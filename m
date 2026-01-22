Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB6E1D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518066B0346; Thu, 22 Jan 2026 14:42:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC1B6B0348; Thu, 22 Jan 2026 14:42:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3525D6B0349; Thu, 22 Jan 2026 14:42:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 046AB6B0346
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:42:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC24D8D289
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:42:09 +0000 (UTC)
X-FDA: 84360620778.21.99B6736
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id B67E7180002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:42:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sEfI0Ka2;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDMqkjXmmPWo06N2pnPKq0+6xyOjYYq00iRwl37j1pg=;
	b=YWCDXW+XetVwNQqdCL6/tIbHfg8/UREso0szThbeSV5kFvCxy0L6gqbhBPVOXKetqFM/IM
	gZjkQA4fHoQI2o0yUCsDf5avLiVwHv05bJsE2zl5hkgOu9UGLEtDdfPxujBZLPIXKEg/EK
	9kRqch09U1mHrzQXIaRcBE1YYyuEh1Q=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sEfI0Ka2;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769110927; a=rsa-sha256;
	cv=pass;
	b=tn84AdVpwjhoss802zuFU2PalyWuB3hak/HkZ4PJeJVXLAlyGN2iM4p+oteeK7hVg07EOH
	77+ho7QwrY37GoAXqI3CZ39ItdNZX71De0wHtx3OD5baFMlvTQIUieBuSLkOc5BC9MCogm
	Zl3XSjoiUfhST74roWNUR3ofyWBLDFk=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50299648ae9so44391cf.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:42:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769110927; cv=none;
        d=google.com; s=arc-20240605;
        b=IT9u64BW+67DE+2B6yuJ7HnW2NIvPDtliHFXmjGOhfltZFsS/265Thvc9Vv35Vt8Rm
         L2+bLkSS7/gakKg1RV5ipYr9DHqG2Q8c0Akdf3XJaTscAjnAN9uo7NYT2B1KJhNmv6zj
         /S4oiMhhQOFZ10HGH1c/wAuyfxTCNG85YGvSdapMD0fWiGNL9+ePb/MQa8eao6FUZoY5
         DFpe0lWXCWtPPr6nKyXGjn7k2zyt0OHJ4uPxUeQMQoPrqM9KYuMJFFRLJWYHoVvRjFwk
         hy5xSkGtvQRrmWTTRuV9FxVQaFj7vt6DBVk0LW7nPy6oCsZjarXrWFsAlCMh93u5NpFL
         /1UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fDMqkjXmmPWo06N2pnPKq0+6xyOjYYq00iRwl37j1pg=;
        fh=CBww7zUagrpGunpVeLBlECdbANzX8dk1JuTHHVMVYRI=;
        b=jEuum7UfCv8gxu+npt0F3JCMP3ICDcvg66Ye+Jt1+F6dbL6U7/3+HlNrxOfckk6BtY
         Hmbp78V1qi1nBDKiZKszFC+Bf8zpDbl68f7ELNcxRnc4wAIpKngrS/l+rSp3GSOACoB5
         1oLWCn384WSVk2xVLcUADE7SBrNNn3jO+yNd3la90Fue3h9Xk3eMfnvamkOrxOP4yvfn
         7b4uZIMXd8NTz3TR5VRBlXcCiv/yk3ggCEXr0mOBDxVPu7Q2UMzvQWYOoSOTWnyiNqNO
         khN/MASyKV2nMTA8CKg34/xxAi0M3JpBmgg7rH4pzRVF3Zs7Eu0esACxuHHF388dGw7c
         yXcw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769110927; x=1769715727; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDMqkjXmmPWo06N2pnPKq0+6xyOjYYq00iRwl37j1pg=;
        b=sEfI0Ka2Upp/sA8vokIo8KtYFcLGsWknBtIVfCYPVzExKNvo+Xl3FyoSV/YLFUVxvH
         UmT07k/leaWJdz7e1pczMp2IMU9lvv7q5FWNA84ICoQAZmcPeKudsQsHYHDWrwlwbBTf
         j9yw4DLXyULyNMEZk/ucDQK9NQMqBqQG06bjmLz3yskvF0YK/vI+BaQtqEobAIqVOzWM
         oVOC5Iy5gMVRHv33FVCt9QcjWqcVULGJF6JlKCH2Iqaw1aSECmknF/PjmoqkavorS93H
         ViMoYHHok9p6IGYWY7r4dW6v1osXtEUoR4FB54BxBxXr4gNpjgpZZ8Uq0/9ls4I34TTG
         RsWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769110927; x=1769715727;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fDMqkjXmmPWo06N2pnPKq0+6xyOjYYq00iRwl37j1pg=;
        b=NWUD17wEJOaG+0AEl+OOVDuOjhUOA1HXYdF4xgRUXrPV1ZX4RJLpfx7IK0lr9NlT6M
         6em+IsveJwrAcxKj74bfS7IS1SaKZwIjccoCBRAtsPNkKksjloTNghqnuk8kFvwQY7FL
         vlXkzbniec1vIBemoAkR5I+vAv0NZrN/85fPzKH+XFV1crsRwLKwMRD1nY0Jtkmq9D7W
         1+QqrjOW+se4aMx4Vmecj/CgA2PoiNHE4iHQvgBceNz1UpOi/Iwqb4w1IxAjE6uEtSfq
         a9EZFtxJbkbJ73gxZPv4GmFyAsv1TwzQMuBGrV+EIcdSWqVlGf+SlNFRW5jt9Jloidl8
         HKSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcwAeTcVpTtaEr7oVvrARjEveSdFE1ctF0w4xyXtnZBYJEwRmAOZUJwr2rdVl+vP8XWx+y2naIHw==@kvack.org
