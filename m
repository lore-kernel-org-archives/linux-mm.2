Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7FBC5AD4E
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 14:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57516B007B; Sun,  9 Aug 2026 10:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADFA26B008C; Sun,  9 Aug 2026 10:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF856B0092; Sun,  9 Aug 2026 10:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1366B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 10:46:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01E921205A0
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 14:46:35 +0000 (UTC)
X-FDA: 85082007192.21.86E4665
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf08.hostedemail.com (Postfix) with ESMTP id 45A56160009
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 14:46:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786286794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=85M9vtfQGnwt3VvMScDiQGiivtLgVMqslBPynvyYrzo=;
	b=DRzmEWv/eWFIAzptIxbMlduFiID0RR1LUYwVP34FPt8A1ePAR31fOgOXAI4J8mIWCbdmk9
	SdHbehETQZoVtShAiH2Q2SseVMYxt0m1pYw209LBKmoyqxhDw0yRXgqhM8S0PSofHA79cc
	3yvppkwBuvWnnXvntqFMb+T7CjjDivk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786286794;
	b=VNGqaor2eUsDU9dx4Joqx2Lq2jzasZqk15GBN3q+uz95nTF+EdQvxzJuIvj14nQoijsxYT
	qsZ4xeibqeiU5I4CAfGt/jAhTnubiwi54dXFyG2mg6W6ia/C2h21uPjMv5HYml1iRMEWQw
	8jBPxMOJ7i9GYJNxnYOzhLst/i9ahaw=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 9 Aug 2026 23:46:31 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Jianyue Wu <wujianyue000@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] mm, swap: drop the swap cache guard and reclaim in swap_free_hibernation_slot()
Date: Sun,  9 Aug 2026 23:45:59 +0900
Message-Id: <20260809144559.2104856-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260809144559.2104856-1-youngjun.park@lge.com>
References: <20260809144559.2104856-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 45A56160009
X-Stat-Signature: uex8hq7bgcrgttuotxq9uyxw3icesddy
X-Rspam-User: 
X-HE-Tag: 1786286792-945413
X-HE-Meta: U2FsdGVkX1+YlXSupvx9fpTCHjLtTDbukHgKs56Vaj1u3vt84GVnJ52OnRtDFa0rebQuNF3J7nIBtf830ZpryfASPHpEdl2ezg5PLOTGphMg0cE/CO++4pJRaGc8GWGyaVnMCZ6yrz2p6TjO7HUrgw4+rmwZjP+8IZgLShi1WKtfr7CGoPePojgAfu3+0lIQMHTphxbEv5/JmnTsvbtnG+LBz5USlN02orN9dj39kUz4D3Cx8KVAY3BfgwT5eSN2q+EiPpO8HPzyT6FsUFxks3RgXS8LwNn93DxsJP9yFdN6/P0a4MFzbvMmBdkAKUgdxRvACozmASRm1lmydDN+gf20k1Zz0K85ccuT04Mxbr9qcx+aCYyAt/xnpYz64i0jJsTxNP1HqDS+AeWIPgNHQxWFS0JMF5q8WqrUnYT0xfjC3YhV2eVwH+W4z+36WIou+XAb7CqtvB3Cp+ksLI9SFh82WZ7Si4ZtudqKkYj0GqlPEfqHyrCz/Nm7pdGO/olzXAayoLIzH0KAJfiVlTtnM3h5XR+5FQvunuR2Oc3T3Gbd9gdevxsTAMrbidwb/igXOjB1mmorS3CwcyyuFL1MyR/Qe78caqx90TxYVVvQXsn/MSM3spU9KwuGtY839RcjKjJy77FOM7D/7CSeaL6A/NTMr0XqqZsg49idcuP8HGM51H/O61ehRiWBJLm0DYYym8p1IG3FarJfn9eW4K+ZOULXy4MwTLQqj1psXDk4uzdOO2xdDStG1WXJK85nwNMF52q2chAZQI/U1CdLkYwhXwkOEfp4SmcMwf5gNMb/YVJ5PU3Wh3t6lBpuTpvxVGnYZRNR4bLQAfYm9/Hli0FwLyA7SjkT1RPjSXzYtY5d2x8VMSylkCpALKqjEwJS+T705VF5xvwhdM06C4vjMb1E3BsmYJCCIaSeDTyrJw51jCpLgu9nZ5hk9lAgdsLKetWothJFS6ow058p9Gtqw1v
 pmqOBm1N
 +4bajJfA37Rxp5YFD44m6sGqgw8QSW0CnImzDgvylJBB6nRlDsBqRVJFSMKggibm4MRr7IIdtuQyZZ7mUm7QaNBIKFeY6JoSc/kG63bIdCFcSC+WQMIaDoSnhbPmJoPzXoXSpvDQp+lZE0f7SCdo6Vo7Ne27fC8LnmdBLUp23VsodH0lDpS5deBxuaZPX9+XwuS76vTuIBLflnOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both are there for a folio that readahead might have put on the slot.  A
hibernation entry is not a shadow and has no swap count, so the swap cache
turns it away and no such folio can exist.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index a337387f7431..4fba1770ce61 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2203,18 +2203,8 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 	pgoff_t offset = swp_offset(entry);
 
 	ci = swap_cluster_lock(si, offset);
-	/*
-	 * A slot with a folio in the swap cache is freed when the folio
-	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
-	 * Readahead can put a folio here, and freeing the slot now would
-	 * leave that folio with no entry behind it.
-	 */
-	if (!swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
-		__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
+	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
 	swap_cluster_unlock(ci);
-
-	/* In theory readahead might add it to the swap cache by accident */
-	__try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
 }
 
 static int __find_hibernation_swap_type(dev_t device, sector_t offset)
-- 
2.48.1


