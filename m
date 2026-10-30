Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E99606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 06:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UffQiRjL
Received: by kanga.kvack.org (Postfix)
	id A4CAC6B00EF; Fri, 30 Oct 2026 02:16:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24796B05B1; Fri, 30 Oct 2026 02:16:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 912D96B05B2; Fri, 30 Oct 2026 02:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 625616B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:16:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CEA8DA05CB
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:16:05 +0000 (UTC)
X-FDA: 85378282290.25.5691804
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id D593D20005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:16:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UffQiRjL;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793340963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVt6n+ttdzDHkN2oBzonKaL5TpJmrmsrnCuBXlPWHDw=;
	b=NPFsoex2XpHIQIt0Vh4gL1YKcrHlHGfwTYndp8Fz4JfnnZ5xPLNmCtWxFgAz0IKQaukf9r
	tC0b16UnlPryGU3Z1+3V1gtsv+rbXY2qR2syi85RSFDp3UVR3JqmIo0k0OXmUvfiThGkhE
	s8bqvsoT4uQ6lgjiaanKOAft6+jf27E=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UffQiRjL;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793340963;
	b=nZoePvjqMjbTYoyfFsJw+oBNzUJVvlJZu/hKEpvOk51C+Ss9P+mYk47b9Fe5XbUDSqpUWG
	qTmLNsAD63b3U+PrwL1PyjA8pCDK0tcxG0Z6r5aqe6ZOXP9XLjZLapCi3AQZel1IUkcPtL
	vi+jRrXzdvFkKEsbLmEn9w9nFAQ+VO8=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5be53e5fce1so384799e87.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:16:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793340962; cv=none;
        d=google.com; s=arc-20260327;
        b=kVDTYXlcP9x0xGIE8WsNTKwDGHBxay75JBFwQ0SIYDfefJykkhat0LZyiXbMjfdQom
         NIr5ylWvY7A/aEeo37Kn1EARld58qTD3jp/KqV0aGMoQUEGycxnpwO9vJ+0Rf1r1uQvF
         XaT97ipphzPwEyRA4z0zP0iovuGa/dWqjWsnZZVJYc6hVKQfbt23ijCPxBMevokzIu89
         AEBCGAyhAEz4jQAo2EUGDnbnpAlMkPN0Nj880AuPaCi8EX4tDnfaHsPhV8Mw9ppbWfQv
         ykBkriXqqDol6YLz7iCI916Mw/0RMHbqYzwcXhG+/22esZ3s3jNRV7p7U5kohyh/ZNhj
         tXyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IVt6n+ttdzDHkN2oBzonKaL5TpJmrmsrnCuBXlPWHDw=;
        fh=DEwp2/X1dJJxbkZN6hnFd/Pm+lPa9xvOXoDVGSUTz3k=;
        b=OkmTmyeaAO7Tgk460RV6q54Z76eBd9BJx2I8ZBs+13vWTOBYMVMm9kmN/lB7jQLwp3
         bSBZBr1R7S/8Gb64eSh7olxHFPJnssSrFymz9Ge8xUBEcMJq7LEPC7xx3CM43oeMrWbA
         pfhs3nyPntoN2FLMUfirH/ZDTC1R6PpBsNZvbYIOZ/og7gbAstPdbdecC2sRn43Ih+kt
         S54/c0EZtKcH1syGeg2flDYL18AcCcEnvnqk5mJQmSxm1GoWhZOErn+hAuIVHELDM0ai
         NkNcFvosePTYtmRUlGkESJNfs2WgI3Rno2n3EjM0WlItENptoZZsXlSLNSyttmw7zBbi
         tKUg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793340962; x=1793945762; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IVt6n+ttdzDHkN2oBzonKaL5TpJmrmsrnCuBXlPWHDw=;
        b=UffQiRjLlVfxvT9gUSPTBcCicHUZygCbYSvpu68MjsInUmizbBwhjKNNskdTo/mOvZ
         eNwai/mm4WzoXIwwY9LBZTynqWfifG1k3u7yYwwbOy2X6sSH84FTs8j/VSAE0nwvds+R
         m9CiSxXqbCl1+lh0HebplWh+kf2WABAfUGeR2T1uY6l/78BMk4bruWJ0jXdQ/YfviMSL
         gosIncuPOLbmWElve6iT0BswIdiG2u2GygHQ4jewKXcbwKGQbRMc/kUphzPX0Tc0F7Wo
         gH8YmMx7fRhSpmxk6m5usMmSiTy2juaOf24uV+oTNHivMk0XaJPnwqQrGPU/c5BcTLtQ
         Zkig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793340962; x=1793945762;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IVt6n+ttdzDHkN2oBzonKaL5TpJmrmsrnCuBXlPWHDw=;
        b=jL9ml8U6sP6bbKZ6oxc+WmrYJZbCjOMQTl8b7Nw0fllAPeB4Ov81t2QhfpkgwqfV45
         UOCQmaSHhBnSvyvxiJyhJs5fDzKXa+0vd0tz0PWtUrnoxu7yJz7cgmdmUm0Qm0Xy7+/G
         Rzk0VzBbxLwZohE0VXK4bHXqeB7hqwBo+NpfVbyYha75Eo+ab8YD2Su9hqEVQWTCPbRz
         xJmPpFPGdNNUAscVu0p6SAidkOWVcGDeiQxgjIXL+BBqHvS7JYIbrPA8sZlzD5vPabnL
         hqeoA4aZIY4/8x0O4KH9FTaMLe41sruNhrK5IwriWcu7bAWGWjoVXbNLY3eHT53fK9+7
         SXWA==
