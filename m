Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B80606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=IFoDESgI
Received: by kanga.kvack.org (Postfix)
	id B79396B05B3; Mon, 23 Nov 2026 07:26:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2B006B05B4; Mon, 23 Nov 2026 07:26:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18B16B05B5; Mon, 23 Nov 2026 07:26:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3156B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:26:43 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14450A0895
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:26:43 +0000 (UTC)
X-FDA: 85466307486.23.F6A5F9A
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf29.hostedemail.com (Postfix) with ESMTP id 10015120003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:26:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IFoDESgI;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795436801;
	b=lxYe2RyNOfccVAtKw9/I4WCITy40hX4eyYwf6bIH46t5P4+LG1Ouy2oBafebTbwM3GJv4G
	gc+7NlHDkvl0P9u6QtE4crIwjPsf4LxILd5HxlO8bFy7ieiXlpckoz4cTaEuA7c1OdV+Oc
	JE2QHJGC2BiRMGPVu7P1D+n41+6upHg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795436801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DVv1xl61LugGV6/fm0FWU535xu6+vNgLbh/GySgNLxA=;
	b=PDznv2OWGQ45aH0GVh6lhIJD0JX3MTOzIDnZmFgLEecBSu7rIXXl1I4dhDHuRzpMYIh3Iu
	vubkP/SRm8sbwTa32Hmf+5MvVzqP8fjFSSeng4dnRsqMv8sz5tNA+z4W/kAQWwftZ3UOYC
	TXivCmIqTqbtwXWNM66dtAR6Vp4rJtA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IFoDESgI;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795436795; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=DVv1xl61LugGV6/fm0FWU535xu6+vNgLbh/GySgNLxA=;
	b=IFoDESgIhPSq1bmAIwRSI/0rsgboGOgymNhC2dX+jjPL8GYKHawmuHaak2yG55YZSiy9ATIV0g+hyiTBsK6TXViI9VH2nHv6mX7mxpLY7lQ582DyffFDOwQZDSt67oY54oFnzJdYW5lU0aaWuMprOhKnW8P0/6xrZgfHZGXqWc4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XFIMpIN_1795436793;
