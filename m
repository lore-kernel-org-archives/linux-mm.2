Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFB9BCA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 21:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BD666B02F5; Tue, 26 Aug 2025 17:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 495876B02F6; Tue, 26 Aug 2025 17:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35D346B02F7; Tue, 26 Aug 2025 17:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 258526B02F5
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:15:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA084B8947
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 21:15:09 +0000 (UTC)
X-FDA: 83820163938.10.9F22325
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
	by imf22.hostedemail.com (Postfix) with ESMTP id D6B2CC000D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 21:15:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Wx5JikYE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.81 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756242907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4j7OV1FuDoEdwtLeSqP/tGFmhHacGZLj7e+4gvahYQ=;
	b=Dxe0hEMcE/hIA1l3XYFhgdhkv0ZhBheDqkv1hb25DmgcSPu2K1OOvArgCNFV7RttFmx6um
	Qf7uMciuffCBkoUPnJ3H36Egn65AUVmTcTQf/VoAU6lUsrW58Tb/3oy1L51nmdMCLpQJuJ
	lzoJcbFjw1Em1AGN5hFN4DTWwPD5SNc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756242907; a=rsa-sha256;
	cv=pass;
	b=QUjqURWBa2J6U8i7u/rrzPQCaVkxtk6+YmABmbqI+8WT6quh1/VXxsBrgZV+jmkRSPOu50
	utBX1ePib0476N5V/crRczwWrMSPP0dSwrb4zToOXLdsVEoOsD4u+B4vaBP6j0zSo4Ipib
	FRliVbx6jQgTJQtC9AIf1EJ7eToYyes=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Wx5JikYE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.81 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X1EEoV1kGhtf2oT7ZeHnY3J6dUmroCCHUTdlJO+J3KaemhY78qOekhxgiYee0ony3w3Lcg0Jm+rL6pkiRRsYfs3kBAV3OrkywxVctsqMwaNsd8kdvqT49OAj028qx0KKai5WFwqhwy8U007MWuOsKojTXqbawSwrUU59Rs4zbmxltzoX8KIJPoWY03QCZfLbNKP7j9wtucd/U6DV7od8y+vag6MfouENvAP356765dXWzyHDhweMHH7F8QzFayPUA6NSFHYVbBN8GrIZMXisM69PnYL4NM9r3jt1J3j1P4zRNuxaNaEEU0i6vZjMZvjsZAe37lAJYFYRpK4CYMcvaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R4j7OV1FuDoEdwtLeSqP/tGFmhHacGZLj7e+4gvahYQ=;
 b=jHGP5XUw0pNDCPYGQr/+KZKXgzZ1nrCu3Jl0Up7QfaYVMwvxW+7ZUwOgVadBNse2sbLg4uvAS0gma1GxzahDYVwusS+I7YzB6N//JIaSo2zK096qhj9IjNuAEFAC3XlJmy41OzbTngnl0P5ZRWt/wZaUnZQWFZ9rOIs0ioo1PfKn2INLgWnUQ+nTVASGw6l9nBHony3urXSw2jAmVCHY8vGFfzHcCvH7ILrdDHo7NtfZ4uXsSrzDtcHKT+CPjmUO302Y9kf9kif1eZAMYCCz+DE5bvFdOZjY2H5tIpA5YANcBar/l29JnNJ08NKAR1lt4tBZGfRx6UIYsqby23WFSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R4j7OV1FuDoEdwtLeSqP/tGFmhHacGZLj7e+4gvahYQ=;
 b=Wx5JikYEHrn72DG0E77z44rpgBtV/BIbLmIT/vviglxbnDHXRnekZk/h+uD/AkzC/zvzrwnEyYVn4kUgz5Qur+XZplx/YPoqO1mJU/n0/TBvNiib6Fw6Zy5VM7y6DlSKC7KxE4uc060icSKn3/6Tqfd/FWVQU5FMcx4gAObgsU19Km9BA1Op+KxFzFKyNP2gETb1h45NMP4hpkl14l1rCBf+Ni6G9pTiNWQYyXC2/1LbbLegibgu+i7QA+Y0i3S488qtHyl95NVI36/JhJKVcbxppzHzNUNHplPZxiIfoM9Ojd3duqvr2ugBGzoeESFzxDJMlFJ7cY4QVDpRhiJebw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA3PR12MB7829.namprd12.prod.outlook.com (2603:10b6:806:316::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 21:15:02 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 21:15:02 +0000
From: Zi Yan <ziy@nvidia.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: Harmonize should_compact_retry() type
Date: Tue, 26 Aug 2025 17:15:00 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <39EB2EAF-64BD-49C4-80B1-4424CD723C5E@nvidia.com>
In-Reply-To: <20250826-cleanup-should_compact_retry-v1-1-d2ca89727fcf@google.com>
References: <20250826-cleanup-should_compact_retry-v1-1-d2ca89727fcf@google.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR10CA0022.namprd10.prod.outlook.com
 (2603:10b6:208:120::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA3PR12MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: 125233c2-95a1-4358-ba14-08dde4e59f39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pBPSoxxInVtE0PEF1UMGYIQbCErNdN5v+PWY6uvOG8wQlFww4np2YgrVAo4s?=
 =?us-ascii?Q?EWf8666ZQ5kI3GeAe/aBdzb/kmI7ySzRUkXwbdXUbGkWCXIkh2tHxnQ1oCww?=
 =?us-ascii?Q?2vzwpaBJGtHMVZrARO97XZjiAv4pEXM16iHmdXCrGIZozZZN1oHqA1lVZeDf?=
 =?us-ascii?Q?ifUQJkbAWQY2QisbbA1X3S+KTJR3SKlHV1FJDT/NjHikSRz38EKdrfI+HrkZ?=
 =?us-ascii?Q?eibQttrzRUtjnSsC1n59Zh9yqrEtT/+vfm1qkyvH7v3QDalyLnUZ+HsFPPUI?=
 =?us-ascii?Q?Cei5FgGoN0Y8tzHic47AVk+BSfdWC2aqIOMxBGYvjIi7vSxGqNOI7t6wZ/ta?=
 =?us-ascii?Q?W41e0U32VV6BjyjcbTtaAy/N1CqT3/s1M0YumbYBcjFrPJjj0vUww3eykCTN?=
 =?us-ascii?Q?NY9AkbkDhlJXC1AwOGNwKEJwFpSmJ0pqkGLrmqhHQlhgVeAtMaSkLatPu1hX?=
 =?us-ascii?Q?rgBa/rIjnDceH3ZYAUy0lSJorLvmXGS7qNg7ehurnK6C1Kc0GA6VKJdJR/72?=
 =?us-ascii?Q?HZ7CcJJDPwSmyQi0i7uwlYT+8SidMnNvJbrK5WgrBIg/C5IFALPc7XFnhvda?=
 =?us-ascii?Q?Spcw4Zg1LaPGWJeLUahWLHvz/I3rMEofv2AFjD1JUZxg4G5vH1JWB9N9MG5/?=
 =?us-ascii?Q?4aRFVaG0GwC2JAVSKERF8ph8kDutmXr4fOSqycuLLvkIJ88vl4CAoUhwhE+x?=
 =?us-ascii?Q?lbUXYJfuNXgdSuB26Ni02y4sxaktdL8GJZoUXFA05XVKz+Ehd056rZi6OwAC?=
 =?us-ascii?Q?dTQbvSgpM19EmGtyB9uc1vZd3EByGEs6qOOjrJcxYwURzC1lUjhV6VxZm6cu?=
 =?us-ascii?Q?wV15SEQpjt6v1WhAiznxtkt7DzsRSoPL/kljS6/KbS4rFl2IX16ExDOBi8Uy?=
 =?us-ascii?Q?Ubw66B83uo+gfyqCKIRlO30u8fu63ZTe1F1FC6BLQJMJvz1VGmdBkXvTDmPP?=
 =?us-ascii?Q?+Bb4yzkB3oaDRZSXxyrobZYevzl3xepm6Ykgn0alt71BP8U/KyQ5SOSjqvT6?=
 =?us-ascii?Q?P0il3oTv0qD8FYUa8nBSJkzQASS9ACj+tSA+1JKG6hqUaFbjZCTENmwtNyFv?=
 =?us-ascii?Q?ssJMTwjBTRbKhAFn5WpCbkvGqwhz/5Eho/i7H0ykNVkANhx318/9ySQBAopm?=
 =?us-ascii?Q?rvs7LgW6ruK33EpFqObkjYfIF76DeQOgkOlBCe8b5hMGPeVwvdvh4wmIpY+n?=
 =?us-ascii?Q?j+6MbTgyfqItY/idLAGU2YYXj77vDH7evW5ad6aURzQDuVGp4wZExq8vfKhd?=
 =?us-ascii?Q?zZHHY3Qy0Yr/8GnKdLHzA3B+MLJFRpgkcEHicWULPkiWuGf3B3XHyRIoYCF6?=
 =?us-ascii?Q?llUYM25Z5l8ySw1Vjr+Gr984fJ5ArCSDLFymmTA3SYTzOciskXP3FOGAdoM0?=
 =?us-ascii?Q?7AmqsqAdEWYnF1ph8UPZXIRHr4Ki5L1PDp2P7Ajrpgpg+IT2Ys3UzDVqq7/5?=
 =?us-ascii?Q?W32d90b31tY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jia2klsNeL0iiwaA8aoc1SW+0EQ/6Ds2uoeV9UfVnjOaAAl27AAQq3NXka3k?=
 =?us-ascii?Q?9aW7LJcdT5ABhyStzk/mqdNX/IZZTRT/bpSb1ZPiHQYFKlhmAPDZyH5l1SZ4?=
 =?us-ascii?Q?dfTkZ/RicTu8KZxHU+zkPRPO7gsge37QiRHjSzGd5NVt9DOqLvJwYexJmXwq?=
 =?us-ascii?Q?SzotCrb3n5QmJANAoIpznKxVnQigsLLXAg305hLWbcMG0mE6PFP3qzouDBDB?=
 =?us-ascii?Q?jI5HsuejvKlfzzkDLnlQh1NQSQJzYQvzoQ9Ronjrr0rJmeBmsdC/kgv4UU/2?=
 =?us-ascii?Q?5CvwhTrSLNcQ4JFzliX/EFrTnab+2/RJ134KaSsv9+Vce33oHhnN6OUgaOog?=
 =?us-ascii?Q?OjiAKIh9VCEVjQgeVugAvkHO5FPy0H4K7gANQFy7sz4ApQP6Ze6QRVJJqzQr?=
 =?us-ascii?Q?METe//xAhslhFpO4dd9iYUa4fh/eh3g1BAWlEdAD0mwbqTYQq877NFk0AMGE?=
 =?us-ascii?Q?xWTLwyuj/WmT33wOlZlcHdzlBTIvHTbI+AXNj9HxDOk/vnxI1YmYsEX5Nztd?=
 =?us-ascii?Q?F18TsdeB5v5QaUK2rMxIDV8q1Az19FqGnjicfvKMme+ewQTc65vGnJWvMVmd?=
 =?us-ascii?Q?8cXKIjXEzrPyFZb8pRjdpoXt1v9WgvIfHCGKeLBCnOP9ieCgArZBc8Q7rGNq?=
 =?us-ascii?Q?QFLpiduvVLeNYrEf5/Cf7f681ymDTVsILyL9/D42JBZ4weYDKswtTkOPgLA3?=
 =?us-ascii?Q?lr+2jCsH9i9OTQmeOv6l3x4iIVLQOVvxFkK3aWV/wWPju5HDNIebA6xVGNMN?=
 =?us-ascii?Q?W7YmX9NsqHHlLBH9KMJrHnuKLcbRcmFzU6gc19yHuw3mYlm+Cocg46KzWug3?=
 =?us-ascii?Q?iMfQ+4yxDGhZLFlH7Nkso2txCw+gBlGh8WVvl7ej4Uq11oD2sRHBLPZ38Sa+?=
 =?us-ascii?Q?Gzd/Ex4N2KtXKuU72BEZ9ghJ2EK/cMj6CqHX2u6OSP8neyrRQjy9wCJvvmHa?=
 =?us-ascii?Q?d72g5TR53TuUbnKcoQA+TffGMlE5R55uj3lL8odqnPKChFIDiefH5gBrWDTg?=
 =?us-ascii?Q?750I0pTXPYT2Wl2FsOfKeWUE8IjAA102VTtzaUiBmDKEk00JU9O+SZgr3BCh?=
 =?us-ascii?Q?CvzwvLQ4Gp+mpHYo3RM6ASnksG2Bi81sDyjA+wsZ2ZbGAZl/UqrmwDz6SDK/?=
 =?us-ascii?Q?VyUbBgFCUp8anUX10cajqC6pmzZFTet/P47+7Xy8p7TiBhaJLhLqpbZoT8w1?=
 =?us-ascii?Q?bNRi6Zix0c9lLHUcR+dBNuQJB7VBdM0Jt3PB/z9BhfQi8BbLz/LkkqjaOsYm?=
 =?us-ascii?Q?akJajXCIZIl3X9f5MwabyioPim2H5ULp1oV8UphlR/bcTXgzJ/yzlMWaYd/V?=
 =?us-ascii?Q?cTJ6+qzGw079fh/oO1k4qrLXrOF6YEoCDE94zsaFWd7xV+st11/39WXwdWwQ?=
 =?us-ascii?Q?pDfRg3XksQpld4U3e4LBLpcUT60o0iy8YE+BXdwZ+7lbnfm6CZDFbNaH2Gzj?=
 =?us-ascii?Q?5hRXkVNQVPB7J98TyZFCIfKjxeaG/kTsO/x/TWOzs1NM6YzR+UQkVozIDQeL?=
 =?us-ascii?Q?RoHwtfMCpnxugWd6nWUQ++7IPqy8JAH27kiFdr0JryhdVMYK8amoiSF7cgyx?=
 =?us-ascii?Q?PvO31LHVTOi+UHw1Ro0BMZIAZ/mybnK5XlLFNTbR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 125233c2-95a1-4358-ba14-08dde4e59f39
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 21:15:02.8131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xZUBzfz/90rIyTSgXTOUOEc/GYJLRkMRCReWSPtlhzRhEOahHZxka1jhD09XKwR0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7829
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D6B2CC000D
X-Stat-Signature: d6tmewzih4dhax7gk6hcb5n7qomuf6u7
X-Rspam-User: 
X-HE-Tag: 1756242906-681804
X-HE-Meta: U2FsdGVkX18XGkqMTWhDmJ4kphrm68+xWkyNfviZ0tMKazeIBVKFg4n3+7BeWeK65AmzhromHxY15gCYxhsg7rRBkPX58WyYWplejL9wiM5PLHQkuym4Ink0W5Z3guAMs9pCrZ0/RrRMCoss2wUyRhAuv3NJnXnFAo20G6SIyga8XX1fF7YRXefNIUFm5iDdD8t3BqYvzeWzeL7cI2qX8KUEy3AYfC+vOfw6CaZHw3skJvjXiYHkmffgFlLqk/c5jqsBiUEH5HAz6jJf+isNUfHpm1KDcO3TQszQPjNOLATzz0PggGddCt53HnfK74fFrrx5Q/tJKJYR5AP/+dQf7eEK1wx/DVj3uSXgOPpHuiAkwsOSNItTC/U7YDMVSnpKlW877YDK4+GyWPyMY/JFtofT+zFdaf2ctRTHqp4yPCw/wEqkGgG3g7jLTQkGil3s2l+rCmZ2igKJ4fTcwx9ZfUiZwboR2Es/1ocMGJrFhRUPINCk9ZDMql+NXpmvGYO967P1/RxM+t0Oy7vXECHmQbAO9PZk7qFaQ7DUekV3p1MdnelRKu3lMoPKmOMQDWH/hYSXCnh6DNSZ9x5c0F3smEoSFnW+ltpLZMpZXYhQtezT+IbRC94Cnal3MRYvrxSIpZLiEHgIDAEWpewQMyspHTlqWjXf9WTNlRxvE2bfAsF6yA+t/Vuy1bQB9pfHDEECj9DlSGttbG6JdCPcitjGyYoJf7pz313CNn11zh2+jrgUTDjT8gGsJetdkINhqoNqr5WA5SNvHgZa7S2aZHn8yU1PoTGtX6qju6Q+h5bJSDEgNmkFe3bL7RSSlrcr3RNUJk+z1k84JYNq5b1WtZUAMg2meA55BUCJ1Ufa2u2vzI2QVe8aNHkDc0UVAaHIL3D1UnRo1HIX4kT2qHcfR9ItG0m/qlchvn8BNjeHGpdrISXfQWmq8oWzpsKs4/QARbKF93SZS6UdNxL+bh+ybuz
 ylBtciRJ
 DLzJWN76rmnE1VVsQfi7aJunNtZssupIT+xnlJBooSKViLK7pwll4VqJgiaF4EhWJd+muV3IOTQhQEJrJfFulUH0uK2S/Tpa7FN6i+Co1qKQuWnyYe6fzql2HzUD1HBw49KTIlt0Bo7tKvpqlT9fb4981z7HrtkC57g5LB5MrAzLKkC2PzNdz1MmWxuxgf6VbI9oUXTUJzUpGMLAfEbvOL+8aK3mZRJsc27zZAiYk5B/TZCamCeDgBTVYA0lPVrBk3zY5IBltw/ZXaaUsLd3PvklUfTzZurPAas2C/5EXgnIcE2Wkxdvj4+TR8LFt7S5whPiSfopU3KSEQGVim4X0PCblkbm9qPQT1qLKr2PvJ3aDl+n1IJM1rr7VaE/Avxvii1tQq9IYignSf4fVb5l4s+Fevt3gaTVpvhbZkP/BWnOMFoQC7j42ZGdbOm3giCelVjWLJtk6F/z8heFAKEyMiIeyHoQwQ6gIBs5Rkw8Sx/iN2CaEVSxzP+6MF6xKXKbW9tBipTbBdj8v9dyAQ2rtSvlio7rDIJbZ2p9UFbmdMS4ft2/YgI8Hhy0OecZZVrdK7dZ58TXmiyEkcpo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26 Aug 2025, at 10:06, Brendan Jackman wrote:

> Currently order is signed in one version of the function and unsigned i=
n
> the other. Tidy that up.
>
> In page_alloc.c, order is unsigned in the vast majority of cases. But,
> there is a cluster of exceptions in compaction-related code (probably
> stemming from the fact that compact_control.order is signed). So, prefe=
r
> local consistency and make this one signed too.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d1d037f97c5fc76f8a7739e8515d7593e0ad44f9..8faa0ad9f461fbe151ec347=
e331d83c2fdc8cad2 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4182,7 +4182,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsi=
gned int order,
>  }
>
>  static inline bool
> -should_compact_retry(struct alloc_context *ac, unsigned int order, int=
 alloc_flags,
> +should_compact_retry(struct alloc_context *ac, int order, int alloc_fl=
ags,
>  		     enum compact_result compact_result,
>  		     enum compact_priority *compact_priority,
>  		     int *compaction_retries)
>
> ---
> base-commit: fab1beda7597fac1cecc01707d55eadb6bbe773c
> change-id: 20250826-cleanup-should_compact_retry-9c6b5cdf8d27
>

LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

