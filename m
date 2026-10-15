Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE739CCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 22:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C604D6B0098; Thu, 15 Oct 2026 18:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C11E26B0099; Thu, 15 Oct 2026 18:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02876B009F; Thu, 15 Oct 2026 18:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8865F6B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:59:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C349C0213
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:59:16 +0000 (UTC)
X-FDA: 85326378312.24.BFAA1B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 51D2480005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:59:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XZEP2WBf;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792105154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnQrwyzLoVynTCLEtuWk+TScXXTmTjeMSsfmQV0kEjE=;
	b=XT9e1PML6MMmUI988j138r8WAv8pr69caLwBtC0pLn7ESLNtDFh+F4ekOKcDcnrqt53cxL
	wKLsduetYKbugCoGpKWhLX8nrHAGe7xytD/qypyBKZOLYKmrGRIzOTLlF3Kx+ytM3oUy4p
	TEnWDndK1ExFJCaYwX0b1bwXVsCDKPQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792105154;
	b=GF3Ae1GD2xO+z4aDPx82kEviOjtCJfY0wVhtYri7mH++Hwu5Oi+mKmy3fCRGGyLGAMtjjW
	xWp+A3BSLQzpgt8H/HPFCSJ7CYYfbitJ2g4+0L7qr/5Lksp4lmX2YRIFuR94RvWeXlI/7p
	OTiRhALAuBxu3vhUBSfpAFKWruKkpPE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XZEP2WBf;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 869C060A74
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6961F000C4
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792105153;
	bh=vnQrwyzLoVynTCLEtuWk+TScXXTmTjeMSsfmQV0kEjE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XZEP2WBfROoz/n/DQyrwTl60Bxqkw8stXfth5gXqEeC4dP/IiSB1l6fZaqdB5/9bn
	 F1J31UvRoUjffzlKp8FmKCVZogCI2A1t9dQM1Ilh8oSYUqrIh8dbK67PVp6NdeqrMH
	 IowuIbK0VmtR+Sj6UK59PLnnmUUfTDtm+0MdFvHHjbANcGKF2hUWK/Ke9tmSGGWkC0
	 hv8zKP2bSHHR/S6rsRZM4v6FLXu8xrlA9UQ7Q6IpRP3v+HJHp+BPU/EwKwj8F+wKrh
	 5VxXQp3KjUwOM77gCWwppm/ccGZKYCpj0cSadmqmJa1JDiqhA1+uFr3DXm9ciw7KrH
	 ZrFFJmHD4a4CA==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b1ab2ad719so1577848a12.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:59:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx1c6HhKr741wbIv8Aw7LPoeni4FxhRPy3yvvAMJKcO+9lNxV2/miIbi301FqK8f9+TLrTIv/1OKQ==@kvack.org
X-Gm-Message-State: AFq9FYLtIfinFJiz5PBrXRgXa/N2VagCk19BpMAPbc9WxVSvRLkQwc3D
	CTLvcQZqfRtsQY1k7g9xZVf2P5vlN+xt9kn+BKH2Mfpdw6xZTnyn3mu4CMlROiimVRdW3P2aRP0
	Cazut7Fdmh+pSR9aURsPs4qTyRF/CQc0=
X-Received: by 2002:a17:907:d08c:b0:c3f:c856:fb7a with SMTP id
 a640c23a62f3a-c3fc856fda9mr209686866b.3.1792105152116; Thu, 15 Oct 2026
 15:59:12 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com> <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