Received: from localhost.localdomain(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XFIMpIN_1795436793 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 20:26:34 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	hughd@google.com
Cc: baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] mm: shmem: fix discarded data left intact after truncation or hole punching
Date: Mon, 23 Nov 2026 20:26:20 +0800
Message-ID: <6fcc15c466667f6943c34e130212b891b7471c83.1795436423.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 10015120003
X-Rspam-User:
X-Stat-Signature: cwg4ka78iu7sgymzpnytfc7oj5y5kbt3
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795436798-311762
X-HE-Meta: U2FsdGVkX1/UbVK/3AmkCWXBCFCsXWD8p3uH2NerPhI5t//Yc+qI/8lDFEjT981kcphLmBCsTTPzS3p0Xjhm0RSsBvh4V7iUwJYqOxmzx5kuRYFS4c/gmiFaJMVaIVr9jkNia0VZ2PMz1ctFuAcmOh4ubHqCK6ExtUiRoHTGpJIEcm1BKKCam+TG6QZqweWIV+rFREwGPGWlsKZfvx5HaWpNhURLtlAEYESHEpHUFQsbpRq2pOlkjKT6VHN+OdawW5KKzJaMNRpVUM/EF32ox5P2XK4J7sF14mIMTksunCgSMpSJ/p9iA4AMDtGTVOWr88N4eqKEMlOXcwoxqoHPmXHQQl3cF2TXjPcr+X5iaGq3z28lg4AoM2G9RqHStGRvsZfjklnRiSGctv3pQYZ2x0iPxuATee+8tOiWYv9yaWHIvO97ds/PZ+816kjrV6ToWhYvmlNt7U0XBC0T7kvPAQ3qazMlhgBRWIysf5Fg3XOC9k76Zq08QTgDJhESmg+q6inhuqFedn4VNrVPmTv5EkK4FIkVUyfCgYtkTtJmkmTfbXJVBfaOBj3Ti4iYCJfhMvfBvAu7oAlDohXuFW2J0ZJmoWzd7t1PuCjt9SkAbM+G9L/Mn7/FB22s+y/5/MPUd6vtoUlFx0nLZ+SFp/kk8DdPbZhnjpmYpRJ1eCCExDbiBO+25VOLM4haywjm5EQMtS/INxOtLmRD0vMYk+Utr3VhM+sBsmrFH6h0jTuHTp79V6rW8kmWgjLuofoqcJJbNcFrfenTxVOakv06cjqb9VYFLnywnVHIc/I9OYL0uR+HgGu9l+TNMcDmyexh9WzUjIhqYh7Rne57fu/W/0CZ+jOEYeq3gqrZuQ4T8Ky67erg4UI3cnNa3LxjV4RNwHew+HNBSbtTiXf0BSmW5Kv8SqArzsfN62TMkuhxbL0fxC0Q6ZyMrPdWNylOIfuRIBDmkGo1ZsFq8ISUeQ0CBjz
 B+VTJpH/
 UEZIoFozqETI1812EQ86gKEKn+pRAWGUGAfxaXTZx+ACCa5fsyVm08gjLLVuUecePfvwg8t9zD8ZnR1mIv1G0CxlpxbRra/8Fxz7Zpyp5cdRzofYqagFTifEoQJRFMdQSLBOcJCPB/5nCM1g8prNYa6UCMysaRdEY5n1ac5Bv5DqoQW9IbxU6l852O/PpbOdpYIzG1J8BrzXRFvcZKShQaar7UVp/ZSKV0ag9cLgRo/sY+3HiDVTmF1IskupqCEwcAK22Wv1WRuVtEccbpgRO+u4bQ5pgQUCppO7PS9oXlPSXL5fl5LXpr4uDxtK/P/lRDNEpNPL1qnor9gpm8rKo1Y+HwW3gkdkJE1NMwykZVVe3X51qQ3uP0VlnqUK/cmvdjXGt+4asoJDBnDtIE98sPbJ9pQvC6XdkKUIVrQEQsr+s2dg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Truncation and hole punching can leave discarded data intact when boundary
swapin fails.

Specifically, when truncating or hole punching part of an order-0 swap entry,
the boundary swap entry may fail to swap in (e.g. due to a memcg limit), and
shmem_undo_range() then skips zeroing that boundary, so old data can become
visible after a file extension or when reading the punched hole. This is
dangerous, because the truncation and hole punch syscalls do not return an
error, yet the user may still read stale data, which is a data leak.

The same problem exists for a boundary backed by a large swap entry, where
swapin may fail or the large swap entry may fail to split, leaving the truncated
range unzeroed and leaking old data without informing the user.

To fix this issue, since we cannot guarantee that a boundary swap entry can
always be swapped in successfully during truncation or hole punching, propagate
the error to the syscall instead of handling it silently and let the user deal
with it.

That means the truncation and hole punch syscalls will try to get and lock the
boundary folios before changing i_size or unmapping the range. If swapin returns
an error, retry -EEXIST and propagate other swapin errors to the syscall callers
instead of silently skipping boundary handling. This also prevents concurrent
swapin and swapout from recreating crossing large swap entries before zeroing.

Then pass the locked boundary folios to shmem_undo_range() for removal or partial
zeroing. Keep large-folio splitting there, after zeroing, so split failures do
not leave stale data or fail the syscall.

Reported-by: David Hildenbrand (Arm) <david@kernel.org>
Closes: https://lore.kernel.org/all/20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org/
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
This fix tries to address the issue 2 and issue 3 David raised earlier[1], where
boundary swap entries can leave discarded data intact after a successful truncation
or hole punch.

The stale data issue can be reproduced with a reproducer. With this patch, the
truncation and hole punch syscalls will receive an error instead of silently
skipping the boundary handling.

Sending this as an RFC first to discuss the fix approach.

