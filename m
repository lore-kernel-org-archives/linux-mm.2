Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CFC4CD4F35
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99BB16B0005; Wed, 13 May 2026 06:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923CD6B008A; Wed, 13 May 2026 06:03:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4896B008C; Wed, 13 May 2026 06:03:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 66F196B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:03:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F19D51207B5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:03:37 +0000 (UTC)
X-FDA: 84761959674.06.DE1219F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id EE0E618000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:03:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QYQeNyMT;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778666616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FA+d0KPwbeDJDyO8jDcrFphrE/mc/PVRZRNuSXXA3/w=;
	b=jarynVu/+5wVt0gk3idfVuzcLH2/Y2vMTjHYzscJoFDgVMKJnt2SXT5FLYeE8ouP8NdVkL
	In7yOGS8srzwr548SOjhGi0jk0jQAm0ayyLXqQNvT7Z16F19sDbeuvx6TyWQsuBfRNm//n
	MLq7IXeca6O7eUAyfMX7uODEaYi7e7o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778666616; a=rsa-sha256;
	cv=none;
	b=sw5M1Y6YqRg40lEMQDdXjs06/Pwy/jZQrRbD/WlJsUo0AVPUFW5vhyulfPEpCXbE0jHT0u
	YUZHh+vaPROaEC5paxvUcOEwVG79u4hYCmKyHrJ+fRnny5w/R1BlCyeo/B4ZLIPVk8GPNm
	nZRe08adk42A/nAMzBFVyc4Ze+vA2pU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QYQeNyMT;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05597444FB;
	Wed, 13 May 2026 10:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F18C2BCB7;
	Wed, 13 May 2026 10:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778666614;
	bh=uNr/uFHa8lFJk/JJ/8kd9ZumVdyGQuQQfbYHdUl02UA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QYQeNyMThpHjuSLKa58f6dppmWVqBeBwSraMrvGJW3jNALwIswOENNrssr9p9eTBR
	 Q3aMvEfZFP+wFNDCbqCVIID/PyxalTbdPQy/d4sWJJkNODltdx2dFIbqTgYHOVCSoB
	 o+x01VAEcKRnWfVOq896D4oaoy82xi+n3/bEaUkrzst0INftTsXsRAbZiIOeyhKflz
	 lQnQVp928t+BO9kjs9ISzqh2vYZ6O2GILsrYPSDEY8qXCcVUiFVRWEABkx3wFA5bqt
	 Gmlh0fwZTTPBaae/HTBvWClE4tJyF27OeL2ZLc8nZbQ5TX6bjVBl/M+txt/WCt4NBV
	 rFKP3SPG1FF5Q==
