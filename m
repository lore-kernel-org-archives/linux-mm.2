Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F02EB362E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 795DD6B0005; Mon,  2 Mar 2026 14:13:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742E36B0088; Mon,  2 Mar 2026 14:13:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618406B0089; Mon,  2 Mar 2026 14:13:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5E46B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:13:46 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F183A5820D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:13:45 +0000 (UTC)
X-FDA: 84502072410.03.B1A2D36
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id EB96180012
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:13:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aAafZPbE;
	spf=pass (imf02.hostedemail.com: domain of aleks.koyf@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=aleks.koyf@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772478824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EQRUOv3BL1z616pg6v/L9SeOGUnHb5iZlfnTM/k5JU8=;
	b=te2HihqhPnMVNYjaMIoF0glIqgTsApnoP2f4yPKroUoc8zp4hgW33bBmidMMzh+qmf5ytl
	DILnHMefBYf9B5m60SX94dk5ZdxWQnzjbxrh9/HBE5Q4xVT+bwwIHPqVGilbO5eRq6e0xP
	m/o7zO7PbekQaD38o4XACVKKpGKuVHg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aAafZPbE;
	spf=pass (imf02.hostedemail.com: domain of aleks.koyf@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=aleks.koyf@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772478824; a=rsa-sha256;
	cv=none;
	b=AzuBxaAEgcVzOP2Y/wAPg7RbzQIdYql1Z2Iw2phEbu/Y3JMCsoqcmqp7WgEeMXKG2Up6GT
	Xat7PVcOOo1oCrNilpUbLt52f2g+CxBTK0tEb51nzieNc7+yhdPJs0/SDQqGQ9Drf+lKj8
	tR+mMyrr2vJn0bNN6bYgMI85zijY/4E=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b9382e59c0eso519193566b.0
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772478822; x=1773083622; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EQRUOv3BL1z616pg6v/L9SeOGUnHb5iZlfnTM/k5JU8=;
        b=aAafZPbELrRgxSTxqUKULVJCQqSIQV5YvdbB4ZMKR6vRUrgslylqiocurnKXwZZkvL
         532I6LyoHmurohXGAECSu/EINXXM3KhI5pooqkY8SvXQaucep0tdvbPWJizD0HMBdWC/
         GmFJMRibGXCOmu0oMY0sjw5cTY56Vg1qj5cmqCpb4AI+uvOMLrhO3qGNFu4CbkzjdF4O
         vFtAyqsFWAvln5NPg4LgWBGZVWjrzTJO6K71HXUUWCw5XNYKz8pTpsVWx6oCgMqfyHQR
         xqcg1Ev7edwoCKMzY/ZYFG0Z9ero+u2b3dclKaULbc3DGf1ejhxB1Dwxt1uWu5HMNqDV
         qWTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772478822; x=1773083622;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EQRUOv3BL1z616pg6v/L9SeOGUnHb5iZlfnTM/k5JU8=;
        b=B9bNuUpb3NvS8N/1Hb9W0Qw7v3YtYdSZ/iX8PQYQLIilIMQ5gFEl0voEk7/cVAue2d
         VsGczTz/88u/HdOHVwkloePX2LycuiR9g/5KVM1wBKz5rgZjkWXufFq7Od1YYXSAkv9r
         sqoyUzx6pwBVTtWsw3sVqVZ2nKgAh5Io1XlwfPDrMtD1xXBRTvsLqZKlHVeoANBWW8cd
         X5DX6IxOl0qXImbP5dKSJdDIGmXD6QNjxsl9wY41cBUgG3EOfHvyd7gVNerkKrSZy8BV
         gOj7vYfdqug33DC6Gj2GqlIWW+DkIgPxHXLoO+M1zEJll6Tjx0CFvwdudWFly48P2bGP
         /Qkg==
X-Gm-Message-State: AOJu0YwOzfPN9erMohnEuL0gQp6QfxRcjAjoah4ZeK9RSOCuNTqOpDdd
	HRWPdUyK1/HsVSub1wY3sHudfD89xm9frXINrbfcfAnLasKt/imW3XhZ
X-Gm-Gg: ATEYQzzBr3jKg5fNW30NFIBXV+pAz87Nl3prg9VwEMLUQfR6XPj+3aQiU9hLR7aJb9f
	uxStgfdHeNrd2mJMtH/pQZjWP1fWKRp1bPjf7JLQUove/dNQZqtGoV1HlsYtJ4o9QGcWPdEsw/x
	DKJJQio21tF2ohnib/DsU0HkDxLl134a8UhHI4nczebK8hn9QrmEg+92PkK4GPoUoZRMnoM9UWE
	Bi6IQzry0Hv2wlvuaHnwxlDHEfj+Tmg0e/D81vLlTBE8N5/KyNz63cKhLLY9Kyw8M1mux0b2Ugc
	sRmHuSnYcXpoYFWc7KMe8DX/1t/NA5HOLw+gF07ODxFV9TzDpwOVxzzOio8bOIW93DmamJ5Yj5D
	psRyMCPnHchp5dynUbapLh5YxkSLcjpQPAUirde9YO7+XnbK26/CDZ3Wk/0HKSe54ie8ezBfz1d
	7IW7wr6NJme7U3wsBrjbpVQZij
X-Received: by 2002:a17:907:eccc:b0:b73:6d56:7332 with SMTP id a640c23a62f3a-b937639b9aamr953480766b.13.1772478821772;
        Mon, 02 Mar 2026 11:13:41 -0800 (PST)
Received: from ArchLinux ([89.105.203.98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935ae93348sm497736666b.46.2026.03.02.11.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 11:13:41 -0800 (PST)
From: Alexey Suchkov <aleks.koyf@gmail.com>
X-Google-Original-From: Alexey Suchkov <dywoq.contact@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexey Suchkov <dywoq.contact@gmail.com>
Subject: [PATCH] mm: initialize 'seq' in gup_fast to remove -Wmaybe-uninitialized warning
Date: Mon,  2 Mar 2026 22:12:37 +0300
Message-ID: <20260302191237.34375-1-dywoq.contact@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EB96180012
X-Stat-Signature: ab6o86sk7xk1ub6xrxmsa1cuwzdi5jn5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772478823-908014
X-HE-Meta: U2FsdGVkX189V+kgqxabMr+bzgeEu0Hu6MSfJYtuV3FAfBEplMDx1SwYdpydycR4FVs4w8O9X57bWMIBCfIYZZmgRDSrM2YV1RDpzyZDWo+lt0LKrcSMH+G5AWg3W4806TLcmk5xS62klDfvwVFRC/FSZ1cTa15YoMY92vWeGDhfosqM3YseA+ed/MmXaz3R8twrSob7ViBAVDgJmmK/9d66IDUis8dqfOuqLvB8kK+BWFjaAoHy3Lm/JGMpCSCw9kI0pZZRENdOhGgRCuoU+wyf37rJBuLu8YATaWTRjQobLZPF7ag/KV3BrTWC5aUEvYvvq0WwtycKXX5ihQo5xVwIJYBs+fMKeJRUDPAWePYGIC82nennGKKBIWMgvPmQnQ7lQLCE65K6iUw+PF3Gvy+ruw4JZy6dJLLRBPMjpTP7rI9Abi2BaiCgnpLr4v7Yt9y4vKS8sQozoPFPUujk5S8Zo91hzqTU1wkuyw6WFohws34WgnUfk7h6iRx8L7MI0dhzOUpfo6yJs9KPMg2DmeRtWZ9uCfUhr8iDz84mYZfFjEutlsNJ6tg09cEt0Gn8Mte3WWZMgV8QxyKtvT81m5Fo+UPisfwPE7tXjv5m9C5zcasTmNVyiUuIGfIV879n0IpZJRpw/gokGUgIbeB8Zwg8/1lMQPEeiVSJRphfZRBQSwpRarXw2gkWYqFyNmnTjRh3TcVo3HgQ9+77wBSuFsLEU69nunsLjrTqMrzPAL0RpGWs+6YP2325nEZs0FcoaKNRmT5yn20OLwPFIcGwuwDLUYF9G2wM6Ww9OtIAVixhE2LhyX5L1tte9bbo/0uTvkinyYJ668NQMT5ooMOz8Cp45YByHaSvDNTRkg+hKsCRSHu08XKWyTgnUkowsi8W+aRIGbH+yXfARglK/BUCpt/rqzF8t1d2D4KZr5R4NN0vxLw5rLyBbnrSM5MXfBnVwSQFUWOgD7BM62coyIg
 wNhTXEXy
 lJwLaore1ikZpYFzIcBJ6xphk2a4mDj7vVHAcTF6uH0jAF0k+o0OQjLUWbqic7jth8XBlNjPGPMZswAP5T2AzlFItSgk+/ymb86rvjRtSX1jTjnwTpHY236oWEWJ4l88v5JkAnaaKFdZuURllYGhglXRys+qNgrLuUJ0NzHITzTO1zQQ+BwLQWQ41/zrhnebrD3pDHD6mSK/Ng1MuFLARxvt6YUHbjjR+5+KjZyYEyBUlERvmSW4yeokQ8EUhSPgtKiinOMxNfHix/V4sRqGllJXoadIMOyDSfxfXBr3fL27b/LgfRhJDmA8OVxXEW9bB5HZ5hwYNKd5jqHjVj9uUmpBYtiOEFx61dlmlCvfmBhYby3GrWJLMjySgFWySNTl7SLauC4kWW69mlhk1zX9GhHKVUDkXzKZ2nScLn7eudngrgHOemFXpWeIywPFhseMf6xQQPn7EmV+CLFjKKsVHPxRzZ6+B3YlJio4x2MFr9ZqIkY3MEfotZOtHH6mluus43XP3gIvywH9J8QeJprl8TmT4B56tJ0yewMXBnqGYueEnHncUy2J/LwrlFwEmamityLyQGb/e6hDbctTsmdKZT7dDYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The local variable 'seq' in gup_fast (mm/gup.c) was declared
without initialization, which can trigger:

mm/gup.c:3165:20: warning: ‘seq’ may be used uninitialized [-Wmaybe-uninitialized]

Initialize 'seq' to 0. This does not change behavior, since
read_seqcount_retry() always writes to it before use.

Signed-off-by: Alexey Suchkov <dywoq.contact@gmail.com>
---
 mm/gup.c | 291 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 146 insertions(+), 145 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 8e7dc2c6e..2553e5110 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -55,15 +55,16 @@ static inline void sanity_check_pinned_pages(struct page **pages,
 
 		folio = page_folio(page);
 
-		if (is_zero_page(page) ||
-		    !folio_test_anon(folio))
+		if (is_zero_page(page) || !folio_test_anon(folio))
 			continue;
 		if (!folio_test_large(folio) || folio_test_hugetlb(folio))
-			VM_WARN_ON_ONCE_FOLIO(!PageAnonExclusive(&folio->page), folio);
+			VM_WARN_ON_ONCE_FOLIO(!PageAnonExclusive(&folio->page),
+					      folio);
 		else
 			/* Either a PTE-mapped or a PMD-mapped THP. */
 			VM_WARN_ON_ONCE_PAGE(!PageAnonExclusive(&folio->page) &&
-					     !PageAnonExclusive(page), page);
+						     !PageAnonExclusive(page),
+					     page);
 	}
 }
 
@@ -230,7 +231,9 @@ void folio_add_pin(struct folio *folio)
 }
 
 static inline struct folio *gup_folio_range_next(struct page *start,
-		unsigned long npages, unsigned long i, unsigned int *ntails)
+						 unsigned long npages,
+						 unsigned long i,
+						 unsigned int *ntails)
 {
 	struct page *next = start + i;
 	struct folio *folio = page_folio(next);
@@ -245,7 +248,9 @@ static inline struct folio *gup_folio_range_next(struct page *start,
 }
 
 static inline struct folio *gup_folio_next(struct page **list,
-		unsigned long npages, unsigned long i, unsigned int *ntails)
+					   unsigned long npages,
+					   unsigned long i,
+					   unsigned int *ntails)
 {
 	struct folio *folio = page_folio(list[i]);
 	unsigned int nr;
@@ -566,8 +571,7 @@ static struct folio *try_grab_folio_fast(struct page *page, int refs,
 	if (folio_has_pincount(folio))
 		atomic_add(refs, &folio->_pincount);
 	else
-		folio_ref_add(folio,
-				refs * (GUP_PIN_COUNTING_BIAS - 1));
+		folio_ref_add(folio, refs * (GUP_PIN_COUNTING_BIAS - 1));
 	/*
 	 * Adjust the pincount before re-checking the PTE for changes.
 	 * This is essentially a smp_mb() and is paired with a memory
@@ -579,11 +583,12 @@ static struct folio *try_grab_folio_fast(struct page *page, int refs,
 
 	return folio;
 }
-#endif	/* CONFIG_HAVE_GUP_FAST */
+#endif /* CONFIG_HAVE_GUP_FAST */
 
 /* Common code for can_follow_write_* */
 static inline bool can_follow_write_common(struct page *page,
-		struct vm_area_struct *vma, unsigned int flags)
+					   struct vm_area_struct *vma,
+					   unsigned int flags)
 {
 	/* Maybe FOLL_FORCE is set to override it? */
 	if (!(flags & FOLL_FORCE))
@@ -647,8 +652,8 @@ static inline bool can_follow_write_pud(pud_t pud, struct page *page,
 }
 
 static struct page *follow_huge_pud(struct vm_area_struct *vma,
-				    unsigned long addr, pud_t *pudp,
-				    int flags, unsigned long *page_mask)
+				    unsigned long addr, pud_t *pudp, int flags,
+				    unsigned long *page_mask)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct page *page;
@@ -726,7 +731,8 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 		return ERR_PTR(-EMLINK);
 
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
-			     !PageAnonExclusive(page), page);
+				     !PageAnonExclusive(page),
+			     page);
 
 	ret = try_grab_folio(page_folio(page), 1, flags);
 	if (ret)
