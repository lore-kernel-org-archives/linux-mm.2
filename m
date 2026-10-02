Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 035F9CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 18:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38BE6B0092; Fri,  2 Oct 2026 14:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10196B0093; Fri,  2 Oct 2026 14:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D976B0095; Fri,  2 Oct 2026 14:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9D076B0092
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:12:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 509501407B1
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:12:51 +0000 (UTC)
X-FDA: 85278482142.28.AE5AFB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9D9BC20002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:12:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V0REfLB+;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790964769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8XGruUG1q9NlQK3HfsezWI4sNwg1U3GmGD0QRbensM=;
	b=StRcEhUJJjg+u/BN08Bw91PVNo7/iupYzTDkLhBqdlVQQ2TbeDM6T0mkGG5YLAGUaZ6AoU
	rR1bXx07K6SMcD1Q1klsS8OqmbbdrOv+D8knNBpGPNx//LaH95x6TBC05AkDDo/bdjjQkq
	72THDPaJHll8KaTR6vd0N0AyEikh03s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V0REfLB+;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790964769;
	b=J2C1STVhaoBgH1B3SHjOGPWD71WWJkI99hIKQc3ZsURnQH0yKoXgrIFL2Tw4S168lARwDd
	lkjz0ac45ZOjsxdhvExVRRoPfAe0Mrk9ZE07lU/9uUkTNcAkaYUqfBrpHYeHZScwy866f6
	dO/Wm3O2NsoFYS2OVPok5T4gAHRaqb0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D5A84025C;
	Fri,  2 Oct 2026 18:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C070F1F000FF;
	Fri,  2 Oct 2026 18:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790964768;
	bh=g8XGruUG1q9NlQK3HfsezWI4sNwg1U3GmGD0QRbensM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V0REfLB+j9fthMzAGcutHRNmRjr4fXKGl1aG9r8XK0w+Vy31R2L9pIYOOWtSZBw3U
	 7qyfwbDD83FmvTuz/gfIb24vWYjIoi/zze2L5JgCYcUWmqce1xusyI7j5+nqBM+MjO
	 27DBo08CWDgdEvumIyd2DotOo5ve2+0IFdtN0jqI5CGjcyLBNLz/3AZRwe7WVDsF2+
	 OldX0GA0jKKM+8yhQ8cXETn3mQMG47JK/JjJ2Y+VWgt70E9FZp7zqmkM8202/EeQot
	 H5P/0nnTUDfDsBZfsNIws2Csfz0zHJOh9GPJm2AmOCw1tlEl4vfgYkJLZPYoZl6IZE
	 j20D1JesWAFYQ==
Date: Fri, 2 Oct 2026 20:12:40 +0200
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
Message-ID: <ar_0GLYM6KsIH6tQ@kernel.org>
References: <20260929053231.66085-1-songmuchun@bytedance.com>
 <20260929053231.66085-7-songmuchun@bytedance.com>
 <ar5xbQsUpSQZg0wO@kernel.org>
 <78D5D6AA-BE36-432C-B0F7-453F93DF18C0@linux.dev>
 <ar9p39Y9SmlxvbA_@kernel.org>
 <85941AA4-7E50-4AAE-BC05-0F443B21BE8B@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <85941AA4-7E50-4AAE-BC05-0F443B21BE8B@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D9BC20002
