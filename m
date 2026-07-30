Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E37C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 06:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4DA6B0093; Thu, 30 Jul 2026 02:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C951D6B0095; Thu, 30 Jul 2026 02:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5D986B0096; Thu, 30 Jul 2026 02:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C98D6B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:34:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 592941608F4
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:34:55 +0000 (UTC)
X-FDA: 85044480150.16.25EEDE3
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010070.outbound.protection.outlook.com [52.101.193.70])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1A688C000D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:34:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1jBLNkqU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of bharata@amd.com designates 52.101.193.70 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785393292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bglS7oomxZfgdvHoNj18LEuXieYUwHYBmfu7vu8Wias=;
	b=znhBxEzcyZRjSxsOVMHd2EsQTaO1PRG6q0LvVqmQhAwdKGuoe8TcFEE8CVZCIaNlQajWzJ
	5qgyibKZzBc8ED9cbHXP87pmasnAuVZ/sxbNxkfv+HFUdO9f/AqAfcN7bTXUTOcqC/ctxQ
	0ODoTiFyjFjX+PpgnGg9nsv1mjgbBEM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1jBLNkqU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of bharata@amd.com designates 52.101.193.70 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785393292;
	b=OGDIVKgXEXCnDLZGD4YsNXeL8PGdxKZ+PTq1qAR8iAjMbE9FK1Lk1uf9ePqJt3tPwMsQNg
	MQNsvnSC4IV4vMl2VOH57cDAAbFjuMSVu9cunURaiQXGicv/6oG1bWpcJBIAKvP+xpNSkM
	TKx99Rzu70/hBgi6eXDv6gaIbRyHeeU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cgOahkw7jF6YvP7moj7UEoSYcPb5h9/PwT7S9Oc0e9Ki4kBy3Tpy8+5SLGtLeXesNWCzTTepSabUps2Bm47KCtVEzRUsDd4C5qscNS3czFlYuNwlEudN8FkaZWgXXXybd92EhSRzIJSFfbnj0z+jp2L22LT/HXvrrxy0r1zT/S0wP6KUaM5AAwxeM9r9mZ/Ve1skW7kaEjxXv+eD5XBsbMof71Rdp22UZSspRzJqpVZHdPYPf+0sgRDcsHWpq0GJkciyaP4R4hTHBmG+o6hFkptlhEtwKuXCeD5q5oBnXI7bTHUQ9UHYO7T2ucCpzZ9vbjXiTpFaFksiuFXiqEAa+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bglS7oomxZfgdvHoNj18LEuXieYUwHYBmfu7vu8Wias=;
 b=LH+4mmzVp+6ehukfh/GQMYdVE/c9AtuZLTlRd/y4I9Tv/F9S8UhUlSvuuEQUeKCpTXUOBfWiM5FAJcO36KOhybOF7y4tCbm8lDNtiKS5wFBpa+tVwgReIN7Us3euCyKA2HC7jhplf23R4Dts0/vqWRpWEbHxNHFbxxll2mRBgJpL0woDhpTJpjNgpwruEpkrb89s+eXV+UaESJzcBWXwBAHz82YO1MEl3PA7M1xrYkDDkDhY6lVEXHKdsbzQSlAQ9zw1/Vc6Q6IOThZ9RLZHSzBCuS0xbIts0s7R9Ugg7X/CQAVC7NE2yzRT/NJdPkYMxcPfQwtgb3zuXiC/rNsmJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bglS7oomxZfgdvHoNj18LEuXieYUwHYBmfu7vu8Wias=;
 b=1jBLNkqU4aDdMthuf2+uGEnBRAQ/zbcMZQxLO0FTXh03r/jEST3lQNSlaFt2m28d1PME71hmw0I0taL2By3QzkELj9axyQKxbtPEdo6cnpngJ1lV8Nn/hhQKPQ00o3yXNPFzEhBcTjoH8H3qec9EFxqYom76L34SpXfkEeJ5sgw=
