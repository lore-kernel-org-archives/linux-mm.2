Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E7FBCC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 20:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3DB6B008A; Tue, 13 Oct 2026 16:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C396B008C; Tue, 13 Oct 2026 16:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1806B0092; Tue, 13 Oct 2026 16:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E47EE6B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:57:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7159D160256
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:57:30 +0000 (UTC)
X-FDA: 85318813860.08.96F25F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8A5D280012
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:57:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C+YJVFkO;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791925048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swgyvDADh7aeJQJNNx7+x0lhh5sd5zqR0J3CqoTV4l4=;
	b=sPIhxUroOU4s2n4/sgYjobEcBKhUq/iRSYpq+cnORsbJanU0VMsKHD7ZouFabUllhlYzFv
	AgFNXiUsIY8HVYfDsD3vsabjrLbA6tIkFVZTuJDpRGsGowZwIzmpddJrfM8CyjLCh02Slp
	bpydsb/nuswK4d8mmOsmHMIgDVMXidc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C+YJVFkO;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791925048;
	b=10b2TdRH0XEkk6C5oYIHRJ3M9pAbjtvimrMuSiSwaLqCpyxJBECJquHVy7XPVF9t/P1Z3c
	+xOjI6WylRd4bbE4HClDf7pHSPpoOFbcOBDf8+Mru7uZtMdWMNP8CwN+PFTxen+n04z/HE
	OMiYqqSFR1Q8lbmMxDCCQjgpjpjttQg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C8C86022B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5452B1F0089D
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791925047;
	bh=swgyvDADh7aeJQJNNx7+x0lhh5sd5zqR0J3CqoTV4l4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=C+YJVFkOF9c2RKGomBEkLsdb7XpO46ieksvz698VJ+S9y1JDMAkBAA74T+3eggGaK
	 EA32LLp1WyxGlbnOaOIthy/dv7aGQJk6zNV9M80A270KWi3KKfveOArTw7FFUOplH1
	 pP4lJlSUeP+IOeJUKsR5R2pEEmMkQXgLPOf7yFvudnoSFqjb2DZHOaUeWgEIa2SVkY
	 56YzotlLmAPaWhzK3bdVr21R2qxq710WYgMmoe1tpPD8uB9O8wPdms8XivyGB7G/vi
	 /MO4xJymJdVLyQmtsbO3/Yw6SsAhnnXB7ihAj2+JaEoc6H8BjjXzPdPgM+5wvJEa1C
	 FHC30gNwvRv3g==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2e6df2742cso530467566b.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:57:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxVAMzNH1PVJqw4n8VXux+SpU+LbIoKYNDgyhttFTgBDxYGBZC3u3iMPDHXky/aeDzRV/W1u/lM8w==@kvack.org
X-Gm-Message-State: AFq9FYLOS4DNt/ll9QggXNmyRXaJbmp7j/MOMELh04YRgV/akMA0/Dp+
	YG7ntDQajLiVeNg5AQvnZzpBZ69i/aCC0MRZtXPo7S7MbMMQB12AX/PPAYYtDfG5GKCDgens10J
	LsN553AvpdI/998JXkUm415mXQXcxn/Q=
X-Received: by 2002:a17:907:c26:b0:c2a:3473:6780 with SMTP id
 a640c23a62f3a-c31a9ffff31mr1312422266b.25.1791925046208; Tue, 13 Oct 2026
 13:57:26 -0700 (PDT)
