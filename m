Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 730B01048922
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 01:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C76666B0005; Fri, 27 Feb 2026 20:16:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C361F6B0088; Fri, 27 Feb 2026 20:16:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B22916B0089; Fri, 27 Feb 2026 20:16:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A099C6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:16:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 778B61CE6E
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 01:16:37 +0000 (UTC)
X-FDA: 84492100434.06.4310E2F
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011003.outbound.protection.outlook.com [40.93.194.3])
	by imf30.hostedemail.com (Postfix) with ESMTP id C507280007
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 01:16:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HjBf+T0g;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772241394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B444r8/1VE+2bEDpsn1Rv3q3aOW+LOZUxy2NYEFPh5g=;
	b=qwtk27zYLZXp9Y4WQIVYfv0L1HL3LYBLaV7+Aqdn2Q06vo7+HT7w3MIDqHOi4G3aZt201k
	X1nFAGKNxSRPCkA0OhW1IvPV+5e2c0LSB2dtKWj15wxAWNNPoq/3O1xfU10UfrbtiOw7bC
	FXSN8CowCDKX2HiLmb87DyYPp4aVn34=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772241394; a=rsa-sha256;
	cv=pass;
	b=eo9wDZbSxYCTnQgsPdb5v60FCOHFbuAHzwrxD1flh/o69i1pMDqPLo2hhubczt9M1k9Z7o
	XYNddbBRkmShD112ysI8F2JZIEzYUCBEQlBXaMF+O5/mwRkh66BVRgFmplhdh40ahf5dhg
	m9K2TiriYGKK5Y4IRDRccZbBxXcCOwU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HjBf+T0g;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dfgNqmhSTOHDJ6JfrCXk1BQDLPH6RYXAW7mB2T1XlLRzzRyiHjDdDi4Xez+Smwk1YXJjTxsrDwxoo0giqwGYbOnmk0jujllSCEkJUW9WT12ibp8n5ZtoNhiAUDLnbL/YSP/vv8xOhr3wcEzbiWkGE9UV4zCvjYeP8RQFOr99yI1DiLj9VfvVe0tE6/xDpGBsPCKibrobH1N24kC49LBTG6AIZ/nnTtyhoY8bqF61TjAjKxdCYoqJXuow7Cvff1otq82HFlNa3hPof3xoPVFnID+HEHyqBZsiAFxxKUAi1583uRDdVdtRkld4kZI6Wx/9VYeqpYqiNvwm9aYDEsDsuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B444r8/1VE+2bEDpsn1Rv3q3aOW+LOZUxy2NYEFPh5g=;
 b=Q7oLqNYFMmQnSszylLu4rOech/57nzlVFUgIH/ZYJa5jCjJYdFJJzS3+FDLFQwMHovnpOXbWDPd5brJyp+3TM0mqJeKyKdmnXXZQq9Lspz093bhr/BX5NLr3NI8+Qd1NgddpBMXeXyS9oBY/voIqFrkrVuXG872t3nTUkvnDA7OKvHQhzi2u7KyFiYIZx4M583qR2dh0ZC7Jtlhh6XUjTYqp4U9up/qJz7h946R56hcfFE6+GirHqDAbHaE08ZaVK+bvUZnEkuyYjFW6L4z+gAob+a8nWfqWv3+ccPmkWhg99soKKLp/lxKu35Zo7CsZY2s5z7lQhmlnYyTYsFVOOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B444r8/1VE+2bEDpsn1Rv3q3aOW+LOZUxy2NYEFPh5g=;
 b=HjBf+T0g0gug+YuaQann9yxuUm9ETAMjMdzUN16NjaGHZ1ov018/yYvS7UVNVu53cdOuFgf1OYL7T2DP3k0EooCTy//iMekDoYcqkAfQqMIicwF6wbZ9ndeROLBPNaDoYg79RJcGsVPLRFwfU1Q3ny/XBbP3WXKUKMhbm70mk3Iz5WCaVT/qrZPdk983pflqRjv+2wDMjNWzuPjgocfqomKDjHbvYJ+/C+cMArA6X+axbTb6cp23CQrM/0/k7gNbQisz+/SpbEA5KKt/469nycyL/6+SiDKHjqrXZBIst0FegK8ri7PBBe01h8OGLga0ds67MZMvNfggMzWvo/lXIw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB7326.namprd12.prod.outlook.com (2603:10b6:510:216::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.11; Sat, 28 Feb 2026 01:16:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.014; Sat, 28 Feb 2026
 01:16:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Oscar Salvador <osalvador@suse.de>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 3/5] mm: convert compaction to zone lock wrappers
