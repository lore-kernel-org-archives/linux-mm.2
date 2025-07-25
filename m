Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D8D5C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 17:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148BB6B008C; Fri, 25 Jul 2025 13:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F98B6B0093; Fri, 25 Jul 2025 13:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00EE66B0095; Fri, 25 Jul 2025 13:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5D796B008C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:29:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF0FA14089D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:29:12 +0000 (UTC)
X-FDA: 83703472944.30.BAFFCFA
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id E8377A0007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:29:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FP8HaNUn;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf15.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.52 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753464551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSaE+fdvZNJRb9bk+7FrHFzB6ezZdAXVqKWN6jX9fuc=;
	b=EVngU2rS3NGEWxRQU9Td3DWWivohiEwawfOEXAX7lI5b7d03n8ESsg6Ne3evvajpaYXN9L
	0DDECpnBCcZH6LeccrYLrfEqbYftGHkpp6m7htnaXpIsAf32VffY45wXqTCXQjxjZSdVcC
	2O4gp83w6LxsEmlwIMzCRleOr6lPFgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753464551; a=rsa-sha256;
	cv=none;
	b=sXmTOsBJafOUKbCQFCF+kjeXvWOv+g5mm7Lj5UA5DaNTaeV9ncpooNxMG9KK/QLDbPtSEC
	LRxi264vHmgc141QEY/F64efW894xPBXRQkJul/bBw2UknSrnDzS25qbbg3yykuLmKJjfV
	amFEMtRQJVtwPAgaIW7EdxpEDL+BetA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FP8HaNUn;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf15.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.52 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-30687111693so363962fac.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753464550; x=1754069350; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kSaE+fdvZNJRb9bk+7FrHFzB6ezZdAXVqKWN6jX9fuc=;
        b=FP8HaNUnmsoOTvcLgvJPCwvdh8TAtTVqwzYbCw1wYesbGSUp4r6dAAW0cDoxYRGJxM
         Ljmjc2kSIG8/5KgoZkoNY4zwLNXyxobp2pw2pdu9CYWVsTIJDWR2wGmQ2yTfKgHFqPoY
         f8Xc2G5Jn5l0WMHP2cpnKHJ3GXARy0ZxLQFGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753464550; x=1754069350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kSaE+fdvZNJRb9bk+7FrHFzB6ezZdAXVqKWN6jX9fuc=;
        b=IJ3CJ6m5mFbAjZP/6ICAs123HM5APxG8t6wJbQBqbIWSihchQB+l7URq+MlUTHW31T
         ln0u9fYRgB6MPYxYqJzewwsh0lkQG/FLNVmk0+ZRSNnqs5zeU4/4SOtt9pFjA9e+yUb4
         WhyU6fxV+ZJu4eFCl5UOU5ieWMs0wl0YDQW8FUql27A5RRzp3bs+JznJgkYQfqjgnOpd
         cYYMqqcmC7U6bhzf8axTwbNEZjCBBxELffYHLer8USBENLny9M+AyUKUmaQrTJOV/1PV
         lHBgBYW/HqxWGfcZLes0h97UKAPBOMFpy8CC7fADMHTrE/LmQoHC6GyzAxpDVduWnjJ/
         lRFw==
X-Forwarded-Encrypted: i=1; AJvYcCXRwfnDLGJ69dBpBD6TU+NPeVVKjSO3bZxbNkII2U8+IFFZsR4H8SSy021LR+XIXJ1TZVeRudbhGw==@kvack.org
X-Gm-Message-State: AOJu0Yxt1OOyaTJPRmEnaE+mHOYpCTh4hv1UNTH1VgwK294t0Sx9nZd+
	1OHBdQ/+/RG/UHqza8DLox2z/y18EaX/+zBj/FK2SmH8SAwMw5FWPl41dL1onzI2o/GHDIqjl/w
	9uiIzcOlMhflK3xTXjrZwjZ32tIh4e2wsvQPEkllk
