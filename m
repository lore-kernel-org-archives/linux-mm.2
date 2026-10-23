Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3396C606A324
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 12:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=MaivSzgh
Received: by kanga.kvack.org (Postfix)
	id 2F3B56B0B4C; Fri, 23 Oct 2026 08:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D296B0B4E; Fri, 23 Oct 2026 08:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16D716B0B4F; Fri, 23 Oct 2026 08:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D94F96B0B4C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:13:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 798801C3B4B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:13:10 +0000 (UTC)
X-FDA: 85353780540.07.515C394
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf22.hostedemail.com (Postfix) with ESMTP id D889DC000D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:13:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=MaivSzgh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792757588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qoF1RPn6HPNki8UOdmD2+HVuHX6Hw9QlW7A9xjkpPmY=;
	b=dhkS356xjFzNGVCgu6/5fXvSfrEmIDv92qQU9Sb+v6U2jWSrYLOn5d85Hdh0/IxR9PMa2w
	48YO58lCzR5oyjom3AxfEHa9c9dsMptRldhabKv7KuI4SyK+bVkyKfe9Rb6cNQ62VJHSDG
	SYlFkqVYffCUlm8qYLBnRpjJETeFVNc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=MaivSzgh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792757588;
	b=dx8NElqdxRP5TN9C9k6QDugQdpdLW+8Ww4ylmZjxogt9him6B2P0VgxhQHBKkv3PGi4ME4
	66X1OaOvJuR0751fMo3ndj9v/5ee+It5pIO1nQwr5Xhl2rsmf3bHmuppVZNON4mV8lExii
	JJUFMH0mjqew0PrWSzLi0IG/NWX4/Jw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792757582; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=qoF1RPn6HPNki8UOdmD2+HVuHX6Hw9QlW7A9xjkpPmY=;
 b=MaivSzghVkP2FD9N3kGx7UPHk2q91thBRtwjvhEYGQuX73lpbHhRpe6H02Bhga9v1lKmec
 7oVUAZYJUEiW57hX/2MeWD7agOBuJQzv8Hbf6NPUYbsHMgNSjGsOnddKL/UDVKeBkysry0
 wVkdGzJtXRoW49jRzQXguye1trMKtZb1hEPIB1MqADqatcbhZMnObWX1t2ShpNesfYD5gz
 CWNeNjKb2QOjR6LGgyr2fSXiVHq9AYV+AXB4SMSfUmZBeARdDy/2i3JFNIn6cfa2E+5exK
 MElIjXWLYT5WdjU2liUtR03E4NQB3CzfNg1NiNC5JME5uEghFaexphiA+iMo3w==
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
Content-Transfer-Encoding: 7bit
Message-Id: <c4c33aaddf5741e125e4130f2220b1892b50aa61.1792756709.git.zhaogongyi@bytedance.com>
In-Reply-To: <20261013093600.54995-1-zhaogongyi@bytedance.com>
X-Lms-Return-Path: <lba+26adb4f4c+89c3e8+kvack.org+zhaogongyi@bytedance.com>
References: <20261013093600.54995-1-zhaogongyi@bytedance.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>
Subject: [PATCH v2] arm64/mm: restrict transparent contpte mappings to valid PTEs
Content-Type: text/plain; charset=UTF-8
Cc: <ryan.roberts@arm.com>, <dev.jain@arm.com>, 
	<baolin.wang@linux.alibaba.com>, <lance.yang@linux.dev>, 
	<mark.rutland@arm.com>, <akpm@linux-foundation.org>, <david@kernel.org>, 
	<ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>, 
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, 
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, "Zhao Gongyi" <zhaogongyi@bytedance.com>, 
	<stable@vger.kernel.org>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Date: Fri, 23 Oct 2026 20:12:33 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
X-Rspamd-Queue-Id: D889DC000D
X-Stat-Signature: pft8shi3h5zy1677kpcd6hqpkk5ca1d1
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792757587-594965
X-HE-Meta: U2FsdGVkX19vynTb349fiZt/C5m1nSBO+HUT5VddpvCz5zfJBXVuK1WeFyhd0tvUQSbirH4pCB/2Yj7btw81lKXTAsrccUDYoyIVl2Y+j1YBAjWRM6p6dJR5gtqqyWQMkevvpRf+LBLHe+EmxYXPDuCgvtyph76nzPB1b2A4dZO78oxE990ybSEmzm5mjS4U25SEw5LpsGy9OPEnRT7BEV+FAkdlsV+tr8p8TeHcezt1QwPIj11s2AbLaMvekqo3THdAWn44TphdYMIw7uS5Z62yRY7A/0YxTjlAACS0KiqomKMXcCXzfUgFHPJ2u3asdpJyQO4e1K2H8EMrAb5yFG8teSTNGx/1IeaKp/dE3oIZADJyZmbOY7ZKKGbsx6sxF+UMiGF3d3A8lghhOFIkveGX39mErOjJ7ghpL/2jus+SWJzVlB++tqgcjGj1z22QsIwAd6TjFeT5iAmOLWaELIZAvP9xTxXrRv1ImTuLUO8pEuHacxPlAwzropZGEEoq4EVE8X8rLuzt3DdahCZtxEuJoPjxOhcqlYzAB5T7Jotoc3Kew6JqoU3j77Q23nIYjs4b0A72eQap2yJ52J3TXZqUmApgD3sMG+JkuQjEK9P1fZv75KD05Yj2Adr4564atM5+4lbBPtIldeRjpmZy2BOGyvfpkkPqJIF8h+siKS4xPi7nS03LbWNSbFXiFbyMVefHOX+UhCLQ0Vbe9ZGvcY9+XF7Q7QBX0ngCWr8jICWEXVQJL9ClaSRSHJWZt9CyyztqkwV81xG5fgIEQgb4h8qL2sAnPH07YEpAcq/i/em5uXlVqgOMKsU/9cH+vFFpZUrvuRjLcPYE065I16OOImchyuQj3QOpC85Qnro2eebegnuOeeX+qobiqq/Lgyo8SdRDfHiK8sTchobtg38jy1qoOv1lYX9lXRz4IIaQCWu8lEYlM21+lSG5CRu2KXaVTaqT0qriX3WiQATeNuF
 LR6P3I1f
 ohMscrFt78p56J1K2vtOiHAECO2qZey9+0e6NOSjZFGCQRBYJUqlk0DiQJr6K1ErNvRppZFuRQ4DSuEl0ohp00yKwW4b+R8ocG1UXJD/lXCJKnPxP8JqihhX03Hpt6kmslkvSbW0MyGh3G7RgUcJcHhry1jixGcKPo1iJb5haeyWn9lnwTeuHLRg1NvRkHpWdIFEBs+bB8I+GioVrKeh34ExY86WfSwi1j1Q4uebV/ZUmuhYICVJ5hWYK/CeDrtiv19hj5An4k2ikntVdS9o5Vut2jeOtzvTHMy97ylaFwpleWzZfxJzReBJJOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The transparent contpte layer treats PTE_CONT as software grouping state.
