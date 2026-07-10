Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 998B7C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 18:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633DC6B008A; Fri, 10 Jul 2026 14:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60AE16B008C; Fri, 10 Jul 2026 14:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B026B0092; Fri, 10 Jul 2026 14:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7156B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:44:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A049D40551
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:44:07 +0000 (UTC)
X-FDA: 84973741734.18.BF3F979
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C49EF160006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:44:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S/ABKXPf";
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783709045;
	b=Pud/VBMkBwrfGHpqQVPZfuDSqNpC3jPbsUCifRz3zT0wxqO277LMK+2ycNHPXEc2dfPS8R
	BoiA8aEHlAsUL5Dx0uhOz59Nq61Cdm9n7ctE5ut7deioOsx2CeG74XT8RhOV9DATMd4b08
	tSt7FbkYQiGYn02312546h3JQ1hmkPA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S/ABKXPf";
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783709045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+L5xEirar3GBPas3QqdU0yCz9SbsxHqF6+XluD6e2k=;
	b=NRFdHWtk8laQAyqNUdn3Yes0uxxLHMFZs/N4i7JmLbZZMH5yhvwTG35FlcMY8wPxUONXWA
	hL28AEJhXlPZehmhQrU6b51D2vfIozzmJjeNuTiKXc5FAxmF3Bacs0ZAuAoDAugQZeQ/AY
	byrX7UMjRpyk5J2KHAxJ+nYG3M9MI+Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 298EF60052
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D458D1F00ACF
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783709044;
	bh=4+L5xEirar3GBPas3QqdU0yCz9SbsxHqF6+XluD6e2k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=S/ABKXPfjfbGEFbgt6UwQIM7R9xuluscDcpOTOZEHZ+FT3fyqBpqVbt95DR+n7B+W
	 0gGwYigWgmTwbr75PsxRcSJiYgS3GMFDN2SJ8oZDaN/gT1i+YNpze8W6rL6EKxCMVE
	 Er4SbNWG+kpDBnCsYILIdZwDY2YDl4+KFO0WkU6P90hXazpblRl/hhOVIpIFde3ABg
	 yqyRaR2fa9UQ7UobbG2U789gurTiiQuBsgZ76qCfbbLlJhel4YHKeEXrLUfq4sX/G/
	 fTBRqQa15zstkRgf4fyB1MJ75kgyUyClpD60CPYv58aXyACX5Hw1OeA21CR96DDLFN
	 vrdu7TD/S5zBg==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c15e03c2763so253640766b.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:44:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp+F3w1+Ml4fyjSPvebof4YJXXxZqBR8rGP2KDjglr9IjIKcXqSb8+SHRxNh/zwjfAzRBvCOiKvMA==@kvack.org
X-Gm-Message-State: AOJu0Yy/Wyn9n/nnw796K/IcG2oVENY6QCKqEaptmfGMK16SkK7VzK/D
	LZ/kUmF3hpnS7WtOu8IW8Hy76NhhDv19C1jUZ3GmDe0sMK5VkCOXl0a0/1C2OvvqhO/MQVf1gIG
	N3N6qn4kSz3i8h9n7UAOjw7+gi9C8g34=
X-Received: by 2002:a17:907:1c09:b0:c15:e33b:8c6a with SMTP id
 a640c23a62f3a-c15feefc6b4mr265404866b.20.1783709043778; Fri, 10 Jul 2026
 11:44:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zN4ig_GGP4a=NLZ9PUW+jFmSfY1yBLrkPA9azvDCrGSvQ@mail.gmail.com>
 <20260710184052.3614560-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260710184052.3614560-1-joshua.hahnjy@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 10 Jul 2026 11:43:52 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOuRFcYnLGUcRYyg9_nAk1TvCxUvV_0101msKL0Mx0P6A@mail.gmail.com>
