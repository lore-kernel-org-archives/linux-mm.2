Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EEF7606A339
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=T4ILRyin
Received: by kanga.kvack.org (Postfix)
	id 385796B05B1; Sun, 22 Nov 2026 07:40:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335FE6B05B2; Sun, 22 Nov 2026 07:40:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2736A6B05B3; Sun, 22 Nov 2026 07:40:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECF9D6B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:39:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 05F351C4028
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:39:56 +0000 (UTC)
X-FDA: 85462711992.21.7569FA9
Received: from mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
	by imf12.hostedemail.com (Postfix) with ESMTP id CC88140005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:39:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T4ILRyin;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351194;
	b=RPbIJ8qJfKTOPPguoC1epyLuh+hoARFLdlUorgwXHPQ541fxOHKD3V8rKxwW1L0CKSwgd2
	v3B+23eACB5kuPP/v8s+IOSunjFPMg18TB8wFfEvucqFHt6rxm5zJh27e9c8kUoHLedB59
	jqISIChddVCYgOKLarPKHG2kvwo7Q3s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzvQnovZtrFEMPgZXasAfIWgMC+NCMM2whiEhl6NtVU=;
	b=gfYXHkS35oKfppSCh/4u1Nc7WrSwUpvRDUO4GxHWJMdf0kZ/4I6/1h1WXcUMrsuAwHjxlt
	UI0mkRyHUTxdOf0nXHphd3Xl/JV7ty4HexN0YnbmYV3eJa2ZagnqwES58JGmkN0QWre54l
	Lp4EOh7ufduhCG2GvNPy06dGAR1e07o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T4ILRyin;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UyaDXEYJfdQ0U95itr/GgGSIbf5fkoLgHgSVX6J0rX8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351192; v=1; x=1795955992;
 b=T4ILRyinXCtBpyExnli4Y/mnoP2zd0CxCs7g8ikb147NIbLVl27bfC8FniyF4NO2Vey84N1J
 NP18L1fMlZb1JGCuTvgxGVujGMj64zBSiTNq9kB40IwWO3hlojE1MnPB4eqCFJnOhio0epkq/WZ
 ASIeLC7QzaMNlFEhMF9QuKws=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6ff4581e564d427f;
	Sun, 22 Nov 2026 12:39:52 +0000
