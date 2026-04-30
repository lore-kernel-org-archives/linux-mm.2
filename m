Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AE58CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43166B0092; Thu, 30 Apr 2026 12:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1A3D6B0093; Thu, 30 Apr 2026 12:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30E06B0095; Thu, 30 Apr 2026 12:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3B8F6B0092
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:43:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 737C21C1E12
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:31:24 +0000 (UTC)
X-FDA: 84715762488.29.4C90EA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5A04D40019
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:31:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KRmXDL9z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777566682; a=rsa-sha256;
	cv=none;
	b=BGaQcUN61Io1fSnYoXrR7u5ypnvXO5bXrwppHzritFPGojePIjYY+lrWUpJ4lBBGBVDKQ+
	KnpX/3NhmToTVmBr8bFjN8VrXM3rUefSeaSBV+t5CLKKdOYC7fS0BZPiw8xMK6faqFWO8h
	R31d1Rc275Unj1zsXAC38wecDP7ea4I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KRmXDL9z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777566682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2BMn/TR67Ibb4b98YidoYFIsOWU44F4wZ/90bwcO9Lk=;
	b=3e64RHqYt6w6pYXuWXmGG/XYAOjBi3sAgXJ3XiSofCmJu0P5x1LGA2K2dg6Jf/XUi3+SsE
	Sltbt9TjPHpo0HN77WYBYsfPnaSoBUTnuK/7/qe9sol6WyhIN8otwaxF1RQ/PI23oBSE4D
	FRy8FHDtkGykYfY4EEG7GQzC/QmDt04=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F2B160142;
	Thu, 30 Apr 2026 16:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84725C2BCB3;
	Thu, 30 Apr 2026 16:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777566681;
	bh=Iv3L3Fv5TuFbAQ5EIXbSziOPY2wPrIySdVhnScRHPuU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KRmXDL9ze57UFB5ftLNSelc0YBrUO2rMtLVtw/bYNdyzIvf68KSXsXLzfAprPSY1L
	 9feOy7Ol3Bz5ZEgmBGa/ik9HWUX+f4BvgSQgzG1g1SzO4zhzG2HvxpHZy3zUhPlzVU
	 uUYjHH/ddhG65Fnd7kBNIVTfD8fFGDw6RSp53P5kSp0Iaj9qdG97uaIsWlDMYhNYj0
	 9aaszEJXP1OeCd+igZsJv3Kz8YoNzcss0SH0+oEn1SN9SDssrhCtlzw8fyF/e+EAQJ
	 iy1cieG6sqqSTuyYEHxupkOH3YgEjfi16dHeZkpjXQ60BEt/x/VN29qUventbpL0mF
	 DGqJbIilE+wUQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id A8B88F40074;
	Thu, 30 Apr 2026 12:31:19 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 30 Apr 2026 12:31:19 -0400
X-ME-Sender: <xms:14PzacrrwtON1yjcKkHqjhYD5_ZyLi0uektR0gTruZ3RAu0alNWqDA>
    <xme:14PzaQRsw_D1Rtc3w2KwhsZbBFWRBu1Wjpy7tBCyedKRjY-P8qqR3RbF7wVontDIx
    yTx-1CW2hJt6PbojNxkZT7GtDMSYqi-Qr3PlRCA8HmXCxBxfmx0h5A>
X-ME-Received: <xmr:14PzaWxbZ3k8n--2DJVyDupDgdj8iRHDm2z5c1RJMekfSEDPbHqHCvMDstSIfQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekjeekudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepmfhirhihlhcuufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgv
    lhdrohhrgheqnecuggftrfgrthhtvghrnhepgeetuedtjefhkeeuiefgudduvdfgvdeiue
    eigeehheehudetuedtkeelhfeihedunecuffhomhgrihhnpehsrghshhhikhhordguvghv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepgeeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughh
    rghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthho
    peiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:14PzaXgIkjN7mK-fjcY706fwrz34-Ahwp02JR4jen55dAGcmCdVQDg>
    <xmx:14Pzaa-6tSttwWx5_yzu6zpee2_fEMQUz_YmR6HeBD9hIba83taKQg>
    <xmx:14PzacPSNH9QdmMtow4Im83_MG0PzApP08Qypc6jwjNiSkI7XGyOwg>
    <xmx:14PzaYp9tbkkl3MsmSVsT-k9R6f18Cpq29ks3ImM29YVih2hdMIrTQ>
    <xmx:14PzaUeCoc1c_e-3GNtWQckdtgj4i48depaB46OtGpW4HRn9e3DmbxP1>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Apr 2026 12:31:18 -0400 (EDT)
Date: Thu, 30 Apr 2026 17:31:17 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org
Cc: ljs@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, 
	sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 07/14] mm: handle VM_UFFD_RWP in khugepaged, rmap, and GUP
Message-ID: <afODmDGimJ4QUkkv@thinkstation>
References: <20260427114607.4068647-1-kas@kernel.org>
 <20260427114607.4068647-8-kas@kernel.org>
 <afOCAZ-dTQiLFN0y@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afOCAZ-dTQiLFN0y@thinkstation>
