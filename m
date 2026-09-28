Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A788AC9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DF746B00AA; Mon, 28 Sep 2026 08:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9903A6B00AB; Mon, 28 Sep 2026 08:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831D06B00AC; Mon, 28 Sep 2026 08:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F0E16B00AA
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:09:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8A911401CC
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:09:00 +0000 (UTC)
X-FDA: 85263050040.08.EC12E41
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 237DA40006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:08:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DK/DhmZE";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flBS/IV2cTEEpYFIE9hkK0/gJv363zv18xBTvbduC1Q=;
	b=i9cRTILIh/pWosTBGXaaLZtNpajFmPM6iPkkSyDtqefuPtscu7UAX/uWaoUxE/SkTJGWRY
	0az16tGn/W75nv+cbjHHWNAElDW0pY1yQzG9cqn7Mxy1oXH22O55YdehnIvNHBM4gkRdRq
	iPD2AdhjM1fi/5V7uE2jp2G3SiVK1tQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597339;
	b=1is5msF6aK1S2kBOwmvpKdYkSLWRcWfKRPTKAxbmzGtTNszVv6mIJzmddEKMMUDKDjShaJ
	1f9A7nQWFQTt2KFoMd2hKrndfLIYCHlWrp0Ww0VckkIXYulD5T+RS1T0XQtBWjiECDLV0F
	WRyAFq7Tn0Qh8YL0owZ/fv/CdH36mZc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DK/DhmZE";
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3FF960052;
	Mon, 28 Sep 2026 12:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7CE1F000FF;
	Mon, 28 Sep 2026 12:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790597338;
	bh=flBS/IV2cTEEpYFIE9hkK0/gJv363zv18xBTvbduC1Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DK/DhmZE5PxjjfiTysNrAMQsD0tPfbAlK4N0oGiIoKpm38aVEaVy4jAC1Y+K6ec4O
	 IHihgKxwhcgEQbMwynntS1fJakS8jaWRXcnkQ6ZPuWLd9u1hAHxvQ/ohwFAkbdRlY/
	 rwgISzCsiwPvL9fX/0Dvrq9/ZLHGjgYxVIN2OzWRbioTSr3hjdaoaL3Yu6xvbcyGDS
	 oLJhM7NBnxMup0u+/pPwdJzHPb19xd05lEGC/VIZzLlMnYyowqUgQvss4lUJre4ZW7
	 oHiDaBdfqwJUfUjnKUNON2bn+UlTXjhpRRR8qBxzHlZxV74PLDGNsaTSkWP6cx46iO
	 usPjeC9PiMZrQ==
Message-ID: <ae606df5-7d14-47b4-8569-fe47321bfac7@kernel.org>
Date: Mon, 28 Sep 2026 14:08:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: check MREMAP_DONTUNMAP mlock accounting
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260928111055.482136-1-azpijr@gmail.com>
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
In-Reply-To: <20260928111055.482136-1-azpijr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: t5boucjsyqeto1qmogpwgzrzahm19xij
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 237DA40006
X-HE-Tag: 1790597339-312334
X-HE-Meta: U2FsdGVkX187MYYTbVUSqskO7pfbu89mZIdm2VauVa5YvuATY//csSP8VHQnGnyj143WTZN+ROO21pZ/Stl9WMSQSBxbANGxKN6iGAs1HB5W/zvgLS3s33811ne2o5G/B5LK9oSICLltS1/H53a/xA7IqDE3o1hgTUzx0dApnWdmczDr/UnXlvfdqb7M0oLjYlEBgFxBhOY0sQQJ/Z0txQOejHEujn6PyNERIbb21VwNhNl0WoqKLMCS20x3n7ox4B1zQKboPi+Z0v97PKgwYO/idYrBP/3Uf4/Tw6nTranhCda9685kWSAOSZHP7gzeN12eQ2aXXRE6+4mAg0hb24qIluWw9ad4OAvPqnRIR2XvNAsJp3ZwIe8quiIbeUV01Co45TxlAdv7TerlpwmTm63wnQTl0xVA6j+sJIb8q3pLDV3hzcFT89EKIn5NN0RAW3kTu7aGRY4HlwYG3aUB45AE+yoc5kJk3Q5xQpczp3yqifeERoAorgrfb4LfPp5KeTwkiGxJZput6HabJ/jDyaWAeXjuq1rpxbeukmvjDUbfC1bGKepMD7xXJQaEHmGZgHMSRD4QmHC9IxIrpS8oQzKUpesdctRYB7+Jki34P2W877atbLKMQDuqLGZGznlyg/ksIKV2bx2X+8cTOnJxsgkQ0Br13dhdCfiUFSPFOjLdVzth52KbqBJPWY+dn2rEkL/GrArxYn/s2o5ZmHIcbccMV++CeN3at1WpC4mAWhFU7vRfdURNYfJfSnj5rpEn/5RM0t59FMyN/AcI6M7CHbkYStb18qvv42CpBajoGDizkImRebrJBB0mO3kviHqfbir+8GG/uB25xos9ouq7HbsRPLlTzVhE9mQDBL/BbWedKNvR3q8rq2S/DzF0DA9HiuhRxLO1e6uLCqEYa/Hyx9UwQWqMA4W489LHWGBZjAUjUSlqan1cjhQmyUMo8bXcAAPWPCZAvDf6by5KcLq
 fHqhbceX
 voRbN2+UIlhfdVZpVMEc4X8suozbOuEe91vwlucAjanB/enKilxTM+FAQSOXspSEJM/A5kmXFoTUkOdL+wVXgPvp9E/2hJJhkd2/hcB+3CHZdNo8r4aIKmF6PviXi3bvwELMKdkdSN+FQWXiDfnp7fck6zCqOCWE+eCMmeNjFAMJAjdSfgPNxzHtC7jNZRq58wnV6FUzOv/GLlgyX2lXkJeci2CecuK/G0GqDbdl03USlmUeD29vOZCzCzYfljXZqBKIt05XTemh034fImNyEKlKDJlqh8gvk89c8lcwjYrE0edurcoOyejZfK89LguQrM8LHhlrh9MO22co=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 13:10, Jose A. Perez de Azpillaga wrote:
> MREMAP_DONTUNMAP keeps the source VMA in place, but clears its mlock flags
> for the whole VMA while setting them on the destination VMA.  Two cases
> leak mm->locked_vm as a result:
> 
>  - an unfaulted mlock-on-fault VMA moved behind itself self-merges, so the
>    single resulting VMA loses the flags without the accounting being
>    dropped;
> 
>  - a partial mremap() moves only part of the range, leaving the pages which
>    are not moved accounted as locked in a VMA whose flags were cleared.
> 
> Add three cases to the MREMAP_DONTUNMAP selftest which mlock() the source
> VMA, with and without MLOCK_ONFAULT, perform the operation and check that
> VmLck comes back to zero once everything is unmapped.  Each case runs in
> its own process, so it starts from a clean mm with VmLck at zero and a
> failure cannot propagate to the cases which follow.
> 
> Verified on x86_64: the three cases fail on v7.3-rc5 and pass on
> mm-unstable with the fixes from the "mm/mremap: fix two issues with
> MREMAP_DONTUNMAP" series applied.
> 
> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> ---
>  tools/testing/selftests/mm/mremap_dontunmap.c | 273 +++++++++++++++++-

@Lorenzo, could something like this also be implemented (maybe with less churn)
in the vma.c selftests?

-- 
Cheers,

David