X-Stat-Signature: 6swxxk7o3yow9ugxdxuwbti7sye5ajwt
X-HE-Tag: 1790964769-281998
X-HE-Meta: U2FsdGVkX1/eCnwwBHo/wtmctMIjT6zUITMrx2+pnOlX7BARESqQuRpYyZYOGaN3t0l6smjQhTJWJnTPFhEBZZ0PkTFSpHXAKiT6roqbrNqSZB/xBg9pJWj2XzvxryqTktxeTwFIxYdDBcVQMfPCslqOvsdaytpYD97YTO9CXcKEIfD5FMjD4AVdEXfIlkoCPU6vUIYeNRyAGHHTWIgjn4Cphg6yFHjfd3xc3+g89ft6YsuY8R2pPPgalgTDOQWgpyp78QY9JG5K/eIoleAcausp7BZqG9rlNmHNUk9xTvVA/9lEpqi0lAcjnLiyp6JUFDS6FXbTGv32/K8NlYghvMj7FCfIYT3yI8qEUaNwH21ZUNBsLk3zUcFcrvDK8v6RPUt5FE9JP52+VYdr40mYf+XE043wWRkynwsuRUxXsAm9JrmHZc8+kNQe/IIbCvySD5P+jI2hbgkuljVY8FQc+7bYbxBY1RNqX91ltX7Jc263aIjaDzGyFxyHj1sYl79vMJS2sx4Bm72GyijrrFlQPgv7A71msvgZQHa93ZGSSqDv+CRiF/jgu/WEKX5m4dHDCXrGx+qYRIMkAfaQuzYS47qgJ0I1yy4MpXueRfvplPdkdjyxWT/v0p4Wuwjf79KJ/MHw9J27nCmgWGmF+ZmiYUFvlRBfP6B1ZXcHgAAb8X/4QIIstbYZsDLKDV2w3K5jmkLzVklfOcKzcSF092MY4b+CXeJG/dxIwCsFxvKU9lC8fsqLE7PQmn+dfria3mZvsLey37N1YDQTijD+MrJP9xQz/Dd4lTim/CjZrK+oRe6IH2uVftidQmFPevuMGau2aRATwtlUI5PKGcujLQ/SJQ/lx6PSr8AeZ9ku/Yuvt5m8egwDV5hEZuwAm8tlycXaX3sA3FxTXluJIQlpOaYIPPQSl7GPzv6/xUPBDaS7HYKRvwaF2D4FOYFCw7J9UOaUrCwOdKtEkqXoIZUKbAJ
 fLFHfwK/
 2ISsvwWCCxQUrYbU9ehEH5FVzfS3OYEDw4qVyc2rbksbnKoWoOnloLRq7xiWh7FRre83S0Ti72cQEBhG14jMuhOss3qo4z5eGxL+CG9GUllXD81+lyWZaZIbk5r8dEAFLcEaU9Mte7e7PysZNyJpb7FEb7Tf3fd9HUS5x+BCRzYYpmaliIOTuzZlEMvc2IgdqlWZjfs2UQ9loGG/+e90eoPM9f3wzfAlpjgXtFOqUhauyCb47xiSIhu/9P/+kqa2qDmIvSJ1xz1fWOPpZxNJmPFe5TPXg93Ork5zcoBKLPiqysW+DhU6rGr5p9unzqr1LTVj/ru0U3zbQmfHVESA0GENVairZcZ7GBT10jbaC7ea1+E/Z9HLrx3L5p9Js5uMj8ME9jLhlNLBPNUg9AIofCNiH1xI79T+elht35Y4BLJjT9ZH7S7hHst+xPhDfDhgFpsDLySOkI7DMU/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 05:56:40PM +0800, Muchun Song wrote:
> > On Oct 2, 2026, at 16:22, Mike Rapoport <rppt@kernel.org> wrote:
>
> >>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
> >>>> index 1650d6bc1211..bd02e8d06965 100644
> >>>> --- a/mm/mm_init.c
> >>>> +++ b/mm/mm_init.c
> >>>> @@ -609,6 +609,9 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
> >>>> if (!is_highmem_idx(zone))
> >>>> set_page_address(page, __va(pfn << PAGE_SHIFT));
> >>>> #endif
> >>>> + VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)) &&
> >>>> + page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
> >>>> + page_zone_id(page));
> >>> 
> >>> Hmm, page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES is initialized a tad later
> >>> than page so it'll have stale data in the page->flags, won't it?
> >> 
> >> Lance is right. The shared tail struct pages are already initialized by
> >> vmemmap_shared_tail_page() during vmemmap population, so they're not stale.
> >> The head 64 struct pages are initialized later — right here, after vmemmap
> >> population.
> > 
> > Still it looks out of place here, can this check be done in sparse-vmemmap
> > somehow?
> 
> The struct page entries of a vmemmap-optimizable compound page
> are currently initialized in two stages. During vmemmap
> population, the shared tail entries are initialized first. The
> retained head area—normally 64—is initialized later through
> __init_single_page().
> 
> This warning connects the two stages: while initializing the
> retained entries in the second stage, it verifies that their zone
> information is consistent with the shared entries initialized in
> the first stage. Therefore, the same check cannot be performed
> during vmemmap population.
> 
> I am planning to first unify the HugeTLB and Device DAX
> compound-page initialization through a common helper [1]. Once that
> work is complete, maybe it will be easy to move the initialization
> of the retained head area into vmemmap population. With both the
> retained and shared entries initialized in the same stage, there
> will be no cross-stage inconsistency to check, and this warning
> can be removed.
> 
> Would keeping the check here for now and removing it as part of
> that follow-up sound reasonable to you?

While it feels really out of place in __init_single_page(), but having it
memmap_init_range() close to the if that skips shared tail pages makes
sense.

What do you say?
 
> [1] https://lore.kernel.org/20260513132044.41690-18-songmuchun@bytedance.com/
> 
> Thanks,
> Muchun

-- 
Sincerely yours,
Mike.