Message-ID: <65596f86-e6a3-48b0-aa3d-2e608964e29d@kernel.org>
Date: Wed, 13 May 2026 12:03:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shmem: add shmem_insert_folio()
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
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
 <bbde0793-fd21-4a9c-b85d-f13d8b787c50@kernel.org>
 <1ce447ceea88bbe56c7d28654a51fc2856a7f986.camel@linux.intel.com>
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
In-Reply-To: <1ce447ceea88bbe56c7d28654a51fc2856a7f986.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EE0E618000F
X-Rspam-User: 
X-Stat-Signature: 9p4ozw9xm5pxfndfhxfapxtndotp5cas
X-HE-Tag: 1778666615-151600
X-HE-Meta: U2FsdGVkX18+AefsoWp3JfSucY+PrMpDaHAYwfarfhGqZVWN/DAEBxCSso9YG/GUrqILM1Rro4/hdJCt9tOcgYK5NlRROfigYCxO/sYpls/dFtbzatKymRJmwFmCcyOjfZ070x6zz1GB9oMT6SPFugtEDftsnGtBtl+GdcNx+e5WLIIcW7SUaYhYCi0NxKxcVcbfvOOojenie34AgA48ECNbJQzCfavR85Sb62s1vv2qFryaHhmFgpsaO6wtod9Qix1t6cGF//cZrudCfCI9P4mrRKY4hwKrRvLvpiPSzLrdRBpaRB3mmrtaTNPn9fiO9i63fyVKdN8faUjTkIv3GOefHMdkQQXlQsyCa0kmv8RZdDL6VKP1XbEp+p1Ca94qTOa4Ic++saMuVkPwsBEfTODyyXEm39jnuez+531gYy2OdGsRejk6euPf7fgaOZCGQo7bgEsENyVGS6r0aYOs0veNhxf8XKUZI5I8ZyNAAaMKwldDsz2hRNRjilXufhuYJptrUKT/CmvH3y7458chhIRA3EZMS38KCCT61ro6UOIyRN/aysafMXV7D4ZNOi+FUwZpbrbEYcUezmyYwVea9TSjGKwAXBcJNgDG8ag0GEWjwEtVDwPJR/wiCeVd+6SJPHUmwZMNgOOTI7nv8tX3vvBWbBuVrLTg2ulPPp9l3ZNtxy3H5OiJK776sRk1adBeOK3uE5leTNFtmMhApZh38mW1x2DG8nQ/VL7HjYe90K6Un7ne0CgfmIO7F6IqcAq8PUX0Y11OiqAkxuBED5loM47RrQMmQnmb1E72fd7mL52Ag+VrtqrOx50MqTmHICoTRHWHMeAmfpFnloBRwzVfDOU6qEuee+x4tcbxe+fyr69NSnyYHdf7KvTHbAJeWE+lEep3EbBoPIiqcRzuRErSWMjzcAhr38S2hAw/A13+6J/pgRZJRgP1seQp0NkjG+Dw/5ILBTn3GAr5Seky3oz
 HpR3pZnX
 iV6I8oWYQmLF8C3kFz1Paj9rjjXvQTfTYh0SwdEP6mEXlJw5FjI1egwEXGJNajffP+BsleVXaex3OROZlAsDQgPfudFn2Ef/k6hfpv+uSymgHN5UTmljByNrZYaywI2+zZRQczqmv1e+MqDXmaEE9tI0EcrpsVIy4WCULBsqP6egYc3iZPC5hM/g+b+sijfwplHYXZYq7ovtInHMxs2T/lKMy3nYJBliEgUaKFtYYyXtzbYd1QInLp1Itd4azN85pMmFp2zRikFRgJIwWPaLg7QfuoK5HaxqQhirf3Do4lMt2BC+WC28TCHpGJsdLtxodQVWUXhY/SiBa8oE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 10:51, Thomas Hellström wrote:
> On Wed, 2026-05-13 at 10:37 +0200, David Hildenbrand (Arm) wrote:
>> On 5/13/26 09:47, Christian König wrote:
>>> Hi David & Thomas,
>>>
>>> ...
>>>
>>> Exactly that is one of the major reasons why we aren't using a
>>> shmem as backing store for TTM buffers in the first place.
>>
>> What was the problem with that the last time this was considered?
>>
>> shmem nowadays supports THP (e.g., 2M) and even mTHP (e.g., 64K).
>>
>> For internal mounts, it must be enabled accordingly
>> (/sys/kernel/mm/transparent_hugepage/.../shmem_enabled).
>>
>> Some distributions still default to "never". I guess if an admin
>> enables it, you
>> would just get THPs.
> 
> FWIW, the i915 driver which uses shmem "natively" uses a special mount
> here that gives back THPs.
> 
>>
>> If "distro default" is the only problem, I guess we could think about
>> how to
>> improve that. For example, just let internal GPU DRM objects allocate
>> any folio
>> size available and supported etc.
>>
>> Would that make it possible to just use shmem natively? (e.g., how
>> would this
>> interact with shmem features like folio migration, would that be
>> workable with
>> DRM objects?).
> 
> Currently the drivers that use shmem in this way use
> "mapping_set_unevictable()" as long as the object is bound to the GPU.
> Then shrinkers can unbind from GPU and revert that setting.

Right, but mapping_set_unevictable() only affects folio_evictable() - -reclaim
behavior. Not other properties (such as folio migration).

> 
> The problem, (as also stated in the cover letter of this series) is for
> drivers that need to change caching of the pages to WC or UC.

I assume you mean "To be able to easily maintain pools of pages mapped uncached
or write-combined".

Can you point me at the code that changes the caching of the pages?

> That's an
> extremely costly operation so TTM needs to pool such allocations.
> That's where using shmem natively becomes very ugly, because you can't
> really use a 1:1 mapping between shmem objects and DRM objects anymore.

So you would require different caching attributes within a DRM object?

-- 
Cheers,

David

