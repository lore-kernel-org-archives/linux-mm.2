Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D242BCCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 17:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0D218E0005; Thu, 16 Oct 2025 13:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE5058E0002; Thu, 16 Oct 2025 13:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB0F8E0005; Thu, 16 Oct 2025 13:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD0218E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:20:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 814D31602DD
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:20:04 +0000 (UTC)
X-FDA: 84004640328.23.A940B37
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9A720A0015
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:20:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WTLU2qjZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kaleshsingh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760635202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oar3IC5PlLSvEtc/2ze2EFC5XBWzyZXV5aWJayEgfz0=;
	b=ult392POHMSRBzqCCfYwBEwMWDZgOPS0HWqo8t/LkoHI50eivIFAhmMsg/sikk9ukCLLIS
	44gywSeh/0KBkBWe0n65N/umEeY4nNheuRtM8gjXdv4n+NUEb3AbaSFBZsJnRfrNR/AAlz
	6H+AmYmrNe75dMsNdamX3/IKe+RNqFY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WTLU2qjZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kaleshsingh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760635202; a=rsa-sha256;
	cv=none;
	b=KsDU8AZgSJEe44jVUD0L28b1v/1gq/EQvKr8sSHerzx2Qezf2Z9XN/pQc55DK3BoTOyqG4
	Heix151SUkFrkTiasy72CKvuaOLWK+mKafWi/WC+AyHwbgNZJe2heoaPOJskR3A/AEjDsn
	AB/h4IPDhEfWZmfDVVVgGGfI/WoF/4w=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2681645b7b6so8715ad.1
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635201; x=1761240001; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oar3IC5PlLSvEtc/2ze2EFC5XBWzyZXV5aWJayEgfz0=;
        b=WTLU2qjZjS9Svk0bN5Nocf4v53ak7co8clUfbAnIZpXrDm+UbxvCwq/Vd99BckP445
         FMT1vekFWUrprah2uME7igOYhBq7S5sMBU/L1/NfE1caP+Pr9i95N3xyTbjCt38/X0eh
         pPSArJ9Es61TwbEiaP63jiOUoqZvyl2WSybdRGqTKC69cOdw7F3U70qJMoatqBK9fQov
         XFx+PraMbYDXpeUnj+ploaoJGStJrYlmouUrkeMU5JIYTlfyFMp4FCOL1tPmuWce4ScK
         rA1NDaM19B+H8RVpcfBoz2gM5YzzYC8U2n0bT2azAQlrZuKWlOCbJ+fLycOvwZtguZ+B
         6Qtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635201; x=1761240001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oar3IC5PlLSvEtc/2ze2EFC5XBWzyZXV5aWJayEgfz0=;
        b=aQs9wFk/w8pWTDalgEbbXlTtszIrjiABP/FlFrfXx1ExPsHd16hVW+NKi9A2BU5v1q
         FKr5iSE/T/ArYZMbUvpryBrMi4dIfzAQ30dTe59eEW/fya15utbQRGVoIjvKol/iNDFl
         gCS6UWC7KZbEj5SaO4Esi0ki2u7qzEFqHrd2z/n3y86Z63miM4Qwrrey1jez9uAYxAD+
         ryYrmzFRsUGK8gvgTdwjbN03KYTp6J14ZpFgnPMcRWgDdkB32m/pvdTCQtuvQgLYYp3j
         ENGasSq0bQXgZv1APS49LK+jZa0pNqXgN5iGBHeSMy5jP/DXWYWbLBl7wiD/FtUk7vxC
         BMgw==
X-Forwarded-Encrypted: i=1; AJvYcCWYBy4bsoUb2+MfQrd93TrXv68V+chqqYlbbuU+wZX8Kreze3+aBlqlKq6KUhBYRxfFLLZIfXO9ug==@kvack.org
X-Gm-Message-State: AOJu0Yxxm26gXz9/0i5eJoVUbtGRgOrLP+f3T6B66BKvAroBSjBV8Yq6
	w/tGqzJ4S24AVIHZX3wYKEzXjULqic7LbhzG02PexezoQSXTIHPJBBZD0PAHFT6vQUhdbCEdgEh
	fLp/g8IU9TwIj0zH9nYDU625XoBHqcHKENToAZCW0
X-Gm-Gg: ASbGncuWtVslQarWbGQuRx6O1QPe5W3tDpkCO0u2gXZ7eeq9mOeRfgVp+9NqPgmPY2r
	gMU8r0UQtQ018a93tIE7RGlKAwpEXHweo0IXANR+0MJVmAjNoT/wC/RfAojs51RBq6dNS4keRO7
	te+WHdqdzR5/e54DPn+GnZuYR+4DZfBetBvSg4mpRRqN6ZJNMK09x8N8V0AwtMcE3MgZCtrn0w6
	XbBynjz0IU4p5wPZ3hlEMTc6ag6a76f5BBlWrA7Qgc1ReqieHeAfCTIZPIECeOR+FJwc0m9rJNB
	Iw6R01GpRjCkYvmx3dfBOWQp
X-Google-Smtp-Source: AGHT+IGaLBYMUVA3dp2bngz8sd3zdctlajyDpg4Q5ej9rYFdWUESUT7d4RcwGFB4ciRjNT7T8e6kC8pvy75+YgR2Dh8=
X-Received: by 2002:a17:902:fc87:b0:290:cd63:e922 with SMTP id
 d9443c01a7336-290cd63eff9mr828755ad.15.1760635200981; Thu, 16 Oct 2025
 10:20:00 -0700 (PDT)
MIME-Version: 1.0
References: <20251013235259.589015-1-kaleshsingh@google.com>
 <20251013235259.589015-2-kaleshsingh@google.com> <144f3ee6-1a5f-57fc-d5f8-5ce54a3ac139@google.com>
 <CAC_TJvdLxPRC5r+Ae+h2Zmc68B5+s40+413Xo4SjvXH2x2F6hg@mail.gmail.com> <af0618c0-03c5-9133-bb14-db8ddb72b8de@google.com>
In-Reply-To: <af0618c0-03c5-9133-bb14-db8ddb72b8de@google.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 16 Oct 2025 10:19:49 -0700
X-Gm-Features: AS18NWDUcYhiaJ_iuWpblZjVBlLRKBf3hDw80qWBei6Spqkt0F1pWUwG8jn-Ias
Message-ID: <CAC_TJvdy4qCaLAW09ViC5vPbj4XC7_P+9Jjj_kYSU6d+=r70yw@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] mm: fix off-by-one error in VMA count limit checks
To: Hugh Dickins <hughd@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de, 
	kernel-team@android.com, android-mm@google.com, stable@vger.kernel.org, 
	SeongJae Park <sj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A720A0015
X-Rspamd-Server: rspam03
X-Stat-Signature: 884reirrzehggc6yyyupci5oxbmeecap
X-HE-Tag: 1760635202-488452
X-HE-Meta: U2FsdGVkX19z/O4mL7uf4VtKCG21zZEYAvSDMm+gFvkwR2t+JMsOfq9xCYDYIBgfx1FoIQMDRHCnoQiAwvfeAbMrbcApVqRoRJY8wGWQLa+5luOR0bZ9fJeMTikdNfk3asSTP9SmbM0cSbb4EogE11eHq1y0zg+PM2CCWAliWkeCadBjyrlTMRjlSavZ6G1tqr63clcABZE0/K5J6IrPRRpIJ2fLnz1Rd3T+dh/JsCNTRUOqt5nRqoXJK3isAoDvZ+H25/jeit27f8Uxi6tbUHRqL/73G/fdRsejQ2nFN9Qz4PHNZndVqF5iH3AJay561XZd4xdeOCs87Jh0naI6EGAueMZQTTjlOd2s+Dby08FLPju7F1SAhTzo+NmfB8JBpQ7r6EFoR58HB8tLHxkO/s5rBeS7bdfAArOX87mbosG/WAGe0mPCWZ/aZ8fGgWmZxq0K6VU9aqmDUglIm5Hv/q5GT8sOfLCKHETHH4YS3o6gX2V4hhyNgpr2Th/b6sEhPieWGgJSYYBEHZkfcFzyZBjeFCsqL1S8pavkKtxx9mcl0Ha7NLN71N1gLtxRobmxPoh1OBdI4zOc2wm4Qcgoi66lhr9nzpbEm/GwQXwW+e4WstRtBFADNsccbU98k9Z8eJfN5xs7h+sg36mDtp2KJg8c0i89UZM3DOndbPg3qu/2CcJL6e5jqFW9k22aErjMbyAnxQgZXJ4by63sfQ8+jDyCYIjxoyipOVqU/+E5wiFsefAJWsFkvmAGmbq5VSqlykj15njNB1aVJfLrzo+0R9ZkgqZJa31bMybAagHOesjVE1Z0DmU+KVEx6QjYuVHiZ68NA/3ma6aeolXd0VF2YiULkpnaaJFdlT78SRGC0EJY92F3uIW1aNmn2MCVnBMPJHMYFNRhrdCa3KgUC7K5YQ1bf2pYkwp6ksgLnB7D25g8W8tYKGIBCGZ6DWGaP4wNPWQ5KfRpoOebMysGPx8
 U2KQUANV
 vdfzS5aJ1I8ShE9S55fQyUsnGEOcXfxfCHeD4zO4ES2nkdvNM48/ZjqzAUd8EkcKJZISyTFf0D7d4fArpVMzIypM15+/BUStVRjyvsUCIaNOrhYkgYSNriIPyH/RI4a3Tc0mQZ+SItKdrpBKrJ6ipxO7+4zunhvN4zMUsPSfLaK9A+mSwta5KlkMH/Osbmm+5wP2fN4oBFkLNj07vDyucH0ASb/fpxKNqqLXJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 10:05=E2=80=AFPM Hugh Dickins <hughd@google.com> wr=
