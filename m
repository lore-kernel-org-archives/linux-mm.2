Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7940CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 15:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3483A8E0162; Tue, 12 Aug 2025 11:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE998E00B0; Tue, 12 Aug 2025 11:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0738E0162; Tue, 12 Aug 2025 11:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0992C8E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 11:57:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7AFC1603A5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:57:08 +0000 (UTC)
X-FDA: 83768559336.09.23B1042
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1F83710000B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 15:57:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bwBC5uY3;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.80 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755014226; a=rsa-sha256;
	cv=pass;
	b=ypjTCHIWvwcuUlSvQiMmrnqOXBGXQXxCeggUvZMYVeKo9rM/WHl56htmk4k3oT0DGn+vS4
	HRNQIuAGabxXSMBpgIJL7JBkzCrivTik4YnnR7IcfkJh24hRGOCfJtePVuKDex6IMGM+x6
	Yt4f6Wa8DxNJ9MIlm8n7nGLUVvhbWaQ=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bwBC5uY3;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.80 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755014226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49ZSpr/I8MWI8XUZKPEYSzl/XhTN6mjiL7yiL7QZf9k=;
	b=DhM9iECTqW4h7tzwZHK+4Qcn2KWctFTpr015Ehvz10EU4Smt/QAt2RKZPtAK3OBI01T6hI
	+CWR+ilAXS18B/71Yd3zpY4kDidRE2w9cL5M3Ame2gx2G6JJR7ff/WmjDQHmd0l+D1Fr3s
	a6VwEIP2kykOMo/eZriuNNmUzceOXWs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R5e2V6C56vLz5OFiVODuqtOgGg58NQv878DAUsLpenvE6vtVkkHSAi6pUcX/Qbv6BKRCAeP1xP+jMxS0r+ON5pyFkfe97XE69G92ixjsS1WU/KlDrUJcowJj9UOzABMFV9O3+b0Q0wI8VSR4N4V1FyBvteBq3PnWWmYh0Aolm9k01WSBnrXkr+DzOTO/aaWVaU6VslIBZR4B7F2ZqUJci6aWIcDwMlkaaIplrK75LBtsbAUNMEW2gKmQ+EdL6rVnKNEaLk2qg6Aj936l/wHsjVw2PjPRgVjzENMU2acZR/GSB1xjPtkU0jd7BStkHLJGCUTuosbdci4WETehXpt1DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49ZSpr/I8MWI8XUZKPEYSzl/XhTN6mjiL7yiL7QZf9k=;
 b=AIT+7CJWBxPCaJKowP/JzLG+6FBBlrZa1DE5Cfif50Z/nVG68tFi4aLg/KrsRxMKjkRWgLOCXF5KuhbfDcowmt61BZixBqYyLthTgvH5kTc7nplEfnKze/BwyhMyD4kZqPWijJ6bEzYtXBBmwlEox1PF4u4DsE2s0OgtxRkyPG/LxvO0DGsHgpOaNNhagVJ6UalnWS1SzwcEvoJFtbvUiRrbjJIsbFz2ki8SNoD0ZzaGdDW6oOC67Nk+Bn5u88y8tRz84UJEZYTlttjYhuZFMtmPCdtMgk37akligqbUmFZ4/BeW2iQRKQDAcsYcV/aCME08L7kgrnztfCiKWCqHOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49ZSpr/I8MWI8XUZKPEYSzl/XhTN6mjiL7yiL7QZf9k=;
 b=bwBC5uY3i1QJMfxhTs+/FM8wHu7gRgrWyyppynrSDbV2YnHQFq0fyqOKiXABFpc81EQce7+twFnpFB5dEjc1xM0oU44VQI7ZKXcYIpDeCLQJjJDm9gIyhLxK7Ilz6FhmQM5EwdazdspHGyaCPMdBQaocmKBGtGsjH0X/u65uEWPzv0R/L7uCyWa72Ipp0mYl13Z0K+SdD4LPxlZ7r+uvNd7/8177pNmpZ1n7qRGNydAQWiMjdWMkGQQ0xcHFHgEBL+IVqG0NG8h2PfUSQQpgWyGlAZhmJE7vltFb98uXRI4M9lljUUyc3V6yDDpATzG35e6B4ir8SBnp8T05wpfKTg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CYXPR12MB9441.namprd12.prod.outlook.com (2603:10b6:930:dc::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.21; Tue, 12 Aug 2025 15:55:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.017; Tue, 12 Aug 2025
 15:55:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>,
	wang lian <lianux.mm@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH v3 1/4] mm/huge_memory: add new_order and offset to split_huge_pages*() pr_debug.
