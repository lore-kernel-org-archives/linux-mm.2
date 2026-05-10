Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD6CCD3427
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 11:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDAC36B0005; Sun, 10 May 2026 07:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8BBC6B0088; Sun, 10 May 2026 07:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0F56B008A; Sun, 10 May 2026 07:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 947A56B0005
	for <linux-mm@kvack.org>; Sun, 10 May 2026 07:40:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D46E8CAC6
	for <linux-mm@kvack.org>; Sun, 10 May 2026 11:40:18 +0000 (UTC)
X-FDA: 84751316916.19.7279BD0
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3B2C640008
	for <linux-mm@kvack.org>; Sun, 10 May 2026 11:40:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gMFbhDsA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778413216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IYStAx1BwQChS6ZRhkWQFwYXY+qT1ZCewaIDP6HriVk=;
	b=i4fYGfWYEi1mGfxVOaLADA0YFcO66rqPHbH3DxO1TXS5flzXTxKjUqfhCaZYnZNegZgCnt
	KkL4IDM5ssoj/J4e8LSKRUxri2MOikllH1hvYtqRtsjInsxQnWnCPlpi1xV1F0EZBQzW9H
	9fy7OOVkXv1THBDajfh7Fa35UUoWMFI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778413216; a=rsa-sha256;
	cv=none;
	b=prfcbssxr1U9/uTMBy3/cSAvfBsEQCHJicqGoY9m9OEJuJ5oJWRkkXGeEfUGJ7FVa4M87t
	B5YOB/m30l1qL6+LMnRWz9tX0amIYtHJSVwRqXRUo/84m+9cLcFy67EBA66ru9D5fkbeQQ
	pt9eVLXWQm2mCUEOSVoKvT3y4G+GuvA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gMFbhDsA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778413213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IYStAx1BwQChS6ZRhkWQFwYXY+qT1ZCewaIDP6HriVk=;
	b=gMFbhDsAV/yRT/hRm5zRlMCP6n5g9+/SDiK3Q3lqDLPlbsQqpY2knCP8VDH8K9oUIQg6jg
	tuniJs76NrOmmdZKrDYjfrCijz8IfVsyqvZr97l7n+wX503Y7jbNhMRbyvEw7sbiKaWYQD
	ROTHYcW2ULn9/NGeZNyrTRFQyoArpgY=
From: Usama Arif <usama.arif@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Nico Pache <npache@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	yuzhao@google.com,
	usamaarif642@gmail.com,
	lance.yang@linux.dev,
	baohua@kernel.org,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	liam@infradead.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	ljs@kernel.org,
	akpm@linux-foundation.org
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
Date: Sun, 10 May 2026 04:39:59 -0700
Message-ID: <20260510114001.600681-1-usama.arif@linux.dev>
In-Reply-To: <04ea0e68-de56-49c4-8c9f-1734139d5e7f@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3B2C640008
X-Stat-Signature: xcn5uaogeis38oyzioswhncpdn1frx7j
X-Rspam-User: 
X-HE-Tag: 1778413215-538863
X-HE-Meta: U2FsdGVkX18eSFWv6cKzZT4GFANThAOF1E0JPTILN7cKRzbQAnMvaMnMImENB/NxqR+mKr9u+FaHfh0SSVQCbjbTfBPAgzxj7pOvZKg4NoYDAqq7AnRRPigarv5DHtvLu8dbSMLwQegkSIQlXbh9mzxFzxrtA8/A2kE7ZQgbMXTmsawebzR3yo9k/+CiTXQRiR34+Kgqr2McZli2YqdLKgmuwvpXYgQYg7fiVOwn/tCaghBWpfUuYoQEEHEbTdDchjYwDTNM23QtDDaHNVUjL25tcABblTWrF+pAMbP/5407K/MR2SIj/Xsls/bNMGVKKHcRb9zYqEW81XNdhQS1cS3ONza3rEGVOLXkqggqtmk0qbq/XgDin5W4SUab/5Npau5qM2+72TbuEbvin5OF4EyYQtGy24aQp+557zS6BV51NRb5UhH+Se/7nCtY3FnFwkfyFqFqu8NZKFom5gjxynU0AxQewvLcMGvUnjkWbDZKCq0FZbETNDMTL4L9v0DUhlZzfF1Mrx70TiqfTIXI1LW3jpxbomqTxyR6Se1fcDkOCxuEw7Z3Yzk0mIL6t0Uf6WO08eCnvaJHFB44kF/3ZLrofuy73nqxQzVxnUlS3hQ5Sploi5rIS9JWgCFeW4nH+5nDC2rgLgpMQApVTlB7TS7Kv0ddNV9HrUhYhuOJFxRGZ4A9RL6m07/zVG1lC1tQofIVDmumSsNfxcyZJHWY78tF9zUyIegXWs8ncBA674ZAleCVKLzW7JM1YiDO8nyNyRHAehL8i8yUfNVcOwBr7kp7JL6oK+JHKG52thRN391eO81PvVH1l8laTvWnDpOR2BSqd9kWNK9wI+vFD9EKup6bh2DPtWTJDcbM8SMTA/b9/FOcez8Nx0vYSDnQx1dFFXbJ5R12yRZBp+R6gHcemN5Uv9+RTHGlT6wv4t0ZQLoBHFMueaMZOWofrvpIDiUwgdmWRxiRUU5Fsx2Byry
 7ISwFw0w
 HQiX3q2m6b6oo48f4oHqSXMMHqnNBCejsXGBbKyS9l38U1yUKvMOgOgRZZx6IwIG3YKlMnWd5BWBldYKHIMZ+9rJsPDzvexKPFjSWfQ3IS/ROoFHMVWsCUr1fhC2rR4LUV9fz4joodANct0qGEh1HOOSHpz43AEgVHyupYc1BycGtojvk/qs4cNzRDUgRrYhg1A5H0gXwQ9xo3D+eXcFzRHkwVAt5rs4PwCwf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 8 May 2026 23:32:09 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 5/8/26 19:05, Nico Pache wrote:
> > Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
> > when splitting isolated thp"), splitting an anonymous THP remaps all
> > zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
> > This flag is set unconditionally for every anonymous folio split,
> > including splits triggered by KSM.
> 
> And even when the underused scanner is effectively disabled on a system. Hm.
> 
> I don't quite like that we scan for zeropages when nobody even requested us to
> split because of zeropages.
> 
> I can see why we would want to scan for zeropages in a setup where the underused
> scanner is active, even when the split was triggered by someone/something else
> (below).
> 
> [...]
> 
> >  /**
> > @@ -4340,7 +4341,13 @@ int folio_split(struct folio *folio, unsigned int new_order,
> >  		struct page *split_at, struct list_head *list)
> >  {
> >  	return __folio_split(folio, new_order, split_at, &folio->page, list,
> > -			     SPLIT_TYPE_NON_UNIFORM);
> > +			     SPLIT_TYPE_NON_UNIFORM, false);
> > +}
> > +
> > +int folio_split_underused(struct folio *folio)
> > +{
> > +	return __folio_split(folio, 0, &folio->page, &folio->page,
> > +			     NULL, SPLIT_TYPE_NON_UNIFORM, true);
> >  }
> >  
> >  /**
> > @@ -4559,7 +4566,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
> >  		}
> >  		if (!folio_trylock(folio))
> >  			goto requeue;
> > -		if (!split_folio(folio)) {
> > +		if (!folio_split_underused(folio)) {
> >  			did_split = true;
> >  			if (underused)
> >  				count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
> 
> In general, this looks clean.
> 
> But imagine the following: someone splits the THP for another reason: for
> example, because migration is unable to allocate a 2M THP, or because we have to
> split on swapout etc.
> 
> Not freeing the zero-filled pages means that these pages cannot be reclaimed
> anymore easily. We split a possibly underused THP but didn't free the memory.
> 
> The only way to free the memory would be to wait for another collapse, and then
> have the new THP be detected as underused.
> 
> Hm.
> 
> (1) As you say, the alternative is to let KSM say that it wants to handle the
> zero-filled pages itself. I'm not a the biggest fan of that approach. We still
> have two mechanisms interacting to some degree.
> 
> (2) Another approach is to just let KSM handle this in VMAs that are marked as
> mergable while KSM is active. That is, we check for VM_MERGABLE and ksm_run ==
> KSM_RUN_MERGE in try_to_map_unused_to_zeropage() to just let KSM do its thing.
> 
> That really just stops both mechanisms from interacting.
> 
> (3) Yet another approach I could think of (in general) is to disable the
> underused handling in a system where the underused splitting is entirely disabled.
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index e9d499da0ac7..5eca99271957 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -82,6 +82,14 @@ unsigned long huge_anon_orders_madvise __read_mostly;
>  unsigned long huge_anon_orders_inherit __read_mostly;
>  static bool anon_orders_configured __initdata;
> 
> +static bool thp_underused_split_active(void)
> +{
> +       if (!split_underused_thp)
> +               return false;
> +
> +       return khugepaged_max_ptes_none != HPAGE_PMD_NR - 1;
> +}
> +
>  static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  {
>         struct inode *inode;
> @@ -4188,7 +4196,8 @@ static int __folio_split(struct folio *folio, unsigned int
> new_order,
>         if (nr_shmem_dropped)
>                 shmem_uncharge(mapping->host, nr_shmem_dropped);
> 
> -       if (!ret && is_anon && !folio_is_device_private(folio))
> +       if (!ret && is_anon && !folio_is_device_private(folio) &&
> +           thp_underused_split_active())
>                 ttu_flags = TTU_USE_SHARED_ZEROPAGE;
> 
>         remap_page(folio, 1 << old_order, ttu_flags);
> @@ -4497,7 +4506,7 @@ static bool thp_underused(struct folio *folio)
>         int num_zero_pages = 0, num_filled_pages = 0;
>         int i;
> 
> -       if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
> +       if (!thp_underused_split_active())
>                 return false;
> 
>         if (folio_contain_hwpoisoned_page(folio))
> 
> 
> 
> I tend to like (2), and maybe (3) on top. Opinions?
> 

Hello!

I think (3) definitely makes sense.

I have not had a deep look at KSM up until just now, so might be dumb
to say all of below.. :)

What I see is that KSM scans THPs as 512 individual 4K subpages and splits the
THP whenever it actually wants to merge a single 4K chunk. That seems like a
lot of work for a single 4K?

One thing that came to my mind is to have a separate tree for THPs and only
merge the THPs that have the same content, but the possibility of encoutering
2M pages with same content is extremely low? so this is probably a bad idea.

An alternative is, does it even make sense to process and split THPs by KSM
in the way it works now? IMO this is a lot of work for a single 4K merge.
Shrinker is designed to release memory when its needed, i.e. reclaim, at
which point IMO free memory is more important than performance. But KSM runs
all the time.. so constantly splitting THPs everytime a single 4K can be
merged just hurts performance all the time. If someone cares about memory,
they should be running the shrinker. Is a better alternative that KSM skips
THPs, THP shrinker splits THPs into 4K subpages when memory is needed, and
only then KSM gets those 4K subpages?

Above sounds like reworking KSM, but just wanted to put it out there.

(2) + (3) sounds like a good solution, but I wonder if above alternative
of KSM just skipping THPs might be better?

