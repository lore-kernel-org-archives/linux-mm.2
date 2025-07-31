Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A5FC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 15:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAC846B0088; Thu, 31 Jul 2025 11:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83756B0093; Thu, 31 Jul 2025 11:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72326B0096; Thu, 31 Jul 2025 11:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C477E6B0088
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:20:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B71F140683
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:20:52 +0000 (UTC)
X-FDA: 83724922344.15.74652FB
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id 86FD81A000B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:20:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0kkY6C35;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753975250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WXVgdNzaNf2ppZOAnb0Hf74PiGm255gpHJ61J8Ej/kI=;
	b=cu3yOc0KiUgrevCuI2nTTJi3JKPTAgfAQgC57KgmcMkcnFyKp1OkKK3XaQMSbDr/kc5PU0
	jfIHSmCqlCBJ9K21C0kOIb1qPTnnj+nHOCcyKLbuEsY6Ac6w/apUnsloJj8N26OGpra4Xw
	WpTZQkaVepI2fS7iv6P4WCahWuehrLY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0kkY6C35;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753975250; a=rsa-sha256;
	cv=none;
	b=p31Ag5Ld3UnqdInxZ3skvwDg/a+8H9xWF83ieHEA5lvcgubFt6kbMyEP0VGeXBhb8vvTe0
	c0uy200iBh5+/dY4S2sODjHYGDWIshYW81lIpSDpBJDfdT6YtE6z76UHb9aiywkB0g/SCt
	FQZbRUqlphmOqd1VhsJYQ9l1QR98+6U=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso435271cf.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753975250; x=1754580050; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WXVgdNzaNf2ppZOAnb0Hf74PiGm255gpHJ61J8Ej/kI=;
        b=0kkY6C357/UccvG74uNR3DypC5+flTwmVTPmgBXc/PCllW1qCTB93kzWVRlVaMFYwD
         nLEgPcvtf6bxkVrjeA/qQAwlc7evELRfPOMKuH5wCIjNVWczLjHd3Jzhzdkz7GeLx86m
         teeEhhoOkBq3I3GUWYG7qKVE0ttT5RGCne33xuFVF1XUGhYCBu5rFqcDja9z26IwxlIl
         ZFVpO1/JO4TzO/fAqOYQDFWkW3uM0ifF8mVnR79Wi0Bz517zbO896EVYB0rQVPKksUH3
         qClaLuFjEKJHGjqmNLTB/zdLMOnVNjtbqvyRe/ncs3Gb1T6/UnzL1+1iRkUwcB3gdHWo
         1yfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753975250; x=1754580050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WXVgdNzaNf2ppZOAnb0Hf74PiGm255gpHJ61J8Ej/kI=;
        b=ndZA+DexTUveaVuhct2rOSux5oPF6zWaD/X44liKgg5DcWalNw4X4pbtDYd1vqbz/S
         mJQmuW9xp0eh3oYMCwu91o2r9NfFs2rWhAez1tUQcJZ2PmDBlozv7uPSyw6TH70Dxjrr
         cCtKppp9oszJzEgmkZQfK+O4hrSPVONNG7UfZYqagBsIbybxGELBieIq3OuXQ2rabgi/
         U9BpLh+q3JtcRwPnPVzS3LRZtRjwHTX9AtYXqkfoFmqS15l9knhCDX3PNLJaAQoGwkpw
         SxnN2cjKhoMVOqLUiis8nkAs26uUnDTycoZ/q6V7zIRRsdIFRgiCH8vPOfQMGRkUwFkD
         kqgw==
X-Forwarded-Encrypted: i=1; AJvYcCXvKunpCyCe1Du8n84eo8UcsmizccNw5ZKqkHPmhM0tstqaRs74CiH2IY+DLrHr2/jiM42kkouLLQ==@kvack.org
X-Gm-Message-State: AOJu0YxEolkfB6BXC1EQGzE+pMpunjvl9SE4Q01IcB7FWscfMdI3bzkf
	FdxkeLR3m2UlcSZ4jncAB5rig7O+JAQ5aisdTQURRDNwpRgFCSj8Wv6TU0LsojDawla9Ut1ZKUA
	HyxbNFtnuvdzBn/8pfeoQbkgIkSfn1gWmO4+3YH91
X-Gm-Gg: ASbGncuWEDTqNk2LsrHVpupEsjQbxTNVwO/vC2lq6EVoMX4OiTW//dl2s1JPFYyosaP
	VvraRTGRWllHMPHuF78PM/BLI/BJYiQSE+7hov3U/jvCn2UcPFfEPsbQ41AwcZ5hib5OaBT5bOK
	1edeZkeyD6he9SyxypaO8Cp4QytHOuG1J3lHr8DP7KKnPKlqW8K0dEthbdfanUU+oBOZ+81in5C
	/hOuCZm79EawQjtQOqc2pPGbhpptyUKwRqJOg==
