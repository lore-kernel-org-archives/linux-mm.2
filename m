Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E53FD74EFF
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 16:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA0A36B0510; Fri, 23 Jan 2026 11:32:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78066B0512; Fri, 23 Jan 2026 11:32:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976F66B0513; Fri, 23 Jan 2026 11:32:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 859D26B0510
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 11:32:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2DC31C1CBC
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:32:41 +0000 (UTC)
X-FDA: 84363772122.08.0986EB9
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 13D36A000D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:32:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SQL3us+n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769185959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sPtpqluJAEzs0V3IMSuKGoLpy2/LAXVAY/2KFjo66G0=;
	b=67nyvT7IfXYKOvHHjZWRUrnVD0Ih5I5seo2HF7RAdyIEZoz4bBY8Km+5Tv+LxhvvtA0w6/
	V4doMsKRFj4j8HoWdmUShMzxrnAlZJ9DQYYaCqaN9UsOsRBjnKk57hxqyxtIMkecZsKRcc
	lIhKBRkzPlvRmWnAuJsMIf4r4kJYGSc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769185959; a=rsa-sha256;
	cv=none;
	b=NV+hfOI6AgwroFAWMzbSeDaBTgZtBOmBTzZoqWIUqmjGajQl8WQVE93x6Xcp5mrwLAVFJo
	lfQxNheFQDj7guDH33PGyuv0JR+pvZro/+Jcle6uXoMi0oPomTCTIrdfQ9hZt5M0K9hKj4
	ll5YglfnSSMs+FbAH5RyU2+y0/d322g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SQL3us+n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <8fb6cba3-681a-4e63-9409-d35ab628d42c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769185956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sPtpqluJAEzs0V3IMSuKGoLpy2/LAXVAY/2KFjo66G0=;
	b=SQL3us+nHv2iY77rLtpxNv3TvsI7Mw5nf88ltRAt8KtGSWnM25i8WCeC42sIrKRMAG/uyq
	nQjfVmb+1kCqRS3AzF7vrSF1oT6kV1dGTWDSzd+S3NdhtXvmgb00hM/kaoIXt4NuSyV2/N
	Erh0ASRfCAygtjnqnTmc02MPx/ZztTM=
Date: Sat, 24 Jan 2026 00:32:30 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v5 4/5] mm: khugepaged: skip lazy-free folios
Content-Language: en-US
To: Vernon Yang <vernon2gm@gmail.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 david@kernel.org, Vernon Yang <yanglincheng@kylinos.cn>,
 akpm@linux-foundation.org
References: <20260123082232.16413-1-vernon2gm@gmail.com>
 <20260123082232.16413-5-vernon2gm@gmail.com>
 <5820b1e9-3c45-432c-84aa-638cf92fd240@linux.dev>
 <CACZaFFPCZfxG+FK9rrefFi1UmtWxiOf2j6KXx+9JDJfcHBz8ww@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CACZaFFPCZfxG+FK9rrefFi1UmtWxiOf2j6KXx+9JDJfcHBz8ww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 13D36A000D
