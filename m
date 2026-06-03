Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C642CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E0596B0088; Wed,  3 Jun 2026 04:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B85B6B0092; Wed,  3 Jun 2026 04:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CE016B0093; Wed,  3 Jun 2026 04:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CC9D6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:19:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 179B31402AC
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:19:34 +0000 (UTC)
X-FDA: 84837902268.22.0D41E06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 65CF91C000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:19:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nqlM7B6/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780474772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7AZ8z9mWLa7vVR6KumYSN0Nipei9xDbXIWVR1mkHhE=;
	b=zdH+PFJmKgpWjKgC86K3wR0qV4NzMGRfke10v37jutNhRHjABY3nMGw1A5Tcze0Y501tTb
	9Dinn1Jm/8FmHri3swMasOT4dTM5WyT1soD2VFsFj7/IqSF0RU9y2heoXxVKRc0DbWpzr4
	gSMT+gQjoG7XpWPqq3HOO+T6ARjVqeA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nqlM7B6/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780474772;
	b=c+CdYG5e3szwBj+5WZHgYud/sPQnIjAJxOYAu82FjnbLeJWoQ9Y3UYdHJa00NZTfM7WHtk
	mm9dijLgkCZm+DnN0PRcG2VW/dH+WfMZdTiFdnh2Hh5llCHTv5ynt5AiEI1ggJfh5F5nN2
	kDJhe0a/Jk/Fk5CNV5gBmnN2GaxwIF8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DAC7B60233;
	Wed,  3 Jun 2026 08:19:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A666B1F00898;
	Wed,  3 Jun 2026 08:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780474771;
	bh=t7AZ8z9mWLa7vVR6KumYSN0Nipei9xDbXIWVR1mkHhE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nqlM7B6/rqeikaLQVbwnEv15LF2reK199SOpmul7UFaeEXYYgiwdST4GAxD2Hql4y
	 YN6sg6U2+XizT+sUpPImX81X5O++AIcLOFntQKDMSwzlebYaDQ6fgy//d3BzAr7NdL
	 5MVg/L/CyROjWQtz/lDjHgAxkjEp7Ejhk7cu3RfvBMBZ2SvIp8yN2dvYJqLsv+4xS4
	 ObXm5x0V3ynXkPCq+tZgv9kPImZYX2XVuWU2ZjSEbECzxRHoAwpkjmE46S4nAdQe5z
	 1Hjdd9gIBVFVC4B1amHN6r0mHNE3ohkJS6lqdZlocSIS+6Ah0/gu2wz0lbzgawIO/e
	 4g7JHoSzexK/g==
Message-ID: <a0a19e2e-04b4-4224-95f6-3195006ee780@kernel.org>
Date: Wed, 3 Jun 2026 10:19:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/compaction: cap compact_gap() at COMPACT_CLUSTER_MAX
Content-Language: en-US
To: JP Kobryn <jp.kobryn@linux.dev>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260519200851.141955-1-jp.kobryn@linux.dev>
 <b4e49d71-bcd6-4c6c-87cb-2dbd75b3c2bb@kernel.org>
 <e318bbc0-3da5-4a49-bb1c-5777b7b4e4e7@linux.dev>
 <e65672e7-9a56-4489-84a1-db25d2c75f28@kernel.org>
 <b17dd2a3-8ca3-484e-8398-e5423f5df9c4@linux.dev>
 <71edb773-d156-49e6-ba6c-8159665a2dbc@kernel.org>
 <89e01c8e-1b08-45a6-a702-b23e45b70a29@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <89e01c8e-1b08-45a6-a702-b23e45b70a29@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: q55z9ryhk3wzgqunyosxafp3u5qzrnji
X-Rspamd-Queue-Id: 65CF91C000E
X-HE-Tag: 1780474772-113069
X-HE-Meta: U2FsdGVkX19KIAhrhBBbTZIF4NaKkf7KY+/WMVOxOiWUBae7BdOsgk8eEjTKKSyZcY7UbvfnegvifxdCMr7ap7ENsADA9jmqErCly1NSHQ5fBC//+R3g1OoVWB/I1Hykvl2aYjVxX9VnvqVYH7P9L09K6ihXyuh8E5NK/eHHD3kCRNrDV1DR5DdVgl2tOMGhCqw15uSmIJZRpYc3+bto+mwvVRBn4VzpRm/EpWLtCj3nbGY3eLF4uRmg/TVru1OZTHhQvXD/0EjPtsO6sdi2zdZkBsH8jYJG6G6GnEvng/gVLBka3RsRRh35RpEX+0tlbifarvxzW9P0t1BOxZ3B793tGSiidhSx5N/CfTwLzVCDFAJ35bJVrjhewuqhJU4QmyRhDc9uSOjhZSXNGPB4T4P3upQuNR2VaSCdVHxdxfBnTNrCd2JFSAJdF2k7xbouxZQ7PLPvmG5bMuEbB5FYhDY5CtaZEfkicB12BIyUnKx+8Ciqzx2NU0oVJVakNt3znjaKWoHO2kFiv1utorOxbldU4F4qLlQgLrDPEvcl0xk4VAgXssMPhSheUA6XjNAfNlnDzYXwpbBAXw6Apaxr30OOspxb16B21C3vyI6zzyVqJUfUPRMuVVX1OgqCYUtxWFH8HxrQvte8DbRvBMquptHyIdfkoE6ZKoBHzcVYlGOU7ZtrEguvo7GrHVIetlSHbTZZGLbEGAmWglNzZgkSin2oEHUUvKTDjSLR0xe1ifHemqBbyFqCSOBn4rj+Pv+KxazFAY5vxnaLIEpE03RPA2Xa6iAcsb5om/gBqEYZXDtFm3UTX+xn4/pkHkrt4pkzo0VvwWDxQfvOAmZFz4Mv1c2hk89nptD3aOnqIRWyDLICKs2B1UE4/iCdNtWgwGvNmmaKb3pZJyphaAvxACeuqNL9j/fFa5kzpkqw/4ZXudJ/jGJB/9GdqvWDSXkHT24et6OKpvvWDjOwaybnf5+
 9Y6zh26U
 n6QsxTFdpaJ92L/SBeKnUFJP7Ez3SVWu5rvkzFvOBA08f8Hb9sUT8K9WSFpz/X6hCdMIEs1/suU+Vt8K+q6dRhp4ByFfZbyLp7jR+BBuoQx5RY+cEakgK/EqcYYVeBMM2jkvNwCDBbSCMVxA5gJzAmVP36MQx6JzRedX2ta8FuFzeVddwbeZFMBhehYBD0zwYz+YLSxBl1J8vf9Ued+HgM+GQabYzM073NQjbONZj+gxDNSveQRHYiPKBxeF/C1adlt3GxVhwnyN+nC5v1INVM8rHckcZoxanYMbs2xRS2AHqcMZDI0JKsL6ZYwAJHw9UjsLY4zbHspiTJyw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 09:15, JP Kobryn wrote:
> On 6/2/26 1:40 AM, Vlastimil Babka (SUSE) wrote:
>> On 6/2/26 03:48, JP Kobryn wrote:
>>> On 5/28/26 1:51 AM, Vlastimil Babka (SUSE) wrote:
>>>> On 5/27/26 02:10, JP Kobryn wrote:
>>>>> On 5/25/26 3:02 AM, Vlastimil Babka (SUSE) wrote:
>>>>>> On 5/19/26 22:08, JP Kobryn (Meta) wrote:
>>>>>>> compact_gap() returns 2 << order, which is used as watermark headroom in
>>>>>>> __compaction_suitable() and as a reclaim target in kswapd. The computed
>>>>>>> value scales exponentially by order. For order-9 THP allocations this
>>>>>>> evaluates to 1024 pages, but the compaction free scanner's working set is
>>>>>>> bounded by COMPACT_CLUSTER_MAX (32 pages). The scanner stops
>>>>>>> isolating free
>>>>>>> pages once it matches the migration batch. The current gap
>>>>>>> over-reserves by
>>>>>>> 32x.
>>>>>>>
>>>>>>> On fragmented production hosts, kswapd will try and reclaim up to the
>>>>>>> gap,
>>>>>>> but it only reaches that threshold 18% of the time, causing reclaim to
>>>>>>> continue a majority of the time.
>>>>>> But doesn't that mean there's genuine memory pressure? We're effectively
>>>>>> raising the high watermark by 4 MB, but if processes are continuously
>>>>>> allocating, we'd be reclaiming without the gap as well? Unless the
>>>>>> workload
>>>>>> is sized to fit without the gap.
>>>>> It wasn't actual pressure, but the repetitive order-9 THP failures that were
>>>>> waking up kswapd. I should make this more clear in the changelog. After
>>>>> looking into why so much reclaim was occurring though, the compact gap stood
>>>>> out since it dictates the target amount to reclaim.
>>>> But the "amount to reclaim" is still defined as "reach high watermark +
>>>> compact_gap()" and not "reclaim at least compact_gap() pages" right? Or did
>>>> I miss something non-obvious.
>>> Within kswapd_shrink_node(), sc->nr_to_reclaim is the sum of max(zone high
>>> watermark or SWAP_CLUSTER_MAX) for each zone combined. The gap is not 
>>> added to
>>> that reclaim target though. It's used afterward as the threshold for 
>>> abandoning
>>> high order reclaim:
>>>
>>> if (sc->order && sc->nr_reclaimed >= compact_gap(sc->order))
>>>      sc->order = 0;
>>>
>>> balance_pgdat() then returns sc->order and that becomes the kswapd 
>>> reclaim_order
>>> value, allowing this branch to be taken:
>>>
>>> if (reclaim_order < alloc_order)
>>>      goto kswapd_try_sleep;
>>>
>>> Then in prepare_kswapd_sleep(), if pgdat_balanced() succeeds (at order-0),
>>> kcompactd is woken up for the original alloc_order (order-9).
>> 
>> Oh I see, thanks for explaining. I think it makes sense to target this
>> particular part (checking sc->nr_reclaimed) than change compact_gap()
>> globally then? It seems we have some mismatch in the various heuristics? IIUC:
> 
> I gave this a try and got some interesting results. Based on mm-new as
> of earlier today, I ran three variations: original compact_gap (2 <<
> order), capped compact_gap (this patch), and capped downgrade gate which
> has the original compact_gap (2 << order) but caps within
> kswapd_shrink_node():
> 
> -       if (sc->order && sc->nr_reclaimed >= compact_gap(sc->order)) {
> +       if (sc->order && sc->nr_reclaimed >=
> +           min(compact_gap(sc->order), SWAP_CLUSTER_MAX)) {
>               sc->order = 0;
>         }
> 
> The new approach showed improvements in THP allocations.
> 
> thp_fault_fallback
>   original gap: 1217
>   capped gap (global): 738
>   capped gap at downgrade gate: 898
> 
> More details are below.
> 
>> 
>> - in shrink_node() we have a should_continue_reclaim() call, which will
>> return false as soon as compaction is suitable, but before that, we are
>> likely to not accumulate enough sc->nr_reclaimed, because sc->nr_to_reclaim
>> would be capped by SWAP_CLUSTER_MAX's
>> 
>> - thus we won't pass the sc->nr_reclaimed >= compact_gap check in
>> kswapd_shrink_node()
>> 
>> - balance_pgdat() will keep looping because we're not raising priority
>> (kswapd_shrink_node() returned a high order) and pgdat_balanced() is false
>> (it checks for high-order page availability)
> 
> I added some temporary tracepoints to verify paths taken. The average
> hits across three 60s runs are shown below.
> 
> kswapd_shrink_node downgrade to order-0
>   original gap:                     0
>   capped gap (global, this patch): 28
>   capped gap at downgrade gate:    80
> 
> So the downgrades are more frequent, but the suggested approach
> regressed harder in terms of reclaim.
> 
> pgscan_kswapd
>   original gap:                    6328
>   capped gap (global, this patch): 3773
>   capped gap at downgrade gate:    7988
> 
> pgsteal_kswapd
>   original gap:                    5657
>   capped gap (global, this patch): 3243
>   capped gap at downgrade gate:    7101
> 
> This is because the suitability checks are still using the inflated gap
> causing the split below.
>   kswapd_shrink_node() gap:      32
>   __compaction_suitable() gap: 1024
> 
> So it seems that capping globally (this patch) is the better option to
> avoid the split above which causes unnecessary reclaim.

OK that's convincing and thanks a lot for doing that. Could you summarize
this in the changelog as well? Thanks!


