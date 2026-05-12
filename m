Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45BFBCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C0F6B0088; Tue, 12 May 2026 03:51:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C7E6B0092; Tue, 12 May 2026 03:51:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942C36B0096; Tue, 12 May 2026 03:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 838AF6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:51:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37394A03D6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:51:32 +0000 (UTC)
X-FDA: 84757998024.18.55D758F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 51E63140006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:51:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tsb6Mhn5;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778572290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rOAyHVShyzacq8L/U2qZPNRMI40UHiX78N1bflhJ2Zs=;
	b=PC6di1yPXuRvKfWeQjZg5Tcwz4D6+V6Kt8ID296w4T5p7zoH4xZHDcKZoRA9womjrfi9/i
	1j/FMVCclb/wXNn/XaXXyRlLAIHFZOWhPd3lgz9pPchb3QLzYEdDbgeuUfJSLnaiup9DgT
	arJQXZ5zgK7DSQFUA6hK+KogOA0pRw8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tsb6Mhn5;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778572290; a=rsa-sha256;
	cv=none;
	b=ZaRr9lImnYCOhf0lKlmpl3ZL8aRjr9SIrx+Kv1WLaBFgelcJOnffNU29m4p3wOP9jCQHFs
	QCIHdV97CgU1Zy3x0M1h6e5DCCmi/5JXx3pwzX+04cbAGQ5LHjrCAGvQaMHbVpGd1yKp2o
	l/pC6kM42XphfKhgU3zIzy4GlzY2hE0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 57763443D1;
	Tue, 12 May 2026 07:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FECDC2BCB8;
	Tue, 12 May 2026 07:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778572289;
	bh=Dq8ING+5fXzkYw+tuaMqTiP1VzJarHzMr6tQqmPU8dc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Tsb6Mhn5W7yHRlJBXykDzeOXgNLdHkKpj0ScceVhTJeGMjwpRaTOu/XBHC5j7/ANp
	 dxH0KoykFdSUCnu9PvxPRfj5amBhduE+D+qptUCZFhlAytu2VhMQ8Q5ucxis9Jj7pN
	 b0yWyz5/X1rDdWboculE//6uVUVqoEREQy7plO7Vz8E4wQkdE6iiEAqoeclt17uO29
	 L4hF0xUH7Z+fU+Je+2ZdOUT+MFGjVL+ol60h7zDbmwx+eoZOOB15rxGXClEBMWkAJp
	 42XtgqxHF9BJs4mjc15p2ogvnzDJJfd+dY1GemoudCAhZOnkHBJtAGyrDXuqvwKFhD
	 D17DnqiaryqUQ==
Message-ID: <8ef6e92d-4cb3-444e-857e-fdbf88c035ea@kernel.org>
Date: Tue, 12 May 2026 09:51:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: "alloc_tag was not set" when running mm/ksft_hmm.sh
To: Alistair Popple <apopple@nvidia.com>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca,
 leon@kernel.org, Andrew Morton <akpm@linux-foundation.org>, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com
