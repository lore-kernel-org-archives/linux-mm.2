Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E73DC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E1E6B009B; Thu, 30 Jul 2026 05:06:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF656B009E; Thu, 30 Jul 2026 05:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ED026B009D; Thu, 30 Jul 2026 05:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 696416B0099
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:06:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D7C0A1C12A3
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:06:55 +0000 (UTC)
X-FDA: 85044863190.17.C8EB615
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 28CEC1C0006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:06:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HL9HYVNw;
	spf=pass (imf18.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785402414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qWCEUI+NN1G0IgJAvIVORNYcGPI+6TMgNy1FVm355BE=;
	b=Ax0uS/qecVx5nLb1S+uVhcQf+d1y++qwNL4LNma29yv/BK8FlTExt6BBNC1Kz+RZ9D8OK3
	mqrryddNnk6zNtpYdamNnJYGA/xsyrQ8ySWr6Jhsg8onQzseuPRGygpLAbcqEPGQ+dPK8E
	xeKMiPm+zfHYFTpIIYeAUvFuK/nFn7U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785402414;
	b=QXd83ikRerIkZOCjwMXjQ6z8MkRQBH75AX6PWuOqNuUNOl3j7JEXf0ML7v5a6EU7BrUEEu
	2gku5ADLvvPLaCfIr4LcHWfw2bbpzhR8ktSZSLjWxqzbLZv8M4qMu7cos385CsQFRe6GZF
	bSxlBgYN0d5Xl7mbAxZr8smNJVnGCDs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HL9HYVNw;
	spf=pass (imf18.hostedemail.com: domain of iprintercanon@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=iprintercanon@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-39c7ed5410bso10500011fa.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785402413; x=1786007213; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qWCEUI+NN1G0IgJAvIVORNYcGPI+6TMgNy1FVm355BE=;
        b=HL9HYVNwtTMtCOUUtgY14iYyI3bFagi0Cn0oBk80v7jTNmBu3BLXNxOahFwpsYAjmL
         sOXlRkZSGlguURLhjqkFhFy/vQG16s+wTGStVZEi8dwXIxcWcnkemv5FJW2dUwWnRKUq
         yiL4Vtj+7RvvG28vyTUfeVXN6XfCBFIAikmRvPMakQQ3ZlZPbJr1EoAHK/AEOHGWb6Yk
         ovr3HxgIXaQRaPUx3wHqzyh6382vcmbcd6cORG5UdlrE31IB9mLVkYw8hoWMgxwvdJp0
         1q8sUF9NA09l6qguSBf8cDwxVNs3O1bq9/MrSzPWdKusurUprnbUIuFViiOnQkShVnVM
         Wmnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785402413; x=1786007213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qWCEUI+NN1G0IgJAvIVORNYcGPI+6TMgNy1FVm355BE=;
        b=QjwhWR4f8bAlgZ74SkJVYLE/1cPSgMuayrgtqxHhVYjxB1juSQfBMUUXt3Kq7oI4iF
         rAiS4AOFFGDyveqSgUYztVAOr/FBIkSiysOpUZ7BlCx7qh9NDONwq1GPj4FYjsBDL4T3
         zG3vVi52Wbx2OnsI6diFkmC7JUFV/L9ic1IE6SQfYbyQJ9j8bc48AiZ2gDIcrEiOUhRb
         9DxMwYmbiPCYUx5ACMEcTLhBGnNNNfqdzMn2UA9QlCF6cdYWiv4w1mMyLMvJtn6q76yx
         iEzVX+RFiDAIgRTFg/68F//EoHuWqtNoVDxrNW6y72E2kk14mbnbx2TvaQ/Ta5N/qIvr
         JFYA==
X-Gm-Message-State: AOJu0YyZlS4m13V/b83Gh0utpGPnXICFtnjRXeawv2NpZo88qnrru4Rb
	60HlrtX+qu0V9kknfoO0m+Yzhmezu6+1XE3uQg7bfu0JOR8JoT9ydX7z0uZYqQ==
X-Gm-Gg: AR+sD11cV61OhlHMIZ6LEqh6GOXOgRN9O962JFj0hR0YJ4JL5ZU770sM8+6wUWnwQ6k
	QTUsemvKL38qcMw+SiITcivjChYQzOEk/34ZNa3LkQpiEy94OzNDxNHuBnzzA7dUozo6McIqbfu
	beZnAEn2U2vLiHM9HnpY6k2X7wZKhUmt+HHQ59V+16lRfRPabP4lENDiJdEqudBigttHgWLxf/s
	556MQDdGeXYqzdxDP5wjpbbcZrBFdSpREGIKXWCOAthZ8hiTUc6ynSjTA6ZjHVdKsl4CGi+kL/T
	VfTDVFQ1g+9p4ppjIdJTU25WX+rCOqLEgQUEutosrkEnk8AeYOiFl9dUXPsp4rHU4GE/CC2gpfJ
	q3QHppCftPudsppvLe8tjcxG4x/bBcoEkNM59pNk8+5rQaIf7fSRmFlwBxx7Jd6rRafv+PgVZPA
	oyXAUm+piBjnSjv1RDoKba405JPBIgEWMekaMTKq7SRHiksA0s3px6L98kgMF1dkLlf9cxq0M1O
	J8ZycStRMpEkSpgub9Db/Co09W3murrarlvMDAOFY3AFTX7a11CZWI5VA==
X-Received: by 2002:a2e:ad13:0:b0:39a:e9c1:5809 with SMTP id 38308e7fff4ca-39f6b82fb07mr2942581fa.3.1785402412414;
        Thu, 30 Jul 2026 02:06:52 -0700 (PDT)
Received: from localhost.localdomain (46-138-176-102.dynamic.spd-mgts.ru. [46.138.176.102])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39f6ac80d6bsm1928641fa.29.2026.07.30.02.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 02:06:52 -0700 (PDT)
From: Artem Lytkin <iprintercanon@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	urezki@gmail.com,
	willy@infradead.org,
	shivamkalra98@zohomail.in,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] mm/vmalloc: make vm_struct.nr_pages an unsigned long
Date: Thu, 30 Jul 2026 12:06:28 +0300
Message-ID: <20260730090628.65814-4-iprintercanon@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729175708.7074-1-iprintercanon@gmail.com>
References: <20260729175708.7074-1-iprintercanon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 28CEC1C0006
X-Stat-Signature: zmruy1bkqhgaoymoajy3g6aw57qxatx6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785402414-291538
X-HE-Meta: U2FsdGVkX1/aCjQ0yVmgqet1NqW4I7VNqpBHfpljqKzjujrLPG4l5sIoPL+iRO0YqZZZMNLWluGBsY4E7l0ryyIjHxl2Y9ZGWwclnp6uVLD8UoFOIagKGz46yWr9e8IioWte+msYrebizIkN1Ii3KDns2D7aI5WYgfiZTAfQYOFo6y6ypEN7bebcEXWCOE5EJBE4j1lTOsw7zXo+39ArWUB4f73YZSahMBs+QygevO3eip3Cie48pfWcNJ+taffCaqnqUVMGiC2bDe4eoIka7bX1oRNPYUCTErFfsZyIWiEFkNTQpyvL78c1tx5G6yFmDgKuVeDmqvL+nln0CbmwcG/hSoQW4bATG4yc/uTmRhRpj1xYvo5EQtye1kKW4lSU3r6Nnso0ppUO2vi6fzbtWGJnpr+R00aQIQcffpraTUZNA5yJ27cAzR9toTeNby2XX1mBnqlFXeuxmG+W+V5XFJx0uIOuZtxB/od6U1jpbXzb+o/oy+Hmg4bY2PxEKNWhgLx8Lh9mc1QB3KTDXrv0CPePM5vhtWWzzRuBal8ZVmAQIZ5D0s9PcY/l5+VgRQi8Cklf2Na8LCUtNvj4N2SQ920PbXofzJvuIqUHPa6U6cLr+IUfkZ71CGV/J6AD5Wr3bvDtcYlXFVLcsXw3FRF64mR4TimuuDktkK6ml88VANbjSrcRXtz1EHYfNNVD3qbf3MZitv/cmuMvOSJA7ZSwuUKyc7XqtKfFMTzaxl7nYRrUzrAa9cMUnLjqVWlC43n9b0Z47/kFlMExWKAyk4er05c5Oj4mHENc2Gu2lNFkL1Diooev0GbHHPY8vhKyqgr8jeD6Q2CJXFoWgS27dZAN6bXYoAL79ThJSU5IBWI0qe+WlOMILeiRtxJ8nG9gXOZAk4yoV1fcGkMj1TLLPBDmFco2Ix6DCd2EqrIzIfdWGFqZy16jz5bQAYPgjoaEQfIJ6GH2LzEphCpnEJYmLjr
 xsi0Dw9m
 uvDNUqoF2S6YkexMQCMvw5+K+a0eHH+JY46Bk1sKVq3gzbzgPm1swkglOk6qUpbj8UoF/2A+T4Mja6964n/6lRO6qSe7qU2peg+tKq3iS/ElXUk4fEWJ9PoS4vD+xn+RwAOxBeLOfaLMN30CrScltJJA7Ofuy40Fs6A1XeGDXLr58926hSmRf/VNPoI1PNHAoceWc34fqrokRvR795j8uOQEdXF9f1kn2tiNvxLWwPV53mUytsXrLSSCjoWVsqU/arpw1V3pFlILybNENMqsOGojuL387Pf8/9cTy70ibfUKxX14F7MbtNt9Pp3WntW+MiYmYEGA9JIyH1M4DGamNIfbBFPZzQhtFi6k/wabLi4fbUETa3qL18xXkqmqtgL0nXEpoLQPLupIkgWG26+GlR5vTRv107V1bRrZ+MnCrU8DZYVODnHmlxmRyPjfWVOBaRYaBrq66xkU8m4pxUsp0wpHWWcNuKvin3jiZL3m/TP2h/85Ztr6oHC33E2fzRzNP6FQZX0L7Cwk0agRMzrXdxBqpn5rLd5mRxb2+JRqbixeQvZpN+3K7o1FTFLs/kfnqcnRErvbA3tCgI/Fa0URx1/tqJVUWr6btXjh5tz+GIOnyVxQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_struct::nr_pages is an unsigned int, and the file repeatedly derives a
byte count from it as nr_pages << PAGE_SHIFT. A shift is evaluated in the
type of its promoted left operand, so those expressions are 32-bit
arithmetic and wrap at 4 GiB of bytes, which is only 2^20 pages with
4 KiB pages. Every such site therefore depends on someone remembering a
cast. vmap() has one. The two commits fixed by the preceding two patches
did not.

v1 of this patch was ambiguous about how much of that has been seen in
practice, so to be explicit: none of it comes from a bug report, the
series comes out of reading the code. What is reachable on current
hardware is the 4 GiB wrap. A single vzalloc() of 4 GiB needs a machine
with more than 4 GiB of memory and nothing else, and /proc/kcore then
reads such an area as zeros while reporting a successful read. The
vrealloc() case has the same cause, but no in-tree caller grows an
allocation that far, so it stays latent. The two thresholds above that
are not equally far away. A count above 2^32, where the field itself
truncates, is out of reach: that is 16 TiB, and as Matthew Wilcox notes,
current hardware cannot populate it, topping out near 12 TiB with eight
fully loaded sockets. The 2^31 point, where the plain int page indexes
below stop working, is 8 TiB, which such a machine could in principle
hand to one allocation, since the only size gate on a request is the
totalram_pages() check in __vmalloc_node_range_noprof(). No in-tree caller
comes near it, so that one is unexercised rather than impossible.

Widening the field is still worth doing, because it retires the 4 GiB
class of bug at the type level instead of one call site at a time, and
the casts go with it.

Widen the field and everything that feeds or consumes it:

  - vm_area_alloc_pages() takes and returns a page count that is stored
    into nr_pages, so its parameter, its return type and the nr_allocated
    and nr_remaining accumulators widen with it. The 100 page cap on a
    bulk request stays narrow, only its literal becomes 100UL.

  - nr_small_pages in __vmalloc_area_node() is derived from a 64-bit size
    and compared against nr_pages, so it widens too. Before this the
    store truncated at 16 TiB, which sized area->pages from the wrapped
    count while the mapping still covered the full size. The cast on
    array_size next to it was already redundant and goes away with it.

  - new_nr_pages and old_nr_pages in vrealloc_node_align_noprof() widen,
    which drops four casts, and the casts added by the two preceding
    patches are no longer needed either.

  - vm_area_free_pages() takes a page index range.

Three counters that index area->pages were plain int and would have
overflowed at 2^31 pages: in set_area_direct_map(), in vm_reset_perms()
and in the bulk allocation loop, where the index is seeded from
nr_allocated. They become unsigned long.

Two prints needed fixing. vmalloc_dump_obj() used %u, and
vmalloc_info_show() printed the unsigned field with %d, which would have
shown a negative page count. show_numa_info() used a single unsigned int
as both the page index and the node id, so the page loop gets its own
counter.

The mapping path is deliberately left alone. vmap_pages_pte_range() and
the levels above it carry the page cursor as int *nr, seeded in
vmap_pages_range_noflush_walk(). That is not a cap: past 2^31 base pages
it overflows and indexes area->pages with a negative value. It is also
not made worse here, because an unsigned int nr_pages already spanned
2^31 to 2^32-1, and nothing about a request's size was ever gated on the
width of that cursor. Widening it touches every level of the walker and
is separate work.

Nothing outside mm/vmalloc.c needs a change to build or to behave as
before. Most of those users index the pages array or shift the count by
PAGE_SHIFT, which is unsigned long arithmetic either way. Three hand it
to a narrower parameter: set_memory_rox() in
execmem_cache_populate_alloc() and release_pages() in
free_mod_tags_mem() take an int page count, and clear_pages() in
alloc_thread_stack_node() takes an unsigned int. Two of those already
narrowed an unsigned int, and none of the three can approach 2^31: a
thread stack is THREAD_SIZE / PAGE_SIZE pages, and an execmem block and
the module tag area are both far smaller. kexec_handover stores the count
into a 32-bit field of its own ABI, which caps that interface exactly
where it did before.

On x86-64 sizeof(struct vm_struct) stays 72 bytes with
CONFIG_HAVE_ARCH_HUGE_VMALLOC=n, since the existing padding before
phys_addr absorbs the change, and becomes 80 with it enabled. Both sizes
come from the same kmalloc-96 bucket that __get_vm_area_node() allocates
from, so the footprint per area does not change either way.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Artem Lytkin <iprintercanon@gmail.com>
---
 include/linux/vmalloc.h |  2 +-
 mm/vmalloc.c            | 62 ++++++++++++++++++++---------------------
 2 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index e4d8d0a9f30f9..aed121d729b01 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -62,7 +62,7 @@ struct vm_struct {
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
 	unsigned int		page_order;
 #endif
-	unsigned int		nr_pages;
+	unsigned long		nr_pages;
 	phys_addr_t		phys_addr;
 	const void		*caller;
 	unsigned long		requested_size;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bf9e32cf93fc9..196da8738cf10 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3404,7 +3404,7 @@ struct vm_struct *remove_vm_area(const void *addr)
 static inline void set_area_direct_map(const struct vm_struct *area,
 				       int (*set_direct_map)(struct page *page))
 {
-	int i;
+	unsigned long i;
 
 	/* HUGE_VMALLOC passes small pages to set_direct_map */
 	for (i = 0; i < area->nr_pages; i++)
@@ -3420,7 +3420,7 @@ static void vm_reset_perms(struct vm_struct *area)
 	unsigned long start = ULONG_MAX, end = 0;
 	unsigned int page_order = vm_area_page_order(area);
 	int flush_dmap = 0;
-	int i;
+	unsigned long i;
 
 	/*
 	 * Find the start and end range of the direct mappings to make sure that
@@ -3493,10 +3493,10 @@ void vfree_atomic(const void *addr)
  * Caller is responsible for unmapping (vunmap_range) and KASAN
  * poisoning before calling this.
  */
-static void vm_area_free_pages(struct vm_struct *vm, unsigned int start_idx,
-			       unsigned int end_idx)
+static void vm_area_free_pages(struct vm_struct *vm, unsigned long start_idx,
+			       unsigned long end_idx)
 {
-	unsigned int i;
+	unsigned long i;
 
 	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
 		for (i = start_idx; i < end_idx; i++)
@@ -3819,12 +3819,12 @@ static inline gfp_t vmalloc_gfp_adjust(gfp_t flags, const bool large)
 	return flags;
 }
 
-static inline unsigned int
+static inline unsigned long
 vm_area_alloc_pages(gfp_t gfp, int nid,
-		unsigned int order, unsigned int nr_pages, struct page **pages)
+		unsigned int order, unsigned long nr_pages, struct page **pages)
 {
-	unsigned int nr_allocated = 0;
-	unsigned int nr_remaining = nr_pages;
+	unsigned long nr_allocated = 0;
+	unsigned long nr_remaining = nr_pages;
 	unsigned int max_attempt_order = MAX_PAGE_ORDER;
 	struct page *page;
 	int i;
@@ -3872,7 +3872,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	if (!order) {
 		while (nr_allocated < nr_pages) {
 			unsigned int nr, nr_pages_request;
-			int i;
+			unsigned long i;
 
 			/*
 			 * A maximum allowed request is hard-coded and is 100
@@ -3880,7 +3880,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			 * long preemption off scenario in the bulk-allocator
 			 * so the range is [1:100].
 			 */
-			nr_pages_request = min(100U, nr_pages - nr_allocated);
+			nr_pages_request = min(100UL, nr_pages - nr_allocated);
 
 			/* memory allocation should consider mempolicy, we can't
 			 * wrongly use nearest node when nid == NUMA_NO_NODE,
@@ -4026,12 +4026,12 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
-	unsigned int nr_small_pages = size >> PAGE_SHIFT;
+	unsigned long nr_small_pages = size >> PAGE_SHIFT;
 	unsigned int page_order;
 	unsigned int flags;
 	int ret;
 
-	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
+	array_size = nr_small_pages * sizeof(struct page *);
 
 	/* __GFP_NOFAIL and "noblock" flags are mutually exclusive. */
 	if (!gfpflags_allow_blocking(gfp_mask))
@@ -4525,7 +4525,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	}
 
 	if (size <= old_size) {
-		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+		unsigned long new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
 		/* Zero out "freed" memory, potentially for future realloc. */
 		if (want_init_on_free() || want_init_on_alloc(flags))
@@ -4554,7 +4554,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 		    !(vm->flags & (VM_FLUSH_RESET_PERMS | VM_USERMAP)) &&
 		    gfp_has_io_fs(flags)) {
 			unsigned long addr = (unsigned long)kasan_reset_tag(p);
-			unsigned int old_nr_pages = vm->nr_pages;
+			unsigned long old_nr_pages = vm->nr_pages;
 
 			/*
 			 * Use the node lock to synchronize with concurrent
@@ -4567,16 +4567,13 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 			spin_unlock(&vn->busy.lock);
 
 			/* Notify kmemleak of the reduced allocation size before unmapping. */
-			kmemleak_free_part(
-				(void *)addr + ((unsigned long)new_nr_pages
-						<< PAGE_SHIFT),
-				(unsigned long)(old_nr_pages - new_nr_pages)
-					<< PAGE_SHIFT);
+			kmemleak_free_part((void *)addr +
+					   (new_nr_pages << PAGE_SHIFT),
+					   (old_nr_pages - new_nr_pages)
+						<< PAGE_SHIFT);
 
-			vunmap_range(addr + ((unsigned long)new_nr_pages
-					     << PAGE_SHIFT),
-				     addr + ((unsigned long)old_nr_pages
-					     << PAGE_SHIFT));
+			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
+				     addr + (old_nr_pages << PAGE_SHIFT));
 
 			vm_area_free_pages(vm, new_nr_pages, old_nr_pages);
 		}
@@ -4588,7 +4585,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= (unsigned long)vm->nr_pages << PAGE_SHIFT) {
+	if (size <= vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during
@@ -4895,7 +4892,7 @@ long vread_iter(struct iov_iter *iter, const char *addr, size_t count)
 			 * mapping types (vmap, ioremap) don't set nr_pages.
 			 */
 			size = (vm->flags & VM_ALLOC && vm->nr_pages) ?
-				       ((unsigned long)vm->nr_pages << PAGE_SHIFT) :
+				       (vm->nr_pages << PAGE_SHIFT) :
 				       get_vm_area_size(vm);
 		else
 			size = va_size(va);
@@ -5400,7 +5397,7 @@ bool vmalloc_dump_obj(void *object)
 	struct vmap_area *va;
 	struct vmap_node *vn;
 	unsigned long addr;
-	unsigned int nr_pages;
+	unsigned long nr_pages;
 
 	addr = PAGE_ALIGN((unsigned long) object);
 	vn = addr_to_node(addr);
@@ -5420,7 +5417,7 @@ bool vmalloc_dump_obj(void *object)
 	nr_pages = vm->nr_pages;
 	spin_unlock(&vn->busy.lock);
 
-	pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
+	pr_cont(" %lu-page vmalloc region starting at %#lx allocated at %pS\n",
 		nr_pages, addr, caller);
 
 	return true;
@@ -5438,16 +5435,17 @@ bool vmalloc_dump_obj(void *object)
 static void show_numa_info(struct seq_file *m, struct vm_struct *v,
 				 unsigned int *counters)
 {
-	unsigned int nr;
 	unsigned int step = 1U << vm_area_page_order(v);
+	unsigned long i;
+	unsigned int nr;
 
 	if (!counters)
 		return;
 
 	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
-	for (nr = 0; nr < v->nr_pages; nr += step)
-		counters[page_to_nid(v->pages[nr])] += step;
+	for (i = 0; i < v->nr_pages; i += step)
+		counters[page_to_nid(v->pages[i])] += step;
 	for_each_node_state(nr, N_HIGH_MEMORY)
 		if (counters[nr])
 			seq_printf(m, " N%u=%u", nr, counters[nr]);
@@ -5505,7 +5503,7 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 				seq_printf(m, " %pS", v->caller);
 
 			if (v->nr_pages)
-				seq_printf(m, " pages=%d", v->nr_pages);
+				seq_printf(m, " pages=%lu", v->nr_pages);
 
 			if (v->phys_addr)
 				seq_printf(m, " phys=%pa", &v->phys_addr);
-- 
2.43.0


