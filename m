Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A822FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 06:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0306B009B; Mon,  4 May 2026 02:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9FC06B009D; Mon,  4 May 2026 02:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68906B009E; Mon,  4 May 2026 02:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92A036B009B
	for <linux-mm@kvack.org>; Mon,  4 May 2026 02:11:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 261861C12BE
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:11:02 +0000 (UTC)
X-FDA: 84728714364.19.E561B12
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012067.outbound.protection.outlook.com [52.101.43.67])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1593940005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:10:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=P+XkzWeB;
	spf=pass (imf27.hostedemail.com: domain of bharata@amd.com designates 52.101.43.67 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777875059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYTG/OTUAyUKj0dzPu1bSgtDGQVrm42SWt0V2KXT838=;
	b=3p+oayy8K0iE0JCwYfkfxqZs8P5v6llol41cu4kM7hcI7PSB18+yVQzOdY3dCX1q38e+3g
	qQBpbC+lH39FIdEnBHR9y/wYcBLaA5ZC3TQYbtOOa/1RurUHGJCo2Q07eV6gALhG3ozxnD
	FZ/i+SfsZ1x/tDJ9wGUMl4y6AjvZQwo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777875059; a=rsa-sha256;
	cv=pass;
	b=J88PlGuCteCRHQndkNWxpMk+xJantFPZwXMp0pZV0Sa36BDd/MuAUTfKEyXQlAkikS2pd4
	Ug7wnHRX3ZMGxCj/C7JEHS/EEgVuC6gdN+/me04iY/rnnUJJ/438gvxfeqMHIqKxu3wXwN
	rr6+zpHdGsXKV5N+JtfyC9hx9f3Yr5I=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=P+XkzWeB;
	spf=pass (imf27.hostedemail.com: domain of bharata@amd.com designates 52.101.43.67 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zk112YuWslE7EM5Nmn8irlt9UcV4+JyZKOzm7dvPG+RLAV+I3V48FGNKBGgKIYB/Xvc5K0AaV+y73fJTxc+OiMHlKO1xtyc6abPFsfHU2SGgD/ra5oSHzGSx29sqOhMeeLW6o+HsfMSpWcJOzUdhixGd84eii4Ffq2K5vvpsuRetjIFjQIDjaBgJ0gFQox/avaH6s0NDniRDhdH9lR/CKKbhU8thsHMJpJ5f7KBvr2zxhIF/hG5xXPLGTQJLEY00RlCI980P9EknU702BV/f4CeiV9dB/vGvWba5mzXdZfFMxfZgR3unUPldpCdnJRTLpFo7k4t1goiZNTXVICmSyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYTG/OTUAyUKj0dzPu1bSgtDGQVrm42SWt0V2KXT838=;
 b=C99+eeoKeHsudtbFwGeras24uOZOdHfBbXG6OYI0hyNgQLJRq0vToCrTxX0e5j3vlZvUluqtU2zzd7AzgQOm2l6SyuX7EYa38GqHEy3d5FYBjRShokeYqxCwARwuTjkp4VRFonCDuBLq0uL7mJjpJZa91PRp4tRmNqxBTvaFgvodk+OZNdv+l5fEyNj+LhXnUxlieeHJnzWII4+CIZF+GPG6IlB+yK/eg9CMXszjC2EVpsZxRk3woOaE2vfHLQAajq5zmO0SdSpKweEM1/vvYoRKh0lkbb/p+d2RP2CVhmZ98B5w4LdtGOm9O0/5fPPGdDnPvvxMosbdthzKXdVULg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYTG/OTUAyUKj0dzPu1bSgtDGQVrm42SWt0V2KXT838=;
 b=P+XkzWeB6T/CXBINExpiiwhBt9jaajh10QeO2Ntfqnzconut4y3Wa7Wo+JbNBTNUi3syVlsSWoTd+nheGk++0x55gfPP4z387PgICPYTzAyoVZi6UgzDvBS5tD3AtMPZMXCpltoKi5CqfbzJNCI0sDpHJHNqp/2SJvDxSntM1R4=
Received: from CH0PR07CA0027.namprd07.prod.outlook.com (2603:10b6:610:32::32)
 by LV8PR12MB9136.namprd12.prod.outlook.com (2603:10b6:408:18e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 06:10:52 +0000
Received: from CH1PEPF0000AD77.namprd04.prod.outlook.com
 (2603:10b6:610:32:cafe::32) by CH0PR07CA0027.outlook.office365.com
 (2603:10b6:610:32::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Mon,
 4 May 2026 06:10:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD77.mail.protection.outlook.com (10.167.244.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Mon, 4 May 2026 06:10:52 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 4 May
 2026 01:10:44 -0500
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
	<shivankg@amd.com>, <donettom@linux.ibm.com>, <bharata@amd.com>
Subject: [RFC PATCH v7 6/7] x86/ibs: Move IBS caps definitions into its own header
Date: Mon, 4 May 2026 11:39:23 +0530
Message-ID: <20260504060924.344313-7-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260504060924.344313-1-bharata@amd.com>
References: <20260504060924.344313-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD77:EE_|LV8PR12MB9136:EE_
X-MS-Office365-Filtering-Correlation-Id: c2fc3d3e-332c-45ae-24dc-08dea9a3e571
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|7416014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	EGsF39yZsm1Udj8qqm8QSkq+CGOIcy/VkztoH3IyTmdqG2t7mZwwWZzyr+hcBxe5LuDOoQRl7wH3/hrBoMkgS3cpPjE3mSJHYeDsAtkmnFsH/UgeHyJLta3JQM21/GMakUVCOCEvzyhjI/zYtq1iYNUhhuzmNj2Nd6TnGj1ISmIKKmJfIl9PIrH2vNQ7fYUXR3jz75FJ2O0HCZS1QB0oNQfKS/0wI/HJynnNswsA/tq1Xy/RhJ9bSeUXpICUZuP5LXgu4QEuN9swbiPb5TFY+1PYQ08SWOWtOgGV3UppcANz3NixGNZrgmGk5JARUPSKNYZZvisn80XuM9wYePHw6vc51WFne+YcPliqvXffDRtzKJ/ksw+XJdtNKqaD77QRhUXmEg2FMk4JWY2p4z4CRzPmB9K9+FbC4dm93LJMSc9omls0yWOtzBXxC6eb0fsCtSjRmPA3xaxbCHAWsUgQTCnLjUnOGshBpkyR7FKWT0J1KOutrf5W7QNX/4vtryDlpU/7xxLhZI8JIv8Dqi7FV/5ClH0MUzXxGn1UfEKYUddbMD5bW3D/nq8oercygXHFnKswltTkF8xla1Ey5iMx0E0r4LwfgCPZa0QGRlogo+0U4kHZt4H2asOqKjRmYPREKwszqvYoVzwhdFwf9TIhQajIg8ugzhdKMHQsePDrC4QiIeozyB+eSbIrJ7zFx83NfGgu6tCZZrvWSavs/zZTdK6V3L684Xdt6YW5ufbYeJw=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	T8/jKitmOrxMkdGHGfcPsLtE7qFKx54oigHH0t9XO1mMw01QRCc1Ku6alhuM5WM9apiXbkJqES1R79TXe3RxA+D6C0tDQDKUCQkczep0dAMBGMz4XFC51lTYIFiHQMADZs10pnb0zBA8rTsh/r47qaFkqoU3sevuxnWLQH0v/NGjCeJjtnkLwQnKOJWnOIs3Puiw0vBnYyEdZSL9PlLy4SgWUm6t67C9wcUh1lMNCY/zP5ZC+CO1nQouKReYyBQRb4INWf83E8CRC+WVKScgl+eKnLUnkBv2ukuoswUHjTlTRQQei+cZtv5Yp0xB84UrEjQb0m1SsocebZpx623R5OJ1MVQdmXpYijXDBG6XFIDb3NJK0wF9itDUos4V2hRF9m3x+iBR1rfIIaK+ftXh4wOo8EPaEKFb/8+9rbu7nLmT1Lta4NeoSKnOh6X73zdE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 06:10:52.6723
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2fc3d3e-332c-45ae-24dc-08dea9a3e571
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD77.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9136
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1593940005
X-Rspam-User: 
X-Stat-Signature: nk64suy4u7e8nkfmspi1imsazqp7pepu
X-HE-Tag: 1777875058-440916
X-HE-Meta: U2FsdGVkX1+Xt9ycSHT/3QB/3ULHL+eCezdFolvNs3yb6039TRvcxVOD29xdzob6eFBXgdpLe6ZupOYPUSrm//2PAp4y/oJAE3giNCvuo5Az3/uFmuMWv8ao5NQu33uDch03W99PJPmXfpZpjCiu/4tyU4Lr2kkuREEV9NLzWK+Zn/gBA1FwWpt5FSPXKcWSHMEJ2Vu4V7yx4tep2bJoxKmy3HQFVGBP74RGGhmL1XTEjovQGT7YZcEI/gAiRxlhe3fnKj7y/gXeQl2AXkiLR/8aegyfoazLXBnPV7e1RAWhsg2xXtyXsGtvkYn53dawRoethNZss7YCaqwyvgm7g84gnqHWqBRO9Gn8IvFZLkYoED8cZzkqW8IxibAAJps4o2ULg/KQLc19QOBOpRk1QxxyhLa3O+PNNS4y6XBUghBdxCVFfRSu0TX0JAV70HXht+ao1Ame33NGmMIG73sYWLKm/xX/sNGZXn4JEiyJebKHyWQW9quHiH/jaIjPtMSTamne4kzcueeY9ALRqxT5o7+XHqu3vq+Vaqqh7hq/8qvpKS970+g9/d1b37uAaTotx3xsixBU3V2AKJNYz1gwpGkk+FlaNuxabFRC0SiEshL581hsxktqJmunqm8zs0I1+rEt8ipPRqNhOTA0O7xR2TU/HT5jnungFiOhfa2fc5L3k9OZVGWI9Zhrys1tBhs6nR4c2hqiq5b8QRBHBOYxZE3Yp8ZZNTu8NJy5BA4rd7W/UsCEiEo82D6FhaV3BJGzT5WK//8O4nsb7mQB9RFBYBBlB2QKLjOO7B64uJQ9S7WnkEw6y2Hb9Xm84gBkaJeFYfjfEQ2Y8/u5bdiaVxBTGRgm4n42Vc1DoDi/LgdEjFFUhxZkhrW3bR2pkmNo8rWAofpfr7ZaBm5b2sWEp7rnHHcsRUTZ1GMMIYqD6g/k5HNu6BZHMagPm4RwfgeuIM57QydV7175cia5egSYtfy
 OMH9s9UJ
 HR7d7rg2V/i4RwmmZlMNI/RVaKzLa1PZlXyWhV/zd8NbwpWZK/auSN90XnyzhbUneKhMk+FOsMNgBr9oer48iGx0/AK/96WBAt0GluCraAmqBbu1y7cnDlZUUqMo8hYcQxgoVWxc8qgtoDVvTzCDHCSrwMxn/PINm8lmBcoV9vAU2+wdO4ifkY/pt/8V9gV2wA9+JQJQYQOgjXyXHXGoGkA7Lb35ep8+dw9Iuj3cgoeHMaGV20253Nojls96iACY7zFvrMxmalL2Hqm6RSZRY2tjxCRs2DAbzmL2jAhITuuVj+8hms0lhOBUL61sAD9XM3rmxcK/pIRlir7hlPRCHe6syGRWqj2FcNS98RmJgOAywV/iyO654AMXTXZadRK7dv5A040ofmh4oXB70Zv67Q7wdlUlLDSL2j19uC310fUEGXeCxYoglTDlGpgwQ+kXvNrU4WTUmuuJ9bGQ3ft/CkCuRIWY9TwEpqdWg2TxT9C13WwTzCDJ+gmDVnN+KF5gKHlYS1QuhFpIrSCUh5yF3BVVWWQ==
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
index 752cb319d5ea..655a54c77f4e 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_PERF_EVENT_H
 
 #include <linux/static_call.h>
+#include <asm/ibs-caps.h>
 
 /*
  * Performance event hw details:
@@ -620,86 +621,6 @@ struct arch_pebs_cntr_header {
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


