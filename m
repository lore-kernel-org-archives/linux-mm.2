Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4679E81BCD
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32A406B0005; Mon,  9 Feb 2026 09:10:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CE1C6B0089; Mon,  9 Feb 2026 09:10:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA056B009E; Mon,  9 Feb 2026 09:10:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6626B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:10:46 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7D4314017D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:10:45 +0000 (UTC)
X-FDA: 84425104050.24.FEA762A
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf28.hostedemail.com (Postfix) with ESMTP id DF2F9C0004
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:10:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=awdnsntt;
	spf=pass (imf28.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770646244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GqpoZTOoqQeg/sPnbuxXNvz3jcbl4+d+2hh6+y2Ot8Y=;
	b=F8Ifi+YaiDuoq75xm51pRb4PtPcGfmn5eU9p+JMbbDvskrO8KXPeZMjDHsaOqC9m4xX2Ka
	Hnuotuzde7TAfTsP5jSGCt2aBmT2OYDb0G+qO9c9kIL+xWdJvLPSksCLFa9OXeAIVjQo0e
	I5IMnCLQ+ijz8/tD+KhslkC8jUId7Vk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770646244; a=rsa-sha256;
	cv=none;
	b=rpr3yWrr7tWghIYwzs/sigg14c2jyrxqPsdNmEsERN1Ml+05H30CkoEPbG/3CAiMFWdtT4
	fxmlb2AVSV9mz7tIFES6NqTKiQzM1tBu0vXuzePywdtGBQ2kBFsx4m0+PjgCEsn/6XWdck
	jjK5IPurChXvXJiuRtkhgWwBohze4Ug=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=awdnsntt;
	spf=pass (imf28.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1770646240;
	bh=hZkJVgJ7X2tCJW8hxCbMEX2eWCVr2C6omxspYOwQ0yQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=awdnsnttpnrxf2kSIQMnWGzZDpV1k+xmdUeIswLueRTYBQDpGa6V/ZdZSx1kSa33T
	 T5p3ulBDXmgs7ul96a1rVSlzLFZJRppsrVxKiIfDqNH/llDIorW2eFMmlYotkYqMLJ
	 jaFGEUnFFs7cksEwPs5qQBphkAB0iCQfz22g9Cdfdeto0fABFoIFrlawCeCNz4TYlN
	 VPL/E5APCcJzKi5FjHoO971eHZMLJ/CU2wX03n32bTfMnPU4lr8hyM/VyXo0NpMCY+
	 ttOSIu8RaGoFpwo8mpIp0BlFxEuKdE2bavwz7Ule8ULtbrN3bz0a8rVEipHreIDYTC
	 yl7ECoK7TQpvQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 817F917E137B;
	Mon,  9 Feb 2026 15:10:40 +0100 (CET)
Date: Mon, 9 Feb 2026 15:10:35 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: loic.molinari@collabora.com, willy@infradead.org,
 frank.binns@imgtec.com, matt.coster@imgtec.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch, dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 1/6] drm/gem-shmem: Use obj directly where
 appropriate in fault handler
Message-ID: <20260209151035.59889115@fedora>
In-Reply-To: <20260209133241.238813-2-tzimmermann@suse.de>
References: <20260209133241.238813-1-tzimmermann@suse.de>
	<20260209133241.238813-2-tzimmermann@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DF2F9C0004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: y967ydff71e79zdtaqb8sop7om73at5q
X-HE-Tag: 1770646243-604830
X-HE-Meta: U2FsdGVkX191V1iMqlET5jJI/SWwcaVlXqib90HRUYO0XLAy/A60Sn2Wu/3NM1QtVj7pj0Gm+vEMe/7VpW2C1zX7LfjJX9RMqXSHZAfiAPAa3llFlVJsmXgcIh2mUKVtP+GzWliLD1EzsX5LEI09V1O6+ajQ/Ry0Y6zyYBIncof/oJUwj0gJAYoyeaMca9dRrf8APvT+Pru8Zz2pK4AYN5/SEvVRaj3tJz9fHNcAzG1C51w/fFxiZSIW9RQloS14vPGojIT/GM6bujN7cD/B6jJjHAsuQTeUkKv9RCMWzNv+39NPHB0RhuOuSnQKopWQDzUal5H9J+aOsVspSGhw2VPA8Zho1Kv2EUtKZa3whF60KdUpoDvSVAxSObUCaphz+NE45A8el5KpcV6cJHi/8xiJS/LgIARm4dOAzkqLktrXFEG2Ou1NrX86O4p/rSAgFixtKK2hw2TqEslKUnErtUUgQL9vIRGKlTDf/KPIv0op6zDU8NGgSo5zaNw1H2ffA7JwzP9mzTedkSuNnudjD4Gmva2PEfqo7OVBut8e0mv1OqaDqVSPN/54BDFLHe9WlkC4EhPJXeG2Q+slPdlm2aZXTIcTFqDtBYiMZX5urOljEaB2bln8yWbu4JxPl5+TqOUX2lfjRlVVoZniJ/jbuEuufkHSmoFDactaboWVeflCwDYjMM2o4V4vCokFYaLGlUG7nOFA6fnSbHDyNBxCzhoTtjXoJN6kMnlTTlg/0RVHbxcKQq/NwD8a2IaaKR+RGIuS86Qn1Fr/HNyqtGPCfH/3+M6PNxIarfdoZxWE/McREbOP/JZQs6g+18zlEFxCo6SchunBMpoj+YZJxUEsNoFUl0TS+8RTgpIDI84/CnD7mKEt52muUW6bNQxO78Aao4XfZt89HAhWWIAKa8hkwCJLL6+R+TY3M9ieAo11vzbFRyLkfR6q9okhqM0W5BYDQLLRbBpbhYcEqadmYbp
 ulfCQCyi
 MGTcu9MhasWOKJSa82e7J5dTuxdcb0WZtsA5igjo3kNuWVSqg7cARm05/gguncWlWRjFQT/Zw7I4YVSvMJPHfJI4shXiTRQhnPL58CCMTIxYPuSRC/8lV0ZBuXHNOuukiBy4ct6CHNicYU0nT3EoCQuCkh8ns5kZtVa5Msw8gZe31CKvVd5w/Q2Qy2kFBL97ZLwTm1R0srPH34O6Oz312+bI+miHPginuKXEQZKl/bPOt2MrCqdAplKYpMEi5EEyQk7LVA57Z597fqdkV9Ow5UQsMU3Fr+MvgGtCRdZi0XppvfC7imBdC8GXLUflV8uHtO5xC8ktxNMPdLZYg4fn+twbfpgqhbM3SfRGz8JZT4jHtTO/NwsD25gWWrrxQ4ft/KDfT3DbRfGie3e5WvNAaDKoylg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  9 Feb 2026 14:27:10 +0100
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Replace shmem->base with obj in several places. It is the same value,
> but the latter is easier to read.
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 3871a6d92f77..5bced7db0f1f 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -584,7 +584,7 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>  	/* Offset to faulty address in the VMA. */
>  	page_offset = vmf->pgoff - vma->vm_pgoff;
>  
> -	dma_resv_lock(shmem->base.resv, NULL);
> +	dma_resv_lock(obj->resv, NULL);
>  
>  	if (page_offset >= num_pages ||
>  	    drm_WARN_ON_ONCE(obj->dev, !shmem->pages) ||
> @@ -602,7 +602,7 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>  	ret = vmf_insert_pfn(vma, vmf->address, pfn);
>  
>   out:
> -	dma_resv_unlock(shmem->base.resv);
> +	dma_resv_unlock(obj->resv);
>  
>  	return ret;
>  }


