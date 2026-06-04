Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C052DCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 02:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2DB6B008A; Wed,  3 Jun 2026 22:12:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA536B008C; Wed,  3 Jun 2026 22:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2072B6B0092; Wed,  3 Jun 2026 22:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 120B76B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:12:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE67B1C1C74
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:12:04 +0000 (UTC)
X-FDA: 84840604968.01.34100D9
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf31.hostedemail.com (Postfix) with ESMTP id EB36620002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:12:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FZ53DP/H";
	spf=pass (imf31.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780539123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6SZO2PTw2KcbXgjzwwx+KH4Kf8JNmzc6dqKetjt7KYo=;
	b=vXI9UJzGgymcZwPg4XjYIXD+Qb7goLZGvofz2ZhTC998OP11sK8Cx7w477/neZazJaU599
	EuEoxgKHIOmdirctJLYqkI4Asuk8OPa6ZOStmibvfjIgJUQNPlEKGC+RlPpbIxzZ0hBI1V
	cxbBcDonILdsQCZ9rvCvHCU1EX3npms=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FZ53DP/H";
	spf=pass (imf31.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780539123;
	b=iZ7G8/1gNZuNf76+y3t5jd8GJGc4Nif8oXzhY1fAItrqXwq4GCKRX+kU9Qq40+4nkgKHvZ
	12NxW0/vjdmmTKXxfQkEPj0DGbb4T705nvwBQa5Pj4AY7VvL2ep4vLE3RCOxA2RjA/IC4V
	7U8vKJsGgGKFeUKscwjPi4e3IJ9I5wY=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-36b9d265355so67711a91.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 19:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780539122; x=1781143922; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6SZO2PTw2KcbXgjzwwx+KH4Kf8JNmzc6dqKetjt7KYo=;
        b=FZ53DP/H+FlDivzabErDixOHQ6eWJVO7Onl2K0xRqBYQ0CHEtghK2O3Pb/bTM/PnrJ
         Istidy1Ub6zksBj7rO7KNZHLZm5eIWL4eKytpGl66NDKlSGoy5kNiIGx+lMB50CtCxfx
         oVv6Q00INMnRvcteG5nrMMiPL0KVzxQM9EIVKR70EPvk+10toEJ0eV3VroVKa2+8bRaP
         Qkr3MWSZr2JgBq/UwEr175GiYpCGVEUc+8YOgzsO7umZWKQm/TEZUrcMFDpNaeZezdyU
         Wjzs4tWo0uPdW2LXqvsOoatzaTOi7bgduNM0vNaF5xJhPLMZ2A1gjKpseiqMzgt5Uq5p
         Levg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780539122; x=1781143922;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6SZO2PTw2KcbXgjzwwx+KH4Kf8JNmzc6dqKetjt7KYo=;
        b=A+m34fY/oXk+YpyqeP2V64WSefTOd6IWELi1liXZy6Bk83T+ACi9gwGlje5fyeMu0H
         MxZkLfJ94an9pZk5usTId49qkCwNOivgf+1IyhNM/ePG1PztD727cziYN3Iopiu+p6D7
         ldYvnE5oNlTCWJwLZPtzp/exhAlv7LJKpU5YsPDGYffE2ypHAZUWk1yeeGpcgilX2uK9
         IpCHvKU7BQBiHi9w/5FXstbNekuRlTDocGpFhby4viy0XNF2CxNsceOv3QW7zM3ZJjbX
         XJOmiOD/noWOncxypa5k0BqrVglaVSrozTonaFpsNoNczZpG29JK+9xfNDF7Scuu3hYd
         vTxg==
X-Forwarded-Encrypted: i=1; AFNElJ+70rItXF4ZZ2hOhfvhWpCb648vYn6tHfCEHYTvKCoSY1EUasabmMqiQxT6VsySLtlfy88RzRGvUA==@kvack.org
X-Gm-Message-State: AOJu0YzXEaztDe7aopqbFA1APdg9BcvVj3AeJcqMhCGbUGaPvIb4NT5Y
	IjIO45ivaj8Z/N3z9ufdtZqyxWOBxuqM4OldKOHQ9EfsjVx8eQua+px8
X-Gm-Gg: Acq92OH3AXku9zJQesYrYmBagNtoB5OnJLWxqeRhnBUZQs1KqAYyBsesiKnO84R1AVS
	3Uqcqa9mb09ETGypk6yt9x04DeKQKgcr0UCbLANKhc2w7g/AtVuE4Pbud47cnFi9kz3/exEyt7O
	VnU/tO/oxgmFLku/4sM+qS1GL8KEtHTdioCiCOsOrs93aqLgzmE9E/b2sRc8bt6u+JcpEjGv4yO
	K+xx4TQ+K+zzuGYgvxJmH+mhq8uWqvXKItFd3O3vFPri1pUs/Ay+80r9W5eQVoU25MWzabkG6S3
	N+rtrfmTCYaxscCV+tlSCviqhrHkEc5NSVXZFsLyja1r2PG1NWED4+mbA/+ZtwCP0tbLCFJ0b/g
	a08YD85+d7xwOTOzsIXBXyC5OzyEKfcaNQS51PGChRnI8Ad2XrFRsRZMy2Q3dEO1AZADdZy9cYD
	bCBNQyMlTC2TuIunzOJMkz3EfwDiXxmiqu0eUr8+h/skhdKxMSHNhuuQ==
X-Received: by 2002:a17:90b:4ac7:b0:36b:93f7:a903 with SMTP id 98e67ed59e1d1-36e30a2adf0mr5186933a91.18.1780539121743;
        Wed, 03 Jun 2026 19:12:01 -0700 (PDT)
Received: from [10.125.192.75] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f68b03ef6sm1101582a91.0.2026.06.03.19.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 19:12:01 -0700 (PDT)
Message-ID: <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
Date: Thu, 4 Jun 2026 10:11:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org,
 tj@kernel.org, shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com>
 <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com>
 <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
 <aiBqzOtEv5iAC_qC@google.com>
 <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EB36620002
X-Stat-Signature: twah3wtf8y1saga97zoorbu6583cwnoa
X-Rspam-User: 
X-HE-Tag: 1780539122-723543
X-HE-Meta: U2FsdGVkX18tmz5n8kI196bH150JCYfEwYYzAfmjrZHG5YLg+hRh5tCZOnvoMaZ0RpoQ78h2/LQaVXYFCVXHSyUBXZZnEk80ZJgq2GbeMJzd3dQVoeqE2CUYoCI/O+2YgotX775MwVRfGGc3GDz/Vc6VqCeaDDbxsst768fQUWzYdU34U3Yu7S833H3jjjsvbFyXetBY8lCQrnRMD3IJLLXqf7ZJyycgSCMNuCCv13bvnm6+RR3mAGmiJCfN8rm90B4udKqb37KlJBE9bCBMsJq9GdYEnqcfAQ3/jPngUqERoRQ/vsI2Mpt+1laLGon2iMy/+m/m2GEFXiQojMi2FmyQjxX6NMjoDiknEKcOfy/S/KBPaKuPazI0KrObrVra/G9J2VARlmGiuyQ0OBTgWi2hK99B9X+8Oti4ItWz9NonQShdOiCPG3nz0QQAnOR1X3PZnH9NcdBWOCzPvu9wKHXiAi84kSD7fls9vrT8qavOYh+7Wfk1NyMKIwuWb99cQ0aoicmeUwc0E8IJ24f0avQpN02q5B0PaUoBn3eWpx4fZLQ65UMroATzNL2QG0xW83K+wzoUgv7CLgfwiRdeAOw8cW4apDdGDYZvqsYbecfhpI/hgrzqP63GVHNkQtfsYhzJ/J9rR31R8HAaSEX+WdLWuq9WSzIXu4Oni0BVPEkskuzgLodC1RxVYvjM2Kigwu0Pyi/TQoQDBeIfD2Nb8fhRU5lXj/Dw9ebqNb5NfMWMeAsBJLJG3z7LjnDIB0YqFCJreFiV3lMr+2R504cwMamgDjJlQVHntxfNZ5ljzE9aW2lrIDGaO3ZNSu4SSy+GZoOCMt6+o2WYTMLBf6B8yINYwMgctDJNTmlxi2B7D+aytYFQwRMk/KE9rWIcDBSkFsygoZPU4/VSlOZYgf/PD/NPjTMW2jmu+dV0SM1M70ufWLvRVDWaHfQfjasJXxkLH5VtwVEY4H/wZwIZVbs
 C4Ea+vEC
 kf3p9sD8QiWIZaYkU1phbT5F2JGGHkxqcVsMf0T0sVNl2ggxI/HLNOl07es+2MWpapFmSFGScuV6dcwGTBNrDahOaSCkwVvyREeyaCyi5bdW6/j3iXgb+fkSHByUtUNIGBaA2cB6XeRwq2r9cBJE6tAozVrFZVaIkc98QohC/DOfwC2YJkBsV5Uryfub7d8HKX+DrI9CeUdss1V8HRJ1cR/xreAJ/7MEkMciw1h4PZ1f9LK5XCXBJMZM0U/HPl3OFxjW38VHcsuoUz8yFRDAGsU8NRcqk67+oSj/i0rzP6jIOvuuy7G7y/BohXTcBmGA6XMhKtbNCn9XcvnoO80wt7u7fr7nyk8pd5ca3itq82Y6LSOfPE1R7/Gu+GgCVvP6Fvw4zqBgYxdBWhGWdJ+sUghmAuq+wsFr1IsmL22pOCG7rzoHLaGj840I+03fI/ZGAGe8ktgtLzyd78WwOhak1SjkmWne6KsK2pDAsKn4TefNUPB2NCdFakD6llG+enbNyKB7HWO8ycku4f1NcqglmGdqvBE47BHHG+DV0RpixAgEts+paEQwnXKmIpswI3cdwWooQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/4 02:14, Nhat Pham wrote:
> On Wed, Jun 3, 2026 at 10:58 AM Yosry Ahmed <yosry@kernel.org> wrote:
>>
>> On Wed, Jun 03, 2026 at 07:22:36PM +0800, Hao Jia wrote:
>>>
>>>
>>> On 2026/5/30 09:40, Yosry Ahmed wrote:
>>>> On Fri, May 29, 2026 at 12:58:09PM -0700, Nhat Pham wrote:
>>>>> On Tue, May 26, 2026 at 4:46 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>>>>>
>>>>>> From: Hao Jia <jiahao1@lixiang.com>
>>>>>>
>>>>>> Zswap currently writes back pages to backing swap reactively, triggered
>>>>>> either by the shrinker or when the pool reaches its size limit. There is
>>>>>> no mechanism to control the amount of writeback for a specific memory
>>>>>> cgroup. However, users may want to proactively write back zswap pages,
>>>>>> e.g., to free up memory for other applications or to prepare for
>>>>>> memory-intensive workloads.
>>>>>>
>>>>>> Introduce a "zswap_writeback_only" key to the memory.reclaim cgroup
>>>>>> interface. When specified, this key bypasses standard memory reclaim
>>>>>> and exclusively performs proactive zswap writeback up to the requested
>>>>>> budget. If omitted, the default reclaim behavior remains unchanged.
>>>>>>
>>>>>> Example usage:
>>>>>>     # Write back 100MB of pages from zswap to the backing swap
>>>>>>     echo "100M zswap_writeback_only" > memory.reclaim
>>>>>
>>>>> Hmmm, so this 100MB is the pre-compression size? i.e if this 100 MB
>>>>> compresses to 25 MB, then you're only freeing 25 MB?
>>>>>
>>>>> I'm ok-ish with this, but can you document it?
>>>>
>>>> That's a good point. I think pre-compressed size doesn't make sense to
>>>> be honest. We should care about how much memory we are actually trying
>>>> to save by doing writeback here.
>>>>
>>>> The pre-compressed size is only useful in determining the blast radius,
>>>> how many actual pages are going to have slower page faults now. But
>>>> then, I don't think there's a reasonable way for userspace to decide
>>>> that.
>>>>
>>>> I understand passing in the compressed size is tricky because we need to
>>>> keep track of the size of the compressed pages we end up writing back,
>>>> but it should be doable.
>>>
>>> Agreed. Using pre-compressed size is probably easier to implement. IIRC,
>>> interfaces like ZRAM writeback_limit are also calculated using the
>>> pre-compressed size.
>>>
>>> I'll clarify this in the documentation in the next version.
>>>
>>>>
>>>> If we really want pre-compressed size here, then yes we need to make it
>>>> very clear, and I vote that we use a separate interface in this case
>>>> because memory.reclaim having different meanings for the amount of
>>>> memory written to it is extremely counter-intuitive.
>>>>
>>> Agree. This would indeed break the semantics of memory.reclaim. I will use a
>>> separate interface for proactive writeback in the next version.
>>
>> But doesn't it make more sense to specify the compressed size, which is
>> ultimately the amount of memory you actually want to reclaim.
>>
> 
> I personally prefer compressed size to pre-compressed size. That's
> kinda what user cares about, no?
> 
> One thing we can do is let users prescribe a compressed size, but
> internally, we can multiply that by the average compression ratio.
> That gives us a guesstimate of how many pages we need to reclaim, and
> you can follow the rest of your implementation as is (perhaps with
> short-circuit when we reach the goal with fewer pages reclaimed).

Got it. I will change it to use the compressed size in the next version.

Yosry, Nhat, should we continue using the zswap_writeback_only key to 
trigger proactive writeback?

Thanks,
Hao

