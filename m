Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC4FCCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C3506B008A; Wed, 13 May 2026 04:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34DC46B008C; Wed, 13 May 2026 04:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDAA6B0095; Wed, 13 May 2026 04:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 099886B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:37:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0E9DA079D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:37:58 +0000 (UTC)
X-FDA: 84761743836.22.7CD3E81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id AB4C480007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:37:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IKqZs1xo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778661476; a=rsa-sha256;
	cv=none;
	b=udktPBNpOpMQyPBVZMf2vaPRlh/AGeko12bJl7zYtmsAW8u4ikXZZUMP/1DO219jbzdsFr
	yDzjJl4llW3Y+4b0ol9h5V5+uGibw8GdfaAFVlofBLo2EbKM5jSiiZUqbBspQz1N7pPRJv
	2ggDqZ+JP9NJV99NZenXzjIYFU1uiCg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IKqZs1xo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778661476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3XZp6L13D7ZZWWF4fQnPYLvpOIqoJD5Xw6qrnIpdrU=;
	b=ccclnOfYxOatR7RioPALlf+8Vo8EoiF5VM6X6VzzZDVZgTsrplhWkvPE4uUq6uR9FFYmR9
	+1t9GPLqhB5ikIMkAcDhUJMNvGfiIaFg/fHS/+NDulMW4FxiRSlC+BQndiyzaX5gVjbtF4
	XOKwV7O85qf8GrP0rr7OzG51X9It9J4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7791E42B60;
	Wed, 13 May 2026 08:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CFAC2BCB7;
	Wed, 13 May 2026 08:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778661475;
	bh=Mio8D06xImBp3UeulX9BWmBmv65A0xCj9zqOBAaitqc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IKqZs1xoOi+DOw6luywW4+QUsXQbLXnZSrEmdlbyJJqFzduEDebJyuNUAMMxL0KLI
	 ycCdl7J3TcRIFWwaMj9b/i317QC4x48baI4+fAWaoKeR58g3FfxxQWlGW0jWfZUYJJ
	 j2nD2EYqpRX0rxFZ792Q6xEx0wvgt5i5VgYUq8V5wpjnLWljSVR+zcmQC/Q5KOItzn
	 queSnaazyRx2tC4HDENaBtGRNfl70btZSDo4YkDioeHq8ycOJHdnuvNNDMy3x7aTcD
	 tHxbZ+1aU2MVTldtwW/XAuKyjmW87kgnHIUUNvLhlT3f4V8jOPN8Fl/aUzvxkB8mq6
	 5+1smQ986GGFw==
