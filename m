Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34C04606A6D5
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=H2F8H0nv
Received: by kanga.kvack.org (Postfix)
	id 2A46D6B05B9; Fri, 20 Nov 2026 14:28:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254E46B05BA; Fri, 20 Nov 2026 14:28:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143726B05BB; Fri, 20 Nov 2026 14:28:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D31036B05B9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:28:16 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED146160125
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:28:15 +0000 (UTC)
X-FDA: 85456483350.16.1754AC3
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id EF34C100006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:28:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=H2F8H0nv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795202894;
	b=zfeV+l5YIXnn+46Ue9IJibfzdEEwQGOUWT3Y4QQd3RkCfntZQk1DI5EmGWYP6vSH5MO2k3
	Gep56tIQIjEGHdD2Ml4Tv7jfGb4KBlwCpnBjzqCdbzQ185dDxfuJmALuN0kOcsCo2/QT+g
	faPhxpapWJ5y5pw4OTmam6iNMCViUCM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795202894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gTSQmZl/zKK0zXMmK+A31LEN+NDNPEQL27tBFK3Clmw=;
	b=kKTxT6UXML0fOxwdbhEwrUbZw9iP16hlSyIjMxDtquZ3bJdogmnxUSuQ2vUxwHVBsWiMqk
	1otB+kKEuLlL1OOT0jrzfGwF/Li3+kXJzl00EycJTBkTX/hMiu5ZX+n7DuS7zNvlOV6Fc1
	Werq4FjQb339moRDTflvqve3j4aEHzU=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=H2F8H0nv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5c15956ce07so2212796e87.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:28:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795202892; cv=none;
        d=google.com; s=arc-20260327;
        b=cBx9b0I9hlU2B98HDo9MvQ0aripci7U0+WeGzAnDlxua2vJa1z0Pvc9z0vRsf1vYFA
         ogvcX3ZAwH8bm/5MQlOwoI4Pt57N1579fsOsnf2eo/273JJYVNkH/xAsb0j9vXGYuPcy
         odTZ9Dt5UoD+P1RdgiujEk84AAxGngan5xb02vmuhJx/TXWQd5M+4KpxnuJB/1J4wI/k
         S6jnXslg//VZjo7LHxjJrlFds8s54QPOvtVZKoIwrSV6S9npK/35DwAOKHRQHwb3C5j2
         JqFyLBxWoYFusdmhr//n4ofJcRPgesU7PGOdCiJxylmBkCJgxm4I/3wKSy93UP8XCyNe
         JK6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gTSQmZl/zKK0zXMmK+A31LEN+NDNPEQL27tBFK3Clmw=;
        fh=0pDDiTncAD5G+KcAgLKHYg/+SxP2URoYUsg1RgIFUMM=;
        b=rmufgUgG0vvqGPk0g8C+MFhMZC2KwCSPM3jY6jn0ZTEn72OZ3LJ4/PYz0qeL8oExgY
         9VI7BBra1kVVeF6f1TGElkct4Eu/m98vN3vB6cIuw89z/L8LNTQ33aTtK1JZ1mtxqcNa
         HhY8HLBx9zlkwweGF7yx6x5gBxoG/z0r/YSYgcXTZH89bPK5yuZL1U/0gfEuWosjQhPZ
         YNIlvNF/3vbKzrBNq14Ah3PTo/wMJzNjUFgM7D986p/rOWHtMmCx1X0ISpPhJWBgcll9
         wOTNqaRyQbn22vO5eCD1MCLE69rEdMnW3kdKlPvvnIfj56D6Lt1K8i7JRgBXA/pMEqk3
         OlxQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795202892; x=1795807692; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gTSQmZl/zKK0zXMmK+A31LEN+NDNPEQL27tBFK3Clmw=;
        b=H2F8H0nvqasU6mb1sD61O5QRMZjfoB/cuWZVNxi0L3QlsLOHFoE40uxmUkPE29NQcJ
         KVM/zhqXp2z0clZ0UhFuruaHrJlovDxBsrZIjdevCKkhkvgl37Gjm462FP/lih9j0/c5
         MCYv6SXadsLamMKFypwO1AADzFMfoZ2Sd1Ydig9RTjnDxPQGT2h0rknIFCw2e09aq4ZA
         HZyGcmv4MM9TflDv9NxgSR3ICKGOUQsieN8IJ/G3Dqk5LaI+tZh/VEKl4qOc8xxkc68q
         abI9L52iqZKq7teOgf1D7gzne7TIkl0gv+aqi3caNeKejwCj50ux8e1sql4OTEFtrQ25
         fqVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795202892; x=1795807692;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gTSQmZl/zKK0zXMmK+A31LEN+NDNPEQL27tBFK3Clmw=;
        b=i0LafQN2BRAb4kVDYPTDE4ONK3aZu4jRv5w4z1912C9vaEE0PLgcgpopnYVaCH+RKf
         x5Ewezz7x5TpKsjJhd2wkQxkJ7uL6To1ZJMAqKf6rP0WpWKBW7JyAoP8DvcdcKHTM23o
         s4SXqQWt9FwWeHmwml1gr0w6MyC8WAsxEH27K/JwflglOrcEnRw8g3uqhhMN4UGtP9RX
         I7TvzBe5fBMDEwbI5q9v6jQOO0/RCVOi1nUTsgryfXfkpYiVYwo5OS16SoXetFd2YccQ
         e27zo0lIsjOwDqW0O9A1MhTRuOUnJoog9EYDh0hVSLp1oyXlwLa9N/kxpk/uX4L56rFr
         pk3g==
X-Forwarded-Encrypted: i=1; AL+hErG58XMXRr2fZMKck9eYfhSPk9TjpvSTDzCf79X9BefYLAzEv77rICKKANplyyRl26koQHTGGI4BVg==@kvack.org
X-Gm-Message-State: APuU4Z9+PX+3PLmva73AU07C7xVCpe+Nj7uKpIuG71qmVlkyGHX4QXJ6
	H+RQT1+BAH266bbNdKUIyq4RI4SJ3NejIJKoHM0AnX07liwtZhJx6qLIOWwGORnh7p2zxG+t0AG
	yLubK0gdHHeKHQ+uK7iMdGE8cMt0xrco=
X-Gm-Gg: AZFdTZdKNoD6cILaSOI+yUYkJvCX9HmkGiDWgWDlqtLp096d9JzHX6Rpny7BCJzoJQT
	K//isW0Z5Y5FjUuBG6+S1RZUE4jTFSCbKwm6h9+isTusKZG7T0ZXkfi56MUYxiVDOclmZf8GJ8Q
	RZmNiivzb1kgMCVrrXldZm7Ut5BrMHVnUHXp/WacIA52tHvl0YDSCzebHhY9EN1zAS+gRwxLGG8
	y00bKcVsXapzvAkM92Rnmi7kcUrL5HbZtLCe7SrlDS4hm8+IffljmdMG2QqGZdn7hpVu533d9x1
	ZEB35MFTQptliXBgrV09SFXQrLkkgS15Xyx+GvCSixv9QRsngJKcaYvPW7opDI5NEMX5U+ahKSy
	VGXITpwu2s9toj57a65zZiRs9cF4OjUR0vOqF
X-Received: by 2002:a05:6512:32c8:b0:5c1:46f8:913c with SMTP id
 2adb3069b0e04-5c1b7c00f96mr1590361e87.20.1795202892209; Fri, 20 Nov 2026
 11:28:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-9-kanchanapsridhar2026@gmail.com> <sashiko-outbox-202714@kernel.org>
 <CACpmpofRbbRuRQfx0wd_xnitwz-TfWZ4_XfgR-y0HYPsN3ZFpA@mail.gmail.com>
