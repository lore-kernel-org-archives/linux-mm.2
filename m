Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC848C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6536B0096; Mon,  3 Aug 2026 09:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7126B00CD; Mon,  3 Aug 2026 09:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C481A6B00CE; Mon,  3 Aug 2026 09:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF316B0096
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:34:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3B478063E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:55:31 +0000 (UTC)
X-FDA: 85059500862.15.56A9545
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf24.hostedemail.com (Postfix) with ESMTP id B311418000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:55:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=IhKc48r1;
	spf=pass (imf24.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785750929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XoWaLkbionFKOOeiPX4VjKQQpydPKudM92zar6pUNOk=;
	b=lGOZ2jxWKIEJ06f3rZbp0dWpp6h+cNjJnp5/R/FUzDTGkO+b9g8gi40nYf8Anx4IftQkli
	1K9idRAQAwNVuC5LLumzXb1KtMSFwdGd7JBZEpBnTmBmEvcV0k8POvFNNsV9IrBbmqCpM+
	k7EwvyGqVXVtog7UQ6pgjlCGgMjwtys=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785750929;
	b=NbXSWQXgLd6OoLtNgCgeNNYqTNGmPsavdTPN/jANQz2I5pidNKmMCLlIQPpbK6Zz2vUaH6
	Ly4jBsoqDLOFkfU6eJLp2dzHxdlMFVo9yY14mjkYj2u1LoN5w+S3VbZTvkCu5mBKjaw9cI
	vrYJQIHJA1NneQEsweBxXMG7VImsDgo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=IhKc48r1;
	spf=pass (imf24.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785750926;
	bh=juMtF9il4sHowpmbeVJrKoAlrCCK8CRS0TU3O/3OaI4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IhKc48r1Lzt3DW7Dos2CZuRcmKicqjJJryVbp21XxDLGs/et3I9TMzxUyS9mWKHNX
	 mGRqNzwhIvxFEG3vlm8Rg5xwKTAZ17YVVbWeLcwGZ88GwmexCJg29HNjcOejTKfey4
	 8s7YErlmfyq1zpkqb/tjgO3AmJTugLP42WdsnWamEFFBJMN3va3cvk5FAHpQXPOZPu
	 FvsyLdQSePbB/NTWLgogWoSy3/6c0ZnzLvj9SxWUMFe9BrMBP0d8phPTkvtG8uftMZ
	 RUnwPGGuvrb5BK1uZeM6vHfJzCOyTwznOyf2iSt8jHjRLFhiDoDwihUg8lFYI9w6i6
	 hhgn+Hu/Zg2MA==
Received: from fedora1.home (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 3BD8017E0048;
	Mon, 03 Aug 2026 11:55:26 +0200 (CEST)
Date: Mon, 3 Aug 2026 11:55:06 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Thomas Zimmermann
 <tzimmermann@suse.de>, David Hildenbrand <david@kernel.org>, Michal Hocko
 <mhocko@suse.com>, Sergio Lopez <slp@redhat.com>, Christian Koenig
 <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 bcm-kernel-feedback-list@broadcom.com, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org
Subject: Re: [PATCH RFT 2/3] drm/shmem_helper: use vmf_insert_pfn_mkwrite()
Message-ID: <20260803115506.5c0acb0e@fedora1.home>
In-Reply-To: <20260731164341.1109827-3-pbonzini@redhat.com>
References: <20260731164341.1109827-1-pbonzini@redhat.com>
	<20260731164341.1109827-3-pbonzini@redhat.com>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B311418000C
X-Stat-Signature: 5j7irq14p6x55gcwjqb4bf5farjpuoyg
X-Rspam-User: 
X-HE-Tag: 1785750929-520619
X-HE-Meta: U2FsdGVkX19iThoaXlgdkpz1L7DbUUzfbMO1ZRd4tplgi5rDAwSnMubTnM5M09mS2u2HPcpDpaCGRkGEQBSrGiPTz45hXE45QbCj4mByHYO0fBTCz3GWSjynTtFMKCln3MVxEwLeS8654YBZLadoCg/JHKEWfzR8zZEIkWSmQfpxz9YgymvIhE0OrNfCT9AApjxd6xxfcOULm6Ks4brWZ/nEQJinu+otMtIcNxAzd1BOfjiAwE4m+Vt7g8lVkLBIBLyOyJCWCbSlXnRLNaXZYj3dhdDmpiLS4o2nuhWSVva9kLYnrX7XN3Tp73w2WBNIWieiqqLbyXK6gOGuTvoTq+uYUrZJxPbcBhPAXu/5cfJ24tYDPGZdqJ6lybLkn9UDAZv9B0vCiqZ4AmCNHO1jmhkmqXalMFeDcTyKwKRXkfscZxT7ghPph9Yam8+JFGP9b6my2z+1jpqBdTfStkrKvKDqr6PHXGt1Ol6chSs8xFx3cdgQXhh8Dljay5NuDCuo++6+X24SP2CVv7JrHYAukE2ogbWFhyGb0640cqOk0rioiLvGhJXL2JCeVwBiq0DjjTvYHcGCRbxfPW5VCSgvtXGzg4IvhuZbvNrcBf25SUVM23x4zspdmG6KAMIZ+v4v5RJ1vCW8cZ/kFZeGroHS8xdBnT98oDeo6U7l5TRmntNZUs5h2EJcXgNRrpZpGcXLgw7ZfimphlZCWTtJk8SmYh0r/nh1CJigSFKFAJjDZXLoEpGk5h/9wWmicV1QzPSaZZ0eMWi5AJKzuZ/WqDMGX2SOB4ZcsN6j1hc7sOCizvbQjfxMDJGntO/47w6XdnBlMFY7nP8bp3SZjBwURakpWbz83Ua8TlrGm9KTZw60UU+tVHGZGQyx7LLqmHxLM9wG4wcqC1tvPKGXdMtSXD7mxFfjnnmY8bHLmQcKwkcfFo3Gm9XRDY5ZCwhRq6AbtfDqtfQjteAfcfpJfyvbT9i
 DJCnmR4O
 Q6vbnmQe9EsH2DpQK0KiMwW2LJg6AKL3FCpWEYc5G/+GDmIk8O77q/+mE6oRAtwu2hYQiz9y5LugVBNw8N+Ip5qc2VIYJP2p37ffUAa0G7bSPnnCw8osk2hH+srZVUfaW2Ftj4PCjObtPyPNgr6BLbuggD1G4cTyWBb1TkIqw8EoSjKFx/F8s4XiX0DDEMMCrdRqqoh67yvcLxM8ZOs7ufeFQhBaXTWXg0GE8eAgkTmhOdIyDEJAIOa8v3ofxKq+cBzfhIsHmTzg5LLzUd1DjN6jVC5GEfH9VXkj6MFs04qJ4wSAAWZYcoRPJacaXEhYLyrS+ELoMcCXyxm3qPnTguXTVWazUz+SV44BMoHJJOXGd+onESGLKvsz7BIoVUVbLD/pxTCytJKNDlM572+ZxVRTe5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 18:43:40 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> This ensures that KVM or VFIO correctly see a writable PTE when
> they request one.  Otherwise, a guest write to an unpopulated
> PTE from a mapping backed by a DRM GEM BO triggers a VM exit
> with EFAULT.
> 
> The code actually is simpler, because the same logic already
> applied to the hugepage mapping case using vmf_insert_pfn_pmd().
> 
> Reported-by: Sergio Lopez <slp@redhat.com>
> Link: https://lore.kernel.org/kvm/20260729072044.25796-1-slp@redhat.com/
> Fixes: 28e3918179aa ("drm/gem-shmem: Track folio accessed/dirty status in mmap")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

Glad some MM expert looked at this, because we had this partial "get
rid of pfn_mkwrite()" workaround pending [1], which apparently never
made it to drm-misc-fixes for some reason.

[1]https://lore.kernel.org/dri-devel/20260528114744.463484-1-tzimmermann@suse.de/

> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 38 ++++++++++++++------------
>  1 file changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index c989459eb215..33a14f558276 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -589,11 +589,25 @@ static void drm_gem_shmem_record_mkwrite(struct vm_fault *vmf)
>  	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
>  }
>  
> +/*
> + * Because the vm_ops have a .pfn_mkwrite() callback, vma_set_page_prot()
> + * has cleared the write bit from vma->vm_page_prot.  vmf_insert_pfn()
> + * would install a read-only entry even for a write fault, relying on a
> + * second fault to reach .pfn_mkwrite() and upgrade it, but that second
> + * fault never happens for fixup_user_fault() callers that directly
> + * walk the page tables with follow_pfnmap_start().  To ensure that
> + * they don't see the read-only entry, pass FAULT_FLAG_WRITE info down
> + * to install a writable entry right away.  Because .pfn_mkwrite() is
> + * not invoked, record the write afterwards.
> + */
>  static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
>  				 unsigned long pfn)
>  {
> +	bool write = vmf->flags & FAULT_FLAG_WRITE;
> +	vm_fault_t ret = VM_FAULT_FALLBACK;
> +
>  	if (!order) {
> -		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
> +		ret = vmf_insert_pfn_mkwrite(vmf->vma, vmf->address, pfn, write);
>  #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>  	} else if (order == PMD_ORDER) {
>  		unsigned long paddr = pfn << PAGE_SHIFT;
> @@ -601,27 +615,15 @@ static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
>  
>  		if (aligned &&
>  		    folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
> -			vm_fault_t ret;
> -
>  			pfn &= PMD_MASK >> PAGE_SHIFT;
> -
> -			/* Unlike PTEs which are automatically upgraded to
> -			 * writeable entries, the PMD upgrades go through
> -			 * .huge_fault(). Make sure we pass the "write" info
> -			 * along in that case.
> -			 * This also means we have to record the write fault
> -			 * here, instead of in .pfn_mkwrite().
> -			 */
> -			ret = vmf_insert_pfn_pmd(vmf, pfn,
> -						 vmf->flags & FAULT_FLAG_WRITE);
> -			if (ret == VM_FAULT_NOPAGE && (vmf->flags & FAULT_FLAG_WRITE))
> -				drm_gem_shmem_record_mkwrite(vmf);
> -
> -			return ret;
> +			ret = vmf_insert_pfn_pmd(vmf, pfn, write);
>  		}
>  #endif
>  	}
> -	return VM_FAULT_FALLBACK;
> +
> +	if (ret == VM_FAULT_NOPAGE && write)
> +		drm_gem_shmem_record_mkwrite(vmf);
> +	return ret;
>  }
>  
>  static vm_fault_t drm_gem_shmem_any_fault(struct vm_fault *vmf, unsigned int order)