Received: from DS1PR07CA0017.namprd07.prod.outlook.com (2603:10b6:8:44d::14)
 by IA1PR12MB8261.namprd12.prod.outlook.com (2603:10b6:208:3f7::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.13; Thu, 30 Jul
 2026 06:34:46 +0000
Received: from CH3PEPF00000014.namprd21.prod.outlook.com
 (2603:10b6:8:44d:cafe::c) by DS1PR07CA0017.outlook.office365.com
 (2603:10b6:8:44d::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.14 via Frontend Transport; Thu,
 30 Jul 2026 06:34:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF00000014.mail.protection.outlook.com (10.167.244.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.1 via Frontend Transport; Thu, 30 Jul 2026 06:34:45 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 30 Jul
 2026 01:34:45 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 30 Jul
 2026 01:34:44 -0500
Received: from [172.31.176.217] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Thu, 30 Jul 2026 01:34:36 -0500
Message-ID: <48ee7e99-d66a-43c9-8068-689113a744de@amd.com>
Date: Thu, 30 Jul 2026 12:04:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/8] mm: migrate: Add promote_misplaced_memcg_folios()
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <donettom@linux.ibm.com>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260728054356.291998-3-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260728054356.291998-3-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000014:EE_|IA1PR12MB8261:EE_
X-MS-Office365-Filtering-Correlation-Id: f34424d4-51f8-4f96-dfca-08deee04a550
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|1800799024|82310400026|56012099006|4143699003|11063799006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	E9oidyqqUvJcqYdVInu7dcAyNoKBRqt89cSTOuRvnFNUovpIL5F2SLbzDgZSu7sM/+X8D760xnLzMavovtDxa5EGC3iOoEY78wGC4UUevY3TLcNmjv2GoCgfDeoruLWXXK69p24w07Ts57oxatofCypoVbFyy1Um0qvnX0UqDs7JF5VrHPnxHRuk0tH27mRKr3dRqP5roMsj5UtJC3syXE1a2S44fyG9RwggshxE5hrfNhkTdVUq9mtXBcMI7aewhjWkP99DxvUHUaasF6oyN2b3VhCRNDLaeMxipriCtiml5LJ60I4l/WWgOCNb4/m0ez5V1iSyG+LiUv5RZIQeTnSFHKRbMNo+bH/NGtztiHfcaJD5OgR0hsprl8A+1cRXf0BDRgkbwamer3bKJt56HU4cVIWBgJabBCPu2Iss2dTCrZGOubFHXQhv+N2ueSSW8bKnL+NfgL1LaQyPfJ6P5RgzyWMH7Mol7tl55PcHvaeODAusfxEpm9aWeU5Kiwhsp+8FDVxh1SODKl40PqNMtdy/AyT2WFThgCIrjT7NP7SCrgs+J/RI2c0J0b2EJXmG92pOBDgIG2uDe3oHiGUPW98OHK+8I7fVampwiiqZ5AHmbKH9cG8nq7xlBHoPCh47igTb/+XcYonCiCSoKUxeZdLjK6m7CCMCFdIa0qNaLXCJJL7byvBwdsFATbAJjL4cgPUqqA4K5jzUjRFMwU1Thw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(1800799024)(82310400026)(56012099006)(4143699003)(11063799006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AStGOysqFt+tEBF/XflP324Yd8q4+tojKqrvpTTUZKQbG6JRw82tbmVlG+LqkP6hD3vxMzdM3u9d/dmfc8lhgWHLRUHpCtx+Xa8TWI/iNwhuWNRaUQsEpTSisU1DIjiuVN3FnZRMzHi2EkhcaVLpTThfk844UaBnatPtHj/du6iK+/GhWHX2zo7T5MHs1sIiS2LEcYZUU77CYOzFRX+VClqu0mP7JjRvyXb8xDuvfELEdpnT0XP+3j78F+iSLFupeZk51+50e1HL1gtaBTEEY65CJDpyRJ6zEQVO/9COWF7vr1ltvIkPWO7m1rJZGSXQEYSDrDMmPDti2RguGLJz+5HfFGuHM/K7Qz+HPkUHbK2MtsDAr4EtuddTHVvBgbbZpAhTpdAiXafhYc1eFsrNcpIZHFhKWq7YN7dJiPeoAkOX/ba5e3Q5nsvMGvoKjQCy
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 06:34:45.3472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f34424d4-51f8-4f96-dfca-08deee04a550
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000014.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8261
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1A688C000D
X-Stat-Signature: mg6xtga3kt6zwyqacroo9xwapztm5ooh
X-HE-Tag: 1785393291-855492
X-HE-Meta: U2FsdGVkX1+wfzpP6nIbS9lwbX41jrm9r0HYJaIlNd7sv6gtB30NDQJ25J1BLcIDmEojg0mqT813+RFQrUcrxIiGYSB/955K4KKw6AGmIU/zf+isrckmTFUSYBHvgTz2O1tBsuJYZcTY2USS0+YgU0B5x9BngIflNSp6c7pnU/xiFrWb+cCkZ/JKB1owRvxlF3jQk9216xpIQ8cCyWwKyNGWy7d4kYah4A/cJLpjhVDMVpT4TlgiKwbK4JShp2lpQB0W1xvUv15/qpZjSPT8A4Z/3GjquYF64aro7hrIFsgiZNjT3V2nF/PrBqpiD4eb0bNo12wN8QSwhhg6MSQUcOQex7/QIrYlp2K+wALqn/gSUYvP4P/s5h+I0m4zlce5UMNGBOHiZHohUqOfQUeA5JpKb2gmjFdOi58mE2uyWN1D/CxdX/mZ64BL0+l2oUyyxlX8bMnVQ5AflXFQ40svtPBbBpbYMofWXR++vaPMhBw5YdVkNoi1KrlykSYLNXzRZ+att/LpRLoU4GXmGIvnYnAz/XauVR/BILPViQB7+8H5hMhR/rXFRxosgA0YyxwTh7ev5Yim0dreXVQcFi8DXNV0yQbp2n5dJohfniB2zZHOQlmPBEUK1N674cgpba0mpmhBgtSGVmmUW7oHObbKo40pWDhPYL1EEly5B5vEu2XqXvMqon4eATOf5632gA0i4NEot3sBH4hNaoB8ktMkQL4mVo4+7m/6VcgO7xlnsp6cnqIO9zjw2imqKBq7GCQtXm0kqNZCOr8hFz3F6lROfbO+RriwbV3OD1HzgeRao+Ac2LRl4YyhT4mrOrz3nILJKKooETXKPrcjisjHM5V/Npj1siseKWaES236jhHrjIfyA1G1zD3RicfOrYhc5EHKc4RKlCCiPy2d6gvNHAY4u5WhQvVKjt0j+t9rr4VTBXfC+pgLbSUKfSqz3UvElspNhqyz3LxajeLpuPSi+yD
 CJ78sa1+
 eC0y6AA/9KVuTBRHRmarGPpEuNhps+HrYQrhHy2do0rHBDDzI5KcwTyN/Qese7qOir4QyL6MCwReRZWnPeF3hMTFHKrf8b0Uc9pHGK5TYgN6axmG2TgWLaOn931KVjHJq1tgPJvvuEUdpEcyZTsPyKwXazI37X+nvaLZaZCGPeg1z6W8IN2LkEwAS3kzEPQuYNJDja1p1pPub169tvi6Jhpb2r2p6uCY4kFiSfbmG6nVb1P80UuT4r6gfXwPlgZGsmq5A+65/ERsvhG6SSschiR/gClxiDm67Gc4d6amrzWi1Ce1nsorV0zv9KwiBtxc0JEXHpXHbamaX2zX7zk2zYsxbRMl/Me3iqz57ZyRNPt0UHE3C2VJReQqjGkRbx+4bgZw/FtGMo278seR0Uhv7yVh2xNAn+HbR+2Hl9qgJKFbA8DD7TgJlq80+h2of2I8wOCiogR0K6kngo95SrS8VvDqKnTfHFHB7vE/fId5x4xL1M4dnqqQatvfHOi/zTH47f9/Dnzpa++oFrcgGSDRVmVd/gBn2765XTAhu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Reply to Shashiko review]

On 28-Jul-26 11:13 AM, Bharata B Rao wrote:
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ab7227376757..58a8a0cf6fa3 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2773,4 +2773,62 @@ int migrate_misplaced_folio(struct folio *folio, int node)
>  	BUG_ON(!list_empty(&migratepages));
>  	return nr_remaining ? -EAGAIN : 0;
>  }
> +
> +/**
> + * promote_misplaced_memcg_folios() - Batch variant of migrate_misplaced_folio
> + * Attempts to promote a folio list to the specified destination.
> + * @folio_list: Isolated list of folios to be batch-promoted.
> + * @node: The NUMA node ID to where the folios should be promoted.
> + *
> + * Caller is expected to have isolated the folios by calling
> + * migrate_misplaced_folio_prepare(), which will result in an
> + * elevated reference count on the folios. All the isolated folios
> + * in the list must belong to the same memcg so that NUMA_PAGE_MIGRATE
> + * stat can be attributed correctly to the memcg.
> + *
> + * This function will un-isolate the folios, drop the elevated reference
> + * and remove them from the list before returning. This should be called
> + * only for batched promotion of hot pages from lower tier nodes.
> + *
> + * Return: 0 on success and -EAGAIN on failure or partial promotion.
> + *         On return, @folio_list will be empty regardless of success/failure.
> + */
> +int promote_misplaced_memcg_folios(struct list_head *folio_list, int node)
> +{
> +	struct mem_cgroup *memcg = NULL;
> +	unsigned int nr_succeeded = 0;
> +	struct folio *first;
> +	int nr_remaining;
> +
> +	if (list_empty(folio_list))
> +		return 0;
> +
> +	first = list_first_entry(folio_list, struct folio, lru);
> +#ifdef CONFIG_DEBUG_VM
> +	{
> +		struct folio *f;
> +
> +		list_for_each_entry(f, folio_list, lru)
> +			VM_WARN_ON_ONCE(folio_memcg(f) != folio_memcg(first));

> Does this iteration need to hold the RCU read lock?
> Looking at folio_memcg(), it calls obj_cgroup_memcg(), which executes a
> lockdep assertion requiring either rcu_read_lock or cgroup_mutex. Calling it
> without these locks will cause a lockdep splat when CONFIG_PROVE_LOCKING is
> enabled.
> Additionally, without the RCU lock, can the returned memcg pointer be
> concurrently updated due to memcg reparenting? If so, this race might cause
> folio_memcg(f) and folio_memcg(first) to evaluate to different pointers
> even if both folios belong to the same original memcg, potentially triggering
> a spurious VM_WARN_ON_ONCE().

That list walk needs RCU read lock protection. Will fix.

Regards,
Bharata.