X-Gm-Message-State: AOJu0YwyuZNPRn9AGNJomTsW/pz4BlogKfoyemmWqaNLcflCMBd2BoMe
	8jVzi0pDy+a24QEZilO7ys5GzfgKCFndgCoZiLqmwgat4J6IjNV9gWRZ3WvFWLJ7zzIkmVGoEmR
	UmN4CUTQ2qCxlA7JFNJHY3iYp+OZbPDoqZuYoFadq
X-Gm-Gg: AZuq6aLnlmVg+SW4TQ830u1tqmLMmi7TGHXySOe6AK75tFNVOjxiyjD2F+aEslrg1GL
	vl3fyHBSEull70VokK7rOgWduqZmne2zsNkR/gIhH5AnV5ICegwfu2n332Hx5t/QcI7YbY8gCeA
	sFrVnLK9XqhQuhM0kVRHXbKZAQV2XaVJRbqzljqGFoFt2fL8fvWfu0Q1qGH1Gqp+8E7PPARPzYH
	Y+dRfn9b/I439h3vnRlhTFUnnKxz0ODK0d51als9havJTwOjF4psdwfaX1GOMWYQjc32f+WsXeY
	bWy2zU4IC5hIbWwzfVP2IK1s
X-Received: by 2002:a05:622a:1189:b0:4ff:a98b:7fd3 with SMTP id
 d75a77b69052e-502f80081afmr1484221cf.2.1769110926423; Thu, 22 Jan 2026
 11:42:06 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <4703b7320796908b9a0827c3d42d74d11b703714.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpG+H=gRSWuhLL=NHQAQzrbF8Jku2qgRHv1moLPRibk5TA@mail.gmail.com>
