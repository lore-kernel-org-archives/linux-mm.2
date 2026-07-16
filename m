Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39F91C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33C66B013D; Thu, 16 Jul 2026 11:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABCED6B0140; Thu, 16 Jul 2026 11:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC346B0141; Thu, 16 Jul 2026 11:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 455DA6B013D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:09:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6B4C8014F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:42:54 +0000 (UTC)
X-FDA: 84994604268.26.0D388FF
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3AF89180004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:42:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GzYocpH+;
	spf=pass (imf24.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldlfwiuLgMW2soE43Rq8OVhlEemN/KhXMrXMzIbx114=;
	b=bMFVusVmFQEsUgklFE2avRbswVtw1GPO8Sv8O0bQi9r9JFyLLIXv1AdfXf2dpTvO0DDSPp
	t1LCLYd9dFHo+bLSjENR/Pgiy7vI4ZfLacW9PcCe24wsZ9Rfl5eLCB0b50+cUXvay72jIC
	D8ts42QzP0SZJIuISqu63sg5VjEL/l8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GzYocpH+;
	spf=pass (imf24.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205772;
	b=5B4gYtoA2Sl5lbAmvQOBIi/RLoCe4cMb7ZCjx89ML43/4Yu6ItqiEDmUqHV2xf/XLRHcQY
	yhgq9lkAhCFRp7wiJT1hh0yda6edWrLYPKO5ZXAmapJfwjzpT5OkSUssxiKbsIWwb86y67
	3aZWMjKg1f1oubo+hZ6oRXFAU51dNlk=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c9e7391839cso2949572a12.0
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205771; x=1784810571; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ldlfwiuLgMW2soE43Rq8OVhlEemN/KhXMrXMzIbx114=;
        b=GzYocpH+u5Blp3Ju38cAwqd2SV2BC2HHEfE6dFKGOkzAF7KkPUgKQHP5Nn/dHNVyza
         33CgSS276uac4n1l5w1G6PkCw3wuoTxmdkp9Aq55XgdhqwZ4X29GB9rs97n6Je/4OW07
         Q+C7g7kSx87mOw9rv7e4BnX4dB6FONA/cC6wDAmlDbJz3ZDZsADdwb8P7m0XGtVx0wF6
         qrFcvdsu9pniOg9p3CcB07wxsGMfLiJsmSKeqXgTks159F3AqB5HwSsQzvMV2h5CcwT0
         1DLX6VZPatzF0nhLWO9S26YMEdFJq0S1ydD2D5PHVnnP/8P5hIBlOumW4OgqizaraqPd
         x3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205771; x=1784810571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ldlfwiuLgMW2soE43Rq8OVhlEemN/KhXMrXMzIbx114=;
        b=Jfsn6zR1Yd69I3tByZiuvQ5goGoUAPuKpgUndtFISo6w36+cPmrH2mq8H9w2YCY66F
         8vaoyOHWTXEt9k57zXqjs/m6KDpLwcZ+lZQo1CfWrVXiQganpqHybK0y0RQlo44cE30n
         AINtmt9X9jPudSIJz4CXajZxFpPK/sAByPPa3aU8FVvzYGp4uhJDoA4ut//AgpK7VzJC
         tR3uFQxkZ9pm2d4f7jV+8Gt+3lxnjvfsS/tUzxG8kB0aKM0R0YpoFoh538qYgHHax8IZ
         6CT8Utf+tT7N6TF8suf6tQ3YlfjdW+jwnZplqCxREdegfP9ctr2eP8fZlq0zU3CciSnv
         v4kw==
X-Forwarded-Encrypted: i=1; AHgh+Ro7p6PvEZ2fDSdIwUoMNWQddR3ePu1ffV/PV0uPvTl4TNBMyCE61iSFD7cfBVfNlY+OP4gOZZznFg==@kvack.org
X-Gm-Message-State: AOJu0YyTCVHj7ofqp+UBQFyernIufrGG7ABROgFQR7H/Hi88Za2NeWhb
	RtWo8YGOYVc4NkU97rOqN4Ewcz7F46elffAsPPJ1yjeSowG8P6rfIX6o1VW7tDJqAGw=
X-Gm-Gg: AfdE7cnDDuFLufMRqye+SRbccm0a3DfzstZjNvPpeRWEyizlANlL8c485Ld5Sd9Nc6n
	XkSgvSf1KHbJZuuHMGkZUdyuFMPIX1v4KAwO+G0PLU7dp9tJFLHGYL3V6l6WgPTGd6501jIm6Mb
	kmOtjUfkazPjBKIW0C3bltw9ESW+OTonAje4glizkYybBffjj012fnKF08PFd1LtM9E6Beb75ux
	tlQQzSXjeL0RQXd6Mb6/5ZtJ4V8ykaMmsUoYI5hRSYgmQMBzbAvlXJ+4V0cbRcJjm0HzJ0DA9YY
	z1qlK1fXvmZS9LmDV/sT2W6ezjt89I+x9d0fGWVsjqhs8YA/LhrxpUJhjWc04+tDaNwdi9wFoGS
	EsrCdS8mO481T8b5kRE1UKeyeqWsJbikZcUUT6J8OsYP7+hZv4QrBeyPX4fnzahAKDo4lsmVUqr
	Qi94hmJTmTo8tPKbMMRDMZTizZbm1tnbybwA==
X-Received: by 2002:a05:6a21:10b:b0:3bf:b1d3:393e with SMTP id adf61e73a8af0-3c110009b76mr25226010637.2.1784205770620;
        Thu, 16 Jul 2026 05:42:50 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.42.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:42:50 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH v2 01/15] riscv: introduce raw PTE helpers
Date: Thu, 16 Jul 2026 20:41:36 +0800
Message-Id: <2bde82cde4c262d35663d386e8a16455c76ec3e6.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q1iyc5g99schhkwuxk4hkfb5qtnoghis
X-Rspamd-Queue-Id: 3AF89180004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784205772-411369
X-HE-Meta: U2FsdGVkX18LeIG1Eu041nZIrqKQtZQ2VgEA3AmhTJz++dti2as9olf8EUe0Vo9gEmbqCBxyTAgWwarpGgMsbYpzKxDeUpGOWlqes+F0rrs8v4CqzyGfYn8Njnou0BZrsVl8DHMLaRa2FmRp+fgtMZcduU5oQYHLDcVSVml5Zr74Ab9n4P3e2QWfqFQpKskoVBTUtuYJSvK2IPuV94YP+wdUTdgXoT57Ej2luQzHXCfAaiu7LsRhJ134Hmkgaz+zTYbh85K5zZ3/9nuTrnGV9bmCfphX+k0ijfnHZsQasXgajWugiWH2qiMhlO2oDSe/1aGp/QKFI0azfX4HSQI4+mmO7GfwziIDmj7B5KLzLh8x3HHT6q7bwvsiFwwk7cSKcpyrhG69uEac14MVGDfXzn141pzL9H+Pu0q8sBKSJ1Ydma8eW5+9mA8or8ldHTkQ/zE6nc1sNdQ11/1cpmpSdqlACqHePc59krlRaLDKpDWTQYDZ2JNkdQjHrdmfPSnmD1OfzGaO4/CYaMdJHpXyqoq9T3XiiWshWfEDBxMAbi/wpaXa3O352ZGSR8YzWRbYJn76yGR2md7zQQvBZ12HJLj+WLUlvR6f6/3eJvZSKYZ6kFTAb+A5uC3Q91FtsYkv80owHbCsIkEPh6NrXxgcUsn/+17Ds/S9JivGlbWSG+qjvX5Tr7ki+9CwWsNjtPTVQh9MrMSQrL496qCKYgZkSI266+ygl8RorjFYXcy1M/cbb3uZOp7LLVFG9tposkn2yH5drb9io2Fqec/JrscMYGfx0jBEsdwmzXRKP3n12UZikhJwsztFELGkKjXOyidTnhmWk2f/TXmrMkqsuya/sNzqp8RtTl6cxFNTBbg3v4v5RjmycDxDpDYZvtLcrtjtlIUPt/zyxE07IYUNVgPWL4Sa6nF1J2pf7wyd+PmAl+Z1a/uzCWFH5AzPEgKnmRvYGSVSJBd4PWFazYc0HXI
 2zXDbAov
 wy3V7FT3ehm/fb9gDMrOKDmB5FSjcIUVWwf1/gVL3vvbyD1yPAw38ZA7qAJKAakaUEfup63EiRNK3ObDLver40jv6gmsIxrtyWrqwN4Z0PBhdwZ6V58mWYc+dgJmRZoP1wyGm4ggvwpXnUq3VbSb91ONfUnw2KMAVcqj2qwEnWE3YYFB8lxbuPj1Ua1pW+XOb+lil6CbW1byhPqMeExIRJRcWTtp9PhmWEmIvSEzLdc08tDdT5kVkHSNc5llD7OBrhRgVGprU6ivVYLX9PQaVA4mOSYsYka926WgAVeHWTHie3bQlhWRHUmFnZdY9rxlm8330bS3CrCW42c2ZMLNJK2caGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Svnapot needs RISC-V to distinguish between two PTE views: the raw encoded
entries used by architecture code, and the logical per-page PTE view that
will later be exposed to generic MM paths.

Split the low-level RISC-V PTE operations from the public helpers so the
raw helpers can keep operating on the hardware encoding, while follow-up
changes build the Svnapot-aware public view on top.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/pgtable.h | 129 +++++++++++++++++++++++++++----
 1 file changed, 114 insertions(+), 15 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index a810655ce8f9b..8ca5da9534967 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -9,6 +9,7 @@
 #include <linux/mmzone.h>
 #include <linux/sizes.h>
 
+#include <asm/cmpxchg.h>
 #include <asm/pgtable-bits.h>
 
 #ifndef CONFIG_MMU
@@ -628,11 +629,13 @@ static inline int pte_same(pte_t pte_a, pte_t pte_b)
  * a page table are directly modified.  Thus, the following hook is
  * made available.
  */
-static inline void set_pte(pte_t *ptep, pte_t pteval)
+static inline void __set_pte(pte_t *ptep, pte_t pteval)
 {
 	WRITE_ONCE(*ptep, pteval);
 }
 
+#define __set_pte __set_pte
+
 void flush_icache_pte(struct mm_struct *mm, pte_t pte);
 
 static inline void __set_pte_at(struct mm_struct *mm, pte_t *ptep, pte_t pteval)
@@ -640,13 +643,13 @@ static inline void __set_pte_at(struct mm_struct *mm, pte_t *ptep, pte_t pteval)
 	if (pte_present(pteval) && pte_exec(pteval))
 		flush_icache_pte(mm, pteval);
 
-	set_pte(ptep, pteval);
+	__set_pte(ptep, pteval);
 }
 
 #define PFN_PTE_SHIFT		_PAGE_PFN_SHIFT
 
