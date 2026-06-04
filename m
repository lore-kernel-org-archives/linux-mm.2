Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C701CD6E77
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 16:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1EFD6B0005; Thu,  4 Jun 2026 12:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECFD96B0088; Thu,  4 Jun 2026 12:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE60D6B008A; Thu,  4 Jun 2026 12:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D02586B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:49:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6396D401EB
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:49:59 +0000 (UTC)
X-FDA: 84842817318.05.A8ACE34
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 671A71C0006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:49:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JcQYAp7X;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780591797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A87NVINYasGU8b7TootJWTNUhNfOL1nK4vYccktouhw=;
	b=SnzK5dWmedYYPyH11vv4u2E5a2HeUl1YFWU/pNRV8qZ3Pcgs+FO5xggKGa2ppO/0dpxzsS
	B59zJKohAhg1NPwVwuXsKviqfzk6GTjiaQ/vqIZYm1Hb8Cq287+PjtIG/FffBvcNV+htd/
	NJXNIU6bwPD/55mvcqT6uIEy5dtEVjQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JcQYAp7X;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780591797;
	b=DQl/U3rNsQlmfxTuTnFr8HQ+88kOOWk00bDt3qfWziqJXOSuxvLpQlbgg/TC7MxfWfcLeu
	MxSAKlZ9qDbC4fRNhEAU1pjwq2jaPFxqybSGMXCgPw+L3xQ3Kv17oiC6gKzI5nzY6l4dIh
	te4KUeaycGHstIsL50E+BLPKC8AB3DM=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5aa69131836so858850e87.3
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 09:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780591796; x=1781196596; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A87NVINYasGU8b7TootJWTNUhNfOL1nK4vYccktouhw=;
        b=JcQYAp7X17w/gfT6fKnPHcxbnYy0aYV4QiOBMT2Tn5mP1OJ9E0WbiT0LWwyVPavmih
         xWdI39HZt9QsEPdLfM4ho1IosDWlstRt9zFTvpZHUsmJJqUHFFUJFixbQJLKdO+v94fn
         emnLzc5HjOVWqwxuHbKhGP0Bkj/W2k6dTc4yndoWHQORBnZyVOO9wuuq48s7WP7GHDqn
         DAWLbi5K1d1+mZXCLek3y0XTIHQ9HLOlISI8ik58ekdMiVJeoSAVb99iIDmJ3b5GWd+j
         PmtCMbh45fQCrkjr9LKuoR4Du/bK//KspM6t/pDMonXJGFtR5sL+chjVSRxoDDUvuyew
         QH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780591796; x=1781196596;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A87NVINYasGU8b7TootJWTNUhNfOL1nK4vYccktouhw=;
        b=N3pBwLo3ge2GUh14aDFobbSY0BC32oAm2XI8l6spMeUW4hcRxo03olLArieO2VXqci
         5Up/Ca/kS3w6dAw4F7i0hM2vPs7YUA/r0mFTKwwSYEJfp82hZevB4YGjxQkwDTQUvH91
         F+RykzieC1byUuMHJwbaVNcPxV527Iv7BHqC/K0kQ1czX+sKxVtBv8AOU3tXPe6ZVQhH
         eF83Zjpr6L2AYr15gzfkGGV2WDLrT17TwAWoiRz4yR2QkctTP9jcIvjtHqnnWMYQ4KzL
         /6FHG2k0BeiYSwD9wzXDC0XcUNjH4cJQWhFAEEQoQ1GgGjZA8qgZ832zcaCOMqM2YPvU
         L5pQ==
X-Forwarded-Encrypted: i=1; AFNElJ/W9cIzofWsKSi1yNp1PhO1K2pXxTSf1CIoKnnya5fux3+EN+LVZoifdJ7esokwzePC3M/6G2f5lw==@kvack.org
X-Gm-Message-State: AOJu0YykVrUIkP0WmsfY4Tsfcp+cf/qk1p05dXvgHeHOYbZbq9Y+VjEz
	UD+bjlik92QS7Ik+HuDX6tR1Z8cry6dESqPCmb+33z9dWToWvtvIH1cI
X-Gm-Gg: Acq92OHsFBNEsMKRKySBcqUGgWu3FD5LLHw0AlF019XSic5s0MQAtPcOI8tow8L6D/P
	Klw35q/7kPRP0ydf+lWeaI9EJox4msmvsglcsieDFQWjtCOezk7TPa6mZLONDCkHxAu+4nHcXDm
	U1YiXOc8NlDZAauMZQI4DAJWym4+mLCIjeGqvYxO8ASLSkmqPTcXMhaC3PWwZmuqpkHkO5HEFeY
	jkXOsJCZeq4Rm3LfyG63MVa0pk9LAbgBXF6I/dmvN63wHeTaEBdGR1KCuLe6p6zkscjSICWxOp8
	BorKKlobhjhxOy84ITYuIa71xkdDngnpfFuDs4cfsBU86v8rxF4s3756ZAy8niFiAbtNgUl9Plc
	+leLp2kH31kdtqktUREuxekslqmJp88Wa6ML2UHJJhHuSeP5C/IzOmUUOHoVUo82DJChKFvkmFQ
	8=
