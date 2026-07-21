Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55592C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D4C06B00A1; Tue, 21 Jul 2026 12:24:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 086396B00A2; Tue, 21 Jul 2026 12:24:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04676B00A3; Tue, 21 Jul 2026 12:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C185A6B00A1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:24:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F51F120212
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:25 +0000 (UTC)
X-FDA: 85013306490.12.3823578
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8CFF340002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jpW44nJz;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLtKmgePsVMTaeM3LRrhXggCl62wc5rCPPnL48yidIo=;
	b=nW3EAPAhqKtUH+FBfStxegxeoRw/FviB8xsuIxDjFneBhd4kxwIo4Q+Ymz0WVT8K8L+wCj
	AMCO2wYLnaYb2Ridt4OkfLB11gEamwWuL2jgWMeEY3G/ZDtE+PaJOMTyGhMR5zdH5kRlWL
	iNeilcFz+i2yT6Fl6VEpZFcgtAajt04=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651063;
	b=IyS7HDdn2yoEHQyJpq62oaEOhbLnJHuZkOdqd9WYJSK22wE5wRCt7awAa2AtKxSVhSKYFD
	rM377eVSNH+X7avpEfbNYUtvaYyuivbxnpy3XLmH/GTm6bSrXMwDBa/UPazoYgYJxIAakQ
	lR7V4TC3V1Lb3fWJma2U49NAn6v2MiU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jpW44nJz;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AF9960A59;
	Tue, 21 Jul 2026 16:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832A61F000E9;
	Tue, 21 Jul 2026 16:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651062;
	bh=MLtKmgePsVMTaeM3LRrhXggCl62wc5rCPPnL48yidIo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jpW44nJzttT3pWAEhrIKz5B4sMBsyhohfB0x3ncv13vYzuBX+eor5vRrEJsAn1GEC
	 8buYNNPOKdsYbmQq4LUYFKbNl9hjm9cLuyrrmuj2vS7L92z3roHNEuY3rwGa7SLFla
	 mVWiAz9B/42AJBbg/tlAC/rzlktFkH1KdlYTHVvbh+z6r7JDzdaFEoJe4k3cYL4Vn0
	 CEM3jZKRS8JnGvVzs60HuN1d6KQxlrY56SsI3GVHxg1BN5fUoLnKf3K0RBbDod0UQk
	 MUO1T9opH9P+jmqCFdx3mbZ949Kz8DemL18bQ0aug9DwEw51oCZgNWGYZpjANkk1fk
	 cdcD3utSbh+tg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:29 +0300
