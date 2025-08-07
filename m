Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE23C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 10:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF11D8E0002; Thu,  7 Aug 2025 06:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7B9D8E0001; Thu,  7 Aug 2025 06:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C3F8E0002; Thu,  7 Aug 2025 06:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5C68E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 06:39:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE7EDC0AE8
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:39:11 +0000 (UTC)
X-FDA: 83749614102.23.7639542
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2665A160003
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:39:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=07vtl+Mo;
	spf=pass (imf08.hostedemail.com: domain of 3TYKUaAsKCO4beaUiXWYThQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--lokeshgidra.bounces.google.com designates 209.85.128.201 as permitted sender) smtp.mailfrom=3TYKUaAsKCO4beaUiXWYThQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754563150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QMhp8lv0NawhZpAecC0XDc0j7rj3CAoHpWDf4sgDMnc=;
	b=nvITxGk36fxL7iuMvw8pzF16nWaz/zlgDzEXS0SzXb+l1rZajxWgFrcTO4wqhwQJyRrPco
	eJ68pph//drw/2O8Hu8llHGPh4HhS0kDuHuXqyAjys1jiHGuS+zsb1gzynSQSKlZ/aG5M4
	59FJaqY/nxDgfwi6esEKzpB9O60filQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754563150; a=rsa-sha256;
	cv=none;
	b=BNXHhiXRITgGuN+6VdPt4w1l7BVo100OwldFD4pk/Ldd1d4sfp1gqx5tzhYsDa3phVsklU
	3o+CPjjKz3/j9plnoMv2diCIacxD3xvSSIbfCpsDjv63gtun+5cQdsCJjn5BxJvDSlLerV
	w2zw84XGbFc1Y2APp/cBJIq5v+puvNc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=07vtl+Mo;
	spf=pass (imf08.hostedemail.com: domain of 3TYKUaAsKCO4beaUiXWYThQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--lokeshgidra.bounces.google.com designates 209.85.128.201 as permitted sender) smtp.mailfrom=3TYKUaAsKCO4beaUiXWYThQWeeWbU.SecbYdkn-ccalQSa.ehW@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-71a29921b1dso11711567b3.2
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 03:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754563149; x=1755167949; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QMhp8lv0NawhZpAecC0XDc0j7rj3CAoHpWDf4sgDMnc=;
        b=07vtl+MomQSfbAmgWwqJgmX1vo/udM0Yj6A5CgF3QFQTc0n5VRUOAR7gGjs9F4feXa
         KjBnpJVcFX2ewuD0sxZtQ/iTVy+y7KDI8mSr0geCl6pjmaYdTyKpgnWtbF9npDXhiNkl
         eBD0MTh8Gp++ss4VHR1K+eI9zTEu+Hu+Schy14xn3hYIgkF6uuo/kn8B+09mFiKNmnKg
         zT0QIHbjR0MboN0oZDqjEsYz9ubJJpt/vuVzeqG4yuUktEqN1GOMBPt/EhXSNbmuK7Vb
         oNa5jkQ7Mukjyo/18vV3sU8kEHHB/dSxdOSIJgcmSGGWzp3so0X6Qu+l61hDFMFvoEQk
         IwcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754563149; x=1755167949;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QMhp8lv0NawhZpAecC0XDc0j7rj3CAoHpWDf4sgDMnc=;
        b=ZJRoxiec5tlODXYvQxx+aXkNRMIUik07rxNko0iF3xFYZkWAu3r0gqYsbofQ79unzZ
         VhLJtCKNz1fuQOqY/yMptaqy1kD2ijQorJSbtBdNDTdOVKtNH+TveqxfImKKYZ1FQgl5
         sJ34Q5jKUjfEaJDL4vAYiHvFZTYpUuJmEBLbpzTS/b8ZiZb7+RoXJRHhUsq5WKeYNe3r
         ue6UBVPQUf4jvbKvQ+BcUoAzN+JneoxsTptgY4hTWjBi2+Ttmu7xZLhuRdVej6juT3d6
         o0S6xIDfbBa8dFex8cSbf0YFxJLfF/mCoYyYnhUW3kUW50Rpvpm8iaLFq+up6C4QzuwM
         AoDw==