X-Forwarded-Encrypted: i=1; AKwUvBxtFXiqUcM5APKgZlW49yWptb6uRg+H9Ua8hBfPD+j43BbFCaN4wxA8hz8ITLXzPar6pBIEe1QR+g==@kvack.org
X-Gm-Message-State: AFq9FYJAF3ZWJ/LcFWfKb4J+dAJsKmDIlFs/bwNwZ9NPtrUvJ1iwNjPh
	IqlH2tV3z7FqDXnHC9NhF8PTAimt6fMkqUfj4f1e4OtwdXULK8ShHFkX/fS3gKZP8jW9OkunOWj
	Gn6HvmR6xBIDcGgy94Ly/yEIlO50XCrM=
X-Gm-Gg: AYBFou3g3Zp4BqTfqhQqjoxjqPzQZ+hWTt3v7g3QusMHwzFZjOesLI47q6yZvnj4LgO
	OkpKynqigDwdvjTAlSe7XSvWmjx/ZlmN/TNH2RD/pNYRLtUiv8mEEDYY0DleapauHVdnOFXz26N
	IEVZAyZCiKOFjdpBfhlSn5DEd1A0UbQ/8dSHx3FgIp95QF/ZDsbaJ9NcmxNgAn3C+/cqdxifFrw
	PHc0cbY/N3nSpQCQ1buZtcgJUfCiWbW7vO0jjAk6v9jCbXgZByJnvjfCvaaXJZAzj0wi/q/MPi4
	d4XLEuetmirn4C4+HKov8SDQ/bWmhTcyY8Y45k+Yn5mzwO+4554a744VQjqF7XmxzxLSjkv8irG
	7eIFnkyYdBkl3vmXtwJcqZPbMafHIk7o+h4SZ7w==
X-Received: by 2002:a05:6512:6d3:b0:5bf:cea4:4156 with SMTP id
 2adb3069b0e04-5bfd956510cmr376884e87.17.1793340961808; Thu, 29 Oct 2026
 23:16:01 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-8-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188659@kernel.org>
In-Reply-To: <sashiko-outbox-188659@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 23:15:49 -0700
X-Gm-Features: AclHuK8qeUEao5lE4vYKNlUTpi7FFlA0-3bCltLoe5if13IPMWkhagm4XDB1Yjk
Message-ID: <CACpmpofOE797D7f4YGZEJ2jtHn08d9Jo8Ya3cdV8h9UL5hUd9A@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] mm: zswap: Batched zswap_compress() for storing
 large folios in batches.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D593D20005
