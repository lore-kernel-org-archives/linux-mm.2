Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C7D3C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218026B008C; Wed,  9 Sep 2026 12:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C82B6B0093; Wed,  9 Sep 2026 12:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7686B0095; Wed,  9 Sep 2026 12:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA4D26B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:36:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30F3C16028D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:36:48 +0000 (UTC)
X-FDA: 85194777696.30.2C86FFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8086F120008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:36:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oBKesYFn;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788971806;
	b=3YjNx8CI+tjHgZUlc98mME9xy4eds+3MylHoj7G11YFZxw7dClTNdMsdw6uvlGYZ738NXc
	uat9eXMImpKtvRvM52AWEKHZTj5oAMAn+2GH17HKG3e4lBxtmRRHW9jsO+d3au4HvdIxB+
	ue1pY3vxc4PMu9VQNQGXokumUdX+Gq8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oBKesYFn;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788971806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VP//58Wn8k2qcOTJ9qxFhG0WtvAq1P5Aq/CZfspgCd4=;
	b=db6Hl9UBeXE8DV2+CSfht8wlDK67+D479Nf+BYDssTwZahhFDq3UdT7pZrPnGvGLWkmmvu
	6A6tBBrDsWZ8MmXnC1JutKnyHO85oqwvaoCr1pNReh8P6NDOz3FP5883cREv6yc/6KrOb/
	dsAsHO5of0xAMrEw4MPwPWGVwK8mjeI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6586B42307;
	Wed,  9 Sep 2026 16:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3F31F000FF;
	Wed,  9 Sep 2026 16:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788971805;
	bh=VP//58Wn8k2qcOTJ9qxFhG0WtvAq1P5Aq/CZfspgCd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oBKesYFnWiOL6rtCA1WvhldX565pHoDow6cst5O+yiMJV8riZzIgENxvieESVooHj
	 9uMYjfMx9fCGNW+BWfKgL3GFDiiKJbSTmDPwkfvB/kwVg+OII+EN7eKID2LqBJptbD
	 Ry5keUUsOTMZ4CUaw9ebSqpsZRULbOse7VVROGG2UZP2AGoKSvWDgoh6QKUb1MzGQI
	 Pg00ASMSf3TbwzPBbeGqpzKbY9lOurMrc9ZfoPdnkRwn71wsI2xaFsWejZQy3UDtdJ
	 5DUoLtwEVttzeKCuqBW5+mc0gP6U3G6Ok8ram3hl+LQhgAiMoex5zhuV8FZJVDFaop
	 NpDwRU0SpznOw==
Date: Wed, 9 Sep 2026 17:36:34 +0100
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
Message-ID: <aqGJx-uQjN8-DEBe@gremlin>
References: <20260909-vma-is-faulted-v1-1-3a701f48984a@kernel.org>
 <3a261c3e-4c26-41b3-b55f-5800ae1081f3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a261c3e-4c26-41b3-b55f-5800ae1081f3@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8086F120008
X-Stat-Signature: mhhc7qjrw75ktzua4xshk19k7wfqn1du
X-Rspam-User: 
X-HE-Tag: 1788971806-980511
X-HE-Meta: U2FsdGVkX1+u9LDUn8GXzapyKrjx63rbSoI6ZiOEKm57TgSRqA6gAQVHsPC6pCQSmi6+Zhk93Ev63xEZTqamOqlg86SBj6rMnBNjpCn2SNNhcybwDPPkZMNDhqmzikzpt11ZPemh+/sGNtc8KC/Q7t5JkFYrCN58rJorwEVuLSjbeN73SSRB+fukwaTOYGrPMgD9vnEMmdR473FrrzyKBmvoxsFsRiqNFuKFFM4tyn4KM2Q9lPnmuLbihJB/bnzoPsgpN0GdsrWkNwoxqzSAgu8nDqynWhWvuv+kE8U2Duh0hmjGPx/YvAY2URaMvdJlFrfMKBn2ut6eSh3Hk9A3H/PEd9oDQoQV6iU+YF+9Jo8AdBGPW2AAvJwaD4IiD4YkxXWAFWhUkvIOLXbucpj8C7QBM/zZucbKTOaM+LOx8lK8fPRmC6B8O47OQv/b/iagX20sIOlHqoG/VJyRq5TvnzRdvN4BsvyYcMICRaTRx6c+Q68GMw4bdkk+wLe/nxo6D5RRk3OsvIIkTHKRq39EqubzQW0g717gPe9N4T40sXtxk8hoYXbx+6P7MrclwlOlDWoSwhPKaQ525sYVE/vbRB5WktMM3YsLNQCYjBHMPm7L3c1dR93DlBQR/ZmMtANPsCA5ijo6XcwTH9Ofv76gb5oU7KbJjL1MQ0K4aMNuO7/oWLTQ8rtBoKLmtgQpweUnur+Y6Td+NzO5QugQ65+ljhh9Q2W3Z55q6gpGqzNlXNIsrRrTryRWDChjj9R7v6Svz7HvJNQPjBgMsSp22NyqOsvqjR1ElE8VPpWIkfH27L0I6+ACbMzER50KzSqByuOlNNB6N9qyb8y4ib1e320R6ML3b+Q/wTWMD1xzbz84JKcXY5xR24qgw0Pvsk++7HgOAhHWHe/NoNfSN23jKY30QkwdnXW1eaQmYNSqrV/42AAYqO/8OKcJ4yWtyMwTaCU++cdbiEhy+SA/f2YPLb+
 oxKFf9a3
 Y1Pm/ADmd8I4MrBJRWDodErquFjO8FecyKYyAOlCkYGpCmEbflWXN32CyXN5jw1iv0YGXK2+YPcQ88AA92PMrQdDP0MeBdXUQatsTtCjaoi/kjU34VCHWmmaT1LeGBhQOdQkrm5nIZt2A/y9rZG0kvzmJP9zayqgS4DFD594kKNQNG88RerEhT2j+mwxm30hbKkDYA1qPP5Sh8ytDyQVBEPHtGht2NtvbYrkPHc1LQYl+4QB8xufj8DDxpXaSdnPc7PlhhUpMT7djoPZXkt1T20byYMzYYbYp8jImHo3xTNKb8uOurzMn9ETqgUnFdVQ4xZXjevDABFy5Fvym67d59PC1E7SzLgM7Fqkj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 06:24:52PM +0200, David Hildenbrand (Arm) wrote:
> On 9/9/26 18:14, Lorenzo Stoakes (ARM) wrote:
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
> > So vma_is_faulted() never provides a false positive (the lock precludes
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
> > vma_is_faulted() instead.
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
>
>
> Is vma_is_faulted() really the right thing to use when wanting to say that we
> (likely) faulted in an anon page?
>
> I think that's highly confusing, considering just MAP_SHARED mappings where that
> will never be true.

Hmm, yeah.

I mean there's nowhere you'd do this check where you weren't checking something
that couldn't at least in theory be anon-faulted. But it's confusing vs. shared
you're right.

vma_is_anon_faulted()?

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

