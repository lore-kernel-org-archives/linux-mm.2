Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 834E3103E169
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7F4C6B0197; Wed, 18 Mar 2026 08:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E304E6B0198; Wed, 18 Mar 2026 08:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1EDC6B0199; Wed, 18 Mar 2026 08:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C18B86B0197
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:07:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72632160579
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:07:14 +0000 (UTC)
X-FDA: 84559058388.30.2B2380F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 85E94140012
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:07:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=leByJek7;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773835632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jako9m7ef30u2KIKlYNuTkvtuk1qZaI001IqwwoxZI=;
	b=wsSQ2fxid4NZAX+5r+xtN44YeG4ssdgLnzeqO0ZP/z6/4i86LgdP7j24BQ1t1kgAaYFmfu
	BbyWIRhYL7qukTL8/i9OirPm1ASN/uDh6Pgw8kHpADq2P7AgN0U7zQnZ9Ld6rZcOqVRQ2j
	YfYFcVJiGf/EaFD15flDd+rmVf8nNnI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=leByJek7;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773835632; a=rsa-sha256;
	cv=none;
	b=XIGZ14U16/ULVQWI7PsIcxlL8LkMi8WCsXdRMGIOKNU+cVpRQ7XOqBYg4rY7HWuoxA1gGf
	IH7W7Fb8lsFYTnWHgJ9B5nFM3VmXXIfisBXvX28f5gqudtoucl2lLEhjdGSAd3AsmtnEr2
	L/hvtLZGfivI3A2JVMCTO3ji+RFCOTQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 13D5E40646;
	Wed, 18 Mar 2026 12:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D426FC2BCB3;
	Wed, 18 Mar 2026 12:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773835630;
	bh=Qwy/Zw7mfBZ5j/QG9jUPEflfhiHhV/iYcxuVi6gsuBg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=leByJek7uVZg6cUI421E1qlsRgFu5i1j9Nrcp9TwCu1n/m2wuj0G9A52e2o93gCeH
	 UE8Pm3pCz99lvNY5DqI85yN3uJYOlzA3MSCA7F49p9zmHwWV9oVeNp2NZ1TNGNAfRS
	 oGhFtbj4lm5IYM6RTSEdhV8PdXr6kYryFRfIw7C4fAjIQdQMagG3Z2yZR9xv/SxKwc
	 zK9ZzLYMWbYW2D+n2DghLnEarPNB2t3FbiaIQPvqj5iRhnDXQEt2/q1ki88ccS2Q9s
	 b7uYJ/mi0bRuEp60/+SEKCMz7RW1DeHIkSAEHZKEVgY1R4GQiYyZ8OaOiRipCnMwrN
	 uolUohi6Gzm/A==
Message-ID: <ee3ca88c-d6ea-44cf-8f75-e996d52c4c92@kernel.org>
Date: Wed, 18 Mar 2026 13:07:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] selftests/mm: skip several tests when thp is not
 available
