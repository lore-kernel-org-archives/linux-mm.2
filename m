Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D086CCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 22:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5247C6B0095; Thu, 15 Oct 2026 18:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6DC6B0096; Thu, 15 Oct 2026 18:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4BD6B009B; Thu, 15 Oct 2026 18:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15A436B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:51:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2C74A01B5
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:51:27 +0000 (UTC)
X-FDA: 85326358614.22.72EF080
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id C2257100002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:51:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ILLi6Gz2;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792104685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n63KkNNJ2ZOvS2IAs8k+KZxz8QryTA7xZPJO3TDdt5A=;
	b=S4iifcmHKVKsAEQhFZMNimFeBh5sGjaTzdH0m88kkg0dWKYK3JplJROeQB0cPW/CDwkiE8
	MRzdDM6Mvm9JNZvnqEN80QDfKG8p8tKsbUrLtaiNg5J0Y30/nGP0Tkcg6okr7Cy8NurXb6
	8nB4W1LIhMDJEf5xNHbqGxb1MlsE5mE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ILLi6Gz2;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792104685;
	b=ZpKPaV5kddf5ZMCZatzsALBSSApsyc+zFzDAvVJxpU+50ZXzfcDGpxbkYDhYXZXt+5/rFt
	Akf2Ff0a91C1bsv7rVppGIaN9f5WV8H7Dpdp5rnJTI+WEWUzLrRMEJEU517B1dzx+nTVpN
	aTYshSzqaTMS+zQUcTVBimOHYU8wVUs=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5ba328513b9so4941809e87.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:51:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792104684; cv=none;
        d=google.com; s=arc-20260327;
        b=H1nADOHD0wbwCacSwBwWmvtNEcXepwuAtA0YNHBipezPHjUcFWXnyis0qjxp+L4iXi
         dff+gvKYJUI2yXbgYDmc9dM1OqcOwNx3LjZvOP93zg086KwfvuvL0dRrEi68XvoKNnrJ
         nvEeV/ivk4cgpn2PEfy5lPgBsGtnbJ42BBMXOZMYTV5WMvwpvJDPP92/VExfmkn7YTKu
         n560IvZASBDZryubxGs/LB5TQbnqzeekyP1UsuZ4ajODheQfV6EDJ81oqGCtzSY9A4l2
         XjsGIXX+7gcg+MaQvdvGyEK8m/phuEhdg22b4OQ+CUwL83NdKY0d1Ed5aUPxunKuZc0X
         QChw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n63KkNNJ2ZOvS2IAs8k+KZxz8QryTA7xZPJO3TDdt5A=;
        fh=ArlQQTZXtSkml6vJfMUjZ05uoxjpleBplB5gLAiI8lM=;
        b=emiwF7cXG1FWVxeOPrkv+xsL3SMiGKSVPHuRZo1WygUCgaquKM2xzMR0VgBW2LVuzo
         Ni/rd7DCuFRSNY4kBCVm8BJFaaA5u3NTS6L0DDC4GBaTZ+uXwKldVLOcGyp5KDh+2E3A
         L4muHI0O9BZXr7vDCJb4z9f6Tp8pdT2nwv66y73W4Bd9YaJNF0nr7eSetuU8eu6haCB9
         hSOWVhU32KQmO0o5k5wceHwYbomOp9Gs7d+xYAore47vLi8+Fo/We+2TCSx1Fd/IIpx/
         qJuRw/Muu0WcTyAKO5ovSdcRPkkBK68DuXB6S4ZKny2WgXc+4exuwto+bOGR3RrJex78
         URLw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792104684; x=1792709484; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n63KkNNJ2ZOvS2IAs8k+KZxz8QryTA7xZPJO3TDdt5A=;
        b=ILLi6Gz2xJv9B681+GhXJCDEAVvrU7/7OmMcHIJiyNsBYGRNdME1kwtOViZntK/KZv
         cQzmNP4V1s+G9bBWN0tooeuT9P1/9j0QJBwgNxilj8JcKmqlj2ljzv8Ix8s6JMJS+02u
         8ITeeIDChsVfVF5J/pQTu5gvN/2LRIgcjmx3xx3bxPt/zUHG0QX1w4Zx6ONAmOS8smQk
         GUzZvNlvYPUuiaejPTPqhMraXrw9I6tUDaYodSE664Y6T1dZ0IlFNdklWnZf0JccSeR6
         HV44Fvan9u5RMRETTT7dNtIj8igPRBdmLszhR62FCZHheRHPqlGAjuyZuAVo7rDEGTkC
         gnHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792104684; x=1792709484;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n63KkNNJ2ZOvS2IAs8k+KZxz8QryTA7xZPJO3TDdt5A=;
        b=s6t1rhTNZP2I4nM52rcQ65jn26GtciE6RZ49Wc8+N9udMYxj87gdQaINQ5eh3Bbozp
         de+2dNT5HwYkDE+NJusi5+FLrvK24nEE6TNKKpTKXSLH+bS65W7dOLtgc3avWCa+2gUF
         csg2OnyT3YMEYhwpZNMFo9ifBpGAXB867LcxF2OVOGnwEFegb5gR2HaZ8MlPCxsgrZq2
         FwErBz9/Hk4h2yMxqrdb1rsAezj5cKl15xBDSMjbbsJqebJgXd4JR0BwVocdeas6zWog
         wN8lkI41PfQ0Ya0fdjJoBXlWmHlQGHV3/lIpwxS/lD0Hk2jFSZO5SqMH2SVYQLTx1ZqD
         L5vQ==
