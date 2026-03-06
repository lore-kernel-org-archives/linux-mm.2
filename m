Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E03EF0182C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7F56B008A; Fri,  6 Mar 2026 06:50:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85746B008C; Fri,  6 Mar 2026 06:50:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9597E6B0092; Fri,  6 Mar 2026 06:50:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 802816B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:50:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 41D0F13AF99
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:50:21 +0000 (UTC)
X-FDA: 84515470242.05.BBBF37E
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id E9E4B2000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:50:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772797819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0v7wLvCPtCaXzasahRaW4I1Fp9K+2KJtXojBU6P9yls=;
	b=gppdsd8KkaLbRYvd5zmCZrC+9ScUmjSw01t1lNiBU1IiOX03AEAbfU5M8ARrU9JrbnOBmw
	3Jifu+U2MCL927h//nNePzQ5fAh0KAwAwQEMpOi8jFDtAetjtduJcoIF32FmQgh8DFYjaO
	3p6Gydj+LiIlqBh7cj0gkJmWEcB5H6w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772797819; a=rsa-sha256;
	cv=none;
	b=tRJFy3jd6CBq5htPsL3tWbwE5Zo37XPCxMyvdGAhjpBVRpXXG/fNaj/yX6THl4/p7tkTzL
	a830veVfIUHxCbpczfsPI6ORKe8HMKXIamLLUS6Ht/mqfCf7WiAlwii/vrax15/3dbybRR
	cwsYhAoQLcHlEocHTik241TudhMPK0E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fS4Sv3hh8zJ46cM;
	Fri,  6 Mar 2026 19:49:35 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 6FEE94056E;
	Fri,  6 Mar 2026 19:50:13 +0800 (CST)
Received: from [10.123.123.67] (10.123.123.67) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 6 Mar 2026 14:50:10 +0300
Message-ID: <902d821b-e903-4bf5-89db-070851c95a1a@h-partners.com>
Date: Fri, 6 Mar 2026 14:50:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: implement page refcount locking via dedicated bit
To: "David Hildenbrand (Arm)" <david@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan
	<ziy@nvidia.com>, Harry Yoo <harry.yoo@oracle.com>, Matthew Wilcox
	<willy@infradead.org>, Yu Zhao <yuzhao@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
	Gorbunov Ivan <gorbunov.ivan@h-partners.com>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Kiryl Shutsemau <kirill@shutemov.name>, Linus
 Torvalds <torvalds@linuxfoundation.org>, <gladyshev.ilya1@h-partners.com>
References: <cover.1772120327.git.gladyshev.ilya1@h-partners.com>
 <6bf6eba6e2e6a74e2045a3bd08d58fd91bece7be.1772120327.git.gladyshev.ilya1@h-partners.com>
 <f3c411e1-062e-4494-b7e9-8056f346effb@kernel.org>
 <a3361902-75bf-4e9e-a8c5-1959f9e72915@kernel.org>