References: <be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev>
 <10e4565a-b416-45d9-a8b0-cd32532b2630@kernel.org>
 <2b46241c-158b-c9dd-9b81-a98366b2c9fb@huawei.com>
 <c16350fa-2f74-4517-8d97-4772def97b78@kernel.org>
 <dff84fe1-ae17-410a-93a2-c5fb921e7f8f@linux.dev>
 <agJ9762r0HwKSsb7@nvdebian.thelocal>
 <f7895374-b43f-4ce7-8a26-112ad30c9273@kernel.org>
 <agLZ_BlwTuSZrORF@nvdebian.thelocal>
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
In-Reply-To: <agLZ_BlwTuSZrORF@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: izsjbjcw7pux4b4sbeehrqghrtcjfg5u
X-Rspamd-Queue-Id: 51E63140006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778572290-182626
X-HE-Meta: U2FsdGVkX19X2hKx4rEiBvcJ2g9HBxjLPH/nrlG1H59n6uP6JpFmPyYI/a1epsNy9/2T3pEr6cViMsEpos9gxolW1gFFyH+IEbn/dOYBGI+rdbr3nhwSygpo26WzIp87nJ0YFcQUU42QLDooFFP8GMnEY7UCvRdSpDlu3j+466K1uBgiHdRN+CUwQhBDcWw5m1fm+6VUDIpkGPw5eeaSawF7e1nSU0Pf/PV/3eVOTL4mRg3zSTUVfEav8k+XBj+3NcePmfICVEKsFTRRcY+eXZKHF6d/PfBGmGrV6cTZGDCcCOHaRMsJ0GItcquhwJ4U6JzkKx1kC/L7GiQE/2FRqTW3+XuL1AfY9uA6Cg8E90RPMC+jOnJJNfVMOF9BynCI03b4Nv/A8bIRPl0hfG3EvWolvnqKM2u5DiGjeIPSsesxgOZYJ4zmxnjCEDPTjGfWJHF/ZjFQ9lP7vh0oNnU3ZvwTVH6xtcfsb730HF2MmFG/dhhTIOE0tCrFNnvM7NRMxSJcg3VMtVKLMVxf3s9YJA/lF2ITaYTS+dHYWKo8UE7S5/47lvZXPbs0HTziiFRVJHMRSVWLVoM3F336SRZ4NHiKtCKhH/eZy8ND5MHMgl5J4afdMHqcR3fcWufG7YZu7PF0xrhtzQtRvjv3+cugvCydndq32Wgxd1PqV2Xar2AlDM9YX+aA8UnmKqwEX8hgxFhJn9pGnf4YhdG/GJJvW4K9O5P1Uq8DsVMOHvAvF6ckV3wtSDLIOKOVLbGrTyMDFjZ7YzirhvpmcN/BZULjwXHzM224PI+696aGMKQtTCt4/hpYpCtkIVvv7NUd/a7ZhL3S5jNyGjUfU56XdWgcU6nRq6Z7ZtZ4Q8lyFizfTTKXIQXKADNLyyqMK1haCAhyt0qz3nDU2F0UoFaJ/bqGVsNfcfOJ3vk9WPd06Pk1JDQcStPJPK9jJ5l8OxXS0C8a4SYqLviX8XeCYNE4MAb
 ZjigQPDF
 s+gaH7ybrZXJ0qmtzb+mufTLhb//QUW0FAPy0F0QCDF86bmdx7xJNy2J8tXjE15VDH0mZziuaNTPX2sOGE9cz9o8wUHDteGhmBQxUk1LuthhgKf1DqLnj4fI3Ru7rftMmCnBR+JlF7NEhF3pZjE0kuw4mT8EJEzAa4KWT9s0VVKpkOh5w7PbKQEHkqp+UXjtrflPVx952ccEjh1HSXEuyNk09xQdGt9k/j/b81VptYAcB3mtdIJ8DmHBo6+O2Lx1uNwc6EnrTNO7Z1bSoZRjCOD3Uu8IfGcFxboIwxFgU1dWkqwz0Lt1JjsDKLYKhzDAcTS3xC6um0O8i+hU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 09:46, Alistair Popple wrote:
> On 2026-05-12 at 16:47 +1000, "David Hildenbrand (Arm)" <david@kernel.org> wrote...
>> On 5/12/26 03:28, Alistair Popple wrote:
>>> On 2026-05-12 at 02:38 +1000, Zenghui Yu <zenghui.yu@linux.dev> wrote...
>>>
>>> Thanks. I have reproduced it now that my fingers are skinnier.
>>>
>>>
>>> Well you know what they say about assumptions :) Although in this case
>>> __folio_freeze_and_split_unmapped() isn't called on the backing page anyway
>>> (it's called to split the ZONE_DEVICE page, not the page simulating device
>>> memory). 
>>
>> Now my brain hurts :)
> 
> I have never liked this bit of the HMM selftests. It has always made my brain
> hurt.
> 
>>> The problem is we're not splitting the tag associated with the backing
>>> page for the simulated memory.
>>>
>>> I came up with the below fix last night, but I suspect it will quite reasonably
>>> get NACKED on the basis of the symbol export so was looking at other solutions.
>>
>> I think there are other problems ...
>>
>>>
>>> The simulated memory should just be used like a bare physical address range. So
>>> there really is no reason for the backing page simulating device memory to be
>>> allocated as a higher order folio. Using the struct page to store some metadata
>>> for the simulated device is convenient though to avoid creating a test-specific
>>> data structure for this. So I am looking at going back to allocating the
>>> simulated backing memory as always order-0 pages in the test which is what it
>>> was prior to the introduction of large device pages, but that was causing a
>>> crash I'm yet to debug.
>>>
>>
>> ... such as doing a folio_page(folio_alloc()), followed by a __free_pages().
>>
>> Why are we even allocating folios here and manually splitting them?
>>
>> Looking at dmirror_devmem_folio_split(), aren't we using folios here for
>> something that ... is not a folio?
>>
>> Likely we really shouldn't be using folios here ... :)
> 
> Exactly my point, just more succinct :)
> 
> I just need to make it work without doing that.

Ok, great. You could also allocate a larger buddy page and just split it
manually through split_page.

split_page will even do the pgalloc_tag_split :)

-- 
Cheers,

David