X-Gm-Features: AVVi8Cel4ge4um3env6XYoknIX6Uczp8EJD7ICGtor-w99a-cB2YkBYGU5nm0Rc
Message-ID: <CAO9r8zOuRFcYnLGUcRYyg9_nAk1TvCxUvV_0101msKL0Mx0P6A@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: flush dcache in the compressed decompression path
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Song Hu <husong@kylinos.cn>, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C49EF160006
X-Stat-Signature: r39ynt4b3zc64s7ao87m86h5t3gnjii1
X-HE-Tag: 1783709045-344925
X-HE-Meta: U2FsdGVkX18QAqV3dHiB5fEifGFF8rm2FYhQkMxLM+FGLgjWNdIGA8+u5wUBtYD1VIfg6XwHGTfyEhaID8N9LFADTxHNeUepIh81YXICKHjIBUKX8nU6Q9YjzphGVExnq/07+5LkTXfedKq4x3k7hakUH/6mat9y85/dS8wa1XO/IFMRl0yuZYTAuuhBmeKcbGygXgnwCOJjFJ9bAoLs24kGZUQ54XcOCViDI5brvgIjEsvfoIxN5S7kIAtvp5luD2Q056zlIoDdTzPmIWvk/JtMY90XjkWEBk6zXIzBD9IVJp4AlkpC7bRgHvME0m3ZHqD3HxSnQoBC20MeyUNXEKhTAnMtFcrjFKFxxmA1uN+L6jDrK8nqnp8+7j3z1pGkngL+LMpRLxtTWB+oBJHGDHEVCpSVkng7s5CRhAu9nKY5pEwv8HWZ6Wqccz79M7ohUzGEsLufQbBZvCA1zNZYyM3OfESb2XK7Q8GaGj/6hh8uTealr9AoUSa2MHwUTbDlFk15RzAgQqq6y+pWJY6J2BDsuT8R7Wm4g3k27EOQ4hYSXZPIMrMq0vqmIQwn27QdHlcOO+oeVag7Ku/ikF4htTFC+bqeADjFdklafN1lHPQB1dtRkhA5nekNLm3C9bqGDA9U9oYaUIapp7qK3B/BKWt5zOdzLvoKzkcJnevIiar4+PEyPBz1KyibpXcifcfZtSzHrInbkX/dx7T93ouKPDppBJHRxjw/Lt9LPwQxwgnImzo1+1AZEwEm6tRmQmVoHryJebhlqUIl3cGbfv2gNLLPRoGosY2CPeuNPjFp5SFEyJxJEdzMZWuNv2ljqjFb5jxMPvf+MLxJlMJr/nvi/6iGC1qjudy4EGiLAtaB13buiFTQo1q4lsLTPLorBsQFVnJ52PBT8lLjoVnTS74haP43Nfzz8SsfolAWDD6/np03cDcg+6xtt89atLaCB/ZKFE4D4gXj9GUNFrdzmHU
 nQd6qRU5
 IiGb/RbJWRcAElMbwt0AMhGUItKmR3eP4SUKMdcEaNS94yFcmPGZMiQRBD2XS0uyviJaZ92vGViOcX2uae9GKd691+ch8i0qd/4g89+7ary+pauU7Q0uB1AyZ1Nh8NmpAwsKiAC/5OItR7dAfL4DpAs6apb3fLeaEP3pYEE0lbh1PZXj0BR4CC1f/rw4jRc4CkN1Y78BV9oG5S3iRAcd65Dl25aFeeIb8L8yUPmH9S7TdFOABjRV2A1I9jQPYzM3i32B1W5av00xf/WzC6L+bc/uGRH6yziIvLEXXcOc4TGSp+yBMoA/+pDukPIWc/AUX5/JMs45tDSlXAr75JFFC7WJzb7xEYp3GnVBMLuDsPL6xFs72cpveMSrmrLqKKTrCZi/0O1O5YV+qb2blxVWediq/jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:40=E2=80=AFAM Joshua Hahn <joshua.hahnjy@gmail.c=
om> wrote:
>
> On Fri, 10 Jul 2026 11:22:43 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
>
> > On Fri, Jul 10, 2026 at 1:28=E2=80=AFAM Song Hu <husong@kylinos.cn> wro=
te:
> > >
> > > Both branches of zswap_decompress() write the destination folio throu=
gh a
> > > kernel mapping: the incompressible branch via kmap_local_folio() and =
the
> > > compressed branch via the crypto scatterwalk. Yet only the incompress=
ible
> > > branch calls flush_dcache_folio(); the compressed branch was missed. =
On
> > > aliasing D-cache architectures this can leave stale cache lines visib=
le to
> > > userland after a zswap load.
> >
> > Adding Herbert here.
> >
> > Doesn't the Crypto API take care of this for the decompression path?
> > Maybe in scomp_acomp_comp_decomp()?
>
> This is what I think too. Actually if you use something like
> zstd_decompress() as well, it ends up calling:
> acomp_walk_done_dst() --> scatterwalk_done_dst()
>                       --> __scatterwalk_flush_dcache_pages()
>                       --> flush_dcache_page()
> over all the pages in the loop.
>
> Maybe I'm missing a path here that would require us to manually flush
> from zswap? But even still, I think that should be handled by the
> path that is repsonsible for doing the actual decompression, not
> zswap.
>
> What do you think?

Yeah I am hoping Herbert will help us out here.

