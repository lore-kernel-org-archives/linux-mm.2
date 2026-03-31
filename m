Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F9EE10F92EB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:23:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9FFF6B0098; Tue, 31 Mar 2026 15:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77B86B0099; Tue, 31 Mar 2026 15:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4706B009B; Tue, 31 Mar 2026 15:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9AA06B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:23:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 385771B7D15
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:23:11 +0000 (UTC)
X-FDA: 84607331382.13.57B3274
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 28774180008
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:23:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sFwwvex9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774984989; a=rsa-sha256;
	cv=none;
	b=x8SWYBzeBbQ+2jTFy97Q0/KA0wnBefEe3ceMRwtrbunzW9uIlbkyEK0zGOsk9p9bb3x8oN
	cf5tBEDsatuZxwUdQtL1RAbSSYIQamwCu64bQSf+ok8ubewH7f41CPonz0zaaiCTSWt8hS
	tkW0tjq5T+X2NhHo8WO6jOU24jaUJFU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sFwwvex9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774984989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9xIGiWCZOHEyfnCEBSlez7vkFb6kGxDmlB0Ix56i3o=;
	b=krR/9AbDjYz5R1exDe82ny/ws3bKfl+Wq96B86CCBfvPtkFzb11+dcqew/oHfNxDOizHhm
	tHeOHWad0kmSWdP8T1KUcLXMckcG73T8VSmUo8VeqqJq2HJWIfKwcXeWez+bCznmr0efeL
	ftdFCKssdBfxaKVnCGXY5H0E2nToYhY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 39D7543B3D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1809FC2BCB2
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774984988;
	bh=UhrdfutYRjACWgV8bXEvfelCUiM7QA+a+wMSMkm8UQk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sFwwvex9EJINfQUSac4A32lqeALJ6p9JUhKtxENIln5uxZxI535SpKNXJVS4gW4Pi
	 GntQQ3p5dWdn63qslL9berElB3PFRgZyzYr5KRU5WjN3DdVYTWa89apX3iqeNtHkhM
	 YWxaYsZdcfD7UqVHAGN0gfucngPtYLZgJU9Ym0/88qaSaj3Id9lJXAN03FqilhRhJ1
	 rXXRnxcdIwQrMMewwtAUTk5T2uW6vp/i8wV8oISEW46Ljq/W55lReCfto+JlVIgHFh
	 18wyQo8FWEws03XSzJkMVqzv+0LYp4X8s7Rm+0ZevYfN7wmYEtevl1AqN0kmiAK1Dz
	 QCKZdenYWagxw==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b941762394aso920951966b.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:23:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW82v6mNR0PzTv6Dvda2GP1865zjUdw+hqxOq2saSmQAQsPmz1vdR3M0FHQ7l0ObTUpymr5ARYu9A==@kvack.org
X-Gm-Message-State: AOJu0Ywo+EMHVw226jYOLuqBR5moxfmF++13NXsXA48OTl/yeKtZNc3E
	HDefsN1qM31TGp43vkjg42djwT3ZfOTOaeFS/szRp8NzVszxvju9Q6fHCH9oyWBLciahkR3w8Wg
	9P1GNCz3D2sKHPpJI1aadPlzJdpwjXIs=
X-Received: by 2002:a17:906:c38e:b0:b99:c0d6:448 with SMTP id
 a640c23a62f3a-b9c13cfd3f0mr44005866b.46.1774984986914; Tue, 31 Mar 2026
 12:23:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260331183351.29844-1-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20260331183351.29844-1-kanchanapsridhar2026@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 31 Mar 2026 12:22:55 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNaEKDdOxe9yOC0yEgh_obRQTHTo3hJ8t39=UbJ74fVDg@mail.gmail.com>