X-Forwarded-Encrypted: i=1; AKwUvBxTo/eHOnQILfN0zB5eEGQl60R5yCOuc3Tax6WUxSpVbMg7M0VsAK3Ov6a4EBS3gtrRzbTyb2bN/Q==@kvack.org
X-Gm-Message-State: AFq9FYKns9ZhnEcm0gycCh4RocRZ8mfqpcfg365YbLqvHMqAW8KMZ9Qy
	nAYcNg83mAul10VVpX4Nr5mbeb7D/zcwx774GpznzqiOugONlfd7adf3pkdl5LCRuMcDeC6SgZs
	uDM1UD3dfZVSJDxg2zEdqDO5xfZfzbUE=
X-Gm-Gg: AYBFou1P26LWGBDjCDVeUzI3XS92HTNBhEkHEMVBseREcBDxFKCPQNu1h188QqolK4u
	pzSh5wN/sqNdpZDFMXQmJfmI+AADsydBpAfFwh38PaPlaEhWPYU0QcCJohDVpM4hb6M+JXZR8yP
	BhL+bsbwNVXTy77d9R/WM6puQPiNkDPdGRQQbAIOAbaq1gUlp0somC/VBtxruy6c4Yhtv0FDwDd
	7X6B27wk63puQWh3y82OUliD0qicTkRll5lPWfjr9BRSz/wYsmZWzKPgXXqir/RDiMQBrzYjSKj
	iQe9nEG6QGwK1Ohky6yXDAJfKY0wbQzJuRvOtB15arggokyKvo1YAJw=
X-Received: by 2002:a05:6512:238c:b0:5bc:b728:31b with SMTP id
 2adb3069b0e04-5bcde39f1c0mr6258902e87.21.1792104683741; Thu, 15 Oct 2026
 15:51:23 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
