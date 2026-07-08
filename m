Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A331C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A8E6B008A; Wed,  8 Jul 2026 04:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2321E6B0099; Wed,  8 Jul 2026 04:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148EB6B009F; Wed,  8 Jul 2026 04:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAA0E6B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:52:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6396EA06B7
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:52:37 +0000 (UTC)
X-FDA: 84964993554.26.78D8532
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 916A51C0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:52:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IYWfqZFr;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783500755;
	b=6ZZ5QP6KKi4GY0jpRVs+PNV/Z93yiKVOYRzB/OkJ3xST4u9eMQ2l+WlQeS9XppBfy2pm4q
	mHGlaAuzrcE5HCw4FMohjlwU4rb/m5vL/LeiNMgWpT0hiXzyf9W8656UG7Ijqiprvk08td
	2R/9bBx7OtJFxPur6UZrsp9CVR8tc2w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IYWfqZFr;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783500755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAiHJAZE3BqubfKAGYUb2cSq4Ujum8v596zy+Arjh8k=;
	b=wnKImdRzhc4DaqY5qhyJflRELBhgozW4i9jV7x3jxXwau/5+c2DkCsJuV6v5CM6Tiq4VUW
	HE5rSc6c78QLdM47hWgGih2jAIe2avB7Op/90daCq0jc9MWwtJz2uLWmz4ghi4DmJgT0X/
	lcr6mEeqxI7RSC1iJNC/U5Eh9spkX1E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2B0C40138;
	Wed,  8 Jul 2026 08:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083871F00A3A;
	Wed,  8 Jul 2026 08:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783500754;
	bh=uAiHJAZE3BqubfKAGYUb2cSq4Ujum8v596zy+Arjh8k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IYWfqZFrlKzG5iJWdiAYy8Ptr9ZiKtF297oeqWsyzNZFU8+kHFSNgiP4wWR1XJeth
	 kVHXxWu0p9WOGoBY5ea8OjxfSnyXs4oHx+X+SZV7gEvLhLv7DAweZbxcQuMWh7YFP0
	 HaCb+F3BAfohvyWF8iVoTHICvidotVcMkxJgbKaosBSpXE5fyyp98dmNnONNNNflxI
	 IxOUk3oSAt9wbFHXqGx9Viz0WSvr2TeNZVNlvhPEFYn1Qas3U6yvu1y6onmmlV6CJU
	 H7DEGzMuv9MowPdqCzRY7dOG+ESkD7xFEAonn/8RPYvNwuIC5N9smGqFB9r7iifBYp
	 a9wqYG7TCC6rg==
Message-ID: <5d4a10a6-430b-4df7-9085-a5b39631c6ea@kernel.org>
Date: Wed, 8 Jul 2026 10:52:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm: Standardize printing for pgtable entries
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: andriy.shevchenko@linux.intel.com, usama.arif@linux.dev,
 hughd@google.com, willy@infradead.org, ryan.roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260708032824.969752-1-anshuman.khandual@arm.com>
 <876c533f-6709-43a0-8595-143a8b9c9201@kernel.org>
 <437505b8-8616-4341-8d19-033d5b6b1d51@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <437505b8-8616-4341-8d19-033d5b6b1d51@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 916A51C0005
