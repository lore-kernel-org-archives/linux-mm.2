Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AFA3CD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:07:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A985F6B0005; Fri,  5 Jun 2026 04:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21FA6B0088; Fri,  5 Jun 2026 04:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA6C6B008A; Fri,  5 Jun 2026 04:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 797466B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:07:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0DE64A0B24
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:07:42 +0000 (UTC)
X-FDA: 84845129964.14.DED8B7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 552434000E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:07:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jeQED94S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780646860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w8kRAMlknVLQLfZAIgetzKT8WiVn11imE2IVzaLKdwc=;
	b=kKVYO4HisHDK0W7YNBqmrV+re5cQQ0MFldWKjC5XtUkXzO5rO7mqGQS5fvwC/gPCUShOMm
	8GU4qcq+rCidVULWAB91pwiPJqoD+O2l811Z3ZIqujXfrJu+hIx/rKm0L1QG7l9IgLlXpS
	9goCe6AT+o/jAj291iHVPY5XyLA1iVg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jeQED94S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780646860;
	b=6zlh/MyDrvw3AEQJDK/3MUYGyZYHO2KrKCwDsCsjjz09ePehjG0lokaTdJ8IDr0di13hjn
	iECHFxOxxPmxuHIOcjhtSqXR2ToCZG9lsE+J6rNIiD1NxaxKcWXf1zepfYs4pms0wkbhQu
	173jfGnDpSvrqsuJU66W0/rNl7SA1Q4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 783C9441D6;
	Fri,  5 Jun 2026 08:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C0C1F00893;
	Fri,  5 Jun 2026 08:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780646859;
	bh=w8kRAMlknVLQLfZAIgetzKT8WiVn11imE2IVzaLKdwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jeQED94Sid+eP6XYPiyQtS/9tDsTpbhHbsga0f0MGCMFWycZ7TBodq4q+ofyjtNWt
	 H3No+jBLfDjAB5Ml2G70qjsUCV0W7udUJgt+kLD8snZc39i1tEwYd1B8iqJUcr6wjB
	 BFMKkt07IDVyDvfv1Fkh/f6vvFvgi7gIk45O9dpw2Xi02owgCzTGsTJAqT4AT/ACoh
	 VsiRS9K/NmtwqmtFMa9YXGBH/J51PYI1vDWWghVE+fUR6gp/ejP9sE1TGMA7cPggks
	 Zc897pF/K1divsMisGWoHQ0ECpuFZxiTed3uMJyY6bFT9WyPP3LGYuTmlG3uNnndVx
	 rruLEKYp4cQ7w==
Date: Fri, 5 Jun 2026 09:07:23 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, Lance Yang <lance.yang@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, akpm@linux-foundation.org, 
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com, 
	usama.arif@linux.dev
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
Message-ID: <aiJ90SWqXvwN9dNT@lucifer>
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev>
 <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
 <616de1a8-1cfd-40b8-b04f-7b324be40bfd@linux.dev>
 <6b11bf0a-769c-4ef2-ac6f-2af38200a6bc@kernel.org>
 <baa0a462-46e0-44ab-b583-c722ad253afe@linux.dev>
 <06d9b665-945f-4967-9ed9-b06514478996@kernel.org>
 <CAA1CXcAeEGOsqp-ywAQ7GMYQzXEeco-rUxUkk2hEF69HybC4=w@mail.gmail.com>
 <CAA1CXcBSPVG4CJFCBDvbuodcJ_7eXoDQTpK0ZN0HEhkDPi-DEw@mail.gmail.com>
 <0ef96c28-9e6c-4d04-90ae-ac43c81d465d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0ef96c28-9e6c-4d04-90ae-ac43c81d465d@kernel.org>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9ikjrfi1fimwipue98ccnqg8myiwxdgg
