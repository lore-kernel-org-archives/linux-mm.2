Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85526C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 06:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4686E6B008A; Wed,  9 Sep 2026 02:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41A066B008C; Wed,  9 Sep 2026 02:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30AAA6B0092; Wed,  9 Sep 2026 02:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD7B6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:31:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B01E81A0101
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:31:16 +0000 (UTC)
X-FDA: 85193251752.29.686EB24
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id CC45C40006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:31:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788935475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=2SZCrjhoz3sJ7psu2Wyv+jlUGEFppYf5two//VdlCrE=;
	b=dH4mDepTMuxO9MZRNqCpaMy+MZBL/tU4lRdmxMysd7S170U8bBYOWmayQPOe6qgLD5nBM2
	Td7hukLtMUfup6RtJv5dnJSWLBU5rCFDk5x2Db6AAqvLIXXH/bJz5tf6hmUAIGm1/gD3FI
	4Wlkx8xSEWouAUEutvLr7mVjabFX5ZE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788935475;
	b=uGV7KKrlFjvt4YGJC/l8XeyXOhTuxK8QR3gSnrcpUg+hTUjYNmg+8m4cZxoTcRrEPN1LVy
	anquMvwLIRsTAzNmJwLx360O9KL0bA+P4rMt37ZXJJWU7DU9AEpBRhhIaAxJpgSjMm25vu
	MKTOhyJ4+l3VCXXw+X0xr/SHqi10g2E=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hfrX64zSmzYQv2K
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:30:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 71B6640574
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:31:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgBnUAsh_aBqxXYzBQ--.8536S4;
	Wed, 09 Sep 2026 14:31:07 +0800 (CST)
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
Subject: [PATCH v2] mm/truncate: fix data loss when truncating straddling large folios
Date: Wed,  9 Sep 2026 14:23:39 +0800
Message-ID: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBnUAsh_aBqxXYzBQ--.8536S4
X-Coremail-Antispam: 1UD129KBjvAXoW3ur4UWw1xWr4kJFy7Zr43KFg_yoW8JF18to
	WfJws0vr1FqrWkKa1jkFyxJrykX3ZI9ryfJF13Cr4qvF12q34DAw47JwnrGa1fZr1YkF9x
	W347J3WfArW7Jr1fn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYg7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
	x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWx
	JVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7sRiuWl3UUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CC45C40006
X-Stat-Signature: doxrww4199yzaxxa6srncjmz4u85sohk
X-Rspam-User: 
X-HE-Tag: 1788935472-195092
X-HE-Meta: U2FsdGVkX19wKfxhDJ4SRNYBQUEf2J6L0ogviJAd+QckT1euTyHJwhIzT/y/rpS3x8eFscCWaHBcLEY6vohgCJ6XeTput2B/83NmxMhvAxfBTtoknIP1UpNV5c3fekQRFXGwrKpbZ8A8y/ap65QJFaam4oAaPj2zG8ZkLZsW0Vk4kgPmg/pUB3gIwO/nku4CdNib/KWAODMD8Eql3Cqx+wl72rgjrQXaFRhNuBK6w/2ik9aj4Z63nBNujXxuNqLvaeF/TsyHw/FvyMd5pX6W/N+3gSHFnAOBBmWORjTpap+4i9mgD5u/zozGKnvv/ycscYNgVTXzECDZb3VmolmNiQC55Nmntn8siYFVQDA72qpsaLyR954v8PZm/cgCl9wwpab3VJTmGsZIalm6Fi1VsFWlKQ2P3KpCo3lzpjBiyN0UNohtOoEM7PonvdxQnfv0b36xkCAqXIKCB1LLqcQI3bK/QI4KzaRcAja08XOOqexspQlfFB8N203EIcsbXRRXnz1aIENXsHpCAMKJwANAMKhW+AZ+eR7OP1ie9dbjWYmgKBgNjEV8/gXQGCRIyzx/YNoymjodqchLbSyqGcHKL+EoH2opNLv9mlS8qmEctS/Hq2RfMRpeloAd8QGoiMaBcqKWJ0KMLbtPMEh6Oy44vM+2rw5bmLimhZcrg57bhICNo+cgOQyrTBHdS9WpE/qcuLLRAVHeWfitfZrt7ql35J7+bouAdomoNazwd988K7/mNBeRJgVRwKF7Ju3PIO8jlx8MEszaYzisrHlr0QCsSwkmLS2wnNKdFkwa4GvacUGu5WmcaWKYNyPTccpo7EqWbXMcVss/h8elV/cTwod1HDTHzbBg3xtdxDcJKFGQMJgzywMFsUUSXOaFmRxp3MnqIgXhU+5F5KgxrYVWNw6ShuiUyTemNy+uWK4fYTmY8aqm7Jlw74qUK5RwFrd2I3+k54MpwIGyX3pvqHjgqHu
 X0JXeUSk
 FE3vNZhiEHuli8WqgYaRs4m1Ujvk7/6Mra/7tqe8OaOC3/p2O0Lr3HOdQzJdYqN6mQT8xe/tCj05Ryp15hamJalplbWAHK9hTk9y1T2DVfWYiPRdsgS2/upcxakqPP5PW5DDGsX0/AlE9+qpfJq55MlJYaqjvlizg6d4j
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

