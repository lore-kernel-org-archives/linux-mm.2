Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23F04CD37B7
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 05:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B6466B0088; Mon, 11 May 2026 01:40:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167796B008A; Mon, 11 May 2026 01:40:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056A66B008C; Mon, 11 May 2026 01:40:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC5316B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 01:40:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69EEBC21D3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:40:54 +0000 (UTC)
X-FDA: 84754040028.15.46C8CFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A87CF40002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:40:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kn6Va6ga;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778478052; a=rsa-sha256;
	cv=none;
	b=TKPB/UJL5J8JaBvcf09uklGKIbxlIk7PxfaHuphjvnlh6dd2U2/0YYH/WUZDEMj0g1Es2r
	/MmkxauRqp/S2PYbUErWz2liZfMhAxEZnDTyverK19qMocWxKiq4vygF1kPxgLGWRCUX6K
	cTMv69V+7WM4PPjVHK0jy9Y+BprMUg4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kn6Va6ga;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778478052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPqo7fjMDOGxG93gfofFl3tvjyE+6Z+8mWJ34IIcXd4=;
	b=PXoeBs6G6iKebcd0g0IIYJ/DA3KY7JDXoBZ5Hqd88yS/fLh3lTQbTkWGZ+PHtIqH9Em+sS
	K9yFJ+FgWCOwjyjjv1wTtLjjsBe5+Vwe/CbNetQ0ocOV+no/vRqH/lLl9fiARQSxS1gN7T
	10HLDQTzaktRQQLRmP2yCY/PMIqTg2Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EBA726001A;
	Mon, 11 May 2026 05:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D68BC2BCB0;
	Mon, 11 May 2026 05:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778478051;
	bh=JIyxTvGVC3zuQ2OR4m1RLr1N+pOyNiKOk9VaIsgzW3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Kn6Va6gaec/W9fP6O8mMug/XPZaH5PS9TrGRZcK3cd2xMyB+VSvEUQkJoExtgw9Dy
	 SDgrzurscpRByuAHL/+6eMBSNK6priS2OThUPdXD1aUYNCTYu6qaHDwpf3i2iVb3NP
	 6PD4M0YlfyFMRqmujtVvnaXwKBDAjRktgVmTKAV26DrSv96KLaEu+qqxQYfYUwWLyt
	 EmP45h9zrH3r3YupD0MOdvpQGIi6wXKJHYin3eFQVWNOwrQglMHqluruNqK7Boxy/g
	 GtsQaSi5mIDf01MAE5WnV5iboaVjGQxn2HbCq/0qyGw7A5S5FkfGj6D07YwMv7kVXT
	 1A8LksMFlApRA==
Message-ID: <5db3ccc6-7184-4068-918f-72dbfc31a781@kernel.org>
Date: Mon, 11 May 2026 07:40:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: clear MMF_VM_HUGEPAGE on
 mm_slot_alloc() failure
To: Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>
Cc: ye.liu@linux.dev, akpm@linux-foundation.org, ljs@kernel.org,
 xhao@linux.alibaba.com, liuye@kylinos.cn, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, akpm@linux-foudation.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <3fb8c00d-d60d-4fec-81b1-e7633384a52d@arm.com>
 <20260506105150.21504-1-lance.yang@linux.dev>
 <6b6b094b-8dcb-423b-bb86-ef1439887eed@kernel.org>
 <41676526-ff0f-4172-8871-0a825ab524d0@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <41676526-ff0f-4172-8871-0a825ab524d0@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sfw8ammm3bj83q7ub8nacre63pz788yw
