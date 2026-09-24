Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C733C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A2F6B0098; Thu, 24 Sep 2026 02:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9124C6B0099; Thu, 24 Sep 2026 02:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827AF6B009B; Thu, 24 Sep 2026 02:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA2B6B0098
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:34:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 829AE14027B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:34:11 +0000 (UTC)
X-FDA: 85247691102.07.10FE9E7
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010006.outbound.protection.outlook.com [52.101.46.6])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4F43C1C0002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:34:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1PrFq0ZC;
	spf=pass (imf20.hostedemail.com: domain of bharata@amd.com designates 52.101.46.6 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790231648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rs9glKE/E/uZ4cc8ih2YoPEtsOZEoucC7qzwfJpfqIg=;
	b=IcUmA8+H16JoMTgma3qXxCpxhnsoUxUPKDV7XSfWSLe3diSwEkHEM57xhwr9sBxNqZFFU9
	f39AXmU2m2ROfTvnWvQZApcFHfJQU0qSLDdfZKcoR9zBAizZ7Ci/V1mQ+7Jfz285HaT0+d
	NX9r/OXF/Zo6OKLcK9/OdVSRAlI/QDA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790231648;
	b=diFD250HhcfFX74M2oAJJ4sgDMXJQaBbdciw9vFBnaTSm7/xqkKAsJmpol9KB9vUNJCTzZ
	nwB9b6LLPPaZZhqaNyKL8lCFjCl5VrrV/oIOKRkEkxRW97UFFX62Tq1uS9LHh8zLQeH1v1
	Y2XVU4pOcXi66LTstvPKT8++67/4Lg8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=1PrFq0ZC;
	spf=pass (imf20.hostedemail.com: domain of bharata@amd.com designates 52.101.46.6 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qxnu3cP+48TUYf3e15hQJtxnnUViis4IOG8mzzdTLOJ4+xnUGcxsrzWrXbXvFbqj5/cI5OuTsFoskdrNOrj5lchylNC8NwgylSliiw/nxZlLJiHI0kn1sdRuxA2GnQm0VGn1Wzkhk2h74HImKHIsQPjiDz5xtuLIkPipCkVc4vDUnIyah8VOIxleQ6QL463IXYxR/coRUvAgzJPUrmpzt/PvlzRLSu+KMODQJBhRHiPglzZpZ6CJXGcUtGPLm/JIXqiFBwqGay9n9etM7lpD20X2IUKZhfdQR3qHd2oitOYRGdQ1pXolZ8vxPCcahtBDS2ecWa5I5YTT46Q5ysQQ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rs9glKE/E/uZ4cc8ih2YoPEtsOZEoucC7qzwfJpfqIg=;
 b=bktdGgoCFrsfmafejwlMfGerccA3XbaaSXkpUz/hfTo1quZqCYUlC5ggNvHgmYOu2GfqafvB/tLbVtD60JXFLjAVwe9wzEDKuGGXX20WIeiiDBxhhkQaoom9jmOL5Cv+FOGlWjp3XfGC80Wg4JlV5tvUiQ48ur73QuTmlx7Rqkmz2/HOxSTZ73vhYTBICzCGSd3gCJyp9VxJgopEP/iErcGbAvQOHadJlZmqCFpOixwHVb1FklcVjJy942WZkWYczwOfiGVRorKsAS/8zNFqQkqgPNM9EYAW9AO1+6whKEo2Zeo0az5NYbwC/Uk1o1qVtIhqMuNJCshsk7t2Zk/rEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rs9glKE/E/uZ4cc8ih2YoPEtsOZEoucC7qzwfJpfqIg=;
 b=1PrFq0ZCg2kPDYSkNVGQVQInQnyIso6natR7C9LlSO1QQEm8Wja1lytj2JBRw/+6B/my5VDFOKHLmNY+Y4nmu1zOnqgeuGlBehEjwiq9gy/Gm1OxKHbc6gBLk3jht6fvs/OJ1FDroPNb1h/Od1p4QGrwOlUhxzeFlBOFhTZCOYc=
Received: from BN9PR03CA0730.namprd03.prod.outlook.com (2603:10b6:408:110::15)
 by SA3PR12MB834210.namprd12.prod.outlook.com (2603:10b6:806:517::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 06:34:02 +0000
Received: from BN3PEPF0000B36F.namprd21.prod.outlook.com
 (2603:10b6:408:110:cafe::25) by BN9PR03CA0730.outlook.office365.com
 (2603:10b6:408:110::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Thu,
 24 Sep 2026 06:34:02 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B36F.mail.protection.outlook.com (10.167.243.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.5 via Frontend Transport; Thu, 24 Sep 2026 06:34:02 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 24 Sep
 2026 01:34:01 -0500
Received: from [192.168.0.152] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 24 Sep 2026 01:33:53 -0500
Message-ID: <22734e84-84ee-492f-9083-9e3034664a9b@amd.com>
Date: Thu, 24 Sep 2026 12:03:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v0 0/3] pghot: x86: IBS Memory Profiler for hot page
 promotion
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<xin@zytor.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<Jonathan.Cameron@huawei.com>, <gourry@gourry.net>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <shivankg@amd.com>, <donettom@linux.ibm.com>,
	<linyongting@bytedance.com>
References: <20260924062206.319314-1-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260924062206.319314-1-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36F:EE_|SA3PR12MB834210:EE_
X-MS-Office365-Filtering-Correlation-Id: 110a341c-2f29-455c-9761-08df1a05d2db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|23010399003|36860700016|6133799003|10067099003|11063799006|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	EhteMQs3v8GTrfSuCfmu135eyYlrLy+TNbNSXWgwSPrfiqGrMnyomo71sZt+/haZwqXpd43oaI/SH88UnzrtUaVH32aNezMq8+WJyTdYOV1RXTkLSzffgc4rsFZ8rytMV+oo6mKNC6p7XRWW3dyiC+dXQeQA2mx7SNvtA5gHuncShUq85jDM1niC2l0x+8vCbDjTzUuHhg4mRr0ZKzY8Y95fV1RI0jHe3DcHAzhiciR0OJAnxM2sI1R3ki8sa6HyA+MminJd9oBBr/H6pYq3pfKMapI/j2AmF0qq69uLarv60ZnGqpSjm7Z7Kw/ipguYqT/TDYmUU3UVbcxnOPcHmXsnt6zdn84TJkyzBvxcql+JooTxZ+r9JQEv9r5FQEd1y/a+U8qJ4WKfSWJ/gzrnXEckm5t84SXcLjQcSY2WIJCF9cAJe0rZNYHwRJZAG2QGvYLZZ+MFgFCwuDU4/1R84Zqp7NeTtCnq7kQUoNxPr4zrYsuSzk4/2qCqUXiHf+Xxw/RfjIZgszoMpVU/IqsGIDWGy/jHZHWzZXj8uUxyQyBFxVPgAaanYRoLuyqKb1UcIXkf55mb6UlSnYDV1irGUxkmLgM9l0i+Id0de2N0rlSrbFeKjFbR5pDL67ijC0GHvI0uriQ8d4hJuBDJK0yb4h6jjzCxbBpucJMxVWX92yxb3CklICF1JNWtnuieZpvUdl0/zgPwslONna1J1SuzEw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(23010399003)(36860700016)(6133799003)(10067099003)(11063799006)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XWUwoGOSNHGkOmyyWn6KCLFy3YHvSUQlZ+e12+WqGlDGEn0bRHGSbjIjPW4CaEihtwj3BgAKsENOuFv8LGYXqAy1Xvrw4VCcFXJ4J8WO7c6H6RuWp223xZBOVt6dfKkoHgxYS1+eBSj1ycypcJh1BH19FS9ZdQUe09KG+3g4BtTFdL9skQEMx1i56HI1PAXZLkO+XjccEhOl4HSd/UVvt6jloaQcYHeSyhBtlZqWE4qNxJ8ET2ZzECIad02YfL87BNqPiu8LGZ6Maq5qKPcgtDK/VR+0+VO8eDBS9/HYKbFvRzDTCn5/lMs+1hwruOMdNxbSalJpGEnDsqrrwS7vDC0XOYLwFtCYu6bKTsctunIL/Fo8qYV2yVOlAATMqEXwigEACJj8/yOnCVwleWqRA7xPRG2wkKlvFia3aGfjn6ScCDFSaFEIyXuYHsLRB+Ua
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 06:34:02.4274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 110a341c-2f29-455c-9761-08df1a05d2db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB834210
X-Rspam-User: 
X-Stat-Signature: ehfi7goxzgsbemrbzybxdgdpxb8ujtxw
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4F43C1C0002
X-HE-Tag: 1790231648-468731
X-HE-Meta: U2FsdGVkX1/O+cgQp2iitwgqF9Cw296fPGUkM8kSga8BzXH+n0jrolmg234krdvsQj2PGlNxjDwXsIh896/SKK7OOTxXK+i4Kc6BSHREBF0+d2oZr/pTmeSql0iYBenS+j6l9zMycximfJ27K+eNVMMW0iIRhrFca/ouuLOZe2NOof5WUJJYM+eHWv4dM+2Zr1mL8sLwQNbFUFJ6PFJa5Q08Z1QEiiLB2ZAbKoXl2MqPG2SBNcxnNYmdYWD/jQZE7HVZJT83XIQDWiXzYbIczphPlh9rNtDo0ZjHsuQ0RtsGT7otMNkvrwl0WFkLRUo50TL/RwKf8yPlRNSZ1m3k475OjvqU3vlrnO/044Lrogl8QIyrt4ZjWVv3MNXvrAOOCq8mlCXQqMVtPZD93yKNmwswEdC9tQ1bRbJWv7mY42ceFPuto7PvfRnBABc0qxnnUly3ZHogYvw6qDovM34UMkADyZ0B9yceH4NW+rDnZ6dxjpz92hEiCsouTQdDoYp9Ck6JI+sqwOyML6o8J95ThzDHmjazmFfVnYD/LW4ofAmV2GwpWw4ZmCRHwo+dr2oXT53ROM4riJ8aA+r+bGmdcKnCVq89xYyR3fB/FQBiaL732sCNEuZqD1h6ZjETnLF22wDssUJ/J8p9AlKkXTr0dHcJ+Y1BMq+2adxVAjugCnbMpaFvlu6ptA68QCOxSpLywZbJxKww+ZCgE7G/AwkitK2KGq4k9xiWXSZIfhL0Z5vRxG/3ghW334IUYtNd5Jpw9F2kL8CxH2Le0cxgmEGnybIryh1GT5q3bW9OHGepLvTmR04OR914xoCMJHF4gSPyogoZ2JCoefq/WrpViZTEa3k80WkoCtDJfMqb07S8Ccbp+e1koUqXecwaYCZ2yz15OR1014waityYqTX2VkfAvwHWG07lZFtgJJYKT1qeIvYjvtnmermFHTMmEa7mVXg+7WSFpe711C9CoMztQKQ
 mZD21wlJ
 URxN0dgtIoq5TK8vqP2HMqB26JW+jyR4kXjmC+CR0EV4q926wcFscUD+3pAmLyWzCAioMYhHd1niHYf7TH2DP30sRiB1k0eHwEcfNkO36oCqc3ewmDMfuTWqtO604JP2bAWfwMHckeUprF+R20f6kVONYZwR/Tzi3/Lm6kjhA5cVpS77GOCXWJGt34OXSrm1vF1k7E+DQCbAGkjeOwHB9FyLVix2LvaCfZY1ftJNj/lNo7gnD5OnsEBGXNCfOHhgGLdfctBFXSYryX+FuORnWP564eHp6aP1KGRj3+MxwzPcgF05WO8l6AfBo6YVFskg7ov6jXG9jT0ZS9Khkg3Ygbg2d6GjtYlnPaVozjnv4DX7ckNrYb4AQmjOW9MGfJrU9YbXmUAHpkbizEUSm7+usaBEiky48Mb3byjCmThiCFKSlG6Pdy3NKixCqzrr/QTkzQ0TemiozVvFHKnqgqnF2mWHVAl3+juJX8ZW61F3Z6NVOYws=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24-Sep-26 11:52 AM, Bharata B Rao wrote:
> 
> Detailed per-benchmark tables (throughput/latency + vmstat and pghot
> promotion counters) are posted as replies to this thread.
======================================================================
Tiered-memory promotion: baseline vs NUMA-balancing vs DAMON vs pghot
hwhints (IBS) - multithreaded runs
======================================================================

Runs taken on one machine, same workload and sizes.  This is a self-contained
comparison of four ways to promote a hot working set from a slow (CXL) tier
to a fast (DRAM) tier:

  - baseline        : no promotion.
  - NUMAB2          : the kernel's NUMA-balancing tier promotion
                      (numa_balancing=2), driven by NUMA hint faults.
  - DAMON fine+quota: in-kernel access monitor with a migrate_hot
                      scheme (paddr), driven by the kdamond thread.
  - pghot hwhints   : per-PFN hotness from the IBS Memory Profiler
                      (hardware sampling), promoted by the kmigrated
                      thread; shown at two IBS sample periods.

Machine / topology
------------------
- 256 CPUs, 792 GB RAM.
- NUMA: node 0, node 1 = DRAM (fast tier); node 2 = CXL (slow tier,
  256 GB).  Promotion target = node 0; cold data starts on node 2.
- Kernels: base = 7.3.0-rc2-base+ (baseline, NUMAB2, DAMON);
           pghot = 7.3.0-rc2-pghot+ (pghot hwhints).

Workload
--------
- 64-thread pointer chase, 64 GB total buffer, 16 GB hot set, 240 s
  timed phase.  Buffer relocated to node 2 before the timed phase;
  worker threads bound to node 0.  "hot set" = 16 GB;
  over = (node0 - 16 GB) / 16 GB.

Configurations
--------------
- baseline : numa_balancing=0, no promotion.
- NUMAB2   : numa_balancing=2 (tier promotion via hint faults).
- DAMON    : sysfs defaults (sample 5ms, aggr 100ms, update 60s) +
             migrate_hot (paddr, nr_accesses>=1) + max_nr_regions=
             100000 (min default 10) + quota 128 MiB/1000 ms with
             nr_accesses weighting (hottest first).
- hwhints  : IBS Memory Profiler as the sole hotness source
             (numa_balancing=0), pghot_freq_threshold=1, IBS
             l3miss-only=1; IBS sample period 10000 and 5008.

Metric notes
------------
- lat  : steady access latency, ns/access, mean of last 25% of samples
         (lower is better).
- node0: end-of-run placement on node 0 (numastat -p).
- promoted: bytes migrated to the fast tier (DAMON scheme sz_applied;
         NUMAB2/pghot pgpromote_success).
- CPU  : cumulative cputime over the 240 s run of the single promoter/
         monitor thread - kd = kdamond (DAMON), km = kmigrated (pghot).
         NUMAB2 has no single promoter thread; its cost is distributed
         across the application threads (scanning + hint faults).
- over:  The "over" column is measured against the 16 GB HOT SET, not
         against B0: over = (node0 - 16 GB) / 16 GB.  B0 promotes
         nothing, so its node0 is 0.0 and its over is n/a.


Table.  Multithreaded results (64 GB total / 16 GB hot)
------------------------------------------------------
id   config              kern   lat  node0  over   promoted  promoter
                                (ns) (GB)             (GB)   CPU
---  ------------------  -----  ---  -----  -----  --------  ----------
B0   baseline            base   320   0.0     -        -     -
N2   NUMAB2              base   143  16.0    0%     ~14.6*   distributed
D3   DAMON fine+quota    base   119  23.9  +49%      24.7    kd 13s(5%)
H10  hwhints IBS p10000  pghot  215   4.9  -69%       4.9    km 20s(8%)
H5   hwhints IBS p5008   pghot   92  11.6  -27%      12.0    km 38s(16%)

* N2 pgpromote_success over the timed window is ~14.6 GB; some
  promotion happens during the load phase before the vmstat baseline,
  so the reliable figure is the placement: node 0 = 16.0 GB (exact).

Supporting counters
-------------------
- N2 : numa_hint_faults 3.73M, numa_pte_updates 12.9M.
- D3 : sz_applied 24.7 GB, qt_exceeds 229, regions settled ~21-71.
- H10: hwhint_total_events 1.40M, pgpromote_success 1.29M.
- H5 : hwhint_total_events 5.91M, pgpromote_success 3.15M.

Findings
--------
1. Accuracy (placement):
   - NUMAB2 places exactly the 16 GB hot set (0% over).
   - DAMON over-promotes (+49%, 23.9 GB): a coarse-then-quota scheme
     bounds volume but still moves ~1.5x the hot set.
   - hwhints under-promotes within 240 s (-69% at p10000, -27% at
     p5008) because hardware sampling observes only a fraction of
     accesses; it had not fully converged at 240 s.

2. IBS sample period is the coverage knob.  10000 -> 5008 roughly
   tripled events (1.40M -> 5.91M), nearly tripled placement (4.9 ->
   11.6 GB) and cut latency 215 -> 92 ns.  period=10000 under-samples
   this workload.

3. Latency does not track placement linearly:
   - hwhints p5008 reaches the lowest latency (92 ns) with only 11.6 GB
     on node 0 - IBS targets the hottest pages, so its smaller
     placement is well-chosen.
   - DAMON needs 23.9 GB to reach 119 ns.
   - NUMAB2 places the exact 16 GB but its steady latency (143 ns) is
     higher than its own first interval (119 ns): numa_balancing keeps
     scanning and faulting the workload's pages after promotion, an
     ongoing per-access tax (12.9M pte updates, 3.73M hint faults).

4. Promoter CPU:
   - DAMON kdamond and pghot kmigrated are both out-of-band and cheap
     here (kd 13 s; km 20-38 s over 240 s, i.e. ~8-16% of one core).
   - NUMAB2's cost is not a single thread; it is paid by the workload
     threads via scanning and hint-fault handling.

Caveats
-------
- Two kernels: base (B0/N2/D3) and pghot (H10/H5).  No separate
  no-promotion baseline was taken on the pghot kernel in this set, so
  cross-kernel absolute latency should be read with that in mind;
  placement / over-promotion is the primary accuracy metric.
- The CPU column is the concentrated promoter/monitor thread only.  It
  excludes distributed costs: NUMAB2's scanning + hint-fault handling,
  and IBS interrupt/sample handling for hwhints.
- Latency is not isolated to a single cause (bandwidth, working set,
  selection quality all plausible); placement is the primary accuracy
  metric and latency is supporting.
- hwhints coverage is still ~27% under the 16 GB hot set at 240 s
  (p5008); it was still climbing at the end of the run.

