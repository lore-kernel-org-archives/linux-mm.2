Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4D70C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 01:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F8576B0005; Sun, 12 Jul 2026 21:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A98C6B0088; Sun, 12 Jul 2026 21:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BECD6B008A; Sun, 12 Jul 2026 21:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5ECEE6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 21:33:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3E69120A52
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 01:33:37 +0000 (UTC)
X-FDA: 84982031274.09.CA84B0A
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013058.outbound.protection.outlook.com [40.93.196.58])
	by imf24.hostedemail.com (Postfix) with ESMTP id DED4718000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 01:33:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CJ3zP4aR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.58 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783906415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9Chl1jmTinEjPlMQGy5sPGefRRODPCqA+9cJN5pVb4=;
	b=pHl8V8WuVi2V8C1XN51O+3oMB+U5nyc4EHl7NA2EkSGB/2hGGimk6j0CXSs823RxSg/F9R
	9ltUbbAiJ8yMZEy7FHQYrFtaTtXKupLeFp85v45mWwbGuTSPOQ1RmIVvdz3KEvcDMhzrp1
	8xH/H+6hJe9gKt4ls1b/4fu4T5SX6eo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CJ3zP4aR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.58 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783906415;
	b=WPIUFvzxF+4htJo7XFH38kVpHvaShTrRjGN1Z4Pd1NbtinrvKtM1U/u/zhqADCarHFf7we
	4bZkG11RDR9879ivC1EVHRJPQ/Ym0nFQZibP1QZjYuDW9C4J7ghR3dVFz3nwOVcmZWSAlV
	hpdUfsWoweN3CW/jOfjbD4CJZJPoAJ4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VK1fetn6bnQwXElkGUGtYnISl+W1a72vqbHXVsbP+a8hcH6veuF/cvlSKBccDj8SrOfZQVVGBSSsaPrEPZhGF5/IKwHzY1OQZVTH6JNq4602ESUmj4c797WB6FpuVMnxbKSadYElTw+CN1pOci5Vs1kT4B3/Ro/im2OrCMsMYredI8itJl1W8J0foX4vooiMJf1lFlQNF/lMQRALaeym/UZoFgxXsZfenR1pSU1A3JzdxlOLhLcUFAI87HSiFI/h5tIqIGYumpa/pdCr+lW4kdz1HAlKSexDmsebSmoEc5HCeaB02StHBaJ3+BJJFCHlhFGanmu5a+iZ+W/VkPE7Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9Chl1jmTinEjPlMQGy5sPGefRRODPCqA+9cJN5pVb4=;
 b=Ih24pvmZuw5vBnaDtJyq+JEDlLDi8/xxFSYkQaWUtvkVN0TBKZ5srV6FettZje4i9zZDOqtWWxXhpWD9ZFeaOfYefYHxxIgaX+YfAkUO6/15zRZfjd7OPetQthZdWvo3Cci9cePFDFPuKvQplENJmhKFAFDJMmTkgL/0kNt7fLzy+jtjSrtzgBAsAqXuCP6gDXJvx7XyJutDBIXMKjy5TU0mjvNIsZiamMvSApC+sG5YpfTTdZWQLMrBEEIDCDnUI4tYvCm9th2xuDshm991/4ObYdJFNcFvOFNtQIZXwJsi1Bs+a2dJSFoc5lvWeFNypyikGXkYExb6l/hwTuS1mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9Chl1jmTinEjPlMQGy5sPGefRRODPCqA+9cJN5pVb4=;
 b=CJ3zP4aRVZ/drGg1qckr6XLdAu8nzFWgz3eX1g1sDgSUr2+trDopy1cv4EPRJCbpmkRCDWcz+Z4SpEO/JFhpAp64cFzgs8C8SLlVX73EYqgZxpPHPnv+aGD6v2baB5Zq+Ir6dFUUInvpmgeyFx3+3Lk4q5yAjo0phOVIUVuLB5ujXxUPWeabZuV9xRcMY+nKPB67D340q0CRJ8AQ6W/l3vRkjbiaNth+YKsl7fXwDGTN/+27+UGyCBd78MZuZ3Q1B3jNvxy/XWaBodY8kn+mhqEd86cFptOb9cNaYhd/N4In7GUo8rDzCMYXBx9O00aIUzb1ZH4++tlBMCGL3PO6uw==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by SN7PR12MB7300.namprd12.prod.outlook.com (2603:10b6:806:298::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.22; Mon, 13 Jul
 2026 01:33:28 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%3]) with mapi id 15.21.0181.014; Mon, 13 Jul 2026
 01:33:28 +0000
