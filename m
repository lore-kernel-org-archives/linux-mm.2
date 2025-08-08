Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F31C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 15:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C4028E0003; Fri,  8 Aug 2025 11:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99B0E8E0001; Fri,  8 Aug 2025 11:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8899B8E0003; Fri,  8 Aug 2025 11:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7BCA88E0001
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:44:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 305181157CE
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:44:09 +0000 (UTC)
X-FDA: 83754011418.16.4D6FD01
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
	by imf28.hostedemail.com (Postfix) with ESMTP id 686ACC0007
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:44:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="A+/WM6CB";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.77 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754667846; a=rsa-sha256;
	cv=pass;
	b=pjj4M+nbtqL83JRRU/32nJz69FKtEYZ96aKRl+PUklrv4Yv4AUWmoNJi1ThG3EqZBrNjtT
	0nrjjkMfCbZA1WyS7K2ni+f33pqn/EFZb73jyZJkzpdvc5l5eS2AulceJNhP2EXvFIIcBT
	/xKLohNZeY6tKlYyOGBIjpae6Nju1Ek=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="A+/WM6CB";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.77 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754667846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JM7tj28809Sl/XCQp+qz354CEABsnGf6IKQ8LZeL4r4=;
	b=avvZyhhs4fhVnRiKi4Tyzl2eUsp3zswGBV63tgY3YNYkx1Ed44mNJHsLW4/7s5EAnPHNvc
	BZre11xERgVJMKi488G1dCVy0A7DJSKPnZI8L1jio59TOgrWQxBGgK9VXACFsx29lJ3S+V
	ZjF+zpV3sHJFpUu8YwhRgTydOKVH4yE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aB/jq0XaKTC1IgDoX2LFQxSBpU4DeLQPyYYRzYnci+D66CGVQDw08Pxf7pgjjxM9eTEaoNHHMICW0sBrYeYT/nMxA5T2dYkVm5/Sh7NFYn5JNH2SE2FTEcLv7l2s4g+CLO7MoTfT75qJiO8OGl2zW07gAKN/VpfI3ZIVPalNST9C0f5c3M1ha6B8qvUkmk9ntQfbH74mxLvZmJJH9Agc6UhNMQ9AZsOzZuN0abGdo59Z0UzMcN0iFuGboz/idceUKFtpfxQTHuqGmxTjRLCYivHSQ6t+VidzlmVThQKJE7Uukp3BZQ2u8gVx4IOR9aoDmNPkkOFnpf3alzuSs834ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JM7tj28809Sl/XCQp+qz354CEABsnGf6IKQ8LZeL4r4=;
 b=sV1dvuhCRQmTbL/1pajRj+EDIL6YWcY80HyXaowGXsDIZ9b7QC3M8M8yKh2FYPYD8/njliceTXjEcPr/xOCsQHeZ7qDW7qYwFAn8ZkZsqkrsVVworY15vV9ncE7Ipllk5sW6Tkxw3YG5g6g1/YlxR3pDd8BiT9lvlEwNmJ/7ZkfQtB612wzJEppew0E2daOq5FiSGjN6B42+sw3+pLIqm7yZtTc6VlU555t2CA7HXTDMYFur9v/0Wl7uUbiz8KQQA8kcKpV5n67DDaCkpUukCvnyLqhDEBDE6TriCrXjTRp11jHXUxRyUigtSu+FwXglQIKE2M2T6c/fY8cqaGCTyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JM7tj28809Sl/XCQp+qz354CEABsnGf6IKQ8LZeL4r4=;
 b=A+/WM6CBs97TwN2bu1ApgK3LBy+vRRsF4VspTzbM5SM6IQrods5nVLLHmwFwP4t5S36v2b4lP5hradJS7qq4ZMFKF5Gim7RIt8M/zYW11aVdu6j0gQnw4qfrHt6n6nRow2epLNnv5RTBbdOOCe0U6rxidslpXbFWpk7LzO4WxdH2r6LCVtabFg1CF3r2shAuI7O0CeiuUnGlvesYXubba62vyE3rYLlidrYAzNUXqF6Fth4ju+GSZOexqa2CyvELUfSkETO5tBLA3FIfbn0ABOTc+M68HWZgco1P30YYaZPBxQVokTc/zD/GtVuYr//haIuZIJ2UQADkN4F+N2hELw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB8088.namprd12.prod.outlook.com (2603:10b6:208:409::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.18; Fri, 8 Aug 2025 15:44:03 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 15:44:03 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, <linux-mm@kvack.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH 2/4] mm/huge_memory: move to next folio after
 folio_split() succeeds.
