Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17BD1C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051636B00A8; Wed,  1 Jul 2026 04:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029316B00A9; Wed,  1 Jul 2026 04:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60286B00AB; Wed,  1 Jul 2026 04:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA4CC6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:08:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3BC9C12029E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:08:58 +0000 (UTC)
X-FDA: 84939481956.03.E7557AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5A03E20002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:08:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BlbI83cU;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782893336;
	b=G3tfwlfqu4pnSSzki4NiUSFpJdhXgevLTtqraSNDSkh/enXIK7dvLZi/o12Vzy4rNOFZaP
	fN8SY+4Yznfxn9UAW9ciepvq1tBfvuZoXjKDs1ylwyjAXm3C16thjeGtSZYAR0VObLY9NQ
	AAfmjzR4BrfgmMt6mMSeMpc+Ah9B8P8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782893336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRfDQ94KKwfv/CvxlzEUrd912NKNt2V1LTiihODrmek=;
	b=tC7xeCPI8iHIjSas/mpuPlpwFAY7Jaa0ozKVHpgHuNiWNVa/rBbQIyd1LqZdeWeDBoXadE
	tw1DBUozByho86tgZUyTT6VpJ0QYNGMYWwS9qyM0eiLvwoBLJourEySVxKPN0Hoqs8tmeK
	NMj9HcJGbXTPbGDpN7bsL9jKu1gSDE8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BlbI83cU;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48B6C4081C;
	Wed,  1 Jul 2026 08:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489481F00A3A;
	Wed,  1 Jul 2026 08:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782893335;
	bh=bRfDQ94KKwfv/CvxlzEUrd912NKNt2V1LTiihODrmek=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BlbI83cUzoFLkksudULNVKgDqYjKjAYdjLUCMofo3GXkuGAU5FbXafStIm29Up3qn
	 P0NaQIGfQzJVswPcldyf1kNpDkU2iiMQiaGeEnWCYqMWEaHOyoa3cSN/gMSTin3o6H
	 DJHJMsud0lh1/srvBVB73TicVBQEQnvFnzG4UJ1IMmXPr10cI4RkKn1nkK/c90y0nI
	 gWeexF39tBly5JGpf8+NGq5F+MbAgpkKokw3X5lgHlH/VyM6IRIa4OluutXCiGJwGl
	 EAYdRFeN515POyx26cJKlOINhqiKPJPTZ6G0sea99hrKVoMk0nF34rFrxFc1y5VJFi
	 5/P5MMD0AW3hg==
Message-ID: <2f884bfa-3cd5-4fba-8aa4-c2e68890ab64@kernel.org>
Date: Wed, 1 Jul 2026 10:08:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Andi Kleen <andi@firstfloor.org>,
 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
 Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <20260629174225-mutt-send-email-mst@kernel.org>
 <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
 <f6d8354c-2f79-4a48-934c-cbeb335765e2@kernel.org>
 <20260630174852-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260630174852-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5A03E20002