X-Stat-Signature: 8s59ixb9dq8ftjj54cfaro9hdcfikz6p
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A04D40019
X-Rspamd-Server: rspam07
X-HE-Tag: 1777566682-680943
X-HE-Meta: U2FsdGVkX19XnGsgmnYbT+83BZjl9P2FMvdmKn+oYXPfamH2wL7D7U8bvguXfJz51oVUuDvP1TEiAu1UhwR8gu0/yhzklWsDIB6oQfI1FH8axMJM+j48fgfS+1aNon0xL0A4PiBMWHhtsL0F1pseV5/iUgWtQUPldM2TgxLHQHoEfonFqXNdsbZ4jzDD8vVPWeOmlU+eUBdsNuKNGschcNXBJ3Z9ypeUV+Mcyvu/cs53r3u3BL40bsULGhhkI+9Djrn16oz+axjsQmXTgM1XPRve0ktlD733Cp131m1CySSyye2Uvv2dhciBeqmxe+UqNJTwSF8ZPdBDf8tMdLe3Z8v1m6SxVkabZWnmJUrBMsExK2ry2QbsUtzRNtDmazVdWiI2axCPZQTJb3+x36dQSfcQx+RpFqQmssuGzPudPSFRwt0Ck1cfNVBaZsFi6h86v2lb/VSrjDxeKSrtTZW0e8+avQYRbyDfswxauA9JDcM8FohgxeK4StSHj3Ed7GpOfL2a7mGFf9bylnDH5ivZoqb9JxyjLfqGiV+A7/KM16jTgDlArdX/sEq54Pjo+w3y4YIO1p8sUZ6y8MIC4juyTzcFbQsvgr794JRXFwGXqQ1OPGf9/+UNd3qQnXpWDx8iPaBjme6mtYbvu1ix6hzqmFmjuP+RZmWuCFqof8JD5ubp6h01r4Ud1vz788XUTepy1XClhvm1UEsyGN0rQWkxj8oxK96Cy2MQh9DwTsoQIgP6m/ha9QFvIozQ9TQ5sHqMMCiuWLruJ3TpStLeAJ6OtIc0TdhVWL1U/4iXX3TiiASZCdlYFI//U+5q4Vvf/LZsyYbbhsufflCL3y16rBkB3y0KnJjIt9u164OmkQ4nfFxx7Vvz9raRVHmrg++/4yTIcq2eIcQI7iw76gggAiqUsMNE2w1uo1YF3RhoayCtvlAT5rdPXSCCd2bVIh7aDWoAcmVR9jO8Iqk+ASGyaak
 lfLQslZZ
 P3wgUua7D+bY5zLrbE+QQtSMQvx63uK7jzGvMmvRTfZ2Kd2Ts+6PQYPAowajKlomXTpRxpK8+4PIxHaMUKhHVBv/DNOw6C9Bcp7lPB9GwOFzCWOfCf1gqUvUcQpZnW/BDh6YYgcIN7f3IJmQGwQQf+PNReKLPx71V6Wit+LfcuvU8kA2rSjWGDoP37ffS5sl54AZdg/O7+V6HxsQ4AAQYvJddys8ykc5fFXtObjiaPekjXxN0CXMVSmUCA7rRQrx8DrPnhqIKo2gudnMIIz3RSioEm2mNoZCDpQE5x77u0Hce6Vc9x7ORhxQ5KGkkfgxji3PHkgxh3S59KJ8uYUCBp40rjD/oDEm97z+8bH05joSm+4XHQ+AnJifS0ew0vewyuf0tI5DIb84+MttwrP4h8GefLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 05:28:17PM +0100, Kiryl Shutsemau wrote:
> sashiko.dev -- https://sashiko.dev/#/patchset/20260427114607.4068647-1-kas@kernel.org -- wrote:
> > > @@ -1084,9 +1092,29 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
> > >  		pte_t pte, unsigned long addr, int nr)
> > >  {
> > >  	struct mm_struct *src_mm = src_vma->vm_mm;
> > > +	bool writable;
> > > +
> > > +	/*
> > > +	 * Snapshot writability before the RWP-disarm rewrite below: when the
> > > +	 * child is not RWP-armed, pte_modify(pte, dst_vma->vm_page_prot) can
> > > +	 * silently drop _PAGE_RW from a resolved (no-marker) writable PTE,
> > > +	 * so a later pte_write(pte) check would skip the COW wrprotect and
> > > +	 * leave the parent writable over a folio shared with the child.
> > > +	 */
> > > +	writable = pte_write(pte);
> > > +
> > > +	/*
> > > +	 * Child is not RWP-armed: restore accessible protection so the
> > > +	 * inherited PAGE_NONE does not cost a fault on first read.
> > > +	 */
> > > +	if (!userfaultfd_protected(dst_vma)) {
> > > +		if (userfaultfd_rwp(src_vma))
> > > +			pte = pte_modify(pte, dst_vma->vm_page_prot);
> > > +		pte = pte_clear_uffd(pte);
> > > +	}
> > Does this unconditional pte_modify() create invalid clean and writable PTEs
> > for shared mappings?
> >
> > Without checking pte_uffd(pte) first, this blindly modifies every present PTE
> > if the source VMA had RWP enabled. For shared writable mappings, vm_page_prot
> > includes _PAGE_RW. If a PTE was clean and mapped read-only to intercept the
> > first write for filesystem dirty-tracking, pte_modify() forces the write bit
> > on while preserving the clean state.
> 
> Two reasons this is safe in practice:
> 
> 1. RWP cannot reach a backing that uses the clean-RO + page_mkwrite()
>    dirty-tracking pattern. vma_can_userfault() admits RWP only on anon,
>    shmem and hugetlbfs (the ones with vm_uffd_ops); regular file-backed
>    shared mappings are rejected at register time.
> 
> 2. For backings that *do* support shared writable + dirty tracking (i.e.
>    the ones RWP isn't enabled on), the fs sets vma->vm_page_prot to RO
>    precisely so the first write traps page_mkwrite(). pte_modify(pte,
>    dst_vma->vm_page_prot) would not add _PAGE_RW in that configuration
>    either.
> 
> > Hardware writes could then bypass page_mkwrite(), leaving the filesystem
> > unaware that the page is dirty, and potentially causing silent data loss
> > upon reclaim.
> > Could this also overwrite other important PTE states like NUMA hinting
> > or soft-dirty tracking?
> 
> pte_modify() on the supported architectures preserves _PAGE_CHG_MASK,
> which covers _PAGE_DIRTY, _PAGE_ACCESSED, _PAGE_SOFT_DIRTY, and the PFN.
> NUMA hinting is encoded in the protection bits, so a transient hint
> state on a resolved (no-marker) PTE would be lost across this rewrite,
> but that's just a re-prime on the next NUMA scan, not a correctness
> issue.
> 
> > @@ -298,6 +298,16 @@ static __always_inline void change_present_ptes(struct mmu_gather *tlb,
> >      else if (uffd_wp_resolve || uffd_rwp_resolve)
> >          ptent = pte_clear_uffd(ptent);
> >
> > +    /*
> > +     * The uffd bit on a VM_UFFD_RWP VMA carries PROT_NONE
> > +     * semantics. If mprotect() or NUMA hinting changed the
> > +     * base protection, restore PAGE_NONE so the PTE still
> > +     * traps on any access. pte_modify() preserves
> > +     * _PAGE_UFFD.
> > +     */
> > +    if (userfaultfd_rwp(vma) && pte_uffd(ptent))
> > +        ptent = pte_modify(ptent, PAGE_NONE);
> >
> > For VMAs registered with both UFFD WP and RWP, could this silently upgrade
> > Write-Protected pages to Read-Write-Protected?
> 
> VM_UFFD_WP and VM_UFFD_RWP are mutually exclusive per VMA. The combination
> is rejected at registration time:
> 
>   fs/userfaultfd.c, userfaultfd_register():
>         if ((vm_flags & VM_UFFD_WP) && (vm_flags & VM_UFFD_RWP))
>                 goto out;       /* -EINVAL */
> 
> and re-registration cannot drop either bit (also -EBUSY in the same
> function), so a PTE in a WP-armed VMA can never satisfy
> userfaultfd_rwp(vma); the new branch never fires there.
> 
> [ ... ]
> > +        /* Re-arm RWP on the moved PTE if dst_vma is RWP-registered. */
> > +        if (userfaultfd_rwp(dst_vma)) {
> > +            orig_dst_pte = pte_modify(orig_dst_pte, PAGE_NONE);
> > +            orig_dst_pte = pte_mkuffd(orig_dst_pte);
> > +        }
> > +
> >          set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
> >
> > Could applying PAGE_NONE unconditionally to newly moved pages trap
> > applications in an infinite fault loop?
> 
> No -- the post-MOVE access is delivered as a normal RWP fault. In sync
> mode it goes to the registered handler, which resolves it with
> UFFDIO_RWPROTECT clearing MODE_RWP; in async mode the kernel resolves
> it in-kernel and the faulting thread continues. There is no loop.
> 
> The semantics here are intentional: a VM_UFFD_RWP VMA has the contract
> that every present PTE is either an active marker or a tracked-and-
> resolved PTE whose next access will re-trap. UFFDIO_MOVE into such a
> VMA must keep that contract, otherwise the moved-in page would be a
> silent hole in the working-set view. UFFDIO_MOVE has no mode flag for
> "skip protection", by design -- the same way it has no flag to skip
> WP arming if dst_vma were WP-armed (and the equivalent could be added
> there if we ever decide UFFDIO_MOVE should preserve markers in WP
> VMAs too).
> 

Oopsie. 

I put it in reply to the wrong patch. It suppose to be for 06/14.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

