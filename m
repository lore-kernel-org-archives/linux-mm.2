Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B694606A6F1
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q8DO47cF
Received: by kanga.kvack.org (Postfix)
	id 6BAD86B05B2; Fri, 20 Nov 2026 14:24:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B896B05B3; Fri, 20 Nov 2026 14:24:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A686B05B4; Fri, 20 Nov 2026 14:24:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 290226B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:24:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E81A4019F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:24:36 +0000 (UTC)
X-FDA: 85456474152.02.8B4B0E0
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id B76384000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:24:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Q8DO47cF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795202674;
	b=LIna8M7lK5lOqajmXuc2OUmVuhK/UFLa2VaNSNAZns9hsNz+nSPHZVO45f5QALpr3y+5ix
	kIeIxYWLbPBxx4yParZB2ispTPh7YEln2QRDkMqj9JDbERji5jAlV1hhbc/Bj78TqvVAB/
	nETHlIiSCGKEJHtdrFTGX8O3GwfhS24=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795202674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EqIWlPRmhQa/qTttZkxhbBZ2a0xxoQ3QCxHq+S0xpPA=;
	b=FGWg3A9Hwl2g5WswAZHs8lmim5MCbD0BoZ6ILtBQjCUBHd8fvbf3uXLB4luviu1zaf/Q4a
	v9oZni/LbZn3Ay1qmweeKQFYNvumlVpTD9JwTA2o45i2NrmARJY+jiFXHtWtJgwWMrFMrn
	HlmsjHGUc75vNIt+0L/7geqDlinqSME=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Q8DO47cF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5be3d5927ceso1798568e87.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:24:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795202673; cv=none;
        d=google.com; s=arc-20260327;
        b=U8Ot2iNppI9R0xl4n+JmOQioNaLUn3/JvSvMpT+kLf3FvSJegTJ+pmSAu1s3qoxGQy
         exUR3MWjcVhRINOmwyUzJf9fhvaMYZDeu3Y20pjsNCllDMxFzJsRW3eES+9WEC7b2tdj
         3yVID3hjzdtZdBGRfI8O/n2UgRgRIjYEunqKnljh+2ONi1CtLflvnTBystRxqIJXQlTZ
         L120GYSmLE3k2PLP3boJ5sorUmbJrhoGF+zZjHeH3PQKZ3iBhrV6iM+08HHDiIst0fbo
         h98moIkXgvNErNreCOezUv6mCOX5yxR6BhrBXBoJ21NhDNQEWzS/bx4OU+1S/VI/4wei
         VvVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EqIWlPRmhQa/qTttZkxhbBZ2a0xxoQ3QCxHq+S0xpPA=;
        fh=fnqQbyj9KRK2Ef/XU9YcZKzk7AoE1hvfLVvDjQ765dk=;
        b=HNkOnn4VUJIJGyfukkEwEcgrzlXpKG+U3Pnw37bhLcJXqFt+BGHBsH45HWkXZg/vnt
         bwLyv0W3ucAygFrHwMdTGi+N3ucEEjBUwZje9plyKgh3XHpgK+BLIdBQkDVofQlOkVVV
         7VtqQMG+deklq+ZOhp9MWSxldK0aykN4yo79+tKFnYxTJTZ5KV0JMQSwuSiL3e/NJHu3
         870Afjdo+fGXi4QhSuqemARtqY8TOKd7m+xAkWFAD3Q1WFhqygeGX7V6Cw+wcPBw0UzB
         zkdtxAR/IGYze70d/b7oeKugQqoKQGPa05orHF4LLmK7brlvj0gl0G4xrne0sbEVK88Q
         Ac3g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795202673; x=1795807473; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EqIWlPRmhQa/qTttZkxhbBZ2a0xxoQ3QCxHq+S0xpPA=;
        b=Q8DO47cF72a53atn4uVyE0WQfw2IAlJ00VZM6rdzj6mlLGi8BTEvZABkBZ4J9J7BZU
         8OzpfSRnEPZSh0UvOBoXqJ1fnoFA2hUVQbYyYUi4KUzKJ4ErV4Ir0Gd5leD2NNFkCkhi
         9I0v0uNDAU64JmZo7mjvj+dscjUs1sUMKdEDQijwcv2/y71pEV+DeQddmiivLHhCjz+Z
         pKQVgFrZCBGlkbkje63X0ip4B96ppvNVJ+qzvG9PbYhdFx3yKumqcWQef46K/2oYskse
         Godi3kqVSFjpknzI2btbfXGGhYdsp+pgPE8V9Tmia3+q5EAr2RvYa2CwBeBFVpFto7zo
         xHSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795202673; x=1795807473;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EqIWlPRmhQa/qTttZkxhbBZ2a0xxoQ3QCxHq+S0xpPA=;
        b=SA3JlIRR5Gk3/sgRMnDaN8tEOVa/g/8adkAjECPTG83G6fS/oJrZK4tW/AFuOFvxp6
         cTpJZMiSG7FwdncgTB1kXPH4sy8oeq3PuSiKPQkAaCNtwIKIuoT641dIhTsDGoc0JIa8
         AZuGSjoFmiCRBWnOlAFBR2rywrmnr54/BhidrYRrE5AilgbDBQn+b1Lzc1a93XdF/gm7
         2dFWa0niSUurCJ0lBgr7WPxLM7XFXAjy4f0yP0Cw7tP84nCZI2gcb4vWYd9FlVt3+Hb9
         oIt1AJnf6LRAWA7reGRcWcpdjXNQi71vwWbh8lHiMR8C/0OSGwuv5fQ2+YlwBUC5I3aj
         juiA==
