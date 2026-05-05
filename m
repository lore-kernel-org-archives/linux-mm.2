Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D97FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 08:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264026B009F; Tue,  5 May 2026 04:27:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23AF56B00A6; Tue,  5 May 2026 04:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151C96B00A8; Tue,  5 May 2026 04:27:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 052816B009F
	for <linux-mm@kvack.org>; Tue,  5 May 2026 04:27:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC0CA16037B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:27:07 +0000 (UTC)
X-FDA: 84732686094.21.ABAFDB3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id E2E9318000A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:27:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Vso5axNB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777969625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wlFQn4mCAZ4JDf9m+1oTd5OJECuerm+FwCyUKdfn60=;
	b=NuUr1UViAa6jXrlXpukVYKAL2htr9xjtrgO7/TpVPvmcACUht5isbYrOPW1r3fTpn2lM7U
	LBQ87GNq2m3IXHgWNs0u6JAG/84IYQG7rT3siKBgiGvkIyEDVcuFw/6viiSxEK/Kx4VjRI
	bj5W/iJ2d30uN23sSth72mcvr20ji6g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777969625; a=rsa-sha256;
	cv=none;
	b=kiT9zje01Iu4/4jIeUgoBuNQdD3DLtIF4gKeiqwhvjRnXavk7JGF4IFxiwdwVUFUXKM5ZR
	rAnaUXiMTIpEd/4w/ljGH3LTM20wjIbX+R6qW3WzzqlrImLQ5pN7+v4d1KkNVe9/aAVsB7
	yIOfbSpBDLn3bbWw+kwGaaCGbHFd910=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Vso5axNB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777969625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0wlFQn4mCAZ4JDf9m+1oTd5OJECuerm+FwCyUKdfn60=;
	b=Vso5axNB+D4rux7oxnvo5j1tQWC6m5l/6s1tzhlgvk/0XmDExLBh1w6xveCe4TJRMfy9Jc
	Ihb2v69GeKq3X7pA9ox31h3pdz3JfgOFQZT+6vt2bE7tQyOSKp/zvMt+HPOS07BBv8JUBk
	Bvbc6g9EQT2c4h8Ux/QS2IP8nGHxQGU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-350-GLXbQYrIOOmglOfO4CCSaw-1; Tue,
 05 May 2026 04:27:01 -0400
X-MC-Unique: GLXbQYrIOOmglOfO4CCSaw-1
X-Mimecast-MFC-AGG-ID: GLXbQYrIOOmglOfO4CCSaw_1777969618
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 045AA1956059;
	Tue,  5 May 2026 08:26:58 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.48.109])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC19C30001BE;
	Tue,  5 May 2026 08:26:45 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>,
	Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: [PATCH v9 10/10] x86/mm, mm/vmalloc: Defer kernel TLB flush IPIs when tracking CR3 switches
