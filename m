Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C70E2C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97CEA6B0095; Wed,  9 Sep 2026 13:48:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9548C6B0096; Wed,  9 Sep 2026 13:48:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 890F46B0099; Wed,  9 Sep 2026 13:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6E96B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:48:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 188E41402D3
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:48:40 +0000 (UTC)
X-FDA: 85194958800.27.EEFE4AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6DC788000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:48:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FMIaA5Xz;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788976118;
	b=KR8aRc+7hnupPTjI/LepN7CCJ868QfUZcbhvXnApIHZBbo3iELyMtQMD/j/P4q9vkT0Okb
	F6iPZOq2vsfeSKJ9XnoRWGFRQVaTIiZ/7dc19Y8wBx2IOdSGwsAiPTfgnbBa5fz2vFEh1I
	gRNKa1szKzHkM5DyZHfDFdhgHDNUtyI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FMIaA5Xz;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788976118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KriljTd17afm3LOBC3hK5znRaxV7ItVcfge8hBIqiMo=;
	b=UG32PEz7i6UdYK92lOP0R10WiBHSZEZnk+2a0crdJ2Vf7I1A7ywhh+7ZdTDBk5xH/qOkvI
	jB9+he/UbPxXNngwfyDHF412yQy4AjTBDOIwgq9CjlMSqWAHD1H2RrUB/uVXAeuBtCVZKm
	rS3BF3lR+v/q6AOuAP3X5OGPKadMRcI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C1A941B3E;
	Wed,  9 Sep 2026 17:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584191F000FF;
	Wed,  9 Sep 2026 17:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788976117;
	bh=KriljTd17afm3LOBC3hK5znRaxV7ItVcfge8hBIqiMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FMIaA5Xz91YxejmDwDLpzttZWpqcmSE7rKb3dvPWM58iWfAO4HgZsUGfhudFQjfMS
	 ok48V8Bd+aaZcKBd8EoAVOuIJYqoEjVjHEDSIX86MgCy0STlvB2sNW3nwFbzlM0QbA
	 MpErlGCmldXlqbieiGMjZU7R9vDZl+mANgMp52GV7mT/eUDIRnmlGXf+NJyQgmiLD1
	 8gmQtS4yc3izE7kRWrFAyR+1NVpiuXN9tiHFgIXmmmIEemBVQk7UmdU/ehMwlZCEUD
	 nhPCF+LR/YeYIMcDNgwRR/8Tp+S61wtbNvOvOf2g3NTdYCQVScRYrOU166spTHDnS2
	 bBhl3xNdk82nw==
Date: Wed, 9 Sep 2026 18:48:26 +0100
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
Subject: Re: [PATCH] mm: implement and use vma_is_faulted(), silence KCSAN
Message-ID: <aqGaNT1M-csCCQk0@gremlin>
References: <20260909-vma-is-faulted-v1-1-3a701f48984a@kernel.org>
 <3a261c3e-4c26-41b3-b55f-5800ae1081f3@kernel.org>
 <aqGJx-uQjN8-DEBe@gremlin>
 <c1f21bf2-71e3-4537-a000-fd0e95257759@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1f21bf2-71e3-4537-a000-fd0e95257759@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6DC788000C
X-Rspam-User: 
X-Stat-Signature: wki3q89st6ngnfcbh6rfd1qejqgiio9p
X-HE-Tag: 1788976118-350931
X-HE-Meta: U2FsdGVkX1+wQ1IxUolabL8r0J26NAup7s0CIzOXickYF+m85kmHWb/ve/yAGjsQkNhrkgv5ssSi1zoYCKmPTraNx3FLnNTKzO6RnzGDlyLA0pZlz7Ksv4lnZu1KUAL0/iHReuyExkfbuhHA6Tf2HXONJXY2Kgj3U0CIVXrXwDv7ckuEKxuvCSwehOB3iN64FDJFfCALN0A36gpgsxMz4X16XeupwyMaJVwlL2UsVSQIjngNgjEhv7c9EmGrWwzifPDef2byWMC6LS4Ju4yOeOZgaqDK/8BtDW7kSyn8LAMeV5TMaeGxeQtIB15bY+VaZdWSagUR126Vdgz62LyETcST4EzVwCNdNpVgg/l98vAe53zv78XeLVld/Q7QjVFBUT8DS6Wcsyy2BfZQ2UfguBZBz3vwrEYoFoNowx3U5PIUQfs/bsjOubBpNhYkevfoCqSzs9YHb+KCXLV3leZQbCIY7QZDyzgs4R6QGqtzxZzZhoPH4SWKANtAgnH4ar1C23CF1j2X3xDC6xouvrfebcBmsW7kN3R/bQxUBYVLzsl1zJ0/0lc7dp0GzWiXSyPnY7fS1ZvhGuaCgjBmyzG5vTuF1VMoYDf9TK1/pIxXNe1yIZKKlyEjwihxUjxz4KtQHviBAdm44v0SwQL8yMp+3NZwnFDG0oCMk9C9m3aQBqHx4JUEn87CcZUNSzDPuzRzLytvEsntpC2UG2XkkniIQEarS9bKK+UPnRWa7f9A5PEQt5DH6r18p48a/YjKVY8iIdw+iSiXGezWbVZU+8RvYEEKT5luUrMcuzzn98VRqbmbeL4wHPBm3i3b0HKpjXX8UsDUgz33L1fQKA0Yw3EOn5K2LGAHQzHP2HvqvJf/Zuj5PX2NJd7+pIpmLLQLTiOpxhup+8zmnc3y1i2/0FOyesc+4zRm3lQDJLutOx8z8bCuh+DyBD5mdkoj6FHAzaPPDIVXC4x++JB7NwOr1o0
 Zyxl4/cE
 8XIQScWkvppWlTuyo3KGaCGOXTq2v7XCFDEa98t4i7kHTY6Kj2VgaKUGPuxHE1RyphDIwqRQ70Kkh2U/NBlpBMnShB48KRUZDb8LcC3zQAhJDjr+KEoO7PvK9yFKcEfxn/6yhWCvvshB0e6k4sS2D2wzCFVzSh2I67rpD+2kWkLuI/py3qdgU9qmzuYYtMEZcVbYgTtmddMOqTvzk3KjynuKeLM0jLsOSmxQ8vmDGrnose0fIiZ86MP4M+kEnyJqcUDu60dW6Ix4OiBs3nEP025IfOOdYOVVz0LTF4ZKpeK6vPev71uVQO9anywlBYrfHqu1zeE1OxhjUdab0aJytN6nPNBONDfthFJVi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 07:32:57PM +0200, David Hildenbrand (Arm) wrote:
> On 9/9/26 18:36, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Sep 09, 2026 at 06:24:52PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/9/26 18:14, Lorenzo Stoakes (ARM) wrote:
> >>> Provide a function to abstract the common task of checking whether
> >>> a VMA is faulted in or not.
> >>>
> >>> A VMA or mmap lock must be held when calling this function. For an attached
> >>> VMA the transitions between unfaulted/faulted state are:
> >>>
> >>>        Transition        |              VMA/mmap Lock state
> >>>  ------------------------|-----------------------------------------------
> >>>    unfaulted to faulted  | write lock OR read lock + mm->page_table_lock
> >>>    faulted to unfaulted  | write lock
> >>>
> >>> So vma_is_faulted() never provides a false positive (the lock precludes
> >>> it), but if only a read lock is held, a negative result must be re-checked
> >>> with mm->page_table_lock held.
> >>>
> >>> Detached VMAs cannot be concurrently manipulated as they are removed from
> >>> the maple tree so require no guarantees.
> >>>
> >>> Use data_race() to silence KCSAN about non-existent data races between
> >>> concurrent vma->anon_vma read/write on optimistic fault tests.
> >>>
> >>> Also while here, const-ify vma_is_attached(), vma_assert_stabilised() and
> >>> dependants.
> >>>
> >>> Finally, update the core VMA merge/split, rmap, mremap, KSM and fault
> >>> preparation callers which test vma->anon_vma directly to use
> >>> vma_is_faulted() instead.
> >>>
> >>> Note that the lockless read in reusable_anon_vma() is doing more than
> >>> checking whether the VMA is faulted - it is returning the anon_vma to be
> >>> used on fault, so this check is not altered.
> >>>
> >>> There is one odd one out - file_backed_vma_is_retractable() - which holds
> >>> neither a VMA nor mmap lock and is stabilised by the file rmap lock only.
> >>>
> >>> Therefore just add a comment to explain why the direct vma->anon_vma check
> >>> is required.
> >>>
> >>> Reported-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
> >>> Closes: https://lore.kernel.org/all/20260829100034.423064-1-trintaeoitogc@gmail.com/
> >>> Closes: https://lore.kernel.org/all/20260909115723.528501-1-trintaeoitogc@gmail.com/
> >>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >>> ---
> >>
> >>
> >> Is vma_is_faulted() really the right thing to use when wanting to say that we
> >> (likely) faulted in an anon page?
> >>
> >> I think that's highly confusing, considering just MAP_SHARED mappings where that
> >> will never be true.
> >
> > Hmm, yeah.
> >
> > I mean there's nowhere you'd do this check where you weren't checking something
> > that couldn't at least in theory be anon-faulted. But it's confusing vs. shared
> > you're right.
> >
> > vma_is_anon_faulted()?
>
> Hm, not sure.
>
> 	vma_had_anon_fault()
>
> Might sound better.

vma_anon_faulted()

>
> Alternatively:
>
> 	vma_has_anon_vma()
>
> is the obvious thing we're checking.

No, I want to abstract the mechanism (so later it can be replaced :)

>
> 	vma_might_have_anon_folios()
>
> would be the clearest (no anon_vma -> no anon folios). But semantically that's
> likely not what you want to check in the code?

That kind of implies you want to interact with those and generally you're asking
whether an anon fault has occurred.

Also a bit of a mouthful.

>
>
> The whole faulted/unfaulted terminology is a bit confusing ...

To me not really?

Actually how about:

vma_anon_rmap_tracked()?

Then it speaks to what anon_vma is actually for, the fact the VMA has an
anon_vma assigned like that means it is tracked by the anon_vma, and it
abstracts the actual mechanism?

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

