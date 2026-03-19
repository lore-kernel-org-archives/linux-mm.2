Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B53131075275
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D78946B0436; Thu, 19 Mar 2026 04:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50436B0438; Thu, 19 Mar 2026 04:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8C906B0439; Thu, 19 Mar 2026 04:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7EF56B0436
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:32:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63D5413ABDE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:32:55 +0000 (UTC)
X-FDA: 84562147110.14.EE6AA24
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf25.hostedemail.com (Postfix) with ESMTP id 875ACA0007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:32:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RnUZEgXr;
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773909173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TU6gcYFyqHku0PKjXCQBjJUvLxC447LGsL/t7ZXARkM=;
	b=XHwuLmyAQfi6ISgcjmf6NG/CZwkTFste6dHKb0mFa1I6Sr7XCZpOgJ6CZaJjvtNzKYktqE
	7SO5EgVR7cCJwid93UVIOVfsU7drNNFDP3gBxKdxeREpkYJa3OKTgd29ZDNeXHfMiAjEbj
	OvkV/b4YOzFN5ZVnRoBqX3cQsxW96Q4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773909173; a=rsa-sha256;
	cv=none;
	b=65RaGFWxjNmigEPQwVVdFWrOJntM6wrUgNXvBCl+4ce4Wg3NufLRCwFOStLsykwSljIaVy
	NE9ZLtXeAEyiS0+UtXRLhO06ftsjTXAoms4zwv8rJD3hHCKhvvWAEfiy/y1Ko5J2r9JCcs
	QRYpKTYw3aawh+RI30APE2l8HRm+CsM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RnUZEgXr;
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773909171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TU6gcYFyqHku0PKjXCQBjJUvLxC447LGsL/t7ZXARkM=;
	b=RnUZEgXrzqu9MxywVIEMBPFnDF2rnUxb1mtJZx/DQpcJ+CY0/OjVLUE26+hD+CTAeyYVM4
	IqUBMJC4r4fzPr46OuEWR1qP8d9MB49toJrttjR5/wrBYiOXlVDP4kk4FpbfoygZqVtwPO
	yGpHhg/7piR3rTqZfEhqT7a8HlTct/I=
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH] mm/alloc_tag: clear codetag for pages allocated before page_ext initialization
Date: Thu, 19 Mar 2026 16:31:53 +0800
Message-Id: <20260319083153.2488005-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 875ACA0007
X-Stat-Signature: fajxjf48zm3cxufxm1qjix4if17chb84
X-Rspam-User: 
X-HE-Tag: 1773909173-759178
X-HE-Meta: U2FsdGVkX19oOHPMIh/xCD0CN3O8wurdNCAHTDOBPMjoaZ1tdQFwcPW+ItKrMaJtkHVO0gSYFpDdnkluWY05zPV/Gmy9/DUxDyUGOiTRB/44hG6ZWr87WQ6Mhflm/GhPS6gopcKV8XM5IuGA7vVPYOSffAChpDa8yOobzODeZf2vRDXQXWOiAndk5bhlDMy07eZ0X+FKM7i0HqAbb1ORYYeijU2gMGQR13ZTJ5IAKh3dQ6hB5Si++rhTYbGWgTs6GdZSp5NJBa1R0SFjQkxlmO3URilJL67AGx6/nrcia3E778sWDAvWXI1FTwuwJyA+U8psW1cqjIgGpKNKXy+MTX1NYl03IOj3f45SFxtVaHaNJPDYfNDZK6S5G3T13d+Ok9JyDVt11KdtQMDXH7t/m0I6hjC5bCua2Vj6YwEq2DcsIOK7oEaSvCaVWSN4F1Gg14TKfezk7YeHkOsuWXgC/yiTnnkBCKvYeNPZJh0KGYx16l+tLdR3+TJx/G89Y+tdNddgoauQ0hesNwZdfIRZzHK6OhbjoXH6AO03eDhUbHbbLlrUwiPxnSDyakoJbsV/yOhpla/LBW11DAhBkAI7XNqwYxRXNZINdHEEucO8eOdzHwhbeRj3RmGO6nLgKJukCqmw2uIwkvG2aLDywKNMbfGeNGWD+C+bXe6aRiXvyH8I9FoPbxOCHV3Y+ML+chFeHcRO68jeY0mxAG8sc2RXvD0HG7ajbpJmQmR6CVvGD1/0O3dlljPQdcWAr8InYTBW8314ISmYZkv9sUOA/Cbc5YUd45t4crnoXy3obdyfyOSWok4fEncJ/gisCbt0tsq98eqM7bCAlnnOgf4RIzd/n+jIk1nDIjOSIFdW/KuKbI7MkojhcWMZw9T8tfrklb1/nHSk8PZIi8WdWnrwA+mWfm/GMFTySZYLyqG+3rEFC6m7ZbetmKLiVhXdgz13rgil5s//s/3qgnxC4zWvIbA
 NrQNqI9Z
 AOpXzJZThIqqhTXAYJcxagOyscujmbsjB2m9+PySTKeDV/Go7Xx1DdFujF3uLX/ZK2amSZditJgQWKz2bUblqfdG0UB42PuE4Qe8XO2ss6Rc3nEiG9koNWBLeLasiGCr0UKsqj6Z1b27STgPbci5B6XHmA08WNWrfxDL8faNKIru+kmlFiEqbQpwPhAZOMnXAP4tGtegKRYiSGlHxOThHw/03G6LL7jqhIjR0hqztVQWAoXGGK0ZDx45voOJScjeqzP87j3rGVy9vauKfTOBqPtbQPeVtNeNQhNHuC2OQ47+Tjwc=
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
codetag set. These pages may later be reclaimed by KASAN,which causes
the warning to trigger when they are freed because their codetag ref is
still empty.

