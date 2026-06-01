Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF9ECD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBEB66B02D2; Mon,  1 Jun 2026 04:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6EC76B02D3; Mon,  1 Jun 2026 04:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5D946B02D4; Mon,  1 Jun 2026 04:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1F3F6B02D2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:45:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E64B140608
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:45:14 +0000 (UTC)
X-FDA: 84830709348.17.2076CF4
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9DA052000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:45:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZLZ7xn9h;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780303512; a=rsa-sha256;
	cv=none;
	b=expJok8S3Oz9QX4JdK0E67pLAjtHCo4/2XyEqIcFiIj7Ts1nwMJesXqIYaMJ53hhjLWejs
	wsN2D0VrWf3xqbHwchxWyhg8p5AWDv7y9d8FKgvxfWWVQfVMYRJ0NjnFF/7GWoefuJNqZF
	druJsSrvoJOitTuYjMZ60IP92miRxZo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZLZ7xn9h;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780303512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KOza5WLjJJP8CiSXeBVxPUywkC8JLKE6qF7U7SNImWM=;
	b=i13ORQbfAfutsGdhlbeN9q0mj8L0fFpdQJz3UFJM8VvoFJwwIwU/wWd1iArM3VhTWqRI2o
	mNnIRb6GCWTDCqC6+X8h5VvYLccMQwB3hs5NCjnm+mTh1mSQMScL1JnO/TWwjykf47MVjy
	Zze23QR4ap+TtB8QhVAa1HVv7cHAzGE=
Message-ID: <32751424-8ad3-4fd2-9f07-8a4f5a98d632@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780303510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KOza5WLjJJP8CiSXeBVxPUywkC8JLKE6qF7U7SNImWM=;
	b=ZLZ7xn9hizllj61bp6haxPz5lrd2xU6GM6bDFO7OqfBI8FyYU42nZlvDfUN0Z5UMU7aoPF
	43AKsI66i32+vOBgOtACggTlFYEWqqH+kqMMNwAHNssdinbwxhK69jz7fMZGpnr4PB5lUn
	G1D4AFqa1xpKp9BarKxWXLQdyayfjMk=
Date: Mon, 1 Jun 2026 16:44:44 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: npache@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 usama.arif@linux.dev
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev>
 <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
 <fb8f24b1-ce8e-4f06-bbd8-f148a9bcaeee@linux.dev>
 <1c99294c-9ebe-4856-bfde-09801701d75c@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <1c99294c-9ebe-4856-bfde-09801701d75c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DA052000D
