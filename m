Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E81EECCF2C1
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 16:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1061A6B008C; Sat, 17 Oct 2026 12:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7C76B0092; Sat, 17 Oct 2026 12:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7D96B0095; Sat, 17 Oct 2026 12:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5CE36B008C
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:02:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52EDD16039F
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:02:34 +0000 (UTC)
X-FDA: 85332585828.25.3E655B3
Received: from mta1.migadu.com (out-15.mta1.migadu.com [95.215.58.15])
	by imf13.hostedemail.com (Postfix) with ESMTP id E5CB42000B
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:02:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H+X25fg3;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.15 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792252952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMtCj83MZWCdQaWjVDoiY6zg//N+365KYv8A73mCyvE=;
	b=g/9SBCYtNjcwPUCA/LFsX+s1PaBQu+bIl5lgPQ7V3Ga7r6n0q5RUBodxE0wzY/XVd2ob4k
	UL2Xbc5tNeJ8RikSnmEvSier4TJLsJ8hWFXTzWRez5A65hiT7zB+7TbYmlrpCUqg/w7SFv
	O4PPiguYof4JP1yp1NdqZFI+o0uHzjs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792252952;
	b=XfGmrzGm+6QKGHl2autT/1iW4hcL9QiNv01oDWur94DDmGUiFaEucG7TL8zS4+P+xM1A1K
	j+1TD/gEVLwa5igu6uN21unOqm8uklrMH6L6r+FCG837YnJ1QVzQyywx5Uw9YCbDoEOTzM
	MF2mjCr5/7BRZvXrQ+DkizqIV+ihnhA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H+X25fg3;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.15 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3TIUnaMNJegHr2uMi3ty/Rxvko3+soqxUBxLdSsFFmc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792252949; v=1; x=1792857749;
 b=H+X25fg3kSVgbkwl44DuSSGBpdLoTDbZAfgfCHea7mC39cPQbcdlR8FOiWFo92vVmuqGCKCB
 k0sluPFs3zb+PPqtemu9aaRgFKeHHvlKfnVfmHGulfFjy+f0B/EwA6vOxTEfXSpmQdp8gqsNwtW
 omwLM6dWFVNfGyawXzenfRxU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 0e5aa83133d443f6;
	Sat, 17 Oct 2026 16:02:29 +0000
