Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 146F8C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03D8B6B00A1; Tue, 28 Jul 2026 01:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09296B00A2; Tue, 28 Jul 2026 01:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA626B00A3; Tue, 28 Jul 2026 01:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91F786B00A1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:45:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1434F1A02C2
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:45:44 +0000 (UTC)
X-FDA: 85037098608.14.F867D79
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010015.outbound.protection.outlook.com [40.93.198.15])
	by imf04.hostedemail.com (Postfix) with ESMTP id E7B434000E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:45:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=b+wAws7D;
	spf=pass (imf04.hostedemail.com: domain of bharata@amd.com designates 40.93.198.15 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785217541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtXF2tTuUm+dX8qPODQX9eak3fMr3vN7uQgjajv3Hrk=;
	b=h3CwPe8O1zgsoE3NbQ9NH6AK8TwtApvRlo+3yYglMtoRZYTk0Ht4DoDNWcbftM3XBRW33+
	9mNgUteotYAGXPLYg2OlOYV3wNRoiy/F7gXdfxxPNoxmlt3jScfZ17BN92Dx7jf0/Qg78P
	bftf61j00CIr2VUscKWLV3LJKrjkwp0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=b+wAws7D;
	spf=pass (imf04.hostedemail.com: domain of bharata@amd.com designates 40.93.198.15 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785217541;
	b=ht7SrSKspb7T9WVQb86t8kv1UMvAKob+V0LjFX3QlXeP7bZ5HS2K0W9Ez1GAcLlwvBzxDQ
	6nbHfRcJnuO2fZ9nH4a6YtEd1rgtx+qi+qY4/wUHIWzxh3PKAhGqS48uUR7qJEBbqznw1g
	fa/dK+BYLLlsLVNeuh1zOFcZk/axxuc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jXcpMBP6bU1Mzm0Kwu1MSbTS4mrJ59vn5DzyKQECF1rFaiXo9WmMwoLgfdjVXD/f/mc9xfAwfI6gJUaeb9rtNwAsQ/52mowPkp6BuoYBuAD7Dh+JIzoLdBojFVxdz3mPSAxXwb9XBG2lfotb7rloGLXQhLZ6mlm9H1N/mH6V62XBdZGO+Spr+Kw8mA8H5EGuXSUiiAuBZvHRYUHv7ICnimVxbd5NbP+Pcjl36dLZEKMrDUCV16vbsr8xqy6SqcYRsnYjU6m+KVkA0jSgVZ2PNoIkyoZKqH0Ob2ZpFpDPn0JYUtt03P1iS+7rzF79nQIIqjnbsj+1lYW6qEecZXzz3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CtXF2tTuUm+dX8qPODQX9eak3fMr3vN7uQgjajv3Hrk=;
 b=vPOzTmzIVP/LY+lpJAfVD0BggBeMdjCojDRIDhkZp74JEt129wt6pbCWMRHM2071g0sr2VFg0IzbHVnKYwnHkD7MGLVh/UyUnYCd+mDffqFzCHGgcQIyIyjoHp5E+p6wbOsFZlHckLvaABs/Vr2HcgqOvjsTuOPJx+1HropOPR8R060YuJVQki1ZixhXQ2oW7lk+5pv1sFekauT8GBgUUVaCxRqyWkEa/Hkqyz1qTSHxV4zUDwWPAipV5WIp2vvYgsQyX7fEYwLKQ8f5c54ifj2EqNffLezh9L8LmEIJukcGM8ZusmxNgKIfxcu1nOk6nA0Uz6ZBZt9SQTM9Lea7zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtXF2tTuUm+dX8qPODQX9eak3fMr3vN7uQgjajv3Hrk=;
 b=b+wAws7DXU55Kq4xT+x6x3I9qYlefzmd7a9wB9TM95kvSppKzN4Rd6ZECfwWJvBDsWBNYOvPpmqugdoJQzNfW+jVmEzHAobKvhK3APINFrwVLtPlGYaxZEVM10EFEQCXx/TM6FBLJN8GcOC5rOKmpIwte4UvinxluN086A6/JX4=
Received: from SJ0PR13CA0143.namprd13.prod.outlook.com (2603:10b6:a03:2c6::28)
 by DSSPR12MB999238.namprd12.prod.outlook.com (2603:10b6:8:374::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 05:45:35 +0000
Received: from MWH0EPF000C6195.namprd02.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::8c) by SJ0PR13CA0143.outlook.office365.com
 (2603:10b6:a03:2c6::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Tue,
 28 Jul 2026 05:45:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6195.mail.protection.outlook.com (10.167.249.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 05:45:34 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 00:45:26 -0500
From: Bharata B Rao <bharata@amd.com>
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
	<shivankg@amd.com>, <donettom@linux.ibm.com>, Bharata B Rao <bharata@amd.com>
Subject: [PATCH v8 8/8] x86/mm/ibs: Add runtime controls for IBS memprofiler
Date: Tue, 28 Jul 2026 11:13:56 +0530
Message-ID: <20260728054356.291998-9-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260728054356.291998-1-bharata@amd.com>
References: <20260728054356.291998-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6195:EE_|DSSPR12MB999238:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a96875-65bc-470e-00df-08deec6b71b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700016|82310400026|23010399003|7416014|22082099003|6133799003|21046099003|56012099006|11063799006|10067099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	1+t4zfF/OldKoYtgjR+z3vcYIrsNYyivy26OwLkjNdEoJa6L9H60sXPT4Eu+nFJkZlNRukgoWkQRewzq/wV8xYyypcUp9hw6W3Mrr35CgQtGnFdeYNu4j+RnHxEPXFwgn67Nyj8fdzpGcxzQTfa6+rxNOrBBSY00WErzU1YE4/dtnd0of35JGuk64vR6SQaLE6SQv+IgqRweuX0CWnaUp301WqmxJXCbAB5GI8yeMbd6qwMn5CSj7IsYHSfz4s11myPtm6v7VW3JIgr1QXIBGj4O/VdSIlOWMo74Dwfqif9vx5ARjbb62fxr0mh4ShwMeN2Qp5dBUbDaNT+E1a5a2zFWpoBtZ7arOMmfQxmvV6qAemuDZzqTVwJHy1FCSQyOPehDWmhVgy/rN1DaYLX0KgyDV+pbAl0sXp2Iga/S3+dPR4K68+BgMndFQsj/ZeRewjmuweXOco3MxvlCHCRi1iMdc9NhYSPD71YzVu/MTLLeI7SdlPxlfq4HVf5l2iLdol5EyfGFEC71dNDX4A6O2n32QSuC3fCj/Cf1GZgO0/iUPvyAM135HnZMYshHffUUvMkeBRRzELKskpYOJzMZLTCzxVKwASmxP928tO3as4leleQOjEp8xerO5WQI5r4J0YBkUL7VHbl2cAPAZTGI+Mfnd/Kfp4CcZnTlffCyg+N/duzCSoflSpTp7P29cha/KYtvoJ2tuaWwj6k/aC9lgw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700016)(82310400026)(23010399003)(7416014)(22082099003)(6133799003)(21046099003)(56012099006)(11063799006)(10067099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MPuUYm4O15FWvxrBvIWpc4VLR32y91M/tliVAgKAp7UKmHFU+Bq2q9pLwyMoE6m2THWj0jSf2RjW62ehYUQeXBdUbbLU4AznEVXMvJ/RIiVnyzNiS5kLAeyQ+DZZD9dr+7cxxft4nZQZVMHusf1QkHPPP/hNaBOO+Qce7QWFtQuiH2fEk36Ttlp8LYslJIrYJZJ9IOvSH21WS57YAcwgka1MiYFJ9BQy5mUaIw4DrOrl7ItIn4Pjakl3xnQHJOfVMycKJxMtP3eKK9cy081unWgju6D97cOXwNDPorEwuZXEvOJcW1Pbcxenrp3fo6fO8ckm3sAlF0CYZy/Zg6lSCeSOCbx9LDqL7RjylBFMKWZCswK7CFP/zUf1CJ1Goaw1sjlP8/dV3SaJHIB6Qt8E2xxH2wjxdWejOQv3axZ4AiI3PM/qe9c3H7cSVRLvulSn
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 05:45:34.5196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a96875-65bc-470e-00df-08deec6b71b5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6195.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSSPR12MB999238
X-Rspamd-Queue-Id: E7B434000E
X-Rspam-User: 
X-Stat-Signature: 8aq9ishk59zhnrx9dpcu6cytybuozfri
X-Rspamd-Server: rspam04
X-HE-Tag: 1785217540-971615
X-HE-Meta: U2FsdGVkX1/x7u9J6zEoyUOj+2zAzNdt3/06Ab80g4KuZx+uk7THacrn9Xcdve1I0kkUPtvbsO+HQfA1YBlikqKYEupcVUz6Clu2MaFuRqBkne9UdeSI3ORAYWS20Wo1VdbzKrsZmD5FyapTjRVwNDuhve8N/yYf0f8hKhI3XlPVHG6qgS/ZvnhK8kv6f9/vW7h6X4MrPzhxC/VOnXUZddKZfKAFxmLHAs+gNcoGdv2Ce41cHqLJhbMpLidQMsjeTyT3qoJZvMhgIpdHBbIKzFky/oM1p9Nwr4P/Ug2Tm7aRaeri5byar1O57AbI5a3loZ/YscfWmv6CLRHZixuXT2daBcrtY5/YzNfjFUUutzz8dxW6Sgxq0KqbXHKIqi6KErYbuNFToLPOta0k5BiacbXUqHNPiiMzQ7EWOEdaLkwg6e0fkwGZLVfMz97dvC2GDQmGeKax7DWZpDL6UYvetLPD2uSf9cqyw6fJkvRldsqJXtvPtjmW3QTtJrixjRaMAkByeZ5pr3Ivj3zBgEBmOx54gM9n4HtD3AR9ag2oNj5UvEUatYlmPKnM8h8cIs0S0bb73+qqMipEiyuzQYyRGAMVZXUAI5r83o5tTnMhPrNJ0GMklU+KlCfKRV+KHzfAzbvn5Iw6PaXZ/MYehMWUGPi0SfuCHBZnyRMMHi9iGQDXbup8xtM0W91M9CZC+1yRgUoQpbOaqqREQLSxHzoNiN9UDwoVaUAndE30+I6JhAZbfWuW4ZMmlKcI9DbJHAKZ44yK1h1B73LY54fQuTGX9l4VmhTS03ppWRE4t56CnYuK431SOoPobfzhfUdo+c9XwSD1uv7gcNO5GkOy04hVzoaPZwAiAnZ9+VIAMfwHlVBBlajsQn9j3F5x4g252OiHYUy/0j6NhhottZSz1N2+9I5nvL3HdIN6XPiDUwH/t5wqUG5ROLMSTgVtmVzosY6F2gDOG5oaGRd+kn1/BL5
 uipcoCnQ
 vKgczFHOW99GG00ecAZ2pbl2oMjOUO1rHMbZf8x5snOmNUm8BhOc9UltPmhXvy5zfS8wdYZg4L/k3aeSMQraj1PKMALgjqeWVm5kv6mR4fJeWaao3FS+xikAkqQ1ug1RBlAqhu9/niNz8nhwqFXoLoJ4xBQ5gLNFH7aINJRq0KM/i8U8KcBU7sEXEMmZ6YcgU0sBTUbb8RFp4yXr/e176/+Ukx8nBM5Q6hu0FkMNnzl0NwMVyXIaGP73OX0CVkxhelPgP8o1CgrnB8z8TYFhg45xMwiQq5kBJN9W9ocGDLgsrXpA7kIE9uh14wLraH8gIZnBjWezqWIqfcD/RJ8PF1mMtid2dI/pOyeCQafFIs+VFr2x4OWFJ8VroT67MRI7lLvfddeocYHxboKbSGGCbO9LYN0rRIvAIAJ3/pUi1CANgE6vOGI5S+cSOyoFyHnVtNVjicMuV4BpPLz10hUqq2P6LfnkmgOvXU2hCLFNeNf7Q1U+EMWD317aGGKR1i526s1QapNBxq1eBn/mK06X0SS8C6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose runtime tunables for IBS Memory profiler and arm the profiler.

<debugfs>/ibs-mprof/l3miss-only  - IbsMemL3MissOnly filter
<debugfs>/ibs-mprof/period       - op sample period (IbsMemMaxCnt)
<debugfs>/ibs-mprof/lat-filter   - IbsMemLatFltEn load-latency filter
<debugfs>/ibs-mprof/lat-thresh   - IbsMemLatThrsh (0x0..0xf)

In addition, a kernel cmdline parameter (ibs-memprof) is introduced
to enable profiling right from boot time.

/sys/devices/system/cpu/ibs-mprof/enabled can be used to turn the
profiling on or off.

Enabling the profiler will result in IBS Memory Profiler samples to
be reported to pghot subsystem. pghot will act on these samples only
if hwhints source is enabled explicilty using pghot/enabled_sources
debugfs tunable.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 .../admin-guide/kernel-parameters.txt         |   5 +
 Documentation/admin-guide/mm/pghot.rst        |  44 +++
 arch/x86/include/asm/ibs-mprof.h              |  14 +
 arch/x86/mm/ibs-mprof.c                       | 371 +++++++++++++++++-
 4 files changed, 419 insertions(+), 15 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b5493a7f8f22..c25bf35767eb 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2216,6 +2216,11 @@ Kernel parameters
 			syscalls, essentially overriding IA32_EMULATION_DEFAULT_DISABLED at
 			boot time. When false, unconditionally disables IA32 emulation.
 
+	ibs-memprof=	[X86-64]
+			Format: <bool>
+			When true, IBS Memory Profiler will be enabled at boottime
+			for memory access profiling. It can be changed at runtime too
+			using /sys/devices/system/cpu/ibs-mprof/enabled.
 
 	idle=		[X86,EARLY]
 			Format: idle=poll, idle=halt, idle=nomwait
diff --git a/Documentation/admin-guide/mm/pghot.rst b/Documentation/admin-guide/mm/pghot.rst
index b802b80e5c24..69210e9f8e93 100644
--- a/Documentation/admin-guide/mm/pghot.rst
+++ b/Documentation/admin-guide/mm/pghot.rst
@@ -150,3 +150,47 @@ Path: /proc/vmstat
 5. **hwhint_extmem_accesses**
    - Number of external memory (like CXL) accesses reported by hwhints source.
 
+AMD IBS Memory Profiler Tunables
+================================
+sysfs tunables
+--------------
+1. enabled
+
+Path: /sys/devices/system/cpu/ibs-mprof/enabled
+
+- Enable (1) or disable (0) memory access profiling. Enabling here
+  would only arm the memory profiler and results in generation of IBS
+  samples. pghot will act on the reported samples only if hwhints source
+  is enabled in **pghot_enabled_sources**.
+- Default: 0 (Disabled)
+
+Debugfs tunables
+----------------
+Path: /sys/kernel/debug/ibs-mprof/
+
+These tune the AMD IBS Memory Profiler hardware hints source and are
+present only when AMD_IBS_MEMPROF is enabled. A write takes effect on
+all CPUs immediately.
+
+1. **l3miss-only**
+   - When 1, only accesses that miss the L3 cache are sampled. It is
+     recommended to run the memory profiler with L3 miss filtering
+     enabled.
+   - Default: 1
+
+2. **period**
+   - Sample period as the number of ops between samples (IbsMemMaxCnt).
+   - Range: 5000 to 134217727.
+   - Default: 10000
+
+3. **lat-filter**
+   - When 1, enable load latency filtering: only loads whose latency
+     exceeds the **lat-thresh** threshold are reported.
+   - Default: 0
+
+4. **lat-thresh**
+   - Load latency threshold, effective only when **lat-filter** is 1. A
+     sample is reported when the load latency exceeds
+     (lat-thresh + 1) * 128 core cycles.
+   - Range: 0x0 to 0xf
+   - Default: 0
diff --git a/arch/x86/include/asm/ibs-mprof.h b/arch/x86/include/asm/ibs-mprof.h
index 3de1880c4126..8b91c0ff1c33 100644
--- a/arch/x86/include/asm/ibs-mprof.h
+++ b/arch/x86/include/asm/ibs-mprof.h
@@ -30,6 +30,9 @@
 #define IBS_MPROF_DATA3_SW_PREFETCH	BIT_ULL(21)
 
 /* MSR_AMD64_IBS_MPROF_CTL bits */
+#define IBS_MPROF_CTL_LATFLTEN		BIT_ULL(63)	/* IbsMemLatFltEn */
+#define IBS_MPROF_CTL_LATTHRSH_SHIFT	59
+#define IBS_MPROF_CTL_LATTHRSH_MASK	(0xFULL << IBS_MPROF_CTL_LATTHRSH_SHIFT)
 #define IBS_MPROF_CTL_CNT_CTL		BIT_ULL(19)
 #define IBS_MPROF_CTL_VAL		BIT_ULL(18)
 #define IBS_MPROF_CTL_ENABLE		BIT_ULL(17)
@@ -37,6 +40,17 @@
 #define IBS_MPROF_CTL_MAXCNT_MASK	0x0000FFFFULL
 #define IBS_MPROF_CTL_MAXCNT_EXT_MASK	(0x7FULL << 20)	/* separate upper 7 bits */
 
+/*
+ * IbsMemMaxCnt is a 27-bit op count; the low 4 bits are always zero.
+ * The hardware minimum is 16, but such a short interval is impractical
+ * (interrupt storm), so restrict the sample period to a sensible floor.
+ */
+#define IBS_MPROF_MAXCNT_MIN		5000
+#define IBS_MPROF_MAXCNT_MAX		((1U << 27) - 1)
+
+/* IbsMemLatThrsh is a 4-bit field. */
+#define IBS_MPROF_LATTHRSH_MAX		0xF
+
 /* MSR_AMD64_IBS_MPROF_CTL2 bits */
 #define IBS_MPROF_CTL2_DISABLE		BIT_ULL(0)
 #define IBS_MPROF_CTL2_EXCLUDE_USER	BIT_ULL(1)
diff --git a/arch/x86/mm/ibs-mprof.c b/arch/x86/mm/ibs-mprof.c
index 923fb8f99552..07e0516db2ee 100644
--- a/arch/x86/mm/ibs-mprof.c
+++ b/arch/x86/mm/ibs-mprof.c
@@ -10,6 +10,11 @@
 #include <linux/vm_event_item.h>
 #include <linux/vmstat.h>
 #include <linux/cpuhotplug.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/mutex.h>
+#include <linux/smp.h>
+#include <linux/uaccess.h>
 
 #include <asm/ibs-mprof.h>
 #include <asm/ibs-caps.h>
@@ -54,6 +59,41 @@ struct mprof_worker {
 };
 static DEFINE_PER_CPU(struct mprof_worker, mprof_work);
 
+/*
+ * Runtime-configurable profiler parameters, exposed via debugfs. The
+ * interrupt handler consumes the published snapshot on every re-arm, so
+ * configuration changes need no locking on the fast path. Writers are
+ * serialized by mprof_cfg_lock and publish an immutable snapshot; the hot
+ * path only does an smp_load_acquire() of the pointer.
+ */
+struct mprof_config {
+	bool enabled;		/* profiling enabled (IbsMemDis inverted) */
+	bool l3miss_only;	/* IbsMemL3MissOnly */
+	bool lat_filter;	/* IbsMemLatFltEn */
+	u8   lat_thresh;	/* IbsMemLatThrsh, 0x0 .. 0xf */
+	u32  period;		/* op sample period (IbsMemMaxCnt) */
+	/* Precomputed register values for the interrupt fast path. */
+	u64  ctl;
+	u64  ctl2;
+};
+
+static struct mprof_config mprof_cfg_slots[2];
+static struct mprof_config *mprof_cfg;
+static DEFINE_MUTEX(mprof_cfg_lock);
+
+/*
+ * ibs-memprof: kernel cmdline parameter to arm IBS Memory
+ * Profiler right from boot time.
+ */
+bool ibs_mprof_enabled __read_mostly;
+
+static int __init setup_ibs_mprof(char *str)
+{
+	return (kstrtobool(str, &ibs_mprof_enabled) == 0);
+}
+
+__setup("ibs-memprof=", setup_ibs_mprof);
+
 /*
  * Record the IBS-reported access sample in percpu buffer.
  * Called from IBS interrupt handler.
@@ -159,28 +199,55 @@ static inline void mprof_drain_cpu(unsigned int cpu)
 }
 
 /*
- * L3MissOnly + Exclude kernel RIP
+ * Translate the software config into IbsMemCtl / IbsMemCtl2 register values.
+ * Kernel RIP is always excluded: the profiler only samples user memory
+ * accesses.
  */
-static void mprof_enable_profiling(void)
+static void mprof_compose(struct mprof_config *cfg)
 {
-	u64 mprof_config = IBS_MPROF_CTL_CNT_CTL | IBS_MPROF_CTL_L3MISSONLY;
-	unsigned int period = IBS_MPROF_SAMPLE_PERIOD;
-	u64 ctl, ctl2;
+	u64 ctl;
+
+	if (!cfg->enabled) {
+		ctl = 0;
+		cfg->ctl = ctl;
+		cfg->ctl2 = IBS_MPROF_CTL2_DISABLE;
+		return;
+	}
 
 	/*
-	 * Assemble bits 26:20 and 19:4 of periodic op counter in ctl.
+	 * Assemble bits 26:20 and 19:4 of the periodic op counter in ctl.
 	 * The lower 4 bits are always 0000b.
 	 */
-	ctl = (period >> 4) & IBS_MPROF_CTL_MAXCNT_MASK;
-	ctl |= (period & IBS_MPROF_CTL_MAXCNT_EXT_MASK);
-	ctl |= mprof_config;
-	wrmsrq(MSR_AMD64_IBS_MPROF_CTL, ctl);
+	ctl = (cfg->period >> 4) & IBS_MPROF_CTL_MAXCNT_MASK;
+	ctl |= cfg->period & IBS_MPROF_CTL_MAXCNT_EXT_MASK;
+	ctl |= IBS_MPROF_CTL_CNT_CTL | IBS_MPROF_CTL_ENABLE;
 
-	/*
-	 * Exclude samples that have bit 63 of their RIP set.
-	 */
-	ctl2 = IBS_MPROF_CTL2_EXCLUDE_KERNEL;
-	wrmsrq(MSR_AMD64_IBS_MPROF_CTL2, ctl2);
+	if (cfg->l3miss_only)
+		ctl |= IBS_MPROF_CTL_L3MISSONLY;
+
+	if (cfg->lat_filter) {
+		ctl |= IBS_MPROF_CTL_LATFLTEN;
+		ctl |= ((u64)cfg->lat_thresh << IBS_MPROF_CTL_LATTHRSH_SHIFT) &
+			IBS_MPROF_CTL_LATTHRSH_MASK;
+	}
+
+	cfg->ctl = ctl;
+	/* Exclude samples that have bit 63 of their RIP set (kernel). */
+	cfg->ctl2 = IBS_MPROF_CTL2_EXCLUDE_KERNEL;
+}
+
+/*
+ * Program the profiler from the currently published config snapshot. Called
+ * at CPU startup, from the interrupt handler on every re-arm, and via
+ * on_each_cpu() when the config changes.
+ */
+static void mprof_enable_profiling(void)
+{
+	/* Acquire the snapshot; pairs with smp_store_release() in the writers. */
+	struct mprof_config *cfg = smp_load_acquire(&mprof_cfg);
+
+	wrmsrq(MSR_AMD64_IBS_MPROF_CTL, cfg->ctl);
+	wrmsrq(MSR_AMD64_IBS_MPROF_CTL2, cfg->ctl2);
 }
 
 static void mprof_disable_profiling(u64 mem_ctl)
@@ -192,6 +259,52 @@ static void mprof_disable_profiling(u64 mem_ctl)
 	wrmsrq(MSR_AMD64_IBS_MPROF_CTL2, IBS_MPROF_CTL2_DISABLE);
 }
 
+static void mprof_reprogram_this_cpu(void *info)
+{
+	mprof_enable_profiling();
+}
+
+/*
+ * Publish a new config snapshot and push it to every online CPU
+ * immediately. Must be called with mprof_cfg_lock held.
+ */
+static void mprof_publish(const struct mprof_config *newcfg)
+{
+	struct mprof_config *slot;
+
+	lockdep_assert_held(&mprof_cfg_lock);
+
+	/* Fill the slot that is not currently published, then flip to it. */
+	slot = (mprof_cfg == &mprof_cfg_slots[0]) ?
+		&mprof_cfg_slots[1] : &mprof_cfg_slots[0];
+	*slot = *newcfg;
+	mprof_compose(slot);
+	/* Publish the fully composed slot; pairs with smp_load_acquire() in readers. */
+	smp_store_release(&mprof_cfg, slot);
+
+	/*
+	 * on_each_cpu() with wait serializes against any in-flight interrupt
+	 * handler on each CPU, so the previously published slot has no readers
+	 * once this returns and can be safely reused by the next writer.
+	 */
+	on_each_cpu(mprof_reprogram_this_cpu, NULL, 1);
+}
+
+static void mprof_config_init(void)
+{
+	struct mprof_config *cfg = &mprof_cfg_slots[0];
+
+	if (ibs_mprof_enabled)
+		cfg->enabled = true;
+	cfg->l3miss_only = true;
+	cfg->lat_filter = false;
+	cfg->lat_thresh = 0;
+	cfg->period = IBS_MPROF_SAMPLE_PERIOD;
+	mprof_compose(cfg);
+	/* Publish the initial snapshot; pairs with smp_load_acquire() in readers. */
+	smp_store_release(&mprof_cfg, cfg);
+}
+
 /*
  * IBS interrupt handler: Process the memory access info reported by IBS.
  *
@@ -216,6 +329,13 @@ static void mprof_overflow_handler(void)
 	rdmsrq(MSR_AMD64_IBS_MPROF_DATA3, mem_data3);
 	rdmsrq(MSR_AMD64_IBS_MPROF_DATA2, mem_data2);
 
+	/*
+	 * If L3 miss filtering is turned off, non load/store
+	 * samples may get reported. Ignore them.
+	 */
+	if (!(mem_data3 & (IBS_MPROF_DATA3_LDOP | IBS_MPROF_DATA3_STOP)))
+		goto handled;
+
 	data_src = mem_data2 & IBS_MPROF_DATA2_DATASRC_MASK;
 	data_src |= ((mem_data2 & IBS_MPROF_DATA2_DATASRC_MASK_HIGH) >>
 			IBS_MPROF_DATA2_DATASRC_MASK_HIGH_SHIFT);
@@ -323,6 +443,223 @@ static int x86_amd_ibs_mprof_teardown(unsigned int cpu)
 	return 0;
 }
 
+/*
+ * debugfs interface. Each parameter is a separate file under
+ * <debugfs>/ibs-mprof/. A write validates the value, updates the current
+ * config and actively propagates it to all CPUs via mprof_publish().
+ */
+enum mprof_field {
+	MPROF_L3MISS_ONLY,
+	MPROF_LAT_FILTER,
+	MPROF_LAT_THRESH,
+	MPROF_PERIOD,
+};
+
+static int mprof_parse_uint(const char __user *ubuf, size_t cnt, unsigned int *val)
+{
+	char buf[16];
+
+	if (cnt > sizeof(buf) - 1)
+		cnt = sizeof(buf) - 1;
+	if (copy_from_user(buf, ubuf, cnt))
+		return -EFAULT;
+	buf[cnt] = '\0';
+	if (kstrtouint(buf, 0, val))
+		return -EINVAL;
+	return 0;
+}
+
+static void mprof_store(enum mprof_field field, unsigned int val)
+{
+	struct mprof_config new;
+
+	mutex_lock(&mprof_cfg_lock);
+	new = *mprof_cfg;
+	switch (field) {
+	case MPROF_L3MISS_ONLY:
+		new.l3miss_only = val;
+		break;
+	case MPROF_LAT_FILTER:
+		new.lat_filter = val;
+		break;
+	case MPROF_LAT_THRESH:
+		new.lat_thresh = val;
+		break;
+	case MPROF_PERIOD:
+		new.period = val;
+		break;
+	}
+	mprof_publish(&new);
+	mutex_unlock(&mprof_cfg_lock);
+}
+
+#define MPROF_SHOW(name, field)						\
+static int mprof_##name##_show(struct seq_file *m, void *v)		\
+{									\
+	/* Acquire the snapshot; pairs with smp_store_release() in writers. */	\
+	struct mprof_config *cfg = smp_load_acquire(&mprof_cfg);	\
+									\
+	seq_printf(m, "%u\n", cfg->field);				\
+	return 0;							\
+}									\
+static int mprof_##name##_open(struct inode *inode, struct file *filp)	\
+{									\
+	return single_open(filp, mprof_##name##_show, NULL);		\
+}
+
+MPROF_SHOW(l3miss_only, l3miss_only)
+MPROF_SHOW(lat_filter, lat_filter)
+MPROF_SHOW(lat_thresh, lat_thresh)
+MPROF_SHOW(period, period)
+
+static ssize_t mprof_l3miss_only_write(struct file *filp, const char __user *ubuf,
+				       size_t cnt, loff_t *ppos)
+{
+	unsigned int val;
+	int ret;
+
+	ret = mprof_parse_uint(ubuf, cnt, &val);
+	if (ret)
+		return ret;
+	if (val > 1)
+		return -EINVAL;
+
+	mprof_store(MPROF_L3MISS_ONLY, val);
+	*ppos += cnt;
+	return cnt;
+}
+
+static ssize_t mprof_lat_filter_write(struct file *filp, const char __user *ubuf,
+				      size_t cnt, loff_t *ppos)
+{
+	unsigned int val;
+	int ret;
+
+	ret = mprof_parse_uint(ubuf, cnt, &val);
+	if (ret)
+		return ret;
+	if (val > 1)
+		return -EINVAL;
+
+	mprof_store(MPROF_LAT_FILTER, val);
+	*ppos += cnt;
+	return cnt;
+}
+
+static ssize_t mprof_lat_thresh_write(struct file *filp, const char __user *ubuf,
+				      size_t cnt, loff_t *ppos)
+{
+	unsigned int val;
+	int ret;
+
+	ret = mprof_parse_uint(ubuf, cnt, &val);
+	if (ret)
+		return ret;
+	if (val > IBS_MPROF_LATTHRSH_MAX)
+		return -EINVAL;
+
+	mprof_store(MPROF_LAT_THRESH, val);
+	*ppos += cnt;
+	return cnt;
+}
+
+static ssize_t mprof_period_write(struct file *filp, const char __user *ubuf,
+				  size_t cnt, loff_t *ppos)
+{
+	unsigned int val;
+	int ret;
+
+	ret = mprof_parse_uint(ubuf, cnt, &val);
+	if (ret)
+		return ret;
+	if (val < IBS_MPROF_MAXCNT_MIN || val > IBS_MPROF_MAXCNT_MAX)
+		return -EINVAL;
+
+	mprof_store(MPROF_PERIOD, val);
+	*ppos += cnt;
+	return cnt;
+}
+
+#define MPROF_FOPS(name)						\
+static const struct file_operations mprof_##name##_fops = {		\
+	.open		= mprof_##name##_open,				\
+	.read		= seq_read,					\
+	.write		= mprof_##name##_write,				\
+	.llseek		= seq_lseek,					\
+	.release	= single_release,				\
+}
+
+MPROF_FOPS(l3miss_only);
+MPROF_FOPS(lat_filter);
+MPROF_FOPS(lat_thresh);
+MPROF_FOPS(period);
+
+static void mprof_debugfs_init(void)
+{
+	struct dentry *dir = debugfs_create_dir("ibs-mprof", NULL);
+
+	debugfs_create_file("l3miss-only", 0644, dir, NULL, &mprof_l3miss_only_fops);
+	debugfs_create_file("lat-filter", 0644, dir, NULL, &mprof_lat_filter_fops);
+	debugfs_create_file("lat-thresh", 0644, dir, NULL, &mprof_lat_thresh_fops);
+	debugfs_create_file("period", 0644, dir, NULL, &mprof_period_fops);
+}
+
+static ssize_t enabled_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	/* Acquire the snapshot; pairs with smp_store_release() in the writers. */
+	struct mprof_config *cfg = smp_load_acquire(&mprof_cfg);
+
+	return sysfs_emit(buf, "%s\n", str_enabled_disabled(cfg->enabled));
+}
+
+static ssize_t enabled_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct mprof_config new;
+	bool enabled;
+	int ret;
+
+	ret = kstrtobool(buf, &enabled);
+	if (ret)
+		return ret;
+
+	guard(mutex)(&mprof_cfg_lock);
+	new = *mprof_cfg;
+	new.enabled = enabled;
+	mprof_publish(&new);
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(enabled);
+
+static struct attribute *ibs_mprof_attributes[] = {
+	&dev_attr_enabled.attr,
+	NULL
+};
+
+static const struct attribute_group ibs_mprof_attr_group = {
+	.name = "ibs-mprof",
+	.attrs = ibs_mprof_attributes,
+};
+
+static void mprof_tunables_init(void)
+{
+	struct device *dev_root;
+	int ret;
+
+	dev_root = bus_get_dev_root(&cpu_subsys);
+	if (dev_root) {
+		ret = sysfs_create_group(&dev_root->kobj, &ibs_mprof_attr_group);
+		put_device(dev_root);
+		if (ret)
+			return;
+	}
+
+	mprof_debugfs_init();
+}
+
 static int __init mprof_access_profiling_init(void)
 {
 	u32 mprof_caps = cpuid_eax(IBS_CPUID_FEATURES);
@@ -346,6 +683,9 @@ static int __init mprof_access_profiling_init(void)
 		mw->cpu = cpu;
 	}
 
+	/* Publish the default config before the startup callback consumes it. */
+	mprof_config_init();
+
 	ret = cpuhp_setup_state(CPUHP_AP_MM_AMD_IBS_MEMPROF_STARTING,
 				"x86/amd/ibs_mprof:starting",
 				x86_amd_ibs_mprof_startup,
@@ -356,6 +696,7 @@ static int __init mprof_access_profiling_init(void)
 		pr_err("cpuhp_setup_state failed: %d\n", ret);
 	} else {
 		pr_info("IBS Memory Profiler is available for memory access profiling\n");
+		mprof_tunables_init();
 	}
 	return 0;
 }
-- 
2.34.1


