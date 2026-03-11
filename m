Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B3D01125858
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD986B0089; Wed, 11 Mar 2026 13:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABBF46B008A; Wed, 11 Mar 2026 13:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DEA16B0092; Wed, 11 Mar 2026 13:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA426B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:34:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D762C17EE
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:34:51 +0000 (UTC)
X-FDA: 84534482382.08.673C31A
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id 42BC440003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:34:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iGKX2ERR;
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773250489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEN6rA6I2hE/dmJ6WhA4UF/cwwzcqi8Y+lZoV8+a3GQ=;
	b=Hh8ZrGLvzgnJh1eg5H64skk+w6lOPgqvbNVGw2UGwQxkyet1GM8/C78yF+rAYT3E330ivO
	ML+uHttGvVknAaDOnb9iwrXAusOVb0J87HZpi0tCCnaB1fJ9zoo5j+XEolqg0zuT1gliU8
	/e36hMviZXNNt2OxLobkzG/F+jGJMSY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iGKX2ERR;
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773250489; a=rsa-sha256;
	cv=none;
	b=lBiOF1bRnWrKusoYuE45KSQxV6anbRj+BUZXGkUGlSpH8BC48X+JzqG30lfJt+vxFxfAUf
	kgXyjII8GixQMjV87YqcGHBQDRHsFDPTZ/ytzxpd2VO2i3rah370r2I7UL+PQdekr7S3EC
	lWKtTlCkujOvsSGxeaQeQt1EJ0ofsT4=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-38a45bc61e9so1725001fa.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773250487; x=1773855287; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bEN6rA6I2hE/dmJ6WhA4UF/cwwzcqi8Y+lZoV8+a3GQ=;
        b=iGKX2ERRYKfXHPTNMYvt3FwKWmAJWcLBlCsYF/5x8lq0/SwgPz5+vRPXmhgVMDCYxR
         qX+Dgs/JV0xKmZ82Jk0dfv/fMphsD+evud72RWjjN6eJEVXvM1jQHHfwNy1SN9lTGuft
         pVIADkZsnEPvHYLFV6sFtHDid1KxlzXbCV00ZtCxtfYzvi5bVVUgng9w8erQuczA2/8p
         TDmucy/1q/3COr7JprOcR4bD89LNdDfjQtZfKglNLvU5Qumb3lklbJgGZ4pM3wLLn+PE
         LkFlLeQXjphCOrvix2/mAgn12iEUg3Ka37tLbKYNLpQWypFrsMfc7CLO+c8T1EmqAGUt
         unIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773250487; x=1773855287;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bEN6rA6I2hE/dmJ6WhA4UF/cwwzcqi8Y+lZoV8+a3GQ=;
        b=RjK+0mBoGXefs5GYjPufs+k2Ve6HlFgeZYN5yorLj1Uop0lW6WGISnJ2rdEV44A5ZI
         Qpx8XRQQInfsg/ByT5T7JUkbRQuZ1BSWsLvE87XgueGj4mZO5UGaiboODTpxYQ9SdwBV
         0zBbzPPywYmWdP7bOfzp+63pzDmlwsT4oWiZfBCt+lBJJ4aOf8LLmnChoAnt96ptZnok
         2Ds7LN/xKAaRECfvqGHtAJtJt89gkPqKol+UspV1gErcHjgjEeqzdJgNW+9OnoUdKVmo
         VnkfGzNDKwVZYX2cPN09ETbeyqdw//nxTPTkROzGS0zrXLQBiJt4GcrHLy8GTb0H4hug
         mbFg==
X-Forwarded-Encrypted: i=1; AJvYcCWY9gAsjlrEMoUnBqhiUKElUP8Anvjr7/RkdXsqB0p3gsN5+lLrtWe8EwJCWo7LaM/a2A4cATR/Dw==@kvack.org
X-Gm-Message-State: AOJu0YzGq7j5DxLCe4O/XBsJRGYY5klRT/0Qkab3lrOaTWaLFlV8z87V
	qHoq7R0hBdS0/auiqsAgPVVNt4qrVOqG23i7p6LG3M0WlJurfzXSnA6T
