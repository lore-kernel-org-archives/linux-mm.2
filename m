Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22FACD711C3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 21:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264436B0088; Thu, 18 Dec 2025 16:17:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 211A66B0089; Thu, 18 Dec 2025 16:17:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C99E6B008A; Thu, 18 Dec 2025 16:17:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EED086B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:17:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9EC6016035B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:17:25 +0000 (UTC)
X-FDA: 84233852850.24.FC11C5B
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010031.outbound.protection.outlook.com [52.101.85.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B0C3C160019
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:17:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FqeaM6QK;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766092643; a=rsa-sha256;
	cv=pass;
	b=Xfr4rP/TmJ136eNb/1NdF4+VyhLBx4W93oWQfNBEGgk5ZhBGuHwTV93zI96h+RxwRkc2cz
	OrEtraqDaLqMAIPeyUUpuM7jcg3120o505QaF6xFmE2I7jUPo2DBYwO1u8pZ1e4eVrj6oO
	o2VmU6NFlQljUojkCf27GKGkAB33XLc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FqeaM6QK;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766092643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N77IOipJ2zBnbSzN+a+jBGPmFh+gyXim2wROZv+vrwg=;
	b=sZH9fv4rYu8anajI/473o0+/7C6IK65C17bE0Xa2HUQ0Mn7vQtPQRb5nyWTel3LkAP3jR5
	7hn1qk+8tH24EtC8SHNzsXP8PZ1P4eNDbouYZTlcT19CBfHL8EwOdxQEJW22F2I0gDD2vn
	NwZ5tjqYOAkj8DzORdWP2UrJ0+3HfCo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VNPI/Xxd0BPPprk7LAAZxPwz2fQkiLIZOT6E57Q0SWpYyoFDF8NewpHuMdcjqAHrAVVUnCNyMhkkRh8LCOqrAz4ac2IT5ss1ax5gqCw77jM5l04QmDSAOt/I7+61PD/NlmXpXrJWPKxggI29Bm3Li37M0YJPhIat6+K1Z3ebTaxgAOETaQIJ7dlKRYdSJ0nHGIwE71/BlhKeOhlfd539nO3uZdERQdTAYG52bjEuiyYUAuI+csGExLzFEs9PTTk3eVx9y29jrcB+Mdu6e/SOYokiDbGC1BUz5EgZSBrp/Q/2TaxW/gLiK+UJSAzQH05YEKvvNzUUhJ0WVSukELIqgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N77IOipJ2zBnbSzN+a+jBGPmFh+gyXim2wROZv+vrwg=;
 b=OQBf17nPdDy4gmkK4YLlDADxJR35b5oGb0LSmdfVlyOuXfZ/eQcaXNHNbRgkW30LRcFKc9ql4dbgn0423NhyUAyhB9WlwuJ82lCtWHRZjF1tbbqEXQJl/dwXPIF/slTb94tkuviYFdxmb1Gx52m30MYy9j/IYX1GsAv1N237fIO/qTfN79UygRfJ2u3Zf8y/yWYGPaTvZw/+kT1yU2IQYNRs+kvV6UuD49gD1LCKST4M8jC//o4/qV/0s2feZGcsANm+jslwZRViuGDY2e3DSWXnqcvgvEEmxWXnP0ZDoLGE5YO8r4OR8V4nzbarLJ7axRw7NLj3czxtX3YOMh8rDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N77IOipJ2zBnbSzN+a+jBGPmFh+gyXim2wROZv+vrwg=;
 b=FqeaM6QKzkTl0lba4pxBhKK7ijrHXSadGlTGhKnBix1kKiP1a2xdd7BFHU6nwcsIDUuu3BKftkxU8Ye0VOG7fMsXTGPe4x8o9UlNAtZOQwWlV4515v+/o2tiR6z5EfaXwZER94ElmBA8POk90OjevIem36pQs1vRjSkvuti/6wMDBihoBIrOvzNkkasXatz9zjbLMmAgbFpsG7fUii8yND41f4g9Qausj+VtkRSkWT92vjVLG0MmC1HUySt7oRk9QJuGMxwpeeNK1qsGy4y5MNCi20ax9ZrLXhU3ntR69lxtuQC0M5VDl9Cy3doIGBlWdqJbScvskO5tSjJBT/FPMw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4237.namprd12.prod.outlook.com (2603:10b6:208:1d6::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.8; Thu, 18 Dec 2025 21:17:18 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 21:17:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 richard.weiyang@gmail.com, osalvador@suse.de, rientjes@google.com,
 david@redhat.com, joshua.hahnjy@gmail.com, fvdl@google.com
Subject: Re: [PATCH v5] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Date: Thu, 18 Dec 2025 16:17:14 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <01A47A14-3B5F-408B-AC37-64E36AFCF14C@nvidia.com>
In-Reply-To: <aURnLqMziaOilLCu@gourry-fedora-PF4VCD3F>
References: <20251218190832.1319797-1-gourry@gourry.net>
 <0E77F151-99B0-4F67-814A-4D79439C9A88@nvidia.com>
 <aURnLqMziaOilLCu@gourry-fedora-PF4VCD3F>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR10CA0034.namprd10.prod.outlook.com
 (2603:10b6:208:120::47) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4237:EE_
X-MS-Office365-Filtering-Correlation-Id: 18482f66-3e3a-483d-3bd8-08de3e7ad26b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vOCMvZ6TaRcRNKNkQHftsO1xzGUYrmLhY6Tg7iLphF9EaTKBFpWDO4Xv5dVq?=
 =?us-ascii?Q?ooAHJmRwQFjuPQPfgYv7f7fEiouMq2+WpaWRz8FWiCIFTc1fI/4s4FrCUDG6?=
 =?us-ascii?Q?XpJy0gZWuFx59zGHGhzpD7WFrDjc5TdsfZy73E8dEcxSwpP6DqipxCERJHcd?=
 =?us-ascii?Q?Ff/DDus9Bor3WFG4Ori4lQuGbQjXcaJiLpwAd3CWQCPXFkte9XqRxtYoKgvh?=
 =?us-ascii?Q?+pw/m7JDuNuqlFHCW3t0RJCzFdwF9o5pQshS3B7eYZPFVCNLWpLwMNnyGXH1?=
 =?us-ascii?Q?NM0DOzZN8ozuL7RdT6AVH4fDEUbO189dKxvV74iXu6031gs8F804rMzV61tP?=
 =?us-ascii?Q?WjJD9EaM1pn8vIRquRnF4Df4DZuyg8/gmxrBMRlwaC7DUuwq2dojgZxh6jEs?=
 =?us-ascii?Q?mymEDhOHiC1sdUQrQ3VVAN+Fo2uGarSKl0Bj0xWZYFOhXCHl8Llml1a1Qle4?=
 =?us-ascii?Q?0thl1cEVUtHnyaSYrxN+dfMzx18np1ruoLZNTW44qxHYHPwNfcFCLPUakWOk?=
 =?us-ascii?Q?8zY5jYpysKKtvd+4YDrBThBPf3E7p+bDPoXuz38NYjw0u7n8drqgYSEio+y1?=
 =?us-ascii?Q?Tc1s2/bxlsV2VZzfxUPgUiLEfEWBklMpIdhEADIikhBzjdC+OVIbUprUiJEh?=
 =?us-ascii?Q?40WG67i9IjKRbSmZe7z8S3LBt747iFnmqJJtqT8M6r/ti7KE0M9pqM4eI0q+?=
 =?us-ascii?Q?mBllYpIFuFEzPIPPihr/g6M87uLa9+ILSJRU1+4aNeobBN/EffAA/aEcZmWr?=
 =?us-ascii?Q?R+idR4TMWHz0dgNQSkpzq10zzlc8ONTCL2mlIxxjFcfdIYt84DTwjnCh/4k8?=
 =?us-ascii?Q?ItjxN/G6SlinbavgOiewhrK4Dbp1MGP3CpNUeCU0r1lG5/xAcfoz2U0cFPk1?=
 =?us-ascii?Q?5xvnNKXOhY8R2tKQYLmqAd6zQAr3JTYbcdVwQjaVTT8NP+pUoHsW2hkdgSyP?=
 =?us-ascii?Q?Y6nRQ3iVu5rR6J+ywM8+o6dbunUCFKHUXAXwa8fMpog6NCZ6pYUnxbC0y2Aa?=
 =?us-ascii?Q?666m/lECgritYvLqh41lBpy/wGM/A4tspuEDoOq6Wn5sEKsyl42KRyrKUn2a?=
 =?us-ascii?Q?XIOhbe97MvAy/NfTWGXs3dAVAkVPB80qPaQfyvSgTsCZJRvzTB6cZ8vlwFGm?=
 =?us-ascii?Q?XtRbpuOyc0x5ZjeQWKq7wmmQ4h9bXtHikRcFdMJXyR+baeJZY/tR3aVlAgkU?=
 =?us-ascii?Q?urjmtpwDLSQZA5gdGyPAPT8q0Av+ThcDpr7PKg5Myeg1R0iSkXhNhBBLS89S?=
 =?us-ascii?Q?ogt5jMvMam8clFPC10cFSwWRXN+eSqDe+4TJrXcCDD2B2u+iejjzjd7zwEAP?=
 =?us-ascii?Q?zIUX2OCCH42lnvR3R2bub31YMMUry5GDIOfwIRBLLaa8s5doFq9ZTNLwYSuC?=
 =?us-ascii?Q?bLyxV4ObXJuJunfyguYirWM9AQQiU7+yTE8ZjGyGFy8gJwJdEXRk/qtq4lsh?=
 =?us-ascii?Q?1DXPtZClxzzAxaL+Kg7XdFOQpEoohnvx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0qyNsRXeF26lkQg7o/KU1gkkb+4f4IbNr1PqXp6FXXPABy5zIanR5nn+eFcY?=
 =?us-ascii?Q?CMeNnzqqUrvMPuKHwv8Qeno7E/T/CTigbLPEroJSwkMd3hkXZP6hlxqA+wJ/?=
 =?us-ascii?Q?A4fDFfnwcpSZE6QhSe8uPuExtkhwtiFzd77BzYQrIF508XBayqIYu5FwuMCD?=
 =?us-ascii?Q?BF195uYblFLXPGKo2bAzr74ZkLkYcaqpU/yIyzqWQ3CK/X1RMfOseWr9T7MB?=
 =?us-ascii?Q?fIBnX5IquNjzbWMB0NRypjBm17XAtxHjhG4aqhHb47uSy0b7ButYl6TlbEPT?=
 =?us-ascii?Q?bjsg0KbO8AGfEfmCBAZtHFNe/3iFxzEft6Bn5LbhSOlNLYU7zHoC8gywozBR?=
 =?us-ascii?Q?Q/F89cVxTFPjz/IXpRzREFErOcn4LR7lb0Z0wDM68lS0Ra/FOS0c7FA5Bs1C?=
 =?us-ascii?Q?C0C/EZ3U0BcaqY3x8I5Ey4XkE+2jB3G9FNcUuzEO+SF8j5vcRq++IeXUHnPB?=
 =?us-ascii?Q?NmeQwhz4GZzpq5NuS0sYeWJDPKMt69OjYdjllTYiPbn0GlQIWvjg2CvSFWDM?=
 =?us-ascii?Q?MOFrFBuL8hC1irce8Qa7U6q1ps+y27A0WuNRVazfrh7UwE9Hq/TRcfcNmP56?=
 =?us-ascii?Q?wf2qQVgHzP22rWxzoDfVOAM02kTAn89cxN2I/zwsbo0b+0VbiWNfzb4Ie74V?=
 =?us-ascii?Q?emlXZxJpMVXVMHHO3uop1hsWYsDCFS+cp3vZPc7qg6zQIyrKPRxI6OJdwHmk?=
 =?us-ascii?Q?TB8tadeMf5MhuExIMHiaYEWv3Ils4QtMVMnAZe0e8OOOHFv/dNe5qLA4Y/Dx?=
 =?us-ascii?Q?ZD6O1IxJndUqFwtqhQnsfQgfL2eFmIR75x6p5mYJGKDmOY+qWkqByLTIhjoQ?=
 =?us-ascii?Q?4+Na945lKi/9dVLBOsBoK3UmvoRE+8GLvaA+rmtS1EtO8bknVheIHsThGjcj?=
 =?us-ascii?Q?ooCjG1Igvtrx+MhnVnesV+QljZVV2q1mtChIFxMfxQ6QDGWhnMFLkjJEANub?=
 =?us-ascii?Q?5vGEU+XCTVndYl8qzQN4e0PdY69oKenXeU/hYUZCwclbuhFZ/im4CoC3jCmm?=
 =?us-ascii?Q?+CzSIXHtyt1Z9NFZCIDG6sjDiEsMDj7rep+U+3YxqABvgPdriaMgzulbu+dI?=
 =?us-ascii?Q?hqqjxF4hh7DbX6csyPGpbx3to4SjncQ5f1CKcLNhmRc4Eq/qb5GdfMGFB+lL?=
 =?us-ascii?Q?9g5EJu9yJULPVhuvFhZMTOrLDEpPeCdDM3WcDUC5xfp3PdlYXyoF6Vgy1JlG?=
 =?us-ascii?Q?g5S82x4tfo3/sPYZjrBWJiDhp1xuZtU0zs8C3pbU2jfvRqCO9rRlioW1HQJ7?=
 =?us-ascii?Q?HXmlEWZM6qLQnQrK7SisoB0o/wQCPI7Kmd/1+Lv6biH7/HOUNwIc4eNTbvdy?=
 =?us-ascii?Q?jSjGmhHwmXOEA0N93zsEC/Ba6ytb/q7SuW1E0Sq560eIpq6eTfxaOG5o5Yfe?=
 =?us-ascii?Q?bUEfwwmFSpuQsUMhV+wsT5VCtDIclPeBDvP2cGwRqd4Rn1RyORjH9COGYvOU?=
 =?us-ascii?Q?FMODtY4AM2eMnDhfar4GkZeerFjsUI8dbTs4oIsw7rUkyvohEui8kCK1IIbv?=
 =?us-ascii?Q?PvSO6gqVTjQV8kkId8WQiHoRY7qxMH1iwPNtR1xLQmWZIW8PDV4uvkikgf75?=
 =?us-ascii?Q?f7lotf5J1MkN+tI4JtDlfDK2ZJavrtL0ivzSIiVU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18482f66-3e3a-483d-3bd8-08de3e7ad26b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 21:17:17.1336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TGgvzsWMValfhDHkzC7XmrvmD9Pxfw7EzNH8lWTQwn7PDdO4wymFnN6agKLaZGgF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4237
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B0C3C160019
X-Stat-Signature: dmatpbzhwxyjyes9awwq9emc8oyzh7zx
X-HE-Tag: 1766092642-630406
X-HE-Meta: U2FsdGVkX1+AEuMpOXFiesYpLmW9Hph6KShNG+doJijMajJV8D2NfSmOzwsg4YUokWYV/d/xbeofCffjjPu9chR4m94tqpdMKIoSA9Ci8w4KQbndyr54UdZY5bQJc4w/EiKaEJQGCxD/A82LhNb/fSvF/iyTGaxdVq6CABaIeuNT1vfT/nDnFXre38p04rnlHH2K9tQfv+OqNPSNR88CtIxqxp/sEVQ8bcJRzfKMEC4+Khh+xmPxcmyndPrkWZ3PzT4gGHA72bC0CR0hY4MhuxlDxOr58icZjwMu78huo56EviEqjaqYm0n/FaOv/cZUoHhC45/UDpUmJVcPbPCvc/fLa2sj59Z9TahALiFYGavETEAHDhMjPAR7HqE9ZygadxH74bXLrkeTlvH33W28bnL4Tt4MERdjI9Gc01J6DpA7oMhE+OkgN2GhP5+9mpof1DLAI6EPpu1Fmzmkh7EDysqBbbTsTVH0yqAis53Env7iyXaNu/2Iv2x+c5c+iWuMpeUDBonG4TQD5gPoG052EP6yuJ4k3WrCrbByWesqakGzibthis2b93zWKhaZJ9RtVCQy5arEfTRUkZxjM91KFQ7+hioidAJC090Srz/1y4oFKrBeVflj0Agl1wLJzc2w1lr/FphS7YOJleYyVj/zedmZhs1SLoCpNVCBvcAAPC9Go29CWTIjA06EUfjbFK2X2TgQtFii71JACDMN1Jf6pIQQUpnotyaYWoLb1nS0X5gblDso74QztY67KmGkT68a7ktwIyDdlHLhBpUjHzrJ/EYKFg92weAGUjVUDi4e/ZKJ0Zf0O+Di6ApQ3e90tgnT4lGlrPEDTybZYhS+LBmcu+0s92ODH/MKdaAYl9ajQ9S3xu8eHwK1BV2gRTPyvle34nCOrnyIb7nH5MRVpT9mxhiQ7pRQq69z2s33jvgT3Ez+r6T+FUn3wuNIf+WIEJ+RU7IEhfdZqYensI8LtGd
 Y8NOX43j
 W5zpvd9jgD8doMpxMsMH0Akn8RO3/ADgMb9D2nSHr5dT2tFY9wwP/dxyal6czyOuoO77J+mwO+/p+hnSFjg7yVRca0f8TUv7yZvncgpYXw1duE5dcrJUqC4HglkbmGQ1G+KX13BGmzs+cobLo17Lg2dyxNQZtlnJftI44BduitIxJNuLhFXqvlj0YbuZQzrYrT9lPDi4J4o1NYTejq+jHJVbdQ5CymRlGxPefBcr0WUFie9Spqx8m8GWu3nDz5pzAvTFC90AXqrFsCPXLt5RIMs0pI5KXTupjr7ls2m0Twj4SEYoG5zD7tUOKruKVaRi5IrDkqIMpdgNP8Pm4a/OfVspaTJMn6J8rUZisgRPCfepOiQBHf4wz6VIp84z+0QhDfoPm2oozgkZOYn/LucMcroIJzMQMyJakA5S3+j90T7K2IQyH7lbkcIVcx6ZRtRDLHI9e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Dec 2025, at 15:42, Gregory Price wrote:

> On Thu, Dec 18, 2025 at 02:45:37PM -0500, Zi Yan wrote:
>>
>> That can save another scan? And caller can pass hugetlb_search_result if
>> they care and check its value if pfn_range_valid_contig() returns false.
>>
>
> Well, first, I've generally seen it discouraged to do output-parameters
> like this for such trivial things.  But that aside...
>
> We have to scan again either way if we want to prefer allocating
> non-hugetlb regions in different memory blocks first.  This is what Mel
> was pointing out (we should touch every OTHER block before we attempt
> HugeTLB migrations).

OK, you assume hugetlb is harder to migrate compared to other movable pages.
Considering the limited number of hugetlb pages, it is quite possible.
Anyway, I will wait for your v6. Thank you for the explanation and the
prototype below.

>
> The best optimization you could hope for is something like the following
> - but honestly, this is ugly, racy (zone contents may have changed
> between scans), and if you're already in the slow reliable path then we
> should just be slow and re-scan the non-hugetlb sections as well.
>
> Other than this being ugly, I don't have strong feelings.  If people
> would prefer the second pass to ONLY touch hugetlb sections, I'll ship
> this.
>
> static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>                                    unsigned long nr_pages, bool search_hugetlb,
>                                    bool *hugetlb_found)
> {
>         bool hugetlb = false;
>
>         for (i = start_pfn; i < end_pfn; i++) {
> 	...
>                 if (PageHuge(page)) {
>                         if (hugetlb_found)
>                                 *hugetlb_found = true;
>
>                         if (!search_hugetlb)
>                                 return false;
>
> 			...
>                         hugetlb = true;
>                 }
>         }
> 	/*
> 	 * If we're searching for hugetlb regions, only return those
> 	 * Otherwise only return regions without hugetlb reservations
> 	 */
>         return !search_hugetlb || hugetlb;
> }
>
>
> struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>                                  int nid, nodemask_t *nodemask)
> {
>         bool search_hugetlb = false;
> 	bool hugetlb_found = false;
>
> retry:
>         zonelist = node_zonelist(nid, gfp_mask);
>         for_each_zone_zonelist_nodemask(zone, z, zonelist,
>                                         gfp_zone(gfp_mask), nodemask) {
>                 spin_lock_irqsave(&zone->lock, flags);
>
>                 pfn = ALIGN(zone->zone_start_pfn, nr_pages);
>                 while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
>                         if (pfn_range_valid_contig(zone, pfn, nr_pages,
>                                                    search_hugetlb,
>                                                    &hugetlb_found)) {
> 						   ...
>                 }
>         }
>         if (IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION) &&
>             !search_hugetlb && hugetlb_found) {
>                 search_hugetlb = true;
>                 goto retry;
>         }
>         return NULL;
> }
>
> ~Gregory


Best Regards,
Yan, Zi

