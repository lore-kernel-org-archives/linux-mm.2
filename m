Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99CC5EDEBF5
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 23:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAC036B0088; Tue,  3 Mar 2026 18:59:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5A956B0089; Tue,  3 Mar 2026 18:59:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41DD6B008A; Tue,  3 Mar 2026 18:59:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AEC676B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 18:59:32 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55093B7D80
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:59:32 +0000 (UTC)
X-FDA: 84506421384.28.94799E9
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4F8301A000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:59:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sr6tuxEH;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772582370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=px1Y/hYXvoU5IMfti8a7poEyLQrLWhXDu0pMI3HLqtI=;
	b=gxa3+q4JdzejdgMEDTW3z3jPvNpqXwstXdRUvR79uydp6erxPWWpvADqBcWmjdXFxhQBvP
	OeFmP9b88fFzsBjY022JrroztMKBVYDoZco2X0asIEbX8jQSLSEsY3jdaxiI8WmD0+eduG
	yHz4fISswiOa2qZA/RtPCkWll21Lr7I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772582370; a=rsa-sha256;
	cv=pass;
	b=6D4jbX2F7Kc0t52NNNN/Vl2xUWHpBR0C1CbRM+AhTAmQ9KdzVZxEqjMdQAZAn08Up2SdoQ
	Xh1lT0vcuY7EWq+GBQoUFrI3dCOuYDCitfRzlpUj/VvYb3pepxnLoUmDgmckulmy14dZMQ
	MsrVMCobprLKRVinK6oRJYd0B6+6KAA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sr6tuxEH;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-506a355aedfso695841cf.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 15:59:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772582369; cv=none;
        d=google.com; s=arc-20240605;
        b=OgEAAVc/dWTdhB9aJB0C7zFtFwq9kFgF0enGebCGv/PE7j5fLr4vSFqv9zlzKmMD5T
         pR5TeOAD8eJdLdCqvraS5VPiybQQUaa1Od/ip2KzUUm2rT3kEzjIdwlPn9D/7v5Q/+t3
         I/vtgSiQOeap+b9IGskXOnpTZLoLDg1wStjSD/D7ZMS7OoO9rTy+IYqhKBY4+MtiuoQ7
         3XFrDME69Hp8JXLf9gjh2A2ScVWJzS2pgounfq28OmGmk0r2WUMaQNqycGaTKaYJusfC
         krJLxeV4Sxf7cycZkTFKXzhWdz1lAl0wQefxO8if8iOOUmTi7mTXEfHXP2WgnZDcoy2m
         bZbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=px1Y/hYXvoU5IMfti8a7poEyLQrLWhXDu0pMI3HLqtI=;
        fh=PFbIjub8rnvtFNtxgEfrNTmGy1rCX1RlxiX3UOyblmw=;
        b=hgKGqo5qY73a6xrInR+lYk6tIqTrmq3ImrT6eH3Lk2ai25S5iLThSY2eNaaLxLOZcL
         lDF+CpzXQtgI//GJGg/nPkc7pM2HLHo4S11KJUj1SkgTaAke8tJ8MwLioTBkx0O6Lszp
         tg/gBEqsU0FT3G5ldp3BxIGFFc/X7pw8OsurPwfEL+a8n4P7z2/legIRNeRi1yf46SmO
         WqQqQaxE0NDKe6IUeFI4wKSVAk57FmlFmVVXwEbo8w7ol6fZOB+EhVS2CH46i8zzxyLl
         +VfyxSAkKIuMDo0VAmse5k0sqE7kty1wSXWWp9iBp0hwYABn2WDax4lx8CyXdCOjHrzJ
         OVaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772582369; x=1773187169; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=px1Y/hYXvoU5IMfti8a7poEyLQrLWhXDu0pMI3HLqtI=;
        b=sr6tuxEHGgqF7AYMgcmxeH10Qk48s3ReyDX4u8/WZy84985IRwMK78poIgf/A6Cn25
         wDdF8yVae6vc1wScZjEEVJLlxI0HcGWozQbnzYbfZZLO2mJG5pWiLedBzVDb0O7OcDGy
         0P8pTlm53/n4mVdMv2m5blhet7Gr4Qs38ICwoDka+nOwGyVV72uVBrl84GIFJLrpOy8N
         CD260wvVa1rro1qPqSiOQSXsoUsnxWLUsSC8jyMFnNVxAthAxRHjgmXnvNfAH+chNGgj
         CA1ES4EB5szKQsADaVMViuz3PONosUJpNV258RTWGCra/pJxOtbC4mjDqn4+2cbDMP4G
         3QJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772582369; x=1773187169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=px1Y/hYXvoU5IMfti8a7poEyLQrLWhXDu0pMI3HLqtI=;
        b=Weu+D8fdtLnnLfvXiV9+aByHvJuQZtNUONyvi4SvDLUXGCQCZD3n7mdrsUdZaE4AUb
         Bp8OyZNMw3f1XHjmw+1PG38+b+YCq+/yPfFlcyVf4iXitaVB5BVD5XJyFU85XxhOhaKh
         9NiX918LsZVyiu4Uphl0ijs7/RLES+3GwSWUDGqtsRIBjfMWzifDhYPRb8Qbn68yNntp
         J4nssQX274N5MylTZunt/6RD/17WAE2AymQX+XgAOt+gBGio76ghsH3NEk7YSx1Fb+Ep
         yP62MTcRTq9yVLeAiIm2czXVgacHQv15Bi2Q27J9td1ulH+jgs9eUMIx8CX0KVXirT19
         PW1g==
