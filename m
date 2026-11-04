Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E976070B27
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 17:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hZs8O4RU
Received: by kanga.kvack.org (Postfix)
	id CCA8C6B05E0; Wed,  4 Nov 2026 12:57:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2B26B05E1; Wed,  4 Nov 2026 12:57:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB816B05E2; Wed,  4 Nov 2026 12:57:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90F6D6B05E0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 12:57:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29E0CA07B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:57:59 +0000 (UTC)
X-FDA: 85398195078.12.F40C387
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 37A19140005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:57:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hZs8O4RU;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793815077;
	b=juom9vHEbrMW9JQ03fKhg+vcIkQCoo2T4reEE4QbGK7mf9jTGR80Tl5GOYPHU3ixARYjst
	waCkpIbE7ytu7Tbj9pomQF2TmGdLcP3Qzq/3wnduN5cApc8DYFST1qb8yNS4Ao6AkJAhxw
	d9m7e0oIuztl/ZjJ+Li2Mu66/Uk7BtA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hZs8O4RU;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793815077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Al6NZB4gmP1JmqmmdhYkvzPU5+LiqrhgjgjQTKaGngQ=;
	b=1tgql/AzAwUHo3T45ZR4xVQRH9QTRT64KRZRBK/yDhVCI6IaW6B0sHkB0H0Z7bRJittzq3
	u1geAtGQ/f7LA/C4J9w7keaoSods70dxZbOn257oW4UaIRJYREE50PyEKL6x7t2+veys/G
	GvgevNU+Q/ta3FoMEoSDPqB3QXZIwFE=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso9139255e9.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 09:57:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793815076; cv=none;
        d=google.com; s=arc-20260327;
        b=exk48yDw2lQzkg9dVImcuUGcmrJ0RagwceF+jSRp06ti5a1+e3KK/YDace8jDX00px
         2+W8TeNj2j4Sz0OC1ORvhajwu3xVaqUBHRQkxZ7FS4CFggrs2hqQ1sWY67yOuWzcWlTW
         eLneTZSrxaFcTAzDIcCPpjVuPl+gLRnctegB8oajJxNZcKb3OSAlW9M6Imu7YCUska9K
         21fBzWNlswQ5//RFel/8uju8i45Jhz+nHDevGwvWwjHAJCOGMjR9lM3IaKRNuXTD9R9P
         iXA7RchiTHgvtnJ1Vx86F3tjcFOSssrpjwAQH9435x7kj8HqLV1uYC354Kb7VgxmSJ6A
         mzrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Al6NZB4gmP1JmqmmdhYkvzPU5+LiqrhgjgjQTKaGngQ=;
        fh=NLz2N8X0628xrUSVuHTZ7cX5S4K4ndWicYl6NBODsO8=;
        b=V9xHlxLG+9sK6kPIm2G79d93dC0EYz0RKGTiyrn9aJ6ItLr+pDg+MtN0XfR3tF2R3D
         urbmMBPEqmxm6YRxwBwZjIYMLL74VVX2sFgxbODcNS48KsC8MfaonpqUVAptGhabjs5Z
         FtVxR0DmJVujiqpDo3IZ777wLl7wFb60e2vYOI25i58qMhSBBkwxUi5QJyEKm4HHzIcm
         k0YZ2Fvga1wOxct6HyLzQc0muhktTY6fo9p1/DUUCD8k/d46sA6aWX4hYGGT4ged9QAO
         KnclFOVYPgzcT4RgiiLeZBQXHWP7AUkS6CnXUk5Sh+1GUrPRLhf1IINA+o8a35TeqCgv
         pjJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793815076; x=1794419876; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Al6NZB4gmP1JmqmmdhYkvzPU5+LiqrhgjgjQTKaGngQ=;
        b=hZs8O4RUDyz135bFy0xhjh0YYQ85iRouL52VAFdaRkNt0OgmxOYgihSYDJovzghCT6
         ihQldMHVYjdqrp9nVV7NrQrvqVQ9sAkSZAecEkWbuCSxVnNUFhOXqifp+MWCApzcVLHR
         lZvASqCqHlyw7okdSYYZX4CvT3qXKbmVzO4bMQfRpwnh6LnzPqwlnm39Owf6sOOmM27g
         93Zi5MlYlgdV09aqyWA4b06cgKyW/RiCcffLZnYjm1u1a5P+2QBfUeKaw5cpauw78AUR
         KE/2yGWS8cFbCKBg+Sys2eSZvCp+9fL7nta1av1IYjRHh+ka45+YT+5SITdoUbZdimTH
         rCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793815076; x=1794419876;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Al6NZB4gmP1JmqmmdhYkvzPU5+LiqrhgjgjQTKaGngQ=;
        b=Xr8JcG0uMqqTD0M77MH1lnzPI4pib0mfZ4I6it0ur3KbvM01oLW+Tuk3A0GPnxIO0R
         MvsJ47akOiuHnJKvRSFPWn1kQWgWK/SIt258cZ5Soj79H1dXxuKoC7J/J09VV0sb7mfb
         mCnOW27rYmyrRlae4+w7mwn5KtKCaWAOK9sUFNNg1uc4fWj8vxuz9BQLrcSd3njoO9qb
         Pj/Gs0Dg9ujv1gH+7mx9Tl5+hf2obKs3yOsb8aQF/0M9Qr3e52PKZ+z7VxMgcI3oxE1T
         gl4PT1aKeV4Piq10uz7uh1lXMsqP6bMxm+HrJw2kNZAmF0e6qwfnJ06c1dCev2aVokNP
         uRbw==