When a valid PTE has PTE_CONT set, the contpte helpers may align an
operation to a CONT_PTE_SIZE block and operate on the whole block. The
current single-PTE helpers use pte_valid_cont() to identify such groups;
this is a helper contract, not an architectural restriction on using
PTE_CONT with present-invalid descriptors. Explicit users such as hugetlb
manage their contiguous encodings separately.

contpte_set_ptes() currently sets PTE_CONT from alignment alone. Batched
set_ptes() users can therefore install present-invalid PTEs with
PTE_CONT set, for example mprotect(PROT_NONE), NUMA hinting through
modify_prot_commit_ptes(), fork() copying a PROT_NONE large folio, or a
PMD split installing PAGE_NONE PTEs.

This is not a hardware programming problem: invalid descriptors are not
translated, so the hardware ignores descriptor bits such as PTE_CONT. It
is a software-state problem. Some arm64 fast paths, such as
test_and_clear_young_ptes(), test pte_cont() directly instead of
pte_valid_cont().

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

Present-invalid PTEs could retain PTE_CONT as software grouping state,
but their single-PTE modification paths would then need to recognize
and unfold those groups consistently. Since current helpers mostly use
pte_valid_cont() for membership, avoid creating present-invalid
transparent contpte groups in contpte_set_ptes(). They bring no hardware
benefit while invalid, and eligible valid ranges can be grouped again
when they are installed.

The public set_ptes() wrapper already clears PTE_CONT before calling
contpte_set_ptes(). Return invalid PTEs through __set_ptes() directly,
and warn if a future direct caller unexpectedly passes an invalid PTE
with PTE_CONT set.

This is triggerable by a user process against its own address space. On
systems running with panic_on_warn, the warning becomes a denial of
service.

Fixes: 4602e5757bcc ("arm64/mm: wire up PTE_CONT for user mappings")
Cc: stable@vger.kernel.org
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
---
Changes in v2:
- Return invalid descriptors through __set_ptes() directly instead of
  silently clearing PTE_CONT, as suggested by Lance Yang.
- Add VM_WARN_ON_ONCE() for an unexpected direct caller that passes an
  invalid descriptor with PTE_CONT set.
- Describe valid PTE grouping as the current helper contract rather
  than an architectural restriction, following David Hildenbrand's
  feedback.

Validation on arm64 QEMU/KVM with 4 KiB pages, CONFIG_ARM64_CONTPTE=y,
CONFIG_TRANSPARENT_HUGEPAGE=y, CONFIG_KASAN=y and panic_on_warn=1:

  Unfixed kernel: guard-marker reproducer warned and panicked on its
                  first iteration.
  v2 code:        100 guard-marker iterations, five fork probe runs and
                  five PMD-split probe runs without warnings.

The runtime build used base af32da41b032; arch/arm64/mm/contpte.c
matched the v2 commit's Git blob ID. The pgtable.h change since that
run is comment-only. The v2 commit itself is based on 24a19b953e2a
and was not boot-tested separately.
---
 arch/arm64/include/asm/pgtable.h | 3 +++
 arch/arm64/mm/contpte.c          | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 6000905a2..6c81a3d22 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1651,6 +1651,9 @@ extern void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long ad
  * The contpte APIs are used to transparently manage the contiguous bit in ptes
  * where it is possible and makes sense to do so. The PTE_CONT bit is considered
  * a private implementation detail of the public ptep API (see below).
+ * Single-PTE transparent contpte helpers use pte_valid_cont() to identify
+ * grouped PTEs; explicit contiguous-encoding users such as hugetlb manage
+ * their entries separately.
  */
 extern void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index 0acab179f..be78d8602 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -460,8 +460,10 @@ void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
 	 */
 	VM_WARN_ON(nr == 1);
 
-	if (!mm_is_user(mm))
+	if (!mm_is_user(mm) || !pte_valid(pte)) {
+		VM_WARN_ON_ONCE(!pte_valid(pte) && pte_cont(pte));
 		return __set_ptes(mm, addr, ptep, pte, nr);
+	}
 
 	end = addr + (nr << PAGE_SHIFT);
 	pfn = pte_pfn(pte);
-- 
2.39.5 (Apple Git-154)

