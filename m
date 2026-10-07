Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3D46CA6004
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 21:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879596B0088; Wed,  7 Oct 2026 17:01:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803996B008C; Wed,  7 Oct 2026 17:01:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA396B0092; Wed,  7 Oct 2026 17:01:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C85C6B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 17:01:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E14A1603AD
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:01:42 +0000 (UTC)
X-FDA: 85297051644.19.5379029
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8993E40010
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:01:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hIcDg1uc;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791406900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dl16HxAgUL00IPU8ek1WsOB+q1DZ4i3Hue7YA0SIFcI=;
	b=hiB0rhyVEsanhlO1rdW2fKFm5sXyQdz/kA66XOf/aYXPUJIqT9X5n14Rv1ASe4oc/TPIQB
	ah2/22mG46PzO2KcFpvuwODFv+X3BuGNAQ5GSgQUYl4WzsCUUaCLnUt0BR5EosDVLQM9Yf
	/wWuosQ6iaoFrJA3fdwsnEQLXj3Wf+Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791406900;
	b=zrMAiEKhz8GMZAUcZI+UvS4aVZVABbszX8iaPTnz8Y0Qv1gxEKnpQkySJfhGgTSRxRB3Z4
	l8wSIhV2YFYKoCj+VoqI1xM+N7qdjI9C1ZUQ93aawXmizORYd2Glryaf8z/7Tn5iUIeBm5
	8dqfHdwuPLMcCVxP8WexupTxVAvLs7Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hIcDg1uc;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7450743FD1
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BECC1F000FF
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791406899;
	bh=dl16HxAgUL00IPU8ek1WsOB+q1DZ4i3Hue7YA0SIFcI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hIcDg1ucpxd0ocFqloDfr863lapn+psrW4MYxKrAHkZ1vytjZeHhPcBDzBq4OFI5e
	 9cVp0/WrnYh/010NUuJ11quYedmT+iNh2K6C8cErd5drBE2o40kaXya+eC08yNoBfC
	 StecFxI0+OY6tk2ywGygEwGAQoulOSdh8UVPiwBM1ZW69XpUrKSGJ80US+j/6mv9TJ
	 NXe/OirguGaeVP9V01rOnexehkFD2WbkHgyE+NJHSQ/gBd2tWBumYcQ11Xu/iSJb15
	 Ea2NX8ELwbrY4MIbWMJ6ueveuRhEkjzkKk5hVKbtY7WWGM8HbvhI48w0MgKKfdTMH9
	 dS2GIkY91/GmQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c169ae1cb26so7387566b.1
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 14:01:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByALhPYtZDGe7UYYonYWJz+V9oQVYfzbVCPA+AWkb24DiXA0niu6a2bML0fkInc1HISCj4nkgixMA==@kvack.org
X-Gm-Message-State: AFuF++n/z5VKCuQzSPNz3n+sNMb1ACIithEm+kGp0jD0ZI5w0Ij7XW3w
	p5s7UK3tW9I8w3Qe8fpbcLoRhJzfCpeeuMF5Sz6IMTMU1mSpbyoWmNJ3s00qBWQtiXkMNjMqQvU
	oxWoJgnenw3QMTffBNR60q+sNebeB1iY=
X-Received: by 2002:a17:907:c318:b0:c29:4b57:503e with SMTP id
 a640c23a62f3a-c3191980358mr35259566b.1.1791406897277; Wed, 07 Oct 2026
 14:01:37 -0700 (PDT)
