Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C64606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TRMaCqUt
Received: by kanga.kvack.org (Postfix)
	id DBBED6B05B6; Sat, 21 Nov 2026 16:22:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D92DF6B05B8; Sat, 21 Nov 2026 16:22:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C817F6B05BB; Sat, 21 Nov 2026 16:22:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 907916B05B6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:22:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1790D140278
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:22:39 +0000 (UTC)
X-FDA: 85460400438.28.E7E87B0
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id BB3C2140007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:22:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TRMaCqUt;
	spf=pass (imf26.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795296156;
	b=KRdx+HyyoTvShDL71R8mxPCQvzbGYBdkpy1h2gF1YCRQuDba2jQnKj0YFIJWDx5E129VFe
	XeDMdFDru655BzLIICFmsY+qi4jdvXerMKlMq/4ZGgeslF40pOkEB+fUBB99Atf61gi6cy
	h9awQ40/COwa28Ezt/Tvfu5j3+r/ro4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795296156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhxZH8BTZF9uyHOWYNwDlYQX01HSpJGN5QAEadM7D00=;
	b=tFp4smb0D2HiBfhH/1t8InXIjbtz54jF2kijzRP/PS/kM/04RSgmjLVjchcTU2xJreeBkv
	zfvzcUVupvTh4XEVT+KABgD/dtGHA7Xq8c/0znIWrJbYw6Ea2+jinRBDrsgXuVvWZw77i6
	RPr9bfnySPrqOxixtOuzNTnqMw+Buo4=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TRMaCqUt;
	spf=pass (imf26.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3ae25d9e2fdso20440721fa.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:22:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795296155; cv=none;
        d=google.com; s=arc-20260327;
        b=JzZGMC/OmA59g8/enKFI7170xBY0u3foT/P6bwCn/vS9z/w/GV54T7vpwf14lXch47
         LuYo/FVJdwZR4sZKaqsQI1VhBAUf20p6/pFAPvjMYRMQtIj45k6nFKsKgtPNeiyT5uFA
         ktnbr+41Zts2DwpVVP9NC3m46KbDG8Oy5s0fBwuywPv6DfDZ9CPWGjyG/3oVAuNyEfoW
         pfUJ6ZWD725OwxmzHhGE3VU8HUY3OW28knrOyGBpqKCAagCcM+v9JHSYeNggQe1ij0jr
         mj8BfKjlKV2L50x6DkwdfO+ei5zWJnEvhTAp+TK+jz7sgtUMipKl5+zfzdxpoRT5wkHQ
         xyQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QhxZH8BTZF9uyHOWYNwDlYQX01HSpJGN5QAEadM7D00=;
        fh=CThFZrbdB52cXIDUPSxJQ/zacP26O4Wh4+xKvKuA5DA=;
        b=Ci+/XgAeNnQRKFLmvk3Ff6x/W605t3nXcM1+D10lI4gNGH2R0Od8/DXo7DS1e9hALD
         IyhO1t6UqlPmg58DYSneWkQTdUsotSKo3EHvwL/qJENNMhf6UBobq87mTpkQ9vPUe5oB
         Lf0z8G4CLPHHyxhEs3jRMsQtPt21PGDFDD/iW9m/vQ+UGVANrFhDlGvvn30ef6Y3WOVm
         CMTdjoABnab1wMDakgy1x4rnWn8AUVOZCKhaxt4cOYDoY6hIQOpgQ/YOU36vPQKJxSS6
         wavbQReb6ro6QBo/0zef4V6At9/mj7oTvbDb9LwylyrnLLhUP0cmfsyGnb/KXfP43s25
         Oa0g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795296155; x=1795900955; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QhxZH8BTZF9uyHOWYNwDlYQX01HSpJGN5QAEadM7D00=;
        b=TRMaCqUtbEV2hKahZoD0JuuXRRq4cTDpqD3W6eOV0RFXUXCe6d4ZZtsauAhwfwEzH8
         uKHbJ8pgNzMXYPsm9VLf9zIJ7r7ogRpWUZcowWf07/NJgWo8BUE69qcLqJKiDg8GVnRm
         3wWTRPFmd/bm93q4fwtwqv21hcHtWtm2azxB8sVl5DnlN7PhtZClJgd6oRefG/K2+l9t
         DxmY9oyIcX7TwvZ1tvmwUJPUHd945cCx61GKUzSMleO18cWhpWmnQLc3VfGJ+ArnFpHt
         B6JMVceh8XBbewwmKGkqrTk/qOzk6T08i/jXkjSru5xx4EChkhIUkIEwDtRIeQFbrgfm
         61+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795296155; x=1795900955;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QhxZH8BTZF9uyHOWYNwDlYQX01HSpJGN5QAEadM7D00=;
        b=WvQ3SI9T05+NWC1zJMYRtcYatFhNB3XN/5Gt09Kup4LK7INtGJTcZ/2blTpHI386OE
         6ZusXRSFmM2fx3KneJxyCvgvFg/dLELsulRNaQXL/q9SjEejLOLz5bMlY1DeXCz0nmTH
         A4AXaEwF4vL1aZpgvivuY+c5RGgXLtHyrrwLB7Ja6OZ5XpOaAiyHCLssNwEWEbK3rkDd
         pDPn62xZHRe1iyQCoUvLGmPhbz/uHmVKb69+oZzqkDqOBnYiU1tD2EhNhMyiw9fB5ZAw
         jm9+OymKE21WpEYs1MUDr53ysKEgj0Zecy1PuK35S9cVS2WSwBZXV20DlxHpfZjFOxFw
         9wCQ==
X-Forwarded-Encrypted: i=1; AL+hErG07DolnZV4KE6Gin1WCquLZhW52nJXuxsW1+J6omIozSgvxBik5zsXFnMjFctIs3ZcVwbg50muBA==@kvack.org
X-Gm-Message-State: APuU4Z93HpyVrDEGeu53RXncOtX/K5eHfaarAdaLlFCv4ySnvWA+uqJu
	nTWW2mTeKYKL6HsHpouogXXms0j5iJcf9LLX9CLkI3XksJOe+ayT9mYATlLTUKGLSrF91RxCTx5
	oWa3IP7Uu4mf4uHrASvWpqa+DYlk2Ags=
X-Gm-Gg: AZFdTZc3vj1/Y+thmdtEXQQ+zY8r+/WqpYUeOldoIJcodHgBbFhiX8jWSq2xmEY0zLZ
	CAVoseMZU7PIKCy3yNS75TN9a4fCmaqNxKRwUy507042pwZ5QdPuH1obRJu3BMY+eXDtzHb/Lov
	isWrjwUnKRtNz7b7681z7qhsO41RNuzXdA+81DH4p4SAV1jQBXl0PjKx98JAK2PTku7Yv2Mnnza
	nHfSCKr5t/aNZvQlhpJqugY7gFrcBcwzB+f0qPK3FsG54Q+82g56o0yViEgqr5wPwb1R0EDiR2q
	M9Z/v7V0vSUoFpNp8Mb1+cTF8AhjSLlajLDpiKq4Dy2nH2bYR6nq8u7zulOPdKjvgc3Wr+wXmNr
	mC1qzLOvstLWpGNsZyQDlo1WevXlwS9GgQ7weKmUDf8kw+BtAd3x3glF99g==
X-Received: by 2002:a05:651c:a149:b0:3ac:e4fe:49c with SMTP id
 38308e7fff4ca-3ae7fa65ademr21112491fa.21.1795296154982; Sat, 21 Nov 2026
 13:22:34 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-9-kanchanapsridhar2026@gmail.com> <sashiko-outbox-226638@kernel.org>
In-Reply-To: <sashiko-outbox-226638@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Sat, 21 Nov 2026 13:22:21 -0800
X-Gm-Features: Aa3M54pt8cwuxT6_by5lL_6hdW5GlQGTKVDXQNTvmifS0EhM5bwkQ1ptuPBtKJw
Message-ID: <CACpmpocYxp38npkHWhbhOyoRAq2KKyvpo6HQRih1VPPDwMvFUw@mail.gmail.com>
Subject: Re: [PATCH v4 8/8] mm: zswap: Batched zswap_compress() for storing
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
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BB3C2140007
X-Stat-Signature: 8grp8k33eunkw388yhac9aa61eckt8bh
X-Rspam-User:
X-HE-Tag: 1795296156-225137
X-HE-Meta: U2FsdGVkX1+t9QQSEWUaoMQ0Sq4R4qWpcWaKlVTcTlrJ8VPuuK929IBFUiI1Ie81n3X7jN1s9mJfcmYgnfBjQ6zKHKS0I6wG6zRNw1EIIhCToQvcg9Vlpeqfg7Zi7BCyQi4pGrlzbl0pCXqeyiaTPi09fm1BG1KhNSGVEw//XVx987KVqT3Tb/RzWGw/MnDxPFT9F1zvvcJ+pz6/2kR4Vw9SCY7hY56STn4lDmHVPZEcNmCXtWTjFqcw0yerlFZt/NhNzn1P6a9TbaLCtAsKtwCh9XptkYp3tuFU6RqyMg6r9Jz4t30H2+smCD5V+rQhAUK7TmaCRgsXBDyuYgnPof3+csxlby5qEabtPhmMkjBO28lNWy8SvnOgsbPnzrqdy8JnB79kY3KxriNB1PMuAF/K+ZFqH6QpcNdoLKjENtHPwRDdMXm0G8ee4WmbLIt+iM4fCR66Ln3JcxNk6k8GL2f7Wufdh7JD2uFjsMuv7Hx57JY/6oaMJNvZCg+JafRcjnTvJ3QXFMz/oYopKF8vO/1hWCcV2AM01+IBJcj2sLAEU5ypdPWuhhk9pPiJcE6Mxlo7v5HkoLiXg9Dnu4K6yMfjHHfB9GtB1P37kELvcyvNPYrlrI6aEBCiUGfDSZeGUPQShJXBaWHryOhEO5ka3J4clZoU2oWU3ZFNuKVFq9huCqryibLGY+hEOTjwzZzLS51qVYoeptg+XT+zenwSgDq077vrhM9KfMhWAit1Fbzc9x6pbxSUxu0AG7Yop0lFRiLDjKVtoWX/+UxuOl5sFkN9igwHMLjiGDgWczv/AJsFcrVlETDinOMnfy5gPcmis2KMj8/bQatH+wpGnHPCya/nvXFLGveyNLSuL8Mbc0hxFDJW+xqEDAAwA4Xnm5IzpRTeE8jnyui7PkvKQ8TJMFHyk8qnmTyysQcZCAXpoBo2Q+upyK8Jiy3/hoVnHldF5/KBT6lLuYcIeZtgMC9
 T+9XrA6v
 BzgZPowCB/2JasxYxjT4VrRSGtCzgX6i1SF5gPW4CBnKRw98RhOHL0PFThy6nRyzV8uoY75UQReDF/drqezTYCOBrCkiUZ0fEjZkKG9R0Gp9S/NAM94KFqjsm2K3sGX90JDVt6v/TAywGdm/oSr5CkLhM31vocvVTrR/QRI7Tb/NG+x9Cv7jI/jZAVaq34t0ap6w3gKEnUkL4ev0MVvojWFnmx5fAO92owrSL/dC2YAsgh5PoO3k5CfAVJIP6cOjvuVrFU5YFtIOeDKz+pmE6gSTbpFZ/1EFR8bI+TCDWIIYVaVXT+o9Q500stCAzFiscwbugogJGy59JAoi8FaiEuaU5LUklNy9OL94IRYDmQQedbAtrdqGxa1a/lvyQelj7ZJ1uKeZmSv0+51SaxigKHs/jQxgB11gebVFflRyTAEEmuEhxU5XiQ1mLZ3HrJdCnzWOIpbTEFlIUtnSnRKAESdMrnWzw9t9cRxyuAFoMBmoi0yBiv8rbNY2xsAZ93gH66G8Bh6+oKmAFAfKS1rNlAhO141aLruTa9pSJfyA+7q0iQgR+GZu6z+88rinKtdSfrowyn3ZQzEzDWIGmq9H2I6ONI/+oCw1Dj5TKOUxNslzeCxynH03AIi5xx0cGipalyPHroMLfR6tsZcZ8yC5glqP4U+x6b4kGbwI8uspBh/Xec/+nY/+DmPn0wOVkOI5udCSInTK0P77S/23KBMbFFply0ORA1V5RVdAJR/YWKPD4MG3VSefOLJgV+u4GRGbamfrz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 8:20=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [High] mm: zswap: invalid and unreset dst scatterlist lengths in
>   zswap_compress()
> - [High] mm: zswap: unterminated dst scatterlist slice passed in
>   zswap_compress()
> - [Medium] mm: zswap: unsigned sg->length check and error accounting in
>   zswap_compress()
> --
>
> commit a77cc3e636d5134b6371aa977bb1025c031583c2
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Batched zswap_compress() for storing large folios in batches.
>
> This commit replaces the per-page zswap_compress() call in
> zswap_store_pages() with a batched zswap_compress() and
> zswap_update_entries() that compress up to ZSWAP_MAX_BATCH_SIZE pages per
> batch using a per-CPU scatterlist table mapped to destination buffers.
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 5e1fb5624ffb8..56354a568bad0 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> [ ... ]
> > @@ -949,6 +971,26 @@ static int zswap_cpu_comp_prepare(unsigned int cpu=
, struct hlist_node *node)
> >               }
> >       }
> >
> > +     acomp_ctx->comp.sg_table =3D kmalloc(sizeof(*acomp_ctx->comp.sg_t=
able),
> > +                                        GFP_KERNEL);
> > +     if (!acomp_ctx->comp.sg_table) {
> > +             ret =3D -ENOMEM;
> > +             goto req_fail;
> > +     }
> > +
> > +     if (sg_alloc_table(acomp_ctx->comp.sg_table, ZSWAP_MAX_BATCH_SIZE=
,
> > +                        GFP_KERNEL)) {
> > +             ret =3D -ENOMEM;
> > +             goto req_fail;
> > +     }
> > +
> > +     /*
> > +      * Statically map the per-CPU destination buffers to the per-CPU
> > +      * SG lists; crucial for performance.
> > +      */
> > +     for_each_sg(acomp_ctx->comp.sg_table->sgl, sg, ZSWAP_MAX_BATCH_SI=
ZE, i)
> > +             sg_set_buf(sg, acomp_ctx->comp.buffers[i], PAGE_SIZE);
> > +
> [ ... ]
> > @@ -965,88 +1007,179 @@ static int zswap_cpu_comp_prepare(unsigned int =
cpu, struct hlist_node *node)
> [ ... ]
> > +static bool zswap_compress(struct zswap_store_context *zc)
> > +{
> > +     u8 nr_batch_pages, batch_start, comp_batch_iter;
> > +     struct scatterlist *sg, *dst_sg;
> > +     unsigned int slen;
> > +     int err;
> >
> >       /*
> > +      * @nr_batch_pages is constrained by the per-CPU comp_ctx's compr=
essor
> > +      * batch size and the @zc->nr_pages in this store batch. @slen in=
dicates
> > +      * the total source length bytes for @nr_batch_pages.
> >        */
> > +     nr_batch_pages =3D min(zc->comp_ctx->compr_batch_size, zc->nr_pag=
es);
> >
> >       /*
> > +      * Compress the @nr_pages in @folio starting at index @folio_star=
t
> > +      * in batches of @nr_batch_pages.
> >        */
> > +     for (batch_start =3D 0; batch_start < zc->nr_pages;
> > +          batch_start +=3D nr_batch_pages) {
> > +             /*
> > +              * Clamp the last iteration's batch size if the compresso=
r's
> > +              * batch_size does not evenly divide @zc->nr_pages.
> > +              */
> > +             nr_batch_pages =3D min(nr_batch_pages, zc->nr_pages - bat=
ch_start);
> > +             slen =3D nr_batch_pages * PAGE_SIZE;
> > +
> > +             /*
> > +              * Send @nr_batch_pages to crypto_acomp for compression:
> > +              *
> > +              * These pages are in @zc->folio's range of indices in th=
e
> > +              * interval:
> > +              *     [@zc->folio_start + @batch_start,
> > +              *      @zc->folio_start + @batch_start + @nr_batch_pages=
).
> > +              *
> > +              * The source folio pages in the batch are directly submi=
tted to
> > +              * crypto_acomp via acomp_request_set_src_folio().
> > +              */
> > +             acomp_request_set_src_folio(zc->comp_ctx->areq.req, zc->f=
olio,
> > +                             (zc->folio_start + batch_start) * PAGE_SI=
ZE,
> > +                             slen);
> > +
> > +             dst_sg =3D zc->comp_ctx->sg_table->sgl + batch_start;
> > +             dst_sg->length =3D slen;
>
> [Severity: High]
> Does setting only dst_sg->length =3D slen overrun acomp_ctx->comp.buffers=
[]
> and leave dst_sg[1 .. nr_batch_pages - 1].length uninitialized when
> nr_batch_pages > 1?
>
> Each entry in acomp_ctx->comp.sg_table->sgl is mapped to a single
> PAGE_SIZE buffer in acomp_ctx->comp.buffers[i], and earlier runs overwrit=
e
> each entry's sg->length with compressed lengths or negative error codes.
> When a batching compressor runs with nr_batch_pages > 1, dst_sg[0].length
> is set to nr_batch_pages * PAGE_SIZE (exceeding its PAGE_SIZE buffer),
> while dst_sg[1 .. nr_batch_pages - 1].length are not reset to PAGE_SIZE.
> If the compressor fails when zc->wb_enabled is true without updating
> dst_sg[1 .. nr_batch_pages - 1].length, any entry still holding a stale
> compressed length (0 < sg->length < PAGE_SIZE) from a previous call will
> skip the PAGE_SIZE fallback and cause zswap_update_entries() to store
> stale data from the previous folio.
>
> Each of the nr_batch_pages scatterlist entries in dst_sg needs its length
> reset to PAGE_SIZE before crypto_acomp_compress().

Summary:
=3D=3D=3D=3D=3D=3D=3D=3D
Batching compressors that result in this code seeing
zc->nr_batch_pages > 1, need to set the individual SG->lengths in the
list starting at dst_sg, to contain the result of the respective
page's compression status in the batch. crypto_acomp_compress() for
the batch will return a negative error in "err", however, each *page
in the batch* could have compressed successfully or compressed with an
error.

The code in patch 8 is handling this contract correctly, for both
non-batching compressors like ZSTD and for batching compressors.

For a reference implementation of how a batching compressor should
handle this contract, please see patch 16/26 in [3]:

[3]: https://patchwork.kernel.org/project/linux-mm/cover/20260125033537.334=
628-1-kanchana.p.sridhar@intel.com/

This is the reference implementation for iaa that correctly handles
this for batch compression, for instance:

+static __always_inline int iaa_comp_submit_acompress_batch(
+ struct iaa_compression_ctx *ctx,
+ struct iaa_req *parent_req,
+ struct iaa_req **reqs,
+ int nr_reqs,
+ unsigned int unit_size)
+{
+ struct sg_page_iter sgiter;
+ struct scatterlist *sg;
+ int i, err, ret =3D 0;
+
+ __sg_page_iter_start(&sgiter, parent_req->src, nr_reqs,
+     parent_req->src->offset/unit_size);
+
+ for (i =3D 0; i < nr_reqs; ++i, ++sgiter.sg_pgoffset) {
+ sg_set_page(reqs[i]->src, sg_page_iter_page(&sgiter), PAGE_SIZE, 0);
+ reqs[i]->slen =3D PAGE_SIZE;
+ }
+
+ /*
+ * Prepare and submit the batch of iaa_reqs to IAA. IAA will process
+ * these compress jobs in parallel.
+ */
+ for_each_sg(parent_req->dst, sg, nr_reqs, i) {
+ sg->length =3D PAGE_SIZE;
+ reqs[i]->dst =3D sg;
+ reqs[i]->dlen =3D PAGE_SIZE;
+
+ err =3D iaa_comp_acompress(ctx, reqs[i]);
+
+ if (likely(err =3D=3D -EINPROGRESS)) {
+ reqs[i]->dst->length =3D -EAGAIN;
+ } else if (unlikely(err)) {
+ reqs[i]->dst->length =3D err;
+ ret =3D -EINVAL;
+ } else {
+ reqs[i]->dst->length =3D reqs[i]->dlen;
+ }
+ }
+
+ return ret;
+}
+

Details:
=3D=3D=3D=3D=3D=3D=3D=3D
For additional context, reiterating some of my earlier responses to
Sashiko's comments.

v2 7/8 response:

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
> > +             /*
> > +              * The per-CPU @zc->comp_ctx->sg_table scatterlists are s=
tatically
> > +              * mapped to the per-CPU dst @buffers at pool creation ti=
me.
> > +              * There are ZSWAP_MAX_BATCH_SIZE per-CPU SG lists and ds=
t
> > +              * buffers allocated for all compressors.
> > +              */
> > +             acomp_request_set_dst_sg(zc->comp_ctx->areq.req, dst_sg, =
slen);
>
> [Severity: High]
> Isn't dst_sg an unterminated scatterlist slice whenever
> batch_start + nr_batch_pages < ZSWAP_MAX_BATCH_SIZE?
>
> sg_alloc_table() only sets SG_END on sgl[ZSWAP_MAX_BATCH_SIZE - 1], so
> passing dst_sg as req->dst leaves sg_nents(req->dst) equal to
> ZSWAP_MAX_BATCH_SIZE - batch_start (4, 3, or 2 instead of nr_batch_pages)=
.
> In-tree hardware acomp drivers rely on sg_nents(req->dst):
> iaa_comp_acompress() falls back to software deflate whenever
> sg_nents(req->dst) > 1 (affecting all order-0 folios and 3 of every 4
> pages in a batch), while __qat_bl_sgl_to_bufl() and
> hisi_acc_sg_buf_map_to_hw_sgl() walk and DMA-map all sg_nents(req->dst)
> entries up to sgl[3] using their sg->length fields, which can still hold =
a
> negative errno such as (unsigned int)-ENOSPC (~4 GiB) left behind by a
> prior failed batch.

Great analysis, Sashiko. Patch 11/26 in [3] sets up the iaa compressor
to handle exactly this scenario [4]. Then, you can understand how [4]
sets up the batching architecture in zswap to work with iaa's
batching, in [5]:

[4]: https://patchwork.kernel.org/project/linux-mm/patch/20260125033537.334=
628-12-kanchana.p.sridhar@intel.com/
[5]: https://patchwork.kernel.org/project/linux-mm/patch/20260125033537.334=
628-17-kanchana.p.sridhar@intel.com/

Any batching compressor must adapt to work with the new architecture.

zswap with ZSTD already works and demonstrates good performance
improvements with this architecture.

>
> > +
> > +             err =3D crypto_wait_req(crypto_acomp_compress(zc->comp_ct=
x->areq.req),
> > +                                   &zc->comp_ctx->areq.wait);
> > +
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
> > +              */
> > +             if (err && !zc->wb_enabled)
> > +                     goto compress_error;
> > +
> > +             /*
> > +              * For each output SG list in @acomp_ctx->req->sg_table->=
sgl,
> > +              * the @sg->length should be set to either the page's com=
pressed
> > +              * length (success), or it's negative value compression e=
rror.
> > +              */
> > +             for_each_sg(dst_sg, sg, nr_batch_pages, comp_batch_iter) =
{
> > +                     if (((int)sg->length <=3D 0) || (sg->length >=3D =
PAGE_SIZE)) {
> > +                             if (!zc->wb_enabled) {
> > +                                     if (sg->length =3D=3D PAGE_SIZE)
> > +                                             sg->length =3D -ENOSPC;
> > +                                     else if (WARN_ON_ONCE(!sg->length=
 || sg->length > PAGE_SIZE))
> > +                                             sg->length =3D -EINVAL;
> > +                                     goto compress_error;
> > +                             }
> > +
> > +                             sg->length =3D PAGE_SIZE;
> > +                     }
> > +             }
> >       }
> >
> > +     return zswap_update_entries(zc);
> >
> > +compress_error:
> > +     for_each_sg(dst_sg, sg, nr_batch_pages, comp_batch_iter) {
> > +             if ((int)sg->length < 0) {
> > +                     if ((int)sg->length =3D=3D -ENOSPC)
> > +                             zswap_reject_compress_poor++;
> > +                     else
> > +                             zswap_reject_compress_fail++;
> > +             }
> > +     }
> >
> > +     return false;
> >  }
>
> [Severity: Medium]
> Won't evaluating sg->length > PAGE_SIZE on an unsigned int trigger
> WARN_ON_ONCE() whenever sg->length holds a negative error code?
>
> Because sg->length is unsigned, a negative error code in sg->length (such
> as -ENOSPC from a failed page in a batch) satisfies sg->length > PAGE_SIZ=
E
> when !zc->wb_enabled, firing a spurious WARN_ON_ONCE() and overwriting th=
e
> error code with -EINVAL so compress_error increments
> zswap_reject_compress_fail instead of zswap_reject_compress_poor.

Yes, I will disambiguate the (sg->length > PAGE_SIZE) check for error
code vs. a real case of an invalid length in the next rev. Thanks for
the catch.

> Conversely, if crypto_acomp_compress() returns an early request-level
> error in err before writing negative error codes into dst_sg->length,
> jumping to compress_error leaves all sg->length values positive and
> returns false without incrementing either rejection counter.

This is not expected to happen today for non-batching compressors, as
explained above. Batching compressors need to follow the architecture
described in "Summary" above, to correctly handle this. A reference
implementation for how the iaa batching compressor could handle this
is also provided in "Summary".


>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120041906.57=
85-1-kanchanapsridhar2026@gmail.com?part=3D8

