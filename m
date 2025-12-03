Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE5F5D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 08:38:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578BA6B002C; Wed,  3 Dec 2025 03:38:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528BD6B002D; Wed,  3 Dec 2025 03:38:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43E526B002E; Wed,  3 Dec 2025 03:38:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 326BD6B002C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:38:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CA9F591DF
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:38:02 +0000 (UTC)
X-FDA: 84177507204.20.F562F64
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id DD69C180013
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:38:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I3qlBqub;
	spf=pass (imf16.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764751081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+b6wSTQsqI5oIpSIr9GCjA+H9X1JfcD4EvfDkM5jJyE=;
	b=OMcDvqeR2ElFeOQjfV39ddYG+oO3LnFbj9MGrNnaKqQGPANBY0/KxjNM7rBXr1c4eC47UJ
	h7I5ocDBEYst8gyDO3/d2lIfmUZVEb3tPoEDzliWShgbhPXWDhzEK0gsbuyUOFnhHChViw
	RAjDAaiP+bdilSeabOYvmP+STOqUqvc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764751081; a=rsa-sha256;
	cv=none;
	b=xvvT6nqDalIlKzqwKg/vHKJ6wTP0TUVp8vUqmpPb3v7B/HozHWRCvh0ca+JsKzS+u1xEw0
	ScgCTdhEXxGBkOWfkjVX6aYWibs4cmy+Tj6ZUbN6jGvFUfon1SA5Hvs2JmQgPA8wQAMMUa
	FVJCyR3ozb0xE8UhCsqbYWj2HxlbouE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I3qlBqub;
	spf=pass (imf16.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-640a3317b89so10123884a12.0
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 00:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764751079; x=1765355879; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+b6wSTQsqI5oIpSIr9GCjA+H9X1JfcD4EvfDkM5jJyE=;
        b=I3qlBqubdtYge2jzHKDMdtd/q3kUyocuoactLeVHk4zwoy2XcJaSBaHdFHtR4lKbOH
         oA2zhPuA6LSBUrzmPdEg15k+v9HKr5p9xPg74WfhHBSxkxgMOlzwNIkSF1OtbxkTmVPH
         TmwNLpY1End4V4fyRMEVx2NJkdSVjI8HpcM60x2Je8Z95urjo3RY1Dccj3uhVvy5uS+y
         XxFk5vv3jFven3lxdQwzummHFmA7B4LQ9S3v9QzREQhchoRv1vrrNlPBQF+ix7GN3OIp
         FNScxFTkZFySbAxNI4f3zCJgD08XcNQgYb1gIurT2llm2YZwW6zsbWlUwzugAZN55xFY
         QZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764751079; x=1765355879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+b6wSTQsqI5oIpSIr9GCjA+H9X1JfcD4EvfDkM5jJyE=;
        b=DrNn6s+1mkzrGKfoUj0GGuKVWi4A5JH5S0NEJUG4vLzLu7YPAcD5FX9Nj1DFKptXK6
         CKK3eXfWMzJQgNeZ0Yrn986XkruhehvRBX6BK1PI+CLXgYctF0ilY0uUMe7GrBXor5X+
         rf6Zfzk7WCel1NeOxmtf57CA4ZAk+fBPCkuC6soYYY+tM6b1PxQ5g5BatJGM6y92EUEw
         ea3r14XfQcXPiy+QnGg9TTQyuCZBp9pqPPRApQWxtIvInR5zu4IiQLFcPa0saNv5gJ/K
         rxQAqKIs07r3wJRWH8dW4vdFh68gD+krEewI1WBIxPUYFSnwnIJhE5VHwhS1Aw35HkLI
         oB5w==
X-Forwarded-Encrypted: i=1; AJvYcCXiGzKcdy2lyYlubgrbwXQ9iL5rBYrgHSDbl3xwsIPhdB8B28JmU32kBuYVjV9feBBnaC/Efeuz+g==@kvack.org
X-Gm-Message-State: AOJu0YyvdXUcq5IGgoLIVkR3CBMRmGcJfFg8Ga1s7lFk/JQ3WFL5Dw6I
	Ob+dvzkAK8I6HX68fXUCKDdyunZLKvdGF5W4fVTqpMWMzytLAeCsOs45zklsMCtVsFkC/baDIT1
	jNaX1wW8I2v29adWj7KPTrlFGJcCFqTMoFA==
X-Gm-Gg: ASbGncv0XSXODyzHRkf/FCUPJp9c6QuUnYDwa87o5Vo2h+4bLlNbsPgTPQx5R/HK+YN
	CGFeOtd3uBt5TQwV6399vC+5dq+ZTcavtifOC18jkL7ns8PdwTdLkH1pjcH6CP+Xdy4iNBkV9Jc
	TIICDqHdBB/9NM8Tv4SALSJhDjgAWScV70u1iKdDc8OypMb3OHE12nxgo+ervfTvLvhA9tM1LVM
	5qPEmUmf0CCPTKoAMi/0g9EX2Oaj+zH3IJPdb70J0pcM0xNlrbG0ZPEjMBPil8gnzo8cjkK8owg
	g19tNxwxeOdJbbhCSgZGiVX+pw==
X-Google-Smtp-Source: AGHT+IHI+TsThZ5CprM23oS61xiZtJ4IkCEddA1qmFHBChAOJ8qtGyi1f3ut/jEA1oymzub/6+zpJSo+m38V2T5BcwU=
X-Received: by 2002:a05:6402:280a:b0:640:b643:f3c5 with SMTP id
 4fb4d7f45d1cf-6479c48bce8mr1205374a12.16.1764751079029; Wed, 03 Dec 2025
 00:37:59 -0800 (PST)
MIME-Version: 1.0
References: <20251123063054.3502938-1-mjguzik@gmail.com> <aSMhj2Q6BTMNSsA4@casper.infradead.org>
In-Reply-To: <aSMhj2Q6BTMNSsA4@casper.infradead.org>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 3 Dec 2025 09:37:47 +0100
X-Gm-Features: AWmQ_bljdBJZg4-0_LyT3_KxqzNbFs2pRCngQLdlYcDnflMloOrVXnJL5Pne6ow
Message-ID: <CAGudoHF1wjY5tF-aKVrjOHoSunSGTrGSrmm3nnmPArVzajTNYA@mail.gmail.com>
Subject: Re: [PATCH 0/3] further damage-control lack of clone scalability
To: Matthew Wilcox <willy@infradead.org>
Cc: oleg@redhat.com, brauner@kernel.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DD69C180013
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: zcwhhm8tfg3hwa1fa6ukobzsxjwq48bk
X-HE-Tag: 1764751080-717493
X-HE-Meta: U2FsdGVkX1+Z0JrwpuUQTXULJ6TRvmsurEnnC81/y9TnfqXHD8aUFNZzMWJMZAklNlaO3zjp8Kb468VXcXXTqPVIKfOUHKeaY2bsUQn7BsnYPLOMlzzH0whve1MGpu3tvCNV/uUrQVASBUcDcecBFVx4UlXwmPo27NGm6CpR+Bmk1Xr5IAngfdhFnG2b1zlaHz6mIXCLucJFsLMKqCk2qwmIJtpxOAg3f8pRN6cflqY+bScSCrXyUJ2a4huWcuRbFYGsiiUWQQYr6lfYU+lJgHXXLTIZly8G2MbBXVRWAwVjeUQ11zrDMiP5l/8jA3tAk9E8crBBYg3GeBXaqfFx5FtmWQVBowBS5x574l4FmkK+VsGacrRS1L4eAvAZHzOI4+3+y8iXFD2pmnc9nplzDTyOOpKl9TYirI3P/hPW2xx7nbb9DDeTYF0sLgQCO+bFzDI0A2BFUsJi9048P2WPiMEjHQH/2/1AZq4sSj8qSkv7ac/1neMVzuslBdLXmVCIpjPHfj8LqV8/YaMT6RpzVfBY/opkYAYeIGAY/ntkkPUx8u9pADaK0RbGR0gTtk5KEVkerhygCPL/bsHN06a0KDyf2C66m3diVOUTvc5a0cTFufpVbwAVYvQjC8WGJuDjko7rs2tAfnhHuSCQVoyc2GrANlZ8wC6OCGl5OEBkOSiGxFmSdccwfItnjZIZXcQRaWzGSATcqSAj/OpDX6KKnh3pn1Q7KUlO4F72rXujQRpXODnJnVJMc7Vxu5H9fYHb5WLZVp/yQELgpeVk8PCpZsX0AYmHk1JI+FCBle8MLJJyCKTt8398JSjZO3kSnhZc0ulzvli9F2bBOxxXdJ04+zoInyI6OdwvOxxyJD3+eaWJ/NjgoHa6n6BnQcqldA8zfHTf4KhJazdt7I8OCerQzNJYFoq78lvIQnHigVeV/BiQQYcaMKBVZguAS61IxD+Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 4:00=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Sun, Nov 23, 2025 at 07:30:51AM +0100, Mateusz Guzik wrote:
> > When spawning and killing threads in separate processes in parallel the
> > primary bottleneck on the stock kernel is pidmap_lock, largely because
> > of a back-to-back acquire in the common case.
> >
> > Benchmark code at the end.
> >
> > With this patchset alloc_pid() only takes the lock once and consequentl=
y
> > alleviates the problem. While scalability improves, the lock remains th=
e
> > primary bottleneck by a large margin.
> >
> > I believe idr is a poor choice for the task at hand to begin with, but
> > sorting out that out beyond the scope of this patchset. At the same tim=
e
> > any replacement would be best evaluated against a state where the
> > above relock problem is fixed.
>
> Good news!  The IDR is deprecated.  Bad news!  I'm not 100% sure that
> the XArray is quite appropriate for this usecase.  I am opposed to
> introducing more IDR APIs.  Have you looked at converting to the XArray?
> Or do you have a better data structure in mind than the XArray?
>

Hi Willy,

in other responses I outlined what I suspect would be a viable long
term solution, very much not idr-based.

However, that's not something I'm likely to implement anytime soon and
I doubt there is someone willing to pick up the matter.

Whatever the long term solution and who/when implements it, the
current code avoidably loses out on some performance because of at
least two lock acquires on each fork instead of one.

At the moment it is structured in a way which makes it possible to
take the lock once with minor effort.

Leaving this in the current state results in a minor risk that someone
will make changes which turn fixing the scalability issue into a
massive problem.

With my patch as-is I can suffer some pain and avoid modifying
idr_prealloc, but at the same time I don't think the modification at
hand is particularly problematic. Notably it does not change any of
the internals.

So the question is if by "opposed to introducing more IDR APIs" you
mean you are just not fond of it, or is it a straight up NAK. Per the
explanation above, I think the change is tolerable in its own right
and I provided reasoning why I'm adding it in the first place.

If the latter, I'll see about massaging this to drop locks and retry
memory alloc.

