Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71727F99C63
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 02:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61FE6B0178; Fri, 17 Apr 2026 22:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D12C16B017A; Fri, 17 Apr 2026 22:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDA916B017B; Fri, 17 Apr 2026 22:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A8BA16B0178
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 22:45:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60154B91DB
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:45:02 +0000 (UTC)
X-FDA: 84670134444.18.CC404DB
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010019.outbound.protection.outlook.com [52.101.56.19])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9790F40002
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 02:44:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uXB7joPH;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776480299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnlnaP8b4VVDCFdGJn3Fuf32eVk9FmQJ0OYvzW8/xjU=;
	b=nU/xgMZVGEjQSVbLpgyWxCfo1POkEwOCdNr3dz7dGwQvHpq+EFKX+seu6no2nE3zFxUsia
	p3yZkeHk410IJEOnns0PGkO3MfE6rCrQ7Ymzkv1qqBEJcATi1T8mkU2sD7g1BPVXUsim9k
	k6Qmj+0YUiN+dTU8YEcruhZdaEHwjPY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uXB7joPH;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776480299; a=rsa-sha256;
	cv=pass;
	b=KhM0oRlzrLxdMSi7waC0hq89SSyJKqQ90jDh6LBTZuonekwTMAbFsOmJXDXK+rc2YE42vg
	LofPofkuP3I1+wM0aWtTa4MaV3oYPVTyN3jhTWbtq0rDslmE2uvJdSg8wg1/jgQ0tOXzh+
	Dgm2XkhE6YYC0JI8x1ql9MScfUrFQFg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pd6QuTKH8bsSklsex/al9Q4h6ZMDJ/cqarROsCE31bPvopkWxgYaiKrSQ5A60iQvOrZQL1DNSoICZ54nbEcxenFmJrckyGIaoXkr8WDAlUojzdR6cbRQ9NLDyzoTorAGBCZpiXPoBoMJ/Fnp05ypu84B5cJUP384H30tIOetsp0CkWZddznOT+cE7Qb5fhXfxNldMWWdbO74sOo8yMpIUep1pW2yj5SVdOqZvAXZBb/LVBvzJdOhR7q+yNMqK5u4CNFKuUJKocne8oGENIx2EaAINOHxw6W8Nz7raESKHNfE19VSz6T1+WLNU2SVsPy5sDEu9BFbVnj5PGs9Uug9Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnlnaP8b4VVDCFdGJn3Fuf32eVk9FmQJ0OYvzW8/xjU=;
 b=ctHPMMnNdr3d04JGNz9c5V8KtE1TTAWzrRWJX7cfB7lp7PCeRYrI0plbZzD2dfjNX9mrCErny4z3C+sMqdSyfE9PeT7EP+wISA8H4usvy9KxUA8AalHWWy2tgbfCQ+YZvrKzkT1s8vZW8RYZjLI0yDhxm8hQcYvXRLi3Ux6RPeK1P4nmXB2Cgy2+SX0r8W5/uNyndlZ/vzLmdWGj2qltdTiaKy+RFPka89SpH4pjW4/rsiZoLrkS6m/jDALy9pQn2a3AhSH9aPYIxACntbzfDXU1Mg79SEta7oCHZ7OO5ZwuHmwh/JGjas7f6cAoYNgf/xIVCT67oAqlSJD5lH4CGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnlnaP8b4VVDCFdGJn3Fuf32eVk9FmQJ0OYvzW8/xjU=;
 b=uXB7joPHE40VU/m+7xeMbzvqRmlSR9MRAd6fpEyAxrBMBu3PXiJ/vllocClVfHQeYrwU71UE8sQghEUp48b6ARS4rJt0bh+7YLahZHo5mqYRI3ToiopexKMBMOEAGs9PR8Iznbh06EsQXy5FUaFfl8urKpQj+E1BIKWF74iNoJdgMr0mscguTAKPY6OmBCHi7vMHcwDLc1jWSMfoki/U2jbmWQ00VBM/0ajxl68lLeRjp42FIu2d9iRMa/ZSadBo65VDMcFc2Mg6o9yyyQ5YK/CC+TMuiGT6mq4HniLXy8jQzJU6GfmpadtVD2Sw7TMti7hE6F9zK1x+iF5vzbVStA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Sat, 18 Apr
 2026 02:44:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Sat, 18 Apr 2026
 02:44:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v3 04/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_pmd_enabled()
