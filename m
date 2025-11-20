Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD4A8CFA441
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 20:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01CB26B0005; Thu, 20 Nov 2025 15:14:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36646B000D; Thu, 20 Nov 2025 15:14:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73966B002A; Thu, 20 Nov 2025 15:14:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9C096B0005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:14:28 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C75716035B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:14:28 +0000 (UTC)
X-FDA: 84132087816.11.B418D31
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 92A0D8000D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:14:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="ES/WAY1Y";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763669666; a=rsa-sha256;
	cv=none;
	b=qcjt9hejlE88iJ2h42/haGo6myDHQiUNdeogQcIcm7oeRbG/NzAwaLb1AqDsOGjAKCw76G
	yV0gqqPenmzfckdn3ELXg97zo6GaXdWappk12CZ2PJy96gzSXddHVt+YbfRLHdaKd9k2nj
	a32qBCwEgjcIcS3NSp08Y015tOfk+9s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="ES/WAY1Y";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763669666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+omO3PV5a0YpXXLvwNkeXHR5K1gWkBI2kB4nQSAWDK8=;
	b=cFkCUwq1teRupzdJeDvKe8/2hjBiNe8aYcOhjg0Ib/A38tgcVejfP3Bhd2JTrJKszF5aB2
	TDIPlSaM6ADs+kVSdHjeywsl/2ZAHcJvaptcDoKQ99AH778onGIshTCBSMtnI3SFyoLA0S
	u2HCDG6cTPVw8NAEcdvZpTdeB73AyQA=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso1374647a12.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763669665; x=1764274465; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+omO3PV5a0YpXXLvwNkeXHR5K1gWkBI2kB4nQSAWDK8=;
        b=ES/WAY1YDLTcOd3LDSQE5rWfs/4tU8c0oQ0jg21+gAQDmMVYWkmamzfK6IGmJDIIQ/
         nhHXm+GMZk4gxB4ON13xX6E8EIzuGHgoWi7H8M5wKfHDx/Zqctoq809pXOarmMnBXhqn
         SaMgtoXGRiB5dt/hvp3yGJ44HgHxBo1Il88YKSobAjXTvK3lKFtoYGdTG44RYTG/9Z69
         vSsuhwUxE1dnCOqiVIoTGUelY9pH2HFy/EmuRVJy0//eZeS+Lz2emX098pGKhvvsm2XT
         ZTxnE6sqB4ieqW6La7uLXU+6wTXLo9JDXsAOucm6Cs4R1or4M2ZY5qye38RVngPbdEKn
         sbwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763669665; x=1764274465;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+omO3PV5a0YpXXLvwNkeXHR5K1gWkBI2kB4nQSAWDK8=;
        b=mDsV/CuQHqZT84aeQZjF7YuBFYtaDs+Jfj1ndQUissss1uockeHYEuUMjxhKw+x54Z
         MnT8UvccDTfy9gK96Zz4k4pvrzVxAyr7+NOKAqsr0QA3sZeCUrUQ8Jn6KA/0w/gl6gh5
         SUO7ndcroxqo2lzRX/a0NpU8bbXrWux6Ez8caB3oQgMCemp79DMAQC+f5XjqIQHMBXpc
         SWi17UL0aQlena8PS6gA7sblaC2jaNuwkeZdO8p8n/HtaWlMEbFqAOzrO69NIbks7V6v
         OvA/49kxm5xKfMHod1WxZLIWl1E9QKnt2f3CdSoyDas5fN7ULK8FVQq8+QNr7rxPmPmd
         Tgwg==
X-Forwarded-Encrypted: i=1; AJvYcCX5imqf+g4fKLHyG1DtoipezPnU2VUwOyBttorYFNoMtKM8J0A+K9ESTWnrbBYMTjhdU58P4HkssA==@kvack.org
X-Gm-Message-State: AOJu0YyHoWDXgPVj9EzTchlzbjyPQ3foIqBeYvPUvzCUlEkMjAhYlU+a
	RCcpNSIF3LgUrI00LTk63wN3bv8Lhw9R44xmAtOnpkw4AFlM9w/R/xAJDklko/PTnOFsrUNfrTk
	u4guZydDk5j3bAet9RjA5EhRStBiXmt1I6xdCBH3RQg==