X-Forwarded-Encrypted: i=1; AJvYcCWRAj2BDqloQ4duAkua4OAmrtiDgNjt9F8Hsh14t2hnZlPEMtqxX/9h5NvzcQdihhpnJ3mFI728ww==@kvack.org
X-Gm-Message-State: AOJu0Yxq90anq0H7aPfJ5q3cjjaUSlawgY56JD2H6dtk8GwOvZTSB10l
	UGn3WbpaODEaUniadS85hDGsuwK0IxMUZVoY3262GyAzEmOCp+uctxZKuxBmsm73i5SHtigEfko
	7Vl8kygjnLjupP/IrS48PfCp0SAIw2loOxmUux+sM
X-Gm-Gg: ATEYQzzhWbX7YH+UdxY7hgmeshxTtNBfJ9OwGTZGrKBuhNFUya7kEuZSPgx3Vslfxzv
	tdKnWAX+8ZBEpuzI7IWwc/Uh9Tyv9kguvMijZ2Ya40taf1qHDsIVlIDjrB11nWpdPgvIQ+mTmw4
	0VElD3eYebIDYKzwLFLhuxJVi1ELqUlk997TEGw8INb6ODj9xG5ws7YB7vpC5Z/BxhQLbbQ5/la
	TCSyzoDhJDszwuJTv7DwPVlGUIHZDf77NbFMtu9LfMw4Zl31JYAO8iBfarRXlYNwzjIVDqkjP8n
	/7j6E1Tk5NVXsb9ynCBMJVvZI9qWlewsLBZB
X-Received: by 2002:a05:622a:14ca:b0:4f3:7b37:81b with SMTP id
 d75a77b69052e-5075fea9c02mr43750861cf.18.1772582368589; Tue, 03 Mar 2026
 15:59:28 -0800 (PST)
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-4-surenb@google.com>
 <72ff2fc0-07fe-4964-9a1e-eccf8c7ed6a7@lucifer.local>
