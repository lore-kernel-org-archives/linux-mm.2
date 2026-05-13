Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24BCFCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED0A6B0005; Wed, 13 May 2026 06:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89DCA6B008A; Wed, 13 May 2026 06:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DAC26B008C; Wed, 13 May 2026 06:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA0D6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:18:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BB13A0802
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:18:32 +0000 (UTC)
X-FDA: 84761997264.24.CB1AF5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2DA8414000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:18:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oHfzZN0H;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778667510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WERqY2w7tNo2JggPELH5oMWY0/c1/wYyO/lM8383GGw=;
	b=qfk2nm8hTbPgjgumKfgmSKrx7DULti02P7QXfAqEZI3LRHHxI62MZpozBliR+nqs2uUdBk
	oVOKjZMc3HZbivIAskN9uTn/rcT4U5jakbvCDcgxZQJlFLY+q1sNrUv9wJTphfLKvAmauD
	+vJNRuvr+65opiIR/hwcb7pXgORfVV0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778667510; a=rsa-sha256;
	cv=none;
	b=fbpXlJDLboTP1R1BZLhfYm47qDmVMY/e4EH3Bx2NnMkNq/MaBKprxSaKYea0OkuTwrvF3U
	eAk4fkG6uSqxkcLhR1HkKF6bP99eNicyu8S4FD0yprNxYXJtAubrLPC1Y614PCC+tKK+x4
	iqU21SthXhAxqt9MC0ydc8/TV4LscQg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oHfzZN0H;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0ED5C438C7;
	Wed, 13 May 2026 10:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DB4C2BCB7;
	Wed, 13 May 2026 10:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778667508;
	bh=XNVgxdsMyv+WQjqxexcWkpC5zwMHq5cBoI5k9npq6Ec=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oHfzZN0Hy8nYLAqKkk5euvDF4oKozt1/KCX73o2Tpi+gsQpa/eqTvWXkeoQwzhvop
	 qk3x4mMreIOwevEWOj3iVh+22rfCMdDYn62Axf1ANjJddE+YR4yBn5jcFdtJ1P1kx+
	 tN4kQTcoheuF9YlPrFWdV4vzK291e2QkeReFAOXauvbAbJqFcpm7k9KQigAhItFAgj
	 //GjVfawF8zhGdokGdJ6UPy6N9tRB90+SmJMP+2am3gY8n6sBmPmfG4otR1QRMHlKC
	 Pvchl4qXzhQ4Appi6fE7Ust2PIZgx3SNlmVO+XZfHl9ewjA4d9ahg3d5OefMuPZvtX
	 X8bvVx2F33usQ==
Message-ID: <5e7d50fe-6143-4f14-9129-a8230dad1221@kernel.org>
Date: Wed, 13 May 2026 12:18:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] tools/mm/page-types: Fix typo in madvise() error
 message
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260513022120.58033-1-ye.liu@linux.dev>
 <20260513022120.58033-2-ye.liu@linux.dev>
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
In-Reply-To: <20260513022120.58033-2-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2DA8414000A
X-Stat-Signature: 56mprifi9bgb9j7kok7nwwj9ze1jwsdd
X-Rspam-User: 
X-HE-Tag: 1778667509-849730
X-HE-Meta: U2FsdGVkX1+Jrje5xaEiF+f0eL25Z+d3lsmOCgO5r1FviFPX7CNX9bjgnAX2Q8uBymye/HO739L9zAJpD63xwsRe6J/j8feQ3w4wyD4dVxfxBofvaI2NGN0AL2zDRv7FLbKqW0eAvjJI+hgYy10j6d8md0Iu26/1eCGcV3mxJpZH+CoMpWO5jNoi+4OxJMqbgTFEuzUIM9kSyJAjYPqBP+P+b8r6uMiJ5VuMElgcH+ODP97pjKR49F7npyS8t4QZ1eacKoyHTCnNKAaNOJ+i0FZCSrFdHDiVvuHO8KxoroGOLYVfoIEv2YfZCv5eDY2jpFxmLYza+M8EHGOWWqknqGVBIxat5jC/MMPzt2DEdEp7FB/2tE/0eSDDetJqe/mo5vHpx17JwXu72piqc0B67nidSHFR6GBY+/7B+wNyBjRzwp7owK6KEFE5MlrIKJaIopf9B9dwkPtLkv/1HmhcXD8yU+fCpHFEXxTYfrQwWxepQ+apIYJsRVhZsqqWETS4fqWa/qnjeo+t8dV9FdYVH7yvRSQpX58czo8CryrDWrKuEX2KK6wMsBjvEWERJswxLRj079yARADRD4ZAkZTndo6lyfkqvQT0CuGatfANBsUBa5K/KKHgDYY/SxRLD8OuWTsXJ4+0GoAMZRmkz9bvaKKDpvK4SkQMxMn+ZgQD8VvAF0TbW6K9fbsV5lIv82IScHGQ9GO0CEn9UJ8F6G/ZFR8vHOlq8gaZGQ7WSodS05RoP6qHX6IoBPQHCJwVFtrNV8+cahhIpNsvEA/4h1136QajVdDbRC/E9vtyIPTgnzJI2ryPEp1mk26f/E0uDdx0KocyKTeqvZQ8uBCcoxqc0jRplHeyw2Pzc1BzjbKWHQtXI4urFrdySQm8Vy7HfimEMBLxLwwJvih7Sz4N5IxN/6YFTkT1x44GhfxxrZHYP0Df30y3XxN/cEw7oscpkbANFpNh16KB/7UeBb/umgd
 HosKHv0A
 09eUE/1sYm6OytUFmwwjVqs2raDV2eQTGyxVMwv+QcS+7fsBKkuE9H7LOcCSFf7bqr2S/IRKXhWd26Fn6bAKg53HYb1u0iR2Rs0mT0qJFfn4iBTdIx+EqKUlw5G+i5Lg23jqqbo/dp39EI/bSOuEiThCQ16+B2y6RThaM+j1L/OPDsqnuNiVs+pr44z5LIge/3cXYQquHVUvHKerqTEHglYsp5cihLyZFMCmjFYQMPgU9iLQyzd9WELgOv2GvNdHP7AtQsnDJmYakrjC0XVVQuRg/ha1xmbdtQugDOuUqEvH5n93ufIZl1oZutg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 04:21, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Two error messages incorrectly spelled the madvise() function name as
> "madvice". Fix the typo in both occurrences.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

