Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64B3C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 21:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665858E0005; Wed,  6 Aug 2025 17:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D7E8E0002; Wed,  6 Aug 2025 17:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52C498E0005; Wed,  6 Aug 2025 17:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 432A08E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:46:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB86614030E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:46:15 +0000 (UTC)
X-FDA: 83747666310.05.63EF921
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id D7B411C0005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:46:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iER3yTsd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754516773; a=rsa-sha256;
	cv=none;
	b=NF07n2PJMpBjbLYPI6uvmGIGhNR2uOhlOQk6bU1Sq0yTeTJCsOORuq+SSQ7ynZqc1qQ4z/
	qTUM5sKlsaCWiYPceu9zM0aJKdnNZerG/SoDt/zH2n2Gi4eG3CvlGRpDPExY800K9tQZXL
	17CSfx8votSbmGGIR0N0yzOeauP5jII=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iER3yTsd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754516773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxW5GAL3bM/I2otEhPeRhXnNiAmw94QPD8j2NzcS20s=;
	b=uplNouh+ZHzkMxPqUj7wQ0S0XTK0V7H01QoFx9Nx95iObBxwUVipLefcYJmUhsXFSfsKax
	XrYx1djxIvpDomM6XbQkiT9ttadb6GxgAcvf+lfmQFNbQE7/kEm+zrT8OewR8ptPSuYfs7
	hw8tIitSEzc5XQks9swohaXrYQJkQM0=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b099118fedso50971cf.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 14:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754516773; x=1755121573; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yxW5GAL3bM/I2otEhPeRhXnNiAmw94QPD8j2NzcS20s=;
        b=iER3yTsdX2DVAeQkf0lgkS1OrJeJqTNeBddmSbye26L5ICKewY/SqFrWn6hpEFx7X9
         ZdTwDwyp0eEu3E95RbM9FsvIcuMhoquyz5csaTO3bppOuZIG4gbJbVuQqFfmlCQbSwzg
         Z2O9VHTMw4tHPOHzPycEUGPDqvZDErABLod3bQ5/EDt6zPNmqcNm3BhWGByv5bpEJ4CM
         oyMg/JW3abRZTfajWeNKX5LXhiqliGGLOc/s3fTLdgHp1UDfdagN/24kjGw1sl93Or7m
         tBhDmbKnTa34nNyVxAbFjSPBG2q0cw+hL0JX00RFI10k2JndSfsvQbiJiQN1qXB3oiMu
         pPqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754516773; x=1755121573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yxW5GAL3bM/I2otEhPeRhXnNiAmw94QPD8j2NzcS20s=;
        b=PtslfLNAGFJMtgwKvFQ9oo6qQPyqZ2XNJZHU1XBgnzyfeu7ShgDKnIhGtJ8VUZQcsU
         8Du52cKU1dFsBL7a7TPSISSLLPT3YqrgK+W9keK7zGB1/K31rIQu1jRkLTKfQ2bAQVAb
         A0q8OS4Fo6g9DKKT66j4zUHtVvRLkP8Lpn71sdTSatUZrCq48T7mUMgAMQOT2X3uG8M/
         vXpPCLvMqBXSwzaeEnnZWkmqfALhqklJBcneAaZaGc4gbv3TIFPZNmNs2nFvbZyPahWF
         dm1a6hp1gNgiwVOae/f4EvXbtnbIC8A9hmDvTTQvl8kC0c7x9ZSg56bUbw0twI75pc9C
         uedQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyssU0LBY74323fZRhse3ntO8h+l2uD5uHPfxLMwZAYJ/MOeZaGUVHm/NW6YZyg5kntaCf3X/meQ==@kvack.org
X-Gm-Message-State: AOJu0YxmN7M42HfMOly6TDYzH2yKGcrPAKeDH2+hBkbvU/lMKLsHahTX
	bi+mMuCNy4OohSw4ZMHabqiDKnqtd/FkqDLXWb9mjeBDQcGfMTguCbwoDYFHxsVL2CAQADDwC4l
	m8sWgC0f9EGdi6v7guULAOss5jiMfSlaDNq4hUFOE
