Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E9DBCDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17826B008A; Mon, 22 Jun 2026 04:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8436B008C; Mon, 22 Jun 2026 04:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05C76B0092; Mon, 22 Jun 2026 04:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89EEB6B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:14:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 145FA1C31EA
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:14:55 +0000 (UTC)
X-FDA: 84906837750.17.D28E8B1
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id D0DFA8000B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:14:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w4htQ3HE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782116093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3h1tz/dJ9kRilDDcZ539pJ47xNMN6AhgjIhHbqlewzg=;
	b=DAlTXDsICbt/CcuJtrNdjvTHcUyoF/rmnRGLwEVvIRgmdDyCUioyrSOL/lMAViFR9gRayv
	H0Ax3oeFN665jqHlQKlCHjlklEBf2jvGil0fDQQikgTzJ6SqxYPNE9Ic2GdIE+n2qpY/tz
	MHTR8F1clBjCZmFWTjtHEQW41nGyvbk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782116093;
	b=BUqjD1uKwTj3WCLiiRVw/Diyz0Vnu5cXc5cL8lPg9w9RNkEPBgAa6jpGeP1w5aMJPWChup
	ElMmrJ1hspS88sqqi483ClDBsjL3txtcbrOmzk51cCad77PL7xw5yQ0mCV+OEH1XoOvzQq
	dJqLdGU1RicvAdlEE/WoxFOYrxOAGbE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w4htQ3HE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <2021e00b-2943-479b-8309-4f6dc97131d7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782116090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3h1tz/dJ9kRilDDcZ539pJ47xNMN6AhgjIhHbqlewzg=;
	b=w4htQ3HEU9Rzbt7I5wvpTk37qhZ+QsSfLijIP2mn8RiggNHxe8KlkxdI/KIYAsfFAHtqdZ
	rTrX+GtW4pCVWmyFKlInAc0NWeHhAJDgSVG5P2wSjn436VVa+rRrk/2iepmMUxHhzR5kYB
	3fiYYqpHWQoHrjvy3mp0nP117HpmnEo=
Date: Mon, 22 Jun 2026 16:14:35 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, chrisl@kernel.org,
 kasong@tencent.com, hughd@google.com, liam@infradead.org, riel@surriel.com,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, baolin.wang@linux.alibaba.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <ee0d499c-de98-4860-bfd0-0bce0b4c1bdc@kernel.org>
 <20260618074449.24974-1-lance.yang@linux.dev>
 <d6259e43-e507-48a4-a048-93b5df2f1b62@kernel.org>
 <0fe2a584-c633-4f82-8c47-d204e3b39a57@linux.dev>
 <e64fc2f2-c4a0-434a-8d60-dcb28b99b8c6@kernel.org>
 <22613c23-612b-4de0-8731-00ad2da63eae@linux.dev>
 <dcfba95b-8cb0-4fa7-a21f-49b595eb92dd@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <dcfba95b-8cb0-4fa7-a21f-49b595eb92dd@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D0DFA8000B
