Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5508FCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 08:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9967E6B00AD; Sat, 23 Aug 2025 04:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F556B00BE; Sat, 23 Aug 2025 04:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB2F6B00C0; Sat, 23 Aug 2025 04:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE856B00AD
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 04:23:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 766A1B9D75
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 08:23:13 +0000 (UTC)
X-FDA: 83807332266.19.01378ED
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9875940005
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 08:23:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="WKchbwK/";
	spf=pass (imf12.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755937391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ECUzsLpIGLfSNANJzOpUlmNgO6Xf1gnfi/48aM/B14=;
	b=pHt4Vw3xLK/0u9pbVyEAIWHaHuqz+yjtCYsyI3y0WTvOK5jXqhpl4eS4LuisQtkVFrIuEf
	GIUrH4iPH4xMk2lrC44L8Zkdo2N5/5GfFWLvoI7T55X+obCMIBAYtpDK9uPIKPr+eGE8Ut
	3Zbqsl5bKEIcd8kFdA0HmGDL9DwDNXQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755937391; a=rsa-sha256;
	cv=none;
	b=FiM6b1caYmGRz+uuihczaSvh03fEzRIJ7LHrbP8BO0sxiPh4+L0FYkBmttupzUcqD0oAyC
	Bf26LGXZ2d79cwuzHz1r0aeayXzfcBdZUDpEXwZJiZnlc2Hqr+GvAY9UYKyxIGNXdNYRD6
	qCy2McaN9vddy5vWUx/df+JfzfaO4IM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="WKchbwK/";
	spf=pass (imf12.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-71d6059643eso22368777b3.3
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 01:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755937388; x=1756542188; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ECUzsLpIGLfSNANJzOpUlmNgO6Xf1gnfi/48aM/B14=;
        b=WKchbwK/9f92Ksf1VyEYiF/2Tqj4zDNrqd17jG134zMPnE8wE+wTSeca6TuSBGu3+P
         DhJtxpHsjuMBnLoJduFM0QfpbL/Mb1etFBtpGru3LXAq0IitTL9PWThQSTEDWY+Ut72L
         e1y2wqcWrZC5EEcLieptMTO0JVNG8zEp/3/KKeTtUR6Q1mO+D6yoqnHYKo6z5wr/bEH6
         ib6iOjVdOZ+qx6l+OehemaP4orjwAfm6W6U4MzvOYh89PRTFc9Ul4KBRb7FTFa/RWllx
         yvSTRc3ADBdHDoihpBHZr+llu+OBJLplcWLT4QbPFyfI+SoblAgw7TJLUoMuMYp18+7L
         uraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755937388; x=1756542188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ECUzsLpIGLfSNANJzOpUlmNgO6Xf1gnfi/48aM/B14=;
        b=s+F4KVUzewehDdVgvS7di0hOddLEqWXpZ3IQCcCC3f7qy3WTLtCgix9MZD8KirjzEY
         oiW2i2hQASYzn0E5wtgyWh6lEIYAI3Vf/RY0H4hK1cxl9eT6K3B8N0aHOzHuGj3R7T9p
         wEsZOF9C/Wk75on1ik4lvRdv+wVzwJA9Vv+wW8AI7atuoE4YSTGSEhqSfHRTMmDpwjXP
         5smzUEp46qdNqBr5KF465f6OYtdcEUQiG2tcRqTBY5arhQMDfYJ3ix5DXkibmf1i0/zM
         mdu8Bz721ikplRHnlRV/sGRQlfkKd2faLFrxsKbmhHoNcb3HznPFW7cu5rrwjL5WX3Bk
         Arfw==
X-Forwarded-Encrypted: i=1; AJvYcCUoxofde7yKyVP0Lhkg8Hk09MfcSrrT1J/wRhZ8Gf7VY6x3ArokzshHzwLfY+mrPtWc11IwbTwGFQ==@kvack.org
X-Gm-Message-State: AOJu0YwGXulOF74+H+QZpRBmJBtwvZYyNxQ8+sGb23HwNwAns/6gHcj9
	Gdy4Vzqrqk+c4MXlZW0hTBzTRAM0FYQ59dz3VU+lbFjZU/fHLOe1+bIeHq8tJQPcUb7rYAjlZSL
	Hjy/Dk7terhtQyvNa0FSpfDcwnCztKcR8UZ3UW3VNTg==
X-Gm-Gg: ASbGncve6QMBYZoyTMjJBbs/8HcN0/nmOOp87oxCoBFFV1Geiz0W6gpyvhDPGC2ss2N
	vR/v9SrIkgN5iFcPM/w1FSAAaUQA8XbovnE7Bg/2NYnjrIAghm1O4IpmbZEj/mFkBwDTBKkebOB
	31gfX3ZQMTU4trqo3mMHHx8pnE7Y0TtNguFbQ8VBe31r3KFfw3Daq+B8YRSKTEqoGVOpTHAcO3C
	3S1VCD9btQM
X-Google-Smtp-Source: AGHT+IH0BVIyZiw5bWrCKqslz5gV80c6AufAKs2rnSguLnlMSKmrPRYkojH4j4/wRFQ/wNMvYf2Fi3seu0hZ9/B27eE=
X-Received: by 2002:a05:690c:4c09:b0:719:f37e:e69c with SMTP id
 00721157ae682-71fdc421889mr66924497b3.36.1755937388335; Sat, 23 Aug 2025
 01:23:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAHSKhtebXWE5m0RcesWe_w2z1Gpqt1n5X0wuE9oD1tX6VxztUg@mail.gmail.com>
 <76a95839-00b1-43b8-af78-af4da8a2941c@gmail.com>
In-Reply-To: <76a95839-00b1-43b8-af78-af4da8a2941c@gmail.com>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Sat, 23 Aug 2025 16:22:57 +0800
X-Gm-Features: Ac12FXyXLbqkgSJ552CB_VB52RDuHyiA8g2c5o9dPYHcJpfZiX_QPTNVRfVvNBQ
Message-ID: <CAHSKhtd_oM8yXBwgm1-6FGhDEaDGCWunohMnb4AtV8Y-__z-zg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
To: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Cc: axboe@kernel.dk, brauner@kernel.org, cgroups@vger.kernel.org, 
	hannes@cmpxchg.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, tj@kernel.org, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9875940005
X-Stat-Signature: 5hoghugn9z59ak3gjrtcpnx7db7fj97k
X-Rspam-User: 
X-HE-Tag: 1755937390-872118
X-HE-Meta: U2FsdGVkX19E8ksdqOUSMjGSxqvNIb5+40R+Rz/Kzhkcpq6UpjLCELbNvPtaAugcYiw88LyUBtzkzHSnaOOC6PREuSET13elmwngis9gmHhAqo6qSjJM8jdhXJXEGnU3CnHDXqIpT4INT5TAUg5dg53uExzBrPQ5Y61au1Y8WU3GvgQayPiNAfIDAqIgbLlny1gr7WBrPVw2SEUimOofxk/RRBXgKEsKiqrtcPrz/9P71kRs/8uYHEA56BsYAGYORgRy+YM2PMFQwe/mKJkQKKFzjxzbgbUhDE9e+bwUizOYb/AJHYmy4SiFC1Ob8SPQrgdrW5HQdqL/gj52YidUGApT+DvtjoIeBUGqSrgMhb4NCB6HJg/McC5fcosxBeOiI9hLdnMvfMSae34jMwY0L+qvKSSV6KbSNAGv/4dZkgrVndHZCrern5FeMvbMDaqEN9FVqUXzkdb8PtoF0eG5CAx03Vn4Kf4AgdynMMwBt0v1oAiQ7q/OXjrlACVLOA/j2O3mHhwHUeYQFzNofAPJP/SC4aMyZ1zAFTL2W7Rt1to8qdBLdCScHXL/9azYrzz2J+HWPyCxAS/rw2/xL4/Hu7A8cjVV2oyqT6TV02a3COx3hTOioJSs0Hck3DoMLyUEwLhmadTi+Jl6++8DZWewZQow+HLVNKKIhKDA99ctTgu/Qj3G5BBT5cWoVirI1usXy6WaUqtFpE0a9oXnBZZ87L3YaTtBzhICAkq/vM1Xrg2Tgcm7/Zw5yY4VpKJ1tUGOGYTlzeVv7DS4BhKHJGG8wzlD2PuYrNSXe5M2SAmifAa2hTGzB2zLziiYVzj2jNziDvnI9dlzaq0YdqzVMTev3kXdq1m83IYfE219Ro/dZ8prQHUWjAxtMzxFOpw8IjWMskuEzjnnEZL4oPN/5pYubG8BwEp1qUOVeqW9pd5rjhDJwYhYJ77Z2rdzxWfZLaoZC8bn9VfsGrLhvLS90wl
 xYjo4FSs
 7yAju+vmFNoFQGlAGix3N1+Malrh2z0DHeCRwQN/TBEiMH1JHtEhWGSSK6SxC23Nl5g8Ze6MTTWn0EMSF3FbLSierT8UzDgbhb8WFrGR8viyEaHx/oOznv4kEarX2YXkFgEUqMUYbo+jlBpzZY59C00iEjAqd+ChjwWfRqPHVeK/9Ei6KDhYQUm5ApLSZ2kcxx9HXLRdZRK+Tj3QPG/+J4vfRu31YOqgjJXJcsQpaOOeCtJOstSzg37JcFr7dXDPk45LgMhXo60NryNPxBM5DRu3G7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sat, Aug 23, 2025 at 4:08=E2=80=AFPM Giorgi Tchankvetadze
<giorgitchankvetadze1997@gmail.com> wrote:
>
> Hi there. Can we fix this by allowing callers to set work->done =3D NULL
> when no completion is desired?

No, we can't do that. Because cgwb_frn needs to track the state of wb
work by work->done.cnt, if we set work->done =3D Null, then we can not
know whether the wb work finished or not. See
mem_cgroup_track_foreign_dirty_slowpath() and
mem_cgroup_flush_foreign() for details.

> The already-existing "if (done)" check in finish_writeback_work()
> already provides the necessary protection, so the change is purely
> mechanical.
>
>
>
> On 8/23/2025 10:18 AM, Julian Sun wrote:
> > Hi,
> >
> > On Sat, Aug 23, 2025 at 1:56=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote=
:
> >> > Hello, > > On Fri, Aug 22, 2025 at 04:22:09PM +0800, Julian Sun
> > wrote: > > +struct wb_wait_queue_head { > > + wait_queue_head_t waitq; =
>
> >  > + wb_wait_wakeup_func_t wb_wakeup_func; > > +}; > > wait_queue_head_=
t
> > itself already allows overriding the wakeup function. > Please look for
> > init_wait_func() usages in the tree. Hopefully, that should > contain
> > the changes within memcg.
> > Well... Yes, I checked this function before, but it can't do the same
> > thing as in the previous email. There are some differences=E2=80=94plea=
se
> > check the code in the last email.
> >
> > First, let's clarify: the key point here is that if we want to remove
> > wb_wait_for_completion() and avoid self-freeing, we must not access
> > "done" in finish_writeback_work(), otherwise it will cause a UAF.
> > However, init_wait_func() can't achieve this. Of course, I also admit
> > that the method in the previous email seems a bit odd.
> >
> > To summarize again, the root causes of the problem here are:
> > 1. When memcg is released, it calls wb_wait_for_completion() to
> > prevent UAF, which is completely unnecessary=E2=80=94cgwb_frn only need=
s to
> > issue wb work and no need to wait writeback finished.
> > 2. The current finish_writeback_work() will definitely dereference
> > "done", which may lead to UAF.
> >
> > Essentially, cgwb_frn introduces a new scenario where no wake-up is
> > needed. Therefore, we just need to make finish_writeback_work() not
> > dereference "done" and not wake up the waiting thread. However, this
> > cannot keep the modifications within memcg...
> >
> > Please correct me if my understanding is incorrect.
> >> > Thanks. > > -- > tejun
> >
> > Thanks,
> > --
> > Julian Sun <sunjunchao@bytedance.com>
> >
>
>
> > Hi,
> >
> > On Sat, Aug 23, 2025 at 1:56=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote=
:
> >> > Hello, > > On Fri, Aug 22, 2025 at 04:22:09PM +0800, Julian Sun
> > wrote: > > +struct wb_wait_queue_head { > > + wait_queue_head_t waitq; =
>
> >  > + wb_wait_wakeup_func_t wb_wakeup_func; > > +}; > > wait_queue_head_=
t
> > itself already allows overriding the wakeup function. > Please look for
> > init_wait_func() usages in the tree. Hopefully, that should > contain
> > the changes within memcg.
> > Well... Yes, I checked this function before, but it can't do the same
> > thing as in the previous email. There are some differences=E2=80=94plea=
se
> > check the code in the last email.
> >
> > First, let's clarify: the key point here is that if we want to remove
> > wb_wait_for_completion() and avoid self-freeing, we must not access
> > "done" in finish_writeback_work(), otherwise it will cause a UAF.
> > However, init_wait_func() can't achieve this. Of course, I also admit
> > that the method in the previous email seems a bit odd.
> >
> > To summarize again, the root causes of the problem here are:
> > 1. When memcg is released, it calls wb_wait_for_completion() to
> > prevent UAF, which is completely unnecessary=E2=80=94cgwb_frn only need=
s to
> > issue wb work and no need to wait writeback finished.
> > 2. The current finish_writeback_work() will definitely dereference
> > "done", which may lead to UAF.
> >
> > Essentially, cgwb_frn introduces a new scenario where no wake-up is
> > needed. Therefore, we just need to make finish_writeback_work() not
> > dereference "done" and not wake up the waiting thread. However, this
> > cannot keep the modifications within memcg...
> >
> > Please correct me if my understanding is incorrect.
> >> > Thanks. > > -- > tejun
> >
> > Thanks,
> > --
> > Julian Sun <sunjunchao@bytedance.com>
> >
>
>

Thanks,
--=20
Julian Sun <sunjunchao@bytedance.com>