Use a global array to track pages allocated before page_ext is fully
initialized, similar to how kmemleak tracks early allocations.
When page_ext initialization completes, set their codetag
to empty to avoid warnings when they are freed later.

The following warning may be noticed:
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

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 include/linux/alloc_tag.h |  3 ++
 lib/alloc_tag.c           | 80 +++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c           |  7 ++++
 3 files changed, 90 insertions(+)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index d40ac39bfbe8..941bb4e40d3f 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -74,6 +74,9 @@ static inline void set_codetag_empty(union codetag_ref *ref)
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 
+bool mem_profiling_is_available(void);
+void alloc_tag_add_early_pfn(unsigned long pfn);
+
 #define ALLOC_TAG_SECTION_NAME	"alloc_tags"
 
 struct codetag_bytes {
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 58991ab09d84..a5bf4e72c154 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -6,6 +6,7 @@
 #include <linux/kallsyms.h>
 #include <linux/module.h>
 #include <linux/page_ext.h>
+#include <linux/pgalloc_tag.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_buf.h>
 #include <linux/seq_file.h>
@@ -26,6 +27,82 @@ static bool mem_profiling_support;
 
 static struct codetag_type *alloc_tag_cttype;
 
+/*
+ * State of the alloc_tag
+ *
+ * This is used to describe the states of the alloc_tag during bootup.
+ *
+ * When we need to allocate page_ext to store codetag, we face an
+ * initialization timing problem:
+ *
+ * Due to initialization order, pages may be allocated via buddy system
+ * before page_ext is fully allocated and initialized. Although these
+ * pages call the allocation hooks, the codetag will not be set because
+ * page_ext is not yet available.
+ *
+ * When these pages are later free to the buddy system, it triggers
+ * warnings because their codetag is actually empty if
+ * CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled.
+ *
+ * Additionally, in this situation, we cannot record detailed allocation
+ * information for these pages.
+ */
+enum mem_profiling_state {
+	DOWN,			/* No mem_profiling functionality yet */
+	UP			/* Everything is working */
+};
+
+static enum mem_profiling_state mem_profiling_state = DOWN;
+
+bool mem_profiling_is_available(void)
+{
+	return mem_profiling_state == UP;
+}
+
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+
+#define EARLY_ALLOC_PFN_MAX		256
+
+static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX];
+static unsigned int early_pfn_count;
+static DEFINE_SPINLOCK(early_pfn_lock);
+
+void alloc_tag_add_early_pfn(unsigned long pfn)
+{
+	unsigned long flags;
+
+	if (mem_profiling_state != DOWN)
+		return;
+
+	spin_lock_irqsave(&early_pfn_lock, flags);
+	if (early_pfn_count >= EARLY_ALLOC_PFN_MAX) {
+		spin_unlock_irqrestore(&early_pfn_lock, flags);
+		return;
+	}
+	early_pfns[early_pfn_count++] = pfn;
+	spin_unlock_irqrestore(&early_pfn_lock, flags);
+}
+
+static void __init clear_early_alloc_pfn_tag_refs(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < early_pfn_count; i++) {
+		unsigned long pfn = early_pfns[i];
+
+		if (pfn_valid(pfn)) {
+			struct page *page = pfn_to_page(pfn);
+
+			clear_page_tag_ref(page);
+		}
+	}
+	early_pfn_count = 0;
+}
+#else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
+inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
+static inline void clear_early_alloc_pfn_tag_refs(void) {}
+#endif
+
 #ifdef CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU
 DEFINE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
 EXPORT_SYMBOL(_shared_alloc_tag);
@@ -729,6 +806,7 @@ static int __init setup_early_mem_profiling(char *str)
 			compressed = true;
 		}
 		mem_profiling_support = true;
+		mem_profiling_state = UP;
 		pr_info("Memory allocation profiling is enabled %s compression and is turned %s!\n",
 			compressed ? "with" : "without", str_on_off(enable));
 	}
@@ -760,6 +838,8 @@ static __init bool need_page_alloc_tagging(void)
 
 static __init void init_page_alloc_tagging(void)
 {
+	mem_profiling_state = UP;
+	clear_early_alloc_pfn_tag_refs();
 }
 
 struct page_ext_operations page_alloc_tagging_ops = {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..336281d91d91 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1293,6 +1293,13 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
 		alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
 		update_page_tag_ref(handle, &ref);
 		put_page_tag_ref(handle);
+	} else {
+		/*
+		 * page_ext is not available yet, record the pfn so we can
+		 * clear the tag ref later when page_ext is initialized.
+		 */
+		if (!mem_profiling_is_available())
+			alloc_tag_add_early_pfn(page_to_pfn(page));
 	}
 }
 
-- 
2.25.1


