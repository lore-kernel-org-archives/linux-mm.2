Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8406BC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CCF96B009D; Tue, 28 Jul 2026 01:45:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D216B009E; Tue, 28 Jul 2026 01:45:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51EC96B009F; Tue, 28 Jul 2026 01:45:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 111FB6B009D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:45:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 681AFA0291
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:45:30 +0000 (UTC)
X-FDA: 85037098020.25.1232F26
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012010.outbound.protection.outlook.com [52.101.53.10])
	by imf13.hostedemail.com (Postfix) with ESMTP id 52E1720004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:45:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=MrYozxuv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of bharata@amd.com designates 52.101.53.10 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785217527;
	b=wGcYioDWe5pWLuTzKqWToaHgjQbpaTb4q062FogMgh3WH9IQnyX9fLJEBC8hcSPNVwx3gx
	zYOyITq6E1F4LZlAmyHMr4XBhOwLEnrviaVvIvif0YCe9ZE4qPp7W3rlj98dc+luBCrMPC
	xLUSIxiCrKJmEGNThhT/9DjrDNhj2CE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=MrYozxuv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of bharata@amd.com designates 52.101.53.10 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785217527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGMzkooZA65UU8isagAS2XTW+xDROHZokw6tS/fLUfs=;
	b=4xdiJuzuIr2TUmyuYTgioekHKoQ6kOtXmAS8p9eweGLToIqYLd0wDe70APHMhgdWYCooso
	9dn0sE7OzMyR2jdMnUyGxab8E3n4PD+XyQh12Kpn8HiuiYqKO+S0nPEReK7C44pNytDuk7
	vzX2JYq/W55pxHcvTDc91qA6t7rVKvk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tkmoI0+JAfijwSKBPFBc5SzcdtYfGtMcrh8IHnsYvCsozreQ5D+UJwqm74ocmrYqGGDH2xHAL9BtTxT1FCJSoD+dc9gZd1Oe1BPUjyxmjzjvNgiGcgjd71ll17c6FWK1h7JOKP2IEGebqIYoDQfOgV1UaRs8n8ZYUBa/OTTCeJ4t3puEbhOqDOZv2Wmb4BgQmGsmZIBBPLZ+CUinAVGgD2E/If9dlcJZposQoY7L259hyCQ5epzi4+6raxaDEqU4BzvRc+HzTAHVNXLgVhJG0R9nTo12x+nqvVic7K35rZ7yN9PR/9XbIA1qaFd7t9La3s6dq+0iyqu32JfOj8pxPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UGMzkooZA65UU8isagAS2XTW+xDROHZokw6tS/fLUfs=;
 b=lmwj3Ab8VNvLYiJmy5RW/l0Bk1nGQ2I4wrL/9f6mKM6HI6ix+HA4uWm+ppV3fJZrE3OZHDwX3LB9gQQO4gUMoTMkF+AdnPKPDjaunJTv1jgHCMwAT6GS54wyxAh+eFjrq/ZZIrqLvD5ERayIkOc+Mzurkq0fCmreXNu+eRtQ9uBEGiwPnvpdokS4j0YaDGQs+JKCSdNzWm/5qQH3zpJqrkEW5iZTVHJJCB78hR9MVIDKZ7EGn3cbCagW4gBG/x2tmZ8/wQFjL6doq9QpeJIriYr2GQ/MhIrFOwIpr8hIz2E0PRNg3gs584k10Toj7IIebuGnO+lDJS9k+SyWzTzbvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UGMzkooZA65UU8isagAS2XTW+xDROHZokw6tS/fLUfs=;
 b=MrYozxuvAZi8l9St8Pvw1mvx/obg4wCn7ESvRWHbGK9Sw3IHUBVgSrREnlNZHCmDZqkzvplTegKj6NQF2tC4y/IkssewJt3R6NdfLzd8xnJNEzpClf++VNGhgQ6RKPx/rjuRqrnlp1zOxHq19Ukbn90LIRwuZ3TiqTF+DPBokCU=
