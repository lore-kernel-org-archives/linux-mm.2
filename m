Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5732FC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 18:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DC3C6B0088; Fri, 25 Sep 2026 14:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98DE96B008A; Fri, 25 Sep 2026 14:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87E746B008C; Fri, 25 Sep 2026 14:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64CC46B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:24:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D41A2160635
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:24:54 +0000 (UTC)
X-FDA: 85253110908.02.5772A89
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf08.hostedemail.com (Postfix) with ESMTP id E732616000F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 18:24:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OJM4FCyR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790360692;
	b=Et+Yj7hrSiYtB95H82jvGaZ0YoIFWV4l+ofrb1yUkxKSFLoFEjxV1lJuCJP4K4pDx1PGST
	dmVyDoRE5SVLso09PeGD+ICHPioGeGXJQ2+bayAxOh57vi+n29ikbz6ORWBgL++huWsutB
	mHCwnkOMoMiVy72a09K7ClgnBwWcDOs=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OJM4FCyR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790360692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VuPCu0NVXXA8ZEi+lRFtiBIDXTK3MN9d4YX7eIhKxYs=;
	b=ugVCofKxgyEEmiJjtndmxcKFbsCGHsy3DQWQDJn6vjbYBnfl4qPHJfUjPUUaUhSUdK6vP5
	ylUFrxlZQTbBf5Bp0U6LczOjA96rRDqdU3cyy4G8hjF2WGI5nCUcda4Eo5+PG7bK6agMv/
	5nsUrof7SzxOaqsvJa7rXUN1cHgrXZY=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485933b24c3so764103f8f.0
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 11:24:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790360691; cv=none;
        d=google.com; s=arc-20260327;
        b=PDAd7uhgLzsSPISBqoOLa4uo8bB/UjxTcvpwUXgyQxllBnSVMp9wtnzfx6Tnf4dNT/
         V1ugPRoVQ8m8oQj7ahjI20ca030mPF2kUrQ1DHuJwyCuoBGGZNTqfyfbeXIe4DWd41GM
         ydlPJMgtc+nfpJsonvcZE98J6SgSbidXLst+lIX06TCOeeFwjNm6kN21/UZAA6+vbz3X
         oWtY4tx8KwtZV0q3nNc+E4aIytMc+glyZcLMJgiDvtYUeH0C7MZ4CMdhZWyhncbpCOxy
         ppNuzK3ctc1TA9pjmX9Rjq3fv78yMffwaXFGHXIjDX/P1w4eaV7H2OPECf7C3+nnNu3Q
         K57g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VuPCu0NVXXA8ZEi+lRFtiBIDXTK3MN9d4YX7eIhKxYs=;
        fh=fK6XDAut77WxO4pQblMmCM/n0MqP6dI8Tf0PFFyPOas=;
        b=fEa07gdR5UCqigx3P9IYGlCSSvf+7UDq8A6D2D7seVoD6jDONdxx4A0kMGxcwdzaWB
         PhR5YX0I6NPzTt/5zUiwdd4bvju7nQZCTfyMlBrdCOdeg2BzdcyCNYzUw/9kQvInLesg
         16rCjZQvdPrH5yrvaWXAYU9jQPleBx86yvGDWDBjLSSWou92F1zSs63EAGQH6P6KaN1B
         k3zU8EZbeLn4WH0Sc+i0pFmQdqOLpTa87kFE+s2CLAmn+rROG48DPhdKr1SSH7cfbDv+
         UM7aHqkf3PdklLp46jrvkfpgq7KMvpek2srubU8mZbwrj0DYSa4NKQT1IdtcVyvH5bhQ
         5RXQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790360691; x=1790965491; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VuPCu0NVXXA8ZEi+lRFtiBIDXTK3MN9d4YX7eIhKxYs=;
        b=OJM4FCyRkB86GKwHcbP0W7QrAGaYiZ+ZHhdCt6wx+ePe3wuGfvEyhaaXMU7bZ1k62K
         KlIknnvwfp2VEaBV0UTAIm5pfaG7pog/Veh4bkra50w/vKKUtYbkiQw0bjt36ZthWZZF
         EcvbI2Qb3qYVleVCyusWeU0Gs66oT9AaiPjewo5d5zlSedf4SWy0ctmDBjyRbAQ/7U6J
         FTD1+P/0U3gRwEX7VO6hWlJGfdijZoC97qXwMftcr6wU4jGKiWs/mrbaVDUdVVKxjfGE
         v/ApQGKeggoi0koTqRAObzrMS5egrY1fbq/0NWGLTpHfQ3YQ5fPYG9ndp8bTIG1jBL6U
         SeNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790360691; x=1790965491;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VuPCu0NVXXA8ZEi+lRFtiBIDXTK3MN9d4YX7eIhKxYs=;
        b=vSAsxUYyNVacjgsf76+EQPRYIUJ+GOrN03U49LS6p09eFHSF/MRz3Tvu/BnaTsLaGM
         8HRYno2lnhtVL2rXZAXwJ2HfLNr7OWZGloMvRMqDpxRQBFUn3PINuK3+Cfg71ebtCeO7
         wabm1vMNGgc7clQicB55JhCZfnWJAAqyOPDaXz9KbJpz7TYv1APqyCRbIfcRKLsdMvvr
         xncvvFEPR5uRBINQAa3yx/6kEd3qEK8YrrvmdyDvyq29T1aTrupKOyOUrsk73MHI/ae6
         YsBsGyNTmMYEo8mWp3a3gs8DJQBngKnmGGq2i0q3fFERvpqU9iAJtsr8CoTxJhUInE1g
         NeJw==
