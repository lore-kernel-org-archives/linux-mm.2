Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55964EEF317
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 08:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6736B008A; Thu,  5 Mar 2026 03:10:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A911E6B008C; Thu,  5 Mar 2026 03:10:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99A2B6B0092; Thu,  5 Mar 2026 03:10:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8128E6B008A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 03:10:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E086160917
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:10:28 +0000 (UTC)
X-FDA: 84511287336.25.117DADA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 65E8A140010
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:10:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hf0GhcmC;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772698226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=27xDI0OzOm+Uw2DiGLLj1itMk00kgtqkJJn67XrawGI=;
	b=ynLuktPyEqq0WMW5CT0NqfPXVwKS9i7ipoXfUEZU4yRF6JOCmX4NBvuzVV5k2IgS8kvb+R
	fkfqTKrIBlMkGZ6eb0wDPwjt1EwLatVoogOpy/TZXM9la0bbd4o0JHB3ffHZM0X9zlnI/R
	CXHP9bw63bZLbKDQqx6CqG/DU3KaX+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772698226; a=rsa-sha256;
	cv=none;
	b=3JbZh8GbzGTnmvU9Pktjo4pR7l9r8iCQyDnVKxrcZpwi8Ayk/V5i7rqb0hnoxCZTVV28uo
	1WPa3TQFl/KJbT1A6G4R79y23dwUbuc0OeRMzclQVDzR1e6rDQw36ZXo7sYLFHuvp/yuOH
	phHXwAzRDK9HP8cgQ3cDMbOjyAtk8m0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hf0GhcmC;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2855B4004F;
	Thu,  5 Mar 2026 08:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561B2C116C6;
	Thu,  5 Mar 2026 08:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772698225;
	bh=RqjdiY48OUHOd2QwKYyszdRCseuTxRO96sKHH0tQrvo=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=hf0GhcmC747zX8rypGDwwmmV03KZ+w/WGPy4I7T44VRtj/vV0kxZJ0YNbPPRDDwAT
	 leXV8jZtbgkNAV4eGC+1GxE75neH2nCAHiZE6XSwbHV/SSD6i+pdpiqPWeV+NdX2gl
	 xyd7zuSVrhoWIwMyioSWmpwI+lrq8SnLFAeGcAysa/6PF9XXJtZ5aW2grmd1fJlKNL
	 r7arDjbG+9Qf8tLT3hBRdKVIBUfnzu+OjZ5zqtjRuH0ykcyM4ouNAeFbTusfKuNK0b
	 JbxMTrK98eVNLEYBvpyzuDaxbHzMwW/pgMzhPH08NQ/oRn4rMyIJjQUmNSi1cqu2H6
	 r/78r4JrLqjRA==
