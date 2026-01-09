Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C37AAD26D7D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 19:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284686B0089; Fri,  9 Jan 2026 14:16:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25C7A6B008A; Fri,  9 Jan 2026 14:16:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172936B008C; Fri,  9 Jan 2026 14:16:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 039A36B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:16:21 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 611491A082A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 19:16:20 +0000 (UTC)
X-FDA: 84313381320.15.48046E6
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 780A1C0002
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 19:16:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=N0pbCl0Q;
	spf=pass (imf22.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767986178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OY298V/mlr0e0R/jNCYCk/cEMiQwxaFCVZQ5rO28hR8=;
	b=0C9Lz+D9E+FLhNl6XNMDQcJYZC+o8XFsXWftgEt4gDNuRHp2Vzsi7nwkwjyLUyr1uzD2q3
	X7SoUuUw5G8Nr5NX3GTRaNjN4HL7GMBBLPcrYSjiK8eEef7W39PtaJfz5FS4x2WpGM9nxO
	J359IBJa3OfJ1s/l4onSqQx0dt0Yft8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=N0pbCl0Q;
	spf=pass (imf22.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767986178; a=rsa-sha256;
	cv=none;
	b=nH4fbn9GJg82aYC3ODg5NycW1j/OfZrQy+LZ7aYBokViD1mmj9TwNLPyB6TZfH38cZqrLy
	XFo4YMIHM3IjiPCUAupGzPHCDrq/l9Qr245yenGGY2nkYDdGOMyrw5DsJDXlt0KCeXbvQb
	vreWl6vxtvpN4y/qOaNrcrxylpycR5U=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29f02651fccso13095ad.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 11:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767986177; x=1768590977; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OY298V/mlr0e0R/jNCYCk/cEMiQwxaFCVZQ5rO28hR8=;
        b=N0pbCl0QUBEdE8jBRVojqGZVHOCbWS8bnakvM3btbmPryreBE3bH0C70LozkUJIfi1
         9ej8NzTRXdeINpE9pable2JcbhgB1SnRrq/aRgu20LIherC9bsmhZOf3rThO2DvwOnD7
         Teqx2ghND67sdOOlQyzr6e+6K8ghpGGpRxuYt+g9buRL6Z3fJy4bd73i8S2sePKnhFzB
         acD+a0Qz/6LxUJAH9o5ccceJt0Fjvs3x09M+fEFFeSoUoo5Gqhc+Y+AG35Br5GHLpILE
         qmGaX5QT3sJvwbGTs1iy5ji27XsrObjihYd3MJ6DLmMRSsFSC5oRYu+1BlmCRhHR/REX
         Da9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767986177; x=1768590977;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OY298V/mlr0e0R/jNCYCk/cEMiQwxaFCVZQ5rO28hR8=;
        b=MeS8sLq2TsPc9tMzf7W9HeTf/4JOdjDXlrIStRn688aK4SCFQNsHyIua7qzOcN3ZTP
         GvxjYVo9uxXzkqKwbK6DyRrgPwlPP+sAzzgtpU+T4vdoCdXRq9nZfMB3PEYdcV9VQbD1
         mvwLZQINhz6C1iIQSVqoNEpNG5EIpW6SYgDW+4aRUcYZcyf9lByX/xEYliLBFca/Bd6u
         Oi0wuGfdToSH+nkjp0UceAlZuqgccMmxTGLeBwDUM0OzKlrEWPrKUM2nEFRus+kdWDnc
         x1Hcg2KAmPfrf0ziztLpT+21VYZhwb3WlJNZlkPqaKv3PVj1XfdXnOju8c/ImIwk4EL6
         FmSQ==
X-Gm-Message-State: AOJu0YzfslcPF9zAvRWoLuE06O5iIxUvVjKSjE9Z5UhfKALQ0MFGiqsy
	KP/NSdoqFznBixGl9FKDBmrS17QxkxR+lZosiTWsr7lWouWvaiop2bKYRd2FEE54MA==
X-Gm-Gg: AY/fxX5zxEEmb4twrGDQHLoYRTvOCZH2k5pqRsQyVmfcjCGatZQ7vn102fMXMj6W2b3
	M7mUM5DW0l0mk+vGKuB7VfGoCrPbw15N+AtQecAvxYN9Qy9RnrNc4MZK+N8Mc3I8bk0HDczn/gx
	HNHHYtEf0j8smUnK/yTSgjiUn70XAulTdwrz0tq9CW2WDU45Y5R3ghb9yLGhwB8NK+HwwJB9Czm
	skJMmIRRE0tY5zKxd6111W4LCYnxu2INFXEkYRttzfMlpoKqwCys4EDJqEjCmz7PvPQJfBRgW52
	kmrJLW68cD19d2rSPIbqVgXXCkFvxKjw12MQBgO6xBxOflC8hH2dWG1RqvIpJXEYtrgxvr1CGqR
	KhxVcI6+6cV/wFLfj3p6CMV6090NFkiMifJKGN0NMq+VbaMG/KnywSsPBIbVb0oDJY99U9CWx+D
	Tg6wIoNU0ngiuAsCC2KT0Pt5m2vOVlfbYd+sdRzl0mf82wFoXV
X-Received: by 2002:a17:902:f690:b0:2a1:3cda:8e99 with SMTP id d9443c01a7336-2a4149da4e3mr360525ad.21.1767986176660;
        Fri, 09 Jan 2026 11:16:16 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81d87955bb6sm4087620b3a.50.2026.01.09.11.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 11:16:16 -0800 (PST)
Date: Fri, 9 Jan 2026 19:16:08 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
	baolu.lu@linux.intel.com, rdunlap@infradead.org,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v6 4/4] iommu: debug-pagealloc: Check mapped/unmapped
 kernel memory
Message-ID: <aWFT-Oh9bQsbqrXj@google.com>
References: <20260109171805.901995-1-smostafa@google.com>
 <20260109171805.901995-5-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260109171805.901995-5-smostafa@google.com>
X-Rspamd-Queue-Id: 780A1C0002
X-Stat-Signature: 8uz4isgx144ew5tjcyhnfbsqxdb3wj79
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767986178-254123
X-HE-Meta: U2FsdGVkX19N8MWD4VNmx/wY/fBpHh+e+Gqkdrht6SUktr+K1trC85CFi8hS5rHYdYfSQJ4dxJpx3FJUSIaiJWFg4DJ+Mbd58oKpksP44i20sk6hTavUyYrVRc2XgJM9I/rCag0Az5iyT74VEAPxNO8Edfqu8Lwy3TdOwc7JjbKTp1rScA2AypxBwizYcgilNN2vUVwp4YCGaxQHD1a44vkPcy9/V+ZnjgHbRlDFYBKbdD3ed+Havbh6S08pC7IIdfuY3Bif+z4+PoKVsct87KmUW58KHVrPzNMWMJ6Vw60mcCdNmv3Wom221YMV+VvWtCtNJaEE54hmi3uZRCjRRH79DdCTjPWNABEzt0vEHgCbl+cLVs/fss1lwbo8zZnwNu4d0bFpPq3wb4DJQQX5BPpi4SPJzQT4+Z76MexBTrtNO8vipFTwfuM+a3y8lli+OmNshPl+rZiUUx/kZFyvqn/pJiUgQIgsqbqBqVk33VJah5QtFU9ye2XVpgnT4aRHWubrO5FgylNcSVLIdImd8kicJLTG/s9iVwe1b6HEY7YBhwUPGtLcrsGZSLdJ/Qlng8teXdjageRkxwPDT+CROLiXya2k3NtK8vxpuw/bgowll3hr4BN9yhSa1j2iExsPw4AODlu7Z3LSC9Q+Hv6M1u5ykzHuG0jn5ooHUmaxabbHpO8MgtIm/HK+cX/MHENSTyLPxjpvJFLoULWgj1ionRod2/c4hFttt3hW4yFpKp3+2SGPtrvTgA9lVugE/m63HB6bhYiBYwNKf9JpTKNUf8/1huJpiTEUl32WQeQ2oE+RUivCNsmLvGhGp0qEGAkwi32A69rNNhsfnju81Kkv3KDx/SYjX2tIG4GEL1iDH/wYEwEQIUAfFoSBEJHVuABQwWgDUvC/BeQaVJSLSBJznvp7ffblIEpz5wepc6HUkxhxwwoNV9TXv53Y4WzoIg6uDPPsHBBOp/mWKEiu3ID
 Lu8IpxP1
 T7lMbQsopP++RuWFQNPpuW4zMPsOFheOcz1bay92oS0ptbxU45HAed56Rl2pFkmKqZy+spiWMF0xE2lMVpMElf1b2YOKkXWNHVXVPgU8DywanBz8u2qoA9M3Jsuid/I5z7GjiEM7JMPH8Duvhu78XVVoFKj5Yoi6Wn9leIFAcYsR94nc4awaesUMxKbdwXw/TQIF2rh2p2SWkTiTEmXWZCwMO2a47cmTnrp7efg+26UbhUFDN8DXbfauESeGn8Zt4fuQmUhJ9pAtS9iOH1gn/u0BV1kQl87SVoTRAJ/OYSIXUZe6fdR66MiQSN0u1+pug6MBkxCbKemqNmop3rFBEb9XAzBFujKuWq30la+8qqqslC8NOWYeXs2gcqgPm5Byj9nG9e2Q+SBgu2RTfJ+jomg8ROTc2N7nazcXbxFDUDwwXaoVdx+bf4s4YiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 05:18:05PM +0000, Mostafa Saleh wrote:
> Now, as the page_ext holds count of IOMMU mappings, we can use it to
> assert that any page allocated/freed is indeed not in the IOMMU.
> 
> The sanitizer doesn’t protect against mapping/unmapping during this
> period. However, that’s less harmful as the page is not used by the
> kernel.
> 
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  drivers/iommu/iommu-debug-pagealloc.c | 23 +++++++++++++++++++++++
>  include/linux/iommu-debug-pagealloc.h | 14 ++++++++++++++
>  include/linux/mm.h                    |  5 +++++
>  3 files changed, 42 insertions(+)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

> diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
> index 9eb49e1230ee..c080a38f45a4 100644
> --- a/drivers/iommu/iommu-debug-pagealloc.c
> +++ b/drivers/iommu/iommu-debug-pagealloc.c
> @@ -9,6 +9,7 @@
>  #include <linux/iommu-debug-pagealloc.h>
>  #include <linux/kernel.h>
>  #include <linux/page_ext.h>
> +#include <linux/page_owner.h>
>  
>  #include "iommu-priv.h"
>  
> @@ -73,6 +74,28 @@ static size_t iommu_debug_page_size(struct iommu_domain *domain)
>  	return 1UL << __ffs(domain->pgsize_bitmap);
>  }
>  
> +static bool iommu_debug_page_count(const struct page *page)
> +{
> +	unsigned int ref;
> +	struct page_ext *page_ext = page_ext_get(page);
> +	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
> +
> +	ref = atomic_read(&d->ref);
> +	page_ext_put(page_ext);
> +	return ref != 0;
> +}
> +
> +void __iommu_debug_check_unmapped(const struct page *page, int numpages)
> +{
> +	while (numpages--) {
> +		if (WARN_ON(iommu_debug_page_count(page))) {
> +			pr_warn("iommu: Detected page leak!\n");
> +			dump_page_owner(page);
> +		}
> +		page++;
> +	}
> +}
> +
>  void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
>  {
>  	size_t off, end;
> diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-debug-pagealloc.h
> index a439d6815ca1..46c3c1f70150 100644
> --- a/include/linux/iommu-debug-pagealloc.h
> +++ b/include/linux/iommu-debug-pagealloc.h
> @@ -13,6 +13,20 @@ DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
>  
>  extern struct page_ext_operations page_iommu_debug_ops;
>  
> +void __iommu_debug_check_unmapped(const struct page *page, int numpages);
> +
> +static inline void iommu_debug_check_unmapped(const struct page *page, int numpages)
> +{
> +	if (static_branch_unlikely(&iommu_debug_initialized))
> +		__iommu_debug_check_unmapped(page, numpages);
> +}
> +
> +#else
> +static inline void iommu_debug_check_unmapped(const struct page *page,
> +					      int numpages)
> +{
> +}
> +
>  #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
>  
>  #endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6f959d8ca4b4..32205d2a24b2 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -36,6 +36,7 @@
>  #include <linux/rcuwait.h>
>  #include <linux/bitmap.h>
>  #include <linux/bitops.h>
> +#include <linux/iommu-debug-pagealloc.h>
>  
>  struct mempolicy;
>  struct anon_vma;
> @@ -4133,12 +4134,16 @@ extern void __kernel_map_pages(struct page *page, int numpages, int enable);
>  #ifdef CONFIG_DEBUG_PAGEALLOC
>  static inline void debug_pagealloc_map_pages(struct page *page, int numpages)
>  {
> +	iommu_debug_check_unmapped(page, numpages);
> +
>  	if (debug_pagealloc_enabled_static())
>  		__kernel_map_pages(page, numpages, 1);
>  }
>  
>  static inline void debug_pagealloc_unmap_pages(struct page *page, int numpages)
>  {
> +	iommu_debug_check_unmapped(page, numpages);
> +
>  	if (debug_pagealloc_enabled_static())
>  		__kernel_map_pages(page, numpages, 0);
>  }
> -- 
> 2.52.0.457.g6b5491de43-goog
> 
> 

