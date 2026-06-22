Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2759FCDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61D16B008C; Mon, 22 Jun 2026 04:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBC46B0092; Mon, 22 Jun 2026 04:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28FE6B0093; Mon, 22 Jun 2026 04:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC5AC6B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:15:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E1D68B038
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:15:00 +0000 (UTC)
X-FDA: 84906837960.09.3D05AE0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 07BA31C0003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:14:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gnp3IodP;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782116098;
	b=LFnKgtrH7m7xIHCEOyrbxXGRXUniDpnecLU86T4mhttmuEFHwFll5qzvI5u/BvgymssWfp
	85zOMHXcQQDQfLpSLhAyMzlzLEbrS+bnNkEWyVkiPolGE+fJxQwL7LIGD6HxpRb4eu2eUg
	y7da5w1DjVN8eWoMs/JXiKHYnAzPKpg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gnp3IodP;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782116098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+os4f4D9ImgKLQn/d1mH2fmoljxB37D2eSbXZ+5FBc=;
	b=YO6MrYTHdmQYxr5SXGDtiFwSjRr2kozf+6P/E64OY8dzbodU4hQFMrk/JicF2VhLJ7H1qr
	MRSQBKXkomhFtayteESW3Ql2tHCGGIia0MySEqKEBppDBY6qFec/sNfo1Un9SceRwtAs8r
	RKUVuoYFbenSs34pUy8yiM4ZKulnol4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5DFCE1BF7;
	Mon, 22 Jun 2026 01:14:52 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C9523F632;
	Mon, 22 Jun 2026 01:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782116097; bh=kfN/FpTa765EpipB1e7lODEHn3FZOJnKInx4uJ85UO0=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=gnp3IodPrm2sqVyqDQ7j95a2oBiRhHNNKL3rqJyJjVEA3HbvOS/+rOU/vexI9+H1u
	 rHl+MtXyGAfJLWBIjr/V8D80HxS5qUYAMNAc1XZ18u5gnryrxrPw/IoYe4NjvT9wDo
	 /5YcudYDmBmUay6rByCKKgj18d6G6W6MWY7HjsUg=
Message-ID: <ae987527-7ab1-4905-b7f4-8fcc3bebdd52@arm.com>
Date: Mon, 22 Jun 2026 13:44:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
From: Dev Jain <dev.jain@arm.com>
To: Lance Yang <lance.yang@linux.dev>,
 "David Hildenbrand (Arm)" <david@kernel.org>
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
Content-Language: en-US
In-Reply-To: <dcfba95b-8cb0-4fa7-a21f-49b595eb92dd@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 07BA31C0003
X-Stat-Signature: mqfzzwi9q3xwo3tey3bwrbz7drtiwmy8
X-Rspam-User: 
X-HE-Tag: 1782116097-85572
X-HE-Meta: U2FsdGVkX1/jXLkdHJI/pvNLMHj+zbNgP3lzuVkUikzxbOVXkWikkB0UakbqhZ2TiPO0GUrkHojoRqjxxARNtDf4Uh4UMJ5cAw6spLQAuD5kGtxIriFnYNhCeFal21uMAdIE82mK1s8F2AjjZoZcWpno/Wi8cmAACJQ4ZSZ7FFMZIhkGs3mvj5dfCoBA2LZ698zbZ+VSoavvL5GMixmKOXcOxvByWuRHIeBjuej8ES8geGK660D9VdGSUzWB1hfTD920pBbeMLvF1b2H/jrDmR9hwDLltc/+5/sX7O8bkPn3+jheuL8N9HHgyW4gz9yCbaZfl2ZxqbuJRTU4bDMvQFe7ZV3JDi5KKc+rywIYZkW68iAH2N2YtcqYPfk+Op/2msPJTgDRJyP3vQ+7dAzxQ8K8RIojB1yAkTWBo8k/G5B4YWMPsC2UI/IBgn6xZ1jsjJgehOWSBy6LTNwEgnOgdhNIB53IHiKbRHwxizCDNtE3TXZIavaf7C3CqE7Ja7EmrZd/qgXlyhpEGxSwExFApuo5fI84q9qe9BleOhHYDTBq16EaGEn47AbNOPPe1CNHIM0f8UpC0VgEbOil3O4nQwJc+D0pCNkvcoimc0kUxQ/Vj9B8kDp8mNBSKbNpBVXgONenxNF6J5eOkam+hLbPfqp0NtASUGzxMbhurdd0tMkLmWZZKsr7v3jVZLQF1vqybbq8rR49xZIvi8FO5cw3Kagp5d1na7ohFKylF9j0tZJqEviqNFFCppRlIdElDSCMQ6LzJMaa4MG5viXtfag4i6XDA9nTEtrbbmmzK5gt/kpIpo/0zRpQOKEqSzLmipaC8J+HAZo4cvLiw1pujSTCvKtKMNhsYI6jS3j1RiCVL2NpbAj3nyUMwqbgYqu6qsv6fl4/W5Ezq0p6mjQOC47QGRdNsrb3ZyYJ3zKytgAqoc5fp1shP8l/AMQuxohGrWxPn+AsbGChnYtb7tszNvi
 EmAEJFJY
 fXIU4L/RlNMB/J+eL+RgECTPoo2JxedKiTaE43QiHm1h4UI8KIr1UYvKChqVGiTcv3yN6WXiDEq9TI4/7qVrBp3XmgHlaDhau7QDFFa+A+dnRI/pHLQBYC8aCQcpNiiBit2XeMUlyAlNchW3unbWoJ/2rK63TMisYjaNLX9oUOhD09lXdgrtUokGJMqwLawfzoF9g78GZL2Wc9knft2iAPBEZiWncKCtfymWEJC/SecIJ8cofg81wyKaWrsFGG7Ohy9InAbd1Aah6J8xzmhKAhpPeWSyef3WjRdLeCryyA1qO3fXBopoN4miC1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/06/26 1:43 pm, Dev Jain wrote:
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
>>>>>>      return __rste_to_pte(pte_val(*ptep));
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
>>>      pte_pfn(x) -> (pte_val(x) >> PAGE_SHIFT)
>>>
>>> check. I don't think this applies, because
>>>
>>> While
>>>     #define _SEGMENT_ENTRY_ORIGIN_LARGE ~0xfffffUL
>>>
>>> We also have
>>>
>>>     #define _SEGMENT_ENTRY_ORIGIN ~0x7ffUL
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
> 

Lemme send a series for them. Main thing is identifying the fixes tag really.

> 
> 