In-Reply-To: <CACpmpofRbbRuRQfx0wd_xnitwz-TfWZ4_XfgR-y0HYPsN3ZFpA@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 11:27:59 -0800
X-Gm-Features: Aa3M54qHyMHAs4REx3hc_QYhZyScUZM2KH4BsGOU3VT9vIU15C1WE7ikT83enGg
Message-ID: <CACpmpof-tnHWn=mqGEm=xAGi039Ewh8Zv5=n+5QOrvLjefv3TA@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] mm: zswap: Batched zswap_compress() for storing
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EF34C100006
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: xmqs41hfotzzmfen3e1c1jmrwbeq4c4w
X-HE-Tag: 1795202893-106462
X-HE-Meta: U2FsdGVkX18Fnf90abUap8lnR57owE4jc0B9r6tU4gXw9f9ozxlJ8JyXUx/DJbmFayewNKf6lnAKCzXDzM4Rdn33prEzrUzdjciIqBQRhMw9RqCcH5rM39mql9TD3cNyolNOszuQO7ROoGt6+AR4T7CyLfMjDDsVBlHLb2TPyQI09OqnnqwSyXrn0aNJAyzKek6IH1jBajZZ4L4o96xVzArfZ4lFJn1oKADfkLtDrHfG6TTMm0B19FaBfCPLOXUo3XCSp/rxikSZGTC3s7l4HMr+RIwJe3v467nzLKLzuy/Df90rZ8Xo5HOciuYBrRtOcKbd7PIzrlDp8wwc11nVW2KGGNaEiRjwt451pPmezgmpbWxE4BMekWVyMIj+fTEdt+3K0PW6Rb0gijcFAM/CDKnYZwRcQ+tN9bD9iYW1zVjXz/k6VsDTFbo8F9zhIDOfOhU/twqqEQEN8pPtGyhGVZl5VddJEbHv8LyaKMQ6YFbi7ULSW423StLErRatmnWYU2xIAdimvAtpQDQnwQcY/nbwKYrE0IC9xjdONa5o+PzDQv5eYDI3NIRIfctPPKmdDTwfOV1YtiZcR2qp6FFnF7ZDATFJQoyaQU3iZLokt4WEgkpte5EsBch4ijQ3YkuigK80TBLviZejsi0zjKpc3Lof+9WJg7144ZUjHCq7Ez/iW0A0zMYai2NZ+tLLbaWsJ37fnbBT3U6m+JMfI9UMnK5uSP6lQtObCcAAp0Z7wE1LxwyVPI/E1CAY0lpsXu2Cdke2EJ5y6+tqep+EkBqHEHatJagsEvA+bSZNugQFXw03lFOmYnenE/V5q/g/YaavO9clqzMigtctKWHLUuL4/aNtJphX7KiTzgz67ilQ4DJxwse3H+Dxg/x82Mfx730xDA4LmHldwJlibeTvYsERpKDWIk9f88CvZUZE3cKDiSEeAsDcZ8eh+7r9Muh20gdVyqv7HAY7TOK4wP0AmwK
 dcmOPu0j
 QEQwPujgZAXP+8zAXiLIpOvVVWHnquvYN1Gr11ocooTbzLqKP0rW226J7j4SQA9KiJr8DRVnBkGkGQTPPB0n/31+bRO73wh4UhmGCwvIgsYK7SOPdIKHf42iR3HtJkQOdfdmcei0g5Z7yWtZd8bNv8V2P2uW+RYxNIbkOitXQtsheyEl6n/kJLec6jIOqyXehZ7jqUL5q9Rdl3q4GF04e1j4QOIIp/uhPe2s3f61VDkyS9agNXQLXUjLb++Rcoc1Ky+vNQERwBt1NcG3HRIlU9F5vSSbs0VUkbvARkoHI7mP4E5NLAmNE2wpbWq7YSROeLGVn8GmPXYvJnegxIee6siPXRVxyHx3Iuc+VOcHUtbwykpojBUdSkRzqZX1FWp2wxMX+f4bvGhFEz3aWwgyqFSEa9THxuNNZUKz7TL1v8KWdg3uHW5ZHK7pb+9zvdQhZtwXbQZOxYRd39qEsMJ0q6MX0Qfw0SG+wJ+3WLjvrNv3Qhl+r9esgxFcLseE/UaA/dR72/0oMJLe4adg9GMOQesPnyAp4QVkgj9lsHsnnyiw4ZG91S58WlDF++mnf0iylgoTVGGuQxfd59/dy6CKpyLQl4GKIGW9hUzCaSEgs/H3HHGTLNwwVwDhdkEAu8RAzF6jkSiSUVms84k40cPk2v4qjnLNqdmfWdgJcWNIRGAntNW4NrP98sajNtex87jESucr9YUidUlXZu3XzvKJEYbbdRaA+GZhf8Da7FdeQgCXiQI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 11:24=E2=80=AFAM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Fri, Nov 6, 2026 at 11:25=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
