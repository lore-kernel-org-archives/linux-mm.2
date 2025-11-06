Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5758CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 11:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E32F8E000B; Thu,  6 Nov 2025 06:31:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BAD48E0002; Thu,  6 Nov 2025 06:31:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA818E000B; Thu,  6 Nov 2025 06:31:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E94C38E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 06:31:50 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 925B859C6C
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:31:50 +0000 (UTC)
X-FDA: 84079967580.23.3C38690
Received: from mail-lj1-f194.google.com (mail-lj1-f194.google.com [209.85.208.194])
	by imf04.hostedemail.com (Postfix) with ESMTP id 830124000F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:31:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cIup4KrH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.208.194 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762428708; a=rsa-sha256;
	cv=none;
	b=SL3kdcFat6pqIV1vttGTFUxwmj2dy3S7nEJ/5hMbPr3ClHRUg6qro3k8JtW0mzFvMbxdYL
	ZlqteM9PsuMqjz7ONvrkUBC6ccGtWCvPVoSDyRh3MG91LzsC5u1xTZBtm+aAfK/xxotpTH
	lL4J2/gh727mfuWeyNpFOnjsJayVNos=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cIup4KrH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.208.194 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762428708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v34V6UOuAW4algEbYefyR7s7Tf+M59sk/X8aCBcGIPc=;
	b=6x5kGFSKNd3pDo/0Bn7PXLy2rvYAL/YtJgE6/pdeJfUv0qlg0IvMsWKPaeZQjVT6xRkNrO
	OM9hHrfLrxsPVzLgT8zb7UvS6tvaqWTlfDKscn3vQSxlsqjLjOMM5XbDwVxCRm60OMR082
	3NrJhUmFajbMnoK1CkNxhxyt30f+eHg=
Received: by mail-lj1-f194.google.com with SMTP id 38308e7fff4ca-378d54f657fso7272201fa.2
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 03:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762428707; x=1763033507; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v34V6UOuAW4algEbYefyR7s7Tf+M59sk/X8aCBcGIPc=;
        b=cIup4KrHthlpfo/obX5VjKpVDy0z9eL3e2E/+kfGJUFgfPEfaYkYWSdUG6enDXB7lF
         TVWj+4YgMQ3qvDdaDeCiQpRMhrHxGaV8jRlYZlFLChdsQR14wALqfpwRFH8Wvma4VIYg
         t5Uco6mIj93RcAqozNMSbxYoQwRwW7pW1VWx3kv4PTNEzZPFx8peiNs1fif6BneZ1CVf
         UyLF0MRhltOEV1BT1rGIV3fNQXBccRLJNMQcYVubX+sP3dCJCv+FYp2NJ9v3cc5MnKQJ
         A1Q+0sTGmQ/S5dzg/gQ6DQPooUa4nV9xaaPyBXkaPmoCiE/6PDPsb79YbZ7MuxQbhepP
         blFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762428707; x=1763033507;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v34V6UOuAW4algEbYefyR7s7Tf+M59sk/X8aCBcGIPc=;
        b=L35/na96J+bQ3Kugbp+mLcfTXk56a5fgcrR3Eshek5bR5KgfeQt5jhjaQzK2AtmFGX
         qpwed78AEyZ+uXsiGiIdxiaZKofZnTIFwD1lBG08MVwbd5kb9PhrwJhFNAxohx/62IC0
         nVTnszNG7kAvXaHd2Xz2UcC4E4++zSwSjIG5lb/vt7h49X8MH3AuvFDkakYA1gwsDqAU
         eEkKDtHJILG4QzgXzFRfsB8cszB3IUy0qgD87cApSC+6h3/JNsYxcIXz4LbcfFpwZIVo
         /bVSh0wazc25XcNUDsboREjmezEZ56ze+IKktlVvEZOJXuvki+aFb7SupXsaEUVpNJfT
         1XcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUASMhwjxrc3bOgV9RQyk5K5qG4JMs17SCyQB38z0tI3TNdEemQrxN+w6yc7wuKey3puv9GqozoYA==@kvack.org
