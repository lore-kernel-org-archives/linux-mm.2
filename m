Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5184CCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 10:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9104D6B0005; Thu,  4 Jun 2026 06:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1846B0088; Thu,  4 Jun 2026 06:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0176B008A; Thu,  4 Jun 2026 06:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 676DA6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:29:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14A9AC2321
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:29:45 +0000 (UTC)
X-FDA: 84841859130.01.A766B6C
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id F29874000D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:29:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf11.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780568983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VcSYpl+1WphsZRL+zITAD4N1z6M6Y6VvGOav8GW48qQ=;
	b=edsqdAuI/z2rxBep1v18DuCDF9Xd6l1AlndboKO//pQlOdkcpAurCGYnlNSbtpMsW3q0Nz
	QOmP7bDba7G2Dx6ldIWyx+rir4lTbUMA9bru7hn/5XZjW2XfeGkEopXnd9BZXimzjQR454
	gWmM1FToT2T3jRHjl1CslRkfe4pSupM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf11.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780568983;
	b=s31vhvCweups3n5VaFA5mddrurMwegjD/tveGW82OZoFVe84m/e9oZ0gceIGDYbedXUmLL
	itkfQIGX8Tsk8n54B6veAtFJbT91SZvOnFulhE7rj3A4HhA4FEjs9fqC4NzOHSDN6NHxb1
	dDUZdJZ9zNAMUPiOU2ibTkij1du/zPE=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gWLR666H1z5B101;
	Thu, 04 Jun 2026 18:29:38 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 654ATUM4053000;
	Thu, 4 Jun 2026 18:29:30 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 4 Jun 2026 18:29:32 +0800 (CST)
X-Zmail-TransId: 2afc6a21538ca37-24356
X-Mailer: Zmail v1.0
Message-ID: <20260604182932932_ZzYpW9TqAks7MQiIwJc7@zte.com.cn>
In-Reply-To: <07f55792-c83f-433c-bb16-58a5824d1dd7@kernel.org>
References: 20260603211011530GqLSXP_rgcuQdR47IGQLL@zte.com.cn,07f55792-c83f-433c-bb16-58a5824d1dd7@kernel.org
Date: Thu, 4 Jun 2026 18:29:32 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vc2x1YjogcHJlc2VydmUgb3JpZ2luYWwgc2l6ZSBpbiBfa21hbGxvY19ub2xvY2tfbm9wcm9mIHJldHJ5IHBhdGg=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 654ATUM4053000
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Thu, 04 Jun 2026 18:29:38 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A215392.000/4gWLR666H1z5B101
X-Rspamd-Queue-Id: F29874000D
X-Stat-Signature: bqm7nx994k6knz3c6boznyeq54nnqs79
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780568981-450479
X-HE-Meta: U2FsdGVkX1+cAXPT3w0IzMxbB074rfW73MiKhJKynJ//WfZcQYXQfvsk42e0ISVqXxHF+qCcytOnUFJt1bG24Jj4tr3XO0B5GLNS7tEI5vAsO0tFgrjqZb/hnQUv7pgKmPIzVY/TbEftiDnLZcwCR/lk86gwB0/PL04ITUL3XNxexUaCb2gtJwYVNr4qsy2zWeWen6OHvqBF0/3i4rm8zWCz+B8KCgzb5A3vdphgOC6nZU7gcP9mbUDPHBaVltD2aH8ojRjwIBv0Ul6mLwQUTfH729JcERMYtc8+a4bnRlvE4FFDaVgB7niugi8qclIULH3DXb9hh61IV4ymmsRBT8/dPDfQ4vcTqdsw7onnh8rp/wAcGOrSoau7+SD8qR1T2efasOg93a+vFztXAYNFMhSZNkUtOkTfBVhSszAOqxg1KsRzT1jwOhHTA33qXPOquSI48zgRzy7Gtg2YUDEzZZfoT2azp0v5Y9al3eC77HBsWs9zXLdYZraLHswDqsfj4CuekBKSWGEC6ux/PgWgeoKXh4M97fmOURWKBN/4D6MXyaHZ4RZtB2j9MPnTUpAUTPFQJBwQR9ZLHr8sdUV1HYFX1SQjIqaELx19yGwfZYQOmmLckExQUkgCFlOefgDL6/HLEcEFpLVx7i/95w97NvNK/YmFmYqEENpsuEE7z+kO560GSGJ4ZJLdkDBZs3g71PucScamlPJIytx3XPOFPojhU5V5xFE2ZGAelHulajfKsfSZhvCBlE223OoGKTyAawqecjojmRYbJMLYOvjiz4gJs68QwLJ2/H5tRHM6NAyVzKcIW7aaVeyzdgJAvzhgGyOij1teZB9PZykQpdbpPr8/C1CZv8Xbqffskg+Kl76aZI3gvRY/JNb+ku8XhJtT1Mvrhk3qBFLjCtMbx0AGqvaN33oy4M08PwPbEwkkneVUiYf94fGI+pF+OqgePZF2JlI7iOV3vqvvwjuJGJm
 6UEYUyrV
 J2xAvn835QrIjYkrOvo2RahuED/HSRCpDchrf3yY6szwK3o8Jhs3VxCjfk+ajo1clMwSHUAbFbIfEclWT96jl65dJehy04qRMDCGgCSPKGX1R4MYLmuG2FlZdW4+RaA0CWybcOJwUGbU8eBL0O78jNZdDWZ4FCiL187dttnCySTiEj87GmNG6LoeEQjL2wZIIVBv+pCwSRronoY8kq/XriMncmeJ9oNzwotAFMiK4pJXqUfiMONr8hVf+i2tWXmeHf7C6U4Z7fZQtcb5+ray5DDIJVCgYJ0vSsWrw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> On 6/3/26 10:10 PM, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > _kmalloc_nolock_noprof() retries from the next kmalloc bucket when the
