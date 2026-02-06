Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F096EE2082
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86D386B0089; Fri,  6 Feb 2026 05:23:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823326B0092; Fri,  6 Feb 2026 05:23:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719356B0093; Fri,  6 Feb 2026 05:23:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B42C6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:23:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E0818C541
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:23:59 +0000 (UTC)
X-FDA: 84413646198.28.3213EA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2E41918000D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:23:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lkgsOVjM;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770373437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+KNZN6z/krldVP2Y4BBko3jZMXeqf1Yu6t3X9QVX4lQ=;
	b=jEaX/PnQHs5l0OrA+45bI1b1jtUtSOta/wyYk11xx5KkoMg+guxunlFhsAleRcBMJCRXPD
	PoQ02rQXqs8xBDuw1EMdTuaSwvGWjkr6C8qq2biwrizLAFId0x8/k54ZFPtpGCZpzwSje+
	6woXrdJh4MZuTkG9/2xeixis5rMbJNc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lkgsOVjM;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770373437; a=rsa-sha256;
	cv=none;
	b=na4nhxv3vraBmkXg9hTK3Lc9aUv6ZUwFKiqE5An0lNUlnjN57NFEij4YVGG4jLI/WXfJkn
	Q2DJwaS+M07jhatOZwKhkyl1C4EP1QrTk2lCqmLuNVSuLCtUx/4YkgLELCE/JZDdIHqDx+
	9i0omRgA310SU6doqblyQpR0+BRqjUk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 01C7444214;
	Fri,  6 Feb 2026 10:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA86DC19422;
	Fri,  6 Feb 2026 10:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770373435;
	bh=CVRfjenhPNZ53C5ptXLpHu6G+l5qThn6T1w+S3R43J4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lkgsOVjM8345QQjYJiRfQfJ0oSMWqIL/dF3b44KB/OYvtFa5wtksT4epKW7dc7zQK
	 n13iIxkGzKpBzMaIzGDTNhk7k+VRqM3ICVJzDUOySg0Dee4z13wjFn7Cl2EN1ekcLW
	 XWt4/jPFLIpPhf3JY1BeyzKTbyedA1v9JDaYVUAjI9tYMJtEuJsfrVQR+lDly5qhC1
	 zCwWghcKG4Qbwjg/A1hG6Xsrw28MryrTIl0yqvYqtw7HzK9njc9BhbXFrF7jt0cFdj
	 aloqve3suzVNAbni2tS3Lc0IjWEudBVqDr37kT5BZXF3tUmnGa4ntBhXN5Von7/OEX
	 EKyVfiMLATw8A==
