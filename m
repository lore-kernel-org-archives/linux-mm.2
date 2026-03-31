Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649C9FF60E1
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89B56B0096; Tue, 31 Mar 2026 04:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13526B0098; Tue, 31 Mar 2026 04:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950AF6B0099; Tue, 31 Mar 2026 04:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 837F96B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:14:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 190B9160B81
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:14:19 +0000 (UTC)
X-FDA: 84605645838.24.2705E48
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5DFED40005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:14:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KPhWyuF5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774944857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0OEStDXL/zZjKkzbq8Nt2VhGm927WEhSrtWgxx4JZ0Y=;
	b=3FkT2eulmq8/csj0icLeKNujNU2Tl3zMPHlKn2HFXmHMenEBI3cDy4JEIdCO0OG0nRjy6J
	sA3uQqO0pSqPurZtckcbWkxD8oTNFMKmClaTl6JgYadq/gj9uwLma+7TAI9tS7VXGv8+eW
	ITyLvFFh0r7Rlq2uu9tlM5JV0XCxGsg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774944857; a=rsa-sha256;
	cv=none;
	b=UC81eGG50wA9X8vab3zspJRhLtBHQIpX1k7f7lcJDId2NCTQKuOrAM5o1XLl/KR4uJCkw9
	yTCD5UMgfe414KC9Gw4qjQLRtPKO0KjW/pldSjwEUlKLFaIqKgOnR+pNu8VELHiyuHm3Qj
	gD8vl25bC/HyHy+Ib0YYhcsl18n6aII=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KPhWyuF5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774944855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0OEStDXL/zZjKkzbq8Nt2VhGm927WEhSrtWgxx4JZ0Y=;
	b=KPhWyuF54WiaCrhrhrDhE4DE6/96nkLLgOaSo2yaj6RXD5toSzkDOlj9vCctzF1v5nJwTS
	BXWdtZpxPgc3MF1RnMYTNW9NlJZxyFAARpbo4T5/2qnKIj2PSyjDCtd7Z2aWVhe29FO1t0
	M3Nrp1B0eJ06fm0c0PrvmHKxY4AwvzQ=
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <hao.ge@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v4] mm/alloc_tag: clear codetag for pages allocated before page_ext initialization
Date: Tue, 31 Mar 2026 16:13:12 +0800
Message-Id: <20260331081312.123719-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5DFED40005
X-Stat-Signature: 5zr769p6xznnd9up9u9y3rsdauczefkq
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774944857-176253
X-HE-Meta: U2FsdGVkX1/1SKZNIJhFG8pTP3L1F6DNv5tV0eMRQbQ6APwRyFBWIoKnDMGeZ2R2dz4EZL3RRA8Ka/az6mI3bUhM7AYS01T1x2t2z4mN5Uj5YWs65ctrUYYx8MTfbfT7wdjEcmyF3BkXIhYVJN/4oz+6nx+xnd4iyb+zL3e1TOvcsYv1xItbO/xWRwY8vGFQgjlV0x65Cl5LCzUHBwxZ4CVNZHK2uPEKjhp9ycHOJzIvA0mQYhcgVE07bCVRJzJxbny8Az9r/i7gSQRU+9mql6WmAst0kXL4doHTrge4KqLnXZ+5Pv0jfuSq6+B8N+0CCcdOSnXRAI9IAcRKk/Hd9gHCQn49+QCKZ1VEyFPpP2ncB2jUsWtZF3LGXceXAKkEE48uk3EDqKYrhVj3ujmsE4HVWRIpEmFOZlnAA32igFu+sivuDb63o2zUPP2peF0yCs77DwL8dvoW2iX4TS3IjyS7tcHYjRQOeQAvSg9RgC3/30rJxEcze1ouKqeQ7QoUogN3ORVY0fqx+EDi3hEOY7AO2IADswn5lPkOF0yc6su9xwPsTMOH0Tg+PMC1XHhkLWqnUMPYUcZCBy5JnR/ckHoMT/J164H09AonexWmyG7QkgC+cYjkw+rnpR9t/CfC//aWS875ZcEIKUbC+TmU8T1lJ5ph5CoF28aZyrwwFGMpYx9a/mivr+aRtggF4ZhllsYw3UTWnoabaO0kmqK9GpuRKg4NcsXYnf68SrU112TqGlQ+29fDMZMvmWDnJetXHIq3YhoJKTdgj1ffSo2A1mEFgprkOg3M59zl3hpFYIUAgVDt9JTZG1II1PkzX8uH3q7vg12YyWnp4SQUyPU1J4kj3l3rRMu0hG3XfrlqX9lbnxC0nbWqxOcxfwmKIxY14gIgXRwP7YmqFHrnyQQ8YpZ4CXmzmBozn49aDgvi+oZpXgmNo1BUT9FmgiFpuRCAyDAGaiQgclI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Due to initialization ordering, page_ext is allocated and initialized
relatively late during boot. Some pages have already been allocated
and freed before page_ext becomes available, leaving their codetag
uninitialized.

