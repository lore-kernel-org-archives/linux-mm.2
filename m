Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B91D3CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 13:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB9E6B009D; Thu, 18 Jun 2026 09:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CDB6B009E; Thu, 18 Jun 2026 09:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8931B6B009F; Thu, 18 Jun 2026 09:14:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AC506B009D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:14:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC3B4140735
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:05:13 +0000 (UTC)
X-FDA: 84893054106.20.7C13A00
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1369220014
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:05:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DFAFERil;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781787912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YyDEvL0Y9z9LLRh/MqCIdyepcOGue4BTdJijYwCJynw=;
	b=EOPAFTJSR0jaRTMEnig19Xcz7aAHVU7pTfduDDBX+f/GI0+3ge8ogfUv0G+ryGUSrfZNn+
	aoPmzv2Hxvaz/4QllLX7V4Pq6j67klGEqbp23nYMrwppeHp5uxlbDMuRtbMyL65d9OVi4J
	8A7EPO5jWo5tLV/pZ2iwIwZPsbTRtqk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DFAFERil;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781787912;
	b=KKIx46TUw0SC3dVUQSXAjlNVOjakpujmoxHvCUJ4RmtYPV8Y/NaUIYMs3D5ALrYEdA0iuq
	I52KCI44hkNeJVMzkOT2Ydx0IZGfx1W2sx5A3dZHbWBQm7l4+2QdAg0yVB0vizXTY+ZIz0
	UbV9uXwcRY1X6ON+BYYZ7w9Mw+ewT3Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781787910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YyDEvL0Y9z9LLRh/MqCIdyepcOGue4BTdJijYwCJynw=;
	b=DFAFERilm5Be/PbFPc/R4Qcl2nZEN+aic8dqQRl1w9He9LptSXUw5+Rv8mA4wYypZ2M6qD
	k4hQxZryEtuv4tkg3HYXe+YwkyZnfVUaAyEEUgxPJxxowmjzMa2y6EmCSOxOvawa/vkb1B
	52BWkFcdQHPqeX+L0AqK6G1XcT76phk=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v4 2/4] mm/percpu: honor GFP constraints when populating chunks
Date: Thu, 18 Jun 2026 21:04:12 +0800
Message-ID: <20260618130414.96383-3-kaitao.cheng@linux.dev>
In-Reply-To: <20260618130414.96383-1-kaitao.cheng@linux.dev>
References: <20260618130414.96383-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wb1y9kjejt5dd8boro5gckh76yiu6664
X-Rspamd-Queue-Id: 1369220014
X-HE-Tag: 1781787911-51088
X-HE-Meta: U2FsdGVkX18rf1N7QK/HYhqQBzxzVnt2fwUxdIKPDpiCbGdMK71yqB+S2b93t+6K3jdZG6IkOUGi4opbCg0iVH4hBHPzhC9Tbs6MubeDorHUsFDzVIM2IPA2zRASTUep9/moV+oQXeMUSfZ5wM2phQ9YI+/pQCuHDCWoBX2bcQ44UW4ijtvWHeok8xclj7jqYPouH2I4qDV1Jm3fohrZhDDbj3YUzGiPK/Tn1zMnrJLANtBHhzrF6PYxXXbU3dE1YGQHOYyDZIPnhnfs9vamgJ6YbBodVbBTwZQzTwLYAF7OvQFAbte+7XwIZcTfQ2laRs0l4irDZtEwd5zJ+znnkOe5jND++YHWjAm/3cKv5OAwy9KqjBBbyW6pWHKHKNZM2WKn4CPro2Q2K1xPLUY0c+ZmUa6sYrYkmpnm2wai+eyXGyBX2NBC2YUeIv00FaXER5ilp3/uk6ztw4rAIGWjOvIPWDTK+NAhlpaEcZCPUIqGchaAJY37VT83mNgHFWjK1bWRVTuqO3ngsyJC8G9VUhj/W/zcN+R12Crd6keCtkZyQe3Z1f/6vJN9deWrBWHYE2qkYmcsagqLZbpyPyN4a+19U4tDUZN4LTTaXqzFR9M367VR0rRDI5uBFE1n/v2vSzoFbJJlzAXRMLm/3XH2AHH6LeRLtOjiFNVEwKWy8bFOKuJdtLi6RDPlH/xJ/cDmPtKtqldsErFwAmdI0hF0bGNcqOmFbtu9/7Ll1CwMMiPQ6tYPs31ryQBsuCMC1m0bDgZK09L0U9xMUj5iYhtcPL1T9BI4ajMF0pZoH57QEgIHc9mNNnUiDlZ1b/jZGD9LJz94Csq8IJXLhAxNDeNpji81lavTUl18GAQPa1OnS+lMswVI04E23HU7UUNsW4wZ9B3N0XR4xzFRnyWqVeUgfhgpmMLv7aiwLJZaNwzyM3MavjaNNcXLmc1Jwyw7hRVUFdJnoCB9rXy8Akv1+q4
 Gwctfeqi
 /6RYeax04j+GkITeJLKFAkzq8H2WTbvGth3kS2UXbWMjLhAlP3vkBpWbdCeGZOv7wWcOSZUJV8PWmDWGAxGoEIO5yVDHlURVd2qL5p6olh2ekou2p44s2EyuS070ZNu34xbBMMxvN8LWw+Y8aDBIlpkZ+e62CF7FV50QbNjSTaNqeSGgT58fevS8ft+Z39LqWkyti5kOkBT6WUufYsgl7vSXh7SFAUT0A9DBv
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
Acked-by: Dennis Zhou <dennis@kernel.org>
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
2.50.1 (Apple Git-155)


