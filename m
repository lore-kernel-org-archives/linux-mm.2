Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF643C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5BAB6B0093; Mon, 29 Jun 2026 05:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32A06B0095; Mon, 29 Jun 2026 05:30:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49336B0096; Mon, 29 Jun 2026 05:30:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FBA86B0093
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:30:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 364B6A061C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:30:17 +0000 (UTC)
X-FDA: 84932429274.16.DAA0658
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 63956180010
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:30:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EutMHnAh;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782725415;
	b=0SIPFpMO5hrZniZWEFzfvXUNUpV328nu1PP224g6glgCMvesFAtAukeQXNkV8d9UfcSFl+
	AWzqImnLrgwupBtVuDV9XnxB9HAh6yfQsWtFDYqNT7CfugwbDQlXKEwMpI1/7T/fo/Cbmc
	54Sumhni3V5stgWmaVHZ8F8yonOCLh4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782725415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmDX1DH/x6Qb+eyiKeo7PcMqEwayzbWwezkxHNk+4wQ=;
	b=mFOnOTOH7ZJh+pBQuxbhzQGrCZNyZlDguOOi7wV6dMv5Irmkkrj9DBmRPpNnVUG+QHneVD
	d6laoktAVBIpVoYLmw2E6Va/NjmetxhH+JbMn35lrqY9ehf1YzVIkKex48YApKbRgyFxUG
	W9ATLfJ6sVDzyapj72H9slemVIdtbOc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EutMHnAh;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B8A8B436E6;
	Mon, 29 Jun 2026 09:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD7D1F000E9;
	Mon, 29 Jun 2026 09:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782725414;
	bh=rmDX1DH/x6Qb+eyiKeo7PcMqEwayzbWwezkxHNk+4wQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EutMHnAh9AMm8hlou+ng55EpSK50mnvkmYgXu2ARdX3DpdRC1zqHPW/MDsYZQn+Qi
	 LBvJ7Chyx1vQw8tLOqkqbu637GtND92HAGR8wv9u3M3kTmT+4a8OY9l8xYCaXKaIcg
	 HEY9AfB+KpwpQVYUIJlaqy3U8078wf93NJcVYQDaZovotSvLnlbl6EZ0W3JlBUti/c
	 NwPUmzi+YUhBiIlFfTJ5ipmSMsAUQ0leyfNmJFwqciqmtJSXr/WbValEX4YI+NaP9C
	 /dMarZos+DRNLSNxhLWaX/atO+6h9g+d2NdJrZA1BF1lXd2LvyiwWDsprowb9Hoxen
	 2niTmOWvidbSw==
Message-ID: <49526116-ce35-4447-bd98-f5f0ca12d92a@kernel.org>
Date: Mon, 29 Jun 2026 11:30:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 1/4] mm/page_owner: add print_mode filter
Content-Language: en-US
To: Ye Liu <ye.liu@linux.dev>, Zhen Ni <zhen.ni@easystack.cn>,
 akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
 <20260625043101.338794-2-zhen.ni@easystack.cn>
 <d86d309d-9f5a-4d63-afb0-dc4016fe1ded@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <d86d309d-9f5a-4d63-afb0-dc4016fe1ded@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: onyagdt457zyuazko4fjszojpeqbbggu
