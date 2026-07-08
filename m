Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF1FC44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 12:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FFC46B0005; Wed,  8 Jul 2026 08:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689DC6B0088; Wed,  8 Jul 2026 08:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551766B008A; Wed,  8 Jul 2026 08:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26C6E6B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:43:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A41B3140121
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:43:38 +0000 (UTC)
X-FDA: 84965575716.29.EBE035C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 63CCAA0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:43:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ulcn4CO9;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783514616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLS0X5htIAfEZh4Gjlb4fMvTuiWjqdpiV3qC5e3cZHY=;
	b=0LGTd9iKPXWb425IsPXnnZl6Vz5muLIXrkISwTVJ4LNKOH0czmwZnfrCZd9VeCNeaQiOME
	LV2BAt50G6RPoyDkSCTW8dKQoOZv8GgnudQ2sd9gSIdIEduL0mzmYrQw0dOigOV6KhrQu9
	m9Sbt/hGxCW3/tvlAKDJ7tXGQ+BetnU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ulcn4CO9;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783514616;
	b=ip7baa7L/nqbYhiCis98kwahWEp3T40x2ZLnxpHq1E+C5hXXk/3Z1ejJvZo+F7I83x3/KM
	qA3WIACSUjzGeG2nPlghoptZYJar8u5Bl4DiNjxNwFvlT8wP1ba81njq94Jc8ky0Xwz3N2
	lHcFYpOaUgrmpsII3iokrWQouD/TCbc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDAB82F;
	Wed,  8 Jul 2026 05:43:30 -0700 (PDT)
