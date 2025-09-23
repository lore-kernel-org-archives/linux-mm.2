Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC855CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 16:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A238E0008; Tue, 23 Sep 2025 12:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10B068E0001; Tue, 23 Sep 2025 12:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B378E0008; Tue, 23 Sep 2025 12:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD4FE8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:46:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7EF128760A
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:46:23 +0000 (UTC)
X-FDA: 83921093046.16.EE29C1D
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8C119A0008
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:46:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ax5+7zZM;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758645981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imzMF9eGcF1IvmXHD33jpPta8P3x9Urk2l5tDJ26VmM=;
	b=wopafXozCr3JY4GEsMoCGKWoij2cmWhVWKiZ/uWCHeP1aOHNmAYHLLfl4+6jhnOMvdxAHW
	V75lfWVzdYoJLrY0OQDeBzQneEynTanpCAp4TiHW1SlL1wphkoSDz6GzYMvCsROy+euGSK
	ZS114M2/trRWnIGZ+F86A9RnXBy8mTU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ax5+7zZM;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758645981; a=rsa-sha256;
	cv=none;
	b=LgFZcS9xv1JZJzhn4+LcrotODef5RIZOq7dd7H/uhwXdnQYuw1icTeHUpuuraJrq+/shEQ
	KGi/RPRJ++Nh7HblMR/yQCvSlz/uVGq2rHD4sFnb0ZU2lyuT1QSqgHppz/BtNzGZJc/QD3
	3nph9yMKcKUpI6MWvIUppm5QYY/ZqSw=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-468973c184bso24414515e9.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758645980; x=1759250780; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=imzMF9eGcF1IvmXHD33jpPta8P3x9Urk2l5tDJ26VmM=;
        b=ax5+7zZM/Lg0hJLt+1Qy4xS5Yd1x//KNRror2Zp6cd9yirdEPpml6xQ9/1rUwMvWNn
         trg3frRknJ8tD7sjZqqZOc2UE3jrM1R0zXg52W+6M9n0LALtra0aRKhWQbcdpb+KMMi/
         AlWZdzuLcBPebiUELzC1IjL4z+8Irh8hMwx4ISEFk+3I31kGzJC0HjgBK+Y6srx/kb+6
         21FhcXuDgOvN4vXu4PPOgR5Ym1+wbJJAZtn5FWEyJDO3Ydd1dsSKE5jaHi5Mzpq6AA2g
         /Levhs9xZilk1f3bHla+qizoubpuUccfen8caO+qq27rVkeotzT32T4SbQhEZX2ZXOL0
         hHaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758645980; x=1759250780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=imzMF9eGcF1IvmXHD33jpPta8P3x9Urk2l5tDJ26VmM=;
        b=HEXEu3U6cskhBsezLXhRNTyHs/c4o/4dISy93sk0Zd7ruw48Jgfxh6zTr5kiEm6L8j
         +TPTJKe76CDGBzUSawl2QZZQNRQZPfl7/5ZA9y/BvR2uZx8UTZyTkWVG+49Nd9e4Inji
         ohOd6fX5jvKf7DlTIRX9gYVwA7sGtvA7+1d5Tq+X3EN6RtRObzbc303aeGGH+xT26iKn
         gokRqylH1RCCBB2dyKoZ2Kzt/mSY/Vb16NySZPgnBLbBkVco4f73YN/dBWKBI3UCPINm
         gTx0na6GnpUo7WGXR4Z2FqzeYcqeOGA7SXLvAEPc+3/jzyKf6zhvaQIEZX6WQTlMt6nr
         E89A==
X-Forwarded-Encrypted: i=1; AJvYcCWyHHDmJwcdsipWqYXAZ/pzDAs7y91gOmbth8rLF+2hr5RHzCzghC/8MyjPonC0HolsyaCh0FFrLg==@kvack.org
X-Gm-Message-State: AOJu0YwLnPaQBFVX4XD/PUtNHPXjVmRAIWYaeQAnkyM8lNQwWNeL6uVP
	IvWSZxZV6wh++YS0xSRyNd1vPg8iltrHD7GTZYUd+iHBvl9i5NiNjLgjYJld/CZPOXggzHieDG0
	hxFv/KTPeXH9xvonc3Hn8+kkX88geU2c=
X-Gm-Gg: ASbGncveT/m1IxlJYLNsv6tI78rnaP5fcMGd4e1JX1db/95g8acTXd/fSCr+gtEr7Rl
	0g1qewzU8wVs3giSX2FjuZghpIOwLgtCbquzSS3sbMo3BJoANBThFX9Vh2V7K24BCm+AGwDfBtK
	/wbNwBH0XZDeCygFJUeKGcZEL0AMe6jcbIWzrBp0DbxF5vtP8aNPwBbr/+0aZLMsxcwHbHc0q8K
	OKAcWjbHA==
