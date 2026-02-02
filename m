Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5115BD172B0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 07:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94FEB6B008A; Mon,  2 Feb 2026 02:46:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA1E6B008C; Mon,  2 Feb 2026 02:46:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC566B0092; Mon,  2 Feb 2026 02:46:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB9D6B008A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 02:46:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3BDE9C2EA7
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:46:53 +0000 (UTC)
X-FDA: 84398735106.12.FF23153
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 871131C0006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:46:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cW0CtRIc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770018411; a=rsa-sha256;
	cv=none;
	b=TSZwu75MxMUoi2m4h+jikv4dVYHpOm0594/cBi0HuvbU0xp8l7UDGvXVucQsQBsvPSRgD4
	yvvWqSs9KK+W1Uv34vNZJZTsvI+igA9JCbkOcwgfj7wbyjBJZqkOEB3NTZ/dtlK1g/oWyY
	QBfTF/gEXox5//9PaBz6k04FHmlVldE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cW0CtRIc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770018411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mXujEoUNJu/9Snvd8x+7m65uywslfWR8iRUR5pLoVkA=;
	b=jhZHO6ZqPxWiMbvq5MxsJnufnmaO4fk9NYylC2RebQ2aEgszextpwgegUZyoArU8PhRaJ8
	hWi4jbiRjT3OMTY1bSuXMTI9SzEkdZVt/M/weJDAyASaO6qhNEUKBi9W0uyQLnU+ph0wFX
	owHlUU/TLQO4OgnNv6kV4IuEtmdESYs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770018409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mXujEoUNJu/9Snvd8x+7m65uywslfWR8iRUR5pLoVkA=;
	b=cW0CtRIcjlR+qdoXFn119hjFWn+vND51Hyj4B41JaZPny8AjoqmKIVlA4gNWteWp+dwdzx
	j6EC7U2UCzrH+Pb/QiYdVzDcwSX6Bix3qjBtySHKO3q2V9suSogN/DMCXgL98TwMFAcQ3u
	XBzs+aQ64ejZ7FphjlXzvoAti/LumqA=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	jgross@suse.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v4 1/3] mm: use targeted IPIs for TLB sync with lockless page table walkers
