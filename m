Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F37B6D15D88
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 15:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45CB6B0012; Wed,  3 Dec 2025 10:53:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1D486B0022; Wed,  3 Dec 2025 10:53:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59BB6B0023; Wed,  3 Dec 2025 10:53:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B42676B0012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 10:53:18 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1D3A89F18
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 15:53:16 +0000 (UTC)
X-FDA: 84178603992.20.5B28D28
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id B8CBB120012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 15:53:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kbd11SnX;
	spf=pass (imf29.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764777194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2crlSn5K87P6BhIOUFvHVg2OvJtF8ySKOKkXTHnicII=;
	b=qs9yRqd2q0+6VEbTgnr8pj/51jeU2up03DZ4uE0kifZ5PExuMlNyis/29WrOnMQ8M2zvje
	qe6bn3vLi5tjmU22m0MmEEMNpcANc95/YsaJNGbWYudFVm/iil9ukYQrL/H5fL/JsE4eQk
	xWxa5KOT0BCOniBUFbwfhz4N8J3H12Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Kbd11SnX;
	spf=pass (imf29.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764777194; a=rsa-sha256;
	cv=none;
	b=I39t+INvndL3QPKSDfhy+SEmI0jh3HnIFpS534Dc3ZDZbpuMGUIeX9EJUul/0JogNud4DG
	AWzrVRGrao0AlVNXBjfDwDCbPfBLSaO/t78VDaZ7YKnfaXLUIOAGK4Fp7LnAXye3UuD8Oe
	6Bz5oDgitIcWIc+TGlz4J4lZZfQXz0s=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42e2e445dbbso1906863f8f.2
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 07:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764777193; x=1765381993; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2crlSn5K87P6BhIOUFvHVg2OvJtF8ySKOKkXTHnicII=;
        b=Kbd11SnXGM1k4Hyc8f8kvnPxVd2dgbetDayxU7IJryeY5D1qTvqawe0KLWDGtbWMNs
         oqoxKhDW045gOICQ2AkiMCNq82nwmltTGhc1xJbkxgErNinO1bGuNKOCgcF/OVGgFCnI
         6AFrv/BZq/dP1iwjhzceFs79sOF8HBDqPuenM/5ojp2Oi/WenGu0b1tdhrScDiBAHVX/
         lAgkgL4Zq5x5xK0P+skFG87eroZ4RZ1TUI2JttHOGAg61uanNRm6nevLhvJloaL7lx8V
         jMiET7e7na5iKsMIRfMWQ+t8XNGcjZT4iDKIcyWwHOEYn5/eOuDe28P2JdOtgX17hpy3
         0iyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764777193; x=1765381993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2crlSn5K87P6BhIOUFvHVg2OvJtF8ySKOKkXTHnicII=;
        b=sgGgxdBeAmq9mDiu1BrMYsc0ZWP/d0GrrOt4qOaeZdmesGmNf0GbkG+byO76ku+aZJ
         ZWBDQndJLX6tuYztAb7aAiw4gR6H4SmP/q9W2PwD2yGF0Q8tm9stFj83+a2ULR7bWGtk
         Nrr/wCksfJu2eJXrfNBNumG8+f5WVlAlg4rl7Ot6cZIFD1SzdrjEKo8vvT2K90yb6o4h
         T74KPgcsgUpotfZkiUzi9w8n5l/uwNlM1ciPp4FWGrCFieqo/q3WudD2t0YMiKKWlzwP
         S1fxlVOFr35uuoy4djjOa6OoZ0lrxuTAQDcfKAL6MHvVL45AQPp14RFCA0tEfspM1xnI
         45+w==
X-Forwarded-Encrypted: i=1; AJvYcCUDm1KaEBx6hlP6V2HXFL3ZmKykRaHGz9SsrC+rci3iYeUjC/uVDZZl7yxomwNkkfXmMDDRzW9qtg==@kvack.org
X-Gm-Message-State: AOJu0YwG7PyeCvn7Bg3qu6kKqWJMcnEWwgKRHWs4Fl3IunDqO3B6ISN8
	l6EbAzpXTulP9XwhagdhgCS6t6BDSKUl/pMcyZJHBzGhqBhZevE3WfmNebsyWUp6tE8fn5LrSxS
	+fPZzZJ0i3/WnkkFi0UiEUmsznjc5goM=
X-Gm-Gg: ASbGnctSPZMaEu2k0Iga4EFeri2A8j3lOoJuf6aKxhT1EGCSgVoXBsHOw91QzORQ54G
	gb2gc4uKfMw5UPQPXiRj+vuUxq3JPDrXI5DPYOSs3fxq6W+2In6iccVbvUd2qKKdqlNqzEnRERb
	7e0AIttN1ASigogxZbVCwfE29fi6v5i/aZr9fXf/Qd/tc1gw0x9D7t/OJWjXQfO9W9t0NOrAOzh
	ZkcNAYoAiUOT97YdExQUrYFWLqJrI4tkAWYjbgRqpxjkj9vUv3w1PWIN8CkeUb1KCXgur3zuz41
	sac4TTeNy5+LHvv48oIL05KJ+AYS5CTs/OP3gi3hW3xZ
X-Google-Smtp-Source: AGHT+IGVEthIPVzhhHPc503742QRTcWX7tDuLoDjRhTCI8e1jm4EB23dZFS0OfI6wAy+XLFNoXZh5Qvo5IbYTQBjLA8=
X-Received: by 2002:a05:6000:2407:b0:429:66bf:1475 with SMTP id
 ffacd0b85a97d-42f73171fe9mr2836344f8f.3.1764777192950; Wed, 03 Dec 2025
 07:53:12 -0800 (PST)
MIME-Version: 1.0
References: <cover.1764685296.git.m.wieczorretman@pm.me> <325c5fa1043408f1afe94abab202cde9878240c5.1764685296.git.m.wieczorretman@pm.me>
In-Reply-To: <325c5fa1043408f1afe94abab202cde9878240c5.1764685296.git.m.wieczorretman@pm.me>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Wed, 3 Dec 2025 16:53:01 +0100
X-Gm-Features: AWmQ_blDuVtndNbheCozTAbytnRMB29Z6p9yQJJRwDXdD-0EGYk1gIR7FCpOkvo
Message-ID: <CA+fCnZdzBdC4hdjOLa5U_9g=MhhBfNW24n+gHpYNqW8taY_Vzg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] kasan: Unpoison vms[area] addresses with a common tag
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, jiayuan.chen@linux.dev
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>, stable@vger.kernel.org, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B8CBB120012
X-Stat-Signature: 5eiooitodq7g76x8ak7ei7n38weidshm
X-Rspam-User: 
X-HE-Tag: 1764777194-545206
X-HE-Meta: U2FsdGVkX191mJzMtXBfZQg00S8FQnMOtuwjg9Zzl65/K70LfWhXE4aDyjpkvIFuHZtZHEXpX0HYc2hzOwqvyTbwjsJaW4zEk736z3ClaWN9svB+Dfh/CvKaFlnKRG6UMg0dA3rZNsncq4B24E3yjR/0ahH7j9fysHY7f70aUlNzPdJ3ECltHny40WBwOdw8wIBUh9Ix/qKdQWoTPjIbrklU/fXdiMXFzJl9lpslk4nxtDwQxR9j8KNAjQrQfEdwfHpOUNtXIG6b1cOq8csucQCrTSwfrJGhN4KdDG9YnD3pGTyVVS2R1BdKc4Rx6n+V+RVgWkCQtNVEMTxVKtN/cjf1nqpZ0cQDFRj0mDoL5zPSP6Znl/aVsqwg2y1fQ8KvQDawJUrvvWWMs3BeDUfNPlTI96C+rRXd8g5EXb3WcKqai9NOR3kLHbH6vbqASdDgLYqRlFi11nAjdbOK3NP2QFP05nRwGixNFI65rYLXjAeS0bU/FSH3hw3s9aWqEzB0rUHrtiuDk3tBJZAYoAFQe+JONIT55n4NyvQNdvii4mBxszpmSZzBweI5u4uIRYIettul+vXpc10wTdmymQNTg10JhZ5OziY2iKhUgT/Qooj4yFRCI3VF7JfSLRKQFj/SWf0YOuO0BIeZRcONYeKjZV7bpZfjJ/kE4HjashLN+PhX2ZEVirskho21g21UZoqclkpQRFg0kVheByrUqKrmGJs8GmidnIv/+mx0wqxwzlCC4dtNVJFjvlSo3cKEtVau52NS4fEli5WKzqCbqsTzlXy6KauQ14M4LYctlJSOSjEe0f7Gx7X7db9dbv8tO9NpuEqnz2qrFJr9y3jUjf4SmhuScYG8ku3vvVrR7hyjMql+vWihro8HVo+RGrwR0sRgjGnkAe59WAutZopcHi1Q1xL2SbLUpfnzXQ2NDy41kZcsohgIst/dYmV3TNYx69l5nVnCV7668fhNhc345se
 FZURPA+q
 DyWNVmsh/+TFmGdbF60LS3La+xTfx0I265w615WM4F4wHm9LA8maa03hAHJUP+1Z6xRn9yjHNwZPGhttM/iBmu6Va4bP3yQ17oNj2oK5u1QxeS4+VF2+DZ1u5fvKLXi1lyme7lruZPezfPfBq5QkeodggE0Fp18jc0JmzmpFoxgtSCfY2iR8hdsRM0o3dOT6h01XLkI16XC3Bs03Nfk/5wIKd8uFyZxMpLMF1ZyQaVh4XmRoYEvq4LE/FUhH0JKpFNuc2oCd7i7QvOtT3sZpsRJb6B7O+xevq6zf6f1ean5DrQZSLQlKojjG0IruCoB38caWEvc7SXzX85gC5BOCpwBIR3jfEN6y7wQUhZRbJYrbv02TZbwUmMvg6ZZHJ8YzFJwscpTozWsqHR7khvU92C1/cnlQw8xDWDPdocCJ8u5D1hnO4dhIITdkCV/ngTHjAijiIaniB/SuTwTk8FqtHa3WqfDqEX71YvDpe
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
> Use the modified __kasan_unpoison_vmalloc() to pass the tag of the first
> vm_struct's address when vm_structs are unpoisoned in
> pcpu_get_vm_areas(). Assigning a common tag resolves the pcpu chunk
> address mismatch.
>
> Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
> Cc: <stable@vger.kernel.org> # 6.1+
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v2:
> - Revise the whole patch to match the fixed refactorization from the
>   first patch.
>
> Changelog v1:
> - Rewrite the patch message to point at the user impact of the issue.
> - Move helper to common.c so it can be compiled in all KASAN modes.
>
>  mm/kasan/common.c  |  3 ++-
>  mm/kasan/hw_tags.c | 12 ++++++++----
>  mm/kasan/shadow.c  | 15 +++++++++++----
>  3 files changed, 21 insertions(+), 9 deletions(-)
>
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 7884ea7d13f9..e5a867a5670b 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -591,11 +591,12 @@ void kasan_unpoison_vmap_areas(struct vm_struct **v=
ms, int nr_vms,
>         unsigned long size;
>         void *addr;
>         int area;
> +       u8 tag =3D get_tag(vms[0]->addr);
>
>         for (area =3D 0 ; area < nr_vms ; area++) {
>                 size =3D vms[area]->size;
>                 addr =3D vms[area]->addr;
> -               vms[area]->addr =3D __kasan_unpoison_vmap_areas(addr, siz=
e, flags);
> +               vms[area]->addr =3D __kasan_unpoison_vmap_areas(addr, siz=
e, flags, tag);

I'm thinking what you can do here is:

vms[area]->addr =3D set_tag(addr, tag);
__kasan_unpoison_vmalloc(addr, size, flags | KASAN_VMALLOC_KEEP_TAG);

This is with the assumption that Jiayuan's patch is changed to add
KASAN_VMALLOC_KEEP_TAG to kasan_vmalloc_flags_t.

Then you should not need that extra __kasan_random_unpoison_vmalloc helper.


>         }
>  }
>  #endif
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 4b7936a2bd6f..2a02b898b9d8 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -317,7 +317,7 @@ static void init_vmalloc_pages(const void *start, uns=
igned long size)
>  }
>
>  static void *__kasan_unpoison_vmalloc(const void *start, unsigned long s=
ize,
> -                                     kasan_vmalloc_flags_t flags)
> +                                     kasan_vmalloc_flags_t flags, int un=
poison_tag)
>  {
>         u8 tag;
>         unsigned long redzone_start, redzone_size;
> @@ -361,7 +361,11 @@ static void *__kasan_unpoison_vmalloc(const void *st=
art, unsigned long size,
>                 return (void *)start;
>         }
>
> -       tag =3D kasan_random_tag();
> +       if (unpoison_tag < 0)
> +               tag =3D kasan_random_tag();
> +       else
> +               tag =3D unpoison_tag;
> +
>         start =3D set_tag(start, tag);
>
>         /* Unpoison and initialize memory up to size. */
> @@ -390,7 +394,7 @@ static void *__kasan_unpoison_vmalloc(const void *sta=
rt, unsigned long size,
>  void *__kasan_random_unpoison_vmalloc(const void *start, unsigned long s=
ize,
>                                       kasan_vmalloc_flags_t flags)
>  {
> -       return __kasan_unpoison_vmalloc(start, size, flags);
> +       return __kasan_unpoison_vmalloc(start, size, flags, -1);
>  }
>
>  void __kasan_poison_vmalloc(const void *start, unsigned long size)
> @@ -405,7 +409,7 @@ void __kasan_poison_vmalloc(const void *start, unsign=
ed long size)
>  void *__kasan_unpoison_vmap_areas(void *addr, unsigned long size,
>                                   kasan_vmalloc_flags_t flags, u8 tag)
>  {
> -       return __kasan_unpoison_vmalloc(addr, size, flags);
> +       return __kasan_unpoison_vmalloc(addr, size, flags, tag);
>  }
>  #endif
>
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index 0a8d8bf6e9cf..7a66ffc1d5b3 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -625,8 +625,10 @@ void kasan_release_vmalloc(unsigned long start, unsi=
gned long end,
>  }
>
>  static void *__kasan_unpoison_vmalloc(const void *start, unsigned long s=
ize,
> -                                     kasan_vmalloc_flags_t flags)
> +                                     kasan_vmalloc_flags_t flags, int un=
poison_tag)
>  {
> +       u8 tag;
> +
>         /*
>          * Software KASAN modes unpoison both VM_ALLOC and non-VM_ALLOC
>          * mappings, so the KASAN_VMALLOC_VM_ALLOC flag is ignored.
> @@ -648,7 +650,12 @@ static void *__kasan_unpoison_vmalloc(const void *st=
art, unsigned long size,
>             !(flags & KASAN_VMALLOC_PROT_NORMAL))
>                 return (void *)start;
>
> -       start =3D set_tag(start, kasan_random_tag());
> +       if (unpoison_tag < 0)
> +               tag =3D kasan_random_tag();
> +       else
> +               tag =3D unpoison_tag;
> +
> +       start =3D set_tag(start, tag);
>         kasan_unpoison(start, size, false);
>         return (void *)start;
>  }
> @@ -656,13 +663,13 @@ static void *__kasan_unpoison_vmalloc(const void *s=
tart, unsigned long size,
>  void *__kasan_random_unpoison_vmalloc(const void *start, unsigned long s=
ize,
>                                       kasan_vmalloc_flags_t flags)
>  {
> -       return __kasan_unpoison_vmalloc(start, size, flags);
> +       return __kasan_unpoison_vmalloc(start, size, flags, -1);
>  }
>
>  void *__kasan_unpoison_vmap_areas(void *addr, unsigned long size,
>                                   kasan_vmalloc_flags_t flags, u8 tag)
>  {
> -       return __kasan_unpoison_vmalloc(addr, size, flags);
> +       return __kasan_unpoison_vmalloc(addr, size, flags, tag);
>  }
>
>  /*
> --
> 2.52.0
>
>

