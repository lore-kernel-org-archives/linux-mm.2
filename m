Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FDFECAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 15:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494538E0006; Tue, 23 Sep 2025 11:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B808E0001; Tue, 23 Sep 2025 11:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A4D8E0006; Tue, 23 Sep 2025 11:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22DF08E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:05:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4C0F1196C4
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:05:32 +0000 (UTC)
X-FDA: 83920838904.24.D8A9B97
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012061.outbound.protection.outlook.com [52.101.43.61])
	by imf27.hostedemail.com (Postfix) with ESMTP id 115EC40011
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:05:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MozHKK+n;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758639930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aj3xnN4RFHxChNk38/x03DKIKmIH/BtgeS8loWgKpG0=;
	b=NGQfXJ8A33T1ysa0E26y7WzyVbg25l71px5O3JMwvqowg//iYVDEgrB1Gfoin36PQIWFrn
	j2Dk9vhBiiEtmUbWY52yMpu6Xw6bT8Rg1Olf9ZBM0O/POhNeg0VAdUONbwZemIX7lhpcut
	4eB7V35T6Sw7ZIuaoHjblIxPz6F/7KQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758639930; a=rsa-sha256;
	cv=pass;
	b=EFWC+9VNv0WxFYkXZsesuvjBhmB4s3dWk8AFUPOWwNJHXy84O6Eetd+qHEyYWMVoA/oxGK
	KlHBqK+g9aYLYB7X95X4csjDUFZj/52kODjZ/yI1B4ey1/2mWynz92EsJK7rmY+UoJNCsH
	fdtlTi/+RCm2We2sqLUJjUTjw6/JdTg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MozHKK+n;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HiZ99hoGyAPaQt3gjIdSfdPE53legliHoZ7/74AbkBFzxcNa3XGxw7iObIYJC/7n88xHIGZjqMo2Cnhf2W4F2/ybvOvdMp52bfNC52hEsMtH2cuOW9xRmt0PYy//GQ5t6KYq4mmaUiBR5I0+NghgJYoL3i87za+6urbalwb3BE8pJbMR/Viu187nyCbASqQyvaxWBJDJLUDjodDHFepuy/iwVNYI2KtdyxSb860gUHG71z1/Fx5DUOm4xH+9WN/Wjo7YCMVI6WGR2BI21CqPXjTT6Woh4xmuRGJXBY8XdJwBMIct18oYPxtwAZP28DpObWgLPF41HLKq7ds86H8MtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aj3xnN4RFHxChNk38/x03DKIKmIH/BtgeS8loWgKpG0=;
 b=ASzuglvL98y9mmK68htLznW5yPyulxR/fKU2g/7cqCHNIvDBx7La66sqCT8XB+pRNIq0RXeyhSKTf7PebOK7muJewQokqfWMewCy3oZEOCVVUNKZ9NOBO6Qpou1jNEsnSQ+Nnc3w30B9BoLFrHdeyxBM9qnOyP+hL4k7f3ofU2EghZBEUu8eZND+7xFHG5mU/jKQ+KOVSrshG/FqLB/yxQtOLo/c51ESrY6zdTsFqL8LcGZEnWiq6T5kR0tpdOowe51u8f25fzHt4S5SfaWMPWGfHfN+cPn7iLhizKQS9tcnfojIiZ20jM9HO/fbzDh+3ys2VldbRIlS1GvegKVwwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aj3xnN4RFHxChNk38/x03DKIKmIH/BtgeS8loWgKpG0=;
 b=MozHKK+nFpZXlF/eQJCfn2pkPRGPjxkiDXQjRHeTXhIUQvdzWorG1e/PhcuYW2VaB80uSjmO2saWr+aLMCvqDO5M+2RKkDHc7L9q6fm+xesLiNmqRs5fk0SMzbyVYV31FSZBEXx0deQQNQS50mEqnjV8BVun65XPBI+esYLmvbYaK573RucIDw5hZKs8uapQknOP92gGTpmy9Pd95og6CjeuD/yVDfaBVWPuqTGL4FdR4/5x1GzNeLse7VXfqeRDaeTe6HqnpZhih81YIrjWmo+hoyhK9LCbWfLxjfnX9lk7QxYXv9JbGUBKEpAdL/rJLI1eH9ib5VWtb5ypkaTtNw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM6PR12MB4316.namprd12.prod.outlook.com (2603:10b6:5:21a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9; Tue, 23 Sep 2025 15:05:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 15:05:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, david@redhat.com, anshuman.khandual@arm.com,
 linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
Date: Tue, 23 Sep 2025 11:05:22 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <561FB62D-AB2D-4745-B089-59C36A66D27C@nvidia.com>
In-Reply-To: <fbbdd325-a8c4-46b3-b303-a8082a11548e@arm.com>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
 <fbbdd325-a8c4-46b3-b303-a8082a11548e@arm.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR04CA0050.namprd04.prod.outlook.com
 (2603:10b6:408:e8::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM6PR12MB4316:EE_
X-MS-Office365-Filtering-Correlation-Id: 614f0945-7a5b-4b5a-6c58-08ddfab2a064
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SdqZU1/kOo5wX3C1gZTs5MLm+nxggj4d9pyCkNJiSGGAB5UeDFNbfHsFaLs+?=
 =?us-ascii?Q?I97ixghTAImPP8LLENYP0vCIdhp4oQcRULVbjdd4+vIPomhQVqKvoce6E+OV?=
 =?us-ascii?Q?h8qh+SNILmzdNEakW9j5b8pf3b64sruAsRSalSFA7zhntXdnhNTzThu87Tde?=
 =?us-ascii?Q?9ivwxSD1flQ0yczy8l2TItQ0hz21BTG5t1mMSo3ITK+sM/m4rlSy4akl5UPE?=
 =?us-ascii?Q?C1PonpwPaA8AGiFvP7IC2x1KwH0b3o7urKoAHQ8eg7BUH2RHEVRINyhBvtrb?=
 =?us-ascii?Q?3HlTjzmsnaiUfdmkgEXx8H/5OCMKqfXp9tbcfVOIfZrxdY1c2OrVK/U0OHdE?=
 =?us-ascii?Q?vZaWz69V+VQndF0E9jfBYDKq+Sx1EfM4MyqF3Vw7eiHr8+Qnf3rSAXJhY0ux?=
 =?us-ascii?Q?vgkSUGiF9l613RuROtIh/622i/q8NK1eCE8NsNkTmC87gTGrCCekEy//DKRZ?=
 =?us-ascii?Q?lVJ70uS/Ppy3pNt538adcfaCU9C85bY3gq1J3897+OeuwqvlmJWf+zfkM6AC?=
 =?us-ascii?Q?9XYS/n28eIi0iNURJMWigp0/INAOJDtWI3MpkvF/FNxept12imE+P48KzCuD?=
 =?us-ascii?Q?1FYMh7N8d7QlAsKYqwwCKf5cwuQww6QnV/2Oo5HJoPcFTC2Hgkx+FbsrANKg?=
 =?us-ascii?Q?gUX+X2ehkAuIxJlV2eXOlAALLhMQOJdteRzH/EbOZTGswJpVLEPtH3YqaVqQ?=
 =?us-ascii?Q?NYRXs2rq6ZWYbyqCxJn1ehN7M7GIgmo5Y83QUrMPZwsaowZ0xlTsyQwDy6tH?=
 =?us-ascii?Q?nlGgBxDsMV41iQSUzQ1fqILtVXGoIDpBy9V/+xj/xRMwkLZSeGg2ZLBwLk7h?=
 =?us-ascii?Q?gJJunPgtyVl1Um+Ge8G0Ri6FgCdBxNhd6/O4vNUtRRhqcG5wPa8kewnNZK5/?=
 =?us-ascii?Q?4FLuRZxL9PfeAJue/xRF5dcQZXHaWD9pWxUNpW2+dZu8xU23npzWChr8bw4t?=
 =?us-ascii?Q?7ZxgMaUrSdzXbyy7siqGcqjBSEOEainpyF3H6Q3LLKN+go3uC1xJhgvd1RbK?=
 =?us-ascii?Q?628ez9cA+/JnU4hpM6k+agUFes2FGi5vxkdYMgDhK+w7MtifDm8SrILfOrRl?=
 =?us-ascii?Q?huW9t8Wd81I8IloBhS64zZhBZiyEiT1p7kIuCuo6H7QH/Vat0T6pMKVVvmXf?=
 =?us-ascii?Q?Q4T3lsTJNBpCJy+Kvw5FMQfNSXfsdQP4HaCkAdqYDX0goDJyJ0K+lmiTBwNy?=
 =?us-ascii?Q?IlnSFxzseJ3UCYUH462efu750qkSV0o+MBLCMIRQK1y91YM9/Fi2Ux/O9mh7?=
 =?us-ascii?Q?ttdt2fDtpwaRywcncryOZ/qFq3spscNjBe4ukc+9mqDlidY70MuJwlm1Ntyg?=
 =?us-ascii?Q?SO+oq263FGyGMvTW3Wdg+2Ihnb+fVUeqDdGe1im1bsNyK42G5xXLDon+8pHk?=
 =?us-ascii?Q?T25LlA2ujlZRxdjqIwo/V36f8fF+UW0AINE9wVrH2v3Tp6gMbunTJzrC8V/m?=
 =?us-ascii?Q?mCiht+kjatg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uLGsGoymVUKYOZsM+gDTCAYjTlcAeuirfDYd42E/GE/yRCnNSdunNR3Kwtx1?=
 =?us-ascii?Q?WMbuhiutBmBn93mxI60XSWdwWe1PbKcgbtqBmj3mlxamiJjO4hlsACWnd9ht?=
 =?us-ascii?Q?VZJTOWGfVBP8TOWoV1Ea3XNrYtqG8iuzMsf3Z4XWqI7ZUEOpTNt+r0+om69o?=
 =?us-ascii?Q?SQPCfeTW9FNImeJXweKpnnwcDjwCNd9NO65fS1f11XcBMBAT4BaEJZu9jnAs?=
 =?us-ascii?Q?5Uswi6MS09vBnO4an/YEs/vYnXRV8OVA3w9Q8bKUfhqHvFVBZR4ij6pFy8OZ?=
 =?us-ascii?Q?2LKhH39oi04ovfz8is94JVVUGZSw7kxoYgS18gXmWmdmg0HraS1o4TSHBlpj?=
 =?us-ascii?Q?47zhPUU24Mt6uRS31WW/+0jPtykMCAUVGrIaz4GyDqi8F9IzSQtlrKrbSS/z?=
 =?us-ascii?Q?wCk6aHrDjw/5doxZpyX5hQ8AiSILNpM4GfiTpWjmIpYq2+VUMp5/coo8UhcY?=
 =?us-ascii?Q?LpIGs9TjgzIGUR2HFfD924TAwXrv17+0Hn2jzDFGlSS2691XLpD10tmeCFjU?=
 =?us-ascii?Q?tCSQOyRjqSRzL1kfzVAaF9pRInwbfrzJS95ls4Jiy9RkpooOv3YdqSO0aNfX?=
 =?us-ascii?Q?4C5aUoIKQJmJ7k9OCL5c5p8hpqI499iDYlLn1cYklCx2gepLNJax+v0Pzlv9?=
 =?us-ascii?Q?pjE207PuJURFUmIWWaEsquDbUKBtFGqAw1MSdXA2yo0KnNTRVCRq3mwzueym?=
 =?us-ascii?Q?TCjoRVaaMExNK7BIRGQdChvo2bRqxQJGGdhJKHpoLXQyxtfBz1yrWq81CTDr?=
 =?us-ascii?Q?sBaYaCZgSo3sGopUiE+ftC0lnIR9qzBFMTG8cI6sV1sKSzBLuBq8/je35aVh?=
 =?us-ascii?Q?ieIJRgO917H1k19F6hEWMc8QPod3JlTraV8BxO5/R3Lq9RotkRYPxm0y/Bu6?=
 =?us-ascii?Q?fmaqAI4N1zfyBzyLNcZ2aXfMYLKvRJ/Ds+lLW1agkJC2JpoAxSB4fQ77DrHk?=
 =?us-ascii?Q?bfnT6LhdpWSc6ZsnaZiEoxbl8T+qjY7uW5RVVl8OsfptNx9Z8KQD1HpevidB?=
 =?us-ascii?Q?gosS9ruKd7dhGXQO+sxxeYyyXKcLSEhaBhWCghT4TB6E4tHEM95th2MSc2QK?=
 =?us-ascii?Q?KspcPGrNVxKK3hBjw0XcAQLuFZr9NZ8Ht9SfGEh/jY+rWXsAzbGY5Zq54cii?=
 =?us-ascii?Q?MpLXOdBVhrD/Yc0eyltXpy/b8hFzTceVFDd8YjEaBEcSJVi35aKc/HS3jrNX?=
 =?us-ascii?Q?AHg5/NFihiS3ZMOwVPB0Ie5kso6e2eDXTHLYEiJ3PcBEv9f+xDvpau33lx6M?=
 =?us-ascii?Q?Wt3BV3ccumtgx9Bhcdwk16YtEBKnpt1hTL+AjRYwFW2zFge4axqm1GnsvzCe?=
 =?us-ascii?Q?FmbVQQO5XhT4XSp5yzPRB2x2XuWf292kU64M0OqnDkteoThzYp9cVKNRrodD?=
 =?us-ascii?Q?+UVtbyG0Tc25BFvAP73VK6E+6yD6uM8vyauMNVGzoRZPYLwsItJ7dfxRY6S1?=
 =?us-ascii?Q?EU9IVlPDNQ4k5evaklW+iwHMU+AdYR1MpKROyz0fWJQ+23vA00cplnKc+GOk?=
 =?us-ascii?Q?iSDFgCps3tAsnqNc9JBiyAs8X/dspvEJsvana9qFyO4rDU4gZTlhdHYu2vGD?=
 =?us-ascii?Q?cIS7Fn1yBfVkrbRJdZ+DZ1bCniOKdjR1skwso+Qi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 614f0945-7a5b-4b5a-6c58-08ddfab2a064
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 15:05:26.0816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YYr6rhd260Q3Sk14bRqjiUtUWYM1y+Qbdsh3swFtmtF0x8z0vUuyHqo8qOm5N8p0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4316
X-Stat-Signature: y5z61qfkcsxc8k3ghjnxmb4o8ica9icw
X-Rspam-User: 
X-Rspamd-Queue-Id: 115EC40011
X-Rspamd-Server: rspam10
X-HE-Tag: 1758639929-217289
X-HE-Meta: U2FsdGVkX1+Cb0xiB/h6U93WzGI5VKdAWWP65IDiPTgDEQrtAuLcvbBAmKOVq6Pk2p7F8vtWLSOzLqWcfCIc85ddcgq5A6+sOquqd38x6ziVocKhciu+l+3T2VVCCRyyWP4fP/xaudhle4sb8BwxphIrG1vKpP8gtytli+X0JyW5eewNqbNvi5c1muufi1ZNWCBrdHksj6iiS/Zdo1wUl4p4aZRQAfLr7WQF9DxRdGoSNP1d6Kxwj1t5U8NkV4dflYcnbHsBnIlaNsoTxeT1cIppf5LhIg9BaAG7h61NyPb+3jrrSXK5Y9XjwYOSoyhvNKQNUEbicimLRVtsuP98KLLOTR+YquW7RK878Nongp8c8fwxpV8vZCqhOrJ3Mipq62JzGyafNhL1zUOwv86E9iD9/iFhhjsUHm3k8KmKBtgBkQd0gFTuNSFgz7bTsWK6xMCA4kFiQWOYFbdkdf+6dIAUYVHd9uE2/Qrve44Yj2qvA7A2Qbyr5nnQ77KCZDDqNuoyYsJI02k5tivvdgwvGGbv5w7l/v0pTZNvdkiVAbxbABqm2Db3eDVtfcTcYBkSUZXKu6wPNYGwNWwNzQpIy7NVxxbo3livO3MEivGqFcl/khOYdDRLcZ3Yu1C4DXhf0BxS+4gDLexQfMmcyD/cIb3obOW8UikaiZLxX2uq/BFO6uraghiCkqpNTse+K7HAZW1r1hy3AN7OYyPkjCw12oi+UFgiBuNRkI84ZV1pLAXBCOZGmlTFx9Ysy9g+7lUgiAiErUZIO2fz1UkXFgf4jBGG0yoJzDQhJPpPPhH5nY/Bnw7bSIc0+YFRfIG0klVEN5pOqbGIPXYyiX7xklJGEqldSPmvMy9Zcn/RZqPZLxvZPKfnrvP0mtMWgB9zyC4uQ8cMDObHru5SLiXGGfGK/CT2kDthsqsPGStVWDJGF78b1hKK1e/W2fWZi9zv8LnPMMP6KF2kDpcSz4Wxvwu
 TVIgtprB
 cPTVmKJH1Nmbd9CKhrM5hbjVwG0YElMDqM3QwdR5LdMmXA8iD0KfLtuAwa2aU6j6BJoCxF7eFnyfeZ9V1dDABZbFJ3YkBxjMULOYjFbVfF3zDQpdVfGNIvl2yUJQXEIax0oZ+FmbX5FDK5viriwnsEGPX1lmY6vRwPdE4/Uwmhf0YeniEk4N/WP445i1FGtJUXaE7xzz7SJc13fRs6rkvRD/4SfjMpBgel1q4phWPK6bWw4e9VIMrJ3rSk+HVmFdcaF11KdkLuDyResbgc/JD2zidkgusEuW4dSdTpZ4XDYYPnUBHJYQeQAVDQXTwerYEGPZfvpiKHs5kVuGY+Gb2Ebt2fw0UaIbwhIoP7++1tV3Kg5ubgNh3YkEEvxCy30cF60zRE3bf+vSfAxnyjkG7adpxNDDydWRyR11lF8Gz4LBFIMsVUf3A12Wos15IZUPFNuaM+4hSwleXfpUx2d+xkLcIsjXZtYEjSZiK7Vm5ToMB1QlQrJk4BkHGcyFzOtUCKnoHdEqmGGxBkloqQFSWFfQPVIqma+lqT98zOQwm478NCxFGJ8ldh81PZRuXrHbqWk75FWeEkshqWY7rAC9d68G30l7VN6jTpjPzzFzSC7DXqul1Ivu37wamCSt7ob0qpWV0t61bPAbseggqmXm/WFYd9nrlbPiF8OigmHe4+iCA4wDwEVmxC6fVTnikthGaNiLOE5p2dPe9iJ794OsADn3Ik0Pj4PZz2YGKoxKK0Boh8+IfI9LAEzWAi/MixKyCh9tXrVW7eLowH7Y8U+aI4nne0YDU0/jl91+MMzOIgDshexXq895j8gqmkRo3R/U84Qee
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Sep 2025, at 2:47, Dev Jain wrote:

> On 23/09/25 5:49 am, Wei Yang wrote:
>> Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
>> introduced generic method for alloc_contig_pages(). But the alignment
>> calculation seems wrong.
>>
>> Since ALIGN() only accept power of two value, while nr_pages could be
>> any positive one, the result is not defined.
>>
>> Use roundup() to calculate the correct alignment.
>>
>> Fixes: 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
>
> The ALIGN() statement was even before this, but not sure if a potential=

> caller with non-power-of-2 nr_pages was present then.
>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Brendan Jackman <jackmanb@google.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> ---
>>   mm/page_alloc.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index a1bcc1e003c7..a17a6014e3db 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -7095,7 +7095,7 @@ struct page *alloc_contig_pages_noprof(unsigned =
long nr_pages, gfp_t gfp_mask,
>>   					gfp_zone(gfp_mask), nodemask) {
>>   		spin_lock_irqsave(&zone->lock, flags);
>>  -		pfn =3D ALIGN(zone->zone_start_pfn, nr_pages);
>> +		pfn =3D roundup(zone->zone_start_pfn, nr_pages);
>>   		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
>>   			if (pfn_range_valid_contig(pfn, nr_pages)) {
>>   				/*
>
> The kernel-doc above alloc_contig_pages_noprof reads:
>
> "If nr_pages is a power of two, then allocated range is always guarante=
ed
> to be aligned to same nr_pages." This means that the function gives no
> guarantee on alignment of non-power-of-2 requests - and why should it?
> It doesn't make any sense to align pfn to 7 if nr_pages is 7.

I agree with this. But giving a non power of 2 to ALIGN is unexpected, ri=
ght?
So maybe only use ALIGN for power of 2 nr_pages and leave other cases alo=
ne?
Or like David suggested in another email, align nr_pages down to power of=
 2.

Something like:

pfn =3D ALIGN(zone->zone_start_pfn, rounddown_pow_of_two(nr_pages));

Best Regards,
Yan, Zi

