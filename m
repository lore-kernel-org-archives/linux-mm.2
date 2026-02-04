Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC30E87840
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 13:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D09F6B00A5; Wed,  4 Feb 2026 08:58:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57DB06B00A9; Wed,  4 Feb 2026 08:58:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6CB6B00AA; Wed,  4 Feb 2026 08:58:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 390C36B00A5
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 08:58:47 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A38F1A016E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:58:46 +0000 (UTC)
X-FDA: 84406929852.23.2F46415
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8BFF140009
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:58:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=TzHv6l84;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf07.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770213524; a=rsa-sha256;
	cv=none;
	b=XRxbg8cMMUhBESHUOTwXNXXIy3ejXVqXRB/M9tTtW+MhFoyz3707Z3YiVdhQjKN4wbxCoi
	tgTelbfBfsgVfRoAhoUGmV4w8nOIi1jCXDZV/EtXJt+JjcYKhWEms3sEmHVGB2Bu/I+ujv
	+YD8JCXDklFrOQtDAGUaofgLWRJVwxA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=TzHv6l84;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf07.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770213524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=st3JhlKUyXVT/jVcU3mjZfWi3pTdXTM+g25x9HLMpfU=;
	b=5HUSL1LpLw1gtZSOiPf1Q2AQZ/d86olubETUDxODsrY7kNIETXXr1M1CnImnjxOoZikNc/
	WlanYbyC1dbpzc4mqbF7nA+Nhj7vg1DLORfHrBuJkzoZNCFF5EqeOHwodjyVwbkSgUxu+R
	/OXMSk8tkTuWk8NvpWBJs6rGX/D3pc4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1770213521;
	bh=k5UMXWgwFCcfrE3dxMlUTv7lURRvMh1vxVEAuRt2VgA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TzHv6l84ETnKx77sOQfP3C3p+0DEvzf0uI9mXUiO7YSl3w1FLFLvDz0IuvB5U+DMo
	 sdUrTp2ykoSXEIpOtVJ+KQzZS2Aqgt61+uy53TvsLfkP9xrUmYydC6lZSA62FoRKA7
	 8mCAbwxqMmAM/WdWLvrCuusWXhv63dBgAd67KU03aL/sPT1RXZkqTu7LVEq06zQ3dl
	 TLilyt4k2t8pZrrSDUwWGbCHTCYYssFyhodIXA/mXvMYOHo3rogBLGi+vZpdc/zzSP
	 XoemwdNDnx36fXM3P0XKWmzVFFgAFM0t14NsfMqkuwy4p2MpPJI+ioaWW+qI/TyKGB
	 8ulU6EQCuYkcA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 6EBDA17E13D3;
	Wed,  4 Feb 2026 14:58:41 +0100 (CET)
Date: Wed, 4 Feb 2026 14:58:35 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: loic.molinari@collabora.com, willy@infradead.org,
 frank.binns@imgtec.com, matt.coster@imgtec.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch, dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/4] drm/gem-shmem: Return vm_fault_t from
 drm_gem_shmem_try_map_pmd()
Message-ID: <20260204145835.2e98630c@fedora>
In-Reply-To: <20260204114341.195143-2-tzimmermann@suse.de>
References: <20260204114341.195143-1-tzimmermann@suse.de>
	<20260204114341.195143-2-tzimmermann@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8BFF140009
