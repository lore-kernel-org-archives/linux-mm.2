Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1707DC98309
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09406B0093; Wed, 23 Sep 2026 05:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9E16B0095; Wed, 23 Sep 2026 05:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A506B0096; Wed, 23 Sep 2026 05:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A28496B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:44:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C409120637
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:44:39 +0000 (UTC)
X-FDA: 85244542278.30.1FA998D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 45A73180002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:44:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b/XKkXgE";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790156677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XeVpYfjcdkpvh9ayAywqm3l1TSy3mb/tb9TU8su0lI=;
	b=hghFODCj2fMm0DjbENkybX4JHtf7A+mKxMiVaaN+OIMMe8JEpUXPomRSL+2l40Xk28BnHh
	1WLF5LItN8cPicC5vwm7UAvZKpqzgtWIHg2TrDUMvbjKlvf68NBNRMh4nfXZ3ZMmtq8BdY
	pIufgdEPpx9zbCqNh2fnirCFXI9BBEo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790156677;
	b=q7e7dliiNfEILxocxHlt+22TTzaB9EUsv8DArXNxOXoOvG+GqOlBW7sH85aviEU995SIUY
	6AUVpKZCxK195FHbS8mGalBGyRBVRw5tEhCm2/FpuaMk5O7YfAZV7LcUNEy+u63YwmBcTV
	46BGoqeoYzd9sPzPLoTLQycx9yx3/1M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b/XKkXgE";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DDAE41AA3;
	Wed, 23 Sep 2026 09:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12081F000FF;
	Wed, 23 Sep 2026 09:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790156676;
	bh=2XeVpYfjcdkpvh9ayAywqm3l1TSy3mb/tb9TU8su0lI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b/XKkXgEKU0YOjuXbwcfy36V3foj+p2K3KoT2nV14+trO1X2xhjmwe/2DHgIRafV5
	 w2N9S6AOKo9aE0469WHHoIvvnWH0hRiy+4BgBs4l0Gumj2JlaL8UjtxvoBrQqrpZQ4
	 iGUr8pPVEbHxSAibGSwyngYH+j2jgzN/UFIAgbosnvj4cagxjp6lKHVpb0WwoWaRXy
	 7a50y3wU0xzbhfT4GEYBHUYgdNsicPhHRz6E+t7MRRH2vPeca3M6gDws5LlFTCleyv
	 i+JwDuEPHowWMKM16/jvYw7ZGlGDzUXINd2zx8ljSfgsEwlHXLRfdap6la9ZlYaV5/
	 Q6WPtWciFN0LA==
Message-ID: <00d07f4a-f679-486f-9413-6917b5213854@kernel.org>
Date: Wed, 23 Sep 2026 11:44:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 ljs@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, baohua@kernel.org,
 alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
 <20260920162014.4479-1-lance.yang@linux.dev>
 <e22eb6f7-7eb4-4f50-af2b-13a2e3952cac@kernel.org>
 <CAJnrk1Zk_4awd5OfbvsCLts1YPsB6JjjOF2hiSmg-wAp+_KUDw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJnrk1Zk_4awd5OfbvsCLts1YPsB6JjjOF2hiSmg-wAp+_KUDw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 45A73180002
X-Stat-Signature: mmeuskjn181tan7wubkrbjhmdc8i9tur
X-HE-Tag: 1790156677-909314
X-HE-Meta: U2FsdGVkX1+KoAEeBN28SAGX1BvAWp8f9dUetmFIqnoJ6zPiRgkoEx1flj+84xj2LOOJHH5egB5wG/JaMnFbAuHym7Trgbe9MJIol7uprfQx9+WTYgI19Fl3k1B9s3IAO7qWz8pf0NdSZAiFDBqpQWVto8ddiiyDyH24csXWQ7bAYhOnnYSyMZiN7pr4WBT/9F8JuHoZMw3acAGZJvxf1X8sLJ/GrXncTGfdGeZyV+TApkbW+X5mmZ15CxC41fqESWviBe+KZ+GzKBlvsYPpOsZhaWHVLw1dNWfEANobLEtR3oRG9IvjmFknWG8DjlXRgLuTJg+dO039sA1f7wbhx2RDFZAXTbuWaFpsQp0TaxOTwFYfH7BFbCk1+78Temm7z+vQV/uJh8X+BSgAPFwSH1k4paU+V/YNaKdWi52EV4wF402H4iSWFvIKkuZGiaVPFx57TXlk8QcoL8a8Siq90qGI+1BdEjfWHYdMJoo00u6a6Uj8Hr2D/X89q5IO/qNAxvi+LuWIOqdvyy2cH/QWxdWuaOuDl6A0nxeG6VihfXtsPNgctpOOh71s2Y7wPvu1D2eMFK35rm1u6AfpKQkigSbkvvmOUDPxr+bR5Z4rXQOQmMZIKVyHonsMphonJJKcHAjefMkjNrf1Oup4BksvceAokB1i4HdawElQNzhYB9wZcRcGGFUih0W6nB/Oj2xr2NED5uaTrDyS7+C0KWtlef5Cwj4o/uD3B2XDjhdPLU+37YR1HqO+CoCWCrWBWkQBu+Y1fFYHFF9Er72pd8aG7fTPbH86dpq4bugpWfCHFE/lfSpqYJMgvBQBPNgVW0dMzWJBTWZtIEAhEgW5RxdOqOkDX9zKulU1O2WejuFi+wH7kK0OHvXUpTLA0F5scv+QLk2TYhHhJ5Oer4KguLvXQIjry0hKmnMga+17kgU//S7YXZioDQpQfqwlN4b2ZZg61rEa+9uKgpzj079lwVX
 zc094DL0
 fDw0JvExQblQ0Zl5N6burpAfFyh2nVbElimlVKN3LkOHB75de/o4H1Vda5WRzZpJxnxpYMmW2wRRzIHsXARo3AjW7pUSaHTGY5mSx7S8s73J3AN5I460E0Vqtq0kL8TNh2hUKWg/0vwDMQWMNghR0/iJjn0NPOYzhsKJd3Vea41lxCW7WV7Md2R4jO8jPZIOLjuQKSYT0NadDUQG0oeu7JjC2rboijuX8vLm1hpdJySqZbuvIomAI6J+ztmmdYowAIK2fsR0FnZ57hCnd4qEkXs7LrtWsgg5dI6iz3Mmb5J+E70YBSm7piJnaZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 02:44, Joanne Koong wrote:
> On Mon, Sep 21, 2026 at 3:12 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 9/20/26 18:20, Lance Yang wrote:
>>>
>>
>> "David objected to the scaling", not quite. The tricky bit is the scaling when
>> collapsing (creep).
>>
>> When freeing, I'd assume scaling should be alright.
> 
> Ah, apologies for misinterpreting your comment.
> 
>>
>>>
>>> Em ... I'm not sure max_ptes_none should also become the mTHP underused
>>> threshold ...
>>>
>>> Say we're on arm64 with 64K pages and set it to 16. Khugepaged PMD
>>> collapse uses 16, while mTHP collapse turns the same value into 0. With
>>> this series, an order-5 (2 MiB) mTHP enters the deferred split queue
>>> because it has 32 pages, and is considered underused once more than 16
>>> pages are zero-filled. So the same knob means 16, 0, and 16 depending on
>>> where it is used ... That's a bit odd ... no?
>>
>> I very much prefer scaling over using absolute numbers as proposed here.
>>
> 
> With scaling, I don't see a way of avoiding having to queue every
> anonymous folio of order >=2 to the deferred split list at fault time
> in the non-default max_ptes_none case, since any folio can now
> potentially qualify as underused. 

Exactly.

I was primarily arguing that I don't want this overhead for the majority of
Linux installations out there that ship with

$ cat /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
511

IOW: we add them (PMD THP folios today!) to the deferred list for
uuderused-scanning but never actually scan them because of:

	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
		return false;

Now, what you are saying is we might want less overhead for installations that
modify max_ptes_none, like Meta's fleet. See below.

> This drew some objections in v1,
> particularly for the Android small folios case. I read that as ruling
> out scaling. The objections were a) the list_lru lock contention and

It was the "deferred shrinker list and lock" contention, yes.

> b) the limited upside vs cost of splitting small folios.
> 
> For a), I don't think there were any hard numbers showing this is a
> problem. If it would be helpful to have some benchmark numbers, I'm
> happy to run a synthetic one (patch 3 applied (which adds anon mTHP
> folios to the deferred split list), only order-2 enabled,
> max_ptes_none set low enough, all threads in one cgroup on one node so
> they contend on the same lock, each thread faulting in a large private
> anonymous mapping). I'm happy to run something else if anyone has a
> workload they would trust more. Johannes also mentioned batching as a
> mitigation. If the contention does turn out to be an issue, I'm happy
> to prototype that and measure it too.

Right, I raised that. Johannes thinks it could be fixed with batching. I was
concerned that it would become rather ugly. We'd have to see how that could look.

> 
> For b), v1 unconditionally queued every folio of order >= 2. v2 added
> an optimization patch for skipping queueing entirely if max_ptes_none
> is at its default value, which would also carry over if we went with
> scaling. So I think with that patch added, for the objection to b), it
> depends on what max_ptes_none Android actually runs. At the default
> max_ptes_none, nothing would be queued at all, so a config that sees
> no benefit from splitting small folios would pay nothing for it.

I would assume everybody except some special users that fine-tune underused
shrinker run with the default. I did some digging in the past regarding public
documentation about how to set the parameter, and most of them just defaulted to
511.

I would be surprised if Android even knows about this parameter ;)

> 
> Does that make scaling acceptable to you and Barry? If so, I'd prefer
> that as well because if/when intermediary values are supported for
> mTHP collapse, that support would have to be proportional, and it'd be
> easier to reconcile the two with split also scaled. If not, then what
> would be the suggestion for where to take v3?
My opinion is (open for discussion :) ) that scaling is likely the better
approach. With the following notes:

(1) If we want to enable mTHP collapse with scaling as well, this needs very
good documentation and also another thought on how to work around the problem of
creep (e.g., refusing to collapse if creep would be possible according to the
max_ptes_non setting and warning).

(2) Systems where the underused shrinker is effectively inactive should not add
folios to the deferred list. Including PMD THPs, which we unconditionally add today.

(3) If we want to exclude certain small folio sizes from the underused shrinker
(e.g., order-2? order-3?) it might be better to just hard-code that in the
kernel instead of giving the admin a choice it cannot possibly make easily.


-- 
Cheers,

David

