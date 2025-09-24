Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A984FCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D5F8E001E; Wed, 24 Sep 2025 11:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4D98E0007; Wed, 24 Sep 2025 11:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15798E001E; Wed, 24 Sep 2025 11:03:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDC828E0007
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:03:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A1C4A11AFAB
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:03:21 +0000 (UTC)
X-FDA: 83924462202.02.B547181
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011005.outbound.protection.outlook.com [52.101.52.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id 65643C0020
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:03:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nuYJQQzC;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2W1HW0KEaqI8qf4RDozHIA5BIK8N8Dh5UATFp5EPlo4=;
	b=CGtKx9m33eAj5j1FdiA/gRp1akf+Uvwu6CMXO72pMg7DXe1LRhXPk0azBHx7EXODHe/STk
	cRLvV5mPSBeHrU6l4ZEQB7xnFTvi49KLkLWKpVdsQ6StDzBWTHszXW+labSTz6E0fMuUGR
	ENw+ewO8nyogXc+Qe7nBWzC5m7JNPr8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nuYJQQzC;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758726198; a=rsa-sha256;
	cv=pass;
	b=f3IIkkhN0i3L4ciCpah3YaE4J57xPB6VjkT8OADIaiRr94COugeyiOwH2qnnz/SdRYfFgd
	3Fv4V95Vn3rabVZ1eAwQiPlo/SiFDb6WJlR7Q5xK1DBrTs1PJrC9ie6dt5O0U2K/epKqsg
	IkmyCavuDvy3E/kmCie6YugpYSTF8R0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uv7JYPMVnAt2n8FIhb4fzsu0V00s93pBP0EDPYwSEDI7dLS4twxdksqpb6PPF5/yrqJTT3r6b2GW3JSSAGEXV+g2JZzDyIgdh0wJWulOIQ7snzkgvbWjB4pHWm9eMx4AglU8eg7i05UWJisuCb1nBb6y8o89DWTMXOamPOhXaKYi5yl6JWMieem8W4cP76yGEfbp4ScAaAMieQAjgbeBRnFayyXK/JxpWPX+WePltMDgfMr6ZPPWE/9r4myB59pjIdVnu3SakLND62ByNfvE0B1uKTfi7+cW5dbUqm9piYESJc/a8ymSd4KKZCuPEYFhCSA2fKtVQLwi7JHSgWVZhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2W1HW0KEaqI8qf4RDozHIA5BIK8N8Dh5UATFp5EPlo4=;
 b=RCNqIHWywbX0Gb32ZlbKYvRhZ217rhBGaRrkJ9UrtrpiZlOsNcnurxxGllmJ6Ud1rwFuTVdBUcx5NrIpDYyD4tsLDIrMDpEnm9yO6nGvuo4y72AAahRukMskLApjyyeQtB7dT/wItHEmsoOkhy01e9y7JCl+tE/homJOXQ3cjZ5OlnaNZETXzFVfTTBuQ+ANp4DBuLX7uDZIj8ZGuRwwBUNBHe4wdh4etxz2x2YsEyfC0inyKsnViN+Rpc6XAN2Ic8BjXv3nsiIlbx6B0zsLz3kKGwH/cHOAe+uFvTH1pjateH1sXKJMmfqcV2Iz8MkDn+ez3o+kMRY8/wBNPlLmTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2W1HW0KEaqI8qf4RDozHIA5BIK8N8Dh5UATFp5EPlo4=;
 b=nuYJQQzCeEhfKpxcfyQ/HGYd/QtNL0oxNC/8/rPCS2RgsDnFKB/lnpRL8LmENSOyVX3jEay6mUxQkooNI6wSjeZJFuhTrRiuS0o2P8zkMB9e0VgH3klE2HfU3AbTe2TqMWPElPcaBTIqHbInzGHMcmUv44mIqITfO/ATMZs3XNZhfC/c853yJfmKzrRdXnqT6mMZSAJD/LJp1QfhgvklTI4LCtVHw3NmzGn+hW0pOO0Ax2nZx4LBAkXKS1bTIBt8FA7BlKgbhr8FC3acMfsY2wmAarHfLitH9ht7REBuJsmaUMy+wY3EoC52pDI+lOihuJTOhzwUjxVd9jym1z2mWw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8847.namprd12.prod.outlook.com (2603:10b6:a03:546::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Wed, 24 Sep
 2025 15:03:13 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9137.018; Wed, 24 Sep 2025
 15:03:13 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, linmiaohe@huawei.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nao.horiguchi@gmail.com,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
Date: Wed, 24 Sep 2025 11:03:08 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com>
In-Reply-To: <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
 <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR07CA0029.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::39) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8847:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c149add-1c8b-4638-44d1-08ddfb7b7b8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ILaxFQJjQvFhdvgBHLk6XSpCLNanaGMiaoCqQ3dnkL1NIIe1TqCZxwX7sV92?=
 =?us-ascii?Q?89jz75PBS3SygBUNN4qZbGc16VC7cgr8SoJVNRelutF4dozF6cZ/roJ15WbD?=
 =?us-ascii?Q?0zTMQ2FP+ZO6kJh33OgwcTjnkdcPjk8fMPUYV8zqMPJfRa5BkMkPsyToWZ8D?=
 =?us-ascii?Q?z8xUNL3fxl+a9uaBCQvL6rRTlubL9F7TxYLzNclJke50fbLmY9LhQuRF/R5+?=
 =?us-ascii?Q?Y7mphVj8ZqcKkIlHJTP/kyyPpQap0kjqmH1f5jMzTPzH/eTtidDuDiSKiyes?=
 =?us-ascii?Q?DSgRFrKsmddvVau6/6i+3YI2sr5OVWsxjlXMy6x2CnEdxxhygRV96h9J9bPs?=
 =?us-ascii?Q?yERVZmZtDXSR/F2QQTtjVCiqCBlLDRjVEqNggDt/9kWhGcX/sPlVqBUsNXOP?=
 =?us-ascii?Q?lYmfuQKNBrKXfIPVJqI8aMP69nD6oeDtqaWB/GeiFf5qHAghCuZKRP9ptpNd?=
 =?us-ascii?Q?BVWYklOOF82K0DEJaAhDIOflolU8WSnF3nIjtpx0ZDOTapN7xML0GxS/DBAC?=
 =?us-ascii?Q?4CFqDT8G9fJtAwtPLgvi4oH3KY9Ldbj/3kwVhFSGoWlsCDkvZzF9TLAycNZf?=
 =?us-ascii?Q?VmIKrFNP44dsDh6upSv54X8NSco6FmsVVIyyeu6yaQMi/BMQV3+HzwYexSGA?=
 =?us-ascii?Q?2Al9Eibq4zMElMPhn12R3NnCYFLGoUks1FX6bxKOJ7FjoVnPypLDlpNxG6bV?=
 =?us-ascii?Q?HOKBNCWf79b/v0OzzUW+iPbingVUqDQiBlXQuedSgDYhZT0RD5AWP5T7uI7O?=
 =?us-ascii?Q?yIav0bNd/XlK4+F1lsBNElR2wm4auonzy6WcIki94cA3EtUzcf+9EvPE/lRc?=
 =?us-ascii?Q?KcHYlysjeeFB0t3aStc0KYChqgRia7CRFRsjfMz4dU/BYExloX8RgvrcChUu?=
 =?us-ascii?Q?sNZ4CFaQwU05mCL8bSQc9s4e5lPwWmCMcy64fGoNfRi3WTYbLlfQWB3nqsO7?=
 =?us-ascii?Q?WalqwTp/0lVfcvlQp03s40+xYOQJsfPlVg9YPw1At+kdMo1aYL2K5azLb59E?=
 =?us-ascii?Q?sGX6jgg7UV731gtMJDjGsU/hX1zS20xVP7v3dU6ArdFUA+GM3tM3YDbnBbEv?=
 =?us-ascii?Q?A+oo5rMoFLfoQ4RPXkk4+gmzVA6esWUzma0jZvRdc+/OY4dUVsLYXqmyEuMz?=
 =?us-ascii?Q?4Lggnb4ddnRbceW4pPUjx7He53BnwtIcBeDph1PUC5scoTeFp4sg0XEdRoc0?=
 =?us-ascii?Q?vZLH2A83fAUb7vFfFCSSnOE89JW+fulErT9/pkc835QSCPEqGrQ/GK+hq5mI?=
 =?us-ascii?Q?Zro7o8vgzZOXcYNhN5aEW/GL3arhUwb2huo4rmLtI3r3o8EGab3df0RDxhb6?=
 =?us-ascii?Q?FRnOX8mjSnb/YgjJdVIqV8ePnAmBC62Lsao0BGzk0gId0jSW/0lRI9skq8/4?=
 =?us-ascii?Q?YuwJBRn58OLgUzYhcsZm4TjqC03rY+u2WXMa1NjjvE8JLhMbMPOlwGpxxqyZ?=
 =?us-ascii?Q?1+hN8eWrBys=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?08ez8DRo9xUZI7Nn2sP3Pya2O4IGnMz/Qlhje+TwPNB3eDavad9Xn3zIcaKn?=
 =?us-ascii?Q?qWHs/4hAnZSM+tSCZ+BwCekvNTc/hihErBpO1bSGLUf3HPDJwrXSGDBa3PNz?=
 =?us-ascii?Q?ezQlr9kPMxd+BphiUZNr/0nTKHJXsQMU5OAg/7tbomef+TTledaDfFwtt+Jy?=
 =?us-ascii?Q?CZhxiBQjAho8RAgBB4cCqSswdxok2l6pT+EdVm+qxQdz13z4WLKHbm/9sYAk?=
 =?us-ascii?Q?60bwLOpcv0bvd6OdUSgtQu3gL02gjh99VIHwlCtLEmYsTWf18LOiMQHa4L5p?=
 =?us-ascii?Q?HczUDG1IGUFTUvOQQgCP8RBFhefCcM+t3l0CmQTWRTzds5b7x/KFOxLtZCFL?=
 =?us-ascii?Q?smHLxa7BoPvkBkqR79WZagnTO7JrSkk+BrohENcGcOQsxu26AyXM0lsSQN5w?=
 =?us-ascii?Q?jWFGXagYdkEIQ90t70LXGEBTx2EwB1oqZaZLbrVacUHbayQszv/lTfGOLe7Q?=
 =?us-ascii?Q?YlpYOQBEFdhk7p1IOO1Ih/CeYiU7s8CsArlMr0QrWWMtZaLINFdkCl+ree3L?=
 =?us-ascii?Q?W7/CEQdXBy4vLEV8MWypzwI+6VyVMnrK62wfpQ2bCPBq8c0FnLDrwlp6ZC9N?=
 =?us-ascii?Q?lDyLmv7wxOH2odrTupdG6l8cP5Bszxo+VBDFG2/7VkXpcK8Y4vLuQFF37EGc?=
 =?us-ascii?Q?x+4oxJr3Dpz4I/ci8FXEwh5pOJwpAwAjlNchgM/qT5S0uoAF2rXmV0pUZvul?=
 =?us-ascii?Q?UAUjy1AZmCmwchbjhR3jIL5S6uTK9YaJsW98nzyiwl44pCB5SFWy/MeAnoke?=
 =?us-ascii?Q?MRp8CSZjnoIDI8hUfdC387q18ES6FTrONf8JeRNfdZSH/7JME3MtRCbenqBN?=
 =?us-ascii?Q?zWFbfto05n/1KecGPzktWA56KrCUMe4eTzkF3DR4/qq7il6tCD6FigkYeVo3?=
 =?us-ascii?Q?dCc3oAkuqj+aCdLVcDtCTajCwxaMr7aKmZancaOo+13/zUVAg/E/GbieLXxw?=
 =?us-ascii?Q?hFFgJTf+TZk6eV/+Sje7tYEWTrIVjt9dipSftC/M1PK8CVxccuyfaojq2oPm?=
 =?us-ascii?Q?sLJrKJMPoCZVbNlrqjrUBtGZpr/5PnW8LOiFvnpOdSa3yXLJqCuj+wYymYqr?=
 =?us-ascii?Q?l9i87ixz5SXm+vFcfFxpNXvBhrR7i7sL70162+qoFJFRf/hHtZjm8ev4BfnB?=
 =?us-ascii?Q?HHFK1u23+12yD1UJutKT2x9J1Le0ElBRM/zh5p/FnQrz7dLL/66kYuVp/JEB?=
 =?us-ascii?Q?5TyPYWg5jKHLZZJ0+3v4Mnv1tRLiZxXCoFx1deo7EAF40M0kdytBeugIaXn0?=
 =?us-ascii?Q?tY3oCwpO1sUh2dntGixeIkT4nVgkkXlOq6+yf8bWPcmk42h744kTaGjDympZ?=
 =?us-ascii?Q?n96lamv95B4JXZKRtc5te85UQddYDMtq9/xUIBGo24UaGE01f4j+YvnsUC8T?=
 =?us-ascii?Q?yOUDNOHfJpkcTdR2aJAXzfzYliCKHRDDrTFq83Fv942QVBXZSde9/BtAlNar?=
 =?us-ascii?Q?roBRUKSTlwe740cgp3Pp5VCnd0stZeunoKiBRiNoA1sWQjac2EURZB5UHiH1?=
 =?us-ascii?Q?y7iHL4o/kyic+4Z5x4R30hFO8Mwozv6uKV/kkgjyfcyI7eIZ2ZVITdCYctHT?=
 =?us-ascii?Q?zZ5K9+XMRZwg3XxZ+EovnC4v6YfVOcpIWDScjSLJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c149add-1c8b-4638-44d1-08ddfb7b7b8a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 15:03:13.0069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DiqsqY/pVQjHF6w/PQbclHZEeShaCN3Wyy83Nm7N25GEw7yRFDlVshrI0dQIw4m4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8847
X-Stat-Signature: 9iqym5n7p8af5et164yob6u491ini4iz
X-Rspam-User: 
X-Rspamd-Queue-Id: 65643C0020
X-Rspamd-Server: rspam04
X-HE-Tag: 1758726198-505573
X-HE-Meta: U2FsdGVkX19YJfhem23FoVUOXLCx69QZqqdVwbDuckbE1HkGeEbCQIqIuZzoF6UIdt7EhMn7ybuTXuQFLXjXOHee8xsXLJOEBZpwQ7A99JL++g7yUujBNXa0z8CZDtXNf5LZkilWUsSvZj7Tzk+DIW1wDijngqTaodGQr7IvLu7QKqlsOeinSN3+aWvgp95cDaglIketWWUiUZIzEvgzcEtIXPU31jmpk2kaoLVSXn6QS2BhXuUGnuyElqufKNOmlbbGE8gegWb4MiRtob6xm/c/il7wLWqHXKediWajTvt0HqmKeN52AEzrAqGAklWz0XaaODfXPwvi6ewCp9gFyylqngQLd4s0Z6mceIadjsjryZKMlrUi8tlOqBOlvsUm2Dy07mN+gD4bFhOSFlgNbKevzZe5BtWMrMkSuTK1hEeLOVohZ/TUOaRHes3TbgpVd4UNmJAP5TsOHCVYVv/LqKGoqq85J8vO2+Sz6yJbhqj2R4nCOCe4jb8vEWuokMbDAu0vAmIv9gbIPIl8v2B/VPxOH8+lfyFjEMdfCU5kXEygruhrqLUiIxaFla6EjP3wIpto5F9P1eUCIly67SSO9bhRgOD39kxrpxbw+hGN9oy3pMh9ytUKm7x5e/35qBytSoFGKbzga1C1mo3I6WI2wOrHdHEN7qDvxpSBfMmr+5G9dKdOJTuwa+JtX4MFAuxTJJm4UqK0Rzc65G5YK/S0N3SeGVA31BQd5mgzJhIoegnRrb1ptkAE/LpJCkZOn5OIqwvBo1uHRBF3nIhT5gEGaApR813hg3jmLnaRDVw33n61JBR53ehurHfPgNwypEIauzuPBXvPsULb50tg+qlPIctgasJOf1LiPK+mEiiPqbc/L9a42w3YaGe247d1cdFNwBA7BI8jFMz9vsWyYvCTaI1RrU+HIWgrlvb17W1USBpOa33yMncV+bonB71LyhFX4OFZWYcDsuHe41BwWi8
 bsUTtp6J
 YDeTddvWfWpSChshHrAk4t5zvn6WoeFppd1DXosQkjT2YNHNQILIMeAG7fZOjEDP0jvd78q6OraRiPyZNvVZ+2xBw6Af9qGXt6W0TXlio5ZgOLQScFtN/9b/PG1e+5piZ8V4Rs7eZ65e+UMoPalFZ62vCbcdtSyyuEumWUHDf7sU1N8n53YKtuB7myei3zAJsycprj3VpIgSHFMx1tJPK+0tRqN7KtvmsOHxsI7fF8uq/Nk4NfJkhBQ1Du8Mk6+57L+Og+cDeHed2FkAY7k6356PIJUlx6OrqW/VV3UgLOzUx3yovV85KZQixv2VQsqfHcl9UuVGxRXWE+XWRy/WGyHf7nMOqhm7DJnsXrRA3qAuBNMhocG0Ev3oCaVB9oRZUEUQFoHdCfR+4uGlND9Nm06fhy3U+8J8pCNYAW2b/99iqFRGVU6i0D1bVl/7fRZWT+qQOypzTL/kMZWqjWTcOKQtRW8EY9WnMjRpU7ZfR7oun8vztG9iMgfpOK0t9FZKw8tbO6OAfk/gDh8o548IGENkuiSbN3nB9g12utAEzdrVI1wzDk7ARwWRWBglBzBkRMUDSgHsm3NVDBSxbC7A++NnHycHoI6MLvEUgYfZDz1lgnHmr3NKY3+8d8mOpAUs0ngQbM6a5FtAjITALX9emrf0RjYpdCbyJs+jHnCeBu37DKm/bMyCII2tknKC596ycvmnkp1nJOsGM09aGWWT5DoKY46mXjeZwpfFjIf09EtSAf+i27ERq35nA/k/QUK9XGIsw4doPiLD0MbyvIr7DNvfSipZ7maSCMaI/2NfO9M2owP/FuRE9JxzIGUE2vNO1H6x5JtiBZ2EHK2pF3IBbyVR82yVRSfejwC2DLYZS1xxhvGnh1PztwshX0hfwlBLq3BGmivDpjpdY2S8s19ioAHvbuP8/uoGjpBy5ww2WLcJdebeSj7tu+V+I7/3cQ+vaH/lLQm/U6yod5S3loycTMIBiUMxP
 DpWRvaXR
 9xDzT2VcySHPGevwvRTrb5eI8ZqgN2TTTWjqXd53kpcWlm3zdz5nm0o/GGpyza8xcBABmMpeSINI1+bp1KwCo9Aprc3/0BhW2wexOUX3fkr7MtSnwjalK8V5vAaaWIbpOevfacQfzfokIV1M6KDMOdlHjdEsVYtCVuhJARKQqWfc9kOa86bQhf2zN7EB9ORs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Sep 2025, at 7:32, David Hildenbrand wrote:

> On 23.09.25 18:22, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    b5db4add5e77 Merge branch 'for-next/core' into for-ker=
nelci
>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/li=
nux.git for-kernelci
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D10edb8e258=
0000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dd2ae34a071=
1ff2f1
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3De6367ea2fdab=
6ed46056
>> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b=
7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>> userspace arch: arm64
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D14160f12=
580000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1361627c58=
0000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/6eee2232d5c1/=
disk-b5db4add.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/a8b00f2f1234/vml=
inux-b5db4add.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/fc0d466f156=
c/Image-b5db4add.gz.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the c=
ommit:
>> Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
>>
>> Injecting memory failure for pfn 0x104000 at process virtual address 0=
x20000000
>> ------------[ cut here ]------------
>> WARNING: CPU: 1 PID: 6700 at mm/memory-failure.c:2391 memory_failure+0=
x18ec/0x1db4 mm/memory-failure.c:2391
>> Modules linked in:
>> CPU: 1 UID: 0 PID: 6700 Comm: syz.0.17 Not tainted syzkaller #0 PREEMP=
T
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIO=
S Google 06/30/2025
>> pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=3D--)
>> pc : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
>> lr : memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391
>> sp : ffff8000a41478c0
>> x29: ffff8000a41479a0 x28: 05ffc00000200868 x27: ffff700014828f20
>> x26: 1fffffbff8620001 x25: 05ffc0000020086d x24: 1fffffbff8620000
>> x23: fffffdffc3100008 x22: fffffdffc3100000 x21: fffffdffc3100000
>> x20: 0000000000000023 x19: dfff800000000000 x18: 1fffe00033793888
>> x17: ffff80008f7ee000 x16: ffff80008052aa64 x15: 0000000000000001
>> x14: 1fffffbff8620000 x13: 0000000000000000 x12: 0000000000000000
>> x11: ffff7fbff8620001 x10: 0000000000ff0100 x9 : 0000000000000000
>> x8 : ffff0000d7eedb80 x7 : ffff800080428910 x6 : 0000000000000000
>> x5 : 0000000000000001 x4 : 0000000000000001 x3 : ffff800080cf5438
>> x2 : 0000000000000001 x1 : 0000000000000040 x0 : 0000000000000000
>> Call trace:
>>   memory_failure+0x18ec/0x1db4 mm/memory-failure.c:2391 (P)
>>   madvise_inject_error mm/madvise.c:1475 [inline]
>>   madvise_do_behavior+0x2c8/0x7c4 mm/madvise.c:1875
>>   do_madvise+0x190/0x248 mm/madvise.c:1978
>>   __do_sys_madvise mm/madvise.c:1987 [inline]
>>   __se_sys_madvise mm/madvise.c:1985 [inline]
>>   __arm64_sys_madvise+0xa4/0xc0 mm/madvise.c:1985
>>   __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>>   invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
>>   el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
>>   do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>>   el0_svc+0x5c/0x254 arch/arm64/kernel/entry-common.c:744
>>   el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:763=