X-Forwarded-Encrypted: i=1; AL+hErHvChY/d7fg/AwbIfEHv6qEuQd16Q8KYxn39xminJTRy890G7BPHdcpfDgUwiU7uL266PmWzFjvUg==@kvack.org
X-Gm-Message-State: APuU4Z+dGf8s3isFPj38Kj44OPfhqbJwl6gq4m8amh800kt0NilMVnQM
	EoF7OQn/zi7fl1Np7hrzwzABvQwvKMa4tnemRZDTtDGdoe7i2IP+2gF7QhHL/DwzcT53mqfQQkn
	wM0MqKrCvUyg3iaC5uNmfU4R5TsBb1qg=
X-Gm-Gg: AZFdTZdIo2VRrUiCleJ7K+KDb9oQkdVpVnmTstp95TVRSn0vRoMz5ve0sIunh1qUbPB
	oowUP62jOZgz+x2zWFNIW8OrULYJV/+JjMEw+mV3vf2IZlb1VU2gCqg0TXPStSRcHYyvcOG8FNF
	7BuaQQ8hBJhU+gltNPnboCEYlxHaSwviLqJoisRuehhkwDOyb1ncwOMceQdl5rYCx9NS/Q9T2Nz
	b4G8fdWlL77FJEUmzrl0cev0OhJ5L8GGAj2WVeJn645/P9JWB3Bs6lG29diriRyLS9KRL5/2ACF
	/lIAgR5sXrj1POfyLhS23KyOQoo/iRTZ6xPFti0+49IpSIQg/1mo+mKCy6h7aTKKqjiDGel+6p7
	8S2FonIvrBYFQnz7Y9Bzv8Ai5Om1ylAt7Ie25
X-Received: by 2002:a05:6512:a92:b0:5c0:a7f:3ee8 with SMTP id
 2adb3069b0e04-5c1bc6f6f92mr1247082e87.8.1795202671893; Fri, 20 Nov 2026
 11:24:31 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-4-kanchanapsridhar2026@gmail.com> <sashiko-outbox-202709@kernel.org>
