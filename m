Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5893DCFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 19:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09346B0005; Sun, 23 Nov 2025 14:25:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1006B0008; Sun, 23 Nov 2025 14:25:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7516B002C; Sun, 23 Nov 2025 14:25:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 784076B0008
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:25:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2BEEAB637C
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:25:53 +0000 (UTC)
X-FDA: 84142851786.15.2EC274B
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 40C441C0005
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 19:25:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZWCLjL5K;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763925951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dkF1W+HmVNp/SmXP72a3xWNyOn0/uzHxCyV8VfqPJ10=;
	b=sjnuuujPKPEuIy7ADd11CE4pHJ8JlPtynCHku58AHJj+WvxBcKfQcCld58LL3C/BkiJ7zg
	ug3Uzm1x+NTpTBOgMWeX+VKJ+1D8C/XTnVVctz+ses4W9JbFfJLng/+kI7TGapJ1aR8cKc
	frh7gwc5TOG5ywmGGve6zOslpy9Ip90=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ZWCLjL5K;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763925951; a=rsa-sha256;
	cv=none;
	b=2O0rrgB/rwWWzxo/h7TpJOoX6H5ZNmmgskt3fZ7DRhGwQ6c6oYDEY1kYornVeQQ+S4Ovgd
	9sZuw6nkI12oGADHBzMl/eLm9SKT6ZzzcbrY0U6Kr7erPEaq4fQHZZXnRz5QzyHm0j+DmC
	D1a6mt6/OaRTD84vw5/b8rEHPkMagJY=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6408f9cb1dcso5357178a12.3
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 11:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763925950; x=1764530750; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dkF1W+HmVNp/SmXP72a3xWNyOn0/uzHxCyV8VfqPJ10=;
        b=ZWCLjL5KXJ5jbYlMGsOkm5DtF/LfmV9Ps/scmQctMTHzaogpZK6lHuY3MO7PzQUl2c
         OoRUYsl2U6kl/Kj4Dfymo8yNOKSLiJbH3dNPw7aPZQBvTy0+mFZvorwVjAuasN0A7sw9
         nt65FzDNQNAaPUqzSMwsefuQi0XZTnQHxfyDc6IYWdwgbGLUF1O6Jkut6pX7uavolPTo
         RF5/SF7eTXGVcclC/Zt2ueZGlEUXQYx9S5MUG/BwQ16D7tmKsEmfbA42UKI5pEIXr2Z0
         Srk2T43CGd/fDjy4Fg/qR1YC4h3zJ2R9cuoClOKpzB0g0rz781+E9aAOu+oK3boXPLij
         zmTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763925950; x=1764530750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dkF1W+HmVNp/SmXP72a3xWNyOn0/uzHxCyV8VfqPJ10=;
        b=QKRQ8OwHcNh+/42FqggrviqelO2rK0ojIP1wmxNzPM4FKN3eo/w+UFNhZ3hxRD4oLU
         gDy/0+85UlQHFTttxCClBFFF6n67qjZIhNei6OoRZMWpDPpbqv4bbTjYaBEmRlX3vH0T
         j/5THv9lAcTJ6gZMJomO92F18suAxQPLAVfj/E0yEtsfAJepg9xwvkQT7NXsOB3bzqgo
         2L/p3ttehS8whPkNPFsb0h/ucesPFi1RyHPhdqXE6KUIJFN3SdoAzuCql+e4eI8kMZCI
         hLi5+WxOvm+5Vv/fQyNFBQWmzZ2SATPmL/S8FvJYK9Tq456AqqYtlXHYgK9xSQY8L5CQ
         LXfA==
X-Forwarded-Encrypted: i=1; AJvYcCXCl0yXztBVqh1We7PDtmoxWVBzhYA8IiU3IEfBuYOadClQ/i5RTnbI2uM3fOQ7eqO/klEhHXNi4w==@kvack.org
X-Gm-Message-State: AOJu0YwPzUO66xCOsLI/k4muQr8IVFo2S6J/BC5HG86NqLEIKJ4K6Cwf
	tFTyZijUZTK3uhn19XQOhwBcF45oEa42J+Hiv43srKHVn1anpyWF3A4zZMtlQB48xMRrgeTPNVg
	4IrLAI025SMLnF7fOONxGl6fZ5NQiIPzriFGryR4uew==
X-Gm-Gg: ASbGnctObbFvewghMGTb8UrCXSwTaQeyIUBEMkADeWtsdHPQr3VfLs2Gi69W6iDtlbU
	lHlJkMxRaHQJ+BAbck4R0w74ir5LJRJNyTPjgoxSQgxJ5OJhXKEhgI1xDP8qlP/noNURvMUS9GL
	QyGuV3cDE9hNFgpvoHDuHnZdAT/AIUiiU68XS9FBFRulwLsYRQ5kJV+Qu70G07/Tw8kzX/yhrx0
	EWV7LV5IyvctFi+wHJPtEAw7Y8+/rRPTlT/3inED12OGRI5O58EbIP0YvFiWx/4Paxr
X-Google-Smtp-Source: AGHT+IEAMY0pvJyme6T1x/GXi+zAz7fUHPUOcouP4DWp2W4b/iQCr9XdKr/m0KnneLDceMLTWxGdGs7cWzgaueOTCwA=
X-Received: by 2002:a05:6402:2750:b0:640:f1ea:8d1b with SMTP id
 4fb4d7f45d1cf-64554665a54mr9031837a12.16.1763925949554; Sun, 23 Nov 2025
 11:25:49 -0800 (PST)
