Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F15CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 11:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABC1F6B008C; Wed, 13 May 2026 07:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6D9A6B0095; Wed, 13 May 2026 07:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95BBD6B0096; Wed, 13 May 2026 07:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82AAC6B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:59:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2253C2D70
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:59:28 +0000 (UTC)
X-FDA: 84762251616.12.8B038FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id DA538C0006
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:59:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pQRkZCsc;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778673567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17rukVLHk+DJeL8wKqxEo4jRB0nLVk9gXZm8IsIg07k=;
	b=Qtrf6LUcwsNpqu3HDqXazylYYVOzmhE4TVB0qdWFm7KPc1L+d7gy8o9kHHLwMOlzGgogF7
	JqCnS0WLxLpOUXQSMEDrTItqwyaJ/mHWUPZyGS1Exii31Sdd+iyVMA22fmLenB30PJ4WE9
	zgP1YLG8pHwJey64/zZQGOP4XF9E5/Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pQRkZCsc;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778673567; a=rsa-sha256;
	cv=none;
	b=SaYTFq3euT4H31/zTRf+8VwVvVCsSoyJ7W2o30Ru9OQlm+4L77ZzN64QeT3OuV1q4u/SUK
	wSDH80W9ea4p6fSmWht5IFx8QThiLK7PiICA+h0umXErr9tSloi3dsViMsmwWXq6+OrkMO
	3BPSpsqB/KsY9a4lS0QlgbLJS/7xG3o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F05B643C41;
	Wed, 13 May 2026 11:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830E0C2BCC7;
	Wed, 13 May 2026 11:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778673565;
	bh=UJ/dC15x81Krq9CH6Oe1MEmvSTSXAsmGq+YMEAUoP5Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pQRkZCscfQZI5aynKVo8uOVACYP4uYWj2GqTzOcN7XWNsTgmFSBWnXlhPZCylv2AK
	 qIZuAxVnO4KLBaVeh00spbVj4QZUqOtXbaAhjRfZUrxSG2zaFfSH7OMsoUIi6dSqd9
	 ES/f3+83sgK205dgQyaK4cux4Q4V14nYZC4pTQFmuYfns2uVPEEWLPhcIyu0hqTsOM
	 Ym/YYpdphctQ24h63IbFAqCZSAYnbNYIGou9N81iqNyCztgcNlvUQsAba+sIKLeaUm
	 cQMW1CTQN1FnffyNdvKl3yPuEl0MWWrqdGOBD4dhFzxwwcJtaQdybZBADHIrc2rSsY
	 ZhHi4dC0LxiVA==
