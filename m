Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95117E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 07:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDE246B0088; Wed, 18 Feb 2026 02:53:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB096B0089; Wed, 18 Feb 2026 02:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCA5C6B008A; Wed, 18 Feb 2026 02:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC2B46B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 02:53:21 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3755756902
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:53:21 +0000 (UTC)
X-FDA: 84456812202.15.6A85BD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 83B1040010
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:53:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A5VgBRLS;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771401199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZ7aCREeI1vJMLmgbp7IfICJYlqgmRd5pZed+gE3iu8=;
	b=UW7fKheRF1pGAXBughAgZZhQFItx/dPoEnLnmjQmHMkC8rxk/p3ipD5trsJH8QdY+Lmo+E
	KD2qzw+bF8/tRSfgQC9SucEGhWbXM81gC6RrWngTRgB3/b8VFHhHinJu7zLxDkQIFMO2zb
	DSTES3TBkvmY1Zk5JQMaZGkxoGm3d6Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A5VgBRLS;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771401199; a=rsa-sha256;
	cv=none;
	b=sVyULKodf64C8ztuG5+Nmg5/cS6YgY8aXhTAl3DzzloAdgxGJQyz4XOm21oQbjO1945JFT
	3Urfbwa4a9+ihux9HT1PlhgL2DIgAlTXxsXVO3tlAVcZFHiDnL+KEUztNKzm38hAPjUWRv
	NVMiG/ClnclGCaliPVDfeYtE3m8vJlA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 09568600AE;
	Wed, 18 Feb 2026 07:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F13C19421;
	Wed, 18 Feb 2026 07:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771401198;
	bh=x/iXEo4UiJ1skVbbS30nZ9Rxy3wTN5EfpMSD8FTyZm4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A5VgBRLS7qUh1f6Qaraszl8V6QgyyoxDbei3NIueJsMmBz4zIqzr2NbtjILNVXAcK
	 op55rvHk1zDId3WrK/OycvLnQd4xMvqXRslpvTvUclOSAkugt+CXGm3ESoujjSQlUQ
	 PbPcGKMrVOwHjg/5yTzLCV8Z0ync3NlrprhQb9e6vpDjGAP3pBgBSufSk3MSJzgdys
	 3kxyQ81UJSyoBlzt5FhMnK8GYmyZ0hGghII6KB8Spi2Yg+jdk3MRCC70MWCCy/GLfK
	 w+f7A/BUF9bdbNLTjjniFeNJjgWhiBx1cplt338VkESX8FyhmAyCkQxbbySxx2ZN3m
	 pfK1j9MTbuB5A==
Message-ID: <b389647e-67e5-4948-9c59-35bf3f936eee@kernel.org>
Date: Wed, 18 Feb 2026 08:53:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/huge_memory: Mark moved huge zero page PMD as
 special
To: Chris Down <chris@chrisdown.name>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <aZU10aBZxCHfmjeB@chrisdown.name>
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
In-Reply-To: <aZU10aBZxCHfmjeB@chrisdown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s5e5c4bpdptq13sxcyzr9nd8mxokwiw5
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 83B1040010
X-HE-Tag: 1771401199-474236
X-HE-Meta: U2FsdGVkX1/ouGLEcmbljpftdEdB/k8AWO292AfpVtKvmLW1LkJ9Jl7odIa4KN4eMPoSGoWL3sl/EFSJYIJIF/Cx/nd26arsHXoBfg6j6p/9lhA7aocescGgkxvlImyDlKuEibVDEaxywGVdmA5DSvVb7WmePmH/4uxbO6foA7qb+bKKfKa2beLf/o6+vkCmqDCL1aSs/gaU3Olgtw4NyT99PZUf9oM4BYjuFJNctIqgNZqqpCjn+a895G+DDt7b5evhl6czqW1lmecSrk25/pKQwRRPt2jD+lztZeB/hX2BzZ3ndwxXDaU1wVksmMqkVrQAX7lF/evBiVjnERfEBwmJeRoAgTTyC5jOU6lHfBt3Q5lho3wiN+2+BmNTo4Qa8z4ybD+QOxWM37D3PBxwI/EI3q1HezkEvD8ma3Q3cnrKkKHwSptE5t0eedisiFa1RpNv1zzsbdKOiN0CpigWEHB0sWugaOOFXoV46eR0A6MK2loUwDI2RxOatj+1UPJ3at0AIJqWQxSwhy7dwTusxZNuPLDwSJyvqM1Wn/nPJpQzwcVa57um6C+ST655gZ5FzQ01FlMIbCObF/fAI8beJrlEX/rRctCqYx5yJcyH7ySRSKMFGo6dkhKw/ZMNnDBxAuJVd5DRwCjsx74BFKJqxIuA3rHQiLSqMWC6+fEkTztLuM50kGAg3GD02si90x9sn7Zaa7WRVcdQZiE5eL5MxlgQVk48y1JjOQEMt7inNT4O82aAmEVd4HVeHIjn3YBcAW0wiOaekslSrlJa+To8wo/gh+oyBijAsD/Qk40qVfCG70oG2KeNqIPHkX5bn4TwkCz5WulFimLPwXndIBqgch7VINaSESyjJXiEnIhbGGiecP+mNUZtCeLSdlwF56CBHsUKsVcLBrrWp3J2RTjh2VXIg2bgoXvvaqltZO5ejGc5GRygjzYzfuKHed/mPEbyldic/FCQ9/wQ63jZfX3
 YDOKVv2f
 HJM7dtGKzXH8MnL1ZzEmGfYX6mB1jDUaULuU9x+74MhFXoONMoSHG0Sc99xwBrJKXrybTtuHRZTRTHPoKvQ1odDWDRG8rMs/Ixr5ZwF0qeMO4pO8E6UQbpl33DbATEerSAZ+7hz0p3e9MZKyiYQ6P1RLhJSKA1kmyt4/P6+ycY3CN/4ZC2ztB28TGUr0xswzfibZkSLtk8M12WhDLQwdS4HFlhk+IaOyelEKAG2Lhy9aHij8FPyn/JD/6HEkTT257ek02M1H4pB/bHIqGrYRBdXbeY9DUEUe8VaDB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/18/26 04:45, Chris Down wrote:
> Without pmd_mkspecial(), vm_normal_page_pmd() on architectures with
> CONFIG_ARCH_HAS_PTE_SPECIAL does not recognise the moved huge zero page
> as special, incorrectly treating it as a normal page and corrupting its
> refcount.
> 
> Fixes: d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>   mm/huge_memory.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index fed57951a7cd..5f908cdb11f1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2795,6 +2795,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>   	} else {
>   		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
>   		_dst_pmd = folio_mk_pmd(page_folio(src_page), dst_vma->vm_page_prot);
> +		_dst_pmd = pmd_mkspecial(_dst_pmd);
>   	}
>   	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
>   

In theory that's correct, but we should look into just moving the PMD 
instead of reconstructing things. See my reply to patch #1.

-- 
Cheers,

David

