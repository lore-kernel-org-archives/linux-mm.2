Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFC3A60A5BC7
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hYXjCm8k
Received: by kanga.kvack.org (Postfix)
	id 050266B05C1; Tue, 10 Nov 2026 06:25:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027776B05C3; Tue, 10 Nov 2026 06:25:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32F16B05C4; Tue, 10 Nov 2026 06:25:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B279E6B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:25:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 483F34059D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:25 +0000 (UTC)
X-FDA: 85418978610.14.3F07037
Received: from mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 590EC180002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hYXjCm8k;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGuw/QaT9bXrIXgqPHG9JcolkC+qxMvqtKQSI6lWxKs=;
	b=2T6OAzcokv2jV2s02d8IapxPNQWrWiwP1wW4C/6Svh+J/ObsWnUqpz4Jhe1LhUpK8hbd2e
	Imwp4mJP/UXplmbqEPwt+R7Yrt4Qm1oyi54Y9lMoN31idlx0s/73zeQhl/ntjc9zYCX3Gu
	RCDjqacXPisyfCDpj56KtdGSQmZzw/c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hYXjCm8k;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309923;
	b=l7VBeICPF5xc0qhfxVaTDMUaWvK8Y5nHOH2zb3DfrKeAqgzxWt+1WQ4tyMcjU2QQBVaTKu
	dIpgsj4Q8JnZjRFXFm4cMGg38yqe8a6CtqAQ3IG/dTreZHAp3h9OMeCD2i48nnn+aik/hx
	ryAkRShNUZyUT8fEf6HF5nGCqx72reU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7uxwHQYlw6xfNJkuwND6/NfRHibmOvz7JrhIzprdUuo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794309922; v=1; x=1794914722;
 b=hYXjCm8k4Lgevpen0G5Qte+VRdIDu6mmNHVBej+4KJucn9QmrhIx/AANavre0axRdMYVM7eL
 NQforNUOJYVSHgwn/RLMaB+u9jq7QDak8rUvTXOPz0BIs3fMMEfn+oTUxNTy7wKJSzBcO+PMGAR
 3woDA+m6SqlWks66DYez6FC4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e708897efeb614eb;
	Tue, 10 Nov 2026 11:25:18 +0000
X-Mizu-Trace-ID: e708897efeb614eb
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v4 7/9] mm/vmalloc: undo partial mappings inside the mapping functions
Date: Tue, 10 Nov 2026 19:25:44 +0800
Message-Id: <20261110112546.261415-8-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261110112546.261415-1-hao.ge@linux.dev>
References: <20261110112546.261415-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 590EC180002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5yaok51n57qz3aiwmawqnmzppnwimdfd
X-HE-Tag: 1794309923-73077
X-HE-Meta: U2FsdGVkX1+pCZdS7hwsAUfkKPhowr/0NuqG7QUDlpriJ2CFRQIkjZdlsSbyn/IqfuFnUsBuEP7EGIE+xkhol5ovNH0Zjvdp8fnHBmGHNPcjvI6gMUdmmIiWMku2pH3gJgJ+zC2BYYMCjmGIeqr2CEX6NQpdewGz3Yh/LPOfROsyJEZTfaLja/oVPRBRKoPycUVtiNVcVHpNJllDcKyIp2Q1DQFnJajVoHtmo31KF7tV7oJcUlGfGK7FHrc9ZefzQ90VpS5qn4O2tl2FzP1Vreq5Zfnb59vfeHSS0dxJ2XTqhycTDLTA7xo90bJMa0QpTFNgmx72ei0qNXWWuoNYFe1LGCTAQInkQtAkoWsDppggZDzjT+CEfatl3o/6XgakLNj6L1AHJXJFBPf92XnkGEaYbQhi8dLp2D5ru9xKx21T1l6HwQ5+bKCuxzTeTNvPyHlHg6uvkwpkFqXCera8M1iZ1+JWi0kQ5d/bCuSjNcpyAdeuTK4Gsvr4NfN3XsrQpcJ5xjKBmJRkPskKyBhEr/ww/YsEYcfREsdespy0kNm2Xt7lI0h3OD6GrGi1iB0jokB7oSuOQgLQWcEp+g4UCC8ttbgo/lbb7y1JdCYIFN75o4kh+b4uWBzEPkKEPhDTY0VIMrQajaYhEFdWUe/6DTgix8LQWNsUVR4wIh5SBFKJPGACKmhomEi3Cz5q2FWs+tOFKhU9IEzE7bNWTRuB3rbXxYdjx++7xttPy4QajzJCKmmjFdvIe+coZu+w5u0hn47q8ZtPoXxGDGpjcwky76Yg/9v2wqJf1ACuf9DO0TD/wRIdIjql27xwu43+Pxrz7ifemnYOhKh+M6sCaKIObc08i4LF4mmoiXjfyUpK43heeRBzEUjrLRkVxJ8sy3HY1K0TB3xdzZYZS68dnIgN3ZmNDIaWbKo7KWQl1Y/4caYXDHKScSZaffZ0f8U0Rr1aip7Rj1Bn7TH7jFvPNnf
 vPFxyGyr
 8F73n9OdaqH53B5bUgzbEmw6yY7gncq/8lrQkvX2lodh1Bw0VQdTOuPdwuswEQ0rYWoOICYFKaaK4HbE2XLMLQIXZmc67vqIQiar5L14ItjbpQbK8vOWP25qdqy+4SlhbvJSr4L1Op9Hp7eUgyCmdSs31CkycV7tmcf4MzbvNKtsa53qPUArB4HQWl09FxDamgo8gO52nbDpYode/dEYXlW86wdGYfQBVnmhtzPRSW9Eebk32L7QDl6Mp3rrjBMH11DHrMR0MSrrxR0zSfJVKTJ7JPKLrnDUWM1CBqWl2Xmqr6X6tjnTDz3o7bqNVNe7SvOAJuW0pROMHmVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The vmap entry points may install some PTEs and then fail, leaving a