Date: Tue,  5 May 2026 10:23:55 +0200
Message-ID: <20260505082355.1982003-11-vschneid@redhat.com>
In-Reply-To: <20260505082355.1982003-1-vschneid@redhat.com>
References: <20260505082355.1982003-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: p46ERc19HXomJ8wZ0qh5v6nxPHExsUh1kG3GKHOKqQ0_1777969618
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E2E9318000A
X-Stat-Signature: xrodsrkanizf4k8kxbwbp6y4zy4rr5ui
X-Rspam-User: 
X-HE-Tag: 1777969625-479217
X-HE-Meta: U2FsdGVkX18HMFdPzw2uoPcFv4jIJ7qGv2uedF55h02bzIyrEDuRpiuLOUc6BE6MmQmzoPdISPojkq5Wb8uxQvcZrC2v3FuatE6dKYVHmhm+rKPR3egUz/6yqNJ4vhVVHtqUjVQKslhtq0MPEFLDjcRlqP7oyP7AuLby5IN4SHOXuUlH+c1yFzhVCr43FFURUaNHe5QcxYllrjz4psvCAnhhJxjXXbbqivRJ8qgfnJOH2W8l9xFdSiUzYoGtb0nHJ+knGaqE1UQj6Lu4Gw0ysBYDBnoWvSjMVE+fgeQnymMw3tLcGsLbhiEfyYOoSU3V5TsEsB1IK/BBL1KNAKeaazJDbTicNG/AAJFSuCF28aLfhvllcPE4Cv+bfsVY/VIGqBKcck1vwcHEFCOm6JhSEPEukUZcWHg8xL64ngYHnaTbfLEyuYvc2Kesot84Udx9F3YZMBhj0qQ8YSWBtQG/a5AaDBTh+x1iJSgz9fR+3MX1s6XPTjFLgnYPq5CLXFmwxon5XqQ0LXUpF6NrIBz+2weeRt1fFjS04I7/VO4ZaTqQmUGsk9a9JYHgZMNK8PJUnm1915um0+c+NpV9Vv/JIJnsYXijn5zxiGxyUPH3c+4SZMnIvFO+xkwYxj6a1IcPCLPOs/+kAWaH0NxR66BwIb3oLk6N9AdnuydcExJ9y7uX+3KCWMvX5Dc31HCdW84MZFbRTWBNj728LbR/lA1heBB4+Ests3m1zaRtH84/tIlcbtWqtZrU+JHlTAFn/e6OCCWlXltHxyCQA8pQMOL6X5+JBnRJUD8uyWfaekRncUkcSVsQ/BidhEpx1NVbRDCM0zKS6gOxpU1NH0Y2k8IppL9oQAMgHiWfNNhi7O4o2mOkxBaxgcEqSOJeHJpSpqCm/oFEsUgbFENMFXRDL0DCAUiaGFBS/cYhbhDLSyjOGmnLixLYqYEGfEt1Rsr1borTcpFX6ut8xCv3weqbfN9
 Y2wFwY9h
 9XUYzAUxJfQbOmngZVU8LO4wUb/7iFr9Ev4lfB+xN47mvq022yhCX6Fb4a6yMpxjKnu9WGLZDSOIRFZ+sU6k/85thrUoqajtDzexvAbu85KjnYfBsZaLOfsMbfiS6aNeP9Mwh07m1KNNKTf+d5bR6synCRlnswOKYfQalzFikxG4EK7KfSaQyGj+x71TLYzx+2U6VUkQsdzS4gXp0NDWjEl7nCr2wI4qNJ6RfOlMzq1CaQ9mkvBlfyjJtFC9hARw21M7KhBPy9s7qDpQi/dPwtWVfPc/sUmogcaWnRzjTOkgkr4gQ6R3+Yg8CkmFKDyEPVtxJiiUIObUE0FHMH2FSeOY8Pa/2HWoZdBh8rQ12TrtRF2kQWAQPqbqBnYjSUvOFaQJ/Hok/+wcofSGnidXALnez7KCncwuXizDC6cCb6a7MGeEF7WPjx6e2hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previous commits have added a software signal that tracks which CR3 (kernel
or user) is in use for any given CPU.

Combined with:
  o the CR3 switch itself being a flush for non-global mappings
  o global mappings under kPTI being limited to the CEA and entry text
we now have a way to safely defer (kernel) TLB flush IPIs targeting
NOHZ_FULL CPUs executing in userspace (i.e. with the user CR3 loaded).

When sending a kernel TLB flush IPI to a NOHZ_FULL CPU, check whether it is
using the user CR3, and if it is, do not interrupt it and instead rely on
the CR3 write that happens when switching to the kernel CR3.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/include/asm/tlbflush.h |  1 +
 arch/x86/mm/tlb.c               | 49 ++++++++++++++++++++++++++++-----
 mm/vmalloc.c                    | 30 ++++++++++++++++----
 3 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 0ec669eb0b4e7..824304c08cd95 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -22,6 +22,7 @@ DECLARE_PER_CPU_PAGE_ALIGNED(bool, kernel_cr3_loaded);
 #endif
 
 void __flush_tlb_all(void);
+void flush_tlb_kernel_range_deferrable(unsigned long start, unsigned long end);
 
 #define TLB_FLUSH_ALL	-1UL
 #define TLB_GENERATION_INVALID	0
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index af43d177087e7..68bcccace0659 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -13,6 +13,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/mmu_context.h>
 #include <linux/kvm_types.h>
+#include <linux/sched/isolation.h>
 
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
@@ -1509,23 +1510,24 @@ static void do_kernel_range_flush(void *info)
 		flush_tlb_one_kernel(addr);
 }
 
-static void kernel_tlb_flush_all(struct flush_tlb_info *info)
+static void kernel_tlb_flush_all(smp_cond_func_t cond, struct flush_tlb_info *info)
 {
 	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
 		invlpgb_flush_all();
 	else
-		on_each_cpu(do_flush_tlb_all, NULL, 1);
+		on_each_cpu_cond(cond, do_flush_tlb_all, NULL, 1);
 }
 
-static void kernel_tlb_flush_range(struct flush_tlb_info *info)
+static void kernel_tlb_flush_range(smp_cond_func_t cond, struct flush_tlb_info *info)
 {
 	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
 		invlpgb_kernel_range_flush(info);
 	else
-		on_each_cpu(do_kernel_range_flush, info, 1);
+		on_each_cpu_cond(cond, do_kernel_range_flush, info, 1);
 }
 
-void flush_tlb_kernel_range(unsigned long start, unsigned long end)
+static inline void
+__flush_tlb_kernel_range(smp_cond_func_t cond, unsigned long start, unsigned long end)
 {
 	struct flush_tlb_info *info;
 
@@ -1535,13 +1537,46 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 				  TLB_GENERATION_INVALID);
 
 	if (info->end == TLB_FLUSH_ALL)
