Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A527CCCD185
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 05:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CECA8E0005; Thu, 16 Oct 2025 01:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6BE8E0002; Thu, 16 Oct 2025 01:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED79C8E0005; Thu, 16 Oct 2025 01:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC5438E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:05:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67EE41A01E4
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:05:37 +0000 (UTC)
X-FDA: 84002789514.29.B9F822D
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8CC74C000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:05:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zr8bqUfl;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760591135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SL78+SZbXELe5OjpiYZ40otsTW6VBbAoBUm1tT/or+E=;
	b=FTcCEw8OcsKmnS2xpF5y4/01cO7h6DUhp9XjAGXchEX2KrVSNm5gZ9D6UVdUsOHknPwMCt
	W4ZTFdf/dWUdOnt/U5ils/1FL3Xc82phE7pzHbev6i5VxX8bz86Xnk/2kDtQJRjGXtuRV6
	Np4OAHAklcrs7lFy1vMRtB3XoBpdwuU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zr8bqUfl;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760591135; a=rsa-sha256;
	cv=none;
	b=W7TBW5wOtmGh3eUcSj0UeuEYtKilT5a7PnvxToP2NT0BW4sODgX6N+XkExGGWprX6909Fp
	UXPbIYCQ8Ol5J7Ogeu5lZWBIriCcuG3+l666tuM8dmHgC3VYXr4I1e0dpt/GOTKH9XbqTf
	vGeE0CX6u5euVPDSn4V62fbUZwP2530=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-7815092cd0bso3045087b3.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 22:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760591134; x=1761195934; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SL78+SZbXELe5OjpiYZ40otsTW6VBbAoBUm1tT/or+E=;
        b=zr8bqUfl2/p/3R4wlF8DscrrAKGEMdGweImxtUHC787CVUhbMCfC8bsgdQmW2FISc7
         k7q7amMiFUTSM9tjFM3ROcCPqz8VnAo2EDzGwSusrTdpbrCuZwgmxmdOIN/tzCSzgbpU
         IMmLtCoWvxM+e0rP7JQbsuX3VJzSJ5peOVvc6b3SQdVc9+5+jgz/UeQBMyEG4WVvK4RE
         BV80QmTadOa8kjkdy0lYs+KRqxxZrqc4SFjCl/fLcyx3TlpTh0yHlPLMHQOZDTIVlfgC
         ZDWrYZKhyHoCoNWPwf6C3Kj5ZmSq8sa9zbi+nE+E78mVre4oEb5DpuHTL90nS9RxrnmB
         70Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760591134; x=1761195934;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SL78+SZbXELe5OjpiYZ40otsTW6VBbAoBUm1tT/or+E=;
        b=fB0JxF6bMG11WWyFG5krjVWb6yAy6eRtsDIZzHj+YCOiJdKJ6QnnO7XqGYZCA2PQyq
         6wY3VAtEgaQzJCO8XRJOMjYAP51zRml8ClKm+3d+JBh8gXn6DbtJcwTXBuJQHdbKsEka
         OLcrwUAh26J03oaR9VVl+6qNteZtO4lhrx4703QfbtyvcFaiFflc8nEXW+EaH613asUX
         LQw4NhhKIIodSUb1Q90trI8fQydFds/WK88z2IMJ3oeGXJatt3cjitnjRJUPBXmJFea+
         QMeC3GGSUe8FvpKTwkvv+d8b3Ag9b/UbtI4LEDyb7/ngbufaDmTaPdnuibuyzS1qhYhv
         sUew==
X-Forwarded-Encrypted: i=1; AJvYcCXgyw7DC8Gjy1rl7zjtP8/L/5AZvU1OoCq6mGaNG/t3lom2h7sGOuzXFPEDaQFFHC1+ciqqoe2NEQ==@kvack.org
X-Gm-Message-State: AOJu0Yzrmh7qQfNChdzUoRPQft71ywL7Ontsw7kbdmuoArDDJxHlwjzQ
	rJrT0CnjppjpMOMg+7URCabWXXwq/XSAhtE8LqmqZRQh/s0FDuR/QF8CfoxJO2NohA==
X-Gm-Gg: ASbGnctXZI4heneX5AS1ZBEJ452ReoLoyhMx9f+BnLXmBENxQk841aeZBFDhxr7JaRP
	xR7N6eu0VY0JtpqnMFSs7Dta+kB78ZpP9KdC0RX3mefgXHqqymKgbzohy13/AZ+yhZ0mFiASPSA
	BWCsPgLyWj9I7OnF//Ldy0tnR6Fy7JhGzwSyZsDnBkK430GOsshm3s8O0VdnmtmLsSEakKK66Lo
	SmP9GqjPSJRexQkxYTif4guY7vR8ukUWYE/8GT9buRFUNjxmhjOslS/WoxEHDR1jBRe4l4eRgMm
	oCkPr5ZUtRRSd9O2sua2qe7rdRKK+OBlypiV5y4MmLw1VE5/Mu/zgaJDie1TACL87k52zsd0ZXG
	LSdg6qSUVD3H6hoNdEW6w8RjO7UhkWaU2rXMqafysuIUNg13A2y/LofUgKMr2z0vtrp2NXPUiSc
	7+gebFO1JJ5AMQau27cvG7d6twRiY1GAnfdlgcwEUnbPm6mRhO685SW+ni8W0nsV8pli1PpTblD
	6LvBZxdO0C7/KY=
X-Google-Smtp-Source: AGHT+IGKHjTCfZs9WliaOHICesM+L1X3EuoBynLJInRo210xgEeIFS6mewEtS3BfqWgQnxUg9wNNRQ==
X-Received: by 2002:a05:690c:670b:b0:783:116b:fc5 with SMTP id 00721157ae682-783116b1024mr9954377b3.33.1760591134146;
        Wed, 15 Oct 2025 22:05:34 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7828d7b9deesm4928007b3.26.2025.10.15.22.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 22:05:32 -0700 (PDT)
Date: Wed, 15 Oct 2025 22:05:20 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kalesh Singh <kaleshsingh@google.com>
cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org, 
    minchan@kernel.org, lorenzo.stoakes@oracle.com, david@redhat.com, 
    Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de, 
    kernel-team@android.com, android-mm@google.com, stable@vger.kernel.org, 
    SeongJae Park <sj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
    Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
    Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Jann Horn <jannh@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
    Masami Hiramatsu <mhiramat@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
    Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
    Juri Lelli <juri.lelli@redhat.com>, 
    Vincent Guittot <vincent.guittot@linaro.org>, 
    Dietmar Eggemann <dietmar.eggemann@arm.com>, 
    Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
    Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
    linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
    linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 1/5] mm: fix off-by-one error in VMA count limit
 checks
