Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F3CCD98D6
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 02:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6226B0088; Thu, 11 Jun 2026 22:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC45A6B0093; Thu, 11 Jun 2026 22:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14036B0088; Thu, 11 Jun 2026 22:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFF316B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 22:27:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F1F71650B1
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:27:44 +0000 (UTC)
X-FDA: 84869674848.10.6C06229
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4D60B180004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:27:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M1H2HE06;
	spf=pass (imf24.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781231262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZtxzLZEWBXulcLtCK2gibovFAvz1jsUS0zrTG+fguM=;
	b=uOkueWFBeoj3XkNY/gMNRR3xIX5TDwadCUG/i3UmV0ifYr1b+UwrpSSOACQsNyWfycxHk+
	4fxQoAWjzEkUmlKRFSxT3FPeJDYa+wetUaE9yDYz4b7vefBQND674rThZh2hB1BYEc1Jj5
	Z2fVrm21H2bk9nJt8MmRDQEwOS+qOcY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M1H2HE06;
	spf=pass (imf24.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781231262;
	b=sZ6uTpTJUactTJ3lIspyYphuinlGHOeMythHD6w13UcZhs3SCcnnlaGbVJ6I6e3KU7eiVu
	ANE4CAbcD2cv1L7mzp3nNKZoc9KkmglUwoMlhbZ9bBuYBQQO33tLEUskKbJsa1VbLFtc7D
	8FqtRBYWpZWvJ1mj9ujrOeMhydbSNhM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781231261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XZtxzLZEWBXulcLtCK2gibovFAvz1jsUS0zrTG+fguM=;
	b=M1H2HE06zFkP6bQE+3n20MsYukCu7vH0fvkGCp0knwqkbBpC5FYvQwgusLwkB8a26pStvl
	UTssrjDPwSljbOZdm3H4PvoJFn/jDSbUc0WhhoYP9DiFAPJyKzhW0cGmOkz7klWa7iv7da
	RXG7ynajKJOzllbZuAK94JehuzzcFJ8=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v3 2/3] mm/percpu: honor GFP constraints when populating chunks
Date: Fri, 12 Jun 2026 10:26:47 +0800
Message-ID: <20260612022648.13008-3-kaitao.cheng@linux.dev>
In-Reply-To: <20260612022648.13008-1-kaitao.cheng@linux.dev>
References: <20260612022648.13008-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4D60B180004
X-Stat-Signature: nq49tzec8wrdka3cwqoj4pz4fhriaxhj
X-Rspam-User: 
X-HE-Tag: 1781231262-361965
X-HE-Meta: U2FsdGVkX19GSefh08Y8imD2NMWmeVecvvpZD7HmMz+tJSwkPcZcBK/RKGdAETe0rslHZWTkZeSHFTMvr+2XkkjJ1hhXCD9XmNRXlwnFkxFshVx84OlNCKAIKzz69KlQlnimHa+FgMfyslWvtvGbS5laAmh8DYNFA2uBGNuGgU/gI0VCdcE0ZMlR2GfpnIpiIYRm5LgclvMwuFtrTR2lMOLPS7VRqx5vrMIZRDBhY9GCZtXU5/sK5ShdgmFxB5l4PAT7wcSw+YyPhuHr0b22EBHDj7dse4HrqYswCzzyI++gSZz6ZTLjElOx/uLshXUWrIUO7D9hgd5+wW8XEHjxwb4iRs0didHPZWAT/K0KkhIdFaHLonM4UV7sDUSuh6pJeBz2K0RkS4Y8ZBN0xZGTB2XiuAJFZpIC2uSA+Qs8+rFIGb42bPExI9K26gbVCFTQ8Npn8hynDSIFghyAvejwb6/FUuCaJfpseQYaIxyJBLNanwyhpQs0E6sEs/YYFVMCs4uQQ8TFc85syJgZJylCkLrgdqKYLiOeEZgToXOvn1xPBPs8lcAJTiVHgN6fpFCDpU466+rTsqep/mKi9xF4WXbnRPRkoOk36Mqfp/QU7p9JjX1EmO22a+2iNEGtY5PotqM6McDopjQnIl/E9q643oAeme4yxITDEFdcI9S6utMiXTkCHa9HKwX406HjxgygfnagSdL+4TzFqnQQTL6PxwyrKpA4b8vAosc4WZC8YprfhuFIbTwRWCPJcT0380Ms5UoaAoYrxpdsm2QEhT2JuD4Au2wKwkApX8KKsaxzkvoJbL1VXS+Ix3Ghw1treNqxykkMbBrUdOziGn9KZM3u4fpni/dGnNE5CdmmdXxBU24F8ixYYW8XjuT+g3VjVBH7kBZsL9+cIvtoAqH+d/UOIcnlcM5IYuWcQ5RqYiTk3LKbKrz/yeCa6xNrY39yKDxDRdOfehZbfG3Vb9C9NjO
 OtxzJ2T6
 /dymLQut70p7HqvUBg0Ra2En//f+M3RbvsWvRFb0XIiJ8Ft8V6kY2OzCRZs5kj4q/qXTgkvD8lRP+xlw5vCQtVVBgA6+KXBykWoKqBsbBhbYY4QKasuq6/py0T/OSWhayCLYSn5TuVSs0RTFtwp5ZG4/KyHo76WhErdzc2nj3TOZxhGsilD83nkkgcEF8aeBHJDhwEQUaDyJ57Mg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

pcpu_alloc_noprof() derives pcpu_gfp from the caller supplied GFP mask and
passes it down to pcpu_populate_chunk().  pcpu_alloc_pages() already uses
that mask for backing page allocation.

However, the populate slow path still has internal allocations and page
table allocations which can lose the caller's allocation context.  The
temporary pages array is allocated by pcpu_get_pages() with GFP_KERNEL,
and pcpu_map_pages() maps the backing pages through
vmap_pages_range_noflush() using GFP_KERNEL.  The latter can allocate
vmalloc page tables implicitly, so a caller which deliberately uses
GFP_NOFS or GFP_NOIO can still enter FS or IO reclaim while populating
a percpu chunk.

This has the same concern as chunk creation: callers such as blk-cgroup
may use GFP_NOIO because they hold locks which can be involved in queue
freeze or IO reclaim dependencies.  If an allocation reaches the percpu
slow path and needs to populate previously unbacked pages, the internal
GFP_KERNEL allocations can defeat that context.

One possible case is blk-cgroup after commit 5d726c4dbeed
("blk-cgroup: fix possible deadlock while configuring policy").
blkg_conf_prep() now serializes against blkcg_deactivate_policy() with
q->blkcg_mutex, and blkg_alloc() was changed to GFP_NOIO for that reason:

  CPU0: blkg_conf_prep()
    mutex_lock(q->blkcg_mutex)
    blkg_alloc(..., GFP_NOIO)
      alloc_percpu_gfp(..., GFP_NOIO)
        pcpu_alloc_noprof(..., GFP_NOIO)
          pcpu_populate_chunk(GFP_NOIO)
            pcpu_get_pages()
	    pcpu_map_pages()
              -> if the selected percpu chunk has unpopulated pages,
	         chunk population may do internal GFP_KERNEL allocations
              -> direct reclaim / writeback can issue IO to this queue
              -> IO waits because the queue is frozen

  CPU1: blkcg_deactivate_policy()
    blk_mq_freeze_queue(q)
    mutex_lock(q->blkcg_mutex)
      -> waits for CPU0
    ... unfreeze only happens after q->blkcg_mutex is acquired/released

So the concern is that the caller deliberately uses GFP_NOIO because it
may hold a lock which can be acquired after queue freeze, but the percpu
slow path can temporarily lose that allocation context.

Pass pcpu_gfp through pcpu_get_pages(), pcpu_map_pages() and
__pcpu_map_pages().  Apply the corresponding memalloc scope around
vmap_pages_range_noflush(), because vmalloc page table allocation does not
pass the GFP mask down explicitly.  Keep the first chunk setup path using
GFP_KERNEL, matching the previous early-init behavior.

Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/percpu-vm.c | 38 ++++++++++++++++++++++++++------------
 mm/percpu.c    |  2 +-
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 69b00741dc68..ccd03cc152d4 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -21,6 +21,7 @@ static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
 
 /**
  * pcpu_get_pages - get temp pages array
+ * @gfp: allocation flags passed to the underlying allocator
  *
  * Returns pointer to array of pointers to struct page which can be indexed
  * with pcpu_page_idx().  Note that there is only one array and accesses
@@ -29,7 +30,7 @@ static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
  * RETURNS:
  * Pointer to temp pages array on success.
  */
-static struct page **pcpu_get_pages(void)
+static struct page **pcpu_get_pages(gfp_t gfp)
 {
 	static struct page **pages;
 	size_t pages_size = pcpu_nr_units * pcpu_unit_pages * sizeof(pages[0]);
@@ -37,7 +38,7 @@ static struct page **pcpu_get_pages(void)
 	lockdep_assert_held(&pcpu_alloc_mutex);
 
 	if (!pages)
-		pages = pcpu_mem_zalloc(pages_size, GFP_KERNEL);
+		pages = pcpu_mem_zalloc(pages_size, gfp);
 	return pages;
 }
 
@@ -191,10 +192,22 @@ static void pcpu_post_unmap_tlb_flush(struct pcpu_chunk *chunk,
 }
 
 static int __pcpu_map_pages(unsigned long addr, struct page **pages,
-			    int nr_pages)
+			    int nr_pages, gfp_t gfp)
 {
-	return vmap_pages_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT),
-			PAGE_KERNEL, pages, PAGE_SHIFT, GFP_KERNEL);
+	unsigned int flags;
+	int ret;
+
+	/*
+	 * The vmalloc page table allocation path does not pass @gfp down
+	 * explicitly.  Apply the corresponding memalloc scope so implicit
+	 * page table allocations preserve NOFS/NOIO constraints.
+	 */
+	flags = memalloc_apply_gfp_scope(gfp);
+	ret = vmap_pages_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT),
+				       PAGE_KERNEL, pages, PAGE_SHIFT, gfp);
+	memalloc_restore_scope(flags);
+
+	return ret;
 }
 
 /**
@@ -203,6 +216,7 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
  * @pages: pages array containing pages to be mapped
  * @page_start: page index of the first page to map
  * @page_end: page index of the last page to map + 1
+ * @gfp: allocation flags passed to the underlying allocator
  *
  * For each cpu, map pages [@page_start,@page_end) into @chunk.  The
  * caller is responsible for calling pcpu_post_map_flush() after all
@@ -211,8 +225,8 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
  * This function is responsible for setting up whatever is necessary for
  * reverse lookup (addr -> chunk).
  */
