Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A121C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 19:01:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2046B0088; Tue,  1 Sep 2026 15:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C626B008A; Tue,  1 Sep 2026 15:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0F486B008C; Tue,  1 Sep 2026 15:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1456B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:01:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 20C2F1A0501
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:01:53 +0000 (UTC)
X-FDA: 85166112906.08.D97A96F
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012016.outbound.protection.outlook.com [52.101.43.16])
	by imf26.hostedemail.com (Postfix) with ESMTP id E4274140015
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:01:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="lIU/X200";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of noren@nvidia.com designates 52.101.43.16 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788289310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iCrJwHuUiPOjnRdh3ZQ5lo0p/AYHI31si3IQQhMCkkE=;
	b=V1+GcYKMN4w+p1ExPkutmrlndOV3PjlJTubATNY+TrNC9FdgRqPXkVZZYUe1sN9B0IeeBd
	q7/kWddSOdXXdRIQC2c/NgrcRdT91JGTiv3LmJLT2YBf/jb8zLioI/kKOnYSqTvw09aia5
	glN4fkizqYhNKxMASvfmxr2DMSjG/Hw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="lIU/X200";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf26.hostedemail.com: domain of noren@nvidia.com designates 52.101.43.16 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788289310;
	b=StbD78cE1KhWQDRX98E69BssYA8bnl7v4W8W9XNQTYBxtMgcfU9ttE/OXYd16wh9B96MTw
	dmJZ2Tnm4gBAc2XoFjfXmGKSk89P7b+ed22vLZXOS6blJ9b0fNfLrxW4I31CcM3V1kp786
	tnzzzahwvA2O8ak80rB6BoiU6zUvbBU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wg8wIMRm+S+T0KqazvsS+iGPuNzuNDGrBeudpBYqIDjLPSA+naHs9MAjkh3zX/OaFgmTz/VUWQ5dgWOS5n27s+BCd+KvJSUY2SfTx2dRkNw4q8GlYUncqzWI5qwUBUTXS+pNfw0O0DOTMDjQC88iecyfQp+DPi+q4rU52D/pXFweYnh4SoOVv62GMOLvJBvgNuRM3YdtXGwNmqxUDIvm8d3SVPpiMhGXjaZxbW+LKGoSOxRIaK07Vbsbu+kcAmExjb07apoIVlVYMT/2lDuYOS3LMaSZ8oeIBMRk0wrkEyyWHxqpU52HQvUdDtWMR3x6EQ7cuDMGnSKiA+OPS44ICw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iCrJwHuUiPOjnRdh3ZQ5lo0p/AYHI31si3IQQhMCkkE=;
 b=dIsbcdRh9AbVHmpWTxSA5bvmuAoxZnj4V5Z+NtUxFvXIsjlKNRlzL4sYA2GYwExrMuNwb3cT9qTi343QoxMvjCxthtXZ6ExNv/72MkY1aMLDhplSWozZko6hn78DFGYtAdFvtQs9coY123M4yjUwWdbietbFGDgciBQXnTsGylDHKECZT78ewojAJISRfVQAJ9Pl7h7EaCDQBW0o4UsgaOCt8nhnFTQdsuJAxoZTnz97e5tPsfZpu3Q4xCJlbpgTJR7DWP8YIaKTa4d3j+Qg6HrnckHRt99+vJdZjWaU99MXuugyNwraAJbstC/WJRuaq9YBOLY4eKK3daYkjMjgsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCrJwHuUiPOjnRdh3ZQ5lo0p/AYHI31si3IQQhMCkkE=;
 b=lIU/X2004MhyfI6lg1AbMBxbUPK4jqDEjSfksKfuPMZ4NmMGZQfbSIU7/yi5DiGcqsUPSx9CXrr3iLHRGGYB2rVokfeRnyZXoX9ANrjufxNUaeXTnSMP74x+3kbE8d0W5pgTV3VszHJ29Gu5pRfh/85pa0KKuIfC3apMd3xRbh0b/dX9q8aCrya7QboYlcaszXLIsSVUXzTEhMglGXPkAPAnIPcEOaF1HkMwtG5QrWYb5ANRVxYgRTrQAa8+spHnMwOgOEPCgfJi9Cg3t1PgfUXLLIzrm0OlkpsMtJV7/DJdEUoV3a20sV2MmP6NIN3g+JohzisWJ+tl4xKrbJQMIw==
