Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99D92C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 06:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6696B00A4; Tue, 30 Jun 2026 02:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6DF6B00A5; Tue, 30 Jun 2026 02:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570AC6B00A6; Tue, 30 Jun 2026 02:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B81B6B00A4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:30:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 871241203C3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:30:22 +0000 (UTC)
X-FDA: 84935604684.03.7EEEE4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8D55018000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:30:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftiz5Kz6;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782801020;
	b=wsGoXxkhhQ4SP7Pmlw+i0GyzlRLiZIrQlSC2YhhbfMpeO8RXrU82ty5F/k67+9Ae6IKGO0
	a2fw+qCiokWdou1yMKMWzZOTbEPFPD3Nx73RSFJWI5zrbXexNJO4knHDCXi6NoOXvr9vp0
	B5LkRskQ/2+PKsZwMW7Q1yDPgKD9JpY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782801020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KOV37TH76GArpnwbguSBuDZgeS0U+NTFaarv2sWby3M=;
	b=Ulg5rUCuQKQOGRozpAGmKcuw9YC06dkHoJEHyToKmRYIuByjnUP7okpnbAt6BJFBW30Plo
	SHrMe7lrqQN+SvIxN+A4GgqYWzeEWnc3e7I6Gib76T7BiMkOgCV0iqX+iTl+4Wnf3deNPU
	bvrC1QY7w8wKYFULlSnWaJYNbv2FJjc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftiz5Kz6;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA0D4435B0;
	Tue, 30 Jun 2026 06:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E041F000E9;
	Tue, 30 Jun 2026 06:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782801019;
	bh=KOV37TH76GArpnwbguSBuDZgeS0U+NTFaarv2sWby3M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ftiz5Kz61TgJ9Z1X5mAqhTLE3tOs3XuQ1Rr4KSSWFuOuVlK7xUruIm7ycl2jg5JRE
	 SDacCiXIvEURjJE+Z0rC6xCDqxC8uFR2rHCDSJTrUv2diaedaU7gJedwjzl+rMPZq0
	 1703isnm/mhq8236+fb+8QwQKLfiLdJJHAwN3G5+GfSnhDJIoAbJ4zupTAKrtmvhLt
	 Pe30hMlArDdkJGVJB2A5JlZ5trPl8lDZXW4V/3N/hqg7zygXEeGOQCbLbRKeQxbH6/
	 F20w52pdxXvcHCK6QvOwOFD+LTjbggQZnnOJ+JpYEx1Ts4dsNHnEixC0RgCiYuCufI
	 D6xPtHSoDGzQw==
