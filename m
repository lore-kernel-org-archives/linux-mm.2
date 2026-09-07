Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D30AC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 20:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6BB6B008A; Mon,  7 Sep 2026 16:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95DE76B008C; Mon,  7 Sep 2026 16:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E6E6B0093; Mon,  7 Sep 2026 16:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 630896B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:02:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E82261402BB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 20:02:37 +0000 (UTC)
X-FDA: 85188038754.28.A4B8A5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3553A1C0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 20:02:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xaxn5Zyq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788811356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZp9MQtMHz2+2kWpWNvVGa8Czo7fd2YuqFVjvJBqt9g=;
	b=WMZKaah6Ls4OWbqkupoQQm0uDs8S89vF26oRwGswM0A+2SMRO642scVJx4GXASwLGU2hjG
	kyGLGLIfH++T0g6IKN9vaAZbZ4jJ2e9CkKSxPBHSKhcWeFIAlTkSKLFS2X0ydHq2mCkqUR
	353LtLpgFo89kfQP+7oGFHzAiB4kKwA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xaxn5Zyq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788811356;
	b=t+SH/wy2wJNmUFDf2WYpR1CoRV8eSFnpTh/Fx85xsvL0zvUxcjiTstt6rp9iLYTplQGzjK
	mU6Xw8Mj0lIjWHDcFDg1YhTS8zvBfl0zzCb6hlz7E/F9uDR0TKepDFgNsAEWK6gRto6hh5
	/5t33VQVvNP06hnYBW05vlPyAWQfuZs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 719D5601FB;
	Mon,  7 Sep 2026 20:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5421F00A3A;
	Mon,  7 Sep 2026 20:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788811354;
	bh=CZp9MQtMHz2+2kWpWNvVGa8Czo7fd2YuqFVjvJBqt9g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Xaxn5Zyq3Zh6YNGRvLtQuVm+NQpM9BWmnk8jbS1EnCD4VRfgdsJhdBY/JvwPyEIPE
	 +bS1tIxSogjKgQ6BVPC861F1q6TFD2wipwg1FCIVbKUTWlvjm+phpvamQ1UaIG4oWk
	 bzP7XzNTWz/YINQBS7OfE2wNxyEBv9R4dxEE9FnHT8y3PXpvYltWTHG1zHEqVx1qpo
	 +iED8u69XsQYm0tDokPFgBeIgRiH+NpkaGxfsTEN8gNof2JTrrMmWm1BVp8nbVNq8h
	 YsqgHFlHloBt7tFWZatNPngFIvD4vwRHJbidT+GGhL3HBEaocpqllshRKI9Of5129G
	 clX5XGU/JwtcA==
Message-ID: <6d6a876a-74a1-4317-9972-cde1d5ba844b@kernel.org>
Date: Mon, 7 Sep 2026 22:02:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/huge_memory: bypass THP tuneables for huge pfnmap
 mappings
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Cedric Le Goater <clg@redhat.com>, Saravanan D <saravanand@crusoe.ai>,
 stable@vger.kernel.org, SJ Park <sj@kernel.org>