Date: Fri, 17 Apr 2026 22:44:21 -0400
Message-ID: <20260418024429.4055056-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0003.namprd18.prod.outlook.com
 (2603:10b6:208:23c::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a448dd2-9429-4ad5-7001-08de9cf46f27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Pqn+ojz7jEp0L2YNR24ADuXbLgI9/xy/GSOmvPhXzzMEr2GLV1mXK7OsVsmbQBxWkS0WM+foA1aH0KLjRntvPddZIoZeyWsRKfE5cFp6V7DxN9rTs8ZHMQ6ARhNk56Pp7NsNz+13SeLpEbC0Gqpk/T/RvkH5zNhjRho957fBbl3o0lNXMTCeTDFpXtkP2G9TrEBJ9hdea2mNd5JN0UXnFO5juA9RmwtoXxT3nkkR+EMfcVzzXE3opHcpU8U69o1JgKAoP7joK0AzvmPOa7cVX76LEyOcGeuJEqwGrKd+m6S9Mz137TqQjsZnwwIpop3GvNCxkKNMZiFGpswgrsZEXxCEKnYAEDS440f8ONJ+15xKjbCAo6JmBoUq8+9SXseK0CViMhbTLjWwQK5UvWpkd6KwkroZ4SK9xfEgBA+WokvLy95l1DyI9DBxN/lISGKVksemdjpcu0mHphPvnv1BNzrzwRwP0iezXQfOOneLH1SVaR55b7RoIJvE37LbabzFFX+95WwMCFfJTywjH0s/HMVgwQ+X1ScIhQ7uzXAY/Zj4Yky3LVvSXXFKWsV6K1+38SXaR+G5qwMz9Le+tbK44pv1TEkHu4L3OxOIZw43bjZAQ1ZR4p4zJN/LOWxkP8dnwoFB4g3zv4KURm7no3ibRaiwIsqzrzcY8D9PiDc0teri1T6uRLtNgvOYA5WDKwxkEJZm03oO7zO+FWhRZ8OczqrHBjq2jN2ZhiTLxk4drwo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xukUgXGHHZmspi6Rf33izUj6sF5WIZfYCgAvO4M+VvDLMXzTgebSoawwQ77J?=
 =?us-ascii?Q?QqBCK+1rU4S+TpVaqdX/NULoI7yqNU/UCCcb8YEfQhor0tRm0Fxn7fGjp4+j?=
 =?us-ascii?Q?dQVDUl0xx1QDIn4eASlmTo3zhAoC/GSm8Wx7sgsmPDqkzKkyWsjfXrTgpAJ+?=
 =?us-ascii?Q?sDloS2vLm5gsMR5vLzCRfBxsPlGv61YlJMf++OigIbcpNdi7W1a9W+O3b5Qm?=
 =?us-ascii?Q?EhCwG1PZlNZciiy9TMkEw5MXiSO8xafL9BHxn5ZX0KzrP5oDg8OwvjpOKr+N?=
 =?us-ascii?Q?3ZFY2Z57HN23JtobCwjh4o9Fac4za/Xd5Wh41fMZcXVPGilxSBxXQLOMJGXU?=
 =?us-ascii?Q?GtkmfqYFpqTr3hv/qogFY2Cs9DS7zapAe3hPs6zrFLWAFkhutZZlgsNSrQgK?=
 =?us-ascii?Q?lQJKiMJVeVETTiWWqoqK3yB9n+wjHlvXBtLJWL8m5ih3hMbAo/vqtdC/Zmg9?=
 =?us-ascii?Q?jAeMb8xOYQ2vRxzsqgwpBE3IqsK9zQIZoWkGN2PuGFBbWnD9bSx4cfCU29CM?=
 =?us-ascii?Q?uMQmoBuwJz4kcHRALKt+b3SNPlEET9L3YRKE75qwyXnGH2zIIeLPsA1rHUar?=
 =?us-ascii?Q?SbLsPjI5U0NaE5owN3KoSeTscdm5gy1Ze/AjxXOZepAjnUF6aQWX8Z23zCqP?=
 =?us-ascii?Q?rxyHuKo0w7AUY5dK1PuzGj9oGL21sb97P1RUrggnUnLM2+WSdgnDU0oegZcR?=
 =?us-ascii?Q?5UFKstETTl/E3oKAn5383nOmkzZb7CBcw9lw3mJn9mcYKjoJJRQSQuv4WIrc?=
 =?us-ascii?Q?ouqbeqtenPQjgEChy48tDqUHqADhXwhajE4V613PR6HsAbEKnfe0n+/ogjWg?=
 =?us-ascii?Q?bogkcWVDVLmJgFl+ZkBJlMz9NwrBjqL+K/Teq5Yn3hcRCLZDAqeIzJLfazXt?=
 =?us-ascii?Q?ZkwBsDt1dNajUWWf71XLtXcF2tgQPmapeabOUSElDZOsIbkOio6f4yexVK0K?=
 =?us-ascii?Q?+1ONlP4KvikTn71PllLRHFGl/5ke1yxgBIeitbkxPLTRR99sybDkLcPrwmfU?=
 =?us-ascii?Q?jceOl/8Eyf3Na9dMC34V94RgVI0HnEuc61Ij9vW5KP2pEClv9KpDpK5jNUF/?=
 =?us-ascii?Q?ft9tXQYVlVz86O/cIRWH3IptuVue+wMAmU28Hti+yd/r1Szp9QI+w4K8o2DF?=
 =?us-ascii?Q?0541rG3/NSmZFy5jm6nFgky2a64t/5EtZfcAUlCrKULxKaErBzrX02yFncnu?=
 =?us-ascii?Q?LIrhjg7y/mx8PHf70ZH3KzyyG812jDKbVHCtSbPHYg8JDgFEL1sqzuzSqPik?=
 =?us-ascii?Q?m4VhPxNdwa/xfMcA+u/xT4vOvw+/X3nrzYJJ521xHskZn2a6ld5cIe2Vu3Cq?=
 =?us-ascii?Q?mjn/8f5mjoD8mUEtlUJBM9A4J5w5EHpOFu9ubf3H18pMockvp5Oiu9aP78o6?=
 =?us-ascii?Q?kkdF1wk5Kwg3mAy4c6YE/iwUc/KH2C3YHoaN6ug3mqsVrbavmuaQSVX9Zqcr?=
 =?us-ascii?Q?aGB5Z+0w2KFvuDnveAu3Y14OjdEy8KTcREClxZjEmRd8JXXvEbusZbJOiCwf?=
 =?us-ascii?Q?+9sDYHhU3jVRRdsbodox4erP2LfZe3NwTZB5kuFqoD3vKDYr6nXUvbUQgIjU?=
 =?us-ascii?Q?TJOHT6aMlOBX0OCfcjbCNxuMzR052A9l/RMjxb0YMU9gjJ02R4r4/ViReAnr?=
 =?us-ascii?Q?C2y9F7jsV7NlxEylvfWvkAapGhEx+TDcjv76Z0lU9xUp1ZZlga/Kp4cdThUT?=
 =?us-ascii?Q?vWGiXDcMg38TGGkoOU0ZMi/VgfvaixOtRSuyJiv91ONNZ10D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a448dd2-9429-4ad5-7001-08de9cf46f27
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2026 02:44:38.5124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xEfU9Aq3P5bxulXAMUE+LhsF5l8hMbif9AQWl11suIsfGdnsOPg9MAs8EkFX+Pgq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650
X-Stat-Signature: njksqqttba9u35kphyonexdfjcsnprga
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9790F40002
X-HE-Tag: 1776480299-933965
X-HE-Meta: U2FsdGVkX18gOckRhKMMn5kYygWu8Zxy5Awi6rpuUdsqrZPZuAsIHiJuDvxioHov4tOlNSDx/q9yuWK0+V2s7tuF30yivzg2XbPfizepfra1fKcMmIrwpdPPiBiqtici/egTovbeVVc3oukQnwGw+ATZ5exwMwJG7ompB2mWhkKjbUjqRIjDwdb5rCpkBqI+y311w4PQGVavZXm1dpvi+TQrYzYPjlROjz26+uNVvrOSZ7EWfPDnpoDfoLSyWhWBabAyGZd7MEVzLS+zYVeN9DBHOKD8ExcapeZyv44u+3DShU3Bjh542/AefMgzhYYOy7UzOF+nF3IjwkXJ7aFC9yxN58KWLMgyXnOhP+djrGnx0hXat9HOeLnA/c8MwQI8IXUuYoLUbpTKI4kTXuy8bUhML4b5+41TmpUQDh7Abkhe3QY/xeV9/FaGHVRFgI5l0oMk9SEXqND8f5ulexUJT8NIgLuXhcz2kfMvtx72jQsmDUYlONldV6M7ZnvClI+cKQwQxfdLU/UkK15UF/mVYwyPuT+9hNAZTSnn3q5GWq/u2oORsUXb31TP44pcNQv8nbWuoDKkoB74skfOHLhcuZk7+Y0YEj3maSdxxWUy0jXenW8qtBfgf0Au55a/4uYPWBAEw28/z7vThqIsK1XQ9aZQqoBTaPRq7LRo3awDALSx0jiLjs9epZSlLJKqlu8zvhIO9aLuykTq7HEXOQ40OWCkggkdqUjKEnW07o1DK+5ESDmITGEQfMGThRiYvDKNJZKnoo57QCYh3Ok+yXfcvpshaS0A/jdqUfMT9ojAEG+jZysIq4+BD7ocTiRIR/hhCobmXpC+5S1MvnYwXR/z6OnMXukKUyIhZqJK5S7X6OLqzMetVxtghHFA0+1GSnbJrTB7PFcinBVS8ugcowJlPsXTVbG+Ll7G4yVf+eDiS5N9VkM9Wid7UKh3fUhGakaNbstc0KK6lng82xUfyEC
 GgSATAoG
 ldy1m6fPWQ91oz/JP961HHGf19UY+MN6bpL6QnrP+uofhcJfaqqsHReKA0NgQesFh7xNCUfKMp4aods3XLu9Xp968CmFVhNxJkUsYil9GWHA0SFU8C3cP4Md/KrHSIlbCCUR8DEo9oohHmG1cMZUe8rjmqDI9qfIJ0iBW2TbI4Qvf0zqnkK1guRlSr3TjWgrcAWOE4nSIob3rJdlQMuZWCFpVaRXs8ldVXlGarNDUO3WFyn+lfBfAC89Jxs9TSTPcTGwDROOR89l1gqhc0iH34lGpDWIDGWjOV6cM2pGK6EezP6RPQ7/+n6N9HXJ2GBphjEqwlCF3Li13A/x5qO8eRg+ISYuOegQvzrN704ojv2WklEmMRHTgaspMZHMQ5Gkd+s6O3IIbgeqhjqvTuY0FybvIRNs6FXJW5xejITDPV2BRXLI/4QnKDTtDI4gqGKYNiP60LM2ADkSyM/GP3TrThC7Opg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
hugepages are enabled by the global transparent hugepage control.
khugepaged can still be enabled by per-size control for anon and shmem when
the global control is off.

Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
IS_ENABLED(SHMEM) in hugepage_pmd_enabled().

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/shmem_fs.h |  2 +-
 mm/khugepaged.c          | 28 ++++++++++++++++------------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 1a345142af7d..dff8fb6ddac0 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
 int shmem_unuse(unsigned int type);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				loff_t write_end, bool shmem_huge_force);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1c0fdc81d276..718a2d06d1e6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -406,18 +406,8 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
-static bool hugepage_pmd_enabled(void)
+static inline bool anon_hpage_pmd_enabled(void)
 {
-	/*
-	 * We cover the anon, shmem and the file-backed case here; file-backed
-	 * hugepages, when configured in, are determined by the global control.
-	 * Anon pmd-sized hugepages are determined by the pmd-size control.
-	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
-	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
-	 */
-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    hugepage_global_enabled())
-		return true;
 	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
 		return true;
 	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
@@ -425,7 +415,21 @@ static bool hugepage_pmd_enabled(void)
 	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
 	    hugepage_global_enabled())
 		return true;
-	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
+	return false;
+}
+
+static bool hugepage_pmd_enabled(void)
+{
+	/*
+	 * Anon, shmem and file-backed pmd-size hugepages are all determined by
+	 * the global control. If the global control is off, anon and shmem
+	 * pmd-sized hugepages are also determined by its per-size control.
+	 */
+	if (hugepage_global_enabled())
+		return true;
+	if (anon_hpage_pmd_enabled())
+		return true;
+	if (shmem_hpage_pmd_enabled())
 		return true;
 	return false;
 }
-- 
2.43.0


