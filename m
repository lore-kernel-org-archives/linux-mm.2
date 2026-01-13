Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B03FD30CDB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 22:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9C06B008A; Tue, 13 Jan 2026 17:02:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC49B6B008C; Tue, 13 Jan 2026 17:02:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB976B0092; Tue, 13 Jan 2026 17:02:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B58056B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:02:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8985F1402AF
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:02:58 +0000 (UTC)
X-FDA: 84328316436.28.3A455DC
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010020.outbound.protection.outlook.com [52.101.193.20])
	by imf15.hostedemail.com (Postfix) with ESMTP id B2D0DA0003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:02:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mOy2QDQ1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768341775; a=rsa-sha256;
	cv=pass;
	b=wmYayVaja1tVkWTjxQG+zpOcstEK4hIFMAXg+cAlTKlcyPyXwkPDq2AW4vzctfo43vz8cP
	072/lnvNhhdNvDQbR6KqJ3mYRWI0ZCbEaYHveUzqdI73EA09GXYFppTY7vWEAyzhWYgS9O
	Qtg1C7uScVWrVq+XSCuTPrtWFyupAiM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mOy2QDQ1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768341775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhG+TBeSIL2ppe5jlkwMqZKUm3Grz0rUFj4e/j3h+7M=;
	b=7JPXIriiPmCuyoOep52+2yY9k+Kp7tI3/ZKLVEMzHF/Wg4JaApW0CJPsy+JmUcgmgj/zNR
	MT3wzxlWgPPPlWDLEdCKhwaUItCSRVF4UrL9A38arEFa3G1MLegXyR8UCb2xB5VzZvzEZm
	yaio1N4ViU+d+32gofpoFs1ErxMpEdo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZXEy85L9hAn4KfXRbnnYHXRDDEgHFfrW/ng3iKjLm8H5ifMNJ50Z3eBg/JmyLJsDOzcaMOZhu4tokbx4UXwjU4jCHsix1r/vwmErFU/hrgR9+nTNjZbjArk9lyerbuAoBEpSHzefOXniMlypZO6QpdCJfkqTSo9x4S/MOYzAy3eYLuJdjWBVAG4DmyMzXHMtyZ6ppCvxjBBex4gO53MXcIy1nFagCIoWlaan4TVMcdiqUPNim1SPTab4AKWpNsvKT5sHA+o/l6eG+YVOOSNuW4oowmTshZexV5ci5X9J4gaGRJFCw/EwaAYA+dDsvUkjfteILKL4CRTWzRyhqluF0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhG+TBeSIL2ppe5jlkwMqZKUm3Grz0rUFj4e/j3h+7M=;
 b=XbpSh9SmVEd4wrRBAmMgNAETbjB5oZ/H+Dek22aZ2wMMPN3ZTacrZOY+fbu6d77LlgI8PoXWBcvuccQLdKBc56Uo8incotiwazvR0J4ubC03pTCUaExZ/GlwR50x7zw6nm6hzBG34SHvb3OTNHqOYkvTG5NKLncjHIodu49dNuwYgIcb+ztnYjXOjUHH8pFmjz/v3YGiOo1/O8k9L2CJeVXLGFTLR7vO04cBJhI5Jm1p/puJ9VlgsXsZpprPJo6tDcRy5Ka/T5KUlS89ognKrvX656mUzEcnAwpuphHi9qyCNHo7tqYGFaRXBM87a+jWBvtn+TMWBJJRTpXJKmplYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhG+TBeSIL2ppe5jlkwMqZKUm3Grz0rUFj4e/j3h+7M=;
 b=mOy2QDQ11UynzHfznMBKnf+GlmHfE9hCB8d1+5uldYmJGv/RxorzyZPKs06wRReSfOmIJD5vq/heCdeVKImwE0n0+A+03F5b6x3UBukZMb19RE9HzAUkLs6IAcelrpAI+3yWNOBOI+7E1rL8tx3JJ2BWiGdY2aUCYZdTZMXiPE1BTF/nElWnw6xb7jbAraTyaPcllwHNHK4Bk3u4CdQTsBLs6HOflq2VplTEtyd3McxQbVSBS1C6rIbBKCp8azVEsKLvWGIR0WR6GsH+AFBd8C2rESdT0sZ+C3iYTx0DzxTq4uAGaxNiNdLPiK9etqG86eF1Ehx19T1Nqy0o8vh0Fw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB5865.namprd12.prod.outlook.com (2603:10b6:8:64::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.5; Tue, 13 Jan 2026 22:02:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 22:02:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>, jackmanb@google.com, hannes@cmpxchg.org,
 linmiaohe@huawei.com, willy@infradead.org, nao.horiguchi@gmail.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com,
 tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com,
 akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev,
 rientjes@google.com, duenwen@google.com, jthoughton@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v3 2/3] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