A clear example is in init_section_page_ext(): alloc_page_ext() calls
kmemleak_alloc(). If the slab cache has no free objects, it falls back
to the buddy allocator to allocate memory. However, at this point page_ext
is not yet fully initialized, so these newly allocated pages have no
codetag set. These pages may later be reclaimed by KASAN, which causes
the warning to trigger when they are freed because their codetag ref is
still empty.

Use a global array to track pages allocated before page_ext is fully
initialized. The array size is fixed at 8192 entries, and will emit
a warning if this limit is exceeded. When page_ext initialization
completes, set their codetag to empty to avoid warnings when they
are freed later.

This warning is only observed with CONFIG_MEM_ALLOC_PROFILING_DEBUG=Y
and mem_profiling_compressed disabled:

[    9.582133] ------------[ cut here ]------------
[    9.582137] alloc_tag was not set
[    9.582139] WARNING: ./include/linux/alloc_tag.h:164 at __pgalloc_tag_sub+0x40f/0x550, CPU#5: systemd/1
[    9.582190] CPU: 5 UID: 0 PID: 1 Comm: systemd Not tainted 7.0.0-rc4 #1 PREEMPT(lazy)
[    9.582192] Hardware name: Red Hat KVM, BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[    9.582194] RIP: 0010:__pgalloc_tag_sub+0x40f/0x550
[    9.582196] Code: 00 00 4c 29 e5 48 8b 05 1f 88 56 05 48 8d 4c ad 00 48 8d 2c c8 e9 87 fd ff ff 0f 0b 0f 0b e9 f3 fe ff ff 48 8d 3d 61 2f ed 03 <67> 48 0f b9 3a e9 b3 fd ff ff 0f 0b eb e4 e8 5e cd 14 02 4c 89 c7
[    9.582197] RSP: 0018:ffffc9000001f940 EFLAGS: 00010246
[    9.582200] RAX: dffffc0000000000 RBX: 1ffff92000003f2b RCX: 1ffff110200d806c
[    9.582201] RDX: ffff8881006c0360 RSI: 0000000000000004 RDI: ffffffff9bc7b460
[    9.582202] RBP: 0000000000000000 R08: 0000000000000000 R09: fffffbfff3a62324
[    9.582203] R10: ffffffff9d311923 R11: 0000000000000000 R12: ffffea0004001b00
[    9.582204] R13: 0000000000002000 R14: ffffea0000000000 R15: ffff8881006c0360
[    9.582206] FS:  00007ffbbcf2d940(0000) GS:ffff888450479000(0000) knlGS:0000000000000000
[    9.582208] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    9.582210] CR2: 000055ee3aa260d0 CR3: 0000000148b67005 CR4: 0000000000770ef0
[    9.582211] PKRU: 55555554
[    9.582212] Call Trace:
[    9.582213]  <TASK>
[    9.582214]  ? __pfx___pgalloc_tag_sub+0x10/0x10
[    9.582216]  ? check_bytes_and_report+0x68/0x140
[    9.582219]  __free_frozen_pages+0x2e4/0x1150
[    9.582221]  ? __free_slab+0xc2/0x2b0
[    9.582224]  qlist_free_all+0x4c/0xf0
[    9.582227]  kasan_quarantine_reduce+0x15d/0x180
[    9.582229]  __kasan_slab_alloc+0x69/0x90
[    9.582232]  kmem_cache_alloc_noprof+0x14a/0x500
[    9.582234]  do_getname+0x96/0x310
[    9.582237]  do_readlinkat+0x91/0x2f0
[    9.582239]  ? __pfx_do_readlinkat+0x10/0x10
[    9.582240]  ? get_random_bytes_user+0x1df/0x2c0
[    9.582244]  __x64_sys_readlinkat+0x96/0x100
[    9.582246]  do_syscall_64+0xce/0x650
[    9.582250]  ? __x64_sys_getrandom+0x13a/0x1e0
[    9.582252]  ? __pfx___x64_sys_getrandom+0x10/0x10
[    9.582254]  ? do_syscall_64+0x114/0x650
[    9.582255]  ? ksys_read+0xfc/0x1d0
[    9.582258]  ? __pfx_ksys_read+0x10/0x10
[    9.582260]  ? do_syscall_64+0x114/0x650
[    9.582262]  ? do_syscall_64+0x114/0x650
[    9.582264]  ? __pfx_fput_close_sync+0x10/0x10
[    9.582266]  ? file_close_fd_locked+0x178/0x2a0
[    9.582268]  ? __x64_sys_faccessat2+0x96/0x100
[    9.582269]  ? __x64_sys_close+0x7d/0xd0
[    9.582271]  ? do_syscall_64+0x114/0x650
[    9.582273]  ? do_syscall_64+0x114/0x650
[    9.582275]  ? clear_bhb_loop+0x50/0xa0
[    9.582277]  ? clear_bhb_loop+0x50/0xa0
[    9.582279]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[    9.582280] RIP: 0033:0x7ffbbda345ee
[    9.582282] Code: 0f 1f 40 00 48 8b 15 29 38 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff c3 0f 1f 40 00 f3 0f 1e fa 49 89 ca b8 0b 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d fa 37 0d 00 f7 d8 64 89 01 48
[    9.582284] RSP: 002b:00007ffe2ad8de58 EFLAGS: 00000202 ORIG_RAX: 000000000000010b
[    9.582286] RAX: ffffffffffffffda RBX: 000055ee3aa25570 RCX: 00007ffbbda345ee
[    9.582287] RDX: 000055ee3aa25570 RSI: 00007ffe2ad8dee0 RDI: 00000000ffffff9c
[    9.582288] RBP: 0000000000001000 R08: 0000000000000003 R09: 0000000000001001
[    9.582289] R10: 0000000000001000 R11: 0000000000000202 R12: 0000000000000033
[    9.582290] R13: 00007ffe2ad8dee0 R14: 00000000ffffff9c R15: 00007ffe2ad8deb0
[    9.582292]  </TASK>
[    9.582293] ---[ end trace 0000000000000000 ]---

