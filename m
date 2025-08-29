Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82F93CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 01:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5B4F8E0008; Thu, 28 Aug 2025 21:55:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32ED8E0001; Thu, 28 Aug 2025 21:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F528E0008; Thu, 28 Aug 2025 21:55:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 858D88E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 21:55:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63FEFC04CF
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:55:51 +0000 (UTC)
X-FDA: 83828128902.11.BB1FE56
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf28.hostedemail.com (Postfix) with ESMTP id BFCFBC0006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:55:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=B92fYg2u;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756432549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJhaXXSDqG4GAemXi4WtUd9dZ0qacHvLnl2G4eecVXc=;
	b=dNBdRgF32toPJPr03oGSW7livrzkp8i+yFqKrQhzReCtTAfc6bl8MHxTeXuLj31ue2FWxY
	HczAaY+Soi+Gz9zJLMjXM/GfmBLuKN0g10siYnvI5W1neeVoEhQD0TUbrJqPPaX+B32tOM
	TPeopboXx5il8grWiH6sUpJz34x1J9I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=B92fYg2u;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756432549; a=rsa-sha256;
	cv=none;
	b=Z/31lNyBpcJ2e0/SED6APeznuoVPK8xIfLsEgKbb3p7zHLaVKsjR5hLjv1kXnocifPOu27
	rXNGUVT4zBgRxON0xYGKjnJEZANOGnDpAjR8xo7MD+2ljL59w9yds0Dmf7vjU5ukFap1Ff
	PSwC4sTsAzycidIQfUFOchwull4CDEE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756432545; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lJhaXXSDqG4GAemXi4WtUd9dZ0qacHvLnl2G4eecVXc=;
	b=B92fYg2ulY2PUvS20VsurrbPF0SFKGMwsaCm5aPgGBjpElHcatpZb8KC+OXHWdd3wTeepWNBB/JUKjfj+abe91r5bBdtXSO6KT6w0eeelWyzXQ9j1OmhjFv41VE40USsyyxgZ5tOG95UYMJkjPqA3wFM0oypGEwVeD5rob3UehM=
Received: from 30.74.144.113(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wmpa1nb_1756432541 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 29 Aug 2025 09:55:42 +0800
Message-ID: <2a141eef-46e2-46e1-9b0f-066ec537600d@linux.alibaba.com>
Date: Fri, 29 Aug 2025 09:55:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Dev Jain <dev.jain@arm.com>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
References: <20250819134205.622806-1-npache@redhat.com>
 <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com>
 <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <c8c5e818-536a-4d72-b8dc-36aeb1b61800@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BFCFBC0006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dic9e6xazhpfprftye8p9orfb4ajrr31
X-HE-Tag: 1756432548-525317
X-HE-Meta: U2FsdGVkX187WFP2bFKmnrdisQgRTKnCBxxjau/UU+0zSv9T4THzPWNUsrSt6PreqaZ5myNubzS/zUrNcGWAlILSmTFwGc2hlkvjzmJ1BhpZK4sTX/w810ux7I20uJUiQPVJ+dyy/OQswewiHXQDA0dZFAghA2TJ6TEVv5P2TV4F9lLSHyoZeDHZO6OqYLhQdykcKLKxmvVKFXwNifzpOFigjFi5rMvcw1PwiF1SCxFaZw/lSjTtjWZHMO/wshLeXBRhQUCG+LocsJb68nfN0kbiyoz1BejQJRYyy5/+iFGQb7DnMwJY7D8Gv8jStEJmy1xhzddu8zV8L/D1a9SUyUOOqGO5PXw9lsjYFx1fpsOe1nl+sNGe5rXP0JFJkGhXWcbL4HYlCchk+1qH1S2qptumNexEcFlChVGNf3Q4LCPj5RBolmNZ/um3Mhet9cVinTapnixSbbBkeWNujRVLNDs2x2ELwH9SGUmat+FsiqN7t2avx/lq/7QXCCU/O2hveBxzxE4IM5nTZAA0ce69BmpUwEHwS8WhT7ocI26NwdxmZE1u7dOZsnwyl/S3xUSWIlTi1KdUv29c/TLQhz1XM/71lG0Oynb3XqihnVMZXc0j6KKT+1aT+8IYaM8tiwh569eewngZ2Plb534f/vdIKHjbbHmVeq4KXr76P4gkX+wtccL+iyFDutuc4yb7Xlh2/z+566EDK//j3+srm6f/p9Qz8liPQo1FW7xLQdJNrxwbFSlJUFVFD+y23oY4pvUaX7fhhczfkBdM4H4yzLQrXJHObX5o+lqBv0C6q7dbv/9+p60Dj94l2A0Z4RawwtMc8nRL5mtuM3tbzlsqu6P5TLAPqZaFnfSSiP4PavTSnOIzBhNz2f5eRHtVG81S73MTpVcs3pjKqMnP2J7GUodbB2caNGUJQTDKcjVLSUEtBZ7ijTYN186xH5iJPLaK6vn999zdkof4Idi3sXbN0XQ
 hvFKumXc
 pv0Da7b6A7xq+dY6auq5lYq0VfmqHllYW4SvLfNWiHNJg+iBarHDjqaQDWEohDX1z4KDe8ZZoRKBZA/E47RWesFwYDsp+Ez3yNOvWrjshgRnV3r6pQN6j6I2yMyH7EYvJ8Z78ucQ+jZB/YWKIT/5wDVtaWVPHfJKxDazlz5OIMkQo027f9VgItYHgKdkM/2mIbrxGjnxNakcegQTwC8d8LJyIl+VC1z1gzK8AohcsZI/MQkfC09IOWy3rHgrwAaglOFD1N3hev3CcPm3mOioPnSwkwLSpruWUvWF+POa4acB1N9iT6lDkk5XYqaCWp7+fYV4o9pArbzWr5IGfuXnW3GbqtC7e4o3FxnyPddkNphHA96KYiFjbtmoMLet0qXv0SXgjpzRd1kK3AoPQNEMlHjFmp5UGim5nv6Vn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/28 18:48, Dev Jain wrote:
> 
> On 28/08/25 3:16 pm, Baolin Wang wrote:
>> (Sorry for chiming in late)
>>
>> On 2025/8/22 22:10, David Hildenbrand wrote:
>>>>> Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1), 
>>>>> but not sure
>>>>> if we have to add that for now.
>>>>
>>>> Yeah not so sure about this, this is a 'just have to know' too, and 
>>>> yes you
>>>> might add it to the docs, but people are going to be mightily 
>>>> confused, esp if
>>>> it's a calculated value.
>>>>
>>>> I don't see any other way around having a separate tunable if we 
>>>> don't just have
>>>> something VERY simple like on/off.
>>>
>>> Yeah, not advocating that we add support for other values than 0/511, 
>>> really.
>>>
>>>>
>>>> Also the mentioned issue sounds like something that needs to be 
>>>> fixed elsewhere
>>>> honestly in the algorithm used to figure out mTHP ranges (I may be 
>>>> wrong - and
>>>> happy to stand corrected if this is somehow inherent, but reallly 
>>>> feels that
>>>> way).
>>>
>>> I think the creep is unavoidable for certain values.
>>>
>>> If you have the first two pages of a PMD area populated, and you 
>>> allow for at least half of the #PTEs to be non/zero, you'd collapse 
>>> first a
>>> order-2 folio, then and order-3 ... until you reached PMD order.
>>>
>>> So for now we really should just support 0 / 511 to say "don't 
>>> collapse if there are holes" vs. "always collapse if there is at 
>>> least one pte used".
>>
>> If we only allow setting 0 or 511, as Nico mentioned before, "At 511, 
>> no mTHP collapses would ever occur anyway, unless you have 2MB 
>> disabled and other mTHP sizes enabled. Technically, at 511, only the 
>> highest enabled order would ever be collapsed."
> I didn't understand this statement. At 511, mTHP collapses will occur if 
> khugepaged cannot get a PMD folio. Our goal is to collapse to the 
> highest order folio.

