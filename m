Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10157C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 06:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E60B6B0088; Tue, 28 Jul 2026 02:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096166B008A; Tue, 28 Jul 2026 02:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEE526B008C; Tue, 28 Jul 2026 02:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B44C66B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:12:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44EC8A1200
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:12:15 +0000 (UTC)
X-FDA: 85037165430.03.2314293
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2BF7B180004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:12:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=CBRLYpR0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 52.101.62.46 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785219132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCe86Ncxxdq8N61Vt4xUqG7Zx7q+SUgG1AlCcafpuPQ=;
	b=PwAirYoXx0iX9TEkvlr3b9yp4DqFbKG9t0fq2/tXnqhYzLg9CRH6jAPIfgbEhLT9hLjNyo
	6cagHbJJHCa5XiB8jrqT47BatSIiu2eAXl3tqui2gJy15w5P9dcJHHw49x9sQlbe7AKpRU
	4U5LwM6p5/o3Xbe2nM2vw5jpI2W8L2Y=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=CBRLYpR0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 52.101.62.46 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785219132;
	b=QU62M9f3uQV8BOQ11gnsx5kt9557lOZBlxM8kFKxCpF1fhGq4dF8OuX6cpIi4Wmte1gWDf
	o1Z9Ortvv8wu+8/bC90c1tDG9jTB3ZHn3mRDO8OPQmN17QT9hWig54V0W2dXhCevV3UexL
	nRBSHLrMjYb7R/WM4TLEgEwDP1p3NVk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vHeQHesXvQ0VfWsJaILN1NW4zrUdfr1JVvR22uUSl12CGHA3U3h3yXdFh3J2S3KliuU1sgDAkg4ju8W1zz96FMzIwdYOP+/Xn9JDJdMIiXw6X4M/Mxu2ucjpay3iotkZdbjqn8dBMkU0ekg312AH7qV+kIHiOwQWjCOFjalfpkm5gHEVFsIAV8VJiC+I4wOOmbrXKPZB4RRwsGUx+s/j94Xbre/wDgSGDX1VCOMavyoR2XrKdVNX0veUJZT7/DBy3FEKs057k99rqho7dPs/hC54Ik+8vIrzUoV/KoEyUemiJKB5NkhTdrIaeOczYOS/K5hlet7IgbAZKLHP/l2qPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XCe86Ncxxdq8N61Vt4xUqG7Zx7q+SUgG1AlCcafpuPQ=;
 b=iCG4g7chgqNwwUsGWtebed1or6r32tkAgQrDEA8tGcWKB87snswxxI3iw7vGtXf+CtH36GfmxrEsQTS2aJrkK2dJHVNHPu/v6qCefRXmdkgifAQwAwN6lTk6GGFhEvjoaMaiZkOvMII0/36ji365lofMgiTWrB/Nsa6bFjsUuRuPVojyJWUYnWKVkV5l6swOnjWjN3qdev5sYNOxoA3SVpJDCc61ie3UUb2Z6pV1fa7nRorJm7pdfRMlPHYMnjhPzKQX4MUq463XCqIOBgcZLHKUw7JXghJVl8nlJHxYwiFmj7VornwZmWKzcMFF1kYl+7MR+0aTvfGscXUYHmPkXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCe86Ncxxdq8N61Vt4xUqG7Zx7q+SUgG1AlCcafpuPQ=;
 b=CBRLYpR0pr3CsI5d5Gv9lM0JNuO3lEZEnfVbw1d/SLMAemfUfai38uI+80mHawshsQ36IoMcHPjjOHslPFaQHJ0qupeKfB37K35WerVoN47L/wv4YJMZQliTyxaN/C36YctWA5O61ayiL3zdvoM5gqmbv+cOeXACRADBdIC4XoE=
