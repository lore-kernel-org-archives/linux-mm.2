Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2CD3C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433F58E00AC; Thu, 24 Jul 2025 14:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4998E007C; Thu, 24 Jul 2025 14:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3D78E00AC; Thu, 24 Jul 2025 14:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 184A18E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:40:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E31B8803B3
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:40:16 +0000 (UTC)
X-FDA: 83700023232.15.79B9370
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF3CC140006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:40:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=M9EDescT;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.46 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753382415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BMNHZLCVEeiqDvQaiWaHPR4yi2NaTZkc3BJ0ttGl9Y=;
	b=g6lcPsv0T27lMeyYCnl0za6K8G3mHMAKUquzZBh7o6jARrxXrRJoAWL87eXzyNJSBD0oJ+
	0ODZzYCZzEuE039OdcItVOisezdPz52mj3fywzR1e2AOxt0a0KXd+IFFGWDDYeICdxZXcl
	bIbUFBLOldUWDRYIe2V1I3UAElFrhtE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753382415; a=rsa-sha256;
	cv=none;
	b=SVK4Y7DSCTC3iK5CYDg4fTCSBQKX5U63mjffHQcfhTkVTq4HiDkGuo+Lb2YoAcsYJV47XX
	h13F7/lN4ypf4seHuOt8G0u6GR2PMwguG5dMv5l1EWk4biV0SAvLwliIsET93tQRDF3XYA
	mmfX0g+AvKqUP8IVsjh9ESKFE9GB+I4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=M9EDescT;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.160.46 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2ffaa4b4f32so31576fac.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 11:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1753382414; x=1753987214; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1BMNHZLCVEeiqDvQaiWaHPR4yi2NaTZkc3BJ0ttGl9Y=;
        b=M9EDescTJECEClQoCPfhjXdg0D8PSNfYBydb0pKDjZI5xbm258+buY9lAvRsyXm9Gu
         GWCRmAHZqbwr+rEjIZOxWQzx8ZG0sADoySBALMdM8Ye9j9NrhcAafKCZUM3lQ/mX04xW
         z5u2qGiCdne2yh2qs2oQd7SU9/AswbUinZbHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753382414; x=1753987214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1BMNHZLCVEeiqDvQaiWaHPR4yi2NaTZkc3BJ0ttGl9Y=;
        b=KEFBxPpDP1aExAmh6D9jCFOjZ7uuc+ldDth0MCRlmtGDadftQZSWAqbPT/tyHA0LjE
         jmYto1Lqx4rrI/O0nzPpdNV0SCqhU3KOUYzMbYEsw+CZG2DywKJnaF7YVDIkEPnwcAim
         QUPnes31wLKgU2FzGBYYa3KA9trXfS2WemvykEJWu+Ig4HfT3JiD0B4N+iJhlRIsSuMS
         luoz3kUF2pBPhxEU8Hf7SeImURPTycLs02+uYCjmkETTiJZtE3+IQjjn+ZnxW6vwBCdg
         Qf7E78T+Xl9ntkYMQ1lTnT5Kh4MKTgvUx+6tdj7DSBNs5a4CQf0ja+JAA7agCTTPVazA
         ZO1A==
X-Forwarded-Encrypted: i=1; AJvYcCUozNotNa6ZRE/+Pd9VcpTnreBr6oicDzjnGZ2N2TbN0+NZVsfiR/trhjiYEAXvWYExih4JNK//4Q==@kvack.org
X-Gm-Message-State: AOJu0YwO/byn7uAZhr0TUI79FEUcDHbyjuctRdzupwp+/GEv6FEwrf2r
	5MOBgFvORS+VPvkFkxQHaUK7ZRVg7fCs4j2IDqcMcOkYXTnyp6VuxEnE5PbFR8GqriVk23CsfvT
	lW50TUmzdNbFkWURan+YJcOSpmlvp14uJQ97GnFMh
X-Gm-Gg: ASbGnctEMGJTss8LNOvKD7pQa7c8C+7QZrsi6z4DYRyiOxkhDAdIBj6asKLueKR8PIK
	JRKkWCsJjpFWf9QtaPaUXmOP+eYJfP/XsZHk9QJgrDsakENtRNEF3zXVhkmwDHhC2OUD0ghL81m
	8ZtqQDScNha/SwMxW3oCHnbQCHHi0VVZX3l0xJkL7jy6tcVhiwrjD7xmTzDK4nxkvg5ZC4lZShz
	8CEz5jZOyB3Vj2OQJY+8MeIrSO6PRWKJ1Cy
