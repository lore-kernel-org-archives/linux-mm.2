Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22BFFC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8E908E00AE; Thu, 24 Jul 2025 14:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3B158E007C; Thu, 24 Jul 2025 14:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02818E00AE; Thu, 24 Jul 2025 14:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 880238E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:41:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A8D3804E4
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:41:45 +0000 (UTC)
X-FDA: 83700026970.17.C7C9EF1
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 503CD40004
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:41:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Ixi9qBZW;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf07.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.50 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753382503; a=rsa-sha256;
	cv=none;
	b=bp57tOKrIjO0wOgVFa4MjNCQnnXUN0yiYuXUogaiL9bsoILhBpU0VPxEyLxKRyh1M2U/ui
	YSFD6lVtTNBysqHnFdvM35OGgeNG9zGUQQY5I/6hQS3VKx1OvjklC7IIDuXQ0jFDyn5UIw
	epB7qH0PIHu49dvVrTfriimP0z5F1Go=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Ixi9qBZW;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf07.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.50 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753382503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1HWlZ2q1kj2IfdBM1XqDySr0QM/i4rMvQ57Io2GLV0=;
	b=DP5o+m9vE9kgqLlkg4LKo+5r3FxAn46PXqW38RtaXVgpHnQSKKMyfLwBfoXlEaD+wvBpdf
	GXpJm+swDun0ACSeIVLmaTqQlouBLaGB9d3j6xbEClzp3qGIH+Z9N14c4wmccH9g5HA1x+
	e/Zl8G0GZTS4VbhY+PkrN9q+Q6puHRQ=
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-306db06638eso192011fac.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753382502; x=1753987302; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1HWlZ2q1kj2IfdBM1XqDySr0QM/i4rMvQ57Io2GLV0=;
        b=Ixi9qBZWZwe1E1AdMSATpG4e1Xh0qd3dxnQ5I56aIJpK27M6xRbunSk/MOH7bBy8me
         kZBQq8PApY0h1rB+/TryNLNIl+EaD0+yxim/mlwCuGAfoAEB68rBz41i9/adsVSh0gFM
         zovTEgcv5u+0onNuIrH3hwoAw98nruGa/WX6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753382502; x=1753987302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T1HWlZ2q1kj2IfdBM1XqDySr0QM/i4rMvQ57Io2GLV0=;
        b=hHNZlbraZXw3MXw45g0KRXnmGf+yUpd2fiJ58WuxKvySRZZ5dcOZ7fXgMxovw79hQy
         tQcLFTQLuKQ9TCv/vClnpDGj63TT3AOhAB92KR2zgwRVK6GDpORJ+TA8HEHrrufsgLlQ
         iqBXkPEuRyvwRg69govCMRulIap3f887BFMdrV2jJjLyHNh06gG6odzTbjoGXt2JDx1Q
         4HuYiL/mQ18G+4v/0JRDdGhVgFOCN3aDHwd6wXfpCqv+vkvZyvy6BPtE/hYTIol72UoY
         vLyKNcIezYlnxKPJ+wONZEW/Cc3Z0BMgKsSXhURzfJZ5SlysO/eZiQMQK71qyZ89uPd9
         E+tA==
X-Forwarded-Encrypted: i=1; AJvYcCXlTRAib7eSWGO49svRNQv0Qy8zGqDJDa7hYNu7YTQtXEBAraTZ+ivmFqYUUsIzDrNTJRVbau7hXw==@kvack.org
X-Gm-Message-State: AOJu0YyR0yG2LMbnCniM13gPoiTB2jCHtCHuFkl+uTa0Ro8ZqO1yGr/L
	sRb2Qh6sQFsle7r7kILzxIXhShl96fgjPWnBi94srK9bucNetf12gO2b38p7kJXT9LqzE2pgI8x
	I5A5qheRplP5Odfr0sbCp2lK722hVLkrE9o5IQ2JvkML6b1KTCtI=
X-Gm-Gg: ASbGncunf0pdlqiui0iM+6k3ohnWC69Gumo08gfYsVu2QCwuNbd6VkANwskux/GaORB
	cpTwjYfKJc8spL08WNuOHQt54HbFfJf8SiV+0gHxWLa3KhR1qdydiP4ckRyWj5o6mL0S0HnO3/9
	AC60z2uD8b5mvtopg3GIcrW4lj0KbvQU+Nus/gNK7mGcDY9YsOO2pD/kSX4GYeTkQk6t1cN/ai3
	H2yenDDute1uwGb24b4U0mZrdSUEyNbdWen