In-Reply-To: <CAC_TJvdLxPRC5r+Ae+h2Zmc68B5+s40+413Xo4SjvXH2x2F6hg@mail.gmail.com>
Message-ID: <af0618c0-03c5-9133-bb14-db8ddb72b8de@google.com>
References: <20251013235259.589015-1-kaleshsingh@google.com> <20251013235259.589015-2-kaleshsingh@google.com> <144f3ee6-1a5f-57fc-d5f8-5ce54a3ac139@google.com> <CAC_TJvdLxPRC5r+Ae+h2Zmc68B5+s40+413Xo4SjvXH2x2F6hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-1513627236-1760591132=:18627"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8CC74C000A
X-Stat-Signature: 7nton35iqorgwt87scznmu5xmfwcnhsc
X-Rspam-User: 
X-HE-Tag: 1760591135-747530
X-HE-Meta: U2FsdGVkX1+DLCFu4BM6dMKrqtcl5nngdK3rF2wrHkROVQPRQ39vcsnhHzCSIOemp1asU0NndsdqGABCZertU5CPtV2BPYL451buqZUK2nvTHA9oxITiSMMURgnGuYF9R4H4WZwQR503u/J9pVAwkdq4fLveawnCVynC9Wf4GLVZaXMkhIZBo2KrhpdfqcAztO2yPrqfy3VD/loTzHqgcTDU1NAV76sNOOMzZfQntbvC0eRnmdf0Jkh4wl7Hs8CpDMO5jALcfKWJFLPs62CRPieRvOwCWVIFMpqOrRxGSBPHyMPqxTZefIYJWqPj0857ZWd12rMrjyvkES21oBsQADLqDHaWvTBUDgIdd5xFVy0uQRCgbGc28ZQHcouzfWJ0jztw0ZBgm6tYOTVAWub/Z7oOX5IgoACcYEcihB5BeDeEfcq6AVBWU+PhmR0JIyCHzrjr7zmMCce3jpolFS79JFaIj4gQ4rX+TPPCVaC2R9oUd3IN2KymFSBfNDzQ6alMAkeIFnEEmZUJugt0APt3hvvDKTxfn3K8ogEJdVjT8e+UG0scnZh+39WvNwWTzuzbpWWD1cnKKBMW9sN0rTbQE07nfjn+RHhI5y8QvnPWA/u7pHATE+HnEAbKn/ozy16PgsKHxIIrcl9ziGZ+0mI5dyl4qj7ebJqE/k1QHz00CXhcJNRLI1FAqkCxP3wYvFt5UpPuUunKaSu5/hrc67RjISGo/6Pipb+uWvpoXsq6hFixYtc9q7XpoXfV2NqvQ61vfXFwu40WsPYkOU74vyr9EcD72L5V5gFecWfAGh7Llak3fG6nR+yy3O6BEWeEd8dWLGHWFM1XDtd95ct473HHkPglijzxeG18LwKL0qrnRruGJnQHV0cyMw8Cim3EHp7zm+dsE8h9ML8UkkNfi0B0qhDGGL912dYfOEXoSQbE7SoDCk6X6uufS5gEIzShXNk/hcp6hHe5QHsMtU9zOct
 TkMNg0fu
 0nX4ykdwp9873gNefm9el05Qt6DeSXetYDb6+ZxK8LAsBRT9hratCKJnU+Gysy/TPlezDdbTCsrlLMi81wMWwLb/kA9XrOM5vBcs7uqZ6xhQUyl8MFGj9kJzZRd/dY29RwPlzKGpPem1RLWQ9GraokiOvkOfTqXQQA41XM11u/rau3qO297GXCsk9CnnjykZZHe0osTbpXmjSXqHUMR6Fw+iSGuFm5/RpFOI1rkZLiQA4Ckhqy2b0GGxjB3QlG4lcG944VGy1xhDoWK7+niznq4XrMi1/NVw0bnvv5bcSAvEddRa3OQGyJfC/19xqZkDyEjvDGTpdKomTyI7T1nVoCeJ/MrblkOEbwzqofvvfjTzm+uNQHzYH6n1Pz9vMeNRdgvOcJ5/L+IA3cAVbYjS+5j2LS6NMjI6GCS+dvdo6FICznz0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-1513627236-1760591132=:18627
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 14 Oct 2025, Kalesh Singh wrote:
> On Mon, Oct 13, 2025 at 11:28=E2=80=AFPM Hugh Dickins <hughd@google.com> =
wrote:
> >
> > Sorry for letting you go so far before speaking up (I had to test what
> > I believed to be true, and had hoped that meanwhile one of your many
> > illustrious reviewers would say so first, but no): it's a NAK from me.
> >
> > These are not off-by-ones: at the point of these checks, it is not
> > known whether an additional map/vma will have to be added, or the
> > addition will be merged into an existing map/vma.  So the checks
> > err on the lenient side, letting you get perhaps one more than the
> > sysctl said, but not allowing any more than that.
> >
> > Which is all that matters, isn't it? Limiting unrestrained growth.
> >
> > In this patch you're proposing to change it from erring on the
> > lenient side to erring on the strict side - prohibiting merges
> > at the limit which have been allowed for many years.
> >
> > Whatever one thinks about the merits of erring on the lenient versus
> > erring on the strict side, I see no reason to make this change now,
> > and most certainly not with a Fixes Cc: stable. There is no danger
> > in the current behaviour; there is danger in prohibiting what was
> > allowed before.
> >
> > As to the remainder of your series: I have to commend you for doing
> > a thorough and well-presented job, but I cannot myself see the point in
> > changing 21 files for what almost amounts to a max_map_count subsystem.
> > I call it misdirected effort, not at all to my taste, which prefers the
> > straightforward checks already there; but accept that my taste may be
> > out of fashion, so won't stand in the way if others think it worthwhile=
=2E
>=20
> Hi Hugh,
>=20
> Thanks for the detailed review and for taking the time to test the behavi=
or.
>=20
> You've raised a valid point. I wasn't aware of the history behind the
> lenient check for merges. The lack of a comment, like the one that
> exists for exceeding the limit in munmap(), led me to misinterpret
> this as an off-by-one bug. The convention makes sense if we consider
> potential merges.

