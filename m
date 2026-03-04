Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E2EEFCE39
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 19:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3045F6B0005; Wed,  4 Mar 2026 14:16:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1F16B0088; Wed,  4 Mar 2026 14:16:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189936B0089; Wed,  4 Mar 2026 14:16:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A86E6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:16:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B67CB1403A6
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:16:36 +0000 (UTC)
X-FDA: 84509337192.18.E8F7537
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BE81DC0003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:16:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Hw1uX/ba";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772651795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9LUIUhEQ/MBNT3CBy+FExFIuXbi10MVhZL5K0MEXVoM=;
	b=1/UCX8P4eNS+i+zFVPkO/E+CDtFhBbKhGtDHTy3HN+XlFo8YGMbi2x7DrX3f5BgJACctTQ
	IkStAddEHVPqqq8ald1TmPgpR2EhPmkmMckOov7xI9NRhDGF5vMjZlCp5VCltWX1y49Osc
	Zpuuv++Zb/tvIIymYzrMhbsnF8dO3s4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Hw1uX/ba";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772651795; a=rsa-sha256;
	cv=none;
	b=nlKkkWJknrjrCP77FrfDwEioSC6zUcDYESDxI3Md2R6jf+Qkr2KqJg2wuqWetBsiiu3HCL
	nzX8NR4f3zSE/rzTerALl14h36N9DZ1G3bzB1VHXiNsDIe+5JgZcAdipxhD88h3+iDsjx5
	ObPV9nTXSGePwszFKo925sFiQIy7SYM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DD4143D35;
	Wed,  4 Mar 2026 19:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4831C4CEF7;
	Wed,  4 Mar 2026 19:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772651793;
	bh=7rUPpgokgbaSU3rIz/IH3gMaIW1UQ9YfdPMn576eNtk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Hw1uX/barYICCyEM7B8C3vo1+KRZJfyPlMb8ducnLmhE49Dup1bECeZGlnljBXQ23
	 89g473DgHrINwx4Hw4KQQq8YohjH0VnXyrYgP+wrS7AR1xjw1m7pw4K2KMpDwgRoRZ
	 R1x/296aUoNdor/3IuFkNtoX4bUWxvUv/oPrp5+Xw1H8+gjBCXI9jxzuY/7V7JBHNQ
	 3rqYAdY2psj820zRvZczFZ1/MrsYbSAlVDTXdM1JzH527WATvxvszKQ75TYVSNnGeX
	 9ud4TNRUHKAfa5P1E80r1eJvLcaJvtVL3MnpvExMSuWgS/CYk6oepWSH4JK66mugrG
	 3B7kAM+GJX/HQ==
Message-ID: <f3c411e1-062e-4494-b7e9-8056f346effb@kernel.org>
Date: Wed, 4 Mar 2026 20:16:24 +0100
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
 linux-kernel@vger.kernel.org, Kiryl Shutsemau <kirill@shutemov.name>
References: <cover.1772120327.git.gladyshev.ilya1@h-partners.com>
 <6bf6eba6e2e6a74e2045a3bd08d58fd91bece7be.1772120327.git.gladyshev.ilya1@h-partners.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6bf6eba6e2e6a74e2045a3bd08d58fd91bece7be.1772120327.git.gladyshev.ilya1@h-partners.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BE81DC0003
X-Rspamd-Server: rspam08
X-Stat-Signature: 3a8ucg7qerf9ua1shno3bhorag7q8whw
X-HE-Tag: 1772651794-593017
X-HE-Meta: U2FsdGVkX1+k5vxY52DJXaqtbhHj/viQNLrx1+cTy8NsqWudY290D5cUUsJ4tmdJHRk7PGFVVnjYKZuumS80TYWKiQJ2N3xy0TpwbbxaiG0v4jB+CalmQ4lEo8PtsU5qgM6YlLo4XGQrtbYVqzy/xh8KlkDvngEY64SfQP2xenVyW361ONCP0WxGyjWtWqJZ/gY/VFBqOK0pts2FUwjy2H5HSotnO76Vn+XLTB2wnUHyaE/3i/3/sirItamUkh9JpaqRu1/SdW805xuKBJGyoKRo4pwCs3ZMud0kDc4lG5ZIZTPGxXpahrZe8qU/KXx4AMZIw2jsGeJGuTCB3hAqgZELxT4zHFNaFmO3e+0OXXhscdYOt902UbnNwlsC3CxbZWaa279fcSnufqrtQ9St35BEvCNcLe3cprM7vio59lFtJTCzYIM4WHCG/v4iRTPsE10VEOlFVTqr1Jqo1+Lg6/RWMx7Mos6D8sDiTf9lzVrHKuMQ5DyRX04ttwLUcbVa/aljnZRL5IPoR2w+XbANDRsZWUUPrw/E3Gx7eZk45MAvCQK+dRWSc5Hb+wR3jc3eAwMMQL9CH86rMd6NGCZj6WVVu09XnbJoS8/nmZuY9bCWwp1zZmbAjEyFhfeMuzMjtarO+ppxcIyO/FsjFqHeXXGDE7prFWFYpt3/xDCiMbbgdTretvfuHN/xqcd9moCHLC0/EM6HGrQ6j62cQ9vF2Gq5C32uriwtoVBu1knnaq6UmvEjJ3ZI2JNocUb5CPELpdmay2SXcPDg6/eMc+1rL/OzmUc5mFqlskDMoydupq8Ezpi1geTJ3Kb/tqCC72gL9AhGjcvs4i2M4a+LAyB1bCBC4mZ4wXtepkrV9EZV2o9OVyAq0Ev6Y/bknYKRubebjo2pisNXTgmyIKiR+tY91cO1kvy9M9/GGAjYLnPxuJ/FANtk2rTzrwDJc3is0F9L83mkzPbFkH0TJXHRJgq
 iVjvmd+G
 V6l9IgiUMlOY/B5DzOUSiYt0H7g3O5RLsxlzBwpRaRNwXNQ97oeyN5B4kCJ33odGGl/lwj0hhJ3I8/y+zVWHKfvdbWuXRKIVaHP4H0MTYFMBBEzSOra8ej26a7y3cBnGfC251duNBMBrqN5ALp/1CeGVPKPeUmzjgRvdZvWg4ZnsArL6e7xgAwSztyyWqoKtmha7CH82KLILVmOKxUu9LXO+h2TgRotJOncpq2dtzhxjb2h0NIcq+7RcMywTEDDylV2O5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This all made mu brain hurt a little :)

