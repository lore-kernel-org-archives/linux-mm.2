Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E682DD778B0
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 19:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 212596B0546; Fri, 23 Jan 2026 14:34:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BFC56B0548; Fri, 23 Jan 2026 14:34:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CBC66B0549; Fri, 23 Jan 2026 14:34:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAA786B0546
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:34:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CF558C095
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 19:34:40 +0000 (UTC)
X-FDA: 84364230720.02.4834522
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6CB63C0009
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 19:34:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=utrDlw9V;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769196878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4VBbAU8vd/2KklhA5UGdiDmofO3byk15wh5Af9y9vUQ=;
	b=yjvlrsubz8PG4z2jscnIa8c/EJBlAwG7ArHWO8aI36/JpPww8VRGc8jHDcdkjLCM4U7fnn
	NOh2oOaikr53l59c4k9WDIn52w1Dzq4GYBZdCdPHNKG2TG+1GNQ3IpvT/G8OFCMZk7T7pc
	56X6vxWW8/GnA6sz9P8FtLHQSBs6vkE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769196878; a=rsa-sha256;
	cv=pass;
	b=NrsjLPFjeRgBBxa0vZR8mRdmSt3CVSwSSXi5xZm9IdMc/nrh7xZX8hyac3EsbV5OeXBjWG
	e24GYJtsFjKkMKO5ZHk0PEZHxOMtfWGgowBBWjyC5wshrPXIiSRn8QAd0UgYi8T9EvQ6+O
	V/2B1xWdsxj+FLQD0PA2i3l9IhgObMY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=utrDlw9V;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-501511aa012so65971cf.0
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 11:34:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769196877; cv=none;
        d=google.com; s=arc-20240605;
        b=gZcvvU9stfvxdi+ilrC1cgRhE6IYARoJvAyO872Q+4nj8pL5GzdhzjGeAI22XFQMut
         pQPq935WmnjlclmLlX9wFm21oaFeI5gWVjel+n2ZzSAedRLuVUm/1yj6HvcVvJy/9PTK
         qxtEzP+pGqkjqky3VwzBXdCjWnq2dACrvHAkPq4ajvvutmYNnBc82I6hxd2PfCzfhcdG
         lKObk5M/RwEZDmMuFsgYzZLC5kk1qjpJD3gyb8uAcInU0dL4wAYJFBiZzhbmkoxZH93h
         9h6SXVbileoU1CSCtnHyS45pi6aP89U6UzUiuNYqJjfdDIEFySIK8cj4JFRYoid/igkb
         0zAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4VBbAU8vd/2KklhA5UGdiDmofO3byk15wh5Af9y9vUQ=;
        fh=qsy3btRcEXIIT7uNMCV3Y9Fyt9JMxqS2qDNJNUTKK58=;
        b=UOhpUcDN6K29vjTQS16jGGiaBMHJ4LZGUQTb8kr/aBd90BSjiTHntPUZjtWMKvlOf2
         okiu1m4PQaU7crbKMwgV1YgeRf0rHToMYrLLygg8xR1nx7hFXkBI7FQywm4hpc2WO88s
         nJ9XQXUz8mSWYlDQec/pR9rirhmBLpwIufaftO+2aLIJashw2t1AP9dWA44EJqlg4J7T
         z4v+I5CDom9qbhmE5PA0ezBLCQtioti5mHaLaY1r6hQNYNW+Vr/0yjKptzlmHWYA4qHi
         /I4wBo2WPDTHpK8ywjB/6ksJHGdZ6ZPhpOjiJrZmsxfa8z7WzKSNW8IRQV4Des4veuUB
         rO9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769196877; x=1769801677; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4VBbAU8vd/2KklhA5UGdiDmofO3byk15wh5Af9y9vUQ=;
        b=utrDlw9VqMvPDLMAV18SHPS89FCtk3XTyM1B49mRxQcg56DUfeofvMxje8R6brw6xX
         Ng+U9dKibvPE/UKx+aa3QrHOM1M9IkK7aW2uuv7JxMJmyfe3QP9McXwSkTEOHmV5Au8T
         Vx9DJeI57My9kbPLY+n1JyfF8CEvtid2NSnWGizfkunfl8u5OMrbf0FO+Luqz12sF1nC
         EeNGlNRc6LCJ/8x58xKXA+g5q162yJMK5r/H8qwD48zF/GhFEfk/hrd5qu23JoXvmLCd
         l3bhTIo+Q1F4lpa2VlzHWeTgDw11D/lWUpw3E1viyMjkV/SCgx6ysvLmbZjfI2MyRzU7
         fqlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769196877; x=1769801677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4VBbAU8vd/2KklhA5UGdiDmofO3byk15wh5Af9y9vUQ=;
        b=jx7VfkIA1DDjPgYpInEy2AAvdLoXPlpJGkxsX6tkb9hGp6wkC0SBted3yv3wEhpUyA
         68GldNmrAsnM0GAaD+qtGAKLszUrdnnKPkJFMiBIR3GgHTr9SxdwGvwQmX77MI1gaVh4
         /MU93ept3IY2z8AG2kgApaix+vlULxQRt5RnyfrpbvmKNkDP0qDP41XxV/nRyAAc7ixH
         U1n3H8L4Q12sngyV8aSr4M6ASP5hbapCeQgIPOeqnVwonEBpmJnWMJyyMjlqUc95Z/kM
         GH+yViXNXnA9a2iDaOZeGPBIkVx1YEdzy0qrsGwFDsQSHczd3A1xWrVg5nSH96m7br6/
         jVCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFdo5UuX2Vhvvtm94ZEn+HgSAIuiWdBELa0F90pZSDRM8r1QfJdGyzjOM6evMGgVud5lSRqPIbhw==@kvack.org