X-Rspam-User: 
X-Stat-Signature: e36r3do3zpsso7oqg4qi6gasnt1yf5mm
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793340963-770697
X-HE-Meta: U2FsdGVkX18hLjOBLizO15Qb0XFhG0/dLTU30IsJvIKYR7OUw9Ie+XojPqthokpc9z3hmeaVHfRtkwiWoJWIz7rsBL9tXbIsWbf3uWfV85jlItn6cfQJZQ0mNGir4Q79/fpRUTlRdjtFrdjITb9KlonD+NvTDLXzhSkS26qVLwBycG5VuUfZAmQqytv9kxn1jt2xALyuyH9uvgNyfVXnVDNtdthfAaxOpq1Vl1mtsq8pb79dwIVy8ab65lw6tg8KSnf7BgqZ/G4r14XpvFAUN1ec7uaUJnFF5kpvKIFefxXmgVXoAeDwjbbb/y+m9j3Rz1o3TJKZkJR8lCj3Bnur2eHNqDZiQhrc316nkJXFgGrTl2uG2A643e2YKF2SRsO+uTmyKJakBJoQm/ExeN0obBjYcdYiyeZq6ZMKjuvFXSJzm29hyLzkUCcIow7yQ4cwaXMJ3GzNnlKeO+nXdQQLMqOV2QoaCrWTYgrvYFNp+LiD8E9YtAnH98fnx1mS3RHsoP2YdyOSF2PdAGhj2j6BVOg5Wle9RgGyc9TpTyl+Cfw1xxofB0nM7shqxVanjFZr6IgFXYJHxHmgfpyWkC7AULv7CO6/3WNIuX5oV3eht8shlLzR8Kg0tpHemhavJJB9JSwXF1HJ/X2LGguTEu7Cp8dU9zNXGEqzEwyzAbBDhv9+d06QEaGUJQjDUcpBy2km0LDJsry7J5k5rvzHm9HMtjBBvk277XY2Is+DjD9++YgcjTVAGtWos+E3EzbugItZZCJyMj08kAUl9IUtptdFkjvhuycGDvyImJlHGIieB/REWRYkzsqCdXnkZCbWDk57TCthg/BmS4MD/gxZHOqZfvZKiG2vZ0zZ8nw8L/5TEWZnopHjPT6pHh2RRWAHrssEYfFwRE20ssXJLNGO1cJGglZ3/NKcTsj4AgXHnucAI8Vtfow/N+LZgEo/bnMJpemIzQ0Xovjslwxtf4jd/uB
 fvaXsxBJ
 tXUMoNTHKvicsMBAdyuMR8I5ROD1HHSqAPDkWA1xhvBvJKJO9CdseGliNvo+jIqM7zgMQQv9mUeoUUocYVG92Zt2NmsTDP7pkTJ92uJUrjSxEVMbQSOh8OQgQxYNegJ4/VfWc36EFs/+OGShV2yPsx0diyZU8vIz3V43RvZGG67UitNQ4ZuB5AxfEYgoG2res/M//GVNkUEG/otV6gPemp9csfP6yu2cO3dHBVXmvfY1Fd4qYh1jIZWcsc4UzsfHhlqQjjh2kWKDkA7ZWFFc6IzBBXQok29JVnCwBnOEu2jq+PsnJ7ZUSfkV+gtdKbIQZp8o24UntPJXuNTB5mTTi1dDn89Y7yw4nEk7ubjo8b9lzikfh1IXUYjvv0tMteC5ws03m+jNVCgjZRUlz6705HqyUJSMskSNn5139Kfl+KReC/Y0b36EAmrtvxhbYYvPzpmSFZz5SFmvUF1LP+Fw8CnyFN/43ZIdU4IV5zcD4P2Ir9qCcvViYcFzfFsisWSxenSruiYFwPf657iWJ8t4ZKgRltyGHl5OpJ8vb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 8:06=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 6 potential issu=