X-Google-Smtp-Source: AGHT+IFkHJ+uk6AmGEYAUc89bOxa9TpcABZ8Qd0G5R47W//bln6p9f0FhGBSRzH4gNy8qyLWXck/VYShbXNXSXFXwls=
X-Received: by 2002:a05:622a:13cd:b0:4ab:4088:7d97 with SMTP id
 d75a77b69052e-4aeeff8922bmr4072771cf.24.1753975249031; Thu, 31 Jul 2025
 08:20:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250731151919.212829-1-surenb@google.com>
In-Reply-To: <20250731151919.212829-1-surenb@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 31 Jul 2025 08:20:37 -0700
X-Gm-Features: Ac12FXytLxguJzhGbhRbOxMecFVRBKGK18J2j15debQV7RsZ7FbXW6Xatmguq8w
Message-ID: <CAJuCfpHghvnWWvF6JN+DHbD8Vv7zPVC0BZcTmW6HcrWrxo=KWw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: limit the scope of vma_start_read()
To: akpm@linux-foundation.org
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	vbabka@suse.cz, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a8xgk8qt7sh8rtrkztfi8tmfi3aahcta
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 86FD81A000B
X-Rspam-User: 
X-HE-Tag: 1753975250-921771
X-HE-Meta: U2FsdGVkX1+oY0sMMncw57B2RWswLYyJKyHpVeYrxFKfpw7eBg0KWAxbA7sMYm+s7EhMRgwAh7PN/qwA5JGR+yapgWkIWX2WjvwGp6C+0D7u8fNMGXWMRkOTtCmcfV3rxBUYdcaHCbm2iG+f5dLHI2kr+TxWh0Cf1Iph995MjoAzC45qMHVc9oAezRT3UlWcvQirOaqKAYE82TrRNelUldDPD/37MHjbjEyYk7sz2aDZd2ShMcEFBeofMHSOQno9AuktHKuIpOoJNgEZHF22Nu2XiuKhPme7UXP2zc5zBO55nqVuQWofXxtcHJfN4olkxgmtyo/U2REnyW22tHmrenuCVQZ8VFJyU+2Yd4ji+zDSgrxy+rFCwa4OYxvxNBXL+n/+nNqVvhV2sp/vC03i6VBlmHZZQfgLXf76KnG7xKJB7QfYOWnuWdTDxtlcN5pQ57aG+v1X1Rak8YLAPcm8PwqtaziIMhUiEepJHcLFQRdmyRhEWo3OWD2FCTh4SpOY2OqvP7Spt2xCRklp+/yqgvI0cwNiKiVSbhxXJpm35ZHsRDoMG1REhm98okjcQaZuMooEayahozCEOOZGbHsN9y6qfX7db8VBokVSdd4Y2rzTGHTY/TwdF0N02TMNe0VmyWbyLmnp7O/gq9pH74soHcU1p9JGKjIJ+YHmNOVfXFMpOlsj5cPDk/BoUH3+tbDt9TASKfQCrAAPzdlGcxglyGZ9EpIAttB0duL4lXmBbMKOT88F4Lcc8yjHgZqNCbWCpJ/pPM6nfkAjYBY3C9DXsiHRx1gkRGBTUgF62D2/LiXfNp3TEq9uzTEhFXrQTnzh4e1uLkVTWM2CZPIYKK35Ho9PJ7HLeqqaFIK8t7PfcaENkYGLzCZjHcHXstck8+/BRgQus9ZyE2R5qFsMKufEPAZMRmW6kWqoutmbZ8xE9pexHCI5IwAZUfm8KGLytlP2uj240jlnOm4l60+ZF6Y
 rNWTiZM1
 F6fYHPPICw39HvJ3wxBcASfYa4jG9Nffo/YH00YxB2ULbPy9jSB+SXIMhy6s+MoXZa2KHm95q8P/tOsCjGzLRkNGDLG012zIacOgSefNNHpxlRq+ILwayfaJQHDK0SYZ6njpoUs35vnLMKAYP9tm5R1+dnBYF2+cBf6sd0+8ZsGzcK/DRq/zsT8QdSo/PDJq+liBZtCh0U0eKKJqs4GP9aorcjfLUVaCv8ALRh+Mzr3eaxsSQAXpC4Stze4w6PBw6oKJ9Z6g5BO58eKUqo+OaGLg0hhULg5K9Mb6a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 8:19=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> Limit the scope of vma_start_read() as it is used only as a helper for
