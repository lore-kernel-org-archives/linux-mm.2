Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B551CCF6BEA
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 05:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 221CA6B0092; Wed,  7 Jan 2026 00:22:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CF9C6B0093; Wed,  7 Jan 2026 00:22:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A7D86B0095; Wed,  7 Jan 2026 00:22:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC43D6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:22:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 936B0C019A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:22:46 +0000 (UTC)
X-FDA: 84304023132.06.9038991
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf24.hostedemail.com (Postfix) with ESMTP id B9D50180003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:22:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s0IydWmZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767763365; a=rsa-sha256;
	cv=none;
	b=ERHH3CNdar9gSLLWaivL3wTWA6VDMLyQa+i9BpEq5i8iJgqO+2xQf67RzOsX5Yr0mS7dKY
	ihTeD2jrbYzS5fkODA4P8prY+71eNxaD0/ghvQZr/kxBkQGtBcHoDJ3R6GBHWRfQ/h1TYk
	ETbMff3BuyA3amoIEpCBAXakRcfoWP4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s0IydWmZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767763365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P6u8X3QujaIS5qtca9umN08oKsh0jFfQJn/GWUgkYqI=;
	b=z+Yq/v8yGQmWPxG3hH89+VZXfTTePpsQ18sb5KyAtYgYYEcgDGSqEN7ILx7fd+b3PWMhkl
	pcFXokNRRajW6QlZKIL7N+b9xgWZWh0Ahg47v6P8O56fsyYK5vHKcrA19s+dqGsv3BeSi0
	P87pQRT7uqiEe/slmoCn7ImeZnWIJwU=
Date: Wed, 7 Jan 2026 05:22:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767763363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P6u8X3QujaIS5qtca9umN08oKsh0jFfQJn/GWUgkYqI=;
	b=s0IydWmZZ/8vRjfy771LelNrfPw/2rNbjPlc3oI+GKUJ1DcELZSaldXQ9HSkGPo69A/IhR
	+WOFFOCEjZqmWzCEWapaGsk8rqma6W2WZVfLvM9n/LwQfi0rORFuE3nT3hDImr2wSqlGga
	i2Pi7BbvTS/QgBnVVnHOtzcWtfSKsss=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zsmalloc: use actual object size to detect spans
Message-ID: <mumv2eouuqepj5btx4jeghevlleucdslt76erxtt4sm5ntavx5@oipdwrdhzlta>
References: <20260106042507.2579150-1-senozhatsky@chromium.org>
 <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
 <og2yztajena3ywyvus6xgc5vlrrecjaynyezygpsrt64kjkqlv@agceajv57eet>
 <vkhwvmazwys7dz7m67fil7xlhevdsc4xbvq3h6nknb7rqojjis@vx2c57ylvl44>
 <ofjlah554fgcc43e66djtysmnagd7gduqutueyauipovs35qb7@mw7keptebqau>
 <5smqbald5bollibqjsvqw2tfngdoiiucurikdgqtz6xjb7u7vz@7p6hskoixaak>
 <lupjar4x2wz25knuntywor5oyx3ksyhh7g7yv4apmztn47ayep@sncrwg4gjlut>
 <3xsreqvvclcuqyllgdz5avxwdvhc3rqri4565xj2hbwk6r6uol@6mnhvdgaxfrl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3xsreqvvclcuqyllgdz5avxwdvhc3rqri4565xj2hbwk6r6uol@6mnhvdgaxfrl>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: B9D50180003
X-Rspamd-Server: rspam10
X-Stat-Signature: w6sszg6woo8zeefg89hcdd48z8c63a7a
X-HE-Tag: 1767763364-149849
X-HE-Meta: U2FsdGVkX18lF+ZB9gCjDCDY5NM7ONTr6LrRy62qHDUfzFwNslPPAzjxMqTTjij1GZRPezzjt6661E21FUtyCqexKW2dfhmA3GyQEG/2nFB+iYw9JEbbkDrYsgJTnCQwrVzpxePSiDO9/aTQCjjhHjYdUvu7lmlVfYg5AuEkZfOqFCNOoEf+BGuaxIw/flmPv/kdY51PX59e5rR1aQnKSNd1wBFBujcTi8ePmVgg2zRAgkh71DqEFZX9L/AQvr3VLwA16EFLDybB3DD4A9bvJi+f6RmyqekVsb7z7ke03gi4hC4UoIHg6pY4T+nIkRmBmjaqSsmhW2ZOfmNhPPvt/mmZo8RqeKZiLB2yCQyekqfuFyFX4d2W9NCDBX4eeUjF3+EhirGmqAiLoDHQNJxWQPCEWGk+O2D1+AXZTF6fh/MBkCHzmW9YUqo8/eA4VDK7dcjptUnKceIM4GeV484EpJ5Ymz31i6G4V06iK4pEueal6sPYqGfEOJq/23dexeiukuznHRw0gLOWI2+acAzp232nAunRMY7OyDUan/qZriokMGdk4dFGXgwN11lUb6BvvKoeSUys7/ABXEG+kQMYz1xjkUQ1ZGsfPkQGQHJpO3XzEJF6Iy/4Plk/PeIGzPtCqc75M+Odrb8ZB/Jb/Th7G2xQrMi6RSc8LqZpNsYAufHwHlt7q1aWzfFxVln4O2b+3kjhYR3szO7EDoxQdFXvIjzAe/Xwfte1of+l5lxYTp7CzS3lY6W2JJbE3+JQu1HmOa5Kp7b+2qS5/a3vnjKbtExfpbOy0L8mkDBBZ6Z6gqTVOwDUtKOgUHC3oRCi7v6lNG9FxpGAbAbqAxZeIjoKoG9EeVhMDEmg05J/efbcl+FzT4EcEYe7oSspJHXeXPzm2JSdPzuM6nXAsKeQ3DShvz5/IGCkKwnqX0v1Jpqg15nTFmWZxMQE16F4Qyw1YgnKyjAkrs1E5y0rRt6OTYy
 gBGJASRk
 ofSUrSYduninWmNN0GVEfRe26/toc29XYcgvwDdz/+owg3sNbFzgff93nr0316YSdGriE7ttFCF4FGDxy1ESiYgKydI5fVg+tOEr2BIx/Fdbtzyh7EvEeP0QTrBqIh7i8Ve3we3OMHJd39ooVAcofiCUXqFe5NYFChy4u8njpm/bmF4+Wv+XR9TnUoTKfS1A+q40R7Bf+C6RMEbw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 12:03:37PM +0900, Sergey Senozhatsky wrote:
> On (26/01/07 02:10), Yosry Ahmed wrote:
> > I think the changes need to be shuffled around to avoid this, or just
> > have a combined patch, which would be less pretty.
> 
> Dunno.  Do we want to completely separate HugePage handling
> and make it a fast path?  Then it seems things begin to work.

HugePage should always be PAGE_SIZE, so never spans two pages, right?

I like separating the logic because it's cleaner, but I want us to
understand the problem first (see my other reply) instead of just
papering over it.

> 
> ---
> 
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index cb449acc8809..9b067853b6c2 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1077,6 +1077,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>         unsigned long obj, off;
>         unsigned int obj_idx;
>         struct size_class *class;
> +       size_t sizes[2];
>         void *addr;
>  
>         /* Guarantee we can get zspage from handle safely */
> @@ -1089,35 +1090,27 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>         zspage_read_lock(zspage);
>         read_unlock(&pool->lock);
>  
> +       /* Fast path for huge size class */
> +       if (ZsHugePage(zspage))
> +               return kmap_local_zpdesc(zpdesc);

Can we WARN here if somehow the HugePage is spanning two pages?

> +
>         class = zspage_class(pool, zspage);
>         off = offset_in_page(class->size * obj_idx);
>  
> -       /* Normal classes have inlined handle */
> -       if (!ZsHugePage(zspage))
> -               mem_len += ZS_HANDLE_SIZE;
> -
> +       off += ZS_HANDLE_SIZE;
>         if (off + mem_len <= PAGE_SIZE) {
>                 /* this object is contained entirely within a page */
> -               addr = kmap_local_zpdesc(zpdesc);
> -               addr += off;
> -       } else {
> -               size_t sizes[2];
> -
> -               /* this object spans two pages */
> -               sizes[0] = PAGE_SIZE - off;
> -               sizes[1] = mem_len - sizes[0];
> -               addr = local_copy;
> -
> -               memcpy_from_page(addr, zpdesc_page(zpdesc),
> -                                off, sizes[0]);
> -               zpdesc = get_next_zpdesc(zpdesc);
> -               memcpy_from_page(addr + sizes[0],
> -                                zpdesc_page(zpdesc),
> -                                0, sizes[1]);
> +               return kmap_local_zpdesc(zpdesc) + off;
>         }
>  
> -       if (!ZsHugePage(zspage))
> -               addr += ZS_HANDLE_SIZE;
> +       /* this object spans two pages */
> +       sizes[0] = PAGE_SIZE - off;
> +       sizes[1] = mem_len - sizes[0];
> +       addr = local_copy;
> +
> +       memcpy_from_page(addr, zpdesc_page(zpdesc), off, sizes[0]);
> +       zpdesc = get_next_zpdesc(zpdesc);
> +       memcpy_from_page(addr + sizes[0], zpdesc_page(zpdesc), 0, sizes[1]);
>  
>         return addr;
>  }
> @@ -1135,20 +1128,21 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
>         obj = handle_to_obj(handle);
>         obj_to_location(obj, &zpdesc, &obj_idx);
>         zspage = get_zspage(zpdesc);
> +
> +       /* Fast path for huge size class */
> +       if (ZsHugePage(zspage)) {
> +               kunmap_local(handle_mem);
> +               goto unlock;
> +       }
> +
>         class = zspage_class(pool, zspage);
>         off = offset_in_page(class->size * obj_idx);
>  
> -       /* Normal classes have inlined handle */
> -       if (!ZsHugePage(zspage))
> -               mem_len += ZS_HANDLE_SIZE;
> -
> -       if (off + mem_len <= PAGE_SIZE) {
> -               if (!ZsHugePage(zspage))
> -                       off += ZS_HANDLE_SIZE;
> -               handle_mem -= off;
> +       off += ZS_HANDLE_SIZE;
> +       if (off + mem_len <= PAGE_SIZE)
>                 kunmap_local(handle_mem);
> -       }
>  
> +unlock:
>         zspage_read_unlock(zspage);
>  }
>  EXPORT_SYMBOL_GPL(zs_obj_read_end);

