Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E390EC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 10:36:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3CFD6B008C; Fri, 25 Sep 2026 06:36:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEDF06B0092; Fri, 25 Sep 2026 06:36:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADCED6B0093; Fri, 25 Sep 2026 06:36:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7226A6B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:36:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5AB1A060E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:36:51 +0000 (UTC)
X-FDA: 85251931422.17.8C528B9
Received: from mail-ej2-f23.google.com (mail-ej2-f23.google.com [74.125.228.151])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1EBFCA0006
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:36:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WFt9KfRm;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.151 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790332610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhWuBlVR+9Exee5MQnVdQb500Y1OJ3oFiUVTaPUsfcQ=;
	b=Z7SQ3GJX5yZIraUTyWCvMTBPzTvlLURG69y2DnFzsYuDeOWcAj1HtLlu0snbohvDOmXz+J
	oML2myvh3/EpfyCn7s+1+M4m6dFSPI2GTHXMfy880HrVvw3MKPL/2c+8AGkUqQn5Kwtmb2
	lAJ1flEUxnb+OdAynpwHW73AJ9VKcjM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WFt9KfRm;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.151 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790332610;
	b=Yg7y3t3DMnBdRO9rs3ZLmkRh3EKJsnI64gZa3HNdyFFOKzX0JhNNaJBIRS2Q+jhMipJCvu
	dtTqpIF1IS6j/rhIJ9jB1uaxYBhCMYXLVpzZ7xYJwiqBT1sILgFMqoPLcGjmfq45tl7jNI
	VadTx+aVKz6nif9jGlux7ZSXQ8OfXsw=
Received: by mail-ej2-f23.google.com with SMTP id a640c23a62f3a-c25ef7a3ce9so84916366b.3
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790332609; x=1790937409; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FhWuBlVR+9Exee5MQnVdQb500Y1OJ3oFiUVTaPUsfcQ=;
        b=WFt9KfRmse5TS9CtqmK43LNKY6nly6E2yA/7YiiU8FNKEtVSaYE4gjtmXdsJHB2/mE
         d7IqoyEPglNXgi1JXT4tR7gKUHNOsTztDJfhO72fCV2tl8gaUg0TMiKwHuj9VoZFudNn
         vM2F7Q30qtwr2akVRMMakUocJN00gtRqnyORDAjePvBZUJZ52h9AL25rzJqQ6chUm9Z2
         8PjS9hLns71WUaO7zYQLXf6PBKaSpubaGPNnWZP01FQnttGBebv0e2kGB3OFaLMaBl1A
         V7Z+fCVSHyB0dMJ54myTi5yvguJ8LbUf9F4BUBrJpCGfhPsbboQSQiBCkokEyIZ1zGXZ
         DyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790332609; x=1790937409;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FhWuBlVR+9Exee5MQnVdQb500Y1OJ3oFiUVTaPUsfcQ=;
        b=R5MEhUzJUsyxKZW4lP7Llme0wr92ca05lOFhPZDCuS6h9GryH3mVuJU8oQtth2rNd/
         Bp+NktWik76VH8gNHgOaQ8NIFiZXddiWz51D8gpPGXGaEu0wD5KFuxn7bvDN03SMhLWt
         Y6UR3JcBiSTHU3L2L3PcFbcIeA+Dg2xVQOGGBuUfc+mDdQn5tJ5b3FHXOvkMY0+e/E9j
         lu3oW5+jrV+PzKXv2pYdH5HtUQVsIhxESg9ATUkSOY64jhWvWbh55oe3Rdg1zxc5WHZA
         BYdfjBu/vMrZRmJRpQ4Vt2MPWhDDzdTOqJCSerRa+8ooyrzJyDHh8hUCuLHhHAtQw1gg
         Jxkw==
X-Forwarded-Encrypted: i=1; AKwUvBxJxYcjvgRgXFw78zwA0aHEDrn/li+903K1u78oMQdOSrPAZlDL7sr9d5RbOnk/evkB2v/TgIc4Hw==@kvack.org
X-Gm-Message-State: AFuF++kH69Izgqv+AARFZceVbUbh/dPyPDgVxeMOh6P+sLmp7das3msN
	Wwm297LVY7wDpvbfW3fLxKkgUgL4qO9nIx8hTwWzp2+NWT63kOJW0cQD
X-Gm-Gg: AYBFou2sJELaA6LNymT8qUpdktJAcTCcfBeteW08QiuEOGTDxILZUZ2tznBEDpiC2UA
	LPEoQXWAoYOPAKzibqFPcVfHtqT1E0fL+uv70EqOO8qlmGr12vw22BARvoX4dkyo1QIkOkOvO+K
	XcaLn99DgeRi5QneSbp0OyA+r8cxDhcvxSTBusyeKeKwVvTgPQah1PvnHgOmg+XiE7c0bKehekl
	nf2f0UaUyc6k9sojmcyBMT5cF5BxKJYJWPNMGfG3E1JehZ8hAsAAWWFkMZ3S5A7fActSjQLSRUF
	1YHGC5Pe8KJHh6G5icAjOGht1r3wrhHHGsTDFZntVP3CeezB5Ozf8962SC77C8oTUtVKWZP7uvY
	qVHfaP+cnBFUg8gnF8nQtyK01dG6egUJtb+tSKkxExYhOi7Y7+v38Ex3MKZyxL2YsnXKgSF4QZU
	GK7M68VQX1vEBOlYzvwD7vMTP/KvI/EEcdRhU=
X-Received: by 2002:a17:906:7947:b0:c26:1649:47ad with SMTP id a640c23a62f3a-c2ac53c3f15mr404029566b.35.1790332608444;
        Fri, 25 Sep 2026 03:36:48 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2ae77fd743sm95444766b.47.2026.09.25.03.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 03:36:48 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 25 Sep 2026 12:36:45 +0200
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH v3 2/2] mm/vmalloc: fix vmalloc_dump_obj cross-zone VA
 lookup
Message-ID: <arZOvQzkacy826wJ@milan>
References: <20260924-vmalloc_dump_obj-v3-0-5bdee3da37b3@linux.dev>
 <20260924-vmalloc_dump_obj-v3-2-5bdee3da37b3@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924-vmalloc_dump_obj-v3-2-5bdee3da37b3@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1EBFCA0006
X-Stat-Signature: acd79wfh3mxrquip1eikbk93bed6ticc
X-Rspam-User: 
X-HE-Tag: 1790332609-763210
X-HE-Meta: U2FsdGVkX1/LubPtIVXeMXviuw1MSRtO6mAsEkjNW0dybSOJs580LYzdwfpjdU0IgK4WXnY19hJR6Z3L0yj7Ni0+MIsxNQr9gUAjyYJUOsI1DxCor4Y6Bh2+1T5vJ340cafny5IYz5KiPwqB81+5XaWzdaHStgEH9yYc2aSv9Wg0acxpUTlE8k32lSYCN9XlauM+VvTMZhnY5rzdcwFWJLJG+kncTYPoa6tdqy3Nz3O4AZ2M94huLI1MX57qHRIWrDFQDFDTCQv90OKRvOjzglryFn9JPjvaGoG843bkF4IEyab/mp+B6QDEgF4j5BCNMyxdIpbOBl37fX8tc8bg/G5fdI23iGEe1iLAA7CW7ygFkABmGNOJZ+avg7Hqp6ECdpwNMFe+3vY9kkeEjZTbGM7fJvuHJGKlz4TYijjokT6VMq1NYUzfjuAnuuoDW4jF+oPMIav6K4eFaqR9VKuDOuW9Jy9N23XYCes1BnfcY/4EvZalSvAfQlFBAjA6B0AYB15/hFjRpA2jDjUz+peTVLbn7rQPdhlrTn2UkA/VSA8Q3KNG0pT1Pb07Kdyga/G/NRsF+ixaNDz5hiPWa9CsyfiYtUe3SNe4KpzSjVhwak6bU4htaStBtlWx5w6TAmVwsoG4u0hQ7G9u12FNETGqGrVAH29GCP0PLD09GfR5kBFF6JopsGRP5lu1IzPH8VZZtW3+s0QoexxJzQpmXfS7Px9M8ZX1HxFfYPuNXI1jaD0hWnjG1qzv9FGc8X+U48efon83wYoQcE7HPOpfMrjGN1HO6FmOGLJBGTYyTV2++uNKWW93wqdDeNSF2IWvsIGjiO+dMTUgIua2s8gDZSeItaDa79+k8HUL+IW5EhWJgzcsL4kPFlH0s+PqsGf/jPcW8kfbgEQ5CFQyRacZRIivqND49Vb5vMhWHnFvDo2UGHXU1X5FsZIOst8bbl4yxdsGFQc1AhuMUESZ8WR0zm2
 F+zaRiZf
 qVRWeD++NZYhZ44xVftv0BV9ifZcrJ7IPFMLO0Ir+MtFn9H8Wv4o6ILmqUrV+tUJqQyvkP50fQD8cOPX9XGRRyLEwXUVB+fGaYTtbPXHUYRoFmfoAVd8VFHSEVZZpdQZcst0DeobqWJHSVLmnDh2JP5c1exLFNctS/6v/jjGUiDHl1dQqlToP9TNBOqtZAZaqHjoTswjau3B570JKnJp59cm++KBq/uJxLzevP59DP/dl6IerAd6uNiP8I6qYVM+KIpkEMd+xplTKZH5VhT/W1XEr7l/7WtzjxBrKqInrfIOzhWKNlUcXCC1iuJLPmTushUzjDxcyKClZABrPEzXlRnSZ9ndnccLZeYYFAK5JumQPK2zKH/9tcu18WggNDVRNs45LjTLYVYRXwc+1yI9HeSaoLBFiFnLXWb5U4ciwl5SqJXq/NXPyu0JZRdUg9r7CRRaBQPOZ8fN4CCwqVCTmGJwZay/fN74mizELQy/nSOBRliGQYxSG2YUwdtDDgoBNCeXdpRmVioQPm70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 04:51:40PM +0800, Ye Liu wrote:
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
>  mm/vmalloc.c | 111 +++++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 69 insertions(+), 42 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index df42d8a6f058..e5b465de1559 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2517,39 +2517,81 @@ static void free_unmap_vmap_area(struct vmap_area *va)
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
> -	if (unlikely(!vmap_initialized))
> +	if (unlikely(!vmap_initialized)) {
> +		*locked_vn = NULL;
>
Just set it to NULL once on entry?

>  		return NULL;
> +	}
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
> +		if (mode == VMAP_LOCK) {
> +			spin_lock(&vn->busy.lock);
> +		} else {
> +			if (!spin_trylock(&vn->busy.lock))
> +				continue;
> +		}
> +
>  		va = __find_vmap_area(addr, &vn->busy.root);
> +		if (va) {
> +			*locked_vn = vn;
> +			return va;
> +		}
> +
>  		spin_unlock(&vn->busy.lock);
> +	} while ((i = next_vmap_node_id(i)) != j);
>  
> -		if (va)
> -			return va;
> -	} while ((i = (i + nr_vmap_nodes - 1) % nr_vmap_nodes) != j);
> +	*locked_vn = NULL;
> +	return NULL;
> +}
> +
> +struct vmap_area *find_vmap_area(unsigned long addr)
> +{
> +	struct vmap_node *vn;
> +	struct vmap_area *va;
> +
> +	va = find_vmap_area_lock(addr, &vn, VMAP_LOCK);
> +	if (va) {
> +		spin_unlock(&vn->busy.lock);
> +		return va;
> +	}
>
Can we simplify like?
...
	va = find_vmap_area_lock(addr, &vn, VMAP_LOCK);
	if (va)
		spin_unlock(&vn->busy.lock);

	return va;
...

Thanks!

--
Uladzislau Rezki