X-Google-Smtp-Source: AGHT+IHIg+HNobqPln9IVjLqjazZFObcWO0xYiJwOyYA5v6NMPyUL45KIuuKS1EbBH0g5KjtFnTF/JHPrS1eWYH49pw=
X-Received: by 2002:a05:6871:3427:b0:2c1:b4ce:e43b with SMTP id
 586e51a60fabf-306c735ce5cmr2179176fac.12.1753382413658; Thu, 24 Jul 2025
 11:40:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com> <ac51c2a3c68a2475149b54180ff012fffab72c02.1752687069.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <ac51c2a3c68a2475149b54180ff012fffab72c02.1752687069.git.lorenzo.stoakes@oracle.com>
From: Jeff Xu <jeffxu@chromium.org>
Date: Thu, 24 Jul 2025 11:40:01 -0700
X-Gm-Features: Ac12FXznMGya-BnO3U5H6mKpJLmpNyl0TeBQAlHn33pD748OLsKUzh_9L0k-wdw
Message-ID: <CABi2SkXHyF+dHo7Rv5V1jPZ4B5_v4Hva-A4XphtRMQJTrw_jqQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] mm/mseal: small cleanups
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hrq18g4i6ij5pup8ewm7r98k4hopuzpw
X-Rspamd-Queue-Id: EF3CC140006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753382414-452656
X-HE-Meta: U2FsdGVkX1+Bri3ukEdN41EbCYvGH40ZFJcxrtnYFb5eqehuixWdIpyyc4NgpHnLJ3tZxizhGTBSIuYVnep9axDpowP0B35j4fHR+Yz6ty5LZuakVWYY9+VZDEd3ZzGGUBDcJE0X+7CaIkBvuSrRpP28WMpj5Y17sdPOC71mwI1aCrx4oLylhO5ogkjkGoDEKXUenJjB0+xO8vhWopsFqIG/8Et30ebEeBkWb95+DkYOAKLSXWJORWbG1fGuFRPmn3gA1AzrxcX93IenSdkeAOEbiiZxv9jkV7doMs+E/teVU1FK+zVFW0Vz0JLZfu5TItIuSo3Mg0XclVqyzzkPEDgk33lF9DX7AlEgISt1X/k6Co8D5D+GPg7Iuk3NO9bJNR790iGxEfEs5o+WqhfIeV4P2dPTKDqayhaf3S3ncxgQJ5//pKvK1Wegke7CFzzETXyhqqeLiW0v7+vB0oZxKQJvxr1UM2avemuAZKRtdBMazO0N4NBUfJTprFw72fpU7V279WK/efdbeafl77O6cNeTrvqWdBDuQMgroBI3xBejT8+xW7u2lbErW09Nc29wOGkTyRZ2P8cDUfD9pfcY5Xxo5Jp7IH7COqRBPQEp4H1lvZBwDk/ZAzKFl1yZZFAf6jYNvGbLvsYkbofGEBDJU7tUooEl2mqi4+VEA6cjSWTgHf0gDXABxhD+WafYWjuncGO6+wiu27Ubr1AT12VTeGBQs+3jvkchthhQZpTqzFLbsGJqk6+inSTZyMEUSvImWG57E8hcZv40znc0bMod5ImCurusJS2vQAtRAc6iUEZus3DUhw43DJVy2V9zwTjplbmM580RvJeublAWGBla+l1q2s0jExx2PxVg4Ci2sFmNV3q6COeON8tIQhSh0DFegWMwKWpyuZXs8jFyjmNpV57YpUY5Xcp/kCtd2vWO5oVYU2I5DdnZovrOMr9nZEHpFZfV3bR9/wKKQ/5SEEc
 r9aGBopF
 ORaNeikYWyo2Cf5miBf1+D2zpqrNI+0AhQSsmRPe+xvsxpIeg6lOZkpnaHEUNs5obvSEdf913wszWgp70Mea2PKpZiiWqGSGgN2/cxRUm2BdSu0tKAA7G90HEqfAxa/Pj4hQBXBoxJ9P4pFAzTX8CxsGSLtHaFcmghZQzSiYGwpTRpmf+HmyGRs4WdWiMG8HlJ/LABe5n6JqnBYZvuhIuIgWZiQyedhxvFieBvnMbMln20wxsiNuGysfiYNOfxy0h8YPWyYT1C1xrgpbzv5zIG+aOaE1NPJNuHFa/8sQWxabH5AY=
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
> Drop the wholly unnecessary set_vma_sealed() helper(), which is used only
> once, and place VMA_ITERATOR() declarations in the correct place.
>
> Retain vma_is_sealed(), and use it instead of the confusingly named
> can_modify_vma(), so it's abundantly clear what's being tested, rather th=
en
> a nebulous sense of 'can the VMA be modified'.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Jeff Xu <jeffxu@chromium.org>

