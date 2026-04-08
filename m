Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7AAD1073CA6
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:28:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E306B0089; Wed,  8 Apr 2026 08:28:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1168A6B008A; Wed,  8 Apr 2026 08:28:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C426B008C; Wed,  8 Apr 2026 08:28:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7EB86B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:28:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 865A313B913
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:28:50 +0000 (UTC)
X-FDA: 84635317620.07.8F3B6E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9EBB2C0009
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:28:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nTu4O9Ak;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775651328; a=rsa-sha256;
	cv=none;
	b=8k9sbtb7L3aARBvK1in3+lwcWXY2kACGDOsUB2O4Ey2WOGyuvb0kyWgLhUitwkBeBy/M+y
	XCsj4wN0aXcmzsAgHfZKI8W+fOQ5f/JMV3cryj+Z+MRki1cP6rltHrDbiZiKFQWfIueNO5
	jCCqNWIG4T2149KgXUPzMmFGBQ4S3U8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nTu4O9Ak;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775651328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+iTfzKY+WAyMsREVjbsVA8K2liOA6jif1jDazY61mGM=;
	b=LE0VgUCN8ej1XmxsndXA/Q9vD+rR6BZYT6EgwBWCGcysN4CNOlGuhaJEqdCra92DdcwTpc
	+1rJw6tHoPN5L3eUlj9U0JD35y5f3vD4YC6clkn1JiBUR4vNroEh3sE5a1G0Osk0EFLgIM
	cQPTuLxcAE4MdGBb/joSl/vPEmk9s5E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CABA84051C;
	Wed,  8 Apr 2026 12:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FB9C19421;
	Wed,  8 Apr 2026 12:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775651327;
	bh=36Oj5jo5sPcT0kNQzcbI+Kpz1ZOD+jY595knL2nNvh8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nTu4O9Akk0flvO6+BSylm5USeEJv58A8rGR5OVCC9K2+wRrwUjZOadfi5VUAT9pax
	 XH0gBWs37n9FdBYhl1ydKUtQIsyREwo5qbrDXxCu/+bgunERXrJ2zDtu8i4bMSqrX0
	 4PT1ElyNznOFP0VQ7Rxnx5ET0DOnsrmzB/B12k9Vq5VADc2F59Z9QR3+67dAGH3CRl
	 Dt1hpAB7ASIMZwFoTz7SgC82EF7FFN+66QYPUEmkSCrJ77Sdh0deMrbzAWk3LtdSiq
	 e7edUxnQwQo66fxs1uJrEsST2+Keag1IlrdarBU9rbplgRNwDH41SM7WyEnLrmqoXK
	 wTav+mb8/iibQ==