In-Reply-To: <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 15 Oct 2026 15:59:00 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
X-Gm-Features: AclHuK8OVaqtU74IUTXePWDKqT9l38kwuNNsIo2XNA9CQvEhaVmXaKfetDsN0wo
Message-ID: <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 51D2480005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 3p1n4iup9dhu7xs6gwcupq4bh9w1rwkg
X-HE-Tag: 1792105154-557709
X-HE-Meta: U2FsdGVkX1+sUZVQyVf3J952uV2sLHS2X0dMFMZslHCidbuzjomv+qdloRBe4Wpc16508goINAnOut+DOX0lh8h95+CRuXd8jVWQWgjmi+kC4c0RjivMYURKT9KIhhHcJnbcneY5V+4B8Pm+wMlGaw7DshHOMOyTCMOA6sHilQJkmIH6TX68fEnyXTOb81o+QxV6vKQ/rHjvagWk2PldltHyccp1f99IyoSB04kx2ET0HLv1dRuCLALr4g3f4hbkH3lEL6GhzdbmBC/AdhdWNqQEZiTw5iZ58cpim+icI0YA8UD05iVi5kro01ZmbfZA7focuzsC91+ukwSVI4OsMBc5Q02PvL/L4uvei8vdksPJaCrKUxp2jsFWArgYzdGmv553DAtrgVQlYpXarsgaKkHiedR8E1MyWLt+tYGykMux+bhy7psP9pxFW+fNM03Sv8gxYPKLi4gOnR27uqVJfvF9ayaDO9EoJ6e7KOQ7a9qInOHokkHJ11dTRKvH3KvtEfPOWZp0Lhgv6Ex3TmVVCulslSyKFec5/FfAvhmJZY6AVQq8pPhie3jK8DyDtplLXkEpBVgvwp0VFPDJ5ZucqeApFNdE1xNrkd0tZXSR39Ii1n1dlpbkdRmGVI7d9csea85erGr8NTxcQAQxt0DID9WV6yjB3hEUucF38O8258uUlLOXBIxA5ScN6Oh682MfPO/9WtwFgCDEryL1UU/l3p+rrS8PFPWs7E5+i1D3sHs5Uby/YbBgkKIGvaJVKL8bLp6EbR3MAyipG0RW5D4xmihCEnyN4DBSwz63jEO1EqhaLNyQcHArHZzRFvlzPpJcouj2r1zwqXNht8VJvxbqJqBKtw5bXm2TjkzRsy+tReOy45rEQyDzW95r4RqrZyXh5viqk6SDrNQQILUvAep2+PywZiwKfL9m+lkCIpDKv3pYwv/UGzCUuagkB9F97HmQqoSBy8I+Yh0rEaNb1DU
 vD9Hx7u7
 uwimGrsc334BRIzJDFlzs+r07RnfTH+ZumuXVuEBUD8bdiOBOBjAxHJaSDexe/rxODjW9pe8e4DmS7c4k7Dy8VJirWofP7CL/mZ9H1qnlxtJF3Kz4nhxEzLJ9ltEBe+w7uKOCVXPo1QYbydzs1CNPjuvufRZIVT6pZAgKkcN60LnTBAATCmWUGIWTdVj8f9sJbC1gP8e7LQ2esZgeJIjCJEaZQecYQvHeSsO1jMwH7hUY+bWa0mMruDy5m1fyKzS8CMWgbgrPOaAVa4nMZzlhgJcPDl200XGVecXaSJxNCaqQTBNoYs7q4qyfgxCCpT0gzvudeyaLBLGnGhGiYcAHA18UhTgEZv4MxBjD9z5rSvdh65msUwR/rX4RH5hAQJAyWUBi5ddI6Y/nziIfSM8Ln912pA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 3:51=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Thu, Oct 15, 2026 at 3:04=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Thu, Oct 15, 2026 at 3:00=E2=80=AFPM Kanchana P. Sridhar
> > <kanchanapsridhar2026@gmail.com> wrote:
> > >
> > > On Wed, Oct 14, 2026 at 8:45=E2=80=AFAM Yosry Ahmed <yosry@kernel.org=
> wrote:
> > > >
> > > > On Thu, Oct 08, 2026 at 11:28:06AM -0700, Kanchana P. Sridhar wrote=
:
> > > > > v1: Batched zswap_store() with compression batching
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > > > >
> > > > > This series is a spin-off of "v14: zswap compression batching wit=
h optimized
> > > > > iaa_crypto driver" [1], and focuses on the generic crypto_acomp a=
nd zswap
> > > > > compression batching enablers. Resuming work on this series follo=
wing a gap
> > > > > since v14 (January 2026). Please note that my email address and a=
ffiliation have
> > > > > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026=
@gmail.com. I
> > > > > have retained the original Intel sign-offs on prior patches for h=
istorical
> > > > > attribution while signing off v1 of this series with my current a=
ddress.
> > > > >
> > > > > To summarize the main contribution of this patch series: Batching=
 is introduced
> > > > > in zswap_store() of large folios: we carve out a large folio into=
 batches of
> > > > > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and stor=
e each
> > > > > batch. Moving the fundamental operations that need to be happen t=
o store a page
> > > > > to now work at the granularity of a batch offers opportunities to=
 optimize them
> > > > > from these perspectives:
> > > > >
> > > > > 1) Utilize existing kernel API that minimize obtaining locks for =
bulk
> > > > >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk(=
).
> > > > >
> > > > > 2) We keep the working set for each of the core store functionali=
ties (alloc
> > > > >    entries, compress pages, store pages in zsmalloc) to be focuse=
d on a
> > > > >    batch, thereby minimizing cache evictions and benefiting from =
cache
> > > > >    locality.
> > > > >
> > > > > 3) Along the lines of (1), the main zswap_compress() batching rou=
tine obtains
> > > > >    the acomp_ctx mutex lock once per batch, and releases it after=
 it has
> > > > >    processed all pages in that batch.
> > > > >
> > > > > 4) Any zswap store functionality that works on a batch can potent=
ially be
> > > > >    parallelized as a next step, to further improve performance.
> > > > >
> > > > > Performance data: usemem with 60% over-commit:
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > >
> > > > How much of the performance benefits come from patch 6 vs patch 8?
> > >
> > > This is how the performance changes: Average throughput is averaged
> > > from 10 iterations of usemem.
> > >
> > > patch 6: 19,119 KB/s
> > > patch 8: 17,593 KB/s
> > >
> > > So the acomp_do_req_chain() path that ZSTD goes through with patch 8
> > > causes a regression, even though it provides a generic batching
> > > framework in acomp.
> > >
> > > I was able to retrieve performance with the following change in acomp=
ress.c:
> >
> > Why add it to begin with in this case?
>
> Patch 3 ("crypto: acomp - Add trivial segmentation wrapper.") was
> co-developed with Herbert. The request chaining for non-segmentation
> algorithms was as in Herbert's original implementation. Since this
> causes a regression, I would like to get Herbert's Ok on replacing the
> request chaining in this part of crypto_acomp_compress().

I mean, why add patch 8 if it doesn't improve performance? Seems like
even with your diff, we only recover performance, but we don't improve
it after patch 6?

