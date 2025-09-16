Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2EBCCAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 01:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7C6E8E0005; Mon, 15 Sep 2025 21:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2D3A8E0001; Mon, 15 Sep 2025 21:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1BD48E0005; Mon, 15 Sep 2025 21:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC2C58E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:20:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EC62BB571
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:20:09 +0000 (UTC)
X-FDA: 83893357338.15.3FBD9EB
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id 654694000A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:20:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2a36A4iv;
	spf=pass (imf27.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757985607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7oc+YeAQI9jR6qkHLGj/AqXsrGbk3uwxOS3oQGgb06Q=;
	b=q5x937nqzf7dSZROaS6zX2OI/sCmv9sF8xtqRxXwUe/da8wXmfN80oOq6njRtYYnjrmmzN
	DU0ODrqZshlOC44beKxVjSCw7Nzjc4qWDkmbUplcLWk4bJIoSnDib9Gh+0Gtj8z72F1jt+
	9yTfwAg/cHe3CNlykORz/8RXMdyHfP4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2a36A4iv;
	spf=pass (imf27.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757985607; a=rsa-sha256;
	cv=none;
	b=1xL8vmWlh5DBYqphRNtQZngDV8fm7920U3yd99s6ghcZEZG248ueBmE88kIIMdF2uA/Byi
	Cs8leoygWoldN3r2xDbC+shS8UaZVZNq24BjSNYm9IhYJuiNmPJYoLjhHP+R3PLDaub7fk
	HGkdaqxLqKl4gW/FzHx2FogRvWXfl+o=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-265abad93bfso78435ad.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757985606; x=1758590406; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7oc+YeAQI9jR6qkHLGj/AqXsrGbk3uwxOS3oQGgb06Q=;
        b=2a36A4ivnGThSeEZPYJgie3cLHxDJlild87waCMoo2gNDrosL2LMpI9LldConRrvBq
         9iMzK5ir6Q0G1+NsDqFyo2wsG65aSAbJXL1TbPeC8JDprn7Fmb2STrwOmxlCEMs+DQFM
         NMNRX5mMj4uu3CPGEJ0WzoUWzmpLh7bwcAIoIDV0QF59njeZ3fzarQXzxazqoTKir1oB
         DPtGYhQW3+iFc3zJnMAnkHHQEoG53qGURlIbtz5UjMB4I8MpHWIR7appAoe4d/6rVUct
         Ezbd5d0EkmwvxcD4rhDKRn3t0W31PhCO56HGs3NSaT6MVdHBdXFqKuhJbFwqevzLRpwW
         7CBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757985606; x=1758590406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7oc+YeAQI9jR6qkHLGj/AqXsrGbk3uwxOS3oQGgb06Q=;
        b=jdhVqMQJ6/fgiJSDvfQ8Mb5mXNyeM3OjUgqcd7mDAAJTfaToqqpPAuEU7HMtC9CXto
         nkrJLdKfhfYlaKrf3ICmwWDKjC8W9Lesc0Am3vQ7MS5tjF4dhuxpfwXwyPwBNwR37egi
         LQXAbEKAT2r9a/4DfMe7Dp5l+TgdoK9ap8Npwj0LIulRviAOLL7hqBPxrQgxgf1shpKN
         GPOcNzAiPHrnE1piVvhoSEZXjmb7ubYsy07WyoqvA10yFs5r4uyVYDvGjOG9jVk8q7bg
         16QqEFf1eZZtC376jxwl7w9FO6faw+LhnlJIQx6MiCSmRP8Xaul9qL1N4YDCJ8rhISuP
         TohA==
X-Forwarded-Encrypted: i=1; AJvYcCWPmlsqLUYOx6UV8VoQBfrmw8s3Y0viKp5XNfIP8dTUS/C3P8oVImPSw1TjJ49aS/8d+DLeEPE21w==@kvack.org
X-Gm-Message-State: AOJu0YwAi7I1Al9NZQETXTfNZ0osBTxbQO6Uaxh5edcyAv1r+yJ6RLWX
	Fk5AriaSaLaFY++T1Q+6bXfxCT+KEYLgnFHCdyYc5qoFOSirlLfzEJjVsEPcpwlGAP+1QOGkmh0
	qRGNihBSP1cNRXjjPLfVefx2eFW8ycgzDeX7VcfrP
X-Gm-Gg: ASbGncvBlvwgp7VgkvEjJRuGlJQ9VvP4cZ44LD6OJw6pYGDb89YAX3OAGcTGW8WkBgk
	3h82dZJpw6HHxbSz91qoALnY0LlTDImKD8PXnjPAhnoGSGCdfQJS6WYZsy6Nk0dDJi49ws3vNwB
	bVt52XFHkYLGAXbk5eqDZZkKWLg8YoxXAMi6r4dAvHrX+sw4JaEpuOuIfu34UjVehllmHkpebK/
	bQtXw8Ee23E9oGZ5Oub5iyPpwcx4/mlqHCMX4xZPzBF
X-Google-Smtp-Source: AGHT+IGwZ42ey53/Z1K5ZBDUQkGoZ+OwR1FjybKwy+/iwpTMAHOkHJQAI64NHEH+hr7wN2JIw+Y3z5X+5jsNmO1nwh4=
X-Received: by 2002:a17:903:2c0b:b0:267:d7f8:4054 with SMTP id
 d9443c01a7336-267d7f84826mr65945ad.16.1757985605754; Mon, 15 Sep 2025
 18:20:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-8-kaleshsingh@google.com> <20250915194158.472edea5@gandalf.local.home>
In-Reply-To: <20250915194158.472edea5@gandalf.local.home>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Mon, 15 Sep 2025 18:19:53 -0700
X-Gm-Features: Ac12FXyOHF1j3BB1NncU7x-UTlGuAAFshnZvp_tnlmREINkio1gvvq5R2YkXEUw
Message-ID: <CAC_TJvconNNKPboAbsfXFBboiRCYgE2AN23ask1gdaj9=wuHAQ@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 654694000A
X-Stat-Signature: psufjo766qarj6wh5hu7nofj1bziopwd
X-HE-Tag: 1757985607-684557
X-HE-Meta: U2FsdGVkX1+29Kq9dwWwOG8qa4Qx6y0yAHvDdJwFblFL7UHBriLCmGfEavuY+Y7pt2H4QZEZlRYCLR7HrbCikbXebtwEpwUcNUuOTP6LtzPfLEl64jCiH+5pK2fY9Frg85YcBAF2AENtzktpJ/ETq9O00h5JPc4XNi2xVxkOn3SR2bjAznwwOIiPyc9eepJdIOGjJx3v6g8miJgi3sdvqeUhMoqsMOgH59PQEXphybyil0YGcmrpoSvED0bKi4nGbS4TYZCOV61slKR8QX0J5ZXL/hbLeCoJ+LQPUnppqUckdciCpwBfeFUDG7i+F//EMZDIdZZpMUsoGcdtMPKhRJ4zg5j8zM1Vl9/ktpiYEBTteltBtroQx0LYX74elDT0hSaczZWu4pgegegzaRpWp/TgOA7DcyqWFuLsU1nV3u3BvrH73vRxcIhjEOWbyjhKnHn94v3mLwmpGGmFpS3Te9wLbSKgOPU1o/lPDTVHnfjbEYV5aVSlen9nNeGRScbR5pnBwrkFhSGVdnmqZNUi2qW0YRAv634J+DLiSYkHvDYMB8sp8N1OITVVItHrdxfFRxKowvBu1d+IVaDv8mI0q9I0/kByEOmyvpUocZ5u+Fi1RJX3iBYGv4hRn7jngFbPGKfV7knl3D0cF2tzinogQV9VoQo+A3XMcmH84WRTvg4sS2fHy63CPENksC55qyj0bPghvoop50X9w+/rpuFBVRAZY/zdOeyu0uUZwM48JXnN0vg0s7DZt5SJVa/ld4PyNrcbMuPA8NI/XnD6CHprYU+6vS6TauB/Vu2ATbVipUa5t/dEoIBkeWFP7lOtiLiCAGXjQw1q84BU9fhtMrdBn+UhWFX56eG5wJZ03KV0XHHg1kkKlNVL//08JuSdNgktmxxIXxtZIJr0TJRX6iHpNVOQGzuSHF7ei62ihtCIP8438Oky4r0v5sn94RRY9Raq/hg7Ex8yiS7fKqMAGcA
 JNiZWaYH
 lBZ9TenMWDNDpapt4uqTngA5HqRs7WzEkaEBCWVdzr2HFk8bJBga4lT4llwcrtpNPuk0rHJYXP+IaFPoFT1NgPWl+xmsAiq1o5mqIxB0+fDpZYEeCoAW6AaFMfmaaEzWrNKi1YxMwwYTT3ASVmgQUTBQHfDeDa0X6TwcNvDWHQTURgYPp0vxqsyxq3pxxy0TIvwNVa7TeXs6EQMV4UfC/OSu2YW/sldlF3fJfcvtj8xYWqBJhm0HJXOBMbYxpRjWwuc/KZOxq2I23sU3ma74tnrnTTmY15LSPcu3svbie4cEFOL0czOdV52Xtj8LMzSF+c5O4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 4:41=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Mon, 15 Sep 2025 09:36:38 -0700
> Kalesh Singh <kaleshsingh@google.com> wrote:
>
> > Needed observability on in field devices can be collected with minimal
> > overhead and can be toggled on and off. Event driven telemetry can be
> > done with tracepoint BPF programs.
> >
> > The process comm is provided for aggregation across devices and tgid is
> > to enable per-process aggregation per device.
>
> What do you mean about comm being used to aggregation across devices?
> What's special about this trace event that will make it used across devic=
es?
>
> Note, if BPF is being used, can't the BPF program just add the current
> comm? Why waste space in the ring buffer for it?
>
>
>
> > +
> > +TRACE_EVENT(max_vma_count_exceeded,
> > +
> > +     TP_PROTO(struct task_struct *task),
>
> Why pass in the task if it's always going to be current?
>
> > +
> > +     TP_ARGS(task),
> > +
> > +     TP_STRUCT__entry(
> > +             __string(comm,  task->comm)
>
> This could be:
>
>                 __string(comm, current)
>
> But I still want to know what makes this trace event special over other
> trace events to store this, and can't it be retrieved another way,
> especially if BPF is being used to hook to it?

Hi Steve,

Thanks for the comments and suggestion you are right we can use bpf to
get the comm. There is nothing special about this trace event.  I will
drop comm in the next revision.

The reason I did the task_struct parameter (current): I believe there
is a limitation that we must  specify at least 1 parameter to the
TRACE_EVENT()  PROTO and ARGS macros.

Is there some way to use this without needing a parameter?

I hit the build failure below, with no parameters:

In file included from mm/vma.c:10:
./include/trace/events/vma.h:10:1: error: expected parameter declarator
   10 | TRACE_EVENT(max_vma_count_exceeded,
      | ^
...

Below is the code for reference:

/* SPDX-License-Identifier: GPL-2.0 */
#undef TRACE_SYSTEM
#define TRACE_SYSTEM vma

#if !defined(_TRACE_VMA_H) || defined(TRACE_HEADER_MULTI_READ)
#define _TRACE_VMA_H

#include <linux/tracepoint.h>

TRACE_EVENT(max_vma_count_exceeded,

TP_PROTO(),

TP_ARGS(),

TP_STRUCT__entry(
__field(pid_t, tgid)
),

TP_fast_assign(
__entry->tgid =3D current->tgid;
),

TP_printk("tgid=3D%d", __entry->tgid)
);

#endif /*  _TRACE_VMA_H */

/* This part must be outside protection */
#include <trace/define_trace.h>

Thanks,
Kalesh

>
> -- Steve
>
>
> > +             __field(pid_t,  tgid)
> > +     ),
> > +
> > +     TP_fast_assign(
> > +             __assign_str(comm);
> > +             __entry->tgid =3D task->tgid;
> > +     ),
> > +
> > +     TP_printk("comm=3D%s tgid=3D%d", __get_str(comm), __entry->tgid)
> > +);
> > +