Message-ID: <0e2a90d7-8b0b-4d04-9c34-9a82294fee9f@kernel.org>
Date: Wed, 13 May 2026 13:59:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] ksm: add vm_pgoff into ksm_rmap_item
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, michel@lespinasse.org
References: <20260503204843889ik1YHe8LX_5N0Neyn0ner@zte.com.cn>
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
In-Reply-To: <20260503204843889ik1YHe8LX_5N0Neyn0ner@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DA538C0006
X-Stat-Signature: aa3wz3xpr53kez3zsrgsybxbxdu4wrko
X-HE-Tag: 1778673566-733341
X-HE-Meta: U2FsdGVkX19B7V1Z6xVDtbAEEGJJRVyuh9F1/ouHePy07f7iCQrQypMtuPMZqs1XAxiGFMNviGwlN8+oZnUMpaRoxjnsDCy1joj5wVfcNPPwbf32Yx71ISbr27CBb+xYxVP4H9BjjcL/H5uMIOuy+pf/qxD2ZgFkEhyuqGjaM3RRiQnPE0ifruTqxXX1kEKJUqkF6g3rjx/7hfeU1L5zWNl9DN28glMSVSXLDiBmMjfr6RWlz6w2gm+GfP0WkQ3LiVaM/7gURRr55uY/lQkAKYW1rtyJIjjG5PGtzQnqceiWTMwU/V1G/3ARlamSzEOfNtQLKR0eia4TmSVsr9RbZO9dXPK7koZT9TEBKmkRdRUP5AS1Wha03X2rALFvpFGEP82by5fSNxD4rqNJZP7hN0Avk/H0F9vvIZSWREXQFRiUqyHfHYNxAdhTxuhnN0baLsvzra36cydkLaEP1ypG0ywdnSFTvYsdpkRYjEESCwg/iyzjck/t39doNSNZAXPvIql1j3q/YB4MPkj7+blfEmRu6y6WJWRHXKmrmd7jdCYn71ERLEqGX07U8A3eAsk1XFwWC6166ngnSZLMJ+Ms0MhXF2Wj17MTK2L5uB1xKfhpxrjpvOxN5xCMu7u4TrUtNGMe8Y5n+F0sJK789aZWXUY/tD1VpUF1JIDZwg6xwAStc6zMo3cd0H+SKu5dtCahNrrhix7GUlzBxWOtbUxjVI0NF+bUR3KRLIVblMXjhijPcRB7OK0NfOnP2dQvo1HnTqRl4LzW/AuA0BzHz3jLr4LbON+fBEzfoxa/7JFWHID3TV8NEC/Zd0K3GdYj3Z5ahkf09ncM4fkcifQE79kfesaKwok2sydVqJMfDNCq/GChZYQ6JjZ0KzxDQqOX4anBE7UNfxHoMGGYKc90jrTBeAkQ2ajHbOoQVbp6e2Gl48LrJXhZFVHk4EzovUBP3f+0/7Ic2QLcAlkOB7Oi2P6
 v+2X7z/0
 Cc1u6c/89qe3usPEQ2u3JKh6M/bkLXLpsxT6xDYj7P+fCZ+EH8tB95uKpHPwTbFv8KOvTitaB4AeWvKjZGnFv4m0hYW0vJsRspUvkxaLcQ7zbqltLY1aj9dJzMGAW05atOJQU6euQ5BAxrxf4W/u0U1IMNWXWzi6qEAD3lMonHjxiyNqu5xL+AHX0/ExHqnirsDbHKt9XraNJ0qnsaz0x/JrOxb9ksC6Y6XEaWX7GB4n3elkG9fCgJgR4oVEIunTNJJt1LzUwCKcZfaHu3BLBuWNUaZA+9KvfLOJX4i2COTlMaLGlpCVNMC6SudUjsoBsVtVAyAkbBVUzEx0ZNe2gqXdcdz4PcObdcyKKoKylRiUifwrQCmDcgn5+UmVqjokZJRx/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/3/26 14:48, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> The reason for adding vm_pgoff to ksm_rmap_item has been discussed in previous