Yes, I’m not saying that it’s incorrect behavior when set to 511. What I 
mean is, as in the example I gave below, users may only want to allow a 
large order collapse when the number of present PTEs reaches half of the 
large folio, in order to avoid RSS bloat.

So we might also need to consider whether 255 is a reasonable 
configuration for mTHP collapse.

>> In other words, for the scenario you described, although there are 
>> only 2 PTEs present in a PMD, it would still get collapsed into a PMD- 
>> sized THP. In reality, what we probably need is just an order-2 mTHP 
>> collapse.
>>
>> If 'khugepaged_max_ptes_none' is set to 255, I think this would 
>> achieve the desired result: when there are only 2 PTEs present in a 
>> PMD, an order-2 mTHP collapse would be successed, but it wouldn’t 
>> creep up to an order-3 mTHP collapse. That’s because:
>> When attempting an order-3 mTHP collapse, 'threshold_bits' = 1, while 
>> 'bits_set' = 1 (means only 1 chunk is present), so 'bits_set > 
>> threshold_bits' is false, then an order-3 mTHP collapse wouldn’t be 
>> attempted. No?
>>
>> So I have some concerns that if we only allow setting 0 or 511, it may 
>> not meet the goal we have for mTHP collapsing.
>>
>>>>> Because, as raised in the past, I'm afraid nobody on this earth has 
>>>>> a clue how
>>>>> to set this parameter to values different to 0 (don't waste memory 
>>>>> with khugepaged)
>>>>> and 511 (page fault behavior).
>>>>
>>>> Yup
>>>>
>>>>>
>>>>>
>>>>> If any other value is set, essentially
>>>>>     pr_warn("Unsupported 'max_ptes_none' value for mTHP collapse");
>>>>>
>>>>> for now and just disable it.
>>>>
>>>> Hmm but under what circumstances? I would just say unsupported value 
>>>> not mention
>>>> mTHP or people who don't use mTHP might find that confusing.
>>>
>>> Well, we can check whether any mTHP size is enabled while the value 
>>> is set to something unexpected. We can then even print the 
>>> problematic sizes if we have to.
>>>
>>> We could also just just say that if the value is set to something 
>>> else than 511 (which is the default), it will be treated as being "0" 
>>> when collapsing mthp, instead of doing any scaling.
>>>
>>


