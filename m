Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED861CA0FFD
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 23:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BF956B0008; Thu, 28 Aug 2025 19:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070E06B000D; Thu, 28 Aug 2025 19:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1B06B002A; Thu, 28 Aug 2025 19:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6EDC6B0008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:54:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0441A1191A7
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:54:33 +0000 (UTC)
X-FDA: 83827823268.27.518C887
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2D622140009
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:54:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qn39xdVx;
	spf=pass (imf09.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756425272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywp5khp3KpGpdpq9ocHmTVlcpn3e5Ai0bpi4D2HSbEA=;
	b=Fua8BjmmgLg4GukaqKS+PPwtV6bMn92tkG4B2PFa5b7NPOusCdKof6V13WXJZaRqib793X
	1KMELalTSsfd2u/pRY/4ACH12ZAUOX227Fw2qAahLC1ec+Z7pShRWaI25+TK1SY5hINQyh
	qeNZmVHjWBDDSfAWheamXgFJabBQzXY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Qn39xdVx;
	spf=pass (imf09.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756425272; a=rsa-sha256;
	cv=none;
	b=GdKx46iqoBVrx6w54gN3Vck2r69Ub/4JMlv9BXzE/4nKDlGLa27St/XOE0PBF5Xb3A5tNY
	mTWTBVHet41eZE0O6JN2vud7Yx5ZzI4IKJVq5jYytRF6TsDEhgS6XWEgD4emwrUI+esFcM
	OcyZNdhKT5pL7kuPe/QqglPfKAGL6yg=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b28184a8b3so17574491cf.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756425271; x=1757030071; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ywp5khp3KpGpdpq9ocHmTVlcpn3e5Ai0bpi4D2HSbEA=;
        b=Qn39xdVxfWVDUVQrSm+2mIcu8mxsjnJ/SzxdF/ZK/Vb8KT15UscsVzOCM1y9k8wBPs
         9vIIfGiPgnVB8OuYGtzs/YyTV1uk3qvI7Ygq7HCj2tXAvv/OweC3DnEzYWbP+jQ68kqr
         5asu4j/25j8RHb6ksgceiJoLEPmJS4GWVuftr+ssAxSvjE0fvU0MTECcZPk/gcHB8gli
         brabcfOjYvZkTyfRQQ0tfgWrD/vnpp/YM4MBA3EbCSVETpAt9OmbejPL/sDmUQOQgio1
         M8YaZ6r9JvwXWceC543DDNQYmnLqkZYdVtWvfIUabIvvyM7hEXtxGjwPjUdqZBxR2jP7
         ns7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756425271; x=1757030071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ywp5khp3KpGpdpq9ocHmTVlcpn3e5Ai0bpi4D2HSbEA=;
        b=jis0GAOwCl52DO/v/kkd1CeHd5o4J6j9eD9oF/ZW/ZMhI0m3gUDPnDUoW0oZnOBv3c
         cqSBjaLyQca9WhkOgTiY1VTgat0JCQ5Phj8rbGvnlaFuRRHlSqzRt76yuHb9imrhMc2h
         gRCfieTcgWUD/MaFo14B17hcUXtbWekX5pvLqrERRlHnUc58rJYd7n3oYnTZq9UCqsAY
         ldDNHP/BknGxzF6DuYWIChxRuDD1otr0SWL9QvsoKEbb5XzkRC73kKLXNswxjVrNCNFD
         1PVAtWmLAbUME+PYfw6IdH8zsSpvlAr9jPN0FCaZ1T0ee97aZpzZeyWixrC3ubsgFzuo
         Fh7A==
X-Forwarded-Encrypted: i=1; AJvYcCXuhanHbrSyx/4Gm7qEk6JVkefOIfWvnvIIjgPDegSQqQ4+JbqR7tfYw7CCp/EJJkZGLXJTU6bRBQ==@kvack.org
X-Gm-Message-State: AOJu0Yw756d9rOLhiFufPebv00oFFt7Py4MvEsEgAHA6PI73jkINaqYC
	XRWN10g91YD59z3pAO5Dr6ov9q3xMBJpx24+Sp63lJLQF5ylZp4OjYtauqJi1P/ZYbtOKwt4bHN
	ubLUQ1G+zphhsDci7E+Lqy+sb7HuR88c=
X-Gm-Gg: ASbGncv7MCWeHuVrUNdyJylTZIYv3OYgcbode8GRRc7ZJ0TRRGp6KDtUVGMStxKb4On
	zlirLB/FDR13yQ90W+4G9TAbnV6IaixuFZW18LwQh1ApazmS3nSxTEA7tVjHPFm4P63f4gjXINM
	+I0XLkbwa6GpY9f28L9xVjtfL/KErVVeyFDliXD7SfC5aqUNYL2O5yLIkqeGsZ8Hfp4ayT7wqz+
	T4bcZycJj3if79Wjg==
X-Google-Smtp-Source: AGHT+IFx1bCdet3TXgM/yuGL1gCygeo78sYjNJ6iHciVjPmaRNEDp0QbZjfxfvz+2gGiwjHgQPA9Qv79Bjp1hQIzq1I=
X-Received: by 2002:a05:620a:a201:b0:7e9:fb98:f27e with SMTP id
 af79cd13be357-7ea1107f044mr3049024585a.58.1756425270808; Thu, 28 Aug 2025
 16:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com> <20250801043642.8103-25-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250801043642.8103-25-kanchana.p.sridhar@intel.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 11:54:19 +1200
X-Gm-Features: Ac12FXxu-APcLv8VU8AYKc0OPlj6u_0o-Gu5UmAhfYadfpGbK1JQlq4O_4nF6-Y
Message-ID: <CAGsJ_4xMYUHo_SRc=1jgP6jMNosA_NP3HCitSMKwx=5ScJ0Cng@mail.gmail.com>
Subject: Re: [PATCH v11 24/24] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
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
X-Stat-Signature: f7pn65w4jng3otg79hgcjda55rcp6s4q
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D622140009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756425271-535784
X-HE-Meta: U2FsdGVkX1/mDoozBz5xYPm03HTMZVw2BLG68f8OA3cGMp7W1aI0cx0dFXek/NWBqFL2BbhnRnaw+5CFWlFNG2HpUWoJf48NwAGqzHMujWwrckV908uTTCGYYMgbkInZysMG6mWHLQeD2PcQYTUaSJyBuiRCNEw8xrc4h4aIpuG0HFVpPRZdXOiA7Vl5doUoKlst6pBQbvFVRxB5YCybEgyKA8WVtiEYIF56gqk7gox4HF/Rdt99ybl5OHYAYfTdBjX3DUwJDrYVahLhoMj/L+AgkqYfTPCpu6syneYUM4dnT+D4TuIhPk1L96exHf0UPkBr1N5IDGLJ3h4t4FcU/bUBMVNiiQQMU8Tr2Iw6M5ox7bor1mU2CF6uLJlM7xjLPtyH3l8DXn8S2GH7PDtiQO/FmMoET+iENgIFRVspOUH8Ya0d/c3yt4WDGc2oR5qQu5b8+/Gs6xJ3opuhT8xJ2Q6GUpFyIghtSgS7wrLnu+M3qEeDQUqBojuBYuPB30arbAQGCy70Pdz8382z/HlsQc3qb0cZxxWFmWUuK9ekIAJsMqJwqePItMDnSSc7ALPhqzHo47eafCCdfeS3aGvsxpImIqR5QIinCE+T51sWZEiaih7Te0o7wzdOHNLEdNGSr1Bfy5UjJpzRt3FTsMim4nsSSyykz8U+VwiLzLhF0QWzKIY1NTk/CEharP8r9IAxpmoypCHuHeYKrOzDTSS8ZNQvqzSsnFHu/7loD07F7Hr5jAZcro1kd0/R3LpiOUAH3UsBDl/H3yQQo6gZ2fbaCMTWHaq9pRCHvuMTecxAPCAqW22o+0Vho/gSkG20ga6EcP3zIjpC075Mv2O9LwpCCJnmO6kjmqbTfgr43CyU3JU7+ZHJm2krP0BDIlJx3YYqPgRYv+6qjLynmDeCtlYMWg1uNREOVuNTbIPeYo+LIgvB7XL1P2XNlyC78MRBdbNId63TTeagKt7jSWPetN7
 0Qy9r+HQ
 toq5yBFqS74ahYEtDcjmcvl9u/GlPk9Pv/MlhG50U3bOt1B8QFAWO9du3dFr0dgCp70BVFqx/n5ilA2ipxbODD8vzrjez60YhGGn9aeNjG8YQ00BHfqqaDmbFJXuonSSmZvb17PcwW3NVHSWL7FhXm6yONHjCvBAlBp8rN0G/oWyGmjY18yuXOXqRY4TZOxRhwSk1Obo+kPBSkX4HW4CSiXQ3Rv/Qc0eMyI9KBuOwE73/c7B80YiGkeefgLE0sGomfZuYCf6imQY1vUwwCGY+Rdx+CB87zM8IRDJOpJaKf1MpjPXK4Icc5bFEi6QDHT4w5luq+zSwnNnW3PtG9a47p/IV3yszD1OxaRUFrKSyY0XdLKIY4b/vgwxoXRtOwjmYQ4FFhjLfrYlqRCgDqV1D37wlOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +static bool zswap_compress(struct folio *folio, long start, unsigned int=
 nr_pages,
> +                          struct zswap_entry *entries[], struct zswap_po=
ol *pool,
> +                          int node_id)
>  {
>         struct crypto_acomp_ctx *acomp_ctx;
>         struct scatterlist input, output;
> -       int comp_ret =3D 0, alloc_ret =3D 0;
> -       unsigned int dlen =3D PAGE_SIZE;
> -       unsigned long handle;
> -       struct zpool *zpool;
> +       struct zpool *zpool =3D pool->zpool;
> +
> +       unsigned int dlens[ZSWAP_MAX_BATCH_SIZE];
> +       int errors[ZSWAP_MAX_BATCH_SIZE];
> +
> +       unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_size);
> +       unsigned int i, j;
> +       int err;
>         gfp_t gfp;
> -       u8 *dst;
> +
> +       gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABL=
E;
>
>         acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
>
>         mutex_lock(&acomp_ctx->mutex);
>
> -       dst =3D acomp_ctx->buffers[0];
> -       sg_init_table(&input, 1);
> -       sg_set_page(&input, page, PAGE_SIZE, 0);
> -
>         /*
> -        * We need PAGE_SIZE * 2 here since there maybe over-compression =
case,
> -        * and hardware-accelerators may won't check the dst buffer size,=
 so
> -        * giving the dst buffer with enough length to avoid buffer overf=
low.
> +        * Note:
> +        * [i] refers to the incoming batch space and is used to
> +        *     index into the folio pages, @entries and @errors.
>          */
> -       sg_init_one(&output, dst, PAGE_SIZE * 2);
> -       acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SI=
ZE, dlen);
> +       for (i =3D 0; i < nr_pages; i +=3D nr_comps) {
> +               if (nr_comps =3D=3D 1) {
> +                       sg_init_table(&input, 1);
> +                       sg_set_page(&input, folio_page(folio, start + i),=
 PAGE_SIZE, 0);
>
> -       /*
> -        * it maybe looks a little bit silly that we send an asynchronous=
 request,
> -        * then wait for its completion synchronously. This makes the pro=
cess look
> -        * synchronous in fact.
> -        * Theoretically, acomp supports users send multiple acomp reques=
ts in one
> -        * acomp instance, then get those requests done simultaneously. b=
ut in this
> -        * case, zswap actually does store and load page by page, there i=
s no
> -        * existing method to send the second page before the first page =
is done
> -        * in one thread doing zwap.
> -        * but in different threads running on different cpu, we have dif=
ferent
> -        * acomp instance, so multiple threads can do (de)compression in =
parallel.
> -        */
> -       comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req=
), &acomp_ctx->wait);
> -       dlen =3D acomp_ctx->req->dlen;
> -       if (comp_ret)
> -               goto unlock;
> +                       /*
> +                        * We need PAGE_SIZE * 2 here since there maybe o=
ver-compression case,
> +                        * and hardware-accelerators may won't check the =
dst buffer size, so
> +                        * giving the dst buffer with enough length to av=
oid buffer overflow.
> +                        */
> +                       sg_init_one(&output, acomp_ctx->buffers[0], PAGE_=
SIZE * 2);
> +                       acomp_request_set_params(acomp_ctx->req, &input,
> +                                                &output, PAGE_SIZE, PAGE=
_SIZE);
> +
> +                       errors[i] =3D crypto_wait_req(crypto_acomp_compre=
ss(acomp_ctx->req),
> +                                                   &acomp_ctx->wait);
> +                       if (unlikely(errors[i]))
> +                               goto compress_error;
> +
> +                       dlens[i] =3D acomp_ctx->req->dlen;
> +               } else {
> +                       struct page *pages[ZSWAP_MAX_BATCH_SIZE];
> +                       unsigned int k;
> +
> +                       for (k =3D 0; k < nr_pages; ++k)
> +                               pages[k] =3D folio_page(folio, start + k)=
;
> +
> +                       struct swap_batch_comp_data batch_comp_data =3D {
> +                               .pages =3D pages,
> +                               .dsts =3D acomp_ctx->buffers,
> +                               .dlens =3D dlens,
> +                               .errors =3D errors,
> +                               .nr_comps =3D nr_pages,
> +                       };

Why would this work given that nr_pages might be larger than
pool->compr_batch_size?

unsigned int nr_comps =3D min(nr_pages, pool->compr_batch_size);

So this actually doesn=E2=80=99t happen unless pool->compr_batch_size =3D=
=3D 1,
but the code is confusing, right?

> +
> +                       acomp_ctx->req->kernel_data =3D &batch_comp_data;

Can you actually pass a request larger than pool->compr_batch_size
to the crypto driver?

By the way, swap_batch_comp_data seems like a poor name. Why should
crypto drivers know anything about swap_? kernel_data isn=E2=80=99t ideal e=
ither;
maybe batch_data would be better ?

> +
> +                       if (unlikely(crypto_acomp_compress(acomp_ctx->req=
)))
> +                               goto compress_error;
> +               }

Thanks
Barry

