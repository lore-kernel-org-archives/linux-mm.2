Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0043DCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 12:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE9576B008A; Fri,  2 Oct 2026 08:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9B196B008C; Fri,  2 Oct 2026 08:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A897A6B0096; Fri,  2 Oct 2026 08:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E9656B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:19:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E5BAC0720
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:19:10 +0000 (UTC)
X-FDA: 85277590860.10.DBA7E04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3BC671C0009
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:19:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cpOf350q;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790943548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWu9e92IrDGxSiXWBdyugaL6uysiiOtkTkm6Sf0sRHs=;
	b=LwZTlA/0MnNkfWsuVTt4tpzSIf/6vd6A9JjpcyC9yp+rNAxTsIBa/baGgp0AuSMTuqbb91
	vPwFXJmYGaCjPle0FjKBwlU5motI7aojxx1tVPOwMdRaOyiv0FK54afKRi/zKf9ADkKOZk
	J029xBC+t7SM49s1A35hLmXbjL2xp4o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790943548;
	b=hfyWAjHjWN8vOCeJfz+Iu4y02cXZvKudDLR6kOG9i28rrIOBDtGLLe6iQTOPhRiof7OxQB
	zL1rMANuB6PqkTyNE0KQ0NSEdCiaSDUq0eeaTzU9tEMN/DmFSHmYgwIjlnGWJcF7EcGdBl
	xlRplQzZcrb5VLvy9JpgKVBtNDKskQI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cpOf350q;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60EF94025B;
	Fri,  2 Oct 2026 12:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891D81F000FF;
	Fri,  2 Oct 2026 12:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790943547;
	bh=RWu9e92IrDGxSiXWBdyugaL6uysiiOtkTkm6Sf0sRHs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cpOf350q1+IqKbjq3pAaHeVGWsdV2XTQIVpzRCzS5t+71aK85iZ/VSu+PQs0YIAtq
	 QTzbVeLMZ7h7PO+YudkRqENz+QtL8biLtdQ5ZoY94rKhWfrf/38jl+/iz7QtIMc4hK
	 pMPLdl9EY4aYBw/uNdoe7yF2uZaLuDYv6fOBug3bRtzB7Aek5ikndYSLeSSXuq37Pp
	 ZY3jDxwC8bCuyK1sDrwnLwYI4079YamJ3eVvgFf16V5EELUXKPFBfFUSGjybGKU3Z0
	 2bVoTh2vNwl6q5KhVzSr0SC+P8I3XSyrK7JpWcJk7l56gtBbWlgA1kV6Oei0e9xRLz
	 97qvr0v/yuLgA==
Message-ID: <494d436c-e3b3-4b65-8a6c-1059d9f468d4@kernel.org>
Date: Fri, 2 Oct 2026 14:19:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: don't ioremap COWed anon pages in
 generic_access_phys()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
 akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, peterx@redhat.com,
 dave.hansen@linux.intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