Message-ID: <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
Date: Tue, 30 Jun 2026 08:30:12 +0200
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260629174225-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rnmtpubkg3ct13f7ppbpreah6rd5fkq4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8D55018000A
X-HE-Tag: 1782801020-743389
X-HE-Meta: U2FsdGVkX19ppUq7LQOxU45Dz0vvGHz8x1CxXxk2z+UPPvzohhSwWrJzL7a3P2Ald/5ZNC0JBeTkGFje55EuY4wmnDP/X+2gaYIvRwbbX+7PLSgDXiA8P5Kjdg26d7dnPQSU5iXeC+FnQ9n2o/HjNjRsFBd+oIODEf7b2150yFTNdcbIBVM3rubuxwhemjnkke2y5o8MQPS+A8oizn4Iik2Vs8zJKQPr9dsykQ56IFNdQLaSRX0P8msA6m3O1oXyj8mBi+NqufB0+zMamWCmV3CQNdWNKoGcgHmub+u4UTP/jppIpL30Ka4wtAK1HF/kafhjnr9tWwlw8lHa9s7X9m+CDU06zd80UZcWqJ/LnfrLp2B2IBQPsoL0Nb8JdKBxSqwMR6MsmxCnneblaLQ24jgeTYNoiy5ywWx5PHQVTyCpqoBxOGsLKVfwp+yWHv9aTEnaukUQoyGPq8/TNXtKQ9hMtmW/cjeXMFd8pxoox+i37U0n3GKaN4rEEj3Nnv1RV6p0R5Vrv8sCTh3l5LfI9T7s53voye0nQL8SAOygeoViC0JPhOUwDyPm5SwhzmbLRG1NevVRa2OePJI+QYaiCPfe4NbMeyoDfkvAeN7VBxFqBt6TgyUJEr70o8dY7xYWkgVnUSOCDkzeIk3U/cq7O7g/tbgUYaNOhNOneM1jFnGk8DU50iZAtMbLCUlrsnWAG0EH1HY7MDFpN2+pNF71jh0cfObvCzYtCzk5Wm7ZCfXp9sdD/PtkqIT2sg1M1CP7WJcb8Mhsla6ysJqXavkQ90VjmbE4MSpzlZlS1RuTCUzULcga+ie8scT6+5zi7DowglJkziZAAYPwNniJ/MpF6c4m492cuSwvns9ksT6jI4Q5fFrUtCYpOJ6DtWm8zBVtN3dgOiqtzR/o8NQPHxICElvl8X50P6pqOmOdrK3eMXvcHBEu29g8Xgqj3f1uTlQ007Ny/1Syth9zbPQ4RTM
 xb4whYoU
 GxSkH9Gz5fRMTLv71SlBTDEFPouLUurf99t5RE1t+Da++9NSBuNOkeKLfddytbB34LEn8P3sAkqv3XSnYTzCM/g/FomH1zsuv0F2o3qqE0O5hIYP1NwYxHKt8L6mq2mJrjLfVnp0KBdLIUwLaqgYpuZgpHb1biodsRptJUwoUXkpEIHRY9IzBpaqsE80GBz5HshCj6WpuG3hHMIyG9qM1+kMpStJwiDf0GBUgvN7Xi0+iE4Z4zfjoUeXOITAw2GrDTy8dOdH8KsZaFawPn0oVqBpnIawb5bxMRAErsSk6DmK41bHoG5H8sz4rPADBrVY4jrLnlMSlO26wwDwOVz0fYWVgLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 23:50, Michael S. Tsirkin wrote:
> On Mon, Jun 29, 2026 at 11:22:11PM +0200, David Hildenbrand (Arm) wrote:
>> [...]
>>
>>>
>>> And again, I'm really not sure fixing a theoretical race when memory
>>> is failing is worth slowing the world by 0.1-1% for.
>>>
>>
>> Fully agreed. I was hoping RCU was cheaper (I mean, we were once told that RCU
>> read side locking is essentially for free ... well in some configs :) )
>>
>> The question if we could optimize it reasonably enough ...
>>
>>>
>>> From what I saw in my testing, if we allocate 4k pages
>>> it's hidden by the overhead. With hp and thp it's measureably
>>> worse than rcu on !preempt config.
>>
>> ... for example, by doing the rcu read lock + unlock around the
>>
>> 	for (i = 1; i < (1 << order); i++) {
>>
>> loop on the alloc path.
> 
> Is this different from what this patch is doing?

Ah, I missed that we batch this already. We could make it include the

page_cpupid_reset_last(page);
page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;

As well, to reduce from 3 to 1 locks.

So I guess there is potential for optimization.

[...]

> 
>> I concluded, similar to Andi, that stop_machine() is too big of a hammer.
>>
>> I wonder if something could be built out of preempt_disable() and sync SMP
>> calls. hmm :(
> 
> rcu_lock is basically same as preempt_disable if rcu is non preemptible,
> no?

Yes. See my other mail, I learned that preempt_disable() should likely just do
for our use case. So the preemptible RCU case would not matter.

I assume that's as good as it gets.

1) Use preempt_disable/preempt_enable to protect
2) Batch as good as possible in the page allocator

If the overhead is then still noticeable, there is not a lot we can do to handle
this cleanly I'm afraid.

-- 
Cheers,

David

