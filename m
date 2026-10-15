Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E98ECCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 23:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758756B0096; Thu, 15 Oct 2026 19:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709E86B00A9; Thu, 15 Oct 2026 19:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4F46B00AA; Thu, 15 Oct 2026 19:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3479A6B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:40:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A789980205
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:40:49 +0000 (UTC)
X-FDA: 85326483018.13.C1DC1E1
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id BB8D320002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:40:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WyHBrOOV;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792107647;
	b=efldu94XpTr7mtUwHzl7EsufMjM6zFMN/w3i8Ap4OKg8fPwsqHaDGDEIHxddgPrkyZZixj
	KheVbr4e0f/yIoigWrEWC2p8m/Y3QEdh3q2UBom7+lMpimdYKKisdH40wCczk3LqYE70HA
	vFzJJgqIZMn/bBU33komc0nUO+jF3Js=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WyHBrOOV;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792107647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICP/xr5+1YMQinRVIx0qLLDaZPBqnXiqmFQQcLFIEgw=;
	b=WvN7qaCsLVsS1oZbn0y/4+NjGn8UFReliIHfKRrbq2tsRnDxW8BohbAbDMLDJhBZAPrgJl
	4Rr+u4CFxWiIg53h0tRJoIs2KsvLrQbal/dRNPQHaqrbXxX5j6OAqRIH/a52sliqtkLMjS
	plHG841lAvu2oMxqm7ABKIRQJ2CgUko=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5ba3ec92031so6065515e87.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:40:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792107646; cv=none;
        d=google.com; s=arc-20260327;
        b=NG8i4GmlOlPYPci/fw8461MmZzKaH04hFS6Mi+nZHR0BJV07QWtKE/zKpcoR+bojYm
         PmKe10BfYhWKs8HnFA2YU5QwHT0MfatGXDvC39H/JM0rzJHs+AJDuVWsg4nf/GereM8z
         0W2gLC6ZhkvGMHG2wMhDyZqVnbtowBIrQxDenrPg0abb+tuB78W4NCJxzFe1sbeP88nX
         stwsHmQMuA/WGT4DCXZWKWgExOWCaktYsG5Cf4nLjmuAlkUgMEkAukll0iT1/CSjsEBp
         Bb3J9oWXg3tqpVzy1SKqqXE97YlBr8kOTB2/hFgis635zbVhYn9/qwT2K8eW80jWAQgh
         qk1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ICP/xr5+1YMQinRVIx0qLLDaZPBqnXiqmFQQcLFIEgw=;
        fh=V+QC1tCx85L8CCTc+otZ5OTraztqh+DO1dPfHIsJLfM=;
        b=XYfMdTf3BwwXfB+13iA6h28DAdBiM4Tic55RJSFsdpDrQJUZVD7OOLhU4dVGFOBGK0
         AJ+9lLynhZpwMEAwADnOl422rhCKR7hW8TvBXATvom1naszl8BuVRCFI1nChVS43k7YQ
         AI4vEHOOrQOXHpBn/GHyJzyeWPNZyREXE7zEkHNlYFE32urhq3pYdV70oqaLadpQklh9
         MpibHReITUJ+TeppYcrZNVbqrwDEoNs+1clF9Yja6r7BVZUGQeelCoilOJ9dIO6rcDae
         wSROzcgf6bFKYx62f7wn0U54XPaCdl7P7mKRnaAPVmTC4mEUV229tBm0nre+Bzj50xj5
         WC5Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792107646; x=1792712446; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ICP/xr5+1YMQinRVIx0qLLDaZPBqnXiqmFQQcLFIEgw=;
        b=WyHBrOOVOLZBvs3mCOv4NVTpyBx2zjt/+hRHoryXwftdIWsfH2L3CUNXB6LasUIscR
         REQ1Qoob1eczePVEVHIERWHwRD4O2nBPLJdm2/HiVlLbSwdnH9DfG8EeKzv9opJHBH0Q
         keJn29EfNaXnYz+xkjr4Z2ZOLfF0ajr0Ko7vLGG7uzKauctYJKm4fqztI+1RJrhcgDza
         6QkVUyEKCrNFD21zSfKqtgNCZli/KO94bCvRaXGzvKAB6bz2lIhkA1F8IrJgmXfupHex
         4YU5AbUp10KHr547dXtdvBJPxbSIWh26Z3ycimMrEz3udUzWex9fMVX6gNx3PBqkR1RA
         EeeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792107646; x=1792712446;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ICP/xr5+1YMQinRVIx0qLLDaZPBqnXiqmFQQcLFIEgw=;
        b=ejhss/lbIu5SXhFlx/N3b8+6RbDfIvp79Bk3go3ZRFQPRdkc0ID10jeAsf1VkM7wyN
         ftJcAKKHUZcAxxyPxgCsa0kkxDHByrDtYO8RXB7VBUSHM2fyee55la9i1H4uV60OWk9S
         NqbbDJsxr1roG6HrFoG81mWHqu4b8hf7P3ypJTC+72zSQV2laSZM+oRfU+WhpSikNe8I
         pYui3Ms/t7dDtWY7XPUpXEvvsszUb96InRFLHnjika7/FYPoF8HHhHaonJBHzB9nBU+y
         eCZpAzzwiH0PnGymhpaz08nk95NdCRgycuHBQBZHzSEIT8+vtMNNBf7Iqqn6vqN4qsU5
         GZSA==