-static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
-		pte_t *ptep, pte_t pteval, unsigned int nr)
+static inline void __set_ptes(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t pteval, unsigned int nr)
 {
 	page_table_check_ptes_set(mm, addr, ptep, pteval, nr);
 
@@ -658,24 +661,85 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 		pte_val(pteval) += 1 << _PAGE_PFN_SHIFT;
 	}
 }
-#define set_ptes set_ptes
 
-static inline void pte_clear(struct mm_struct *mm,
-	unsigned long addr, pte_t *ptep)
+#define __set_ptes __set_ptes
+
+static inline void __pte_clear(struct mm_struct *mm,
+			       unsigned long addr, pte_t *ptep)
 {
 	__set_pte_at(mm, ptep, __pte(0));
 }
 
+#define __pte_clear __pte_clear
+
+#define __ptep_get __ptep_get
+static inline pte_t __ptep_get(pte_t *ptep)
+{
+	return READ_ONCE(*ptep);
+}
+
+#define __ptep_get_lockless __ptep_get_lockless
+static inline pte_t __ptep_get_lockless(pte_t *ptep)
+{
+	return __ptep_get(ptep);
+}
+
+static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
+					   unsigned long addr, pte_t *ptep,
+					   pte_t pte, cydp_t flags)
+{
+	pte_t old_pte;
+
+	do {
+		old_pte = pte;
+
+		if (flags & CYDP_CLEAR_YOUNG)
+			pte = pte_mkold(pte);
+		if (flags & CYDP_CLEAR_DIRTY)
+			pte = pte_mkclean(pte);
+
+		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+					       pte_val(old_pte),
+					       pte_val(pte));
+	} while (pte_val(pte) != pte_val(old_pte));
+}
+
+static inline void __clear_young_dirty_ptes(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep,
+					    unsigned int nr, cydp_t flags)
+{
+	pte_t pte;
+
+	for (;;) {
+		pte = __ptep_get(ptep);
+
+		if (flags == (CYDP_CLEAR_YOUNG | CYDP_CLEAR_DIRTY))
+			__set_pte(ptep, pte_mkclean(pte_mkold(pte)));
+		else
+			__clear_young_dirty_pte(vma, addr, ptep, pte, flags);
+
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+	}
+}
+
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS	/* defined in mm/pgtable.c */
 extern int ptep_set_access_flags(struct vm_area_struct *vma, unsigned long address,
 				 pte_t *ptep, pte_t entry, int dirty);
