Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5C14C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2F26B0099; Thu, 24 Sep 2026 02:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8A7D6B009B; Thu, 24 Sep 2026 02:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F616B009D; Thu, 24 Sep 2026 02:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81C576B0099
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:37:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDB99140283
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:37:42 +0000 (UTC)
X-FDA: 85247699964.11.B6CBDEB
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010016.outbound.protection.outlook.com [52.101.56.16])
	by imf24.hostedemail.com (Postfix) with ESMTP id E80AD180004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:37:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gmgslRry;
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 52.101.56.16 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790231860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2cuHss1f5nj2E2L2f3iB/jediY0K3vNyJk5p/GIhpXo=;
	b=uEpWQrhaqtsEQsW9smNsRR/noUnzW7gzoz29C2uhOxEDqibR/vNDbvmHxA5XfiRUag97UF
	3B4Ds1brRC2N1StHzvwql0f7LsFT1LxWRdf/HHMU8O5iRngYS/OfWzw2lAmj98qvM7udka
	FFzbkBo07i7FgSmvVI7Rk8ciqH3XEVQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790231860;
	b=bwhKgOevDNQ7m1HfhroGgwVJALGqUUpNGXFPM6MI1n7u0d1drmFPrPJrPjwnF2T/ocpE3H
	tlMkU4STrf1oHMgTLdvPIdoapmq4xHQTm1m3syTS/h9gwmBoxYZaAWcFjXlI8CIhMnWO1p
	/BDC0CNQQHLUGx4Ge2btSTc7He36FHw=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gmgslRry;
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 52.101.56.16 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NDTlwm1MtxBvmoQ7VH9SJQY2iXoIg3qxtwv6EGLRH0eTaWzC3zWHlwpwhYyhTg19y6TWJ/z1fg4dqkyiBJWDdZ4IYhrSHUEUGfgOTK5Ipb7RN3Gx1mGzGRxnTmnHnmpWBiMi2hgpxIqG4DvzTDzQIeeLSJWH0mJhCEQF4P2CFRKsMP2G0EIPr01tqyDx6EjVkUz19+8QoXR9sMyoE0mvrkRAoaIeO80EqyRr+ItjhDXNX4svxeMDAze+BiTeurctA0BEn37EcNyWDbm06FTQKtMSOi388BXB35R5VmrIC9Ei8kLC7QxsjoLhlOIKaspeJXXKm0ngya/7V2Le4FtYbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cuHss1f5nj2E2L2f3iB/jediY0K3vNyJk5p/GIhpXo=;
 b=d6IfvuchQ9O+N/FiQJVImvJ9/ZvEZW2PwJRvH3/t4DmQPg5A4DXdZtCn3Irkzdt+YjYihIRZLEYIXNJsiKMM/z1e59m+RgUxYE8Nz1eP8IYq7eB0Jw9YlTambZqIzNZXt9ML0N2PIE9hahX3mrzxmxdt2ATPgZylPSNwLWKElYsLW8wzX36BfzZQpXKmGufOmCQ2yjXPY6S/zgMHh3nkD3eJCLRPiniKaX5ubGFU+SIr8H7u5MD6Dgf4ofk2ddb8mz9M5MVE5/3dOdmpzIYvu56N06rLtNf8LEW6XLnm1PLkjG0fB2KsFt/T3C2bjPJ7Ft7aYPDRwqYo961E8hkACg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cuHss1f5nj2E2L2f3iB/jediY0K3vNyJk5p/GIhpXo=;
 b=gmgslRry3t4KMiIU7DC69ZWFvSPDumos5/O1iYY6wA4w07QFysxUmgqOy1Oau3tdyeUn5X5mz0tlb8mJukuoIG5dx2Q9PuccMVTIuqhrDpghjph+5SjYaj+ukhAY5Ro1aRlwDiMqCeOCRE6fGJXAjpO9jPlXSfJZdk0xsIzPtZI=
