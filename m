Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A1EEC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 10:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D6816B008A; Thu, 31 Jul 2025 06:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687B66B008C; Thu, 31 Jul 2025 06:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576926B0092; Thu, 31 Jul 2025 06:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4766C6B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:47:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA119140690
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:47:37 +0000 (UTC)
X-FDA: 83724233754.13.75E29E0
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id 24A081C0009
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:47:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gwa8xVj8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3xkmLaAsKCNE8B71F4350Ex3BB381.zB985AHK-997Ixz7.BE3@flex--lokeshgidra.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3xkmLaAsKCNE8B71F4350Ex3BB381.zB985AHK-997Ixz7.BE3@flex--lokeshgidra.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753958856; a=rsa-sha256;
	cv=none;
	b=aMmnILHnb8ZNJzQ85XMvAY+6Va/pntgeVAq8SM9UB3mxbWGKakpyCfBLGdVhyKast4aPYv
	9LYJdgzSu8LHdJr7emf4mukc5g/2RdNeHGznsVnD8YPvJJGE91U+nSZNZfNC9NPJazcOSk
	AsAJ9SrovJhT8c+8S2ydiCPh4FLaZjk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gwa8xVj8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3xkmLaAsKCNE8B71F4350Ex3BB381.zB985AHK-997Ixz7.BE3@flex--lokeshgidra.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3xkmLaAsKCNE8B71F4350Ex3BB381.zB985AHK-997Ixz7.BE3@flex--lokeshgidra.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753958856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jmVmMC4y8g0rdBTUdQ+rlpniSResHrgoYPF/jK8n4hk=;
	b=2S1M0UNcobitk4KTkzPaYpbUDexJFRRPsHLoWNFtHeAYmojg1Dm467fpCwDfdBHDdTtkPe
	BWNhIYYJ5ngpWRksdHPQL5MaS4Ogt6HTJ3E5Lj3t4kZ6mx9mKdpJ07wjVC83g/WA0C/o7c
	8Z1hfAMBpxK8Q1oTPVJFNBZA+A9+QVA=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2369dd58602so12995855ad.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 03:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753958855; x=1754563655; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jmVmMC4y8g0rdBTUdQ+rlpniSResHrgoYPF/jK8n4hk=;
        b=gwa8xVj8Wt+C9FjdxhjloabOBkm8po0C8umpNS8gtny6pwTYv3kctDKKtXJlgahdrV
         m3SkzpTWKiv0OQcyiF8tVUFe4WDr3SHxzHxRxboo746G6nMYPx/EkqPXxHpKxzC0VFOi
         mhZ8Je5tl9Mt92IPisQk1JmLOX+DqXrYtNsDJbMSZq5yOt9LW8vD5wD2Wi2FBYWRRXVz
         a3ow5ZYbVZDCbRyqKkeKHTg6Nnphbzp+iUzO9USmLXjVSDsRlrc2i0JAdEFSETOiKaOe
         gqibrnyt8Hgsh3C82kCOKTfNhG+Tomtlpv2MauKej1X7kOT7gclWPbC5UxUhz412yFPM
         rbww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753958855; x=1754563655;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jmVmMC4y8g0rdBTUdQ+rlpniSResHrgoYPF/jK8n4hk=;
        b=t8o/TJM1F71ZghrO6T//mutabmBvlEppo8/xsFu0qyBR7u/w+Sqzz7iPdvnayUf+Ox
         B+9Q2T3pzTsq6Apo9ywyNjZOAnvaC7kM0k4Gvg5UEi8GaXsmGUaa8z1VoEz4o6eoB1Cj
         jjg5LW6ytZDQcOHJs8QElDlUdddSaZnIoFfjGX23i1IRiRnaiyCVvjeR+fdvkzjfRKCK
         pdTIIe1H0lrQTJL0GjpwfzJUR+j5z3Ytkjqji6bJkeLe1/6XqvQzF5bI7QJ4FndedKsV
         +0MFznmvL7Z7MXWYKcbQX+sS8Z4XxlJbnu1k+nqWnFIlhh77jUqTE7NZO85naGGSafNe
         Z8AA==
