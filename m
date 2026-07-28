Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1E5C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:45:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B17E6B0088; Tue, 28 Jul 2026 01:45:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B506B0098; Tue, 28 Jul 2026 01:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E452D6B0099; Tue, 28 Jul 2026 01:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEB856B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:45:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3F7DC14024E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:45:17 +0000 (UTC)
X-FDA: 85037097474.30.6BAFD5D
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012042.outbound.protection.outlook.com [40.93.195.42])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3A422160004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:45:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FIiCvHec;
	spf=pass (imf08.hostedemail.com: domain of bharata@amd.com designates 40.93.195.42 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785217514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6rRxyL4qLZXnhf9S9UPhYTd3mUQg2kCVdp/Q5sfyuc=;
	b=PR9t3ly1U66KlzJgHIIsOc5TaKs7n1cMSkaT9Kxzz6QG2HuyPXDj+I8f9Xd3MdqWDQ+szI
	LHdh2AS7GFOhjZLH0QZoVRaKn+og+PvvmRFU+cSJXBP96I+gay+vEWhkuVPiz2NvO3DbYs
	0UJQniYcgonLBeKDIIu97/DlMXFGwGM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785217514;
	b=om9MBzt/FmTftkVlf/IN0GgS7y7I/2wqVI51W55GBDB1cSVPMid5jUjp4Hx7Db3x1pJBDj
	N1NbZqxV0uznWwVzErdIsVcmD1t2kyGfXVnc7yOXped41xW4+ZUYpvFXylhVTbyvytnXFy
	KqCNalEeommAq0UpL/i1PyebWT1vhoQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=FIiCvHec;
	spf=pass (imf08.hostedemail.com: domain of bharata@amd.com designates 40.93.195.42 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rsGlucdkuzzw+Jh4RYaU65D1LcbPDaEkOfaBNLlHm36M/xXIsnSa/9v4k1JJU932WC9adv/uxKcQFeqUa1FkEfKkO5TtDZVH/QYLHOaFJozvq/9HBW+dwtlPO8jWnX1e+l44jOs9CIE+etAh20WLcURvdISWtGgJ24judR1sANEcSbzlNdSuYjTfHAk+Wu6oEfzQOpZM7UNer1T/x+JlF+oReY+8QFG92EsYGZpO5G7CLyTbbICbDxefnuc5SdoJ+cveeKM7NkLEr4uyt1NpWd2IvBgQZ38RZgrYXEGTwBhBlVBaE+XMvQHquacrbgIOaUwbpA1gN6ZMx1z7OLRUCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6rRxyL4qLZXnhf9S9UPhYTd3mUQg2kCVdp/Q5sfyuc=;
 b=AB7HRBHsugAKQsomBUW6KMnEYo3qfjYhs1TyomgngwjOJw8dip+z77VhziiIcU0RjKe0pOzW0xgqJvRpSDPbBwGkjTio116xzpa9c49MYXNcrsLRy040tMjzb/wfuj1SICLmV15mNu01gZv6OpS88uR2un7v7I5Fu9Meh0TH4cJYZ5FSlz6IKqg6eIkpMaseT5sIxXas9FPBioeMKSu21bGlQOzmx1SnJ0O2erh4Pox/BfozliDViyVkv3g9SaplaXI+67RyVG+X51MPKd7CuFq/ojxPbjWrs7GVzxp0WkqzhVCkdCXoXOAY41aVeztKGW03wteb43of5+W1l11eyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6rRxyL4qLZXnhf9S9UPhYTd3mUQg2kCVdp/Q5sfyuc=;
 b=FIiCvHeco9oLVwjoS8kVbebqtb2DfQyq60Q7B8guCY1mhpIvgl6zlDjRywxuGFt12VX6fwG1Ww/ZlQux4+V3aXVe3kHFBS19ZcBFf0iL98Skt7zSwJfcNKHEtOWpDQntkwpDZzgBc0iwn1aXn+JjaIeJpPc/o8S10ZdnWzuQlo8=
Received: from BY1P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::14)
 by SA1PR12MB8742.namprd12.prod.outlook.com (2603:10b6:806:373::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Tue, 28 Jul
 2026 05:45:05 +0000
Received: from MWH0EPF000C6194.namprd02.prod.outlook.com
 (2603:10b6:a03:59d:cafe::41) by BY1P220CA0001.outlook.office365.com
 (2603:10b6:a03:59d::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Tue,
 28 Jul 2026 05:45:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6194.mail.protection.outlook.com (10.167.249.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 05:45:04 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 00:44:55 -0500
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
Subject: [PATCH v8 4/8] mm: pghot: Precision mode for pghot
Date: Tue, 28 Jul 2026 11:13:52 +0530
Message-ID: <20260728054356.291998-5-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260728054356.291998-1-bharata@amd.com>
References: <20260728054356.291998-1-bharata@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6194:EE_|SA1PR12MB8742:EE_
X-MS-Office365-Filtering-Correlation-Id: c7747adb-2f02-43b9-9e26-08deec6b5ffb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700016|1800799024|23010399003|22082099003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	jg227vkeIRoTJFbrN2MdRLmFS15R3TUQ/rNy5WQOxgr3anv1cZKnVA0HJBzUKysgbi96lW852MujKf0rVvtDnz7PiqAmWW6but8cMR7YuuwycRJsNQCYiH48u0lpcWV29ohdLF+qq5XoxCE9bts6Hf7+VMwbh49K4hE6jmZ3URFbmofBfF7Ad/ZS0cstQ24ph4Z/h2PXtkQDcVHiS77mNNDdOZ5fJ767DAaAdg3+pjvOpjdeQ4n2bDCrnFMMt0UR8Lj48rdio55z3tg66VaH6v5X2lq9TWbRk25IIpaOmYqgxFvDUBFemway3wS5dXKCt9tdhXTGDNvYux1AODVBxy6DGgd+gbKqayEgTY+C4kgDOjWyMt7K9Sv389Av41iBvy9Tc19T6QYsTNZuwxconNKnmAuWPmY78ANPM5ICdmE7C+OXAyxPCU5p4RUecCTYFIyjaiy9Fi+Kj1NRqYyfNl/G2CYdfJ8jakrF6aVQAObdNPEjoup1ihttwd5BT8lk1ox/eEdcZvr3EHIEVELXQma9bb52fwAmjgHaeAkOvzbcm+pJc48PNcDx/x7PYcyu8AXWFFED9OJR+jhY/yFcR7YcQhr5Xkk4rnsveBX98N4wVHey5Xq6sQx0i5q8u5asQiV3PDB7Shi9PQilY2qzPbbUX/oiFRBjjTuI4ByQ8SzUwaD7ncqDF1+O9Kpft5XY
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700016)(1800799024)(23010399003)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jw6O4KGOj6ppF8XWT9MnRTj+ZDUnWZ7q5+Fx3RchR/NNlFuaamqg1D7ar/J+WPrTbHrCfdvIwyPZkY6Aeat9tP4ZX51wST59W6ZjXdjzoFrqSheZ4HLpsme8JUAh1V/amWOJuCLenpBOce/vPNLQ0tXloSGnOUYfq26Ft4CodTcQqUDe31ttHCiN811pdJCCw9rZRzHzMbwbTRVLEy69bHVpJp9F9CkyIxNieeGBFkxz6g5S/KwTnT8JYeYBfuojMbvNARW3SgFWFh9drGrxn3J/qJhUawwUubeH0nEpsbgoQZpLwuhgD4WFInqYlV4DU62+Lvb53PdfNT8KXLfbvTGcFAofVhzL/XgKc1p3GynVxwj8FW64Oh7WsjRO4zW4ZMuiQoQ30tASIQEFqH+gFXD9zy1gpWawLrBePRYv1QK2mh7gXk3aIVXh5K5mhxUj
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 05:45:04.8393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7747adb-2f02-43b9-9e26-08deec6b5ffb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6194.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8742
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3A422160004
X-Stat-Signature: 3f9dpzsk8kfdpo5nk8n3u9kjnxu56dt1
X-Rspam-User: 
X-HE-Tag: 1785217514-685406
X-HE-Meta: U2FsdGVkX19xug1IODD5XSjK9PXZzzxGKKv3tW7YW9W61itLxkaOE04WI2cS4nShm280S4AMJhDM5XleA3MVOcQRtgAaX2vP2m3n6lpxNxwwx4LSeKYNxnijSsCm7jxrn9JJ+zh7OWIIvwnmsvEuX/YwNiforLtxbep8hktUq13cJnRYjCeaAgLCD7n8vdXDW59uqG2i5Ztw3SVJ0t9q36xnQzJ1gyZksgnJkd6HeUBBBLMRz1mR0HYpoFBB3YCkWvVy8twNvZQQf2h4zL7zLRE9Y86BWxcp7mTexDaUOnUlIQrVSFDAsWIoShU9pYiPQf5HIYHshALX06cklVoB6U9XGvqOFIY+0F3d8mz9Xk9KQurj+9/jac3qsHrfsUGHL2CF9VTu86b2f3hd1QXlCBkNiQf01MFGV/z6LJsV4iEVq6KUUuuREd1KT8Fu/M+zUHlCe9oXFRzELMI2ukJq4C/OTTaGVVMbSzKAuyCj4/o5enFDRGwxizPFDYVAL4z49gWeWqYpkaqMF0wdJ/aEDbYa9Y5VKDOmUdn71jtwopSfGGbcIhgx6FJQZv/wbWcr5so+Yk6fKH7n944xHMxgkX3CEGV9T7f3ZbUQRX5/G6M3tiNXYyVhZaPAeONyeO5wErImyveaMo9ZOSbspMXEban8lIgX1fK0Ow4/aCtpqE/yB62l3I1pvgRH/eghvhdqhJFRkgZR3nUs/lOYC2wLBNeh2c/N8M07By1HVCUP7j4jBs5/zEBK9YJ3TnD0R19D9rXFXTHjDMi8B7p79T6iScm+jhT6dVvuZl4x7uzGwJjdVNRsQYgES2jOdfQ0ZrMusWjIfN+gK6AFrwo+Lard/QtweCZbsrLfiqIHf0MTqRWyGZPo0fSb2OPQbJRAxBOH4pAsBD0sIUFWGZMIJcASyCAIMr8TaEPXz9VWjhaHp/D9hBrkZr3McTy/cmeDKkYkMZFAJRg9VO/Ix2CtYOk
 rAKtAYP/
 RT4b80XCkNLhrBZULEOTbXnhnx5X91ZsKEGeHgi2Dg0hpePs+Ou+TdT9+FE+xU10u8rYyEdqvruMrzOSOn6iuVjQZ0UBlOJisGejU+QoOdnm2ry/LqNBY1CkH3MwalYBUoAggvInXrSNLRdPO3zcq8fdlxwoJcBb0TPMuvVD95mlANYsC8W1Mi01MMRPW6/hwqb8YhRE3Hu6Pflb7r0+Yp7PR1mwrSN/o7DyMbpT1tw5jK7Gqu9WKHtiVF5RxEHwjzLASLtYKbjKw+95O+MfxDesWVNVDC0sfvIkew2s9Yy8MCCax+tRQe1a3SIVRRCRkYDg4JRR6fzU5pXavkbuaRGePHqRGblMsqzeqBDxW44jzMfzjjRVBK7/N7jRODiGvYBDUgxOv0vu/xbj97Dnyqfiv+BFvfVY41dybM54ipatpJ6NXC9VoDLmS5JdRZTydNk1MAal3u61BRgYM0zIyexuK2vlXhIFFpPC8WQzqxI++3ANvrGUb+hKK1oQqWYDJyLd78sNmBLm7NQnnAmDO5hDwGJIMpovCU5X7QlE63/EHtztsf9wlL/EcwQ==
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
 Documentation/admin-guide/mm/pghot.rst |  4 +-
 include/linux/pghot.h                  | 39 ++++++++++++-
 mm/Kconfig                             | 11 ++++
 mm/Makefile                            |  7 ++-
 mm/pghot-precise.c                     | 77 ++++++++++++++++++++++++++
 mm/pghot.c                             | 13 +++--
 6 files changed, 143 insertions(+), 8 deletions(-)
 create mode 100644 mm/pghot-precise.c

diff --git a/Documentation/admin-guide/mm/pghot.rst b/Documentation/admin-guide/mm/pghot.rst
index 0edbe0082816..6d9b3d9522d1 100644
--- a/Documentation/admin-guide/mm/pghot.rst
+++ b/Documentation/admin-guide/mm/pghot.rst
@@ -56,7 +56,7 @@ Path: /proc/sys/vm/pghot_target_nid
 Path: /proc/sys/vm/pghot_freq_threshold
 
 - Minimum access frequency before a page is marked ready for promotion.
-  Range is 1 to 3 in default mode.
+  Range is 1 to 3 in default mode and 1 to 7 in precision mode.
 - Default: 2
 - Example:
   # sysctl vm.pghot_freq_threshold=1
@@ -68,7 +68,7 @@ Path: /proc/sys/vm/pghot_promote_freq_window_ms
 - Controls the time window (in ms) for counting access frequency. A page is
   considered hot only when **pghot_freq_threshold** number of accesses occur
   with this time period.
-- Default: 3000 (3 seconds)
+- Default: 3000 (3 seconds) in default mode and 5000 (5s) in precision mode.
 - Example:
   # sysctl vm.pghot_promote_freq_window_ms=3000
 
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
index 7b85d717f410..313e5a6973e4 100644
--- a/include/linux/pghot.h
+++ b/include/linux/pghot.h
@@ -37,8 +37,40 @@ DECLARE_STATIC_KEY_FALSE(pghot_src_hwhints);
 
 #define PGHOT_DEFAULT_NODE		0
 
+#if defined(CONFIG_PGHOT_PRECISE)
 #define PGHOT_FREQ_WINDOW_MIN		(1 * MSEC_PER_SEC)
-#define PGHOT_FREQ_WINDOW_DEFAULT	(3 * MSEC_PER_SEC)
+#define PGHOT_FREQ_WINDOW_DEFAULT	(5 * MSEC_PER_SEC)
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
+#define PGHOT_FREQ_WINDOW_MAX		PGHOT_TIME_MAX
+
+typedef u32 phi_t;
+
+#else	/* !CONFIG_PGHOT_PRECISE */
+#define PGHOT_FREQ_WINDOW_MIN		(1 * MSEC_PER_SEC)
+#define PGHOT_FREQ_WINDOW_DEFAULT       (3 * MSEC_PER_SEC)
 
 /*
  * Bits 0-6 are used to store frequency and time.
@@ -66,6 +98,11 @@ DECLARE_STATIC_KEY_FALSE(pghot_src_hwhints);
 
 typedef u8 phi_t;
 
+static_assert(MAX_NUMNODES <= (1 << PGHOT_NID_WIDTH),
+	      "pghot precise nid field too narrow for MAX_NUMNODES");
+
+#endif /* CONFIG_PGHOT_PRECISE */
+
 #define PGHOT_RECORD_SIZE		sizeof(phi_t)
 
 #define PGHOT_SECTION_HOT_BIT		0
diff --git a/mm/Kconfig b/mm/Kconfig
index 0a5bcd5d45ed..955a826ecfe9 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1523,6 +1523,17 @@ config PGHOT
 	  This adds 1 byte of metadata overhead per page in lower-tier
 	  memory nodes.
 
+config PGHOT_PRECISE
+	bool "Hot page tracking precision mode"
+	default n
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
index 4939a1a74c1d..83bac64cab26 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,4 +147,9 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
-obj-$(CONFIG_PGHOT) += pghot.o pghot-default.o
+obj-$(CONFIG_PGHOT) += pghot.o
+ifdef CONFIG_PGHOT_PRECISE
+obj-$(CONFIG_PGHOT) += pghot-precise.o
+else
+obj-$(CONFIG_PGHOT) += pghot-default.o
+endif
diff --git a/mm/pghot-precise.c b/mm/pghot-precise.c
new file mode 100644
index 000000000000..df82f2068a99
--- /dev/null
+++ b/mm/pghot-precise.c
@@ -0,0 +1,77 @@
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
+#include <linux/memory-tiers.h>
+
+bool pghot_nid_valid(int nid)
+{
+	if (nid != NUMA_NO_NODE &&
+	    (!numa_valid_node(nid) || nid > PGHOT_NID_MAX ||
+	     !node_online(nid) || !node_is_toptier(nid)))
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
+	nid = (nid == NUMA_NO_NODE) ? sysctl_pghot_target_nid : nid;
+	old_hotness = READ_ONCE(*phi);
+
+	do {
+		bool new_window = false;
+
+		old_freq = (old_hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+		old_time = (old_hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
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
+		hotness = 0;
+		hotness |= (nid & PGHOT_NID_MASK) << PGHOT_NID_SHIFT;
+		hotness |= (freq & PGHOT_FREQ_MASK) << PGHOT_FREQ_SHIFT;
+		hotness |= (time & PGHOT_TIME_MASK) << PGHOT_TIME_SHIFT;
+
+		if (freq >= sysctl_pghot_freq_threshold)
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
index 19cc023091f4..f66baacb2862 100644
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
@@ -158,13 +161,15 @@ static bool kmigrated_started __ro_after_init;
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


