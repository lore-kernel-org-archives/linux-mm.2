Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA8BCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 12:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 954E290015A; Thu, 14 Aug 2025 08:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904CD900023; Thu, 14 Aug 2025 08:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A51090015A; Thu, 14 Aug 2025 08:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66AFC900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:57:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 301201DCCEF
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:57:44 +0000 (UTC)
X-FDA: 83775364848.24.19AEC3C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id E6127120010
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:57:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fFrSki3j;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755176262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYu+pSj8qm0uW6d7jDREfJ9qf0mUNCcnnXWJjgjHnj0=;
	b=I0RNta6Mgx2L+BftYPrmU/IZpppOuYxqIk6Tk/WlI0ZiOO2Z9RE1D+fvIKxXsWoS0+T/tl
	ZG3QRy29MI6Pgkuw1byYqkzNg+9lQwIWGhadJzfNtaB8q6K14tGfzes2gKni2+GBURlx33
	e/zBXwQ8JupScDF2jLNUIIWaK2aNBHM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fFrSki3j;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755176262; a=rsa-sha256;
	cv=none;
	b=Ng/6pyrIKkb19cwaSZTXnKEoCCY33kG5FQGXFScnZcMhApvpr8/HxGjyTgFlhxHIvTHjjN
	Q35HbaErzoiFr+hk0waCa4E0PJLOXNMdSq2HiyGDECKa+ijF7HNdAa7KPb/SVADFpnYb0O
	4glvW6ZFZwL0+oJrwXYzJtxkUuigffo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755176261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eYu+pSj8qm0uW6d7jDREfJ9qf0mUNCcnnXWJjgjHnj0=;
	b=fFrSki3jB8WoKYKwxhvcpfVmNL+PqSkz2DIF15Yifc+hwi0KB4IqcLjvhjLVX+lbM7CqyT
	gkOiTWHy5d9PW52XmpPPtkZBirUxJM1dBWIr2GiOSdtNyTB1C4kVa6JPYsDVnwSNAHCMEq
	LAiDvswEQhWhPFjhxi/Mm4hM5ALkZzk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-152-Vu3U0pieM-GVfnFK3C86Hg-1; Thu, 14 Aug 2025 08:57:38 -0400
X-MC-Unique: Vu3U0pieM-GVfnFK3C86Hg-1
X-Mimecast-MFC-AGG-ID: Vu3U0pieM-GVfnFK3C86Hg_1755176257
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0d0feaso6139735e9.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755176257; x=1755781057;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eYu+pSj8qm0uW6d7jDREfJ9qf0mUNCcnnXWJjgjHnj0=;
        b=dZAt4LkGLHq7mtbdTqcUoC1SXB/NzvzpOgAQ5n32lAF0q+hAzrMk5EZ9Z48w1+2kXI
         U753FLmpT1bKLCjrR4AfSZMCh3BIF4phAreuWzDfJuQkFC0jhPcglxvso9xTs95Bbh2Y
         Jk9lKZyOu6hS8d5wJVw+H4dtLaNPGaDLrFMZg5bbg599LmeshzRUPcePLrHFVUhB+qEK
         kPprWVl+my9CRcPCLZICnMyF92g8o3bnVtla3ze78/Jr2rUdhh2zzJbthwREinSFBIe1
         wQJh+xrs0FK1YZXBtCeNmUYx8QJAeRfBAGxODOsVZLtChmVbFrhv0kQ7lwALxVXjpPeh
         MkmQ==
X-Gm-Message-State: AOJu0YyOmXedwUr9gmTW++v+qaqDmcWdqNZHCDtxIs6dItm5n+y5TJRw
	IQmLvNuDuQI0TejZPl85GqM/xdbqgWM/9yGpDQY/sapgppEJKMiT2/jkAoeRgiyVGB4AbepG7t4
	g6EGkRufxfAhmbjWqx/ZVJl7AOtWz5ZpeQXYftvGiMPDIUSpLlen0
X-Gm-Gg: ASbGncsSc5Qsd6RIYIdHuLN3ifVTb8XWXbcq+URdVtmdDk7rkmuOZ0kXYTq9fyQ4Qvg
	R1X4fafqie2V4VVEGWq2pYhJ0JJBuoDn0tBZfBWEXFjX8FqKesJDUZKVxie5MFtaXkNj4+F6qC7
	/KLfdIK/BBgkzryHeDTV1ZGeRItBVhwTpusJxG2ixjQxxFr9tCcHSi3kg/uFV+URz5WN/unCp2m
	WvgzUVdO5g997ul4FJSOCQqwSGeX0AKqk7CfuDHVMntNiQl1QHRtFaT1AbhcO3o0RzPnSm1g3Rt
	3guLUde+YQY3BGxBEXZ3fK+ooEXTYrXxt+bJV0i7WDrP8YeHeLIa5epKnzVGU3WhRGUlH3/V/Ck
	urxp6rihfnUWu2pDUpIDwRVxtJ7cTWei4259XdXRFW+fA65GVcvmPmPyBEN7RFp7YTtQ=
X-Received: by 2002:a05:6000:220b:b0:3b7:8abc:eba2 with SMTP id ffacd0b85a97d-3b9e417a582mr2839960f8f.20.1755176256777;
        Thu, 14 Aug 2025 05:57:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEn355CJ3+mtgaJrvleI5wccd3uw0m2+XNh8G0sr2xzowEBV62WSZYiqEVueQBVjptBo0rtQQ==
X-Received: by 2002:a05:6000:220b:b0:3b7:8abc:eba2 with SMTP id ffacd0b85a97d-3b9e417a582mr2839928f8f.20.1755176256218;
        Thu, 14 Aug 2025 05:57:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3e00:9fca:7d89:a265:56f3? (p200300d82f443e009fca7d89a26556f3.dip0.t-ipconnect.de. [2003:d8:2f44:3e00:9fca:7d89:a265:56f3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c469319sm49750456f8f.54.2025.08.14.05.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 05:57:35 -0700 (PDT)
Message-ID: <b607985d-d319-4b47-9365-0595f7d87f28@redhat.com>
Date: Thu, 14 Aug 2025 14:57:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 6/7] mm: memory: add mTHP support for wp
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, glider@google.com, elver@google.com,
 dvyukov@google.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, muchun.song@linux.dev, osalvador@suse.de, shuah@kernel.org,
 richardcochran@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.or
References: <20250814113813.4533-1-vernon2gm@gmail.com>
 <20250814113813.4533-7-vernon2gm@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250814113813.4533-7-vernon2gm@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: imY2lzCi0C04brz9SGUTCMlQnYY0Jyvb4BXHDDo9ziE_1755176257
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E6127120010
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 5cd7bc355wtnn7181fpge3o3nprymq6y
X-HE-Tag: 1755176261-168295
X-HE-Meta: U2FsdGVkX1+yWQ4ifG6Z9InVf2C4Xubsu2OhhSlJBpJ0WNU502e0CC5yPhZ3rYhTrOrwEySk5Y7v2p1yPOySk5N2zygZHwuaqGX9SWGb8/YbIc9XKhQaCp7RWM9lqQayyM+umlZ7q+wHhV411Eexk3JKTWF7j7zDQJCcph1unXOvvS065gzwmKF04UYWai/Rx3+uQQ39SA7l+Prgccyn95l3LubJkfWK/MBSyO1F7gr3Gy+3glwy8R2o9wagZDQwhG42x+kUPRK3FEKHAFKo5o/TQ+IHHjIxxwzpYmVMpq/bTV9UW2PHn1//yzbGeGiWmYtd6xKt/A+DWsMPmdAASd9xdVB/6DrPnqxWgiAF4idrAoFQlIM6lGnnGUL5t/2H8VmU70Gw+kT7pvhfPI2KUpI3V6SYCkieo/fcHGlQiCs2Ycl3q+T52Xlh+KzzAoHVCS2z/4cO5JPCGiOI8ozE2DWpzFFNz+T/E7k4RVjvOl9BEFbZ+TzlH7S1UVrTJpgWBoJeE4VL8LO2NSXIwQ6d/lYBvWfx2ABSdMWcdF2ZYQhcB5lVxKMueFUzYa0w++f8g7+bx918c4CLFwij0yycJgftE/xpnHk2KMPEw236xGhjiJA2ltQHngsWOWzmuuBIVUrlXVxtKwHhJeT94dxLukSgig64RSgkkEHwMbi3ySfIox03udCVD+2VgYrYsVi0P6eJFq6rtUzComzR+OZTh2NLIk0oGya2Sp5k24Fs4B6P7K4cU6JA3kS7npmLvAl3a79/ZvMZ8Dk3/ocTx9DIOA0MlBaTlbtN4oPzFx8f+AxB9QUBx/X7+CdVrMi38XIQEiHyzoB7M+FSB+SLyVa/EIIcD7RFMoNEXGt0g9VCyQKOft+8F8K+ja+QMIH4Bbd4QKWo9z0qH8/M1yk+Pyyk1DaRQu8ObAdcAcQmhZWLaYOxNs3qwoxICOCqpSHo0U+FqXYxNc/fzRCxLmHoxrd
 gobAY8zU
 tIU368L+/UByLCKq9cIwvlacrVxGPPRCErUXkdar2F2yeuBu7Fs1DODJnPf0iu+Z+jjDjgkH0FnVxdNcyv320Z0PebJVI8H2ZbZHP548WC0UTur0UbUD6ssu+2L4vneJaP7c67gCW3buIkBGfhl4quXUm8yCTS7IboW3b/YPFtbCOCjTYAWdtXvRGd0yac/b1gOeILl1WxWm1QPKt0KjjjhUIklQUcQxgbze2Q8Qw/7rD66Aih74uYohUFLKL3082IzTtpnslDYK1C2sWzjBR403huDFyN4BVj5XCYvQtx3vjqN/LIfX2t1Tj/HYPtUahXBqksxFD3VgzGMyFUYV1fieXvlVGDkoLXuOeoBl2du1d4+8aL8mShi6Q57QF2AjqkP7d/kgdHfjl1kZLyiZXudcR6nMLJf3kafsXUcbZEgrM8nbfYdeQ6QHPFZ1fUVWBNW6SwuCZb/kxdaiOk7e0aBBMhijJ1/f5f9z4O7jHkJgCWDIeEvffVm4HXOYiGktnzduHj0/2oX7oXqMI5+Mb2gcig/PtUh0HkCEf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.08.25 13:38, Vernon Yang wrote:
> Currently pagefaults on anonymous pages support mthp, and hardware
> features (such as arm64 contpte) can be used to store multiple ptes in
> one TLB entry, reducing the probability of TLB misses. However, when the
> process is forked and the cow is triggered again, the above optimization
> effect is lost, and only 4KB is requested once at a time.
> 
> Therefore, make pagefault write-protect copy support mthp to maintain the
> optimization effect of TLB and improve the efficiency of cow pagefault.
> 
> vm-scalability usemem shows a great improvement,
> test using: usemem -n 32 --prealloc --prefault 249062617
> (result unit is KB/s, bigger is better)
> 
> |    size     | w/o patch | w/ patch  |  delta  |
> |-------------|-----------|-----------|---------|
> | baseline 4K | 723041.63 | 717643.21 | -0.75%  |
> | mthp 16K    | 732871.14 | 799513.18 | +9.09%  |
> | mthp 32K    | 746060.91 | 836261.83 | +12.09% |
> | mthp 64K    | 747333.18 | 855570.43 | +14.48% |
> 
> Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
> ---
>   include/linux/huge_mm.h |   3 +
>   mm/memory.c             | 174 ++++++++++++++++++++++++++++++++++++----
>   2 files changed, 163 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 2f190c90192d..d1ebbe0636fb 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -132,6 +132,9 @@ enum mthp_stat_item {
>   	MTHP_STAT_SHMEM_ALLOC,
>   	MTHP_STAT_SHMEM_FALLBACK,
>   	MTHP_STAT_SHMEM_FALLBACK_CHARGE,
> +	MTHP_STAT_WP_FAULT_ALLOC,
> +	MTHP_STAT_WP_FAULT_FALLBACK,
> +	MTHP_STAT_WP_FAULT_FALLBACK_CHARGE,
>   	MTHP_STAT_SPLIT,
>   	MTHP_STAT_SPLIT_FAILED,
>   	MTHP_STAT_SPLIT_DEFERRED,
> diff --git a/mm/memory.c b/mm/memory.c
> index 8dd869b0cfc1..ea84c49cc975 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3344,6 +3344,21 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
>   	return ret;
>   }
>   
> +static inline int __wp_folio_copy_user(struct folio *dst, struct folio *src,
> +				       unsigned int offset,
> +				       struct vm_fault *vmf)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	void __user *uaddr;
> +
> +	if (likely(src))
> +		return copy_user_large_folio(dst, src, offset, vmf->address, vma);
> +
> +	uaddr = (void __user *)ALIGN_DOWN(vmf->address, folio_size(dst));
> +
> +	return copy_folio_from_user(dst, uaddr, 0);
> +}
> +
>   static gfp_t __get_fault_gfp_mask(struct vm_area_struct *vma)
>   {
>   	struct file *vm_file = vma->vm_file;
> @@ -3527,6 +3542,119 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
>   	return ret;
>   }
>   
> +static inline unsigned long thp_wp_suitable_orders(struct folio *old_folio,
> +						   unsigned long orders)
> +{
> +	int order, max_order;
> +
> +	max_order = folio_order(old_folio);
> +	order = highest_order(orders);
> +
> +	/*
> +	 * Since need to copy content from the old folio to the new folio, the
> +	 * maximum size of the new folio will not exceed the old folio size,
> +	 * so filter the inappropriate order.
> +	 */
> +	while (orders) {
> +		if (order <= max_order)
> +			break;
> +		order = next_order(&orders, order);
> +	}
> +
> +	return orders;
> +}
> +
> +static bool pte_range_readonly(pte_t *pte, int nr_pages)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		if (pte_write(ptep_get_lockless(pte + i)))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +static struct folio *alloc_wp_folio(struct vm_fault *vmf, bool pfn_is_zero)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	unsigned long orders;
> +	struct folio *folio;
> +	unsigned long addr;
> +	pte_t *pte;
> +	gfp_t gfp;
> +	int order;
> +
> +	/*
> +	 * If uffd is active for the vma we need per-page fault fidelity to
> +	 * maintain the uffd semantics.
> +	 */
> +	if (unlikely(userfaultfd_armed(vma)))
> +		goto fallback;
> +
> +	if (pfn_is_zero || !vmf->page)
> +		goto fallback;
> +
> +	/*
> +	 * Get a list of all the (large) orders below folio_order() that are enabled
> +	 * for this vma. Then filter out the orders that can't be allocated over
> +	 * the faulting address and still be fully contained in the vma.
> +	 */
> +	orders = thp_vma_allowable_orders(vma, vma->vm_flags,
> +			TVA_IN_PF | TVA_ENFORCE_SYSFS, BIT(PMD_ORDER) - 1);
> +	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
> +	orders = thp_wp_suitable_orders(page_folio(vmf->page), orders);
> +
> +	if (!orders)
> +		goto fallback;
> +
> +	pte = pte_offset_map(vmf->pmd, vmf->address & PMD_MASK);
> +	if (!pte)
> +		return ERR_PTR(-EAGAIN);
> +
> +	/*
> +	 * Find the highest order where the aligned range is completely readonly.
> +	 * Note that all remaining orders will be completely readonly.
> +	 */
> +	order = highest_order(orders);
> +	while (orders) {
> +		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> +		if (pte_range_readonly(pte + pte_index(addr), 1 << order))
> +			break;
> +		order = next_order(&orders, order);
> +	}
> +
> +	pte_unmap(pte);
> +
> +	if (!orders)
> +		goto fallback;
> +
> +	/* Try allocating the highest of the remaining orders. */
> +	gfp = vma_thp_gfp_mask(vma);
> +	while (orders) {
> +		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> +		folio = vma_alloc_folio(gfp, order, vma, addr);
> +		if (folio) {
> +			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
> +				count_mthp_stat(order, MTHP_STAT_WP_FAULT_FALLBACK_CHARGE);
> +				folio_put(folio);
> +				goto next;
> +			}
> +			folio_throttle_swaprate(folio, gfp);
> +			return folio;
> +		}

I might be missing something, but besides the PAE issue I think there 
are more issues lurking here:

* Are you scanning outside of the current VMA, and some PTEs might
   actually belong to a !writable VMA?
* Are you assuming that the R/O PTE range is actually mapping all-pages
   from the same large folio?

I am not sure if you are assuming some natural alignment of the old 
folio. Due to mremap() that must not be the case.

Which stresses my point: khugepaged might be the better place to 
re-collapse where reasonable, avoiding further complexity in our CoW 
handling.

-- 
Cheers

David / dhildenb


