Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C02ECA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 10:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5196A6B0088; Tue,  6 Oct 2026 06:52:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA8A6B008C; Tue,  6 Oct 2026 06:52:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E08B6B0092; Tue,  6 Oct 2026 06:52:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 191FE6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:52:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7FB2240103
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 10:52:35 +0000 (UTC)
X-FDA: 85291887870.21.BE5D34F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D5EF9C0002
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 10:52:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPDc2rpr;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791283953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sb1SBwuGuPt1qP7ui7PIRFwQF/QwxhK7LWahurK/UGA=;
	b=HCEU7Xk3rVrAVm7IhVYLFeIFuGIcvUYKT5zQAzLbqW700+X2QYxBvlywDvLkG6umu7lNL5
	mYtPW/zr4vRAUpQ0RnQgKYpNWS4H6rZ/2a+TfGP3QcOvDXn8S/VGOTjUACJHGnsbKVj/pV
	zmY1BnnhtSE6eN6hOHemexDqYdd0a/g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPDc2rpr;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791283953;
	b=A6XR8EMmqDyydNWYqfFecMCbYp/gRBffFfGzMomblgGtOtSgSzNKJSzh3NewhStieNqUP9
	3bka+nYyJp1WeuKjsKKnjVJl5AqICRnZgnf20wcyNYfbHizI+1ogWGtzuycE3gqJAJ14tj
	l8OWN/kH79boCsT15cXbkoJuSZqXqrk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1198E6022C;
	Tue,  6 Oct 2026 10:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0891F000FF;
	Tue,  6 Oct 2026 10:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791283952;
	bh=Sb1SBwuGuPt1qP7ui7PIRFwQF/QwxhK7LWahurK/UGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UPDc2rprdWWklNjxtl84opXyR87sbol/pJaC9vtqX6Sxn4rnOqdifPu2HwdV1iQ+O
	 u38O2miOTA5MnBFfEQq8L9YSpRWEYQpuWbZy6RYRA3f99TiWUQzS0KLiqV19rOFHqh
	 fY5N0qs4goUW6KgL7eEj8lkxXZ5yVeeS3YQR0YFVOeGp3ao3Sx/h42dRjBQoER7W5Z
	 xOUwp+ofq5vwtBjlRohMtRDAwPCJzDzRZT1QX7gpltGi3uewvT6Ys4uhTuU705Q7fP
	 WnbobxKCz5yU2Z/9lGB/XJi/Ctpvap2cJHMiAGQ+iR9zPjPpYSOUSHu1pif14dCz9F
	 GHd5d5QVErTLw==
Date: Tue, 6 Oct 2026 12:52:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 6/6] mm/mm_init: add zone mismatch warning during page
 init
Message-ID: <asTS6OtxPMVshuIO@kernel.org>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
 <20260929053231.66085-7-songmuchun@bytedance.com>
 <ar5xbQsUpSQZg0wO@kernel.org>
 <78D5D6AA-BE36-432C-B0F7-453F93DF18C0@linux.dev>
 <ar9p39Y9SmlxvbA_@kernel.org>
 <85941AA4-7E50-4AAE-BC05-0F443B21BE8B@linux.dev>
 <ar_0GLYM6KsIH6tQ@kernel.org>
 <D91CEA1E-6B79-434D-AF49-16C62C0FD095@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D91CEA1E-6B79-434D-AF49-16C62C0FD095@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D5EF9C0002
X-Stat-Signature: icgmgbknbsndp54iu77yh6uym9195qa1
X-HE-Tag: 1791283953-615285
X-HE-Meta: U2FsdGVkX1/PcIjOeIelXV1DJmKv+eomV9ud1Nu8ePma9+2htxnkqXm/1rcemfzYVGVB4GlHpND8R6ThG6lOAKBXupNSg8P5ax+Z6OVbGrNOkdGkoMrTTvZuI3E2PyydHKRmehE9SU/3cSRIIO4nM195+/rOd1ro7wKkjG4QxrFlPn6RCqYCiljtUwnLtzTXsKEUdLeCYoHEHBmyM0wHacR7nu3HM7E3NSUuKciJ2hF2FtGlLfYMmgwbIoL5LefD6tMzg5wwP3GTcBcAso3Itggi2WE7YLYmSb/a3hmtfmm3LNIQ5NbLhtRuouV4dswbdUUpjy486dngrOpE6LRr2rylK6dxFssPsADab7OGXkWjX43oSPiAUURMPMMpIKvEoH3PUZ21ZfhNjtnaSlkLiIevmqr2exT8NjCo3s9zZcguGUWHOMxzD03NOLgtA6ega2XgpDq9Ets3MUobvIg1ePQoXKriZ43IOxV3OMnn55gfjpMjq1cpaXjLOV9UCZHjdxKAIf3ZyGdn9TyDDxk5vK3DEoWircHCUWqw/fZiVmJMUyojxQGqBju+XROxLOKA3TxLcz9XE82wvhxv6ZjbvniLjwdhFWtFvjyFv543/68lgbRrwDLN14QoyyTtXZWRpqdd9gsTJZ7pk49OBIlq23kuz3Mq37E6cYkzPRcp4wVDOzk3nP36cLkJy07Q9JeOyraDHSGp2yNpH/mJDqpb/2P91kftYpRmRB4/ayJ7OuO1hfQbdZXQ53uGPmTrnHNBCRWgRWxYFowuPB+KdTuVfSBcBA/mr5ZxfBCASI3s7WS84JM0OqCatVeLAHOkrtg/7FvmqCrUZvCDVAB3QP4Pgs4RgZHqJVB3jEVqTddGRDo6nKVcEKF0vVBo9m2IVgUZIz1XWoOezjv4lFZydp/UGwZWy7NzOMLVwbSp8OeV9DvYV3udTvmRh7THqj2Q1ClIRNyat8dow5kUAq7qtVx
 lMreNj4J
 vB65DOgUzwNVa9nqdNsey/gJk6VyQauaUymsmuWOU1T72m8vFRKxVdIKZhSFZyrY6j5hQGUrZ8fQX3meKYha1lW03SN8/3q/Nzdy0TuZwdO1jLhHMMAuCyAh2WyE1O0I2ql3kjrz384ZAkfEbGXdBoZAzp6OznkQ4GPHS3a1p8rfMKzIEEh2Lb1b4NXYNA2kL9sEt1dycGR30OMJI+Asdepf4fjwUmb+LqIjNpAxvgo3pE5DADo3KCzCqEgzXz8f6ur9wv6XtFUY8qtHaDyX0aGyGsq87KdTG5GEauerVaWuUxEAOwFUFUcw/lbVyQq5bLuriWUj4id+Kd5FehNAbTK+2SqrgPzyvz9gr8qzVPnjFhAlV58JmqLgYnvZk53IJapXBkO/JxEMGouzoI/pV7KcVEPPtNknWiJwJDfOfS+4fsPFErsxNHIxUqdd5KNTyvB6ew4mnOlAk5uM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 05, 2026 at 06:27:52PM +0200, Muchun Song wrote:
> > On Oct 2, 2026, at 20:12, Mike Rapoport <rppt@kernel.org> wrote:
> > 
> > On Fri, Oct 02, 2026 at 05:56:40PM +0800, Muchun Song wrote:
> >>> On Oct 2, 2026, at 16:22, Mike Rapoport <rppt@kernel.org> wrote:
> >> 
> >>>>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
> >>>>>> index 1650d6bc1211..bd02e8d06965 100644
> >>>>>> --- a/mm/mm_init.c
> >>>>>> +++ b/mm/mm_init.c
> >>>>>> @@ -609,6 +609,9 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
> >>>>>> if (!is_highmem_idx(zone))
> >>>>>> set_page_address(page, __va(pfn << PAGE_SHIFT));
> >>>>>> #endif
> >>>>>> + VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)) &&
> >>>>>> + page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
> >>>>>> + page_zone_id(page));
> >>>>> 
> >>>>> Hmm, page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES is initialized a tad later
> >>>>> than page so it'll have stale data in the page->flags, won't it?
> >>>> 
> >>>> Lance is right. The shared tail struct pages are already initialized by
> >>>> vmemmap_shared_tail_page() during vmemmap population, so they're not stale.
> >>>> The head 64 struct pages are initialized later — right here, after vmemmap
> >>>> population.
> >>> 
> >>> Still it looks out of place here, can this check be done in sparse-vmemmap
> >>> somehow?
> >> 
> >> The struct page entries of a vmemmap-optimizable compound page
> >> are currently initialized in two stages. During vmemmap
> >> population, the shared tail entries are initialized first. The
> >> retained head area—normally 64—is initialized later through
> >> __init_single_page().
> >> 
> >> This warning connects the two stages: while initializing the
> >> retained entries in the second stage, it verifies that their zone
> >> information is consistent with the shared entries initialized in
> >> the first stage. Therefore, the same check cannot be performed
> >> during vmemmap population.
> >> 
> >> I am planning to first unify the HugeTLB and Device DAX
> >> compound-page initialization through a common helper [1]. Once that
> >> work is complete, maybe it will be easy to move the initialization
> >> of the retained head area into vmemmap population. With both the
> >> retained and shared entries initialized in the same stage, there
> >> will be no cross-stage inconsistency to check, and this warning
> >> can be removed.
> >> 
> >> Would keeping the check here for now and removing it as part of
> >> that follow-up sound reasonable to you?
> > 
> > While it feels really out of place in __init_single_page(), but having it
> > memmap_init_range() close to the if that skips shared tail pages makes
> > sense.
> > 
> > What do you say?
> 
> Sorry for the late reply because of traveling to LPC.
> 
> Putting the check in memmap_init_range() would validate the
> invariant for the shared-tail range skipped there. It would
> not, however, cover all vmemmap-optimized initialization
> paths: optimized Device DAX bypasses memmap_init_range()
> when there is no altmap, and deferred boot-time HugeTLB
> initialization may also initialize retained entries
> elsewhere.
> 
> If the intention is to validate only the skip in
> memmap_init_range(), moving it there makes sense. If we want
> the warning to cover both HugeTLB and Device DAX generally,
> it still needs to remain in __init_single_page() or be
> called from the individual initialization paths.

Yeah, putting this into all the callers sucks too :(

With all the callers,__init_single_page() is the right place for this
check, but I think we can add a static inline in sparse.h, like e.g.

vmemmap_optimization_verify_zone(page, pfn)

to make it a bit nicer.
 
> Thanks,
> Muchun
> 
> > 
> >> [1] https://lore.kernel.org/20260513132044.41690-18-songmuchun@bytedance.com/
> >> 
> >> Thanks,
> >> Muchun
> > 
> > -- 
> > Sincerely yours,
> > Mike.
> 

-- 
Sincerely yours,
Mike.