X-Gm-Message-State: AOJu0YzAhW4geiVR/6tiZOsDATx+by6+mHCjE2FPbkcCPrPm3kqLEiYB
	AcidR6A3hF9Xo0B1RLiHog8w6+gdsfF55cc8KjinJGGRjftL0ZQJT9We4YhjBcusC8YD6vbahiK
	CgmYpg36IIFgIztLnIa6NV+drnYwHrE+FQe29ggBb
X-Gm-Gg: AZuq6aJX1wrj5bXbsVf2nMevrK+KSAJktSHAvNdmmXU64JjdkbyQ8mvQMHPjDMH4cBW
	Ij4JBOfNMCFRxDvnD/UL/pebGNU2lmCP5o9Jdrd/Ny98gC7nqT+rspNQZlY40lSETkwqc1YgVKi
	QchMUVWJdiNnTPLqqpv8hCBER8I48vjY52YH+8c7e2oaUnzwDJASYCPJbmoV3RZBqvFXnv1Q419
	weqmc5Fi2lgmXNekY2sKo++fRndalQEHA49JzkL9IM09QV1djMifZ7KviKThmFplmJ0Lw==
X-Received: by 2002:a05:622a:19a7:b0:502:f07e:854c with SMTP id
 d75a77b69052e-5030513a13dmr1303931cf.6.1769196876925; Fri, 23 Jan 2026
 11:34:36 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <4f95671feac6b6d4cea3c53426c875f3fd8a8855.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpEULwMTxAzxUdzfpHe2=+umXL6HFMvydkqW=tP8mB2ewg@mail.gmail.com> <c7c8158d-e360-4a29-9e48-f2b45b9ca147@lucifer.local>