X-Stat-Signature: 75sh4kky9oorxqey6arhj8ghegzeyps3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769185958-882312
X-HE-Meta: U2FsdGVkX1+yNylKMJOrkm2bOJcgaGk4YjsPMDhzGxn0G71Q0Ha/q6u6Y8NA4Pm/S97C0O4+99hhX3phTXJOhKMhD8D59cpx7XimDTJja65PxA+rAqOkozXBHuii5cwoK4SU4FdeuROD44GwhHLZ7/Ko1a6axw3znimcKaYzdkSoIYmdM9SHMXQbyB1hW0U1uvsMtneKlzBQxne/2hZ7B70I8ky/O3klw/heQfSxpC5TdKgqFGFMsSuOqyJKbrPyC3XOvaAYS8AtupnET2BGO2qFO1OSHKlViCdm8VAnPOSfC3R9vI7fqKsRd+1/3kUGXm7dVrHK2kRoSpCjdJuZO42Q2lDdG+E6BC7oUxD/Fhu7teQYpENqQC84SjfB6rVnDhLvC84cYlFwsu6S7e0RvcNBQibWMVFtH7p/pm1uDY74BTp3V/5lzjHxQ4fFDFfH98TgYyMZ9g5KHB18ehcxDragwtHUEpWJPgXJMYhliNGvUdn9ll7xWvGAjKBEyLkyL5RutV/n5uxawjelWw4OzlXGY1SmJ3xWZmfJJBcLk710EZJYFr3acYpkPCta7HArtO8Jz7raOYZCKWRH5HKKBR0jiqoHkN1JvnfYzB+8rFvTP8sPB7YkxxbvlNTVfR4CxFVj2eY62Shry2LURusfinzptHKQZRoc3Dof9zyiLTuvwmTNVa9o+4nQtr7h1EZlXGrW8yhUaquHnJjtdl+MBIjNYYp3feAZt2OLRf74dvTm5xeelg6eKH6zgxrEGlb2zmzCiPLcInWlUu6e3oklbujRWUxZvZVuWafCPzGNP5w4j/kLNaGMWdR/OpQxTaL1u/SZ5UQ9ACd6Xwe61eufVWtIndNBquxVXsFlVKNsNEkNh7o766EDEEzw+1y20hKm+tTRasP47fJISDsjtv8dvbekKO7HkO1pAp9JpM4zyMNsH0hIyKILv/wCfud0lG8mw/hfsenZ8nCpMd/hZTt
 AQOiJmM4
 uDB2X/dsV8czIbpPJ8cIVs42RhWh76GsRAOxxG4SeOfYSmw/lE2TEqxrGjGkI1P2lHVB0RLzPkaYB+82qzafIvA8u9UoZsON/J/Iddnlem+0kiSm4B08IYSN1SpfoLhIJD98EY23UHXY8na6/U1X8fPtIed3NPxHq3KYy7pREuHecL1Ujr1nn2MI08dlCrG8+ETCCegXzuxN34kAE7YGQkAjYJhCnzPth0V848iHI9R34yRI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/23 23:08, Vernon Yang wrote:
> On Fri, Jan 23, 2026 at 5:09 PM Lance Yang <lance.yang@linux.dev> wrote:
>>
>> On 2026/1/23 16:22, Vernon Yang wrote:
>>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>>

[...]

>>> @@ -583,6 +584,11 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>                folio = page_folio(page);
>>>                VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>>>
>>> +             if (!pte_dirty(pteval) && folio_test_lazyfree(folio)) {
>>
>> I'm wondering if we need "cc->is_khugepaged &&" as well here?
>>
>> We should allow users to enforce collapse via the madvise_collapse()
>> path even if pages are marked lazyfree, IMHO.
> 
> $ man madvise
> MADV_COLLAPSE
>          Perform a best-effort synchronous collapse of the native pages
>          mapped by the memory range into Transparent Huge Pages (THPs).
> 
> The semantics of MADV_COLLAPSE are best-effort and do not imply to enforce
> collapsing, so we don't need "cc->is_khugepaged" here.
> 
> We can imagine that if a user simultaneously uses MADV_FREE and
> MADV_COLLAPSE, it indicates a misunderstanding of their semantics.
> As the kernel, we need to safeguard the baseline.

No. Afraid I don't think so.

To be clear, what I meant by "enforce":

Yep, MADV_COLLAPSE is best-effort - it can fail. But when users
call MADV_COLLAPSE, they're explicitly asking for collapse.

Compared to khugepaged just scanning around, that's already "enforce"
- users are actively requesting it, not passively waiting for.

Note that you're *breaking* userspace. Users would not be able
to collapse the range where there are any lazyfree pages anymore,
even when they explicitly call MADV_COLLAPSE.

For khugepaged, skipping lazyfree makes sense.

> 
>>> +                     result = SCAN_PAGE_LAZYFREE;
>>> +                     goto out;
>>> +             }
>>> +
>>>                /* See hpage_collapse_scan_pmd(). */
>>>                if (folio_maybe_mapped_shared(folio)) {
>>>                        ++shared;
>>> @@ -1330,6 +1336,11 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>                }
>>>                folio = page_folio(page);
>>>
>>> +             if (!pte_dirty(pteval) && folio_test_lazyfree(folio)) {
>>
>> Ditto.
>>
>>> +                     result = SCAN_PAGE_LAZYFREE;
>>> +                     goto out_unmap;
>>> +             }
>>> +
>>>                if (!folio_test_anon(folio)) {
>>>                        result = SCAN_PAGE_ANON;
>>>                        goto out_unmap;
>>