Received: from BL1PR13CA0442.namprd13.prod.outlook.com (2603:10b6:208:2c3::27)
 by PH7PR12MB7235.namprd12.prod.outlook.com (2603:10b6:510:206::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 06:12:06 +0000
Received: from BL6PEPF0001AB4E.namprd04.prod.outlook.com
 (2603:10b6:208:2c3:cafe::a2) by BL1PR13CA0442.outlook.office365.com
 (2603:10b6:208:2c3::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Tue,
 28 Jul 2026 06:12:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB4E.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 06:12:06 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 01:11:56 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 01:05:25 -0500
Received: from [10.136.47.225] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 28 Jul 2026 01:05:18 -0500
Message-ID: <1ff51d91-f4bd-49f7-9f88-323fa33c6087@amd.com>
Date: Tue, 28 Jul 2026 11:35:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
 - redis-memtier
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
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260728054356.291998-1-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4E:EE_|PH7PR12MB7235:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ef0cfdb-07c8-460a-5489-08deec6f26b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700016|23010399003|7416014|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kCgDuNAK7R3Ru/BNGYLfTJe8ZuW5Dhhn8ha+4T3E4LhvX1m5HAGRDKbEwS43skzXSQJU5s1SMWQwKpnPRtPDrXF90ngVpEvLPR3M+9+oonf7a3XnQ3VXrsnDvzDZrN9V0g/kfWChcC/iijQTwzjSjzPBtZeEjq2EZfTxlNQMQMpVhIUe6QlTZRhlNJXxuTUw0W4NcLIaDrZhwVY6/ikV5HFUXCAnkGehY2BSeAaOZK1iJHvJVwkbfksrAGqNwrk4RGxoR7QAJNzfEL0yp/Bc20h2tuaH+LpuACzDskTqftpEXrc1X/ggNISFMJ/M0b+xNZPwN8Byr/Uw7bomylxorYI3/mx0Gyr51UvZX1C2rKBy0fYOodEMsAUAFR1lfSI3q0phfibt8khr800PTFz59s2RcBX96C0vz+f+XKCpqw/KO9+sLMDiPv0qTYlyr0DMzc8m+wCOvWHDcB8KicK+jlqBexKMaQIrz7TTcAbNvlCax04rzy6bKU4bmfZX5GUadqh70WBHHHUPWHUDf/jkymDikOcTyf7rENLFkYxN3uYj1e2pe/rOHisbcxjr4dmFD759EFsHBWBBN1ewDQIiSkLJhLpsxNGpW42y5RtovueMP6O/KCa0UIyYd0dR8aQrLJ6ZRGHpiILoFoSbrOUDHCOjeW8cjQI5C0yOOgNpNZsKOnBmCWAnPI8uav25O8BgKZh5ZyLRa+P3JtFvAPDpaw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700016)(23010399003)(7416014)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RYdh8o+BL8azqF1loscJsN562kQHrJ0CpR0uvwK0gkz+mVWM3FMcOaLiIkK5TXVSpRYV1RwSduX2KMOHkm64qMPsXS4Bbj8kpahZz8qgV5X+FG2wMNNGlmh9wGoG0ST/3hU2tSX3MiFU/7kM5L1HaU2RxWiZNwYmEYT3Zxx+HFEhYjoN7vOpp9UaWO4Iq4zghR8kVSe2Ra3eNz4z5WBHl4GgOsUhVhmd2PuHuMwUad5xDJR0rvezuV25YLEAYnkuaRGQlwSAhzany9fLjKxe2S0mrwiKniZsCbMaWyF+Lx9AyaZW09GWoveUSjwK/3lMC7FQOZ5WGVZUnPa4GUveALtUrJFdm7+7M1PTYpH14kCRDTFuPs2gan9ot4uDOsLmXv0kCiy8SDZvggTO2HxAiODZd9Xc4gA25G0yOXrrw1fMWj036koeAZlIVMEm2V5L
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 06:12:06.7647
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef0cfdb-07c8-460a-5489-08deec6f26b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7235
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BF7B180004
X-Rspamd-Server: rspam01
X-Stat-Signature: wxdtysow3s64bi45m6fq6o8uzzn361eh
X-HE-Tag: 1785219132-895401
X-HE-Meta: U2FsdGVkX19Pd8KhkgywY7HCwmKHxORgolqF3YAl/l/cnEOpG20Uqemy2/PJ+Wocw+EMDzMGxcySI+tuXoTqbBUfmY6zGVInE2EhPF1Yj7KgOyv0OeoSz8kZ70fH7rHqvM4+ac+JHvrAxNXWXy3S+p/vjp6NvYB1kvryHo6jqCkagkz0NuJPT/WpdoXFrchGXGqXp+wIgp+I37s5Qcb5Z/Kz7Rvkm5M60Zywd9BuPrCx/SYlRBd9jAxkCjIDQbtMs3dajbMIOLLyMVFYoeXNTCsqk9B7juD3V9yonVoarQ5hvUo32eF2jQRiVMHHvvL5pscmn2m98QxtYSyryDEnpThxekm3+THaBgSuznLbNipVUVoxSyWS5IP6KzhILmpL22ZIzsY02LgKN3YbTKrq2ZTERUXJXVtWpsY1PDSTQZDj+otgXToqNp0buEIsXipqatdzTLU5Hw4xzYbqEqUQ+utWT0HBTVjlfGKlNQvWDceOswn4fvy61knLmbzzMYK4GHFefsrMzlHtG96pPWrnBz7yI4H1wUEZTNOd9POsn02OXJ/R25B7e529bxgrMdBKt6xzRQ4ZmW3/kV7XjCwEhfqlxUDauLrge65UWCZbTJyxE5BdizbtoNwDPdNeWn2hkxNaxNpUSXPP4xC30x29AXewbovpj1CcmJIDc31NWXHFQBTneh7hk+01zEmlp4VBl9sBC/Qg+IOGE+7yrhw0IS1+gMzVV4lupSerU4WJIFppo8W+aWM5aR3w3xujUnEe1bDbDVY+keQ+nDdFLl0Mg9/MNNYiBxAWdqqgW7QRk/wMuVKkPJePOh5aPFKQ6KK2nZe90sNWGXB8cChCCJTc8pQo3BqeswjM32A60EHjUHJtTOElF5H3hftI380NpOD0p6s8QqbObOrtqyHNDBRkujRolgLoz4kimHhczMY88+Hgn7uRiXnHwmuRBUyPNikp1Y8m6hiGMrmyvbtHoZU
 oA0zoGLg
 viFViVChTFbzUndC2HGp7502WtexiPDr/hHa49nFxPGSVShgkBujXzZGsWd96N/Je8F0sEZtQuPLesv7FsiW2DoZ93tnmoIgJuYztOc8suBifo924CT3ixZY01gIhbT9zAe70zOjuRc6w5fKyJmsuHPv5ltWb1L4Dqggy0dRh/HtDFri4KgD34fu4kKSHD8sUaQA0hQPX0hOHpuqzGe29Q/KYm7mxcdMr3Bp2LQWn+pSbZkQYY48TV9v9niusBpbOpTdZt6vvqLNOvrG08A9+jNmOQ77u5QSuv9+SEosgE+ty/lz3A/3g/gBCr6Qvylj3+Dq4/nvFg+lkQ2zSVGlp92HafjbL+Wrql7wVIt/uXyndmzRjr9uTeR61GlmVp3pAZhbi09d1L10eA5O706iSb4G9W54GFNMR1wdFbaUhbwf9j3iwQI/EX0G2Vyx6CYg0ju6s31CangblVMZqTZCcXuDYmlmz82VMRGtaPx2CcWfLBEI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Redis-memtier

In-memory Redis server is loaded with a ~64 GB dataset
(62.2M keys x 1 KB) whose pages are then explicitly migrated to the CXL
node (lower tier), while the Redis server and the memtier client run on a
top-tier DRAM node.  The measurement phase drives GET traffic with
memtier (16 threads x 100 conns, PASSES=12) over 50% of the keyspace so
that repeatedly-accessed lower-tier pages become promotion candidates.
We compare throughput/latency and the kernel promotion activity across
the base kernel and the pghot kernel, and across hotness sources (NUMA-
balancing hint faults vs. the IBS hardware memory profiler).

System: AMD Zen6, Nodes 0,1 = DRAM (top tier); node 2 = CXL (lower tier).

Cases:
  C1 base/NUMAB0     base kernel, promotion OFF (baseline)
  C2 base/NUMAB2     base kernel, NUMAB tiering promotion ON
  C3 pghot/NUMAB2    pghot kernel, promotion via pghot, source =
                     NUMA hint faults (kmigrated batched migration)
  C4 pghot/IBS-10000 pghot, source = IBS profiler (period 10000), NUMAB=0
  C5 pghot/IBS-5000  same as C4 but IBS period=5000 (2x sampling)

=========================================================================
Table 1: Benchmark metrics (memtier)
=========================================================================
Case               NUMAB   Ops/sec  vs base    Avg    p50    p99   p99.9
                                                          latency (ms) ->
------------------------------------------------------------------------
C1 base/NUMAB0         0   281,424      ref 181.62 180.22 348.16  362.50
C2 base/NUMAB2         2   295,551    +5.0% 173.18 168.96 307.20  354.30
C3 pghot/NUMAB2        2   296,269    +5.3% 172.42 169.98 327.68  364.54
C4 pghot/IBS-10000     0   281,645    +0.1% 181.67 179.20 350.21  362.50
C5 pghot/IBS-5000      0   281,665    +0.1% 181.72 180.22 348.16  362.50
------------------------------------------------------------------------

=========================================================================
Table 2: Page-migration metrics (vmstat delta over measurement)
=========================================================================
Legend: C1=base/NUMAB0  C2=base/NUMAB2  C3=pghot/NUMAB2
        C4=pghot/IBS-10000  C5=pghot/IBS-5000  ('-'=counter absent)

metric                       C1         C2         C3        C4        C5
-------------------------------------------------------------------------
pgpromote_success             0 10,433,576 10,433,484   594,762 1,128,469
pgpromote_candidate_nrl       0 10,433,576 10,433,484   594,762 1,128,469
numa_pte_updates              0 20,333,714 20,344,211         0         0
numa_hint_faults              0 10,433,576 10,433,533         0         0
numa_pages_migrated           0 10,433,576 10,433,484   594,762 1,128,463
pgmigrate_success             0 10,433,576 10,433,484   594,762 1,128,463
pghot_recorded_accesses       -          - 10,433,533   595,426 1,130,753
pghot_recorded_hintfaults     -          - 10,433,533         0         0
pghot_recorded_hwhints        -          -          0 1,000,187 2,026,558
pgdemote_kswapd               0          0          0         0         0
-------------------------------------------------------------------------

=========================================================================
Key observations
=========================================================================
1. Promotion helps this workload: enabling NUMAB tiering promotion lifts
   throughput from 281,424 to 295,551 ops/sec (+5.0%) and cuts average
   latency 181.6 -> 173.2 ms.
2. pghot-hintfault has no regression vs base as it matches the base tiering
   case.
3. pghot-hwhint sources promotes far fewer pages than hint faults and it
   barely shows any improvement over base notier case.
4. Halving the period (10000->5000) ~doubles hw hints (1.00M->2.03M) and
   promotions (0.59M->1.13M) as expected, but is still far short of the
   hot set, so throughput does not yet move.