Date: Mon, 13 Jul 2026 11:33:22 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usama.arif@linux.dev>, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	david@kernel.org, dev.jain@arm.com, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, matthew.brost@intel.com, 
	npache@redhat.com, rakie.kim@sk.com, ryan.roberts@arm.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, shakeel.butt@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v3 0/3] mm: handle device-private PMDs in walk callbacks
Message-ID: <alQ-873fbNk-FA--@parvat>
References: <20260710105557.1987433-1-usama.arif@linux.dev>
 <20260710165348.cab6f58aa81b30e34d121d0d@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710165348.cab6f58aa81b30e34d121d0d@linux-foundation.org>
X-ClientProxiedBy: MEWP282CA0083.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1e1::7) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|SN7PR12MB7300:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bccd28c-59f1-444b-74c0-08dee07ebd36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VYNZnYhhb3HEIqQMIBme36uH5m0O0SUtRsijONUFLIsds59kZtnLFbOxLMpu2/2PndBzIXhnsNdo9YEOr9HMbpbLaIbX3sa7gXnR7x63MqQP+EOXwUjyALes+rkr4nvhpZ5sndDQ1cNsJQZ5EPZNO35efK+wq5M0LRZq0g3vZC2ElZRuHOXIJ10KnhuxyWBnq5Q7fJvaUf97YFmJYHv6e7kNlFfgnySPKGROpjfP7HFEgCODKCvUu13orTGE3mLFGAvsLaloa1lBdvBHh65t2EmC2od2eps7ajX7WwLxZbCHzaX525Zx2cDs8FC08EfqoovTr6b+0p/+ey2IRYZ1IqR4CYXzdUqeDX87oH3g3OtL1qC64IjCpx58r+3VxQSd3lvBFTAMS3exH/m88ecRnpnXzSDfMREwOUO9b9CVv9QUeM177LsdNXAO5PnWK2ygQrhPGxaFas3XJApeP+Gb3jEIk8K9G8sdQx30Zha4cbBPspus1a7kApFy/FXV8bapAHCMinowQ1RxCAgUqEWiiZajiwyZujiwKrXWEemKyRggwnL6fuVwtdH0Vh8KBniaAPI36ohYCaKTZV0Wu+1kxYh9E95uwFgLETe607M2UmReqD9g16dxP2ucUCUtekijyeYZlgvhGMr5BNKl66cjsu8kcOCdLiyQlPXBSdAQzM4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ynyp1zq6OMXiO4gMpka2HiC6ge4lWq/LKMVLvmvtA6wHS1g/HHOn2E0vBsh2?=
 =?us-ascii?Q?7tZx0SJ/nVcguN+Aww1v1xiVQhMHL4jy7a9+/QxHWlpV2fe6LWfIlz8Rn4N+?=
 =?us-ascii?Q?DpAAjywXKxrwgw68TfqPmbLkVXcNot3tcRzeYCSeSDF2MARvNLukUoxAKTh2?=
 =?us-ascii?Q?9+CAOAcw9rq3oKg/eI/d0V7jzcPMrnU/d5XBTyyKuNDAdxPRDrX5gCoGQmdP?=
 =?us-ascii?Q?egr6fhr7BSZgxjisxJxh60TDkOKLva0B2lGv5BWbk0VmbaWR9j4bCxxTcFS8?=
 =?us-ascii?Q?5wE6zTC80EC5gFanjXLuNbb/KvYQ7GPdLz84gSGAWXe9DaeOD1vlB9qQCotL?=
 =?us-ascii?Q?GJm70TjBbH8uvPjkTUui58VEgH98oLwCmdtRPF9ZnB9ZcWDtGGcuJG/nAjim?=
 =?us-ascii?Q?poUe1vUUb1ONdO3/o+8m91unCF1xwDjHHXxZr8QPA5osxGu2Vy6Y5ZtbSapy?=
 =?us-ascii?Q?vXIC+kXKMJfPhocxa7EqL9x8qpmogMrscQhA02omCKy+VcgY1oetQmaF/NXY?=
 =?us-ascii?Q?sBwRTdyf8l0b7H0gZeQt0rI18AMaUOe3YicLsoijWqtp3CZtgKW4qyjZVAAO?=
 =?us-ascii?Q?rNv2LzUZjllIwqX9XtLgvhNBfszHeLuCYLgPiNRyHcXCe7RigaUnH2roawE2?=
 =?us-ascii?Q?lWuX3ieWhKCfiOUKe3dcnvUKyvmAeBkPRZjeYH4VPMbddvPN8T1ji7B7AmXT?=
 =?us-ascii?Q?qJYUWSeOx3AeOuv1w93P5G5TKACni6UWLRxUXJl5FunRln0ntU589ZKsHLAz?=
 =?us-ascii?Q?5+0pK4LCzy8PvarpCVWnl+scwd7TDAEgO76KVMT2RF096J7wvmStt3vFlKfr?=
 =?us-ascii?Q?cZfAVrFxFHOJ/L6+4ktK4KDq9dbJcqr2bAy4ESum33PaQ9hb8Bnl3YsY+Nuj?=
 =?us-ascii?Q?2V154hQsSDN/dFENzE07ZyQ+6ncCazZp//zXiAtsCDFAPYFwXzT8fVVQGmW4?=
 =?us-ascii?Q?pvNmqdhLsZ9fbYHScWXR7/dLj/HPTqhKHJRHuSeaExQt7QDKwYqbzlGqqdCg?=
 =?us-ascii?Q?HLpdSqP1muxbLw/H0He4c80/i99gkXe1iSdWedyjE2/bymcSUW9YNk5lLchn?=
 =?us-ascii?Q?9lkd94DnnJ1UB5lTeEC1uWwKaVvWVK4SwIzFSVe6ud7kIiziPx99uD5Z5YFm?=
 =?us-ascii?Q?HmIhDicYGQ21emDt+6boH9r6CHnU1vJHppmjh5ESCcSsA2RNFK+OEvrKZxwX?=
 =?us-ascii?Q?MBQhU74gHhO4LA8rOYlD6BJ6ZfPnZC0o9X6OLjVJmnTLTbDKhOfLS6+rhFll?=
 =?us-ascii?Q?n7Syg1x7wsEI2hPWEgRext+gdrdBxu+ss5K9J364nHU2PPBLBqHotc1L03H7?=
 =?us-ascii?Q?Xnnhr2K8/pSfg3c/pktVgUas6U42FQpZOubXBfaW6JQyntkTn5vS+CJPPrh+?=
 =?us-ascii?Q?un5P5fpp+WMG36ZTxM43OSt1Jz0+NY5DK2BwB9vE6ZUegTsz1TeatyAJEO9l?=
 =?us-ascii?Q?kZLHTGqbLO4Mri9DGeZf2owvbn8Oi1UbUqbXyzWLEIlaWiua8lGwzCuxm/bG?=
 =?us-ascii?Q?PItfZZQedE92oD1cnpc3kwO3OC5kGqwI+omt1kDen1Rl1L/758SBbrm0ngDf?=
 =?us-ascii?Q?/9Uv6UjixsptWC5juJDL9Jz575TwRy796sru6AEURmkckVM+IVJ21YdJjIxI?=
 =?us-ascii?Q?CbB7uqMmv+kpq9EUx0geTQPPYYAdHwdr/kWiR8zYtypIEeTfNHaqn1M1Ys7Z?=
 =?us-ascii?Q?CVXnWGW785fNCil/wYhymEbdcdqxkyluJ7UKSwcH6fj/i72aINIgCexJWslB?=
 =?us-ascii?Q?BKRttCjdbw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bccd28c-59f1-444b-74c0-08dee07ebd36
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 01:33:28.5644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0d125ph+Po4pCksKzmwQ0dxA2dezcBzJm0wWA5hUFou5DPmxOJ34tgU413rLqd2hjGFVbmJxn+qOklMxLwFdiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7300
X-Stat-Signature: m573w8emtcgmur9jd4myip8wngo51w1y
X-Rspamd-Queue-Id: DED4718000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783906414-906439
X-HE-Meta: U2FsdGVkX1+TI+VzmeppyHjTPRko8hxzPqu8YZeE0oWbY9b3LhM3KeSH2LW0ugCwnRb++icOzFpko4N6GJciAlzbzF96TkDbuFrg1enxseqJriudGoBYZpO0clkvcADYA0Q1I3Qu0WMEpNmmVk8TIhgH7zYMmGye3vhsLUZ6JrNUVUSvEAxYEBh0gP3Lr022uJrMk2Kb0lRlJa0L23Y4Wo2CmUHw+fHJVaepLb0Sb+J/rpTLI7PJznnV8HbgtDpEDLmrhnGlyVHRTrLTrWvMawz3JgYBOVfyD0ey1No9MjQU0lf0NcUyDRMZTVq1O+3oWc9TbVJx2ZF8iSShP5PJY9yG0CyzHEJbqZApMokZxwGZWA0P88zJfjpfHla7oea9bDuo+c9dlyjwA181f3A058xucJWRr2FZ9vMjBIweQb1UfzCOXB2A+V6Q5glwKXxPm4Cv/5F56vZQXXgb1NglUxrhF2FeFrah8XMUoVnGRpQMV1UJt68Huix61+pYP4oft5YWJZdTjWS+N7XT7nYtgAZARWvX85Et1t1aN/bNrV33I7Wgh+oLIVfHsTCf4XRTwle30M6FDZvg0uUUIXD1xFwcrToEpUGTYsgCc53woePieDa8d3A2Q6HNvV5gBNgr5JWnrOcLho14+M1EjYLJKDimImWR7Sn1KFXWKZpKwyCb8p727lPv8x++gYArPbA7bRG3bxhADVBsbKSsgTAB8jYPueP7+M8qcYv4pgWFZgy+0GC/zt9RYBbPflG1sIsucJUkVHnSz9j2KlDGfzq8bXSYN6EFN4qgWW1v7mMZkvGoZxnqSiuYSwMZYWlbyktT3OCO7uKH7Qx+SlN6BAR4+4rfpcaatgJgaSv58CZ/n31KSaiVKe9SGQXEeOHxwRj2y9ChbweOw+XPgwavufHy1eqGHpGBtuoWGs9AM96sYJBCiJOmDyqv0b0zBiJGMqixLF1dpBq1IV09uRHZ8IL
 m/yJRpXW
 bugMR6bcP7rQO2jAWlMbnAFFmlvUL7b9i9MM9LF2MjkKdi/mPhYkn+CckDSDRl7swNwLoKoPN5x6t6bmgxGltCStY2AlliOfWChjBp6I97Kbvah1EU5zkPEMAOtwzyIUAWnIfdOfnnkPoyN6YBbZO00y0Vh9j/0z3GLgvlY/I+Bp1J6UlPTwiwpYpupGP6h/Dt1s+rJG3PPerSmzErit21UHTLQc83CPFpVcJzzCg+5ur+Zi2OYF4Zug7xsrLA47QGcQXbZH9XzD8roL1UQ2byl/aFoKIvBYBpMlWqzg2a7TrkgNmlYPkgJ6QbljNOBxJjKQqu+Pja3DIVwUaI66nkeQ5RTznCNkL6G6idsOW2CIlrxfMADCzWM7ww6uXigHyJj95i3JWV8tRA323vWLXiILL02NK4JoPC//+R8LRluRRR65iCvNnKf+55h7fCvUEseJwsdFLOueiWO/ow+rXVWUXT8gVET8UEE7c6coxCo9mp26gTkIck7zPEaRsXwYlSd9DoKpL1yjc+lSrWlmQcLfBH35VHDW/hC6l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 04:53:48PM -0700, Andrew Morton wrote:
> On Fri, 10 Jul 2026 03:55:20 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> 
> > Since commit 368076f52ebe ("mm/huge_memory: add device-private THP support
> > to PMD operations") a PMD may hold a device-private swap entry whenever
> > an HMM-based GPU driver migrates an anonymous THP folio to device memory
> > via migrate_vma_pages().
> > 
> > pmd_trans_huge_lock() succeeds for such PMDs (pmd_is_huge() returns true
> > for any non-present, non-none huge PMD), so several MM walk callbacks
> > that used to assume present THP or migration entry are now reachable with
> > a device-private PMD. The results range from a VM_BUG_ON() firing on debug
> > kernels, to an oops on a bogus vmemmap dereference, to silently isolating
> > an unrelated live folio from LRU in the aliasing case.
> 
> Added, thanks.
>

Thanks Andrew!

> I didn't add these as hotfixes - the Fixes: commit is somewhat old. 
> Feel free to disagree with this!
> 
> Sashiko went nuts over possible pre-existing issues:
> 
> 	https://sashiko.dev/#/patchset/20260710105557.1987433-1-usama.arif@linux.dev
> 

The pointed out seems plausible? I am working on some tests to catch
more errors via hmm-tests.

Balbir

