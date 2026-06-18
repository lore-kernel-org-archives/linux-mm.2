Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1579CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 17:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3030D6B0088; Thu, 18 Jun 2026 13:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9FD6B008A; Thu, 18 Jun 2026 13:05:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1B86B008C; Thu, 18 Jun 2026 13:05:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D320D6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:05:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60B37A015D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:05:35 +0000 (UTC)
X-FDA: 84893659830.04.108A4F4
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 50BE280014
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:05:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=D9sTB9Q4;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781802333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ybW0XDMXWhhPRAahHbsLjLyEsfhFFCr/wzQmAvHHa+w=;
	b=6adqh4sju1MOTbKLvUw3/SF5ofNI/eC5eG3Nx6chuxcNdjgRUNRXf4aemsJtEOFT2/LQD0
	1c0ebz2zzMc5ppRFoisN6WTRtIbLboRa368yDmyMMt8FxtZYyFdASAG4SbvF1gZ6ZmmY2F
	WoRHSlxkNa3uAnRMXsBLkDcXaXzFaSQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781802333;
	b=BWFtZOb26KFKWjM8UYrg293UeFPpePok4x20YojNOTySi0QCoR6p7T7sBzh2jyFn9ABsMN
	8A4h8NNb3gIQNWMgF8LFZnY6NLSvsf9spiOcY6zw6lSSVR4iEelk4QhC2tRrr/XVGZr9B7
	Ip7itRJeUYWbAaDaeistYwBYnB/DCjc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=D9sTB9Q4;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so8607715e9.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781802332; x=1782407132; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ybW0XDMXWhhPRAahHbsLjLyEsfhFFCr/wzQmAvHHa+w=;
        b=D9sTB9Q4bAs/SXFyT1f20bsoGeuN3oYoEjySBJgcCO6xw4iRg1Fiz7BWbQqTv0FdNZ
         k1znPy1Z4Slo0N8leL/M8nu6l/DWDZge2A2/Mu6YzyE5bc+u1dIhPKoKnFV9AJ/YJw3e
         7jAZDOno1/bo7U90d261R98aTZfTgdg5XUSyXQDjeLEsKLqTVfX7Yd0t6hB7mWO3XCtm
         IjaPo2Z0B3FZmpo6mGatzOiKdCNPgsQEjKoWb/D4Lri3vlHAJ24FPBgvF9eclZ30ah4R
         Fz8BjDApI12GoQ5Or5uEtpdb/6ewv/FsS1vJoiFutD3KsGiuE4kVMplfko2UxP65Q1VE
         uzyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781802332; x=1782407132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ybW0XDMXWhhPRAahHbsLjLyEsfhFFCr/wzQmAvHHa+w=;
        b=iVtmrnptVBtmGZiY+VghCcRGH33A9kl5876l1XRm1BPRfG9SlXjjFfdTgDIKWR4+lh
         f6V7LD5RuZVNMZkbQ4PXYiFz5Y8iMsS7ktKrzJAmE4pHBzhjnvjBCkiIsaLKJ1rjiAUx
         9kfxNcxASsRP3TPsM28b5JKGChU5FPjORlw7SKMpk9C1Hm3ISR3Ys4uKXkN5OkwbvTQT
         n34V6nCX+f5irOndKyBGwPUg0RCHEYFJkxna8MAFbPVFHBRQwoIrSWpmglmof5xn7MBA
         7AMHltfO5w26YdEheAubmkipseYXrkXIRHa65ZAUnxX2wbr1QcEudoCiUZQ98G8SBm3c
         e1Yw==
X-Forwarded-Encrypted: i=1; AFNElJ/CzxKuDM2t+zm2c8E4iJMQJF26x41VdplKIN2pcsskFm1RYVRF/2mqfCP1a7SkdD7XG+SznNeUfA==@kvack.org
X-Gm-Message-State: AOJu0YwQWny1ds9tPleWzYu09YMLyyCrl9merPYILCncwO72w1JrNYKJ
	e7xLKajgxvJeasmFS3oGX2nx8dO374OWWYBBZ1DV3/RmJ9Rl1qdRnZME4PKTYsF8cHg=
X-Gm-Gg: AfdE7clHIMr8IPVcBRyT9fYUptENnRDD+fzR/TX9WHyPxxDGTd1XmPKnJnlzpWTOTPw
	ZJLaR5rRhfzvSYFgYwoI8t0SoVGLFwfOMo9cJrkLLdnP9HuABaKVRHWPXwIAx+84ySa/3TtfymC
	yKqTzAPYE3gRhhil6jA2ttauBNMyAnEKRjxcWa3KVC3GOFAnxcaRv0WOFsE742ungySU1XB4iOg
	aTTEOVLvUlVuU3hqU0IkAkleJPW83CHWSzs2QRn+LgR+AqPxLAVOTRSLG3uUDbFHD6bQ+oHMnbR
	nh8g6gsah5iLf46Hvl8pJQV95bR8uOkP2TzQB3CiHUeEE//gqTPQ5VT7O4DyzCEgE8lMTr90SEE
	7+6H/B10ho4dxI9c0/2nBaVrk4C1U+Uv60N75z0GFXaaY4AESM1165t3nvZBmNh+RtYw5yAR1mV
	bGTqopQUBIJm5rIu3ZKtm1RqWGfQ==
X-Received: by 2002:a05:600c:c48f:b0:490:b645:3213 with SMTP id 5b1f17b1804b1-4923f56c119mr7287915e9.19.1781802331500;
        Thu, 18 Jun 2026 10:05:31 -0700 (PDT)
