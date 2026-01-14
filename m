Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10EF2D39014
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 20:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BEA06B0005; Wed, 14 Jan 2026 15:14:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 241CF6B0089; Wed, 14 Jan 2026 15:14:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119F76B008A; Wed, 14 Jan 2026 15:14:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F41956B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:14:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1884140600
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:14:18 +0000 (UTC)
X-FDA: 84331671396.28.C9A1310
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id DDA6140009
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:14:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PXIK6kEv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768421656; a=rsa-sha256;
	cv=none;
	b=Ah+Wx4NoHzyKlT4r2EUNfbRPF8y6Mq0lr27g/n7kHNvEwlWqrbJFdtWeGiFhtzJYZkbW6p
	hXBNyvlMra+QgO/8Ma6hF35eJg3aiZ+OsP25aMSV1fC7/FJ5NVos5421hHRruBCJWXaaZk
	Vufskh6ofQjRMtjQ6wCJkc7ml/TD0wg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PXIK6kEv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768421656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kzVDHJhjPlTChu5I1kJ+EMdWTAY0qPSxa/SxIORTNe8=;
	b=p8R2jTcZZ3eAoHdZgqKmKtEaCHVZ5yGQadb9iTsp5Rw/jqvGlWE04vWfl64hJbRgnloZFr
	cfAH5sisusxIUfwbU4Y+VaKjXNM0wac/LzHAFeg95jiluxfMU59EDzIlYatHvU7xHtQZUy
	+5PDPwcaUdSgyGADi+U3a1RLZLPuVAY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0918960051;
	Wed, 14 Jan 2026 20:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5610CC4CEF7;
	Wed, 14 Jan 2026 20:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768421655;
	bh=ln4PO0exRBfvEWi16/ut6iLsNheqOyuMABH4qKzzpYw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PXIK6kEvsZ23eqAxs3owI5uGeoC7MTSnqlL5xkVO4usRMOdEZdWFedia1iUOyo19R
	 uoZwi4skY9hQvPOwj1AwVz19JM1eAxUlWUKbKBTWoNQweZFseAvzP26ARB7scjXgsr
	 G3n4WW9zvnC0jSkfnNRI25sSPJ6J0taDOJ7iu4Kkx9zI5AM4ObLC/t+4S94Gm/+3ZH
	 ryEz7Tl8/NPYikFnadjg6Fanrt7LVEjM+BDsXkW00BGLcpGIFEdaO7w+TMtnxX1eOd
	 wgqx5cltZN21CPrkk2rgv1FVzx30KGO74TvwQj9X/101XtsLTw3V8djgIvSZV4prJe
	 zq4bDJmlYxtZw==
Message-ID: <976561d0-0edb-4f09-8ed1-ab8f85c9aa87@kernel.org>
Date: Wed, 14 Jan 2026 21:14:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/2] mm/khugepaged: retry with sync writeback for
 MADV_COLLAPSE
To: "Garg, Shivank" <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
References: <20251215084615.5283-3-shivankg@amd.com>
 <20251215084615.5283-7-shivankg@amd.com>
 <3cc27720-8f53-4b6f-9202-42b3b73928b8@kernel.org>
 <dbbfc5f1-d9e5-4d39-a2df-e35d6ba73063@amd.com>
 <d6287c39-59a7-4592-8afe-bdbdbcd70b04@kernel.org>
 <7a42515f-ae57-4f4d-831c-87689930a797@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <7a42515f-ae57-4f4d-831c-87689930a797@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DDA6140009
