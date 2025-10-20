Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39E10CCD1A2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 23:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8603E8E000A; Mon, 20 Oct 2025 19:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8380C8E0005; Mon, 20 Oct 2025 19:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E878E000A; Mon, 20 Oct 2025 19:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66EF88E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:02:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2302A119A16
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 23:02:22 +0000 (UTC)
X-FDA: 84020018124.06.0FAEFB4
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013057.outbound.protection.outlook.com [40.107.201.57])
	by imf01.hostedemail.com (Postfix) with ESMTP id 600D74000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 23:02:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lu8NK64Y;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761001339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UC4ru6M4K9KavDSATdEHcw7K35SUPeHeyT7DBobv4ys=;
	b=cWwr2jIA4stWMAWQgnLBlaRZP2W8IxMwF7XQqhmcShOkSGSx+zkMIBgjWE8L+Tp7nCWC7K
	Cxd80oUSlvihRmHPhhhmTgDcLSuFWdjlWj3xMWExlDKCYwvmaZPoLBlKqzNz1OclEwajXe
	trzA5aHZ1/DA/vY2zubVmVjqc3IIyOw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lu8NK64Y;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.57 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761001339; a=rsa-sha256;
	cv=pass;
	b=jjiLE/RkgCmjhwkpGMzi2c9/5zUr2FEM81xcTtWilHQ9EJUgqyws3Jz04fe04jnQhlnRJM
	eCFbry1JHvpf2XQZKqdyq3RyzfhMS4V3QzBa4H5FF7Q29ast2CF4/WKDgHvKDVoMPA3LcJ
	v/DSrc9ICaWki+YBt76ODLn9BKGjyiA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JEzLRCfHeZ7qAXZ2ynbFwfgVKRmF0zbbjoGJhTpnfmZAx97KF0ar0dFx8/Z6rtPS8oLAOd8JWme/c8GQOQfp+QCyTByhRUKH5+s+3RdKvFfgjZ30x4zbpFkWVcZh016Gjbpg73twIrlx6ioJ4h9nBLarlXnlPCW1gazBVREDofpSfeU0kZsVhn7b/uBRKYNwiS6CczojH3nVtD7xS9ecimAx07ymuoxFBCKgIgToXodfjIjmVwR+ABYsA7Q2yD6+63/4ko7kvZAwCZ3Gcj418t4/IkvgF6QQpn62o/R5WECrZC/vw0JA31rinIe7ouM5Y6hxks7ERRsL3xpTqbxzAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UC4ru6M4K9KavDSATdEHcw7K35SUPeHeyT7DBobv4ys=;
 b=B8pkWHNsqKbNzV/LhO4px4MUMBs9g37Yz6lPlGGc5ODZ7XC4u06Kurd1qN/lXcHONO5HXh1ZZpk2h3iqoZ/l2w8hd+NCYM5tj7GY4hXb45y9sFoc11CinE6MIZDIhWT7JR6R3ygWYZhMmFsp0Gf0LQiL/wqVJ6xhO4TzF6RBAPAx6Q4GZ0DfY8RIISbQ7X54V54IgqmLtkPOfRCGAtsyIZc9WAEOeSeNG3ANx83tAvwVV8qfqqGI3C62gMmExweje6cUcaVtq5AVablBNHNqxhTd43mlxsz8JZdiUCuS/TiJg8+CvBL5/cwEdjEUAb6v3IxA374yGccZWvjOm5s4AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UC4ru6M4K9KavDSATdEHcw7K35SUPeHeyT7DBobv4ys=;
 b=lu8NK64YNXo/zJ+mv/fx7baPkeoAHHdnw3JM5yOFNtxx7A2Q6AzZdLAuIngNQZKrnsEWolkrx3vHiInZRu19Pnw1yw67boMywEg0bK6EN+P/Tzn22rCB3uLV2XA3maFJWQLkyFqP25IaSy5PjhEazvTk9w1ds599L3+qRhOirby5xlwLGpD5LtEpnwXGcmE9uy82I6ImjAGBAnlosPiJPAsp2jHi2EKpWmaus2rR+EGfsdPsYAf41MitYl3EcwY6dDGNrEh7fNVlF9qyqRjH/tvYGB+ZL4nACLPfuQE641Sh51bowmfs9vumsUAa71ADGfDTzaL10LLoWDWFNMXXIQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB6568.namprd12.prod.outlook.com (2603:10b6:8:8f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.16; Mon, 20 Oct 2025 23:02:16 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 23:02:16 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 David Hildenbrand <david@redhat.com>
Subject: Re: [RFC PATCH v2] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
Date: Mon, 20 Oct 2025 19:02:14 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <8A6112F2-794C-4076-A6DB-F68FACCAAE93@nvidia.com>
In-Reply-To: <20251020210816.1089910-1-gourry@gourry.net>
References: <20251020210816.1089910-1-gourry@gourry.net>
Content-Type: text/plain
X-ClientProxiedBy: BN1PR12CA0009.namprd12.prod.outlook.com
 (2603:10b6:408:e1::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB6568:EE_
X-MS-Office365-Filtering-Correlation-Id: f366fcda-6558-47a7-204e-08de102cb6a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xh2r/XS4gfgz9q7FxTPFULN8bzjdH6FYI2PtueooyKDrWQqOTxeluJtvaJQW?=
 =?us-ascii?Q?FMvAKXcGt3+/4WdGzPinmV0T/P3hh5p16A816An6x4SQ66mOSM0GlN9u/Cmm?=
 =?us-ascii?Q?i0psnd+Ltxop8EDQLUK6QqKxuy3sbc0roRO2itfWfrl+8H4ltc70YvtSEBtz?=
 =?us-ascii?Q?7sdnwkoR6lyZv4Mj6a0P8eZyC7gSmA8IJJwD85UhDxVc1/Hy3GW1clokeRle?=
 =?us-ascii?Q?GMfScrWjNh324J59KO+cMlqeiB7LIFI6mqfSV8+EJjy233Xx4VJeTvUKdGle?=
 =?us-ascii?Q?5jIIGR+w7qFQbOZScjbnefujUcAvLtOufS32n4W4sfwb0/NRhiAfl3UTC2qs?=
 =?us-ascii?Q?2eDpobhz8ZYktGc/ge6LTDWSK+ARA6Q14exLfJ8Qn6BceraMd/7VbtPR6Fb0?=
 =?us-ascii?Q?myHkZPgptVZVkQe1Gzwom73WTEKj5mw078gQjtToXP06nIJdg4XLCXzWrRNi?=
 =?us-ascii?Q?zJSNNcMxBZDoTOesu1P8y13pN6gZBekA7Z21DIVtltrRgf6zy844VMr5EZAV?=
 =?us-ascii?Q?EuuOQEKzJPq/cUhBFKCJAU12KqjpZ7dMVU/2bbr3/Hhmbu43U0ccS2rITNwq?=
 =?us-ascii?Q?CyDqDvkIfewqSiITH8i8SkxOAzEKgqPwnrtdOmxqXQl9trH7byQYZat7lCEN?=
 =?us-ascii?Q?EAvgCTUdB2jxEy41gvq0eNvgfCvs6VqU07JOUOMDfwSpTKR5RKUVHVdB6bxk?=
 =?us-ascii?Q?N4sEYIggS5nWINxDal3DUY82+x4vqqPExBtCHSmflSPTF8dUZztLVOe8vMxN?=
 =?us-ascii?Q?lrxav1e8fUUOtvglN4SEE2J5WgXE9LYMf12f8zoQfe0muzOxyBszir2S+saP?=
 =?us-ascii?Q?ht7v+h5HjrmwPsFcaWyfwkNxUngNh11Oryyp93Sy7Oet3igeHeHKoRgbFqNE?=
 =?us-ascii?Q?osXTBgoSnLFvSFB+GYbfbXjReBwvWvWo2LFNa6Wa3VYpsxBT3uJqc4aTu6lV?=
 =?us-ascii?Q?539o/JY0nxSnn8BGTIsXfFSHpDjX/xLJWA9jUgxV2E8kTuUvPx9+n+DUmO0B?=
 =?us-ascii?Q?eXt4i+FBiLIaX+rYvylfnmfMjqpruHku8cDkmzT0GdMj+SbEWglG0g1WMSls?=
 =?us-ascii?Q?3ClSNfnt2Px01deUij30IaWcKSQyVgoorBD26Guew/SzKou6TjKQteAskXMU?=
 =?us-ascii?Q?uehF/dHSrmM4CbuSs1A02NRUU+JnswN3BFwNlN1DNLZXp2SZyD6fuPPaVuQC?=
 =?us-ascii?Q?c2qMRDmNsbpRKf8G24qN4PDx4kR/dFJ4cyS4NmZbZN7nymnoKbZqHMZwVGZK?=
 =?us-ascii?Q?DBnNM8G5sN23c+JaeKWSZiJ37FrZfbJMvuqgjdgBpCHWlzMTXflSCISQT/iT?=
 =?us-ascii?Q?kQNLRBwSoW7NrHAicmFcie6mKpGhRP+/ytQto+RBe/fRYi8y5ehUrBUmLqO1?=
 =?us-ascii?Q?pXithx961DdrrrzGXzusgUJtafm80FkFolfgvQaGrRWbW7/gZsIW8EwsD65X?=
 =?us-ascii?Q?3de6HPdchQJ9XVeDIXkvry8hDSga1u8G?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gPg9nCCuzZtmD6SSE3v2hxwv20V3Q2jSX4kYDE91GgWyK7X3JQ6cZj0LNnku?=
 =?us-ascii?Q?Ph0NLwb9DdOYbEfJkaXb4QT6KRBojJMRGNVpzjiF3ceZAxl/G/4rP0Zo9Uop?=
 =?us-ascii?Q?1LelX8uGvcEYGrtPZo71ELT5K1fMq2DVwus843kfo9P/10FtUgMESMq2iZ1l?=
 =?us-ascii?Q?9w047sltcd4MklZsLCup+eJqLTxVMb6iMySoOLu09to+PfKFNeVT/BjpxSgT?=
 =?us-ascii?Q?KUPr2UFqit2V7s16lv3rQ/LHi19I4GV4xgemV4gdQjLRc+7dp8O8reBubdkZ?=
 =?us-ascii?Q?uDc9XdR7R5UPK8uhCS90mOlBNwoVX3ud8QLDRfrOsbPZoWE6gBReT4bTi83J?=
 =?us-ascii?Q?e7LEJNZ643YE8HD+SwvtWFBPPX3XWiT+TK/Wd/ftSLUUSg24cG8fyPfRS3KD?=
 =?us-ascii?Q?XujOSRTeKLmFNSa55QtjOcgH1B8XFkmNFBIQ6HQn+NkDmcbZS1fMfXKQBtg4?=
 =?us-ascii?Q?NtJ+OfN4JOdw6E2w/qsIRN+eU454GhoeD5xR8zyWkUoT/na+LljJN2UVBv7h?=
 =?us-ascii?Q?kklcRv8Ytr1yv8jJ8r0gBa7Mg9qpOfizGpc2UbTWxEdc36KFiDbhVhOzXG3f?=
 =?us-ascii?Q?bLM4tCP3P7x/DegkqaOXCtOCtnrkcB/EkNK4Av74NB5oH+/BwbL3ZtBVqL8l?=
 =?us-ascii?Q?GVA1zFFFTkuneK56MLlQB/VJLb57a0JgYCIlLFiO/ZCIfwmTQ2blfelLBhBH?=
 =?us-ascii?Q?1X/XT5AV3G7QBdEmGc4mF+BviIfzSPhsVFakxbejK46Eqw9lVVbiqe6LOm7L?=
 =?us-ascii?Q?VcGQTdDZ3GwjPsYtCRL5NJR2IrJMml0qwwPuf40sVbpT2EhHu/GNrJtQ+A5g?=
 =?us-ascii?Q?ZSDh3IdO7439XviiBUm5uFdc9Kp8wKREJo7088hWqtXOjH2Cg2X3BGrRP3RH?=
 =?us-ascii?Q?G2zybU9+yA1vlBXvZaEBiNjnj8w8LSAaizrCC8fzu6N6xeoj2/TCzRzDAIFU?=
 =?us-ascii?Q?e5oGta51oyhruN3GeSplYZ2/4zACkBu9+QVYS6gBwO2vYBfBs7CKPbBO8Bqo?=
 =?us-ascii?Q?esRJceMTpOfylHE7hRZtWxlWBtMvWfzlwJAT26Yp6+EXqRPaanjgykQpnYUw?=
 =?us-ascii?Q?h9yN+NbWJigiKmO92WqQZjJGPHb4KQjlf8j1P8+h3UkvD1TZE9IK8PrrCSp0?=
 =?us-ascii?Q?TfaQN6wBkjmAaGXUjurM9i4r8zQf5FnvgaymrB6WCCAWJsbO1F5DBTJkncXq?=
 =?us-ascii?Q?AWcjIh32bCUrTYNuAAAuQVFp2lsopZNrpNrb/GQxkm/lxkjvk1Yk6rG6PZvb?=
 =?us-ascii?Q?oRlu5/7jy9bcgZwP6G7ajxuXS0YCcrC8TzM1netjOWzFJCvzuPmkSTnlh6oV?=
 =?us-ascii?Q?OTXj9xqwmYzyw4O7AoW7dMVxnSgmQMJZN5S/lSzVBZ1RxR2bagdSkd3/6OfK?=
 =?us-ascii?Q?nnzU2qVrG6lW0jMTd7h5k0/t5ZczNlUVfovOGMFSTw6qCa2/VcAsH+sdnASp?=
 =?us-ascii?Q?yi6Wgh8vx9MVXr8wRwpFCAHYV0YZcUP2NB10Dn/TDeRDLYxKzlKfsWCyp1hG?=
 =?us-ascii?Q?JXqAt3D35LDSR4F5PV7GLG44Yo12E624PpKzMWLasoLKSmOKSr6/IOpxhqZ+?=
 =?us-ascii?Q?2s7CJM4Kn/63Q7pwgqC35Tu6eS5snh/o3+/Ds9XI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f366fcda-6558-47a7-204e-08de102cb6a4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 23:02:16.3639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: udkOciQN8rX30WzBQwRoqpNQlj50/FbzYiggZH4Y61Qwe5JIxtfGlzA3wD9vlzV5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6568
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 600D74000E
X-Stat-Signature: uuqokx58t7dgjr4g1x9b34dtb6zzenoq
X-Rspam-User: 
X-HE-Tag: 1761001339-23216
X-HE-Meta: U2FsdGVkX1/7WUZOclb7Gx5H/TvwXrhzQTGhtLr/t8H3p4RNOJj7oQWhYxN5cHLgXe67QLH51sOeLeg2s65Vc6lxVf/vEPPCeHgCGLzqkCnkEK+q3EpiB65XaQDLeRCSH3KuGif4VidNe+F5lxj2rnHogKBZobTl2ee6Ju+1JK3KP4IVMrhUEaNjSj1HOSXPY4oqFSiXjn19KFde/mJ7D0AnRuPRkxskHc22Sx8mYPyIrzvCQJu/JtO0S8YuzLAjSo5xiXrENA7mGq4cFpoDNN/RcTPRyl3dYQhjBF/ZuFSkjxPsh0T9CPHzXQDOyojt5le3Jl09wefjsiJcXYQu8HzOelgFbtSlWayUxvtPhqSvzqWnvArNTPuYGQT7G8RO+Uo+j3MtmScdsrSyOb5AXwawyxI5AiBMvLUTXAjm24uN94hsUQRb6YLb/UnsnFbdvShkskDU32MdJoBWxATkITp3mJ509DYhxCAKmnJj4OA1MmgiKcfqNm0+KyRTfHzmEUeZx2yCaMbWvJQyMT5EWFX1mmNz+BzHXdEUQJgr5zWMQUHG3fPE7IhkF1Q/uScRFSDDkgW00D2HMSW5Pi4+YSLdfgJqEKgi8cD/UvJ6Ze6LdEyRbtt17KhRgEKS9eADzhoaAHNzKnFwwDTbItnCqRbVGfTQHBEqKHXIbMCzq568MAYm1zFALfGd34cJk1JgEhILhbtB37hTVxal46Pf1RtUPl1+7IUf0fYGCrhPuLVk+iBqI6/zNOva+QGPq0ZGCc/2rZCLjqi2ewUqTol6jXy3xMT9xl0wG9SLHcSsiBGpd4+UXfoOpygj3wRRuF7LjgNZ1Q9Qd7/FzU8dvSoUVl+rcKmuO1UC/Xdq4gfs0XD2euJmOiatok7CeGZ4LttWK+4HjDhwSBhtWCMT2aCKrn/y5xWEZC218wgrQ2DhZZbi0Kn2NgbTqd7KaFrQCVMeUS1s4iTxGKUj+Rf+dvu
 2Oe7MWzE
 qAVTTa0kc1XdAoYL1DnQV2TUWMp4iiB0f3IDPfT4y0YP+wsRR8yTxmdMFqsrtxWDYRf2YZFjDwLSgNgF9tGEcF2BArr08k0x+NfTBoSDg5LKLDbusSCYohxZplBnHBm04lw6LOfV42T6Tyb2xfhJPs4id75f/PbJo3A7an2DqqkmcJMUWartbH1TOTMeH79hpPsTX7ZJ8grXiGWytaGrthajYUu/Kw/jZA9L6aeJxJrDZ3MEyOyMZ8lwZSvDG3ePK7jmsUvhJipkeUlIVYoVF45TZEiJ+W3xYbRh3weSOEOp0g5rNWwkqZhXCFmZNxEgybSefKyMHsvcSpLlLo/FgDWHgDjEw/N32NppMlZK7iK3YKmM5HYziMdn5yyX6n4Y8RuoyEudn99dGw6C01lDCIpzRUp02AIn2CJX1vTGg0s7NwNWz0OfbGoj4dOJNCSRkmMBWt54l1FbpbjQ62hqQ3KbeGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Oct 2025, at 17:08, Gregory Price wrote:

> We presently skip regions with hugepages entirely when trying to do
> contiguous page allocation.  Instead, if hugepage migration is enabled,
> consider regions with hugepages smaller than the requested allocation.
>
> Compaction `isolate_migrate_pages_block()` already expects requests
> with hugepages to originate from alloc_contig, and hugetlb code also
> does a migratable check when isolating in `folio_isolate_hugetlb()`.
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  mm/page_alloc.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