Date: Tue, 13 Jan 2026 17:02:44 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <13276FAF-85A1-41DB-8C30-CDA856FA6BF7@nvidia.com>
In-Reply-To: <aWXaiWI3v_PJOKDL@hyeyoo>
References: <20260112004923.888429-1-jiaqiyan@google.com>
 <20260112004923.888429-3-jiaqiyan@google.com> <aWXaiWI3v_PJOKDL@hyeyoo>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR17CA0061.namprd17.prod.outlook.com
 (2603:10b6:a03:167::38) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB5865:EE_
X-MS-Office365-Filtering-Correlation-Id: b52b64ab-d6bb-4555-e736-08de52ef7f54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ofco4x7/Xif1atFOJFgwAKTCQ29py4XG799Z3MLn51qm1dOKaUQZLaxXQW8b?=
 =?us-ascii?Q?5fsefli3NOaz6tRnmERv1fxbNIQOje6AzIAgf+RiipEgdbflopwRCBaKkviH?=
 =?us-ascii?Q?fwL44cLR3o4pBMdA3CxDnrPa69oUUeV2HlQRHCzjki8rmL1hGBPsA/4j4Sb9?=
 =?us-ascii?Q?4018C+u0aYLstVQvw3mNDHNOA1Hz40em8sCo4NbV8Hv2FgP7lBIldGBUs16l?=
 =?us-ascii?Q?xX8M3bcDCq7z03afhrZdyYUvmU5x3ciGnYZZeWgCqYGnzF66+jsXIH45FmdL?=
 =?us-ascii?Q?NEawSpse/jfxotpVxuxCHi/BsyfBpvEUxH03wKJkoav8cbJ9xTwzUJA/d457?=
 =?us-ascii?Q?1p4ZDmMT3n+bY8LzsugVGMgUSOfre9XkSr5wacq+SwiXj0e9vw06Q2C+fTqM?=
 =?us-ascii?Q?m5XzF/ZuZlBNAkONGJ4xTS0ea7vEzuo5QstKMMub8kWWGczyI9LWosGjGwAX?=
 =?us-ascii?Q?YtPXMeVrR2FVzaIskBqNBV42J8z8Lwq/JMQBPqSxTcWj3IOx7Ac8nz3y5dcc?=
 =?us-ascii?Q?xTweJcYCwW/BTCy92vFi4s2ADHe/QMqgl4hYfTH7Cgw8rGk9EmNBjrY51PoH?=
 =?us-ascii?Q?WRPGh/l6wOhGSOAB3W8MJMTRaqwN+NWLGKAK2k/c1L9IHPouEjZj6laB76AT?=
 =?us-ascii?Q?KfkyWuniow7VNtFT4zMNZ4pP9ncurjqdeZraT4DhuPCQIFxBL5g6zxndLAqG?=
 =?us-ascii?Q?4G7lZ5hXIpXculmaJLWttqcFWC/R+zADrdzSM8QmYqhcdpVLfDxY+N3V5uzy?=
 =?us-ascii?Q?rOgrmhuO0KFh8DTzAtlRq/Dd803nvIzeAdTMnof5j6xc1bdi5KryHZrn4TKZ?=
 =?us-ascii?Q?jwvhsVOUl5BfuXKX7KGGTK/YXq+yo2tuuD9/BXw4C61HLXv+VMWBCTqhIlFW?=
 =?us-ascii?Q?hGPCPzbNF7m+fRx5vBtoLoQb89t0pMkrLFUJr6NIJ7a6J/FnE9g58kCKNc2F?=
 =?us-ascii?Q?3Fsw9ODnlhyiaHUzS/265Ef8h2dKvk3KDpYgyHLtAf1K2hVLypqooZI6VJ1a?=
 =?us-ascii?Q?8ZT6YG/Kl8qqgd9QQvDg8eVarg7upJ/Rx2VXgBJHOPl1h8A+0PuQ7gQDyzLr?=
 =?us-ascii?Q?3tAz+uK0SIYWzwe3szAEqjht9XYQqk/8njCMOJkxyPT2cWuxVlSdD1juv+e/?=
 =?us-ascii?Q?UURWuKIum0Ua8TMVFYXpQXsPDZ57kNCVFEbc93IOtZ7+JD+YkwOn2qnC3sIp?=
 =?us-ascii?Q?AyQzEQkapfubBsqGA17sRBTEjfH4gHG87cTaov6kSV+baGNaeJD/RP/rsRUM?=
 =?us-ascii?Q?nv1VPOrGOXUl57rsgQnDiIDSNMjz13sQsqUSsWE/qIsWPQmz5fOq2fWoWW+L?=
 =?us-ascii?Q?YmGgsIZhCdYJfg9IrW5SubnxdIEoy77XKmNZG40svkDopS6eDYLLr4FrtJEK?=
 =?us-ascii?Q?51yBHn+xjQkcRFKrf37VRroOx44u6kf/PUsFDTXMYR78su5P5TqhZpsWdqKi?=
 =?us-ascii?Q?/dWvadMRO3IE0JwHCLNcl5egLbuwm+V4GSuvu5omVA84TBWBjJLjhQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bQlHbFPnuFNEWX6ROXAs6SMku6NfFQIcLzUtT0RNvtoW69MtdwpNn378d0Qk?=
 =?us-ascii?Q?/fyZNHpGyJITseDZGg/3xh6uSIdxEAU0Xu30TK8aUeUxbd1DJp1Eiv7lk76o?=
 =?us-ascii?Q?DAasEMMimHIx1vsr+XI7Ev/EgxIHYv3FrXE7qT7Z3Q5+kusBF8vgyNnzrQAc?=
 =?us-ascii?Q?5ydCcpMrNdG/W97hsXfVqjU9fxtdLsFcZG6Z7gdMwJC21/rbzcpOmRpOKcpq?=
 =?us-ascii?Q?pjrGWPWlt+Z2jep2nRBnw5kPlEh8X0LapHiLhq9VqjRWvviGWZYAgZoudsJ3?=
 =?us-ascii?Q?DwusjTk0DUUhazEl9Kcqgxm4Wa0OZcpe+fsJ8oL6rcD87uFeu/0FQegq0HAs?=
 =?us-ascii?Q?JBrV6KHVUUQm+X7+6NX0BSCXPlQOKDKWCE7pk9djWt9ptYSYSKITzqn6FQy4?=
 =?us-ascii?Q?UBJSIil4aSGsZeO1qdKcobXKuNKDKcAgOSWecmvIWUmSpAD7OTJp3i/bNPST?=
 =?us-ascii?Q?XE/trqq76hu+KABekzzUVwblmW1JpB6ArSVqxAt9EM+xh/RKbxniX6r4u7eo?=
 =?us-ascii?Q?AWYtRUynZKAqJ6888RLL3Ep/g9uDny+OdTz8gO0RuQvaU9eaDFdZSXZRaITE?=
 =?us-ascii?Q?LTlUb8kqlwKOuUpyItXN5MpPARO2QfVt/Zyj8ocpU32V/AaC6Sr6WfMC4ume?=
 =?us-ascii?Q?5v+J2HmHOSHftiXm5gPzAFSXaZxf/E4mzpc3K6opD/5XWeBVJM/xEU9d6i7q?=
 =?us-ascii?Q?oMGrUkLr6JfBQIGRgt96QHidrr17criQbEKuBI/BiHi548cc6rbpqEdrOamw?=
 =?us-ascii?Q?lWVM6jHbEj0A2z6ls+GMOHgr+nbksI4LUR/hE0dt9bIEYTSbsic4F89Gsr1v?=
 =?us-ascii?Q?OUvRQqhcuSj+zqWtG56GQoqeMZJhsdrPzWn1rJfKngofRVI6AR6dQvKNeHIj?=
 =?us-ascii?Q?AD7JLW2H007ViVgEIRCCrPU3K9SarxI++sc0l+VH9olmVAvNl/U24xGpseXu?=
 =?us-ascii?Q?KI0TIaSqI1EeDIQB8xjtsp+ZjLQeMyKvRYl/FBqTfQ47lxQgfJHH5OF6CiTV?=
 =?us-ascii?Q?7aPla6XOhbBN3ZbYwNIf2XAAxot51AYWbGZ3Hi2hYWn0w+dB6el5MIoSDka0?=
 =?us-ascii?Q?UgGI9wbbtqiTpKXKA7TrEGUD95mtl3JXOdmTSHWsjqnxQYpD+OhM4sQmaUEG?=
 =?us-ascii?Q?zdNsS2YB2mdjkFFhhZA6j/vI3GnYAr6chKV/XbFQYiLMJPPBoxmZxWUszfRo?=
 =?us-ascii?Q?vD6qN55xwxeHp/WIW2+Q57zrJ020e1Tndk4GIOiBpYUOijMAwxkeHjQ9tina?=
 =?us-ascii?Q?r6Y3ftYSd+ooWATZxJA3isrPBUcaWZBXAwdtyjbrLMb8YiHwt+z7fxw1kcx8?=
 =?us-ascii?Q?Qg4KFM4LcodNH0qySVh3VxmHBYdhcxK9uS7MjZdWqCvtxLJmzRLh+h56bGbi?=
 =?us-ascii?Q?4NRvLcqClfWVd8wewYc4Lo3hv/g7DHL9HOl94wjSG0etQGL9BpfEZDlODs5Y?=
 =?us-ascii?Q?bQ0eroqDPFWVVq58ondTtCYXAtPYH6e+EXf/DkmcTLxLDi0iH4BHZb0xd9/p?=
 =?us-ascii?Q?O/qjyaxQ1XlmDpxUJ2fknnZIenntutMc/JBif9HDu44KXqAF4ue+5XZrLsq5?=
 =?us-ascii?Q?wvMSNvb3zATLRbgCVtGvDltQ4jaRqjZRWiVGIqvEmb8s+3OwYCiwo72qRxCr?=
 =?us-ascii?Q?sNGhDgEX+/2niluPAhX4YP0RO/xL59k1jGNoRkHY2D9KhGBfRF+sujep57q3?=
 =?us-ascii?Q?RdpSCNTPhm5QwCPPrVlPn4ZufLlgPMxG+1pTG2TRzRcs4XppYxK7pYyPx3qa?=
 =?us-ascii?Q?PKWZ8jZKOw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b52b64ab-d6bb-4555-e736-08de52ef7f54
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 22:02:52.1313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VG1m2Yf/Iomy83qXWa0BaCpZstdmIcPFEymBZHxqrc1fiIFmpoqUwBDMm4winMOz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5865
X-Stat-Signature: gj7htkh11og3b8m8rgbseyn95c636fsp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B2D0DA0003
X-Rspam-User: 
X-HE-Tag: 1768341775-250044
X-HE-Meta: U2FsdGVkX18216QtokGpj/bjP9YJOHIocsRQDb45260mTMHBd87CWwTB7HaAVHBYinAKulw7eNx8XmetfFdC2y5qmBDEvgoWHJ+O1U3SsXWIDcNglQGfMbafVWa9CBZrhi6SqecmgioKXAAY+N1Q0lYxdNUdr7JUcUPJsMBRZ0kA0BNj29Hm7dMz8aZ+RSGwLeiaOk/BZr7C0NnGAE4oV9ObmojZIFcLg5hLOeLsl3nfat9a7mSnvHbsp48pfoiaFwSR0FgIzp57R9LwjkZIHPPsmL3+ywWtZTIgyp9XY2mjuYOcaIHvTjHT42oRdD3bKOPLMVGBXuIYaxvwYeLFRoiOaExZSzSyRgkUt5jz6H/7vALGboIkYyAgKviln5CnDVrSa4pDwIlTSRtfB9HOvpfU0A7pWtBvNk1dfPNgQF0dEp5MZu7P3djXxt1+aBaARHRyWCIqqWu/d0gvVno3D3jnmFA7o076dWAexJG8TWfMEBBEZEAso1ckAdmHcuczIetpjTLcG0EgP2Lm50xmrrL57+ZvW4gYMFIapyiP2UD7bJ91DuY6qfRTY3l/z1NKSpS6wxAP7H8VUbbYK7BH1Uo1C0ba8X6SY5xjq+L5xoEHRXwvnkhxHMkyoILOfLLclAa8V9GqCgyPfwm0xDkHHShvyUZqhVLj3V1H/9plvVqibcR7Je32y7NnySXOEqH3myJTnfCVaaAl9rFcoEQyJiFZ/iyc5J3IibympQXK4hSylnAfs6Z84ZHnGDyVlVT9APl057mnceGDJr1S5rDst5TwPg0GS8iZyXmotfMcJ8WtPgxcnBf3nPGxrqYHnathV8mTIpNRXTmZ3i9AcloRjsOAq/jv2CDzT7sI+Sg6Wd73R6uDC1jIHXFrZqpS0D/K09IogYZ0LR/VMY/zhFoNR556ftYv09um/F2D549eMVkGX4O+b3cgeX8TXSJsxiMky4cEFuC/GwEerMv0k4P
 nVO8KAii
 GEVv4rsm5ZmeVBo9rBw72sSvZ0Tzto1dW+d+C1uBtAsv9glpKM2mwaJh503iYWyjVKF9fkDf7Ab1Ntb9umjlxvV7vauxofLCe0r90n8pP6rY2sLf97ipruMwzs8jUKq8HDci2hFoKCdKQrsqTmtJyAscZvg8WQqheSL3Qn9iBR1GTmlyv7GDRC/brg+BCpmzPP1bRuGgPRn0XOOkJlAAIBbhRg/zQPCDDmj0YdvrJvmwchkXwdYRYTaQ1nQyPh7jFzF5ceLeOCzbcFnIHotyxar0TVFNbs+nHX/2h/c3gx4l0PBfdBpzHx9G8VtPso7hmbr6whUEbB8700R8csT5vam2oxFbvijitJG971yxvWbXfS4PXKs/4/iiAGryiAf42FJd8/ywDkBZwG/satinQtrNEGoNLizknRAuohjIXQBnYalbaTK1Bok0vEwM8JUsBrth+MPmfP1EAyLEB6Pckx+XjgJmffaj3/b/aVedQIe2x3a6NdmnqLrF5R7yKQdikPVDmOAD76BVUAXquJYJm6VvqHWIR4K6EvbP2v4up0PrcCSelLd06AiNJZjfrSqfestdhsLhH8aRSKICmbAqZCh5sCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Jan 2026, at 0:39, Harry Yoo wrote:

> On Mon, Jan 12, 2026 at 12:49:22AM +0000, Jiaqi Yan wrote:
>> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
>> becomes non-HugeTLB, and it is released to buddy allocator
>> as a high-order folio, e.g. a folio that contains 262144 pages
>> if the folio was a 1G HugeTLB hugepage.
>>
>> This is problematic if the HugeTLB hugepage contained HWPoison
>> subpages. In that case, since buddy allocator does not check
>> HWPoison for non-zero-order folio, the raw HWPoison page can
>> be given out with its buddy page and be re-used by either
>> kernel or userspace.
>>
>> Memory failure recovery (MFR) in kernel does attempt to take
>> raw HWPoison page off buddy allocator after
>> dissolve_free_hugetlb_folio(). However, there is always a time
>> window between dissolve_free_hugetlb_folio() frees a HWPoison
>> high-order folio to buddy allocator and MFR takes HWPoison
>> raw page off buddy allocator.
>
> I wonder if this is something we want to backport to -stable.
>
>> One obvious way to avoid this problem is to add page sanity
>> checks in page allocate or free path. However, it is against
>> the past efforts to reduce sanity check overhead [1,2,3].
>>
>> Introduce free_has_hwpoisoned() to only free the healthy pages
>> and to exclude the HWPoison ones in the high-order folio.
>> The idea is to iterate through the sub-pages of the folio to
>> identify contiguous ranges of healthy pages. Instead of freeing
>> pages one by one, decompose healthy ranges into the largest
>> possible blocks having different orders. Every block meets the
>> requirements to be freed via __free_one_page().
>>
>> free_has_hwpoisoned() has linear time complexity wrt the number
>> of pages in the folio. While the power-of-two decomposition
>> ensures that the number of calls to the buddy allocator is
>> logarithmic for each contiguous healthy range, the mandatory
>> linear scan of pages to identify PageHWPoison() defines the
>> overall time complexity. For a 1G hugepage having several
>> HWPoison pages, free_has_hwpoisoned() takes around 2ms on
>> average.
>>
>> Since free_has_hwpoisoned() has nontrivial overhead, it is
>> wrapped inside free_pages_prepare_has_hwpoisoned() and done
>> only PG_has_hwpoisoned indicates HWPoison page exists and
>> after free_pages_prepare() succeeded.
>>
>> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email=
-mgorman@techsingularity.net
>> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email=
-mgorman@techsingularity.net
>> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
>>
>> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>>
>> ---
>>  mm/page_alloc.c | 157 +++++++++++++++++++++++++++++++++++++++++++++++=
-
>>  1 file changed, 154 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 822e05f1a9646..9393589118604 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -2923,6 +2928,152 @@ static bool free_frozen_page_commit(struct zon=
e *zone,
>>  	return ret;
>>  }
>
> From correctness point of view I think it looks good to me.
> Let's see what the page allocator folks say.
>
> A few nits below.
>
>> +static bool compound_has_hwpoisoned(struct page *page, unsigned int o=
rder)
>> +{
>> +	if (order =3D=3D 0 || !PageCompound(page))
>> +		return false;
>
> nit: since order-0 compound page is not a thing,
> !PageCompound(page) check should cover order =3D=3D 0 case.
>
>> +	return folio_test_has_hwpoisoned(page_folio(page));
>> +}
>> +
>> +/*
>> + * Do free_has_hwpoisoned() when needed after free_pages_prepare().
>> + * Returns
>> + * - true: free_pages_prepare() is good and caller can proceed freein=
g.
>> + * - false: caller should not free pages for one of the two reasons:
>> + *   1. free_pages_prepare() failed so it is not safe to proceed free=
ing.
>> + *   2. this is a compound page having some HWPoison pages, and healt=
hy
>> + *      pages are already safely freed.
>> + */
>> +static bool free_pages_prepare_has_hwpoisoned(struct page *page,
>> +					      unsigned int order,
>> +					      fpi_t fpi_flags)
>
> nit: Hope we'll come up with a better name than
> free_pages_prepare_has_poisoned(), but I don't have any better
> suggestion... :)
>
> And I hope somebody familiar with compaction (as compaction_free() call=
s
> free_pages_prepare() and ignores its return value) could confirm that
> it is safe to do a compound_has_hwpoisoned() check and, when it returns=

> true, call free_has_hwpoisoned() in free_pages_prepare(),
> so that we won't need a separate function to do this.

I wrote the function. compact_control->freepages[] is an array of free
pages isolated from buddy allocator as a temporary free page buffer.
I wonder if compaction_free() can get a HWPoisoned folio or not, since
to get to compaction_free(), the folio needs to be copied to a new folio.=

If the memory goes bad, folio_mc_copy() will return -EHWPOISON to abort
the migration, but I do not see any code marking the folio has_hwpoisoned=
=2E
When it reaches to compact_free(), there is no way to detect the error.
I think the corrupted page will be put back to buddy and be marked as
has_hwpoison after it is allocated and accessed by an application.

You might need to add has_hwpoisoned code in migration code path to
catch folio_mc_copy() errors.


Best Regards,
Yan, Zi

