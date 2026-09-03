Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52EBFC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12BA6B0095; Thu,  3 Sep 2026 11:50:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC3D16B0096; Thu,  3 Sep 2026 11:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00F16B0098; Thu,  3 Sep 2026 11:50:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 726906B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:50:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD59EC05D7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:50:19 +0000 (UTC)
X-FDA: 85172887758.05.D87043C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 174E7A0009
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:50:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OYJ+Zl3t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788450618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0X9ZLAQ4mUEchhwpqleI41xzP5aRuvK6f6Sh6Yxzi4=;
	b=44vj6HmHqxtRtttVM66c9qGhhOTEsFx34aOFY0BBBZOuBZoxrE1FHU4e85gBIJf5dsWSUt
	OxlD5sP/K86XRqB4mqoEFuaoMLKiFtMXj8wi+Fac+skPSQcgXVL/lz2BRcPQCAoWhOtn1c
	+os8Rkb3YYhWsLA2yr39TyI+5isCsA0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OYJ+Zl3t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788450618;
	b=SKyME/2ZkkkCJC/1QrR+U7Ui5n0kd+Ghx526ZXS4rfRSo0qOMZXiiAhzkm0/gBizHaXosL
	X5SEmxrAhAH6rqqPLbPNQyHdpDQJgQp2csQUkshfVPB/wHd94V73vV/uHq7/DRvI8PxyWN
	KJz+pF+JS4n3kQac1amBdGHmm3ZCdB0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69A0C43C54;
	Thu,  3 Sep 2026 15:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4180E1F00A3F;
	Thu,  3 Sep 2026 15:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788450617;
	bh=Z0X9ZLAQ4mUEchhwpqleI41xzP5aRuvK6f6Sh6Yxzi4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OYJ+Zl3tMLn1MD1z6fiXKp4+i9tHpSYBMlJNN0tpYuVSfwQKTR5zVkw45bX7Q4PTw
	 o6NmhmyOQC1T8A7OxYMHgBjsFPek/w5rxSk5f3hxPJ7wUkgyINX5RUuG5hZErfLTDK
	 d8FnpW/qGCiLySjLSSd7a5lqoeN4/j150u5+rP8OLeGhNApjIC16fJT869KuufeTIf
	 Xz+fwfT6vjd7WFXrTSmMhfp1+3YJtwirO/TcznnlXg4cFTacvgDB1ywtBQ022spaHK
	 A5TX3vACapU+ds4GgORfT0T1iv6dfsmsWcn7E41bTU0lD7+wbcf2SY42YlJ4vMlOeH
	 geH2yghWdDQmg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 03 Sep 2026 18:50:00 +0300
Subject: [PATCH 3/5] mm/execmem: make sure ROX cache always contains
 multiples of PMD_SIZE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-execmem-rox-cache-pmd-v1-v1-3-11beb2a3d249@kernel.org>
