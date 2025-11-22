Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26710CFC518
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 02:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099F56B0008; Fri, 21 Nov 2025 21:55:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 071D06B000C; Fri, 21 Nov 2025 21:55:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B8B6B0023; Fri, 21 Nov 2025 21:55:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D39A66B0008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 21:55:52 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92C3E88CB6
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:55:48 +0000 (UTC)
X-FDA: 84136727976.21.0BDC2F8
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010067.outbound.protection.outlook.com [52.101.85.67])
	by imf18.hostedemail.com (Postfix) with ESMTP id 899E01C0006
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:55:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="U/svPHUf";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763780145; a=rsa-sha256;
	cv=pass;
	b=SXQ+n5E9zSS7dtW6VorzuGIsGMrxAQauNrx2sQ+hkSf+unxLsSaiqWvmuZ2vNwAw195z8f
	s+5OpwBRDWcoGg7Zn2J35msg9ENZHPWru6u/KwwRe7PBLBvcsMr1essyMK5UvkudJVECr7
	cESh/5GiW11kSpmrjN5QmcdgGBIECt8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="U/svPHUf";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763780145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dp8wqnebcphN+TiPVc8lxUz8G/aCi5eZMNGk0TQrpMw=;
	b=sOaCblirlEguI/tFC22zGs3YUXXYElXgif9IJ4wvFi85mQtBRMLsN3JUw9Zqa5rDLMvpDv
	YBeAMYOVTdgLlt08E2dsev2uU2W1UGUESu+14hHeawFERSEhhEEZJU0/zkbdcyCFisvVUQ
	zGrvIiYv/ynrjX+a3fzFx6jpihspLDA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oyc/h/yoCtPRtIiY/yOrR8T+YzDVS1n/heRE8l+LyvClMu/eDiC6X11t+TXVZvmiTorj3wbzrggmp1ZvrVggpio1qu6zVSGLJwwalHF+ZUjpWNmlm5nyJYnC8upbW/kLASoQ4OaXSRQ/bFu/DhYVUdjSq2Kq1s7JpvdxJSxi1xWHkjB/dMQYQzL1bf3190cseT2r/jAKElIKKzPX+DgSHesoDMsirmeS9R3vaRtj1B/J/ujZubbBvvQoV1Q/TUGhv635Twf0ct+abPR/z736tHAJErIgh3no5BHBlPU5Fr/9VcDj7wrE29bOOYRN+pLtqwziu4m79t2L36IUQxh7qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dp8wqnebcphN+TiPVc8lxUz8G/aCi5eZMNGk0TQrpMw=;
 b=wNfq+dBS5SeS98UYvdqJWKKqH8LxyJ25kLy8LOoDscV8p3kXiY76/7ceoRv22XWU1tWBrcGxbI0Xorfhxe0dAFELfnz3nQ0TD+MWlY/djxCXFP0KPRIUrHysfId+07BuJNofbJpC/vBxt+/7eC87cFs1uf5HmGl2h93Pkc5fyZ4YGJrEE+fVGw0bICb34FfU8dew/g4QE5FwNFnV6YpmBTwlCMAEwB5RlFex+Ycd/Sp8jIoP6LIbBpcTfos4eRoFpOvFC31XharEfeQD9gzkOgJrcCjGLS69RXpSHgqPlKTKDD/QYh0RmPk2bewzSUppI/IAybh09fAWRlk/KOLF7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dp8wqnebcphN+TiPVc8lxUz8G/aCi5eZMNGk0TQrpMw=;
 b=U/svPHUfmzuFdAZ8tRZT93U4rxxqr3XQIXR4I7oumYaCgjwa0VrNfrEC8mf82E2RMBeP/+z4QFOiWI8jTPv+Ggh1vfCRs/MxvAuW5ZtiNY1DzL5AL3/2CDc/XWrgnhtzh0pMWkrvXk1uuSfCVLhy1vhllfVcrpHr/K6c6MeSGuN3QVjcbFc/WG/+s+XifERnOUJmmC8DhK/UYsNWq4C1e+7ZSLrbqrA2udga0b3BDWeok2BQ8o2zlSYV+dlfpm0XzXwy2idyLeajHH0Z89udEofVjKmaVRxjBUJJkqxYbV8tGtFxGktaVXDYGNKshXCIL9UfK73Rhs8EJKD88tSuzw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6994.namprd12.prod.outlook.com (2603:10b6:806:24d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.12; Sat, 22 Nov
 2025 02:55:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Sat, 22 Nov 2025
 02:55:41 +0000
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
Subject: [PATCH v2 1/4] mm/huge_memory: change folio_split_supported() to folio_check_splittable()
Date: Fri, 21 Nov 2025 21:55:26 -0500
Message-ID: <20251122025529.1562592-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251122025529.1562592-1-ziy@nvidia.com>
References: <20251122025529.1562592-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0060.namprd05.prod.outlook.com
 (2603:10b6:208:236::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6994:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f980bf2-b27d-471e-4525-08de29729fc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ngBU5zA8SzKSOO99XuqCjEfOhYHxzotO/qQ2qh6/IM0bKf15ZixhE03nkHUL?=
 =?us-ascii?Q?oL9Bf6wGPcHoN2t2tMlA+9y8ATPTvDRFvOyRsSNDvl0uiu7DSoiBylXpmF5h?=
 =?us-ascii?Q?E3pHrZ1yGfibPTjNsFV+Qd9o00zqt/OUpJoWenjHfZtfz6HBpyhd7CGYLF66?=
 =?us-ascii?Q?vu0IWy9ksExnkhBGbOHEykoxTkj/kKdO+PfqUjTaurszbKI6+eu83SPwGN3l?=
 =?us-ascii?Q?HKnu3o5upvTFowdrEj9sW30AzV4l/uGzkgkJe6KIp4cUDK19jSwxCnUToFQl?=
 =?us-ascii?Q?JCH7V8e4QOf2Nee4v21QoQtmqSQ5B6MK/YZ0S8O2H53y5YEJKW38kA6RQQGw?=
 =?us-ascii?Q?SjENycOnGF9nZFXvzSAfaTg8x0pUVaVFY7QhOOPNAGtpHDkScEgYb06vV91w?=
 =?us-ascii?Q?0o6ksH8eN6wGXpwAaMkJmbvIVaanbood7WNkjnsJFCi4Rj0IGdiT2+g5mAJ/?=
 =?us-ascii?Q?BWCPsbhMlekIQ8GijZ798YI3S+0Mgcf/gBhhw5ybSU0Wkob2k5jj1ZBMW7+j?=
 =?us-ascii?Q?3zsBCsYPJWL3Hvmd6+qKuIAKy5KqDUTzHMf07APdVun2ntd1Fd17Onx3bSzB?=
 =?us-ascii?Q?4Qm+36F4lpWZQuDJgV2W0nbliRz4ap/H+qXXmogfyqQgE+K71gDRYSb7ANSb?=
 =?us-ascii?Q?9xOFHYvFS28jVNf26YVCxrTY78vD/B2qEZRAnNlbm0Bh8ejlji8vzQv6giq1?=
 =?us-ascii?Q?D1217Jgex1ATPFIDJM2ckJ7Xk/1a0Ca98ZZsOghPIcyiavtivD3JP9DT2Zo0?=
 =?us-ascii?Q?L4d6qT2gg3dRXM+H8n/PBBghqEm2GJrNgMKvi31vk52r197UeW5o2maq0dJQ?=
 =?us-ascii?Q?HID23Wj1QZ+PUBrXRCRco5pAErjT8V7uFniI6NC57l0+o0vGvlbRjUhnl2oU?=
 =?us-ascii?Q?+xO0E8bp6iJlXDRCRKSTpc8f73akmYFjKf2qB/jxZkcXPqoOD3e9WPt/PLJJ?=
 =?us-ascii?Q?9yLfNbW1eA6dRAW76oOFLEZ3CQCGkmMVfmVdElZMJjEf1fvylxbKqDOUHYd7?=
 =?us-ascii?Q?eCgiIXj3/1qjqBdAKcrhWwHx+yas7uJf+1l3qOFMuB5RLM9MmxVEeMUYG0ku?=
 =?us-ascii?Q?YK/7H0yO9lig0obGU4gmxd5apk2Hb6GhrPsskmL6GYp37dsd5G7alVQyL6Jq?=
 =?us-ascii?Q?B857o15MR1qc3RwY+fHX/zUgo4nI4ISrUc1ZHxcZOv4nN54fyvXveYFyTSFs?=
 =?us-ascii?Q?uqkFN/WHw9JwnNAxveGiYfdahhAmXYtQY3ixg1oLkGmhw8cusaQygIOub8HA?=
 =?us-ascii?Q?i+g13wMCRnmuPznGBC/My5x4aYieEJ7B0ngdyF74QeeNZG2ADOnNWuYjfoPN?=
 =?us-ascii?Q?Z6MCYUlNaiCvPFiKuP2FBx6mCqNlBmqEMnf9DWIF0BJ7zQdJtWz5vrx5Cafe?=
 =?us-ascii?Q?VRAOr/n8AaCsSZDO9QE5SkH7DhvKfDsNx0BsBki2gE4RekX1tMuKVtcrz1wu?=
 =?us-ascii?Q?6+7ewiObjMSdK+28sJ41S5XFa414jBIo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SoDeudQSN3RPdJ+ERMAu+qVGUBDp4H0j3MqgVYFxeL3mPy4Tu4oxu5rpwAHl?=
 =?us-ascii?Q?QnBFZM80DqAWAUra/tzQobu912n9KiQETuQ7EUIkTIiQUK6/AxgnoGUMJKdY?=
 =?us-ascii?Q?JMlgi089iQVJbnwgHuwza0EtNYiCGSFatjR2brgaVlTKrr+q6ZTRjAge0rZA?=
 =?us-ascii?Q?sOfVn5BF5lYsFwBt97iIEp7CC5s4//70uZAxc8z6ehTy5s60mypZJg1LXJXh?=
 =?us-ascii?Q?reVXF4XxFlZq1luVQU5pAe8ZTvv1ljDEfteGLsYSXR5MiWIE7Ggn7eRX1MFf?=
 =?us-ascii?Q?PFcMglD6u0umLTeGTUht4gEj6NBYSspvu8XHyKe93CcLl232AlpwTZRCVcyv?=
 =?us-ascii?Q?QkO1OUBa3dmHFVnHQWnmzrhO2bwcWYZzsvqZmrAwsivtiy3XMTyxVTlfBhun?=
 =?us-ascii?Q?6XXuyVduS4pi8RFCXuOBj6FKRBa1yvTZHjwpLxIuiYo/UubGfcSg44wDTRNK?=
 =?us-ascii?Q?f8We8idyaBhWfm4V1hpwrXB/4ixNW2XhlmQPrC5fLTxEmqeQy5bEY4exATmR?=
 =?us-ascii?Q?7Hia7fy/b/q4WhI+Q0vtCOg4os8opivPvUuExwqDOeB02gDt/hO1vyiIXFOC?=
 =?us-ascii?Q?CMM5+cKKp6uqJN/ymL8eILS/aUBz9e3GisblH3Maa6ur5YaAnu6erarnfpiq?=
 =?us-ascii?Q?q/48FJe5hODTCkXnE3nAJlDjUz98pknLCSCeuCdLVwfZB9jDKD3QRas+hy1Z?=
 =?us-ascii?Q?w/UCGVITPbv4RwsKRoQZs7euzaeA1pGHXOkJQ64Ff1oVV3YbJY/BPOU6hAWW?=
 =?us-ascii?Q?LTFUeEvj6h72MxwkZhYfTiYksK1fPGLVwuG1LwmLvnWrzb3OjY8OC0ng83jb?=
 =?us-ascii?Q?/OF0/zuSvcMC6Uwwo6+WmMrZPvjqiiydSvXGR45EbZngvsaC++Yol38q+zaa?=
 =?us-ascii?Q?wamraIa+lwCGDGLRKFAeUeA4GwrEnNL1V+An50KOlxxpn7XUbm7T58tYQ8yt?=
 =?us-ascii?Q?mUEqQJvtpE8wavne9JhwtS6QH/vgWz0yNJDLGlIq1USCBEcRoK57tCATqjOF?=
 =?us-ascii?Q?XwGmZt1fH3kxsGJ0XVoaBRcffq8qVopQhiWpI0a+efyqPqpPAlt7LHUKfWgS?=
 =?us-ascii?Q?BImDPVjGxw57kw30ucBjehJnEfIch97+ED0o0Z3u0z5jkO4VWxhW3Q6bEksK?=
 =?us-ascii?Q?HfcMTZvoMA5Ko+IvmGWfmpud6P3b5hHDRDzIPGSmaW0LuAYxpUAn0M7vgJPf?=
 =?us-ascii?Q?yMRVJoJWi2FKQNTFT1xqPunSodW3pI2/ZfVYrPtaRcToFUM0GpSo/mdj/GQb?=
 =?us-ascii?Q?lQmHy3BNSojnyWVl3sLhrUCMGS6xp5Phnw+NU/Cqkd7VSbl5UWHFPBm+fRMF?=
 =?us-ascii?Q?QP8WHfnMawgzBkUZjASA9qRAc6ug3pdVmL9rizTFztwXxErSc6QoOfk/dtbI?=
 =?us-ascii?Q?GqzcTOtN3UaRrgbm1uSUtj3gaCss3GlkF/mbeO8eHnwz/YeuUv3OVCIPhq5C?=
 =?us-ascii?Q?+w/ZsDMAKtT+QypiU3YD7EqwFkwKeAecy+Z/wezHKs3H5aqfoBctfGKlewSC?=
 =?us-ascii?Q?itD5J1qaOtEXSiJPBnV7At52anYL8jGhB7CHpUb6t6q9Xq6edMqojgiH9yxc?=
 =?us-ascii?Q?EV97xwdUmP8agVoBV1bBoZ6QN+PVEcYvxtdWK5jm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f980bf2-b27d-471e-4525-08de29729fc0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 02:55:41.7295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eHVFXMWy/Y45cuXK7NsPrrLcsYKWpnEgrUAbzS/fDoLRtvJT8uoQ5Lb7B5K2Orkk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6994
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 899E01C0006
X-Stat-Signature: gygr6nr1woaemd3pnpbkcb88epf8kpi1
X-Rspam-User: 
X-HE-Tag: 1763780145-296608
X-HE-Meta: U2FsdGVkX18wl3vNZYkyuicgUI4PmJeJrgF5b6hUsF/pREhXsb9kEahkVAKM2R/hlKB/BDHLavk+qFjkGAWk7s2Daz6xFv/KaDTjy0L5HifJjKVeEgFba4MC+sznIebJRbOxd3OL8iTlVTJCqPxapmFYp5vq9Xsjoz8KXAMeQDnkR0yjGFcPsZR9jLBwUMdI70LyEvpq5OTczQ+lOEaBXrc9LrwV3yptDHN5cXQ/Te5AbFnlR8q3g0RPHqJ+zsCGF9o4ZG5bQztiLtE3k0vEnltQMkhaS0JAZRwAhs+LZgVIOBaZZTUCumhCP/1o6vmGSrW6+uotjTmn1LsE5wmqykwvZQabS0vSWG9MfSrW+ni9MeaUCtSE3s/WcTsFx5GGnI1fLDMCRAel/m9aT72GkyXw07S+GMKhuUcKWpzFUpTewkM4r+FDJyNHBM66fY7BZaZHdr6POTJv0tv0onMWyqaWBEYoczCZNwwoxs6keW8MKYQvHDUNjXz5ASVNOSuvr8NOOdZiXiSaaD9S2S5+gN1vGOE9XJKqV0WRGjT89lPoqdca8thEj9cssl36zf8gkSDciRjJqWa/l6+MKt0qoxZcwIQKMKwqQIqdy1G0abGXPQWierVOFMX+4xwUEuu/gwola7pB8SB+hLswFMt6ajG38qSm0G6DnDqzrGcl1eSzxbSBVP+AfxVmgyUtTv6wY97BddlKWyIQBmDU1FdLemvVY592KHgvhkN+QHzb4bCIlx8y1ZVnjCtwns74xuVGWVtmW7MLF8uzhGhdOJLIlwor6hvVg/RSS6E72660nFOUWCQHQZYxrnA32LbJYqTlO3gfp+cw3dxuYNKNKB1nrZxRbEC2Lh3X1vu081ww/cj7ZQtzuzNcWB6hu53PBXzuvg1CH+1S6dOZBns2tRmXBC1ghISoAjXsurlDrt4UI5BfzcS4p217ovs9VlBM/RwOdYi4+fG53cxF+IOn+Tj
 rUXedOW/
 VOHxNoB7d30GB960n7i/lCasnzhEJ1iadBF0qaj4Ui+sDK1nQhA7N+beNpBtSwfjSkBJ8G6x6F2f5V7TLHrqLRNdElzcn89Q7SfJOoECY+irTv+cS//qMn3G7zqZPtZr0eSeZr6n2VGABMZrz5v4VcjxAEpIfqHglC+tSToiccJd2ROk7jb+YOHk1XORlCpK9Pm7Zs09FwObky/7cLxU8Ao4yI0ierpTIfY5Jt3tSxIzUVzEgWSXuBYkFraschX8/OaRR8a+N+uTf6GYSMhuKbCKxqSV0RH+Xz74hoVEbEIqGEm4/LXbmvjPpk5KeDQ48ptYOjsEnEaqcjj+8GZi47Y3+GbXZxxEAyUlfAVxR68u2bCDIHg+zZPxabtBGSvnQOET2ncZSzFRh+CT/5JkuhGioyFfYcZ7WkWWnSQs2L+0Uen5Nxtxy5MadZhhLfiC51KdznqcVRDWee8tgN6EcU8mEaGdzx5stehVVNgpIoXd/xuradcwK3U+wnaCJnXTfzCr0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_split_supported() used in try_folio_split_to_order() requires
folio->mapping to be non NULL, but current try_folio_split_to_order() does
not check it. There is no issue in the current code, since
try_folio_split_to_order() is only used in truncate_inode_partial_folio(),
where folio->mapping is not NULL.

To prevent future misuse, move folio->mapping NULL check (i.e., folio is
truncated) into folio_split_supported(). Since folio->mapping NULL check
returns -EBUSY and folio_split_supported() == false means -EINVAL, change
folio_split_supported() return type from bool to int and return error
numbers accordingly. Rename folio_split_supported() to
folio_check_splittable() to match the return type change.

While at it, move is_huge_zero_folio() check and folio_test_writeback()
check into folio_check_splittable() and add kernel-doc.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 10 ++++--
 mm/huge_memory.c        | 74 +++++++++++++++++++++++++----------------
 2 files changed, 53 insertions(+), 31 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 1d439de1ca2c..97686fb46e30 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -375,8 +375,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
-bool folio_split_supported(struct folio *folio, unsigned int new_order,
-		enum split_type split_type, bool warns);
+int folio_check_splittable(struct folio *folio, unsigned int new_order,
+			   enum split_type split_type, bool warns);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
 
@@ -407,7 +407,11 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
 static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
-	if (!folio_split_supported(folio, new_order, SPLIT_TYPE_NON_UNIFORM, /* warns= */ false))
+	int ret;
+
+	ret = folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM,
+				     /* warns= */ false);
+	if (ret)
 		return split_huge_page_to_order(&folio->page, new_order);
 	return folio_split(folio, new_order, page, NULL);
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 041b554c7115..c1f1055165dd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3688,15 +3688,43 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	return 0;
 }
 
