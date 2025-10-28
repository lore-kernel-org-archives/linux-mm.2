Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56530CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B343A8019B; Tue, 28 Oct 2025 13:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0C3280199; Tue, 28 Oct 2025 13:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21D28019B; Tue, 28 Oct 2025 13:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 85BEC80199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:43:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5583812ABA0
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:43:31 +0000 (UTC)
X-FDA: 84048245022.18.0D506F5
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 66F6240018
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:43:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gkKVIp5l;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761673409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tm84HDvajvdUeYx0RetHD/996j4kdkLd2nXgDOVyMuw=;
	b=0C2jmmTO4LwETPwSDMTkCFw+MJDnn7YdyJ+rvStUBkMrmAvg6MrfRc1CSyg4GI8CU3o4WW
	PLIRmVi95OvRGL3cQ6MT6+Ve5Se7XCit3tD4N1aDeQSAzLy1LDQgTKmifMxwVgvl2LX3Ki
	1j/2LXBug0F7h8Xfw2rigejhkdpnG2o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gkKVIp5l;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761673409; a=rsa-sha256;
	cv=none;
	b=DA1ktI8rhtA+26LXagGbsNMUkvKk//n40ZTX6hudQyMQP6aXGHa3Vqe05ah2lnA5zzG8jo
	SBU3/LG8uLUY6CmGMFkBsChIzTS00uzL/vTe0yUpI1x0J4Y2eWrtyvrPA8bnU9WGi12t0r
	aRyHotwcxdaj0SRXu5TwXJD+1j1Rzog=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4eccff716f4so31451cf.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761673408; x=1762278208; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tm84HDvajvdUeYx0RetHD/996j4kdkLd2nXgDOVyMuw=;
        b=gkKVIp5lLRqHy8chaZw8uOff5HcvdU0/jHHYfDlMD2ybKxByTXwzELylfEDKmkhfmp
         QLuXjSOu8gY4bFzY8kYZXIvr9QkiDe7Ag56K7t2SlCJJgC6hczrf55skdoIa5zIXmAIZ
         DM3wr95tPnp+hCeRkVE2PXWOr0JiuwXAo3tTVmYCwewZUDW6Da6BPd3zEBWjl3GlUBj0
         RJ6eTfsKkJjONbS/UcZn9THMqHU+uhMmN7lQTdGRhUTNpXvawP6K/swGKFwj2xJcmWSl
         bmh2/E6nYwloY31NpVPJ+KPmqm2wyoqSp/rzt2Q6iC6BETV6ufrLais1uhXLS7ADCu4H
         AbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673408; x=1762278208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tm84HDvajvdUeYx0RetHD/996j4kdkLd2nXgDOVyMuw=;
        b=nWq+Ee3gHwbBMKyU5cY2WVvcfs/cxWhp5XFDoWzxAJvFUvzdhvOlgty+lSj5JAzQri
         hRhSBm/L5WzE/7fDbrfVnp8QTMBpdrGFKtqA9gSAIDWiQKEKScgOcmfoeiL9aLtvAhIU
         sCXK8M/MCFujpo5Y67eO6tyShtSNFQ8eSLoWuOddzOlWGXJwKSjn3ZZsMg/YDEWeLpKT
         VNycAm8IiBCTmoUc8jnTASosae2EYtrLaFp3pnjEdjtIurbAgqJmwHgbBpKa3sXA+wMj
         vsd1MB9pTtvczYCN7pDwdgWi4kTi2fAw+ZEXSQ6Z74vpyFhfiG6aiOwV1ELBK96USFle
         8O+g==
X-Forwarded-Encrypted: i=1; AJvYcCWorZdFfJktyR7B0tXRNbZS4DAK9JUhufWnEcsz/OOmxkyzd+6GcIj3spIwzmFj+VcK+TDhswCEbw==@kvack.org
X-Gm-Message-State: AOJu0YzAc2Z42tZp/ISKYYJcGz55qtg/sj7KIobqtrkJ/I3SYAzOVi6w
	0ciAeb7FwAwpSLPpxVLRniUmLd8s8dnYLXzfGoE2fgkh9KvstsAGoFk0YZlPEhrUXUB2SioHv3x
	Q9laKUpcP8zXKF4fWyG6Xzy5kGeOmQBUavvrGM3+b