> mailing list threads [1][2]. The main purpose is to allow the KSM reverse mapping
> to obtain the original VMA's vm_pgoff, so that during anon_vma_tree travering, it
> can conditionally locate the VMAs and avoid scanning the entire address space
> [0, ULONG_MAX].
> 
> To minimize the size impact of adding vm_pgoff to ksm_rmap_item as much as
> possible, a trick that David suggested is to use a UNION that groups the members
> related to the unstable tree together with the newly added vm_pgoff. The members
> that valids only when in unstable tree include oldchecksum and age information.
> However, the function should_skip_rmap_item() in the smart scanning needs slight
> modification, since this function still uses the age information even when the
> rmap_item is in a stable state (the page is not KSM), a situation that occurs
> during COW faults. After using union, the size is still 64 byte without increasing.
> 
> The setting and resetting of rmap_item->vm_pgoff are similar to rmap_item->anon_vma.
> 
> [1] https://lore.kernel.org/all/adTPQSb-qSSHviJN@lucifer/
> [2] https://lore.kernel.org/all/202604091806051535BJWZ_FTtdIm3Snk24ei_@zte.com.cn/
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>  mm/ksm.c | 41 ++++++++++++++++++++++++++++++++++-------
>  1 file changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..0299a53ba7c9 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -195,22 +195,28 @@ struct ksm_stable_node {
>   * @node: rb node of this rmap_item in the unstable tree
>   * @head: pointer to stable_node heading this list in the stable tree
>   * @hlist: link into hlist of rmap_items hanging off that stable_node
> - * @age: number of scan iterations since creation
> - * @remaining_skips: how many scans to skip
> + * @age: number of scan iterations since creation (unstable node)
> + * @remaining_skips: how many scans to skip (unstable node)
> + * @vm_pgoff: vm_pgoff into the original VMA where the page is mapped (stable node)
>   */
>  struct ksm_rmap_item {
>  	struct ksm_rmap_item *rmap_list;
>  	union {
> -		struct anon_vma *anon_vma;	/* when stable */
> +		struct anon_vma *anon_vma;	/* for reverse mapping, when stable */
>  #ifdef CONFIG_NUMA
>  		int nid;		/* when node of unstable tree */
>  #endif
>  	};
>  	struct mm_struct *mm;
>  	unsigned long address;		/* + low bits used for flags below */
> -	unsigned int oldchecksum;	/* when unstable */
> -	rmap_age_t age;
> -	rmap_age_t remaining_skips;
> +	union {
> +		struct {
> +			unsigned int oldchecksum;
> +			rmap_age_t age;
> +			rmap_age_t remaining_skips;
> +		};			/* when unstable */
> +		unsigned long vm_pgoff;		/* for reverse mapping, when stable */
> +	};
>  	union {
>  		struct rb_node node;	/* when node of unstable tree */
>  		struct {		/* when listed from stable tree */
> @@ -776,6 +782,10 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
>  	return vma;
>  }
> 
> +/*
> + * break_cow: actively break the write-protect of the VMA. This is calld when

s/called/called/

But why are we changing the documentation as part of this patch?

> + * rmap_item has not yet become stable, but page has been merged.
> + */
>  static void break_cow(struct ksm_rmap_item *rmap_item)
>  {
>  	struct mm_struct *mm = rmap_item->mm;
> @@ -787,6 +797,8 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
>  	 * to undo, we also need to drop a reference to the anon_vma.
>  	 */
>  	put_anon_vma(rmap_item->anon_vma);
> +	/* Reset pgoff that overlays age-related information. (still unstable) */
> +	rmap_item->vm_pgoff = 0;
> 
>  	mmap_read_lock(mm);
>  	vma = find_mergeable_vma(mm, addr);
> @@ -899,6 +911,8 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
>  		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
>  		stable_node->rmap_hlist_len--;
>  		put_anon_vma(rmap_item->anon_vma);
> +		/* Reset pgoff that overlays age-related information. */

AI review says that this might not be the case on 32bit. So I guess the comment
should be

"might overlay"

> +		rmap_item->vm_pgoff = 0;
>  		rmap_item->address &= PAGE_MASK;
>  		cond_resched();
>  	}
> @@ -1052,6 +1066,8 @@ static void remove_rmap_item_from_tree(struct ksm_rmap_item *rmap_item)
>  		stable_node->rmap_hlist_len--;
> 
>  		put_anon_vma(rmap_item->anon_vma);
> +		/* Reset pgoff that overlays age-related information. */

Same here.

> +		rmap_item->vm_pgoff = 0;
>  		rmap_item->head = NULL;
>  		rmap_item->address &= PAGE_MASK;
> 
> @@ -1598,8 +1614,15 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
>  	/* Unstable nid is in union with stable anon_vma: remove first */
>  	remove_rmap_item_from_tree(rmap_item);
> 
> -	/* Must get reference to anon_vma while still holding mmap_lock */
> +	/*
> +	 * Must get reference to anon_vma while still holding mmap_lock,
> +	 * We set these two members of stable node here instead of
> +	 * stable_tree_append(), maybe because we don't want to hold
> +	 * mmap_read_lock again? Here mmap_read_lock is already held to
> +	 * find_mergeable_vma before merging.
> +	 */
>  	rmap_item->anon_vma = vma->anon_vma;
> +	rmap_item->vm_pgoff = vma->vm_pgoff;

I suggested to use the actual linear page index instead at [1]. Storing the
vm_pgoff is wrong I think.

[1] https://lore.kernel.org/all/5401c1d2-5f42-4288-9dad-2b9768b579c7@kernel.org/


In another comment I said:

But it's all confusing. Because we might temporarily have rmap_item->anon_vma
set on an rmap_entry that does not yet have the STABLE_FLAG flag set through
stable_tree_append().

And then we magically call break_cow() which does a magical

	put_anon_vma(rmap_item->anon_vma);

(this doesn't look correct in once case) ... anyhow.

So we might want to reset the pgoff there as well, OR only store
the pgoff in stable_tree_append() where we actually set STABLE_FLAG.


So I guess we have to figure that out as well.

-- 
Cheers,

David

