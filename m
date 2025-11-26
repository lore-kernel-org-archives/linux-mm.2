Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C317CD10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A7F06B002F; Wed, 26 Nov 2025 11:11:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07F356B0030; Wed, 26 Nov 2025 11:11:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6B76B007B; Wed, 26 Nov 2025 11:11:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA22E6B002F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:11:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A483DBA7BE
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:11:31 +0000 (UTC)
X-FDA: 84153248382.03.769BE00
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id AEEE140014
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:11:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YebUo7E8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764173489; a=rsa-sha256;
	cv=none;
	b=5AWLmaUfzMku6Yw1bTSJP4vNBVUI6JlrDgFBjNEJEYE8eyYUl7fcOBagt93+4xSv8IJ1K+
	2kqbo4Qe6DcL0YBywI6mChsnz1Xy9SQLfsjbd+vI32VxFPdirWog7FsrI3StXzR1d73HH/
	U+bwBxbO7oPJaY0+9/oRAheowGT2pwc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YebUo7E8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764173489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BufC0JEUpSedrl1NfhyQysvKSaFUXF1uLVq1S8/4yM8=;
	b=QNt0MbaLhAV0eq7jsydLQxArZuBZxM8YDqlm/lEnND6w+od68Ie7FFFPy1amvBd996TaHR
	SfnDj/pOfy51gBqs2Hfv4/mnvpZFSGiWbb75vWnvRUsUHGFVZ6Q3cs3vVFQL6gDatDRyTv
	trW7tCOZVLkuyaNkMb3D6qfQnWTp6PM=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ee147baf7bso300401cf.1
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 08:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764173489; x=1764778289; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BufC0JEUpSedrl1NfhyQysvKSaFUXF1uLVq1S8/4yM8=;
        b=YebUo7E8dhxbz1iRTk4w8mC33a65OewzX3peM2Me/BVl58rFaQGCsXdDpvp4Tvh15v
         Er9DS7OF3KhN0PySomvjDyOrJtrg5+V4vSAdzvkTglNSuj/U08VixULGXnFyYj7SjB1X
         yNSFBSmrvZ2MC36MbOlZgCQuK35+O/vKl2gKV4dhQKqFWXY1cAJeb8AijsKBnbZqPuYi
         EdO7AWgrVxaxVUsBzCsDaudAwRnYbTfZkPpABgBfnfiGT8fD0PT64bDHVN7kYuVJneWW
         tWXDHd1Y4ujkzRXd0we28Xf+t6uJC+4CG3/oYWcwJtpFDtIr/2SbmCHXeMG7oy65sDRU
         7/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764173489; x=1764778289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BufC0JEUpSedrl1NfhyQysvKSaFUXF1uLVq1S8/4yM8=;
        b=WbAemdEXi+SDNjJVjF+64oOvvWN67wQPo4go3b/8ezeeVPYQfvO6WoZd8lZlssSg+H
         IDGC96zQBhIaLLCtyg3aFUgGsmHOOUraW2AyIjAVI4haz015PDG7P3KiSstSxkCznW10
         +zJ4Mf8uiGsYcRYr7KyctcWVgwuaHtVSovLGqLB+unoawuTkNl7VOn00A3LV61r652A/
         ixn4mYVEO3KGHPpFn8sxSma+21KbxHPJgzGfZWUBY1T1XFia92T+VqevUk0IzDVLpeRm
         z97gIgJEEGE7Ulvl4EPkJv7J2VH8SBbiaD98FXPrWG439GClD11pWaRi/3IwduU6uxN1
         rOrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYAtfay9kWkb6C3wTGIaxwi/SVckL7EqUJMFOHnwBxkBy0bS5hOfc/cYJRU5Stbl8dyctpsAfdwQ==@kvack.org
