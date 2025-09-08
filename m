Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C86CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 19:55:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DF18E000B; Mon,  8 Sep 2025 15:55:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945AA8E0001; Mon,  8 Sep 2025 15:55:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882618E000B; Mon,  8 Sep 2025 15:55:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A3668E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:55:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 238B41A0293
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:55:39 +0000 (UTC)
X-FDA: 83867137998.07.6830AFA
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3A62E18000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:55:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XNWgsIPt;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757361337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tmr9R0O7RWkWQ6LWG3LXCf5yq/w4BQPFAFSdkpU6lPU=;
	b=bT6tApBsLWzHcGw0kAjg2r3pxwNWj00kX/yLkN7jSC9k6kw1rBDsEneCDL5cBfi3uITf4v
	xEQEGwAtTa7eTqI3wCvxMhhAZGZxNmh+3JzKxk4dsG1wBnUHZi/M5dZvBDxInnHSl78eK4
	/OW1W4OljMxrtkCuYCIyjqaqQay8BOw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XNWgsIPt;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757361337; a=rsa-sha256;
	cv=none;
	b=2tl+xk3FrKq5sO4zVimIYsbPoqff/EaguvdnpDgmgJdZpL/2himmcznAm+7sWq2t4N8NUA
	z1qtwTJWpV+dsGcxLRlaVBD2EYhwWOkfumclvNNBOQ6NyOIzTkqEmvJkD0sHyDJeHs4FYJ
	GlOUKUmTZlcx/1pkbw3zlHI1m5FBg5U=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b5d6ce4ed7so978501cf.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 12:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757361336; x=1757966136; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tmr9R0O7RWkWQ6LWG3LXCf5yq/w4BQPFAFSdkpU6lPU=;
        b=XNWgsIPtslzssg5sJcxMFOwt5TInPTPDBqthSuslvyHjpUzRzuxP6ebCJJi7DfCD6p
         iDFa0PRrJUYRA9HeigN0TxCzbTzkVxM1iJW3hp49ctUFQNfAKtEjYGq6ELz5I+f1NMct
         r+U4crWpaznxWs2vF8DmY8blAtJqUuQR2NR8Cl+XeCsWP/S2D6H+aQPFScwIC/j3o8Wf
         ZgmACtTheUacbmv8mZu5vl0A9YT+VJ0KN4ykHD4Wl89zK4y4epNU6ckb09GeTIxDLOpu
         5PWvk1JwK9XHK79Y9MUrE7S7c2jqA4fulDAXnW9gyzdpG2Gk3pfwSCsChhKmIl0FIbUu
         AhPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757361336; x=1757966136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tmr9R0O7RWkWQ6LWG3LXCf5yq/w4BQPFAFSdkpU6lPU=;
        b=azLHopBpqM5IeZVTCwFaIx+R6FNTzwr3JcJE2OWEKvIe7ImhEFesI/nSisj1BI7bOB
         Xpkyk4GZNXCuKPDagPnUAucCthV2hajWRph3o8BPlID6axYgbhcH++bfvB8e5BQDeXJY
         KP+1zGnE+UjVwDmDFjnTEcZzr9Mj6xokaMbW/RXUaAImr4DOVrFqqTXj/89qWDtfGsjb
         Q9vhnPouQ8N41FGt+KR/02nQr7GROMqJ0kMO6It4jLAGC+gSjHAiVW1Fc2Bhw6rG886O
         xYZhFh07PehBFzchT39XB54GPYIc9QF87wjaj84Ws9pKwYXgX/5+w352XQFfqGP2Xy0G
         EfDA==
X-Forwarded-Encrypted: i=1; AJvYcCVAz0E1ZBki5Y0QWDh7Zv3TWAEIhb+bfFxcyFVMyNmt4/MfheEuJAfvInaP4fxGRn5XZR7ux+jaCg==@kvack.org
X-Gm-Message-State: AOJu0YwkJSGR38xgel8I4zk0wU3evuDW8GC90+/9u8oAjfEP30Ka7zps
	WxJMwti0gdJ2VxsarxS8nvgUnw/1WBG5B3mnMd18RR7cjrZcpb1h9l9Rbr4AyZVkcJNTYJdk/Mh
	EjG+vY7bUL8rNpehigSWKe4ln8p+GRCm19tluNqv3
X-Gm-Gg: ASbGnct7fSYUnzLPqc/KITfwYbGTy/o4AD7113mhlcNZX2081G6y3dzDBt6VsQJwJZl
	uFv4X5FK3dei6VAhFCs4CkJRQsAtLIe5nBt+ofsRlH8ET1t+sgfU3lGlrCY8qtjtxPvYe3wzCSC
	cE6c0CCvM2JhY48nvJkDFPPvpZgf6i8vic0ykGTLVLNSEAVTFtUnZOfV5CtScK21saJw0Q9PVm3
	PgCwA==
X-Google-Smtp-Source: AGHT+IFht5pppNMMGMtPH/agZlekP76+Bq9kz9lTs1Z+7HZ8Zxgz+fKXs2YuHK6UPaXwGsTfuhgnxU+LcWW0vB3VTXg=
X-Received: by 2002:a05:622a:3d3:b0:4b3:4ed0:c6f6 with SMTP id
 d75a77b69052e-4b5f6f80a58mr13347131cf.16.1757361335849; Mon, 08 Sep 2025
 12:55:35 -0700 (PDT)
