Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6190C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 18:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64ADE6B0092; Thu, 23 Jul 2026 14:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FBEA6B0095; Thu, 23 Jul 2026 14:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EADA6B0098; Thu, 23 Jul 2026 14:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AEBC6B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:00:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90F1EC012D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:00:25 +0000 (UTC)
X-FDA: 85020806010.22.45C2900
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8E6332000D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:00:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JC0jEv5y;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784829623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MUxCdbGeWaQGh+LoYEwItBt1n3zOg3U69kYn+XJ9Jdk=;
	b=q/pPwrFXghSR7gJrHDX4K8zaUrTrPZA7jmfobyS1rBVEoLHFLOo8F0Em5O2RUs/IUf48dK
	XQbS2Jfu18FuhqR7UWlPqhhT6wGp6TB6siQK9KOtH//phggr2CI6Z5hz5yKN1l8rT6QGW4
	A+AXcvT2Z1KjeM3/g6Z0sv38xlkaWoQ=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JC0jEv5y;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784829623;
	b=hUxmSm4GmuPJe/1XP6KHri1WH+FAMmiUMs25izhbqHV+YZRYuh1mK21haQcBwj61/5lD29
	HA+vKCwLlKxWwqXptSGGDw37ffw+y4GE5X6ZelGocRtRUdpG+wbQRJQCGG82ykOHuF25U2
	zN2UxE8JSpvonMFG1QXrcBiGlRyzjCw=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c15e03c2763so140206366b.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:00:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784829622; cv=none;
        d=google.com; s=arc-20260327;
        b=S9YTHgGndGsVTDp7s7l1TwN87tqEAh7qMt4d3515NuO2+CJDZAlEk2zfY0FkVdloiX
         HIzW4/FjDTY+1JaYCnpkg/Ce+y79KttZcd4bZLgCZD13jjt4c8mmGpbkEYyqFLSLpvbc
         rbZsWK4LE8VfiGHPNVM6sgHBl7NhvIb+T0Ygdt/69jgJp70a9JRouccnYbDoVPihUl0f
         eWR+FsIszUw5Tl/TmMe81fCVRN0OCwcvJCiAVv9FFDsqgOz70keVNzB6WLMd9QD6SZEN
         IkYzAkWVXpjOC6hMzyK5ydQa+KAG3FosF7lEazdeKEg5Z9L55fk2x1gfY0hE3xt5Pnd/
         J/Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MUxCdbGeWaQGh+LoYEwItBt1n3zOg3U69kYn+XJ9Jdk=;
        fh=YQTqChsSDSY/aKTsPYMsVyB1bk23kgHg7GE4hmyRXAA=;
        b=Kedy/TUjurSk21ANksPk5uuKNpZaFEdXOq1D7hiu0aDat1OZuqgUuZsgqBwuKv0jCl
         SQ0ApIeNe16H21e1hKSM5eXYnmjeYKw7+4atnNWPy8eUqWBR8uBGNTcmz/ptyQoOo8QL
         p9UA2Tth2mukQI2I7C+r+vYb9lVJh/uTJ7DhIxtYpeIXjg0PGtv3MMBrHXvPZyOMgBHn
         BCzAIUxnDELA6VHTRHGwUbz1gNiNBHe6GjPUxWd3f8+kIlIdbHggi+xou/LUdq5VHM3U
         SuYrgzIKMkc/joJKT1LVz23Uoj3jLptXUMiq5hWeHOxxAydHgQ+zx3cj+BrgBMWMnk/L
         wtvA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784829622; x=1785434422; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MUxCdbGeWaQGh+LoYEwItBt1n3zOg3U69kYn+XJ9Jdk=;
        b=JC0jEv5yCyS5FnssZ9jw31z60QEtwUrFscoWsiN0yU9Jy2Ak6vk8f8idxX2gfbahvG
         UaaLvn3AeNXcyBHLbxZpN1BuBeW8sbaNOdl6fIyvu5Mu81xbiC18bMoPR/GOlcDDrh1Y
         3HCAcfASaz4jHBmTZrLXLKcGYhNLZTTLyaPVJ8sDsNv183y2COde3/dTKydw9CW+JP89
         9MM9dsn+0PTLMR0P2xavrfLzbtMrAeT++yvqdohJv9FXRjizplV91RZxEXv7BJQbX7yc
         FrXujX+UwFHXz6Uk+3QkI3HktZRWNpfpZJzeCnd8yinug9cE3BspPz7KS6suGikghwoE
         Xp0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784829622; x=1785434422;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MUxCdbGeWaQGh+LoYEwItBt1n3zOg3U69kYn+XJ9Jdk=;
        b=looqeB3B0BMkIQseagJvROtr8x8ENLyax8tnxRqjnMakude4ACh0o/FUtxGr1o+4WV
         axbJCxO5diF3kFS+jek2/rqe1iTaTKslmukHtTfnFxYBO+yoaj2AW9oh+itn30wS73j6
         J1yk/xyIU00NetG+mIWAvUcYiHRHQEsXH8JHrUgF4U5l2wpIjQU3/oPcF8WMrr29a5n3
         kd6tn9zWmFTXwRD8HDDzVPjJ79zVD29KrHFDvkaOJzCXbxfPZiXQBSnOe9CzN6LyjOKR
         YE+mvHCkuctkz/gBIoC/8tdxaoRBSvESCdGxsJ9h9OiMtoDriGCAJ64mqrPtyMYygaDS
         oArw==