In-Reply-To: <CAJuCfpG+H=gRSWuhLL=NHQAQzrbF8Jku2qgRHv1moLPRibk5TA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 11:41:54 -0800
X-Gm-Features: AZwV_QiG6ERyAk2e30dd4xem0NB6YP41YIG43gNM9PVcgxPRGOqPuE--37BQxdE
Message-ID: <CAJuCfpFVqmHnUVxZZLgeCv7QdPUH3Bv5tM=uOzPWuQgnx2zFvw@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 04/10] mm/vma: add+use vma lockdep
 acquire/release defines
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Waiman Long <longman@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kgn4ey9p7r8k4ewcoffc1p3bnm73i869
X-Rspamd-Queue-Id: B67E7180002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769110927-200635
X-HE-Meta: U2FsdGVkX1/A7BU9KGuDqyJMOkJeriet90icmefQLRii7+3dPcQq4AP+K5uWVMkfK2vAcRiaz0NP7if8eFXHz/HLhXynIG6Hr8d15Cceo8ng0kJgoM34d+5QbU8A8ap4oAVY3cDGslHQnEz7oWXTON6tHveoMMrsKye/q4G1WDUG7g+WMl2tdGOc9KvefaaNEyHWkuALXd1tzSMLXuheBohngQzke9oH2gziagiKCVThmqRuCkA4XnA13vHWcG1oTdFeQk3FOMGLA3oAJOEGQkz3yXYuL9WGuDr8YUOf3uus5H3xBpYa/V8/p6W5l6lhy8CR23ipZQuYI6qKufonKGIru5RpAJ/G5qLfPgrjPzvRjvFG37Uws1Tr6juTAw8n/lTVKjLsoYpRH2g0yygK8H/KHwQj8MTwzPlL1+h071rdr+Khv1u4WVvYv4BJ9X2DRfEoOWjCFegs5G+LoRvmnjdS/6C6ET3xQgVj5ivcOn7vvIlVabjG4+KwZcnGHqi7wz1h52tzORB+vGVbTJhYuDSEugF1+h43CjuH7rhUSMjJdTqvCf7+1et+Yl7wDlSKoNF+D13FT2G6atbv/8vQOmDFbXTM8xERdCbS7LpcDbP14GRM1jkDzMEOI+77Hd7csVVgnJJTLT52TG9CDrOQgMJj2QnS1b7ymX2dug8CvY7IRGnakm9E3adgIiei76Ty2qoHcEBqoY6Fy63iBxPi+ifHQutCqN9Tk7O2wPlxziZzHzaF/jh/Xkn2M1VozIzpzj5pAc8atLBSzq1/xJe8twiXAmBtSd9ocTQd5Br8kvB6QsbM8cLcEjlxLYMZJs7CI1ZHnyHqnnRmitGys+odov8FnAvrAo9Acvw3ASLK/HWjOmZrlAccIqRp2pA3jTCmEAG+HIUg8OKXBx8SzDJDHzwXjFUGaP8ImBtJwzRuEXmZ2suRFXtlTLX95c5JTUwypBfWixyJp3UL5eDZL5q
 3N3Kpsrf
 QSR64W8QwrTZO2uaKWAi/YFZG2RYiaBT5Yi8sueYoQJhLmpxdyUxKr2uUbXipeZQi9AFOhswJWhSP4yOYZnDntgqnfOL7+Nn4nxphS0z6cRVC+hrpEpqQcXx9yCTgjru9najstIcVGRyuYIcsMuvnM70DMKjrTZqJmMq3CtigShD7EQopfMMt37iO15TpV/0tkrDOH6W7WPer2BhlSV2fI6cJoOiumaWd14aGUzBe88YI3EjcFe4U5TSSuNLZWNvnNGzfXNGuxR47nB/YTDLj9otkRm1R7jeHleohwCkHe1jzbB2tzucslf9rqzU0qdAzVGUT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 11:32=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Thu, Jan 22, 2026 at 5:02=E2=80=AFAM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > The code is littered with inscrutable and duplicative lockdep incantati=
ons,
> > replace these with defines which explain what is going on and add
> > commentary to explain what we're doing.
> >
> > If lockdep is disabled these become no-ops. We must use defines so _RET=
_IP_
> > remains meaningful.
> >
> > These are self-documenting and aid readability of the code.
> >
> > Additionally, instead of using the confusing rwsem_*() form for somethi=
ng
> > that is emphatically not an rwsem, we instead explicitly use
> > lock_[acquired, release]_shared/exclusive() lockdep invocations since w=
e
> > are doing something rather custom here and these make more sense to use=
.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Very nice! Thank you.
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>
> > ---
> >  include/linux/mmap_lock.h | 35 ++++++++++++++++++++++++++++++++---
> >  mm/mmap_lock.c            | 10 +++++-----
> >  2 files changed, 37 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index 0b3614aadbb4..da63b1be6ec0 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -78,6 +78,36 @@ static inline void mmap_assert_write_locked(const st=
ruct mm_struct *mm)
> >
> >  #ifdef CONFIG_PER_VMA_LOCK
> >
> > +/*
> > + * VMA locks do not behave like most ordinary locks found in the kerne=
l, so we
> > + * cannot quite have full lockdep tracking in the way we would ideally=
 prefer.
> > + *
> > + * Read locks act as shared locks which exclude an exclusive lock bein=
g
> > + * taken. We therefore mark these accordingly on read lock acquire/rel=
ease.
> > + *
> > + * Write locks are acquired exclusively per-VMA, but released in a sha=
red
> > + * fashion, that is upon vma_end_write_all(), we update the mmap's seq=
count such
> > + * that write lock is de-acquired.
> > + *
> > + * We therefore cannot track write locks per-VMA, nor do we try. Mitig=
ating this
> > + * is the fact that, of course, we do lockdep-track the mmap lock rwse=
m.
> > + *
> > + * We do, however, want to indicate that during either acquisition of =
a VMA
> > + * write lock or detachment of a VMA that we require the lock held be =
exclusive,
> > + * so we utilise lockdep to do so.
> > + */
> > +#define __vma_lockdep_acquire_read(vma) \

