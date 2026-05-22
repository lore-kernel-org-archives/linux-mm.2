Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DA26CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 11:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 741316B0093; Fri, 22 May 2026 07:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F20C6B0095; Fri, 22 May 2026 07:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E0E06B0096; Fri, 22 May 2026 07:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE3B6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:44:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A713814081A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:44:36 +0000 (UTC)
X-FDA: 84794873352.24.77F008F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 94B0B120003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:44:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qt841VlS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779450274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7R5NDp5rIQEKgmx6ff9T0EAO9NIuV9zvssCRGuN2Nxg=;
	b=W9f5E9avitEUzLUs6H0IJ4NgyfCpyN4jFJyqesDAyu9b2czo6zIqkvYwBndLTiD5MQqcJN
	WAcUnzvFoqPxHnBiTVpPsmmDSzhP/6MZ863t2NWFcMQ3J5/BpkVuhkb6rPKQ2tw5Ci0Qe9
	vX/pobT3zgnKR6LVk/zhrK9M/Cg9g+w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779450274; a=rsa-sha256;
	cv=none;
	b=WYHIMTAj+nZioyWCT0aIVGL32fXiQm2l1OgwrqzPJs4q0QGvmi7lPVOLtY7efwOYcyOKGt
	hORSb8AaHi8XVSnF8IqyxHLzIAuNjjyc3/GTw1N1zuUui4ckYMOV+otKXqKTIk0zK/zpnY
	GQ05AE7h2DEBYL7mF4BGuELh/SCmaBE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qt841VlS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 862E94327C;
	Fri, 22 May 2026 11:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629B11F00A3D;
	Fri, 22 May 2026 11:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779450273;
	bh=7R5NDp5rIQEKgmx6ff9T0EAO9NIuV9zvssCRGuN2Nxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qt841VlSj3QS3Bxsc4RBFCcw1ZwOuFFG/ekVzzSD2g06cK7CnOAsRnliahxM3J0Fj
	 2gOPmEAmhXXTRWp6Fr1vIl1h3ne1i78pqR/tKSykwptOt9q86CnD+dUhzWR7WT/uVr
	 LoZgJ1gkqVQhiSl1oZ/Whr3T3yXe+jni+tbBuCPAUTRFvht5T39oCd1ejnq1b/ltpP
	 UA2SddoVQc/JL62WZTWLWfKIPPXSKjzIJW8p/m538JGt3022rApPm3IPElJyr5kEMz
	 Pft75V3aTWFsYeoNE+aHTW5nX0aEQASkT0Xp0WFmNOASbvkCsmhgGdZ19hnhfgEChE
	 c8/68j9Z5uNfg==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 94B66F40069;
	Fri, 22 May 2026 07:44:31 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 22 May 2026 07:44:31 -0400
X-ME-Sender: <xms:n0EQajzaWUAL9foVl3iSXLRppyszmKHlcbKTz09aNBDzWda9abzdIQ>
    <xme:n0EQao5eWXQxAc48kc28joC7NhC70-iZIgZZMD5N4dFWaBAHcfHEnmrcj_6Av666R
    fI_7XdS2f_fMSJERkvvdEGk3OLU2fRi7Zq80Q10QApSbteW73137A>
X-ME-Received: <xmr:n0EQai6cX3uF_gHjNw4yHL8-AiiXt58FoNSXQFsrEwMygLFEdtb141KYHBxPBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedttdekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefmihhrhihlucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhn
    vghlrdhorhhgqeenucggtffrrghtthgvrhhnpeeuieejieffkeehfeffffdtkeelfeelhe
    fhfefhudehjeehvdffleeuvddufefgkeenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsoh
    hnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhn
    vghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeegiedpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtg
    hpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepvhgsrggs
    khgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesoh
    hrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:n0EQahLnSwNCQtzwgiyBDyXM6QXTIzHcpKJRL_cw5-UfKWI_ZtGPiA>
    <xmx:n0EQakHez12dNbwMmUO0uVj63cxI2c1kiERawUYVAtNB9Hoqj8ZlOQ>
    <xmx:n0EQau0j47Y2kYXSFKvkmNASmGHslIn1RQnBuGHsbGerJDymGXmi8w>
    <xmx:n0EQamzIkUog0A3bQiC44FAMQf1ZKLmSZ2mXYsJouisWgBpHyQv9hA>
    <xmx:n0EQaoFwDGvWKyiuxNInuwchtGw0QVDFOFHNPlTYuyd4gM6cWXlxSGh_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 07:44:29 -0400 (EDT)
Date: Fri, 22 May 2026 12:44:25 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org, 
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 05/14] mm: add MM_CP_UFFD_RWP change_protection() flag
Message-ID: <ahA2Oy0NVaB8I8GR@thinkstation>
References: <cover.1778254670.git.kas@kernel.org>
 <ff3420fdd75f58d56827ff3d2eaffc0d74154627.1778254670.git.kas@kernel.org>
 <agNZE49m8Pkn8CeW@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agNZE49m8Pkn8CeW@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 94B0B120003
X-Stat-Signature: nf4si4886zi4sh1pwfke8hmhjmdd1tf8
X-Rspam-User: 
X-HE-Tag: 1779450274-629228
X-HE-Meta: U2FsdGVkX1+sATYf+xcwpz4zQKZLZzYQlbxW6FVrRBn/vDff7xpe9Ugm9GreR/Q2Tk8mGxH/nqLJVzAfO9g46o55tdgaY24/9x0RFZXKefAgLEcX5DSZ1/TTxZvg/2HFUzjwOqyyVcqwic6Zj2dptrfgIuH7bgCGNfyzfBg6nh4ODsETcsqTnNiV/brEiJ6Szkf8tsc0WXy50RMZlu11WAhMsGduxkjZ0n+o5ijQ08o6yfxdLIbzOb+HTCKi4syDJE57Sb/zNDD2+fQPj1j+jcv/LMgVA/AejWvMjEPdYrvQEvnaqgj2UAWT5PCqqohhfsAjeZ7126zjVZtBAsed27Dn8D6JOGk0cEomhdagARtRXdQqqbLHGYwe8kM5yMklJxUZa5uV0FFDS5O9rdfAnzBrsMRRfy5i8nhyT5fn/slf2z/3YNeKsShZFGnbdGSVZPHxbnNzqszty3R9zSA5Ko4zbKpPXhgUIwYz1JLTKiIgEKiI443f1WEFz225VrfL7RP8EYl/9fSAC4gHD9zUzR9Syp/bbuecfWQAmceX6xqIWuUGXpQgFh4KY1Cn8bHAJlDwjB2MoPFzu5ibIEUYOs9TnlKVAxjckJGq9LYzl8ob3wwlza90o2OH67mZQ3iEu8Rrfow2LpM9Xt4noljnzHRBL79yoqMBA5Be3J26IYsZVLxlH6ScWzrxSyz/lWxvVjDepnFSSq9E+h3B1poHUT2bIFCIjz1o207dv/S6piBIoLREQ0SsEn0CCyoQYSUlnkN6Ge7Uy/RUzRnrgmS14CoC8dSlg9+oUWvhB1Zx+8jH4MU/heLgE0QMhow8fEfX0FHPhjYh8u/saXd3j20etguQLDPQxTFT3yffhDuBe/mp7g4x5R0JcFyyIuMpKWVudWEDGbpu0t3TnOtYSWTeKnGPIv9hjlXaecAZ7nb4AtD9pj1BCvXvDXQH34LhoT6kuCdNANFqd244m4RpwPg
 yeg8sDhu
 riyOssecnqpgakxQpmWHKi4QbQxYNOmCxEngOKTdLB8aDjt6zjMCiSgHPy9oE0IJjnhE0Rkdo3+HQ3w7eLf4YdYCYNWgRzJJKlHMpAcHhP91XySr80dJD7b8FXk6vBayfRt2xgZOmQW6WF6RbpbTr3sjIcd/7dWwXIwMP/KC/WF/SYIhFHGuIUDvL1rJaL38anVxKVmBR7zRoErij9loZDEMgmkoSlk9gl4S/nxv/5UL9FrSgolkTLugjIA6ZSK6wRhALnkXw5RU4+atLS7GXWRssttIEao7fsedXj1hJSvTK0kBcESY1vzzOQx60IvUDfOqSv8aqVei6gk5ZvgJER0GuY10+BQdbNu2X+kKSTmny2VB0zvudhPusc9PC9xtoSX7U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 07:45:07PM +0300, Mike Rapoport wrote:
> On Fri, May 08, 2026 at 04:55:17PM +0100, Kiryl Shutsemau (Meta) wrote:
> > Preparatory patch. Add the change_protection() primitive that
> > userfaultfd RWP will use.
> > 
> > An RWP-protected PTE is PAGE_NONE with the uffd PTE bit set. The
> > PROT_NONE half makes the CPU fault on any access; the uffd bit
> > distinguishes an RWP fault from a plain mprotect(PROT_NONE) or NUMA
> > hinting fault. MM_CP_UFFD_WP and MM_CP_UFFD_RWP share the same PTE
> > bit, so the two cannot be used together on the same range.
> > 
> > Two new change_protection() flags:
> > 
> >   MM_CP_UFFD_RWP            install PAGE_NONE and set the uffd bit
> >   MM_CP_UFFD_RWP_RESOLVE    restore vma->vm_page_prot, clear the uffd bit
> > 
> > Both are wired through change_pte_range(), change_huge_pmd(), and
> > hugetlb_change_protection() so anon, shmem, THP, and hugetlb all
> > share the same semantics.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > Assisted-by: Claude:claude-opus-4-6
> > ---
> >  include/linux/mm.h            |  5 +++++
> >  include/linux/userfaultfd_k.h |  1 -
> >  mm/huge_memory.c              | 20 ++++++++++++------
> >  mm/hugetlb.c                  | 25 ++++++++++++++++------
> >  mm/mprotect.c                 | 40 +++++++++++++++++++++++++++++------
> >  5 files changed, 71 insertions(+), 20 deletions(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 3f53d1e978c0..2b65416bb760 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -3291,6 +3291,11 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
> >  #define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
> >  #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
> >  					    MM_CP_UFFD_WP_RESOLVE)
> > +/* Whether this change is for uffd RWP */
> > +#define  MM_CP_UFFD_RWP                    (1UL << 4) /* do rwp */
> > +#define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* Resolve rwp */
> 
> Nit: any reason except copy/paset to use different case in "do rwp" and
> "Resolve rwp"? ;-)

copy/paste it is. Will use "resolve rwp"

