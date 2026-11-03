Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FD53606B128
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hmXa9PJ9
Received: by kanga.kvack.org (Postfix)
	id BBE1A6B05B2; Tue,  3 Nov 2026 05:13:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E546B05B3; Tue,  3 Nov 2026 05:13:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5D436B05B4; Tue,  3 Nov 2026 05:13:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8226B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:13:52 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09CBB8036A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:13:52 +0000 (UTC)
X-FDA: 85393396704.09.478F13F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id EA36A14000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:13:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmXa9PJ9;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793700830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8iafhbcQJ7sp3lB+0gHN0eXHJ45Ph346dETrlnBka+M=;
	b=EVFXZZXGnJddmO1lI7exBpz2fjtlyHbCXthz1VdGLb5jd8OrZ+cktL63B4LgctFua3JS3r
	Qd9rhyfkuFYhyeWtjzXHUEwFTc1kjYXoqjriQ2OPWNsco4QvDqBPR3z7v38gvJ8ivDo/Nm
	uMwDYypuwT/Do+awBUeosbfKKpG4Qsk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793700830;
	b=juLrEDG/y9qejmSk0iBkA5RJ/zXD0FF9rz0kjN+C9pvvrn4FSnbBQRzqlkehmrbM4V8Hmw
	HOEKd8GVaN8cJpSDzbysalLOFz4qIPoB5TgX/7P2EZYLR3S1HDxUc5m/IjGyGs/8KRVnPe
	c3o6l5xD61L2di4qZh/L89xGh0/aJwk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmXa9PJ9;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0111B43770;
	Tue,  3 Nov 2026 10:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29C11F0093A;
	Tue,  3 Nov 2026 10:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700828;
	bh=8iafhbcQJ7sp3lB+0gHN0eXHJ45Ph346dETrlnBka+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hmXa9PJ9sBMJ+HfumooMQzRMa/fZrZguv0pLVrAH8OQ4F0X7yl4CAEbQDs8FH3yh2
	 i9bJurxOXl6G+z3PJnndKB3IpwfuQiwtM1Cdc4VM+N2JfNZpnVf6zgrqXT1hs3Rbwl
	 6f/smHcqPAe0XfQHG9ZnxP5GwIrxRlpcOs1MOa/F4NhRSFjN/0RnbHamsDRYz9DAHf
	 0U5JMXPYnS25yysbIYXmNGxoU8Q5DyO4hBHgK+hoisOMSp4QCxq53NY7ObycMfWAl3
	 6l+KiFRG9YFR2fQVZdLtRyCYzQf38m6VI/HeLhG2+8f6tpm4FxY53PuhS7y5pgwM+B
	 jj1uV1UAk+kVg==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id A4BDD1980047;
	Tue,  3 Nov 2026 05:13:41 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 03 Nov 2026 05:13:45 -0500
X-ME-Sender: <xms:1bPpalr2gMXOjQyvyy7dSqZbILOBgga3ox1uzYDdZktOrYfTbQWUGQ>
    <xme:1bPpatVOTtGlPIcDh6wCoDEGO4n42_AQ-5X3kvnlBZNLT0PAgkoDodLtNdjpnzRak
    RBL3p4XnfgxEvHgHdm92hqNh_esleSXtbvsWChbo5OBanSwJ08FEThDmA>
X-ME-Received: <xmr:1bPpajYB4CDza1uoYOfmW8OTbvpIYI0lnBB1y75umVPSVbw88Xb2r8Gpo_M>
X-ME-Proxy-Cause: dmFkZTEwQUzH9wfsWr85L33/7Ip8vsacIUnJqbt5Fzpmxj6hGx0brSuxDwz8Cr9mCj51ov
    Ixy3YLwmNS9t2Eu+tskJCdR54uQZWpOzJSDT4qm+jBBxJN6PKyJ1hsnh4IoHE4bCysApMW
    YfwR1L2hSiVYcvadWZx00S2J7ZYGsyv3Z4v4dGUcEyxibWsq6sXCysn97CP9L5rsW8Dqa4
    qa0lutljG5RxY65EWsu+0Y6ZYfQ50/7c7rccNHV1kdgiVqzt00A+kNFk6M/GZBFwivSj06
    mvpX2fLJNE88WXgipN7XHGTOR8F9B9MCi5FrcPE8QrxMRpxGF8GRAEvZGnwfAgiMQp6Hel
    WWY9pmnT3gLJo1in4TAthn4hhGbypTlHoqCm+sY9XTKOmmr9Y5xg9/8FyGxLE/eB3vVbQ7
    lNOgdrWrb+y//wC66bz/qyr3TeASU/l8s9iS14SXwAU22UfHMMtS1x2mNxq4safC4LECWI
    6Zlg57xFEZmMJmkLwabNSeudd8wAkO5aMs4gjRn0c88p0wKZXOCs98rIzCbwi/LlSL7Iv3
    6AO9cvt9Yj/i4FgKDfEmX5O1ECillOv0T7kToh8g7QVA3TQ4B4wGwLR2pWAlukQfhrPsWt
    f2XsDWJZJjFP5/hNVNKpc/iwph1G2jqKvw2q16xIyeZDk6HEu4jMojOSXb9A
