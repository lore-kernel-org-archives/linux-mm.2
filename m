Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF12C54F54
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A1E6B008C; Tue, 28 Jul 2026 08:58:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731386B0093; Tue, 28 Jul 2026 08:58:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623176B0095; Tue, 28 Jul 2026 08:58:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DBD96B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:58:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C26EBA034C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:58:52 +0000 (UTC)
X-FDA: 85038190104.30.738CBDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id ECCA4120009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:58:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A74PjBdP;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785243531;
	b=CzNeJbsEXkcS4aDyBHQwvuK5g88hqWR96Dh4Gn3vMcnlhPTJ3plXLdWL2yvhJkWaiobSOg
	TchKTIFytoXBRfRYg3ocF5IDr+L/QRhh6S7LVcBjKxr2dipm9TlFtp8l1AkTEvrfiJq6FP
	VktAsNCFyCPhqslpRfXShlCDSdCV5hI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A74PjBdP;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785243531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q62HDP0Erg3czKft4bDyd8KVyyjoOUqBzq5NLqx4itk=;
	b=E8s+JilqTN3sUdhBGfNYyAtrUsd+SpxE3ChUs0Y2yXJgDA8jxVgh7GV+N06Urqg180/blS
	HfrYI/2i7Hb2pd7QUdVBGHDxUWaCxwzTk8CfpK75x89E8HBueayIWUR1UxusNQv/R6serE
	Ab8HCusHsl9KbErbGCpxKdWI/bajglk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CB57415C3;
	Tue, 28 Jul 2026 12:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F4E1F00A3D;
	Tue, 28 Jul 2026 12:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785243530;
	bh=Q62HDP0Erg3czKft4bDyd8KVyyjoOUqBzq5NLqx4itk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A74PjBdPW4zj0Mph7aGGoQTiCKy7aBTkYKaPkXhU9DiPxbDItjnucxCc4wTPBAw31
	 6WKOggkK4srMsM1op220wzimf2PiKU+bjI/+nw/wscb8ODi6EWqGhSlrSC2YJUu/gS
	 TZVI8hIZHhJtktozqoPxcqVbsbZQ0jMwNrjTSE5TvsEDu43qhYFfNSb3zJ3HNnLQ8s
	 GEq5dELXkQS+tWYVbpfD+YinxIfqEnQ1KTZ9aaGNCDnVk0wCZMtLU3RX7akTc2DlAS
	 gSXpMFwgJcb2NzMDoki6Kwknqac/0q1hmigYSq63YHNhQ8RK7SivqG7+vSS4kX+0Eg
	 ZXb7DQ2En0crA==
Message-ID: <603ef1ec-bccc-4fe4-9523-e8b8a731be63@kernel.org>
Date: Tue, 28 Jul 2026 14:58:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/huge_memory: add folio_split_driver_managed()
To: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>, intel-xe@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>, Dave Airlie
 <airlied@redhat.com>, Matthew Wilcox <willy@infradead.org>
References: <20260722044220.1110278-1-matthew.brost@intel.com>
 <DK564OOZ3JUK.292JORO9KGKEV@nvidia.com>
 <DK57FVTRTLR2.1A906PYJ2TCE4@nvidia.com>
 <a0c06d8c-fc3a-4ede-8aba-8c7430027a35@kernel.org>
 <2FD2B991-09B3-40EE-8230-49BE3A239EEC@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <2FD2B991-09B3-40EE-8230-49BE3A239EEC@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ie5h94pegkfbcbbgk1heaypo1xkokk1r
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ECCA4120009
X-Rspam-User: 
X-HE-Tag: 1785243530-37923
X-HE-Meta: U2FsdGVkX1/jKlLZOTF2HFhW9M4RjzaFRofH1Dfktiu3SMkNWB85ap2z6DyeQq+Azv819ErRSYHUAAXssfkF31vOsx6U+QIBBzs6OPH9lQ+F7kICUNAAsC9B+Z/cVpMk9CmvllgguXkcRkNQnjmL9OkwqbAjL4CCwwbUYj1wuLzWMynXdgcyZRNUfENXr4Y218sfmirki1WaIzQkZ5Df+CuYNTNcQnyM9CkjqRMtq34DXIREP8O4fTzhbB6EeA4GeThmrN9NJ5lF78UV5l9+8Rj6Su6SnShWIdpH3vFH/MjGG3X61Ad/5r7Rxrz0D/p42KlxpGEiPGCoReq86LJFeHUDuTbXD/7RTJUaS58JNEsKqONe/omGDie70iHn+ho4icQY3Lf1mgj1MCrlsDPNkra4StqaYvZrWMAGBS+2vjR8ZRCNTqf5rVV0glUoplmxpn3yELd+U9sdLMmLwzuKnJrXTEi3gWK5ZLSKdZZaqaVjr4FNvwD/LknM3WiME9yJWUocAGLMLPbfYWzJXsZU2Aa4A0fq0BpnOS+ZmOYqOpW2nksWaKFizOPqURriyfeom/QLGjd8kSbFWybFwc5bH26h2EZyQsYT3w+0mGsWy4Z7/rD8oUlgdqSemOhh99giYs/dC5ZBu6jFMl0U4owwbMIB+FWGp9M6j33DqMH/LTTppQ8DFwd8FZrnK9AqjdFQMKNLjx+pdHO9mEJQhUQaS+dw4YWpGfKl7wMLZalJ4qLVxCygInY3VvP9wh3vB1GxdWe9SiaglFgIY/s2WHhq2rcuij59jDd8hOyJfzeij31P4ZJ3Bqjg2cHLi+lUwF8r5c16TOjc0nXpHKXHjRg/cDc8aK8xx+e5YRUgdQdSpX24rkRFQIMBlrXmC9S2NKTtfGqRyX16qHMLKmGQ9u5ftYCK7EeS2c8oGYYnyl7mgMFqzDaIw8hi5v+39VEIkB4dnrjsybMpVnM4gmwRJIP
 hYM5ls0d
 CJNRx0YvCfGzHrO6jkboL5OX/hZvX/FyjDgpEiImZlPoieTcytWywbpIr3N0HQyS79oLVlBtEeyCgKqBkLYu1KbOc9EgUb+0zSYpEmvpA8dLbTltsbMqqrlAkMMb/6SUzsjIGKrJd2uHt57RoCU/8gzuwAPQvDzkIySp9G6O86ZCRRiU6XcX6d8RPZiz+cBXclEH6Y0/58atsT+Srt/DHVm4Bhd49SfP9DJBeomFeflqBl3um4IKe5FrGLV/L8SADbgb0ei4mRK4jvlQLv7309fF+4yjmklkxM5iMBmrLNRJZiOHzwJmPp4otbVVRXA12yJ4Eb75bi+kse1YGPgpRtMx/VtfX4r1HVOjRAXxv2Std4vTo46FukhCdVTFM+Dqu2WvYzp0vF8qWJ1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 20:23, Zi Yan wrote:
> On 27 Jul 2026, at 13:33, David Hildenbrand (Arm) wrote:
> 
>> On 7/22/26 17:28, Zi Yan wrote:
>>>
>>> Strickly speaking, these vm_insert*() compound pages are not folios,
>>> since folios are supposed to be rmappable and they are either anonymous
>>> memory or file-backed memory. I am working on separating them from
>>> rmappable folios by replacing PG_private with PG_folio and marking all
>>> pages in a folio with PG_folio in page_rmappable_folio().
>>>
>>> Hopefully, we can find a better name, like refcounted_folio, later for
>>> these non-rmappable compound pages.
>>
>> They wouldn't really be folios, I guess. They would likely be a simple
>> "refcounted" memtype that allows for compound pages.
> 
> Yes, they are not folios. But “folio” was started to replace “compound page”
> and slowly becomes rmappable anon and file-backed. People outside MM still
> thinks “folio” == “compound page”.

Yes, it's a bit of a mess now.

> But once I manage to remove PG_private
> and get us PG_folio, page_folio() will return NULL for non-folio compound
> pages and we will need a new type for them, “refcounted_XXX”. We can decide
> XXX when I get there. :)

So far willy did not document a type that just has a refcount.

https://kernelnewbies.org/MatthewWilcox/Memdescs

Maybe "Managed memory" (struct mgdesc) could be the right thing for some memory
with a refcount.

The question is, if the use case at hand would even require a refcount, of if
frozen pages would be good enough.

> 
>>
>> But what is the conclusion here? It sounds like "folio_split_" is the entirely
>> wrong interface for these compound pages.
> 
> We probably would allow folio_split() to be used on compound pages now
> until we can make a clean distinction, e.g., using PG_folio, between them.
> 
> Yes, folio_split() and its helper functions are meant for rmappable anon and
> file-backed folios. But currently “folio” is de facto “compound page”, since
> for example prep_compound_head() initializes folio fields even if it is meant
> only for compound pages.

If we can stop more abuse right from the start, that would be nice.

We do have split_page() that splits a non-compound higher-order page. Maybe we
want a split_compound_page(), or allow for split_page() to accept compound pages.

Because splitting a folio is really something different than splitting just some
compound page (no mapping/pagecache/whatever involved).

-- 
Cheers,

David

