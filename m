Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31491CCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 16:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70E568E006F; Thu,  9 Oct 2025 12:46:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696EB8E002C; Thu,  9 Oct 2025 12:46:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537AF8E006F; Thu,  9 Oct 2025 12:46:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FCBF8E002C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:46:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E63E911B21A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 16:46:31 +0000 (UTC)
X-FDA: 83979154182.26.7514ECF
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0AE92C000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 16:46:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sKya4+fa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760028390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZzlluHwkUBhNfLLuHc1HKW2H+S+ipbeYuCHoUWYJ/AU=;
	b=J0xP0+EWho1vADV0v/1gCxwUdtF1DsKBsVBYqawX2mWJ/vo5Bo1tGPXLTJIdgY6wrQzO2f
	hLf4ut61aG+j9BopMrrZb1icmDTnW1aHpzo6GXJQJU6GMio2ZOOz8dxMoPx1NomhBbrfFV
	urfof6BgY/Ux+Mmx3mqH37gGpYfjv6c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sKya4+fa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760028390; a=rsa-sha256;
	cv=none;
	b=s4cZH0eCS8RS63IGAQO5IvUycjOfu4TQvSnlpeHMkN7QxLtYXeIcgB656EXsejFx96ryWo
	NlPvGR1qE/bL44H864F6V0fCQBfMAMof/JhIswJaXNqXbhtnbQjPUw/u2lahSaZuzd2kMQ
	FgeEMD4ePTOPTNRi79ZDNE/Pk/FifqM=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4e6ec0d1683so6591cf.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 09:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760028389; x=1760633189; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZzlluHwkUBhNfLLuHc1HKW2H+S+ipbeYuCHoUWYJ/AU=;
        b=sKya4+faXFrwBkDkqMJInAGpAZ9eY27ugrjWd4BP2etfoWtsiY0mJOORw/4xVmgtOX
         AlMoKXCzItDgtKOfFQ3Y8v3hGFs2J1vgs5AbgPshhgFNHIPqrutKFb4NfBTs1lXnK4Cj
         qTQsS0UGIsz7ncREdDIa4HqexTiLBFHef1pAmLvd4Tb7090fYJN+aJP4qVpgO3LGK36U
         dVwZvm0kO7sdttfQ+miTvydgjQsTX12x2qIKWH4+VjwTyg00Ox8wMeetiHQf5UlqEzh6
         Lk8i1qAvBFSnWBsH5pI3o6mzQNhwGs2C1HiLTGl2AS1LPg32bLIaGavo2N3MAdFjZYJ0
         qq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760028389; x=1760633189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZzlluHwkUBhNfLLuHc1HKW2H+S+ipbeYuCHoUWYJ/AU=;
        b=ZsH0fIz+Zx+iOu57Lo6xzOXTyI3nkKRkhEV23SqbKnM9ymdyMTr27+iMes+2CgLK6B
         y4SbVmxVq626TTBYqzGJ6GlBfB4NKgQribBLCKSel0G0bNSB9LAEncAw0kusmdOb8Tej
         xVZbJ31+vq4qCIff4ad+yO0SciP5aDQrv+hnqMWN+D5WbOnmHd7tzX5ZvGMWchP/3thD
         9l2MWHLCmBoqx8abBuMuatJKvS99UVpzGdFK9Y8i1sbp6bo7u0xrm5dfpPzyeJEp/Blf
         SgQyBlI9jPZI03LIlvjF64Z1j1GVdScnsGZVPTl2K4Nm6Jk5xZuSKEhAVm4qVd6dA8CC
         bL+g==
X-Forwarded-Encrypted: i=1; AJvYcCVa5UajuDDsieNIIFCYnXbMYAOpqlXDK8OKnb4VGUkUw0d4O8lYdQa6IvKLUp+2+kg/crvdq3A+Kg==@kvack.org
X-Gm-Message-State: AOJu0YxKqE00stOldqYb3JRmUyKvd7bMdj5bXsbOkem3RN6tOmf7Rhjy
	VRk3pTvGAfharElNqAtrUHVIF0n85fxXgmRs5O9/ZGP3bhZ0IojCMvrl0mpu4WtJuNbQvWf47Fm
	YsLaRVInd58X66A/J4qGwJh1pZMECZBuLiG+LCDMQ
X-Gm-Gg: ASbGnctB7ONauTxiNV84ArebIIi8xVvzFe6qhG1n7H1+mfznPkayj5pAX3+EmM6OJSZ
	xxG7zyxnEj7gjCuFudiI4oDIBwaRV7VZ0PlAbw0R7TNzvbfYWFQe+4Utwzy1RBt0ZoeQT8FkhAi
	SOMQ+IfserwhBt3sSJk7OIOU2lPxuE0a5or643hfFDVfvsQC9c8C5Yn2x2a6cpxQA0SmPhbJN/y
	HUndbGA95qydU7ZyJoPCWPCwg8V0yJ7PnkfwAu9Xl6L7kvpvqZu0xIyaGr85uOPCEqkWYo=