>  
>  /**
> @@ -176,6 +181,9 @@ static inline int page_ref_sub_and_test(struct page *page, int nr)
>  {
>  	int ret = atomic_sub_and_test(nr, &page->_refcount);
>  
> +	if (ret)
> +		ret = !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_LOCKED_BIT);
> +

It took me a while to figure out why this can't be just an atomic_or():
even though concurrent page_ref_add_unless_zero() would see a 0 after
incrementing it to 1 to back off, there could be yet another concurrent
page_ref_add_unless_zero() that would see the transition from 1 to 2 and
continue.

What is the performance impact on doing the additional
atomic_cmpxchg_relaxed() whenever we free a page, in particular, for
anonymous memory where we mostly have just a single reference that we
drop during munmap() etc?

>  	if (page_ref_tracepoint_active(page_ref_mod_and_test))
>  		__page_ref_mod_and_test(page, -nr, ret);
>  	return ret;
> @@ -204,6 +212,9 @@ static inline int page_ref_dec_and_test(struct page *page)
>  {
>  	int ret = atomic_dec_and_test(&page->_refcount);
>  
> +	if (ret)
> +		ret = !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_LOCKED_BIT);
> +
>  	if (page_ref_tracepoint_active(page_ref_mod_and_test))
>  		__page_ref_mod_and_test(page, -1, ret);
>  	return ret;
> @@ -228,14 +239,23 @@ static inline int folio_ref_dec_return(struct folio *folio)
>  	return page_ref_dec_return(&folio->page);
>  }
>  
> +#define _PAGEREF_LOCKED_LIMIT	((1 << 30) | PAGEREF_LOCKED_BIT)
> +
>  static inline bool page_ref_add_unless_zero(struct page *page, int nr)
>  {
>  	bool ret = false;
> +	int val;
>  
>  	rcu_read_lock();
>  	/* avoid writing to the vmemmap area being remapped */
> -	if (page_count_writable(page))
> -		ret = atomic_add_unless(&page->_refcount, nr, 0);
> +	if (page_count_writable(page)) {
> +		val = atomic_add_return(nr, &page->_refcount);
> +		ret = !(val & PAGEREF_LOCKED_BIT);
> +
> +		/* Undo atomic_add() if counter is locked and scary big */
> +		while (unlikely((unsigned int)val >= _PAGEREF_LOCKED_LIMIT))
> +			val = atomic_cmpxchg_relaxed(&page->_refcount, val, PAGEREF_LOCKED_BIT);

I assume we can't do an atomic_dec(), because we might have concurrent
unfreezing (or similar things) happening that overwrote whatever was in
there.

Is it really correct to replace _PAGEREF_LOCKED_LIMIT by
PAGEREF_LOCKED_BIT, dropping some unrelated references? I assume the
reasoning is that we treat any references with PAGEREF_LOCKED_BIT set as
irrelevant and can get overwritten any time.


I was wondering is whether page_ref_freeze() could actually leave the
references set, and only set the PAGEREF_LOCKED_BIT bit, whereby
page_ref_unfreeze() would only clear the PAGEREF_LOCKED_BIT bit.

Similarly, the set_page_refcounted() could add a reference and clear the
PAGEREF_LOCKED_BIT. That'd be more expensive on the allocation path ...
and not sure if that would really help to turn this
atomic_cmpxchg_relaxed() into an simpler atomic_dec() my brain could
more easily understand :)


I think this patch needs a lot more documentation around what the
PAGEREF_LOCKED_BIT means, and how this interacts with e.g., the
set_page_count() in set_page_refcounted().

In general, I like this!

-- 
Cheers,

David

