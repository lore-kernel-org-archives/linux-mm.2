Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AD27CA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 01:01:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DFCF6B0026; Wed, 27 Aug 2025 21:01:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490756B0027; Wed, 27 Aug 2025 21:01:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357936B0028; Wed, 27 Aug 2025 21:01:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FCC36B0026
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:01:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23BEE1DEB0D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:01:05 +0000 (UTC)
X-FDA: 83824362090.06.77DD5E1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5AEA91C0007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:01:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iBGJeofV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s7BzUjOg;
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756342861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sS2K0YNgtzLtr97rO9EXI59jp6M7W9/07jEE8Xximik=;
	b=0QscfmA8D+thSbwR1+PR52dIVHDfLdXiCzFS/zOiZ0YT/UevhZcw9b0FAuYzyMKxRo+mbz
	6/iy/C81D625Gcq9kInjGKEK2ERvv1EcqDNoHRQRFiguTiITsyQP6QTmPKxEeObtpHHqBa
	hhCVM4kaMobwGh8NrQG/ZTjOjzAjO2k=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iBGJeofV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s7BzUjOg;
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756342861; a=rsa-sha256;
	cv=pass;
	b=fv5jsXCW/9hojzq7H022n0WxkMfdFBecTGnc/Uwpv4djs4DN4b3VHEmncoU4Ytc1dgNykY
	ichfnJvgwsiDIatn+xnWr5mUYwhcDE/wQdWqt7t4nrmatz+s+y+OP1SpJrXWVjxfHO82qV
	9MrMaeDu52gVEG0QrRCTL6zJiTk8kTg=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57RLHKxx017481;
	Thu, 28 Aug 2025 01:00:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=sS2K0YNgtzLtr97rO9
	EXI59jp6M7W9/07jEE8Xximik=; b=iBGJeofVXWP+gwjbgbpuCaJtjYtjUrAk3t
	39gopIb3sM1O6gv3k+ydJoT4Cc4j/9cNiI+1HyjMSRcq85DBB1ogz/0Z/M9UPmui
	wWlknqPVsoHXzPNLJYHRuovfLgxOE8xPSjM/9zRr/zW1gmDUXSUM/T3Fhp31OzEW
	Uia2fTJ6TQCT7emtxbW7mLCfkwi4SBUMJe892MP//smzTYGB9FhijEVLAfTOMkca
	25GyJk+iidonEVFy7TyUKtwfwF9lxIAuSORlWuE5Wr9jN8GyxBOIREY4WfpG8vDK
	dQ7/2JRusV5j4maGuT+bqDl8yVuL40vuyGszQ4qxqI99PWU89fyw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q48eqnbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 01:00:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RM39jP005292;
	Thu, 28 Aug 2025 01:00:57 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2051.outbound.protection.outlook.com [40.107.100.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8bh1bq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 01:00:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wd2mP+y44u/pKHskIsgx6q6EELsVC4owWok6LB3xo+ZoqmoyCkLCJ5tPW31PEc15bDP3rMgnQF2O8+66OTJG4x4q/jM114AOaa1m9ngrzrY9Rk0fJavEr8KeXS9ECfAelZYWVKr8FSgPMRbeVwFq0C5qhgLZH6QX9mPBRGP1TfuXqul+0M5n+lqiqcWwVdzYO2ypbY8b+n2xmy6he6WfrQwrg7vac58uMzTK/PEL8m6oVnyxCJnQx6uT17WGrv614NQ0aulAtpg+HTNr/r8o4VY80+tMHaUHkcVOnWfol0sfpOfY21t0PD0r4EIurT/AbfNQXKG6wOkGE8HgpBILxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sS2K0YNgtzLtr97rO9EXI59jp6M7W9/07jEE8Xximik=;
 b=kzYHOmbpqAYom2Mlrid0AOAW7hfBK4yZc4fhuKMSYAZKMGt0WuaDrkpK6G0GmF9kXAIuA9ki4hqrAGbz3jf+IVVj/KZUQGT66hdi2bHJi2DQ5+oSgLFDbn5naQ/6oJz+2I6MviMAnjo09UChQIIek+P7z5oJ8mOg4c3DHoXyw6tKjZPz68mdTFffD4q78uL8pmMcTOL/rtNp7t/K/oVnbrip/wmtOjIRLvXCS/Qb/fDNDA6gYjZYYHbGVRu4PIhGr/7w0r+LKIt1f/fIYJgZ5VQ76Z1D3uygH1d92xCXL7HhwugwFxr9fUhyjGuCu4k6HdDtYoePssQgPaMw134tSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sS2K0YNgtzLtr97rO9EXI59jp6M7W9/07jEE8Xximik=;
 b=s7BzUjOgVFSscfYsKGEvispJn95/AnAVb98DAW9HRKXx8uHdt1cgi2eCdhGk04cm7lL7dZNVi/WWJu0MQlWgBGf/Qh+wIDk3woLZ4fDs5FCRVRazXmJRAL5/PH5z6cwnH5NEqprP5yGfoWxVA80eOvL9XKgGdLTIec0+1VWm1wg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB6750.namprd10.prod.outlook.com (2603:10b6:8:133::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 01:00:50 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 01:00:50 +0000
Date: Wed, 27 Aug 2025 21:00:47 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] tools: testing: Allow importing arch headers in
 shared.mk
Message-ID: <zef56rw4gqlj4ct4cdx4eohnmtvi772bal5yemw56rgtd6x6sm@5sireezjvfjo>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Brendan Jackman <jackmanb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
 <20250827-b4-vma-no-atomic-h-v1-1-5d3a94ae670f@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827-b4-vma-no-atomic-h-v1-1-5d3a94ae670f@google.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0282.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB6750:EE_
X-MS-Office365-Filtering-Correlation-Id: 50de5aba-241c-4f55-d84e-08dde5ce546b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yl8MBCumSWMkTw3pL4IvcArxtwpmb9cSy5qqy0yzTXn7ex4QhsCT87rUWuZN?=
 =?us-ascii?Q?FLPgp+b1VIWRmawPO03P2JMuaE/4IGhQbUzL5iIamMSJr6cHHYetUNfegs/n?=
 =?us-ascii?Q?ICRfRvnrck5yeIpM606ObAEkT+exbEON4cDKKJtyEesyjOUh/HNVJcJBAt7s?=
 =?us-ascii?Q?sHwS29oEUa6f0eK3pIkJ2xgulFSGbf0IcN6KJQORdqmKcosun4YsrBpa4tPO?=
 =?us-ascii?Q?DpAG8lhkG6dQ2Ljp5SJgj14VnQ9gyp1gyv9+9lG1zXthxjMDNk0EHT2sh+K3?=
 =?us-ascii?Q?1VIXh77b8m6tY7sdvGeMjyl5yVK6Yd1xgypu+j89Wii21DPn3OI+taeJYY8a?=
 =?us-ascii?Q?UaXVNLHOwB+kflnR/N3njrJ1+g5PrW/qMjR4eKIcjHoFzekKiPkjFh54CZRr?=
 =?us-ascii?Q?JvRGkv5/lE1XMeli/mtFmSjKqC9qc1GryCcywrqqbpcitNQZpIJdR4wJOfIS?=
 =?us-ascii?Q?1MDIYq94EhEaOWRpl7s/+7OFNfdXWGWmMOBNGBs38pc8gYYKSMEgx8g/sc+0?=
 =?us-ascii?Q?/J7Ikifjzmx9Pp0dc4A7VChmgyo0HD1cpwK7ACp2zwfDJIAuEyJ7UIU9MJR1?=
 =?us-ascii?Q?DQpw5Br5xKmLQAp2tID9YXTHjIJCfChmPP0hqJABxsL7RdmI5oj/LFzFazBJ?=
 =?us-ascii?Q?5vqTl/UrAqVyHmxI1TR5Fc2MAT9POhW/mrtf55d9RhGYbWJcu9b6pOmBAsIS?=
 =?us-ascii?Q?OuwgHW0mJ3t72Wpf5Y0NERubtf7ICujmkinVMiGKVYZMd+aQ+EVZPlkGw3TU?=
 =?us-ascii?Q?6rVqfRTnNpG72VaFlG/3oqAXt0RMokx1c9cyhPH/xTrUcYSx1Ez60l4sQxO1?=
 =?us-ascii?Q?HBU1QtDedmhgz8OI3ErqRbwemaBLtghE8o19OhQhquCqPxb5vBd4S13P0hqx?=
 =?us-ascii?Q?WVqWtv1xzOKzVC4thQuvKb3XCAK2LIpZju85Ki8hYovUj7uM/xXh2QaLTBBb?=
 =?us-ascii?Q?L0e+cLfQvbyqLZFjYzsK0a4QZ4m7T9evWOTh/DP+Mkh1pwQ3i83hJIgyox0/?=
 =?us-ascii?Q?W8Fk/dfSm01YDg0lS9tSp8cna8w7NbZ6DSW4ulxasv9wdB7SZKPwHRUdQM74?=
 =?us-ascii?Q?kvVjcKeyM98GD+6xQMm+/WTvX6QlUFtz8ZcawQmMPCj8yrOgY6yQRbMO1WSz?=
 =?us-ascii?Q?RWgHVkWvYDo7Mx7MBx8VOBN0c4UtVPa0WJbbywzQFuLrWPG4Ksn2HdfSGIwy?=
 =?us-ascii?Q?n9bEKlESqyFigCuavc67dDVoQQIvuUOU7Z2TSCMOaZT8dVK0Go6iWuxbJf+T?=
 =?us-ascii?Q?6ukaSKVjBTLXfpGIzxkDwUs9bEfOgk0V9uh/nAcneheP7SZ5ORIkFByqQAOA?=
 =?us-ascii?Q?1NG6MoIrlE3IKEVK3p8PgtOpApSrN782lFLYl4Va+SdtT8Gy46tXFk5uW+5O?=
 =?us-ascii?Q?s0HtOiheXzGHUj+TUohB+JxzLiiPNXtIDukb6/AdlSQ7TNsM+WVRfe5WuksT?=
 =?us-ascii?Q?hha30IR8NaY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rG2/mM+WZ65PtREEFJ8/XEWqNRMBXNd2sdMNKpXxQmL/Y9/3zQn/GKk9JX+a?=
 =?us-ascii?Q?1bOO8UOJICPsVt99v7b5/h01SUhKRsPgqNLmlDYElhKL+j6tWwRO4FbSFtBj?=
 =?us-ascii?Q?Zmcr/8MBNGEW2K4hXVQ05rmPOnnTonGq86lDh77MUqy2Ekil28d8VfsOSPvQ?=
 =?us-ascii?Q?/ciihp2+bTw5tbKgoviIqcpo2ZosSLDuUmzrp0NUYwc6FL+jQm4Ob9pTuoGu?=
 =?us-ascii?Q?53MDs2AYZBCgNYX8xTn1tJHOszIYlKChhf1PKOjxasgEXc6/HbN7TyGBmmSU?=
 =?us-ascii?Q?g2A2afzt+IRbUiWA/GQ4cX0iAooFd2nTPfoppRVW/dv2uFHoiGL4evW7Cpx2?=
 =?us-ascii?Q?w9A8xhDC6SB2XQAK6IOI64HPWgdGZvL8CyORv19qJU15RKukowDDDd2zcx6Q?=
 =?us-ascii?Q?uF58QcGzusTFUkjZUCg59x9G/7feXafGQfHPQX/PkUC83WnLZUZXgzdzEWis?=
 =?us-ascii?Q?/ojYNSSTkJbcCkzyrzh5Epfy/v+AAvjlaKGWVRUoPoCwfBKRK0gsOC47EL1T?=
 =?us-ascii?Q?owIG/P6QtmnnLiDrmXq2RL8NTjn+Im5ZyVgTjEq274QQLJcHc5b6luNZrDlj?=
 =?us-ascii?Q?zfn0e0f/i9V/fRv4e9yZ7UFKHKmP72c3ojzXDL0OppAf39+QPuXYqUZIy4Qq?=
 =?us-ascii?Q?Gm/9WhO0Y44iHSyAKAzStyMZEtEiyUnrQDMPjgoN8ZeHEI8b2vyNblrDUUbP?=
 =?us-ascii?Q?WvL7M6ndFraVOpuPUALscs8mNOOSVStLaV+Spe6FumG9N+UA6xTYpTjjm8gW?=
 =?us-ascii?Q?g3J6EGgGWCnmObkb28ntIobjjxF4W4FeaUs75+Bb3HSIR5Puhp7US3DSh0Fk?=
 =?us-ascii?Q?2cn5hX23KNabe6FNT6mp+1BZ+TZN53FcXNDrt/KOM2s7IKvk6wTEHFzjUwdA?=
 =?us-ascii?Q?ZCW3DnVu/fZg+250iKAoVDQrfGFQxeal6ECj+X7f6ezm5UnjBx4ulXpqTehd?=
 =?us-ascii?Q?+0b+5Efmu41lMCZcDvslmDpGsPuIBWSfnqhyqxIokAaQ57Azs72vPrVEr/p4?=
 =?us-ascii?Q?4WKg74uRbuluxzGNEIVXX2DXeOy/IYr51My18FefkG2aYTawDIH584UIEpXq?=
 =?us-ascii?Q?4kQ/T4g9w9nwcS9Mi4/LzVEEfY4W49nUb2gwfYQA/F5nhjKZN0RApX2tSTuY?=
 =?us-ascii?Q?LSd5096bE2Ky8NTbprcGwDOY60T8ZvFydL3L2yDF3iSOMs7fQld66ghGrgq1?=
 =?us-ascii?Q?Zeq/B/BUtHf4bIpmQlm1YGmnPQj8WuqQx4VULW5k8+etF+XZhaUDlqJOube1?=
 =?us-ascii?Q?SDtzTFnh+CnJd0wh/oZxSWNcAvExEara9qNF+uhcozqvUfaiJh8nS5rw4D5k?=
 =?us-ascii?Q?0Xn8QCdlChHkAzcNyOfD/4qMziWGAAV4RVf4tdyi3RnIpqb34EK7QWSTdQQA?=
 =?us-ascii?Q?QYhqF9Si8V0evSrvARsWsGhDKwDckNs7p1BxLZ9+HL/nA2EAq8yzN//zmUaZ?=
 =?us-ascii?Q?NDAv7M3k+bXjQlIxOY3f6wvKSGnJf2AQqlvHJO6crAF67cxiWfu0rOTeRN0n?=
 =?us-ascii?Q?QQQrqPmsaUsAxlHj6Tl0WEQMoWow3fgY924LRq1XjWHNQFWJaY5ZV2UblCiO?=
 =?us-ascii?Q?mUKcTXYIJSsxR3+VF+vSJNF9CEU9yJAKYxY9iPKTVPrgFlZ/gts43UXI7upq?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eqk3eN771xzblFUUlgWSNkTgBivWUGhcnzPoLdX8e2oqNGKA1ypiIk6dGE1ZQflL1y9TjKeuv8n2pZlFocWt/X8guC5K99DdknN3Qw98C/t+hnjcZDXqGHAfIIEVrUdK7/4emcOov1JR0g/6hnguuv3dJ1T9aAUEKll4G5FlEZ0fYBr+el1FA3btYL+ApgDpuBMe80V5m4+gB+K+j88ybqrwvrOEE1MvteyTBHWZoX9s1PuEbrVEDvL882V0abqV/v8DBUjy8PiMQbe/DpxjLrxyGY6vYbqJF2rJOsIXtY4ogrqBeXiAxjzfn+N59BHiyQ8IVeACDA2tNxJdcwJEKQI+TkGtWIFr5YvBzrCERIDN8qdol+Kc1A+FeKOSeB0uWwUBNE+60wReXGzvWYLXewMODmlk1zqFTxXAaoSyhlsOymvxIFoijyiwXPPdXD9YmB8+ra7gmM1Roe/pUCURFRzu+DRCswLxk+Ck88mPKKySl+HDdzuJcsNJV70LvOwHRS36UouSvh6+jokuQQxl9jgJhMThMATET/lb1wZVQl+MMiJpMuOD+jZBzg79H3mHRinWMrM5O8PtriPPz4w+mM21+Iq5IYKL0OgLD06A3Lw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50de5aba-241c-4f55-d84e-08dde5ce546b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 01:00:49.9997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3HUDxfAb5niIcLVwkhlQusSkymArkzH7TOs77QBQxxDHBnZH5U5J7VOqCZOmZo4eGx6bxeRoygwikJQsV5opA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_04,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280006
X-Proofpoint-GUID: ql41UOZINeEjBbH0HsG-ooQbxIQEPQGy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNCBTYWx0ZWRfX9rSPtv+Y/nUu
 AhBbkJm7v7KZ8PTIRsNWbfeGfXMIiihrWzMN80GRVH7bu9r45nkWhIGxOqNEwWRi7mvv/rW58I2
 Tl9LhUpIWht0qEk3FfRh80qHNwZr6gKWF+kS/p4uRQdJ5suv1hjY+m0LjmSnbXFxQqQhzQUm54c
 Hj/VNM6N+WK7Ebn4riq8q20Jbib5AYdNN0olIA8RejyltB2MAk05nhKGbP2bcu0h0FUVFZ8NJAj
 vnNNiue9YQQrp/TbKYcld2XzlnfEcSGu6OZTFkBBv2p3NNunsoeM3+x4c5DtRneKLN8pDVaeoQ+
 UeENycl/Hhw7IArUmABeNKbuBaf+hROP2RUAY/9J5qHnd00Rl0lcjrL7/pKkFELKQpOuDrny4Ar
 HWfITffma40BdLPMOK8tZUmh1WNtgg==
X-Authority-Analysis: v=2.4 cv=FtgF/3rq c=1 sm=1 tr=0 ts=68afaa4a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=LPyVwdBBitfx6ZMO_kcA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12068
X-Proofpoint-ORIG-GUID: ql41UOZINeEjBbH0HsG-ooQbxIQEPQGy
X-Rspamd-Queue-Id: 5AEA91C0007
X-Rspam-User: 
X-Stat-Signature: 3tjdoq5quiphcei4mintowdwp1p4gc3k
X-Rspamd-Server: rspam09
X-HE-Tag: 1756342861-254699
X-HE-Meta: U2FsdGVkX1/BkORmm6bkB+5ZFbRWrkHxYMX5RmmprgOaoY8diKY4oZT2oPYKKmHQH0EWu0O7HsSxce1MIbXGuNfel/Cq2yweb78K9OEEUiN7aimYeNwL1+/9esn0yLV5y1H39hIJ5vTQGQDXefijALMfQTpaSYc6mYndd2DrvUnKODHLU1ld4HWhKmfeaAbGyukUBG7Q4u0aHJ1s+FnZMyy8h2SZVIaf6BujrfVISTYUcL49w1ovvhp/9LKCxpNgxhH+GBDRzqKTF6sEYwUS+vbfXnjgxwHdYq/me9zYryUA6ilLnamwpOIQkZCldjbXfM2omYEgtLIOHswKRaocZ1FJJSsEv02DXSaaDj2VB2vd3PCAwIaWJbAgtV9f8B/T3JV2dUr1hAw+reHpm69SbuiHhKn4S+TVm63tDYr0j1IsUGG/HQmvyqnFkSAvgkkTwWCx2etLlzUpFbUzwwRSgGSXzLyG0Z8LdBhUw+G1K6i6kk87YXnRClGVNJyjHHHh9q25+jsdtVQg3H7tdYiCUyROCNt0ZERf8XK9cpTmwV3ZUD+KXzSX8jVwN3CEMwcli4vaV0qcdIW8kyvhbr5NNRFbtLI+YxE19NLw5TW986YrDJ9lrMZt8Wo3tDNc+VYEEPXIQDV5VxNMNov4kQ68SYfQG8yd0XEy3rWexXKZe3kcvFUL9Sjg0pvU2dXjZo0va6aMJplaA1tBZWZbbMIRBswpapDheQhssToF1hALV/R1nN77RrxVWeILVLb0tlHoveTXPWNKA8wcKweYqKXg9o0d7pZWGR2jsYO/HnkwflTaqTOp2+4l0hxV621osGZzlnBxuHzDqsB9KLq5z6vgn+UyQfMLx8WCwKrCXZj9X2FJJgLJ5eMnXvRxoN/tTCQVVnbmk6qGDlDAkxAF1djL9S3fduJvwtHrbTnKJ1aTAlYzxGk/ZqAHvlfpEH4+80rdQVaM8njIO9Gr9sCNKnR
 nhnhAZQN
 M+lqjIk9glRk41eQXdkvytAv9KKZ+E/tTrtiBANMs0YzUh4Nif+qhx0k1fsC1kM1jdVTNxQscR6jUxgxz70djkmxoGKcEhlEx/uoJTtNStViD8MplBoiWUdIQQGc38llcNZmlT+nF3vDpFyhxLlnooi1qg13cf4iNeLoWPDyorkJvH91zmQEkHrCqlO9lai+/ErMphjnS8JQ6sVqovDiy5OkP4ox1hmHvDA/k+1HOpGtTH88BrG2W08zrSnvLseSa9UZfbyG66Z9hShPHbCk32sWK1WZlD1F//715FAnRo9eY31WtpoV01Ep8RZIZPGN71bRwqUjr1qMzMnlh+gNdCinWxs6y49lQvLPGQJn5X68EGVyyO/5IVJEd1NoAMEmKj3c+nHIYt1E7l5yWv9BToomj0XJ+AnDAgvYeo83X5Y74g1M98NoOukvm7dCW2d9Z16EXfFTOiuyzfgwJbmqzd+UjGtAcoFBu42HmVOyHLdtvZPs2M0sb0WXnCWWLpBWcK1kR02F8RbTh4CBdCCEsfyR7F5tVJ6v5axDr98SBlWqWFc2ZGulGp0MNIzkKu1v4FUROZbktSdS94vAULJAAdrKfe6j74ieWjHfK6tNxcyE9TThxWyre/uGhm9yhtQFENn0jHXZS6BapBK7dTTxY8JTRIx+EDqO+2+kvnJUI1peOn3iFqxFbrlEic3bpyaFerfYfjJmetegBN+uWzGptFTNmN+YSS03onzOESdqG+2kNZVJyqDTfZGV1iI8H3ML8Q7BU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Brendan Jackman <jackmanb@google.com> [250827 07:04]:
> There is an arch/ tree under tools. This contains some useful stuff, to
> make that available, import the necessary Make helper file and then add
> it to the -I flags.
> 
> There still aren't that many headers so also just smush all of them into
> SHARED_DEPS instead of starting to do any header dependency hocus pocus.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Thanks Brendan

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  tools/testing/shared/shared.mk | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/shared/shared.mk b/tools/testing/shared/shared.mk
> index 923ee2492256b693c5cf16cc014d9d2410be5457..937aaa7623320da1085a8e0f43f6a728ddd3ab1c 100644
> --- a/tools/testing/shared/shared.mk
> +++ b/tools/testing/shared/shared.mk
> @@ -1,6 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0
> +include ../../scripts/Makefile.arch
>  
> -CFLAGS += -I../shared -I. -I../../include -I../../../lib -g -Og -Wall \
> +CFLAGS += -I../shared -I. -I../../include -I../../arch/$(SRCARCH)/include \
> +	  -I../../../lib -g -Og -Wall \
>  	  -D_LGPL_SOURCE -fsanitize=address -fsanitize=undefined
>  LDFLAGS += -fsanitize=address -fsanitize=undefined
>  LDLIBS += -lpthread -lurcu
> @@ -11,6 +13,7 @@ SHARED_DEPS = Makefile ../shared/shared.mk ../shared/*.h generated/map-shift.h \
>  	generated/bit-length.h generated/autoconf.h \
>  	../../include/linux/*.h \
>  	../../include/asm/*.h \
> +	../../arch/$(SRCARCH)/include/asm/*.h \
>  	../../../include/linux/xarray.h \
>  	../../../include/linux/maple_tree.h \
>  	../../../include/linux/radix-tree.h \
> 
> -- 
> 2.50.1
> 