In-Reply-To: <c7c8158d-e360-4a29-9e48-f2b45b9ca147@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 23 Jan 2026 11:34:25 -0800
X-Gm-Features: AZwV_QglINHieQVVU9Ln3erH7fB3eaWb2v8z1U93ye9e7yoFwpUXra2dZpBIa5Q
Message-ID: <CAJuCfpFbsAHr76ZfUEaRLzdxQMDjPEP+bsLNC35X9t53G_uqAg@mail.gmail.com>
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
X-Rspamd-Queue-Id: 6CB63C0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8nd5ao98dkcafe5odeqq6f4mistaxu7x
X-HE-Tag: 1769196878-256026
X-HE-Meta: U2FsdGVkX1+/FDK3npFuIhH6rQdHUHbbucttO6udOCgrytCZuzP9+B7DvEyIEyhM3UvBb2STz5l3nPP5X/4e1hjmwm+gb0/y3fxrARGFpdkpnyXFy19BVmEe0OqsJ4JowyLS8ckGGyPHEaGU/Iw4i7CJjiOiXnfcjWBj4tFVZ0f8/MfkUtvtjMU+Jh165JOCpUvOzOV8H8b+cs7+miUiohVY4OlTj1LvaDWa10T7ycFlRHfZ0GZPt4nPDb4Dec2wrymIrM2OnQGj52y/NKKY5mF4n7WpNnu7O/NBo5fLQ+n+W1kIxD9rk8tqKAyczKYBq6F5Q5u8WqHLwumVrqF5071ogSowXcm4WcShiIEuYyoiJWcxCG8baUB2UD4sJSdLkO4MO5boFhKqJwc49P28+PEOkqILaVJp823r422mu7lOXFYdiBRatTNCFM6dXJO/B6PDyRfHqQU3oGn/1QIP0DNRyotcLqypwWcup7E4jmPAcXctUlrmWvPyvyiHVwXGvK2wCrzgbUxfWhSyx4EdLM5hfCs4jHU1jaJ+xSlv1PsO89U/orRF8XPjkQXmrfmXsMXzKO0VVNX6T9l+7iVfz1Ku7ErVyHcxoR2uT/2pbTdQEIaKoAGAcbgMAUBggDuKLAlqWnJjRnRCAkdN8FgXVBBn9LmYRpjZTXCLAOcO4ye3umG+kU3MprE22tF3SvPSuC87v0dSHtte7VLHN+ZwNO/uIvTxnGiiaTAmNAM5OKM7wHnTc8ToisWOhDVzrEhNBQyEqhGLh0+xomU6wAHxhuCuQsw2z8Cjuf/fHVW1+GnevV23o0ykQoJQ7LS4O3mqpK4zL/Flcyixc5N3ZZPMVBU4yuJS6TLJ8QTJ5gJ4NrOQXBvwZoxgBc/ZpxPMpGPXzsthG2Ot6Dku0FdRZCOQ/BhHbDnP1gvfUo4TkUoRHhkjkgnBQCVO8AIDYp5KLZ3kJc76zcH0r4Gm+KNqJI6
 BoQ+zGi5
 e4NyyDfq9VlP36mg/k/nbZPqclGHLbL3bm9DSlgl4NpthgL/d0dO9VW1Gm3+cGQywivh2GoMTyT0PITQOxJXsbf7L+keyyJFwYqcZwhwgCwKAl2STab3nTVKlF5S7s5bA31AEiWPb17zG1gCoY0PiwC4x/0Itsj7Ls2dIsYrXjE7nK3HiAy4r/6q4R1H0eQq1rFY/wjeI++mUbpdiI+7n2svADpVyGb/BoAvmjM8hGXJQRfI9m3TjUKfuYHvRKi+GoguiAr05nsLCuolst4Ot9M35STSUKwJMYm4opw2b4stmQP2Er2bDZe3xBMzBgKFhzj1LCx3COdmRXA8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 9:59=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Jan 22, 2026 at 01:41:39PM -0800, Suren Baghdasaryan wrote:
> > On Thu, Jan 22, 2026 at 5:03=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > It is confusing to have __vma_enter_exclusive_locked() return 0, 1 or=
 an