Date: Fri, 08 Aug 2025 11:44:01 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <B178AB0E-07C8-4777-B15E-8A378E3AE69F@nvidia.com>
In-Reply-To: <CD2ECB34-11E2-41F5-B220-860FD2C60821@nvidia.com>
References: <20250806022045.342824-1-ziy@nvidia.com>
 <20250806022045.342824-3-ziy@nvidia.com>
 <20250807085521.bhs2o6wk6pe7xf5x@master>
 <30CEAF42-ABC1-4174-8D78-C92B8C8AEB37@nvidia.com>
 <20250808031523.g76tmlghuaorjaoq@master>
 <CD2ECB34-11E2-41F5-B220-860FD2C60821@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: MN0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB8088:EE_
X-MS-Office365-Filtering-Correlation-Id: f5f1a17d-e187-4ea3-a55e-08ddd69266e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TecI/0X7Mo+xX5pORsUQVyUGM7BWybUxWjJtK9xj9M7IWpsfss6T85s8es1u?=
 =?us-ascii?Q?/x2YLcVx8g/lFuwzP1y8RZx/8NzAIfE+oE9g0Y9VifKJgNEud0OcgdIneyH3?=
 =?us-ascii?Q?rXKTebMMc84c/129N511muEBvU++j834NOLQbV7UzANk4WLC22FAjYtaAY1r?=
 =?us-ascii?Q?lzhyfg3Z40GanlXgbEOnWmq7hVZJZyfB0csbHQwRY+sZ7CgHeXkybzlrwk24?=
 =?us-ascii?Q?rBJXlUajaoUPbOp5PBvIoAlJg10JpiXoospcteCXqZpcAATkQXUn2qgE81wl?=
 =?us-ascii?Q?8bvszzupnJ3ic6HVC4gVierpxdTdDmDmfqJPZ9v3mLdxxyw0LrNL5r9KpUs9?=
 =?us-ascii?Q?YaiJrvG44ML7yGK6Q2gKHff5HpHY5BH7tSwnSEBn457/9ISa1QEx2NHFSygK?=
 =?us-ascii?Q?qtcUOSBAywpyPdR1ObSWW5GXZU0yS3yMcLODBWJSm5EraErSyAK5GMEUZrh1?=
 =?us-ascii?Q?ww1KnsYTxK+hhfn34+cQx8rHdkSNVmaKn7M+FOO8mDnAU0+ppGDDrg+fJjXv?=
 =?us-ascii?Q?XkN9eCJFz391OWrzk59UKKMIc2TCyzQO0J1mc9vpwsQRevz+3MaSGLixvyi3?=
 =?us-ascii?Q?ba4CTczDyus01XuHJ608c60T4iSwHBpN3O24yD44+nKALd+odaVXUS6cykNg?=
 =?us-ascii?Q?O83BdbP6r97HgPbRci3j1Mt6FMoViEuei8zpYZ8PVz+dhRi4Rnxn80nFqMXv?=
 =?us-ascii?Q?3Fwm1MeWKPQTXPgsqBKFrNoCmJwkapWhC9k06XpyD6DJYKMaUAp/M0MN6Xz4?=
 =?us-ascii?Q?lGZ2hLBDyVjvGn7JZfYlQDfVtF1a3BGrK4RukMXO3UMq5FcAyVNIsw1mO57s?=
 =?us-ascii?Q?hOvOzsYy4zNgYVZsanWLNxuHagfh0FO8Wdwr/iPh2J8ytSI6ToLhSYufFllG?=
 =?us-ascii?Q?uQQ0oVP2LYILbLxDhvGFxNHvVYdWZpNFOusIJwy1x2wkSdQdrhuLOX0jeJum?=
 =?us-ascii?Q?G0LdU8rE5KWo0Inb/PYGuT3SnAnh1AbjSJQRr4E7rTi6pOs/agjzC/ytQp0a?=
 =?us-ascii?Q?dfw1NYT1o5IDxTajJhDzzN2HxpqUkgyQ10y6uRFH5xuoHoxwP4LD8E5x3HOr?=
 =?us-ascii?Q?/7bOWY4adqVm+udWkTGEFqK0vpex+91JaDQDIxZc6gvp4ZpoUYJg3C00kowo?=
 =?us-ascii?Q?8DraJxs63L4u5/3/i1+OUHlMcse56FaIIP0nVIWjAYylGjNDonFfOBLLsnjV?=
 =?us-ascii?Q?jIghoRPyJgPuim1EPpAI8Z5qLtIvX5zRYGdrZxL6F6Lg66FMsPlYF4GGUalO?=
 =?us-ascii?Q?eLQSH3WStH/zOqvr+D8Bt1NtGPyX2ziJ0bSbR3rzb7xbGYVzxo2GGHOxNRHc?=
 =?us-ascii?Q?fCOeHig2gpPHvYyNN1p2IEs8UQjLHVp5LvcClK/9dyBDKzjTbnzH8rUN6uKM?=
 =?us-ascii?Q?tMeRX+/Eqcz3tlrcwYR5XgnPMYMuSWVfY7Oj47B0kTr+PBvgFfuSfZHuDi+P?=
 =?us-ascii?Q?7y1WRho5NEo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ek9lagwdS8kmbvtkbo+jJvdU8a82+4wSQCGhignsJiyi4QIbSvou1ikPOCbJ?=
 =?us-ascii?Q?jEgssU3FLhMn8SymU2KGH9UHhh98suAgTd/vTtJteSd+XAi6N0S+y6b2wxwD?=
 =?us-ascii?Q?jeEtfJ6py80Ql1i7nU5ng23y4BiHa6S3Hs6wzak588yo0n+fMa7EdShjGRkU?=
 =?us-ascii?Q?Gc28kXWtStZbSmjTuhQYoLjJtCO11mc1/ZgzS8K7KO6pcKB1PIWCqLqCqdCN?=
 =?us-ascii?Q?LnnezBxvVe9tRZodxn0UH0A4a6YXgadZUoYxy1a2G5YQpyNA8Z9B6XMGxKVJ?=
 =?us-ascii?Q?Gt7EYQrqUNrthQMOn3mjz4Ko8sdVRTVdAMu+/2THkcxugvmettAz396zPBc1?=
 =?us-ascii?Q?eJ26RMhSMLnkmr6XVBqXVtIk3+6QbYwEJBvoiRX5DndnBDLpPRfrZxfDrVoK?=
 =?us-ascii?Q?52f+sfcfSG1/mP6KUKg3BQwWNbr1lOS4yn0wnSJQOhJpzcOV5KcDq5/t6ys0?=
 =?us-ascii?Q?tLe4DdZC3WaDZV4cvuqZmtrGoKnlL5Craqqz+i6xM/dfbhOdP5yF8gJcX/5w?=
 =?us-ascii?Q?y7V7k7F3NevtHnQfOWInK0gNtLivDngjXGR9CxczSK74Jt1nh47UrhqyAecT?=
 =?us-ascii?Q?Ge6q1JJTAOd2Tm6u+YpYFVenlFtYRAUnoyAp5R7sT7Z8NGWEn/XOQgCko5P1?=
 =?us-ascii?Q?0PsubcNup8UIsR5Qmy7MV0Kl6RbTsacWi2jnjMlf5cM+fEOnH6IWUPuj4CUU?=
 =?us-ascii?Q?1LTMgR4FcOTwaM1V7lDN7PiUG8YIsxxkJ/7f6wHftmxeOAhsXOE51kmCXMCC?=
 =?us-ascii?Q?iMtGOtyUZm9iN9TkVbx3mhSV5Ucoe7t0/QUIDbbPEweg3mdxxPCuVTntR1e3?=
 =?us-ascii?Q?H6gRtcTFjhgWYdZeh54MIXmc1K+WRr6laikzOo8G17fB3sDEPXAHBzgaPcdV?=
 =?us-ascii?Q?flkX6xToeLMXYayBxBpW4sLkyQgsPwBMJry8a92CJ524Hgiw03nsgakoxMk5?=
 =?us-ascii?Q?hTci6X7oabs9Ulx3siT3vcc6bGThrxgWnx9orGXCSw89d2FpN0B1hieq9nj6?=
 =?us-ascii?Q?IQVu/WbzdXMDC6IiS+W1kKzrxjiuJqOVs01yGz8/mnYn4gIAq6VVdQVwzR+4?=
 =?us-ascii?Q?1fKamH+glkB+sxLChwFeHOOAP5cTxUkYfxeL3YJklqp2ghoksbXYksonqw0a?=
 =?us-ascii?Q?5b6xacdvLpHFIBV/VnCDrsoEK96BWaNwJ4Z1qBaXjbH1+T5GTKUAQZW6fZVs?=
 =?us-ascii?Q?BRs8Z44P8OEvwcuezXQR4s1maOsfM3urM6CnEOgyA+4V83jE7XlOEvp5547x?=
 =?us-ascii?Q?eJD/i+dWxcHgp09XYHY9QqQtlhF2Y02iL8rwCM+WYPa0jsXSYjZqHG++lL62?=
 =?us-ascii?Q?DBS5GzAS7ulRMNlDU5gSN5VseIIrBKhLPdKuHZ9US6Op5s5jxuIxuTfApCdj?=
 =?us-ascii?Q?Er4gOW6XmRwCMXWA4hfFHsa8kpFlSMi3/4KDiDtdwJMV3LgagqxtRuBLfEMz?=
 =?us-ascii?Q?JD+Gk11+jWMT7dpH+m49LSrbaAqhvrL5xO1M4HoWH2L81vk7HW9ITX2LZW0W?=
 =?us-ascii?Q?rj3/pxc90t0L5MG4r8ED7TKK95rKGNnWYtHY7Go7W0EW1l7sn+2wNdIddlYe?=
 =?us-ascii?Q?EduJP4tjH/PsO/eoR9wfN+tpL0xjMFseb98s5O4V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f1a17d-e187-4ea3-a55e-08ddd69266e3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 15:44:03.7519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pk5CKqok4iY4XfFOc9ZuFumyb+2Acyh7WtwjYwZC72gYlL824i/5elgWI23q8lXY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8088
