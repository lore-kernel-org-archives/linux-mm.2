Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A88F01821
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 072ED6B0089; Fri,  6 Mar 2026 06:07:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38276B008A; Fri,  6 Mar 2026 06:07:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E448C6B008C; Fri,  6 Mar 2026 06:07:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D149A6B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:07:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5740E8BE96
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:07:44 +0000 (UTC)
X-FDA: 84515362848.30.A840B67
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E863816000E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:07:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LfXrGnQj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772795262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNkRqhf2OEYfDr/sk/mw7yv47Dg5A+NNPlMn4giuCwU=;
	b=MdeKVj2ApLwuDLJ2/r2CsfI66SRd3zMpq4GQJMeGGkYbmZ5v9EiRCHFiV+MimhtYgwVfI+
	4o/jiey4Kvbl3Ux/2Hp4b1p2+eZIC+WYijhkdSYfas4KjYk9Y/IVZ0EbQwegq3mzi/8t5/
	ixHJcyBz++dMbxhdR7RGU/NOSL36LEg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LfXrGnQj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772795262; a=rsa-sha256;
	cv=none;
	b=wkcuu/KH3Pd5vJaB779qBafUSR8zFUC11JxRNZ014hgJNwtnHzZjWUbpEiT2oYpe6Ojah8
	S6Op0x8HadWKNez2ZRlLbQa/NuyX9AvO41Mc0HbKVO8MzASQDggoQtI5UzygY2dZSVnMqh
	E7z7GASTLZaqkGANTn9z70MWtFce2/8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DB1E60130;
	Fri,  6 Mar 2026 11:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD42C4CEF7;
	Fri,  6 Mar 2026 11:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772795262;
	bh=xHA3xv8H6bWtNG4YWuzx0gTRR1QZaKIgnv1aEOMe/sI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LfXrGnQjHWNBBCETU/U4oSl/XQLAxUW5IW4VzDgbJuqr8rMv2CC9tqLHt++rzGNHE
	 t0r7h92NQurOz8dlsIXe9stMOQlmA9ZH6uLf2rKEazE2DmsuCUq0OtForVaXI/uXVW
	 xtlO4A6wks/mXhKXFf8pRc21P5Mj4x0jcKTcGp5pDBK5Rz7C8/7ojyk95zx5cNCewp
	 1u29pZldqh+4VOJ/ZgmA75LILHILbY+xmhXnvOKJTsfxC6LVYIr2RXdmffQ1gmyK+q
	 OgN6lcJBXIMNxzWGvz7oM3X3rkkwdktXnGjssSHgVBLcvQYAK7mQTpIC3PR4xxKLyg
	 qnM/YAedK++bQ==
Date: Fri, 6 Mar 2026 11:07:38 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 1/4] mm: move vma_kernel_pagesize() from hugetlb to
 mm.h
Message-ID: <833950ef-e01d-4914-b5f9-bc1f6261b184@lucifer.local>
References: <20260306101600.57355-1-david@kernel.org>
 <20260306101600.57355-2-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306101600.57355-2-david@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E863816000E
