Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2E3BCA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 03:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0307D8E0002; Tue,  2 Sep 2025 23:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24418E0001; Tue,  2 Sep 2025 23:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A428E0002; Tue,  2 Sep 2025 23:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE8228E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 23:28:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 751C71604AD
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:28:08 +0000 (UTC)
X-FDA: 83846505456.13.F87965A
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2DE471A0008
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:28:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BkZAXLvt;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756870086; a=rsa-sha256;
	cv=none;
	b=xcZEgX3ZFAkFRLULkjIQjLKyoU9Q968NRcv42mc3Nl3KS/nLk6BPiwnxx+PxW3ozAuMh3F
	+i9Jke+XBHONjQF7MkpdsPqsWl+kUXGQHkLc3KSCcVHaXrfU+RVyQohlDnMXVHcIGH4JWV
	VW5notGgUiD89qjA2s4SRnyyWjsRPn8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BkZAXLvt;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756870086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9pNvoK8E483FKVV4UiISiOQElVaIf1JmFvnG6QIAnXY=;
	b=tsAQ4N3xp6neLx75LkDsfge9Kr85UIy5hJDZj30vteseIQkeZe1YNR6zrRjOeF9hWz5fY+
	/w+J1xwefBUEk681rMNMGBHVZ9AflH3GeCJPNa559Sl6c2ydfGGM7GlKFzcWUyBxZUMw1S
	0tr32RpJ6oRev4vr6YQfYVynTutOA3E=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756870081; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=9pNvoK8E483FKVV4UiISiOQElVaIf1JmFvnG6QIAnXY=;
	b=BkZAXLvtY0n2juOzVrzk/O44rN55Z1lhmA7cKSsAjIhLiMp1f31QElyu1OcYd7RThpKiZdYKIoOi2GpgwvtJ/T27VRg7G8G9Ea8+WrkHB9UkoNGcxTVAfFZFvavLgdR4OyCpozvD4EvQ34pXRSF1vspFNHpBgho7BiacA12h9to=
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnA-49f_1756870075 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Sep 2025 11:27:57 +0800
Message-ID: <9ccc6d6b-c077-4b8a-b8da-99cabf182e17@linux.alibaba.com>
Date: Wed, 3 Sep 2025 11:27:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Usama Arif <usamaarif642@gmail.com>, David Hildenbrand
 <david@redhat.com>, Dev Jain <dev.jain@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kirill.shutemov@linux.intel.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
 <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
 <CAA1CXcBDq9PucQdfQRh1iqJLPB6Jn6mNy28v_AuHWb9kz1gpqQ@mail.gmail.com>
 <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
 <95012dfc-d82d-4ae2-b4cd-1e8dcf15e44b@redhat.com>
 <bdbb5168-7657-4f11-a42d-b75cce7e0bca@lucifer.local>
 <e34e1ffe-c377-4c9a-b28b-ca873f3620ac@redhat.com>
 <db2320ee-6bd4-49c1-8fce-0468f48e1842@linux.alibaba.com>
 <c8c5e818-536a-4d72-b8dc-36aeb1b61800@arm.com>
 <2a141eef-46e2-46e1-9b0f-066ec537600d@linux.alibaba.com>
 <f34b5fcb-6a97-4d97-86a8-906083b53be6@redhat.com>
 <eb02c281-6d41-44af-8eaf-8ffc29153a3a@linux.alibaba.com>
 <286e2cb3-6beb-4d21-b28a-2f99bb2f759b@redhat.com>
 <17075d6a-a209-4636-ae42-2f8944aea745@gmail.com>
 <287f3b64-bc34-48d9-9778-c519260c3dba@redhat.com>
 <ad6ed55e-2471-46be-b123-5272f3052e01@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ad6ed55e-2471-46be-b123-5272f3052e01@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DE471A0008
