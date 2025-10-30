Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9C5FCCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 14:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303E38E007F; Thu, 30 Oct 2025 10:45:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4978E007D; Thu, 30 Oct 2025 10:45:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17D5C8E007F; Thu, 30 Oct 2025 10:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0108C8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:45:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAF321A0167
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:45:47 +0000 (UTC)
X-FDA: 84055054734.13.A110C1A
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 96DE7A0018
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:45:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Jha3HIHm;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761835545; a=rsa-sha256;
	cv=none;
	b=ivMt3gjvKah0ibxmmxNjnrIjMlqOYL15dHS5Z03toS/hLUqfTKu51TnUR/BtE3Q4KRCE6x
	GQ+47VQ3JICQGcpXjRfrAGAJsL/e0l67xXgWNgDWDEMfov93YEsQQD8E4yvcvjMJNsXEI0
	u5FbA2b79K0GWtBjpKMKil4GBrmyICE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Jha3HIHm;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761835545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+q1WnNkV6oI/Ffptxas5/IbEl8V9x7m1lbLHWaOLlOc=;
	b=x71LgQqISbLfZW3MD1yJriH5Qo7X6wlnoJ1iRpnaVRQYKVDnIsXUcSNLoqGOfvUezwFW3a
	2CuUQADVVTxfJKKFqMV9LHCsV94JFBVx5vuXeu8VErFW0INncNihvshZhsLOvtN/xX+AdU
	yb2h8bqwsZ774/OS9FurTnnWrpAksNw=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6399328ff1fso1976666a12.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 07:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761835544; x=1762440344; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+q1WnNkV6oI/Ffptxas5/IbEl8V9x7m1lbLHWaOLlOc=;
        b=Jha3HIHmWXopDF9R73wgIezA9y3dQlZk4QTaD6Jug73L+O2pPowmd3BPRVT0bk+5BD
         wXX1onPZc7CDTu7BQirZEJ54+udFKxRqzRLxJ/bHGCn1p8mHVqrYDKqixjQvwEo5oWtk
         hqGZgZqi7me/iqz2Uz5A+0m8zkiaFhArf3fUjvvWH1NX/5WECbANQLju2gtOoTucOvO2
         TykBoCHu4H1XKn9rVGHqpVOKZE5+cJigB28dwvg2N08J+/U+VTTvYAOQMR6mCpGMeARZ
         aaQhkh4o0LM7rqu1cqDUQDKE54muFhNoU7JER5q9JX8VlxBzcjmP0HV/hfSm5jQ/4OJe
         30cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761835544; x=1762440344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+q1WnNkV6oI/Ffptxas5/IbEl8V9x7m1lbLHWaOLlOc=;
        b=e7nKOBWV5yIXFZcW6BHMTXgVNupiX9loUeo9tL5mTXqI8U5diZMpcoPfurZjUUj3lt
         phXFTMhrVTBcWbTi5Vefr7FhaipVpQmKOMGGG6a9tomtJlJF6Fhi7o5JhipeTQ7B38/l
         /y+RYpsk5ZD36/7mUnrVO3lP0diCRpjcbCm3y7dhlUG2xI7fqRG0cxpNpayEribGlzse
         UYcsl8Zm8z4PbRNfN8gEYdhMkZO+r7qDCfwEb/l2/MaMAAw+PaZVgl9aMXYo0/ug9/fI
         sEx0hV/tdpRdkP0MLaQKps0XIrw6dAPPTpC1Sf3oHywoWTwr4j7Xb5i1aCO2fvvk0h5N
         vuMw==
X-Forwarded-Encrypted: i=1; AJvYcCW/2huHQAruCAAmpV2yrQ9Xm/6LXjBimjilP9BZfYSXeYA6ybblS5hBWQBbr6/FNE5rO3i25M8thg==@kvack.org
X-Gm-Message-State: AOJu0YyE6Y5euktcQNS+8UKY/kavvix4wotigxLzgdS85GApwDf0mUrS
	CwV4eGDGjiCGJg0OgNwmdCV5yvOG+aqXGa++aE+nKMjggFOFwI+WI1/DKgEZEq/VpiqK8IhHcbr
	FPLZGS09dk7P/CiBmH3gU1B6dzqZ6W5z+c8/K4Owivg==
X-Gm-Gg: ASbGnctfgQHAATTSEUyDSAbnIsWKQ1kOM6YrzJJsYA83PkArCcFlb93MVMKYAiQtwyZ
	35PTFLjAS4sJf+IjcecXAYtsoYHMLzdf8we8CKkHaKxqyXj7NfKVuEXem1UmCihN2HhSFUx19CM
	KvakfqGpwf+lnxJzseOlUf11bO1t0vtT5lGGg6AgKvlIL7lGe/L1yg9yrwmF8BonX1P5HDA0eTd
	Olgx2pXTwGpxf45TU9pYW0bh38xyOhxoo3FrJ02zepb8obtRRu2WZ6v3sQ+8r/DApvp
X-Google-Smtp-Source: AGHT+IGDU4/Gkv1R1qd17xLlVAOgOMmcUmYUsrlTksKyc7NoB+oWGvlCOuq9OeegwnOVOhMBaIm81jNVaYjX67APFf4=
X-Received: by 2002:a05:6402:d08:b0:63c:2d72:56e3 with SMTP id
 4fb4d7f45d1cf-64044252e1amr5523342a12.23.1761835543199; Thu, 30 Oct 2025
 07:45:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-15-pasha.tatashin@soleen.com> <mafs0tszhcyrw.fsf@kernel.org>
 <CA+CK2bBVSX26TKwgLkXCDop5u3e9McH3sQMascT47ZwwrwraOw@mail.gmail.com> <CAAywjhTbBx+rYGpPGtTw_--9XhoYZBX8ase5ddM6rxmC5J-2JQ@mail.gmail.com>
In-Reply-To: <CAAywjhTbBx+rYGpPGtTw_--9XhoYZBX8ase5ddM6rxmC5J-2JQ@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 30 Oct 2025 10:45:06 -0400
X-Gm-Features: AWmQ_blojHtPMG7BDXtmPjNBm90NSboe9qJfp5atDPpsuilsmQAVEvUy6gel7ys
Message-ID: <CA+CK2bC8Ge0WM84ei1JGpqTzsZXeP6B3VXbSiNW6ZmHmQsXHCg@mail.gmail.com>
Subject: Re: [PATCH v4 14/30] liveupdate: luo_session: Add ioctls for file
 preservation and state management
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: s3h6f43t8peiht3cijfxwnnwgeowp6da
X-Rspamd-Queue-Id: 96DE7A0018
X-Rspamd-Server: rspam09
X-HE-Tag: 1761835545-722801
X-HE-Meta: U2FsdGVkX185YgygKE5/1jMYGJMCHPoLmA4n/++zV4f9fTCn8tH3DBTH0pvC7Ntw7diiSrxg4zIPP1nHWZ4qlAN1V4NHsTBLvVwc/PzWXFHzCxMzVJ6KttilPUKenpOH6ErBdYzmQK3nHgXHMExouyT6YIrtUOu8wctuO4LGLbgv36EFPfG5rRiqvgoilKZC12bGHSme0lXEvH14hCvOm7selZtt3Q7SM2t67aMT3DqtDvYJIoLleCe+LnQKvwThMVzovg5glYii2gOXyPJZJdADo4nfbcWZpI3LBGlUbxoJrlrCZS+/3fYTNYp1PlVOLpt4vUA1LcZ+B5DS1gfPMLzKQ4GcIwJQSsvgEL8zOGoxCZmwcK6GBHtlc2igN9Wd2zN5IbeTW00Ad667gegtHJuX2cTcKoXjh2hxNdEQJnOpQJA0UERr+DREfAjFCQrLuEzGnVYyNqGaRjj/TGn9bhZlRiR1l43Z5HRzsPLnm7OUqKRjGT/gVv+CLmrxjsCzKWaHWGwnDChqwU9Rc8OPOq3uuREOs4C0se6NeBe21iqxWox8U8EoRy+EB1iXGUCk7je/yszgwQih6cJPWSHds2EeuC1IL3NsmsxpCwoU+PbQgVbbF6rqGx1exKrnULnhv2dcprpSgYAFESp7Snddf7hPwQF//EavoVPNTpiIeX22jnNbV43MMar+4VvD8IUPzVXnusVc05XoziYLh8hKjL1oDpTGtHAM1r+frj6RlgN/yrtQu13tOStg+bCDTxtvJU+1h0GEiArU+DogMs83Uii6PdCJSlAAOBnBGHpqpW7EfH/9CP6rTLXhGn/qKZo9vcxA8PEmcqz4A9QqAQcPgjFB4OP71rtssFoahNKheKYmmwojnpVUb9zZyDEKA+iNATo6M+HOqSsOwwEdeGIoKeZpfwEWkKucmUZJxxTwI/ljqfX0+X06ETKeVcHLfCQuQwA7ZMnbJS9jTakm/Wx
 CWp8V4iR
 Tdq/wLg49tM1OG2Im4KlXNqT/5Ecq4bXlk8/8fT7PChq/frQ9x2c3/DEo8OCTXlzUBZAPd9kd3DAMFTQSkRvkJ6IVM4o3KCRbVlw/KsqiFu/OF9RsTdMpbPLZ8V7UAgMU14rZEdTwsekTlMVNXxQ2slhG3JC29L41n4/Sc2aDN0C3nl0BgvJWBXTMRRE7TpExHkmUbqBm19zdhISw2nWhRzG/ZVbSbASPNOChGqA+kG7d9dc0t7NqJcpQIHgfcjsT/3M++5ZDBrbaYp5PGW6FmwzLUr6vee3dus4Cd8uGEkp9Hasl73cOmF5ED9pZ5qeDmjQJLiSg5lcwMc2s5G9W2o0NGGFRUE0svwk0LcBzaLw30DCzjUfDIztLZnjfJDuRavK5QSGqbLYyfw/GWZA2PlFTGdJm/Ito2Lk6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 6:00=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
>
> On Wed, Oct 29, 2025 at 1:13=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > On Wed, Oct 29, 2025 at 3:07=E2=80=AFPM Pratyush Yadav <pratyush@kernel=
.org> wrote:
> > >
> > > Hi Pasha,
> > >
> > > On Mon, Sep 29 2025, Pasha Tatashin wrote:
> > >
> > > > Introducing the userspace interface and internal logic required to
> > > > manage the lifecycle of file descriptors within a session. Previous=
ly, a
> > > > session was merely a container; this change makes it a functional
> > > > management unit.
> > > >
> > > > The following capabilities are added:
> > > >
> > > > A new set of ioctl commands are added, which operate on the file
> > > > descriptor returned by CREATE_SESSION. This allows userspace to:
> > > > - LIVEUPDATE_SESSION_PRESERVE_FD: Add a file descriptor to a sessio=
n
> > > >   to be preserved across the live update.
> > > > - LIVEUPDATE_SESSION_UNPRESERVE_FD: Remove a previously added file
> > > >   descriptor from the session.
> > > > - LIVEUPDATE_SESSION_RESTORE_FD: Retrieve a preserved file in the
> > > >   new kernel using its unique token.
> > > >
> > > > A state machine for each individual session, distinct from the glob=
al
> > > > LUO state. This enables more granular control, allowing userspace t=
o
> > > > prepare or freeze specific sessions independently. This is managed =
via:
> > > > - LIVEUPDATE_SESSION_SET_EVENT: An ioctl to send PREPARE, FREEZE,
> > > >   CANCEL, or FINISH events to a single session.
> > > > - LIVEUPDATE_SESSION_GET_STATE: An ioctl to query the current state
> > > >   of a single session.
> > > >
> > > > The global subsystem callbacks (luo_session_prepare, luo_session_fr=
eeze)
> > > > are updated to iterate through all existing sessions. They now trig=
ger
> > > > the appropriate per-session state transitions for any sessions that
> > > > haven't already been transitioned individually by userspace.
> > > >
> > > > The session's .release handler is enhanced to be state-aware. When =
a
> > > > session's file descriptor is closed, it now correctly cancels or
> > > > finishes the session based on its current state before freeing all
> > > > associated file resources, preventing resource leaks.
> > > >
> > > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > [...]
> > > > +/**
> > > > + * struct liveupdate_session_get_state - ioctl(LIVEUPDATE_SESSION_=
GET_STATE)
> > > > + * @size:     Input; sizeof(struct liveupdate_session_get_state)
> > > > + * @incoming: Input; If 1, query the state of a restored file from=
 the incoming
> > > > + *            (previous kernel's) set. If 0, query a file being pr=
epared for
> > > > + *            preservation in the current set.
> > >
> > > Spotted this when working on updating my test suite for LUO. This see=
ms
> > > to be a leftover from a previous version. I don't see it being used
> > > anywhere in the code.
> >
> > thank you will remove this.
> >
> > > Also, I think the model we should have is to only allow new sessions =
in
> > > normal state. Currently luo_session_create() allows creating a new
> > > session in updated state. This would end up mixing sessions from a
> > > previous boot and sessions from current boot. I don't really see a
> > > reason for that and I think the userspace should first call finish
> > > before starting new serialization. Keeps things simpler.
> >
> > It does. However, yesterday Jason Gunthorpe suggested that we simplify
> > the uapi, at least for the initial landing, by removing the state
> > machine during boot and allowing new sessions to be created at any
> > time. This would also mean separating the incoming and outgoing
> > sessions and removing the ioctl() call used to bring the machine into
> > a normal state; instead, only individual sessions could be brought
> > into a 'normal' state.
> >
> > Simplified uAPI Proposal
> > The simplest uAPI would look like this:
> > IOCTLs on /dev/liveupdate (to create and retrieve session FDs):
> > LIVEUPDATE_IOCTL_CREATE_SESSION
> > LIVEUPDATE_IOCTL_RETRIEVE_SESSION
> >
> > IOCTLs on session FDs:
> > LIVEUPDATE_CMD_SESSION_PRESERVE_FD
> > LIVEUPDATE_CMD_SESSION_RETRIEVE_FD
> > LIVEUPDATE_CMD_SESSION_FINISH
> >
> > Happy Path
> > The happy path would look like this:
> > - luod creates a session with a specific name and passes it to the vmm.
> > - The vmm preserves FDs in a specific order: memfd, iommufd, vfiofd.
> > (If the order is wrong, the preserve callbacks will fail.)
> > - A reboot(KEXEC) is performed.
> > - Each session receives a freeze() callback to notify it that
> > mutations are no longer possible.
> > - During boot, liveupdate_fh_global_state_get(&h, &obj) can be used to
> > retrieve the global state.
> > - Once the machine has booted, luod retrieves the incoming sessions
> > and passes them to the vmms.
> > - The vmm retrieves the FDs from the session and performs the
> > necessary IOCTLs on them.
> > - The vmm calls LIVEUPDATE_CMD_SESSION_FINISH on the session. Each FD
> > receives a finish() callback in LIFO order.
> > - If everything succeeds, the session becomes an empty "outgoing"
> > session. It can then be closed and discarded or reused for the next
> > live update by preserving new FDs into it.
> > - Once the last FD for a file-handler is finished,
> > h->ops->global_state_finish(h, h->global_state_obj) is called to
> > finish the incoming global state.
> >
> > Unhappy Paths
> > - If an outgoing session FD is closed, each FD in that session
> > receives an unpreserve callback in LIFO order.
> > - If the last FD for a global state is unpreserved,
> > h->ops->global_state_unpreserve(h, h->global_state_obj) is called.
> > - If freeze() fails, a cancel() is performed on each FD that received
> > freeze() cb, and reboot(KEXEC) returns a failure.
>
> nit: Maybe we can rename cancel to unfreeze. So it matches preserve/unpre=
serve?

Sounds good, I will call it unfreeze() instead of cancel().

> > - If an incoming session FD is closed, the resources are considered
> > "leaked." They are discarded only during the next live-update; this is
> > intended to prevent implementing rare and untested clean-up code.
>
> I am assuming the preserved folios will become unpreserved during
> shutdown and in the next kernel those folios are free.

That is right, KHO does not keep memory preserved for the next reboot.

> > - If a user tries to finish a session and it fails, it is considered
> > the user's problem. This might happen because some IOCTLs still need
> > to be run on the retrieved FDs to bring them to a state where finish
> > is possible.
>
> Sounds great.
> >
> > This would also mean that subsystems would not be needed, leaving only
> > FLB (File-Lifecycle-Bound Global State) to use as a handle for global
> > state. The API I am proposing for FLB keeps the same global state for
> > a single file-handler type. However, HugeTLB might have multiple file
> > handlers, so the API would need to be extended slightly to support
> > this case. Multiple file handlers will share the same global resource
> > with the same callbacks.
> >
> > Pasha
> >
> > > > + * @reserved: Must be zero.
> > > > + * @state:    Output; The live update state of this FD.
> > > > + *
> > > > + * Query the current live update state of a specific preserved fil=
e descriptor.
> > > > + *
> > > > + * - %LIVEUPDATE_STATE_NORMAL:   Default state
> > > > + * - %LIVEUPDATE_STATE_PREPARED: Prepare callback has been perform=
ed on this FD.
> > > > + * - %LIVEUPDATE_STATE_FROZEN:   Freeze callback ahs been performe=
d on this FD.
> > > > + * - %LIVEUPDATE_STATE_UPDATED:  The system has successfully reboo=
ted into the
> > > > + *                               new kernel.
> > > > + *
> > > > + * See the definition of &enum liveupdate_state for more details o=
n each state.
> > > > + *
> > > > + * Return: 0 on success, negative error code on failure.
> > > > + */
> > > > +struct liveupdate_session_get_state {
> > > > +     __u32           size;
> > > > +     __u8            incoming;
> > > > +     __u8            reserved[3];
> > > > +     __u32           state;
> > > > +};
> > > > +
> > > > +#define LIVEUPDATE_SESSION_GET_STATE                              =
   \
> > > > +     _IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_STATE)
> > > [...]
> > >
> > > --
> > > Regards,
> > > Pratyush Yadav