X-Stat-Signature: wxghf1xx7h7ehf43uuf93h45dk8ggzbj
X-HE-Tag: 1783500755-318973
X-HE-Meta: U2FsdGVkX1/BZIzfMRFrG+UfJf0Dq7bC0E/ykslMaYkVnTEIFIL7UivsEjZ1OruDhD0VRqQhs5I28fwcN9wZMKsuNUVE4MR5OIhOXBdOAio5rsD8k+CEzgeDYk2kZFvfslEWpBFUe8Eobi24s7DX8XkG9L9aTtH4n8YTFwwrGvp5BeYJQy+qqXkHi++zqJrnF8InaOT+HR60X4/J42HSHzkPffShYQ40NmhtqWo7DSfRdsj04EkfIxDydbGgcQdfQL1X6HnPQn8OZGfZTN/d8JEO31qY4EMk79gdzhjlbuKne9M3Hbdqt6Mi0vf38U4QruPaeULf9HllFfF6TT6omcyIitJVtkGFVm18nZ739oFk7OhPJELRHr+HPrY63Isb/9GWNUY5N12+w284D1gn/ymBatTD+JYY3s9LrVx2tCiLLXXQe++qM8mxTO99KGZH99DCzYuwOHnOfhTv3OcZUNDLbqfWqiE+QYwcq5OLvIBCEsmR8jNR4NzRCGrkm/0ljzyMfpM5H2ZQ+0pimiKrpQOAMTPFY16JZXlh/yPTwjQ9P/ryGos54x1fOpkWFre7xYuNmOYMsRB1IMs0ebOOn5YgWMIfEzqhYpqyXJsmtJj91mDjuLz0S6MnlCTIliXy30VqJ8qT6t3zH6ihOaERhXi+qWWPcAYcBIxkXtYzkcZigJ6bJnBVZeRrX5SdegfmrwUOak4Z3ghdxnLhM0LPHjt9V/dlNBuQKCRO0p1v6VPxh0ACrqLqvsgF6gJuNs+RJSEZPmwJVHx24c+bIim9U19OsqtlNyyBjnO5h2MzCAq2GbfZaQxlQWIoEqd9zM9mQQbDwpg1Nmz2R9lrpZuot6cxzaVOorJDyCfVoePUyWgdyxs/AS7X9BR7Qqrai/PqHGZRLmRL1FtTiQap86uKhbEe4VXkUn9ceHyCqf/c4SQzvBBEQaBWmSIgYux3XSNkt/QtFS33Jaef9Fqf1Ez
 CPFP+zvF
 RbUb/E2iqGk/l3pn+xvb9zcwlYLKdA/ZdaJknD4WAy5/AY1E+b3AJirVg/SqV7pSF/hWHBKdQR9t8PpnfnvIC7jB2OBbBDUhVCNFyvk9jzH2pkmuqfhLtO1oPGdk7JZud27CINDAtO0eQtAIC3E/eXsNKnLtd3Ky43DaP2sb5HliwfQ/4EaBoUNdSUkOXTlvORt8GgzlWQd7c2ecl7V+UwsnkzRiDFkAaEvUAogRZNzkcfmZKZMwXz3P57+XWc8AHlYQ4v2FPHDdCesPVD+tt/atfmxJkU/X5N5Kgvl6HyukfCoHwV3NvRo1ezmOFs8XLgRGviz5DMl9imaI6f1Nfvf0Zyzg2oJHu9cwn1rLdd3+bWcbPXJSlol2ZLC34L6x1p48gm/x8cWA/hfC/fH3kXmdk+VH0wxo+bAUYaIgXBMlkrI34x5D2JN9t1ELlBVH4rO9XW7S/WRAZDo0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 10:43, Anshuman Khandual wrote:
> On 08/07/26 1:31 PM, David Hildenbrand (Arm) wrote:
>> On 7/8/26 05:28, Anshuman Khandual wrote:
>>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>>>
>>> Bad page map reporting currently stores page table entry values in an
>>> unsigned long long and prints them with fixed 64-bit-oriented format
>>> strings. This is inconsistent across call sites and does not work well for
>>> architectures where page table entry values are not naturally represented
>>> as 64-bit values, such as 32-bit or 128-bit entries.
>>>
>>> Introduce a common helper to convert raw page table entry values into a
>>> fixed-width hexadecimal string based on the actual entry size. Use it for
>>> bad page map reporting and for dumping the page table walk in
>>> __print_bad_page_map_pgtable().
>>>
>>> Pass page table entry values to the reporting path as raw bytes together
>>> with their size, instead of forcing them through an unsigned long long.
>>> It keeps the printed output consistent and avoids truncation or misleading
>>> formatting for non-64-bit page table entries.
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: linux-mm@kvack.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>> I still think you should add your
>>
>> Co-developed-by :)
> 
> OK - will add.
> 
>>
>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> ---
>>> This patch applies on v7.2-rc2
>>>
>>> Changes in V2:
>>>
>>> - Dropped space after ":" during print per Matthew
>>> - Dropped CONFIG_CPU_BIG_ENDIAN per David
>>>
>>> Changes in V1:
>>>
>>> https://lore.kernel.org/all/20260707041703.658021-1-anshuman.khandual@arm.com/
>>>
>>>  mm/memory.c | 98 ++++++++++++++++++++++++++++++++++++++++-------------
>>>  1 file changed, 75 insertions(+), 23 deletions(-)
>>>
>>
>> In general, LGTM (I wrote of it, lol)
>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index ff338c2abe92..a2b63af82792 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -519,9 +519,48 @@ static bool is_bad_page_map_ratelimited(void)
>>>  	return false;
>>>  }
>>>  
>>> +#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
>>
>> We could reduce the stack space for !__SIZEOF_INT128__, but not sure if worth it.
>>
>> __print_bad_page_map_pgtable() will currently consume 132 bytes for strings,
>> guess that's still tolerable.
>>
> 
> That's a good point. Are you looking for something like the following
> where stack space can be saved if __SIZEOF_INT128__ is not supported.
> 
> #if defined(__SIZEOF_INT128__)
> #define PTVAL_STR_MAX   (32 + 1) /* Max 128-bit value in hex + NUL */
> #else
> #define PTVAL_STR_MAX   (16 + 1) /* Max 64-bit value in hex + NUL */
> #endif

Yes, something like that. Again, not sure if we need that right now, but it sure
looks logical to try reducing stack usage if easily possible.

-- 
Cheers,

David

