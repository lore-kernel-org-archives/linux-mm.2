Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ACE0C54F52
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDDA36B0096; Tue, 28 Jul 2026 16:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB37F6B0098; Tue, 28 Jul 2026 16:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1146B0099; Tue, 28 Jul 2026 16:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 831D66B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:20:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18B5212043E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:20:35 +0000 (UTC)
X-FDA: 85039303230.12.1ED126D
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010039.outbound.protection.outlook.com [52.101.201.39])
	by imf29.hostedemail.com (Postfix) with ESMTP id A9C68120007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:20:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ENhnvR8V;
	spf=pass (imf29.hostedemail.com: domain of noren@nvidia.com designates 52.101.201.39 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785270032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gM0KYMeECBmGcdADWhUzQwes1li7WPzQmeq4gK5f3hU=;
	b=FJdbN62RZqY0egX7DCT8Hh7h0thKf3xVAdhZJJkFi26UxvlKCWAHulSlJ5dvpmJchjwBL9
	O5dTqTbid8+dmwyu/sagTkWj63STK3zoUIcHoFI0O5NTkecOaK7jbS2lYRU1PP5SFjsLAG
	O2I9/mZKmTxcTXGiDPzSoB7GA3KI3+E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785270032;
	b=MdPcUg3Vg19ZOYSO48rHygk/LSBg04eJQQwRSwNxXOiPrNOrMfU/5MieSA4XYSRgOvBZla
	bCkzBOCWx41b8qrSpXOskQlcHWEwqUf96KtDrW+hjqs1icTR2PdjzkwVHP17iiPYCcCFoD
	DDTTJmLDuo8szmHIWviZZFbRcLRk69s=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ENhnvR8V;
	spf=pass (imf29.hostedemail.com: domain of noren@nvidia.com designates 52.101.201.39 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dDUjpdMvd1PCzuG9iQlD08N1hwCA/Gc/38gBhZH/VYbWGqDlqsxhBJXbMQDuJoBfe/y7JLA+DVj0vVBWyL5wpuKy2BTObEMJVDvBMRy/i4Wie+MFdFQsOt3groztnWAJicrX+QXcUCh8e8l6HEIVtYMoUoJb5Soarvm1uWGktuF3OAtFbrJaz6NCEBLcxwrl6BiAWGc+3c5PS7KZLt664YrGILj2DJI9gE6TAioB7h6R2ork6lbC6BFKfjPoi4uF5YCYkzqDdZreTov5kTeEuIe2wfiwKdDZJn1EaiXyGVbzsBr6zBOYQHxqDyaAZL33K4Qlss44lHrhtyERko1N8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gM0KYMeECBmGcdADWhUzQwes1li7WPzQmeq4gK5f3hU=;
 b=iizYxIihrbUB93ASwWIooOrrbvhudPdhzqjWKz4iySDQ4jIqBHnHDhc/HhNRXQb0M0n3VZRjbXYnxzQovyGTY1nUPK1pjOSFPRdDVPJl1xSl4x+lvFJY0AXadGKt8n8iEck1lBdz99eAjIcWZEqnbAUubaHuoa8Yx2htlnKFTzQ6ZZTGx9FbG6LiBl/HDoT+2Koiks0X110CV0NbDlxaf72YrLqb/pDi4lJ5QkMItAEJF6WSkHyG+wNVmEWh+wn1nHIRNumS+POuOFX4rqQMHlJ7JnzMfpI7pA1dLqTSOd2KN5O+Klfuw6Zb7J6MNODjdffj8m+yHPBB7lRgBRy6mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gM0KYMeECBmGcdADWhUzQwes1li7WPzQmeq4gK5f3hU=;
 b=ENhnvR8VzArbCFXG970OKzGzrrTuD3ru7kTgr5vtW4WTQXMiX28iRA1l9+7v7INMSdZe3BmZiXqihI55ey9VhjUuvzLwA973FCAfcFZX+kVDnDprudKIpDwbI3JmSOsGMNtG7A38fxOD6Libux/IYy0x1P5hzz2D2/X9pvwGeAY0MHNJ9fevtVFXHGRZRwu7Vty9d5CfiiyxjxoKRvLjSIOSX/1JC8AMpPzVGG4dWRJnWG+VShGE8gkRkePcEx3yuvRA5ROJVwEy4CM7iF2ZWSd4z2cPYc9abToVC3U4IfRA20neE1ZpX5IYvLjbxCRxDua98oVUtGyVDmGOKr4tVA==
Received: from MN0P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:531::20)
 by IA1PR12MB7592.namprd12.prod.outlook.com (2603:10b6:208:428::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 20:20:12 +0000
Received: from BN3PEPF0000B071.namprd04.prod.outlook.com
 (2603:10b6:208:531:cafe::54) by MN0P222CA0012.outlook.office365.com
 (2603:10b6:208:531::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Tue,
 28 Jul 2026 20:20:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B071.mail.protection.outlook.com (10.167.243.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 20:20:12 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 28 Jul
 2026 13:19:50 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 28 Jul
 2026 13:19:49 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 28
 Jul 2026 13:19:46 -0700
From: Nimrod Oren <noren@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	Nimrod Oren <noren@nvidia.com>
Subject: [PATCH] mm/khugepaged: cap min_free_kbytes recommendation at 1 GiB
Date: Tue, 28 Jul 2026 23:20:14 +0300
Message-ID: <20260728202014.2517142-1-noren@nvidia.com>
X-Mailer: git-send-email 2.45.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B071:EE_|IA1PR12MB7592:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ae5c903-2ee5-4881-20eb-08deece5a10e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|36860700016|82310400026|10067099003|18002099003|11063799006|56012099006|13003099007|6133799003;
X-Microsoft-Antispam-Message-Info:
	z6l0RrlYNCMAj2v3P88hGJg4SbCJgFfsOlNXbx9OqWJbairQHwgYihlw7cle85TPeQ5Z9YmWMUNEjml2rzh1ksrtuyX0EXLlMulQSis2FNRXP+mzOCUtC5rykjhNBX6KF3kQ8b00dY+uXAEi67BKDC3P+0o2k24WsVUC7Lj15wrQ4kDtOK+GYdmoEP9kDLSbUvVYRN9NrjqT82uOzCdPSQqj1SoViOgsKMztC9KtDnqG8Hnx4Rq7jCSuIiRzgU4nus1uQ1dmQiEqrKLZq78yN4UadD2d3eYEitCWyxQD+VtQdieIxxB9JzNk3AYQM8OgM1A6mtGR12dUYFBg/AikNOmwKCRmjczm/Jz2HqF4vZQk3AKfFY/BcqVMeF4xOl6n+UgoWl6CUELo+g7QUCTaDU+z1GouhXWT1yEnaNmrHTOoG//RVDxviJ85xBErROVh0iSAeA+B1YiY5gM4dmFQNMe6YIbh618zeFWO70ppz4N1zGsbwAXl1a7sEvBWED4WSuCF56kjB2nemn0S6QwzXKRnfxGxRpCTQXj6jjUUbmIKqcpWs5/IJ1HZ7/0+5sTFUf3J9PDqiIIWGIxgFA0WQbtIXSD2kQiCnTe64f1bArEmvZeOFk3Y3+zXdcLBxbMrKrfG1WubdM0kVI9MgbXeP2BJitoSGEtriDn4B8RQDM6hgUF62yowqjuth9MBu3+ZVe/TF1vghypN7eIo8m7Xsg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(36860700016)(82310400026)(10067099003)(18002099003)(11063799006)(56012099006)(13003099007)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gqig14HUTZSHUnUQzeSrpsxNylQsbHfHcfWWX1Ed3k5qvAI09rUPUfzYS+gk5zgHanWiSUIP6lBlCVjvtB5PBtyYQFAPfIt8T7O/CJyyRJ+Fg0AqymKlmX5uVotPEu5jPsIPhdv0utRpDiHp2kOx0VB52seE4VNWJWQmvnPEdwDWYwtsz/dEj/Q9iVot16GPkdXM3VRKSlIvvqU42YMCtwThtkJcI+7+2cEd3SKIKHlMKizg5ez0IKj8u4uuHAHnrXm85V3/CzA6wgNMA1Z1QCdnQYnf2rghj9rALxCKg0soamFDFSA8Aas/95DZjO7U4m2FkAFT8FIGNL5Or6kvJ12cl893MP8v3LcJ3t9BW0O9bMglGWVFHeWCShzHdxZAPYjRX4ElDEdW/niIjf/ERQqIhF/D4ehYfDmHBJmOQX9B9gjSolYJWuuCMEi48Cen
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 20:20:12.5055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ae5c903-2ee5-4881-20eb-08deece5a10e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B071.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7592
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A9C68120007
X-Stat-Signature: azatz1dohabnm6unx7uf9pd1xe8bti67
X-Rspam-User: 
X-HE-Tag: 1785270029-926388
X-HE-Meta: U2FsdGVkX1+KirLvZZJzmS4vFUx7P+3i1sOOUWETN0gVx2U97IDExeZ56s+16rfqklj82bK0M874YBunh4SrVi9V2kG+m3jfTC8eGdj6r9JH+nlV+PcHOPtB2HCYYwLb9eBXHrK2Xuf45IEurC5vtXZ5U34ZRw1nlRh9dE17jucKWZTuIinHfDIGa6n1I0mlrZiaxYAtBzogdU49+LoL/4xZWVj4Z1YEWsf0QI5833SAKeREmSguUpZ3CIQFoAsSYpKCOfpPAHV/oss38n46wC96EDgRuAV7wgtjAXqzI3N4fVjw3Um4VpWe/BwrauUVVhBae3sUIlshudt0FxHixoyMziUNaZ4GKpzr4jfF+OfDFPvDbuhhJkxO9s4p4vvhXPVoKJ3nyFVPeTxOklsYTzLEoH40gqXgN+yhlohbkWqx1+W4MGx65AV450lKqfQZuMS/iYQ81C4naZY5xsfEAalRS00pWnU8+LFXiUmXq4FTfIxqKySxKUgaOe41HyLOFnMDgPC8WJoji0zmniePS5UTjJKI8VwkGNTSKt9XQQEqMOWL3gpswph6qzstWXBSrdwNXlJ+9POggOwUY1+VgLBjchhkQOeyvU/lZskuM6Dpodn4sJGNtziB+nu6zWaKmi+NiTqW843FDU/bcPcQpKjJJZblOrTvYMHCGQRReDWHmBfiZM8fFahzB0cpxm5FeW8P7oLY8iK0xIPxAnH4yDuxjiL2P8oQuTs50vqOzxKuSZJLZhk8hiIVNP9ZJhC3JnO6jAFTUB4sS1qYV0W1ACb5K9ncGfOOAtrcgxHSIlKZPlC1NL+7IcI2ijjU+7fk5/+JXXsCO0NtrqQwADJUyYUsM8C4T83spkWsAD1SjVGCESEsLzLE0IJF7wOGpbsIykuiqb6IQQRzIHZzzocsbwsP3reFAOfHiVf4tRq0ycngBqLDJGuKJ2Ddv7WbUuBOx1FlhL0RGjbApNolx9L
 dhAr5+ys
 wulTZMedRq0hVqbtDKptL0nDIOB65Yo0S+/6xN45FHZxX6iweb1SbUI4fAJfHAcjSu0gVEbMm7zdGtWVYRRllyVAF9cgVLR9DUWdMWObm2Hxyem4iZpS4EPdb73qeMEUzMkHh/hXoKVi3UxSWR4qn/yWXg3xX7zu3vb6PtEaNmlViQhbHCd3y2aaizm/MqgwiRRIthTmnqtNCrFSzx2EncYvNgr45s0bwyvDQMCMaOctlD7waUh9EVfpan6R+MJYiGqVj949QCl9cl1UTAk0I8Q3IDEldxxNOkT3UBjf99UN90k3jwB7L4ctp76Rj6/YBUB/vkV/I/a9bVQbwlgD6AuiNeHyz9DDmB2ZWcw01sIH0cgzvz7e3/WJDzXIG0hRO5tDnQNuf4d4r7sUSuEBV5JkwXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When THP is enabled, set_recommended_min_free_kbytes() may raise
min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
With MIGRATE_PCPTYPES equal to 3, the formula accounts for 11
pageblocks for every eligible populated zone before capping the result
at 5% of low memory.

This is reasonable when a pageblock is 2 MiB, as on common 4 KiB page
configurations, but scales poorly with larger base page sizes. With
the default arm64 pageblock sizes, the contribution per eligible zone
before the 5% cap is:

  4 KiB pages:   2 MiB pageblock,   22 MiB per zone
 16 KiB pages:  32 MiB pageblock,  352 MiB per zone
 64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone

Consequently, min_free_kbytes can reach excessive and unwanted levels.

Add an absolute 1 GiB cap to the recommendation, in addition to the
existing percentage cap. This bounds the automatic recommendation to a
sane value on systems with large pageblocks while preserving existing
behavior for typical systems with 2 MiB pageblocks.

Link: https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Nimrod Oren <noren@nvidia.com>
---
v1:
* Cap the final recommendation at 1 GiB as suggested by Lorenzo.

RFC v1:
https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/
---
 mm/khugepaged.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 27e8f3077e80..d9caf10e05b5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -23,6 +23,7 @@
 #include <linux/ksm.h>
 #include <linux/pgalloc.h>
 #include <linux/backing-dev.h>
+#include <linux/sizes.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -3096,9 +3097,13 @@ void set_recommended_min_free_kbytes(void)
 	recommended_min += pageblock_nr_pages * nr_zones *
 			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;
 
-	/* don't ever allow to reserve more than 5% of the lowmem */
+	/*
+	 * Don't ever allow to reserve more than 5% of lowmem or 1 GiB,
+	 * whichever is smaller.
+	 */
 	recommended_min = min(recommended_min,
 			      (unsigned long) nr_free_buffer_pages() / 20);
+	recommended_min = min(recommended_min, SZ_1G / PAGE_SIZE);
 	recommended_min <<= (PAGE_SHIFT-10);
 
 	if (recommended_min > min_free_kbytes) {
-- 
2.45.0