X-Stat-Signature: bqy89m9n7rsiyrzy19ehzdsegpomznqr
X-HE-Tag: 1756870084-458143
X-HE-Meta: U2FsdGVkX1+AWBF+/91vnyAUWF8gMsoD+7kkgnSYhbeMuLpQ5nrfO5mFpcscJI7qFlPXw/g6DExJQ5bTN7tX3CskiKSrTAv6M4ZYDBLNvPVYPQ/WG75G+ABgzzWr8DNxE7r66YICNH4ohQDlRSfQrFln4XFez+fYY6ngSUBj2dKvxxyweI+iTj8FdSw3qORk368ytk9+4ZYVX71ETHR/mBBK/AUEUf5skMkUouolfs50hfpI7DwuZgDRFAb6QDCYQ47iOalyT5odtvXbH12gGw987r9ZJQPi1YWerCBhZVrNqoH9toiyIUs215/7xrJtnqz7JDtMTLwvvSD0UuVZ/cglocJQCaYXUgvEg+AtOTlMWCEw0RW8WAYxjhv18GoNGfDBZM+/ZYV4QNN7S1e2jd9YxmPyaEYCJP/88zINHk1lT91N8tQrDOrEF1BRiFKKNUtY0c/Y77p7smG2mFE1fDPQZgVBnyJRfDQTVR4yewAXFBiyDoARXOhCXR1gKHO4KUP+fULzTRgZejHc/LE9g0xuaNbiBVi+9AXw/IN0cetlpc7rTLFo/Lezgo4C8R+hs73OdOhRida3U+SOPJTZvpBKromzIQVMm8fs6bZx5x5mEO9H9dYBFdowmngHFhXywE8Pwz8aJS4t3Uvgsrf3L9fcZAnER4yFAKL7FeAhpk0EV8SF8zGM6/TjpEX23IDKxpkNxircTHp9tiYwSI21v8HkQoCflPLOU+RgeuXGPHv0TSLeUWRqybJraFwmqJ/5hGiI5jN97akZl3v8cfAwOv8twmAkGwciWuLBpJATJL6EQ95j66T/FiMfGSvW/GKZyVszyp/yykrc3w3FnbMiyvPEZMFm9C+6ZGNKI7zffXoDfAVuA3DC7cPZBV2YIScSDU+WfLeb1hbS0QLCU6b/jBE9IgLIBlWc65Los8YNPdFyEU8PTP2Zn/v0f1UOBMBeHaonDSud9lgJX+/9DuQ
 HX+r2M3T
 iajtsbHU6/KJT8aSd+d/S0DKoa9e4uPCn5ZWJ0ohXQPLdNsiCzcgiQ6Yo0Mj5YbCjjVSKYICco1UTj9oZzG6vdhst0p8RzkN3NmRzqOtFs0Pnb2maC4S6PNwxwkzFNGOwXjSUP1h/EKvEnbybzI8rPjmYYq2LCa1OXbZuWL0VwRiEAvVYnbGDsGwe+qLcRauppipHWFjsrGFnxX5GNUk9H6dqvMKtsFseAVVo4iwuus+Iyj1EFnuS54FMbWdgfQ1AYDN/VS+Angxvksj8fnKNh1uTXW5wyfAaHAIELQPAZd7pRv35Ee0KiwpMrBcXpEy3ygPDDxabnirm7ZkFTr0AndZJHcEBEyYj7Cn+Sq5g0wtP66b2I/WvIETll2Y9VZfHlhV42Mw+XUamKdr2MCsgM4IqQmbT2W4yTyd5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/3 04:23, Usama Arif wrote:
> 
> 
> On 02/09/2025 12:03, David Hildenbrand wrote:
>> On 02.09.25 12:34, Usama Arif wrote:
>>>
>>>
>>> On 02/09/2025 10:03, David Hildenbrand wrote:
>>>> On 02.09.25 04:28, Baolin Wang wrote:
>>>>>
>>>>>
>>>>> On 2025/9/2 00:46, David Hildenbrand wrote:
>>>>>> On 29.08.25 03:55, Baolin Wang wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 2025/8/28 18:48, Dev Jain wrote:
>>>>>>>>
>>>>>>>> On 28/08/25 3:16 pm, Baolin Wang wrote:
>>>>>>>>> (Sorry for chiming in late)
>>>>>>>>>
>>>>>>>>> On 2025/8/22 22:10, David Hildenbrand wrote:
>>>>>>>>>>>> Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1),
>>>>>>>>>>>> but not sure
>>>>>>>>>>>> if we have to add that for now.
>>>>>>>>>>>
>>>>>>>>>>> Yeah not so sure about this, this is a 'just have to know' too, and
>>>>>>>>>>> yes you
>>>>>>>>>>> might add it to the docs, but people are going to be mightily
>>>>>>>>>>> confused, esp if
>>>>>>>>>>> it's a calculated value.
>>>>>>>>>>>
>>>>>>>>>>> I don't see any other way around having a separate tunable if we
>>>>>>>>>>> don't just have
>>>>>>>>>>> something VERY simple like on/off.
>>>>>>>>>>
>>>>>>>>>> Yeah, not advocating that we add support for other values than 0/511,
>>>>>>>>>> really.
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Also the mentioned issue sounds like something that needs to be
>>>>>>>>>>> fixed elsewhere
>>>>>>>>>>> honestly in the algorithm used to figure out mTHP ranges (I may be
>>>>>>>>>>> wrong - and
>>>>>>>>>>> happy to stand corrected if this is somehow inherent, but reallly
>>>>>>>>>>> feels that
>>>>>>>>>>> way).
>>>>>>>>>>
>>>>>>>>>> I think the creep is unavoidable for certain values.
>>>>>>>>>>
>>>>>>>>>> If you have the first two pages of a PMD area populated, and you
>>>>>>>>>> allow for at least half of the #PTEs to be non/zero, you'd collapse
>>>>>>>>>> first a
>>>>>>>>>> order-2 folio, then and order-3 ... until you reached PMD order.
>>>>>>>>>>
>>>>>>>>>> So for now we really should just support 0 / 511 to say "don't
>>>>>>>>>> collapse if there are holes" vs. "always collapse if there is at
>>>>>>>>>> least one pte used".
>>>>>>>>>
>>>>>>>>> If we only allow setting 0 or 511, as Nico mentioned before, "At 511,
>>>>>>>>> no mTHP collapses would ever occur anyway, unless you have 2MB
>>>>>>>>> disabled and other mTHP sizes enabled. Technically, at 511, only the
>>>>>>>>> highest enabled order would ever be collapsed."
>>>>>>>> I didn't understand this statement. At 511, mTHP collapses will occur if
>>>>>>>> khugepaged cannot get a PMD folio. Our goal is to collapse to the
>>>>>>>> highest order folio.
>>>>>>>
>>>>>>> Yes, I’m not saying that it’s incorrect behavior when set to 511. What I
>>>>>>> mean is, as in the example I gave below, users may only want to allow a
>>>>>>> large order collapse when the number of present PTEs reaches half of the
>>>>>>> large folio, in order to avoid RSS bloat.
>>>>>>
>>>>>> How do these users control allocation at fault time where this parameter
>>>>>> is completely ignored?
>>>>>
>>>>> Sorry, I did not get your point. Why does the 'max_pte_none' need to
>>>>> control allocation at fault time? Could you be more specific? Thanks.
>>>>
>>>> The comment over khugepaged_max_ptes_none gives a hint:
>>>>
>>>> /*
>>>>    * default collapse hugepages if there is at least one pte mapped like
>>>>    * it would have happened if the vma was large enough during page
>>>>    * fault.
>>>>    *
>>>>    * Note that these are only respected if collapse was initiated by khugepaged.
>>>>    */
>>>>
>>>> In the common case (for anything that really cares about RSS bloat) you will just a
>>>> get a THP during page fault and consequently RSS bloat.
>>>>
>>>> As raised in my other reply, the only documented reason to set max_ptes_none=0 seems
>>>> to be when an application later (after once possibly getting a THP already during
>>>> page faults) did some MADV_DONTNEED and wants to control the usage of THPs itself using
>>>> MADV_COLLAPSE.
>>>>
>>>> It's a questionable use case, that already got more problematic with mTHP and page
>>>> table reclaim.
>>>>
>>>> Let me explain:
>>>>
>>>> Before mTHP, if someone would MADV_DONTNEED (resulting in
>>>> a page table with at least one pte_none entry), there would have been no way we would
>>>> get memory over-allocated afterwards with max_ptes_none=0.
>>>>
>>>> (1) Page faults would spot "there is a page table" and just fallback to order-0 pages.
>>>> (2) khugepaged was told to not collapse through max_ptes_none=0.
>>>>
>>>> But now:
>>>>
>>>> (A) With mTHP during page-faults, we can just end up over-allocating memory in such
>>>>       an area again: page faults will simply spot a bunch of pte_nones around the fault area
>>>>       and install an mTHP.
>>>>
>>>> (B) With page table reclaim (when zapping all PTEs in a table at once), we will reclaim the
>>>>       page table. The next page fault will just try installing a PMD THP again, because there is
>>>>       no PTE table anymore.
>>>>
>>>> So I question the utility of max_ptes_none. If you can't tame page faults, then there is only
>>>> limited sense in taming khugepaged. I think there is vale in setting max_ptes_none=0 for some
>>>> corner cases, but I am yet to learn why max_ptes_none=123 would make any sense.