X-ME-Proxy: <xmx:1bPpautBv3lU7CCVrH7Yh7YJd1hgS7NNQVXkymg5Ok1CjQCT85t3Ug>
    <xmx:1bPpaqp4J_12LQlGj_SYfL2c9PmP4uidYGPuBNdZBjQoK6a19YBX3w>
    <xmx:1bPpauISTpEI2L4Yff1qlbMTdFL8llRWQeLA6gz0NAex2KASEsymFQ>
    <xmx:1bPpah6AD4KSee7fZthwezNfUIufqKyi1AHQhOe6AtB4b_lGrTAksw>
    <xmx:1bPpanQAi20wLItnIVmA_XLNiBtcmBUCkk3YSrlCgxdxN83QjMZXtNXL>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Nov 2026 05:13:40 -0500 (EST)
Date: Tue, 3 Nov 2026 10:13:39 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Xu <peterx@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Andrew Donnellan <andrew+kernel@donnellan.id.au>, Rohan McLure <rmclure@linux.ibm.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] x86/mm: Define the zapped-entry checks only with
 CONFIG_DEBUG_VM
Message-ID: <aumzjHyJsshPJBUI@thinkstation>
References: <20261102144001.342837-1-kas@kernel.org>
 <b04316eb-a2f8-4587-9392-e673c7bd2fc8@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b04316eb-a2f8-4587-9392-e673c7bd2fc8@intel.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EA36A14000B
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5omkfycc63q7cfhyd4ud1e89o3niwcum
X-Rspam-User: 
X-HE-Tag: 1793700829-928506
X-HE-Meta: U2FsdGVkX1/uj4el71rRypGTFzIMkGvTrJeLUMFj+XTIac4Bj+wAuZEfzWqtuKBcVQc53pwXt+Nvcv4t+L5R0w371GaWGavdevzLl4bMnUmUZ8sBjLqv3V2szZakWjVWT/eURjpfv0AHlZciu2XdfryoAzvMSXYpLtxKkrzilmkMOtrTGd+tz0E02Dvxo0JP3TbfK6DlEjcSh/QUf1koVz2KAefcZYeg4qWkvKsRx6CuHxtGi/t0x7rgi5iLcHCHX/TvuABnFISQ5uIhNapgFIFtrVnzqN3aLALerUkRYkiEXMVVQfewracoYgLpQhmfGvZ1kko+9KhXZ5sURHQlYRgIu7SlpwzGD9d42iXfcgiOpZx2y+YpfeY4OFD9rW1++rQJt1bUN4+cM9fJYjbvnaBvQY1WgnWAZd8dMyuuo0Nj2WdsL0FHni8+YtHk0pIK/R+agZbe3L6d+5c6o+3bgW1rLMNolUerbbPwx7SSv7O2nDCTPPd/UZPGi3rA39TWrygf83iSDVPW1IjJBPR8hDeqmFxjV5FF7QIYmd+EipQTLKPcbs9dDXJv1LVOl7Nbqw9gPvejvSyofKPBGVj1Lk5Z3ppkEle0Mbr/wn9S9IDo5xCdpP0r4Bt7R9Kss6N3vj5/qnl/1ojkBCfXHsYbSUH5MJX4pn4QZF6j+5QhI7zAwUR6LVbyOySRa8Ec7WZY7C3rAiKO3O9hAOF640bfrO/YVonLH0mRTTu2TJlvKelsM+i+gKkZInd2+qgyHZoD3XyMkWKWCbTF7MxTPCmBDviD23OFwpJY0xCUSRDOxHSftpH1dRornB/TcVcEo5bIqWJMvU7ELze1qAwH+gH2A7Jhae6zKH4Jt+MEW4n2HM6t9iEpSjKHpF/18qzq/qzSP9Pg/AGPsC1+GoEOAHpTfSMpyWuaJw/CPo5iPtAgMJXKLLzm/gEpJCQYMFsGm8EQKe/U6XZzMRj/VlEjHRF
 uCLfhPFI
 jjlMnmvSfW6ncodHUNcwkNHW2LH0umqiyBnUUv1ydxC2cgjWm242p9lT5GP2BKkwpA7mFxcc9EdQzAnRZMfLZVqBflPy7Zg60ZnCTXxtr4lFSyNemBcps96H49iJqZI5hrnFPWDn6AQepttCjQNeOOKkOsWbH6l77IbHkSiDNW4Dqsdx7LrK18V9KwvJsVCs9GWcESl1T0u1FzbJLW4igg0fqzL8LRpuTWMMFkLbAZGORAZ7znxELZ1eMiypVCeLjfOzJatIAekdMw0W+bQ8+hk54LDO8C/MPfddpcE6WLV206eHBO3Y+pgZ2pRn/Mhx2pTSxpIu1+0kgOi5lif9cu7r79snMkpI5nCpbvpXh/9+CUxbdY1frtfv9y5vfbMSiQu3vIxflGj/8386Dq+4CiYuyBIWGoPaIWY9z44mzJMLB0rLqW23sC9Ip/XYMmvUHwVnFd50r5cvFJRKb9sgpW7nKZgKs/G8khvDuwteNILSZ2NM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 01:12:47PM -0800, Dave Hansen wrote:
> Or, heck, I'm not that attached to these checks. Let's just kill them.

Works for me. x86 is the only architecture with them, although arm64 and
riscv have shadow stacks too, and the x86 helpers already keep
Write=0,Dirty=1 out of other VMAs. Patch below, without the Fixes: tag.

Rick, any objection?

-- >8 --
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH] x86/mm: Remove the zapped-entry checks

Zapping a range calls arch_check_zapped_pte() for every batch of PTEs,
which is every page for small folios, and arch_check_zapped_pmd() or
arch_check_zapped_pud() for every huge leaf. Only x86 implements them, as
out-of-line functions that warn about a shadow stack entry (Write=0,
Dirty=1) in a VMA without VM_SHADOW_STACK.

The warning is a VM_WARN_ON_ONCE(), so without CONFIG_DEBUG_VM the
functions are empty, but the calls remain. With the SRSO "Safe RET"
mitigation the return of every such call mispredicts.

The x86 helpers already keep such entries out of other VMAs.
pte_wrprotect(), pte_mkdirty(), pte_modify() and their PMD versions go
through SavedDirty, and only pte_mkwrite() and pmd_mkwrite() on a
VM_SHADOW_STACK VMA create the combination.

Remove the checks, their callers and pud_shstk(), which has no other
user.

In a KVM guest on Zen 4 with Safe RET, zapping 4K pages takes one branch
miss per page fewer. MADV_DONTNEED of 1 GiB gets 6% faster on anonymous
memory and 8% on shmem, munmap() 5%. THP is unchanged. Without Safe RET
the difference is within noise.

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 arch/x86/include/asm/pgtable.h | 16 ----------------
 arch/x86/mm/pgtable.c          | 26 --------------------------
 include/linux/pgtable.h        | 20 --------------------
 mm/huge_memory.c               |  2 --
 mm/memory.c                    |  3 ---
 5 files changed, 67 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 000fc6c1ca37..613c22c7838a 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -199,13 +199,6 @@ static inline int pud_young(pud_t pud)
 	return pud_flags(pud) & _PAGE_ACCESSED;
 }
 
