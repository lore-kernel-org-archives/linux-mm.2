Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C71A7CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 07:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B73036B0088; Thu,  1 Oct 2026 03:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFCCF6B008A; Thu,  1 Oct 2026 03:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12BB6B0093; Thu,  1 Oct 2026 03:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76B776B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 03:08:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8C3780331
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:08:45 +0000 (UTC)
X-FDA: 85273179810.27.6DE9CAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0AC3D140004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:08:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wuzhray8;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790838524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvSYXYalm63CDGUp0iUMo4KFN4PdB/yvny+LMXqSogI=;
	b=WoOul7MH20qOc1nN8otSZ/CxPVSD8Cm3xqXB89J50QttglGC4B2WYvIYBX5S4e41wHYxuo
	gGA6b3Nd0oUgoDoj/YY5XQItMADhQRS7vrFGjddarJwNSWkp0TKZ6SKmX7JtVpPDSzEned
	T6MiUSBg+PDRRZSuC36f8d78CFHRJDY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790838524;
	b=Ynb4b1AeVGgpp31i+xeo40zDH/pwaTRMI9BHCI+9QdJI6TZC5JdKYFcbxZW6iMo1Manpb2
	nwKVvqAswh/GKb2qj1QvlbyeusVJI82XLumWaaj7FYqsD/+VnrEbMI6vUhDzTQTqCi8KpN
	pmEocD1eBvf33JJXvHM+5ID8CTFa7Ds=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wuzhray8;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AB8C400A2;
	Thu,  1 Oct 2026 07:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299501F000FF;
	Thu,  1 Oct 2026 07:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790838523;
	bh=FvSYXYalm63CDGUp0iUMo4KFN4PdB/yvny+LMXqSogI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Wuzhray8wlCI4wK6CdYNATgeXQk1B1+6oDPjXFB6wgag6e8Zyayeenn0GpvbleIN6
	 B9WaFzIZYilGEIPzM/fGe96QLu3nOblllzyhAslnrLWKR1kKbm9zArBR+ZI9Uq7evp
	 f3grQzKvpQOqytiQ1J1wxObVg0HL4fxsheS86h8oZHU74sJLvOqgA1czZSBjeryb0K
	 wYDPXcy+jDX9rjw0WDm7FOYEyxhOUdfAVX+aNDl5+PCNmL+eUzqR7LLvaO4FDlxcR7
	 0fGkKvwEi7wQyYZb83GPZcRmYJ8aSa2TA0A3PU1BBnjQfUk2tibb4v1VNn+c2A4ER+
	 os8O7YULYHA/w==
Message-ID: <bda5eeaa-7868-4d4a-9026-9e99347afd7c@kernel.org>
Date: Thu, 1 Oct 2026 09:08:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] selftests: run tests on nommu architecture
To: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org,
 liam@infradead.org, rbm@suse.com, akpm@linux-foundation.org,
 luto@amacapital.net, brendan.jackman@linux.dev, liuhangbin@gmail.com,
 corbet@lwn.net, kees@kernel.org, ljs@kernel.org, broonie@kernel.org,
 mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org
Cc: geert@linux-m68k.org, daniel@thingy.jp
References: <20260929235711.2287931-1-thehajime@gmail.com>
 <20260929235711.2287931-2-thehajime@gmail.com>
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
In-Reply-To: <20260929235711.2287931-2-thehajime@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0AC3D140004
X-Stat-Signature: pugez61ojmjr77epuqjzhu95n9urg9ad
X-Rspam-User: 
X-HE-Tag: 1790838523-640570
X-HE-Meta: U2FsdGVkX1+WYbmSIpPp8swciGdrnCOksd9ztHV4c9P/R2pu+q14HmeZXNlxkn2Zu2draj8UtMP/A6wk5ahznt+/DA+BIDrZtfnAO8ltaCFa+6jdzeNgp7pU7ygymq1Le7bIaOdPBvu8H//yTIdSv4ZeHdr1QpvV/EJS9hXNreOfH5jdrqtDV3OouHyEgiD+R0QQZZIkDGClmodG5P+JSiUJaaYaABktG+Oz4QRWpI2j2QuF1sEergr6V4Fq4Dj1oPtkYK6NLxB4DwlLKK4oGCTM7o4q3V2N5LdZJ9CEkCLIB7O2n7eTL3iFJScHgGSa/dICd//mQ46MVTyWp7Dy3VBJsFfhhqMDIfsP/+Yk6cdUjCNcJGM+olMclzmr0D3OHum/CgkrCbvJdymdtFgemgz04NG+JLKN6DrT/zoQa4TG05Q9RSNJ3sav7xXHDar4Zvap2NA8a9oNndmt4xCEBIc/ZfA8LUA3z9cHYsgFS49SVYqV+0I/bUg3b81Ks74iy20bMSVxqbDKlm18AH7KFgvKQCTS74VeYYGhcWPvkrKlD9zxF+QghBTudkG0QqwoZnqP59+3vRlB1SwbWohQY6vBfKOO8Nqgr0fURUMA3ocieMsPEwMILsPD490dvaxjLPBZp2daN2XDMZJt9Duc9PyHaLhPVK2aAy3VRfAobzLXnYzfJv62Fl+JEQfC3wPe5wda4ctQuf6pm4xq6AuGlIcydSh3v0F0N3WxKITAezbDBamfwlZEGJAZXbFTZPIo8xCwsQwN2biKzejTHv0txY1n7lpImUcbj9vrucC79D2VIOhlPOFe/zZ96KWQx8ZzxCBcmZz3gFl8idYZ7m4LSmqBaRLcXDWmLw3owQR0vUrkSoSJ36zNH7G3kd2Y1hoQuYqNzm+eqkk45EfLBBIxr8nc314ZrQ7jnhFrOJ2MzWG3dt3vjWXQiVJ/lU2NWjlmpMKeWE7zLCymtX+JCz/
 yklTVwpu
 ewKNad3uK0HJCZdzyygdQlwWdjpSzQ3ci8MqZWtDmZKntDb7XLjZWsBTDgA9E1K30/PnEri2hf34l1MgCLGRGKyrJ4uxm0719NHp9Sf5VaQRVJXCSdlojO4BYDieqNgTvKaeWcS2M5xVtuTdxXhrz3pF1CKmUAatLn1MW5+70thmWrqumTyi7nB8PCYKc4ii3/9Aoia9ebAmu2GnnMt6HH8ol41ClAZwwdsalCL/zi7VUenuuxsCNFkSl1LHOBRfi3kwB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 01:57, Hajime Tazaki wrote:
> Architectures lacking MMU don't support fork(2) syscall and only
> vfork(2) is available with limitations.  Thus, we cannot run kselftest
> on nommu architecture as is.
> 
> This commit addresses this issue with the following changes:
> 
> - on test run stage, avoid calling timeout command when NOMMU=1 variable
>   added to environmental variable, since timeout command uses fork
>   syscall which nommu platform doesn't support.
> - describe the difference of nommu tests in the document.
> 
> So command line to build/execute tests for nommu should be like below:
> 
>  $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=nommu
>  $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=nommu
>  $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p \
>    -c nommu

Is there a way we could derive that from the environment in one of these cases?

I'd assume once could compile and run the nommu um variant, and within there
simply build the selftests and run them?

-- 
Cheers,

David