MIME-Version: 1.0
References: <20261006002307.2669023-1-usama.arif@linux.dev> <20261006002307.2669023-2-usama.arif@linux.dev>
In-Reply-To: <20261006002307.2669023-2-usama.arif@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 7 Oct 2026 14:01:25 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPm4B1_wtAUMeSR9PQ5ja+kJz14Ub7MCuJit_NSH2DQsQ@mail.gmail.com>
X-Gm-Features: AclHuK-Q3mzr7L7OrxFyQiTbmZzxOuADEUhJwA1scGB8YD5sCzYWMRoQUzHZsT8
Message-ID: <CAO9r8zPm4B1_wtAUMeSR9PQ5ja+kJz14Ub7MCuJit_NSH2DQsQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: zswap: use separate compression and decompression requests
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, terrelln@fb.com, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, senozhatsky@chromium.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8993E40010
X-Stat-Signature: 3fooqkoh8zm9894oegp86h69xe317dqc
X-HE-Tag: 1791406900-869065
X-HE-Meta: U2FsdGVkX1/NqGxtBGDxVHWW85xRmU++c4K6lytCo6PIb0bONcas4hlen9WP42yKsL650HUj6sM54vZMWtknSfE9KJrXa2wcQ0d2lUt4RMz+MW66DIYma1Vqzky5PC3Ga6BU9NwnFF6Fsejqqk8rFtPdM8sv28V3yflwrWxV94sEPokcMUUaBxQsyIakfkKuvNKIFrz59/vM6badi5L8LjPuQIpx4fQnOEO4HRTcrF/sznA+/IUKVgj3H9DU8dVD7UWzyAY+XyFCuIBs6DhPF4idfF2aeqjFYOXtTn8RFzHnnwanPsbd0SefEBRrTQs5I0xMv4uAMQb+FiT/HpDWeNUYx5t8k9OQ3frySRkPGyi5LEs2VFLgoJphBcLSfDV3Cstx0gusVIFmuXfB3882WMgWF4iFbzgH0YxLP3F2lPKGw7v5TKbDfM/pcRSccu6sC7MjdcDAOks0R1jxpW8Dmjmqe3edRy2/6B0zzoMqUDMHSKxqioz5ILiAPHOxNjnTc1RtmBPBCTGVMA0J6KBGRYdEsUWQKK0RFYRyJAHmgNN9tzp/XWraMdiqkh5PhSsuqvxNQ7jKEI+0W3RKv6uy4HOHaoux038F1Q5B35PZ+2aU1MihGzdqCYSvfcGCSOh2MDDXFM4jOyPLh24d+K4/TjeOMiW9lpXU2bwsb7uETxFYPuTl43/COe4yg+gCyfeSiPKQxcK20h+lJnb1/5VHuTXpenbzjrd868x1Km7BP3WO0O8GlYVkqSI4q5Az3EP1mILI70oDnU+nqpIqA0tV57/9N7WeMX86qdhQEP0PUsR2Xhy5O7jkeCMleqs1VhiIciBtJjs1ITqEa9WgAJTawqSuDkxNjqvxacqF3fDiJc6c5V7li/alaO8VEHHVplVVO3GG2UwZCznLFKrqa9grwN9wvKggMwXUzU+iUyijfO2f7vSeVXwyKPecq16yetJeF/y/GzyXxuuywUKGSN3
 hpA53qgQ
 T5d9I019L3Wi0e5ivym4NO1+LGLzS8UiVrjlmW9gkjOTXTY0bGk6l1Wubx/6gi1797CKQ0XkmnfMAdmz73HGjhZck44hZituATCqNV8Qcn0P9BMALTXR7PYgpyyYdovwsQhcEqQgSj9A5e2O1+WtoeDYsoFMBTAZ1/kTEiBshjPbo3REY/156a6kbwYw6vCjJEnuoQAFzgLj0Sc5E2fq269Oo57HLAFOLIYVpg1eQWYdJv68q4jFs8TkEpbNedpFrV0Ke+Fgn/qo7SV0hL7KHb9VEV5DY684xQ5IQYnVvODCtiG1ZoeopaFj2fq0IVgubzeoDsSC0s7497qE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 5, 2026 at 5:23=E2=80=AFPM Usama Arif <usama.arif@linux.dev> wr=
ote:
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
> compression. The two requests can share the per-CPU transform: no
> in-tree implementation modifies transform state while (de)compressing,
> and shared codec state has its own locking.

I am a bit uncomfortable with this. If future changes modify the
transform state while (de)compressing, it may result in nasty bugs.

As for the buffer, I would also prefer some protection, but I feel
less strongly about this. For example, we can put it inside
zswap_acomp_req and not initialize it for the decompression request.
Alternatively, we can have an intermediary struct that contains
zswap_acomp_req + buffer, and use that for the compression request.

> Loads can still wait for
> each other on the decompression mutex, and stores still serialize on
> the compression mutex.
>
> This follows the proposal from Sergey Senozhatsky for the same split
> for zram [1].
>
> [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chro=
mium.org/
>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/zswap.c | 89 +++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 52 insertions(+), 37 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ae19e301fced7..54187b1ef751d 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -137,14 +137,20 @@ bool zswap_never_enabled(void)
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
> +/* Separate requests, so that decompression does not wait for compressio=
n. */
> +struct crypto_acomp_ctx {
> +       struct crypto_acomp *acomp;
> +       struct zswap_acomp_req comp;
> +       struct zswap_acomp_req decomp;
> +       u8 *buffer;
> +};
> +
>  /*
>   * The lock ordering is zswap_tree.lock -> zswap_pool.lru_lock.
>   * The only case where lru_lock is not acquired while holding tree.lock =
is
> @@ -270,14 +276,10 @@ static void acomp_ctx_free(struct crypto_acomp_ctx =
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
> +       acomp_request_free(acomp_ctx->comp.req);
> +       acomp_ctx->comp.req =3D NULL;
> +       acomp_request_free(acomp_ctx->decomp.req);
> +       acomp_ctx->decomp.req =3D NULL;
>
>         /*
>          * We have to handle both cases here: an error pointer return fro=
m
> @@ -796,6 +798,28 @@ static void zswap_entry_free(struct zswap_entry *ent=
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
> @@ -827,25 +851,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>                 goto fail;
>         }
>
> -       /* acomp_request_alloc() returns NULL in case of an error. */
> -       acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> -       if (!acomp_ctx->req) {
> +       if (zswap_acomp_req_init(&acomp_ctx->comp, acomp_ctx->acomp) ||
> +           zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {
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
> @@ -866,14 +878,15 @@ static bool zswap_compress(struct folio *folio, lon=
g index,
>         bool mapped =3D false;
>
>         acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> -       mutex_lock(&acomp_ctx->mutex);
> +       mutex_lock(&acomp_ctx->comp.mutex);
>
>         dst =3D acomp_ctx->buffer;
>         sg_init_table(&input, 1);
>         sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
>
>         sg_init_one(&output, dst, PAGE_SIZE);
> -       acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SI=
ZE, dlen);
> +       acomp_request_set_params(acomp_ctx->comp.req, &input, &output,
> +                                PAGE_SIZE, dlen);
>
>         /*
>          * it maybe looks a little bit silly that we send an asynchronous=
 request,
> @@ -885,10 +898,12 @@ static bool zswap_compress(struct folio *folio, lon=
g index,
>          * existing method to send the second page before the first page =
is done
>          * in one thread doing zswap.
>          * but in different threads running on different cpu, we have dif=
ferent
> -        * acomp instance, so multiple threads can do (de)compression in =
parallel.
> +        * acomp instance, and compression and decompression use separate
> +        * requests, so multiple threads can do (de)compression in parall=
el.
>          */
> -       comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req=
), &acomp_ctx->wait);
> -       dlen =3D acomp_ctx->req->dlen;
> +       comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->com=
p.req),
> +                                  &acomp_ctx->comp.wait);
> +       dlen =3D acomp_ctx->comp.req->dlen;
>
>         /*
>          * If a page cannot be compressed into a size smaller than PAGE_S=
IZE,
> @@ -932,7 +947,7 @@ static bool zswap_compress(struct folio *folio, long =
index,
>         else if (alloc_ret)
>                 zswap_reject_alloc_fail++;
>
> -       mutex_unlock(&acomp_ctx->mutex);
> +       mutex_unlock(&acomp_ctx->comp.mutex);
>         return comp_ret =3D=3D 0 && alloc_ret =3D=3D 0;
>  }
>
> @@ -948,7 +963,7 @@ static bool zswap_decompress(struct zswap_entry *entr=
y, struct folio *folio)
>                 return false;
>
>         acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> -       mutex_lock(&acomp_ctx->mutex);
> +       mutex_lock(&acomp_ctx->decomp.mutex);
>         zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->=
length);
>
>         /* zswap entries of length PAGE_SIZE are not compressed. */
> @@ -965,15 +980,15 @@ static bool zswap_decompress(struct zswap_entry *en=
try, struct folio *folio)
>         } else {
>                 sg_init_table(&output, 1);
>                 sg_set_folio(&output, folio, PAGE_SIZE, 0);
> -               acomp_request_set_params(acomp_ctx->req, input, &output,
> +               acomp_request_set_params(acomp_ctx->decomp.req, input, &o=
utput,
>                                          entry->length, PAGE_SIZE);
> -               ret =3D crypto_acomp_decompress(acomp_ctx->req);
> -               ret =3D crypto_wait_req(ret, &acomp_ctx->wait);
> -               dlen =3D acomp_ctx->req->dlen;
> +               ret =3D crypto_acomp_decompress(acomp_ctx->decomp.req);
> +               ret =3D crypto_wait_req(ret, &acomp_ctx->decomp.wait);
> +               dlen =3D acomp_ctx->decomp.req->dlen;
>         }
>
>         zs_obj_read_sg_end(pool->zs_pool, entry->handle);
> -       mutex_unlock(&acomp_ctx->mutex);
> +       mutex_unlock(&acomp_ctx->decomp.mutex);
>
>         if (!ret && dlen =3D=3D PAGE_SIZE)
>                 return true;
> --
> 2.53.0-Meta
>

