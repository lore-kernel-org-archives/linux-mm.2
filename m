Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AB14F33A92
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 14:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 213966B0005; Fri,  6 Mar 2026 09:29:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F4466B0089; Fri,  6 Mar 2026 09:29:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 121A36B008A; Fri,  6 Mar 2026 09:29:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F38396B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:29:27 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A66131C460
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:29:27 +0000 (UTC)
X-FDA: 84515871174.06.C5DC767
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id BCCCF40006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:29:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772807365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FIafwMg5yexn5QzVKW2ay6Ytq2x8bTi71eCcoEbYBMc=;
	b=nWAoABo3tC1b8ZXfVlW846z8ylPE1tY+b6yyogCECEiCquuj9bws37jCzoHsGqzpbo8x7y
	MJqacuirjmDwpC6v07jyijKR7y2pxyz+N8zG5G7PDU8FiWgy/M44itdfRdaMCfdfIgm33W
	9wB0ae+7BaRHwvu9NEGiDxY6vo5fnFQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772807365; a=rsa-sha256;
	cv=none;
	b=cHp4ATSwDiIqoOsEa4QMD95DLro2VHBvuvJhWNNzscctXQrYn5NfqKccCvRdWZQL0J1ZYQ
	rjKfZ+01ZfK80k4n4AYrFW+nXU+ztpVTXvm2SRckDj0w7UQk6bp7vFwQKPAUqkQP9gpuUM
	VJvCbdtAovnhY809c7h7ejcFnituwrM=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fS8060CqPzHnH5f;
	Fri,  6 Mar 2026 22:28:22 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id CEF4740086;
	Fri,  6 Mar 2026 22:29:21 +0800 (CST)
Received: from [10.123.123.67] (10.123.123.67) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 6 Mar 2026 17:29:18 +0300
Message-ID: <75aa8f34-4d91-4758-847d-248a5be3db62@h-partners.com>
Date: Fri, 6 Mar 2026 17:29:15 +0300
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
 Torvalds <torvalds@linuxfoundation.org>
References: <cover.1772120327.git.gladyshev.ilya1@h-partners.com>
 <6bf6eba6e2e6a74e2045a3bd08d58fd91bece7be.1772120327.git.gladyshev.ilya1@h-partners.com>
 <f3c411e1-062e-4494-b7e9-8056f346effb@kernel.org>
 <a3361902-75bf-4e9e-a8c5-1959f9e72915@kernel.org>
 <902d821b-e903-4bf5-89db-070851c95a1a@h-partners.com>
 <54cc6e6d-bda7-4c5b-a998-df854ead1985@kernel.org>
