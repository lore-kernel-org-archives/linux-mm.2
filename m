Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F089C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9610E6B00AD; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F966B00AB; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81DB26B00B0; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54F446B00AB
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1304801BE
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:06:43 +0000 (UTC)
X-FDA: 85071776286.20.3706B34
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf01.hostedemail.com (Postfix) with ESMTP id C9A7040010
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:06:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786043202;
	b=8SiNWrMpgWCqmh8tYmIIYXRHuPV1qBxPSv7gjZGHGLiBLdl0ybCOLWrXQuUoo+q3tjlR3U
	ZeExXfT18DRAxoddTYJqrQy0eyNEnZiTShPI2hnl3eH5LWG3DuDIGOSyPEEcEm5lgmsfq2
	vCR37ehGycpgxHHSg3xWt6eY33MnRhY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786043202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xctwvkCJ+o27xS5RMu97tXPlMWyOXOEaAODCbwOM2nc=;
	b=iy6oq7zNaoPT3iUf2VZdwn5azVGQhOl5206AGVtavFtOs3WxqIp6zUXaTms+onu/LRXYDD
	G8PDELK+UGp9KA3Knf1j0kezKcWIIX+F4zgs7ZVA1aEEuLkYTYze9kecrkyjWG4k4nuTh4
	f5CfylUr3vKObLOP7Yv/L5sB0YKRH4Y=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 7 Aug 2026 04:06:36 +0900
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
Subject: [PATCH 4/4] mm, swap: drop the swap cache guard and reclaim in swap_free_hibernation_slot()
Date: Fri,  7 Aug 2026 04:06:36 +0900
Message-Id: <20260806190636.446205-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806190636.446205-1-youngjun.park@lge.com>
References: <20260806190636.446205-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C9A7040010
X-Stat-Signature: hz9q3nqzkqjihmpenfbhr4sme6gwmd4y
X-Rspam-User: 
X-HE-Tag: 1786043200-838039
X-HE-Meta: U2FsdGVkX18esVam/L0IeQtQvJxnBMaeBZWzNB5VOHCraIZS415GVvTxFAjARjst+89ziKOLKJvkEGQXEFv+aHSi3jXn4vCBnjCa6YzzPuDitgxjYHsFtHkoKIE6aLEaltN2f+K0hq0zURX1xaIejc/TboQsm83KhcLUb4G4DCkdHmTIH2U+7C0FqZoNAhfCSe2dOjZ9+jgXy36As8Qm9jDDljkIBAeVoWAZJtImgUPM3tIc2I2RaRCSyGXmzgUzNjliMJA6rSdLU4bRtZoEMZ85f1EOzrWm12OxiBRV2Apw5NNgU01LAWOyDSY/xPTMLdo7qds6BV/GsDXWSMIv/OCyB+MIyBQL8LFIFcDsh/lP6w3wrYpaTWj7t2gLVZGp5YppvNeS3P8nnqXcC0YHnvvPU45aurg1f/MtfVQiUcL7iBlQQbKi9JAiASRRJMQg6oEXFm01P6nTEfbbCLS50nUos/BjmjJ+R25t/7tv6Mzjog6VQcJUSZOGQLn10ePvs4HIlAbIWqIJhL9cnQs1Ox1AsPrPidh8SmomQOFpf3VaEr35/PigmcCH0916RT4z/vzQdUQfe5+ZJi05UCd+t6M2LNiDnD429pKzqKHXq728zvPHwXyIB+8MtMo+++eWUoSaT4bxhzNddzOs1QbuL21EjyhayTI5Rq+/1A8xwkasfAdPHSPM/aTktJIThay0jBoZ8lEAlEVMYo7Y1kRw9CkrQriAmUrIs7zvwnVfU7+QHgBJzgn2XmNFm7/LvOl2l51O/Hx059ocVgoK/77mXIyQDTvUDJIvVaAYD7UxIzA2vhNfpJHquHKVintPFeb4xOANRO898oA0FyBzeJhZ4Gt34dk/fOhXtiKn85D2hHo4fPQRN3xfL3dHP2xf7XLZl1crsjMNGHD/BwddHDPRU8j+d40MhjrQ1ayhd6NbAzjfznSlfSGT0m2ooSJsaTrH4fiyh9yzC9TPHLa1XKY
 UU/4UiKe
 ZEn/O7ktBuIMFxY62A+lnAHd+rBqa20ydgij8HC+FJhnPcn2pTh8bx8JLHP+Iqa4PElI8D/7hKoCIVJphnl6IHDGUUsSBVWHEorbJFtpmt/mUrl5aWa+0N0UL1R8HpmdGYIbYXM8yrDv/JobaFpbuq4v4pBxzX/ouG8gYN+rq6XqkSm4t6JY/iwwzogLD223lL7F+oslBJqy7Pbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both are there for a folio that readahead might have put on the slot.  The
previous patch turns these slots away at the swap cache boundary, so no
such folio can exist.

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


