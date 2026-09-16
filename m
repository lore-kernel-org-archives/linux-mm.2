Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A6CC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A2A6B00BD; Wed, 16 Sep 2026 05:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2DB06B00BF; Wed, 16 Sep 2026 05:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1C0F6B00BA; Wed, 16 Sep 2026 05:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7026B00BA
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:32:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30CC5A5769
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:54 +0000 (UTC)
X-FDA: 85219111068.29.D854F01
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0498F40005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RzWyZ6mOHoBBej9m48wclILXsha0ako+JkDBLlpkB14=;
	b=qIVsYkgCUQS1NJEu/n35tN5CuURohP7XoH+lv15p3rtIXZ9TG/5FGPM40iOOGFe0jnllWl
	rHnCP/gw2GHME7JM9kavlhzDkJySrqJMVC2ACzC+lY0hlva9BVWdDwNvdRerRmeINQrhRT
	AxqzBU7xZKX5GKkDX3v9AdafzhlHkMc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551172;
	b=HJCF3URlAOUA5GAymIwdIjGIak/Pv9sOJf8CTBl+4KbG2OE/O1woI6kebKa6HauY/Y8Nkl
	ZRnVpsxP807ZVIZurHWzQYuBQI+6vzmrSFBChx72GUOSzD6IQ6IIilA+pTiDY19+fRZ8lN
	J2xkCQhiSYQOmhsP50GNsUSfqDJ5/HU=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hlDFD3Vs8zKHMc2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:32:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 98AF640590
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:32:46 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCHVikvYqpq8i0GAg--.65015S5;
	Wed, 16 Sep 2026 17:32:46 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	bfoster@redhat.com,
	joannelkoong@gmail.com,
	djwong@kernel.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v3 1/3] mm/truncate: fix data loss when splitting straddling large folios fails
Date: Wed, 16 Sep 2026 17:24:48 +0800
Message-ID: <20260916092450.654408-2-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHVikvYqpq8i0GAg--.65015S5
X-Coremail-Antispam: 1UD129KBjvJXoW3ur45WrWUWr48XryrCry8Xwb_yoWDtr48pa
	yUK3sxKrZ8Ww4jkrnrXa1UZw4Yyas3XFWUAFyxGwnxAan0qwnrKF1Ut3W8KFW3J3s7A34F
	qF1jyay7WF1UJFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTRMfOzDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0498F40005
X-Stat-Signature: eqcdd8simmijrjd35picbqjsef74cjo5
X-Rspam-User: 
X-HE-Tag: 1789551170-315396
X-HE-Meta: U2FsdGVkX1+pESNRbwz2WxaxfInelwhpib2RuGm9NoBDjouKH5sZrQDKPdLJz1qy1tdgKtUl/RjL5Gdpd9XwuyxGHBSAQYO3t87xQJ7oDaD75QwKMGayC2VZVC+Szve3PobpG1LnZvP0IrNIia9sWMKmRnGs5h7uN+lcFWXQ6v4yQZH9xM7kWxJ7c2B0pkTWgR/V5xvkHza8a+Ap5uh0u8Cznig3y/mVD7P9IQKjwMPqiU4TWU/JksyjJVJ0XXUnLyAQw4i8JBtJv/H6sr3Uq3cZCCq01TTU+Vm7+RAxaQVFwLXoUUqbqlbG0EYSeTWlyC+Imku9JwNTLxXHNjy88z1eSir3CePb2FKCZbxmE8weJuy693+7MzikeNO93y7NpobREgjIBRLRUhq+E51dfKp1ZsdcTKN064vchnaYZAJUyS/ytxmfAV1v7vm4q5Bpo6OFyUgWSwau8Mdiqjqrgs98gOwFPKyKcqEnIlpS2JqR4FXUoEj+JwZK7Xx2sHK9lp5MoNAetTSMNc4vkitgkFgxPGAu4tkhBAAvt219yDjRd2b85OZnhkH+iuQ+GO5RUrguzsh2PBHVbX+2Wys0GIS4nTA3KouSk44UZERgdjasqHcUE0E8xu07fpkMAHzMowExaeFMIE2i4V+k6yxMY6wPaDoWXtvkKJdLrEkT9cnyKIsDKK87B9g0F2+HiFayxnxjEh2CPeRWF2QwRzWT4rtYCaXK4wpjM0eeFHkh1JLH7oQrPrPjiKNe+31MhgFcOZGozxi/GHfnnE1VhkyWiKP6NhXibmD4nmN3XpLKwUxNhIUuOUC7VsdeLxyWcFK9VOxx6AoXdMVT7MbGxLxHp98LMDqmIMR0CGe3mJqd4puLDb/j+JKZf9uqxx2H0LUKK/FveefIjfRvm8/LF3Qit8d3alcC+JK4K6MzXQZk4CdeZiXGbYCpXITXxxR8Wgay+NeiWKKC2LfjAK7va6s
 SFo0seE6
 jaiSjod4lYz28IN6qgkYO87E+g/Kb7Fc7fBzcjV7mQNfjwaAGP3zF3xtSYaGnjqsmul+NeJnBS0fZhwqj5YZg9rnW93eetdmDZvQFJUkgDulVy3z29XQerliX7iZihR7Ke0DmnYHHaUXoIX8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Yi <yi.zhang@huawei.com>

