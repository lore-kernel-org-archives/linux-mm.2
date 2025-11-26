Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD7EBD1037B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 03:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12EDC6B000D; Tue, 25 Nov 2025 22:50:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107086B0022; Tue, 25 Nov 2025 22:50:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F10D86B0023; Tue, 25 Nov 2025 22:50:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE1866B000D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 22:50:20 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67663C049C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:50:20 +0000 (UTC)
X-FDA: 84151380600.12.2A48A4A
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011019.outbound.protection.outlook.com [40.107.208.19])
	by imf30.hostedemail.com (Postfix) with ESMTP id AA42080002
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:50:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N8ftfp26;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764129017; a=rsa-sha256;
	cv=pass;
	b=LJ1KC1J4BEGyh52P7YbGg8EojSYr33run2OLMjQWO5u56e+WWDDSgLpsbo5RhuNZbVvucI
	lWAdc/JwOMYc9yLl5cbuynwBHyuIIs1knZEd9lWD1dFoC1DBcJL8nkFGNMWfOQ7+HKyCds
	Bevk3sp7EeUBYvFQiEmsIsmuJ1RBQaw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N8ftfp26;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764129017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Og0jfuk03VRol/DXSo702cO/LBwjgkAYunyJ9w7e4n0=;
	b=xFn0maYHGCX6ZDmkarRcZnnL9b//8lpDcbVgJzRM+XBB1uTcw3xjTOtyppFU5lxp+PJK3P
	mabkV/1gE9boYpkw2ZIYK6DHQ8c17ZLmUv66vcJ/HSs/2vz2No8E1wJavR9axyIrGaFzZM
	u9XtCufiiGv5M7xNwCSP7f5vt/Lg8Q4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fuHuN/ZBiNsnDV9zLydswC09MIif0FW2AOB94MfN6wl5VdbbVb6uiZInSyOK0TZlcXSxKDmhF7z+ftzmjBEOAgidONWSn29LCnb9Feq+HnqV6ajsNjMI1Bq/8cwJaaiB7ZJLadVIpKDOcA1xotMonwI7eUrHl359mdkObIpil3bYIg5l8GF27rRvOB9ofXv7JP9/rRqcVytJ1tQo7N6UsH6liMukv25++hPsBaPyNtg9tichTR1VEGqOCjIga7OwgmuEPbGocDxQu4IePcLo7ygxrrrH9N/JcpeA94PdEHn2K6oN3Niu/BWhYnOPoijQQoMSGHUm5JXYxvO8PShwiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Og0jfuk03VRol/DXSo702cO/LBwjgkAYunyJ9w7e4n0=;
 b=eko0KpTEwYoIv2GOw8q/yPo7aWku+AsZG8QxXmKvbU0Kb5kjl+rh3w42Hm5XXD/Og6TZ9wJhGcXXP8kQAzq+HjQXiSgpaXaOv48rObSQmrzWalOOiWZF59yc38eJCWkolYzeS/TxrbR23whLM4DMnatUhvedJH+nea37p0hGCEwBb0jPNQlUsDtZNItkazpm12S2mPTvaT5CEdk7FyC31nU0g9SsZiNPkhK0WyT7csV/Vtgt+nvx10OWy4h9ZQEGlpbpQuszyHCyoYMhqcm95y3c2EDmFMpClyMKA5ilDaFQicmEE/i3Llf9YAxgrZpLC3xOBvaedCfI2cEJ3ImFhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Og0jfuk03VRol/DXSo702cO/LBwjgkAYunyJ9w7e4n0=;
 b=N8ftfp26+fl8pla1UlHhx/LqjwPvgesIDP4Q0qCXy5m+hs91+r4Lwsrx+7Dut98HAyS11J8uh+zXf/+3sgK4JEHQvY8eDH12PspsahZD/4nxITBddbMFmDtjp0ZUDOhW+bGy4hIdEXzoGSYsxVeb7MjN6tI6G9G+PGB2qieVksN23OT78wepRrohlWYkMD7aaNdONs4fANRFfd4EPBIyvGA/FXzpAbWEKk1i/wOPLwQ3lyMIb3AmK8lVT3LCHUYCaOZXXV4vPjVw/GmBlFRyFwsd2VaVhWQCF6AwgyRtYoA2/EZh7LWYIJG0RDOpRA8UZ8OAonavGh+hn6pndqYLuQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV9PR12MB9782.namprd12.prod.outlook.com (2603:10b6:408:2f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 03:50:14 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 03:50:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] Improve folio split related functions