References: <699ae98c.050a0220.340abe.0d31.GAE@google.com>
 <20261001152524.171115-1-ngocthang2710.1999@gmail.com>
 <32fe40e2-854a-47ec-9d95-93e23f9a7af4@kernel.org> <ar9omYD3HcTDBpGA@gremlin>
 <c6253814-0cf6-48f3-8f81-3285466dca45@kernel.org>
 <9d43234f-93cb-4c86-a2a6-a3cdebf48f3b@kernel.org> <ar-Cq0YNpQ6_3fDG@gremlin>
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
In-Reply-To: <ar-Cq0YNpQ6_3fDG@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3BC671C0009
X-Stat-Signature: 171jrzd758ir7o6okeyi7gkz97emhb6q
X-Rspam-User: 
X-HE-Tag: 1790943548-240819
X-HE-Meta: U2FsdGVkX18zDK9KNGG9kVIYz/UJh+hiKcFb6OVMq7/JIqqC3zgWaTjbk9hTu48MuMfA/cRLTxvsNtcj4b2Dfss3ydAhPcTVWpFZmo6XXxqhD8KE3NB78FWK2T8J03jX3+RaasAr0rJFoxW5f5qNJfRRbVXwzr/R/BbIXM8G8/HUMeYF14PPPH9PUZ+4MrN+4DJXSBlqP3moKBcLYs/To9kqJnZLsa+nyJT9w9fDU0ctLCbyPS6TqZS6fjbT4WDAMPwpxKMGqeeS82gOaR9VFGDlPhJTNT+vCRXnW2tA7mf4etVwaqpotXZRn0hFeTtJ0tYvFPeG8tqKeHXBL+UFqAuV31C0gc1c5mSqR34mYkmfffVCOlorzPeNDgMV/GczHe7bVWLs1pzcVK0EXplXikgVOZDpF3SD6EB6VYtRrpymVJI5QrX1fHNGsNpcYk6NDTYQM3IABUOhLcW/Oqa97h4iS5bpl2Zbj0TJYQYeTz1EMY2AGangItSQxA9ro/G26QESmaXjA9Q7nJX2vRdttOhSzZVaF1rQnOFD8uSs+bs95/RGfGYQlkobBI5BRVuKUBAURddTO7ZkVCmlu6/+n7Bc2gFTgbgaDkzuLlRmAsn3Y99S3I8T99xDbjf+kVADYQNFixNuSZ8bRMflCiib2asHmHpPnCFitMsixG1z2pj885inSeImudzDkWnaLaDqykrRoEW2JW+sP9AUCKcoW/HnlOobGqPeNXYHbfinpfoTRgKtKChrseOCOiGD9CPnTH1Nagt40BZoyjTuXF58FuUqxTWSOm0K9+G+3QxpKk9UElpmD5jpUwWrMzH0nK7IIKqY1EleBjcFhHsqeNg+/XmtjMpEHRWS90ZIVPD7OXm4Jy9q+VMrQldbue7/p9qydYWoYQsp7Qps2U3z+rgmhhMvnQ3kY8PuWU/su7Nqheb4krUQooGHDe3el/vo1Plmxw6ZZOyhXKLY1f3ifNY
 9rxMCjxH
 eh/KZcCIdriXhEv7xcXBTEEF40P1Z46HJ6LszyHmVoOe60Tll6ogZw78XH2uigYwQ0TO9zq/EkhPmjGNaJhWUE36Lj4Dk2jlhgykPBwnmRJ/L2HIaNRECFrV+Dq0BO4zdb97+kApuNr+v0fgfrTtFMVVnyLPkZ6Ns7ZjmDfFrLgSDrB8fYpQyzW0uXAB7+AqehXNOEmvyHLqtI8EAIchQoXXAo8+BJj2lG59zoznTgMae9LmnqrBnwML24PA1+gqgzii1vzLQu4dhCziIXtPOwOGMQ7uaW+UNvs0ldTPvyMiXUGVsCTuGCJJ6i8VTuj0bHj/Rbbt4QTEfMIN9xYEYmIkgVXz9MXzIIptsWSsfpytxTA6TjOcUMxwM6DFDeKIkBHlPP1DkHhA4gkmfCCdqyKjsK1sc+U5GNJITigEBuFUjcN3IQr8KVmKuA+QPkjnegYG1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 12:09, Lorenzo Stoakes (ARM) wrote:
> On Fri, Oct 02, 2026 at 12:04:27PM +0200, David Hildenbrand (Arm) wrote:
>> On 10/2/26 12:02, David Hildenbrand (Arm) wrote:
>>>
>>> Yes, I'll take care of it.
>>>
>>> [...]
>>>
>>> After sending this yesterday, I concluded that we can do this cleaner: just have
>>>
>>> bool normal_page;
>>>
>>> (naming suggestions?)
>>>
>>> that express that this is something refcounted with a struct page, like
>>> documented for vm_normal_page().
>>
>> Hmm, have to think about that once more, regarding VM_IO and if there are some
>> cases that would actually have to work in generic_access_phys().
> 
> Well, my series at least makes it easier to reason about VMA_IO_BIT!
> 
> Though not sure if it really touches PFN map cases specifically.

I'm more concerned about someone using this function on VM_MIXEDMAP | VM_IO with
a memory page that has a struct page but is actually not memory. So we could get
something that vm_normal_page() would flag but generic_access_phys() could
actually read ... I'll have to explore the generic_access_phys() users once more.

All way to complicated (and you series improves things).

-- 
Cheers,

David