Message-ID: <bbde0793-fd21-4a9c-b85d-f13d8b787c50@kernel.org>
Date: Wed, 13 May 2026 10:37:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_insert_folio()
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 intel-xe@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
 <20260512110339.6244-2-thomas.hellstrom@linux.intel.com>
 <f14d99d3-c1ff-453b-a280-17b8c4d5af94@kernel.org>
 <b4800086347aa3b27edc42b6536cb3a2b76a1aa8.camel@linux.intel.com>
 <26479389-459b-4cc4-914d-e7d29d5e5cc9@kernel.org>
 <c6b4031a-5625-4b1b-8a51-6e47241d32c9@amd.com>
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
In-Reply-To: <c6b4031a-5625-4b1b-8a51-6e47241d32c9@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bmu5otagbiiep3ew75t6767jbcz8c1e9
X-Rspam-User: 
X-Rspamd-Queue-Id: AB4C480007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778661476-888868
X-HE-Meta: U2FsdGVkX18rki4LN2dIVgFWPTFVxgzY7DVUHX1j6AFgAgCteuYfgm/vaXhvmIV6owhyw1GjATHgbciTeT8Ui9OJvv1/MHs8DewL0htV4dKd2JQLoo4Me56HKJHO1CYwatCpzBMfWped6g8rPVzYKpSbnukMTI5E8igeAp2EsJVgt80RAw5ZBzAnduiy+EsyhaW9ABboNfuWiXYJ+gbCMiGDwmjleRJFnqv3s2uTkS/XDAalJOOiHqNHEEA+F2K9wpGWv0blq8wpC2V1ZOsyALFUvD9QpXxU8WpxoXXB25EjF9OxjQDGkCVs9rOtoiOw8gw/z/Oq6l1PgfkpwN4p17RJtt4hJtM4PQ1nCpv3gQqQodF1j6wBXFRE+Dh0s4EZGGXx1FVIdoUFp2zUmuCA5/jQpPSAUqUTRosQ53uifZdoNht5eaCPIvZ8SuBYhbt88zcoxj7A3R/iLOejl3lbKK2OradgRnTvyHyvwra+BEe/5vIb4tMUY0peTaoDSNU1FGOTuGUNNoT1+eYaVW7EYakZfO9oPuTe9dmJdMaqD9oPqIWCOfTrOkKuz3xsUSJCWzoQ3VbJDUrGNh6cyj+8NQPPSLGf0s2UfMAiFTRPClBGo3b2CUl0RuQDUzHVgndcdRzqeQdQI+GqFgyQMRxKjsQSpVGH40Zf2QpjEz+kYCy+W3G74wwNPNWFexLP3Uc3MsMrt+nnhJJJnZcDLiaqEaVzDFDq7DAQzkwgaBaJYvGwRSjSgUlSXqm1nYQw9T6Y9+9LXMHNHI+p0j9qpaTW1QMKvXSHAC5Ehmr5ZXXZiMPdPZ1qhTM85lde11E6TQ5jMb7q90wmz5j6cFuPJAnJsL0yghOWaQ4QXy+jAng86ecE+EmWe33p2LYP9Wkcb9FQ8kJHVRfDkJDFLVbW4MbmAzwGpGa71VOlk2moeH+OEXhj9m+LVjNS1rXS5madQxMP0kctWl1a+uVedZwbG/5
 U21/n/v5
 bdvT5jsGmmGCNwIv4o1siJMojurxM0eDXOpA5r8L0ocnzvLPFyFHkHUslF7qpi7YFjkAM1bEJEBA3Ok3/J9p+CNkxiZDrtUxPpDR603X18rEZ/dJ2V3ZN06PlQ3kXfZHxzTPHVoiV+2eQgYtDB+Id1j+khtjg3yygGeZQtDpqNvCRoTeLbrC7Dvm1qy8uIYNjGsr1EmhgVbbeBJWZyvfHayyk3Ofb4Aah56hGXJ4SYVW/4Cq4SV16STSQEdNlJxdLBGtUazf46mcj6K3twUPPSWmRU/OaISH9U5sMMw2Q833FPEtQNdcPCnQziK4sIR3EXGv4NwPcN7mbf0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 09:47, Christian König wrote:
> Hi David & Thomas,
> 
> On 5/12/26 22:03, David Hildenbrand (Arm) wrote:
>> On 5/12/26 13:31, Thomas Hellström wrote:
> ...
>>>
>>> OK, can eliminate those. Is VM_WARN_ON_FOLIO() preferred,
>>> or any other type of assert?
>>
>> VM_WARN_ON_FOLIO() is usually what you want, or VM_WARN_ON_ONCE().
>>
>>>
>>>
>>> OK, let me understand the concern. The pages are allocated as multi-
>>> page folios using alloc_pages(gfp, order), but typically not promoted
>>> to compound pages, until inserted here. Is it that promotion that is of
>>> concern or inserting pages of unknown origin into shmem? Anything we
>>> can do to alleviate that concern?
>>
>> It's all rather questionable.
>>
>> A couple of points:
>>
>> a) The pages are allocated to be unmovable, but adding them to shmem effectively
>>    turns them movable. Now you interfere with the page allocator logic of
>>    placing movable and unmovable pages a reasonable way into
>>    pageblocks that group allocations of similar types.
>>
>> b) A driver is not supposed to decide which folio size will be allocated for
>>    shmem.
> 
> Exactly that is one of the major reasons why we aren't using a shmem as backing store for TTM buffers in the first place.

What was the problem with that the last time this was considered?

shmem nowadays supports THP (e.g., 2M) and even mTHP (e.g., 64K).

For internal mounts, it must be enabled accordingly
(/sys/kernel/mm/transparent_hugepage/.../shmem_enabled).

Some distributions still default to "never". I guess if an admin enables it, you
would just get THPs.

If "distro default" is the only problem, I guess we could think about how to
improve that. For example, just let internal GPU DRM objects allocate any folio
size available and supported etc.

Would that make it possible to just use shmem natively? (e.g., how would this
interact with shmem features like folio migration, would that be workable with
DRM objects?).

-- 
Cheers,

David

