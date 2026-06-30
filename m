Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FA2FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EA3E6B00A6; Tue, 30 Jun 2026 03:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C40E6B00A7; Tue, 30 Jun 2026 03:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28C416B00A8; Tue, 30 Jun 2026 03:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDC656B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:29:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6ED7D403EA
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:29:49 +0000 (UTC)
X-FDA: 84935754498.05.7BCA26D
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012004.outbound.protection.outlook.com [52.101.43.4])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2E573120002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:29:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZVn08Eda;
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.4 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782804586;
	b=dXHayZUiPNCsqCMyHKuxsn8K8+aMqWOfZJM5sCWgwJezOBFaUoXfBLYKJQuV4pQVBDp4zD
	WjPE0u4MGp9jURKfsm9Bg2n6hBCHLHiNg0B+j5S+MQFp7Lk4LP/Nclc4guBcNuIZJig9+q
	VWHOCd9GLTR+84hiw7khoKqjRGuBaio=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejtVnlH8iz5PO4bS0HPGoIKn5VpJDvbvOnHH9m9ec/s=;
	b=O0HWd2cLxbjyDWAC2XQXrkNuYvptlJjCk8zC17KlWGtvAR5vMkUdBIdAfQ8/TcfYL6ZWSa
	ZhSuHQow93w/71ROxWB9Sfk8UTHAYt98QmFkPqvhmKD7NqBY4ufe8zuzb6u5EnmwIWgBHV
	ZfPr9viRrKgbyDCFDsQvAjA0/Wx+G7I=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ZVn08Eda;
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.4 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MpPvmUeckbEWg67gSEskCn4tpoziXai6ZKdR7kBf6M/IdkS+HAF/jIydQKgFB1qkB/CmOyfIJbuWe/Wld77WbU+is9RlRRcGhDXPHJaYQwuD5K/oOtpv39m9u/XXo9M/uB57qyFtOEgw5IGan+uzmm4gUbNWjw4jHdQKxrRAV5Ru5Wu5H6sOlcTN7yul9WiOQHygeu2z6/Xtwmf4KqLDPDOHyBDdxo9LZe9A3z4WCa/HivOmM2EivuwH1cNcjC1HGwI4vmZUplljtxHm5vIhkIyRE3d/3jbaZHtPTFmI/fnZTyJsAcMVq5bFGTwOhopmimzPgVmoj1Sn9+44+5iFOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejtVnlH8iz5PO4bS0HPGoIKn5VpJDvbvOnHH9m9ec/s=;
 b=bVqPHn7FBidBIFLK6vxrcoegjqsKrPVoMOQ9Jnxy9570Mabc441Uq1bfEv8QwZAlHJzykSXfzrfOIsUHLs/6CuHSLJfe2fFlhCvoa0AvD4sVsnNeVr/BmEdQe4XFThPPekC8g9PtKff4RxZdUxpjgWnKkqT/1Xs29TvuBAAY3aoDFFjDsSfZr3vzVFmjteiN+9Z6Q0DW3fPpf7dB0j4c6fTK0hcGiHm6AkRnFMKCm1+6limnPUY0WwiU/pA3HK6YiLfonDKQMW6HDeoWac8i4wYOnnzWuFJqwAhOBjWXKrrtmtgbseiK5iQII5FnNUPy6zzB4Qpac1ebww7C3cC7hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejtVnlH8iz5PO4bS0HPGoIKn5VpJDvbvOnHH9m9ec/s=;
 b=ZVn08EdazfIjUYT2GSxYvWimizp8Tb90iLo9EIRbx+gx+yvrFg28yhKULUZoGQoDCB7cqq2OKMMTfJpYbql4vccLITjXpglaObR0201ZjUjhlqQbADyDitXSF/fvmKltNaZvZuJnesujsE1LXYbWT4U+hCWINI6pBOxfxSnJuKY=