References: <20260903-execmem-rox-cache-pmd-v1-v1-0-11beb2a3d249@kernel.org>
In-Reply-To: <20260903-execmem-rox-cache-pmd-v1-v1-0-11beb2a3d249@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Tissoires <bentiss@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Stat-Signature: 51qfosg9657emwiaotpbmwrthadhidip
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 174E7A0009
X-Rspam-User: 
X-HE-Tag: 1788450617-997198
X-HE-Meta: U2FsdGVkX18N03crMXhL5Fg2EXjUisneufH5Jougle37E8HeNmU59yT5obT8XqalIu1J4ut2NIWhcL0AovaqCeZbUTM0dCM++N6RDYZvMSSd6xzkPZZkPscrfowxXO+3c1b4PeBs0bvWbql9qxgqtzvTEfjpcMJ6CRLN+8yHlHubkPJNTuXwc0dz52UUGfcHNwRNnaykF9N0gSDBrGc/EaFnNKj7aTGxejbG0OO2HIEdZc4ik+b3MwgVPTMjbs4xZT1lJIlPwtHi6ElqMLm2MKrMJmB0GVUJ9ydBaD+r9rkDhudBKcurlG6d2gnJ2HS2X3BZdn793HbRj3+6uEPO7l8zrZSAmMmmjlU6KfAtsUtHxMniWKQ3LouOI3dEDjf2imLNaWpUFcT7FS7TvgUfFa0uzjc11PVBA5JAMD0+nlkA8YcK0P4F4hFgfLLx52G+CYW9OAkzTdibpBYp/eXT2lfh8ZGZO0efi8KbxuBfGczpd0SmhDfJW2dWYhGmtEq17Unf7K1B0Z+FevY4is53Udl5LonyabY0QSO2j0+bDosDSkfY+8bAVKsK5Q6O8HiIs6Vn+msKRBh3W4QIrw+nCkq8FccCWBuRhtz3m463drOex1uw63t1fXodpDa1/0shm1FhHQ3bd9gaxZxXHYF5PCZhT32pOR6CcSyXOgblGa6u22T1h6qVpgWf4E2qF9shwbdodPSCKh/rwXJ6ijpQ3Db+jZAmzAapOMyZksPxx17P1vgvzBBpYRlicWW/wNORx2ftTWmWv88ikxqEPRDiC3Y+DedwzSEvwOhRjEGsTzS8B0upxmofnWCe8pjf0W38+Gb9RFtP9lPQnAGHe8NVFR9KF+cHEwPsJaRkfCJZktR8UwNRb/encvKlrni61aNGrJggy4P3Kq3Jtv0est0uzlbtI0F6/kZ4ykMBNwWj+vbIdHhratVt3nDXOnvdAKvDyvY9C7E4Ib73Jzw7UNp
 TCGCHjv0
 zXWu9ZL8MSgpoahHXFtR/Pa2CgFrvZxn5vhGhPxwfAxJg/rE06Uhag7XuLp2o8zIKRMTN67tyR+FwFw5QyoPR9i/FYUTrfudWtEsCBMLODtSke/wQ/udPkoLzxDdyQcxihaH/MyHNWRoDgtGszAUJpbojLav0MvnIwt/+lLb++VZMHbjxxgDBTYgukxhFtDcNxHRFCf7cSYIjovKti38cUQByeicOiy2+GWBtOUb1b1sNc7b+Xqsyzak0KzXg7kyiMlxwrtc8XdB/tk1gzgqdnTmSiRP1yCyrCR7U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ROX cache relies on its chunks being PMD mapped. For a PMD mapped
chunk, set_memory_rox() updates the direct map alias one PMD at a time
and the large mappings there survive.

When execmem refills the cache, it rounds up the requested allocation size
to PMD_SIZE and tries to allocate that with vmalloc(VM_ALLOW_HUGE_VMAP). If
that allocation fails, execmem falls back to vmalloc() of the original
size.

There are two issues with this approach:
* If huge pages are not available, __vmalloc_node_range() silently falls
  back to base pages. The area execmem gets is virtually contiguous, but it
  is backed by 512 scattered base pages.

  Permission updates on such areas split large mappings in the direct map
  that contain those base pages, up to 512 PMD splits in the worst case.

* execmem's own fallback adds a small base page mapped area to the cache.
  This adds the overhead of cache management to these allocations with no
  benefit of reducing fragmentation either in the vmalloc/modules address
  space or in the direct map.

  Worse, these areas are never freed from the cache, because
  execmem_cache_clean() releases only chunks that are a multiple of
  PMD_SIZE and aligned to PMD_SIZE, exactly to minimize the number of base
  page mappings.

Add VM_REQUIRE_HUGE_VMAP option to vmalloc that fails if the allocation
of huge pages fails or if such an allocation is not possible because huge
page allocations in vmalloc were disabled or the architecture does not
support them.

Use this option when populating the ROX cache. If
vmalloc(VM_REQUIRE_HUGE_VMAP) fails or vmalloc of huge pages is
unavailable, handle the memory allocation outside the ROX cache with plain
vmalloc().

