Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44ADCCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1A369001DD; Thu, 14 Aug 2025 16:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB2E9001D5; Thu, 14 Aug 2025 16:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA869001DD; Thu, 14 Aug 2025 16:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80B159001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:58:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38F5BC075C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:58:34 +0000 (UTC)
X-FDA: 83776576548.07.DC31449
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 58D9B160008
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:58:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ne9cQkKn;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.178 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755205112; a=rsa-sha256;
	cv=none;
	b=uNoQ6uFczBHKE3/coRlvhQl57HYkNTJR0hm220PlYxy5Dhszs/f9rcC540LiZGQPoglELK
	Y+on4hZOJ9cQhlmF4XsEVaWSlCB9XiqyDotkjBaJhavfRQCXYs4Yd/EDO400KE1v0GWLpj
	bmyD8ydo4fFLsZfSuOpgA4yxYdIGux8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ne9cQkKn;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.178 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755205112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/DvcecNfaCyZ/2dBsbFRg7Z15sklMK4MZS2CFAwCmU=;
	b=WGccFORnSdy3CTs0eOcDk6VCwEdOFNkHetEL3PCjuHuQ5l3LlwBU9Frb8NctXGsO8qhJhw
	4RypETDvjoWk6AXORFbOLAbLGZnUJhvx0GP6Ua1x2zSD+wy3Fo3qKLXmlgk1ovLxn8CTlr
	lata0433RztQkB9gXwfH4G0FcFwsaeM=
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3e575ff1b80so4545325ab.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755205111; x=1755809911; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B/DvcecNfaCyZ/2dBsbFRg7Z15sklMK4MZS2CFAwCmU=;
        b=ne9cQkKnxEHZeENRP776pn8oFbQe0kAImgUSv9lx0mK/6YIxFP2w64enrXOM8GV7Ib
         DZc/hHvE3tpUe7XyZKuUbFEalbZD7yvbyFRNugIyyQIiXPxAndWjeOZXFvpkZjGRE55Y
         GT8sR9yLhQD5GkTSAQemp/wnYuE55h3k/tP1f8MCplW4R5jJ0KRVHgDNcKOPfK1PssfV
         sv5uEP/cgL1UUVzPTRQstXgMkQQcZiJK0TXC2uUu/KB+vKfa4KHZLCKa5QPfUv236Y8s
         xq8xLRAikbJLto5V9HpTHSHCUb/9k6lepZ55L/nun8OY3VvBPMifi2x3apakKGHh4Y3f
         srEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755205111; x=1755809911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B/DvcecNfaCyZ/2dBsbFRg7Z15sklMK4MZS2CFAwCmU=;
        b=jh+SBYoNF3Iu5y3liyGuff+K2m2SAjPMs6fuZcVSC2pQCUVR6yRAJexxQAfu1MLaSN
         ST34wiRQpQu1rdv0INY3lqX70QFn1ZY6g3fJ5r+D4LjGdEZgmMduoIIbEYMlLRMwuCtH
         LL7lD13/HrvuuYuzvDdFYit1cWZ1UVs0fLBv/d4bGc0FWHHeKznP9HH0hl7vfK1RShiC
         HqBQ+2opeZF3G6lLnkw3Vgfq4ehPg7qTX/PZWpHojxw7mccHW5uXLNZl+ya/gdX/R4jh
         7UQsyM5qSgaCiOaDjTRr8l9UBWxR+NR45oKcH3YcJRLxdXN3yadEun+s+JFdpuLno8ED
         EJtA==
X-Forwarded-Encrypted: i=1; AJvYcCVcNucRxmrqcT1Wi3NuQAYNnVYYDSM9DwnOU/KrsYRVzoR+G22bFfKy/crevoT0D7KGEeRmY9/Tdg==@kvack.org
X-Gm-Message-State: AOJu0YzF9X1nw2DWWfJ4HPHNouitAhbEV0/pJaeI3spFQl14w4rxbejy
	/QKAWiXBobWoXMFamSbHbRC7wdXz1IfPH9A+A6gzF4vseZbNA+sWq7sy8KIcP3lmRhIZeJvlGzS
	JVsOT+NQ7yScC2e6X4Uye4SkBCwqsTW0=
X-Gm-Gg: ASbGncuRHWWi2Ni9Dv2EFUEhuZmU/i+L/5EImJYXFV4twKZNMQBqa44pE7hE9X6DQ8G
	vd1KkhIG6SyXaox8SH3Fxypqw27RbqVKmjZliUcVLGlU8HipC9bxUn+ADAVP4R1lSSjIaxVLKif
	RkvboezMlPTNL7NnJjQNY/RXHz0v7qxbD+P1FYC+rhEhjP5uNeSC9pVcwgGBZzkv2x7NRjHzt5K
	ibu4dE5uRbvCJziPEQ7d40=
X-Google-Smtp-Source: AGHT+IFgFZhJs9UqzM/o4QK5/KKQVO4RuxrGKNaiXRMHhQRYN59D+ji06hiSpUfPH25P/9nSatfEHqOb68pCzsUmkQA=
X-Received: by 2002:a05:6e02:278a:b0:3e5:3a15:93b6 with SMTP id
 e9e14a558f8ab-3e57b9d0151mr10609915ab.8.1755205111077; Thu, 14 Aug 2025
 13:58:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com> <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 14 Aug 2025 13:58:19 -0700
X-Gm-Features: Ac12FXyONKGeDobAX5KFBeSfqGfnUrGztv8b4uIaiXScw_41fTc1M5FIYAMcooo
Message-ID: <CAKEwX=PV9-QhQaSBGd67s=CVMVJne=fzajRn3=Vf+7OXVuNFmA@mail.gmail.com>
Subject: Re: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 58D9B160008
X-Stat-Signature: 4w5di8n6u1iphhc6184ttt6e6atc8ofk
X-Rspam-User: 
X-HE-Tag: 1755205112-600419
X-HE-Meta: U2FsdGVkX1+cDoUhFFZIU+WtgekXefPJIvazY8hCONQ5FZBIvvKZGayl2frKyxsFxwSL3xbD6HDrpTFyVO4vGSDvbcK7icy3B9GJPYRU/PBiU/O+2nF4VWFdS1tkCLz7qph3PKxkZwzHcf/aRahXhlobj+STA0hW3nZg3994UV6oHv0ecUrE7o8QGw6Kr6PmRYEkUMZ/0jfcfCh8d1lQXNQ7dD0G22DjbNFENUxOVcufk/s1yzRP+OFED/G2j6u+0pBN23nSlKrSb1wE4tN2uxwfbpWncjmavtt99QZR5Wn9yNfhyEYboFj0EBPc+OmGrdchpLwl9i0s23JarNr6vyzMkdq9kbX+KjBT/VsUURrAnMatmgW5JdAbM9QNPtYH76iGbQdD0VsHFw2UF6QkOctXQsUzwOUcSfWIPVa9B/D3v/uL4Wr50BVcuzW9tnzc7X5nBEfHjETzUs28XJEh0hOnYP21skSlfjFxkYIcwocinZO7QZ4/iNfxhXpF3VKom1WwGe4MmdTBq3Ig8OcHr9z0Y0cv+cSFxaFoD0f0GBjk97eUQG/8JOMPGayX3JH4Acjo5rAWhbF3MFnPvjog1A9IOafOiPtIZQNPZ+AEjNKt2zYESZHB/LkoN0lT1LCiXzY2AjhGdUNaAM/FYzbXy2iKT7nxAnhH1IdsHb/cctg7da7mv7K7SXvw2IK40S9FLXhgDXgL/df5QuLJpOSTD112PKP58VI0i38H6d44pujhrI7wmtNc9qBSJjGTAwBE92rwmaRpkabUmZ0Mf0mlS9Pyn6q+jIS/3X9Drk/HrqLcQvEgH3Jz4Fn0xWnb4d1L/1lLP4RQqveXZJNtTDtaDEVvrHP8ynGZTmPc6z+AmrLX0qGJRxeM7RfnAVPwA0f9N0mMGt9nRR2LJ+0Gi1EU7m3Zlp8mqDi7qPEsteV6W3U+NM5y2cqHGKOvlOVMHgqgDlSCuMDDUg/+RG1eCPk
 D6RP503q
 n7p8JxVwQFKeF0r+BthjysD8OHCHKzx4NZ3MHUv0NKvzyV81YnO1XUZb3ulW43D598NCBj7d8Fc5nA0WrxyFYVDFyKMGOnZQZg9KBm78tXiW565Jh4JNrttpT/xcxmrduDME8WvhNK5GchpusTn6EwyzkEQGHfXcB3x/oo3uLNuVZ9s4TYuZIVglOoh/EHRoFF0h2gEmufO4fBkj3T1NUnRziQu26N+xIRm1pKZdBHM6t/ZYPb/io/XzHqYoCyC5d1n/fqh/gAeU2ROZaaECxi2lykdNoOEfu6DDgnqHh7CZyXqJ23y5JkiMmPOqYeqzFyWVk8IHDIi5BY1i0FfDaD99qFgQ3q8ju9LK/fnc3wtubKLNb6p8F5znVfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 9:36=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> This patch sets up zswap for allocating per-CPU resources optimally for
> non-batching and batching compressors.
>
> A new ZSWAP_MAX_BATCH_SIZE constant is defined as 8U, to set an upper
> limit on the number of pages in large folios that will be batch
> compressed.
>
> As per Herbert's comments in [2] in response to the
> crypto_acomp_batch_compress() and crypto_acomp_batch_decompress() API
> proposed in [1], this series does not create new crypto_acomp batching
> API. Instead, zswap compression batching uses the existing
> crypto_acomp_compress() API in combination with the "void *kernel_data"
> member added to "struct acomp_req" earlier in this series.
>
> It is up to the compressor to manage multiple requests, as needed, to
> accomplish batch parallelism. zswap only needs to allocate the per-CPU
> dst buffers according to the batch size supported by the compressor.
>
> A "u8 compr_batch_size" member is added to "struct zswap_pool", as per
> Yosry's suggestion. pool->compr_batch_size is set as the minimum of the
> compressor's max batch-size and ZSWAP_MAX_BATCH_SIZE. Accordingly, it
> proceeds to allocate the necessary compression dst buffers in the
> per-CPU acomp_ctx.
>
> Another "u8 batch_size" member is added to "struct zswap_pool" to store
> the unit for batching large folio stores: for batching compressors, this
> is the pool->compr_batch_size. For non-batching compressors, this is
> ZSWAP_MAX_BATCH_SIZE.
>
> zswap does not use more than one dst buffer yet. Follow-up patches will
> actually utilize the multiple acomp_ctx buffers for batch
> compression/decompression of multiple pages.
>
> Thus, ZSWAP_MAX_BATCH_SIZE limits the amount of extra memory used for
> batching. There is a small extra memory overhead of allocating
> the acomp_ctx->buffers array for compressors that do not support
> batching: On x86_64, the overhead is 1 pointer per-CPU (i.e. 8 bytes).
>
> [1]: https://patchwork.kernel.org/project/linux-mm/patch/20250508194134.2=
8392-11-kanchana.p.sridhar@intel.com/
> [2]: https://patchwork.kernel.org/comment/26382610
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>

Mostly LGTM. Just a couple of questions below:

> ---
>  mm/zswap.c | 82 +++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 63 insertions(+), 19 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index efd501a7fe294..63a997b999537 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -80,6 +80,9 @@ static bool zswap_pool_reached_full;
>
>  #define ZSWAP_PARAM_UNSET ""
>
> +/* Limit the batch size to limit per-CPU memory usage for dst buffers. *=
/
> +#define ZSWAP_MAX_BATCH_SIZE 8U
> +
>  static int zswap_setup(void);
>
>  /* Enable/disable zswap */
> @@ -147,7 +150,7 @@ struct crypto_acomp_ctx {
>         struct crypto_acomp *acomp;
>         struct acomp_req *req;
>         struct crypto_wait wait;
> -       u8 *buffer;
> +       u8 **buffers;
>         struct mutex mutex;
>         bool is_sleepable;
>  };
> @@ -166,6 +169,8 @@ struct zswap_pool {
>         struct work_struct release_work;
>         struct hlist_node node;
>         char tfm_name[CRYPTO_MAX_ALG_NAME];
> +       u8 compr_batch_size;
> +       u8 batch_size;

Apologies if this is explained elsewhere, but I'm very confused - why
do we need both of these two fields?

Seems like batch_size is defined below, and never changed:

      pool->batch_size =3D (pool->compr_batch_size > 1) ?
                            pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE;

Can we just determine this in zswap_store() as a local variable?


>  };
>
>  /* Global LRU lists shared by all zswap pools. */
> @@ -258,8 +263,10 @@ static void __zswap_pool_empty(struct percpu_ref *re=
f);
>   *   zswap_cpu_comp_prepare(), not others.
>   * - Cleanup acomp_ctx resources on all cores in zswap_pool_destroy().
>   */
> -static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
> +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx, u8 nr_=
buffers)
>  {
> +       u8 i;
> +
>         if (IS_ERR_OR_NULL(acomp_ctx))
>                 return;
>
> @@ -269,7 +276,11 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ct=
x *acomp_ctx)
>         if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
>                 crypto_free_acomp(acomp_ctx->acomp);
>
> -       kfree(acomp_ctx->buffer);
> +       if (acomp_ctx->buffers) {
> +               for (i =3D 0; i < nr_buffers; ++i)
> +                       kfree(acomp_ctx->buffers[i]);
> +               kfree(acomp_ctx->buffers);
> +       }
>  }
>
>  static struct zswap_pool *zswap_pool_create(char *type, char *compressor=
)
> @@ -290,6 +301,7 @@ static struct zswap_pool *zswap_pool_create(char *typ=
e, char *compressor)
>                         return NULL;
>         }
>
> +       /* Many things rely on the zero-initialization. */
>         pool =3D kzalloc(sizeof(*pool), GFP_KERNEL);
>         if (!pool)
>                 return NULL;
> @@ -352,13 +364,28 @@ static struct zswap_pool *zswap_pool_create(char *t=
ype, char *compressor)
>                 goto ref_fail;
>         INIT_LIST_HEAD(&pool->list);
>
> +       /*
> +        * Set the unit of compress batching for large folios, for quick
> +        * retrieval in the zswap_compress() fast path:
> +        * If the compressor is sequential (@pool->compr_batch_size is 1)=
,
> +        * large folios will be compressed in batches of ZSWAP_MAX_BATCH_=
SIZE
> +        * pages, where each page in the batch is compressed sequentially=
.
> +        * We see better performance by processing the folio in batches o=
f
> +        * ZSWAP_MAX_BATCH_SIZE, due to cache locality of working set
> +        * structures.
> +        */
> +       pool->batch_size =3D (pool->compr_batch_size > 1) ?
> +                               pool->compr_batch_size : ZSWAP_MAX_BATCH_=
SIZE;
> +
>         zswap_pool_debug("created", pool);
>
>         return pool;
>
>  ref_fail:
>         for_each_possible_cpu(cpu)
> -               acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> +               acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
> +                                 pool->compr_batch_size);
> +
>  error:
>         if (pool->acomp_ctx)
>                 free_percpu(pool->acomp_ctx);
> @@ -417,7 +444,8 @@ static void zswap_pool_destroy(struct zswap_pool *poo=
l)
>         zswap_pool_debug("destroying", pool);
>
>         for_each_possible_cpu(cpu)
> -               acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu));
> +               acomp_ctx_dealloc(per_cpu_ptr(pool->acomp_ctx, cpu),
> +                                 pool->compr_batch_size);
>
>         free_percpu(pool->acomp_ctx);
>
> @@ -876,6 +904,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, s=
truct hlist_node *node)
>         struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool, =
node);
>         struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool->acomp_ct=
x, cpu);
>         int ret =3D -ENOMEM;
> +       u8 i;
>
>         /*
>          * The per-CPU pool->acomp_ctx is zero-initialized on allocation.
> @@ -888,10 +917,6 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, =
struct hlist_node *node)
>         if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
>                 return 0;
>
> -       acomp_ctx->buffer =3D kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu=
_to_node(cpu));
> -       if (!acomp_ctx->buffer)
> -               return ret;
> -
>         acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0=
, cpu_to_node(cpu));
>         if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
>                 pr_err("could not alloc crypto acomp %s : %ld\n",
> @@ -904,17 +929,36 @@ static int zswap_cpu_comp_prepare(unsigned int cpu,=
 struct hlist_node *node)
>         acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
>         if (IS_ERR_OR_NULL(acomp_ctx->req)) {
>                 pr_err("could not alloc crypto acomp_request %s\n",
> -                      pool->tfm_name);
> +                       pool->tfm_name);

Is this intentional? :)

>                 goto fail;
>         }
>
> -       crypto_init_wait(&acomp_ctx->wait);
> +       /*
> +        * Allocate up to ZSWAP_MAX_BATCH_SIZE dst buffers if the
> +        * compressor supports batching.
> +        */
> +       pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
> +                                    crypto_acomp_batch_size(acomp_ctx->a=
comp));
> +
> +       acomp_ctx->buffers =3D kcalloc_node(pool->compr_batch_size, sizeo=
f(u8 *),
> +                                         GFP_KERNEL, cpu_to_node(cpu));
> +       if (!acomp_ctx->buffers)
> +               goto fail;
> +
> +       for (i =3D 0; i < pool->compr_batch_size; ++i) {
> +               acomp_ctx->buffers[i] =3D kmalloc_node(PAGE_SIZE * 2, GFP=
_KERNEL,
> +                                                    cpu_to_node(cpu));
> +               if (!acomp_ctx->buffers[i])
> +                       goto fail;
> +       }
>
>         /*
>          * if the backend of acomp is async zip, crypto_req_done() will w=
akeup
>          * crypto_wait_req(); if the backend of acomp is scomp, the callb=
ack
>          * won't be called, crypto_wait_req() will return without blockin=
g.
>          */
> +       crypto_init_wait(&acomp_ctx->wait);
> +
>         acomp_request_set_callback(acomp_ctx->req, CRYPTO_TFM_REQ_MAY_BAC=
KLOG,
>                                    crypto_req_done, &acomp_ctx->wait);
>
> @@ -922,7 +966,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, s=
truct hlist_node *node)
>         return 0;
>
>  fail:
> -       acomp_ctx_dealloc(acomp_ctx);
> +       acomp_ctx_dealloc(acomp_ctx, pool->compr_batch_size);
>         return ret;
>  }
>
> @@ -942,7 +986,7 @@ static bool zswap_compress(struct page *page, struct =
zswap_entry *entry,
>
>         mutex_lock(&acomp_ctx->mutex);
>
> -       dst =3D acomp_ctx->buffer;
> +       dst =3D acomp_ctx->buffers[0];
>         sg_init_table(&input, 1);
>         sg_set_page(&input, page, PAGE_SIZE, 0);
>
> @@ -1003,19 +1047,19 @@ static bool zswap_decompress(struct zswap_entry *=
entry, struct folio *folio)
>
>         acomp_ctx =3D raw_cpu_ptr(entry->pool->acomp_ctx);
>         mutex_lock(&acomp_ctx->mutex);
> -       obj =3D zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buf=
fer);
> +       obj =3D zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buf=
fers[0]);
>
>         /*
>          * zpool_obj_read_begin() might return a kmap address of highmem =
when
> -        * acomp_ctx->buffer is not used.  However, sg_init_one() does no=
t
> -        * handle highmem addresses, so copy the object to acomp_ctx->buf=
fer.
> +        * acomp_ctx->buffers[0] is not used.  However, sg_init_one() doe=
s not
> +        * handle highmem addresses, so copy the object to acomp_ctx->buf=
fers[0].
>          */
>         if (virt_addr_valid(obj)) {
>                 src =3D obj;
>         } else {
> -               WARN_ON_ONCE(obj =3D=3D acomp_ctx->buffer);
> -               memcpy(acomp_ctx->buffer, obj, entry->length);
> -               src =3D acomp_ctx->buffer;
> +               WARN_ON_ONCE(obj =3D=3D acomp_ctx->buffers[0]);
> +               memcpy(acomp_ctx->buffers[0], obj, entry->length);
> +               src =3D acomp_ctx->buffers[0];
>         }
>
>         sg_init_one(&input, src, entry->length);
> --
> 2.27.0
>

