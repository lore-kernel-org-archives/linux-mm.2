Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5EDCCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35B926B00B5; Wed, 24 Jun 2026 11:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3335F6B00B7; Wed, 24 Jun 2026 11:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249D26B00B9; Wed, 24 Jun 2026 11:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E74A26B00B5
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:10:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 61A5F1A035C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:10:47 +0000 (UTC)
X-FDA: 84915143334.22.7DE72BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7FB3E1C0003
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:10:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ArSaKsHZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313845;
	b=hRt9KwpmuElxF8X91VUoFlLernuFuMf8aFFP8GK0u1Q11q8r5MXRhXM3MISs0oHE0zso2p
	qYIN3qr015vkMLQijRuYQ634i3NLv/4oeyO6gMhzUU+qk+D8BucX6T0M0R3rE5nfSNchHr
	QoDfTeWFkdS4yrSJBaJ0JKrdvFsZPt4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NlUQtV6rYk7FKhDdMJZ3o48WICN+uQTFGFIwzC3yTEo=;
	b=U9A6v183BfQDbL27sKXptG4fWPQRSIMyPW8etgDFGENxkCEHBWkMnzJLx8QaQVIGv/LTna
	VipH2cZGXuY6T7BQurNvb/0jGrjDCLsRq1zN52ZymIw5FSSsDCIXRwnVZwHBVH3bA0lMc5
	X3/pKtTtDHYcfSRTBsou8Ir3LjRkmXU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ArSaKsHZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F2024074A;
	Wed, 24 Jun 2026 15:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161031F000E9;
	Wed, 24 Jun 2026 15:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313844;
	bh=NlUQtV6rYk7FKhDdMJZ3o48WICN+uQTFGFIwzC3yTEo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ArSaKsHZSqQkrSpM7Kdsx+/KbxnolqM0OwwNDd8CZzpShdHZ0Xs29mMXHn0/O5tOz
	 NSp6GygGgPmWjmGbywVW6UEGhsP/O5L94yCEuFksLPBvePfWBbgQBtsbENKDOHmyso
	 fwJathYt4T5m3qlJSYtVcCWpVQZCyyE+OOYCgZxw9SRjUiygI2BLYq/D9ag0cpYKYe
	 tpbnjgb6ufYJJ8p1SP0CwYlz9CGgS4u2CZlbCw8a4i8xHXQx0EM1dC+QseHp7+Gwhh
	 TJovu4jh5TZnOVjkKkU9R+47sJbAfvJntFJ27CDMmYZC0ctXVGetOIkclyWjgAdXyr
	 /IHUliFHUoXWA==
Message-ID: <8cdd6eb3-1e93-4a77-a187-86b94ef57258@kernel.org>
Date: Wed, 24 Jun 2026 17:10:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm: entirely remove lru_add_drain in do_swap_page
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: baoquan.he@linux.dev, chrisl@kernel.org, jp.kobryn@linux.dev,
 kasong@tencent.com, liam@infradead.org, linux-kernel@vger.kernel.org,
 ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org,
 shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, youngjun.park@lge.com
