Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2E64CA5FCE
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 08:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87F816B008A; Sun,  4 Oct 2026 04:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809C76B008C; Sun,  4 Oct 2026 04:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3E16B0092; Sun,  4 Oct 2026 04:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8266B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 04:19:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AD09120B2B
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 08:19:26 +0000 (UTC)
X-FDA: 85284244332.24.4DD3AE0
Received: from mta1.migadu.com (out-157.mta1.migadu.com [95.215.58.157])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6988A40007
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 08:19:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cInPyJUB;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.157 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791101964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KvagPUqMOcLymFNy70AsIuZOLdYZiwr6NU0P2uKsOp8=;
	b=xjLi/zwzf3O0YT5rNeWIe/ux7QOPWL/S9n4Ihj2tBUhO12F+N8U2MtdOjLes/pfY05Ci17
	DR7o64VLe2SVraCWGx49oN+2R0AKsitsT3oy0Z7ALwzpL/88MApxPvCsRd3A68gRGdHGEz
	KlY2Vfs8zHzizxOmibDOrE68TZK8Fnc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cInPyJUB;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.157 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791101964;
	b=L54OvC7h7tN5lfuuDlgYOfGRbanzroBsjT/57pl4dFhWfqJGrQVzoWmZnSTs1cpEKnp6zY
	fHmMW7pCJJgZF3Yx1yigzDcTRxVl6O9kQOYiQpCv9GeRTh5UEo1bZdZXIc6lO7OuP+Bfmy
	CKjfpG70cKcyLdRHcuz8IsHKa++8Wog=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=N1P1P3jMKJo9ggmNihU/EA7zpJLYlMm+cg9cdHhLxxg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791101962; v=1; x=1791706762;
 b=cInPyJUBLGSY2wxghyK4yA+Y3qVmWpB0fPPJsxBZ/om6qJbIgcRDoGOkaVyPvZu0Ptj6/RZG
 lYJi6x34tB4cfYSl/Yu346FdSoWRvDu6wLjcomAj+fgeLjtD6kGs82Jl7U50eu7o0e2pNexUin/
 33Oi4UkExep6r0kMqHOuvyw0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e992c55305e9727b;
	Sun, 04 Oct 2026 08:19:22 +0000
X-Mizu-Trace-ID: e992c55305e9727b
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: usama.arif@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	baoquan.he@linux.dev,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	liam@infradead.org,
	ryan.roberts@arm.com,
	vbabka@kernel.org,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com
Subject: Re: [PATCH v8 26/30] mm: handle PMD swap entries in UFFDIO_MOVE
Date: Sun,  4 Oct 2026 16:19:17 +0800
Message-ID: <20261004081917.20111-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261002095503.3585565-27-usama.arif@linux.dev>
References: <20261002095503.3585565-27-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6988A40007
X-Stat-Signature: 5ox9tab648t5hzqoa5bb9mpg9dp41dga
X-Rspam-User: 
X-HE-Tag: 1791101964-74039
X-HE-Meta: U2FsdGVkX1+sSKhVLTUu4oST7+0LcTz10JsFIUKck+qwyAVfOgW0HUHFIn945vVkH5sYohYk52vZY4zC3DYeO7Mns7Pv8tZwkF/ZsHyKtGIWeEoJpeS26+uJrnMXqX8Ap+EKT/xWOjWRT+TFnuOuC3OahxsRKPkpAeQO6QhhkpfIbpcnh+zaFCUiSSl2W3JKQk2UlPrdjLpVygXuJTgHHInpQZtjZgAPA3itclo3aUcXGBScqj+igqWzxBUJylPcUmPA7FG/03rcaifyB6EeuJBwkPfMGwmK1uB0oy3xN64MenT9y4A7qzVOZNgGAGCA1irMkAu3ZXPrkSqLPLftWWBDI+z1/IbTfuxyDWZFaXwG2toZWxIhpl+fSM4YqfuApXWpsYEx3KssVBL1FbPpWU2kXfTd2onUeaFGTMhUyfS0IrdVwXleqN9mlJxj9bZSqQHsjxy+2ye6zCTSbKHR/aJzxImenzPhXss2EKY13IQpqE36bhwvWxGkdCvTILoB7c/PA2lFEfQhJtYpD+adxd+0ynMwW8yyC1CESlB9tPW0C6N5R64klgmDa9keoDGnmRcKUDxIi+TZxHBnAtwsTdHAPqGuquuFRgCH7L+r0uYrxbpj54kXhD6ievCOTU4K8zU9DPz+m/fOBLCbpbL2CtwJgQUW225JVnx3oxvHCPDYMgxYI5mJrYQLTZIyOfGaYXZh1vBnNd90hEGlU3Omyggmk34/amUoODrhkDMiFKhihD8AkPWze7YUpQ4JnJ2RxmmyOj/ksDH5rg0U/xOr504ZwrUk26LYz9MNW55X2hRgonki7IZB79hEbMdGyDyoUj2GIt16WsnNDZq058a5rYcBv6YlxUkxFoVgTZidBXC+x4e+X3qLp736NIhT2qfE30b7LaWsVI6cRyww8j90TYSp04ucICjDhyXBtBTbEyxWu/pp+RZcPxp/r4JURWHt8CCr9IhORbX3yiZSC8T
 /9+riiMq
 4Zk0eGq4nudR0xHHJTZbw4PUEXe0zBAC4GzytptaDt5aq53ak3DCIUKELc5+DfEpBu5wkBcrMvQfDDMqhyHO0QZ1OXQN1VGCvBo4YEm5JNxE7iO/dU1j3BwPD7Y1n6Dg5OGsaTDFOJ3CsPHzRxkAiTppkWB2KAexk/Qwe3Mf7kKRndUQa5RXLWHYfPKQoWAN+fSl18qJKwPI88P2eHiDHjKoP9vjW0lYdYn8eMaDy89zVW1f9oPcedV0ss4V3uEOTUminUItnDbeTiML0kFfq0qgt1Zq8ETy6Wp9N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Usama,