X-Google-Smtp-Source: AGHT+IFGOCABTTvB+uzF9wmiyKAOSjp+0YvJguYqvnGbeIpD4kNUAbPp92D+Kc9fHRgycq+ZSZnoA+bqeSnlnTMvEN0=
X-Received: by 2002:a05:6871:71c5:b0:2b8:f99d:7ce6 with SMTP id
 586e51a60fabf-306c6f21d67mr1770212fac.3.1753382502323; Thu, 24 Jul 2025
 11:41:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com> <9ae70e1c509d790cf174f16e491975efd9be50b6.1752687069.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <9ae70e1c509d790cf174f16e491975efd9be50b6.1752687069.git.lorenzo.stoakes@oracle.com>
From: Jeff Xu <jeffxu@chromium.org>
Date: Thu, 24 Jul 2025 11:41:30 -0700
X-Gm-Features: Ac12FXycf8JmBrOhOyz1OgvG94mrvgZe6JkSBqJucvHYxI-9914zkEue6RQd-ZA
Message-ID: <CABi2SkXQsao-S+uy63k6Zc=y4W-pik6XZSzw+05f_Ws_frqZmQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] mm/mseal: rework mseal apply logic
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 503CD40004
X-Stat-Signature: 5oubkknqh77n9xexgn5k7ywbbdm9qror
X-Rspam-User: 
X-HE-Tag: 1753382503-850645
X-HE-Meta: U2FsdGVkX193GBeTMHH6+/wNbKarhMocHbHG6LN4qGONNJA6OIcxjoKHLTdZxo56VbLq4q3mDj05hfjhw2D0J7iYZH1r2O72uCyEARv3gCVjezsKlWDZRqOgrccjDCj/Y6fJ21ijHRbQSwaILL50nWZgR9b8hzzHQltIwuyHuEGj9EjUFGByGhvo4BYpj9gYpGRVKrqY9MCvMk6erjvAP85Asehl9cRpEKgLbRxTWDiZ2mrJ5xdnD204ar1gbW8iTcPX3llCXSLWG6Krtngv79VAAKPtyrsDUZ0VuP6ngH4O1EUmwq1f++PkIF9IErfONRPrbLTP545RrlbmHoSwzHYfgkshh0OAzxa02zV+QkerVWY/qWYhycfzLqJVW8UsuL0jzoTp7XBLWjyhSUuA5MvP40wg1sz0wJmF0VCsalb83RyL8d3nKoIvEBi8mu6OsEZ/8C3t+TiU1qIm1yF2hiw7hbNYupILbiVvw+dg4yjso3k3Jeafj6o71MgJ+DfmVjafmn16aDvn+rSPsI8o596PEwsizfR9GuniSFJeWiSIMJYseZfYwv8RweqzCY+2YtzCe7ZEQX87EGdDweZ8OLdomVbtS0igQEJtshba6Kyk4CxA805zwI8U4+7NvUb2NOXIpcbgmJZ4p9H0huybRIC4L/zw65Qo+VKi2K/xlBUp7OnfFi6wlm0B2gP0jw/G0718jg1A7G6XbMUidAHR6ERjUqfIVicBMI/TidvupUpZoo4ksKwXXdZoj0SvW7PqQMFafqUcwBusjY+5DZR4ZvjXdiXdX6pJnaDBcUSzvD/ukFUj6pquQGQfAOvCGnkOLv5/91b4hcovJ1NZETuwFstUvrmAQTve+8OhwgTRcoPuniIpDOLXznTHkjVfRuQ7JkhUkkLGi/ve2qiDazabYMh6rNj95XsSN7in5/fprWD0EmBKTikcOrHYF1w8t+L6R6PqL+o/cfVboWAlTYz
 i3qGsCKI
 lBGxQCr7w5qJoMRylPOxDVqtY+e/I1pPcHyNBNh6Ky8vm520r9M37DH/Itq0RaScr2ngw5FZJsa2UjM1cdHQCK5LrUPat1Zit3yTuz4wFPSxv2dp1Mhv/TsJLHrUQ/FLV65ubCWmFOQbm10MZB/MiodlszUuBXJi8QWJoIlp3wyYMP0dsgFgcTjHrJvt+xU3Pmg2Bz8dwKkA0kzhf8LGwhOzqI+NJSFsPA/FCuf7ndbNlxv20ttTWBHU/H9ijl+9kt5v09Hc/4YbdR9JzvPNs+f1QWGVcg0fozI+fboDzZ1rtcSY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

