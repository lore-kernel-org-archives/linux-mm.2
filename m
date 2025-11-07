Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51820CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 16:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A26418E0011; Fri,  7 Nov 2025 11:29:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FDB58E0006; Fri,  7 Nov 2025 11:29:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A798E0011; Fri,  7 Nov 2025 11:29:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 843438E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:29:33 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 221335959B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:29:33 +0000 (UTC)
X-FDA: 84084346626.04.0F450AD
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4506F180004
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:29:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CzbSMyc2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of chuckwolber@gmail.com designates 209.85.166.179 as permitted sender) smtp.mailfrom=chuckwolber@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762532971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpUHhwLLVw048cC2Tr3FEbA9y73h0hyI54ZDUH0t8tg=;
	b=tS1zKZ/CC/5jUTlmDiMWE8FWtmP2cq6LxxySwqSrw1upGd8tE5p50XoMAZsqXykQa7l+/J
	1RUYNK32Zn7nvjUVidroyPxCSIGRKNUURJie/XDjkNPn1MvaEbizNQebJiuej5ST5ph9lI
	n+pxVHnYaVEsThCJc1cMnnjhnu58fN8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762532971; a=rsa-sha256;
	cv=none;
	b=syafViP0qFbuyY2NOrpvqhVzqU4PpgKCNPYiUC540fVcI1nnLV5lLD3PyFyv1O+IehZCVo
	z/1HWWQE4181D08ii9dVYUF99BuSWhMJtOor5ggOCvDjvAIg9Mv+qz2Vl1oIievgBMAH/n
	0gYqsa73YY4EE7HbVIlKYfT5kqdqS+8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CzbSMyc2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of chuckwolber@gmail.com designates 209.85.166.179 as permitted sender) smtp.mailfrom=chuckwolber@gmail.com
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-4330d78f935so7364175ab.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 08:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762532970; x=1763137770; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KpUHhwLLVw048cC2Tr3FEbA9y73h0hyI54ZDUH0t8tg=;
        b=CzbSMyc2HjSATGhoEQ0qOAUC1tqauRCFpRMkfXL9hyb3fsYR21IvxJQkB0IJ2kirFa
         UpeHzTw79kuW8R9lnckf3qk7+9WnPZ5S+1qsOWEikMo/I9dtp3GsG1uoBALiEFhn2Lbi
         vyIjJy5tTsiETfMc2WFJhS3JoT9Mspu2jrBiTIFFW5N6bv/J2Tyb6Rtnn0strgZjyViY
         UUhU0WVpBqivdxAxDcV8Ak6goDK9VlTn/YcbzgGWVIlyGc6LrfnXkOOxCi0PFcLoT96s
         JJd1Yk3tIjQ02D4RFIMxb1UEIkUWGRaJZzuDWfmnBqEzuZoOPJnwQOlVbRnf04hdqX0D
         vExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762532970; x=1763137770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KpUHhwLLVw048cC2Tr3FEbA9y73h0hyI54ZDUH0t8tg=;
        b=m7qkq4d2a9iH/LsaEL8U5NKjZz4ifhMmKTqizB99ZehfOPHo2Yh0z3mja6iYx9Jb4Q
         dpaYZE8SjF3vpUZBKP5DCGzuCcqUSgNVJj4fgxRwsJmWPpCSab2fyubSpqBxTLtbdZdX
         iKtAWZgsFHDgIZE8zmFvsQ6zGzwYU2Ym5tL6ePV2G3iOiofHm1S2MWw6SAVSr6/836ae
         YjfDWZx9dsjTo8Uxf0sH2ZFJ2TdCvrT/ZtmQl0C53xgKgyRTvmYrDt5zCvyk1HLeHqgh
         Odw1a/FJRkP8aRWO9tfzfxkpZzQyvNcUYhLr9lOH5gVSKWcguB42dfTkp2HcXViz+31Q
         wxeA==
X-Forwarded-Encrypted: i=1; AJvYcCW4w2PiC6LknwI1WbbEkUn5KtlMUvJy0WNYdjwD6qZOl2PmAqSyt8NmvgHyT1txemyFiqhfQ6cUNQ==@kvack.org
X-Gm-Message-State: AOJu0YysGh93SxvvXyG6ToLMGFv23bOU9/Jir+pejdZ/zHl9mUa82mIN
	kQBshMQ0HzHdgXEtjsWg5SuSN0CbKbkd0OqWDGPbF8TtByEnBpbjTsnMwG2Irq/T9N8EPvLNGMl
	sUZ4GRdjDIzBXW0rsm52jklzHLSP1f+A=