> > +#define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
> > +					    MM_CP_UFFD_RWP_RESOLVE)
> >  
> >  bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
> >  			     pte_t pte);
> > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > index fcf308dba311..3725e61a7041 100644
> > --- a/include/linux/userfaultfd_k.h
> > +++ b/include/linux/userfaultfd_k.h
> > @@ -397,7 +397,6 @@ static inline bool userfaultfd_huge_pmd_wp(struct vm_area_struct *vma,
> >  	return false;
> >  }
> >  
> > -
> >  static inline bool userfaultfd_armed(struct vm_area_struct *vma)
> >  {
> >  	return false;
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index d88fcccd386d..2537dca63c6c 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2665,6 +2665,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >  	spinlock_t *ptl;
> >  	pmd_t oldpmd, entry;
> >  	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
> > +	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
> > +	bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
> >  	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
> >  	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
> 
> It looks like uffd_wp* are always ORed with uffd_rwp, we could fold this to
> e.g.
> 
> 	bool uffd_prot = cp_flags & (MM_CP_UFFD_WP | MM_CP_UFFD_RWP);

Makes sense.

> >  	int ret = 1;
> > @@ -2679,11 +2681,18 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >  		return 0;
> >  
> >  	if (thp_migration_supported() && pmd_is_valid_softleaf(*pmd)) {
> > -		change_non_present_huge_pmd(mm, addr, pmd, uffd_wp,
> > -					    uffd_wp_resolve);
> > +		change_non_present_huge_pmd(mm, addr, pmd,
> > +					    uffd_wp || uffd_rwp,
> > +					    uffd_wp_resolve || uffd_rwp_resolve);
> >  		goto unlock;
> >  	}
> >  
> > +	/* Already in the desired state */
> > +	if (prot_numa && pmd_protnone(*pmd))
> > +		goto unlock;
> > +	if (uffd_rwp && pmd_protnone(*pmd) && pmd_uffd(*pmd))
> > +		goto unlock;
> > +
> >  	if (prot_numa) {
> >  
> >  		/*
> > @@ -2694,9 +2703,6 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >  		if (is_huge_zero_pmd(*pmd))
> >  			goto unlock;
> >  
> > -		if (pmd_protnone(*pmd))
> > -			goto unlock;
> > -
> >  		if (!folio_can_map_prot_numa(pmd_folio(*pmd), vma,
> >  					     vma_is_single_threaded_private(vma)))
> >  			goto unlock;
> > @@ -2725,9 +2731,9 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >  	oldpmd = pmdp_invalidate_ad(vma, addr, pmd);
> >  
> >  	entry = pmd_modify(oldpmd, newprot);
> > -	if (uffd_wp)
> > +	if (uffd_wp || uffd_rwp)
> >  		entry = pmd_mkuffd(entry);
> > -	else if (uffd_wp_resolve)
> > +	else if (uffd_wp_resolve || uffd_rwp_resolve)
> >  		/*
> >  		 * Leave the write bit to be handled by PF interrupt
> >  		 * handler, then things like COW could be properly
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 61cda9992043..63f6b19418b9 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -6434,6 +6436,11 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
> >  
> >  		ptep = hugetlb_walk(vma, address, psize);
> >  		if (!ptep) {
> > +			/*
> > +			 * uffd_wp installs a pte marker on the unpopulated
> > +			 * entry; RWP does not install markers so the
> 
> Nit:                              uffd_rwp

Ack.

> 
> > +			 * allocation is unnecessary for it.
> > +			 */
> >  			if (!uffd_wp) {
> >  				address |= last_addr_mask;
> >  				continue;
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index 8340c8b228c6..23e71f68cf7a 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -216,6 +216,8 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
> >  {
> >  	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
> >  	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
> > +	const bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
> > +	const bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
> 
> And here a single pair of bools should be enough I think.

Yep.

> 
> >  	softleaf_t entry = softleaf_from_pte(oldpte);
> >  	pte_t newpte;
> >  
> > @@ -256,7 +258,7 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
> >  		 * to unprotect it, drop it; the next page
> >  		 * fault will trigger without uffd trapping.
> >  		 */
> > -		if (uffd_wp_resolve) {
> > +		if (uffd_wp_resolve || uffd_rwp_resolve) {
> >  			pte_clear(vma->vm_mm, addr, pte);
> >  			return 1;
> >  		}
> > @@ -265,9 +267,9 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
> >  		newpte = oldpte;
> >  	}
> >  
> > -	if (uffd_wp)
> > +	if (uffd_wp || uffd_rwp)
> >  		newpte = pte_swp_mkuffd(newpte);
> > -	else if (uffd_wp_resolve)
> > +	else if (uffd_wp_resolve || uffd_rwp_resolve)
> >  		newpte = pte_swp_clear_uffd(newpte);
> >  
> >  	if (!pte_same(oldpte, newpte)) {
> 
> -- 
> Sincerely yours,
> Mike.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

