Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C7A4CD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 01:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B829A6B0005; Thu, 11 Jun 2026 21:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5A316B0088; Thu, 11 Jun 2026 21:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A978F6B008C; Thu, 11 Jun 2026 21:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97E606B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:39:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 504211A0305
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:39:46 +0000 (UTC)
X-FDA: 84869553972.15.B644CCE
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1574A140005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:39:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LGLOoTjg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781228384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZTQ/6WMmxREpnpZL5rsRg6GyXuulFTK7USgPNOqZmyI=;
	b=rK1NuGoTpeJctrYY/GEKQgWBF5oxS+63X377oouLkr5Gc5VmJ5Pz+3Jjk+AkAE4xgCdEi9
	fExm1Ec5yGXHDj9pLTetFraKquWBVKL8DtmYbwmGBloJgWOr3KMSq1tpabuSnBxXX5preT
	X42xRLfHdOa9cWB9zT87konkcERSs6I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LGLOoTjg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781228384;
	b=yKff4U4P4YguMbSyHxI8v4Kj3scNVpaXUPT7W9wvrEHVCC8jliBBvCYH5hLZbSHcIcawNM
	SPcugVOmalL2I3yJWwVrdys2/sd7NTBZY6U8mgHrMr38mB3CJRqR+5Gi63FVrvfYsr0q3i
	NjT22o/dwDNF+IOGmHQWUOu3i8zx21A=
Date: Fri, 12 Jun 2026 09:39:29 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781228379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZTQ/6WMmxREpnpZL5rsRg6GyXuulFTK7USgPNOqZmyI=;
	b=LGLOoTjgKQ3gCNfchJxPcPiqLb1X/HIdIefLejyjDiekw1r/tabu5dFcuTkv25LIHGUNTH
	nFDRHFIlq0xbj1Sh9oycQgviIY+ZJ4HvMN7ddKZmeOlzTce3ehqzKCyc9J1xuadYNn888k
	pEmDDabL27H2BoXG/dTbM9Yxk6evCo4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	youngjun.park@lge.com, jp.kobryn@linux.dev, usama.arif@linux.dev,
	shakeel.butt@linux.dev
Subject: Re: [RFC PATCH 3/3] mm: entirely remove lru_add_drain in do_swap_page
Message-ID: <aitjUfwbxuaH_1j7@MiWiFi-R3L-srv>
References: <20260611105124.98668-1-baohua@kernel.org>
 <20260611105124.98668-4-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611105124.98668-4-baohua@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1574A140005
X-Stat-Signature: 8tgeky4748refk8d9osztzq7opauuqx6
X-Rspam-User: 
X-HE-Tag: 1781228382-351477
X-HE-Meta: U2FsdGVkX1/6QReH9zSww1HVhcsPgfiKRvxc1waW23K81rUL+WLNQ1+X42OfWZWCX2B9WOJrxHEmQFtE7ECRjaJZRiTktjalPJutLHu3aOHmiZnktquncSO6FzdAkfma1149n+048qYkLOr3BMtCN+LsbzzqOYtq8RU241/z2bPcLoSOIybkEgkRAGN6by9vEsrUHXVuaVIoiHRoctJO2IMozT+t5bG5FYhTzru/o2+55a2IHAK2QObDTjHSJQw/ZgCYUecWArXbbDL9SIjAm8emUMCQ8fjOOHX1fnTmXqoGrbuI1zJGe1m0w5cmp58hWQnsmhlc/AN80psquYtl/6HAAmNhq/9z5pPwf2i3Qr8ppvq/0+1UDmbh6AHd7VKgznQRGx0WhZ+VUvinyMLa+VriXyYDIE6ZoswViI986CCapLyA+tL6+iSEDVihPZfGfj2LIcYa6leu6Msh/EB7miyeuSp82Fl31MovtrKKG9+72wSlj2pJadAeagGLWJhHB0mp/Hk/DRwEw+89hTJeMXqDM4QLONgE5/xlov50VcgQV1eCeSmE7zgZaZBUrRntvrPxuBCJcIVYTuLlrXcvt6NLrNh9hTYmPjjIjBWr6G/XBMZUFP0yvG/hllU1ocxUFnRvDiZakwTzLquUtxCioxC81T4x/AfJzkADoszA0DCBrQf2M0uN0MzZkro7ixmjhyoWfVOPo2XpIXGRJwoviCAZXHdab8cRkgTdJSVe2bbFHKV0GV94jauerWwY0Q/m4psc5/wEfvVDG/1xatgOABGzyQStC+JvVc1XQ0tyxAfyP2lstQIwTcqk07dA/GrvF1vK3WMr5aLZFUNbE19sl8wSX9YIb1sMLBnB+Ya1VYn++qxvJULtAncnFvK2n+UT8qkE7FVXSTmgynGqf9yYGfsXG0onBR2nskoVny+0wWTdxbn/KRHeQcllWeURz/oEx2bAv5Sx+5DPT/gYLOr
 rYUr+KdW
 sVRvxOmfb7O/Gtkz4sig9ub9aEcv0d1QJdU8N7oWvguJ0hJju4mNv7vOlTuIzG89txcdHyRjPYqca4vR9fbDS91o0833LCK5gLrkEJv2An4SDmylJxpvgPlNXqMc0bhYfi+QfqtNcKm+rSscogfgONn9EfouCUvdHQzuCkBrnBLaROex54mFxX+8g47EyxBw/TqKSIQXemtZzlEDFcNmu4l/tz3Czv0Qwbr7jSdcNfuIqY2Vb9SuUrnDUIcCuR3CPtYLsEvhyFMesXcawAq9B+ZOoWivhcp3UtMyda1ZFrw2XVrHPct/uWypXJuMbjDybFTpRkM7UaIMbD9FlLvH13PE547zRR/faN6T8V9H4FEumDr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/11/26 at 06:51pm, Barry Song (Xiaomi) wrote:
> We are doing a lot of redundant lru_add_drain() calls in
> do_swap_page(), especially for synchronous I/O devices. For
> example, the test program below currently ends up draining
> lru_cache 100% of the time:
> 
> int main(int argc, char *argv[])
> {
>         int i;
>  #define SIZE 100*1024*1024
> 	while(1) {
> 		volatile int *p = mmap(0, SIZE, PROT_READ | PROT_WRITE,
>                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> 
> 		for (int i = 0; i < SIZE/sizeof(int); i++)
> 			p[i] =  i%64;
> 		madvise((void *)p, SIZE, MADV_PAGEOUT);
> 		for (int i = 0; i < SIZE/sizeof(int); i++)
> 			p[i] =  i%64;
> 		munmap(p, SIZE);
> 	}
> 	return 0;
> }
> 
> Folio reuse now relies primarily on the exclusive hint, making
> lru_cache draining to drop the refcount in lru_cache largely
> irrelevant.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index ce8ef27e7a54..b5a78670bcc8 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4903,16 +4903,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  	} else if (folio != swapcache)
>  		page = folio_page(folio, 0);
>  
> -	/*
> -	 * If we want to map a page that's in the swapcache writable, we
> -	 * have to detect via the refcount if we're really the exclusive
> -	 * owner. Try removing the extra reference from the local LRU
> -	 * caches if required.
> -	 */
> -	if ((vmf->flags & FAULT_FLAG_WRITE) &&
> -	    !folio_test_ksm(folio) && !folio_test_lru(folio))
> -		lru_add_drain();
> -
>  	folio_throttle_swaprate(folio, GFP_KERNEL);

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

>  
>  	/*
> -- 
> 2.39.3 (Apple Git-146)
> 

