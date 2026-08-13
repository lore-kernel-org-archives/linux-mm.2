Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AAEBC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 20:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC5F96B05BE; Thu, 13 Aug 2026 16:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77756B05BF; Thu, 13 Aug 2026 16:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66216B05C0; Thu, 13 Aug 2026 16:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 819A46B05BE
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:35:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 029111601FA
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:35:00 +0000 (UTC)
X-FDA: 85097400402.05.A7E29E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id AA54340006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:34:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zG+Mz8wA;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786653299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S6cmsqG8l1zHA7G2eW50R84mRNDy78OB/Hf6CViIuCI=;
	b=ToKiBvHlnUgfMtvR0bEgP8vnlj9dGoiXu9WBH9NZOfPzMGmR5kGFIUJJnXh0eyO8WVrTMI
	MxdL0X29uRnled8H17F3PhYKbdSZ1+S1T9wThDZGIal5vvYfma546JRlVQEhEnnUsYIUkj
	8QFezMZf4piLhdmQWnZwOb3OkBMQUuA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zG+Mz8wA;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786653299;
	b=S9HOLdKMhEqKs9pzZGq9u13te41HnwEyGDtbNtIq7zwjvOZ/fjROHF/Y8GDZ+Npp21xcOE
	jjMd1BIXDiQBftT8gU6rk2sza45ZeXwQoEyVsaKfy+cWu4zgR29rLbIXrcWzuxuS0If6o1
	umhhWGSuT3U/Uia43OA9/ZhUlwAVcII=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A85B600AF;
	Thu, 13 Aug 2026 20:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392BC1F000E9;
	Thu, 13 Aug 2026 20:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786653297;
	bh=S6cmsqG8l1zHA7G2eW50R84mRNDy78OB/Hf6CViIuCI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zG+Mz8wAESaFgbRTNpUhV5gDm1QDClFyEh8Ovhvu0WoDTePb2+EvDHSn2FKcngIFO
	 /LnfoOA25EiRjyARMHAT9ior6KhjydG7NBn4AsaTh5TVr/nVSDXdRRuTRpSYVMSH7C
	 CZ/umvUuoFSCA4o+YF4WQPd7dsNJAnSldnbng/zQ=
Date: Thu, 13 Aug 2026 13:34:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu
 <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed
 <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 0/3] mm, swap: don't spin or flood the console on a
 bad swap entry
Message-Id: <20260813133455.3fe770eadcbe640e6f6c46cb@linux-foundation.org>
In-Reply-To: <20260813-swap-v2-0-4a625ccabdae@debian.org>
References: <20260813-swap-v2-0-4a625ccabdae@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: itjs6ydtdjain7dmqd1fr3fpatfsogka
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AA54340006
X-HE-Tag: 1786653298-951455
X-HE-Meta: U2FsdGVkX19iH4A4Ykme42343QxMTWuu4uO0pHr2IH7FYnEXFUg3EU4JM2n6x1IAK/eVuwTsoovhu7NVmmZgtGpmvLZj4MpH5huVJNvFsqIpjuB5oUpiAd4qVBNCaISVNiZdz0xjxxGhZcPCqv67e7np4dPqkL3+JtsnrISC2YMxm31dIuRHUNMBnUf/TgA7+p7/3I2lcQjxOl7LXj50K1725Af59hBgkQGnEjy3EnJXtlnxo8PzzdD5L26SfEt5I3/QcM+ufVKCfLJJJTNgKS0hV9ZEY3KkLM//vjzdhQKhUR6QWUR9/Ib0s8FUNDNNXABeXlyW+1oI1KkoKlL/VHNSsAeu8v5TkDkg5eGEWP5l9fK92sokmFCBEm8tkSCd7TO4NhdW1JNYRNsxbXAG9OY9/GT+Pb1T29Vox6FGHxcrx3lv1wTgjHZ50Jn/zizYnKABXHeLGVZVks09AYpHXrACVNoSB8gN0uWIshAFVTf2OFsd0a9MC5SJE1QAF+Tey1nHs06oyrZdUh3oFqUq29p3SwiPIKTMvjKJQ3naDZe5CvwVLUALGNhEPvt0lXPgjsXelNO1jxLAOgW1JIdtqZbRSwB1dhNJhzyuDuzUDN5zt0yJ+7xbaj8PGDUg4ql57nhIXnUNK3lWEqB2peezS1lENMJJBjwbqzkfCbAUJAB27m9ezzi9NdtRa6gZyar31wsjdqFY70MdiBcdNDa/7KfKHEeISUsVg3eOCaMvlA84M+qSFu32ci622PUeEMrNIa6quM+q14yVTGmG+OlnnVXCHXDdg3X0A7CNdVKNjU9Hx8BvnIRRnpLICSPg0QkuYChAEpy5i6UlL0ZOAyvfYvHXkgHMasO5kww9z4c4zlYBf+rivQ8kMgtCvWtkNJjSAf4J/f3EMNNNq8toO8EjxmnqnuQZebrB4krXRXeFWgpyBuBI2psPAdRwQ2LEueH15gEQfGSXYHxGyBcBgFR
 acRepk6S
 ehci/DhLctDY74PHaQvKSN88n2sTXPYdNPn+0eqjz91LEedImYxrBy+AnBEMgYpGRTGRZVM39vDlnzPJV1nC2ssXVFA8lHCpxZf2UB8wesq/Aikr1nfB7HxzX/GBlAlWEoNfhgLf8nzbHx87XAl4kE8T9begYhOIWkrwl8tYvSKEu6a+hUgUbfRB907c1ySczVNnxkV7LNWjCDEwP/fQnHTsGhKG/nsMNCm1wFOmpBTTmoskLUqT2n8fsWFxe9QJIPyKm8A9PIl81/TkeYNgq/xNvtbg2OLltafcSRojbMvaX/dw6IX0pVOm2ZnuQGvWYDtEAEOyRjrF0YICXsJ4CgauKxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Aug 2026 03:02:19 -0700 Breno Leitao <leitao@debian.org> wrote:

> I've seen some machines at Meta fleet that show the following type of
> problem:
> 
> 1) It gets some weird warning:
> 
>   BUG: Bad page map in process khugepaged  pte:f000eef300000017 pmd:00000067
>   addr:00007f57c0a01000 vm_flags:20200073 anon_vma:ffff88829af7c340 mapping:0000000000000000 index:7f57c0a01
> 
> The corruption is most likely the collapse/PT_RECLAIM race fixed by
> commit 366a4532d96f ("mm: fix the race between collapse and PT_RECLAIM
> under per-vma lock"). But this series is not about this one.
> 
> 2) Then it floods all the monitoring of the fleet, sending the same
>    message in the loop, crashing the our fleet kernel monitoring
>    subsystem (which is the part that I am interested in protecting)
> 
>   get_swap_device: Bad swap offset entry 3ffffffc043c5
> 
> For instance, in a host today it logged 6M in a few hours, and it is still
> going forever. Two things go wrong.
> 
> 1) get_swap_device() prints unconditionally, unlike print_bad_pte() next
>    door which suppresses itself with is_bad_page_map_ratelimited().
> 
> 1) do_swap_page() returns 0 when get_swap_device() fails, so the
>    fault is retried, reads the same entry and faults again.
>    Nothing in the round trip changes the PTE.
> 
> Trying to fix it in a naive way:

Cool.

These behaviors sound pretty obnoxious.  And the patches are quite
simple so hopefully the swap maintainers will make quick work of them.

I'm assuming that users of earlier kernels will want these things fixed
so please let's work on identifying suitable Fixes: targets and
deciding which of them should get a cc:stable.



In a spirit of experimentation I asked Gemini to identify suitable Fixes:
targets and it said

[1/3]: Fixes: 122e201211e4 ("mm, swap: get_swap_device() to get reference count of swap_info_struct")

[2/3]: Fixes: 122e201211e4 ("mm, swap: get_swap_device() to get reference count of swap_info_struct")
	(and it complained that this patch doesn't fix anything)

[3/3] Fixes: 122e201211e4 ("mm, swap: get_swap_device() to get reference count of swap_info_struct")

And I cannot find such a commit anywhere, so wtf.

chatgpt didn't give me anything useful.



[2/3] is "no functional change" so ideally it simply wouldn't be
present in the series - we should aim for minimal changes when fixing
bugs, then leave the cleanups for later.


> PS: Sashiko flagged several pre-existing issues, and get_swap_device()
> returning an error opens the door to fixing some of them.  For this
> series, I am focused in landing the basic cases first and build on top,
> if needed.

Yeah. probably these are the same issues:
	https://sashiko.dev/#/patchset/20260813-swap-v2-0-4a625ccabdae@debian.org


As usual, they're all mishandled error-path things.  It's axiomatic,
really - nobody hits error-path bugs, so they never get reported so
they never get fixed.

otoh, now that these bugs are out there and known about, it's possible
that a Black Hat can find a way of exploiting them, which increases the
pressure to get these bugs addressed.