X-Stat-Signature: 196hwh6ijw88scz3335hhx156bdfrpto
X-HE-Tag: 1770213524-512537
X-HE-Meta: U2FsdGVkX1/HZD/bqcOIvsUmvol3XwTEgn0fHX0T7XVTeUBREoxcqgAAIThy07yGHdObs2JJvZh/UkFk+dF2S3ifxKXrkmtWGhWjs8ICB4y9QCfnPVbhrUyzoGMB2vqsiG0abTRBjkJ78mGfUFeJ9T6LqaRgdYX0UWOLSqbQH5W0IDuXl82ONh6YlHuxhyrioRbg5qlY4L/wVjs0gGfrkYRNQmqyuLRTbUbs5ORc5k9GCWlfhY8iqMTHlrtpOgdR4WpqLlMSAVuA//Hk4QZbT/DSSoSVqFD8oG0Vo4Fd/b/3QbRi9lgn6rv6PyAinbTJGKGJ9hI3Vsef8ee/a0BSLHfT0ZL9V2U3N2IGEU+QPSaf6li3FxkECLPAhuJJ6dMMOnO19tdd/qEsgkLiHrk0gDDwGOJDGqRZX4RCptR11fggWsMcx29XOX4FK9T/xQYE32meeSuOM2zR9JXwMMxZC3CtsWX7v+F1VXPedhMWyAhojgrH4a4JQASEuqaLZhsKDG/+IpZ9hBbo5OLfZ1gM/NCOnK0+eWGMAkvPF3fAks0a8x6oZZv6ero6gZbXb1UJVpYdkAVOFMO9eWvXNIU2A5LQJjwbYjEk5gUm0D92TZSjANbrwFsh2w9bjGyU/NZel7K53OWc+WkLHmYpJMWvAbzO2PQCTUI8nMXZuWuYmje/S41WIJvo1tWwVRi/szDdgX0pBjpniI7PyJZ/bAfHv0dsRxN+feekZvTIlHiqX5JdvgkNccqhrIqR0DcEn3dYcO7GGKWLmcFz4JXGeSWYvJuca+ekDNIS1FJr1H46QXfwsjxzDmIah15citIG7TBR0/h+TGz7KtIjHgUAVY/nRsHbe9OMqk+qUgi+CDg6c7rTgR9d5lsXYSbvHbhw3e+eucbY9bM204nJIpyA4HMY3rs8MAwZLNYZgD6wGomAl+zv/3tP08IU2+C9gKo2jtavV18gOVIFQ3W7t+olEzT
 SqeoeLji
 y76ukMRo+TDTODxpw8INqbE3NyKYTaRo9PTsK6lsw9CnnFCECOJLMfLpIinfOZ20gmwza1+b2dIkqSogjCdrfg/6kTWgmed0IkSGjWjecOSl7Hvh4+7NrY268ocrUF6ivtdAocwfRxklaTkbib9jMYCxtgT719W5s1Jf9BrO4wZPx0oI6vCfCEOuqicBGddyj4V6v2eyMiRFtFMVSrTsmd9vqbclVDrOr+bmtp4UcUQzO+v4I0Vt+XMo4i7nQa7M1BpSTQgCjaUxCsFy9WIswHQvKQp75jr6o8JUANdBcu4jtGHA6RCos+bDWwHyCCYc7E9hH3hIZF8YpqMXHxV9N98YmizEmlKKxr74cKUdGY6Aeoj0KJA93BVL2qiGnyBWYIDodOmDYSbIf9B/X3srcTG0UnzNmSN6xtYbZxP1q8m3Q9awmppTVUxUsN19q+DuMUVh8XXrfzqeAs66y8HIHXiObaR9195k8dItK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  4 Feb 2026 12:39:29 +0100
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Return the exact VM_FAULT_ mask from drm_gem_shmem_try_map_pmd(). Gives
> the caller better insight into the result. Return 0 if nothing was done.
> 
> If the caller sees VM_FAULT_NOPAGE, drm_gem_shmem_try_map_pmd() added a
> PMD entry to the page table. As before, return early from the page-fault
> handler in that case.
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Suggested-by: Matthew Wilcox <willy@infradead.org>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
> index 3871a6d92f77..e7316dc7e921 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -550,8 +550,8 @@ int drm_gem_shmem_dumb_create(struct drm_file *file, struct drm_device *dev,
>  }
>  EXPORT_SYMBOL_GPL(drm_gem_shmem_dumb_create);
>  
> -static bool drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
> -				      struct page *page)
> +static vm_fault_t drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
> +					    struct page *page)
>  {
>  #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>  	unsigned long pfn = page_to_pfn(page);
> @@ -562,12 +562,11 @@ static bool drm_gem_shmem_try_map_pmd(struct vm_fault *vmf, unsigned long addr,
>  	    pmd_none(*vmf->pmd) &&
>  	    folio_test_pmd_mappable(page_folio(page))) {
>  		pfn &= PMD_MASK >> PAGE_SHIFT;
> -		if (vmf_insert_pfn_pmd(vmf, pfn, false) == VM_FAULT_NOPAGE)
> -			return true;
> +		return vmf_insert_pfn_pmd(vmf, pfn, false);
>  	}
>  #endif
>  
> -	return false;
> +	return 0;
>  }
>  
>  static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
> @@ -593,10 +592,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
>  		goto out;
>  	}
>  
> -	if (drm_gem_shmem_try_map_pmd(vmf, vmf->address, pages[page_offset])) {
> -		ret = VM_FAULT_NOPAGE;
> +	ret = drm_gem_shmem_try_map_pmd(vmf, vmf->address, pages[page_offset]);
> +	if (ret == VM_FAULT_NOPAGE)
>  		goto out;
> -	}
>  
>  	pfn = page_to_pfn(pages[page_offset]);
>  	ret = vmf_insert_pfn(vma, vmf->address, pfn);