X-Mizu-Trace-ID: 6ff4581e564d427f
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	baoquan.he@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v6 01/14] mm/vmalloc: support vmalloc-backed VM_SPARSE areas
Date: Sun, 22 Nov 2026 20:39:05 +0800
Message-ID: <20261122123918.3486916-2-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261122123918.3486916-1-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ujoo6p5qnyutrruynoh8gtenujuesosc
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CC88140005
X-HE-Tag: 1795351193-154902
X-HE-Meta: U2FsdGVkX19cQAR0yJABcA42XRr8Quiwva4D17XlWcH7BjOe4im0oyQAJLA6EBT/3MqDRka20Oe7lJ+KW7YNmldJYBuhHhUFtW9BVEzdm2Jha6j/pp9ol92DYDPSKCXwEQdhpD0Bw8SaslUZe04Xj+A7X96l6b+96A2bSGDHz/z4QpkyRdnMoVA78t3vPpbb+i/v54Xj2f8yEA6F80uySebYxHeqRyzCXdGZZksCU8iP8RCuiFf8vO4feX3iETg87PWsBRwKFVRviVjJa/mXBI4np8NMzCmPgMn52E82MdcNtu8EJ7b3eOyGul2f5NQz88qP+nEqWjR9aVKBkclwyfReRf0CJUKHGpo0hXaZJxYF/zQWv3vCe1K3i19Dndt6+SmqAkxFVppkcbqqC4SK8s6aLczQLyBS83g2fcJhaWe7qB+jO8KBtH/uE3PgKhDSkYfLNTLdFWhPXysqf4Ff8Ip2xJe9Qd3r8Trhi/i+1eJsBM9gzfZCnolV/9Rd5vWxKGWsI0bn1lf6YR+DtiWONLcf/u4eE7oMUuPobCxkHwdRhxZWJx9Db5BfDIlEOxbL4/IV5n9l4YdvfCAAWw65RUocNoxHL9ZVj1gyg3L/m7aQyvQBn4UGJU1N8TUtzsAuMSjH59PFlBc7NhiVZp9w4CKGR2WXESxxVA8lceLkpPhZtVDL0K8969dadoDpXK7egVBEfkqD9XLnJ9u2PVpFoYYXXd1I63keU9KgXAAr/uLxKOdLPtkW8ek/wKeLd2Cr8oQXzYHtAtW01MMYnQU+jcCO1qCymFiEsVEgExN1krX8NLAf05YZfdbrJi7PN4uIFYNWvN7JE1aXVk+x1TiyNl9ADWZVJtiyMEoLw30rOp9jMVRZAIgB6u2eNCkshUauAAs42MZmLu3t2BXezecj8oEBE108irm1TWuCkJoMXg05/CmqfTLTH11dd4IJgQvguPbIzI7BFEdc+lHmwPc
 T/CLetZY
 y6RjwOz3VhRtQw5vcmTZrVGaZQnF2Z71Lo2ZjptODRoveRymKbx7RB0xP8UUWolNMRSPrOO7ovPeRswCdgJkyE9g+ZKncRI9alTpJjc5O5d1wrp/miEqySpqhF/t/F/g8FRwiB6mvWJ+QWSzwimP2aa0yvkGb76PicfIMuNPyR7V5zCcuVDw+HplEvWX4S/LCTkCUHdYsFez9eS87qRDtwLDF9i1behYt3zATiTVtEp+eyLN0aygFHwBgBI8sRMnWlUtiONb311OXCO2K3Vf4dFfpBsKSXOyT/yGjK64d4P4xkZyZjapaRI7SebMNY1xInzYhxERDHfvhZAQ5KAA9UomKY5p0cSCLNKUDB5RgwcEim9sfw25sQuILZ0StSQ+gOzSY1jfkrsCiYbFsu+njumVM29SNV1Xfk89obgO8JPboOZb33Z2eLhXtGblOZb1CMNs7HkC/G4DKVcY4W/YM3FVqzAnPxoOm5IQbIZ11BOHb1fKT0yJwBDyIJ1I1mb0TkX3gAoKEU7RwtaazmisMQS6lHd9Kk6s5GqrRPV5UMEYVUohbhgTZvnE0Q5qr0VuMEepTDxvLjMAdNhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

VM_SPARSE areas are created with get_vm_area() and filled in by the
caller via vm_area_map_pages(), so the caller need to allocate the pages,
keep the struct page array and free everything by itself.

Add vm_area_grow_pages() and vm_area_shrink_pages() for VM_SPARSE |
VM_ALLOC areas. Pages come from the page allocator and are tracked in
area->pages, so the area is released with a single vfree(). The backed
pages always start at the beginning of the area: growing maps
[nr_pages, end) and shrinking unmaps and frees [end, nr_pages). Callers
serialize the two helpers.

nr_pages keeps its existing meaning of "number of backed pages", as
with vrealloc() and vread_iter(), and is updated under the vmap node's
busy.lock so /proc/vmallocinfo never sees a page that is already gone.
Only areas populated through vm_area_map_pages() stay a memory hole.
vm_area_map_pages() now rejects VM_ALLOC areas, because vfree() owns
their pages, to avoid double frees; free_vm_area() warns for the same
combination but not for plain VM_ALLOC areas.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/vmalloc.h |   2 +
 mm/vmalloc.c            | 149 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 147 insertions(+), 4 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 034a693777ca..9f40edcddfa8 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -296,6 +296,8 @@ int vm_area_map_pages(struct vm_struct *area, unsigned long start,
 		      unsigned long end, struct page **pages);
 void vm_area_unmap_pages(struct vm_struct *area, unsigned long start,
 			 unsigned long end);
