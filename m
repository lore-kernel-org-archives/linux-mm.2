Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55ADDD778B1
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 01:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B35606B0578; Fri, 23 Jan 2026 20:44:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0CEB6B057A; Fri, 23 Jan 2026 20:44:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EEBA6B057B; Fri, 23 Jan 2026 20:44:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FE8F6B0578
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:44:19 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62FB116016C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 22:07:57 +0000 (UTC)
X-FDA: 84364616994.11.12C445E
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6E77740002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 22:07:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="LgYASx/F";
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769206075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZSAAHeHiUR5FnBeJkK8QZrK4YM4qpJPJNY1MlgLuKY=;
	b=lDwAFRCM9bREHS9IXYDIhpJROF1Ucts3+50wxv1bl2WFadyIN2jWtWVZYfQDUuzP+z/RDe
	DOAuN4ODehRJCtBIXdsj9rpxcwujZ0yqkooyuEf6lyRUGCk+NnbRuxcpmufA5Lobx+mMwW
	IsmMyeR5bWoESITZEFpVCARLDIlYeUI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="LgYASx/F";
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769206075; a=rsa-sha256;
	cv=pass;
	b=NKPTAdTZnEYIcus24BmgI3RdRugRIc30gV1IFRgF9d2hk1X7dgx55F1I+ADfazeScHIYwG
	+Kdcvz9AFeBg8HSZoMgEEz/AvRz/y1VPn8QLZQXqLUDm7H1R99YDr+0bCJ5wGKywQpG8/P
	kBdlRG2tgqeR1mVx6p/rU9y3psBbvAQ=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5014b5d8551so136451cf.0
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:07:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769206074; cv=none;
        d=google.com; s=arc-20240605;
        b=F02qwkGWNrifU5NuYPXW62fB69FJQUUFnF2gPfIcWfBVJ3VzkyIlEA8lVCLXB2CeBE
         N8UAf0lA2GxZPP1f3sw5GZqdRnIsgMVzcmn4X2yntEPfVjgWksVtug5aGcj3ELDWeqP4
         zIJq5/eFYvDPTDv6tKcW5c/S/O7Enr/1rCHLA5y+h2xeep+G4hGaClexNgNZYxpzSbTI
         Jw5IF3gTL0DjGIwHfiuZMWb5KpoHkWkaofwWJiPs/opSd3kO3wGFXgPocL3ZYEHFNyax
         oPGvEwrVGqn12SQRIe8GTKxmI5nNp7GMwyu97wwJpgvQ8yDcVRWoAIjiaGRwDgPw2C2b
         BxCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AZSAAHeHiUR5FnBeJkK8QZrK4YM4qpJPJNY1MlgLuKY=;
        fh=yfF6EJ/90iFFdjc2d8WWe0t7D0GRjVuTh6uCSbC8dVA=;
        b=RcSgPyyBZmI6cZPp6xpbVmB8a1wtRvEQcMCf83cwQbwA/JY7h6Lue9yk30uHinNd/e
         7P0c3uxFoIOH1BhAQqDaU/JE1lyZarKht7x9ZqUGozvaGaeezqOghQ7yW12ArtVIBANy
         RivnyNEPA0Wniu2HQjAziYMHA6K5wZB0PU8OKs679qKYgW/zxpRSXCZ8tNHseLZgi1zM
         0Jsx4uJNBrjvnSreM+jt4F9IAanaYHXoLAXsKoRuQWZ3IvHn2GAP8XBkiqEbCFBo4cQY
         g/igSO45v6ihhi0+pm16HtYHSuFS5X2vx97iWE+qhWNdCerug638oL67zGf0CNC4fKHI
         1w3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769206074; x=1769810874; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZSAAHeHiUR5FnBeJkK8QZrK4YM4qpJPJNY1MlgLuKY=;
        b=LgYASx/FrqglTyHvnAkbVbHm6h/SfIEEp1ri+BwXpfgo42v/vjdvNwPccdbF8YcHN2
         j3nhOw5csjVSORJkvA++XCJGIq58T2/U7VBSW6GYtYMR2AODDwxu/lbkPXCTOuC5i4iJ
         Y51sRRVNcw1bSfx4jauKcRjc3OBZJ1tDcGDgxCxFLh0zFl7GhxT4DgGoiHXkXegMeZoo
         zB8wjV8OVziS/mhnhVnIt4LFM5+pVv32Hz9KMoRG0MM0qWl8SPveUOrYeBzMyMYYZJXP
         +Ewkt0UuDMoJjSy30ItMPZ8j6D8wZ9mLRlETooYoIia5rF38S4Jr8hvcqbUtl2a2iewn
         nF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769206074; x=1769810874;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AZSAAHeHiUR5FnBeJkK8QZrK4YM4qpJPJNY1MlgLuKY=;
        b=jU27RaqsOGCWEaU1uAz6+apa+chvzJWp4/qjxMwu36B0FEybVmGv0USSMouLaNhzGD
         BLu9sSKfA1wYPZejnDw48YL2K1di6LqZPQZl6lYPEvo0YheTn5psWa0sl0SFrt0hSeJq
         PPHyhJuZdmFEMNRkS3WXBc+cngkESRHREcJAu8HMYrv75M19wAL+NFnjbUqFPEYptf+4
         +Ph2vy0RoG9/TfvVoqET0dTL4GMdJs3utc6PNFFzNR3sY/dvTY1E0dimSJ9suYEchcUX
         inl/ivRsuIzvULrlZ9qSfpJ/Y8TxYLvCFAWu+bc/3xj5m3fQELzbZNit1bRddXR5fRBg
         /L4w==