X-Forwarded-Encrypted: i=1; AKwUvBx1FXdiV97WKNWj2398MAe48z5JCRrg3nUjdCK4nvrv2fLp3avk8nKg0qv+U/86RtKtvZN503QtTQ==@kvack.org
X-Gm-Message-State: AFq9FYIyYaXLMNts9bZc9K4SrFqXWphhb8F5majobNWVvS1lKU32dFUX
	cG2oumpRLetUlsGuIhw1VgWvDz6HlFaBPVO6AxxrKs7H0tSdXXJTsoe6ObV4f1eOEOmzGZHpJz4
	sdo2KJBHDsm0wgQA0YlzxOQMi2Lh/k1E=
X-Gm-Gg: AYBFou3R8usm4rbo74Ivx18g7jDcj4gHeMImQ7chcCUVaoOBAWaMGthtOK+YeI6qqxY
	f56dAYJpKc1ixBtaBdqhRUxWfIkmLNuoQklnqQrNNIfTSo08M8Tr6cSqLmw/WtulKptZe/MvRD0
	QfCRDeucpfMiHAkU+UaqXes/uHoSzhKduCrMNYo6fzAmx96Dj9PX8OsAfiSzqH/0S0FAXJQu27m
	IkpyXrRtQxV2GTWXP77qifr0yBCaXDsFGpT61moUaw2rTIG/NDcEZT978G0ByGA0YTZo4xvgEnh
	Y+W0DyUfDdw8X/EN2LMfqYrujydwAEOxIv/ZmS2tCtzGWXoSGtELISSz
X-Received: by 2002:a05:6512:682:b0:5ba:3c60:b875 with SMTP id
 2adb3069b0e04-5bcde5aab53mr7165266e87.43.1792107645951; Thu, 15 Oct 2026
 16:40:45 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com> <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
In-Reply-To: <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 16:40:33 -0700
X-Gm-Features: AclHuK-o0YoycUuTLR9c0WACqcfx9D0UCCwaTlp6tqXVGsdos9IwJufLaP7OH9Q
Message-ID: <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
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
X-Stat-Signature: z8m5gbxqj54bcewhxggo8ooycdpow345
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BB8D320002
X-HE-Tag: 1792107647-173122
X-HE-Meta: U2FsdGVkX18gcTJg6aD89rD+rxava26dEOWAVE87YUldxsU3cxT4/MxFBYl0lU+QXeh/2LnO6KF67BFmAv78Tst08t7jRa6jW8lLGJtkiTIMpt+tpLyOjwlognS62VWVinkhKheQK12gDYaN7kDnqvJg7mWr+fIyWQpRg60xCjAp09rvMjdsIVLuMbrCPlUSSMHOi5kA/r8M6zb9hlAhmdgUgFp4PwJZ6n1f6iVajwQpL4vZjmNKy3PgNdPqlYqjhVV1y7rCzx7s3UFYh2+w6s03bxkbstsYj/gbS/y64NZx4wjOYRTb/TUxVBMfQKQPbaMaQVo8YZ00QLfiayczkho+qTqvRlNpJKsPa401DBPjw4SFA1hrJC45tBfQpoaQMUy7Abr+16wdz01xZ4DlxaO5+7h/x9phoH4/VRb3XJ67XNCPjFgFqEeT3S0LUU/oQjZEOI+qlBu9zMmHJBMX8duSnuqduPJlRBlRlb2eliIZSDHrvnPAYaUyCwxJQExMhEU8YLmWlDYn4Ea4bOjFGuAxK3Ihbh5PcNrJG6c4z7IoSLRnPrRP+4LNQr75WLzXfe2jIdQFj8SnkE68fkJzotLl+RRvCBP1yQHVuCH/J4TMl9Mi3EuHEhxYeb7jASLeLOIiZn5pbltUvvuD1R/4r0e9Z99mwFM2w32IWPwbuyCOQBF6DjzzEKc0JabxwqdivL9cn4UBylsmS4vztdlzGIdpss86Ww4LjaXu47UkA1RuurRDjcd0LCgHk9sT+pZtsOtOnZmSOSDBlpNCG6E9HT54CbFzxnGMzYDqCcOGZLdOvW4AiR2H+AdQ87nq43nnT4Xx1Zq+kWIHC0G5H3VM8jpD5aIPAohI19v0P5RXXFGkPEoqdJ8pAMO10xIoRmQVQ0qZ1uKHcIp260uDJiekyoVszjxJiAJrGUDm69Ebs5NAH6gMcOWH5bm28SL+ExPHuwHJJyWdQSQz0kDopEk
 I4qGNFtQ
 g2So1BJSdLLCNVUAn4VU7NJBaqsoFdf2OPfQBDedHL4QKba4H9LgRRrDUncWSkw4rSrZ/b9R2+vHWe1NfMOF3+6+lY/cBygZgJYb+21woUzsES2sfblleJj85qIWtgwOujkwy9MdLnoq7orv8DWE3P7+ik0tHWnHyaUKq6bqpErhIdBcHYUPlFbVZv9nN9OTMkT0Rc4sJPmGrQTItEEV4MAINWU81UsrzjuLJvgqBfKV/ke1eWHhDeGS+2k1NTHrk4sd6sj+HxBwdStDptoyB2SmlYPv2wzhVbE+MnmAsxCVWwjH92owcDYEbEdWbIMaAS7NEwTIaXVXA/h9m0xCHwhDtWxsYEDMXJNSYt2j3Q+A5gqPgw3g43tftaLtM4x3kDI+hk3mTbpCr/0xmN4K7snPp05HhCwDonF1nZPEtkCbm9ui2WOszBVcfzvICr9bxBSqBlMbuk/bpl+iahsCsVOYsCJQjYangPxVCDoMqx8nS3UKPMseagvj/QQ/97HyJ6DEiaU+GltE6PLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 3:59=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 15, 2026 at 3:51=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Thu, Oct 15, 2026 at 3:04=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > On Thu, Oct 15, 2026 at 3:00=E2=80=AFPM Kanchana P. Sridhar