Content-Language: en-US
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
In-Reply-To: <54cc6e6d-bda7-4c5b-a998-df854ead1985@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.67]
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: BCCCF40006
X-Rspamd-Server: rspam07
X-Stat-Signature: sn7cednghm1uqw3b7mwsrmue8jor91pa
X-Rspam-User: 
X-HE-Tag: 1772807364-446226
X-HE-Meta: U2FsdGVkX1/f/VA0fBclhWy+UNCKBABRaWXpitmbMoUbWsWTF+J+MX9KQwP3wv87SAMKg0SZFtS2+HKRb3lih2pvk4fmc/ufzSonghaLXbmcBMBFqE4yo5BwZS+JqSJ72K0pzJUnDH9S/Cs0AKvmnj3PAiR+aaky+O57URPv66DApFZtmLCv+vF+vTvTJIz/e2nrWj8e08WZ6t+D3KZhwDelPL6QzeT60Esd2aFMPxFDJv/SGTWFmDZFJwTz/lUORHC8KFb9wJBKD34cFySwJUVIZu1U3pQshzdlBTz67YBCIxUJelbmZX/Wv2EqVku9FJo2ZI6rHFaEBQwDDGks4L4DrZXPfVZ9dkj5F+VQbgLfFDVAEJ0buZQo5dkv71wK952xBbkV99J44O4voBvZv9DfZxQWRutHOyYbLXF8CeJiqJaAfdnnMrzafScH8VfAYGKQqQcWoqNaj7w7708OixJyev4UbOecIyfNxCkZtmpaAZm96nuoDd6A01/QHcjhu375vtfKZbOgAFrnUu3l2JY4CFRxBW9nBBLmo9E0MQrI0e1Bm2ngDN63eyYg7cTZHgVIe+eAo8i0VC7Oh0/Tbq+aIGGSEf5w5TKg+vOtFZ0t0FHtFd3lXatIAmtUGVeq38cyAIGM5fKRMr3JPj0EoBUzW/aaC0UtagFfmaXhKhTuXaOCDv4tkUUQcK93MioJSmqTg0FYTlnxJQhjMe+CbdiG1rcEb29+LBRRFQdr/6EvbQJo3DHxvFKvqT+ssG+Lbtj4b4NHIsXKT1u1sGwr+uZkFxEdwKgm+hmeJXLmSkquZ/s2VoQY4QIAfCPFu64DuQnQT5SriV+1T1cnsflKu+fr4Ir+s8NRvXLHS1idwDru5zE7HsxlKL2gYsZEO3eWsxb5iB8GuJE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> For example, all pages we add to the page allocator through
>>> __free_pages_core().
>>
>> You are right that refcount = 0 is tricky. However, for a bad outcome
>> you will need:
>> 1. Some external reference to this page, through which you try to
>> increment the refcount;
>> 2. set_page_count(0) somewhere between freeing and "it is safe to alloc"
>> state.
> 
> That is way, way, way too dodgy.
> 
> What you should likely do is
> 
> (a) Make set_page_count(0) set it to PAGEREF_LOCKED_BIT
> (b) Make any places that might skip set_page_count(0) to use it
> (c) Document this all extremely thoroughly.
Okay, I agree. My reasoning was more about "it's not _that_ bad if we 
miss something outside the allocator" than "everything is fine as it 
is", but maybe it is really that bad...

> Alternatively, disallow set_page_count(0) ccompletely and add something
> like "initialize_page_as_frozen()" or sth. like that.

(Below are my thoughts, not active proposal)

Actually, we can keep "zero is locked" property if we change scheme a 
little:

If we invert locked bit so that 0 means locked, then we don't care about 
memset() / GFP_ZERO / set_page(0). But then there is extra bit on each 
active refcount, and (un)masking will be required on each refcount 
read/set/etc operation.

We can place locked bit in the highest bit like now, or move it to the 
lowest. This doesn't make any difference except for how masking is 
performed (and or shift). I can't really tell which approach is faster 
(and more optimizable after inline).

This approach doesn't look appealing to me, mostly because of redundant 
masking. So for now I will try to add proper initialization / 
documentation in all risky places.
>> So adding new pages with zeroed refcount to allocator is safe, because
>> there are no external references. Zeroing tail page's refcount is safe,
>> unless someone actually tries to increment its refcount (and this is bug).
>>
>> Generally, the only unsafe set_page_count() (or any other zeroing) will
>> be in allocator itself between freeing and allocating. Or maybe I missed
>> something, and this approach is indeed incorrect
>>
>> Probably we can think of some debug checks to prevent bugs in "safe"
>> scenarious
> 
> Just take a look at do_migrate_range(), where we do a
> 
> page = pfn_to_page(pfn);
> folio = page_folio(page);
> 
> if (!folio_try_get(folio))
> 	continue;
> 
> If that is a page that was added to the buddy (set_page_count(0)) but
> either (a) not allocated yet or (b) allocated as frozen that's a problem.
> 
> We really rely on
> 
> (1) Frozen pages
> (2) Buddy pages
> (3) Tail pages (compound or non-compoud)
 >
> To have a refcount of 0 that *reliably* makes folio_try_get() etc. fail.
> 
> Anything else is just playing with fire.
>