-static int pcpu_map_pages(struct pcpu_chunk *chunk,
-			  struct page **pages, int page_start, int page_end)
+static int pcpu_map_pages(struct pcpu_chunk *chunk, struct page **pages,
+			  int page_start, int page_end, gfp_t gfp)
 {
 	unsigned int cpu, tcpu;
 	int i, err;
@@ -220,7 +234,7 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk,
 	for_each_possible_cpu(cpu) {
 		err = __pcpu_map_pages(pcpu_chunk_addr(chunk, cpu, page_start),
 				       &pages[pcpu_page_idx(cpu, page_start)],
-				       page_end - page_start);
+				       page_end - page_start, gfp);
 		if (err < 0)
 			goto err;
 
@@ -271,21 +285,21 @@ static void pcpu_post_map_flush(struct pcpu_chunk *chunk,
  * @chunk.
  *
  * CONTEXT:
- * pcpu_alloc_mutex, does GFP_KERNEL allocation.
+ * pcpu_alloc_mutex, does @gfp allocation.
  */
 static int pcpu_populate_chunk(struct pcpu_chunk *chunk,
 			       int page_start, int page_end, gfp_t gfp)
 {
 	struct page **pages;
 
-	pages = pcpu_get_pages();
+	pages = pcpu_get_pages(gfp);
 	if (!pages)
 		return -ENOMEM;
 
 	if (pcpu_alloc_pages(chunk, pages, page_start, page_end, gfp))
 		return -ENOMEM;
 
-	if (pcpu_map_pages(chunk, pages, page_start, page_end)) {
+	if (pcpu_map_pages(chunk, pages, page_start, page_end, gfp)) {
 		pcpu_free_pages(chunk, pages, page_start, page_end);
 		return -ENOMEM;
 	}
@@ -319,7 +333,7 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk,
 	 * successful population attempt so the temp pages array must
 	 * be available now.
 	 */
-	pages = pcpu_get_pages();
+	pages = pcpu_get_pages(GFP_KERNEL);
 	BUG_ON(!pages);
 
 	/* unmap and free */
diff --git a/mm/percpu.c b/mm/percpu.c
index b0676b8054ed..4d89965cba16 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -3256,7 +3256,7 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
 
 		/* pte already populated, the following shouldn't fail */
 		rc = __pcpu_map_pages(unit_addr, &pages[unit * unit_pages],
-				      unit_pages);
+				      unit_pages, GFP_KERNEL);
 		if (rc < 0)
 			panic("failed to map percpu area, err=%d\n", rc);
 
-- 
2.43.0