-static inline bool pud_shstk(pud_t pud)
-{
-	return cpu_feature_enabled(X86_FEATURE_SHSTK) &&
-	       (pud_flags(pud) & (_PAGE_RW | _PAGE_DIRTY | _PAGE_PSE)) ==
-	       (_PAGE_DIRTY | _PAGE_PSE);
-}
-
 static inline int pte_write(pte_t pte)
 {
 	/*
@@ -1666,15 +1659,6 @@ static inline bool arch_has_pfn_modify_check(void)
 	return boot_cpu_has_bug(X86_BUG_L1TF);
 }
 
-#define arch_check_zapped_pte arch_check_zapped_pte
-void arch_check_zapped_pte(struct vm_area_struct *vma, pte_t pte);
-
-#define arch_check_zapped_pmd arch_check_zapped_pmd
-void arch_check_zapped_pmd(struct vm_area_struct *vma, pmd_t pmd);
-
-#define arch_check_zapped_pud arch_check_zapped_pud
-void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud);
-
 #ifdef CONFIG_XEN_PV
 #define arch_has_hw_nonleaf_pmd_young arch_has_hw_nonleaf_pmd_young
 static inline bool arch_has_hw_nonleaf_pmd_young(void)
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 4a105f283cfb..58e5012b56b0 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -797,29 +797,3 @@ pmd_t pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
 
 	return pmd_clear_saveddirty(pmd);
 }
-
-void arch_check_zapped_pte(struct vm_area_struct *vma, pte_t pte)
-{
-	/*
-	 * Hardware before shadow stack can (rarely) set Dirty=1
-	 * on a Write=0 PTE. So the below condition
-	 * only indicates a software bug when shadow stack is
-	 * supported by the HW. This checking is covered in
-	 * pte_shstk().
-	 */
-	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) &&
-			pte_shstk(pte));
-}
-
-void arch_check_zapped_pmd(struct vm_area_struct *vma, pmd_t pmd)
-{
-	/* See note in arch_check_zapped_pte() */
-	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) &&
-			pmd_shstk(pmd));
-}
-
-void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud)
-{
-	/* See note in arch_check_zapped_pte() */
-	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) && pud_shstk(pud));
-}
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780fe849ff8b..fc32289af58a 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -621,26 +621,6 @@ static inline unsigned int exec_folio_order(void)
 }
 #endif
 
-#ifndef arch_check_zapped_pte
-static inline void arch_check_zapped_pte(struct vm_area_struct *vma,
-					 pte_t pte)
-{
-}
-#endif
-
-#ifndef arch_check_zapped_pmd
-static inline void arch_check_zapped_pmd(struct vm_area_struct *vma,
-					 pmd_t pmd)
-{
-}
-#endif
-
-#ifndef arch_check_zapped_pud
-static inline void arch_check_zapped_pud(struct vm_area_struct *vma, pud_t pud)
-{
-}
-#endif
-
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e8684..6e49fa841911 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2558,7 +2558,6 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	 */
 	orig_pmd = pmdp_huge_get_and_clear_full(vma, addr, pmd,
 						tlb->fullmm);
-	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 
 	is_present = pmd_present(orig_pmd);
@@ -3045,7 +3044,6 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		return 0;
 
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
-	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
 	if (!vma_is_mm_managed(vma)) {
 		spin_unlock(ptl);
diff --git a/mm/memory.c b/mm/memory.c
index 0fb676dd2bd6..25d630033642 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1755,8 +1755,6 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
 		clear_full_ptes(mm, addr, pte, nr, tlb->fullmm);
 		rss[MM_ANONPAGES] -= nr;
 	}
-	/* Checking a single PTE in a batch is sufficient. */
-	arch_check_zapped_pte(vma, ptent);
 	tlb_remove_tlb_entries(tlb, pte, nr, addr);
 	if (unlikely(userfaultfd_pte_wp(vma, ptent)))
 		*any_skipped = zap_install_uffd_wp_if_needed(vma, addr, pte,
@@ -1795,7 +1793,6 @@ static inline int zap_present_ptes(struct mmu_gather *tlb,
 	if (!page) {
 		/* We don't need up-to-date accessed/dirty bits. */
 		ptep_get_and_clear_full(mm, addr, pte, tlb->fullmm);
-		arch_check_zapped_pte(vma, ptent);
 		tlb_remove_tlb_entry(tlb, pte, addr);
 		if (userfaultfd_pte_wp(vma, ptent))
 			*any_skipped = zap_install_uffd_wp_if_needed(vma, addr,
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

