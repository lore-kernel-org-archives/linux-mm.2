Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CDDEF589D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 13:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111066B008C; Thu, 23 Apr 2026 09:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E92A6B0092; Thu, 23 Apr 2026 09:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40446B0093; Thu, 23 Apr 2026 09:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1B3D6B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:31:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 702311B6E64
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:31:23 +0000 (UTC)
X-FDA: 84689907246.22.F0AC7C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 647A31C0016
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:31:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SuC0qMwj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776951081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FP/uXsbtCYHgyfuTbT/XD8E1z41ddmSKf13JWi8kd88=;
	b=iagKQEF4T+NovFTWQheFyJFl9mmZteaTf+L2vMx5kv2nWQhL864cXPBlSk6wYL0ub/zAzf
	MBRp/fH7m6+s80IrjH/4k5HyXspM9jTKLJKGfsUtU0lkFb2aR4A4WQjAOk6imBq73stER3
	TQcWsFFWBZrnJqQcvl6iEMWPnWFbb+c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SuC0qMwj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776951081; a=rsa-sha256;
	cv=none;
	b=5DcqB2cNjmomdx7IAcw0b44q5p9k3E6mGBxdFOUAN8Bkyc4xN9wqBDvfnqE6KwtSK9s2xx
	dU1XyYIGo5FTJp9eIeQxuI1IweNVCckCodf+nlUvtivR8UymJS/MgJwZiZiW8FQLOwiff6
	+9ViDMwWxei1CaodH8KImSED6erK9BY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 69C39406B2;
	Thu, 23 Apr 2026 13:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DACC2BCF5;
	Thu, 23 Apr 2026 13:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776951080;
	bh=KMe0YNCVeH3Ab45BSIZHBghW101L8KHnVWa2ygzk6FM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SuC0qMwjuhuShAxltSJy+p42wFrO/oEDq9LCHWMiAJ0YOY5HjFHxsHPseW6itbOj1
	 MskzRFu6+BB8HC53EyqYDLf3HVZzIpNk7Xn046iHDtEPcKz1EjhWkaxI046fGNWjJd
	 rc1G/Kd+urQI3eWNnpsZPDixF9wFkzuJ8twln3xpelDWQFer2bNMDYRLH4Z6FD4R0z
	 gDJxERrcLbNdBcD3y9XIzp5X2jwYHZYMN7rEsgg1e0vqqzr6HR9F0hoezShgr2yaiL
	 wFUXsCc0B4zX+Lpe4IIP4MaJX6HgeiAG/FbJMpWFp0io0nugd9Vjttj4qp6KUpbHbF
	 i3XvMVhtP8+nw==
Message-ID: <7a762959-014c-4727-999f-a5073f9eaf7a@kernel.org>
Date: Thu, 23 Apr 2026 15:31:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] selftests/mm: clean up build output and verbosity
To: Li Wang <wangli.ahau@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260422080446.26020-1-wangli.ahau@gmail.com>
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
In-Reply-To: <20260422080446.26020-1-wangli.ahau@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 647A31C0016
X-Stat-Signature: dhkfqxfhq5jtyfn9sfmr96nituqnxwct
X-HE-Tag: 1776951081-154088
X-HE-Meta: U2FsdGVkX18N0KD3Jn5dnr+phZTB4gyTjLpGGN8wufrrhk5iSww28E5uzjLSM/8PejSiQymx1rr1tsUYnjC92IvPkI4LT5OX9abruBjpFHGGDrW3WNJXziZGuQeSa6NA4lXWBmlhU2lqrGa3N752Z3HeclNZe+YaQ9zDNpQQlynNwhp1qAGFCuUvKnzaEFOT+92l3Y0pIMs60UjQ5BFkvlpgG/Cds5/gxx29cjvA5gJnwIxGtVekcb7QyZ3yh2l18RMj3qpfZ/eRgaCzeZS+BXpxt3d/r758yD2DIGZME/QV+Xr+QJ222BhLmlpySGtDz4lzK7ufBHA96EMgfhLC5Z5TMwuKTKtTtZD2KART0rCyi+nCRTU7Hbe20Fwv3Bx8E4tqxIz7lWDIleCbXlAUl1Fy9DYkMzYRVfjFC5S7MzXmoojC89b1fuzkKBp7ay/gLibogEtfpXe+2S07ZbdbL7540pmC7Y5prIe4HJ5d0NkRznG1NzhYAjTroMhbd7hILk9tN3JAxsRF/ZIaltApy9wTDrOqybWColYKcACVsPPcIh1zS5awRseMez5jxl01Ep2HMIn3fWxssCPdl+3Ezr/x+myG0XlpI9SvhcUL9lerrY7eVESq5pm/UQ0VJKXNu48ZYoPd772J3xfkpnaUMQcAMFuFXwdI28SMu6mAx1ggPPGaWgjYjQv0DpmI29Ua2UuPV1KogRYEnjFGxN9fQ4y/BQteZ2FgAY1ZKNxU2XoQWTVzRAsG/c5LalrWU/b9ZHS+mPY2CZlH/MkHmq/MLL3mvcdSLGAZvWY8MfSVGFAaujzj+/2r29k21IUoOWqBLFtDhZF0RKyAVYlRTPD7jlRDg+i9LKp6UVOvneXF0jmmTfjroncicVWWc0Ub4cZTrm0DySnIsENFMPZzaF43FhKx9NwX/Ah3V5z31NNHNh2obfIWX+nlbaEJ7cwbDYuuqwL6Ug91/aUgp3EoCKO
 7TPoumVl
 YVjy9BBRaevcC59SrykNrawYLfP4PTEGFMzQr/7/eAZNo0Vnz5gaLQ98ufwd8HEGnfDCDX9/UJSOIzeK5TsIYWsWnGHZRCW7ijCpi9PLH1griJeah0LV9m022MXDBRGfVf+M2B14sE0qT1i0IUXml8/+r4g24gZB1koVUDe6me8TMDk7/KmGSkOjKX0VnBhh5ACnmN6TyT0hDeaqZkY5mZ5VCUcuuFHFSmNtUEhnrav7R+JXMGjpr6vEAVeHcaiCfMOVrKPqC8sbUnwf/cOgLM96pVYKtCk8pxqkdciotuUB1b399FMLDzQRT2VJT4PE1G59bLL8dQDtpQJ3T6FSLSTr5F/bgzel5BR1K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 10:04, Li Wang wrote:
> Currently, the build process for the mm selftests is unnecessarily noisy.
> 
> First, it leaks raw compiler errors during the liburing feature probe if
> the headers are missing, which is confusing since the build system already
> handles this gracefully with a clear warning.
> 
> Second, the specific 32-bit and 64-bit compilation targets ignore the
> standard kbuild verbosity settings, always printing their full compiler
> commands even during a default quiet build.
> 
> Notes:
>   My email address has changed due to employment change.
>   Previous Signed-off-by was with <liwang@redhat.com>.

:(

As a former RH'er, I'm deeply sorry for what has happened there, really.

Thank you for continuing to contribute upstream, highly appreciated!

-- 
Cheers,

David