X-Rspamd-Queue-Id: 552434000E
X-HE-Tag: 1780646860-294804
X-HE-Meta: U2FsdGVkX1+EXhv1OgEz5Cdg/PWGMYS7YFmHLaGxGjWxzIhsQlo+imSa5rakDlAlDwoQOe2qSdJ+gfFW3DiJXdrfZ/JRXwJVr7QuMujhzJrbVYtLsx5r3T3lgoo7BoVuLuRog8QImL9eEa1DieF43+jiLARTNuceZxu/G+Q8xWB0SnoBbxND/guzeaFYUqmAMfcSSzftlqACEkdVfhRkUkab/FLAe7vorqEbsC1kbx2vROAZXC6W7Ykr6fZXT0fzF5AtmgRJ2bjoNTiHNyOLY904Fcf9vrBU6TtbtdNDvbMK8Ffjuir41WA4Hg5TKKM9Z30fURMPpH2CcKN7Fdhhdc7Voi+mHOU7SkALSqAK3bqMz4qaoMMZLzNJiyqlOatO8i5H3EiXIWnzJOKDLNxgDP/jO/Xf+IDzUW0zztLUqIfG7zCdjEzxkYa7tvdxuJ8MIkIQUr6438J8HnBw6mEm7uH5jbAQ8YBIbOFEM1d1YdYJW88gnBTggal6tNKxQq3j/XhEYRQvnKMs8s3FgocY0DzxQTZK/obcszLskqiHjm9q3OqVTeXKOAIQ0ea3QgXfkQuitcGFqzndlTgQeeTTFs4avRkjynpZR6OycvNTQjfIvnF/OVm5ocOIqxvVZWwQYqVrMzVPQXfmAeS0pg1H/02qyezGl4hAexNDlMOJqNZMkefTmL6EVjLHgCj6IvLomT0vnj/5PpTAFnFtFv0ChSuFpqtq/pfYXyaVNMX8HnweF/nQbmRQI/TYry5XLmhRyekQM+j15p7v7hTqqTx954X36rHkaG0/bWzPL/5yrt/bgcanubmlx9cQ51oTI2YDj4m9YmySWYOn8RDeYW56HU9eOS7qyYo7XwKZYxh6UqQZyRnY8csMZu/Me8dM4gLkdK9hzAkWxHkRl7sVgbqtn3MTSeoGUty/BjvMLiWRXsAqm+eeeVBA1sIuNPed+YYqp2RneXNno6s0ZtgtktF
 JAmdhaz0
 fbYW7WD0i1M8ZgIlaf2PYYz9OIHJZ/HHZCdhRV427+bqkPAlm5RKNCTpPIhNzJ5iQxUd/pnb/3+ts2eCUy3LRL5hNwA/IuK78fG4Qb55To0I7+Bul2S+O3BdkYU0OIT/h7f8gWljqD4/e9c6wjhPMTodrAO5mskOPu1dgcCUWwY8Tgbm4JOduWIpUjNGFNdtqhPPJ3VsT985bZeMQMktuk6Fax/7f8GEB6m2Lx7RJQEBPQ7fRu0k3Sg0Hz6t2GC1kfZeS9okrAdVSIlz0fL8bMQBJBD+6mLWxM44DmPwVCyQniXACeHPD1PKYaJvDvQbyUoCgmhwOkKRdNxvn3av9KH3ZvMKLSWCnteCFpf+98m9Q+MprAx91/1riHLB6LbAcSEQI7GvYXmUwfez9qKxAYsg5n+kbRcFm8vQbgBsbasXIRJVyJsDXbw5PhtGLhkpJzgX5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 09:18:27AM +0200, David Hildenbrand (Arm) wrote:
> On 6/4/26 19:04, Nico Pache wrote:
> > On Mon, Jun 1, 2026 at 9:00 AM Nico Pache <npache@redhat.com> wrote:
> >>
> >> On Mon, Jun 1, 2026 at 5:14 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
> >>>
> >>>
> >>> Yeah. BTW, I think we'd need a spin_lock_nested(), so @Nico, treat my code as a
> >>> draft.
> >>
> >> Okay, I read the above and did some investigating.
> >>
> >> I will try to implement and verify the changes you suggested :)
> >
> > I've implemented something slightly different actually and I *think* its better!
> >
> > } else {
> >        /* this is map_anon_folio_pte_nopf with no mmu update */
> >         __map_anon_folio_pte_nopf(folio, pte, vma, start_addr,
> >                       /*uffd_wp=*/ false);
> >        smp_wmb();
> >         pmd_populate(mm, pmd, pmd_pgtable(_pmd));
> >         /*
> >          * Some architectures (e.g. MIPS) walk the live page table in
> >          * their implementation. update_mmu_cache_range() must be called
> >          * with a valid page table hierarchy and the PTE lock held.
> >          * Acquire it nested inside pmd_ptl when they are distinct locks.
> >          */
> >         if (pte_ptl != pmd_ptl)
> >             spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
> >         update_mmu_cache_range(NULL, vma, start_addr, pte, nr_pages);
> >         if (pte_ptl != pmd_ptl)
> >             spin_unlock(pte_ptl);
> >     }
> > spin_unlock(pmd_ptl);
> >
> > The logic here is that when the PMD becomes visible, PTEs are already
> > populated (no possibility of spurious faults on local CPU)
> >
> > the SMP_WMB makes sure of the above

THe locks prevent those 'spurious' (really: incorrect) faults anyway so I don't
think this is necessary.

> >
> > And the pmd is installed with the pte and pmd lock both held through
> > the mmu_cache update.
> >
> > This follows the conventions used in pmd_install() and clears the
> > potential for local CPU faults hitting cleared PTE entries.
>
> After the pmdp_collapse_flush() we'd be getting CPU faults due to the cleared
> PMD already? So the case here is rather different.

Yeah conceptually the code above is problematic because you immediately make the
PTE available right at the point you populate, so taking a PTE lock after that
is rather shutting the stable door after the horse has bolted.

Doing it this way is not a good idea in any case because we're adding
complexity, an extra function and an open-coded cache maintenance call for
really no benefit.

I asked Nico to abstract the anon folio mapping stuff explicitly so we could
avoid this sort of duplication so let's not roll that back :)

So again, I think going with the original suggestion (with an updated comment)
is the right thing to do.


Anyway, an aside But in practice we can't have page faults here right? The VMA is:

- Ensured to span at least the PMD range (this isn't immediately obvious in the
  code)
- VMA write locked (mmap write lock held)

And we hold the anon_vma lock so no rmap walkers can walk the page tables here
either.

So I actually wonder, given that, whether we need the PTE PTL at all.

But.

At this stage it'll almost certainly be an owned exclusive cache line so it's
very low cost to do it, and it means we honour the update_mmu_cache_range()
contract.

And it also makes it clear that we're gating changes on the PTE being
untouchable so any future stuff that maybe changes some of these rules doesn't
get caught out.

So probably worth keeping.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