e(s) to consider:
> - [Critical] mm: zswap: unclamped nr_batch_pages in zswap_compress() caus=
es OOB and crash
> - [High] mm: zswap: zsmalloc handle leak on partial batch failure in zswa=
p_compress()
> - [High] mm: zswap: invalid and unreset dst scatterlist lengths in zswap_=
compress()
> - [High] mm: zswap: zswap_cpu_comp_prepare() returns 0 on buffer or sg_ta=
ble alloc fail
> - [High] mm: zswap: zswap_compress() reads -EINPROGRESS sg->length for as=
ync acomp
> - [Medium] mm: zswap: zswap_compress() stores PAGE_SIZE outputs when writ=
eback disabled
> --
>
> commit 61c906de6e16dcc53db7f835142f9c05558dca5f
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Batched zswap_compress() for storing large folios in batches.
>
> This commit introduces a batched zswap_compress() implementation using
> per-CPU scatterlists and refactors zsmalloc allocation into
> zswap_update_entries().
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index c8890e8a9b836..4476fb4aeb5fd 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
>
> [ ... ]
>
> > @@ -944,6 +956,21 @@ static int zswap_cpu_comp_prepare(unsigned int cpu=
, struct hlist_node *node)
> >                       goto req_fail;
> >       }
> >
> > +     acomp_ctx->comp.sg_table =3D kmalloc(sizeof(*acomp_ctx->comp.sg_t=
able), GFP_KERNEL);
> > +     if (!acomp_ctx->comp.sg_table)
> > +             goto req_fail;
> > +
> > +     if (sg_alloc_table(acomp_ctx->comp.sg_table, pool->compr_batch_si=
ze,
> > +                        GFP_KERNEL))
> > +             goto req_fail;
> > +
> > +     /*
> > +      * Statically map the per-CPU destination buffers to the per-CPU
> > +      * SG lists; crucial for performance.
> > +      */
> > +     for_each_sg(acomp_ctx->comp.sg_table->sgl, sg, pool->compr_batch_=
size, i)
> > +             sg_set_buf(sg, acomp_ctx->comp.buffers[i], PAGE_SIZE);
> > +
> >       /* Skip the per-CPU request when decompression can use the stack.=
 */
> >       if (acomp_is_async(acomp_ctx->acomp)) {
> >               ret =3D zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ct=
x->acomp);
> > @@ -960,92 +987,161 @@ static int zswap_cpu_comp_prepare(unsigned int c=
pu, struct hlist_node *node)
> >       return ret;
> >  }
>
> [Severity: High]
> Does zswap_cpu_comp_prepare() return 0 on failure if allocating
> acomp_ctx->comp.buffers, acomp_ctx->comp.sg_table, or sg_alloc_table()
> fails?
>
> Earlier in zswap_cpu_comp_prepare(), ret is overwritten by
> zswap_acomp_req_init():
>
>         ret =3D zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->ac=
omp);
>         if (ret)
>                 goto req_fail;

This is resolved as part of the error return issue flagged in patch 6.
I am making sure that acomp_ctx->comp.buffers, sg_table, etc. related
failures set ret =3D -ENOMEM before "goto req_fail". Thanks for the due
diligence.

[ .. ]