To: Chunyu Hu <chuhu@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
References: <20260317094419.1429259-1-chuhu@redhat.com>
 <20260317113730.45d5cef4ba84be4df631677f@linux-foundation.org>
 <abpu4OMsy3Xl5QA0@gmail.com>
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
In-Reply-To: <abpu4OMsy3Xl5QA0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 85E94140012
X-Stat-Signature: dn5b6q5rd54f3ugb9wka3x1k4p4kn8rt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773835632-348475
X-HE-Meta: U2FsdGVkX1/X0iYMdUFzqxSB12MznEQYKtXCgIA6CL+gXAELiyGOii6EWVxfyE7eKdD2KgpvrawXLZoVDfQft3ubXUGQe3mY3BUiTEe6oLSlfu3S359ZKB9YC4OCTbs7M4iATovHLnfFEsHnbeZDYi7YMb7GBCwdoF5vI6ndwrOewRYRF59TrI1X1Mo+wn4NFHnRfi4IZFmX8k5rxIe1SQdpe5bEuLdFtPmhP9R6AW7SfM6W02sdhF+LR2ldxrUa9/sS6Zn8i9Jkz9xH3djiVPNm2n5RFzQa7ietqEMoor84+Oow7XLudxQqBWhA+kmVV2doqx+xquIP8zQLZDvmpWYlaLt3mNUyanbLa068s3w99RJ/WbxETdQGwHTqOHo4rCXNQJlvSQliuGTf6yOF64t1+Qg6zoMCACBj2/iNuUKjQn12N8Ot4mLkj5nnOkU85ioljfworMQkmg02B07iJt880gjKhbq7PapuMYYo1uxrv6SApJp+1l3FncE88JWUBUzBO6LjaikBqe26YuRHXEeO2d7YegmTRe60VV2z7XjvNIjHiD6buTCB2vlgtm2A0qk/OVYVuerUnYHnE69J2ke36tHa5E7HQ17ZH0eDls1ZKuNKYSmpJayr+6jtTVNWTG4QbAuX1/gJUn6Ri6hHmjnH5kIa+UZHfLLt3aAKG0U0SS4sPkUACLuJEB/ZRjJHoH4BZ8tzx4KUdRb3H/lAgCz9PZ1veUUxyoVT65jP5inrCi0Fcm0oEAngrX63864txOVk1l7EiLaRfcK6SJVlBCcntiIFnZ4OlcUF1A6vA2Qq+HxzPJWsrJqaERG91fbjTn2H3YalyknhZ/fdOtO7s7Qm21A7HWdt4P3OO8FQcORqNeVuO03xZGos9KFPITpoNLFVGVx/XLXTUrCdgpNBAgq4j+EAHE0oz0IaAixuksfSLBhM7NWcH4vD9kCuLFgDsCr6vNWlaAT9YhYAgep
 OJ+c6yUg
 9URVS8k+McqKGqxrwx3zn4fvhZN1IlgI+EJ5ND+fQX7+9DO4codm5x2fY7VxoS0JXZatWHZ0PLqriwzlGZdLzK/5SCjtdarUeNr5XCzIpxKpMNS07afFjv8px6WWAQGZOjKjBwKh2LbdZ1QHFMTWf4M50FY4LBwHvcnyH904x+MsOnVmjQ4niY6WvnK/yivrlgHsfebsnqawBMVZaVsoW36HOeJ/JpFcwS0odlznyS0BsNqkraqEHRXqvIsGvag7DTSMtSNaT0UkHm1wRx9/5BvnOhEixCEf5HlAzzzRWC/weCeRxl5JjIZOXd38ZKbCDOuFPQyu/BKBQ8krQAAExuUWFPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 10:22, Chunyu Hu wrote:
> On Tue, Mar 17, 2026 at 11:37:30AM -0700, Andrew Morton wrote:
>> On Tue, 17 Mar 2026 17:44:14 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
>>
>>> There are several tests requires transprarent hugepages, when run on thp
>>> disabled kernel such as realtime kernel, there will be false negative.
>>> Mark those tests as skip when thp is not available.
>>
>> AI review asked some questions:
>> https://sashiko.dev/#/patchset/20260317094419.1429259-1-chuhu%40redhat.com
> 
> Hi Andrew,
> 
> Nice tool.
>  
> For question one. In guard-region test, collapse tests are for checking
> collapse is denied when operating on guard region, not for checking
> madvise(MADV_COLLAPSE) will fail when thp is setup to 'never with sysfs,
> result is same, but it's a different test. Maybe we don't have strong
> interest to test when thp is set to 'never' in this collapse test.
> Do you perfer we let it run when thp is setup with 'never'?
> 
> For question two. In soft dirty test. Yes, test_mprotect skip logic has
> similar issue when open failed. 'Bail out' would be shown. Maybe we
> do this in other series or you prefer me to fix it in this series?

IMHO, that's something for another series (if at all).

> 
> For question three. Add buffer length check in write_file() helper and
> check if written bytes equal expected bytes. It's easy to add a buffer
> lenghth check and make it robust. It's not easy to do the partial
> written check as that will make the helper more complex and need one
> more parameter as expected written bytes. Maybe for such question, we
> should do with other series, not in this one?

The AI brings up many things that are irrelevant in practice (in
particular for tests). So I wouldn't worry about that. You are only
moving code.

-- 
Cheers,

David

