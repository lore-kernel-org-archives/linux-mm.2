Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF9C60716C5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 17:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kcTvm6uM
Received: by kanga.kvack.org (Postfix)
	id 45EE46B05B2; Mon,  2 Nov 2026 12:57:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435936B05B3; Mon,  2 Nov 2026 12:57:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3791C6B05B4; Mon,  2 Nov 2026 12:57:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1402C6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:57:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A6285801DB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:57:30 +0000 (UTC)
X-FDA: 85390936260.18.C3B0F30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0DC3E2000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:57:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kcTvm6uM;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793642249;
	b=Cvu3eViQJQyu8AIHDbHEI6TzgyI6xCQfreMVZwJqs9H01eNWAuvPp/UpLWfVj8+aAfjBjx
	AIzaPDwD8v9NNQf+0FsqH330cgQfjT2B77j4sQe9On20UBsaFsZiOP8eGhmL+kIg8JlZB9
	dEwm9dgSU2UR3Aa8d4EeFLP2DQmomyc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793642249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yN/enZfckxR/KaazQYI51lP72amm4JJmcuC6uTU2Oc=;
	b=Y6N5yfdk1znDyKZGtETbAzolermI2j3PQTkbFT+obPS1qfHeyDnchW3aG+tUkXsuz7D2ym
	7U2dzF7vMuKtedpbdmLfN+p0pSCwpQiBytIYEOqVFhNjtrRrJR1mqW15zAp/6hMviU0euw
	NkmpEHyArRdzQZXt7Q49JhVq0I7tirk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kcTvm6uM;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47F7160A74;
	Mon,  2 Nov 2026 17:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8930A1F00A17;
	Mon,  2 Nov 2026 17:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793642248;
	bh=9yN/enZfckxR/KaazQYI51lP72amm4JJmcuC6uTU2Oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kcTvm6uM4hHl2o6FdFgVY6v1NyTLeSRetQGO03jcOBvMddtdOrpST+IL4s6+Mfei9
	 NUkBnNxXuuxm07FIDtdNtX6ChQD/D2dIXexIESLJj/2rTuQLyCUS6gcbKPrAXDmAh+
	 bV24zqnSVUYA++RkUpi9jHHSqKou5w3csFuVevqeHe3fRimZ0pAn16cDVm0WKXqNRv
	 6KMyl12KfzdzrSgbMlECNk96GQn4rF4B6OHq/pUthlAr9Kvyh/sGYUr879prMdwXe/
	 8h0vD+0jvfMJz4YsePT7byIsb2bBayxtQqiIGXSOyKkNwSDCl4c+wZ9rWQBR47MON0
	 9Dbr8e2uoTmRw==
Date: Mon, 2 Nov 2026 19:57:20 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/12] mm: hugetlb_vmemmap: generalize vmemmap page
 allocation
Message-ID: <aujPACLfTbPJnIJa@kernel.org>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-5-songmuchun@bytedance.com>
 <179361471104.1337633.3959715900505206111.b4-review@b4>
 <09EF0F81-23CA-4F3C-BA0E-41F34A0AA4B2@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <09EF0F81-23CA-4F3C-BA0E-41F34A0AA4B2@linux.dev>
X-Stat-Signature: n9m9yhsycyzomeht1nmfa4jkh7dbku3c
X-Rspam-User:
X-Rspamd-Queue-Id: 0DC3E2000A
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793642248-744489
X-HE-Meta: U2FsdGVkX1+vtcyp/3BeQB+UMCGYywcnpXZb5KGfJBIF1pBR87piWdKgpsk056vBDQfcQt4U39EqfCXcjdHIqzrB1jj+s4fC5wSblsbQ3YuzR0WYPbjW99vEwMLogO6YugeY3Rh2JW/pAhn4i3HexBy1fTzGtJmuaTxjGsbXqf3u0QlILvcAd3EPsL8XtkTzDVd7vdsZh8a44BAD7gghSta1oOn+km9MbL/G0Zo+X/HGbrWwFMdzW8+8yy62JmU+r9Xn/6Uixi/MsBzs4FZHzSZXtN3i3HWfJDi1+Mtf7RcwguuNmKass4qGflWd9JaHaIwhkY2kD9kMfmJ/J6e3qZpG0QaqO+Cp5tWT9fQGnpoWoIm2Vq9s3aV48HYaZt/BVm7ADr+gMC0LFuVfdW30vFe1vh1CTKLNUjL5Cr6LVaw4W/qYJ/BGI8ZHIUCXU6mnbbuJKGwBI3UM6nxT2RlpnfGkGEbZjnukPYWeHKcFkn+3KS0y0GBMAGItbMD+yuYtAZtLgEGR7hjaG3MVUNIimhE+zM+NLhA53BNEL+C5OBm695qwK5nSdBwzxNzuyhrK9g92lbh8vZLjUr9DGgpPMfJmpgq0lBusUSsbcm3w1U1McVyaawPUFsVtLGwyyHnLWmtHr50Mv/dmoNApJZViy+byM5uwk9eKiQWNlEuvr35Qm9Pxd/oSc3jL2jg106BgB5SraolcCW3xdddEbqzLPEaXb/1JvLgrQ9XrtmjAWezpM+DLeYkMmDAQ5DaMlZjL3R31AkodyNEkkpjB1l4H3ObJzDavtdjcOihybzLQvgyAirlUAd5JBf101Oqszyd3zBSfnk+QYQ2B6un9EO2cQEzqol90a3qSF4yI5sdzJCnvMi4/2wibJvYIPiGTY6j353IDsbt4IIUj2+4aQYdDgyRBj4N4rqvw+5vJRjNNQH+D5z8QbKaPuY/tMd/w5OHChBtz96ozzmdd0QTLkH3
 wYNjIFNI
 HdYEY7xqkaQDTtsYrHVkDnOxY9HOGiDVvR5/GAfXGwko822Gf9xpdBrCZYr4Pp03yaTbKVrC12ZMR7eWLTjLH/cSRacDU7RVb8QR0ogekzsF2jo5ykr1B53V+oSMFEE99wcEgrjnzHaXp+X1+/kvUNXlIrZ2EKXwZbL43tftiXIEUnpXEvp60EX70/6OHkOSBha8r7fCKeH/0pA8onjhiYZV5lB2gvA+b2v3i6naOI4PmRBIB4dGpCwi3rlrvxR4HatpotjdjCjMpXJe4H6/iVuuPuPBvqIr7loijpPHJnx4GSH+/Qf1QIT2X/Ziwm3kTq4UojHnWbjNFcGBSa1/qV6R0nGCkUVhAxBNi8ETa4Tw2B+Pi2P4qB5HQK3v3yBLFAcUdEVlmtg0ZTz0D5zCCzn+Z+Id4KjXh9UaeY7aLTU7Yre4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 08:34:03PM +0800, Muchun Song wrote:
> > On Nov 2, 2026, at 18:18, Mike Rapoport <rppt@kernel.org> wrote:
> > 
> > Hi Muchun,
> 
> Hi,
> 
> It's my email client's fault. Let me email it again.

Things happen :)

> >> Vmemmap page allocation is currently tied to restoring a virtual range
> >> and assumes an empty destination list.  These constraints prevent it from
> >> being reused when pages are requested independently of a vmemmap range or
> >> appended to an existing list.
> >> 
> >> Generalize the allocator and give it an all-or-nothing list contract so
> >> the restore and optimization paths can share the same allocation policy.
> >> This also allows HVO head-page allocation to fail gracefully under memory
> >> pressure without triggering the OOM killer.
> >> 
> >> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> >> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> >> ---
> >> v2:
> >> - Collect Reviewed-by from Lance Yang and Qi Zheng
> >> ---
> >> mm/hugetlb_vmemmap.c | 39 ++++++++++++++++++---------------------
> >> 1 file changed, 18 insertions(+), 21 deletions(-)
> >> 
> >> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> >> index 0e5b2b182d1bf..4b20a8efc0678 100644
> >> --- a/mm/hugetlb_vmemmap.c
> >> +++ b/mm/hugetlb_vmemmap.c
> >> @@ -334,28 +334,26 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
> >> return ret;
> >> }
> >> 
> >> -static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
> >> -				    struct list_head *list)
> >> +static int alloc_vmemmap_page_list(struct list_head *head, unsigned int nr_pages,
> >> +				    int nid)
> > 
> > Please indent with two tabs, like David likes :)
> > Applies throughout the series.
> 
> Sure. Should we update scripts/checkpatch.pl in the future for MM,
> since this script seems to favor the alignment approach?

Yes, makes sense to me. 
 
> >> -	for (i = 0; i < nr_pages; i++) {
> >> -		page = alloc_pages_node(nid, gfp_mask, 0);
> >> -		if (!page)
> >> -			goto out;
> >> -		list_add(&page->lru, list);
> >> +	for (unsigned int i = 0; i < nr_pages; i++) {
> >> +		struct page *page;
> >> +
> >> +		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
> >> +		if (!page) {
> > 
> > I think goto err_do_cleanup is cleaner than ad-hok cleanups
> 
> I’ll use goto style, either is OK for me.
> 
> > 
> >> +			memmap_pages_add(i);
> > 
> > This is confusing. Updating counters only to use
> > free_vmemmap_page_list() seems worse choice than walking the list and
> > __free_page().
> 
> I think the memmap accounting should be done right after each successful
> allocation — that way, using free_vmemmap_page_list() becomes more natural
> and simple.

Why are you against using a loop with a plain __free_page()?

We know for sure it's not a reserved page and there is no need in
free_vmemmap_page().

And with memmap_pages_add() per page do a bunch of atomic_long_add()s
instead of one.

BTW, it would have been nice to avoid per-page counters update in
free_vmemmap_page_list() too, but that's not related to this series.
 
> Somthing like:
> 
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index c04f53f708d2..cab9ec14873d 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -207,14 +207,13 @@ static int alloc_vmemmap_page_list(struct list_head *head, unsigned int nr_pages
>  
>                 page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
>                 if (!page) {
> -                       memmap_pages_add(i);
>                         free_vmemmap_page_list(&local);
>                         return -ENOMEM;
>                 }
> +               memmap_pages_add(1);
>                 list_add(&page->lru, &local);
>         }
>         list_splice(&local, head);
> -       memmap_pages_add(nr_pages);
>  
>         return 0;
>  }
> 
> Thanks for your review, Mike.
> 
> Muchun
> 
> > 
> > -- 
> > Sincerely yours,
> > Mike.
> 
> 

-- 
Sincerely yours,
Mike.