> >
> > Thank you for your contribution! Sashiko AI review found 3 potential
> > issues to consider:
> > - [High] mm: zswap: corrupted and unterminated dst scatterlist in
> >   zswap_compress()
> > - [Medium] mm: zswap: unclamped nr_batch_pages on remainder batch in
> >   zswap_compress()
> > - [Medium] mm: zswap: unsigned sg->length check mishandles negative
> >   errors in zswap_compress()
> > --
> >
> > commit 212f5740068394b4c82b7b1e5452b1ac6625322f
> > Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> >
> > mm: zswap: Batched zswap_compress() for storing large folios in batches=
.
> >
> > This commit replaces per-page zswap_compress() calls with a batched
> > implementation that compresses up to ZSWAP_MAX_BATCH_SIZE pages using a
> > per-CPU scatterlist table and updates the batch entries in
> > zswap_update_entries().
> >
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index 5ef1ae67e67a9..45fd8dfaf916d 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> >
> > [ ... ]
> >
> > > @@ -898,6 +914,7 @@ static int zswap_cpu_comp_prepare(unsigned int cp=
u, struct hlist_node *node)
> >
> > [ ... ]
> >
> > > +     acomp_ctx->comp.sg_table =3D kmalloc(sizeof(*acomp_ctx->comp.sg=
_table),
> > > +                                        GFP_KERNEL);
> > > +     if (!acomp_ctx->comp.sg_table) {
> > > +             ret =3D -ENOMEM;
> > > +             goto req_fail;
> > > +     }
> > > +
> > > +     if (sg_alloc_table(acomp_ctx->comp.sg_table, ZSWAP_MAX_BATCH_SI=
ZE,
> > > +                        GFP_KERNEL)) {
> > > +             ret =3D -ENOMEM;
> > > +             goto req_fail;
> > > +     }
> > > +
> > > +     /*
> > > +      * Statically map the per-CPU destination buffers to the per-CP=
U
> > > +      * SG lists; crucial for performance.
> > > +      */
> > > +     for_each_sg(acomp_ctx->comp.sg_table->sgl, sg, ZSWAP_MAX_BATCH_=
SIZE, i)
> > > +             sg_set_buf(sg, acomp_ctx->comp.buffers[i], PAGE_SIZE);
> >
> > [ ... ]
> >
> > > +static bool zswap_compress(struct zswap_store_context *zc)
> > > +{
> > > +     u8 batch_start, comp_batch_iter;
> > > +     struct scatterlist *sg, *dst_sg;
> > > +     int err;
> > >
> > >       /*
> > > -      * it maybe looks a little bit silly that we send an asynchrono=
us request,
> > > -      * then wait for its completion synchronously. This makes the p=
rocess look
> > > -      * synchronous in fact.
> > > -      * Theoretically, acomp supports users send multiple acomp requ=
ests in one
> > > -      * acomp instance, then get those requests done simultaneously.=
 but in this
> > > -      * case, zswap actually does store and load page by page, there=
 is no
> > > -      * existing method to send the second page before the first pag=
e is done
> > > -      * in one thread doing zswap.
> > > -      * but in different threads running on different cpu, we have d=
ifferent
> > > -      * acomp instance, and compression and decompression use separa=
te
> > > -      * requests, so multiple threads can do (de)compression in para=
llel.
> > > +      * @nr_batch_pages is constrained by the per-CPU comp_ctx's com=
pressor
> > > +      * batch size and the @zc->nr_pages in this store batch. @slen =
indicates
> > > +      * the total source length bytes for @nr_batch_pages.
> > >        */
> > > +     zc->nr_batch_pages =3D min(zc->comp_ctx->compr_batch_size, zc->=
nr_pages);
> > > +     zc->slen =3D zc->nr_batch_pages * PAGE_SIZE;
> > >
> > >       /*
> > > +      * Compress the @nr_pages in @folio starting at index @folio_st=
art
> > > +      * in batches of @nr_batch_pages.
> > >        */
> > > +     for (batch_start =3D 0; batch_start < zc->nr_pages;
> > > +          batch_start +=3D zc->nr_batch_pages) {
> >
> > [Severity: Medium]
> > Can zc->nr_batch_pages exceed the remaining pages in the store batch on=
 the
> > final loop iteration?
> >
> > zc->nr_batch_pages and zc->slen are computed once before the loop inste=
ad
> > of being clamped to zc->nr_pages - batch_start on each iteration.  If a
> > compressor has a compr_batch_size that does not evenly divide zc->nr_pa=
ges
> > (for example, compr_batch_size =3D=3D 3 with zc->nr_pages =3D=3D 4), th=
e final
> > iteration reads past the end of the folio batch and walks past the SG_E=
ND
> > terminator of zc->comp_ctx->sg_table->sgl in for_each_sg(), causing a N=
ULL
> > pointer dereference when sg_next() returns NULL.
>
> Thanks for catching this. I have resolved this and will include it
> when I submit the next revision.

This has been resolved in v4 submitted yesterday.

>
> >
> > > +             /*
> > > +              * Send @nr_batch_pages to crypto_acomp for compression=
:
> > > +              *
> > > +              * These pages are in @folio's range of indices in the =
interval
> > > +              *     [@folio_start + @batch_start,
> > > +              *      @folio_start + @batch_start + @nr_batch_pages).
> > > +              *
> > > +              * The source folio pages in the batch are directly sub=
mitted to
> > > +              * crypto_acomp via acomp_request_set_src_folio().
> > > +              */
> > > +             acomp_request_set_src_folio(zc->comp_ctx->areq.req, zc-=
>folio,
> > > +                             (zc->folio_start + batch_start) * PAGE_=
SIZE,
> > > +                             zc->slen);
> > > +
> > > +             dst_sg =3D zc->comp_ctx->sg_table->sgl + batch_start;
> > > +             dst_sg->length =3D zc->slen;
> > > +
> > > +             /*
> > > +              * The per-CPU @zc->comp_ctx->sg_table scatterlists are=
 statically
> > > +              * mapped to the per-CPU dst @buffers at pool creation =
time.
> > > +              * There are ZSWAP_MAX_BATCH_SIZE per-CPU SG lists and =
dst
> > > +              * buffers allocated for all compressors.
> > > +              */
> > > +             acomp_request_set_dst_sg(zc->comp_ctx->areq.req,
> > > +                                      dst_sg, zc->slen);
> >
> > [Severity: High]
> > Does setting dst_sg->length =3D zc->slen corrupt the per-CPU scatterlis=
t table
> > in zc->comp_ctx->sg_table?
> >
> > In zswap_cpu_comp_prepare(), each entry in sg_table->sgl is mapped to a
> > separate PAGE_SIZE buffer and only sgl[ZSWAP_MAX_BATCH_SIZE - 1] has SG=
_END
> > set.  During compression, each entry's sg->length is overwritten with t=
he
> > compressed size or a negative error code.
> >
> > When zc->nr_batch_pages > 1, setting dst_sg->length =3D zc->slen tells =
the
> > compressor that dst_sg[0]'s single PAGE_SIZE buffer is nr_batch_pages *
> > PAGE_SIZE bytes long, while dst_sg[1 .. nr_batch_pages - 1].length are =
never
> > reset to PAGE_SIZE and retain stale lengths or negative error codes fro=
m the
> > previous batch.  If crypto_acomp_compress() fails while zc->wb_enabled =
is
> > true without updating every entry's sg->length, any entry still holding=
 a
> > stale length in (0, PAGE_SIZE) bypasses the sg->length >=3D PAGE_SIZE c=
heck
> > and causes zswap_update_entries() to store stale data from the previous
> > folio.
> >
> > In addition, because SG_END is only set on sgl[3], passing dst_sg =3D s=
gl +
> > batch_start leaves 4 - batch_start entries linked in req->dst.  Hardwar=
e
> > acomp drivers that check sg_nents(req->dst) or DMA-map every entry in t=
he
> > scatterlist walk past the current batch into trailing entries whose
> > sg->length may still hold PAGE_SIZE or (unsigned int)-ENOSPC (0xffffffe=
4)
> > from an earlier failed compression.
>
> Sashiko raised this in v2 code review. Please see my follow up comments i=
n:
>
> https://lore.kernel.org/all/CACpmpofOE797D7f4YGZEJ2jtHn08d9Jo8Ya3cdV8h9UL=
5hUd9A@mail.gmail.com/
>
> and let me know if this explains things better. Thanks.
>
> >
> > > +
> > > +             err =3D crypto_wait_req(crypto_acomp_compress(zc->comp_=
ctx->areq.req),
> > > +                                   &zc->comp_ctx->areq.wait);
> > > +
> > > +             /*
> > > +              * If a page cannot be compressed into a size smaller t=
han
> > > +              * PAGE_SIZE, save the content as is without a compress=
ion, to
> > > +              * keep the LRU order of writebacks.  If writeback is d=
isabled,
> > > +              * reject the page since it only adds metadata overhead=
.
> > > +              * swap_writeout() will put the page back to the active=
 LRU list
> > > +              * in the case.
> > > +              */
> > > +             if (err && !zc->wb_enabled)
> > > +                     goto compress_error;
> > >
> > > +             /*
> > > +              * For each output SG list in @acomp_ctx->req->sg_table=
->sgl,
> > > +              * the @sg->length should be set to either the page's c=
ompressed
> > > +              * length (success), or it's negative value compression=
 error.
> > > +              */
> > > +             for_each_sg(dst_sg, sg, zc->nr_batch_pages, comp_batch_=
iter) {
> > > +
> > > +                     if (sg->length <=3D 0 || sg->length >=3D PAGE_S=
IZE) {
> > > +                             if (!zc->wb_enabled) {
> > > +                                     if (sg->length =3D=3D PAGE_SIZE=
)
> > > +                                             sg->length =3D -ENOSPC;
> > > +                                     else if (WARN_ON_ONCE(!sg->leng=
th || sg->length > PAGE_SIZE))
> > > +                                             sg->length =3D -EINVAL;
> > > +                                     goto compress_error;
> > > +                             }
> > > +
> > > +                             sg->length =3D PAGE_SIZE;
> > > +                     }
> > > +             }
> > >       }
> > >
> > > +     return zswap_update_entries(zc);
> > >
> > > +compress_error:
> > > +     for_each_sg(dst_sg, sg, zc->nr_batch_pages, comp_batch_iter) {
> > > +             if ((int)sg->length < 0) {
> > > +                     if ((int)sg->length =3D=3D -ENOSPC)
> > > +                             zswap_reject_compress_poor++;
> > > +                     else
> > > +                             zswap_reject_compress_fail++;
> > > +             }
> > > +     }
> > > +
> > > +     return false;
> > >  }
> >
> > [Severity: Medium]
> > Does checking sg->length without casting to int mishandle negative
> > compression error codes when !zc->wb_enabled?
> >
> > scatterlist.length is an unsigned int, so a negative error code stored =
in
> > sg->length (such as -ENOSPC) is never <=3D 0 and instead triggers
> > WARN_ON_ONCE(!sg->length || sg->length > PAGE_SIZE) and overwrites
> > sg->length with -EINVAL before compress_error: checks for -ENOSPC.
> > Conversely, if crypto_acomp_compress() returns an error before setting
> > negative values in sg->length, jumping directly to compress_error: find=
s no
> > entries with (int)sg->length < 0 and increments neither rejection count=
er.
>
> Thanks. I have resolved this.
>
>
> >
> > --
> > Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.=
7909-1-kanchanapsridhar2026@gmail.com?part=3D8