> higher-level locking functions implemented inside mmap_lock.c and we are
> about to introduce more complex RCU rules for this function.
> The change is pure code refactoring and has no functional changes.
>
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Forgot to add Lorenzo's

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks!

> ---
>  include/linux/mmap_lock.h | 85 ---------------------------------------
>  mm/mmap_lock.c            | 85 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 85 insertions(+), 85 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 11a078de9150..2c9fffa58714 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -147,91 +147,6 @@ static inline void vma_refcount_put(struct vm_area_s=
truct *vma)
>         }
>  }
>
> -/*
> - * Try to read-lock a vma. The function is allowed to occasionally yield=
 false
> - * locked result to avoid performance overhead, in which case we fall ba=
ck to
> - * using mmap_lock. The function should never yield false unlocked resul=
t.
> - * False locked result is possible if mm_lock_seq overflows or if vma ge=
ts
> - * reused and attached to a different mm before we lock it.
> - * Returns the vma on success, NULL on failure to lock and EAGAIN if vma=
 got
> - * detached.
> - *
> - * WARNING! The vma passed to this function cannot be used if the functi=
on
> - * fails to lock it because in certain cases RCU lock is dropped and the=
n
> - * reacquired. Once RCU lock is dropped the vma can be concurently freed=
.
> - */
> -static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm=
,
> -                                                   struct vm_area_struct=
 *vma)
> -{
> -       int oldcnt;
> -
> -       /*
> -        * Check before locking. A race might cause false locked result.
> -        * We can use READ_ONCE() for the mm_lock_seq here, and don't nee=
d
> -        * ACQUIRE semantics, because this is just a lockless check whose=
 result
> -        * we don't rely on for anything - the mm_lock_seq read against w=
hich we
> -        * need ordering is below.
> -        */
> -       if (READ_ONCE(vma->vm_lock_seq) =3D=3D READ_ONCE(mm->mm_lock_seq.=
sequence))
> -               return NULL;
> -
> -       /*
> -        * If VMA_LOCK_OFFSET is set, __refcount_inc_not_zero_limited_acq=
uire()
> -        * will fail because VMA_REF_LIMIT is less than VMA_LOCK_OFFSET.
> -        * Acquire fence is required here to avoid reordering against lat=
er
> -        * vm_lock_seq check and checks inside lock_vma_under_rcu().
> -        */
> -       if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_re=
fcnt, &oldcnt,
> -                                                             VMA_REF_LIM=
IT))) {
> -               /* return EAGAIN if vma got detached from under us */
> -               return oldcnt ? NULL : ERR_PTR(-EAGAIN);
> -       }
> -
> -       rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> -
> -       /*
> -        * If vma got attached to another mm from under us, that mm is no=
t
> -        * stable and can be freed in the narrow window after vma->vm_ref=
cnt
> -        * is dropped and before rcuwait_wake_up(mm) is called. Grab it b=
efore
> -        * releasing vma->vm_refcnt.
> -        */
> -       if (unlikely(vma->vm_mm !=3D mm)) {
> -               /* Use a copy of vm_mm in case vma is freed after we drop=
 vm_refcnt */
> -               struct mm_struct *other_mm =3D vma->vm_mm;
> -
> -               /*
> -                * __mmdrop() is a heavy operation and we don't need RCU
> -                * protection here. Release RCU lock during these operati=
ons.
> -                * We reinstate the RCU read lock as the caller expects i=
t to
> -                * be held when this function returns even on error.
> -                */
> -               rcu_read_unlock();
> -               mmgrab(other_mm);
> -               vma_refcount_put(vma);
> -               mmdrop(other_mm);
> -               rcu_read_lock();
> -               return NULL;
> -       }
> -
> -       /*
> -        * Overflow of vm_lock_seq/mm_lock_seq might produce false locked=
 result.
> -        * False unlocked result is impossible because we modify and chec=
k
> -        * vma->vm_lock_seq under vma->vm_refcnt protection and mm->mm_lo=
ck_seq
> -        * modification invalidates all existing locks.
> -        *
> -        * We must use ACQUIRE semantics for the mm_lock_seq so that if w=
e are
> -        * racing with vma_end_write_all(), we only start reading from th=
e VMA
> -        * after it has been unlocked.
> -        * This pairs with RELEASE semantics in vma_end_write_all().
> -        */
> -       if (unlikely(vma->vm_lock_seq =3D=3D raw_read_seqcount(&mm->mm_lo=
ck_seq))) {
> -               vma_refcount_put(vma);
> -               return NULL;
> -       }
> -
> -       return vma;
> -}
> -
>  /*
>   * Use only while holding mmap read lock which guarantees that locking w=
ill not
>   * fail (nobody can concurrently write-lock the vma). vma_start_read() s=
hould
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index b006cec8e6fe..10826f347a9f 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -127,6 +127,91 @@ void vma_mark_detached(struct vm_area_struct *vma)
>         }
>  }
>
> +/*
> + * Try to read-lock a vma. The function is allowed to occasionally yield=
 false
> + * locked result to avoid performance overhead, in which case we fall ba=
ck to
> + * using mmap_lock. The function should never yield false unlocked resul=
t.
> + * False locked result is possible if mm_lock_seq overflows or if vma ge=
ts
> + * reused and attached to a different mm before we lock it.
> + * Returns the vma on success, NULL on failure to lock and EAGAIN if vma=
 got
> + * detached.
> + *
> + * WARNING! The vma passed to this function cannot be used if the functi=
on
> + * fails to lock it because in certain cases RCU lock is dropped and the=
n
> + * reacquired. Once RCU lock is dropped the vma can be concurently freed=
.
> + */
> +static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm=
,
> +                                                   struct vm_area_struct=
 *vma)
