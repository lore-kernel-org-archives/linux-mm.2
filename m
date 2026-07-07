Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E055BC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9DB6B00B1; Tue,  7 Jul 2026 03:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8A736B00B2; Tue,  7 Jul 2026 03:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7D856B00B5; Tue,  7 Jul 2026 03:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 88A5A6B00B1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:08:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04E6FC1CE4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:08:51 +0000 (UTC)
X-FDA: 84961103304.13.D9EDDA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3C55C80002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:08:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=axXuCzSC;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783408130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQBPzeQTUsoBAHhbAd8CqcjmLxqDEHm995n/RdJoJgY=;
	b=fDEsg4/JMOoq9VEnXdTlTt6Hv3VqcYuO6k/KXwj7dEfMNWgblWi/v8lRmtXMHxXKdY/fne
	0YgWDzP/Z5HcKxI09ttqzob9/IjWiweXCyKyYklY9VzG1GHETVMIdUghP9GLRalWPqAuEf
	Vdx1Gy38niO6PoWddj646THoJa+XiUs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=axXuCzSC;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783408130;
	b=f5pHtsCWKmD/fu3WwVurzNnfx3Y7Gzxb8ynSzOFllqbcKtXVza3CzX0xY3HuaAcsBkYlu+
	MJZ56Ic/GdlsRUiX5o1YH5V776KOJp+HFIgXExcTKXxFtjQ4uz7PKpvZPWx9ObkzCyox8Q
	3ZurQTHDbQpKdnQ8TZUCW6oJ3HuWbT8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A8BC407FF;
	Tue,  7 Jul 2026 07:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3385E1F00A3A;
	Tue,  7 Jul 2026 07:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783408129;
	bh=jQBPzeQTUsoBAHhbAd8CqcjmLxqDEHm995n/RdJoJgY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=axXuCzSCHG3TVFRpTNM+eLZBHMPfC/7NofeFrQivYgsRWxkB5/J9Vb1VFoZziynpY
	 yd3nsNrYGymf25QqoYLv1xUuAlvRSFRCiPLdKWA8uLpQ3XNa2IcisnCdjLEuBCFM+A
	 FNkuawlX37GGYsreHhw4vqCFAVFiQ2vFDJJIL13lX4YNtJnU223jUvRf2xA9Bg8NqZ
	 hm5xNtoVBVHKAsGkHSC24yWf8LGaYFjQGNInNag9q2wNAd0Wda0Amfakhwxvu59pEZ
	 D7enSH8vK6l5jPOJq+NcKUvvSp6XBuJns6snER07SRxbmKSFFROfSS1bzqGQYqRq/Y
	 Hovjc6Cl96Vgg==
Message-ID: <5c128db1-7f82-4e2c-b029-5623880ea56d@kernel.org>
Date: Tue, 7 Jul 2026 09:08:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Standardize printing for pgtable entries
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: andriy.shevchenko@linux.intel.com, usama.arif@linux.dev,
 hughd@google.com, willy@infradead.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260707041703.658021-1-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260707041703.658021-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3C55C80002