Message-ID: <aeb1972c-57ba-4f21-8289-66424e4e619b@kernel.org>
Date: Wed, 8 Apr 2026 14:28:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 11/16] arm64/mm: Route all pgtable atomics to central
 helpers
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-12-anshuman.khandual@arm.com>
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
In-Reply-To: <20260224051153.3150613-12-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mrius769cii4satph5i1r694ak4ydn5m
X-Rspamd-Queue-Id: 9EBB2C0009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775651328-945105
X-HE-Meta: U2FsdGVkX19i96MuMimmW6VFzVhg/M2d01dk5ewFnpoWZecgogYUvHO0B/Alzy1ilNu32hrl2y4dkK4zD8sn63+uQ0veIfs9F6R8yRh8c/aFzVKVtRh63WPUnQtXa4LY29XPIvQXtcs0zWl96uknynVqrfq1ZH66HRR5cotwPVHsjMG6NnCXqiBTh/Ay5JpU7LpXXR91baiZAubGYavMeyj9B1dJBoxyHO/X+aW/WRRHhcHBU+kvNDJHW7+nbAbCP0womHgz1T7Oses8CMTuAGAh0WSVimnzMjRytvtn+NL9DfKrJz8uhX5BdMkU6v8J70LloRQje/Zo8TqVMW+jOPLfckFnO05iNty1KYSDFIMdDmyy0XF1+clQhxkzMAVfVW0M0BwyFAf/C+DBaIOr3vqxHL4mNKMQVwtk73JXe13PizbA0d4k2yRSER+GysOzlqleqsqpsgx0Yv/iLVLhtino2sdhLLpzBMYWEqx+ZQiZfKSSs56t8SWoVTrdNzs/xKnYKaqSpHqGdINLXHXgCmcEzJM7ZvqauDmg4/ZjhdlNZHSCE8+IXqFe6ub1KXvExVQCvnw1xPprcaUQCgzVHjarrZE8mBR0G1Z8rvVT1Ivq5kqv65+jmUvKJ/boVTcA2xPr3b0OraNjm8iUb1lFplZbAFdqg+X8j6KsgsGCL3Fu+HvI3rqjkXN4jfR2anTn+qljKW2JbfsloI0WZ/WIverTXGWp2FZVK1xJ1lypefMTOrx8JQfOMihtpC6kgBVfJFU3dgjSLxEp2XZqMZalvowW1jzflaxdmXT4TNWpPLuqLo61Z8CI3F6m/9rYsHth8HjQc57AdzsOcH0vAO2xm7ByQvIEeswJNqmL3d3XVHTb7S5dhSmpzwd7vRwRJ72fOA9tjUTbTfeE5TPXpBwU+wS31OElU5X+0WS1rN/SGmMzKxFOVVDhPtzScRYnkAW8U57QfaZLmZB+YDYLJrl
 E7mHemzw
 TWaRhNxP+jgWTax4XSnYslhPBQnavgsnwa/+tNMl8Pdn1qO5Zyri1ZJZIr0w26WAwaPYd/EqxL19Oyl5Yu4gVBukvPqg4YWiGEUSfV5G7UmXD/LOSIS2eHWUHgdZ4gB1mklkPk2yLHBWh3obM7Clq/SaJwroUaIOrbW3+kl0rAKHcDqCW7YC/Q+GWNVOcws9zsZ+/argm8Vzt1rT2Io8MGB1SeSJQYC1tmu+avdDmJ3/Q849mTsiI9xDRXmb44sJEONOmIVAJdT3ZBxqHqNSRrGJqqc04uXBfgIvMkIWtFcdyo8o19E/PHqd5zsfr0BZMwCdN2TiELepRHTrIRdbumyZq+QRtkuyzz6ZbgRiRfSVg0NjKR3Ap0gQqz1WlyWa2EH2wj6blvoWKhgGTwjN8AaarFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 06:11, Anshuman Khandual wrote:
> Route all cmpxchg() operations performed on various page table entries to a
> new ptdesc_cmpxchg_relaxed() helper. Similarly route all xchg() operations
> performed on page table entries to a new ptdesc_xchg_relaxed() helper.
> 
> Currently these helpers just forward to the same APIs that were previously
> called direct, but in future we will change the routing for D128 which is
> too long to use the standard APIs.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 23 +++++++++++++++++------
>  arch/arm64/mm/fault.c            |  2 +-
>  2 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 42124d2f323d..cf69ce68f951 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -87,6 +87,17 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  #define ptdesc_get(x)		READ_ONCE(x)
>  #define ptdesc_set(x, val)	WRITE_ONCE(x, val)
>  
> +static inline ptdesc_t ptdesc_cmpxchg_relaxed(ptdesc_t *ptep, ptdesc_t old,
> +					      ptdesc_t new)
> +{
> +	return cmpxchg_relaxed(ptep, old, new);
> +}
> +
> +static inline ptdesc_t ptdesc_xchg_relaxed(ptdesc_t *ptep, ptdesc_t new)
> +{
> +	return xchg_relaxed(ptep, new);
> +}
> +

We really want the rename of ptdesc_t before this change.

-- 
Cheers,

David