X-Google-Smtp-Source: AGHT+IFP8pTY+nYi3192pC7v/zVC0ylFZb4IKvnNmuLy2m/5DZrc79HwlN5a4NAdoI7tQpvEg0iRs5lwN2jl7QYp5Qg=
X-Received: by 2002:a05:6000:25c8:b0:3e7:1f63:6e7d with SMTP id
 ffacd0b85a97d-405ccbd6d4cmr3017672f8f.45.1758645979885; Tue, 23 Sep 2025
 09:46:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <20250919145750.3448393-2-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-2-ethan.w.s.graham@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 23 Sep 2025 18:46:08 +0200
X-Gm-Features: AS18NWC3Zatya8SBoZMxgc3ReWws0f2Kk0nbCOoRpJZnpr-tGokn7pV_jWkKaCg
Message-ID: <CA+fCnZegSdAeLkutKP54BH19Kv+FAaFbW1oOvAgbTZZMsyu0sg@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] mm/kasan: implement kasan_poison_range
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, glider@google.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: i9nhzuwpgdfr183yabys7rf96c61hy5j
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C119A0008
X-Rspamd-Server: rspam04
X-HE-Tag: 1758645981-361757
X-HE-Meta: U2FsdGVkX18MYM2yYCLkriNx0Fg6Kb3G5RoR/4ezOjotS7VjSyQyAVVRbQzql9jMplimUCDb82iU5Rg7ZTYSVr4ylQciHGP6xvSV2y3MbBcFtGhh79Nk8k6qGjP9+he5LjKfvxSSH6xaf7G3mq2RNNCQ/DVFCSho/8uq15Nu3kvgs+hbiZA2UlTU5j2OHmdmv9uxiz1NxR0B+Urfsn9psH8o4My3pgoCcvXGkEoB7np4hVLsxU3qmAmPdBa+M6sMOaEJrW+I2xtfBQUd+TK681tQRLC/m4fwkMU/Okxx/X+FV+Bx8xnRI7NOppTiu+bOKdqvDZ+VbICg5MAvze91+U3zRB0oqfyNURbTNmUT1doAllqSwNZhAe5cZqBBuPmZtuhKHalqJZyVOKChc3iAMOGa1YlyBxAAfrBVMbHrFme9gWaA4mjFG6LAANt65Qzdn/YPvhbBnANk1BRO6WFEhmKmDlUcV+h6zAA7UJrwYVOW5A05jEseDtnE/afEsKl5L8aigD8oMX9gcJwtl58aRJYxZdxnIoBS81yLaTD18EA5b9J7XaTCCevWgl5MK7ZN70bo5DdVpRdXfQe/FNKOzRywomVDY87AswHuGPUgv9LuYb8g5KpxHpogBDjlcogmP/HjZL/Ar4uHADaySSw5+5y0BCNqYsCDRSHhodcjSj5tvMJay+cvBkFu+juDgBomdVSX0zgO/z8hwfqtRSmXA9fh/yExYZmBSNgFzCL2mg6ezA9QJUrVPZolUyfnP/UrgrdntYHENPbQPqfxYGJhrzRovMgYSZf8i9afak1mfOnM/ADlkUFJG1vEAAom6qWvWwpfNfdCD7Kk9siuufptxRWEvhMD6jf/tj7sOerivOV1QZ9+oz3Au3uwjB0p6RF4pWzJXQOPQFw+rLaFLxMA+j1lYniMTElWU0GfdljdgGy8gCWHS/pyesi+SzK5b6APzADiqI6WNmrCREiVDEX
 Vd4R8R0w
 o9mRZbR5lNYHkVTdzDSjIomjfqIeYF0e/RF5XlcFnhc/MIwdxF4e0ErrA8jUPF/lwJCubh6bm/C8nry6gbSces4vA6T6HDkZR8UFiLNhi8Nx2z0Ochb0IfSUA52hkNOJqe773oPFKuDjdTmWSy/eC84mrfoWn0u4MwZu6D9iqlcdmb5ORTgl2+5rMoPtu2LBWEQhFM8JK2GIMdjsJ7mrpBYltYPo7QGYo4jkH9KSP/Oc04391mvWc3hWhPKZZv725L2APGtB0/ui9uVWn/6+9xow4Tg+hFUJoOHW8IEuLtdmRzldwm1qyPrEQfGYpzGCQXnvQO5aRnsXBRB5vRKSYGlMQaDEMQsRXsdUQYlhf0LGdf8h6Ds4if21AFXC2D4li9EPywA2/nvFeaOL5xX7bXD1yJJcpu7cHjs/lXazt9SdYY+N+AI8Ly7uOQs3CEJyBjabF0wkNezLBOimHq5pZFCR/OOjq3XrIhebSraQbf1kISol34TcZzNZ/QYZZzh+3zjWEelZEeNut1qfyHoq/uOGMLq9tHS/UokhbPkUDSPJssoPPOGsy1L/Lrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 4:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Introduce a new helper function, kasan_poison_range(), to encapsulate
