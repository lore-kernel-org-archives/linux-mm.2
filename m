Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7368BC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7A56B008A; Thu, 17 Sep 2026 23:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1709B6B008C; Thu, 17 Sep 2026 23:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 087656B0092; Thu, 17 Sep 2026 23:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CFB966B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:36:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E2F6C051D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:36:48 +0000 (UTC)
X-FDA: 85225471296.06.93A3108
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf11.hostedemail.com (Postfix) with ESMTP id AEB6440004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:36:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BrxP1QrK;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789702606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c5IgYQhJIaLET5VUZswXngb8vhELaOWEAGHyCwS5Ja8=;
	b=HJBUP5Fa1ltnCWErFL/NIauQUEf6NzgAt26MNCTx8koNgmGTouFNhHKfv1Pn25OwdxoOD6
	lxrljx9S4Hfxr3mqwklhNW5nbMMDXWvLDITezzQRHK1aV7Jz+CO8uuLSmus2tGip4D7jxM
	UD2UXb+DbWFx1qYxLv6PSUdfSJfIIGA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789702606;
	b=n1umXlczS807lJFypgORi0szGH55mwFaBSOXu8Vn/W0C2DCH3XeOwo0/gyBWufBYZKfXYj
	mft0Igk7wuW1y594VFDsmJFsFKsfgsEOC/5YoMSpyK5sZG8zDugk8nI01x7nX3Kp4sQ/0Z
	aPId7mmIoTrmDKJOE7zlTQfaB6pqzvg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BrxP1QrK;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789702602; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=c5IgYQhJIaLET5VUZswXngb8vhELaOWEAGHyCwS5Ja8=;
	b=BrxP1QrKloyxPTdb+X/FnZVaXtbc8/V3TpoeybtHskbczvgf01kj5bG796oWBuirASPbVzJdzZHvNj2Ws9IPEOWY6XP2VWa0D7fy9hKJ7k7e/xhyZKDMXfD9tCWogROdMx+IGB6ER0sjVWOUi5Ixw0DSa1UvuG1TR8Slqeug0gA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0XB9qv0d_1789702593;
