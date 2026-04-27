Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34093FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724626B008A; Mon, 27 Apr 2026 07:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D54B6B008C; Mon, 27 Apr 2026 07:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4806B0092; Mon, 27 Apr 2026 07:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 41EE76B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:39:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 025E41A0168
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:39:27 +0000 (UTC)
X-FDA: 84704140416.24.98B3FE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id F38A21C0004
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:39:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MKo0bjg1;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777289966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cmXNX0QNd3YjmZE3ijIpYlhhcL2JDLsFLu0nEp+pFLo=;
	b=gOI4h9ZDcpM1ojWJBf3wWSJHMxzRZmaB7C2fiXspF+r3BDUwHZ6HUnYXcH74DziKkyqqRC
	kxsA1nBa76aRKfv4nOkqGM3BzoVVBgZa7AP+J1opWuxnWk1zVIOPNyT16+z24QmBlBf+S/
	nb0o5+EqssleG5bCfpMhilA6zCFahiQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MKo0bjg1;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777289966; a=rsa-sha256;
	cv=none;
	b=suBftS/o/kjIDLyEwql1KLqEN0DTCmKYQ54JZGrtlRvGT+zNxNLs9mTLPddXXEm/NiVzzs
	zo/zKah9Fw36FLQ/pi+35kmr1kzMh0gETFXSEl3v5DoolkC6gs/Mkr2ToxN5MccEJCB0Cp
	eqDIA4JtOwhPNZU1mpSnk89UO4/2YDQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1941F40DEE;
	Mon, 27 Apr 2026 11:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A3BC19425;
	Mon, 27 Apr 2026 11:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777289964;
	bh=5p/+BJw364LpBg2TW5B7Hb/TLyJRCIFAcAv/CoEAiC4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MKo0bjg1kFuTImzP+X9JZ7jTXfrIDV8HBEDsocf4wcyVyL/T2swotqNw0+zmOOOm+
	 fh0QUwcusXnwMZZqxSDTZohj/qSw5QKEDGp3SwlOCyagvHishSDJ+/WB1zm83l1aap
	 iNSaUQJALajTDYeULElowTiTtaeVCrjL+eLHyklWy9REKT2hGyys1jFclYkR0Vx61v
	 xVSCmGX7A0rZwU+yTMyHKGoNaDC/sTVxFjogaGcKMAtAzFX+mXEUpo5ykrCl+3tQQk
	 gHYZOzmUWwOt9I52UPiCAvR04DW3gTGgl18XvXUvNe8clR469jqUe5iUlmNLrKGa6U
	 KPWRR7q2HJWCA==
Message-ID: <f4fd0c56-6541-4cc5-9b7e-d4fdc5eb4f5b@kernel.org>
Date: Mon, 27 Apr 2026 13:39:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm_types: remove references to s390 gmap
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: linux-mm@kvack.org, linux-m68k@lists.linux-m68k.org,
 Geert Uytterhoeven <geert@linux-m68k.org>
References: <20260427105810.23761-1-pbonzini@redhat.com>
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
In-Reply-To: <20260427105810.23761-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F38A21C0004
X-Stat-Signature: srqsen8qpxjogq4ksmg3ca3gxuijisoe
X-HE-Tag: 1777289965-697313
X-HE-Meta: U2FsdGVkX19MQNa4sAl386NOvMqY3h/5Yf17R/kKOGHwoCV7yz1i5o3iTJfVf95hXaEhgWhsdUDWYM5cBmOhwCj68YP4kkoWEhHZC7X+MmywIK1GozfC1wmxYF+yyWw4UZf8CaLh8dA0pcuYSA7GNVso/LjTxp+3Q4khqaR3VHJ7/vvbMyWLMECYHten0pjdbuP1VeAKzvpM5UDq7qB/uBLgnLrIZUrEYa8WxgFYwydGcNoYXer9geEZCWzT6cRrN4V0qQeuSTzuceXrul5lou15t9S3krq0yTzAVcym3dZob9TYjdHtbokLJYqqNIExJCZLUBV0E+yx/ThMYoeiEo2erae7ApZEK1YnHlDr5w8TXR+/zS/DrTM9cmGgTuNXARL/t9lefN/rL7akf8YdiH9506p47a3rAEWe8rCuD0ZQxmW9wmmHNyFWiuOb+on+Qf/dPIDn7eVgNHe6gg6Mng4mD1vs8onykGOIm21e/EE/ax5DUJPTn9uUanVsEzZ9ZYu8ZQnJrP0nOIN/+IqYEQAL7V2Cy8yhtoUbyTWoexr5lrvIvliKdUU/cES6MazRV2U1oadqV/e7lMDHwAaWlg8qzGDxR+PV4A87EW9p/ZiLR7wXFo9aZI+sI2BRrlOaF0yFNMoEKkvIxdS4kUIBOoFxy9OTWwsA5QjjtJJKL2fY5z0nhdAsMZilMUwQLKhuj2HksZS422+AxuxHWkjDN03R4juFVb6yLj21yCZ1HcAZACjNY737XDNjJKaSez06kJQjWtc4T0pIez0f/oyjS6VGnYof6FEvjFVo4IJkFFqavVlCTznkX4y0a/kRwDrWEVlFnt/hKdIkDBpBNh2GZu18WD1az64WpISYeTpuvCOPVJFW/kRzW7iNILizGf+fqOT3C9e2T6WiMrO2vfPLoP+VbtOKQavYzqi6QiwTYux0+Hb4dz4Y/AKqtF8kpZjNPGQeEv4HykFdR+wGz9e
 QUOiQLIS
 Lim5wfl6hpLhmfmSvhvRTfyqwB/8rYAN+0taXynGeVK9WlF0KW4iYiSxcfP5cX2U19KpoPKe6WFGRsjvG3WLalHx5uQhjysA75OMtI9ynEeW+qHMThhlDcMrGBB/8ExLVfBF0LEJmOIs8H/Dlciym3LELKsoN50NiVbG1f73KKjXR0bFb2vGEQE7NyOpq0c97izMG89z9Tv//BWRiO+AGB9gCZ2Nr2577ODK0JJB1p85i9IRufED7T4zozh6wPTiE67r0baAAOoeJgI6+1khC1FYPHeBZ9DVWK2NNnNP/Mib0NoV+DhcXB0dahX3AGEh+0+AB1rNOukO7RNUcPeIpCtuWhxse61mjY+itKaHrfM8VRJxrtAWI0LMg3pb6QtRWogIc8+LWXrJdrKbYG2GJF/kSqSReDg3uiDJMC3Akub7FoZwHUQgixs6GXTJeyEerMDHB8O9lsSYBPJN8YkNSJtsygQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 12:58, Paolo Bonzini wrote:
> s390 does not anymore use special struct page for its shadow page tables.
> The honor of giving a special meaning to pt_index is now m68k's, so
> rename the fields and adjust them for the desired type.
> 
> Cc: linux-mm@kvack.org
> Cc: linux-m68k@lists.linux-m68k.org
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

