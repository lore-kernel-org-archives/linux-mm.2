Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E125E81BCC
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43616B0089; Mon,  9 Feb 2026 09:11:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03DD6B009E; Mon,  9 Feb 2026 09:11:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C068E6B009F; Mon,  9 Feb 2026 09:11:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B03A66B0089
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:11:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 842AA1A0113
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:11:02 +0000 (UTC)
X-FDA: 84425104764.20.FB0BF50
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf18.hostedemail.com (Postfix) with ESMTP id 966771C0014
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:11:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=N4ASDskM;
	spf=pass (imf18.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770646260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OxrvzS/b1u7n+TWx7ZNbZJZsDvABsNVL9CWNJK/qzlI=;
	b=VwIwwO14QW2mihHrq3K++uQ6UvDtd3r72PF1O0nsGo8dzdkE2tcue913wOQnE6+Wf3GAeJ
	MM1fWOikVcZRUZmn0b/3NsJo88E47e4f9HP5VW/UTuCdrzIbgwkK4M+B7ZTvyddVn8X/sZ
	LZevKSxhgEkwL61HiWQyZJey4Gojt0c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=N4ASDskM;
	spf=pass (imf18.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770646260; a=rsa-sha256;
	cv=none;
	b=oR5i8dhFVjmRqRZcLYuVBrJKKMTTO4LUfu8QSGzXOW1mTa3rNf8kFzvk7Q3GgGueL5DhcY
	t0U+xi3HWerowA68CL5iknb/2RAz22zDvs+CfrCr2V5Hh0cdPY5hPz55DAHeRNJZOFuUF4
	e+mfXyODeWROvxnhYB4fhsFduHDObJs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1770646258;
	bh=XsTT1aouWN0PI0Cgpb6lDz1G8jjSfhV7436FJ8s5GG0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=N4ASDskMiPY2popv+86n5/fBaI+hHHWoWPPwXCdlbFGLIlrriRsIxHeCUwwIL/Eu2
	 TDLigTyyaNj1q5chJhPcwbEupmfGnVuiHtMBK5dfAcBB95+UU6ouzABSa+tYpaDoOB
	 pHn4cpQiSyGUo0wz6B4NncABL4NvKyvi4vqAn3mxq5gfzfsqroam4YoFGBv+5H/rV0
	 M0L/bKN8O/aBz7+esuH69FdPVHIqBvOJ1A5GieFxfO0RIENvnPq28HOsSiC02LvdIb
	 kNPhdwpW/+X+SRLJwjcpJou0aXcKHGDj+r/JlmFqQoOwRtfPFSeW8K7E60myI2m8g/
	 ACIOlbVHSgMwA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id A88B117E137B;
	Mon,  9 Feb 2026 15:10:57 +0100 (CET)
Date: Mon, 9 Feb 2026 15:10:53 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: loic.molinari@collabora.com, willy@infradead.org,
 frank.binns@imgtec.com, matt.coster@imgtec.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch, dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/6] drm/gem-shmem: Test for existence of page in
 mmap fault handler
Message-ID: <20260209151053.397844d9@fedora>
In-Reply-To: <20260209133241.238813-3-tzimmermann@suse.de>
References: <20260209133241.238813-1-tzimmermann@suse.de>
	<20260209133241.238813-3-tzimmermann@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 966771C0014
X-Stat-Signature: o5i9g55tngbjhjwf98oan1okfb75xfey
X-Rspam-User: 
X-HE-Tag: 1770646260-570803
X-HE-Meta: U2FsdGVkX18gWvAuMxphy7PTLFlzfhOZzZXLNI1Dr2gQ6tqFEdUcsCSND5p0dHVGJor1jNCi7nE7gtP6U9cMXE2L+4bTlpbbqY9iAOQ3+cjFsA6kE0De4HKVxtx4cgmclNti9r6HjEDj2lQglODhCGgCTBHX/FraOQGUq4dvzHXS9eZvlWVQ4sTnIfqXX62kTX6Vj+Arnu+XEvwOtn8vjLOtxych0/mjuM9BEHByPfs5M+UfnOdI9YNpbpbDfwF/52l853q1Si/HCTCXzLmhBowCM84BgHZ3UEufTnEX6h5czXjjrWa9wXCke9mwyYAt57PP2OgGSAItMsgWC/cQ9AmsNutd9WSWPEXwUDYb0X97UeNg9T8bul2o0BRrq3VZnibs8A5Tk38aZcSg0PyGexk+skdzNEyamj+MzS8P/nlEvaK3/2GBYRRwD86q4EPvgJT2s8VdKESJIGVkhNm2XAAmPrw63snq8dmFqotJCi6SwtEHpo0aP45PmwM+Tt0SNhrcQzzkv7Jlcr7Sv7tzKDoRKS1Y0Q3iAZfZ3UYSZjVIpHckG9Hq8/sZJbNN/4/FnO8Cux3Wc9+1wJUDqXaw9YF7iWNBnDa1AKA/iT45rIWEZSK3dVcmpyI4yo6PvanTPQDMwZmfBThTDu+6zQFap1ciujlfsCJmC6H5htiRXAQTbAFf/FxKgaAUC0IkGDZD8MaOM8X17XaLhMwsKkXFfgorQcSKmT+0uioKCZTLQh5GbrhDlMhul5VOj7jGZ4KUcaKyJ1qV/CCoGpRzvt22uCCztiLJrKhnYA9+NwKxcHqzJA6osA6YheGz5DZqFqotZ6LfShD8yByOawWszsSdfF7dBENyivHCcycqg39dNtRVw/d0+keF7t9xCwPAWfzFIGQ2czdi2qjhTSqEAd4fP+eWx5346VD2QYSqVEp1F0bMNmxelCaZYLWivVtdI/AnuyNb0lSar4JdSEInOOr
 Yvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  9 Feb 2026 14:27:11 +0100
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Not having a page pointer in the mmap fault handler is an error. Test
> for this situation and return VM_FAULT_SIGBUS if so. Also replace several
> lookups of the page with a local variable.
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 5bced7db0f1f..3ee54c24e535 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -574,31 +574,31 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct drm_gem_object *obj = vma->vm_private_data;
> +	struct drm_device *dev = obj->dev;
>  	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>  	loff_t num_pages = obj->size >> PAGE_SHIFT;
> -	vm_fault_t ret;
> +	vm_fault_t ret = VM_FAULT_SIGBUS;
>  	struct page **pages = shmem->pages;
> -	pgoff_t page_offset;
> +	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
> +	struct page *page;
>  	unsigned long pfn;
>  
> -	/* Offset to faulty address in the VMA. */
> -	page_offset = vmf->pgoff - vma->vm_pgoff;
> -
>  	dma_resv_lock(obj->resv, NULL);
>  
> -	if (page_offset >= num_pages ||
> -	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
> -	    shmem->madv < 0) {
> -		ret = VM_FAULT_SIGBUS;
> +	if (page_offset >= num_pages || drm_WARN_ON_ONCE(dev, !shmem->pages) ||
> +	    shmem->madv < 0)
> +		goto out;
> +
> +	page = pages[page_offset];
> +	if (drm_WARN_ON_ONCE(dev, !page))
>  		goto out;
> -	}
>  
> -	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, pages[page_offset])) {
> +	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, page)) {
>  		ret = VM_FAULT_NOPAGE;
>  		goto out;
>  	}
>  
> -	pfn = page_to_pfn(pages[page_offset]);
> +	pfn = page_to_pfn(page);
>  	ret = vmf_insert_pfn(vma, vmf->address, pfn);
>  
>   out:


