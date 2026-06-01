Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FC1ECD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 18:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F5CF6B04A6; Mon,  1 Jun 2026 14:37:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7DB6B04A7; Mon,  1 Jun 2026 14:37:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFF136B04A8; Mon,  1 Jun 2026 14:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DECFC6B04A6
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:37:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 958C71615BF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 18:37:32 +0000 (UTC)
X-FDA: 84832201944.25.9128943
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 09E8A1A0005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 18:37:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AeGFnrrs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780339051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=453LPwlZ8/0XDh2NTel4qFyIHs7frDqHpyzC5sHiGyg=;
	b=NusMwwj9AyxMJUWivUryEafkV0Asnbqysky5Rf0eY3MdOrfAX3gSQilQBHLgOnRtG/OZpU
	OIS3cATVuSFfabAUer/9KQJYD+YqQYNgsKJKcuPDAYtX+tcy43br2Is+SjDeLVqcUcTHps
	MBD5bL1hZXwdeb9fieyyIU8NSFIQfxk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AeGFnrrs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780339051;
	b=KNJ2xdP4QFQNkM248O2bpi/yFp/UmKj5YxYNaFF/2qNmGvL0qni3TncxnWm+68PlHa0lG6
	erVXG7YZH2OP0CcO/2l666B+YFRNqOcRgZ+IaP7tIJxBzsryjU5G19TV6KxW7N7PXz4aIO
	EOEEyzBEF3e4deyv0JZAe5oLBUGJzck=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 77D34600AA;
	Mon,  1 Jun 2026 18:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F091C1F00893;
	Mon,  1 Jun 2026 18:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780339050;
	bh=453LPwlZ8/0XDh2NTel4qFyIHs7frDqHpyzC5sHiGyg=;
	h=From:To:Cc:Subject:Date;
	b=AeGFnrrsK0E5ty6ct0u3gW1VReUmbexgBW8yoXoczN3DxBHadkBk6Lt6cLL27yoji
	 TD1au2oJ5rgsPB625hifuG8gVWIBPcbCDrzp1n8n35hCsjzKOaTyqRT0ItaNZwMlAY
	 f/73X4KLIu4ok1+/RZGsXdm2QoT0qZ1jwuYRLF3o+3Wpdb+EV34DBTnALMJwS+qNyI
	 cTCahpNQQz9nE6Yvd6nY5uBKHMvFkDjtmLAdrYfLYnJUSiI+40RGegaBz8hCYfPYl7
	 u8DuXmy6UZwlxyhDHuYg+BXR8YRybd3v9alFTqrTU68jWbLzX9R+PwvzjFdY7RZCD2
	 CzjYu29f8VVLA==
From: Tejun Heo <tj@kernel.org>
To: void@manifault.com,
	arighi@nvidia.com,
	changwoo@igalia.com,
	ast@kernel.org,
	andrii@kernel.org,
	daniel@iogearbox.net,
	martin.lau@linux.dev,
	memxor@gmail.com
Cc: peterz@infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	rppt@kernel.org,
	emil@etsalapatis.com,
	sched-ext@lists.linux.dev,
	bpf@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH bpf-next] bpf: Replace scratch PTE atomically when allocating arena pages