> +{
> +       int oldcnt;
> +
> +       /*
> +        * Check before locking. A race might cause false locked result.
> +        * We can use READ_ONCE() for the mm_lock_seq here, and don't nee=
d
> +        * ACQUIRE semantics, because this is just a lockless check whose=
 result
> +        * we don't rely on for anything - the mm_lock_seq read against w=
hich we
> +        * need ordering is below.
> +        */
> +       if (READ_ONCE(vma->vm_lock_seq) =3D=3D READ_ONCE(mm->mm_lock_seq.=
sequence))
> +               return NULL;
> +
> +       /*
> +        * If VMA_LOCK_OFFSET is set, __refcount_inc_not_zero_limited_acq=
uire()
> +        * will fail because VMA_REF_LIMIT is less than VMA_LOCK_OFFSET.
> +        * Acquire fence is required here to avoid reordering against lat=
er
> +        * vm_lock_seq check and checks inside lock_vma_under_rcu().
> +        */
> +       if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_re=
fcnt, &oldcnt,
> +                                                             VMA_REF_LIM=
IT))) {
> +               /* return EAGAIN if vma got detached from under us */
> +               return oldcnt ? NULL : ERR_PTR(-EAGAIN);
> +       }
> +
> +       rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> +
> +       /*
> +        * If vma got attached to another mm from under us, that mm is no=
t
> +        * stable and can be freed in the narrow window after vma->vm_ref=
cnt
> +        * is dropped and before rcuwait_wake_up(mm) is called. Grab it b=
efore
> +        * releasing vma->vm_refcnt.
> +        */
> +       if (unlikely(vma->vm_mm !=3D mm)) {
> +               /* Use a copy of vm_mm in case vma is freed after we drop=
 vm_refcnt */
> +               struct mm_struct *other_mm =3D vma->vm_mm;
> +
> +               /*
> +                * __mmdrop() is a heavy operation and we don't need RCU
> +                * protection here. Release RCU lock during these operati=
ons.
> +                * We reinstate the RCU read lock as the caller expects i=
t to
> +                * be held when this function returns even on error.
> +                */
> +               rcu_read_unlock();
> +               mmgrab(other_mm);
> +               vma_refcount_put(vma);
> +               mmdrop(other_mm);
> +               rcu_read_lock();
> +               return NULL;
> +       }
> +
> +       /*
> +        * Overflow of vm_lock_seq/mm_lock_seq might produce false locked=
 result.
> +        * False unlocked result is impossible because we modify and chec=
k
> +        * vma->vm_lock_seq under vma->vm_refcnt protection and mm->mm_lo=
ck_seq
> +        * modification invalidates all existing locks.
> +        *
> +        * We must use ACQUIRE semantics for the mm_lock_seq so that if w=
e are
> +        * racing with vma_end_write_all(), we only start reading from th=
e VMA
> +        * after it has been unlocked.
> +        * This pairs with RELEASE semantics in vma_end_write_all().
> +        */
> +       if (unlikely(vma->vm_lock_seq =3D=3D raw_read_seqcount(&mm->mm_lo=
ck_seq))) {
> +               vma_refcount_put(vma);
> +               return NULL;
> +       }
> +
> +       return vma;
> +}
> +
>  /*
>   * Lookup and lock a VMA under RCU protection. Returned VMA is guarantee=
d to be
>   * stable and not isolated. If the VMA is not found or is being modified=
 the
>
> base-commit: 01da54f10fddf3b01c5a3b80f6b16bbad390c302
> --
> 2.50.1.552.g942d659e1b-goog
>