Message-ID: <ac8ea0ef-4175-4563-b312-d888b31b83a9@kernel.org>
Date: Fri, 6 Feb 2026 11:23:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 15/17] mm: Remove the branch from compound_head()
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-16-kas@kernel.org>
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
In-Reply-To: <20260202155634.650837-16-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2E41918000D
X-Stat-Signature: iwcgtzmtdydqcuucpaox9kykwh8psjtk
X-Rspam-User: 
X-HE-Tag: 1770373436-694331
X-HE-Meta: U2FsdGVkX19s8LKIUqtUp0O16jQR2OKvFHop9rQjcUo2Bzk2VQtgKKulVnSyj+BMcoLWiUxI6jn1oAaPb0DmCHogfMWq4Rz3D2K6CJP7kWcoo3NT1uk/omK5MTkaEkXiWBINUNZ0rrN2vH5i4PN1VhU/4CaaKoJV1UuWXPBNghoblCJ5rkm9TaPVLRYOEHqDtlbcmTE7ieH0owZ2peEkQ093zZsfobt7LMKGTpKPA91FY8o015w3TB2P3kfyjTnQk5AxoBsmF2NUvZLqBSsnOpN8eiB2xbAOpmGzaFbSPF9lZzLhnf+/q5nTcnrv/EVpBIW37Bknj3Ylp1WkVVD4g6SYxzkFm5n2UOzkbRXMkuoMqZxdEHSaGhZiFLV437zHlCZhbBrzu7KV8L2YS2qBa1+P8KaawAqHUve2fDbaekN49aZRzN+h6qdh5rCmuE4pxbEdXpaXYg8xzJTWJI5mRzH3UpuRnbC4EFijJeZTyV4PlV0KW0kB1ZtEBNlraM6BaK/LgQ0YLImepbTePtX9XXUsP3Pv3BSWk7NCw5bh808fHrrCT0Slk7Q5jmKP95v7IyrDGeHxh5Fs7KsjWm2HeeDovg+Gv6mBWGuOOuXbD85UufEFEIkCBM7gv02QlikTeZBW9kzdyuYpsQRe6ZUJ2bpISBm3tRxTab/U6cZpYQmpfBit/TLxPc6j2cFODoEfXc7acsgC+OLLYV7ynv5Yqmv3Ec64ptca9B4odyGXkPvYBR2kc+8mSFFQHWiR1YnAGnaqEiwaIH0o+ymr9RS8qffj+6y+ln02vvQNjv0qxO98Zs546pOZzPKFi1i1Hpacyh+Z1r9wJ611hEV8d8H2clTgH6s0+cC+f3zUyZ5ukMakh9COVZmAOZbCm8G23hoy6zM5IIZqrFIIv+7FK5UE6/dLHXmOAD61yqbaVoAL05fJ9/yH85ys3My115uNTLgLaMDOAN3TtmRp11SPBGh
 8pdkPDJ5
 RLx8Ub9eixNbJG3zRdVSBIt9N/G+NeMmt0S6tcNEoptU8LIn70PJ9lBSh4B3bJXlvXJ/kiBhss9SRuCEVBQGAi5y4AvLlOyXtD18xeucE3F3+ngeDRykTJ+5hjNQbJLEFJh0xAIjSV88gs+hmg/gg+13CMBxSi9j1n5WnDAxbHOeY4/5TtEKRd/DdKoRFkZ41lQUxcxWQGsIS5lwCc5PgpIpUO+FDO/7d8lIknu4HBd4HTIxGcQSBIEeV+1PxmMUN6fM9WElrDtBT1E8V9OoTQFi21fsbjd6WJv1ayGGe1ugrtKaXoqlD7AIlQKHuc5nbxI4PioMfTK5hSShYFIkepEJbxAtx0qYnlZIl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> The compound_head() function is a hot path. For example, the zap path
> calls it for every leaf page table entry.
> 
> Rewrite the helper function in a branchless manner to eliminate the risk
> of CPU branch misprediction.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> ---
>   include/linux/page-flags.h | 27 +++++++++++++++++----------
>   1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 1aaa604f4b9b..16384cb6f962 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -224,25 +224,32 @@ static __always_inline bool compound_info_has_mask(void)
>   static __always_inline unsigned long _compound_head(const struct page *page)
>   {
>   	unsigned long info = READ_ONCE(page->compound_info);
> +	unsigned long mask;
> +
> +	if (!compound_info_has_mask()) {
> +		/* Bit 0 encodes PageTail() */
> +		if (info & 1)
> +			return info - 1;
>   
> -	/* Bit 0 encodes PageTail() */
> -	if (!(info & 1))
>   		return (unsigned long)page;
> -
> -	/*
> -	 * If compound_info_has_mask() is false, the rest of compound_info is
> -	 * the pointer to the head page.
> -	 */
> -	if (!compound_info_has_mask())
> -		return info - 1;
> +	}
>   
>   	/*
>   	 * If compoun_info_has_mask() is true the rest of the info encodes
>   	 * the mask that converts the address of the tail page to the head page.
>   	 *
>   	 * No need to clear bit 0 in the mask as 'page' always has it clear.
> +	 *
> +	 * Let's do it in a branchless manner.
>   	 */
> -	return (unsigned long)page & info;
> +
> +	/* Non-tail: -1UL, Tail: 0 */
> +	mask = (info & 1) - 1;
> +
> +	/* Non-tail: -1UL, Tail: info */
> +	mask |= info;
> +
> +	return (unsigned long)page & mask;
>   }
>   
>   #define compound_head(page)	((typeof(page))_compound_head(page))

Nice!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