Date: Mon,  1 Jun 2026 08:37:28 -1000
Message-ID: <20260601183728.1800490-1-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 09E8A1A0005
X-Stat-Signature: iwtmjiqfgppstfkr7ur6h4z6qugmoogu
X-Rspam-User: 
X-HE-Tag: 1780339050-855202
X-HE-Meta: U2FsdGVkX19sn/BQVd+85eb4tRhgRmgZX3GBDDfwHSkBOlgsq2VLWH0YayAB5q76FAwGdQJ7dl8DafPG97Q9EMwZrpCvAvUBVVNU23Usrnrt0x4aOg8t+bx7j/LJlQKjpHVxKBGIPu68Fvq63kkeFIHfi4Xh61ib+9qZSpMNmAYVBPUfPUJERoGtj9GyVoX82BmOFHoff+/UBOfGAmiBeFJVCpbWW1xsdy4JqSk1l1jto64aQ4r4HLy8hK/6GTShUpkuZiyoJXwfESiAHVDQ78/ftPDZsg+2hbye8vQChLuddOuKNzsD2IaXs7b0pKSN3AYFpbZqJGLCB33ul/ttPw7WFJrlePyd3/UDjtp+afJRcasUwfLFC5SwM9kDfPSSRA0v1d1rzuJxSQeV2BWZLgXonIsHwgdyglluXjG2xsOW3Ii2ECX5iMPafkDxZ2+SC3DnlL3aGvSQ+0VT5ezk0p1qJo59TfgRDnHd1pa6NE9U9TpOGdYbL34HagDKiyjWuAYoKxdzPFlqN3/SPls7CwQqGBmUJBgY2uGARalCqHLANN2iHrlYU7fbQ3VTBxltKBcR2fy5D4xa//qKD7TqH1QhEWQPllX/u/YJqOztirTl+S6N+4+HtS2DWFG06CIU4PP47Cr3jLNxfZsRwxBabblL/IZz7c74EFG8fc5RS9Ne68wYESTP2CMXMJl/E07R6fB5ACUpk5QcwJcdPaf4RO6CSYgIkGX82azZUie6hHv86BlqslmXXlgO22aq0bge935YrRB6Mxgz12uA9whp4V45VtbL1sAHi7hRxo8gqR0vnbwUXvVmDR12X7bf4PzSYMQkP6sulyYp4vUB7YjqvV4xrc/I1+3bluY6uoj4hNR3J9MP3v6VXNsTlQp5xxNnH4Eu37zJXzTvGfx6ziLBz/0+FLImKVrn+LcvVSJ4NhJCprfeg45usNJFPemgnUVAekdMYbAZomUjWzpxVjh
 F1WG4qcf
 vWv52PvsrkYqgtEbBwW5JJXouOaSqhAsNs0U96lByQziJVuNYUabNEZ9L7Ql2s3Q+fUY6L6qKY+AVzi/wMRgcBSi2gARokQFU/GjLbrXEySHdF42BL2FQkY/rPvEtRQ3BVBrdjGaK8E3xKQri8H5zWy0Y2vZ9X+f+CJMKfU5t3aChKIvKmiRnqyZb+Bx81hsYb35KjptkjguCpPnM07YCwqBiw4YwzdFS7NQHlk49issgSYM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_range_set_cb() maps the pages for a new arena allocation and returned
-EBUSY when the target PTE was already populated. Kernel-fault recovery
leaves the per-arena scratch page in unallocated arena PTEs, so a later
bpf_arena_alloc_pages() over such a page hits that -EBUSY, and every
subsequent allocation of it fails the same way. Allocation must install the
real page over scratch instead.

Overwriting the scratch PTE in place is a valid->valid change, which arm64
forbids without break-before-make. Route through an invalid entry instead:
ptep_try_set() fills only a none slot, so the PTE goes scratch->none->page.
On finding scratch, clear it and flush_tlb_before_set() before retrying. The
new flush_tlb_before_set() is a no-op except on arches like arm64 that need
the break-before-make TLB invalidate. The loop also copes with a concurrent
fault re-scratching the slot.

Arches without ptep_try_set() never install the scratch page, so keep the
must-be-empty check and set_pte_at() for them.

Fixes: dc11a4dba246 ("bpf: Recover arena kernel faults with scratch page")
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
---

 arch/arm64/include/asm/pgtable.h |   11 +++++++++++
 include/linux/pgtable.h          |   18 ++++++++++++++++++
 kernel/bpf/arena.c               |   38 +++++++++++++++++++++++++++++++++-----
 3 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 984f050..3ce0f2a 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1842,6 +1842,17 @@ static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
 }
 #define ptep_try_set ptep_try_set
 