X-Forwarded-Encrypted: i=1; AKwUvByvdHCcOZR+BbiQ5gP0nC86Ln3I+4dK0Dnv/Q/Z6diD38xENQ2aigEFMYi9GMJWapGXGHKoLYsYmA==@kvack.org
X-Gm-Message-State: APuU4Z8wVgUubK6MYXgHnyE7TlzP9wMktkScdi0q6l9v92XC4pmR4Wpf
	Q5nwl8JuZ8vqS4Az0ylcJ6YdAo9RLjJur8jT2YsKpuhHwm+n1gegN1oyz2d+AGVf5ZzycurllMO
	Tp2AUOFjk87Cputk9oqpzQn0Jk4YL0Rs=
X-Gm-Gg: AYBFou1Y9lIHXUSCRb3dxZ1hh7/qq6YjzWQbOst/UKq6tUZUDpOomsnUjQT85OHYV+n
	QIbPoYIi6NpLRPwwqqChw5HKjHd6uCyoj34RYP/98CA+TqdKlGd3+arPQVqL7sq1j3f5rUG2jfC
	B8dDSRmT6dM76fs0yejrFsPW+8PvLFz5YJsyMj3wvepLcHLa3Pqq3lez8R1cZbNWsZ2RS3r/ZAj
	M5fMi2apJ7Os0JozvbU7jC58fgPt8IM8CTrMEhbJj0XGsot0XLCYChaahgepMK+cmk7nRVki6FY
	Nu+ck3yTGgtSY9tlaR9EWiR1v3394SX+PveiWsnMvT3Q+VDofBiwfzyfxJXU4s/fTla5A5OePcX
	u2w7vx6DinhduS29Kj4rJ3IW3kRMko3yuNUVAe50DtoUnA9GUtPRw8tAizr5tRfN3reujINgO7n
	b6QNPBdIngolsyFAJCruqwIv67a0qdVNh4+Xobmqgkbh9Iwv01Oefj
X-Received: by 2002:a05:600d:a:b0:4ac:aae6:6401 with SMTP id
 5b1f17b1804b1-4acaae665d8mr265138875e9.12.1793815074599; Wed, 04 Nov 2026
 09:57:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1786003779.git.xueyuan.chen@vivo.com> <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com> <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com> <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
In-Reply-To: <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 4 Nov 2026 10:57:43 -0700
X-Gm-Features: AclHuK_Jo2-e0XBl0SeJKjVGW4UNTrMrsSqvnyX3EFS-6wHyvSchpJgGvWFz9n4
Message-ID: <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
To: Chris Wiseman <chriswiseman@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Xueyuan Chen <xueyuan.chen@vivo.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 37A19140005
X-Stat-Signature: hpdbimkk8aixqpy3hfikb7ufa485tkgn
X-Rspam-User: 
X-HE-Tag: 1793815077-630945
X-HE-Meta: U2FsdGVkX18DsiAWYl4ZzG3TA1uQwBolkYh+Y1YmilAylGEaKKBQANDHMT+pajTcvxkd8b3y9TKrorLkqAU9OpMx5USctRnfTEtYTqFedKVQfJpxezkKoC42+lGTNJJ87KrxlY9bPmkVvpHvmfBO80glzm8fS2C3bQIdZjloKTqhkSSGWJwOiRCl6tj40/GrDu68RYjXqp4oNTo61KgW9BupNPStg3IJ8/wkQ7y+24nz43UmHm2Glb7E+8r89fw8YXn9gt1cELddO70uMPo6e8q2CUvOsu9w354NojlL1zTKTO6Y+HAOuqwokwcJSimW4GfiwnB34qIg2qCw/hfLAvYrAVi04SSCFUY66GGXWO904tam7UwJKkYkQOtapWevxQ520LtFEd3orsDhMzklvxJ+HbgAgL6ZW40lZ862DY8K4w8hmcSdUNSZ9/Hws/tYDNY6dnrgHhv4wB0tBEK1QINieCHK79H+4onomYH6FbpCE2jIMB+GkVTELdCg81Yhd2SOGqkWAAKIIbxYAae1DH3//zba91M5csJdCzkpCjUEmtgrrBvqE6030GQrjvSNdEBH9hJfurRjvdPuXl+N7Qat2XhqIbNl1WvDND8U8ug/W+YnSIW0Jm9GmzqJrpyvWBo5PyxDHHD8izNxsSS+i1Bw80bVrO/QNkHmdgbNFzja6cPPFQgwyDONTlfQ2FS3hpfpXpCO0SE/JuyUPpvferSaRYB1nt0bme4Ewy8x8cUnk6NbAa62XXLFyOvp6oReFHkNvhlJLPWuPkcGL08WRz/CY9gKkiAOC3GEoyr8cUMfqtaoPVWTPykjfZq1ROrellg0zFZQJ9KxeH6q50G/jXWDIE8h2jimYaXTqSHtorr8Ya4YS6h8Y3XXka9z9DXVZvVYtfyPvgBp8/7iaRIH7fjrZCtd3nCQ+bs1LliwYbbXZfxP2PDayO/VBA9aKBicnxW82ctT/vjimFUQrgC
 F7uG5CU9
 w9SFCN5csy1/3DkadmA7ksQpCtL2ttykSmIiIkdpnfLgKfL8TYWrrgPwllbPCyB3E1YdRu/2828ZgmheM4mLfBJTwgEWLz7H4d0Yqv1TzXYex7VoXBtIKhG7nHJRXBw0kYhCYoHJv7Xt7hUJ7EBWAHhTZ9DD6YCY+DVuEGqgiWXEX88ougRKJ3Dtg72d5bpSpAC+ur0dN1ao056K5iWy2HpHvRZ4gpkecWzZB6Q4M6TikGsCOhiwopkUCnHB7Ir6s9eYPmWz8aK7wX0HOwH6rOfR2W44CehMSng1iRHJjQOIYGbvOuZ38D3tvpWwJfLoBJUKmNV1BD80NWmBPH+C+ScltlrKqqXWmzbA1LhIx15w7liTTx0a3m4rGlmiDWCgwwtvA7AqgbAGhnnNLeT8fGiSZmkYBUFnTHhNJNNH8k/0oavIbj9hP3Hp2/iKFFOTplu2UQu48feQgcFskUgjUs+khQqvq12w/5OvFNWScYtphD9JiUHDAqLkDzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 1:24=E2=80=AFPM Chris Wiseman <chriswiseman@google.c=
om> wrote:
>
> On (26/11/02 08:47), Sergey Senozhatsky wrote:
> > Adding Chris for visibility
>
> Thanks for looping me in, Sergey.
>
> I tested your CONFIG_ZSMALLOC_SHRINKER=3Dn patch in ARM64 QEMU (7.3.0+, 1=
6
> boots per arm) by fragmenting zram0, triggering a manual compaction pass
> at pressure onset via /sys/block/zram0/compact, driving ~240 MB of
> swap-outs under memory pressure, and running a post-swap manual
> compaction pass.
>
> Your theory holds up: with the shrinker enabled, the kernel compacted
> 2,218 pages (~9 MB) in the middle of the swap-out, only for incoming
> swap-outs to immediately reuse those pages.  With
> CONFIG_ZSMALLOC_SHRINKER=3Dn, mid-swap compaction dropped to 0 and zram
> pool memory was identical both during the swap-out (120.9 MB vs
> 121.0 MB) and after manual compaction (110.9 MB vs 111.2 MB).
>
> I also tested adding the unlocked zs_can_compact() pre-check in
> __zs_compact() on top of CONFIG_ZSMALLOC_SHRINKER=3Dn, which cuts each
> userspace /sys/block/zram0/compact scan from 97 us to 27 us:

Is this precheck basically checking if we can free at least one zspage
of the size class before proceeding? Yeah the number looks good -
let's add that, in parallel!

>
>                                   Shrinker ON   Shrinker OFF   Shrinker O=
FF + pre-check
>   -----------------------------------------------------------------------=
--------------
>   Pages compacted mid-swap              2,218              0             =
             0
>   zram mem_used_total (mid-swap)     121.0 MB       120.9 MB             =
      121.1 MB
>   zram mem_used_total (post-compact) 111.2 MB       110.9 MB             =
      111.1 MB
>   /sys/block/zram0/compact scan time    96 us          97 us             =
         27 us
>
> Representative /sys/block/zram0/mm_stat snapshots:
>
> BASE (CONFIG_ZSMALLOC_SHRINKER=3Dy)
>   pre_onset:         184553472  58747279   82350080  0   82374656  0     =
 0   0   0
>   onset_compact:     184553472  58747279   60456960  0   82374656  0   53=
45   0   0
>   after_swap_out:    334196736 107289761  120946688  0  120946688  0   75=
70  29  29
>   post_compact:      334749696 107472834  110907392  0  120946688  0  100=
16  29  29
>
> PATCHED (CONFIG_ZSMALLOC_SHRINKER=3Dn)
>   pre_onset:         184553472  58747279   82350080  0   82374656  0     =
 0   0   0
>   onset_compact:     184553472  58747279   60456960  0   82374656  0   53=
45   0   0
>   after_swap_out:    334372864 107347183  120922112  0  120922112  0   53=
45  29  29
>   post_compact:      334995456 107550158  111009792  0  120922112  0   77=
67  29  29


Ah ok hmm. Sounds like internal compaction isn't that helpful, i.e
zsmalloc already does a pretty decent job at packing objects that
there aren't a terrible amount of internal fragmentation in the first
place...?

Should we do CONFIG_ZSMALLOC_SHRINKER (default to N or to
CONFIG_ZSWAP) for now, and remove it in a couple of releases if users
in the wild do not complain?