MIME-Version: 1.0
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-6-pasha.tatashin@soleen.com> <aSMX_pnUShilO_sj@kernel.org>
In-Reply-To: <aSMX_pnUShilO_sj@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 23 Nov 2025 14:25:13 -0500
X-Gm-Features: AWmQ_bkm6GWLaDGmSYxA_sDe-BfkSNdLO3VJvb3Ilu_NQl85-GJkxSTO8YXhl0w
Message-ID: <CA+CK2bANLwj+nqDy8_dXgCBym_VFSFW26naqC3x7XED9tC-TYA@mail.gmail.com>
Subject: Re: [PATCH v7 05/22] liveupdate: luo_core: add user interface
To: Mike Rapoport <rppt@kernel.org>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net, 
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
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 40C441C0005
X-Stat-Signature: 5toxdbf48awwe1n31yadrxmkgqdo8d9d
X-Rspam-User: 
X-HE-Tag: 1763925951-413313
X-HE-Meta: U2FsdGVkX19OYimd9IHgtMYZgCIsFBowGaH38CSGm7IyGwHsMXA022cpm5ZVrd4lvzSULspiVrh+63ZWKQossk+lxVyX/gtoEnlWErTKp8kWUVv4fe5fjr5AEoOHFpegku0p8fXM13j9Q9ycBZkmBlEvh2tgzdmockr6uzZMuVYyXzn3LHb1SAlg3X6NLcnJcylmM1hQ/78meynA+6x9OFYa4SNMIJFR2dk4j5Y+flGTO0e9529qEzKXdTTl34FRny6iRLvdrGU2OFRaVy09Vbv1hCNspeYv/7DnrZ9JiZB0YfnYIBy6X7nkKOr70JjHC4R9MdO8KS7xFyiNzP1RxoZPezyn/8FoKXZVj9oo+IzCRiJNw1J7pojT5i1uz4GEsiiXiBOF3D3ZLzf/BpSKa813NkASiyrtBXkm/irk05rCYlhklzq5piXo3ebUCcxpru50KGDMKBm4w6StVPE59AUdZXXbPB2fT2Wzb071zJ7vzw21sCjN7eu57Z3cccUh+SJdMbSOQihUztcFqNUAKISSqbUL8cepS/kaQ3xT3wYuoX4qgPEy3Ulo9zyES6imHPb14zG/EqA/RDlEY3nFRX4Vdw54eOd7WdFxRbK8czE6IGWbL2V+CfH/3J43/ulZtPslnZ7jOS698INt+5v15a1AFxlvj0rgwQ6bntX4Nr1Rb+qbEa63q8MSBWxHduPbxt4rhZc1MqIm4jaOJA1rCAC3igZGYW+NDoM6DfuRbXAPHdaYFSP69Un+69MjdAN8KRpnt+t0qSy636rGsYn6ndHO/clFKNsrgIpVicZKdsqnBbQ+GAtytvQGzZZlDHSFzCZF6MvDg/6kaPOYIxoSOuhmdJxFyIVmkcXDmv3DLrCA7fO3X5tnLio4BfqLUnFRnTi3G1mGEqtEq3r+rOEIdlmjFqH0Gc7X0RMAk+kzYQ3WxDyli2uvQbEbGIfX5z1zYuBGyOLNa+t8kGb45bb
 /WfY2NrV
 qiRiVmYXV7l1DFOTjyQdcXfOnLnlzHGlkRjfisDpJUHjvnn7XwERBmqzIHQ3ZFgwHO/q5uLRgcUpWw+OtfLCTGsUbqWC4injc3Q6MaiEy4n8Q/nkuu2BkQKfyrAL+/V+7ycI8Frw4AtGnEb2/7UKGu0VzjUlSrKCqqkyQCWMfh5NL3ILTUiMYGURyyYdHqAyrQGkgdtDVSLtg27c4cWyPK+1X7hjKWflMiS6o8qZnRe0OMjnXtcGE/N4qKx5MvRk5R1vBzPp37H9OKReRQsizw7S5MuVCPp4FwQ5pT2Gkn6JYMWBUrxEqJixMY46Ei8jfMsObY53qTV5oWFVkO+V3jYIvI/wl3ABw6Uar7s9GieIpzKXwSYy4y49VxysyBPtXETHtSz6vZjNErk8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 9:20=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Nov 22, 2025 at 05:23:32PM -0500, Pasha Tatashin wrote:
> > Introduce the user-space interface for the Live Update Orchestrator
> > via ioctl commands, enabling external control over the live update
> > process and management of preserved resources.
> >
> > The idea is that there is going to be a single userspace agent driving
> > the live update, therefore, only a single process can ever hold this
> > device opened at a time.
> >
> > The following ioctl commands are introduced:
> >
> > LIVEUPDATE_IOCTL_CREATE_SESSION
> > Provides a way for userspace to create a named session for grouping fil=
e
> > descriptors that need to be preserved. It returns a new file descriptor
> > representing the session.
> >
> > LIVEUPDATE_IOCTL_RETRIEVE_SESSION
> > Allows the userspace agent in the new kernel to reclaim a preserved
> > session by its name, receiving a new file descriptor to manage the
> > restored resources.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks

>
> > ---
> >  include/uapi/linux/liveupdate.h  |  64 +++++++++++
> >  kernel/liveupdate/luo_core.c     | 179 ++++++++++++++++++++++++++++++-
> >  kernel/liveupdate/luo_internal.h |  21 ++++
> >  3 files changed, 263 insertions(+), 1 deletion(-)
>
> --
> Sincerely yours,
> Mike.

