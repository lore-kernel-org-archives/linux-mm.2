Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FD73CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 19:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8306B0088; Sun,  3 May 2026 15:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A8EC6B008A; Sun,  3 May 2026 15:55:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5701E6B008C; Sun,  3 May 2026 15:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43E666B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 15:55:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3309C262D
	for <linux-mm@kvack.org>; Sun,  3 May 2026 19:55:58 +0000 (UTC)
X-FDA: 84727164396.13.3FD892F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 88814100006
	for <linux-mm@kvack.org>; Sun,  3 May 2026 19:55:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I2LrCfTK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777838156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7bhFmIB4GpwZzfLoiO6pcKAFE9QNelEpmmS09GV+5aw=;
	b=jDdrERdyByUl4+ZVN7j0VoqgB3wO7ySdC5ocyLjULnCG/d1Iu1Og7Wym1uv5Xm89Qoa0Pt
	eTZ2rhu7cedX4TcxT3XHeMYqwZ+lVGe85tFMwnMqJfyj4XvXBeJeitDmb0XQsfZ224Fjox
	bWYtxneKdxFN3o6uz5yIfIUzcY5U8iM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777838156; a=rsa-sha256;
	cv=none;
	b=P2AuUSKZ99LwKhbz04OAWWaTrfBbKBzjNe0yk/Kg9dQEBwtTI4FPNYKsn5OenG8eW87MPZ
	PgSv4Y33aeXVD+YGfiG9isRrwKCSNIoiPidxY8tQIp57TUXA9LXS+AsghcHcdB+TGWT6m8
	6E06wM9cEbcMRbs3QuWqZTULZWzTfB8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I2LrCfTK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D534160008
	for <linux-mm@kvack.org>; Sun,  3 May 2026 19:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C954C2BCC9
	for <linux-mm@kvack.org>; Sun,  3 May 2026 19:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777838155;
	bh=q0YQtTiiL7ieGdsHU5xDXtyCdqIQKThOK+46A5C32Gs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=I2LrCfTKxq4IVaLNDuZ1S09XfDfyfhD4jomMUPbzrmQVVmcYTxvqMttecoq9syWRx
	 j2vqFmHkN3FN4QFvwP4rqOmeCxhkL3/9+Bf9OwTlICDDmZv2TBM43XaoWDOVyoxB9O
	 uXfZCP7LEJ1jMnUHvhQL84OeO100SA13TNQodxkYjrsA0+sOi7PC/ZW73GD+6l+XD/
	 Xm0wkYGd28jiSG0a9eJ3ab+nn3cED9SDxF2uHkNytaBziig812s1tkcKSi+3YhsN76
	 r/1UtWafHIKEOYHQJo2v3bIDjTh7LI+ZVE8DI4a3fwLchTaxIVBaugdBeS7ao0E3yy
	 OWM41KwIlqxxg==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8ef45a6d9dfso390377785a.0
        for <linux-mm@kvack.org>; Sun, 03 May 2026 12:55:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/6xPKapgN5iAI2jsGQUOPorVw6F+tdCoo+zpftIqi9m6AT/q4GHzmDZrvqXq8XrZGO2cCG85FFlA==@kvack.org
X-Gm-Message-State: AOJu0Yy0Wp/MIEwpgK+nIjCe7QN1l9oqnyNWuv5Y0UvtnOJzlV4mnJ4/
	FdWRDWK0z0ooo5ufeVjl5y2hSLHQBKEmfhn7QB0LJAq2nTuW+A+XQNN/9pT6d0X9BNuIPwF1ihr
	b1Oja15jaVMqjtLgjg3jeB16w41fb33s=
X-Received: by 2002:a05:620a:4706:b0:8ee:f390:8f85 with SMTP id
 af79cd13be357-8fd154fbfdemr1048725085a.3.1777838154653; Sun, 03 May 2026
 12:55:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <yezmezj26xntushmylductlmytfgvwsnbnzlhffkfwugfxkt6m@gleq22spziyk>
