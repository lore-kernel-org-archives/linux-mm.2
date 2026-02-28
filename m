Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FF28FD0045
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 23:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACE3E6B0005; Sat, 28 Feb 2026 18:07:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7B8C6B0089; Sat, 28 Feb 2026 18:07:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908896B008A; Sat, 28 Feb 2026 18:07:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8B66B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 18:07:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C7211C281
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 23:07:12 +0000 (UTC)
X-FDA: 84495403104.21.2BF5AE8
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 76631180005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 23:07:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VGXBbKPK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Ezg/kazO";
	spf=pass (imf06.hostedemail.com: domain of martin.petersen@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=martin.petersen@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772320028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7YaqEKUoaTNuSIdfUPGTpPEtauQ7HK2dA2vXYHcioo=;
	b=SfTbc7H9eOfV46yuMiRpiuf/bnTPtooLf7IdFKar4pnBW416nfm1o4Qv7ucDMcafuaq127
	n/906uCGrVm68MQtdvk7p3erwixVabk+s9wIfQ0vqfiT4HNvmi+g1pfxumNl0MSdgRMmcf
	o7UQ17l6yHpZJ9TjklQykrG7uU0sxJw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VGXBbKPK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Ezg/kazO";
	spf=pass (imf06.hostedemail.com: domain of martin.petersen@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=martin.petersen@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772320028; a=rsa-sha256;
	cv=pass;
	b=kH6q/SbxIuCvXaph1FrLyzG8+ejQyWHhFG5lq/C4bEXtUM73yV5fb9GZV7zjT1xq8yeFqr
	c1/0YQv/fYAyyavJG7DKwhR0MQ/gk4DCny7RBxscWx1qqGqPpV4Z6bD52+4ooShHj6v4uG
	ivVrtGeAkjGIE+7MWsO71TD087UtFog=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61SMp62T1623871;
	Sat, 28 Feb 2026 23:06:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=u7YaqEKUoaTNuSIdfU
	PGTpPEtauQ7HK2dA2vXYHcioo=; b=VGXBbKPKxr1sag8IX2iwaiG1sunWM6pNTM
	t31qo/gjcLnnjUilYgpJlrxZo10fl5XmYNcc0rlNrxsQjILMWvLmBAncLYRMU4Yy
	AcnusvTGrOveBcs4djuiOBvaYd7dc2WLJxsuVbwCbZKecb+o6vZ8cuy5o7TW+4+3
	gh9hF+NF6d7Vr5PncPTZXNEYdYnQwIqaEH1YlnjOGssqRdpHY0wFfj/JQN2NalYB
	LNzQS6Bj3TwlJ4CTQr9YjHu3kKJY0N4VyOAG/oVC4DEVDCSQOjVqDg9x6aahUZqp
	tFUqrDVM9mnuPd7Ffuv4Y+FVG1gbioc7tGKuoexTMzQj3A2MPx5A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cksg80mkr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 23:06:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SI4nXc034757;
	Sat, 28 Feb 2026 23:06:33 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012042.outbound.protection.outlook.com [52.101.43.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptbm923-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Feb 2026 23:06:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bsy4Amhua3wRSQqQAOjiYfu3MuaOaMTpCxUUBlK30hZ7CiTjAGvzdEkCh4CUEMO3MyXKr+CaWh+9373C0hTjWR/pM+oYQRddk6APoASgYxLM6Pjw5BnU+znKv+48/8Aq23Xfya/bZmZXw1x28YoYxRURyZ4BWdooK0GIuT5DU5OUndlHbpGoVS0wHTBICYJzgstAiwr6d75iVnBQ1kXhpfsA69elc1GQnfmNtcPIVJlt9nYr7ZE4tQ8/vr4uKLjUtdy5TzoH2K9Ht7CDb0Rgv1kEUglQpWK0Xyv+ya4VZtEhqmKtgbG/X9oQSXdDlYlIsyaYiRAT6p22JN3dj6dnEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7YaqEKUoaTNuSIdfUPGTpPEtauQ7HK2dA2vXYHcioo=;
 b=E8+e6Koj5TUqDdW0oqe0a3IKAruvfQNZdtvCZN5L81Ya+8tkdpuj7FlbgHmATcEDZ5dpJzICyPKfMTGuDDgOWdl4umynnzUTenPqw1OZ6OH1lUjZLqp69X4eoN53XuFFURYvHGle0KrjCmjOyN92kE9IMHtq5ocncaduFbWaE0FsaB92X9miyQFjUb07S5BbByeetIEA5ZUGrneW5p6vh9boocjWoc6ggsh9twikQBrvXrx/BAbvM0teCfbbvY9n1yelLql8BXClonFr7tobBHjwlPh4m11t8RqaYR4BWf28CgfaxPbTCWymmmj1qO8M1xYu8yrwba4/3kayRPJYDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7YaqEKUoaTNuSIdfUPGTpPEtauQ7HK2dA2vXYHcioo=;
 b=Ezg/kazOQhf11I/OTY48SzO/KzqGCvQyCWA5n41is7gR2FTNuWJAc/IdDGZZj3A7/eSHzNRgibSBDuwE5HK0tSoKrp4NCQ0cUAKQhjQzGp49h+nnCU5f2HKx+pEzUAE+YVsYL8/xnLcInaCu3PyLKZlVChOk1e/O07tx9leA+xQ=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW6PR10MB7659.namprd10.prod.outlook.com (2603:10b6:303:246::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Sat, 28 Feb
 2026 23:06:29 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9654.015; Sat, 28 Feb 2026
 23:06:29 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Song Liu
 <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
        linux-raid@vger.kernel.org,
        "Martin K . Petersen"
 <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH] block: remove bdev_nonrot()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260226075448.2229655-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Thu, 26 Feb 2026 16:54:48 +0900")
Organization: Oracle Corporation
Message-ID: <yq1ikbg31uk.fsf@ca-mkp.ca.oracle.com>
References: <20260226075448.2229655-1-dlemoal@kernel.org>
Date: Sat, 28 Feb 2026 18:06:26 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0036.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::44)
 To CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW6PR10MB7659:EE_
X-MS-Office365-Filtering-Correlation-Id: 53b1a183-2b01-45be-fe42-08de771e0129
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	CjMsQKTL0VHrh1tYhxj9fmeIaR07K1f/36LbfoTsELnIEjR6tX9arQaCHS03k1Ic2metV+0+/2O/yg3Rvy3Z8YSWRuhzRRF9JB7rjoNl6ovym2xELhZghJovaF48osEn14elLVFIZh1RYUIGm0UxKxtczl48Tp5HWgnokVqSUczanZa3Hr6dO8jLgx+A+SGUlaNUwUKeqdlUtzkcY72lBs755gYw6tod/COq1z2Uutim6+JrMq/aGHMVIIMp/3Kgy0dynFgST/1gRWi9vcsCNgBuReuKgItv5Xixm3Wp7jYfkD0Df10vNo1++KGwXxPwhs9Jkz61znmU1Brgfn8dS7P0fXEhpFhTlYn1td4phduNdtuFPHjx6EBaJetJQIOzJAV5mKyLcjn8uhZEzoBU8rAu1uT3q3y47Qecq/GpiJKo0+r36KKzX3ar7z1o12/FKLxkTdCJqC85pdmVXfmU6uOQBpFgCIOE9lH9wJtncnohef8nw4IsqNgXeq2cqFO81TDrDAxw57z8AxRyD95emLX39ddsi6+rJUL2KV8Bk4nY9nYpKRUbAyo11krC/zl5KpnAVVkEq/2a99VtP5eLV11rXHld8nuykzwWPQH5tc5LM4i5k1UYLwLTbsdl9RPZ+BWpJDymRPqrodbQDXEpYaL4xXup0kzNt7/D5UjDdsBM4xMfI+0yYCi8ribYh1EKhnB4/Cb6hUj9feTJfZ52WZ0I1RDXKDCHyyYWTW1N7uA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?poINlQp0cwOhEdL/+bPXbT2IR93F7u++4lNzqul6ItHFBxmBlgVNxf3l+X8v?=
 =?us-ascii?Q?/zEsxm7iigQav+8YJrW29f+9kW8cZfX8UXJItzrGb6tbQQ7j+G3/NPk5lGTF?=
 =?us-ascii?Q?mbbGFcSThEynpOnHsETrVM0fB0S8eLOGBxjfFt6NGZ9VhPflFVmDNRE++T5y?=
 =?us-ascii?Q?uumMgBE5YH6B4wlcRleMITP/G26up2zZhiOy5CXAnW0OY//7wMPMfzwDFebc?=
 =?us-ascii?Q?n8CO+4Lne1VhABOGlsTYWSsqvHDuQ5YUI9lHLPezc9smcjzhz8wX4ZXspmTf?=
 =?us-ascii?Q?ahRlTHteQCWJxcmwx0zYm5O1XntLtmmPv/cq12WKmwOXMzf0JgwAEATthjig?=
 =?us-ascii?Q?4f/Ls87Eu8AVONtB6yWhZLhohIt8ntBmvWc8fM+qlrWvUPhb1PCgU1gGnt3l?=
 =?us-ascii?Q?kkehewYeytZjbUZ5csK7DAmoEsu7NomOcvxA+7h77jj3L2AjuD2hJ6u/VQwk?=
 =?us-ascii?Q?23QJVt1NyaNM3oud83j9jUwRURlbquzZF0t92d9dey+IY46HztjZdHhNHPtw?=
 =?us-ascii?Q?UBW6mruP0GV3LZDmpTcPrWFtbOVsMit/wfrxyzF4A/JzcZC3iq8FlQs1gYKd?=
 =?us-ascii?Q?4npZzFUGE3njGoWtZ4uyVUfuEdakWmUMc6E1AlzHIXA96PMWGlA648pQMHdS?=
 =?us-ascii?Q?wQWFY3FP3Q6SyFhER6o5Ozgndfr29goYlz+puMq8V5OxDmMYjtsoxK5hJBf3?=
 =?us-ascii?Q?wjdjJMhVVW1Qh68pN7tkA2X5H8SI08eU6PLozEonBkH9Dnvdqp6dkvL6dwPY?=
 =?us-ascii?Q?aucSjQh0++9WthklxcLMwv2Ijcpz8S+mwYrPTdtcK1apd07Dfw+BtupvekSW?=
 =?us-ascii?Q?3KFaPpjJRoXkO9p5cuzdQOI70n0XVgm6lYZVMubT58vy6PoxldpHX8GTukQ6?=
 =?us-ascii?Q?1aZrlMYF1n0/65Ga5Dc5ogN1WZPicQQOkeZZSvRaqz1NTgCkeG7szIeSKptT?=
 =?us-ascii?Q?V/C6EW2/cxCXrc02bsjKPaPgZeaP49r4+yjS0C6z/kklpSp8KxKnXfuje6SC?=
 =?us-ascii?Q?gvR1UaDplveTuadvHVzLwb0jWzoY01kaZy77eROkjmbcC492O2sx4od7sj36?=
 =?us-ascii?Q?PLcsMhQ8x42zwTErnqn4cQ9fIp8cghn3pqXzGfraERtueKfG4qi55OQricmi?=
 =?us-ascii?Q?cGoTF2LvAZG3BPQ40HPCAo7IEkth8UBAFJkjOt+/8wOoJQv4J4TuakLACJTg?=
 =?us-ascii?Q?i2F3SwkPGl1CuVk8JiOQowE1bcotWbf7BwvORUoeSFkIsRCMHxQJWZNYa3O8?=
 =?us-ascii?Q?e+QKSa3Yb8jPV42DpPkiN2bALJoRb0be5LUMBSNTkX7hwhZDbvZEEQdsWFB8?=
 =?us-ascii?Q?hzow4uQ2duT3/sqsr2hmK6BgqeUgQWrMdIenlS1GLMuJ9+3+FMpSR57b5jiH?=
 =?us-ascii?Q?DapcbmTe7ZBkjz5DHQfaStJSx38/p5DAZfCd7Rd8QIyQQUFVw1DgN4vVwQB4?=
 =?us-ascii?Q?zgiPokJmlKHClQmgTXeaZQtR0/Cz2EZOOuYMPRI93OULgPJoAggySj/wNUW4?=
 =?us-ascii?Q?LIcJFQpKbqAVsxviYExq6aevwAhzCWLniChgff0KCHIIeK85kmorp2Cia7m/?=
 =?us-ascii?Q?LnvSk5sRHoOUQ6ZtDQkLSWxYylntfUH3beQbBss31kG1qIxZO9GZJolNScrS?=
 =?us-ascii?Q?FJUqp5gboaB8a1vXSHZ/T5HEd07SrFB7PbZW9kWEvK6qvANI8Kbymn3gbrF/?=
 =?us-ascii?Q?AOBnhqZO0f/EO3wNnkaTf7FIjR78Rz4vxzPFrN3xiuOuWedqqERpnJtaN2Or?=
 =?us-ascii?Q?G8sC5YFcP/yn3d3Rao5T9bJYGLMktEA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Dal4dUQfnkRz4UynFrU13/mHqxX7t4KdW3Jjp0haqVamvTCE6YPZB2uv8Y9Ju85pGdbvITogXUweq4ybG1+GnAfpOercLmv3Z30OA8Y8AJ+5QStMj3lCib7BkVVIHVHQJZpAsHMS3X/F9UQ1P75L+LV8cTo+bmzSVPBmo8H4RcTlXai64m7fp+WD81WA+UEWt7xcsd/SegEf+SyrPiZByd1ygLov2kTTaGY+TNbQKoXHoncERm+eC2pIdU52259H64ldmVzoNr3G0K5GpAVHqicJVoh9eBIDX6d/xaSCyVWYiJ/lvwluG4eOTudvE0J2hDAz1hqfLL3vvc2Os14CA34DmsrVGEXzITGO5bqo6nQ/yFGl0rx7z2WPAsawjnJhOzFh2vCH80cdFqHmGXBuENkWzkJkQoajnDA9uZWT/S0HlV2HKNkckjbyqbjjy9JH7nq6hN+GM/Bfi5Nc3wHRBKcWAmR1TTHSOUGWEW3BuiGM/ziAw67ZBIq1WDtS/D05ZDdePgIvWtby8drtrdWzArUscyeZwaEaq7mfXa/5IfW67rFZcx4nQ3oTXiQJVev2RBL3wzx0ZizwSDCw1/3NXiyVU4hycA0YYYrgkP8+Zxg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b1a183-2b01-45be-fe42-08de771e0129
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2026 23:06:28.8485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hyT3j3vq4vN4u0bCSyxS8L2NA/aHB9b0pPI402HsfGL+nebFUgXl/tz4KhfpXJLYJvC0okUCrb7Nwx/FIyxYPlayUYvSMqyYyd5WcYCXgAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7659
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602280215
X-Authority-Analysis: v=2.4 cv=bbJmkePB c=1 sm=1 tr=0 ts=69a374fa b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=wrmydrnNtcTXJaWCz40A:9
 a=MTAcVbZMd_8A:10 cc=ntf awl=host:12261
X-Proofpoint-GUID: RCtAhHi8dso2TsurLMlOfxgsb1nHGR86
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI4MDIxNiBTYWx0ZWRfX1k/VdyluxSab
 57XNVqV8uRE4OpW/j1NgqUpsJZ4TjYOKBmQFO2ktC9HanFZJiZg/ExmTYWmpCVzZd9wM7I50HkG
 emRRFHIYq9bjDh4m+DWtI1xT23GXpHrDtLCK+UorgSDbWh4tC4W1d/YKIR+QIFIHp/pYTiAkB49
 4OOpGEV+3UO+fyoeCMMW/aIeP2VHCt9If1wTMCKmwqVqH58EvD6d4l/5H5hXxlAT+a7J5H2pnmB
 FgfZIxi1aV9r/OFBdNv2r3j1B2f4SWWB9A25vM3vy4MPYXc689MG81kYl+WjxiQHy+x9co+WXFm
 xZPDKSH3qzehf07hbvQkEluJc2f0yW2jmZ8xbfr9VHYd2xuJhe5R9lDsSIUU0hTdXJ8qJvW/JNi
 M6oyUE6vPtgjArNMBtvW6tLS9dRoUGIBgmzOhu1UpJAx6wUbJMXZmUFDqWdinBvnHZFk0pCKq2O
 HRo5xb2Kc9w7h72Iyw3LdC0NtkxJI/BOCDbSajts=
X-Proofpoint-ORIG-GUID: RCtAhHi8dso2TsurLMlOfxgsb1nHGR86
X-Rspam-User: 
X-Rspamd-Queue-Id: 76631180005
X-Rspamd-Server: rspam08
X-Stat-Signature: ycsdjarqsfn956ftn9pgotb3e6i5hop4
X-HE-Tag: 1772320028-705560
X-HE-Meta: U2FsdGVkX19v7KqkuZ6XtNZVqng7vOiyJ7W3k+n6v2EmIn/uqip4siU5uWVGWMjSbmZeOg3svxHzKGaYkDISMr7nInw7T2r/Q2qw8OQ8A7sKubtIk4ucUnrLMp8S+msA/Z+pNbFT6noa+xNo4qpY4FlqVsCiF+LWl2NM4LRlUPihmAbOwMGU+qEteM3+lRHRl8dPtvVInybsfucxuwlELAotvDJwMlWTE2vESKBRUnblxJE55b/RxiwA+Q2AjdC/d3TJb2XZAkF8OsTWeiV49BB8LdkbmXjCvACF9KPQoO6GCiMYLumcEJ4w54nElO9bL3vlMvLkzm8HjFUhsuelWZjo18GMabS0ClYn3u99aBf47IjfNU9L33f/wL1fTdMUaIhQGjiqsT23zSd9PjZJpQjxG/lOPyaV/7/C89TjOZnt7F4S8qDaUsJdy7VLN505jJlIdg8+kbdJrAiHTH9zrCMqy55Rkz0WkWlz8XPMnwSPjCE9GF1juuYlBx2UKRmEMuBnomjdIpqOzNT102gZDs/NrD9D3wcN3n0CXe8vlhQMnT2KuDnaorJVnqcJaQw3tzi8s0t04cxJqsrjeGwPDiWreZ89Uk/WECB8onAx3EDvjJtHcuWxHU/A6cdV22+Db0pahJstM3IqreLba3kyoSN7hmIBdZY8jLF61yL/PrdBYzFXo4IemCuCr0SV5S2nuimuNizHtbthA4ziGy8Hp7z7B/MI/j6rJ7mMQWY+RTVyNgtG0DXgERnmZUDwFgmOn7llozLrpdHDRfbKuhouc1/HcLuuDy4PUyNYu3TviXeDDqf87zJflr0i4RSSY140j2SALV8cr+iwJRnN/QT1sDW2Gm2P00chhYVWtT6vykBK9x417ektzZLnx2k4ZD5Q4jHpsqV+ffBkIiXugpRm49y0iwoXUrlmJnPfhsY7fgFp4rdSxdtLyPlMHxAm/+MuhGS3eOlPNEX1mmuxQ7D
 y+j4RJZ/
 ijRI9LUfMoxu7xhIwTnXWzy+o+o/QaqL4kqqiE739+BtjkY+78oQOIGSyXgS/ZXKvO3pBzfzfX8mtXbiNb0zLuVcLFOYhvqLoNrpPKoiQYJ0BkE8NVeIpMurYLAapx0yW7XCtYUZAkr7CIwnM6n8QN+gYvEWBYVerb9EdKq0NOC4WlXgDi+BEpWuMzGbVHaHIaCesM7xYfLH3Omo9QjE9F2XLGnHsdMqCK7zN9DvBGPev4XCk8MsuyBGvNk3N488i6SRSs6iz24f89PgpZY1+cDCLDuwEc+8ZsFiE2M5/snzrUcxpvS9klm9b/SIlddg3/hI6eXpJHVqtCcEipXQFvLlRgF55RnJcatIOOcbLFl7IzOHPIyp8w82UFI+2VDU7MpuTQLPVGDsGCtHyPB8iaD93dXgvDwxp57rpqKOfO8DddwQFoXFgeOcUoQpPbsWuo6NXJTpNcRSjfoA75GMPhlmZT8yTZMQ/0y5whZbXA7S/G8zg+4SzQliKVhJ+90q6NtpIle8CU4ydXrQZokPrId4g7RREPNWWgUwaAqEQCkt6ucp9h40F9akWHMinEi6nNYKamot3Tqm6dYOTE2vL/iE7/I0lV2FR91/PXUzpHCMCDYSVdGykZ+tGwZrSnS6JlzE0JbjBFjfSsZi2Eko7uCO5hCWFLLqS/quJ/kjlMUL5lobjUygfIIFbD3l6boHfLmRKoyo1Sd3R3mOSR0AiO79j8um5Iej0P0yMdanYP/qSdFflGWMkgXrAaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Damien,

> bdev_nonrot() is simply the negative return value of bdev_rot(). So
> replace all call sites of bdev_nonrot() with calls to bdev_rot() and
> remove bdev_nonrot().

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen

