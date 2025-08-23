Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32F68CA0EED
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 15:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 154406B00B4; Sat, 23 Aug 2025 11:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12BEF6B00B5; Sat, 23 Aug 2025 11:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 019D56B00B7; Sat, 23 Aug 2025 11:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1E136B00B4
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 11:17:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36D91139279
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 15:17:34 +0000 (UTC)
X-FDA: 83808376428.21.DD78E6D
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id D3904C0005
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 15:17:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GaxgiJzq;
	spf=pass (imf10.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.176 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755962252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GuRxDgISxpxh2GnvxFHQaLERLGxx6pa9QJkvdj6dXFA=;
	b=z7yhPBeGHbfcdlRbn2Vaf9zgzaAo5M6YjKFYw6iKuprw4qK5EYZhDwkQmEIUTJmoYvGtLx
	lrl68EnthTt4Ppn+XgwHqnMER61WkT9HjfW5aTheddU7maxDeMh2ETovgju4XEfjEUxbgQ
	595x/WlgwxYn5dJw3vDIunula3NN9h4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755962252; a=rsa-sha256;
	cv=none;
	b=eT/sa1WyCwSX8l+VJvaeDkBcacbKdw9O5qyPOAKtJ4Xcxhx5bp0JKGBTI79j4WPPhT8aue
	iLRa1nvIAWTaXs4q38/RSCe6p/QolNt+rN6a71Js7FjtIXsvlfUykBfNavHGYcmxuwtN8S
	hXGeSIFUSex+vaUROGkZHlmHfp+l+/k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GaxgiJzq;
	spf=pass (imf10.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.176 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e9526271af9so1054050276.3
        for <linux-mm@kvack.org>; Sat, 23 Aug 2025 08:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755962251; x=1756567051; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GuRxDgISxpxh2GnvxFHQaLERLGxx6pa9QJkvdj6dXFA=;
        b=GaxgiJzqN07hctDSshzJOzXoy70vlxkaNVye6jEP5uGD6YPmdB5KVOiiCnsrlob/9k
         s2esJNFD3+sUDxNWd2L0liR5j0be3c/wXaRWtEQ/E1/xpb7yHS2doT3PI98GUHQo0/dy
         bNCI/lj/2FCbxaJuMWHggNmHoRWCKTvBjiMy8BgXCz2uh0QBcqxXEOnXh6bZ/fN6oS8u
         iNfZOHxzSfgxlu3wM25xpLE1fYWvpv6zOv9l2bPmPvNflcD/2dQRcVcA8+y6sbzRWm+0
         vbg0TGRXlm0CEbCuqV/5h+rbYkDDzEiSvMSHvIlZP1vPspnEki4X0hK65yvcrnZjMHJh
         sjow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755962251; x=1756567051;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GuRxDgISxpxh2GnvxFHQaLERLGxx6pa9QJkvdj6dXFA=;
        b=eoDILyBmx2vV346xww0r3t3PTF5VtvqCGwpXVjH47Z8GbU9ZMMuqdSN0ZPBA+NTLnR
         z24sRYOMhgdcIN325bvUG+2xN0A6uw61NHrnLguPjfeavJZ8wjkDQPaZb4UVyMtmlDTW
         JHqWQyf+QJ9wPSgoRbel7DjDAVU3Cg11k8ffS05gD+llpnpWj04XfGiiPhQDEQrvEGu0
         YXaCUnZ60axgg2gv62XvqlDv9EiJnOBysBbAnvqFE4EJvE5gAgwmnV1wVXtON1OPiY7L
         NzsAR8/r/r69M2gZtwWENm1xu8/9xWtCxnRToEhJJ+qhJunj7yUhDrAtQOenNz71N92n
         887w==
X-Forwarded-Encrypted: i=1; AJvYcCVvI7LAqbyjNwAVpEIXf/lX1veQzrgmGAw1PD7Kv0QTEJZrdrXQwSpNC0UW1I1wgOXbomjQW4sOzA==@kvack.org
X-Gm-Message-State: AOJu0YwrK6qW+Nu8dNmLRdSM3c0xqsuHj/O0eNLjO9e3vAS6qIp7P/Xm
	wt/SdLeMVLBOX4fJVSy8fQkKOxbEMXDUD1p/d+sLgkC/F4cKcAv6fYTcLTy1U400PTrlOky1fj7
	o98HJLsgduZhBq8vm4Al6dPxjR+EkfhUhOxmJQTcR+Q==
X-Gm-Gg: ASbGncs8zqFW/w7uYkODLi6X2XitZvwH6tM/e5yWKpaEVfSCloYcD/QtUjRsG6UOsMs
	0WmowNQ6N0rzBIPI7a1qQM1ma52tY2L95J+bWzocsi5GTCiyAh+2jgKVVTyxFGlhHZCN/sAeZ8i
	DHUlYNt2V5cKjn+tANb2/vI6TluyCrK3OaghF9/kSY+zQbafHtlJoecNrKGu0/dEjIMZTw39MFk
	c47rJmoAuAn
X-Google-Smtp-Source: AGHT+IGfmqDZeqPR9mSevC/rcJ40kyyYwYfMlgm7zFyEEtXeFJRkcrNU7yLh0iiiwELRzs/EafzpuCacOFikh66vbYo=
X-Received: by 2002:a05:690c:6102:b0:71f:f866:bba4 with SMTP id
 00721157ae682-71ff866f374mr19817227b3.17.1755962250487; Sat, 23 Aug 2025
 08:17:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAHSKhtd_oM8yXBwgm1-6FGhDEaDGCWunohMnb4AtV8Y-__z-zg@mail.gmail.com>
 <a3f9e0fd-28fd-41ea-9c78-e3c971e7445c@gmail.com>
In-Reply-To: <a3f9e0fd-28fd-41ea-9c78-e3c971e7445c@gmail.com>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Sat, 23 Aug 2025 23:17:19 +0800
X-Gm-Features: Ac12FXwWa1i1Z_eWULAcABG_D4uLHUyCsSFkbKNqIneaeOcJBr_iJqr2a3VgmDw
Message-ID: <CAHSKhtewVTFTsfnLQwjJeaqg950Rn-_Jde5pQq8knoJaX=XsLQ@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D3904C0005
X-Stat-Signature: fqb1zqxym8eq46epc94n5no88mihkjbe
X-HE-Tag: 1755962251-989658
X-HE-Meta: U2FsdGVkX19R0fd453LX4yYGyieHjkM7iq19N+pLSHhy+YASKdwO91FLj8uNaDKmeI8Ng+PY1aQdD6V59CSDmVOATdoZT7CE9G6j63EdanQUZ1LsC5rCYy5VcMDcKRvCLDAFVt+cVgdS3BrqNBvVa+VTiw0Y2YWYhS2QtJQ/y1AvYFSsrD3PEkm8L2o3bc5gJBvlVOBsA2zrHAWGlBCkH58MmCQEib4ar8rXFLedkL2ypTNnev/KqvJC+Z4ZTHGerGeINfxX3AqpADHvDRROT/5Cy90ugpTnVtH7CHctyXBtDP3nXo2LYNR5WieWieBeoTDhnFRKtddFZdEKyQR0jguS8mGn+94necmr9PVNo4E++XadgBB3HiyaNaoR52fDgRvbrDsYMdRvwQJAvxVtCwcOTJXmXTnmZ6gCT8FNJ2WdGtOTy33jjPrbVDG+eWgCAS6h3SujJDjxEmFMGAG7ZBXUS3WpcLQa+jevNesNGO7UwjYqCu4ZdqbWcPs4qMsf724IUJVkxu9dJOcIn/QeRyTCCty/Gneoi1+zUEKZp3BL2tp94IsROpNDshUcSa8s1IYTVkb7mZ8acQwxcfKXYx5ZF9vfVLrteHq18fm/wr47IgqwpXX5CWghH+BsGlHIYOmyV21r8zY48rHSbwFXy4/kV8o0uVc8ekf8FzDqXoXK2S5Vd4LZHySWADZpEZ3FV9YIK1VDi4fobea3uG8xkLQLHYHmCDULs+nk0eP/P8FQEV1TqmR+sfrdgbf3SDh6wip7b+4TXMAHO+5ugOl7X6Q/TT2KvXAyVaPhDO7kRYrRD+NfRK8IgahkOsIm9cV6bE7Oqou0evihJ/QzrKW3/QD3wmOiUFDAqCnsptPqE2HQ5byqlD4NKsnK1SgTzOZaTEzoPpciCeY04PdU3Sns0eA4uvHopIV471Aadh5CxgR48K7k/MJ8P5U76428pARdwx6iG7aqOZgg2aPNGNU
 Uz4wzVax
 lBV5mcDgPMHGHojYr7kz76UAK40gdhyu3hqRcy1wdgOc39XaZpRHGVHKeCcSK+bapToPvBLd0D4m16UfBwlIWVWkbqX3r3S6uu9vPcYK5vXWaiGxbtwh3nwnP2Gp70FlRz4irF2PEaQJkRFuLkZFqDveebaHLlQeJSNoUqxIL80WZlpsX4OUn4tKx6yoq8lK9McZcy7R+y1UvRiWQP1hrEe2e6KREabXxZRBlGwl29GMeN6UfBW39Tlm4GR9JA9CIgy++YOaa9QZdUJGa6bJNwSXXFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sat, Aug 23, 2025 at 10:09=E2=80=AFPM Giorgi Tchankvetadze
<giorgitchankvetadze1997@gmail.com> wrote:
>
> Makes sense, yeah. What about using a shared, long-lived completion
> object (done_acc) inside cgwb_frn. All writeback jobs point to this same
> object via work->done =3D &frn->done_acc.

Well, IMO there's still no method to know which work has finished and
which hasn't. All we know is whether all the work has finished or not,
isn't it?
>
> On 8/23/2025 12:23 PM, Julian Sun wrote:
> > Hi,
> >
> > On Sat, Aug 23, 2025 at 4:08=E2=80=AFPM Giorgi Tchankvetadze
> > <giorgitchankvetadze1997@gmail.com> wrote:
> >> > Hi there. Can we fix this by allowing callers to set work->done =3D
> > NULL > when no completion is desired?
> > No, we can't do that. Because cgwb_frn needs to track the state of wb
> > work by work->done.cnt, if we set work->done =3D Null, then we can not
> > know whether the wb work finished or not. See
> > mem_cgroup_track_foreign_dirty_slowpath() and
> > mem_cgroup_flush_foreign() for details.
> >
> >> The already-existing "if (done)" check in finish_writeback_work() > al=
ready provides the necessary protection, so the change is purely >
> > mechanical. > > > > On 8/23/2025 10:18 AM, Julian Sun wrote: > > Hi, > =
>
> >  > > On Sat, Aug 23, 2025 at 1:56=E2=80=AFAM Tejun Heo <tj@kernel.org> =
wrote: >
> >  >> > Hello, > > On Fri, Aug 22, 2025 at 04:22:09PM +0800, Julian Sun >
> >  > wrote: > > +struct wb_wait_queue_head { > > + wait_queue_head_t
> > waitq; > > > > + wb_wait_wakeup_func_t wb_wakeup_func; > > +}; > >
> > wait_queue_head_t > > itself already allows overriding the wakeup
> > function. > Please look for > > init_wait_func() usages in the tree.
> > Hopefully, that should > contain > > the changes within memcg. > >
> > Well... Yes, I checked this function before, but it can't do the same >
> >  > thing as in the previous email. There are some differences=E2=80=94p=
lease > >
> > check the code in the last email. > > > > First, let's clarify: the key
> > point here is that if we want to remove > > wb_wait_for_completion() an=
d
> > avoid self-freeing, we must not access > > "done" in
> > finish_writeback_work(), otherwise it will cause a UAF. > > However,
> > init_wait_func() can't achieve this. Of course, I also admit > > that
> > the method in the previous email seems a bit odd. > > > > To summarize
> > again, the root causes of the problem here are: > > 1. When memcg is
> > released, it calls wb_wait_for_completion() to > > prevent UAF, which i=
s
> > completely unnecessary=E2=80=94cgwb_frn only needs to > > issue wb work=
 and no
> > need to wait writeback finished. > > 2. The current
> > finish_writeback_work() will definitely dereference > > "done", which
> > may lead to UAF. > > > > Essentially, cgwb_frn introduces a new scenari=
o
> > where no wake-up is > > needed. Therefore, we just need to make
> > finish_writeback_work() not > > dereference "done" and not wake up the
> > waiting thread. However, this > > cannot keep the modifications within
> > memcg... > > > > Please correct me if my understanding is incorrect. >
> >  >> > Thanks. > > -- > tejun > > > > Thanks, > > -- > > Julian Sun
> > <sunjunchao@bytedance.com> > > > > > > Hi, > > > > On Sat, Aug 23, 2025
> > at 1:56=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote: > >> > Hello, > > O=
n Fri,
> > Aug 22, 2025 at 04:22:09PM +0800, Julian Sun > > wrote: > > +struct
> > wb_wait_queue_head { > > + wait_queue_head_t waitq; > > > > +
> > wb_wait_wakeup_func_t wb_wakeup_func; > > +}; > > wait_queue_head_t > >
> > itself already allows overriding the wakeup function. > Please look for
> >  > > init_wait_func() usages in the tree. Hopefully, that should >
> > contain > > the changes within memcg. > > Well... Yes, I checked this
> > function before, but it can't do the same > > thing as in the previous
> > email. There are some differences=E2=80=94please > > check the code in =
the last
> > email. > > > > First, let's clarify: the key point here is that if we
> > want to remove > > wb_wait_for_completion() and avoid self-freeing, we
> > must not access > > "done" in finish_writeback_work(), otherwise it wil=
l
> > cause a UAF. > > However, init_wait_func() can't achieve this. Of
> > course, I also admit > > that the method in the previous email seems a
> > bit odd. > > > > To summarize again, the root causes of the problem her=
e
> > are: > > 1. When memcg is released, it calls wb_wait_for_completion() t=
o
> >  > > prevent UAF, which is completely unnecessary=E2=80=94cgwb_frn only=
 needs to
> >  > > issue wb work and no need to wait writeback finished. > > 2. The
> > current finish_writeback_work() will definitely dereference > > "done",
> > which may lead to UAF. > > > > Essentially, cgwb_frn introduces a new
> > scenario where no wake-up is > > needed. Therefore, we just need to mak=
e
> > finish_writeback_work() not > > dereference "done" and not wake up the
> > waiting thread. However, this > > cannot keep the modifications within
> > memcg... > > > > Please correct me if my understanding is incorrect. >
> >  >> > Thanks. > > -- > tejun > > > > Thanks, > > -- > > Julian Sun
> > <sunjunchao@bytedance.com> > > > >
> > Thanks,
> > --
> > Julian Sun <sunjunchao@bytedance.com>
> >
>

Thanks,
--=20
Julian Sun <sunjunchao@bytedance.com>

