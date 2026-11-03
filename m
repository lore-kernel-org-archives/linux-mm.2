Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F0A606A7AA
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oDOWjPdA
Received: by kanga.kvack.org (Postfix)
	id A92E96B05B5; Tue,  3 Nov 2026 10:24:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A44656B05B9; Tue,  3 Nov 2026 10:24:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981776B05BA; Tue,  3 Nov 2026 10:24:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6CAAB6B05B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:24:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 057F9120460
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:24:53 +0000 (UTC)
X-FDA: 85394180466.03.2841690
Received: from mta0.migadu.com (out-90.mta0.migadu.com [91.218.175.90])
	by imf25.hostedemail.com (Postfix) with ESMTP id 048BDA0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:24:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oDOWjPdA;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793719491;
	b=BZA8jFKr0GqGntPHNyB4ot/qOYa6QsBSy5VOX3glFfNOCCcfKUXPrk8qcTSkumuiLkuw6h
	zVRKeh6rELfU1HrpGjADU9oSV8VcV0JGUmlauec5QE5UmvN38ftkWRd2pgRXgqo+gypWxS
	HO4zBranIK1/DI1qefXA8mcdaS2rT/M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oDOWjPdA;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793719491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NhYtZrkm1A2y5gfXb/MOXR9T1Dxa9gZMQbF7Vezns8s=;
	b=PJChKBnkSgV7gp3EttkFt9P9l8vCNl7Xacd44xUZmFtQXHfMW32bL6xiZiw/yjY4wnJj1s
	ZXsE5uuyxWh6MoKDLBUSaEbXKfkL6tIzyD+ShD79JiSHkiIv5jM+WOM4NO18Jtbl0sortc
	DbuaV/6FTZbZ5C8UgYD5gdjIMMSxAvU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uT7L6pAMqKZY5SqEVouIfWTPNvq3GQ1tPvyDPXZOklY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793719488; v=1; x=1794324288;
 b=oDOWjPdA3l9VJDLf1agEGIp1f47Azi2PCJY+Kcu8KjclzDF7O4HZPonjDgDkjy69U+YYO8xb
 ckZ+Z77ttMB4DWxLJjGv4qo6zoXCLZh/gTRZR/CnfOl3Xq+AfjQKLJE4SgrMZ45kpa6HHEkluHk
 BieINBeECAWGsUYs0kBtROQo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 4abd1e9e5f610d68;
	Tue, 03 Nov 2026 15:24:48 +0000
X-Mizu-Trace-ID: 4abd1e9e5f610d68
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
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
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com
Subject: Re: [PATCH v8 26/30] mm: handle PMD swap entries in UFFDIO_MOVE
Date: Tue,  3 Nov 2026 07:24:43 -0800
Message-ID: <20261103152444.2041674-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261004081917.20111-1-lance.yang@linux.dev>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ss3eu1rypqaj15apsw73sp1677bxbjr8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 048BDA0005
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793719490-755624
X-HE-Meta: U2FsdGVkX1/DCLfxtqWJWN6hSu9W9qXYrVtAQWWqubGsOiFWeC/rWYBdkyFhu0haVaqdGwdVnC/O7+SqG7HUuIcsbTzOHlk5adg0zFRgu0RmVXMrtDpWfHMkZ5DwTe80nDSksFl/rKT4ArWa/tIiUSfBrBCkq4Rxd7oqo303R0P2sLb+GL3zWcfalOOV0klf8cvbieuuXoQYZGit1oPivx0tqfunBotzb19pMqN3jYv5duy7flbaWUJmVN9faJv9Rxkq8Z52LT5KvT7MsZcMZTX2Iri3wswSEyNIe8WMmWK/KareC9/Hw0VgtRd5EcmSI13S3vun12L3j8OV869hXr4MERP1G2eZ3afSk7EDLewoEXJwRpWBrhFOJaAZHM1s3q1avRTlVf1pLt32qveXQuEb3N+kVBE+Jj07Gwv3LucXRGwcvfvObARCizyseEXRfrLNmzAedhMbjQsJtUOynLRr83rvSjquy+dERUptvtbmlihM25w8mKGkgu9PdgT6qJouCFWxK7pAXrUv4wYowb2byLEugWf1rHHqFyZUpAFm7hfHKZXIsbQ5TWc6s6Ix/GLy9YxaTUEDbeh+J9KL9WvTH5ypBAvFZ8pjTnIaR3B18VaPAL1WwyWC0Fj9pQx4xVJL1FLTIu376U48wiy+T0KQUVowZ8yGeQarCQ+Y4rpMdbRHlJw7nOl2kXVHhLQamZt7HspItoqUaTqJ6mQeH7bpJ8qhk0uZcDnxZQTT4+0tIU/MJYdXwAH5GomTUciWZg9HSrCnFn+zImJJwoxqpT65DikYrojYjqGo5wuEz437PSErDd0ClomaPcX6Kw92WdyERUcBdRO/7RNH2U4fKDh+8QrM/Sou8ju7FVsa9AauECb+ozRQIfPWSu15TwM6ndfWmRdDcTMJxbEOZNH7ylaLh1iPnIb57vC+CVmPM0WxWZ1/pZz58JzMBQEcmyRdsegVznZNA7t8PCdysfR
 8Ax/H/td
 SY7QR/XoUcrHKBozWuP4a+laDLUymFnnc+5aT4BWp/RnhnKB2OIz1OyGf+e8fCVPLQDgCaLg36B1FN/EPC1qFeMfKu3okczecVmC9ylm6gCoVZarD/dn6TXRSQ/TXXpB0eGHw8fqrWSaGUopYNMT77qqSkGqWscSDn0aKppCmadPSNrPl8PPpDhaBFjoHOPjCf2FDomOenWY056BGiDaubq67NcwfB9ZxsxkUJVA0WPy25AP9ZLSLYLtav0UhVYmstGsfjrzbSVq+ugRQwF96R4C64g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun,  4 Oct 2026 16:19:17 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> Hey Usama,