X-Rspamd-Server: rspam03
X-Stat-Signature: gxdgufmaz3e3f7us3scpspqetckjdq7o
X-HE-Tag: 1780303512-925195
X-HE-Meta: U2FsdGVkX1+GQMCwag3SxFdw7zHPWR/QaEh1Ko/XXl+Iz6UjR8Lyn9wnqD/Wh+sWRFbai6y8NgsitkK6VhLGeuX2f6TZCZdcdM08GJfiioNkwdbySxZGw8z0348TzMvj8qTiybvtUStYrkEenBIfLSrcA+RDIdB0vUh+FaBuSpgVW2vWHi6ebmCFYzgW9DF7cCo1X0PHowVErwqsmcKFN9NXciGu43o+hPYb/1TizHRNS2IrO3yt5FdffqDsHNHBehHQD4T+a7SxJj5f/ab74fdL3uy0NQ5OWHwbQ33Oo+QMlndgNfTn8mH8AxfIGtGzh776/vEvQQ+eeq66jn2xprOj5uxQ4AxmUZFyRHpVXSAIfYgPfwg17/gvwGDzLTulWdRX2Vbbz3sB0pnTBFwxxPr5Mt9a8iwuE3ulmvD4a4MtnINYwTZpbsr/Gg/2RdW4xnu27LwHafgOXnl5IvVdEqfACfBwaNuehvSDFXwlz7uIVamtPvPSwiEzHHWhFQ6zapOHZvgXVOvtPFEor9znUwrrVemAWtdvBRhDO37+fYKvFnV+J6+4r5p1PTg+9UNOmx9s41/XrtxSGs3fY/xaEexvJiyq+CdR9oQSHkqJrIfAAt5Zn59xeOf0yig7/oxHgMOO184/AmHTcU6SSRah4o0dmZdm8ar8pGgYmxUM8dSx83vRB7t/gjVDpIkt5hMsVWhwXbKHFeqHM/mZuTFZ4+B70zRi5hW+b/pKf59XwU10IykMnnIPym66oi/aXq5h6WOg+K09VgpBxLtjYCr2VbW7yHeIiVEDlnDNnW6+7ex4t6IlGUFYc656r1fwn6EWXb+MKj8JcH2mh1pEKPPGkD7eQSsabk5OSicipU1BpW0FMh00TMt7FJbMPi1PjDYr/Ap+3HrJEASQjHhGVr7+SckDvGE3O21Cq53M7N4IbsVCh66hw8gavjMQtrnvU7fOan7NLfFWRmgaVIZ1p8y
 jyw02Z4Q
 s9KFh/U8akLHN7oaX3lSdP/LCt1LDN9xLrauGG23CJh4B2dhE+iui7kfIIu3ngtoRTl8kO7sIa9V6PMYamJmMLmmrvVBVlOnsxpMkwGFz8fEttd4hZuFSSeXrxF78TcRcArCTk+zXdNtz/lmohT/d0K7gtgKhDCt+WR40FWT0pjGhkZS5C3kc/XlMkESFPcfOu2QVjXrYAkApSKNxlwXlmug19a9JP5PBX6nfuHnYMQm7diHFQGa90DpIzhA86A8A17miNLkbCfssgS7Rj8PROE7AuaxJI9tv9k8otY9237V4yTYfJ/Inw0gk0bXiDoWr4ULl6H+stz/n+TjbIqhhrifQCpHG1B2C8Not
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/1 16:15, David Hildenbrand (Arm) wrote:
> On 6/1/26 09:49, Lance Yang wrote:
>>
>>
>> On 2026/6/1 14:54, David Hildenbrand (Arm) wrote:
>>> On 6/1/26 05:28, Lance Yang wrote:
>>>>
>>>>
>>>> Ah, fair point.
>>>>
>>>> I was mostly worried about arch hooks that walk vma->vm_mm again, rather
>>>> than only using the pte pointer passed in. For example, mips does:
>>>
>>> Right, a re-walk would be the real problem.
>>>
>>>>
>>>>     update_mmu_cache_range()
>>>>       -> __update_tlb()
>>>>         -> pgd_offset(vma->vm_mm, address)
>>>>         -> pte_offset_map(...)
>>>>
>>>> and __update_tlb() has this assumption:
>>>>
>>>>          /*
>>>>           * update_mmu_cache() is called between pte_offset_map_lock()
>>>>           * and pte_unmap_unlock(), so we can assume that ptep is not
>>>>           * NULL here: and what should be done below if it were NULL?
>>>>           */
>>>>
>>>> So if khugepaged happens to run with current->active_mm == vma->vm_mm
>>>> here, could __update_tlb() hit the none PMD, get NULL from
>>>> pte_offset_map(), and then dereference it?
>>>
>>> Likely yes -- that MIPS code is horrible. And the comment in MIPS code
>>> even spells that out. :(
>>>
>>> Do you know about other code like that, or is MIPS the only one doing a
>>> re-walk and crossing fingers?
>>
>> I had Codex do the boring grep-work through the arch update_mmu_cache*
>> code :D
>>
>> MIPS doesn't seem to be the only code doing a re-walk, but it is the
>> only one I found that appears to assume the PMD/PTE walk cannot fail,
>> without checking whether the PMD is none ...
> 
> Okay, but likely the other code that tries to handle it is also problematic.
> 
> Best to make sure the page table is already installed when updating the entries.

Neat, makes sense to me :D

That way the page talbe is back in place before any arch hook gets to 
look at it :)


