Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E99CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 15:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E63D8E008E; Thu,  9 Oct 2025 11:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695EF8E001A; Thu,  9 Oct 2025 11:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585628E008E; Thu,  9 Oct 2025 11:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 441718E001A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 11:04:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCE4B1409E3
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:04:25 +0000 (UTC)
X-FDA: 83978896890.24.E1B78B1
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id ED380120010
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:04:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jgAwmolD;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760022264; a=rsa-sha256;
	cv=none;
	b=q5u+Tt3s0xUxQuevpUSBbwdZ4FJg0IQOx3mSOTOUDO37hlsMiCeMjpQsCJwZn/XlqY77z7
	abEq5DlyafJEIqrc0FMgcfDIFtBmebdjbetbjlqX6v1wjdyrrljSEPfSKMFX3vChLUZQFx
	ZCSSCk7Xl7Ql1HMvgg4M/1fxsxX59SQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jgAwmolD;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760022264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GiXnUieO2xScql0ch1/VZCkQk9SwXWpJ1Ui0K7fqWkw=;
	b=6xm80+5MLtWMfYPB46wydJY3s9kPcb21ZIHOhaJVyMHh+kl4v68zfpLhC3xt7lhucIvV1b
	gClh6kjO9Zj8r3dM1fMmbd3GEJZRA/rToReoHT71gS5ufJqnl4rsNX+AvAH/5JynCmKhhm
	b2K95vVE3YrxZ6gpycW1S/cqkkQdAoM=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4e06163d9e9so9534941cf.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 08:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760022263; x=1760627063; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GiXnUieO2xScql0ch1/VZCkQk9SwXWpJ1Ui0K7fqWkw=;
        b=jgAwmolDesGr7UZtZT3Qr/P0VUt1TTzCmiZ1bgt4V6gNHtXU3e0+lJNyJfBf+zbc8L
         WjGUIkRMymCUyl98jh/+021BsXOjg3d2B+Z/KkkSiSV3JcafXL09wnx30/FqbTFjLXha
         RU5AtS4/ETXEnD7r3Bbn+DPsk8qfi3LcuSQXKw0MnVtXeAHDC2H95a4Bz8vkBQLNBoaO
         Fox4UGCM9dMVt0wQB+bkWz6wYNLF+wGs5fG+6QHZo35plHtyjRC2EmB7peQVeIBjFGbH
         6ADTcbnBf/obumjqwWnUfkAbwSTwEu6IHi29S+iJWWyM/DYlCuHJ2qh2qNcFbZNbTukH
         OoYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760022263; x=1760627063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GiXnUieO2xScql0ch1/VZCkQk9SwXWpJ1Ui0K7fqWkw=;
        b=p0ltQ17sQtgBQpFXkJK0WW6cZoHwLjNkozqd3yuHKfgqd/enryv8EmixbHfXAhtp3W
         rXVrY6vQMuOSdu1Efyz0D3OodAx7Fj+NzsFbNP45gyIYPlCTL1/sjXfaSgzcFLxkmKo1
         cQq12H7d5M7m4Qg3Q71moB9dZ7m4xcBMyORpFOijWBz4QhEQFPvYYFf8uEN4itLqdW+1
         PnyP4tT4/GU7DW7KsHTwvZr2FeNqhCGWRPCCU9TwKyn0KCQ6xGbOpgHIkdqLv6QGhh8H
         o4jtaiUa3xGnBusqPxyk9fb7l9mICKukO2jRmgj4QZM/ViZwTPErXExXivNs3NERBMtE
         TnDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlobmEsSn5J82vzODtKIlQ1P8agv0H5MzEHcSSPSn4hhaIYmzNVpM8n1//LaVa/2MqOaAWaXmACQ==@kvack.org
X-Gm-Message-State: AOJu0YzCZYuKypALZVUq5cmik0dFib3uSvEYe/3X948VuY4IBA57myfq
	aYpKeUdGbm+vHXqyXB7igAtgO/GtHfwqk+pDppDWbaouhCsd4FZXU+6et3yxBhIcNLvA7k1fBpR
	G9ML0U+gW+WdfGrv7I8LbsuGY1DIhBjD4N/x3Rt6GTQ==
X-Gm-Gg: ASbGncvXTnrR+F/0rS3b2JJ7SYf32nFrpplnv0o7ESi5JodQem4PA627fBXl9z0y2I3
	QvKxbTvIubZ57G1PGC0DHYll0d//Gk/IMCGJSsRyybNC2K8a9AptcEqp+ORz3TnQw9ZrjnUEUyr
	BvXcg7/pVudTnPCSY5IAzC5SEzRt4Clq5vCeejD9qn7hd335ogVU0vcfQgre0quWj1tDTr2Kmv0
	VMzMluAnNJCf9laK7iqyKm0OYK+v2hikJWQlsU=
