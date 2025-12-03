Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97FA2D15DAA
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 15:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222186B0022; Wed,  3 Dec 2025 10:53:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2C76B0023; Wed,  3 Dec 2025 10:53:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8836B0026; Wed,  3 Dec 2025 10:53:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 001746B0022
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 10:53:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA10951CB2
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 15:53:18 +0000 (UTC)
X-FDA: 84178604076.16.03277B9
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id DC2698000C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 15:53:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hcl552r2;
	spf=pass (imf02.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764777197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbCXDQ9SqAkNCyhh2J6cLNmuXbzuNKSafExnU4lsLPE=;
	b=8eJwWhyR6emsL7tgZUrMKBXhoDgRC7YNE74EMkZUJUOetQwWGJZ/t+RtZDv5m1OPsrKYmk
	P+wfWW2Ksgrx84KtmnOsfJA5fQ5r1eplncGAn87RGMsT3pvykiTNvQhVIz8sN445DFkgqS
	m5+Bmw/05FtM3vv/AWdikmbOzqjw7gg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764777197; a=rsa-sha256;
	cv=none;
	b=HmFgJ0fg/Rt3sugnuqkALtmH9rWsYDs/vvJ2N4lcF51ZNM2+cOH2I7tGnIjoYxzlcbdcIq
	epSDOsxxRvp0wg4O0ESyhfMmdvCG1vc9VgKojwiB+EzBu+H16PUyfRw0MbXm3XcO1jVG+p
	RudIZ8fdBmVULqZtYfo8tNHtFcBL628=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hcl552r2;
	spf=pass (imf02.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42b38de7940so3458703f8f.3
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 07:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764777195; x=1765381995; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UbCXDQ9SqAkNCyhh2J6cLNmuXbzuNKSafExnU4lsLPE=;
        b=Hcl552r2t7/25OJaDEtBkrDV4VEEje4l4fOl57E76eOtowe7GMF3nOsJPA59g7LC+B
         8O9T9nmZ0w81sk7jPxie5ImYf9EfnKdfRQIwTlAGqq8Kc3jxypysCnVwVUIc3NSXcASo
         QEa6IN1HMsYAMZ/hfwGDDRcjwkNOS4P+UZEq5mwcdawyPxgfxeJXZFno6I/qw+R0S2b3
         FolN/1J2boGzOvKGqbdBYSNcLZd8AhUHKspgJ8Y82lmdBeQIpbKOiIHoEV3Fwq8pmrH3
         /Dzk+pLWzUercboBaWZ0u1zE5LxzYpQ1/ZY5wA+1Vam3vW2dq5rmKxYlpn8B5ciC1qnr
         sPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764777195; x=1765381995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UbCXDQ9SqAkNCyhh2J6cLNmuXbzuNKSafExnU4lsLPE=;
        b=AaYCt6Hhey7Byf+KF9v41H/wQkZhm2JWNI8PKGsNwMcEK8y08Oy/z4LprzrmYJDaTd
         ueu1ODI1Vu9UTJz0Pn0Eas1ANYou6tdSNjrjkuFrvk+GHW/jXp3csCVpoblFHFN3FIGI
         Mm7OWJ+cV21/5R9VlAjjdYXLl1k+5LB+zfoAUGSRStFGR+Mr2xysyDi0z9djHqEySHJQ
         WOYM7puvSMx2e6yI8BmhAgDd9aXesu9cfSs/Bvw8PpNQJssWPVCQo1ZIyIt1Xieew2ri
         rKoL7IHvxrXPG4SaKQaPydN/pTDxmhv9ln3Q4JOuuAWc8F/bwmrSoUGe/Zskj9VPrV2Y
         Xm/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUD6/iz3my1MoQWGHKJNu000D5wj8VFYmOi0UQSOq1qbOfXVTSuWcIIFSkn40NHbQ/ectyQfl0hQw==@kvack.org
X-Gm-Message-State: AOJu0YwwOlgsI/V39uTPDlLTRVCaZDYGW1RG5HlS73L/0Y5hc3LctRYp
	BvtlFoHiISsuQo5eSwy4pAgQarDSRbjfWtj41T7iYvFbhj6UZsE3Dpj8iOOsf+20iBPS1RvuL9L
	w1zZ48mEqpk4aq4VI8HLNBjK6hhke57Q=
X-Gm-Gg: ASbGncsqfXtfbAu+r+i5Ene+jQ4vaABXceZY4IbLa2/fBZJAp7ksjyQXL0hcUintWt9
	COuGtifcPV0LbgERKyxyTTkBM4wFZmqx3ALr0LXC7P1XsK7HyH8tJ2f8v8D+1rlhVXgAdXFRd3M
	OH6eWezpH/2VnY91ngdjY72Q96bpGn3kVv2G+1Dt8tkZIxd3QMQyRQZobS7LSOXEaiFWYuqbIwu
	Za0/nGm+f7gUvKL3nZ5QMtBAqVOhnmhRHi0XgIBgXJStEHpsZazVzgBcEsZdpzKd4QcoTsP9sR6
	MdOXn6T0dGuZt9JGfgJyG8TTiiYt7YJ3/Q==
X-Google-Smtp-Source: AGHT+IHlgWIguHQqtQJUmTU9clPCoSpB0eZFF4A7hFrVj4ECNhiZ2vK4TnzEqYb6JUFA9cj3Dgx32Onb9P4bwY/6Tdc=
X-Received: by 2002:a05:6000:1449:b0:429:d170:b3d1 with SMTP id
 ffacd0b85a97d-42f7320bea0mr2896527f8f.59.1764777195326; Wed, 03 Dec 2025
 07:53:15 -0800 (PST)
MIME-Version: 1.0
References: <cover.1764685296.git.m.wieczorretman@pm.me> <3907c330d802e5b86bfe003485220de972aaac18.1764685296.git.m.wieczorretman@pm.me>
In-Reply-To: <3907c330d802e5b86bfe003485220de972aaac18.1764685296.git.m.wieczorretman@pm.me>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Wed, 3 Dec 2025 16:53:04 +0100
X-Gm-Features: AWmQ_blEBUtF_kyhGwNBKkD8DFVrkg1o4JirX5I6i5HJ0Jf545_FnpPgl_CXx1E
Message-ID: <CA+fCnZcNoLERGmjyVV=ykD62hPRkPua4AqKE083BBm6OHmGtPw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kasan: Refactor pcpu kasan vmalloc unpoison
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Marco Elver <elver@google.com>, stable@vger.kernel.org, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DC2698000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 4e8cpnq3yquh5bhcp8qamzczdq85q4db
X-HE-Tag: 1764777196-72138
X-HE-Meta: U2FsdGVkX18met1/4yMB/wASFJMb75MGYae0kptEhUmZa8uo4SyZf/HOY9ZSE7WPPDRUy/zGwriWVG2lu4BvQg5FVm4dlY9USCq2wl8RHsqLVcXzaTkh2xv6QXWDIgEn8sPwqC0FcwBx39zdeIlc/WdQtKVDMjMmfYAEWoKfpiYZNPgEH/6sfhTFpP+a7F0uoLMvi5E2K7P3VJbC3bQUHfzJNUh8y7mu5I9Xlo+TZM51JeH7h4A+KYio0MKdg0pQJuJF+fSZe+ncCG/AE8Oe+FRTRYkV1pYxgHYi80lqq+OoHSlVICuFtEnbfo2V2vai1cYpgs3LY8INNrEJFPuhu773JilvnQwbeu2/2IrMLGB6r6FSYHZWV29wCrWzEU+YP/tOmVKb/2XFRiaNbPPfxKdAAkAf44w/V2F6pUzD5w6tbnhnE3fakxz+kRvxxS8gHQlZnOEpALPaMWBezd+uVszql0TzrFccS0NGZxtyN7k81dH9LLotbjtD9RRL9M4Scg5T7rw1j+x97f2sP43rM7doz61L/6ywy6OMqM6Kq+WudaG4lpJpqTjylAyW7Hns3isGltc6Aj6UpCj7+GXFVOFhgF/yBGtNqZZdSqORkicqry1JG0uiggG3SGfM91rl+wgo24EA8BoRDc+EZz1V0sSjp1QXJp6/r9DAaXG2JoyOdVKgxMgeFvC1HWxpywVxHRqPp9VXItqQLkTltj1WNpm0ocIysDMKj2r3J8NpjrJPW5YD0U7P51iy6KjwKnMwGnPHShMQfs4d6MTc0/BfSwdvU3+LKQeqb9JZbpY/d3EedmKmt4ONrawo6Cu0hdo/+vLMpklNCMhNgHmL6Ev3jvhUgPqN8k1vV8/kdWDH2LhFxtS09BLuCgBSplWQlzZv2C+6M+MJLcTZaK8N7bIcZnqcVnsSBqFTb9TauI9Z2lGqbrMO+oUegJYfgNwO5c+qtTpMqJDOBPhqaDjD3Tx
 mcLKj9Co
 x1Ag31LIac9nRhJ75cF0C4cGYauiZydTmoJLnGn2jBLr2GkjBsISXsFtgfcIkpQIrce6RjQdQi7cmISGv7DUheml3iw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 2, 2025 at 3:29=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> A KASAN tag mismatch, possibly causing a kernel panic, can be observed
> on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
> It was reported on arm64 and reproduced on x86. It can be explained in
> the following points:
>
>         1. There can be more than one virtual memory chunk.
>         2. Chunk's base address has a tag.
>         3. The base address points at the first chunk and thus inherits
>            the tag of the first chunk.
>         4. The subsequent chunks will be accessed with the tag from the
>            first chunk.
>         5. Thus, the subsequent chunks need to have their tag set to
>            match that of the first chunk.
>
> Refactor code by reusing __kasan_unpoison_vmalloc in a new helper in
> preparation for the actual fix.
>
> Changelog v1 (after splitting of from the KASAN series):
> - Rewrite first paragraph of the patch message to point at the user
>   impact of the issue.
> - Move helper to common.c so it can be compiled in all KASAN modes.
>
> Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
> Cc: <stable@vger.kernel.org> # 6.1+
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v2:
> - Redo the whole patch so it's an actual refactor.
>
>  include/linux/kasan.h | 16 +++++++++++++---
>  mm/kasan/common.c     | 17 +++++++++++++++++
>  mm/kasan/hw_tags.c    | 15 +++++++++++++--
>  mm/kasan/shadow.c     | 16 ++++++++++++++--
>  mm/vmalloc.c          |  4 +---
>  5 files changed, 58 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index d12e1a5f5a9a..4a3d3dba9764 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -595,14 +595,14 @@ static inline void kasan_release_vmalloc(unsigned l=
ong start,
>
>  #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
>
> -void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
> -                              kasan_vmalloc_flags_t flags);
> +void *__kasan_random_unpoison_vmalloc(const void *start, unsigned long s=
ize,
> +                                     kasan_vmalloc_flags_t flags);
>  static __always_inline void *kasan_unpoison_vmalloc(const void *start,
>                                                 unsigned long size,
>                                                 kasan_vmalloc_flags_t fla=
gs)
>  {
>         if (kasan_enabled())
> -               return __kasan_unpoison_vmalloc(start, size, flags);
> +               return __kasan_random_unpoison_vmalloc(start, size, flags=
);
>         return (void *)start;
>  }
>
> @@ -614,6 +614,11 @@ static __always_inline void kasan_poison_vmalloc(con=
st void *start,
>                 __kasan_poison_vmalloc(start, size);
>  }
>
> +void *__kasan_unpoison_vmap_areas(void *addr, unsigned long size,
> +                                 kasan_vmalloc_flags_t flags, u8 tag);
> +void kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
> +                              kasan_vmalloc_flags_t flags);
> +
>  #else /* CONFIG_KASAN_VMALLOC */
>
>  static inline void kasan_populate_early_vm_area_shadow(void *start,
> @@ -638,6 +643,11 @@ static inline void *kasan_unpoison_vmalloc(const voi=
d *start,
>  static inline void kasan_poison_vmalloc(const void *start, unsigned long=
 size)
>  { }
>
> +static __always_inline void
> +kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
> +                         kasan_vmalloc_flags_t flags)
> +{ }
> +
>  #endif /* CONFIG_KASAN_VMALLOC */
>
>  #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && =
\
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index d4c14359feaf..7884ea7d13f9 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -28,6 +28,7 @@
>  #include <linux/string.h>
>  #include <linux/types.h>
>  #include <linux/bug.h>
> +#include <linux/vmalloc.h>
>
>  #include "kasan.h"
>  #include "../slab.h"
> @@ -582,3 +583,19 @@ bool __kasan_check_byte(const void *address, unsigne=
d long ip)
>         }
>         return true;
>  }
> +
> +#ifdef CONFIG_KASAN_VMALLOC
> +void kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
> +                              kasan_vmalloc_flags_t flags)