Message-ID: <a3361902-75bf-4e9e-a8c5-1959f9e72915@kernel.org>
Date: Thu, 5 Mar 2026 09:10:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: implement page refcount locking via dedicated bit
From: "David Hildenbrand (Arm)" <david@kernel.org>
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
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f3c411e1-062e-4494-b7e9-8056f346effb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: bsdj5d5rq84j41hdiu1expdyuhsipxx8
X-Rspamd-Queue-Id: 65E8A140010
X-Rspamd-Server: rspam03
X-HE-Tag: 1772698226-618008
X-HE-Meta: U2FsdGVkX18zLzz/Gr9vptulOE1hlT0WLAbEKsqkpmwJZFmIm2xxxtqH2nTyTC2LJSaC6+0oWjwApm20PlOkHVd8D4tx7VO6W1OhYE3oE1pzkdL3TrxoeeAYhOPQ/nkA17kOQkK11m2fJN0DwLvCoH+CQe0sTD/J1xTyeB6SXLILY71ZbeVbW4K3jZGj12hn8DYeMhQ68nwWvz6+31pdlUaZ3w45IP6Urk3hhqZSr6hrD0tYy2jD+UUzkv2BFkEhRMdZOYIQsngZz33Avt2rAOqXeCeZb0dpgqZJwub+/M6WLEp1WSBycflirB4PdZi5wA7FzJmMMriowuoSaSo4NccdUrq9V0MV6KBLS9GFJh/SYokAuXkvWH0gScN+U2TERGuevdkEzm6MDwe1m/MW61C79Yk2X4k0XoXuauTpj1TfGmCrW02+SisM+7RiHZ0VYxXa90SXQ0bEixOTca5OPQCWBuxVdN1WTXIF7qTBqjoDDtFpplLANbwvIZsqCZ+ep7QZKz476wjp+v2bdXCiMAnDo7BlVelpfELSl1zLc6UKq/X2mskjAobK/RqGOSobekVUCm7qzX1bWyHkxd2JHSxSLaCdKA6Eqn+VrvGEvIJSXbHTi4iWYkB6FpSBwRpMhkmBut02qYXWGIhHi3hKk9uJRxXpPgPDBsfHl/lNKZ5iQVKQc8n+DsOF/prdX6dP7PgOcAc9utP72gBMSz2deesT+rP2gJWWhQaYLJjrN6ExV+VuqCaHf5pRS70Kx7hOR7lAfWrRI7i1qdKg5WeGOgw5e3tepbxf45iOD+X7ufBoLJcvW/dl22F57BkQgGHWb75nGwufQjzMdTUzEBxdyoy5yI0nR9lRotugEMNuc1xy697lRWQMtO22SHCq6YVPR7IfZQMkz6TFBU6ePP9WGzSrj07ho6X+/H3bnLRvCAVn//ZJv5S7kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>  	if (page_ref_tracepoint_active(page_ref_mod_and_test))
>>  		__page_ref_mod_and_test(page, -nr, ret);
>>  	return ret;
>> @@ -204,6 +212,9 @@ static inline int page_ref_dec_and_test(struct page *page)
>>  {
>>  	int ret = atomic_dec_and_test(&page->_refcount);
>>  
>> +	if (ret)
>> +		ret = !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_LOCKED_BIT);
>> +
>>  	if (page_ref_tracepoint_active(page_ref_mod_and_test))
>>  		__page_ref_mod_and_test(page, -1, ret);
>>  	return ret;
>> @@ -228,14 +239,23 @@ static inline int folio_ref_dec_return(struct folio *folio)
>>  	return page_ref_dec_return(&folio->page);
>>  }
>>  
>> +#define _PAGEREF_LOCKED_LIMIT	((1 << 30) | PAGEREF_LOCKED_BIT)
>> +
>>  static inline bool page_ref_add_unless_zero(struct page *page, int nr)
>>  {
>>  	bool ret = false;
>> +	int val;
>>  
>>  	rcu_read_lock();
>>  	/* avoid writing to the vmemmap area being remapped */
>> -	if (page_count_writable(page))
>> -		ret = atomic_add_unless(&page->_refcount, nr, 0);
>> +	if (page_count_writable(page)) {
>> +		val = atomic_add_return(nr, &page->_refcount);
>> +		ret = !(val & PAGEREF_LOCKED_BIT);
>> +
>> +		/* Undo atomic_add() if counter is locked and scary big */
>> +		while (unlikely((unsigned int)val >= _PAGEREF_LOCKED_LIMIT))
>> +			val = atomic_cmpxchg_relaxed(&page->_refcount, val, PAGEREF_LOCKED_BIT);
It's still early here, but I think there is a problem.

Please bear with me :)

	val = atomic_add_return(nr, &page->_refcount);
	ret = !(val & PAGEREF_LOCKED_BIT);

Implies that can grab a reference whenever the locked-bit is not set.

Including when the refcount is 0.

Now, that works fine when racing with concurrent freeing, where we are
just able to decrement the refcount, but yet have to set the
PAGEREF_LOCKED_BIT bit.

But, what about any pages that don't have the PAGEREF_LOCKED_BIT set,
but have the refcount at 0 permanently?

That's, for example, the case for any pages where we do an explicit
set_page_count(page, 0);

For example, all pages we add to the page allocator through
__free_pages_core().

That means, that someone could easily grab a reference to such pages,
including tail pages of allocated compound pages where the refcount is
still 0 -- or pages allocated with a frozen refcount where we don't ever
do the set_page_refcount(1) in the buddy.

Bad things will happen when that wrongly page_ref_add_unless_zero()
obtained reference is dropped again to free that page.


You'd have to make sure that there is no way we can achieve refcount ==
0 without going through page_ref_dec_and_test(), when actually freeing a
page.

One piece of the puzzle is handling set_page_count(p, 0) I think. But I
suspect that there might be other places where we don't even have the
set_page_count().

See vmemmap_get_tail() in
https://lore.kernel.org/r/20260227194302.274384-13-kas@kernel.org for
example, where we know the refcount is 0, because we allocated the page
holding memmap with __GFP_ZERO.

For example, I think you'd have to make sure that *any* pages in the
buddy have their refcount set to PAGEREF_LOCKED_BIT, not 0.

So unless I am missing soemthing, this is broken an requires a lot of
care to make sure that refcount==0 is handled everywhere accordingly.

-- 
Cheers,

David

