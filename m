Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71820606A323
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=vAcYbX1i
Received: by kanga.kvack.org (Postfix)
	id 925406B05B1; Thu, 29 Oct 2026 02:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5C56B05B4; Thu, 29 Oct 2026 02:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4976B05B5; Thu, 29 Oct 2026 02:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55A496B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:21:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2832802DC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:21:52 +0000 (UTC)
X-FDA: 85374668064.16.35FEFF4
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012048.outbound.protection.outlook.com [40.107.209.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9CA23A0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:21:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vAcYbX1i;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf15.hostedemail.com: domain of bharata@amd.com designates 40.107.209.48 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793254909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLfduqBXLNMlCnhaczovDEndt3vcdmfZESMLOzlcWQc=;
	b=C31JePynLoTkUkwzCBpUSTBvV+3RBsDG0easz/FxuDaTPYNbQaDLkNjHPxgLrXFho1W22C
	uNXPGNvTp3FqFaVW7LpLaUiQ8sWiagGqochpUuBX0CJSDpYCaqcyTTqRlRv9h2nRp9RjBH
	WjrJ7Bx8QvgQw+mbjaSgfTzTKvX9UXw=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=vAcYbX1i;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf15.hostedemail.com: domain of bharata@amd.com designates 40.107.209.48 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793254909;
	b=30LiahOEOOUsev3X1hSO3qUDRgY3nNKc2tSxnfDyO5bs6mi2cXSGVbGKP5k83EGCAjpOlF
	RFZaoFlzntW8caaAw18I4QNvQASkwLiFve4BHYEyilpl3Z2K4hravBAXoRnuASOWsTfgi3
	fK0TJRAUN4NtfaOBRUMNsO3IYqPKdZM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aWS+32e0RJtGGFHigk7A6rjoxbAzSYVVmT8yeiXQ36pAcOqxLHVCtatSuIkZF86lILwlBhjnH4oN5nKOGUD5+FIVWRdJ5U8WkWosmhKEwODrTWshtFZ/fYwEtrPXe8XtzcN9kTx6aWJ1bXciULfbrFvFOlgg/G49ZaADdzHQUVC8Cq5P+8MJaf+SAo738xQIOWUzx1odcZz/LOYEXzBUJCFYseTrPSUHK0DAgrKdh0XUoePL4N+wS651N8gzYd95gl0C22KkGyINVQ1lMuVgnMNp7PJtycbpl72ly50oARY6T/UACBfUnjFt636RRZNNNVB5c+40eZ6Hi2WFIYRMGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLfduqBXLNMlCnhaczovDEndt3vcdmfZESMLOzlcWQc=;
 b=f4nvDnW/nkfSFv+5rc/i2wzwhFHjBC1AkU6rhweVjBqTvx5Kfmfw7Hb62eQgtqWEiq7IiqjDzJ9khgG3XU9gcUVixAOvpUGqki4BYWI6lIHkdZSWwXyG46NpUy9+9fesXujgjq/8m4CuDBcqXszNr0KHaIuJcyD8FMalWfmykCGs+bEDSOGhxc9L38eh2EykrfvnsZCjSNjsps5+FGJMQ5NTYCEPh1oM7b5w/kZHrNpVUa3S3HrCXWPUDjaGN+wwNgg/5AnFGwwAbR7OWOitVQ64rtYxaTxIXRXtgSa4nrq9oIZMZzWs1bty2WAmudTM1A1B77yvTiiGSSXNaxUfiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=bytedance.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLfduqBXLNMlCnhaczovDEndt3vcdmfZESMLOzlcWQc=;
 b=vAcYbX1inJznCGvY0z8mYJ4hTRr5qBkfYMzirqOFdqDDDExaDRcAZCtgkNv0Wtqo8marO5MreVIriqii101oxEKgeoh3Zjb7Nc3xiu9eL2yqgjon3gMLvbx0bf13P6EW86xU235vMp379X0/SrpRqrOwrlMiptqKFEWWtEhp+MU=
Received: from CH2PR19CA0015.namprd19.prod.outlook.com (2603:10b6:610:4d::25)
 by SN7PR12MB8132.namprd12.prod.outlook.com (2603:10b6:806:321::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Thu, 29 Oct
 2026 06:21:41 +0000
Received: from MN1PEPF000793FC.namprd05.prod.outlook.com
 (2603:10b6:610:4d:cafe::47) by CH2PR19CA0015.outlook.office365.com
 (2603:10b6:610:4d::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.7 via Frontend Transport; Thu, 29
 Oct 2026 06:21:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MN1PEPF000793FC.mail.protection.outlook.com (10.167.249.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Thu, 29 Oct 2026 06:21:40 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 29 Oct
 2026 01:21:39 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 29 Oct
 2026 01:21:39 -0500
Received: from [192.168.0.152] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Thu, 29 Oct 2026 01:21:33 -0500
Message-ID: <de52b5f1-97eb-4404-b7f1-53f0aab17fae@amd.com>
Date: Thu, 29 Oct 2026 11:51:27 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] sched/numa: fix scan-period adjustment for
 tiering-only mode
To: Li Zhe <lizhe.67@bytedance.com>, <akpm@linux-foundation.org>,
	<bsegall@google.com>, <david@kernel.org>, <dietmar.eggemann@arm.com>,
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>,
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>,
	<mingo@redhat.com>, <peterz@infradead.org>, <riel@redhat.com>,
	<rostedt@goodmis.org>, <vincent.guittot@linaro.org>, <vschneid@redhat.com>,
	<ziy@nvidia.com>, <riel@surriel.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20261028041253.74839-1-lizhe.67@bytedance.com>
 <20261028041253.74839-4-lizhe.67@bytedance.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20261028041253.74839-4-lizhe.67@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF000793FC:EE_|SN7PR12MB8132:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d673e7c-4110-4d81-2785-08df3584e4f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700016|376014|23010399003|82310400026|11063799006|261028144727099003|260925021911599003|261026140227099003|260925021311599003|260925022911599003|921020|56012099006|261022105027099003|261021123027099003|4143699003|261021121427099003|261009223027099003|10067099003|22082099003|261026121527099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	rjsAJcZYN/AUtKB0uQW4bpDpa4XApfBf84sNdV91n+BSTux/WJjVi2Bdru0FVnS+b4DcYfAVwbzGg0yUP5Z4QMIfH6b8jFcg2y/SspISepw0XXXtBvzYV99oCJXIcts5NmN8eiNOnwDhw0e1/tNYv0QVTbnKZIL3Em8ldIOCevESWXsfVH89GE2glaSzv5etL6hDDYOa0KZeYY0RQfnqPziCk55QSKgJlBTMBgZUlKBstpKEidVaedu0fVIpVVLJBCDTJcYnSQzY9JO8O+zWtnyCfOZFK7YOG1AjytyxE2QPqh3EOKBgwil7GhWQSfknIjLGiLxQBdZiRU2VUMEd8dF1Vsfo9YaPRkuKrIMsaK9euaOQELsa/8D+3z6p71GZD8V8pMq2pTcIIGI+2rM9UhluJokoTkILKpRswnsy/L+ALPwb28Me6fR5D12SIQzDEo0qymAxwH0ev7ji6qiLOFOVhgvqaDTlzn4uB/lWOjdBkVvDq3bUfE9LqTw9P1MT/4hdsde7fuzwJqrfyuQyjMaApxp5zoOQg8+2TEd6vs7eIjuV0xptt/CWD4YhiSL4nnJve/vLvt7fNS/ylQ34nrKLzAMtE4k+SIa9Haj3399mDG8lpo+H7QklivkeKRvWT5zjQK9U0ACXeD9fWLvJ3RjJpbEsUrt2Zn0ZmXilbvXsim9zPxiKJ8w/GKQqpxBMLOGzv2Nc7AiDvuh0qODS1j9mAEkSs3QtzgJtlLovGxGQGF/4gzCwGEWASp6uW6hM
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700016)(376014)(23010399003)(82310400026)(11063799006)(261028144727099003)(260925021911599003)(261026140227099003)(260925021311599003)(260925022911599003)(921020)(56012099006)(261022105027099003)(261021123027099003)(4143699003)(261021121427099003)(261009223027099003)(10067099003)(22082099003)(261026121527099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DiaB39WjhR1j69ulx6GX24PHlEtZXqVlJJJ0nouUiOp4PCDdPHfyx7dRn7tC+hW70cqKBQ+iLP1RQmMLwPZlJl3u5R2h6XLZKE8DOZf9HE7rFYEnrWByHkx2LJLehRcK44/7Z2rwJyqxM9oS29Ippd6bDGfusP+KKfuNwVZ7xaf4QbUQBq9bD66KrzJUaygqp6d0lvGUE42kJG6nJGqARz6D61S3h4aR1+undjXo76Ny0m1aCP3eAjUGq4cwmajymRb+Rj/99EbSxTm/0m0tkXIry18DgQUI7H5eDXVpqNrbM0SuzvKUbPlDe7dcN41l7jdZGrImbAQEtepKdmrL3GYuUjbM7INCTpdosIXlmCC4H2TryZoUhtl/rg9j1WpmBB/ag3VVmVVx1BnfRQBpQIH34mrI+e2M8fllgQciyMzYFXsDyh5kAylUtZQ36urQ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 06:21:40.2440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d673e7c-4110-4d81-2785-08df3584e4f1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF000793FC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8132
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9CA23A0002
X-Stat-Signature: apsc97c96jgrxf9e8bae48ybmhw5ezue
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793254909-552767
X-HE-Meta: U2FsdGVkX1/WniFG8z453R4DYtfiSnFsmWw8l46809Dj6qpPlBu8AzL46Kd07qSZzyK3HYJYboZVzmTOF01aNM3JLVRRkjJllWOqiBBcXUX6UCbuk8NR+8ccwbH5lo7PzPmOmUQ2MaYOJGCP8YmcExTPYk8eQtF58Lo9LxU/QVqAY6ArhrSAH97HPgMTBFF0xTEtURuy6lH1WlXzQxICpv81/JGecLzQoc8rpXCmPb8d+z3OO6BdRsyCkcLC/mwL51krGL8CIQQ0HK6MhOgkmTsfPfbULoeASc1xEyJJAq48SS7fV5+jGZ8bKCQyTccnps5j0DaOniifXv8XuEktReam3tGcbz+rdTsajyaX9abMOzP0Zc7aSu1VAHKd5SKcMdWs2D7a9hIUQcQ93ly0/RE1x0+mzOhNar4mGkQunD2uFoPGEMONje7Mo7hkACoDdxrQYzkkXO8dOZ5MBARmpQAxMguDddmg9WGM7Qe+CjwCFAf3xpMzmke3qJ4P9dM/pcWPFuvQSoeHfmiUpDqH3oOOClHgznzKNUDqzhHv3E6SZmjBTF5YrGc/RJR7Yf0DLCSuu3zqvuTzHfr0XBIKv/vPIGW5hnr3uFGs/aSHxsAm1ySxBBc240pn/mK2YTuqIcNgz+oOOtxF2JmnCzzDelBQ1xr/7qe6EMaIIA19qUW95L8J88zHPLBun6gyybNe9B3V5TwVpk/y+GmGHBfgekVpE7SJQoooALhHL2YbBbGShKyMDlGZlouwCTSsydE9KRHs/f0AzrNuaDyC7oQgOL44MGpybfec3MSKty988r1umVEMaz1jg9JdqAMl1357+Y7xuIUYFTeOPBc3Y36rxPWMOTl08g3h5bEhp+zXwDqNTK1e5KEX5qt3EvUqbnr9WKbcNRzE4D+Jnz8/RF2xPqxGcf4ZcGXtog60ZULDvMYmJ+k50f/1c4xh0YGREpBya2KVsUAV0BzPvTqR0Ed
 KXDfmckD
 DIM3ovzQtKS0w1JcLzgLEaTuvb0Z7cmAJtMTxd6wPOKlmDnUU7xwICfp4i8j/L/MBlKTrYUDDJfyGUKo6FcM7hHapeod4DIeqUvrV6jbXHocQkNL3xpnRTjskQaAi7rc+c/UKzUrdTkTLgKIveeLdJFgXsKALXFqvuIRl8LT5TDQK/jqECMGg5mGzF+vA1mpjOBISrfAVPBrhJZf7iw8v5ZKBaoZKhuFv/8s/KO5SqgFvJqD3As305jhj3T90R1sD+Xd5JG+H7ZTRHHAYdES+TmKdIW0hbt+VBcmdvxY1mGZ29xwc6c8+0zgx6PJ/DvLCJb+Qy3HhBvmAXJQJ/5pFl6nECgLCv8m18RhS/ONq+5ZmSZShx/q/4n4aLiRb6v6cEZ08CM5JI1s8J2V5H9ZZHWlVWNZHIS6XCa4+SXqtJqurwjbocti9YjaFwUpKL9GlaLTspy3qjnp7g/VCRLSiWecpc/tr476ZtbEk7a0kwDnypGMwvknE10Y2Bek6Il39TNXiqDUu71iiBwy/lKk2IvAfjNgeJwnQvh5isInrTWaAqTU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 28-Oct-26 9:42 AM, Li Zhe wrote:
> When automatic NUMA balancing runs in memory-tiering-only mode, NUMA hint
> faults identify slow-memory pages that are worth promoting. They are not
> normal task-placement feedback.
> 
> Without separate tiering feedback, successful tiering promotions are fed
> to update_task_scan_period() as private remote faults. That leaves
> local == 0 and shared == 0, so the function hits its early slow-down path
> and doubles p->numa_scan_period. Repeated promotion feedback can therefore
> drive the scan period towards the maximum.
> 
> Track memory-tiering feedback separately from normal task-placement stats.
> Successful free-space bypass promotions are not counted as tiering scan
> feedback because they did not pass the hotness and rate-limit checks. Cold,
> hot, and throttled feedback is generated only by the hotness/rate-limit
> path, while migration failures slow scanning like the normal placement
> heuristic does.
> 
> Use the same 70% threshold style as the normal scan-period heuristic. A
> hot-dominated window speeds scanning up, a cold-dominated window slows it
> down, and a throttled ratio of at least 30% also slows it down. If a
> window has no tiering feedback, for example because promotions used the
> free-space bypass, double the scan period, following the same
> no-useful-signal slow-down direction as normal scan-period adjustment.
> 
> Evaluate the tiering window when a scan sequence completes as well as when
> tiering faults are reported. This lets an empty window back off the scan
> period after qualifying tiering feedback stops.
> 
> On a CXL system with node0 as DRAM and node3 as slow-tier memory, a
> STREAM Triad-derived OpenMP workload was used to model a
> bandwidth-sensitive working-set shift. It first accessed one 100G range,
> then switched to another 100G range. The workload was first-touch placed
> on node3 and then run from node0 with memory-tiering-only mode enabled.
> 
> With the free-space bypass disabled, so that promotions have to pass the
> hotness and rate-limit checks, a kernel with only the bypass control was
> used as the no-feedback baseline. Tiering scan-period feedback improved
> the transition window after the active range switch:
> 
>                               no feedback       tiering feedback
>   first 80s after switch       122.4 GB/s             129.3 GB/s  (+5.7%)
>   200-240s after switch        139.9 GB/s             140.6 GB/s  (+0.5%)
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  include/linux/sched.h                |  17 ++++
>  include/linux/sched/numa_balancing.h |   9 +++
>  kernel/sched/fair.c                  | 113 ++++++++++++++++++++++++++-
>  3 files changed, 137 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 1c93da75226e..c4959747374b 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -833,6 +833,16 @@ struct task_ipi_mask {
>  struct task_ipi_mask { };
>  #endif
>  
> +#ifdef CONFIG_NUMA_BALANCING
> +enum numa_tiering_fault_stats {
> +	NUMA_TIERING_FAULT_COLD,
> +	NUMA_TIERING_FAULT_HOT,
> +	NUMA_TIERING_FAULT_THROTTLED,
> +	NUMA_TIERING_FAULT_MIGRATE_FAIL,
> +	NR_NUMA_TIERING_FAULT_STATS
> +};
> +#endif
> +
>  struct task_struct {
>  #ifdef CONFIG_THREAD_INFO_IN_TASK
>  	/*
> @@ -1433,6 +1443,13 @@ struct task_struct {
>  	 */
>  	unsigned long			numa_faults_locality[3];
>  
> +	/*
> +	 * Memory tiering faults are tracked separately from normal NUMA
> +	 * placement statistics. In tiering-only mode, slow-memory hint faults
> +	 * are used to decide promotion, not task placement.
> +	 */
> +	unsigned long			numa_tiering_faults[NR_NUMA_TIERING_FAULT_STATS];
> +
>  	unsigned long			numa_pages_migrated;
>  #endif /* CONFIG_NUMA_BALANCING */
>  
> diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
> index 200f50075d5c..12f31ed56d66 100644
> --- a/include/linux/sched/numa_balancing.h
> +++ b/include/linux/sched/numa_balancing.h
> @@ -8,6 +8,7 @@
>   */
>  
>  #include <linux/sched.h>
> +#include <linux/sched/sysctl.h>
>  
>  #define TNF_MIGRATED	0x01
>  #define TNF_NO_GROUP	0x02
> @@ -16,6 +17,14 @@
>  #define TNF_MIGRATE_FAIL 0x10
>  #define TNF_ACCESS_TIME	0x20
>  
> +static inline bool numa_balancing_tiering_only(void)
> +{
> +	int mode = sysctl_numa_balancing_mode;
> +
> +	return (mode & NUMA_BALANCING_MEMORY_TIERING) &&
> +	       !(mode & NUMA_BALANCING_NORMAL);
> +}
> +
>  enum numa_vmaskip_reason {
>  	NUMAB_SKIP_UNSUITABLE,
>  	NUMAB_SKIP_SHARED_RO,
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 136207b62d87..1d9efc2b7427 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2760,6 +2760,32 @@ static inline bool cpupid_valid(int cpupid)
>  	return cpupid_to_cpu(cpupid) < nr_cpu_ids;
>  }
>  
> +static void task_numa_tiering_placement(struct task_struct *p);
> +
> +static bool task_numa_tiering_update(struct task_struct *p)
> +{
> +	if (!numa_balancing_tiering_only() || !p->mm)
> +		return false;
> +
> +	task_numa_tiering_placement(p);
> +	return true;
> +}
> +
> +static void task_numa_tiering_no_feedback(struct task_struct *p)
> +{
> +	task_numa_tiering_update(p);
> +}
> +
> +static void task_numa_tiering_fault(struct task_struct *p,
> +				    enum numa_tiering_fault_stats stat,
> +				    unsigned long pages)
> +{
> +	if (!task_numa_tiering_update(p))
> +		return;
> +
> +	p->numa_tiering_faults[stat] += pages;
> +}
> +
>  /*
>   * For memory tiering mode, if the target fast memory node has enough free
>   * pages, recently accessed slow memory pages can bypass the normal hotness
> @@ -2887,6 +2913,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>  		pgdat = NODE_DATA(dst_nid);
>  		if (numa_balancing_promote_free_space_bypass &&
>  		    pgdat_free_space_enough(pgdat)) {
> +			task_numa_tiering_no_feedback(p);
>  			/* workload changed, reset hot threshold */
>  			pgdat->nbp_threshold = 0;
>  			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr);
> @@ -2899,10 +2926,18 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>  
>  		th = pgdat->nbp_threshold ? : def_th;
>  		latency = numa_hint_fault_latency(folio);
> -		if (latency >= th)
> +		if (latency >= th) {
> +			task_numa_tiering_fault(p, NUMA_TIERING_FAULT_COLD, nr);
> +			return false;
> +		}
> +
> +		if (numa_promotion_rate_limit(pgdat, rate_limit, nr)) {
> +			task_numa_tiering_fault(p, NUMA_TIERING_FAULT_THROTTLED, nr);
>  			return false;
> +		}
>  
> -		return !numa_promotion_rate_limit(pgdat, rate_limit, nr);
> +		task_numa_tiering_fault(p, NUMA_TIERING_FAULT_HOT, nr);
> +		return true;
>  	}

I like the separation of scan-period updation of tiering mode from the regular
mode as the existing update scheme was dependent on private/shared faults which
made little sense in tiering mode.

However I am not sure if you should drive the scan period updates from
should_numa_migrate_memory(). The scan period belongs to the hint fault
scanner. I am pulling the promotion heuristic out of
should_numa_migrate_memory() in the pghot series. The hint fault path
only reports an access and shared engine does the classification and
migration for every source. The other sources may not have numa_scan_period,
so this feedback has to stay with the hint fault path.

pghot supporting multiple sources may not see the light of the day in
near future but it is still good to keep the source specific
aspects and promotion engine separate.

Regards,
Bharata.

