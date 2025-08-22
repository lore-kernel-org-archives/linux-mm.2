Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65780CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 18:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BC906B8009; Fri, 22 Aug 2025 14:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96D2A8E009D; Fri, 22 Aug 2025 14:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AA526B8009; Fri, 22 Aug 2025 14:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 798908E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:13:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 39583832EC
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:13:56 +0000 (UTC)
X-FDA: 83805192072.23.47422FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 24C7C100007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:13:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J0/qh204";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755886434; a=rsa-sha256;
	cv=none;
	b=r+9QjUc1t//3Cbgw55reNZ/tOYTyKhaskmmTuXQPJIHFLpkvOoqSE+Oxbahp/1hK/27HWi
	mNZ2lIlXpA4NP3Qqfh0xOVTXdAifKNR9IrPRR7X7CrHMGTvFHL1e5LIOoGURdv1rabvR/U
	zu5BiG0BCDhw11hHJEhDdvHFLtaxl/s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J0/qh204";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755886434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yd0UGZ1tH2WngY0j+8mIqNNexSK9NpPBJac5HIkojTE=;
	b=J1fzg462JbHNmjoetZ/eFMnFPrNw/8Qeii2iyGmGXTdlmhCA2QOW+95NIK+6tTkm19DvVr
	5rC5vbLLUisblHceJgAk+McEeg4IzAON4jUoSb21TttCsCXgiMY+46YIzZXKE4O7IH6QK5
	+0ri82uv2ZkVkvTUT27T7I1rSy/Lidw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EE1043D37
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4822C116B1
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755886432;
	bh=vU343fTAxgZmpgPZkktnORXe5EWIuSgLimMaZupOkQE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=J0/qh204A+4yfnTJ2NWo8b6v5sEJUk2J6Am+cWkIYuF7hk8eW6vHEeIfZv4DCg3e2
	 XRoXxlcezc/MkUUxB3/nLG8fEwQB5CLqXAEhpOZsS2+sOnHhn0sMM6O9Wnfh4XEHB/
	 vTlDpo/vsf+XBdF8EVTXikfB1BxWP/gKLcrKo75sdxv5jrBSwQNPOwt5bjpjZavgw7
	 u3mv8t+rBqapKK9qDQbTrVpI/OIKx/TA0yTS4MrKtM3MNnQJUiJg0gWTBGjU0CmmkS
	 FZV2D2loitmjwFdJg+1mTAPkv6gFS8xgH0eJZbjiH3m+PxhecWe/rTKCbEbT6aBi7R
	 xLJJfCWtZ2n+w==
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e9513a4b346so2032300276.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:13:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXSvDqfcJ4LNeKT81NgFLwGZ7O63N8nyztOoBwtmIS21YSSda3KRtAd0ztVFhCvUCi7xD3sPxINng==@kvack.org
X-Gm-Message-State: AOJu0YzHwBTudnpLDNNP7zgjtg6h7iLuD/hxZa0aXiDZWB7rMycWkwtt
	7bVU6luN0/XaHpr79Bf8fCM7C5o8rA9In57X7A1BoFGxSwzV6uz7RrVIaGH+EJDh0wq1WPsIN9p
	pHQPUIKx7hzR4VUfFL5FwcGkvHLEXXtkpjHEgxAceNA==
X-Google-Smtp-Source: AGHT+IHhRf2TaqCZn/6kRt8XjIKqpaL9R5RJhn8UTmBo6Oybg2svLWl6m5S/cJDHVVyZbVAu3WydAGxqOV8Ga0ecPRc=
X-Received: by 2002:a05:6902:1891:b0:e95:11d6:258 with SMTP id
 3f1490d57ef6-e9511d6033cmr6400849276.16.1755886432211; Fri, 22 Aug 2025
 11:13:52 -0700 (PDT)