Date: Tue, 12 Aug 2025 11:55:09 -0400
Message-ID: <20250812155512.926011-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250812155512.926011-1-ziy@nvidia.com>
References: <20250812155512.926011-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0080.namprd03.prod.outlook.com
 (2603:10b6:408:fc::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CYXPR12MB9441:EE_
X-MS-Office365-Filtering-Correlation-Id: dfe31b83-7335-4cee-7839-08ddd9b8a97b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Kmzlg0au49/cyx3puc0nOSMMpi0wo0VVsX7e+sseniQD3OaoT8QeerQogcoF?=
 =?us-ascii?Q?QgT7UW3fmgRIJNV3LW4C7qCgU74fpFToXX6zopzsrBQSzYr0HRbuUZhY+H7y?=
 =?us-ascii?Q?4W44rwlV54H3PLuFDUWHU1Qi45jGJ6T68X8l8EDBBpDkeVjzgjhw1Pza6L0j?=
 =?us-ascii?Q?j/CVOxp2GWM23KWmmSpeJlptWD90UI+5+Oxr2kWvLaO2DWcCv3LDNUFa8KP9?=
 =?us-ascii?Q?/sy365P/n2s8qwdee2YQujVd6zt/+Z1jD0jdpaKwukZtBLoF9zb+q268uvi3?=
 =?us-ascii?Q?XIalTvYBdNOHNFzORW8/90jkjAoEoO78Kctn257LDCpzSdEIO9Nq0c6JloGL?=
 =?us-ascii?Q?IOLb9VbdIPEeY9VLE/ba07lBlANYIWVnpeGTtDXop4NoKnIsjyoCu1eRndIZ?=
 =?us-ascii?Q?1h7oCgkKDQuRqadiA53FwoLv3Bn1OoZA5cdqB8tWgijCeGl5LAZhKwpogRtG?=
 =?us-ascii?Q?EWDClJSdi4jU1I/BA9XuocMdUqVL2PA8DrNeTYw9gG+JacBYhjwWFd+hDopf?=
 =?us-ascii?Q?Lr3kHHD2s0kc6n/aBUH9nxphml24w8L7QSE6IlULoZudfiol0xhtoDLle+WJ?=
 =?us-ascii?Q?y52JoLvi991c55qSDrztVVQTUNew/0y2uMP2+9yCcnOuFb7cZd+IbHcuhiCi?=
 =?us-ascii?Q?uQVPy/wo/xUHyGYloMf+YF+k5mDDM2kAm17hKL8jVlHTcBC8oYn+KQbR/azR?=
 =?us-ascii?Q?m6VWIqbmsz5OokucooIk1QwCwWRJYGD2QwjwssMl3AsNcoSS0TPNKxkiXZJR?=
 =?us-ascii?Q?cMIxdFOrXLYwZsAxtkN3oDLO5Ga+CzV8U0mdUC9NVgj8WWxboWkilCeVtJS3?=
 =?us-ascii?Q?0akeJPv07xaNG+dJ1fNv9DnYRiFisAVosZ7K2O8NyrB1GzpucZaNOhnWzPNQ?=
 =?us-ascii?Q?h/rtuctIssBC/ClWqyiKCQ7e4yKVasq3RVh+bdN7srexSc/3Wf9AzKy2hm/v?=
 =?us-ascii?Q?8q6MISpaS1fuAST3BP9B/1p0vH2ulIIJMu6vy/guwWIYFYobVS86ScphoEjI?=
 =?us-ascii?Q?0jMKFoPE0uGjF+WpaYOmjotZaR5FAKnk8Zw1xPKlY4Dr8x/u8J7ZmQBAXU/P?=
 =?us-ascii?Q?DuhJHgaA95cVMBjj0S3+nK+PTveLl0ydE6SFLcj0x8gyFyo+F/mF6w2DvUwJ?=
 =?us-ascii?Q?R4T2mHDBTpxuuGdBKzpyEsV93+iHrIQl2B1M13oUdN+nhJYugPor+2HRe0bn?=
 =?us-ascii?Q?oApDtW/8B+8nQYIM8pvMTjwWGdDYQkbwaLJhb4ciiWdDdTAGhA1WewcUgoJr?=
 =?us-ascii?Q?/ViL3mEJXAw5VgxIG5mIevifY6j63Y1Hk/LkJ69PT953hmKoabY9QdkII9CM?=
 =?us-ascii?Q?yN9L6ibaVdYmQ1Z0M5DNPQ4Re2d9jPt7mBKMdZc8mvHPsdf/AtPbsxRlxMcX?=
 =?us-ascii?Q?5JfsqcWkaZya80ZNXVrsD2V+0sbdtRI7BZksf1V3hz8CpQsuDMLpGbK7sv7H?=
 =?us-ascii?Q?OGXc13Hewik=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZbDAxyMivNU3x8ixFjtYgtKCSeR1KuH4UdzRX2UJjimub87TNhIUDMbXuPU3?=
 =?us-ascii?Q?7xnSsu8VGozXvrf85rxDJ8O7+zFIwMSvM9qzQjQn1GWDbT68bC+zRCDV0+b5?=
 =?us-ascii?Q?J0c1IlsB/eaFZh72/Mu8vxb1vZIiUuSAbTsjRseONr8iBVzTDHFnCl6YV+Py?=
 =?us-ascii?Q?+kcQN4YMxoWk5+My9ZKxKv4Gt/AASU8/9OSiyvnmkDnBU/HJljwxb16jAS53?=
 =?us-ascii?Q?qhTaP+VYxXifLCbWeBuep2R0WGCpvIC7oEPs88zEwtFrA67zM8IWD5xuv1EZ?=
 =?us-ascii?Q?X+ije46mSMCs0gNGxTMnQjyKK29V+puixrV787Y8jzX6dHAH0tbiWD17URgx?=
 =?us-ascii?Q?ANzz1/4Tm7Elb1Lu3vWCXRUCTXO+cB7qPMXl+/qXBeGBRIm3j4qm4jJFHYhm?=
 =?us-ascii?Q?jiKEak3c4ikPslRystf1lIEAP5195Gze2q2VPXqkdGQuAkg7oXwHDNaJtrVO?=
 =?us-ascii?Q?q5Brx00l5VWN53Jpqu8476awvl22UhY39GpjqbI2JTgGtz/4N906u6sXkLtE?=
 =?us-ascii?Q?EvLH3Tapn86LKuwZ/scQc70VO90u2eulDr1A4jD7lZmd8uj+j+hr/UW2dGOq?=
 =?us-ascii?Q?0xgg+XakJskIUCDbF+zU9DxJobt1ai6rq75g773y50u2I60XA1VRW4QmHLET?=
 =?us-ascii?Q?1357rb886Z0rwqy6S08TETDezDy6vP6+7iC7IKmWQeKz9Z9rXJKc9XjYNLA0?=
 =?us-ascii?Q?DV6JFfTa/Sjn1Qq5GoeuXzHw3WanF+I4t1X9WdaQhLwKg7ZI2Bpwz99Rfosn?=
 =?us-ascii?Q?GjourSK8vu7gmFFwH/5AP32lCRCVHeZnwsCk2Fq0Sk2YrJ7KsWCaq9vowS29?=
 =?us-ascii?Q?OEKuW8IL1Z+CrVIJ7UqxjkyMk9T277PddLPpt14xTB9fuyu0dxim1HyZevo2?=
 =?us-ascii?Q?UAB2isAmikGC45exZU1mbeKTokUO8CnrpfSLNBkQ3Z+bJBXKAk1GTd8kH1Vb?=
 =?us-ascii?Q?0BlMQ20vIIP/PXrhW3+bQ4qQdAz8JwHybdxNRIBgRekT+2xIrsqPYZ4RKcCu?=
 =?us-ascii?Q?SOfKwOM0E1H+011jvO8GMFjEhFsSQ8rHwsJj+3zrMBg92edjUdwIzHL6keyp?=
 =?us-ascii?Q?afen/kSN5U+CONpJXnpbaiEBNGfZuhc9fIEvNZAHvVeJgnEUu8lyg+mWCQly?=
 =?us-ascii?Q?2x+oeA6D+NvH+vCif0DbiOFAhzfsWOshciNOFo/72Nh1SqMnUhYoUYoYvoIy?=
 =?us-ascii?Q?jkGR2sfLLJqWNAIFLPjk1zsAJ6MCek2IwXi06LJ+N7GzJ9tAGKpu8SsdYaT+?=
 =?us-ascii?Q?EQMbQSjqqcmHt8aTkVa3umPIJszrQP0OGKMEW4aEGo4IRtw1yzA9THOiJ5NS?=
 =?us-ascii?Q?f/hNUXU6n0mfCXrWYDZPL0JA9uCnwvHWYinXIcV2hH38RcOHqHJ9H1Q3+rpg?=
 =?us-ascii?Q?g+dSytX8ZGanY5E0YKgjvd/sRc3NDicf4b7q7TCdeXwYnPYTWMY0v70rW+GU?=
 =?us-ascii?Q?orp6I4CEc/GAr/yHZZLaohB7VQYabEEZRj1P3Ps1UM/koP3mRUEJJhSMifyF?=
 =?us-ascii?Q?XpqljWqBqd57wZnAZA0qibvjgLKu5+liup9Gb+Zk0JMj++RFzEURb7hky0Fa?=
 =?us-ascii?Q?z5Efi4G+5nCrRUPfkCj3kK5//+nO+xuJEg7C8+IC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfe31b83-7335-4cee-7839-08ddd9b8a97b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 15:55:29.9683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bja5+Hk1Vpuh8WYQxQiBme48nCcI7bUiqe3SHq3w8+PFbhoBEWDcoIMwl2/QZ9AH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9441
X-Stat-Signature: 6nx31cacuuytu9uxnpk3n5naspgpmx4i
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F83710000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1755014225-886347
X-HE-Meta: U2FsdGVkX1/oj9buPmd3uK2SXVY9Vv3V+NORbH+XTlCJEcFcGSG5v/aBDRQRzkMY5KLXBk5FukvBVBjL1MBptcIFZobjNb1OaXxFjOXxHDFaY0wRgTLRRktfyVQu2na2Hr5nSxxLkpsDdnxcy7NV2N3zL9oXZGyRjrhGy2rfkSNkPiP+VYE+HXSxYdv2Qv3LoniYV3u99UjsoXhOhuG149gBKRwp1J48VwDuXJzYvSaRQz5/0BMh6ZLUaqvKQAjV4MDHa9dJTu/Crv0XZAscvQeBjVEASQBYhVLUt2O+OdbcldRiXDB3NKrfg8VPK+5WVxPTfZIZLN+3sDHY5FvI4lkWg0pILnVElEnvTRIpCVfnZajCcyDCZ/rgaibFkUxvIppBMw1RQzaQYAN8ipOJRZOmASu+s2JPYmm2yAsdoxc/V6rSYOcQtTdGKNGXIJv33BY629BHxdSaq8hQYLwaNAZGudSPOyohigUUoC+Ql99Dcz/oI4/UyVr4OmQc1bkMNzjfKBA9+eCaUr9mVgmHwlKhnW6Xo+kYZFdzcuqVAKYkSRtmKQisxraiCIkCuJsQLxLy58EYb0m37qUXUjN5wzp8pXQDUgMFLByyEau+zv7prwr1VX9Zzt6f2KkPJ4VNbUgkOUgmlfP6Dn5bCAbUxofeR2NjvfMVyTf8F7KkgwMZ9gssWrNXnfCLgKP94KXGeKrPAyZyoj1iNsYy+wlksf1CMvNcZF3K+Dho417skrPH3lY9tHhXBdUDIgwVtFTBSFBIU5J5z4n/E2ZC3eIMhAkrZku95dCL9PskoefRh+74WqrDa9FinPvbG7QYqLSle2nvtsvTYIZav0ObQ8wlhqT0nZnCyGGokV7Zk6oPIw0Dto0UG8ZlaQQ+CoCo/cbNCCHypXlJW/An+UvZ8mwsFxwHKsXke4yK5PKNe7xQCgLeOaSUpF4IPPn5iEa3MANZCRWwn9LGe1aMvil3MJA
 kP/jIS2N
 LTbZzmo2RjOLUttMutcOx7LvmGqTxeY1ZEycdetsF5Z2S6/rGO5PAE0/lt3l3gWSpQDGL0zvXqFs4v5S/guE2nA7UBayo9mAQoqqG+N1sWM1/eapBr8/Lv1CSS7mj/J3lcWkiPpA+ESAsda22WnTgJlxDkQHBgOAdBgUPOadyKFAMi0wdQTjxrEM6K739fWYEKM/hL7PdJQqENMk4RxnAhf6IxQm12PZf26PmV67UYw7WZjJpRPvVhaUiFxagGC83keuKVVjR42DbmXdh9HYo+wp/4jfp88wfVk2WJd7iee0+9HuBLNRKXZmOo4y9F3P5uOSuFM9CS9I1lfDpv6195X5pJCuVVy7knFu4Tr22s073YjsE/G6wiajRdrGWVn48L+W3TePOY6+PP28L++tjNDO8rwazdmrz+HVcUS6JV4rVLMPNlISFMuez3M65nthO9n47wlf3u3K3rFI8ZgZbbZ6eYipiFuN8nZLzjQ6VVolgvCaR3q7tKcfOfbRdlKIM2yYp3p7L80bbnopDLAfsCIEqY6ibhOn9rrqoH1YgReyW1SQePM5Ta6RUQ2OBqI6cwwW6d3S8yMoHSGyUqhQ9taGlCp01Q/R8mMQ8TgF1/WHRaKE3B/ipEEbgRogvbKyoZC/2npPcfGxXsoj7YXK5L4P35XeZnLMkevoI/u6Y6yev8a8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

They are useful information for debugging split huge page tests.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: wang lian <lianux.mm@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b8bb078a1a34..22dc727d1d27 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4319,8 +4319,8 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		goto out;
 	}
 
-	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx]\n",
-		 pid, vaddr_start, vaddr_end);
+	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
+		 pid, vaddr_start, vaddr_end, new_order, in_folio_offset);
 
 	mmap_read_lock(mm);
 	/*
@@ -4430,8 +4430,8 @@ static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
 	if (IS_ERR(candidate))
 		goto out;
 
-	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx]\n",
-		 file_path, off_start, off_end);
+	pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
+		 file_path, off_start, off_end, new_order, in_folio_offset);
 
 	mapping = candidate->f_mapping;
 	min_order = mapping_min_folio_order(mapping);
-- 
2.47.2