X-Mizu-Trace-ID: 0e5aa83133d443f6
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	chengming.zhou@linux.dev,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	terrelln@fb.com,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	senozhatsky@chromium.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 1/3] mm: zswap: use separate compression and decompression requests
Date: Sat, 17 Oct 2026 09:02:25 -0700
Message-ID: <20261017160226.2510957-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAO9r8zM-utRFYGBfaEb=89LWM0DOKc8dywcDLSb6L7f4c80yuQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E5CB42000B
X-Stat-Signature: 4x3gfuotnfbwpnxwctcntfcbrr4ygju4
X-Rspamd-Server: rspam05
X-HE-Tag: 1792252951-494926
X-HE-Meta: U2FsdGVkX1/dK52PpVh7Mmo2Cuo6WbtvH/jeRYr+Fo+t4CVEkUJEgcDZZ5HmAtx/nWJTE+9A1h0YcNXk3IqUjabxkn22fQFSi5c5NEXWjWzPGrsWexGVT7CpCfbCZWlQ9vpxfUkbKn5aFhnD9BSU+t8lwEV+tTM/sYXgeJOZs0KRIDV9gwX5ywvZIW6FBdnGI8H04XxykFhelRbsy1C8vgHFXaYSMYnN4r8cu7Z2atCG7IUp9Yaewr2S6kCw+s7eUZSw4kzNb9JLWeob2fE6AFZFclaOzx59Bdv16hQiu8oqCbmiWerN1gMmVp94HgLVmccm3rfv/W3NvCJbA0f1TkT4/jMnSCaKerDJx66J6cOl1jlzEnU+bZ1y5zU7GzsIzr0KPNeuhnethXJyHlRF4p5xdJKrn9cbirq071jbqikwrrQqrdj3y/LAOA2TCZuk5rTexZpYn0GWqIZhJaBR0jo5XpHEwOPV/s6QELpacUbzU1z2jgm3xkLll0JSRV6URlEAcCc8ulcSYhOr6Fn0eOwysmulP43MwUDxz9h9iGcmBjOEEOyT9waCjS8T5KjfC14+hqneZMJ5G0mP8gPlKhlUBZg4ra47i+tX35Qy3wLsgmjvsukjZXA/EghBePn13kvR+h5AnpPN917RgocWtPzEMeJp2Mwzbb3NNOAo7pa2vwlGVttRZvxcI1sV6uTfWUEUJarLGzgdqt+PUs5dG1kTOZqR1nyqLoRc6HLSTlCkjcQJYfgQmlqt3i3MbBMFSPYQAW4yP85Nt4XF7gC4wksr41WKVhi5O+sf2X/nIJzNs2nzhKwN8HLf1pFBO6qDUQqc8kr89U+uiUH+uTTWAeekuklV6jiBdRmb5HJESzLnRTX+JfL5sz9OiZXopQkBb8nE0nlB9H6Oj4T6hJoU0xjddxT9xDPqZmuNONUrwEHStUhTDWgx+bQmZ8cSZwh3ICvQAEWNAiNo7s12xgB
 HCPvHiBk
 YGipTxg5VRILz97fV8iPWoSVmRugaC5yf2kxzRfcXz0iJqDT/FN2Cik7LWbugtj6DtANEcNxQODsH0FWc7ObsRMDVhkn3AX9TCX18vXT+dkeDDxRMe+1AwlEqNXsA2PNU0JrZ+rPyxELKyUMgd+ZSU6dHoK9w5RP/XLfOKIFffKa9+OoOFjO2EI8AZ75IzQ/6OgMG3zjGPoVFrQLd6S2QIvK/ky7PiHL8VO/RxB82SbKxQTawSR8Y9a5BknBT8WOnhhgbiZ4h5Zlp41klKCG0nlawdZItxPPUvbG98y/7oH+0mfjHs5akHJVQ+qK7vdeAYBmLOCzmZ6kIQkA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 13:57:14 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> On Tue, Oct 13, 2026 at 8:10 AM Usama Arif <usama.arif@linux.dev> wrote:
> >
> > Stores and loads serialize on the same per-CPU acomp request and mutex.
> > A low-priority store can be preempted as soon as the compressor drops
> > its stream lock, while it still holds the mutex. A higher-priority load
> > on that CPU then waits until the store runs again, which can take a
> > long time when other tasks are runnable.
> >
> > Give compression and decompression their own request, completion wait
> > and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> > decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> > compression, so group it with the compression request. Independent
> > requests can share the per-CPU transform; the codecs and drivers
> > synchronize their shared state internally. Loads can still wait for
> > each other on the decompression mutex, and stores still serialize on
> > the compression mutex.
> >
> > acomp_request_free() ignores NULL requests, so drop the check in
> > acomp_ctx_free().
> >
> > This follows the proposal from Sergey Senozhatsky for the same split
> > for zram [1].
> >
> > [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/
> >
> > Acked-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> Why didn't you take Herbert's Ack?

Ah completely forgot, will add it in the next revision and fix the nit below.

> 
> LGTM with one nit below:
> 
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> 

Thanks!


> > ---
> >  mm/zswap.c | 108 +++++++++++++++++++++++++++++++----------------------
> >  1 file changed, 64 insertions(+), 44 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index ae19e301fced7..23c4298765795 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -137,14 +137,25 @@ bool zswap_never_enabled(void)
> >  * data structures
> >  **********************************/
> >
> > -struct crypto_acomp_ctx {
> > -       struct crypto_acomp *acomp;
> > +struct zswap_acomp_req {
> >         struct acomp_req *req;
> >         struct crypto_wait wait;
> > -       u8 *buffer;
> >         struct mutex mutex;
> >  };
> >
> > +/* The compression mutex also protects the output buffer. */
> > +struct zswap_comp_ctx {
> > +       struct zswap_acomp_req areq;
> > +       u8 *buffer;
> > +};
> > +
> > +/* Separate requests, so that decompression does not wait for compression. */
> > +struct crypto_acomp_ctx {
> > +       struct crypto_acomp *acomp;
> > +       struct zswap_comp_ctx comp;
> > +       struct zswap_acomp_req decomp;
> > +};
> > +
> >  /*
> >   * The lock ordering is zswap_tree.lock -> zswap_pool.lru_lock.
> >   * The only case where lru_lock is not acquired while holding tree.lock is
> > @@ -270,14 +281,10 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
> >         if (!acomp_ctx)
> >                 return;
> >
> > -       /*
> > -        * If there was an error in allocating @acomp_ctx->req, it
> > -        * would be set to NULL.
> > -        */
> > -       if (acomp_ctx->req)
> > -               acomp_request_free(acomp_ctx->req);
> > -
> > -       acomp_ctx->req = NULL;
> > +       acomp_request_free(acomp_ctx->comp.areq.req);
> > +       acomp_ctx->comp.areq.req = NULL;
> > +       acomp_request_free(acomp_ctx->decomp.req);
> > +       acomp_ctx->decomp.req = NULL;
> >
> >         /*
> >          * We have to handle both cases here: an error pointer return from
> > @@ -289,8 +296,8 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
> >
> >         acomp_ctx->acomp = NULL;
> >
> > -       kfree(acomp_ctx->buffer);
> > -       acomp_ctx->buffer = NULL;
> > +       kfree(acomp_ctx->comp.buffer);
> > +       acomp_ctx->comp.buffer = NULL;
> >  }
> >
> >  static struct zswap_pool *zswap_pool_create(char *compressor)
> > @@ -796,6 +803,28 @@ static void zswap_entry_free(struct zswap_entry *entry)
> >  /*********************************
> >  * compressed storage functions
> >  **********************************/
> > +static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
> > +                               struct crypto_acomp *acomp)
> > +{
> > +       /* acomp_request_alloc() returns NULL in case of an error. */
> > +       areq->req = acomp_request_alloc(acomp);
> > +       if (!areq->req)
> > +               return -ENOMEM;
> > +
> > +       crypto_init_wait(&areq->wait);
> > +
> > +       /*
> > +        * if the backend of acomp is async zip, crypto_req_done() will wakeup
> > +        * crypto_wait_req(); if the backend of acomp is scomp, the callback
> > +        * won't be called, crypto_wait_req() will return without blocking.
> > +        */
> > +       acomp_request_set_callback(areq->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +                                  crypto_req_done, &areq->wait);
> > +
> > +       mutex_init(&areq->mutex);
> > +       return 0;
> > +}
> > +
> >  static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> >  {
> >         struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> > @@ -811,8 +840,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> >                 return 0;
> >         }
> >
> > -       acomp_ctx->buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> > -       if (!acomp_ctx->buffer)
> > +       acomp_ctx->comp.buffer = kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_node(cpu));
> > +       if (!acomp_ctx->comp.buffer)
> >                 return ret;
> >
> >         /*
> > @@ -827,25 +856,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> >                 goto fail;
> >         }
> >
> > -       /* acomp_request_alloc() returns NULL in case of an error. */
> > -       acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
> > -       if (!acomp_ctx->req) {
> > +       if (zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp) ||
> > +           zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {
> 
> We stop propagating the output of these functions to the caller here.
> It still works because ret is initialized as -ENOMEM, and that's the
> only possible failure of zswap_acomp_req_init(), but that's really
> subtle.
> 
> I'd rather either propagate the return value as-is on failure, or make
> zswap_acomp_req_init() a boolean so that it's obvious there's one
> failure mode and future changes can't just return a new error code
> that would be silently thrown away.
> 
> >                 pr_err("could not alloc crypto acomp_request %s\n",
> >                        pool->tfm_name);
> >                 goto fail;
> >         }
> >
> > -       crypto_init_wait(&acomp_ctx->wait);
> > -
> > -       /*
> > -        * if the backend of acomp is async zip, crypto_req_done() will wakeup
> > -        * crypto_wait_req(); if the backend of acomp is scomp, the callback
> > -        * won't be called, crypto_wait_req() will return without blocking.
> > -        */
> > -       acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> > -                                  crypto_req_done, &acomp_ctx->wait);
> > -
> > -       mutex_init(&acomp_ctx->mutex);
> >         return 0;
> >
> >  fail:
> 