> 
> On Fri, Oct 02, 2026 at 02:52:40AM -0700, Usama Arif wrote:
> [...]
> >+static int move_swap_pmd(struct mm_struct *mm, struct vm_area_struct *dst_vma,
> >+			 unsigned long dst_addr, unsigned long src_addr,
> >+			 pmd_t *dst_pmd, pmd_t *src_pmd,
> >+			 pmd_t orig_dst_pmd, pmd_t orig_src_pmd,
> >+			 spinlock_t *dst_ptl, spinlock_t *src_ptl,
> >+			 struct folio *src_folio, swp_entry_t entry)
> >+{
> [...]
> >+
> >+	moved_pmd = pmdp_huge_get_and_clear(mm, src_addr, src_pmd);
> >+	if (pgtable_supports_soft_dirty())
> >+		moved_pmd = pmd_swp_mksoft_dirty(moved_pmd);
> 
> Shouldn't we clear the source UFFD marker here?
> 
> 	moved_pmd = pmd_swp_clear_uffd(moved_pmd);
> 
> just like move_swap_pte(), no?

Yes, good catch, Thanks! I have added clear for next revision.

> 
> >+	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
> >+	if (userfaultfd_rwp(dst_vma))
> >+		moved_pmd = pmd_swp_mkuffd(moved_pmd);
> >+	set_pmd_at(mm, dst_addr, dst_pmd, moved_pmd);
> 
> static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
> 			 unsigned long dst_addr, unsigned long src_addr,
> 			 pte_t *dst_pte, pte_t *src_pte,
> 			 pte_t orig_dst_pte, pte_t orig_src_pte,
> 			 pmd_t *dst_pmd, pmd_t dst_pmdval,
> 			 spinlock_t *dst_ptl, spinlock_t *src_ptl,
> 			 struct folio *src_folio,
> 			 struct swap_info_struct *si, swp_entry_t entry)
> {
> ...
> 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
> ...
> 	orig_src_pte = pte_swp_clear_uffd(orig_src_pte);
> 	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
> 	if (userfaultfd_rwp(dst_vma))
> 		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
> 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
> ...
> }
> 
> Suppose the source is an exclusive swap PMD carrying a UFFD-WP marker, and
> the destination is an empty hole registered for synchronous UFFD-WP without
> RWP. We haven't write-protected the destination, but a successful whole-PMD
> MOVE carries the source's UFFD-WP marker into it.
> 
> On swap-in, that marker is restored in the present PMD, leaving it
> write-protected. The write fault then reaches
> handle_userfault(vmf, VM_UFFD_WP), even though we never write-protected
> the destination ...
> 
> That would be quite a surprise for userspace, and could leave the writer
> stuck if the unexpected WP event goes unhandled :)
> 
> vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
> {
> 	struct vm_area_struct *vma = vmf->vma;
> ...
> 	bool exclusive, stable_writes, rwp_restore = false;
> 	bool write = vmf->flags & FAULT_FLAG_WRITE;
> ...
> 	pmd = folio_mk_pmd(folio, vma->vm_page_prot);
> ...
> 	if (pmd_swp_uffd(vmf->orig_pmd))
> 		pmd = pmd_mkuffd(pmd);
> 	if (pmd_swp_uffd(vmf->orig_pmd) && userfaultfd_rwp(vma)) {
> 		pmd = pmd_modify(pmd, PAGE_NONE);
> 		rwp_restore = true;
> 	}
> ...
> 	if (exclusive) {
> 		if (!rwp_restore && (vma->vm_flags & VM_WRITE) &&
> 		    !userfaultfd_huge_pmd_wp(vma, pmd) &&
> 		    !pmd_needs_soft_dirty_wp(vma, pmd)) {
> 			pmd = pmd_mkwrite(pmd, vma);
> 			if (write)
> 				pmd = pmd_mkdirty(pmd);
> 		}
> 		rmap_flags |= RMAP_EXCLUSIVE;
> 	}
> ...
> 	vmf->orig_pmd = pmd;
> ...
> 	if (write && !pmd_write(pmd) && !rwp_restore) {
> 		vm_fault_t wp_ret = wp_huge_pmd(vmf);
> ...
> 	}
> ...
> }
> 
> vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
> {
> 	struct vm_area_struct *vma = vmf->vma;
> 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
> ...
> 	if (vma_is_anonymous(vma)) {
> 		if (likely(!unshare) &&
> 		    userfaultfd_huge_pmd_wp(vma, vmf->orig_pmd)) {
> 			if (userfaultfd_wp_async(vmf->vma))
> 				goto split;
> 			return handle_userfault(vmf, VM_UFFD_WP);
> 		}
> 		return do_huge_pmd_wp_page(vmf);
> 	}
> ...
> }
> 
> So, clearing the source UFFD-WP marker before the destination RWP check
> would match the PTE helper and keep the RWP re-arm :)
> 
> Am I missing something?
> 
> >+	src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
> >+	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
> >+
> >+	double_pt_unlock(dst_ptl, src_ptl);
> >+	return 0;
> >+}
> >+#endif /* CONFIG_THP_SWAP */
> >+
> 
> [...]
> 
> Cheers, Lance
> 

