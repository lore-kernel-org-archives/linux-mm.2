Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB825C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 11:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D05BD6B009D; Tue, 22 Sep 2026 07:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB6546B009E; Tue, 22 Sep 2026 07:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5756B00A0; Tue, 22 Sep 2026 07:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96D226B009D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:26:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3F4440417
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:26:15 +0000 (UTC)
X-FDA: 85241169510.14.4EF911E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 35CEB10000A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:26:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N8K+TmDd;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790076374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKJMVvn2+RJOxSICwkLphAN5JLB84QmmP/Pj6bfhCzQ=;
	b=zlXu1mvWFbAtJz3R0SO8YK1i/yPv0uRfXHdw6PRAOKBs1I2imxiUfmpO6lFauelvooLtzR
	Ya/p7AuWat0Mrbmo/ZwXPYchg2sKRFpNhf9S23yV8duakrXTpBS/wSVMU+4vzs1o1Cqvdw
	lrOlgJTDChKNkBPOLdRTlQ1YUZ4/iWU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N8K+TmDd;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790076374;
	b=krtY5uGJd/iUN8ZxhDu1fXZC6o1gJYztq3lnVX1At+ggO53qzsJNVaXXnY7v6pQfrek7oI
	5mhVnig6kfqIDpEAISTNHapJN+cvXaBksD4uIt+CAKNy2pUztum/F0ysp1tiki93hMaR1K
	jDDxdvDz0AH3vTu/HtsEnO8SNdXk6vk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 606B3432F8;
	Tue, 22 Sep 2026 11:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022281F000FF;
	Tue, 22 Sep 2026 11:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790076373;
	bh=dKJMVvn2+RJOxSICwkLphAN5JLB84QmmP/Pj6bfhCzQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=N8K+TmDdK88xGDMzYGmuOcdg0t5dGhwKYyZ7n2PsCOVVHvv7wX9H5CeAn2j3CEHBA
	 HSKrdxMGbZ4oixqqjn3EN85PrlHxhnfvqz97xDGD5nQ76YgW5P2Elwd/rEQxqjCC22
	 hM1DZkfv+0GSv/tdmbUGIBgWfDs9d6Rsw3/Rx847M/We4L0deN9/eHy1AXCPT++k4i
	 yM1q6GVm4HsUIk1JamCd9QR4yxMk9CqAE8y/lPdRExkcozL3f950c9gNjL+EzYJAxf
	 d2vRLOHdeNlsnCT+cKatkIU1cDiOHTUtCX2+FnndsoTqXPRIOrbHC6GrY1NVmx8scJ
	 sERJGYNvzSeeA==
Message-ID: <2e695c8a-4212-42b5-bb51-fbe1aa162e1d@kernel.org>
Date: Tue, 22 Sep 2026 13:26:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback
 completion
To: Barry Song <baohua@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org,
 willy@infradead.org, jack@suse.cz, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, jannh@google.com, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org,
 chengming.zhou@linux.dev, kunwu.chan@gmail.com, tz2294@columbia.edu,
 hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260921152449.629486-1-alex@ghiti.fr>
 <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
 <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org>
 <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 35CEB10000A
