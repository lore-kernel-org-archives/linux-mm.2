Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA3CDCA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425136B00E1; Thu, 21 Aug 2025 13:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD106B00E3; Thu, 21 Aug 2025 13:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312606B00EE; Thu, 21 Aug 2025 13:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3176B00E1
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:27:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8C48117A7D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:27:11 +0000 (UTC)
X-FDA: 83801445462.07.F9F006B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 236FE14000F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:27:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=redhat.com (policy=quarantine);
	spf=pass (imf09.hostedemail.com: domain of "SRS0=upZg=3B=redhat.com=david@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=upZg=3B=redhat.com=david@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755797230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VixE144/2jOPHduLKabLC5BIcDW7Tx801gfcBH3/Xec=;
	b=iyfup5LHtPSzPzSBmduVLXVyws6JFwKN7H/JD0tJ6DHeM+Y7BVfRW+4Wu8KipYX3uTPm04
	e/3L8t4cbX3y6fDDtF2bVPe9Yh0NGo5+N4uO76aUyifVcV/OnwVvEx9wx2JxEE3POujgxc
	8iQAf2t1tFAAOgTA0goHv1BLxhhO4xM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=redhat.com (policy=quarantine);
	spf=pass (imf09.hostedemail.com: domain of "SRS0=upZg=3B=redhat.com=david@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=upZg=3B=redhat.com=david@kernel.org"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755797230; a=rsa-sha256;
	cv=none;
	b=dEP/qfEkJ3sM+SUwwq+pu4QTj6I9xXKF/7LE8JidsS5cUF5n3Sj6UXwE5DND0Y/t/JpMRr
	ajuueekxeK/qQGwUVVVfj/ZGfgTzxLRcUDBN59lhwzOJi6uf7z+zAb1YinYHOxYzvs/Z/j
	2Iupm/zG6W4ptRG9JNwz+x7mmJHfF6k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 82B8A6022C;
	Thu, 21 Aug 2025 17:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C12DC4CEF4;
	Thu, 21 Aug 2025 17:26:59 +0000 (UTC)
Message-ID: <e2e31d1d-5214-47f2-8400-6a30caf5d0fa@redhat.com>
Date: Thu, 21 Aug 2025 19:26:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nico Pache <npache@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
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
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d110a84a-a827-48b4-91c5-67cec3e92874@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dd1j9q6b9nhtdf7686kdkidqxumftxut
X-Rspam-User: 
X-Rspamd-Queue-Id: 236FE14000F
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspamd-Server: rspam05
X-Rspam: Yes
X-HE-Tag: 1755797230-546377
X-HE-Meta: U2FsdGVkX18mnBG4mWBlNchLY4zL/8N/NSNkIgpfKxCDzvnKZ9Fo4mu+OHdoTyl/yJv4B72lN9fKKcEMFHul89Y+rDA9jRmZsBw8MsozIpGVg3eRaqBOYMffIi7rd+pkoUzFFlC+cs5dBFEB31gdTV37eaOEcp0X9c5rkD7GCi42+G1abXAzc3I19UhrYS47yqa/BVW048LigCoKVi6btPrqWu8XeowuwZwDPoL5QfPCjzyYu5QxU7cqPF8GuOU64Q7pbTHMhJ+nVJ7z80h6AqKDywhJm2Ll0OIu9BgRVznvMctwG5rpCpIlIf68BgsNqbTeefvWV0FJSRNZ1NgsK+Hdg/sIzgg+80ph2hLBnMjSEplzqXEE2At7LbBuNqOY+OTj6nrG/NMN/NZeDYt59tm/55bZAGTQPKFI3tjkRDAl6OW2ookZRvCp6w1RFgRM78ys7CtmCBpNmfF2y0S8tf41F4UBZ+ImaRCZd1xCpNuj5+VZSU/MJGR8oNaI3Rz+6xbxHh5/mR+nJKJnM5ng/VL6oQwFp6aX5dMfv63YjWEQW8/E7ZrdBawa/xE/T0rNzRo1+c15kZVo8P5kKY0z49JMKZgOITPNL9dGb4nu2Rf4SpkH7BFcxeb9rmQjYRux4FbLWHR6e+vlYiv6dF6IYCc8BvJamDPxw11m/zoAvv0TY4hhJa+H0HHoZ7UVZlhXWmpo+x//jWm0KcuuTvqUGzvnBY6HBbAho2nZHIkJtDIW50pGhUx5zcCn2MrjICR79GYbAwosM9ne18BuuivV+NEMTVqqd1nYLl3TFLw3eQmfZS9hLlAfwTORFPy0PH8hyY4BgiC39HZpMTx1ypGnE0LghSMBogMNGvkPnjs/k0HQk+HkVMtwAz05DqACvOzS11mTirP5zW6f2eN2dvHZ2GJxOyU94+vYmE5yC18y2fB+ZJsM3FHtI+BBPgWtHfqm4hFYNMoJucOwhBMHVIi
 kjfWIMat
 ZfgWa6cUEB6Ow4lHntH61E4a3lZPrsf6hdmXMOehe31IjJeQ5KiZucjGXsVcayAKfO6kE9JzvoqWTtHjVXHLgNQ7WMSB1EqRLzqHQ56SUgqbAbUTQuPzRj5e8guWJCu6FefPf6Vdm1FHUQN4odq4l+OXnfu4IV6LQt2HyqTMZk/mMvuB5S0tReOgHL+rEyxfrYsFTNYRrDfy0AZ2zKwdUzP5WRf+O3qGhL37MYO+7r5WiKaVoLozTvJsi4bKLth/0jYcAMN0e4wUNMt7jnsmRG8JHe8aj8gklVh5LN/1UP7jEFIZYqJBVb+DSjZmJG9NLQFRBvRF0/bJ8aVvuCFOjv2DMDMRx3lHR2sB0gLIcjuEFy6AnPBv1AMNfaLuMcp2vtcxoS3dnpcEjQzMgPgiaS9fgmJrQxjVoIvYq2Fnjf+ujWHSBvBIx5I6L5/Ju5c1rFwO7vi7UKasZodj5hhOh0ftM9hJsiDHDDCD0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.08.25 18:54, Lorenzo Stoakes wrote:
> On Thu, Aug 21, 2025 at 10:46:18AM -0600, Nico Pache wrote:
>>>>>> Thanks and I"ll have a look, but this series is unmergeable with a broken
>>>>>> default in
>>>>>> /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_max_ptes_none_ratio
>>>>>> sorry.
>>>>>>
>>>>>> We need to have a new tunable as far as I can tell. I also find the use of
>>>>>> this PMD-specific value as an arbitrary way of expressing a ratio pretty
>>>>>> gross.
>>>>> The first thing that comes to mind is that we can pin max_ptes_none to
>>>>> 255 if it exceeds 255. It's worth noting that the issue occurs only
>>>>> for adjacently enabled mTHP sizes.
>>>
>>> No! Presumably the default of 511 (for PMDs with 512 entries) is set for a
>>> reason, arbitrarily changing this to suit a specific case seems crazy no?
>> We wouldn't be changing it for PMD collapse, just for the new
>> behavior. At 511, no mTHP collapses would ever occur anyways, unless
>> you have 2MB disabled and other mTHP sizes enabled. Technically at 511
>> only the highest enabled order always gets collapsed.
>>
>> Ive also argued in the past that 511 is a terrible default for
>> anything other than thp.enabled=always, but that's a whole other can
>> of worms we dont need to discuss now.
>>
>> with this cap of 255, the PMD scan/collapse would work as intended,
>> then in mTHP collapses we would never introduce this undesired
>> behavior. We've discussed before that this would be a hard problem to
>> solve without introducing some expensive way of tracking what has
>> already been through a collapse, and that doesnt even consider what
>> happens if things change or are unmapped, and rescanning that section
>> would be helpful. So having a strictly enforced limit of 255 actually
>> seems like a good idea to me, as it completely avoids the undesired
>> behavior and does not require the admins to be aware of such an issue.
>>
>> Another thought similar to what (IIRC) Dev has mentioned before, if we
>> have max_ptes_none > 255 then we only consider collapses to the
>> largest enabled order, that way no creep to the largest enabled order
>> would occur in the first place, and we would get there straight away.
>>
>> To me one of these two solutions seem sane in the context of what we
>> are dealing with.
>>>
>>>>>
>>>>> ie)
>>>>> if order!=HPAGE_PMD_ORDER && khugepaged_max_ptes_none > 255
>>>>>        temp_max_ptes_none = 255;
>>>> Oh and my second point, introducing a new tunable to control mTHP
>>>> collapse may become exceedingly complex from a tuning and code
>>>> management standpoint.
>>>
>>> Umm right now you hve a ratio expressed in PTES per mTHP * ((PTEs per PMD) /
>>> PMD) 'except please don't set to the usual default when using mTHP' and it's
>>> currently default-broken.
>>>
>>> I'm really not sure how that is simpler than a seprate tunable that can be
>>> expressed as a ratio (e.g. percentage) that actually makes some kind of sense?
>> I agree that the current tunable wasn't designed for this, but we
>> tried to come up with something that leverages the tunable we have to
>> avoid new tunables and added complexity.
>>>
>>> And we can make anything workable from a code management point of view by
>>> refactoring/developing appropriately.
>> What happens if max_ptes_none = 0 and the ratio is 50% - 1 pte
>> (ideally the max number)? seems like we would be saying we want no new
>> none pages, but also to allow new none pages. To me that seems equally
>> broken and more confusing than just taking a scale of the current
>> number (now with a cap).
>>
>>
> 
> The one thing we absolutely cannot have is a default that causes this
> 'creeping' behaviour. This feels like shipping something that is broken and
> alluding to it in the documentation.
> 
> I spoke to David off-list and he gave some insight into this and perhaps
> some reasonable means of avoiding an additional tunable.
> 
> I don't want to rehash what he said as I think it's more productive for him
> to reply when he has time but broadly I think how we handle this needs
> careful consideration.
> 
> To me it's clear that some sense of ratio is just immediately very very
> confusing, but then again this interface is already confusing, as with much
> of THP.
> 
> Anyway I'll let David respond here so we don't loop around before he has a
> chance to add his input.

I've been summoned.

As raised in the past, I would initially only support specific values here like

0 				  : Never collapse with any pte_none/zeropage
511 (HPAGE_PMD_NR - 1) / default  : Always collapse, ignoring pte_none/zeropage

Once could also easily support the value 255 (HPAGE_PMD_NR / 2- 1), but not sure
if we have to add that for now.

Because, as raised in the past, I'm afraid nobody on this earth has a clue how
to set this parameter to values different to 0 (don't waste memory with khugepaged)
and 511 (page fault behavior).


If any other value is set, essentially
	pr_warn("Unsupported 'max_ptes_none' value for mTHP collapse");

for now and just disable it.

-- 
Cheers

David / dhildenb