X-Stat-Signature: ejpzcxpxxxg4deqp9js83zugx8ek8qxo
X-Rspam-User: 
X-HE-Tag: 1768421656-240162
X-HE-Meta: U2FsdGVkX19bz4Op7R7RP5wkA6qK5dN8GJOAHF9hlOd0mIWNGw7XO8qSMmj5vKyBl11ywTbnwEaJuqj3jaB7FpZsZCm4yRFs6jPU6F+1IypEzFc/cJI9idphym4JAj+MvWyEzG6B7GSkpoCGzXFfj8PMRBE9TJCSnQchB450MefOmEUfB/4WkR9BREfIOoFT0u6HBpBJZlhUZ4ypHG+XHl5p4mdtfbsBHk2+Qi0j6sn922hmj/Xd6n6Z04GS5m49mQzu0pHh8nAq+kQ/JpfrnLJy5HSuxCksVlkv5PPGETZglh+vpcGdM7p6nyKXXlLBd4MGVeEileE4mI7p9I2Wkocq7wovC2ajjV3MHm5cacuYCE7BRA5xAhv8OI7A6xWNyg0eP21/BoBRG/KEvYbg+jGpHPSRF4DQB/4wWKnBxBPQHJvZ4fmz6uyIUyo5mU4X1pFFjtYwgZSXeX6HQeVJhgGLt2XeAAJomrXLUDL33xES4JCS6dvaZBQfTt6kIZ/x9FElea39qds+TWv3MR32zHIQ7ug7nTccVnRd9ANmMUwUAy/rQskYA9WOqccQtSQhiT3Cp+ZqTqWA3V11/Q+fhCtXdYx137O+XCOlM4D7ghRvSOblHvhkKbV2erMbW3xes6nWwpoJDNDlRgd9XL8Z03r8XLhK3PWKfUgbVEDOL8/oIe0x7R6Ju8UXKUgzZocGaEXFvlgPVq17MvJQG6FIqaoe22StJxcqc4LDp2QJnSKbcIligNj53+BqHXLbGuudRgu1paO274ADM6UP/BzduhTrgdB9nly8sUB34WdFaGeOeSVWqLdIU2CXHhAfKgB7vZqUwSGPySffZs7AkG0pxItITzBTPX+goKf3bmEoFvq2KvorW05vPDzMYsW3fLBh2RXr9FcUZLbXS/mXOrzMv0fEGG7ZXbW52RP73qWnYFyAlb8AGm3X++JWmwFfmOs52jgoAQcj9E3BTCiNtWM
 NVrEsjoV
 GBq1Ive85V5Z0AXoHtcGcmjg1uAlPbhgS35hMcz1I+B32iVeA5/J1+7p8HJkB7w2+DWFHFLTU8F6D9nu+NRAr3qt70PL+u3iM3GRxhKhdbg9vhZYMu9oECSUa54rSXjD66QbE2lsNwIZrfJMCoKCUmkPFgniFx81HFxwINO+SEiYUlDCSBLYGClYzMYA/mw13d9s09EPHTebml+Rc5HoRjosrg8IEtukXs7dtVmkDfUIA5V2k7YuJEDftMuUPkDcsCJ2Y+PpdmocuubfA8fgVH4D3DQK+cQx7egMMB8985x3dbRfwfPeF8N2ovIiXFryKZocyJ5a28MQzFSw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 20:47, Garg, Shivank wrote:
> 
> 
> On 1/11/2026 4:59 PM, David Hildenbrand (Red Hat) wrote:
>> On 1/10/26 19:20, Garg, Shivank wrote:
>>>
>>>
>>> On 1/9/2026 8:16 PM, David Hildenbrand (Red Hat) wrote:
>>>> On 12/15/25 09:46, Shivank Garg wrote:
> 
>>>>
>>>> This looks a bit complicated. Can't we move that handing up, where we have most of that
>>>> information already? Or am I missing something important?
>>>>
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index 97d1b2824386f..c7271877c5220 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -22,6 +22,7 @@
>>>>    #include <linux/dax.h>
>>>>    #include <linux/ksm.h>
>>>>    #include <linux/pgalloc.h>
>>>> +#include <linux/backing-dev.h>
>>>>      #include <asm/tlb.h>
>>>>    #include "internal.h"
>>>> @@ -2786,7 +2787,9 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>>             for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>>>                   int result = SCAN_FAIL;
>>>> +               bool triggered_wb = false;
>>>>    +retry:
>>>>                   if (!mmap_locked) {
>>>>                           cond_resched();
>>>>                           mmap_read_lock(mm);
>>>> @@ -2809,6 +2812,16 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>>                           mmap_locked = false;
>>>             
>>>                *lock_dropped = true;
>>>>                           result = hpage_collapse_scan_file(mm, addr, file, pgoff,
>>>>                                                             cc);
>>>> +
>>>> +                       if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>>>> +                           mapping_can_writeback(file->f_mapping)) {
>>>> +                               loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>>>> +                               loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>>>> +
>>>> +                               filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>>>> +                               triggered_wb = true;
>>>
>>>                    fput(file);
>>>
>>>> +                               goto retry;
>>>> +                       }
>>>>                           fput(file);
>>>>                   } else {
>>>>                           result = hpage_collapse_scan_pmd(mm, vma, addr,
>>>>
>>>>
>>>
>>> Thank you for the suggestion, this approach looks much simpler.
>>>
>>> There are two small nits I observed:
>>
>> Yeah, was a quick untested hack to see if this can be simplified :)
>>
>>>
>>> 1. In the retry loop, it is possible that we reacquire the mmap_lock and set
>>>      mmap_locked to true. This can cause issues later when we do:
>>>
>>>          if (!mmap_locked)
>>>                  *lock_dropped = true;
>>
>> That whole logic of having two variables that express whether locks have been taken/dropped is just absolutely confusing. Any way we can clean that up?
>>
>>>
>>>      because the caller would no longer see that the lock was dropped earlier.
>>>
>>> 2. We need an fput() to balance the file reference taken at line 2795.
>>
>> Ah, yes, makes sense. Having a single fput() would be nicer, but that would require yet another temporary variable.
>>
> 
> I agree, that this interaction for lock taken/droped is confusing.
> However, a proper clean-up would require refactoring the locking logic across multiple functions in the collapse call-flow path.
> This seems significantly more invasive and risky.
> 
> I would like to handle this refactoring but in a separate TODO for later.
> Could we please proceed with these minimal changes for now?

Sure, fine with me.

> 
> Since, V4 has been in the linux-next/mm-unstable for a while, should I send a v5 or an incremental clean-up on top for this?

Just send a v4, unless Andrew tells you otherwise :)

-- 
Cheers

David

