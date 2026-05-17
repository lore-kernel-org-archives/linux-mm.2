Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CEB5CD4F3C
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 21:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943796B008C; Sun, 17 May 2026 17:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5816B0092; Sun, 17 May 2026 17:12:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A576B0093; Sun, 17 May 2026 17:12:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 693676B008C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:12:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C9741C0551
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:38 +0000 (UTC)
X-FDA: 84778160796.29.B3DEE77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 86A8240002
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o4ysWDWo;
	spf=pass (imf27.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779052356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5n7qh9GBI/XIQVJvdaz+YA12H/HVsAPZmN6Ix1XLfA=;
	b=hqCyWMuFiLpL8+tfhFxl4/Vf3cFLQoXFLJLelfzweci8t+cyXIVUyHyqhzjeBHUYMmB8xA
	+TM+Kk0NdCU50tgy+zCZGr7pXRf1jOFAFQ1i9lf4mAYTM3xYXtALIrnfkXdt7aYOXTU6dc
	/VpyFR8fetUoHEqukiIA0KLYsc4S64w=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o4ysWDWo;
	spf=pass (imf27.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779052356; a=rsa-sha256;
	cv=none;
	b=qRujk9O/KcCaSM0VRYMtkBnKbPTi8wdGzFNnJrysOD01ASZkeZYaIr9F8xXiE5RCvbN6fy
	cu4g98WsMjWLFSHs6VQMPuMlbjbDQ9yoCuqBNNXwswOZ+nYbvDs8iNDXIklFCPC0S3EyVd
	Fcpy7ZDHgSWP9p7Am3c9qvBfQuUQr0s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0478445CA;
	Sun, 17 May 2026 21:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F90C2BCF6;
	Sun, 17 May 2026 21:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779052355;
	bh=1f9d3JYwFiMahH/8WGQt0poov+XDuSMt4V/gu+qK3ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4ysWDWo4uxHS5tQSac3Xmcbd6sKR2lxoBeL3jByIqBZglRJ2AG+3BtsqRWzBkCbE
	 StHDUdDII9a4B9flp1LAG8U4gSYMUJ+5ddQ5I9lHbGaVgl24nom2FXoOu4MaSf7ljF
	 qI2SacPDxoqInrwktFeDtOIExBPJIDFa5uzgJ1CoyAW1TYXDfUhA1TsO9rX8ANRtd8
	 nvp80b+k/UoK6xbpced1MvpG0/q5zvugcKXvPWA12AA1YduUZlRA2JoqXukLzVfU/t
	 GAItbmPKKIAa4V4BDWFWv8LONxhzy93/rMvB3ENgMuQH5wFdrd4e+EKcbYct+Re+Hg
	 Ra30D/hlyTKEg==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	sched-ext@lists.linux.dev,
	bpf@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/8] bpf: Recover arena kernel faults with scratch page
Date: Sun, 17 May 2026 11:12:26 -1000
Message-ID: <20260517211232.1670594-3-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260517211232.1670594-1-tj@kernel.org>
References: <20260517211232.1670594-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jpatc1mt5x7h9dpxn4whc7eq7b1njy6r
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 86A8240002
X-Rspam-User: 
X-HE-Tag: 1779052356-16709
X-HE-Meta: U2FsdGVkX18viK6EFP+Ke4a1F6mAmhACy4SUGc7O/VlOzAqnEmeTapYO0Nozv4equ0kaKAD7X6HyQEMU/ywdXdP80OApYgcx2vv8tfXv61pxn949B1NDsnxP24ibQqoy2IcbcnI4bGgEt9oY5Ik1PBAdqojoI1gLgd3dO5eHjyA7r4KuidBktMQdGLTeBasFNwj+yn1P71v7PNPkr4f8cj1tlSAmxYtRb1KWf3k0xYAQu8nqylB6eQh0318+BiIGEdiI6AEEbPKN1LAr+ZjHGGtC0eFUte6k6MGOGa1ziKnPPAAftLUdnGjKDL5d9ncRiu6j6dFTm+0m/rhWjtJz2IuQoIB5O5/T7ZQeaIpR+rhm1L2vFrifc8d4w88F/+h7UsiX/7BYJbyMK7dF5HutqxSou4zWbu5+gJrVbHDsLxXVj5wvF+jmQ4z4E48kqwvFLOWm/RYIjjHvEmCrS3+DBvIfKqBZZNvpqsxTkg4LexQqitvYGmrQXTBlmkPuyNW9q0xAeeCqOuiY3TLQeasuVN62jSGVMMEMoNL7o1TzEvJyYA6Zfc4VysZv6rnYFeJQf8vzxDbJBBcAr61YNncNq/+5j5d/biWwKdO89wnimapuUy/STPYtPBIAP2Lv3hFdOPgyn8kdyHgDkPQKWbPfLfbD7SOaFiGxiWB4XZ4171l3RUNsscdva7O5jZlowO2vMAoyX3qky9C5k/Bba14xGQCc0PDUzgdmWiGaoYvPQKXcpVbZ90r2tgLmsp++PyO0EB3FKAVwC6wp6cJ/dHH7k2fyzDICM0doOXqn+EzPZFWD/qw+8UhP0RK1j4tDG0J3aBF+vWj2iPgzU9nRN3833ujoAZvgimAa39Xbd4+uZvRNFHa40Da/qcZyG+n/7rBKVWmihaHz9dxdC6hBn4dq5kWD47taPv0LUtoa/QZS73EAqveRjbgolyDJpa3lpyBgqkzJU2BcxElSJsmPYM2
 pbtHvoDL
 5L1wRTefoqIsoD7YJ7f+caIOO76CLZPKQw7fvpevifS0FGZnPIKnw10agtW3eIzRXAFTRNQBGDmCL4sfPp4B7A3fjhdlzKezSt1IxVjEYL6y3+7ZdKNzvTi8xPNk3INsDaIX/3PpT9mHQljvo0nqHstHyZY237xSn7skGrB3PKjNJqlJ04RK0obJT0Xh9TgnJpUuXx5xIrSHmz3zXblqvBBtdQ6V3l7nCIahOSeB39Mmc0j3dQFNW5674xkDAREYMnj1j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

BPF arena usage is becoming more prevalent, but kernel <-> BPF communication
over arena memory is awkward today. Data has to be staged through a trusted
kernel pointer with extra code and copying on the BPF side. While reads
through arena pointers can use a fault-safe helper, writes don't have a good
solution; the in-line alternative would need instruction emulation or asm
fixup labels.

Enable direct kernel-side reads and writes within GUARD_SZ / 2 of any
handed-in arena pointer, without bounds checking. A per-arena scratch page
is installed by the arch fault path into empty arena kernel PTEs - x86 from
page_fault_oops() for not-present faults, arm64 from __do_kernel_fault() for
translation faults, both after the existing exception-table and KFENCE
handling. The faulting instruction retries and the access is also reported
through the program's BPF stream, preserving error reporting.

bpf_prog_find_from_stack() resolves the current BPF program (and its arena)
from the kernel stack - no new bpf_run_ctx state is added. Recovery covers
the 4 GiB arena plus the upper half-guard (GUARD_SZ / 2); the lower
half-guard is excluded because well-behaved kfuncs only access forward from
arena pointers. The kfunc-author contract - access at most GUARD_SZ / 2 past
a handed-in pointer - is documented in Documentation/bpf/kfuncs.rst.

The install is lock-free via ptep_try_install(): on race-loss the winning
installer's PTE is already valid, so the access retry succeeds. No
flush_tlb_kernel_range() afterwards - stale "not mapped" entries just cause
one extra re-fault, cheaper than a global IPI on every install.

Scratch exists only to keep the kernel from oopsing on an in-line arena
access. Its presence at a PTE means the BPF program has already
malfunctioned, and the violation is reported through the program's BPF
stream. The only requirement for behavior on a scratched PTE is that the
kernel doesn't crash; in particular, any user-side access through such a PTE
may segfault. The shared scratch page is freed once during map destruction.

BPF instruction faults continue to use the existing JIT exception-table
path; this patch changes only the kernel-text fault path. No UAPI flag is
added; the new behavior is the default.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 Documentation/bpf/kfuncs.rst |  14 +++
 arch/arm64/mm/fault.c        |  10 ++-
 arch/x86/mm/fault.c          |  12 ++-
 include/linux/bpf.h          |   1 +
 include/linux/bpf_defs.h     |  11 +++
 kernel/bpf/arena.c           | 170 +++++++++++++++++++++++++++--------
 kernel/bpf/core.c            |   5 ++
 7 files changed, 181 insertions(+), 42 deletions(-)
 create mode 100644 include/linux/bpf_defs.h

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index 75e6c078e0e7..6d497e720998 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -462,6 +462,20 @@ In order to accommodate such requirements, the verifier will enforce strict
 PTR_TO_BTF_ID type matching if two types have the exact same name, with one
 being suffixed with ``___init``.
 
+2.8 Accessing arena memory through kfunc arguments
+--------------------------------------------------
+
+A read or write at any address inside an arena does not oops the kernel.
+Unallocated arena pages are lazily backed by a scratch page and the
+access is reported through the program's BPF stream as an error. Only
+the BPF program's correctness is affected; the kernel itself remains
+intact.
+
+The arena is followed by a ``GUARD_SZ / 2`` (32 KiB) guard region that
+is also covered by this recovery. A kfunc handed an arena pointer may
+therefore access up to ``GUARD_SZ / 2`` past it without bounds-checking
+against the arena. Larger accesses must verify the range explicitly.
+
 .. _BPF_kfunc_lifecycle_expectations:
 
 3. kfunc lifecycle expectations
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 920a8b244d59..0d58d667fcd8 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -9,6 +9,7 @@
 
 #include <linux/acpi.h>
 #include <linux/bitfield.h>
+#include <linux/bpf_defs.h>
 #include <linux/extable.h>
 #include <linux/kfence.h>
 #include <linux/signal.h>
@@ -416,9 +417,12 @@ static void __do_kernel_fault(unsigned long addr, unsigned long esr,
 	} else if (addr < PAGE_SIZE) {
 		msg = "NULL pointer dereference";
 	} else {
-		if (esr_fsc_is_translation_fault(esr) &&
-		    kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
-			return;
+		if (esr_fsc_is_translation_fault(esr)) {
+			if (kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
+				return;
+			if (bpf_arena_handle_page_fault(addr, esr & ESR_ELx_WNR, regs->pc))
+				return;
+		}
 
 		msg = "paging request";
 	}
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f0e77e084482..b0f103ddbd23 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -8,6 +8,7 @@
 #include <linux/sched/task_stack.h>	/* task_stack_*(), ...		*/
 #include <linux/kdebug.h>		/* oops_begin/end, ...		*/
 #include <linux/memblock.h>		/* max_low_pfn			*/
+#include <linux/bpf_defs.h>		/* bpf_arena_handle_page_fault	*/
 #include <linux/kfence.h>		/* kfence_handle_page_fault	*/
 #include <linux/kprobes.h>		/* NOKPROBE_SYMBOL, ...		*/
 #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
@@ -688,10 +689,13 @@ page_fault_oops(struct pt_regs *regs, unsigned long error_code,
 	if (IS_ENABLED(CONFIG_EFI))
 		efi_crash_gracefully_on_page_fault(address);
 
-	/* Only not-present faults should be handled by KFENCE. */
-	if (!(error_code & X86_PF_PROT) &&
-	    kfence_handle_page_fault(address, error_code & X86_PF_WRITE, regs))
-		return;
+	/* Only not-present faults should be handled by KFENCE or BPF arena. */
+	if (!(error_code & X86_PF_PROT)) {
+		if (kfence_handle_page_fault(address, error_code & X86_PF_WRITE, regs))
+			return;
+		if (bpf_arena_handle_page_fault(address, error_code & X86_PF_WRITE, regs->ip))
+			return;
+	}
 
 oops:
 	/*
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 0136a108d083..831996c411cf 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -6,6 +6,7 @@
 
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/filter.h>
+#include <linux/bpf_defs.h>
 
 #include <crypto/sha2.h>
 #include <linux/workqueue.h>
diff --git a/include/linux/bpf_defs.h b/include/linux/bpf_defs.h
new file mode 100644
index 000000000000..d98e033b8c0b
--- /dev/null
+++ b/include/linux/bpf_defs.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Subset of bpf.h declarations, split out so files that need only these
+ * declarations can avoid bpf.h's full include cost.
+ */
+#ifndef _LINUX_BPF_DEFS_H
+#define _LINUX_BPF_DEFS_H
+
+bool bpf_arena_handle_page_fault(unsigned long addr, bool is_write, unsigned long fault_ip);
+
+#endif /* _LINUX_BPF_DEFS_H */
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 08d008cc471e..bc696bef7104 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -53,6 +53,7 @@ struct bpf_arena {
 	u64 user_vm_start;
 	u64 user_vm_end;
 	struct vm_struct *kern_vm;
+	struct page *scratch_page;
 	struct range_tree rt;
 	/* protects rt */
 	rqspinlock_t spinlock;
@@ -118,6 +119,11 @@ struct apply_range_data {
 	int i;
 };
 
+struct clear_range_data {
+	struct llist_head *free_pages;
+	struct page *scratch_page;
+};
+
 static int apply_range_set_cb(pte_t *pte, unsigned long addr, void *data)
 {
 	struct apply_range_data *d = data;
@@ -144,8 +150,9 @@ static void flush_vmap_cache(unsigned long start, unsigned long size)
 	flush_cache_vmap(start, start + size);
 }
 
-static int apply_range_clear_cb(pte_t *pte, unsigned long addr, void *free_pages)
+static int apply_range_clear_cb(pte_t *pte, unsigned long addr, void *data)
 {
+	struct clear_range_data *d = data;
 	pte_t old_pte;
 	struct page *page;
 
@@ -160,17 +167,45 @@ static int apply_range_clear_cb(pte_t *pte, unsigned long addr, void *free_pages
 
 	pte_clear(&init_mm, addr, pte);
 
+	if (unlikely(!d))
+		return 0;
+
+	/*
+	 * Skip the per-arena scratch page. A kernel fault on an unallocated uaddr
+	 * scratches its PTE; a later bpf_arena_free_pages() over that range walks
+	 * here. Without the skip, scratch_page would be freed.
+	 */
+	if (page == d->scratch_page)
+		return 0;
+
 	/* Add page to the list so it is freed later */
-	if (free_pages)
-		__llist_add(&page->pcp_llist, free_pages);
+	__llist_add(&page->pcp_llist, d->free_pages);
+	return 0;
+}
+
+static int apply_range_set_scratch_cb(pte_t *pte, unsigned long addr, void *data)
+{
+	struct page *scratch_page = data;
 
+	if (!pte_none(ptep_get(pte)))
+		return 0;
+	/*
+	 * Best-effort install. ptep_try_install() returns false only if another
+	 * installer (real allocation or concurrent fault) won the cmpxchg; their
+	 * PTE is already valid, so the access retry succeeds.
+	 *
+	 * No flush_tlb_kernel_range() needed: stale "not mapped" entries just
+	 * cause one extra re-fault through this same path.
+	 */
+	ptep_try_install(pte, mk_pte(scratch_page, PAGE_KERNEL));
 	return 0;
 }
 
 static int populate_pgtable_except_pte(struct bpf_arena *arena)
 {
+	/* Populate intermediates for the recovery range (4 GiB + upper half-guard). */
 	return apply_to_page_range(&init_mm, bpf_arena_get_kern_vm_start(arena),
-				   KERN_VM_SZ - GUARD_SZ, apply_range_set_cb, NULL);
+				   SZ_4G + GUARD_SZ / 2, apply_range_set_cb, NULL);
 }
 
 static struct bpf_map *arena_map_alloc(union bpf_attr *attr)
@@ -221,22 +256,29 @@ static struct bpf_map *arena_map_alloc(union bpf_attr *attr)
 	init_irq_work(&arena->free_irq, arena_free_irq);
 	INIT_WORK(&arena->free_work, arena_free_worker);
 	bpf_map_init_from_attr(&arena->map, attr);
+
+	err = bpf_map_alloc_pages(&arena->map, NUMA_NO_NODE, 1, &arena->scratch_page);
+	if (err)
+		goto err_free_arena;
+
 	range_tree_init(&arena->rt);
 	err = range_tree_set(&arena->rt, 0, attr->max_entries);
-	if (err) {
-		bpf_map_area_free(arena);
-		goto err;
-	}
+	if (err)
+		goto err_free_scratch;
 	mutex_init(&arena->lock);
 	raw_res_spin_lock_init(&arena->spinlock);
 	err = populate_pgtable_except_pte(arena);
-	if (err) {
-		range_tree_destroy(&arena->rt);
-		bpf_map_area_free(arena);
-		goto err;
-	}
+	if (err)
+		goto err_destroy_rt;
 
 	return &arena->map;
+
+err_destroy_rt:
+	range_tree_destroy(&arena->rt);
+err_free_scratch:
+	__free_page(arena->scratch_page);
+err_free_arena:
+	bpf_map_area_free(arena);
 err:
 	free_vm_area(kern_vm);
 	return ERR_PTR(err);
@@ -244,6 +286,7 @@ static struct bpf_map *arena_map_alloc(union bpf_attr *attr)
 
 static int existing_page_cb(pte_t *ptep, unsigned long addr, void *data)
 {
+	struct bpf_arena *arena = data;
 	struct page *page;
 	pte_t pte;
 
@@ -251,6 +294,12 @@ static int existing_page_cb(pte_t *ptep, unsigned long addr, void *data)
 	if (!pte_present(pte)) /* sanity check */
 		return 0;
 	page = pte_page(pte);
+	/*
+	 * Skip the scratch page. The walk is page-table-driven, not range-tree-driven,
+	 * so it can visit scratch PTEs at uaddrs the BPF program never allocated.
+	 */
+	if (page == arena->scratch_page)
+		return 0;
 	/*
 	 * We do not update pte here:
 	 * 1. Nobody should be accessing bpf_arena's range outside of a kernel bug
@@ -286,9 +335,10 @@ static void arena_map_free(struct bpf_map *map)
 	 * free those pages.
 	 */
 	apply_to_existing_page_range(&init_mm, bpf_arena_get_kern_vm_start(arena),
-				     KERN_VM_SZ - GUARD_SZ, existing_page_cb, NULL);
+				     SZ_4G + GUARD_SZ / 2, existing_page_cb, arena);
 	free_vm_area(arena->kern_vm);
 	range_tree_destroy(&arena->rt);
+	__free_page(arena->scratch_page);
 	bpf_map_area_free(arena);
 }
 
@@ -374,33 +424,37 @@ static vm_fault_t arena_vm_fault(struct vm_fault *vmf)
 		return VM_FAULT_RETRY;
 
 	page = vmalloc_to_page((void *)kaddr);
-	if (page)
+	if (page) {
+		if (page == arena->scratch_page)
+			/* BPF triggered scratch here; don't lazy-alloc over it */
+			goto out_sigsegv;
 		/* already have a page vmap-ed */
 		goto out;
+	}
 
 	bpf_map_memcg_enter(&arena->map, &old_memcg, &new_memcg);
 
 	if (arena->map.map_flags & BPF_F_SEGV_ON_FAULT)
 		/* User space requested to segfault when page is not allocated by bpf prog */
-		goto out_unlock_sigsegv;
+		goto out_sigsegv_memcg;
 
 	ret = range_tree_clear(&arena->rt, vmf->pgoff, 1);
 	if (ret)
-		goto out_unlock_sigsegv;
+		goto out_sigsegv_memcg;
 
 	struct apply_range_data data = { .pages = &page, .i = 0 };
 	/* Account into memcg of the process that created bpf_arena */
 	ret = bpf_map_alloc_pages(map, NUMA_NO_NODE, 1, &page);
 	if (ret) {
 		range_tree_set(&arena->rt, vmf->pgoff, 1);
-		goto out_unlock_sigsegv;
+		goto out_sigsegv_memcg;
 	}
 
 	ret = apply_to_page_range(&init_mm, kaddr, PAGE_SIZE, apply_range_set_cb, &data);
 	if (ret) {
 		range_tree_set(&arena->rt, vmf->pgoff, 1);
 		free_pages_nolock(page, 0);
-		goto out_unlock_sigsegv;
+		goto out_sigsegv_memcg;
 	}
 	flush_vmap_cache(kaddr, PAGE_SIZE);
 	bpf_map_memcg_exit(old_memcg, new_memcg);
@@ -409,8 +463,9 @@ static vm_fault_t arena_vm_fault(struct vm_fault *vmf)
 	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
 	vmf->page = page;
 	return 0;
-out_unlock_sigsegv:
+out_sigsegv_memcg:
 	bpf_map_memcg_exit(old_memcg, new_memcg);
+out_sigsegv:
 	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
 	return VM_FAULT_SIGSEGV;
 }
@@ -668,6 +723,7 @@ static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt,
 	struct llist_head free_pages;
 	struct llist_node *pos, *t;
 	struct arena_free_span *s;
+	struct clear_range_data cdata;
 	unsigned long flags;
 	int ret = 0;
 
@@ -696,9 +752,11 @@ static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt,
 	range_tree_set(&arena->rt, pgoff, page_cnt);
 
 	init_llist_head(&free_pages);
+	cdata.free_pages = &free_pages;
+	cdata.scratch_page = arena->scratch_page;
 	/* clear ptes and collect struct pages */
 	apply_to_existing_page_range(&init_mm, kaddr, page_cnt << PAGE_SHIFT,
-				     apply_range_clear_cb, &free_pages);
+				     apply_range_clear_cb, &cdata);
 
 	/* drop the lock to do the tlb flush and zap pages */
 	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
@@ -788,6 +846,7 @@ static void arena_free_worker(struct work_struct *work)
 	struct arena_free_span *s;
 	u64 arena_vm_start, user_vm_start;
 	struct llist_head free_pages;
+	struct clear_range_data cdata;
 	struct page *page;
 	unsigned long full_uaddr;
 	long kaddr, page_cnt, pgoff;
@@ -801,6 +860,8 @@ static void arena_free_worker(struct work_struct *work)
 	bpf_map_memcg_enter(&arena->map, &old_memcg, &new_memcg);
 
 	init_llist_head(&free_pages);
+	cdata.free_pages = &free_pages;
+	cdata.scratch_page = arena->scratch_page;
 	arena_vm_start = bpf_arena_get_kern_vm_start(arena);
 	user_vm_start = bpf_arena_get_user_vm_start(arena);
 
@@ -813,7 +874,7 @@ static void arena_free_worker(struct work_struct *work)
 
 		/* clear ptes and collect pages in free_pages llist */
 		apply_to_existing_page_range(&init_mm, kaddr, page_cnt << PAGE_SHIFT,
-					     apply_range_clear_cb, &free_pages);
+					     apply_range_clear_cb, &cdata);
 
 		range_tree_set(&arena->rt, pgoff, page_cnt);
 	}
