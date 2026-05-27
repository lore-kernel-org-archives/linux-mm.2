Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75ABBCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 10:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD296B0005; Wed, 27 May 2026 06:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66406B008A; Wed, 27 May 2026 06:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3AD6B0093; Wed, 27 May 2026 06:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDB466B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:18:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60BD5C1F5D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:18:43 +0000 (UTC)
X-FDA: 84812800926.04.348403C
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9436340012
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:18:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=MfBVuMQr;
	spf=pass (imf07.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779877121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=haBQERx45uHlpfIApL+SmjV0hL8KIRhpwBxMpgFLOOU=;
	b=nOJM+u42CdcGH8664GEl82wVtEPa9fgtCyAtys4U8EVAh10pHlqhYwQ9UHby1kMT2eUmc5
	WvgHCvCcnA6dKLbHZbpnsFZODh+qyyyLzs0/oRiA70tFh37LKPddiu4G5Ne3JQJAsD9Xvr
	1uFib9XYxtOsuZEjaF5Kej1imDuJ6WE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=MfBVuMQr;
	spf=pass (imf07.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779877121; a=rsa-sha256;
	cv=none;
	b=Rbqx2oUTqK7gWFptBBmDEtWIS4qiskG7PN4bwV4NMQqLtGLqPKN8Th6Ev1kkmbC19Tc4hj
	UowNxPsH2ou9SZW0FN1slFlg37ch/yXDJSRrgak/aRU2qBkrjLc00CFKguuLBB/y5nw++P
	NkrjcdlhWtHArtceA+ik8wkeSrDTnlI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1779877118;
	bh=4ru3wYjtQnM8/T3ZwOVDnP+xTOoJR3KuUN+b8D2TEW4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MfBVuMQrz+Ajs/ARbEEcg8WdWJUVy0PYzBS9azsAlXQ1r5Ci0jfqmzRAePWI2/G5B
	 TysT7sUgy8mdrNobUd4IS6b1ykrEKu/w1av5GZSXMeSIWEVY0gp2eg4hSK+Q3lMVjL
	 z+uT8oC7mjGMCny1QXIyPkZ40UCYUHtNSlJ4Bzi3WUeOsuxWvx7vr2xuHysW/mdZeA
	 c32AWgemx+Zi4+3dOm70EJr2auijgV4makuFSp/JiIK4CY208djoQez6Ir/810dqc+
	 YrgKN0yxg8uI1UhiLO02pEiZFYxeGAl7XiERZGhLsgM3H0DS+yce3DCq0+QwBgD0AC
	 V2QURmlLFUKkg==
Received: from fedora (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5A9B217E0411;
	Wed, 27 May 2026 12:18:38 +0200 (CEST)
Date: Wed, 27 May 2026 12:18:32 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Igor Torrente <igor.torrente@collabora.com>,
 loic.molinari@collabora.com, willy@infradead.org, frank.binns@imgtec.com,
 matt.coster@imgtec.com, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Message-ID: <20260527121832.7264f0db@fedora>
In-Reply-To: <67855fcd-2afe-4a1d-a51a-210e45f56167@suse.de>
References: <20260209133241.238813-1-tzimmermann@suse.de>
	<20260209133241.238813-6-tzimmermann@suse.de>
	<d89422f1-f00a-47b1-b68a-d949d6d6a974@collabora.com>
	<850e8355-7884-405c-a70a-986ce032c019@suse.de>
	<831c0943-c75f-4d42-aa5f-90ce34cf8530@collabora.com>
	<67855fcd-2afe-4a1d-a51a-210e45f56167@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 37rcbftcdkp9jzsankxxsx9gmipm76ui
X-Rspamd-Queue-Id: 9436340012
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779877121-138239
X-HE-Meta: U2FsdGVkX1+wqlno0SJibmmWh2gTLtCgbxcr3779cTDIKCiEoMvTIp4xP09suBCENYkePISjZpmZMpySuxzasaNDuU4sRa2PTmg60Vbb+zN9eEee7dRfx7l2ay0AlvR0qOZ0CDQ4uvnE4Wu2ApFCFW1TdgnssOqlhQ0tmV1pYGyM+QnuLPagVGuq8tI9mCTh62fDiZn4OTbaoqeHXO48HdrNejCTQGZfzZhIA5YnN7LhkQVo1YpDskuqxobaeasUeY78e/8x8723hvaN2Z8NzZOjMMG7bXsnOHrZeemG2W+/1da/ngOQb4+0zOJiJfcxtVQg7rJUn+B3+QZib7b06wwfVAOxT/IUMsYvCX1JdtLJfim2Gq4qkfh/WTdQtiONPWCNuYGstDEhy4y/WZaZEjPbVdi7aUVSP2jW0jxam8iqc5VPY2GU+gA/tuY/SJPiyH4ttPiPExxkxSKIRC1XAsFAjns2EEGYOTB6ecYDCi4VrGTBlovk9uMQJdkUOMLWbkq8EcEnqib0e1E3QNZDXYrgnA3xDzNlUFYJ2i1wAz8ElDeG0xG5uNExmXVaNRRmHVqqdxAl5Cot/DGgWGNbf4I97n4oA+Lgaw+X0M8IFoZU6QkYn2hSfh6emfZU1+As9x7EG9lnP7pW1vsez4nrTrN0dNbNPAgrFlPixgDjPtzqHoo/sZlvcwhX77z4QaLVxJS+hvpMKTGqHM7Fnuj/V58N3vjq1Rng9NHMR8RmHkYZeIT8u3OXqLnFPyrlmOU08YROxnJj93LjV5M1J+VLh7PxzJILdrHsuLoTekalslRuDrqn3EmEiXfqT1dpuiODg5YizTE3hU5tKx1k83GiOIUwIdqNd9QdWfSy8ZAQbXwsrSaYFmBzMH7Ua9xKQ/2MGPbcMd6tqMcPcNweyCt5w49UQ+EHYiq7dVOHqGh7K5lZJja1ISAIs/1spljDyK1dUrzpDaLhX9fqO8g0jb1
 jCuM22hS
 tSW2aQViXvS5F2PlS9jYZerga7b6r4Hc/OYYCCleDmP5eDoAaDiKVuPFhPoUKPtSHf0oW8VWokH7Nh7eQpsqzKVqJ+uHWzPaU+kRj/M5+aKs1Pt4Di8Ox4CVoC3Nbz5/7u31jao2idbtnKRHBLNyWrRI4J785C/dZw0FkfuGeQjRMlYjT++d+WCW2dLBRkl+Zx7IG1askFt9Cf05qiqtbjPIsGgiqee3HkjXSr9mAbmZL8jKLKC49VHMkMFbEus8//mr9GShHkBa2Q2HbEifu1Ezi2MQ9ftbwBoUl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Thomas,

I'm inlining the diff you posted so I can comment on it directly before
it's officially posted to the list.

On Wed, 27 May 2026 08:56:33 +0200
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 545933c7f712..07e117673124 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -554,21 +554,6 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
>  }
>  EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
>  
> -static void drm_gem_shmem_record_mkwrite(struct vm_fault *vmf)
> -{
> -	struct vm_area_struct *vma = vmf->vma;
> -	struct drm_gem_object *obj = vma->vm_private_data;
> -	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
> -	loff_t num_pages = obj->size >> PAGE_SHIFT;
> -	pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset within VMA */
> -
> -	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> -		return;
> -
> -	file_update_time(vma->vm_file);
> -	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
> -}
> -
>  static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
>  				 unsigned long pfn)
>  {
> @@ -581,23 +566,16 @@ static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
>  
>  		if (aligned &&
>  		    folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
> -			vm_fault_t ret;
> -
>  			pfn &= PMD_MASK >> PAGE_SHIFT;
>  
> -			/* Unlike PTEs which are automatically upgraded to
> +			/*
> +			 * Unlike PTEs which are automatically upgraded to
>  			 * writeable entries, the PMD upgrades go through
>  			 * .huge_fault(). Make sure we pass the "write" info
>  			 * along in that case.
> -			 * This also means we have to record the write fault
> -			 * here, instead of in .pfn_mkwrite().
>  			 */
> -			ret = vmf_insert_pfn_pmd(vmf, pfn,
> -						 vmf->flags & FAULT_FLAG_WRITE);
> -			if (ret == VM_FAULT_NOPAGE && (vmf->flags & FAULT_FLAG_WRITE))
> -				drm_gem_shmem_record_mkwrite(vmf);
> -
> -			return ret;
> +			return vmf_insert_pfn_pmd(vmf, pfn,
> +						  vmf->flags & FAULT_FLAG_WRITE);

I believe we can go back to

			return vmf_insert_pfn_pmd(vmf, pfn, false);

if the mappings are no longer adjusted to catch write accesses.

>  		}
>  #endif
>  	}
> @@ -635,8 +613,15 @@ static vm_fault_t drm_gem_shmem_any_fault(struct vm_fault *vmf, unsigned int ord
>  	pfn = page_to_pfn(page);
>  
>  	ret = try_insert_pfn(vmf, order, pfn);
> -	if (ret == VM_FAULT_NOPAGE)
> +	if (ret == VM_FAULT_NOPAGE) {
>  		folio_mark_accessed(folio);
> +		/*
> +		 * Always record write access to the buffer. The natural
> +		 * place would be pfn_mkwrite, but this breaks KVM.
> +		 */
> +		file_update_time(vma->vm_file);
> +		folio_mark_dirty(folio);

We can be a bit smarter here:

		/*
		 * Always record write access to the buffer if the
		 * mapping is writeable. The natural place would be
		 * pfn_mkwrite, but this breaks KVM.
		 */
		if (vma->vm_flags & VM_WRITE) {
			file_update_time(vma->vm_file);
			folio_mark_dirty(folio);
		}

> +	}

The rest looks good to me.

Regards,

Boris

