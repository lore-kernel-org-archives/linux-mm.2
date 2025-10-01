Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE351CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 22:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4FA8E0007; Wed,  1 Oct 2025 18:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3EBB8E0002; Wed,  1 Oct 2025 18:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2CF68E0007; Wed,  1 Oct 2025 18:17:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ABC288E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 18:17:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64E3316027B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 22:17:26 +0000 (UTC)
X-FDA: 83950957692.07.2967A00
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7F61418000B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 22:17:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JXGWBLD0;
	spf=pass (imf06.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759357044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=im5o8/JhY9U4JZPGh2QjfMYtoFGFzGrMg53SDn54CBY=;
	b=CcI9hlm6Ctmew2jawSR4wdLGcKqKp0k8vDcCtBDjsNqd1MiUlTX6wvoPBYHUSP3UGQFCdT
	P8yZ34ikkcJNPEmzPgXsTLywiHXRn9KsRpckuSJmTZoHDMVvJzsxaEEhlnnos64MJ1Q2oq
	nwrcA/IwgpKymy3ncIqW+RogDjuw74w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JXGWBLD0;
	spf=pass (imf06.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759357044; a=rsa-sha256;
	cv=none;
	b=QOcXVFuyIkP3RZqv4hRKWExzfBpaEFcw/ABzv9dF3CuBV2CS5696zxhh5uwXxsikRyserw
	fPFwNS6aiHwfVn9y8dTe3bl29rKOxwIL8aWEtfB1dDsRNUBFCgicFid999Rex8ROqc7BMU
	RmVlvpW/6CmB2AlRSFPa4/nE6jwwUyg=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-27d67abd215so73535ad.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 15:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759357043; x=1759961843; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=im5o8/JhY9U4JZPGh2QjfMYtoFGFzGrMg53SDn54CBY=;
        b=JXGWBLD08pbEcy51zCwdXumCmLwqHFrZBdB8hOa726rZS9r9Qok4MXY6or3gE7BVPI
         QB9EKkti41B2rdnAuGfKqVQboUjQL16Zqw/UGYAiktjGmoHeze+YEBN8jvSoiqQ9yAnU
         FCgZpb42mHl3AKjCbBtm9U0DTIr1gkCzo264728YQIFNsRXUEQXReR/utlWlrOJMCgpM
         NS1U32Aqj+T//kYcfqAwPurVWpNOKkpwtvM0kbuzbLRMyRKq6QwqYOMD2IDA1Eo58Dbi
         9NxHgkqSXKdvX0Zuj++CTXZVVMNhTDVbuJtmEb3D3elsHnjgVmNhQMiPZ91sPBI/TOO5
         OJJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759357043; x=1759961843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=im5o8/JhY9U4JZPGh2QjfMYtoFGFzGrMg53SDn54CBY=;
        b=VfCTiPqZ/DfG+vxibWyffeRhfAEeCzLZn9AoKBUp5k+25i3zB8Am1AGQtSXzLMgy/M
         RJfONqVdl44A3JHUyRR2ymBvBB/nfyYUd+ZiE+m3yOJGG7rZmRt1wmV2S7wxJyPQFRNi
         grxrBYRXC8KasChVNioHQD7jwu8uwxCD4MEuUnd3dWbwxw2+zU0LpvnVPFlz7droftTF
         KwfHH2kN6/zBUyvn3CEmzXE583eyRoD78OCYrxwrBLHx4JS1/cS28VKYpkwhEiuEvFhX
         rW54eG/7+7iB1S8Q42lGpe/D7PDkaRuqVvQcVMSnOWx9CQ7tuW02Lp2Y3oeFj5hIiUaR
         MoMg==
X-Forwarded-Encrypted: i=1; AJvYcCWx/WAuDyV8PmJ62ZHiHmPjFFDkKsLO4HefWFQb9sEFLoAhUVH0+cKVSTpAj5jUReFO0O7hpf7dtA==@kvack.org
X-Gm-Message-State: AOJu0YxlGxV7aBSGH62qFNJuVQ+0WU/EvY5qo017Dai9Cjs6r1WgJ2GJ
	KPTzL+7agx9zcwRw9wpmC9UP+KwLIEhT3ZJM5ziaDSwLvhbZDnBwesCFj5YDxx2OHolcbzg5f3g
	DXct1AjYG+SbK6G8doQ3t1OY+4WvlS2U6HJ+IQOs7
X-Gm-Gg: ASbGnctg4fUCwzgxC6/C7n2vn+aLDMuvGw24FQneXpzpnINdGE5zDMpZI//Dbdbdami
	P978zNSZwxmeqyBKPMH92gC8W+Fz2ILrxtJ+nt2E+J8nBzy82jNfNjJ5vpu4IgZTYw8GDWAD4mc
	WD8rV2d+4nbY/y2D56PAJ+v7o8h7apRnrcY8J+XLeTE/XdUKveb8x3OCVI+kjtXIkHLcysrAcCU
	GHwx9zKQ9JoJH1sIxEwSph5jai9Fgf9XAGcOHM/XeTO24m1HXVwn7tBrhVGxFEqXL6TZp+E1vMn
	ifWb3PU=
X-Google-Smtp-Source: AGHT+IEhjJEVv1KO2Sl21mU11B4LQvkwHgYZg9a+VzDZ8KCf9eDDcpza/PlMQ4nWMJB8yYNDQWX3ETtyc0DRbR0iuAQ=
X-Received: by 2002:a17:902:f791:b0:25b:ce96:7109 with SMTP id
 d9443c01a7336-28e8e9e7c4amr656585ad.3.1759357043044; Wed, 01 Oct 2025
 15:17:23 -0700 (PDT)
MIME-Version: 1.0
References: <aMmMnfU-Koopc9mL@x1.local> <1758043654.112619688@apps.rackspace.com>
 <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com>
 <1758052343.971831541@apps.rackspace.com> <CAJHvVchHKxiVKFjUz4ir4PVDvUihLhiSRMBWqpMEZfwLdereuA@mail.gmail.com>
 <1758306560.96630670@apps.rackspace.com> <CAJHvVcj_gd=48k-dgbLeEoqn_f+QD-ifscu_DPvpAmPd1Kg=GA@mail.gmail.com>
 <1758998720.44976697@apps.rackspace.com> <CADrL8HW0eNsHnEsEdKYRNvFRBMvrDMrHawa55Kik9QFeVNEwgA@mail.gmail.com>
 <1759175092.67312651@apps.rackspace.com> <aNrsXJsKaw24ADAp@x1.local>
In-Reply-To: <aNrsXJsKaw24ADAp@x1.local>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Wed, 1 Oct 2025 15:16:44 -0700
X-Gm-Features: AS18NWB0rgWlKVjT_-eaXe1ipgZH5LVgU24IvVOu0YKljnqjqmaS0nFQKcyhcQo
Message-ID: <CAJHvVciLe9--JnNn1=q=ycrgQSTVt7Zq0e01KhaRmOeSLO86dQ@mail.gmail.com>
Subject: Re: PROBLEM: userfaultfd REGISTER minor mode on MAP_PRIVATE range fails
To: Peter Xu <peterx@redhat.com>
Cc: "David P. Reed" <dpreed@deepplum.com>, James Houghton <jthoughton@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7F61418000B
X-Stat-Signature: rqt18eb51cj4piq1zr3e4pkw6qtpf3ob
X-HE-Tag: 1759357044-656758
X-HE-Meta: U2FsdGVkX18iq66GWq37tz3pFiF9a6MYqxgkym3t+L14X2gSwaC/mzGKuhRZS7eibudpOFYvYNlmG7oJu6OdgQukAL+wSr1gxMEe0O4wSxLO4g2iqfA++4nO0r/khTzGyHnx6WU/1M8dvLAjLp4xS5fzcnLdylQDk3vfVLrR6MWBm+rMk2QDAJAw3J9rplIm3EXT6wGAbsSFRxWQKncHjpFXp1tEgGKmTOOw/nAPWnvI3XqSqS53DUVEGIaO0WLuf47jfwXXa/gPEhoKaICfd+BQf+9I3Cf44I37n7shT9ERJGCOcYp7aory0m6Qiiae+hy0+f85nssCb7VSgj0IQLu53U7vycRcmcEDbExkajzZlQKSIVF4bMe2z/QLuMlifWUWd7PbSzcExDKwWIRLXyvJ/Ft+XtOUqML3cwhKxfhDhP4iWWGKze4avg9ID42jY0bojmXj3ui9hMzBJP5P5xMHFyGqft8CJZlS20kOobHjqflzwx079YY+KK/ZGG6uge33rmuwav2WrTKJhxGEfF7Oly4aKEFo5mJW966Aa/hM45w73/JZdLe9uAH2v/S8ELEBLYqBWQOYSpMsgo9LPOiO7NYIKToOETQN7F/4l+MUOX7CeWIAF7CofZ/aFvJuMklctAkAbrip+kfkDRJHIMeSfYyF5DBIlks5gyzqU0Up0VTfeF9N6IYa2CKy7uo8Yr3FHGTJ9Vv8mm/9er44XE+RoD05lGIftwBOHdQiVfhC28sz8w5MsENndDzkXHHq3HVJXy46Do8bH1fSe+9Z1tpfsTdaoLFSv5Oo1+2oFqXUu5ocL9ps2XpcthJ4Du4CTpo2JwgLtI+CnfLss1RYvGM4uLSudGnUAz6ilJNs0ykMEeiyvWjrb6mHe45SxYxbYemDL4SiPzhCpDg2xI+5cZUtAUMnumHn4jkLYrY/xpODBGI44hQT0yZVUfw1Bo6d0TLC30L/7/HQY/QfqoA
 oXQNegMD
 5ZkKZ5MDBJHXhiPvkkLSpwc1wWKfTbGJJmuEr0J991CTHnGwO+PBPaP0MB8kFuiRA5nzmHddLntivcPNzj6gXwHgAYv2QkvK5ucSRs/uyTHPClYpYX8adNSW9j5LBFSgDNkkNw4VSTfQV9Ybvt8FHOFxAODXV18JbHJPBvhp416djR37vOQrM1XgXPJ3TeptpTrs97xuAIqxdw8AjWoYuPmVuy2wOsufgtbJykjgNuitBLuREj4axy5Eyp8oeuMJctwQIaP6loHENjNg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for linking the ExtMem paper David, that makes it a lot more
clear to me what your expectations are.

I think basically, userfaultfd has evolved incrementally, and it only
has a handful of features needed to address pretty specific use cases,
it doesn't have the full flexibility / generality you would need to do
"full memory management in userspace". Not to say I think it shouldn't
be able to do that from a philosophical point of view, I just mean to
say it would take quite a lot of work to get there.

Performance is also a big concern. Userfaultfd performance is not
great, in fact scalability issues are one of the reasons we have been
pursuing guest_memfd based approaches to VM demand paging, instead of
userfaultfd.

I don't disagree that in principle it makes sense for anon private
swap faults to generate userfaultfd minor fault events, it's just
until now nobody had ever wanted to do that, so it hasn't been
implemented yet. :) For what it's worth, I don't think this would get
you where you want to go by itself though, because the only action you
could take in response to such an event today is UFFDIO_CONTINUE,
which would simply swap in + map the page, you would have no
opportunity to e.g. populate the page contents from elsewhere, you'd
be delegating all of that to the existing in-kernel swap
implementation. So it doesn't really get you all the way to "full
userspace memory management".


On Mon, Sep 29, 2025 at 1:30=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> On Mon, Sep 29, 2025 at 03:44:52PM -0400, David P. Reed wrote:
> > I thought it was a general purpose interface. My mistake. But I think i=
t
> > can be more general, at least encompassing my goal of having a userspac=
e
> > "interface" that monitors processes' page faults.
>
> To James: thanks for the great writeup.  Somehow, I just feel like userfa=
ultfd
> (as a linux submodule) got some sheer luck to have you around. :)
>
> To David: just to say, I still think it's a general purpose interface, at
> least that's the hope..
>
> I agree with you at least on one point you mentioned, that shmem also can
> swap, and that was accounted as minor faults when swapin happens at a
> specific virtual address.  It doesn't sound fair if anon isn't doing the
> same. Indeed.
>
> It was just not in the radar when minor fault was introduced by Axel, eve=
n
> it was for a solo purpose for live migration at that time.. but the hope =
is
> the interface designed should service a generic purpose.
>
> Now the problem is, userfaultfd wasn't initially used for monitoring syst=
em
> activities.  As its name implies, it provides the userspace a way to
> resolve a fault, but only if a fault happens first..
>
> Meanwhile, system activities should definitely at least involve swapouts,
> which unfortunately doesn't involve page faults, but only happen the othe=
r
> way round when the system wants to secretly move things out.. that is wha=
t
> userfaultfd is out of control.
>
> It just sounds like it won't suffice your need even if we could add minor
> fault support for anon private memories on swap cache. However, if
> userfaultfd is used to do everything (including swap in/outs), then it's =
by
> nature all trappable + accountable, on both swap in/outs to/from any medi=
a.
> Then swapout will be driven by the userspace too, then everything will be
> in solid control, including monitoring of the activities.
>
> Thanks,
>
> --
> Peter Xu
>

