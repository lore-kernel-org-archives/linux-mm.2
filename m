Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBD9DCC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4F46B009B; Tue, 13 Oct 2026 05:36:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6E806B009D; Tue, 13 Oct 2026 05:36:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5D706B009E; Tue, 13 Oct 2026 05:36:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8631A6B009B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:36:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 177B41403E3
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:36:44 +0000 (UTC)
X-FDA: 85317098328.28.D769CD2
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8E9F2140003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:36:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=W4qDJHtc;
	spf=pass (imf09.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791884202;
	b=JloEeP7YaOUDnvM8hP2zZ9XVFo9tTYe4Qa43qBP7XrRxYlDI6PpGwwYdVEH2XaAB+RU3CE
	eFUsfdLcHJt5layK42y2/vGBKnPxe4Epuet9H4c4GMcI8vLygIF9drwTz7nnbgojIy/JiP
	5jNnvoWovMLzLtj4+4kGb9KK+Uodaks=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=W4qDJHtc;
	spf=pass (imf09.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791884202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=q5NdZNxCSRtyhz8oP1rgzjW01hgyzNkTJZX8N4nqPNQ=;
	b=x5QCGf+2rIGblZptRHGIyaKEYEIu3AkdMcuZZFcn/PpmwEFVDLFdT1XdTtfHECdwo8Rndg
	OJE0dheGiU6h39MWiEF/4bam9Cthv8azVqr5jawSSYJ6U1bK0s8CNrC0iCSr1LOfnI/rv8
	N/cc0Xy2URmqeli1GMv4hU4wn/mmR2o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791884194; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=q5NdZNxCSRtyhz8oP1rgzjW01hgyzNkTJZX8N4nqPNQ=;
 b=W4qDJHtc9LVzt31VkunYswjtBLDSTpcyuUzILm1XB6uG7mZ04TQ+3KFRTHtf8WZEgriCWd
 8Ch8CWxaCDJWnDrog9CEUc4LPq0xprTx4biqWMEpJ3HMXKwyRyclKVS1sgde8+nGt/00zk
 dBW18D4wkGBuNDFvVRTGXFsh5rXGU5RYJl5NM6zMZtUQEMHtoGGDFDPnqyaqyFumk/d82Z
 2x4xRpHEvNhAk14q9h/ZfYtD572Pfy76PmfhfHFyN6ROeFjRl0ZIPqW4TwbHiQOB4sSzZr
 NSoA2DgLzNdecj/biFzjoR/64Mkb9JtMPGM/WROwBSMAtNViSSabMRubKYxmTw==
Cc: <ryan.roberts@arm.com>, <dev.jain@arm.com>, 
	<baolin.wang@linux.alibaba.com>, <lance.yang@linux.dev>, 
	<mark.rutland@arm.com>, <akpm@linux-foundation.org>, <david@kernel.org>, 
	<ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>, 
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, 
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, "Zhao Gongyi" <zhaogongyi@bytedance.com>, 
	<stable@vger.kernel.org>
X-Lms-Return-Path: <lba+26acdfba0+4bbe47+kvack.org+zhaogongyi@bytedance.com>
Date: Tue, 13 Oct 2026 17:36:00 +0800
To: <catalin.marinas@arm.com>, <will@kernel.org>
Subject: [PATCH] arm64/mm: restrict transparent contpte mappings to valid PTEs
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Message-Id: <20261013093600.54995-1-zhaogongyi@bytedance.com>
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8E9F2140003
X-Rspam-User: 
X-Stat-Signature: 19hwsmw3phi4eyzqru4euptc7i5ds6s6
X-HE-Tag: 1791884201-271082
X-HE-Meta: U2FsdGVkX18ExzZIqspOyHxrm2MnGygnKIRh+sVOF9EpGIN1VUR2NdaAbn6a3mgw95iiIdEDZHLXzUETOSdjdoG5DP6s+FMcpwbAgNZJqqk+/R29SgWxZ6Tb68YWj+vgK6kGKx+FSa5FwNFpqhw3h9Of0j9SuO224ATZ59qChAo58JkjaQB/kdsYd/Tp4UDxqomZJEKYERxurGwmtLNJJMKKwjorsiKRgSyiKCcN0t+nK+ZErzftbDVvRWbFAsKc6F2u1kp48Us2I7EZoqe6bHHaqL5w4nun3RpwvYoFJo9jucs4E0PmTQ50BA6e7KXUXtqWbJQ5FBIavCLf9pNKtN+SY7b3bVv/knHV8JH0lrhCfbJPUVwG4g4BA4QsyNAR5tbByUa8CFlkNRNUSF95cHOwM8EE+7W07QbqWSq68ioeiTeCNYtwMGextBa5sBUhaej5OWrR/247zCEeyWJoqEfeYo4FeZpf4EAt091X+jtBGBW9co5OigosudSVMeDtDxKoq9m7IuQZJMk9qterWlwOBQE8LfRaD63uIYytGpOqNss+Gh2hgX19RhwcoW6IhAn5DCK9TtbsjPICxcrJ7hX88nEqbIGe4DX+PmhLucSE/yoc/CWA53EpG1sEHVftdbjfJSNFTd5PEqNp1qjHdiHJ4KAOnYuksHdRNDgnFpSD+xFky0oucekB0hCnrN6DaNZSuoTVLp6PvKh2292pHELRPLTHfqHCguRjHXZDdbA7Gggyz+QMxZhsvAE9WqCHHj+TSz7D3kExaBQgQ2D+Tb2KybohACtQjmaUIhcUXuDNZbLndzGXdSDY/EdYRpoUA+tvRD6YSfwZR5KQ1PsE+1DQ+o6tAS7sJDhQxBGOVMy4i5GrF9PcKpGfSsUNnWZYa38O0/GFFpdIdUNYACiBera8UUOgRiayByET2yG1ve6M46aEeHp55+QOE6ifpeLbsyb/Y+93KO5ulxuwP5m
 SSFvSXIG
 +VJx7N8ubFMtM5+ef0Man8+oHwZvc/2N7KBM+gkp6jNJclIPeDNIflhO/hZGDpAxXzuZSuP5Z+Hn2ZLEdjTzrWJgAppwxfhnjcKIOTPaZttCoPCWrefS45HRXbNAiF+4obGVU/25P+7ejfX1MeDJTvIT8XnyeP1aKsQ6FZqLXM6byC00woq6oDMt884j7+DUKsrASVJ2C3/qaKeVWyOyHF591nIEsJUz7ZQ+4Yq62cbv89Mj1KTxrwaZL9M8ngy5Pwow5wEiuBNufYI7Y8pJk4wOpLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The transparent contpte layer treats PTE_CONT as software state: when a
PTE has PTE_CONT set, the contpte helpers may align the operation to a
CONT_PTE_SIZE block and operate on the whole block. That invariant only
makes sense for valid mappings. Explicit users such as hugetlb manage
their contiguous encodings separately.

contpte_set_ptes() currently sets PTE_CONT from alignment alone. Batched
set_ptes() users can therefore install present-invalid PTEs with
PTE_CONT set, for example mprotect(PROT_NONE), NUMA hinting through
modify_prot_commit_ptes(), fork() copying a PROT_NONE large folio, or a
PMD split installing PAGE_NONE PTEs.

This is not a hardware programming problem: invalid descriptors are not
translated, so the hardware ignores descriptor bits such as PTE_CONT. It
is a software-state problem. Some arm64 fast paths intentionally test
pte_cont() directly instead of pte_valid_cont(), for example commit
9970a9a27ffc ("arm64: mm: implement the architecture-specific
test_and_clear_young_ptes()"). Fixing the producer side preserves these
fast paths and covers all consumers.

In the observed failure, mprotect(PROT_NONE) installed a full
CONT_PTE_SIZE range of present-invalid PTEs with PTE_CONT set.
MADV_GUARD_INSTALL then zapped one PTE. The nr == 1 clear_full_ptes()
path only unfolds pte_valid_cont() entries, so the neighbouring
present-invalid entries kept PTE_CONT while the target entry became a
guard marker.

clear_refs_pte_range() then reached the marker through:

  ptep_test_and_clear_young()
  test_and_clear_young_ptes()
  contpte_test_and_clear_young_ptes()
  contpte_align_addr_ptep()
  __ptep_test_and_clear_young()

The marker changed from old_pte=0x00000000000047c0 to
new_pte=0x00000000000043c0 by clearing PTE_AF. For swap PTEs, bit 10 is
part of the swap type field, bits 6-10: 0x47c0 is SWP_PTE_MARKER with
offset 4, while 0x43c0 has type 15 and is decoded as an ordinary swap
entry. Zap later warned in swap_put_entries_direct() with a bad swap
entry.

This is triggerable by a user process against its own address space. On
systems running with panic_on_warn, the warning becomes a denial of
service.

Fix the root cause by making contpte_set_ptes() use the transparent
contpte encoding only for valid descriptors. After this change, the
transparent contpte layer preserves the invariant that pte_cont(pte)
implies pte_valid(pte), so fast consumers can keep using PTE_CONT as
sufficient evidence of a transparent contpte block.

Fixes: 4602e5757bcc ("arm64/mm: wire up PTE_CONT for user mappings")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
---
Validation on an arm64 QEMU/KVM KASAN setup with CONFIG_ARM64_4K_PAGES=y
and CONFIG_ARM64_CONTPTE=y, using an out-of-tree guard-region reproducer:

  populate a CONT_PTE_SIZE anonymous THP range
  mprotect(PROT_NONE) on the range
  MADV_GUARD_INSTALL on one PTE in that range
  write "1" to /proc/self/clear_refs
  restore access and remove the guard marker

  Unfixed kernel: failed in the first iteration, with 65 bad swap
                  messages and a WARNING in swap_put_entries_direct()
  This patch:     completed 100 iterations without warnings

Additional producer-side instrumentation confirmed the same invalid
batch state outside the mprotect reproducer:

  Unfixed fork():     copy_page_range() wrote out_cont=1
  Unfixed PMD split: split_huge_pmd_locked() wrote out_cont=1
  This patch:        both paths wrote out_cont=0

 arch/arm64/include/asm/pgtable.h | 5 ++++-
 arch/arm64/mm/contpte.c          | 7 +++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 6000905a2..d6246042b 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1650,7 +1650,10 @@ extern void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long ad
 /*
  * The contpte APIs are used to transparently manage the contiguous bit in ptes
  * where it is possible and makes sense to do so. The PTE_CONT bit is considered
- * a private implementation detail of the public ptep API (see below).
+ * a private implementation detail of the public ptep API (see below). The
+ * transparent contpte layer maintains the invariant that pte_cont(pte) implies
+ * pte_valid(pte); explicit contiguous-encoding users such as hugetlb manage
+ * their entries separately.
  */
 extern void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index 0acab179f..851fa2e44 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -463,6 +463,13 @@ void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
 	if (!mm_is_user(mm))
 		return __set_ptes(mm, addr, ptep, pte, nr);
 
+	/*
+	 * Keep the producer-side invariant documented in pgtable.h true even
+	 * if a direct caller passes an invalid descriptor with PTE_CONT set.
+	 */
+	if (!pte_valid(pte))
+		return __set_ptes(mm, addr, ptep, pte_mknoncont(pte), nr);
+
 	end = addr + (nr << PAGE_SHIFT);
 	pfn = pte_pfn(pte);
 	prot = pte_pgprot(pte);
-- 
2.39.5 (Apple Git-154)