Date: Fri, 27 Feb 2026 20:16:24 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <D1D52823-2A03-452F-8356-5D64A8B57C02@nvidia.com>
In-Reply-To: <3a09e46f52cf9f709b0725bc2b648cc5212843b2.1772206930.git.d@ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
 <3a09e46f52cf9f709b0725bc2b648cc5212843b2.1772206930.git.d@ilvokhin.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0041.namprd08.prod.outlook.com
 (2603:10b6:a03:117::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB7326:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c16e996-6610-4a4f-5efe-08de766700c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	kNAKVoWjLLyCeWt4kxJweMwiVE7orI42OD3O2f4YOM+JdVYkwAfRWqZ5EzQEfs7IvxJmcX2edQ7Tz0M99BcOs9MfZuNGOAdEUuGIe2CswnLI5UyYWGHDDD4l0hg9OefqoSwnDnZsfvqJKB8RckDbSLxvwZze6xa8/zaGMLadlJugMyazo5gvzc8uCpITwarWxfSdZMVXiKrlffN4EKZAUp3ARg2zo8qzYGKWA9a4Z3nhOuDAQbS0mH0w8l0UwxWJRQ7SMwPZ55ruRheQxwxSJI8iyLReM0smgFFZ/gcS7cwnsQ9bLafFMQVGRU0wCoEHuwrTiB36YYYlNKTSeSsGusBfxZ4TCq4ieGh+rP8wnaP70KrVzr2T12Cz0WojZGi48JE8mZsZO3NQmLP8Iulj2L0ViCuoVu7+pFrKBgeKD8X3h50O4FBTS4+GvwhcSuQ/sjNGcu2mzvLRCC/q6293YMIFaAfqMnA7BMB4MHfVWAwOCj4YhjKjkNIadTiOyJ643MIOADbzOBC7hE3AXBnvP+qlzdvAG/c26IJzqEbDVD0at7GoH/KoP5f86FS0U0Op3NoeGTDlU87ucm9fjconK/1n6ilLCORNfLxi1YPwsdZpBaNSCzKYX7Bggk5ET3DaWyKikEsD3PxhS2Pnd2KNQaulUZ++bMyULzGGETjlWdMCEryZ2QzO6So3/xHb0gTyO53WONE9qKrtJHU+qaHT8Z+kcYRekUCn4fjmZgrGvqA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zjacgqenjw1UAi6OWPulePWjJeub4ZWbCzG/wPDVMrBLbHDcpX9YVXT/7SPy?=
 =?us-ascii?Q?qGZhw4mL0FrjVMXx4NHfwnAivLCO1h3cGjs9xTDvyfCIFTgt7pFt4Yww1NDA?=
 =?us-ascii?Q?H3uXl+K/osd2zSKfM42otUIzuWmtHWvRG+KS5AyeADF0APeroU8HUsJhTmQl?=
 =?us-ascii?Q?P8K/bOgUhfKj/W3hpARkwlcpUwBFrEMxGvC1/3zRm7tve2B6/DxHJmAwuxAX?=
 =?us-ascii?Q?rL6HK/eOg2XA07BLxeu8VXXO0pEQmm9oLkCmTLFg7wPFeSFnItdb73HPpAGl?=
 =?us-ascii?Q?oK23TAKsKeMz6v8ekk1fbpPITbxB9Z1rtmYXGy0S0fvaEDR18Z3cjFpO627Z?=
 =?us-ascii?Q?xBzTQ/gGbD23WbRvftC8bjLwxEkomSUsClcVgM7UaHdw4/MJijr1sPnxmFb4?=
 =?us-ascii?Q?89/MW7WQuDE/CjCViSA87aPKXWXlgcYERv3oOQthw7YA8Cq2Al/yU0XOCgOW?=
 =?us-ascii?Q?7bHCNNIV9PYWsVVHEFVwgNHI8cPiM+vPiOEPscaoyTYKypk2aXgYl/9ClcD5?=
 =?us-ascii?Q?TQ2zVkTTkBJMRTpqwa/Axc2pLRPFWekhFMyq2Jwe4mlDrcnh23LWVattoBMR?=
 =?us-ascii?Q?l9zRyNkARcEUN7PJ7C5XqNzjOYnjftLU8zrttgaH1YhSg2Piol/0LHDejU0Q?=
 =?us-ascii?Q?45nCgbigOeD//5RtXXncyoD8lCKdAlxidrYHmie+BMqczhfLjdJ0geJJ1SSC?=
 =?us-ascii?Q?ET4OLQn2x5KHLjeoQbyxsmCiJNDu8MAko6C/EnqiFhFjtjFzHrvID8jgZIa6?=
 =?us-ascii?Q?vzJN0XU6SQCdef2MmproY2nJMFfpTY1Rd6+RlQ7ttvN06Bebw56amvH7R2Nt?=
 =?us-ascii?Q?yvJUENO59lmJN4Kjy18KcBguOhHZvIcuX11llm2f3FSSyfPhHWbeUPSvzyt6?=
 =?us-ascii?Q?QtRJAL5DarZSyjDgQIba+P2AJI5RTXih1SdDXh2weHiOISeuN4wIV2vWpDmZ?=
 =?us-ascii?Q?KuzHNKx0+5QHlIEUOYok0cDlEBSfq5R4y7hGpPLqoSnVZBLPZ/5serQ+aUoz?=
 =?us-ascii?Q?q+BNyhAzEitS5uInthzMKBMG/3sdw7b1TPvK0mB2DDhFAjkmwZOknGFa+S+b?=
 =?us-ascii?Q?WduR4cVUj/KYsq4aV8B/qq819RwYF/mBRPGM2pp0FxBjvuLXEKpcVSafkK+q?=
 =?us-ascii?Q?nsAehsd/tnyGdX8/5hG8hY+5G8cfPsM//L7hDqFiQouSQgXxoJtb1O7INIzS?=
 =?us-ascii?Q?e5hX0VVCVgHQPVj5Au+GBxVGKjv1XmT1TDMv0tEBO2tGkjA3ZNVCgZdGtTaV?=
 =?us-ascii?Q?6YTbNisKP7lw9VBvO6HgGsUGD3Agqts1ijezm8Pw5GFt/gfQIQvVno9Jonxr?=
 =?us-ascii?Q?cNZmB+pN657kmsa8DZIBOpeS1Vo1Mk4LL0MsB6Z3CLRSopHXv1bjOYaU1koU?=
 =?us-ascii?Q?ZC2W5KptqMxqx998R8to7EEQ6xuYGQMnlZQuE59L9F7Okp/dF38Vc5sxyZDj?=
 =?us-ascii?Q?shqmDrWqGGlnSywcLLU/o3wZAEDZ7lWC/03fKRA59/zW7v0SctEWdNo7GmG9?=
 =?us-ascii?Q?K48zEwfN+FhXpG/GQI+ZgbrBD+J56y8PUpfT6loBSP/kUb4VjreV5nhLkDdz?=
 =?us-ascii?Q?59c/gmuKsLBhnJMcGV53Y4m67y2JKr8OldTvwHDXRE+XOQJvkL9nBsBx8K8Y?=
 =?us-ascii?Q?ZozmahYXDNmiIxuTO3H3y99QQYhqFygh1LlSK/UxmtLO0sQwmQZMB23lGKfo?=
 =?us-ascii?Q?DMibyKqHpRwZ0irYLME+WsEYNCbBpsShmMahttwJW1zA4WJh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c16e996-6610-4a4f-5efe-08de766700c8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2026 01:16:30.2664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOqx+nrhj8iJWHa021mrtJHnbjRwPdCwiM86jsAlUVCnY4mOSwonzbQlFW6t/Zef
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7326
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C507280007
X-Stat-Signature: jydikzz1yqhnw4h753ranpngm6isuotr
X-Rspam-User: 
X-HE-Tag: 1772241394-681995
X-HE-Meta: U2FsdGVkX18fKbUrQUBMJyp511c4+qLLYj70LlPtmdL3Kgj8sTiRodpaL20sMZAOsbkZsiaCGD65BrA1PAG33HmhUNIvAtVzgSCeuwhlw5ht++awkeweSpKfOdogXakNKbALnWjJivu1y+LZVoJtDtYqZiBVm90XdRZL2SNGT65xbMaUY44b5QTH+6u/JtnfwSK25kw8Ywlk/V4EMxo8nF2vEJXr7PpYaIGp4cX3frxCkhuowILOg/c9HfMwV5RnnkpGMW7nZAYqTQhQPkPJsT6lPKgdBleCyk0Zs60i15BZwLnd6D1Dt+vAmDK6PZ550iJkIDItcLBfie32dMNX/7dVLStKZeI97HigOSN6l9AQLIbhMcpFlXZIe35mRrEwe7Iqz3UDCkoKxGarC+qAjaE47pJA6XXRWRRR7OLRQJHnzdBBBiZ7DsRwxNyOMaGq/9RsdHo92YeGLNwhnt2LqyDC6xaNOUn1QLqSZ97jzVqpJiT7BLOqD4Ax53I3U4I5fjz81wVUQ6ebKp724MKusk0IJunbzD+zne7DneOdM0plSBMfnV5D6b/yEYWGkOS/Sewx28i+N+jVUZVyWg9NjcOkPgtTIXjVG+h1ovvo4G3Arwve37R9J0I5vbF99JQ32oI8OFKKfBLfxKRTpUwKToZy1o9PUz3ImSMXZwf3EHhUXUPYmlvagPpkhsptGCv+96HI/T6M3pnIsK2ipatHRolX7Hd9+rcOx+O1kPAEbNX+ha2Fkn/lVOm9bEkRHNNKs6qLCfDd1Er4tiK/J5l8XxoVsCG+rFZpV8nsZOzXiVpWK+jbNyYidr0r6FGm40cv5oxx8zIZfjstBMOd8HnrEX1/OSuZDo1vPnqcE3GZJ3UvqQHpcZpKtxojT9PnHiKsqzO11a2gfGKuaUEeeU7fr3ydIeWxjmFqPdQ8tHPOBw9P41tDzFI2XVBFfqAvkPAgf3yWu6NUadYaivOFs8R
 9cCHnzez
 gxGIGuDcQL+pZ6pbOelT5j/d05t+eADQ/SYRePnn9ktWZEkbh22afeeCvGZi2iGSDpwTyaeH0Hf5mUY9R4ohIKR2xy1gJ90YD5FoZzDetRvR6PgSCYqDWFvQEhqs5zmVbubfxU9dWBnX43xoNtDPBKMtxru+Ie62brRI4xhOp8d2KPNMBG0cihpp+KlbxTbii/0HMBMlgTO/67R7mWHSJSS+0FO4nyQ2iRlVySKV7jDEeumfqLqweIvBO5Ubs5z6rJtQVgyEmObnPqrpE4foq6raHYy1w7KcuqYbD7+sK3qQmWRbE7IIkMJNTNaoe+AI4qhuctsRyGpPA/YwjqgMfpr3FcIDQjZRbP5tMYV9T37H1JSDJgyuDU4iRRWoWDblviNuqbAC+hpSvzA1ckwIp3eM57g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Feb 2026, at 11:00, Dmitry Ilvokhin wrote:

> Compaction uses compact_lock_irqsave(), which currently operates
> on a raw spinlock_t pointer so it can be used for both zone->lock
> and lruvec->lru_lock. Since zone lock operations are now wrapped,
> compact_lock_irqsave() can no longer directly operate on a
> spinlock_t when the lock belongs to a zone.
>
> Split the helper into compact_zone_lock_irqsave() and
> compact_lruvec_lock_irqsave(), duplicating the small amount of
> shared logic. As there are only two call sites and both statically
> know the lock type, this avoids introducing additional abstraction
> or runtime dispatch in the compaction path.
>
> No functional change intended.
>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  mm/compaction.c | 33 ++++++++++++++++++++++++---------
>  1 file changed, 24 insertions(+), 9 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

