Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B05B2EA4FD5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2F86B0005; Mon, 23 Feb 2026 10:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180D76B0089; Mon, 23 Feb 2026 10:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 058256B008A; Mon, 23 Feb 2026 10:30:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E53696B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:30:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9617216016F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:30:39 +0000 (UTC)
X-FDA: 84476108598.09.292E1A9
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id B2FB340017
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:30:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X+bMQtJC;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771860637; a=rsa-sha256;
	cv=none;
	b=L52TLD8fL/ezCATeg93aupUPWd5hZN+t79Kycj1YoRovurnBR33iwNr+lVztzAq2sYkmDJ
	tRajwka3vO93/B7mCoi5JLu1gGOc5H5W65hwg+4CDn3yHmO5IGNkFU5cI8N/bc8+o3Uv3m
	SvvK2RSx2/fJLyXvGPm0qmXFJuHivwI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X+bMQtJC;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771860637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Mks/OfOs14ryWESFq0ukBN3EdWq9QlH027cW2Z5oAM=;
	b=kwrvjyTeEY2274viz306iPnBpILmknVlwOAPbW+L5dgPGyEbRHzPGW86OV3pG9QVrf9Kq8
	s5Qo6vqjzQ0f1vovrS183CzQpOgO9x5C6TTa3KLHuY2FIvYGOlMOG5cVMrnCOSW7s8zUHn
	oz3OuCgMnWrPoNe/OGw7ziLEdBp3D1I=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38708180241so35091951fa.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771860636; x=1772465436; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8Mks/OfOs14ryWESFq0ukBN3EdWq9QlH027cW2Z5oAM=;
        b=X+bMQtJCMABEqa92kMQh0xCO5yK8nnuiMMHoFhaQs2Pu4JU115T8lhojStnY2geRAq
         2L7B+r4cbLVUMvu0e1z49r6+nFiglT3RvJoWcTuV9ZPq2QF5vvYfrXWBwDVtaaiGayIb
         JbxZaz8h6ouow+BHswhMAXEPVV7G2ATARK0tGxWDB4CR21J0EnRuwFQ8teCUb30AXGUa
         ypkwpC9fLmUSBNdE1SpxisPx6TFWu+7Of2MxnQTFKuKHUYEE9wAHkO8OdN2zlDsrW+p6
         WNnyXRd2ERk9XW8QVzJMZtwYCexrGA6xmdn9+dwMZH/1TfBMpUGUamALb/cc+TX6hsp7
         ew1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771860636; x=1772465436;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Mks/OfOs14ryWESFq0ukBN3EdWq9QlH027cW2Z5oAM=;
        b=aVjOFr87hzbLUI6EATCcIHLOMiD6qhSbHzvYAHbxNGwu/rbv1KruePb00iWX7r4Oq8
         nVz9+KHpYkfAjS59exzkxfLFQmelK/5SjX3IfHTkqEuoXNrYR2BL3taugNDIUFpNB1DX
         QdC32Swa4t9pbFZg1B3OJYfb2k9h4+qvlnG329yprRbhT4yDoe/WPahgogZiq6n56KZY
         3W987+IJQY/cEuUOzl8e7v4ag21Wq2eB6ppHDfMhlpacxA1vYBCjeKLpizrddhWZUxSD
         V+bagT8xKr88YcCRyzu+WhfCHV3W27TZjYu749WNX6ual/yTSZswIb7cvMoP2mJfS72Y
         IyiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQlQaSHs3jqYlBtmZlhtaapfy3xhCCG7q6Vk7MbZWG7uIyhg5nHM//5rFhNg0xeFErxvqAwY//3g==@kvack.org
X-Gm-Message-State: AOJu0YzbOrsBjMbxglG9SB00Bcb3rnvC+ILXtwl23+UDmYfaePOAPEYk
	IlCSqxncVa2Jq0iuTZFqvWWBOKW6zlmUoC/ZBaIJjrodhGI6oxiIYczX
X-Gm-Gg: ATEYQzwTCd6XrEgfpPEjQ7GA5RrJNCpVanZ5q1ZllcUcWe4ufC9CnkPXPZjhV24IQnd
	6giYHKFQBC4j1UL2r0QueF+J+5ahjIB5mTBovEdk7+vjNHKBudh/3XQ8zni75y2qdK/mjI8FYY/
	pKYc05HU7rimeBf6X8s2yFALRYRXYw3HJca8CWIfiGub62IpIftt9qo2UElpS8PLZ0q3ze1BDNA
	P/1QjzogS/guU5nRylZ/mHelU5x0mrQbeUu8jaeUbWXswhvPrkxNzU89reLYpW0rsm4yOFxHxAG
	LO1jT4G7tBwK3ICgFJRXObuwDVFCI+elpYTJzTjd4Sr3Teqi7Ig4k2CvoKVAVgia/E2g7GYnome
	Tngl2gT/ed0sGCfdGQwqk/+g9B1wFLZLC0evvXrMplGhPf+3ccI7NSbcBrkb5f8r6FDo6SzVBL1
	nLwb1EsemCj2ANFQZEnSFYt4eiJw9GWWETC3ubQ4NfKi1hqccOrSTk