X-Gm-Message-State: AOJu0YwHPcSMkbQC2roZ70FY092XvapJ8jzfWexTSFf76WZzS0l6SFAJ
	0ysud93FcHEUjQ80/xyn1llYmu/WGOUjBsgsNHAWfig6WTOoEhrbTI8td7RCCmOKqL2U4mfgRJs
	ODYWgQP/2iuxNQ2bbzIRYCr4pOYr9TdONVfUz2bEF
X-Gm-Gg: ASbGncuTUAyupJ06C89LxVatepFK2/Z03OO0hyImfVnRVH0J+fppRVdmsDbuMSLFQ4K
	qcWgKtWH5q5vAIRQUwibF0n2+Xv+cGP+lCWARtCGSjTI6rTJjQoQxIx1iN8k26FbrxHywM9/d2a
	tRABzdq/tnMP1de9Jvlq+dFFqhizlMy4HHutElAntZjdYJyEFg4SicOEikBAaAWF4L7snfq6fGS
	3CTIp/g7zGYTiPJcoGHUw4XOrONtzOqER5OHVePX5WegCpqjuY6GV0jkCGqG84GV6yBoeRoiNpW
	xDZWcMCNB/9IrlWsIGRu7Fa0vA==
X-Google-Smtp-Source: AGHT+IEmUNzDi+nUvk1WdtulUkKKO+WUuH7mcTu8FAK/P1b94QWfxgOZIDVLrQ8u4ieBXR4ho/DH7Igt5nxKj0II1Hc=
X-Received: by 2002:ac8:7e94:0:b0:4b5:d6bb:f29b with SMTP id
 d75a77b69052e-4efc6b0dda5mr5698181cf.8.1764173488435; Wed, 26 Nov 2025
 08:11:28 -0800 (PST)
MIME-Version: 1.0
References: <20251126034404.2264317-1-willy@infradead.org> <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
 <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz> <aScXSEY7v7_fcEZF@casper.infradead.org>
 <44f4d9b7-45e3-4d2e-b1df-cab8e254e54e@lucifer.local> <CAJuCfpExY2wYk=TuWEGGgyh3YOJyi2+4sPVd4XfNb7kZeRr2Rw@mail.gmail.com>
 <3d069afd-a19e-4ee7-bbb9-7d15b065ab1f@lucifer.local>
