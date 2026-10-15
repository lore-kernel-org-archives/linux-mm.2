Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A943CCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 22:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 458AC6B0095; Thu, 15 Oct 2026 18:04:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409886B0096; Thu, 15 Oct 2026 18:04:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FB166B0099; Thu, 15 Oct 2026 18:04:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0617E6B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:04:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7712BC01A6
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:04:42 +0000 (UTC)
X-FDA: 85326240804.17.2C9ED5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 89ADE4000A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:04:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJT0+jrL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792101880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RlYzd0USpwg3JvbStBZnQdUC/IjyPKMmb+JkSAhgO4c=;
	b=4RsiVMQvcXxEyU5dRDXtuiVazTKTx5Dce4CJsYYcJG3JC69PMx6/aNzxj6bDtQt8OzOG3p
	4iR4mkWIw728t10lVTu3w31yADhSZR+Z8pp9num7MVAGIX8t8FDoSusJJcAvqui6jcVb2H
	4Cop1khzdSSamNIxAe9XThfDBt+cL34=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJT0+jrL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792101880;
	b=qOtXBz5KM7D7V5lCTUHH1qnm8CDQuYC3FQW4rVrcdnFRWxkpoKP6fmzAcnPh9+TUE+onVQ
	p910qrS8GgECQOlDRDnz03GVlmqnKYXHSkEvxQT0v7eq+VhNSPge1v98fFr23MStWyAQmT
	eWv6Gb2iYVA+POy+mNC+TgJPT1tdBNA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01D0543E84
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69E51F000CE
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792101878;
	bh=RlYzd0USpwg3JvbStBZnQdUC/IjyPKMmb+JkSAhgO4c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DJT0+jrLOGQd88lrqJAj8DabydJnd2u7QOrmT2Txk0viriqWFku9s8wrt5PECKnOs
	 69hEyT85EXJ/EQiNhU1aPp6e0XCy+NQg9bdIIQabSSQRQqJ5ECf1WVPDG21nIIe+Ki
	 rPnh5lg+hS5i6/uhd1UrMHRRrCZVxgoaVM9VnLYUZ85lOaZ6ONWn5D1HMoUkvcHtLp
	 H6lPS6nxQIzY1ff3xdtZyF6VKoRRL/DTJdw8Te1P7VfQ2WGaXaDjASwxx+9nd0HuUO
	 20Zyxjs8ZGUymprw0fADj/AXo+540TeHGZH7gkZ9zK83hFvc9YTivBuHzKKVRfnTt2
	 HYXFjlBE91Zow==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c262f1186f0so775374766b.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:04:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBySkUTrwojI5jBP9H8nMqHh5VZtsImU5Az2aYyTvJxQH8WGUkUeGfy9L6ugO4SChG7bE3Zf6mOpGA==@kvack.org
X-Gm-Message-State: AFq9FYKgtTo00W+2/AM9oRK3KfZGijaeTFn7IRRJXOafZXxbawdvCR44
	zPZFfOzm64UAevX50vBsQK8+HkkM3QAc4CygjTUhwuSC95wdkDEIjIwJKvfNFACUDZfAkBbZPd6
	H2kYn6dBw7vtKSeL+rE/n4RvceDe33RA=
X-Received: by 2002:a17:907:dab:b0:c2d:fade:e089 with SMTP id
 a640c23a62f3a-c31a96de49dmr1933015666b.0.1792101877742; Thu, 15 Oct 2026
 15:04:37 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
