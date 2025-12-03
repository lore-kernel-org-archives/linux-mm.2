Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7610BD1BDD6
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 19:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C376B0011; Wed,  3 Dec 2025 14:43:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33FC6B0028; Wed,  3 Dec 2025 14:43:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70BF6B0029; Wed,  3 Dec 2025 14:43:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A44936B0011
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 14:43:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 46B805AE84
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 19:43:42 +0000 (UTC)
X-FDA: 84179184684.15.4DFC444
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 92358180009
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 19:43:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TiFmfslp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764791020; a=rsa-sha256;
	cv=none;
	b=2GZahmZ6WXvLJBRNeKY4kFN9TTS6uEX+z6GyzunZv6mnD02scTkPr6jsg2Gz8j+OybyFTQ
	yoY1rATMIcRPx5miDQpsFzXlc8D03ZWEs5BKPHZdMrkleucKIGtp6ncLJ+pB8oHHejiM9K
	BJQpIlHVmM1f1b3gVKVsR/AuBxgU5dY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TiFmfslp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764791020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WvNTasi5NQp5rEDf7+C2Qur56QYbkJ78NCDkWfXBxXI=;
	b=L3uhppLzG6CERG+8dU5GarKnnPudcwNR5kGWmXZRL2YloBaaHSBA1d6RE/tOsB6fYoA5yq
	ulMwuilwtycwnwvW+XiTcohY5MVKbqSqt18XW7tYGpasy6mS2ikd6AiRSVs+MJRTpBNUsM
	ikcuSFNXnbkFfDZlF6F07aQr6Xepnbs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE7AC60125;
	Wed,  3 Dec 2025 19:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421D8C4CEF5;
	Wed,  3 Dec 2025 19:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764791019;
	bh=bWOZ0rCV1PNPpXj+8oUS6KZ5pRj/a3w/aJIWyjxRjp8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TiFmfslpXKpLMd4VGIQZGRENUANoV1GI4j6S6Z5rRyRvQfqwzhW2aet54FFCDaiUJ
	 lIap4P2tGkxv1DUxfUYcDYoWyF1jejpG702cshoYE82pVC1C/UqUQst0/Y/vZFs9Hc
	 MEJ7EQWKC9gAqa3M5+cEqiqTeen2xvvoLjzSrye4YJQ4lMgUtyWXcS6dAlNVqt/qr/
	 niko2ItLElc2hsDCRRRPSMB4cpD1DIWgPZZFrI6pIhPfejGzp0KItvjZk1r71W3vDZ
	 0W0QIHK0ZPAGQswyz3y2iS58WKVFHYRNVcc0EO2lk7WEpZdVphPlBrlBVn9z/9whhq
	 gR7C9vkQPvTJQ==
Message-ID: <b5a925c5-523e-41e1-a3ce-0bb51ce0e995@kernel.org>
Date: Wed, 3 Dec 2025 20:43:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
To: Frank van der Linden <fvdl@google.com>, Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 kernel-team@meta.com, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com, kas@kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com,
 muchun.song@linux.dev, osalvador@suse.de, x86@kernel.org,
 linux-coco@lists.linux.dev, kvm@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>, David Rientjes <rientjes@google.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>
References: <20251203063004.185182-1-gourry@gourry.net>
 <20251203173209.GA478168@cmpxchg.org>
 <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
 <CAPTztWar1KqLyUOknkf0XVnO9JOBbMxov6pHZjEm4Ou0wtSJTA@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CAPTztWar1KqLyUOknkf0XVnO9JOBbMxov6pHZjEm4Ou0wtSJTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 92358180009
