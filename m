Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5E73CA5FB7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 17:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258C86B046F; Tue, 20 Jan 2026 12:46:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206706B0470; Tue, 20 Jan 2026 12:46:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112C96B0471; Tue, 20 Jan 2026 12:46:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 00E726B046F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:46:19 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F2ABC2506
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:46:19 +0000 (UTC)
X-FDA: 84353071278.02.D109BFF
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id 82185180005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:46:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZfBzN9qA;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768931177; a=rsa-sha256;
	cv=pass;
	b=XQxWid6pyPZNS6ap8zsbnwj2rtytlVIEPWz2/Iky46swaShdCTuWZPKhpnTX65IiU7qc/e
	JqoPAj99UCIIbAqROWjWzWIIVA3UUWbKSprAv5WhySjBiS6sYJDrf8bs16hq4czSDg5de3
	aI7tBP9Em5OA9bNK2ES1SLWdWeo4kJQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZfBzN9qA;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768931177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S62j0SHPNW708eY63qC28hPGcjYC7bAFOz0DSzigrVs=;
	b=Ak1KeuCtXqpKNQkZQS2hGW5VMH4lABUfB+gmiOTQDMZGARHyU6ZGt1dO0Sbjy/XwWe7vgg
	1TSzmpkYijr4/JNtEOAxa08ldasRQlm6f5s345xyH6sU2TBMiP4mjrL/aCVzXl1TJe64Hh
	3CkltU5DGuUrrLjv/+4w0mKxG+bAVhs=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47d63594f7eso40641615e9.0
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:46:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768931176; cv=none;
        d=google.com; s=arc-20240605;
        b=g9Feimyj6G/Xxy//i4BCr3UjY08Xy73S2DnfjV8BeCD/MNtNBE/ATaNxSVOoU/rC36
         dniucxVkFq8rmPzmLmIolvYdKBYywgLb3Sohf5MFllsF/Rh+TyFj0h+yhjEURYXE2KFh
         Nsv2lfADy/GkIijIbrEE7Xro246MAt5QHCXxKxsVY2AUmCJ9smNvtzXatrBg7eqB9aEy
         5axnlUj/TNthKd4Zu232j/ScjAdVSrS0JDlemd7hTWxSXazjrqjCMqck3wK11IFK4xxZ
         Rc7sfZNmPX+6tp2n8VgKY/ueWUOprx/bjJdZ68Bf31bt4aym+uLyWPjED+RpZ37qmahB
         Ky4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=S62j0SHPNW708eY63qC28hPGcjYC7bAFOz0DSzigrVs=;
        fh=pEufldifWL04S3Sphy8jQUAk/4HQJQltNS2DeP1f4BY=;
        b=joWBljIqBdZTSEXEtrcA+Uk/eqoxxE2G01VxrXTON1xI3HrFl4yPcLEnCoQkA7hZIr
         h/ju7Tt7Fkl8ggB5+fG5ttKxhnzWmy/coeoEy8iXeCsjYGMvn2J5RwHEVkI5YoP1wRS0
         zTcOhWy12aWjeczheeLyRo1qGE0TZmG57LlitulxeeW84r0QC6jnXVy+W0R+xkkJ9Tr7
         DrOZQi5RG6FZfsw2cUSmb86NloG0u36Ew2l5SiYlqGhxzLHi1ONoIhzecD0lDNvfHysv
         dXr2+rxZjztp7WxZAUHyPhGwVbAo1fesGN1BhzmTsiPs0rXagB327SeTYbS2kAIeg0OA
         Lq3Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768931176; x=1769535976; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S62j0SHPNW708eY63qC28hPGcjYC7bAFOz0DSzigrVs=;
        b=ZfBzN9qA6wVzvxpqzfnIw6qu5ssYjaDzeZS5SvRhUT5vX3hXJC/VjkbnEoWjMfWCqu
         /u9UQvsFqEl1FIPm5jcjGrpJs/UAAqXzzqYU9sK3nQvMUKrT0U1q/NAbc5QhVG4YynDd
         H59Ozo/zeY9zEDKE+9Eq+9SRTDHN2Cm2ymsOwl69KDl3/7WMycc2TTsBYXaXGGj2aSqg
         orkjSoQhuc8Koo5ZF1AEzlWk1SfnL9MbVfScu2XzdVTm5tTQtjepK/hPyAoqrjxDVbj5
         qBvz2WvFLmatb2saggEmoGO1n7RWM4hhq4ekc0bSJ7gsn2pOv67aUIn4t3bpCbOr/X8f
         lR7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768931176; x=1769535976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S62j0SHPNW708eY63qC28hPGcjYC7bAFOz0DSzigrVs=;
        b=Vg+eQ+rc8XGDLI8ltoGnSjtEcblwNCsSUbueXJ8EulqwjpKGOOt5Pm1wCq/SqRfZfr
         BLYC2F9832GFL/JYO5F+7YDIgo7kMt3IO7sZ+WSwnfHey/+C3GsPKoJVeosL3NRFsZLE
         s1Ac3mvkBDYrjx6B3rw2sJ3kZRfuygiUmk/Qft+U7mTAkIeiabKGflvSWVStv21Pu1JZ
         PO+5DZt3AXTMX9tOYmGf6t6HEfgM4hq6LaTSYuvjFCnsRdXy4UOSkLHt35OPJA4pa3qc
         19uOp8nLxeTXDw6NDdcwjE95UG/U1CeQw3niCagSkWcUE4bSNkh2CQLbilUdbkewboaZ
         ytAQ==
