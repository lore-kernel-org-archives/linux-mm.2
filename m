Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD8BD109C03A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 170AF6B0005; Wed, 25 Mar 2026 12:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122326B0089; Wed, 25 Mar 2026 12:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010816B008A; Wed, 25 Mar 2026 12:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E1BDB6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:34:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90CD91B756E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:34:18 +0000 (UTC)
X-FDA: 84585132996.29.F04484D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C3F8D8000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:34:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y7h94x2k;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774456456; a=rsa-sha256;
	cv=none;
	b=rMMLRlvLRvJnxU1S9YgSzvb6ubLI5riWCZP6aMMLpK/tJNzQ2ztX3yjemlJqn9qbASpUgj
	vrdfdS5XTU2RYTA57TJ4rAHNdjJDRfRMsokJeqHmC/JKm0yya95BoUP9jXlb2gWoGNdXPW
	qCaCkhonx9xuM5GjP/pelnAqzig4NMg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774456456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rre2cOdgM+E9HHigvGd1CwNndTiuqrhdoEqYsnNT7cw=;
	b=mdnXUOZ7sIEHOj+zUrEEFIuhUc+HBT52pCOYiR+FEFNByqsbEb1Y/+pmPEBJTzGCDNXdFh
	k2g4g0sl/XsekliPG4z1zpos6kQRssnPvrtTvegpBk2xQIPTA2srf+5AA5PXcvNNiYRldN
	vPdRraf/ObUSWO9+YRM3qkgAdUsI97Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y7h94x2k;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C37260121;
	Wed, 25 Mar 2026 16:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDBFC4CEF7;
	Wed, 25 Mar 2026 16:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774456455;
	bh=EK+MXobnSf1BBibce4fu/sJoIEkh81eUcMOgGablWuc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Y7h94x2kdDHczeELc5j9D4V4ZkNKjvFG0ghhN/UJqJUp1YSldk7TY8Y89o93EpPd/
	 UYgGijBvukwnDYfccGvcD+TpFvk9QvJadmXSam6z+iGy9GTQEPcSxFG0J8i5ybWvKj
	 J0as3Klj9WNbZc1uXs71rW5QsAsB9WGgNZQ3bhwrpMA2I6kWBFRRDS96xN/iCVYZ8M
	 Dnhs9dDmTZuoLv1Yg9s7NhquLHif+p/HmcTLvRht81fNjyH2N/+fv/aK6Bsc6qYLlo
	 9rNnxq/VvGFuo6jMNsUrlRjbKBf3nPyskonKjIZiv2yVKpsMcbQfRjl3+akdMcjtkT
	 Qle77GdWeZ41g==