Received: from localhost (109-81-26-193.rct.o2.cz. [109.81.26.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd33dafsm2921175e9.8.2026.06.18.10.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 10:05:31 -0700 (PDT)
Date: Thu, 18 Jun 2026 19:05:30 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>,
	Shivam Kalra <shivamkalra98@zohomail.in>
Subject: Re: [PATCH v4 1/4] mm/vmalloc: honor GFP constraints in
 pcpu_get_vm_areas()
Message-ID: <ajQlWn2iyg-nPIR3@tiehlicka>
References: <20260618130414.96383-1-kaitao.cheng@linux.dev>
 <20260618130414.96383-2-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618130414.96383-2-kaitao.cheng@linux.dev>
X-Rspamd-Queue-Id: 50BE280014
X-Stat-Signature: t65k3hyiesgqdfktfz4uww6rsfhdht45
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781802333-417186
X-HE-Meta: U2FsdGVkX1/0JsiH1vgQopm/RA8QpK1vGm7tjZ+GO5IgGsnOoW+DUQmFMb8bBvBcw7K7C5vM77L0twztKzCtiCup5DBBp6Nc3c3sVq0cFWU4VqMrfyt2jtRZFWvP7jwzAspzCEVD70jtwPITdYLWeGgHnNdHvG+z2xoz7FAcfCJtzPJj0oPkXDJUgprP+J7D8suEQuS9zeotZ32EigaT6tLI2AvpvBb0ILMdzDVYarYa+A02KAchmQ+Q9nz/usyFltCyUYLABR/pPWCthHPxGjEpRHa/xxCA5MGCan27DJdA9m+VEYYMMV55SAqb/yYH3lhpcvAUwW6xRwycpFDlzSDz0LRjPgzKbXk82/klXsLWkT3yGG5UitF6x37MFoeC0mHOtiOw0ugPjkgnMLEnMCuw2yOf0DU2aMPC1p5GVumZemVNOkwxPHKmShmmHRuLp1k4diRo3v0O6Nx9j750GN7x7iy3eDWjG8UZ5s20x6okg//vS3LSUGyvYvzlpfQaFYX4aZCCZxMDJkmGEmaztyahsbLlkfQ3MCGHsopquK+NnvJJ76ILOKGxk+STOJvgdqauUYw33jM9Nqp1/rP/1ovhv2C4tZHkrE1sZI6jSsjdWpVNgYK6tm/gifCjFF9kJ2MjRwv9vdlSAY3dLBverAhdR2m3aVzzvqUrxUFe4fZar0GwsjB46mANEHXQWGGwmWW/DZJ4muUUN3h1mYsUGVhzf8ItOkBz4IeAJUW2iDFjTu4mCncU7+n3qN6fNwFFVSh3F/O8ChZpsFskztmdHCJCsFy1qSjgbXZoIQqiNjwttXuJqU5eTa5oswt9LZlqzgvGcnrQMqxPWcktGSvJnBm0srscoOOrlJQ7E4ISVdLvZBr/dXyXjSsRa/A36zUmF24qsjVLptUTMtzK+uXPgLe/Uk1WWgdcWEmVCCqHu7JnR1s8ouhyt9kq6h8wUbFsLdUUC93wasKEgfUbkLc
 KgFtubjj
 RGf4jZSMhB6CxF1X+VgxMW5iu/jH6rDCVmNamOEae+HlVY2Ldcjk1STYcjgkDl0FAVGJmD3npActUo80G7AsGta9Hf7iY4fsUIjXClbf+62dpC7AHTrgnR217+Og0JMHXhQ6ony40X5jsIUfEOhDg/YOw2SxCiBjkU5nwjs0W13Yv5GZIe0/Na1V+Y1N37rV1uB+Qp4fKmPBXqcLIcQeZMhvO5qtUzpRoizHHIYYHyAGSCPHJaS3P92mi72OFmDquD5+nojqVZfhbtLvUQy7udSIgAmHZUx569tK8qmDJ91WvwupszAnTykTE1zoL8PD3lzv+6rInN3hYDEfEHpQk3MAqueM0PBq0sglzb0H1BK4eErJ2D7r+oTKHCaIIs59afz8hXrZEhVsZapVWYnlK+nREadt/p4CBAT4RvvDMah5UNk5jSKede44bvVENdXaTvjVCTGUdvejV6YC7LYeUJEMmtLJa1ECKD2U1+cneJwZ6FmNlcaMVb7NRU8Rqq+ZNVkAg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 18-06-26 21:04:11, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> pcpu_alloc_noprof() derives pcpu_gfp from the caller supplied GFP mask
> and passes it down to the backing percpu allocator. However, when the
> percpu vmalloc allocator has to create a new chunk, pcpu_create_chunk()
> calls pcpu_get_vm_areas() to allocate the corresponding vmalloc areas.
> 
> pcpu_get_vm_areas() currently performs its internal allocations with
> GFP_KERNEL, including vmap area metadata, vm_struct metadata and KASAN
> vmalloc shadow population. This means that a caller which deliberately
> uses GFP_NOFS or GFP_NOIO can still enter FS or IO reclaim while creating
> the vmalloc areas for a new percpu chunk.
> 
> One possible case is blk-cgroup after commit 5d726c4dbeed
> ("blk-cgroup: fix possible deadlock while configuring policy").
> blkg_conf_prep() now serializes against blkcg_deactivate_policy() with
> q->blkcg_mutex, and blkg_alloc() was changed to GFP_NOIO for that reason:
> 
>   CPU0: blkg_conf_prep()
>     mutex_lock(q->blkcg_mutex)
>     blkg_alloc(..., GFP_NOIO)
>       alloc_percpu_gfp(..., GFP_NOIO)
>         pcpu_alloc_noprof(..., GFP_NOIO)
> 	  pcpu_create_chunk(GFP_NOIO)
> 	    pcpu_get_vm_areas()
>               -> if percpu chunks are exhausted, chunk create may do
>                  internal GFP_KERNEL allocations
>               -> direct reclaim / writeback can issue IO to this queue
>               -> IO waits because the queue is frozen
> 
>   CPU1: blkcg_deactivate_policy()
>     blk_mq_freeze_queue(q)
>     mutex_lock(q->blkcg_mutex)
>       -> waits for CPU0
>     ... unfreeze only happens after q->blkcg_mutex is acquired/released
> 
> So the concern is that the caller deliberately uses GFP_NOIO because it
> may hold a lock which can be acquired after queue freeze, but the percpu
> slow path can temporarily lose that allocation context.
> 
> Pass the caller supplied GFP mask from pcpu_create_chunk() to
> pcpu_get_vm_areas(), and use it for the internal vmalloc metadata and
> KASAN shadow allocations.
> 
> Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Reviewed-by: Shivam Kalra <shivamkalra98@zohomail.in>
> Acked-by: Dennis Zhou <dennis@kernel.org>

LGTM
Acked-by: Michal Hocko <mhocko@suse.com>

Thanks for fixing this!

> ---
>  include/linux/vmalloc.h |  4 ++--
>  mm/percpu-vm.c          |  2 +-
>  mm/vmalloc.c            | 23 ++++++++++++-----------
>  3 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index d87dc7f77f4e..e4d8d0a9f30f 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -310,14 +310,14 @@ static inline void set_vm_flush_reset_perms(void *addr) {}
>  #if defined(CONFIG_MMU) && defined(CONFIG_SMP)
>  struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>  				     const size_t *sizes, int nr_vms,
> -				     size_t align);
> +				     size_t align, gfp_t gfp);
>  
>  void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms);
>  # else
>  static inline struct vm_struct **
>  pcpu_get_vm_areas(const unsigned long *offsets,
>  		const size_t *sizes, int nr_vms,
> -		size_t align)
> +		size_t align, gfp_t gfp)
>  {
>  	return NULL;
>  }
> diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> index 4f5937090590..69b00741dc68 100644
> --- a/mm/percpu-vm.c
> +++ b/mm/percpu-vm.c
> @@ -340,7 +340,7 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
>  		return NULL;
>  
>  	vms = pcpu_get_vm_areas(pcpu_group_offsets, pcpu_group_sizes,
> -				pcpu_nr_groups, pcpu_atom_size);
> +				pcpu_nr_groups, pcpu_atom_size, gfp);
>  	if (!vms) {
>  		pcpu_free_chunk(chunk);
>  		return NULL;
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 1afca3568b9b..08f468135e4d 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4946,16 +4946,17 @@ pvm_determine_end_from_reverse(struct vmap_area **va, unsigned long align)
>   * @sizes: array containing size of each area
>   * @nr_vms: the number of areas to allocate
>   * @align: alignment, all entries in @offsets and @sizes must be aligned to this
> + * @gfp: allocation flags passed to the underlying memory allocator
>   *
>   * Returns: kmalloc'd vm_struct pointer array pointing to allocated
>   *	    vm_structs on success, %NULL on failure
>   *
>   * Percpu allocator wants to use congruent vm areas so that it can
>   * maintain the offsets among percpu areas.  This function allocates
> - * congruent vmalloc areas for it with GFP_KERNEL.  These areas tend to
> - * be scattered pretty far, distance between two areas easily going up
> - * to gigabytes.  To avoid interacting with regular vmallocs, these
> - * areas are allocated from top.
> + * congruent vmalloc areas for it. These areas tend to be scattered
> + * pretty far, distance between two areas easily going up to gigabytes.
> + * To avoid interacting with regular vmallocs, these areas are allocated
> + * from top.
>   *
>   * Despite its complicated look, this allocator is rather simple. It
>   * does everything top-down and scans free blocks from the end looking
> @@ -4966,7 +4967,7 @@ pvm_determine_end_from_reverse(struct vmap_area **va, unsigned long align)
>   */
>  struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>  				     const size_t *sizes, int nr_vms,
> -				     size_t align)
> +				     size_t align, gfp_t gfp)
>  {
>  	const unsigned long vmalloc_start = ALIGN(VMALLOC_START, align);
>  	const unsigned long vmalloc_end = VMALLOC_END & ~(align - 1);
> @@ -5004,14 +5005,14 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>  		return NULL;
>  	}
>  
> -	vms = kzalloc_objs(vms[0], nr_vms);
> -	vas = kzalloc_objs(vas[0], nr_vms);
> +	vms = kzalloc_objs(vms[0], nr_vms, gfp);
> +	vas = kzalloc_objs(vas[0], nr_vms, gfp);
>  	if (!vas || !vms)
>  		goto err_free2;
>  
>  	for (area = 0; area < nr_vms; area++) {
> -		vas[area] = kmem_cache_zalloc(vmap_area_cachep, GFP_KERNEL);
> -		vms[area] = kzalloc_obj(struct vm_struct);
> +		vas[area] = kmem_cache_zalloc(vmap_area_cachep, gfp);
> +		vms[area] = kzalloc_obj(struct vm_struct, gfp);
>  		if (!vas[area] || !vms[area])
>  			goto err_free;
>  	}
> @@ -5101,7 +5102,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>  
>  	/* populate the kasan shadow space */
>  	for (area = 0; area < nr_vms; area++) {
> -		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area], GFP_KERNEL))
> +		if (kasan_populate_vmalloc(vas[area]->va_start, sizes[area], gfp))
>  			goto err_free_shadow;
>  	}
>  
> @@ -5158,7 +5159,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>  				continue;
>  
>  			vas[area] = kmem_cache_zalloc(
> -				vmap_area_cachep, GFP_KERNEL);
> +				vmap_area_cachep, gfp);
>  			if (!vas[area])
>  				goto err_free;
>  		}
> -- 
> 2.50.1 (Apple Git-155)
> 

-- 
Michal Hocko
SUSE Labs