X-Received: by 2002:a05:6512:108f:b0:5aa:753c:d8de with SMTP id 2adb3069b0e04-5aa7bf75701mr2785257e87.0.1780591795348;
        Thu, 04 Jun 2026 09:49:55 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa7b97ac1esm1321971e87.54.2026.06.04.09.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 09:49:54 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 4 Jun 2026 18:49:52 +0200
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v2 1/3] mm/vmalloc: honor GFP constraints in
 pcpu_get_vm_areas()
Message-ID: <aiGssN5OS0nN7a58@milan>
References: <20260604113101.89510-1-kaitao.cheng@linux.dev>
 <20260604113101.89510-2-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604113101.89510-2-kaitao.cheng@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 671A71C0006
X-Stat-Signature: an3buofa5bxcjumsz5tmhff87whrzdsk
X-HE-Tag: 1780591797-503968
X-HE-Meta: U2FsdGVkX1+pyd1xMC4QoXJi8tmFxhflzMVKBheh+RhfVndxIbBQnM1qqSi6DQLSTEX0Nabk2Fg3bJP8vBf0yNfmPVb3q/e2Klf0tJTeWQZ1Ezfng3ULkpWb63hmkv1H6kN/pFeYAKQ+BhHRsMtB51LM4kjjHLzi2ad+aJfFtyKr3+TTy+XQDIVb/YKgPa+9kr6Gw3pGiOKY4gchqkoXS9xq4CVFBK2eK2BrPgt+yNnr+k4I5ZmEVGKThKd8nxhRpsijBs50Pa4pA0mbJzfMRrNYXs5HOaRbdRwCZVFGyHNoMVUFJH+yveeiGw/vEo3MVL51M2dJwd/tq1XbHYikUYSqY1RRVXp9vUdwNa7KkKvJc8F4wxGq6Z9fLVH3e4tD150wF1F4uztQxlYSzENHsfvQJ4qjqIUYLHF5OlDpJ1Jjy+IlEq5Y4kibzNgVFIkY8Rt2BTnmEbD//5dQoP72lXzrLafoZqOvWlRj4/5Nue+jv3d1EH+eCpHQ4C7rmaTxVLPhdpek3h74VJwc2T/Ij3J7znM8W6P2DQR133NqJunGgWXDT2XRkvpJXSibAz9/+er9sZq3wPDGUBY38BWa5fi1ka9pbEJBqqA7W0EVkX5SHYXnWKbgmaSAotB/GD5I/sisne+o/NK9FoQUr6ULJwk60YoKDfiDTEnlhQGR14aD2f40/BUMGD862+UuGQ/7sES7PCzq8bK+Qez1IN0ylOm2JQTxnbOPuF6z3Nj64MA0Ex9JErOFTvcxSWZeVxZC8+mBL18JD/GcX5zZYhRGJvpDSjW3UlnKNwUqEYtAj7UZeEBtksWOfH9RvsHf0qycamTOc8h/FOVjsPoGo7mUUbGkIaLtt/vRUDkAvWRyYd+S1b5GHfcZZaL4yZgsiUKQMJk7+d9qgDpjX1HMSF5rNN0Y7NHV832MjsUv4CY1tsyhO+tKjBRsoSxUyqAKL3DGsIpaHCKTi/EWjDnUfh+
 5tC1Fw2p
 N9e6FuGvRJ0/mglheuVazY74ptISNZuJr9y+tM8S3xGTcQTFUM4hER25RpKpIAm4emOpJgFbRrgiob6JMOW5gPQcwxmGtQru7v+MS2ypLufxhdM5FlPPzK5c9CeldhB1G+Et/GRWIErgjSRy75JklpAAjaUK0kHff19oetNG5paaz4XfNeYG3+UdbsAK9PoUjUeOwel+kPuvGPfKotW6TtCYUBfFedo1ZfsNBul/nQzNf5xtRxiRXfzXsCPCK9QEFmUpjAcluXDxzQljPmPvdOgbWO3o+9ELxK//0Cm045mZhpcJB5/I2BlNxA6+cgiPK0YGMFXFS0ImzyPCs8eNOEqsIdMG/EsZJzIkWi0cBQ7WkoJpeBLRhC8g9IqGjH+MA39n4ZS9+h0Vw0YsmaEuQz0uu0e4XgjzXrG4azXT7Qa4iYMHVJEKByid4L8ijAxIv1jSLBe3Wb9WQNvsLIFc4UmXUB6L+ggMDCb0FotrfwrYu3qm7G3AOJh1kdEPQ0x17T8TW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 07:30:59PM +0800, Kaitao Cheng wrote:
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
> ---
>  include/linux/vmalloc.h |  4 ++--
>  mm/percpu-vm.c          |  2 +-
>  mm/vmalloc.c            | 23 ++++++++++++-----------
>  3 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 3b02c0c6b371..9601e06624c8 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -308,14 +308,14 @@ static inline void set_vm_flush_reset_perms(void *addr) {}
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
> 2.43.0
> 
Looks good to me:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

