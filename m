Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21C6EFE5219
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27CA46B0005; Fri, 24 Apr 2026 08:16:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206526B008A; Fri, 24 Apr 2026 08:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CEA66B008C; Fri, 24 Apr 2026 08:16:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E879D6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:16:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 812D5160141
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:16:30 +0000 (UTC)
X-FDA: 84693347340.22.C5F1240
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4A00B140005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:16:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sJ0tb4HG;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777032985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mekafd5APcMH7BoUbraO1nb07bIHlGWwb0wm7fMGErE=;
	b=nve3EMLktJj7m7vmb5IigWg/kAAF+Jqn6GHN9nA2qHhTxZgDtcP8pUBDB1MDwd4+9vhcaU
	K3H+VVr74cty1t0NBmp6DVRhkEWpY3nmJQwER0e3VHSSn95v74oOyYeoum4FdWU0cfmmlj
	MsLNBog/obSoyzyo2eAN5IPqqBh/3tA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777032985; a=rsa-sha256;
	cv=none;
	b=O4NLDOZfNtNwxvh1LbVKsqEWZK2kSLQ72qn5K9pyalbf+hbgonvjPXh3sRMmd+y4xwNn2p
	TGqv3MJkia8V1hdFd/1sY4ESQAY6JyBMcME1v1p+/xxBOkZOReRW5RjF4oUvuw71LwwqIr
	oGhZAMWHa1F+fGqig6/UD6UlVReYr5Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sJ0tb4HG;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 958116001A;
	Fri, 24 Apr 2026 12:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B1BC19425;
	Fri, 24 Apr 2026 12:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777032984;
	bh=bpg6Bd10fmGe+BQcNr+6kBcX4Z+i28lK24sYFJnz+ms=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sJ0tb4HGbbhdYuMn0qIVUVj0alcqc8Q8ueyANCykxd2TCkFMuXGBibV6SUCUQZnJ1
	 x+mM2INukLxebNBZxFbGvdrmiu1rWCripO9nlSufN7hL3SA5Bf6MLLjOuiXtpramAT
	 BzIARPtuvBTYwe4MUV5F9fJaE/ermR4wDGggGMaOZReQCCdZKK2UXeizHWBFozJrhJ
	 4LZJp2lg0zfYlwCvahJuCmBRGPLtaQcm8sLCPWaamQG+ulNdEkwiWvtnCKjXzUBES0
	 /aO6NIr1ZOvk31kOtBG3I+GmMH96jRBKuXO52YeLLL77PvWT/XBw+5WsalZHD2py27
	 0ejZnETyN8Wiw==
Message-ID: <e9c5cf89-fa4c-4b83-ae70-9d3c72542ee9@kernel.org>
Date: Fri, 24 Apr 2026 14:16:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
References: <2026042303-vendor-outright-b9d2@gregkh>
 <a20913f0-476c-4f56-a044-9802bb1c7f1a@kernel.org>
 <2026042431-charter-ranging-597c@gregkh>
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
In-Reply-To: <2026042431-charter-ranging-597c@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uhay7o8x4mex6chekjnmneus9kwsrw38
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A00B140005
X-Rspamd-Server: rspam05
X-HE-Tag: 1777032985-368608
X-HE-Meta: U2FsdGVkX1+FDB4Rgmh08uUajCFIcJ4M+A8UUwWtsfCEsO91Le/shTeF790TgBNztTN0h4W3+79sanJkgX2Stz/l3BVETfXfSRTvMavkBE38ct+6MfUe9p7/As7EPWLloUkwGRYZKbKDf6X59Cu6ITkjwUE3migmgJozHoTWx0XlQ0GiexmZ9TKm4HtGoKOf9b9jN+PjAUM3Gi4lBlzzVJ4e0SfEM+ysNpBuDJhD42yCHbMrNp48OlqlgIBygaE55h4ZMQawiUGdbVyg02CejY3u9PPzP+TefuctHAUwXkPEEfZrctomG5ryxJh5ctsxPZp1Rqj30mDmfs8SjiBJh9WVfPtTxlCIuTV3PxmQLGqaVpYQ464v7bWp9HeZw3xc4PlzGej/x46IgUIBKqKUcd2enNCpH4HA/msFkBVXd7a1+2xtCKZMgsrz3+KogBOheVK/g+p2D88CXeWPJFZKNuGEM3gukCmcjuR6U2NH69Kcb2qYcGilnpsmRjnq53mMXG0jxYPnXEqHlX6Pl8fUcKZbHTC6DG2XeJWkbCEZDmiZTJHpgShdR33nmBf09RlRSNjkCRydZUyPG8l7D18GoSh8slnGDj+AFAa9EN/UkwmPOUPNvdjiGoKFjXbyZ1Tnluwt/2ZHopavnz7wnzOgYzFUFei4sWdtOEB7SpuUX6ISEPK9UjCu5OcoWQNPafUL8X9F+WXvERWJIQwZgUVX9MCemry9FuSbQ0Jr6yqdqyRraJcHVCLusaw8OU63km0VnAqPkc2SVRZGUtVMwNPBWFOoZmmOJ5D0yMdFJDwgX5WkWyPZnRn8lBwlHvj8icrfI8BhEOZuFVGnpInNuwiJVGEQIN3CKF5/xr3qeCgzr1Afhaz/c0y1Sw57baxva2U9STJqmvI54Iy7mS+Gc7ismqSIW90IRd+5EJJD3vik71vcmmP1SHTcJJ8tf5mRhX7ZV6IuXDihf/7eb/OTEHx
 qjofl9a3
 lTbx1/dRnhdr4oz4mV1yw9AEbbAASDmqcuR0gBZxVglQluEUZ/gCDTWAqcD8zDixDGoQ9VGJOtgHKaSkkpp2o3R2Y+mZ7+0/OI8/Z/hAAyP2o2xnr9u2vZlt3KqcSkEB7m6pmaV4cU+a0LSyqmh0gfR8ovZne3YpBiMa77IZo9al12ocGw25M/AlTjsex13bGkd2CnBsZoBAFcIFPUd9T0hMmBzsnMrDCcAYZTNGvl0jbNZS8ehRRvcfknEBL/HRNjLErinsxGvmQYYlhXCqx+7P7Rqgd9HT+yvYJHzaOnUHwte87q9Q37JJj7I7XD1gjwpLjts5JgzYZ5o0wuB5FBKm+/zSQ+V8CoCunyHjGtNPIMejLQxNmjvEI15IAEkv9NdnvHin8qQNB8HGRBVcwD2pK/CcIsciXO15tHnVYJvVK3WO6Q6B6St80/f5dB5KizppSNQv3pMYPgow9fXx1z13xcYG/j7bRFK/mqcj+mw0vfbeKtovrQDvLdPcYZdedv43X5BMBXCuVGZ9lG6nHq6zGtPdW2XsA44nTImHcYINIZMA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 13:31, Greg Kroah-Hartman wrote:
> On Thu, Apr 23, 2026 at 05:55:56PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/23/26 16:28, Greg Kroah-Hartman wrote:
>>> The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
>>> get_page() reference for each page regardless of foll_flags:
>>> 	if (pages[i])
>>> 		get_page(pages[i]);
>>>
>>> This is reached from pin_user_pages*() with FOLL_PIN set.
>>> unpin_user_page() is shared between MMU and NOMMU configurations and
>>> unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
>>> GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
>>>
>>> This means that pin adds 1, and then unpin will subtract 1024.
>>>
>>> If a user maps a page (refcount 1), registers it 1023 times as an
>>> io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
>>> unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
>>> the page is freed and returned to the buddy allocator.  The remaining
>>> 1022 unpins write into whatever was reallocated, and the user's VMA
>>> still maps the freed page (NOMMU has no MMU to invalidate it).
>>> Reallocating the page for an io_uring pbuf_ring then lets userspace
>>> corrupt the new owner's data through the stale mapping.
>>>
>>> Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
>>> for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
>>> symmetric.
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: David Hildenbrand <david@kernel.org>
>>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
>>> Cc: John Hubbard <jhubbard@nvidia.com>
>>> Cc: Peter Xu <peterx@redhat.com>
>>> Reported-by: Anthropic
>>> Assisted-by: gkh_clanker_t1000
>>
>> Assisted-by: David :(
>>
>> (no, I'm not a tool! :) )
> 
> True, sorry, I guess people can "assist", I should have added that.
> 
> If Andrew's tools automatically pick this up then:
> 
> Assisted-by: David Hildenbrand <david@kernel.org>

I think we usually use Suggested-by:, but really I was just joking :)

> 
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>> v2: - drop huge comment
>>>     - rework error return value based on David's suggestion (heck,
>>>       pretty much the full patch was written by him now)
>>>     Link to v1: https://lore.kernel.org/r/2026042334-acutely-unadorned-e05c@gregkh
>>>
>>>  mm/gup.c | 13 ++++++++++---
>>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index ad9ded39609c..2f6f95a167af 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -1983,6 +1983,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
>>>  	struct vm_area_struct *vma;
>>>  	bool must_unlock = false;
>>>  	vm_flags_t vm_flags;
>>> +	int ret, err = -EFAULT;
>>>  	long i;
>>>  
>>>  	if (!nr_pages)
>>> @@ -2019,8 +2020,14 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
>>>  
>>>  		if (pages) {
>>>  			pages[i] = virt_to_page((void *)start);
>>> -			if (pages[i])
>>> -				get_page(pages[i]);
>>> +			if (!pages[i])
>>> +				break;
>>
>> Best to mention that change in the patch description. I really think this is the
>> right thing to do (returning NULL in the page array is just very dubious).
> 
> Ick, I see Andrew already grabbed this so I'll just leave it for now,
> thanks for the help and review!

Andrew, can you add "While at it, don't return NULL pointers in the page array,
as this is really not expected for GUP users; instead, just fail and return
-EFAULT."? Thanks!

-- 
Cheers,

David

