Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 359D4FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A217F6B009D; Mon, 27 Apr 2026 11:44:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D2096B009E; Mon, 27 Apr 2026 11:44:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1866B009F; Mon, 27 Apr 2026 11:44:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7410A6B009D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:44:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 547A143301
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:53 +0000 (UTC)
X-FDA: 84704736186.05.F0BBB38
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 50D5740014
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="g3/9eQXm";
	spf=pass (imf17.hostedemail.com: domain of 3VYLvaQgKCG4MdPN+SUfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VYLvaQgKCG4MdPN+SUfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XTH9nHu8rDITPKAJB2BnahRrdCbOr3wfwwaQ1ZOWZK8=;
	b=pAaV978FlCErNYzqiY4Jjv/vmqSpQRgXmLWqFbyaxiVUOdAXIrgnJ7SJl2AO4DztMHnvP3
	+6cUb/tOIVnPhVIfBRBgcfR36/0xVoEp4LrYY93chdAG2udGmpe23RBCTE5YHH7G2goFZn
	VgV2v8yeSgFkhMzTkEnJMWjukya/9ug=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="g3/9eQXm";
	spf=pass (imf17.hostedemail.com: domain of 3VYLvaQgKCG4MdPN+SUfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VYLvaQgKCG4MdPN+SUfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304151; a=rsa-sha256;
	cv=none;
	b=skwroKjIBOvzRVvRIOYQ+tOe2Pdo8pNmn6/9B+ochMDAzSXyDmjwbYFAcvJiLdoMO8cGbk
	19DYJvIDm38wsHl3VwHIwHxeCT9uXj47bJu7fjGSmzeh0HQUmP6vrm+eFLN5YJe+x6WqzN
	bUyyC9/WaGMXnBSYElQfV1EJ/Smr++M=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48a5775d647so60542485e9.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304150; x=1777908950; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XTH9nHu8rDITPKAJB2BnahRrdCbOr3wfwwaQ1ZOWZK8=;
        b=g3/9eQXmzgPoVEGkdAY3w0IxBS/1+0h27mzPIUqtDURsNTf8IFjm/yF3f+mDZA9wcq
         u/2JUKsoF+WS4vawceshykgJxEFJkh9dUJEU6J20DxrgyMkx3s49NFadQqC5iqrbkOyz
         1lIyFnmb8WaW6Kt1fqc5lvGBDzsvhmfm19xYxpfGcPnGrnz1sFpwjC/zc+z61q8aluTB
         wGJR7XSyQfTqm91udpG8DlhdwYVO6Fmr/QouDpKoi7GNttS+dDi2qWjJ09sB3f4DCAI1
         0dovWJ2tP8BJTFcErQVbvAxlJHjQ9S/ZlalK7OQACMSwkfQkiMWEtzWPK/XNHeEGo3MS
         bZMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304150; x=1777908950;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XTH9nHu8rDITPKAJB2BnahRrdCbOr3wfwwaQ1ZOWZK8=;
        b=Gg/fGL/kISjAAdumwUIt065GqBU7c7TL6OGvhNxHdMGw1ICF7fKxVZGKaHPsBm/pHQ
         J8gGI7oE1evVaShBp7tOHYVluOPRZqAmeroex/vs2J6+64a8kxlDgny8RxDl2QmMuBP1
         zxjfjzXTqknJVKnEEZXENyC9x0AK9aUs3tqLXAGSGMRW9Nx9bdgTCWoipsMCJlzvPxpv
         noeg0eRFVb2qI0o2nV/pVyKEo12C7Lkh40Uy0jeMnUuhVMpHiYJgSevVcp3G8UABOfya
         eRh3hM0iVh5FVBwI1KlSo1M4mpOMROYNfOaZ7lQiSJAAzODgWutPBvVD0wK+PR+iXUCu
         r1IA==
X-Forwarded-Encrypted: i=1; AFNElJ8ALHCt8DniF2zc77Cmcq9oOkdM6iAzUAE1LwnGYXiz8PUAu4atYI/YV6lf1U8N3Te9QPGnT1R6Qg==@kvack.org
X-Gm-Message-State: AOJu0Yxpffa/VTgk+cUUdZWvt/ghfUahTRzP071/pmiH/vaM+H2V4jAm
	+GJToc01E4JcKms4L+I8VxwqlSS8oRPRB60Rr5/3BxLznHUMFtfAhlcMNqke3oCGf6P8hrmG3w=
	=
X-Received: from wmcn9.prod.google.com ([2002:a05:600c:c0c9:b0:485:fb9c:ffa5])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3546:b0:488:81b1:ae36
 with SMTP id 5b1f17b1804b1-488fb7880camr604813405e9.23.1777304149544; Mon, 27
 Apr 2026 08:35:49 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:31 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=5803; i=ardb@kernel.org;
 h=from:subject; bh=YSdu4q+PtPsInD53oLl+3uBw5SBzUVoUd7FzWVZ14jY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN9E5+Lo4bOq9KZm6o4L8u/vb/hydxl+fVRaYE/zvc9Y
 VmglsHQUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACYix8jIsKnEu41r6pMdV/e7
 tUrq7Z357SWjW05Bks+rK6s47Vdea2ZkmLNng5zCxX8/rKfelTlnZcUXtfa71MttQVn9jCEdZr+ LeQA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-31-ardb+git@google.com>
Subject: [PATCH v4 14/15] arm64: mm: Generalize manipulation code of read-only descriptors
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: st6giwuuz4z18qd7pqiq8m9ydbd87spa
X-Rspamd-Queue-Id: 50D5740014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777304151-920147
X-HE-Meta: U2FsdGVkX19nldSwUWwHdFK5YThQNfMTQ0U/0/ePjx0EVlK4f+NJuys07xmpHNo97ww8Ksjxk7z0ciWxflGJ/1VBLLswP5Yq/06wwAfZj8G3CCCRK9sq44cJikOC+28+bZ0+pf4dQ0SbbkO5lIi/Fp6i8awEbqSQDxtrxh3CDgLQSRMzNZnr9oTm7RCQbwU+B+hH3743tD+4XD8TugaDEBYfMlCGN7L4vyhCwMTMW/L7j1pQA9bd3gwLhuIEviQvpr/iF677vjUvxmKEYpdWJw0fBxwaztclh8i6XtumaxXYdZuH98pDTyDmgNeXkbI1OZfiwRar5mSpyPBUaGtfzgjDal9vEVJBEzmLntPySDOBlswPa08mJwWFP8ODLiewRe7F+xXSecZHK18dIZP14Q1gFmOTlyynuWYK/D26WBOgHlqYnkWMV7JVF/D27gAlxaYY0yjwCNYUjDChVfax3mXrAZyTMRDDMOkx4ZrpPMbcNryHzC+ml4HpeVrAkyEia6FYmyv6iofJ/NfzcMdMf/TTOJi0xG1MMtUEjwP5+o/ol6tTC/bJybJ79NGOJqyfaxQwYSa9OmmlZaJc4A+LaCQawsszxjyhYQiHx3SFald3jBaMiDmQnfM8WGBgyLbSdzzZtHSpjCB8evir2jUUehFFQuKaOgx2HdOaazJg/Tu30c2O7+wl1gzz9QmjVfWgWlpM/G0ZxrVMBLIhcnO+hUPubl4kgDXMP9o0vjKZDW3CfDRybdNVVKL9QyIyHk2gV7rZKY4rkclnV6CNfNiuuq7Y6VQxhN79OhU01IZIyNjiHJJsqQTma2S2matB4tsxWdGICYwQ3MB2Eh4mkLC9TUNlVTQRDl+KTu/l5chAof0GsF9RBzlss4TgJbBTBw7w3vnBAixSPu0RS2aEJAu/OuQkt+dIzPyoIPuOP0TnBNJmTibgxnJwoxJEYM1hgIXghcaOSCbdNlX1KSfaTkm
 4MjM0Lqz
 BvqhuJxUfb8BV83GYcF9mJ3jnIXQ0e3wnWp0AQs8GJ8DoYA4KGmuEgOMJWB1avMEuFvt7Xsec98euiGosncrAEx890OjPh5Gc+6Ubk3NYp5zwBKpNJmDARmPTseWdtertadKnbYVdvma/U1qJJWKNnOgWWDg7wNcw4t3XUp0zooEWgXS/LZPF2d0qfq9h8rYw6s0U/ZcbhejPaC8PDArW77wlpFbd0INQzUtoYhyyiGCozvCmCQ1xFCLbnoVumGzYRTQ835fLTyVd5Zg/zGOjhP8YUhR4r/CJGzz/sc7wf2gzvnKSVT8b0ImThwCoOBD2uWuvj5s8V7Cu98NSwUB9MWuJ043j4CQRoATVGQYt4Uzs/mRKI4XydthfrEUg3swb/KvBC7ptUNGalCIUNXWlpUJ2EFAU1hCxOuY0WoICtvsf/kSotbd8U2ttQZyhEkcsUakZTN7jG6Vq2PTlqE9Bk1NrpA/tBdLtB+qX8/IJ9uLIx7v+CxCm2Nqelvo68mHUtRXCLxMBNnhAXXO0IzyY+c+T8nG4dksWBrar0wb0ohPYgX9vv8KjH2ZNcet3498w8tazIxLTFvXhLr2XcG4st1NnIXsHHSaip20iytqwHfdNWwazflDOWc6l3ddG5ZMjvBppHC+XGah3OTxN7aIDpEF8Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Before moving the fixmap PUD/PMD tables into .rodata, update the
existing descriptor manipulation code so it will fallback to the fixmap
for any descriptor located in the .pgdir_rodata section.

This is slightly more costly, as it evaluates whether or not a
descriptor is in the kernel's rodata region at levels PMD and higher for
any configuration, rather than only when the level in question is the
root level.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 27 ++++++++++----------
 arch/arm64/kernel/vmlinux.lds.S  |  8 ++++--
 arch/arm64/mm/mmu.c              | 24 ++++++++---------
 3 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a1c5894332d9..94235dd428be 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -816,23 +816,22 @@ extern pgd_t swapper_pg_dir[];
 extern pgd_t idmap_pg_dir[];
 extern pgd_t tramp_pg_dir[];
 extern pgd_t reserved_pg_dir[];
+extern pgd_t __pgdir_rodata_start[], __pgdir_rodata_end[];
 
-extern void set_swapper_pgd(pgd_t *pgdp, pgd_t pgd);
+extern void set_rodata_pte(pte_t *ptep, pte_t pte);
 
-static inline bool in_swapper_pgdir(void *addr)
+static inline bool in_pgdir_rodata(void *addr)
 {
-	return ((unsigned long)addr & PAGE_MASK) ==
-	        ((unsigned long)swapper_pg_dir & PAGE_MASK);
+	return addr >= (void *)__pgdir_rodata_start &&
+	       addr < (void *)__pgdir_rodata_end;
 }
 
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
-#ifdef __PAGETABLE_PMD_FOLDED
-	if (in_swapper_pgdir(pmdp)) {
-		set_swapper_pgd((pgd_t *)pmdp, __pgd(pmd_val(pmd)));
+	if (in_pgdir_rodata(pmdp)) {
+		set_rodata_pte((pte_t *)pmdp, __pte(pmd_val(pmd)));
 		return;
 	}
-#endif /* __PAGETABLE_PMD_FOLDED */
 
 	WRITE_ONCE(*pmdp, pmd);
 
@@ -893,8 +892,8 @@ static inline bool pgtable_l4_enabled(void);
 
 static inline void set_pud(pud_t *pudp, pud_t pud)
 {
-	if (!pgtable_l4_enabled() && in_swapper_pgdir(pudp)) {
-		set_swapper_pgd((pgd_t *)pudp, __pgd(pud_val(pud)));
+	if (in_pgdir_rodata(pudp)) {
+		set_rodata_pte((pte_t *)pudp, __pte(pud_val(pud)));
 		return;
 	}
 
@@ -974,8 +973,8 @@ static inline bool mm_pud_folded(const struct mm_struct *mm)
 
 static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 {
-	if (in_swapper_pgdir(p4dp)) {
-		set_swapper_pgd((pgd_t *)p4dp, __pgd(p4d_val(p4d)));
+	if (in_pgdir_rodata(p4dp)) {
+		set_rodata_pte((pte_t *)p4dp, __pte(p4d_val(p4d)));
 		return;
 	}
 
@@ -1102,8 +1101,8 @@ static inline bool mm_p4d_folded(const struct mm_struct *mm)
 
 static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 {
-	if (in_swapper_pgdir(pgdp)) {
-		set_swapper_pgd(pgdp, __pgd(pgd_val(pgd)));
+	if (in_pgdir_rodata(pgdp)) {
+		set_rodata_pte((pte_t *)pgdp, __pte(pgd_val(pgd)));
 		return;
 	}
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 2dca18574619..e5e1d0fd7f27 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -243,8 +243,12 @@ SECTIONS
 	reserved_pg_dir = .;
 	. += PAGE_SIZE;
 
-	swapper_pg_dir = .;
-	. += PAGE_SIZE;
+	.pgdir_rodata : {
+		__pgdir_rodata_start = .;
+		swapper_pg_dir = .;
+		. += PAGE_SIZE;
+		__pgdir_rodata_end = .;
+	}
 
 	. = ALIGN(SEGMENT_ALIGN);
 	__init_begin = .;
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a464f3d2d2df..84d81bae07a7 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -65,34 +65,34 @@ static bool rodata_is_rw __ro_after_init = true;
  */
 long __section(".mmuoff.data.write") __early_cpu_boot_status;
 
-static DEFINE_SPINLOCK(swapper_pgdir_lock);
+static DEFINE_SPINLOCK(rodata_pgdir_lock);
 static DEFINE_MUTEX(fixmap_lock);
 
-void noinstr set_swapper_pgd(pgd_t *pgdp, pgd_t pgd)
+void noinstr set_rodata_pte(pte_t *ptep, pte_t pte)
 {
-	pgd_t *fixmap_pgdp;
+	pte_t *fixmap_ptep;
 
 	/*
-	 * Don't bother with the fixmap if swapper_pg_dir is still mapped
-	 * writable in the kernel mapping.
+	 * Don't bother with the fixmap if rodata is still mapped
+	 * writable in the kernel and linear mappings.
 	 */
 	if (rodata_is_rw) {
-		WRITE_ONCE(*pgdp, pgd);
+		WRITE_ONCE(*ptep, pte);
 		dsb(ishst);
 		isb();
 		return;
 	}
 
-	spin_lock(&swapper_pgdir_lock);
-	fixmap_pgdp = pgd_set_fixmap(__pa_symbol(pgdp));
-	WRITE_ONCE(*fixmap_pgdp, pgd);
+	spin_lock(&rodata_pgdir_lock);
+	fixmap_ptep = pte_set_fixmap(__pa_nodebug(ptep));
+	WRITE_ONCE(*fixmap_ptep, pte);
 	/*
 	 * We need dsb(ishst) here to ensure the page-table-walker sees
 	 * our new entry before set_p?d() returns. The fixmap's
 	 * flush_tlb_kernel_range() via clear_fixmap() does this for us.
 	 */
-	pgd_clear_fixmap();
-	spin_unlock(&swapper_pgdir_lock);
+	pte_clear_fixmap();
+	spin_unlock(&rodata_pgdir_lock);
 }
 
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
@@ -1071,6 +1071,7 @@ void __init mark_linear_text_alias_ro(void)
 	/*
 	 * Remove the write permissions from the linear alias of .text/.rodata
 	 */
+	WRITE_ONCE(rodata_is_rw, false);
 	update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
 			    (unsigned long)__init_begin - (unsigned long)_text,
 			    pgprot_tagged(PAGE_KERNEL_RO));
@@ -1221,7 +1222,6 @@ void mark_rodata_ro(void)
 	 * to cover NOTES and EXCEPTION_TABLE.
 	 */
 	section_size = (unsigned long)__init_begin - (unsigned long)__start_rodata;
-	WRITE_ONCE(rodata_is_rw, false);
 	update_mapping_prot(__pa_symbol(__start_rodata), (unsigned long)__start_rodata,
 			    section_size, PAGE_KERNEL_RO);
 	/* mark the range between _text and _stext as read only. */
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