truncate_inode_partial_folio() splits a large folio so that the caller's
truncate loop can drop the in-range sub-folios while keeping the
out-of-range tail. The first split at the punch start edge is
non-uniform, which leaves the sub-folio at the truncation end edge as
large as possible, this means it may still straddle the range, holding
both zeroed in-range and valid out-of-range data. The function then
attempts a second split at offset + length to isolate that tail.

If the second split fails the straddling sub-folio stays merged. The
function returned true unconditionally on all exit paths of the success
block, telling the caller it was fully handled. The caller kept its
default end and the truncate loop truncated every sub-folio below it,
including the merged straddler, discarding the valid out-of-range tail.

For example, a 4-page order-2 folio punched from offset 0 to the middle
of the last page:

  truncate_inode_pages_range()
    truncate_inode_partial_folio()      # same_folio == true
      1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
      folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
      2nd split of folio2 fails / cannot lock
      return true                       # BUG: caller keeps default end
    end = 3
    loop truncates p0, p1, p2-3        # p3's valid tail is lost

This became reachable after commit 7460b470a131 ("mm/truncate: use
folio_split() in truncate operation") replaced the atomic split_folio()
with folio_split(), whose non-uniform split can partially split a folio
and leave the end edge merged.

It has gone unnoticed because a dirty large folio normally carries the
filesystem's private data, for example buffer_head, so
filemap_release_folio() -> iomap_release_folio() returns false on a
dirty folio and folio_split() aborts with -EBUSY before any split,
leaving the straddler safely unsplit. The bug is only reachable on paths
that produce dirty large folios without filesystem private data, and it
was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
attached.

Rework the contract so the caller is told the page range to discard:

  - Add pgoff_t *pstart and *pend out-parameters that receive the page
    range fully covered by [lstart, lend] after any split (or none),
    i.e. the pages wholly within the range and safe to discard.

  - Adjust the ordering of the validate check when splitting folio2.
    folio2->index is only reliable after the reference count and lock
    have been successfully acquired, since it may have been split
    concurrently, or freed and recycled to an unrelated mapping. On any
    failure to obtain a reliable end position, fall back to
    folio->index, which is safe but leaves the sub-folios split off at
    the offset edge in the page cache.

  - Rename the byte-range parameters start/end to lstart/lend to better
    express their semantics.

Callers in truncate_inode_pages_range() and shmem_undo_range() pass
&pstart for the folio at the start edge and &pend for the folio at the
end edge, so the truncate loop drops exactly the fully covered pages and
never touches a straddling folio that still holds valid out-of-range
data.

Suggested-by: Brian Foster <bfoster@redhat.com>
Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 mm/internal.h |  4 +--
 mm/shmem.c    | 13 +++-----
 mm/truncate.c | 89 ++++++++++++++++++++++++++++++++++++---------------
 3 files changed, 71 insertions(+), 35 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 68db5abd0a4c..6e6ad3187378 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -627,8 +627,8 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
 unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
 		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
 int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
-bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
-		loff_t end);
+bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
+		loff_t lend, pgoff_t *pstart, pgoff_t *pend);
 long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
 unsigned long mapping_try_invalidate(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
diff --git a/mm/shmem.c b/mm/shmem.c
index 89a1495e55f7..712dc3effe02 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1175,11 +1175,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 	if (folio) {
 		same_folio = lend < folio_next_pos(folio);
 		folio_mark_dirty(folio);
-		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
-			start = folio_next_index(folio);
-			if (same_folio)
-				end = folio->index;
-		}
+		truncate_inode_partial_folio(folio, lstart, lend, &start,
+					     same_folio ? &end : NULL);
 		folio_unlock(folio);
 		folio_put(folio);
 		folio = NULL;
@@ -1189,8 +1186,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 		folio = shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
 	if (folio) {
 		folio_mark_dirty(folio);
-		if (!truncate_inode_partial_folio(folio, lstart, lend))
-			end = folio->index;
+		truncate_inode_partial_folio(folio, lstart, lend, NULL, &end);
 		folio_unlock(folio);
 		folio_put(folio);
 	}
@@ -1258,7 +1254,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 
 				if (!folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
-				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
+				} else if (truncate_inode_partial_folio(folio,
+						lstart, lend, NULL, NULL)) {
 					/*
 					 * If we split a page, reset the loop so
 					 * that we pick up the new sub pages.
diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be47..bec6d881d022 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -206,15 +206,21 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
 /*
  * Handle partial folios.  The folio may be entirely within the
  * range if a split has raced with us.  If not, we zero the part of the
- * folio that's within the [start, end] range, and then split the folio if
+ * folio that's within the [lstart, lend] range, and then split the folio if
  * it's large.  split_page_range() will discard pages which now lie beyond
  * i_size, and we rely on the caller to discard pages which lie within a
  * newly created hole.
  *
+ * When @pstart and/or @pend are non-NULL they receive the indexes of the
+ * page range fully covered by [lstart, lend] after any split (or none),
+ * i.e. the range of pages wholly within [lstart, lend] and so safe to
+ * discard.
+ *
  * Returns false if splitting failed so the caller can avoid
  * discarding the entire folio which is stubbornly unsplit.
  */
-bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
+bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
+				  loff_t lend, pgoff_t *pstart, pgoff_t *pend)
 {
 	loff_t pos = folio_pos(folio);
 	size_t size = folio_size(folio);
@@ -222,14 +228,20 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 	struct page *split_at, *split_at2;
 	unsigned int min_order;
 
-	if (pos < start)
-		offset = start - pos;
+	if (pos < lstart)
+		offset = lstart - pos;
 	else
 		offset = 0;
-	if (pos + size <= (u64)end)
+	if (pos + size <= (u64)lend)
 		length = size - offset;
 	else
-		length = end + 1 - pos - offset;
+		length = lend + 1 - pos - offset;
+
+	if (pstart)
+		*pstart = offset ? folio_next_index(folio) : folio->index;
+	if (pend)
+		*pend = (pos + size > (u64)lend) ? folio->index :
+						   folio_next_index(folio);
 
 	folio_wait_writeback(folio);
 	if (length == size) {
@@ -259,32 +271,62 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		 * for shmem truncate
 		 */
 		struct folio *folio2;
+		pgoff_t end, aligned_end = (pos + offset + length) >>
+					   PAGE_SHIFT;
 
-		if (offset + length == size)
-			goto no_split;
+		if (pstart)
+			*pstart = round_up(pos + offset, PAGE_SIZE) >>
+				  PAGE_SHIFT;
+
+		if (offset + length == size) {
+			end = aligned_end;
+			goto out;
+		}
 
 		split_at2 = folio_page(folio,
 				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
 		folio2 = page_folio(split_at2);
 
+		/*
+		 * folio2 may become stale due to a concurrent split or
+		 * freeing, so validate it before and after taking its lock.
+		 * If it fails, we can't get an accurate end position and fall
+		 * back to folio->index, which may leave sub-folios split off
+		 * at the offset edge in the page cache this round.
+		 */
+		end = folio->index;
 		if (!folio_try_get(folio2))
-			goto no_split;
-
-		if (!folio_test_large(folio2))
 			goto out;
 
+		if (folio2->mapping != folio->mapping ||
+		    !folio_test_large(folio2))
+			goto out_put;
+
 		if (!folio_trylock(folio2))
-			goto out;
+			goto out_put;
 
-		/* make sure folio2 is large and does not change its mapping */
-		if (folio_test_large(folio2) &&
-		    folio2->mapping == folio->mapping)
-			folio_split_or_unmap(folio2, split_at2, min_order);
+		if (page_folio(split_at2) != folio2) {
+			folio_unlock(folio2);
+			goto out_put;
+		}
+		if (!folio_test_large(folio2)) {
+			end = aligned_end;
+			folio_unlock(folio2);
+			goto out_put;
+		}
+
+		/* Split failed: back off to the head of the straddler */
+		if (folio_split_or_unmap(folio2, split_at2, min_order))
+			end = folio2->index;
+		else
+			end = aligned_end;
 
 		folio_unlock(folio2);
-out:
+out_put:
 		folio_put(folio2);
-no_split:
+out:
+		if (pend)
+			*pend = end;
 		return true;
 	}
 	if (folio_test_dirty(folio))
@@ -413,11 +455,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
 	folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
 	if (!IS_ERR(folio)) {
 		same_folio = lend < folio_next_pos(folio);
-		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
-			start = folio_next_index(folio);
-			if (same_folio)
-				end = folio->index;
-		}
+		truncate_inode_partial_folio(folio, lstart, lend, &start,
+					     same_folio ? &end : NULL);
 		folio_unlock(folio);
 		folio_put(folio);
 		folio = NULL;
@@ -427,8 +466,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
 		folio = __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
 						FGP_LOCK, 0);
 		if (!IS_ERR(folio)) {
-			if (!truncate_inode_partial_folio(folio, lstart, lend))
-				end = folio->index;
+			truncate_inode_partial_folio(folio, lstart, lend,
+						     NULL, &end);
 			folio_unlock(folio);
 			folio_put(folio);
 		}
-- 
2.52.0