-bool folio_split_supported(struct folio *folio, unsigned int new_order,
-		enum split_type split_type, bool warns)
+/**
+ * folio_check_splittable() - check if a folio can be split to a given order
+ * @folio: folio to be split
+ * @new_order: the smallest order of the after split folios (since buddy
+ *             allocator like split generates folios with orders from @folio's
+ *             order - 1 to new_order).
+ * @split_type: uniform or non-uniform split
+ * @warns: whether gives warnings or not for the checks in the function
+ *
+ * folio_check_splittable() checks if @folio can be split to @new_order using
+ * @split_type method. The truncated folio check must come first.
+ *
+ * Context: folio must be locked.
+ *
+ * Return: 0 - @folio can be split to @new_order, otherwise an error number is
+ * returned.
+ */
+int folio_check_splittable(struct folio *folio, unsigned int new_order,
+			   enum split_type split_type, bool warns)
 {
+	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
+	/*
+	 * Folios that just got truncated cannot get split. Signal to the
+	 * caller that there was a race.
+	 *
+	 * TODO: this will also currently refuse shmem folios that are in the
+	 * swapcache.
+	 */
+	if (!folio_test_anon(folio) && !folio->mapping)
+		return -EBUSY;
+
 	if (folio_test_anon(folio)) {
 		/* order-1 is not supported for anonymous THP. */
 		VM_WARN_ONCE(warns && new_order == 1,
 				"Cannot split to order-1 folio");
 		if (new_order == 1)
-			return false;
+			return -EINVAL;
 	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 		    !mapping_large_folio_support(folio->mapping)) {
@@ -3719,7 +3747,7 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
 			 */
 			VM_WARN_ONCE(warns,
 				"Cannot split file folio to non-0 order");
-			return false;
+			return -EINVAL;
 		}
 	}
 
