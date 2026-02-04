Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77EAAEA7946
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 20:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D3F6B0089; Wed,  4 Feb 2026 15:31:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53BA06B0092; Wed,  4 Feb 2026 15:31:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439BF6B0093; Wed,  4 Feb 2026 15:31:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31C6B6B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:31:26 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E83491C13A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:31:25 +0000 (UTC)
X-FDA: 84407919330.08.0A851AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 05FF71C000A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:31:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fA/BsKvG";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770237084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9bnkfckbAZ7s1IPdiDoZT9cL2UZckY/P5nRcL0Sj4I=;
	b=vtrmt0VtsR+aqsDOKIcUKXjnwDAc3rXnPooKkUFUg09TJJOv4B5zw19VwelofoALqJVWVG
	0qEf5Wl7lIdwDdRxyW/LbbLgL2R6CgrgL28yBDSUc4czQQDLgnwTOgZtTBqoAd+O2yWpuZ
	2Mi32ImIsVhN5y2FWajuc3H5PNjzSo4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fA/BsKvG";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770237084; a=rsa-sha256;
	cv=none;
	b=YDIOSeRg7IqMI3ZoqaMkClTEUEMl4SOinUOD2axqLAN4nYjam56JMdT/EPQZj4D7iGFP0Z
	YT5APQ0tj5AgMVrHymCNo2O48rcv7bC3z52LX9buoJeJaxKOVWYzPUl1dx9Dgv39YBsF37
	WkyoAwcMYRMQg5evVCnOBoYgh+EPZhk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D07F40469;
	Wed,  4 Feb 2026 20:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC584C4CEF7;
	Wed,  4 Feb 2026 20:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770237082;
	bh=d8LLjnoCEgDTgjLliFif8I6sRjSCvvdWpJi7lCkljyw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fA/BsKvGRsWc2PziNJzVkNKVQci6TTQg10r7xO1cE/73lim7Kf0EdK/3eSC4RKY5U
	 TI+2WTEZTs2VkgyTnN7eYQtHn3aD6qiOSRaR8N7J8Qaf49PSAivPOSMDqj6mL5wc4g
	 b1b2/cuoWlYx05H0/Z/jQQnJ300JszkcCgKtMcXJTAkZ5Ul9T7zaiI0wBKXnR7aXa3
	 JjLTe5438PaTfNTyObUZQcDC4SXF2tpvhPHmASEawt95HBjqKODV2Gh0+MLkBe6a9/
	 KTJ+cxvG4sYo1rDyVaaRERJWAHpvYWL0mFP51M4scclMWlYkx+RryPq73bLpuunPuW
	 BUeeDuI2YVFWg==
Message-ID: <7bb98650-cb7a-4230-8868-7da2aab5923a@kernel.org>
Date: Wed, 4 Feb 2026 21:31:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
To: Zi Yan <ziy@nvidia.com>
Cc: =?UTF-8?B?5piv5Y+C5beu?= <shicenci@gmail.com>, linux-mm@kvack.org,
 linmiaohe@huawei.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
 <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
 <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
 <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
 <9E046323-740A-434A-8B60-B8A32D0955C0@nvidia.com>
 <11399c99-f966-47be-bbb4-a7d4e79c8c38@kernel.org>
 <86002E57-58EB-4940-A7F0-7AE4A60484DF@nvidia.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
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
In-Reply-To: <86002E57-58EB-4940-A7F0-7AE4A60484DF@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 05FF71C000A
X-Rspamd-Server: rspam07
X-Stat-Signature: 19fizwg19tumbts8tz9jjgsfhrffu4oo
X-HE-Tag: 1770237083-935096
X-HE-Meta: U2FsdGVkX187rs0TiVkkJPZDNi4Fn44NaED3FWoyrSEC+4cv2tKpggm/h2HqVIWyfJnGQTEy9gcEGaFTzNLy61Yyp2i0PJRto8he5qBs1IW3bpeVUcWUa2/C5UETNc3VDtIatIM8KfNIs9HOv3SWWbhulenGNhZToczlLoLHEIS2W966j/Y8Oy5LApCyzIRFBIvcrZeucebqRm6calGlhjxH2r85BO3KLyWDuDMQnoTR0Ck5Pgh6qSe07Ksw+blyu0G1JkqkqtpS3azOGehuDADZc7bN1H7ubeVsuOt25ssaXaXoX2MsabMR+M8dOZd5yyikCL7EGB7vopVjLPOY0mbMbDU8OXOMH5netKQFrvP4vpPMGHqc25jjTcPzMYmXP4zQUg85zlmbk4NI4NixumeaUqqo0V3ShvgM3Ljy+95LGmKPE4MPUrBW+X0UHDMViEVyayC4B7C5LYuVAr6up6rkUE1qR+ylKvgVbXRVgyCJn5puuzCGEfK334q05UyBYNN1XXw53te88qAqSrvpBSGzElXDOcrC0e+CBBIStYRKqoqUoXru1+tTj+JohqCC7xb3NHtAZZ8qa8UQQreVrUBJ2urpFrav+cprUo/+gzrg6dOuW17z4IE6YwakPTYCXr2wp9h/oiW8uOFHnczKNRtvWnNLdL9rMqFUJMy9/KOxhD71BLfL8mHdrpHHoYAwPzI8GBT69fpI5rL/+ASYrn5a29Qn9ujxSbfwm2W7VU4V+9z6QC+wst3YiB17NIzxQKopE3Dn4Ho78bQV4Aozksg79NenKlUsC0joF84vcK5vmHsGyDD9zfO6JKj+1K0QR3zhKb1aApgMFb0BgXZaa3MDICB/5/M05Jd5Cy/QYOV0NQNR7sMADAElU6suS7jszQZqysQwcJDFh7Xa4xjj7l/Ku1c8sO7pvfCiBxZjtM1tBAv4r+NhHf0NZa8U0tj/Ed2CobIS7yY3sls8Muh
 XpJW15rW
 xFhB9S+8jPNYgVw3B+Bz4wJQIoUF8YvUEswKJmLa0GqqaP3fFjpmgEWbXMmV5FY84NCAc70uBWrk94qVomuu1vUpe8wLm9qWFXOJi6aI4Z03vOafm3by9AxjHMEme8KLkqaWl0mrggs7AKEMRgGsz58SMbGm3a/uakVXizn7dKBef5ktL2m+GC8IP8zWDlaX7tiJA4KDxH6Zbp+oX4Zg7T7mwMOt+pkNAiJSyqyuVoFDiGFMNgjA+D7vDPi9jtGvgbA/6T7lVZJiUPhwYhAoqZrfHPuAKDslWQWgkDlG+6+AE8EbMMtTGAMCchV0JTfsfSzTJl2R7PTVFzv1dMBtgCkPDIhGDEawa5269
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 21:13, Zi Yan wrote:
> On 4 Feb 2026, at 14:55, David Hildenbrand (arm) wrote:
> 
>> On 2/4/26 20:48, Zi Yan wrote:
>>>
>>>
>>> What do you mean? Changing memory failure code to only handle large_rmappable?
>>> large_rmappable is a folio flag, memory failure code should see such
>>
>> Did you mean "should not" ? :)
> 
> Yes.
> 
>>
>>> non-folio but compound things to begin with, IMHO.
>>
>> I would say that we could right now reject in memory failure code any compound pages that do not have PG_large_rmappable set.
>>
>> I have the faint recollection that we don't set PG_large_rmappable on hugetlb folios yet, so they have to identified as well.
> 
> Right. My patchset[1] is trying to add it, since hugetlb is used as a folio
> in most places and large_rmappable is a folio flag.
> 
> 
> [1] https://lore.kernel.org/all/20260130034818.472804-1-ziy@nvidia.com/

Still on my todo list :)

>>>
>>> I think we need to be able to tell between raw page (compound or not),
>>> mappable page (compound or not, especially for those used with vm_insert_*),
>>> and folio.
>>
>> We can't identify (small) folios just yet. We'd need another page flag for that (just like PG_large_rmappable), and we all know how that ends ;)
> 
> Yes, I am thinking about removing mapcount in struct page to achieve that.

On my todo list :) Stupid CONFIG_PAGE_MAPCOUNT that is still around and 
stupid partial-mapping handling.

I worked on this after LPC but was distracted by PTO :D

> And only pages used for vm_insert_*() and folios need mapcount. 

vm_insert_*() won't need it for non-folio things. Only folios. We just 
have to teach the zap code to also leave the mapcount of these non-folio 
things alone. IOW, identify them when we map/unmap as "not folio" and 
not touch the mapcount.

> Code
> uses vm_insert_*() on pages would probably have a struct mappable_page
> with mapcount.

I don't think we'll need a mapcount for them. Only for folios.

> 
>>
>> With Willy's work we'll be able to identify folios reliably.
>>
>> How to deal with that vm_insert_* crap, especially for non-folio pages, is also future work based on that.
> 
> I think it might the other way around. memdesc does not have mapcount,
> if we do not have a separate struct for these mappable pages now,
> what do we use at memdesc time? folio?

Folios will have mapcount related information, yes. Long term, memdescs 
will for sure not have any.

Real fun begins once we start messing with refcounts. vm_insert_*() will 
be "fun" on non-folio things.

-- 
Cheers,

David

