Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6299ACCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A56C8E0042; Fri, 10 Oct 2025 11:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D108E002C; Fri, 10 Oct 2025 11:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C5A8E0042; Fri, 10 Oct 2025 11:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 634F88E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:48:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28CC1160371
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:48:14 +0000 (UTC)
X-FDA: 83982636108.21.58D3A67
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 353FD80018
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:48:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VgdqPA5m;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760111292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cbj4zp7uSZx/T4/nBfgioKWu9VmcYJpiOH4O825NldU=;
	b=1B+7ULvckzkyZYpy8V2XCh3ONOLwVap4BvRm49TtcCjG0BZyquA2MAEi97l6PxBf+U9Jfn
	2BK8PU7vkwtVzP8tGRrVxN8XuLqsCFGTM0ZzHdFKpxnALpgHUio+sbMghnIUfIrWlgizSM
	VMSh7eC766hbHjt31I78VAwUtnFfVFQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760111292; a=rsa-sha256;
	cv=none;
	b=d/JZWIIEyvT8EvLXzDxX/Y4+D6KEx75VnXkbNo8RN/s08EA+DtP3Y5b1ZAJCdPFxyZdYoo
	79hf2LF6Ypkhl1J+e5Z++JsqG1+cqoiXMLp23/XpsUwcf1zXC/ZfY5J37jfGdfkPOOQidR
	GKY/xM9XnydandyfUikqr1Xk/3XbGfU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VgdqPA5m;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760111291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cbj4zp7uSZx/T4/nBfgioKWu9VmcYJpiOH4O825NldU=;
	b=VgdqPA5miIZwlKlDdZdgV2hJ4op7Uma0/6zG4Rq0opbEPD7aOYofiynXWQsg8umLRu6zCh
	p9ZNT9EP1p4BL3+MXoB7KKZxRUaK4NB5VlJcuppFYVgh/WDvY2n3w9p9+Y1uwYItxm2szY
	UxHR9YWArVLSiPC5hOuCTjWiEZHuq+s=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-78-vBNA1yILN1WPT3ArJUl3tA-1; Fri,
 10 Oct 2025 11:48:07 -0400
X-MC-Unique: vBNA1yILN1WPT3ArJUl3tA-1
X-Mimecast-MFC-AGG-ID: vBNA1yILN1WPT3ArJUl3tA_1760111281
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 509861800452;
	Fri, 10 Oct 2025 15:48:01 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.45.224.29])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98E831800576;
	Fri, 10 Oct 2025 15:47:46 +0000 (UTC)
From: Valentin Schneider <vschneid@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
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
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>,
	Petr Tesarik <ptesarik@suse.com>
Subject: [RFC PATCH v6 28/29] x86/mm, mm/vmalloc: Defer kernel TLB flush IPIs under CONFIG_COALESCE_TLBI=y
Date: Fri, 10 Oct 2025 17:38:38 +0200
Message-ID: <20251010153839.151763-29-vschneid@redhat.com>
In-Reply-To: <20251010153839.151763-1-vschneid@redhat.com>
References: <20251010153839.151763-1-vschneid@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam01
X-Stat-Signature: b3c5m6sqnhrpjk7y1uxdpw8d7qmxqwy6
X-Rspam-User: 
X-Rspamd-Queue-Id: 353FD80018
X-HE-Tag: 1760111292-660254
X-HE-Meta: U2FsdGVkX1/LV2VaBch9XM23HshNE63fuTggaO4ElOYApkl2TDyk4VCxe2C3OnfOmi5nt+D79D/mZHD357bWKlxXzZ4LmA3Ax3HExqAtnPVdER5ZLgJFezvRDWGZv5a7V+rYUVvFjDLYXHmxFNS496u7QG/zfmnEKU3EdVyeJ6X0D6OmvoffKJ+kjhziawGN3Bmsc6dRWvG29CagLH5fHWeuxgZO35wNmUOPEZ0KHKZmSLyjxClW/vHvXbNPHLM2BmhR6oKoSX5WHrgE2AtBdZCOxUyHlZgnOHTLNSM7C3p1FtpSpVj+vIyEJM/1Z0mCeq13DO37qlFhojVF0/n5JQmXgxGMHes3gD1wM4uKDsxRY7xc1HZ8Cw4DuKxn4PtYIzb2rvKdFt0iiQ8oBDOmUZCDpvshbNbna6NiAVDlXO/WlolLvjiWtJfP9b15MD5PocUKM9GKTDYAgNLOwGWr4A4Q4YytSovaZ72cjR8ZBTCAaFAH7ENqHEAFNtojC8u+uLuuhQMHEOVzqkyHOBH82tEqInuXBtXnO+vj1BBOE5wBIVwBH3R5SeWJ7sRPCUo1hzzaQi4tFML+OG3y2FRbNXsSD/tB3GuAgh10ZRCfe/kgy+n6dENYCAAPMPtXS5ievS+qA7ZUQuApDQTtQRROf9KFaAD3q1job54uVEyMm5hgqGr7BlVq97EdZWgqNKB+eNKbI4LyG5K9VS02zLasbsxRDSAfS3Sn+gzQ996tZy2wAE+Dg9jh1BLprG+h7t+0VotvGuxxEG4cFqtrR/qKON1gywa/KS+wHXpHUGmE9Wah8hQMt4bU+jaaYcRg5XCBXr8NdLY5M0vp5IdKkST6UAXlUJilYMHrsGPF/o4CH3TvT7iF12KSwtn8LVVBFqnGCoVWUEEUA5RJDNN5ylq1bIGEnMq48EVH9GLi7n9yFpNu96h7lXlykhWacr7dEMwE2l6WJWmVPtRIc8RMEDu
 4nmlUXLT
 0bWsud2BxDJXsmOZLuamD8ISC21oHHTw8vXorBya4MCDrEFzv4FDjdJL+PdaPTAW+UnnHNah0Ebo93gsYK4kNByxDyDWzngMmxG1mK8dxDJ3H01yUSB2rbcHnJ29Rj5E7eUnHTJ91zNVoilBnNCajks3EY4NIPsN/3Tk1Awdju1D9gMA5TO9T+94k3bxUlu55xKyauDdRVfYudvVdCCLOqBZSnK4sCz9wfhfnjyxMGS0hNpZG+69M/dtrwhp/DLSJcIjr44hJe98udWNnt44/7ibiIV8ES8m3BUJCPAXffAtLh3D7uOn1OmDd363VvK763omv8En+AdxBb7F37eI+eer9JbMNDdQHS/73jMm4JwvFkYSW9n26Li1pk7weP6/PujfGoaKU4/UXzlwndOIs9FVgZyJ2/K8Kb0kgzR7JHH1beKFq++fSAbGsf3VLm0NBZsejkc65lJQ8kg8dQEU0TXtKlqb+ByVGYTDR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previous commits have added an unconditional TLB flush right after
