Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31571C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FCAD6B008A; Wed,  8 Jul 2026 04:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4906B00A4; Wed,  8 Jul 2026 04:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111426B00A6; Wed,  8 Jul 2026 04:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDA8A6B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:43:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FDB990F96
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:43:34 +0000 (UTC)
X-FDA: 84964970748.22.C7D7372
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49107160005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:43:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JuTeCaJP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783500212;
	b=B4+lBJSIbxSfCTwb0RiOVbR+nWhBqqAoWtf1X2aFQK59QJBBNCD8brHhIddfv/2sBSnkTo
	M3qLCrje5gQGyla3TJy7sMqSX1ijti8HamA4Lf/2QPanKkyuuRDNJ0zmXPT4+OfZcZzjbd
	+SNC59K/uAVHZn31mIsaguzWdYpSo6Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JuTeCaJP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783500212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RpSFjubiSNglNc6EAkaSPGixV3m5Q9xD2SlBZjzGCzk=;
	b=5TDz4ULmik+QGB7mftfXvHIqnzW86sDcyATJ0u1A49r3wUxr3/72JzBK6Z0aMPYfGYRkSr
	3Psr8QdrurJ279AA0xoftv4t9wh7tCCE84u4BRrY/xnXupeeLrKje7oA/Zf4dD+WeMdhDG
	x/MfsFWvJy3JrtrXXnLna5SGa+X23bQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D80401650;
	Wed,  8 Jul 2026 01:43:26 -0700 (PDT)
Received: from [10.164.145.253] (J09HK2D2RT.blr.arm.com [10.164.145.253])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C16873F7B4;
	Wed,  8 Jul 2026 01:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783500211; bh=MCK9eENGAIn0ByvV2x9VNERLdyrWsFYGRTi6b6lpGJ8=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=JuTeCaJPdfGfvfNwkDT9Vihg/6/Zu8Zs+uuYJRWvUxfUPsZJ7R/v1NLC9TP/thJQg
	 wdPrqqvy9Cum3YT19QPDMP/M64YWy128vXZOPC9r0Qy3PmxUMrq05nN4/g/8P7HK1R
	 igecv7wUyuAYJr3WYIL2utYOBp4dc5GzIUPwoi2M=
Message-ID: <437505b8-8616-4341-8d19-033d5b6b1d51@arm.com>
Date: Wed, 8 Jul 2026 14:13:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH V2] mm: Standardize printing for pgtable entries
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org
Cc: andriy.shevchenko@linux.intel.com, usama.arif@linux.dev,
 hughd@google.com, willy@infradead.org, ryan.roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260708032824.969752-1-anshuman.khandual@arm.com>
 <876c533f-6709-43a0-8595-143a8b9c9201@kernel.org>
Content-Language: en-US
In-Reply-To: <876c533f-6709-43a0-8595-143a8b9c9201@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 49107160005
X-Rspam-User: 
X-Stat-Signature: 97tgp5debfrppgkgsgmfi8qkczaxsx6k
X-Rspamd-Server: rspam03
X-HE-Tag: 1783500212-285564
X-HE-Meta: U2FsdGVkX1+uR84DsyGdbzqpCvMhOD1BTOoEzmpDdjU/ddTvAQ+2XXloURkJ/82NOJ0a6CqirhwQ5uclYs+lG1RCbd66dLLvE8qxwrYJ6a+uwD7Eax9WT2YegKsTMZpW8Xq2lA7pi+ItGWMUXXdsqeYxqbKi12ws0xzuX0JFdn8f5SGHwC1BEwUKPgascKFLExwWn83HJFDXUf9fBeTyGyp/5X+PtccnVBwyibpy37vL1suRhsUDI94LX0fnAJ+2KCjlOgaKlkKxyOmgbjs6+Bkj+gUicowG/Hk5OgBLpx/+VwvDOoVF5Pd3kWezcyAC4yPBcWHWvwSa67PRuaRq8/J9b+rG4snBxGjepp61Pc4wgnCVY0g9zizPstbB/7cbkSS0SePU1xKVPGDlZIynjW6oBIPDKawEJDupSEJXB3Qk1zHXwmYksCEkMm9E0sIJiT5C9omK22HE2/98J8hHNa1k4PeskGI3gbIrhf6pY0Cfvy6MxzQ88O3xoj2d6LWOmNuW2tTUtlbfovNdVGuBSyYqGIHoyC7z6tNpy/YhWsOtAJqZ+c3tA8oFbHxCVKvItRAbLqJFDf4/8OU/konUci0d5b39OSShXheEHBkB1DUad9sgSchU+NG4t+WdePzt+h89qHVxp6ZS0vKdy30xn6zV4yltM2ywfe6b6OU3TILzolXcuwDNWu+B51/6aLdSXGwVIqode7GePb4nd2kaC8/DPEccZYNQKLJUfNLW/xAyMvIl2eOXatBLQJcO1zM7/GVdthSF3fzUZ9d2DITszhvImLF7sVm5o/DBaS/jDvbrwKBdPaE9Xzu5tEviZKgSXGmE2cQD7yAsJcxHMoczzeqYe8wlC1WD6atoB7ZyH8n65+TJZ+5l6NQHgxNN05Z8jUTyNAETEbS3FSRpQ+WZVu8OWOUamVVBLtULU0rZuG3PggDC00Co2T7EbQSeuE/f+8J1sx3eRBU8DJ9+Z9w
 6Qy0kepJ
 Zyr3DbGnk0dEiIF1b1Hc/ZeNjtzZIY/XpzMw2AU/swMTyNLpBk1gTXwoiTPFX9G6Af1YOpWcVVdi/C3ER/4NB4kTvXDYswTJlV9PXTMx/oLuZVHlCeOIoRFvqtUuq5njlwoWhVdDoB8k9nrvg0zb/C25d6HyrRfA6si4GiwpT4IggEldcWBYEvjpaLFpimBGxmeztCyGdZmAChuzGJ8pZAx1oyFyWIwAJKqar9T/sAY+NdaGYR6Da2GRaUxdT6650TMROyYQpZSkT00HDftD81iOVXlPKOuk/Ay4TDRFYIwl2b6yc74q2RP1AnK3VTpdu7IsYLZcklxPnsFPdJpjXxe1TakAfohIlk0zboiloFnW8V5EQldM7Es2zSIYkqsvuhJkOyKy2iB+tBEejJFqV5zZeKTA8quHgF6kZq1FP9A65QAxACbidh3NCPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/07/26 1:31 PM, David Hildenbrand (Arm) wrote:
> On 7/8/26 05:28, Anshuman Khandual wrote:
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>>
>> Bad page map reporting currently stores page table entry values in an
>> unsigned long long and prints them with fixed 64-bit-oriented format
>> strings. This is inconsistent across call sites and does not work well for
>> architectures where page table entry values are not naturally represented
>> as 64-bit values, such as 32-bit or 128-bit entries.
>>
>> Introduce a common helper to convert raw page table entry values into a
>> fixed-width hexadecimal string based on the actual entry size. Use it for
>> bad page map reporting and for dumping the page table walk in
>> __print_bad_page_map_pgtable().
>>
>> Pass page table entry values to the reporting path as raw bytes together
>> with their size, instead of forcing them through an unsigned long long.
>> It keeps the printed output consistent and avoids truncation or misleading
>> formatting for non-64-bit page table entries.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> I still think you should add your
> 
> Co-developed-by :)

OK - will add.

> 
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>> This patch applies on v7.2-rc2
>>
>> Changes in V2:
>>
>> - Dropped space after ":" during print per Matthew
>> - Dropped CONFIG_CPU_BIG_ENDIAN per David
>>
>> Changes in V1:
>>
>> https://lore.kernel.org/all/20260707041703.658021-1-anshuman.khandual@arm.com/
>>
>>  mm/memory.c | 98 ++++++++++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 75 insertions(+), 23 deletions(-)
>>
> 
> In general, LGTM (I wrote of it, lol)
> 
>> diff --git a/mm/memory.c b/mm/memory.c
>> index ff338c2abe92..a2b63af82792 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -519,9 +519,48 @@ static bool is_bad_page_map_ratelimited(void)
>>  	return false;
>>  }
>>  
>> +#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
> 
> We could reduce the stack space for !__SIZEOF_INT128__, but not sure if worth it.
> 
> __print_bad_page_map_pgtable() will currently consume 132 bytes for strings,
> guess that's still tolerable.
>

That's a good point. Are you looking for something like the following
where stack space can be saved if __SIZEOF_INT128__ is not supported.

#if defined(__SIZEOF_INT128__)
#define PTVAL_STR_MAX   (32 + 1) /* Max 128-bit value in hex + NUL */
#else
#define PTVAL_STR_MAX   (16 + 1) /* Max 64-bit value in hex + NUL */
#endif

Besides will move the macro just before __print_bad_page_map_pgtable()
where it gets used.