Fixes: dcfe378c81f72 ("lib: introduce support for page allocation tagging")
Cc: stable@vger.kernel.org
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
v4: Fix sparse warnings by changing the typedef from a function pointer
    type to a function type, and placing __rcu before the pointer
    declarator. Use RCU_INITIALIZER() for static initialization.
    Closes: https://lore.kernel.org/oe-kbuild-all/202603291211.YhY0R0se-lkp@intel.com/

v3:
  - Use RCU to protect alloc_tag_add_early_pfn_ptr and avoid race conditions
    between alloc_tag_add_early_pfn() and clear_early_alloc_pfn_tag_refs()
  - Add static_key_enabled() check in clear_early_alloc_pfn_tag_refs()
  - Use task->alloc_tag instead of current->alloc_tag
  - Add NULL check for task->alloc_tag before calling alloc_tag_set_inaccurate()
  - Add likely() hint for get_page_tag_ref() in the common path
  - Update comments to explain the small race window between ref.ct check
    and set_codetag_empty()
  - Move all CONFIG_MEM_ALLOC_PROFILING_DEBUG code (variables and functions)
    together near init_page_alloc_tagging() for better code organization
  - Add TODO comment about replacing fixed-size array with dynamic allocation
    using a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion
  - Update function declaration in header file to use #if defined() style

v2:
  - Replace spin_lock_irqsave() with atomic_try_cmpxchg() to avoid potential
     deadlock in NMI context
  - Change EARLY_ALLOC_PFN_MAX from 256 to 8192
  - Add pr_warn_once() when the limit is exceeded
  - Check ref.ct before clearing to avoid overwriting valid tags
  - Use function pointer (alloc_tag_add_early_pfn_ptr) instead of state
---
 include/linux/alloc_tag.h   |   2 +
 include/linux/pgalloc_tag.h |   2 +-
 lib/alloc_tag.c             | 109 ++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             |  10 +++-
 4 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index d40ac39bfbe8..02de2ede560f 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -163,9 +163,11 @@ static inline void alloc_tag_sub_check(union codetag_ref *ref)
 {
 	WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
 }
+void alloc_tag_add_early_pfn(unsigned long pfn);
 #else
 static inline void alloc_tag_add_check(union codetag_ref *ref, struct alloc_tag *tag) {}
 static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
+static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
 #endif
 
 /* Caller should verify both ref and tag to be valid */
diff --git a/include/linux/pgalloc_tag.h b/include/linux/pgalloc_tag.h
index 38a82d65e58e..951d33362268 100644
--- a/include/linux/pgalloc_tag.h
+++ b/include/linux/pgalloc_tag.h
@@ -181,7 +181,7 @@ static inline struct alloc_tag *__pgalloc_tag_get(struct page *page)
 
 	if (get_page_tag_ref(page, &ref, &handle)) {
 		alloc_tag_sub_check(&ref);
-		if (ref.ct)
+		if (ref.ct && !is_codetag_empty(&ref))
 			tag = ct_to_alloc_tag(ref.ct);
 		put_page_tag_ref(handle);
 	}
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 58991ab09d84..ed1bdcf1f8ab 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -6,7 +6,9 @@
 #include <linux/kallsyms.h>
 #include <linux/module.h>
 #include <linux/page_ext.h>
+#include <linux/pgalloc_tag.h>
 #include <linux/proc_fs.h>
