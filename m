Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8269EF5862
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255746B008C; Tue, 24 Feb 2026 11:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C9A6B0092; Tue, 24 Feb 2026 11:49:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1014B6B0093; Tue, 24 Feb 2026 11:49:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF97E6B008C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:49:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B27F8C0DA6
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:49:25 +0000 (UTC)
X-FDA: 84479935890.05.AA684F3
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11023083.outbound.protection.outlook.com [52.101.83.83])
	by imf08.hostedemail.com (Postfix) with ESMTP id B5ED916000E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:49:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=G3y1sdmr;
	spf=pass (imf08.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.83.83 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771951762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mSXlske3BWyWhQBdflLyfAu4iTQEfERsuxzd0fAGyc=;
	b=6cnNGCTaL4OwPPJrEG7wcTWs37pxxbPere4jYFlCFYnsFRYHQGLf6MMzlMCi9Fqqi7TyoW
	lbMWbxzwrpOSDP5XY9DgWE/5wjtY/0gE/b8HBT3bxV4WCK//bxs0bzwXMLFjhACFyodgVh
	Kjr53Ekgo6shOHgodKBu+AEUb2auE4E=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=G3y1sdmr;
	spf=pass (imf08.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.83.83 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771951762; a=rsa-sha256;
	cv=pass;
	b=HjZQaGGzFvuzgq9Al62d5BNGY1QyXXdiSnFJV8oT94EH4rPnjnnXSVHceWF0YJQzIc3fqT
	Q8+AxZt+gqGz5/Ep53RnEDzGd5vqcSEfE72JwX1rII1zoweiH6+IrL26imfmdgIqx8T7Zd
	iu5g5tUU+4TAM2iynbx+t733kMfVoU8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ic9a0GzL/4pn6XuCm6Qy+1OMSUJmXzUbYb93dW286vCdzDuBCxhZLubiPL70GAHkNSaDmGCrSg7fFTw51W29bNfDWPqaYojNytNPdlQIkts1GfeZjYLJDK/tGSaRudelW26pmhVVQXRvA2P6CGOX2ExYcX2TgSSwGnSi+4fqR1y3ieQeXEj2GvmOPSwZ5oZQA+3T8/Io2iqfcRFPyd2ZSmXyh56LdJKlLJhd4B1RnczYRsXFqc+mIt5BvFJh1shQSoQej/LYJoV4otFlya/7adVWh7BICeyl29SNZVnffLNJHDjiHszBjl9eN4UFtreUbR3ovkqYfJuEPBmyP/qYOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4mSXlske3BWyWhQBdflLyfAu4iTQEfERsuxzd0fAGyc=;
 b=vr8uqmgWnz4c1C1Djsaf3+cvydefJigKXobsuBrl/cOjZ+H/bJEmT+niA0zcIlOpurAUN7gkTGGXqOglXSK1bJ+a44JNUcu/cXTdBMGQqbaE6SQBoIcypByJv3xWFbZjtDCva8dQsi3cgngKouJCUE3En36JrrPlLDWTFNWALk03uPKm4b44RYpe4dONk1Iiw+hxjeWpkTYgZy3BOC2944ZDDA/mkaXlC1sFT7fvnljsJGknsO5bMy6h8TkNhBAUEadBGeFpVVFaJP+jJDX3jqX7i+0H4xjRZq+eXYQ21J3rvosO7NGZOEfijajZ55OiNFOHMvu1L5eZ4rKna5V+kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4mSXlske3BWyWhQBdflLyfAu4iTQEfERsuxzd0fAGyc=;
 b=G3y1sdmrYt9jJfg1K1ROLWmU22FXFZ6epn8khORq3idSYacEhjXH4tS8Nv11QKuC+4i8W0/sZcM4arU9knw+dYGPIGwoTJov1fboCs0I1ICCI0p8zKTJ/xTLBPQVC+ASeDDaVmpHccOqkRgoCIFalXehTLdLNsSTUvopMFSytafkjWNwqMBPw9xpccgqoZV0+/qjy1hJ29vVK56QMumFPSH/d0bDs/2pJyTbhXuu4HtAE/ezMefTH5MUgEEAMx+eeR8wNSJ99/bKNtChWB8muzaJ5k9lW+AgH1KCVqYgtts7kEo943P9Dr2MPG6ySH44lMxwfdk/lJW4sZOwi/PRQQ==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by DU0PR08MB9154.eurprd08.prod.outlook.com (2603:10a6:10:415::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 16:49:06 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 16:49:06 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>,
	Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v3 1/4] pid_namespace: avoid optimization of accesses to ->child_reaper
Date: Tue, 24 Feb 2026 17:47:52 +0100
Message-ID: <20260224164852.306583-2-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::14) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|DU0PR08MB9154:EE_
X-MS-Office365-Filtering-Correlation-Id: 278e8988-47cd-48de-ca37-08de73c49f89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|7416014|376014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4kWySDFlVUiiasBBTxncKhNiDKTVjalSAgzpMUvmzi8vbRkRa7Kp8YxthjT3?=
 =?us-ascii?Q?XLKFtZYvfvGe8ljyGpcNs8SDKGq8+fljLfI2eZLqfr6/9HaTLcs+k8glV5gz?=
 =?us-ascii?Q?HZJt93S/+635jYSjQUlF93ZiageaofmadkG98oEdNYqmwz0XrYWxV6YgNoIq?=
 =?us-ascii?Q?PZZjQzwUqxrzHtxE0sUbVn5prTUx/esssaH2jMt0d3gzGsgBEvVYdmDNpS6H?=
 =?us-ascii?Q?Css63RCcaBCqgHYMH6L59oN2LBcAfWp8bfZgJhvzGjyWzit0OwEWol2du9XL?=
 =?us-ascii?Q?lkcQ2/3RrtBdAsEamYaG3bt47TA6Q8dMP/M4kc3kl151Aa8K+zEeSxCpOieZ?=
 =?us-ascii?Q?t6jEG4tUOtlVazCpfrkkaYMNhY0B726ZkdBFsCr1LxF31miML/CkXnJkCmxp?=
 =?us-ascii?Q?QR/q8dQeHudA+9665jco019Rx9kl9tQ8Fouil2u2gzbIHtWAoMpeQEx/QPZ6?=
 =?us-ascii?Q?9FpsoUZ+7nUOg5t1AOQMbWu/9Z+V2WsqBmOoiE3TX79ZWLU2HAFGv3RF4Kye?=
 =?us-ascii?Q?06JbqrUd3D519HzR5G5eXrLyzhRvbVqZg+EyTxccaI75XxgN5mzurPUfYuER?=
 =?us-ascii?Q?WAxQXWoVXA1QqUr1r/BEIrlO79jH4QT+ztadi08EI2yM5qjwpbX0GP3tAvWA?=
 =?us-ascii?Q?QQtkV/JtcEDBAORtKMqAaGLECHV2ZYBSJMHLGaciLyRg70BIFTEhPoA7Uuky?=
 =?us-ascii?Q?Yx2Os2kOfEW3AnIyW+g/CQZSPr+UV36e/7fFEDnrdsL2JDBwkmKIGrbQBUgY?=
 =?us-ascii?Q?uyL1gUtQBYvQlVfTFtQQuRyTqJ9q25BfracTM3xEB5jXuVifucoG8totcc0B?=
 =?us-ascii?Q?thzG41/AmCHte3SX4QH696VhAJMKN57Xas3e+T6+F4tdk7plkLpvTrVBlhnf?=
 =?us-ascii?Q?cKRFNMbOHqE0jIXT7sEHoiSbhUfs0jBkPauw3YIB14tZ/Src10yRvDNdmqAV?=
 =?us-ascii?Q?l1Bwv7BiQQKUwcEYs2E2J4SCJpSrliQ/iPfR+EJd5J3IwFisZgxFRaqhQKjP?=
 =?us-ascii?Q?rvRATAAp0VQlNmpKsBmqhm2vVh5TPQWBUwyJbIC3FFs9NW1ghR92TSnAxcT5?=
 =?us-ascii?Q?Zp4lO4zn56tXlOMnT+nYLnGqmmb/BeilNHefl2qe9sVK/5CjizC/8zeFnFrC?=
 =?us-ascii?Q?YVH/V68/Lefq250+V00K0dRX+7JeHOqJ8Uo2x438UIo/GqoLIcGqycAfdiKA?=
 =?us-ascii?Q?yNa07SfBahmFt0VOZb9xEk77TTlBhcRQ2+nBr6drd2qAlXeN6y0oZfg+AVtS?=
 =?us-ascii?Q?I+n+GxAdSCnEUpXg5QI6Zxyud+zKNIneOChH8c2QvZ5OqU8eMXv4Kqrdmq/A?=
 =?us-ascii?Q?jWRVnoBttFjtfr2+1uBNt57aRFEH++2zr6O7gxjUcnVj5In0IfTtT7HJTLLQ?=
 =?us-ascii?Q?zbsFOc6gtjC2FWpuVC+ShwsB/OrxZcXoR2+vLk9q+s8MdXBGZKn0ulqbrqVb?=
 =?us-ascii?Q?h3ug6sB8Vj5M+5Gu2T5e5bn7LquHEUNYUhKoNCmIl+N29aSMX6litRQNuKAL?=
 =?us-ascii?Q?osHPRgwe96lzR0YU5YCJSwLkdfw1YUJxHQdLMc5sW43S+qyNN4HfkY969Vuc?=
 =?us-ascii?Q?Mf5ssOWfypIMEIhjN4s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(7416014)(376014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DLUAvQOYvcisxoxXaeKGGawaLkgNfd1KdwAXndWsqV4OXwKteWZQ4CEv0JUm?=
 =?us-ascii?Q?BQOz0TZl+PTjhr2LdgKBXVDOuEUPzj5rrkkR4B0/fAK3foLaO9rDuBm3Y8m+?=
 =?us-ascii?Q?ZmOoKI9glYzU9p3W8IW2iqjm3w/J36HE8iJKQn6QGFlRoohegpKEN4PMaZVQ?=
 =?us-ascii?Q?JdWxVt2YCsXfL9HPTqehGOBRU4UKM/Gp45jFS0HsvdlvHC+Y2Ibp+8CiWTrp?=
 =?us-ascii?Q?dH7qW5mZjTna7lggiMHWWCPzTLOPPQxEHWofyrYSMl7ETSAM7L89UiNxrHWk?=
 =?us-ascii?Q?OBaOXc94bDsYfD03rCI2emf2rUy6moNv8fV12yEuqbFlmVK0KzCjNc3mQH2t?=
 =?us-ascii?Q?GxdBlt05eknJstSx18U9IE/yHCM+Ji1gNQzvnxWouHRmWe/YW3JNCgXS5E2N?=
 =?us-ascii?Q?bDsMinaIJjs08Zxg9quoSfHTCORTnvVhJYQmMWTebV04EM4tCR2iQJsoxlIP?=
 =?us-ascii?Q?YFKLDCdkEpVnLHni3XWCRNLv34OXC1QO+Jju1rwcxL/CxBr1KZ6p1LjYfHdx?=
 =?us-ascii?Q?0jXTDZeW8/sWiipcJcgtXGpdwcT65PbWq/mzvJIwkCUg4wGDTJJzm94CxL8N?=
 =?us-ascii?Q?uw0HsCrtqeH2USNjTVdlZnVMdQQnruHscj+1TA0gcHY/MRPrZQsQjIyQzo9t?=
 =?us-ascii?Q?rJf6u+TND+swqvOCbHGBdPKy8I+bOTu2B0936qgY0KxWuo/gI3YP7useaaHD?=
 =?us-ascii?Q?e5zxslmEgo0YTqkY70K3paNopjTKYNKVyfn+3zELx55h3XcmSdcGPHxi0dH9?=
 =?us-ascii?Q?Qdb0TtKM33shvHj+jjViv9WeJz67apCw86SKITsWnPxeVZbCWKPwjQ/5M8u5?=
 =?us-ascii?Q?jtqV+YeIiqhd0bIyGEP5o3Ws7KVidbjZCHBuVsfnwfe1Zs0tWowNrHQ1LW2l?=
 =?us-ascii?Q?PTEA8NEa2Eug6uUIBLPKPhfewgal51WYCv1ha/8Qv2O+3YMBC1fGbVFFZUTN?=
 =?us-ascii?Q?CFIC4BcnmvbR8AORiZITsNwJ/BXxK5TwMeRdlM3aqarxhY3n1ulPr7N1hzh0?=
 =?us-ascii?Q?MKHyQXypSS6gUJHWmmGy6DzONn/idvxkY/SKsCQqeaXzOsHfonOzr7i2vbhZ?=
 =?us-ascii?Q?WFIRo/irNOEM+h05jbuZ3APcMcNOxsWU/x9/VxyYvGDqA2njAvqf7nJwHSxi?=
 =?us-ascii?Q?c5EsZc9nUdF3iMtXlE8lGOxXXzEBCZMkipKRFCYkzKYca6QhhCq72gl6KbP8?=
 =?us-ascii?Q?pQpvV1JaUDnLgyEYWOYLfbfOc9UCOtGhUwG7YhOLPHIVpU0qoESJpYesWo7k?=
 =?us-ascii?Q?b63YCHAEnPlWskqDGiN8UEpIwyp3KiHeMLtzTDCEI5gYAMz0x49OUoG0L/Ao?=
 =?us-ascii?Q?dDHYYLcYKDw0S40a4jVS5K5O26feJIqLxrpN4drQCqgrdqp5bxvexnKbZcXj?=
 =?us-ascii?Q?FwKJfZc899A0jD7bTH85T4eiIzCukV7GoG+3z6+SYejWn2/KEvw9qIDazK33?=
 =?us-ascii?Q?u/AwSdKmpb4x1QpXOSzVd8qx120wayPuuoThOUno7U5SYN0GEI9WKsqWSsX0?=
 =?us-ascii?Q?ZzVSS47WS6b9aUocZeuwSOAeg6B713AQF58XjQTynbY174KgTfvjPuetovaS?=
 =?us-ascii?Q?YOt2+HZx9PwaWsI9eLIUD1LIlXMPVTOEpqzxkzv9OgM3ruWHDNOwUDivjxta?=
 =?us-ascii?Q?ME0CXhoA92uVFs0vW/Hc4lCHYG+Ab1RY4CGUQBq4XxcTNn7JivCThb3Ybo0C?=
 =?us-ascii?Q?iHb0XVJCfld37KLO5c91M2zejfrXm93tB+j6kjUEvju/jlcNCE3jjLrZ/vPL?=
 =?us-ascii?Q?IvzCJjKIy7PClESOSrooq2+q3DqN37kxMkoQgWm4+eeRnlGPeRJELJnRnU+N?=
X-MS-Exchange-AntiSpam-MessageData-1: je2w9PJehbq7hlst/w7j26kEKJDHpPzz2wU=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 278e8988-47cd-48de-ca37-08de73c49f89
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 16:49:06.1451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qFxPH9A+Q1P13wIkjwEli2dBstSKvR7GIhRfu8zKEOYVczOchPqro/QBwjCtX1p4oRnLK7EnSgUI/Qh3Q09UBSkRE+lB0y1RvNVD5sYxT2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9154
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B5ED916000E
X-Stat-Signature: xw74yszs3bzyotzj8c9fo3nrp6xie771
X-Rspam-User: 
X-HE-Tag: 1771951762-181583
X-HE-Meta: U2FsdGVkX19qbl+h5GB6T1cREt+nSjEuKn8iEREQDgVNDydsvaiQPmXFRTTpPV/l8zwZRbqBGZT5kYcHm5SpO+SVjXo/d1Tuu4pgwxWknT1IvQw4IxdUQTKir9o442jcER85NHdzPikKiVjHAuDOoNxl303stbEsI7XI1QilnO9Y+8csqU+ZQSEcWwEgIfeIg/5ZtdkafX12ZN1Z3W7IMdbPmMTjYoT87f/2SZkLNU/hfDXyZcs09jsbK6SJ0TcnxGGyVQpEEYAsd5MLDxSu4PErvCIfpcHeUniU49rowJ80KKUJkYdfjiPhC9X5r1gjOqOOabuW5uxs7421yDP6zBOU9i1j0zFnBp9+SEbIckWJ/sqErIz0tVLZz2tq1Ae8FO2HKh0CdlSa+j3U87ZlHDBPPYdOo0zeTNuyCZjHM9fGv00XckfzI6NFny/ikpM/DFscVlTQ4wMpVijJs6GTgjq2y2XtOWWohvUy6GYCFwVwNJr5X9Nz9iM4JO+C5rFcb0wGDXnvIXBdWWTGt7LVKm16NW5WxB42G6d3QqJ7w/P3Om/50c9HIeQFOpNUXohRCvBbb0I3OQ1DiYSc0cj+M03fV+AKmoST6biLl/xnMbj6Th5EF/KZeJJeq4iY9wrDgyFDh6l0b1UwOVhRNquklOJhraSOkNJCpc4/RfmVXctpmBIIt5My7q4ogECqdmsevs2/CTiSrsGZdidvF3oSvHtKob9KL6wIDEJLP41AiDUHevcUQA1pNu/CXsMaxQM64KvogBoYVx1yeZnZxSohdgngL+7uZ+xbWWCQhHGRU+NcWylmjt3gyKD0m/r3t9gEG0tAp+zurwe2FXphQcv8dVG5R9+MgUhq4KkXd8JqTyVYbWj4J8hoFaMoZ7yFi714rBb17ZR23+cb7jAAkvVpYYtdmcO6RFoK2QQD/rF8gRZnn+kWpSqH/E5IDWj0dIvYXtY3Gcsd60bFPVySTEO
 L2IEU4Al
 MEQ7joWT95jqzRLpko9su9Mq6iAxO2m0qme8650UjlpjX2dWZn8aVSatEQDF9n1ILShrvkm3kOMECkChvfQ6YP1bf5a9iwsvguACo/di8NxAqsx9xNNSl7CiIN2MUPA8XOd0PMNXK6j7euwl7gm5sKwq7/o3rxNlgosVK025jPkNpm+3is3jyMxFU/qzO/SFxPwA66/eNbWdalheXVd2nm0u+OlYwbldrW7ziMdUAtUhz910zr4QgqhTnAtWmTbFgEz0AkdA8B7hmupIPmydeZESZ4r5RMY27Bz6yN9NYig+RUTRtj1npY9ya5lroY1q+RhCYNzw5BI6dQ69BOa7C+T/Pvi8nOqSnUvthITRJQ4bbEVEHxerplqC9lI3XD4lTFZrZjXFAq7hyRN0fiAQUPunkDUE6xOQbTvO4asmCeqX3UnhxcHNxd6XDmo2q5KGaejzqNmkbFRlf6vFcy4XwxT4m9iw3kPmBEcrBi7ultgd9CByWp61f57XQ29kwtM0gA/bE2w1rYDF2JyZnSWfyICUPYTg5WqOgk+O3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To avoid potential problems related to cpu/compiler optimizations around
->child_reaper, let's use WRITE_ONCE (additional to task_list lock)
everywhere we write it and use READ_ONCE where we read it without
explicit lock. Note: It also pairs with existing READ_ONCE with no lock
in nsfs_fh_to_dentry().

Also let's add ASSERT_EXCLUSIVE_WRITER before write to identify to KCSAN
that we don't expect any concurrent ->child_reaper modifications, and
those must be detected.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
--
v3: Split from main commit. Add ASSERT_EXCLUSIVE_WRITER.
---
 kernel/exit.c | 3 ++-
 kernel/fork.c | 5 ++++-
 kernel/pid.c  | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 8a87021211ae..8e5e523dcc79 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -608,7 +608,8 @@ static struct task_struct *find_child_reaper(struct task_struct *father,
 
 	reaper = find_alive_thread(father);
 	if (reaper) {
-		pid_ns->child_reaper = reaper;
+		ASSERT_EXCLUSIVE_WRITER(pid_ns->child_reaper);
+		WRITE_ONCE(pid_ns->child_reaper, reaper);
 		return reaper;
 	}
 
diff --git a/kernel/fork.c b/kernel/fork.c
index e832da9d15a4..9ce2d12ec701 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2423,7 +2423,10 @@ __latent_entropy struct task_struct *copy_process(
 			init_task_pid(p, PIDTYPE_SID, task_session(current));
 
 			if (is_child_reaper(pid)) {
-				ns_of_pid(pid)->child_reaper = p;
+				struct pid_namespace *ns = ns_of_pid(pid);
+
+				ASSERT_EXCLUSIVE_WRITER(ns->child_reaper);
+				WRITE_ONCE(ns->child_reaper, p);
 				p->signal->flags |= SIGNAL_UNKILLABLE;
 			}
 			p->signal->shared_pending.signal = delayed.signal;
diff --git a/kernel/pid.c b/kernel/pid.c
index 3b96571d0fe6..76c2744493e2 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -219,7 +219,7 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 			 * Also fail if a PID != 1 is requested and
 			 * no PID 1 exists.
 			 */
-			if (tid != 1 && !tmp->child_reaper)
+			if (tid != 1 && !READ_ONCE(tmp->child_reaper))
 				goto out_abort;
 			retval = -EPERM;
 			if (!checkpoint_restore_ns_capable(tmp->user_ns))
-- 
2.53.0


