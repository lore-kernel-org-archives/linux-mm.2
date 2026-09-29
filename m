Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E915DCA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA2B6B008C; Tue, 29 Sep 2026 17:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3336B0092; Tue, 29 Sep 2026 17:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8629A6B0093; Tue, 29 Sep 2026 17:53:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F15E6B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE6EBA0611
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:18 +0000 (UTC)
X-FDA: 85268151276.20.39F5B6E
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1DA7314000F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HTpqF0Ce;
	spf=pass (imf26.hostedemail.com: domain of 3SzO8agoKCP4torg41goynmuumrk.iusrot03-ssq1giq.uxm@flex--nilayvaish.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=3SzO8agoKCP4torg41goynmuumrk.iusrot03-ssq1giq.uxm@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o1P9WuKoGNZI5bVMLBN5j4pkqMdI5a1cja1/URYfM68=;
	b=2DyNB+5VQfEVUHkpghlN8A63m8HqfBtZXUHMlKSlBnTNa5h03uVFyPK3uwNyQMpXuwPMdi
	JagrVftQrhDr/Co7tJoO3XoNvAQRe844/6AhSjagqVxYoYf/d4bteRQv7s72NurgRcxSfS
	iRiJfUhJ/CZ4faFD7i8g479ulpjHHqQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718797;
	b=AdhTliyhEsL5DfD5p080FbOf1RnQdsjOZZ2mMVyQoXx9wjzJahTh3Rqg2Ioh76UFQF0vih
	0NVmg0xVdTOGfsYazy/ODW5mphzKydnVHHZ7/nOP4aCpVgjXwcZAVwbglf8rWgIaYJCXF2
	ZocQvd04CDd20qEiz7hHxOuQNUAb1EI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HTpqF0Ce;
	spf=pass (imf26.hostedemail.com: domain of 3SzO8agoKCP4torg41goynmuumrk.iusrot03-ssq1giq.uxm@flex--nilayvaish.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=3SzO8agoKCP4torg41goynmuumrk.iusrot03-ssq1giq.uxm@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3441e2b3fc3so3844768eec.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718796; x=1791323596; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o1P9WuKoGNZI5bVMLBN5j4pkqMdI5a1cja1/URYfM68=;
        b=HTpqF0CePS6QRzDoEbM3HsqoaNxgiIk1AWHbwr/h5W27wdrTAkD2fsi2okdOwIpck7
         G8syZbixhTcUJFIObU6+W/bx1vI/vC6ankTp2su+jKzU1k6YFuYPxmg4RzAxxebiqnuX
         q0MlgibuSDuC9637egbOxEu6pjBwTUSuAfObYJ8UdwQkl8/cLpytN/7ykLualMkzswJl
         ecWAsUIIJn7sKsPtvEAT9hASO1Em+RYErbDl7PE5bTKpZbLZCXVKtSkYvaGgvRwGirko
         h0FgNjz7KISz+I79k4KIF2YTdpDhvysvZ4oQbPONsWdC+EWGYARbHK47oduziAbAuzEt
         DiMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718796; x=1791323596;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o1P9WuKoGNZI5bVMLBN5j4pkqMdI5a1cja1/URYfM68=;
        b=S/7LV+MBzOhgHHybZp2s7SRNYWZVqbuE7XbFkXigtl40rvdzGk+Px/M7FUNQGYoTQe
         ojlLAsH4sGxbvjcYspD4oP1h6XQxk/sWgPUSFPyXbATih4ebaVFhl/HvU5R1SF0rwlSL
         cqVHmPwKqjeK/2KCbnaXdze23BLvkybu3Dcby3gPu2dlQH3tEWFSq1e9Bd+GTqMX9Upr
         97C0cceqZbER0gytkNJnvMoTo8UWuvb35XFEcCbtm/iD7Nk9T1mTm95rXXsBxg6Gvcna
         lxVeNtwZebx93hilp/ZTQSt3yZobjUF8mkqUg8zXMwTwlMBXgj+DjsJPIPFjVd/onxdW
         btXA==
X-Forwarded-Encrypted: i=1; AKwUvBxzuwWa+3VuTzexYsBN5B4UEIXN7ARWEkZLlgOmfVwr+jlxkVEVekpM1cfaQOh+0j+aXUlHh3Osxg==@kvack.org
X-Gm-Message-State: AFuF++nDdj7JJaPqLDi6D/WDxvn61fzqR6FpVZ62HCujZXOz9Brp7wHv
	/9+z2W1FA1ECOjvWnG1y1cMyX+nYa1bAfg+4qMcKXWmnBImTSWwL6TNVbX9AuHXtG1xMnx5NDf6
	ZNEjR0zoFgqcRDw9iV6G9Rg==
X-Received: from dlbox7.prod.google.com ([2002:a05:7022:1207:b0:149:432f:988])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701a:c909:b0:14a:725b:7b40 with SMTP id a92af1059eb24-14ca02946f6mr559079c88.44.1790718795504;
 Tue, 29 Sep 2026 14:53:15 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:51:53 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-3-nilayvaish@google.com>
Subject: [PATCH 02/15] mm/huge_memory: use folio_page() in PMD/PUD rmap, zap,
 and migration
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1DA7314000F
X-Stat-Signature: 4q754eecmmjqyfofcc7hhng68w5mzfqa
X-Rspam-User: 
X-HE-Tag: 1790718796-937395
X-HE-Meta: U2FsdGVkX18i/c2Mf4MRN5MA8fS58XNTX1RwDkPRURf1P9eVMtiigCHAXULOXEA8IEJoFRUuEMSjnt1brTGbGHr4e10A0N4vXivLy4P5oOK8hg0hSo231l/XX+mcvzUNuMRmHgkZHwD/obHSFgfVts5gmWV+qTJwa7nx349GJaI7b8T/dkv8O6L96CRrH4Dm1msaq/ssjMYH6fHRp9pa1GprqEZv1ZfAp1q4eBe68WtuWbFXQwdvOeuzTIq7RnaAXHN00/801Jqhg42TCe631swJ0TVWikWpBIVS7U+KH5P4RU9/FN9xYR54WDMGtqoBNKQ0SySl/nH8ZZ3b24DXLs7EdEZ4LWvfg+ALaCK+Z6tPCNQldTP99lcQDgPXlODp7FTJcpht88hHMAZrknANMNTsjqrrpQiZJIXM3l4rj5Ncmw6gy64ZUc+R0N2hOWHYO1kjVsLL3dQ+GXsorVEaDFuIr1+IL++mb114QCx9TO1H8Y3fIEN5BnbFN3ZzQZ4JO86Y0ArgS/5mkbfQfN85EJyhpiI4jp+4C3RURbCAYe8DIEQ+2S8H7HtpJEz+DJO3XdRQUDYcHwm5vc5TAsRPOjotTeIkIMig0z+JXHQDtZzd7Arr6WBtt/GbT0oWcioqOfhcLlNkyUl3iM4NG/N70n5ipvdLh6PVysv9EDVq3zPCDJ/vAsXr9GKGZN11XmEXVrCzHNFnPvOD9afVR+3TjWWq9pjW+bILwGpmuTQJKceCkVGeU/NxUv1Rggp+AK6i/ZTWu+K4egaXIT36DWpsYujT3VTUWY4A7wwq/i8VePydSQgZFk/gSdS7SmHoAv5/NzQOMzSp8Ao2VRJnCSYTuB7qjNZeQi0qt5xR+FuVTu47vpqLRu4Rl5D+f1PCSjiVwl43bKUjnBBB76rpqt+FJNrDW6w5Qk78gpf5g8mbbXkZXWe6+1tIWApQC6uI9E2I7UUB7NvQdPhyPFjnsoM
 dw8jkuAI
 dbizxwQ7lYhRlSBUcLdC94HddU7ixfqaMIk2DC3g+2rt6ZscNIg3tiXO2fIVMnSUbTH/Xfqf3RaYCIoq29gXRzOQZFNprW7ui+zaEnRjCfbKx4uynV+KsRMySxoCi8zpOY0Twdu8/1SFyYpyrUTSGZ0u7XqMxuCTJxVLR8roGfuHhQMmg7ryWryD9NRPs2gQfun7LvPNALN1Cdj7Ek0+ABBtJtFlBHuFHv24lOpoYpUt2jI9V0GnK+YpHaRgsOi+Wrx1EP6Px+SE3+0jSr/0Efa0knMm8noSeV2ccITxY3ZPVSY/Zw+8u0tR4vxDM38KwQ/npqc2wYG2CIjlh1G5K3f/6e1DmMCtH7Gt+30KuBAcBbtCcs3mLyuKKrLgIX1+XkwK+CuntMdMfvbSxM8mnbUf484YY6a4b8o0DAUuBsQyjWgbbi5vvkh33+dHqqprMFJMaT1BNR052CE93CZ+1jjooBTwynTODnlpVMLjeMvrjS0xiQmnsHm4usTcLQRymjMx0KI3gIMVouYGmlJcYLtRGIg1uhAQjzqixNJIKv7GXkJ62gepU8d2ctUJe80/uoGxa0kWOIPHZNEj+N+/SweNwQKl3Grak6eW0blALVUYHqD3b0Pn6jqJStDu0iQAmot5vwLj+1UxWGJFX8jBecCJJuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

Replace direct &folio->page uses with folio_page(folio, 0) in
insert_pmd(), insert_pud(), copy_huge_non_present_pmd(),
zap_huge_pmd_folio(), zap_huge_pmd(), move_pages_huge_pmd(), and
remove_migration_pmd().

No functional change intended.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/huge_memory.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ddc631a388b9..31af817eeded 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1664,7 +1664,8 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 			entry = pmd_mkspecial(entry);
 		} else {
 			folio_get(fop.folio);
-			folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
+			folio_add_file_rmap_pmd(fop.folio,
+						folio_page(fop.folio, 0), vma);
 			add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
 		}
 	} else {
@@ -1786,7 +1787,8 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 		entry = folio_mk_pud(fop.folio, vma->vm_page_prot);
 
 		folio_get(fop.folio);
-		folio_add_file_rmap_pud(fop.folio, &fop.folio->page, vma);
+		folio_add_file_rmap_pud(fop.folio,
+					folio_page(fop.folio, 0), vma);
 		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);
 	} else {
 		entry = pud_mkhuge(pfn_pud(fop.pfn, prot));
@@ -1935,7 +1937,7 @@ static void copy_huge_non_present_pmd(
 		 * folio_try_dup_anon_rmap_pmd does not fail for
 		 * device private entries.
 		 */
-		folio_try_dup_anon_rmap_pmd(src_folio, &src_folio->page,
+		folio_try_dup_anon_rmap_pmd(src_folio, folio_page(src_folio, 0),
 					    dst_vma, src_vma);
 	}
 
@@ -2487,7 +2489,7 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	/* Present and device private folios are rmappable. */
 	if (is_present || is_device_private)
-		folio_remove_rmap_pmd(folio, &folio->page, vma);
+		folio_remove_rmap_pmd(folio, folio_page(folio, 0), vma);
 
 	if (folio_test_anon(folio)) {
 		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
@@ -2572,7 +2574,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	spin_unlock(ptl);
 	if (is_present && folio)
-		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
+		tlb_remove_page_size(tlb, folio_page(folio, 0), HPAGE_PMD_SIZE);
 	return true;
 }
 
@@ -2947,7 +2949,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 	}
 	if (src_folio) {
 		if (folio_maybe_dma_pinned(src_folio) ||
-		    !PageAnonExclusive(&src_folio->page)) {
+		    !PageAnonExclusive(folio_page(src_folio, 0))) {
 			err = -EBUSY;
 			goto unlock_ptls;
 		}
@@ -5186,12 +5188,13 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct folio *folio
 		if (!softleaf_is_migration_read(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
 
-		folio_add_anon_rmap_pmd(folio, &folio->page, vma, haddr, rmap_flags);
+		folio_add_anon_rmap_pmd(folio, folio_page(folio, 0), vma,
+					haddr, rmap_flags);
 	} else {
-		folio_add_file_rmap_pmd(folio, &folio->page, vma);
+		folio_add_file_rmap_pmd(folio, folio_page(folio, 0), vma);
 	}
 	VM_WARN_ON_ONCE(pmd_write(pmde) && folio_test_anon(folio) &&
-			!PageAnonExclusive(&folio->page));
+			!PageAnonExclusive(folio_page(folio, 0)));
 	set_pmd_at(mm, haddr, pvmw->pmd, pmde);
 
 	/* No need to invalidate - it was non-present before */
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