+#include <linux/rcupdate.h>
 #include <linux/seq_buf.h>
 #include <linux/seq_file.h>
 #include <linux/string_choices.h>
@@ -758,8 +760,115 @@ static __init bool need_page_alloc_tagging(void)
 	return mem_profiling_support;
 }
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+/*
+ * Track page allocations before page_ext is initialized.
+ * Some pages are allocated before page_ext becomes available, leaving
+ * their codetag uninitialized. Track these early PFNs so we can clear
+ * their codetag refs later to avoid warnings when they are freed.
+ *
+ * Early allocations include:
+ *   - Base allocations independent of CPU count
+ *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_init,
+ *     such as trace ring buffers, scheduler per-cpu data)
+ *
+ * For simplicity, we fix the size to 8192.
+ * If insufficient, a warning will be triggered to alert the user.
+ *
+ * TODO: Replace fixed-size array with dynamic allocation using
+ * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
+ */
+#define EARLY_ALLOC_PFN_MAX		8192
+
+static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
+static atomic_t early_pfn_count __initdata = ATOMIC_INIT(0);
+
+static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
+{
+	int old_idx, new_idx;
+
+	do {
+		old_idx = atomic_read(&early_pfn_count);
+		if (old_idx >= EARLY_ALLOC_PFN_MAX) {
+			pr_warn_once("Early page allocations before page_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
+				      EARLY_ALLOC_PFN_MAX);
+			return;
+		}
+		new_idx = old_idx + 1;
+	} while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx));
+
+	early_pfns[old_idx] = pfn;
+}
+
+typedef void alloc_tag_add_func(unsigned long pfn);
+static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
+	RCU_INITIALIZER(__alloc_tag_add_early_pfn);
+
+void alloc_tag_add_early_pfn(unsigned long pfn)
+{
+	alloc_tag_add_func *alloc_tag_add;
+
+	if (static_key_enabled(&mem_profiling_compressed))
+		return;
+
+	rcu_read_lock();
+	alloc_tag_add = rcu_dereference(alloc_tag_add_early_pfn_ptr);
+	if (alloc_tag_add)
+		alloc_tag_add(pfn);
+	rcu_read_unlock();
+}
+
+static void __init clear_early_alloc_pfn_tag_refs(void)
+{
+	unsigned int i;
+
+	if (static_key_enabled(&mem_profiling_compressed))
+		return;
+
+	rcu_assign_pointer(alloc_tag_add_early_pfn_ptr, NULL);
+	/* Make sure we are not racing with __alloc_tag_add_early_pfn() */
+	synchronize_rcu();
+
+	for (i = 0; i < atomic_read(&early_pfn_count); i++) {
+		unsigned long pfn = early_pfns[i];
+
+		if (pfn_valid(pfn)) {
+			struct page *page = pfn_to_page(pfn);
+			union pgtag_ref_handle handle;
+			union codetag_ref ref;
+
+			if (get_page_tag_ref(page, &ref, &handle)) {
+				/*
+				 * An early-allocated page could be freed and reallocated
+				 * after its page_ext is initialized but before we clear it.
+				 * In that case, it already has a valid tag set.
+				 * We should not overwrite that valid tag with CODETAG_EMPTY.
+				 *
+				 * Note: there is still a small race window between checking
+				 * ref.ct and calling set_codetag_empty(). We accept this
+				 * race as it's unlikely and the extra complexity of atomic
+				 * cmpxchg is not worth it for this debug-only code path.
+				 */
+				if (ref.ct) {
+					put_page_tag_ref(handle);
+					continue;
+				}
+
+				set_codetag_empty(&ref);
+				update_page_tag_ref(handle, &ref);
+				put_page_tag_ref(handle);
+			}
+		}
+
+	}
+}
+#else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
+static inline void __init clear_early_alloc_pfn_tag_refs(void) {}
+#endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
+
 static __init void init_page_alloc_tagging(void)
 {
+	clear_early_alloc_pfn_tag_refs();
 }
 
 struct page_ext_operations page_alloc_tagging_ops = {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..04494bc2e46f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1289,10 +1289,18 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
 	union pgtag_ref_handle handle;
 	union codetag_ref ref;
 
-	if (get_page_tag_ref(page, &ref, &handle)) {
+	if (likely(get_page_tag_ref(page, &ref, &handle))) {
 		alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
 		update_page_tag_ref(handle, &ref);
 		put_page_tag_ref(handle);
+	} else {
+		/*
+		 * page_ext is not available yet, record the pfn so we can
+		 * clear the tag ref later when page_ext is initialized.
+		 */
+		alloc_tag_add_early_pfn(page_to_pfn(page));
+		if (task->alloc_tag)
+			alloc_tag_set_inaccurate(task->alloc_tag);
 	}
 }
 
-- 
2.25.1