+/*
+ * arm64 mandates break-before-make: a cleared kernel PTE must have its TLB
+ * invalidated before a different page is installed in its place. The broadcast
+ * TLBI is an instruction, not an IPI, so this is safe with interrupts disabled.
+ */
+static inline void flush_tlb_before_set(unsigned long addr)
+{
+	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+}
+#define flush_tlb_before_set flush_tlb_before_set
+
 #define test_and_clear_young_ptes test_and_clear_young_ptes
 static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, unsigned int nr)
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index b5739bb..4c6c408 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1061,6 +1061,24 @@ static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
 }
 #endif
 
+#ifndef flush_tlb_before_set
+/**
+ * flush_tlb_before_set - invalidate a kernel PTE's TLB before re-setting it
+ * @addr: kernel virtual address whose PTE was just cleared
+ *
+ * Some architectures (e.g. arm64) do not allow a live page-table entry to be
+ * repointed at a different page in one step. The old entry must first be made
+ * invalid and its translation flushed from every TLB, and only then may the new
+ * entry be written.
+ *
+ * This is only for the lockless atomic kernel-PTE installers (ptep_try_set()).
+ * It must be callable with interrupts disabled.
+ */
+static inline void flush_tlb_before_set(unsigned long addr)
+{
+}
+#endif
+
 #ifndef wrprotect_ptes
 /**
  * wrprotect_ptes - Write-protect PTEs that map consecutive pages of the same
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 1727503..b6ac5a9 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -142,6 +142,7 @@ static long compute_pgoff(struct bpf_arena *arena, long uaddr)
 
 struct apply_range_data {
 	struct page **pages;
+	struct page *scratch_page;
 	int i;
 };
 
@@ -154,19 +155,44 @@ static int apply_range_set_cb(pte_t *pte, unsigned long addr, void *data)
 {
 	struct apply_range_data *d = data;
 	struct page *page;
+	pte_t pteval;
 
 	if (!data)
 		return 0;
-	/* sanity check */
-	if (unlikely(!pte_none(ptep_get(pte))))
-		return -EBUSY;
 
 	page = d->pages[d->i];
 	/* paranoia, similar to vmap_pages_pte_range() */
 	if (WARN_ON_ONCE(!pfn_valid(page_to_pfn(page))))
 		return -EINVAL;
 
-	set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
+	pteval = mk_pte(page, PAGE_KERNEL);
+#ifdef ptep_try_set
+	/*
+	 * Kernel-fault recovery may have installed the scratch page here, and
+	 * some architectures (arm64) prohibit valid->valid PTE transitions.
+	 * Install atomically into a none slot. If scratch is present, clear it
+	 * and flush_tlb_before_set() (break-before-make) before retrying.
+	 */
+	while (!ptep_try_set(pte, pteval)) {
+		pte_t old = ptep_get(pte);
+
+		if (pte_none(old))
+			continue;
+		if (WARN_ON_ONCE(pte_page(old) != d->scratch_page))
+			return -EBUSY;
+		ptep_get_and_clear(&init_mm, addr, pte);
+		flush_tlb_before_set(addr);
+	}
+#else
+	/*
+	 * Without ptep_try_set() there is no atomic installer, but such arches
+	 * also do not wire up bpf_arena_handle_page_fault(), so no scratch page
+	 * is ever installed and the slot is always none here.
+	 */
+	if (unlikely(!pte_none(ptep_get(pte))))
+		return -EBUSY;
+	set_pte_at(&init_mm, addr, pte, pteval);
+#endif
 	d->i++;
 	return 0;
 }
@@ -475,7 +501,8 @@ static vm_fault_t arena_vm_fault(struct vm_fault *vmf)
 	if (ret)
 		goto out_sigsegv_memcg;
 
-	struct apply_range_data data = { .pages = &page, .i = 0 };
+	struct apply_range_data data = { .pages = &page, .i = 0,
+					 .scratch_page = arena->scratch_page };
 	/* Account into memcg of the process that created bpf_arena */
 	ret = bpf_map_alloc_pages(map, NUMA_NO_NODE, 1, &page);
 	if (ret) {
@@ -665,6 +692,7 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
 		return 0;
 	}
 	data.pages = pages;
+	data.scratch_page = arena->scratch_page;
 
 	if (raw_res_spin_lock_irqsave(&arena->spinlock, flags))
 		goto out_free_pages;

