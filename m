Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B95C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6913A6B0095; Tue, 11 Aug 2026 09:37:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640A16B009D; Tue, 11 Aug 2026 09:37:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556D56B009E; Tue, 11 Aug 2026 09:37:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 338896B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:37:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8ED5A0457
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:37:16 +0000 (UTC)
X-FDA: 85089090072.17.508D0A2
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C8BF8000D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:37:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786455435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zb60uywR2AW4mq0V1yAZ78j7QI66v3ssUpPIw+k70ZY=;
	b=doz9ras9SjKt7wrIjGHLPyTb8qQ8ODMHmZKYuLYA0DGSkV88oYC++vuf4N0cfMfIeGcrFP
	X1Q+fXzuHoOihe7Za5+TdzIWCx86MrL9yDqk7KKPtlCUYRKYcydjSLszbuTF7wKdg9+trv
	zEQG5UGOrhAY0Fyc2cOZ82Z2RbGEJFs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786455435;
	b=CCbCc3rZMMfIK5kvuFxgfzCptcNCYOA3Aope4aQze6nQLz9a2X/qGHHo0SeX35FnbZu609
	S4JFrB//GubHJL0lCDk0fUYNNW4OyvYu18d7UdgKb3S32KYrM5+K0U5gx9aaeIifhAd6+d
	1wjQahsAd4RYHInFSudNjAApGWS/SKA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 11 Aug 2026 22:22:12 +0900
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
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Youngjun Park <youngjun.park@lge.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/4] mm, swap: don't free a hibernation slot that is in the swap cache
Date: Tue, 11 Aug 2026 22:22:06 +0900
Message-Id: <20260811132209.2862708-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260811132209.2862708-1-youngjun.park@lge.com>
References: <20260811132209.2862708-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C8BF8000D
X-Rspam-User: 
X-Stat-Signature: kh899jmajf1azpbsq4xfimy9uoomk3zt
X-HE-Tag: 1786455434-546861
X-HE-Meta: U2FsdGVkX1+9YAUhiYXjqyY2wdwvhF97XfCM1PJi32JXcf5tuDM/iNenCZiRkj4Fg92PYcCmyS/WYeBCIsZ9qP8voKWc4bWOHoRi/zPwJVNtnX9/BWO4qcRz4Zw9FYBQqRkew/X9QrCRw4nJGZhqrTP+j7w76DTKF2FKQUbM4m/FyJZnBrPV2bVR2rnDqw13jGAIJqb/cL8NSKFETxNH1ywZU7pKt3qjL17k8zJGFaPBMbZoHEeGuPZZzmlZHyfq2Q+lSKRlEUm9U1G8SiUPkNYeIznB5Ke5O0mNrONPWOfuM2nGQWfj9oRiygRdtDbkSUiaAUasiXK15hTIKtFzsQdh3xGOOoCyErhRy1fmm+yhhW0ZuvYQCMjwsNJu+DD38eXX1KHwHIZ8wObdKCqjIHJ+GHBtOfIPRC7eH4OtQhut2XDvpk2YB4YVB83MX18u4aFyvGfZ/VViqKAjKtxdNQStMwwh8joRVHO2LngF9Iyq0sC2V55sA0VwFl7Pqq/80A6CLNyFrBBhvl6LucDTLZc6KjAgxKacnBR6xCPrztdbZxJqvPFkFBzGtvwgG75JFvg9ImB2LecmtFGL3sH7J1p0N8RNChRLjaOwb0HBG1Btx7mTk2MYI9TYM26M5hE8dJoFitLLFizVtAmABLfo4Fxma8k3RXkAf6P0X5r6OmGC1syEwxXZm1qdTpQtvjzD3pWjBrEY9QgZAUjk44NyOIOLrtCdVWvN9qGI3zh7K+FQn8CgcKZDVfWhd/5zszFTfDNIJEh208i/d7BLVuW3JrUdan/oRX6kRt3iybQo/dL4/JjnZJe0hdsDfG/AV70NUtZKSqjakDbs+Iud8O8dE8418fbi8ykf80IOXI4URl9fVDhILs9uS7GnKsqeG5qwa4bQB/pebUuogYqjXr9aG81zfZb1UKCH/iBXfMbdwoqu3GehOFFDHKgLjDz9q6N3WCNJAv7T0cYzmVv/zNo
 e6enxss8
 sPuXXwh4y883GLeB4KwPDDDpWrGGkA1jcUwJwRAtQKYy5m/LUb5hT1A1VW2MO59dddS83HXrKOGNRVm6HfA+Vkcv7fZAxc2SnncWOCTjUy8u454SlrlxFIU6F1r6RdJSFRdbOLuGl36RsGeSTI36l0TJdKSLnpwGiTs+AjhaOXz+xNcquDe3LjTBpJwnMpUGrOngy+aamJiGYpk0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A slot with a folio in the swap cache is freed when the folio leaves the
cache, not when its count drops.  swap_put_entries_cluster() follows that
rule.  swap_free_hibernation_slot() does not, it calls
__swap_cluster_free_entries() whether or not a folio sits on the slot.

Cluster readahead can put one there.  It walks a raw page_cluster sized
window of offsets around the faulting entry, and a hibernation slot passes
__swap_cache_add_check() because it is not a folio and its count is not
zero.  Freeing the slot then clears the entry under that folio.

The folio is now unreachable from the swap table, and the offset goes back
to the allocator.  The folio is still on the LRU though, so reclaim can
pick it up later.  It then takes the old offset out of folio->swap and
overwrites the table entry there, which by then may belong to someone else.

Check for a cached folio before freeing.  The slot is then left in the
ordinary state where only the swap cache holds it, and it is freed when the
folio leaves the cache, either through the reclaim below or through normal
reclaim later.

Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
Cc: <stable@vger.kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index dea2d3b36e06..f5dfc7e59191 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2202,7 +2202,14 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 
 	ci = swap_cluster_lock(si, offset);
 	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
-	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
+	/*
+	 * A slot with a folio in the swap cache is freed when the folio
+	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
+	 * Readahead can put a folio here, and freeing the slot now would
+	 * leave that folio with no entry behind it.
+	 */
+	if (!swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
+		__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
 	swap_cluster_unlock(ci);
 
 	/* In theory readahead might add it to the swap cache by accident */
-- 
2.48.1