X-Google-Smtp-Source: AGHT+IGHSYnwEnvnqmKsabQEceJc2q2+TNir49AdC6M2J+VmuPk/pcH5aGDEMoZErKTqhORDi+KuefUOCQVA2OYIhzI=
X-Received: by 2002:a05:622a:5:b0:4de:73b2:afc7 with SMTP id
 d75a77b69052e-4e6eaced976mr96420711cf.31.1760022262645; Thu, 09 Oct 2025
 08:04:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
 <CAAywjhSP=ugnSJOHPGmTUPGh82wt+qnaqZAqo99EfhF-XHD5Sg@mail.gmail.com>
 <CA+CK2bAG+YAS7oSpdrZYDK0LU2mhfRuj2qTJtT-Hn8FLUbt=Dw@mail.gmail.com>
 <20251008193551.GA3839422@nvidia.com> <CA+CK2bDs1JsRCNFXkdUhdu5V-KMJXVTgETSHPvCtXKjkpD79Sw@mail.gmail.com>
 <20251009144822.GD3839422@nvidia.com> <CA+CK2bC_m5GRxCa1szw1v24Ssq8EnCWp4e985RJ5RRCdhztQWg@mail.gmail.com>
In-Reply-To: <CA+CK2bC_m5GRxCa1szw1v24Ssq8EnCWp4e985RJ5RRCdhztQWg@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 9 Oct 2025 11:03:45 -0400
X-Gm-Features: AS18NWCvIxwxMrUeEufsjS7vH40gfGK_CglDZxzAQyGFJbNRzJDPR8YX8_lwq6A
Message-ID: <CA+CK2bBs9FA-nVag-9QJ8zgocxhY9JOgkgOhFix1xScGyF3tKA@mail.gmail.com>
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, pratyush@kernel.org, jasonmiu@google.com, 
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 1zd4n6cd5wwkhu1sya4m78duwjtpq47k
X-Rspamd-Queue-Id: ED380120010
X-Rspamd-Server: rspam09
X-HE-Tag: 1760022263-251617
X-HE-Meta: U2FsdGVkX1/sBo8W9d0MqujCZehgCHtNLeNo+kLMw/nMnq2Zii+ugzG7gNCtHPtLWJNqh7dlIOkKzc+lJUrK3UltNWCTgktyrVDpFPxpYH/8EURTH1iab6fKzUO4jgKVgn/wEaQmEmTM294Ban3GGIAMWB1vz+wLm0bqeZiow+kErhLBSlgYZzN3RT2fTnRoVEslSZw38zpGWCK018Cy2/5C88GTdMWxzK4WrV6Ywa//uov52hxAXdV6gkUbiaD7G1/+oZHHoik6B9qj9HM8PN4GyhKI6Cmwf6zr9LX+LQRWdxwj0r1vjP+w6k679+fZhqQ294I5s1O7l8fD60bQ8CZ6taHlzsQgIqn+AzrLanMLPpjdSy5CxHh+B6DM+oAQXEukEERkY0U2Wg8Zn6R3PH1JPqG+jHmOiQZrjgvxesD6mAO6ZEROIV0Aib2eQLHkONFgVpEfo38jKmre3S3bxW9jbObNPCpwnRuV7EfZ627JNXLplvpVXDZHISexnjNb2NeTaMyU0qz23Ncbe9eBNPeJrEvQzetHs7o5MBdOr1D2XH/mdsrpq9FYsUf86k+oPz2luOtfURey1Gu2R8C2C9gSl19XQ/n+XqKhozeO90g9iVLFxfMiVAbARsn/jNyGFjDZUQ3/uSgkdbPpCdtX1m0Q/ObGwvJAskC3RMTov+jwf3n2CG/pPPDT57aCdhmsWXiCMWvlRt9ZZw6ZqRVBMiIydcViFsiLVzj0g2fLGkBC/HPCfTc2QQ7rs/eghjfkKClRSU0YkLUM0HtM/s6g/mr9VahJcx1youyMstvGHF05BSuraphsNP3wZhMXCYn2tv1wDUue1oTDhy7KegYovFI9Y3/iWzEcBGk8QWuXWSaPSq7g8Lyk/pNnuEQvyEEDB3IS2Um5/cz1a68XyLu63e2LCHmKtWhMSa+eR6ilp2r4wtLrU77EZfYK8jI0AWT8rxnRspM2Zdn+SaP0yqW
 VxLiua53
 dGuyZnzetKzp6NyHFybeHG7zFzX6AUREDEO7p1wOCvcFeZL+CKBPlQ9MuK2upCbUgSQxWPJzoUXThgQBreARJnr61mRgVA5Ksh8x+5ygRxBftsbXmuq2WomHpnEJvQ1NhODZb2oN210quE0NGow27j3IHo98e3mzQNuWSBBH/jTrXHCPe5IvM1zUGQFffUvfhnVKI+9rWPrPa+UL/RpZQ4nxYaLnRsdBsWTEWRiJClrU6rTyGBPS5YAkJIhbpln+T4IUvr0YY+qEFmAOv/8YVFIg0MWH8ah+7uOj0fK3Z6v0/K60h9tmzhn3VmFCoPtGEygRV1J8YcL+WD6Og9GspDLHrEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 11:01=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Thu, Oct 9, 2025 at 10:48=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> =