Content-Language: en-US
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
In-Reply-To: <a3361902-75bf-4e9e-a8c5-1959f9e72915@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.67]
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: pj6sxuo3onct5j6j8q6u6t59j6o4h1qn
X-Rspam-User: 
X-Rspamd-Queue-Id: E9E4B2000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1772797818-22698
X-HE-Meta: U2FsdGVkX18jkY5O30V1wS3f6VtATT192JVEXpEobwhgWO2gYpSydo2/5KcUe+kBMp+uqxVUN786q0VQJXinaaml+S7mLay34AEHSh38L/Xwpd8WcP395dPe4Mype5XvhhgB24QbicZx1LmiTkchO728aYTUTd/QnefKvqTghI7SMAg2yYd2mlvYWbXju+lPkZYnXcB3e4X499K1AsKcMZd/REsP9zHgolPuDy0qz88Tjn0E3idVQjJIScsPp3QoVxRMnnZwWBjY2xMYNvRc0SMqfKQA+1IC/0blCjG1kiym3nNGVNjOIWRZZZB6DgCKa5nHbOQGoc8xHcOw82x+C8JGznJ3EOw3kiXFJdDNKk5U8mSMAJPOZ1QKbHaCSK2xnayDl0nJSyMi9GQ1zthX1J4H1uiZqdRVGy/LteFKSKIxy117MO8wxYU70EO9XwILek58CxVW0NZzf63aWISrgzyIKCp9IP1Y+zI2R+sT4GfgANlj5ay99IRuS0ghb9CVuYTeN+T399T5R+wJ8/FezOTBSGhfd/MXcarc9WMrnxyUrXhforlOnlp92Cs6450yn/PCtLgQt6o7PkfyQcBX3SrTOFeXyuNQ8STk7XFwXaLQp/zVrMJtmT7ZFjW5hEH9sZA23ofe4xalavHIMGdS/6DxkS2sVJ1lU561gBZqvccfJfHyxFOI4mb5xHpdAq2ifqlm0BW1dIH1KT5YGqVRaOGAluqUz5GC+x8vfyLeZS7YtZLTC3BVGvTIjUXw98Fvk3eGL8mGBYj2ux785JBOBa3Omq5rAGhQFLC1U1sx6fXE3dZVkQIW2vOC7y17ldhF54WVfzFAhVpneBfqiKC4mqmv0u/6D0J9iFd3/4mAbR5Y5VSxqq+UE8pKv2+gEXt8vnW6ynuOitEJWGZ2UsSpVtTDFTrPmGudd53+09FkIvOGdKQyjJBwbl564W8+49AdzFKM3JgHTbJL/dJv0jS
 sGX6PlP7
 3m/w+lNhq+jc9SHwXvyCGFnI4PMau5ucR/MIIEEA+lCT5Zq20KMs/jLQiEMIZ7rzuGN3XKIyICgfnyfDrZYFy7+NpA8DMQfpuX9Tixq+UWByxhbmLbgabKq9juARTptLJbHsbQnJ7dR6pPYjX1Lk7cP8MOm4FVMZve/t5iC78hldFgGZ3sadQ2hu7D3F9RXjShpEYSzdAD/9SMDYX2nZW3XfIjLavP6JMBPR8DEvEuLRaNuXiWvVn2hMAh4OhO5wOT1nb5i1+hxK/uIs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is combined reply to both of your emails, hope you don't mind

 >
 > This all made mu brain hurt a little 🙂
 >
 >>
 >>   /**
 >> @@ -176,6 +181,9 @@ static inline int page_ref_sub_and_test(struct 
page *page, int nr)
 >>   {
 >>       int ret = atomic_sub_and_test(nr, &page->_refcount);
 >>
 >> +    if (ret)
 >> +        ret = !atomic_cmpxchg_relaxed(&page->_refcount, 0, 
PAGEREF_LOCKED_BIT);
 >> +
 >
 > It took me a while to figure out why this can't be just an atomic_or():
 > even though concurrent page_ref_add_unless_zero() would see a 0 after
 > incrementing it to 1 to back off, there could be yet another concurrent
 > page_ref_add_unless_zero() that would see the transition from 1 to 2 and
 > continue.
 >
 > What is the performance impact on doing the additional
 > atomic_cmpxchg_relaxed() whenever we free a page, in particular, for
 > anonymous memory where we mostly have just a single reference that we
 > drop during munmap() etc?

I'll try to measure some numbers. Theoretically speaking, in 
low-contention scenario you will exclusively own cacheline after 
atomic_sub, so relaxed CAS should be cheap.

 >>       if (page_ref_tracepoint_active(page_ref_mod_and_test))
 >>           __page_ref_mod_and_test(page, -nr, ret);
 >>       return ret;
 >> @@ -204,6 +212,9 @@ static inline int page_ref_dec_and_test(struct 
page *page)
 >>   {
 >>       int ret = atomic_dec_and_test(&page->_refcount);
 >>
 >> +    if (ret)
 >> +        ret = !atomic_cmpxchg_relaxed(&page->_refcount, 0, 
PAGEREF_LOCKED_BIT);
 >> +
 >>       if (page_ref_tracepoint_active(page_ref_mod_and_test))
 >>           __page_ref_mod_and_test(page, -1, ret);
 >>       return ret;
 >> @@ -228,14 +239,23 @@ static inline int folio_ref_dec_return(struct 
folio *folio)
 >>       return page_ref_dec_return(&folio->page);
 >>   }
 >>
 >> +#define _PAGEREF_LOCKED_LIMIT    ((1 << 30) | PAGEREF_LOCKED_BIT)
 >> +
 >>   static inline bool page_ref_add_unless_zero(struct page *page, int nr)
 >>   {
 >>       bool ret = false;
 >> +    int val;
 >>
 >>       rcu_read_lock();
 >>       /* avoid writing to the vmemmap area being remapped */
 >> -    if (page_count_writable(page))
 >> -        ret = atomic_add_unless(&page->_refcount, nr, 0);
 >> +    if (page_count_writable(page)) {
 >> +        val = atomic_add_return(nr, &page->_refcount);
 >> +        ret = !(val & PAGEREF_LOCKED_BIT);
 >> +
 >> +        /* Undo atomic_add() if counter is locked and scary big */
 >> +        while (unlikely((unsigned int)val >= _PAGEREF_LOCKED_LIMIT))
 >> +            val = atomic_cmpxchg_relaxed(&page->_refcount, val, 
PAGEREF_LOCKED_BIT);
 >
 > I assume we can't do an atomic_dec(), because we might have concurrent
 > unfreezing (or similar things) happening that overwrote whatever was in
 > there.

Not only that, but also you probably don't want to handle "atomic_dec() 
returned 0" situations.

 > Is it really correct to replace _PAGEREF_LOCKED_LIMIT by
 > PAGEREF_LOCKED_BIT, dropping some unrelated references? I assume the
 > reasoning is that we treat any references with PAGEREF_LOCKED_BIT set as
 > irrelevant and can get overwritten any time.

Locked refcount doesn't contain any "references" except failed 
optimistic increments, so you are right that they don't hold any 
semantic meaning. The only reason to clear them is to prevent overflow, 
so we are doing it only if it is absolutely required.

 >
 > I was wondering is whether page_ref_freeze() could actually leave the
 > references set, and only set the PAGEREF_LOCKED_BIT bit, whereby
 > page_ref_unfreeze() would only clear the PAGEREF_LOCKED_BIT bit.
 >
 > Similarly, the set_page_refcounted() could add a reference and clear the
 > PAGEREF_LOCKED_BIT. That'd be more expensive on the allocation path ...
 > and not sure if that would really help to turn this
 > atomic_cmpxchg_relaxed() into an simpler atomic_dec() my brain could
 > more easily understand 🙂

I believe resetting whole counter via single CAS (CPU-wise) is cheaper 
than atomic_dec() for each individual attempt.

 >
 > I think this patch needs a lot more documentation around what the
 > PAGEREF_LOCKED_BIT means, and how this interacts with e.g., the
 > set_page_count() in set_page_refcounted().

Yep, I'll fix this

 > In general, I like this!
 >

 >>   static inline bool page_ref_add_unless_zero(struct page *page, int nr)
 >>   {
 >>       bool ret = false;
 >> +    int val;
 >>         rcu_read_lock();
 >>       /* avoid writing to the vmemmap area being remapped */
 >> -    if (page_count_writable(page))
 >> -        ret = atomic_add_unless(&page->_refcount, nr, 0);
 >> +    if (page_count_writable(page)) {
 >> +        val = atomic_add_return(nr, &page->_refcount);
 >> +        ret = !(val & PAGEREF_LOCKED_BIT);
 >> +
 >> +        /* Undo atomic_add() if counter is locked and scary big */
 >> +        while (unlikely((unsigned int)val >= _PAGEREF_LOCKED_LIMIT))
 >> +            val = atomic_cmpxchg_relaxed(&page->_refcount, val, 
PAGEREF_LOCKED_BIT);
 > It's still early here, but I think there is a problem.
 >
 > Please bear with me 🙂
 >
 >     val = atomic_add_return(nr, &page->_refcount);
 >     ret = !(val & PAGEREF_LOCKED_BIT);
 >
 > Implies that can grab a reference whenever the locked-bit is not set.
 >
 > Including when the refcount is 0.
 >
 > Now, that works fine when racing with concurrent freeing, where we are
 > just able to decrement the refcount, but yet have to set the
 > PAGEREF_LOCKED_BIT bit.
 >
 > But, what about any pages that don't have the PAGEREF_LOCKED_BIT set,
 > but have the refcount at 0 permanently?
 >
 > That's, for example, the case for any pages where we do an explicit
 > set_page_count(page, 0);
 >
 > For example, all pages we add to the page allocator through
 > __free_pages_core().

You are right that refcount = 0 is tricky. However, for a bad outcome 
you will need:
1. Some external reference to this page, through which you try to 
increment the refcount;
2. set_page_count(0) somewhere between freeing and "it is safe to alloc" 
state.

So adding new pages with zeroed refcount to allocator is safe, because 
there are no external references. Zeroing tail page's refcount is safe, 
unless someone actually tries to increment its refcount (and this is bug).

Generally, the only unsafe set_page_count() (or any other zeroing) will 
be in allocator itself between freeing and allocating. Or maybe I missed 
something, and this approach is indeed incorrect

Probably we can think of some debug checks to prevent bugs in "safe" 
scenarious

 > That means, that someone could easily grab a reference to such pages,
 > including tail pages of allocated compound pages where the refcount is
 > still 0 -- or pages allocated with a frozen refcount where we don't ever
 > do the set_page_refcount(1) in the buddy.
 >
 > Bad things will happen when that wrongly page_ref_add_unless_zero()
 > obtained reference is dropped again to free that page.
 >
 >
 > You'd have to make sure that there is no way we can achieve refcount ==
 > 0 without going through page_ref_dec_and_test(), when actually freeing a
 > page.
 >
 > One piece of the puzzle is handling set_page_count(p, 0) I think. But I
 > suspect that there might be other places where we don't even have the
 > set_page_count().
 >
 > See vmemmap_get_tail() in
 > https://lore.kernel.org/r/20260227194302.274384-13-kas@kernel.org for
 > example, where we know the refcount is 0, because we allocated the page
 > holding memmap with __GFP_ZERO.
 >
 > For example, I think you'd have to make sure that *any* pages in the
 > buddy have their refcount set to PAGEREF_LOCKED_BIT, not 0.
 >
 > So unless I am missing soemthing, this is broken an requires a lot of
 > care to make sure that refcount==0 is handled everywhere accordingly.
 >

---
Ilya