@@ -735,7 +741,7 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (pmd_trans_huge(pmdval) && (flags & FOLL_TOUCH))
 		touch_pmd(vma, addr, pmd, flags & FOLL_WRITE);
-#endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	*page_mask = HPAGE_PMD_NR - 1;
@@ -743,10 +749,10 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 	return page;
 }
 
-#else  /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
+#else /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
 static struct page *follow_huge_pud(struct vm_area_struct *vma,
-				    unsigned long addr, pud_t *pudp,
-				    int flags, unsigned long *page_mask)
+				    unsigned long addr, pud_t *pudp, int flags,
+				    unsigned long *page_mask)
 {
 	return NULL;
 }
@@ -758,10 +764,10 @@ static struct page *follow_huge_pmd(struct vm_area_struct *vma,
 {
 	return NULL;
 }
-#endif	/* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
+#endif /* CONFIG_PGTABLE_HAS_HUGE_LEAVES */
 
 static int follow_pfn_pte(struct vm_area_struct *vma, unsigned long address,
-		pte_t *pte, unsigned int flags)
+			  pte_t *pte, unsigned int flags)
 {
 	if (flags & FOLL_TOUCH) {
 		pte_t orig_entry = ptep_get(pte);
@@ -800,7 +806,8 @@ static inline bool can_follow_write_pte(pte_t pte, struct page *page,
 }
 
 static struct page *follow_page_pte(struct vm_area_struct *vma,
-		unsigned long address, pmd_t *pmd, unsigned int flags)
+				    unsigned long address, pmd_t *pmd,
+				    unsigned int flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct folio *folio;
@@ -852,7 +859,8 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	}
 
 	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
-			     !PageAnonExclusive(page), page);
+				     !PageAnonExclusive(page),
+			     page);
 
 	/* try_grab_folio() does nothing unless FOLL_GET or FOLL_PIN is set. */
 	ret = try_grab_folio(folio, 1, flags);