Received: from [10.1.30.54] (unknown [10.1.30.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E0D6C3F7B4;
	Wed,  8 Jul 2026 05:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783514615; bh=gWp+3yzItFKmNeTeCbEZqOw1SYe7BR0bUIaJS8T+B6o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ulcn4CO99/3f/6uXCB350dwHaGdTkecbpP535w1xCRxO5v4pJCASINSJJ6EO4iHRG
	 QgQB0TEcCzb4MhMfw8AAguXxmbdeGdTg40kMoaWx8huTY/bQostBbsutCL51JekyW8
	 k3ei7oY0ouAN5Pijg9THZ0dughBzpr9NLIEoeHLg=
Message-ID: <724a080a-bd4b-4fab-a890-c6a97ebff77f@arm.com>
Date: Wed, 8 Jul 2026 13:43:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm: Standardize printing for pgtable entries
Content-Language: en-GB
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: andriy.shevchenko@linux.intel.com, usama.arif@linux.dev,
 hughd@google.com, willy@infradead.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260708032824.969752-1-anshuman.khandual@arm.com>
 <25cde246-540f-4ab4-b541-0b7313c57954@arm.com>
 <76f24730-46de-4583-9189-ff7ba28c741d@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <76f24730-46de-4583-9189-ff7ba28c741d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 63CCAA0003
X-Stat-Signature: 88j7ca3iog88ptzenre8xmeeft4d3kt3
X-Rspam-User: 
X-HE-Tag: 1783514616-410644
X-HE-Meta: U2FsdGVkX1+Q0BvwSo9Pg69uZfRXGnBuxAYK43T6hwqQHlew3Ug8z5hZZrZFih272kgnfoFLP8qXQfbjrGiPLyLTqGaw9FKFBH7K2PZfmHu5kNwzHfbPc5iQyoFHZxr+Qko5np+RNVjLh95+lhPet/2TGX4O0o1Cm5EMWUFWfztYiRgDuMeN2coyYlOk8VASJ2A557ZzQovUTwuO/BNofEeDZVgK1Cpr5+s5UcT9Grl90FZNehtC0ndIRph136EG4qUX056GlkcJSM3sN0fexyM5W8PuYFYKeCs92w4wy33s+8RGWNg6aCTP0v6N/MxGBz7p2nZoMyCr1rBDEMC212O8l+i5Qpkwdzw5adoOa/WlTWcbMsivZspoHUICojCy45FO4np5CuRJD/2WYJZaQAY5itX949Qyccgqa4HX3FBvMT7oo/RAmEXdHzacp1k61f8m8Kpn/2A9aQ+A6GAKAC/Tc2Pkr5YXmV6HDDkanDH9dUJUp6plQ6AT7zOjQRtvjDAcIojzXR5wh8seEWBtLRD/zyAD/U5kFV0taIRH1KMvI7V32JHZPCN9tqDD0+SO0XEgAzypDy6vkIPDGmStfy7NvXp2trY5ZLGYdi64Xj7ktCawqwz3yKBfjYjSVtsA6MjloZFaqHyi+/tkyTvJ4j0wKnI7rmWX+DQ0h/55UdtW7p9ivLFyqlnQg+nhYscC++2KlgvdgBWjbnW8xf/DvCpCk69MJw1wM9gGBp8gkNwuPnfyBapVqketAgbt0H1BMVLBzMKtT9/TdSfQO2ba1OQssq4uXIhfWGxE8ofa4np+l7Z5eoNkCh/FG4HIe+CPqvnnWD3Sw2hPu5/h4nY6qrrNqorAsxKmmE6uFSlGVs76+kKT5/W+JdNPKCtXMdDrWqOnC51XJKKWJcI+OV/yG5srQIonO9SAlNJpGYpUa91B7zVS7wanhTVXMSILH6zLKkPylAROy1HxoKo5+2j
 pfHz9Gox
 wJ1KE9J7JEb08fL1R5/zxbPEC1K05KD5IdPbLyxQw78EL04M2TDG5zzttN+/W24kbLRNF8del8dALObj4VhnFAP8zzmHA6bNGN92Iq8KWmvG7muj8RWJYVxJAstH3K4MtQBLUq+DYzaN21Mh08I0WUxbN02993LFkjF4Xbhe5NAfViYtRcZ2ZM+y9Ug+ThLyxUOvL6LOMAWpHGrGWWxGmmQpHgKV8ekuKLum5eYGUhcApiZtH2Dx4Yfqm6181QMsvW04MZ8SRlOvwnOXdcAyOmFEUDQWPH4sZMwoNrO8rL5VCU5Yob98YTxLteq4X9g06yzFK7NMQPy/6BSzP6I8XL0kfkGFm+oI6RqjcUu9+cSNvRzztmvZ52dUnEW9pVEX+1d2MYPS+XVcM2gAc5Mi2+vzo8MnklK/ZZj6i6eKHfG5UyZ5NtVr94oMAUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/07/2026 12:27, David Hildenbrand (Arm) wrote:
> On 7/8/26 13:22, Ryan Roberts wrote:
>> On 08/07/2026 04:28, Anshuman Khandual wrote:
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
>> Not sure if it's worth doing something like this?:
>>
>> #define PTVAL_STR_MAX						\
>> 	(MAX(MAX(MAX(MAX(sizeof(pteval_t), sizeof(pmdval_t)), 	\
>> 	    	     sizeof(pudval_t)), 			\
>> 		 sizeof(p4dval_t)), 				\
>>     	     sizeof(pgdval_t)) + 1)
>>
>> Would probably save stack space for 32bit arches?
> 
> Do we really care about that? This is about a corner cases error reporting right
> now.

Fair enough, it just seemed like an obvious and simple (very minor) improvement.

> 
>>
>>> +
>>> +static void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)
>>> +{
>>> +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
>>> +		snprintf(buf, buf_size, "overflow");
>>> +		return;
>>> +	}
>>> +
>>> +	switch (entry_size) {
>>> +	case sizeof(u32):
>>> +		snprintf(buf, buf_size, "%08x", *(const u32 *)entry);
>>> +		break;
>>> +	case sizeof(u64):
>>> +		snprintf(buf, buf_size, "%016llx", *(const u64 *)entry);
>>> +		break;
>>> +#if defined(__SIZEOF_INT128__)
>>> +	case sizeof(u128):
>>> +		snprintf(buf, buf_size, "%016llx%016llx",
>>> +			 (unsigned long long)(*(const u128 *)entry >> 64),
>>> +			 (unsigned long long)*(const u128 *)entry);
>>> +		break;
>>> +#endif
>>> +	default:
>>> +		snprintf(buf, buf_size, "unsupported");
>>> +		break;
>>> +	}
>>> +}
>>> +
>>> +#define ptval_to_str(buf, val)								\
>>> +	do {										\
>>> +		__auto_type __val = (val);						\
>>> +											\
>>> +		ptval_bytes_to_hex_str((buf), sizeof(buf), &__val, sizeof(__val));	\
>>> +	} while (0)
>>
>> I think arm64 code also does pte printing, which you also need to fix up for
>> D128 support. Perhaps this could be moved to a header for reuse?
> 
> We could do that as a second step, right?

Sure, but why churn it twice? Anyway, no strong opinion, you're the boss :)

> 
>>
>> Also not sure if it's worth returning buf so that this pattern would be possible:
>>
>> char pmd_str[PTVAL_STR_MAX];
>> pr_err("pmd=%s\n, ptval_to_str(pmd_str, pmd_val(*pmdp));
>>
>> Although perhaps that's a bit busy and should be discouraged...
> 
> Yeah, let's not do that.
> 