X-Gm-Gg: ASbGncvMamdlKtHMn/x0kfxUBoZoejoLlrhYNb9epOryCvOiI90k877uV92bm7h/TZf
	lEVnzsv9eg/Cm6NgBagkOKVDSqjv74ZIzMD5FdD9PIj23tZq1Ye4OaBU5Qmv8V89HSYPY1Az1CV
	/p6ol9m6J5EN0Id9kKv1omNc4EAT/HE8fvMdZ2NqsG7RKZLZIA/OIMaDnPIuyOYQPIduE/b8vYp
	GxvFqdqqE0C6uAZAYamKjkznCiUMb/EpYA4L5otUM9zZpJ/
X-Google-Smtp-Source: AGHT+IFdmXPQZItR2ayc1YdqBDwRQHE7GzP2qwoWOBR+mlDDDgs6jqf+g5f4jCHjpUZgoidmSeVTdUaYH200K1a+z3I=
X-Received: by 2002:a05:622a:607:b0:4b0:85d7:b884 with SMTP id
 d75a77b69052e-4b0a37dc7aemr454981cf.21.1754516772179; Wed, 06 Aug 2025
 14:46:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250806155905.824388-1-surenb@google.com> <20250806155905.824388-4-surenb@google.com>
 <8ddff47d-3059-42ea-b022-6151da513049@lucifer.local>
In-Reply-To: <8ddff47d-3059-42ea-b022-6151da513049@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 6 Aug 2025 14:46:00 -0700
X-Gm-Features: Ac12FXz2HywmlnpQot2FVtRqWi3gIynzyBudbKw5U311U7inXb6k23cYiYmJ7i0
Message-ID: <CAJuCfpEntig+s6GNSERvMJBY=LNWNd_9CraxG7-zkwK1KF882Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] fs/proc/task_mmu: execute PROCMAP_QUERY ioctl
 under per-vma locks
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
X-Rspamd-Queue-Id: D7B411C0005
X-Stat-Signature: uq4squrf5px3k3dazsi1q6o34xkeem6c
X-Rspam-User: 
X-HE-Tag: 1754516773-687634
X-HE-Meta: U2FsdGVkX1+M4DEXnwg8JPbGKjQ81F5LDRGCq4krgcsOha+modn4klc/blKzlKb8R0FRYE6o/QfO5qkLaxmkkShpTcOzkfBAG/nBumfsKMf5oTudROs8zdpzc4tvB9Esrd6fQ5ZvSsUqQuammQ1PmBpFFCp6Pjs3Pgu77gte5dfaGkoilvqpGY6qOzxsIcZZFsHUufmAqbPLoZV4lD2opo8in74Z2zjyq9MF15bjBLWC90EHhvKKmZroMD/nWFXhk5aRqQPcSiGREuDtUx8Md6qy0BZ6nmrbBLZBgwo8ZENf2W1jfS8UP3rYDL8doMtR1EYrnjg6QCROVv1FWzYpgYLU5kOFImWqov6oHV70D0xftKghqVxxHdzi9I1YdFOp9AyELsFz08AgfG+zB8oYL3b1DpW2T9xczbF74sa8oQyUSRWSpLKx69V49mkABnY/jKacOC25aIuRd5zXrSa4kqWv0QaaMOtwIRw43iLerMFBAd7p1yiu6j8hh0efR5nLgv4l1wtKSdC3Hn3HlIfCJjHHB7Pb2AJlfGP+3OG7qFhdbhQCBFQGadu96dphayLsEC6XhJ66hgQGi3wg4RnFqvscCc/huQ+R+LDSGJ/5CI6tP12tyPsZ4RWB9B0LecZCCnqDDKThIcels7yeFqgqa6U3x0gPgfegiq4+5Yq7A+JBVNaspkgA7BQpXEMhWBC1xphRVBLEvMfnQSY6D9Jlkt3eSevOn0CusuZBB6KzsKjhrZko9tLuSFmJLKo4uqkSJNuoyK+AP1aM0qwX/7ugQg0P5pVCMml3SfnWx9KA1G1e6i0gy/CiapJFGwM0CA8POjOF9yri5X2Rici9sZKD3F5ONqwWYH8MIMaTIyDjpaVbLMw2jpiM3lciS0bxKfHNPzKFJfuC5j+RDIB+c9TR01PKx7OOt61oE3F+meCcI/QH+C+btZZf8xitq/jn6VOxmDmGUFPFSiswd3F+aM2
 bNFeRgDn
 wsE7OVpEUJCt9hsxkrnYQxNgGUEfispQEW21WrQ65wUiyZv1VNp0t/uYMZkU1AmHYUHRI5d4qkNnEumUdhMWoXQijYRcWhFP+Ylm0HtZHsdrcNOVNCiu0CkHBqvIanoKEql8I6uEP8mGjL80OkrXeXOxwllVI0ETLXoF5ZfYkuRgyytDeWiu0eYf9+90DC3YXX2P6z4zrpVvO1gqJIvuYMh3Jc2WqiwqdlXLaFsHZoDGudwqUmsNiKRfnvxU0X894WYaeXn5vBpV1UpfTp2ESN37OAm6yc01QMpid0aI7mTHvZiL9JToIZqQ/0vyTdcplDcBc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 12:03=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Aug 06, 2025 at 08:59:04AM -0700, Suren Baghdasaryan wrote:
> > Utilize per-vma locks to stabilize vma after lookup without taking
> > mmap_lock during PROCMAP_QUERY ioctl execution. If vma lock is
> > contended, we fall back to mmap_lock but take it only momentarily
> > to lock the vma and release the mmap_lock. In a very unlikely case
> > of vm_refcnt overflow, this fall back path will fail and ioctl is
> > done under mmap_lock protection.
> >
> > This change is designed to reduce mmap_lock contention and prevent
> > PROCMAP_QUERY ioctl calls from blocking address space updates.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> A lot of nits but nothing's really standing out as broken, AFAICT...
>
> > ---
> >  fs/proc/task_mmu.c | 84 +++++++++++++++++++++++++++++++++++++---------
> >  1 file changed, 68 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 45134335e086..0396315dfaee 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -517,28 +517,81 @@ static int pid_maps_open(struct inode *inode, str=
uct file *file)
> >               PROCMAP_QUERY_VMA_FLAGS                         \
> >  )
> >
> > -static int query_vma_setup(struct mm_struct *mm)
> > +#ifdef CONFIG_PER_VMA_LOCK
> > +
> > +static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> > -     return mmap_read_lock_killable(mm);
> > +     lock_ctx->locked_vma =3D NULL;
> > +     lock_ctx->mmap_locked =3D false;
>
> We also do this in lock_vma_range(), seems sensible to factor out? E.g.:
>
> static void ctx_clear_vma(struct proc_maps_locking_ctx *lock_ctx)

That name really confused me :) Maybe lock_vma_ctx_init() or something
along these lines. If we can't think of a good name I would prefer to
keep it as is, given it's only two lines and used only in two places.

> {
>         lock_ctx->locked_vma =3D NULL;
>         lock_ctx->mmap_locked =3D false;
> }
>
> > +
> > +     return 0;
> >  }
> >
> > -static void query_vma_teardown(struct mm_struct *mm, struct vm_area_st=
ruct *vma)
> > +static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> > -     mmap_read_unlock(mm);
> > +     if (lock_ctx->mmap_locked)
> > +             mmap_read_unlock(lock_ctx->mm);
>
> Maybe worth a comment as to why we leave lock_ctx->mmap_locked set here?

Sure. The reason is that this is a teardown stage and lock_ctx won't
be used anymore. I guess I could reset it just to leave lock_ctx
consistent instead of adding a comment. Will do that.

>
> > +     else
> > +             unlock_vma(lock_ctx);
>
> Should have said on 2/3, but I wonder if we should prefix with ctx_, as
> 'unlock_vma()' and 'lock_vma()' seem like core functions... esp. since we
> have vma_start_read/write() rather than functions that reference locking.
>
> So - ctx_unlock_vma() and ctx_lock_vma() or unlock_ctx_vma() /
> lock_ctx_vma()?

