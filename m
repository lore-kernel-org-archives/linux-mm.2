Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0059C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 09:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19C56B00AE; Tue,  7 Jul 2026 05:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF12E6B00B1; Tue,  7 Jul 2026 05:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06596B00B2; Tue,  7 Jul 2026 05:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97F036B00AE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:08:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCB25120377
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:58:58 +0000 (UTC)
X-FDA: 84961380756.04.EDE1D94
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 906FA40009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:58:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dulQMMmn;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783414737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rafzc7NSX40FsHAeCQrgdZ1t+LeM6LJzDVfIjGWs6nQ=;
	b=66SWHJKyfszInJFhe7H6cyFdi0r9kidfswff//onmjaU0pxJCKiqdbEVxz9cYo1EcLYVTn
	i0iJPOY4peRF3hjkGAdPfSGyryTUzZyVtOSraFZ9blVj5ZE7q/fCkrAvl7TXMy4f4TL3/y
	KJCNqzJgFmO23qRAfmvPkLVveIpKeA8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dulQMMmn;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783414737;
	b=vd7TwUyAk0PfmN5WkqgZgccmkwHt5Bra9eJViz1b+1ephBeAUm8yo5zCL0dFpFgDugWjDP
	UUgt94t5BuNGAaeJwpJYw7RcPfddgvNYlfruQQ0S/UpKAYViUHooH3Iky2kZUhwidEiLbI
	+5aLCcHAk/Lnq8nGKPw0vXH3nqK9EsM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DB482B;
	Tue,  7 Jul 2026 01:58:51 -0700 (PDT)
Received: from [10.174.42.191] (unknown [10.174.42.191])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2647A3F85F;
	Tue,  7 Jul 2026 01:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783414735; bh=vy65AfeKcM9JM0/EN7cdtimmzBIvOMxJ8F0u/aP5ezw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dulQMMmnCkJuz3jkS1i/8I+q5kXKdSZouMk2DqiF/Y/xCOt/C0g51KuE5ViN0xdFU
	 3SxQhpPlQd65nhPNyl1MPeBHEgLhwwvDcs7/Uzzwacc0ZnDxJU0wFOOZjF5y7jy7qI
	 hjsoHbuAU2gsbvJ/1koYZS3TlAEdqYnjKTs5ENWA=
Message-ID: <dcab355d-ca27-47f1-8421-c610a9e58365@arm.com>
Date: Tue, 7 Jul 2026 14:28:43 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Standardize printing for pgtable entries
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org
Cc: andriy.shevchenko@linux.intel.com, usama.arif@linux.dev,
 hughd@google.com, willy@infradead.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260707041703.658021-1-anshuman.khandual@arm.com>
 <5c128db1-7f82-4e2c-b029-5623880ea56d@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <5c128db1-7f82-4e2c-b029-5623880ea56d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hourjyp8fahx8ytd7suitr54aywurnjt
X-Rspamd-Queue-Id: 906FA40009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783414736-546790
X-HE-Meta: U2FsdGVkX189VzqU/UsPwc6Ex8WSlTbHujhtdflmiqKyVypWiBYzhLT7T/LwIXyOIa8SGQ+xTCzhZe/FreDFvLopo2S+Q4DXrZktnCBkvNvzUf5T0UrZgvLur1ASdGvxuKu/M8NlGv5xi37XEgtW2bBL+5DFCit8Fca2r9LGfaf8nuvu+Vrz3vNxKPZyT/03CTY9aH5mG1p7BOQZLUemNSYy6gUnHftHvRIzP0Q+Z+xJdTYRX6HEgVNIYo/1wUPM8m25/s4SYvvfJLh/zlv7kkUy5x6q9r4uRTHhbaEbXX1RIZyckuq3M4Oqio7hGPvqRLtAqrH5caMCkFzijQJ/3FOJwMQRPJtq/3eIB39VznhkfrVvA+CBTk2oTQy1O7/T2FmSNT4ZRAt6BfkdRSs1/dKl+vQ0ny27lFbsAM0067zaW//eNWov7L2A6az5SkYnjY3tYdK6oTIqM/Jnobl/2CL6UQKpP9L2dCCzw4bIHX37F2JRtfRUiZryPMLElLOihTNEGOf/PRauscROPBR6DyRTEu0BgT1uhOvK/a5u96/XNaDV+3d0D8e2DpCXKU0mOOSFsNM64O9PLgS7b7BUheebfm7+PNGN8G2l2pvHAZEJWB5+1NqYhxL4QcGum8pFxiYGa1sR5j9kKXxt6Zkbo32HVq7DB+luf3hDSN7LFhEF+WMw79a+sDOIvtsnWm1wgLsM2Bca3wlsWK5AZ3+7M+pU4kzFucyaao0jLXeBNBE134ulVjFwY6wN2DiwW2zAsFP/eR+19lBTLuxFZiRSbSWd/Jx6eaREElZz3AW0SC2/ShEUgYlif5FMts4uTwCMY0aTNWZBk4MNH53QgJyPuOxxJb54ayxoX1tACKfclRa30HcMwlVBXW2+VJ8gRD0Zpo6clC31FrUIMIoAplL/kPOX1pUiLPpAxjInYcdi6jNGew2fUDMzGPBp2YkvDdUdLSvxR9ZS8mhRGEknPCS
 Vc80t61k
 TMFcY+SU2YBKm6FucfCg8agNP2nP12yj4g/rZPm++xpsWlbDZkL8reJDsguO0KL28XhEpJwRdb4UInFg3H1DzSoeuSLlgbRiAUEyP3F2UNBM89zFhryrZ9RbjhiHdVAnIJhFt2byBw0RJhnp57OBEBPBU6JnW1Rsuvzws7cAJh6JzzaqHJjHagWKQgz/Kp0RihbKBmjU7qXtTJEk9WdqzhsAebMlf7X8heBScZP9NQMVi18QHuS9pxR7X38XIQx5oDWD9jZYS2oYedpR3K/AAaAGc+MuE7FJldLsz05EKLJNygpweqlMkuadFU/rii3FdUuLFhCwVb/Q8GAn9KWZBq1krwGE8UOfzWMSoGpV+DCzlO7J8puRbtNXDolsjEcPOVVO1I2MjgyPISJMMPyVBO02clU7hQNXTwGv5gdi5rUMddyHIamgjdmFb6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/07/26 12:38 PM, David Hildenbrand (Arm) wrote:
> On 7/7/26 06:17, Anshuman Khandual wrote:
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
> You should add a Co-developed-by here :)

Have not done much changes from your original patch :)

> >> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
> 
> [...]
> 
>> +
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
>> +	case sizeof(u128): {
>> +		const u64 *val = entry;
>> +
>> +		if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
>> +			snprintf(buf, buf_size, "%016llx%016llx", val[0], val[1]);
>> +		else
>> +			snprintf(buf, buf_size, "%016llx%016llx", val[1], val[0]);
>> +		break;
> 
> As discussed, can we simplify that by casting to (u128) and then shifting the
> values into place?

which would be something like the following - had similar
construct in D128 RFC V2 series as well.

snprintf(buf, buf_size, "%016llx%016llx",
	(unsigned long long)*(const u128 *)entry >> 64),
	(unsigned long long)*(const u128 *)entry;

I did think about it but is not the proposed chunk bit cleaner
instead and easier to follow. Do you have concern regarding u64
pointers into u128 then accessed in chunks ? Regardless don't
have a strong opinion either way.

