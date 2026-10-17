Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77414CCA463
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 03:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CB1E6B0088; Fri, 16 Oct 2026 23:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17AF06B008A; Fri, 16 Oct 2026 23:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06AA06B008C; Fri, 16 Oct 2026 23:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD1FA6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 23:53:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B7F61C26F6
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 03:53:43 +0000 (UTC)
X-FDA: 85330749126.04.35EC4BA
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 44B9D40005
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 03:53:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ft5IqvGm;
	spf=pass (imf11.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792209221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c0xww6zOl66Izqr/6HsQKYJXypZK9pMb27w+but6MD0=;
	b=M/CoTLUbiiF2H8LblwlroisWGuoUF93EcLecpoD1ZE6zuwEUCMhE52fhu1z11Je0b26Y6z
	wAeeXNBtZrGgnaaDbW9tdilcwLlh0UTs45JXA/9ZFS60L0W3Mph6OTq+POHEFGeFPbss+h
	Ju8NUnFHyCelbRVe1BwLr6wE94Rw310=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792209221;
	b=n6r2wBlrgNKoaC0CMH3YmUgUiUWyUcSYzBf0vnUQ1nu5BvZ7DwWaVx9PbfuCrNsX1Z7XMg
	QKbDekKw2HhOSgULHSRvqL/XPKCW8P/yRB11e0DtJC3PXDbvgxK9if4Mb71CG/MIg9HjrE
	MSH4JTLu1UK3St4qjFobv/FBxuWPBcI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ft5IqvGm;
	spf=pass (imf11.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5bccecba199so482674e87.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 20:53:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792209219; cv=none;
        d=google.com; s=arc-20260327;
        b=RslL9BtthjyLb351EAA4JY9xmKlRuKCTY6G+Gb0nT80EcxKmhMKRjOu7PKrZskLiEg
         B4HiAKFmG3O3skQGgLzF8NPzc0edTxEouxOPgGLjdf8SJAhPtRNruLHSCUQ91Oj2Uj31
         3G4JJO+10Qw2WYcPBFkJJ703RR0wWzT0/s3lU8KkWjo79WndtQt5qY6253m5lCf4kVy2
         j+Klmf5OTpyOeMQEtp/SPSG1kFLsEj/dWZN8a3/Fncu2q6r6JrFxzzGKioP4v0YCqZp/
         coiO/eypIq1SJmi6JTk54zZRfUxVQw/7kBRLt74I/h2P5a6/CxRjTDlzBAyNp4Mgpxj4
         jr/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c0xww6zOl66Izqr/6HsQKYJXypZK9pMb27w+but6MD0=;
        fh=GEjt+j5HVlUa36knRXRq7LEoIXx96n0GtAbNWh26bEI=;
        b=IPuckQrJa04FgDpbeIKctqR4N5d0qIiRWTeVYnC1LqJlIa4JljvEsSVoPYbpYOPMnY
         eWxIbAR2++NClg6Y/NDcdMhA02HrEtgtem7RxYvmxdLtwnOIJIZM+whlOacd5dT54A2N
         xiy/3evJZDqMGOc5H7vxprvpY6bPgubrSAjEXpgLG47O7QXiFcmqS+MJHGCflqTYbXcr
         V/bgjDksjKTKcGqqP3TmapqXE3fQfboiytGZ5pwborTrbvL+52Bw2ZmRqRl/WZDulv1F
         tY9ohPbfgHdrorK5q4XLyXcMhEeRIJInycTdd1jFv9Nh1GBP9cfoub8FSR9jbLCg0pya
         q2GQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792209219; x=1792814019; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c0xww6zOl66Izqr/6HsQKYJXypZK9pMb27w+but6MD0=;
        b=Ft5IqvGmPWOyptr9oCwlaj6d9yVeoyz0ivSSzE04pvdVg5Pw51vY24DT1kgEOmSIfd
         LL7MwFfi9uLZ3SkKYhRmR7h1CFD7CQNI3M7cKUKNSwT7R+LHWyIWAv1Fn01/vPaXKfKN
         Up+HI8mHltHNdFeWUhXylhxGa0latr+r4F+VriAgmq03F9iVSgzfrV5dmsuujjJ7MawY
         C4Tj1NbFDaXnTPYY7g1EoBqQbrOnshPFi+w1YsqXP44V6qYsYbpEMfFMp0PofSGADWUv
         yILMfS9EhpQH4kekg89CCfpriL7oJjzgTR/MoROFc/NG53QcQ1NEnfHmu0Tdcqtj22E/
         pHkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792209219; x=1792814019;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c0xww6zOl66Izqr/6HsQKYJXypZK9pMb27w+but6MD0=;
        b=vvvHSrRXEYXYuQc1FeCWy1K9KNoD0epf7NE3okSSQf8IBdHwm718eQQqg3JoegtkL4
         Kp4JetIaji3BnSz5UBrHF39Mqul5FvkD9X50R/iT4vsatQ57Z65wyWd6Asl86l0ZM7sW
         WRvK+kieIn3Ap7EmguKyRdgXuQ+ZGuM69JyhJ9hGXnz1pOnNLCARJwf7NyDsOWet4u6k
         G9s6nPJkAseeVJR4TNqQ/oZj74o5Doz55QEH0IIxJeYPFYkst7F04JrV+4lwy1SVLAek
         5bZ1skYqnvHa4U/huIBnxwVIznpRha92GIAZkUnPtSS8stujmAwlX+HEQPVST8IE50tn
         2VKA==
X-Forwarded-Encrypted: i=1; AKwUvBwCbEFUbXwe6zHyHHqzYNoWnKjwlrfQerPLCBEtx25iX5fRhKmDtBNaNDz5lEbtBHsJJeMUJ67LIA==@kvack.org
X-Gm-Message-State: AFq9FYLuXbX9Y3o2mi7sXaubG2q7GBK00GoWxZjV2wzHRaSTfvnA2SJq
	yYZBOGLLhqB1p/wSXzmwu1xSeGeovLx1CwjHUei1Hy8o+fQCLBCfkLZJOu3+9Xyfdb1R3j+R+v4
	baYxWIg17jW1m8I0ZoQqm4Jv6H7Frd5U=
X-Gm-Gg: AYBFou3NXonOzCLVyrF2hny8nqrP3gscKfINx61hkhB9RoaFsQaNHzLBFBK4eEtFOyf
	TmkgtwFlwOEImyKrD40Xmp6gXh57exVdqwy6Eyu1B4u5MqQOV2WKaOQQeHDxTglgOLrHwWEUrud
	JMTjqerE4CHvwdRlhUTxL1SHNEtgEmCAN8SMHqQa4V00uzkP1iShyOYAM9TK+jkpL5EOBR1r2i7
	oFQXp19o27yrwnTniPNn/f8f6sAi4PZ0pZk5Rv5pwupFO2RhCBhpH7+kIVzo9Zb9dFS85VMgRbV
	jRzvKCbOdyF1mDYZ3m1AmfhnpcSOQhl0JBwR5ck9w6w5m/aSyuzlSS4=
X-Received: by 2002:a05:6512:3993:b0:5be:5220:3db2 with SMTP id
 2adb3069b0e04-5be52203f96mr217853e87.26.1792209219390; Fri, 16 Oct 2026
 20:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <CAO9r8zOHtaeo5jhHkHB8Vtb9+KZXO+DH74v+7Y84W0v=tatRqg@mail.gmail.com>
 <CACpmpofN-JfCgJtW9D0wNu0_pL1pRWGfNphUQnE9Bse-P5tHpQ@mail.gmail.com> <CAO9r8zO+0h3LLuaFGi6RF02sBYrG71Zf9qMei73UPvRi2onGxg@mail.gmail.com>
In-Reply-To: <CAO9r8zO+0h3LLuaFGi6RF02sBYrG71Zf9qMei73UPvRi2onGxg@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 16 Oct 2026 20:53:26 -0700
X-Gm-Features: AclHuK9PwGYFMZLK4QolgvssL7tX2S8kM-FVLNspgBd1JKDsPP-LcKfChdsn8JU
Message-ID: <CACpmpoe+krnso-b1h_g_Q=HzV5x8xpu=Ke9==+4PfWF0ZcAUgQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ajzgpcuebf9jff9ore1bbt8yq7j8e4r4
X-Rspam-User: 
X-Rspamd-Queue-Id: 44B9D40005
X-Rspamd-Server: rspam10
X-HE-Tag: 1792209221-41071
X-HE-Meta: U2FsdGVkX1/VzOTvUOT4kBSVhq2gft2fRb9XV3py8OW2b+dHbq94deo0rTzTozWW8SKWKxV3hw71rxgYwW0os/wN1PduoTQ8AzNPoQnVptkwEScPYuNfmtnX+LP0uWmnKUpRRd7gPyi7wChG1e/nWP223KmebUBG2mbOphUHYhglwGDy6u6v35u/WnKajQNYZMwK0prIuHdd27Q+dqriG/hiOHCbxd5d/ogtzOYlpPLr3K3FdVjPQVDZ/CklEKJoFzmZiQ76q3V8x3O6CnrQ7eYXFlbIhNRFN0Fp49KzYwe8rkqyl8T9JwKfAdWTIqsAru3Z7IdP88i/OpPdX4i5UuwStTwqrL/2AE/QBRl9JMz/xN3AEyAgD2Ktdmnt9yG5vQ12wgvCOTFxMHcpph2sIXvct8ORPZCVjlCtCnNukc8AYStuUy7Q7q4UqkKv3j2mZ88+D4lRoSqBM06stmu9giKqBiIaUiBp8V+Mn7qr9m93CB2g/rYEyxn+H2zLezRyutcr50+5byPOP4ZvQ5lQlDrtXtTRwcHgTgFjna5MFwJY6bYvr12Z/cm9mecEikP5KV5+H1BdPMrvyw4XL/nu+3Ey/jWIyHS32Y/mQD80VByMy221iVKqezxHwA89NbyKE3x1Na9F+DPKavwNVMFTJrPWCdOwqgzb1CxcqKi+2D3ESP2Q/l3MEhmi7JL5UqtNSn7a4B5nSQPJrz7CrkflC9UdnfZc/r0itpHu67YonJ0ABlifjtl81n5kcZ2voK5/15bIy3OWravS85E2Y4ILbMsFhuWeDXPTQGh5Upwb8Tc/6TeFNQr5VozulWg1dwJr/xxnThecf8eq7TCNrU6EfVoZDV8eQSZ9Wk6D2Z58PApK6xrvucC1eXJCnI8CwPGy6spqGx/Usb7b9G9FCYIcAO5WAFKgfb52uSq6bLcD3NW/T8/WILu/yMHfMrt3WjwAXrvesrrSA28NmTxUovv
 Z/pWstDW
 f3UweNjYWMb53bHTC/fD0RZsDeng9V3Io5tbXViB3XuLtNgYF3++ilETuSUaP4MkNilrpmPbIfAvB3T2Wv9hPpYO3cKuNupSxfs5S93UJYAGt6KAp4WphG09k7y8421lZMoQF/WVj0+EyxjVZEemtKG96qhptsE3J1MsKtfE3Gz2LJbyAG0T236yKRPJQKoNA4y5sjqPfV/mqqS0kCnEACRrcKyqAP9onRpO999cos4LMdioScGU9ceKc0EWVscKcgMtO4zcZfVG+J+VXMOhsrE9AZ+CyFgECsO7WZnrFfLxCJQqIVYH5sSS+yqQjy6hEmfB2n/8Ky8+u/x+CjXsxSg8EZI8sAkq/ehpnGdlqXd6YbOUqwcX9Xa+BdOQFGuw5bXn/XkMvGKodLSpoVfnSWyu2OLeanjslTbb9xxZ98nsp2L5TOfGSFFf/bFMzmGMwV7OGzH9i2uFF4FhN3UN4p1VYKwQIoX5fUrYlQPEdZy06GoXWNZfVDYlhL/Z9tRBsfe7UHy4EfkYI3FU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 2:48=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Fri, Oct 16, 2026 at 12:05=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Fri, Oct 16, 2026 at 9:14=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Thu, Oct 8, 2026 at 11:28=E2=80=AFAM Kanchana P. Sridhar
> > > <kanchanapsridhar2026@gmail.com> wrote:
> > > >
> > > > v1: Batched zswap_store() with compression batching
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> > > >
> > > > This series is a spin-off of "v14: zswap compression batching with =
optimized
> > > > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and=
 zswap
> > > > compression batching enablers. Resuming work on this series followi=
ng a gap
> > > > since v14 (January 2026). Please note that my email address and aff=
iliation have
> > > > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@g=
mail.com. I
> > > > have retained the original Intel sign-offs on prior patches for his=
torical
> > > > attribution while signing off v1 of this series with my current add=
ress.
> > > >
> > > > To summarize the main contribution of this patch series: Batching i=
s introduced
> > > > in zswap_store() of large folios: we carve out a large folio into b=
atches of
> > > > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store =
each
> > > > batch. Moving the fundamental operations that need to be happen to =
store a page
> > > > to now work at the granularity of a batch offers opportunities to o=
ptimize them
> > > > from these perspectives:
> > > >
> > > > 1) Utilize existing kernel API that minimize obtaining locks for bu=
lk
> > > >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> > > >
> > > > 2) We keep the working set for each of the core store functionaliti=
es (alloc
> > > >    entries, compress pages, store pages in zsmalloc) to be focused =
on a
> > > >    batch, thereby minimizing cache evictions and benefiting from ca=
che
> > > >    locality.
> > > >
> > > > 3) Along the lines of (1), the main zswap_compress() batching routi=
ne obtains
> > > >    the acomp_ctx mutex lock once per batch, and releases it after i=
t has
> > > >    processed all pages in that batch.
> > > >
> > > > 4) Any zswap store functionality that works on a batch can potentia=
lly be
> > > >    parallelized as a next step, to further improve performance.
> > > >
> > > > Performance data: usemem with 60% over-commit:
> > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > Validation was done with mm-unstable as of 10-3-2026 (Baseline) and=
 with this