X-Received: by 2002:a2e:be83:0:b0:386:8ea2:ef7 with SMTP id 38308e7fff4ca-389a5de6217mr31159511fa.32.1771860635535;
        Mon, 23 Feb 2026 07:30:35 -0800 (PST)
Received: from pc636 (host-90-233-215-147.mobileonline.telia.com. [90.233.215.147])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-389a7a201fbsm16328941fa.22.2026.02.23.07.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 07:30:35 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 23 Feb 2026 16:30:32 +0100
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmalloc: streamline vmalloc memory accounting
Message-ID: <aZxymBwx67pMn1ZP@pc636>
References: <20260220191035.3703800-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220191035.3703800-1-hannes@cmpxchg.org>
X-Rspamd-Queue-Id: B2FB340017
X-Stat-Signature: 9tc933jkbcjzh7qij3dr9p4b3xiot1yi
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771860637-179818
X-HE-Meta: U2FsdGVkX1+36By9f3Ua3xomMGslWwAo+6sNSLOvj1+jHjAVqz4Mw1Xf8a359ca6twGgnjWOKIImdqdwdfb8a1t98YKW6Zn4WUux8j1vLTp3/1MynMMgc8EWOxfhfzB301H31FRJlOJWFRE3MlExUeFtj1HxuA1UXIQ+JmGWBCUITmEY8+T8dMFzaRfcNdEfAE59WK12KDhzMQHjKHJuxxO2Gydpxjxkv2db3R4Jv8i0SJBBY8NsthymkAlKEEHhtuGbKvs+9/jAaSwWTcfXUcoAIqXVk4oAMy7+vubujKNJR4RkA/bASfay1k016a/qcULCmbnDR0CZIrsRvWQl9efkV6K2wdtg3JdqCi8KKum/Xeb2uk0GMKF2n6RH8HF5b0k0lZ8nGLBdGTWOz7/DKl1F7KIRNeaCByLn0FFyncTpWwpp+OZc3OGKs1f9lPKkaUnqSzcxXhcVCqkNLq83nl5PF46RL3Wv3pe1/rBWkil4sYd1KzTiUB1irrkstu+3MaWCbdn2+Lwi0+pAu7K4VquYUizt20rGuAfcypjKOq1Sso5rUL9RznRj93fgI5khn/tanAfo2I6FW5PxU9sL7nIjbpeWnpjOTHdWuEnuFVsMSekCABVu5bK1LuUDbX0+evxJW8S2RVUDX6csSV2gzu8UPqJLHmXKDTf39YuhXErt+IS4zTQGHW7C/17wK2Uvo/WHxOmg7qy92GdTl5RJjVvYI83pUxnYP6lTf1Jt+qyHYKKmD3WicgWIuqw1FHf6UGx27xfhaF1DdlZjVbVvgsTYO43kjIF4Yu9g6p7uxHH5xt+oe3B7q9DFEnFy7McVpk5k2CHXe24DEIPQemDIpXOThtfV8NOTKZ0IoCMGqcRViUJayEc9PH23oc/kNzuw9Yq6RLc6o49+5nj2L3vMFKTPR2IH5mw4gjwQ6lu1thFRFuknWiScpIHeVkvnWL2bRwlX8WuW3FQwwcKYJ4U
 7hjm/Ip8
 3BI+TFwf4mRKsVWTBVQT1SlWuZCqYP6pb/cMyOPWGe7YZSyasFWJYYrmRzT4LbtijizY8O3XBXekKIbrUiFkWgyXWF1GKSiUoHncnfLzc+Wea+e8o0C3lfae6WxKdvfdLDsZxc2uLEL+27dMkCFRWlFgktw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 02:10:34PM -0500, Johannes Weiner wrote:
> Use a vmstat counter instead of a custom, open-coded atomic. This has
> the added benefit of making the data available per-node, and prepares
> for cleaning up the memcg accounting as well.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  fs/proc/meminfo.c       |  3 ++-
>  include/linux/mmzone.h  |  1 +
>  include/linux/vmalloc.h |  3 ---
>  mm/vmalloc.c            | 19 ++++++++++---------
>  mm/vmstat.c             |  1 +
>  5 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> index a458f1e112fd..549793f44726 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -126,7 +126,8 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
>  	show_val_kb(m, "Committed_AS:   ", committed);
>  	seq_printf(m, "VmallocTotal:   %8lu kB\n",
>  		   (unsigned long)VMALLOC_TOTAL >> 10);
> -	show_val_kb(m, "VmallocUsed:    ", vmalloc_nr_pages());
> +	show_val_kb(m, "VmallocUsed:    ",
> +		    global_node_page_state(NR_VMALLOC));
>  	show_val_kb(m, "VmallocChunk:   ", 0ul);
>  	show_val_kb(m, "Percpu:         ", pcpu_nr_pages());
>  
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index fc5d6c88d2f0..64df797d45c6 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -220,6 +220,7 @@ enum node_stat_item {
>  	NR_KERNEL_MISC_RECLAIMABLE,	/* reclaimable non-slab kernel pages */
>  	NR_FOLL_PIN_ACQUIRED,	/* via: pin_user_page(), gup flag: FOLL_PIN */
>  	NR_FOLL_PIN_RELEASED,	/* pages returned via unpin_user_page() */
> +	NR_VMALLOC,
>  	NR_KERNEL_STACK_KB,	/* measured in KiB */
>  #if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
>  	NR_KERNEL_SCS_KB,	/* measured in KiB */
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index e8e94f90d686..3b02c0c6b371 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -286,8 +286,6 @@ int unregister_vmap_purge_notifier(struct notifier_block *nb);
>  #ifdef CONFIG_MMU
>  #define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
>  
> -unsigned long vmalloc_nr_pages(void);
> -
>  int vm_area_map_pages(struct vm_struct *area, unsigned long start,
>  		      unsigned long end, struct page **pages);
>  void vm_area_unmap_pages(struct vm_struct *area, unsigned long start,
> @@ -304,7 +302,6 @@ static inline void set_vm_flush_reset_perms(void *addr)
>  #else  /* !CONFIG_MMU */
>  #define VMALLOC_TOTAL 0UL
>  
> -static inline unsigned long vmalloc_nr_pages(void) { return 0; }
>  static inline void set_vm_flush_reset_perms(void *addr) {}
>  #endif /* CONFIG_MMU */
>  
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index e286c2d2068c..a49a46de9c4f 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1063,14 +1063,8 @@ static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
>  static void drain_vmap_area_work(struct work_struct *work);
>  static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
>  
> -static __cacheline_aligned_in_smp atomic_long_t nr_vmalloc_pages;
>  static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
>  
> -unsigned long vmalloc_nr_pages(void)
> -{
> -	return atomic_long_read(&nr_vmalloc_pages);
> -}
> -
>  static struct vmap_area *__find_vmap_area(unsigned long addr, struct rb_root *root)
>  {
>  	struct rb_node *n = root->rb_node;
> @@ -3463,11 +3457,11 @@ void vfree(const void *addr)
>  		 * High-order allocs for huge vmallocs are split, so
>  		 * can be freed as an array of order-0 allocations
>  		 */
> +		if (!(vm->flags & VM_MAP_PUT_PAGES))
> +			dec_node_page_state(page, NR_VMALLOC);
>  		__free_page(page);
>  		cond_resched();
>  	}
> -	if (!(vm->flags & VM_MAP_PUT_PAGES))
> -		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
>  	kvfree(vm->pages);
>  	kfree(vm);
>  }
> @@ -3655,6 +3649,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  			continue;
>  		}
>  
> +		mod_node_page_state(page, NR_VMALLOC, 1 << large_order);
> +
>  		split_page(page, large_order);
>  		for (i = 0; i < (1U << large_order); i++)
>  			pages[nr_allocated + i] = page + i;
> @@ -3675,6 +3671,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	if (!order) {
>  		while (nr_allocated < nr_pages) {
>  			unsigned int nr, nr_pages_request;
> +			int i;
>  
>  			/*
>  			 * A maximum allowed request is hard-coded and is 100
> @@ -3698,6 +3695,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  							nr_pages_request,
>  							pages + nr_allocated);
>  
> +			for (i = nr_allocated; i < nr_allocated + nr; i++)
> +				inc_node_page_state(pages[i], NR_VMALLOC);
> +
>  			nr_allocated += nr;
>  
>  			/*
> @@ -3722,6 +3722,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  		if (unlikely(!page))
>  			break;
>  
> +		mod_node_page_state(page, NR_VMALLOC, 1 << order);
> +
>  		/*
Can we move *_node_page_stat() to the end of the vm_area_alloc_pages()?

Or mod_node_page_state in first place should be invoked on high-order
page before split(to avoid of looping over small pages afterword)?

I mean it would be good to place to the one solid place. If it is possible
of course.

--
Uladzislau Rezk