X-Gm-Features: AQROBzD3f6QTMk6taNdtOdR4UhC8PdFo7yWHM0QP6A35EexvhjwM7m2aFc-2aYE
Message-ID: <CAO9r8zNaEKDdOxe9yOC0yEgh_obRQTHTo3hJ8t39=UbJ74fVDg@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] zswap pool per-CPU acomp_ctx simplifications
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 28774180008
X-Stat-Signature: iys5s9ynfiw9ydsjwuxbaw75kq5f76x4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774984988-388230
X-HE-Meta: U2FsdGVkX19yjb94w5WEXe1cG6Moapo7oCQ6QMe2P8K01UpszOtuXpuQOTckVzSyZnKMYY2T3xap2IgfRayAjc+azrxHHHMG/gp5dmvR673VvmeKhoeTIedSypTdqXh10dlIUTJ9mOjxyfZSiD8hp5lWxCx5ZyPOd+6Ek+JEm+MElbRFa0NS8f2NvLZzQ8HsAWhhyDEvZqHJVPWvMSWWd6tPvH15hiCtppxek8KdlQ3hIv9OF1K1V2HMWdk8IYsB9p849Tx1ubor8vMxBnY0Mgcbb+QvyKrI1PM4DUEY6jT38DPXOJH6bqgy5oq+p4GmaicjfaHa1EuhH8o3xSHazX/nj28EVENTKPOVyWajkXBRfS+Js0H0+5asPnDyrVu4IDrvjmNmrQH+JMmdpj9FGJ4tVxXJha4B96WpmA6Wp0PCb2MvkM8dcDKm7Wue7qROk+/kjMlZFL78Ai9phWeiCsYfPRwSEfQt2OucciaPWDYp0YbgUf43Trk4Y20KhUzvRiKa9ve9iSFdRYqTCbzYxxDn6izc9ItpfI5nGM8ZlJuJmija2ll2Ccy25IihThIcXktLA0tS0OfAo8UNCIPq/pB149/lPpJVVTZRSyWl1qXB19WHiACyb7zfchSM8vrDZmin841UiyPV2h3lMHQc3p/DzW8zewu8kMI/5gExFV6t041sV2eUBbAul16DzioFNhzqkpx0IkWjXTtw8iD/Bn0MjhxvdhyWWtJqwAkIus8RSQMbDrvvy662xKaETwyFbh+zNTiktIkWKXmiEKAdOU5NYpcNzuTjq2b+nA0f0LojOlk3Xo/pChAu22XiqjZkmSDZiq9i1iy1MJ8LTV/BNI48Xc9G730vziHE2C6oCIeHFlAIC7jYPNQMBcF28wRwwaqjdd+B6VJqHeetnPFiODYvflFba6F7b5Vx0IQ+esMvpgwHcObq+J+XPEcf7v6pV9tgTBPtBL9U3JuU1n4
 RQr9xROy
 12A00NbkPIAjgw6xjlV7+1FjyhYrV6Hge+MgIwVWk2+2sQjqmbNSYuexvb3W1mtGJWY2sdto6Bs/N1ss6vTarzvbIHWz34mZjWfri/pssN8JlWzfDULbNxrAsj4ivSU19Hqg63ZT/RiMmPeLxqwZaV6UeM5sJFYmArjpcJSaUeIYy8TfC3JgQPDvR2T8PgNlNSTUepvtuXGzT1RjWKQ3TKwyV34vIGIfutCWTiLcTkIdrVCXoQPt5X5C32mccL1wTfQC5IUVyz8/aKGI5MZifwsyUq0tcQ+VCqbnvJ7vo0Jw6nfoZfpJ3scQgGKauALuwM7Knc7STQ5w778KsB3s8XMXle6TCEvXY0FuQYbwGUKB0Rv4ifkLU7905dYXdyivqbeO0yzhpeKL/4uLa32ffzXSvKimO2pVB2sKJVZmv7dtsEgKe0YPpIMZOfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 11:34=E2=80=AFAM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> This patchset first removes redundant checks on the acomp_ctx and its
> "req" member in zswap_cpu_comp_dead().
>
> Next, it persists the zswap pool's per-CPU acomp_ctx resources to
> last until the pool is destroyed. It then simplifies the per-CPU
> acomp_ctx mutex locking in zswap_compress()/zswap_decompress().
>
> Code comments added after allocation and before checking to deallocate
> the per-CPU acomp_ctx's members, based on expected crypto API return
> values and zswap changes this patchset makes.
>
> Patch 2 is an independent submission of patch 23 from [1], to
> facilitate merging.
>
> [1]: https://patchwork.kernel.org/project/linux-mm/list/?series=3D1046677
>
> Changes since v2:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 3-31-2026 (commit 24e341657c28).
> 2) Collected Acks.
>
> Changes since v1:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Made the changes to eliminate redundant checks on
>    acomp_ctx/acomp_ctx->req in zswap_cpu_comp_dead(), per Yosry.
> 2) Renamed acomp_ctx_dealloc() to acomp_ctx_free(), per Yosry.
> 3) Incorporated suggestions from Yosry and Sashiko to reset the
>    acomp_ctx's members to NULL after freeing them, to prevent UAF and
>    double free issues.
> 4) Replaced v1's patch 2 with v2's patch 1.
>
>
> Kanchana P. Sridhar (2):
>   mm: zswap: Remove redundant checks in zswap_cpu_comp_dead().
>   mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.

Sashiko was able to apply the patches and doesn't seem to find any
regressions: https://sashiko.dev/#/patchset/20260331183351.29844-1-kanchana=
psridhar2026%40gmail.com.

