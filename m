Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AE0A10F2847
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E13626B0096; Fri, 27 Mar 2026 11:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC38D6B0098; Fri, 27 Mar 2026 11:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA226B0099; Fri, 27 Mar 2026 11:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0A856B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:46:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28B1213C556
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:46:30 +0000 (UTC)
X-FDA: 84592270140.10.5EEFF75
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id BAD788000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:46:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=spSPVolE;
	spf=pass (imf30.hostedemail.com: domain of avagin@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774626388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owpdxFF3v/KlPV1csbkJ90RTaf+LQvkCMaflebyBvGw=;
	b=vl4j9MK/cPZUa+Q0xqqqtIgzCxd66vYjG2qHI56UKZGQXIjl8dwtFhwaKE5GCHM1jtDUAZ
	bK5odBZmu0/uemlOp81kPVHF2Ahr0pEnr2J0m0AIoulXmX8b0281O0AsqlCXR+BhXhkbMw
	aCLpPMcDb9ZYsLUsrthEl3dMd8mG61Y=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=spSPVolE;
	spf=pass (imf30.hostedemail.com: domain of avagin@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774626388; a=rsa-sha256;
	cv=pass;
	b=hY+KmO2cM+FRrmJl1OVEPccxD90Nw/d7bY1N1NB+LCUbaJ6VVMl0OszvasvxfXCd7P0deZ
	gn82Nl3krk9lXmcVzY0xkjYQ9CwL/gUxzBvH0GqQMEWMVKicSWL6iE+wC/TvVxVXpcyCay
	GmzhPPqQnDJnhE37ho16J02mXersCOU=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50b6c45781aso667131cf.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:46:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774626385; cv=none;
        d=google.com; s=arc-20240605;
        b=RLoKNKertftih4KztsVnsUps4n2b9zckXqM6B5Wly6BJm0yD257ZdIdEQoVAIy8VX5
         belHj4LKu0AEqZEI6Ie4tmAJ/tyfnNw74jM1fyRRGaHGI+MJhHJcHB6NkA/Dxm81xrnK
         XVw2qpUbHEkKeJk1OnJZbqWoO+95C9lHL4xThZ1RrwQ1x+EjOyS27hXjMpwHmh0vnJOZ
         QX+soqRFjFe/buJaQDh6hS9XiCDd8nInwf2WF7k17gZIp06u7X9YnB29GpXtxe5pQ0v4
         +ZKt+Nwf8pO2l9gwGXZ560YM/mgO/sxHmb7dOUHT+0C68WG0wtzTqxekmcdGj/qFknDa
         KuaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=owpdxFF3v/KlPV1csbkJ90RTaf+LQvkCMaflebyBvGw=;
        fh=lzSnYPyXcYMG0brDJCgDmvBJk2i5QvQE8v/9RPLP+f4=;
        b=LLjm3TJQI9BPWQrWS/Le/UmeACdCOYlhDfJqxreCOAxgNKW+al/uX9r5Jk/cQFeUwA
         SoLKMuRpKBbnwdpbl++wakP3UelyXzMC/HrKvUyamYy/erTEeQdMuzaU8WH9s9r47FiY
         I6RXNJWqKO9+y1HloDej9VU5Bbidpc+OCJb3gLEX1reAw9xAXaYqyXq7+SoFujlzEQlQ
         nPrQTKhpIUXl//wza69rCZU22/MVdLCheO/SoP57XZvXMZ6lnAriVrKxaQekxCU6DWyS
         e5FlZfZZznW/Iie4+oh1+5R1FK1gmBQYy6czjoE9ZNrBQji8aPYg9sFuK2fM5Fs8N4Qa
         insw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774626385; x=1775231185; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owpdxFF3v/KlPV1csbkJ90RTaf+LQvkCMaflebyBvGw=;
        b=spSPVolEnHe/pCMWZXKLeIZ4HuyHSL0GJEhwcADFdRx/uO0Czf4PiaTeWCiGQzPUvo
         NzexyJt18GtTHM5cAUru5vct9wCRY+P594AJH0ZvbkyASsTYxMYo8m9oFCWxsz8A9pL2
         Esg0JDu+lPPJb0nEevOQlKCGZ5XYGHsD1/e/MGaErgGXo2iMkRE7zjNt/GE69XO31OET
         XAmqZ4zwWvu8fHgMimNoSXhaBWUv/+biu1eTGAFeHG3rkO28paJVMq7oaEKG+obq9jBZ
         GtQqa8TWaXHkIvs/9XG2uvEAyRjNsIqBrsHp3ScTFrI6hjaMTbsnRvBMkx3dliX0zAwz
         7tmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774626385; x=1775231185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=owpdxFF3v/KlPV1csbkJ90RTaf+LQvkCMaflebyBvGw=;
        b=DILF6gIkMT7sen3pxz8QREM1Tji3zDfVm+ozqQW0LM1xtgRENSL6COdLVn9xN8h8Jh
         aTvGU+L4VRB+7OChWw0MYmJrIsgLJncHKo2UjmuIHSVzXm4cPSKjRt3cEcmuqlrQxGEC
         de39HRBgpMa7MbEbJsiOLs1g7H0vyq2oVQSVTYpmKB/50M0ikbGTHysRDX8I9AGisu9m
         S49V6XjbpOHc/5kMW6MNNBW8JS8p1Z0EEwdjZthzditgI9APDViLpdqWLeZgQ4zPLSq4
         cUctyypDbK4Wuwas/jy6alsh25qM8G9JUPNohiegNib8evfwpDbCc2iYuXmHD3YQKw6P
         3maw==
X-Forwarded-Encrypted: i=1; AJvYcCW9X8Py0KrfZixC71ePZXDwnJNiyGO4Fv9fdNhTMoGPN7HyvsB2JBE9M8+l5qZNEbTBdLHrH6j37A==@kvack.org
X-Gm-Message-State: AOJu0YwUUdQ/vzk6Z9DyqyP1KWH33tWlikw5r0FqnZ9hFYh4gH2a8R0v
	qfZV4jw6HbXFvmEgq5U19I9z0vIxF+0uq6EkkBw86DliIwzdELdg1yRFPwi0SaqRIJWw4oA3I5S
	IS4ANJX8l2JGc7eaqCq9Hn+UJCVk0hHbDW839OILt
X-Gm-Gg: ATEYQzyp9yOdwth/P0s9vfOwjuOcocOx4La9rAmBsLTYgkrisoXNKVjP0Lc/nUshs+D
	W4lfa/A8lDeCHhiZITviYVviQJpyCUHvQxpNBUYcirKGs/0NlCZq4aGk5DMkiod9ehIRL218m2G
	lev1wW+nQxsvahntq991BNXyjxYdn23Cc0qdSczzYjTfmJKRHrZg2+tOzyMAAyg21bgf0pFK0kS
	3XOF1knQVTu/CPEpszAC8j43ZuUZndoAJn40ul6X1UDi6dyqvoHXjlzDzzLtpfomKsqlcbn8Z9I
	c6BWxZk=
X-Received: by 2002:a05:622a:4c86:b0:509:72a:ae59 with SMTP id
 d75a77b69052e-50ba1cbeb9amr15605551cf.10.1774626384838; Fri, 27 Mar 2026
 08:46:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260323175340.3361311-1-avagin@google.com> <20260323175340.3361311-2-avagin@google.com>
 <acGEonF9I6sPA42B@J2N7QTR9R3.cambridge.arm.com> <acJnOB-rlyt-3jU4@willie-the-truck>
 <CAEWA0a7iR8YHooqXJfhersV6YhAXGMZDUhib3QQH5XGn=KNowA@mail.gmail.com>
In-Reply-To: <CAEWA0a7iR8YHooqXJfhersV6YhAXGMZDUhib3QQH5XGn=KNowA@mail.gmail.com>
From: Andrei Vagin <avagin@google.com>
Date: Fri, 27 Mar 2026 08:46:13 -0700
X-Gm-Features: AQROBzCbFCKKF5EGKvRVWmaQmxOKGk-clLCYQmcai8kbKMF-pnr8L4F1E1mL0vY
Message-ID: <CAEWA0a629qGEHvHpczGrZ+UBnzO75KgLsU7RoeR0cekmvaxLQQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] exec: inherit HWCAPs from the parent process
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Cyrill Gorcunov <gorcunov@gmail.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BAD788000E
X-Stat-Signature: mnx7bjwp5ys31o8ckmqj6qhgoeoc81qs
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774626387-785558
X-HE-Meta: U2FsdGVkX19guWHrAgzjH5QlhOQMlPw6YYjYwpVMSAAuYsb4aYBhb1Jnx9SNASN6fHCvz+3OFjg3l1eRLFWVO3FhCWFEGqy7NmnLNqfGe68RB/Eaw77BU+TSoStiHub2y/2LVQc/ML9JTP2onXxOkbopkGcD50lMcZOWrbyq2vjqopGloUl3u+Ysjqg/Jyld0oaRcF827me6YHy7pbCqF8zWkvQGA+6TQ00gowwSE29fnRVtkuBKVaW5Romi6M0Is9bamdVlI+/YbKyBSAQaEpAIceft1HI3pCCHERPctmaOMrWlhHOJRN4kr0NEtqQg+iO0w3oTtoq8tY22HhdLuu0aJQoOW3Z5x6ZhHWPUNTO37Fxy7OcCL8ntvLHU7UIP201znkXF55ZL2mXAAtggqaUGr+ZQx9QazLT1mgwZAob8BC0W60thITjrX01u2m6zwFcHznq0L+orjff9hZ9zmmDUbBRfrxVz3H4RMjNb2P6YYZW4firTK2AEUVaRYvrpWKI+uHMfQ+DNhi4gbcCXKAtMxUSnfZt0c5wmBAX9g8TqN4WORls5WKj49qdC/hFZa7KRTd/g3NVbneXkkKElAQsRzfAQvQgWIxoIzWm0vN5d9ZUS7/NLySE6vPq9eD7OWsqMaptQwDE/8SwXoInvnvBd+iYYuoWmF/prP4XGfR45SVhNiQLZvIZGgHR/FOKgO5JNXuAhZx9D47igsAcCnjthSiRDAvWQQqbvl7vPhRvKhDhBrLWZdYPqrQjNAnmUJjr3qhMQ2sO5dIStLbLq1q/5cYDo6hTC7Q270cBPkdRdkdQJ21riYbtz1wmqDwBJpBYMcGhrcx+66l2eaN40AVvdG/7aONIE6B8rTjMcnUkqMQg1Cwy4Fw1GfXe40vyEI/OWODDxbfho4efPsI42MovqBMrpfg2NV7clSu5XyZ0BDQoe5mtg6hjcrCsLRUMBh0O94QPaMR9LPEN6w/4
 t279ciiJ
 CoPvjYvQA28m4mZ1VjKDm62QCp4zVGZpDXymYT+HyqZDgONyb5v8sgqmAOUwffFg6mMYTCT/s/A8tI3Yyku+dIBQCHnUdzN6q0+LLiRDFv7P/kD5aWJU6eHDjWLgWv4Hf5ADVlLkUDg/QFuOqA4uSRPFS1Ov1jXh+rctQatlbibHgW+RSsOlafcLSqT8GcGIgVY6hQQ7fPTzqqQIniblgyj2POWjxS/9UMfIGdSRZNfXnL5XEULTD6D2AglsxG3wRgk8zX012iEHy8dX7+CeXFFKIJYvMxYgDT9QQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 3:19=E2=80=AFPM Andrei Vagin <avagin@google.com> wr=
ote:
>
> Hi Mark and Will,
>
> Thanks for the feedback. Please read the inline comments.

Mark, Will, just checking in to see if my explanation makes sense to you.
Let me know if you have any further feedback or questions.

Thanks,
Andrei

>
> On Tue, Mar 24, 2026 at 3:28=E2=80=AFAM Will Deacon <will@kernel.org> wro=
te:
> >
> > On Mon, Mar 23, 2026 at 06:21:22PM +0000, Mark Rutland wrote:
> > > On Mon, Mar 23, 2026 at 05:53:37PM +0000, Andrei Vagin wrote:
> > > > Introduces a mechanism to inherit hardware capabilities (AT_HWCAP,
> > > > AT_HWCAP2, etc.) from a parent process when they have been modified=
 via
> > > > prctl.
> > > >
> > > > To support C/R operations (snapshots, live migration) in heterogene=
ous
> > > > clusters, we must ensure that processes utilize CPU features availa=
ble
> > > > on all potential target nodes. To solve this, we need to advertise =
a
> > > > common feature set across the cluster.
> > > >
> > > > This patch adds a new mm flag MMF_USER_HWCAP, which is set when the
> > > > auxiliary vector is modified via prctl(PR_SET_MM, PR_SET_MM_AUXV). =
 When
> > > > execve() is called, if the current process has MMF_USER_HWCAP set, =
the
> > > > HWCAP values are extracted from the current auxiliary vector and st=
ored
> > > > in the linux_binprm structure. These values are then used to popula=
te
> > > > the auxiliary vector of the new process, effectively inheriting the
> > > > hardware capabilities.
> > > >
> > > > The inherited HWCAPs are masked with the hardware capabilities supp=
orted
> > > > by the current kernel to ensure that we don't report more features =
than
> > > > actually supported. This is important to avoid unexpected behavior,
> > > > especially for processes with additional privileges.
> > >
> > > At a high level, I don't think that's going to be sufficient:
> > >
> > > * On an architecture with other userspace accessible feature
> > >   identification mechanism registers (e.g. ID registers), userspace
> > >   might read those. So you might need to hide stuff there too, and
> > >   that's going to require architecture-specific interfaces to manage.
> > >
> > >   It's possible that some code checks HWCAPs and others check ID
> > >   registers, and mismatch between the two could be problematic.
> > >
> > > * If the HWCAPs can be inherited by a more privileged task, then a
> > >   malicious user could use this to hide security features (e.g. shado=
w
> > >   stack or pointer authentication on arm64), and make it easier to
> > >   attack that task. While not a direct attack, it would undermine tho=
se
> > >   features.
>
> I agree with Mark that only a privileged process have to be able to mask
> certain hardware features. Currently, PR_SET_MM_AUXV is guarded by
> CAP_SYS_RESOURCE, but PR_SET_MM_MAP allows changing the auxiliary vector
> without specific capabilities. This is definitely the issue. To address
> this, I think we can consider to introduce a new prctl command to enable
> HWCAP inheritance explicitly.
>
> >
> > Yeah, this looks like a non-starter to me on arm64. Even if it was
> > extended to apply the same treatment to the idregs, many of the hwcap
> > features can't actually be disabled by the kernel and so you still run
> > the risk of a task that probes for the presence of a feature using
> > something like a SIGILL handler or, perhaps more likely, assumes that
> > the presence of one hwcap implies the presence of another. And then
> > there are the applications that just base everything off the MIDR...
>
> The goal of this mechanism is not to provide strict architectural
> enforcement or to trap the use of hardware features; rather, it is to
> provide a consistent discovery interface for applications. I chose the
> HWCAP vector because it mirrors the existing behavior of running an
> older kernel on newer hardware: while ID registers might report a
> feature as physically present, the HWCAPs will omit it if the kernel
> lacks support. Applications are generally expected to treat HWCAPs as
> the source of truth for which features are safe to use, even if the
> underlying hardware is technically capable of more.
>
> Another significant advantage of using HWCAPs is that many
> applications already rely on them for feature detection. This interface
> allows these applications to work correctly "out-of-the-box" in a
> migrated environment without requiring any userspace modifications.  I
> understand that some apps may use other detection methods; however, there
> it no gurantee that these applications will work correctly after
> migration to another machine.
>
> >
> > There's also kvm, which provides a roundabout way to query some feature=
s
> > of the underlying hardware.
> >
> > You're probably better off using/extending the idreg overrides we have
> > in arch/arm64/kernel/pi/idreg-override.c so that you can make your
> > cluster of heterogeneous machines look alike.
>
> IIRC, idreg-override/cpuid-masking usually works for an entire machine.
> We actually need to have a mechanism that will work on a per-container
> basis. Workloads inside one cluster can have different
> migration/snapshot requirements. Some are pinned to a specific node,
> others are never migrated, while others need to be migratable across a
> cluster or even between clusters. We need a mechanism that can be
> tunable on a per-container/per-process basis.
>
> >
> > On the other hand, if munging the hwcaps happens to be sufficient for
> > this particular use-case, can't it be handled entirely in userspace (e.=
g.
> > by hacking libc?)
>
> CRIU often handles workloads with a mix of runtimes: some linked against
> glibc, some against musl, and others like Go that bypass libc entirely.
> CRIU is mostly used to handle containers that can run multiple processes
> possible based on different runtimes. It means available cpu features
> should not be only specified for one runtime, they have to be passed
> across different runtimes. I think the pure userspace solution is near
> infeasible in this case.
>
> Thanks,
> Andrei

