Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2364606A890
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=sDx0tnxA
Received: by kanga.kvack.org (Postfix)
	id D6F516B05B2; Thu, 12 Nov 2026 09:50:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D477D6B05B5; Thu, 12 Nov 2026 09:50:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C84296B05C6; Thu, 12 Nov 2026 09:50:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A53136B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:50:28 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B694BC029D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:50:26 +0000 (UTC)
X-FDA: 85426752852.13.CFE9E57
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id E5EDD20004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:50:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sDx0tnxA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794495025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCXPmaCthBgEXTrlaPcclc3/LLYGCPmdnrH+YjDkVHU=;
	b=L0cN7+z17aaaFfxrTdt9jT70Oa3alX+Dcaj0KcOOaBNSujUpmHYQU2SpJUh3vGc/Za1z2Y
	UoWA+cdRjKE/G4k+r6LUr48bsslbFva9xSLYKvE2v711xpcOZMMYSkUBxxlZKrcp7Rg58O
	ROHYqHV7EDNVB1udkFt9hlXisamrs20=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sDx0tnxA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794495025;
	b=PE39ysBbOwHr8/WgQMa1/q0kqERWE5ASP0qN1v+nVwjDbaQ5K/9RZQyoF/Sp4FsQn9YFzx
	pgjGqyYovnrB5sgl31dgMD7ly3dn+GzyLApN9vdSmCXVxep37lWKABPkcumgXb/hHP4zRn
	edlVCrwkAS8Y/rtNyuN/x8zL6F3LEFw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 08CEC1516;
	Thu, 12 Nov 2026 06:50:21 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C3F63F673;
	Thu, 12 Nov 2026 06:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794495024; bh=+s0Rk/mSeWGvdAKtOlpf42pJMk09UK6Tn3e1uY2y7+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sDx0tnxAz6cFHnGuBZjLsrCMBsBbAbfeZPQMGJsLYhbLqDwLs2EUYLW7M8HzrRwBT
	 CwHQoI3Nv0y7lpgl6aHYYeXHXJ52UPC/+Ls4yZu5IXB9sUTzbupU5lRlyJ0/hQBTim
	 ShBwsGzEUr0BpshFL8STX2XSVIO/B4RQ0M8JyTSg=
Date: Thu, 12 Nov 2026 14:50:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Chris Down <chris@chrisdown.name>, Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH] arm64: hugetlb: Prevent write fault livelocks on stale
 TLB entries
Message-ID: <avXSK0zKGttR0dEJ@arm.com>
References: <avPxZjjdBIlM_8_g@chrisdown.name>
 <87ld6yn3vx.fsf@DESKTOP-5N7EMDA>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ld6yn3vx.fsf@DESKTOP-5N7EMDA>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E5EDD20004
X-Stat-Signature: 3exq1dn4kc3pfgos7ehz47cunbq61bhf
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794495024-846024
X-HE-Meta: U2FsdGVkX1+6ZqUbgcWHyXujhywyHahoX3nb8AZOrpbPgiqBz2m0apG/CDsCiEwehi+3owsD0bK7Hf7C+DJdZfLsy3ZpQWG3ICKqSl2LqzWbdAJGuetIZn8KpnVoJtrmsTO0W7PidUmblWcQSoPaxDTUjdxZIXlghBpDfC57V/+n2Y2zeqCm8JUxK8dO0UxtKiOr8/iy8fmhiUZSKd2hJHoLG0iDSXBvHbwU4Ge/R4Ysg7j+b/HZNLEg4rwUIR78Sky+botXnzbFRLV2KRv7Aeovbjng/l1Xd1Ebkh4zSOuYBEVUy+bfr07JWfVUU7w1FeGqG8PfiqCpnAO6YkaRNXeTrkavGEBmQ3lVMVt7RtlcBUnUv8J2+U0pN7zAA6OLi7+h+5QtRy1/LF7IetYCbP1jh7q3LdYuDAnzlytlpbRzgV8xf2T92uynjsCVJat54hWyyq5USoOGnjA5es7wexwYjPRvnILuhKhgI0hkxiSKjaX4Qt/1zgAHlPvlR2mBLLnka5JeCarf79NmQXpUOfkSdguPRz6mKouniNsxycfQh7HBSoSTH6kUlNUTybOBWDetFxSUgXcyduX2faVQcqG72bO6a+JYsW96CuP7Aa2QBXKy/C5R8CB/KHTfb9kHqSLOrQGRsF2cVQ+INlD/+B3W4EFdvOgmQw5EfeEx0gMq/J3OAs3UCDJ29Vlt/2OBMTednPOdiVBx4pQPRoG7DjwutX4gzErJQXzw2HIgUNxT9Dsk2+L2sMiCxfwYkPhvrA6fOMuqDmzsapIjnEstkd0R0sn7Gfy5wtie384qDMUAGVHgEcwPgy2M241rWhWfrpfLVB8s4w1tzb+CKQy1BMVVjPT5DLaHgzJIN+GJIh/tbnLcBLTo8iYo4L7uq3L+egmMJVDuexMFeNOuqpI7f40frhf94KR3tDGw32nxz7mCQdWNuParDlAaN44CSs/NzT7QPjmhAXwnJUPrZtZ
 ctjnuOSx
 LZ1DdWA0vqxyTG0/96xZMVseh4nkA5EsJxAGuCEWdisuu+nxBi/iuJILh5G666mKvvQoAQSkcr1u5eAStUDrkcMyTnjUOM5g4bViLM6J2YVrnf8d6TCApe1zdYSYlorKGZ/GxRE+ISjrwzpiLuHRDfUL3PM46iVGd+i3v4Z4WRSQbEdAETILChNxcFS339aCvaU9V+MtKuN+T84jC5iZ9632xLGWyVyG/liVeqOzehRjeNszvjIPEWFGEhlnAmwVS7VuW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 11:08:02AM +0800, Huang, Ying wrote:
> Chris Down <chris@chrisdown.name> writes:
> 
> > In Meta production, we have had tasks get stuck in a fault loop while
> > using hugetlb on arm64. During my investigations I found that affected
> > tasks share a private hugetlb page.
> >
> > Looking at the stuck task states, I found the following ordering:
> >
> >   CPU0                                 CPU1
> >   ----                                 ----
> >   read page
> >   [read only entry cached in TLB]
> >                                        write page
> >                                        hugetlb_fault()
> >                                          hugetlb_wp()
> >                                          [reuse folio]
> >                                          set_huge_ptep_maybe_writable()
> >                                            set_huge_ptep_writable()
> >                                          [flush local TLB only]
> >
> >   write page using stale entry
> >   hugetlb_fault()
> >     huge_ptep_set_access_flags()
> >     [entry already writable, no flush]
> >   retry write using stale entry
> >   [fault indefinitely. well, that's not ideal!]
> >
> > The reason is that when a write fault makes a non-contiguous hugetlb
> > entry writable, it only invalidates the local TLB. However, another CPU
> > can keep the old read-only entry, so its write will fault even though
> > the page table already permits it. hugetlb_fault() then finds nothing to
> > change and leaves the stale entry in place, so the same write keeps
> > going round in circles.
> 
> Good catch!  Thanks!
> 
> > This is particularly bad because, if the kernel is copying to user
> > memory, the retry stays inside the kernel and the task can't act on the
> > pending signal.
> >
> > It can even remain unkillable while holding locks across the copy,
> > resulting in further failures. For example, a read into a hugetlb
> > buffer can hold the pipe mutex and block other users of the pipe until
> > the loop ends, causing cascading lockups across the machine.
> >
> > To fix this, when a write fault finds nothing to change in a
> > non-contiguous hugetlb entry, let's invalidate the local entry.
> >
> > Fixes: cb1fa2e99955 ("arm64, tlbflush: don't TLBI broadcast if page reused in write fault")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Chris Down <chris@chrisdown.name>
> > ---
> >  arch/arm64/mm/hugetlbpage.c | 21 ++++++++++++++++++---
> >  1 file changed, 18 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> > index 8e799c1fe0aa..ff1f53e435e1 100644
> > --- a/arch/arm64/mm/hugetlbpage.c
> > +++ b/arch/arm64/mm/hugetlbpage.c
> > @@ -429,9 +429,24 @@ int huge_ptep_set_access_flags(struct vm_area_struct *vma,
> >  	VM_WARN_ON(!pte_present(pte));
> >  	ncontig = num_contig_ptes(huge_page_size(hstate_vma(vma)), &pgsize);
> >  
> > -	if (!pte_cont(pte))
> > -		return __ptep_set_access_flags_anysz(vma, addr, ptep, pte,
> > -						     dirty, pgsize);
> > +	if (!pte_cont(pte)) {
> > +		if (__ptep_set_access_flags_anysz(vma, addr, ptep, pte,
> > +						  dirty, pgsize))
> > +			return 1;
> > +
> > +		/*
> > +		 * Another CPU may have made the entry writable without
> > +		 * invalidating our stale read-only TLB entry. To avoid
> > +		 * indefinitely faulting on this entry, flush it.
> > +		 */
> > +		if (dirty)
> > +			__flush_hugetlb_tlb_range(vma, addr, addr + pgsize,
> > +						  pgsize,
> > +						  TLBF_NOWALKCACHE |
> > +						  TLBF_NOBROADCAST |
> > +						  TLBF_NONOTIFY);
> 
> IIUC, this is similar to fix_spurious_fault() for non-hugetlb folios.
> Can we use similar logic?

I think we should but that's something going forward, not as a
backportable fix. I'll take this patch for now and we can look into
wiring up something similar to fix_spurious_fault() for hugetlb.

Currently fix_spurious_fault() only handles pte/pmd faults, so we can't
simply do this:

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index da5d04edf7c1..e0e582f264e8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6297,6 +6297,8 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (huge_ptep_set_access_flags(vma, vmf.address, vmf.pte, vmf.orig_pte,
 						flags & FAULT_FLAG_WRITE))
 		update_mmu_cache(vma, vmf.address, vmf.pte);
+	else
+		fix_spurious_fault(vmf, PGTABLE_LEVEL_PTE);
 out_ptl:
 	spin_unlock(vmf.ptl);
 out_mutex:

because the pgtable level is not known to the core code. We'd need some
arch specific hooks and handle it in hugetlb.

With Chris's fix we just miss one more retry before invalidation. But
yes, having similar mechanism in the core code makes sense to me.

-- 
Catalin