In addition, even when both splits succeed, data can still be lost when
the mapping's minimum folio order (min_order) is non-zero. folio_split()
stops at min_order instead of order 0, so the sub-folio containing a
split point stays aligned to 1 << min_order rather than to a page. The
original success path left start at the page-aligned head of the range
and set end to the exact page index of the end edge, neither of which is
a folio boundary in general. Either one could land inside the large
folio at its edge, and the truncate loop would drop that straddling
folio together with its valid out-of-range tail.

For example, a 64K (order-4) folio with min_order = 2 punched from
offset 0 to 36K:

  truncate_inode_pages_range()
    truncate_inode_partial_folio()        # same_folio == true
      1st split at p0 -> [p0-p3, p4-p7, p8-p15]  # non-uniform, min_order
      folio2 = p8-p15 # straddles: p8 in range, p9-p15 tail valid
      2nd split of folio2 -> [p8-p11, p12-p15]   # success
      end = p9                           # BUG: p9 inside [p8-p11]
    loop truncates ... p8-p11           # p9-p11's valid tail is lost

Rework the contract so the caller is told the page range to discard:

  - Return true only when a split occurred, false otherwise. This
    clarifies the existing confusing return value semantics.

  - Add pgoff_t *pstart and *pend out-parameters that receive the page
    range fully covered by [lstart, lend] after any split (or none),
    i.e. the pages wholly within the range and safe to discard. They are
    aligned up (pstart) and down (pend) to the mapping's minimum folio
    order so they always fall on a folio boundary.

  - Rename the byte-range parameters start/end to lstart/lend to avoid
    clashing with the new outputs and to separate byte offsets from
    folio indices.

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
v1->v2:
 - Export pstart as a new parameter so that the generic and shmem
   truncate paths don't need to recompute the start value from the
   return value. (Brian)
 - When min_order is nonzero, align [pstart, pend] to the inner
   boundaries of the folio to ensure they do not point into the middle
   of a large folio, which could otherwise cause valid data within the
   folio to be incorrectly cleared. (Joanne)

v1: https://lore.kernel.org/linux-mm/20260903115018.2034541-1-yi.zhang@huaweicloud.com/

 mm/internal.h |  4 +--
 mm/shmem.c    | 13 +++-----
 mm/truncate.c | 88 +++++++++++++++++++++++++++++++++++----------------
 3 files changed, 67 insertions(+), 38 deletions(-)

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
index 89a1495e55f7..4efbbbba5da5 100644
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
+							lstart, lend, NULL, NULL)) {
 					/*
 					 * If we split a page, reset the loop so
 					 * that we pick up the new sub pages.
diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be47..d88a1b159084 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -206,35 +206,41 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
 /*
  * Handle partial folios.  The folio may be entirely within the
  * range if a split has raced with us.  If not, we zero the part of the
- * folio that's within the [start, end] range, and then split the folio if
+ * folio that's within the [lstart, lend] range, and then split the folio if
  * it's large.  split_page_range() will discard pages which now lie beyond
  * i_size, and we rely on the caller to discard pages which lie within a
  * newly created hole.
  *
- * Returns false if splitting failed so the caller can avoid
- * discarding the entire folio which is stubbornly unsplit.
+ * When @pstart and/or @pend are non-NULL they receive the indexes of the
+ * page range fully covered by [lstart, lend] after any split (or none),
+ * i.e. the range of pages that are wholly within [lstart, lend] and so safe
+ * to discard.
+ *
+ * Return %true if the folio was split, %false otherwise.
  */
-bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
+bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
+				  loff_t lend, pgoff_t *pstart, pgoff_t *pend)
 {
 	loff_t pos = folio_pos(folio);
 	size_t size = folio_size(folio);
 	unsigned int offset, length;
 	struct page *split_at, *split_at2;
+	unsigned long min_nrbytes;
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
 
 	folio_wait_writeback(folio);
 	if (length == size) {
 		truncate_inode_folio(folio->mapping, folio);
-		return true;
+		goto no_split;
 	}
 
 	/*
@@ -248,9 +254,10 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 	if (folio_needs_release(folio))
 		folio_invalidate(folio, offset, length);
 	if (!folio_test_large(folio))
-		return true;
+		goto no_split;
 
 	min_order = mapping_min_folio_order(folio->mapping);
+	min_nrbytes = mapping_min_folio_nrbytes(folio->mapping);
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
 	if (!folio_split_or_unmap(folio, split_at, min_order)) {
 		/*
@@ -259,38 +266,67 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 		 * for shmem truncate
 		 */
 		struct folio *folio2;
+		bool tail_isolated = true;
+
+		if (pend)
+			*pend = round_down(pos + offset + length,
+					   min_nrbytes) >> PAGE_SHIFT;
 
 		if (offset + length == size)
-			goto no_split;
-
+			goto split;
+retry:
 		split_at2 = folio_page(folio,
 				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
 		folio2 = page_folio(split_at2);
 
 		if (!folio_try_get(folio2))
-			goto no_split;
+			goto split;
 
 		if (!folio_test_large(folio2))
 			goto out;
 
-		if (!folio_trylock(folio2))
+		if (!folio_trylock(folio2)) {
+			tail_isolated = false;
 			goto out;
+		}
+
+		/*
+		 * split_at2 may no longer belong to folio2 due to concurrent
+		 * split. Retry to find the correct folio in case it's still
+		 * large.
+		 */
+		if (page_folio(split_at2) != folio2) {
+			folio_unlock(folio2);
+			folio_put(folio2);
+			goto retry;
+		}
 
 		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
-		    folio2->mapping == folio->mapping)
-			folio_split_or_unmap(folio2, split_at2, min_order);
+		    folio2->mapping == folio->mapping &&
+		    folio_split_or_unmap(folio2, split_at2, min_order))
+			tail_isolated = false;
 
 		folio_unlock(folio2);
 out:
+		if (!tail_isolated && pend)
+			*pend = folio2->index;
 		folio_put(folio2);
-no_split:
+split:
+		if (pstart)
+			*pstart = round_up(pos + offset,
+					   min_nrbytes) >> PAGE_SHIFT;
 		return true;
 	}
-	if (folio_test_dirty(folio))
-		return false;
-	truncate_inode_folio(folio->mapping, folio);
-	return true;
+	if (!folio_test_dirty(folio))
+		truncate_inode_folio(folio->mapping, folio);
+no_split:
+	if (pstart)
+		*pstart = offset ? folio_next_index(folio) : folio->index;
+	if (pend)
+		*pend = (pos + size > (u64)lend) ? folio->index :
+						   folio_next_index(folio);
+	return false;
 }
 
 /*
@@ -413,11 +449,8 @@ void truncate_inode_pages_range(struct address_space *mapping,
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
@@ -427,8 +460,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
 		folio = __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
 						FGP_LOCK, 0);
 		if (!IS_ERR(folio)) {
-			if (!truncate_inode_partial_folio(folio, lstart, lend))
-				end = folio->index;
+			truncate_inode_partial_folio(folio, lstart, lend, NULL, &end);
 			folio_unlock(folio);
 			folio_put(folio);
 		}
-- 
2.52.0


