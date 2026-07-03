Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0809AC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 08:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3AFD6B00B4; Fri,  3 Jul 2026 04:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEB3E6B00B5; Fri,  3 Jul 2026 04:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00C06B00B6; Fri,  3 Jul 2026 04:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BAA86B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF574C2084
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:14:36 +0000 (UTC)
X-FDA: 84946753752.05.F0F04B0
Received: from mail-m2458.xmail.ntesmail.com (mail-m2458.xmail.ntesmail.com [45.195.24.58])
	by imf29.hostedemail.com (Postfix) with ESMTP id E41F2120005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:14:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf29.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.58 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783066475;
	b=jAvEK+vtX/1MKMk8HkMXhRMRNyWpJo6PepFCkcOwNLlkbXqcZAsr2BgRdiCH+P7JT3bipz
	mx8A4UqsYrdcbr/JBiK1ctu2VNDszXanFuBLn2+o7N1rQz6IUwy8FpPRokRqyK/5uZUTgd
	fBQlFR938Xpx4Pr95HWAMClMT5fa+DQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783066475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rNkZfdfDIc0PgxB6uJxGbDb3X3OA7/Ay1HM7gjlnt5s=;
	b=ILvdXc9+YpF9uyJdhSEAUpxNttXcuqBdNtNKqY4C4WTC0gdkPDU981nYdsK9AkqWrTaFFd
	4BdvGEu8rJYWJJ31QxeGaStKDPxcHZ07eAVBEJMrSvoejs2PgdzKkOughlp2RgVsukL6oE
	/5N7EXZmgruVBuKfDJ95lKPAq7hMA9k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf29.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.58 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1c3e01f79;
	Fri, 3 Jul 2026 16:14:28 +0800 (GMT+08:00)
Message-ID: <f7bd2660-374c-4b2f-a274-8fd46368abea@easystack.cn>
Date: Fri, 3 Jul 2026 16:14:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 1/4] mm/page_owner: add print_mode filter
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Ye Liu <ye.liu@linux.dev>,
 akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
 <20260625043101.338794-2-zhen.ni@easystack.cn>
 <d86d309d-9f5a-4d63-afb0-dc4016fe1ded@linux.dev>
 <49526116-ce35-4447-bd98-f5f0ca12d92a@kernel.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <49526116-ce35-4447-bd98-f5f0ca12d92a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f270b1ea70229kunm2f44f0d5d2cdc
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGBlDVhodThhNTkoaQx4fTlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: sg68zrcoig4hhdmnm6sds89uiwrots8t
X-Rspamd-Queue-Id: E41F2120005
X-HE-Tag: 1783066473-440448
X-HE-Meta: U2FsdGVkX1+4+zR0qcj926KUcnRHi8gbHOHm1YcMv2cdsbWd0skkMpFDIwug8XXdwkkUW88ZGu5xmqXU5jGjQOw5/4iTYgloETEsNsYG/d93rEZwco6mDBOaQTJcaVh0VT01QHkj/JWzU/gnnMh1rYd7bxl2lGOt6vOQmBF5YI4rjqh32cmj8M26flQvjwwkXT7l63cObUMGL2FbZBYEa1T1yUjdiyrCojEt4xotvvYBgxOD2vCx9XQhsONxwYidwCqGTMaFBFrS1ljXcksh1qTsBGdSRC2kF80iZgWmhXFNwFtVFGNEzbSS5/jOGB0VtLNYj9Nyu3ZSm4MAzxTcmdSSINr6z66hLpTUtHSNgtUbdHs2002Sq7mChXKLa/RUXpvaW7ZIQlla43Xg+txzzkeC/nKLWK87MFPQ0PhGPLCossQ7FmHfDCmX49qet52kWJjZPVQBNRff1JfOOMvqXCDzz5wICBEXhOFeq/D+nRASVmlcIl+XLSu5tui34rXGULELiPRX9H9SZmOE3CS/kwK/JRsKRgcccEnB+I08MWQkY+2GKGvCyhsHyZErcmw18k+X/EH10P9FCy2xmE5/RSFjkRBCFENwRJo+ttc9QNA8v4xMF20u2Mi71HvSZUbRguvjetedcW5lCBR7t2Vg8qgeWBZPFHVoGTgoi/ivcFwRKz1ngwyWqZL/fHagvIEbYKNGpxgze5+/0WU6Nui3xdY9CPSiC1aLg8+sPtJ8s5y5A7NqfLAEQDhE4IiNjw66h5lMIptMFtZbO27dbUOWBGQs/sOBYCDUUpOhkVWZJAHZH0QHB4hE8JaEjULLJTGqkwrORvTKA24UWd6OoCCoGuQHIvo157ipWNmqzY1V19wUF5WiL3GOhEK6Bfylw58uyRzQx4WYCo6DI8RZha+vnLDzAv+0uGGHl79kKejsv9zWcMRHStoSxgChs3mEKLNJCzsB5M3orTj0ITw/PAy
 QlZCkssR
 fTcMzOv1kSqqn6tmKZw67Zt4v27QRa4iQ+hs+npPc60dbzzaNCxyCAIqmwWH6hv6P+6J0cJcyQZMEy4gGGVM01/vptNBFiFi6YY1JBOPM0BxSGQC3JFKs7NpY8fPcPO7IYYDYiE3Trfc1U+EErxQH6/ptXVHvZ/sCleMd7NOBhV9w6q17Y63YcpSju/Cj3O139NRNQyvAoqFkPnY8dSJQ5CCQofddH8GZkOTsP8lDw4hmgvmVOIBARM9HuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/29 17:30, Vlastimil Babka (SUSE) 写道:
> On 6/29/26 04:59, Ye Liu wrote:
>>
>> 在 2026/6/25 12:30, Zhen Ni 写道:
>>> Add a print_mode filter to page_owner that allows users to choose between
>>> printing stack traces, stack handles, or both, providing flexibility for
>>> different debugging and analysis scenarios.
>>>
>>> The filter provides three modes via page_owner:
>>> - Writing "mode=stack" prints stack traces for each page (default)
>>> - Writing "mode=handle" prints only the handle number
>>> - Writing "mode=stack_handle" prints both stack traces and handles
>>>
>>> The default stack mode maintains backward compatibility with existing
>>> usage, displaying complete stack traces for each page allocation.
>>>
>>> The handle mode dramatically reduces log size and improves performance by
>>> showing only the handle number instead of the full stack trace. Testing
>>> shows handle mode reduces output size by ~66% (84MB vs 244MB) and
>>> improves read performance by ~4.4x compared to full stack output. The
>>> mapping from handles to actual stack traces can be obtained via the
>>> show_stacks_handles interface.
>>>
>>> The stack_handle mode prints both stack traces and handles, making it
>>> easier to identify pages with the same allocation pattern by comparing
>>> handle numbers instead of comparing large stack traces.
>>>
>>> Example usage:
>>>    # Using the page_owner_filter tool (recommended)
>>>    ./page_owner_filter -m stack          # Print only stack traces (default)
>>>    ./page_owner_filter -m handle         # Print only handles
>>>    ./page_owner_filter -m stack_handle   # Print both stack and handles
>>>
>>> Sample output (handle mode):
>>>    Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
>>>    pid 1, tgid 1 (systemd), ts 123456789 ns
>>>    PFN 0x1000 type Unmovable Block 1 type Unmovable
>>>    Flags 0x3fffe800000084(referenced|lru|active|private|node=0|zone=1)
>>>    handle: 17432583
>>>    ...
>>>
>>> This implementation uses per-file-descriptor filter state stored in
>>> file->private_data, allowing each opener to have independent filter
>>> configuration.
>>>
>>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>>> ---
>>> Changes in v11:
>>> - No changes
>>>
>>> Changes in v10:
>>> - No changes
>>>
>>> Changes in v9:
>>> - Add spinlock_t lock to struct page_owner_filter_state for concurrent access protection
>>>
>>> Changes in v8:
>>> - Fix buffer overflow by adding bounds check between stack_depot_snprint() and scnprintf()
>>> - Fix unsafe string handling: use memdup_user_nul() instead of kmalloc_objs + strncpy_from_user()
>>> - Fix strsep() memory corruption by saving original pointer before strsep() call
>>> - Change format specifier from %d to %u for depot_stack_handle_t
>>>
>>> Changes in v7:
>>> - per-file-descriptor implementation
>>>
>>> Changes in v6:
>>> - Remove unnecessary braces in if/else statement (coding style)
>>> - Use stack array (char kbuf[33]) instead of kmalloc for input buffer
>>>
>>> Changes in v5:
>>> - No code changes
>>>
>>> Changes in v4:
>>> - Change from numeric (0/1) to string-based interface ("full_stack"/"stack_handle")
>>> - Merge infrastructure patch into this patch
>>>
>>> Changes in v3:
>>> - No code changes
>>>
>>> Changes in v2:
>>> - Renamed from 'compact mode' to 'print_mode' for better clarity
>>> - Use enum values (0=full_stack, 1=stack_handle) instead of boolean
>>> - Update debugfs filename from 'compact' to 'print_mode'
>>>
>>> v10: https://lore.kernel.org/linux-mm/20260618035750.3724613-2-zhen.ni@easystack.cn/
>>> v9: https://lore.kernel.org/linux-mm/20260525081652.2210206-2-zhen.ni@easystack.cn/
>>> v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-2-zhen.ni@easystack.cn/
>>> v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-2-zhen.ni@easystack.cn/
>>> v6: https://lore.kernel.org/linux-mm/20260511033017.747781-2-zhen.ni@easystack.cn/
>>> v5: https://lore.kernel.org/linux-mm/20260507064643.179187-2-zhen.ni@easystack.cn/
>>> v4: https://lore.kernel.org/linux-mm/20260430163247.13628-2-zhen.ni@easystack.cn/
>>> v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-2-zhen.ni@easystack.cn/
>>>      https://lore.kernel.org/linux-mm/20260428071112.1420380-3-zhen.ni@easystack.cn/
>>> v2: https://lore.kernel.org/linux-mm/20260419155540.376847-2-zhen.ni@easystack.cn/
>>>      https://lore.kernel.org/linux-mm/20260419155540.376847-3-zhen.ni@easystack.cn/
>>> v1: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni@easystack.cn/
>>>      https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@easystack.cn/
>>> ---
>>>   mm/page_owner.c | 129 +++++++++++++++++++++++++++++++++++++++++++++---
>>>   1 file changed, 123 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>>> index 8178e0be557f..7595735979bf 100644
>>> --- a/mm/page_owner.c
>>> +++ b/mm/page_owner.c
>>> @@ -54,6 +54,23 @@ struct stack_print_ctx {
>>>   	u8 flags;
>>>   };
>>>   
>>> +enum page_owner_print_mode {
>>> +	PAGE_OWNER_PRINT_STACK,
>>> +	PAGE_OWNER_PRINT_HANDLE,
>>> +	PAGE_OWNER_PRINT_STACK_HANDLE,
>>> +};
>>> +
>>> +static const char * const page_owner_print_mode_strings[] = {
>>> +	[PAGE_OWNER_PRINT_STACK]	= "stack",
>>> +	[PAGE_OWNER_PRINT_HANDLE]	= "handle",
>>> +	[PAGE_OWNER_PRINT_STACK_HANDLE]	= "stack_handle",
>>> +};
>>> +
>>> +struct page_owner_filter_state {
>>> +	enum page_owner_print_mode print_mode;
>>> +	spinlock_t lock;
>> Hi , Zhen
>> The spinlock in struct page_owner_filter_state is unnecessary and adds significant overhead in the read path.
>>                                                                                                      
>> 1. Per-fd isolation: the state is allocated per open() and stored in file->private_data.
>> There is no cross-fd contention possible.
>> 2. Hot path cost: the lock is taken for every single page in read_page_owner() and
>> print_page_owner(). A single read can traverse millions of pages, each paying
>> spin_lock_irqsave/irqrestore — including interrupt disable — just to read a mode
>> enum or check a nodemask. This is measurable overhead for no real benefit.
>> 3. No practical race: nobody writes filter config to an fd while simultaneously reading from it.
>>                                                                                                      
>> Suggest dropping the lock entirely.
>>                                                                                                      
>> Just my take though — happy to follow whatever the other reviewers prefer here.
> 
> I agree. If someone is writing (updating filter) and reading (getting
> page_owner output) at the same time from multiple threads, they might get
> inconsistent results but that's getting what you ask for. Importantly it
> can't cause any crash, AFAICS.
> 
> 

Hi Vlastimil, Ye,

Thanks for the review. I understand your concerns about the spinlock
overhead in the read path.

The spinlock does have its use case: it prevents race conditions when
multiple threads share the same file descriptor and call read() and
write() concurrently. While we recommend users use the page_owner_filter
tool, we cannot exclude the possibility that some users might directly
share the fd across threads.

That said, I'm open to discussion on whether we need the spinlock. As
Vlastimil noted, the issue isn't severe enough to cause crashes. My v8
version didn't have the spinlock - I added it in response to review
feedback.

So the question is really whether we want to protect multi-threaded fd 
sharing or not. Because, the overhead is small in non-contended cases 
(single-threaded usage) since there are no competing lock holders.

Thanks,
Zhen

