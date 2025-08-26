Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B669CCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 03:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 093788E0092; Mon, 25 Aug 2025 23:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044498E0090; Mon, 25 Aug 2025 23:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C1A8E0092; Mon, 25 Aug 2025 23:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D537A8E0090
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:48:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7DC28845E5
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:48:23 +0000 (UTC)
X-FDA: 83817526086.19.4A17E3B
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9C2862000A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:48:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kDBZiSd7;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756180101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jSD8VMG9zZQ8ShbiUSnWktqc4t1GwqQcLAuPm99uK2A=;
	b=jR8FZZknR51IYzKxQu9lcsm7nIdMrg9gA0EIOvdOLmE2RIGIUKiSOrX39YODjT8lhrHLYh
	qA0Q6kfURGWZHSRkl6KoiPWx/b5nDXYwqCmzDLbgaD/xKoLcYrIRhHYbxp1bFvXkxsoo98
	6Q8KCr/ZAf8H1S+GNEn7Qp5mED7BHCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756180101; a=rsa-sha256;
	cv=none;
	b=oGU7Dw6gfgRv5K3HgsoHtAvoCtVqZoS1VH6G8NvLhHrCjAFceKjxyYkozSylhCTex6YmEJ
	EKyKOAxdmNFNU15mL3VBzZvApTMJaJwSkirCs2s4/WNCmcOX3poY7MRQZiWfZX9DOzLqNx
	rs+gh7xnwm5uAiwNLSAmSRFJtdWztGE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kDBZiSd7;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7e8704c7a46so613358885a.1
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756180101; x=1756784901; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jSD8VMG9zZQ8ShbiUSnWktqc4t1GwqQcLAuPm99uK2A=;
        b=kDBZiSd7oRlWnQ3nmuybcFEZcw76KAMpRXON4CFE62U9sY5ms5PpOC1fT47+n2a9xp
         lRf3bADt8W7WSyvAsiUeOIpHvTlNmyNOCGPLzrgoDKLOqi7JUBSTLGnuBu0f8TiPAL4/
         05bCxjmB0gP4ovTQr/WXIJRRSga5hp3wHhLAzhEaIZcqFYTUTDehXd0tOuM5E8IGXxZe
         HsvLY3AUMmFVJHvOCAVBHlnbhyAOUJKELGbhs3LR8RkkHFSVu1vQReCjmxfXOIt8OdKn
         gxSHVdjbMs2cK5jYxzg9iZQiGgbTFQPcm8Ipm94DechnLgBFufjBMUM1TJIveLzqJU2A
         kCUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756180101; x=1756784901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jSD8VMG9zZQ8ShbiUSnWktqc4t1GwqQcLAuPm99uK2A=;
        b=gVaV7YAPkfoZy0v0soXGWy81NAjp403I1CPjxYTocRK7hJ4lBHHORDb4VkSa3jt54t
         +J7chdCNW16f6wHz6cYEv/hW7Qv1se4rI6YNKhUj4X2xhZQmPgCN5+JzDIAF26pjzqKc
         vNOvroMmzxsZplelVNWiW3gkOeMyBIPhr2P7wJBX2pWhLUyevyqJmYzv5RsoKyPrAnFD
         0MSWhceALzB0QeJL/9Vhddu4l1OIDJPRViQIoWP5xl6nUSYzW2dIrtQuNeA9wvLdscOr
         YMl3OVOJSGxSBwjvBncXhjbz1x+Bo4IMq0zE13GJ4sXC0e+Wr2hquGm12gyFpFiP4xNV
         yq4g==
X-Forwarded-Encrypted: i=1; AJvYcCX8Gjcbn7AFT5N8kmkk8djkvebRqvX0jxSABR2jVCC2lnP9OaFUyGyfSGuMF1O2i5uX7zPKDcL3zQ==@kvack.org
X-Gm-Message-State: AOJu0YysF/B6p274/muP2SQF+5Cug+FsLLe84PIeQ6ChfosxmlkbH+sA
	5HQIaIMLnf1I5N6Wdp5HfHOdUaDLvV+SSZgo/VSCtJjzkmj5P+pW5Y/0DfO/kHZfNgA9dZgBytS
	3vZFXksDRKv3aJcRpJrBOC1mwbIMlOcg=
X-Gm-Gg: ASbGncu8DXmBFW0HaPboLKYhG3UTEWcN5C2AzaXInQDUqXuNYRSjUBwE8pSErzKza14
	mK+AiNqbjjSJ4BYxq8UzMp2tC6zqrST34/OOqJXO62rYhvbnxONt/NwZ2RWYyCQRlJBBmtP8+3h
	fIIkznq8aZSG4jtw11aP/NTN6XIdOTDu1W9ukl6kVs/WC6vUKrJjT4IdtCRoZu0NU+1BAiHvHp9
	GCIwQE=