[1] https://lore.kernel.org/all/20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org/
---
 mm/shmem.c | 114 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 86 insertions(+), 28 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index c769d0bc7df9..8f973e622dc8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1306,6 +1306,7 @@ static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
 {
 	const gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
 	struct folio *folio;
+	int error;
 
 retry:
 	folio = filemap_get_entry(inode->i_mapping, index);
@@ -1324,17 +1325,22 @@ static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
 	 * Truncation can look up a large swap entry at or beyond i_size.
 	 * Swap it in directly to bypass the size check in shmem_get_folio().
 	 */
-	if (shmem_swapin_folio(inode, index, &folio, SGP_READ, gfp, NULL, NULL) == -EEXIST)
+	error = shmem_swapin_folio(inode, index, &folio, SGP_READ, gfp, NULL, NULL);
+	if (error == -EEXIST)
 		goto retry;
+	if (error)
+		return ERR_PTR(error);
 	return folio;
 }
 
 /*
  * Remove range of pages and swap entries from page cache, and free them.
  * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocate.
+ * Boundary folios are locked and referenced. Zero them, split large ones,
+ * then unlock and put them. NULL means there is no boundary folio.
  */
 static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
-								 bool unfalloc)
+		struct folio *start_folio, struct folio *end_folio, bool unfalloc)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -1392,25 +1398,19 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 	if (unfalloc)
 		goto whole_folios;
 