In-Reply-To: <3d069afd-a19e-4ee7-bbb9-7d15b065ab1f@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 26 Nov 2025 08:11:16 -0800
X-Gm-Features: AWmQ_bmMH-eupCqIRkvK5PDEWly5aeDohpOZHdH9KL7hD5hZ7re3ssm5zGtQEos
Message-ID: <CAJuCfpEajhjsT0Y5sYiNGALUDMr+t3A=VvqsVzgYUvkHLdTW3g@mail.gmail.com>
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AEEE140014
X-Stat-Signature: xbhzpr4rmaf5td58ohr96egfkadydgyq
X-Rspam-User: 
X-HE-Tag: 1764173489-548643
X-HE-Meta: U2FsdGVkX19ULK/EPUzgQU6B4wp/iUDwor9w3FQvQyAN3OE3D/2bWBo8xyeBnkd8kvKwLUl+IdAaE9CYgxvQ3GgeHH2BykM/S1TEIZSF478WyN8lC3FVMCK8OAclaegfmGlwb2+U0gkR9+BA/NoFRNK06cQNFWp54sURnwoZVE2NSljlbahYfOzMbgcNDiL5hPV1ArqiiDWX44gYdN+MeWgedYbzTrN7tkv+PRUOznmEBSGr2H2aOV/GENWt6GQC6OgCGAL7lgeSR2sa7sRQI6F8X64fBCAaAbEKvgEGb45dv9sjqn4d7MJMypA62h/NyH76fCOnl3VDG2II25oqO+zQAVoOgH+kEGBaRol6HtLgTLkfUbyZLFx5CO5WVzckzutd5hP2ZxBY3Qnei7IhxjYjt4DMfG4+Om2YGW1eEbxog5zhzltG8/ReRo4MoI5+DNmqHBaC8v7zTkPF9RMVLF8Cupz7hF2XlOZMP7MGawTf+asHMb5scmn1CiWz2qX0QurN6jleDXXAlIxslTM6JzmOrcfmEO6QP9EIL6GaImqiq1pDpMB5K4v7x6Z3rkhKBylLnahGfmF+yNBFfO4P1Zgg4JjH22W7VwXEtELUhmWWKJl6GGfTMjTuFWpFMq0HZ9A8qTRsb2xRgThqk4in6ZdTu7FmgHbZOp7PTbXjPF8ZECPIhR16J2LULynx2M8s28iapAotb+3NLgdslWCxz3zK9rqRmhIpU2o3qWRvkuQvPDIWrr4y6Lxlp2kKciwzunavrh8oOx8Wyuav4wIB0YDN8SHWpKpmE8MFkvWrYm5SdjUV/S0zZ1v0HMGUPN+GKgZV28PChWRc9axqmyzIOko06PG6uG95j0/ehXrNFFUHicCoMMeCDK+pdGHUPOxEajGdb+wdZw02O/yHiOu03GldiVHOcqL5C1SNs2KsKQyVeQ1gg61KpVGdGUqmoSjRVa2GqsOYJ4yvO7Fy7AS
 v1zRZbcR
 AIHKe+ENbvEpxim1WCGh6c/fwCMoyESxT7opQUj/0HNsx2wSktNe1FD3l568YKFX4ksNw7hPG3L+OqiLd0cEzkVYOV9NPdcbRWWIcyt4urqmsNE1u2qxZBtqPArqHoODhumTfz1GyS7Ob9CkCiN8CAltM/jwLh64VJ/9xkQpH2dXqPlJ95dWyDnhwtcSZl60VuB4xpFwDiBEzjq1Y9GRj8cmtd0yY7frAfL9w/MxPmwjgmhhIpt4I5n6RbWI3gAhXxeQ047Qrcr+Ze9MUIM5GkQt+h1AnPZnuLP/vgiC1T6xvMEAnPYpThSGF+SUUhK5USUHc7d0id/lJULz+J4z8Jyprtwdna2FWVwr0W/fFtSUko1TPTSmoR4PLZ4oFlgHTh6X1N2yT8z/TXztFsILDH4tehiallUjHRnSp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 8:01=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Nov 26, 2025 at 07:49:13AM -0800, Suren Baghdasaryan wrote:
> > On Wed, Nov 26, 2025 at 7:20=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Wed, Nov 26, 2025 at 03:05:44PM +0000, Matthew Wilcox wrote:
> > > > On Wed, Nov 26, 2025 at 03:36:46PM +0100, Vlastimil Babka wrote:
> > > > > On 11/26/25 5:28 AM, Suren Baghdasaryan wrote:
> > > > > >> Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this b=
ug.
> > > > > >
> > > > > > Doh! This is embarassing...
> > > > >
> > > > > Hand-rolled synchronization primitives are wonderful, aren't they=
?
> > > >
> > > > That's why I liked the original approach of just using rwsems.  I
> > > > mst admit to having not paid attention to this recently so I don't
> > > > know what motivated the change.
> >
> > That made it simpler to add SLAB_TYPESAFE_BY_RCU for vm_area_structs
> > which improved the performance of allocating these structs during
> > calls like mmap and fork.
>
> Hmm, we doubled down :)
>
> Hope the wins were worth the complexity, but obviously the horse has bolt=
ed
> and I should have asked more about it at the time...
>
> >
> > > >
> > > > > > Wait, why do we consider this as a successful acquisition? The
> > > > > > vm_refcnt is 0, so this is similar situation to an earlier:
> > > > > >
> > > > > > if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> > > > > >         return 0;
> > > > >
> > > > > But this means "vma is not attached" not "we failed to lock it".
> > > > >
> > > > > > IOW, the vma is not referenced, so we failed to lock it. I thin=
k the
> > > > > > fix should be:
> > > > > >
> > > > > >         if (err) {
> > > > > > +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma=
->vm_refcnt)) {
> > > > > > +                       /* Oh cobblers.  While we got a fatal s=
ignal, we
> > > > > > +                        * raced with the last user.  VMA is no=
t referenced,
> > > > > > +                        * fail to lock it.
> > > > > > +                        */
> > > > > > +                       err =3D 0;
> > > > >
> > > > > Returning 0 in this situation therefore wouldn't be correct.
> > > > >
> > > > > AFAIU since we started with attached vma above, it's not possible=
 that
> > > > > the refcount_sub_and_test here will drop the refcnt to zero. We c=
ould
> > > > > just WARN_ON_ONCE() on the result (in a way to make also the
> > > > > __must_check happy) and then can return err below.
> > > >
> > > > But how do we know that we started with an attached VMA?  Maybe the=
 VMA
> > > > was in the process of being detached and still has readers?
> > >
> > > So we're talking about:
> > >
> > > vma_mark_deteched()
> > > -> refcount_dec_and_test() [ ref count is zero ]
> > > -> __vma_enter_locked()
> > >
> > > (meanwhile...)
> > >
> > > -> reader attempts to read
> > >   -> optimistic check doesn't successfully find write locked VMA
> > >   -> __refcount_inc_not_zero_limited_acqure() somehow doesn't notice =
0 refcount and increments
> > >     (??? how)
> > >
> > > (back to vma_mark_attached() -> __vma_enter_locked())
> > >
> > > -> refcount_add_not_zero() returns true
> > >
> > > [ process gets fatal signal ]
> > >
> > > -> rcuwait_wait_event() errors out
> > > -> oopsies need to do something, maybe [VM_]WARN_ON() not right?
> > >
> > > Correct me if the above is wrong.
> > >
> > > I mean is any of this actually possible...?
> > >
> > > Seems dubious. But I guess right now we assume it _is_ possible. What=
 a mess!
> > >
> > > (Again I wonder why we made our lives so difficult here)
> > >
> > > Anyway even if we are midway through a detach, the detach is ostensib=
ly waiting
> > > for the readers to go away, and our reader is about to go away anyway=
, but the
> > > process has a fatal signal so do we even care?
> > >
> > > I actually wonder if a WARN_ON() is warranted to see if this even eve=
r
> > > happens...
> > >
> > > OK just going to reattach... my head which just exploded from the abo=
ve :P
> >
> > We are overthinking this. Vlastimil is right. If we entered with an
>
> Watch Vlastimil frame this... ;)
>
> > attached VMA (which is the case due to this check:
> > https://elixir.bootlin.com/linux/v6.18-rc7/source/mm/mmap_lock.c#L60)
> > then the only function that can detach the VMA from under us is
> > vma_mark_detached() but that function can't race with
>
> We hold the mmap/VMA write lock yes, but as per the comment in
> vma_mark_detached() + above list readers can spuriously increment the
> refcount (ostensibly) as per:
>
>                 /* Wait until vma is detached with no readers. */
>
> So doesn't that mean we can hit the issue Matthew raised?
>
> Otherwise there would be no need to do this dance in vma_mark_detached()
> anyway?
>
> Maybe I'm missing something.

No, you are right. I realized after sending the reply this temporary
refcount from the reader can be dropped from under the writer. Was in
the process of analyzing these paths when Vlastimil's reply came in.
I'll spend some more time stairing at it to see if we are missing
anything else.

>
> > __vma_enter_locked() because both functions are required to hold
> > mmap_write_lock. vma_mark_detached() has an explicit
> > vma_assert_write_locked(vma) check (which implies mmap_write_lock) and
> > vma_start_write() calls __is_vma_write_locked() which does
> > mmap_assert_write_locked(vma->vm_mm). We can add a comment here or an
> > mmap_assert_write_locked(vma->vm_mm); at the beginning of the
> > __vma_enter_locked() to make that obvious.
> >
> > > Cheers, Lorenzo
> >
>
> Thanks, Lorenzo

