DROP SCHEMA IF EXISTS `afoh`;
CREATE SCHEMA IF NOT EXISTS `afoh`;
USE `afoh`;


# SET foreign_key_checks = 0;

CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(256) NOT NULL,
  `password` varchar(256) DEFAULT NULL,
  `profile` JSON DEFAULT NULL,
  `created` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `flags` SET('guest', 'admin'),
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `user` (`id`, `email`, `password`, `profile`, `flags`) VALUES
(1, 'guest@localhost', NULL, NULL, 'guest'),
(2, 'admin@afoh.info', '$2a$10$z/q611pNv/WSgAIntOQ6Meow8d6QDZW73MlDKiEJ/5KPI3jAzZ912', '{"name":"Ari R Asulin","description":"g ssgffet &lt;br>omg &lt;hr>"}', 'admin'),
(5, 'ktkinkel@gmail.com', '$2a$10$9rknzN/XYtGJpyELSnA/3.2TEniFIlMDFsT4oNg3JceJV04crc6rm', NULL, 'admin'),
(6, 'ari.asulin@gmail.com', '$2a$10$TAG1S.apbF2rr1nKstYj5.n1caQ1Wj2q188sw2QCcLrAIs9K9vK3K', NULL, 'admin');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;



CREATE TABLE `user_session` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `uuid` varchar(256) NOT NULL,
  `password` varchar(256) NOT NULL,
  `created` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('reset', 'active', 'inactive') NOT NULL,
  `session` JSON,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk:user_session.uuid` (`uuid`),
  CONSTRAINT `fk:user.user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




CREATE TABLE `article` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `path` varchar(256) DEFAULT NULL,
  `title` varchar(256) DEFAULT NULL,
  `content` TEXT DEFAULT NULL,
  `theme` varchar(256) DEFAULT NULL,
  `flags` SET('logged-in-only', 'logged-out-only', 'admin-only'),
  `created` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk:article.path` (`path`),
  CONSTRAINT `fk:article.user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELETE FROM `article`;