References: <20260907-hugepfn-allowable-orders-v2-1-b89728339148@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-hugepfn-allowable-orders-v2-1-b89728339148@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6g1u6jobokx45ytf4ee6xb36u6rxryge
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3553A1C0002
X-Rspam-User: 
X-HE-Tag: 1788811356-731937
X-HE-Meta: U2FsdGVkX1+dE6yz99x0RWpHP8VnJevohfYxil7M6kyMhgVJyKVo8MYziWmK75lCaueAsRXYYvNesvrLWc3o5HsW9TpKhgG32QgEeGVLZyxMVLU3jWbIMlVuaNKLeWQj64o9MCwupj75XvHoYbUIkQSx9cXCbv60ZFdYBBVAgTztSlUqCrw5Pom03nvwDZQXAPC8qPQdTXJQjWjRzjXT64xN6hMftVn+XQCL75z/EjSw6RgKJzM8gMtFAtJiZonjE5zSaSgkG+SSGoiArjf78hasCX9Ks91eQ9G/aHBetrbKffFhKcEV/7HC6Z97Gqgj7rm6dcVysMHbjly/WuQ6b7S6pBamRwjFWyYtnjq526bPl/Xppg7ZRolvMRaaJsrMxAlgidvT4FLwniJ802NvO1GbKpo9e36MQHn2rh30/6nGyKuLYWebTjuKmNme3XJUnuYaYlSTqICoT9COknGxTz0rS/OhPjsDi5um+4x2hwT3JLUMZn/MKAL+r9wYTqxfaDiH+YOwAU1jbZQmjpvCNqRYq58xN3z3u88QJUuzH4mrbByjmqShyTqNqILCgIZQmsYNJpvgXVXiYrQ0MvzFFy2yweCjIGE7Jafa4xw/laU1/6IyruMnblRQgCR4C6a0viP0CtwuZivtHW7992lKKBoo/knXEU4IDXLHom+AwQbfbvmy8oe0geekZEOPZeXtxEHSCSKIO75maG7TOdJIn7/ikV/YaSInqQtcof6lKak11hanoJRsYNTLfILYtidN6DB+FC8JHswdPd1ZwKMY2o2JI/u41yPz7Q1Bh2hMx0f7D8n5l/rdmutq/3jJ/W5K6mdJvCzYphRH36oTHsx4Mx1+jo1qLpJdhmoUmLBCORe+Ksjbm6fBIy2vryOzpOubhKa/r1NVZVEGSDnhMzgdzF58XN7YTvJsCQ7VA9MQ7YGGx1Y6E3+OWnUQg1FBpH4t8UyILXmHVthjKrZhU4B
 eJWZeN5Z
 1YOM6emBJXv6t3jMrVi/Ow2Tv8Ocjo8mfm6R+fUEf7OK5fJ7n4C3u1s3zwB2MK0x9qIr+T3PT8MhywyyIDukRsBjEOdgbMpxS3kbQP+mv7F9o0Fo93k38fdDZisbzbKQjx+QOCgqwO1u5nsusCPTJwJWWw5gCV/qpfDwT1cI+HJjie68+gcyp29XzzcEt0S1wn7tQ6v4JJMpR3T7zvrW3npmW8XaousX5dClFB7eIuh6rbYiuJlwA24DOx53eqMc9ce50B9KQAdg50yTweIQ/oNs/wE+QOQxyfxrNjyOci66sKjpHlaUfKfNj4+rOK8qQSRjBk4Ot1br8pJjB3ZrhJ8R3v4vyAXH6R/1Gt6RlTRJNB3rxNj5WBEssZvIComsY8eQwAbtxdN+lVeND92G2MmIq6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 19:33, Lorenzo Stoakes (ARM) wrote:
> The sysfs THP tuneables at /sys/kernel/mm/transparent_huge_pages/ rather
> confusingly only control the behaviour of THP in some instances.
> 
> They are not applicable to MADV_COLLAPSE operations, nor to DAX mappings.
> 
> Long-term, THP is predicated upon compaction being able to obtain large
> folios to populate THP ranges.
> 
> However, vm_normal_folio() returns NULL for PFN map mappings, thus their
> reference count is maintained by the driver, not core mm.
> 
> As a consequence, the folios are not subject to reclaim nor compaction, so
> are not truly part of the THP mechanism at all.
> 
> However, since commit 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
> introduced the ability to establish huge PFN maps, they have been subject
> to THP tuneables.
> 
> This is incorrect - if a huge PFN map is available (defined by
> vma->vm_ops->huge_fault being non-NULL for a VMA_PFNMAP_BIT VMA), then it
> should be mapped huge upon fault-in.
> 
> Correct this by explicitly checking for this while ensuring that smaps
> continues to accurately report THPeligible statistics.
> 
> While here, abstract the entire file-backed THP check in
> vma_can_map_huge_file(), with sensible separation of logic into helper
> functions.
> 
> Note that drm_gem_shmem_mmap() and panthor_gem_mmap() establish huge PFN
> maps of shmem folios, however they are marked unevictable in
> drm_gem_get_pages(), and in any case would fail the reference check in
> __remove_mapping() even if they weren't.
> 
> Failing to map huge PFN maps has resulted in significant real-world
> performance degradation, see links for details.
> 
> Reported-by: Cedric Le Goater <clg@redhat.com>
> Closes: https://lore.kernel.org/linux-mm/20260805055544.1568534-1-clg@redhat.com/
> Reported-by: Saravanan D <saravanand@crusoe.ai>
> Closes: https://lore.kernel.org/linux-mm/20260821070520.25759-1-saravanand@crusoe.ai/
> Fixes: 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
> Cc: stable@vger.kernel.org
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: SJ Park <sj@kernel.org>
> Tested-by: Saravanan D <saravanand@crusoe.ai>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> v2:
> - Added tags thanks everybody!
> - Updated to use vma_file_*() naming as per Zi.
> - Also updated vma_can_map_huge_file() to vma_file_can_map_huge() as per
>   David.
> 
> v1:
> https://lore.kernel.org/r/20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org
> ---
>  mm/huge_memory.c | 86 +++++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 64 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index afbb5974bd22..75c204af40cb 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -92,7 +92,7 @@ unsigned long huge_anon_orders_madvise __read_mostly;
>  unsigned long huge_anon_orders_inherit __read_mostly;
>  static bool anon_orders_configured __initdata;
>  
> -static inline bool file_thp_enabled(struct vm_area_struct *vma)
> +static inline bool file_thp_enabled(const struct vm_area_struct *vma)
>  {
>  	struct inode *inode;
>  
> @@ -118,6 +118,67 @@ static bool vma_is_special_huge(const struct vm_area_struct *vma)
>  	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
>  }
>  
> +static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
> +		enum tva_type type)
> +{
> +	const bool has_huge_fault = vma->vm_ops->huge_fault;
> +
> +	/* MADV_COLLAPSE ignores tuneables. */
> +	if (type == TVA_FORCED_COLLAPSE)
> +		return true;
> +	/* Huge PFN mappings are uncompactable so the policy doesn't apply. */
> +	if (vma_test(vma, VMA_PFNMAP_BIT) && has_huge_fault)
> +		return true;
> +	return false;

/* Huge PFN mappings are uncompactable so the policy doesn't apply. */
return vma_test(vma, VMA_PFNMAP_BIT) && has_huge_fault;

> +}
> +
> +static bool vma_file_allow_thp_tuneables(vm_flags_t vm_flags)
> +{
> +	/* THP=always? */
> +	if (hugepage_global_always())
> +		return true;
> +	/* THP=madvise and marked MADV_HUGEPAGE? */
> +	if (hugepage_global_enabled() && (vm_flags & VM_HUGEPAGE))
> +		return true;
> +	return false;

/* THP=madvise and marked MADV_HUGEPAGE? */
return hugepage_global_enabled() && (vm_flags & VM_HUGEPAGE);

> +}
> +
> +static bool vma_file_check_thp_tuneables(const struct vm_area_struct *vma,
> +		vm_flags_t vm_flags, enum tva_type type)
> +{
> +	return vma_file_bypass_thp_tuneables(vma, type) ||
> +		vma_file_allow_thp_tuneables(vm_flags);
> +}
> +
> +static bool vma_file_can_map_huge(const struct vm_area_struct *vma,
> +		vm_flags_t vm_flags, enum tva_type type)
> +{
> +	const bool has_huge_fault = vma->vm_ops->huge_fault;
> +
> +	/*
> +	 * Enforce THP collapse requirements as necessary. Anonymous vmas
> +	 * were already handled in thp_vma_allowable_orders().
> +	 */

The reference to an anon vmas is not really suitable in the vma_file_* helper
(would be better kept in the caller). I'd just drop the reference to anonymous
vmas entirely.

> +	if (!vma_file_check_thp_tuneables(vma, vm_flags, type))
> +		return false;
> +
> +	switch (type) {
> +	case TVA_PAGEFAULT:
> +		/*
> +		 * Trust that ->huge_fault() handlers know what they are doing
> +		 * in fault path.
> +		 */
> +		return has_huge_fault;
> +	case TVA_SMAPS:
> +		if (has_huge_fault)
> +			return true;
> +		fallthrough;
> +	default:
> +		/* Only regular file is valid in collapse path. */
> +		return file_thp_enabled(vma);
> +	}
> +}

Much nicer to read, thanks

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

