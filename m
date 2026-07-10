Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC6EC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 03:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 634156B0088; Thu,  9 Jul 2026 23:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5AA6B008A; Thu,  9 Jul 2026 23:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FBD26B008C; Thu,  9 Jul 2026 23:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE606B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:10:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 853A514031C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:10:35 +0000 (UTC)
X-FDA: 84971389230.12.A6A33DD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7DDBC20009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:10:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lNLmbCZA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783653033;
	b=LMKmJIuM1pBpTC972sP+V/eUDvSEHY1QmFFVOXG9y2cc87FZLLoThGuRY4cx92jeSPbgIe
	FXtvNakiW38OZpGjgLgVNJrGm7A2LshEfi5BgfUMUI8qjvK5b+qWMLvvfyaUAlWtceAv22
	hLilZ1+u+CVQI23qXly+xWKJf5r4Ua8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lNLmbCZA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783653033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QPRHajWjrhSaIavarxUnyeF35eab4+Io7xcy5kNS10k=;
	b=GbqmiDHbByTftE98+BGC5PUFow78LEqHKNWEvq0jjPvr+V7933WttBT3M8sF/9eSOa3qfe
	t2E+DwRwDFCSKo+ZtKb8R5G5W0WqhhtASB05MwpGeZ46ieEj3t1Oy9tDVdhohSNq/jCtMP
	Q7TyvEh5rFP2Gyo9YzDGAIPxZ96Ju6U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22CD21E7D;
	Thu,  9 Jul 2026 20:10:28 -0700 (PDT)
Received: from [10.174.42.251] (unknown [10.174.42.251])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 462D23FC81;
	Thu,  9 Jul 2026 20:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783653032; bh=r/JqXLtVJZipeHmoQcA9Vb3tveHMo173t3JvLPsXfyg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lNLmbCZAKfAuKzOWn13sCSTiJnF4tNjcdAiQw5oDxbwzYSUmw/NG2SisqM08KNOED
	 W4v6Kh+fr07ME6UaNZNJST3Dhv3LsXj/B7AySXY13fV1vu3TAsT2KFUDHrS0JvJrwS
	 +rVAdObC8bYH0+S5QeWHMdOhS76Fp+VkZrxh6yMg=
Message-ID: <25857f58-9ef1-49e0-99f7-366d91028c02@arm.com>
Date: Fri, 10 Jul 2026 08:40:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, andriy.shevchenko@linux.intel.com,
 usama.arif@linux.dev, hughd@google.com, willy@infradead.org,
 ryan.roberts@arm.com, "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <20260709170816.4e876a16eef9a93f41bb1940@linux-foundation.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260709170816.4e876a16eef9a93f41bb1940@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7DDBC20009
X-Rspam-User: 
X-Stat-Signature: 7tyct7bncbm1jjebs1wy7c95spxx8i5y
X-Rspamd-Server: rspam03
X-HE-Tag: 1783653033-385938
X-HE-Meta: U2FsdGVkX1/0jomMbItECAXYP48o+LULQwSAFniHK4RU1gUbP/7huIPj/x5Ruwe6R4uDsdrHGCemCBblX/IOgPqQrXwsxhPlULzSHdr+zMEXLpFU0EA7UxVo+q4CNBQ+QSrdDRD6zZIhGYW5B/RZfmMIN1XZp1c2zEslvRuIQoXJ6SLxsl5WJe6IOk6jZOkyVkriWopcjw4oFTk0QhVPgPQbPAyn4Vnj4uC8bRdq1QejdpNLEShP+TJLk6i/CfZU1PDEsxY0JDJe1zl68rSqtRloa6GJ9D6HSR2VqwSnRdZTR751MjLevkPd910QMObFDRbjxrts838qRe/z0T8EU1mQW/jKeloE4MPFME8XitVyCNOqkA3zdv6+9BhAk5h+/U0kepqAIj/vEMsAPsv3gRkpUhNhrIJSnTdOLMCjMedPRxnmzvXTK6xmGZakUYZTTXw4lnv3AU8tTsMhcZUhJ2ZcIZk8DIUXhd9+dp0yjD9O1w/nyhYGTMgq5rwX2TlHVYW3tNc0/DcG1xPYqnZHecso6yJJS2qmfBx8cOOksBy1ZpkBkwFwmhc3tkL+OELwjSZ79AILvTe1lVmp8YIK1oBTckFWI8xGa5jhMLSA5zZ85HmGv7CLs4R79TOE6SSqNLtN51bT9i+QZQCSX2TnOIgzSAIVsDK9IxtTmilfN8zITqjnXeOexlH6qkyPJz2PCmE0eex1zum3R9e5rfS/gvZzFYslCGik7jUXkoBQ/ltXNkztYpXFAVUHRNthJr6Pk1L75ID6jHZV8oCN5FRE07s21J7jq1ezhNfDAK9cZjFHr7qVndlsM2N8RBjlECRcbYg+XX1WONrRh2h/8y5iPTJBSEXjxsqmFvTH8PcEtcB7tSjGLkfwtkxt4LL++f1oAZWzlj1WPeuFWXfPX8L99joKENVr3zQatT6h6WvYf+UO6gI7i1cxKMWC06xEriy8v76z4bERoGusB38/Ql8
 goj8sLv6
 olUHWc+ekigglLH5WyBjnpIhN8OoE3/bplQAIQ2LY+YIF799Ec6uD5ognPJnACceCYvR6RYqtBA8tAea2vp5IlvgWkARLwB54QQ92gRQ/GMQu5Qm8hFvHFnbhBfVCggQAyVnRuclu3Sl9TQWz+UyXIUR/sPQSZ2TJCn8IhQIIUeyotL5o9MV4iJm/llc5DmAAvWnNbWql0SFJsmmpxrVm1JanhjXmDvAu9OasQrbyg4gbQ09T1hyJ4Z2OmHvbEqZhaF+NiazZy/rlGEGTClm4nSoXjtDgCOLRsE9yOCglIqKz4h9nrCbNupaf6lw8xq9x8pnH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/07/26 5:38 AM, Andrew Morton wrote:
> On Thu,  9 Jul 2026 10:13:34 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> 
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>>
>> Bad page map reporting currently stores page table entry values in an
>> unsigned long long and prints them with fixed 64-bit-oriented format
>> strings. This is inconsistent across call sites and does not work well for
>> architectures where page table entry values are not naturally represented
>> as 64-bit values, such as 32-bit or 128-bit entries.
> 
> Well grumble.  It's a lot of fuss for something which nobody is hurting
> from.  Or are they?  What's the actual utility here?

Current page table entries print does not work here for
128 bits format (arm64 D128) because neither 'unsigned
long long' can hold 128 bits nor printing extracts u64
from the 128 bit entries while printing with "%llx".

Proposed a separate printk format %pp[te|md|ud|p4d|gd]

https://lore.kernel.org/all/20260610043545.3725735-1-anshuman.khandual@arm.com/  
 
But there after it was decided to rather have a local
solution in mm/memory.c instead of adding a new print
format.

The proposed change here streamlines existing u32/u64
page table entries format prints but also enables for
u128 which will be added later.

> >> Introduce a common helper to convert raw page table entry values into a
>> fixed-width hexadecimal string based on the actual entry size. Use it for
>> bad page map reporting and for dumping the page table walk in
>> __print_bad_page_map_pgtable().
>>
>> Pass page table entry values to the reporting path as raw bytes together
>> with their size, instead of forcing them through an unsigned long long.
>> It keeps the printed output consistent and avoids truncation or misleading
>> formatting for non-64-bit page table entries.
>>
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>>
>> ...
>>
>> +#if defined(__SIZEOF_INT128__)
>> +#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
>> +#else
>> +#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
>> +#endif
>> +
>>  static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
>>  {
>> -	unsigned long long pgdv, p4dv, pudv, pmdv;
>> +	char pgd_str[PTVAL_STR_MAX];
>> +	char p4d_str[PTVAL_STR_MAX];
>> +	char pud_str[PTVAL_STR_MAX];
>> +	char pmd_str[PTVAL_STR_MAX];
> 
> That's another 128b of stack, in a potentially deep code path.
> 
> Hopefully gcc can reuse the same stack space for some of these but it's
> not been good at this in the past.
> 
>>  	p4d_t p4d, *p4dp;
>>  	pud_t pud, *pudp;
>>  	pmd_t pmd, *pmdp;
>> @@ -532,34 +575,34 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>>  	 * see locking requirements for print_bad_page_map().
>>  	 */
>>  	pgdp = pgd_offset(mm, addr);
>> -	pgdv = pgd_val(*pgdp);
>> +	ptval_to_str(pgd_str, pgd_val(*pgdp));
>>  
>>  	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
>> -		pr_alert("pgd:%08llx\n", pgdv);
>> +		pr_alert("pgd:%s\n", pgd_str);
> 
> can this do
> 		pr_alert("pgd:%s\n", ptval_to_str(pgd_str, pgd_val(*pgdp)));
> 
> and eliminate a few locals?

But that would not eliminate any local variable.

The helper ptval_to_str() does not return but instead
fills up the provided buffer which later gets printed.