kasan_unpoison_vmap_areas() needs to be defined in
inclunde/linux/kasan.h and call __kasan_unpoison_vmap_areas() when
kasan_enabled() =3D=3D true, similar to the other wrappers.

And check my comment for patch #2: with that, you should not need to
add so many new __helpers: just __kasan_unpoison_vmalloc and
__kasan_unpoison_vmap_areas should suffice.


> +{
> +       unsigned long size;
> +       void *addr;
> +       int area;
> +
> +       for (area =3D 0 ; area < nr_vms ; area++) {
> +               size =3D vms[area]->size;
> +               addr =3D vms[area]->addr;
> +               vms[area]->addr =3D __kasan_unpoison_vmap_areas(addr, siz=
e, flags);
> +       }
> +}
> +#endif
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 1c373cc4b3fa..4b7936a2bd6f 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -316,8 +316,8 @@ static void init_vmalloc_pages(const void *start, uns=
igned long size)
>         }
>  }
>
> -void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
> -                               kasan_vmalloc_flags_t flags)
> +static void *__kasan_unpoison_vmalloc(const void *start, unsigned long s=
ize,
> +                                     kasan_vmalloc_flags_t flags)
>  {
>         u8 tag;
>         unsigned long redzone_start, redzone_size;
> @@ -387,6 +387,12 @@ void *__kasan_unpoison_vmalloc(const void *start, un=
signed long size,
>         return (void *)start;
>  }
>
> +void *__kasan_random_unpoison_vmalloc(const void *start, unsigned long s=
ize,
> +                                     kasan_vmalloc_flags_t flags)
> +{
> +       return __kasan_unpoison_vmalloc(start, size, flags);
> +}
> +
>  void __kasan_poison_vmalloc(const void *start, unsigned long size)
>  {
>         /*
> @@ -396,6 +402,11 @@ void __kasan_poison_vmalloc(const void *start, unsig=
ned long size)
>          */
>  }
>
> +void *__kasan_unpoison_vmap_areas(void *addr, unsigned long size,
> +                                 kasan_vmalloc_flags_t flags, u8 tag)
> +{
> +       return __kasan_unpoison_vmalloc(addr, size, flags);
> +}
>  #endif
>
>  void kasan_enable_hw_tags(void)
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index 5d2a876035d6..0a8d8bf6e9cf 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -624,8 +624,8 @@ void kasan_release_vmalloc(unsigned long start, unsig=
ned long end,
>         }
>  }
>
> -void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
> -                              kasan_vmalloc_flags_t flags)
> +static void *__kasan_unpoison_vmalloc(const void *start, unsigned long s=
ize,
> +                                     kasan_vmalloc_flags_t flags)
>  {
>         /*
>          * Software KASAN modes unpoison both VM_ALLOC and non-VM_ALLOC
> @@ -653,6 +653,18 @@ void *__kasan_unpoison_vmalloc(const void *start, un=
signed long size,
>         return (void *)start;
>  }
>
> +void *__kasan_random_unpoison_vmalloc(const void *start, unsigned long s=
ize,
> +                                     kasan_vmalloc_flags_t flags)
> +{
> +       return __kasan_unpoison_vmalloc(start, size, flags);
> +}
> +
> +void *__kasan_unpoison_vmap_areas(void *addr, unsigned long size,
> +                                 kasan_vmalloc_flags_t flags, u8 tag)
> +{
> +       return __kasan_unpoison_vmalloc(addr, size, flags);
> +}
> +
>  /*
>   * Poison the shadow for a vmalloc region. Called as part of the
>   * freeing process at the time the region is freed.
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 798b2ed21e46..32ecdb8cd4b8 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4870,9 +4870,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned=
 long *offsets,
>          * With hardware tag-based KASAN, marking is skipped for
>          * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
>          */
> -       for (area =3D 0; area < nr_vms; area++)
> -               vms[area]->addr =3D kasan_unpoison_vmalloc(vms[area]->add=
r,
> -                               vms[area]->size, KASAN_VMALLOC_PROT_NORMA=
L);
> +       kasan_unpoison_vmap_areas(vms, nr_vms, KASAN_VMALLOC_PROT_NORMAL)=
;
>
>         kfree(vas);
>         return vms;
> --
> 2.52.0
>
>