Received: from MN0PR04CA0019.namprd04.prod.outlook.com (2603:10b6:208:52d::33)
 by CY5PR12MB6575.namprd12.prod.outlook.com (2603:10b6:930:41::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.18; Tue, 30 Jun
 2026 07:29:39 +0000
Received: from MN1PEPF0000F0E1.namprd04.prod.outlook.com
 (2603:10b6:208:52d:cafe::8a) by MN0PR04CA0019.outlook.office365.com
 (2603:10b6:208:52d::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Tue, 30
 Jun 2026 07:29:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E1.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 30 Jun 2026 07:29:38 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 02:29:28 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Tue, 30 Jun 2026 07:28:40 +0000
Subject: [PATCH RFC v6 4/5] drivers/migrate_offload: add DMA batch copy
 driver (dcbm)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260630-shivank-batch-migrate-offload-v6-4-da95d7e8b8a2@amd.com>
References: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
In-Reply-To: <20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>
CC: Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden
	<fvdl@google.com>, Teja Vojjala <tejavojjala@google.com>, Pravin Tamkhane
	<pravintamkhane@google.com>, Kinsey Ho <kinseyho@google.com>, Wei Xu
	<weixugc@google.com>, Matthew Wilcox <willy@infradead.org>, Davidlohr Bueso
	<dave@stgolabs.net>, Vinod Koul <vkoul@kernel.org>, Bharata B Rao
	<bharata@amd.com>, SeongJae Park <sj@kernel.org>, David Rientjes
	<rientjes@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, "Yiannis
 Nikolakopoulos" <yiannis@zptcorp.com>, Dave Hansen <dave.hansen@intel.com>,
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>, Shakeel Butt
	<shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Fan Ni
	<nifan.cxl@gmail.com>, Jonathan Cameron <jic23@kernel.org>, Aneesh Kumar K.V
	<aneesh.kumar@kernel.org>, Nathan Lynch <nathan.lynch@amd.com>, Frank Li
	<Frank.li@nxp.com>, Dan Williams <djbw@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782804526; l=17627;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=slS65rgIlB5eytgKz5oEceZYKCMBATb7d3dSKNrGEzc=;
 b=3g3WBxTfgIAGae10nFvFaK1uXS6woAHtuiQRN1Ocik+Tt0pyT2KLUvxWt5VNKNACIbacUmeOV
 gK3S7BOsjskCXb09+V83F8LH1X1uT+YXQS+DvCY+S/HG0E08WxZcwoJ
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E1:EE_|CY5PR12MB6575:EE_
X-MS-Office365-Filtering-Correlation-Id: dee72db1-2dea-4219-cbc0-08ded6795812
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|82310400026|7416014|23010399003|3023799007|18002099003|6133799003|11063799006|22082099003|56012099006|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	dvcX9iXxQyikEigeRtxZtuiusSuQO7TAy8rp4CpbWufQvkiWg6/2hRd7Sr1+H1BNzARqWBi8srVnRj8BzHL2d0B6g6RDPuXcxrcaQQ7soiospWFnZbRD8xG9ZZ9PVqzMx9IhJiqA7oxA1XsWFns5RhCSU7Sa4MlaB1BI4nDDeuLf7S/Q0AQz4i1fzjZy1Rzl3BSJ493mW/C18KBaQQyKJa3tFMBlqfOggUkY1gBWNv0qLyn3+TrW/pHW/nJi0TdPeWuU+Zk8GrGRUQNf0VpJhhfqQgJbrpZU5uVcCAIGZ3P7hRhxJP12HDYK8Ym3U7v/VfmlI8hZEw05em5sf0XTDCGg2TiHteiLXbbA+N31DT7BNY+WkaCgidYeiQA4eSKdNSU5A4p3VaUzqWZrpXSUTsOFL2F+T69Z1F8UUj4REnUno5Vc7gITauaCUVWQeN+Wds9/S/mYpHJNif/I8R8jCGiBZmv/lumgscrZ6F94Smxp1kXJZCfi0Tvn15uNZZolSo5dSqBV0E9rgVBsYkMFhTO766Ttp2XuaoolY5+dO0R8CMnu9D0FiKIjYbtCyg0W2Iha0U5yvLwCIUoMe2hryaI8EyvGQWstdY7l33CqAReB/xisReQXDgQQtTI5EFsupdZHotGUEdLDXbLBwsCES3ZgzlcPBOA9RgqU4xPgSw7efa6VcJXyDw27G/y9Cidm5Nxcdyc+gv7x5S6zK2ea7c0DdD06U7IaHgC6Htt6+6eZDs7Dm2bergp+xB4kGqoT
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(82310400026)(7416014)(23010399003)(3023799007)(18002099003)(6133799003)(11063799006)(22082099003)(56012099006)(13003099007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5t2UaiD4XZ2081zWXtboEkd+HEKNp2Pc4uibeVirwbXkDW6WHgB6PvobERGiIwVeE6kn81hDuWbeJFL+0hQ25s3sXc3ymVasfoQTusCvHI02/lT2I9ZiQU/cM8pRBPwCBQHUe5GGMl8oJr4F6181PxRN+misxVM3CzWmlZouSK48LwVLvqcitwTYXaaxFiDu0i2sWsR3heRTutTCPVI3k60Sjm/fEW7ZYkM9bAlZjaa3P5CUH9krFnFCVkYQCWlcGYZhtSSJSJnasOL4y4sdSOuALEk6+0IIAPIUkRxsnLFDjlcuPWVTZg7Xt2VMURQrPOb9WKWyGt7kCRh2D99raSW/V0YqeMOT+VuYF5QuKJ3a7aD+GCHqhxewZAS3jDdGriHlilKK6I/dRt9RGLyPltQdG/0OkqN12YtxlSrXTt1M4O6LjQS/uLFxJG9EP84P
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 07:29:38.9760
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dee72db1-2dea-4219-cbc0-08ded6795812
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6575
X-Rspam-User: 
X-Stat-Signature: 9qymxc1tko37n5mugcfhmwcimhyo7c84
X-Rspamd-Queue-Id: 2E573120002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782804586-773399
X-HE-Meta: U2FsdGVkX1++9iG10ENEiDi87jAzJXU9W+i5cggClODs3/ZrnERCuQLYQVG28v2c4bcAPyEAscv41Jiqtq4aAkZzhKGnW9FinLN07wCGNmYfxtTPKAWaEeUdKjFB52vb9xO8kSO2zjKa4XIlhz47yfe6p0feIFsQyYcyZTXR3lXprG1QTZcgk6JAIByg4h8BBE+rQb2j/2KMo75s7ojZqrsdl9HxjmLDQMF1hNLcxz+vEwS58fewVKM9D+BJYWOJ25sfEIwN5yLwM9xYRs0mjGR0ImV4q+UPRx8xhxm4g8jrpIqkebOHpzKrXR5r2vaVXQLASWf2hl8PBy26IJR2EQjeNFrc9sXXmL2rJBq5rH2TKh6UXjjCelMgomrVFbDv591lx6KWLSOx8jxWtPh+bmNqUZpm73Pd8/5GDVXqfoT4zzI9MGluTpUFS09pr/OzrdRNxOncGK7K/3jBifIFyNMSPb1hNUFpf/QHcMFkmyssYq+SbM/wwIJjOXBAL7Ql0csqZwUWMo98MsraYNFuIqXDqmBu2fl8Id85nNSkyttq2Rwf27e+BfWjwvG2rCC1Hc39SU/dP2wmzIjMsfuHGBle6FAVRWrnvxzmPWaOY4L4OT0jKTHk6QSZ5QLqIp+5gMyh/kCbaB+Jqp82jag9rMmwmKmEmYqE+R53XT+GmtwJ6nGLa7qk0JcgfqMy8fUioY+H2j/eNo84KQgV2572l7A1pzqmsqEFCTa6QbAGCjhMWv5+8cXrA0UIGV3fapnb6HNXaN2kB9I+N6yIBwAww6pm3mq09cq5AipcI8JBNI7kiU9vjrpmE1s09vSO3R05yIA++SpIaWsO4lfMLLRu90vQNqBpEMP2nUpSJTskNKsyw54beORjvq77uC6nNjZsVEwDPp0Zr39ephMEmiV1nift1O2lRjjno98fKLJ1i97+DhhuNEViBCLdPExKGILfXAf6AyQ+UWUyQdoRdPo
 Kqd4xAl1
 Osaf9sMjKaMZyIe/9kRHdDSkhK0ixZCpwUbVJEF4WK7XJRvyvo58dPSg4SZ4ecDJy/DW+ThwHysgZeUWpNEcCot0EuI0xBxl6jL941dvAVbq0VYhXmDQuiQIZzj72oi+o5gxXSQV0oXkP39y0G0/smyMARnUrn8UslQFceFMjXX8paqX/gKTmOyDGWLFzFHyg6td0Vye0OuNO7Ik6XFh+paDB+pt/aTNTPOzu5a17K0mswoQJSmgoONCJMk8YaQaMf07/RW6I+VidoPHJhk8S43IU0PXVCaVzDVIDXPc/eTpjhYu85ndXGMY0OspzVfLh83KHfuq2Uk18FohS1eyFQVrJbJclkJvAlArsfz0ViEAzTUUTHZo5I7ZcrkMQEW+YsWwMZM5b+j0AdJLRCmH4pz/Y5ZSSV7Q8ozD0qBez3caJSctk3EEIZWlSsmNJmPml5itRJCFm67PTjeygaaylgF2mg27/hE0nxADKXMFOSjU7mOIJIP0BHNZVuVT4AIhyAaLg2XU1Gw25ZAm4uYmAG38BVS1Df6E+HjpxxbeIh27s7hkDl0+gekSG6Hyw05yXnqd3u+9a3i/h2lo8dOSG6ekUl/Od7nFvu+BcS/Y8poT/4ss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a simple DMAEngine-based migrator that plugs into the page
migration copy-offload infrastructure and batch-copies folios via
DMA memcpy channels. It is intended for testing the offload plumbing
and as a template for future migrators (SDXI, multi-threaded CPU copy,
etc.).

On success, the dst folios are marked with FOLIO_CONTENT_COPIED so
__migrate_folio skips the per-folio copy. On any DMA error,
FOLIO_CONTENT_COPIED market is not set and the migration falls back
to per-folio CPU copy.

dcbm registers with reason mask with reason mask
MIGRATE_OFFLOAD_REASONS_ALLOWED, this set can be narrowed at runtime
via the reason_mask parameter.

Runtime controls are under /sys/module/dcbm/parameters/:

  offloading      - enable/disable DMA offload (0/1)
  nr_dma_chan     - max DMA channels to use (1..N)
  reason_mask     - reasons to offload: names (e.g. "compaction,demotion"),
		    "all"/"none" or raw numerical mask.
  folios_migrated - folios DMA-copied (write to reset)
  folios_failures - fallback count (write to reset)

CONFIG_DCBM_DMA selects MIGRATION_COPY_OFFLOAD so enabling the
driver pulls in the infrastructure automatically.

Channel acquisition uses dma_request_chan_by_mask(DMA_MEMCPY), which
works for providers that set DMA_PRIVATE (e.g. AMD PTDMA). Generic
mem-to-mem engines that do not set DMA_PRIVATE (e.g. SDXI) should
acquire channels via dma_find_channel(DMA_MEMCPY) or the async_tx
APIs, which can be added in a follow-up.

[Correctness Note:
 Karim: Descriptor can complete out of order for some dmaengines.
 so descriptor chaining may yield incorrect results. For correctness
 we need to add callback to every descriptor
 https://lore.kernel.org/all/20260619160725.lfcxrbj5go67qy6u@wrangler
 Shivank: device_prep_dma_memcpy_sg() would solve this.
]

Reviewed-by: Karim Manaouil <kmanaouil.dev@gmail.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 drivers/Kconfig                       |   2 +
 drivers/Makefile                      |   2 +
 drivers/migrate_offload/Kconfig       |   9 +
 drivers/migrate_offload/Makefile      |   1 +
 drivers/migrate_offload/dcbm/Makefile |   1 +
 drivers/migrate_offload/dcbm/dcbm.c   | 481 ++++++++++++++++++++++++++++++++++
 6 files changed, 496 insertions(+)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index f2bed2ddeb66..3e83a1475cbc 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -253,4 +253,6 @@ source "drivers/cdx/Kconfig"
 
 source "drivers/resctrl/Kconfig"
 
+source "drivers/migrate_offload/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 0841ea851847..88cb8e3e88df 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -42,6 +42,8 @@ obj-y				+= clk/
 # really early.
 obj-$(CONFIG_DMADEVICES)	+= dma/
 
+obj-$(CONFIG_MIGRATION_COPY_OFFLOAD)	+= migrate_offload/
+
 # SOC specific infrastructure drivers.
 obj-y				+= soc/
 obj-$(CONFIG_PM_GENERIC_DOMAINS)	+= pmdomain/
diff --git a/drivers/migrate_offload/Kconfig b/drivers/migrate_offload/Kconfig
new file mode 100644
index 000000000000..c9f2e21a95cf
--- /dev/null
+++ b/drivers/migrate_offload/Kconfig
@@ -0,0 +1,9 @@
+config DCBM_DMA
+	tristate "DMA Core Batch Migrator"
+	depends on MIGRATION && DMA_ENGINE && 64BIT
+	select MIGRATION_COPY_OFFLOAD
+	help
+	  DMA-based batch copy engine for page migration. Uses
+	  DMAEngine memcpy channels to offload folio data copies
+	  during migration. Primarily intended for testing the copy
+	  offload infrastructure.
diff --git a/drivers/migrate_offload/Makefile b/drivers/migrate_offload/Makefile
new file mode 100644
index 000000000000..9e16018beb15
--- /dev/null
+++ b/drivers/migrate_offload/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_DCBM_DMA)		+= dcbm/
diff --git a/drivers/migrate_offload/dcbm/Makefile b/drivers/migrate_offload/dcbm/Makefile
new file mode 100644
index 000000000000..56ba47cce0f1
--- /dev/null
+++ b/drivers/migrate_offload/dcbm/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_DCBM_DMA) += dcbm.o
diff --git a/drivers/migrate_offload/dcbm/dcbm.c b/drivers/migrate_offload/dcbm/dcbm.c
new file mode 100644
index 000000000000..bacbcc689171
--- /dev/null
+++ b/drivers/migrate_offload/dcbm/dcbm.c
@@ -0,0 +1,481 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * DMA Core Batch Migrator (DCBM)
+ *
+ * Uses DMAEngine memcpy channels to offload batch folio copies during
+ * page migration. Reference driver meant for testing the offload
+ * infrastructure.
+ *
+ * Copyright (C) 2024-26 Advanced Micro Devices, Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/migrate.h>
+#include <linux/migrate_copy_offload.h>
+
+#define MAX_DMA_CHANNELS	16
+
+static atomic_long_t folios_migrated;
+static atomic_long_t folios_failures;
+
+static bool offloading_enabled;
+static unsigned int nr_dma_channels = 1;
+static DEFINE_MUTEX(dcbm_mutex);
+
+struct dma_work {
+	struct dma_chan *chan;
+	struct completion done;
+	atomic_t pending;
+	struct sg_table *src_sgt;
+	struct sg_table *dst_sgt;
+	bool mapped;
+};
+
+static void dma_completion_callback(void *data)
+{
+	struct dma_work *work = data;
+
+	if (atomic_dec_and_test(&work->pending))
+		complete(&work->done);
+}
+
+static int setup_sg_tables(struct dma_work *work, struct list_head **src_pos,
+			   struct list_head **dst_pos, int nr)
+{
+	struct scatterlist *sg_src, *sg_dst;
+	struct device *dev;
+	int i, ret;
+
+	work->src_sgt = kmalloc_obj(*work->src_sgt, GFP_KERNEL);
+	if (!work->src_sgt)
+		return -ENOMEM;
+	work->dst_sgt = kmalloc_obj(*work->dst_sgt, GFP_KERNEL);
+	if (!work->dst_sgt) {
+		ret = -ENOMEM;
+		goto err_free_src;
+	}
+
+	ret = sg_alloc_table(work->src_sgt, nr, GFP_KERNEL);
+	if (ret)
+		goto err_free_dst;
+	ret = sg_alloc_table(work->dst_sgt, nr, GFP_KERNEL);
+	if (ret)
+		goto err_free_src_table;
+
+	sg_src = work->src_sgt->sgl;
+	sg_dst = work->dst_sgt->sgl;
+	for (i = 0; i < nr; i++) {
+		struct folio *src = list_entry(*src_pos, struct folio, lru);
+		struct folio *dst = list_entry(*dst_pos, struct folio, lru);
+
+		sg_set_folio(sg_src, src, folio_size(src), 0);
+		sg_set_folio(sg_dst, dst, folio_size(dst), 0);
+
+		*src_pos = (*src_pos)->next;
+		*dst_pos = (*dst_pos)->next;
+
+		if (i < nr - 1) {
+			sg_src = sg_next(sg_src);
+			sg_dst = sg_next(sg_dst);
+		}
+	}
+
+	dev = dmaengine_get_dma_device(work->chan);
+	if (!dev) {
+		ret = -ENODEV;
+		goto err_free_dst_table;
+	}
+	ret = dma_map_sgtable(dev, work->src_sgt, DMA_TO_DEVICE,
+			      DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
+	if (ret)
+		goto err_free_dst_table;
+	ret = dma_map_sgtable(dev, work->dst_sgt, DMA_FROM_DEVICE,
+			      DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
+	if (ret)
+		goto err_unmap_src;
+
+	/*
+	 * TODO: IOMMU may merge segments unevenly on the two sides, fall back
+	 * bail to CPU copy. In practice, I have not observed merging in tests.
+	 * Handling unequal nents is left for follow-up.
+	 */
+	if (work->src_sgt->nents != work->dst_sgt->nents) {
+		ret = -EINVAL;
+		goto err_unmap_dst;
+	}
+	work->mapped = true;
+	return 0;
+
+err_unmap_dst:
+	dma_unmap_sgtable(dev, work->dst_sgt, DMA_FROM_DEVICE,
+			  DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
+err_unmap_src:
+	dma_unmap_sgtable(dev, work->src_sgt, DMA_TO_DEVICE,
+			  DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
+err_free_dst_table:
+	sg_free_table(work->dst_sgt);
+err_free_src_table:
+	sg_free_table(work->src_sgt);
+err_free_dst:
+	kfree(work->dst_sgt);
+	work->dst_sgt = NULL;
+err_free_src:
+	kfree(work->src_sgt);
+	work->src_sgt = NULL;
+	return ret;
+}
+
+static void cleanup_dma_work(struct dma_work *works, int actual_channels)
+{
+	struct device *dev;
+	int i;
+
+	if (!works)
+		return;
+
+	for (i = 0; i < actual_channels; i++) {
+		if (!works[i].chan)
+			continue;
+
+		dev = dmaengine_get_dma_device(works[i].chan);
+
+		if (works[i].mapped)
+			dmaengine_terminate_sync(works[i].chan);
+
+		if (dev && works[i].mapped) {
+			if (works[i].src_sgt) {
+				dma_unmap_sgtable(dev, works[i].src_sgt,
+						  DMA_TO_DEVICE,
+						  DMA_ATTR_SKIP_CPU_SYNC |
+						  DMA_ATTR_NO_KERNEL_MAPPING);
+				sg_free_table(works[i].src_sgt);
+				kfree(works[i].src_sgt);
+			}
+			if (works[i].dst_sgt) {
+				dma_unmap_sgtable(dev, works[i].dst_sgt,
+						  DMA_FROM_DEVICE,
+						  DMA_ATTR_SKIP_CPU_SYNC |
+						  DMA_ATTR_NO_KERNEL_MAPPING);
+				sg_free_table(works[i].dst_sgt);
+				kfree(works[i].dst_sgt);
+			}
+		}
+		dma_release_channel(works[i].chan);
+	}
+	kfree(works);
+}
+
+static int submit_dma_transfers(struct dma_work *work)
+{
+	struct scatterlist *sg_src, *sg_dst;
+	struct dma_async_tx_descriptor *tx;
+	unsigned long flags = DMA_CTRL_ACK;
+	dma_cookie_t cookie;
+	int i;
+
+	atomic_set(&work->pending, 1);
+
+	sg_src = work->src_sgt->sgl;
+	sg_dst = work->dst_sgt->sgl;
+	for_each_sgtable_dma_sg(work->src_sgt, sg_src, i) {
+		if (i == work->src_sgt->nents - 1)
+			flags |= DMA_PREP_INTERRUPT;
+
+		tx = dmaengine_prep_dma_memcpy(work->chan,
+					       sg_dma_address(sg_dst),
+					       sg_dma_address(sg_src),
+					       sg_dma_len(sg_src), flags);
+		if (!tx) {
+			atomic_set(&work->pending, 0);
+			return -EIO;
+		}
+
+		if (i == work->src_sgt->nents - 1) {
+			tx->callback = dma_completion_callback;
+			tx->callback_param = work;
+		}
+
+		cookie = dmaengine_submit(tx);
+		if (dma_submit_error(cookie)) {
+			atomic_set(&work->pending, 0);
+			return -EIO;
+		}
+		sg_dst = sg_next(sg_dst);
+	}
+	return 0;
+}
+
+/**
+ * folios_copy_dma - copy a batch of folios via DMA memcpy
+ * @dst_list: destination folio list
+ * @src_list: source folio list
+ * @nr_folios: number of folios in each list
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+static int folios_copy_dma(struct list_head *dst_list,
+			   struct list_head *src_list, unsigned int nr_folios)
+{
+	struct folio *dst;
+	struct dma_work *works;
+	struct list_head *src_pos = src_list->next;
+	struct list_head *dst_pos = dst_list->next;
+	int i, folios_per_chan, ret;
+	dma_cap_mask_t mask;
+	int actual_channels = 0;
+	unsigned int max_channels;
+
+	max_channels = min3(READ_ONCE(nr_dma_channels), nr_folios,
+			    (unsigned int)MAX_DMA_CHANNELS);
+
+	works = kcalloc(max_channels, sizeof(*works), GFP_KERNEL);
+	if (!works)
+		return -ENOMEM;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_MEMCPY, mask);
+
+	for (i = 0; i < max_channels; i++) {
+		works[actual_channels].chan = dma_request_chan_by_mask(&mask);
+		if (IS_ERR(works[actual_channels].chan))
+			break;
+		init_completion(&works[actual_channels].done);
+		actual_channels++;
+	}
+
+	if (actual_channels == 0) {
+		kfree(works);
+		return -ENODEV;
+	}
+
+	for (i = 0; i < actual_channels; i++) {
+		folios_per_chan = nr_folios * (i + 1) / actual_channels -
+				(nr_folios * i) / actual_channels;
+		if (folios_per_chan == 0)
+			continue;
+
+		ret = setup_sg_tables(&works[i], &src_pos, &dst_pos,
+				      folios_per_chan);
+		if (ret)
+			goto err_cleanup;
+	}
+
+	for (i = 0; i < actual_channels; i++) {
+		if (!works[i].mapped)
+			continue;
+		ret = submit_dma_transfers(&works[i]);
+		if (ret)
+			goto err_cleanup;
+	}
+
+	for (i = 0; i < actual_channels; i++) {
+		if (atomic_read(&works[i].pending) > 0)
+			dma_async_issue_pending(works[i].chan);
+	}
+
+	for (i = 0; i < actual_channels; i++) {
+		if (atomic_read(&works[i].pending) == 0)
+			continue;
+		if (!wait_for_completion_timeout(&works[i].done,
+						 msecs_to_jiffies(10000))) {
+			ret = -ETIMEDOUT;
+			goto err_cleanup;
+		}
+	}
+
+	/*
+	 * All folios copied; mark each dst with FOLIO_CONTENT_COPIED so
+	 * __migrate_folio() skips the per-folio copy in the move phase.
+	 */
+	list_for_each_entry(dst, dst_list, lru)
+		dst->migrate_info |= FOLIO_CONTENT_COPIED;
+
+	cleanup_dma_work(works, actual_channels);
+
+	atomic_long_add(nr_folios, &folios_migrated);
+	return 0;
+
+err_cleanup:
+	pr_warn_ratelimited("dcbm: DMA copy failed (%d), falling back to CPU\n",
+			    ret);
+	cleanup_dma_work(works, actual_channels);
+
+	atomic_long_add(nr_folios, &folios_failures);
+	return ret;
+}
+
+static const struct migrator dma_migrator = {
+	.name = "DCBM",
+	.offload_copy = folios_copy_dma,
+	.owner = THIS_MODULE,
+};
+
+static unsigned long dcbm_reason_mask = MIGRATE_OFFLOAD_REASONS_ALLOWED;
+
+/* offloading: enable/disable DMA migration offload */
+static int offloading_param_set(const char *val, const struct kernel_param *kp)
+{
+	bool enable;
+	int ret;
+
+	ret = kstrtobool(val, &enable);
+	if (ret)
+		return ret;
+
+	mutex_lock(&dcbm_mutex);
+	if (enable == offloading_enabled) {
+		mutex_unlock(&dcbm_mutex);
+		return 0;
+	}
+	if (enable) {
+		ret = migrate_offload_register(&dma_migrator,
+					       READ_ONCE(dcbm_reason_mask));
+		if (ret) {
+			mutex_unlock(&dcbm_mutex);
+			return ret;
+		}
+		WRITE_ONCE(offloading_enabled, true);
+	} else {
+		migrate_offload_unregister(&dma_migrator);
+		WRITE_ONCE(offloading_enabled, false);
+	}
+	mutex_unlock(&dcbm_mutex);
+	return 0;
+}
+
+static int offloading_param_get(char *buffer, const struct kernel_param *kp)
+{
+	return sysfs_emit(buffer, "%d\n", READ_ONCE(offloading_enabled));
+}
+
+static const struct kernel_param_ops offloading_param_ops = {
+	.set = offloading_param_set,
+	.get = offloading_param_get,
+};
+module_param_cb(offloading, &offloading_param_ops, NULL, 0644);
+MODULE_PARM_DESC(offloading, "Enable DMA migration offload (0/1)");
+
+/* nr_dma_chan: max DMA channels to use per batch */
+static int nr_dma_chan_param_set(const char *val, const struct kernel_param *kp)
+{
+	unsigned int new_val;
+	int ret;
+
+	ret = kstrtouint(val, 0, &new_val);
+	if (ret)
+		return ret;
+	if (new_val < 1 || new_val > MAX_DMA_CHANNELS)
+		return -EINVAL;
+
+	mutex_lock(&dcbm_mutex);
+	WRITE_ONCE(nr_dma_channels, new_val);
+	mutex_unlock(&dcbm_mutex);
+	return 0;
+}
+
+static int nr_dma_chan_param_get(char *buffer, const struct kernel_param *kp)
+{
+	return sysfs_emit(buffer, "%u\n", READ_ONCE(nr_dma_channels));
+}
+
+static const struct kernel_param_ops nr_dma_chan_param_ops = {
+	.set = nr_dma_chan_param_set,
+	.get = nr_dma_chan_param_get,
+};
+module_param_cb(nr_dma_chan, &nr_dma_chan_param_ops, NULL, 0644);
+MODULE_PARM_DESC(nr_dma_chan, "Max DMA channels to use (1..16)");
+
+/* reason_mask: set of MR_* reasons this migrator handles */
+static int reason_mask_param_set(const char *val, const struct kernel_param *kp)
+{
+	unsigned long mask;
+	int ret;
+
+	ret = migrate_offload_reason_mask_parse(val, &mask);
+	if (ret)
+		return ret;
+
+	mutex_lock(&dcbm_mutex);
+	WRITE_ONCE(dcbm_reason_mask, mask);
+	if (offloading_enabled)
+		migrate_offload_set_reason_mask(&dma_migrator, mask);
+	mutex_unlock(&dcbm_mutex);
+	return 0;
+}
+
+static int reason_mask_param_get(char *buffer, const struct kernel_param *kp)
+{
+	return migrate_offload_reason_mask_format(buffer, READ_ONCE(dcbm_reason_mask));
+}
+
+static const struct kernel_param_ops reason_mask_param_ops = {
+	.set = reason_mask_param_set,
+	.get = reason_mask_param_get,
+};
+module_param_cb(reason_mask, &reason_mask_param_ops, NULL, 0644);
+MODULE_PARM_DESC(reason_mask,
+		 "Reasons to offload: comma-separated names (e.g. compaction,demotion), 'all', 'none', or a raw hex mask");
+
+/* folios_migrated / folios_failures: counters; any write resets to 0 */
+static int folios_migrated_param_set(const char *val, const struct kernel_param *kp)
+{
+	atomic_long_set(&folios_migrated, 0);
+	return 0;
+}
+
+static int folios_migrated_param_get(char *buffer, const struct kernel_param *kp)
+{
+	return sysfs_emit(buffer, "%ld\n", atomic_long_read(&folios_migrated));
+}
+
+static const struct kernel_param_ops folios_migrated_param_ops = {
+	.set = folios_migrated_param_set,
+	.get = folios_migrated_param_get,
+};
+module_param_cb(folios_migrated, &folios_migrated_param_ops, NULL, 0644);
+MODULE_PARM_DESC(folios_migrated, "Folios DMA-copied (write to reset)");
+
+static int folios_failures_param_set(const char *val, const struct kernel_param *kp)
+{
+	atomic_long_set(&folios_failures, 0);
+	return 0;
+}
+
+static int folios_failures_param_get(char *buffer, const struct kernel_param *kp)
+{
+	return sysfs_emit(buffer, "%ld\n", atomic_long_read(&folios_failures));
+}
+
+static const struct kernel_param_ops folios_failures_param_ops = {
+	.set = folios_failures_param_set,
+	.get = folios_failures_param_get,
+};
+module_param_cb(folios_failures, &folios_failures_param_ops, NULL, 0644);
+MODULE_PARM_DESC(folios_failures, "DMA-copy failure count (write to reset)");
+
+static int __init dcbm_init(void)
+{
+	pr_info("dcbm: DMA Core Batch Migrator initialized\n");
+	return 0;
+}
+
+static void __exit dcbm_exit(void)
+{
+	mutex_lock(&dcbm_mutex);
+	if (offloading_enabled) {
+		migrate_offload_unregister(&dma_migrator);
+		offloading_enabled = false;
+	}
+	mutex_unlock(&dcbm_mutex);
+
+	pr_info("dcbm: DMA Core Batch Migrator unloaded\n");
+}
+
+module_init(dcbm_init);
+module_exit(dcbm_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Shivank Garg");
+MODULE_DESCRIPTION("DMA Core Batch Migrator");

-- 
2.43.0


