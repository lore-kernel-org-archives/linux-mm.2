Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1269EB364A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 01:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 026306B00D0; Mon,  2 Mar 2026 20:40:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36666B00D1; Mon,  2 Mar 2026 20:40:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15616B00D2; Mon,  2 Mar 2026 20:40:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CFF526B00D0
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:40:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78947C1E7C
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:40:50 +0000 (UTC)
X-FDA: 84503047860.06.898D16E
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 75D6B4000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:40:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="1iDJ/Pu4";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772502048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RHtEYTysNPYagRCHLFbuCPDqzq95xfw2UNoQ2VwUxZ4=;
	b=tx79BWQsGwiuCq6wb6JctykNjcPYyrD1jgP+oBilhHk3KGH1KQ10HsFlUCLkUJf3ZxwrPz
	AeiEam95N2NZLhmWlx8Tu6rHlvpfjXOcDBAzpjiz52oTny/8tAcOwWFPGFf/zn7rLliMp/
	iTmRCnnQz9lelyPJY8c6mma1TrVXVNE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772502048; a=rsa-sha256;
	cv=pass;
	b=Q7zDDsXKdGOiwRfGNLf/GyBrEytnkaF3JLdInCPl8yiIrWm1GuzhH50IgTfuiamuFgPKK3
	DKK7sG3OQzTZcLDzvm8usclN+fTkG+mZm96xKxMso07eWMV98U90UEfIJy/RBGD4YAWC9Z
	Dxgl+z3HxlrFE5dG3onkYUoxXLljuJE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="1iDJ/Pu4";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-126ea4e9697so2547c88.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 17:40:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772502047; cv=none;
        d=google.com; s=arc-20240605;
        b=W9h2rzr6LofzD9PfLo1MheeNBBz5ASGZXNP0/V9hhYWh8y+m+bnLvpNz1JQqaudzgc
         h83N1s5hsKzGkTPite5cliH7kGZq78CoX7br0Allrh+6FMJLQsqLzndRRiQznx6ARoEF
         jwrXwgExEMTg3jzboTBR0lPSBEwtT6JfEQ9+5hW/wNsxYFibOBmgHcsl0Yw28Jja3y+0
         7QJLY+F/Lh2L4tcipcTtsOaeBeYqAUVSom4PxRvyw9SvJEcKhtv3fSKd80bsKWENwvGs
         QyikCcBnlQRs6x0pixfIy3oncheoFF0wqGr7Ry0rmkEn7IzFRWbk7xCQN6PCevDXS9WR
         kCvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RHtEYTysNPYagRCHLFbuCPDqzq95xfw2UNoQ2VwUxZ4=;
        fh=ri8r8UQOl/TPAAErefjJEFr0WkMSDOJeHz+3WAZSGdU=;
        b=jPcTRRlGe+lN0HZWTzPBAslgQilsWpAE69vhlQKJl6GDAX3mrlXgbmwBsot4ZZa6Q6
         xe4vjNpGB/yQkZ8Yri2EFsLPw8CB5dHEytHoInRbMw2m7OI1+lXopbUzAO5xum1myfrf
         Af9DB39Xe5nY8zWPx9Yq+Ff95lLYFtVibtGif8mCK4+gmW5PnEwTIUE8lz8+HcDp1bfb
         1GORXMee/+zTTOXqqfYIs0SSswPc9W1O8r520z4Sh/juXWExX6i2X0oaDD3C09slOtW6
         7ZfwrNwplrxHHq1e3hPk0ha7kr7E43TAZjlX3kkweJ1YftaQTtpqXz5Ghuaqhtd7lJgr
         wKug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772502047; x=1773106847; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RHtEYTysNPYagRCHLFbuCPDqzq95xfw2UNoQ2VwUxZ4=;
        b=1iDJ/Pu4JnkhNpkttKt2I5mTQRU0U0tPKpaEDVfiFGU33udyGRX4i1ToWzN+foZwo5
         pE53cbK55XekSNY5BAtRBfCIJQ8eOUoFk47AAeAyp+J+B+7MEjsM0yPuifK+WbHhOsor
         mWCPA933iB6lANMUccyP+y2RKD8oO6EDMiTLtJ5yN27hJYWxj4EHWF3pLcUMmPPTl/o/
         jQ6r/mEu7a0SeSBEVxpMs6cnS8VP4AkpVUqzrIAeiXMlv56oKGsCbGJqItWLnWy5o3Q0
         ZMHnXUY8TMFLD8vnoI2mim2afkg/FBTUxqwceIxvFGvPi4LueUEcKfdmpYwDKMmSvlnd
         fLig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772502047; x=1773106847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RHtEYTysNPYagRCHLFbuCPDqzq95xfw2UNoQ2VwUxZ4=;
        b=nFpthLLLIoH1LLORDpg9is5qbHBYjl9QIye5maDwMA8OltZbw9xycRp4zBsk4SHEce
         /7foKG7Kh3mGlZSNjBoaaBcbIc+HDPOEtF65vnKTaWlyDlQIddKlFO9niuWm9triSf1x
         njjCe6Lm0qqjypsHewrv0U619nkpbjmu4Jn+PwfAOHqhrrUjYL6xvTx4dgqHEAiEV7l2
         ICDbkZbsQw2A7BWoNxEO67meKFU4Cn1+vWjJezigZyWRN9nLbmdqrUXxODCpOtLs4qs7
         elytUo8KJcw0KdkKVtRqJXlb7u9hvVza5FqYEthPoRNVFP3tD2L4CHZYXGQiufVEkPGN
         +gKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXHq5jD9Raa2ex3aQsO7Fvyq0mqNmNQT7LRTgPTwF6KHFzEoOV6JkhjrjO4sR1GyEQWmZaqu5FQg==@kvack.org
X-Gm-Message-State: AOJu0Yzdd0sljmX4WK43rOh0Xvsa/HAP595w6rtLHz9bR8OyDH7ym/dP
	9bkaQbMj/1qqIyAOViDKeWpugcggK9U0GjqrNkwK5gJDaO0yHEYTOBOqmmAOBjJwm0stGLNbFVR
	o74eHGGOFLv/5CEoHFy/b12mwn8HPUZI6okPJuMAn1T7Tr0Sjh4X/Ag39
X-Gm-Gg: ATEYQzy1/VqnK6CV/bzdU2SIJmAH1pvIAeyUNE3tdTfwNTSgNoymRo9hZdQ/9kF/Sf3
	ce4BYATD9r8ko9y7kz1rM6uswP6XWdTiMNOGXJ8AToDyvjd0OfR2XsCsCLp31lD+leZLxA9RbFI
	zjSCwmR3Jf64g2OVtClrR3ZAD3VIRwV8obvJ//FoCPCdgTPmVqsoNouglqfu3qjMgv68HES6oLy
	3PcwDM+g8WrPxpMgFaqTxeKtq4i6b8DgirmLGFsH0+/cJGjq4zqrb9CMBCOKgvK7w5t0ggKKQ6i
	6jbPQUTF
X-Received: by 2002:a05:7022:4087:b0:11d:f440:2690 with SMTP id
 a92af1059eb24-127961b4fa2mr253738c88.0.1772502046523; Mon, 02 Mar 2026
 17:40:46 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
 <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
 <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
 <CALOAHbCma=SW4nu_GPv_pbuuXv1V5JPB-9cA3z1TeemWqU68tg@mail.gmail.com>
 <CAGsJ_4yAkaqqzSu7SS=_fgZ_AQCqtbv8LmuPGCb7SiFpGk4csg@mail.gmail.com>
 <CAMgjq7AkvgzW96-JQzEg5c4oW0cMsjPHcCnukCUZXgSvXL4-DQ@mail.gmail.com>
 <CALOAHbB3rQ2b7ABqFegt2afYRL7KjpWREucrhOYfTT=onV1+Gw@mail.gmail.com>
 <CAJj2-QEO=9Nt+HP6m=xtFD8qcXCdGCRmESmcs0haeiMdqqTA1Q@mail.gmail.com> <CAGsJ_4ynhyROTMsy1m3AZNsAzFsjZY3EYpSOSTLR0dQSxO+akw@mail.gmail.com>
In-Reply-To: <CAGsJ_4ynhyROTMsy1m3AZNsAzFsjZY3EYpSOSTLR0dQSxO+akw@mail.gmail.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Mon, 2 Mar 2026 17:40:10 -0800
X-Gm-Features: AaiRm511ojTjG7hKo8xpV0lcRPHhsif7Fad1_seCXYrxXbU-9Yk4OJwDsS251r0
Message-ID: <CAJHvVci8nc-yTHkAbSEQQtqkRvgATJWcSTwBCY49A5W4AQcd7Q@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Barry Song <21cnbao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>, Yafang Shao <laoar.shao@gmail.com>, 
	Kairui Song <ryncsn@gmail.com>, bingfangguo@tencent.com, lenohou@gmail.com, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	weixugc@google.com, wjl.linux@gmail.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: nri7nyd1ng4jjhpg4be649ugmt3eunxi
X-Rspamd-Queue-Id: 75D6B4000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1772502048-136336
X-HE-Meta: U2FsdGVkX18r4TG8CGMAXpZ4USvvihpGPjfe3KBnWAywtQbOey8oHpzS0JvF4iwt1e6YxyMlYuihhknNYV295X8qmSxma8Icy18rH+kNPgZ2wm99Qj2Vr9R7CZ438nbteAFNohdtT6q73R/qW6o8H/gG2HDKBtPkpxeIEOUwkaL1XUPLv94gQvQKJj/fTLzh7fNnLxJlKO6hsmMGWCdoRuc5si/Dzslg5mW6OvAbda5d/JPJxFgzfCL3dVJ9Me8uCsEl+fhlO85LPn2II75LnOwonbj3tTxA3nh4iUKgZyUdTwjzgWBeEZXU5X2ti8BaJSlUsKtCAeCKEEUCYcVBdIXI2RTk0qtNYaD/+Wx7ZBvBam0Mwb7l1Nue7ZJQnKrxZhV6cgs/ioUiI6rWqXRp7mVnHsS/e9LBMnVakrRHe7uriMXkjc15RWHgFwVzMAwck9D5aUjXQlDiz4njp2X2igyI8sLfQpPwI+sTFAx22wvxvH74jIF9RBPuraMS4yyhMf9bdVToHdQVHxpu/U88hlb6wScy+XPKlwwIeM5Gk226fyBhq57ik9/4KOD+oo6BalERLyYZ3Q9e2X3mOXFXNFh2LbnH7tUlxgU+LYSRBVYvzwPJWaoxXksUTw858vDeMygusWkxt031l4ZN9tslaMHnLyeJrrXLWGh93xMlFnnDy+Cxr0hACmcbtxLcIviUAs8q9CFG1biDDOnvAmha2EDfI8ttp1QsVPvLbEUTxOcaaxXFBSqwUmfArsNgs8wlFwqnkA6TtafwlOK+csY83OKoMlKZnXUuaWZaTbinMb0Acm53GTjfyuQhqJLqBBd1aJLmLgaNOOavpDM7HI6ytZoUTgKVvTJSO4Ixb/N9pUQDjUZn+790PpT+PS9C/WjDeR37r/glkf2TRuef2VYmqPONB7GmneP7mT6Pc3oEQzcmwq8DtamW4zKBUgAfOwU5cco0IRDQkfdtx2FJeWY
 jFxwI5vG
 QQD8ETiawaHIgNMTX8tU3L3LZ1Wy1hjSPx9ltfeaHVvVdyZAy4n8nYZfkeAUc9G3VTyLs+JM8jEMfNzw0SbCT6L8eIBjQSB0xwYcWFxj4YULanM4nRjYJhiXlCjQ2obkecoTvGv20BHyy4+NAoU8Yg3IrSeFf1ASgAy9bgsk6fbq5KHCQYTmDdCF+ztDmaPHk3U1tBTjl0pWIFt3BXK83ApXFZ2YXh7bV/X4pyGDitpKVdzXyFuI4zFSv/iOea/eMtJFEq/ooSIkPUySrcnEl9kxXpe8JBDYX4RUCahFZncFTXtuYKy0gPbNkE4TuqovWPCqkKytuhjLUygHPEPK/sdg4X7Og3tvdJSDN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 5:34=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Tue, Mar 3, 2026 at 1:52=E2=80=AFAM Yuanchu Xie <yuanchu@google.com> w=
rote:
> >
> > Hi Yafang,
> >
> > On Mon, Mar 2, 2026 at 8:36=E2=80=AFAM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> > >
> > > On Mon, Mar 2, 2026 at 5:48=E2=80=AFPM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > > >
> > > > On Mon, Mar 2, 2026 at 5:20=E2=80=AFPM Barry Song <21cnbao@gmail.co=
m> wrote:
> > > > >
> > > > > On Mon, Mar 2, 2026 at 4:25=E2=80=AFPM Yafang Shao <laoar.shao@gm=
ail.com> wrote:
> > > > > >
> > > > > > The challenge we're currently facing is that we don't yet know =
which
> > > > > > workloads would benefit from it ;)
> > > > > > We do want to enable mglru on our production servers, but first=
 we
> > > > > > need to address the risk of OOM during the switch=E2=80=94that'=
s exactly why
> > > > > > we're proposing this patch.
> > > > >
> > > > > Nobody objects to your intention to fix it. I=E2=80=99m curious: =
to what
> > > > > extent do we want to fix it? Do we aim to merely reduce the proba=
bility
> > > > > of OOM and other mistakes, or do we want a complete fix that make=
s
> > > > > the dynamic on/off fully safe?
> > > >
> > > > Yeah, I'm glad that more people are trying MGLRU and improving it.
> > > >
> > > > We also have an downstream fix for the OOM on switch issue, but tha=
t's
> > > > mostly as a fallback in case MGLRU doesn't work well, our goal is
> > > > still try to enable MGLRU as much as possible,
> > >
> > > Our goals are aligned.
> > > Before enabling mglru, we must first ensure it won't cause OOM errors
> > > across multiple servers. We propose fixing this because, during our
> > > previous mglru enablement, many instances of a single service OOM'd
> > > simultaneously=E2=80=94potentially leading to data loss for that serv=
ice.
> >
> > Would it be possible to drain the jobs away from the machine before
> > switching LRUs? The MGLRU kill-switch could be improved, but making
> > the switch more or less "hitless" would require significant work. Is
> > the use case a one-time switch from active/inactive to MGLRU?
>
> I guess the point is that if upstream provides a sysctl to
> toggle MGLRU on and off, then that sysctl should actually
> work as intended. Otherwise, it would be better to remove
> it.

I think the problem is the requirements are not well specified. :)

Is it enough for the knob to function well on idle systems? Or does it
need to function "ideally" under all conceivable workloads / stress?
Also how do we define "ideally" - is a stray OOM kill acceptable or
not? Is that preferable to waiting on the switch / drain to complete
during reclaim or not? Reasonable users could disagree.

>
> Based on the previous discussion, we have two options:
>
> 1. Reduce the likelihood of OOM and other errors.
> This could be achieved either by applying Leno's patch,
> which suggests shrinking both MGLRU and active/inactive
> lists during switching, or by making shrink_lruvec wait
> until the switching is complete via schedule_timeout().
>
> Note that there is no guarantee the switching state
> won=E2=80=99t change during shrink_lruvec.
>
> 2. Ensure that shrinking and switching do not occur
> simultaneously by using something like an rwsem =E2=80=94
> shrinking can proceed in parallel under the read
> lock, while the (rare) switching path takes the
> write lock.
>
> If we want to keep the toggle, we could at least make a
> small change to reduce the likelihood of mistakes?
>
> > I do want to note that OOMs causing data loss is not really the kernel'=
s fault.
> >
>
> Best Regards
> Barry

