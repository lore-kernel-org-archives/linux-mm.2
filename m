Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE3B1CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 16:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27B378E0006; Tue,  9 Sep 2025 12:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252F98E0001; Tue,  9 Sep 2025 12:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168DD8E0006; Tue,  9 Sep 2025 12:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03EDD8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:54:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1E8FC063F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:54:09 +0000 (UTC)
X-FDA: 83870309418.09.56B055A
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9C2A5A0017
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:54:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="2K/vvHI+";
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757436847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2tBW9z9qtavE4/GQ4hxoUrDMkmeBsS59wkL6NhBrnw=;
	b=d3HcefqoIxXM79XHGfEUMtS/ch2R1B3PKSz+gLi+AOyJCK0n+UedYmgkenLHyZArRm7vhV
	gH2sTlK6wgSZdb24ko1Bl+096/EZchOFxtvx1tWpASHAFnUpRzmzSPedpSAVVRluPniwF5
	y+lAvZZuyUi3U3rC30o6V4VUIxdWVuA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="2K/vvHI+";
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757436847; a=rsa-sha256;
	cv=none;
	b=0iElPYPT2/E0T67wfAxGwctti35DilAu/znWKNx6qh0UlUsrY773Gi0idUB7zwHRIOFlga
	x2ORmkpgMb6rkPRVwPFCIMNsMC9UUWOvqrwqSYVhM0QvYH7b3pvlJ+iWP+N3KwcoGddoSN
	qix/WYEpMTbMc7rvdW/aDZL0wKTUujE=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-61d14448c22so233a12.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 09:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757436846; x=1758041646; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2tBW9z9qtavE4/GQ4hxoUrDMkmeBsS59wkL6NhBrnw=;
        b=2K/vvHI+l9ehyEPCKCVD5iPNknz2ZwumFZYCVOo9zlxuTg4S4NV0eGq+y/UKuc5TGA
         7jOueWh40Yk1vSaJ8qgf8yx3seghRtqSU3mU/4wIpzhoKLNUYT3tZsy4BQr103+ngT3h
         juzFXGnHEJSmLySgPNofVRDhJTKTdYVGF+qsaWNgEw6qFv7KCyMnTOozwUvlUqQYVIaA
         ZHsOHuOTl2OXCsq1+nHXUwqKZQdyAv0IUWL150hnu1r0LTGvNZMA4cG/57lp1Rt1prQR
         kyfGUqqPujKJGVtsHODg6seX07nkYI/vSuMVGH9TBHb5sLPid93//28BtbQYrTH4UYSC
         5TFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757436846; x=1758041646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h2tBW9z9qtavE4/GQ4hxoUrDMkmeBsS59wkL6NhBrnw=;
        b=vQXGsUC4cP9+pJNeKM0OG6+7hjY/zpsRALM07dy7Q6cqC6mpNp+c2QiMiThritS0nK
         OoSWSi+9rN1VxRtN6KjwoN07hU52IKmqUX+Av8SYyr5ugI8T+nfl78+dbLUYnit/b8Ok
         rMjxedYTiQLKubpjGitCa61ZqY9g2LRboLS8MLypg+1JS2LtmMHfAq50076fRdVMPWuT
         zPQmC7poxq40FlJS5TWlyR4seqpcsXhSkB2djXtI1gU2WRB7Da6Ua66OOUvLcS+VqabQ
         DIUgCFxWPl9gi9vCB7k8Wm25xGMz+647MqEbiRQ4WjQX0yf+USeP81u5AqOG6nm5UKnr
         J1BQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMOhigKj0wMvx2orMxiUYBUS75TcJVjFNBqGiDfkRlY1xagf2ScSpc63Fsn+V5MmwK7OBfRmZtlQ==@kvack.org
X-Gm-Message-State: AOJu0Yy7IEXxNKXJBR+m8/Tmpc+EfRgwWPRCmh0QbSxEAuu/UvBqkDti
	dr2/OjnsolEqvQSFYEUAS6mTmjhrNlnHTgZVjmEBVq9Tv40VtUcgc3JL4FaSJeTfOvTok6uLiKE
	Dv7uK9wddL5G3DPaeDJBnW/Io9dYwO94YQ14uAfX1
X-Gm-Gg: ASbGncvgFsih9iqe5CN+qSnWgUG0qjnWCyLdLYSV+6HabobirZ6SDZKyjMI59uRxN6I
	EZ/YNysw1yVEFYFnpoaVJpN1zkBEa6xeceR3wOcC6MNrIVs31lXMyEeV5etquLPVEJPsncVWJlc
	Uvk1KtrAvhhoflX4kUzJaf0q9GX7bscXDshAGZkkYOZKMUMTg9pGL93T9OR8sHA0ln3TZkSf9XR
	14BHH4cNJ+0zryw89FH+t61dg/UpWSaR7AlpRj37seeOUVw7tkadi8=
X-Google-Smtp-Source: AGHT+IHIuRq2aKoS3kEjqYzebKZlwD2uOrphU5fkaOYcf/p/e9onUEd1fbAZ1KbzoQawzSyO+8wUa2PQlZBj/Dw4WRI=
X-Received: by 2002:a05:6402:d60:b0:61c:d36d:218c with SMTP id
 4fb4d7f45d1cf-6234d3ee779mr244623a12.0.1757436845803; Tue, 09 Sep 2025
 09:54:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250909090659.26400-1-zhongjinji@honor.com> <20250909090659.26400-2-zhongjinji@honor.com>
 <aL_wLqsy7nzP_bRF@tiehlicka> <CAJuCfpFCARoMJ8eniYdZ3hSaM_E3GvfRBV1VD1OohOfJpP87Hg@mail.gmail.com>
 <aMBZfYUN9qtcXXtL@tiehlicka>
