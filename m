Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B777FCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1842E8E000F; Tue, 16 Sep 2025 14:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B4E8E0001; Tue, 16 Sep 2025 14:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0989A8E000F; Tue, 16 Sep 2025 14:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED06E8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:23:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8EB3119391
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:23:20 +0000 (UTC)
X-FDA: 83895935760.04.E2C7976
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id C7A1D4000E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:23:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NZDa1RpM;
	spf=pass (imf11.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758046998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VxUZE7TC0xZyMAyFa+6mdSBsb32RFob5X99goi87Xdw=;
	b=H7t3PsQoe+rcpbjPvLDQ9prMJl+PLplBOdzUrzqhXPAg+vDcrRRYwargy2QysJgdrM1yJW
	kIin2N5Imv85NJVigoLYKMBNIWJW1ZjiV2FHyMOn6PbW1/EcHcJ7tRgoj6LKL7/GvmXqr3
	fOEXZlk3BL0iBnC6zycmLDn60E5ReAI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758046998; a=rsa-sha256;
	cv=none;
	b=DcMjTo5z48SpfCmTs6KwRFrtO9nQp2k2znAfCYUk2ELJFp7XsXRPPfwtNhwtJyIVc9ev6A
	k0yzcc966tTvfIw7VCq7azButPw1xFGjL6VWbHhLFeZmuPFj07tAP0eRjGjSN3m9MOMQeY
	KmJhb0BT7nXJjxD/l5tjskErkgVKJVQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NZDa1RpM;
	spf=pass (imf11.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-265abad93bfso23045ad.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758046997; x=1758651797; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VxUZE7TC0xZyMAyFa+6mdSBsb32RFob5X99goi87Xdw=;
        b=NZDa1RpMCNhrjDMkboDkAZWaGO7aYqdw1LZjLWGAxK86prfetEfT0Iwkk30uPu2Zcn
         RM7IKIQNv40ixxEUAMXhVqQEDdmAwLb2Gz7qciV5fu7hrHMDHFu/ty0s6v2V2dgqRedP
         yuxj0Pl3/2ZaguVqzjQdGBoJmfJjYBrNV5iDxNqe+Pt6koliSM/Xb40HGKR0HJ3YwM85
         Owrgv8MjujEIxBG/YmcYdXrmfWHH8hBN6KjwXMixrDrVOejLIcYGiVE56bmIJmmYTQL4
         cX4JTCdQ4PHQa8xqaeRtOk4AY/DINlFFTOYBqFNY3bfe2r5TL4OMtNz5haZ0c2Edk2d1
         nizA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758046997; x=1758651797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VxUZE7TC0xZyMAyFa+6mdSBsb32RFob5X99goi87Xdw=;
        b=SlCdvwCaGXNhorkxVOJ7WxiqMmM4WkTEiMY/73/JiwSRsmAnGe9dxb5FmIDPrCyGO7
         20Qs9F3Czua206KDqyHutbCDISMNxWSAnvtGeVXfF2PJK+AJVbiDb5vuvL8JaVVsC7Fo
         JwqnXTEv/E+sMUDO8smOHNUuR8B8HpIo/96+iOs338EPTQBZ2mAv/QvE/b3G3sQ82l3k
         pDyH858LP90xxyt2l4jsKakKARmxLcTwRxbwIqO42ruOWQEiIxjn/iFvu7RtJmK6gZG9
         LQw0T+/VawKWJeJNNKdrl8ryF7Zr95SJTGdKNmhoFRtwX0GkKswsrbHu9g2bS95OEXUT
         g4wA==
X-Forwarded-Encrypted: i=1; AJvYcCXc09Ev/hntvs0zsp0P7YRusmOBSkmme+yVCEd6sohBcNmbQfX/1pCs8nM4SUcgkH6cc7mK6OUOKQ==@kvack.org
X-Gm-Message-State: AOJu0YzOieT/jbaEIy9ddRNOYleHGZdQyMOfNAwuZGVIHgLWchOJjPe3
	wB1dgJ2W8CHVmgqIj55SAeux28VGJfFuubRQaN0N/F82jpnxkYfX4mMDJtpbd/umUJZBM8wTSQK
	nX08/7iAgrAYU/zeou4CAQtZy/ji0Z5JgyUut3Dpw
X-Gm-Gg: ASbGnct8phMXjFI4xGsifupa7uCfGguEfcDWQ9pB7/Cn2JijedUG1v+c5fveBJIsm7S
	1/XlNiizr0zXakYBSLKS1vX+hqjjDD0gE2n1BHTwDE5k50J5qFHG4Cbk9P9GhWSJY3HJ8fOeyZz
	MMWblwozcMBOaHc+PqP7tKGFjI3RDJiiY4YK+bC98iHsRFMfXwS2gmkuUcY5Vaj5YojtrTf+xtF
	qDHNFd/m/xfQ0LIkkkblf/Pw1z4Dp7jSJLOA6f1L/GFpTKX/j1DVo4=
X-Google-Smtp-Source: AGHT+IFeMeqAy+cuIfy8BDPUr07CVnLWSx0isY1COTxmQUhbfeHhUc/gJKs+z9vTXpQo6NDvDMpWAnnnlJDkjgySN7E=
X-Received: by 2002:a17:902:d2c9:b0:266:b8a2:f605 with SMTP id
 d9443c01a7336-2680120ed16mr333025ad.3.1758046996934; Tue, 16 Sep 2025
 11:23:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-8-kaleshsingh@google.com> <20250915194158.472edea5@gandalf.local.home>
 <CAC_TJvconNNKPboAbsfXFBboiRCYgE2AN23ask1gdaj9=wuHAQ@mail.gmail.com>
 <20250916115220.4a90c745@batman.local.home> <CAC_TJvdkVPcw+aKEjUOmTjwYfe8BevR51X_JPOo69hWSQ1MGcw@mail.gmail.com>
 <20250916134833.281e7f8b@gandalf.local.home> <CAC_TJvc6aqjBRZ05wyGb49AU+-aKpSph=ZSk3fdV2xraXi-_nQ@mail.gmail.com>
 <20250916140245.5894a2aa@gandalf.local.home>
In-Reply-To: <20250916140245.5894a2aa@gandalf.local.home>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 16 Sep 2025 11:23:03 -0700
X-Gm-Features: AS18NWDeydKXZzxWqGElteJppqO6QozHlpb4s_Ylp5BcEhKGMmDvVoyYUojBOGg
Message-ID: <CAC_TJvfAQDiL9PydWnKE6TDMcCzw0xrsLMZVZLe6eO0R1LODhA@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] mm/tracing: introduce max_vma_count_exceeded trace event
To: Steven Rostedt <rostedt@goodmis.org>
Cc: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de, 
	kernel-team@android.com, android-mm@google.com, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uaxsbo7hkou74ngj9431y61menm4mjhp
X-Rspamd-Queue-Id: C7A1D4000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758046998-432391
X-HE-Meta: U2FsdGVkX1+eaRzwm7GUvkhOX8W+RMwudMvLo/6OepBuPmfGVVJN30CESIQJQYbXvNqTP7EXG+OEi+xRuGlF0Mv30hqPEEwC51yweBDslLyDn3E1beHtT3Jdp3b2p4dRJqpKjW6lLJObnzVJ++UBnvmheDsgxqqLiCcjj3BMjR8mwZV60QzVLVzB8pKMLNCx2uIKG3Sa78RJzADu2zhAVIEpKMHIHBWQdFk9jVLyiQnARlwIgkuwF1hXvlbLDzBtX1Rv+8J1LVE0nNzrLJn65D+ZnX4/2Vv+syNCebzVeG5yH7wVaSo8PPRifBVvopFC58dwjm672YvLoqa3aCBTQCYx9yiJDgy2KUP3rE9VBTEn22AVOJylNJTOMhD62XU+k+3v6PDkeIfwEW5Z/NpZXlR3yku83nQc0ywIxtRcd8yUYlVrNHZJMSIG1SU1sEb7v9zz3BhRCu3vjbeOXH4+vJg0gNQLTxJe8p/TErTl78Zwg1bzmg06b3Nu8cYcOkGbHthIfh12ilYLHUFDZpGZ3+H/Fs4/8vz26jSbEijzPliHW8FmNHYANq0nIYF1LvHPExK+fhTu3kvAmNP5jlSW+ccz243A0V6scVmlQBmOUTDm+G2TCoDBjtAQxKnwM+VKmKS9tOG+fuXCeF+cwvPXvmPk2Wjeoa7pv6vGvHVyBLYoRJRjuCTWKFPtn7jlPVKEk5L1qctF2t3i22hwYZO48DI7etSqm9lRbOqHDPUufSLBwez8efETGH8GnsMpcR8Z2W29wyqd70WS6gxDV2/gvDi+ZOXj0dz+A+hWQ0OEY5xhSzDjdj1zzAjetNoTi/9OUrh+MWpBMU07/AkKQl2mzqmFZPzQGckJvoRFSnbYEIV1PtJ+JdBbWIDeR6SzqMKV/z07YEQYSttX/UouFRE0Smz3zA66Au0XT+NmPGsmRwQPBX8lQYHcE3UDtLjRwzqaoDk2IQkdcHXSy7wikFP
 RkXdnz91
 o4Gy0lyBg1WQ3RkYAzu//OGs/cjT1aDQWadzm9sy8K1hrYKGXSlzDvyyRNiN4XT0bTMXRDZ0WnV1elVcSVEyug75c6xVtdzFqLypAJ5XdE3HGs1/CekqqZtIjLPiCwsOQHFn0GFzWLcK+581lqIPrI5EGEEKetutW4dbEt/gwv2VXgwGesvI7sj1JZnzLhFWg36iuIxmHyIi1vw86dHsDj9B4MlfTSa7VZuqNy7T4WxmcuOSMWTO9l9awjnw1wpyKK3ZTvrWrY9BzrBXJuqjVEdN6vFUfgCab52nMwVY0RjpvbFD6M3cjLTmATXgY8cCQIJlZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 11:01=E2=80=AFAM Steven Rostedt <rostedt@goodmis.or=
g> wrote:
>
> On Tue, 16 Sep 2025 10:57:43 -0700
> Kalesh Singh <kaleshsingh@google.com> wrote:
>
> > > BTW, why the hash of the mm pointer and not the pointer itself? We sa=
ve
> > > pointers in lots of places, and if it is the pointer, you could use a=
n
> > > eprobe to attache to the trace event to dereference its fields.
> >
> > In Android we try to avoid exposing raw kernel pointers to userspace
> > for security reasons: raising /proc/sys/kernel/kptr_restrict to 2
> > immediately after symbols are resolved for necessary telemetry tooling
> > during early boot. I believe this is also why rss_stat uses the hash
> > and not the raw pointer.
>
> When it comes to tracing, you already lost. If it goes into the ring buff=
er
> it's a raw pointer. BPF doesn't use the output of the trace event, so you
> are exposing nothing from that. It uses the proto directly.

My understanding is that the BPF tracepoint type uses the trace event
fields from TP_STRUCT__entry(); whereas the raw tracepoint type has
access to the proto arguments. Please CMIW: Isn't what we'd be adding
to the trace buffer is the hashed mm_id value?

>
> Heck, if you enable function tracing, you are exposing every function
> address it traces via the raw data output.

Right, security doesn't allow compiling CONFIG_FUNCTION_TRACER  in
Android production kernels.

Thanks,
Kalesh

>
> -- Steve