@@ -3734,10 +3762,18 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
 	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
 		VM_WARN_ONCE(warns,
 			"Cannot split swapcache folio to non-0 order");
-		return false;
+		return -EINVAL;
 	}
 
-	return true;
+	if (is_huge_zero_folio(folio)) {
+		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
+		return -EINVAL;
+	}
+
+	if (folio_test_writeback(folio))
+		return -EBUSY;
+
+	return 0;
 }
 
 static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
@@ -3922,7 +3958,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	int remap_flags = 0;
 	int extra_pins, ret;
 	pgoff_t end = 0;
-	bool is_hzp;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
@@ -3930,30 +3965,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
 		return -EINVAL;
 
-	/*
-	 * Folios that just got truncated cannot get split. Signal to the
-	 * caller that there was a race.
-	 *
-	 * TODO: this will also currently refuse shmem folios that are in the
-	 * swapcache.
-	 */
-	if (!is_anon && !folio->mapping)
-		return -EBUSY;
-
 	if (new_order >= old_order)
 		return -EINVAL;
 
-	if (!folio_split_supported(folio, new_order, split_type, /* warn = */ true))
-		return -EINVAL;
-
-	is_hzp = is_huge_zero_folio(folio);
-	if (is_hzp) {
-		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
-		return -EBUSY;
-	}
-
-	if (folio_test_writeback(folio))
-		return -EBUSY;
+	ret = folio_check_splittable(folio, new_order, split_type,
+				     /* warn = */ true);
+	if (ret)
+		return ret;
 
 	if (is_anon) {
 		/*
-- 
2.51.0


