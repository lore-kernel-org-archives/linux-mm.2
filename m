Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF53CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 20:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D93D38E00F4; Wed, 29 Oct 2025 16:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6BC88E00B2; Wed, 29 Oct 2025 16:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81988E00F4; Wed, 29 Oct 2025 16:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B74448E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:13:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B74C89105
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:13:55 +0000 (UTC)
X-FDA: 84052252830.16.4965802
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 65FAC14000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:13:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OoPRWTha;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761768833; a=rsa-sha256;
	cv=none;
	b=pBfZwyyx+iTcm3vSzxBR9exGmWWRqI5etn23pNWE7tvsJYPEqNKZ3FDyFXOLZr6EkNYixm
	zTo2C5uTGlf4x9cq769Iufz/CS8onhyF4aX31r1Kp+mVOXpLDQXtZo5ecXG2GdsO5NkJ78
	dZAp1WiE3Unm2xGyzgi1XEr468wv5qw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OoPRWTha;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761768833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxNKUqsLJOnot7UUBS6WN0bVpwUbu+IjTrx41B9jW8k=;
	b=1ILHJkaU5ZMX5fnZJyK4pEYglrVL0a+QCQHOAJj8RkczE0EJRHh2o3zH3lBYBaMKMSIzzx
	MSAOxHj+sgBbTFLLbKavjgBG0yDjktN36FhAkKc2LqtkOHJL3+FFUqQQwi6ePPoMIk6Mqw
	UEGt+l/KkWIGBQ/ZVhaOpscmBoMLNW0=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b5e19810703so40963166b.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761768832; x=1762373632; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxNKUqsLJOnot7UUBS6WN0bVpwUbu+IjTrx41B9jW8k=;
        b=OoPRWThaRnoRIBhpNBWAwhNSJQl8r0iUFfv8XC69wWatXHR+OMEANFlPsYK/AoYQ8V
         2dOXX8lTda8i1PoNzVEYzTYj1w5R7XoyWEn/USuXxYEh4t/Yosl5bdE9QPCZ0avikxU9
         pNJa0gWQ6lhxzsPjBhRuNs/FY/8+jojokOF6fOUU+GjZD6jqh26CJKDuez58NJvmV4PP
         bBvyPzp8Zvv5DiSCwf7pSaDs+ieSpNOMyhvbaGQwwU4QO7oZGipFHNG8B7jCzlJOn4BA
         V7R/+mVYjWjydWbD2eokPUp9p/hQwcL8t9WiSYUBixlOKZNXOPw1OGI3oVdjF3Q7T1Ma
         gzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761768832; x=1762373632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fxNKUqsLJOnot7UUBS6WN0bVpwUbu+IjTrx41B9jW8k=;
        b=SnI/7xgMTne4cLDBJrltwrLiLVG3Yz+NfLxdb7Nrsk2683mOpMZYXI3ZTxfHjiRHXT
         sr98G476g4rnik+e3ajRagD35eVG68L3g8xmf7T0AKiHIVXd3HLkDWp51nguZ3lWfr2Z
         1zRLqfgSNArWEINCePBSVHCf+XN0YIfYwzLQv6NBV3JbIBFCVC3ED3lcsk5/fO93gUVB
         7RaYJHkEsZOGWbymNEp9vOwoODk9OCvfbynAJkfq1NnTEsYFrPAKXXat8b9nz46kMbXl
         jgO5a1HgQIDy/m0JKxptVPnp0zJhIx0aX+/R59WNypsl9kvPaKo9brLHFiiuwItCavE2
         9sZg==
X-Forwarded-Encrypted: i=1; AJvYcCVXVOxUmcPCtAp16dfBGVB5rRVPeKAdrMvTauJnCCXnxEBLRRno4mrgghUVxhfFSWPbY/8UonnoXg==@kvack.org
X-Gm-Message-State: AOJu0Yw1unaXOhXeS7VhNF/AT4jOcZZIHfFIIBU/7am6vUJx3TeQV1xk
	clEjwN7VUWVP97JZxq9b98s8DEt9q9N+8PDXoPitHOO6dsYjPLElrbbQc7BmsRGb1Lxg4Lk71Px
	mAjBUZNyYReyfAmmmbcDrWBgYOEn5pMDRqPkRALoXBg==
