Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ECC2CCF2C4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 21:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B5A26B0088; Fri, 16 Oct 2026 17:48:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267626B008A; Fri, 16 Oct 2026 17:48:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17D376B008C; Fri, 16 Oct 2026 17:48:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE2746B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 17:48:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A04FC0134
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 21:48:37 +0000 (UTC)
X-FDA: 85329829074.23.F18430E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 78CE8C0008
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 21:48:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LVuTTWsY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792187315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ylh7TTsoBZmvoxuSRMyoR3bwQNz2SMz21EvQ30zmx9A=;
	b=Q2We1O1CdbOUOcD1lQvkz/ZbIq1pxgaKPbDehJj6G+G+kkhpUjm+lyRfA8nPlATTg49qEC
	Aoc0j6wLj+1exToJC1Rh81/wGnTqZxzlN4LceHiYchp8Iozo/0iUxYS09IpNMbblakj1Gx
	e0FbC14SOmA/Q+v2FOMYsnYv7t+WARU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792187315;
	b=Mra8rnZRlpWBM6MAVsRBFqqkgW4h35QciBIhn6HWzVABiY3NbovJdW2797Ny3xgWvCnNYl
	eOTqaTLczhVmACiBIp+Fd1P1H2oKil/q2UgJvR5SP/tAGyAQzMVxEg18Ab/x77S1e9nAFv
	u4lv2zDLUfunEpG0OtXcqARhmTOi7Wo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LVuTTWsY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B086F411C3
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 21:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931241F000C6
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 21:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792187314;
	bh=ylh7TTsoBZmvoxuSRMyoR3bwQNz2SMz21EvQ30zmx9A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LVuTTWsYz6W76Thi1YXgOVaDYQM2FTrz/ArcFuNiQTA0ZvQEDAJNpG0BBWxa86LeD
	 LIkLjWb6G/CpviF/y/xZdhoRDWIe8lbPQaINDtJPy4VdxpGO4ZByUAhR2gLK5ipTjF
	 W74FyAZQ4sgzUkyu+2tVhebb/4ymzRPh7ywDEoGCDUMx8qfD6yDQSCVaZt3QEwviMI
	 FBVocAahARGfvkTUOOPujFfCGQ1mP03pJacvOiNL1CJEuqQn+86kY2jbKCdaf2NQAj
	 7knsfLzMWukW4TNSwbuD797GMNG7AcfsAWWbie4s5qP2LEToK9Xk2/nmJ9CJmxWNbe
	 9LvY+aEbOOIHA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c263415982eso44498766b.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:48:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwVLHOJosqIXOMU+QLoa9in97WWJJJCfhYoAvnAa6JeP4Na5wHgIoPSXBQRgKZbfXPmCTaSyvCLlw==@kvack.org
X-Gm-Message-State: AFq9FYKWMJmDJopg0pi/tNhy9YnYNMVzD0tBqLlm9hIzrDvZLYyEVKei
	e9AJk/PfIXTjytjngfhzxgKm7Jt+iB9QA93+7+SFcjJrvPxJQNyyu8ZIXpo6tINHwGGrIJgXXJL
	LWpyNnVlCQKwRvH44mFO3ge+mr4SO6kw=
X-Received: by 2002:a17:907:868a:b0:c40:aa04:18d0 with SMTP id
 a640c23a62f3a-c419da41336mr78750666b.17.1792187313507; Fri, 16 Oct 2026
 14:48:33 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <CAO9r8zOHtaeo5jhHkHB8Vtb9+KZXO+DH74v+7Y84W0v=tatRqg@mail.gmail.com> <CACpmpofN-JfCgJtW9D0wNu0_pL1pRWGfNphUQnE9Bse-P5tHpQ@mail.gmail.com>