X-Forwarded-Encrypted: i=1; AHgh+RrGkrUKeT8Z/Prfyi5mjhQ64+ZZHq03BV4Txv07xKQ0XndKHsF8O9IkyGXMJzBqlQ1wrrwoGS7sXQ==@kvack.org
X-Gm-Message-State: AOJu0YzHELApMhpvbJA/eEoXOD0Gh6MA6eik/b9rCDXJTr37m2/CVFG+
	Qo+I2MMXD5+PWXkYpl5u+WAdg6BuD/0jvnZhnHRC/H367e9xieSy8WFAvIXHnYxDILHYD0hEPRy
	RjTnAobFcogmR7W452cQXTb4RgEg3iH4=
X-Gm-Gg: AR+sD11kAQG2p+npiDSehBvZ2tZ3/9uuQnX1q/hmaf8SIZ5VYP8TmSg41OLMU6r8UGe
	e1d8/nexhp2bOyjJdYuzgkApcMlcmLsBWDZMJonzMhyi49+6Tl3n9tmm6awMCsKww0e0gbRjoow
	I7zuaeoHkXHMfshEL4n5lzfb/S0e45I0fQL6GIWkFkRnHA+fUJ/A/BXlcmxe457PYP39liejsKs
	EMTMNxdBT/XP35WJAmzkL5gZUeBZdq2d4xPsBYYX8Yv2Q+b5SgXPPrEItesQ3j2EZxuL0tpCwFW
	I7e6WQXs6nedH2eHR5w=
X-Received: by 2002:a17:907:9619:b0:c19:891c:e1a6 with SMTP id
 a640c23a62f3a-c1c536c8d6emr180399366b.12.1784829621600; Thu, 23 Jul 2026
 11:00:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260722130615.3163560-1-hch@lst.de> <20260722130615.3163560-2-hch@lst.de>
In-Reply-To: <20260722130615.3163560-2-hch@lst.de>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Jul 2026 01:59:44 +0800
X-Gm-Features: AUfX_mwYG6fMwqod_7vhQphcNSi4VFizKHSgiYv7Hwr5KRsNZH6h97bbms1Vw_s
Message-ID: <CAMgjq7ArsgdKf-uZ_drQ9Kqtq4i_MMZ+dP+tjNzPrsrR0YPBWQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/swap: revert to single-folio writes for
 synchronous swap devices
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, trondmy@kernel.org, anna@kernel.org, sfrench@samba.org, 
	linux-mm@kvack.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8E6332000D
