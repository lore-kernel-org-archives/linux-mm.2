Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59A78CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 16:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531A46B0098; Fri, 16 Oct 2026 12:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50AC96B0099; Fri, 16 Oct 2026 12:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447836B009B; Fri, 16 Oct 2026 12:14:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 166296B0098
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:14:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F3721C3540
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:14:19 +0000 (UTC)
X-FDA: 85328986638.05.0E52087
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C54451A0007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:14:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ce2iQ+aN;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792167257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dn+zQ94Xx5nbXHRqVu2X2ak1EC4Zynh6vHRjEPrbNFM=;
	b=WkUFzznPhy6LYHsWTpv87gxkQRUHP1tIrKCobVIa8AFNy7dFeC/skncQMCZ69hMruvG8fy
	cNiiWyUH/IfEk6wVyKOA6W15CtWjkvL3+0GSl/PVOaGF/NR6D+i7uibqobpmUmH0ocIcFj
	wmA3ead4UeYBfea/tfoF02liU3HVDgI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ce2iQ+aN;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792167257;
	b=yeEZZbUGJ/CTl9Rh+fyeOgWMsYzLzhcvUrlWqSyPc+6cYhKfLNvQEYfITNMb7kwE/GhXL+
	OgtkYAAyil81b7u0lZHS4/ObVa8Cg8yIQxXnzTyLASN6w0s3cLdrl/Y+zExcxPZRU+fkJN
	NcotEdhjkRO7ocztolsi15gNg6OSF0E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 50D2B602D4
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B481F000CB
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167257;
	bh=Dn+zQ94Xx5nbXHRqVu2X2ak1EC4Zynh6vHRjEPrbNFM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ce2iQ+aNWDa3bNAHmS+VFScdYtMvOZUU12Ia3m21vTFFw6XVN/tklXYG1bX4+2X+y
	 k/63DtKhqTyKvJ8SnUvR5bs+7rWzwPH/j2jfYzPZmSHrW499daGHRt+/ZMYm3LwhLX
	 TY7cE0YeUZauHk5fbEFqH7s4m7nYKwpAAP0RV3A1qW0W2wDh7wwzbAEEU1cLuxDUm7
	 oOjM5zPgBSZfGMc3l4PVGhb4xN4+0TGJCPjyb7OGvAffKJVeVfGpZbAodk8yCM0xgm
	 s4XopY+7vjcZ3PagXHVppWtm5mHfsR718FyeLi6/18ox3d4BUzVJThVQ6IPvy20fwc
	 TuMUjEowDwiCg==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b1ec41d8e9so22457a12.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:14:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzyt8kiZicIOQmulZVM6xr1Nq6BRnOR0/bnjIMdVFgpu+77orzeF8wwwtpLrQtzuQDJTsx+6NsYtQ==@kvack.org
X-Gm-Message-State: AFq9FYLdHehsmdp+L8OObsuCTEerpP8lsNY1i3ZDRSKXMmk+4iRgEf5T
	e8O8hsxL4fJbkhmzb6eZq++BShWkupnbz+8ZFNr1sHlBuvmuzx2PMMXAjf6/u1xDZYmxvmN+Xhd
	jJv8+g6B8FdKs3OEHW49THMTKrzcup6E=
X-Received: by 2002:a17:906:9f86:b0:c40:560a:45e with SMTP id
 a640c23a62f3a-c419f416b79mr22483966b.35.1792167255917; Fri, 16 Oct 2026
 09:14:15 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 16 Oct 2026 09:14:04 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOHtaeo5jhHkHB8Vtb9+KZXO+DH74v+7Y84W0v=tatRqg@mail.gmail.com>