partial mapping behind.

The callers do not agree on who cleans it up. pcpu_map_pages() and
kmsan_ioremap_page_range() roll back what they mapped, while
vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
__vmalloc_area_node() expect a clean range from the mapping function.
For them the leftovers stay mapped, and the next attempt to map the
same range trips the WARN_ON(!pte_none()) in vmap_pages_pte_range().
A leftover huge pmd is even worse. During the retry, vmap_try_huge_pmd()
calls pmd_free_pte_page() on it, and the x86 implementation cannot
tell a leaf entry from a page table and frees the mapped page.

After discussing with Suren and Ulad, we decided to put the rollback
into the entry points of the vmap API rather than into every
low-level helper. __vmap_pages_range_noflush() undoes the whole range
it was asked to map when it fails, and vmap_page_range() undoes its
range for the ioremap-style mappings.

The rollback is __vunmap_range_noflush(), which only clears the PTEs.
No TLB flush is needed, nothing has touched the mapping yet.
vmap_pages_range_noflush() also drops the KMSAN metadata of the
failed mapping.

The undo walk skips its cond_resched() when the caller's gfp mask
cannot block. __vmalloc() with GFP_ATOMIC or GFP_NOWAIT can run in
atomic context, where cond_resched() cannot schedule.
__vunmap_range_noflush() takes a can_resched argument for that, which
the sleepable callers pass as true.

Suggested-by: Uladyslau Rezki <urezki@gmail.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 include/linux/kmsan.h |  8 ++++--
 mm/kmsan/hooks.c      | 18 ++++++++-----
 mm/kmsan/shadow.c     |  7 ++---
 mm/vmalloc.c          | 61 +++++++++++++++++++++++++++++++++----------
 mm/vmalloc.h          |  6 +++--
 5 files changed, 72 insertions(+), 28 deletions(-)

diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
index 7da9fd506b39..0016c032d1e7 100644
--- a/include/linux/kmsan.h
+++ b/include/linux/kmsan.h
@@ -150,11 +150,14 @@ int __must_check kmsan_vmap_pages_range_noflush(unsigned long start,
  * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap.
  * @start: start of vunmapped range.
  * @end:   end of vunmapped range.
+ * @can_resched: whether the unmap walk may call cond_resched(); pass
+ * false from atomic context.
  *
  * KMSAN unmaps the contiguous metadata ranges created by
  * kmsan_map_kernel_range_noflush().
  */
-void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end);
+void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end,
+				bool can_resched);
 
 /**
  * kmsan_ioremap_page_range() - Notify KMSAN about a ioremap_page_range() call.
@@ -355,7 +358,8 @@ static inline int __must_check kmsan_vmap_pages_range_noflush(
 }
 
 static inline void kmsan_vunmap_range_noflush(unsigned long start,
-					      unsigned long end)
+					      unsigned long end,
+					      bool can_resched)
 {
 }
 
diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index 107f66841274..0cd1edaa1120 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -136,13 +136,16 @@ static unsigned long vmalloc_origin(unsigned long addr)
 						 KMSAN_META_ORIGIN);
 }
 
-void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
+void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end,
+				bool can_resched)
 {
 	if (!kmsan_enabled)
 		return;
 
-	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
-	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
+	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end),
+			       can_resched);
+	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end),
+			       can_resched);
 	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
 	flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
 }
@@ -171,8 +174,9 @@ static void kmsan_iounmap_pages(unsigned long start, unsigned long end)
 		if (origin)
 			__free_pages(origin, KMSAN_IOREMAP_META_ORDER);
 	}
-	__vunmap_range_noflush(shadow_start, shadow_end);
-	__vunmap_range_noflush(origin_start, origin_end);
+	/* ioremap metadata mappings are always GFP_KERNEL, so resched is safe. */
+	__vunmap_range_noflush(shadow_start, shadow_end, true);
+	__vunmap_range_noflush(origin_start, origin_end, true);
 	flush_tlb_kernel_range(shadow_start, shadow_end);
 	flush_tlb_kernel_range(origin_start, origin_end);
 }
@@ -207,7 +211,7 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
 		mapped = __vmap_pages_range_noflush(
 			vmalloc_shadow(start + off),
 			vmalloc_shadow(start + off + PAGE_SIZE), prot, &shadow,
-			PAGE_SHIFT);
+			PAGE_SHIFT, gfp_mask);
 		if (mapped) {
 			err = mapped;
 			goto ret;
@@ -217,7 +221,7 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
 		mapped = __vmap_pages_range_noflush(
 			vmalloc_origin(start + off),
 			vmalloc_origin(start + off + PAGE_SIZE), prot, &origin,
-			PAGE_SHIFT);
+			PAGE_SHIFT, gfp_mask);
 		if (mapped) {
 			err = mapped;
 			goto ret;
diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 2166086d3dc3..452760a333e4 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -247,7 +247,7 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 	origin_end = vmalloc_meta((void *)end, KMSAN_META_ORIGIN);
 	kmsan_enter_runtime();
 	mapped = __vmap_pages_range_noflush(shadow_start, shadow_end, prot,
-					    s_pages, page_shift);
+					    s_pages, page_shift, gfp_mask);
 	kmsan_leave_runtime();
 	if (mapped) {
 		err = mapped;
@@ -255,12 +255,13 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 	}
 	kmsan_enter_runtime();
 	mapped = __vmap_pages_range_noflush(origin_start, origin_end, prot,
-					    o_pages, page_shift);
+					    o_pages, page_shift, gfp_mask);
 	kmsan_leave_runtime();
 	if (mapped) {
 		/* Undo the shadow mapping set up above. */
 		kmsan_enter_runtime();
-		__vunmap_range_noflush(shadow_start, shadow_end);
+		__vunmap_range_noflush(shadow_start, shadow_end,
+				       gfpflags_allow_blocking(gfp_mask));
 		kmsan_leave_runtime();
 		err = mapped;
 		goto ret;
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 3f98056f8c7e..d1986f68eab4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -372,8 +372,12 @@ int vmap_page_range(unsigned long addr, unsigned long end,
 	if (!err)
 		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
 					       ioremap_max_page_shift);
-	if (!err)
+	if (err) {
+		/* Callers are ioremap and arch setup code, always sleepable. */
+		__vunmap_range_noflush(addr, end, true);
+	} else {
 		flush_cache_vmap(addr, end);
+	}
 
 	return err;
 }
@@ -429,7 +433,7 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 }
 
 static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
-			     pgtbl_mod_mask *mask)
+			     pgtbl_mod_mask *mask, bool can_resched)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -451,12 +455,14 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 			continue;
 		vunmap_pte_range(pmd, addr, next, mask);
 
-		cond_resched();
+		/* The undo path may run in atomic context. */
+		if (can_resched)
+			cond_resched();
 	} while (pmd++, addr = next, addr != end);
 }
 
 static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
-			     pgtbl_mod_mask *mask)
+			     pgtbl_mod_mask *mask, bool can_resched)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -476,12 +482,12 @@ static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
 		}
 		if (pud_none_or_clear_bad(pud))
 			continue;
