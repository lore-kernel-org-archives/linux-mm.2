Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74936C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B736B00A0; Thu, 24 Sep 2026 02:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C926B00A1; Thu, 24 Sep 2026 02:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2964C6B00A2; Thu, 24 Sep 2026 02:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2E596B00A0
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:23:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14551120260
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:23:49 +0000 (UTC)
X-FDA: 85247664978.14.23DEB68
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id C95B7180009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:23:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=cp1xArf5;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf16.hostedemail.com: domain of bharata@amd.com designates 40.107.208.48 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790231026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4LWvsFHDDqcH1I+lDAjrpmW0dmMPzVOZCvfxQilqtaw=;
	b=hmSXySjkyj7cg9gzzb5bdVgZ8O+ja4KD526TyZi0P6oeu1Jc0WrBYVuLZlWTL6SdfW9Zbw
	WBaDRqTG7A95CgS22tiMQAknYb7sl5M+GVdxg91D+XyVblZ034wG50ifSmHzvxZBlT6EcS
	20nGnL1pQdIty1RvIm7UP9zDw8sCl1U=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=cp1xArf5;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf16.hostedemail.com: domain of bharata@amd.com designates 40.107.208.48 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790231026;
	b=BZz+T3ey19frO/iDC33+sgIyBmc9n+P3nLkZ+xo4KO4W7so1LJ0NThWeVy8KYCBZQXsFWj
	dU4P4aS0a4g0uXR3BnuiQLpryA3PN2lG5JG7ezNA733s77fywakdmGNdH7bjo44u/Lg7Yg
	zZibcw0flCBzVHKo15XTSp+VEHSgsUc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N7mp/v8P2Gd5T177V+6fT7AikTa6hXiHEao2auu6xJdFDgPd2XmaxK4n6cJcc4+8okE8YIpprwuA0PKpcSvyjUQvSAH5ZhQM3ZZARA01PqY1BdaAEm3v+d5QfilKk4JJ/OYAaH9fouOh8saNFveu3kDxNvYkaqpMvEVNHDV+vCysfP6I5ZTr0zrVhtBhog2CAHtXlK+iXs8p0IYTYEklblSu6Hr/DSwq6amVCcWEPHWRxXi/g1Aj9OTkNi2aF2N/H7bh6YqS+X6nYjJ3Q16b9xjauo+1XE7chfYygqjsKQuRMdTzBG7BhwiX4ZOaEQrj36nDGK+z/WrSHLziLcVCng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4LWvsFHDDqcH1I+lDAjrpmW0dmMPzVOZCvfxQilqtaw=;
 b=bJjP/c21BSnWWTULsBTarFoldVtjhq3J4aVqwWYYEXLKJdwZA6UAGYl6qaGDlsfL7XerCOIxQ35SGy857iwXPn7EBFPAxpnmbPVHKzKcF9lRI32xfgfypIn5CCvpRcFBOQQ3ceqvkGygxlhSLwEvp5TXbE5e6iGnfoaZiZ3OIpbD+MATVn1OCnOGHuU7Pw6xTAUtdHN7n356vgdhw9qjO5f1sZAugbzFmDtg8KYGMJm91+lk/61HdbaLj3LA4YFc1dhRLNdp7uUkNbvbJBm7O9vC690gl9ABhbJkjU5SIM2UYxeI6y0KGzM6BtH2yXkoceuivzuUUaiqmiw36Uw34g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LWvsFHDDqcH1I+lDAjrpmW0dmMPzVOZCvfxQilqtaw=;
 b=cp1xArf59yIki9fqd+ZHjqZ7V3KuHD11OlIhYM8UzYRFzvtDjg6ydLKO2oOTmDeSD9lsbd+Mj+3Vcc3VZ0q8gI9lvi3dRBTB3OTMvzQb/tJGhPNpt0RyqiIfbe0KcVlNFcifG1z9tBi4bVHt/pDmOWyAvy/LPhSD66M/UMnad/A=