X-Gm-Gg: ATEYQzzArwUlAeAlhvZdIJZiDvGwYYxj578KsB82cg/BheALLmhmEQVudk4j1Aj6zw8
	ilpU04AvQp/iBdlYbQ6/VJsh0VFQIpLO/uE+u3sjc9nOpXcbJe3y9ACOVxOg+e7uYw5CJN+6KHO
	gXlRlfXEGaMdQp3YTv+6JR8kau2FPyom0NPuPw3F+PH/S6/R1dfNqxqZddbfS+KBEhmSe7529sT
	3iC5FRWqLxYo8Bfor9wvZ0HwulIFy5ofRTWOUY7ndc3gPqs8zLlXSB3ia0jWZqG+CeDP+VwoYu8
	jyod6AEM4JQkDLCigL4qTROYqoxY5vzly1C4Dg5UOopPJQyXQwryiATeEFPZcrCpFxx2RySHNay
	9e8fO3mhnv/IgCJiGiz7o0EKZeXo6o5yQYOGwexwGbC9RkB0N9fs4UkgI0iPKJ4+X
X-Received: by 2002:a05:651c:985:b0:37c:d689:7e1c with SMTP id 38308e7fff4ca-38a67e1b7c5mr13078491fa.23.1773250487356;
        Wed, 11 Mar 2026 10:34:47 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38a67d5fab0sm4838941fa.8.2026.03.11.10.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 10:34:44 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 11 Mar 2026 18:34:41 +0100
To: shivamkalra98@zohomail.in
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v3 1/2] mm/vmalloc: extract vmalloc_free_pages() helper
 from vfree()
Message-ID: <abGnsSAqxJWqSlXy@milan>
References: <20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in>
 <20260309-vmalloc-shrink-v3-1-5590fd8de2eb@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309-vmalloc-shrink-v3-1-5590fd8de2eb@zohomail.in>
X-Stat-Signature: 7mxsuiznogn86f9goyr7witpyaubc7sc
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 42BC440003
X-HE-Tag: 1773250488-217447
X-HE-Meta: U2FsdGVkX19fAi9apor4v7BQNvLN1lyx6cl92C31fqRimfiMULMMK7JCraHDNi5WemEgdP+rgxF+5fKCFhRkLGDEQJlxNjkJC5/ofMm1ONAJAWULKwCYoA/T/e8JYI/BBGg6fA+3uBLkcRh85W6PLX1WOoilDBTTQaZTbsLu7mqaKJBnQ+a6WlmaQhj8uTORW7n3GunLX+nvh88QwMIYEQ1jcJFIfT75chkVTg0hdRQUwPzYT5Gmw2m3ZSw4EGybjVZXmRdFuZZtJyePAT7iS7/y6tOrXzMveds88+3y5kdQVR882BQ8TdDgUO8wTdLmPwu/5WV2a8YIK5SjcUa6PTLbHJjd7zOqmhdRqwDvP6MiH5+hUr4XalciFj62eecT2e2ZoGFKopc5YRUcQ9SakpUadUcEnBiUxI24mmgg6+9wVFM+piDHwT1v/BhFMO6ttRkWp9SfGRIU00RPGwJmZujeXaCimU14wwzfjkyjfYTLo2tmoU1kg1+F/BUAeNJ/Xo8fwUu8HpPnRpj3DtT0njXqDdJAIPulFajOPx1NeFlpNqE1zYKgS5sIsPuiFG1NxXvt+Ofmxqy9Md5vK5ym0FittGzyijdAT9kkBwsaCeEanQDg5JkSCMIBBIWogwE2T42RZBbPuei0OjuNRagCvrX/oJzK1mTxmgq2SyYqnlTVo6JoXPnTwmNA5pnWo878Fi9+X459Wvl1aPNL24GE50d50QV7nLUe7f0/vQWNrg4TfOP53GM4aEqIEFPEZVqYpegoJJfeqzfLnaPjPWMK80pK5m/ZyifbMNPXFOGgVP9h+EhCcEbkO0mlJaRbecHS62jSmFNGCPaoqcGC9wmWQS4sWIhlj8vdgQaocHpB9LgWcRsl8JEUZkkQiCzrEt1zRXH4YO85nOSrjPTlLL+x0NCe8jgiVpIy27sssEZWFhPP7RKg8Gpma+pDWd7ugpEsuRo3pzLq6117dR0Se0P
 nGOo/DJ1
 vc651OBJ6bC+lYf+hJlkXK57h81QPWKGejGa3cGwHEslcLzjCQ6YmI9LNIEOawSgY+xeVOF5yhZyq74TDjmlvPWgTTjXuMW93JkpMXmNvUOjZ8oi2V1BHVmtsncODDYPVgJPJBqBevDloW2vTH6U+Jjrzs5g8nsjaf0TuUeg+QAmrANVw/Pt3lrZv4CohhtVSLr4l9uUKBx+sMrGk9sO1h5PUZa9W6d8Ywa9vqZdL2S39wHgnE7tNGfzI7V3JQE79tRJmRCZClhnJTRQ+wTEQaocq+VESXEGlJ96Tac9qboyrurtrTDSKBV1DZ8o0AsuBba2RAyieFnTektplkjVWQyd+kmz13LVqfxyfAq8PN2S3abU3HapA4daC69JFY9OODruxk9619FLeWiqVhI9HZxtNQppyAyPszdEKVC0FFYrGqR8iBIiF36jwK12Po9zVAcM5WkTpFYhvtqNNsg/ClAdgbSiGS2UEEZacuxIX6Orzf15vzDEERkNf44jjoAPxJVlty3IxoEa4e6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 05:25:45PM +0530, Shivam Kalra via B4 Relay wrote:
> From: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> Extract the page-freeing loop and NR_VMALLOC stat accounting from
> vfree() into a reusable vmalloc_free_pages() helper. The helper operates
> on a range [start, end) of pages from a vm_struct, making it suitable
> for both full free (vfree) and partial free (upcoming vrealloc shrink).
> 
> No functional change.
> 
> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> ---
>  mm/vmalloc.c | 46 ++++++++++++++++++++++++++++++++--------------
>  1 file changed, 32 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c607307c657a..42ae68450a90 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3416,6 +3416,36 @@ void vfree_atomic(const void *addr)
>  		schedule_work(&p->wq);
>  }
>  
> +/*
> + * vmalloc_free_pages - free a range of pages from a vmalloc allocation
> + * @vm: the vm_struct containing the pages
> + * @start: first page index to free (inclusive)
> + * @end: last page index to free (exclusive)
> + *
> + * Free pages [start, end) updating NR_VMALLOC stat accounting.
> + * Caller is responsible for unmapping (vunmap_range) and KASAN
> + * poisoning before calling this.
> + */
> +static void vmalloc_free_pages(struct vm_struct *vm, unsigned int start,
> +			       unsigned int end)
> +{
> +	unsigned int i;
> +
> +	for (i = start; i < end; i++) {
> +		struct page *page = vm->pages[i];
> +
> +		BUG_ON(!page);
> +		/*
> +		 * High-order allocs for huge vmallocs are split, so
> +		 * can be freed as an array of order-0 allocations
> +		 */
> +		if (!(vm->flags & VM_MAP_PUT_PAGES))
> +			mod_lruvec_page_state(page, NR_VMALLOC, -1);
> +		__free_page(page);
> +		cond_resched();
> +	}
> +}
> +
>  /**
>   * vfree - Release memory allocated by vmalloc()
>   * @addr:  Memory base address
> @@ -3436,7 +3466,6 @@ void vfree_atomic(const void *addr)
>  void vfree(const void *addr)
>  {
>  	struct vm_struct *vm;
> -	int i;
>  
>  	if (unlikely(in_interrupt())) {
>  		vfree_atomic(addr);
> @@ -3459,19 +3488,8 @@ void vfree(const void *addr)
>  
>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>  		vm_reset_perms(vm);
> -	for (i = 0; i < vm->nr_pages; i++) {
> -		struct page *page = vm->pages[i];
> -
> -		BUG_ON(!page);
> -		/*
> -		 * High-order allocs for huge vmallocs are split, so
> -		 * can be freed as an array of order-0 allocations
> -		 */
> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
> -			mod_lruvec_page_state(page, NR_VMALLOC, -1);
> -		__free_page(page);
> -		cond_resched();
> -	}
> +	if (vm->nr_pages)
> +		vmalloc_free_pages(vm, 0, vm->nr_pages);
>  	kvfree(vm->pages);
>  	kfree(vm);
>  }
> 
> -- 
> 2.43.0
> 
> 
I posted my comment for the v2. Same here:

probably we should move "if (vm->nr_pages)" condition inside the
vmalloc_free_pages().

I think, the function name should also be renamed to something like
vm_area_free_pages() so we align with vm_area_alloc_pages() helper.

--
Uladzislau Rezki