X-Forwarded-Encrypted: i=1; AJvYcCViu+feNdBpn3P27BrZlr4JQ8dikXJ9Bp8Yi5lEa7Krr+jkqUzZK8eqetfm1m3NEgE29KoDXFQaew==@kvack.org
X-Gm-Message-State: AOJu0Yz0QywGgpUvoh3NVuGQPwuAq8MawtaAuQF13Fcal0mJs2PiNDYp
	9l4Lkaktjo8GOi0Ce5IuU6eYSoDIwhnQeXe+qArF8atekr6Ggyg18iP1ovLg4WeWSajY3dbauli
	P7RGYXD45Hs22r3ceMAiGa1EtV4HIS0w=
X-Gm-Gg: AY/fxX4IX5udAg4VgmXgSjbswF4v5AqallJYZimiXD9ks7W+b4N/NfUKHEry0eZxypk
	BRUUhSVUukX5YnVGXKDm2iBQ03MEsBDS+hYwgn+yIwu4LnvzWWTVNo6W1DNQoXzeD/dGParRlsg
	5laIlW/ZLVfmiqIJYTnF27rtyb5TjtVwuvy9h5VdYt88KBuxSmdtFqGuaMriHmlIbb+T8u+IP6A
	djxmoIco+oLuksTvKD3RtKZ0+FCkWE+Tm6AWB2cuEBn/6mh2Jx9IbP5Wjp7Ds+tzsBHFtHGMFik
	b2fzXmGgfIxgVgCyEJIezb6CYhfvuw==
X-Received: by 2002:a05:600c:1387:b0:47a:935f:618e with SMTP id
 5b1f17b1804b1-4801e30ba55mr226386785e9.15.1768931175524; Tue, 20 Jan 2026
 09:46:15 -0800 (PST)
MIME-Version: 1.0
References: <CA+fCnZcFcpbME+a34L49pk2Z-WLbT_L25bSzZFixUiNFevJXzA@mail.gmail.com>
 <20260119144509.32767-1-ryabinin.a.a@gmail.com>
In-Reply-To: <20260119144509.32767-1-ryabinin.a.a@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 20 Jan 2026 18:46:04 +0100
X-Gm-Features: AZwV_QgHEFU4vEPzoSPaqq3jpo5TVtLgMu7Szxs9QJWFvb1rbWBsdNTSzpLq_Nc
Message-ID: <CA+fCnZddq=S0H5qXZ_CLSB3Y1cNw7nY4AYTBsGRR5DmY5+=paA@mail.gmail.com>
Subject: Re: [PATCH] mm-kasan-fix-kasan-poisoning-in-vrealloc-fix
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>, 
	Maciej Wieczor-Retman <m.wieczorretman@pm.me>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	kasan-dev@googlegroups.com, Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 82185180005
