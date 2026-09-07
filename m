Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 063F6C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF94E6B008C; Mon,  7 Sep 2026 12:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA676B0092; Mon,  7 Sep 2026 12:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE80B6B009D; Mon,  7 Sep 2026 12:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C81C6B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:17:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF311401D7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:17:42 +0000 (UTC)
X-FDA: 85187471964.09.5FDD7CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 555AF40006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:17:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=chjSiu0k;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788797861;
	b=I6Lkabo5MAl2GVDmu9TDPJztw8Z1uI8BpPe5Ur0QyTu7q/Hxp9qEZ6pGKeFbQKdJ1sqi1z
	FtbZwaRQNqi8ok74A6y9hklX06/Z7WCXJYtM4eKbQJ4rtJa5C69/BlvJVTzk85v73ClwEa
	ndut5DepmEOIx3IU5FUZL9Ig1rtRbwk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=chjSiu0k;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788797861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOnQahPO1TmCL6FmC3Riu7SZQYrSuY8UOh5mIJltyRE=;
	b=Kgiyys9cUPAGWTF1KP8RsgeHquWLhuypktner+IbIaHvGLdT0M72HVn9bBOU0lCDIgBt/l
	iN9HM6JeM7dfaApsayucFvrM4mhlNg1iCqRbv5QKDK8biUv0iV3ZzgmuJuntN7f7rog5Hv
	yWA4VjormAzE3jukqerIfMGoHeb/NPs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DEE7D601DB;
	Mon,  7 Sep 2026 16:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D921F00A3A;
	Mon,  7 Sep 2026 16:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788797860;
	bh=wOnQahPO1TmCL6FmC3Riu7SZQYrSuY8UOh5mIJltyRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=chjSiu0kxNy55FySd80YLuWpGKduvYPpWOIeXBDAEDtKqnVBNh9d2zpIacBhCSdaA
	 /hPjIqOuSUHj8c/P9fQmZl5QsN4WOnfiIOfKBSlpTDf98LalsExTWUCBri/U/G11Qu
	 463UFNmJOoS1/LOyoX+MydBYhJ4deFChj18UBUl7lXOC4G9EfqkcCO0FWNUFnMgVSu
	 ZJ0dq8yg+/MGoN7WleKNCrwoFHxPeyLQn9DKBpOtPSgfQA6XKTE7mNpQtFaKmgn8pj
	 cXgDuC+tRseK5NaxjJcE836EtT/y3wIWapSvHcDps3dvye1fYFKYf3q119INcb4rPb
	 /Z9QHNIdzdHYA==
Date: Mon, 7 Sep 2026 17:17:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Cedric Le Goater <clg@redhat.com>, 
	Saravanan D <saravanand@crusoe.ai>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: bypass THP tuneables for huge pfnmap
 mappings
Message-ID: <ap7jVxFLczCCsJp_@gremlin>
References: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
 <034a2687-3551-485a-a382-e7e77aa3919b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <034a2687-3551-485a-a382-e7e77aa3919b@kernel.org>