In-Reply-To: <yezmezj26xntushmylductlmytfgvwsnbnzlhffkfwugfxkt6m@gleq22spziyk>
From: Barry Song <baohua@kernel.org>
Date: Mon, 4 May 2026 03:55:43 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y8JtCxEy9hVxVd8eaf8D9WC8BcRQp9afUVu=FJA1-awA@mail.gmail.com>
X-Gm-Features: AVHnY4Ib9xDIPW1tJ1arRI_zR4ugsASIRuQ44tzF-c_n00UjvUcn8YpRrQawfp8
Message-ID: <CAGsJ_4y8JtCxEy9hVxVd8eaf8D9WC8BcRQp9afUVu=FJA1-awA@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 88814100006
X-Stat-Signature: fa9kowhqi8zooytu31kpi9zot1x8ysx4
X-Rspam-User: 
X-HE-Tag: 1777838156-192442
X-HE-Meta: U2FsdGVkX1+cHWSuO6f+ccOw3Pmqb/SvNI33Ww9EMPpg6GlSpIhBefB7Ef9IGIos+gYlUT6HeBeS6h44oc75Ai0yybZR8vgPGXGDxKCgwyHkwb1rRtuiZyWQ76mXxvvfvSgb/lPuxA2PpuB+JThKuZRwbT5oagIfaB0lpKBNiUA0+6HHW0SWtd4xYhZNxewM3zaXou2qS87yVRQv5xp/XpRaosNdfDCPqXMIqcjm6fGIKMUEkMwWw5lb1PebFWEIQHJuHykX28bOfMLcDe5yPru//mB7g8W20EODlgtgn1z7XvDCtW5KOUAazhY6FRvMT65ZZeZ4FLQX+sKrFtCT2Iu8vPB51ZPV0p2sZ9IuSGpxEAPqxz5A11SIlDy/LQrUIwaZZsLveRd8FVEkcR3Y4ONqKK7zHVuApM7zfedi4XmZUBPUMoQMYfIOHprSWUctJlJQ952Ubq2hpT4fbB1DS34BaoIWr7E+FnD+G1qjfaTiFSERKqmVGU8kiXzknporyRdQbvIs3uSuZWd/nbuofhZ14X2dt0nAPhHQMMlKEG2C5LtvwZ0w2R2N/GWFVrUrLcgw4ZTo2EHs5Z8F/cw6v68V1YqjUjF47jeh1i5MRGKWs2ovoVRazSqxeef7jPWpD4sXnKDqvGxwTL/fwr+qwB/Ax7VkCLuDRaq3gj3XumgEYAV3mo5olqFImXyZc4nT+fVvFEjEuc35wqWjXV7aqsh/ThyctkUcr82yukguzsiOTEVVnXlhHptXHTil853shg++2jzfZi0mYJZhV5G9EWDWCAKofC5TA53HUsCbPLSnb/GQcuvqBp7ushaDYHoKFS21ShPt2qPlsX0BzPsK0S1gJONEe/BbiCXJkQr3gtwwYvl8U/B/zJF+EC4+xxkQ3ioAF+uMCuXfHVXgaH6JnlzIHtJRPaPOygSspXt3ubJlapBG29zpd5QrZwVaudWfDW6P9gWIZwXtbeFcvZQ
 wmnDRFw1
 Aobb7pJzChMNw2zqc10LYS9idrNLw6aLvuZJxE3hvReJjkKLagxkjTT4GHWhyt/+yK+LoKTcngIANdlfXgQTIRmycQwex8bQ4Ke0AbHpzqWEkU/MwcF87LvTgBr9YVh0RVjk5Cog0se3cU1cBev6TdryChwSQYvdUtKbBMSifZYFVahk62o4fUw33Xg1J7XZotwHWUDWgfnXzkUVNytBbyWtg9eJ4/+MlMSLrrDZrtTXHo7xcGLQRGVAZm7FESJ6KehIKmGs/g4o+hQxJGwjATSwIkhvvX/DVeAz+nRHum/8E61VTlxHjeBU3yBndro64TmSXRAqoSW19yqU7PXWsv08v3smLbEqtjftRpv9gf2momf4KWm4cJFEJg0SYDXeolh8AQboZd2fyRTsI0jfQ7ulhic39yWEfPZtSFSlfGNY5QsS4dzyJN4O7ujC4yBlabxPINJBAvyW8uB4H+Yd668dW43R4pvMnhiIQPOAGWxWsMg8yZXQP0caza972AWzzI9GkJ2e/kx2ttCESQlNOSJx39dKsEnlWn5RIhRkUfscAWSt8HaROx7oxd7drL84UEmVjVrbqbtoyOaUBgXk/XNVlbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 4, 2026 at 2:17=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Fri 01-05-26 18:57:52, Matthew Wilcox wrote:
> > On Sat, May 02, 2026 at 01:44:34AM +0800, Barry Song wrote:
> > > On Fri, May 1, 2026 at 10:57=E2=80=AFPM Matthew Wilcox <willy@infrade=
ad.org> wrote:
> > > >
> > > > On Fri, May 01, 2026 at 06:49:58AM +0800, Barry Song wrote:
> > > > > 1. There is no deterministic latency for I/O completion. It depen=
ds on
> > > > > both the hardware and the software stack (bio/request queues and =
the
> > > > > block scheduler). Sometimes the latency is short; at other times =
it can
> > > > > be quite long. In such cases, a high-priority thread performing o=
perations
> > > > > such as mprotect, unmap, prctl_set_vma, or madvise may be forced =
to wait
> > > > > for an unpredictable amount of time.
> > > >
> > > > But does that actually happen?  I find it hard to believe that thre=
ad A
> > > > unmaps a VMA while thread B is in the middle of taking a page fault=
 in
> > > > that same VMA.  mprotect() and madvise() are more likely to happen,=
 but
> > > > it still seems really unlikely to me.
> > >
> > > It doesn=E2=80=99t have to involve unmapping or applying mprotect to
> > > the entire VMA=E2=80=94just a portion of it is sufficient.
> >
> > Yes, but that still fails to answer "does this actually happen".  How m=
uch
> > performance is all this complexity in the page fault handler buying us?
> > If you don't answer this question, I'm just going to go in and rip it
> > all out.
>
> I fully agree with you we should verify whether the retry code still brin=
gs
> in real-world advantage today with VMA locks. After all the retry logic h=
as
> been introduced in 2010. That being said if there are realistic loads whe=
re
> one thread needs VMA write lock while another thread is faulting the VMA,
> then the latencies can be indeed extreme. For example things like cgroup =
IO
> throttling happen on the IO path and thus can throttle IO of a low-priori=
ty
> thread for a long time.

I=E2=80=99m quite sure that swap-in and VMA writes can occur
concurrently, and this is fairly common. For example,
Java GC may use mprotect or userfaultfd on a small
portion of a large Java heap while other portions are
still under do_swap_page().

If we start exploring different approaches for anon and
file, I agree I can revisit this on an Android phone if
there is a real, serious case where a file VMA can be
written and a page fault occurs at the same time.

Please note that, as an Android developer, I am particularly
cautious about priority inversion. A recent issue causing
severe priority inversion is zram attempting to support
preemption[1]. When a task performing compression or
decompression is migrated to another CPU and then preempted
by other tasks, high-priority tasks waiting on the mutex may
be significantly delayed, impacting user experience.

>
> BTW I'm not sure I quite understand Barry's priority inversion problem
> since I'd expect all threads of a task to generally be treated with the
> same priority...

Exactly not. Maybe these slides[2] and this project[3] can give
you a hint=E2=80=94they aim to standardize things on Linux by
learning from Apple OS. Basically, tasks are classified
into five types:

USER_INTERACTIVE: Requires immediate response.
USER_INITIATED: Tolerates a short delay, but must respond quickly still.
UTILITY: Tolerates long delays, but not prolonged ones.
BACKGROUND: Doesn=E2=80=99t mind prolonged delays.
DEFAULT: System default behavior.

[1] https://lore.kernel.org/linux-mm/20250303022425.285971-3-senozhatsky@ch=
romium.org/
[2] https://lpc.events/event/19/contributions/2089/attachments/1797/3877/Us=
erspace%20Assisted%20Scheduling%20via%20Sched%20QoS.pdf
[3] https://lore.kernel.org/lkml/20260415000910.2h5misvwc45bdumu@airbuntu/

Thanks
Barry