Date: Mon,  2 Feb 2026 15:45:55 +0800
Message-ID: <20260202074557.16544-2-lance.yang@linux.dev>
In-Reply-To: <20260202074557.16544-1-lance.yang@linux.dev>
References: <20260202074557.16544-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 871131C0006
X-Stat-Signature: gnbni7diwg6s3qcsddns6zpshm91giq5
X-HE-Tag: 1770018411-672526
X-HE-Meta: U2FsdGVkX19mnImZvmnp/ffyjrYiL64u7eo/q+uGnpOC9nXHrcW58SXe/nePYtrH0SkQcALQK7e0FSw13igs8oJDAYcyQHkf+0OfJlRIucXuLTN+4iZGIiqBBe77k/ll/YOcNZsknOv4gNEwU21de+xd2FlWZ0ZWPoWYJG5NWQwkSKI1qvSGn5vMOeDVc5ePLr1FzIpPShSjp1ZOmYjLKNh0TqQR5NuqN3+kKmYuRxb03S4or7qPRZDF9eixqd7d1BMv4fDjvPxoY1c6A9PkLI25fDuf86/wObtaWiwHz0p2DnuQzuvoILFCYaGnuTrdmxyoQ9nSC1FQ6+Jfb9JGKX/3gnqPWhy41UEwac0xy66fx9lxZytehiyodrWYEchjPKhaSrNsFPLBAc3eL/d5kVfc0bCwhzN4NoZhfHrWpA1xhsIyS3HH40FSkV4oYgPOOfRasH/vfrIRrg08/BrjoxDWN0j0XajzsUBVNEq9aqNnse5SbZNPlGMRspr5rI63y4kSt2JZPbmNmTrbMGf8lUc9WdUlfkTgjnFQEizJonu/1Sh3jEdiqdTGuYG6f/ZE4xKEXSdXa47Qi2X07PVDHQxqwArVxQcQ2LWlvp6vdE0vyZMfedeAsOg6lEsi8RZ65bYHdg25gd3cbwFxDBF5aW3roi8Wf/TEr4jPuu3iy/rbhPyHDPFMFGrtGh9/L3jKMs9+MiZHcFDINNf3kxkVhMS2ay/c3GnKNU+1gRBb0rvNbMey7zczuT46Ns4jZB6TLgHIj5bvdAWMdnPNcjmaw2nurZsH1wgOkIjYwAQoGreS9qLo+4jCv2MCErv4ypwSpQUkm9EJnlp9a7PpPZONHT3OuaEX97TTNCc7f2s6CqyLXRtFiz4FbZyga8dQzTuJaWxjLS+0ycy0QA3ovXRDx/fZh3vl6OFFy1IfNsgtXfPIG9PIQY5BnALhlayLLutzQEiYtbvartQhJ8bs+pl
 XsWPK07F
 rI6SJVWAtPqqyM3Em7ANgA54TWLxRvCVlDYK51bAH6LALi9TEI7tRIB4mUAO+lA/kgTdbEbZrV4EdFQs1JJO2eqoE//5BvOPqozVoDRJAvW+KWZYqKxtpRWTVM0Iyu/Q2xAnSSSfsm3RLZwoMt4G+bAa4BeMhJs6R67qElHPg7IrdshsurphdY5+V90Br8jExCmBWxrWo72csVyQdawHlpzPqTY9nEAc50spe+k3vypIvjnVbd1iLxp31huqYcyjm3a3u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Currently, tlb_remove_table_sync_one() broadcasts IPIs to all CPUs to wait
for any concurrent lockless page table walkers (e.g., GUP-fast). This is
inefficient on systems with many CPUs, especially for RT workloads[1].

This patch introduces a per-CPU tracking mechanism to record which CPUs are
actively performing lockless page table walks for a specific mm_struct.
When freeing/unsharing page tables, we can now send IPIs only to the CPUs
that are actually walking that mm, instead of broadcasting to all CPUs.

In preparation for targeted IPIs; a follow-up will switch callers to
tlb_remove_table_sync_mm().

Note that the tracking adds ~3% latency to GUP-fast, as measured on a
64-core system.

[1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/asm-generic/tlb.h |  2 ++
 include/linux/mm.h        | 34 ++++++++++++++++++++++++++
 kernel/events/core.c      |  2 ++
 mm/gup.c                  |  2 ++
 mm/mmu_gather.c           | 50 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 90 insertions(+)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 4aeac0c3d3f0..b6b06e6b879f 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -250,6 +250,7 @@ static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
 #endif
 
 void tlb_remove_table_sync_one(void);
+void tlb_remove_table_sync_mm(struct mm_struct *mm);
 
 #else
 
@@ -258,6 +259,7 @@ void tlb_remove_table_sync_one(void);
 #endif
 
 static inline void tlb_remove_table_sync_one(void) { }
+static inline void tlb_remove_table_sync_mm(struct mm_struct *mm) { }
 
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f8a8fd47399c..d92df995fcd1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2995,6 +2995,40 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 		      pgoff_t *offset);
 int folio_add_pins(struct folio *folio, unsigned int pins);
 