+int vm_area_grow_pages(struct vm_struct *area, unsigned long end, gfp_t gfp);
+void vm_area_shrink_pages(struct vm_struct *area, unsigned long end);
 void vunmap_range(unsigned long addr, unsigned long end);
 
 static inline void set_vm_flush_reset_perms(void *addr)
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 320e981188c9..0fe2f1c39b96 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -788,6 +788,8 @@ static int check_sparse_vm_area(struct vm_struct *area, unsigned long start,
 		return -EINVAL;
 	if (WARN_ON_ONCE(!(area->flags & VM_SPARSE)))
 		return -EINVAL;
+	if (WARN_ON_ONCE(area->flags & VM_ALLOC))
+		return -EINVAL;
 	if ((end - start) >> PAGE_SHIFT > totalram_pages())
 		return -E2BIG;
 	if (start < (unsigned long)area->addr ||
@@ -4174,6 +4176,135 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	return NULL;
 }
 
+/**
+ * vm_area_grow_pages - back more of a sparse area with pages
+ * @area: area created with %VM_SPARSE | %VM_ALLOC
+ * @end: end of the range to back, %PAGE_SIZE aligned
+ * @gfp: gfp flags for the page allocation
+ *
+ * Allocate and map pages for [@area->nr_pages << PAGE_SHIFT, @end).  The
+ * pages are zeroed when %__GFP_ZERO is set.  The backed range always forms
+ * a prefix of the area, and growing to a range that is already backed is a
+ * no-op.  On failure nothing is mapped and @area->nr_pages is unchanged.
+ *
+ * The area must be released with vfree(@area->addr).  Callers must
+ * serialize calls to this function.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int vm_area_grow_pages(struct vm_struct *area, unsigned long end, gfp_t gfp)
+{
+	unsigned long start = (unsigned long)area->nr_pages << PAGE_SHIFT;
+	unsigned long addr = (unsigned long)area->addr;
+	unsigned long nr_pages, nr_allocated;
+	gfp_t nested_gfp = (gfp & GFP_RECLAIM_MASK) | __GFP_ZERO;
+	struct vmap_node *vn;
+	unsigned int flags;
+	int ret;
+
+	might_sleep();
+
+	if (WARN_ON_ONCE(!(area->flags & VM_ALLOC) ||
+			 !(area->flags & VM_SPARSE)))
+		return -EINVAL;
+	if (WARN_ON_ONCE(!IS_ALIGNED(end, PAGE_SIZE)))
+		return -EINVAL;
+	if (WARN_ON_ONCE(end > get_vm_area_size(area)))
+		return -EINVAL;
+	if (end <= start)
+		return 0;
+	if ((end - start) >> PAGE_SHIFT > totalram_pages())
+		return -E2BIG;
+
+	if (!area->pages) {
+		unsigned long max_pages = get_vm_area_size(area) >> PAGE_SHIFT;
+
+		area->pages = kvmalloc_array(max_pages, sizeof(*area->pages),
+					     nested_gfp);
+		if (!area->pages)
+			return -ENOMEM;
+	}
+
+	if (!(gfp & (GFP_DMA | GFP_DMA32)))
+		gfp |= __GFP_HIGHMEM;
+
+	nr_pages = (end - start) >> PAGE_SHIFT;
+	nr_allocated = vm_area_alloc_pages(vmalloc_gfp_adjust(gfp, 0),
+					   NUMA_NO_NODE, 0, nr_pages,
+					   area->pages + (start >> PAGE_SHIFT));
+	if (nr_allocated != nr_pages) {
+		vm_area_free_pages(area, start >> PAGE_SHIFT,
+				   (start >> PAGE_SHIFT) + nr_allocated);
+		return -ENOMEM;
+	}
+
+	flags = memalloc_apply_gfp_scope(gfp);
+	ret = __vmap_pages_range(addr + start, addr + end, PAGE_KERNEL,
+				 area->pages + (start >> PAGE_SHIFT),
+				 PAGE_SHIFT, nested_gfp);
+	memalloc_restore_scope(flags);
+	if (ret)
+		goto free_pages;
+
+	kasan_unpoison_vmalloc((void *)(addr + start), end - start,
+			       KASAN_VMALLOC_PROT_NORMAL |
+			       KASAN_VMALLOC_KEEP_TAG);
+
+	/*
+	 * Publish under busy.lock, like clear_vm_uninitialized_flag():
+	 * show_busy_info() reads nr_pages and pages[] under that lock.
+	 */
+	vn = addr_to_node(addr);
+	spin_lock(&vn->busy.lock);
+	WRITE_ONCE(area->nr_pages, end >> PAGE_SHIFT);
+	spin_unlock(&vn->busy.lock);
+	return 0;
+
+free_pages:
+	vunmap_range(addr + start, addr + end);
+	vm_area_free_pages(area, start >> PAGE_SHIFT, end >> PAGE_SHIFT);
+	return -ENOMEM;
+}
+
+/**
+ * vm_area_shrink_pages - release the pages backing the end of a sparse area
+ * @area: area created with %VM_SPARSE | %VM_ALLOC
+ * @end: new end of the backed range, %PAGE_SIZE aligned
+ *
+ * Unmap and free pages for [@end, @area->nr_pages << PAGE_SHIFT).  The
+ * released range can be backed again with vm_area_grow_pages().  Callers
+ * must serialize calls to this function.
+ */
+void vm_area_shrink_pages(struct vm_struct *area, unsigned long end)
+{
+	unsigned long start = (unsigned long)area->nr_pages << PAGE_SHIFT;
+	unsigned long addr = (unsigned long)area->addr;
+	struct vmap_node *vn;
+
+	might_sleep();
+
+	if (WARN_ON_ONCE(!(area->flags & VM_ALLOC) ||
+			 !(area->flags & VM_SPARSE)))
+		return;
+	if (WARN_ON_ONCE(!IS_ALIGNED(end, PAGE_SIZE)))
+		return;
+	if (end >= start)
+		return;
+
+	/*
+	 * Lower nr_pages under busy.lock before the pages go away: readers
+	 * walk pages[] up to nr_pages under that lock.
+	 */
+	vn = addr_to_node(addr);
+	spin_lock(&vn->busy.lock);
+	WRITE_ONCE(area->nr_pages, end >> PAGE_SHIFT);
+	spin_unlock(&vn->busy.lock);
+
+	kasan_poison_vmalloc((void *)(addr + end), start - end);
+	vunmap_range(addr + end, addr + start);
+	vm_area_free_pages(area, end >> PAGE_SHIFT, start >> PAGE_SHIFT);
+}
+
 /*
  * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
  * This gfp lists all flags currently passed through vmalloc. Currently,
@@ -4983,12 +5114,18 @@ long vread_iter(struct iov_iter *iter, const char *addr, size_t count)
 		if (n > remains)
 			n = remains;
 
-		if (flags & VMAP_RAM)
+		if (flags & VMAP_RAM) {
 			copied = vmap_ram_vread_iter(iter, addr, n, flags);
-		else if (!(vm && (vm->flags & (VM_IOREMAP | VM_SPARSE))))
-			copied = aligned_vread_iter(iter, addr, n);
-		else /* IOREMAP | SPARSE area is treated as memory hole */
+		} else if (vm && (vm->flags & VM_IOREMAP)) {
+			/* Not backed by struct pages. */
+			copied = zero_iter(iter, n);
+		} else if (vm && (vm->flags & VM_SPARSE) &&
+			   !(vm->flags & VM_ALLOC)) {
+			/* Populated by the caller; treat as a memory hole. */
 			copied = zero_iter(iter, n);
+		} else {
+			copied = aligned_vread_iter(iter, addr, n);
+		}
 
 		addr += copied;
 		remains -= copied;
@@ -5104,6 +5241,10 @@ EXPORT_SYMBOL(remap_vmalloc_range);
 void free_vm_area(struct vm_struct *area)
 {
 	struct vm_struct *ret;
+
+	/* VM_SPARSE | VM_ALLOC areas own their pages and need vfree(). */
+	WARN_ON_ONCE((area->flags & (VM_ALLOC | VM_SPARSE)) ==
+		     (VM_ALLOC | VM_SPARSE));
 	ret = remove_vm_area(area->addr);
 	BUG_ON(ret != area);
 	kfree(area);
-- 
2.54.0


