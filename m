Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06265C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 18:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F2896B0088; Mon, 31 Aug 2026 14:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A3C76B008A; Mon, 31 Aug 2026 14:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76AF06B008C; Mon, 31 Aug 2026 14:21:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4516B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:21:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E4B01201EF
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:21:00 +0000 (UTC)
X-FDA: 85162381080.15.669027B
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id AD545A0013
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:20:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gzPJS5Vm;
	spf=pass (imf15.hostedemail.com: domain of stevensd@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788200458;
	b=gVUbtHpXgaM6KytiUIGQDjhKT7rhomIQPafj726ZYToxpyAyqsktjCyrjqP89XrxjfhNt8
	yGbTV2K89kzQlRzBOMyDZE72Dp+osANqoTA+5mDFOP2xQqQTFAprm51cEu7nuJNo4Ovzso
	5J0UIeOPrFga1Ve+eX9zeoGCpm96VX4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gzPJS5Vm;
	spf=pass (imf15.hostedemail.com: domain of stevensd@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788200458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=liZszDn7klOcxD9VBLJE3EvZKiNzUHK63cI9Y5HfyPk=;
	b=jdldVPUIOQBkA4w4lyALMlObvp3tGsR0VRBwyDWw1a69FsH89rBsYnplxUsPJQdnGwvF0R
	fKL45HFQlurqXhjOUHDZj25Qmkm2DI5nsEpLLCDS+/fLkJNRSo9gua8HHwRQV7s4x7Y0ZY
	Jm1HTWcNaV8TsRlk1hOu1UrsKKrywrU=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-498012a61f6so5845e9.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:20:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788200457; cv=none;
        d=google.com; s=arc-20260327;
        b=e2UuymNoVMTO0lUf8DV9aI6H56KYXpocUMWuyf5x05EB/ihjbKv3AL1ESvJV//vZD7
         +/+zz3cJojoBZ6Pxm1UNFE1Vjr70Vhy5d07xyGFjZxmtwyOL5ebZRhRgYWwOyCshq25v
         Dd4p64HIR6IMkY28rO6PeJUe0YFANH3A/hMjPJ082QFq5HOp9hPgU+iQuq6+4EMakZkB
         hPwYeK0Zo8QOjPp0h59zAlGP+IVEZ49Vp06J8FMwFHsNqQDRlYKA7vjCfwak1QzVJdD/
         RKUPTA7BPsRyO+Nsu7QD7Wl3FuIZiSfEZawJqUpvIshyVgOIkwtHhWdh6FSZpzELPLIu
         N1Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=liZszDn7klOcxD9VBLJE3EvZKiNzUHK63cI9Y5HfyPk=;
        fh=G689CQngDl4+WYk9YHw/VY4aFOj9db8Tgz3ofs+6qyY=;
        b=MTTdGUpVQpeoMZHySL009HKigqPuMN0TXkAFFuuTU7Y6mM0sGkbgK/+Q3Pk1vUMh3Y
         L2TqWsDGtl+dJ6epXr5kBdDqjTl/h7Sqn/Y9DXl++K5C6bvJSuNSw0/fcyvyJw01sE0y
         Ko3ghRZS7UGZa9UUMgDjOjV4ngnPz0luLFdpk5nKxHNQbXs131o9rbdZuQS3On7QTS4+
         Dw/Y2mrYdrZUXRMRH4I4uuREmLeW62FjZWfFWBDEKwvkfOk+z9Oh0yMWZ15n9zHD/+Sx
         cTiFmhYWV+92j9iWaEctRRv60ETk76e2DAwrJJdcwCwKbwupkBsFw1ooN9wxsI08mBiG
         HOqw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788200457; x=1788805257; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=liZszDn7klOcxD9VBLJE3EvZKiNzUHK63cI9Y5HfyPk=;
        b=gzPJS5VmuFX2SGe2EATkfC2F+EitdW4J9M4u+yAcb5s6ftjljb5PowIkOuqza0SJgR
         RGMIjA+PLEWb7k/77LfGMSKitRImPD5PacopNQ8n97w1O2WxVD3JJ6XJ5Lb3ww0H0nt2
         tQLwqvXswsjHeiVucm1ZDH3qN1+71IgwccOySivE6DL/8rNo/gitFai135Zkfnfpb+9w
         FkF1l08uz2dtQeydqxIY1WMfI8kr5G2fvl1/2us8YvxFIzHHXWYTZ/3/FqXh4KLfQyGr
         T5psuVjdap1Bu/ApPj6DdAu8xJS4azBBci6eMB9fFFoIoowEKz84HX6wxyI+nt+9ccMQ
         S3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788200457; x=1788805257;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=liZszDn7klOcxD9VBLJE3EvZKiNzUHK63cI9Y5HfyPk=;
        b=X5xkmGIZkGxh7V/SNtYv7/p+RrbYbGYneJQRdPbzwxrvWEd7ZqtWp1/yv9sceMOjG1
         CyeurF9jKEcUOeQch5f8i11mg9JbyEYzbREcyACgpfxrY+CWoJ42e7asfZo1IqSF39MT
         6SBNujiF4y/o5bIG14IODGSnjjIcSI/tMXyKilQWlAGQmhL8ehxmEQ0ww/Oa5ymBWlaK
         wb0/uOQL9vMnDK+DaAKenTD47QDxpPqvDJcDWSulqbf+jqCEp0EqKnwm9wDsdC5Jhhec
         Ds5/9hET0Drf33pYq35hQa1Zrei/gDE3XNigTVd1C4XnFy5CQyM9CpIPtZU/F+6cyPdB
         qHyQ==
X-Forwarded-Encrypted: i=1; AHgh+RrUHHLVag15eKwovRDqlBmL6ODKoqRXoFaQ2qI6TN4LuMBSUld7ykN9f/r5WciNGKbPd/QEVbpgpg==@kvack.org
X-Gm-Message-State: AFuF++nicrvxHtHMn7G2t+n2/qTMV7OUqsyXZtLOc0Ojw9nDdRBuF7sE
	qSHg23Gs9ZPJeIrpZA873mX/lEfVlxx+Wnkoc5Ml65k4I/92QAivNDoI0bH0lkEHv8ozLqTNWXm
	CVzan+svm59WPoatw4u5+7lGCuxghvT9uJsGL/gp4
X-Gm-Gg: AR+sD11wKdAoKLip6i7Ha6lrnifHMZT0mMHiGnkNxgTB4Ajg9PbwoWs0puCxsPc8WfV
	i+meFvTAjU4CYQPvpPELiQvHjD5Li6rug3kOTreT7ULIh51mJRyAhUQPU4t/RLL6ewrrein/C5d
	iAV7CRWDetId+4ouxltA7zbCBbqr66Ee6L37e1yYbNwPbzFOk5bb3hxCgaxkR471GPBRdwLyq4M
	/M1X45SWVetjGAXe5IJk/u6cE/ttRLbCf3xaZguAN2YeosICyyZnXqFh8yic46wygkI6q25qzOK
	Bi7zue732h9bCyRCX09VdGXM4R3bc69dO659S/Eh0a7MDa8Zl+5RJSAcaUNyvO6r8lHER2psVzj
	Ox516g8CdZGf+t3T5wLbM1w5GOYyDNtgNw0tDMsjE5w==
X-Received: by 2002:a05:600c:6d8a:b0:49b:8eb7:4a7d with SMTP id
 5b1f17b1804b1-49cdd243062mr54125e9.4.1788200456737; Mon, 31 Aug 2026 11:20:56
 -0700 (PDT)
MIME-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com> <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de> <CAOiLmNHK5Hw55omycg_EAHzi=g1iqJn1NTap1Mt98im3xTXcvA@mail.gmail.com>
 <20260831080803.LhShiZ4V@linutronix.de>
In-Reply-To: <20260831080803.LhShiZ4V@linutronix.de>
From: David Stevens <stevensd@google.com>
Date: Mon, 31 Aug 2026 11:20:45 -0700
X-Gm-Features: AcwNN1UgSDGKp_-qGVll8X0b99CFe9G1chydBMXs5bqOm1Le3KZxzv-yKBGwCyM
Message-ID: <CAOiLmNFvOi5bCULVmo2gZRnnJX-L8mEL5QYLdsXVSHgN9bJFdw@mail.gmail.com>
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: multipart/alternative; boundary="000000000000043817065a5bdddd"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD545A0013
X-Stat-Signature: 7pd6dm397m7wabk5r76trbm9pyzhhd53
X-HE-Tag: 1788200458-3176
X-HE-Meta: U2FsdGVkX1/MQTETWw2ci8Gq8PISKT1/y7k+Y+i1wVfO84H89epn4C+aSOQgh5dQhTTcWqK5aX2Z1V9+hwv5RHD1nDYlWHzSd2xYQT+jfvENvJ0eRA9x/FI0ogoKqLINsIufqvBxcZ2AwaFB6JzPl1UijKv1KXJ3AwZh3cetx88xcmG72CrvsCMFhtCv4rnssqzyKfyjzrRLIXqkuttM6M1v9NS46c3WydX8GhH6s23PsJwqUZyVTb2Vp0faJG7uGtk6b2DE/4EKUZi4mJltykCD9FtRWEOy21uvLFI8pVLCC+A9iuiqFDcOFaaDo9YCtTeLc4HtpEzGRXpgXco99epBgmpWJ9WP85oEW/CwbL1sZCmjm8ByV0rjgtp/hfwvINlJAoDDjUZfoK5uO3JugAH6bmwPxBbaycv9rzm11/PSJFCq0iZr3omW7A391mdUNCOYZg/FZKxYYkVGv3dArMeZ8PwzW7HaZH41opZOFrbOWGFnzUwQsvCOyakldrs2Y11q3UG0V6OYQLKo2xLPwQKze4j4jnfxUY31YAcdUWfqf4veP9NefafU5oXok6RmRkqRbG34deoHKNwU8vCeqBNw6+Pnyh+5MHQIEZT0AlMQRZ5xoQvycoxLQphiv02UirZMBWuNbNgngL7o0dwg9BV4AfLJBbvQA4Zimm4qzb07N3VSYQjP9Fq71RMPgPLELm1egqGEyrP0XSj0+yX73COyPt0oJU+opcpb2oqgU12NXEfxxRDkKqnhcU8WE8OY/bUzvhZZWFbZgx3ZE7p3jNMEMmdgGW73cDX/SVRsUe/L6Vl5nAc3kRg8JQzNPBeQqGFnZbXWjh+WzMKH/t00WU9KhSFI8CX6MQAd8rOyLDD5Exk5trKHjnJhUVKG8xs32NFToMsNLmmpyo3JMlPRboiWc5OY44aMN+UzIQM0Pjg8IddCO/YxAE9Ht6j9t4ZBsMqHlJEKim4xEng6NSp
 G4XbbM0S
 OGekJWfEGohO0pgce7ECFE7NtSpKkwDBnkaS8HkoO6TluvJ0+zywMstcUoUjV3THIRmJ0v51bANAValw0ObXQDHKOpqmCj54o3LZhS17yU9qZPsWZpVq4ApA0JuaUOQ/gIcV0nRdlpnY4R+uUSJkVg3ian+LAVcdsljxxqyzgobOLaJWd0hUI1xVIk84bEZl0UM34zv2KzoQ5iCGrCPRlbHPhvGAwZkzuDm06BEdFtcajHzbG8cdNc3O+532ziFVWx4wmaaBJ/Q7kUAMLc0E+Nv8Jk0NM+FLdXphe6iEkPUpxoEGMmH5mlJ+jJkD2Jr7zk9DzoIkFcV0xVlk6reurzI0kkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000043817065a5bdddd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2026 at 1:08=E2=80=AFAM Sebastian Andrzej Siewior <
bigeasy@linutronix.de> wrote:
>
> On 2026-08-28 14:17:49 [-0700], David Stevens wrote:
> > > Did lockdep see this?
> >
> > What are you referring to by "this"? I did stress testing with lockdep
> > enabled and didn't see any errors, although I will admit the bulk of
> > that stress testing was !PREEMPT_RT.
>
> I am (was) just surprised that lockdep did not complain about the memory
> allocation under the PI lock. It was pointed out in that thread later
> that the new trylock usage could mask that.

Lockdep did complain on PREEMPT_RT, since spinlocks can take pi_lock.
That's why PREEMPT_RT always defers repopulating the stack in this series.

The trylock usage is sufficient to prevent any lockdep issues on
!PREEMPT_RT, however.

> > > If I understood the whole exercise correct then you have a kernel
stack
> > > of two pages and in best case you can unmap and release the second
page
> > > while the task is napping.
> > >
> > > What might be a tad simpler is to memset(,0,) the remaining part of
the
> > > stack. Since the stack is vmap-ed it should be swapped out on its own
> > > without additional tricks. That memset() would help zram to compress
> > > better so it uses less memory. ta-da.
> > >
> > > What also should be simpler (and I am not saying just to move you awa=
y
> > > from the scheduler) is to have a shrinker which iterates over all
tasks
> > > which are marked for reclaim and then similar to swap just unmap both
> > > stack pages and release the second page which is not used.
> > > Upon wake up the task should create a page_fault which would be used
to
> > > allocate the second stack page and map the whole stack again.
> > >
> > > This sounds simpler.
> >
> > There is no swap for kernel memory, only user memory. I did contribute
> > to some previous work that aimed to only only prepopulate one page of
> > each kernel stack and then to dynamically fault in further pages as
> > needed [1], but handling that architecturally and guaranteeing that
> > memory is available when needed is difficult. Full-on swap to zram
>
> but faulting it in while the task is running is sort of complicated
> since the task might have page_faults disabled. This is what I missed
> initially (the task is with disabled interrupts in the scheduler).
>
> But unmap the stack while application is sleeping (via shrinker) and
> fault it in via another thread on wake up should be doable.

Faulting on another thread's stack does bypass the architectural problems
of faulting on your own stack. However, since the faults could happen in an
atomic context, it has the same problem of panicing on memory allocation
failure. GFP_ATOMIC obviously wouldn't work. It would be possible to have a
pool of pre-allocated pages to handle these faults, but I can't think of
any way to size the pool to guarantee it never runs out.

-David

--000000000000043817065a5bdddd
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On Mon, Aug 31, 2026 at 1:08=E2=80=AFAM Sebastian Andrzej =
Siewior &lt;<a href=3D"mailto:bigeasy@linutronix.de">bigeasy@linutronix.de<=
/a>&gt; wrote:<br>&gt;<br>&gt; On 2026-08-28 14:17:49 [-0700], David Steven=
s wrote:<br>&gt; &gt; &gt; Did lockdep see this?<br>&gt; &gt;<br>&gt; &gt; =
What are you referring to by &quot;this&quot;? I did stress testing with lo=
ckdep<br>&gt; &gt; enabled and didn&#39;t see any errors, although I will a=
dmit the bulk of<br>&gt; &gt; that stress testing was !PREEMPT_RT.<br>&gt;<=
br>&gt; I am (was) just surprised that lockdep did not complain about the m=
emory<br>&gt; allocation under the PI lock. It was pointed out in that thre=
ad later<br>&gt; that the new trylock usage could mask that.<br><br>Lockdep=
 did complain on PREEMPT_RT, since spinlocks can take pi_lock. That&#39;s w=
hy PREEMPT_RT always defers repopulating the stack in this series.<br><br>T=
he trylock usage is sufficient to prevent any lockdep issues on !PREEMPT_RT=
, however.<br><br>&gt; &gt; &gt; If I understood the whole exercise correct=
 then you have a kernel stack<br>&gt; &gt; &gt; of two pages and in best ca=
se you can unmap and release the second page<br>&gt; &gt; &gt; while the ta=
sk is napping.<br>&gt; &gt; &gt;<br>&gt; &gt; &gt; What might be a tad simp=
ler is to memset(,0,) the remaining part of the<br>&gt; &gt; &gt; stack. Si=
nce the stack is vmap-ed it should be swapped out on its own<br>&gt; &gt; &=
gt; without additional tricks. That memset() would help zram to compress<br=
>&gt; &gt; &gt; better so it uses less memory. ta-da.<br>&gt; &gt; &gt;<br>=
&gt; &gt; &gt; What also should be simpler (and I am not saying just to mov=
e you away<br>&gt; &gt; &gt; from the scheduler) is to have a shrinker whic=
h iterates over all tasks<br>&gt; &gt; &gt; which are marked for reclaim an=
d then similar to swap just unmap both<br>&gt; &gt; &gt; stack pages and re=
lease the second page which is not used.<br>&gt; &gt; &gt; Upon wake up the=
 task should create a page_fault which would be used to<br>&gt; &gt; &gt; a=
llocate the second stack page and map the whole stack again.<br>&gt; &gt; &=
gt;<br>&gt; &gt; &gt; This sounds simpler.<br>&gt; &gt;<br>&gt; &gt; There =
is no swap for kernel memory, only user memory. I did contribute<br>&gt; &g=
t; to some previous work that aimed to only only prepopulate one page of<br=
>&gt; &gt; each kernel stack and then to dynamically fault in further pages=
 as<br>&gt; &gt; needed [1], but handling that architecturally and guarante=
eing that<br>&gt; &gt; memory is available when needed is difficult. Full-o=
n swap to zram<br>&gt;<br>&gt; but faulting it in while the task is running=
 is sort of complicated<br>&gt; since the task might have page_faults disab=
led. This is what I missed<br>&gt; initially (the task is with disabled int=
errupts in the scheduler).<br>&gt;<br>&gt; But unmap the stack while applic=
ation is sleeping (via shrinker) and<br>&gt; fault it in via another thread=
 on wake up should be doable.<br><br>Faulting on another thread&#39;s stack=
 does bypass the architectural problems of faulting on your own stack. Howe=
ver, since the faults could happen in an atomic context, it has the same pr=
oblem of panicing on memory allocation failure. GFP_ATOMIC obviously wouldn=
&#39;t work. It would be possible to have a pool of pre-allocated pages to =
handle these faults, but I can&#39;t think of any way to size the pool to g=
uarantee it never runs out.<br><br>-David</div>

--000000000000043817065a5bdddd--

