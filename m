Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F8ADF01825
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0ED6B0005; Fri,  6 Mar 2026 06:11:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954106B008C; Fri,  6 Mar 2026 06:11:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8564F6B0092; Fri,  6 Mar 2026 06:11:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75AA46B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:11:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0AC716051F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:11:30 +0000 (UTC)
X-FDA: 84515372340.03.F5A74D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2C61D180006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:11:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bdHvIeL/";
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772795489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PumA3EBaEMAeDzqDrpITFSV9O0HJ5n9l26R6Sjhk7P0=;
	b=yYVHAshOMSR2/2oKHUk59aAz/RsEjhffMBxjF3tYZNfEm5jvpd1z83a+y+GGoBQbjr0OQ5
	+fO33XqCkRtofU2LzfrPGL3vX1u61RM6NHY56JDx+bH67tyk0snhaZHiJjuGik1zlrQxfP
	wXZa5RSDkUv0vvczpdus/ovTJxnE6fc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bdHvIeL/";
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772795489; a=rsa-sha256;
	cv=none;
	b=B/jFzY6VJ9e++hJgK9nDs4wsxdxHYPuyyDSmfulLHK2pb83xCqEjny9FV4uoK6T4/XgiRF
	/Su+/s9ND7lmspzHySwT7oNQH1kOhBXTDziDUSwOPV9db5u6N41WOUDlzDOqTSNXLcasr7
	ni/n2GHM8v+1g6aJg56YZioKsFslD3s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C43144454;
	Fri,  6 Mar 2026 11:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B593EC4CEF7;
	Fri,  6 Mar 2026 11:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772795488;
	bh=XPnWJ/zcW6bcNJfU50q7o2JeLb8fNCmjYqceT7SznhI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bdHvIeL/wlKDg0FcHc0VzSvms6Qw1rJu3w5LF8u/FdPD9nAOxopFjS63ed7LiZtQn
	 UkSZl8EQ/mSVlZMpC43C6W86wNCXOoApnPfV/pfMb9E6n3qbpoNGB1qIVoLon3ASbH
	 nPcp27j5jCCwpmNUZMuAZX5MlN/ZRYDxiZ7xcKGfVHH++DqHgOeNE36bRq48VMLtNw
	 0liKlv8hMf/KQ/gdlYvpGQNcZQluXf/jHE6RmlecqumS3+3cBxXFlidPpilxI+l56B
	 mcSNfvgEx7MbN3meiAgJb3tkUpCw3KI3eicxkTPgCB2KGUdzChTV5da5pFQkzP0CDk
	 hRbRCxTW1/N/w==
Date: Fri, 6 Mar 2026 11:11:25 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1 2/4] mm: move vma_mmu_pagesize() from hugetlb to vma.c
Message-ID: <8ed76150-9e06-45c9-a061-1a1bd1d4c0fa@lucifer.local>
References: <20260306101600.57355-1-david@kernel.org>
 <20260306101600.57355-3-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306101600.57355-3-david@kernel.org>
X-Stat-Signature: r1i8di9p5ipk8jhtwjp91k5x1ry1uwkt
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C61D180006
X-HE-Tag: 1772795488-697212
X-HE-Meta: U2FsdGVkX1+C1uCn2k4BQD6J0tz9QTdkNejGqhN7unc+fy/evjRPwhRWqq1nHCqf2Iwq+PIsVJ23Fg+zEQBurfYMF8p4sgTYOuKvjAwFTZUSrc8l86iHJMjjvS1vqkQ532MB0c+EFs15xbE/l0Ru8bMQBK7Ih5WNqUywhdrXEI8DDFBKyf24DZAoqL2YiP82YruRcZbZXDqOpdJEcMIE5YtlxfZCyCCpdHPAX8qGIP/+aCUNJTP8dWwSBMatWu5VdXltDNIyTjTs98+D2IeUjVy+WrudP/ZQQbesPIPl5/ySWA/b5HiYPHaKTBndAEJCdi6vr8xE7bkTIbzp/aWJxn5bQMxGAwA7nCO5FdAMVB/tsD6KkI3tB4OOKBkHSRJVrMJbA3EiuJF3WNDNXaORGvNSXtTaIW92k2q9+BdHMuwsgj3hgO3vTS1sZe1yQ6agp7KEgmWh81I8Q3pORKhTRdgZuDyKpKr/3fSz0//Obpzbohw+DGzz8AXwClN/JkgTiQhzxClyELHXx2WMHs33R/IH3huuzzkQiagpJrY6g1xCRQucny4lb9Vrj8gVCL460GqGScAqgriMo9zIx7QyPD+yVKByQXKXEJy2v2RD/M1Sn3LyZOMFrqluGyf2jrTqQxbxefCMxFiPT/87D7uLcElmzenk2rZVQUkH/mX2E2ABHTP+A+sP6hBDXS4HH5Qxw05GwFnXMxoc0y8+xMYtv/22kM6VxHLZDXSGPkJ29HmPlUaB3g3A/8vQz7Hk1Vgi6E8eXrWi1spWwv7zp5elBQAwwQnS1Q3M97iaWYsA4oL2DzMurvvBf8RnqRBRbPgZDoSJtIBsmGM+v5IqiPhknZeEryCO9rxra2OfEdA0hlOtys7q5s+EbLwrr2bP8OoZUHs5LyYne00bTgO1/2pa40GOIwDIy9R2Q/icX2FHU9HdgwKzGh511d+Ekl8ERSNpIPiJ/5chqnJObV81jMO
 NBawFvav
 FPcvAQHTntr3sX3I8xx6O4SwVhKsDQxYlz1h/bFbKjHWTRnozd6VuWP2K0wS63cQCN6ZkgG/7ddxShPfw9GLjYY4Nc0W3GSPKLnoXWiq+P34uZgcFUvh88GBfnXn1V1VLb6eCTwym/XcZDaAOlDgo3KVJHa4ipWUv+uET14iqx3b6XcRmmLW8HOEism5CxF7F4f70lGD0AST7A5uuEKzeOixRMJoCcAQbo1PbyDbMuguhEypPEsNkcRMSOehk+t5WToOJIkbBSC45Ci56DBmiJAUNv2soQ+xvW/K08vMaHxIG74fv/0nWu3jZ8j0SzV9Uz0Rv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 11:15:58AM +0100, David Hildenbrand (Arm) wrote:
> vma_mmu_pagesize() is also queried on non-hugetlb VMAs and does not
> really belong into hugetlb.c.
>
> PPC64 provides a custom overwrite with CONFIG_HUGETLB_PAGE, see
> arch/powerpc/mm/book3s64/slice.c, so we cannot easily make this a
> static inline function.
>
> So let's move it to vma.c and add some proper kerneldoc.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/linux/hugetlb.h |  7 -------
>  include/linux/mm.h      |  2 ++
>  mm/hugetlb.c            | 11 -----------
>  mm/vma.c                | 21 +++++++++++++++++++++
>  4 files changed, 23 insertions(+), 18 deletions(-)
>
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 44c1848a2c21..aaf3d472e6b5 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -777,8 +777,6 @@ static inline unsigned long huge_page_size(const struct hstate *h)
>  	return (unsigned long)PAGE_SIZE << h->order;
>  }
>
> -extern unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
> -
>  static inline unsigned long huge_page_mask(struct hstate *h)
>  {
>  	return h->mask;
> @@ -1175,11 +1173,6 @@ static inline unsigned long huge_page_mask(struct hstate *h)
>  	return PAGE_MASK;
>  }
>
> -static inline unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
> -{
> -	return PAGE_SIZE;
> -}
> -
>  static inline unsigned int huge_page_order(struct hstate *h)
>  {
>  	return 0;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 227809790f1a..22d338933c84 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1327,6 +1327,8 @@ static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
>  	return PAGE_SIZE;
>  }
>
> +unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
> +
>  static inline
>  struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
>  {
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 66eadfa9e958..f6ecca9aae01 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1017,17 +1017,6 @@ static pgoff_t vma_hugecache_offset(struct hstate *h,
>  			(vma->vm_pgoff >> huge_page_order(h));
>  }
>
> -/*
> - * Return the page size being used by the MMU to back a VMA. In the majority
> - * of cases, the page size used by the kernel matches the MMU size. On
> - * architectures where it differs, an architecture-specific 'strong'
> - * version of this symbol is required.
> - */
> -__weak unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
> -{
> -	return vma_kernel_pagesize(vma);
> -}
> -
>  /*
>   * Flags for MAP_PRIVATE reservations.  These are stored in the bottom
>   * bits of the reservation map pointer, which are always clear due to
> diff --git a/mm/vma.c b/mm/vma.c
> index be64f781a3aa..e95fd5a5fe5c 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -3300,3 +3300,24 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
>
>  	return 0;
>  }
> +
> +/**
> + * vma_mmu_pagesize - Default MMU page size granularity for this VMA.
> + * @vma: The user mapping.
> + *
> + * In the common case, the default page size used by the MMU matches the
> + * default page size used by the kernel (see vma_kernel_pagesize()). On
> + * architectures where it differs, an architecture-specific 'strong' version
> + * of this symbol is required.
> + *
> + * The default MMU page size is not affected by Transparent Huge Pages
> + * being in effect, or any usage of larger MMU page sizes (either through
> + * architectural huge-page mappings or other explicit/implicit coalescing of
> + * virtual ranges performed by the MMU).
> + *
> + * Return: The default MMU page size granularity for this VMA.
> + */
> +__weak unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
> +{
> +	return vma_kernel_pagesize(vma);
> +}
> --
> 2.43.0
>