> > > > patch series.
> > > >
> > > > Testing was done on a Chromebook with a QEMU "vng" VM running in Cr=
ostini.
> > > >
> > > > Chromebook Diagnostics reports:
> > > >   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
> > > >   RAM: 16GB
> > > >
> > > > vng setup:
> > > >          Memory: 7G
> > > >            Swap: 3G
> > > >     Pinned CPUs: 4 (E-Cores: 4,5,6,7)
> > > >
> > > > zswap compressor:
> > > >   ZSTD
> > > >
> > > > mTHP enabled:
> > > >   64kB
> > > >
> > > > vm-scalability/usemem setup:
> > > >
> > > >   cgroup memory.high: 3G
> > > >   4 usemem processes, each allocates 1200M anonymous memory, reads =
the
> > > >   Silesia dataset [2] from a pre-fork-allocated buffer into the 120=
0M,
> > > >   writes to each unsigned long in the 1200M, sleeps for 10 sec, the=
n
> > > >   frees the memory and exits.
> > > >
> > > >     usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M
> > >
> > > What is --read-silesia? Is this a local change you made to usemem?
> >
> > Yes, this is a local change I made because I wanted to get compressed
> > lengths besides 565, which is the only compressed length of data
> > swapped out from the original usemem.
> >
> > To replicate my setup:
>
> Thanks for sharing the details. I am having trouble reproducing the
> results, mainly because the standard deviation seems to be too high to
> make conclusions. What is the standard deviation in your runs?