X-Rspam-User: 
X-Rspamd-Queue-Id: A87CF40002
X-Rspamd-Server: rspam07
X-HE-Tag: 1778478052-985723
X-HE-Meta: U2FsdGVkX19HoLvZ4GIQ5botHXvOCKdMI6O0P2tzXj92erLBOCQTLgO3JK1hpGmxb8jpcXSNrFKGuDAnaDvpDaBUzdHtazQuyVool9CKKVLo3yC8wDTzl0hLMuCCXU9Ga/QI7VtIjIWhjQoxJIBVpElVjF2428SOu+UWlV+MwOTg+BHUcHNVkLgZKS0DjKdyKINhD1DFn//CYPsLRR38NnxbrFo+KmwCLgadx/PvJux6R6LftuekWLwNL12p+SCl1bqODtA547XAx9VQXpzYluVLPf+vCQQWSvYtXdB5aKM5RX7vkY6hSh383RiP4gWJewi89i1/+jeVSJvX3WjincQlYy5U+yT0eIjP6FmKi5uFXOLsaINNbSO7I+P5AHRR8WtMubwJEWIdQs72SKHcMOl/o0Tyr4+eSPkO4qenMv0WjG3jso7Pq7t8rJaqaQrnqHQJQdQXsvKFIqPZL1eXu82OCO+UHaGHlzkmb4ojSPKGGZLNUO07APnUDA2oVw9b1zf1tqAOGh/Rr8hTUNhSI9MjTVuBVYmXv1x7oWTJZ/LRAy1nLpqVt0WwGX/MzABA3/zYGMmNerhMNcGZIU9D1wL7VoRn/047ItnJ+0Gc6JWGiNX+5adIO21KrYdn7uhbrHmZjtgyak+THXeEbyw0uZptmVDWneMBt28P3Q6/ZZKRYndbySuQXQhdG5lQ3ApCCqq/yKfojaA9eIHhAhP89Q1mT/ccdNQyIIg9sExj6Omf/Q9K5PAkCGIGPTYETku3VEsQB9I/repDi8k47vXtvIqS3xYzHlM5PlHymwZ/o72UV6DumicXm13wyWhyWq5M5Z5cFRJhjeZxYwJBHhafYVX54j22KWcrCEb/DujWaPLXObTDWDEeUEeOf6Kmnz0BFzOvcGTIj7fhgcwIPOqTDeOPriRXDf9gC03g5vXn/Kfb6phOueP/KjBG8VRSvTObDYwmhi5FcWAP+fuI7WB
 pQVlYWWp
 xvT0PSO0TCjKWPBW1rAyd/x1UA8vXzvWUUZO8mpuV088k9gthEjt5EYR4XpIgyzvszf+7+lNBhFuBCTtZJF/fvuOY/csFHMtLYydN1MEc/kep8D+nSVUWr54r7JoefKskOr5RyNYzv+euv9GqeKwNGldJNIvTow0rYF4j4KXN3nXyMchrc1GkhRRQMbmj5Y8rA2qzf8n3dOtQxY7vpnNStjhJCzBretwP5QE5Z2tE1vMmfEGvGBYi1l7MOre3KTDNWn06cgRAjjSvTmRxFOWAHk7Ig40xexliED8q5fNZIoOv5gjHkHTvLrc/eKN0UNPEnS3xhUsn2kmdKTJko16ZF09OmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 06:00, Dev Jain wrote:
> 
> 
> On 09/05/26 3:11 am, David Hildenbrand (Arm) wrote:
>> On 5/6/26 12:51, Lance Yang wrote:
>>>
>>>
>>> Right. A racing khugepaged_enter_vma() can see MMF_VM_HUGEPAGE is set
>>> and return, then !slot clears it again. If there is no later
>>> khugepaged_enter_vma(), the mm still wouldn't get registered :)
>>
>> So why not
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 5f4e009593e0..78735f34250a 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -437,13 +437,16 @@ void __khugepaged_enter(struct mm_struct *mm)
>>
>>         /* __khugepaged_exit() must not run from under us */
>>         VM_BUG_ON_MM(collapse_test_exit(mm), mm);
>> -       if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
>> -               return;
>>
>>         slot = mm_slot_alloc(mm_slot_cache);
>>         if (!slot)
>>                 return;
>>
>> +       if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
>> +               mm_slot_free(mm_slot_cache, slot);
>> +               return;
>> +       }
>> +
>>         spin_lock(&khugepaged_mm_lock);
>>         mm_slot_insert(mm_slots_hash, mm, slot);
>>         /*
>>
>>
>> Arguably, on the race described above, likely the thread seeing the
>> MMF_VM_HUGEPAGE would likely similarly have failed the allocation.
>>
>> I'm fine with either, just wanted to raise the (cleaner looking?) alternative
>> where we just properly back off?
> 
> Yes this is also fine - I am overthinking but I wasn't going this way because ...
> A process doing THP allocations will fail on the mm_flags_test_and_set everytime
> after the first time.
We should perform a mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) test before
calling the function when the flag might not be set yet: in khugepaged_enter_vma()

khugepaged_fork() should only get called once per process.

Which makes sense, because mm_flags_test_and_set() is expensive.

-- 
Cheers,

David