X-Gm-Gg: ASbGncvLptjIkjz8S/CNNJN9r95Tk+ksBpNgfvergZP6lvwNAyqFrTcVVEOgyldTpvE
	7NnTvHbqFLpqI956yMwRKBsgUUdVbMcS27jp8OnNZ/weKz6zVcEIROpi1xYGij9Ea6R65tN76Mh
	huSb5F1V8GxF09QxdNmBfv+Iu6HYG8bfpfX1fRXzyEamvhx5opryWZIBhvusnR/PnCMPiksr7Q6
	1JKLVyj/o8RD1qk4fJG0tz7T/ZS6knyt3JF1g==
X-Google-Smtp-Source: AGHT+IEFqlrwTnKDoR7DIn2NqYJ23XBMp5ePhuoZhZWSSkqYz9HxqLYfIgNGRVP8ewYjbRm4dTAB2AFJDFMz9nij6pk=
X-Received: by 2002:a05:6870:3801:b0:2b8:f99d:7ce6 with SMTP id
 586e51a60fabf-30701e53f8emr649983fac.3.1753464549754; Fri, 25 Jul 2025
 10:29:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com> <492a98d9189646e92c8f23f4cce41ed323fe01df.1753431105.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <492a98d9189646e92c8f23f4cce41ed323fe01df.1753431105.git.lorenzo.stoakes@oracle.com>
From: Jeff Xu <jeffxu@chromium.org>
Date: Fri, 25 Jul 2025 10:28:57 -0700
X-Gm-Features: Ac12FXz_pXsJ1IDMKlfMO5R9PgQPO6x_W1wy-9G-nGooGD61YrZpGMC1Em0jUKM
Message-ID: <CABi2SkVSjRV_zz0mhuRF3t3UJM_x=+gct1jbV=qd7eNMPBbvkQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] mm/mseal: update madvise() logic
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E8377A0007
X-Stat-Signature: r9y1rm7ce6y6jjxp63m9c47xdsheh6dx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753464550-652342
X-HE-Meta: U2FsdGVkX1+QCrFLxVNQu+jS4CG6+JxH/45caFbwwbYD5DBR5JUH74cQqBcj50BL+12S6LezFLW6vkb86zS0xvaJzzr7nOTUDDgx4xzyofgPFuqQy7BvWaG2trl6f0vth/u1cJm2C1QSKelJBFij3k4VKwXAxkB76UWJ3JH+vyyiOAiW7SmoPqw/JFv0/w6lX9HocrdhiwBDQaOktkvkZfH/ppdwRd7WiG0UAF28Nv7QN00wHEDDxNR9015Xkds7k8ARaZOazvecU6CMSnx+xn9g3l9UuEntabjm5n9aSoAIiyZ4ELFcXvED1sep05i0f83VsqMGwB9kbKDpovSM3HKf1SmlwwyUtP9GKPGh9Epxpe/kM+0xtEkcsb+lI6pIt3O+ZtqwdG3KsNcZRmtTIXqm06H43eQYVL7VmaDTkWoS6WIqYsx9rIwhVR+yU7llXKZER7mbHDJEf/43gX9+2C2UBWu+bqa3Q4dbs2yrorDSFYgtDFmCzPt3Wvn+vslSJmGETiGQLlKrNAZ/lkpZWFFnkntRoMd2pJfZ2Dzw9O5H/DD+X71i5h0SPUHWHpud5J1BTa6d4sgWYZlaiEP1nwg8U4J6hiJM+wtMfj8OufmZhETorViBA4KR+6y6vZJwOQ5pKJdg/RCOqfRMPLpKvAYoFsIjtbGzV1pQxzKtuf9KcEGKfwabYHyKFqzo2jolYJzBPF1ew0xQod963oEKryXkQvKvYqLQfyAnV3UQt5nDVjtxwsXsDkSbxfFh3akwB6o5KNt9Ygnn5oRG7iX3e0+DRLNEcdUvJYweRvdtWmGM1pGRIC0aRrbkC6s/s07DI7/PJ36aFxgCG+RdWcbpGNUzHxoYjDHyfFxSghpIDbMDCSFFV85lSZ7fMMDudRBmbIKQX2S+SHXo354ZigeJ4jCC9l097+bysi48EJUUz99HMUVV6aWll7FWbM/pmzVz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo

On Fri, Jul 25, 2025 at 1:30=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> The madvise() logic is inexplicably performed in mm/mseal.c - this ought
> to be located in mm/madvise.c.
>
> Additionally can_modify_vma_madv() is inconsistently named and, in
> combination with is_ro_anon(), is very confusing logic.
>
> Put a static function in mm/madvise.c instead - can_madvise_modify() -
> that spells out exactly what's happening.  Also explicitly check for an
> anon VMA.
>
> Also add commentary to explain what's going on.
>
> Essentially - we disallow discarding of data in mseal()'d mappings in
> instances where the user couldn't otherwise write to that data.
>
> We retain the existing behaviour here regarding MAP_PRIVATE mappings of
> file-backed mappings, which entails some complexity - while this, strictl=
y
> speaking - appears to violate mseal() semantics, it may interact badly wi=
th
> users which expect to be able to madvise(MADV_DONTNEED) .text mappings fo=
r
> instance.
>
> We may revisit this at a later date.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/madvise.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  mm/mseal.c   | 49 ------------------------------------
>  mm/vma.h     |  7 ------
>  3 files changed, 70 insertions(+), 57 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index bb80fc5ea08f..7f9af2dbd044 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -19,6 +19,7 @@
>  #include <linux/sched.h>
>  #include <linux/sched/mm.h>
>  #include <linux/mm_inline.h>
> +#include <linux/mmu_context.h>
>  #include <linux/string.h>
>  #include <linux/uio.h>
>  #include <linux/ksm.h>
> @@ -1256,6 +1257,74 @@ static long madvise_guard_remove(struct madvise_be=
havior *madv_behavior)
>                                &guard_remove_walk_ops, NULL);
>  }
>
> +#ifdef CONFIG_64BIT
> +/* Does the madvise operation result in discarding of mapped data? */
> +static bool is_discard(int behavior)
> +{
> +       switch (behavior) {
> +       case MADV_FREE:
> +       case MADV_DONTNEED:
> +       case MADV_DONTNEED_LOCKED:
> +       case MADV_REMOVE:
> +       case MADV_DONTFORK:
> +       case MADV_WIPEONFORK:
> +       case MADV_GUARD_INSTALL:
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
> +/*
> + * We are restricted from madvise()'ing mseal()'d VMAs only in very part=
icular
> + * circumstances - discarding of data from read-only anonymous SEALED ma=
ppings.
> + *
> + * This is because users cannot trivally discard data from these VMAs, a=
nd may
> + * only do so via an appropriate madvise() call.
> + */
> +static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
> +{
> +       struct vm_area_struct *vma =3D madv_behavior->vma;
> +
> +       /* If the VMA isn't sealed we're good. */
> +       if (can_modify_vma(vma))
> +               return true;
> +
> +       /* For a sealed VMA, we only care about discard operations. */
> +       if (!is_discard(madv_behavior->behavior))
> +               return true;
> +
> +       /*
> +        * We explicitly permit all file-backed mappings, whether MAP_SHA=
RED or
> +        * MAP_PRIVATE.
> +        *
> +        * The latter causes some complications. Because now, one can mma=
p()
> +        * read/write a MAP_PRIVATE mapping, write to it, then mprotect()
> +        * read-only, mseal() and a discard will be permitted.
> +        *
> +        * However, in order to avoid issues with potential use of madvis=
e(...,
> +        * MADV_DONTNEED) of mseal()'d .text mappings we, for the time be=
ing,
> +        * permit this.
> +        */
> +       if (!vma_is_anonymous(vma))
> +               return true;
> +
> +       /* If the user could write to the mapping anyway, then this is fi=
ne. */
> +       if ((vma->vm_flags & VM_WRITE) &&
> +           arch_vma_access_permitted(vma, /* write=3D */ true,
> +                       /* execute=3D */ false, /* foreign=3D */ false))
> +               return true;
> +
> +       /* Otherwise, we are not permitted to perform this operation. */
> +       return false;
> +}
> +#else
> +static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
> +{
> +       return true;
> +}
> +#endif
> +
>  /*
>   * Apply an madvise behavior to a region of a vma.  madvise_update_vma
>   * will handle splitting a vm area into separate areas, each area with i=
ts own
> @@ -1269,7 +1338,7 @@ static int madvise_vma_behavior(struct madvise_beha=
vior *madv_behavior)
>         struct madvise_behavior_range *range =3D &madv_behavior->range;
>         int error;
>
> -       if (unlikely(!can_modify_vma_madv(madv_behavior->vma, behavior)))
> +       if (unlikely(!can_madvise_modify(madv_behavior)))
>                 return -EPERM;
>
>         switch (behavior) {
> diff --git a/mm/mseal.c b/mm/mseal.c
> index c27197ac04e8..1308e88ab184 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -11,7 +11,6 @@
>  #include <linux/mman.h>
>  #include <linux/mm.h>
>  #include <linux/mm_inline.h>
> -#include <linux/mmu_context.h>
>  #include <linux/syscalls.h>
>  #include <linux/sched.h>
>  #include "internal.h"
> @@ -21,54 +20,6 @@ static inline void set_vma_sealed(struct vm_area_struc=
t *vma)
>         vm_flags_set(vma, VM_SEALED);
>  }
>
> -static bool is_madv_discard(int behavior)
> -{
> -       switch (behavior) {
> -       case MADV_FREE:
> -       case MADV_DONTNEED:
> -       case MADV_DONTNEED_LOCKED:
> -       case MADV_REMOVE:
> -       case MADV_DONTFORK:
> -       case MADV_WIPEONFORK:
> -       case MADV_GUARD_INSTALL:
> -               return true;
> -       }
> -
> -       return false;
> -}
> -
> -static bool is_ro_anon(struct vm_area_struct *vma)
> -{
> -       /* check anonymous mapping. */
> -       if (vma->vm_file || vma->vm_flags & VM_SHARED)
> -               return false;

In this patch, the check for anonymous mapping are replaced with:

 if (!vma_is_anonymous(vma))
      return true;

vma_is_anonymous()  is implemented as following:
static inline bool vma_is_anonymous(struct vm_area_struct *vma)
{
   return !vma->vm_ops;
}

I'm curious to know if those two checks have the exact same scope.

The original intention is only file-backed mapping can allow
destructive madvise while sealed. I want to make sure that we don't
accidentally increase the scope.

Thanks and regards,
-Jeff



> -
> -       /*
> -        * check for non-writable:
> -        * PROT=3DRO or PKRU is not writeable.
> -        */
> -       if (!(vma->vm_flags & VM_WRITE) ||
> -               !arch_vma_access_permitted(vma, true, false, false))
> -               return true;
> -
> -       return false;
> -}
> -
> -/*
> - * Check if a vma is allowed to be modified by madvise.
> - */
> -bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior)
> -{
> -       if (!is_madv_discard(behavior))
> -               return true;
> -
> -       if (unlikely(!can_modify_vma(vma) && is_ro_anon(vma)))
> -               return false;
> -
> -       /* Allow by default. */
> -       return true;
> -}
> -
>  static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *=
vma,
>                 struct vm_area_struct **prev, unsigned long start,
>                 unsigned long end, vm_flags_t newflags)
> diff --git a/mm/vma.h b/mm/vma.h
> index acdcc515c459..85db5e880fcc 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -577,8 +577,6 @@ static inline bool can_modify_vma(struct vm_area_stru=
ct *vma)
>         return true;
>  }
>
> -bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior);
> -
>  #else
>
>  static inline bool can_modify_vma(struct vm_area_struct *vma)
> @@ -586,11 +584,6 @@ static inline bool can_modify_vma(struct vm_area_str=
uct *vma)
>         return true;
>  }
>
> -static inline bool can_modify_vma_madv(struct vm_area_struct *vma, int b=
ehavior)
> -{
> -       return true;
> -}
> -
>  #endif
>
>  #if defined(CONFIG_STACK_GROWSUP)
> --
> 2.50.1