X-Gm-Gg: ASbGncuYWJOPOeOq5tIEAQwh+GlvH0wQ3MDYLykWL4cG8+U77xNK8BUykHADsM05kPh
	FJ4kFJ8rsFvKY5DrmfOEQwuXftjOWOF8wKmJ7Dg/DdwaJrf1+CCO7uljjB0U4YWbTAvGoEa11c6
	PChkIRM4tqU5l5bZP//N/KsNENWzetPhy5aFaAVsg+vNmDGZpu3NKKWyP6QcHkvB1mgaS8DTnAQ
	KYwawNVhlC/OSkeBfuE/+vwuh6u1s4IorIQTyKHwX+M5zdHCLr8cpa6z6CzEsug2ukUqLxp85EG
	nTNMPMJWPWE5vFclAUePfHVbIsCQXgHgwhq1lDAk75m7q3zPuICA22BgYEXdWGw8Sf0N3xqdmwv
	TrfBirkCZuBRxtHFX90DHl+4zOhh7d6MLytrptolMVkGoWYextTwBIYtDMi7lIDiFnYbJ5M7toy
	FlylxyKQ==
X-Google-Smtp-Source: AGHT+IHLBeBsljRup9vfyIw0zMlrDC0E78/7aLQDxLzaAjO0KjqOY+HyEIQe54ZnzvQGmNPUrUss4m9CIjqFlxlmgpc=
X-Received: by 2002:a05:6e02:168e:b0:433:46a7:be57 with SMTP id
 e9e14a558f8ab-43367e17daamr795725ab.8.1762532970241; Fri, 07 Nov 2025
 08:29:30 -0800 (PST)
MIME-Version: 1.0
References: <20250910170000.6475-1-gpaoloni@redhat.com> <2025102111-facility-dismay-322e@gregkh>
 <CA+wEVJZEho_9kvaGYstc=5f6iHGi69x=_0zT+jrC2EqSFUQMWQ@mail.gmail.com>
 <2025102124-punctuate-kilogram-da50@gregkh> <CA+wEVJajSGzb85YTiv98yAY3bcJFS0Qp_xjLc++wnU8t=wDAOg@mail.gmail.com>
 <2025102211-wolverine-cradling-b4ec@gregkh>
In-Reply-To: <2025102211-wolverine-cradling-b4ec@gregkh>
From: Chuck Wolber <chuckwolber@gmail.com>
Date: Fri, 7 Nov 2025 16:29:13 +0000
X-Gm-Features: AWmQ_bn6uEo7-A9xvlR4_AxUEmBwxnRKzTpVyrh4GYZ_AQq2WQg29VVKDwL_Wwo
Message-ID: <CAB=6tBSaGfKq4RgV=nbw28Yq59jHMrVOkm_dx2bqD1AjU37oaw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/3] Add testable code specifications
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Gabriele Paoloni <gpaoloni@redhat.com>, shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, safety-architecture@lists.elisa.tech, acarmina@redhat.com, 
	kstewart@linuxfoundation.org, chuck@wolber.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hr6y8fuhhbpua3uxxk9k6o97fn1dk5pz
X-Rspam-User: 
X-Rspamd-Queue-Id: 4506F180004
X-Rspamd-Server: rspam10
X-HE-Tag: 1762532971-925403
X-HE-Meta: U2FsdGVkX1/34r/HYRWhKKoEnnnjFHDwj90a7l9UBOS3UHRHFZ0KPRTx8pCCOydLwFr6Phh2ozySMPe8fyGDqe1CpJC9NwGkeLCTZ/znHw+5pdMtx5haU9MwHTrdpmCoShJ+ppiWTEpUMFJLpR9CivPqZ0+7f3YkZslvGMFmBh1uWVhLanylwrunnpKxclWLM0e0SfpwCqIr57OrnNbW2dKMxVJUMS7Eql+0zsHUv11tzXmTUJAxHSvtBG2iIlhhSZunZOT5JDV+0xv0vVvghj2p4O34fwUGKtYr6dImkfzG1Zh0z61LgMnLK676ONXKBso4YBXLMnC7HqUI3xJEeEa9sL9d7LjlUCKq4Yi9Vd50VmSWdzgcPYGMExuAhGThekuV+gIoH0l9V7GJnkC4PiYHb4vrnRebv3YKhVLZ8GKukUc9Zy1kr708rRML0dPN0HkZHjvY0PcEWTOpdbTjvWoLtU6t9d6dZWy7Z7rYSWgy9frQHk8x/iIVBnmZEw85VtcAx8p+Z/dxgGcM8ezgR6KOltr7ghNaSdkG9xrkVeQxID4HNdmOOxmwK315XxKgcJGm0pHiSRaiDZBylvnf6UZ/LkQq/gej54Y+V/XxKt9TwtD3a2oc79qewoYon5EEwKo/r/v7R71+BWJVjUB09LBNvy7Dt04kkCImgrtlpYdBRGcSqGucOwsqGUh6X1M2sK1ESLxAkV5TU7B9W1NW7T7HwIPnF7jtqUNjSLWvHZtt16q6Es0+l0HhMtet3AFqN5PI8MmI7drGdo/XDgceyPux8/pD/W8TJoQKvMBBHzNx9yeyXd/DDjrCU02uJ6MWzf/C/8gpiIvchiDIURvkUXJR+UnW9i8kLMhnLoepo4tk8A43wPb6W/4gTefVz8iSvKAVWfRViLaVmc8xpD9UAmE2c1ZK5xIRBX7Hz7u/ywXIOxYFFQvZsLGxoKSTKlcpE4rfKTZQi9e1aygmOQO
 H8v8ht5o
 DPBtyCHykySO4LNq6eR3wmxVH6ox+dvOv9JEKL6XgKfWIi/iGiwxBpZlPvy/BtX/cggTFYOrlo+CeeBefoJX3i9rzbY4LF4uhhlbU+oDe3KXD+oAQcHtAtrR54nXAaU1VMUJ+s5RHpJ0W0zBE+g2leGv8F4Z0zx1IvBcjfMwSJXLKrWEiFlHOyOkTcjAvmD28vavxABDgfbYtLhMWWmhouXqACCdoYZw4Zm0ipxS1xdSa1SSrinphd4ScCv2xetQjyq6ckt4izNXYIYvV4eXEBoe4ESNouu0fUR9g6yYgoTASscF3GRajYRghWPfyUAWItqgXdyf9NbgZetD1EI/VmzUrPbHSKZH/ZQAgYPgojxesTqY0l0sCkfEwYutl9yeOcVpMjO1tRRlMTur5ogEy5DF2rw+ObrQFO956
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 5:13=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Wed, Oct 22, 2025 at 04:06:10PM +0200, Gabriele Paoloni wrote:
> > > Every in-kernel api documented in a "formal" way like this?  Or a sub=
set?
> > > If a subset, which ones specifically?  How many?  And who is going to=
 do