-		kernel_tlb_flush_all(info);
+		kernel_tlb_flush_all(cond, info);
 	else
-		kernel_tlb_flush_range(info);
+		kernel_tlb_flush_range(cond, info);
 
 	put_flush_tlb_info();
 }
 
+void flush_tlb_kernel_range(unsigned long start, unsigned long end)
+{
+	__flush_tlb_kernel_range(NULL, start, end);
+}
+
+#ifdef CONFIG_TRACK_CR3
+static bool flush_tlb_kernel_cond(int cpu, void *info)
+{
+	/*
+	 * Send the IPI if the target CPU is a housekeeping one, or if it is
+	 * already executing in kernelspace.
+	 */
+	bool ret = housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE);
+
+	/*
+	 * Pairs with the LOCK in NOTE_KERNEL_CR3
+	 *
+	 * Ensures any previous operations are visible on a remote CPU
+	 * entering the kernel and setting @kernel_cr3_loaded, if this one
+	 * decides to defer the IPI.
+	 */
+	smp_mb();
+	ret |= per_cpu(kernel_cr3_loaded, cpu);
+
+	return ret;
+}
+
+void flush_tlb_kernel_range_deferrable(unsigned long start, unsigned long end)
+{
+	__flush_tlb_kernel_range(flush_tlb_kernel_cond, start, end);
+}
+#endif
+
 /*
  * This can be used from process context to figure out what the value of
  * CR3 is without needing to do a (slow) __read_cr3().
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index aa08651ec0df6..6276c8cb2be0d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -506,6 +506,26 @@ void vunmap_range_noflush(unsigned long start, unsigned long end)
 	__vunmap_range_noflush(start, end);
 }
 
+/*
+ * !!! BIG FAT WARNING !!!
+ *
+ * The CPU is free to cache any part of the paging hierarchy it wants at any
+ * time. It's also free to set accessed and dirty bits at any time, even for
+ * instructions that may never execute architecturally.
+ *
+ * This means that deferring a TLB flush affecting freed page-table-pages (IOW,
+ * keeping them in a CPU's paging hierarchy cache) is a recipe for disaster.
+ *
+ * This isn't a problem for deferral of TLB flushes in vmalloc, because
+ * page-table-pages used for vmap() mappings are never freed - see how
+ * __vunmap_range_noflush() walks the whole mapping but only clears the leaf PTEs.
+ * If this ever changes, TLB flush deferral will cause misery.
+ */
+void __weak flush_tlb_kernel_range_deferrable(unsigned long start, unsigned long end)
+{
+	flush_tlb_kernel_range(start, end);
+}
+
 /**
  * vunmap_range - unmap kernel virtual addresses
  * @addr: start of the VM area to unmap
@@ -519,7 +539,7 @@ void vunmap_range(unsigned long addr, unsigned long end)
 {
 	flush_cache_vunmap(addr, end);
 	vunmap_range_noflush(addr, end);
-	flush_tlb_kernel_range(addr, end);
+	flush_tlb_kernel_range_deferrable(addr, end);
 }
 
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
@@ -2373,7 +2393,7 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 
 	nr_purge_nodes = cpumask_weight(&purge_nodes);
 	if (nr_purge_nodes > 0) {
-		flush_tlb_kernel_range(start, end);
+		flush_tlb_kernel_range_deferrable(start, end);
 
 		/* One extra worker is per a lazy_max_pages() full set minus one. */
 		nr_purge_helpers = atomic_long_read(&vmap_lazy_nr) / lazy_max_pages();
@@ -2476,7 +2496,7 @@ static void free_unmap_vmap_area(struct vmap_area *va)
 	flush_cache_vunmap(va->va_start, va->va_end);
 	vunmap_range_noflush(va->va_start, va->va_end);
 	if (debug_pagealloc_enabled_static())
-		flush_tlb_kernel_range(va->va_start, va->va_end);
+		flush_tlb_kernel_range_deferrable(va->va_start, va->va_end);
 
 	free_vmap_area_noflush(va);
 }
@@ -2923,7 +2943,7 @@ static void vb_free(unsigned long addr, unsigned long size)
 	vunmap_range_noflush(addr, addr + size);
 
 	if (debug_pagealloc_enabled_static())
-		flush_tlb_kernel_range(addr, addr + size);
+		flush_tlb_kernel_range_deferrable(addr, addr + size);
 
 	spin_lock(&vb->lock);
 
@@ -2988,7 +3008,7 @@ static void _vm_unmap_aliases(unsigned long start, unsigned long end, int flush)
 	free_purged_blocks(&purge_list);
 
 	if (!__purge_vmap_area_lazy(start, end, false) && flush)
-		flush_tlb_kernel_range(start, end);
+		flush_tlb_kernel_range_deferrable(start, end);
 	mutex_unlock(&vmap_purge_lock);
 }
 
-- 
2.52.0


