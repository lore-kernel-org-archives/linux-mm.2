Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1BFAD11192
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 18:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F24C26B0062; Wed, 26 Nov 2025 13:43:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4EF6B00A8; Wed, 26 Nov 2025 13:43:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4A56B00A9; Wed, 26 Nov 2025 13:43:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C508F6B0062
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:43:29 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 936241406B2
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:43:29 +0000 (UTC)
X-FDA: 84153631338.18.71F33D3
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id B976618000F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:43:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=imDIeiG9;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764182607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yLPOtacZ//HsbFCrCmvCJYEqUcOOkshQ1Q+2V1twtrY=;
	b=u+fSewtuLeh3rcTmNZwbwmHp6dV4O1mPGxtgJJ2IIw3MIwWK5mtzfwajTv5rYEba0sEkdR
	9bgQ2BBNlO1t35wLo21VonCY6/UjWUYkcsbhxyb2zJzUDYSo2TjQDKlYCnCX7AaPgYTFla
	g7ys4bAZrlhgX3AJyw1+ZROJsyMsAqk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764182607; a=rsa-sha256;
	cv=none;
	b=sTUDD1d2ieOaP0UGoqL7vQebMG+HvoJ2f2HpIcJfZSDAyOo0A5IIeM9qvpc2KAx0qw4Z9y
	GtIVDmHwHQWWSYzxt9qSR2NoQ8smcs4Ba/GsCBlbwYteuWV/K20CMgiGJAmFrzsB9NlBkE
	fcc6cdgiDzLU4uG7TPE6cHRdqjgZNz4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=imDIeiG9;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ed67a143c5so29981cf.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764182607; x=1764787407; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yLPOtacZ//HsbFCrCmvCJYEqUcOOkshQ1Q+2V1twtrY=;
        b=imDIeiG9V64aBPqLKZJ6zrUnBi6A6BsS/VBymWDnLqHXpLpaeQNf6vMu18Dx5tdczM
         JmXu80P3qg7FClbNQftxwxIUdAConTVRthEBEWqyEqinBbequ47LCKlcuyUtkb+fx61r
         CPmRkRKV8tMhrlKw3bttNcuDpYIvcPZi6KpX8tMJS2TOxggwfGdWCXndxZQguko6FTXQ
         eyYtkF22iXidW6TBO+hroF2nBuPSFjUvc+t05D7PQKnFipUW2RrMiL9PXdG/D6RMYECF
         ODG80ljzkAQwk8AmY2NdJe3upgn/bIo0FhJv0QKkoGa1lzdUOWk6krKBC4hPBadZD+n5
         FQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764182607; x=1764787407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yLPOtacZ//HsbFCrCmvCJYEqUcOOkshQ1Q+2V1twtrY=;
        b=S6Ouo40+74AE5kpATnR37VTTNgAw4x0Zl2ZOoYdErKpGSuChgbpHJIat3om2IFW8Qp
         25JauLkDCcIeV4MQXYUXejXq6oWto1JGWkBWebKA/QxzgS2J8AL6T/Jrg0W6SCpFjxGs
         AK61ZnXhbsHsqCaVtm4DOhJgCR8EXtMF31SLArkG1ftIgdE/C+ct/BrEG1OOHRigwAvB
         zZiuPe8sZcqixUgU7ifH9aN0q4+9KBVPPJ/vNuQ299+yUMGk7Je0QCA4wRhfb7oCcofY
         CXQi4MetbQtzBl5G+m78lV1pJta3Bg6o/bLelF8M96ePdfn3+VX2+U12yG2FJXvU6h9/
         Aynw==
X-Forwarded-Encrypted: i=1; AJvYcCWe1mV+wf4nVF+NBwaNg3XAT/E1FiU8ARLAO/r4tv5PKa3Luco7yWjq1iGQcMWGS2nQpGtL++QvoA==@kvack.org
X-Gm-Message-State: AOJu0Yxs8mQ8bgx9pp0Ce3wwwqAa6er2WVzYNpsGBbSbPBMZoC1c6Ey0
	/3KhXMANaOT7yq0G+I5UOAA9zW0LkGzNXyL01yJRAlKsCFcNVk3QBuqvQMh8ITUT7dfQvYNI376
	gk6AOL0t7r708OqONq+jjl+BCqaiDn1c5VM52/Tu0