X-Forwarded-Encrypted: i=1; AJvYcCXuvd5FYJoQBxChQfy75ugKdoqd9hSv8sXLH27KQOdbATKZEYyzWXEd0VqGO66U7FagBM+GmK+Imw==@kvack.org
X-Gm-Message-State: AOJu0Yyc+uVEu7mPn+DEuAajP/ziaQL4c2ex0BLPtzEonvIF6Ou8sIq5
	XdOMLqUOzzijp+c5LpWUTjdIrvNEv3znPVyuY6bSjWDiZ2HDK1wSIMskpNjthOi1rlQxUXIM4b7
	mYA7yiqP97CSBea7rOJnaejg0pZCPIFJ/PO43TTzy
X-Gm-Gg: AZuq6aJLCH6wW/xjRkpK0reIRdU2AlxQWC3pFx31H/JEGqYfxSuUEAb3ktIV3G2L6PJ
	9a5OKZ/yN+Qr/8cUCmSgcAJFIHhrzWKNXmIt/ZKX7sWM15dydi5S2B7/nJzqSTmr1jJC2Rit904
	MuCniP3D8sI6FXpujJ0V3k4Bt49XpDCCf5YAdoi5WEzKv8OPKSVWUR2nwho9CMBeCE0kBxKW2FT
	jjHJiwXdO0F9Ks7X6etnCEAt2jOfvlFqdn5FVzmtbmwpwT8FqvOhGddIltLKeEE674lgg==
X-Received: by 2002:a05:622a:4d0:b0:4ff:c109:6a4 with SMTP id
 d75a77b69052e-50305143330mr2954461cf.4.1769206074080; Fri, 23 Jan 2026
 14:07:54 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <4f95671feac6b6d4cea3c53426c875f3fd8a8855.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpEULwMTxAzxUdzfpHe2=+umXL6HFMvydkqW=tP8mB2ewg@mail.gmail.com>
 <c7c8158d-e360-4a29-9e48-f2b45b9ca147@lucifer.local> <CAJuCfpFbsAHr76ZfUEaRLzdxQMDjPEP+bsLNC35X9t53G_uqAg@mail.gmail.com>
 <c4d64bde-831d-4f3e-9b92-68c1beb70599@lucifer.local>
