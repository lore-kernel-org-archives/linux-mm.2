Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B930BD715C7
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 06:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8376B0591; Sat, 24 Jan 2026 01:48:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3762C6B0592; Sat, 24 Jan 2026 01:48:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3856B0593; Sat, 24 Jan 2026 01:48:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 176906B0591
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 01:48:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6515D287E
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 06:48:31 +0000 (UTC)
X-FDA: 84365928822.27.98A967F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7CF4840002
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 06:48:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769237310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RIm5E9EgCc+JEZgiZ0Tyy8uFNA5t3nrMzHD4vMOa+14=;
	b=MkYKkzKyIxQuzPBmgwSkUwU3be2dN2rUKYSPoV8zx8o3GuWN251vu7cUt1M54jQ74dnnrw
	k7xW0l14bsGbIz+Ue1uAVb5B1nwmcRqV5b+9gaOSbNHYxCIzzo99+i/iwLOouhsxt4CAMJ
	cJBmB2TFpwf7eJRtXQo8gP68cIbPrgA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769237310; a=rsa-sha256;
	cv=none;
	b=HHkIL9PuP0p8QZwbaZah+i9saman7K5QfFupE/+NipoYFGvYnVxVvovsmjwg9NCunsJSeH
	+p8glI6LM1Qd+PGhJsYkO2uOnNC53Xx6+omms3bGFFZ/GCVXMJw/rmHeB5PFHTofN47r91
	5z2W+yStPh6MxQw7mBUK/iKboe7d6v4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8818C1476;
	Fri, 23 Jan 2026 22:48:21 -0800 (PST)
Received: from [10.164.10.250] (unknown [10.164.10.250])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1294C3F73F;
	Fri, 23 Jan 2026 22:48:24 -0800 (PST)
Message-ID: <18e34ad4-82b1-42c3-b01d-ac6e5330c4e0@arm.com>
Date: Sat, 24 Jan 2026 12:18:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v5 4/5] mm: khugepaged: skip lazy-free folios
To: Vernon Yang <vernon2gm@gmail.com>, david@kernel.org,
 Lance Yang <lance.yang@linux.dev>, baohua@kernel.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>,
 akpm@linux-foundation.org
References: <20260123082232.16413-1-vernon2gm@gmail.com>
 <20260123082232.16413-5-vernon2gm@gmail.com>
 <5820b1e9-3c45-432c-84aa-638cf92fd240@linux.dev>
 <CACZaFFPCZfxG+FK9rrefFi1UmtWxiOf2j6KXx+9JDJfcHBz8ww@mail.gmail.com>
 <8fb6cba3-681a-4e63-9409-d35ab628d42c@linux.dev>
 <CACZaFFNY8+UKLzBGnmB3ij9amzBdKJgytcSNtA8fLCake8Ua=A@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CACZaFFNY8+UKLzBGnmB3ij9amzBdKJgytcSNtA8fLCake8Ua=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: nh7kymubuf37f46br6nn1fqkhuaacsz6
X-Rspamd-Queue-Id: 7CF4840002
X-Rspam-User: 
X-HE-Tag: 1769237309-375264
X-HE-Meta: U2FsdGVkX19CcOeAtmYUtaR/AmVnPvtZWJyxLCHlyGuvRWuAlGCnMXCe+3FtcFAvyhzi9j42CI4p3x3Xr/cUBLVVXcI/9A/PF0N/rIkj4CjTnq9c5IlaLxDKIN6WkDy5KwubS/J9IdoCOdGRRm83WodKU5vrBrafV1hyJhvX1IF1UX9NqWIUgI82eXKvNiiBfr8IxzWzvulFfv6p/Kx2jiWoES64dyfwB3LrtNlHC9jMCfn85DIx4yh/JtzwHYGsk2T3vJ5scQpDaJiKxSSUMzRuwztxlXWQKkYMa59zvfE4Y9O+mFZHym/dqlsON/f5TJLd8Sfnn9mB6YE/jdD43as5LktxUYZeR4PqdRfA+Q1eXDKuOR/Zrgkjye8XdxIdPp1vU2EyWo0oWA3mNJR+VhjxgYgtw1ikztB+pdBS3tXqQN5fzddyanBTe1ne+1/NZMVMbcg1NkZ49MdPv1MEl1bGx2dDsFkNTBWBY4AWfzY17pkkQECo9+2iwTU8C8lkiW+u1xrs2DxIwbQm1c/XA7YtqqyaYwbsIUma8VsjgiCQcQ8Quz3Y2yA0STuQPIXb/mA2RAwDxVq8oGpsixt3pegWZjouAPiB9w/0hibi7BzhSrVDtbgoZUvTx/Swd8VSRbeaSl7vdLfbEs7VHER1JCocItdBI81unHeCySmdfIDTYdMpJdlBWMW5Cajo0E95R7wtHGQBTS7ZKgP3K1z3Mu7tKWn376BRYPQHa6cBnr7l6ge70/sS9ZdrjrtL5KD1JnwmtEvQBdYSqXvoJBSK7bKIiLB5DscR0nAbeaZr57LU782ArN5cj0JalDFVfPiAOiAfNPBKNaH/wzGLSuN/y/F/PGe9KPvZybL7f9rmMEQQ1xrd91pQ86gpImoSdxW1iTxo9HEz3KNz9ZJo76pC7SM1l9iqC3KMTlKmDH6PIi/+GPffdjgwnVjD8rN9HNqoUQtR97o1fE/wDwkBsEc
 AeKK4RCr
 7sEgPxCvPVkIYikxJ1EgwAaqapr+F86/410BBzgald1z5V26rqmqGwCQ3+tnLUwqGU2avpWf1yWXCAUD3Cm/KZTcE0JwqSylAi8zdwGQrQWNiBRtK0hMrN8+jCHTx6PYQPnFUKIyFbNAw7LbStffv8MqvRVYvI+3o0XUgb2UvMrF5hmI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 24/01/26 8:52 am, Vernon Yang wrote:
> On Sat, Jan 24, 2026 at 12:32 AM Lance Yang <lance.yang@linux.dev> wrote:
>> On 2026/1/23 23:08, Vernon Yang wrote:
>>> On Fri, Jan 23, 2026 at 5:09 PM Lance Yang <lance.yang@linux.dev> wrote:
>>>> On 2026/1/23 16:22, Vernon Yang wrote:
>>>>> From: Vernon Yang <yanglincheng@kylinos.cn>
>>>>>
>> [...]
>>
>>>>> @@ -583,6 +584,11 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>>>                folio = page_folio(page);
>>>>>                VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>>>>>
>>>>> +             if (!pte_dirty(pteval) && folio_test_lazyfree(folio)) {
>>>> I'm wondering if we need "cc->is_khugepaged &&" as well here?
>>>>
>>>> We should allow users to enforce collapse via the madvise_collapse()
>>>> path even if pages are marked lazyfree, IMHO.
>>> $ man madvise
>>> MADV_COLLAPSE
>>>          Perform a best-effort synchronous collapse of the native pages
>>>          mapped by the memory range into Transparent Huge Pages (THPs).
>>>
>>> The semantics of MADV_COLLAPSE are best-effort and do not imply to enforce
>>> collapsing, so we don't need "cc->is_khugepaged" here.
>>>
>>> We can imagine that if a user simultaneously uses MADV_FREE and
>>> MADV_COLLAPSE, it indicates a misunderstanding of their semantics.
>>> As the kernel, we need to safeguard the baseline.
>> No. Afraid I don't think so.
>>
>> To be clear, what I meant by "enforce":
>>
>> Yep, MADV_COLLAPSE is best-effort - it can fail. But when users
>> call MADV_COLLAPSE, they're explicitly asking for collapse.
>>
>> Compared to khugepaged just scanning around, that's already "enforce"
>> - users are actively requesting it, not passively waiting for.
>>
>> Note that you're *breaking* userspace. Users would not be able
>> to collapse the range where there are any lazyfree pages anymore,
>> even when they explicitly call MADV_COLLAPSE.
>>
>> For khugepaged, skipping lazyfree makes sense.
> I got your meaning, this is equivalent to two questions:
>
> 1. Does the semantics of best-effort imply any "enforce" meaning?
> 2. When madvise(MADV_FREE| MADV_COLLAPSE), do we want to collapse
>    lazyfree folios?
>
> This is a semantic warning, and I'd like to hear others' opinions.

Lance is right. When user does MADV_COLLAPSE, kernel needs to try its
best to collapse. It may not be in the best interest of the user to
do MADV_FREE then MADV_COLLAPSE, but that is something the user has
to fix - kernel does not need to think about it.

Regarding "best-effort", it is best-effort in the sense that, the
madvise(MADV_COLLAPSE) is a syscall needed not for correctness,
but for optimization purposes. So it is not the end of the world
if the syscall fails. But, since the user has decided to do an
expensive operation (syscall), kernel needs to try harder to
make sure those CPU cycles weren't a waste.

>
>>>>> +                     result = SCAN_PAGE_LAZYFREE;
>>>>> +                     goto out;
>>>>> +             }
>>>>> +
>>>>>                /* See hpage_collapse_scan_pmd(). */
>>>>>                if (folio_maybe_mapped_shared(folio)) {
>>>>>                        ++shared;
>>>>> @@ -1330,6 +1336,11 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>>                }
>>>>>                folio = page_folio(page);
>>>>>
>>>>> +             if (!pte_dirty(pteval) && folio_test_lazyfree(folio)) {
>>>> Ditto.
>>>>
>>>>> +                     result = SCAN_PAGE_LAZYFREE;
>>>>> +                     goto out_unmap;
>>>>> +             }
>>>>> +
>>>>>                if (!folio_test_anon(folio)) {
>>>>>                        result = SCAN_PAGE_ANON;
>>>>>                        goto out_unmap;

