Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 883E6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6960B6B00A2; Wed,  8 Jul 2026 03:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6454D6B00A3; Wed,  8 Jul 2026 03:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536816B00A4; Wed,  8 Jul 2026 03:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AD7F6B00A2
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:52:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B08824062B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:52:43 +0000 (UTC)
X-FDA: 84964842606.30.B438E4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id EAC1DA0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:52:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FnMLMPl+;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783497162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWtEFlyIBpXMvKiDy1pvoBypm88zNYTkMdGjO/FtoKY=;
	b=QtwHTsb5Pcv4lpYkZKWwZl7vqVPRV0fWFnDPLwkwp741DPzhUJobPlY6BwSShD5bE76Xzz
	YHhGYjQ/Gp/SkFvwzinJ4vM7w+VC4j/Zc4isNRTqY8MjrBDH6T0CJRdQPPHU9wFHUbM0MX
	RXMKBYqv8PiZFeVw+bKCSF5nFFjgtcE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783497162;
	b=HvgvmudswFDwaJv9W5CK7gU+GTIULhm6eOmhM8Ck163973NKwuK0QlnY+iKVHzIfe/QBGG
	iGw9q9tarh5lBlRMHmRgIneyIdPKfiKgIkBt0Z2/UQkLN7eadPpSmsqFL01qX+aj55mNOv
	hZtL2PBLDJPi/eDWqdMxptlJrTRhLyY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FnMLMPl+;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1953242E89;
	Wed,  8 Jul 2026 07:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A7E1F000E9;
	Wed,  8 Jul 2026 07:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783497161;
	bh=bWtEFlyIBpXMvKiDy1pvoBypm88zNYTkMdGjO/FtoKY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FnMLMPl+it7PS4Stb8ZECCtFTf5XbRZwfJtYsrRc7MXssz/cfKIqDNiEIQrRPMw+n
	 oM0NmaftDSDUNHJ6JkTOlNLiJm0jVfyEaUx/0ViqTHJ7w5sbNxztzbhBDyWzgtfHIA
	 mLOC+5nNOwAp25pb6cwkXnNRS4E87uWIbHNARD7v6j5mRu3hIEofBEObKyB2wjZUMN
	 1i3w5XgBcQlEKAe6AWxs6qtrrZhoDCZle3FXR2wkuQw+zn/dnIpsaMS0HAPHRb5vr5
	 1F/ZGYmhBJdh/N8/iW2bxz2zPA0ILyVcOMxshVcHNWR1FNhF/HJZT7gND8C18mdiLs
	 IMuAVEAEwMW0g==
Message-ID: <bd190dd0-fbe5-4772-aa7a-a4ffd2c925b6@kernel.org>
Date: Wed, 8 Jul 2026 09:52:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 2/2] mm/ksm: Use precise linear_page_index instead
 of the whole address space
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260708122218298hWVcT2XtcT3UnK0QdTwuA@zte.com.cn>
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
In-Reply-To: <20260708122218298hWVcT2XtcT3UnK0QdTwuA@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EAC1DA0002
X-Stat-Signature: fwtjgsxk4o3ynyuzi7jhk9uq79izku7o
X-HE-Tag: 1783497161-821891
X-HE-Meta: U2FsdGVkX19mKjkjeizyPfii00dreVKUOLQ+alRhPwl8K+pEBRrbSDiFGwUsJ9hFf1h7VelP8o/nIIueoXvQB/z0P46P0eNrw1xBakBoVGbhv4x98q2+JO3eb6kqKLhY+2gq657jZUv5wzEbkPynSB6PcChJiD8+t+SL+eYWmXuy1QMHMn2S7wYEn17+yThwSONDUAYk3+37HS+ldS3g+HQ092PPaNj9TN1AFf/weaWBvb3g2sJbNQRx9acS2LYWDnpTzdWnUIJbgsKNCrG3IpR0Qgli8I7cxgPi8E2PdYBueEMmoVX1LGUKGrnddVDIsr6BF5BfVGzckVPiVZDprQAwIytrzj2iuaNtYn0lrkvOaljYQteD2PsgZbjeM5J38eCumFHZ7OmUI12/7yifK94w0c5l8QgnjMuK4iphALkLjUwIkG8amyPxRho2l/cTWiskEJSuzs/LWQGy4efNNfAEr425deu6w7rNEee8Jsb16bRkUHwRMaMx8GXzm8t5m1+/EcQCvAk02o/1NdMbD0Euazo0c3zmtgzTWZ6A1UvFhss7D9eLoJodmt6C7Wcr9aK5WtptJvpeccXUeIxjK+3Q2Nw5Jy948r4/4PVZH6+XNSvZpdTwJCMvL6AbCJ3zOR0mmCXCNOEfYsd2ZcVs1g8qXd65NGvu0OF90yM6FnFexLVawgDBI6J8tCjjPZJaAylsPRgNunNUV391ZUcxWdXhaAAnxxIHK/YWq33RBe0GZKif6cXISMNP+QKQoAUABGUYEed77Ba+LLrR5KFSKUC0Y8/IdD6B8UWZCPO9ixaUDh244fJdFHRSjtmpTUtsJ5jLjiR9r44goNjC0fCV+astFWnuqHIdRvItpi3iVZ0TpnHJjAPmW7qBJNCJYTl/IlTJGKudtMFqMQbTaqPHfDp2Ztw3xCEKAo74jDmpdMmsOt6X/K+8Mwt/3ur2lqyP59mC1IlTTchkISTB9jK
 o9ZRfbQ4
 ZNy7U/4JUQUWADJSXqCxpx8BpC7rvAIV6NRad+34paQWWo6pp3sZJuioIwPTCitNZ+peE+Yk8RBny80KB/Tw2ad+1lWnApgSlTSGmCj2XXT+VwzjWxzfvuyxUaJ0SLT9zWwwW7m6bjU1wXteANjFj3Mmtcm3Gu57HptABSXT3cHFOMDULfLyox9doAUMwaHZ+DqMokdaIcAEWCAsbPc7Ydt5+CKswjew/Z3zOq8FbmGH8NIvfSbOao95JPFE96Zp+rTkpp2tgPpVjDHfov11rYrPxhEZPMMBRR93SJH/AbhuGS0pO6acooI8wmTbUBoBQEhRMqqYrLVI7mqpfEsGQkQUkNqdFt6FbZ/IxazYj6U2ePQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 06:22, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Since an earlier commit introduced the linear_page_index to struct
> ksm_rmap_item[1], allowing for optimizing the RMAP walk, we can use it
> to locate more precisely all processes that hit the KSM page, which will
> decrease a lot of unvalid iterations.

It's awkward to reference a commit by a mailing list link. The other patch is
not upstream yet. Best to wait for that to go in first, so you can properly
reference the commit.

-- 
Cheers,

David

