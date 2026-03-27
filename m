Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4168010F2847
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86DBF6B008A; Fri, 27 Mar 2026 11:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844FE6B0096; Fri, 27 Mar 2026 11:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75AE36B0098; Fri, 27 Mar 2026 11:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 649C26B008A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:46:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26BEE141181
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:45:59 +0000 (UTC)
X-FDA: 84592268838.02.B49B9F2
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010038.outbound.protection.outlook.com [52.101.201.38])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7CFBA80011
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:45:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Puml56b5;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774626356; a=rsa-sha256;
	cv=pass;
	b=IXRvaIuWGtZVtUQs3vL3tvCpFUXpLje+q9/Jy6IrCH1brIjlC3onx+GNkxm8QLokwTXu84
	/aPAYQgfqlS61x9zoDltE6hLcxjKXp3k9B69PMeN0jB+XqDDIk20fVnC8NYVy+gCeqU2kI
	HIJikjiPGsHLxbTkREVAEf8rxTaucCs=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Puml56b5;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774626356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g4YTWwUkPSHhnwGuIDMn468tHzz8cWsd2I0uB8NCMBc=;
	b=nab8GYdaM7s91CpujnJhaKK3igZI6Po9JI0v5J5D/RFjtcLGUT23QgbivcAcKUR3RYdveM
	NwvptWCIJs0r+QiRYIUIa/pb9XrAm7iZCxPg31+1z8LkTX7uNxxztAe0zfBrxUlWaR4kRR
	Px5QpMCMssfvnWcYMzaEwWQexlxc0HM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pHtRdMejVR9/dThoDWOPjx38sZLQTegygdh8GBu/jK/OO+/smJ8HpLdXHgdnQ2Spwo6lfGsw+dh7iZCPBv7uLxSHGmYcnZdFx2Z1RAQZa3njg3aVEjsRt0QjXQtEy6zFpIlEu6zeGo8uQOpq0nB8huaoEfX+tA0IwJslO07B3RdpylX6VvQJtHOrRNd4wipDKeo07fUwX1EgoKyGkvnjnFUjkJRM0Ym1SruWaMIMxtZNwrTxvQXCJc8uKvjLNJOgjzaV0Xb2RyK3VT5SbXLWsLFN5PMppeBxn0Qhy2TC3gqI6wWYyd4gT2EdRkaxijJhxoMFDTP0QIn7kht/3/6bZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g4YTWwUkPSHhnwGuIDMn468tHzz8cWsd2I0uB8NCMBc=;
 b=IaC71ZDL2QfXA/SxU3h5BdM0OJ537kc+y9Cobc0FZMYjZYUMQf0qYNwmZOqvgbS6nsuJk4Xbe8VItQlZjZwjyQrADzMFsN3Z/MVkAuLeNXFsgUmnKD6+c9xhhPq2NE4oV67oRJiRqZwcYizocazkUk4+bFX0D45RnpfLfEF+3ZcpZRMrtLV2k+/g/YaStEWGIn6l6g7OOyELzQ0pv5x/XTQnxsE8rBKNfijk2iSKV6a7W7xxruUP0iYOYz1zoqLscVMcOotWikYRVfo/J7FszWwKBrcc1oGsGRkL6uIZ/XcfxXlTa1uEavTEllGlx20gwPf7RpnLlmSsoM1ag6pIbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4YTWwUkPSHhnwGuIDMn468tHzz8cWsd2I0uB8NCMBc=;
 b=Puml56b5LvPKoeIdyl0Hymn/t0ZSnSt5EB6ksH0/4tmtFFBGtmjH3KMX0V0rBMI3i1Ovlb/fm49s9vUuFHsfrFwnHGMb/D+BbYG3XAiY6KafbS7EnIIEo8ZbJiaM3YFYlQL6Id3mnJ/+ud/KP6exSUsW74lP7iAFHQ4zv6VZQHPCVHmJX16vhXAYMUAnIa8lGF9U1eg4VRXe6IpqicPi4c54GFEdEWGZe/MGtoSThnH4Al7QbjNLm1Ic4ugqWOIE4IIN65UIzZPE0zmwvrPWpE8rLBgvNuwQ0YHwCqa+OyVHZCMwpYn5Cu7z+M8Zi0fq55u8Hoi43T6RQZyopDDnNg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8884.namprd12.prod.outlook.com (2603:10b6:a03:547::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Fri, 27 Mar
 2026 15:45:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 15:45:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, ljs@kernel.org, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 1/3] mm: memcontrol: correct the type of stats_updates
 to unsigned long