Since the fallback allocation has to return ROX memory, add an
execmem_alloc_rox() helper and use it for both populating the ROX cache and
dealing with a fallback allocation in a ROX execmem_range.

With that, the cache only ever contains PMD aligned chunks sized as a
multiple of PMD_SIZE, and the PMD checks in execmem_cache_clean() become a
VM_WARN_ON_ONCE() to ensure that the PMD mapping invariant does not change.

Assisted-by: copilot:claude-opus-5
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/vmalloc.h |  1 +
 mm/execmem.c            | 76 ++++++++++++++++++++++++++++++-------------------
 mm/vmalloc.c            | 15 +++++++++-
 3 files changed, 62 insertions(+), 30 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index aed121d729b01..6e555e31e6225 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -38,6 +38,7 @@ struct iov_iter;		/* in uio.h */
 #define VM_DEFER_KMEMLEAK	0
 #endif
 #define VM_SPARSE		0x00001000	/* sparse vm_area. not all pages are present. */
+#define VM_REQUIRE_HUGE_VMAP	0x00002000	/* huge page mapping or nothing */
 
 /* bits [20..32] reserved for arch specific ioremap internals */
 
diff --git a/mm/execmem.c b/mm/execmem.c
index 00dd6324cae01..77653b7f163dc 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -51,7 +51,8 @@ static void *execmem_vmalloc(struct execmem_range *range, size_t size,
 	}
 
 	if (!p) {
-		pr_warn_ratelimited("unable to allocate memory\n");
+		if (!(vm_flags & VM_REQUIRE_HUGE_VMAP))
+			pr_warn_ratelimited("unable to allocate memory\n");
 		return NULL;
 	}
 
@@ -146,9 +147,10 @@ static void execmem_cache_clean(struct work_struct *work)
 		struct vm_struct *vm = find_vm_area(area);
 		size_t size = mas_range_len(&mas);
 
