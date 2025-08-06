Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751ACC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 18:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16E418E000E; Wed,  6 Aug 2025 14:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1464B8E0002; Wed,  6 Aug 2025 14:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05BFD8E000E; Wed,  6 Aug 2025 14:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC2EE8E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:43:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51004BA421
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:43:29 +0000 (UTC)
X-FDA: 83747205738.23.867E358
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6574D1C0008
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:43:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="lFnrR6+/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754505807; a=rsa-sha256;
	cv=none;
	b=gJbFnASNtxGezZCpERek48Z1vJvmMjmEXKQCuybVTyNXCd8s7hNmR+39gbeaNf+nfCIe5C
	CLsb/JEvI63aTTzv1bZ2Khi7M+KPFhiYK/sGBZO+zjm5O8f37iifg06jcmMGahL5uFlSYe
	MAd/lmF4URuHqjAIy0JsbIqqmkc5vLA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="lFnrR6+/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754505807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXVMjl2ENwPs+sngCAI8ptho3dmgSlq6SfHqbvBpUp0=;
	b=D2l0fi6zj579sYXttR3KTGNUcHFl04RDRbpgfgUnDXvWmeo6QyOgllH7pl9NAiB5/PhGiL
	Nb35QDdgdO0/VqH2GvLNoy6+euveQHjHryE2wmYBdvu64UcVftsQ5DN2ejxyg9WT49OMj5
	Dw+PNcxSXC9iukKlkqQ+maxtnlnFKgU=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b099118fedso72251cf.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 11:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754505806; x=1755110606; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hXVMjl2ENwPs+sngCAI8ptho3dmgSlq6SfHqbvBpUp0=;
        b=lFnrR6+/6TbD5r0/B98KV5SILqNMtesKH+Vls0sVbX5evzqeFQpRF7NaPbQvYG7/s/
         SVc7PLp2LuYDiDFhipfd/p9g6yQp/ljQ0XUVi6oi27/1pRCft1cxqwOv3V+N6KgrBtbx
         9KUvc/sMmEgiIiWb8OuuOK0a5B5qAkAeghlDwnjIZzjYslNwfdjQN/OYy5nf/Z44kpwd
         JTBbYFPt2UUz3YUS8NqFt2AhpTimGnuDXhmRxhMuL0Z3U9hpNOKVtji3wcPBnltLVkAm
         LAlbyjnnxcRuRdIvkYQDhFXRTP7qanG0X0Psrz8K1hRrnLl30DLam6MQ4C/PEr8+9+AX
         wsUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754505806; x=1755110606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hXVMjl2ENwPs+sngCAI8ptho3dmgSlq6SfHqbvBpUp0=;
        b=dFsUE7PrhakQpEzqInFU/Qm5eIUNaX9Xp5QFytRsoNvgTVtbLun8Q3BEx+lh0B3KQX
         8ZqrNTON2s6tE9g+g+W7Npx1x7O8NSjAb2xpFI42QZfb/xJkJAwHnUIZV+WdQTcSXs4w
         6k5Ws61TvPCcYSB6cuNd5KsTZJYCizwZFyYIzPcw1ndov2Ul/4g+gY3x+eCk7NskAH4Y
         g+7nOe+zwYxdJP4xD5rwILGjQeRph3daT2skbO9bBh089OgaNrw6xuXPF5pbgAThUa82
         8pK5sUuzuIYasUB4+Mb53Jy0VJrieAwH6y7BxTbpcADEjSUPc0H5WBAUIZQbIiUNnqtS
         KfZA==
X-Forwarded-Encrypted: i=1; AJvYcCUldIPcKRlLZ3/LLgB0+sP/+jrmzw7iPsbdbKRnL7XYjiDuZ2Ml3Sa3diEtKf0kk+L02JUSYKY4fg==@kvack.org
X-Gm-Message-State: AOJu0YzZsIqQFbmRhVOWDMGp15C2BPhxrZLG7ZJbfiIrqxGP+JmZxMIJ
	/+24Y1SR3pn5Emy5k//96GITZTiY8nDEHild4HlOstd7cgbM+KacjOupBHqFfl3DLuUSdnsvtMh
	qt2II+CqY3ofSqKTL2DBM1AL6hRV0uPicB9COto0g
