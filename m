Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2EB6E7E0CD
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 17:36:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96166B0088; Mon,  9 Feb 2026 12:36:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19616B0089; Mon,  9 Feb 2026 12:36:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F15B6B008A; Mon,  9 Feb 2026 12:36:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF096B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 12:36:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2684A1A021B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:36:44 +0000 (UTC)
X-FDA: 84425623128.11.FDE48BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 68AB614000A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:36:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ducPG5td;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770658602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tpv4P7hFejXc6ZUpfvlUt2fIVX/99spP6E+e7hNMs5s=;
	b=bWUFSXp8zdASru/+3ELXFSl8FP9ojrDfN2/yRqM1eBzn4Pjn2mYUZSFPGEdckOiIulwoms
	kfn6adglcJFwuAlKnSX6rONdaYaisVUyl6FwlROH1zUK5RhozUpSaBKw5SvBN82fTThmWN
	FIRgcmndjSU+EulC8O8MuO3ohca3Dvc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ducPG5td;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770658602; a=rsa-sha256;
	cv=none;
	b=0Kys75vuNdl14fG4u0CzdrMf3hun9fAlWGWVRu0LCe/QYF6JCyoiAEt7hV7y2IZy7N7D7w
	+HiWRHbJNuDTsp/6IbLivTNnK0Ng0kREiLfaMqPZROD07zcgPg5IyQMOauulddy6A18WiS
	HUmQdNZsvvZniSRPopA652xP7MkKAlE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6596460008;
	Mon,  9 Feb 2026 17:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24815C116C6;
	Mon,  9 Feb 2026 17:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770658601;
	bh=gfMaqqBwGsOY8oyPuNLoKaW9sW4dgip3p9mqVldeH+4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ducPG5tdCmRCCzFAHTXlQMHKfNtB9ChlU5y7orZSMHaVqb2HKo/wvtM90GTI+Gjgp
	 CR75ETZQGnloF7cqrrofJ+tEY+elLZvu+OibSLcwksQyBPgQZJHwzjgR+PDJoUdjUu
	 yWwN07NZPKukGr/ih6vf/OTgSwCNACwRHcUjY3Mkw3UMHqvM71VuLxJ07rgVMlW4fz
	 PopIINCcDNH4grywm4UQmL2EpEcPwPJ7Ntt8SKcwqModWEOe/yy2r46aNEXtwvwt7o
	 j0rBb1h9vQR/Ypks7r9Ohx4QsAOJuPj2hZC7L3GOno09CJTxXNXXf4p4N4vBHy7IJ9
	 /VTFZkYo7PUAA==
Message-ID: <546b200d-5b70-4db4-99f1-f50f6a343c10@kernel.org>
Date: Mon, 9 Feb 2026 18:36:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
To: Zi Yan <ziy@nvidia.com>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, npiggin@gmail.com,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hughd@google.com,
 chrisl@kernel.org, ryncsn@gmail.com, stable@vger.kernel.org,
 willy@infradead.org
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
 <cbc3b5b3-09b5-4e3c-99f0-a1f67582afff@kernel.org>
 <0BC1D792-80CA-4E60-AEA0-187F73BD4723@nvidia.com>
 <bc0b6d03-4309-463d-a112-aae57cee335d@kernel.org>
 <22431471-b569-4ade-9881-387debada00b@kernel.org>
 <91F2E741-5473-4D34-ADA1-C9E6EDCBF5E0@nvidia.com>
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
In-Reply-To: <91F2E741-5473-4D34-ADA1-C9E6EDCBF5E0@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 68AB614000A
X-Rspamd-Server: rspam07
X-Stat-Signature: ub1sq3xucb367eqdc56zrnwq564y5nxs
X-HE-Tag: 1770658602-314308
X-HE-Meta: U2FsdGVkX1+r7VR9AaoLNi4YnafnU69G4ADcbdqUfQbgtRTet/3KRxxSYhwUQYhE2is/PP1QQZZVqqLvZabuctDvKpHLG5VOOJ3KTkDfcxVfmN6UIxEVT0N+wAGZDPERgYhYrlwxxBX+UZgRSkkZKjg5tRih/PkyaEyEhS5VTlAo8jFj1SMUxZhG9/SXDaoiMsRynupZaJvAu9x8ZaxCoyWhpjiB5UwzN3IvZ8KgvZ0P29GwbPYp95z9us4eNFyKHkvaFPC0LGtlzJps8jt4f1p6qEoqn6CBnSgs4nJObTdEK/0MFROeCBFSSYOKEFk4JXoXYtSpkRt2+SIrAA8FDEbG9uMjJAqaLbtXGZcJ5eeqWjiD4e/pzvWkcjqVGPLb+dDWfPSlriiRjsRTGxeHr3RLtGhfCeV6gB8whypb8xXrIU8JTFn9If/HpCG//roaW67vBUg1Imo4pISo4bToUFXQj1Ijgg5V2/2HXbfhTIZjT2P2GrmRbbYAN3MbMC9fwoLV5S0dK5PQo4FqlEpahT/QyQgYalnTwF6B9cjVpuLrhOL560oye1WVQGiqb/yA/ne4pCUBEGDi6WQMqYUCH1C94zvl/1c/MQ2GSmSAOQOyx7H7u2PzlMFC3TYWD6j8yDFRc2XuHLFKz8BzaPqAecmRMIr86dpGgwQ+74BezuJdhyDfaCQXBBpI1VZzVCBkaFPIGcfH5+HIifApOePF19XVRO7UfsE3efwybYw8lxNJH1gLFy3pfw7xIF1852gLNtI0vdPyEvAzon5l31VUf09Lpb+aMsRpx1k7YoQ7RQQjHGfw5fGigkIJN7CS0sBzir75I2aeKqZNcxR5EepsI175hEqLrTzaDpoCaf2H8QyxR7vSFUt5VmzP4Tal/214q2h80YzEJCuc06cGlQO6Dtlc1/SzmS57GUv9N1Uja8/fLXB3phl9YHr86HD7Zy7sBlnyLiIm99SiCdf7gbh
 4yx74sue
 2/lW/yxGx4gctGw0jevsIV0nyFx/YgSafYlnmGITzZ1OPl7zSb8gGCcgt+Hb4nXQOEaL4gvntMs2+SJdHEidHfQ0gG6wEcnFkZt1OsZR7JklHzgb0cWFUHa2K828VnAlYeFT06mUGjHBLBKTBvbXksQgHtFgUl1y7ERD7wpNrvDTS7r8LvMoW1NPFqbO9pkqDqqc8IvbwKhdapCC6+886MxJNj+cxHVyWXbUTQ20fVQjRBm0P0TOdgQwJprgeEMLGqAMwUu0qxfw5kzmOoNBGjPBFRljRQnd/oYtwjgnXmyq5UfymX40Ozm+Oeg6T/FCPrg0mmpiY+ZG+9vSZ8yZTCNOYVxbibFffDuWDzCsIWyu+4J2CvpD7colodaYrb0O0Om6zpU0/k/v26SC+KRehwNa34w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 17:33, Zi Yan wrote:
> On 9 Feb 2026, at 11:20, David Hildenbrand (Arm) wrote:
> 
>> On 2/9/26 17:16, David Hildenbrand (Arm) wrote:
>>>
>>> Right. Or someone could use page->private on tail pages and free non- zero ->private that way.
>>>
>>> [...]
>>>
>>>
>>> Thanks.
>>>
>>>
>>> Right.
>>>
>>>
>>> Right. And whether it is okay to have any tail->private be non-zero.
>>>
>>>
>>> Ideally, I guess, we would minimize the clearing of the ->private fields.
>>>
>>> If we could guarantee that *any* pages in the buddy have ->private clear, maybe
>>> prep_compound_tail() could stop clearing it (and check instead).
>>>
>>> So similar to what Vlasta said, maybe we want to (not check but actually clear):
>>>
>>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index e4104973e22f..4960a36145fe 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -1410,6 +1410,7 @@ __always_inline bool free_pages_prepare(struct page *page,
>>>                                   }
>>>                           }
>>>                           (page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
>>> +                       set_page_private(page + i, 0);
>>>                   }
>>>           }
>>
>> Thinking again, maybe it is indeed better to rework the code to not allow freeing pages with ->private on any page. Then, we only have to zero it out where we actually used it and could check here that all
>> ->private is 0.
>>
>> I guess that's a bit more work, and any temporary fix would likely just do.
> 
> I agree. Silently fixing non zero ->private just moves the work/responsibility
> from users to core mm. They could do better. :)
> 
> We can have a patch or multiple patches to fix users do not zero ->private
> when freeing a page and add the patch below.

Do we know roughly which ones don't zero it out?

> The hassle would be that
> catching all, especially non mm users might not be easy, but we could merge
> the patch below (and obviously fixes) after next merge window is closed and
> let rc tests tell us the remaining one. WDYT?

LGTM, then we can look into stopping to zero for compound pages.

> 
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 24ac34199f95..0c5d117a251e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1411,6 +1411,7 @@ __always_inline bool free_pages_prepare(struct page *page,
>   				}
>   			}
>   			(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +			VM_WARN_ON_ONCE((page + i)->private);
>   		}
>   	}
>   	if (folio_test_anon(folio)) {
> @@ -1430,6 +1431,7 @@ __always_inline bool free_pages_prepare(struct page *page,
> 
>   	page_cpupid_reset_last(page);
>   	page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +	VM_WARN_ON_ONCE(page->private);
>   	page->private = 0;
>   	reset_page_owner(page, order);
>   	page_table_check_free(page, order);
> 
> 
> Best Regards,
> Yan, Zi


-- 
Cheers,

David

