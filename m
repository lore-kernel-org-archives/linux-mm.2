Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 797A2FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 08:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE14B6B008C; Thu, 30 Apr 2026 04:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D92326B0092; Thu, 30 Apr 2026 04:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA89E6B0093; Thu, 30 Apr 2026 04:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB1466B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:15:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 555E8C1483
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:15:28 +0000 (UTC)
X-FDA: 84714512736.22.80583D7
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf28.hostedemail.com (Postfix) with ESMTP id 67FF5C0009
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:15:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sIrfZG4L;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777536926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QeKSgDzY/uWbLPbJzTnzMQBUL5j9ZNsCB3b2Vb5/Nio=;
	b=HctZt8lAQogRwfrj+7NQoPs8Pj/+i25xc1cDkCKBB/kJWBfLzPJI1JsVPFgkIa8TELyLoz
	TV8tsC3jR5fasrUcKQ7wwv/sNwLu/j+ux4NTCiFphx1iCdCOabAnyUF5l2uWrTzMjh7MJl
	Kle/1AoqDtirXS4f6jMp8pMjYNLZvmQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sIrfZG4L;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777536926; a=rsa-sha256;
	cv=none;
	b=yC2tWuqpzomrAjlGay6pNl4gRPHdB2Ad+A2Qt8zOJzJmNTbNg5g/X3wnh8Cp8feP0g+0+g
	jHGZZiD3VUcJczdVAHD3PyVIt+AWnVfc4QfeHFxalfZgB3yi/yAVQHxgxLSntINaMI5sbi
	9Dimc4SQVSYxErfYgAFyPgXijFdWZ00=
Message-ID: <b1ececdd-a8c8-4ac2-9eee-30e8c076c43b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777536924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QeKSgDzY/uWbLPbJzTnzMQBUL5j9ZNsCB3b2Vb5/Nio=;
	b=sIrfZG4LUjkE03kAS3LxgPB4QZxWd7q3bavgFesOIcjtc2+9Fzxse9zeeU0zOGMQoNPZQK
	PdITEcGuRG8GcCeum0HuZcWpQsheDZiVU6ACTRMxddDCkYZ+1/fneY8098gWj8SPwiax9E
	NJbCSUbCJdb1tPcwENLIM6BMg6Fb0CE=
Date: Thu, 30 Apr 2026 16:15:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/huge_memory: skip huge_zero_pmd in
 zap_huge_pmd_folio()
Content-Language: en-US
To: Bibo Mao <maobibo@loongson.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <e3f542dd-f22b-fc8c-b376-72ab5909b6c8@loongson.cn>
 <20260430070217.39679-1-lance.yang@linux.dev>
 <6cdeb3e7-c399-4ead-e809-44e3d4d84bc7@loongson.cn>
 <37531e17-2a4a-44f5-af61-667331444ca2@linux.dev>
 <4807181d-c111-5568-b040-140706e56b4f@loongson.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <4807181d-c111-5568-b040-140706e56b4f@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 77ja4duxm645n559pbrey1wx177o4qes
X-Rspamd-Queue-Id: 67FF5C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777536926-789003
X-HE-Meta: U2FsdGVkX1/cqTqJeEvMyyv1tly4JO1EuVwrC1DvbUJUmbU0HbyS3QSTYinz9uMTwOeUzdRvPGj7ra7ZgVLTXAYLd9IdLAExse2r1EAEjRc/+2In0z9kO9pc86VvMG8XyT1Y9RKqNVzUtbCmnwPb9bzBXiMYQ7mmIxjjFwd5iHKq98+Mc3lI84HZ4KKGmd9OTi+9Ti3AagtYY3km0JhoVbCe4PKJ3NAFg78NlJTs/ER2fa6HwghBRazlSCGsMdSxrqH6SglhPoSDuViJcL3rZ5kDQty73FPY8WYH+LxRq/+GCQCE3OrmsbqGm+/EHUInCSh61ZYaRcl5X6lQYAO5zyeNI2GL2z9duF56AMf5pJrij9JEhV+x4QUEP3IyE7fr8Qk6k9+sCTljQvlJN4prl2/7CNWUZBt2jh6AADLOR1P7kqYQ+9Emcx7CIbFk5SPeJ4/cQjbn3Xe64s2X7yrHYZNqYnDq975RGv/KHBQlP36Y6Ee1vsZmIbnCbvdpeKtEkoxSuVJLVP9WG/1AcnmzAFm4CGggRlgqcVArd8lBFIophb6dk5C4Htxi3EaRdhNibX27oau03PepOa2lMXaN4+2DqpxQZEgGuLV7CN/Etr0o2qYecX7YdDxm7HBUwu9/hsmFFpWmkGYAbvSDvZEucRqMK+mAkpgCpPJ7vV4soY5dgAzoozRth9v4h23B168jWFD+tBC0TA8ycGeNp0sQfQR+B4DkiVAxyBl/4ktG2iPyNzXO26L5/TiyFPcyISRwBjVb8gMY3opKBzSP43RS/UDWrz3K6yH0D5ww8Ty8X6r1ugOj6qPu3rA+1/f5d353My1jG0ZiHNWSqU2iIiCfvj1IEJcjUJlDgim/yDD6TAqezSuyLsb8mUVMS77Pk1YrTrCBwhxfoIcWopugZrSeiiLm8Ue+ofHqXuiE922bwQT0Z9HSgn14tCH5Y+73Wz7Y2R1dAo7WAJRu6DjQird
 RuOdTOxD
 A5/VTWPrATLLkPO5eQtb4ok/mAHi0MsI0BChdEJ+x5jshBMthPsValgvkHyCU+35k7ufWNAV6eoxY61I73uJygY6MEPKPI8M04qiQ1U1rlq/iNu8ssTx+jyuaHlTROjMF/HhS3I3FRWYXCTYCzIQTzaGB2vVWikSsj/HM66h0JJ6HICbyaPwWhAWrCC4GJxHBUpMcb/1879VG8MOacwTwx6qGft27EduSVVP6E7jGWhLlzm54m32VWvCUIlgrcSQCKST907B8eZ7EIHk9M8wQvgueTyvL5bK2Zm4NvK60SBk8+kKfzcjDVI9tQ/x0eb0hUcNX7CYrknTTvtwzRkAZhOAZE9ATXDmPGbTCUHyo8pV18IoX5S5Y1ZGEda5H2+mG1Bn0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/30 16:09, Bibo Mao wrote:
> 
> 
> On 2026/4/30 下午3:16, Lance Yang wrote:
>>
>>
>> On 2026/4/30 15:05, Bibo Mao wrote:
>>>
>>>
>>> On 2026/4/30 下午3:02, Lance Yang wrote:
>>>>
>>>> On Thu, Apr 30, 2026 at 02:34:20PM +0800, Bibo Mao wrote:
>>>>>
>>>>>
>>>>> On 2026/4/30 下午12:28, Lance Yang wrote:
>>>>>>
>>>>>> On Thu, Apr 30, 2026 at 12:11:20PM +0800, Bibo Mao wrote:
>>>>>>> when executing command "make check" with qemu software, there is
>>>>>>> error report like this:
>>>>>>> BUG: Bad rss-counter state mm:00000000972846bc type:MM_FILEPAGES 
>>>>>>> val:-4096 Comm:bios-tables-tes Pid:27802
>>>>>>> BUG: Bad rss-counter state mm:00000000752180c5 type:MM_FILEPAGES 
>>>>>>> val:-2048 Comm:worker Pid:27815
>>>>>>> BUG: Bad rss-counter state mm:000000009c2f6a61 type:MM_FILEPAGES 
>>>>>>> val:-2048 Comm:qom-test Pid:27825
>>>>>>
>>>>>> Good catch!
>>>>>>
>>>>>>> The problem is that when application exits, rss counter is 
>>>>>>> calculated
>>>>>>> with huge_zero_pmd huge page, instead it should be skipped.
>>>>>>
>>>>>> Looks like the same problem[1] we discussed recently.
>>>>>>
>>>>>> [1] https://lore.kernel.org/linux-mm/74a75b59-2e13-3985-ee99- 
>>>>>> d5521f39df2a@google.com/
>>>>>>
>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>>>> ---
>>>>>>> mm/huge_memory.c | 3 +++
>>>>>>> 1 file changed, 3 insertions(+)
>>>>>>>
>>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>>>> index 970e077019b7..3cbea344d4a2 100644
>>>>>>> --- a/mm/huge_memory.c
>>>>>>> +++ b/mm/huge_memory.c
>>>>>>> @@ -2423,6 +2423,9 @@ static void zap_huge_pmd_folio(struct 
>>>>>>> mm_struct *mm, struct vm_area_struct *vma,
>>>>>>> {
>>>>>>>     const bool is_device_private = folio_is_device_private(folio);
>>>>>>>
>>>>>>> +    if (is_huge_zero_pmd(pmdval))
>>>>>>> +        return;
>>>>>>> +
>>>>>>
>>>>>> The huge zero PMD should not be returned by vm_normal_page_pmd() or
>>>>>> vm_normal_folio_pmd() as a normal folio. If it reaches
>>>>>> zap_huge_pmd_folio(), we already made the wrong normal-vs-special
>>>>>> decision ...
>>>>>>
>>>>>> So I don't think we should special-case it in 
>>>>>> zap_huge_pmd_folio(). That
>>>>>> only avoids this RSS decrement :)
>>>>>>
>>>>>> Could you please check whether the fix[2] also fixes your QEMU test?
>>>>>>
>>>>>> [2] https://lore.kernel.org/linux-mm/ea1453a6-14c9-4334- 
>>>>>> ac7e-2758586393b2@kernel.org/
>>>>> yes, I think it will solve this problem.
>>>>>
>>>>> Only that I think that there should be tlb flush operation after
>>>>> pmdp_huge_get_and_clear_full() even with huge_zero_pmd page, so
>>>>> tlb_remove_page_size() should be called. Is that right?
>>>>
>>>> Calling tlb_remove_page_size() is not necessary there :)
>>>>
>>>> zap_huge_pmd() already marks the PMD range for TLB invalidation right
>>>> after clearing the entry:
>>>>
>>>>     orig_pmd = pmdp_huge_get_and_clear_full(...);
>>>>     tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
>>> Yes, it is. I forget the tlb_flush_pmd_range() calling in 
>>> tlb_remove_pmd_tlb_entry().
>>>
>>> So the fix solves this problem. And thanks for your explanation.
>>
>> If possible, can you test the fix[1] with your QEMU workload and
>> provide a Tested-by? That would be very helpful :D
> yes, this patch solves the problem. I do not subscribe linux- 
> mm@kvack.org mailing list, please feel free to add
> 
> Tested-by: Bibo Mao <maobibo@loongson.cn>

Thanks for testing!