X-Rspam-User: 
X-Rspamd-Queue-Id: 63956180010
X-Rspamd-Server: rspam02
X-HE-Tag: 1782725415-134248
X-HE-Meta: U2FsdGVkX19/7wMh6p+r0PzZEO9U/fEUYNEgUrmGgyxCH6GWyGb7hUdbghBaFQPz2fU/2sTaHrFJ+vdM8wHdjrlWWPN2JLdsL2gyccQee4q7L9BM0Szx7JguwneeIVGgy3JANaLFFkmyIbxvMAexqmXMuYrkPyPbk4vkTE96QUTW9B+RFPDqZpQ5+cbjrSGNPkV5aRSO1AO2E+utYIrAHv+R453+d3Zrfx/dwn22XWUn1TueSK6nQKxdLBIMO0QDD2Hxw5SksVhCl54eFsRsUYMcmD1/sG55yVMYPy9r4UB/ipiDZLcSovBB5nlk22ySfrbokaZvV/Betd1xHYSMVJ0827FLFe+q2THp830uxlkvrMmGttERZg4D3dFnNNtLD2fPjbQdPAylVE0zyRKagWLz0W9/rTwltftbLeaVh+s9oiuRU5/AH+UOI0cVSvVZukjO24rYpQA6Sed/0/oha/3wqs0F0zY9LcJGUhVM4F0IGtVE6zqHdnIEHcIk+6jX+x3Pfgo2WS8SRR7j/oUI3ypvrUq7upod++6Qh02cuPYotrlVpvc8960jw6YODORJx10NRwQQ9dypUgwB+XWh/qCYEDAAmHxecNOIDNU9ChkYVK0tVBL5ZKY/w9C2tmTJK32kR8YBkbUOZqiL2dVt6pRtldHwPngLhvwfaHC+yFJLA/BwJJsx/S2zF8VkQNYwNPQRactUN4dx2nB3kNLELqJW9P7e9QiJz4gP6e6xBiQkrxuQv2FwrpMNbSnSY6hIQmhYCfW+R9ETltMYWO7qgX1WbfEt+gMdBYG26I4cnXEnpvohuvxjP339WY3N/h97wxHu2EHhmwbee05Ks3LtleevUk9Pzy9r7gkpoPFiXmZsUKFc14komja87yGJFWVfTHIqAB2cTr4hC5FN/fOm+GY3D0I0w51BegCV0PY0p9mKcajihTi1gFkCowLP7I5KH6aatgOypJX9V0Vn9Vv
 7YHRMb1D
 tHoZav0P+INVwN4oNHYOjfl51LsjE7kTrJWcY7TS++kPxrJDN2Iw82vBaFBJFSaZJKQz8uH1g9JlEd7G+b8BqTRWpg8JQqRzz898rF9y8vw4OGerVR3ginyggl3me3b8QbPTN+3opZIFh1eIe38lvEUj4qX0CaGphiiSMUizBtu1nuCjdeMScTSWqEy6UYSKqgNEnmbQhqgtlCn/99KlUT7hxSsF2bDuV8E3qaJfy4bSizmfpAkrU1b8QiJVqaUwXYriVZe/awoK90lWY6jFmlk+DiccKgUhqAgGGEJ+vmJDyL/w8wfKgHrrFR7o90q81j/WQKZwFwoSdc5sASTROJRQ8UiQjwaYxQE81
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 04:59, Ye Liu wrote:
> 
> 在 2026/6/25 12:30, Zhen Ni 写道:
>> Add a print_mode filter to page_owner that allows users to choose between
>> printing stack traces, stack handles, or both, providing flexibility for
>> different debugging and analysis scenarios.
>>
>> The filter provides three modes via page_owner:
>> - Writing "mode=stack" prints stack traces for each page (default)
>> - Writing "mode=handle" prints only the handle number
>> - Writing "mode=stack_handle" prints both stack traces and handles
>>
>> The default stack mode maintains backward compatibility with existing
>> usage, displaying complete stack traces for each page allocation.
>>
>> The handle mode dramatically reduces log size and improves performance by
>> showing only the handle number instead of the full stack trace. Testing
>> shows handle mode reduces output size by ~66% (84MB vs 244MB) and
>> improves read performance by ~4.4x compared to full stack output. The
>> mapping from handles to actual stack traces can be obtained via the
>> show_stacks_handles interface.
>>
>> The stack_handle mode prints both stack traces and handles, making it
>> easier to identify pages with the same allocation pattern by comparing
>> handle numbers instead of comparing large stack traces.
>>
>> Example usage:
>>   # Using the page_owner_filter tool (recommended)
>>   ./page_owner_filter -m stack          # Print only stack traces (default)
>>   ./page_owner_filter -m handle         # Print only handles
>>   ./page_owner_filter -m stack_handle   # Print both stack and handles
>>
>> Sample output (handle mode):
>>   Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
>>   pid 1, tgid 1 (systemd), ts 123456789 ns
>>   PFN 0x1000 type Unmovable Block 1 type Unmovable
>>   Flags 0x3fffe800000084(referenced|lru|active|private|node=0|zone=1)
>>   handle: 17432583
>>   ...
>>
>> This implementation uses per-file-descriptor filter state stored in
>> file->private_data, allowing each opener to have independent filter
>> configuration.
>>
>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>> ---
>> Changes in v11:
>> - No changes
>>
>> Changes in v10:
>> - No changes
>>
>> Changes in v9:
>> - Add spinlock_t lock to struct page_owner_filter_state for concurrent access protection
>>
>> Changes in v8:
>> - Fix buffer overflow by adding bounds check between stack_depot_snprint() and scnprintf()
>> - Fix unsafe string handling: use memdup_user_nul() instead of kmalloc_objs + strncpy_from_user()
>> - Fix strsep() memory corruption by saving original pointer before strsep() call
>> - Change format specifier from %d to %u for depot_stack_handle_t
>>
>> Changes in v7:
>> - per-file-descriptor implementation
>>
>> Changes in v6:
>> - Remove unnecessary braces in if/else statement (coding style)
>> - Use stack array (char kbuf[33]) instead of kmalloc for input buffer
>>
>> Changes in v5:
>> - No code changes
>>
>> Changes in v4:
>> - Change from numeric (0/1) to string-based interface ("full_stack"/"stack_handle")
>> - Merge infrastructure patch into this patch
>>
>> Changes in v3:
>> - No code changes
>>
>> Changes in v2:
>> - Renamed from 'compact mode' to 'print_mode' for better clarity
>> - Use enum values (0=full_stack, 1=stack_handle) instead of boolean
>> - Update debugfs filename from 'compact' to 'print_mode'
>>
>> v10: https://lore.kernel.org/linux-mm/20260618035750.3724613-2-zhen.ni@easystack.cn/
>> v9: https://lore.kernel.org/linux-mm/20260525081652.2210206-2-zhen.ni@easystack.cn/
>> v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-2-zhen.ni@easystack.cn/
>> v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-2-zhen.ni@easystack.cn/
>> v6: https://lore.kernel.org/linux-mm/20260511033017.747781-2-zhen.ni@easystack.cn/
>> v5: https://lore.kernel.org/linux-mm/20260507064643.179187-2-zhen.ni@easystack.cn/
>> v4: https://lore.kernel.org/linux-mm/20260430163247.13628-2-zhen.ni@easystack.cn/
>> v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-2-zhen.ni@easystack.cn/
>>     https://lore.kernel.org/linux-mm/20260428071112.1420380-3-zhen.ni@easystack.cn/
>> v2: https://lore.kernel.org/linux-mm/20260419155540.376847-2-zhen.ni@easystack.cn/
>>     https://lore.kernel.org/linux-mm/20260419155540.376847-3-zhen.ni@easystack.cn/
>> v1: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni@easystack.cn/
>>     https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@easystack.cn/
>> ---
>>  mm/page_owner.c | 129 +++++++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 123 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index 8178e0be557f..7595735979bf 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
>> @@ -54,6 +54,23 @@ struct stack_print_ctx {
>>  	u8 flags;
>>  };
>>  
>> +enum page_owner_print_mode {
>> +	PAGE_OWNER_PRINT_STACK,
>> +	PAGE_OWNER_PRINT_HANDLE,
>> +	PAGE_OWNER_PRINT_STACK_HANDLE,
>> +};
>> +
>> +static const char * const page_owner_print_mode_strings[] = {
>> +	[PAGE_OWNER_PRINT_STACK]	= "stack",
>> +	[PAGE_OWNER_PRINT_HANDLE]	= "handle",
>> +	[PAGE_OWNER_PRINT_STACK_HANDLE]	= "stack_handle",
>> +};
>> +
>> +struct page_owner_filter_state {
>> +	enum page_owner_print_mode print_mode;
>> +	spinlock_t lock;
> Hi , Zhen
> The spinlock in struct page_owner_filter_state is unnecessary and adds significant overhead in the read path.
>                                                                                                     
> 1. Per-fd isolation: the state is allocated per open() and stored in file->private_data.
> There is no cross-fd contention possible.
> 2. Hot path cost: the lock is taken for every single page in read_page_owner() and
> print_page_owner(). A single read can traverse millions of pages, each paying
> spin_lock_irqsave/irqrestore — including interrupt disable — just to read a mode
> enum or check a nodemask. This is measurable overhead for no real benefit.
> 3. No practical race: nobody writes filter config to an fd while simultaneously reading from it. 
>                                                                                                     
> Suggest dropping the lock entirely. 
>                                                                                                     
> Just my take though — happy to follow whatever the other reviewers prefer here.

I agree. If someone is writing (updating filter) and reading (getting
page_owner output) at the same time from multiple threads, they might get
inconsistent results but that's getting what you ask for. Importantly it
can't cause any crash, AFAICS.


