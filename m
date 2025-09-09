Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3311ECA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A13B8E0011; Tue,  9 Sep 2025 16:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851628E0001; Tue,  9 Sep 2025 16:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 740DE8E0011; Tue,  9 Sep 2025 16:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 600688E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:09:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 185EC1A0604
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:09:39 +0000 (UTC)
X-FDA: 83870802078.10.9B2F7DC
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 40D3E40019
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:09:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AQk7cmcZ;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k2iEu3UkPnmUFQcRlFrbHDvxDgSjAEfpS4soOoNd4oI=;
	b=tL3//hKKKHCJD5YqOe9edeybJmII1aw+OVyfu9uMZ9E8dX9LAoFFI9tpxHPXZmWt0N73op
	0ZzprdlD45jYbIm+iiP2ZR8azZIwSfk/DLs049FQs22K+cvPlUP/wbm5Yk9Efohm6600nU
	oOGOqHHDRBwGiov8YZPuMG8kgXT5OzU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AQk7cmcZ;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448577; a=rsa-sha256;
	cv=none;
	b=C0dlmDdLi18PGSbThlHwxjWHILBsE5ift2GH4xlVxQTXkWGwwrV+gERm2+fdu8PrKgb+Nx
	60GYZcfqo2oLfONBacrF9511V8RM1Az8GLwmV05KhUm7wB6qPs/XzSLrs/GE986lIP7/rJ
	dkfW+iGaAnRmFp55rzuhO2mnPSlH2D0=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b48fc1d998so14141cf.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 13:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757448576; x=1758053376; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2iEu3UkPnmUFQcRlFrbHDvxDgSjAEfpS4soOoNd4oI=;
        b=AQk7cmcZPglAtqO2yh3ps9hhJFXNe/V7u6be8QyXsDpkASfGK51sfP5jlUNL0Y4Pk0
         NoGdMLZhbqiR6zArW8vSxOaBDUswySXUT/4g34OjvFdRoYCUbEgD51lS17Gn6O6bHGK0
         QvikmXReLr6bOAjP5r5H8bBUJDU5+af8IXkiPgJFRhQ10RjObcIwzKsfhBoBObZQDA15
         NW5eTbNqIk/aGmCnAbq2DU7I+fRodEuzATgoS8fkvbVhoE37BG7BCSAUmIldnxlCiBkz
         8VoPvR98uKdbK2kvj5Afn0YAVXY8GG2Fcz1LMySlJ2DInyZnFY2IuGV5oYWBpgCuPZOO
         myUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757448576; x=1758053376;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k2iEu3UkPnmUFQcRlFrbHDvxDgSjAEfpS4soOoNd4oI=;
        b=FokiEpZ6hWC09QqSoDhhZ+7uxsMcwgwXytet5vRTTUAAA14OumyEJ9kaSAuRxA+S2Y
         AsUyySzpyHpnaY9gy/NjYbFZLk5YWTDpZMGBSzyjygsKyFkT4cMI05WkvuPF59rz+DZ8
         Njqk/K0A7PRm95g/lkwnjlBurkI/or84uv22kuIjaO/SxRgW5QX80uRR+k5+SLedjxrx
         SQiBLXmEIoZdF0xvyMvLdjDQMt1Lh1XsZUVT4nlBnqC957oSB2jBuNG+hR5tIzP1K/nE
         R2p5VuWLiQl6Whwkns088UxEswrmvoWH9NpAlg5K2zihmJXdT+Q0hcOsg8c+ptmozUXr
         gsZw==
X-Forwarded-Encrypted: i=1; AJvYcCVF47+WgWZCSZcmr8ZX6JIzph86XW2VosNR5dIAtPY3gEPCvfOWfNa5oaY+K9YMzHa4l9lMmrKKuA==@kvack.org
X-Gm-Message-State: AOJu0Yyl7PaAAtVDqpNkJOejy6laVy29mwloMV3UwcE+Aw84OsfQKlIB
	/I9lElqVlO+5WhB6S9haNjOCVdwpV+lCPzakncaFdHcGo8bl7tcN0pJ+8FNzwZcxTEeATwbKw/D
	Q54oD3Tnl2YDNrWpFA69LLVzcC572j1QR9lRceBva
X-Gm-Gg: ASbGncuaYss2P33CF8ul3M3DHWl5qUQczVqD56P+qZYYFR0XxCONo2TPaA2MPtxJo9r
	eHxffZWjMRQzXEkf9SEXqgheNAll7UqdkVp01W546qnP9Gbwdr6jxD9CZLEIWjrP90HIVtf4qv8
	hG4jBY5cZkwNxklQq+AtGRCTfAH6uTy1CPMXHI/g9GUU62z39Ni8xOBBQlBF4qTnUSHUhS+vuZV
	O0gkOAQy1dpQx3GDpop9iV5Yw3INdIwEbiQJtFrLNi/yO1nyg1bE+0=
X-Google-Smtp-Source: AGHT+IGTNwq+7MViYUlFJ2vyU1cgy8m+5k5wmGXsJgTGt3s4JBmennrId+EoWqDbJIEA0d2+A3uYjG/h63nRoBrR2lo=
X-Received: by 2002:ac8:5a95:0:b0:4b0:82e5:946b with SMTP id
 d75a77b69052e-4b625102754mr1224361cf.4.1757448575785; Tue, 09 Sep 2025
 13:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com> <20250909190945.1030905-3-Liam.Howlett@oracle.com>
In-Reply-To: <20250909190945.1030905-3-Liam.Howlett@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 13:09:24 -0700
X-Gm-Features: AS18NWDlSEXaT8xC9-9GCN6E5E8NjDo0Ac393Cnh_Tc5RiGu5Zt4J6irQLdxDmI
Message-ID: <CAJuCfpFOt3_W+YQNy+xPzY_R6JUM3EOsbaZh+uznSNpF1RKX0Q@mail.gmail.com>
Subject: Re: [PATCH v1 2/9] mm/mmap: Abstract vma clean up from exit_mmap()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, 
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, 
	chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 40D3E40019
X-Stat-Signature: j67tyzetco5ort6h7zq3oidkmt5obpxr
X-HE-Tag: 1757448577-32078
X-HE-Meta: U2FsdGVkX1+dINfPdNUMXPsIbotNaX1mEYOTmbBsE6YLVdSOrLzbiRGcIeijeyGnPeDDdUWokNQY++QEGKCUfOfRFyW3JNlPliJkXyzLZ6/DAly/KozpeFqlCPwAi72vIURH2r79Tdycu9ISr8B4L5boFoagITWiHAucXaop6KPrVWCXqfy0R3Lsm+eoMrj4pBU3fzkuALBpje9S+uX50vai76UuRaHOwzsLvEEZ6uHT05Ov6+FQoF/Qg53XJ2kcZnWuScL3iFlviicYDyr7Q/WSOIcMJSNWEx5I8cMx4EwChTDp6QS0IozsvKicP5TvGvWy+jzWQ1PRYJANC7o5ZywWYCgpT1/6wWKtlKAj0rFcc2A552wkcidQM+4+w2Wcg4GCkylJSisa12miM8qwlXT6/akmI9l/Z5mehW/geOQigMZf8PFHm3mkxdauNk+tmd02zTkYNnKkd50HmZvAp0ybmhQMPm/XkKoqQPTQ4jslay02YXhy+mrdxD/6qoCGjyp++959jwbdhxFetlhZ40yV0qEUoge0iSf3gnJAT+KtZL9gi0ih9iZ7VxlkWYqNDWWVyLCLgaRmG40g9kkFelCOEJ4A4UOzz7sT/nwve81M/QFLHJP2FYntk/9W33dT0YQtTQ7iKpkXz+igFFhTiuMXy7AN4TucsQAA7xBJkvdRgtHT+iiB2IldV3whsAtcKvBR9ZmRtAPgUZ6DqgDq85LZ1LEmpRgLs/XSDjY7+8pUBLySwwXO4C9wViR5LGYul5ZjKhEVRRIy7rfWHqp8+ym0aQVUTqxj/X5HE9IG7CX8uJX5J3qRIDn2HwpXj3NIK4en8ztF97og8ze69tgH4z1yYwUs9bt4JaJR/KdRP4CuUIn/oaq8KjFL8vxUhgSW7/aiBc7VZaLHU7wptzK1h5eRyHiiaDMzFPdhrhv+4Qc0/4qA23uft5abFgaPTR800pBUsZTsumbA4HO/blx
 p/WyKBEr
 ZDGlh4k3+SiFMQc3eTP8hWZEHG2uUUJUz+nMh04qR8TtyRi8sRfMKPh/fbfTPR6pekgtkqcatt5i2dlpseMGEcbKVveIc9g3+nU5PfGAMMZF0H1fbb5T+VObovwTUfI8hKjHhjqlsP/ejZZJZG+uZdghP/YsBBivCcRdybHbnS/IThVmPokPTsfxS8C746LnAirPGkf/BwptL3CWQFnCT67hWsdRO6d1nNzQ77c5sJQ5i0q881TjPSK4E28dGU5iRZnoQTA1Rf0XN7Grnm3JwCPhL6Y5xFWd5vRhr5MxChy0pnUqLaOOZjm14YJ/JdPZ40et8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 12:09=E2=80=AFPM Liam R. Howlett <Liam.Howlett@oracl=
e.com> wrote:
>
> Create the new function tear_down_vmas() to remove a range of vmas.
> exit_mmap() will be removing all the vmas.
>
> This is necessary for future patches.
>
> No functional changes intended.
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/mmap.c | 37 ++++++++++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 13 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index b07b3ec5e28f5..a290448a53bb2 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1250,6 +1250,29 @@ int vm_brk_flags(unsigned long addr, unsigned long=
 request, vm_flags_t vm_flags)
>  }
>  EXPORT_SYMBOL(vm_brk_flags);
>
> +static inline

nit: Maybe let the compiler decide whether to inline this one?

> +unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *=
vmi,
> +               struct vm_area_struct *vma, unsigned long max)
> +{
> +       unsigned long nr_accounted =3D 0;
> +       int count =3D 0;
> +
> +       mmap_assert_write_locked(mm);
> +       vma_iter_set(vmi, vma->vm_end);
> +       do {
> +               if (vma->vm_flags & VM_ACCOUNT)
> +                       nr_accounted +=3D vma_pages(vma);
> +               vma_mark_detached(vma);
> +               remove_vma(vma);
> +               count++;
> +               cond_resched();
> +               vma =3D vma_next(vmi);
> +       } while (vma && vma->vm_end <=3D max);
> +
> +       WARN_ON_ONCE(count !=3D mm->map_count);
> +       return nr_accounted;
> +}
> +
>  /* Release all mmaps. */
>  void exit_mmap(struct mm_struct *mm)
>  {
> @@ -1257,7 +1280,6 @@ void exit_mmap(struct mm_struct *mm)
>         struct vm_area_struct *vma;
>         unsigned long nr_accounted =3D 0;
>         VMA_ITERATOR(vmi, mm, 0);
> -       int count =3D 0;
>
>         /* mm's last user has gone, and its about to be pulled down */
>         mmu_notifier_release(mm);
> @@ -1297,18 +1319,7 @@ void exit_mmap(struct mm_struct *mm)
>          * enabled, without holding any MM locks besides the unreachable
>          * mmap_write_lock.
>          */
> -       vma_iter_set(&vmi, vma->vm_end);
> -       do {
> -               if (vma->vm_flags & VM_ACCOUNT)
> -                       nr_accounted +=3D vma_pages(vma);
> -               vma_mark_detached(vma);
> -               remove_vma(vma);
> -               count++;
> -               cond_resched();
> -               vma =3D vma_next(&vmi);
> -       } while (vma && likely(!xa_is_zero(vma)));
> -
> -       BUG_ON(count !=3D mm->map_count);
> +       nr_accounted =3D tear_down_vmas(mm, &vmi, vma, ULONG_MAX);
>
>  destroy:
>         __mt_destroy(&mm->mm_mt);
> --
> 2.47.2
>