> > > <kanchanapsridhar2026@gmail.com> wrote:
> > > >
> > > > On Wed, Oct 14, 2026 at 8:45=E2=80=AFAM Yosry Ahmed <yosry@kernel.o=
rg> wrote:
> > > > >
> > > > > On Thu, Oct 08, 2026 at 11:28:06AM -0700, Kanchana P. Sridhar wro=
te:
> > > > > > v1: Batched zswap_store() with compression batching
> > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > > > > >
> > > > > > This series is a spin-off of "v14: zswap compression batching w=
ith optimized
> > > > > > iaa_crypto driver" [1], and focuses on the generic crypto_acomp=
 and zswap
> > > > > > compression batching enablers. Resuming work on this series fol=
lowing a gap
> > > > > > since v14 (January 2026). Please note that my email address and=
 affiliation have
> > > > > > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar20=
26@gmail.com. I
> > > > > > have retained the original Intel sign-offs on prior patches for=
 historical
> > > > > > attribution while signing off v1 of this series with my current=
 address.
> > > > > >
> > > > > > To summarize the main contribution of this patch series: Batchi=
ng is introduced
> > > > > > in zswap_store() of large folios: we carve out a large folio in=
to batches of
> > > > > > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and st=
ore each
> > > > > > batch. Moving the fundamental operations that need to be happen=
 to store a page
> > > > > > to now work at the granularity of a batch offers opportunities =
to optimize them
> > > > > > from these perspectives:
> > > > > >
> > > > > > 1) Utilize existing kernel API that minimize obtaining locks fo=
r bulk
> > > > > >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bul=
k().
> > > > > >
> > > > > > 2) We keep the working set for each of the core store functiona=
lities (alloc
> > > > > >    entries, compress pages, store pages in zsmalloc) to be focu=
sed on a
> > > > > >    batch, thereby minimizing cache evictions and benefiting fro=
m cache
> > > > > >    locality.
> > > > > >
> > > > > > 3) Along the lines of (1), the main zswap_compress() batching r=
outine obtains
> > > > > >    the acomp_ctx mutex lock once per batch, and releases it aft=
er it has
> > > > > >    processed all pages in that batch.
> > > > > >
> > > > > > 4) Any zswap store functionality that works on a batch can pote=
ntially be
> > > > > >    parallelized as a next step, to further improve performance.
> > > > > >
> > > > > > Performance data: usemem with 60% over-commit:
> > > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > >
> > > > > How much of the performance benefits come from patch 6 vs patch 8=
?
> > > >
> > > > This is how the performance changes: Average throughput is averaged
> > > > from 10 iterations of usemem.
> > > >
> > > > patch 6: 19,119 KB/s
> > > > patch 8: 17,593 KB/s
> > > >
> > > > So the acomp_do_req_chain() path that ZSTD goes through with patch =
8
> > > > causes a regression, even though it provides a generic batching
> > > > framework in acomp.
> > > >
> > > > I was able to retrieve performance with the following change in aco=
mpress.c:
> > >
> > > Why add it to begin with in this case?
> >
> > Patch 3 ("crypto: acomp - Add trivial segmentation wrapper.") was
> > co-developed with Herbert. The request chaining for non-segmentation
> > algorithms was as in Herbert's original implementation. Since this
> > causes a regression, I would like to get Herbert's Ok on replacing the
> > request chaining in this part of crypto_acomp_compress().
>
> I mean, why add patch 8 if it doesn't improve performance? Seems like
> even with your diff, we only recover performance, but we don't improve
> it after patch 6?

Patch 8 does improve performance over patch 6 (19,578 KB/s vs. 19,119
KB/s) by 2.4%. Besides, patch 8 provides a compress batching framework
in zswap, which is the purpose of this patch series. zswap is the
first user of the crypto_acomp compress batching API provided earlier
in this series, which I think, is a great starting point for us to
evolve this further, as mentioned in the cover letter.

Thanks,
Kanchana