X-Forwarded-Encrypted: i=1; AJvYcCX+1/ok4gmu0yyfdDqqz7oJKPCYYMWytDy8D7UFyS8/a+Q7pmC58xga+JZZ3rRiS0PLK7fXxMbTYA==@kvack.org
X-Gm-Message-State: AOJu0YzGdMp7SjkUNLwAZbf/XA0qI6ywWGwHlYICqMiy+qKpe69+SJKi
	UPJme2GfowabaVj44Gv4vdEKMu6x3ErPUlTY1uNwXG4twMxsDmC2ys8hY+q5FlII4fWviCp23A0
	EwnEm6qQgPuJdcZLNyaEZqluxtg==
X-Google-Smtp-Source: AGHT+IE1/tQaotfDerxo0Akpv/ZrF2UBnAJanrDy28VEqq5hoeuwi3AYJLinngOd7YlfzatpVqskhQvBnkPQaOEXLQ==
X-Received: from plbjc17.prod.google.com ([2002:a17:903:25d1:b0:23f:fa41:1de3])
 (user=lokeshgidra job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f70a:b0:240:1f19:d35c with SMTP id d9443c01a7336-24096bc750amr86995275ad.39.1753958854671;
 Thu, 31 Jul 2025 03:47:34 -0700 (PDT)
Date: Thu, 31 Jul 2025 03:47:26 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250731104726.103071-1-lokeshgidra@google.com>
Subject: [PATCH] userfaultfd: opportunistic TLB-flush batching for present
 pages in MOVE
From: Lokesh Gidra <lokeshgidra@google.com>
To: akpm@linux-foundation.org
Cc: aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	21cnbao@gmail.com, ngeoffray@google.com, 
	Lokesh Gidra <lokeshgidra@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Barry Song <v-songbaohua@oppo.com>, 
	David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 24A081C0009
X-Stat-Signature: os1fjs79qp4qjuwcb9hjazzgdjiudae9
X-HE-Tag: 1753958855-532159
X-HE-Meta: U2FsdGVkX18XD/4rP86tURA2sRC1L2WJ7uHNxb4cxJQpmESENVsxCH0piLJyBUUp/B2xXPzy6DjVVCfhJPNdZkNU1yA6gUTI/QaB9uG3rRepyJWedjLwo8heKFt+d8RDMjfNlsfV2F7crVHbzHAv41qns1LVNy32OUeFLle76Ac12f9DxvnVJjxB/UILeA61FY6eDOtymnydGVjwVyKB1veMPbrSeyGDSmkbd6o5RAoXsv1rfqLA2mfc21G5+UdDGom6pAsNTlo3x5eioIMSj+G7dG0uJ1zYwO044Wz8APBw6EFa56FgGGfg5i39thA1fpae3GbwPfvCy9pZPrPCL70pm31gMfPWi9uRqUxnaArU7Bo7xwWIdWbpGrxI2bwcamSfsqBDMHXyalXHP7PE7tY/D4EUpj598Lz0Y4+i3cUIqS9BM2arLd9ODfvYrB4e+mDVATxFT0HknvUsIHoU5xpNQBI4RbSMQIrmeKCIMBsShccHm+gcuYaIKXgJhFQZ4/AUpyN9Eamn1aWn8y3YHZ5AGfXq1YjcUP0tiIgwY71jADz6VOQlKlcSlgHWP/4pPduKzgqxjLuEsOav7IQhnbfcNVoB97OwKGKPpMNlTK8RCikA3PiX9xi6R5bSzwHZYCvlIaxQ3cyFxA4x28DCE2sGWYJN2+wHKvDDAJHT2DmapSSYHAos0N4yU/9VHUSFXzZbBp7HZ7iPyPiwHdc0bVOwfSuHXaRDZvZ6l/PrRQFBxF3VPMXstX03YwtUlIAaO7zuCjTLN90vcSU1XpzMB96LrJpp+IFYEfPv7not0g6kgHk9UcdQIRjbJnIaD6I4br0YfFoJdPtvuss8YC3iF0CZCExDPqvBJDNfvpvgTUbWLuxdRbe2rmlcWLaiKmOCM64yhRQbPS+/vAOBDmk7q9IkEg4UGD+r6I+zSjfkEn9XbIXChyV9b2PfR22Ua4PDDBPzXF6+mMoAn0YXO2o
 D7qFWLls
 ee0ko2wXRVJZssuoReVntxye4CljyMtY5kqaUQgu/Uttyr10KL4g6v80STeLz5O7u205yENjtif+TVdc9yx3xIUz+bOJwJdHunczhXPub9SEQk2I750aWPEg38q1rAVMmQzLOvk2J6wQFBm6925N/T63tRavMCjbl9HQJerXEo6GhA5CVa78di6J5i9eXEN2MPGXNJMKhXO/Df1U78Yt/nFQis48i0tdCGXgxt9ldZoj1z8KeHH8YOE0HLZM7c2PoPChgDWagN0TPeCYpwgDGD1jNCjiX9mTR6H2jLTepGCKjsQ2uOUDFO9pE8bZ4Vyqstb5rozYkZqV04Zse3iz2Gb4r96QOHm4LSLUSd3gCHMe3C1zKmvn8+Hi2WGVjRTjqzZ01NrwycN3cJJMN19Hjkif13aeZMdMutMx/hGM44POAuumx8fVBamnK2ay3UDhnXWyv4DLXrrvVbb+sFVhBptEcDBScsRSgx4+zLP0a6XHBpwECbH6RmEVaXwcTTOkvRFZw/J3KAkjJhBXt0XUhuO5z6zN+nO5jjpFwhuS9Q4RPen9QOqGffE8Aw0B3u9Bfx08BCMvUzYQsygBxZQllIykpeQt1SXX0x0fwEO7fKn0RGCUAQZTmwCJ+zdtGsTXtfSDG+PYEdEcBZYqCzBQ6oR9ht2zEiAzygHxA
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
 mm/userfaultfd.c | 179 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 127 insertions(+), 52 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 8253978ee0fb..2465fb234671 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1026,18 +1026,62 @@ static inline bool is_pte_pages_stable(pte_t *dst_pte, pte_t *src_pte,
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
+						 pte_t *src_pte, pte_t *dst_pte)
+{
+	pte_t orig_dst_pte, orig_src_pte;
+	struct folio *folio;
+
+	orig_dst_pte = ptep_get(dst_pte);
+	if (!pte_none(orig_dst_pte))
+		return NULL;
+
+	orig_src_pte = ptep_get(src_pte);
+	if (pte_none(orig_src_pte))
+		return NULL;
+	if (!pte_present(orig_src_pte) || is_zero_pfn(pte_pfn(orig_src_pte)))
+		return NULL;
+
+	folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
+	if (!folio || !folio_trylock(folio))
+		return NULL;
+	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio)) {
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
+			      struct folio *src_folio, unsigned long len)
 {
 	int err = 0;
+	unsigned long src_start = src_addr;
+	unsigned long addr_end;
+
+	if (len > PAGE_SIZE) {
+		addr_end = (dst_addr + PMD_SIZE) & PMD_MASK;
+		if (dst_addr + len > addr_end)
+			len = addr_end - dst_addr;
 
+		addr_end = (src_addr + PMD_SIZE) & PMD_MASK;
+		if (src_addr + len > addr_end)
+			len = addr_end - src_addr;
+	}
+	flush_cache_range(src_vma, src_addr, src_addr + len);
 	double_pt_lock(dst_ptl, src_ptl);
 
 	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
@@ -1051,31 +1095,60 @@ static int move_present_pte(struct mm_struct *mm,
 		err = -EBUSY;
 		goto out;
 	}
+	/* Avoid batching overhead for single page case */
+	if (len > PAGE_SIZE) {
+		flush_tlb_batched_pending(mm);
+		arch_enter_lazy_mmu_mode();
+		orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
+	} else
+		orig_src_pte = ptep_clear_flush(src_vma, src_addr, src_pte);
+
+	addr_end = src_start + len;
+	do {
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
 
-	set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
+		folio_unlock(src_folio);
+		src_folio = check_ptes_for_batched_move(src_vma, src_addr, src_pte, dst_pte);
+		if (!src_folio)
+			break;
+		orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
+		dst_addr += PAGE_SIZE;
+	} while (true);
+
+	if (len > PAGE_SIZE) {
+		arch_leave_lazy_mmu_mode();
+		if (src_addr > src_start)
+			flush_tlb_range(src_vma, src_start, src_addr);
+	}
 out:
 	double_pt_unlock(dst_ptl, src_ptl);
-	return err;
+	if (src_folio)
+		folio_unlock(src_folio);
+	return src_addr > src_start ? src_addr - src_start : err;
 }
 
 static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
