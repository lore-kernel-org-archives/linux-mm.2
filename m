Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0BDDC98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02DFE6B008A; Thu, 24 Sep 2026 02:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21596B008C; Thu, 24 Sep 2026 02:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE93C6B00A7; Thu, 24 Sep 2026 02:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBD546B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:28:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA50380279
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:28:13 +0000 (UTC)
X-FDA: 85247676066.10.BA0BAB4
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013047.outbound.protection.outlook.com [40.93.201.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB65220005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:28:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="2QdRo/zq";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of bharata@amd.com designates 40.93.201.47 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790231290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZaSENzKd//RH+srTSkCCPMOZioF7KPEZ2kojACm+jiA=;
	b=I9/Dg+v+kYoA+jHlzADhhhQWpXEwqdsBPkGDfJcXtVG6lnXPMay0pNEAqbjgIw0jH8MIPI
	OUYIAaNb527hR6Z1l4jyoBmBTk0kmsYMg6C6tTi5LyS5AIZtd3FmKKbOz88q1Rs/rVDLl6
	1w5vKY/HpAWu1mbswp8DJdZNZyRT82c=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="2QdRo/zq";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of bharata@amd.com designates 40.93.201.47 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790231290;
	b=luTOtAqo4/HKfBWrHrFRXW3bjHGVhlUo6ZWNgSLK8zuL9IUNszRSyk3QJ4zVXm3FWm99K6
	/9C7w96OqKweYXd4PlqX0Jpy3j1Xypg4wSFCrr0aQQa5t2PiSZwpwc7cyKJrFxJ2/WozGU
	k1Rvzgo1nDSQo8nkPc8NDdTzHiqzEKs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vLvxLqQQLsy8MB0Z7Col0d5DpIW1edhO34qACXPAoreTPewaiRIdbVOlo9FSF3U1tLvLLzeb3Gker8dJhPKJu0fizbgg5xRDzavdRNolOet/AkWYCbQtOvZRIqyJWAyUwwxCNtilIFpyzpEPCiwUaw0W7naQNw6O3BVoIZ/1mhvJCp2ZJIjtz/Z6HdafunKnjh1KwUY8P3TsCvpGLHkPJ/S5XU23oJoi66TXHT8/6bkrTo5Ur7gbATJAnvlW8N4XLwgRYSal/5LtwmurSmQJBgNdfnPjlicKh1UX5k7ewxy8bsb0dqxVndavPfWbT/5SWtm9Y+g5jT+8NZx0EQ9oHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaSENzKd//RH+srTSkCCPMOZioF7KPEZ2kojACm+jiA=;
 b=NTF1+CTVFeF6SfZ8YoFX3q3Lcy2NVjjZTzSFbrY76jnWM9o3BwJXSeUZ/BWnT5snbChkC2Fe/QFPFlTWlb07QIMsy1cyICpVNCheqGzXd8362o0XWq8YmTjjLRejyPy4+9zucBRVcWtU2HrrLG27odeeji1ohyx5aTVv15Xkmono8+sI7KizGupIaO+avXwD3Sf0b6eBb9XasVm83SbJ9jR2WalV6d/FudxI4/7xlkG3Q3h8UqTesbxMH08vrgtk0zibCG3IQlLA4TORfi6tlQgyNWSLwGi+jzCAnSnAvXFYu12u7NUCDQwDVMAQOyZm58lb0DpMByvFlWdn3xPEuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaSENzKd//RH+srTSkCCPMOZioF7KPEZ2kojACm+jiA=;
 b=2QdRo/zqJnpmizsGTOH46qQkFD/v53Exi8AWGJzkB9GRopf2ruOu101OtVJHgek87Fdskge9jxF0781GIq3dDzp0dtxlOuGU3x32UFR9UBQg7TUW+T1gdCP6Ov6QkEWLLphRfWmRByOLtZ/C0Q7mtqOTfRKx2UG4APGFIWnZWkM=
Received: from BN9PR03CA0917.namprd03.prod.outlook.com (2603:10b6:408:107::22)
 by MW4PR12MB5627.namprd12.prod.outlook.com (2603:10b6:303:16a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 06:27:57 +0000
Received: from BN6PEPF00000072.namprd03.prod.outlook.com
 (2603:10b6:408:107:cafe::53) by BN9PR03CA0917.outlook.office365.com
 (2603:10b6:408:107::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.14 via Frontend Transport; Thu,
 24 Sep 2026 06:27:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN6PEPF00000072.mail.protection.outlook.com (10.167.248.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 24 Sep 2026 06:27:56 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 24 Sep
 2026 01:27:56 -0500
Received: from [192.168.0.152] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Thu, 24 Sep 2026 01:27:47 -0500
Message-ID: <5e3b81d0-c086-45e1-a682-a4a68253189e@amd.com>
Date: Thu, 24 Sep 2026 11:57:46 +0530
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
X-MS-TrafficTypeDiagnostic: BN6PEPF00000072:EE_|MW4PR12MB5627:EE_
X-MS-Office365-Filtering-Correlation-Id: a4a39fd3-85de-4763-c5a1-08df1a04f8f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|23010399003|82310400026|1800799024|10067099003|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZE/55bGLDKZaK6drJ+2SGPEpOwgtsEHERihUKA4PCMbG1sJDg4kx48PoLYbM8zHafcG14NEv9Mae1R5g/zxLhw9ERette2IxKOudv+EORik7SVVEQis3xcXeq8KzVLLFbJLjSlk/nNmrvsJwlbmCUXx2SbThWABQ7IFlSxkWztDke1VVNueTuZIb2uju/szw2WNxkHMUUP/Aa45OJyrfVnTSff7wTiJgqaFoOW6ySDva+MoG6p/1A4ROvkNdgf3LrXCMyWY4uEQ/LlPm+4nJDn4LzCEEo7iSANwF+4Rj5AgcFXqRHzg2HiMfpstgYIWbBmXhYxV1OY+3d9NVe+F9GAPYWHlhu3xODhD8weKQf64wRhB93XSAWqfN7Pjv5VIAzSvqABFnK2FWZNDU31QUbjW0Cvck9vzuk4B0+BunnkEkHiS9BZ3etx4OUvyS/cbkmcHcQ8WvD5oQUTJ1dMU7BomzOIOCxr3iLceBF/gB4MdXbVgWvZobuqFDFl6uQNg/5sw2OwBvQPxqjsv5cMp5DUtQWc7EegUJPF6ogNydZCf52wPgVcJ6tE/h+gZTQ2q0hUE853BvYN9GQSVOrKqySIq02CsuSMeP37PHh5LnjeMK3sDxmE8QLXnBqp5dunWPdlgbuaHehm0smQxUpwkCeehWpjSaTG/vBNMhcviURGfRcniR7WdYKpjcw05DQb2sSmG0NsSBTdgS6MBcE+WvXA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(23010399003)(82310400026)(1800799024)(10067099003)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	On314MJQSuFXPNmEIBxRd963WiDpeBdjgg4++JVOELmq7+Jq1UeOjKBRBqejQuXcETvA5n/x1LHLv8zOufx9qoL4C/Vd17zVos/FZMN9LQ2y0Y+acz57C74AzHwpRriH0Rwocle8U4cfLXj9uynKqxwKtq5E/OECV5DySr893ACcxAPfbYzK+A35Cwq1nW91tVQiIdOHCYVzHP7wVyAIPfJAImxYUQeQApIAaQNaGR2V8IWvTSPg3SNS1IGPvTdVjGMEnDG/7JwjPiMB0r3G226F1TVONwFoljj/EeGdJ5Oec1NcE8LZsU3d1BlYocTYmGDdsENUocoJt2qGcvPKBJN4zGJuD0LUbjXKmxQqNWQnECBsCDWrTc4yTbYet7KBaZMQcVm64cl6dWAywPCwIDT/3+c1qohtKGFV3ZM8UuG/DO5F5qVDxLZ/yH0MUb8W
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 06:27:56.8514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4a39fd3-85de-4763-c5a1-08df1a04f8f7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN6PEPF00000072.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5627
X-Stat-Signature: 3k55nf5nm66o8he6e8x711i4a3faxb8f
X-Rspamd-Queue-Id: AB65220005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790231290-15935
X-HE-Meta: U2FsdGVkX1/A/2uNyWe1XU3x457fnHD4aG2pcWR8Oih+LmzkuKNGhqBi/TkqTzwcqnnNX2zbEnClLZy5gZfbxe9OhagSexZnJ5ARCpcirIVpbAdPCE9y7/dxxnbFJkEZDM0kHr+ka3pNtC7daElmsWzyJiOF6mYpBaRqrqqYX0v4zTVyKOH23dKaytprfb2SpmHZBwPJrSP7RyB9DNiFJEkZjZnS8oASk8TQFNRN92o21Njpfxv7PlXYr5MSyyonRWJmZQllslff8nfTJ5a6EsG3q1H1tibazqc4ntxeQfY2HmmKuTJdBC4YT09CPyMvNSsPRE/x8GsyRP00K9s8cTrZodYRyq/BRt1I5M1p7jbtd7oaMpixOn7na8qjic4jniOFDm2dfLH8aHHnebfLxnAyVv7XULKLUG+JtNhQ7c7Orstxd1uKr/M572y4roKl5OBNUrpylT02s7xtwArzANYEJMVar85KfSsWD/qPZzLIljjGEs97kni3TgTrDoBREB6g0n2MdqC26W/z9Jj5Natj6nhFh26qZq53gKQ9wNjVlX57rhlTVOuLHII93xWyzmbYjh/acz69mT2K9oTzG6jf+g54d3O8WrZNED3Kr9RMWKTMoG4rlgKYf1hxgZCXEGQJleEqHcpWVLncRqXyrAozw5VQC/a93I0j7y3s2/ZprcSha1uPiGtwIoD2jIzfzEoqZPrbGDF+qngb+Q3tvH13+CPTZ9/Tj0DtCdQCMYxg7z83e3IbMu4egVcmM3p4gJF4k/ZO1aVP77mpcaL/So7cZ9gqbQcOBTdZ2I7IkVsOLmMa3a4obJrCjyJnoxh/G14zVBjF5BMELFP9LKU/Bczmih1MamcY3RvvIT6IwobGqt1SvwQzP6DJYS8EgzOIQkObLoSUgyBN/CelOn0ErLe8dPOHKZEsZX2DextEa7CqSF0++Uf4uhVd4CU7aChsOLADOxft621yOWuJd7p
 ubhVDl4e
 TgHzyHEmo+abXSQvU29Wx0nAVrmowvrlJ41ys/EIWFadTS3BfDaI4CMYbelZlCW+PSAhgn4GYOi8+yc5XVVa2umoCB2cnoM3e06njK1ln1P6kzXvQbDvBi1o/yxHpdAfTBts9gDl/mOvNXfur6R8UoKtYzqN6FSskaMbT3X/J2Gnn4bUMEplBDxd7yM4Vzze4vFoRAAM6ybw+S0N5QYwzsOySaRf2h4ho2uDmNn+CoZVc/MAfr3GyOSmlgVFPqYQwsoVG4uzDbMnX4WjOYwMcda0P3m/7JxDYmBJ+ouSDM0Q/fmbCKVroP95FI5tN1s+5K8rU4r7MgwEny4BjEwZN6aRCNv6OU+KUQxW0pG7kCrNnZyaA89Os619FuDjYpIXSembP9jvIKa2qvCsp6aynNsK6GqTHkWoQlTIhdmBvPlESEHWtu6SHccFx+cmrpBs87eTWUNc+u5dnkog0Ty0tSJ4m1O+uN0bKfkU4MqTb40CqU3w=
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

Graph500 tiering comparison: base vs pghot (hwhints)
====================================================
Kernel(s) : base  = 7.3.0-rc2-base+
            pghot = 7.3.0-rc2-pghot+
Benchmark : Graph500 reference BFS, SCALE=28, edgefactor=16, 128 ranks
Topology  : top-tier NUMA node=1 (CPUs+DRAM), lower-tier node=2 (mem-only/CXL)
Note      : SKIP_VALIDATION=1 (timing-only); all TEPS carry Graph500 (!) flag.
            Figure of merit is harmonic_mean_TEPS (hmean).

Config legend
-------------
C1 : base  kernel, no tiering       (numa_balancing=0)
C2 : base  kernel, NUMAB2 tiering   (numa_balancing=2)
C3 : pghot kernel, hwhints source   (pghot_enabled_sources=2,
     pghot_freq_threshold=1, pghot_target_nid=0 [default],
     IBS mem-profiler on, numa_balancing=0, promotion=off)

Column legend
-------------
hmean   : harmonic_mean_TEPS   (primary Graph500 metric)
hstddev : harmonic_stddev_TEPS
median  : median_TEPS
bfs_t   : mean BFS time (seconds)
spdup   : speedup of hmean vs C1 baseline

Table 1: Performance
--------------------
+--------+------------+----------+------------+---------+--------+
| Config |   hmean    | hstddev  |   median   |  bfs_t  | spdup  |
|        |   (TEPS)   |  (TEPS)  |   (TEPS)   |  (sec)  |        |
+--------+------------+----------+------------+---------+--------+
| C1     | 5.543e+08  | 5.51e+05 | 5.548e+08  |  7.748  | 1.00x  |
| C2     | 1.298e+09  | 6.80e+07 | 1.394e+09  |  3.308  | 2.34x  |
| C3     | 1.755e+09  | 2.32e+07 | 1.805e+09  |  2.447  | 3.17x  |
+--------+------------+----------+------------+---------+--------+

Table 2: Relevant kernel counters (/proc/vmstat deltas over the run)
--------------------------------------------------------------------
Values are accumulated deltas (before -> after) for the whole run.

+----------------------------+-----------+-----------+-----------+
| Counter                    |    C1     |    C2     |    C3     |
+----------------------------+-----------+-----------+-----------+
| numa_pte_updates           |         0 |  25867526 |         0 |
| numa_hint_faults           |         0 |  13318442 |         0 |
| numa_pages_migrated        |         0 |  13318248 |   3702779 |
| pgpromote_success          |         0 |  13317996 |   3702779 |
| pghot_recorded_accesses    |         0 |         0 |   3709015 |
| pghot_reported_hintfaults  |         0 |         0 |         0 |
| pghot_reported_hwhints     |         0 |         0 |  21385228 |
| hwhint_total_events        |         0 |         0 |  21385281 |
| hwhint_dram_accesses       |         0 |         0 |  16747814 |
| hwhint_extmem_accesses     |         0 |         0 |   3697760 |
| hwhint_cache_accesses      |         0 |         0 |         0 |
| hwhint_useful_events       |         0 |         0 |  21385228 |
| hwhint_dropped_events      |         0 |         0 |         0 |
| pgmigrate_success          |  26841377 |  40161043 |  30548434 |
+----------------------------+-----------+-----------+-----------+

Key findings
------------
1. Tiering is the dominant win: C2 (base NUMAB2) reaches 2.34x and C3
   (pghot hwhints) 3.17x over the untiered baseline (C1), where the
   working set is stranded on the lower-tier/CXL node 2.

2. pghot hwhints now clearly leads base NUMAB2 on the official metric:
   C3 1.755e9 (3.17x) vs C2 1.298e9 (2.34x) -> ~+35% hmean_TEPS.

3. hwhints/IBS is far more efficient and stable. C3 reaches its higher
   hmean while:
     - promoting only ~3.70M pages, ~1/4 of C2 (13.32M);
     - issuing zero NUMA hint faults / PTE scans (numa_pte_updates=0);
     - being ~3x more consistent (hstddev 2.32e7 vs 6.80e7).
   IBS reported 21.39M hwhint events (16.75M DRAM + 3.70M ext-mem),
   with hwhint_dropped_events=0.

4. median vs harmonic-mean: C2 median (1.394e9) sits well above its
   hmean (1.298e9), reflecting high per-BFS variance in the fault-driven
   path. C3 median (1.805e9) and hmean (1.755e9) sit close together ->
   low variance.

Caveats
-------
* Single run per configuration; the median-vs-hmean spread for C2
  indicates non-trivial run-to-run variance. Repeat runs are advisable
  before drawing firm quantitative conclusions.
* SKIP_VALIDATION=1 was used (timing-only), so TEPS values are flagged
  invalid (!) by Graph500 and are intended for relative comparison only.