ote:
>
> On Tue, 14 Oct 2025, Kalesh Singh wrote:
> > On Mon, Oct 13, 2025 at 11:28=E2=80=AFPM Hugh Dickins <hughd@google.com=
> wrote:
> > >
> > > Sorry for letting you go so far before speaking up (I had to test wha=
t
> > > I believed to be true, and had hoped that meanwhile one of your many
> > > illustrious reviewers would say so first, but no): it's a NAK from me=
.
> > >
> > > These are not off-by-ones: at the point of these checks, it is not
> > > known whether an additional map/vma will have to be added, or the
> > > addition will be merged into an existing map/vma.  So the checks
> > > err on the lenient side, letting you get perhaps one more than the
> > > sysctl said, but not allowing any more than that.
> > >
> > > Which is all that matters, isn't it? Limiting unrestrained growth.
> > >
> > > In this patch you're proposing to change it from erring on the
> > > lenient side to erring on the strict side - prohibiting merges
> > > at the limit which have been allowed for many years.
> > >
> > > Whatever one thinks about the merits of erring on the lenient versus
> > > erring on the strict side, I see no reason to make this change now,
> > > and most certainly not with a Fixes Cc: stable. There is no danger
> > > in the current behaviour; there is danger in prohibiting what was
> > > allowed before.
> > >
> > > As to the remainder of your series: I have to commend you for doing
> > > a thorough and well-presented job, but I cannot myself see the point =
in
> > > changing 21 files for what almost amounts to a max_map_count subsyste=
m.
> > > I call it misdirected effort, not at all to my taste, which prefers t=
he
> > > straightforward checks already there; but accept that my taste may be
> > > out of fashion, so won't stand in the way if others think it worthwhi=
le.
> >
> > Hi Hugh,
> >
> > Thanks for the detailed review and for taking the time to test the beha=
vior.
> >
> > You've raised a valid point. I wasn't aware of the history behind the
> > lenient check for merges. The lack of a comment, like the one that
> > exists for exceeding the limit in munmap(), led me to misinterpret
> > this as an off-by-one bug. The convention makes sense if we consider
> > potential merges.
>
> Yes, a comment there would be helpful (and I doubt it's worth more
> than adding a comment); but I did not understand at all, Liam's
> suggestion for the comment "to state that the count may not change".
>
> >
> > If it was in-fact the intended behavior, then I agree we should keep
> > it lenient. It would mean though, that munmap() being able to free a
> > VMA if a split is required (by permitting exceeding the limit by 1)
> > would not work in the case where we have already exceeded the limit. I
> > find this to be inconsistent but this is also the current behavior ...
>
> You're saying that once we go one over the limit, say with a new mmap,
> an munmap check makes it impossible to munmap that or any other vma?
>
> If that's so, I do agree with you, that's nasty, and I would hate any
> new code to behave that way.  In code that's survived as long as this
> without troubling anyone, I'm not so sure: but if it's easily fixed
> (a more lenient check at the munmap end?) that would seem worthwhile.
>
> Ah, but reading again, you say "if a split is required": I guess
> munmapping the whole vma has no problem; and it's fine for a middle
> munmap, splitting into three before munmapping the middle, to fail.
> I suppose it would be nicer if munmaping start or end succeeeded,
> but I don't think that matters very much in this case.
>

Yes, your understanding is correct. I meant that currently, we allow
for an munmap() requiring a single split to succeed even if it will
temporarily exceed the limit by one, as immediately after we will be
removing one of those VMAs. However, if the process has already
exceeded the limit, say, due to a non-merging mmap(), then an munmap()
requiring a split will fail. It's not a big issue, but I found it
inconsistent that this succeeds in some cases and not in others.

> >
> > I will drop this patch and the patch that introduces the
> > vma_count_remaining() helper, as I see your point about it potentially
> > being unnecessary overhead.
> >
> > Regarding your feedback on the rest of the series, I believe the 3
> > remaining patches are still valuable on their own.
> >
> >  - The selftest adds a comprehensive tests for VMA operations at the
> > sysctl_max_map_count limit. This will self-document the exact behavior
> > expected, including the leniency for potential merges that you
> > highlighted, preventing the kind of misunderstanding that led to my
> > initial patch.
> >
> >  - The rename of mm_struct->map_count to vma_count, is a
> > straightforward cleanup for code clarity that makes the purpose of the
> > field more explicit.
> >
> >  - The tracepoint adds needed observability for telemetry, allowing us
> > to see when processes are failing in the field due to VMA count limit.
> >
> > The  selftest, is what  makes up a large portion of the diff you
> > sited, and with vma_count_remaining() gone the series will not touch
> > nearly as many files.
> >
> > Would this be an acceptable path forward?
>
> Possibly, if others like it: my concern was to end a misunderstanding
> (I'm generally much too slow to get involved in cleanups).
>
> Though given that the sysctl is named "max_map_count", I'm not very
> keen on renaming everything else from map_count to vma_count
> (and of course I'm not suggesting to rename the sysctl).

I still believe vma_count is a clearer name for the field, given some
existing comments already refer to it as vma count. The inconsistency
between vma_count and sysctl_max_map_count can be abstracted away; and
the sysctl made non-global.
I'll wait for feedback form others on how to proceed.

Thanks for the thorough review and discussion.

-- Kalesh

>
> Hugh