X-Forwarded-Encrypted: i=1; AJvYcCXyQZeCWhud59cxwQIFFt51zmeFMo51X6f7r2/Z0TxkfILOUTIJK2ceTcl2y0TYnww+NPWJzRzgfQ==@kvack.org
X-Gm-Message-State: AOJu0YxkTRDksvpf7LY/uHZ8St4moifZkfDzZFagW85rch919jf9eRpG
	tuRXKgGTbbBtlveYKNeDfUfSAOgAj7hkltgfbsDbL7L2uNwra8aGV0E3D45RAD1hwinSdyjP0Z1
	6FUdevDwt0eBDr2lIa2r0AQKUHw==
X-Google-Smtp-Source: AGHT+IFygKfhqzlRbf1LnnYZ11Ya4RsFggPGNdRjmlB+hO6r7aW1ZTzxIcjlYSCcRn/pfcMxLmzIJovOA/8i0Pfwng==
X-Received: from ywf19.prod.google.com ([2002:a05:690c:9693:b0:71a:3c31:55fb])
 (user=lokeshgidra job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:690c:61c1:b0:71a:34bb:4277 with SMTP id 00721157ae682-71bdbbb573bmr32678997b3.18.1754563149083;
 Thu, 07 Aug 2025 03:39:09 -0700 (PDT)
Date: Thu,  7 Aug 2025 03:39:02 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250807103902.2242717-1-lokeshgidra@google.com>
Subject: [PATCH v3] userfaultfd: opportunistic TLB-flush batching for present
 pages in MOVE
From: Lokesh Gidra <lokeshgidra@google.com>
To: akpm@linux-foundation.org
Cc: aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	21cnbao@gmail.com, ngeoffray@google.com, 
	Lokesh Gidra <lokeshgidra@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Barry Song <v-songbaohua@oppo.com>, 
	David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2665A160003
X-Stat-Signature: zf1gsjpue43bs6z9y46hcrgdhxr9eryi
X-Rspam-User: 
X-HE-Tag: 1754563149-227986
X-HE-Meta: U2FsdGVkX19NQtMsLlExajhCsU0Cd1RWMUyanC1MDPKTTgKYEFGPGcc/nV+7d7mc4aroEsh8aoaXj0jq2+duq/lLiYhqPOCIjhLfEhVcsZdWCGFMWNwqSgzYpGxJfiMvzvZ6AugDy1tIhLkVDKFEKpXF/JzR7DcRZOeVdXjai+Ct1x1/oroyTiscwHFoUBBpvDstutKGN6XJ2hi1C8BI+khBi+61QqboV4EKkG67dBoRAfiBygSc6bPi6bih5Vf/Yfnke9iha9Y+amCS6KJWH7D0cxO6DWdLR0blHtYhXJcKQRqt58VrgrmyM6ByLasdDkj042lI5kUr/dv5AfHBdCNiynt9n5y3jDoFXXk4+PS2wyNN4/pqWiNAFO9SchMpncjcOvRV9XPzR/+cbJnhljYtRsx3JjUJp0j1Yc6WmN9RMjuDaJaJZK09xiw3KePK9T67VOgP9O/FSrWhcOwNiMyCh7Bk38IbeJF+me2wHJgq0mSOynK6ITVcDCEd+CxCU2DS6Kfk+bWpt+aht0cpjE/+TXHxY+we2RXBcefXnpjfBjds6FZ0azds2ooVvlK6oeOY0Wt19Y7xX3hqAG2Ae1kNTRXwJIMRdG23qw+SdZAdLHraietb3NpP/g2W4hg9n2P8WIWV3AvLChJqzR1pnqClP6zKlaQ4ud5x34ELWXMdzSmRyFA85pD3oFKshrWvsG6j5xEPJc3zX7zRoJcmsQe7r9zw9OpLpmtXWT8ippBZqJe/EIL7SS+lnW3v9vAAOsfdscUMGSRqLIpXPBZKiv16RbJopEbxVn+saZavYxmvPXtOzl1OdeY1zapSNzmHZVv3wD6NsCG4NNlwAAjK5BPbPL89Rg1Peembcubsoxfj0mcSL/QxXnV5WxmzELsa7CLjqirr5BN1xpuX+P0SR1sYhiyoY6IRi9xqoK1O8ZNG5FaCTZdrGq8Eu92DDSLXDAHPgWTWollTmzhoFTq
 PdnjMZKv
 jQlxZUy2vLPoR5peyzhHmcjGFZJQwLKaOsxzOiTqTUWIMAZMOjj79K9f+hz4EpKM15Zs0aej6hlZEsDOdUwOOufZDJytvVn5lBhPiUpPyICl11gFflswUgY3TgoNmsat24A2kjb+5BW5aOazpDiTWIRUGnucRFExybRM82arbVDdUzCJUpS9I6BK9m2qzg8KOeEsZaKOaSqfVEN42niRtyWNWlST5ZLDYrF9vB1xqosdPeL0sHRv5W3r8CE6AcSdD4EWXslr27xfoNvA0wVjAQ4IBPP5Pp3M8dW/629sBJ46mddH1sV+cRdkQRDktZii6j+q+v/RaRJ6BLpkLTbXn/BMotaeKDjgS+GLksks/Gu63cnOgerAxFJ2g2j2kmGalQzhz4UnKF6CvALvM32nflDjPpuxYM3NLRXlumHFav925wege4S0oOayCdl+khfko0CBGSpjKIR+iUocwZgwBaj3thpZNpHjfj5wm3KzB8snvPc1niShJXdhdHAKgI0FL5VTk1fZPn1jzmCqdLbc9Ex8QBFaH3W3zYoq/JBZZlgrRc+VQ7eA96SQnrIzQ1K/qTCdK2d3R1Y9bCXgIaLkY+d6xNRZDFXgeSnkgnImfDLi0jGMuroEytfWMXY3TCInYqjlo1rGCngSCMJD68zn3vSC1H3IiKzaHB0WVXQ49cy/x+U4y6Ykyk2RxsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
for moving present pages. Mitigate this cost by opportunistically
batching present contiguous pages for TLB flushing.

Without batching, in our testing on an arm64 Android device with UFFD GC,
which uses MOVE ioctl for compaction, we observed that out of the total
time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
~20% in vm_normal_folio().

With batching, the proportion of vm_normal_folio() increases to over
70% of move_pages_pte() without any changes to vm_normal_folio().
Furthermore, time spent within move_pages_pte() is only ~20%, which
includes TLB-flush overhead.

Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
---
Changes since v2 [1]
- Addressed VM_WARN_ON failure, per Lorenzo Stoakes
- Added check to ensure all batched pages share the same anon_vma

Changes since v1 [2]
- Removed flush_tlb_batched_pending(), per Barry Song
- Unified single and multi page case, per Barry Song

[1] https://lore.kernel.org/all/20250805121410.1658418-1-lokeshgidra@google.com/
[2] https://lore.kernel.org/all/20250731104726.103071-1-lokeshgidra@google.com/

 mm/userfaultfd.c | 179 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 128 insertions(+), 51 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index cbed91b09640..78c732100aec 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1026,18 +1026,64 @@ static inline bool is_pte_pages_stable(pte_t *dst_pte, pte_t *src_pte,
 	       pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
 }
 
-static int move_present_pte(struct mm_struct *mm,
-			    struct vm_area_struct *dst_vma,
-			    struct vm_area_struct *src_vma,
-			    unsigned long dst_addr, unsigned long src_addr,
-			    pte_t *dst_pte, pte_t *src_pte,
-			    pte_t orig_dst_pte, pte_t orig_src_pte,
-			    pmd_t *dst_pmd, pmd_t dst_pmdval,
-			    spinlock_t *dst_ptl, spinlock_t *src_ptl,
-			    struct folio *src_folio)
+/*
+ * Checks if the two ptes and the corresponding folio are eligible for batched
+ * move. If so, then returns pointer to the folio, after locking it. Otherwise,
+ * returns NULL.
+ */
+static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
+						 unsigned long src_addr,
+						 pte_t *src_pte, pte_t *dst_pte,
+						 struct anon_vma *src_anon_vma)
+{
+	pte_t orig_dst_pte, orig_src_pte;
+	struct folio *folio;
+
+	orig_dst_pte = ptep_get(dst_pte);
+	if (!pte_none(orig_dst_pte))
+		return NULL;
+
+	orig_src_pte = ptep_get(src_pte);
+	if (pte_none(orig_src_pte) || !pte_present(orig_src_pte) ||
+	    is_zero_pfn(pte_pfn(orig_src_pte)))
+		return NULL;
+
+	folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
+	if (!folio || !folio_trylock(folio))
+		return NULL;
+	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio) ||
+	    folio_anon_vma(folio) != src_anon_vma) {
+		folio_unlock(folio);
+		return NULL;
+	}
+	return folio;
+}
+
+static long move_present_ptes(struct mm_struct *mm,
+			      struct vm_area_struct *dst_vma,
+			      struct vm_area_struct *src_vma,
+			      unsigned long dst_addr, unsigned long src_addr,
+			      pte_t *dst_pte, pte_t *src_pte,
+			      pte_t orig_dst_pte, pte_t orig_src_pte,
+			      pmd_t *dst_pmd, pmd_t dst_pmdval,
+			      spinlock_t *dst_ptl, spinlock_t *src_ptl,
+			      struct folio *src_folio, unsigned long len,
+			      struct anon_vma *src_anon_vma)
 {
 	int err = 0;
+	unsigned long src_start = src_addr;
+	unsigned long addr_end;
 
+	if (len > PAGE_SIZE) {
+		addr_end = (dst_addr + PMD_SIZE) & PMD_MASK;
+		if (dst_addr + len > addr_end)
+			len = addr_end - dst_addr;
+
+		addr_end = (src_addr + PMD_SIZE) & PMD_MASK;
+		if (src_addr + len > addr_end)
+			len = addr_end - src_addr;
+	}
+	flush_cache_range(src_vma, src_addr, src_addr + len);
 	double_pt_lock(dst_ptl, src_ptl);
 
 	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
@@ -1051,31 +1097,54 @@ static int move_present_pte(struct mm_struct *mm,
 		err = -EBUSY;
 		goto out;
 	}
+	arch_enter_lazy_mmu_mode();
+
+	addr_end = src_start + len;
+	while (true) {
+		orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
+		/* Folio got pinned from under us. Put it back and fail the move. */
+		if (folio_maybe_dma_pinned(src_folio)) {
+			set_pte_at(mm, src_addr, src_pte, orig_src_pte);
+			err = -EBUSY;
+			break;
+		}
 
-	orig_src_pte = ptep_clear_flush(src_vma, src_addr, src_pte);
-	/* Folio got pinned from under us. Put it back and fail the move. */
-	if (folio_maybe_dma_pinned(src_folio)) {
-		set_pte_at(mm, src_addr, src_pte, orig_src_pte);
-		err = -EBUSY;
-		goto out;
-	}
-
-	folio_move_anon_rmap(src_folio, dst_vma);
-	src_folio->index = linear_page_index(dst_vma, dst_addr);
+		folio_move_anon_rmap(src_folio, dst_vma);
+		src_folio->index = linear_page_index(dst_vma, dst_addr);
 
-	orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
-	/* Set soft dirty bit so userspace can notice the pte was moved */
+		orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
+		/* Set soft dirty bit so userspace can notice the pte was moved */
 #ifdef CONFIG_MEM_SOFT_DIRTY
-	orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
+		orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
 #endif
-	if (pte_dirty(orig_src_pte))
-		orig_dst_pte = pte_mkdirty(orig_dst_pte);
-	orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+		if (pte_dirty(orig_src_pte))
+			orig_dst_pte = pte_mkdirty(orig_dst_pte);
+		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+		set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
+
+		src_addr += PAGE_SIZE;
+		if (src_addr == addr_end)
+			break;
+		src_pte++;
+		dst_pte++;
+
+		folio_unlock(src_folio);
+		src_folio = check_ptes_for_batched_move(src_vma, src_addr, src_pte,
+							dst_pte, src_anon_vma);
+		if (!src_folio)
+			break;
+		dst_addr += PAGE_SIZE;
+	}
+
+	arch_leave_lazy_mmu_mode();
+	if (src_addr > src_start)
+		flush_tlb_range(src_vma, src_start, src_addr);
 
-	set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
 out:
 	double_pt_unlock(dst_ptl, src_ptl);
-	return err;
+	if (src_folio)
+		folio_unlock(src_folio);
+	return src_addr > src_start ? src_addr - src_start : err;
 }
 
 static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
