Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EB0C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A246B009D; Mon, 14 Sep 2026 11:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72796B00BC; Mon, 14 Sep 2026 11:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BADC36B00BD; Mon, 14 Sep 2026 11:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 984C56B009D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:20:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DE1C140184
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:20:15 +0000 (UTC)
X-FDA: 85212728790.22.8C9EF3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 91F991A0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:20:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=agVnINAX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789399213;
	b=LzxkS1et/bEwbgHGXBTDSiTpIyfh7ECWY5ZwOLB+wMeNeBH3dTu07wcTbqFuiRU2CZeR+O
	o5l6oD9dr32m4MOtU8YUEX/gp9xkoVObFqpPszdXSm6VYSoGdLCmBSyv14twlz43VaL1MV
	x21gDKb08vNKJUyeK4Rg+smUv1D9psM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=agVnINAX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789399213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QuICXryj3rtgQiC2AqSchUKR7Zt7J09e5geN7kW0voI=;
	b=XxY/XKv5K31ajDISwXkEMfxYYW4xdgb29zi7ElxTPLzyJv6wvly4tWfopMiW0V6mknkcJa
	b687EWR1n6OXOuYaWvWIvjMVVauMhFhyEfj0XJRMsbmgnNQOYcpf9kSKNhBy2YFxq/bYV4
	6qzAwDDfTs6PPU649oQGMHQF4PSsjac=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E6ED60142;
	Mon, 14 Sep 2026 15:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5341F000FF;
	Mon, 14 Sep 2026 15:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789399212;
	bh=QuICXryj3rtgQiC2AqSchUKR7Zt7J09e5geN7kW0voI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=agVnINAXKULV/DF8wRfY0MB14blSneHnWBCQ2DjZxOTAnrRqXlW9/sS0OPBdnEJXt
	 pHGa6Vi1rvE39snHRYj83/KVuYkPoQYuCyNhfKETW/gAWgKdMfI/zPmT3z+gvdrfYA
	 fgjs1ydldyGwpicMWxu/04M4oLdkiwi9i9uZZwRaZrmE/VrbEKgw1tRaXoAKVXH4Tk
	 1tblCYcfhskxs+iaix8nC9L2f11kYPZ4lFotVO6n3VVbOW+1346J3iO009PcAB5I6e
	 gaE4lO0rI0JND/pWNHGXNb1RaYAbFmruvtXBJIritkG+PsOyiKS0RnGGoZajqiZMXD
	 qzzqpsVOXyLqw==
Date: Mon, 14 Sep 2026 16:20:02 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Subject: Re: [PATCH v2] mm: implement and use vma_anon_tracked(), silence
 KCSAN
Message-ID: <aqgOTUiz-7Mf-2sE@gremlin>
References: <20260910-vma-is-faulted-v2-1-e81ebc7d146b@kernel.org>
 <7d779a3e-0c12-42fc-91e1-fe53ae2dc641@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d779a3e-0c12-42fc-91e1-fe53ae2dc641@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 91F991A0002
X-Stat-Signature: ucf3r5f8z8rxfrompgh6ad633kp9e3nf
X-HE-Tag: 1789399213-665622
X-HE-Meta: U2FsdGVkX18Hya8oTGOxskkOuBsYiqfkkyAtxx655Fdk6zRTlT6YEJLQciTWkmpj5PqjXu2E1mcOJovFCgjSwGzOWKqxtKfY6+Qao/ULsG3guLaKtjpzQL75byMFqEua9RJBa+nuHTKkzV24ieyCKpVsswBiTgvWbEZ5dYLeckeIHBIuH5jVIoP9jakGpcQ1aWRBBP9Fd+g1yNQVist326yyAZowbn8p67d7GAyXCKtbmajSSDmx5MelUcU8tDNxD8aVTQQMaM68hsNA1pclJ79PSz7Yh+VrkN1EOtc611vQahNJhotfkk2qpvL/tmDCv5eKDZ9CBi+n8yZqdJkzKltnkmOqsp8tXHN1jsHpoEDvdlRfSMcMbt/1vdgZbgNN4zvsAlSttJH5t1ON9TeZW3vwSChz+AijBHSJg/M8Ggg1sXh5DDChbPU/5LgpW2QoRlmmoUsgb6FZUS8BdAg4NP05zRl89lFY0Tg9NHOBSmEQ+LEYpkKHCwQEhVcAHM0/O1e4xWLEkLYb/YaHoNlBzDFqi9JHDStHSW6S03DBY/pSTAq2Kd56hK4xSCUOvIXdL5uNUjSc3u1VJI2dWrwozzp+aWvU8k7F70pwbS7BuoMKlYbGEKN/AvGuV4qwohcUBUzVuvVm5KZzm9HlGqkrQ3ipK4THoLlGvir9bHFE7UAv9VFOZHdypjWl1LzYE6mrSyn6qDWIggia5aaI6RYYWsMZd+v18/3iL5/pMVOXYXLIZJ5+6vvYhErxJPDtLdLnxji8RapkFBJeiJw9PJWqFS1amFEGN9Es9XGxtNZLFxK58+b/pO9CrHJez0r3YQA5Pc0f0d/1ef++UE//33X+KdWCTx/AuLe8bEl7lSYTwod/cXJYUnuFTrUEqfdO4Ee+84eYdHwMugsaC4tw3tCptvcgzJpT60uPDE7MevwOUGsWC9lDVYWkFNmXAvjWBjgStE3XYqAYuUhSisRAyWZ
 E4p5iLrT
 Og0a4ud+j7V+72TClOsEog2x9Gta3zxW99L5zWzm3309pjdfSNPxyK5qcTz3zOGImo7uObeKNyEVbE2g4EdxbxVm/HAHLafiLy+wkTPtjOTX5GFztbM+ixadJ2dqptfy+s1lzFx9JCjbwrIw1liE4+ZKZO1TtrokUPXLJGEcxkdz/REbr2FLfnqZDMjWS9Erhn11WMDLcO1fjlbtbj+ThAiEPiX8Hqdr5adYo/bc79fJkECN+oU8C8Cr0DWHVGNB+z73I/s1FNZw2kEQpsRoOQUQSy0unokbIO3WXutpd9MR+fziHDRFo4xp8tgEPZ3qJsI8fySI7ThqWW/7d6PxXOyxvdnwEV4frzmsniXvZAw9arYf8+nfjDqU+VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 04:02:43PM +0200, David Hildenbrand (Arm) wrote:
> On 9/10/26 15:18, Lorenzo Stoakes (ARM) wrote:
> > Provide a function to abstract the common task of checking whether
> > a VMA is faulted in or not.
> >
> > A VMA or mmap lock must be held when calling this function. For an attached
> > VMA the transitions between unfaulted/faulted state are:
> >
> >        Transition        |              VMA/mmap Lock state
> >  ------------------------|-----------------------------------------------
> >    unfaulted to faulted  | write lock OR read lock + mm->page_table_lock
> >    faulted to unfaulted  | write lock
> >
>
> Still using the faulted/unfaulted terminology above is subotimal but I don't
> mind too much as long as the code is easy to grasp :)

I think this would read terribly as 'anon rmap untracked/anon rmap tracked'
really.

This is why I like fault as a verb here, it is explicitly the event that
changes state, and also as a noun because once faulted, a VMA is faulted
and it's just how I've thought about this for years now :)

I understand, obviously, that VMA_SHARED_BIT mappings can be faulted
unrelatedly but vma_anon_faulted() would then be my preference rather than
abstracting that (yes I know there are some weird edge cases on with that
state too).

But I am compromising on the name :)

However as far as description goes, I think it's far clearer this way.

I'm happy to hear an alternative if you feel something else would be
clearer here though!

>
> > So vma_anon_tracked() never provides a false positive (the lock precludes
> > it), but if only a read lock is held, a negative result must be re-checked
> > with mm->page_table_lock held.
> >
> > Detached VMAs cannot be concurrently manipulated as they are removed from
> > the maple tree so require no guarantees.
> >
> > Use data_race() to silence KCSAN about non-existent data races between
> > concurrent vma->anon_vma read/write on optimistic fault tests.
> >
> > Also while here, const-ify vma_is_attached(), vma_assert_stabilised() and
> > dependants.
> >
> > Finally, update the core VMA merge/split, rmap, mremap, KSM and fault
> > preparation callers which test vma->anon_vma directly to use
> > vma_anon_tracked() instead.
> >
> > Note that the lockless read in reusable_anon_vma() is doing more than
> > checking whether the VMA is faulted - it is returning the anon_vma to be
> > used on fault, so this check is not altered.
> >
> > There is one odd one out - file_backed_vma_is_retractable() - which holds
> > neither a VMA nor mmap lock and is stabilised by the file rmap lock only.
> >
> > Therefore just add a comment to explain why the direct vma->anon_vma check
> > is required.
> >
> > Reported-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
> > Closes: https://lore.kernel.org/all/20260829100034.423064-1-trintaeoitogc@gmail.com/
> > Closes: https://lore.kernel.org/all/20260909115723.528501-1-trintaeoitogc@gmail.com/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> > v2:
> > - Renamed vma_is_faulted() to vma_anon_tracked() as per David.
> >
> > v1:
> > https://lore.kernel.org/r/20260909-vma-is-faulted-v1-1-3a701f48984a@kernel.org
> > ---
>
>
>
> > index dd66c6ad5af1..40669bec953c 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -264,7 +264,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> >  	 * Allow page fault since anon_vma may be not initialized until
> >  	 * the first page fault.
>
> Do we directly want to fix up such comments to not talk about "anon_vma" but
> instead of the abstraction?
>
> Not immediately sure how to rephrase, but I guess the goal would be to avoid the
> term "anon_vma" and least outside of core-rmap/anon_vma code.

I'll do a pass through. Can be a separate commit in the series I guess.

>
> [...]
>
> >  		/* KSM folios don't reach here because of the !anon_vma check */
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 01e7b6b046b6..9f9cd6657360 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -2705,7 +2705,7 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
> >  	if (check_stable_address_space(mm))
> >  		goto unlock;
> >  	for_each_vma(vmi, vma) {
> > -		if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
> > +		if (vma_anon_tracked(vma) && !is_vm_hugetlb_page(vma)) {
> >  			ret = unuse_vma(vma, type);
> >  			if (ret)
> >  				break;
>
> [...]
>
> > +/**
> > + * vma_anon_tracked() - is @vma tracked by an anon_vma?
> > + * @vma: The VMA to be checked.
> > + *
> > + * A VMA or mmap lock must be held.
>
> I would document here what the implication is: if untracked, there cannot be any
> anon folios, if tracked, there might. Some callers of this function (e.g., ksm,
> swapfile) want to know exactly that: could there be any anon folio in there such
> that they have to provess the VMA.

Process?

I'll add some more details to the kdoc.

I do think the name is poor now on reflection, vma_has_anon_rmap() seems
stronger. You OK with that?

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

