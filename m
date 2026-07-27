Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FE0EC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F375B6B00D4; Mon, 27 Jul 2026 10:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8006B00D5; Mon, 27 Jul 2026 10:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E006A6B00D6; Mon, 27 Jul 2026 10:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B66F76B00D4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:53:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48C1E80779
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:53:50 +0000 (UTC)
X-FDA: 85034851020.14.2E98524
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5159A80011
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:53:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="N/Q1Ge6U";
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785164028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HBlnivitJQK60dpXDn/ZTN6OnP1/cWmlbn1S1eH9KWM=;
	b=vY3HXIHmPU3VgSCKdNiYd/7bDdpvCvGh/nGUawSBHLM2Iwfo9DHkFjQbLv+lgXyHY3XwzJ
	14UL1t9YB23M7vhVMdOZMi3AFYRYtJYup+1WAE9gwkB0WELrK5eJzsJ8GfhQTNnjqdATrx
	/ibtaccsDjm3DqbkhQTSLZsOcX8vwts=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785164028;
	b=B+2YmhZi/4h64d4z1M1XS9G74/0HlgU79Ex8g8CgOFvUMkNkr6YXm6lJpcrW/T6m7lXoBO
	snBoG+k+b+j5i+87icfxQaIFrq93OyGApKWNdSqq09JeWP9uc4i45rH74eRjCIgeBkSwG7
	VnjFs2AmNzP17j6os2T1PKcjoogqdpU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="N/Q1Ge6U";
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c10e86e52so391321cf.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:53:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785164027; cv=none;
        d=google.com; s=arc-20260327;
        b=ocnF6lcCEyUX23ewhJtREJn7K/xhstGiY/U0S3q7Gn5lN/DKqRD4dmId5OZ/8QRol2
         a+uiCseLGqMWCwJoqn2K0Z4KZoLbs1mmISPZ5NAHZq4E8dHth31GaKBdYo4LvIw5zBDK
         UuqsZz+sNR33ujbClx7/pZ3wj2E/iHmvUwwr4N8tOZDNi5gESvLgsXYAe8Fo/E9Adjsk
         RBf4ztCW4JuVGV92DuXIKGUGgKID5yD5dQwt+RUV0g4aBCgVeD3hXTSO6lnbXrouRl5T
         y/HlB8Bn8hTmxrueUKTavnOzvnQtomhCyaOTuopmu8vnCCdqJeFDsA8DE2JnkmgkfEm0
         /jbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HBlnivitJQK60dpXDn/ZTN6OnP1/cWmlbn1S1eH9KWM=;
        fh=yDJuneuJFOvu7dlQx6/y0FZwYVUe7bXIxQ/0iUMwmug=;
        b=WlxDZWPQLC4rxRXGvDirr0u6gkCSivFRuSaX8in/xGcnohHDn1c854lM6GqNLnwAo/
         KcbfJh7DW1yf9FlCSW6SPJ9p9+pw6FAN2eyrhEOSfrwQMhPTep2SoVWuQEmiHbyu74nD
         SPSj2vXpxwLVlEEjrfzOWU4grB+yt2Cy5BY/cBoH2Xkh68OqgJGlWTrWytASPy3FpykY
         fbd1rAaai257/dwBYT3FXwZBn/2dDv2dutE/UJgGzPIFEJJyQbYI/5/vdv8LiHCSflZN
         nj+6RxWE5wtLqf5ZUCoMNls8e4PfowmWjX+cdQzCDM+5ESANSJCZqw/GlXGC39lgbAZa
         uiGQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785164027; x=1785768827; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HBlnivitJQK60dpXDn/ZTN6OnP1/cWmlbn1S1eH9KWM=;
        b=N/Q1Ge6U0nwsHoK/VjTWj0GoxrCtpF8wLbHs6dv498fPbClIOPXicgU6J+B1PbJLrN
         +3/7i+0YN18d8hliwS1FacvNUlwltOS1SRQOlXzRlcFNDOVXRiVzgFKcryI7kI6gh/A3
         ixrklZT0GNRy55hRZGUYl1bWR/QLj8D/dgneyToanI1H56y5s6Nv7rWCE6sedECskYqn
         HAgsPQxChHNvHJWgWSlRArkUVzjniYNIX/a2xaPLi/c9PaSGfdaxhEUs2B6nV7OYbrAt
         nWnONxMnNVU4yloDJz8yaC7mJjbhSD2fk1CYDrz02rpBzmD7pveATAeGVjbItsHh8LMZ
         j+iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785164027; x=1785768827;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HBlnivitJQK60dpXDn/ZTN6OnP1/cWmlbn1S1eH9KWM=;
        b=GwGiZK/ZOftScNTm1CsGv55Gh6hspliTxNR6tE66MZ0yejEm67u+THxlO1heGKwvG9
         ASRL9kz7sBOdfeuUToV5NBZouKQi0yXKRY34anqPpShCOW4Ka+hGpbGJZKOe7zPySibI
         z4sJWoG7ZwIfDxHLqSEtVEI1tS5ecNPSwuTZE7vs0+0sbQzLEio5SntRxmPDs0H6P3Tq
         /uQ4ocQG+21csQbSn/wt4j4JTq4siwAsV8ASRpnUq8wD8uhPEn0qDSo4ot5xU4ZcB034
         +IdocMORfJ5nLn56BbWv3fBx7f+L1zJw3I5dX0Nkl5RU+VPB2EsUs6SSSi0v8EqnC179
         YLxQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp1sqUc+hFhh4ftCWNdG+kyT2rzeXoP3IH5P+QTbKClX8sO0CW4nqWQPjKJghRT5dxoMhcVPPAhXw==@kvack.org
X-Gm-Message-State: AOJu0YzOFgT/M4jpWINwAcaZG7u1kBOynzIVt+4wow+O3JD4gLK0Ttje
	THR8YqnYrEa9qEDU6Q2lCRUnydnkI8oaGMff1/RA38E5MvHx5ijYJ9h8ynqw2/gUI9ddN/pm8sj
	+eDKIKdoPxS6RGRvztmrz/xjb2Jbhe3ocEaacCM+C
X-Gm-Gg: AR+sD133PwBbma5J3P69thilxpYWrSZjigikmnVAGyl9xbsX33HRpPy9xhZDmFwSQoH
	Smm9vS54GNYXzN7ziGWkALi2CrrJP/J6XrC3CK5lCmjGaYauJNGYtShC+8A7UQMRJScJXZeuLkc
	InumqPi0XNgjr3lvYDt26O/a/6vr77KzqYO4Ec5OZVT3v84EaV7Z3qDf/9cYpnbkpr6I4z9iZ2s
	5ClP4Fk12KHQPdej+ZWG3tGruJzi/mLiVMtmIbimFVvus/wh1KSN35TqagByFKP0A7vAh0=
X-Received: by 2002:a05:622a:901c:b0:51c:ae6:a57 with SMTP id
 d75a77b69052e-529a76e10b3mr32723511cf.11.1785164026709; Mon, 27 Jul 2026
 07:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260724222934.1463812-1-riel@surriel.com> <20260724222934.1463812-3-riel@surriel.com>
In-Reply-To: <20260724222934.1463812-3-riel@surriel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Jul 2026 07:53:35 -0700
X-Gm-Features: AUfX_mxhZprgZ03CyQH1jdCYZ3TPLv3GAQLED7tTn-RB53lD8I6WJHAc-o4mA6w
Message-ID: <CAJuCfpF=S2F3iSu8AxQxoU8KVe=_1d63mjEcd==+u9wBjWqe5Q@mail.gmail.com>
Subject: Re: [PATCH RFC v4 02/12] riscv/mm: add untagged_addr_remote_unlocked()
To: Rik van Riel <riel@surriel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kernel-team@meta.com, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5159A80011
X-Stat-Signature: ibo6yfcgy44n8yepfucycodn4t5bgf45
X-Rspam-User: 
X-HE-Tag: 1785164028-167234
X-HE-Meta: U2FsdGVkX19xalurybgAp8f4WUhq2qhLDsYojKmQaWqeO/HDZUcAwg8pvGCDf83vhQcwAavS6uMO6NPMMLz47ih+qscWGNuAP/IMqn+hR/WirXa6qZRBC6/MHZsBasftYjdb84QdcLw94XoT8yy84yUJbo9o9VJmNcYThVKtum1vByHLEPX8WFX/3ExTwGt4ZrZvgLiETxwL5z6y8MW/FnaSVFHbQfURnEYFDX/ZsAIQJf6tHrza+okMy2FRkCyXmdUCsQTNxvxPyMnMIGgySD4Kud1p7z9L20/GyzoUm4K13a2h76l+nY2kBG499UmCiPy8iV/tPiJzN7S3IrFWfghJpCefWyIJ3dUcjWdtP9/+p7OYvkk+VV7fLNEtKX6wHM4OIymCHcX0l8oQjNPYee1FLlKbQVrh3xwHs1+XF5PmFYV1sFNpnbzOJWBMQAqxE0B7S1O1mgqGBRBnw7xMm8UOabXrHKynONZF3DncGks4eO1LFkP7a3vw31mBk4gV4oCFsP6QfWYM0dFUXPanVa3sZeeLtNEAmcjBCJASCXf8jMqQoD06ve664NUYrfpOn5QSN6uFGIwwLBexKq1Vr4P+S9VzKS9oFcM3JL8RstUahc+6r8V0jXe3ZlaQNon6TulTDOfV8GaiTPfA5PK+2LypNZeTkPSUQAPuyitT5VqnxJhZmo8WmYNQpNFsRKkrwo4ft89hRGwKwoxvNJyxs9G9k9jjCBOhqGIfYp9VHVDVA8XCUWql/32kQDYgIyy+JbOS9TsZQZ4d1a4/59NUMiGbY9qsQfOxdJjkIyDioy+Om8me4ysTvcoa1lFyt2CrPsJI2BEZr6UbbX3SrzuecQvBayFbdixewld4DVp7C1VdDr2XGcEIhIaHFH8Ojj7fdXIQMtbzFvej5HEWQPiJ9Q20RdEZf8hMtlIAmwms8mrl5c5Z8PHtm53TfY14Ek+/pfFNjOOCodtezDNA9ZL
 Qn+FFYDH
 0NJmLkzpOs7QIv3DdoDRbbP+QtaMWIUsv2VmVLhOVIe3qwpWhnD6/nqgvemsk4ZSAG8udh5CNV2FwvXTny58xQdLBccdKgZ66LcdKC3G1TThvMPEkMGW8WQhpHZtHp7AYWdY6AouuSrURPvSpaB227pzDcKV/R+2v7aDKpsWn46rtUbWkuNcVZHpUgrWnOBnt6/7+WPnWtEr6q4aXjMrmDrD3hCuNEBjLJZ4a7GsOmFeSLSqeWMWJsn/7AQFmHx//uCD7dwidsN07YJOi21XO7ueevkkPJV5y0r10vbHrzIeYOYEGchmR2moJMywLZLedGOq8bB8H/OCkbfQGJUFQcPdhD/N2wQ8YaYZqB9t000YOrVPcYqRvFi3Fmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 3:30=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> __access_remote_vm() reads another task's memory under the mmap lock. Tha=
t
> lock is contended on large multi-threaded workloads, where an mmap() or
> munmap() stalls readers like /proc/PID/cmdline or process_vm_readv() even
> though the target memory is resident and reachable under the per-VMA lock=
.
>
> Reaching it under the per-VMA lock means looking up the VMA first, which
> requires untagging the remote address without the mmap lock. riscv's
> untagged_addr_remote() asserts that lock and has no unlocked variant; the
> generic untagged_addr_remote_unlocked() falls back to untagged_addr(),
> which masks against current->mm, not the target mm.
>
> Add untagged_addr_remote_unlocked(), which masks @addr against the target
> mm without asserting the lock, and redefine untagged_addr_remote() on top
> of it so it keeps the assertion.
>
> The mask width is mm->context.pmlen, written while a program is single
> threaded, and frozen with MM_CONTEXT_LOCK_PMLEN once it spawns a second
> thread.
>
> That read need not be stable: pmlen is already read locklessly by
> untagged_addr() and mm_untag_mask(), and a remote untag is best-effort.
> Annotate the lockless reads with READ_ONCE() and the writes with
> WRITE_ONCE(), so a reader sees one whole value and the accesses are
> KCSAN-clean.
>
> Assisted-by: Claude:claude-opus-4.8
> Signed-off-by: Rik van Riel <riel@surriel.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  arch/riscv/include/asm/mmu_context.h |  4 ++--
>  arch/riscv/include/asm/uaccess.h     | 10 +++++++---
>  arch/riscv/kernel/process.c          | 12 +++++++-----
>  3 files changed, 16 insertions(+), 10 deletions(-)
>
> diff --git a/arch/riscv/include/asm/mmu_context.h b/arch/riscv/include/as=
m/mmu_context.h
> index dbf27a78df6c..3ce16796e5a2 100644
> --- a/arch/riscv/include/asm/mmu_context.h
> +++ b/arch/riscv/include/asm/mmu_context.h
> @@ -21,7 +21,7 @@ static inline void activate_mm(struct mm_struct *prev,
>                                struct mm_struct *next)
>  {
>  #ifdef CONFIG_RISCV_ISA_SUPM
> -       next->context.pmlen =3D 0;
> +       WRITE_ONCE(next->context.pmlen, 0);
>  #endif
>         switch_mm(prev, next, NULL);
>  }
> @@ -44,7 +44,7 @@ DECLARE_STATIC_KEY_FALSE(use_asid_allocator);
>  #define mm_untag_mask mm_untag_mask
>  static inline unsigned long mm_untag_mask(struct mm_struct *mm)
>  {
> -       return -1UL >> mm->context.pmlen;
> +       return -1UL >> READ_ONCE(mm->context.pmlen);
>  }
>  #endif
>
> diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/ua=
ccess.h
> index 5d4ec15584cf..53806e0f7dcf 100644
> --- a/arch/riscv/include/asm/uaccess.h
> +++ b/arch/riscv/include/asm/uaccess.h
> @@ -16,7 +16,7 @@
>  static inline unsigned long __untagged_addr_remote(struct mm_struct *mm,=
 unsigned long addr)
>  {
>         if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SUPM)) {
> -               u8 pmlen =3D mm->context.pmlen;
> +               u8 pmlen =3D READ_ONCE(mm->context.pmlen);
>
>                 /* Virtual addresses are sign-extended; physical addresse=
s are zero-extended. */
>                 if (IS_ENABLED(CONFIG_MMU))
> @@ -33,12 +33,16 @@ static inline unsigned long __untagged_addr_remote(st=
ruct mm_struct *mm, unsigne
>         (__force __typeof__(addr))__untagged_addr_remote(current->mm, __a=
ddr);  \
>  })
>
> -#define untagged_addr_remote(mm, addr) ({                               =
       \
> +#define untagged_addr_remote_unlocked(mm, addr) ({                      =
       \
>         unsigned long __addr =3D (__force unsigned long)(addr);          =
         \
> -       mmap_assert_locked(mm);                                          =
       \
>         (__force __typeof__(addr))__untagged_addr_remote(mm, __addr);    =
       \
>  })
>
> +#define untagged_addr_remote(mm, addr) ({                               =
       \
> +       mmap_assert_locked(mm);                                          =
       \
> +       untagged_addr_remote_unlocked(mm, addr);                         =
       \
> +})
> +
>  #define access_ok(addr, size) likely(__access_ok(untagged_addr(addr), si=
ze))
>  #else
>  #define untagged_addr(addr) (addr)
> diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
> index b2df7f72241a..6ae7552fed09 100644
> --- a/arch/riscv/kernel/process.c
> +++ b/arch/riscv/kernel/process.c
> @@ -357,13 +357,15 @@ long set_tagged_addr_ctrl(struct task_struct *task,=
 unsigned long arg)
>         if (mmap_write_lock_killable(mm))
>                 return -EINTR;
>
> -       if (test_bit(MM_CONTEXT_LOCK_PMLEN, &mm->context.flags) && mm->co=
ntext.pmlen !=3D pmlen) {
> -               mmap_write_unlock(mm);
> -               return -EBUSY;
> +       if (test_bit(MM_CONTEXT_LOCK_PMLEN, &mm->context.flags)) {
> +               if (READ_ONCE(mm->context.pmlen) !=3D pmlen) {
> +                       mmap_write_unlock(mm);
> +                       return -EBUSY;
> +               }
>         }
>
>         envcfg_update_bits(task, ENVCFG_PMM, pmm);
> -       mm->context.pmlen =3D pmlen;
> +       WRITE_ONCE(mm->context.pmlen, pmlen);
>
>         mmap_write_unlock(mm);
>
> @@ -394,7 +396,7 @@ long get_tagged_addr_ctrl(struct task_struct *task)
>                 break;
>         }
>
> -       if (task->mm->context.pmlen)
> +       if (READ_ONCE(task->mm->context.pmlen))
>                 ret |=3D PR_TAGGED_ADDR_ENABLE;
>
>         return ret;
> --
> 2.53.0-Meta
>
>