X-Gm-Gg: ASbGncuibVHif1WP9+qF69MO3xQud+o2nIBWrZNSL9i1oZSEBaZymD1LkNdiYC/wj+y
	IznajZP5LXiI2dX7wbLkpeSFYht5mVfcCK4MhGZJpOjkzEEfKZDO1tJxYKzkdB6Bf6RysfdEirb
	rGYFIKyweYT+mAeWT0SRywfSVfKfU14GJVmq7uSVXrZexE0S6zU+VRLqV6kdVKX7VAmgd7WHJs+
	PWQOQweGTXdcwTlREHNytC6RWzoIzx0fwto9TDZIwrJyObW+JoR+Kmq1wEip7fEVebDTEGa//c9
	PB9/6s5+3mxXiKO1nCvMm10=
X-Google-Smtp-Source: AGHT+IGKlbSs7aySmmA5hJcyeB4+paBvQvJXg6lkYaNjCS6GjyCfOE96jze4Ea97BSopPYlF6efFEJYjrVMJgKr5l9g=
X-Received: by 2002:a05:622a:4d2:b0:4e8:aa24:80ec with SMTP id
 d75a77b69052e-4efd0ca4ccamr252971cf.14.1764182606450; Wed, 26 Nov 2025
 10:43:26 -0800 (PST)
MIME-Version: 1.0
References: <20251126174500.2498895-1-willy@infradead.org> <c35ab0c0-97c3-4565-ba2d-5c418ecac593@lucifer.local>
 <aSdGvY2UzrXdR2e3@casper.infradead.org>
In-Reply-To: <aSdGvY2UzrXdR2e3@casper.infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 26 Nov 2025 18:43:15 +0000
X-Gm-Features: AWmQ_bk0FVGZf8A3HlZ4IUTDbpOSZroDuVgHqHfGNb12W688YBH4eS3c-Gs7B6w
Message-ID: <CAJuCfpHheus2oiv94r14afjVV00XZnfqHY0p+H8fxjxCSYjg9g@mail.gmail.com>
Subject: Re: [PATCH v2] mm: fix vma_start_write_killable() signal handling
To: Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B976618000F
X-Stat-Signature: cydpbhbjzqnpjhx9s1rnnu97wpc9f9ry
X-HE-Tag: 1764182607-652014
X-HE-Meta: U2FsdGVkX1/P3ROMIO2dcL+hTFYlHzadlODua3LyGJK35yHuzUWddyK5Qyva0Wfdk6RVEfASYZNo6PHYPgubfq9XaY263fP+iLoBQF1MtWjYSR1xQ9n80aLejj0LS+UjJIboxrfOkHHra9GCzWrKwIfVOWr5WnZ6aIMginVLIq5Br9YTSxUDod8jiFgLactHRRAWTJ8RcFQ7oJqL2fbcMneLirfK1vyCtZCYgnmilvEQSautZTdSLOJ1V17STln488uda/sNzEi/apPnIwo4m3bajy8BkWKUMwDzyzwVhUCudsLgP/oy5/xTgL8Td+t+42lgTQgtarc/p2NVtHBtpp7E/JFP0mg6De+gvwrbtOWiiEzVmY8MvdfuNYa+aPp9hZFiza9Ht1SjrGYiXEktEeIC9m04MrfiXek1P8geO2s75y+k6zofEhYXXvbfYiLrA/jx1QXeTBfSSNm0h2RL869gdOHIkXAnjIUXDv0zyjSVH6ngf+bf+xpfjdnUkeCJL3tCSOlV16RvGnIgRJgPkN8KKL5Ctiw2vze5YNmpEzOa9oeeTKi0qlETkeAnNtSd/XR2geghZ+IEPvHXEHIEqXrn3g/D4DDLQMaDyyDbE5nnIwFQKJrTmB9v1v6/n0hM9fAjC1AR0/XQsqlc4yyJXCEpy9IFCzxzXItCkaafsZdTD+BhJgJa62LiMbqAQ8raibeOcAWmSpfsQRUn/Xdh0t5CKkDaTotCbTbAqJZpONY7utp34wV9C+RprvGCen0TprQUfntjdFBOa7w9pVHxuvKlFbuOtBrwFk4R9s5n/vZ3gQGUAb6DR7tPlW9KZCHm3yrMvtJJEoqe1iqeeMSeV+emt4FQs/VEHHC51fSBxezdLNpoWjFHPKH4BhZ4JiCGxE06uduw4dOEl9c27EEg12zNSsrBx84X3zYwktXjtRRtNBqx770LO17k6XB9xvRNwoqTREMLauKf80z/JR9
 IyeLgAWd
 mJva9s4QSDHbdAasfAlUUkB7P3sJRgduckNbBjj953SOEOCVxfEqAJK/qMUbcSwfLkdZkFVbP5JgxugywTmCPJHTvEgfAr171KD5VWzdbwJrABl52wMr0jVqgeILEmOCCCL/7VXtLjYgMa0Wv8QuDoDmJOSrQ5/siH4ZSsQE/tvGZ0OQSdjbKIK1WoJIaZFtv0ttB65XF1+tgMIrY05YH52iyo5NOIePeGU9h0GYFVC/sKqlmR1MzovRCqny7JD8Z/mwPyYWPOy73ws7NQQ/eMD+M+jBeR9gT8U/uk9dKwyEYUK/di+cbOJmg5HIolyeeyQdpIRBzPvaK5qLEhaj3nwCMqeYlgdTR7Tk4Ybggt3KMVTb3BfHmCwJNU/kUpQlc7IiIyrxbLjDEuzYKxNQdtpvBfDdhZ8jQfZhi2k97BG+B3tAoGF3Yx3lO9lO1cRyZv3XOqUeC2YjcSacDKPuS/QfPhKa7zr8B6jBGd53DaAcqnkIQUB5qvINMoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 6:28=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Nov 26, 2025 at 06:06:53PM +0000, Lorenzo Stoakes wrote:
> > On Wed, Nov 26, 2025 at 05:44:58PM +0000, Matthew Wilcox (Oracle) wrote=
:
> > > If we get a signal, we need to restore the vm_refcnt.  We don't think
> > > that the refcount can actually be decremented to zero here as it
> > > requires the VMA to be detached, and the vma_mark_detached() uses
> > > TASK_UNINTERRUPTIBLE.  However, that's a bit subtle, so handle it
> > > as if the refcount was zero at the start of this function.
> > >
> > > Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
> > > Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
> > > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > Cc: Vlastimil Babka <vbabka@suse.cz>
> > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> > > ---
> > >  mm/mmap_lock.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > > index e6e5570d1ec7..3c9bf2f96280 100644
> > > --- a/mm/mmap_lock.c
> > > +++ b/mm/mmap_lock.c
> > > @@ -74,6 +74,14 @@ static inline int __vma_enter_locked(struct vm_are=
a_struct *vma,
> > >                refcount_read(&vma->vm_refcnt) =3D=3D tgt_refcnt,
> > >                state);
> > >     if (err) {
> > > +           if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcn=
t)) {
> >
> > Really think we should WARN_ON_ONCE() as Vlasta suggested.
> >
> > It's an 'impossible' situation so we should make that clear. And we sho=
uld
> > find out about it if the impossible happens... :)
>
> It's only "impossible" currently due to some fairly esoteric reasoning.
> As far as _this_ function is concerned, it's entirely possible.
> I don't want to leave this trap for the next person who calls
> __vma_enter_locked(TASK_KILLABLE).
>
> > > +                   /*
> > > +                    * We got a fatal signal, but the last reader wen=
t
> > > +                    * away as well.  Resolve the race in favour of
> >
> > This is very subtle, I don't think this really explains this clearly
> > enough.
> >
> > Maybe put something like:
> >
> >       /* Couldn't wait on readers probably due to a fatal signal, so un=
lock. */
> >
> > Before the refcount_sub_and_test()
>
> I think this falls into the "saying what you're doing, not why
> you're doing it" trap.  Whereas my comment is at a higher level --
> there's a race where both exit conditions are true at the same time.
> The rcuwait_wait_event() picked one option, but we would rather resolve
> the race in the opposite direction.
>
> > And:
> >
> >       /* Shouldn't be possible - VMA entirely detached, so treat it as =
such. */
> >
> > Before err =3D 0?
>
> Again though, saying it's "not possible" relies on knowing all the
> callers of this function behave a particular way, and there's no
> guarantee they'll continue to do so.

I agree with Matthew. Returning 0 here would work correctly even if
vma_mark_detached() starts using TASK_INTERRUPTIBLE and 0 becomes
possible. The comment also seems appropriate to me.
Thanks!

>

