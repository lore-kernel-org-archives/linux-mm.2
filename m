Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D056EE0AEF
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 18:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38FC76B0089; Sat,  7 Feb 2026 13:08:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33D366B0092; Sat,  7 Feb 2026 13:08:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232A66B0093; Sat,  7 Feb 2026 13:08:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 11A836B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 13:08:39 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3E1F1603BE
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 18:08:38 +0000 (UTC)
X-FDA: 84418445916.04.AE65DF0
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84A75100005
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 18:08:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MD8jZ7ev;
	spf=pass (imf05.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770487716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ADLwV8JZcYp0DC0E2IUjZFGMdOVavU1OQrQeFgMEqOc=;
	b=3Eus7EpCuSQ02V0NXcBAgsEVzOqpcfclKcwIyxa/rcS1qGtV5WTcdzwDNUIicI08IEFqNW
	OHyH9HsMlmSyqy7wS6b0ZKOiceTtWN6CBOstkP1O/l7FBH0kXYqQE5EfLJIMCaqflA4wPg
	Kv2KN7jIe0ODr1YnMxUw+w6cjYKHlwM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MD8jZ7ev;
	spf=pass (imf05.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770487716; a=rsa-sha256;
	cv=none;
	b=CwIQ85OOcQ9wdagYharvSjN6JSK66J9a6CXC8eANWjucZQDoeiacMF/sNih3d+ArOZMd+D
	GtjSqMs1WDaXsJZzZ5sZZAqP4FOmhWPvnWcJEerxZgMeV/NA+473TL+e6ax6SgrxqcNdcm
	t1dykKjYn1LnFbjNLFw9ibJCJmw/HXg=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4806e0f6b69so24356215e9.3
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 10:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770487715; x=1771092515; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ADLwV8JZcYp0DC0E2IUjZFGMdOVavU1OQrQeFgMEqOc=;
        b=MD8jZ7evlElxtxGqsbV9UKjtC7u7nLaB/T2VItlEhEHGtzfeanNcCpxTRsak0IkM7e
         9Jq0cpDXMNR0on8g8V/shoSnZmsBdf6U1C3IXXv+WqSpZCw4oPo+XQItu4Vc8z7SRYzQ
         vyAjnoW4zVmcnJUsp8VT1MUrzCqdGsqSg9arbt12m7GJmU2CxmsG/EmNKyrufXjIVojt
         TuH8rzNECzL1g0BmmsxJyvnHqPwSod1aboymvmldzCIya+OqVKW/WoBpyHoMcCb1nkaJ
         Vl1iFLoU9UtaDotas6zPnxP2DCflNDNOxND2jK1h6Bv5HY3sNwPfgyzD+s/yfBpBnnEL
         YR4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770487715; x=1771092515;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ADLwV8JZcYp0DC0E2IUjZFGMdOVavU1OQrQeFgMEqOc=;
        b=Vqcj1jdeTwcQrWQeNEdlZCjnTOe1yh8s8edlixenVirZLXGcEjcmBLwfvgUqJsUAsi
         XG0z/leo6PAPtHxQdZOQqj3FWFFJX75qN2lSCfi96k7Fw4uhTZDX7wOj77i1iNDciVnd
         I+ovMpZ2vhGc6uUz1sc/FlASQRuZ9DBQcu3NsILedokyDXTJiDtQ3YZzsYz0wMRfjYL5
         6ArsrvEz1BFG0FbeF+75usI4vWqRvapIQGW8JOl/g0M8A1RbsBCdd8wLl2KxChUqYkw2
         4u5GzsUaY5+gaQxW/YQigatuf/330g3vlER5Aimk/CgCYfsAViF+XHgI1RYGx9j8GbtD
         kkDA==
X-Forwarded-Encrypted: i=1; AJvYcCVo/chNH7r5pEvIr2cwj7R3rXT4DOq4S92xIdCPd1LB7gDgukumKImcIxd7SGw/65FxoW+kv+JChw==@kvack.org
X-Gm-Message-State: AOJu0Yz8wmo7yCHh5Mv4xkvkLQb1Zc7mnaS0ioQtmHqJMMeGg4xa+F0L
	FtJ2QG9BVDkp0U0SoIvp3Ay9tjvhe+wKw9+wraB6HWM5hgsaceUtO0/4
X-Gm-Gg: AZuq6aK1mLtm29C1bDHjFNUjCrcqr0fIpo4BAeRJrb1qtuRH1d76rpaqVJqSQj+ELGw
	pXKuIu/RbFu43izwap7iKrhZO3gtE9dUsgp0c9Xy96KYo1puNB5KmnHSoZAt6OMBq8ojux3JnAm
	NvFknxUYPZ9WP5xg+RmEVRMt35wfmSNIy8YwwhwGsUFQJR3mYtrXURUQ6mUl2n66teK5LmFo2XC
	DBtfX5nVjkPNO9lVBu87H8qFPNoBTEGQbwXE3q719LJpjtxtVRdA/AyMd0tTviRHQEALLeCp+Pj
	brxTeX2MHBZt8mMXgEkB53mbDxGzuOXfM3bbiEleViM6rYReTCwSzDdkGqSIH8sQrFEhyZdDRcT
	qThSAkUExcvz5k07V2ak/zgFnyjJ/gWFiDcidqYcryn0pEFBrmR6TSCgNXg/4XJUdcdIdTWdDhR
	Qakt787vfdYRkRoiYcOzRdctGEBZjSc4kI09kXMk8eIH0LZ4Ex+sWTqWEzK1hhw1AaJRdc2vk6q
	8KsYc+guS9PU+g=
X-Received: by 2002:a05:600c:4f07:b0:482:eec4:772 with SMTP id 5b1f17b1804b1-4832021da15mr86024475e9.32.1770487714650;
        Sat, 07 Feb 2026 10:08:34 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e752:9400:18cf:c773:ee86:c436? ([2a02:6b6f:e752:9400:18cf:c773:ee86:c436])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483207286bcsm123461875e9.12.2026.02.07.10.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Feb 2026 10:08:34 -0800 (PST)
Message-ID: <687c7173-31c9-457a-9900-68e7f38688ed@gmail.com>
Date: Sat, 7 Feb 2026 18:08:33 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: map maximum pages possible in finish_fault
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, kirill@shutemov.name, willy@infradead.org
References: <20260206135648.38164-1-dev.jain@arm.com>
Content-Language: en-GB
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20260206135648.38164-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xpeoe97ffsqoms6muj6aizszm3auq757
X-Rspamd-Queue-Id: 84A75100005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770487716-719963
X-HE-Meta: U2FsdGVkX18/qKtarQqgEWeqGWS+/3hQUQh7UaPsMIVRyCK3u40kk9OFGWVaycwFdUkoF8UktKcHf5WbGoaNV6mCC9igF34bG+kCrbTXOIuIbuulMIWKuVhuGM8P4eKN8NeEBFAc8quxxBy7xR3Cx9h1aM/VJ3CMqhjJgiRuhFpKgQpfJ78h4tRntwIFBzCL4EpqnUKlt/3WFTBawgWtvzjhRpM81KKolpWU3+5DuWrf94cehrW3Bq029r04pxljySg5MlODqR3NaP3hSt7UQa+qj06RHcD1Kra3dToT6CwpkZF7QXPU/i2SWam6bUo95TmsrkWyGkC0ZWKOjH6iYaMOdpQRELdhP1gVRP4VcIDfQtYMuwavMFGlehO+pgOiK+tpM9oGkEdlei4nqns3yUQWJwMVC0RDcTC8wYmN97Np8ioAW5SFAM+rZkhFYVwUt6j8y6r8cIej+u9JoR49zbeiEwTW/HJYeFtF4uH2qA8GQugp85S+KvwFmfr+2RY6qw8ZNYji8pxpKacMwrkOWZQgfFTLde3B7Jv5VLrLj2SgP+qy8vf9aII8Xel6MJ5zHLBa74mHxwL8L4tjk5KKAO3YC0Kgt0FJskeXyKLcmOHPWU2dEqSTX8tL8ILSuRhy+T/NawbPaHW1XY7ZBDdp9xvu+Z+hZQtHQg1Zq6IcRi0778nZeMDLXBJZsQvVro5yoM5IPmK7iEDJaL41uBz3pKU9RFzMLpsN1MKC3f5OTnB2nVzX60WaCBATlZkK2mXO1zpAmYHAJp5z9I9OQ8+Prd/7jlbuwtD3FsLXiKcMeHN/OrvQlEpQmnCD9be85z2bXBXNtrNaRduHGo5QLdcodc3PUXquFgGXDVx+8p8+5QtGaVyReKZlGUOcf+YeUgsveWPcTpxmy6RWHzkQkDwEB4dnvdWWiUZ3xyQhZ9nkJT+BXR1zcnnQsocBnamVhD/uOqG0qEFZkmsJbUsNvUf
 SUniTrxx
 MGLlIi3fUKOroizo1Kwp+X8uL+WGQFyXwFaHTG592x9Pdk0YDmrqS3josSzY8mgEvHvaAIofcRJY4+7xs+41sIushuO98TP1NdojNd8iv5pYsRGIg6N3cytTI9AnxVQL2s0ZmcfpkbPwGqkOB6HpP6Y6C4yoNpdWzfVohNDRhf0SKR2h8j2iACNYlFXXJ2PfXwX1AqFMrVOYflga9T6MF+G79O+bwidLu1O29Y5yfZYKLmu74gz+9k5J0+T9z9B3DflHYMG2Q/0+jpoziPnD4ORPsTJX7PIYasB8BiIM14xa9xa31BHhbiTp5hYqEN4WuADm4TyeRepXUzkKS8dpUfS1F0elFdVQm/hElfH70K8oN2du64bwjw2eMuZDdyPIYt0tMDvm7h+FgdJd2RR4+2NAFeu9f22GUOIigHMC5ozqSk6CmRJhPSm5SE6TUEvGaiquO5qYb/aUEYQm5auau2/AR5HOL/ldJkWeRabXBSnfvn/I+C5dvX59LSqyxAvVlGi4jOuLW8yAM4l+oEKUqMKbbyTO1Vsknc0ojuhxn+b7s0gg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> @@ -5619,49 +5619,53 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>  	nr_pages = folio_nr_pages(folio);
>  
>  	/* Using per-page fault to maintain the uffd semantics */
> -	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
> +	if (unlikely(userfaultfd_armed(vma)) || unlikely(single_page_fallback)) {
>  		nr_pages = 1;
>  	} else if (nr_pages > 1) {
> -		pgoff_t idx = folio_page_idx(folio, page);
> -		/* The page offset of vmf->address within the VMA. */
> -		pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
> -		/* The index of the entry in the pagetable for fault page. */
> -		pgoff_t pte_off = pte_index(vmf->address);
> +
> +		/* Ensure mapping stays within VMA and PMD boundaries */
> +		unsigned long pmd_boundary_start = ALIGN_DOWN(vmf->address, PMD_SIZE);
> +		unsigned long pmd_boundary_end = pmd_boundary_start + PMD_SIZE;
> +		unsigned long va_of_folio_start = vmf->address - ((vmf->pgoff - folio->index) * PAGE_SIZE);
> +		unsigned long va_of_folio_end = va_of_folio_start + nr_pages * PAGE_SIZE;
> +		unsigned long end_addr;


Hello!

Can va_of_folio_start underflow here? For e.g. if you MAP_FIXED at a very low address and
vmf->pgoff is big.


max3() would then pick this huge value as start_addr/

I think the old code guarded against this explicitly below:
    if (unlikely(vma_off < idx || ...)) {
        nr_pages = 1;
    }

> +
> +		start_addr = max3(vma->vm_start, pmd_boundary_start, va_of_folio_start);
> +		end_addr = min3(vma->vm_end, pmd_boundary_end, va_of_folio_end);
>  
>  		/*
> -		 * Fallback to per-page fault in case the folio size in page
> -		 * cache beyond the VMA limits and PMD pagetable limits.
> +		 * Do not allow to map with PTEs across i_size to preserve
> +		 * SIGBUS semantics.
> +		 *
> +		 * Make an exception for shmem/tmpfs that for long time
> +		 * intentionally mapped with PMDs across i_size.
>  		 */
> -		if (unlikely(vma_off < idx ||
> -			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
> -			    pte_off < idx ||
> -			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE)) {
> -			nr_pages = 1;
> -		} else {
> -			/* Now we can set mappings for the whole large folio. */
> -			addr = vmf->address - idx * PAGE_SIZE;
> -			page = &folio->page;
> -		}
> +		if (mapping && !shmem_mapping(mapping))
> +			end_addr = min(end_addr, va_of_folio_start + (file_end - folio->index) * PAGE_SIZE);
> +
> +		nr_pages = (end_addr - start_addr) >> PAGE_SHIFT;
> +		page = folio_page(folio, (start_addr - va_of_folio_start) >> PAGE_SHIFT);
>  	}
>  
>  	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
> -				       addr, &vmf->ptl);
> +				       start_addr, &vmf->ptl);
>  	if (!vmf->pte)
>  		return VM_FAULT_NOPAGE;
>  
>  	/* Re-check under ptl */
>  	if (nr_pages == 1 && unlikely(vmf_pte_changed(vmf))) {
> -		update_mmu_tlb(vma, addr, vmf->pte);
> +		update_mmu_tlb(vma, start_addr, vmf->pte);
>  		ret = VM_FAULT_NOPAGE;
>  		goto unlock;
>  	} else if (nr_pages > 1 && !pte_range_none(vmf->pte, nr_pages)) {
> -		needs_fallback = true;
> +		single_page_fallback = true;
> +		try_pmd_mapping = false;
>  		pte_unmap_unlock(vmf->pte, vmf->ptl);
>  		goto fallback;
>  	}
>  
>  	folio_ref_add(folio, nr_pages - 1);
> -	set_pte_range(vmf, folio, page, nr_pages, addr);
> +	set_pte_range(vmf, folio, page, nr_pages, start_addr);
>  	type = is_cow ? MM_ANONPAGES : mm_counter_file(folio);
>  	add_mm_counter(vma->vm_mm, type, nr_pages);
>  	ret = 0;