X-Stat-Signature: y76sut95uisewjwx4q6ek4iyxusdjc4u
X-HE-Tag: 1784829623-462849
X-HE-Meta: U2FsdGVkX1+SqRqxabMNQAzNPHNInsaoKb4D3u101LehY52n9Ixx/lo6QvU6A/+SLXE+rKYRVHkRDX8HUBlUJQhMpBBGj+dUS4k67oUuoWIp7/MCwp03/N2nimcYqRKdv+qMAUSb/C1HlKg7P4ko1Zcfc5zdPJz8KCewI2Nif8F+MOWEi/0APFS4UGyPqr4cqfQn1qle2feyFCt7ZwajpM7pAJe5D5m8rPry1K01bqwEI4PrQTsihGueGgthCeo+BFuJ1P12Qgrh1qLAuDoli3lDR6gExU4+Jx4acjYsjcYcOPgfEkS22FjIr8nSiZ7HyrV0gADDqq+TdwUWDt7iBjGlVMP51HJKiFdk3+TRnVMFgjVhCDUBVkQ/MuFA7cjyko/8NmuiyF2RUjpM5DZN4gBHv2SCoI6fhzi6a+3BzUtyB6Yzx6BDc8ujAWxdP72iy3H0fH/gJeSI/Rgk1Fy5yb+gI9tgJ+dVOWLBswQ5k7ROV5oqspsMA115Aose/JZhfZ97qd3VP7LGvFiSzzBkt7+n3mc9IOMAPnP1PH3R7VkkKqnwZIoI51F9XNrgcSrIKjkv2hxKJifZwdRjSEEWLB7dakuj4JMx8P18e6wCgZ2XdNUmQkv+K5avWKwtexcSS40N4miH/er7VLWy36z+2WPoYB1PWk4B55c9ESKzA8hdQnvc2vJCWIysgCjgtwf21x2mRYXcN1p6TG9ArUqbZGKJvMbbTQv6rTGJM9nksxUqpl6wCwPkHgaXWuzJ2WXj3Y7Qfug47Ytmu9pVmgu9yDag4iKYW/dPb2ZWyC48P8A00Ly+o553PUcR2BkN4ccyIoBjC67XYwXKoeFRX7SKrYNbJEVvLVC+Cen5ux5aNqs8icKqTt2EnclV45aGRpwk7VUNSd0e9TYqS6bW5c4+iBw4qUMtKtjfM/Kq8yo6R7DCS0R91amQoFB2sycCEv3EXw/L3E0c+bFOh3saZ5Z
 KrP0LynD
 f1PDedP1zuYKaE0ZdUCaVltCZkUuq3YfS87ARu13iU82w1tVRzanNMDPs5+BPciwNFTmb8icKh0ykVVaHsniGTe4toAd5kwoqG2n2UkLcizrx9uqb1ksPbsgFGzjZLCdQK/MiRRMC491lkqKdaYw5u/yrMTf9wUn+dkFzswmPRHekG6xRcbXFvH+bZ1fFmP+WIcCTGlhpodRLFQ6A8Z8ir1lwVUf7FMRsvj2I6cAmYzAFMKzzrJOI7jSaaaJmYR85pCoBj9CGMpg+R38/yxxsB34WTsGd/yavhx+6FF55vV2rX6N/Ltm+/RvQZgPO9OadxpxgbYJQxba/9V5mPc5ADsBfY6J1qrCiapEZy0387mZxqD3bKL/e4LGLjGT4B1x4r0/K6MYD7BoAoU5jBzDWAf9qo9reDTkqJViz3Qv5n3pYcvo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 9:06=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Kairui Song reported that zram benefits from submitting each folio
> directly instead of batching up I/O because the classic LRU scanning
> benefits from clearing the folio writeback bit in the scan loop.
>
> Accommodate that by kicking off reads for synchronous devices for
> each iteration.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/page_io.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index e4fa7ffffe8b..c984a4023a65 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -358,7 +358,16 @@ static void swap_add_folio(struct swap_io_ctx *ctx, =
struct folio *folio, int rw)
>         }
>         bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(foli=
o), 0);
>         sio->len +=3D folio_size(folio);
> -       if (++sio->nr_bvecs =3D=3D ARRAY_SIZE(sio->bvecs)) {
> +
> +       /*
> +        * Write out the iocb if we filled it, or if the device is synchr=
onous.
> +        *
> +        * The latter is to work around expectations in the classic LRU c=
ode
> +        * which make synchronous clearing of the folio writeback flag in=
 the
> +        * reclaim path beneficial.
> +        */
> +       if (++sio->nr_bvecs =3D=3D ARRAY_SIZE(sio->bvecs) ||
> +           (rw =3D=3D WRITE && (sis->flags & SWP_SYNCHRONOUS_IO))) {
>                 if (rw =3D=3D WRITE)
>                         swap_write_submit(ctx);
>                 else
> --
> 2.53.0
>

Looks good, thanks!

Acked-by: Kairui Song <kasong@tencent.com>

