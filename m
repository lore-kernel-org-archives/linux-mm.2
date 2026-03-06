Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C631EF01832
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 13:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40BF6B008C; Fri,  6 Mar 2026 08:10:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEEBF6B0092; Fri,  6 Mar 2026 08:10:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC3DC6B0093; Fri,  6 Mar 2026 08:10:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C7E2C6B008C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:10:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6573D592C2
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:10:17 +0000 (UTC)
X-FDA: 84515671674.02.8B56643
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A82D34000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:10:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPktBZVB;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772802615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gp4QZ2wxY+gYbrvECxbnbJG/BDfCcjvw3OegdBalhRU=;
	b=08UlFQ2HtWj+zu/VhNBswWMIcyRRqZ5ngbQVzVPIAFVDiMRqY339i6SJCNhetRLZYuWJpU
	lDpGpzvg6+pqjOYOGF5U64Bid8fz5c17AZOI5RWZfvdmEc+XAUvWr6/KXKiU/UQiOE5GvK
	t51E0apoS+mO5QYxCOWJVQPjD96/e9Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772802615; a=rsa-sha256;
	cv=none;
	b=FIXrnDqfT8mFHmPL+RID+8Jgye7duWgZyu3wIH3vx0S7znj85wQMXlZMnFu7JORW7ZfrUD
	ALpvp2FiBW/ExOpB4yyBPo28Peu3a4Uf9AWGNpkN2zh74xSpCI46Nsv62MufPeKIKC+CYs
	MHHH8gBqDXxloDHWdf+cM553t4DzTXM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPktBZVB;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B6F860127;
	Fri,  6 Mar 2026 13:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B553AC4CEF7;
	Fri,  6 Mar 2026 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772802614;
	bh=61lGynqWixTzQYwyPA6ZFruK9XjY6xGcpOGYFOEIcyc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KPktBZVBidCYe4HR1PJvnvJ4qUzMyGkpu6Be2Y9L7neKHTFr5deLppeg5Usp5CcFn
	 G1xhlgut9NR5gDZEHJmBit5FVSjzf3X76Nb7LnQyN35Ft0gouVBdVEsyB36llo5Zzi
	 9qk0B38nIVyK4fiAgXGOgD0NVao8jFSZubPSKnW1XSGviHuLx6FeBwUdiB6DRLffvy
	 8xyKvkDNPjO2rI8g22Xd/Z3T2zjrluHSr/0LBJmdtmGggj66MJ/X4kS5+cxJOhYwwC
	 c2E/+ZIWIkisnuUYp/eA0pvLh2R4I5c7K4Y2GfGXzB8rDTizwS4QV+IijlK79bhVfp
	 40P+OQ6e7J5PQ==
Message-ID: <54cc6e6d-bda7-4c5b-a998-df854ead1985@kernel.org>
Date: Fri, 6 Mar 2026 14:10:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: implement page refcount locking via dedicated bit
To: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Harry Yoo <harry.yoo@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Yu Zhao <yuzhao@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Gorbunov Ivan <gorbunov.ivan@h-partners.com>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kiryl Shutsemau <kirill@shutemov.name>,
 Linus Torvalds <torvalds@linuxfoundation.org>
References: <cover.1772120327.git.gladyshev.ilya1@h-partners.com>
 <6bf6eba6e2e6a74e2045a3bd08d58fd91bece7be.1772120327.git.gladyshev.ilya1@h-partners.com>
 <f3c411e1-062e-4494-b7e9-8056f346effb@kernel.org>
 <a3361902-75bf-4e9e-a8c5-1959f9e72915@kernel.org>
 <902d821b-e903-4bf5-89db-070851c95a1a@h-partners.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <902d821b-e903-4bf5-89db-070851c95a1a@h-partners.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: irbbjzmnqow9dngqkqkp157jg4ixq7cn