Received: from BN0PR04CA0134.namprd04.prod.outlook.com (2603:10b6:408:ed::19)
 by CH1PPF68E8581EB.namprd12.prod.outlook.com (2603:10b6:61f:fc00::611) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 19:01:30 +0000
Received: from BL02EPF00021F6D.namprd02.prod.outlook.com
 (2603:10b6:408:ed:cafe::5b) by BN0PR04CA0134.outlook.office365.com
 (2603:10b6:408:ed::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.10 via Frontend Transport; Tue, 1
 Sep 2026 19:01:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F6D.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Tue, 1 Sep 2026 19:01:27 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 1 Sep
 2026 12:00:57 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 1 Sep
 2026 12:00:57 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 1 Sep
 2026 12:00:50 -0700
From: Nimrod Oren <noren@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
	<brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, "Hugh
 Dickins" <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>, Dragos Tatulea
	<dtatulea@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	Nimrod Oren <noren@nvidia.com>
Subject: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Date: Tue, 1 Sep 2026 22:01:23 +0300
Message-ID: <20260901190123.3511535-1-noren@nvidia.com>
X-Mailer: git-send-email 2.45.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6D:EE_|CH1PPF68E8581EB:EE_
X-MS-Office365-Filtering-Correlation-Id: de47a461-3fcd-4e6c-e537-08df085b6d3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|7416014|376014|18002099003|13003099007|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	8UC/i94n0HwlTl+8XRs9zbF2jyxkv4hCNAg6cjJ7Pj6+fmRQ1nrlM1ae60r9eBOgAZHwS2HYkhQgAlg2EUFxttcU18a1v8N4nIb7mvCL9KSmLtIsjN8aAZ1whhMNUaLb3MZrydHdJ0CFsqaE0DVgxXfMAAKmJVhVsn4/RsVbHjE2tlKIGvZEA2Y1Jj1JK94bfRzCuFxe3xh0W0Pi0CYRiGpxW/ZLlWzLvXrvG4zPKTH9naBBUlzsmhkE000+hPnclqzQdLdoHCVuvzQRlPflQi9rSygJS0dm7qZiDnv7A3rRoBFt9YkPkLByibwltlqWs9moNnxB3WyQHNKic4ihNV+M+ReLFH9NdvgxPm203dMnPE54zWc3z0fDJK2+EmpR2FumzyLe9hZmETrXMkpkv8dv4yPC/2nWtl0AFBMDMfYlGbVK9MrOvtXVWDqgs/pCCJGVS6D57iliV/ZCQGFv04OCdTBoqUzsER8rKZhte/iYMX6nh6g+bKkEHbXw/gD1GW7pQ1ef1nKoJ6h7Y6ETUIiF8Vmm6jq0rBUtDxuO3fE5wXloEbjXuxYSvK8vmw2hZYehIcpRyfQwcKn0YW1TU6VVyU/lSE5xZBytlGxPOcoiAOYBbigNweBG1dZ8TbOaiRMNQRaMyEfoD13POjnkpTjkvt1YM7fm+Zrr5C4cSW4OibYr97NYrTccpZSMOZSA/o2kbKH5K4Z72e2CoMe0AA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(7416014)(376014)(18002099003)(13003099007)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sAdVDoGEY7irDp7JIxkxWanR9ha1sFi9T/B1R1B8b5MDmXc5aBvvpjaA9ACQFVVGp1YGrHcCDMZbOC/MxHRlVr5KqDj44C6e9Ssb87SneUU6T3QNuLj5lJfwZFQqE/7EDr9gyS1qS/7GxUsjWuku24tbg55ZXteUZ4jcBD2vw7+5QGX7HTb0TScnevW4W0GwS7sQPzCZ5TF1J9AyQKG3JkKOqVkmQMmRt5dXUXxK2J9zOtAXmFj6p/pP+MIj4BsX0C/yqeJL48qvDt9ebh8PpZKMOlS+9pkFGG6eYALvrTaBkUAUaciGBgfoQj9IReiP+o1ogVYtAyk/CGvfQrcb4fpw2pi9aAAg76gVLMuEqCyTEeZAlcIVaEfm3WuXTT6oJTWU2v2d8Rqht26AhaZhPvTjy8QnVuLW2ZPGxzo2Oef3oEmuSpqmhIASeutHKdMm
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 19:01:27.5936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de47a461-3fcd-4e6c-e537-08df085b6d3f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF68E8581EB
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: fpi8wcz8haoc54e8i1eifo1qr1qcka4t
X-Rspamd-Queue-Id: E4274140015
X-HE-Tag: 1788289309-892229
X-HE-Meta: U2FsdGVkX187A+2F+Ak+cIQ8PquU51mgTfE7qB/vsCJUFT/gfMdmo1aN6LQW+Fv3rPHX/qsskSUTWMd3yuz2UQme0K7A6KMIqJoLdcqwwCg87rYfRnig+zqfIem722PDEj3ZkkemL9Oeh3J1HM0ywAtyfxJQOQnkQP7jKT86HkyjvHa9G149wgdjoZBqLUrhwX4Lvg6ChU8RpsMzc4krtqoKfHMZ0rkTfhDLrz35O/Mk/6yWE8m7CZ+UpWjGMt/LlP0NEgexHJZKlxdzTrZzH/Rajq+q1JAf5KiS54y/cUKIWltp9EnmE3V2qx5O1XQ64XfEmHhQVx18dOl59cJAS41lxwikh+yPvLIyooGNeM9vaj1zwWiFF+fD+xJvNcEgr+RCFtuqZHdTgoFKpGAtgiiOQZKmxWvNvtlFxtiZblDlzbdQmB9Kn6po16Wry3FPqFDZRPBud6fRf9QCSHxMIIIktdozTacbW+gHUxEHiB2CNsnowRxyB5OQfRqJXMXlYUIaOEWz8Z6jZ8I5A7At+GvXN08VgUozXP9Y8g1Er7e0qagRAMZ7y86+JuekM8m4zX56xIWKw0JSo8PZDHEkG88fHyBHyrXMJbyuKdPqfwIr3m5rPWyLevNwFBx4Kibh1D4/b0hsZRBDbtYTSeAbiHkCE4UP+FzJwlC3VyX/IURKfvmOeYo6sbFe4OoaQtD8HAJrT5449rM35lXKi32kGFLLK7JVbRYtQJuD7xi9jd2W+yANyLPwQFQ9AyFWDAgW5sSJyf+diCMUBgV/fz7JeBjYV48peui8LxvQaKvO4yRlmJxjNKema1glHYEbm1U5hSasArROaN6rfCwq1cwUwQuqIWAwwfZOl7Vs/n7QfL+fHcam+bYHckpQr3TXya7CImOVK786XibKSPAgjad/lmX62sb/dJ5bFnY6RMqt2keTKniDWf0fgQqF186Cq8B+HnPHcQOa0G29NPPqG+G
 OMLBcL2n
 yQXqqA50C2YrQ7ozt10FlAzzAIeh7pTSE59DZBzhRrQILlG9wGaeJMTf6C6fZD0oxcii11iJEkxkxlrDyLwNXzvnEmJVURrsnfpn9wRZTdGzKJpTqF5K78vDmKKTeqjbJEetdGM6HwxDxMIHepCtSkQ+qngV8DuMzj9QdnDpv18IUlI9YztOn88L/5yQfzm8XOpgnYJwGd1jZq4fSMmL1oRLt0Fp6bKtsRoHRwh5SFMtoU+TH/gyqPpudHiTwbGmTUkMzemussX3EiKArQ3gDl8FebukVLQtp2L64wnpo+f6A7yOmlJm+ivHwCmMmxr+wW1abmbKODYorpmcfOwxG9s7VTsezGIV5K+UVrh88TEyvmUp4fheGoXWt23eQjU0AUH1zXLs7rKH/GspRb46f5Dt5AZFkR3lMcb72uA3gnnNHuqaoDAX6iIXZMYber7rrZNTxG2IEIwYk6LuopOuM2cTFog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When THP is enabled, set_recommended_min_free_kbytes() may raise
min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
Commit f000565adb77 ("thp: set recommended min free kbytes") added this
heuristic to help keep pageblocks free and reduce fragmentation for THP
allocations.

The recommendation scales poorly with larger base page sizes. With the
default arm64 pageblock sizes, the contribution per eligible zone
before applying the existing cap of 5% of low memory is:

  4 KiB pages:   2 MiB pageblock,   22 MiB per zone
 16 KiB pages:  32 MiB pageblock,  352 MiB per zone
 64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone

Even with that cap, min_free_kbytes can reach excessive levels.

The automatic min_free_kbytes increase predates proactive compaction
and many subsequent changes to compaction. Given those changes,
increasing min_free_kbytes for THP by default is no longer clearly
justified.

Remove set_recommended_min_free_kbytes() and all associated
recalculation paths. With this policy gone, min_free_kbytes is
controlled only by the page allocator's default calculation and the
vm.min_free_kbytes sysctl. Users who want additional headroom may set a
higher value via that sysctl.

Link: https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.com/
Suggested-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Nimrod Oren <noren@nvidia.com>
---
v3:
* Replace the 1 GiB cap with removal of the THP-driven min_free_kbytes
  increase as suggested by Michal.
* Remove all associated recalculation paths.
* Make min_free_kbytes, user_min_free_kbytes,
  calculate_min_free_kbytes(), and setup_per_zone_wmarks() static.
* Drop the now-unused declarations and khugepaged's page_alloc.h include.
* Drop the obsolete v2 documentation addition.

v2:
* Use a named constant for the cap.
* Drop explicit linux/sizes.h include.
* Update min_free_kbytes documentation.
https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.com/

v1:
* Cap the final recommendation at 1 GiB as suggested by Lorenzo.
https://lore.kernel.org/r/20260728202014.2517142-1-noren@nvidia.com/

RFC v1:
https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/
---
 include/linux/khugepaged.h |  5 ----
 mm/huge_memory.c           | 14 ---------
 mm/internal.h              |  8 -----
 mm/khugepaged.c            | 60 --------------------------------------
 mm/page_alloc.c            | 11 +++----
 mm/page_alloc.h            |  2 --
 mm/shmem.c                 |  7 -----
 7 files changed, 4 insertions(+), 103 deletions(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index d7a9053ff4fe..e2a2ccb6cd05 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -15,7 +15,6 @@ extern void __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
 extern void khugepaged_enter_vma(struct vm_area_struct *vma,
 				 vm_flags_t vm_flags);
-extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
 void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 		bool install_pmd);
@@ -47,10 +46,6 @@ static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
 {
 }
 
-static inline void khugepaged_min_free_kbytes_update(void)
-{
-}
-
 static inline bool current_is_khugepaged(void)
 {
 	return false;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c5d11147b69a..b1f87e005e03 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -499,13 +499,6 @@ static ssize_t enabled_store(struct kobject *kobj,
 
 		if (err)
 			return err;
-	} else {
-		/*
-		 * Recalculate watermarks even when the mode didn't
-		 * change, as the previous code always called
-		 * start_stop_khugepaged() which does this internally.
-		 */
-		set_recommended_min_free_kbytes();
 	}
 	return count;
 }
@@ -735,13 +728,6 @@ static ssize_t anon_enabled_store(struct kobject *kobj,
 
 		if (err)
 			return err;
-	} else {
-		/*
-		 * Recalculate watermarks even when the mode didn't
-		 * change, as the previous code always called
-		 * start_stop_khugepaged() which does this internally.
-		 */
-		set_recommended_min_free_kbytes();
 	}
 
 	return count;
diff --git a/mm/internal.h b/mm/internal.h
index e16f1250b25c..6890d7836c68 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -689,11 +689,6 @@ int user_proactive_reclaim(char *buf,
  */
 pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
 
-/*
- * in mm/khugepaged.c
- */
-void set_recommended_min_free_kbytes(void);
-
 /*
  * in mm/page_alloc.c
  */
@@ -701,11 +696,8 @@ void set_recommended_min_free_kbytes(void);
 
 extern char * const zone_names[MAX_NR_ZONES];
 
-extern int min_free_kbytes;
 extern int defrag_mode;
 
-void setup_per_zone_wmarks(void);
-void calculate_min_free_kbytes(void);
 int __meminit init_per_zone_wmark_min(void);
 
 extern int __isolate_free_page(struct page *page, unsigned int order);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f49a6710933b..c36b7d0b91d7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -27,7 +27,6 @@
 
 #include <asm/tlb.h>
 #include "internal.h"
-#include "page_alloc.h"
 #include "mm_slot.h"
 
 enum scan_result {
@@ -3086,57 +3085,6 @@ static int khugepaged(void *none)
 	return 0;
 }
 
-void set_recommended_min_free_kbytes(void)
-{
-	struct zone *zone;
-	int nr_zones = 0;
-	unsigned long recommended_min;
-
-	if (!hugepage_enabled()) {
-		calculate_min_free_kbytes();
-		goto update_wmarks;
-	}
-
-	for_each_populated_zone(zone) {
-		/*
-		 * We don't need to worry about fragmentation of
-		 * ZONE_MOVABLE since it only has movable pages.
-		 */
-		if (zone_idx(zone) > gfp_zone(GFP_USER))
-			continue;
-
-		nr_zones++;
-	}
-
-	/* Ensure 2 pageblocks are free to assist fragmentation avoidance */
-	recommended_min = pageblock_nr_pages * nr_zones * 2;
-
-	/*
-	 * Make sure that on average at least two pageblocks are almost free
-	 * of another type, one for a migratetype to fall back to and a
-	 * second to avoid subsequent fallbacks of other types There are 3
-	 * MIGRATE_TYPES we care about.
-	 */
-	recommended_min += pageblock_nr_pages * nr_zones *
-			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;
-
-	/* don't ever allow to reserve more than 5% of the lowmem */
-	recommended_min = min(recommended_min,
-			      (unsigned long) nr_free_buffer_pages() / 20);
-	recommended_min <<= (PAGE_SHIFT-10);
-
-	if (recommended_min > min_free_kbytes) {
-		if (user_min_free_kbytes >= 0)
-			pr_info_ratelimited("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
-					    min_free_kbytes, recommended_min);
-
-		min_free_kbytes = recommended_min;
-	}
-
-update_wmarks:
-	setup_per_zone_wmarks();
-}
-
 int start_stop_khugepaged(void)
 {
 	guard(mutex)(&khugepaged_mutex);
@@ -3160,17 +3108,9 @@ int start_stop_khugepaged(void)
 		kthread_stop(khugepaged_thread);
 		khugepaged_thread = NULL;
 	}
-	set_recommended_min_free_kbytes();
 	return 0;
 }
 
-void khugepaged_min_free_kbytes_update(void)
-{
-	guard(mutex)(&khugepaged_mutex);
-	if (hugepage_enabled() && khugepaged_thread)
-		set_recommended_min_free_kbytes();
-}
-
 bool current_is_khugepaged(void)
 {
 	return kthread_func(current) == khugepaged;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c4dc61ec663e..5280784c91a8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -50,7 +50,6 @@
 #include <linux/ftrace.h>
 #include <linux/lockdep.h>
 #include <linux/psi.h>
-#include <linux/khugepaged.h>
 #include <linux/delayacct.h>
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
@@ -272,8 +271,8 @@ const char * const migratetype_names[MIGRATE_TYPES] = {
 #endif
 };
 
-int min_free_kbytes = 1024;
-int user_min_free_kbytes = -1;
+static int min_free_kbytes = 1024;
+static int user_min_free_kbytes = -1;
 static int watermark_boost_factor __read_mostly = 15000;
 static int watermark_scale_factor = 10;
 int defrag_mode;
@@ -6663,7 +6662,7 @@ static void __setup_per_zone_wmarks(void)
  * Ensures that the watermark[min,low,high] values for each zone are set
  * correctly with respect to min_free_kbytes.
  */
-void setup_per_zone_wmarks(void)
+static void setup_per_zone_wmarks(void)
 {
 	struct zone *zone;
 	static DEFINE_SPINLOCK(lock);
@@ -6704,7 +6703,7 @@ void setup_per_zone_wmarks(void)
  * 8192MB:	11584k
  * 16384MB:	16384k
  */
-void calculate_min_free_kbytes(void)
+static void calculate_min_free_kbytes(void)
 {
 	unsigned long lowmem_kbytes;
 	int new_min_free_kbytes;
@@ -6732,8 +6731,6 @@ int __meminit init_per_zone_wmark_min(void)
 	setup_min_slab_ratio();
 #endif
 
-	khugepaged_min_free_kbytes_update();
-
 	return 0;
 }
 postcore_initcall(init_per_zone_wmark_min)
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b9259deddb59..86162e6cfa8c 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -227,8 +227,6 @@ void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
 		     unsigned int alloc_flags);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
-extern int user_min_free_kbytes;
-
 struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
 		nodemask_t *nodemask, unsigned int alloc_flags);
 #define __alloc_frozen_pages(...) \
diff --git a/mm/shmem.c b/mm/shmem.c
index 255d69ebceba..92dc770b10e6 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5782,13 +5782,6 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
 		int err = start_stop_khugepaged();
 		if (err)
 			return err;
-	} else {
-		/*
-		 * Recalculate watermarks even when the mode hasn't changed
-		 * to preserve the legacy behavior, as this is always called
-		 * inside start_stop_khugepaged().
-		 */
-		set_recommended_min_free_kbytes();
 	}
 
 	return count;
-- 
2.45.0