On Fri, Oct 02, 2026 at 02:52:40AM -0700, Usama Arif wrote:
[...]
>+static int move_swap_pmd(struct mm_struct *mm, struct vm_area_struct *dst_vma,
>+			 unsigned long dst_addr, unsigned long src_addr,
>+			 pmd_t *dst_pmd, pmd_t *src_pmd,
>+			 pmd_t orig_dst_pmd, pmd_t orig_src_pmd,
>+			 spinlock_t *dst_ptl, spinlock_t *src_ptl,
>+			 struct folio *src_folio, swp_entry_t entry)
>+{
[...]
>+
>+	moved_pmd = pmdp_huge_get_and_clear(mm, src_addr, src_pmd);
>+	if (pgtable_supports_soft_dirty())
>+		moved_pmd = pmd_swp_mksoft_dirty(moved_pmd);

Shouldn't we clear the source UFFD marker here?

	moved_pmd = pmd_swp_clear_uffd(moved_pmd);

just like move_swap_pte(), no?

>+	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
>+	if (userfaultfd_rwp(dst_vma))
>+		moved_pmd = pmd_swp_mkuffd(moved_pmd);
>+	set_pmd_at(mm, dst_addr, dst_pmd, moved_pmd);

static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
			 unsigned long dst_addr, unsigned long src_addr,
			 pte_t *dst_pte, pte_t *src_pte,
			 pte_t orig_dst_pte, pte_t orig_src_pte,
			 pmd_t *dst_pmd, pmd_t dst_pmdval,
			 spinlock_t *dst_ptl, spinlock_t *src_ptl,
			 struct folio *src_folio,
			 struct swap_info_struct *si, swp_entry_t entry)
{
...
	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
...
	orig_src_pte = pte_swp_clear_uffd(orig_src_pte);
	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
	if (userfaultfd_rwp(dst_vma))
		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
...
}

Suppose the source is an exclusive swap PMD carrying a UFFD-WP marker, and
the destination is an empty hole registered for synchronous UFFD-WP without
RWP. We haven't write-protected the destination, but a successful whole-PMD
MOVE carries the source's UFFD-WP marker into it.

On swap-in, that marker is restored in the present PMD, leaving it
write-protected. The write fault then reaches
handle_userfault(vmf, VM_UFFD_WP), even though we never write-protected
the destination ...

That would be quite a surprise for userspace, and could leave the writer
stuck if the unexpected WP event goes unhandled :)

vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
{
	struct vm_area_struct *vma = vmf->vma;
...
	bool exclusive, stable_writes, rwp_restore = false;
	bool write = vmf->flags & FAULT_FLAG_WRITE;
...
	pmd = folio_mk_pmd(folio, vma->vm_page_prot);
...
	if (pmd_swp_uffd(vmf->orig_pmd))
		pmd = pmd_mkuffd(pmd);
	if (pmd_swp_uffd(vmf->orig_pmd) && userfaultfd_rwp(vma)) {
		pmd = pmd_modify(pmd, PAGE_NONE);
		rwp_restore = true;
	}
...
	if (exclusive) {
		if (!rwp_restore && (vma->vm_flags & VM_WRITE) &&
		    !userfaultfd_huge_pmd_wp(vma, pmd) &&
		    !pmd_needs_soft_dirty_wp(vma, pmd)) {
			pmd = pmd_mkwrite(pmd, vma);
			if (write)
				pmd = pmd_mkdirty(pmd);
		}
		rmap_flags |= RMAP_EXCLUSIVE;
	}
...
	vmf->orig_pmd = pmd;
...
	if (write && !pmd_write(pmd) && !rwp_restore) {
		vm_fault_t wp_ret = wp_huge_pmd(vmf);
...
	}
...
}

vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
{
	struct vm_area_struct *vma = vmf->vma;
	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
...
	if (vma_is_anonymous(vma)) {
		if (likely(!unshare) &&
		    userfaultfd_huge_pmd_wp(vma, vmf->orig_pmd)) {
			if (userfaultfd_wp_async(vmf->vma))
				goto split;
			return handle_userfault(vmf, VM_UFFD_WP);
		}
		return do_huge_pmd_wp_page(vmf);
	}
...
}

So, clearing the source UFFD-WP marker before the destination RWP check
would match the PTE helper and keep the RWP re-arm :)

Am I missing something?

>+	src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
>+	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
>+
>+	double_pt_unlock(dst_ptl, src_ptl);
>+	return 0;
>+}
>+#endif /* CONFIG_THP_SWAP */
>+

[...]

Cheers, Lance