X-Gm-Message-State: AOJu0YzkNVDCo90vduD92U9PlOZueYb/EZ9KldpXAyD3mromTtYnG6Mn
	kCIXg6lQdmmtznB1Adn6zme/B3FPYvAf/pqqQP+TTV26s7poUKHcYFHxbEnVUOJm
X-Gm-Gg: ASbGncuc5xWn+NIOxA0JeOHCg5BUimkzWfeE7EcJigAMFSRV0Q0y095bdIYDW3inWfd
	dZfnMrZRJDe5GO+0tW9s0/wqngEYrjuix8t+SK39gO2sCpz9m/5X/ApnClcrmem8wUAvqXWT6Mk
	01dJo4hVijWCcarjyeuMXmIKTf3hBrM3Ft+AmVUoIv5vlycEqwb8b6p2chZIKn9l94nIYiQCONp
	mfO1PAwVb/1XtwuUvhI03dI8Sqg9vWVTKdge3JcQXRClpR6b1dA1MVvq1vpP2yVZnQ7IY9VnS/4
	g04JRARpJBwDAKHGnzblPsKs3VYcSPnU9cMZ6txKVWGQZprVmauUgPTuumShqaQoTh85a4eJDIs
	r9JZsH+92wWgdAifJj6nwPJJU4XHYtZwbOGPko2NuwodpwPxU37M6351Uinupf/eBguK77DB+Cu
	MCLJMcAF+vQHzJz6rUpqi8L6ZtxAA/tRUG7SpCg8SslQ9TsQQjcwBYwGQeWxK6P/UeEQMRIPO0B
	9diqE3DOlaQFWI4z7nwMxWctJ2ixIHAyc9jSOy0uQ==
X-Google-Smtp-Source: AGHT+IGIIzFUbwr8Yw2DpY4lrZQbFJ3COc7ijCkphFraNz8s3Ec0LQ/U2ePs+7AxsxoZH31PQrgUNQ==
X-Received: by 2002:a05:600c:46ce:b0:477:1af2:f40a with SMTP id 5b1f17b1804b1-4775cdc9053mr58862025e9.17.1762422432751;
        Thu, 06 Nov 2025 01:47:12 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775ce32653sm97818805e9.13.2025.11.06.01.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 01:47:12 -0800 (PST)
Message-ID: <2b9fa85b-54ff-415c-9163-461e28b6d660@gmail.com>
Date: Thu, 6 Nov 2025 10:47:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -v4 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
To: Huang Ying <ying.huang@linux.alibaba.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Yang Shi <yang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Yin Fengwei <fengwei_yin@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251104095516.7912-1-ying.huang@linux.alibaba.com>
 <20251104095516.7912-3-ying.huang@linux.alibaba.com>
