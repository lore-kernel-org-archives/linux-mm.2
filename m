Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DFC6FCC9DC
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793696B008A; Tue, 10 Mar 2026 04:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7175F6B008C; Tue, 10 Mar 2026 04:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622C46B0092; Tue, 10 Mar 2026 04:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 503796B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:23:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0836513B15A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:23:36 +0000 (UTC)
X-FDA: 84529464432.09.A859FD5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 33E9C1A0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:23:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773131014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZoUAXyjI8ksm965pjBKFH/ei443oBFLgIGbLGAjoijA=;
	b=w2SCec3oIJscq+/ivK2om7/cBChJpVaMo6WjopvKRyQwUqNKbjlh0AA2w8iYmUi70RDpXB
	4fuPAjZUR8FdVTpDGB1WPV+rAPqgRwLzS3ECwfSkzWRMDu4UYLqdrN4P+QZjFLKm5JoDE+
	O7958PorJf9vfnIy72sNqtH72qOagKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773131014; a=rsa-sha256;
	cv=none;
	b=aDHzKeVvML2Xb7BhF2N/seJYF2fSaqj+xRZ+oBsLPgHW9WbJ2wn2YiO1IAT95fY2vvzG2U
	huGW9M6iJVioA2nXk7pgGZbHJEzSyaNh+eaGpS7tTlYGVwCa6ZAS1fRZ/fIWrrzkXlBnrG
	p3cpqHcDnFBMldB3zI6DgGHWnBqgRG0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 317B616A3;
	Tue, 10 Mar 2026 01:23:27 -0700 (PDT)