X-Forwarded-Encrypted: i=1; AKwUvBwVLBx1ySCm3YkpeYl+4U9O8hiE64ixHXap2M8YAuC9iB1csgegixFyHln8OmDVVYSIgeXCX/tw2A==@kvack.org
X-Gm-Message-State: AFuF++m8ng01S8MSy8OGpqHvBN9PyzA273lb05UbyEG/lioPr5FYZVrS
	61tKzI/sMrsP09vmBSeQl4ABoK8QpNKSdv2DQpUwydzNTZSnXPkFZ1zU1waGtlQJXSxoku6SNX3
	OsXxlxOj1GbqICIX3kepKgLRN8G80nZo=
X-Gm-Gg: AYBFou1CCV1Ox66tZrS+vMZzhtZ2ov2lfdKLsc5sFWT8KOkhjrJEcFB4HnHoJXm0yg1
	5xZ2Crb2S897vv6bdthV+rcM0SgnSVrP6mbr390YXPZrufRSwL8N2/8Hl1iRLFvLYdZSOJVreS7
	Y97N8CwQDnYgzea0VXIqRmZWPX1uQkmNPbF0tzevv4BCUJSL2AQaZxuwUFjn0rdzrt7tJNwYY8s
	/yur3w7bhdkDItEadc5rVOkPS36VS9xGzviz4bD+ZXqdu45uF8Zi2xb37hd68hQgDcuc7p68qVo
	4l4jw3XOYdqEIWTUiIYw2DTk8PbGRzyNrREf9X0x9lm4vQdRQwwQM6n5yHmncvY0yuLuCu0qbH3
	AhXW1ATHdZpo=
X-Received: by 2002:a05:6000:40da:b0:486:f907:ebec with SMTP id
 ffacd0b85a97d-488716f419cmr13910053f8f.31.1790360691287; Fri, 25 Sep 2026
 11:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
 <7571f005bca65aa4ad5e7ec89e62801ad058b689.camel@surriel.com> <CACePvbV-tazW=LmsbUtAhHzR2d6JwFT5R1jYZ9_NTp1hxXH=bw@mail.gmail.com>