@@ -1140,7 +1213,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
-	return 0;
+	return PAGE_SIZE;
 }
 
 static int move_zeropage_pte(struct mm_struct *mm,
@@ -1154,6 +1227,7 @@ static int move_zeropage_pte(struct mm_struct *mm,
 {
 	pte_t zero_pte;
 
+	flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
 	double_pt_lock(dst_ptl, src_ptl);
 	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
 				 dst_pmd, dst_pmdval)) {
@@ -1167,20 +1241,19 @@ static int move_zeropage_pte(struct mm_struct *mm,
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
@@ -1196,9 +1269,8 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 	struct mmu_notifier_range range;
 	int err = 0;
 
-	flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
-				src_addr, src_addr + PAGE_SIZE);
+				src_addr, src_addr + len);
 	mmu_notifier_invalidate_range_start(&range);
 retry:
 	/*
@@ -1257,7 +1329,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 		if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
 			err = -ENOENT;
 		else /* nothing to do to move a hole */
-			err = 0;
+			err = PAGE_SIZE;
 		goto out;
 	}
 
@@ -1375,10 +1447,13 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 			}
 		}
 
-		err = move_present_pte(mm,  dst_vma, src_vma,
-				       dst_addr, src_addr, dst_pte, src_pte,
-				       orig_dst_pte, orig_src_pte, dst_pmd,
-				       dst_pmdval, dst_ptl, src_ptl, src_folio);
+		err = move_present_ptes(mm, dst_vma, src_vma,
+					dst_addr, src_addr, dst_pte, src_pte,
+					orig_dst_pte, orig_src_pte, dst_pmd,
+					dst_pmdval, dst_ptl, src_ptl, src_folio, len);
+		/* folio is already unlocked by move_present_ptes() */
+		folio_put(src_folio);
+		src_folio = NULL;
 	} else {
 		struct folio *folio = NULL;
 
@@ -1732,7 +1807,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 {
 	struct mm_struct *mm = ctx->mm;
 	struct vm_area_struct *src_vma, *dst_vma;
-	unsigned long src_addr, dst_addr;
+	unsigned long src_addr, dst_addr, src_end;
 	pmd_t *src_pmd, *dst_pmd;
 	long err = -EINVAL;
 	ssize_t moved = 0;
@@ -1777,8 +1852,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 	if (err)
 		goto out_unlock;
 
-	for (src_addr = src_start, dst_addr = dst_start;
-	     src_addr < src_start + len;) {
+	for (src_addr = src_start, dst_addr = dst_start, src_end = src_start + len;
+	     src_addr < src_end;) {
 		spinlock_t *ptl;
 		pmd_t dst_pmdval;
 		unsigned long step_size;
@@ -1865,10 +1940,10 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 				break;
 			}
 
-			err = move_pages_pte(mm, dst_pmd, src_pmd,
-					     dst_vma, src_vma,
-					     dst_addr, src_addr, mode);
-			step_size = PAGE_SIZE;
+			err = move_pages_ptes(mm, dst_pmd, src_pmd,
+					      dst_vma, src_vma, dst_addr,
+					      src_addr, src_end - src_addr, mode);
+			step_size = err;
 		}
 
 		cond_resched();
@@ -1880,7 +1955,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 			break;
 		}
 
-		if (err) {
+		if (err < 0) {
 			if (err == -EAGAIN)
 				continue;
 			break;

base-commit: 260f6f4fda93c8485c8037865c941b42b9cba5d2
-- 
2.50.1.552.g942d659e1b-goog


