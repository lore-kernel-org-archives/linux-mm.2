Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC2B7CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 22:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70C578E010C; Wed, 29 Oct 2025 18:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BCC68E0106; Wed, 29 Oct 2025 18:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2EC8E010C; Wed, 29 Oct 2025 18:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6C08E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:00:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9871C072F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:00:37 +0000 (UTC)
X-FDA: 84052521714.05.E6E3AE8
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id CF46F2001C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:00:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T3LkS0is;
	spf=pass (imf13.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761775235; a=rsa-sha256;
	cv=none;
	b=UJCLuCqMZNBRYhFONX8fJWQ98OhUryUlnZi5sYOiVnw3qL7zNhqVtvGqmEDWH+T4pLCrvU
	iIvI8Zt3A2vAl8SCF512Z2dp0cmcLoKDipz3llWYXvr5BefpQ3WW8hJg7QtA1fFG9OH0QI
	2eO8ZAvOMwl5HKtOMaA6gUHk/lZ+/0s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T3LkS0is;
	spf=pass (imf13.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761775235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iLD3TQVOiWY5r3Odhgs8R7i+r0sY0ies83ZNYoXLOpk=;
	b=WRm8AXwaAUBziIu8Tt1aZssG8o1QC/xlW6s4pnTbaLIKcp3NNwle3FO9qCcEsDouXENull
	5GJ3uGgAuwZybS/SaqfXTnAsDK32uD/fbAIK9xYVNYKpPJePMpnR3prsRQmfRb1Y0pWr5+
	8ycSNItB1kIeF0EBS7xXgOriGlYrfQI=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-27eeafd4882so35445ad.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761775235; x=1762380035; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iLD3TQVOiWY5r3Odhgs8R7i+r0sY0ies83ZNYoXLOpk=;
        b=T3LkS0isuHdcwJGUwemdDNFsWXfeuYswg64U6qEuiGUIMx8tuWAlmuFw7m+bE/wEfa
         00KA1NbfojXnA7/P/ij6gKK1toe55lQy2q8sjZMLp8ArnbgJxkqXloc/fW7YDEnhF4nx
         wpcxF+XXFKKzEdHZWg1gvncLfLvLeNFt+ZwP4Xu+wlF3IqPGdVYrn0kWOTSqd160AUbn
         491Qe6LymhrNNS8/glE+bpR3WgRtQqdgLUJc7QrIl0EQv7Zhk3RwrPunoDDRHVxTzp7C
         HAvG/Deaab/ciJEl3sxFhvvLqvzHDI27+HZ/rPitfRLUYPLCybTPMpp7/i6mHMgIXCZy
         9QhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761775235; x=1762380035;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iLD3TQVOiWY5r3Odhgs8R7i+r0sY0ies83ZNYoXLOpk=;
        b=O3bY/Pa/EcjC5B6Nfm9F4DUM2eYLP2q/oLJpKh3fHqpgoROGujYCCS68uKOHf05RSW
         2iWxqdg7YhD6zvQS6dBLJmGE6qMCRtKtDcUlQnbf9ABaafjog8vvPSQDsWKUTSKs8aWU
         O+utTDKf+0M/TR4X+fS5Yj86j4eehpuVEAr5shM8eZ83VxThA4wg9tsn7afcbZDIzdSg
         tkIKLnnfRTALvV+B18veyKNiKHz//8Qwz+U9YbwKNGL7QswHQAAtRFRA2X+xERfbUeRc
         lykDNf+hc9JDr27LyB/xus2NBT2o0ATsycAYpuglYAqEMqB6Y9TM7sZF3HEEODD07kAQ
         nlig==
X-Forwarded-Encrypted: i=1; AJvYcCWf6GnrMjkNYVOs6INdUPSiowS/ifjMQOiBruI3qn7DMnuHS1NSyXeMWZKOFZg7NBhWEosRSzjoFw==@kvack.org
X-Gm-Message-State: AOJu0YwCSA6nl2kGQ9P/lr9eVhnM5zrqZF/WG3eAvOU3B17/2CqGC/0b
	ulSPPBHZc+cFecH9x/F+ytDX/PLfKyGoIKYoLpL2nwZEmyKxc0QCpyJZpHvqkkkkKCJhOhUvvv+
	XXemzq8POLgxMGnothIlity/uLDU8x+xGfJot4LgH
X-Gm-Gg: ASbGnct0cg0FOS9DAxfB//JAclLbEdRiVZnGi+2TWLWXsp5ThdXeuV19GYYq9oKp3zy
	tscSMlpGAIkq4qjL+BZhC+y62uOC4kRm+swTRlShqbpPIs62BdvChgZw1vyXYIK7U90f1w3duNE
	m4w69EMf07KmxWravOYDbppEy7NOIFTy2dOwoxvA7IGde19cbpFilBkemCwRR7u0+6enGx9TskE
	ITA64+Ee8jS2OEmzCoWzL17qw0EJ4+C6lYwsWr3Og7w4EWDjmLXWwQYDPKG49TEJptdZZRi80bo
	YFha3bhmS2hsoqNoS1qMYTWMGCbN
X-Google-Smtp-Source: AGHT+IGQiEL8ReoIvOwZKzbVpHBeTpPCQv29yrRij7Hwfs/n1+GX5gwd67TK3b+ch8zjTS1IjIo6qaeBI23B0BA9NWI=
X-Received: by 2002:a17:902:c40e:b0:26d:72f8:8cfa with SMTP id
 d9443c01a7336-294ef8d21c6mr633415ad.13.1761775233734; Wed, 29 Oct 2025
 15:00:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-15-pasha.tatashin@soleen.com> <mafs0tszhcyrw.fsf@kernel.org>
 <CA+CK2bBVSX26TKwgLkXCDop5u3e9McH3sQMascT47ZwwrwraOw@mail.gmail.com>
In-Reply-To: <CA+CK2bBVSX26TKwgLkXCDop5u3e9McH3sQMascT47ZwwrwraOw@mail.gmail.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Wed, 29 Oct 2025 15:00:20 -0700
X-Gm-Features: AWmQ_bkGoprZL04a0uQTcZsPv3KjOr3HxUN9sapy64_kyfy98s5fgevUjY0pmjs
Message-ID: <CAAywjhTbBx+rYGpPGtTw_--9XhoYZBX8ase5ddM6rxmC5J-2JQ@mail.gmail.com>
Subject: Re: [PATCH v4 14/30] liveupdate: luo_session: Add ioctls for file
 preservation and state management
To: Pasha Tatashin <pasha.tatashin@soleen.com>
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
X-Stat-Signature: pcynpoitn5wrfczp94mypt871m7wqg4x
X-Rspamd-Queue-Id: CF46F2001C
X-Rspamd-Server: rspam09
X-HE-Tag: 1761775235-587073
X-HE-Meta: U2FsdGVkX180rcPOT3ykHQ/IIXrP2GhH/tVDqxF2UIAiP/r05hbsIv50LrX6idxYSBG6fKJFioiEbb2C4kVriZGL35EVLBmbe3shpWScwPWwqxbrGG+Ix6+fz60u3UT0QmzeeSB+iyJ6uZw6AiaHMnmoTsytyz6h3XVbQysQEFoA+oXbAl9/DxKsVrkt2BiOQS4FgoS/qDuRMZNJJhGsJa0+aT4HYs0sPOkIKv3Izjdh0+4eErv5/sH/booE7IHi8JPRO1PBjdeXZ3QNINPk/WpdbkUylKxi3xCvDoDENlGSyGdUZ5IIaUgoJltQjQqJhiUyuJkT9bJXEom8BLel6T16A5rH34HuD+TIX9dDTynWuY9CyWhAMx1J2aoiGmNY2jlAE73WIAzbxWWZM+HWTvCcz98GshyCymy8vbqqvdO88iJ+GeERYFLhNneTmFvyEiPdQ8vstC+78gRab1AnuprgO7nh/rN6whYWmKRaLvrt6/TC7pQ82U3YNih7UVBOPHT6xIfcSIm0absnGhtPLDIRUG2Um01Os7GDWZ3as1B82lUj6HME4tIcEPfivLtZTeEKfT6/2I2f/SvV95gCC093x+OnsN/X3gEP/FlkaHS15nrObIhLH46/u2Mu/zzS5tf/QBW8QzKpW9kX5QiVQBsWY7oKHvdYht1accclMSw9o9qkeVEerPLuW75SDC2cIetyMCA8egoXmPjdTD6sQvOMEb3T6/WRmniTWbn9qf3A2ejwOX7JU9OCTnWxWDFojcB8EDcLodRgdMgv596yx075ecJoKMMqgZ6p2RdqP0OPKBy2saMPo4azAtSky8ND5ye0A/jkQEieejHVM4n9mKjumCKe16gBposdpblQlXNXvyIdoIwnQKWtud8jg72It9Rig4a3uxk/O/UBqu40p1mRQUy6EHfli49gGacOYgrPj0hGhEhYxPvRIVzsWHx4HwYLgZXZeGPqG5rKNlR
 OhHDfrqC
 rBXZ4pOAK8tAGxEUG6lxkHpeccRn4+PJ2CIJGCHMK7EWhAkasV5Eg7ujgTpYAR3AgxIPUVwb5IN8RxaR0P0BdJMKVDcHxXipUWskSqhl1KVtaTYq0y4VoXDGY0XtGGU/1jUFFUbCK9B2mZcOKd0wsY6O8UsaxknqJ9mHdqE2ehQihgMUurdDXlmLRnh7CM2I9YIXea1b9idkNztFd+myM2APbHe1CfltmH1StCrt6vnPc5USu19yjHrUHg2kMjejFSPeECzO4gqXgs6rQuCkYMZhBKH7Xqgnhv9j46wm1WfumijDgHNidVhZx4zxa/vezpcQlG7fXw/21blwKQgJZ0KaCL/+ZO7exhlyICU9k2YxiNBme5VR3A//hjic56Cgv6EtozxwUgnniXW8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 1:13=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Wed, Oct 29, 2025 at 3:07=E2=80=AFPM Pratyush Yadav <pratyush@kernel.o=
rg> wrote:
> >
> > Hi Pasha,
> >
> > On Mon, Sep 29 2025, Pasha Tatashin wrote:
> >
> > > Introducing the userspace interface and internal logic required to
> > > manage the lifecycle of file descriptors within a session. Previously=
, a
> > > session was merely a container; this change makes it a functional
> > > management unit.
> > >
> > > The following capabilities are added:
> > >
> > > A new set of ioctl commands are added, which operate on the file
> > > descriptor returned by CREATE_SESSION. This allows userspace to:
> > > - LIVEUPDATE_SESSION_PRESERVE_FD: Add a file descriptor to a session
> > >   to be preserved across the live update.
> > > - LIVEUPDATE_SESSION_UNPRESERVE_FD: Remove a previously added file
> > >   descriptor from the session.
> > > - LIVEUPDATE_SESSION_RESTORE_FD: Retrieve a preserved file in the
> > >   new kernel using its unique token.
> > >
> > > A state machine for each individual session, distinct from the global
> > > LUO state. This enables more granular control, allowing userspace to
> > > prepare or freeze specific sessions independently. This is managed vi=
a:
> > > - LIVEUPDATE_SESSION_SET_EVENT: An ioctl to send PREPARE, FREEZE,
> > >   CANCEL, or FINISH events to a single session.
> > > - LIVEUPDATE_SESSION_GET_STATE: An ioctl to query the current state
> > >   of a single session.
> > >
> > > The global subsystem callbacks (luo_session_prepare, luo_session_free=
ze)
> > > are updated to iterate through all existing sessions. They now trigge=
r
> > > the appropriate per-session state transitions for any sessions that
> > > haven't already been transitioned individually by userspace.
> > >
> > > The session's .release handler is enhanced to be state-aware. When a
> > > session's file descriptor is closed, it now correctly cancels or
> > > finishes the session based on its current state before freeing all
> > > associated file resources, preventing resource leaks.
> > >
> > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > [...]
> > > +/**
> > > + * struct liveupdate_session_get_state - ioctl(LIVEUPDATE_SESSION_GE=
T_STATE)
> > > + * @size:     Input; sizeof(struct liveupdate_session_get_state)
> > > + * @incoming: Input; If 1, query the state of a restored file from t=
he incoming
> > > + *            (previous kernel's) set. If 0, query a file being prep=
ared for
> > > + *            preservation in the current set.
> >
> > Spotted this when working on updating my test suite for LUO. This seems
> > to be a leftover from a previous version. I don't see it being used
> > anywhere in the code.
>
> thank you will remove this.
>
> > Also, I think the model we should have is to only allow new sessions in
> > normal state. Currently luo_session_create() allows creating a new
> > session in updated state. This would end up mixing sessions from a
> > previous boot and sessions from current boot. I don't really see a
> > reason for that and I think the userspace should first call finish
> > before starting new serialization. Keeps things simpler.
>
> It does. However, yesterday Jason Gunthorpe suggested that we simplify
> the uapi, at least for the initial landing, by removing the state
> machine during boot and allowing new sessions to be created at any
> time. This would also mean separating the incoming and outgoing
> sessions and removing the ioctl() call used to bring the machine into
> a normal state; instead, only individual sessions could be brought
> into a 'normal' state.
>
> Simplified uAPI Proposal
> The simplest uAPI would look like this:
> IOCTLs on /dev/liveupdate (to create and retrieve session FDs):
> LIVEUPDATE_IOCTL_CREATE_SESSION
> LIVEUPDATE_IOCTL_RETRIEVE_SESSION
>
> IOCTLs on session FDs:
> LIVEUPDATE_CMD_SESSION_PRESERVE_FD
> LIVEUPDATE_CMD_SESSION_RETRIEVE_FD
> LIVEUPDATE_CMD_SESSION_FINISH
>
> Happy Path
> The happy path would look like this:
> - luod creates a session with a specific name and passes it to the vmm.
> - The vmm preserves FDs in a specific order: memfd, iommufd, vfiofd.
> (If the order is wrong, the preserve callbacks will fail.)
> - A reboot(KEXEC) is performed.
> - Each session receives a freeze() callback to notify it that
> mutations are no longer possible.
> - During boot, liveupdate_fh_global_state_get(&h, &obj) can be used to
> retrieve the global state.
> - Once the machine has booted, luod retrieves the incoming sessions
> and passes them to the vmms.
> - The vmm retrieves the FDs from the session and performs the
> necessary IOCTLs on them.
> - The vmm calls LIVEUPDATE_CMD_SESSION_FINISH on the session. Each FD
> receives a finish() callback in LIFO order.
> - If everything succeeds, the session becomes an empty "outgoing"
> session. It can then be closed and discarded or reused for the next
> live update by preserving new FDs into it.
> - Once the last FD for a file-handler is finished,
> h->ops->global_state_finish(h, h->global_state_obj) is called to
> finish the incoming global state.
>
> Unhappy Paths
> - If an outgoing session FD is closed, each FD in that session
> receives an unpreserve callback in LIFO order.
> - If the last FD for a global state is unpreserved,
> h->ops->global_state_unpreserve(h, h->global_state_obj) is called.
> - If freeze() fails, a cancel() is performed on each FD that received
> freeze() cb, and reboot(KEXEC) returns a failure.

nit: Maybe we can rename cancel to unfreeze. So it matches preserve/unprese=
rve?
> - If an incoming session FD is closed, the resources are considered
> "leaked." They are discarded only during the next live-update; this is
> intended to prevent implementing rare and untested clean-up code.

I am assuming the preserved folios will become unpreserved during
shutdown and in the next kernel those folios are free.
> - If a user tries to finish a session and it fails, it is considered
> the user's problem. This might happen because some IOCTLs still need
> to be run on the retrieved FDs to bring them to a state where finish
> is possible.

Sounds great.
>
> This would also mean that subsystems would not be needed, leaving only
> FLB (File-Lifecycle-Bound Global State) to use as a handle for global
> state. The API I am proposing for FLB keeps the same global state for
> a single file-handler type. However, HugeTLB might have multiple file
> handlers, so the API would need to be extended slightly to support
> this case. Multiple file handlers will share the same global resource
> with the same callbacks.
>
> Pasha
>
> > > + * @reserved: Must be zero.
> > > + * @state:    Output; The live update state of this FD.
> > > + *
> > > + * Query the current live update state of a specific preserved file =
descriptor.
> > > + *
> > > + * - %LIVEUPDATE_STATE_NORMAL:   Default state
> > > + * - %LIVEUPDATE_STATE_PREPARED: Prepare callback has been performed=
 on this FD.
> > > + * - %LIVEUPDATE_STATE_FROZEN:   Freeze callback ahs been performed =
on this FD.
> > > + * - %LIVEUPDATE_STATE_UPDATED:  The system has successfully reboote=
d into the
> > > + *                               new kernel.
> > > + *
> > > + * See the definition of &enum liveupdate_state for more details on =
each state.
> > > + *
> > > + * Return: 0 on success, negative error code on failure.
> > > + */
> > > +struct liveupdate_session_get_state {
> > > +     __u32           size;
> > > +     __u8            incoming;
> > > +     __u8            reserved[3];
> > > +     __u32           state;
> > > +};
> > > +
> > > +#define LIVEUPDATE_SESSION_GET_STATE                                =
 \
> > > +     _IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_STATE)
> > [...]
> >
> > --
> > Regards,
> > Pratyush Yadav