/*!40000 ALTER TABLE `article` DISABLE KEYS */;
INSERT INTO `article` (`id`, `parent_id`, `user_id`, `path`, `title`, `content`, `theme`, `flags`, `created`, `updated`) VALUES
(1, NULL, 2, '/', 'Home', '\r\n<section class="highlight box-shadow">\r\n    <ul class="flex-list">\r\n        <li>\r\n            <h1 class="themed" id="activities">Welcome to AFOH!</h1>\r\n\r\n            <p class="themed">\r\n                AFOH provides several directories of shelters & housing, food banks & kitchens,\r\n                as well as directories for local homelessness programs, services, and organizations in the Valley.\r\n\r\n                AFOH performs outreach at various locations in the Phoenix Valley on a daily and weekly basis.\r\n                Click here for more info about our outreach routes and schedules.\r\n                AFOH on Facebook is a hub for the Phoenix Valley to connect on homelessness issues,\r\n                find opportunities for kindness, and for the homeless to access programs they need for shelter and resources\r\n            </p>\r\n        </li>\r\n        <li>\r\n            <img class="box-shadow float-right" src="file/image/food_supplies1.jpg" alt="Service To Others">\r\n        </li>\r\n    </ul>\r\n</section>\r\n<section>\r\n    <div class="page-quote">\r\n        "The best way to find yourself is to lose yourself in the service of others."\r\n    </div>\r\n    <ul class="flex-list">\r\n        <li>\r\n            <a href="file/image/food_supplies2.jpg" target="_blank">\r\n                <img class="box-shadow" src="file/image/food_supplies2.jpg" alt="Homeless Resources">\r\n            </a>\r\n            <h2>Homeless Resources</h2>\r\n            <p>\r\n                AFOH provides several directories of shelters & housing, food banks & kitchens,\r\n                as well as directories for local homelessness programs, services, and organizations in the Valley.\r\n            </p>\r\n        </li>\r\n        <li>\r\n            <a href="file/image/service1.jpg" target="_blank">\r\n                <img class="box-shadow" src="file/image/service1.jpg" alt="Local Outreach">\r\n            </a>\r\n            <h2>Local Outreach</h2>\r\n            <p>\r\n                AFOH performs outreach at various locations in the Phoenix Valley on a daily and weekly basis.\r\n                Click here for more info about our outreach routes and schedules.\r\n            </p>\r\n        </li>\r\n        <li>\r\n            <a href="file/image/bears1.jpg" target="_blank">\r\n                <img class="box-shadow" src="file/image/bears1.jpg" alt="Social Media Hub">\r\n            </a>\r\n            <h2>Social Media Hub</h2>\r\n            <p>\r\n                AFOH on Facebook is a hub for the Phoenix Valley to connect on homelessness issues,\r\n                find opportunities for kindness, and for the homeless to access programs they need for shelter and resources\r\n            </p>\r\n        </li>\r\n    </ul>\r\n</section>', '', NULL, NULL, '2019-01-10 04:43:48'),
(2, NULL, 2, '/about', 'About Us', '\r\n<section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">">\r\n    <br/>\r\n    <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n        <h2>About Us</h2>\r\n        <p>\r\n            It\'s all about the homeless. From local to nationwide and elsewhere, our focus is on homelessness issues and coming up with solutions with the local community.\r\n            Arizona Friends of Homeless is a non-profit 501c3 organization which serves the homeless through daily outreach, connections\r\n            to local services, shelters, and programs, and provides awareness to the general public, members, advocates, donors,\r\n            and volunteers on homelessness issues for Arizonans. Arizona Friends of Homeless hands out\r\n            food, clothing, blankets, towels, hygiene packs, ponchos, socks, back packs, bikes, shoes, pet food and more\r\n            relief items to the homeless at various locations within Phoenix where need is great.\r\n        </p>\r\n    </div>\r\n    <br/>\r\n    <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n</section>\r\n<section>\r\n\r\n    <h2>Who We Are...</h2>\r\n\r\n    <br/><br/><br/><br/>\r\n\r\n\r\n    <h2>What We Do...</h2>\r\n\r\n    <ul class="flex-list">\r\n        <li class="box-shadow" style="margin: 4px; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n            <br/><br/><br/><br/>\r\n            <div class="highlight box-shadow" style="padding: 1px 1em;">\r\n                <a href="/outreach">\r\n                    <h3>Outreach</h3>\r\n                </a>\r\n            </div>\r\n        </li>\r\n        <li class="box-shadow" style="margin: 4px; background: url(\'file/image/service2.jpg\'); background-size: cover;">\r\n            <br/><br/><br/><br/>\r\n            <div class="highlight box-shadow" style="padding: 1px 1em;">\r\n                <a href="/resources">\r\n                    <h3>Resources</h3>\r\n                </a>\r\n            </div>\r\n        </li>\r\n        <li class="box-shadow" style="margin: 4px; background: url(\'file/image/service3.jpg\'); background-size: cover;">\r\n            <br/><br/><br/><br/>\r\n            <div class="highlight box-shadow" style="padding: 1px 1em;">\r\n                <a href="/projects">\r\n                    <h3>Projects</h3>\r\n                </a>\r\n            </div>\r\n        </li>\r\n        <li class="box-shadow" style="margin: 4px; background: url(\'file/image/service4.jpg\'); background-size: cover;">\r\n            <br/><br/><br/><br/>\r\n            <div class="highlight box-shadow" style="padding: 1px 1em;">\r\n                <a href="/social">\r\n                    <h3>Social Media</h3>\r\n                </a>\r\n            </div>\r\n        </li>\r\n    </ul>\r\n\r\n    <h2>Get Involved...</h2>\r\n\r\n    <ul class="flex-list">\r\n        <li class="box-shadow" style="margin: 4px; background: url(\'file/image/help1.jpg\'); background-size: cover;">\r\n            <p class="highlight themed">\r\n                AFOH is a hub for volunteers to find their niche. We believe that everyone can and should be allowed to help in some way.\r\n                Current Needs: Sandwich helpers, Mesa outreach, goods transportation.\r\n                Contact: Mike Atanasio\r\n                <br/><br/><br/><br/>\r\n            </p>\r\n            <div class="highlight box-shadow" style="padding: 1px 1em;">\r\n                <a href="/volunteer">\r\n                    <h3>Volunteer</h3>\r\n                </a>\r\n            </div>\r\n        </li>\r\n        <li class="box-shadow" style="margin: 4px; background: url(\'file/image/help2.jpg\'); background-size: cover;">\r\n            <p class="highlight themed">\r\n                AFOH is a non-profit, charitable organization. Every donation is utilized or spent on our homeless outreach efforts.\r\n                Current Projects: AFOH Motor Home, AFOH Wash Morning @ Social Spin, Amazon Wishlist (ship donations to our door!)\r\n                Current Needs: gloves, hats, blankets, shoes, socks, hygiene items, winter items.\r\n                Contact: Mike Atanasio\r\n            </p>\r\n            <div class="highlight box-shadow" style="padding: 1px 1em;">\r\n                <a href="/donate">\r\n                    <h3>Donate</h3>\r\n                </a>\r\n            </div>\r\n        </li>\r\n        <li class="box-shadow" style="margin: 4px; background: url(\'file/image/streets18.jpg\'); background-size: cover;">\r\n            <p class="highlight themed">\r\n                Learn about homelessness issues in Arizona with AFOH on social media. Locals can connect to organizations, events, or share their own in our Facebook group!\r\n                Current Pages AFOH, AFOH Issues\r\n                <br/><br/><br/><br/>\r\n            </p>\r\n            <div class="highlight box-shadow" style="padding: 1px 1em;">\r\n                <a href="/social">\r\n                    <h3>Your Voice</h3>\r\n                </a>\r\n            </div>\r\n        </li>\r\n    </ul>\r\n</section>', '', NULL, NULL, NULL),
(3, 2, 2, '/service', 'What We Do', '            <section>\r\n                <ul class="flex-list">\r\n                    <li>\r\n                        <h2>Local AZ Outreach</h2>\r\n                        <p>\r\n                            AFOH performs outreach at various locations in the Phoenix Valley on a daily\r\n                            and weekly basis. We provide food, clothing, hygiene kits, referrals, maps, and more.\r\n                            Click for info about our outreach, activities, routes, schedules, and ways to help!\r\n                        </p>\r\n                    </li>\r\n                    <li>\r\n                        <img class="themed" src="file/image/service1.jpg" alt="Local Outreach">\r\n                    </li>\r\n                </ul>\r\n                <ul class="flex-list">\r\n                    <li>\r\n                        <img class="themed" src="file/image/clothes2.jpg" alt="Local Outreach">\r\n                    </li>\r\n                    <li>\r\n                        <h2>Social Media Hub</h2>\r\n                        <p>\r\n                            It\'s all about the homeless news, topics, and events. From local to nationwide and elsewhere,\r\n                            Arizona Friends of Homeless focuses on homelessness issues, providing a forum for like-minded\r\n                            individuals with giving hearts to spread awareness and come up with solutions together within\r\n                            the community. We host and notify of upcoming events and opportunities for giving and proposing\r\n                            solutions with individuals and organizations in need. Anyone can join!\r\n                        </p>\r\n                    </li>\r\n                </ul>\r\n                <ul class="flex-list">\r\n                    <li>\r\n                        <h2>Resources Directory</h2>\r\n                        <p>\r\n                            AFOH provides several directories of shelters and housing, food banks and kitchens, services and programs,\r\n                            as well as lists of known local  homelessness groups, organizations, programs, and services in Arizona.\r\n                        </p>\r\n                    </li>\r\n                    <li>\r\n                        <img class="themed" src="file/image/streets23.jpg" alt="Local Outreach">\r\n                    </li>\r\n                </ul>\r\n                <ul class="flex-list">\r\n                    <li>\r\n                        <img class="themed" src="file/image/streets3.jpg" alt="Local Outreach">\r\n                    </li>\r\n                    <li>\r\n                        <h2>Personal Support</h2>\r\n                        <p>\r\n                            AFOH Issues is our Facebook Group for homelessness needs, issues, and requests, as well as\r\n                            missing persons posts, and personal opportunities to support a person in need through acts\r\n                            of kindness, or just provide information or give moral support.\r\n                        </p>\r\n                    </li>\r\n                </ul>\r\n\r\n                <ul class="flex-list">\r\n                    <li>\r\n                        <h2>Teddy Bears Project</h2>\r\n                        <p>\r\n                            Arizona Friends of Homeless regularly provides shoes, bikes, and teddy bears to the\r\n                            homeless in Phoenix. We believe in equipping the homeless with tools for mobility,\r\n                            as well as recognizing and giving voice to their issues. AFOH strives to acknowledge\r\n                            that all people are free and equal in dignity and rights, and that a little kindness\r\n                            and respect goes a long way on the street.\r\n                        </p>\r\n                    </li>\r\n                    <li>\r\n                        <img class="themed" src="file/image/food_supplies15.jpg" alt="Local Outreach">\r\n                    </li>\r\n                </ul>\r\n            </section>\r\n', '', NULL, NULL, NULL),
(101, 2, 2, '/resources', 'Homeless Resources', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', '', NULL, NULL, NULL),
(102, 101, NULL, NULL, 'AFOH FAQ', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(103, 101, NULL, NULL, 'Homelessness and Crisis Directories', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(104, 101, NULL, NULL, 'Groups, Outreach, and Organizations', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(105, 101, NULL, NULL, 'Foodbanks, Kitchens, Medical, and Other', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(106, 101, NULL, NULL, 'Shelter and Housing Directories', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(107, 101, NULL, NULL, 'Women\'s, Youth, and Domestic Violence', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(108, 101, NULL, NULL, 'Pregnant, Post-partum, and Family', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(109, 101, NULL, NULL, 'Single Men\'s Shelter, and Housing', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(201, NULL, NULL, '/projects', 'AFOH Outreach / Projects', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(202, 201, NULL, NULL, 'AFOH Central Phoenix', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(203, 201, NULL, NULL, 'AFOH Chavez Park', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(204, 201, NULL, NULL, 'AFOH Motor Home Project', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(205, 201, NULL, NULL, 'AFOH Wash Morning @ Social Spin', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(301, NULL, NULL, '/contribute', 'Contribute / Volunteer', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(302, 301, NULL, '/contribute-donate', 'Donate!', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(303, 301, NULL, '/contribute-volunteer', 'Volunteer!', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(304, 301, NULL, '/contribute-amazon', 'Amazon Wishlist', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(401, NULL, NULL, '/contact', 'Contact Us', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(402, 401, NULL, '/contact-facebook', 'Facebook', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL),
(403, 401, NULL, '/contact-email', 'E-mail', '\r\n            <section style="position: relative; background: url(\'file/image/service1.jpg\'); background-size: cover;">\r\n                <br/>\r\n                <div class="highlight box-shadow" style="margin: 4em; padding: 1em 2em; text-align: justify;">\r\n                    <h2>Coming Soon</h2>\r\n                    <p>\r\n                        Check back soon for more updates!\r\n                    </p>\r\n                </div>\r\n                <br/>\r\n                <span class="text-bottom-right highlight">\r\n                            "Poverty is not a fate, it is a condition. It is not a misfortune, it is an injustice."\r\n                        </span>\r\n            </section>', NULL, '', NULL, NULL);
/*!40000 ALTER TABLE `article` ENABLE KEYS */;


CREATE TABLE `article_revision` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(256) DEFAULT NULL,
  `content` TEXT,
  `created` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx:article_revision.article_id` (`article_id` ASC),
  KEY `idx:article_revision.user_id` (`user_id` ASC),

  CONSTRAINT `fk:article_revision.article_id` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk:article_revision.user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `file` (
   `id` int(11) NOT NULL AUTO_INCREMENT,
   `user_id` int(11) DEFAULT NULL,
   `path` varchar(256) NOT NULL,
   `hash` varchar(256) NOT NULL,
   `size` BIGINT(11) DEFAULT NULL,
   `content` MEDIUMBLOB,
   `created` DATETIME DEFAULT CURRENT_TIMESTAMP,
   `updated` DATETIME DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (`id`),
   UNIQUE KEY `uk:file.path` (`path`),
   UNIQUE KEY `uk:file.hash` (`hash`),
   CONSTRAINT `fk:file.user_id` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



CREATE USER IF NOT EXISTS 'afoh'@'localhost';
GRANT ALL ON afoh.* TO 'afoh'@'localhost';