MIME-Version: 1.0
References: <aKgm+wisMipLqnL4@yjaykim-PowerEdge-T330> <aKihqI8PWLFL1b5i@casper.infradead.org>
 <20250822131022.4df59a60@gandalf.local.home> <aKisJJYL9LV20qzg@casper.infradead.org>
In-Reply-To: <aKisJJYL9LV20qzg@casper.infradead.org>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 22 Aug 2025 11:13:41 -0700
X-Gmail-Original-Message-ID: <CACePvbUYp7w68C8z_TeMhOJQ0hmWw1jkwy+D_Lb+N5WbmufAug@mail.gmail.com>
X-Gm-Features: Ac12FXyVtLiDu6js8Zea8UB6FyOKcVFb0xZCJLZ3n24tp2pC2drBWSymijPbbTU
Message-ID: <CACePvbUYp7w68C8z_TeMhOJQ0hmWw1jkwy+D_Lb+N5WbmufAug@mail.gmail.com>
Subject: Re: [TECH TOPIC] Per-cgroup Swap Device Control
To: Matthew Wilcox <willy@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, YoungJun Park <youngjun.park@lge.com>, ksummit@lists.linux.dev, 
	gunho.lee@lge.com, taejoon.song@lge.com, linux-mm@kvack.org, 
	David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 24C7C100007
X-Stat-Signature: 6qkx6bem1tp1f6gtmbfurfwzpejzpxff
X-HE-Tag: 1755886433-386839
X-HE-Meta: U2FsdGVkX1+GIEsF/V8s50r1+gAvB0YQsRH/aZaN7byJFThsVwUc8yUZV1a3/tpYfJIjJUVJNvAp/eH/78IB1ucQn3UZn1OCQnm9F2exCVKYEFZTCOjFyz3HY6l6ceCdt0DW116mQQw+mZH+tMgw3O8BlALUwI17zerlwYi6a5n2QBsoRzd38GLVHzHJSgRCXZNlUAki/q8XlX3rM+Vh9dD6AjVjeteaL+yU9IExoQrS1NSWu4tDc8MFWqRwMynwumuqJ0VJqKwzzulO9KEPT/Rweu7tyRgjbDBYQaXb6L+YO3bUJyZYfDRZLkBJVlnbIstE/hZkxJ+JbOJhuk+XAbauKgEjRbpW9O5wL8eBomHjz/t3e6936cJOsEiVW6mBDLIPsAsrfy3Vv0+P6tbsTK0O/B6qeIUjrB9J9d6Us2ev0WdhMHmhsMx9u6x4DSltIk8/wPH48n5cGeseYyhCxGN642EBcBIBsYB3tCS/PiokKtwT8s7faeJDKcTUZL6AUb210F/qo62J6QNkJwqlpjiyLcYkw92sCz/9QtfVD932KQYDwDWZWEIyV98JG5OQjq19s/o0qHiVEEmYd6Rn2h8Qxh3/UUMOZAmjjw7ThwTeCh/NzKDiLsHcCgwROFCuiO1i3bz1aewJc2kHISxDbxF5d9bsj+bGXtH73admCCkmNvGF+rCmkUkXm/W1qNA1fK8oDBVwsEXCPhTRs9QDuAUH7kQjQcJoIlYsqm7m37BwsqH1gm/HgOE1TeuQ2suSdw85bNCbw3H6hx17KQYg1t7IBHQutK2fM4vKHsD0gfDjPkEysLcboE8mr9pSjkUzMGfUkYETaToAa9NQWaaArfgGzOYJjzQZSmPfK1AgCrL/LfOo+KSC9ZVl7V0MscA5GLFS7F4b6L0Aea8irGS7xqVmAmpI1JpsqRh/rQivSlpufuujV60z0xZGXIyPQPo2QbOr1CQeYJC7f8qZ4pG
 et97AJF9
 r8OHuWe2SbXNr7JMhkFKh2RCfP7moABRdHn+D64/5iJcBVff1xQcQ1qhHzMYjsCaZfUeC56QmcKRx6qpbD0kEa9oxoDfi1//SaB9YLO4mFPBlorsxA5gzFwnV2aUvHeYLZS9Qz2ijXFpyl03HqwMZOz54359ZxdrlqeLE9XscmSg3zvrA2+g9N+tYYYJQ6u4d/SrfqMhGRZh6RKxQMx0rJ/mejmhs1Lvt0uTI82CcVnG3lkH6J4EjaysEgtyNCW9oaHS2eoaBO9H7JhPdH8lG48HOjfkfQWgsVjmqfFAi3pQzGBa7a3cHF+CKpPliE3GlXKzL2w9V0Fz7GKpvcgTUDj7Jjk1Hew4R8b7HyksH6UT11cxr3ZzX95xRhQTGTEEPfyW84Em9ZFnz99sVlupZsP6tLQ1EuoP5UzndpUVzOzYshj4PKc4RTdwLvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 10:43=E2=80=AFAM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Fri, Aug 22, 2025 at 01:10:22PM -0400, Steven Rostedt wrote:
> > On Fri, 22 Aug 2025 17:58:16 +0100
> > Matthew Wilcox <willy@infradead.org> wrote:
> >
> > > > Proposal:
> > > > I am developing on a restricted internal platform where there is a
> > > > technical requirement to use idle devices as extended memory.
> > >
> > > I don't think this is appropriate for the maintainer summit.  You
> > > can submit it to the Plumbers MM microconf [1] or LSFMM in May.
> > >
> > > [1] https://lpc.events/event/19/contributions/1995/
> > >
> > > Also you should have cc'd linux-mm for this kind of thing, adding
> > > it now.  Preserving the rest of the proposal for those who are
> > > interested.
> >
> > From Ted's original email: https://lore.kernel.org/all/20250805144357.G=
A762104@mit.edu/
> >
> >   Related to the Maintainer's Summit, the Kernel Summit is organized as=
 a
> >   track which is run in parallel with the other tracks at the Linux
> >   Plumbers Conference (LPC), and is open to all registered attendees of
> >   LPC.  The goal of the Kernel Summit track will be to provide a forum =
to
> >   discuss specific technical issues that would be easier to resolve in
> >   person than over e-mail.  The program committee will also consider
> >   "information sharing" topics if they are clearly of interest to the w=
ider
> >   development community (i.e., advanced training in topics that would b=
e
> >   useful to kernel developers).
> >
> >   To suggest a topic for the Kernel Summit, please do two things. by
> >   September 10th, 2025. First, please send e-mail with a subject prefix=
 of
> >   [TECH TOPIC] to ksummit@lists.linux.dev.  As before, please use a
> >   separate e-mail for each topic.
> >
> > So this appears to be appropriate.
>
> My mistake.  I thought tech topics were part of maintainer summit, not
> part of the kernel track.  It'll be up to the kernel track organiser(s)
> whether to accept it to that track or whether they think it'll be more
> appropriate in the MM microconf.

That is partly my fault as well. I suggest to YoungJun for the LPC
2025 in this email:

https://lore.kernel.org/linux-mm/CAF8kJuMo3yNKOZL9n5UkHx_O5cTZts287HOnQOu=
=3DKqQcnbrMdg@mail.gmail.com/

What I have in mind is extract as you said, the MM track Micro
Conference, and CC the linux-mm mail list as well. I forgot to mention
the details of the MM Micro Conference track part in my suggestion
email.

Anyway, is there any conflict to apply to LPC MM Micro Conference
track as well? Of course which conference to apply to is a decision
for YoungJun to make. I am just curious what options are available
now.

Hi, YoungJun,

If you decide to apply for LPC MM MC track as well, don't forget to
register yourself as a speaker on the LPC website.
https://lpc.events/event/19/abstracts/
The lower right of the page, there is a button "Submit a new abstract",
Click on that to start the process. Don't forget to select the pull
down menu MM Micro conference.

Hopefully see you in LPC then.

Chris