In-Reply-To: <CACePvbV-tazW=LmsbUtAhHzR2d6JwFT5R1jYZ9_NTp1hxXH=bw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 25 Sep 2026 11:24:39 -0700
X-Gm-Features: AclHuK-nk61jbPKSQK9eOD-whCQNgC46gTK8mZrS59_h9wP0CK07WrJWS_RDZQc
Message-ID: <CAKEwX=NbD12FfApEb9g+3Gt_-Rmof0tovYZsxPPyk5TCbFq=Lw@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, akpm@linux-foundation.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: 6bmhosocunk54gxpyhr6x7gf4yw4sasn
X-Rspam-User: 
X-Rspamd-Queue-Id: E732616000F
X-HE-Tag: 1790360692-80261
X-HE-Meta: U2FsdGVkX19c35DGZgG4+7Vs98kVWUki+IK1spgVKa4SotleAHMXkTfyfeyfdefA7gdbinZypwL/9ZBCof0ogb8exjhlqNbWi0LqMKJWG2GlfVMmi6JveFbCBRKgQzHgaZHetyMXE8k9pDWCs5TF5gf+ZNY0ZkKoTZuat3l6FmfdS6Qkw6e+IiVEi/gqhXnDVXzlb2SWjK6DI4Zm/frBuAAShNVvZvTT6sz9pdfPfXuWlFsA1Rb5QlRmVi2uaLUpUhOrcrMCKOWFzilj9Qr030NPe8ILJrp4TlsZToeE1RWxH7Ihbbd5pqBGGx5eOAfzE2mb2zvICbUtNGIFXPVdLg2YqFiaOMpw4OErTcP7nxF5i8sv/9tUnXtFsrtTl2T0c682jRFqWB+ef5FgC10Qdfvekeijk2TzKDGJk86IY4KuxWfqln/IPIeeit/Hrl5qO8Nt/rkhzNvQtylBYa5krQGhchZo1Wh462ZqRzNkIWAVKq0xj/+a0Muf98zDnDvH8ZBzDKdc8Bsy9vA0FJRW44un+1eVUeuhdV+cSKp/liU1Zd4MCScNGv39WSTcnbvqo2Phh5XHO5p+vWmelI9mBImxp8ifu91EG7ykZKiX2wZoNDAu9IuV+nxI+Q9C5+CHyyPeLzRMvnfyCpgnVDmmgmKcaIKCV7PwuXwZqSHN3bgPY7M2/YDs0E0NfUxCDdJJH60dMqZ7leYmArphjHRCwELrh5ZvJ+Cg8tGZqPU87qnuuzb0cPSTpYKzIXUBryihbwy4cObUX/ADdbgg9QmpBUYqt2Vq/hR4+VSITt4txYoaLh5d2+U+RmC00Inp+IwJWmHvGf+vcaPpL9N0w4MlbXFDOtjCzCwEQFR4iDe/byJaLrhLyGI7G6KHy0NZm29zRY6wi9hxYDAWfvjLMIsDfcy1zngYgq3tki2ENu7Z2J5QsS4KhxtbI3w1nc1U0IGOsTnBs9H5SviT3ODYE4Z
 QCA+6Zzp
 6IGOJ9iMr7TFXOcIY1txHzD96/N6voK6XKZ2WdOvMzu4LcJRsS6+So+mqCFdnxrBaXUNlN+Nul34EuD5HKF4X7Ga46kU2e4PLPWPloEXRIlbzMRHhzDWR61qRLnLHZomCs0g6Tfxkxn1R+kaAZs8OvjPAWFoQa5YFh6LQF9ct7wL4Fd1NiLUXvL8PovcVMzC9urGQZUeOFUg1ZwdI+wVZxxoJH2byh2LQnd6R+3lH7Q7Fw/jg6c0/5AaZpLNkqFVOx+cbbN9iIY2zHfYW5mgxRL5TdPHVDBVji+311fn+XxL3kZMMKMjT6ruD8R7zG/9ZbS4ls4mgPYDJjqOQ9IAa+Sdp/0OeQataazFx/t05upGOYWOh0e1DacH1UO/zggg9djdwoldfsgGI9C/D0MS2QUr96zWvf3lHuu7JfC3mgbz4u8fopQJWkNF48SXu6mExAPJft85E85/4MyIl8k2Zd6VVMMCTvIBMUqq1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 6:17=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Thu, Sep 24, 2026 at 8:13=E2=80=AFAM Rik van Riel <riel@surriel.com> w=
rote:
>
> Yes, but it will pay the price for going through the unnecessary
> redirection layer always. It incurs performance and meta data
> overhead. That was one of my previous objections to the earlier vswap
> version. Sorry I enjoy micro optimization too much, that is both my
> strength and weakness.
>
> >
> > When everything in vswap, we don't need to test for it.
> >
> I've been there and done that, the result was pretty bad in those
> earlier series.
>
> > Handling the details of what's behind the vswap would
> > be handled one layer down.
> >
> > Chris, do you think that would be cleaner?
>
> If it can wrap below the swap_ops, it is just priviate inernal dedail
> of implementing its own indirections. That would be much cleaner. That
> is what I am trying to pitch to Nhat in prevoius email but does not
> have following actions.

Registering vswap's operation as into swap_ops isn't too hard. I
frankly don't see much wins to it for vswap itself, but it's not hard
to do if you like it.

What I'm disagreeing is treating it as "just another swap device". The
implementation shares a lot of swap device's machinery, so I have
don't mind adopting it, but you can't treat it like a normal swap
device, and expose it to userspace like one. You get issues with
allocations internally, and externally you give userspace a vector to
misconfigure with device priority.

That's why I've been insisting on what's the use case that motivates
these aspects of the interface that you're interested in. A pretty
design is not a real usecase, especially one that creates problems
with userspace misconfigurations.