@@ -1140,7 +1209,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
-	return 0;
+	return PAGE_SIZE;
 }
 
 static int move_zeropage_pte(struct mm_struct *mm,
@@ -1154,6 +1223,7 @@ static int move_zeropage_pte(struct mm_struct *mm,
 {
 	pte_t zero_pte;
 
+	flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
 	double_pt_lock(dst_ptl, src_ptl);
 	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
 				 dst_pmd, dst_pmdval)) {
@@ -1167,20 +1237,19 @@ static int move_zeropage_pte(struct mm_struct *mm,
 	set_pte_at(mm, dst_addr, dst_pte, zero_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
-	return 0;
+	return PAGE_SIZE;
 }
 
 
 /*
- * The mmap_lock for reading is held by the caller. Just move the page
- * from src_pmd to dst_pmd if possible, and return true if succeeded
- * in moving the page.
+ * The mmap_lock for reading is held by the caller. Just move the page(s)
+ * from src_pmd to dst_pmd if possible, and return number of bytes moved.
  */
-static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
-			  struct vm_area_struct *dst_vma,
-			  struct vm_area_struct *src_vma,
-			  unsigned long dst_addr, unsigned long src_addr,
-			  __u64 mode)
+static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
+			    struct vm_area_struct *dst_vma,
+			    struct vm_area_struct *src_vma,
+			    unsigned long dst_addr, unsigned long src_addr,
+			    unsigned long len, __u64 mode)
 {
 	swp_entry_t entry;
 	struct swap_info_struct *si = NULL;
@@ -1196,9 +1265,8 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 	struct mmu_notifier_range range;
 	int err = 0;
 
-	flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
-				src_addr, src_addr + PAGE_SIZE);
+				src_addr, src_addr + len);
 	mmu_notifier_invalidate_range_start(&range);
 retry:
 	/*
@@ -1257,7 +1325,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 		if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
 			err = -ENOENT;
 		else /* nothing to do to move a hole */