Thanks and regards
-Jeff
> ---
>  mm/madvise.c  |  2 +-
>  mm/mprotect.c |  2 +-
>  mm/mremap.c   |  2 +-
>  mm/mseal.c    |  9 +--------
>  mm/vma.c      |  4 ++--
>  mm/vma.h      | 20 ++------------------
>  6 files changed, 8 insertions(+), 31 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index dc3d8497b0f4..da6e0e7c00b5 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1286,7 +1286,7 @@ static bool can_madvise_modify(struct madvise_behav=
ior *madv_behavior)
>         struct vm_area_struct *vma =3D madv_behavior->vma;
>
>         /* If the VMA isn't sealed we're good. */
> -       if (can_modify_vma(vma))
> +       if (!vma_is_sealed(vma))
>                 return true;
>
>         /* For a sealed VMA, we only care about discard operations. */
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 88709c01177b..807939177065 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -605,7 +605,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_g=
ather *tlb,
>         unsigned long charged =3D 0;
>         int error;
>
> -       if (!can_modify_vma(vma))
> +       if (vma_is_sealed(vma))
>                 return -EPERM;
>
>         if (newflags =3D=3D oldflags) {
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 5b7fe8f36074..8e93eca86721 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1649,7 +1649,7 @@ static int check_prep_vma(struct vma_remap_struct *=
vrm)
>                 return -EFAULT;
>
>         /* If mseal()'d, mremap() is prohibited. */
> -       if (!can_modify_vma(vma))
> +       if (vma_is_sealed(vma))
>                 return -EPERM;
>
>         /* Align to hugetlb page size, if required. */
> diff --git a/mm/mseal.c b/mm/mseal.c
> index 1308e88ab184..adbcc65e9660 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -15,11 +15,6 @@
>  #include <linux/sched.h>
>  #include "internal.h"
>
> -static inline void set_vma_sealed(struct vm_area_struct *vma)
> -{
> -       vm_flags_set(vma, VM_SEALED);
> -}
> -
>  static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *=
vma,
>                 struct vm_area_struct **prev, unsigned long start,
>                 unsigned long end, vm_flags_t newflags)
> @@ -36,7 +31,7 @@ static int mseal_fixup(struct vma_iterator *vmi, struct=
 vm_area_struct *vma,
>                 goto out;
>         }
>
> -       set_vma_sealed(vma);
> +       vm_flags_set(vma, VM_SEALED);
>  out:
>         *prev =3D vma;
>         return ret;
> @@ -53,7 +48,6 @@ static int check_mm_seal(unsigned long start, unsigned =
long end)
>  {
>         struct vm_area_struct *vma;
>         unsigned long nstart =3D start;
> -
>         VMA_ITERATOR(vmi, current->mm, start);
>
>         /* going through each vma to check. */
> @@ -78,7 +72,6 @@ static int apply_mm_seal(unsigned long start, unsigned =
long end)
>  {
>         unsigned long nstart;
>         struct vm_area_struct *vma, *prev;
> -
>         VMA_ITERATOR(vmi, current->mm, start);
>
>         vma =3D vma_iter_load(&vmi);
> diff --git a/mm/vma.c b/mm/vma.c
> index fc502b741dcf..75fd2759964b 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -1351,7 +1351,7 @@ static int vms_gather_munmap_vmas(struct vma_munmap=
_struct *vms,
>                 }
>
>                 /* Don't bother splitting the VMA if we can't unmap it an=
yway */
> -               if (!can_modify_vma(vms->vma)) {
> +               if (vma_is_sealed(vms->vma)) {
>                         error =3D -EPERM;
>                         goto start_split_failed;
>                 }
> @@ -1371,7 +1371,7 @@ static int vms_gather_munmap_vmas(struct vma_munmap=
_struct *vms,
>         for_each_vma_range(*(vms->vmi), next, vms->end) {
>                 long nrpages;
>
> -               if (!can_modify_vma(next)) {
> +               if (vma_is_sealed(next)) {
>                         error =3D -EPERM;
>                         goto modify_vma_failed;
>                 }
> diff --git a/mm/vma.h b/mm/vma.h
> index 85db5e880fcc..b123a9cdedb0 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -559,31 +559,15 @@ struct vm_area_struct *vma_iter_next_rewind(struct =
vma_iterator *vmi,
>  }
>
>  #ifdef CONFIG_64BIT
> -
>  static inline bool vma_is_sealed(struct vm_area_struct *vma)
>  {
>         return (vma->vm_flags & VM_SEALED);
>  }
> -
> -/*
> - * check if a vma is sealed for modification.
> - * return true, if modification is allowed.
> - */
> -static inline bool can_modify_vma(struct vm_area_struct *vma)
> -{
> -       if (unlikely(vma_is_sealed(vma)))
> -               return false;
> -
> -       return true;
> -}
> -
>  #else
> -
> -static inline bool can_modify_vma(struct vm_area_struct *vma)
> +static inline bool vma_is_sealed(struct vm_area_struct *vma)
>  {
> -       return true;
> +       return false;
>  }
> -
>  #endif
>
>  #if defined(CONFIG_STACK_GROWSUP)
> --
> 2.50.1
>