In-Reply-To: <aMBZfYUN9qtcXXtL@tiehlicka>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 09:53:52 -0700
X-Gm-Features: AS18NWAskqfJSKzjlCIyKddbks8of4_LFzBxNZe2p1mk8JK6wEwUqIe8FiYXcFc
Message-ID: <CAJuCfpFsgTmmSGEzK6TF62TNr4d4E+Art4ghfB3dHxQYMHJ2ww@mail.gmail.com>
Subject: Re: [PATCH v8 1/3] mm/oom_kill: Introduce thaw_oom_process() for
 thawing OOM victims
To: Michal Hocko <mhocko@suse.com>
Cc: zhongjinji <zhongjinji@honor.com>, rientjes@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, tglx@linutronix.de, liam.howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, lenb@kernel.org, rafael@kernel.org, 
	pavel@kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, liulu.liu@honor.com, feng.han@honor.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9C2A5A0017
X-Stat-Signature: xkuddtmp5bkqaqiea5k6xg9x77mfzc1w
X-HE-Tag: 1757436847-958882
X-HE-Meta: U2FsdGVkX18HzdcADoTHKSvrwLs/1nBH4mUvDc5ZmDCYMilDfHYJAurXBWev6OvF50ZhBb0ZOpQSUhq5q7cSr/fqCLVRHU+rD2G2YmdaCEC+8X9tFKN89qbGb6J9SJ6z75OxHUKpA20Ps9Up/YbJzHg1DdUjyR/1v3CbuCAh3BA5qTI+13B5XLZesWpYijwt++R2Bdhtl6rQS38DSePLDnrkCRyb3mdH1ZGPxxuhT7a3mxEDRs/OUPgfSMZKFrNPeBUNFJSaYxdWA6vCKjdY2AOiQ/0hFRqAlPMjyT1IvogYH59pKcHo0a5h1eih03wnEJBct9bRmVpT91yk3gOnMcW7oz9V9H+Q5bhVNk7GoR5EwOTeSMn7l4VplI7H9q+hgjKSk2mOdfEg4bWkeIt7AhZw3fovMG4xjiPBfkyWfpipT4wEstw2eXyeg651KMWdP0WdtGTtI+fSt6etG5ADmav/YTGQgAuxa2no3/CdwlvI7zd9DSXeIByKsLlp39ORlGPaW52oOcIhm7RowOcCNMD3DLgvsFEFxEy8D+6fJthdJrB5I52D+2fS5xyIHYGu0HqesI9UmUem4mKfg7YFF6FDaAe8U7XgvnoPB/+/f6tM4bU8gQv/OeMnc2fX5fBWcS/yBgWW9nkk2l5nUXdGVWChLwn5OK8XJKe1ICTEpCJI7FSICS9zS4CstFDl0etFAo+aXRVlkfcffWVCYPZWbY+0ujSKWNcY1lBeANgIOhJJce+ge9Osg2KfwEXTNetWQNqppW3DQW7r/4o7TIrelclfjhavpdRChMG5fLnkZM6xNU0Ru30NHIeotJQ+1wgCJ/lVHEW9SeFc59x2uR/0x8VNEdYhL3DiOPAp19iKjcVfxsSiP0Gl80Pbk+Cth24DNf+IijdeMq4XDUv3GTUvUK0yO9wmtQQDjip5eulTmdCECsxmFKmTIOSUIpmCZs9FlSIBEVDFVBFJYABdp3T
 Rxy++kvs
 0wzkGSdeQy+NDbQ/yjj/PUaab7QiechCgVuLd8mkked2LyZcEE7O7BD3YUPAy8HuXdTOYuSsDrBBvU2gC5wWJxlaK+JNtivwLoj1T1Ti0RqSSmGJSQTfzgRvoapLliz6/41+QKWG7uf37MdM9bfX3NduKFWIATAjRxsVcOkbbMqqpHi5hn5VWXlRXcoRo64wAFqU3py862cIVWDjIXfs0LD+8YHNu/4hEJxkkNrjEgzHVfndA09j5QzSkjERKGdxm0lizRMG1amuK0qWzp8j6OhaKd91xv70n/SWm+kFvQFLyo1U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 9:44=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Tue 09-09-25 09:27:54, Suren Baghdasaryan wrote:
> > On Tue, Sep 9, 2025 at 2:15=E2=80=AFAM Michal Hocko <mhocko@suse.com> w=
rote:
> > >
> > > On Tue 09-09-25 17:06:57, zhongjinji wrote:
> > > > OOM killer is a mechanism that selects and kills processes when the=
 system
> > > > runs out of memory to reclaim resources and keep the system stable.
> > > > However, the oom victim cannot terminate on its own when it is froz=
en,
> > > > because __thaw_task() only thaws one thread of the victim, while
> > > > the other threads remain in the frozen state.
> > > >
> > > > Since __thaw_task did not fully thaw the OOM victim for self-termin=
ation,
> > > > introduce thaw_oom_process() to properly thaw OOM victims.
> > >
> > > You will need s@thaw_oom_process@thaw_processes@
> >
> > Do you suggest renaming thaw_oom_process() into thaw_processes()
> > (s/thaw_oom_process/thaw_processes)? If so, I don't think that's a
> > better name considering the function sets TIF_MEMDIE flag. From that
> > perspective less generic thaw_oom_process() seems appropriate, no?
>
> Please see the discussion for the patch 2.
> TL;DR yes rename and drop TIF_MEMDIE part and update freezer to check
> tsk_is_oom_victim rather than TIF_MEMDIE.

Oh, sorry. For some reason that part of the email thread ended up as a
separate email in my mailbox and I missed it. Your suggestion there
sounds great.

>
> --
> Michal Hocko
> SUSE Labs