In-Reply-To: <72ff2fc0-07fe-4964-9a1e-eccf8c7ed6a7@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 3 Mar 2026 15:59:17 -0800
X-Gm-Features: AaiRm509RYF3etasX2xFgZmAhKSXZQCXlropJgc5ZcJilpJ6cUQUI8sknzWfQIY
Message-ID: <CAJuCfpG_bekxrHd49qyUBR2K7V8o7DrOvc-ZR7M8dAC-Hyp5ng@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm: use vma_start_write_killable() in process_vma_walk_lock()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5g8akoupri5yuiy5pmqqwxewii49nj57
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F8301A000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1772582370-604212
X-HE-Meta: U2FsdGVkX1+K/WTETYl2JNb+M9ocq5hXcIJYTNvEt9FH6YjVIgPHDrcDJujIOkL6U+YskqPpivYfe8TTTOiO0JTNtB/O2nnzhUL/UaoQCrOyMS3goNT9sxIAyzZzhFlkwLjEl22ciaJ8bxwfsyM88zgqeybyF5PGxNkMPUNeH2FXj/4uo7SC4XEBVt/qusWXKpbJ8LzlLU3IzV5qRQlo6sXyndOniu9BsBEW4F4pFeXqLTyZLtB1l6qvGeXhEGOhfrk67eIjmqviZ+nHdwy+eLaBFme4maRorxftW/P5+OkhkMV9nld9RvbQQ1rNkZoKWs1u4RLsyrNZJMsgXnIXcLh6r7XninLqug1aBiLBHndTvVr8p5PZw+umZWP1+8g0d2GxwqAAlTY9kER+pqFIBY6RKQhZhyphoBge7idYJcW1L0acE9xpNBCQ1NctN53mALTQHfiwtgdcJv+sdoCOKgJXozTvy+5ZiXdFD08sNi4lA2X6bzIwcn1YgJ/kh+7Zz8kayMUrc5zreH6Bf8OP0fBJRgV5o+6zPI5TpaOqjPyhAzyuE3Hm17eyyKrgn8CMWPAjlPgJQOwNbrGfL9K2kxBrXcd11hXPen7V7KOx9ujAEk8kegcBzQX4/6bg9vbe1SSBjdIiqYbBNYPB26XLuvNH8F+e/04JgJ+XEHk8DHC4fgj1RqfpO4WI/67Z7Ex/2Rrk5t05LnmY0Qs74btcJdS5jyHsbX+zt9cd37Cnoo9kThB9YDiSACV0gQSxyd4F10OLxLcZRwGTYOtuByxyKJzxnhZSY3K5qyp4HUYXKcaOHCRAg1AglLtn7sr5pPRt2d6T6ACeBuepYkIxGVvUUa6PUDRr5N1zM2FuRhWuSNsSF8cAp8IwJyFkicIii3+vc0nIqQeMtUhRa1gUUFukhn28xkbJBzqo+4T8a4BrjLqlIsOXbv+EEM6uZ5t/r6I2i6RDNgRpJLBHsxjhjl2
 clifp0Rw
 TfD2tUmUdky9x5aN65YbW0D/SGfYQnTNdT4w/80hdtHq76H/YqZVDVHRNcZJw11y8tqFaXwr/IgI4GgcpkTiu/ynS7kzuIs8qFBeii2xicrKDdr41jb+FbDwP8L9luF4gTZB2efgw9LV09BpPz/ah6XXE2Od/GP49mwFY4+kvHqiPe9gKSZE92NYxEgEVBgomXfackKg3L0P23a2/+GePkzubYejSgF+Me+yBp4fDMMLajdS0Y6iZm2TBbfFv5Z3BQXx0KbvSzonBSP+uGqulXPVBuGMmD8YCL3CtGs73K4E7tN8carMaxWGZN9Nd1hWPFoE22ekKJgT2GsPlYtB2Pr5DrY9vlFYmyo4b1klg32zSG5HOK4rm1HOARiadr7sLLKXKy5SNZ+1EaOOnQZJqfbcrWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 7:25=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Feb 25, 2026 at 11:06:09PM -0800, Suren Baghdasaryan wrote:
> > Replace vma_start_write() with vma_start_write_killable() when
> > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > Adjust its direct and indirect users to check for a possible error
> > and handle it. Ensure users handle EINTR correctly and do not ignore
> > it.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Have raised concerns below but also this feels like you're trying to do a=
 bit
> too much in one patch here, probably worth splitting out based on the dif=
ferent
> parts you changed.
>
> > ---
> >  arch/s390/kvm/kvm-s390.c |  2 +-
> >  fs/proc/task_mmu.c       |  5 ++++-
> >  mm/mempolicy.c           | 14 +++++++++++---
> >  mm/pagewalk.c            | 20 ++++++++++++++------
> >  mm/vma.c                 | 22 ++++++++++++++--------
> >  mm/vma.h                 |  6 ++++++
> >  6 files changed, 50 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 7a175d86cef0..337e4f7db63a 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -2948,7 +2948,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned=
 int ioctl, unsigned long arg)