In-Reply-To: <CACpmpofN-JfCgJtW9D0wNu0_pL1pRWGfNphUQnE9Bse-P5tHpQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 16 Oct 2026 14:48:21 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO+0h3LLuaFGi6RF02sBYrG71Zf9qMei73UPvRi2onGxg@mail.gmail.com>
X-Gm-Features: AclHuK_zAfaGRUrzaXzEs4qzNQZy6mar-GxIugKXPKJjvgPfBJdYRUyLH6KYsfc
Message-ID: <CAO9r8zO+0h3LLuaFGi6RF02sBYrG71Zf9qMei73UPvRi2onGxg@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 78CE8C0008
X-Stat-Signature: 8cwdjnb34fem3qrzarbuci8dnnnynu8g
X-Rspam-User: 
X-HE-Tag: 1792187315-482923
X-HE-Meta: U2FsdGVkX19Tvt8w3xyHu+iMHFjwEsmFCTJkG7/ZuNqYRlSNax+llggiKB4j5QoHAdXlnY2bWMTJPHwLBhlpJLBv+oC14sT5xm/XPNnJQvHuKSnhifFIksxGXK4PqZJUZDrpOjbrlv4q+b5Xk5gsO6vBMfK//ZNNHyA+G+qRWPnCdnQ7AH/uxJTxGBmAZcCHxUPQFE4FI06WLL5Hroqxc48kKX8gdfxX4q07pmEC12jLuJNV6TUOW+s15t9R2twUc/8+MxOxV4fHyznbJOffEcRKAaEjWuUgo6FmKNAP+D4wg5fcRR7BNur1ahoVbpx8WQscpIl0KYbpZTzTxZ4LwLUeMsymEb/3Xcz/FqbvM5Da8owbs61EEMlLKLmPI8PJWoJwLvTZu7MDdzQON93BerfFYlbNKGdqHHHHRKvBakbEQ/FTSoLaKsefC/ERKaq0jq3EC16TcR++iu/nIumcBeB9mbjAyECXqYKWqmBODerr0vI6swiBVnZnotMeokpDToc7idaEBVJ2tNhCWGu+16IY5qeNBURCtNSYxeMhji5PttkbI8T4a6XlcR9tOULOAJPsFDpIs/Cvtqck4+mxIg18VpFNkYtuB4FeQIwbOBheub+uDCjVej7/3z0DMRPKKMXf2Yryi4tEv5KXst2NG0t/5103eOPW9k9luDGBXg9SsKDCLh6/+kReyc8ilCHqpskQAHxKLE3GUdYRiPGM2LHXPIzirnXQlUKfDcaKBfTfNbrG+wIFoeYECohKybWIdVFLtXPyODUjW5LhmN8ydswhi01cnQOUB27TEoefFZOPduYU2A9lcrJ12YEEk8TfD9dH9bxgNz9w8XvsBzjp5KsXeXtzf+zNcRpj3EEyVTTVsC+XTmGij2lb7fCWUcpFufaIHbEoQLtzHIya8vuVpwWzLatbj48sMEG6C0PBj4LCENk0rzP8vCR7LRtgvbsVpjRK3qyfRZfAPqA7H5l
 0MT+ZS6f
 RFJ02K7cApDYk9wFA522kBvzv3EYCX8Hpqiv/X/UqJYjVV/cDC24dWpEc3vN6gvRUIYSGnJ8BhunTkQzpZtxyqFqMULY858fN4hkvmKNQvOtDI7lOAePVE7lE0dHGyR4r35Iwe3dU+7mNctm6Yk7+pKoh+IGu3EpOEEi3s3J9xMSdWZ1wTGkcT3Z8u23iR6G7jsbgbo3JWML/5W+NZeDQs/edfAD8nr6trR/Cse0oqYVKWQ07l0q4wR8zObKylaA0IwRrvseZnLWKLjTnhbkEWT4rWAmztcVB3MBUAmy4YlE0xcW+3nGIhU2BnmUrh36mKmytDQCRV1oXe/Dx7Yk/i2cJfZgWSlM3NVm2ToeBiCKLsC1tpj3zdb/HA/raK9JVFu2DcyaagTPe71rA7Qix6QZixg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 12:05=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Fri, Oct 16, 2026 at 9:14=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Thu, Oct 8, 2026 at 11:28=E2=80=AFAM Kanchana P. Sridhar
> > <kanchanapsridhar2026@gmail.com> wrote:
> > >
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
> > > Validation was done with mm-unstable as of 10-3-2026 (Baseline) and w=
ith this
> > > patch series.
> > >
> > > Testing was done on a Chromebook with a QEMU "vng" VM running in Cros=
tini.
> > >
> > > Chromebook Diagnostics reports:
> > >   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
> > >   RAM: 16GB
> > >
> > > vng setup:
> > >          Memory: 7G
> > >            Swap: 3G
> > >     Pinned CPUs: 4 (E-Cores: 4,5,6,7)
> > >
> > > zswap compressor:
> > >   ZSTD
> > >
> > > mTHP enabled:
> > >   64kB
> > >
> > > vm-scalability/usemem setup:
> > >
> > >   cgroup memory.high: 3G
> > >   4 usemem processes, each allocates 1200M anonymous memory, reads th=
e
> > >   Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M=
,
> > >   writes to each unsigned long in the 1200M, sleeps for 10 sec, then
> > >   frees the memory and exits.
> > >
> > >     usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M
> >
> > What is --read-silesia? Is this a local change you made to usemem?
>
> Yes, this is a local change I made because I wanted to get compressed
> lengths besides 565, which is the only compressed length of data
> swapped out from the original usemem.
>
> To replicate my setup:

Thanks for sharing the details. I am having trouble reproducing the
results, mainly because the standard deviation seems to be too high to
make conclusions. What is the standard deviation in your runs?

Also, I tried measuring the latency of zswap_store() itself through
bpftrace, and it doesn't seem to change much throughout the series.