X-Stat-Signature: ross8gow9sikahtgniqcji6wyjusussm
X-Rspam-User: 
X-HE-Tag: 1764791020-538619
X-HE-Meta: U2FsdGVkX1+pLUO4UTVXsbRWOuwlIt1qO8xYSLIG19zRbYqyi5g9Uq1fFD/1p3bN4XlP7ehvYsd83pttt3feicwlVkMKBqIEZy7e3QgnH27sQZdMElEwIl4fLEPQQn+z7fnE3qEemhPlJ1bfZcqmMF8wJmnuGimEnxl4bFRQkwFemByhTyUDPaxsXDiv/IcTiYJbjbby5D+bdhVkBFwyXMvJbQ1h3UmiowZRZ3Bo/9orxKvwV9vXOfelnlwD/etlWxrZVKDhe8WnSC8wxGFckxNP43xHqyk1LEIDMYYpaKNgFN8x829PxObyqzzgKlb7En7TE+MrhPzSbiUdLWUkYbZ3pWroiFvrPrO93pXURps+onESEpDbujEXPLK5fiQy2K06kVL0FYo05z9JfkwMnxqX/LhqLx0frVY+zigbl6VxPF+6Lb6CgeN+th86f9ykl18ASzTn663cvsAhMc6TVUW+nhG+D3h8eiHpHIgGzt8Jgtm/rXmkgQaPNU3fvNtZV3vgr0S5yZrFgwNj1IVAzu2twoemeLfVppqgg38Fqx5SiWLlsCEwR6elAnX2TKP9mty7Aid8ocP//JH549YLbUiMrj4/G82UACTMediTmalR2/Kqh/sgXcXTq8CPbGWigKZ0Omu4Y33758Npxg3TQp3QwWk8lymLR3t2Rb2ToVaqhTvcESjdlnT/fuwqPU6qnliqgBsg1n+EebeOFmWEF+swZzRss2CdncXd53s15ZK1LVGQ7Snk8+mUmPS5xoVJzo4hjwJos/2Z2L8GQc3jd7Qp00JY0N5d977Sc7i5BB+EQCr57VUKlUGLeyT7TyGvdPGXrG6sFjNgeiwmR0A2ox0GEuzLSQuC7+29S7+n3IIsgf+92QZbwn4Ss//TjWBtADZvDXmQaYnzoOSTMdfUIPkTETZ3EtgmlSU2r1es/fneY1gWS8SUuMFz1G7mbibfcHIJ8jw8YrqelyMw+YP
 CcbzX773
 KHqNBQbwLhtdBLHtPweYxnNNVow0E8GeriSXasBzcf8y2LZLrzVHWno5rYE/vm9fvMb38OIXbpJnnNKKiSFvJSmHjeAohpfjB/JsXXDNhUXzKKLUeJm9CoPt/sJhf4tqzzwKpoejm2MbxiUv6TVnY+MVc7o2zmfCmO4MfGtR62cCU/1vYfl1e+PxE5amd/Ru0lfVGaDf6sCqAWYUhpzMlTGj0zvQmvgxX2eYHBUXp1OznsiXZGATN8c5EnyzuKyd2G3M52T8C8cmk+J3iHcY4GoWe4Qu4GnUlrvzJ7c78vJeT/mUeaHq/MPOVpsg406FJdYoyfvVmIQvEXmsAPmfxlcRk93PUvsn4J/Bbt8oUak16DHSsxEZHvOO7+F3uS5b6Rl7TXqdJBfSaOVxvvNG9n29+ScsaJ/DtQrrDCjMKGygLBNgKd8Au50HJe4bvN1cZ067Y+mubO/P0YySe8XpsBcA0Mp7WQh42V3oORFbiNk5wSANHGu+CgFQpwcxkkJicz9Yj0/eQhJvEG6Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/3/25 19:01, Frank van der Linden wrote:
> On Wed, Dec 3, 2025 at 9:53 AM Gregory Price <gourry@gourry.net> wrote:
>>
>> On Wed, Dec 03, 2025 at 12:32:09PM -0500, Johannes Weiner wrote:
>>> On Wed, Dec 03, 2025 at 01:30:04AM -0500, Gregory Price wrote:
>>>> -           if (PageHuge(page))
>>>> -                   return false;
>>>> +           /*
>>>> +            * Only consider ranges containing hugepages if those pages are
>>>> +            * smaller than the requested contiguous region.  e.g.:
>>>> +            *     Move 2MB pages to free up a 1GB range.
>>>
>>> This one makes sense to me.
>>>
>>>> +            *     Don't move 1GB pages to free up a 2MB range.
>>>
>>> This one I might be missing something. We don't use cma for 2M pages,
>>> so I don't see how we can end up in this path for 2M allocations.
>>>
>>
>> I used 2MB as an example, but the other users (listed in the changelog)
>> would run into these as well.  The contiguous order size seemed
>> different between each of the 4 users (memtrace, tx, kfence, thp debug).
>>
>>> The reason I'm bringing this up is because this function overall looks
>>> kind of unnecessary. Page isolation checks all of these conditions
>>> already, and arbitrates huge pages on hugepage_migration_supported() -
>>> which seems to be the semantics you also desire here.
>>>
>>> Would it make sense to just remove pfn_range_valid_contig()?
>>
>> This seems like a pretty clear optimization that was added at some point
>> to prevent incurring the cost of starting to isolate 512MB of pages and
>> then having to go undo it because it ran into a single huge page.
>>
>>          for_each_zone_zonelist_nodemask(zone, z, zonelist,
>>                                          gfp_zone(gfp_mask), nodemask) {
>>
>>                  spin_lock_irqsave(&zone->lock, flags);
>>                  pfn = ALIGN(zone->zone_start_pfn, nr_pages);
>>                  while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
>>                          if (pfn_range_valid_contig(zone, pfn, nr_pages)) {
>>
>>                                  spin_unlock_irqrestore(&zone->lock, flags);
>>                                  ret = __alloc_contig_pages(pfn, nr_pages,
>>                                                          gfp_mask);
>>                                  spin_lock_irqsave(&zone->lock, flags);
>>
>>                          }
>>                          pfn += nr_pages;
>>                  }
>>                  spin_unlock_irqrestore(&zone->lock, flags);
>>          }
>>
>> and then
>>
>> __alloc_contig_pages
>>          ret = start_isolate_page_range(start, end, mode);
>>
>> This is called without pre-checking the range for unmovable pages.
>>
>> Seems dangerous to remove without significant data.
>>
>> ~Gregory
> 
> Yeah, the function itself makes sense: "check if this is actually a
> contiguous range available within this zone, so no holes and/or
> reserved pages".
> 
> The PageHuge() check seems a bit out of place there, if you just
> removed it altogether you'd get the same results, right? The isolation
> code will deal with it. But sure, it does potentially avoid doing some
> unnecessary work.

commit 4d73ba5fa710fe7d432e0b271e6fecd252aef66e
Author: Mel Gorman <mgorman@techsingularity.net>
Date:   Fri Apr 14 15:14:29 2023 +0100

     mm: page_alloc: skip regions with hugetlbfs pages when allocating 1G pages
     
     A bug was reported by Yuanxi Liu where allocating 1G pages at runtime is
     taking an excessive amount of time for large amounts of memory.  Further
     testing allocating huge pages that the cost is linear i.e.  if allocating
     1G pages in batches of 10 then the time to allocate nr_hugepages from
     10->20->30->etc increases linearly even though 10 pages are allocated at
     each step.  Profiles indicated that much of the time is spent checking the
     validity within already existing huge pages and then attempting a
     migration that fails after isolating the range, draining pages and a whole
     lot of other useless work.
     
     Commit eb14d4eefdc4 ("mm,page_alloc: drop unnecessary checks from
     pfn_range_valid_contig") removed two checks, one which ignored huge pages
     for contiguous allocations as huge pages can sometimes migrate.  While
     there may be value on migrating a 2M page to satisfy a 1G allocation, it's
     potentially expensive if the 1G allocation fails and it's pointless to try
     moving a 1G page for a new 1G allocation or scan the tail pages for valid
     PFNs.
     
     Reintroduce the PageHuge check and assume any contiguous region with
     hugetlbfs pages is unsuitable for a new 1G allocation.

...

-- 
Cheers

David

