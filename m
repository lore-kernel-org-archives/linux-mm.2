Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D9DE9A754
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 09:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107AD6B00A3; Tue, 24 Mar 2026 05:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DEB16B00A5; Tue, 24 Mar 2026 05:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F362D6B00A6; Tue, 24 Mar 2026 05:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB0996B00A3
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:51:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7715CD0577
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:51:16 +0000 (UTC)
X-FDA: 84580488552.09.902245B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6818918000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:51:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Orv0iXJ0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774345874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rz+xHMp39eTKGjjZlITwEBRnQcSaPN2YegGdzhgHICw=;
	b=YFwEJfPVvJK2hsq5C/ng4E2NSWyK3bKDDghxTgL/CkarD7E4yXnssbFI+vVr2mjPCYCoxg
	6bB9IqiwFH2M3z+qd+w6VgMKfj/goCgVrf/RsveNuiLfszd29QPbKjrCr0nkg+TEY1JYIs
	fc914eYXwF8cuqDLXmbu9dcm1HVu96c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774345874; a=rsa-sha256;
	cv=none;
	b=Nv5YlcgMdYN82hmfHxXibt5Y2msN1boiFVB0D4MOBsrGR9bz+Zn4tukRQ/mla+6sKCT5+j
	PExuwu9rmypo9Tt4TnK7sk2/6RG5JH2L2jb1CWb4iuSSakn147b3/jsP2r6a101C+J4km2
	87tIuGR7w9g6N7rb5EeegDxb019gJEA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Orv0iXJ0;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of vschneid@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774345873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rz+xHMp39eTKGjjZlITwEBRnQcSaPN2YegGdzhgHICw=;
	b=Orv0iXJ0MYr9Dh13Gp5/Xj2+9VUlphQFoULcOBi/jGtGMD/l8PwZSBlG91Smo8oJMmZlBq
	IUTkWYmo19pNXmrpiDCCELqNNm5dLmi/2pHeeONNG+lA6/1YUx+fC991/jMQZvEF3w7mZq
	+19ReQbedIaPUBWpvxbEeAMVkLcf6g0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-wNsf_mUJN3imxGWVyKna5w-1; Tue,
 24 Mar 2026 05:51:06 -0400
X-MC-Unique: wNsf_mUJN3imxGWVyKna5w-1
X-Mimecast-MFC-AGG-ID: wNsf_mUJN3imxGWVyKna5w_1774345862
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A46981955F18;
	Tue, 24 Mar 2026 09:51:02 +0000 (UTC)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (unknown [10.44.34.246])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20CBD300019F;
	Tue, 24 Mar 2026 09:50:50 +0000 (UTC)
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
Subject: [RFC PATCH v8 10/10] x86/mm, mm/vmalloc: Defer kernel TLB flush IPIs when tracking CR3 switches
Date: Tue, 24 Mar 2026 10:48:01 +0100
Message-ID: <20260324094801.3092968-11-vschneid@redhat.com>
In-Reply-To: <20260324094801.3092968-1-vschneid@redhat.com>
References: <20260324094801.3092968-1-vschneid@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Ru4w655j75HWsGFXFaXpZWIhOPtzhBRV3YvG26VHRMU_1774345862
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 6818918000E
X-Stat-Signature: ictkcoaudob8ordqkteq1kbaxhrjkwp4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774345874-919232
X-HE-Meta: U2FsdGVkX18CefL3uA9vHN5gPLJfXJouh3wwAM4PkAIrIpvfgl4x8d3JgcyzL5yYf3JeS0uawsv4gon7O9IEC17ZmRIrul3X5Fba8AfpyjZAT98bQd5/N/ruEmW8lmsaoIlP5qXmP5+180w3ZaXu8mds4UeP3PCZeNX1VApLbVspZ6hGVK78kLL7hscI2GvHfCUwAkdf0hjoGHxYWHwDGPuDFZayxq4RxoqsWGQLI+DdbFwcdFGKYiCMiLVgww8Ebspide6WdabD8Z0cj2WBeGC9myyY4vV1u/vXGgEYFPwxZzo8yqroaKjPwon1C0wQjs7EI/RxxrvTOn57ZjjH93Mbcx16qf/sNfm4ZwCFwGXfPfpikG4bNdzHxrsDj/zp7PThHLsiUWr8K7o5VTVeKbsrXro4BAfduIp4ok9oZc+d8F89V1g4yotyF2a6MHDwqmf3LeF1HMxBrgtAa0dA1gL8ULxduXxL8leEeX5duzWfrVSiDmRpg5j9DHW52xkxVWef8yUrGstmim6+i4Sjvh6NxPBB6/5es+1Q8zRNOTZ5MxG0gjoGQsJs+w6QhmBCcXgwHY7ObLe8dcFUjrm8wBHjtps0Q/8N7B4sbmOhLXKinDQEA9MEn0Lnk4VfQca4yPSyBa+m3tyrVlS601UwldqLwQIOOYGqNHSanshO3pfz35Btk0u8SqzELcfQMHjxp07MZg0XJlAw5zFmnLb3LmJvt2A92tpHbuN8x+M/Bxxhzxe8jNw2i/PUephYNxc7LSTyGR/q6FNaqxqUa3oCvHVAp3XetElr5RcZ+HzENDPQ1N3vRKgtlCaF0i+orbj86+nOPg9enKhSLMaIvRUGp/h1jgi7mSgK8tkQ0KCd7fsCPxAtCcSvwj6YW/dMYAqIY3HITnTcYqMszyHJJuR0SiSQzQZI+dBZzTBz/INMyl+1tBIaB+G775IeS6J2eU3TMvIDdfjwL6GeSS69a0c
 IKw4FXnw
 Ng9kPzkwf6cBrlUi67nRkBVv8py344PWazJvx02XKWAt6eMc2X/H+RDYnwQrxh/JgUtTn1KEcWWh4eb+cAXCUZxjwJnd1WfWZ1M4YX78H+RZqudLI+Xi4DfG2pkcJQIM3ghGIhrmK5v167L994dMFvnPb+L+BensxpkToOrAOWDIFyQPbY/z/vv46f502tfCXNdxhcYEwRkZowKkWWaPDIiMR2b9gHcNbohY2voN8hd92dP06OMhgGB0Z+xwKniK0n2soAB7BmmYEW+h2h922wpEq5j1tIL5vAhVag9MRgwlXic7UsnXUQE5Bihrb/kN1nozmcPuz1tMij0CjAvhUvN6DxvywAh6/anf2cKS+Ufi6jhE91A5hjdYNuCn49gry1uoqx91oTmZ28M1dbUkyHK45sDXKU4MfT6AasXaWKFte3sHsMYw/2w2Uyw==
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
 arch/x86/mm/tlb.c               | 34 ++++++++++++++++++++++++++-------
 mm/vmalloc.c                    | 30 ++++++++++++++++++++++++-----
 3 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 3b3aceee701e6..8bae150206665 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -22,6 +22,7 @@ DECLARE_PER_CPU_PAGE_ALIGNED(bool, kernel_cr3_loaded);
 #endif
 
 void __flush_tlb_all(void);
