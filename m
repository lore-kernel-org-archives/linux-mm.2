Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73B3810854BE
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 09:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA2C6B0143; Wed, 18 Mar 2026 05:17:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98AFF6B0145; Wed, 18 Mar 2026 05:17:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1576B0146; Wed, 18 Mar 2026 05:17:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C67D6B0143
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:17:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 157258C014
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:17:02 +0000 (UTC)
X-FDA: 84558629484.02.D36BBFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5828C0009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:16:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SatqFpHz;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773825419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vg5DApBLnRnveNhDxPd4z30pMeAh61oVheOSKulSZc=;
	b=fI8UEiVpPZyNTRAf1Bm8d/aA38QwLTy6r/e4tnAvZeNFwBLe+LcTxZYRj78RdSS3xBHKJP
	nvYkNm8+tIC8U0emmVcAl5jo1OzLpFx3468NBfmLtNoobyqftkVx0NHoZhelysM+MTWjuT
	OJVCwa5ajyZoH4ge1SrNTd0Nzu7HPBc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SatqFpHz;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773825419; a=rsa-sha256;
	cv=none;
	b=K8CAuIJDI6mIODFrBBkIPTmxaESfO67qFNK8OoUzlRtw/jOcZ4rM/raLcsvthOcawKSuNt
	KUq7UFQGyIAXVU4g/7vYP8jX/9rr4/SHd5RCkSUxRR6fOl8dRpeMSaeqLHYH7Egsmxop4P
	c4H8FMVuJVjq0YiXRh+iki/GnT7BWk0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A67E60054;
	Wed, 18 Mar 2026 09:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1BAC19421;
	Wed, 18 Mar 2026 09:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773825418;
	bh=xreC6OjhR8b2vuZLjpAzaLuVTmeRPkmKaKfrFoVsz/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SatqFpHz9cPpL4L9ndUa2Q6S/y7v2dDfhqXQV+g3eARqBCjHhO9MFCQ2P55gjUWul
	 g7zwGiodabII84x0E11Xosw6CTV4bb/yzmzS/LGXeM2GWyyc8SagTIXrqGbTEVPNfx
	 IU9qETigMDz7cl8RW6taGT8IXfs5eO66iraSElrf/8a4PVuBHBUZV4jCgsV1n8+8M1
	 eC5AWdLXkpaxYdtzqWW2wPvCKfZpCYxkRmLSPOkuWjmzSVdGYSFeUmX5sZem/RgdVj
	 ZQCWpMv0zTq6MuG1sMxKK0zzaxCIvICxv9NQzoDIxUXWgCufqjn/qggVhXmbxGiczg
	 mJ+i5r0WZjRwQ==
Date: Wed, 18 Mar 2026 11:16:51 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 1/3] kho: make kho_scratch_overlap usable outside
 debugging
Message-ID: <abptg2AObfxkkxKf@kernel.org>
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-2-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317141534.815634-2-mclapinski@google.com>
X-Stat-Signature: bohdz6n6etjao943m5ecqy1udy4dx1o4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C5828C0009
X-HE-Tag: 1773825419-332253
X-HE-Meta: U2FsdGVkX1/sQgAc/PzF+aDoKjke8jJXnPgJ2bgX09O9KSTdTTbvOBHDPPXjE0TKEP2cwq2qc83wRTBgtuAN1kyJqElUVqSBOyaBUSQP+vPHxkwjQtL9IRApvmxQHNDQApLE3ydgSh74FTjg14zGwE7EIskjD8dHAR9jLPIffFKInGVPEOD5Ha6ViK8QVF9224FtgMZMAgrUYRdChWYWWXCrwmG/S6Q3xCFvadJ4MtgPMI2Tko4Jbl+R9unYu1kUxI/A3ltGYxPPxoYyky16gnRfih1cIecJfgB3p3mXCdOUJ4ANuADe0AMUB2Df3OggWQbzB2YXtOLHO02EUMgrLLLmR0IrCs/ov6SqAycpb4uvXUPkAuf1PsYf/NbJQKW02MNveSZ1RJ21PxDP/D4A+qv9Ex34/hFOqvkdGnqYT3RKtnOlH+T2ZMilEvEyRvMwS0ln5kipPtzpu7zH/cKZr4WxvJjCMPYP45uNkoCq4ofPralhntSCgoMPmAiUQLzjhQ33AzR6e3h/7hBO+khbaf/T4gmJqTs4jPiIAAFWtiMCvNoMmJeICQliZTWVUOjvVvXzngLCR/R4neeZy75WP1EONTCrenBatWgNUnWqx/c4rUs6VjiR29GkVLOygCRon3m13vhDTsPvqJTNoWH4FTjUXvaf6euz1QN7ButNBbdpUHLo2rBasXN5nvwqNNOZPShch5xMHo0/4viNQAI98kjOek6v++B091xvw3XFv7W7HmOV2lilauW3H27cO7WdnqRM3F0nnRgr4EyUhwusBM8cBLDwlxFp9ZoY7EMqW6ItQeARnQFHlk1l/cLYegr/HAO9u8eBAVCKJVh9riMgvGfgf3HzyXNh+ajwgnP0Uy66JEG6McYkuEv8aXdbvGHIRexmKul3BHIp32XjsO9IHaN1dSbqa1ISNHOQBRblLSzzxZ1iUFR44dffin7wxr0pFMuYrZSqCXPEm0zJkaP
 9szH+8Lu
 i0DjNxtXrc4sDnog3gxKjgAoWTC2R22HdTsFjsWUMCCoCLBqtqPHz6Er8ub6MXHv9sbz2mFznyCM1pJrZlQc4VK8JDa79B5kgVL4F6gycxI2uQjRRCy6v0FrvqPQIEkvCUkiQJnVoZw4bgux/AdAWI+ifPVEKs9dW0p79pDJhi5Egc7LxV77QnbNQdijOcmhO3b+MHpOl9LwGXrOhZoMnYJF6VmAJKfLTwFqWTvGZPTq3h3N+5RXlceKoyzg9RVwpCqdrlVJJnhJphRWTM6aVPluDq4qXyYKjjU90Bl1ndjGfhQM4xICjPNhM2gnkELJQ6pmj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On Tue, Mar 17, 2026 at 03:15:32PM +0100, Michal Clapinski wrote:
> Also return false if kho_scratch is NULL.
> 
> Signed-off-by: Michal Clapinski <mclapinski@google.com>
> ---
>  include/linux/kexec_handover.h              |  6 +++++
>  kernel/liveupdate/Makefile                  |  1 -
>  kernel/liveupdate/kexec_handover.c          | 28 ++++++++++++++++++---
>  kernel/liveupdate/kexec_handover_debug.c    | 25 ------------------
>  kernel/liveupdate/kexec_handover_internal.h |  7 ++++--
>  5 files changed, 35 insertions(+), 32 deletions(-)
>  delete mode 100644 kernel/liveupdate/kexec_handover_debug.c
> 
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> index ac4129d1d741..6a0e572c3adc 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -35,6 +35,7 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
>  int kho_add_subtree(const char *name, void *fdt);
>  void kho_remove_subtree(void *fdt);
>  int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
> +bool kho_scratch_overlap(phys_addr_t phys, size_t size);
>  
>  void kho_memory_init(void);
>  
> @@ -109,6 +110,11 @@ static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
>  	return -EOPNOTSUPP;
>  }
>  
> +static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
> +{
> +	return false;
> +}
> +
>  static inline void kho_memory_init(void) { }
>  
>  static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
> diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
> index d2f779cbe279..dc352839ccf0 100644
> --- a/kernel/liveupdate/Makefile
> +++ b/kernel/liveupdate/Makefile
> @@ -7,7 +7,6 @@ luo-y :=								\
>  		luo_session.o
>  
>  obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
> -obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
>  obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
>  
>  obj-$(CONFIG_LIVEUPDATE)		+= luo.o
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 532f455c5d4f..c9b982372d6e 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -820,7 +820,8 @@ int kho_preserve_folio(struct folio *folio)
>  	const unsigned long pfn = folio_pfn(folio);
>  	const unsigned int order = folio_order(folio);
>  
> -	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
> +	if (WARN_ON(kho_scratch_overlap_debug(pfn << PAGE_SHIFT,
> +					      PAGE_SIZE << order)))

Can't say I'm fond of kho_scratch_overlap_debug(). How about we make it

	if (IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG) &&
	    WARN_ON(kho_scratch_overlap(...)) 

>  		return -EINVAL;
>  
>  	return kho_radix_add_page(tree, pfn, order);
> @@ -864,10 +865,9 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
>  	unsigned long failed_pfn = 0;
>  	int err = 0;
>  
> -	if (WARN_ON(kho_scratch_overlap(start_pfn << PAGE_SHIFT,
> -					nr_pages << PAGE_SHIFT))) {
> +	if (WARN_ON(kho_scratch_overlap_debug(start_pfn << PAGE_SHIFT,
> +					      nr_pages << PAGE_SHIFT)))

Ditto.

>  		return -EINVAL;
> -	}
>  
>  	while (pfn < end_pfn) {
>  		unsigned int order =
> @@ -1327,6 +1327,26 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
>  }
>  EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
>  
> +bool kho_scratch_overlap(phys_addr_t phys, size_t size)
> +{
> +	phys_addr_t scratch_start, scratch_end;
> +	unsigned int i;
> +
> +	if (!kho_scratch)
> +		return false;
> +
> +	for (i = 0; i < kho_scratch_cnt; i++) {
> +		scratch_start = kho_scratch[i].addr;
> +		scratch_end = kho_scratch[i].addr + kho_scratch[i].size;
> +
> +		if (phys < scratch_end && (phys + size) > scratch_start)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(kho_scratch_overlap);

I don't think we need to EXPORT_SYMBOL() it and it'd better grouped with
scratch allocation functions.

> +
>  static int __init kho_mem_retrieve(const void *fdt)
>  {
>  	struct kho_radix_tree tree;

-- 
Sincerely yours,
Mike.

