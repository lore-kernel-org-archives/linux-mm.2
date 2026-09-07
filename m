Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0E82C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856C96B0096; Mon,  7 Sep 2026 08:08:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0876B009B; Mon,  7 Sep 2026 08:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7D26B009D; Mon,  7 Sep 2026 08:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3753E6B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:08:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C564480149
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:08:38 +0000 (UTC)
X-FDA: 85186844316.02.3D90B9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 044F61A000E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:08:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHI2LGgs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788782917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F9XAOyQk7CNSeFwQo5G/rrbyMC4zTPJ5fNDWbA7bGIs=;
	b=CetfFaafHGvmWvWtQtgs0qooWiAjWskgKqCYecwHwJIL1faCVi/jPBpXeNPEFN8P7J2dp/
	i2mXn1e24naVxqvLL7HMi2F+JoyQOnvvW7byuylA5KkxlwEdlKI1ERlUTDUaw8wRIu5wLE
	TDj4YIOOzNPEgfjkJ5J+CAWnHWGZ4wI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788782917;
	b=6Pd7fQncmjfePerQVhw0+PekoX4CkPO1xUSpYSACYxICIvgvE2QyoT+qdexy+YtsLQl86S
	q6K1yLq0nc8KYBAQwFMp9P6ZrjV88PwHSlCz08P4BK023KQaccZQpDNa9OtTz3nvRTaZyo
	i72c/6VWHgHA1i7w48sR2g32wyodx1I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHI2LGgs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF26260AB5;
	Mon,  7 Sep 2026 12:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996AF1F00A3A;
	Mon,  7 Sep 2026 12:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788782915;
	bh=F9XAOyQk7CNSeFwQo5G/rrbyMC4zTPJ5fNDWbA7bGIs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HHI2LGgsBNcP3wHm+ZHe+TykMyXyGu727qZBKl7DzmjgYdw+ARUi7d69Qp6mTWUoN
	 /83aYQoussugnC50w8VYBKyxjQt+UaulYFtdVesOhLX5ekL+hx/P842uB2AF2oECPz
	 Gk1r92mUrJDbDiMjTHvUoUknpOW0TEPePsd+GtQLaYnNWAKxJpqYumeE9Gq6+vcWIp
	 p7aYNNrXv7dNx6rm67s5skihcO/irlV9g/LuCf7ONnqU/yVnaJzPdhRYbuxGbjHpBn
	 IODmCxxQYgDn80rPCXKyr0Pwuc2MPEBeJBSc3c5mJcZeGXln/cTOFKlvKc0UmQ4zfp
	 r/n4WmgQTPM3w==
Message-ID: <5140ad5d-a024-4df9-8e1c-b702433821dc@kernel.org>
Date: Mon, 7 Sep 2026 14:08:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/memory: constrain generic_access_phys() to page
 boundary
To: Ren Wei <weir@nebusec.ai>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 notasas@gmail.com, vega@nebusec.ai, rakukuip@gmail.com
References: <cover.1788531737.git.rakukuip@gmail.com>
 <eaa4de66f9491888e0ffeb2d37ba7ae796ba535e.1788531737.git.rakukuip@gmail.com>
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
In-Reply-To: <eaa4de66f9491888e0ffeb2d37ba7ae796ba535e.1788531737.git.rakukuip@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 044F61A000E
X-Stat-Signature: i3d3zd3fcs7qr6rpy17wwsws34qt74yr
X-Rspam-User: 
X-HE-Tag: 1788782916-607921
X-HE-Meta: U2FsdGVkX1/Vg0CQMXzhk50wayiK1U/EqC3KhsZF2rjWkQR9uRaIdI1dSshwXfblKitIO4hWygIkEnL7967OfE8lQ7QsnRk2/BlP2vK6xnxXw9th2xRqjlumVxPLHmWG/5Dl7+32AfXNxJa15wsetr/Z3ZHn/48eaIRluvejvF0QeAoOD9QxzIM9z+D4nc8LckKoOzvODyJur2TqW8WirDKjBA2Sg63a0je7W0UhZmi+GWkVOc2ltHIdjNMVjd6N0Jrmie5dbwSWB6XGWHVkNPWdpCzcYsNT7F1d7APQLWVxMbQwG7KSm7dgw9KSGetvbouk9ziqpQqs5xi48WPCKRhc/Gta2h/ujxsA5CsZrWb2fjH6+bvrx6P7EJhQge6CI6zUBE2d+w75k92DY4D39iZau+fb7m3ve7Tf3gHkYZKXYq4m6vRnpDpwtGf9W8h8RmrpYQ9vsXq7ulT1x4h5p2QzY0U5+gQ0xPJhUwAO9noGKAwaMiaEyOswvFV74BwmYFkCNCEIhShldHLSG3perSbHsGNTsZnZkNFMro4JiWnmpIX77LzzOXOjRB4zA52swXQ6ndLjrg0a679uEGmjwlgomG2d6r6PaePmlHuInRj4chYv0N4bSNW4LL7uF+RFez50pWvw733oqd13uZkm8wSmihjPM94wKUInh+IGhWzDOOxpq49r1XaYbZzZaqZSG2HtjsvtjARY1x5h8GJcbufAiW00x7gTfQE1uN51e8SfY/qYaXNKpZ25gTAxF06subrSk0WAi+IfR2Gh2L0UHPhgZl+DcvGVgIGmw+ag41PV4J+C+X+YF8luKlXURBjSTLnJ5DxuQ96UXs7B4gJUVYv0T+mPtKeXqG1JkjVbYOD3kR0XO2MJGYNzJ/C14PRJt3QUvqv1oodn9QnFE0ygEhNiPQxWrc5sz8EVTfB1nrJhrpym5DZDy+lJ5GdfKFTTzGinqmodfvJwcnI/yy9
 0m2RoKdc
 8fL7LqqpP4V4fIRNEZSoNx7QkFspxSNqKFKJB5P9QyM4LF+viKLY4CHAGjq1gB60nzYBkC0Qc8b2/HBSNhhSwoFPWns4zhQ+NWDUUvFGdwddVhIJjkNWJfZlvbBMKbvGk0yPb7kuBrrGcfsIDgXM9MQIV+PLzcdblBjsBFEDnxkjBP57egEy53K3vhxeG15Di4C5e/RBHT+oWW+FVBFi8W+j69zJ6KwoAeaRLehH1YmsqxcTItLFgy5vJrD9Cd9H8KVLQmA5CS8TSkssCJTwILkzuNXa6rG4L5glyZyCESXDBlNqiu//9FwihrenTloHvojETHd/x5xctgWMtGFxUFoGFzTLF3ahpGlJH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/5/26 16:12, Ren Wei wrote:
> From: Luxiao Xu <rakukuip@gmail.com>
> 
> generic_access_phys() improperly validates the memory access range: it
> only validates the start address using follow_pfnmap_start() and passes
> PAGE_ALIGN(len + offset) to ioremap_prot().
> 
> This poses two problems:
> 1. In PFNMAP VMAs, consecutive virtual pages are not guaranteed to be
>    physically contiguous, and individual PTEs may have different access
>    permissions or writability.
> 2. The mapping may cross VMA boundaries if len extends beyond vma->vm_end.
> 
> Since __access_remote_vm() already loops over the requested length and
> accesses normal (struct page) memory page-by-page, constrain the ->access()
> callback in __access_remote_vm() to at most the current page boundary.
> Because VMA boundaries are always page-aligned, this also ensures the
> access never exceeds the current VMA.
> 
> In generic_access_phys(), defensively clamp len to the page boundary as
> well, map only a single PAGE_SIZE via ioremap_prot(), and add a missing
> (resource_size_t) cast during PFN re-validation to avoid truncation on
> 32-bit PAE systems.
> 
> Fixes: 9cb12d7b4cca ("mm/memory.c: actually remap enough memory")
> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Assisted-by: LLM
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
> Signed-off-by: Ren Wei <weir@nebusec.ai>
> ---
> v1 -> v2:
> - Drop internal multi-page loop in generic_access_phys(); clamp the chunk
>   size in __access_remote_vm() to PAGE_SIZE - offset instead, leveraging
>   the existing caller loop (David Hildenbrand).
> - Defensively clamp len in generic_access_phys() and only map PAGE_SIZE.
> - Add missing (resource_size_t) cast when checking args.pfn (Andrew Morton).
> Link: https://lore.kernel.org/r/f618e2f57ad0086a8d7a95cb17dcf5a1f0cf0e45.1784428532.git.rakukuip@gmail.com
> ---
>  mm/memory.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 8b0c2c735d3d..09390e51432f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7164,6 +7164,11 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
>  	bool writable;
>  	struct follow_pfnmap_args args = { .vma = vma, .address = addr };
>  
> +	if (len <= 0)
> +		return 0;

Why is that required? Why would it be valid to call this function with a size of 0?

> +

We should add a comment here explaining the situation:

/*
 * Limit access to one page at a time, as that's what follow_pfnmap_start()
 * guarantees; expect the caller to retry to read larger ranges.
 */

> +	len = min_t(int, len, PAGE_SIZE - offset);

Do we really need the "min_t" here? (can't we use min?)

> +
>  retry:
>  	if (follow_pfnmap_start(&args))
>  		return -EINVAL;
> @@ -7175,7 +7180,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
>  	if ((write & FOLL_WRITE) && !writable)
>  		return -EINVAL;
>  
> -	maddr = ioremap_prot(phys_addr, PAGE_ALIGN(len + offset), prot);
> +	maddr = ioremap_prot(phys_addr, PAGE_SIZE, prot);
>  	if (!maddr)
>  		return -ENOMEM;
>  
> @@ -7183,7 +7188,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
>  		goto out_unmap;
>  
>  	if ((pgprot_val(prot) != pgprot_val(args.pgprot)) ||
> -	    (phys_addr != (args.pfn << PAGE_SHIFT)) ||
> +	    (phys_addr != ((resource_size_t)args.pfn << PAGE_SHIFT)) ||
>  	    (writable != args.writable)) {
>  		follow_pfnmap_end(&args);
>  		iounmap(maddr);
> @@ -7254,7 +7259,8 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  #ifdef CONFIG_HAVE_IOREMAP_PROT
>  			if (vma->vm_ops && vma->vm_ops->access)
>  				bytes = vma->vm_ops->access(vma, addr, buf,
> -							    len, write);
> +							    min_t(int, len, PAGE_SIZE - offset_in_page(addr)),

Why isn't it sufficient to cap in generic_access_phys() ?


-- 
Cheers,

David