-			err = 0;
+			err = PAGE_SIZE;
 		goto out;
 	}
 
@@ -1375,10 +1443,14 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 			}
 		}
 
-		err = move_present_pte(mm,  dst_vma, src_vma,
-				       dst_addr, src_addr, dst_pte, src_pte,
-				       orig_dst_pte, orig_src_pte, dst_pmd,
-				       dst_pmdval, dst_ptl, src_ptl, src_folio);
+		err = move_present_ptes(mm, dst_vma, src_vma,
+					dst_addr, src_addr, dst_pte, src_pte,
+					orig_dst_pte, orig_src_pte, dst_pmd,
+					dst_pmdval, dst_ptl, src_ptl, src_folio,
+					len, src_anon_vma);
+		/* folio is already unlocked by move_present_ptes() */
+		folio_put(src_folio);
+		src_folio = NULL;
 	} else {
 		struct folio *folio = NULL;
 
@@ -1732,7 +1804,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 {
 	struct mm_struct *mm = ctx->mm;
 	struct vm_area_struct *src_vma, *dst_vma;
-	unsigned long src_addr, dst_addr;
+	unsigned long src_addr, dst_addr, src_end;
 	pmd_t *src_pmd, *dst_pmd;
 	long err = -EINVAL;
 	ssize_t moved = 0;
@@ -1775,8 +1847,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 	if (err)
 		goto out_unlock;
 
-	for (src_addr = src_start, dst_addr = dst_start;
-	     src_addr < src_start + len;) {
+	for (src_addr = src_start, dst_addr = dst_start, src_end = src_start + len;
+	     src_addr < src_end;) {
 		spinlock_t *ptl;
 		pmd_t dst_pmdval;
 		unsigned long step_size;
@@ -1841,6 +1913,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 						  dst_addr, src_addr);
 			step_size = HPAGE_PMD_SIZE;
 		} else {
+			long ret;
+
 			if (pmd_none(*src_pmd)) {
 				if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES)) {
 					err = -ENOENT;
@@ -1857,10 +1931,13 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 				break;
 			}
 
-			err = move_pages_pte(mm, dst_pmd, src_pmd,
-					     dst_vma, src_vma,
-					     dst_addr, src_addr, mode);
-			step_size = PAGE_SIZE;
+			ret = move_pages_ptes(mm, dst_pmd, src_pmd,
+					      dst_vma, src_vma, dst_addr,
+					      src_addr, src_end - src_addr, mode);
+			if (ret > 0)
+				step_size = ret;
+			else
+				err = ret;
 		}
 
 		cond_resched();

base-commit: 6e64f4580381e32c06ee146ca807c555b8f73e24
-- 
2.50.1.565.gc32cd1483b-goog