X-Stat-Signature: cf9ham7u3z4iefwy68wqbku6ceiamm5d
X-Rspam-User: 
X-HE-Tag: 1790076374-822665
X-HE-Meta: U2FsdGVkX19pmk8rw7lqtaAzHJK1DYzbSqVpOJ+c7yC+6CZNxTacSAUY+cCf4Gfyd9vOsfHbE8hHE5qh31Wv7+dMb93JoqfsjYDZO/p4y2g+PS7HJJ0xAVNeUrYe821ojMvaGRfENvk45X7jXWHgFsRF24WNin4X0/Kc0j9xJWRs2iZ8ajUxVrrpg3vF178OUIpeCcOQJnvQ/FxqFaUnhrlga8VeytR0daF5m4yApdEbkK79E/6qpHZ1seTnPkKsvpt7n+7jSyfC1ut4zKg1dBo6wsvYk0aZlZDkqMxOu7WuDr4njfR1vgmWNW/b2NIXnPZL53ZQyqRkVJTKWtw0FipmxD+UEJy7Ncnw6d0JcQ3z8XZrk+Ec15h+SD1Qct0t3lmxsMXMti9IxvRFDvol8tGtHSL4dB9FUAD5mv/QftBpvYO4nwgbxOLKkp71mhr4WdXrKgWs9rtv1+/hV67Md7z9Azp20q3POnMAw1hgobmxkZFcL84Xw7dIUJLEL7Tpy01lEXA+izTIGY+sUBdx0/BsS4HMJ0ylpQ15IcQX74q9iKZ+GUtW+z+2bQ0W1ru+TXxARMDEJgFVOfeLcObc/RlWKJfjyE9q9eIvciVXzyNroU0LoRqWPxOlSJfp4WLAmFYZrGRunzDXN181Ti168PLU61YqRxy8KVJvF0Syn0T67jgo7SfbKQfx2O/c7K5pQHwpPKk4sYyDVzXxatn9uxvmKx8FOw/Zd7/DO3yYkeT3NQ5u7PtUKQuK6ZQ30iYj2gF4v9EZV+KpJuFS1D7fhVrdeULLs28LWBL26x8cGkTnUjV8Vq8M6pKmqTVE0XQiPYWhcaeM/sT5qndpV7SF3VUTt9wXSo8XGSuaGnRBhrcCS4Rz3G52JkHQebCLUp05isO1xhuJJWrn6znSmRMS/MhhkxGNsPa+5lU/UEXybFv3YIQZOoVh/oKu1oXw8Ye8/VHqjiBG3s7wCe8i97g
 A1rua/AY
 SC8u0OCob7KXjmYH86zuUeV/dJ3NY6zNWpddOKaNDM+gmfCW+KfrnQdgsImnZGpgGoF/5FKTHh4D+zC/sU1OAzRp9yaVCZadTwBj7Lx+RA0wcaNnznOeygw8px2QQgvWvqyKNtzbN106hJVpBSyxswmxPjU/D0RUPYaj1gNF4IDK0yKf0WZVqkSbJT1vqvJhf9RSA47wTVdcI8trzMhHWZ2XwjzcVbJOIqHPU4uBkcluhMM6SXHosVThKnuctIdkAV4crtwPqHF12MwyWKi5atWZxCgr3/2V8jSyVmCKWtoUNcGbi9AFzSFeSOJwEahnXCstF80TCBjU4m2AfdiD0Ozdi+N7VTG6qjhhlMfVH5TLO0QjhXW2uP25wZzyToxwKQlN0p9w1kJJAGabNjbbCNNYyJNzA6dvrV43smNestx2gzX6/5bjiQ2SoLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 12:37, Barry Song wrote:
> On Tue, Sep 22, 2026 at 6:20 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 9/21/26 23:56, Barry Song wrote:
>>> On Mon, Sep 21, 2026 at 11:37 PM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> For synchronous I/O, such as zswap and zram, the memory is released
>>> immediately after sync I/O is done.
>>>
>>> For asynchronous I/O, such as NVMe, the swapcache is currently
>>> expected to be rotated back to the tail of the LRU and wait for
>>> another scan. Alexandre once mentioned that when he tried handling
>>> async I/O the same way as sync I/O—releasing the memory once the I/O
>>> completed—he saw some regression. So, delaying the release until a
>>> later scan may allow swapcache hits before the folios are eventually
>>> reclaimed.
>>
>> "may", do we have any evidence that this actually is relevant in practice?
>>
>> We asked to reclaim memory. We wrote the memory out to disk. We unmapped it from
>> the page tables. We made the workload the could, access the page immediately
>> again suffer already.
>>
>> We should just evict them as soon as possible to free up memory.
> 
> I suggested this to Alexandre, and he found that it could regress some
> workloads [1]. That is why Alexandre is only making the folios
> immediately reclaimable for `MADV_PAGEOUT`.

I really hate to add special sauce for MADV_PAGEOUT. Also, I don't quite like
that we do something fundamentally different for sync vs. async.

I assume, though, that async writeback that is very fast might just find the
!folio_test_writeback() scenario just like the sync case. ... or if we
reschedule after pageout()?

I am wondering: if we can show that letting async swapped out pages stay in
memory a bit longer improves performance, aren't we swapping out the wrong pages
in the first place, and not swapping them out would help the sync case as well?

> 
> See Alexandre's description:
> 
> "Future work
> -----------
> Barry suggested extending this to MADV_PAGEOUT and general reclaim. I
> prototyped dropbehind for all reclaimed swap folios and it regressed
> sysbench OLTP throughput by ~15% on NVMe swap: dropping the swap cache
> immediately turns cheap in-cache refaults into disk reads and collapses
> swap readahead clustering. 

Thanks, does this represent a workload pattern we care about?

-- 
Cheers,

David