X-Rspamd-Queue-Id: A82D34000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1772802615-265131
X-HE-Meta: U2FsdGVkX19mAejws3BPV2Nb7SGxM5kf4Ll6130EblO2QiKZTGxVov/qCOVqdy0pjs9y48SBemkUky7OazwjR4TeaSKm/FRlpovrPmaZ8n5Yu8ZJiZuBmK4e99g0ir0SQVzgk49eVe5ap7to7f9IyWd/IW7ypF6kYo/E2psArcxzUHC/6ZAI+pfOW5pWmV2CXNn1juIIJsL6IaGFzwipGqia3UuYK748NjbA7tI8TeQPwtzdS3CijqzgN2hB1Ba+WBG6Bx7kPDPEskHlvPnSXqjCKr/q2mkAXS2uheNhWtSW1dorOlURX7DE+aR2zZ0hW8S/5NQveMF6I0l+spQe5UzlZfdIl33MNw8cIa9SGc9VIml2f4dGNX3MK3hDRlDc73FjhIG50pFZS7Wj+akNT1M497ZXC0j+yLf9DUGXsLvRCElHqubN1dH8o5ne56BCa6C0pLRQJ1j9unpMDlBgVErGfn2QxWqSpf50Wh12j7+Texad9wOoeQhC4hBVtpsk3LctyrN6IOOG2MmtWll/E09faz7bWIm8/xMVPcTf/aDCYLgDo5b70B1a77pP8XL5GC0Wq6s9rm4X6fmOhtvkw6pdQ7UMUIWgHyBJa/xmk2RruHLHMzMjkhkiIf42LVRyr53IACvefPYBfm5gwRt1L7Je0VIy79G7ZvlySW296qfWJDhTPI2FDpfqmTHqgjhaF19VEuh4Ch+xh6QGMeKh+dJLXfElA0d/DdpLemXdLuuuvRohGPZh3G+iuy8SfQahN+MEuIW9iaRO+bsq13zgd3fq1XL+OQDvhDGXxkXPsfgnwbAsFgnkul3dXuzeoRmE31uOuTx6Uh3QYyZelIK4XgSknaz9wLI5RQOK6IdtrbGbFAl0e3V6mHVFy9qrduUOdWU/KceIEq3TYhLRXxFdC0xWf7fthxDv2TnfhUXdAyqK2o+1jpqPezl0fQ/pPCUf4AS9aG41GDjlpTIlSG3
 p7cRVNpX
 AmIpPorHhDVYzJCyUdOJY7vR/QfdzSzdsCmJ4VRjh5BP2A7HgCRwOjZLAEu3oMlJoo/b9+uI+gGmCxvoGTjI/gWDaw8wIv/mGwalxI2GU56TEHg2SC2k/puVDFO9cxEBHKDhCbfWcaGP26Pc9U9f8ZndfUGdb28MWpGMSqImSL+phuyMS1KcIuMwcEb84Nt6F576kICDduf0mt1yfYut/P2TdcbJVnSvDDAdJmuQqRrrEFbjsn/+Rl8mAr/SKGkWYmS/1xEzIZrd1MFZieRsAHBVEY3orXJYUQXT0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>
>>>       rcu_read_lock();
>>>       /* avoid writing to the vmemmap area being remapped */
>>> -    if (page_count_writable(page))
>>> -        ret = atomic_add_unless(&page->_refcount, nr, 0);
>>> +    if (page_count_writable(page)) {
>>> +        val = atomic_add_return(nr, &page->_refcount);
>>> +        ret = !(val & PAGEREF_LOCKED_BIT);
>>> +
>>> +        /* Undo atomic_add() if counter is locked and scary big */
>>> +        while (unlikely((unsigned int)val >= _PAGEREF_LOCKED_LIMIT))
>>> +            val = atomic_cmpxchg_relaxed(&page->_refcount, val,
> PAGEREF_LOCKED_BIT);
>>
>> I assume we can't do an atomic_dec(), because we might have concurrent
>> unfreezing (or similar things) happening that overwrote whatever was in
>> there.
> 
> Not only that, but also you probably don't want to handle "atomic_dec()
> returned 0" situations.

Right, and then we'd have to free the page here instead, which is rather
awkward.


>>
>> I was wondering is whether page_ref_freeze() could actually leave the
>> references set, and only set the PAGEREF_LOCKED_BIT bit, whereby
>> page_ref_unfreeze() would only clear the PAGEREF_LOCKED_BIT bit.
>>
>> Similarly, the set_page_refcounted() could add a reference and clear the
>> PAGEREF_LOCKED_BIT. That'd be more expensive on the allocation path ...
>> and not sure if that would really help to turn this
>> atomic_cmpxchg_relaxed() into an simpler atomic_dec() my brain could
>> more easily understand 🙂
> 
> I believe resetting whole counter via single CAS (CPU-wise) is cheaper
> than atomic_dec() for each individual attempt.
> 

Right, that's what I meant with "more expensive".

[...]

>>
>> For example, all pages we add to the page allocator through
>> __free_pages_core().
> 
> You are right that refcount = 0 is tricky. However, for a bad outcome
> you will need:
> 1. Some external reference to this page, through which you try to
> increment the refcount;
> 2. set_page_count(0) somewhere between freeing and "it is safe to alloc"
> state.

That is way, way, way too dodgy.

What you should likely do is

(a) Make set_page_count(0) set it to PAGEREF_LOCKED_BIT
(b) Make any places that might skip set_page_count(0) to use it
(c) Document this all extremely thoroughly.

Alternatively, disallow set_page_count(0) ccompletely and add something
like "initialize_page_as_frozen()" or sth. like that.


A refcount of 0 must really only be temporarily allowed in the system
when transitioning from 0 to PAGEREF_LOCKED_BIT. Otherwise this just
screams for trouble.

> 
> So adding new pages with zeroed refcount to allocator is safe, because
> there are no external references. Zeroing tail page's refcount is safe,
> unless someone actually tries to increment its refcount (and this is bug).
> 
> Generally, the only unsafe set_page_count() (or any other zeroing) will
> be in allocator itself between freeing and allocating. Or maybe I missed
> something, and this approach is indeed incorrect
> 
> Probably we can think of some debug checks to prevent bugs in "safe"
> scenarious

Just take a look at do_migrate_range(), where we do a

page = pfn_to_page(pfn);
folio = page_folio(page);

if (!folio_try_get(folio))
	continue;

If that is a page that was added to the buddy (set_page_count(0)) but
either (a) not allocated yet or (b) allocated as frozen that's a problem.

We really rely on

(1) Frozen pages
(2) Buddy pages
(3) Tail pages (compound or non-compoud)

To have a refcount of 0 that *reliably* makes folio_try_get() etc. fail.

Anything else is just playing with fire.

-- 
Cheers,

David