Date: Tue, 25 Nov 2025 22:50:04 -0500
Message-ID: <20251126035008.1919461-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:208:91::40) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV9PR12MB9782:EE_
X-MS-Office365-Filtering-Correlation-Id: 61114ea9-a94f-4357-4e09-08de2c9ee7db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ANruWOWssmQcPOiKL48bIcVMfMmbf7PQYbn6smnGkUaRg1T9ufGnSMKKw0fu?=
 =?us-ascii?Q?tTDWmjgmI9uvGHhlfVw4S1cD6gfvlMTMAKZKdQ001SnuN1BP51Q60JTxYgx5?=
 =?us-ascii?Q?mkYzWi82PJ0ODlc04dXJPg7Fo0GrtzY+omoGMSz64Ghg4iVE2uMM3Z8NZiLh?=
 =?us-ascii?Q?hgtkLn5u/eKtA6AHV5FIsAngKaIAQHoWBk0ntAJMsXL7TY9uzJHEB1WOSAFx?=
 =?us-ascii?Q?+XaTM7z6BKSFpXs31eB/zFdlfhEHC+yVNrq4ER63ljMQHhzANM66dDJbWn1K?=
 =?us-ascii?Q?Hoe75MF7+1jj/b2jihXpCD1oq/UHmmltdyKTD4pFpVCQsMzYXRxvRFJKO+kw?=
 =?us-ascii?Q?QEQvj6uJ0f+E+Xhmju6vGoxaGNufl/Lswsh8+nJFFDuoI70yraFlU8Clxzrd?=
 =?us-ascii?Q?CEc+JYX59uUYQ7NgBEpj+q2YEdBbe6KoDaxgwmU6c2Ncor5ozNWnE5iMIFvI?=
 =?us-ascii?Q?49tXQShh7eHawmgz51BA9MryHAU3lGcGJuJihI20nhuPimV4MCmsko7xCwC7?=
 =?us-ascii?Q?vlQzcwRVHNVHEPHAIkL4OLAtYBlCEJs4IIOZjNWlbcoeSXSnJoo5Pz+4IYG9?=
 =?us-ascii?Q?uROkKLOTlFIwOYG7fXI5Z2tsMm3jqVjeX4YBnbgM7DHT8HEniJ6DODtnSQie?=
 =?us-ascii?Q?canR2c/WVUzYOWh0xY2pte1pUD+sxU3vSHkMTbXM1CAUFvAXonounQ5+c87d?=
 =?us-ascii?Q?xXExoO0RqTMMVfFFUmDNKFwB7yy+VxSg1Zm87j/qbSNzVgr+5REjlrzY2VfE?=
 =?us-ascii?Q?lCZreT/vorIIh1Z/De0rwd3+f0Jogg3Abyz/IvWWfDJVKYg6hXb9Q1ea0PjH?=
 =?us-ascii?Q?4oX280WGaZHLka33nKuh2F2qBdgyHQBMBdO/zxHd6S/hMhD4zE63jHJBHfnJ?=
 =?us-ascii?Q?V1X9L88qj0mGRQUYxqOVDq/mDpi3n4T7JwDdN29lyGV7EPlTHEcL4jkzbog+?=
 =?us-ascii?Q?ltvGBNPTbEBPUnVg7w0bF0fQmE68j0YG8jVXVYgUsUONkQhRuumHOK2bb9AR?=
 =?us-ascii?Q?CEmBMZMbBQNLvIb0Op0TUlw6IGR+89GIf+EeZ97oQgrp2y6BPFwfU/angv3n?=
 =?us-ascii?Q?NQMxZh0a2x0wyDnyeiNgd+oc0lw8YbqGyT3J+SkhpJbeuKlC3IOi9eHWtvlp?=
 =?us-ascii?Q?VP1mlCipUqgxZb2fz4/sGwOkyU6Je2go8sKM7s6HmrrgTZ45ofWaKuivlGvD?=
 =?us-ascii?Q?/VdsDuP9YIHqRMHJ3RS0Hpny61o9VfmFt3/w34Vmkq+9shoDdDLHtNFywfKa?=
 =?us-ascii?Q?MK14z51xI6HWzRe1I09mhSv2BClFtXyNey6Sm2+6U/hPDUic7MDAwKA9Blk3?=
 =?us-ascii?Q?R1AJp362JaQlVb9ve8kyLIqRIrBvq+rpp03G7+V3cWZH1Hr9GMq4G5TnaJn6?=
 =?us-ascii?Q?AbTmjEGmrW5QjyGOlkVMHFyfnbfYjayAwSuC41yesg9RvNQors8FIJuGoejb?=
 =?us-ascii?Q?3RRPOOtESUd+vDn5MfgHSiaUriuEcn8u7a//3nQj/0D3MmVWFjLRGQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mbBeJYaQgHYbvQclvuR1QDx7ecx9yHv6M6IUdFaPvWUYE0Mey11K+FlqKNE5?=
 =?us-ascii?Q?NpD7yVTid5uzNN9hxPFZP91N9WKiBJ5zSu+Rpf2w3KKVjRX0HwDi5oa4I/8K?=
 =?us-ascii?Q?ec+P3eoD4A36gIKu2MZJAl7fqqCTaL9VlTl70+G8/XSZrN8W83+6hglsD7aE?=
 =?us-ascii?Q?/IkeZQKgmOmBnWCk8vXlseWOqWbKs9VNsuON6mOZdOWxSD1Y8koxsUuvjMxS?=
 =?us-ascii?Q?8F+kRxfWEFg8QQakPeGuOMIOYqPnha8vaEnLhl96Bmut48HSBX59WVgzbhXE?=
 =?us-ascii?Q?vRFzdLEdZCeVB7u/wG+TvcWMB1RtVjQBHhbGKIF+Y0UPlpCPzbMU7jWzl+p9?=
 =?us-ascii?Q?Dhyg/UGLbGLElkaPlIeFm4jwanEaZLL2BRXEygcVaNBQ4Cs6ahhwK3/BDYfU?=
 =?us-ascii?Q?/CnGrIFlQSvOchKJgKgNYWT+vNeTNTKLnNetKOdrEOuKwB0kKg4N8K0Z0gsF?=
 =?us-ascii?Q?tiyYbeB3Awy24fm5yapzQPFVEvMKzxrKTegMqiDivQvB1UuhZUZ7iHh7lMqe?=
 =?us-ascii?Q?K/+zhN1Gss1a9uF6SJLtT4N9rWm7E4j9LwsiG7HMc3GU7gz82DuZmNdSOkRY?=
 =?us-ascii?Q?bc9sGpF4GKXgdp2Eq/ISE2xcg0oIApWAJ9zKIECS+4OHq6wcK7DuKdjTrLih?=
 =?us-ascii?Q?thU1wmVDXtEssqWBZnuX9DQCELwQg4hbseNyLMCI+p4x7MqWAkqgFHcPdBIl?=
 =?us-ascii?Q?1HrrIEPEvGJqYEy7/JGBFMX3DJzP9LmQaEk4XnatBellzMDSCoUPjCMwvPmS?=
 =?us-ascii?Q?RApbwxBCPWOyM28UOVP3bMmmGAvCxX8PqMmxvnO6nvZqwqXWVqZoTtaU/F7A?=
 =?us-ascii?Q?eEwUdol7Em5umTJY9uBlFtVxn5NAJkod67M8dvCEMfpRXbdaRTSu9BiwMoO1?=
 =?us-ascii?Q?95PYiMioJxK2/YxIJN66a4xZSll3vO5JDGY+neteD9h7qF/oMnZY+opRGJjj?=
 =?us-ascii?Q?l7m1jG4uRpXANLSsG5spZC9k093Q2j/tw7SATCHYu5Y66CZqJYYtaqgNZHIU?=
 =?us-ascii?Q?viI5SaHuvj06XQoe3l8KCacrGq16g6dRdMC2ae4g9QxyyUMzO+/WMi+ZSRVQ?=
 =?us-ascii?Q?NbuEzY4CT4jKp18afGCvL4utAbZZ/OkkUVDIsOqgCp1gUnxmeT5vS1ghjvE0?=
 =?us-ascii?Q?eVZfCwfsjGq5yrPYNQTDtHwK3S8ZnxrgVW3j3bnixW1INL5DwmCLlixSd9jr?=
 =?us-ascii?Q?LIP+NycIqHNZXAK5oIVe3b5EeGUGKR2csMpHEik3N3wosoxPe4NZk6OY5q47?=
 =?us-ascii?Q?mURITKjtKqbfFCmx11yEMwbmHQLclOV4R6so/8ednF45RxNiu0gF2+fPjiRC?=
 =?us-ascii?Q?oCXRy+fZa7MflEz/RSxZS5n0xzJoluvYaaAB1bWq7aDH6zPEprclnR0I2/R1?=
 =?us-ascii?Q?EyXjoQdbQQhGW/h2hUHTqK55Ea8Lo8wW6goZJD6/jN6BuTXMC5aiglCpUxs3?=
 =?us-ascii?Q?dGuG7wxMAowJmQw5G2uH4xmTvCFTtHL+GZET/eS3+yNjQVSDTxKMTU7zuB+K?=
 =?us-ascii?Q?vnYUGug2jdTETVoJIZeP4zrCt+eM7S7+PtFZRINooaO8ih2Q5jOy0XpdwLCg?=
 =?us-ascii?Q?X5apQfBq9Uh6yGqQbsDvZ0EU/P5GEkPMOq9fN4zs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61114ea9-a94f-4357-4e09-08de2c9ee7db
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 03:50:14.0819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BNVEWKrUXOPAH8t6W0iD8uItzpDSOl+/phT19EtI+KmsePmYwb9lKZ0uGj9MjXL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9782
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AA42080002
X-Stat-Signature: dqxfetrj1fgbqrpipb4yjbdz9mnsjc6k
X-Rspam-User: 
X-HE-Tag: 1764129017-25266
X-HE-Meta: U2FsdGVkX1/kNBcQguG3IlFDpVcqyvAv3DoYB4Z//n+ftXyKcY/FTH2wsyuatuL+xIgtajK15y6WkDdXJSeJ5kiHVvwCu8qBZQxxS78ux9qlhpVrYDILH6wOyYL0pIBlraykKZYdRgMxrRivgn9L54OJ/RTsBwsVffLNHLPhcko4MGHEX9bTsLz4FJJagD5pnPBWwxoaLiNthOVUOcK6xJ6FMWa5pxj9ODO3U7F11lMMtQ5sxxIxTCQbrmTUmGbSunf3pv9WEtgDb2ic59Z8we8chARf7Z+ebxduMXIQpMFAeZuiHCWc4wGG/NBJjuJ58Jj0ksyPSlJG1F+O1mJ2WqBgR9cgx4lal3zntZQpcbAxCzmXe2jXfp4iYL5pWgEwV99owGUBAVItHyXSCa97SYPSZrtmsFTsvrajEdpX1oFP88x+Xo20MJzsf7NnssI5dhyD00KcVKxB/M8s9NlJRrnwAwdllLoWVl+g43lR/Vnloscj3PFdRfdWEqf1ictnaPB53/v7wLDb7WjH5zj78oKUrN2YrjIvpaJulCi2iCQyh3Xm1hvHbl+vdllYga0pVUXt4cE21dOu9HneM/XLdsmeuoTHr5fZYU6zPu4ovfbMgwaoWety+9Sdik7U4MX2d8H++iiXU36RSb0I4w5MkxU/XZx83Pnd4QEM53AZ+kqhZuRNrLI5VxIBjMW0SLDe9tvMDYCrpnFcGMkXNSBuxdQgyu3FUUK5T1n3WTMBUQL7LQuuBL7NNS9mQQkqJATI9GuwUgm1fUV/yXIj3dqMrggo3faFjx6jz2M4cHbr5XhQo3RzxRdF6QY3PtAeR7H1vur9P88tsbKQe324HTr9vsEeiXDnnNVYuVAVeGm5z8qIs1f/j+G1GiIrZzEHe+y3TskNpMhph5+NfGO4fDnhHuN1xqjXTnaQFS3jHudIQHhXqqGSBTsQ1HngcFlkEbpuKaI+yqoGKyJgwgeL/KG
 ul3DX+b/
 mAmlZrTuK/2RobYBZAVYdhU00fqbe2WBfRtSibaEAsva1tp9bbzDRev0dpnuBAhGlPNW4BGGldHDIXf0/34y+uqSe+4CzFxZ4HCO8WbMjyEEx4EIbqAxo6kqwCybBu38kRJe+6G5Uvb2kqpIoShiox2vPSV/+f9gy6p1CJDj3+EwFlHV3tlXobeoNmzVM01fDBd5jWc4Fx4luLwWO1czP4MlP0XTPGWnkM+mF5PbArVobd11wW42hzZ2Jv5NPTyxX/gBi12W4mkmhWPpexi9lSM5c7QPm6r8zD1F5QsSzzhIS3RVlJPk1cIpt6fR4IeYftn62Wj+ag9V4qj9p2nlO6mbLZi1XWIoH+kI1y97z4gSSPPLi6Or0XCcfOMalDLn/8BoHwHGsDW+m8prD20GHvLrkDeTfqkldDM9S8oTS9jzTA9RcUPci5Jqn8ObJ5x6Pq3qnEIi6xwASzuTPwWUyMM5jantzT9jnog14
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This patchset improves several folio split related functions to avoid
future misuse. The changes are:

1. Consolidated folio splittable checks by moving truncated folio check,
   huge zero folio check, and writeback folio check into
   folio_split_supported(). Changed the function return type. Renamed it
   to folio_check_splittable() for clarification.

2. Replaced can_split_folio() with open coded folio_expected_ref_count()
   and folio_ref_count() and introduced folio_cache_ref_count().

3. Changed min_order_for_split() to always return an order.

4. Fixed folio split stats counting.

Motivation
===
This is based on Wei's observation[1] and solves several potential
issues:
1. Dereferencing NULL folio->mapping in try_folio_split_to_order() if it
   is called on truncated folios.
2. Not handling of negative return value of min_order_for_split() in
   mm/memory-failure.c

There is no bug in the current code.

The code is based on mm-new with V2 reverted and can replace V2 cleanly
on mm-new branch.


Changelog
===
From V2[3]:
1. Removed "bool warns" parameter from folio_check_splittable().

2. Removed all warnings in folio_check_splittable() and added a single
   warning in its caller, __folio_split() instead.

3. Spelled out in the comment in folio_check_splittable() that folios
   without a mapping in the swapcache can be shmem or to-be-anon folios.

4. Renamed folio_cache_references to folio_cache_ref_count.

5. Removed extra_pins variable.

6. Replaced folio_expected_ref_count() with folio_cache_ref_count() for
   folio_ref_unfreeze() uses in __folio_freeze_and_split_unmapped(),
   since they are equivalent at those call sites.