+int __ptep_set_access_flags(struct vm_area_struct *vma,
+			    unsigned long address, pte_t *ptep,
+			    pte_t entry, int dirty);
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG	/* defined in mm/pgtable.c */
 bool ptep_test_and_clear_young(struct vm_area_struct *vma,
-		unsigned long address, pte_t *ptep);
+			       unsigned long address, pte_t *ptep);
+bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
+				 unsigned long address, pte_t *ptep);
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
-static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
-				       unsigned long address, pte_t *ptep)
+static inline pte_t __ptep_get_and_clear(struct mm_struct *mm,
+					 unsigned long address, pte_t *ptep)
 {
 #ifdef CONFIG_SMP
 	pte_t pte = __pte(xchg(&ptep->pte, 0));
@@ -690,9 +754,24 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 	return pte;
 }
 
+#define __ptep_get_and_clear __ptep_get_and_clear
+
+static inline pte_t __ptep_clear_flush(struct vm_area_struct *vma,
+				       unsigned long address, pte_t *ptep)
+{
+	pte_t pte = __ptep_get_and_clear(vma->vm_mm, address, ptep);
+
+	if (pte_accessible(vma->vm_mm, pte))
+		flush_tlb_page(vma, address);
+
+	return pte;
+}
+
+#define __ptep_clear_flush __ptep_clear_flush
+
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
-static inline void ptep_set_wrprotect(struct mm_struct *mm,
-				      unsigned long address, pte_t *ptep)
+static inline void __ptep_set_wrprotect(struct mm_struct *mm,
+					unsigned long address, pte_t *ptep)
 {
 	pte_t read_pte = READ_ONCE(*ptep);
 	/*
@@ -705,9 +784,11 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
 			((pte_val(read_pte) & ~(unsigned long)_PAGE_WRITE) | _PAGE_READ));
 }
 
+#define __ptep_set_wrprotect __ptep_set_wrprotect
+
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-static inline bool ptep_clear_flush_young(struct vm_area_struct *vma,
-		unsigned long address, pte_t *ptep)
+static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
+					    unsigned long address, pte_t *ptep)
 {
 	/*
 	 * This comment is borrowed from x86, but applies equally to RISC-V:
@@ -724,9 +805,27 @@ static inline bool ptep_clear_flush_young(struct vm_area_struct *vma,
 	 * shouldn't really matter because there's no real memory
 	 * pressure for swapout to react to. ]
 	 */
-	return ptep_test_and_clear_young(vma, address, ptep);
+	return __ptep_test_and_clear_young(vma, address, ptep);
 }
 
+#define __ptep_clear_flush_young __ptep_clear_flush_young
+
+#define ptep_get __ptep_get
+#define ptep_get_lockless __ptep_get_lockless
+#define set_pte __set_pte
+#define set_ptes __set_ptes
+
+static inline void pte_clear(struct mm_struct *mm,
+			     unsigned long addr, pte_t *ptep)
+{
+	__pte_clear(mm, addr, ptep);
+}
+
+#define ptep_get_and_clear __ptep_get_and_clear
+#define clear_young_dirty_ptes __clear_young_dirty_ptes
+#define ptep_set_wrprotect __ptep_set_wrprotect
+#define ptep_clear_flush_young __ptep_clear_flush_young
+
 #define pgprot_nx pgprot_nx
 static inline pgprot_t pgprot_nx(pgprot_t _prot)
 {
-- 
2.39.5