In-Reply-To: <sashiko-outbox-202709@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 11:24:19 -0800
X-Gm-Features: Aa3M54rhTUbna5usUdb29tdk64fNtvutRquhcws5sDaGP6EBJACKMJdTqBzkNNQ
Message-ID: <CACpmpodxjJ3ZQt4xOsWfWQNjgMtPzKx0oGMy+mJTU1wxVWdMUw@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation wrapper.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: d1f3736n7j3sitb4i5m5896dzhhfmqh8
X-Rspam-User:
X-Rspamd-Queue-Id: B76384000A
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795202674-956137
X-HE-Meta: U2FsdGVkX19F2drEVqzKIg8GxZwDeYFpP4QpfF6JjU9tKJ+3uNA+JvC8hyhCI7qiHGNfas7v4pkiGRPRsQHku1zWtauBdGUQfm2Pxt943mivx0l2lkupnOS3GMox97Ev49FABVxjj7cC+kTNgh7TGm9NSXifd5Byo+/57VeGDkB9uOwsDWn8bV88pm4us0F+dbixGaBUxpYhjCUt/gmt1XJ8ZBDL0UeQGrFOZFQKRcLP57n+SkN9jnXeZxYRvGoUFeEjW0z8HuyhOPHmVPr5RwOWhvfBprJ5C4LN12JMbGdlGa6Ufd+7MobKbEekHU6U4pNvsmUiCIkZJBK7zVkNjc+/1Pqf+vTEIMNZUA/LGXt+ocx5H1vX2fKSHluOLlxw67J9reSFPCvjC6wBVHPQ7cGG62ZHjkbeTOM/+/aMDzjZGTysUvv3wLOKKqW+qKvBo6Br2tiQYh9FmyTf3+uV5lToQw/VY4KKgUkBE0EPJhmwy0tZ3FdDssWtOU2se/x7z8RmfoVQ7o8T6PTgsEoXBFZz0TPZElFDG/+lbm6ichpRGd2xRvUhw2v7RLpatsie88Fm2t0j60WDTqX8dN+pkb6Tty5NgCp3vbpvAIoTBvCpiuTmM3zRw0h+85NgodkaLsgJorQtsONNOgl6RTsMy4bEIqCgyZ9y++v1nrKhklxuA2jG5bTDoE+sFBAAZoJ9D7+BeoMUP17QBrFXWpqTWn8cH1bqtFoAEAfrHMwGAYaCaCFixohGi/QbX3HCc01i7y0SiyZNoDlG0zV33Ig1DCB5vCvkUHZ5XwFqdxUqqLEyfethiPUtIaDVrz+6sfoNo3QRMp2rMit1xxyrXDnFBXZ3EzilGBWhaNMwvj6WD+fWmGmjr/kBiNtljoN71qSwsBkAwU5RJgdvAtdPcvxa+Ro5YWJ+2v4IMMBn/rTUOaENq3sHSernV7oxDqx5iUDgropMf6yqO7EdCydRV0o
 QU7colE1
 cP5alPwkg//YKsDx1WJi9/aowhRNJBkC0gp7feZ9rKF3ZsRvtheGoJ6r+B8ItTbii102qh5cqf63/OYM8iwj/VmpOitw/oM0QyBwgrYluuB30nqJbVVBgrFYh1I2LshMS1g+13rFWDdH5yqtJy8rsWIRZw5ooWHX89O6x5lyQ/DA0yrfEuRg9bxBuJua/P6wjXFkaHa7hDhZk8gEqc4Vb8DBvUQ8pWjL/AvUwYrgHznTQfD8zpZHwD/E1QDqTmNBjV6a3yKgja1xJhkPfS8N0ffmKqkM7d/vGhcnRtm3mcv++znxDYH2WbgQweZSN7uHJ5FLF4o6g9Zh047dZDGrCMgtLUob7aZGyi/FPwDPVXVul1OEkWPiN53wHsCJlU0H1CLE1mk52k2Ji51AmD468okYCjnizzdyKKdTfUKSfBRpioUTMpRQZaQjBRcO52nXR1iyoSqZjohGEuqD4Q47ipoRsQkTNHJ+uHWNw1QEu40cvhwSli05eG2qnLwL/KTD2cI3b4FiT/DWg8+yQHTj6CPhtXKOuRuIOi3DP1lGPwaxuQ8FcFZSaR52jtUtGQyoHIAVj8zYppCLuLoia1r0XzPSb/BSRVolmY64IMrBnSZXyIqGi2ahhtUJkeD1UGuAprVRorGXccisn5jY34VuYqWPTA7HTxpl1iEs0Lu7y9uJsSAPa18oFKdF0yFnzCouKQc8i9cC0m3WFfhb1f8AY0vOfyDm90jjb/jxi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 11:25=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] crypto: acomp - missing non-zero unit_size check in