Thanks David for your explanation. I see your point now.

>>> For PMD mapped THPs with THP shrinker, this has changed. You can basically tame pagefaults, as when you encounter
>>> memory pressure, the shrinker kicks in if the value is less than HPAGE_PMD_NR -1 (i.e. 511 for x86), and
>>> will break down those hugepages and free up zero-filled memory.
>>
>> You are not really taming page faults, though, you are undoing what page faults might have messed up :)
>>
>> I have seen in our prod workloads where
>>> the memory usage and THP usage can spike (usually when the workload starts), but with memory pressure,
>>> the memory usage is lower compared to with max_ptes_none = 511, while still still keeping the benefits
>>> of THPs like lower TLB misses.
>>
>> Thanks for raising that: I think the current behavior is in place such that you don't bounce back-and-forth between khugepaged collapse and shrinker-split.
>>
> 
> Yes, both collapse and shrinker split hinge on max_ptes_none to prevent one of these things thrashing the effect of the other.
> 
>> There are likely other ways to achieve that, when we have in mind that the thp shrinker will install zero pages and max_ptes_none includes
>> zero pages.
>>
>>>
>>> I do agree that the value of max_ptes_none is magical and different workloads can react very differently
>>> to it. The relationship is definitely not linear. i.e. if I use max_ptes_none = 256, it does not mean
>>> that the memory regression of using THP=always vs THP=madvise is halved.
>>
>> To which value would you set it? Just 510? 0?
>>
> 
> There are some very large workloads in the meta fleet that I experimented with and found that having
> a small value works out. I experimented with 0, 51 (10%) and 256 (50%). 51 was found to be an optimal
> comprimise in terms of application metrics improving, having an acceptable amount of memory regression and
> improved system level metrics (lower TLB misses, lower page faults). I am sure there was a better value out
> there for these workloads, but not possible to experiment with every value.
> 
> In terms of wider rollout across the fleet, we are going to target 0 (or a very very small value)
> when moving from THP=madvise to always. Mainly because it is the least likely to cause a memory regression as
> THP shrinker will deal with page faults faulting in mostly zero-filled pages and khugepaged wont collapse
> pages that are dominated by 4K zero-filled chunks.

Thanks for sharing this. We're also investigating what max_ptes_none 
should be set to in order to use the THP shrinker properly, and 
currently, our customers always set max_ptes_none to its default value: 
511, which is not good.

If 0 is better, it seems like there isn't much conflict with the values 
expected by mTHP collapse (0 and 511). Sounds good to me.

