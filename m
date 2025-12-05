Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE75D2CE01
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 01:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54D316B009F; Thu,  4 Dec 2025 20:09:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FEAB6B00B8; Thu,  4 Dec 2025 20:09:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4134A6B00DE; Thu,  4 Dec 2025 20:09:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB736B009F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:09:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9F4D133216
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 01:09:12 +0000 (UTC)
X-FDA: 84183633744.05.720B078
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id DF45C40003
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 01:09:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JvqjEn73;
	spf=pass (imf01.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764896951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESNpKydnctKAjT+ZBVg0a3DE2zeWzMFqr1QgEt4u5co=;
	b=DpFDCJQ8/HoPR42iyusNa8q36fsIM4EYz8JI8tgvhpO0xlYEMh/odqGRG9wdbkUICSASja
	E/8K50gRCOn9XNy06pKhBgpRkR+TBAmjWR2MqtKtw274EibBUgFVM/rJ7o3Z5TGqJAtAjm
	kROV7UA/oqz1AuRHIIdFR9qvbc5aWfQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764896951; a=rsa-sha256;
	cv=none;
	b=DK/tr+N5KR151D7nooDtLkPHb4zjxN24NgamnS1AWIwHKiLt3PaIesAVctusw5h9cYAnht
	FGnaZMaJDhnN8Tfw/IMBbtQJKz/vBJjdkbHF5x76zi+wx7wK6OoMINRwI1hsl4D+pGH1B2
	c11avJphIJuFeMIvUe8pOoGdu3ne7HA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JvqjEn73;
	spf=pass (imf01.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4779aa4f928so15737825e9.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 17:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764896949; x=1765501749; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ESNpKydnctKAjT+ZBVg0a3DE2zeWzMFqr1QgEt4u5co=;
        b=JvqjEn73+YWXdlYHgObmslBjIygmeaQlXrwKR/22+AFIFbaxBGzSZnc7M+TAwVrXxx
         u4wshbU4ohsXTDOq+k0h+fdksgrJxtFqES0WY1AyLk/IsP3uwk3QPMvU19ay1rDJVayf
         JtJ8ObGci7GzYTrTZPnnXN9Sj+qs3P1wBckzet9boY5q7yCz9HJeXYyFpvphmGnKFkCJ
         tGA3aQi7WHGYRkr4GGisHJZHv7gghc8imdF3VXiWf+FYK/Y2lDqgVFI9uJWHds2MExiR
         EL3A/dupuXkuXNkOdBWUwxdtHZgDyrLZmXQW0HgnlYLKcn+Eb8zqQR42vI3L97w4Ad6d
         OpyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764896949; x=1765501749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ESNpKydnctKAjT+ZBVg0a3DE2zeWzMFqr1QgEt4u5co=;
        b=fjMbFKQQMMOj8qzvK+TEgSAjfjJ1epNGM0rqr+UgFxV5MwgvVAWmxoYivTbyh1EqnO
         NHUb/1JgUYciQSBNXTyVs8GhiE8mO6giJ1lHbjegLiiZgRQvr3D/NbGuXuEl96O1rocG
         HnxlDPPXeC2IyXbiJYmTLaUAEuVIapEqhcuRGVFSZd5+WVccc8HaWYJes3BTnYa9K9UF
         pNsjU2xIcx9y478dUGhprzF5/ZkaCXyoX28k0i23BGyk+UenvAgvaoKDHKLCtDknMt2w
         kEqzIiNPQDmr4KqEtwh/CzdOTzuJ4cxgMdOae5VF0WF7FfQ7E7m4Bjo8gsSfFnOjBjqJ
         NZ9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUuGuuNb2yjJgrxh+TVUTbEJpsIoWKwIbfCvwNZHJVNge9xn0M777glELE70JZbBRFGeTEuU30UyA==@kvack.org
X-Gm-Message-State: AOJu0YwmqUjfo0+iLEZyvIzg3edNv1oRJeyTnZrlen7m0zLyyibAqCrA
	pzOILvSTALYuzShFyQyD60OFPGh/9ESvMnrwqkpRvaR3/oi6DoRWh4R84eCIOmRR/BlU+D4FjZ+
	KCicUKDRfStDYlPVMs763ZOatcoVZ1J8=
X-Gm-Gg: ASbGncs42oHTGb2LlSA+Jn2dmxiUJOhwUxowvbZeYieaYeqKGs2sPfuK43RMcpAZcz9
	YWaDv7D9Zyg+NV1cBhxcRnUeTbGyhPwi1QKhWQn+jlIfLy2J2Al0SqpBToHel236nYVeHlaB8mf
	OaEHS+32DfAzMyBmoXZlbn9BzDITtaSUMG7GrOldUJr7u7hJq7UFU+olraa7MZIZJQ4KarysZBC
	gt3GU+Rasqyf7k2Kdc22w0H4BGtimWMvMZV/Jn7Rpr+A8txjoEHFqX93+m2Xi8+hLkYcWgQv3th
	Eib/DFpHe87D7hRPJ2FnvgOEgSXdiJv3
X-Google-Smtp-Source: AGHT+IHuCdH//3zlGLVdXGt0vj0NK20frSWSi/Ir9mCKPbJuGtJWzIdesvTg2a1k9mrd+Fm1Zx/kAf3Ue4yxRd1xWxE=
X-Received: by 2002:a05:6000:250d:b0:42b:530c:d8b5 with SMTP id
 ffacd0b85a97d-42f79867232mr5216864f8f.58.1764896948983; Thu, 04 Dec 2025
 17:09:08 -0800 (PST)
MIME-Version: 1.0
References: <cover.1764874575.git.m.wieczorretman@pm.me> <38dece0a4074c43e48150d1e242f8242c73bf1a5.1764874575.git.m.wieczorretman@pm.me>
In-Reply-To: <38dece0a4074c43e48150d1e242f8242c73bf1a5.1764874575.git.m.wieczorretman@pm.me>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 5 Dec 2025 02:08:57 +0100
X-Gm-Features: AQt7F2rJmIzAQLLWNUCtlHH3vMgTJvmbF98DSGlcKvxxcaL8y5jTuVOv6OgUATo
Message-ID: <CA+fCnZdsdLYqRe3DQPv-ATAsXwKPMExfEyODt134het_9B01Zg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm/kasan: Fix incorrect unpoisoning in vrealloc
 for KASAN
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Danilo Krummrich <dakr@kernel.org>, Kees Cook <kees@kernel.org>, jiayuan.chen@linux.dev, 
	syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DF45C40003
X-Stat-Signature: uq8ubhjkea1ifcgi149grior3zugzqz1
X-HE-Tag: 1764896950-68849
X-HE-Meta: U2FsdGVkX1/CPxcv1v8PB/eb2wDaVoC+E1Qq0tbHqdEJMrtihfuxgYpXuH7bB9qa1mANkshcYME+F0/dKZhh92OXxFaW3N7e/EqPU/bGyL3h83DHUGPeUS9F6Fx+t1QViSRzvjhnd1BG+EGh2bBCU4eWf7gc+oH7cuEyVu5Kv7QbDI7qRUJK+YFgEIflnO3/KdygKJXZC0B4V/ZcuQAzZ1j/WSOg6DRQiQDZU1CtwKGx1/Gbvrketx+AnpNqRJlpQrDsfV/4/TBn7jlOQPuxQTgwsG4nxC2pdE71wvbqPDYus3mjXeDGRRUAMkgRqsVDXZxuZk/3xLAmJQU2I2V0Dnt/wa4w7LHkuyM0+bIPjanNBkaxqHzGFHywZtRk+Vi3dCF97zxG3hT3NTzmS0VG5zF8/kGuLoeAvI+xGNYqauPIgm0pc5Hw10jU16vTZg98Ld9XjfqwzYSfGYFyxjRRH/fzzxbASdN57vGFGs92QNVpCEXiBuURVOXVN0KiAYTPJCBiXmJUmjYOFwD+Cm4hdevKWkq08d07SgOkA9n5hFle1A5Z5+iDseu3QQPU+NLDAQB6o6YEt03K+SWK7rIcuiCkqnGIfccM9pFbOcDBfr+ptFRDykdZIo2YizePnJkUDKaBlBTad0W5m/YD7phIBVoEJhtTdZc1LbAntIZ6PB8+KG2oqWb+ADadXhSyu6itBs86SHXu3L6OmYJr4X3ipe9zcd6tdGI0cH6U7RSv0PbpB6o0UsCRqmIVPiduev7qaR/9N/UCcc/PqUrRa9rDvMYVJZEsfbnko54k4yhmDASanxHBd6TaoO7h/ecjllnEQz0NupWpuUSFzXaUxFkOlmRLW6lkqwZZwyGFfV89H+BZpo3IBA8jr8BwoIDZCdo/sq8QfQXCji+PgzLG9/MNzyNNwrMl5UOLhMReSqoZrKhAtQLQk/5Y4/7rdjfDY+CSyiNH0oRFFssh5mRkmf1
 wBimpGMa
 j2TZ+A9Kt8Y4TSDrXfnOkr/I9rJITd/n7Hl17c3D+Ze2F46XQOiFFyxDFyfGfaBTEfNC4/2Ap0A/ufRv9zgQtKgu/GJyb4uuUgUvYbgX9DopECPpLyszBKrs+w7MjoVQK/y3Bo3quRuaTjS3WUiYkVVpPoHdOSCZbdb60nf4KyEyNNPBAubEajfFOWZcWnmxKEQWzh8E4bo9VQJFTBbJG0RIqAZkjJAo5Ps8ZMtsRisadFRD+AiLgBRIIe1O0EvrQlsPR5ytmrWaxx5nHqpdrEk9Os/XlP5ucX0Q4LF4dC0ts4oJc/+J2fMp0AvL0Z0V0NHL3+Vgu3jkFXksJEFZ98IOcaFoGpMRIWJr3JOVZtwB6K6EfhrCvDCvNo0DO70zA6oHsnmiZjdDu4pMPkBq/4LzjkEJysVcPVRH7YIFjOzqic/6LruqFkIZbExl/9MyDbl5zPdE1rOUbhpXHI1MMK+AGxoAw/GKcEe5/DxEURo526AVPBHxS3WF/efJf3FEUq55iyafJZtLkg1FmYC34r+JidOg5SI2n2UROmy2tvjhb44xDgMRYZODesQXr2bNCWduaBztU9/LNYxWW3lALm5nwuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 8:00=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Jiayuan Chen <jiayuan.chen@linux.dev>
>
> Syzkaller reported a memory out-of-bounds bug [1]. This patch fixes two
> issues:
>
> 1. In vrealloc the KASAN_VMALLOC_VM_ALLOC flag is missing when
>    unpoisoning the extended region. This flag is required to correctly
>    associate the allocation with KASAN's vmalloc tracking.
>
>    Note: In contrast, vzalloc (via __vmalloc_node_range_noprof) explicitl=
y
>    sets KASAN_VMALLOC_VM_ALLOC and calls kasan_unpoison_vmalloc() with it=
.
>    vrealloc must behave consistently =E2=80=94 especially when reusing ex=
isting
>    vmalloc regions =E2=80=94 to ensure KASAN can track allocations correc=
tly.
>
> 2. When vrealloc reuses an existing vmalloc region (without allocating
>    new pages) KASAN generates a new tag, which breaks tag-based memory
>    access tracking.
>
> Introduce KASAN_VMALLOC_KEEP_TAG, a new KASAN flag that allows reusing
> the tag already attached to the pointer, ensuring consistent tag
> behavior during reallocation.
>
> Pass KASAN_VMALLOC_KEEP_TAG and KASAN_VMALLOC_VM_ALLOC to the
> kasan_unpoison_vmalloc inside vrealloc_node_align_noprof().
>
> [1]: https://syzkaller.appspot.com/bug?extid=3D997752115a851cb0cf36
>
> Fixes: a0309faf1cb0 ("mm: vmalloc: support more granular vrealloc() sizin=
g")
> Reported-by: syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68e243a2.050a0220.1696c6.007d.GAE@goo=
gle.com/T/
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> Co-developed-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
>  include/linux/kasan.h | 1 +
>  mm/kasan/hw_tags.c    | 2 +-
>  mm/kasan/shadow.c     | 4 +++-
>  mm/vmalloc.c          | 4 +++-
>  4 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index d12e1a5f5a9a..6d7972bb390c 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -28,6 +28,7 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
>  #define KASAN_VMALLOC_INIT             ((__force kasan_vmalloc_flags_t)0=
x01u)
>  #define KASAN_VMALLOC_VM_ALLOC         ((__force kasan_vmalloc_flags_t)0=
x02u)
>  #define KASAN_VMALLOC_PROT_NORMAL      ((__force kasan_vmalloc_flags_t)0=
x04u)
> +#define KASAN_VMALLOC_KEEP_TAG         ((__force kasan_vmalloc_flags_t)0=
x08u)
>
>  #define KASAN_VMALLOC_PAGE_RANGE 0x1 /* Apply exsiting page range */
>  #define KASAN_VMALLOC_TLB_FLUSH  0x2 /* TLB flush */
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 1c373cc4b3fa..cbef5e450954 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -361,7 +361,7 @@ void *__kasan_unpoison_vmalloc(const void *start, uns=
igned long size,
>                 return (void *)start;
>         }
>
> -       tag =3D kasan_random_tag();
> +       tag =3D (flags & KASAN_VMALLOC_KEEP_TAG) ? get_tag(start) : kasan=
_random_tag();
>         start =3D set_tag(start, tag);
>
>         /* Unpoison and initialize memory up to size. */
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index 5d2a876035d6..5e47ae7fdd59 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -648,7 +648,9 @@ void *__kasan_unpoison_vmalloc(const void *start, uns=
igned long size,
>             !(flags & KASAN_VMALLOC_PROT_NORMAL))
>                 return (void *)start;
>
> -       start =3D set_tag(start, kasan_random_tag());
> +       if (unlikely(!(flags & KASAN_VMALLOC_KEEP_TAG)))
> +               start =3D set_tag(start, kasan_random_tag());
> +
>         kasan_unpoison(start, size, false);
>         return (void *)start;
>  }
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 798b2ed21e46..22a73a087135 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4176,7 +4176,9 @@ void *vrealloc_node_align_noprof(const void *p, siz=
e_t size, unsigned long align
>          */
>         if (size <=3D alloced_size) {
>                 kasan_unpoison_vmalloc(p + old_size, size - old_size,
> -                                      KASAN_VMALLOC_PROT_NORMAL);
> +                                      KASAN_VMALLOC_PROT_NORMAL |
> +                                      KASAN_VMALLOC_VM_ALLOC |
> +                                      KASAN_VMALLOC_KEEP_TAG);
>                 /*
>                  * No need to zero memory here, as unused memory will hav=
e
>                  * already been zeroed at initial allocation time or duri=
ng
> --
> 2.52.0
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

