Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 185CECCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6172F8E004F; Fri, 17 Oct 2025 04:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EEB28E0016; Fri, 17 Oct 2025 04:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52C128E004F; Fri, 17 Oct 2025 04:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 420038E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:47:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F3F2479F8
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:47:39 +0000 (UTC)
X-FDA: 84006977838.06.986E9F2
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1F7E8140008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:47:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mHdZop5p;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760690857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dD/R4CwZofsKKYJHbZWsPDyQl7J+N7r0zqZT/mrEyfo=;
	b=TBE5Uu+gHCK89UxyVORWh9n6SRg/m7eKoYIFEj/ognK+C6tuSNWA8IoVJIXrSl8UtdMurf
	Nh3yvCCOLeBrCkqnh/2u+A3VRGWKL6DFPR4lZfp8WpRviCCNI7mNFQM/AHhohkjYKaVbp9
	051RGV0P3FVlVETwjEYL0TeXh7XnWJQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mHdZop5p;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760690857; a=rsa-sha256;
	cv=none;
	b=6gi+OZIFa19HTZ/b0NurQ+s8rMj4MnmONsm/cpU5jpDhvZD6jhC9rYJ0AiCgJOhYpmXRZ3
	8kxTaFypRi1Bbj3SPlUSMCkcxBBOg/kYoDjp5LDriMxzpOKrOLMnVuB/S7rPgZHP9IK8+Y
	EOudkVtbPM6T8nu3n9sPrDl2aVnHHBo=
Message-ID: <13b41a39-cdb1-4537-b4c8-940674c5875d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760690855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dD/R4CwZofsKKYJHbZWsPDyQl7J+N7r0zqZT/mrEyfo=;
	b=mHdZop5p1rSOj+z23FxR20Rmj+8SIpqO5da+owwVu1ds+Fx4h6YWK5llE8gAjBkJCtn88S
	Jt/8gTKAoJySK399ijwf7PK+9AAtmT4OnEfh1z0qX/bjoln4vuthbReljSBj1Y8QHHA+rY
	TgFK2ZMw7Mp3pxBdD66TwaDs9jB+vKY=
Date: Fri, 17 Oct 2025 16:47:20 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: guard is_zero_pfn() calls with
 pte_present()
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>, Wei Yang
 <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251016033643.10848-1-lance.yang@linux.dev>
 <17c4c5f9-6ac8-4914-838f-f511dfbf948f@arm.com>
 <20251017012724.4bo5oj2g6tdmp2fv@master>
 <1674efca-6d4e-4247-8b1c-b6816360d8bb@redhat.com>
 <ab918a83-edb2-4a19-821d-a96de9e097eb@linux.dev>
 <4a7a7fbb-e33e-4033-91e7-efce7915cf7f@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <4a7a7fbb-e33e-4033-91e7-efce7915cf7f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: m4cuuwrghrna1bzm5kingja4am7tbqkf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1F7E8140008
X-HE-Tag: 1760690856-817195
X-HE-Meta: U2FsdGVkX1/j1bkXZgsjzvpl2QSPaXo/L1C6wp5A2x6P/DfdGrv8JYw46FrNAwXC4raOKHYmHIv+JUzgMsbtuiGDN4+PSTiy8hdg4zxAroRRIV2EnBhtwCViQjdxnl9natIs5Y/RuTiL7kPMKDXADC53E6mreN+yk8U4pV58CkyJ09msFz5FLdcfCLAzFyWIXr3yogSqwUMwBbqifE4fbDT0FJhmrwNSlsUKLPGqi5moUj4CdBBLNjmad13u1ud1GlSMFVv3+8DQJAhVDktCxHjUGAqhXVdvIfWcSxig7XGsRjELId5WgibHvMuC/QzW4egWCAv0/pfaNuyqVi6RhrrietXxL413q9uskvql1qfsLdL00oRX6rHLTsQwQRqy2lpYfXeewyB1g+PuNN70LK+caoADS1ro3vdyUUr+rQ5qNfu8nP/qioCXqVA0cQLoyKtnD9/tYy06lEz60fY4ZDH5KC6XWl8Ft8SBhDVk+SKjMj1cYy0BDPaJjHjAKgF5x8Avo6T1duPZ3G57xiqo7FAL2bbBkQaa6T7a5P2LguJwfRQ2O2JIzAqs3CbUeFaVTPXDIL47w5OdqXImXVQDGLL/HjqP8WdPdffKoMKGw5W1EGRf6pDapMFeZ7DQfS7xo/copfu5eyLLSWZXAmjFnsMTZ/KOFqCK07wFQuoD9oOR6W5+TWkYmYD+jxd0/bJ+LcbfvocKxwHhOMTMWsLMhCodnhT/5+LOcAsUvv25MM+2ijUooq2oXjAK4vLmNp0A2OXX7e8oN06thyRwaOoxFsDLq6OHEN6hupxcd+wDMVR4qsktv9ZCtSmUoIhQra7+x9xX+W4ZYrE+i2vwrRqPopcpQeq8pKZ6HTXgQcO4trBfsdDcyUOHiVD1NqbO+YbicljgxVXZEiuXJIh0lh1m++KBN9EbY841urH3GB5ybxTIi2q1bO85GA/drrLt7ILB5QhJpyogUnCz7kGEaTx
 iGDWBshe
 Dll/iMQoYnfRhWvGsE5wyxiqqwWvrm2YKiWGI1/0NFBXZwWm+6yVy09er+izLOqkFGZ+QiIVW4AFVLJejxthbwBseCKi2a75aGHEjdJyHwYDJI+PtRSv/8M3xBIYF6qqtC0TdyjTARafHjAegaP1+vUieqHT9bpRAChOYLEDg5fgASVapmMHrUUESBy59zoqhypvLYOq8u/fbAzX7w4YBWdPubA8NfJ7x4EFmI175SQLCf1uWPMPKLaOESkMGIgzvOVNRluF4neowl519eLQlZTq5lYx8BMtMDuVLTGUmk19lhPXdK78HAwSwBDsoUUH33xOwNceyFomsOBMnAO67oXr1bMkUXZqqy7VTgnQvNCqpPPaUHdZX7hnGLgC2XXUeKWVd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/17 16:43, David Hildenbrand wrote:
> On 17.10.25 10:37, Lance Yang wrote:
>>
>>
>> On 2025/10/17 16:11, David Hildenbrand wrote:
>>> On 17.10.25 03:27, Wei Yang wrote:
>>>> On Thu, Oct 16, 2025 at 11:47:06AM +0530, Dev Jain wrote:
>>>>>
>>>>> On 16/10/25 9:06 am, Lance Yang wrote:
>>>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>>>
>>>>>> A non-present entry, like a swap PTE, contains completely different
>>>>>> data
>>>>>> (swap type and offset). pte_pfn() doesn't know this, so if we feed 
>>>>>> it a
>>>>>> non-present entry, it will spit out a junk PFN.
>>>>>>
>>>>>> What if that junk PFN happens to match the zeropage's PFN by sheer
>>>>>> chance? While really unlikely, this would be really bad if it did.
>>>>>>
>>>>>> So, let's fix this potential bug by ensuring all calls to 
>>>>>> is_zero_pfn()
>>>>>> in khugepaged.c are properly guarded by a pte_present() check.
>>>>>>
>>>>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>>>> ---
>>>>>>     mm/khugepaged.c | 13 ++++++++-----
>>>>>>     1 file changed, 8 insertions(+), 5 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>>> index d635d821f611..0341c3d13e9e 100644
>>>>>> --- a/mm/khugepaged.c
>>>>>> +++ b/mm/khugepaged.c
>>>>>> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t
>>>>>> *_pte,
>>>>>>             pte_t pteval = ptep_get(_pte);
>>>>>>             unsigned long pfn;
>>>>>> -        if (pte_none(pteval))
>>>>>> +        if (!pte_present(pteval))
>>>>>>                 continue;
>>>>>>             pfn = pte_pfn(pteval);
>>>>>>             if (is_zero_pfn(pfn))
>>>>>> @@ -690,9 +690,10 @@ static void
>>>>>> __collapse_huge_page_copy_succeeded(pte_t *pte,
>>>>>>              address += nr_ptes * PAGE_SIZE) {
>>>>>>             nr_ptes = 1;
>>>>>>             pteval = ptep_get(_pte);
>>>>>> -        if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>>>>>> +        if (pte_none(pteval) ||
>>>>>> +            (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>>>>>>                 add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
>>>>>> -            if (is_zero_pfn(pte_pfn(pteval))) {
>>>>>> +            if (!pte_none(pteval)) {
>>>>>
>>>>> Could save a level of indentation by saying
>>>>> if (pte_none(pteval))
>>>>>      continue;
>>>>>
>>>>
>>>> Vote for this :-)
>>>
>>> I suspect there will be a v2, correct?
>>
>> I was hoping a v2 wouldn't be necessary for this ;p
>>
>> Of course, if we'd prefer a v2, I'm happy to send one out.
> 
> I lost track of what the result will be, so a v2 would be nice at least 
> for me :)

Sure. V2 on the way ;)