Received: from BN9P222CA0030.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::35)
 by CHAPR12MB999248.namprd12.prod.outlook.com (2603:10b6:610:2ff::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 06:37:35 +0000
Received: from BN7PEPF000000A1.namprd04.prod.outlook.com
 (2603:10b6:408:10c:cafe::8b) by BN9P222CA0030.outlook.office365.com
 (2603:10b6:408:10c::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.16 via Frontend Transport; Thu,
 24 Sep 2026 06:37:35 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN7PEPF000000A1.mail.protection.outlook.com (10.167.248.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 24 Sep 2026 06:37:35 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 24 Sep
 2026 01:37:34 -0500
Received: from [192.168.0.152] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 24 Sep 2026 01:37:26 -0500
Message-ID: <61cf8070-008b-4909-8b20-e138d3b33289@amd.com>
Date: Thu, 24 Sep 2026 12:07:20 +0530
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000A1:EE_|CHAPR12MB999248:EE_
X-MS-Office365-Filtering-Correlation-Id: 35470ac9-8dad-414b-8145-08df1a0651ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|1800799024|7416014|82310400026|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HEhchYiFyQ4LeculKYX7/9WrZh0wtWZfBuont917UT0OHmDTzWla2yp3njj1Ev++AS+t5qY5u9SqWS7fCoq6aEdhh2umYj/Zvp7iNmfI1adBwO9JFbIk7x3IDua9ZTHSxVWX13CKNGXblWjiQ52s1wDnE+dyT7ShA42cUGPzk/Lnr0pwaoRfYffpegJlgx+YMc7ISPKFRDBr6ZHJft1t7dQXeYvTSCB1yrKZCgJZSNrA3/srUV3VGTaSRylc3yXc/GGGKeWXlannVnVi8Z74m6iMg5HkxgmD6+fG0ID4LJI7ryLu4dRZfSN8jo9luMJNjMFQwJf9tRSTGr9iNeLST/UDCNsWiNFzCtglom21guzx0WNC8pytECrvfACkc2n15Q83Y6uevP0oqqoFuGwMv7UNFehkim3LM8IXX01zPWRk0in3wj2tzBXfN7xB0BtKC+AcW3po81/179e476dyC4EtY7TRUsjuAbQXmEDKamQIbeu8ssmtPS+jjCasVijnn0gsCtrfuf/NS6PrQa6t/nd0J08fRM7RDkIoHkHvcFh6OZLK8+3JDZhCNpF1sqXlAW0C3eY7agaMiexps/QH7nJNO36ESdgtlhcO28oYnQJSjQlj1AlYzHlK/nokv7Y9yGrmSjYvlyfzEB8Ri6RWM2Kdl0TTCSt62wO6kkfH5PzdQbG3n8dHlt2uv2ahJa7Q5iSMv1EKkGKnMFkUBJSU6g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(1800799024)(7416014)(82310400026)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aupPwZ5vrl+MWfxqNAqku/eMLHs8gzRFqRvMNvLVhiHvvJPtaVzr+z6lvYie7p9MHXOrgiU8PP+a0VxguQhbbWU+Us5ddaH9tGTECFI/vZLRk38g2V11LfDhEPUO7EfMU00ypx4Nbk/dwc4Kb2TQhL4WnZMRvcg3LcLzJtmOWTq4te4J3HpMVKOIquFDxJz9BcB8+/52yJK2PwWdRX7bpBNiUmn55IFZp3he9hN5p6ASXRI+z839cbY97uMXNk8QHKxxTNFdre1Yy+Q1MbYV+IYft1LGZbTYlrQny0inVK0maufEmWg2Aq7fT2+v+DK2D72y5g0CpkOmRQoE6rLvbWXUvNmSgMqB9DCuRHPQqhOLaG8vCncF056Imf9yBou1A0SONxV6e2wipkh4hIvBaWOmfgDvF54O9yVMN4HUfk6TN4F2o3MdZwSmHlsEIXtZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 06:37:35.4132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35470ac9-8dad-414b-8145-08df1a0651ce
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000A1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR12MB999248
X-Rspam-User: 
X-Stat-Signature: ke3rif4jra1fickyuchjm6xpm7m8yk3j
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E80AD180004
X-HE-Tag: 1790231859-418654
X-HE-Meta: U2FsdGVkX19GHT4hiZDy2VHpAHsfKP+AqJGPItUAzzt8ih1kp3WallWdXsD8ADgAikwXJQ7jVYzvmJ5oMk8rGU7X8M3XS8ZlGi+hbC3cQW9uSN+mTIze15wA5W8TYfyf5xXiwsKQoOk4EuRhJNJfPnlP4aJiMKdGiUKhuhYlnJAAovdlH6NFQ1cBklS1gMo/quB2wwEzthT5F0c4zKo/O3L/IBqUTTuW1NrLmH/+3HqUX8JSSJ4QMWiFW+xJUz9lfrHWL4V7eDRbzeQsIJ1Whw5VkTPiBJvlqlPaEGw0lSKk4pUFB+VbiAvzQIvpVn4eg8xJyEWT3Rkr00e1j1S8Sb3PcjGewHQILcrWJwul+oCeJqfqTchD7XzDjH/oXD3llbD3Pj7VxAq71tEe+BfCPEBa6+HvOQQtYDyeGH399nuLK6Lgb4LAaJtmOWJuYsfasiFyrDxt6v0bJNljai2irEqq3f73+vZAL/Wt3WbQj/V1m31ai/P1O71uEQVFESdRcG3NLupfzHb2OAfD2nc/jixKH75uTBxPM59AmadEMg2xUMKc6tvjs7Aoyur7IFLB8JDyqDcwAoH7vkua/uo/1c3OUPBNRtxpZd4Nr/GLSMJzA16EYJbdoNQSjbdwynB4porDCS8+4n0OyNKvlwEuTOa30K3FsIPpf+YFibkcYCj1QVP5de3nf/XtrR4F8YMwD7RRta0UtwSQC+vEme9CdTSgv08E5/ZQmrtl2QAg3Xd4tQzggIs0ZiuUzM0oXQ+nv0FlyfH/PYaJAfGYpOZ2C3ykWR0SNFP9jJv9Aa/yeGO1mRJ83XL0DzWsrtK/jAV2jio4H023WvC6//8NmsRz87vnhD6zSjNxPTOWFkIEBCI8Vt7pjFtvmfyUv+yIQzKCgxKhY2xr+FHtmiCwaSFBsFvqgXSZWJgFUxf/jgVZAPYCBNFqzGAzcs1rGYwFEJ17wmc7QCuLn9PM/zyo+Zr
 rjFCQwRn
 skZXbIj7/J2999RmzOHx/Gcku2pd6TcyNtwQxkogHkTCnvdOuGF/Akd28DlCsHLaadccR+n7kbdKuM8XsqoP2EMhZR0WN7bUOM3CM8o6mDG0ku6I6pJcadV2NwxsxjG2Mn/BjTfnWPdSSCIAXjo1yF5X3TqGCnTnDTafwamx/FvMhN4icEQHwTcUCledmoFI13uO6aBfKBNjDvO5hOxMs3GtgN7BOiXQnnELu5QgYBHm48MWUDNMhMluowLTiKLkaW5RXAYwWcqaeleDaq91Rker9xNm49wY9lSAJA8Iq28IZ5APSFn2WDP+FVo7eItGenDaL9WVa+i7J3nQECfb8huHF4lQDWzu1EVDRjz95FURxJQULfTNWTfPcnoFF6ViBfukjnazXtBu8cpbxj9221zsDMt8xrzt3mWyMxh6aT2MzgyicYRHqljf13AbIOBtTW/zrEGXtge3SJaNdlGSdUNY/gNWEaumz3QWCujXTMtqBZ8s=
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
==========================================================================
Redis + memtier: hot-page promotion on a CXL-tiered system
==========================================================================

Benchmark: an in-memory Redis server is loaded with a ~64 GB dataset
(62.2M keys x 1 KB) whose pages are then explicitly migrated to the CXL
node (lower tier); the Redis server and the memtier client run on a top-
tier DRAM node (node 1).  The measurement phase drives GET traffic with
memtier (16 threads x 100 conns, PASSES=12) over 50% of the keyspace so
that repeatedly-accessed lower-tier pages become promotion candidates.
Promotions target node 1 (local to the accessing threads): NUMAB uses
the accessing node, pghot uses pghot_target_nid=1.

System : AMD Zen6. Nodes 0,1 = DRAM (top tier);
         node 2 = CXL (lower tier).  Redis/client pinned to node 1.
Kernels: base=7.3.0-rc2-base+  pghot=7.3.0-rc2-pghot+

Cases:
  C1 base/NUMAB0      base kernel, promotion OFF (baseline)
  C2 base/NUMAB2      base kernel, NUMAB tiering promotion (hint
                      faults); promotes to local accessing node
  C3 pghot/hwhints-10k  pghot, NUMAB=0, source=IBS mprof,
                      period=10000, freq_thr=1, target_nid=1
  C4 pghot/hwhints-5k   as C3 but IBS period=5008 (kernel min,
                      ~2x sampling; 5008)

==========================================================================
Table 1: Benchmark metrics (memtier)
==========================================================================
Case                   Ops/sec   vs C1     Avg     p50     p99   p99.9
                                                           latency (ms) ->
----------------------------------------------------------------------
C1 base/NUMAB0         285,288     ref  179.46  177.15  344.06  358.40
C2 base/NUMAB2         295,475  +3.57%  173.18  168.96  325.63  364.54
C3 pghot/hwhints-10k   285,923  +0.22%  178.91  177.15  344.06  358.40
C4 pghot/hwhints-5k    285,290  +0.00%  179.24  177.15  346.11  358.40
----------------------------------------------------------------------

==========================================================================
Table 2: Page-migration / hotness metrics (vmstat delta)
==========================================================================
Legend: C1=base/NUMAB0  C2=base/NUMAB2  C3=hwhints p=10000
        C4=hwhints p=5008  (both hwhints: target_nid=1)
        ('-' = counter not present on base kernel)

metric                       C1          C2         C3         C4
-----------------------------------------------------------------
pgpromote_success             0  10,433,506    575,010  1,107,371
numa_pte_updates              0  20,333,730          0          0
numa_hint_faults              0  10,433,506          0          0
numa_pages_migrated           0  10,433,506    575,006  1,107,369
pgmigrate_success             0  10,433,506    575,006  1,107,369
pghot_recorded_accesses       -           -    575,677  1,110,760
pghot_reported_hwhints        -           -    964,304  1,967,044
hwhint_total_events           -           -    964,324  1,967,078
hwhint_dram_accesses          -           -    388,027    854,679
hwhint_extmem_accesses        -           -    575,674  1,110,758
hwhint_useful_events          -           -    964,304  1,967,044
pgdemote_kswapd               0           0          0          0
-----------------------------------------------------------------

==========================================================================
Key observations
==========================================================================
1. NUMAB tiering promotion (C2) helps only marginally: 295,475 vs 285,288
ops/sec (+3.57%), avg latency 179.5 -> 173.2 ms, promoting the full hot set
(10.43M pages / ~39.8 GiB) to the local node.

2. pghot with the IBS hwhints source is flat vs baseline at both periods
(C3 +0.22%, C4 +0.00%). numa_pte_updates / numa_hint_faults are
0 (no NUMA balancing); promotion is purely hardware-sample driven.

3. Sampling density scales promotion linearly (period 10000 -> 5008
doubles reported hwhints 964,304 -> 1,967,044 and promotions 575,010 ->
1,107,371 pages, ~2.19 -> ~4.22 GiB); ext-mem/CXL samples map ~1:1 to
promotions (freq_threshold=1), dram/already-toptier samples are not
promotable.

4. But even ~4.22 GiB is only ~10% of the ~40 GiB hot set, so throughput
does not move.  Unlike C2 (which promotes the whole hot set), sampling-
based hwhints at these periods covers too little of the working set within
the run.  Reaching C2's gain needs far denser sampling and/or a longer run
so hwhints promotes a large fraction of the hot set.