X-Gm-Gg: ASbGncsOF2wrmWFizwDA8okO6inHrMksutfWj73iPiPAWv/xQZZeF/j1/wj+wxCFoUf
	Eb1k2eKqW6ukBh1S/i3+mdqeilGvqfbs8Lr1WyPa+d6nciZAhyOc7o67tjJvIjrcyi2/QEocjJe
	nSFSYNJ9Vrsl7IPALJ3u7jMlxvpdVsUiAOEEjQahHJr4S0VTI7KD56V4qtTTYmpCe7MTAn71mnd
	cuz5nwua2zFtU7WUxkXBsj9Efa3H7YTQhQ6pyOOOHiO/LFj5qzBk701vEQ/gbkvwP5NKTOxUUry
	VTLumymvP5XN3pGsutnjOpz53g==
X-Google-Smtp-Source: AGHT+IHqOw0wVAMZdI9HPTfn0JRAVi2UYS5cUsNnlCDAZHhG876N53Uqz0wugy8aVXJs9k9838Yo4Ajkv/Cn41vL3UM=
X-Received: by 2002:ac8:57c4:0:b0:4b7:a72f:55d9 with SMTP id
 d75a77b69052e-4ed1593d02dmr323231cf.13.1761673407812; Tue, 28 Oct 2025
 10:43:27 -0700 (PDT)
MIME-Version: 1.0
References: <20251027122847.320924-1-harry.yoo@oracle.com> <20251027122847.320924-2-harry.yoo@oracle.com>
In-Reply-To: <20251027122847.320924-2-harry.yoo@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 28 Oct 2025 10:43:16 -0700
X-Gm-Features: AWmQ_bkEq6fU-X83NBs-FScowfdztSWFRPMtVvCpjCocisVvI5BwLCPHsCScVHY
Message-ID: <CAJuCfpF5gG63njY436vctG-Tzbco8X9a1w3YA=u1AGrRqxVshg@mail.gmail.com>
Subject: Re: [RFC PATCH V3 1/7] mm/slab: allow specifying freepointer offset
 when using constructor
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@linux.com, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
	rientjes@google.com, roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, 
	shakeel.butt@linux.dev, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 66F6240018
X-Stat-Signature: 9gs8ppgozkmpbk6bnzqnfq4mfbf3p9qg
X-Rspam-User: 
X-HE-Tag: 1761673409-958876
X-HE-Meta: U2FsdGVkX1+/5ScSMFN8PxF3zmJ0Uh4LR9gdy1glQ8tJHbrBtHV+cX2zqUb4BodTpALVui1sL+XhHU4OnXKo9kbpLAeazVbH8QCXTLgezcHbxH4BSVd5QBfvZ2vpUUkM/uBqlqfLqKnGpvhet1sNBVlF54rpcOoYHUEIX01oTQfsbo8wAvfUmThTIqtt3RbHcgj18sN/v2umuK09neFgX/Y5+z+mHG8SJEo5V/jjh4eUiETOUHpeRcyfrQS01wXTG9ag+ZX9JIFnpcz4jW/6xGq8SwBvTL5wfwFd3sKjwJS3izE1pW0zjjnxmaHn4Q2P64A0dXM3GUPMGu8MrQGlq26/QGBpghoUd4a0NDX8nN/upd2hbwU63oPARpfLwOPo0pnKYJ9VU9WGuW3jdgUDHoDkwuJG/GH1lWVey+7aqfnQ+rvXY7LpkR/6mA8MOUPGt1foGgySsBmkG2Dmg5XMvBWCM69NXSahSGL1LBuK6X+uMUqGqb//8wZMjJGm08yBze0BVl3x74WtZze2HpopBmmra0XjLASKoh4uc2M7/GcDqS3KAbwIlHPA3bFsy5trRmz0Yrx0agl9vCN5yec6YMBCpDdR9rgLt8wUI10hmDcAAVUYiEKCdDw1kqEr9mFDmIQz1GfzytnVGcXlL8bBo/xeD3TQR520OFRq4xeqemqsISEHV22bCPamMYy3yuQ7sQHMUku+3j54fplCzZWprtJC/hJP2nXYDpd8LYsLI+ndZBHfrXMPV3ciwnOvGbKIbCpRaVW3W0cELsRkWshYbLMQpNGD/iXdTUd47eY3I0D7Y3THw4xYpa61Rfgq3UlIbYMsZihkPIoqzkgmH3TUysebov94bLANp0fpYraOX0aOcOxz0WSyx1LE3l+AB4pqhH1vuRkx39l2wbcFeg4PO0v7CEtpnzxvsLThqUFBQRaYc1JpBSNmafUuAV/vDNYKNCf2PCREqV+H60jdYR+
 0xvrPil9
 7MEqdI/wp7OjS5xEBxdBE2maYBGCnYayrtUkO7PpX56JB3smNs8EDebIV2Q1mbN/Dr6XrT0VJNvTDATDBDKFYUtX6VzHhySZ+Hf8M0vYEzy9PThyZ6hRhUABmyNc22xrGXwQ/Z3n92/CdV3Tg7a++ICalljf+FmkWjz6XKshk647ncZsZrNvRuAr/4itTku30LjEQzaszNILDhsaT7uA82f6KxzcUqfEynacZ7W4jx0p8x6cLnlAIp603nQpqo7M9ZlAniJCu3SyUuFhW09wMY3Ti3cbSSn7H69jZeUkq+rQXqcpyPakqHnBQIot7RvkreEIhuoaUQK/RSd/hgBtrh8MCx8r1dNWuXBwD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 5:29=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> When a slab cache has a constructor, the free pointer is placed after the