One question I forgot to ask. Are you adding "__" prefix to indicate
no other users should be using them or for some other reason?

> > +       lock_acquire_shared(&vma->vmlock_dep_map, 0, 1, NULL, _RET_IP_)
> > +#define __vma_lockdep_release_read(vma) \
> > +       lock_release(&vma->vmlock_dep_map, _RET_IP_)
> > +#define __vma_lockdep_acquire_exclusive(vma) \
> > +       lock_acquire_exclusive(&vma->vmlock_dep_map, 0, 0, NULL, _RET_I=
P_)
> > +#define __vma_lockdep_release_exclusive(vma) \
> > +       lock_release(&vma->vmlock_dep_map, _RET_IP_)
> > +/* Only meaningful if CONFIG_LOCK_STAT is defined. */
> > +#define __vma_lockdep_stat_mark_acquired(vma) \
> > +       lock_acquired(&vma->vmlock_dep_map, _RET_IP_)
> > +
> >  static inline void mm_lock_seqcount_init(struct mm_struct *mm)
> >  {
> >         seqcount_init(&mm->mm_lock_seq);
> > @@ -176,8 +206,7 @@ static inline void vma_refcount_put(struct vm_area_=
struct *vma)
> >         int refcnt;
> >         bool detached;
> >
> > -       rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> > -
> > +       __vma_lockdep_release_read(vma);
> >         detached =3D __vma_refcount_put(vma, &refcnt);
> >         /*
> >          * __vma_enter_locked() may be sleeping waiting for readers to =
drop
> > @@ -203,7 +232,7 @@ static inline bool vma_start_read_locked_nested(str=
uct vm_area_struct *vma, int
> >                                                               VM_REFCNT=
_LIMIT)))
> >                 return false;
> >
> > -       rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> > +       __vma_lockdep_acquire_read(vma);
> >         return true;
> >  }
> >
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index ebacb57e5f16..9563bfb051f4 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -72,7 +72,7 @@ static inline int __vma_enter_locked(struct vm_area_s=
truct *vma,
> >         if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma=
->vm_refcnt))
> >                 return 0;
> >
> > -       rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
> > +       __vma_lockdep_acquire_exclusive(vma);
> >         err =3D rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
> >                    refcount_read(&vma->vm_refcnt) =3D=3D tgt_refcnt,
> >                    state);
> > @@ -85,10 +85,10 @@ static inline int __vma_enter_locked(struct vm_area=
_struct *vma,
> >                         WARN_ON_ONCE(!detaching);
> >                         err =3D 0;
> >                 }
> > -               rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> > +               __vma_lockdep_release_exclusive(vma);
> >                 return err;
> >         }
> > -       lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
> > +       __vma_lockdep_stat_mark_acquired(vma);
> >
> >         return 1;
> >  }
> > @@ -97,7 +97,7 @@ static inline void __vma_exit_locked(struct vm_area_s=
truct *vma, bool *detached)
> >  {
> >         *detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_F=
LAG,
> >                                           &vma->vm_refcnt);
> > -       rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> > +       __vma_lockdep_release_exclusive(vma);
> >  }
> >
> >  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock=
_seq,
> > @@ -199,7 +199,7 @@ static inline struct vm_area_struct *vma_start_read=
(struct mm_struct *mm,
> >                 goto err;
> >         }
> >
> > -       rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> > +       __vma_lockdep_acquire_read(vma);
> >
> >         if (unlikely(vma->vm_mm !=3D mm))
> >                 goto err_unstable;
> > --
> > 2.52.0

