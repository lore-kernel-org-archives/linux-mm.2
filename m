Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA300C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662EB6B0088; Thu,  9 Jul 2026 05:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63A3E6B008A; Thu,  9 Jul 2026 05:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5555A6B008C; Thu,  9 Jul 2026 05:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2EF326B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:13:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB0811A044A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:13:05 +0000 (UTC)
X-FDA: 84968673930.10.1189FFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1228FA0007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:13:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jo9YjbQo;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783588384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8m3px3wvL7t+yfRyJJDo1wFoeEvqbSBdF2NL5bU1BLk=;
	b=iJpORo0XexiaIC3XqCr1+3Jw1MIVuorVbe3G1X5WTzQHhSnNWwyMZetcfzVvXrfmHwRg7A
	WzKPy34Wky1MEHNQVWFZ3HEq0BBsYLXFqPH1M09isiWm1TIpGOY7CktNHmEVCT+EgoNdx3
	8265+MqhAfDmHKa2hJO1ZQprXvsR7Nk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jo9YjbQo;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783588384;
	b=TEyqNK7YZNaBuWsSOwG+sV+iT5y1Q+DLgOYr89/TxSV8V+p2aNQtjGaj0MQrRcELPJ2c67
	D80QNa87KvB6fE4ls4tBYTgK18tGy8JkAhgT/oyb6JL+wYLYgzeY2gND3fmihRBmdNyjbv
	04MPXFUwnz4SV5fosaMSQV+3jffVWRU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7964E600C3;
	Thu,  9 Jul 2026 09:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EBD1F00A3A;
	Thu,  9 Jul 2026 09:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783588383;
	bh=8m3px3wvL7t+yfRyJJDo1wFoeEvqbSBdF2NL5bU1BLk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Jo9YjbQoO+fClv+/OmXC6c3I4tJIvVIulKNtV9vpEQpdGI+J0BS8I6pjQD6QfzeTP
	 VD+ngcbEDuoef1KQhPHMETvBkv7hDkruOcxofNghKZM/JZvRey/rVNOrfrENk4mMBV
	 sG9Xh4EjcqlocaCrq9vMAvxfcU7xZKTzlEN8alTIJPbMdYMOSVh05FTFZ7VwO8zJaR
	 U8kKuu6HGEB66G1UVV5/9UMZlWGnpOAxaafY+cm6/GXFYKFED4UVAbJE8QnA0nyThu
	 6U1ouxODJ9oeFd8CZ494X/8Vzx0KD2K+lpfQppJdA7uN1K57oVn5KjeOAe7sqUfUOc
	 llS12265Drvpg==
Message-ID: <dfa83e42-4f27-4c38-8796-b64a791788d9@kernel.org>
Date: Thu, 9 Jul 2026 11:12:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Petr Mladek <pmladek@suse.com>
Cc: linux-mm@kvack.org, usama.arif@linux.dev, hughd@google.com,
 willy@infradead.org, ryan.roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <ak9Qe1G7Rv3HF6ZR@ashevche-desk.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ak9Qe1G7Rv3HF6ZR@ashevche-desk.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1228FA0007
X-Stat-Signature: e8ixab5riy48ootxxn5cm6fmkte7yeef
X-HE-Tag: 1783588383-718564
X-HE-Meta: U2FsdGVkX19DRkJGk0jF83rfnkSBmg6RcG/lSYWg7sFb/AFteDolskpOpIjihL6g85rIstCCVIb3XquuWppttcP8BZhTqHmCPNgc4z62VI4cqTuxXb+QkNySQkLWdSAHyRWeAuVE5fot6bJzubLNuB7/k3XtvNBe+8ulZJlV46JExMJdjGQ/M9tO7OMorJA7RKBG2oeCUaMd+OvMDRYD9pQ0634BlSQZxhOIIxM/MX8wGBu3zrcmqjcYuWRuqu27vWEujGCQRweYAv5Bt/G3tHi3IYmuSnBwvUG+PsQjjg8JzuNn/myf6um4nzxUCNAi1NcsWP90nvzK0F+avC7saZ+VZw46mjTKmTETeyK61S1eMWDXOtt4mit6FKi+hwBxKfxXFRYUXV9EBlr1KCVITEaJiEaUKEAU3iRz+t9Iy1m/jFnu9ap0bjpq5R3yzbokODuNuJ/pQFTu8rO+Csx3SHv2A2JDFXTlO/2K700pH5pGKT29k2mkJ/C6U+5NKEIMZ+xlWbDNl+H3NYfjLUPZDkX2fR5tFYFVpWoS4IQLfBHFXdNcVUVRbp4P1vSPaGZW39g3RaLBzPy+SeGEJJ1zMP4DQaQGKx25S9rbzEDauRsuLBSWAHAoaGKQYaI440K26UivJjLGEruFfz1E7Z6OmAD/pHzqa92c3RVmecVMxSbePKW+vQy8/j+osZACQDE7Rsk40AiiIXG4NatHEhA15t2TL4N1d3xmy4UGVdjCC4fvRkw2msWEWKQvG/+ZxO4C/PcnE8Azbt+ix3ucj/Je4czQU/qEtsoJRhi/XoqsVmi+HgFhymEbSckE1/XMuxL+c3tuY85TQXNq+0Qj2JFF9RaOsDNtcxH2MdJxPGv4nMr9tECmySGbikXSmFBQFDkPxndcBlnNTvMOSGVL8WbXl1vl9q5lN3u30LKNAHCWfRBL5D2RNmMIPKV0RLsHCKTWxQwMGDl1kT12Do3Hi8u
 wmjx9QeL
 Uuu/uf0R0FUUohKdoNRHTO6xBe/XNC0Okjg6DHwNqUN0mlCXrIA3ID7mdJRKpx69EMXBKT3GDGpnulJNUNKD/c7ixCBiyqiKqrebggrJ+iCp60RhhSPZOdzcYFO6SpEklpcRryKOb4vF2ElZJnHcNFHgy2+2p5Ok0Gy8c0Mxq/pSapT1BLub2Xze4YnK78zCNezMLOQ3rv+ZKNhatihPmm9rE2TfQ337JJRw3CCEgEIyXP1+oMdbzYYZBNYC7LfYqMgXujF710p2S7ue1rQ8iCsdymkMtLoQ7Q5CIMJSezDQDfRKGXsm4k+/hvRUdBsIcsqp5M1fbyEOJFpE/AlBu7J4UkHjEWYu93tPKk1sWPzeMFSoEpK4hMogbWdI4U53P97j9NHLcytLD/kRU6nHATrPRKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 09:40, Andy Shevchenko wrote:
> +Petr, wondering your opinion about code dedup (see below).
> 
> On Thu, Jul 09, 2026 at 10:13:34AM +0530, Anshuman Khandual wrote:
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
> 
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
> 
> FWIW, you may move these to be after...

We generally don't handle it like that in MM. Maybe one day we'll switch over
and document it accordingly.

For now, having selected patches doing this differently is not any helpful.

[...]

>> +static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
>> +{
>> +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
>> +		snprintf(buf, buf_size, "overflow");
>> +		return;
>> +	}
>> +
>> +	switch (entry_size) {
>> +	case sizeof(u32):
>> +		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
>> +		break;
>> +	case sizeof(u64):
>> +		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
>> +		break;
>> +#if defined(__SIZEOF_INT128__)
>> +	case sizeof(u128):
>> +		snprintf(buf, buf_size, "%016llx%016llx",
>> +			 (unsigned long long)(*(const u128 *)entry >> 64),
>> +			 (unsigned long long)*(const u128 *)entry);
>> +		break;
>> +#endif
>> +	default:
>> +		snprintf(buf, buf_size, "unsupported");
>> +		break;
>> +	}
>> +}
>> +
>> +#define ptval_to_str(buf, val)								\
>> +	do {										\
>> +		auto __val = (val);							\
>> +											\
>> +		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
>> +	} while (0)
>> +
>> +#if defined(__SIZEOF_INT128__)
>> +#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
>> +#else
>> +#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
>> +#endif
> 
> The above is quite duplicative with what we have in lib/vsprintf.c. Have you considered
> using something from there instead? (Yes, it might require some functions to be wrapped
> or dropped from static.)

Which part in particular do you have in mind?

num_to_str() does not apply due to the u128.

We could have u128 variant that we would only provide with __SIZEOF_INT128__

int num128_to_str(char *buf, int size, u128 num, unsigned int width)

And then have the code pass the value instead of a pointer to the value. A bit
tricky to handle this based on conditional __SIZEOF_INT128__ support, but could
be done.

Not sure if that is really what we want here, though. ptval_bytes_to_hex_str()
is pretty ... simple :)

I didn't immediately spot a replacement for PTVAL_STR_MAX. E.g.,
of_unittest_printf what calls num_to_str() just hard-codes "16".

So it would be good if you could clarify what you had in mind, thanks!

-- 
Cheers,

David