@@ -875,8 +883,8 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 		}
 	}
 	if (flags & FOLL_TOUCH) {
-		if ((flags & FOLL_WRITE) &&
-		    !pte_dirty(pte) && !folio_test_dirty(folio))
+		if ((flags & FOLL_WRITE) && !pte_dirty(pte) &&
+		    !folio_test_dirty(folio))
 			folio_mark_dirty(folio);
 		/*
 		 * pte_mkyoung() would be more correct here, but atomic care
@@ -931,8 +939,9 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 		spin_unlock(ptl);
 		split_huge_pmd(vma, pmd, address);
 		/* If pmd was left empty, stuff a page table in there quickly */
-		return pte_alloc(mm, pmd) ? ERR_PTR(-ENOMEM) :
-			follow_page_pte(vma, address, pmd, flags);
+		return pte_alloc(mm, pmd) ?
+			       ERR_PTR(-ENOMEM) :
+			       follow_page_pte(vma, address, pmd, flags);
 	}
 	page = follow_huge_pmd(vma, address, pmd, flags, page_mask);
 	spin_unlock(ptl);
@@ -1005,8 +1014,8 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
  * by a page descriptor (see also vm_normal_page()).
  */
 static struct page *follow_page_mask(struct vm_area_struct *vma,
-			      unsigned long address, unsigned int flags,
-			      unsigned long *page_mask)
+				     unsigned long address, unsigned int flags,
+				     unsigned long *page_mask)
 {
 	pgd_t *pgd;
 	struct mm_struct *mm = vma->vm_mm;
@@ -1028,8 +1037,8 @@ static struct page *follow_page_mask(struct vm_area_struct *vma,
 }
 
 static int get_gate_page(struct mm_struct *mm, unsigned long address,
-		unsigned int gup_flags, struct vm_area_struct **vma,
-		struct page **page)
+			 unsigned int gup_flags, struct vm_area_struct **vma,
+			 struct page **page)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -1084,9 +1093,8 @@ static int get_gate_page(struct mm_struct *mm, unsigned long address,
  * FOLL_NOWAIT, the mmap_lock may be released.  If it is, *@locked will be set
  * to 0 and -EBUSY returned.
  */
-static int faultin_page(struct vm_area_struct *vma,
-		unsigned long address, unsigned int flags, bool unshare,
-		int *locked)
+static int faultin_page(struct vm_area_struct *vma, unsigned long address,
+			unsigned int flags, bool unshare, int *locked)
 {
 	unsigned int fault_flags = 0;
 	vm_fault_t ret;
@@ -1220,8 +1228,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 		return -EFAULT;
 
 	if (write) {
-		if (!vma_anon &&
-		    !writable_file_mapping_allowed(vma, gup_flags))
+		if (!vma_anon && !writable_file_mapping_allowed(vma, gup_flags))
 			return -EFAULT;
 
 		if (!(vm_flags & VM_WRITE) || (vm_flags & VM_SHADOW_STACK)) {
@@ -1263,7 +1270,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
  * historically expanded the stack in the GUP code.
  */
 static struct vm_area_struct *gup_vma_lookup(struct mm_struct *mm,
-	 unsigned long addr)
+					     unsigned long addr)
 {
 #ifdef CONFIG_STACK_GROWSUP
 	return vma_lookup(mm, addr);
@@ -1283,15 +1290,16 @@ static struct vm_area_struct *gup_vma_lookup(struct mm_struct *mm,
 		return NULL;
 
 	/* Let's not warn more than once an hour.. */
-	now = jiffies; next = next_warn;
+	now = jiffies;
+	next = next_warn;
 	if (next && time_before(now, next))
 		return NULL;
-	next_warn = now + 60*60*HZ;
+	next_warn = now + 60 * 60 * HZ;
 
 	/* Let people know things may have changed. */
 	pr_warn("GUP no longer grows the stack in %s (%d): %lx-%lx (%lx)\n",
-		current->comm, task_pid_nr(current),
-		vma->vm_start, vma->vm_end, addr);
+		current->comm, task_pid_nr(current), vma->vm_start, vma->vm_end,
+		addr);
 	dump_stack();
 	return NULL;
 #endif
@@ -1351,10 +1359,9 @@ static struct vm_area_struct *gup_vma_lookup(struct mm_struct *mm,
  * instead of __get_user_pages. __get_user_pages should be used only if
  * you need some special @gup_flags.
  */
-static long __get_user_pages(struct mm_struct *mm,
-		unsigned long start, unsigned long nr_pages,
-		unsigned int gup_flags, struct page **pages,
-		int *locked)
+static long __get_user_pages(struct mm_struct *mm, unsigned long start,
+			     unsigned long nr_pages, unsigned int gup_flags,
+			     struct page **pages, int *locked)
 {
 	long ret = 0, i = 0;
 	struct vm_area_struct *vma = NULL;
@@ -1396,8 +1403,8 @@ static long __get_user_pages(struct mm_struct *mm,
 			vma = gup_vma_lookup(mm, start);
 			if (!vma && in_gate_area(mm, start)) {
 				ret = get_gate_page(mm, start & PAGE_MASK,
-						gup_flags, &vma,
-						pages ? &page : NULL);
+						    gup_flags, &vma,
+						    pages ? &page : NULL);
 				if (ret)
 					goto out;
 				page_mask = 0;
@@ -1496,7 +1503,8 @@ static long __get_user_pages(struct mm_struct *mm,
 			for (j = 0; j < page_increm; j++) {
 				subpage = page + j;
 				pages[i + j] = subpage;
-				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
+				flush_anon_page(vma, subpage,
+						start + j * PAGE_SIZE);
 				flush_dcache_page(subpage);
 			}
 		}
@@ -1512,7 +1520,7 @@ static long __get_user_pages(struct mm_struct *mm,
 static bool vma_permits_fault(struct vm_area_struct *vma,
 			      unsigned int fault_flags)
 {
-	bool write   = !!(fault_flags & FAULT_FLAG_WRITE);
+	bool write = !!(fault_flags & FAULT_FLAG_WRITE);
 	bool foreign = !!(fault_flags & FAULT_FLAG_REMOTE);
 	vm_flags_t vm_flags = write ? VM_WRITE : VM_READ;
 
@@ -1561,9 +1569,8 @@ static bool vma_permits_fault(struct vm_area_struct *vma,
  * This function will not return with an unlocked mmap_lock. So it has not the
  * same semantics wrt the @mm->mmap_lock as does filemap_fault().
  */
-int fixup_user_fault(struct mm_struct *mm,
-		     unsigned long address, unsigned int fault_flags,
-		     bool *unlocked)
+int fixup_user_fault(struct mm_struct *mm, unsigned long address,
+		     unsigned int fault_flags, bool *unlocked)
 {
 	struct vm_area_struct *vma;
 	vm_fault_t ret;
@@ -1646,12 +1653,10 @@ static bool gup_signal_pending(unsigned int flags)
  * Please note that this function, unlike __get_user_pages(), will not return 0
  * for nr_pages > 0, unless FOLL_NOWAIT is used.
  */
-static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
-						unsigned long start,
-						unsigned long nr_pages,
-						struct page **pages,
-						int *locked,
-						unsigned int flags)
+static __always_inline long
+__get_user_pages_locked(struct mm_struct *mm, unsigned long start,
+			unsigned long nr_pages, struct page **pages,
+			int *locked, unsigned int flags)
 {
 	long ret, pages_done;
 	bool must_unlock = false;
@@ -1668,8 +1673,7 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 			return -EAGAIN;
 		must_unlock = true;
 		*locked = 1;
-	}
-	else
+	} else
 		mmap_assert_locked(mm);
 
 	if (flags & FOLL_PIN)
@@ -1749,8 +1753,8 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
 		}
 
 		*locked = 1;
-		ret = __get_user_pages(mm, start, 1, flags | FOLL_TRIED,
-				       pages, locked);
+		ret = __get_user_pages(mm, start, 1, flags | FOLL_TRIED, pages,
+				       locked);
 		if (!*locked) {
 			/* Continue to retry until we succeeded */
 			VM_WARN_ON_ONCE(ret != 0);
@@ -1810,8 +1814,8 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
  * If @locked is non-NULL, it must held for read only and may be
  * released.  If it's released, *@locked will be set to 0.
  */
-long populate_vma_page_range(struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, int *locked)
+long populate_vma_page_range(struct vm_area_struct *vma, unsigned long start,
+			     unsigned long end, int *locked)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long nr_pages = (end - start) / PAGE_SIZE;
@@ -1822,7 +1826,7 @@ long populate_vma_page_range(struct vm_area_struct *vma,
 	VM_WARN_ON_ONCE(!PAGE_ALIGNED(start));
 	VM_WARN_ON_ONCE(!PAGE_ALIGNED(end));
 	VM_WARN_ON_ONCE_VMA(start < vma->vm_start, vma);
-	VM_WARN_ON_ONCE_VMA(end   > vma->vm_end, vma);
+	VM_WARN_ON_ONCE_VMA(end > vma->vm_end, vma);
 	mmap_assert_locked(mm);
 
 	/*
@@ -1857,8 +1861,8 @@ long populate_vma_page_range(struct vm_area_struct *vma,
 	 * We made sure addr is within a VMA, so the following will
 	 * not result in a stack expansion that recurses back here.
 	 */
-	ret = __get_user_pages(mm, start, nr_pages, gup_flags,
-			       NULL, locked ? locked : &local_locked);
+	ret = __get_user_pages(mm, start, nr_pages, gup_flags, NULL,
+			       locked ? locked : &local_locked);
 	lru_add_drain();
 	return ret;
 }
@@ -1964,7 +1968,7 @@ int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 		if (ret < 0) {
 			if (ignore_errors) {
 				ret = 0;
-				continue;	/* continue at next VMA */
+				continue; /* continue at next VMA */
 			}
 			break;
 		}
@@ -1973,12 +1977,12 @@ int __mm_populate(unsigned long start, unsigned long len, int ignore_errors)
 	}
 	if (locked)
 		mmap_read_unlock(mm);
-	return ret;	/* 0 or negative error code */
+	return ret; /* 0 or negative error code */
 }
 #else /* CONFIG_MMU */
 static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
-		unsigned long nr_pages, struct page **pages,
-		int *locked, unsigned int foll_flags)
+				    unsigned long nr_pages, struct page **pages,
+				    int *locked, unsigned int foll_flags)
 {
 	struct vm_area_struct *vma;
 	bool must_unlock = false;
@@ -2002,10 +2006,10 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 	/* calculate required read or write permissions.
 	 * If FOLL_FORCE is set, we only require the "MAY" flags.
 	 */
-	vm_flags  = (foll_flags & FOLL_WRITE) ?
-			(VM_WRITE | VM_MAYWRITE) : (VM_READ | VM_MAYREAD);
-	vm_flags &= (foll_flags & FOLL_FORCE) ?
-			(VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
+	vm_flags = (foll_flags & FOLL_WRITE) ? (VM_WRITE | VM_MAYWRITE) :
+					       (VM_READ | VM_MAYREAD);
+	vm_flags &= (foll_flags & FOLL_FORCE) ? (VM_MAYREAD | VM_MAYWRITE) :
+						(VM_READ | VM_WRITE);
 
 	for (i = 0; i < nr_pages; i++) {
 		vma = find_vma(mm, start);
@@ -2031,7 +2035,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 		*locked = 0;
 	}
 
-	return i ? : -EFAULT;
+	return i ?: -EFAULT;
 }
 #endif /* !CONFIG_MMU */
 
@@ -2055,7 +2059,8 @@ size_t fault_in_writeable(char __user *uaddr, size_t size)
 		return size;
 
 	/* Stop once we overflow to 0. */
-	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+	for (cur = start; cur && cur < end;
+	     cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
 		unsafe_put_user(0, (char __user *)cur, out);
 out:
 	user_write_access_end();
@@ -2125,7 +2130,8 @@ size_t fault_in_safe_writeable(const char __user *uaddr, size_t size)
 
 	mmap_read_lock(mm);
 	/* Stop once we overflow to 0. */
-	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+	for (cur = start; cur && cur < end;
+	     cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
 		if (fixup_user_fault(mm, cur, FAULT_FLAG_WRITE, &unlocked))
 			break;
 	mmap_read_unlock(mm);
@@ -2157,7 +2163,8 @@ size_t fault_in_readable(const char __user *uaddr, size_t size)
 		return size;
 
 	/* Stop once we overflow to 0. */
-	for (cur = start; cur && cur < end; cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
+	for (cur = start; cur && cur < end;
+	     cur = PAGE_ALIGN_DOWN(cur + PAGE_SIZE))
 		unsafe_get_user(c, (const char __user *)cur, out);
 out:
 	user_read_access_end();
@@ -2235,7 +2242,8 @@ static void pofs_unpin(struct pages_or_folios *pofs)
 }
 
 static struct folio *pofs_next_folio(struct folio *folio,
-		struct pages_or_folios *pofs, long *index_ptr)
+				     struct pages_or_folios *pofs,
+				     long *index_ptr)
 {
 	long i = *index_ptr + 1;
 
@@ -2262,9 +2270,9 @@ static struct folio *pofs_next_folio(struct folio *folio,
 /*
  * Returns the number of collected folios. Return value is always >= 0.
  */
-static unsigned long collect_longterm_unpinnable_folios(
-		struct list_head *movable_folio_list,
-		struct pages_or_folios *pofs)
+static unsigned long
+collect_longterm_unpinnable_folios(struct list_head *movable_folio_list,
+				   struct pages_or_folios *pofs)
 {
 	unsigned long collected = 0;
 	struct folio *folio;
@@ -2273,7 +2281,6 @@ static unsigned long collect_longterm_unpinnable_folios(
 
 	for (folio = pofs_get_folio(pofs, i); folio;
 	     folio = pofs_next_folio(folio, pofs, &i)) {
-
 		if (folio_is_longterm_pinnable(folio))
 			continue;
 
@@ -2288,14 +2295,14 @@ static unsigned long collect_longterm_unpinnable_folios(
 		}
 
 		if (drained == 0 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
+		    folio_ref_count(folio) !=
+			    folio_expected_ref_count(folio) + 1) {
 			lru_add_drain();
 			drained = 1;
 		}
 		if (drained == 1 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
+		    folio_ref_count(folio) !=
+			    folio_expected_ref_count(folio) + 1) {
 			lru_add_drain_all();
 			drained = 2;
 		}
@@ -2388,8 +2395,8 @@ check_and_migrate_movable_pages_or_folios(struct pages_or_folios *pofs)
 	LIST_HEAD(movable_folio_list);
 	unsigned long collected;
 
-	collected = collect_longterm_unpinnable_folios(&movable_folio_list,
-						       pofs);
+	collected =
+		collect_longterm_unpinnable_folios(&movable_folio_list, pofs);
 	if (!collected)
 		return 0;
 
@@ -2462,12 +2469,9 @@ static long check_and_migrate_movable_folios(unsigned long nr_folios,
  * __gup_longterm_locked() is a wrapper for __get_user_pages_locked which
  * allows us to process the FOLL_LONGTERM flag.
  */
-static long __gup_longterm_locked(struct mm_struct *mm,
-				  unsigned long start,
-				  unsigned long nr_pages,
-				  struct page **pages,
-				  int *locked,
-				  unsigned int gup_flags)
+static long __gup_longterm_locked(struct mm_struct *mm, unsigned long start,
+				  unsigned long nr_pages, struct page **pages,
+				  int *locked, unsigned int gup_flags)
 {
 	unsigned int flags;
 	long rc, nr_pinned_pages;
@@ -2478,9 +2482,8 @@ static long __gup_longterm_locked(struct mm_struct *mm,
 
 	flags = memalloc_pin_save();
 	do {
-		nr_pinned_pages = __get_user_pages_locked(mm, start, nr_pages,
-							  pages, locked,
-							  gup_flags);
+		nr_pinned_pages = __get_user_pages_locked(
+			mm, start, nr_pages, pages, locked, gup_flags);
 		if (nr_pinned_pages <= 0) {
 			rc = nr_pinned_pages;
 			break;
@@ -2527,7 +2530,8 @@ static bool is_valid_gup_args(struct page **pages, int *locked,
 		return false;
 
 	/* LONGTERM can only be specified when pinning */
-	if (WARN_ON_ONCE(!(gup_flags & FOLL_PIN) && (gup_flags & FOLL_LONGTERM)))
+	if (WARN_ON_ONCE(!(gup_flags & FOLL_PIN) &&
+			 (gup_flags & FOLL_LONGTERM)))
 		return false;
 
 	/* Pages input must be given if using GET/PIN */
@@ -2600,10 +2604,9 @@ static bool is_valid_gup_args(struct page **pages, int *locked,
  * should use get_user_pages_remote because it cannot pass
  * FAULT_FLAG_ALLOW_RETRY to handle_mm_fault.
  */
-long get_user_pages_remote(struct mm_struct *mm,
-		unsigned long start, unsigned long nr_pages,
-		unsigned int gup_flags, struct page **pages,
-		int *locked)
+long get_user_pages_remote(struct mm_struct *mm, unsigned long start,
+			   unsigned long nr_pages, unsigned int gup_flags,
+			   struct page **pages, int *locked)
 {
 	int local_locked = 1;
 
@@ -2618,10 +2621,9 @@ long get_user_pages_remote(struct mm_struct *mm,
 EXPORT_SYMBOL(get_user_pages_remote);
 
 #else /* CONFIG_MMU */
-long get_user_pages_remote(struct mm_struct *mm,
-			   unsigned long start, unsigned long nr_pages,
-			   unsigned int gup_flags, struct page **pages,
-			   int *locked)
+long get_user_pages_remote(struct mm_struct *mm, unsigned long start,
+			   unsigned long nr_pages, unsigned int gup_flags,
+			   struct page **pages, int *locked)
 {
 	return 0;
 }
@@ -2827,8 +2829,8 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
  * pmdp_collapse_flush() in the THP collapse code path).
  */
 static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+			      unsigned long end, unsigned int flags,
+			      struct page **pages, int *nr)
 {
 	int ret = 0;
 	pte_t *ptep, *ptem;
@@ -2914,16 +2916,16 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
  * useful to have gup_fast_pmd_leaf even if we can't operate on ptes.
  */
 static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+			      unsigned long end, unsigned int flags,
+			      struct page **pages, int *nr)
 {
 	return 0;
 }
 #endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
 
 static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+			     unsigned long end, unsigned int flags,
+			     struct page **pages, int *nr)
 {
 	struct page *page;
 	struct folio *folio;
@@ -2965,8 +2967,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 }
 
 static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+			     unsigned long end, unsigned int flags,
+			     struct page **pages, int *nr)
 {
 	struct page *page;
 	struct folio *folio;
@@ -3009,8 +3011,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
 }
 
 static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+			      unsigned long end, unsigned int flags,
+			      struct page **pages, int *nr)
 {
 	unsigned long next;
 	pmd_t *pmdp;
@@ -3029,7 +3031,7 @@ static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
 				return 0;
 
 			if (!gup_fast_pmd_leaf(pmd, pmdp, addr, next, flags,
-				pages, nr))
+					       pages, nr))
 				return 0;
 
 		} else if (!gup_fast_pte_range(pmd, pmdp, addr, next, flags,
@@ -3041,8 +3043,8 @@ static int gup_fast_pmd_range(pud_t *pudp, pud_t pud, unsigned long addr,
 }
 
 static int gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+			      unsigned long end, unsigned int flags,
+			      struct page **pages, int *nr)
 {
 	unsigned long next;
 	pud_t *pudp;
@@ -3067,8 +3069,8 @@ static int gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
 }
 
 static int gup_fast_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages,
-		int *nr)
+			      unsigned long end, unsigned int flags,
+			      struct page **pages, int *nr)
 {
 	unsigned long next;
 	p4d_t *p4dp;
@@ -3081,8 +3083,8 @@ static int gup_fast_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr,
 		if (!p4d_present(p4d))
 			return 0;
 		BUILD_BUG_ON(p4d_leaf(p4d));
-		if (!gup_fast_pud_range(p4dp, p4d, addr, next, flags,
-					pages, nr))
+		if (!gup_fast_pud_range(p4dp, p4d, addr, next, flags, pages,
+					nr))
 			return 0;
 	} while (p4dp++, addr = next, addr != end);
 
@@ -3090,7 +3092,7 @@ static int gup_fast_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr,
 }
 
 static void gup_fast_pgd_range(unsigned long addr, unsigned long end,
-		unsigned int flags, struct page **pages, int *nr)
+			       unsigned int flags, struct page **pages, int *nr)
 {
 	unsigned long next;
 	pgd_t *pgdp;
@@ -3103,14 +3105,15 @@ static void gup_fast_pgd_range(unsigned long addr, unsigned long end,
 		if (pgd_none(pgd))
 			return;
 		BUILD_BUG_ON(pgd_leaf(pgd));
-		if (!gup_fast_p4d_range(pgdp, pgd, addr, next, flags,
-					pages, nr))
+		if (!gup_fast_p4d_range(pgdp, pgd, addr, next, flags, pages,
+					nr))
 			return;
 	} while (pgdp++, addr = next, addr != end);
 }
 #else
 static inline void gup_fast_pgd_range(unsigned long addr, unsigned long end,
-		unsigned int flags, struct page **pages, int *nr)
+				      unsigned int flags, struct page **pages,
+				      int *nr)
 {
 }
 #endif /* CONFIG_HAVE_GUP_FAST */
@@ -3127,18 +3130,19 @@ static bool gup_fast_permitted(unsigned long start, unsigned long end)
 #endif
 
 static unsigned long gup_fast(unsigned long start, unsigned long end,
-		unsigned int gup_flags, struct page **pages)
+			      unsigned int gup_flags, struct page **pages)
 {
 	unsigned long flags;
 	int nr_pinned = 0;
-	unsigned seq;
+	unsigned int seq = 0;
 
 	if (!IS_ENABLED(CONFIG_HAVE_GUP_FAST) ||
 	    !gup_fast_permitted(start, end))
 		return 0;
 
 	if (gup_flags & FOLL_PIN) {
-		if (!raw_seqcount_try_begin(&current->mm->write_protect_seq, seq))
+		if (!raw_seqcount_try_begin(&current->mm->write_protect_seq,
+					    seq))
 			return 0;
 	}
 
@@ -3173,17 +3177,17 @@ static unsigned long gup_fast(unsigned long start, unsigned long end,
 }
 
 static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
-		unsigned int gup_flags, struct page **pages)
+			     unsigned int gup_flags, struct page **pages)
 {
 	unsigned long len, end;
 	unsigned long nr_pinned;
 	int locked = 0;
 	int ret;
 
-	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
-				       FOLL_FORCE | FOLL_PIN | FOLL_GET |
-				       FOLL_FAST_ONLY | FOLL_NOFAULT |
-				       FOLL_PCI_P2PDMA | FOLL_HONOR_NUMA_FAULT)))
+	if (WARN_ON_ONCE(gup_flags &
+			 ~(FOLL_WRITE | FOLL_LONGTERM | FOLL_FORCE | FOLL_PIN |
+			   FOLL_GET | FOLL_FAST_ONLY | FOLL_NOFAULT |
+			   FOLL_PCI_P2PDMA | FOLL_HONOR_NUMA_FAULT)))
 		return -EINVAL;
 
 	if (gup_flags & FOLL_PIN)
@@ -3339,10 +3343,9 @@ EXPORT_SYMBOL_GPL(pin_user_pages_fast);
  * Note that if a zero_page is amongst the returned pages, it will not have
  * pins in it and unpin_user_page*() will not remove pins from it.
  */
-long pin_user_pages_remote(struct mm_struct *mm,
-			   unsigned long start, unsigned long nr_pages,
-			   unsigned int gup_flags, struct page **pages,
-			   int *locked)
+long pin_user_pages_remote(struct mm_struct *mm, unsigned long start,
+			   unsigned long nr_pages, unsigned int gup_flags,
+			   struct page **pages, int *locked)
 {
 	int local_locked = 1;
 
@@ -3380,8 +3383,8 @@ long pin_user_pages(unsigned long start, unsigned long nr_pages,
 
 	if (!is_valid_gup_args(pages, NULL, &gup_flags, FOLL_PIN))
 		return 0;
-	return __gup_longterm_locked(current->mm, start, nr_pages,
-				     pages, &locked, gup_flags);
+	return __gup_longterm_locked(current->mm, start, nr_pages, pages,
+				     &locked, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages);
 
@@ -3480,10 +3483,8 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 			 * reason, we try to allocate them and add them to the
 			 * page cache.
 			 */
-			nr_found = filemap_get_folios_contig(memfd->f_mapping,
-							     &start_idx,
-							     end_idx,
-							     &fbatch);
+			nr_found = filemap_get_folios_contig(
+				memfd->f_mapping, &start_idx, end_idx, &fbatch);
 			if (folio) {
 				folio_put(folio);
 				folio = NULL;
-- 
2.53.0