Date: Fri, 27 Mar 2026 11:45:37 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <6EE7FA90-D90D-428C-BC14-9D7F37DFB031@nvidia.com>
In-Reply-To: <a5b0b468e7b4fe5f26c50e36d5d016f16d92f98f.1774604356.git.zhengqi.arch@bytedance.com>
References: <cover.1774604356.git.zhengqi.arch@bytedance.com>
 <a5b0b468e7b4fe5f26c50e36d5d016f16d92f98f.1774604356.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0142.namprd03.prod.outlook.com
 (2603:10b6:208:32e::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8884:EE_
X-MS-Office365-Filtering-Correlation-Id: f41874d0-88bb-423e-0c9d-08de8c17e655
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	D1D/ChrpJbbLeMS9ATb6+iQZrnE/ZaGf87Q9bDjT6M3yIGhjDP2vauCRu5+ycontHuGjNL6lvbVnyg21kq3dxoiRDNCJWKcRD9ngk4p1jqSa5jJLUAXrb/iAa/YluoqWdOZZ82LbXpibhmCADbCCtuVHF6pVqScBHgjSQWcm7lHlxJdUTaiQ1UKRKyxL4fnb7IVC50C3AghZtlte8epJ1x9+22b4bn0k3PX57MyZR6GudmYNrSwBP36rDzE8SKv4pwshaUMlYRlaU4bGlG2Cx3drxS9bQzJHY4NWnMEykYB6RyIVhxwkWtA3mOkmZO4+ky5IL7oWrMyRXJUtQkkXUWbAbrmEEH0DqzdZ3kHnviipNZpJPo8XS51KZI5plsXEp5ikC0pyjzDfck0s0me6sWtMRtxBa8rRC6+ZPI7br4BKc4tTQaz2HoXxU2/LDNqHFk/ymRGV8BW+IMla51PhEBLtlYMQOs9nVIxszO1KxJwb0MphWVZ2eKE+LqDKkrvn8J0e77fWqGyMzSQtzyT6OeVkpoq3AwhO/V7aCDkM6PswMsMbJLmktGdw8ejYmHAZXuCCI4hokFa6VG6C5OfOgEHfR7s06CpgOi2K48sZMB6zs1duyWo9rv3oqAGGKVGMqAjpZnHY0dFq+1IaTsBEWlwKDIEsJsSLKfdpLnzWapViAKhu4NDhTYnrnGZztmzbQ+n64cstgEN/ziqt7sxqDIxECO6bsVyQGcDwPzh/Ycw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R/mFiS+BhJwZNkJDQzCxwzGXV81naT6KQZ7Bfr5zDoRXaeTSaOStSEBur3UT?=
 =?us-ascii?Q?xC4Lo66gqL/FR0sCsLDeBCufJG+KXL72ZMcEBjYkLgGlN/IxpCmEvlV6XOPz?=
 =?us-ascii?Q?ZltxOHnCDUvWBZMIXR7rfBh6QHNYUqda6pq+uw9Z6ZB8cZOUtD8yWL3BjFLD?=
 =?us-ascii?Q?0njoNkz9lEFjHJmgB8RQU/fWpGykHaElb/pzVZcoTyKqMx4r/+SUrGUVqXS2?=
 =?us-ascii?Q?hLxv3yxo72fl7Zbmt2KCbhNM1JkmB24tnaBSMrL5LSPVsPuK4UEE8uWqM3S0?=
 =?us-ascii?Q?zbIVGvfBfkgjfDkMMgwfiz93OLGv7N4KLpAlu409akDcd28D5xNZzwXagUF+?=
 =?us-ascii?Q?u+zB5ofvfQax86w520Kg6KUsFUDnCpQGVVtzGqR3GOUmstDSPYqhWF+uZGUZ?=
 =?us-ascii?Q?sQgNpAvWTqOVgTen39tKDVoq2yMtet6onU5KTeI64YjOQmN+WdFaYfc6ZNGb?=
 =?us-ascii?Q?jIIvEhZ2RE+xcMzLc63zXIDAS/HxTq6Grk1Kd3gyRX6tcpDbbGkk5frpZ+X7?=
 =?us-ascii?Q?1WulKDvOiYdUOY7r4UzgrhucNJ44tIermfVhbuVLw3612dFz+JDqwBnsN04m?=
 =?us-ascii?Q?RiqE0ln7OwY6XyOTdfd2IjYXYsNHIq/sl5u/lIDqFpdT34xKcGQSc63oVDJe?=
 =?us-ascii?Q?kR20hLKQ66mRBtShzoBKjg87AdRHC6p8HC71NGg7nxcHUIZrms6tDESi0/+U?=
 =?us-ascii?Q?Mlf811vTW43dVi/HoVWKBopMf1FR+fl2b2m3LVlz9or5ssso+aQ8LTCbVm8v?=
 =?us-ascii?Q?iaTA4llFMGl/kt6q9LSukj2UZ8hl4SeVF74iA7FKmUbECbAk5T0es8qKORrG?=
 =?us-ascii?Q?Hd2j8AnzMyID574j5FNuVbeo32Kem74PWnp3GcGRkZmg184ToDi6QBUKd1rA?=
 =?us-ascii?Q?LG3qMswzj2Xtnr1rSdCw/VXmvv95rMYpARIYyhemhGg59W7AV+n+2fhDO1+9?=
 =?us-ascii?Q?MLLBJxXRE/EDQJ70j7QX1eAYQkUksk0JTVDLwo5hXNYqimaezgb/D4gaQNTI?=
 =?us-ascii?Q?Nr4qc2F4582/K9KfOgdWJkazchfBMjiPo6izJUVAMMqovFvhNR4/NvL50IdA?=
 =?us-ascii?Q?/tMzPZ2w+ZdqYssBr2d5cV0A1t9WbGHXj0frKkCpx03LLPEdZ8Rx9K2Ss2ht?=
 =?us-ascii?Q?DY+cv4djiWKBZP0ABUkielAm6Rldlpb3hawDUT5yheDLKN2EbpS2nWNVDsaP?=
 =?us-ascii?Q?+wqdejXVRkalwUg3D4NHsTfp2LS5IhfgyBuZrsm8B9a45MNFnbmmETgG6+Fq?=
 =?us-ascii?Q?6ffbKcmUP3yjtfuqZbMoqoQFdDjrEtx3v1DXNF+qcR4g2r4i9kTAW4t3Wezd?=
 =?us-ascii?Q?uA36L6Fv/T+k2ws00+cKiJn3bUNcesPZK98L0oWMHcscAqpFqqSyPGdlJCL5?=
 =?us-ascii?Q?klxzqxSXPMbb3foWxTZfeYw8Y29MkDnMX8Rm6rfmKuaKmTDSfoqEzquMKbZf?=
 =?us-ascii?Q?eliBI8tU54u+4fI8+aTMpbV1VXDTQboxQGt5z1TmyAvOVpXpJB+rvsn5U4n/?=
 =?us-ascii?Q?v/j7cwhkdR4nIFa+3BrShSuvnIuc7Nev27rmEGS6Y4kkt58QTQcS52r+x/Lg?=
 =?us-ascii?Q?DZMoAHfCEDmCfJgcKfbYAHVKn2vLFD1bmQNVCDpMYnTPUhLOXqrBg8yR2pnY?=
 =?us-ascii?Q?scX/rHIa5E5iqxoH72mHSFH2SD3GDmsg7aQV4sYsSj0BfJI0QaiCStKFAnWJ?=
 =?us-ascii?Q?OBLwuZAxAuxMabbZQgIAUDwngqR2nI2YXTY3jzqqdp1T+Py6UoHolYo7COms?=
 =?us-ascii?Q?uhMd9cy3qQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f41874d0-88bb-423e-0c9d-08de8c17e655
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:45:41.0997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cquwJ5NJMFIVZPyORkE+/Wk6pRg28fA6nDc9BDB5tUL5I8j9oYInl4AV+NfP3gL6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8884
X-Stat-Signature: 5kbsw6snjnmrykq6spf4wuqhawiq1o7q
X-Rspamd-Queue-Id: 7CFBA80011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774626355-665264
X-HE-Meta: U2FsdGVkX183DOJqi9uLs1AAa89GBLcEdWg1mSHk0oZ5JiqRALxY2BI30vvLdhuQy8yWTvsdSaAyzNYWzOxJIjbZO1IKN+z9Cvg5Q90J22J6jHXjX+BkDAd0OYolOySq8zULtvqg9HrkVFbLLpwBrXLK71kUsJW54mSPoETL+U6wHkCqHJmnXEUSpJmVtOJS9J99j+PkGsGwkddbRjXge92EQml472V9BQ1a8HFFFOZCN8z6zbQwUTWV6yHxq01KZV8WkBUw0IwFJej9CFp4lYC+11qihx/OS0l6wpCM0LVtYblyjvVgiISUlXBl04sYVR3qqLfwZJquCAA5kcRDvjGrAKvprPBzpRNLi2RvKKdd66Gg8djc92O8Gp6g7cn/GZn6w7KZLMy9WjXVrHdtJ9JnZ1Rr9BW/j3izj+NNJmvYSjagxPe/V6gGfixuFMV32qmNHOzfRS6KhxyUhT246go7kdaDYxLvIRHthSa4ssTrMZOyCgYVexA4WjIOqHGaKzl5EGUUWk/TJUxukIHoFHIfD19j49t6tG8WWaLVw6Ngb4yvDyb7N4PERVis7RkSqZUeDTnaQ8DruoJj8Pi8iD4kcAqM9A5l6ptpVrkDNWiIM9WPT0QBnqaz9ZgquEKe7u/bcagItYFyOinLywGBwRfXmcEnekY72kqlChtaiSmanRrLoGsbLgMJmmFABMg2xNry2ECI4yuD0Hx1Hzj1afinDOtcOrTHlaLV72xCAacwvn+lzT2Qq6xwZkvLzyoZJvFru/qVYP10HPx+E6TSMjpQaDQWJNDu52ES/sj3RGxLT7vzuZB9vHRQ74LEFrRY5MKO4PfUWEN1J3IxOTXvir14exqmAr0bYeS1GfTUCdTJrgNnv9T8Sj+hZue7LK6NfjDzYZIUyU+a5AyT2RMRQEGQBi8kjmXUC+b0I0peTKVWbfnfh5KXm5jO6GpTo5ADG9hLUbwQLgcGRYj+r9R
 XgU5oc7S
 jz30LE7HTkHCMfUgT4oreRLGTYYtqWlc4zILzTRFXI2YQwIcncSVoP/41EoETG+nbVeWHfgdHN0/e2SaCCHhiPXZT+RpAbISK6GKs6G0FHfM4sktBXGyzXs6eO6/R+bdy+EGFAYXj/Gn2TVosfvPjGlFJboHXWEk7ZzmoMAwXheKuE1kPmcm6NRD5T4Ng9GEBowQutwwsq6AQElnngy/Xgm1LrqhKi0KQ1xx15Lgk+HrLCbI9pjDgXReafl61k3Yq2aaz4C52t4Bver16vGx6KRwZXcFEe7fQ3QRe386AlwrdsHLMe0TYgQTR5WJne2mXn7yC96O6tkVC9bUS0ODbhaDo3W3WedMe6DFU11PGpn9NeQTMzD8qzJIChfh8PMfENyJdA73bVwzJz2mgG8pdGGyrm1il/mUTHwESQ3lw+UZDnXAu2KsMjZO+1b3UkhEtWr7b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Mar 2026, at 6:16, Qi Zheng wrote:

> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> The memcg_rstat_updated() tracks updates for vmstats_percpu->state
> and lruvec_stats_percpu->state. Since these state values are of type long,
> change the val parameter passed to memcg_rstat_updated() to long as well.
>
> Correspondingly, change the type of stats_updates in struct
> memcg_vmstats_percpu and struct memcg_vmstats from unsigned int and
> atomic_t to unsigned long and atomic_long_t respectively to prevent
> potential overflow when handling large state updates during the
> reparenting of LRU folios.
>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  mm/memcontrol.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