> > initial allocation fails. The retry currently reuses `size` as the
> > bucket selector and overwrites it with s->object_size + 1.
> > 
> > That value is later passed as the original allocation size to
> > __slab_alloc_node(), slab_post_alloc_hook() and kasan_kmalloc(). On a
> > successful retry this makes KASAN/slub-debug observe the retry bucket
> > selector rather than the caller requested size, potentially widening the
> > valid kmalloc range and hiding overflows.
> 
> Good catch!
> 

Hi Harry,

> > Keep a separate `bucket_size` for choosing the retry cache and preserve
> > `size`.
> > 
> > Fixes: <af92793e52c3> ("slab: Introduce kmalloc_nolock() and kfree_nolock()")
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> > ---
> 
> I want to note that this conflicts with Vlastimil's work-in-progress
> feature [1] where it separately stores orig_size in struct
> slab_alloc_context which naturally solves the problem.
> 
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/slab_alloc_flags
> 
> No strong opinion on whether to queue this patch and then rebase
> Vlastimil's work on top, or wait for Vlastimil's work to solve the
> problem instead...
> 

Thanks for the review and for pointing out Vlastimil's work-in-progress
series.

> >  mm/slub.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 67abbbf68fc1..6a2b3ade3611 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5350,6 +5350,7 @@ EXPORT_SYMBOL(__kmalloc_noprof);
> >  void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
> >  {
> >      gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
> > +    size_t bucket_size = size;
> >      struct kmem_cache *s;
> >      bool can_retry = true;
> >      void *ret;
> 
> But in either way, I think it's more straightforward to introduce
> orig_size as a variable to keep the original size and pass it to
> __slab_alloc_node().
> 

I agree that introducing an explicit orig_size is more straightforward
than adding bucket_size.

I'll update the patch to keep:

	size_t orig_size = size;

and use orig_size for the allocation hooks/KASAN paths, while allowing
size to continue being advanced for the retry cache selection.

> > @@ -5372,9 +5373,9 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
> >          return NULL;
> > 
> >  retry:
> > -    if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
> > +    if (unlikely(bucket_size > KMALLOC_MAX_CACHE_SIZE))
> >          return NULL;
> > -    s = kmalloc_slab(size, NULL, alloc_gfp, PASS_TOKEN_PARAM(token));
> > +    s = kmalloc_slab(bucket_size, NULL, alloc_gfp, PASS_TOKEN_PARAM(token));
> > 
> >      if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
> >          /*
> > @@ -5408,7 +5409,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
> >       */
> >      if (!ret && can_retry) {
> >          /* pick the next kmalloc bucket */
> > -        size = s->object_size + 1;
> > +        bucket_size = s->object_size + 1;
> >          /*
> >           * Another alternative is to
> >           * if (memcg) alloc_gfp &= ~__GFP_ACCOUNT;
> 
> -- 
> Cheers,
> Harry / Hyeonggon

--
With Best Regards,
Shengming

