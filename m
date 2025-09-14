Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 981EECAC58F
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 08:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5D768E0005; Sun, 14 Sep 2025 04:20:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0EFF8E0001; Sun, 14 Sep 2025 04:20:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D24B98E0005; Sun, 14 Sep 2025 04:20:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA37F8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 04:20:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8B361A02BB
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:03:46 +0000 (UTC)
X-FDA: 83886965652.14.AB7F1E9
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id B0272C000D
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:03:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tqa9yjtO;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757833425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1SBr7YTYHDvS3STNvioAQqSYjCCaY8tahzoq1n3/n0Q=;
	b=XWvCbFHD16UzkgKK7lSV+5FQXGF9dQ4Xvd5PNMJlzalzLhy8qah+RBoPFAvVOijYp/4pwN
	e5i//OI9cvt9k5SgOr7PXrRa743EARMeUxp9ieBa3WsBCPLsblZVyxgQddjyIsA7epJ9Me
	ct9KZ0r0nwYCeNllp7VhJbePpfD7NUw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757833425; a=rsa-sha256;
	cv=none;
	b=e4TiJEOh6SsYClVvMAVzV4pHqUGcWZXwhtX+4QOS4EKSbqqqQb0VHIPyFuyv/OtDE2Yh/H
	34hXiSG5ewKCcm+vqHAYmJ498PC8sfpZTTxN793000FYjY7S0sFtWUZmtQoAx9FXyF6a9z
	+icllujaOp4kL0VVTsqfwqS6XIyHb+Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tqa9yjtO;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757833422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1SBr7YTYHDvS3STNvioAQqSYjCCaY8tahzoq1n3/n0Q=;
	b=tqa9yjtOsatRIhbP8nB/MAj6tBzhYbcOf2/rGtw62bmQhqbhU/9QBIKsZPO6njSvtX/caE
	D32294AGw73O6YTfU/EInJ6LgMp105ggkB7oBs//eCL3283sA3IyKOIcueedZPl515tLMS
	7R+cGZoHCFgMNXDY+Q72P/pU5WAswC8=
Date: Sun, 14 Sep 2025 15:03:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
 akpm@linux-foundation.org, chengming.zhou@linux.dev, npache@redhat.com,
 ryan.roberts@arm.com, xu.xin16@zte.com.cn, baohua@kernel.org,
 Liam.Howlett@oracle.com, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: uijkzu7qu4xt4o1ofkyanozqxexkazjg
X-Rspam-User: 
X-Rspamd-Queue-Id: B0272C000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1757833424-85434
X-HE-Meta: U2FsdGVkX1+DJsAD6Cx/xZJCzJqBgoY5+UYuOc0xy6YScJZ0oLEeg7VYmmXFR7NPcaxNeXHSfjCelW0QXZplOn5OeeZWbuuHSny5WizxcTZDa4kjz+ouo9jEZYhYcM+mWrcdLRrCZ5BdOGyFeYkR4Do8LSTa6bKOTY7sKQcWyB4SKU9TNDllV4fXKAiMh/2SYUjYoVQ4DBclMwreTApPCDVNs7zmhl8H8W1AAkwkmmCIAXgq/GudwoYWzlZRsiQubqQYCUa8NP83Ed54p+ac9k3J0TjjcYyVzcQVLNZ79hFmV0PkZXF4OJmwXEcliIw9AmyFeyzoRevLlP/e116DkAk2JXxB6JjGbFONzito1AhRbWdwsANbxoLrIguObgZZSyglvjajDAuJaFgjg2umPhdKK8csVeS8QwBh3MMKTim3qxdffYa4B8imtxyCf+pvF8nEhuCvb85WUnx+kQPOJOYp8xkY91jGQCIi2g4Mt73sbcpM2CAYfOKV9g6NNWE032Yb9MN10Vk1jXR5FWwE3YNO8H6A7F7SFZi45XZrmtX+RYOp+xLlFzVPx2DCOZySJhy7SR2QA/pNRK7iuUEFSk46gspHieBSiwC6jBIU/elPAQLlI+iznMPLEXgzSFyoT4xBElGaRQr3Ht9YTjiXBe6Hk0tdka4A8dsAlcoxnjsFFhc2hapjll9E8rbjP9cg3A2lrr+qu6VL9q4lmkOSG0IrjRPJNyohLUkKA2hC3FfQtIB5w5k3qsrjRFzeOGkkoNmyNTh0oVYwf3jQMiNISmBoTv/TzKW95NY+SnopYqIcA3mXlecvKYAtZ1BBHqNa57Z2uj1Y5LffKiFkUvB/8Y13llArkq2p35rPIIlFGCVtq4ApMlzVkSpKd1rDRcwPyzucyYJ3758yqFPGfSm9n/7LmOAGvwYprYeGhAhfYr3rAc62QWE9DF/IfkCcXKjjshxjAXwe2+I2QK4KZkt
 BAR0ULJs
 vtM+S8dd33gUhqMfLKXWX3cLXSMpj8yzvV6HF/zfxSe3l0OSjbxlTG2ZpZWZF645nIf58TWnN3nLke5NEdeBqAQ1ziMloC0wz+uQjY0v84S/Xc/blfseNjqWHdWlU/3n8gsrV5UahkBBLMONxb7+AjKaWCI1OwkNUMxoWxxpj/Y8Y/Cd+3lqjJOpJL3UIBsbuU0C/yb5KAC3Ms6e92JF04kXdWfZ1ttJsCiNlR14R6AI7ZUeqtG7OzohI66gsZLYJQystd1IwRwSh4pVIUR5FK1xGNLGp8Lt3e96DMEEywwbln+vVbuz/q0yvLjM68j3KQ9NI/ANcTyU6dbELl7qXaMHexcdC63qYN9Esq/v1D1lUe1lsu/xl+EAu9lHnmKLGRTy5hLXj4F4zJqKfZLEITOmuNuFFPLW70zYDLHSWblry+iURzD74pA4m3X11EjqDw4WM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/14 14:21, Dev Jain wrote:
> 
> On 14/09/25 5:30 am, Wei Yang wrote:
>> When using mm_slot in ksm/khugepaged, there is code snip like:
>>
>>       slot = mm_slot_lookup(mm_slots_hash, mm);
>>       mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>       if (mm_slot && ..) {
>>       }
>>
>> This is only valid when mm_slot is the first element of its wrapper
>> structure, otherwise a NULL slot would converted to a mm_slot with
>> negative value. And current code thinks it is valid and continue.
> 
> Shouldn't you fix the code for the case when you can't find the slot
> in the hashtable, i.e slot == NULL? Like, if (!slot) return.

Right. For khugepaged specifically, the slot == NULL case in
__khugepaged_exit() (only user of mm_slot_lookup) should probably
be treated as a kernel BUG for new.

But I'm not sure if the same logic applies to KSM ;)

> What you are currently doing is just ensuring that if slot == NULL, then
> we get a legal value of mm_slot, and since the code then operates on
> the basis of mm_slot, everything will work fine. I really think this
> is a workaround to the real issue that you got slot == NULL :)

Anyway, an actual fix like "if (!slot) return" for khugepaged would
be better than this workaround, as Dev mentioned.

Cheers,
Lance

> 
>>
>> Current code works since mm_slot is the first element, but make sure it
>> won't be disturbed.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> ---
>>   mm/khugepaged.c | 5 ++++-
>>   mm/ksm.c        | 5 ++++-
>>   2 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index af5f5c80fe4e..668e74ad33b7 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -108,7 +108,7 @@ struct collapse_control {
>>    * @slot: hash lookup from mm to mm_slot
>>    */
>>   struct khugepaged_mm_slot {
>> -     struct mm_slot slot;
>> +     struct mm_slot slot;    /* keep it the first element */
>>   };
>>
>>   /**
>> @@ -2382,6 +2382,9 @@ static unsigned int 
>> khugepaged_scan_mm_slot(unsigned int pages, int *result,
>>       struct vm_area_struct *vma;
>>       int progress = 0;
>>
>> +     BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct khugepaged_mm_slot, 
>> slot),
>> +                     "slot should be the first element");
>> +
>>       VM_BUG_ON(!pages);
>>       lockdep_assert_held(&khugepaged_mm_lock);
>>       *result = SCAN_FAIL;
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 2ef29802a49b..0d486dbdf7d3 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -124,7 +124,7 @@ typedef u8 rmap_age_t;
>>    * @rmap_list: head for this mm_slot's singly-linked list of rmap_items
>>    */
>>   struct ksm_mm_slot {
>> -     struct mm_slot slot;
>> +     struct mm_slot slot;    /* keep it the first element */
>>       struct ksm_rmap_item *rmap_list;
>>   };
>>
>> @@ -3842,6 +3842,9 @@ static int __init ksm_init(void)
>>       struct task_struct *ksm_thread;
>>       int err;
>>
>> +     BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct ksm_mm_slot, slot),
>> +                     "slot should be the first element");
>> +
>>       /* The correct value depends on page size and endianness */
>>       zero_checksum = calc_checksum(ZERO_PAGE(0));
>>       /* Default to false for backwards compatibility */
> IMPORTANT NOTICE: The contents of this email and any attachments are 
> confidential and may also be privileged. If you are not the intended 
> recipient, please notify the sender immediately and do not disclose the 
> contents to any other person, use it for any purpose, or store or copy 
> the information in any medium. Thank you.