X-Gm-Gg: ASbGncv0qIlIDBfWYfH+Ci/ssPASCeOkirJ0AcROR1yZiv3TNVjS8p1VugpHV6W6uDk
	yRpijtdIJ0XPPZBID5IDy7DOcAwMw1eVa2Mad04w32hla6umDalmheSB/4vWNvwDuQupak92l3Q
	IgMyZryQzPmwkGhDdOWhFpY4WyKE4dTntDDGO8NeCQsiZ4VoJWo63VuUp0VAw4TTt8Le0T2tCW9
	mtXUWbjQvl3beqc1fBewGdebbygvR5xX3nk3tTmTbczYKwOS+gO+vul+PYYhsjEdkoKz1s41s7x
	3LI=
X-Google-Smtp-Source: AGHT+IETa8hWOUfKCvI3S7y7dFesOn/0oRFaIqYivthoGyP3sfDzcaEBdtnkETAlUGKTRLP1/+X3Uvd7Kky/elnwLAk=
X-Received: by 2002:a05:6402:3509:b0:63b:ee76:3f63 with SMTP id
 4fb4d7f45d1cf-64539667b0amr3359932a12.7.1763669664757; Thu, 20 Nov 2025
 12:14:24 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-6-pasha.tatashin@soleen.com> <CALzav=c-KJg8q8-4EaDC1M+GErTCiRKtn5qRbh1wa08zJ0N4ng@mail.gmail.com>
 <CA+CK2bD4Y3CMHcTGKradmv-hAbdtA7zsw2CYeh7-8LNianYMZw@mail.gmail.com> <CALzav=dmFQr+BrqzRDgio0q68MPRVnZPK4-wUXVj47o1FObgNg@mail.gmail.com>
In-Reply-To: <CALzav=dmFQr+BrqzRDgio0q68MPRVnZPK4-wUXVj47o1FObgNg@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 20 Nov 2025 15:13:47 -0500
X-Gm-Features: AWmQ_bkiZMs_ib46GqJJAyFDjxnjrkzfc-NJQCiTAHteg5hCk1-ag1G4ow0v2YA
Message-ID: <CA+CK2bAXaMdp7rw8RVWNpfunu-XW59RjmdhwmEwZtCZohrdrGA@mail.gmail.com>
Subject: Re: [PATCH v6 05/20] liveupdate: luo_ioctl: add user interface
To: David Matlack <dmatlack@google.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 92A0D8000D
X-Stat-Signature: t3n537qt9k6pwtwk69tu4hnu3thuecj3
X-HE-Tag: 1763669666-292817
X-HE-Meta: U2FsdGVkX1+ggvwRLMV3fpewiKbQuQwbs4hs1zXC+pmjejt2f5vXjukJpOGTrbFGr8RKKSsdGt3mAO8ZlJPhM0r8Ysbo1JOxniktZu2UneM4Tfm1yCs3cAjGjPSI3CA0U4RFqsj2xjJezXPTibToMg5jIsBHdyw/TjNV5B6ZDfAJJQXjXGIngxYXdRsFW6yC7S0cBKMzFVTRmG+EfHULSO7ZN5Drf2ny+bMew8kvTleK7XDmBQLg2WDUQNyp/1SPyoa47+yNWLmFEfXG7FuWwF4+H517zICk+TpSS/R7wxAH9bbhoi3iQsNR5yWTMUr7v1vbif24DBbLlLWZtA0qGODWQgaiigq0hUcqtPLqlcZE5mqEJehc1LNYDOgZJVemcF++1NaiuPc0Ssu0br1tQmmHd9TPybJ7BTyiPcCJ5C905gET7Ls7A+yq7mDEfwF8Rx9HGhtBDs9y599rho2rqx08ltSSe9CTe8ocsAGOCdTFuWjucAPnppNqBc1eTZta99/3DPmavAeyP4XjsU9RbsMNwHfra7KznPz+M9piz2nXBxY4P/lQAcIbyseLvACmoSttimKnVRbiEM9qbczhdLoeyPFj5DvI/yOGUuG59zNxOe//AyEfSAWQreHFsHjNcLQDiIe8zXvWO1Mk/Bk/z/anHfM7ySA+Rpvrq0omI8dLucpfI0VTnSICJin5iCUyZJQEIucApUrO6RAqD+zpX9Nfj+aUDjdmU6Rd4PxZiP8KyT2fbA003i5puhF4SLO/+r+58b7gZtFP4/uUUcYNMR2uP4jH2JELpYoI9kCGaBYdye8ixPfNmREz71o1ZzSq8ZnxSsK+TgHWeJiTuDy0JnkxN26yjlpn6BJwraxEv5P+ZOKekM31TG/QrnHQnawule99fyiHv2KLPcImrbfx27Bl5B6B9WS+dFE6newwQJi5wb/HnjYSos1kH7PL7dDONY7Le3yDzjagJuJMuRq
 tDn2z+Ge
 5c8yXBcrI9DjqJxphNDWQhWawtnQQFq6Qu4ArZJsxjT/yF8B/XyFKszHwqOLc3y8gEaqaMUtTXPN+Hui+/9VldRBhRYwOPZU1UeBfabbOx3yLzWUNNb7H3ilq0e8FKuM4e3r2Ty2DMnB8+9hXENueEq2sgckIk5lZLBo4pSZhywm73PfDdfwNx7QyA8uPLuZTbnynesBsDvo/xUJRd7ibmW5Slr4fhChcoIMzpta+jBIItoaIc0EDVy9JckMc6As1fUG32x3CmuhqyeYzvvCLEpguJHyWJbajtVn1dSkheh1XNG9PdeeAjgDsbqr/zblTQHYvdBTNLvqliJGj31HtiB3cV5WfKPKZnYABSAYEQ5hhD6JV2zwdYvSCnOHfvqp/iuzyJRDxxNXDk48=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 2:43=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Thu, Nov 20, 2025 at 11:23=E2=80=AFAM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > On Thu, Nov 20, 2025 at 1:38=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> > >
> > > On Sat, Nov 15, 2025 at 3:34=E2=80=AFPM Pasha Tatashin
> > > <pasha.tatashin@soleen.com> wrote:
> > > > The idea is that there is going to be a single userspace agent driv=
ing
> > > > the live update, therefore, only a single process can ever hold thi=
s
> > > > device opened at a time.
> > > ...
> > > > +static int luo_open(struct inode *inodep, struct file *filep)
> > > > +{
> > > > +       struct luo_device_state *ldev =3D container_of(filep->priva=
te_data,
> > > > +                                                    struct luo_dev=
ice_state,
> > > > +                                                    miscdev);
> > > > +
> > > > +       if (atomic_cmpxchg(&ldev->in_use, 0, 1))
> > > > +               return -EBUSY;
> > >
> > > Can you remind me why the kernel needs to enforce this? What would be
> > > wrong or unsafe from the kernel perspective if there were multiple
> > > userspace agents holding open files for /dev/liveupdate, each with
> > > their own sessions?
> >
> > By enforcing a singleton, we will ensure a consistent view for tooling
> > like luoadm (which will track incoming/outgoing sessions, UUIDs, etc.)
> > and prevent conflicting commands regarding the transition state.
> >
> > This is not a bottleneck because the vast majority of the work
> > (preserving devicse/memory) is handled via the individual Session FDs.
> > Also, since sessions persist even if /dev/liveupdate is closed, we
> > allow the agent upgrade, or crashing without requiring concurrent
> > access.
>
> Yeah, I'm not concerned about bottlenecking. It just seems like an
> artificial constraint to impose on userspace at this point. The only
> ioctls on /dev/liveupdate are to create a session and retreive a
> session. Neither of those will conflict with having multiple open
> files for /dev/liveupdate.

Enforcing tooling consistency, and improving security for global
state. Otherwise, it can be relaxed.

Pasha