MIME-Version: 1.0
References: <20261013151007.2093943-1-usama.arif@linux.dev> <20261013151007.2093943-2-usama.arif@linux.dev>
In-Reply-To: <20261013151007.2093943-2-usama.arif@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 13 Oct 2026 13:57:14 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM-utRFYGBfaEb=89LWM0DOKc8dywcDLSb6L7f4c80yuQ@mail.gmail.com>
X-Gm-Features: AclHuK_lRc7F0Bg3qaR5eej13vxAe2hsWEYGgSw8MGRsbo0q5ZL77DQKttmVvso
Message-ID: <CAO9r8zM-utRFYGBfaEb=89LWM0DOKc8dywcDLSb6L7f4c80yuQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm: zswap: use separate compression and
 decompression requests
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, terrelln@fb.com, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, senozhatsky@chromium.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8A5D280012
X-Rspam-User: 
X-Stat-Signature: 9q1uoym1wki89h34swas4z7wbmcuj8ja
X-HE-Tag: 1791925048-558868
X-HE-Meta: U2FsdGVkX1+lv6dpXMIvNgizPnK7IPTZLiaolcEsTrSl+x1qHCEW/S+eD3wESQ4FtlovAu3LkcvHcwQmpn4x9SASnHWkjJCgYwXfyBkiKryNwSaZIwV+yhqxDXtcpspLS8szoeB0FSq26ZuQzs2rXpw+znyMvZv6YZCryEFVx5uUrEc+I5F/EaBrupjRB4E5eA3GKf6HSwXOsI0L6FO9Ei4a3eHw04ex90hxLqRX5I/SvfPi5QA7zQj9yiPdBOvKFNisMFxF18Il40vHDCrp9Ic/0qN+kiN5A2GODxXZlLsovmq1pBjEl5y8LuenQHzXinkRWvsXkyJgzW7jbRgDWJ5zCsPEJTz6uZWYXzP/iblHQ6hYULxSm0F6JpznFxZactJFpgZgiDtCfHpbKBnuRboVWoNUHxLsN1lPMyWWwIbAJRl5/HZSraby0Ig6eZhvHe3zAVh3iabHnpPWSliGvmN0esHgzl7Qa9j2h7DFX4XFR+WE8dQN8Fr7uoaiD4M9HvjbETTOVeiYOuAU7HB9rZ9xr7B5ZQqenJmtasaiNEdYarivptUg7sH5gpnR2LwcMeMbpTYG8VB14XnT60NMcj+szb1jIALB/LMcdyDJBzjbrrs+CSI4L3c+82e6ISqeT2JST3rTjH5UW57ok5utFG0bfjGL6eSsLssXpm33Xc7GFflEOftwxPh78JBV5KdH+5AKsm9XPXOf11xozbdo2aYiroIv169q/niAE7LJZl9pQEbptuZ/SnzXpYWkGKmm72zfrXeRFP4gX7pJRwnIrQ/ws7gU9+PdUufz7Rhs2eX+9LPREiHsSQEW7lvt21HY9THzZQiwzrZaesQVlk3PQNJ7lKge/wKUQO8H+o6lislIYKPq5d8YnAaoLf5VkHRyyVwqi+ygOogNTJMyjtzWsSVXDU0vnEQ7srK3ftvP8php1x23uMeldtVQKm0T3VT7yCjan5eMZkWByjlvBVk
 yKWbQ9BG
 S38XtCop0RwjTdNaOYYgcjsWNlZsHjxumfWm9jXv7mLM3hH6cwdguG84TN0/vLhVAen6+KXHZ0PHw5f5jisb+pQ8FyaI9iIyvsfOh805zNQ+o+cOkxpJvsapl9BfmWFKswyl7iW2dj9qICPwBVtJayyJgMxet765yd6/oaEBUNKwsXfYFEcgJpN0yKKZClIORC7qK3GVd0C4XJuu7jxVGrWS5dEirchiFKq/aWT4oLda5KHsrw8CcsxOgR1YKBt0vgh6hbDk0JqZhdfvB6dGfY9slgJchJVc1zE1kZTiCIA9ati7JE2luWGYWpd6S8bqUFdXMxMygmcqy2ehGhumxZSArwJCFXgAQITwjKAoVDB8XRk4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 8:10=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