X-Google-Smtp-Source: AGHT+IF70ucIJMpJA0vPDQgicdHZr5JjOzPiEUk9y5SQTUUUNRoZE52nw8qSw3T5aRdmC55lZrWVgbTQ4VOEIK5o6D4=
X-Received: by 2002:a05:622a:344:b0:4b7:9b7a:1cfc with SMTP id
 d75a77b69052e-4e6eabce6d2mr16470351cf.10.1760028388319; Thu, 09 Oct 2025
 09:46:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
 <CAAywjhSP=ugnSJOHPGmTUPGh82wt+qnaqZAqo99EfhF-XHD5Sg@mail.gmail.com>
 <CA+CK2bAG+YAS7oSpdrZYDK0LU2mhfRuj2qTJtT-Hn8FLUbt=Dw@mail.gmail.com>
 <20251008193551.GA3839422@nvidia.com> <CA+CK2bDs1JsRCNFXkdUhdu5V-KMJXVTgETSHPvCtXKjkpD79Sw@mail.gmail.com>
 <20251009144822.GD3839422@nvidia.com> <CA+CK2bC_m5GRxCa1szw1v24Ssq8EnCWp4e985RJ5RRCdhztQWg@mail.gmail.com>
In-Reply-To: <CA+CK2bC_m5GRxCa1szw1v24Ssq8EnCWp4e985RJ5RRCdhztQWg@mail.gmail.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Thu, 9 Oct 2025 09:46:16 -0700
X-Gm-Features: AS18NWBgKgmWhR1-EKut7z0eede2LXIJaTXH-__gJayThOTTr-r8gXegH0ezPFY
Message-ID: <CAAywjhSU7ibji=Z50U+OcX7eemhid2sB7OK_fsgzds3vGTZOjw@mail.gmail.com>
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, pratyush@kernel.org, jasonmiu@google.com, 
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
X-Rspamd-Queue-Id: 0AE92C000A
X-Rspamd-Server: rspam03
X-Stat-Signature: zaiq6wbiu1baqbrzaichi1ntzpju8su7
X-HE-Tag: 1760028389-917171
X-HE-Meta: U2FsdGVkX18ghQABajzTPeiXKo9Ple2j78EK+1nKBHGfg7lGNpgeGSjixybHIu+tnZlZeOqayFJA/3f/SG4OajeuVoiImZnruH5KK3NmdMLu+AVPiqJsr3ZqrgT0c9NLOER3hYUaRcEtb66VNKrWsOL73gcncjBizexf5YY3YTXQSpqq4FHsI8ljWUCeXU7FcXJ0gk88cJo4VnxVB+fBEMHOinzLSmaWODcMtft9m2g5Hk/3bExiHi7N0Uw3dBAEx5kFZafc/z7q0QaNqvSgr601/ZC1zjWWnesflcdqIDUtIIEwDZhv1PPCLvRZ9QAvqfW0ujIohZfM2JwlqxX+BKVSkNyUd88mXMWJodKBTb09kEEOHuujGTnGjMXhbNtvve0KyORy5O9sP538REoQJJbc/eLSMSZf2en77LP7S9N+oBr3vi1gxZpm6eclsfDVg03uVDRyV8ObufStZ90nqnVAGeTAcQp6scD41mzrimFzup9BTbIyXOFyIsn8rfPnLMu1zC4KdBFsfYpyKzAuS4OKJQIupmWxJKaaAI2Wca2tYN9mLC0eyGE3Bnxn1vZpT0k1/ZwLEOkLrqE0lW/tU6o4Uz2sqRc8uhgcud4lm4TLpw7iP04St52n6wxdoX8mlkvD8faSc+D8lhuBbKTikRRxlZgSkQCT3B75Vhb4RSpfKOAqFs56nCnwXAWVusidxnISAAUTHKUElqZzr92xk32Vi/e0sukf00e444EX2FvB4oMl+HAVXSPdChcx4PwU2JeZb8f6DNKWEUu/eM7oy9O5xgSkuKzSLx3bhn7cotGI3ARriYqV8VX8suYX0bCe6dCiAmMGeaLKBZnIM1D/vC3Gr/yVOd5ca7+aFSy87rKa7AvNCpF7xwW81OLUwTKgt8M8bKZhWFUwqDJqCkudBVBAtzD4b5xAHgmWg8AsQ5iazWhQ79ky9jHuIoqhyJjdN2kaIiRXZt6ytwy4YAv
 IUm+Ime6
 DMu/gFjZrSGPAR8mHC1rw0I8NcalSWG6EcOH9i5fUDP5oR75u4dM6TjJKAOCjf4gdNwGIhNiiQkrVKrvZsOsbZdNaC1fkHyYR/g4G+EQPw32j6+dCNvGf0PYV7tANLxIxQjeCf7fFpSLsGjXsvrZ/92AR/SQuDvEC+zqMDhXDaPLlwlxTpvSNAwor/AtByqAZLulmXsDz0a5vUBGnQEWN8OQspRHqnntjtiJTcWlLZbR81R1Yyo2572s4Xf1s3h73amAps6yp2tv6gs3hn3IT9LyG65aJOeQkD2/CByd7rFr3Thyz1AUBend4tBMhm9Bhyyo971loJ7LV+2A/xaVWFrfEREf5WuD6CX7w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 8:02=E2=80=AFAM Pasha Tatashin <pasha.tatashin@solee=
n.com> wrote:
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

Please clarify if you still consider that the user does register the
dependencies FDs explicitly, but this API just triggers the
"prepare()" or "preserve()" callback so the preservation order is
enforced/synchronized?
>
> We cannot do that, the user should have already preserved that file
> and provided us with a token to use, if that file was not preserved by
> the user it is a bug. With this proposal, we would have to generate a
> token, and it was argued that the kernel should not do that.

Agreed. Another thing that I was wondering about is how does the user
space know that its FD was preserved as dependency?

>
> > file =3D liveupdate_retrieve_file(session, my_preserve_blob.file_token)=
;
> >
> > And these can run in any order, and be called multiple times.
> >
> > Jason