From: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Content-Language: en-US
In-Reply-To: <20251104095516.7912-3-ying.huang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 830124000F
X-Rspamd-Server: rspam07
X-Stat-Signature: ery65eyjoa1f6g5wker1cjhzamc3517w
X-Rspam-User: 
X-HE-Tag: 1762428708-138873
X-HE-Meta: U2FsdGVkX18xi6motFnCaRdxmZAy4Y2pgHm3HY9mSifBizrU5EAI3+/C2TiIVnltFnigYbMul4BctAFZHdeTfLVe2C7f0G45f1SHO7zDtRAVLsW/0lQhVqx5nkhj9dn72KZSFjnTW9igdlaxf4jYhlthI1UefsVQokLPbf7ykdKp72T6Cdd4GyB6tz3Q69WkHhd43xSPwkAl8tFh/h6BTXHTkoyTOjixbsG66Ke8HtoFM4CzKShwcrDcmxmEFqqrxlmz143xxvHkJ1dfEpnmrT+ojuMZJrdynC3k20h5iR/HmHrzZEl9l7z4h3BSL9Mfj5cJd0vHKlPzwszM/9CKFsLluuERiuvs8iRwhl5G2AQE65QS3pgbOyQLJCgrm0sno2bvHJvAkOw/YNNNvoCWVfXiDh5jKyEe9InxzOCyxzoGXnwKtJKetcr+fiYJW22aSKFqKMm1k/TRdJvCwWz3clrFYHwrEOWHTrpHDCbncjwCAiVG6ldAuL/DEhAUC+PFEVs+1rzXwbV4aBP46KRict/N4McVf9gzpOSR9nnbhrtxBBq1Sha26gyK77qmuVEabOvziAC8+AC/8Tl/O1doxc4bkyynB8QvczGP3l+5a0YZpyKf4fOxdQLJTJWaHuZy26thbaRZYTXKVWXVtMnTzezYZc1o28eHmeCqE0M6AVf2lg+MWos3Oe4J6IPpiTJ1rLrP0HMDYlP7C9jT460/WVekFccAiv4rX8bRAYMnvXZm3ZrNzO2C5K2Hicji9Y57VBkpqIV9vQMlQmNYa+VtD5WgyT9XXV+A3Qvax/FZPc4tVGTjDtt7M4GuZamARNhU89CNAVmMRNAqw2YZIT+BDLMhD6djZyUdQL0xWskyfJD9eqUlqrWrYGklaG2wOSUEvG0HPjxVfr05SFQR8ffiBfxCEETV1B01VELmceqqA0RpofxplR0wXD5SYk4FU19vuw7tLWkhPQA5s0l/6Ws
 8suxbPs9
 F99EsS3yi8Lv/ZJnB0WxUKvgPb2hnhl3dA2lxE1qAKwi+b9EOI731DBscc7hE5lCqVscEkjfaSTEmZBiLq6k0vVsfmBenmzlrDcvgpf3xn2FxIpt1J9qeehifAJ88qFK5sdCGO3dIZN4OWlDD2c3k5u4oz0HYjlapgXPA/NCjXkhBKS7U3uSc49W8iwIMDQKgDGBL8+4l03nB4DmSe7UYIvz0LbOpn+F445uWgotsasYYEFgxrX5o43C018BFslj9U7266UsIQyVpFmxzZmdy4GSbemKh1ZAzssPmBNOQsNyE7aj/KJyf3VRQoAz7dwcb3zNbT/Nnge8rbPmQSCsS8QLuqosVnDwlB63L2ztpDQ9kt3F3pqecPDQFrHK25FLa3eu9OszZ1p7mJGcgpfu5MmE/QNZMcbLKhFZ7ORRrjJl7Ttmb+LWB9wIbHWEKCXtAAq5gpSodKWLiqR2cKMRs9JwOyNmp0LKSTW3bTiQmAkHx0qTgKo6H1fL5Br0hQDMwTmq5pXoFYHqBl9k5yOeVk24guIhOypKY1ww84m4oA5USYTCjjB8d4EG/P8hcq7PanH9RxoxQZCB1FRNJ8HOOOY/Wog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.11.25 10:55, Huang Ying wrote:
> A multi-thread customer workload with large memory footprint uses
> fork()/exec() to run some external programs every tens seconds.  When
> running the workload on an arm64 server machine, it's observed that
> quite some CPU cycles are spent in the TLB flushing functions.  While
> running the workload on the x86_64 server machine, it's not.  This
> causes the performance on arm64 to be much worse than that on x86_64.
> 
> During the workload running, after fork()/exec() write-protects all
> pages in the parent process, memory writing in the parent process
> will cause a write protection fault.  Then the page fault handler
> will make the PTE/PDE writable if the page can be reused, which is
> almost always true in the workload.  On arm64, to avoid the write
> protection fault on other CPUs, the page fault handler flushes the TLB
> globally with TLBI broadcast after changing the PTE/PDE.  However, this
> isn't always necessary.  Firstly, it's safe to leave some stale
> read-only TLB entries as long as they will be flushed finally.
> Secondly, it's quite possible that the original read-only PTE/PDEs
> aren't cached in remote TLB at all if the memory footprint is large.
> In fact, on x86_64, the page fault handler doesn't flush the remote
> TLB in this situation, which benefits the performance a lot.
> 
> To improve the performance on arm64, make the write protection fault
> handler flush the TLB locally instead of globally via TLBI broadcast
> after making the PTE/PDE writable.  If there are stale read-only TLB
> entries in the remote CPUs, the page fault handler on these CPUs will
> regard the page fault as spurious and flush the stale TLB entries.
> 
> To test the patchset, make the usemem.c from
> vm-scalability (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git).
> support calling fork()/exec() periodically.  To mimic the behavior of
> the customer workload, run usemem with 4 threads, access 100GB memory,
> and call fork()/exec() every 40 seconds.  Test results show that with
> the patchset the score of usemem improves ~40.6%.  The cycles% of TLB
> flush functions reduces from ~50.5% to ~0.3% in perf profile.
> 

All makes sense to me.

Some smaller comments below.

[...]

> +
> +static inline void local_flush_tlb_page_nonotify(
> +	struct vm_area_struct *vma, unsigned long uaddr)

NIT: "struct vm_area_struct *vma" fits onto the previous line.

> +{
> +	__local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
> +	dsb(nsh);
> +}
> +
> +static inline void local_flush_tlb_page(struct vm_area_struct *vma,
> +					unsigned long uaddr)
> +{
> +	__local_flush_tlb_page_nonotify_nosync(vma->vm_mm, uaddr);
> +	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, uaddr & PAGE_MASK,
> +						(uaddr & PAGE_MASK) + PAGE_SIZE);
> +	dsb(nsh);
> +}
> +
>   static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>   					   unsigned long uaddr)
>   {
> @@ -472,6 +512,22 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
>   	dsb(ish);
>   }
>   
> +static inline void local_flush_tlb_contpte(struct vm_area_struct *vma,
> +					   unsigned long addr)
> +{
> +	unsigned long asid;
> +
> +	addr = round_down(addr, CONT_PTE_SIZE);
> +
> +	dsb(nshst);
> +	asid = ASID(vma->vm_mm);
> +	__flush_tlb_range_op(vale1, addr, CONT_PTES, PAGE_SIZE, asid,
> +			     3, true, lpa2_is_enabled());
> +	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, addr,
> +						    addr + CONT_PTE_SIZE);
> +	dsb(nsh);
> +}
> +
>   static inline void flush_tlb_range(struct vm_area_struct *vma,
>   				   unsigned long start, unsigned long end)
>   {
> diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
> index c0557945939c..589bcf878938 100644
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -622,8 +622,7 @@ int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
>   			__ptep_set_access_flags(vma, addr, ptep, entry, 0);
>   
>   		if (dirty)
> -			__flush_tlb_range(vma, start_addr, addr,
> -							PAGE_SIZE, true, 3);
> +			local_flush_tlb_contpte(vma, start_addr);

In this case, we now flush a bigger range than we used to, no?

Probably I am missing something (should this change be explained in more 
detail in the cover letter), but I'm wondering why this contpte handling 
wasn't required before on this level.

>   	} else {
>   		__contpte_try_unfold(vma->vm_mm, addr, ptep, orig_pte);
>   		__ptep_set_access_flags(vma, addr, ptep, entry, dirty);
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index d816ff44faff..22f54f5afe3f 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -235,7 +235,7 @@ int __ptep_set_access_flags(struct vm_area_struct *vma,
>   
>   	/* Invalidate a stale read-only entry */

I would expand this comment to also explain how remote TLBs are handled 
very briefly -> flush_tlb_fix_spurious_fault().

>   	if (dirty)
> -		flush_tlb_page(vma, address);
> +		local_flush_tlb_page(vma, address);
>   	return 1;
>   }
>   