-		vunmap_pmd_range(pud, addr, next, mask);
+		vunmap_pmd_range(pud, addr, next, mask, can_resched);
 	} while (pud++, addr = next, addr != end);
 }
 
 static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
-			     pgtbl_mod_mask *mask)
+			     pgtbl_mod_mask *mask, bool can_resched)
 {
 	p4d_t *p4d;
 	unsigned long next;
@@ -496,7 +502,7 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
 
 		if (p4d_none_or_clear_bad(p4d))
 			continue;
-		vunmap_pud_range(p4d, addr, next, mask);
+		vunmap_pud_range(p4d, addr, next, mask, can_resched);
 	} while (p4d++, addr = next, addr != end);
 }
 
@@ -512,7 +518,8 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
  *
  * This is an internal function only. Do not use outside mm/.
  */
-void __vunmap_range_noflush(unsigned long start, unsigned long end)
+void __vunmap_range_noflush(unsigned long start, unsigned long end,
+			    bool can_resched)
 {
 	unsigned long next;
 	pgd_t *pgd;
@@ -529,7 +536,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
 			mask |= PGTBL_PGD_MODIFIED;
 		if (pgd_none_or_clear_bad(pgd))
 			continue;
-		vunmap_p4d_range(pgd, addr, next, &mask);
+		vunmap_p4d_range(pgd, addr, next, &mask, can_resched);
 	} while (pgd++, addr = next, addr != end);
 
 	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
@@ -538,8 +545,9 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
 
 void vunmap_range_noflush(unsigned long start, unsigned long end)
 {
-	kmsan_vunmap_range_noflush(start, end);
-	__vunmap_range_noflush(start, end);
+	/* The unmap paths are sleepable, keep the resched point. */
+	kmsan_vunmap_range_noflush(start, end, true);
+	__vunmap_range_noflush(start, end, true);
 }
 
 /**
@@ -727,18 +735,32 @@ static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
  * The caller is responsible for calling flush_cache_vmap() after this
  * function returns successfully and before the addresses are accessed.
  *
+ * On failure the mapping is torn down before returning, so a retry
+ * sees a clean range. When @gfp_mask cannot block, the teardown
+ * skips cond_resched(), it may run in atomic context.
+ *
  * This is an internal function only. Do not use outside mm/.
  */
 int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
-		pgprot_t prot, struct page **pages, unsigned int page_shift)
+		pgprot_t prot, struct page **pages, unsigned int page_shift,
+		gfp_t gfp_mask)
 {
+	int err;
+
 	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
 		page_shift = PAGE_SHIFT;
 
-	return vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift);
+	err = vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift);
+
+	/* Undo the PTEs installed before the failure. */
+	if (err)
+		__vunmap_range_noflush(addr, end,
+				       gfpflags_allow_blocking(gfp_mask));
+
+	return err;
 }
 
 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
@@ -750,7 +772,18 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 
 	if (ret)
 		return ret;
-	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
+
+	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift,
+					 gfp_mask);
+	/*
+	 * The page tables undo themselves on failure. Tear down the
+	 * metadata that was fully set up before the mapping failed.
+	 */
+	if (ret)
+		kmsan_vunmap_range_noflush(addr, end,
+					   gfpflags_allow_blocking(gfp_mask));
+
+	return ret;
 }
 
 static int __vmap_pages_range(unsigned long addr, unsigned long end,
diff --git a/mm/vmalloc.h b/mm/vmalloc.h
index d8372a4f65c4..9ea28845f713 100644
--- a/mm/vmalloc.h
+++ b/mm/vmalloc.h
@@ -40,10 +40,12 @@ void clear_vm_uninitialized_flag(struct vm_struct *vm);
 
 int __must_check __vmap_pages_range_noflush(unsigned long addr,
 		unsigned long end, pgprot_t prot,
-		struct page **pages, unsigned int page_shift);
+		struct page **pages, unsigned int page_shift,
+		gfp_t gfp_mask);
 
 void vunmap_range_noflush(unsigned long start, unsigned long end);
 
-void __vunmap_range_noflush(unsigned long start, unsigned long end);
+void __vunmap_range_noflush(unsigned long start, unsigned long end,
+			    bool can_resched);
 
 #endif /* __MM_VMALLOC_H */
-- 
2.25.1