X-Rspam-User: 
X-Stat-Signature: drtu8s51yzbtestie3a61pjbu6gt1kw4
X-HE-Tag: 1782116092-625802
X-HE-Meta: U2FsdGVkX18v2VoVRsZx65mXCaBOebhNgLA9xzuWGVrYMyX+V8diztIWVWWJSrDOdo4YXWS0K+G/mn9o1yB8LBg20JIlMwSYIRpVIFe1WgWRuxmRLayrYhxYO0K5+UrMqx3xptnQxpreIshLv93jd5IWDYa6R2mo7DJ2ufwf4Y7WeT1gSg60D6yfn84m/5WhtN9O6pZmsYW6CKmY2Im3x9K+zN5GbOYaGHBbvV88eOSOCqvIp+cHjUunYtt7j/fthYnFeP3jZ/9fDmN5thzu4MgOKE8EI+RUh8k5iuc/pQBwAEgPu8IK/BNQNw8r6QBQiST7DgukcEbgMCXPnb7Y6QTa0fVLAohTHPXZ0Fau2dXN+1W3QSgzIdN8ApUXYFFvpcS7XK4ClG3Bdv7oh6e2Us+pD9FGrQiEMKo7EGVZaGKbV07X3jJgMeiRxQ7/UohgKEY/j/N9A5hwrRwbnuxpmkbzbPuKGkDVVYZOrqORg7Fh0ZQpAFKwb79noIWBn+nCryQrArZLruaWu4mzc+oF3GESvxvJUSy0o5/VR3Z+BA/VmLMrk1Q46dMEyonE0hXndcQ6v9x1G/GXbk60dSJDWJvBo0iJjNeTFboiqmPJFmvCbOeLzszNFxNRM8OlkCeNrAkboCzZYZ3t1h9+nAKQzuP1XP5Rg+1658IpjRWIob/pUit+hI+dE3WAKXQyjzvI5GU45R/I3Ifs8KKqu+QKsovwb1dhaRvd90jEMrPzm1/ULb4LTzbTuAq6NP6Cbw180iEfLu4TMwx3M3zaQTsj9yisQQ841U/uQT7XEck57g8kjr0SRLjHr+gVSNerg/X8vwFVMlwEH1Mpq5lAMi0Dq5oDXC26d5bn3D3oVel9hdP8Emb9fTczW6SuoNsJxBuyZqlWuwQTUU9YcEhaI2lttF56zSWtWdRPfaTer91ojZgDbW0EQE1ekpxkyEMIAh56jOi8E61v9LNEq++ptXn
 nHLFGWcn
 tVeOQAbxIW6DeFHqp17aEnN1rdOZALUsCRd6NNifBngqCiKTdesO5C1jUUJHCC2+zuGtJJta9qaX830ISeoLWJCEzEZF/ZkXngfiyNlhuOXl6fJnppAE9AibykT3ThfTMsg8xMY3FzPpMy1isb7pTizxUlHkaqNhtR1PakKwnZ7D8A6H601Qg4wsNREX+NaXzz+nrZUTZSRw7koJEzuEkpLNFfR0/hoG43j2/4T7Dy0eecFTsVGbrUEr2C2tdvpVXtRzpRQPoo07jG02NySpzVRuQqcThCzQGtFIN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/22 16:13, Dev Jain wrote:
> 
> 
> On 18/06/26 3:31 pm, Lance Yang wrote:
>>
>>
>> On 2026/6/18 17:43, David Hildenbrand (Arm) wrote:
>>> On 6/18/26 11:09, Lance Yang wrote:
>>>>
>>>>
>>>> On 2026/6/18 15:55, David Hildenbrand (Arm) wrote:
>>>>>>       return __rste_to_pte(pte_val(*ptep));
>>>>>> }
>>>>>>
>>>>>>
>>>>>> So plain ptep_get() can feed raw huge-entry bits into pte_pfn(), and the
>>>>>> derived subpage can be wrong.
>>>>>
>>>>> Good question which impact that might have in practice?
>>>>
>>>> The subpage check can warn, but we still pass that subpage to
>>>> make_hwpoison_entry(). So the hwpoison marker can end up with the
>>>> wrong PFN?
>>>>
>>>> +    subpage = folio_page(folio, pte_pfn(pteval) - folio_pfn(folio));
>>>> +    VM_WARN_ON(folio_page(folio, 0) != subpage);
>>>> [...]
>>>> +    pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
>>>
>>> My s390x page table knowledge is a bit rusty.
>>>
>>> IIUC, it would be a problem if some PTE bits in segment/region entries (pmd/pud/
>>> ...) would pass the
>>>
>>>       pte_pfn(x) -> (pte_val(x) >> PAGE_SHIFT)
>>>
>>> check. I don't think this applies, because
>>>
>>> While
>>>      #define _SEGMENT_ENTRY_ORIGIN_LARGE ~0xfffffUL
>>>
>>> We also have
>>>
>>>      #define _SEGMENT_ENTRY_ORIGIN ~0x7ffUL
>>>
>>> So these bits are not actually used.
>>>
>>> What __rste_to_pte() primarily does is reshuffling present bits etc.
>>>
>>> So using any other bits besides the PFN would be problematic I guess.
>>>
>>> Am I wrong or isn't the present bit already at a different location? For
>>> prot-none hugetlb folios there might be a real issue, as the PTE present bit
>>> corresponds to the PMD/PUD read-permission bit.
>>>
>>>
>>> Oh my :)
>>>
>>> So yeah, we should probably fix that ahead of time unless I am missing
>>> something? Good that we separate that hugetlb crap out.
>>
>> Yeah, looks like this was already there before the split. Should this
>> be fixed separately?
> 
> Same bug is there in try_to_migrate_one(), check_pte(), remove_migration_pte()
> and prot_none_hugetlb_entry() :)

Oh my :)