X-Google-Smtp-Source: AGHT+IHogeU0tcf8N9/98D2LKMRmBjSxLonp2Qk4eM+QiDMFLzmDfhCSs2TqzN4cavgW351hLtr/C3wuwPteFCroeM4=
X-Received: by 2002:a05:620a:28c4:b0:7e9:f81f:ce7a with SMTP id
 af79cd13be357-7ea110daa7cmr1436407685a.80.1756180100659; Mon, 25 Aug 2025
 20:48:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com> <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250801043642.8103-23-kanchana.p.sridhar@intel.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 26 Aug 2025 11:48:08 +0800
X-Gm-Features: Ac12FXzFSiQppO9L-3PlARCfK6bU14dUhFnHEYsWxbGYtLIBoR6DEP5l_M3xqew
Message-ID: <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
Subject: Re: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	usamaarif642@gmail.com, ryan.roberts@arm.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9C2862000A
X-Stat-Signature: sa68rb3wrnnnup4z65kutfemg7e4he84
X-Rspam-User: 
X-HE-Tag: 1756180101-189375
X-HE-Meta: U2FsdGVkX1+Ay1lu7C9Zlpc2UGtgs/GbvioHHcb2QNYjB2i+CGOJnTC1e9sqyvuyFxMCGdw4HHZwFhj+jJOjCbE4AAhdsKzr8o3iGvBu5dLHb1QJfSjMP3FW2DjdD58IxX5UYULPs9cW/97BYw+iBY60OzRcvjrMlv2h2K8ME/Axr8c0TKOGh9A1chgc1o92LMPjrT6KWYb4TIIdsBLEFB9KDi6P6YBwMNod9Jn6WEO5KpYyKMg3iHtU7HFHCuY4FOjjcMTyTDZmjFNYRe++Cj9vTp4R7saajqmpA82zaLK9TQZyKAEw3IHgHld60+J0gVikh+83ebKYMT8/78d9mWvI7jcO4P6CAUEkPfolbfqguv39mxyjZJ33pnQMCRG5arKdjR1JfgNVxC7X3l9xkeFaYbyDQMTznvkWFZ6g93UCDQ4XdoiimMjAqQvlElTtVA2B4kmW8UMAECphbgxV8YyzHwdk9m462A2YQUG8TD0Pvs/XOH1uMt1CRjQ+/tRXMHoGTd5AzTUuRA7lpnraBsg7b+Qrzif9VSgXjUKsr5s1RC+G32qHcRQQ6WhABjkXx79wUQD2dDaCkCXtJ5rWOOARkhImsLK1gt/HJSJ+cSRCmjCz6jf35MmEPKD9rBSs3DAwejGubMVrck/VHyHpjvS2ExVW0YcTeKv7YBcxFLfqLTXN+MWCHHZJZP7r0bp9FV0D5uaIiJhS8Ko7vqP0bvpWepjzUr9Tg5TQISfaN+nLkDXuDKedq+OKw6TmYuT+7NknxxBLLRQKeUYwo13NuWQ5PX/+aOOn1xE8+VS0wtuK4IShsjkqBHvSAyziO5ewUIsLAqdVCVHsI8nbcxdrFo8MRxasBS2F1Bx8PYz+7Ya+f+YnVCYlfv/NPPXMJUgWVCUNmSocGQiE6gSihPqDEXyDNEXhyQS0eJ4hoKWwBFxgkMPzGZcZklDloHvdHy+mvRwAX6hLyBaobQajiLJ
 MuTeXsBv
 q9fb1qeI48ErlJ+7xYOtviDDJtCNstNJISgdT7w/fdlf/Flhtv02m8Tlyv0HWF810UemVOMLIMoR+eCaychGhbQoZwCTSoAp2J57Y2VKTkbf9yfGyVQUjKX6bGTTUFOMug8WkzJgmatIVWmPC6Soqka0Axu5/2hAsXBqQLNo69t4r06jmfPvyb7VHiwtzog0zvt+5HKhOZwGA73C1E0VajvW3nVUev7MhzGXGNgqYZPGzq/Hv0TO005u8fj/uz+qsrremgEyw7GUxLc7LeRxglRnpgOirfNdGRUErHc03H6pxq3noj3pYRXkw/evOiTVXPjwVUZVysr5V1FPe+C39liSss03pOEw2MQ5XRCkmx+rU/Uk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kanchana,


[...]
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

It=E2=80=99s hard to follow =E2=80=94 you add batch_size and compr_batch_si=
ze in this
patch, but only use them in another. Could we merge the related changes
into one patch instead of splitting them into several that don=E2=80=99t wo=
rk
independently?

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

It=E2=80=99s hard to follow =E2=80=94 memory is allocated here but only use=
d in another
patch. Could we merge the related changes into a single patch instead of
splitting them into several that don=E2=80=99t work independently?

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

Hard to understand what is going on if related changes are not kept in
one self-contained patch.

Thanks
Barry