X-Gm-Gg: ASbGncteLCRw5sbX/dGasRgB+A0ICCkbqhVpoKx/M3DBD0sybt4anzW1T7UfY2ZnvQZ
	q1oVPrlqPqXpatSCUVX1PvsaUamMYDSwqyOPjpWavnc8RipbuHM+eeTtlq0sVC+keD+/GxkJd48
	0ERNrH493IQrC04ggdkS0fU3MfWvstE9qHhU2RHMbRYyUUGpeFdXlM3MFO3PpyCQJ96qDWPpp5F
	4Cwi+u17ebHWI9ThfheFflYBvE3ztpahZMvvA==
X-Google-Smtp-Source: AGHT+IH/vu3AEPEMg1lWhWr6c5i1Hk7l+MHr3ajLJbommv99ZScZpBMyjMSwyw60o5voAFBY5O9vUyZH8Zz3a0jPmgA=
X-Received: by 2002:a05:622a:646:b0:4b0:85d7:b884 with SMTP id
 d75a77b69052e-4b0a1f66a26mr272861cf.21.1754505805730; Wed, 06 Aug 2025
 11:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250806155905.824388-1-surenb@google.com> <20250806155905.824388-3-surenb@google.com>
 <01bedec6-53f8-4c1c-9c47-c943ca0f7b4b@lucifer.local>
In-Reply-To: <01bedec6-53f8-4c1c-9c47-c943ca0f7b4b@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 6 Aug 2025 11:43:14 -0700
X-Gm-Features: Ac12FXyS4v5I4rD9FZQ1-uYMFEt8OMTd5btwqy6XpYscekLqviMpnC9QC0UOhos
Message-ID: <CAJuCfpGf6w5-Hxg8tb_3H+2m0JR_3NutLjd=nmN0X=cJyTz+yg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] fs/proc/task_mmu: factor out proc_maps_private
 fields used by PROCMAP_QUERY
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, david@redhat.com, 
	vbabka@suse.cz, peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com, 
	brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com, 
	linux@weissschuh.net, willy@infradead.org, osalvador@suse.de, 
	andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu, 
	tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6574D1C0008
X-Stat-Signature: izytnwdz9q8xfxqhcgi3coqkz6w3eso5
X-Rspam-User: 
X-HE-Tag: 1754505807-2306
X-HE-Meta: U2FsdGVkX1/S+svj3ak8O2amwVMLHMXARnC+ZwdY+QrH1t/idZzfYLeMfk8xmBnCLK5zkuQ3l4bt1xP3NGGwXYHqCDhcRbkq3vZ1HOEuyt0fWo7czGsm/hA+0jIDzbg3sEWos3O3cV7GDkvR07vFuR8U9gUaX19Sl3JNS0g0MDLMz9zcDboUSN8sDXpBn0kKqgea7OMkb1OwzzDamGkSZU2HtYxAnHdQeqi5Gx1JFUfBygwRip30MOa+RCvRMaVzXoCl6ACKHWpOmAofGKmnwky/rGrFvQoJCPpDNWqF8o+OagfT9pTFn/4UK7wRkJqNCk3caIllsBMPReKWHFR1qba16ji01PnSKpMKFm1tyhJdGI6ZuM5SXLc2Ew5X8a+Ax6OLv+e4q0fLKYvoZ55+Nr/Y/VphefpsNx5CpzjKvZ1YO2P8EwlBZKVPHq+W27TGVSK1fwjuf+Tpn8Z/ysPPs7n+Lx2LpFGRSReZ8bQGCIWEakzLw7Y7AHEpb+0MJtCUGtx6pnXMaCfPwKNq0ZIsidum/xvSOCXU9vw0SKkgXd+Bb0TeXtJljx0Yl+YwLs/2AztRs2BpuwOV0nn2IG0JIYLbhymY0b8OU78FXDBjG3qtZYFSITcROF/RI4WIK81jISAauOwfUCuLNahzDSj3Z9CyS3LXNsvfIi2b8dX2UDLTYSLY9uMRebZeWPNiAW7hvG1xIOY0SzlCQYs8H+pkIocPdgxRequopv5Upv8l54VhZjFCM1yU0xFgat2QILyJLbhgvAR1stQKeGRhVKgdjfbJp7INInE7Z9fCnVpFccilzv7UbaAxTw/AW/FWoqOHiilk/qu8/MOaxpWWbhVJOXe9fh5+JnCk1rlPY9zHSCBAIobWVswZigZU28AmsnK4YEwd7qmwA9sJHGknUjpVxFaCLFjbd1dKNL2NLANockCX9mEDLhtM6+xKr6Mh4C7XJEGUovn0wk1Qrr/r+ZZ
 MZRD1t5b
 urpoDUV0QjMPFXhsUX0W6fFO7BvrPIHFhjniOuyUuQZ0I/FzZrGi9O1RKh1wu8p9hfNR4QLAYMFzN0KkakOFVIq8LzdSyC87N6sq5W8AysBis2jOquQakcRnvGMM82CyWxZ2O/xkSjbvuWg0bGgH6oI6iEcdFtF9dlRmyAMcgMfVp2+dOiFoXdIAD2qFBgT28Ew4t1uBAQmsXbJXU9DlNiT36mGMTPYwkeVtqfpKOfuZ8nUMWxRATFHjj81IAwoAe8ZR2hBWhS4H50wFA5EtIoWMvqoInMpk2w4n93sUDyhRSxzUTinpgfELMP9irGT1ZjlcburG3UgxRmG4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 11:04=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Aug 06, 2025 at 08:59:03AM -0700, Suren Baghdasaryan wrote:
> > Refactor struct proc_maps_private so that the fields used by PROCMAP_QU=
ERY
> > ioctl are moved into a separate structure. In the next patch this allow=
s
> > ioctl to reuse some of the functions used for reading /proc/pid/maps
> > without using file->private_data. This prevents concurrent modification
> > of file->private_data members by ioctl and /proc/pid/maps readers.
> >
> > The change is pure code refactoring and has no functional changes.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> > ---
> >  fs/proc/internal.h   | 15 ++++++----
> >  fs/proc/task_mmu.c   | 70 ++++++++++++++++++++++----------------------
> >  fs/proc/task_nommu.c | 14 ++++-----
> >  3 files changed, 52 insertions(+), 47 deletions(-)
> >
> > diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> > index e737401d7383..d1598576506c 100644
> > --- a/fs/proc/internal.h
> > +++ b/fs/proc/internal.h
> > @@ -378,16 +378,21 @@ extern void proc_self_init(void);
> >   * task_[no]mmu.c
> >   */
> >  struct mem_size_stats;
> > -struct proc_maps_private {
> > -     struct inode *inode;
> > -     struct task_struct *task;
> > +
> > +struct proc_maps_locking_ctx {
>
> Decent name :)
>
> >       struct mm_struct *mm;
> > -     struct vma_iterator iter;
> > -     loff_t last_pos;
> >  #ifdef CONFIG_PER_VMA_LOCK
> >       bool mmap_locked;
> >       struct vm_area_struct *locked_vma;
> >  #endif
> > +};
> > +
> > +struct proc_maps_private {
> > +     struct inode *inode;
> > +     struct task_struct *task;
> > +     struct vma_iterator iter;
> > +     loff_t last_pos;
> > +     struct proc_maps_locking_ctx lock_ctx;
> >  #ifdef CONFIG_NUMA
> >       struct mempolicy *task_mempolicy;
> >  #endif
>
> I was going to ask why we have these in internal.h, but then noticed we h=
ave to
> have a nommu version of the task_mmu stuff for museum pieces and
> why-do-they-exist arches, sigh.
>
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index ee1e4ccd33bd..45134335e086 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -132,11 +132,11 @@ static void release_task_mempolicy(struct proc_ma=
ps_private *priv)
> >
> >  #ifdef CONFIG_PER_VMA_LOCK
> >
> > -static void unlock_vma(struct proc_maps_private *priv)
> > +static void unlock_vma(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> > -     if (priv->locked_vma) {
> > -             vma_end_read(priv->locked_vma);
> > -             priv->locked_vma =3D NULL;
> > +     if (lock_ctx->locked_vma) {
> > +             vma_end_read(lock_ctx->locked_vma);
> > +             lock_ctx->locked_vma =3D NULL;
> >       }
> >  }
> >
> > @@ -151,14 +151,14 @@ static inline bool lock_vma_range(struct seq_file=
 *m,
> >        * walking the vma tree under rcu read protection.
> >        */
> >       if (m->op !=3D &proc_pid_maps_op) {
> > -             if (mmap_read_lock_killable(priv->mm))
> > +             if (mmap_read_lock_killable(priv->lock_ctx.mm))
> >                       return false;
> >
> > -             priv->mmap_locked =3D true;
> > +             priv->lock_ctx.mmap_locked =3D true;
> >       } else {
> >               rcu_read_lock();
> > -             priv->locked_vma =3D NULL;
> > -             priv->mmap_locked =3D false;
> > +             priv->lock_ctx.locked_vma =3D NULL;
> > +             priv->lock_ctx.mmap_locked =3D false;
> >       }
> >
> >       return true;
> > @@ -166,10 +166,10 @@ static inline bool lock_vma_range(struct seq_file=
 *m,
> >
> >  static inline void unlock_vma_range(struct proc_maps_private *priv)
> >  {
>
> Not sure why we have unlock_vma() parameterised by proc_maps_locking_ctx =
but
> this is parameerised by proc_maps_private?
>
> Seems more consistent to have both parameterised by proc_maps_locking_ctx=
.

True, we can pass just proc_maps_locking_ctx to both lock_vma_range()
and unlock_vma_range(). Will update.

>
> Maybe we'd want lock() forms this way too for consistency?
>
> > -     if (priv->mmap_locked) {
> > -             mmap_read_unlock(priv->mm);
> > +     if (priv->lock_ctx.mmap_locked) {
> > +             mmap_read_unlock(priv->lock_ctx.mm);
> >       } else {
> > -             unlock_vma(priv);
> > +             unlock_vma(&priv->lock_ctx);
> >               rcu_read_unlock();
> >       }
> >  }
> > @@ -179,13 +179,13 @@ static struct vm_area_struct *get_next_vma(struct=
 proc_maps_private *priv,
> >  {
> >       struct vm_area_struct *vma;
> >
>
> We reference priv->lock_ctx 3 times here, either extract as helper var or=
 pass
> in direct perhaps?
>
> > -     if (priv->mmap_locked)
> > +     if (priv->lock_ctx.mmap_locked)
> >               return vma_next(&priv->iter);
> >
> > -     unlock_vma(priv);
> > -     vma =3D lock_next_vma(priv->mm, &priv->iter, last_pos);
> > +     unlock_vma(&priv->lock_ctx);
> > +     vma =3D lock_next_vma(priv->lock_ctx.mm, &priv->iter, last_pos);
> >       if (!IS_ERR_OR_NULL(vma))
> > -             priv->locked_vma =3D vma;
> > +             priv->lock_ctx.locked_vma =3D vma;
> >
> >       return vma;
> >  }
> > @@ -193,14 +193,14 @@ static struct vm_area_struct *get_next_vma(struct=
 proc_maps_private *priv,
> >  static inline bool fallback_to_mmap_lock(struct proc_maps_private *pri=
v,
> >                                        loff_t pos)
> >  {
>
> (Also)
>
> We reference priv->lock_ctx 3 times here, either extract as helper var or=
 pass
> in direct perhaps?
>
> > -     if (priv->mmap_locked)
> > +     if (priv->lock_ctx.mmap_locked)
> >               return false;
> >
> >       rcu_read_unlock();
> > -     mmap_read_lock(priv->mm);
> > +     mmap_read_lock(priv->lock_ctx.mm);
> >       /* Reinitialize the iterator after taking mmap_lock */
> >       vma_iter_set(&priv->iter, pos);
> > -     priv->mmap_locked =3D true;
> > +     priv->lock_ctx.mmap_locked =3D true;
> >
> >       return true;
> >  }
> > @@ -210,12 +210,12 @@ static inline bool fallback_to_mmap_lock(struct p=
roc_maps_private *priv,
> >  static inline bool lock_vma_range(struct seq_file *m,
> >                                 struct proc_maps_private *priv)
> >  {
> > -     return mmap_read_lock_killable(priv->mm) =3D=3D 0;
> > +     return mmap_read_lock_killable(priv->lock_ctx.mm) =3D=3D 0;
> >  }
> >
> >  static inline void unlock_vma_range(struct proc_maps_private *priv)
> >  {
> > -     mmap_read_unlock(priv->mm);
> > +     mmap_read_unlock(priv->lock_ctx.mm);
> >  }
> >
> >  static struct vm_area_struct *get_next_vma(struct proc_maps_private *p=
riv,
> > @@ -258,7 +258,7 @@ static struct vm_area_struct *proc_get_vma(struct s=
eq_file *m, loff_t *ppos)
> >               *ppos =3D vma->vm_end;
> >       } else {
> >               *ppos =3D SENTINEL_VMA_GATE;
> > -             vma =3D get_gate_vma(priv->mm);
> > +             vma =3D get_gate_vma(priv->lock_ctx.mm);
> >       }
> >
> >       return vma;
> > @@ -278,7 +278,7 @@ static void *m_start(struct seq_file *m, loff_t *pp=
os)
> >       if (!priv->task)
> >               return ERR_PTR(-ESRCH);
> >
> > -     mm =3D priv->mm;
> > +     mm =3D priv->lock_ctx.mm;
> >       if (!mm || !mmget_not_zero(mm)) {
> >               put_task_struct(priv->task);
> >               priv->task =3D NULL;
> > @@ -318,7 +318,7 @@ static void *m_next(struct seq_file *m, void *v, lo=
ff_t *ppos)
> >  static void m_stop(struct seq_file *m, void *v)
> >  {
> >       struct proc_maps_private *priv =3D m->private;
> > -     struct mm_struct *mm =3D priv->mm;
> > +     struct mm_struct *mm =3D priv->lock_ctx.mm;
> >
> >       if (!priv->task)
> >               return;
> > @@ -339,9 +339,9 @@ static int proc_maps_open(struct inode *inode, stru=
ct file *file,
> >               return -ENOMEM;
> >
> >       priv->inode =3D inode;
> > -     priv->mm =3D proc_mem_open(inode, PTRACE_MODE_READ);
> > -     if (IS_ERR_OR_NULL(priv->mm)) {
> > -             int err =3D priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> > +     priv->lock_ctx.mm =3D proc_mem_open(inode, PTRACE_MODE_READ);
> > +     if (IS_ERR_OR_NULL(priv->lock_ctx.mm)) {
> > +             int err =3D priv->lock_ctx.mm ? PTR_ERR(priv->lock_ctx.mm=
) : -ESRCH;
> >
> >               seq_release_private(inode, file);
> >               return err;
> > @@ -355,8 +355,8 @@ static int proc_map_release(struct inode *inode, st=
ruct file *file)
> >       struct seq_file *seq =3D file->private_data;
> >       struct proc_maps_private *priv =3D seq->private;
> >
> > -     if (priv->mm)
> > -             mmdrop(priv->mm);
> > +     if (priv->lock_ctx.mm)
> > +             mmdrop(priv->lock_ctx.mm);
> >
> >       return seq_release_private(inode, file);
> >  }
> > @@ -610,7 +610,7 @@ static int do_procmap_query(struct proc_maps_privat=
e *priv, void __user *uarg)
> >       if (!!karg.build_id_size !=3D !!karg.build_id_addr)
> >               return -EINVAL;
> >
> > -     mm =3D priv->mm;
> > +     mm =3D priv->lock_ctx.mm;
> >       if (!mm || !mmget_not_zero(mm))
> >               return -ESRCH;
> >
> > @@ -1311,7 +1311,7 @@ static int show_smaps_rollup(struct seq_file *m, =
void *v)
> >  {
> >       struct proc_maps_private *priv =3D m->private;
> >       struct mem_size_stats mss =3D {};
> > -     struct mm_struct *mm =3D priv->mm;
> > +     struct mm_struct *mm =3D priv->lock_ctx.mm;
>
> Nit, but maybe add a
>
>         struct proc_maps_locking_ctx *lock_ctx =3D priv->lock_ctx;
>
> Here to reduce 'priv->lock_ctx' stuff?

Yep, will do that in all the places. Thanks!

>
> >       struct vm_area_struct *vma;
> >       unsigned long vma_start =3D 0, last_vma_end =3D 0;
> >       int ret =3D 0;
> > @@ -1456,9 +1456,9 @@ static int smaps_rollup_open(struct inode *inode,=
 struct file *file)
> >               goto out_free;
> >
> >       priv->inode =3D inode;
> > -     priv->mm =3D proc_mem_open(inode, PTRACE_MODE_READ);
> > -     if (IS_ERR_OR_NULL(priv->mm)) {
> > -             ret =3D priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> > +     priv->lock_ctx.mm =3D proc_mem_open(inode, PTRACE_MODE_READ);
> > +     if (IS_ERR_OR_NULL(priv->lock_ctx.mm)) {
> > +             ret =3D priv->lock_ctx.mm ? PTR_ERR(priv->lock_ctx.mm) : =
-ESRCH;
> >
> >               single_release(inode, file);
> >               goto out_free;
> > @@ -1476,8 +1476,8 @@ static int smaps_rollup_release(struct inode *ino=
de, struct file *file)
> >       struct seq_file *seq =3D file->private_data;
> >       struct proc_maps_private *priv =3D seq->private;
> >
> > -     if (priv->mm)
> > -             mmdrop(priv->mm);
> > +     if (priv->lock_ctx.mm)
> > +             mmdrop(priv->lock_ctx.mm);
> >
> >       kfree(priv);
> >       return single_release(inode, file);
> > diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
> > index 59bfd61d653a..d362919f4f68 100644
> > --- a/fs/proc/task_nommu.c
> > +++ b/fs/proc/task_nommu.c
> > @@ -204,7 +204,7 @@ static void *m_start(struct seq_file *m, loff_t *pp=
os)
> >       if (!priv->task)
> >               return ERR_PTR(-ESRCH);
> >
> > -     mm =3D priv->mm;
> > +     mm =3D priv->lock_ctx.mm;
> >       if (!mm || !mmget_not_zero(mm)) {
> >               put_task_struct(priv->task);
> >               priv->task =3D NULL;
> > @@ -226,7 +226,7 @@ static void *m_start(struct seq_file *m, loff_t *pp=
os)
> >  static void m_stop(struct seq_file *m, void *v)
> >  {
> >       struct proc_maps_private *priv =3D m->private;
> > -     struct mm_struct *mm =3D priv->mm;
>
> (same as above, I reviewed this upsidedown :P)
>
> NIT, but seems sensible to have a
>
>         struct proc_maps_locking_ctx *lock_ctx =3D priv->lock_ctx;
>
> Here so we can avoid the ugly 'priv->lock_ctx' stuff below.
>
> > +     struct mm_struct *mm =3D priv->lock_ctx.mm;
> >
> >       if (!priv->task)
> >               return;
> > @@ -259,9 +259,9 @@ static int maps_open(struct inode *inode, struct fi=
le *file,
> >               return -ENOMEM;
> >
> >       priv->inode =3D inode;
> > -     priv->mm =3D proc_mem_open(inode, PTRACE_MODE_READ);
> > -     if (IS_ERR_OR_NULL(priv->mm)) {
> > -             int err =3D priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> > +     priv->lock_ctx.mm =3D proc_mem_open(inode, PTRACE_MODE_READ);
> > +     if (IS_ERR_OR_NULL(priv->lock_ctx.mm)) {
> > +             int err =3D priv->lock_ctx.mm ? PTR_ERR(priv->lock_ctx.mm=
) : -ESRCH;
>
> >
> >               seq_release_private(inode, file);
> >               return err;
> > @@ -276,8 +276,8 @@ static int map_release(struct inode *inode, struct =
file *file)
> >       struct seq_file *seq =3D file->private_data;
> >       struct proc_maps_private *priv =3D seq->private;
> >
> > -     if (priv->mm)
> > -             mmdrop(priv->mm);
> > +     if (priv->lock_ctx.mm)
> > +             mmdrop(priv->lock_ctx.mm);
> >
> >       return seq_release_private(inode, file);
> >  }
> > --
> > 2.50.1.565.gc32cd1483b-goog
> >