Received: from 30.178.69.151(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XB9qv0d_1789702593 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:36:39 +0800
Message-ID: <c875638e-d14d-4237-9824-57d6c0f4a2ef@linux.alibaba.com>
Date: Fri, 18 Sep 2026 11:36:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: memcg: don't hand out large folios above
 memory.high
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 xlpang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, chris@chrisdown.name,
 kasong@tencent.com, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260915042546.279410-1-qinyuntan@linux.alibaba.com>
 <20260915042546.279410-2-qinyuntan@linux.alibaba.com>
 <aqx5kcqRrbkuay4i@linux.dev>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <aqx5kcqRrbkuay4i@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AEB6440004
X-Stat-Signature: jha348zmfdji4o5jy9jb916nwz97bpf6
X-HE-Tag: 1789702604-887028
X-HE-Meta: U2FsdGVkX1/YbLwzSWlH2vlBoKHuf5W/kgGf01kAOGeImrEmjniOl7RhK0/tuo1GerzWzchprgXa3ypWORkSaRlJMp7fGVKlpO6D55gPH591S7L5qXN3OOdVshwG1kUVKE+76IwbLjpn/BAgfuEU7YtHVYZSHqzccdBQ7YUdatOcn4TjZQ9EgbleRply0Iz+g5Ebi165kYNpHuGyOJ1to6yulxfrwEZ6LziSPE+NmbEStwyk6XmP6YjGg9l/IGfC0D5WsL4E64Cnu93xJveYqY6/l1dxhi+CdbmuHuucWHJ4sCfU5rex8ZPPhIV1d+DFn0v/ZiFercClF+dJebOpMeiznWPAfex9N08vt4ZzZx3bGiOAjzETolaXe4rSCd1BZiYArzQxrP1QBGHCXPFbm6S/opBT+CbybMYso0eE1ahrjfmfbV3z4uh6YNf91n24PomVqQji8y0jz8Ak288hZpMcYeDRegpyg6eZ/Q70c2Vj4qWTEanbP6hjxfN3zi2metTWfE0/SBizSb1jjoHxiJy6IrcrZRVS0RuT3/YPo5QFG2rc+wmhujBKs6nmFS//9zozKfF5sTPgLyRlHhUmgZfVlTAy9RZEwvrPubs0YVqAwy/gX0PnBzxqcJxAsNrxHat75NsfxbPN5K+wEIcbRZFLbkPJWsMVJLeYeu0rfsaW28y3tWjtG3jYhQPaWIoryMwAHP3XUPO8tkkX2HvMoSmSPfVm5sAh9bJgPR4h2AvkedtE/7JvasJjapq8Yp5dTVC4Vf1YKLCUQt6peFtT3SMPMI8da1Y1Ga+wAt/7qIVPrvSgT6N+gpC3xG62NNQ5mupTTlf+rMBhZWhSGm4v1aBy2WR5sqND5VUjJ2qxUj23ahzEj3NUAuS3MaGts1zEHBCOF7Ra/trwEIpJ5Dy9dJWAqPNR6wXVr89XZFxoWgG0Noe3h9O78xyG9oA7rcIs2sLitskdkwOSQTdYv0b
 R+3iwo1m
 +ptNHUS7IL0CElXJXSQvDPGNPw/Z68y+N5zaI6SYC/qkNV54BBdaPfSC3WnvUsApTqUNoZfPTpumYW2XiQ39Q2hXo+D5NmS3JZcJZLe8BhO7QfzjamY6TOpjHI1MhISicrRktRh0KFJG4/Zrb+hl5WeGxTYSeqx1xh0jWEIrBSmoyw10WMYgGJwINAVsRXsvvkNVkCo6pV1gHlsJPOZ7IlEF11x8h1MlXuKli0eh540iuRmkDwLZWyVFKwnPWOdB/Vl/euJ1IUncpgRohMEOL6f2ntiG2HjjthuRc9Rx7QbLOW0DX4r/s7t2FHnCss/gm/lvt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/18/26 9:26 AM, Shakeel Butt wrote:
> On Tue, Sep 15, 2026 at 12:25:46PM +0800, Qinyun Tan wrote:
>> memory.high is enforced on return to userspace, and synchronously in
> 
> Over time I feel like this sync throttle for memory.high was a bad decision but
> that is an orthogonal discussion.
> 
>> try_charge_memcg() for large overcharges, but only when the charge gfp
>> allows blocking.  A populate loop - mlock(), MADV_POPULATE_*, any
>> GUP-driven population - never returns to userspace, and large folios are
>> charged with the THP allocation gfp, which does not allow blocking under
>> the default defrag=madvise without MADV_HUGEPAGE, nor under defrag=defer.
>> So neither runs: usage grows from memory.high straight up to memory.max
>> with no reclaim and no penalty sleep.
>>
>> mlock(200M) in a cgroup with memory.high=30M and memory.max=140M.  Of the
>> 110M between high and max, the burst consumed:
>>
>>   4K pages                       3M in 5s, then still throttled
>>   THP, defrag=always             6M in 5s, then still throttled
>>   THP, defrag=madvise          110M in 13ms, then OOM killed at 16ms
>>   THP, defrag=madvise, patched   3M in 5s, then still throttled
> 
> I don't really like polluting non-memcg MM code with memcg internal details.
> Let's first discuss the semantics we want here. Please tell why getting
> oom-killed by kernel in the scenario you have described (mlock() larger than
> memory.max) is wrong. How does throttling it will help? What can the external
> observer (userspace oom-killer) do other than killing it? Or you are thinking
> that the workload itself is observing itself and change the behavior (though
> the big mlock one can't do anything).
> 
> What I am looking for is the real use-case you have for this case. Not
> mlock()ing big chunk or creating a lot of unreclaimable memory and going over
> memory.high. For example the reason I added the sync throttle in memory.high was
> to implement a feature Google has in their internal kernel where a workload hits
> its memory.max limit, kernel delays the kill for couple of seconds and during
> that time, the node controller may decide to increase the limit based on the
> memory situation of the memory. However even with sync throttle, we couldn't
> reliably implement the alternative because applications there have thousands of
> threads and there is threading library which keeps cloning more threads if it
> observes threads getting throttled.
> 
> So, let's talk about some real use-case and then we can decide if throttling
> makes sense here. If we decide to allow throttling in such cases, I would rather
> do it in memcg code i.e. somehow inform memcg code that this is THP allocation
> and can be throttled.

Hi Shakeel,

Thanks for the detailed review.

Honestly I don't have a real use-case. I ran into this while testing THP
under memory.high, so it's a semantic inconsistency I noticed rather than
a workload I'm fixing. 

The thing that seemed off is just that memory.high enforcement depends on
the folio order the workload happens to fault in - order-0 gets
throttled, THP under the default THP settings doesn't - which the user
has no control over. 

I don't have a firm view on the right semantics here either, and I think
you're right that that's the thing to pin down first. Whether the
order-dependence above is worth doing something about, or whether it's
acceptable for large folios to skip memory.high, I don't have a strong
opinion on - I'm happy to go with whatever the discussion settles on, and
if it's working as intended, that's just as useful to know.

And if it does turn out to be worth throttling, I'd be happy to rework it.

Thanks,
Qinyun Tan