X-Stat-Signature: y9rsozos9pdtmgjangazxtdt7z6ha4jt
X-Rspam-User: 
X-HE-Tag: 1772795262-755385
X-HE-Meta: U2FsdGVkX1/PJsq7ItNciqy5Jm5KmiChr3+w7Dy6okZmPaZPwxI8lvEv1+k9b/G+2d3H99Auxhu30+tYFmPj7hGc1vO8zR8AdC+NNYJQdZFpHm50e8I4OLjh/TqQgcgnfSho552sIV05/e7b1J0J4/P72vU8wXXRuHJcqv4ift47aR4LywU6IbCcywXs6wJ5cnX9FQpy7uNWImsjXds+kFUlJKWMibrUliIb8j70+bxLxUPr0dQBpivRhJhMr3Hzazbu/RCYnwKTBvH+udvmP+4USuUTbBcivIErzf9rEH1y6kDlcWIvcSAVXWeM5Q0e1wONI3qbZeb2G4issEXPTlG8rcfZKrkXVEo789ZijGQTDxmNRh/S88mmeRjLFIBeVgAW3nHH9Ud1ZcyMFigyUWmEvDALLqz0hB3hQHphHEDC8e4pW+ROwu8227eVEOaR4BDWWt6jqUUpICUfmM1QrlKshFZ/j3SvyK+5QbL7cXPmSX7+LU+v+msY+H6n8H24bojWubrdgTXB0vveB5KyB2vdnRuXABgDHEDiIZqnIU7os6lP2my1HXFhqW4lkDwc7IpdzF/aCIVdhkE2J8K35pMrFW9p3q/1uyaZQx5dfNcM8G/gsAO2RayEwRzCViVyufXqm/F+AzlMBFxSf6uVW/mTxLoCSRHhga25UEY8yMW6uvc6bNVs1zeQSS6Ggz59uMjpVBm4dpf1FM93kVMhOQOlxE+4A3bAcZB0peQGYcl87q6L8lxss1y51YCPicQywYS9xhQte1nTnmOcq/zB0OFacfs8uw0psBI7+xTH+yQCkyqYLl4Mxkuhpf11wQyAFi3Jhj6e7mRSbYkjcetkjay9j2yiHW125JisO01Ytk4kmAhz8dHtDWXtI0KjdxAAxd7pXGH5k8SctCXx6nY46mmi7YPFrQV5jP8LRC6T/Oxp2wzymj20Hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 11:15:57AM +0100, David Hildenbrand (Arm) wrote:
> In the past, only hugetlb had special "vma_kernel_pagesize()"
> requirements, so it provided its own implementation.
>
> In commit 05ea88608d4e ("mm, hugetlbfs: introduce ->pagesize() to
> vm_operations_struct") we generalized that approach by providing a
> vm_ops->pagesize() callback to be used by device-dax.
>
> Once device-dax started using that callback in commit c1d53b92b95c
> ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
> it was missed that CONFIG_DEV_DAX does not depend on hugetlb support.
>
> So building a kernel with CONFIG_DEV_DAX but without CONFIG_HUGETLBFS
> would not pick up that value.
>
> Fix it by moving vma_kernel_pagesize() to mm.h, providing only a single
> implementation. While at it, improve the kerneldoc a bit.
>
> Ideally, we'd move vma_mmu_pagesize() as well to the header. However,
> its __weak symbol might be overwritten by a PPC variant in hugetlb code.
> So let's leave it in there for now, as it really only matters for some
> hugetlb oddities.
>
> This was found by code inspection.
>
> Fixes: c1d53b92b95c ("device-dax: implement ->pagesize() for smaps to report MMUPageSize")
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM, but you need to fix up VMA tests, I attach a patch below to do this. Will
this resolved:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  include/linux/hugetlb.h |  7 -------
>  include/linux/mm.h      | 20 ++++++++++++++++++++
>  mm/hugetlb.c            | 17 -----------------
>  3 files changed, 20 insertions(+), 24 deletions(-)
>
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 65910437be1c..44c1848a2c21 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -777,8 +777,6 @@ static inline unsigned long huge_page_size(const struct hstate *h)
>  	return (unsigned long)PAGE_SIZE << h->order;
>  }
>
> -extern unsigned long vma_kernel_pagesize(struct vm_area_struct *vma);
> -
>  extern unsigned long vma_mmu_pagesize(struct vm_area_struct *vma);
>
>  static inline unsigned long huge_page_mask(struct hstate *h)
> @@ -1177,11 +1175,6 @@ static inline unsigned long huge_page_mask(struct hstate *h)
>  	return PAGE_MASK;
>  }
>
> -static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
> -{
> -	return PAGE_SIZE;
> -}
> -
>  static inline unsigned long vma_mmu_pagesize(struct vm_area_struct *vma)
>  {
>  	return PAGE_SIZE;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 44e04a42fe77..227809790f1a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1307,6 +1307,26 @@ static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
>  	return is_shared_maywrite(&vma->flags);
>  }
>
> +/**
> + * vma_kernel_pagesize - Default page size granularity for this VMA.
> + * @vma: The user mapping.
> + *
> + * The kernel page size specifies in which granularity VMA modifications
> + * can be performed. Folios in this VMA will be aligned to, and at least
> + * the size of the number of bytes returned by this function.
> + *
> + * The default kernel page size is not affected by Transparent Huge Pages
> + * being in effect.
> + *
> + * Return: The default page size granularity for this VMA.
> + */
> +static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
> +{
> +	if (unlikely(vma->vm_ops && vma->vm_ops->pagesize))
> +		return vma->vm_ops->pagesize(vma);
> +	return PAGE_SIZE;
> +}
> +
>  static inline
>  struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
>  {
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 1d41fa3dd43e..66eadfa9e958 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1017,23 +1017,6 @@ static pgoff_t vma_hugecache_offset(struct hstate *h,
>  			(vma->vm_pgoff >> huge_page_order(h));
>  }
>
> -/**
> - * vma_kernel_pagesize - Page size granularity for this VMA.
> - * @vma: The user mapping.
> - *
> - * Folios in this VMA will be aligned to, and at least the size of the
> - * number of bytes returned by this function.
> - *
> - * Return: The default size of the folios allocated when backing a VMA.
> - */
> -unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
> -{
> -	if (vma->vm_ops && vma->vm_ops->pagesize)
> -		return vma->vm_ops->pagesize(vma);
> -	return PAGE_SIZE;
> -}
> -EXPORT_SYMBOL_GPL(vma_kernel_pagesize);
> -
>  /*
>   * Return the page size being used by the MMU to back a VMA. In the majority
>   * of cases, the page size used by the kernel matches the MMU size. On
> --
> 2.43.0
>

----8<----
This breaks the VMA tests when patch 2/4 removes the references in other
headers. So this patch should also update them, I enclose a simple fix for
convenience:

From bec84895cbdbe28e3495c4d90e097074598419e5 Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Date: Fri, 6 Mar 2026 11:05:12 +0000
Subject: [PATCH] fix

---
 tools/testing/vma/include/dup.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 3078ff1487d3..65b1030a7fdf 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1318,3 +1318,10 @@ static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
 	swap(vma->vm_file, file);
 	fput(file);
 }
+
+static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
+{
+	if (unlikely(vma->vm_ops && vma->vm_ops->pagesize))
+		return vma->vm_ops->pagesize(vma);
+	return PAGE_SIZE;
+}
--
2.53.0