unlock_ctx_vma() / lock_ctx_vma() sounds good to me.

>
> > +}
> > +
> > +static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_=
locking_ctx *lock_ctx,
> > +                                                  unsigned long addr)
> > +{
> > +     struct vm_area_struct *vma;
> > +     struct vma_iterator vmi;
> > +
> > +     if (lock_ctx->mmap_locked)
> > +             return find_vma(lock_ctx->mm, addr);
> > +
> > +     unlock_vma(lock_ctx);
> > +     rcu_read_lock();
> > +     vma_iter_init(&vmi, lock_ctx->mm, addr);
> > +     vma =3D lock_next_vma(lock_ctx->mm, &vmi, addr);
> > +     rcu_read_unlock();
>
> I think a comment at the top of this block would be useful, something lik=
e
> 'We unlock any previously locked VMA and find the next under RCU'.

Ack.

>
> > +
> > +     if (!IS_ERR_OR_NULL(vma)) {
>
> Is the NULL bit here really necessary? presumably lock_ctx->locked_vma is
> expected to be NULL already, so we're not overwriting anything here.
>
> In fact we could get rid of the horrid if/else here with a guard clause l=
ike:
>
>         if (!IS_ERR(vma) || PTR_ERR(vma) !=3D -EAGAIN)
>                 return vma;

We still need to assign lock_ctx->locked_vma when !IS_ERR(vma) before
we return the vma, so the lines about would not be correct. I can
change it to:

if (!vma)
    return NULL;

if (!IS_ERR(vma)) {
    lock_ctx->locked_vma =3D vma;
    return vma;
}

if (PTR_ERR(vma) =3D=3D -EAGAIN) {
    /* Fallback to mmap_lock on vma->vm_refcnt overflow */
    ...
}
return vma;

I think that would be the equivalent of what I currently have. Would
you prefer that?

>
> (the !IS_ERR() bit is probably a bit redundant but makes things clearer
> vs. just the PTR_ERR() thing)
>
> Then do the rest below.
>
>
> > +             lock_ctx->locked_vma =3D vma;
> > +     } else if (PTR_ERR(vma) =3D=3D -EAGAIN) {
> > +             /* Fallback to mmap_lock on vma->vm_refcnt overflow */
> > +             mmap_read_lock(lock_ctx->mm);
> > +             vma =3D find_vma(lock_ctx->mm, addr);
> > +             lock_ctx->mmap_locked =3D true;
>
> Kinda sucks we have two separate ways of doing fallback now, this
> open-coded thing and fallback_to_mmap_lock().
>
> Sort of hard to combine since we have subtly diffrent semantics - the RCU
> read lock is being held in the /proc/$pid/maps case, but here we've
> released it already.

Yeah, plus that one uses iterators and this one doesn't... I don't
think it's worth trying to shoehorn them together given that the code
is quite short.

>
> > +     }
> > +
> > +     return vma;
> > +}
> > +
> > +#else /* CONFIG_PER_VMA_LOCK */
> > +
> > +static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
> > +{
> > +     return mmap_read_lock_killable(lock_ctx->mm);
> >  }
> >
> > -static struct vm_area_struct *query_vma_find_by_addr(struct mm_struct =
*mm, unsigned long addr)
> > +static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
> >  {
> > -     return find_vma(mm, addr);
> > +     mmap_read_unlock(lock_ctx->mm);
> >  }
> >
> > -static struct vm_area_struct *query_matching_vma(struct mm_struct *mm,
> > +static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_=
locking_ctx *lock_ctx,
> > +                                                  unsigned long addr)
> > +{
> > +     return find_vma(lock_ctx->mm, addr);
> > +}
> > +
> > +#endif  /* CONFIG_PER_VMA_LOCK */
> > +
> > +static struct vm_area_struct *query_matching_vma(struct proc_maps_lock=
ing_ctx *lock_ctx,
> >                                                unsigned long addr, u32 =
flags)
> >  {
> >       struct vm_area_struct *vma;
> >
> >  next_vma:
> > -     vma =3D query_vma_find_by_addr(mm, addr);
> > +     vma =3D query_vma_find_by_addr(lock_ctx, addr);
> > +     if (IS_ERR(vma))
> > +             return vma;
> > +
> >       if (!vma)
> >               goto no_vma;
> >
> > @@ -579,11 +632,11 @@ static struct vm_area_struct *query_matching_vma(=
struct mm_struct *mm,
> >       return ERR_PTR(-ENOENT);
> >  }
> >
> > -static int do_procmap_query(struct proc_maps_private *priv, void __use=
r *uarg)
> > +static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
> >  {
> > +     struct proc_maps_locking_ctx lock_ctx =3D { .mm =3D mm };
>
> >       struct procmap_query karg;
> >       struct vm_area_struct *vma;
> > -     struct mm_struct *mm;
> >       const char *name =3D NULL;
> >       char build_id_buf[BUILD_ID_SIZE_MAX], *name_buf =3D NULL;
> >       __u64 usize;
> > @@ -610,17 +663,16 @@ static int do_procmap_query(struct proc_maps_priv=
ate *priv, void __user *uarg)
> >       if (!!karg.build_id_size !=3D !!karg.build_id_addr)
> >               return -EINVAL;
> >
> > -     mm =3D priv->lock_ctx.mm;
> >       if (!mm || !mmget_not_zero(mm))
> >               return -ESRCH;
> >
> > -     err =3D query_vma_setup(mm);
> > +     err =3D query_vma_setup(&lock_ctx);
> >       if (err) {
> >               mmput(mm);
> >               return err;
> >       }
> >
> > -     vma =3D query_matching_vma(mm, karg.query_addr, karg.query_flags)=
;
> > +     vma =3D query_matching_vma(&lock_ctx, karg.query_addr, karg.query=
_flags);
> >       if (IS_ERR(vma)) {
> >               err =3D PTR_ERR(vma);
> >               vma =3D NULL;
> > @@ -705,7 +757,7 @@ static int do_procmap_query(struct proc_maps_privat=
e *priv, void __user *uarg)
> >       }
> >
> >       /* unlock vma or mmap_lock, and put mm_struct before copying data=
 to user */
> > -     query_vma_teardown(mm, vma);
> > +     query_vma_teardown(&lock_ctx);
> >       mmput(mm);
> >
> >       if (karg.vma_name_size && copy_to_user(u64_to_user_ptr(karg.vma_n=
ame_addr),
> > @@ -725,7 +777,7 @@ static int do_procmap_query(struct proc_maps_privat=
e *priv, void __user *uarg)
> >       return 0;
> >
> >  out:
> > -     query_vma_teardown(mm, vma);
> > +     query_vma_teardown(&lock_ctx);
> >       mmput(mm);
> >       kfree(name_buf);
> >       return err;
> > @@ -738,7 +790,7 @@ static long procfs_procmap_ioctl(struct file *file,=
 unsigned int cmd, unsigned l
> >
> >       switch (cmd) {
> >       case PROCMAP_QUERY:
> > -             return do_procmap_query(priv, (void __user *)arg);
> > +             return do_procmap_query(priv->lock_ctx.mm, (void __user *=
)arg);
>
> OK this confused me until I worked it through.
>
> We set priv->lock_ctx.mm in:
>
> pid_maps_open() -> do_maps_open() -> proc_maps_open()
>
> Which it gets from proc_mem_open() which figures out the mm.
>
> Maybe one for 2/3, but it'd be nice to have a comment saying something
> about how this is set, since it being part of lock_ctx makes it seem like
> it's something that would be set elsewhere.
>
> Since we have fallback stuff and want to thread through this new lokc
> context type I guess it makes sense to put it here but given that's the
> case, let's maybe just add a comment here to clarify.

Ok, something like "lock_ctx.mm is set during file open operation" ?

>
> >       default:
> >               return -ENOIOCTLCMD;
> >       }
> > --
> > 2.50.1.565.gc32cd1483b-goog
> >
>
> Cheers, Lorenzo