X-Rspam-User: 
X-Stat-Signature: qdouu6cka96jiye1iu1dkagj4kni1z7p
X-Rspamd-Queue-Id: 555AF40006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788797861-119241
X-HE-Meta: U2FsdGVkX1/HFg8x4SSmLeWfPzflRRczThoNeKMoSCEtHkLP4z2/HGbg50LbjxNHMwLnFLNF1kIe4zaKNHScETOiqJ0zZPMufVVc5nFpT5O2cs/hiHOXz+G/3BJXL2P0bErUlowzYYwTpvy7UPxArTLV9YrvjgHPunib8w5yb/QG9KspicPg19bKAh5HfNd3Ukj72wqgnqA6xi6G69WsEAOjzMeMZpW2IgjQ0Dpm1zrkMHXopQ0oqzZApDC6egTqfvZUvGKPGfmU26iZrNbkLkbVj/QVsCDJNbmTLfQgUG32SfCxYVM7crlVoyFuxUsZjcY2T2K415wtuM6S3OIMPZYMyW+yxlKYIa1wfddTDPTHJD2LyklsqSSHpPZVQuH/hBjQn/ENE6N/hO4LM3ECG/pHWEtKdsVxR5zTOYvgxOY00Xc5N6TMWjQvOA86wH7O1E8CwuGu/+ebW2TXuYflv95l5lDnXccuUuscMSDerEDs6u5tYWK0NW24BmNDjTHpW7Con1ryNRZl9KSXJVBYUpl9fuhlN4qmnlqPM9OnYV+ceZdD8M45gypzz0FUOq9TCBc92Gp+XgTy/U7tcdBuK2Z6sxzad1TGh4yf4UIBulLRGPhvQwKRhxxOuifs9VXPgCWJXYmqEeo85AIxCZ3M37xQbrH6Q0larbE6u+d4TxcWyP2ZgRKAKewrGcKKgrIqE59kiDvCzX3Qxs0cZvxJKfRiSNnIt3ictwhT5C6NSCrtKInmwDOqTVcnYczWcPbUoEk+lb+HVVZQuqFY8JIb64sq9+epnBarLlfZ0SFLOvOxka7AZ6Rh6kt5FVGXucFvzaIfyM9u1C/6xPAxa+LfCJbBPznFIJFycJ4OM/1shQS+aIB1BW6cpgY05WHlNzbj7OGc6ZGmWDMsAWxWdXyelg8mFUCsmWO3kU5FXGW2TvYCL1Z76vdJTWcDjTOKvfxU3v+XKQrokUQ5D4vxnTv
 U6ZaP6Li
 e6aMGMSYUIaolNl9VNB62rCzBh7VnlELwyyQSEM3Bid4ZxZ7iz1CpZ4AkPlOP597uEmEZH+4ZWCPODPZ1lO8p/jYeVZ50ZdY3lMZARU4cxJ3nh4j9zJHfcSZI/BMccXjwHSMZgGqQUMyyFvKSJbzsjRERnHNvUHjk6/G2zPJTITm0ea9OK8DjviVDoX4TlSNa1G2d+iaLj8rdx993csVfsOAonvw2w7rFEV8jTnLCo1kRiogHM4FEo+RkHsX4kiWxXPRlpFLvBocDIQASiyYiz5nmOz6AEGTRTG04aN3OM8OQbiqH0EgWtmZEV2dCRzHIwNvKw4VQB2xvlazIWnVUfnV+/jLdHbqeFM+Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 06:14:14PM +0200, David Hildenbrand (Arm) wrote:
> On 8/27/26 21:55, Lorenzo Stoakes (ARM) wrote:
> > The sysfs THP tuneables at /sys/kernel/mm/transparent_huge_pages/ rather
> > confusingly only control the behaviour of THP in some instances.
> >
> > They are not applicable to MADV_COLLAPSE operations, nor to DAX mappings.
> >
> > Long-term, THP is predicated upon compaction being able to obtain large
> > folios to populate THP ranges.
> >
> > However, vm_normal_folio() returns NULL for PFN map mappings, thus their
> > reference count is maintained by the driver, not core mm.
> >
> > As a consequence, the folios are not subject to reclaim nor compaction, so
> > are not truly part of the THP mechanism at all.
> >
> > However, since commit 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
> > introduced the ability to establish huge PFN maps, they have been subject
> > to THP tuneables.
> >
> > This is incorrect - if a huge PFN map is available (defined by
> > vma->vm_ops->huge_fault being non-NULL for a VMA_PFNMAP_BIT VMA), then it
> > should be mapped huge upon fault-in.
> >
> > Correct this by explicitly checking for this while ensuring that smaps
> > continues to accurately report THPeligible statistics.
> >
> > While here, abstract the entire file-backed THP check in
> > vma_can_map_huge_file(), with sensible separation of logic into helper
> > functions.
> >
> > Note that drm_gem_shmem_mmap() and panthor_gem_mmap() establish huge PFN
> > maps of shmem folios, however they are marked unevictable in
> > drm_gem_get_pages(), and in any case would fail the reference check in
> > __remove_mapping() even if they weren't.
> >
> > Failing to map huge PFN maps has resulted in significant real-world
> > performance degradation, see links for details.
> >
> > Reported-by: Cedric Le Goater <clg@redhat.com>
> > Closes: https://lore.kernel.org/linux-mm/20260805055544.1568534-1-clg@redhat.com/
> > Reported-by: Saravanan D <saravanand@crusoe.ai>
> > Closes: https://lore.kernel.org/linux-mm/20260821070520.25759-1-saravanand@crusoe.ai/
> > Fixes: 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/huge_memory.c | 86 +++++++++++++++++++++++++++++++++++++++++---------------
> >  1 file changed, 64 insertions(+), 22 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index afbb5974bd22..4bf7b670586d 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -92,7 +92,7 @@ unsigned long huge_anon_orders_madvise __read_mostly;
> >  unsigned long huge_anon_orders_inherit __read_mostly;
> >  static bool anon_orders_configured __initdata;
> >
> > -static inline bool file_thp_enabled(struct vm_area_struct *vma)
> > +static inline bool file_thp_enabled(const struct vm_area_struct *vma)
> >  {
> >  	struct inode *inode;
> >
> > @@ -118,6 +118,67 @@ static bool vma_is_special_huge(const struct vm_area_struct *vma)
> >  	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
> >  }
> >
> > +static bool vma_bypass_thp_tuneables_file(const struct vm_area_struct *vma,
> > +		enum tva_type type)
> > +{
> > +	const bool has_huge_fault = vma->vm_ops->huge_fault;
> > +
> > +	/* MADV_COLLAPSE ignores tuneables. */
> > +	if (type == TVA_FORCED_COLLAPSE)
> > +		return true;
> > +	/* Huge PFN mappings are uncompactable so the policy doesn't apply. */
> > +	if (vma_test(vma, VMA_PFNMAP_BIT) && has_huge_fault)
> > +		return true;
> > +	return false;
> > +}
> > +
> > +static bool vma_thp_tuneables_allow_file(vm_flags_t vm_flags)
> > +{
> > +	/* THP=always? */
> > +	if (hugepage_global_always())
> > +		return true;
> > +	/* THP=madvise and marked MADV_HUGEPAGE? */
> > +	if (hugepage_global_enabled() && (vm_flags & VM_HUGEPAGE))
> > +		return true;
> > +	return false;
> > +}
> > +
> > +static bool vma_check_thp_tuneables_file(const struct vm_area_struct *vma,
> > +		vm_flags_t vm_flags, enum tva_type type)
> > +{
> > +	return vma_bypass_thp_tuneables_file(vma, type) ||
> > +		vma_thp_tuneables_allow_file(vm_flags);
> > +}
> > +
> > +static bool vma_can_map_huge_file(const struct vm_area_struct *vma,
> > +		vm_flags_t vm_flags, enum tva_type type)
> > +{
> > +	const bool has_huge_fault = vma->vm_ops->huge_fault;
> > +
> > +	/*
> > +	 * Enforce THP collapse requirements as necessary. Anonymous vmas
> > +	 * were already handled in thp_vma_allowable_orders().
> > +	 */
> > +	if (!vma_check_thp_tuneables_file(vma, vm_flags, type))
> > +		return false;
> > +
> > +	switch (type) {
> > +	case TVA_PAGEFAULT:
> > +		/*
> > +		 * Trust that ->huge_fault() handlers know what they are doing
> > +		 * in fault path.
> > +		 */
> > +		return has_huge_fault;
> > +	case TVA_SMAPS:
> > +		if (has_huge_fault)
> > +			return true;
> > +		fallthrough;
> > +	default:
> > +		/* Only regular file is valid in collapse path. */
> > +		return file_thp_enabled(vma);
> > +	}
> > +}
> > +
> >  unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> >  					 vm_flags_t vm_flags,
> >  					 enum tva_type type,
> > @@ -190,27 +251,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> >  						   vma, vma_start_pgoff(vma), 0,
> >  						   forced_collapse);
> >
> > -	if (!vma_is_anonymous(vma)) {
> > -		/*
> > -		 * Enforce THP collapse requirements as necessary. Anonymous vmas
> > -		 * were already handled in thp_vma_allowable_orders().
> > -		 */
> > -		if (!forced_collapse &&
> > -		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
> > -						    !hugepage_global_always())))
> > -			return 0;
> > -
> > -		/*
> > -		 * Trust that ->huge_fault() handlers know what they are doing
> > -		 * in fault path.
> > -		 */
> > -		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
> > -			return orders;
> > -		/* Only regular file is valid in collapse path */
> > -		if (((!in_pf || smaps)) && file_thp_enabled(vma))
> > -			return orders;
> > -		return 0;
> > -	}
> > +	if (!vma_is_anonymous(vma))
> > +		return vma_can_map_huge_file(vma, vm_flags, type) ? orders : 0;
>
> I don't have the time to find out how these functions ended up being named, I'll
> have to trust that it will be alright.

:-O

>
> Adding to what Zi say, vma_can_map_huge_file is also confusing, no?

Yeah I agree, I had a model in my head as to why it was an OK name then when Zi
raised it I realised that my naming scheme was, in fact, terrible :)

>
> are we mapping a huge file? :)

Lol... hugetlb maybe? HW poision too? Perhaps? OK you've only been back for a
day I should stop using these swear words :P

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