> object because certain fields must not be overwritten even after the
> object is freed.
>
> However, some fields that the constructor does not care can safely be
> overwritten. Allow specifying the free pointer offset within the object,
> reducing the overall object size when some fields can be reused for the
> free pointer.

Documentation explicitly says that ctor currently isn't supported with
custom free pointers:
https://elixir.bootlin.com/linux/v6.18-rc3/source/include/linux/slab.h#L318
It obviously needs to be updated but I suspect there was a reason for
this limitation. Have you investigated why it's not supported? I
remember looking into it when I was converting vm_area_struct cache to
use SLAB_TYPESAFE_BY_RCU but I can't recall the details now...

>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/slab_common.c | 2 +-
>  mm/slub.c        | 6 ++++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 932d13ada36c..2c2ed2452271 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -231,7 +231,7 @@ static struct kmem_cache *create_cache(const char *na=
me,
>         err =3D -EINVAL;
>         if (args->use_freeptr_offset &&
>             (args->freeptr_offset >=3D object_size ||
> -            !(flags & SLAB_TYPESAFE_BY_RCU) ||
> +            (!(flags & SLAB_TYPESAFE_BY_RCU) && !args->ctor) ||
>              !IS_ALIGNED(args->freeptr_offset, __alignof__(freeptr_t))))
>                 goto out;
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 462a39d57b3a..64705cb3734f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7781,7 +7781,8 @@ static int calculate_sizes(struct kmem_cache_args *=
args, struct kmem_cache *s)
>         s->inuse =3D size;
>
>         if (((flags & SLAB_TYPESAFE_BY_RCU) && !args->use_freeptr_offset)=
 ||
> -           (flags & SLAB_POISON) || s->ctor ||
> +           (flags & SLAB_POISON) ||
> +           (s->ctor && !args->use_freeptr_offset) ||
>             ((flags & SLAB_RED_ZONE) &&
>              (s->object_size < sizeof(void *) || slub_debug_orig_size(s))=
)) {
>                 /*
> @@ -7802,7 +7803,8 @@ static int calculate_sizes(struct kmem_cache_args *=
args, struct kmem_cache *s)
>                  */
>                 s->offset =3D size;
>                 size +=3D sizeof(void *);
> -       } else if ((flags & SLAB_TYPESAFE_BY_RCU) && args->use_freeptr_of=
fset) {
> +       } else if (((flags & SLAB_TYPESAFE_BY_RCU) || s->ctor) &&
> +                       args->use_freeptr_offset) {
>                 s->offset =3D args->freeptr_offset;
>         } else {
>                 /*
> --
> 2.43.0
>