+/*
+ * Track CPUs doing lockless page table walks to avoid broadcast IPIs
+ * during TLB flushes.
+ */
+DECLARE_PER_CPU(struct mm_struct *, active_lockless_pt_walk_mm);
+
+static inline void pt_walk_lockless_start(struct mm_struct *mm)
+{
+	lockdep_assert_irqs_disabled();
+
+	/*
+	 * Tell other CPUs we're doing lockless page table walk.
+	 *
+	 * Full barrier needed to prevent page table reads from being
+	 * reordered before this write.
+	 *
+	 * Pairs with smp_rmb() in tlb_remove_table_sync_mm().
+	 */
+	this_cpu_write(active_lockless_pt_walk_mm, mm);
+	smp_mb();
+}
+
+static inline void pt_walk_lockless_end(void)
+{
+	lockdep_assert_irqs_disabled();
+
+	/*
+	 * Clear the pointer so other CPUs no longer see this CPU as walking
+	 * the mm. Use smp_store_release to ensure page table reads complete
+	 * before the clear is visible to other CPUs.
+	 */
+	smp_store_release(this_cpu_ptr(&active_lockless_pt_walk_mm), NULL);
+}
+
 int get_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages);
 int pin_user_pages_fast(unsigned long start, int nr_pages,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5b5cb620499e..6539112c28ff 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8190,7 +8190,9 @@ static u64 perf_get_page_size(unsigned long addr)
 		mm = &init_mm;
 	}
 
+	pt_walk_lockless_start(mm);
 	size = perf_get_pgtable_size(mm, addr);
+	pt_walk_lockless_end();
 
 	local_irq_restore(flags);
 
diff --git a/mm/gup.c b/mm/gup.c
index 8e7dc2c6ee73..6748e28b27f2 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3154,7 +3154,9 @@ static unsigned long gup_fast(unsigned long start, unsigned long end,
 	 * that come from callers of tlb_remove_table_sync_one().
 	 */
 	local_irq_save(flags);
+	pt_walk_lockless_start(current->mm);
 	gup_fast_pgd_range(start, end, gup_flags, pages, &nr_pinned);
+	pt_walk_lockless_end();
 	local_irq_restore(flags);
 
 	/*
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 2faa23d7f8d4..35c89e4b6230 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -285,6 +285,56 @@ void tlb_remove_table_sync_one(void)
 	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
 }
 
+DEFINE_PER_CPU(struct mm_struct *, active_lockless_pt_walk_mm);
+EXPORT_PER_CPU_SYMBOL_GPL(active_lockless_pt_walk_mm);
+
+/**
+ * tlb_remove_table_sync_mm - send IPIs to CPUs doing lockless page table
+ * walk for @mm
+ *
+ * @mm: target mm; only CPUs walking this mm get an IPI.
+ *
+ * Like tlb_remove_table_sync_one() but only targets CPUs in
+ * active_lockless_pt_walk_mm.
+ */
+void tlb_remove_table_sync_mm(struct mm_struct *mm)
+{
+	cpumask_var_t target_cpus;
+	bool found_any = false;
+	int cpu;
+
+	if (WARN_ONCE(!mm, "NULL mm in %s\n", __func__)) {
+		tlb_remove_table_sync_one();
+		return;
+	}
+
+	/* If we can't, fall back to broadcast. */
+	if (!alloc_cpumask_var(&target_cpus, GFP_ATOMIC)) {
+		tlb_remove_table_sync_one();
+		return;
+	}
+
+	cpumask_clear(target_cpus);
+
+	/* Pairs with smp_mb() in pt_walk_lockless_start(). */
+	smp_rmb();
+
+	/* Find CPUs doing lockless page table walks for this mm */
+	for_each_online_cpu(cpu) {
+		if (per_cpu(active_lockless_pt_walk_mm, cpu) == mm) {
+			cpumask_set_cpu(cpu, target_cpus);
+			found_any = true;
+		}
+	}
+
+	/* Only send IPIs to CPUs actually doing lockless walks */
+	if (found_any)
+		smp_call_function_many(target_cpus, tlb_remove_table_smp_sync,
+				       NULL, 1);
+
+	free_cpumask_var(target_cpus);
+}
+
 static void tlb_remove_table_rcu(struct rcu_head *head)
 {
 	__tlb_remove_table_free(container_of(head, struct mmu_table_batch, rcu));
-- 
2.49.0