X-Rspamd-Server: rspam06
X-Stat-Signature: ajad9rz697hadbdhjnot9fxktgqhfa76
X-Rspam-User: 
X-HE-Tag: 1768931177-949464
X-HE-Meta: U2FsdGVkX1+4AFMX6s/Ds2zRyqTECRmiibjVl7chHErKCXmHSHANf7J/7JBnWjVAHCBV9sNJNv117kd9G8FFz1T8idZZWCowFDBDi815UiKLqPZm7oAnLV3c1JR6wW7WwBjXXIXK7vw5/9ih8o+JPTervP2QVdqvDSRtl/TqKqL2YGstlkmzr9pVInzafVD4Dcjswsf07/lY9Ep/tb/QEQf6AUf7S6ivnCkfLzic/DKVVoYIdD7ygJGGF41GXbmH8gGbqawbJVXWptYj6P6pE21LCziBkzHTnVCGBEZ+X0BSu8DixuYsz9GyQ3IVWCqQthU2retH3LZFi8hUV/YMu+v+sPSRfd7jCQN4it1qKVRB2XD/8byDpLVWNMEmRbSaLIkLKhFsjZhds+45gx4G8Dgf/N5SbdnNSV4J+W+HxCEy4K8pZoWt8UlMt9nDXntyIiKzvtrBCELppJwsiAL8AaZXLtbI9zZ2AOoAP7ZYfiZVt1CflLZN1FxDg1aQbNCH2+ieP/VKE8XUQC58rN53CNEsyLFH+/BrZfWMDdC/R7LwvTMhF4Kq4wzQ9pXErs7RhrgSsMZ7WJvLNN3Bng0sTyi7RFuqhtQ52bWft4LZZL0lo4U67Nenm2VzoC/MiuQ0cyLecKcuN9c8FXodgyYu2/24L+/W6U0JKg2CwDU3LJqSzubPKh+pwmeHENkxDXALwKK2yHosMJEn4+sggDapWkQUSnDWMX+GmuHG1HN6Vwf8aJDhGhoTww9ubfBagenrCqLUnGXFWXs+ygb3BS0tXftk9drWnGOOTZDnQ4wey7RReoFO1N3c6o+zR3SdBOyIF3rqnSCcG8MuMw7Y5T3iP8npfI/IeSGj5SAEAz0/f0frfK1P+jGmjo58KlyLawUve/bPNCeByIb5SqTjerpZ7Q2wyEjXKw3muMg1wxDLcBAE+tvtuO9rEGJB4c83fZP3qTjhvRCCXdbWvKvmCMH
 ofdyZPx9
 Pl27fYyKT7jnUEUduJsOllcBJEok8VDGsVt6rTwHGeNW0+rCK3bd9Q3V78yng33E/a96HcljrDVw3Szpuc7CUq02GlX2myNBaKTkVdfpgAR0oXDIa4iQc+pu6RcB1JnBmHX+HMyiK8AbLSQKmA5ryjY20nBQ7rjqXOG+5X1iz7xURYsYmqc3vx0tA2T8/uIiNT1FOJrfVfw+h2eSt5w1LmTxcWSMScgU32jZK7Vhb9aGxKwczInfsZbA4kkmGCkltb+EX1WD3M7it/EL9r7OycZ4KCTyG+0zTTglcGI4AUbV62MlwgQvNJ6x3yrgLHRtXtmQKnKAagu6uoEkI/hprolkwS7QPHQU8q5/5tQXXffXnTNZJTWfNEZzPF6XLxK8VvFZSfkLAMbte/pyTnxeeSpbybWIPVRw+pEb3jBz0/TqZy1uGmikII8ZY5+tABSGP8S1MokME82oHtaz4hPwXMCUikAUfWfKvlH9/EPCKGRv+zmc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 3:46=E2=80=AFPM Andrey Ryabinin <ryabinin.a.a@gmail=
