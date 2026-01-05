Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70562C79F9D
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7C8B6B0171; Mon,  5 Jan 2026 10:58:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4F066B0173; Mon,  5 Jan 2026 10:58:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8FB46B0174; Mon,  5 Jan 2026 10:58:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B66A66B0171
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:58:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3145456B5D
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:58:57 +0000 (UTC)
X-FDA: 84298368714.21.DC2146D
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2907D100004
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:58:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CPjZzKlM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767628735; a=rsa-sha256;
	cv=none;
	b=h0j0SJwljP6H6eAF4reh/BFC0BMPa2brlggB2BK/izmMinjHD4V0sRQTVga1B2ha+5ui6D
	/y4fpwRhhAlolbxH8Wc2Tpccj267rqeBBZiEDZz+pCiVwBj8RQLhJbg5Oa46j6ako19/Bg
	T5ShP7eCvXcD3HbU6oCpYFeEoK9huYo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CPjZzKlM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767628735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ym0z0T5HItzl2pYidC+rg4e90vuOlIprRqPMXHeuYvc=;
	b=mjZLjYL+olciCi1No2Lv2jYLuVMbvm2Xmk4+OsVxThZ/xycS9Mwbxo25HmzGIaQQCFgIBU
	pz8a36f2pMFVN2mER8auqWc071VOJ+Zl30RMdVgw+5BaBeYyzvxJ1S/oid3Nzp4jMSKyxb
	1hH4pJP3s2t2GQarn2ZK+/LfJx34jdk=
Date: Mon, 5 Jan 2026 15:58:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767628732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ym0z0T5HItzl2pYidC+rg4e90vuOlIprRqPMXHeuYvc=;
	b=CPjZzKlMmJ6UXcoNDflEiakj2aMD2EzwmthicOlC9UWcURdhMj0gu3HUXgV4Rr9NrX73hH
	IVgyXAZcbR6yE8gKL74vr/d8mPPCbWuZc/1Gm6kocOZ9sC4ssXZbFaMPFJ1k40OwGM0EFw
	GEFohT3G+SLPXs+BvaLQeg5KOSnvweY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <v5veb673xrz6z3tevfdymhuik7nltojrvcqyjih4ds7co4p4hr@5e7ngdkrxo32>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
 <20260101013814.2312147-3-senozhatsky@chromium.org>
 <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
 <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2907D100004
X-Stat-Signature: j8jmxdq4mrzyd9dfhbs8necwwjqoytke
X-Rspam-User: 
X-HE-Tag: 1767628734-890052
X-HE-Meta: U2FsdGVkX191NdOnqA7mUlaEgEO3FD3ZQi6o6s0dukOlHmaQ20q3r2UaF7pP3VxUF+zLkZ4+t3tSDLvtImH5Ahn3zQp7qA0w+Nd4+9ChK/zFbIvGPHJZ0OVl/ZY9LxVznD0vK9jc9kTU2/vbs7h4QiyqoFr/p/lnEXvCnUQpKETYb4S/WiXaNhKql5w40VYS1XEnTyuuOlqXjkDVz2eb8cqoQeD5Mj8vJCRGv5TSOHXbbmUK4Dq1kCFXrKu2PFmvpcWAGue57HFPHZUxJnky5La1lAcDQq4xLXM5vnBJee7+zyvJO5gXipkD2PMzU0yAp3KBaDtpGYeD6uYu+2NNoN8jOLwWXS5bbRJbRtJAd1jMpl2Prtd86rLAMpXmzzJaveXYvpNXI1FYl0RqueR9MMZzepW+yIME4ksi+296AHtu0apiWQKRE9LYx7jJHPMXEwbWpPd0SCgJ4xd6A6uA/T0HZIBuDjT/IhaiL6+zP7jEQTIIMxCe9xZkVEJnXP5TaS58z7d5fpfNW/O4nS/AcJqJPppeIKYXy4JuK7/AiV1zbHSmT0SxIQifbFQnJ8bS88esL2WmW9SmcxsHfD/JZhbBL27YhiE2B1OZBEqtxREUF22eVEbFCoFO+T00xewAImPGZqnVX4teTtTj45BLkcve+VTSvlePGPiGqL/07R/oKHefaQ2KYBkYRjZwaayqqeJVp+gUzQSKrRRLx2mvt2oNLnkaX2w32VmZEDuLBy3djlpY7BKW46bkRKbRrbHUTP1gd2f3X1fFpiqE1FGRmmxctQtW2ICnyKxoAsOiuzbDv4SpYuYUHNg/xMW0v6GpCnwn4k3H3jYLkJMKy6KtafKhp+aVntVvPv+L2w4gKrcXoxZSHSpdQtZZaJvw3e4WMTN6esOcoy+IOKgKdPKoZ1DvzBq6Y2LM/U68GSMgF2sk3ydyomOBI6Czmfi68Fc7ijbEvjDHx5itmsfYgu7
 aX0jTYGu
 0oOM+2mPOa2hIElw2WtcA92WeJA1J/EhVT82SulahF9if2iM6eF80+OHqzIXOV/wCg5Euk5G6iQP+0KO/OsoO0aPLmbUDN57h4bM6koPMN98SO/4UZovosyvsBPhgjy+Mz/5C7xP7WLaRV4D+TnTsAm5a9MFhdWrSHnjF31/jJbsIl9S3S0sH6lunYnqON0K0cGX08ltaGMKPD3Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 10:42:51AM +0900, Sergey Senozhatsky wrote:
> On (26/01/02 18:29), Yosry Ahmed wrote:
> > On Thu, Jan 01, 2026 at 10:38:14AM +0900, Sergey Senozhatsky wrote:
> [..]
> > 
> > I worry that the heuristics are too hand-wavy
> 
> I don't disagree.  Am not super excited about the heuristics either.
> 
> > and I wonder if the memcpy savings actually show up as perf improvements
> > in any real life workload. Do we have data about this?
> 
> I don't have real life 16K PAGE_SIZE devices.  However, on 16K PAGE_SIZE
> systems we have "normal" size-classes up to a very large size, and normal
> class means chaining of 0-order physical pages, and chaining means spanning.
> So on 16K memcpy overhead is expected to be somewhat noticeable.

I don't disagree that it could be a problem, I am just against
optimizations without data. It makes it hard to modify these heuristics
later or remove them, since we don't really know what effect they had in
the first place.

We also don't know if the 0.5% increase in memory usage is actually
offset by CPU gains.

> 
> > I also vaguely recall discussions about other ways to avoid the memcpy
> > using scatterlists, so I am wondering if this is the right metric to
> > optimize.
> 
> As far as I understand SG-list based approach is that it will require
> implementing split-data handling on the compression algorithms side,
> which is not trivial (especially if the only reason to do that is
> zsmalloc).

I am not sure tbh, adding Herbert here. I remember looking at the code
in scomp_acomp_comp_decomp() at some point, and I think it will take
care of non-contiguous SG-lists. Not sure if that's the correct place to
look tho.

> 
> Alternatively, we maybe can try to vmap spanning objects:

Using vmap makes sense in theory, but in practice (at least for zswap)
it doesn't help because SG lists do not support vmap addresses. Zswap
will actually treat them the same as highmem and copy them to a buffer
before putting them in an SG list, so we effectively just do the
memcpy() in zswap instead of zsmalloc.

> 
> ---
>  mm/zsmalloc.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 6fc216ab8190..4a68c27cb5d4 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -38,6 +38,7 @@
>  #include <linux/zsmalloc.h>
>  #include <linux/fs.h>
>  #include <linux/workqueue.h>
> +#include <linux/vmalloc.h>
>  #include "zpdesc.h"
>  
>  #define ZSPAGE_MAGIC	0x58
> @@ -1097,19 +1098,15 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>  		addr = kmap_local_zpdesc(zpdesc);
>  		addr += off;
>  	} else {
> -		size_t sizes[2];
> +		struct page *pages[2];
>  
>  		/* this object spans two pages */
> -		sizes[0] = PAGE_SIZE - off;
> -		sizes[1] = class->size - sizes[0];
> -		addr = local_copy;
> -
> -		memcpy_from_page(addr, zpdesc_page(zpdesc),
> -				 off, sizes[0]);
> -		zpdesc = get_next_zpdesc(zpdesc);
> -		memcpy_from_page(addr + sizes[0],
> -				 zpdesc_page(zpdesc),
> -				 0, sizes[1]);
> +		pages[0] = zpdesc_page(zpdesc);
> +		pages[1] = zpdesc_page(get_next_zpdesc(zpdesc));
> +		addr = vm_map_ram(pages, 2, NUMA_NO_NODE);
> +		if (!addr)
> +			return NULL;
> +		addr += off;
>  	}
>  
>  	if (!ZsHugePage(zspage))
> @@ -1139,6 +1136,11 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
>  			off += ZS_HANDLE_SIZE;
>  		handle_mem -= off;
>  		kunmap_local(handle_mem);
> +	} else {
> +		if (!ZsHugePage(zspage))
> +			off += ZS_HANDLE_SIZE;
> +		handle_mem -= off;
> +		vm_unmap_ram(handle_mem, 2);
>  	}
>  
>  	zspage_read_unlock(zspage);
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 
> 
> > What are the main pain points for PAGE_SIZE > 4K configs? Is it the
> > compression/decompression time? In my experience this is usually not the
> > bottleneck, I would imagine the real problem would be the internal
> > fragmentation.
> 
> Right, internal fragmentation can be the main problem.