Received: from [10.164.19.59] (unknown [10.164.19.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 860FA3F7BD;
	Tue, 10 Mar 2026 01:23:24 -0700 (PDT)
Message-ID: <04a7465b-ee69-479f-aaa4-ccdf3ae16805@arm.com>
Date: Tue, 10 Mar 2026 13:53:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] mm/rmap: make nr_pages signed in try_to_unmap_one
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com, weixugc@google.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com,
 jannh@google.com, pfalcato@suse.de, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
 baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org,
 willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-2-dev.jain@arm.com>
 <21801fb7-0f42-4ad3-8b85-2ac6013b8aa5@lucifer.local>
 <31f93292-3de6-475c-b7fe-82ef41a3a7de@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <31f93292-3de6-475c-b7fe-82ef41a3a7de@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kzedw9jxt7pmec56w9keqy6wcpeadfuc
X-Rspam-User: 
X-Rspamd-Queue-Id: 33E9C1A0005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773131014-625946
X-HE-Meta: U2FsdGVkX18Kbaftp/1XmkWq0W7kE8NfnWYoKhNU4DBPHAaY4dkeRnxcBMNSmsi2UDi2//s4PWfcpSw0zhDQrz4jJIneite6OUKnmZpN41mh2reHyTcKmY2JU077eYASdjGoNcHDCS3dJK3yD1vSzVUjDFLcRAvLMQ5GyKfnQr3qbHhMVr/KNL3IQIxiUNhT/om+pZEzZqsw6x9Cu93ttadeC346A0PQPLZ2quOXuDIE7yBLVKIKmBt8MWsRoftBQ70NwO0fObpeNWiZjNAO6fyCr05wb82TveO+9Ug1Bj6nv+wLu771IJb6WEO3R22rcK8MNW7xxsCG2fo/8ObNXDsAXulMttKmFn7Zx9SJ1zgZod377emVCMpmYgf2euLB7JmY8wzxds5aXtjX9o4GVpALyZm3MJE6Lq8ra+1v9LEXX7jFwEsk0IKXlmgD1HnpqvMyZ7woHG8qzeBNmDqRIh1e6+i8s6w7JVYUi+7MkX6MMMdOA01IP/RQuRSw9oXg3P143oULaZHNIVjmVqSYVk/bxzhMKcIKOjpcjYEvxGu7ZI+6BbO1v+pHdbqHX1UbXbz7e5MziRdf93MYdXN59XNnzatpb7wDNNyUcBJzLPLi5aprTOfF8nr83QYbJJc4Xn+aoJGnk0wwUu9WfQT2jfwZQtI4OpYeGbIAWDmBNF3GnprAF8SL7evkaNmb8+5aZpEcEANZQIfPh3z4aKGaFpo3gUi18goFODvPpUQe/Hqe/UmbJ2ldRg9twqriafKDtKOWZYiigmASyEaCpHTOFXyFT/LjYX7LpTPFjk85M+O3YbaxJM7gIV8wq6jL4CmXfUyuWB7YRHkXENYTLbhG1gUma8S9Sez6QQqGuR96Fhn/P+LLoASCXA4UF6XMKeR62cJfZyazk7jNJJUgKKPcexbB5/I//W7Y3tcxuGXvpW8a1bNa9Bz4tRV6yWL4UOCXjAdoWdNod4dA0UyUXVg
 Z5V/tP5H
 tGEmMOOn4s2bE417yOEpx+ChoKIlMBqTPD4kTh1cpHWcS6xCATfN+ql4+C56pltS46vzUca4FVOz22w1QzRwBFouBgXDP7LdS9hEAj+x6XX158pFdndddZmfd3yjGwkGJno5/MoOkOm7HzFkavoagRSuGwnbBIx/lb5nO6+qi+IYinWLfBijNscMIrtgru5t+odyc6OhIo8cuWMgjQvf2itrITMGk4Mtri28Fx1tliSrZ+Jo9GEQBgV/YnnhJiJlnRMM7rFxuI5ASuv66e8Q54kTxKaY9kw0DNgd2IIO+mFKCVOXi8FodSSDCmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/03/26 1:36 pm, David Hildenbrand (Arm) wrote:
> On 3/10/26 08:56, Lorenzo Stoakes (Oracle) wrote:
>> On Tue, Mar 10, 2026 at 01:00:05PM +0530, Dev Jain wrote:
>>> Currently, nr_pages is defined as unsigned long. We use nr_pages to
>>> manipulate mm rss counters for lazyfree folios as follows:
>>>
>>> 	add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
>>>
>>> Suppose nr_pages = 3. -nr_pages underflows and becomes ULONG_MAX - 2. Then,
>>> since add_mm_counter() uses this -nr_pages as a long, ULONG_MAX - 2 does
>>> not fit into the positive range of long, and is converted to -3. Eventually
>>> all of this works out, but for keeping things simple, declare nr_pages as
>>> a signed variable.
>>>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> ---
>>>  mm/rmap.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 6398d7eef393f..087c9f5b884fe 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -1979,9 +1979,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>  	struct page *subpage;
>>>  	struct mmu_notifier_range range;
>>>  	enum ttu_flags flags = (enum ttu_flags)(long)arg;
>>> -	unsigned long nr_pages = 1, end_addr;
>>> +	unsigned long end_addr;
>>>  	unsigned long pfn;
>>>  	unsigned long hsz = 0;
>>> +	long nr_pages = 1;
>>
>> This is a non-issue that makes the code confusing, so let's not?
>>
>> The convention throughout the kernel is nr_pages generally is unsigned because
>> you can't have negative nr_pages.
> 
> Indeed. Documented in:
> 
> commit fa17bcd5f65ed702df001579cca8c885fa6bf3e7
> Author: Aristeu Rozanski <aris@ruivo.org>
> Date:   Tue Aug 26 11:37:21 2025 -0400
> 
>     mm: make folio page count functions return unsigned
>     
>     As raised by Andrew [1], a folio/compound page never spans a negative
>     number of pages.  Consequently, let's use "unsigned long" instead of
>     "long" consistently for folio_nr_pages(), folio_large_nr_pages() and
>     compound_nr().
>     
>     Using "unsigned long" as return value is fine, because even
>     "(long)-folio_nr_pages()" will keep on working as expected.  Using
>     "unsigned int" instead would actually break these use cases.
>     
>     This patch takes the first step changing these to return unsigned long
>     (and making drm_gem_get_pages() use the new types instead of replacing
>     min()).
>     
>     In the future, we might want to make more callers of these functions to
>     consistently use "unsigned long".

So when I was playing around with the code, I noticed that passing
unsigned int nr_pages to add_mm_counter(-nr_pages) messes up things. Then
I noticed we have an unsigned long here, which prevents that. This is quite
non-trivial information for me, especially when I searched around the
codebase and found this is the only place where we pass a negative unsigned
long.

But thanks for pointing out this commit. If it is a well-known fact that
(long)-folio_nr_pages() will work correctly, then we can drop this patch.

>     
> 
> 