X-Stat-Signature: 4nzdzzc16onceeiqnhexyd56bbhw93pz
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782893336-769634
X-HE-Meta: U2FsdGVkX1+0xgquvPrCZK1IELOVACfDCdmw4gF6J4Gzl2CIYHWxWx+JxDEOY5Mu+hnHUALABVX6KZYAN3bvEemCq+8qik0zxCkzk92zcHUozML5842r+1GNq5tM4tExe3RJeiDuBbeVJ1NkA1eEeBVbvXWM/kwbgmkF6Acd+G61Evw60b/dEJMaSEY7KwTkCwcntF2kJ+yoT55WRhZa7OY2nj2o07+gM9QXDZJhp+VSHcp0HGLiHgcED/r/7iZ92AnEwqV71dzujRwadTMs1XHcdZRCffGBLFh12HT2DBhiQR/tjpy3CUngWkvsIIXk0ODNxtLKWxfqJYifdcaw4DI7XuHCNwB67FpphBpuq3YFYPO/++1DGqeiOHCkj0WW6bp1tCjnQNG4P0ywrzNeFlAPahz0SKEy5Hp/Ma8mS4dR3x+tE+u5rBhQPYvFTUZWIIC1kVpKO3k5wpgXP9bZ6JnpQLi9im6if1MAb+I8FoTH0G99UxtR9ZQYftn1B9O7+XGrWhkIBNJxAKsd5+NJ9jefVBtPB50DK6nxUbitCkF/UmZ2Va94zsEZlAHXRu36VmcINPaQ/ZUkqIIEa+4/DPIpF2WL82t1rhnjrDjvlFX4RApW5Ky4w6MFtmqe36FCH7aDEvhxQXw/0ZOWDw/gCwn/Y9RyyP+M/fu/Z/BvZrPTK+Dp3GVZi06XnpPklqAhfw1D5x8JsnAlW0PFdEaqRY549CTSmlllRLuPqj1ZrjABkQI85MgCHhy67lm1h7x7p2VtiMsOMQAiz+ACoHvZxIism9zh1SxW9/SZk3JPKzTHUsfGs1gUC4htOSij/+ZdB1vp8BcTAFmFzYiLUns+qn8YUVSe0yQYnf6UkZQo/ZJLIVop0MLao3rt/AHVhKySiLL538HeZLVbEVCFm3rh+obJc7/i1I/tzH7/yxqurvL8yaXSgUlwRM26MvNy20VGuTTEM/s3QoBLhmYfL4W
 W5xDlkx0
 Tiv0hBpCZJqG07cglFG+SPpuqVhu/RTFIpL3EnYL+1I/YEuOhhoPrvRze0dgs0ho235XuEi2ihYZnwNnAJX3hOwtpoH7DDD4Jgp4FYF5WnR8vOPGca9oect+fHS9z3EsKoVms6L74XmQpNB+6mu1FnQ7lt977UaeHNFYnXcj2/IlQ4W+iws6p9eEgNfWmDi0dZtaAfywZQQ56NGJPi3rNaIvs5bSceopR2fgB56/X7jsjDYH1PIoShDj2yekpd2u6HovsCdEO4KUaLaxIKKVDwKeXb++Ey+mrkpMp35i7w3ZHuGtEzPWm5j+Xp6Or36cGDJgERWsIZ4tOuX5nbWRVfd72JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Cheers,
>> 
>> David
> 
> Yay. I did that + dropped the extra lock/unlock and now it's in the noise in
> my testing. needs much more testing of course.

Cool. I'd expect that latency-sensitive workloads (PREEMPT_RT) would not want to
have hwpoison handling either way, so using the no_resched variants at these
places might be doable.

> 
> If you want me to post (including addressing your other feedback) let me
> know.
> 

Let's first discuss the options. We essentially have the following one so far:

1) Ignore the problem

It's been there forever ... but I am not quite happy about that.

2) Use atomics everywhere

The easiest+cleanest, but as measured, the performance hit is real.

3) Keep retrying for a couple of times

The big problem is "how long". A CPU in a hypervisor might be stalled for quite
a while (20s? can be longer).

4) Disable preemption around non-atomic updates + synchronize_rcu() loop

I think it should work, but I don't like the possibly endless retry loop. (well,
it would never be an endless loop in practice)

Is there a problem with synchronize_rcu() latency, given that it can take in bad
scenarios a couple of seconds? (grace periods can be large ... but also very short)

4) disable local interrupts around non-atomic updates + let all CPUs perform
   atomic setting/clearing of the bit through smp_call_function_many().

Disabling local interrupts is way too expensive. :(

5) disable preemption around non-atomic updates + let all CPUs perform
   atomic setting/clearing of the bit through schedule_on_each_cpu()

Mixture of 3) + 4), but schedule_on_each_cpu() can also possibly take a long
time (as long as we cannot schedule on a CPU ...).

We could likely build something that remembers all pages with bits-to-set /
bits-to-clear, to then kick off a per-cpu work ... and once all CPUs processed a
page it was fully processed ... needs much more thought.

6) stop_machine()

Big hammer. I think we'd still need to disable preemption around non-atomic updates.

7) Move hwpoison bit out of page->flags

Use a sparse bitmap. Quite invasive, and any hwpoison bit checking code would
get more expensive.



Did I mess something up / forget something?

> Or look into call_rcu_tasks/call_rcu_tasks_rude which might work without 
> changes in mm.

Looking into call_rcu_tasks() (the first time) the semantics are interesting
("involuntary preemption is not a Tasks RCU quiescent state").

I'm curious how this interacts with random page allocations (on the IRQ path?),
and which design you envision given that we only get a single callback (who
prevents code to re-enter).

> 
> Or if someone else is gonnu work on this, absolutely fine too.

I can likely let someone work on that, but I think we should first figure out
what can really be done. (and likely when we send it out, it should be an RFC)

-- 
Cheers,

David