X-Gm-Features: AclHuK-wTWiI_HWFi3__wF5R0bm5SgzhJD-59mYqegifCIi_SvzEA4blKihevCg
Message-ID: <CAO9r8zOHtaeo5jhHkHB8Vtb9+KZXO+DH74v+7Y84W0v=tatRqg@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C54451A0007
X-Rspam-User: 
X-Stat-Signature: pw61dprzp6m9to54t6ak3sd3xecczynu
X-HE-Tag: 1792167257-130080
X-HE-Meta: U2FsdGVkX19ejdKoW+i4HjabES46jTSZRBfwD3qrNu/rZa5MaLFp93F14qCVigKWeEXv+JuMPlv0SbQCGe6uslz3M6EH452FAsQmOVROW8miOlrvtekRKPsqtI99FX3MuQh480NU8YfUDyXvCPf0r3+iaGymNq78Teb87Z6GUjdHAbUyNbFHFxkmS439yBWWw0epEk3GOi9oRl3SsN1F3RW1SVzyuuyigCOLqN/rXD1uvM0xXRE7/syytzVINsMzdU2Ml1Oza5CrduOAPHoEqmYuJSlIwwk857TirqHsNxirHq3JDidhenZUT6EoOQtPGkozqY2hOKErTSS8EpsdcsJHN7IqeVrxSmEIyKxAiJfElgXzoGk8SISVd93IVT0SQgH3IrWSlOc5Xc1l9ou8cdSF3otj7SLY8wVxDgWMNqskl4+JTMP6uYUplwXGoGkcU5CzOCrO9eO0EFDUUPEQJcy080D1sbhhgPQS0KZsGZQj55w0L0p8TbcxaKlwQII+NAi5FDrkfG+zzCMJVQNgJ5KZMQDdYtl9lyoeIaZwPo+ApvVEJfMhboQGp4PyZ4ethuJkWlIaKPapI3xLEJf2mWcSNBzPoplAlaxU/xkFzuQi54fbpKit0E8WUa6JmK1k0PTzwuORnn6quPNuWaZMeWz5Bbm8h89lbUPCFpbMRGa2mSKdmMAwbimgXuTr1X/rzO6I3/n7XvwEzMjyXiFihGZngI+y4PjREpxcyViWOxaq4IuI/K5MADOBtEaRSJuVVWBzm9dprxqMX0JAINbfZ970fH9mMEURQfpAvVpNS87BrLh3o6Cjb0685CvuewWfZAaN0zNSPenLk42rtq4ybFYRozwwF5Oqrhfp7+lvvFnrsk0BsXBt2amOKV+ld5wLmWVIgejpE2D/F1Ep6J4Z0P4Hyl8Shj9fy/zhmLAYCMYSAwxtmpx9qhYE9GN9wzZzdkHZnPFKQryd0nemRZf
 XeQ2uDCX
 iMYNY5z2sbNkSavWmHbQa0/8LpGYxgfpCUAEKYulmDQwdKIzUp6PsDIt/c5PpCoSFVnIfuBt1lec0LLnIhYeouI5/iGjFaMcUppZj1B8y7K/BDcCxXWFSVKiSjhi+l2/oJePlY8SQZ0n+6Rjd5YQDaZ1IQbauo78ewZftuUueoQTB7ZtUVzIihvLONo/ufOknSFuruXWjrgsE4jZvkPsFnIExxzY+q1KciZUVoSB9HYwa/ozplsbkE5Gz+FlXmML/N1k8JgJTi8VYeyiBC3sKwk0HekO/J4mQgtku7MirHXn8HbdGZQUCIQyna82jPqbL5aDNrVzf6LKgWWqKpyNAj75bQRDkQ8H08BTZSIyC2VqOjHzcI0F4FkdrSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 8, 2026 at 11:28=E2=80=AFAM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> v1: Batched zswap_store() with compression batching
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>
> This series is a spin-off of "v14: zswap compression batching with optimi=
zed
> iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zswap
> compression batching enablers. Resuming work on this series following a g=
ap
> since v14 (January 2026). Please note that my email address and affiliati=
on have
> changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail.c=
om. I
> have retained the original Intel sign-offs on prior patches for historica=
l
> attribution while signing off v1 of this series with my current address.
>
> To summarize the main contribution of this patch series: Batching is intr=
oduced
> in zswap_store() of large folios: we carve out a large folio into batches=
 of
> ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
> batch. Moving the fundamental operations that need to be happen to store =
a page
> to now work at the granularity of a batch offers opportunities to optimiz=
e them
> from these perspectives:
>
> 1) Utilize existing kernel API that minimize obtaining locks for bulk
>    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
>
> 2) We keep the working set for each of the core store functionalities (al=
loc
>    entries, compress pages, store pages in zsmalloc) to be focused on a
>    batch, thereby minimizing cache evictions and benefiting from cache
>    locality.
>
> 3) Along the lines of (1), the main zswap_compress() batching routine obt=
ains
>    the acomp_ctx mutex lock once per batch, and releases it after it has
>    processed all pages in that batch.
>
> 4) Any zswap store functionality that works on a batch can potentially be
>    parallelized as a next step, to further improve performance.
>
> Performance data: usemem with 60% over-commit:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Validation was done with mm-unstable as of 10-3-2026 (Baseline) and with =
this
> patch series.
>
> Testing was done on a Chromebook with a QEMU "vng" VM running in Crostini=
.
>
> Chromebook Diagnostics reports:
>   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
>   RAM: 16GB
>
> vng setup:
>          Memory: 7G
>            Swap: 3G
>     Pinned CPUs: 4 (E-Cores: 4,5,6,7)
>
> zswap compressor:
>   ZSTD
>
> mTHP enabled:
>   64kB
>
> vm-scalability/usemem setup:
>
>   cgroup memory.high: 3G
>   4 usemem processes, each allocates 1200M anonymous memory, reads the
>   Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M,
>   writes to each unsigned long in the 1200M, sleeps for 10 sec, then
>   frees the memory and exits.
>
>     usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M

What is --read-silesia? Is this a local change you made to usemem?

