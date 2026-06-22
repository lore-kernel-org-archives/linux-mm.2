Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 723A1CDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 07:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FE256B0088; Mon, 22 Jun 2026 03:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF476B008A; Mon, 22 Jun 2026 03:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252EA6B008C; Mon, 22 Jun 2026 03:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF1C26B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:55:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7CD711A05C7
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:55:51 +0000 (UTC)
X-FDA: 84906789702.29.C6D38B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C3FA740012
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:55:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=czajZs6y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782114949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PI6SCYr5oDI+dmRba23U6uw1UDjQEl4kT/Lv5kvNOWU=;
	b=FPDaM91UEx1v1cDRo/hBsBwEHM9oa+H+RM9uHdGGpRKzkQOcX7LLx2Gv58Pep7duiBGoe4
	LwcmGObHsOMEodyoUlpWLn/NDEoFkVjvvvc5qIbrY+HK3J9Fd4sTR01BxhFJI5BQhmJhpg
	Lix7naK6smN80ve87Jes6XjcM+P6wyo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=czajZs6y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782114949;
	b=OYQQYu1OL4fJLEt4ld5sIZXCQXHMQ/wk+8BuOg6iSJMj/J9G2pJjPe60C4hG3MUfZgiN/P
	vRRWsCKqMyFVVVz0+c3aSWDhOg9wXYoP+I+I1bpk0PFqKhhxRVjk4fjgXHimNSim12y4H+
	KFz2zxP9rzGVlvXsgvr17SQ2ZgqhCb4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C5C860051;
	Mon, 22 Jun 2026 07:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8321F000E9;
	Mon, 22 Jun 2026 07:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782114948;
	bh=PI6SCYr5oDI+dmRba23U6uw1UDjQEl4kT/Lv5kvNOWU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=czajZs6yEfQODRWp3l7euZ0tzsVCGwORupONsIcPqZXgDJm6CuPyAMkTXa/n9rffc
	 Y+ml8ZcgQOJWVanBoyzTFlbnXBa6VDnXVxMFtV62KFZzkTVjNOnzbOglpk+wDoCbIh
	 j2D1PAdf9RafGBD+6rzndI/LHbvl+URMqkBU7A4xEN8dFWff3nzru5xAKWJSrt/QUK
	 QCFEXPZQx24mcMDPEUdU74U8VNfQ1ZwON5cW+f47Mhuilm+Ap8fxOlhO1VEBhj58BI
	 ZC0JimVqciTQmp1to9HgN2RZjDLbNLMI8XZbjKBhI6wHzXlTPN71eoOvCETLprEu+M
	 GwNWoeH6bnTeg==
Message-ID: <6d576c2a-af34-493c-bccb-cf2e035e6506@kernel.org>
Date: Mon, 22 Jun 2026 09:55:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] mm: improve folio refcount scalability
To: Zi Yan <ziy@nvidia.com>, ilya.gladyshev@linux.dev,
 Andrew Morton <akpm@linux-foundation.org>
Cc: ivgorbunov@me.com, Liam.Howlett@oracle.com, apopple@nvidia.com,
 artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com, foxido@foxido.dev,
 harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 rppt@kernel.org, surenb@google.com, torvalds@linuxfoundation.org,
 vbabka@suse.cz, willy@infradead.org, yuzhao@google.com, pfalcato@suse.de,
 kirill@shutemov.name
References: <df26082871b4c65b2bd38d409026237c08572836@linux.dev>
 <20260608154734.8e4115fde4e2e14a3b6892fb@linux-foundation.org>
 <fe53d9a75f776a5e002a3375d086c5714f558547@linux.dev>
 <DJECF2107V6T.23HGJJJ8ECKJ9@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DJECF2107V6T.23HGJJJ8ECKJ9@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3FA740012
X-Stat-Signature: i6pebnx17sisb6zrnsmkexydfax5sy3m
X-Rspam-User: 
X-HE-Tag: 1782114949-773349
X-HE-Meta: U2FsdGVkX1+4QH+cI/amXbJEu8rM3rXPXkQyRfQrv5xR51Ba0gHWZadAfMsxEJ0ZYkuoLyAdqr3+nuxF/Q3TKHUSaMzrePXbSCX8SB3M/ACZBx02wFQzWsAoohp7nMHECSMMx9SHswqhdWsLu8AR8cDdTsTK+dvnNtm+TUsamPxwcKYIY5BmhwOvlSeF8ooQefKpS09wJAprB6PbJQTJFl1q5dwhYTG4boVR6+4XOcKm6mM2+JqXLK8GZDxzX9KgbSsNHPLNSZ8fucZbJi3AlkVwE9bgALTnIW33LYoQWn1B5/59+EErSWZDRqIYnoioyWwzgQC8wommVG2M4Xv62g6uli2QC+SvM94fdUTB25mEMjk1Xc0KPd5+CD9RFRjGIQlENebmMZnQPU4U44KlVnYeiuUmdREDaQKr9g9iYAiC1Ai/M0ZHCPijyEiT+8h0snJIlRoJLNSIyzjTzZXpw02Hhr2sIKG2ufFeaGO0X5VgcUbu52Ufh5W2e04aiJM0ctMAuAkONqWphX4mZRa8XvoTSZbPM3FeViv/whSQ8vpUZXOw4+WSZwAnqcDi8Y9hwiJjomCwgrLYafL2ANMhTytstMykdc4ANhsbXO2HsMWkDeLiMNgfs8rV2GQyoihgS0L8O9aQq2kVcT6fReUEciJbrm4VTKhxkvzYZzmgNf2hg0PB67ovzWqfGlr7UckhlaNpp92UBfTjtMJPKwQuseBG3mlXhLzieMcXsPS/GXIEQqZia3KCtxWuY39M+1kI0rMAHjfDyyV/zLZHuA8JzAXPflzQDWf6U+CIQiC6wkfsEXe4vWUA/Ja9PZNYiCBfVSBgQKBDNKMwciD1IAfKQ6AfhWyE/f+Owxw2WojPGmU5F/IQ0lYkoCrsnuvnoQ26lsb65jtvzdvOOg4VY/3Xs545BPOkWPDOIOOj8aeKvfNbIZ44ivqNM1xszgXov2P+tXKWYS1mBqaXJO/UHEg
 heDMI5Ey
 XBr2apmcbTjGMMZJ2oxUURcI7XMgoMgzH6syLswwzMZeCkRg1qOrEaXK7iPCgiMbhG0vHfq2Qu16RALDIfZ/N3eDjv2rpzW6fXdUf4QzAe2Q0j3Bgs4mqDzXiPI04jlAZzbPa08EF34RjATTjHxGhuYQwa3DW5bVB6KQXSNJGn+PjMIC4B/i2//V5/EQ8OGkNi1oRwNsAEX12tTw5T+qYMFPIUDmI/fudRRIBSestT8QYnHgDmswgd91wxs/Tdk3xv+/vOU8bN9AH7hte48fM1GECcV/TCf9HcWrQxNvgPMR2b8mx21IviWiMfOwfd9ZUPYez
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/21/26 03:40, Zi Yan wrote:
> On Sat Jun 20, 2026 at 2:19 PM EDT,  wrote:
>>>
>>> Thanks. Nice numbers.
>>>
>>> AI review had some things to say:
>>>  https://sashiko.dev/#/patchset/df26082871b4c65b2bd38d409026237c08572836@linux.dev
>>
>> Among some minor issues, it also pointed out a funny ABA race:
>>
>> ```
>> T1/T2 work with pages of type X.
>> T3 works with pages of type Y.
>>
>> T1: page_dec_and_test()
>> T1: -> sub refcount [1 -> 0]
>> T1: -> *interrupted* (very bad hypervisor, for example)
>>
>> T2: optimistic get() [0 -> 1]
> 
> How is this possible? folio_get() and folio_try_get() should prevent
> getting a refcount-0 folio; get_page() uses folio_get(); try_get_page()
> also checks refcount before ref_inc.

With this patch set, it's different:

Essentially, there is a short time frame between dropping the refcount to 0 and
setting it to PAGEREF_FROZEN_BIT.

(1) atomic_sub_and_test() [1 -> 0]
(2) atomic_cmpxchg_relaxed(0, PAGEREF_FROZEN_BIT) [0 -> PAGEREF_FROZEN_BIT]

Someone in-between (1) and (2) can still "abort" this freeing process by
incrementing the refcount from 0 to 1. (2) will detect this and count it as
"well, not freed".

So with a refcount if 0, the page is "staged for freeing", which can be aborted.

> 
> For your patch, is it because of the separation of refcount-0 and
> frozen? The page goes refcount-0 before it is frozen? 

Exactly that. Refcount 0 is only transitional.

> Will it work if
> the page is frozen first then gets its refcount to 0? Basically, the
> frozen state prevents anyone else messing up with your refcount.
> 

Let me comment the original sequence:

```
T1/T2 work with pages of type X.
T3 works with pages of type Y.

T1: page_dec_and_test()
T1: -> sub refcount [1 -> 0]
T1: -> interrupted (very bad hypervisor, for example)

-> T1 did (1) but not (2)

T2: optimistic get() [0 -> 1]

-> T2 intercepted after T1's (1).

T2: put page back [1 -> 0]

-> T2 started (1)

T2: calls dtor for type X, returns into the allocator

-> For that to happen it must perform (2) through page_dec_and_test().
-> Page is frozen now. [0 -> PAGEREF_FROZEN_BIT]


T3: receives page of type Y, sets refcount to 1

-> Ordinary refcounted allocation. [PAGEREF_FROZEN_BIT -> 1]

T3: page_dec_and_test()
T3: -> sub refcount [1 -> 0]

-> T3 did (1) but not (2) yet.

T1 resumes execution

T1: -> CAS [0->LOCKED]

-> T1 did its (2) now.

T1: BUG: calls dtor of type X on page of type Y


I am confused about the "dtor of type X vs. type Y". We have the page in our
hand, once we won (2) we can lookup the type and do the right thing.


I guess the interesting part is where the destructor is called from the outside:

static inline void folio_put(struct folio *folio)
{
	if (folio_put_testzero(folio))
		__folio_put(folio);
}

Where we keep operating on it as if it were a folio, although it might now be a
non-folio thing.

So if T1 is doing a folio_put(), we'd call into page_cache_release() etc with
a non-folio thing.

But IIUC, that can happen today already when we do
folio_try_get(folio)+folio_put(folio) and it wasn't a folio in the first place?

I'd assume that will all change once the refcount moves into
separately-allocated "struct folios".

-- 
Cheers,

David

