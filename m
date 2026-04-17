Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3541EF43683
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 09:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 751C16B00CF; Fri, 17 Apr 2026 05:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702926B00D1; Fri, 17 Apr 2026 05:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1A36B00D2; Fri, 17 Apr 2026 05:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5C26B00CF
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:58:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF95D13C08B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:58:02 +0000 (UTC)
X-FDA: 84667596804.30.3A6F18C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id F1AE9140002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:58:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mcRcwE+C;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776419881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vggxilHzi22tupDRPYUzRtQVBVIqyNl3pc0Ir9NVJQg=;
	b=BrCle5BRr7hb1z8MSF8Q1QnhvdwoD3+IK6iNl5qhVDabjsYtuCHm6re7Z5y30iQf6N/S0E
	fSc0mzXkONlIrZh1TdsTzv6Z9y1EU41HoEcyF1B3jn6PokBIpFq4O/gEIW+HgTDsD5bArH
	w3f7LEyVuBMb1oM5VGUpnSa0pB9tWRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776419881; a=rsa-sha256;
	cv=none;
	b=sPJIunpg8xiXM/xpoWQMTNXw1OPBvM9164Xpl/n9+lBSl7vYZFpaDmXJJFVixR5Y6Aps6t
	ks3VYOGjOC4lCndLlM9l477c1u1TjM8gKWdiMeLViGRXCTKZSdoBtsl+JEEV2oMTb/gZNB
	zSemAqDUKtApBcthsaQmb7QUDUYcJ3U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mcRcwE+C;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD5E343E00;
	Fri, 17 Apr 2026 09:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB2FC19425;
	Fri, 17 Apr 2026 09:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776419879;
	bh=2E5lhUu078wPwmjVrWs1doXuvxv4JvNpcxkCylouaek=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mcRcwE+CDJGe/aiLEO5IT80LYSEA2IjbnkGF+eOe7J/IAKQ00gMrplaNiY8AXfveK
	 AtZVmL/cTmR9bB0iNBJvhU/3s6Th/qbqSWDWN22LJ5saZlDOMVVdUlW3LbaKtkrbHr
	 LyDAqavHXgM4s7hDXNqaBUE5znLZn+0f5Bo75HcsQB6W4c/nfTOffVA9krjWSbNwtC
	 QwROI8t6bNURjQsYgPepNr4xbipF+ca/LikVZhraBhUTFi14RZuRHuQXPVjIH0a9zC
	 9vFsItX6cawo42YY2M3r0USEgUa84GMSf/d/VLyXIWBkjBxBdalWUmh4BzDTVP3FKf
	 DY27ct364FT/w==
Message-ID: <8a0b6d67-121a-4ac8-a74b-737d52d8b7ac@kernel.org>
Date: Fri, 17 Apr 2026 11:57:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/10] mm: introduce pgtable_has_pmd_leaves()
To: Lance Yang <lance.yang@linux.dev>, luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 Liam.Howlett@oracle.com, npache@redhat.com, dev.jain@arm.com,
 baohua@kernel.org
References: <b65d560458b2488f715b5afc1603d786e786ccf7.1775679721.git.luizcap@redhat.com>
 <20260410081938.51302-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260410081938.51302-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: udsi5airyrwo3qbygg1hmb6sfny8dbgn
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F1AE9140002
X-Rspam-User: 
X-HE-Tag: 1776419880-283754
X-HE-Meta: U2FsdGVkX1+lMd5cOWrqklcQPjE075HIfF9DqARJI08x0cb2xPpY6aRF3JEFRn13JC3ooYKTYyL/rfTTJIc+OWFvomqCCfcTYdPY8F/VtaGudWHRoqDO8tFpZjZlFxd8rQcwYyTed+PAqc/iSCTIWlRf92nAFQht4Av2g7cqiaarwVGgqoM4pmVRhcrDAbr7Gy1UFQixG6P38TzEi9z54CXji2QpOX+zqTNjl/KslakL9VMbC4bvmZtZMAP6VFCpQuoR33IA9zA9T3PKoQbYVgSj1exhHHoouNW3ZfKZZpzCeUQENDNfQyuyiYN1Ag02LcXZqMrjFv7A5nKK1sxOms9b4+kQMS4VW2tRrZ9siFDom8b5xeRNY6FfpsTMWrNAIRrZqwQlRnjdiHhNl7VBOjlPa543h00ZTodMuahZV/oPkeRr9ugYMkB9RiHmxcHPK4Ag4r0Hv9ShoNpYVcZwv+oag2Fayiv3cYUcKGs7eG2x7x7Kah1ZlwqF7Wjk3nGfprhZ4x6d8i8fRbWI9NPO/FA5mK8SHo61yIkDdzQKjMZCYOTMQCrfczh7aLGjuG0QHKiVmFhpfR0srlG/1LtrzUMJa0o7DEgw3eCYo9SUbaB/fco3tjQOxozrtXyxtLqSlqfAfa1Hjl0hhtzHjLoWR948Xm+Zi6SicViYPVZyfWNRJgf7tTVEkqe/kQhQGT1iP+1DVnbZAQlZxEiGfDHQE05TO+4eCoTmCkjiIsQyqY6D3cp1tvXMcDLhcvnsdKwx2Z4Zy7m+KJAXk4naQu2yJGxZ5tqXyc+DFy9qk2uMJTtSwhNeQJbtaHRrXciHefCRQYQKfS9tU2Xq8uGfRr9kLSbtDh9TU/VuHIvO+675vVsGlQ/j8wlWFBsHpeP/NCyWPW0VlFXi2KDEa/flOPLbCXWL+OY3wEMkHoj24+Jt2ysVYUTJ7GVdXZUzHpN7eoZ/t14J9cFjADi4GbS20EG
 ciV4t2rq
 v+NQuYjOxZ5A0ApMeqzIZQKTAhJc22f2UUrqu8Q/JbElCm9cOEL/+8sSXMrdbikx9mL9zPJKVHZaUeYxoSS1s51SA3I6x7CjPxMzU1iVPDg811AuaJpnRDFRPYoeHZUngs4glAXI4mMRl/BQiyIimhOcx5XSz5XtAG133m6ScY4U6q2quY1R5dMhliPsQvOBGX70FU5Evxj7OurxIo3Tw6t61ubRcuMQ5W+ABPTxBkHgS+PTdRozI8SejR0n2Yr9gkY6OFJKuADcdASFc07bfOHcCd8TU62AUCYCBuMAUAF7xE4A56xtMEXzBvq6Z7WG7Cdgmed0vC4geYQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 10:19, Lance Yang wrote:
> 
> On Wed, Apr 08, 2026 at 04:22:57PM -0400, Luiz Capitulino wrote:
>> Currently, we have two helpers that check for PMD-sized pages but have
>> different names and slightly different semantics:
>>
>> - has_transparent_hugepage(): the name suggests it checks if THP is
>>  enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>>  implements this helper, it actually checks if the CPU supports
>>  PMD-sized pages
>>
>> - thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>>  by the hardware, but it just returns a cached value acquired with
>>  has_transparent_hugepage(). This helper is used in fast paths
>>
>> This commit introduces a new helper called pgtable_has_pmd_leaves()
>> which is intended to replace both has_transparent_hugepage() and
>> thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
>> it returns true if the CPU supports PMD-sized pages and false otherwise.
>> It always returns a cached value, so it can be used in fast paths.
>>
>> The new helper requires an initialization step which is performed by
>> init_arch_has_pmd_leaves(). We call init_arch_has_pmd_leaves() early
>> during boot in start_kernel() right after parse_early_param() but before
>> parse_args(). This allows early_param() handlers to change CPU flags if
>> needed (eg. parse_memopt() in x86-32) while also allowing users to use
>> the API from __setup() handlers.
>>
>> The next commits will convert users of both has_transparent_hugepage()
>> and thp_disabled_by_hw() to pgtable_has_pmd_leaves().
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>> include/linux/pgtable.h | 15 +++++++++++++++
>> init/main.c             |  1 +
>> mm/memory.c             |  8 ++++++++
>> 3 files changed, 24 insertions(+)
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index a50df42a893f..c4c5282f795c 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -2192,6 +2192,21 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
>> 	}
>> }
>>
>> +#ifdef CONFIG_MMU
>> +extern bool __arch_has_pmd_leaves;
>> +static inline bool pgtable_has_pmd_leaves(void)
>> +{
>> +	return __arch_has_pmd_leaves;
>> +}
>> +void __init init_arch_has_pmd_leaves(void);
>> +#else
>> +static inline bool pgtable_has_pmd_leaves(void)
>> +{
>> +	return false;
>> +}
>> +static inline void __init init_arch_has_pmd_leaves(void) { }
>> +#endif
>> +
>> #endif /* !__ASSEMBLY__ */
>>
>> #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
>> diff --git a/init/main.c b/init/main.c
>> index 1cb395dd94e4..07f2ddbf9677 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -1044,6 +1044,7 @@ void start_kernel(void)
>> 	print_kernel_cmdline(saved_command_line);
>> 	/* parameters may set static keys */
>> 	parse_early_param();
>> +	init_arch_has_pmd_leaves();
> 
> One more thought here: I don't see why we need boot-time caching.
> 
> has_transparent_hugepage() does *not* look expensive on the common
> archs. On x86, it is just a CPU feature check. MIPS is different, yes,
> only the first call there is more involved ...
> 
> But if we *really* want caching, couldn't we just do it lazily instead
> of adding another early boot init step?
> 
> Something like:
> 
> bool pgtable_has_pmd_leaves(void)
> {
> 	static int __arch_has_pmd_leaves = -1;
> 
> 	if (READ_ONCE(__arch_has_pmd_leaves) < 0)
> 		WRITE_ONCE(__arch_has_pmd_leaves, has_transparent_hugepage());
> 
> 	return READ_ONCE(__arch_has_pmd_leaves);

Would look easier when just using two booleans: "has_pmd_leaves" and
"probed".

I do like static keys, though. And wonder whether just putting that into
hugepage_init() would be sufficient?

-- 
Cheers,

David

