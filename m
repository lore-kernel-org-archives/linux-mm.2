Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC8C0D29DFE
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 10:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 431F86B0005; Tue, 13 Jan 2026 05:16:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DC8A6B0089; Tue, 13 Jan 2026 05:16:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300886B008A; Tue, 13 Jan 2026 05:16:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24DEC6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:16:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA08F1AE8E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:16:33 +0000 (UTC)
X-FDA: 84326536266.25.9268167
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id D1957140006
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:16:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CD4Vh4OX;
	spf=pass (imf09.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768299392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjsp2Pxh99kEipTyQ7GElGEt+SiIlC7dQ4lJqdrePlk=;
	b=08dKWzdK0WssF5cnhlIM80sEGAMCgil0J5og6F7snU3cFuej6lg19dBiP+6gd5Wtqb9chV
	hDSOPVHsvlvpsmKGkP38kVUbRwmmBWF6+QAkaZFRMNGdY4456loVmlEHhuqVPPi+qXqrT4
	aUInkTIWgqTsJvFo+Iawrrn7b0/2zis=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CD4Vh4OX;
	spf=pass (imf09.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768299392; a=rsa-sha256;
	cv=none;
	b=zFj3eL0jtqmdhyLLTJAlMq5YY+Lo8458rBjjHa2uvmXcfCnHRyA9V+3gtWYsvgmdINgoJQ
	/vGL4PvIV/BcLs0ht7RFV5KXt/BXzEpYV5+JqBglvgtwcwdnzUZbQ4ddj9EoYXJcgqP1Yv
	dQsiHYVdN1QPLNYmesD1vb7Ol30f/6A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768299391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vjsp2Pxh99kEipTyQ7GElGEt+SiIlC7dQ4lJqdrePlk=;
	b=CD4Vh4OXutSvkLtR9LWFddbN0rdWhXFKqC8Nk9ZqLOjUafUac3eR+ecu7xrn+DFFYkuiEf
	Qv+2xU9ttQJs2FVwtkPiA2qlc8lhDWQLNDp4bLyOO8tnSvvPBJ8qL5AO++apuprWyJxi3k
	npD3Il/dXfX+lv/Cl4hgJdq299kbdm0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-bLVTTVX1Pm2AONjrwC1DFw-1; Tue,
 13 Jan 2026 05:16:27 -0500
X-MC-Unique: bLVTTVX1Pm2AONjrwC1DFw-1
X-Mimecast-MFC-AGG-ID: bLVTTVX1Pm2AONjrwC1DFw_1768299385
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A42C51956046;
	Tue, 13 Jan 2026 10:16:24 +0000 (UTC)
Received: from localhost (unknown [10.72.112.148])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C3CB330001A2;
	Tue, 13 Jan 2026 10:16:22 +0000 (UTC)
Date: Tue, 13 Jan 2026 18:16:18 +0800
From: Baoquan He <bhe@redhat.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: m.szyprowski@samsung.com, akpm@linux-foundation.org, vbabka@suse.cz,
	david@kernel.org, iommu@lists.linux-foundation.org,
	linux-mm@kvack.org, vladimir.kondratiev@mobileye.com,
	s-adivi@ti.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
Subject: Re: [PATCH 3/3] dma/pool: Avoid allocating redundant pools
Message-ID: <aWYbcnglF5P/WhL4@MiWiFi-R3L-srv>
References: <cover.1768230104.git.robin.murphy@arm.com>
 <8ab8d8a620dee0109f33f5cb63d6bfeed35aac37.1768230104.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ab8d8a620dee0109f33f5cb63d6bfeed35aac37.1768230104.git.robin.murphy@arm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Stat-Signature: unz5ytrwfbf3ku64g3k1fza36omhd8n3
X-Rspamd-Queue-Id: D1957140006
X-Rspamd-Server: rspam04
X-HE-Tag: 1768299391-412236
X-HE-Meta: U2FsdGVkX1+M5knv8mFl1w4c2EGatg4TnLGkhuu23bB4VBU1hQyWladCz48450j6cVAb5ubhwSd05non7QLBztPOSAK7Z7fCeI4DFv7bQsxy+6f7Z2BqtKOtg2oFEPse73cwy56aOP4YsPqJUm5DJMvSRDXJN+DXSy2yhJKZWzEx4F8ABWetn2kbMpWDXgp7VC4Is4pEd5HgAgBpLuSrxOgbxaqX0ApT6FOxkS4pZF/wlSIK2sdBI4GQr8fVh1jDaxxGmeAQmxc11F1KAC9+lkwuVIRw521vxDSSTWvmQ9IewAEhbgctfG0ccsZ4XboBkCKiByRLaI9GP4Ach4L3XrHT5tMNQBI1t/d9HZsG7XKsg4YrKLN9G6LVrP3WHPLeDvwzugkYby+ChQtsr3k246Oz+7remDyNr5qF7RcgEseJ95+bnN6UvgwX3QQvPSIzQ0drYr51eA9IlU857rvah1LI+JwXQamZFM0CIm+w7WDBaRnPra9hf9XBxFzSGNDEgJZ72enn6lMW4rFfTk1mFKTRquSIGoYJjC8S2YC8/+fdUnE5vk14TNJ66ur5hS599fswYMwEsg52mZJ5aGzZ0qBoVSb5ZRIOyH4Lep/EyH4ojWKHAV4mj3ynG7XUao6b/ZWtrMtuYjII9kJotzGyDD+8hAcqSNc5aydBv7Li0ffXkVOmT9sJJl6if3CTMcIgVRZKymTB/yh5YOJktDcwH1H4YCh5Ks598+96j89o21o14HDRj/B4uCzqHnSPrJRn50tSSTwWPwc+0F7saRQE6vWrapKoePMJ3wce+rrfiW0mXkSW2jAUWsJIH6J3o0AyFWYCDrCe2F2R6RYwTTFx+8iqM61vNKI7MIhdQzSh+xJBbFTqItzEslOD0Yomw2f1KJ86E1hDrgCC0+Uqg9J1OEhtB/NLFC6mrwXVajVsN0Dlae4diC8t93ee3nrZqIX6DTAV4d4awWx80we9R45
 IGRZ3pQR
 dhbLWLCCSpjTdWDO66BRYWnKVdA90CouCwTSH+cHMGU0SBKPz1LnJVPptWeEcJeGjJ4PvyNGHzMbkQmjYR7C3TGZD8VfqwT0ReT00LHVmMZGCXqzgduG/8jPmXsFixOfwaJJBVOEE+5kk+bFKQ/IESjB3iZhyPpfbPFH+VibZ8Rq+7EUpQH4QbCGhZgKieopRJGIlkRMpxa3071tPZKVcH6KjJuKQHceN/0xH+dBVrCBVCZoxqrmx517+QLbIXEuO0a/i40E/5yIsGq9mXi7Px5qhZN4oPTbyKyx/NKXrOxYnpNmmhYeORJPLbM08kDLaq+hQtkHtTlVFnvYTmFpLL8KzsjTAXn0WsCMCjIEsD8Pv+UxQEt4jN9HGfaBl1cuf0DwJkzlQDN/CvdVgB7n5xq20rxA1LW9vWO0TOeZWJ/uWMRjmbVIcTSzRaob5/KdtUlpZKGQGqurkZGWGqL/TL8ORcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/12/26 at 03:46pm, Robin Murphy wrote:
> On smaller systems, e.g. embedded arm64, it is common for all memory
> to end up in ZONE_DMA32 or even ZONE_DMA. In such cases it is redundant

This is true and the whole series looks great to me. Do we need adjust
warn_alloc() to handle empty DMA32 zone too like empty DMA zone case?

> to allocate a nominal pool for an empty higher zone that just ends up
> coming from a lower zone that should already have its own pool anyway.
> We already have logic to skip allocating a ZONE_DMA pool when that is
> empty, so generalise that to save memory in the case of other zones too.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---
>  kernel/dma/pool.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
> index 2645cfb5718b..c5da29ad010c 100644
> --- a/kernel/dma/pool.c
> +++ b/kernel/dma/pool.c
> @@ -184,6 +184,12 @@ static __init struct gen_pool *__dma_atomic_pool_init(size_t pool_size,
>  	return pool;
>  }
>  
> +#ifdef CONFIG_ZONE_DMA32
> +#define has_managed_dma32 has_managed_zone(ZONE_DMA32)
> +#else
> +#define has_managed_dma32 false
> +#endif
> +
>  static int __init dma_atomic_pool_init(void)
>  {
>  	int ret = 0;
> @@ -199,17 +205,20 @@ static int __init dma_atomic_pool_init(void)
>  	}
>  	INIT_WORK(&atomic_pool_work, atomic_pool_work_fn);
>  
> -	atomic_pool_kernel = __dma_atomic_pool_init(atomic_pool_size,
> +	/* All memory might be in the DMA zone(s) to begin with */
> +	if (has_managed_zone(ZONE_NORMAL)) {
> +		atomic_pool_kernel = __dma_atomic_pool_init(atomic_pool_size,
>  						    GFP_KERNEL);
> -	if (!atomic_pool_kernel)
> -		ret = -ENOMEM;
> +		if (!atomic_pool_kernel)
> +			ret = -ENOMEM;
> +	}
>  	if (has_managed_dma()) {
>  		atomic_pool_dma = __dma_atomic_pool_init(atomic_pool_size,
>  						GFP_KERNEL | GFP_DMA);
>  		if (!atomic_pool_dma)
>  			ret = -ENOMEM;
>  	}
> -	if (IS_ENABLED(CONFIG_ZONE_DMA32)) {
> +	if (has_managed_dma32) {
>  		atomic_pool_dma32 = __dma_atomic_pool_init(atomic_pool_size,
>  						GFP_KERNEL | GFP_DMA32);
>  		if (!atomic_pool_dma32)
> @@ -228,7 +237,7 @@ static inline struct gen_pool *dma_guess_pool(struct gen_pool *prev, gfp_t gfp)
>  			return atomic_pool_dma ?: atomic_pool_dma32 ?: atomic_pool_kernel;
>  		if (gfp & GFP_DMA32)
>  			return atomic_pool_dma32 ?: atomic_pool_dma ?: atomic_pool_kernel;
> -		return atomic_pool_kernel;
> +		return atomic_pool_kernel ?: atomic_pool_dma32 ?: atomic_pool_dma;
>  	}
>  	if (prev == atomic_pool_kernel)
>  		return atomic_pool_dma32 ? atomic_pool_dma32 : atomic_pool_dma;
> -- 
> 2.34.1
> 
> 


