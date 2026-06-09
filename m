Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 420DACD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 17:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815986B0005; Tue,  9 Jun 2026 13:50:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5A16B0088; Tue,  9 Jun 2026 13:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 702B36B008A; Tue,  9 Jun 2026 13:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62AEA6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:50:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0DC501C274B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:50:52 +0000 (UTC)
X-FDA: 84861114744.05.AFFA84D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0269D100004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:50:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dkkd8v1W;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781027450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=riqPe4mF8Xf/nvA1oOAWh2F1ufWhKQ7N3vQCbEzqwFI=;
	b=nk0Q5tL8H1TE6He2mRF0nghoz4KhCVW8yy76Zt0DZ6hS9T7TH9Ck3yko+kFYpVaithP0eG
	X0t0VqNbXEgry8082QBo+nM/gYLZaOaq1UwsoUUYb42HqkCX94Xo/sdDRKJ3FS6sfFZERq
	sYIt2fCjjTv9U0awWcE+kVvBmO9Z5TI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dkkd8v1W;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781027450;
	b=PAly1JYEIqpIE2oDmuT6eQtFpksRPneFf9OcPB5WIeuNvzrxm0DGp8hpOeSZJOsp49Fx2R
	BdnbGARa0LiF/Oz7dioe8KWW0WoWMXNmwpmS29sz1ZjbSc2Im8MFyjHqy3gVwRc5GyxGfF
	8ERqVssQMhJLtDKelBr0crB6fahpheQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14CD644031
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBE71F0089B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781027449;
	bh=riqPe4mF8Xf/nvA1oOAWh2F1ufWhKQ7N3vQCbEzqwFI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Dkkd8v1WU1HJD+eaAnqGv4pQ7cqvVBq4l03cGW/0HbUk5qsp8dibb1D/pKNbJs01I
	 GL86tQoHylg6mHQw4/B99eAJZOg9KqdWsCsd2y6KGxnImH+PWrMpDKVk4kdfgplcgN
	 3gpJFxe0Uy93JyRdeqKFaOpq+oipAwKa1WF5SdK4p8VLffgIcgUSoSwJ4OLeU7I3CZ
	 oA1QN7GIZplX+DSIs2O+vvF1itqP/7cxv2q3O5NZ59HkqmaeLmJqqe/ZBH+AL/HcBN
	 zPwHP19jVekFKigH9kRUwhPkN+vbXVNAxHSaQ7vOyJlWqwL29VjC0x+6HUXA8tD5ni
	 BNNWqd7C9aKIQ==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bec449cf976so817105566b.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 10:50:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+BVKZr25rOWPczVbPI+uR1736beneoGfYf8V1cxl3Hpxk4o39iTpTNORruAVpP4XD17syDSFb6vg==@kvack.org
X-Gm-Message-State: AOJu0YzuqEqaQnRw0Kse2S7VRmkPue9GoDb5qCt8Je29xYKGeyHapfq/
	RhRpbW2dlVSnS1jC4auMeqPQ29FIDY684qF0+dxY9kLfLkBy6PEGSXxniAFlYp9eQoLPjzO4sF/
	cxfiuBHX6LNUUKJ4F+nYl48wVk4/fwYk=
X-Received: by 2002:a17:907:b809:b0:bf9:cc72:6e05 with SMTP id
 a640c23a62f3a-bf9cc72723emr112423266b.25.1781027447765; Tue, 09 Jun 2026
 10:50:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAHPqNmyHRwhi7uZN5WP8h8w3peAy-y4ZTmN4pb-OaS2RbdkD3A@mail.gmail.com>
 <CAKEwX=PpwDawVzfxQn3AuuxQu4Kn24-0NcoXg24=eHD+sBk-9A@mail.gmail.com>