-		if (vm && get_vm_area_size(vm) == size &&
-		    IS_ALIGNED(size, PMD_SIZE) &&
-		    IS_ALIGNED(mas.index, PMD_SIZE)) {
+		if (vm && get_vm_area_size(vm) == size) {
+			VM_WARN_ON_ONCE(!IS_ALIGNED(mas.index, PMD_SIZE) ||
+					!IS_ALIGNED(size, PMD_SIZE));
+
 			/*
 			 * Preallocate to ensure mas_store does not fail
 			 * If there is no memory for the tree update, bail out,
@@ -264,38 +266,41 @@ static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
 	return execmem_cache_alloc_locked(range, size);
 }
 
-static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t size)
+static void *execmem_vmalloc_rox(struct execmem_range *range, size_t size,
+				 unsigned long vm_flags)
 {
-	unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
-	struct mutex *mutex = &execmem_cache.mutex;
-	struct vm_struct *vm;
-	size_t alloc_size;
-	int err = -ENOMEM;
-	void *p;
-
-	alloc_size = round_up(size, PMD_SIZE);
-	p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
-	if (!p) {
-		alloc_size = size;
-		p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
-	}
+	void *p = execmem_vmalloc(range, size, PAGE_KERNEL, vm_flags);
+	int err;
 
 	if (!p)
 		return NULL;
 
-	vm = find_vm_area(p);
-	if (!vm)
-		goto err_free_mem;
-
 	/* fill memory with instructions that will trap */
-	execmem_fill_trapping_insns(p, alloc_size);
-
+	execmem_fill_trapping_insns(p, size);
 	set_vm_flush_reset_perms(p);
-
-	err = set_memory_rox((unsigned long)p, vm->nr_pages);
+	err = set_memory_rox((unsigned long)p, size >> PAGE_SHIFT);
 	if (err)
 		goto err_free_mem;
 
+	return p;
+
+err_free_mem:
+	vfree(p);
+	return NULL;
+}
+
+static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t size)
+{
+	unsigned long vm_flags = VM_REQUIRE_HUGE_VMAP;
+	size_t alloc_size = round_up(size, PMD_SIZE);
+	struct mutex *mutex = &execmem_cache.mutex;
+	int err;
+	void *p;
+
+	p = execmem_vmalloc_rox(range, alloc_size, vm_flags);
+	if (!p)
+		return NULL;
+
 	/*
 	 * New memory blocks must be allocated and added to the cache
 	 * as an atomic operation, otherwise they may be consumed
@@ -317,6 +322,11 @@ static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t si
 	return NULL;
 }
 
+static void *execmem_alloc_rox(struct execmem_range *range, size_t size)
+{
+	return execmem_vmalloc_rox(range, size, 0);
+}
+
 static void *execmem_cache_alloc(struct execmem_range *range, size_t size)
 {
 	void *p;
@@ -444,6 +454,11 @@ static void *execmem_cache_alloc(struct execmem_range *range, size_t size)
 	return NULL;
 }
 
+static void *execmem_alloc_rox(struct execmem_range *range, size_t size)
+{
+	return NULL;
+}
+
 static bool execmem_cache_free(void *ptr)
 {
 	return false;
@@ -453,17 +468,20 @@ static bool execmem_cache_free(void *ptr)
 void *execmem_alloc(enum execmem_type type, size_t size)
 {
 	struct execmem_range *range = &execmem_info->ranges[type];
-	bool use_cache = range->flags & EXECMEM_ROX_CACHE;
+	bool use_rox_cache = range->flags & EXECMEM_ROX_CACHE;
 	unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
 	pgprot_t pgprot = range->pgprot;
 	void *p = NULL;
 
 	size = PAGE_ALIGN(size);
 
-	if (use_cache)
+	if (use_rox_cache) {
 		p = execmem_cache_alloc(range, size);
-	else
+		if (!p)
+			p = execmem_alloc_rox(range, size);
+	} else {
 		p = execmem_vmalloc(range, size, pgprot, vm_flags);
+	}
 
 	return kasan_reset_tag(p);
 }
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6ed6c160abed7..4df5c25786c6d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4027,6 +4027,12 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
  * %__GFP_SKIP_KASAN can be used to skip unpoisoning of mapped pages
  * (when prot=%PAGE_KERNEL).
  *
+ * %VM_ALLOW_HUGE_VMAP allocates huge pages when possible and falls back to
+ * base pages if huge page allocation fails.
+ *
+ * %VM_REQUIRE_HUGE_VMAP implies %VM_ALLOW_HUGE_VMAP and fails instead of
+ * silently falling back to base pages.
+ *
  * Can not be called from interrupt nor NMI contexts.
  * Return: the address of the area or %NULL on failure
  */
@@ -4052,6 +4058,10 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		return NULL;
 	}
 
+	/* VM_REQUIRE_HUGE_VMAP implies VM_ALLOW_HUGE_VMAP */
+	if (vm_flags & VM_REQUIRE_HUGE_VMAP)
+		vm_flags |= VM_ALLOW_HUGE_VMAP;
+
 	if (vmap_allow_huge && (vm_flags & VM_ALLOW_HUGE_VMAP)) {
 		/*
 		 * Try huge pages. Only try for PAGE_KERNEL allocations,
@@ -4068,6 +4078,9 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		align = max(original_align, 1UL << shift);
 	}
 
+	if ((vm_flags & VM_REQUIRE_HUGE_VMAP) && shift == PAGE_SHIFT)
+		return NULL;
+
 again:
 	area = __get_vm_area_node(size, align, shift, VM_ALLOC |
 				  VM_UNINITIALIZED | vm_flags, start, end, node,
@@ -4142,7 +4155,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 	return area->addr;
 
 fail:
-	if (shift > PAGE_SHIFT) {
+	if (shift > PAGE_SHIFT && !(vm_flags & VM_REQUIRE_HUGE_VMAP)) {
 		shift = PAGE_SHIFT;
 		align = original_align;
 		goto again;

-- 
2.53.0


