Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4130C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD58A6B00AD; Mon, 10 Aug 2026 10:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BADC06B00AF; Mon, 10 Aug 2026 10:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9836B00B0; Mon, 10 Aug 2026 10:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5D36B00AD
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:49:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CFAFA18B4
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:49:54 +0000 (UTC)
X-FDA: 85085644308.12.64E1639
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8369440003
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:49:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DDLV4D5/";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786373392;
	b=jO/gwv0cXElxOwVsJC5GACw6nsbf9qe3mSw3eFmNFhyxqVVu3UQ4chBMW2r4pjGdpIHS0x
	fdG8zEH4eULjPl08Enl9XilZkNQ4a1iNM+KYjiJX6lrMf3tSH9j6sPJnZaxw/WZEilHkyp
	OK2Nqb2TZlCabU081ApNeSkbiwjehh0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DDLV4D5/";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786373392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqYTIOcwqT/VZ1KRSURFM6UpmMmApXfR18VlY6eRteM=;
	b=Re7FNOrIXzRiOPdn1edP/MCwZkHJn4N7BAS83cYKfziB6t7rILNz9BoDHXfq+lJqUy38Vh
	GR69hWy0+ro+92GBIrx2QuF0mEzoBtq3BZI26lDdglhJcirZpvjJ4G78qLBNXlxqC89mL7
	bBZjBt70V34yctmUtMS3+usxjO5LCqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CC7B60052;
	Mon, 10 Aug 2026 14:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191DD1F00A3A;
	Mon, 10 Aug 2026 14:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786373391;
	bh=nqYTIOcwqT/VZ1KRSURFM6UpmMmApXfR18VlY6eRteM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DDLV4D5/0yK0WFGvOUluF97774da12v0+sqtcBQtZhbJ3o4r6J8hF/tAL8NFofbbJ
	 0djPxejLipzE+eFd0GVPXFTSvklTL/YNBrlVi4XO0G7an7/exzzdhNV3B9yZpjsi5J
	 1YEkLvI5WSws0ul3BkoIXrK4efY3JtJmp64/g2vgm2U2HOqw28AaVNGrHUJ6TOb+uT
	 y/XotPFBWsmDTLLf9jaT2SQEC+QCJTPAhY3JWEa1/QcX/um2ao6xSjJ/bTlDTJwSYO
	 W+SpTdW15okBdJdOK6VjCi2LqEVbx9xrwF6+c/yzZESkjT1xV3GwPPF78wtNtkjqow
	 7X8pjtsjQXZKg==
Date: Mon, 10 Aug 2026 15:49:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm/page_io: use swap entries directly in zeromap
 helpers
Message-ID: <annizMfrtB64wMCW@lucifer>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-3-0899bac3b826@columbia.edu>
 <annJiayAzNA7kA6O@lucifer>
 <bc25141c-753a-4280-83fd-a7e2e2a2db6d@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc25141c-753a-4280-83fd-a7e2e2a2db6d@columbia.edu>
X-Rspamd-Queue-Id: 8369440003
X-Stat-Signature: fbd3u4yh39x434iw99r7q9esom7n49kc
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786373392-707069
X-HE-Meta: U2FsdGVkX1/mgAp4GtfgeXuxvvOft6mEyOHMUbUq9t6ulBZD3PniMvgBBed2zIDW1D3ZxBX4RJRi0SDSrPR9oGwdxMMxexxn/ySOAHaaPCdRGNd1rsF7wTB+8M8F4CNTQpOZQhyuAtcANXElk9ebLLVNYa6+zNGtzQNczGsbtU6HL+MuNFY/J8s5SJytMheYFG10dZm95BnkCSkiJAQmuQ4mqnBZdd6qMrZTXvFkp8wwZuL4MFScggXl6jG4UuXQJd2ZZWCpDPF7IbohqKMrpr5MUu8zfWTdSYaEegQCSlHXvMPEHMt0Hx+jHw5Q5jpEyvhVPfzhkMVcB292UWIxyCx12e05aRHwLQuz2sZQfKbg0HiyFFdu5QKU+QjHXZ9+adysFauLCzx7i9UoDmqRnSzzKY7lkIIq/DYUSqRlrWoEa72pqW1vm/DIn2wcert5lszQd40mBkXAeWka1lawQ5n5r6uHGeqk6gxVjMrqR3djMk1hwu+k5kD7H8R5+VZg4BMYiyH2nZopMQ1ZeiiI/eE3CwDwHCV6fRUJPiuguTIpJkuSjK2jO7D3A0s18gxsJ3/tl3JOz2FkzHfY4OxNoBJgu4PwQBWABsYR8KviKxL/HeG2ptp2LggxeWTgHWQnqB/0PihhKQzVOfh89/g2/Jwmx38lSZR6h0L77mnlyMLuYCHzvL6ofLRD2lPwq4RMypy3G0luYQ4Ks7MqO9a1diluwon2dudt0sj35zCoYQu3eDLy8cFpnchJ7KF1Rl9yOLMN6Z5e/NHVztzteQka5GwfNBYLykdDNRKkFdSs+kcxUkRuSUM7rrF267WpT3CdTPT/QFfgFoZ458p8tHgMFusV6qoRosVEPWnQcyCMR3DSCmIaj4l1Rok8L/V522kqsXdhLaAiM7ZjTynPSpAPkJSfOw2VrwQgr0lWJODx7qGuk+fd1Jx1+3NJ+wLYVXJ9Ue6xs6gelbE+pHrvPbS
 ql0Ora7W
 +uHuaPXV5y2lzRyfE+nscYjRyji5Dwncrg4u1+4Q5/VAoxBHJ8dpitOznsDdslBE0fy0P3tuubHDodXBXKpW0vLNp6s/wP8SEBx5wyrkl6gzr1N7EFx8KlINfwhTgpNYWWhNFXuH3a7f9SKnW80zKzFFXiJUYrVc1gr87OP7nX+urNP1GuBCxtui0J4ga36Cxq8wmHySTaQwt/dOWGx7qHuRDFWmh6GxjlzP61scpGbc1S0C3Tz1tizTvEYGzQ7kUsDoPgTFZ5aGD5cXpVRH4qJgEsG2QPjvJFFb3hcPsAeqneccWLh8dSEJfrhlQTUWS1cwZ592+zcb0M2p+2ou0TpyvQoRwHK5sRJQ/h/BcOm5HY9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 04:14:45PM +0300, Tal Zussman wrote:
> On 8/10/26 8:55 AM, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Aug 06, 2026 at 06:55:35PM -0400, Tal Zussman wrote:
> >> Increment swp_entry_t::val directly instead of recomputing each entry
> >> with page_swap_entry(). This removes the last struct page usage in
> >> page_io.c and saves one call to compound_head() per page.
> >>
> >> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> >
> > Lord I just looked at page_swap_entry() and... yeah. This is an improvement
> > thanks :)
> >
> > I haven't looked at the rest of the series so maybe you already did it but I
> > wonder if we could remove it altogether?
> >
>
> Indeed we can - I have ~7 more patches which do exactly that, but they're more
> wide-ranging (rmap, zswap, huge_memory, swapfile, arm64 MTE), so I kept them
> separate from this.
>
> I believe Andrew is planning to pick this up post-rc1, so I'll probably send
> them out then since they rely on some of these changes.

Cool. Never fear the churn, as long as it's achieving things that have good RoI
(this definitely does) then we're all good ;)

And yeah probably best to send rest at 7.3-rc1 to queue up for 7.4. We're trying
to gradually keep the merge window vaguely sane-ish :)

>
> > Should we rename page_io.c to folio_io.c now? :P
> >
> > Anyway LGTM so:
> >
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
>
> Thanks!
>
> >> ---
> >>  mm/page_io.c | 8 ++++----
> >>  1 file changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/mm/page_io.c b/mm/page_io.c
> >> index 43b4383a4729..c6d0949b3f1e 100644
> >> --- a/mm/page_io.c
> >> +++ b/mm/page_io.c
> >> @@ -159,7 +159,7 @@ static void swap_zeromap_folio_set(struct folio *folio)
> >>  	struct obj_cgroup *objcg = get_obj_cgroup_from_folio(folio);
> >>  	int nr_pages = folio_nr_pages(folio);
> >>  	struct swap_cluster_info *ci;
> >> -	swp_entry_t entry;
> >> +	swp_entry_t entry = folio->swap;
> >>  	unsigned int i;
> >>
> >>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
> >> @@ -167,8 +167,8 @@ static void swap_zeromap_folio_set(struct folio *folio)
> >>
> >>  	ci = swap_cluster_get_and_lock(folio);
> >>  	for (i = 0; i < folio_nr_pages(folio); i++) {
> >> -		entry = page_swap_entry(folio_page(folio, i));
> >>  		__swap_table_set_zero(ci, swp_cluster_offset(entry));
> >> +		entry.val++;
> >>  	}
> >>  	swap_cluster_unlock(ci);
> >>
> >> @@ -182,7 +182,7 @@ static void swap_zeromap_folio_set(struct folio *folio)
> >>  static void swap_zeromap_folio_clear(struct folio *folio)
> >>  {
> >>  	struct swap_cluster_info *ci;
> >> -	swp_entry_t entry;
> >> +	swp_entry_t entry = folio->swap;
> >>  	unsigned int i;
> >>
> >>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
> >> @@ -190,8 +190,8 @@ static void swap_zeromap_folio_clear(struct folio *folio)
> >>
> >>  	ci = swap_cluster_get_and_lock(folio);
> >>  	for (i = 0; i < folio_nr_pages(folio); i++) {
> >> -		entry = page_swap_entry(folio_page(folio, i));
> >>  		__swap_table_clear_zero(ci, swp_cluster_offset(entry));
> >> +		entry.val++;
> >>  	}
> >>  	swap_cluster_unlock(ci);
> >>  }
> >>
> >> --
> >> 2.39.5
> >>
> >
> > --
> > Cheers, Lorenzo
> >
>

--
Cheers, Lorenzo