In-Reply-To: <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 15 Oct 2026 15:04:26 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
X-Gm-Features: AclHuK9As4WppohD6ZJZNrzjy04-7wgYHo0FQv2W3Z0D8lo9pnmEnN3DgsfpTfg
Message-ID: <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 89ADE4000A
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: j1cnrihnhs9jtyshzognyiz35hbx31qy
X-HE-Tag: 1792101880-350853
X-HE-Meta: U2FsdGVkX19q3/ph7qzkC7DT4F1X4OuGLmJkk66FgWJKHyc7yS+6t5NJQTqCXzDSO1/b/ePbQy2mSOP8GTkCcCuDucKlFZp1PTpY6QNFN6Cb1uTXAqTvHm5v6g7L8nDAczv/+zqOb26Utdc2p9P1AsaGdBdkYE17vvE4GJ+5iaMioVcsJUaqviDSHAtsfjY/4G/Kq/KhocxwjpLhLOZS0Rxo9stZCwP4e5yRPJ7ZXgOUl3UPwcGizCX8MjWrV+B1x9kao8/RD8E+V4szvBFItnxHpgnNOK9y3GUq9sM5/2aqLiM5X6pRFhK8VCRd1BVXz5ovCKV4GVqMSqfusMbbG7qnCm4TZ03qoc+yCSY1cpEGQXRxK/o6e4FJyaQ6Uuotn17ROuYgFjZfj87/af0CRIDK5rY6duYm+pHdYn8GrVW5tLR4xn1eZPXkpidIy9KLVd0ITQE82GfSzPk0WPFLAD1abqi1vfG3HpvgSbePgXSwkPzl+20RnyBljlyCiSk6RDXRWpr397DXhf/7z+P44cdpCXvkV2nmX/HWyx3PErYe0yOOm4KZE8kiJXRp8qeTiuP0YmE/V+bewj+mvi7vPLJlIuZizWofCGP2uj3i+GV6Nlqe/uAiMKsYOH/D93RaJ7xVBJ2J092YxdaPbzPDg2U19mcwbL9YBASpio1WSD8F9rYTVU5YPPcOrlRC8EEGoHvkIplmYBzs8LMIkYkJeSTTA08KBxtsfdr8tmtEDbCn4w/z0ibhAATPsoYEcU3LeY0mDvwqBH1IGE9f1w7N2zfJvuG3hTHBzwccWxQ/wrTYz2sqLpsMNOtBqczRWAy4W9PJ220r4LhgCM/480sunHFymMC9XTD3T9frx7L7+MWuK6RWikh5+TvcdYB0AcLizAJ1PSav+IneGca8we/9pDdKSr3BToOzEksBvcoeNmsbgYTM24mTXghZHdj3gTATJ/icyIdR5oINzb6PB/o
 af2KM1e+
 tp/siZUQFf3dVP+bLTOykVveH1jnfsbFhG17kPiSreVUuMi3E3dGurPql9oZOowLmMCUOSjh8931sNA9nBXt6+MO3G9QA0dWgyR7yIH/CtRzYTUU4mSK1wEQeH3iMUlZy4TR1R18R0bQqcUtbxwhOge/F4X7HMEx7GnKETcxIeDcxyJTUXRwudRxgP5WbwLuC1Rbwv0hePiWpLfMxexpWGZkn2CnTMtthUhaO9p+pdJGY0IIqxchqDZ84bCbQK1xFVWYLDi2I8Mt/ovSlFQ5j6kt/b5SlUH0Uz/v7L+kOFwDm3gMi0kPh7dEJAiit6DScU9bfyKZKMJA+OykJsaUGcEBERYYRPUEZvrVT+eovTHwSaH/arMJeelQo8i+V5SndEUPjH+MhfCNNwMB6oq5Fd475/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 3:00=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Wed, Oct 14, 2026 at 8:45=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Thu, Oct 08, 2026 at 11:28:06AM -0700, Kanchana P. Sridhar wrote:
> > > v1: Batched zswap_store() with compression batching
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> > >
> > > This series is a spin-off of "v14: zswap compression batching with op=
timized
> > > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and z=
swap
> > > compression batching enablers. Resuming work on this series following=
 a gap
> > > since v14 (January 2026). Please note that my email address and affil=
iation have
> > > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gma=
il.com. I
> > > have retained the original Intel sign-offs on prior patches for histo=
rical
> > > attribution while signing off v1 of this series with my current addre=
ss.
> > >
> > > To summarize the main contribution of this patch series: Batching is =
introduced
> > > in zswap_store() of large folios: we carve out a large folio into bat=
ches of
> > > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store ea=
ch
> > > batch. Moving the fundamental operations that need to be happen to st=
ore a page
> > > to now work at the granularity of a batch offers opportunities to opt=
imize them
> > > from these perspectives:
> > >
> > > 1) Utilize existing kernel API that minimize obtaining locks for bulk
> > >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> > >
> > > 2) We keep the working set for each of the core store functionalities=
 (alloc
> > >    entries, compress pages, store pages in zsmalloc) to be focused on=
 a
> > >    batch, thereby minimizing cache evictions and benefiting from cach=
e
> > >    locality.
> > >
> > > 3) Along the lines of (1), the main zswap_compress() batching routine=
 obtains
> > >    the acomp_ctx mutex lock once per batch, and releases it after it =
has
> > >    processed all pages in that batch.
> > >
> > > 4) Any zswap store functionality that works on a batch can potentiall=
y be
> > >    parallelized as a next step, to further improve performance.
> > >
> > > Performance data: usemem with 60% over-commit:
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > How much of the performance benefits come from patch 6 vs patch 8?
>
> This is how the performance changes: Average throughput is averaged
> from 10 iterations of usemem.
>
> patch 6: 19,119 KB/s
> patch 8: 17,593 KB/s
>
> So the acomp_do_req_chain() path that ZSTD goes through with patch 8
> causes a regression, even though it provides a generic batching
> framework in acomp.
>
> I was able to retrieve performance with the following change in acompress=
.c:

Why add it to begin with in this case?

>
> patch 3 with this change in acompress.c: 19,578 KB/s
>
> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index 192ea996e779..dc609bd7d927 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -293,8 +293,12 @@ int crypto_acomp_compress(struct acomp_req *req)
>                 return -EAGAIN;
>
>         if (likely(req->unit_size && acomp_request_issg(req))) {
> -               if (!crypto_acomp_req_seg(tfm))
> -                       return acomp_do_req_chain(req, true);
> +               if (!crypto_acomp_req_seg(tfm)) {
> +                       int err =3D tfm->compress(req);
> +
> +                       req->dst->length =3D unlikely(err) ? err : req->d=
len;
> +                       return err;
> +               }
>
>                 return tfm->compress(req);
>         }
>
> Herbert, would you be Ok with this change in patch 3?