wrote:
> >
> > On Wed, Oct 08, 2025 at 04:26:39PM -0400, Pasha Tatashin wrote:
> > > On Wed, Oct 8, 2025 at 3:36=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.co=
m> wrote:
> > > >
> > > > On Wed, Oct 08, 2025 at 12:40:34PM -0400, Pasha Tatashin wrote:
> > > > > 1. Ordered Un-preservation
> > > > > The un-preservation of file descriptors must also be ordered and =
must
> > > > > occur in the reverse order of preservation. For example, if a use=
r
> > > > > preserves a memfd first and then an iommufd that depends on it, t=
he
> > > > > iommufd must be un-preserved before the memfd when the session is
> > > > > closed or the FDs are explicitly un-preserved.
> > > >
> > > > Why?
> > > >
> > > > I imagined the first to unpreserve would restore the struct file * =
-
> > > > that would satisfy the order.
> > >
> > > In my description, "un-preserve" refers to the action of canceling a
> > > preservation request in the outgoing kernel, before kexec ever
> > > happens. It's the pre-reboot counterpart to the PRESERVE_FD ioctl,
> > > used when a user decides not to go through with the live update for a
> > > specific FD.
> > >
> > > The terminology I am using:
> > > preserve: Put FD into LUO in the outgoing kernel
> > > unpreserve: Remove FD from LUO from the outgoing kernel
> > > retrieve: Restore FD and return it to user in the next kernel
> >
> > Ok
> >
> > > For the retrieval part, we are going to be using FIFO order, the same
> > > as preserve.
> >
> > This won't work. retrieval is driven by early boot discovery ordering
> > and then by userspace. It will be in whatever order it wants. We need
> > to be able to do things like make the struct file * at the moment
> > something requests it..
>
> I thought we wanted only the user to do "struct file" creation when
> the user retrieves FD back. In this case we can enforce strict
> ordering during retrieval. If "struct file" can be retrieved by
> anything within the kernel, then that could be any kernel process
> during boot, meaning that charging is not going to be properly applied
> when kernel allocations are performed.

There is a second reason: by the time we enter userspace, and are
ready to retrieve FDs, we know that all file handlers that are to be
registered have registered, if we do that during boot with-in kernel,
then we can get into the problem, where we are trying to retrieve data
of a file-handler that has not yet registered.

>
> We specifically decided that while "struct file"s are going to be
> created only by the user, the other subsystems can have early access
> to the preserved file data, if they know how to parse it.
>
> > > > This doesn't seem right, the API should be more like 'luo get
> > > > serialization handle for this file *'
> > >
> > > How about:
> > >
> > > int liveupdate_find_token(struct liveupdate_session *session,
> > >                           struct file *file, u64 *token);
> >
> > This sort of thing should not be used on the preserve side..
> >
> > > And if needed:
> > > int liveupdate_find_file(struct liveupdate_session *session,
> > >                          u64 token, struct file **file);
> > >
> > > Return: 0 on success, or -ENOENT if the file is not preserved.
> >
> > I would argue it should always cause a preservation...
> >
> > But this is still backwards, what we need is something like
> >
> > liveupdate_preserve_file(session, file, &token);
> > my_preserve_blob.file_token =3D token
>
> We cannot do that, the user should have already preserved that file
> and provided us with a token to use, if that file was not preserved by
> the user it is a bug. With this proposal, we would have to generate a
> token, and it was argued that the kernel should not do that.
>
> > file =3D liveupdate_retrieve_file(session, my_preserve_blob.file_token)=
;
> >
> > And these can run in any order, and be called multiple times.
> >
> > Jason