From RFC[2]:
1. Renamed folio_split_supported() to folio_check_splittable(), changed
   its return type from bool to int to return error code directly, and
   added kernel-doc.

2. Moved truncated folio check, zero huge folio check, and writeback
   check in folio_check_splittable().

3. Changed zero huge folio check's error number from -EBUSY to -EINVAL.

4. Replaced can_split_folio() with open code.

5. Changed min_order_for_split() to return 0 for truncated folio instead
   of -EBUSY and added kernel-doc.

6. Fixed folio split stats counting.

Comments and feedbacks are welcome.

Link: https://lore.kernel.org/all/20251120004735.52z7r4xmogw7mbsj@master/ [1]
Link: https://lore.kernel.org/all/20251120035953.1115736-1-ziy@nvidia.com/ [2]
Link: https://lore.kernel.org/all/20251122025529.1562592-1-ziy@nvidia.com/ [3]


Zi Yan (4):
  mm/huge_memory: change folio_split_supported() to
    folio_check_splittable()
  mm/huge_memory: replace can_split_folio() with direct refcount
    calculation
  mm/huge_memory: make min_order_for_split() always return an order
  mm/huge_memory: fix folio split stats counting

 include/linux/huge_mm.h |  13 ++--
 mm/huge_memory.c        | 161 ++++++++++++++++++++++------------------
 mm/vmscan.c             |   3 +-
 3 files changed, 97 insertions(+), 80 deletions(-)

-- 
2.51.0