Sure thing! Let me know if it would be useful to upstream the
--read-silesia option to the vm-scalability tree.

Yes, standard deviation is considerable, which is why I run usemem
consecutively for 10 iterations and report the mean Average
throughput. I could also report the median going forward if that
helps. The cover letter vmstats are after 10 iterations. The last set
of data I reported in this thread after applying patch 8 [batched
version of zswap_compress()], had a mean of 20,946 KB/s, standard
deviation of 5,391 KB/s and median of 22,477 KB/s. For reference, the
stddev for the baseline mm-unstable was 5,397 KB/s.

I have found this methodology to be reliable in drawing conclusions
because as zswap_store() performance improves, the outliers are fewer
and the data is more clustered near the mean.

>
> Also, I tried measuring the latency of zswap_store() itself through
> bpftrace, and it doesn't seem to change much throughout the series.

I ran bpftrace today to gather zswap_compress() latency per-page,
before and after patch 8. It shows a clear performance improvement
with compress batching for the reasons mentioned before:

Sequential_zswap_compress  nr_samples     p25     p50      p75
p95       p99
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
zswap_compress_ns_per_page  1,722,489  43,947  57,791   88,489
130,165   323,961

Batched_zswap_compress     nr_samples     p25     p50      p75
p95       p99
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
zswap_compress_ns_per_page    339,088  42,081  52,633   63,185
118,461   191,710
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
 Latency saving (ns)                   -1,866  -5,159  -25,305
-11,704  -132,251
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D

Hope this helps. Thanks!