In-Reply-To: <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 15:51:11 -0700
X-Gm-Features: AclHuK-C_rlfvY9gc7Ysw5I3rgT-17tzvCB8MZKJeUsSlTmiFpKdeYuI1BXf3wA
Message-ID: <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C2257100002
X-Rspam-User: 
X-Stat-Signature: t4wigu5hfu5yd8hbjboqs1it9j5micbw
X-HE-Tag: 1792104685-540695
X-HE-Meta: U2FsdGVkX1/d9StI8Kt95N4Q5yuudr26Hy84FwoNA3sUMK7KLZYOTxkH/vI2Hc3NMKNQbXeTbrYPT7VAsvpVnE7bUNiHFeaLCdO3fLXffdSR6kVkto9xGfVGBtROTF9JPbEKwPkIzys2wa3SOhEGDFflbIyLkGRKWiLBkvZ5j+9o11dBl0cTucDS+WvbNd1Ss5Eq0vO2VtHj5isI4N9rviOd7dOGAQTAiFXaKf4dPLj9zhmKEuqEJ/hgGSMCsNRzMJJ5/Bx/Bi1XwhJKAOB+nlVSUdVlrrAqkoR7OChSMawjIRlpNNjIX90m3pG7BjE3Faniwv9ON4ZF0MfYdN6ayy6vmh6Wfymxpu9XJ6w0nVEGRTobDN14Qv84BNyxVkqPyDiLG+MDFPUCUibsg/4/4Q0mrmxXwE9bqYAj7EYHUmh8QUDTUr5IgULX7JU40MTBtElHq+iSrlNlTiIKRuksdP/tB3eAC+qpcKCPiXykAgx7ea334rbKSnRTPQmOa8BuuYFfagJTnDYUn5Q3xuykeMIVOk6vxLILhnohgr2pcu4F6Dxfx/7q51ZfL/BUvAWVCB4w2ojxtqCxTDtQTxOVf6qqj3RWQIuX+IAI4Y8vhb03INor6nCPzXRw8UvY6RZBw7LKFPY/NEmTzAsTa+zQVz5OH4ne7xM0NPi+xbTM2EvovlPE0rymMUOlZZi5/rL4uKK+OsiNhuHTS1lPf6/BKE/cqF4jHLCVZJM2xo43S76YoXWOTlKo7LTzAR388UULtcMX4foTunEf6PO+Is/nZzi7GsDJuanb0l2PqRzX6HNz/q9YFWlTNGWDP9dTMJwO0oOlksfGg3XhrfpeZPbGtfXm63yB2ai3lBwuZzj2EpxTwgmixYrBVfOn8maF2tccTRF5dY00AIeR5kFrvSUO1p20gQJs4Ao/FlQtVIdJVuXvTDVulIQ98Zj456g7ZrTWRrXHWsU0qUz0Fqi6Hjt
 yfk8wvjS
 4YbddaS9TR5lapACFBQag5OVRe3k/VGhJK/cv4zdr/bm9WpR/1dhXlfATcKJRMZWN/uUmQvNA1NHIS98OFSrRa8Met37+TdBKZOho4aTYyk4ixcNoTbBPq0q8gQphXhWDjRMeoZdQHzyl2++yXZSaKwyTIoAaIwxTUXhCDWx5JSXHx6z0SyNtP9FM42u4MjP0w1EndfAH4/QOqUolzTME1d91Jgjy834kuRjGuQiJJsTML9s+T4iLUud1KmEOAqbz9+f3oaf5Z65Wl2WJfLl70uiBXJ+jKJ99omFKf8OKc5FifbE/DgziA6/Beu22aye/1GjEPiIAqkbpBR61DyMF780qh1KaXDcURgqD55nVBB+55xnvu+x2OuNsh97rjtI7cEjcqhokCtQDmA0MtnO87OFbfOPnkFNjzH6x6CEjugjEBPmOTe2SxQL9S+EvLMmTu2ifgfg6njpuX0r59MrFKwOCMgdDvxHqLtXYrGlC63glShkfrYyP1A4veBQvrfCfoZDnb3oD2i/lBHc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 3:04=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 15, 2026 at 3:00=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Wed, Oct 14, 2026 at 8:45=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Thu, Oct 08, 2026 at 11:28:06AM -0700, Kanchana P. Sridhar wrote:
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
> > >
> > > How much of the performance benefits come from patch 6 vs patch 8?
> >
> > This is how the performance changes: Average throughput is averaged
> > from 10 iterations of usemem.
> >
> > patch 6: 19,119 KB/s
> > patch 8: 17,593 KB/s
> >
> > So the acomp_do_req_chain() path that ZSTD goes through with patch 8
> > causes a regression, even though it provides a generic batching
> > framework in acomp.
> >
> > I was able to retrieve performance with the following change in acompre=
ss.c:
>
> Why add it to begin with in this case?

Patch 3 ("crypto: acomp - Add trivial segmentation wrapper.") was
co-developed with Herbert. The request chaining for non-segmentation
algorithms was as in Herbert's original implementation. Since this
causes a regression, I would like to get Herbert's Ok on replacing the
request chaining in this part of crypto_acomp_compress().

>
> >
> > patch 3 with this change in acompress.c: 19,578 KB/s
> >
> > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > index 192ea996e779..dc609bd7d927 100644
> > --- a/crypto/acompress.c
> > +++ b/crypto/acompress.c
> > @@ -293,8 +293,12 @@ int crypto_acomp_compress(struct acomp_req *req)
> >                 return -EAGAIN;
> >
> >         if (likely(req->unit_size && acomp_request_issg(req))) {
> > -               if (!crypto_acomp_req_seg(tfm))
> > -                       return acomp_do_req_chain(req, true);
> > +               if (!crypto_acomp_req_seg(tfm)) {
> > +                       int err =3D tfm->compress(req);
> > +
> > +                       req->dst->length =3D unlikely(err) ? err : req-=
>dlen;
> > +                       return err;
> > +               }
> >
> >                 return tfm->compress(req);
> >         }
> >
> > Herbert, would you be Ok with this change in patch 3?