Yes, a comment there would be helpful (and I doubt it's worth more
than adding a comment); but I did not understand at all, Liam's
suggestion for the comment "to state that the count may not change".

>=20
> If it was in-fact the intended behavior, then I agree we should keep
> it lenient. It would mean though, that munmap() being able to free a
> VMA if a split is required (by permitting exceeding the limit by 1)
> would not work in the case where we have already exceeded the limit. I
> find this to be inconsistent but this is also the current behavior ...

You're saying that once we go one over the limit, say with a new mmap,
an munmap check makes it impossible to munmap that or any other vma?

If that's so, I do agree with you, that's nasty, and I would hate any
new code to behave that way.  In code that's survived as long as this
without troubling anyone, I'm not so sure: but if it's easily fixed
(a more lenient check at the munmap end?) that would seem worthwhile.

Ah, but reading again, you say "if a split is required": I guess
munmapping the whole vma has no problem; and it's fine for a middle
munmap, splitting into three before munmapping the middle, to fail.
I suppose it would be nicer if munmaping start or end succeeeded,
but I don't think that matters very much in this case.

>=20
> I will drop this patch and the patch that introduces the
> vma_count_remaining() helper, as I see your point about it potentially
> being unnecessary overhead.
>=20
> Regarding your feedback on the rest of the series, I believe the 3
> remaining patches are still valuable on their own.
>=20
>  - The selftest adds a comprehensive tests for VMA operations at the
> sysctl_max_map_count limit. This will self-document the exact behavior
> expected, including the leniency for potential merges that you
> highlighted, preventing the kind of misunderstanding that led to my
> initial patch.
>=20
>  - The rename of mm_struct->map_count to vma_count, is a
> straightforward cleanup for code clarity that makes the purpose of the
> field more explicit.
>=20
>  - The tracepoint adds needed observability for telemetry, allowing us
> to see when processes are failing in the field due to VMA count limit.
>=20
> The  selftest, is what  makes up a large portion of the diff you
> sited, and with vma_count_remaining() gone the series will not touch
> nearly as many files.
>=20
> Would this be an acceptable path forward?

Possibly, if others like it: my concern was to end a misunderstanding
(I'm generally much too slow to get involved in cleanups).

Though given that the sysctl is named "max_map_count", I'm not very
keen on renaming everything else from map_count to vma_count
(and of course I'm not suggesting to rename the sysctl).

Hugh
---1463770367-1513627236-1760591132=:18627--

