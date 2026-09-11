Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 763B6C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9262B6B0098; Fri, 11 Sep 2026 14:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6DE6B0099; Fri, 11 Sep 2026 14:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6316B009B; Fri, 11 Sep 2026 14:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E78E6B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:16:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3290A42DC
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:16:30 +0000 (UTC)
X-FDA: 85202286540.27.E5C4A23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3302614000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:16:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X99XCYO7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789150589;
	b=dT0rHMoFdW5nLYCEaJ9rQa1bJX4qWP8oH0gUbqqknd4M66zW9Kn5N6EdYDOLlKu+R0i9Nq
	Kkan5PYifrmh+do1kLjksxmsarHE3IM0yKY4zdEQOfi90FKANKDiQxLtzPyKx5gx3/zwmH
	jqJtp4leo8xxCSdXL70lKEP5qeyfaIM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X99XCYO7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789150589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXkt8h/Jok9K7Q3feytS1db7RvHnBcGlzZ45+6I/na4=;
	b=RYLmGz/bqzsfPfGtu1rNlneLS01T09Ikqu8Ab2d3XpkqAyAuIOfvWYmaEuyZfWCmQt6AIr
	j+hpsF/wYP8XECXJ9e/C8ee2BaW8R6qsT+EDICjY50fEC081k8aqnnzaWHvAzAI2u3uy3t
	2UdpQ9JAhTOUazs7R7U8xqpwa7B+cb4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A68D9600AA;
	Fri, 11 Sep 2026 18:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6A81F00898;
	Fri, 11 Sep 2026 18:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789150588;
	bh=pXkt8h/Jok9K7Q3feytS1db7RvHnBcGlzZ45+6I/na4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X99XCYO7J5latPOdtROUfGkWNMIZoKp9nscpYoI4bUZPyx9DTxg99Cd6v1kiNCHYi
	 z/B9/nTxxuFhaNEnIQERpDHVoU9VBn3zqR04M3D61ga4pBpCpNi48pY4OrPl0ZPDq1
	 luBs+w7JZwyu03/ggVvbbW0knu5oiouEX1O6Ij7WjcboyN9tekmeaT5jufsiH004XK
	 2k+ak0Fxj1KN70ahhHBLh+if7rlUrRWJNdN0bUfqNl4yxZwPVi25ClsfxxSAreGdRK
	 AGypfPnMXrYpmlOZEk4fruLO4myYSm9gmCS9eCTYMSH4GUWs+XGV2s03qVJYgRnF5V
	 QrqZ1pi2UTKEA==
Message-ID: <376e2b66-c0f7-4064-8e38-997fad4df5b3@kernel.org>
Date: Fri, 11 Sep 2026 20:16:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/gup_test: safely calculate GUP batch size
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260903115033.162218-1-sarthak.sharma@arm.com>
 <cc0fdb0e-ab6a-4095-b559-10e1d8a616d9@kernel.org_quarantine>
 <366c39ee-d452-4a1c-af0d-2badd4d8210f@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <366c39ee-d452-4a1c-af0d-2badd4d8210f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3302614000D
X-Stat-Signature: 38hncnrts4jgyhze6ap4gm8fjshoezdm
X-HE-Tag: 1789150589-245877
X-HE-Meta: U2FsdGVkX1+H/R2jReGZyJ8k3J/nQK0pLHEbc+O2JI44ZS335WOls9XZ6Ph+n1GLIMPVotMisNTsbigVhRuxZk8e9NdzXJLThUvmnfFIyPyf1eLVm+y8jB8cTYPk7W6rfrRPpmMJrXjWGjAu6MEfLRB9FqCZR+3eYwYf4ETg9UCchyWDCKtIrM4VhYR6MZRKgysxZaF1DRiWd9qqN8DF//i8blPlBNCyXyg5+WehiB27X5oEIxYegWiaOaIwQgAKyKoEObkW/rvvQJxzpBTtrZRTPN/ZlCwz3+sqZRAtAD6ZzV8wk7Y5YJsEyimEuCqaDzIo60dPNPXBtcRFSTMmjvWWwJWa4xvsa+haxsOdekHiffdHBUi6MPVddDQQuukge3lgvyhhiIrOOw5gKL5N9YN38MLOYl8XCkaCOMQPordBbVaexSvrYN70hxH/fkkGCEk28JqubMxSHOt3Iz8tBVE5Kr46YBTxInRQRw/+lsPstApQbjm1BwStisjEIXZxA8/x9C/lBLhaoiLJr4txyOiNtmxILoTpdqoUoqLhje9r4u/DYBlM/SGHtktms4oon5IvpJN8eVfpIZk7SbE+s88E/35nhni5ibdroBlm4WkoCti/E3ftyfVahScCtsjtONqi52dUd08OY6RxQnGtMlQB/jqTJGb/s0ohR7Q6FazvsTB735pwYnRMxvz5yEfKPnd8qjLqA+cfS51xYHOZ56ogw5VpzQh/tFDrBddt7qrW8G4FO9zgPQmVruYc4EtWpqs36zAW8ba3aavfyfXYOSo85R8iJ95Lch99qw2s19H2LiYWknUeSV+AuZzePDrQ7AOS9U5egYU3FXogN7ZfijV0BKC7RC8N3KCzSIcbtVLQkazwRcO3v5+FRGuituGnP2Gu+UmVeowkaIyCCzhdLesFTA7YVm31nQPh6+hgI75aBwQE0tYLt/GHWCzH7B/tuThZq7Rkm9pqt2sTrcU
 ms2XzK7B
 Atp94vdCP1ujLpU2l1861APQiTrm4Eok3DnUOV+lJOy+mXvNH9xjDUAJcOVjksUwxzDZElXDJ6CT0TDEvLiddZOf1Xp9iDcsNMEuiVPiDIaoQ9NiTAX7BCGrusGKL8K5ft8hiRvciWk1zZ3hOdSPr/eY81i1+Pz2uWw5RXHArgAZXBU5lrMlfEqeFktMtlAVrdFjfThqt4pEGbBjHUVPy17OtXP8fnPFPPstZdPOv5Uqsnr3n/mOgo1iLrmRS+h6ZYGVJA6sam4pcRkZeoaMn0rjWF/gdE5DX/i6jcSwWiA3mpYBuIgAzH79vHhKFVbqC+B12ePDiOS4Fcr/kBx5th11UV65+n6s6OgBk6vMt7L3/Hq+Gt+Eb3sd6ykMFFvyYoYmPFt0AODnIo+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 14:13, Sarthak Sharma wrote:
> Hi David!
> 
> On 9/7/26 8:20 PM, David Hildenbrand (Arm) wrote:
>> On 9/3/26 13:50, Sarthak Sharma wrote:
>>> __gup_test_ioctl() calculates the end of a GUP batch using:
>>>
>>> next = addr + nr * PAGE_SIZE;
>>>
>>> If nr is too large, it can cause next to overflow and wrap around.
>>> If it wraps, the next > end check is bypassed and a large value
>>> of nr is passed to the GUP call, even though the pages array was
>>> allocated according to gup->size. This can lead to out of bounds writes.
>>>
>>> Also, when fewer than PAGE_SIZE bytes remain, the calculated batch
>>> contains zero pages. The code still calls GUP functions with pages + i,
>>> which can point past the allocated array.
>>>
>>> Calculate nr by taking the minimum of the number of pages per call and
>>> the pages remaining in the address range. Stop processing when no
>>> pages remain and calculate the end of the batch using this bounded
>>> value of nr.
>>>
>>> Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
>>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>>> ---
>>> Sashiko reported the issue fixed by this patch while reviewing the patch
>>> "mm/gup_test: report actual pinned bytes". That patch has been applied to
>>> mm-new. Since the two fixes are independent, this revision contains
>>> only the GUP batch size fix.
>>>
>>> Changes in v4:
>>> - Simplify batch clamping logic as suggested by Kiryl
>>> - Don't call GUP functions for an empty batch
>>> - Drop the pinned byte reporting patch since it has been applied to mm-new
>>>
>>> v3: https://lore.kernel.org/all/20260901083452.115365-1-sarthak.sharma@arm.com/
>>>
>>>  mm/gup_test.c | 9 +++++----
>>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/gup_test.c b/mm/gup_test.c
>>> index 185ba3bb8ed1..1b64e932c4c5 100644
>>> --- a/mm/gup_test.c
>>> +++ b/mm/gup_test.c
>>> @@ -139,11 +139,12 @@ static int __gup_test_ioctl(unsigned int cmd,
>>>  		if (nr != gup->nr_pages_per_call)
>>>  			break;
>>>  
>>> +		nr = min_t(unsigned long, gup->nr_pages_per_call,
>>> +			   (end - addr) / PAGE_SIZE);
>>> +		if (!nr)
>>> +			break;
>>
>> Can !nr actually happen?
> 
> Yes, it is possible in 2 cases:
> 
> 1. We calculate end as gup->addr + gup->size. So, if gup->size is not
> page aligned, then at some point, we can have (end - addr) < PAGE_SIZE
> and (end != addr). Then (end - addr) / PAGESIZE will be 0. Right now all
> callers seem to provide a page aligned gup->size, but any userspace
> program which can open /sys/kernel/debug/gup_test can provide a non page
> aligned gup->size.

Note that this is a pure testing interface. So we don't care about weird user
space doing stupid things.

Rather reject unaligned gup->size early in __gup_test_ioctl().

> 
> 2. If the userspace supplies nr_pages_per_call = 0 (we never validate
> nr_pages_per_call so it is possible).
> 

Same here, user space won't do that. If you want to be sure, rather reject
exactly that early in __gup_test_ioctl().

Something like

diff --git a/mm/gup_test.c b/mm/gup_test.c
index 185ba3bb8ed10..9e3e1df8dd526 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -116,7 +116,8 @@ static int __gup_test_ioctl(unsigned int cmd,
        bool needs_mmap_lock =
                cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;

-       if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
+       if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX || !gup->size ||
+           !PAGE_ALIGNED(gup->size))
                return -EINVAL;
        if (check_add_overflow((unsigned long)gup->addr,
                               (unsigned long)gup->size, &end))

> Sorry for the delay, your email didn't reach my inbox due to some reason :)

No worries.

-- 
Cheers,

David

