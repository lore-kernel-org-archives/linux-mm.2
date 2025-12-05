Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62641D2CE01
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 01:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68166B00DF; Thu,  4 Dec 2025 20:09:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B188C6B00E0; Thu,  4 Dec 2025 20:09:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E04F6B00E1; Thu,  4 Dec 2025 20:09:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9D16B00DF
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:09:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C3BE5880A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 01:09:17 +0000 (UTC)
X-FDA: 84183633954.25.F68331D
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6FF6D40003
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 01:09:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cXhOD4J5;
	spf=pass (imf01.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764896955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+mF3Gja/Pth6t91/XACwIVYUz7EioOwwJ2M/LMKxqY=;
	b=HnxN920l1sGrSMKw+/bIqdLMOHcZHuGH18vYQvmZwYxQgXezCWX05Q7zp0mYPTEMcpHNQ3
	Br7sDKxjR++ovyRvO8Ws3DLZTBnNWyuZzaf9BiaWvFnOsaYkEc/KSv4bGQyXdEeOBeW+dy
	3EF5Eblil+1tlTWLfmqwdk+MF31ebPs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764896955; a=rsa-sha256;
	cv=none;
	b=6UfTh/RkxdLDl72jeI71QV85QmMpx+bwcLzTzEXZ/NkZg1UG8qMlPa9fzyJUt65jXaWIvb
	e6vKm0U2AohfADIxKnqJwQQrJYFc+wTlKeqbf5SxyVYxxM+6aZRNB8SMd5E9sHbOCHwNf1
	iJ/CtRllGFBMhZQ6/gp4c2aDva5KitE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cXhOD4J5;
	spf=pass (imf01.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42e2b78d45bso738401f8f.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 17:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764896954; x=1765501754; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+mF3Gja/Pth6t91/XACwIVYUz7EioOwwJ2M/LMKxqY=;
        b=cXhOD4J5Xd57uBtAWsjvEqYQMWMuIYiuBJrufv+MgIBjngMI71B4JGr5pjfwgqvsiM
         iydD6xLlw9bNJptfy/ZP29QRE7PTZ+LTbLAkTCFkwuDmpBjq+pZ0dBaTwm222Pz5BOhV
         85cz38ITH2ImI9bFOOAdXYeKGS1rQw+w3ly8Bas2zncE3L7S2rEluzZ5tKw458ARtc2/
         2GBKPkldp7OkZ2noip7ZCMxBOJZgmb53VWzFWPYHNLZsQBnyGS+KK04flsqIr7buI8bY
         erSSXB87NGgnVCxI1GxBWQGBdDntj9v5Al9OT7JhlD494MdDbF9KfCAcA838tXIz5oyU
         WyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764896954; x=1765501754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m+mF3Gja/Pth6t91/XACwIVYUz7EioOwwJ2M/LMKxqY=;
        b=jsrF2t2SZL1QmOilKJOrzE3jlE5JNO2fJwrNx9q/flNJ7zqmBn+U+yp5MTCe28mQfs
         Ylx9Dt3Fse0P+/84yuPw31a0V9fdqebFwviMnDNPgF0CcCOjzx631cFrrUUPCZukUJAS
         yZFSucgHCoyyvE+PHyY+F2/XYgwVt1/bmMQuBr7aJOVGF7quybY1NujjncLbn7KP8t58
         NkDIOYOPyYRcWY4vw5XsExvYoySM+dSijWkeEj74+h3inRqEPnBPcnwiCBnarbNgOKW4
         Eb59FOjt5xf3geuZMr5RcC3GXHbtAFWYWdGSjRCcEGaviKU44+tKUFQ4Jphl59qDNkwI
         eFDg==
X-Forwarded-Encrypted: i=1; AJvYcCX3UUnftCWfeVAv7AfFpXRtHS4HKSZhTHKhPsm8PYRPxWdgAXA9QpnvrkEzH+r4lxiPZfLYYS/VPg==@kvack.org
X-Gm-Message-State: AOJu0YzhE0oJ9A+Xhf1uJoUEwcz6Fta5kAl6mse/1e5v2G76rol8bleR
	suwRMpt88ITblOMwci+p4512Y7rfUqBTwCZg6c68xaqrzPlHv5R/d6EJdo0d/wZ+nSvdPgS8wHS
	TZ+2DY/AL82LueVrO0IEp3xAUtRfH9iE=
X-Gm-Gg: ASbGnctRhgSnI4PAWUcUax4XVUymJTV/HIyu8Q2znZHhxlSp0AbjpOHrgQclRd0VHiU
	gHZe+LkNDx8hMc92wFHKNxMCFhE4QVyjH6ZI7acBUZnFR3a7dSvqh2bFhjMmgZ7Hd868JQa6Gpy
	AzF50tWnGGc6LQN/bS2AVFLrAZLqaaENSOqQhTDNhm2kUIWtIl1Q0MbhYxcZpC9hK1fouRQil/N
	WAxlDyl3jMOVmAAiN/qTiyJDqZ0E8nN78l++HhGfE2HtPKbJBOg0tfUPjlcvnICp5Zjqzs6XCqd
	48IuakOxrSL1za/bl7ryLxNEAgkMLI8D
X-Google-Smtp-Source: AGHT+IHrLxvQquVzeBGBF0tieKiREZvd+gfKaW/+zjkJAmLlTU45HN5GIeGBuFV6OBvncx3R42+sl70O/V0jBzKjc54=
X-Received: by 2002:a05:6000:1887:b0:42b:2f90:bd05 with SMTP id
 ffacd0b85a97d-42f731c3290mr7979343f8f.45.1764896953705; Thu, 04 Dec 2025
 17:09:13 -0800 (PST)
MIME-Version: 1.0
References: <cover.1764874575.git.m.wieczorretman@pm.me> <eb61d93b907e262eefcaa130261a08bcb6c5ce51.1764874575.git.m.wieczorretman@pm.me>
In-Reply-To: <eb61d93b907e262eefcaa130261a08bcb6c5ce51.1764874575.git.m.wieczorretman@pm.me>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 5 Dec 2025 02:09:02 +0100
X-Gm-Features: AQt7F2q4Ra3kjpdEcyDMUb7m8yHahuZhZTyWN3KMRPGCVySA_YBmuHFHNlC1cSE
Message-ID: <CA+fCnZfRTyNbRcU9jNB2O2EeXuoT0T2dY9atFyXy5P0jT1-QWw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] kasan: Refactor pcpu kasan vmalloc unpoison
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Marco Elver <elver@google.com>, jiayuan.chen@linux.dev, stable@vger.kernel.org, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6FF6D40003
X-Stat-Signature: qh3pmb5bxh71ifkzk6qq7ht9zzpca171
X-HE-Tag: 1764896955-548774
X-HE-Meta: U2FsdGVkX18AXNR6j8ihXh4333SZx84bb7DHmDGCLOi6Al58m+lir8YPGjN6gJjXTpEkULOxxXH5qZfDU+a6JsrJJM1e1QLAKVcw/2yj02+POE/K0TdRgLqX3e4afo/1KXyNehQmhuDp8iEZ9YJ1qPUZiSImVdQ760hZ2kvQAkNU450aWpJvaupYgTIc9mfPzhGK81QRN8wIkwHLguE3Ypay7YYE5cbyab5zSEM0FOfOC8Ez3fZXrvxj0l4lkMx2FrvdQU9YrYRadh98GeeOShS1cy1+ofBhi4q9C4fEQxCSSYRl/6fY1UjjbNSgA4kCql7b1Z4dYtVIUbr0NUIaq2UYII3iPkxiLlEOIPf0RgLehelahL8bbChUWb9lSF9Adidw+U4QDFlazejHrwpbJ6JrnTaH4q9UgKm9eyOUhK8DcLVsNn7SpgHVQdUWjlXSnPzShS5vNXOw40dIpc/T3o5aZjknyWOF84R5igwO/+G5DrkHw6xQ8urxfenUhA17HZ5KcE7KNyU1bqxecNqpU1kln6HAoMyP4WjmCZ99ULR4vtxJWw/PbcgH54dT1mcMy1/YTG0Y3mTomq/X2iuzyaefnfeplJuRONlzXmTDdpQnZZ4G5ZdC4ik3uTN/bMtZnW1nzHEBdb7/WSKQ8n5vU+0fVciWSwwMvyLikmaAJhDSuHFDwowfTIPKCVi1VQoWvIESkAR3G+QlPHTuRVmyU9YBXcywrMCZH/d89Ztf45nrjJYl3MWdeSfUy8rvvxilv2r79T0Khn73VM8aAZMhuyGwVC1Lc3t+2pNvAHIfwEOR6sOuR9KEC51igYqe710sAYT0tBtFxH0U9TOWX4bB+WcMTbKVwSfrs/szhn8Ipy9LTiCUzvTMN8FLlV734jAZAQ7BoHsG2pOWop0A4Q6pRxm03EfNlPRfCC+AtQx7ta6NTw8XfzWuFTV9KNBCneFfdF7jdQL+orVklDmlk/E
 JCoCfOJu
 vEUMCsVE3tK2+IkYsxC+gFWOJMl/8hvYW2AUZOWrH8x9xa6bYHrCJuYcmpHPXuk9Dy1Z8nsYx0a2TNDQS6sdr7ZMKEQh5PAYB35ESxMESvPTEzm7hG1aO+/aF/5K9geGLzsjVR0axs6I1M+4wMf4OpixfKff/CLS95Uj6OhFIZViXNJAaT8KQXJXzoA1w6uQHs6nuBSlRjdywQpUCZ5xanUrcyJUh0/PQ376f8iV1Fgco/WWFvlu+kHc3SpjIg0TO7g/pLFizroX1Umqjs2Nne+HG9Ea2WO7rGF/YR3DObFf4DbCZGM7iFkzFVRTIxX/L+iyOyn+MsaaLxFLmCkGlpmlzUlY9iTeGAkswzhERWJMdMMrqkWZJmzI2GTFpomA0BdkM/X4pCQIMX3S2shxSDDuG/GMeUVZQwnua1KuSogax3/SR9z1nMEmG0kkTJu1rxLvdqqGrx/H7j8rdpGdDPoC9mnrM/TiPlDFJ59naTXl0F88B7BqTZbGnMyuJD47vDBzSyBF8rY8LpavBr7m3ftsUoA==
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

Nit: Can put this part after ---.

>
> Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
> Cc: <stable@vger.kernel.org> # 6.1+
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v3:
> - Redo the patch after applying Andrey's comments to align the code more
>   with what's already in include/linux/kasan.h
>
> Changelog v2:
> - Redo the whole patch so it's an actual refactor.
>
>  include/linux/kasan.h | 15 +++++++++++++++
>  mm/kasan/common.c     | 17 +++++++++++++++++
>  mm/vmalloc.c          |  4 +---
>  3 files changed, 33 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 6d7972bb390c..cde493cb7702 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -615,6 +615,16 @@ static __always_inline void kasan_poison_vmalloc(con=
st void *start,
>                 __kasan_poison_vmalloc(start, size);
>  }
>
> +void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
> +                                kasan_vmalloc_flags_t flags);
> +static __always_inline void
> +kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
> +                         kasan_vmalloc_flags_t flags)
> +{
> +       if (kasan_enabled())
> +               __kasan_unpoison_vmap_areas(vms, nr_vms, flags);
> +}
> +
>  #else /* CONFIG_KASAN_VMALLOC */
>
>  static inline void kasan_populate_early_vm_area_shadow(void *start,
> @@ -639,6 +649,11 @@ static inline void *kasan_unpoison_vmalloc(const voi=
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
> index d4c14359feaf..1ed6289d471a 100644
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
> +void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
> +                                kasan_vmalloc_flags_t flags)
> +{
> +       unsigned long size;
> +       void *addr;
> +       int area;
> +
> +       for (area =3D 0 ; area < nr_vms ; area++) {
> +               size =3D vms[area]->size;
> +               addr =3D vms[area]->addr;
> +               vms[area]->addr =3D __kasan_unpoison_vmalloc(addr, size, =
flags);
> +       }
> +}
> +#endif
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 22a73a087135..33e705ccafba 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4872,9 +4872,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned=
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

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