X-Gm-Gg: ASbGncuwK/wXbDe4DNiBDL1rERVKHaY/Y4aa4YCARy9+zn/SWsaDcQw3rmO8xjze5W2
	j+WuGQO9eIpOZ6/XWXvwTQ7LCHWM8xtmlIzD1edRbvy8magXuWxzjUje7jP2NW3jSKJqbM9DAly
	NJQNR88Ff+IM7nxcZGe1fwpshcXLVBxig1iWQcbegDz8xZdpDC50ZnNAy7REHs5P4pdxow5DYRz
	DVEbaZq0WfjcYrfYzh1fOUz//Eyz0Rbne/zVpNbQXrKL25UKqrjstmIUUFoi8ue6GCc
X-Google-Smtp-Source: AGHT+IGrqbF9PW88BwcvYbeFbvOXRwoCun/iE1ZSEaorTMP1Ihb1MtG0h6t2CJQLQRZKh3kqkmFzEpEHa7ehLYOu0M8=
X-Received: by 2002:a17:907:72c4:b0:b45:60ad:daf9 with SMTP id
 a640c23a62f3a-b7053b0cf7amr50121266b.3.1761768831381; Wed, 29 Oct 2025
 13:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-15-pasha.tatashin@soleen.com> <mafs0tszhcyrw.fsf@kernel.org>
In-Reply-To: <mafs0tszhcyrw.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 29 Oct 2025 16:13:14 -0400
X-Gm-Features: AWmQ_bnKVfAOoreyDJlaPrAp9h8ss-TNKXA3PtoSrf7r-Gv5W7RZKx9AA8z_D0k
Message-ID: <CA+CK2bBVSX26TKwgLkXCDop5u3e9McH3sQMascT47ZwwrwraOw@mail.gmail.com>
Subject: Re: [PATCH v4 14/30] liveupdate: luo_session: Add ioctls for file
 preservation and state management
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, changyuanl@google.com, 
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 65FAC14000A
X-Stat-Signature: 1c9q9cceiribfu37sgnhsun1dpzmd663
X-HE-Tag: 1761768833-549735
X-HE-Meta: U2FsdGVkX19Ih1pr/ZyiWmQw29wEEE8y43WajhMMSk1hS7aC3cz92Xbp9kOySLO1DQy0YzdRdAY260AvFebVHmhhe4h5mHdRE5vlZzWzMde4dLOvc3Aob79GbdWMbs4lkpvHlaCQwO4/s6LQD+AgTctkfl87dl6bP65mMOnhLKQGac+TMpsTW7ok86frPZq59uPGSgtGhTwUKyJ6cAvzvBcXclGLQMaAgtTBJ4pg/KfP+3TyaL5s3m9rnnc9g3qmpazouuOqh9hav5MD2jMcZqtIAgLl9GyjuqLyCHKN/YQKP7fA7ciO74US3yGxT6+i0OLrcNOhP67FW32CVUk3wFs3iN7R52pdhrH6c6IW0BgTpb/WNfiRnsswNznHeavNHscLYbL59USRj6PUNW2EvX9Xsoa88eri3mCM1lW4a217tgrNjpHu1+gADRdYweydLPFPzemmjvPtj1ZBTcZPKkFpCwEc48Wdr+4ogiaruNsgvyvphe565L9OtSKsTRqC3up9SZkXZuIz4RlxX1c5W2IWfV4BBo6GjO1ChDXw4SyHf0SK7ndj/dCBwPYGG9AiNOIZSujH0qfupCuzCRa63qSEZt7nl4zZ8hcGWeX2YG6TeVnkAGcx2fU75Nll1U9tAAF77DFUGem66dyUP3/CrL8KI2twD6vZCU7T3vESLNjtPz2Ew/XykvmJTKWMVW2NOIchmSPeIqobW8xX5bRD0Y7gBGSBpFW1AE2nzwcGAfqFbQaXu6InxODrZ6wfbQLlR/m6lH+yBWDtmihZXmiR5oUsaL6LcR9183PjH7jxxmkQ9tzF94CeYGiXogvcvp/CClIkArZHMGm9sCJWxAUS8j4C/7qEFUzfW+qH2i6n4VEisOIRgfo12LB8enzyyQNQpIFuStzm3vMh9czBj8A7ekLF+yvc2u3QQz38pvycu0+gmDu24e5szvQY3toLt0WI4k/SZp6ffBqp2Qjahxk
 pZiQ8U8B
 56eN7wHaqd4IGt14KCZgu0pWI4HMGU1HjOdX15I8DEcXku8/3Q6VkOevhIMYYropLC2OCLL0iSkqswL3CQvk5ZKPODvfqiA/m+2pvecNmAfU8w2k2/KAxx8LCfZfgVxBLun3rXVbmJRgymDqa0ak7R72GwlmlZUXYjxooQ3cW2pHBZYQtdWX/qZEOctf7q1v+BPkyBoNnVx+r6keovPyGTEFTSlbsxMmiGNyrAxQuD3j7ewJG6EzaRq1irXI0UMbDmhzn6BG09c/jVXUgm5jzUpQUW6HAUgyuwt4ZBpvY/R51RWte46uuTr5cC2ScC67S4S1VdSsMu7GwyrKnlZO/CbPpTV7ZKMaCrqBG+dfIPx8249lpWRDdqs8p5/isDWqU+Txz3JjkPSOBBI0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 3:07=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> Hi Pasha,
>
> On Mon, Sep 29 2025, Pasha Tatashin wrote:
>
> > Introducing the userspace interface and internal logic required to
> > manage the lifecycle of file descriptors within a session. Previously, =
a
> > session was merely a container; this change makes it a functional
> > management unit.
> >
> > The following capabilities are added:
> >
> > A new set of ioctl commands are added, which operate on the file
> > descriptor returned by CREATE_SESSION. This allows userspace to:
> > - LIVEUPDATE_SESSION_PRESERVE_FD: Add a file descriptor to a session
> >   to be preserved across the live update.
> > - LIVEUPDATE_SESSION_UNPRESERVE_FD: Remove a previously added file
> >   descriptor from the session.
> > - LIVEUPDATE_SESSION_RESTORE_FD: Retrieve a preserved file in the
> >   new kernel using its unique token.
> >
> > A state machine for each individual session, distinct from the global
> > LUO state. This enables more granular control, allowing userspace to
> > prepare or freeze specific sessions independently. This is managed via:
> > - LIVEUPDATE_SESSION_SET_EVENT: An ioctl to send PREPARE, FREEZE,
> >   CANCEL, or FINISH events to a single session.
> > - LIVEUPDATE_SESSION_GET_STATE: An ioctl to query the current state
> >   of a single session.
> >
> > The global subsystem callbacks (luo_session_prepare, luo_session_freeze=
)
> > are updated to iterate through all existing sessions. They now trigger
> > the appropriate per-session state transitions for any sessions that
> > haven't already been transitioned individually by userspace.
> >
> > The session's .release handler is enhanced to be state-aware. When a
> > session's file descriptor is closed, it now correctly cancels or
> > finishes the session based on its current state before freeing all
> > associated file resources, preventing resource leaks.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> [...]
> > +/**
> > + * struct liveupdate_session_get_state - ioctl(LIVEUPDATE_SESSION_GET_=
STATE)
> > + * @size:     Input; sizeof(struct liveupdate_session_get_state)
> > + * @incoming: Input; If 1, query the state of a restored file from the=
 incoming
> > + *            (previous kernel's) set. If 0, query a file being prepar=
ed for
> > + *            preservation in the current set.
>
> Spotted this when working on updating my test suite for LUO. This seems
> to be a leftover from a previous version. I don't see it being used
> anywhere in the code.

thank you will remove this.

> Also, I think the model we should have is to only allow new sessions in
> normal state. Currently luo_session_create() allows creating a new
> session in updated state. This would end up mixing sessions from a
> previous boot and sessions from current boot. I don't really see a
> reason for that and I think the userspace should first call finish
> before starting new serialization. Keeps things simpler.

It does. However, yesterday Jason Gunthorpe suggested that we simplify
the uapi, at least for the initial landing, by removing the state
machine during boot and allowing new sessions to be created at any
time. This would also mean separating the incoming and outgoing
sessions and removing the ioctl() call used to bring the machine into
a normal state; instead, only individual sessions could be brought
into a 'normal' state.

Simplified uAPI Proposal
The simplest uAPI would look like this:
IOCTLs on /dev/liveupdate (to create and retrieve session FDs):
LIVEUPDATE_IOCTL_CREATE_SESSION
LIVEUPDATE_IOCTL_RETRIEVE_SESSION

IOCTLs on session FDs:
LIVEUPDATE_CMD_SESSION_PRESERVE_FD
LIVEUPDATE_CMD_SESSION_RETRIEVE_FD
LIVEUPDATE_CMD_SESSION_FINISH

Happy Path
The happy path would look like this:
- luod creates a session with a specific name and passes it to the vmm.
- The vmm preserves FDs in a specific order: memfd, iommufd, vfiofd.
(If the order is wrong, the preserve callbacks will fail.)
- A reboot(KEXEC) is performed.
- Each session receives a freeze() callback to notify it that
mutations are no longer possible.
- During boot, liveupdate_fh_global_state_get(&h, &obj) can be used to
retrieve the global state.
- Once the machine has booted, luod retrieves the incoming sessions
and passes them to the vmms.
- The vmm retrieves the FDs from the session and performs the
necessary IOCTLs on them.
- The vmm calls LIVEUPDATE_CMD_SESSION_FINISH on the session. Each FD
receives a finish() callback in LIFO order.
- If everything succeeds, the session becomes an empty "outgoing"
session. It can then be closed and discarded or reused for the next
live update by preserving new FDs into it.
- Once the last FD for a file-handler is finished,
h->ops->global_state_finish(h, h->global_state_obj) is called to
finish the incoming global state.

Unhappy Paths
- If an outgoing session FD is closed, each FD in that session
receives an unpreserve callback in LIFO order.
- If the last FD for a global state is unpreserved,
h->ops->global_state_unpreserve(h, h->global_state_obj) is called.
- If freeze() fails, a cancel() is performed on each FD that received
freeze() cb, and reboot(KEXEC) returns a failure.
- If an incoming session FD is closed, the resources are considered
"leaked." They are discarded only during the next live-update; this is
intended to prevent implementing rare and untested clean-up code.
- If a user tries to finish a session and it fails, it is considered
the user's problem. This might happen because some IOCTLs still need
to be run on the retrieved FDs to bring them to a state where finish
is possible.

This would also mean that subsystems would not be needed, leaving only
FLB (File-Lifecycle-Bound Global State) to use as a handle for global
state. The API I am proposing for FLB keeps the same global state for
a single file-handler type. However, HugeTLB might have multiple file
handlers, so the API would need to be extended slightly to support
this case. Multiple file handlers will share the same global resource
with the same callbacks.

Pasha

> > + * @reserved: Must be zero.
> > + * @state:    Output; The live update state of this FD.
> > + *
> > + * Query the current live update state of a specific preserved file de=
scriptor.
> > + *
> > + * - %LIVEUPDATE_STATE_NORMAL:   Default state
> > + * - %LIVEUPDATE_STATE_PREPARED: Prepare callback has been performed o=
n this FD.
> > + * - %LIVEUPDATE_STATE_FROZEN:   Freeze callback ahs been performed on=
 this FD.
> > + * - %LIVEUPDATE_STATE_UPDATED:  The system has successfully rebooted =
into the
> > + *                               new kernel.
> > + *
> > + * See the definition of &enum liveupdate_state for more details on ea=
ch state.
> > + *
> > + * Return: 0 on success, negative error code on failure.
> > + */
> > +struct liveupdate_session_get_state {
> > +     __u32           size;
> > +     __u8            incoming;
> > +     __u8            reserved[3];
> > +     __u32           state;
> > +};
> > +
> > +#define LIVEUPDATE_SESSION_GET_STATE                                 \
> > +     _IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_STATE)
> [...]
>
> --
> Regards,
> Pratyush Yadav