switching to the kernel CR3 on NOHZ_FULL CPUs, and a software signal to
determine whether a CPU has its kernel CR3 loaded.

Using these two components, we can now safely defer kernel TLB flush IPIs
targeting NOHZ_FULL CPUs executing in userspace (i.e. with the user CR3
loaded).

Note that the COALESCE_TLBI config option is introduced in a later commit,
when the whole feature is implemented.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
---
 arch/x86/include/asm/tlbflush.h |  3 +++
 arch/x86/mm/tlb.c               | 34 ++++++++++++++++++++++++++-------
 mm/vmalloc.c                    | 34 ++++++++++++++++++++++++++++-----
 3 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index e39ae95b85072..6d533afd70952 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -321,6 +321,9 @@ extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
				unsigned long end, unsigned int stride_shift,
				bool freed_tables);
 extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
+#ifdef CONFIG_COALESCE_TLBI
+extern void flush_tlb_kernel_range_deferrable(unsigned long start, unsigned long end);
+#endif

 static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned long a)
 {
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 39f80111e6f17..aa3a83d5eccc2 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -12,6 +12,7 @@
 #include <linux/task_work.h>
 #include <linux/mmu_notifier.h>
 #include <linux/mmu_context.h>
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

@@ -1535,13 +1537,31 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
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
+#ifdef CONFIG_COALESCE_TLBI
+static bool flush_tlb_kernel_cond(int cpu, void *info)
+{
+	return housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE) ||
+	       per_cpu(kernel_cr3_loaded, cpu);
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
index 5edd536ba9d2a..c42f413a7a693 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -494,6 +494,30 @@ void vunmap_range_noflush(unsigned long start, unsigned long end)
	__vunmap_range_noflush(start, end);
 }

+#ifdef CONFIG_COALESCE_TLBI
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
+#else
+#define flush_tlb_kernel_range_deferrable(start, end) flush_tlb_kernel_range(start, end)
+#endif
+
 /**
  * vunmap_range - unmap kernel virtual addresses
  * @addr: start of the VM area to unmap
@@ -507,7 +531,7 @@ void vunmap_range(unsigned long addr, unsigned long end)
 {
	flush_cache_vunmap(addr, end);
	vunmap_range_noflush(addr, end);
-	flush_tlb_kernel_range(addr, end);
+	flush_tlb_kernel_range_deferrable(addr, end);
 }

 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
@@ -2333,7 +2357,7 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,

	nr_purge_nodes = cpumask_weight(&purge_nodes);
	if (nr_purge_nodes > 0) {
-		flush_tlb_kernel_range(start, end);
+		flush_tlb_kernel_range_deferrable(start, end);

		/* One extra worker is per a lazy_max_pages() full set minus one. */
		nr_purge_helpers = atomic_long_read(&vmap_lazy_nr) / lazy_max_pages();
@@ -2436,7 +2460,7 @@ static void free_unmap_vmap_area(struct vmap_area *va)
	flush_cache_vunmap(va->va_start, va->va_end);
	vunmap_range_noflush(va->va_start, va->va_end);
	if (debug_pagealloc_enabled_static())
-		flush_tlb_kernel_range(va->va_start, va->va_end);
+		flush_tlb_kernel_range_deferrable(va->va_start, va->va_end);

	free_vmap_area_noflush(va);
 }
@@ -2884,7 +2908,7 @@ static void vb_free(unsigned long addr, unsigned long size)
	vunmap_range_noflush(addr, addr + size);

	if (debug_pagealloc_enabled_static())
-		flush_tlb_kernel_range(addr, addr + size);
+		flush_tlb_kernel_range_deferrable(addr, addr + size);

	spin_lock(&vb->lock);

@@ -2949,7 +2973,7 @@ static void _vm_unmap_aliases(unsigned long start, unsigned long end, int flush)
	free_purged_blocks(&purge_list);

	if (!__purge_vmap_area_lazy(start, end, false) && flush)
-		flush_tlb_kernel_range(start, end);
+		flush_tlb_kernel_range_deferrable(start, end);
	mutex_unlock(&vmap_purge_lock);
 }

--
2.51.0