In-Reply-To: <c4d64bde-831d-4f3e-9b92-68c1beb70599@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 23 Jan 2026 14:07:43 -0800
X-Gm-Features: AZwV_QgjcSMn75D2UlaPVIofqLooCOJZrIcpFa1j2O9XtIxpcBLbSXHQEa8jXh8
Message-ID: <CAJuCfpE3D8XyR5wy+Zzq7TX5am=q3SrevarJaf6Z7-k-9CkmkA@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 07/10] mm/vma: introduce helper struct + thread
 through exclusive lock fns
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6E77740002
X-Stat-Signature: wtiy1e1gdkanbf7b7uhg8q48gwr655yi
X-Rspam-User: 
X-HE-Tag: 1769206075-537089
X-HE-Meta: U2FsdGVkX190Xgwsm27RCAvm9kVJYFjDfOllbuuAaWbbOF7vz4AbGjv2NmxZSoAqXE5p+YaX57AvCizFzvy/XkHMzkDHHepor4UJvjxVFAwOykMmLqgeM03/vjLGvbxEHD+gJlhntjlv1an6WBRiutfcSkq4nUt5BpNYFW+5vjmDhpQFv6kmJeO3H3kMXvVYlFErWHGoR1eyD8Fjb129QWWGnvW3c1X9pxJ/ckwRA51RnnH4lB+ZjhYx1X524xJhybKcRKsvu0kQoTEHjDW7KDbLAX3O73ANyGwaan2jjoE308YopSbHsg/JQwQ2lAKCGhGaP3l/3+vkiqG+BKKAJlALmFY2iXjJv53W7YSWd1J799L8ZEB0yuTF+OgrzIJAkLrMLcDISvMlJXh1UECs9rpEJhCFoRfKyEXC8oUvoCiboTmN+ndvj//F+q2p2helatIM+Jb6l4+bxR6H5IezRVY+OUQKmF8yAP04rLbSa3Nk58H0d+aPGqpKgPBFO1CnoQero2UFxXl7fKDyr8PCzisM3XKNxfn/s8qy8Nubg7UHFyub++4A2iFZDqOhaVwdOPV09hakITAJM5N3cLzJ2bIQpWK0ZQGk1e0zYht7A/LSbyEZyMPLCbGryM2f0cVH3I6vzUpuTUglTgorpL6Uf65wWFeYBVl9vG92+JhOlwj7yRyLo5RW3hlNOGu6vp+13jII0Ds9jHutXFjhsDWgJ8fe51EhvA3QG114pwj4qZTxS5pkano3C2VluxUSOC/7YnbFspYh9UG2Q3wsrQb06AIa9QYqQOqHiMiptXNElrPp8IIUnrxEMkQxSf8u6IqX4J4gZsU1x3CZDlIJchgigzm2ceupxbAhzerk8ZDFa0WS/bO4F4tsFIR2NiIwazyn7bAem/2YjY1LzzvazcBzaB12tbKZbHbWX2sTD35OA1jdnaQmCLzSbtb0Ziq8msKApbaktnRR6H6FRqmsnC1
 lmkgFcj7
 Qy2i2+7t0CYc6TNSUFynCIC4a4WgpC1fr2sx1YhxfOb+VOem/ZherDUF134KE+k0n1ADDWg3Z+WNu92uDAvbQvjEEwT6WANMEWMEyr+0yn+4e/5iDAgSApqKqV5JCwv/p6d0CCz9P9souLrOGCLeumK0dRnHUrKxndoMmAdQdL8P1x3/5oxoBM6hFycnAQOKTpMSDHjQp4ylHiV+lvB/KOqCsZVvhlXqx6AgN6ci7i5PH7ztTU1/l+s9Yt2+miEVuFinuN04hu25J7NLl95rXn1iED4Z/OdWWjEIJ8gyCnhdXhGonn+U9d1QfGjU9wJ6/MlMYvW19WSLVxcg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 12:04=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Jan 23, 2026 at 11:34:25AM -0800, Suren Baghdasaryan wrote:
> > > > >  int __vma_start_write(struct vm_area_struct *vma, unsigned int m=
m_lock_seq,
> > > > >                 int state)
> > > > >  {
> > > > > -       int locked;
> > > > > +       int err;
> > > > > +       struct vma_exclude_readers_state ves =3D {
> > > > > +               .vma =3D vma,
> > > > > +               .state =3D state,
> > > > > +       };
> > > > >
> > > > > -       locked =3D __vma_enter_exclusive_locked(vma, false, state=
);
> > > > > -       if (locked < 0)
> > > > > -               return locked;
> > > > > +       err =3D __vma_enter_exclusive_locked(&ves);
> > > > > +       if (err) {
> > > > > +               WARN_ON_ONCE(ves.detached);
> > > >
> > > > I believe the above WARN_ON_ONCE() should stay inside of
> > > > __vma_enter_exclusive_locked(). Its correctness depends on the
> > > > implementation details of __vma_enter_exclusive_locked(). More
> > >
> > > Well this was kind of horrible in the original implementation, as you=
 are
> > > literally telling the function whether you are detaching or not, and =
only doing
> > > this assert if you were not.
> > >
> > > That kind of 'if the caller is X do A, if the caller is Y do B' is re=
ally a code
> > > smell, you should have X do the thing.
> > >
> > > > specifically, it is only correct because
> > > > __vma_enter_exclusive_locked() returns 0 if the VMA is detached, ev=
en
> > > > if there was a pending SIGKILL.
> > >
> > > Well it's a documented aspect of the function that we return 0 immedi=
ately on
> > > detached state so I'm not sure that is an implementation detail?
> > >
> > > I significantly prefer having that here vs. 'if not detaching then as=
sert if
> > > detached' for people to scratch their heads over in the function.
> > >
> > > I think this detail is incorrect anyway, because:
> > >
> > >         if (err) {
> > >                 if (__vma_exit_exclusive_locked(vma)) {
> > >                         /*
> > >                          * The wait failed, but the last reader went =
away
> > >                          * as well. Tell the caller the VMA is detach=
ed.
> > >                          */
> > >                          WARN_ON_ONCE(!detaching);
> > >                          err =3D 0;
> > >                 }
> > >                 ...
> > >         }
> > >
> > > Implies - hey we're fine with err not being zero AND detaching right?=
 In which
> > > case reset the error?
> > >
> > > Except when detaching we set TASK_UNINTERRUPTIBLE? Which surely means=
 we never
> > > seen an error?
> > >
> > > Or do we?
> > >
> > > Either way it's something we handle differently based on _caller_. So=
 it doesn't
> > > belong in the function at all.
> > >
> > > It's certainly logic that's highly confusing and needs to be handled
> > > differently.
> >
> > Just to be clear, I'm not defending the way it is done before your
> > change, however the old check for "if not detaching then assert if
>
> I mean you basically are since here I am trying to change it and you're
> telling me not to, so you are definitely defending this.
>
> > detached" makes more sense to me than "if
> > __vma_enter_exclusive_locked() failed assert that we VMA is still
> > attached". The latter one does not make logical sense to me. It's only
>
> I don't understand what you're quoting here?
>
> > correct because of the implementation detail of
> > __vma_enter_exclusive_locked().
>
> Except that implementation detail no longer exists?
>
>
> Before:
>
>          if (err) {
>                  if (__vma_exit_exclusive_locked(vma)) {
>                          /*
>                           * The wait failed, but the last reader went awa=
y
>                           * as well. Tell the caller the VMA is detached.
>                           */
>                           WARN_ON_ONCE(!detaching);
>                           err =3D 0;
>                  }
>                  ...
>          }
>
> After:
>
>         if (err) {
>                 __vma_end_exclude_readers(ves);
>                 return err;
>         }
>
> So now each caller receives an error _and decides what to do with it_.
>
> In __vma_exclude_readers_for_detach():
>
>
>         err =3D __vma_start_exclude_readers(&ves);
>         if (!err && ves.exclusive) {
>                 ...
>         }
>         /* If an error arose but we were detached anyway, we don't care. =
*/
>         WARN_ON_ONCE(!ves.detached);
>
> Right that's pretty clear? We expect to be detached no matter what, and t=
he
> comment points out that, yeah, err could result in detachment.
>
> In the __vma_start_write() path:
>
>         err =3D __vma_start_exclude_readers(&ves);
>         if (err) {
>                 WARN_ON_ONCE(ves.detached);
>                 return err;
>         }
>
> I mean, yes we don't expect to be detached when we're acquiring a write.
>
> Honestly I've spent the past 6 hours responding to review for a series I
> really didn't want to write in the first place, updating and testing
> etc. as I go, and I've essentially accepted every single point of feedbac=
k.
>
> So I'm a little frustrated at getting stuck on this issue.
>
> So I'm afraid I'm going to send the v4 out as-is and we can have a v5 (or
> ideally, a fix-patch) if we have to, but you definitely need to be more
> convincing about this.
>
> I might just be wrong and missing the point out of tiredness but, at this
> stage, I'm not going to hold up the respin over this.

Sorry, I didn't realize I was causing that much trouble and I
understand your frustration.
From your reply, it sounds like you made enough changes to the patch
that my concern might already be obsolete. I'll review the new
submission on Sunday and will provide my feedback.
Thanks,
Suren.

>
> Thanks, Lorenzo