Received: from SJ0PR13CA0149.namprd13.prod.outlook.com (2603:10b6:a03:2c6::34)
 by DM4PR12MB8522.namprd12.prod.outlook.com (2603:10b6:8:18f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 05:45:22 +0000
Received: from MWH0EPF000C6195.namprd02.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::f) by SJ0PR13CA0149.outlook.office365.com
 (2603:10b6:a03:2c6::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Tue,
 28 Jul 2026 05:45:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6195.mail.protection.outlook.com (10.167.249.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 05:45:20 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 00:45:11 -0500
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
Subject: [PATCH v8 6/8] x86/ibs: Move IBS caps definitions into its own header
Date: Tue, 28 Jul 2026 11:13:54 +0530
Message-ID: <20260728054356.291998-7-bharata@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6195:EE_|DM4PR12MB8522:EE_
X-MS-Office365-Filtering-Correlation-Id: a02ee25e-a077-4607-da0f-08deec6b6966
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|82310400026|7416014|376014|11063799006|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ixuDVHM5S3iPnuQ7BwQEizXjboi9UnE+1dDPtPBwiu2wXXHHj2EpNOcnrGUDv8q8/QzT0MxwIamSCaxviXQKlwz/oqDYUZb4hH4bwpndwUOqTEWHewZ06Y7vTTvi+zCjooSc+Mpe/zu/GlRFrg48RTcVQqGiClGIdFyUblpditXZmSPDBjopbssWw7SHR2XlJsPibyq7cDwt58UJIxD8+UjVsW1SKGYf1wc59YKDPS+MWEPAmmSDYKZ9C1UTy24nlBvFF+Q7ZBMPqv0DvBgmCPDFsl83Xi+tvX/442fBvYabnEQlU9TgNKARogfWhygStkv31Lx0imVCMRpku0+xlGjh9YJ+/iKQTB92QojVEchpHypo3cSLm5g2uV63XSxRplwTlWEMnoAj8P0j0cLfbxEcQvmEleMF0+I4CRLOnbIwgGRJP00ilrCNVG4lo8CNEbqXxXyiGSl6+zLj/Gl+nkZQzUVW3MsJ22srGKDSXJchiPSTQEgKf5raqhjoQnkl9sgesR9ENEACWTKBjcdBeyNilEzEvrjNYd3JwugLS1V+NDA/EQODxydjvzH5OqvZZWo+dnnIOjKBv66jA7gJUsEJM1S4bbSOryzmEBjCaqFFHgBAzU1qKXaeaiYG46itwfWIKrtZLXw1kaaKPMeRHXMUi60L85kPU3VEM8/3Dlb2llAPQ3pGQJwwRj7mGfMzXDzkoqoDwjQVgEKrHzB6IQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(82310400026)(7416014)(376014)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eRYRGOIOgt2LiXt/YLKaRytF1IPs2TFAZJyHwbSAC6e3EmtbNl1rI+3dWilPuGu0SdiMyy2sH8a3OsXEiBrTjgx/6znBE3lXvxu/xpa9fCkyj4O9j3A4fOLHnhCe/K4anSxNEgV3aYd18UKYblkRoh+s+mqpR1mV/X4poiE0z0/Nms9GLOH1igwg/Tq9DjwcRiYcH/r+sVqSowa/ZuqzU9EjqW0CylVhs7Vy8ZCiWdKF0SBniHTpVNXv52f3TsJN9YZKXs6d9shDmVFyVjZQ8MJNHTjEM9A+BrfuWsW700IEhB52dv/+NxH1HVkomfj5o1orz8esNLHwd8qN5hFhPH/bMLlUskF4/vRIE2a709R3F8jr2NC7dVqYMivlFwbByB5lo47eUXgH9kos73ygg8R3PZTtgo6RtmTNxQkIu1sNcx+IFi5aC4i94pI85m62
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 05:45:20.5855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a02ee25e-a077-4607-da0f-08deec6b6966
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6195.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8522
X-Stat-Signature: oo4bcu4yhynfi3i1bawj8uftq3yxgkk9
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 52E1720004
X-Rspam-User: 
X-HE-Tag: 1785217527-783742
X-HE-Meta: U2FsdGVkX1+4c6fHTnOCX6/peHue4+7rlZqfFzCYjdtXoq9S4V9BphSnlYYq4dt4eNL2fgjeponXnOngc6D1k3hclksu/bOjsnDhjLX/rp+oBU+Y8VeT8LIMRo38eA1MMsSlp7NCy4X7MpH7sIVkNgZYuyRYn/MKQjZTjWa3ZhxD2rS8JVB91ZQH35o02vAMoALa3L7AsEN5nqUeR3NFtdEqEhd2sAxGiE/EpcXrA5qjFwAzyg5jUOTTzFkZEST5t8517iNYJwyxDul3rkSu6XL1NobEyeLcQdkGnF4SHW3cBH3ia04o+HOMHXBUtEjqAX6RlrtzsDd4m5jrw04rKDuqlaSKSVhgxRlM7l2r1JV/5wzW9UaeKFd3ML2cmraWRAkPPVXnjsn2mfb6Vai/V7f0COikNqCgQzbPrTnfv1pB7B6c7CPLiDV+SyM3VNq87xzsoTz9at2HXBC+3SRuEkNG1o+vVUlJe53mCfmr6bINO7wUVuNyqIU/RAcTaMYsgPeffvX+XZ93Xt55PvM+wkdKloIybgmUwsbpg71UVBKg781zC0AZ0Us3v3VrXcZBCL0JpuMp1rGuBrg9suqaQKC6SFSc5hB+B3qaNYyai7nDDMH2SJ7Ip3dN1CYkyLbtFOFW2qAeQliB5z7BGGkVn2UUiOvVBt7Iif0pB4387XmGVFbLsXmpf13g03OlF270ZXIRJG4EFnBzs4R2njeBJcopxpYe2EISTZg9R75gznGX04SH3BgTqcUL+L0o0oJlgISd985RmxRheCP6ixwx4HY2wpD8pMVH0kc4IFwPi39VxVA6jHcHuvnFUbxeiz+H90Bq9qDqty7h5nAhMm7KjGoUsZZrFybwDv76ACiGPqiXcPTUITMljv/G2ZkWAsoZmUXKxJ1VhNxzju4TmhQb7/BUmcswJZEsGr6KRmjNQIqTGPpSHUB6T4GwkA0m1yfZCvSDhzEtER1t6Yn2N27
 t3cldgYC
 TwafoJ70aLi9YYN/m767+5YwYv54AF8nI5pDe45Ds50GIOZU04cWBGAgsMS6Aw7UOUofmrIAMxq4nPuhWHQ/v/4rljmUTmZcMnFBAlIYYEB1zxFBcl2M/i/LHWVavl5r2euFZw6kpcBcUZEmgpmc5kadpnt5eh4L7vHD/I8Yxw9n7weV5W+TB3Ezasief/45S3PnE7m89+NqoSq1gJTuhevBv7SHyRP9qWa6Deh10AKJKiLkxmXdSSxonBNDpyKHYpYAzJVQlT6Fq/hiw4jm+trfNIlb1thBNX94EOEsRF8EkZ+Tnq5xHy4FVpb/qZloq3K78RKiqfnGbap2YQD0zNe5UpE4riFBeVdOQepYxYIToS33YkqKTd7Cb1rHJIpgBPlQh8pIB4X4tod7BTvy3bavfJ4uz7KLcpUGKIamebPYzOtN7dJkpZ7BYmahSn0mYuJbkjssGOhF7wuAzXQvNBGdnCKGiA1tKmhViHHSezG1x8x026p0FoZZ2UHkYy9HDJphiQJgrb3Ni8BVvcz+YnWQ8wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Subsequent patch adds IBS Memory Profiler driver that is
independent of the perf subsystem but needs the CPUID
0x8000001B capability bits. Hence move those bit definitions
out of asm/perf_event.h into a dedicated header so the new
driver can consume them without pulling in perf.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 arch/x86/include/asm/ibs-caps.h   | 85 +++++++++++++++++++++++++++++++
 arch/x86/include/asm/perf_event.h | 81 +----------------------------
 2 files changed, 86 insertions(+), 80 deletions(-)
 create mode 100644 arch/x86/include/asm/ibs-caps.h

diff --git a/arch/x86/include/asm/ibs-caps.h b/arch/x86/include/asm/ibs-caps.h
new file mode 100644
index 000000000000..ddf6c512c8f9
--- /dev/null
+++ b/arch/x86/include/asm/ibs-caps.h
@@ -0,0 +1,85 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_IBS_CAPS_H
+#define _ASM_X86_IBS_CAPS_H
+
+/*
+ * IBS cpuid feature detection
+ */
+
+#define IBS_CPUID_FEATURES		0x8000001b
+
+/*
+ * Same bit mask as for IBS cpuid feature flags (Fn8000_001B_EAX), but
+ * bit 0 is used to indicate the existence of IBS.
+ */
+#define IBS_CAPS_AVAIL			(1U<<0)
+#define IBS_CAPS_FETCHSAM		(1U<<1)
+#define IBS_CAPS_OPSAM			(1U<<2)
+#define IBS_CAPS_RDWROPCNT		(1U<<3)
+#define IBS_CAPS_OPCNT			(1U<<4)
+#define IBS_CAPS_BRNTRGT		(1U<<5)
+#define IBS_CAPS_OPCNTEXT		(1U<<6)
+#define IBS_CAPS_RIPINVALIDCHK		(1U<<7)
+#define IBS_CAPS_OPBRNFUSE		(1U<<8)
+#define IBS_CAPS_FETCHCTLEXTD		(1U<<9)
+#define IBS_CAPS_OPDATA4		(1U<<10)
+#define IBS_CAPS_ZEN4			(1U<<11)
+#define IBS_CAPS_OPLDLAT		(1U<<12)
+#define IBS_CAPS_DIS			(1U<<13)
+#define IBS_CAPS_FETCHLAT		(1U<<14)
+#define IBS_CAPS_BIT63_FILTER		(1U<<15)
+#define IBS_CAPS_STRMST_RMTSOCKET	(1U<<16)
+#define IBS_CAPS_OPDTLBPGSIZE		(1U<<19)
+
+#define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
+					 | IBS_CAPS_FETCHSAM	\
+					 | IBS_CAPS_OPSAM)
+
+/*
+ * IBS APIC setup
+ */
+#define IBSCTL				0x1cc
+#define IBSCTL_LVT_OFFSET_VALID		(1ULL<<8)
+#define IBSCTL_LVT_OFFSET_MASK		0x0F
+
+/* IBS fetch bits/masks */
+#define IBS_FETCH_L3MISSONLY		      (1ULL << 59)
+#define IBS_FETCH_RAND_EN		      (1ULL << 57)
+#define IBS_FETCH_VAL			      (1ULL << 49)
+#define IBS_FETCH_ENABLE		      (1ULL << 48)
+#define IBS_FETCH_CNT			     0xFFFF0000ULL
+#define IBS_FETCH_MAX_CNT		     0x0000FFFFULL
+
+#define IBS_FETCH_2_DIS			      (1ULL <<  0)
+#define IBS_FETCH_2_FETCHLAT_FILTER	    (0xFULL <<  1)
+#define IBS_FETCH_2_FETCHLAT_FILTER_SHIFT	       (1)
+#define IBS_FETCH_2_EXCL_RIP_63_EQ_1	      (1ULL <<  5)
+#define IBS_FETCH_2_EXCL_RIP_63_EQ_0	      (1ULL <<  6)
+
+/*
+ * IBS op bits/masks
+ * The lower 7 bits of the current count are random bits
+ * preloaded by hardware and ignored in software
+ */
+#define IBS_OP_LDLAT_EN			      (1ULL << 63)
+#define IBS_OP_LDLAT_THRSH		    (0xFULL << 59)
+#define IBS_OP_LDLAT_THRSH_SHIFT		      (59)
+#define IBS_OP_CUR_CNT			(0xFFF80ULL << 32)
+#define IBS_OP_CUR_CNT_RAND		(0x0007FULL << 32)
+#define IBS_OP_CUR_CNT_EXT_MASK		   (0x7FULL << 52)
+#define IBS_OP_CNT_CTL			      (1ULL << 19)
+#define IBS_OP_VAL			      (1ULL << 18)
+#define IBS_OP_ENABLE			      (1ULL << 17)
+#define IBS_OP_L3MISSONLY		      (1ULL << 16)
+#define IBS_OP_MAX_CNT			     0x0000FFFFULL
+#define IBS_OP_MAX_CNT_EXT		     0x007FFFFFULL	/* not a register bit mask */
+#define IBS_OP_MAX_CNT_EXT_MASK		   (0x7FULL << 20)	/* separate upper 7 bits */
+#define IBS_RIP_INVALID			      (1ULL << 38)
+
+#define IBS_OP_2_DIS			      (1ULL <<  0)
+#define IBS_OP_2_EXCL_RIP_63_EQ_0	      (1ULL <<  1)
+#define IBS_OP_2_EXCL_RIP_63_EQ_1	      (1ULL <<  2)
+#define IBS_OP_2_STRM_ST_FILTER		      (1ULL <<  3)
+#define IBS_OP_2_STRM_ST_FILTER_SHIFT		       (3)
+
+#endif /*  _ASM_X86_IBS_CAPS_H */
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 1eb13673e889..de18e63c5c3e 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_PERF_EVENT_H
 
 #include <linux/static_call.h>
+#include <asm/ibs-caps.h>
 
 /*
  * Performance event hw details:
@@ -622,86 +623,6 @@ struct arch_pebs_cntr_header {
  */
 #define EXT_PERFMON_DEBUG_FEATURES		0x80000022
 
-/*
- * IBS cpuid feature detection
- */
-
-#define IBS_CPUID_FEATURES		0x8000001b
-
-/*
- * Same bit mask as for IBS cpuid feature flags (Fn8000_001B_EAX), but
- * bit 0 is used to indicate the existence of IBS.
- */
-#define IBS_CAPS_AVAIL			(1U<<0)
-#define IBS_CAPS_FETCHSAM		(1U<<1)
-#define IBS_CAPS_OPSAM			(1U<<2)
-#define IBS_CAPS_RDWROPCNT		(1U<<3)
-#define IBS_CAPS_OPCNT			(1U<<4)
-#define IBS_CAPS_BRNTRGT		(1U<<5)
-#define IBS_CAPS_OPCNTEXT		(1U<<6)
-#define IBS_CAPS_RIPINVALIDCHK		(1U<<7)
-#define IBS_CAPS_OPBRNFUSE		(1U<<8)
-#define IBS_CAPS_FETCHCTLEXTD		(1U<<9)
-#define IBS_CAPS_OPDATA4		(1U<<10)
-#define IBS_CAPS_ZEN4			(1U<<11)
-#define IBS_CAPS_OPLDLAT		(1U<<12)
-#define IBS_CAPS_DIS			(1U<<13)
-#define IBS_CAPS_FETCHLAT		(1U<<14)
-#define IBS_CAPS_BIT63_FILTER		(1U<<15)
-#define IBS_CAPS_STRMST_RMTSOCKET	(1U<<16)
-#define IBS_CAPS_OPDTLBPGSIZE		(1U<<19)
-
-#define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
-					 | IBS_CAPS_FETCHSAM	\
-					 | IBS_CAPS_OPSAM)
-
-/*
- * IBS APIC setup
- */
-#define IBSCTL				0x1cc
-#define IBSCTL_LVT_OFFSET_VALID		(1ULL<<8)
-#define IBSCTL_LVT_OFFSET_MASK		0x0F
-
-/* IBS fetch bits/masks */
-#define IBS_FETCH_L3MISSONLY		      (1ULL << 59)
-#define IBS_FETCH_RAND_EN		      (1ULL << 57)
-#define IBS_FETCH_VAL			      (1ULL << 49)
-#define IBS_FETCH_ENABLE		      (1ULL << 48)
-#define IBS_FETCH_CNT			     0xFFFF0000ULL
-#define IBS_FETCH_MAX_CNT		     0x0000FFFFULL
-
-#define IBS_FETCH_2_DIS			      (1ULL <<  0)
-#define IBS_FETCH_2_FETCHLAT_FILTER	    (0xFULL <<  1)
-#define IBS_FETCH_2_FETCHLAT_FILTER_SHIFT	       (1)
-#define IBS_FETCH_2_EXCL_RIP_63_EQ_1	      (1ULL <<  5)
-#define IBS_FETCH_2_EXCL_RIP_63_EQ_0	      (1ULL <<  6)
-
-/*
- * IBS op bits/masks
- * The lower 7 bits of the current count are random bits
- * preloaded by hardware and ignored in software
- */
-#define IBS_OP_LDLAT_EN			      (1ULL << 63)
-#define IBS_OP_LDLAT_THRSH		    (0xFULL << 59)
-#define IBS_OP_LDLAT_THRSH_SHIFT		      (59)
-#define IBS_OP_CUR_CNT			(0xFFF80ULL << 32)
-#define IBS_OP_CUR_CNT_RAND		(0x0007FULL << 32)
-#define IBS_OP_CUR_CNT_EXT_MASK		   (0x7FULL << 52)
-#define IBS_OP_CNT_CTL			      (1ULL << 19)
-#define IBS_OP_VAL			      (1ULL << 18)
-#define IBS_OP_ENABLE			      (1ULL << 17)
-#define IBS_OP_L3MISSONLY		      (1ULL << 16)
-#define IBS_OP_MAX_CNT			     0x0000FFFFULL
-#define IBS_OP_MAX_CNT_EXT		     0x007FFFFFULL	/* not a register bit mask */
-#define IBS_OP_MAX_CNT_EXT_MASK		   (0x7FULL << 20)	/* separate upper 7 bits */
-#define IBS_RIP_INVALID			      (1ULL << 38)
-
-#define IBS_OP_2_DIS			      (1ULL <<  0)
-#define IBS_OP_2_EXCL_RIP_63_EQ_0	      (1ULL <<  1)
-#define IBS_OP_2_EXCL_RIP_63_EQ_1	      (1ULL <<  2)
-#define IBS_OP_2_STRM_ST_FILTER		      (1ULL <<  3)
-#define IBS_OP_2_STRM_ST_FILTER_SHIFT		       (3)
-
 #ifdef CONFIG_X86_LOCAL_APIC
 extern u32 get_ibs_caps(void);
 extern int forward_event_to_ibs(struct perf_event *event);
-- 
2.34.1