+void flush_tlb_kernel_range_deferrable(unsigned long start, unsigned long end);
 
 #define TLB_FLUSH_ALL	-1UL
 #define TLB_GENERATION_INVALID	0
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index f5b93e01e3472..e08f16474f074 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -13,6 +13,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/mmu_context.h>
 #include <linux/kvm_types.h>
+#include <linux/sched/isolation.h>
 
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
@@ -1530,23 +1531,24 @@ static void do_kernel_range_flush(void *info)
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
 
@@ -1556,13 +1558,31 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
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
index e286c2d2068cb..55b7bafe26016 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -501,6 +501,26 @@ void vunmap_range_noflush(unsigned long start, unsigned long end)
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
@@ -514,7 +534,7 @@ void vunmap_range(unsigned long addr, unsigned long end)
 {
 	flush_cache_vunmap(addr, end);
 	vunmap_range_noflush(addr, end);
-	flush_tlb_kernel_range(addr, end);
+	flush_tlb_kernel_range_deferrable(addr, end);
 }
 
 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
@@ -2366,7 +2386,7 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 
 	nr_purge_nodes = cpumask_weight(&purge_nodes);
 	if (nr_purge_nodes > 0) {
-		flush_tlb_kernel_range(start, end);
+		flush_tlb_kernel_range_deferrable(start, end);
 
 		/* One extra worker is per a lazy_max_pages() full set minus one. */
 		nr_purge_helpers = atomic_long_read(&vmap_lazy_nr) / lazy_max_pages();
@@ -2469,7 +2489,7 @@ static void free_unmap_vmap_area(struct vmap_area *va)
 	flush_cache_vunmap(va->va_start, va->va_end);
 	vunmap_range_noflush(va->va_start, va->va_end);
 	if (debug_pagealloc_enabled_static())
-		flush_tlb_kernel_range(va->va_start, va->va_end);
+		flush_tlb_kernel_range_deferrable(va->va_start, va->va_end);
 
 	free_vmap_area_noflush(va);
 }
@@ -2916,7 +2936,7 @@ static void vb_free(unsigned long addr, unsigned long size)
 	vunmap_range_noflush(addr, addr + size);
 
 	if (debug_pagealloc_enabled_static())
-		flush_tlb_kernel_range(addr, addr + size);
+		flush_tlb_kernel_range_deferrable(addr, addr + size);
 
 	spin_lock(&vb->lock);
 
@@ -2981,7 +3001,7 @@ static void _vm_unmap_aliases(unsigned long start, unsigned long end, int flush)
 	free_purged_blocks(&purge_list);
 
 	if (!__purge_vmap_area_lazy(start, end, false) && flush)
-		flush_tlb_kernel_range(start, end);
+		flush_tlb_kernel_range_deferrable(start, end);
 	mutex_unlock(&vmap_purge_lock);
 }
 
-- 
2.52.0


