Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA3DC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1FC6B00AB; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05236B00B0; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1036B00B1; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 641C46B00AD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:06:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2C891401B3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:06:43 +0000 (UTC)
X-FDA: 85071776286.17.789AB42
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf09.hostedemail.com (Postfix) with ESMTP id B08D2140002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:06:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786043202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=idsh6lBluUzDd5ouX7GdyldxmTkixYeyRhsGWQchmWA=;
	b=ACGlySS0a+TCbNjbwsOVZI2PTjIKbKAkvuzF0kZXQtCQ/5QETCcHNaMkC/W1wPeYeCW3e9
	LvmPPDQLxvL68DhSill/VIYo0DxKmpvTiKrk4lVBm1OkginKqwo7Tene/cV9sH3y4oTLWj
	npGZEpz0VeL0q2/F86W6NdUy3bPmcao=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786043202;
	b=ypCL6hp2xFgP8MPSC6Nk2UPNOR6uz2oYnQjTLzZc9f+S/NFM8eQolXe/RS/mF0pcKC0Fus
	vaumxRSOgJP/w8E7H0xsBPG86rvLgumMooTIlZGoNFPmzfpUcUgGuAM0zY7+cZzOApYlQV
	GO0VsK0bUn1CTm9eqIRT+N9YD58bZy4=
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
Subject: [PATCH 1/4] mm, swap: don't free a hibernation slot that is in the swap cache
Date: Fri,  7 Aug 2026 04:06:33 +0900
Message-Id: <20260806190636.446205-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260806190636.446205-1-youngjun.park@lge.com>
References: <20260806190636.446205-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B08D2140002
X-Stat-Signature: qkubs156xa4a63gccadjwy4wmhfepfey
X-Rspam-User: 
X-HE-Tag: 1786043200-137222
X-HE-Meta: U2FsdGVkX18lUyOjrFQNWDVLRDRlON9rb8HcozKjtNTJKCoo1/SPCj7MEUHWhVgl9u4X0dWkcwGIKnGj8saNNW+B0ji0/Og72pmTrs9pSkXWklTeFWaMCm+JQcBhxItL5CVIW57lxm5jAHRHZknWukivCPi9/Vd1R7Fw+Vx0pM/LeXlTneaYnb3sKtmGIVcYEM6tFykUkw0f9ELxTj/uH2kopY6zxzdDGThoJWEkBvw8RxB5hyEd7w6W8gJajbwmKBizR51XHO0CK2Y6C054fGU4KK2eGL1xI2fSd5dY1EXnkOiADwNVPX9f9xfr3MSZgfkwAsqy6u0dPpM7V1W2P7tkxd3yND/4c1kp069cIPCg72dnX8tZEylHEOBWiVvINRzLClGVm0REzoEOeBtJmmK0lJI8qWSFVW8XTyPIwwCsmI2b6vhemctyF6CH4Vxe0eB+RzXSJlnqzn0td8qanCL66jlrk+qrXQ0ijVDzuFHbZTQQi2n7cCWGV0feVXLBmlLQ6VbKQNGdVPghLut8vzF/MY6vycpHPtHxg5GXriFgErAn4KHC1P6+ZEvbyGF8oFCkSpLoWuY/8qJE4TTVJHXhHaC3aTHJzSLaRqhLVGh64al+hwvwa8JBOuJlWrLhNuiD5H6nOGm3t9v0dceapvN3EnRDcGw3+Ad3KD6i1Gftlj+cKUOR3u8b/H+hJU+qG67qdsz9FYYw1LxDUGGB9JNDMzgTxZGXa+vLVFQGHv9bTOn/MMZtDA4oIDYCkBvn2qsrJ2sm96/snDM/wsWEQnq/4s/nOwKjoFXys4tBttgHk8iktTBRvVVcW9Adcr6sWVGOKNY8EuZp6PSm2rUT7+u+7tfPl4zWoSKa+JsxpB+i2zd8sExPvWAgMsbRn+l36ZbWwsaZEb8TU6dH2MpboOvuXKFhldCMbWjLgVQk/TTbUEXT5oIQezKYqnRTALCFmcjzjeaEm0V+2VIsFjw
 MOyVlKpI
 CjUlToGr+LbZX2Tu/ZthX5E3M5yvDn/N49agNZ6g2MyYHaAdXVRMTHz5jljK5NEqDVw4v3OZJpcKjXdPgmKtqZ2bp6knmc9pxL2PXSOEfYcCYo8QWvIfPzgPjC5Bqup7+JgRR/AdhL6Kjz7U2SnCe5G3XmyAZSqXcgYWw
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