References: <20260623231635.43086-1-baohua@kernel.org>
 <20260623231635.43086-4-baohua@kernel.org>
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
In-Reply-To: <20260623231635.43086-4-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7FB3E1C0003
X-Stat-Signature: j3gtmagksqthqroz8hh3obeq7jgb7jwp
X-HE-Tag: 1782313845-820112
X-HE-Meta: U2FsdGVkX1+qTZ7EYKV4JUOHjGTfrPfHF4Uh6zruGX5r/Hk6j8PRquWqlegYdWMeTESOeG5TtTH05DsCkItt/HkMiaubBs2XKbEGx1D/1/OBDM+6FmdGAlEsDfOuJ07YN4Qsm/+sfwUb3/m7d0ps/CLk/zXhtaAoo30wMyzKbEC1Jte6XoFRgD3EI4poKH/9mDrpNJ/xx4HsIvJGIcKqf3ZVhnxwvJKaiL6JOFQArjRYhkRtXdI/AJffFQf4iiuFA8DSZFaNiB4V2sJQvjWLC5LXv7To4eK2m7Cn0Q3RL9z7enwYRn0B5ilwxiF1D6IncyV5FkZprai4pJtHzgAm/IgjMgQnbTVmJjdE8NXMkBqzMsloYh7KV9xl4bPYAut60krcbTXWp7SG8TyeT77jZsCxjIe13JoBtvft+V7LWFfLqpmh39VwoS7VU3a0s+lV9Mqa9eT/2QPzPK7ayXLu2XF9jzUrzvcGJfI3ZutdmIoZvfYPtOffwVXFpP+yOiXrlQm+qCqOaQpYVecgx2nwvuvgYl1S8t/vgh5lWMIiWfzvK6iikzqyZdpHx+QzY90v1z8LWrJsJCfjctwfvXUXfFoNpu+jlGeiE3PPyBjhACB4v/Fr7JCa2pSSX7dF2lRf6PugCj++1gNKtuM/6Q83WzTnyFFEEA1fC6grmcDVJGt5XR6eKplgWc6BA+Fbe5TCr7QV2NCoQ1y+/vUwfgS3thzBWzEc2ay2kjDR7/a2u0/M0WqKwoQmNhhHuw4RF33Zbq+6rLcWaehc5dswDUGzqjuGA4ttLVKyQhiXtE7ugvesEwZNjdip9zmrRC+JvQ0E4CXMRo2OaT3nqYajY6l7iMWac7OsC0kkz85/jVKbyJq7fcH3JT3scXMhuSxpJMyhvTEx+zXrAQ8K1vxoo7kDHBbrqNYBJIvbb3XSO1LbjjvyQGoqk2/QjrHaBvtFqStTSNWFARPwNpGZljGrR7D
 H54jcsaA
 ukyB+FH5QupmQBS0p/RzSrPDRsDtnhfxMZ0cNKr2O4k6ize4K+L+w76ro4+Q+fx2+lY02dD2AbONbpSyHBlmR1njaNO0UsPBkhcp9eKyMsfolUu9NqZOCEE96O2N9kQPNpIJEQEbmAYgx9s4qrqq56VzzPWrDArlkN7PlzdHik2/9/N4p6kLlVSxx+x4FyQD351cRa1dJejYhYGMIneowi60i0i9yJ4eMOoheHizDiomaCtFLa2Blsr5BysOohiDp05WAQpC+47jg8zlpTNgsQbyT6ppWfG9394zkIk9cxNxZbrdWiQrjQixKsr/xTiXY8bjMFVb7YsXz4J0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 01:16, Barry Song (Xiaomi) wrote:
> We are doing a lot of redundant lru_add_drain() calls in
> do_swap_page(), especially for synchronous I/O devices. For
> example, the test program below currently ends up draining
> lru_cache 100% of the time:
> 
> int main(int argc, char *argv[])
> {
>         int i;
>  #define SIZE 100*1024*1024
> 	while(1) {
> 		volatile int *p = mmap(0, SIZE, PROT_READ | PROT_WRITE,
>                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> 
> 		for (int i = 0; i < SIZE/sizeof(int); i++)
> 			p[i] =  i%64;
> 		madvise((void *)p, SIZE, MADV_PAGEOUT);
> 		for (int i = 0; i < SIZE/sizeof(int); i++)
> 			p[i] =  i%64;
> 		munmap(p, SIZE);
> 	}
> 	return 0;
> }
> 
> Folio reuse now relies primarily on the exclusive hint, making
> lru_cache draining to drop the refcount in lru_cache largely
> irrelevant.

Makes sense, we'll fallback to do_wp_page() where we handle the non-exclusive
either way.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