-	same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
-	folio = shmem_get_partial_folio(inode, lstart >> PAGE_SHIFT);
-	if (folio) {
-		same_folio = lend < folio_next_pos(folio);
-		folio_mark_dirty(folio);
-		truncate_inode_partial_folio(folio, lstart, lend, &start,
+	if (start_folio) {
+		same_folio = lend < folio_next_pos(start_folio);
+		folio_mark_dirty(start_folio);
+		truncate_inode_partial_folio(start_folio, lstart, lend, &start,
 					     same_folio ? &end : NULL);
-		folio_unlock(folio);
-		folio_put(folio);
-		folio = NULL;
+		folio_unlock(start_folio);
+		folio_put(start_folio);
 	}
-
-	if (!same_folio)
-		folio = shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
-	if (folio) {
-		folio_mark_dirty(folio);
-		truncate_inode_partial_folio(folio, lstart, lend, NULL, &end);
-		folio_unlock(folio);
-		folio_put(folio);
+	if (end_folio && end_folio != start_folio) {
+		folio_mark_dirty(end_folio);
+		truncate_inode_partial_folio(end_folio, lstart, lend, NULL, &end);
+		folio_unlock(end_folio);
+		folio_put(end_folio);
 	}
 
 whole_folios:
@@ -1513,12 +1513,39 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 	shmem_recalc_inode(inode, 0, -nr_swaps_freed);
 }
 
-void shmem_truncate_range(struct inode *inode, loff_t lstart, uoff_t lend)
+/* Check whether the end page of [lstart, lend] lies in the start folio. */
+static bool is_same_boundary_folio(struct folio *start_folio,
+		loff_t lstart, uoff_t lend)
 {
-	shmem_undo_range(inode, lstart, lend, false);
+	if (start_folio)
+		return folio_next_index(start_folio) > lend >> PAGE_SHIFT;
+	return (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
+}
+
+static void shmem_truncate_range_partial(struct inode *inode, loff_t lstart, loff_t lend,
+		struct folio *start_folio, struct folio *end_folio)
+{
+	shmem_undo_range(inode, lstart, lend, start_folio, end_folio, false);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	inode_inc_iversion(inode);
 }
+
+void shmem_truncate_range(struct inode *inode, loff_t lstart, uoff_t lend)
+{
+	struct folio *start_folio = NULL, *end_folio = NULL;
+
+	/* This void interface retains best-effort handling of boundary errors. */
+	start_folio = shmem_get_partial_folio(inode, lstart >> PAGE_SHIFT);
+	if (IS_ERR(start_folio))
+		start_folio = NULL;
+
+	if (lend != -1 && !is_same_boundary_folio(start_folio, lstart, lend)) {
+		end_folio = shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
+		if (IS_ERR(end_folio))
+			end_folio = NULL;
+	}
+	shmem_truncate_range_partial(inode, lstart, lend, start_folio, end_folio);
+}
 EXPORT_SYMBOL_GPL(shmem_truncate_range);
 
 static int shmem_getattr(const struct mnt_idmap *idmap,
@@ -1578,19 +1605,30 @@ static int shmem_setattr(const struct mnt_idmap *idmap,
 	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
 		loff_t oldsize = inode->i_size;
 		loff_t newsize = attr->ia_size;
+		struct folio *folio = NULL;
 
 		/* protected by i_rwsem */
 		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
 		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
 			return -EPERM;
 
+		if (newsize != oldsize && (info->flags & SHMEM_F_MAPPING_FROZEN))
+			return -EPERM;
+		if (newsize <= oldsize) {
+			folio = shmem_get_partial_folio(inode, newsize >> PAGE_SHIFT);
+			if (IS_ERR(folio))
+				return PTR_ERR(folio);
+		}
 		if (newsize != oldsize) {
-			if (info->flags & SHMEM_F_MAPPING_FROZEN)
-				return -EPERM;
 			error = shmem_reacct_size(SHMEM_I(inode)->flags,
 					oldsize, newsize);
-			if (error)
+			if (error) {
+				if (folio) {
+					folio_unlock(folio);
+					folio_put(folio);
+				}
 				return error;
+			}
 			i_size_write(inode, newsize);
 			update_mtime = true;
 		} else {
@@ -1603,8 +1641,8 @@ static int shmem_setattr(const struct mnt_idmap *idmap,
 							holebegin, 0, 1);
 			/* Swapin-error markers are not counted in alloced. */
 			if (info->alloced || !mapping_empty(inode->i_mapping))
-				shmem_truncate_range(inode,
-							newsize, (loff_t)-1);
+				shmem_truncate_range_partial(inode, newsize, (loff_t)-1,
+							     folio, NULL);
 			/* unmap again to remove racily COWed private pages */
 			if (oldsize > holebegin)
 				unmap_mapping_range(inode->i_mapping,
@@ -3895,7 +3933,9 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		struct address_space *mapping = file->f_mapping;
 		loff_t unmap_start = round_up(offset, PAGE_SIZE);
 		loff_t unmap_end = round_down(offset + len, PAGE_SIZE);
+		loff_t lend = offset + len - 1;
 		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(shmem_falloc_waitq);
+		struct folio *start_folio = NULL, *end_folio = NULL;
 
 		/* protected by i_rwsem */
 		if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
@@ -3903,6 +3943,23 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 			goto out;
 		}
 
+		start_folio = shmem_get_partial_folio(inode, offset >> PAGE_SHIFT);
+		if (IS_ERR(start_folio)) {
+			error = PTR_ERR(start_folio);
+			goto out;
+		}
+		if (!is_same_boundary_folio(start_folio, offset, lend)) {
+			end_folio = shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
+			if (IS_ERR(end_folio)) {
+				error = PTR_ERR(end_folio);
+				if (start_folio) {
+					folio_unlock(start_folio);
+					folio_put(start_folio);
+				}
+				goto out;
+			}
+		}
+
 		shmem_falloc.waitq = &shmem_falloc_waitq;
 		shmem_falloc.start = (u64)unmap_start >> PAGE_SHIFT;
 		shmem_falloc.next = unmap_end >> PAGE_SHIFT;
@@ -3913,7 +3970,8 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		if ((u64)unmap_end > (u64)unmap_start)
 			unmap_mapping_range(mapping, unmap_start,
 					    unmap_end - unmap_start, 0);
-		shmem_truncate_range(inode, offset, offset + len - 1);
+		shmem_truncate_range_partial(inode, offset, lend,
+					     start_folio, end_folio);
 		/* No need to unmap again: hole-punching leaves COWed pages */
 
 		spin_lock(&inode->i_lock);
@@ -3991,7 +4049,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 			if (index > start) {
 				shmem_undo_range(inode,
 				    (loff_t)start << PAGE_SHIFT,
-				    ((loff_t)index << PAGE_SHIFT) - 1, true);
+				    ((loff_t)index << PAGE_SHIFT) - 1, NULL, NULL, true);
 			}
 			goto undone;
 		}
-- 
2.47.3