@@ -928,23 +989,12 @@ static int __init kfunc_init(void)
 }
 late_initcall(kfunc_init);
 
-void bpf_prog_report_arena_violation(bool write, unsigned long addr, unsigned long fault_ip)
+static void __bpf_prog_report_arena_violation(struct bpf_prog *prog, bool write,
+					      unsigned long addr, unsigned long fault_ip)
 {
 	struct bpf_stream_stage ss;
-	struct bpf_prog *prog;
 	u64 user_vm_start;
 
-	/*
-	 * The RCU read lock is held to safely traverse the latch tree, but we
-	 * don't need its protection when accessing the prog, since it will not
-	 * disappear while we are handling the fault.
-	 */
-	rcu_read_lock();
-	prog = bpf_prog_ksym_find(fault_ip);
-	rcu_read_unlock();
-	if (!prog)
-		return;
-
 	/* Use main prog for stream access */
 	prog = prog->aux->main_prog_aux->prog;
 
@@ -957,3 +1007,53 @@ void bpf_prog_report_arena_violation(bool write, unsigned long addr, unsigned lo
 		bpf_stream_dump_stack(ss);
 	}));
 }
+
+bool bpf_arena_handle_page_fault(unsigned long addr, bool is_write, unsigned long fault_ip)
+{
+	struct bpf_arena *arena;
+	struct bpf_prog *prog;
+	unsigned long kbase;
+	unsigned long page_addr = addr & PAGE_MASK;
+
+	prog = bpf_prog_find_from_stack();
+	if (!prog)
+		return false;
+
+	arena = prog->aux->arena;
+	/* a prog not using arena may be on stack, so arena can be NULL */
+	if (!arena)
+		return false;
+
+	kbase = bpf_arena_get_kern_vm_start(arena);
+
+	/*
+	 * Recovery covers the 4 GiB mappable band plus the upper half-guard.
+	 * Lower guard is unreachable from kfuncs; an address there indicates
+	 * a different bug class - leave it to the regular kernel oops path.
+	 */
+	if (page_addr < kbase || page_addr >= kbase + SZ_4G + GUARD_SZ / 2)
+		return false;
+
+	apply_to_page_range(&init_mm, page_addr, PAGE_SIZE,
+			    apply_range_set_scratch_cb, arena->scratch_page);
+	flush_vmap_cache(page_addr, PAGE_SIZE);
+	__bpf_prog_report_arena_violation(prog, is_write, page_addr - kbase, fault_ip);
+	return true;
+}
+
+void bpf_prog_report_arena_violation(bool write, unsigned long addr, unsigned long fault_ip)
+{
+	struct bpf_prog *prog;
+
+	/*
+	 * The RCU read lock is held to safely traverse the latch tree, but we
+	 * don't need its protection when accessing the prog, since it will not
+	 * disappear while we are handling the fault.
+	 */
+	rcu_read_lock();
+	prog = bpf_prog_ksym_find(fault_ip);
+	rcu_read_unlock();
+	if (!prog)
+		return;
+	__bpf_prog_report_arena_violation(prog, write, addr, fault_ip);
+}
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 066b86e7233c..fa368d8920d9 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -3290,6 +3290,11 @@ __weak u64 bpf_arena_get_kern_vm_start(struct bpf_arena *arena)
 {
 	return 0;
 }
+__weak bool bpf_arena_handle_page_fault(unsigned long addr, bool is_write,
+					unsigned long fault_ip)
+{
+	return false;
+}
 
 #ifdef CONFIG_BPF_SYSCALL
 static int __init bpf_global_ma_init(void)
-- 
2.54.0