>   crypto_acomp_compress()
> - [Medium] crypto: acomp - union type confusion in
>   acomp_reqchain_finish() on virt dst
> --
>
> commit c2a605231cabd5e0e15d6d778b3943a2c118d756
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> crypto: acomp - Add trivial segmentation wrapper.
>
> This commit adds a single-segment compression wrapper for algorithms that=
 do
> not natively support segmentation, returning the compressed length or err=
or
> in req->dst->length when req->unit_size is set.
>
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index c8b4b8589769e..ac4dc52668b89 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> [ ... ]
> > @@ -242,6 +246,10 @@ static int acomp_reqchain_finish(struct acomp_req =
*req, int err)
> >  {
> >       acomp_reqchain_virt(req);
> >       acomp_restore_req(req);
> > +
> > +     if (req->unit_size)
> > +             req->dst->length =3D unlikely(err) ? err : req->dlen;
> > +
> >       return err;
> >  }
> >
> > @@ -266,10 +274,13 @@ static int acomp_do_req_chain(struct acomp_req *r=
eq, bool comp)
> >  {
> >       int err;
> >
> > +     if (unlikely(req->unit_size && req->slen > req->unit_size))
> > +             return -ENOSYS;
>
> [Severity: Medium]
> Can acomp_reqchain_finish() corrupt the destination buffer when a request
> with a non-zero req->unit_size uses virtual addresses?
>
> In struct acomp_req, dst and dvirt share an anonymous union.  When
> acomp_do_req_chain() handles a virtual-address request
> (CRYPTO_ACOMP_REQ_DST_VIRT), acomp_reqchain_virt() restores the raw u8 *
> buffer pointer into req->dvirt before acomp_restore_req() restores
> req->unit_size.  Writing to req->dst->length then treats req->dvirt as a
> struct scatterlist * and overwrites 4 bytes inside the caller's output
> buffer.
>
> In addition, acomp_do_req_chain() is called for decompression (comp =3D=
=3D false),
> so a decompression request with req->unit_size set will also hit the
> compression-only req->slen > req->unit_size check and write to
> req->dst->length.

Herbert, is it Ok if this can be addressed as a follow-on to this patch-ser=
ies?

>
> >       acomp_save_req(req, acomp_reqchain_done);
> >
> >       err =3D acomp_do_one_req(req, comp);
> > -     if (err =3D=3D -EBUSY || err =3D=3D -EINPROGRESS)
> > +     if (unlikely(err =3D=3D -EBUSY || err =3D=3D -EINPROGRESS))
> >               return err;
> >
> >       return acomp_reqchain_finish(req, err);
> > @@ -279,10 +290,27 @@ int crypto_acomp_compress(struct acomp_req *req)
> >  {
> >       struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
> >
> > +     if (likely((req->unit_size =3D=3D req->slen) && acomp_request_iss=
g(req) &&
> > +                 !crypto_acomp_req_seg(tfm) && !acomp_is_async(tfm))) =
{
> > +             int err =3D tfm->compress(req);
> > +
> > +             req->dst->length =3D unlikely(err) ? err : req->dlen;
> > +             return err;
> > +     }
>
> [Severity: Medium]
> Should this fast-path check also verify that req->unit_size is non-zero?
>
> Callers that do not use segmentation leave req->unit_size at 0.  If such =
a
> caller submits a scatterlist request with req->slen =3D=3D 0 on a synchro=
nous
> non-segmented transform, req->unit_size =3D=3D req->slen is true, so
> crypto_acomp_compress() enters the segmentation path and writes the negat=
ive
> error from tfm->compress(req) into req->dst->length, corrupting the calle=
r's
> scatterlist or causing a NULL pointer dereference if req->dst is NULL (wh=
ich
> can also happen when req->unit_size is non-zero and req->dst is NULL here=
 or
> in acomp_reqchain_finish()).

I left out the check for req->unit_size is non-zero, because it is
implicit in the (req->unit_size =3D=3D req->slen) check, and also because:

  - I did not see other places in acompress.c that specifically check
for req->slen being non-zero.
  - This is in latency-critical code. Fewer conditionals are preferable.


>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.79=
09-1-kanchanapsridhar2026@gmail.com?part=3D3