Message-ID: <cbc7c2d7-963e-4630-baf5-287fb127774f@kernel.org>
Date: Wed, 25 Mar 2026 17:34:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] vmalloc: Optimize vfree
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-3-usama.anjum@arm.com>
 <1D88CFF0-8A74-413F-9A6A-39E27B760AE1@nvidia.com> <acOjIcqyIVY9KNn0@milan>
 <a79ff8ba-ed4a-43d0-9c4b-d2883a5c48e8@arm.com> <acQKZBqTjpm6-k2f@milan>
 <84f14a13-6236-47ef-afc5-e168d16caeec@arm.com>
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
In-Reply-To: <84f14a13-6236-47ef-afc5-e168d16caeec@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C3F8D8000B
X-Stat-Signature: fxhj3zi3596fkfm54fu3s919bwb44agn
X-HE-Tag: 1774456456-445903
X-HE-Meta: U2FsdGVkX1+OmvNZKNh5ZbwCxPs3Grsw9AM0ua6/rRKmd//Cji+/0ZzM9PkuSWIcknY6awcTt7RcJWs9Fxvzpvp23brZgnWnozJwxANtOpwXmFP8pvCJIJES8H5PpYMfN3oHH4tor+M2ADYHlxkp8YrBgsUbAVrGLcVzhzkmUyg7GwDQ2HXXxX7WosieAvUzyIlYcCDDK62rMixSDzQwYWqrLMldq0BlPH5nEWHFp77h1Q8JCfZMbKoDp7VymWb9k2oaeFKwP1Uoy8nCimbOlI2eV80f1PlYLH6W9tyfczNYTo7Y10qCM1QT3CnC2a7uMAbAcEEpg0v6kHq7xY9sdwk82MGABpQGe0pWkqyG9hQ4HcYkyvqPHFI5sq8BbND+AOchp10NnxlM9HFEdjhaIAvEJRUJm+nidcHp5oERuV2kt6WMag+y7lQa8pOvDZOEPEhLXDnzfgD6ZgOuoTKAkac0vNQVn6HlCOpyNMoUTZP7HENKfDu02e7QM5CS+DGICY0XEGoTRwzxdChG8yilLbJG4R4jd7OGPXFkLF1PRz5xDtW8QUL8JKnpGc2SFzlxyJ4jPIwW/eMgT9uKFlhc4f7IkE7p5iJnMRWk7htsvxcs6Hk3qdLZQZ+ONLtyXLysDjUZWpTtav4qJYcILIy03oluAL1Sl7P7hwtS9r1fRm2xPytdIMLqyBMWMMeMHmypz2h8Q8AaatWm9ZLPskrJUC5JQyccBCbNZjOdSWltFhssKv7CaL2y1o0EaBKrnhsTNda0rz17T3QurYB8FlOLXeq7q9QLiFb0PbWISg+rSdvypl8ia1yhp4Vr21hretReDt/VMz1WVjpaAujjm7TPx/2q5Q6J+rzRam0zKt/eXxA9uoc6S2YLtgMPZB9tLL7r0/pAYFTTzC49l9+IEmNJ5s5EjzMtYL5lSlUIyrXZWimWxt7h7l10N4hHiRbrH6GhQ6IB7/pHl0tW/RdAeNM
 gFJS7Tlo
 kkDBokDdqw0vpBBtyPuhWykKdLGII5p6cgWZzvVnRdVrdJ/gy55K0SCuhT4tQjYMJH3tQ0EsrCBoFqjs5T9Qpa8ph4thV7Tyribif/Xjdr7hQjeHL2EXL04V1fco7O/rThoBlfP+7iVjZCWKlX6/7YW1PxwrzvdlLPM18l3aASYVn5QoepxWWSb+3jYc7NCwfxMbmvfC46xc/csLw9v7LwmE+fOdKELIn+TAOBSzYl566riaAqkwaRrz3LepRpN0dy1S7JA0+lsdMXd0+Ivfu0OcyMrfe8wr0TZRhRBmbUvmuyEJ8kqNiYyFiZi59uUkwyH+YB6ToL66ZiSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/25/26 17:25, Muhammad Usama Anjum wrote:
> On 25/03/2026 4:16 pm, Uladzislau Rezki wrote:
>> On Wed, Mar 25, 2026 at 03:02:14PM +0000, Muhammad Usama Anjum wrote:
>>> Sorry, I didn't get it. How does having cond_resched() in this function
>>> affects __free_contig_range()?
>>>
>> It is not. What i am asking is about:
>>
>> <snip>
>> spin_lock();
>> free_pages_bulk()
>> ...
>> <snip>
>>
>> so this is not allowed because there is cond_resched() call. We
>> can remove it and make it possible to invoke free_pages_bulk() under
>> spin-lock, __but__ only if for example other calls do not sleep:
>>
>> __free_contig_range()
>> memdesc_section()
>> free_prepared_contig_range()
>> ...
>>
>>>
>>> The current user of this function is only vfree() which is sleepable.
>>>
>> I know. But this function can be used by others soon or later.
>>
>> Another option is add a comment, saying that it is only for sleepable
>> contexts.
> Thank you for detailed response. I can move cond_resched() to vfree() and make
> free_pages_bulk() allowed to be called form sleepable context. But I feel the
> current implementation is better to avoid latency spikes. I'll put explicit
> comment that this function can only be called from sleepable contexts.

That's probably good enough for now. It can accept arbitrarily large
areas, so the cond_resched() in there is the right thing to do. :)

-- 
Cheers,

David

