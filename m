Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F00CEC01B1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C92F86B008C; Mon, 23 Mar 2026 05:52:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C69A86B0092; Mon, 23 Mar 2026 05:52:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B593B6B0093; Mon, 23 Mar 2026 05:52:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A1A1D6B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:52:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 407AD8CB7B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:52:14 +0000 (UTC)
X-FDA: 84576862188.02.F9B71F4
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013052.outbound.protection.outlook.com [40.93.196.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2426D140004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:52:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ht1q8T5b;
	spf=pass (imf26.hostedemail.com: domain of bharata@amd.com designates 40.93.196.52 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774259531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XjX6f7ME+sRZyfJJIoAT/8vHUdkm8qeEw0Sdf9Rwync=;
	b=F9D0SlkFUdtZaWM5y5JLx39En1cndwoHhipXGbNkYdEw3vTnkyMYfehD2RYzx2aSXom7kt
	qUwJE9Dont7a2YR+8JWqsh/JzoRHcu6fcwz8jyPCweGazKMRJqFZr2eH5fmuXuiSIkzkJ1
	mtZDVPAT1V9ZVMfKvqdyLX+P51A4vdw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ht1q8T5b;
	spf=pass (imf26.hostedemail.com: domain of bharata@amd.com designates 40.93.196.52 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774259531; a=rsa-sha256;
	cv=pass;
	b=1Q63X4vbXuyCHjabJKF0s2x4veyf36OL/Rt5tRm4L9w1G67Swtp6QBVM/MaCHbmmVQJdWs
	GJY+35bJhE18qCOUOJiRPijifVdWfkwJPxVZ+Dl5kHtTXU7gIj8tL89CvzYRmiS1xBspEX
	zmClZiTaTUj9HF5M70L8e2QgKGkr7I4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EFld6Eb36a8GDnkBRGqAw+gqwTK7Vm1o7pUFTksfjj6flrVMbEIgVkxXPtJjAeczEZmVVRHSMy+KagcOZTSvWS09yT8IjUesrv6XQ4wIHKi9fWTamkz5LLByBIpqsCLLn8pFdivViPdoLsoaG1GjoYhnKOnmTJ8AOBO8HfX1e8Gi3kIQZFi428q+3nwJAZ64diVO3L9HOEwLuYBs18aWkIRzvvOgqov8NrACXMxpcBEexAJ0uxQo6jfsPKEM3kcTtWHWD5+SeUkyCcKxQcUWR2NfsNW3dEGJOpfnzUQNKihIvqTAHKAowWdA2tqkwQCqmFmCFLYbAJAg3tm7IvddJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjX6f7ME+sRZyfJJIoAT/8vHUdkm8qeEw0Sdf9Rwync=;
 b=HJQXkvzrQCFIDhuqSpf1I1N+IzcRV//zsaazudqGuYwepFg/y+osnSVxPstZcsqS3NkrZklO8QIPfx+Jmq4XA6qfHllumWFwYwbQPsK+7wVyoICnFZKWuJjzS4tDGQCtaqzYJ/ul9fTArkalTj8yPns+FEKV0rkr3DHvwKZCXxiHz1D91gR4wkQPs4SN3gHBHFzeKIY1pL3Iv++8ZlTWHtjyQrp6Hbc11meqb/KyIdPBl8skvSk1KKwBvpXRJZTziC5DPlTmmMGaJDgf89m9LAexw4L+LaM7g8SG99bGbrbH0dQe2iIZGbjXUebKtk7Ix0A24Mw+xk+AK6ZNj7i2hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjX6f7ME+sRZyfJJIoAT/8vHUdkm8qeEw0Sdf9Rwync=;
 b=ht1q8T5b39D/FbAZqpEhc/9mGhb9qC+8kyALlqUS+vwoTRZQS/xGBajXIv+ABtejVbPacSD0i4XBFOi+lyG1fvluVEmsehnvKpQqfpVgjO2fifntnq2hsOQCTs8bQ+1YJVbZs1alo3Oz15MHWfKMda6vBkJtjCeqXkmXTQuqqHE=
Received: from CH0PR03CA0394.namprd03.prod.outlook.com (2603:10b6:610:11b::28)
 by SJ2PR12MB8955.namprd12.prod.outlook.com (2603:10b6:a03:542::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Mon, 23 Mar
 2026 09:52:04 +0000
Received: from CH2PEPF0000009F.namprd02.prod.outlook.com
 (2603:10b6:610:11b:cafe::8d) by CH0PR03CA0394.outlook.office365.com
 (2603:10b6:610:11b::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Mon,
 23 Mar 2026 09:52:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009F.mail.protection.outlook.com (10.167.244.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Mon, 23 Mar 2026 09:52:04 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 23 Mar
 2026 04:51:56 -0500
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <bharata@amd.com>
Subject: [RFC PATCH v6 4/5] mm: pghot: Precision mode for pghot
Date: Mon, 23 Mar 2026 15:21:03 +0530
Message-ID: <20260323095104.238982-5-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260323095104.238982-1-bharata@amd.com>
References: <20260323095104.238982-1-bharata@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009F:EE_|SJ2PR12MB8955:EE_
X-MS-Office365-Filtering-Correlation-Id: 48b0cb9a-cb46-4b74-0ccf-08de88c1d680
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|376014|82310400026|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	tFZhB1KKUq/J5TpKEs9KWCaC/p4LAnoSoaQgYDpv30QSR36SpxmJQhCNVCIv3bfKS5GPjDILVMwRBu+ZalDmYEUCfb8Qo5SZ+rQROcM2Ht3zZSsaf23bD7WWfoJPlv7Y5RBoSlaoyjM+e593gbOG8ip7XT4XzmsPgkMsk7LUzBb0i5E3tszDmzIEN+4kL3AO9ZW6xaflifSsvI9lo5Z+erSbS41CCdNpXz1uRt69NUHzknQhfx6dPuuaOVxLXKaNY+XlJVp18N8y9Je41UJLvhQeQb/YvaZ3MQaS18tAj1/KKvSFElZ2HDaRhXcRyjdyDQce7yyJfXX5Csw5T/ozs+nkergdhB/gjJKJ3knEyG73YyQFf2spU6h/TSi08cabTPuWiyhQCUjBzDfdXMdl6nrvwQh1i6OWhmAhNzL0Dr9CLdRvu50G9qlefZuV+3QXDsjLqgeRTHPvfeaJmyqpm0/gsm/wrwMgNck/LVsuIJyOG4CBbhVI6M83ViSDe+sQALcMXxXMW1jxZUFJYfJ8lhIxSr+r9/e3JRBTaOua1H+xuzZ6vwqoEycIrQVD3jqWKGcT3QbgZTAxY1lhEQmq3vocLZB9DAv0rmHAqiyQy+hn31M+EgTA8+acJ1+yQsUe6/P5dtzs5QMys8314hAKCGsCNT906wy7bzOAUdVd8QjlpXJ1+uqz0s1mzD7kktFOHq6xxz1ae/YTAiBMf/1gm3u04goKfYxDP8zVM0gs4Phg+kRl0aQMS7xU7I3pmFKn0kxaGq8b4aJ3xnguGsWq7g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(376014)(82310400026)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Z11kkaZMRFydQx/P2cyAL4m7wQjGOOcdpXFSMcqFDSjAsk9CiZifIUbuKR4fNbTltaNtRh18ek7fF7QsdLqSG9HdyFiTNfc/Tst2xcidT7ka21m9Axfv4mEg2mW0g8u81/D3So+9pOnPssgNrwzOpp8WN1opbvPx+mVgEv+CdTJnSj6WCfegFHvEi2V56bbcPbhei1gSfc3so+c9cXPqeEe5kRAvsKR4PFiBlEjuhWfyedivE9JZGiNRyEtxTBnLbLSpRTgLXKDlcokl4lBus/vdKxeLk+B1fBDuPBhupbA7Ka546IJSqou3jxkGYkz20Njc2mqW2/Lp0etEXj6BVzZleHSkFNq6olBjP1HXYaVEd1pYlMMtMPoDMHIedFJpww19zcQg3i6MtD33wbOrQcoRyt9lyTlVHZ6vqgGAforUN8TmlcefEoaPCn6MjBYW
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 09:52:04.1348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48b0cb9a-cb46-4b74-0ccf-08de88c1d680
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8955
X-Rspam-User: 
X-Rspamd-Queue-Id: 2426D140004
X-Rspamd-Server: rspam08
X-Stat-Signature: 8ujooy4itgba5q5b8y3j8rdiw95jbq97
X-HE-Tag: 1774259530-686887
X-HE-Meta: U2FsdGVkX1/EnBrzmc4Pm70vCsV3GPW4i1qaJPgYyEVer2hN2jkV2bOxgV6Zl02kuOr/VPHqlKo8bEoUUhs/zCOu4UbKS5ggSymNgUNDhfsag8HUeo+9B60Uh2Ur2lbDLGYVw8C9cbQOWbKHNBWObd9lQI72hEfrg5A7eKqGiaUwk2UQDJ87RAPYutARL7kLKldjY1ZbuXzaxHuxaYOEE4GItiBDPAjYt5uGkrxot3WYAiL8KAQ9D1lfo9hgfy3VzJcB9+gD4uuJKzzFJLfkVHncyWTRYxKaLUDww5aufnWQXwxElKANogCbZrjms8qhc//rmuQAJEXVTMrHiJPWMUHw4KH4KGoCHBhi4AzLgi68l6YMoIuwK9ql4mHVYdAkmlJx2y49PwYsjwnM3l+Ow2Qpot18CGpx5UtnPCxD85wZFU3Oia/pg00LFTnOsjOY+a3s3m9hh54hF7j8COCOzuf5zPRtv2J5dWsAJPgI/dpZ+DvvDiHYLVfjYq3O0dBxZq0YE+ZWYjZXa/kFRsfga8YdNsO/XIEhuRehw3tcvkVxh+rEOUCsPJjU4iywV27HmpLsLgkPix9asF/hBGckXgDCDRStNNJi1qpx6pddRYBTgms8dUEO/Unc1KoR0RmufktSaH6toABmJQAeB7RLEZy30t1QR/yh+pfbaKZROOMqqc+GmDnEaX293c5xr88DmKAMY2e4D4pniDmXxeL46Vkpqev8fl1QqRgZGdWWR1nGCkz30EqPRxfqvUL2DiWLn8Eq/2G2ChHK6kUOlNiSFo1vE0/D30Sj1KMHqA3yGDa1+h976x/Is8+7ecwDkM0uvfqA0HTsou/wACQX5if4wAriOFcaL1QW3EZIA0CLqD9z2eeb6g8LBOQwWg8B1p7RVpF6W2Ldrr1TViiYdF/tr3GQvrefaciL1+uPft+esPtw+ActSc8HBP1Hlx1WrFnCfrepi8gCNiZyols/0vF
 0QDFeo2N
 woP+I2MV4hQTnjZhry6ei8+JZAnluE9oG6CYyS6NVi9JuFBGyJSTDF3Lp+xUd6y6mLCmqHVKlJAb0tcq5/zd8H0CjnDGXNnIwwXgbQj3eYZg23qhUilj69+G5WLr4kzT01sdt+0iOQZW9dmBvl4Ttpc8c6dpnXE+QR9QyVwlpfyaCVLDL6psP80jafL2H3/hEw9cmNzZ22nfcJweM/qV0jB5z6ryEOhWPQFer51cOHlaU/1E9YWtIq3biDJMTJ24XhJNvb8WAX8WRqt79lFB5NJvzoXKEViFznAieCTejSWwg1Lj4yiMybRxAb3LeGJToxYlilHM7RE5zGKQDfgrOuSx1LR0/wcLQ1BzMabWFX5QwpH/nsREB1wl+Vb/AYPxjlJyJt8xcc72LBgksb1PUASbiFFdsMXwBLXs5C1QW9Sl3vL/E070JPFmR1yGf7Ex4GkGxbmAJ/q7kqISBtj0RyNEe9CgWI5xhA8s95e4rxXh8C3hkDpFj/bJycLdF8GcReQwaOSuYCMu0iMk3XXsZRqx4/huaDXAjNHHZHsqlc4R8hw6mZ2LvVydzsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Default pghot stores hotness in a 1‑byte record per PFN, limiting
frequency to 2 bits, time to a 5‑bit bucket, and preventing storage
of per‑PFN toptier NID. This restricts time granularity and forces
all promotions to use the global pghot_target_nid.

This patch adds an optional precision mode (CONFIG_PGHOT_PRECISE)
that expands the hotness record to 4 bytes (u32) and provides:

- 10‑bit NID field for per‑PFN promotion target,
- 3‑bit frequency field (freq_threshold range 1–7),
- 14‑bit time field offering finer recency tracking,
- MSB migrate‑ready bit.

Precision mode improves placement accuracy on systems with multiple
toptier nodes and provides higher‑resolution hotness tracking, at
the cost of increasing metadata to 4 bytes per PFN.

Documentation, tunables, and the record layout are updated accordingly.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 Documentation/admin-guide/mm/pghot.txt |  4 +-
 include/linux/mmzone.h                 |  2 +-
 include/linux/pghot.h                  | 31 ++++++++++
 mm/Kconfig                             | 11 ++++
 mm/Makefile                            |  7 ++-
 mm/pghot-precise.c                     | 81 ++++++++++++++++++++++++++
 mm/pghot.c                             | 13 +++--
 7 files changed, 141 insertions(+), 8 deletions(-)
 create mode 100644 mm/pghot-precise.c

diff --git a/Documentation/admin-guide/mm/pghot.txt b/Documentation/admin-guide/mm/pghot.txt
index 5f51dd1d4d45..7b84e911afe7 100644
--- a/Documentation/admin-guide/mm/pghot.txt
+++ b/Documentation/admin-guide/mm/pghot.txt
@@ -37,7 +37,7 @@ Path: /sys/kernel/debug/pghot/
 
 3. **freq_threshold**
    - Minimum access frequency before a page is marked ready for promotion.
-   - Range: 1 to 3
+   - Range: 1 to 3 in default mode, 1 to 7 in precision mode.
    - Default: 2
    - Example:
      # echo 3 > /sys/kernel/debug/pghot/freq_threshold
@@ -59,7 +59,7 @@ Path: /proc/sys/vm/pghot_promote_freq_window_ms
 - Controls the time window (in ms) for counting access frequency. A page is
   considered hot only when **freq_threshold** number of accesses occur with
   this time period.
-- Default: 3000 (3 seconds)
+- Default: 3000 (3 seconds) in default mode and 5000 (5s) in precision mode.
 - Example:
   # sysctl vm.pghot_promote_freq_window_ms=3000
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d7ed60956543..61fd259d9897 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1938,7 +1938,7 @@ struct mem_section {
 #ifdef CONFIG_PGHOT
 	/*
 	 * Per-PFN hotness data for this section.
-	 * Array of phi_t (u8 in default mode).
+	 * Array of phi_t (u8 in default mode, u32 in precision mode).
 	 * LSB is used as PGHOT_SECTION_HOT_BIT flag.
 	 */
 	void *hot_map;
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
index 525d4dd28fc1..2e1742b8caee 100644
--- a/include/linux/pghot.h
+++ b/include/linux/pghot.h
@@ -35,6 +35,36 @@ DECLARE_STATIC_KEY_FALSE(pghot_src_hwhints);
 
 #define PGHOT_DEFAULT_NODE		0
 
+#if defined(CONFIG_PGHOT_PRECISE)
+#define PGHOT_DEFAULT_FREQ_WINDOW	(5 * MSEC_PER_SEC)
+
+/*
+ * Bits 0-26 are used to store nid, frequency and time.
+ * Bits 27-30 are unused now.
+ * Bit 31 is used to indicate the page is ready for migration.
+ */
+#define PGHOT_MIGRATE_READY		31
+
+#define PGHOT_NID_WIDTH			10
+#define PGHOT_FREQ_WIDTH		3
+/* time is stored in 14 bits which can represent up to 16s with HZ=1000 */
+#define PGHOT_TIME_WIDTH		14
+
+#define PGHOT_NID_SHIFT			0
+#define PGHOT_FREQ_SHIFT		(PGHOT_NID_SHIFT + PGHOT_NID_WIDTH)
+#define PGHOT_TIME_SHIFT		(PGHOT_FREQ_SHIFT + PGHOT_FREQ_WIDTH)
+
+#define PGHOT_NID_MASK			GENMASK(PGHOT_NID_WIDTH - 1, 0)
+#define PGHOT_FREQ_MASK			GENMASK(PGHOT_FREQ_WIDTH - 1, 0)
+#define PGHOT_TIME_MASK			GENMASK(PGHOT_TIME_WIDTH - 1, 0)
+
+#define PGHOT_NID_MAX			((1 << PGHOT_NID_WIDTH) - 1)
+#define PGHOT_FREQ_MAX			((1 << PGHOT_FREQ_WIDTH) - 1)
+#define PGHOT_TIME_MAX			((1 << PGHOT_TIME_WIDTH) - 1)
+
+typedef u32 phi_t;
+
+#else	/* !CONFIG_PGHOT_PRECISE */
 #define PGHOT_DEFAULT_FREQ_WINDOW	(3 * MSEC_PER_SEC)
 
 /*
@@ -61,6 +91,7 @@ DECLARE_STATIC_KEY_FALSE(pghot_src_hwhints);
 #define PGHOT_TIME_MAX			((1 << PGHOT_TIME_WIDTH) - 1)
 
 typedef u8 phi_t;
+#endif /* CONFIG_PGHOT_PRECISE */
 
 #define PGHOT_RECORD_SIZE		sizeof(phi_t)
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 4aeab6aee535..14383bb1d890 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1485,6 +1485,17 @@ config PGHOT
 	  This adds 1 byte of metadata overhead per page in lower-tier
 	  memory nodes.
 
+config PGHOT_PRECISE
+	bool "Hot page tracking precision mode"
+	def_bool n
+	depends on PGHOT
+	help
+	  Enables precision mode for tracking hot pages with pghot sub-system.
+	  Adds fine-grained access time tracking and explicit toptier target
+	  NID tracking. Precise hot page tracking comes at the cost of using
+	  4 bytes per page against the default one byte per page. Preferable
+	  to enable this on systems with multiple nodes in toptier.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 33014de43acc..dc61f4d955f8 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -150,4 +150,9 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
-obj-$(CONFIG_PGHOT) += pghot.o pghot-tunables.o pghot-default.o
+obj-$(CONFIG_PGHOT) += pghot.o pghot-tunables.o
+ifdef CONFIG_PGHOT_PRECISE
+obj-$(CONFIG_PGHOT) += pghot-precise.o
+else
+obj-$(CONFIG_PGHOT) += pghot-default.o
+endif
diff --git a/mm/pghot-precise.c b/mm/pghot-precise.c
new file mode 100644
index 000000000000..9e8007adfff9
--- /dev/null
+++ b/mm/pghot-precise.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pghot: Precision mode
+ *
+ * 4 byte hotness record per PFN (u32)
+ * NID, time and frequency tracked as part of the record.
+ */
+
+#include <linux/pghot.h>
+#include <linux/jiffies.h>
+
+bool pghot_nid_valid(int nid)
+{
+	/*
+	 * TODO: Add node_online() and node_is_toptier() checks?
+	 */
+	if (nid != NUMA_NO_NODE && (nid < 0 || nid >= PGHOT_NID_MAX))
+		return false;
+
+	return true;
+}
+
+unsigned long pghot_access_latency(unsigned long old_time, unsigned long time)
+{
+	return jiffies_to_msecs((time - old_time) & PGHOT_TIME_MASK);
+}
+
+bool pghot_update_record(phi_t *phi, int nid, unsigned long now)
+{
+	phi_t freq, old_freq, hotness, old_hotness, old_time;
+	phi_t time = now & PGHOT_TIME_MASK;
+
+	nid = (nid == NUMA_NO_NODE) ? pghot_target_nid : nid;
+	old_hotness = READ_ONCE(*phi);
+
+	do {
+		bool new_window = false;
+
+		hotness = old_hotness;
+		old_freq = (hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+		old_time = (hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+
+		if (pghot_access_latency(old_time, time) > sysctl_pghot_freq_window)
+			new_window = true;
+
+		if (new_window)
+			freq = 1;
+		else if (old_freq < PGHOT_FREQ_MAX)
+			freq = old_freq + 1;
+		else
+			freq = old_freq;
+
+		hotness &= ~(PGHOT_NID_MASK << PGHOT_NID_SHIFT);
+		hotness &= ~(PGHOT_FREQ_MASK << PGHOT_FREQ_SHIFT);
+		hotness &= ~(PGHOT_TIME_MASK << PGHOT_TIME_SHIFT);
+
+		hotness |= (nid & PGHOT_NID_MASK) << PGHOT_NID_SHIFT;
+		hotness |= (freq & PGHOT_FREQ_MASK) << PGHOT_FREQ_SHIFT;
+		hotness |= (time & PGHOT_TIME_MASK) << PGHOT_TIME_SHIFT;
+
+		if (freq >= pghot_freq_threshold)
+			hotness |= BIT(PGHOT_MIGRATE_READY);
+	} while (unlikely(!try_cmpxchg(phi, &old_hotness, hotness)));
+	return !!(hotness & BIT(PGHOT_MIGRATE_READY));
+}
+
+int pghot_get_record(phi_t *phi, int *nid, int *freq, unsigned long *time)
+{
+	phi_t old_hotness, hotness = 0;
+
+	old_hotness = READ_ONCE(*phi);
+	do {
+		if (!(old_hotness & BIT(PGHOT_MIGRATE_READY)))
+			return -EINVAL;
+	} while (unlikely(!try_cmpxchg(phi, &old_hotness, hotness)));
+
+	*nid = (old_hotness >> PGHOT_NID_SHIFT) & PGHOT_NID_MASK;
+	*freq = (old_hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+	*time = (old_hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+	return 0;
+}
diff --git a/mm/pghot.c b/mm/pghot.c
index dac9e6f3b61e..7d7ef0800ae2 100644
--- a/mm/pghot.c
+++ b/mm/pghot.c
@@ -10,6 +10,9 @@
  * the frequency of access and last access time. Promotions are done
  * to a default toptier NID.
  *
+ * In the precision mode, 4 bytes are used to store the frequency
+ * of access, last access time and the accessing NID.
+ *
  * A kernel thread named kmigrated is provided to migrate or promote
  * the hot pages. kmigrated runs for each lower tier node. It iterates
  * over the node's PFNs and  migrates pages marked for migration into
@@ -52,13 +55,15 @@ static bool kmigrated_started __ro_after_init;
  * for the purpose of tracking page hotness and subsequent promotion.
  *
  * @pfn: PFN of the page
- * @nid: Unused
+ * @nid: Target NID to where the page needs to be migrated in precision
+ *       mode but unused in default mode
  * @src: The identifier of the sub-system that reports the access
  * @now: Access time in jiffies
  *
- * Updates the frequency and time of access and marks the page as
- * ready for migration if the frequency crosses a threshold. The pages
- * marked for migration are migrated by kmigrated kernel thread.
+ * Updates the NID (in precision mode only), frequency and time of access
+ * and marks the page as ready for migration if the frequency crosses a
+ * threshold. The pages marked for migration are migrated by kmigrated
+ * kernel thread.
  *
  * Return: 0 on success and -EINVAL on failure to record the access.
  */
-- 
2.34.1


