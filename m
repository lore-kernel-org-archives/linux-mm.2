Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70482C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733BD6B00A6; Mon, 28 Sep 2026 05:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4226B00A7; Mon, 28 Sep 2026 05:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D42F6B00A9; Mon, 28 Sep 2026 05:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 333456B00A6
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:06:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A90A3A0154
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:06:11 +0000 (UTC)
X-FDA: 85262589342.02.BEC35E4
Received: from mail-ej2-f41.google.com (mail-ej2-f41.google.com [74.125.228.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id C594F160009
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:06:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EBLPgoDC;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.169 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790586369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtSlOLaW3Y5DkxUyXc5MQJfomo4EWRSttsNoIPMu1rQ=;
	b=rRgxD+mtR/hEERuG76qC3/WHg8oNiTJOZwzrZerZy0+lOaCMYzz9zBup72PwPTUcuVHbn/
	lWxHYn7cOYWXGTWwKYNhDZjGAacXBX9OMhCph7xcTuL6y0+uWBmO+k6yp+sZjxFV9nbWqN
	mn7iYBeN4X3PUeVxD0aSc2bdWqsMGwU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790586369;
	b=nYJTbs+p9AWl8JB6Z2EMQPWHdvCDo6RFleN2Calo/Jq872Z72qOlx430mBZutqyMz29mCs
	gZCDkI7bai9R/kXJhyNGPqsEapkr6fThEL+vs43SEP4OYcZBufdtlEUTk5KhcBhLXWFD5d
	FcH4vFsJOIMKNTs3eSnZAh3fxOpkhWc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EBLPgoDC;
	spf=pass (imf08.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.169 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2dca989afcso146754666b.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790586368; x=1791191168; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XtSlOLaW3Y5DkxUyXc5MQJfomo4EWRSttsNoIPMu1rQ=;
        b=EBLPgoDCq87EIj24H1ZL1UqfrCQ2Pmtj45D1hL8AM009QdiwRTqtGzQCD5NLEsM+GG
         qCxaRuPnF35uU5AGZOTREajuDu+VB8ol70sphuxbMymCUpg593XZIfzBv4N7JUjl05TG
         aYUcDJgD4mpM1zQ96AzhnJkFm+5hzRFlIe/rbjMA0xuTu03LyaTAORav7EtmRaSc1VVe
         dvefSHW9uNhRewgtrLg3ygk727e0SkJnNuMG+OsqS4HbHjSmRjzzCFjxjOZAS7dZuXFw
         YNjq+3x62fthwClL88O5K/UmigvR3Hr+7I2DHHauo+6YqTqBLGhW0Y857mWXM3OM0XFv
         yueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790586368; x=1791191168;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XtSlOLaW3Y5DkxUyXc5MQJfomo4EWRSttsNoIPMu1rQ=;
        b=xDFo6J22W6Ivfw1Q1gALd/z7R06dkmKoGhIw1FuAT1PwmdCvgXUVFDgVdVGR1P7bxM
         NqnmttNxDd6xAvv9zKbu9NuBqcoc3YCpSRqQQuez7lIDLh03TzbqzJUrWRjKkh/XZMhL
         zJiDvetf2GpgSVJd7cNH1lOYeR7fq1ktU0fWEtX+feMp0H0uceweU2xVUaunJGlr0wU1
         +fr3J5z7itJBQYE+h7qfE4ssfkoUMob0ojJcYzhbKSepVOeVtfyayvmvZaSeAdd50pm8
         iX5r8qYm0J9CP2/rcJjVdQAYlTMz8TUxBlNldgObAbS4JZbkx6XTykSDUWTU34ypaFSJ
         ftng==
X-Forwarded-Encrypted: i=1; AKwUvBy2DmaL1NyQfxuk1I36bC8GSFJKwOVJV6R9N646jICV5/lchUgpplibxYEwGjBO1vlNEdAzXQSuYg==@kvack.org
X-Gm-Message-State: AFuF++ldzmbD0fLw+BFEK3VuhG+3kqxU4FpgUcw3daJljm+ILf4mZ+Jm
	gk/K7kdY16znmPNwKWFRuMnHc2Of+C+52gzYK4ofdnL9uJQY1sDWHRIt
X-Gm-Gg: AYBFou1q24UeOIewHWwVU8ImtmaaOhDW9eHIhV8YGBqU44VqFmrgeR7yqwMH83PZx/w
	LJ6qf4x/GxolLIERd7KrCukink2A/s1G3yvdVp0QVgD2aOXW/mO4h5SJPAVsnGcOEwmU2Pdzra6
	YRsJW2Li2w6jpWgrenYY4IZDIvijMQqpCxPo71AV9EGdT8s0Gm96MhtAZ/eKOJ1iIyBxGpBzn7y
	7jLlpVJ32oN+IeKMZ6fLGJjfgMU/TsdIiadJ1mSi4KR82aSUh8jSct+/k94UKPzHX7u28oYLr44
	Qe/6wd5WeQNYX1ZDnBx8odhANYMaw+bmVwPOQrwPOfltVQMNPvDQvrl8wcgIGaE0kWvnk45Unsy
	10/KYpTAAB++LCI5UNJHLPAr6yclBunnEKl9fevbeiz5q/STXRs80dUxn9pWfvrJSm9JgMj885m
	we1x5rCQW2NXaPVWpKrzBg96xJeQhh8mp68+g=
X-Received: by 2002:a17:907:9447:b0:c26:2eee:ffc7 with SMTP id a640c23a62f3a-c2ac250ec3emr1002093866b.35.1790586367856;
        Mon, 28 Sep 2026 02:06:07 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2ae7356d1csm441929866b.18.2026.09.28.02.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 02:06:07 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 28 Sep 2026 11:06:04 +0200
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH v4 2/2] mm/vmalloc: fix vmalloc_dump_obj cross-zone VA
 lookup
Message-ID: <arot_MLB2tWwR7ue@milan>
References: <20260928-vmalloc_dump_obj-v4-0-6f288a431edc@linux.dev>
 <20260928-vmalloc_dump_obj-v4-2-6f288a431edc@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928-vmalloc_dump_obj-v4-2-6f288a431edc@linux.dev>
X-Rspam-User: 
X-Stat-Signature: xgrjxmxe3ua3chknknfkac44yfi84jw9
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C594F160009
X-HE-Tag: 1790586369-315277
X-HE-Meta: U2FsdGVkX1+OhX9/Q9GkhebKrzhbM3cOHiL9mT2h6QTV6ywbMYZVIW7lkBr43fx/quwLX82Wib1+5pn82hnUxRezql+nZugCjsMNpmqg66U7gOo7kvd+MWPUUYL9Nc90t+wN9qlldxeVyZAbevafeu3pBhqD6lmX0qYkrg8l4+GqcXihQBhLPkFCosNG246xMWmSN3QIHsb3EqLBHwn4O6Yjeo6igCFuIJ61i8o92OiUN/lk+N1FCYka7XxMXzAiQ1I2PIVgJtmoFYK0VSgrs0A6uj+I0Zk7A5ArlaqJ79G71B8By8zJJ6qUJ9TEnFRm7EDw1+N2uCA6IVlpz9ZsUbN+7Ie/tI8x5pzxonbQ5j9d/QBxe3UuPrTxyUYujKmdkMh6tnzaJ3RRDNKaAH6G/YeqrHS/5PptP5yXaRNzSg3iNDNNaPTk0rwVAp7cypnwJPmkbjchDN8lMDo56WT1LXSnm4U+mwH/iyB72r6gfSoltirpE1RoWV/ycQkMF3Zk5wicoeonJ4qRLNyoK+yKfUceeeeyZFItibPXr/uORQuQrazNzUE91WU7XfenVCIfuAv4J0P+KvEfw88E4s12qPEku/BPLC02mdVUkgimRhWlQcCat4Y08ISrC5v/OwnHFXxJFEfPuQ7n+EbL0MjxY1XvA/D7ob8mPLf5vDcer6NNrPx16/OFGViO96TwBNnuOMAhhM8RRWrm5Tg8AePFphAOIMMPNIkFbvwsQLLb2fQtrgw6+KxUOXvGgjlCoCQ+OCTElpnEtv2bK8DK8GhZrvq+nLOnlqRt6BxtbZ0i+HGHH9xqvbPevXi8zQfdCGIbgC5ouobepJn+RiMFjNHi9CYcaJ7QelYQ9Wzc13+ioaw7oILXYfKUeM8u0Pn+CPk4T700XwEEJKhFPhlROwEoe5kQ7U5y2FbKk74ILyHjFcGupl5rAJYsuW27mA2Fb97IVwltlSmgC1rk7Nk1Zye
 Dtro6F0q
 hTJWh+dQjrH51lKejesw4WlU4u2aXwM27PHhe3hlArwa4xsBPmnRowH9MXuFyRXaiyLCnfKMAH4AqrSws5VcOuh7IvxBKsUnudoFXodqNosmAZQ3i0Bcn+uh/cwz9Is8lmACMyB2KPQy577FONldfqRj+HOXWWJuEiUx2+Zi/UP2JpUa2fnnfH8xWVTzL1OAmHpirmSalWTqeT1SDeoKNcaAkaTkGHO1T8tL4+kbutvsq3muW5JDT6ZgJsFp/3AKeZi+tt2usv1f67tHHW4G/HfuCKhe/C4lYLFrBa2AFY4W2fYaOlPod+r5xxe89x7jbEzFV0NV7WXvFFPOmVlfxfbTgJsELoE4cC7Rb0BXQosG38FjYUm8hiNBKAbGksokImr5rHyPlbi0RZTX8quJYz1qk56bzrHEMaMJ5nhEsXgKOtIx/6FuwPbNJHDf4VofZx+N6cyhtNMzk2pcvbi2X7+DBFKbM59RfisCw+ShFi04b77HAw8SUMrZbz+qc4kDzwDqI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 04:15:55PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> vmalloc_dump_obj() searches only one vmap node (addr_to_node(addr)),
> but a vmalloc allocation may span multiple vmap zones.  The VA is
> stored in only one node's rb-tree (addr_to_node(va_start)), so an
> object pointer in a different zone than va_start maps to a different
> node and the search misses.  This affects any allocation larger than
> vmap_zone_size (64 KiB) on multi-CPU systems.
> 
> Extract find_vmap_area_lock() from find_vmap_area() to share the
> cross-node iteration logic.  The helper supports both spin_lock and
> spin_trylock, the latter for atomic dump contexts (OOM, KASAN, RCU).
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 108 ++++++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 66 insertions(+), 42 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index df42d8a6f058..4f4d7453962f 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2517,67 +2517,94 @@ static void free_unmap_vmap_area(struct vmap_area *va)
>  	free_vmap_area_noflush(va);
>  }
>  
> -struct vmap_area *find_vmap_area(unsigned long addr)
> +static inline int next_vmap_node_id(int i)
> +{
> +	return (i + nr_vmap_nodes - 1) % nr_vmap_nodes;
> +}
> +
> +enum vmap_lock_mode {
> +	VMAP_LOCK,
> +	VMAP_TRYLOCK,
> +};
> +
> +/*
> + * Search for a vmap_area at @addr across all vmap nodes.  An
> + * addr_to_node_id(addr) converts an address to a node index where
> + * a VA is located. If VA spans several zones and passed addr is not
> + * the same as va->va_start, what is not common, we may need to scan
> + * extra nodes. See an example:
> + *
> + *      <----va---->
> + * -|-----|-----|-----|-----|-
> + *     1     2     0     1
> + *
> + * VA resides in node 1 whereas it spans 1, 2 an 0. If passed addr
> + * is within 2 or 0 nodes we should do extra work.
> + *
> + * Returns the VA with @locked_vn->busy.lock held; the caller must
> + * release it. If @mode is VMAP_TRYLOCK, nodes that cannot be locked
> + * are skipped.
> + */
> +static struct vmap_area *
> +find_vmap_area_lock(unsigned long addr, struct vmap_node **locked_vn,
> +		enum vmap_lock_mode mode)
>  {
>  	struct vmap_node *vn;
>  	struct vmap_area *va;
>  	int i, j;
>  
> +	*locked_vn = NULL;
> +
>  	if (unlikely(!vmap_initialized))
>  		return NULL;
>  
> -	/*
> -	 * An addr_to_node_id(addr) converts an address to a node index
> -	 * where a VA is located. If VA spans several zones and passed
> -	 * addr is not the same as va->va_start, what is not common, we
> -	 * may need to scan extra nodes. See an example:
> -	 *
> -	 *      <----va---->
> -	 * -|-----|-----|-----|-----|-
> -	 *     1     2     0     1
> -	 *
> -	 * VA resides in node 1 whereas it spans 1, 2 an 0. If passed
> -	 * addr is within 2 or 0 nodes we should do extra work.
> -	 */
>  	i = j = addr_to_node_id(addr);
>  	do {
>  		vn = &vmap_nodes[i];
>  
> -		spin_lock(&vn->busy.lock);
> -		va = __find_vmap_area(addr, &vn->busy.root);
> -		spin_unlock(&vn->busy.lock);
> +		if (mode == VMAP_LOCK) {
> +			spin_lock(&vn->busy.lock);
> +		} else {
> +			if (!spin_trylock(&vn->busy.lock))
> +				continue;
> +		}
>  
> -		if (va)
> +		va = __find_vmap_area(addr, &vn->busy.root);
> +		if (va) {
> +			*locked_vn = vn;
>  			return va;
> -	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
> +		}
> +
> +		spin_unlock(&vn->busy.lock);
> +	} while ((i = next_vmap_node_id(i)) != j);
>  
>  	return NULL;
>  }
>  
> -static struct vmap_area *find_unlink_vmap_area(unsigned long addr)
> +struct vmap_area *find_vmap_area(unsigned long addr)
>  {
>  	struct vmap_node *vn;
>  	struct vmap_area *va;
> -	int i, j;
> -
> -	/*
> -	 * Check the comment in the find_vmap_area() about the loop.
> -	 */
> -	i = j = addr_to_node_id(addr);
> -	do {
> -		vn = &vmap_nodes[i];
>  
> -		spin_lock(&vn->busy.lock);
> -		va = __find_vmap_area(addr, &vn->busy.root);
> -		if (va)
> -			unlink_va(va, &vn->busy.root);
> +	va = find_vmap_area_lock(addr, &vn, VMAP_LOCK);
> +	if (va)
>  		spin_unlock(&vn->busy.lock);
>  
> -		if (va)
> -			return va;
> -	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
> +	return va;
> +}
>  
> -	return NULL;
> +static struct vmap_area *find_unlink_vmap_area(unsigned long addr)
> +{
> +	struct vmap_node *vn;
> +	struct vmap_area *va;
> +
> +	va = find_vmap_area_lock(addr, &vn, VMAP_LOCK);
> +	if (va) {
> +		unlink_va(va, &vn->busy.root);
> +		spin_unlock(&vn->busy.lock);
> +	}
> +
> +	return va;
>  }
>  
>  /*** Per cpu kva allocator ***/
> @@ -5278,14 +5305,11 @@ bool vmalloc_dump_obj(void *object)
>  	unsigned long nr_pages;
>  
>  	addr = PAGE_ALIGN_DOWN((unsigned long) object);
> -	vn = addr_to_node(addr);
> -
> -	if (!spin_trylock(&vn->busy.lock))
> -		return false;
>  
> -	va = __find_vmap_area(addr, &vn->busy.root);
> +	va = find_vmap_area_lock(addr, &vn, VMAP_TRYLOCK);
>  	if (!va || !va->vm) {
> -		spin_unlock(&vn->busy.lock);
> +		if (va)
> +			spin_unlock(&vn->busy.lock);
>  		return false;
>  	}
>  
> 
> -- 
> 2.25.1
> 
LGTM:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