> Stores and loads serialize on the same per-CPU acomp request and mutex.
> A low-priority store can be preempted as soon as the compressor drops
> its stream lock, while it still holds the mutex. A higher-priority load
> on that CPU then waits until the store runs again, which can take a
> long time when other tasks are runnable.
>
> Give compression and decompression their own request, completion wait
> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> compression, so group it with the compression request. Independent
> requests can share the per-CPU transform; the codecs and drivers
> synchronize their shared state internally. Loads can still wait for
> each other on the decompression mutex, and stores still serialize on
> the compression mutex.
>
> acomp_request_free() ignores NULL requests, so drop the check in
> acomp_ctx_free().
>
> This follows the proposal from Sergey Senozhatsky for the same split
> for zram [1].
>
> [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chro=
mium.org/
>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Why didn't you take Herbert's Ack?

LGTM with one nit below:

Acked-by: Yosry Ahmed <yosry@kernel.org>

> ---
>  mm/zswap.c | 108 +++++++++++++++++++++++++++++++----------------------
>  1 file changed, 64 insertions(+), 44 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ae19e301fced7..23c4298765795 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -137,14 +137,25 @@ bool zswap_never_enabled(void)
>  * data structures
>  **********************************/
>
> -struct crypto_acomp_ctx {
> -       struct crypto_acomp *acomp;
> +struct zswap_acomp_req {
>         struct acomp_req *req;
>         struct crypto_wait wait;
> -       u8 *buffer;
>         struct mutex mutex;
>  };
>
> +/* The compression mutex also protects the output buffer. */
> +struct zswap_comp_ctx {
> +       struct zswap_acomp_req areq;
> +       u8 *buffer;
> +};
> +
> +/* Separate requests, so that decompression does not wait for compressio=
n. */
> +struct crypto_acomp_ctx {
> +       struct crypto_acomp *acomp;
> +       struct zswap_comp_ctx comp;
> +       struct zswap_acomp_req decomp;
> +};
> +
>  /*
>   * The lock ordering is zswap_tree.lock -> zswap_pool.lru_lock.
>   * The only case where lru_lock is not acquired while holding tree.lock =
is
> @@ -270,14 +281,10 @@ static void acomp_ctx_free(struct crypto_acomp_ctx =
*acomp_ctx)
>         if (!acomp_ctx)
>                 return;
>
> -       /*
> -        * If there was an error in allocating @acomp_ctx->req, it
> -        * would be set to NULL.
> -        */
> -       if (acomp_ctx->req)
> -               acomp_request_free(acomp_ctx->req);
> -
> -       acomp_ctx->req =3D NULL;
> +       acomp_request_free(acomp_ctx->comp.areq.req);
> +       acomp_ctx->comp.areq.req =3D NULL;
> +       acomp_request_free(acomp_ctx->decomp.req);
> +       acomp_ctx->decomp.req =3D NULL;
>
>         /*
>          * We have to handle both cases here: an error pointer return fro=
m
> @@ -289,8 +296,8 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *a=
comp_ctx)
>
>         acomp_ctx->acomp =3D NULL;
>
> -       kfree(acomp_ctx->buffer);
> -       acomp_ctx->buffer =3D NULL;
> +       kfree(acomp_ctx->comp.buffer);
> +       acomp_ctx->comp.buffer =3D NULL;
>  }
>
>  static struct zswap_pool *zswap_pool_create(char *compressor)
> @@ -796,6 +803,28 @@ static void zswap_entry_free(struct zswap_entry *ent=
ry)
>  /*********************************
>  * compressed storage functions
>  **********************************/
> +static int zswap_acomp_req_init(struct zswap_acomp_req *areq,
> +                               struct crypto_acomp *acomp)
> +{
> +       /* acomp_request_alloc() returns NULL in case of an error. */
> +       areq->req =3D acomp_request_alloc(acomp);
> +       if (!areq->req)
> +               return -ENOMEM;
> +
> +       crypto_init_wait(&areq->wait);
> +
> +       /*
> +        * if the backend of acomp is async zip, crypto_req_done() will w=
akeup
> +        * crypto_wait_req(); if the backend of acomp is scomp, the callb=
ack
> +        * won't be called, crypto_wait_req() will return without blockin=
g.
> +        */
> +       acomp_request_set_callback(areq->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +                                  crypto_req_done, &areq->wait);
> +
> +       mutex_init(&areq->mutex);
> +       return 0;
> +}
> +
>  static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *n=
ode)
>  {
>         struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool, =
node);
> @@ -811,8 +840,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, s=
truct hlist_node *node)
>                 return 0;
>         }
>
> -       acomp_ctx->buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL, cpu_to_=
node(cpu));
> -       if (!acomp_ctx->buffer)
> +       acomp_ctx->comp.buffer =3D kmalloc_node(PAGE_SIZE, GFP_KERNEL, cp=
u_to_node(cpu));
> +       if (!acomp_ctx->comp.buffer)
>                 return ret;
>
>         /*
> @@ -827,25 +856,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>                 goto fail;
>         }
>
> -       /* acomp_request_alloc() returns NULL in case of an error. */
> -       acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> -       if (!acomp_ctx->req) {
> +       if (zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp)=
 ||
> +           zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {

We stop propagating the output of these functions to the caller here.
It still works because ret is initialized as -ENOMEM, and that's the
only possible failure of zswap_acomp_req_init(), but that's really
subtle.

I'd rather either propagate the return value as-is on failure, or make
zswap_acomp_req_init() a boolean so that it's obvious there's one
failure mode and future changes can't just return a new error code
that would be silently thrown away.

>                 pr_err("could not alloc crypto acomp_request %s\n",
>                        pool->tfm_name);
>                 goto fail;
>         }
>
> -       crypto_init_wait(&acomp_ctx->wait);
> -
> -       /*
> -        * if the backend of acomp is async zip, crypto_req_done() will w=
akeup
> -        * crypto_wait_req(); if the backend of acomp is scomp, the callb=
ack
> -        * won't be called, crypto_wait_req() will return without blockin=
g.
> -        */
> -       acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BAC=
KLOG,
> -                                  crypto_req_done, &acomp_ctx->wait);
> -
> -       mutex_init(&acomp_ctx->mutex);
>         return 0;
>
>  fail:

