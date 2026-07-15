Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38967C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1E56B00AF; Wed, 15 Jul 2026 14:38:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91386B00B0; Wed, 15 Jul 2026 14:38:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80416B00B1; Wed, 15 Jul 2026 14:38:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 991B96B00AF
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:38:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E965DC024B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:38:03 +0000 (UTC)
X-FDA: 84991870446.06.594D7F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id F0C48A0009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:38:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=R6YsU9y3;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784140682;
	b=k6jGqfRYB3O/iGwIiCNmE9jIuluxb2PQb1PXnJnqHEwFrPVPt7nGOlbRwTtoGcL9jMrzFw
	Lfyw+sLaUAD+Jz2U48CAFiTYB250FfvXj12y4ormARjXBUloBg9GdX2d9dgIyyyzsHyyF8
	4zffG4Go2gw+K+8bMWzW/NX03Qz77EI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=R6YsU9y3;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784140682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVD5YICoFs6IGZko2faFmBTnBcS21tFoTzk2EZjj06c=;
	b=NpXO5tkm4QCtOsPddlxR1IBNvk+aOSJAmptYKmQnNuC87XrfSyMGe3kq93ZAv7dMqe1jTR
	w7/cgsAay2SPuw18MqoWFtj7ys/rs25UjEi9tN3n9FmBqKa/3APe+LW/yvk9CE9SIo57M+
	mwI9qROxDfveyFs30J5d8rK6+v3jc5o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5DE64017F;
	Wed, 15 Jul 2026 18:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA981F000E9;
	Wed, 15 Jul 2026 18:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784140680;
	bh=MVD5YICoFs6IGZko2faFmBTnBcS21tFoTzk2EZjj06c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=R6YsU9y3n0TDYpeduksymjcvij1ta9ZUFduBjNE7KPDuG5FCrySIN/Cl0MsGX6Z/k
	 DmTqgFlF9pAO0Rsv439GGi7L1XAUCT2c26cG8ZSzZlC/9K6gGkhbfaXOdFc2lrUQO0
	 LLG3nqzkh3F0SkMWkSaLYY9twTc7K23pSBMbE8OE=
Date: Wed, 15 Jul 2026 11:37:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
 anshuman.khandual@arm.com, david@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 Wen Jiang <jiangwen6@xiaomi.com>
Subject: Re: [PATCH v7 0/7] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
Message-Id: <20260715113759.74d68fef26f1df0c6bbcc85c@linux-foundation.org>
In-Reply-To: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F0C48A0009
X-Stat-Signature: 73z9fcy9ytd87zxwafannaejaa1u3wfq
X-HE-Tag: 1784140681-997505
X-HE-Meta: U2FsdGVkX19fKzQup2vW19vCd+uAZ39ctHEbOTr9GJc1m7W6ZVuQvNfECFsb+Zh/ucdPBgl2/YFQ5bKe3QQU6QnDLGT2EXG7Gys8M0dTiojIe4/Lhdpqalf6ijivEbBpDhVeeFszhlpjrG8ZkRXObjcfoLP3MlIkAKEwlrz6sKIFUumEG6PyVS6rTytZCbh6YU16DuWtjLIyc7tt4FNZgnYPghpg3FGKQNRfhq31V3t/QhglxehAmNvl4Vj8gavp0JYqC6Bw2b1G1Q6if96lbreOQccv53qeNAxF+qhSqf1VaOnzXPhnucm9YOJoB62UU2evFY0SmA/PxopjJwFnUKPxucOJUdYkwciFQzZdqROQk00bb0wg5vTjgbxBWpWstL3mexJxK+oMeI5SAG38YGOUbhNg3iJk4G7i39gxiD1bIKJ64QCT871JCGXBlFx6qkdUlRg2Vfv0SFGVvIW9MErmtWgMiKxhpBL/0DCMP1PrhkCA5c3eyOgw0sI3JjHlXbiRJAKVmweyuBkvRwCMMsBd7Dm7CARH+mvVq9FwOn2pU8zt7rrtKCOTXPLeIJu44W2EuyyA2J7JYLJrc2UmQScNuWQLP3qs9VPwIUvOZ4xcS3Ath17LN4G0+fioGBToX2Q9pWjf8Ys2J2UR47/onPKFAFzv4KxrfRdApPgUAHIPbijSmjfMz0EefAb7LpbsO5VFDQBg2N1A332fEnFon4lqZ4RB0ZMNGlyew8mL2KJoS2IoZTxtA1xsoS+QYL+eehv8kUjpXhTzH9v79kxl1BCvXxdtdLyRl3GHZ5ZsikW7tR/I4pMZh0VLfNjb7TRXETO3gXSp/fjG0EcR4NqN8FKqrh/owTdoySZ97AVkwAgFh73sWMWTWQixYu2BLS1w3AMS5IDW81GBXMESU9aeV/VKO7SqTkhRT5zWiHGUXf95RNP/HSx4Q1QsIRKULHM/yc+uQhDBnmCH9ZSmZmT
 WXW4igig
 C7WLFkDJWJqXmAuGCQZzxQckpYYQ84Bq2L5+4j0XIlC7iSdxgbMkG1aztbebwV2fbJe6lyKApopuR2LSfy/vKxePe60Vvx+J2ZpgAMG1WugbKd/hQ1WAtBD75UqlGneJVn3f/nMiaxrZya9tbzuQlRnc8Yl7rgWXqGpn/MqFZoBCkUsK8pH9qoW4Cq4x+A7PvBVEciMM5fSXw3ZqJg4mWqn0F5OOevqhUX8zZ55YrWc/d8kLFjF4p9QXxoKXo47eJ2liQ668uAeu8ek6hYqEqQuXEPTr5h/OFQLIqQoml7+w3ENbYn4rObAo09mTmOx3yo23Km/v1NiuNBGRLa2V71gp0/UELs/N9Ptw5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Jul 2026 20:08:06 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:

> This patchset accelerates ioremap, vmalloc, and vmap when the memory
> is physically fully or partially contiguous. Two techniques are used:

Thanks, I've updated mm.git's mm-unstable branch to this version.

> Changes since v6:
> - Add a clarifying comment about the reuse of hugetlb helpers
>   by non-hugetlbfs(vmalloc) mm code (patch 1)
> - Expand the arm64/vmalloc commit message and comment to clarify that
>   multi-CONT_PTE_SIZE values are vmalloc mapping spans, not HugeTLB
>   hstate sizes (patch 2)
> - Move the local steps variable change in vmap_pte_range() into the
>   vmap_set_ptes() extraction patch (patch 3)
> - Propagate vmap_pages_pte_range() errors through the upper
>   vmap_pages_*() levels instead of returning -ENOMEM for all failures
>   (patch 4)
> - Add a preparatory vm_shift() helper patch before the batching patch
>   (patch 5)
> - Guard the PFN alignment clamp in get_vmap_batch_order() against PFN 0
>   before calling __ffs() (patch 6)
> - Fix kmsan_vmap_pages_range_noflush() indentation in the batching path
>   (patch 6)

Here's how v7 altered mm.git:


 arch/arm64/include/asm/vmalloc.h |    2 +
 arch/arm64/mm/hugetlbpage.c      |    5 ++++
 mm/vmalloc.c                     |   31 ++++++++++++++++-------------
 3 files changed, 25 insertions(+), 13 deletions(-)

--- a/arch/arm64/include/asm/vmalloc.h~b
+++ a/arch/arm64/include/asm/vmalloc.h
@@ -29,6 +29,8 @@ static inline unsigned long arch_vmap_pt
 	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
 	 * aligned in both virtual and physical space, then we can pte-map the
 	 * block using the PTE_CONT bit for more efficient use of the TLB.
+	 * The returned mapping size may cover multiple CONT_PTE_SIZE blocks,
+	 * capped below PMD_SIZE.
 	 */
 	if (max_page_shift < CONT_PTE_SHIFT)
 		return PAGE_SIZE;
--- a/arch/arm64/mm/hugetlbpage.c~b
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -94,6 +94,11 @@ static int find_num_contig(struct mm_str
 	return CONT_PTES;
 }
 
+/*
+ * num_contig_ptes(), set_huge_pte_at() and arch_make_huge_pte() can be
+ * used by non-hugetlbfs(vmalloc) mm code to set multiple huge mappings
+ * at the PTE level.
+ */
 static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
 {
 	int contig_ptes = 1;
--- a/mm/vmalloc.c~b
+++ a/mm/vmalloc.c
@@ -616,6 +616,7 @@ static int vmap_pages_pmd_range(pud_t *p
 {
 	pmd_t *pmd;
 	unsigned long next;
+	int err;
 
 	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
 	if (!pmd)
@@ -642,8 +643,9 @@ static int vmap_pages_pmd_range(pud_t *p
 			}
 		}
 
-		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift))
-			return -ENOMEM;
+		err = vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift);
+		if (err)
+			return err;
 	} while (pmd++, addr = next, addr != end);
 	return 0;
 }
@@ -654,14 +656,16 @@ static int vmap_pages_pud_range(p4d_t *p
 {
 	pud_t *pud;
 	unsigned long next;
+	int err;
 
 	pud = pud_alloc_track(&init_mm, p4d, addr, mask);
 	if (!pud)
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
-		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift))
-			return -ENOMEM;
+		err = vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift);
+		if (err)
+			return err;
 	} while (pud++, addr = next, addr != end);
 	return 0;
 }
@@ -672,14 +676,16 @@ static int vmap_pages_p4d_range(pgd_t *p
 {
 	p4d_t *p4d;
 	unsigned long next;
+	int err;
 
 	p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
 	if (!p4d)
 		return -ENOMEM;
 	do {
 		next = p4d_addr_end(addr, end);
-		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift))
-			return -ENOMEM;
+		err = vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift);
+		if (err)
+			return err;
 	} while (p4d++, addr = next, addr != end);
 	return 0;
 }
@@ -3591,6 +3597,7 @@ static inline unsigned int vm_shift(pgpr
 static inline int get_vmap_batch_order(struct page **pages,
 		pgprot_t prot, unsigned int max_steps, unsigned int idx)
 {
+	unsigned long pfn;
 	unsigned int nr_contig;
 	int order;
 
@@ -3602,9 +3609,11 @@ static inline int get_vmap_batch_order(s
 		return 0;
 
 	order = ilog2(nr_contig);
+	pfn = page_to_pfn(pages[idx]);
 
 	/* Limit order by pfn alignment */
-	order = min_t(int, order, __ffs(page_to_pfn(pages[idx])));
+	if (pfn > 0)
+		order = min_t(int, order, __ffs(pfn));
 
 	if (vm_shift(prot, PAGE_SIZE << order) == PAGE_SHIFT)
 		return 0;
@@ -3621,7 +3630,7 @@ static int vmap_pages_range_batched(unsi
 	int err;
 
 	err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
-						PAGE_SHIFT, GFP_KERNEL);
+					     PAGE_SHIFT, GFP_KERNEL);
 	if (err)
 		goto out;
 
@@ -4199,11 +4208,7 @@ void *__vmalloc_node_range_noprof(unsign
 		 * supporting them.
 		 */
 
-		if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
-			shift = PMD_SHIFT;
-		else
-			shift = arch_vmap_pte_supported_shift(size);
-
+		shift = vm_shift(prot, size);
 		align = max(original_align, 1UL << shift);
 	}
 
_


