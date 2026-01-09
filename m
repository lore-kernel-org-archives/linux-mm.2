Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B835D26D70
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 16:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD3D26B0089; Fri,  9 Jan 2026 11:03:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA23C6B008A; Fri,  9 Jan 2026 11:03:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCE476B008C; Fri,  9 Jan 2026 11:03:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACE766B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 11:03:02 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 810E91A02E6
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 16:03:02 +0000 (UTC)
X-FDA: 84312894204.03.AFCD40B
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id A397CC0012
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 16:03:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KywQBmKy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767974580; a=rsa-sha256;
	cv=none;
	b=HodpVv1OZ3Ufp5NnGtGv0Dlx7kEsGJREQgogqc/pHalDQSJ5osGmQp0cGk1CF54XRL+HOw
	5Mcd95Dbv0Sh/VfCLqF34y3/Imv+glHy6hCW654BuBCVVP+a3Y3XTs1MDOn5RcqRCLpKSg
	jhlCe8OEbb7TrfbGfFUPY64GxDLDk6Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KywQBmKy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767974580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HO9vyzWX0Ct8pEprBc6DFuRbfkLrbZ4emdg92O7zT0w=;
	b=BleZEYRNuu72n7slLT5BwRVuevOjOu4caYiMJ2DENGgnJKic8/twLOONXuY4ZmW+a7lswg
	4IgP/QNJDWkDkH+W9ZI07m8ee4EB+jf1DvKZsbGOihsW2pFSq0iAIU8J3tG4eVASamWANS
	fHQUnCNzFt7ALQkQSJj01LUT8aW+ISA=
Date: Fri, 9 Jan 2026 16:02:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767974578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HO9vyzWX0Ct8pEprBc6DFuRbfkLrbZ4emdg92O7zT0w=;
	b=KywQBmKym5GSn3EeJNWSqcIbpo9DQ4fzPmNQ5lQwgcXOJPWZKZ1zfMIx5be/zImMZ3j60Z
	ADdkA8akfLqTCYNSrlAiN9h5yAEEc4PXDGsfK8KLJ492vcWXIqn1vB/ukAYgHRR6/ru3Yg
	RZX7usDFvfocrW6xZLm28GHCw6d+Qfw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <mldy4ayvdlmdz2c6spsmbuwiekvqtnxoj2lzg2ktehmdefsees@wdi7vw7kliuq>
References: <7q5gqpfshnc3lfhzxughpks3fc2knw2delpm5io2oe54monydl@5isuxnjputjr>
 <aVyYuS_usi-lpHkM@gondor.apana.org.au>
 <dou7g3n5fpynsab7hmxf4bgmqdewtdhkkiriwlghxzyduick7h@bsi3q2kivvbs>
 <aV3uXguDCaVAbY53@gondor.apana.org.au>
 <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
 <53zplsrqc66z4ea64cosy53zvttuuhgxr2ik7uw6i2zgluegyz@d3ulgntwnyw4>
 <llj3jf5evsp7f2wl2hmm6mouqzwzolvdnu4yquhxbgsgaqvsda@ltct5tqpzmyo>
 <utnvn4oupcmohosp6d3qti54qmdppg2xfw622dq6zz7t66a6ma@2pentzdw3zgk>
 <yxpn4gan74uryy6huzulsqvqvbsqiehdqe6lu7m3hjf3tjjdop@a6cifoycstso>
 <2iophcy2e6vk72ypxeshmen66e7jhr52zr34parn4uw6vdyjef@frnpfrltrky2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2iophcy2e6vk72ypxeshmen66e7jhr52zr34parn4uw6vdyjef@frnpfrltrky2>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A397CC0012
X-Stat-Signature: 1f17k78efw3ujabhbcbaigmmsxmj7jqe
X-Rspam-User: 
X-HE-Tag: 1767974580-496118
X-HE-Meta: U2FsdGVkX1+GgnL2QDpV10R0gsN8/dqab+FKtMOZ2eZy6nVam7HOVdUZ3YIz/6JuqSL4CrrFwiyRDb+3WExyqY1T5lLl3AX+PVpCh3ldQD3Nv5ID6pSndny7uDxggJPwahVujMgur9l0uQKltsIop/hd4YnE/oNutopD4oUT/NdrrU6BsLZ1H3qyPs8G3CWDXX8CUp73O6OWJJuIPReXux9apH33DT7JMdh7a2cw4bbtQ5nd0e4WNIVvwNl3FMHRgz8oHLylrPXi+eJfKbinL71OJcuY7dwrP/jUTPpZAaoovZ/WnrryY19vqYlHxlQVF1eEo4rdTbVe8+LpN9QXFkhWjuCqP8Wne0iXem6ae4zpHqrxdTrYlaqwgCnpU64nUfz7sSsDzYQ/l7ZWfla5tw53b1TDpSwJ2cVcO8slumuZiX0qkOY7GPnYK33X8KBrfqXggKwbJL8cPCx66VoIKcnrG8H2qv1wtm7d4fhq/5s+uTsxN0Q9kvJTOU4mV5ZjLns+AatJFaQeVghLnUnCiN2doftgH/tHjkDwmf9uNclnrxE2bmYgZxrApXpXUj/J9BU8/EhJeAA5IlZHaQw1hBRInegzyBDkYxKfCXuqmyeOu7Z1LP3slBy5jhj6+JlrZD5ocSSq2nQKUdczv9G1jxANanghrRFzUvE+7fLiYrkecLgQ30aqVpWDI7WFicicsO8D2gfQPoen2Th1Oa/xh3eaij1iBj0Qx4z4gs/JiEXDHi//cYJ3RUzRBPZFwL/ieuIo0Dm9N4nCFXYE7EMLzver3WVVKUBbYQeHEskt+ceiR+tw+4T9oY9BhamNskggTYYHcPzW1mGbgqzRQbrSlfEKTBzvQ6ruEt/TdJ3DK0K//+6L2eIXeArNduj6fEjF8UulUMl/EUX7AqNShDXFhVWYiCAbCek03AXejp3nJ3n67bK86qxb7PFsBJ14iQ/GNt73X4v1piG3y9CZBR3
 fPG6N6nD
 xc6m8gNxmk2Y3HhQKvDVc0Kn3vqk+oG7l6u5TQpod+KhNNJTGNBmFzOlK3GeiInRdfBU8IynvMwiM0M2n7K8q1hDkIPyJY+/zI0B4pxpCiobENPfcKA33+vXxJ2gHfIcQ62iw2yZkPKRTDdjlzPsrVKOZQvkuT8xxweD2aj6zq18Vnx2B8d02gqtFftfIM4bS5kgEpm24MqWn68Cx+wJaCImAbPn13VmM9s6+V/rJQeiMiic=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 12:29:58PM +0900, Sergey Senozhatsky wrote:
> On (26/01/08 08:01), Yosry Ahmed wrote:
> > > Yeah I agree, I guess I can cook something up.
> > > 
> > > For transition period we can have:
> > > - current "memcpy" API
> > >   for zswap
> > > 
> > > - SG-list API
> > > 
> > > I can vmap either on the zram side or have new zsmalloc vmap API
> > > (alongside the memcpy and SG-list APIs).
> > > 
> > > Once crypto API supports SG-list and algorithms tunables I can
> > > switch zram over from zcomp to crypto API and remove memcpy and
> > > vmap APIs from zsmalloc.
> > 
> > IIUC based on Herbert's previous response, crypto and scomp already
> > support passing in a discontiguous SG-list. So for zswap, if zsmalloc
> > returns an SG-list, it will just be passed as-is to the crypto API.
> 
> Oh, okay,
> 
> Something like below?  Not really familiar with SG-list API.

That makes two of us :P

Herbert, do you mind taking a look at this? It looks sane to me except
for one question below.

I can try to test this next week with zswap and see if it blows up.

> 
> ---
>  include/linux/zsmalloc.h |  4 +++
>  mm/zsmalloc.c            | 65 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 69 insertions(+)
> 
> diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
> index 5565c3171007..11e614663dd3 100644
> --- a/include/linux/zsmalloc.h
> +++ b/include/linux/zsmalloc.h
> @@ -22,6 +22,7 @@ struct zs_pool_stats {
>  };
>  
>  struct zs_pool;
> +struct scatterlist;
>  
>  struct zs_pool *zs_create_pool(const char *name);
>  void zs_destroy_pool(struct zs_pool *pool);
> @@ -43,6 +44,9 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>  			size_t mem_len, void *local_copy);
>  void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
>  		     size_t mem_len, void *handle_mem);
> +int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
> +		   struct scatterlist *sg, size_t mem_len);
> +void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
>  void zs_obj_write(struct zs_pool *pool, unsigned long handle,
>  		  void *handle_mem, size_t mem_len);
>  
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 16d5587a052a..8f7569058147 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -30,6 +30,7 @@
>  #include <linux/highmem.h>
>  #include <linux/string.h>
>  #include <linux/slab.h>
> +#include <linux/scatterlist.h>
>  #include <linux/spinlock.h>
>  #include <linux/sprintf.h>
>  #include <linux/shrinker.h>
> @@ -1146,6 +1147,70 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
>  }
>  EXPORT_SYMBOL_GPL(zs_obj_read_end);
>  
> +int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
> +		   struct scatterlist *sg, size_t mem_len)
> +{
> +	struct zspage *zspage;
> +	struct zpdesc *zpdesc;
> +	unsigned long obj, off;
> +	unsigned int obj_idx;
> +	struct size_class *class;
> +
> +	/* Guarantee we can get zspage from handle safely */
> +	read_lock(&pool->lock);
> +	obj = handle_to_obj(handle);
> +	obj_to_location(obj, &zpdesc, &obj_idx);
> +	zspage = get_zspage(zpdesc);
> +
> +	/* Make sure migration doesn't move any pages in this zspage */
> +	zspage_read_lock(zspage);
> +	read_unlock(&pool->lock);
> +
> +	class = zspage_class(pool, zspage);
> +	off = offset_in_page(class->size * obj_idx);
> +
> +	if (!ZsHugePage(zspage))
> +		off += ZS_HANDLE_SIZE;
> +
> +	if (off + mem_len <= PAGE_SIZE) {
> +		/* this object is contained entirely within a page */
> +		sg_init_table(sg, 1);
> +		sg_set_page(sg, zpdesc_page(zpdesc), mem_len, off);
> +	} else {
> +		size_t sizes[2];
> +
> +		/* this object spans two pages */
> +		sizes[0] = PAGE_SIZE - off;
> +		sizes[1] = mem_len - sizes[0];
> +
> +		sg_init_table(sg, 2);
> +		sg_set_page(sg, zpdesc_page(zpdesc), sizes[0], off);
> +
> +		zpdesc = get_next_zpdesc(zpdesc);
> +		sg = sg_next(sg);

Is this stateful? Will the SG list be returned pointing at the second
page now?

> +
> +		sg_set_page(sg, zpdesc_page(zpdesc), sizes[1], 0);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(zs_obj_read_sg_begin);
> +
> +void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle)
> +{
> +	struct zspage *zspage;
> +	struct zpdesc *zpdesc;
> +	unsigned long obj;
> +	unsigned int obj_idx;
> +
> +	obj = handle_to_obj(handle);
> +	obj_to_location(obj, &zpdesc, &obj_idx);
> +	zspage = get_zspage(zpdesc);
> +
> +	zspage_read_unlock(zspage);
> +}
> +EXPORT_SYMBOL_GPL(zs_obj_read_sg_end);
> +
>  void zs_obj_write(struct zs_pool *pool, unsigned long handle,
>  		  void *handle_mem, size_t mem_len)
>  {
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