Subject: [PATCH RFC 06/18] x86/mm/pat: introduce an inline helper to check
 if alias needs update
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-6-2c1fc62306b3@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8CFF340002
X-Stat-Signature: xt6b615nqtmt9zeijgxo9os4ugub7ita
X-Rspam-User: 
X-HE-Tag: 1784651063-406658
X-HE-Meta: U2FsdGVkX1/NPBpKKFlDx6iS5Mvkj9ycghz0O6sMdIO+/T+7nElF3bwnxP3oqqkGAwFbwFp5BSK6fXShzoQ7rDzPg9yTJ0ebkMTPGnLTGqOa5YLltYNhpFYC3FqLYZg7SbXevXv2huNV3Hc6W/rJjA51QPP1tVLVoHJXgxJPi30DKtUAcL7TgieoOC481hzSvR11zyWenTOZgpPLl9it7aIDXduCWUTONFqRJqwgC4pLqkzUsW8RtpxO158OQNcE2uoNWDg0VRj0eDAUnS5OscSc4i+uKrSnoq5d9nzgWu5jMCQAE+fNyaGbOGzLqtcW85Mifswh018THugs4nJsg0r1VzCazkphut/poohws/b2EAFsouLqP3mm6WsoZ183X61FgYYynvp0U3PNjK9tUwcuFMyc6i5MmMaxbXvwBsBPdyyzT8PEBhe8c+IJO47QZbhDdodpdAkFLlBnKWIRdrrL94qWt+04A3C190HFpRqXpCSnzw21i4sdnuMo2xsreOOxno1x9kD9dPr/6RH0qpzbURRc+3zWUMobqqMYskVU0aoVJLhtmbzAsO0qp1nw1H3K+6J+u2YWAYRtC934hTSbKvGExTSF/DSXFIoKbMjaISr+aMQJ6kuX+KJUZFXPzsMW8DEJ0PW3dPGOrl3U4FwZD5sTtRSxiABMC5GDRLWeIpiuzhlYfAE319VSPu3+jQfPAa1+E6EWtv9dLgThoaSjyZzkr5yKQjwUn0qaH4sv6h9/iO26pTpDwncIkWkG8gjFPOb3nDhea4pFY4OqObZWCEh1Teg0UJh5162d1gUfpK2Yq3pzleE54DCcJBjbhebgxCBTxrwEHp8Cm+Xwjjhlb0SUKoQXR7BGSQVJFrJLLSdW/vF2VqkpKmvNZbDssuernzy/ljTWn4b/+wiWYGKRvk0+29AAHb8Ap7sBydd9enDj5Er1QLDTwTWZk1UQuCygVOLX69scRbYOWv+
 mherSYnx
 0PdLOoSoB79xcPR2ek3vUwB7NneMQzI9QuVsradzQvGYulC0u/M3b/WRRXF2/KnuYRZUGZ0PK/ZwDa3+fH3bRNLqOOT6lAVL8j8x2EPu0tP2o7WOWOPUnCZE+zeSKz83r3JkMUJgx5C1Ych5gA4sPvdjQNImSntz3sfDUD0ki+fcBEUQva+Tbk4S1z6Wrp2Cds9Km3uDulnggSZD2uDejzr5UUudoLxMFJiTyAYe/clvICEhhZvQLKLX4SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once core parts of change_page_attr() would be moved to common code,
the processing of alias mappings would be out of line and would require
a function call for each modified PTE even if the primary target of
change_page_attr() does not have alias mappings.

Calling a function per PTE just to find out it has nothing to do is
expensive and resulted in ~30% regression in instrumented cpa-test.

Although cpa-test is a microbenchmark, ~30% regression is still a lot
and can be easily avoided by inlining the checks that gates processing
of the alias mapping.

Introduce cpa_should_update_alias() inline helper that checks if the
alias update is required.

Since on 64-bit an alias could be in the high kernel mapping, pull
__cpa_pfn_in_highmap() along and rename it to pfn_is_kernel().

No functional change intended.

Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/include/asm/set_memory.h | 50 +++++++++++++++++++++++++++++++
 arch/x86/mm/pat/set_memory.c      | 62 +++------------------------------------
 2 files changed, 54 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 4362c26aa992..332ec300c2ed 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -3,12 +3,62 @@
 #define _ASM_X86_SET_MEMORY_H
 
 #include <asm/page.h>
+#include <asm/sections.h>
 #include <asm-generic/set_memory.h>
 #include <asm/pgtable.h>
 
 #define set_memory_rox set_memory_rox
 int set_memory_rox(unsigned long addr, int numpages);
 
+#ifdef CONFIG_X86_64
+/*
+ * The kernel image is mapped into two places in the virtual address space
+ * (addresses without KASLR, of course):
+ *
+ * 1. The kernel direct map (0xffff880000000000)
+ * 2. The "high kernel map" (0xffffffff81000000)
+ *
+ * We actually execute out of #2. If we get the address of a kernel symbol, it
+ * points to #2, but almost all physical-to-virtual translations point to #1.
+ *
+ * This is so that we can have both a directmap of all physical memory *and*
+ * take full advantage of the limited (s32) immediate addressing range (2G)
+ * of x86_64.
+ *
+ * See Documentation/arch/x86/x86_64/mm.rst for more detail.
+ */
+static inline bool pfn_is_kernel(unsigned long pfn)
+{
+	unsigned long spfn = __pa_symbol(_text) >> PAGE_SHIFT;
+	/* Do not reference a physical address outside the kernel. */
+	unsigned long epfn = __pa_symbol(roundup(_brk_end, PMD_SIZE) - 1) >> PAGE_SHIFT;
+
+	return pfn >= spfn && pfn <= epfn;
+}
+#else
+static inline bool pfn_is_kernel(unsigned long pfn)
+{
+	/* There is no highmap on 32-bit */
+	return false;
+}
+#endif
+
+static inline bool cpa_should_update_alias(unsigned long vaddr,
+					   unsigned long pfn)
+{
+	/* Primary is not in the direct map, its direct map alias needs update */
+	if (vaddr < PAGE_OFFSET ||
+	    vaddr >= PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))
+		return true;
+
+	/* direct map page that is also part of the kernel highmap */
+	if ((vaddr < (unsigned long)_text || vaddr >= _brk_end) &&
+	    pfn_is_kernel(pfn))
+		return true;
+
+	return false;
+}
+
 /*
  * The set_memory_* API can be used to change various attributes of a virtual
  * address range. The attributes include:
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index ee40962d4ee9..2a087dcedf84 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -224,61 +224,6 @@ within(unsigned long addr, unsigned long start, unsigned long end)
 	return addr >= start && addr < end;
 }
 
-#ifdef CONFIG_X86_64
-
-static inline int
-within_inclusive(unsigned long addr, unsigned long start, unsigned long end)
-{
-	return addr >= start && addr <= end;
-}
-
-/*
- * The kernel image is mapped into two places in the virtual address space
- * (addresses without KASLR, of course):
- *
- * 1. The kernel direct map (0xffff880000000000)
- * 2. The "high kernel map" (0xffffffff81000000)
- *
- * We actually execute out of #2. If we get the address of a kernel symbol, it
- * points to #2, but almost all physical-to-virtual translations point to #1.
- *
- * This is so that we can have both a directmap of all physical memory *and*
- * take full advantage of the limited (s32) immediate addressing range (2G)
- * of x86_64.
- *
- * See Documentation/arch/x86/x86_64/mm.rst for more detail.
- */
-
-static inline unsigned long highmap_start_pfn(void)
-{
-	return __pa_symbol(_text) >> PAGE_SHIFT;
-}
-
-static inline unsigned long highmap_end_pfn(void)
-{
-	/* Do not reference physical address outside the kernel. */
-	return __pa_symbol(roundup(_brk_end, PMD_SIZE) - 1) >> PAGE_SHIFT;
-}
-
-static bool __cpa_pfn_in_highmap(unsigned long pfn)
-{
-	/*
-	 * Kernel text has an alias mapping at a high address, known
-	 * here as "highmap".
-	 */
-	return within_inclusive(pfn, highmap_start_pfn(), highmap_end_pfn());
-}
-
-#else
-
-static bool __cpa_pfn_in_highmap(unsigned long pfn)
-{
-	/* There is no highmap on 32-bit */
-	return false;
-}
-
-#endif
-
 /*
  * See set_mce_nospec().
  *
@@ -1830,7 +1775,7 @@ static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 		cpa->pfn = __pa(vaddr) >> PAGE_SHIFT;
 		return 0;
 
-	} else if (__cpa_pfn_in_highmap(cpa->pfn)) {
+	} else if (pfn_is_kernel(cpa->pfn)) {
 		/* Faults in the highmap are OK, so do not warn: */
 		return -EFAULT;
 	} else {
@@ -1968,7 +1913,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	 * to touch the high mapped kernel as well:
 	 */
 	if (!within(vaddr, (unsigned long)_text, _brk_end) &&
-	    __cpa_pfn_in_highmap(cpa->pfn)) {
+	    pfn_is_kernel(cpa->pfn)) {
 		unsigned long temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) +
 					       __START_KERNEL_map - phys_base;
 		alias_cpa = *cpa;
@@ -2026,7 +1971,8 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int primary)
 		if (ret)
 			goto out;
 
-		if (primary && !(cpa->flags & CPA_NO_CHECK_ALIAS)) {
+		if (primary && !(cpa->flags & CPA_NO_CHECK_ALIAS) &&
+		    cpa_should_update_alias(__cpa_addr(cpa, cpa->curpage), cpa->pfn)) {
 			ret = cpa_process_alias(cpa);
 			if (ret)
 				goto out;

-- 
2.53.0