In-Reply-To: <CAKEwX=PpwDawVzfxQn3AuuxQu4Kn24-0NcoXg24=eHD+sBk-9A@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 9 Jun 2026 10:50:35 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMUv5gBkTEst=8GtyPTn1cixFggemHt-p_tPG55fosOQg@mail.gmail.com>
X-Gm-Features: AVVi8CfO-HYgjbOYhNhP1BvKXT26PpMBc6Im-P4-X2faQPMvAA5Lk-KUpDprk_I
Message-ID: <CAO9r8zMUv5gBkTEst=8GtyPTn1cixFggemHt-p_tPG55fosOQg@mail.gmail.com>
Subject: Re: [Kernel Bug] INFO: task hung in zswap_decompress
To: Nhat Pham <nphamcs@gmail.com>
Cc: Longxing Li <coregee2000@gmail.com>, syzkaller@googlegroups.com, hannes@cmpxchg.org, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0269D100004
X-Stat-Signature: y659mbzhnojwfpmz44647ncqu4sxo76a
X-Rspam-User: 
X-HE-Tag: 1781027449-683523
X-HE-Meta: U2FsdGVkX1+T3MV/jWC/MTNdaVaDppstWccKVxAs+5ktBYZhFLTdwi7SKA78HLG8X+AcD3MxLlMDXgE1yCNmV+2cJqzsQ7yJuvykTI95vteq9PGSxRp71DihJv0qwdHqffnXUKADBPNYiYciHMCZRScJFJc/RYq3Q4JuEB1IV9UGVon+55xxUvEQqvHeMqQoUDTd4hVefhhiMcE60BXt26tDDA79dju44VKsommstKmH9U6wIuWRo5byDg6V4O7ebmQ4bcwQsTPPDf+X76aQ3cRJxQqCDBlzrfg1pVvFA8G6xYEc/oPR5B9vf7HPSaNsvptZGcCwryj8xiVqwMyWGTFn2VO6muiYXYfr+FSglgpFyC41ZmRRIb+44Yq7hy74vCbJEobqP7oJ8NoDpp/2nvuQtBaPvAC60f0uWJcq8ewzlumbhTLgEupJ92STSc4dX5fyCf5TRIfwdqZ7Z45WHvMSDi3/YzhPSNxst32oq2lTZcQgp7YLWDq380mD5F8F0lqVEpqjY8P/0Cm/l00qgIOJH5+dTwZuFnDLNsGvHRmpFo3jCCFbQFQeX1/RZxfBR3NUh1JXJGEgQfMR0NEJODqDR4LtuqIPicelZbTaNY5rN32Jyy9AFzhTZy9C+7/7vDfnwaylmi0vHtUOXcJBmD7/ByRmFIRROWnyYWOneTIVobA5AiXzHY1li+qjJf3fMLysfT/2I5jRGn821ZXSBphB+a/7q/86SKHWOK0CcQpeI/WJy4FNLN6U0wDKOAy670sWbYxWbg6+OV/opSgvOaCsXn5pMZx7ioWphhkaDFCCZeLpj4XqSyam4Qi2+fmn9SeO1BAsqGpWiibQ6DwljbzUymyzWGj9skP2+OLrDreGC047VY9VUgF9/EvMUFvtUYjp7tFnm1Gkmxk8R2XuMHYgaO72C9ZTtSzxMGZCIq4AypDQ/OcmZxw237snzp9CNSg5XTmDyGFMB2svFFq
 /g4/RdC/
 n5QRHxCUshELZC1klz5bl5evjYlphC3ogdjSDtHtC5ew9H4k15/XtK9sXZZ31SCpvprF+kGcfECL4Mv+55MenfEWuxotee6VJ1e57oReYArUBbWXtNTvBGOGd1JiGdYmuzEMN2XYGLz3qTG3xjbmNWwUC3/oHpJSE9XJ52ss32foedbq3SwGAG3RQaODrG2g/rJz+N6wNfiK96w7jFWSnxQODVeLrSgt+gGmOMRe/4S1sCzKTV1R6t/QABUGn8uFMeoVYWntAeBpTZ3YJt736IZmuPfVrO09xDHps7NAJFiLINm0MvICBYZKiV9JKx2q/Ihqy5WiOuq2jVYxiojqFNmzE0j7blmgMY3uR4BcyXY6BvjAWGn4oIsnJLi4Xe253tNQtOcEfwmIqdu1hk9lpfmxftg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 8:40=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Tue, Jun 9, 2026 at 4:51=E2=80=AFAM Longxing Li <coregee2000@gmail.com=
> wrote:
> >
> > Dear Linux kernel developers and maintainers,
> >
> > We would like to report a new kernel bug found by our tool. INFO: task
> > hung in zswap_decompress. Details are as follows.
> >
> > Kernel commit: v7.0.6
> > Kernel config: see attachment
> > report: see attachment

If I am reading the report correctly, it seems like we are doing
swapin from the page fault path, and waiting for the per-CPU mutex
that is held by kswapd. Since we can sleep waiting for decompression
while holding the mutex, it's possible that we have some kind of
priority inversion where kswap held the lock, went to sleep, and
didn't run again for a while. But that always been possible for a long
time AFAICT.

Do you have any more details? Is this a new regression (observed when
upgrading to v7.0.6), or is it possible this was a pre-existing issue
and you just found it on this kernel?

> >
> > We are currently analyzing the root cause and  working on a
> > reproducible PoC. We will provide further updates in this thread as
> > soon as we have more information.

Yeah more details like a known-good kernel version, or even better a
reproducer, would certainly help a lot.

> >
> > Best regards,
> > Longxing Li
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > https://drive.google.com/file/d/1Bx2unEf-QntjVi8g6Zw7QNO6OP4cjGO_/view?=
usp=3Ddrive_link
> >
> > https://drive.google.com/file/d/16xzUrwOvwE67cnMPH3AhhNRWq6hr26Qj/view?=
usp=3Ddrive_link
>
> + Kanchana, who last worked on this piece of code