> > > error (but only when waiting for readers in TASK_KILLABLE state), and
> > > having the return value be stored in a stack variable called 'locked'=
 is
> > > further confusion.
> > >
> > > More generally, we are doing a lock of rather finnicky things during =
the
> > > acquisition of a state in which readers are excluded and moving out o=
f this
> > > state, including tracking whether we are detached or not or whether a=
n
> > > error occurred.
> > >
> > > We are implementing logic in __vma_enter_exclusive_locked() that
> > > effectively acts as if 'if one caller calls us do X, if another then =
do Y',
> > > which is very confusing from a control flow perspective.
> > >
> > > Introducing the shared helper object state helps us avoid this, as we=
 can
> > > now handle the 'an error arose but we're detached' condition correctl=
y in
> > > both callers - a warning if not detaching, and treating the situation=
 as if
> > > no error arose in the case of a VMA detaching.
> > >
> > > This also acts to help document what's going on and allows us to add =
some
> > > more logical debug asserts.
> > >
> > > Also update vma_mark_detached() to add a guard clause for the likely
> > > 'already detached' state (given we hold the mmap write lock), and add=
 a
> > > comment about ephemeral VMA read lock reference count increments to c=
larify
> > > why we are entering/exiting an exclusive locked state here.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > ---
> > >  mm/mmap_lock.c | 144 +++++++++++++++++++++++++++++++----------------=
--
> > >  1 file changed, 91 insertions(+), 53 deletions(-)
> > >
> > > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > > index f73221174a8b..75166a43ffa4 100644
> > > --- a/mm/mmap_lock.c
> > > +++ b/mm/mmap_lock.c
> > > @@ -46,20 +46,40 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
> > >  #ifdef CONFIG_MMU
> > >  #ifdef CONFIG_PER_VMA_LOCK
> > >
> > > +/* State shared across __vma_[enter, exit]_exclusive_locked(). */
> > > +struct vma_exclude_readers_state {
> > > +       /* Input parameters. */
> > > +       struct vm_area_struct *vma;
> > > +       int state; /* TASK_KILLABLE or TASK_UNINTERRUPTIBLE. */
> > > +       bool detaching;
> > > +
> > Are these:
> >             /* Output parameters. */
> > ?
>
> Yurp.
>
> Oh you added the comment :) well clearly I should have, will do so.
>
> > > +       bool detached;
> > > +       bool exclusive; /* Are we exclusively locked? */
> > > +};
> > > +
> > >  /*
> > >   * Now that all readers have been evicted, mark the VMA as being out=
 of the
> > >   * 'exclude readers' state.
> > >   *
> > >   * Returns true if the VMA is now detached, otherwise false.
> > >   */
> > > -static bool __must_check __vma_exit_exclusive_locked(struct vm_area_=
struct *vma)
> > > +static void __vma_exit_exclusive_locked(struct vma_exclude_readers_s=
tate *ves)
> > >  {
> > > -       bool detached;
> > > +       struct vm_area_struct *vma =3D ves->vma;
> > > +
> > > +       VM_WARN_ON_ONCE(ves->detached);
> > > +       VM_WARN_ON_ONCE(!ves->exclusive);
> > >
> > > -       detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_=
FLAG,
> > > -                                        &vma->vm_refcnt);
> > > +       ves->detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_REA=
DERS_FLAG,
> > > +                                             &vma->vm_refcnt);
> > >         __vma_lockdep_release_exclusive(vma);
> > > -       return detached;
> > > +}
> > > +
> > > +static unsigned int get_target_refcnt(struct vma_exclude_readers_sta=
te *ves)
> > > +{
> > > +       const unsigned int tgt =3D ves->detaching ? 0 : 1;
> > > +
> > > +       return tgt | VM_REFCNT_EXCLUDE_READERS_FLAG;
> > >  }
> > >
> > >  /*
> > > @@ -69,30 +89,31 @@ static bool __must_check __vma_exit_exclusive_loc=
ked(struct vm_area_struct *vma)
> > >   * Note that this function pairs with vma_refcount_put() which will =
wake up this
> > >   * thread when it detects that the last reader has released its lock=
.
> > >   *
> > > - * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in ca=
ses where we
> > > - * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fa=
tal signal
> > > - * is permitted to kill it.
> > > + * The ves->state parameter ought to be set to TASK_UNINTERRUPTIBLE =
in cases
> > > + * where we wish the thread to sleep uninterruptibly or TASK_KILLABL=
E if a fatal
> > > + * signal is permitted to kill it.
> > >   *
> > > - * The function will return 0 immediately if the VMA is detached, an=
d 1 once the
> > > - * VMA has evicted all readers, leaving the VMA exclusively locked.
> > > + * The function sets the ves->locked parameter to true if an exclusi=
ve lock was
> >
> > s/ves->locked/ves->exclusive
> >
> > > + * acquired, or false if the VMA was detached or an error arose on w=
ait.
> > >   *
> > > - * If the function returns 1, the caller is required to invoke
> > > - * __vma_exit_exclusive_locked() once the exclusive state is no long=
er required.
> > > + * If the function indicates an exclusive lock was acquired via ves-=
>exclusive
> > > + * (or equivalently, returning 0 with !ves->detached),
> >
> > I would remove the mention of that equivalence because with this
> > change, return 0 simply indicates that the operation was successful
> > and should not be used to infer any additional states. To get specific
> > state the caller should use proper individual ves fields. Using return
> > value for anything else defeats the whole purpose of this cleanup.
>
> OK I'll remove the equivalency comment.
>
> >
> > > the caller is required to
> > > + * invoke __vma_exit_exclusive_locked() once the exclusive state is =
no longer
> > > + * required.
> > >   *
> > > - * If state is set to something other than TASK_UNINTERRUPTIBLE, the=
 function
> > > - * may also return -EINTR to indicate a fatal signal was received wh=
ile waiting.
> > > + * If ves->state is set to something other than TASK_UNINTERRUPTIBLE=
, the
> > > + * function may also return -EINTR to indicate a fatal signal was re=
ceived while
> > > + * waiting.
> > >   */
> > > -static int __vma_enter_exclusive_locked(struct vm_area_struct *vma,
> > > -               bool detaching, int state)
> > > +static int __vma_enter_exclusive_locked(struct vma_exclude_readers_s=
tate *ves)
> > >  {
> > > -       int err;
> > > -       unsigned int tgt_refcnt =3D VM_REFCNT_EXCLUDE_READERS_FLAG;
> > > +       struct vm_area_struct *vma =3D ves->vma;
> > > +       unsigned int tgt_refcnt =3D get_target_refcnt(ves);
> > > +       int err =3D 0;
> > >
> > >         mmap_assert_write_locked(vma->vm_mm);
> > > -
> > > -       /* Additional refcnt if the vma is attached. */
> > > -       if (!detaching)
> > > -               tgt_refcnt++;
> > > +       VM_WARN_ON_ONCE(ves->detached);
> > > +       VM_WARN_ON_ONCE(ves->exclusive);
> >
> > Aren't these output parameters? If so, why do we stipulate their
> > initial values instead of setting them appropriately?
>
> I guess it was just to ensure correctly set up but yes it's a bit weird, =
will
> remove.
>
> >
> > >
> > >         /*
> > >          * If vma is detached then only vma_mark_attached() can raise=
 the
> > > @@ -101,37 +122,39 @@ static int __vma_enter_exclusive_locked(struct =
vm_area_struct *vma,
> > >          * See the comment describing the vm_area_struct->vm_refcnt f=
ield for
> > >          * details of possible refcnt values.
> > >          */
> > > -       if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &v=
ma->vm_refcnt))
> > > +       if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &v=
ma->vm_refcnt)) {
> > > +               ves->detached =3D true;
> > >                 return 0;
> > > +       }
> > >
> > >         __vma_lockdep_acquire_exclusive(vma);
> > >         err =3D rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
> > >                    refcount_read(&vma->vm_refcnt) =3D=3D tgt_refcnt,
> > > -                  state);
> > > +                  ves->state);
> > >         if (err) {
> > > -               if (__vma_exit_exclusive_locked(vma)) {
> > > -                       /*
> > > -                        * The wait failed, but the last reader went =
away
> > > -                        * as well. Tell the caller the VMA is detach=
ed.
> > > -                        */
> > > -                       WARN_ON_ONCE(!detaching);
> > > -                       err =3D 0;
> > > -               }
> > > +               __vma_exit_exclusive_locked(ves);
> > >                 return err;
> >
> > Nice! We preserve both error and detached state information.
>
> :)
>
> >
> > >         }
> > > -       __vma_lockdep_stat_mark_acquired(vma);
> > >
> > > -       return 1;
> > > +       __vma_lockdep_stat_mark_acquired(vma);
> > > +       ves->exclusive =3D true;
> > > +       return 0;
> > >  }
> > >
> > >  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lo=
ck_seq,
> > >                 int state)
> > >  {
> > > -       int locked;
> > > +       int err;
> > > +       struct vma_exclude_readers_state ves =3D {
> > > +               .vma =3D vma,
> > > +               .state =3D state,
> > > +       };
> > >
> > > -       locked =3D __vma_enter_exclusive_locked(vma, false, state);
> > > -       if (locked < 0)
> > > -               return locked;
> > > +       err =3D __vma_enter_exclusive_locked(&ves);
> > > +       if (err) {
> > > +               WARN_ON_ONCE(ves.detached);
> >
> > I believe the above WARN_ON_ONCE() should stay inside of
> > __vma_enter_exclusive_locked(). Its correctness depends on the
> > implementation details of __vma_enter_exclusive_locked(). More
>
> Well this was kind of horrible in the original implementation, as you are
> literally telling the function whether you are detaching or not, and only=
 doing
> this assert if you were not.
>
> That kind of 'if the caller is X do A, if the caller is Y do B' is really=
 a code
> smell, you should have X do the thing.
>
> > specifically, it is only correct because
> > __vma_enter_exclusive_locked() returns 0 if the VMA is detached, even
> > if there was a pending SIGKILL.
>
> Well it's a documented aspect of the function that we return 0 immediatel=
y on
> detached state so I'm not sure that is an implementation detail?
>
> I significantly prefer having that here vs. 'if not detaching then assert=
 if
> detached' for people to scratch their heads over in the function.
>
> I think this detail is incorrect anyway, because:
>
>         if (err) {
>                 if (__vma_exit_exclusive_locked(vma)) {
>                         /*
>                          * The wait failed, but the last reader went away
>                          * as well. Tell the caller the VMA is detached.
>                          */
>                          WARN_ON_ONCE(!detaching);
>                          err =3D 0;
>                 }
>                 ...
>         }
>
> Implies - hey we're fine with err not being zero AND detaching right? In =
which
> case reset the error?
>
> Except when detaching we set TASK_UNINTERRUPTIBLE? Which surely means we =
never
> seen an error?
>
> Or do we?
>
> Either way it's something we handle differently based on _caller_. So it =
doesn't
> belong in the function at all.
>
> It's certainly logic that's highly confusing and needs to be handled
> differently.

Just to be clear, I'm not defending the way it is done before your
change, however the old check for "if not detaching then assert if
detached" makes more sense to me than "if
__vma_enter_exclusive_locked() failed assert that we VMA is still
attached". The latter one does not make logical sense to me. It's only
correct because of the implementation detail of
__vma_enter_exclusive_locked().

>
> >
> > > +               return err;
> > > +       }
> > >
> > >         /*
> > >          * We should use WRITE_ONCE() here because we can have concur=
rent reads
> > > @@ -141,9 +164,11 @@ int __vma_start_write(struct vm_area_struct *vma=
, unsigned int mm_lock_seq,
> > >          */
> > >         WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
> > >
> > > -       /* vma should remain attached. */
> > > -       if (locked)
> > > -               WARN_ON_ONCE(__vma_exit_exclusive_locked(vma));
> > > +       if (!ves.detached) {
> >
> > Strictly speaking the above check should be checking ves->exclusive
> > instead of !ves.detached. What you have is technically correct but
> > it's again related to that comment:
> >
> > "If the function indicates an exclusive lock was acquired via
> > ves->exclusive (or equivalently, returning 0 with !ves->detached), the
> > caller is required to invoke __vma_exit_exclusive_locked() once the
> > exclusive state is no longer required."
> >
> > So, here you are using returning 0 with !ves->detached as an
> > indication that the VMA was successfully locked. I think it's less
> > confusing if we use the field dedicated for that purpose.
>
> OK changed.
>
> >
> > > +               __vma_exit_exclusive_locked(&ves);
> > > +               /* VMA should remain attached. */
> > > +               WARN_ON_ONCE(ves.detached);
> > > +       }
> > >
> > >         return 0;
> > >  }
> > > @@ -151,7 +176,12 @@ EXPORT_SYMBOL_GPL(__vma_start_write);
> > >
> > >  void vma_mark_detached(struct vm_area_struct *vma)
> > >  {
> > > -       bool detached;
> > > +       struct vma_exclude_readers_state ves =3D {
> > > +               .vma =3D vma,
> > > +               .state =3D TASK_UNINTERRUPTIBLE,
> > > +               .detaching =3D true,
> > > +       };
> > > +       int err;
> > >
> > >         vma_assert_write_locked(vma);
> > >         vma_assert_attached(vma);
> > > @@ -160,18 +190,26 @@ void vma_mark_detached(struct vm_area_struct *v=
ma)
> > >          * See the comment describing the vm_area_struct->vm_refcnt f=
ield for
> > >          * details of possible refcnt values.
> > >          */
> > > -       detached =3D __vma_refcount_put(vma, NULL);
> > > -       if (unlikely(!detached)) {
> > > -               /* Wait until vma is detached with no readers. */
> > > -               if (__vma_enter_exclusive_locked(vma, true, TASK_UNIN=
TERRUPTIBLE)) {
> > > -                       /*
> > > -                        * Once this is complete, no readers can incr=
ement the
> > > -                        * reference count, and the VMA is marked det=
ached.
> > > -                        */
> > > -                       detached =3D __vma_exit_exclusive_locked(vma)=
;
> > > -                       WARN_ON_ONCE(!detached);
> > > -               }
> > > +       if (likely(__vma_refcount_put(vma, NULL)))
> > > +               return;
> > > +
> > > +       /*
> > > +        * Wait until the VMA is detached with no readers. Since we h=
old the VMA
> > > +        * write lock, the only read locks that might be present are =
those from
> > > +        * threads trying to acquire the read lock and incrementing t=
he
> > > +        * reference count before realising the write lock is held an=
d
> > > +        * decrementing it.
> > > +        */
> > > +       err =3D __vma_enter_exclusive_locked(&ves);
> > > +       if (!err && !ves.detached) {
> >
> > Same here, we should be checking ves->exclusive to decide if
> > __vma_exit_exclusive_locked() should be called or not.
>
> Ack, changed.
>
> >
> > > +               /*
> > > +                * Once this is complete, no readers can increment th=
e
> > > +                * reference count, and the VMA is marked detached.
> > > +                */
> > > +               __vma_exit_exclusive_locked(&ves);
> > >         }
> > > +       /* If an error arose but we were detached anyway, we don't ca=
re. */
> > > +       WARN_ON_ONCE(!ves.detached);
> > >  }
> > >
> > >  /*
> > > --
> > > 2.52.0
>
> Cheers, Lorenzo