>>   el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
>
> We're running into the
>
>         WARN_ON(folio_test_large(folio));
>
> in memory_failure().
>
> Which is weird because we have the
>
>         if (folio_test_large(folio)) {
>                 /*
>                  * The flag must be set after the refcount is bumped
>                  * otherwise it may race with THP split.
>                  * And the flag can't be set in get_hwpoison_page() sin=
ce
>                  * it is called by soft offline too and it is just call=
ed
>                  * for !MF_COUNT_INCREASED.  So here seems to be the be=
st
>                  * place.
>                  *
>                  * Don't need care about the above error handling paths=
 for
>                  * get_hwpoison_page() since they handle either free pa=
ge
>                  * or unhandlable page.  The refcount is bumped iff the=

>                  * page is a valid handlable page.
>                  */
>                 folio_set_has_hwpoisoned(folio);
>                 if (try_to_split_thp_page(p, false) < 0) {
>                         res =3D -EHWPOISON;
>                         kill_procs_now(p, pfn, flags, folio);
>                         put_page(p);
>                         action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILE=
D);
>                         goto unlock_mutex;
>                 }
>                 VM_BUG_ON_PAGE(!page_count(p), p);
>                 folio =3D page_folio(p);
>         }
>
> before it.
>
> But likely that's what I raised to Zi Yan recently: if try_to_split_thp=
_page()->split_huge_page()
> silently decided to split to something that is not a small folio (the m=
in_order_for_split() bit),
> this changed the semantics of the function.
>
> Likely split_huge_page() should have failed if the min_order makes us n=
ot split to order-0,
> or there would have to be some "parameter" that tells split_huge_page()=
 what expectation (order) the
> callers has.
>
> We can check folio_test_large() after the split, but really, we should =
just not be splitting at
> all if it doesn't serve our purpose.

But LBS might want to split from a high order to fs min_order.

What I can think of is:
0. split code always does a split to allowed minimal order,
   namely max(fs_min_order, order_from_caller);
1. if split order cannot reach to order_from_caller, it just return fails=
,
   so most of the caller will know about it;
2. for LBS code, when it sees a split failure, it should check the result=
ing
   folio order against fs min_order. If the orders match, it regards it a=
s
   a success.

At least, most of the code does not need to be LBS aware. WDYT?

Best Regards,
Yan, Zi