> > > that?  And who is going to maintain it?  And most importantly, why is=
 it
> > > needed at all?

I appreciate the questions. I sense there may be some confusion over who th=
is
is intended to benefit.

The design of the Linux kernel is emergent. This is a fundamental property =
of
the way it is developed, and the source of its greatest strength. But it ha=
s
some shortcomings that place a burden on kernel maintainers, all kernel
testing, and even people who wish to contribute.

We intend this as a tool to address those areas.


> > > For some reason Linux has succeeded in pretty much every place an
> > > operating system is needed for cpus that it can run on (zephyr for th=
ose
> > > others that it can not.)  So why are we suddenly now, after many deca=
des,
> > > requiring basic user/kernel stuff to be formally documented like this=
?

You are correct, the kernel has succeeded over many decades, and will conti=
nue
succeeding for many decades to come.

With the exception of some very narrow situations, the emergent design (or
"nuanced complexity" if you prefer that term) of the Linux kernel is not
communicated in a broadly consistent way. This affects the way the kernel i=
s
tested, and also the way it is developed. Even veteran kernel maintainers a=
re
tripping over nuance and complexity.


> > Let me try to answer starting from the "why".
>
> Let's ignore the "why" for now, and get to the "how" and "what" which you
> skipped from my questions above.
>
> _Exactly_ how many in-kernel functions are you claiming is needed to be
> documented in this type of way before Linux would become "acceptable" to
> these regulatory agencies, and which ones _specifically_ are they?

Exactly zero. This is not for regulators.


> Without knowing that, we could argue about the format all day long, and
> yet have nothing to show for it.

As this is not intended for regulators, it is not clear to me that catering=
 to
their desires would be a good use of anyone's time.

I say this as a software engineer who works in a _highly_ regulated industr=
y,
and who knows the relevant regulations quite well. There are good ideas bur=
ied
in those regulations, but (in their default form) they are _not_ appropriat=
e
for the Linux kernel development process.


> And then, I have to ask, exactly "who" is going to do that work.

The intent is to allow for a separate maintainer path. There is more to it =
than
that, but I do not want to bury the lede here.


> I'll point at another "you must do this for reasons" type of request we h=
ave
> had in the past, SPDX.  Sadly that task was never actually finished as it
> looks like no one really cared to do the real work involved.  We got othe=
r
> benefits out of that effort, but the "goal" that people started that effo=
rt
> with was never met.  Part of that is me not pushing back hard enough on t=
he
> "who is going to do the work" part of that question, which is important i=
n
> stuff like this.

Well, I am sorry for that. I am not quite sure how to respond, but I certai=
nly
sympathize with past frustrations. I have plenty of my own.

We are not offering a silver bullet here, and the work to describe the kern=
el's
design will be finished when the work of development is finished. This is j=
ust
an attempt to fill in a semantic gap that is responsible for a great deal o=
f
technical debt and maintainer burnout.


> If you never complete the effort, your end goal of passing Linux off to t=
hose
> customers will never happen.

It is not clear to me what customers you are talking about. That is certain=
ly
not a goal in the mind of anyone working on this project that I am aware of=
.


> So, try to answer that, with lots and lots of specifics, and then, if we
> agree that it is a sane thing to attempt (i.e. you are going to do all th=
e
> work and it actually would be possible to complete), then we can argue ab=
out
> the format of the text :)

I respect what you are saying here, and perhaps the point of confusion came
from the safety related source? As is often the case in science and
engineering, we are borrowing (and _heavily_ modifying) a technique that is
found in a different domain.

The intent is to target technical debt and maintainer burnout by filling in=
 a
semantic gap that occurs when a human idea is turned into code. Ironically,
this is why the safety regulations were written in the first place, but lit=
tle
consideration was given to development methodology during that process.

Thank you,

..Ch:W..