On Wed, Jul 16, 2025 at 10:38=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> The logic can be simplified - firstly by renaming the inconsistently name=
d
> apply_mm_seal() to mseal_apply().
>
> We then wrap mseal_fixup() into the main loop as the logic is simple enou=
gh
> to not require it, equally it isn't a hugely pleasant pattern in mprotect=
()
> etc.  so it's not something we want to perpetuate.
>
> We eliminate the need for invoking vma_iter_end() on each loop by directl=
y
> determining if the VMA was merged - the only thing we need concern
> ourselves with is whether the start/end of the (gapless) range are offset
> into VMAs.
>
> This refactoring also avoids the rather horrid 'pass pointer to prev
> around' pattern used in mprotect() et al.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Jeff Xu <jeffxu@chromium.org>

Thanks and regards,
-Jeff
> ---
>  mm/mseal.c | 67 ++++++++++++++++--------------------------------------
>  1 file changed, 20 insertions(+), 47 deletions(-)
>
> diff --git a/mm/mseal.c b/mm/mseal.c
> index 61c07b1369cb..0ab12e09792a 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -15,28 +15,6 @@
>  #include <linux/sched.h>
>  #include "internal.h"
>
> -static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *=
vma,
> -               struct vm_area_struct **prev, unsigned long start,
> -               unsigned long end, vm_flags_t newflags)
> -{
> -       int ret =3D 0;
> -       vm_flags_t oldflags =3D vma->vm_flags;
> -
> -       if (newflags =3D=3D oldflags)
> -               goto out;
> -
> -       vma =3D vma_modify_flags(vmi, *prev, vma, start, end, newflags);
> -       if (IS_ERR(vma)) {
> -               ret =3D PTR_ERR(vma);
> -               goto out;
> -       }
> -
> -       vm_flags_set(vma, VM_SEALED);
> -out:
> -       *prev =3D vma;
> -       return ret;
> -}
> -
>  /* Does the [start, end) range contain any unmapped memory? */
>  static bool range_contains_unmapped(struct mm_struct *mm,
>                 unsigned long start, unsigned long end)
> @@ -55,38 +33,33 @@ static bool range_contains_unmapped(struct mm_struct =
*mm,
>         return prev_end < end;
>  }
>
> -/*
> - * Apply sealing.
> - */
> -static int apply_mm_seal(unsigned long start, unsigned long end)
> +static int mseal_apply(struct mm_struct *mm,
> +               unsigned long start, unsigned long end)
>  {
> -       unsigned long nstart;
>         struct vm_area_struct *vma, *prev;
> -       VMA_ITERATOR(vmi, current->mm, start);
> +       unsigned long curr_start =3D start;
> +       VMA_ITERATOR(vmi, mm, start);
>
> +       /* We know there are no gaps so this will be non-NULL. */
>         vma =3D vma_iter_load(&vmi);
> -       /*
> -        * Note: check_mm_seal should already checked ENOMEM case.
> -        * so vma should not be null, same for the other ENOMEM cases.
> -        */
>         prev =3D vma_prev(&vmi);
>         if (start > vma->vm_start)
>                 prev =3D vma;
>
> -       nstart =3D start;
>         for_each_vma_range(vmi, vma, end) {
> -               int error;
> -               unsigned long tmp;
> -               vm_flags_t newflags;
> -
> -               newflags =3D vma->vm_flags | VM_SEALED;
> -               tmp =3D vma->vm_end;
> -               if (tmp > end)
> -                       tmp =3D end;
> -               error =3D mseal_fixup(&vmi, vma, &prev, nstart, tmp, newf=
lags);
> -               if (error)
> -                       return error;
> -               nstart =3D vma_iter_end(&vmi);
> +               unsigned long curr_end =3D MIN(vma->vm_end, end);
> +
> +               if (!(vma->vm_flags & VM_SEALED)) {
> +                       vma =3D vma_modify_flags(&vmi, prev, vma,
> +                                       curr_start, curr_end,
> +                                       vma->vm_flags | VM_SEALED);
> +                       if (IS_ERR(vma))
> +                               return PTR_ERR(vma);
> +                       vm_flags_set(vma, VM_SEALED);
> +               }
> +
> +               prev =3D vma;
> +               curr_start =3D curr_end;
>         }
>
>         return 0;
> @@ -185,10 +158,10 @@ int do_mseal(unsigned long start, size_t len_in, un=
signed long flags)
>          * reaching the max supported VMAs, however, those cases shall
>          * be rare.
>          */
> -       ret =3D apply_mm_seal(start, end);
> +       ret =3D mseal_apply(mm, start, end);
>
>  out:
> -       mmap_write_unlock(current->mm);
> +       mmap_write_unlock(mm);
>         return ret;
>  }
>
> --
> 2.50.1
>

