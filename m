Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B14CB10BA438
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 00:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C35A36B008C; Fri, 27 Mar 2026 20:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6CE6B0095; Fri, 27 Mar 2026 20:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE246B0096; Fri, 27 Mar 2026 20:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9342A6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:21:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 045A21A1421
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:21:40 +0000 (UTC)
X-FDA: 84593568402.13.AB3ED76
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2897110000C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:21:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=klHmp+Gd;
	spf=pass (imf05.hostedemail.com: domain of avagin@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774657299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9bPtEBHXKpRO9CjXfaCqUQKt7R+Gz6rl79/OVT+YNo=;
	b=RN9XCv99CTruY0M8Z6342xjOSq0EhVq3w60Gj8e9BmPsfl43kI8xqGOy4ZSFIBDJa1/Muf
	R0UrXmRUr35UcEMPDpcHU7pub49EoHGCuvW4mDwIoBHuAqBDPg7BM61RzYfQkFY5NxbOMn
	hDwJ7UYy0Bt4h+NGe8LDMgyeFdsaBv4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=klHmp+Gd;
	spf=pass (imf05.hostedemail.com: domain of avagin@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774657299; a=rsa-sha256;
	cv=pass;
	b=OV93ku+oBGxo5uWMbJGyR1g07m8yS151BNedTt7O4/hT4f7bL7BdXL4LK060tDnqzYB8fb
	c6NPFBEJ04dxiH1fwFJlZXG5BHvaUSKvwgmAey9zKyOT8fwqoBELb0vQXoUouDCjEXesOw
	oXtvN3srA7eQIzx3SHzOblFtYkQleZI=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-50b6c45781aso239191cf.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:21:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774657298; cv=none;
        d=google.com; s=arc-20240605;
        b=K2td7PsEFgZ2JBZWjVGUk68asPzPd8YAYTJ/Eqo5T/PqtYzrYHXpqddasQdBrTL29Q
         iCvZOZq/UtvNDqy9Sn3BcEJTG3iFRuPQcNCVVgaymo+NYASm9BJYd0jOIKMdJVrcjSH+
         HrbbHxbGKgP/WATen4pMOY3ElR2Dmj17h4zMOXRGHlW5qdVD1qya4SZZ1rIXhBn9KAP5
         NHbrOaXdZrRw4U/iJ1uM3DIqwI9vRudrZdsEXrXXsc2xll9IAdDAjKR5FtwsiaIYooo3
         WNHEJpvm1s9uNMJf95N11zTlicWqH6eHBB948fYZFaMlh1S7Lywgr+QNwNbzVMyCxvd7
         YBEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K9bPtEBHXKpRO9CjXfaCqUQKt7R+Gz6rl79/OVT+YNo=;
        fh=ydqE2YWiJXzzJJwfj+h1ih+AUCdxBRHsFDbfpJa2c1g=;
        b=KE8HwtwcSeqndm9KX0FIWOb8ctGgotJiWGbSB2KdNiMT+3Fs4md4x1ZJAbLEge6E/N
         oSnCmGV61hV1EKJnh4njdZfg7H7mteVaggXSDDaYu4h4mys7tK9VVywd4CR+IgFtlBN4
         EiW2ZJy5h2+MferiQKK+LP579DHYhCpyOV/NbxKnlnxHQm80LyAiYbXqS0ouaTZYan7h
         98M3K56EUiQNENV+Al7PnWgK9BjeqsPJPFbqsEEIcZscBz3suZLbWREOhBsd5M8/aL17
         7cfYl7zF817STlZXf33LBqlZx2m8YMCKGtmO1aCFaoW38WifHxPr50ruIDNPkUiW+hMo
         DDeA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774657298; x=1775262098; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K9bPtEBHXKpRO9CjXfaCqUQKt7R+Gz6rl79/OVT+YNo=;
        b=klHmp+GdbZDcahcGTylesji7kBehPmH2bs1+O90mrDnLTTWEy9yTMddE7pV7FUnmVA
         /xAzXKujPzWwxuPjJoi3BeHBMpxux2cYzX15CTBPKojeeDdzavjVuh/vuFgKTG9qr6sX
         TcvCPSYswbgqV0wD7aDOrNPp2zvI6PN2amkGsncFVybI7pROeLd5K04wW6pxTXwdI1Os
         wME6hMVOeldjcpHyY9Yx2AMjxq4WfSm2JZKngxB1l0SBEAKaHSioWwNa7gILArnWZAl6
         +H16K3/tiVn5xzC298ITQmVHeHq0+Zh/y3rSVLkyUqrXjfQVL59Gxq6UMDsTJjXgRJEA
         0EjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774657298; x=1775262098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K9bPtEBHXKpRO9CjXfaCqUQKt7R+Gz6rl79/OVT+YNo=;
        b=hWDulJ8zOFLGsbQvSmzVjGZnF+sr+O1WGd5qhHZzI+GZ3qNd7FW9p4LjGLIYW2yvwR
         Q/X1v/ZrfQE+5/rGPHupLom3UQdQ49g9+5j4qDCnp4Eq2tW0QX8Mb5ocaaQqhRv6lb05
         919gFBrml1WrYxz0t3kdMZ4xHrD7F4E2HTgmTLTknZama4I0noARveKppnBQBBN5iqt1
         uYBwvPmwC0QSnv0p/qTvTwsKujo95VS0P/zLJcsDgldQE/wWT0djPlk/2revqEP+7AM9
         AxTqbnVR/ARLpUxXr2zYUmV8xVTXYoCgCD6EmonyJ7JQNmwkpUa2eOwuT4HZeSryMjtZ
         GHTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaP0A/xWX2Br22HR4wC3b+sIn/vG18m0I8JpEfoTb0pTS6SWlvIT0KxJCVdLGImDDPuloV2YC/VA==@kvack.org
X-Gm-Message-State: AOJu0YxRgui59+Ryid+MvPnXN3btn1VLNrknBnCtE+q7l0qNJ7JlFiez
	df/d5dl/T4hq5UY7DpNKNUUFMNPruPDFdMHmVfq6EtWRTrlzj/e8ZLOLyHrwBvIKWAOGQaBwRUv
	l5jrSxEDy+dGFcFCilgcdAnYXWdyYyDFQJc6oz3LW
X-Gm-Gg: ATEYQzy9fV5VMVhrSmb9N3xnPGUp5rTHsgnjSl33agxVxuQuPIe9UDgPlRfNVAKIDy7
	kyQNAbR7P42p0HxtBqHKXM14ANJ4xfCdSPcY5JYZLk/OFL/Fms1e3sjPz1CNvfbIaLY2HKedP5K
	ot3JkllzmTbk0UGgbnuKmpFU4XU+mc6ZUAFOZQVq4OmNMAMjCHshduASr+4XDLR+9cOPh0FY7qe
	Jv67WiBnLue6rc7twlFJHAYfjAhyu2l9mi/SUTQfi2Hyxit5e4p4PiXHBNuuA2IIqKDNPz0+yOh
	S0D0e1asNzpPMUanuw==
X-Received: by 2002:a05:622a:4c8e:b0:509:14f0:bff2 with SMTP id
 d75a77b69052e-50bb27f62edmr6416861cf.12.1774657297623; Fri, 27 Mar 2026
 17:21:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260323175340.3361311-1-avagin@google.com> <20260323175340.3361311-2-avagin@google.com>
 <acGEonF9I6sPA42B@J2N7QTR9R3.cambridge.arm.com> <acJnOB-rlyt-3jU4@willie-the-truck>
 <CAEWA0a7iR8YHooqXJfhersV6YhAXGMZDUhib3QQH5XGn=KNowA@mail.gmail.com> <acarA3sGKY4Acozw@J2N7QTR9R3.cambridge.arm.com>
In-Reply-To: <acarA3sGKY4Acozw@J2N7QTR9R3.cambridge.arm.com>
From: Andrei Vagin <avagin@google.com>
Date: Fri, 27 Mar 2026 17:21:26 -0700
X-Gm-Features: AQROBzAZx6vusK91xtphbHO0OyQ8WklBK8fprRQAhCkwYE-GzsBGKaet5s4vnp4
Message-ID: <CAEWA0a7AZiuy1F+0LDxtEtJpdu=zA-RKhPb1wcDMpy2tSMFO5g@mail.gmail.com>
Subject: Re: [PATCH 1/4] exec: inherit HWCAPs from the parent process
To: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>, 
	Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2897110000C
X-Stat-Signature: moekwc1m4bmgu8qsueiutidygk9krocs
X-Rspamd-Server: rspam06
X-HE-Tag: 1774657299-48625
X-HE-Meta: U2FsdGVkX18rQ5v3fhh8C88GwtBNkKHNe95qh1XBnUjvbP99noJwXYH+fKtiOt7QQKuOuzMtmx9wiLh5ZJWPs7gunUHsyCo30a0Pa2X8vqHHvzWmEK/sndMDhDIXTPI00c8y0cJH89+80UFKNzazfwjSCyn2OQiEtg+O2OFpWPBwqBtK0a76Sz3O8X/cxjtrDwwo0+mCPWPh3lRw9pSYYPYQRmsz7TnotzPmh1wvjPTXZUGRLzwp5hBPizfU0P/KOwHB09bFlaOx4UwtLlrtAy1iPjL1ARtsEMf8i/JEjRjgbGXlHc0t4CRG+PNDrNvjvyQJvwJaCmtnosiHZI5z4MYUxFfjAyP1rAUHyqBS69S6NFnhyha+Jv0et5LUTFae+6omGVPiAUu++Sq2NioE2XisvVjo+7jG/a/QZK7uuEwrlS7MuUg1dN2Nm/uESzFyvZN+yv6VZjGMi8RCs7QGIfEl59+STspQ02SzVkvQb2TImieJYFs3AHNVZa3Lw4knkmUPX8QPNHg1nhkkS1gfrpHOAdKfOOPHaZWwd99s3lmBaVAswI2b0nZhEfaIq2jRPS5PGx+TnnGzMre9s8hQHxeoHHbWXJ1b3Z4Z6ItTOV4uo1E4CL6z8dXWYgx81Jw5845RcU/zoymRT8Zh39yRg4/ay0w1TDFbU0moQ8bCp6/FSupnyxMqWuq+RMbi/CWNebmzcgy1KRdO02aKk1UmMfxb9zJOklw9HmYYqMms2VCMimmBpcp3Uf1MNoFnM/xxXZjLZZo15Gl4Aiev61eQ4Ne9isqIJwhN5qKwENaqfOggLHIs+IPnCmW0Yvq8DnNzIf5hbCZRQXAv3U4ci0y5YgPSShPMev6p9x3pF/do2pmfBFnPyE3zzit81UR8EuDoCnq0O74gWF+Im+W4qFjETbm8+g63d0a5Gpn76hIsluLRhau1Gkn73gOJo5CGRKnspbzC81dzu04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 9:06=E2=80=AFAM Mark Rutland <mark.rutland@arm.com>=
 wrote:
>
> On Tue, Mar 24, 2026 at 03:19:49PM -0700, Andrei Vagin wrote:
> > Hi Mark and Will,
> >
> > Thanks for the feedback. Please read the inline comments.
> >
> > On Tue, Mar 24, 2026 at 3:28=E2=80=AFAM Will Deacon <will@kernel.org> w=
rote:
> > >
> > > On Mon, Mar 23, 2026 at 06:21:22PM +0000, Mark Rutland wrote:
> > > > On Mon, Mar 23, 2026 at 05:53:37PM +0000, Andrei Vagin wrote:
> > > > > Introduces a mechanism to inherit hardware capabilities (AT_HWCAP=
,
> > > > > AT_HWCAP2, etc.) from a parent process when they have been modifi=
ed via
> > > > > prctl.
> > > > >
> > > > > To support C/R operations (snapshots, live migration) in heteroge=
neous
> > > > > clusters, we must ensure that processes utilize CPU features avai=
lable
> > > > > on all potential target nodes. To solve this, we need to advertis=
e a
> > > > > common feature set across the cluster.
> > > > >
> > > > > This patch adds a new mm flag MMF_USER_HWCAP, which is set when t=
he
> > > > > auxiliary vector is modified via prctl(PR_SET_MM, PR_SET_MM_AUXV)=
.  When
> > > > > execve() is called, if the current process has MMF_USER_HWCAP set=
, the
> > > > > HWCAP values are extracted from the current auxiliary vector and =
stored
> > > > > in the linux_binprm structure. These values are then used to popu=
late
> > > > > the auxiliary vector of the new process, effectively inheriting t=
he
> > > > > hardware capabilities.
> > > > >
> > > > > The inherited HWCAPs are masked with the hardware capabilities su=
pported
> > > > > by the current kernel to ensure that we don't report more feature=
s than
> > > > > actually supported. This is important to avoid unexpected behavio=
r,
> > > > > especially for processes with additional privileges.
> > > >
> > > > At a high level, I don't think that's going to be sufficient:
> > > >
> > > > * On an architecture with other userspace accessible feature
> > > >   identification mechanism registers (e.g. ID registers), userspace
> > > >   might read those. So you might need to hide stuff there too, and
> > > >   that's going to require architecture-specific interfaces to manag=
e.
> > > >
> > > >   It's possible that some code checks HWCAPs and others check ID
> > > >   registers, and mismatch between the two could be problematic.
> > > >
> > > > * If the HWCAPs can be inherited by a more privileged task, then a
> > > >   malicious user could use this to hide security features (e.g. sha=
dow
> > > >   stack or pointer authentication on arm64), and make it easier to
> > > >   attack that task. While not a direct attack, it would undermine t=
hose
> > > >   features.
> >
> > I agree with Mark that only a privileged process have to be able to mas=
k
> > certain hardware features. Currently, PR_SET_MM_AUXV is guarded by
> > CAP_SYS_RESOURCE, but PR_SET_MM_MAP allows changing the auxiliary vecto=
r
> > without specific capabilities. This is definitely the issue. To address
> > this, I think we can consider to introduce a new prctl command to enabl=
e
> > HWCAP inheritance explicitly.
> >
> > > Yeah, this looks like a non-starter to me on arm64. Even if it was
> > > extended to apply the same treatment to the idregs, many of the hwcap
> > > features can't actually be disabled by the kernel and so you still ru=
n
> > > the risk of a task that probes for the presence of a feature using
> > > something like a SIGILL handler or, perhaps more likely, assumes that
> > > the presence of one hwcap implies the presence of another. And then
> > > there are the applications that just base everything off the MIDR...
> >
> > The goal of this mechanism is not to provide strict architectural
> > enforcement or to trap the use of hardware features; rather, it is to
> > provide a consistent discovery interface for applications. I chose the
> > HWCAP vector because it mirrors the existing behavior of running an
> > older kernel on newer hardware: while ID registers might report a
> > feature as physically present, the HWCAPs will omit it if the kernel
> > lacks support.
>
> On arm64, the view of the ID registers that userspace gets *only*
> exposes features that the kernel knows about, as userspace reads of
> those registers are trapped+emulated by the kernel. On arm64 it's
> not true to say that something appears in those but not the HWCAPs.
>
> I understand that might be different on other architectures, and so
> maybe this approach is sufficient on other architectures, but it is not
> sufficient on arm64.
>
> > Applications are generally expected to treat HWCAPs as
> > the source of truth for which features are safe to use, even if the
> > underlying hardware is technically capable of more.
>
> I'm fairly certain that there are arm64 applications (and libraries)
> which check only the ID register values, and not the HWCAPs.
>
> Architecturally, there are features which are detected via other
> mechanisms (e.g. CHKFEAT), for which HWCAPs are also irrelevant. Even if
> that happens to be ok today, there are almost certainly future uses that
> will not be compatible with the scheme you propose.
>
> I don't think we can say "applications must check the HWCAPs", when we
> know that applications and libraries legitimately don't always do that.
>
> > Another significant advantage of using HWCAPs is that many
> > applications already rely on them for feature detection. This interface
> > allows these applications to work correctly "out-of-the-box" in a
> > migrated environment without requiring any userspace modifications.  I
> > understand that some apps may use other detection methods; however, the=
re
> > it no gurantee that these applications will work correctly after
> > migration to another machine.
>
> I think the existince of applications that detect features by other
> (legitimate!) means implies that there's no guarantee that this feature
> is useful and will remain useful going forwards.
>
> For example, what do you plan to do if an application or library starts
> doing something legitimate that causes it to become incompatible with
> this scheme?
>
> I don't want to be in a position where userspace is asked to steer clear
> of legitimate mechanisms, or where architecture code suddently has to
> pick up a lot of complexity to make this work.
>
> > > There's also kvm, which provides a roundabout way to query some featu=
res
> > > of the underlying hardware.
> > >
> > > You're probably better off using/extending the idreg overrides we hav=
e
> > > in arch/arm64/kernel/pi/idreg-override.c so that you can make your
> > > cluster of heterogeneous machines look alike.
> >
> > IIRC, idreg-override/cpuid-masking usually works for an entire machine.
> > We actually need to have a mechanism that will work on a per-container
> > basis. Workloads inside one cluster can have different
> > migration/snapshot requirements. Some are pinned to a specific node,
> > others are never migrated, while others need to be migratable across a
> > cluster or even between clusters. We need a mechanism that can be
> > tunable on a per-container/per-process basis.
>
> I think that's theoretically possible, BUT it will require substantially
> more complexity, to address the issues that Will and I have mentioned. I
> don't think people are very happy to pick up that complexity.
>
> There are many other aspects that are going to be problematic for
> heterogeneous migration. Even if you hide the HWCAP for a stateful
> feature (e.g. SME), it might appear in one machine's signal frames (and
> be mandatory there), but might not appear in anothers, and so migration
> might not work either way. Likewise, that state can appear via ptrace.

Hi Mark,

I understand all these points and they are valid. However, as I
mentioned, we are not trying to introduce a mechanism that will strictly
enforce feature sets for every container. While we would like to have
that functionality, as you and will mentioned, it would require
substantially more complexity to address, and maintainers would unlikely
to pick up that complexity. Even masking ID registers on a per-container
basis would introduce extra complexity that could make architecture
maintainers unhappy. There were a few attempts to introduce container
CPUID masking on x86_64 in the past.

In CRIU, we are not aiming to handle every possible workload. Our goal
is to target workloads where developers are ready to cooperate and
willing to make adjustments to be C/R compatible. The goal here is to
provide developers with clear instructions on what they can do to ensure
their applications are C/R compatible. When I say "workloads", I mean
this in a broad sense. A container might pack a set of tools with
different runtimes (Go, Java, libc-based). All these runtimes should
detect only allowed features.

Returning to the subject of this patchset: this series extends the role
of hwcaps. With this change, we would establish that hwcaps is the
"source of truth" for which features an application can safely use. Any
other features available on the current CPU would not be guaranteed to
remain available after migration to another machine.

After this discussion, I found that the current version missed one major
thing: there should be a signal indicating that hwcaps must be used for
feature detection. Since we will need to integrate this interface into
libc, Go, and other runtimes, they definitely should not rely just on
hwcaps by default, especially in the early stages. This can be solved
via the prctl command.  Libraries like libc would call
prctl(PR_USER_HWCAP_ENABLED). If this returns true, the runtime knows
that only the features explicitly listed in hwcaps should be used.

You are right, the controlled feature set will be limited to features
the kernel knows about. And yes, we would need to report CPU features in
hwcaps even if the kernel isn't directly involved in handling them.
Honestly, I am not certain if this is the "right" interface for that,
and I would be happy to consider other ideas. I understand that these
hwcaps will not work right out of the box, but we need a way to solve
this problem. Having a centralized API for CPU/kernel feature detection
seems like the right direction.

As for signal frame size and extended states like SVE/SME, we aware
about this problem.  However, it is partly mitigated by the fact that if
an application does not use some features, those states are not placed
in the signal frame. In the future, when we construct/reload a signal
frame, we could look at a process feature set for a process and generate
a frame according to those features...

Thanks,
Andrei