X-Stat-Signature: 51mb4fpmx8b1irjn9awo4uzqemrwkedq
X-HE-Tag: 1783408130-642124
X-HE-Meta: U2FsdGVkX18wrheY6T+3A1hNbe70ZXWTNBGWT3mf2jpNqY8ZgZ/5fBb2Ghy+ymqlfEINlFmLAOzuDR7RN/UBiudqiMvFliz54SnJgqkqluz2runoUlS3Id4DnhjtoWIfq3iQYz1cDxNKgpPXIvk5NRUGY/0hrxE/4yr+mDbPLpzKSfjBULt0WN6ReVgXmcvR8ptlJXjpDWFvaZD4oKv2zNeWdM5lmYx2JS3QQfFtgC6a+VEWHn3WQ8yBpwHkkiMiZqLNnWkEDWfCva8S3kLR9UFfGsQ5vrKqg4/vI5AkPkuuVzGjcihSEjHwwqSOl/9dtFVbz5alk7MWNXEPaRmt4F55L1N7XlZk21941rgRcP+7wObzjQSX4jIREcCXibkbx/zIb583fQA1Pfr5s1ArZHp2kGQWMt8tQEarXLazfWRw3JJVpbxS9WikllLTNrM/fzEyfrPiEBxu+ZjcDmdhgKcec+j6YKCdmk0tsriHOgQE6UzcI+K43wCX2VWBFoMdjysja43hsGvMhe6wLvsjeXXvziXzhVOombzoZOMM7+8yaRlRYlGzRIvCLvij5BL0ypiC2mhhBhzs8RHnQxKXi5gOvujKq0i8zz+MhfVHh5qUkQmOAY4BGKSsGobAy7cKkND1smgdfDJxnb8+KOtr36fSthlq0NzUVR94ciR8el9X1QBpBX4IdRPlDmtvjMV7aR7AHQ2Tj6vGnhBoH4oAHgl3X66sgEu0mtCpFQGq5tnD+pjpMEBnZiKLQ3n7r2CapMU2Xc1p6WES0oEowjqWZg3gqZWI7ga7otqJCPxmK8OhzH/FSFmBjXr+7Y17soV97nS8ctXWVDEElTsGVq9Bxt710xMmKbIpemCoMAxiMPw73YN6T4D9n07Cca6XlGtpCogD5q8b3jMPgAqtnkUl+ntdzUVXnLeDmL4uYADdBSyVpC/1yFhMCvqEm+FWnwhLPxrjTsfXS9tGt6+AhQ7
 JZA2U0Fk
 z74tqvb5mPoSljILT0hhl88q4934SRutdbmtLyjhPXoeRxI3UCT8S8npEsppLuRVe0+rNKx7E1TsoCcj9ABWBkeD0EwkxcTuPOC6OWk0dokxyHLlaMEUBCI9D6cGAbd6rg9z0mD6gPLrMfnTJcBEzmHonYLhNG/1uZG1ygHqtwAS49GU0WccmlYHHk5oBdsSg5+ZaRGVDHJQQ1+anp1eg0ZQKW92fCvvHrE8ZOqqqzXS2RStQ6SwD0cYedAwM9mrD2bwA06FjFtDHx0YGPD+7/sh+mTXYDv+eOX6eh0bG1NThiD8iMNTjcfXNV77Ob5XcraNeMUqqT+GiCobJLq9VoLj8AZO2JeKSPIiD0wqra+f62ozq6OrFf1D9S9icF8iEYr3OclHz8k4fgjmJvHBN+LSoXZyU5ZlAshSiuD9Y9auc80ljs2b2VnLFptjeuraY4SSNni3fs4Lh2AE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 06:17, Anshuman Khandual wrote:
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> 
> Bad page map reporting currently stores page table entry values in an
> unsigned long long and prints them with fixed 64-bit-oriented format
> strings. This is inconsistent across call sites and does not work well for
> architectures where page table entry values are not naturally represented
> as 64-bit values, such as 32-bit or 128-bit entries.
> 
> Introduce a common helper to convert raw page table entry values into a
> fixed-width hexadecimal string based on the actual entry size. Use it for
> bad page map reporting and for dumping the page table walk in
> __print_bad_page_map_pgtable().
> 
> Pass page table entry values to the reporting path as raw bytes together
> with their size, instead of forcing them through an unsigned long long.
> It keeps the printed output consistent and avoids truncation or misleading
> formatting for non-64-bit page table entries.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

You should add a Co-developed-by here :)

> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

[...]

> +
> +static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
> +{
> +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
> +		snprintf(buf, buf_size, "overflow");
> +		return;
> +	}
> +
> +	switch (entry_size) {
> +	case sizeof(u32):
> +		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
> +		break;
> +	case sizeof(u64):
> +		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
> +		break;
> +#if defined(__SIZEOF_INT128__)
> +	case sizeof(u128): {
> +		const u64 *val = entry;
> +
> +		if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
> +			snprintf(buf, buf_size, "%016llx%016llx", val[0], val[1]);
> +		else
> +			snprintf(buf, buf_size, "%016llx%016llx", val[1], val[0]);
> +		break;

As discussed, can we simplify that by casting to (u128) and then shifting the
values into place?

-- 
Cheers,

David