Received: from SA1P222CA0002.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:22c::9)
 by DS2PR12MB9776.namprd12.prod.outlook.com (2603:10b6:8:2bd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 06:23:26 +0000
Received: from SN1PEPF00036F43.namprd05.prod.outlook.com
 (2603:10b6:806:22c:cafe::21) by SA1P222CA0002.outlook.office365.com
 (2603:10b6:806:22c::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.17 via Frontend Transport; Thu,
 24 Sep 2026 06:23:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF00036F43.mail.protection.outlook.com (10.167.248.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 24 Sep 2026 06:23:26 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 24 Sep
 2026 01:23:14 -0500
From: Bharata B Rao <bharata@amd.com>
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
	<linyongting@bytedance.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v0 3/3] x86/mm/ibs: Add runtime controls for IBS memprofiler
Date: Thu, 24 Sep 2026 11:52:06 +0530
Message-ID: <20260924062206.319314-4-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260924062206.319314-1-bharata@amd.com>
References: <20260924062206.319314-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F43:EE_|DS2PR12MB9776:EE_
X-MS-Office365-Filtering-Correlation-Id: 1456b221-f90c-4721-e715-08df1a0457bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|7416014|376014|10067099003|11063799006|5023799004|3023799007|6133799003|56012099006|21046099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	XJJknpltDcU46kMgNmgf5ftArRBVAM3DMZXD8woYqql1D/4xE5D0rkJNmbuv9a0Ipa37dkjUVuXv/xUSolk/BsAyTu+AS29SrjTsCuNtHhQE0XHSOqKQKE1LkicRlh6lq9sK4/la+C7K6HLqrvpNjuDTs2kw4VqDZ44Njntoish7LpaqZ7FHBSAxCbrvRKFKWoH6wMhz4uQgE4yC1u3l5J1EOr8j6wrmbHElRMfayTBzevMiZgxWYMTZCyEaGrwi1R9/VHe0OtVZOaBU8y5r6haMfE8Ch5ZyIcnOmm3K1sSG9ADekiHXhEx7SRei9H0FpLhCAilPJtWR8Z1l+0Le4GTCzOHe0DxD8bxZEfrHK5/VdbX5xzoT8h0AyEW1SlO3diXQM5tOEK8SXqLxqMbvOG2mzzyRhSUGLuCXZWgMpOy0AetigOFFqVTNVVA/0wtWE4VO66AyW9qkrLISb32scnnC5K9fV8iSB/gzin9l9AwWBOSq/oyMGWeNaXkKAkOn49HrqYXJaq29N3i5Q/DmufCClhGALGS+0xgYxJUNfoKV/r/wFciymFnDfzzYu3w1VjGH11P3PDuImQuEaF4L23DzO9BX/dda0gI7F35PToA0KxnjmG/aD2QFEmjEOga43PRZh27+CJoxN7q+NLCiSSkRpTkWx1q0n9uw917CdU6U+vdCcC2qZOZIsc+SzttgPKDYmDEwMAFTXOy7uTgHig==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(7416014)(376014)(10067099003)(11063799006)(5023799004)(3023799007)(6133799003)(56012099006)(21046099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cey6VDZULqt7PSxDS4XT4Q9tHLrVSK1ijRdaej22mkLsDHNdKRY5zmH/AiI1LltN8ZeHImKx9aIP090ANW0/b1ns9jfxRqKKHR7yFEp0GAnejmpzHuE7Vg+ccjQKpXLOFbMO4yivg5cUxXCQVsp5xWBndQgq+XTB4iGQKyZqZ7PuysaiCEpzxvR+AE/J2PoSK0SFZiv+JNOui+qfU9TTwP2ak8OwzSagjofyUsl9rlhpWzm+wM1TEkl6uLwq0czdwlBqO0ReYnZnOHC1xKXigB/XPbChHXFLPqr2EL4Y8s0qr3ZP65+CLWU/yL0Il4L6Hq148bT3EY5zSya3celPuZGD3uweU7fwNbEtQEI090cnjRI45U8yr2rc0j1hyrYmv84b/VyBlJwdzyuoIl1Q/A2I26mdgRCczqM2fwPg2rmEhVQeVo0bKIJx536g15jg
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 06:23:26.3361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1456b221-f90c-4721-e715-08df1a0457bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F43.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9776
X-Rspamd-Queue-Id: C95B7180009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ajuawotbu67qgur78m5eyh6dew6ximug
X-HE-Tag: 1790231025-220706
X-HE-Meta: U2FsdGVkX1+M7gnjzvis+XPfzYfAnpUZcnCZh6HUW1jDll9HePZ71pXaoQgeU1Gz4G1+p+M7ChBTuNu9T8Of2VmMUtxYhz54DoAR2SphmrI3notEoqOFmwGHwpSbmuGpnq6lhPnZGyIOQG6ZLXXgHmZKHfdZwxAAy81Tx9GENqyssonnaJdP6WO/P3faZdXxXU9kUFxajWsk8mzWvirVtrvLCJByzEzy643F30PubJ4ay9zjOLjOtT8NW9yP+Pe6irCOPctPDByHek+YUEayZm+O4ebVCJJmD5/Ctv89ViLr5lEqTzbiP1jt8QUpGcmX1JviJAdKgWChIySey5ucEI8GQuoP87SHI3xBFgegEwV2zCGogYyOtcBubT/Nz5jthTegk/N0/gjzglcoQ2bcCY2CCIw+IwPFqYuUVQINou1+HoTTSYX7FQnknRBmKfcqnhQg7XuvUP5vgtxR0tMdCR2+RhRTxSx+D06/yHTHy2OQmGnmcMVht2hx0OZvHYJc7suCt/mcr3KHIiDp5UFwk1yIICEaPE0zB3hQvhflEQQ7de6qqC8wiTjrIbVvvUEIeOteky5Qj6Z+MlycjKi09iw7jNL1MCAd1jy43fnNNPd3Bz1CmRf1QEVopNRgDtE64JRdlSCXOKNL7G1qJ9jKEuarVaS/FYVarW3iuhWudEMJqYzCcGFnuBPCmHDTX3xoDHr6RbRgiXJ8B0sY5v6CHsOudfGq7au0QyF440+zROPZsIFhfwg5IYjYaRcuNXSRb6Sa1o8JMlTEqlnNa1dRZiIl5nRWJF5+a6dKRbtHOhqrwxPSaXsX5JOxT+W8oUJ8oub9ZWwfcEak45iuZbnwyTeoXVYiwIWOUeP9vWXpAptkpxu17lDKD6wKwDvexTYf3pQe8ndA7FsL09puLtEQx/kQ51J9M9shTN763NJW2G7g9/DeHu+FpmZhi3UPRpA9QYgC93pGhl/VayCwWfL
 hQMiifwZ
 79YLBROLIzcRN8r/2hgAya2MRBC6l8JCDhKxL4d1MMJmVbK1nyBIDqq6KNofVyv0u4tg1glqZY9rqxM9sdDyJDaZUf4MwG/yTIExpiUmKp21YLKvr2uxjVl93KETHgWE/UwSAqMWkiGbJdy/GyOuB3BwWQBtY36N7YqXiiPM4TL4LZf86ewWZk+G2FHq/18ysjmRvn2P6a1jHBybzaqCVNdHn7SJR+jtIWu3k/Oz3yXvTBSkozKgk97GeNLc50aHahdrzyerKPOExYZhh2VucjbzR4tyUj0uobHbyJTYAeq3kUwIRbPQEC15R4yJsKeJMF8QMnEselr2n2wBZaelNouzZEuUyovEIme31YCvRxa5zSgpdinZkWotKWxeoHsmwNLu9lv/vuZF7Qki5GCWZqXBSL/V4SLZk2ysaSJugl7MaPLJS7SOop3p+QaK6pq2s65NVljaeGyOFVLsMoKXLOU7NpMfQhQiizLPmeLHg9B7X+eKP8EM1f6CSxNxZ+gQfuM73DZM6QrBJ9RduItUhyvoswg==
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
to enable profiling at boot time.

/sys/devices/system/cpu/ibs-mprof/enabled can be used to turn the
profiling on or off.

Enabling the profiler will result in IBS Memory Profiler samples to
be reported to pghot subsystem. pghot will act on these samples only
if hwhints source is enabled explicilty using pghot/enabled_sources
debugfs tunable.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 .../admin-guide/kernel-parameters.txt         |   5 +
 Documentation/admin-guide/mm/pghot.rst        |  47 ++
 arch/x86/include/asm/ibs-mprof.h              |  14 +
 arch/x86/mm/ibs-mprof.c                       | 415 +++++++++++++++++-
 4 files changed, 466 insertions(+), 15 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd2..3ef091d86c33 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2235,6 +2235,11 @@ Kernel parameters
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
index df8316175207..97142c2558cd 100644
--- a/Documentation/admin-guide/mm/pghot.rst
+++ b/Documentation/admin-guide/mm/pghot.rst
@@ -159,3 +159,50 @@ Path: /proc/vmstat
 
 5. **hwhint_extmem_accesses**
    - Number of external memory (like CXL) accesses reported by hwhints source.
+
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
+   - Range: 5008 to 134217712. The written value is rounded down to a
+     multiple of 16 (the low 4 bits of the hardware IbsMemMaxCnt field are
+     always zero), so a read-back may be up to 15 less than what was written.
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
index 3de1880c4126..5262a77645ef 100644
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
+#define IBS_MPROF_MAXCNT_MIN		5008
+#define IBS_MPROF_MAXCNT_MAX		((1U << 27) - 1)
+
+/* IbsMemLatThrsh is a 4-bit field. */
+#define IBS_MPROF_LATTHRSH_MAX		0xF
+
 /* MSR_AMD64_IBS_MPROF_CTL2 bits */
 #define IBS_MPROF_CTL2_DISABLE		BIT_ULL(0)
 #define IBS_MPROF_CTL2_EXCLUDE_USER	BIT_ULL(1)
diff --git a/arch/x86/mm/ibs-mprof.c b/arch/x86/mm/ibs-mprof.c
index a455fdc60d8e..6f63f18cf474 100644
--- a/arch/x86/mm/ibs-mprof.c
+++ b/arch/x86/mm/ibs-mprof.c
@@ -10,7 +10,14 @@
 #include <linux/vm_event_item.h>
 #include <linux/vmstat.h>
 #include <linux/cpuhotplug.h>
+#include <linux/cpu.h>
 #include <linux/syscore_ops.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/mutex.h>
+#include <linux/smp.h>
+#include <linux/uaccess.h>
+#include <linux/string_choices.h>
 
 #include <asm/ibs-mprof.h>
 #include <asm/ibs-caps.h>
@@ -56,6 +63,41 @@ struct mprof_worker {
 static DEFINE_PER_CPU(struct mprof_worker, mprof_work);
 static int mprof_cpuhp_state = CPUHP_INVALID;
 
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
+static bool ibs_mprof_enabled __read_mostly;
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
@@ -166,28 +208,60 @@ static void mprof_work_handler(struct work_struct *work)
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
+		/*
+		 * Stop the sample generation only; leave the extended LVT
+		 * routed so re-enable does not reprogram the APIC. LVT
+		 * mask/unmask is done by mprof_arm_cpu / mprof_disarm_cpu.
+		 */
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
@@ -199,6 +273,56 @@ static void mprof_disable_profiling(u64 mem_ctl)
 	wrmsrq(MSR_AMD64_IBS_MPROF_CTL2, IBS_MPROF_CTL2_DISABLE);
 }
 
+static void mprof_reprogram_this_cpu(void *info)
+{
+	mprof_enable_profiling();
+}
+
+/*
+ * Publish a new config snapshot and program every online CPU.
+ * Callers must hold mprof_cfg_lock and cpus_read_lock. The latter
+ * keeps the online set stable so on_each_cpu() cannot race a CPU's
+ * ONLINE arm path, which might still be reading the previous slot
+ * as this publish overwrites it.
+ */
+static void mprof_publish(const struct mprof_config *newcfg)
+{
+	struct mprof_config *slot;
+
+	lockdep_assert_cpus_held();
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
@@ -222,6 +346,13 @@ static void mprof_overflow_handler(void)
 
 	rdmsrq(MSR_AMD64_IBS_MPROF_DATA3, mem_data3);
 
+	/*
+	 * If L3 miss filtering is turned off, non load/store
+	 * samples may get reported. Ignore them.
+	 */
+	if (!(mem_data3 & (IBS_MPROF_DATA3_LDOP | IBS_MPROF_DATA3_STOP)))
+		goto handled;
+
 	/* Data source is valid only if the sample isn't an L1 or L2 hit */
 	if (!(mem_data3 & (IBS_MPROF_DATA3_DCMISS | IBS_MPROF_DATA3_L2MISS))) {
 		count_vm_event(HWHINT_CACHE_ACCESSES);
@@ -423,10 +554,245 @@ static void mprof_pm_init(void)
 {
 	register_syscore(&mprof_syscore);
 }
+
+static void mprof_pm_destroy(void)
+{
+	unregister_syscore(&mprof_syscore);
+}
 #else
 static void mprof_pm_init(void) {}
+static void mprof_pm_destroy(void) {}
 #endif
 
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
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
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
+	guard(cpus_read_lock)();
+	guard(mutex)(&mprof_cfg_lock);
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
+}
+
+#define MPROF_SHOW(name, field)						\
+static int mprof_##name##_show(struct seq_file *m, void *v)		\
+{									\
+	unsigned int val;						\
+									\
+	mutex_lock(&mprof_cfg_lock);					\
+	val = mprof_cfg->field;						\
+	mutex_unlock(&mprof_cfg_lock);					\
+	seq_printf(m, "%u\n", val);					\
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
+
+	/* The lower 4 bits of IBSMemMaxCnt are always zero */
+	val &= ~0xf;
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
+	bool enabled;
+
+	mutex_lock(&mprof_cfg_lock);
+	enabled = mprof_cfg->enabled;
+	mutex_unlock(&mprof_cfg_lock);
+
+	return sysfs_emit(buf, "%s\n", str_enabled_disabled(enabled));
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
+	guard(cpus_read_lock)();
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
+static int mprof_tunables_init(void)
+{
+	struct device *dev_root;
+	int ret = -ENODEV;
+
+	dev_root = bus_get_dev_root(&cpu_subsys);
+	if (!dev_root)
+		return ret;
+
+	ret = sysfs_create_group(&dev_root->kobj, &ibs_mprof_attr_group);
+	put_device(dev_root);
+	if (ret)
+		return ret;
+
+	mprof_debugfs_init();
+	return 0;
+}
+
 static int __init mprof_access_profiling_init(void)
 {
 	u32 mprof_caps;
@@ -460,6 +826,9 @@ static int __init mprof_access_profiling_init(void)
 		mw->cpu = cpu;
 	}
 
+	/* Publish the default config before the startup callback consumes it. */
+	mprof_config_init();
+
 	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
 				"x86/amd/ibs_mprof:online",
 				x86_amd_ibs_mprof_online,
@@ -470,10 +839,26 @@ static int __init mprof_access_profiling_init(void)
 
 	mprof_pm_init();
 
+	ret = mprof_tunables_init();
+	if (ret)
+		goto out_hp;
+
 	pr_info("IBS Memory Profiler is available for memory access profiling\n");
 	return 0;
 
+out_hp:
+	mprof_pm_destroy();
+	cpuhp_remove_state(mprof_cpuhp_state);
 out_free:
+	/*
+	 * With ibs-memprof=1 the profiler was armed above, so an interrupt may
+	 * have queued a worker that dereferences mprof_s. Producers are now
+	 * silenced (cpuhp offline disarmed every CPU, or cpuhp_setup_state
+	 * rolled back its arming), so nothing re-schedules; drain any queued or
+	 * running worker before freeing the per-CPU buffer it uses.
+	 */
+	for_each_possible_cpu(cpu)
+		cancel_work_sync(&per_cpu_ptr(&mprof_work, cpu)->work);
 	free_percpu(mprof_s);
 	pr_info("IBS Memory Profiler failed to initialize\n");
 	return ret;
-- 
2.34.1