MIME-Version: 1.0
References: <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com> <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
 <aK2/Vesgr9Xcl5gy@devbig569.cln6.facebook.com> <CAJuCfpHJMSd16j3ANrtJGVfLieHdeO_Epq=U9OKty3TV362ckQ@mail.gmail.com>
 <aLFKHGe2loD657fu@tiehlicka> <zerazodfo2uu5az4s6vuwsgnk7esgjptygh5kdgxnb74o2lzjm@fkziy4ggxrxc>
 <CAJuCfpFynEuwBSu28UiRDjWrayN-raX4Nqqh283MwRoJLi8bMQ@mail.gmail.com>
 <uoyjzkybkqd3wkvauofmorv72gnjisoq3owvijsezpt3wbrazz@at562ngtvszd>
 <CAJuCfpG17E_yoZeqEDrN0PFn8UBKqiGT28KDwEDmBm6byFje-Q@mail.gmail.com> <cca3gvk5gco6i2vbjvtarmi77imgj5y64kqb7bebcrbjagdwca@4p6zq4iaiqr6>
In-Reply-To: <cca3gvk5gco6i2vbjvtarmi77imgj5y64kqb7bebcrbjagdwca@4p6zq4iaiqr6>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 8 Sep 2025 12:55:24 -0700
X-Gm-Features: AS18NWA5R6z4os11O0uAZbscD0giAOrKc3pAZnMY5I0U-VPDOAWS3MM6jGMGM2E
Message-ID: <CAJuCfpE-dTF_TRJkSffTxtD_P8A10MJUOHd83xBg4B7ATknGGA@mail.gmail.com>
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Michal Hocko <mhocko@suse.com>, 
	Yueyang Pan <pyyjason@gmail.com>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Sourav Panda <souravpanda@google.com>, 
	Pasha Tatashin <tatashin@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5mgo17bq3pprjgemjnhrptw1jirs1wgz
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A62E18000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1757361337-120402
X-HE-Meta: U2FsdGVkX18FEKFuWUjMWt55+L+VCBA1+1yzorvYp+J03YdTdaOmtLMyFhmJRX9tpemzvlFIVtWcL+wqhuxUBhb1T6g56TK3S9aNE0toc8BThJWSzPH/QTlAS4ZMeBq7e7d5Kzl/IHM/fxyGjnispNAzDd81YurxjwmJg0X0deTIoy38ccOKRb+/S6cEKOTChPpSvBTP8mFs5JAReJXz/1Q2toode1H8poWHp/XFzm7qvT5akWH2I5Yeyioi+kPCJBrsM1Mm9oLbFbijXQ1fc11HGKQRC74kBGNK0poK8iy3zbt6/Dj+wxTs1URAwdOBXf7WGnSJWtiOLJDR7mAwsnJNq8FTHY2E5sQ2pJmTCkA3yiqPVGQOVpYtlzlJzr2o6/dn12fNH+MWvVrLdFr3tU12scdt28aw58d9GtruHimuj0m00x8b9JFaxGk0cMOI0nHEuCWH5bvy0GednTcTIz1StMqs/UGL2iBVOT3qeh09xVTuFt15YFXJnVlO0GUDRpOHqeoVYtTjCLEe7J7LcdusreMyWwXlHvywWks2EBWpeis4lSXSPSJl/tCjevOr+PuiUuGSoMWM+YtJ6Ot3Q7uYn6KE2Kn39rlH9AVgmSoeUM//ANuoW4b/eJHMRdXZM9svLx/oyzM/6AJ7bt6UUU9gXt3w1N0WPLwjnmUoCwXxBRI8/smjAg55oLwolQ8aMg8QOQ4ejkV6vdRIw+wv6eJuZNzk+vCiICJmhp52+6xQdnZOt/HeZ4KrCUkWsms97Piu0l8YfO2icUja8PEqNjDzUGTIQHYSZdkugd2rjT2jt7DsIf6RcS4UOqe2/t/nr4S+XT0JB/4B0SDTtiLt2xtrOPa5weR9fHrmSht/vKUb63mdNd2dxBII2ENnxx/8SAMw9oSmIQX3s/st7dml+EVz7RBqsolQZIxRjc35Agwie6nmjFErJhZhTSZ/ezb40zef4fLQq6YbtE1ibtT
 dXX4hT8n
 53LmUSQzYvECo3kTX5KpXiuL0SZNQ7mLsKRTEYS65zR5GZ2C95hgWnGXNzezPH3OdF14xZciUUwKUNU1H3MnIoVS+Gzk018mAkn2gvi1b1gxZKZNlhRwyhM9Q1JvH0AuYQoun/mGVJu1rzavfXa+AVuH4L8XCULoVZrSg7tDWR3vCJP0Pdg8KYsAoVb5uHVelsZMR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 12:08=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Mon, Sep 08, 2025 at 10:51:30AM -0700, Suren Baghdasaryan wrote:
> > On Mon, Sep 8, 2025 at 10:49=E2=80=AFAM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > >
> > > On Mon, Sep 08, 2025 at 10:47:06AM -0700, Suren Baghdasaryan wrote:
> > > > On Mon, Sep 8, 2025 at 10:34=E2=80=AFAM Kent Overstreet
> > > > <kent.overstreet@linux.dev> wrote:
> > > > >
> > > > > I think that got the memcg people looking at ways to make the acc=
ounting
> > > > > cheaper, but I'm not sure if anything landed from that.
> > > >
> > > > Yes, Roman landed a series of changes reducing the memcg accounting=
 overhead.
> > >
> > > Do you know offhand how big that was?
> >
> > I'll need to dig it up but it was still much higher than memory profili=
ng.
>
> What benchmark/workload was used to compare memcg accounting and memory
> profiling?

It was an in-kernel allocation stress test. Not very realistic but
good for comparing the overhead.