> >               }
> >               /* must be called without kvm->lock */
> >               r =3D kvm_s390_handle_pv(kvm, &args);
> > -             if (copy_to_user(argp, &args, sizeof(args))) {
> > +             if (r !=3D -EINTR && copy_to_user(argp, &args, sizeof(arg=
s))) {
>
> This is horribly ugly, and if we were already filtering any other instanc=
e of
> -EINTR (if they're even possible from copy_to_user()) why is -EINTR being
> treated in a special way?
>
> I honestly _hate_ this if (errcode !=3D -EINTR) { ... } pattern in genera=
l, I'd
> really rather we didn't.
>
> It's going to bitrot and people are going to assume it's for some _very g=
ood
> reason_ and nobody will understand why it's getting special treatment...
>
> Surely a fatal signal would have previously resulted in -EFAULT before wh=
ich is
> a similar situation so most consistent would be to keep filtering no?

Current code ignores any error coming from kvm_s390_handle_pv() and
proceeds with copy_to_user(), possibly overriding the former error. I
don't really know if this is an oversight or an intentional behavior,
so I wanted to minimize possible side effects. I guess I should try to
fix it properly (or learn why this was done this way). I'll post a
separate patch to error out immediately if kvm_s390_handle_pv() fails
and will ask s390 experts for review.

>
> >                       r =3D -EFAULT;
> >                       break;
> >               }
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index e091931d7ca1..1238a2988eb6 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -1797,6 +1797,7 @@ static ssize_t clear_refs_write(struct file *file=
, const char __user *buf,
> >               struct clear_refs_private cp =3D {
> >                       .type =3D type,
> >               };
> > +             int err;
> >
> >               if (mmap_write_lock_killable(mm)) {
> >                       count =3D -EINTR;
> > @@ -1824,7 +1825,9 @@ static ssize_t clear_refs_write(struct file *file=
, const char __user *buf,
> >                                               0, mm, 0, -1UL);
> >                       mmu_notifier_invalidate_range_start(&range);
> >               }
> > -             walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
> > +             err =3D walk_page_range(mm, 0, -1, &clear_refs_walk_ops, =
&cp);
> > +             if (err < 0)
>
> Again with this < 0 :) let's be consistent, if (err).

Ack.

>
> > +                     count =3D err;
> >               if (type =3D=3D CLEAR_REFS_SOFT_DIRTY) {
> >                       mmu_notifier_invalidate_range_end(&range);
> >                       flush_tlb_mm(mm);
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 90939f5bde02..3c8b3dfc9c56 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -988,6 +988,8 @@ queue_pages_range(struct mm_struct *mm, unsigned lo=
ng start, unsigned long end,
> >                       &queue_pages_lock_vma_walk_ops : &queue_pages_wal=
k_ops;
>
> There's a comment above:
>
>  * queue_pages_range() may return:
>  * 0 - all pages already on the right node, or successfully queued for mo=
ving
>  *     (or neither strict checking nor moving requested: only range check=
ing).
>  * >0 - this number of misplaced folios could not be queued for moving
>  *      (a hugetlbfs page or a transparent huge page being counted as 1).
>  * -EIO - a misplaced page found, when MPOL_MF_STRICT specified without M=
OVEs.
>  * -EFAULT - a hole in the memory range, when MPOL_MF_DISCONTIG_OK unspec=
ified.
>  */
>
> You should add the -EINTR to it.

Ack.

>
> >
> >       err =3D walk_page_range(mm, start, end, ops, &qp);
> > +     if (err =3D=3D -EINTR)
> > +             return err;
>
> Again, you're special casing without really any justification here. Let's=
 please
> not special case -EINTR unless you have a _really good_ reason to.
>
> And also - if we fail to walk the page range because we couldn't get a VM=
A write
> lock, that's ok. The walk failed. There's nothing to unlock, because we d=
idn't
> even get the write lock in the first place, so there's no broken state, i=
t's as
> if we failed at some other point right?
>
> So I don't see why we're special casing this _at all_.

I want to avoid possible -EINTR code override with -EFAULT in the code belo=
w.
walk_page_range() can return -EINVAL and any other error that
ops->pte_hole or ops->test_walk might return. We might be fine
treating all of them as -EFAULT but masking -EINTR seems wrong to me.
I don't really know a better way to deal with this but if you have a
good alternative I would really appreciate it.

>
> >
> >       if (!qp.first)
> >               /* whole range in hole */
> > @@ -1309,9 +1311,14 @@ static long migrate_to_node(struct mm_struct *mm=
, int source, int dest,
> >                                     flags | MPOL_MF_DISCONTIG_OK, &page=
list);
> >       mmap_read_unlock(mm);
>
>
> >
> > +     if (nr_failed =3D=3D -EINTR)
> > +             err =3D nr_failed;
>
> Ugh please don't, that's REALLY horrible.
>
> Actually the only way you'd get a write lock happening in the walk_page_r=
ange()
> is if flags & MPOL_MF_WRLOCK, menaing queue_pages_lock_vma_walk_ops are u=
sed
> which specifies .walk_lock =3D PGWALK_WRLOCK.
>
> And this flag is only set in do_mbind(), not in migrate_to_node().
>
> So this check is actually totally unnecessary. You'll never get -EINTR he=
re.

Ah, good point. I'll drop this part.

>
> Maybe this code needs some refactoring though in general... yikes.

Right.

>
> > +
> >       if (!list_empty(&pagelist)) {
> > -             err =3D migrate_pages(&pagelist, alloc_migration_target, =
NULL,
> > -                     (unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NU=
LL);
> > +             if (!err)
> > +                     err =3D migrate_pages(&pagelist, alloc_migration_=
target,
> > +                                         NULL, (unsigned long)&mtc,
> > +                                         MIGRATE_SYNC, MR_SYSCALL, NUL=
L);
>
> Given the above, this is unnecessary too.

Ack. Will drop.

>
> >               if (err)
> >                       putback_movable_pages(&pagelist);
> >       }
> > @@ -1611,7 +1618,8 @@ static long do_mbind(unsigned long start, unsigne=
d long len,
> >                               MR_MEMPOLICY_MBIND, NULL);
> >       }
> >
> > -     if (nr_failed && (flags & MPOL_MF_STRICT))
> > +     /* Do not mask EINTR */
>
> Useless comment... You're not explaining why, and it's obvious what you'r=
e doing.
>
> > +     if ((err !=3D -EINTR) && (nr_failed && (flags & MPOL_MF_STRICT)))
>
> Weird use of parens...
>
> And again why are we treating -EINTR in a special way?

Ah, actually I don't think I need this here. If queue_pages_range()
fails nr_failed gets reset to 0, so the original error won't be masked
as -EIO. I'll drop this part.

>
> >               err =3D -EIO;
> >       if (!list_empty(&pagelist))
> >               putback_movable_pages(&pagelist);
> > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > index a94c401ab2cf..dc9f7a7709c6 100644
> > --- a/mm/pagewalk.c
> > +++ b/mm/pagewalk.c
> > @@ -425,14 +425,13 @@ static inline void process_mm_walk_lock(struct mm=
_struct *mm,
> >               mmap_assert_write_locked(mm);
> >  }
> >
> > -static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> > +static inline int process_vma_walk_lock(struct vm_area_struct *vma,
> >                                        enum page_walk_lock walk_lock)
> >  {
> >  #ifdef CONFIG_PER_VMA_LOCK
> >       switch (walk_lock) {
> >       case PGWALK_WRLOCK:
> > -             vma_start_write(vma);
> > -             break;
> > +             return vma_start_write_killable(vma);
> >       case PGWALK_WRLOCK_VERIFY:
> >               vma_assert_write_locked(vma);
> >               break;
> > @@ -444,6 +443,7 @@ static inline void process_vma_walk_lock(struct vm_=
area_struct *vma,
> >               break;
> >       }
> >  #endif
> > +     return 0;
> >  }
> >
> >  /*
> > @@ -487,7 +487,9 @@ int walk_page_range_mm_unsafe(struct mm_struct *mm,=
 unsigned long start,
> >                       if (ops->pte_hole)
> >                               err =3D ops->pte_hole(start, next, -1, &w=
alk);
> >               } else { /* inside vma */
> > -                     process_vma_walk_lock(vma, ops->walk_lock);
> > +                     err =3D process_vma_walk_lock(vma, ops->walk_lock=
);
> > +                     if (err)
> > +                             break;
> >                       walk.vma =3D vma;
> >                       next =3D min(end, vma->vm_end);
> >                       vma =3D find_vma(mm, vma->vm_end);
> > @@ -704,6 +706,7 @@ int walk_page_range_vma_unsafe(struct vm_area_struc=
t *vma, unsigned long start,
> >               .vma            =3D vma,
> >               .private        =3D private,
> >       };
> > +     int err;
> >
> >       if (start >=3D end || !walk.mm)
> >               return -EINVAL;
> > @@ -711,7 +714,9 @@ int walk_page_range_vma_unsafe(struct vm_area_struc=
t *vma, unsigned long start,
> >               return -EINVAL;
> >
> >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > -     process_vma_walk_lock(vma, ops->walk_lock);
> > +     err =3D process_vma_walk_lock(vma, ops->walk_lock);
> > +     if (err)
> > +             return err;
> >       return __walk_page_range(start, end, &walk);
> >  }
> >
> > @@ -734,6 +739,7 @@ int walk_page_vma(struct vm_area_struct *vma, const=
 struct mm_walk_ops *ops,
> >               .vma            =3D vma,
> >               .private        =3D private,
> >       };
> > +     int err;
> >
> >       if (!walk.mm)
> >               return -EINVAL;
> > @@ -741,7 +747,9 @@ int walk_page_vma(struct vm_area_struct *vma, const=
 struct mm_walk_ops *ops,
> >               return -EINVAL;
> >
> >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > -     process_vma_walk_lock(vma, ops->walk_lock);
> > +     err =3D process_vma_walk_lock(vma, ops->walk_lock);
> > +     if (err)
> > +             return err;
> >       return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
> >  }
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 9f2664f1d078..46bbad6e64a4 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -998,14 +998,18 @@ static __must_check struct vm_area_struct *vma_me=
rge_existing_range(
> >       if (anon_dup)
> >               unlink_anon_vmas(anon_dup);
> >
> > -     /*
> > -      * This means we have failed to clone anon_vma's correctly, but n=
o
> > -      * actual changes to VMAs have occurred, so no harm no foul - if =
the
> > -      * user doesn't want this reported and instead just wants to give=
 up on
> > -      * the merge, allow it.
> > -      */
> > -     if (!vmg->give_up_on_oom)
> > -             vmg->state =3D VMA_MERGE_ERROR_NOMEM;
> > +     if (err =3D=3D -EINTR) {
> > +             vmg->state =3D VMA_MERGE_ERROR_INTR;
>
> Yeah this is incorrect. You seem adament in passing through -EINTR _no
> matter what_ :)

You got me figured out ;)

>
> There are callers that don't care at all if the merge failed, whether thr=
ough
> oom or VMA write lock not being acquired.

Ah, I see. I was a bit puzzled by this vmg->give_up_on_oom flag. I
think what you are saying is that errors from
vma_merge_existing_range() are ignored unless this flag is set and
even then the only possible error is ENOMEM.

>
> There's really no benefit in exiting early here I don't think, the subseq=
uent
> split will call vma_start_write_killable() anyway.

But are we always calling split after the merge?

>
> So I think this adds a lot of complexity and mess for nothing.
>
> So can we drop all this change to the merge logic please?

Ok but is there a good reason for this unusual error handling logic in
vma_merge_existing_range()?

>
> > +     } else {
> > +             /*
> > +              * This means we have failed to clone anon_vma's correctl=
y,
> > +              * but no actual changes to VMAs have occurred, so no har=
m no
> > +              * foul - if the user doesn't want this reported and inst=
ead
> > +              * just wants to give up on the merge, allow it.
> > +              */
> > +             if (!vmg->give_up_on_oom)
> > +                     vmg->state =3D VMA_MERGE_ERROR_NOMEM;
> > +     }
> >       return NULL;
> >  }
> >
> > @@ -1681,6 +1685,8 @@ static struct vm_area_struct *vma_modify(struct v=
ma_merge_struct *vmg)
> >       merged =3D vma_merge_existing_range(vmg);
> >       if (merged)
> >               return merged;
> > +     if (vmg_intr(vmg))
> > +             return ERR_PTR(-EINTR);
> >       if (vmg_nomem(vmg))
> >               return ERR_PTR(-ENOMEM);
> >
> > diff --git a/mm/vma.h b/mm/vma.h
> > index eba388c61ef4..fe4560f81f4f 100644
> > --- a/mm/vma.h
> > +++ b/mm/vma.h
> > @@ -56,6 +56,7 @@ struct vma_munmap_struct {
> >  enum vma_merge_state {
> >       VMA_MERGE_START,
> >       VMA_MERGE_ERROR_NOMEM,
> > +     VMA_MERGE_ERROR_INTR,
> >       VMA_MERGE_NOMERGE,
> >       VMA_MERGE_SUCCESS,
> >  };
> > @@ -226,6 +227,11 @@ static inline bool vmg_nomem(struct vma_merge_stru=
ct *vmg)
> >       return vmg->state =3D=3D VMA_MERGE_ERROR_NOMEM;
> >  }
> >
> > +static inline bool vmg_intr(struct vma_merge_struct *vmg)
> > +{
> > +     return vmg->state =3D=3D VMA_MERGE_ERROR_INTR;
> > +}
> > +
> >  /* Assumes addr >=3D vma->vm_start. */
> >  static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
> >                                      unsigned long addr)
> > --
> > 2.53.0.414.gf7e9f6c205-goog
> >
>