.com> wrote:
>
> Move kasan_enabled() check to header function to avoid function call
> if kasan disabled via boot cmdline.
>
> Move __kasan_vrealloc() to common.c to fix CONFIG_KASAN_HW_TAGS=3Dy
>
> Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> ---
>  include/linux/kasan.h | 10 +++++++++-
>  mm/kasan/common.c     | 21 +++++++++++++++++++++
>  mm/kasan/shadow.c     | 24 ------------------------
>  3 files changed, 30 insertions(+), 25 deletions(-)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index ff27712dd3c8..338a1921a50a 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -641,9 +641,17 @@ kasan_unpoison_vmap_areas(struct vm_struct **vms, in=
t nr_vms,
>                 __kasan_unpoison_vmap_areas(vms, nr_vms, flags);
>  }
>
> -void kasan_vrealloc(const void *start, unsigned long old_size,
> +void __kasan_vrealloc(const void *start, unsigned long old_size,
>                 unsigned long new_size);
>
> +static __always_inline void kasan_vrealloc(const void *start,
> +                                       unsigned long old_size,
> +                                       unsigned long new_size)
> +{
> +       if (kasan_enabled())
> +               __kasan_vrealloc(start, old_size, new_size);
> +}
> +
>  #else /* CONFIG_KASAN_VMALLOC */
>
>  static inline void kasan_populate_early_vm_area_shadow(void *start,
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index ed489a14dddf..b7d05c2a6d93 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -606,4 +606,25 @@ void __kasan_unpoison_vmap_areas(struct vm_struct **=
vms, int nr_vms,
>                         __kasan_unpoison_vmalloc(addr, size, flags | KASA=
N_VMALLOC_KEEP_TAG);
>         }
>  }
> +
> +void __kasan_vrealloc(const void *addr, unsigned long old_size,
> +               unsigned long new_size)
> +{
> +       if (new_size < old_size) {
> +               kasan_poison_last_granule(addr, new_size);

I wonder if doing this without a is_vmalloc_or_module_addr() check
could cause issues. I remember that removing
is_vmalloc_or_module_addr() checks from other vmalloc hooks did cause
problems, but I don't remember what kind.

> +
> +               new_size =3D round_up(new_size, KASAN_GRANULE_SIZE);
> +               old_size =3D round_up(old_size, KASAN_GRANULE_SIZE);
> +               if (new_size < old_size)
> +                       __kasan_poison_vmalloc(addr + new_size,
> +                                       old_size - new_size);
> +       } else if (new_size > old_size) {
> +               old_size =3D round_down(old_size, KASAN_GRANULE_SIZE);
> +               __kasan_unpoison_vmalloc(addr + old_size,
> +                                       new_size - old_size,
> +                                       KASAN_VMALLOC_PROT_NORMAL |
> +                                       KASAN_VMALLOC_VM_ALLOC |
> +                                       KASAN_VMALLOC_KEEP_TAG);
> +       }
> +}
>  #endif
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index e9b6b2d8e651..32fbdf759ea2 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -651,30 +651,6 @@ void __kasan_poison_vmalloc(const void *start, unsig=
ned long size)
>         kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
>  }
>
> -void kasan_vrealloc(const void *addr, unsigned long old_size,
> -               unsigned long new_size)
> -{
> -       if (!kasan_enabled())
> -               return;
> -
> -       if (new_size < old_size) {
> -               kasan_poison_last_granule(addr, new_size);
> -
> -               new_size =3D round_up(new_size, KASAN_GRANULE_SIZE);
> -               old_size =3D round_up(old_size, KASAN_GRANULE_SIZE);
> -               if (new_size < old_size)
> -                       __kasan_poison_vmalloc(addr + new_size,
> -                                       old_size - new_size);
> -       } else if (new_size > old_size) {
> -               old_size =3D round_down(old_size, KASAN_GRANULE_SIZE);
> -               __kasan_unpoison_vmalloc(addr + old_size,
> -                                       new_size - old_size,
> -                                       KASAN_VMALLOC_PROT_NORMAL |
> -                                       KASAN_VMALLOC_VM_ALLOC |
> -                                       KASAN_VMALLOC_KEEP_TAG);
> -       }
> -}
> -
>  #else /* CONFIG_KASAN_VMALLOC */
>
>  int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
> --
> 2.52.0
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

Thank you!

