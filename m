Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B345EFD5F8F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 07:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 029A26B0089; Wed,  8 Apr 2026 03:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5E46B008A; Wed,  8 Apr 2026 03:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD9A6B008C; Wed,  8 Apr 2026 03:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5C616B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:39:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58BB7140A55
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:39:50 +0000 (UTC)
X-FDA: 84634589340.29.E7F27CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 73402180009
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:39:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rOqNUi4d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775633988; a=rsa-sha256;
	cv=none;
	b=OxBIw67u+wOSn7xsQxbk+22LEpDxvZcu7km2zpnZWjrBD1uqqsm4ch03g9Hftvufaxud2y
	Drkixgxr4MiDWq/MXAdtu/eutRp0+i4NanOoo7QpdCZzHrbPVTnAup7OgDz42e9yF+Uxk+
	gNSubqYJjTi5CYWF9yVbhB4uFINXVAA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rOqNUi4d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775633988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuJ/5kTSfJV3pXeVXskqH/1yE1cJwc9wVREJXPsF+Ko=;
	b=GKZN/pDJefS3RK7F5tv/ou1bBCdIph6Xz/PfrA9O9P0SzvcInvkbCyglAVBhxSCyOBmemF
	QMSjtQvfftL41NZni3hVZljpMPIHf19LTPEwZVw/+7Xg2kr7Q5ElySnNn9jPVWCtBazToB
	x8CALBVNj4AJizi7MFQS4s1VMFGMJig=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 859D842E55;
	Wed,  8 Apr 2026 07:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A37C19424;
	Wed,  8 Apr 2026 07:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775633987;
	bh=JKML08yy0dGpuo28t9vqJg2KAb5rilg3WmynEttBawc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rOqNUi4dltOXzra1+FgfFkNRd/5pwIsWuJGItMQC259wbE+864o+qSF1LRL5816dM
	 ikBXsGUsokZQLJ6E7R9Y3GsvJzSVmhs9aTNrofH2ZKJlNJXTIu1h95jmSClldMUlir
	 RD6LQLMbiqCCmvXbAo/weSbFXEmgbtiQFqc21/l7MyZm/tp7U55aRx/LOeb00iLMGm
	 dsCttTgICrEcjgmdYn4/P8tr/nQ9CIKcxHRSlvjRHQLs+3aLAUx8Vvz0DRk4KmM9kz
	 fKrho3gfOlCpe4TJogEakgWq3+N2z4raLU7ZKv+Q2nEn1w2SCulHd8bqY0pUV0XK46
	 RjuI3vNqWoSdA==
Message-ID: <efb2dda7-144c-4e00-bd5c-0b57a1244fb1@kernel.org>
Date: Wed, 8 Apr 2026 09:39:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: proc: document ProtectionKey in smaps
To: Kevin Brodsky <kevin.brodsky@arm.com>,
 Randy Dunlap <rdunlap@infradead.org>, Dave Hansen <dave.hansen@intel.com>,
 linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yury Khrustalev <yury.khrustalev@arm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260407125133.564182-1-kevin.brodsky@arm.com>
 <98880cc2-09be-4bd8-b8f4-f0f0845f939e@intel.com>
 <2d2aac86-2780-4a29-9eef-116c26485812@arm.com>
 <18e2042c-d414-40fb-8819-5e930d5b1584@infradead.org>
 <8a5e4afd-cd0a-400a-8624-79c1dc9e3ff3@kernel.org>
 <fee59f61-cf62-4a60-9d8a-4543a02a9c48@arm.com>
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
In-Reply-To: <fee59f61-cf62-4a60-9d8a-4543a02a9c48@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: su3wgimfwjb5i6dpfna4dtstkyb1r47z
X-Rspamd-Queue-Id: 73402180009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775633988-627410
X-HE-Meta: U2FsdGVkX19jPJn+YidvZqMQ5Gwtc3CSGXOhKY9TRzDiFgPswgkToGWZSEGCZx79/fffgy2g8hiD5JscwwIp4eVbWZR5tJM5Ctlx9ERhevhUH5+IZwlXvBlbH0VOeksmhCQrwvdi7HVdVhLnmDT7mKcxqLyJP59cdIF0wKT/b4BYnb9EPZ5PqjdCI9PzOAAk4EvF1CKyjKq2stwrptBouLWLK8y1XW9RqYTO7Rb56FhSY8mTjn7UIwSoe2sdBE9UcTG/+Ny7aFnWsmEG+9lkxve8derwKNXLg9HsUm1GP1Xqtje8K2rpWxdCxqRR10Y8zDJSvCfS1Pr8g2evdl9phd9DP6bt1DzmVya7xyYPXup8pXpGOIWM0yhP3NyBOFpwWJRLZZ/riAC1D+matgIPo2qkPbKD+JjtGmtgk7lnwySwoTuKSsEmdICdGnHzCBKYw2GrcpNvYkowgLqa6TioPxwXp4qx1X7naVnyaBZ3tmKKP61czyrtkPNinRuOXLS3lgGScGMh7cJAfM8oBXq26beKSWPQyFxmqnYLI68MvzFputBmsUXlUxXxt33yZvodbwD2EGkuEtrXANL7ej2KcAziJYoeQQnHHY9dKrPu05nE9BWzxnCEnKD2dZ/+w0NraKZiVj3yu2YjQKGNYb+tvDJ9WDHXCoEZcnnngdN3oLNlDwtRfoqTGdCAHFdP5Qy9SG0Om91m/x6f6o1Tf0C1sVxjjT0oPsfYLD9LMKC2HeDTgJDWIwI7drVwMiM9pMQPQwxPXMnRIM6BmyzpHrsAWYggvEIxMD1k5zsy7b+Yvm9fgpa0fOK455tZvfD87/lp9+ONTEjvwNOFaT0btYzo/wlVWIVCgLjwx/Do/KxT2JItE6SVyHUV1uausNKEvoZ5HEzEnuRowtoabpPshXQS981iZ6qgaGTrWjhaS0nCxetc5votJcp8BhbI9I3nB7bLwP0DpT3uoYtot0oTSfg
 AeYq6nu3
 vtjA9/FB8Q5f2oa2JXl+JwVGtMbZzw62nmslWqWEFO2Y23tjWc2Z9AJGGSeI+zHIRRV5g05U58zTqzVSoXVWPky9zQGYvCQwq4CxMF85Aux93nACDHJ3A36Ty73wQYklKFDjdo9UcsAs9euH3v6KSq5CgCaWYUFOsSPA0tDHxFfKmGCFNXnenI02wH3TrVYLCi0alOXkZvZw1fyTlpU7sOddTN7fKgszxTxsUoZKbbFJ405QS/SL+DLisG3IzR4khB0FJwADHg90mrUknTP81UAQS9NLftaHQD8C1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/8/26 09:15, Kevin Brodsky wrote:
> On 08/04/2026 09:05, David Hildenbrand (Arm) wrote:
>>> I think that "system" is too nebulous there, so I would prefer to see
>>> "hardware" instead.
>> What if you're running in a VM where the feature is hidden ... ?
> 
> Of course that's also possible, "hardware" has to be interpreted in the
> context of virtualisation... But granted it is possible to hide features
> even on the host with the right kernel parameter, on arm64 at least.
> 
> "If the kernel supports protection keys (pkeys) and the hardware feature
> is detected"? Still vague but a little more accurate.

Can we just talk about CPU support, to avoid using "system" or "hardware" ?

-- 
Cheers,

David