> the logic for poisoning an arbitrary memory range of a given size, and
> expose it publically in <include/linux/kasan.h>.
>
> This is a preparatory change for the upcoming KFuzzTest patches, which
> requires the ability to poison the inter-region padding in its input
> buffers.
>
> No functional change to any other subsystem is intended by this commit.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
> Reviewed-by: Alexander Potapenko <glider@google.com>
>
> ---
> PR v1:
> - Enforce KASAN_GRANULE_SIZE alignment for the end of the range in
>   kasan_poison_range(), and return -EINVAL when this isn't respected.
> ---
> ---
>  include/linux/kasan.h | 11 +++++++++++
>  mm/kasan/shadow.c     | 34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 45 insertions(+)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 890011071f2b..cd6cdf732378 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -102,6 +102,16 @@ static inline bool kasan_has_integrated_init(void)
>  }
>
>  #ifdef CONFIG_KASAN
> +
> +/**
> + * kasan_poison_range - poison the memory range [@addr, @addr + @size)
> + *
> + * The exact behavior is subject to alignment with KASAN_GRANULE_SIZE, d=
efined
> + * in <mm/kasan/kasan.h>: if @start is unaligned, the initial partial gr=
anule
> + * at the beginning of the range is only poisoned if CONFIG_KASAN_GENERI=
C=3Dy.
> + */
> +int kasan_poison_range(const void *addr, size_t size);
> +
>  void __kasan_unpoison_range(const void *addr, size_t size);
>  static __always_inline void kasan_unpoison_range(const void *addr, size_=
t size)
>  {
> @@ -402,6 +412,7 @@ static __always_inline bool kasan_check_byte(const vo=
id *addr)
>
>  #else /* CONFIG_KASAN */
>
> +static inline int kasan_poison_range(const void *start, size_t size) { r=
eturn 0; }
>  static inline void kasan_unpoison_range(const void *address, size_t size=
) {}
>  static inline void kasan_poison_pages(struct page *page, unsigned int or=
der,
>                                       bool init) {}
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index d2c70cd2afb1..7faed02264f2 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -147,6 +147,40 @@ void kasan_poison(const void *addr, size_t size, u8 =
value, bool init)
>  }
>  EXPORT_SYMBOL_GPL(kasan_poison);
>
> +int kasan_poison_range(const void *addr, size_t size)

This should go into common.c, otherwise this won't be built with the
HW_TAGS mode enabled.

Also, you need a wrapper with a kasan_enabled() check; see how
kasan_unpoison_range() is defined.

> +{
> +       uintptr_t start_addr =3D (uintptr_t)addr;
> +       uintptr_t head_granule_start;
> +       uintptr_t poison_body_start;
> +       uintptr_t poison_body_end;
> +       size_t head_prefix_size;
> +       uintptr_t end_addr;
> +
> +       if ((start_addr + size) % KASAN_GRANULE_SIZE)
> +               return -EINVAL;

Other similar KASAN functions do a WARN_ON(bad alignment). I think
printing a warning is fair for this to force the caller to enforce
proper alignment.

> +
> +       end_addr =3D ALIGN_DOWN(start_addr + size, KASAN_GRANULE_SIZE);

I don't think we need to ALIGN_DOWN(): we already checked that
(start_addr + size) % KASAN_GRANULE_SIZE =3D=3D 0.

> +       if (start_addr >=3D end_addr)
> +               return -EINVAL;

Can also do a WARN_ON().

> +
> +       head_granule_start =3D ALIGN_DOWN(start_addr, KASAN_GRANULE_SIZE)=
;
> +       head_prefix_size =3D start_addr - head_granule_start;
> +
> +       if (IS_ENABLED(CONFIG_KASAN_GENERIC) && head_prefix_size > 0)
> +               kasan_poison_last_granule((void *)head_granule_start,
> +                                         head_prefix_size);

Let's rename kasan_poison_last_granule() to kasan_poison_granule()
then. Here the granule being poisoned is not the last one.


> +
> +       poison_body_start =3D ALIGN(start_addr, KASAN_GRANULE_SIZE);
> +       poison_body_end =3D ALIGN_DOWN(end_addr, KASAN_GRANULE_SIZE);

end_addr is already aligned.


> +
> +       if (poison_body_start < poison_body_end)
> +               kasan_poison((void *)poison_body_start,
> +                            poison_body_end - poison_body_start,
> +                            KASAN_SLAB_REDZONE, false);
> +       return 0;
> +}
> +EXPORT_SYMBOL(kasan_poison_range);
> +
>  #ifdef CONFIG_KASAN_GENERIC
>  void kasan_poison_last_granule(const void *addr, size_t size)
>  {
> --
> 2.51.0.470.ga7dc726c21-goog
>