>
> > -static bool zswap_compress(struct folio *folio, long index,
> > -                        struct zswap_entry *entry, struct zswap_pool *=
pool,
> > -                        bool wb_enabled)
> > +static bool zswap_update_entries(struct zswap_store_context *zc,
> > +                              u8 batch_start)
> >  {
> > -     struct zswap_comp_ctx *comp_ctx;
> > -     struct scatterlist input, output;
> > -     int comp_ret =3D 0, alloc_ret =3D 0;
> > -     unsigned int dlen =3D PAGE_SIZE;
> > +     gfp_t gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_=
MOVABLE;
> > +     u8 i, batch_iter, comp_batch_iter;
> >       unsigned long handle;
> > -     gfp_t gfp;
> > +     unsigned int dlen;
> >       u8 *dst;
> > -     bool mapped =3D false;
> > -
> > -     comp_ctx =3D &raw_cpu_ptr(pool->acomp_ctx)->comp;
> > -     mutex_lock(&comp_ctx->areq.mutex);
> > -
> > -     dst =3D comp_ctx->buffers[0];
> > -     sg_init_table(&input, 1);
> > -     sg_set_folio(&input, folio, PAGE_SIZE, index * PAGE_SIZE);
> > -
> > -     sg_init_one(&output, dst, PAGE_SIZE);
> > -     acomp_request_set_params(comp_ctx->areq.req, &input, &output,
> > -                              PAGE_SIZE, dlen);
> >
> >       /*
> > -      * it maybe looks a little bit silly that we send an asynchronous=
 request,
> > -      * then wait for its completion synchronously. This makes the pro=
cess look
> > -      * synchronous in fact.
> > -      * Theoretically, acomp supports users send multiple acomp reques=
ts in one
> > -      * acomp instance, then get those requests done simultaneously. b=
ut in this
> > -      * case, zswap actually does store and load page by page, there i=
s no
> > -      * existing method to send the second page before the first page =
is done
> > -      * in one thread doing zswap.
> > -      * but in different threads running on different cpu, we have dif=
ferent
> > -      * acomp instance, and compression and decompression use separate
> > -      * requests, so multiple threads can do (de)compression in parall=
el.
> > +      * For each output SG list in @acomp_ctx->req->sg_table->sgl,
> > +      * the @sg->length should be set to either the page's compressed
> > +      * length (success), or it's negative value compression error.
> >        */
> > -     comp_ret =3D crypto_wait_req(crypto_acomp_compress(comp_ctx->areq=
.req),
> > -                                &comp_ctx->areq.wait);
> > -     dlen =3D comp_ctx->areq.req->dlen;
> > -     if (!comp_ret) {
> > -             if (dlen =3D=3D PAGE_SIZE)
> > -                     comp_ret =3D -ENOSPC;
> > -             else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
> > -                     comp_ret =3D -EINVAL;
> > +     for (comp_batch_iter =3D 0; comp_batch_iter < zc->nr_batch_pages;
> > +          ++comp_batch_iter) {
> > +             batch_iter =3D batch_start + comp_batch_iter;
> > +             dlen =3D zc->entries[batch_iter]->length;
> > +             handle =3D zs_malloc(zc->zs_pool, dlen, gfp, zc->nid);
> > +
> > +             if (unlikely(IS_ERR_VALUE(handle))) {
> > +                     if (PTR_ERR((void *)handle) =3D=3D -ENOSPC)
> > +                             zswap_reject_compress_poor++;
> > +                     else
> > +                             zswap_reject_alloc_fail++;
> > +
> > +                     for (i =3D 0; i < comp_batch_iter; ++i)
> > +                             zs_free(zc->zs_pool, zc->entries[batch_st=
art + i]->handle);
> > +
> > +                     return false;
> > +             }
> > +
> > +             zc->entries[batch_iter]->handle =3D handle;
> > +
> > +             if (likely(dlen < PAGE_SIZE)) {
> > +                     dst =3D zc->comp_ctx->buffers[comp_batch_iter];
> > +                     zs_obj_write(zc->zs_pool, handle, dst, dlen);
> > +             } else {
> > +                     dst =3D kmap_local_folio(zc->folio,
> > +                                     (zc->folio_start + batch_iter) * =
PAGE_SIZE);
> > +                     zs_obj_write(zc->zs_pool, handle, dst, dlen);
> > +                     kunmap_local(dst);
> > +             }
> >       }
> >
> > +     return true;
> > +}
> > +
> > +/*
> > + * zswap_compress() batching implementation for sequential and batchin=
g
> > + * compressors.
> > + *
> > + * Description:
> > + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > + * Compress multiple @nr_pages in @folio starting from the @folio_star=
t index
> > + * in batches of @nr_batch_pages; the latter representing the lesser o=
f the
> > + * @nr_pages to be batch compressed and the compressor's batch size.
> > + *
> > + * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compresso=
r does not
> > + * support batching.
> > + *
> > + * If @nr_batch_pages is 1, each page is processed sequentially.
> > + *
> > + * If @nr_batch_pages is > 1, the compressor may use batching to optim=
ize
> > + * compression.
> > + */
> > +static bool zswap_compress(struct zswap_store_context *zc)
> > +{
> > +     u8 batch_start, comp_batch_iter, batch_iter;
> > +     struct scatterlist *sg;
> > +     bool ret;
> > +     int err;
> > +
> >       /*
> > -      * If a page cannot be compressed into a size smaller than PAGE_S=
IZE,
> > -      * save the content as is without a compression, to keep the LRU =
order
> > -      * of writebacks.  If writeback is disabled, reject the page sinc=
e it
> > -      * only adds metadata overhead.  swap_writeout() will put the pag=
e back
> > -      * to the active LRU list in the case.
> > +      * Compress the @nr_pages in @folio starting at index @folio_star=
t
> > +      * in batches of @nr_batch_pages.
> >        */
> > -     if (comp_ret) {
> > -             if (!wb_enabled)
> > -                     goto unlock;
> > -             comp_ret =3D 0;
> > -             dlen =3D PAGE_SIZE;
> > -             dst =3D kmap_local_folio(folio, index * PAGE_SIZE);
> > -             mapped =3D true;
> > -     }
> > +     for (batch_start =3D 0; batch_start < zc->nr_pages;
> > +          batch_start +=3D zc->nr_batch_pages) {
> > +             /*
> > +              * Send @nr_batch_pages to crypto_acomp for compression:
> > +              *
> > +              * These pages are in @folio's range of indices in the in=
terval
> > +              *     [@folio_start + @batch_start,
> > +              *      @folio_start + @batch_start + @nr_batch_pages).
> > +              *
> > +              * @slen indicates the total source length bytes for
> > +              * @nr_batch_pages.
> > +              *
> > +              * The source folio pages in the batch are directly submi=
tted to
> > +              * crypto_acomp via acomp_request_set_src_folio().
> > +              *
> > +              * The pool's compressor batch size is at least @nr_batch=
_pages,
> > +              * hence the acomp_ctx has at least @nr_batch_pages dst @=
buffers.
> > +              */
> > +             acomp_request_set_src_folio(zc->comp_ctx->areq.req, zc->f=
olio,
> > +                             (zc->folio_start + batch_start) * PAGE_SI=
ZE,
> > +                             zc->slen);
> > +
> > +             zc->comp_ctx->sg_table->sgl->length =3D zc->slen;
> > +
> > +             /*
> > +              * The per-CPU @zc->comp_ctx->sg_table scatterlists are s=
tatically
> > +              * mapped to the per-CPU dst @buffers at pool creation ti=
me.
> > +              */
> > +             acomp_request_set_dst_sg(zc->comp_ctx->areq.req,
> > +                                      zc->comp_ctx->sg_table->sgl, zc-=
>slen);
>
> [Severity: High]
> How are the destination scatterlist entry lengths in
> zc->comp_ctx->sg_table->sgl maintained across batches when
> zc->nr_batch_pages > 1?
>
> In zswap_cpu_comp_prepare(), each acomp_ctx->comp.buffers[i] is allocated
> with size PAGE_SIZE and mapped to sgl[i] via sg_set_buf(..., PAGE_SIZE).
>
> Here in zswap_compress(), setting zc->comp_ctx->sg_table->sgl->length =3D
> zc->slen sets sgl[0].length to zc->nr_batch_pages * PAGE_SIZE, which
> exceeds the single PAGE_SIZE allocation backing buffers[0] when
> zc->nr_batch_pages > 1.
>
> At the same time, sgl[1 .. zc->nr_batch_pages - 1].length are never reset
> to PAGE_SIZE before calling crypto_acomp_compress(). After the first batc=
h
> completes (or after a batch fails and jumps to compress_error), those SG
> entries retain their previous compressed lengths or negative error codes =
on
> subsequent requests.

Excellent questions. For compressors for which compr_batch_size > 1,
i.e., zc->nr_batch_pages > 1, that batching algorithm's driver is
expected to test for req->slen > req->unit_size and use
req->slen/req->unit_size to ascertain the # of SG lists to process (in
the case of compression). Please refer to a reference implementation
in [1] and [2].

[1]: https://patchwork.kernel.org/project/linux-mm/patch/20260125033537.334=
628-17-kanchana.p.sridhar@intel.com/
[2]: https://patchwork.kernel.org/project/linux-mm/patch/20260125033537.334=
628-19-kanchana.p.sridhar@intel.com/

The crypto_acomp algorithms don't use
zc->comp_ctx->sg_table->sgl->length as inputs, these values are always
over-written as the output of compression (patch 3 in this series).

>
> > +
> > +             err =3D crypto_wait_req(crypto_acomp_compress(zc->comp_ct=
x->areq.req),
> > +                                   &zc->comp_ctx->areq.wait);
> >
> > -     gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABL=
E;
> > -     handle =3D zs_malloc(pool->zs_pool, dlen, gfp, folio_nid(folio));
> > -     if (IS_ERR_VALUE(handle)) {
> > -             alloc_ret =3D PTR_ERR((void *)handle);
> > -             goto unlock;
> > +             /*
> > +              * If a page cannot be compressed into a size smaller tha=
n
> > +              * PAGE_SIZE, save the content as is without a compressio=
n, to
> > +              * keep the LRU order of writebacks.  If writeback is dis=
abled,
> > +              * reject the page since it only adds metadata overhead.
> > +              * swap_writeout() will put the page back to the active L=
RU list
> > +              * in the case.
> > +              *
> > +              * It is assumed that any compressor that sets the output=
 length
> > +              * to 0 or a value >=3D PAGE_SIZE will also return a nega=
tive
> > +              * error status in @err; i.e, will not return a successfu=
l
> > +              * compression status in @err in this case.
> > +              */
> > +             if (unlikely(err && !zc->wb_enabled))
> > +                     goto compress_error;
> > +
> > +             for_each_sg(zc->comp_ctx->sg_table->sgl, sg,
> > +                         zc->nr_batch_pages, comp_batch_iter) {
> > +                     batch_iter =3D batch_start + comp_batch_iter;
> > +                     if (unlikely(sg->length <=3D 0 || sg->length >=3D=
 PAGE_SIZE))
> > +                             sg->length =3D PAGE_SIZE;
> > +
> > +                     zc->entries[batch_iter]->length =3D sg->length;
> > +             }
>
> [Severity: High]
> What happens in zswap_compress() when using an asynchronous non-segmented
> acomp driver?
>
> In crypto/acompress.c:crypto_acomp_compress(), when req->unit_size =3D=3D
> req->slen and !crypto_acomp_req_seg(tfm), the fast path runs:
>
>         if (likely((req->unit_size =3D=3D req->slen) && acomp_request_iss=
g(req) &&
>                     !crypto_acomp_req_seg(tfm) && !acomp_req_on_stack(req=
))) {
>                 int err =3D tfm->compress(req);
>
>                 req->dst->length =3D unlikely(err) ? err : req->dlen;
>                 return err;
>         }
>
> When tfm->compress(req) is asynchronous and returns -EINPROGRESS or -EBUS=
Y,
> req->dst->length (sg->length) is set to -EINPROGRESS before
> crypto_wait_req() waits for completion, and nothing updates sg->length to
> req->dlen when the request finishes.
>
> Wouldn't zswap_compress() then see sg->length =3D=3D (unsigned int)-EINPR=
OGRESS
> after crypto_wait_req() returns 0, clamp sg->length to PAGE_SIZE, and sto=
re
> every page uncompressed instead of using req->dlen?

This shouldn't happen now, with Sashiko's and Herbert's earlier
suggestion incorporated, that tests for !acomp_is_async(tfm) instead
of !acomp_req_on_stack(req) in the fast path.

>
> [Severity: Medium]
> Also, is the assumption that compressors never return 0 when the output
> length is PAGE_SIZE true for software compressors?
>
> Software compressors such as lz4 and zstd return 0 with dlen =3D=3D PAGE_=
SIZE
> when a page compresses to exactly PAGE_SIZE bytes. Previously,
> zswap_compress() checked:
>
>         if (!comp_ret) {
>                 if (dlen =3D=3D PAGE_SIZE)
>                         comp_ret =3D -ENOSPC;
>                 else if (WARN_ON_ONCE(!dlen || dlen > PAGE_SIZE))
>                         comp_ret =3D -EINVAL;
>         }
>
> Without that check, when err =3D=3D 0 and sg->length =3D=3D PAGE_SIZE wit=
h
> !zc->wb_enabled, won't zswap_compress() and zswap_update_entries() alloca=
te
> a PAGE_SIZE object in zsmalloc and store the uncompressed page even thoug=
h
> writeback is disabled?

Yes, I missed this, and will fix it in the next version. The special
casing for comp_ret=3D0 with dlen =3D=3D PAGE_SIZE (among other end-cases)
when writeback is disabled, needs to happen with the batched version
of zswap_compress() as well.

>
> > +
> > +             ret =3D zswap_update_entries(zc, batch_start);
> > +             if (unlikely(!ret))
> > +                     return false;
> >       }
>
> [ ... ]
>
> > @@ -1681,11 +1785,10 @@ static bool zswap_store_pages(struct zswap_stor=
e_context *zc,
> >       return true;
> >
> >  store_pages_failed:
> > -     for (i =3D store_fail_idx; i < zc->nr_pages; ++i) {
> > -             if (!IS_ERR_VALUE(zc->entries[i]->handle))
> > -                     zs_free(pool->zs_pool, zc->entries[i]->handle);
> > -     }
> > +     for (i =3D store_fail_idx; i < zc->nr_pages; ++i)
> > +             zs_free(pool->zs_pool, zc->entries[i]->handle);
> >
> > +compress_failed:
> >       zswap_entries_cache_free_batch(&zc->entries[store_fail_idx],
> >                                      zc->nr_pages - store_fail_idx);
> >
>
> [Severity: High]
> Does this leak zsmalloc handles in zc->entries[0 .. batch_start - 1] when=
 a
> later sub-batch (batch_start > 0) fails in zswap_compress()?

I will reinstate the v1 solution I had for this exact same issue that
I dropped in v2. As it stands in v2, yes, this can leak zsmalloc
handles. The v1 solution will address this.

[ .. ]

>
> > @@ -1757,6 +1860,10 @@ bool zswap_store(struct folio *folio)
> >       store_batch_size =3D (pool->compr_batch_size > 1) ?
> >                           pool->compr_batch_size : ZSWAP_MAX_BATCH_SIZE=
;
> >
> > +     zc.nr_batch_pages =3D pool->compr_batch_size;
> > +     zc.slen =3D zc.nr_batch_pages * PAGE_SIZE;
> > +     zc.zs_pool =3D pool->zs_pool;
> > +
> >       for (start =3D 0; start < nr_pages; start +=3D store_batch_size) =
{
> >               end =3D min(start + store_batch_size, nr_pages);
> >
>
> [Severity: Critical]
> What happens in zswap_store() -> zswap_store_pages() -> zswap_compress()
> when pool->compr_batch_size > 1 and the folio (or trailing batch end -
> start) has fewer pages than pool->compr_batch_size, such as an order-0
> folio where nr_pages =3D=3D 1?

Yes, thanks for flagging this. Also something I had in v1, but dropped
while optimizing v2. I will reinstate this.

>
> In zswap_store(), zc.nr_batch_pages is set to pool->compr_batch_size and
> zc.slen is set to zc.nr_batch_pages * PAGE_SIZE, while zswap_store_pages(=
)
> sets zc->nr_pages =3D end - start and only allocates zc->nr_pages entries=
 in
> zc->entries[0 .. zc->nr_pages - 1].
>
> Because zc->nr_batch_pages and zc->slen are never clamped to zc->nr_pages=
,
> when zc->nr_pages < zc->nr_batch_pages:

You're right. zc->nr_batch_pages and zc->slen need to be clamped to
zc->nr_pages. I will fix this.

>
> 1. acomp_request_set_src_folio() in zswap_compress() maps zc->slen bytes,
>    reading past the end of zc->folio.
>
> 2. Both the for_each_sg() loop in zswap_compress() and the loop in
>    zswap_update_entries() iterate comp_batch_iter up to zc->nr_batch_page=
s,
>    dereferencing zc->entries[batch_iter] for batch_iter >=3D zc->nr_pages=
. On
>    the first batch, zc->entries[zc->nr_pages] is NULL (causing a NULL
>    pointer dereference); on a trailing partial batch after a full batch, =
it
>    contains stale zswap_entry pointers from the previous batch (corruptin=
g
>    live entries and leaking the newly allocated zsmalloc handles).
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.17=
923-1-kanchanapsridhar2026@gmail.com?part=3D7