X-Stat-Signature: dyuy548nqbpfm9n9uokef7koyiobse5k
X-Rspam-User: 
X-Rspamd-Queue-Id: 686ACC0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1754667846-206383
X-HE-Meta: U2FsdGVkX1/EqJS1cg1fItt6hR8ktdt7z98gNKxNE057uOZxDPJA6v7BEDQheusqGHDeBFae+5B4Qlf9wMnjyhxC2aRkLACI0gl9aIC/yGt2zD7Vivudj3ua9NNQKGHLDOeAMS+N6xHCTHHrkF7ARXvUA3eHBiXZqtcsXb43nIbHwhL8Ya6T/t0TJaxmYAcFiADWEIzVi4fBqco8avnsw9Vk726AK8+89Rxk7z7OmovSDP81dRnw0//J2S7n0175+slT745AFZantWuLrURTVnWZRPWIvy9LzOENhHyvsXWBnyMoIiJR8FRBGzPzkX3WzQA6A/tgHk7D4RFLQfC/AVpQA9dXkRmPxhjSr3AuDs77HWFNFk5g6dUkCU812IS4lAsyvCJX7YdsO0f9858FnPkfnx8OnFbg9DvIGdb80SvgSVV+kvfapPS8+jXO5892iNRlOrVD7srfecjjqXEmSIwmYstTromzWWXlWbIlw6l4aDou3cBdSewPl4FpUAQQYtT7NDgFV9eEOJw5aYmc/v0GZL6hzGccgilDm8fCbFk1n/B3lpXlYG4vbsLr4vdbxc4r0je6ahy7Jw1BKPwXCeomaa1KEORGYx23Vnhp4powdoC6f1zh9mHVva2XgsF7z9tT7HlN7gNiWumg5ZZ70+7367x/NgY/C/ote1e4Kn+fzmmOFpwSyMFCzbIIbYzYvUyb2Ah5N9D7u0uLRQHYH4QbIeeoRUr2FROPoNRARHpzrl5Za1ktvFihgFZqLQujWOXM0X1bXkF3ytCAyVr+/CfRYxeAiijFfIcWUb4I8BVyA0F4Q2h8XGT2Kw2A2BaqaPi9yoym8fyfZFzeeCE1uwcMMuOzASVLo39jobroO3cL4QidELJiNtledZFHQj7NxvJ+dgTlgusJ2y8vFdZHb27HEq2X7/pbAbv27/30XNv/0+DYKbBzTSbzf3g0XmgwMLHgp8MO53JxlKOu3uZ
 3m8sldfb
 E+wpZmx01vqz2A2zpnI4I5QD7CkCmoFf0z+1qcGqo/o16Ckj09/3nS1k2foYtwtue7SCZkxiHVxUtuLFva8/VX69X65SGfan1WfLt7jsRP2dUhYjilz0BDpZykzUKEU/0NmgaGIXm59Bm16WkFjwjhfs7LqO6BYyxB/ePmA2eFamtjJz8sAIVnOBIJzyrTD8/s6QYMXfhJwadDG+PoAoaBO0MeD3RgGK9NrkCvnFzksRq8fT3TQt74d7s0k/N0G3dV+4f/WoUhRab04KJfiD+XSPMlP3EsPIWIe6fGgNV/O/idlivEJkMW5Ws7k8tgTbyhzXNOL6rL+Va6RsuIPi/PVZntlKJcpmZrxq0afm9TWY6KR0KFX1f3skfTi8ASAZPbHe/VLXMm1RNkjwwMkf+5M4qKHaFfSDCNgSCWo2jcK1zatJUXuFb/tWZDbrOZHfpy9y8ATkg7fSbDQnJ2jwhT93qTHEVJCe7FZZo5yXsVcnfxOOvZLfccTajBxBdz0cd9MgZqQjaQITxx7Dj0leGrPTJCdR9X16a1CTo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Aug 2025, at 11:24, Zi Yan wrote:

> On 7 Aug 2025, at 23:15, Wei Yang wrote:
>
>> On Thu, Aug 07, 2025 at 01:05:09PM -0400, Zi Yan wrote:
>>> On 7 Aug 2025, at 4:55, Wei Yang wrote:
>>>
>>>> On Tue, Aug 05, 2025 at 10:20:43PM -0400, Zi Yan wrote:
>>>> [...]
>>>>>
>>>>> -		if (in_folio_offset < 0 ||
>>>>> -		    in_folio_offset >= folio_nr_pages(folio)) {
>>>>> +		if (in_folio_offset < 0 || in_folio_offset >= nr_pages) {
>>>>> 			if (!split_folio_to_order(folio, target_order))
>>>>> 				split++;
>>>>> 		} else {
>>>>> -			struct page *split_at = folio_page(folio,
>>>>> -							   in_folio_offset);
>>>>> -			if (!folio_split(folio, target_order, split_at, NULL))
>>>>> +			struct page *split_at =
>>>>> +				folio_page(folio, in_folio_offset);
>>>>> +			if (!folio_split(folio, target_order, split_at, NULL)) {
>>>>> 				split++;
>>>>> +				addr += PAGE_SIZE * nr_pages;
>>>>> +			}
>>>>
>>>> Are we sure addr points to the folio start?
>>>
>>> David pointed it out. Will use addr += PAGE_SIZE * (nr_pages - 1).
>>>
>>
>> No, let me be more clear. I am talking about the addr in next iteration. I am
>> talking about the addr in this round.
>>
>> For an addr in the middle of 2M, we still could get the large folio if my
>> understanding is correct.  Then (addr + whole folio size) seems wrong.
>>
>>              addr
>> 	     |
>> 	     v
>>       +-------------------+
>>       |                   |
>>       +-------------------+
>>
>> Not sure this would be the case.
>
> Got it. addr should be aligned up to PAGE_SIZE * nr_pages to get to the next
> folio. Thanks.

On a second thought, this new stepping would mess up with PTE-mapped folio split.
I will drop this patch (pr_debug part will be moved to Patch 1) and change
split_huge_page_test.c instead.

--
Best Regards,
Yan, Zi

