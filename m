Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EF7CCF9C7A
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 19:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551DC6B0062; Thu, 20 Nov 2025 14:11:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529816B007B; Thu, 20 Nov 2025 14:11:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43FFE6B0088; Thu, 20 Nov 2025 14:11:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33E566B0062
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:11:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBB2212E2D3
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:11:13 +0000 (UTC)
X-FDA: 84131928426.02.1246928
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id F0EA6140011
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:11:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VUu0+dsH;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763665872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ah4PI5Tf13M72+zbrnNAV69UwNAi5YkBZFZHyMln8zc=;
	b=54g4DoPWJNrHo68tH9R1XEW125AQTtL+WVeY/r2Lk4o7tP7KIssSFtmrV/wWO1dE0zeJId
	MrM2KHcOQsodPCZHS/NAxbPVuCxbFBQlQt2p0emlgJ4BNQfaHDvwlp2AnR4s7W1PLjCPNM
	27L2Z0GgtrEB3f19I6wCaEbw24N3tKU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VUu0+dsH;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763665872; a=rsa-sha256;
	cv=none;
	b=BcwFPAF5WhaBjxQXwkt7cBFkmiOd4lo9R7twnq5dqnJD2h2q6XKZ7RQ2MG+yvb27iujZGH
	XUjDjsxt01USb4E2Njins/zw7pzUjtemKhn92G9CAHCMMo4K4YA6DeAjxr3VyY0hJ9RZf7
	cWUJX7LEp3mju63pv8TeehtEWrS/G6s=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640d0ec9651so1907343a12.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763665870; x=1764270670; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ah4PI5Tf13M72+zbrnNAV69UwNAi5YkBZFZHyMln8zc=;
        b=VUu0+dsHnM1nn2USNJoiSMVlmMEe+vQhOV5P4GjYJN1/0RvhhrhbgulwXc/k8WxH03
         EUTtPjbPZQh874vj4rMB9ieuwto/rMnApHL1894L0I0LWab24iI+0wiilpAhvhIkNbi3
         7ow4YwKZi7ld16aI+KgNWYN4Q65f9JQfSGOBGmSOqDn1jG8AKAsFN7nOjGI6s6WWsOsf
         o5UpnU70SITeJdWlpQDwhmaVy7hhpugbijFEGK3hYXFoCPwCl7zxcD7lkHWYl7OUoxGU
         rXGVKG/E+OfWw0rJVbyYySprVMN6aE+wPkXb2WjCq0E24BCzBwSY8zONXetAppKVtBto
         Ngkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763665870; x=1764270670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ah4PI5Tf13M72+zbrnNAV69UwNAi5YkBZFZHyMln8zc=;
        b=jfa5JqmDpmQJ52ar2LRSWVcfDAgaCVbBfWR2V8ub7mgizS4K0ambcA0P7nBxAKRNC8
         C6uhbc2Fjw51lf5baFevG1s0ODWrmo9EhZVXlACE/sX5AeHCoX9soxvZIhm8D65PZ5mB
         oJFI1v/08XWE3FneE9z2mjkrTsMUSO3Dwy65LbnhMkacmKLAI2SMOlihIVyECP6ILAyQ
         H2KEmaIqUSvF1EirVAs2HQyyaV9qbv2fCCdC5yspDfNdXROqRMNKfmpbDObkulzx+/EL
         ZvdG4QEqA1VagnlMwGaCCtfzYgNIdJesgocJfdu5gOEhKX2yoUf2eLa7B+6mbTmzHgov
         VRgg==
X-Forwarded-Encrypted: i=1; AJvYcCVQUHyhEUEoHc12ISLwBoz4qpDT1Qo0C75qFl3gjJ6JetkwRzBLrdB6rGAj2T9mLz+Um5DfvMY9ew==@kvack.org
X-Gm-Message-State: AOJu0YzMNwof9wIX7UI9AXd7oT+VM6qZWpQDyAv6S4lSvFvH24zlFmGV
	0JHvTx3ocFC5EHYoZ5KIp67qu8P+splGyjFMlCGNeF1+yD5ChXFS0oNyHtz2d9++Segl14KSRRv
	SfBBuHVZBYTB1R3fVnlLF3KCxfLxwDEV+qF8Wupu4LQ==
X-Gm-Gg: ASbGncvTqLciqiMORihqce/kCKQ5KnIoIVAiiKZKXLxD7fNpkRhsMZIfMJpEG7JsKFi
	9U8TzVC0y8cvmC2UfZfyUwFTklN37JGatr/CLNIIX2G5lcAJduNDgViPnNh3C8S7gCDzfRQs7r7
	pXK0X8j1C2wR1RebONF9Ltnsul2WFBTcAONLBh91Vw8Ty8tM+U0AZtSjeWoqMgA7x2DPdJajkcY
	0tSLf+tPeYEFy42ucn0koKs20fn55jFITMlKPsekKKi7Y4Lbc2mgOeFXCoAqA8yTVvc
X-Google-Smtp-Source: AGHT+IH4WA4XmxDMHnQGvwWRqcCYMoQ95h8Cnb/tecHWkSne98BYp1s+lgZXYiOL0q0CCu+HgOArmo/0lwNHfSz4VVo=
X-Received: by 2002:a05:6402:3586:b0:640:a7a9:289f with SMTP id
 4fb4d7f45d1cf-645363c6b54mr3839432a12.2.1763665869906; Thu, 20 Nov 2025
 11:11:09 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-9-pasha.tatashin@soleen.com> <aRrtRfJaaIHw5DZN@kernel.org>
 <CA+CK2bBxVNRkJ-8Qv1AzfHEwpxnc4fSxdzKCL_7ku0TMd6Rjow@mail.gmail.com>
 <aRxYQKrQeP8BzR_2@kernel.org> <CA+CK2bASYtBndN24HZhkndDpsrU1rwjCokE=9eLZUq2Jhj6bag@mail.gmail.com>
 <aR9i9SXGDQ6bi1mi@kernel.org>
In-Reply-To: <aR9i9SXGDQ6bi1mi@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 20 Nov 2025 14:10:33 -0500
X-Gm-Features: AWmQ_bkna6LLJHL393cMjX0oZb4owkA8mCeUNJHS4sJFmwNTru1Npow-9jQRfrE
Message-ID: <CA+CK2bAA4qifTLpk27FtJX476Jr+VB9sa-NTUyo9nqmeWfkPPg@mail.gmail.com>
Subject: Re: [PATCH v6 08/20] liveupdate: luo_flb: Introduce
 File-Lifecycle-Bound global state
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F0EA6140011
X-Stat-Signature: j4i559975iawskao3864e5t1mwjshsty
X-Rspam-User: 
X-HE-Tag: 1763665871-562091
X-HE-Meta: U2FsdGVkX19yc26JYYSGXsozW8U+EfrA6yebrKnBLtLUSbONW6Hoy+Y+RhPQgINg0uhXntTq2s/g63B3TLV6Y5yk94azxa1gUYPJdpK43BjNMAfKHI8Cn/jzDtl6XAd9yLEqRSPkXCtqC3Zey2qSNUTGVYtiJRfrjLteSkp6YGlsvq/bqECdJ+lrXHU0E8Xc0aT7AqjJQImCjE1AVIj3cExbMfucZQ6m49HwiUcEmsyAJZDSf2b/Qbor+aQkfhMmP78w7gHmYtZbnC664ysUpHwnFogTmDlw+sUFLD+5Ek9myJxwow0dr29W7TMm1ck3fUgRbQBCVFg9CF0JYHQL/ijWCAflmVwgdMtz5Jduvvg7SHJAcgrFSbvq82xkDHhFNCNXDQUhxRfC4+/0D4R5tqwxzjUSnJhKsGTNk3WDugpdpqvFyAvZ9yw532WczRSGP4E4b5+dxbWKR3+h7gMAcxhtesnGmwtyhd3u6HlMnetvoJt7R1oldUWb9kWuLxi1n5hQbXQudV513j65ZLd/iRQMEN5KD2S+sXBY3vKz2lKMqbUkv5aOa9fgdGiCTM3l9oVUkSmzWRfiOjzsit6QqOtrlUUoyky9ZFXFaODoVhuLN+KkVhY40Yi0kRZeJczZ9EUvPl3p/+lM7NmDMMW3HTN/f681mbKICH3yt5/tBlvYmgcCiKNETZslmS+nOzd+6RJk+hdrVkqJu98gZRqxfAdDeQtqXv12m7+DoA8S6OMQh29f5I/0a5DeXi2FMQc919VBXkGDpSTB/CsR0o3UKu7VRguRq+FNfR5hGwjJqbeWTV4dDNf1oktb3UDOZ0dt8MO+xGgOjp6Tj03yA6+2pV10pafXrlFQrmUSFtrOwloXnrWAb6KCsBB4SUNoZNq6CPHWrTnHXqrKnj0LzaWhPNoTzA2SVOeXYrjENQu5X+VuurdDjfnT3tKW60tHPVVTmZSUBd0UKhCNv84CQvk
 sViflLwI
 HFi1czVPxYLbv+FdcG7MmpJcYXBPB0Jj6cYdSflhLaiG9w1rTsTtTLkaMoSMJ1GTyv9Z9O+J2UFi4PiJBqJnmm0ZkdeNcBaHnLDujbHidjjxOaed/pwAx+x/libIuxSRkIr6ozz6Wj7TwQYNSs46GA772PGy/oc9WdCXJN+5pqYefm2jG+iO02XA7hZB5fUYta2gi1lQBw6ujwXuaUcadPgXn9O34mZnb598gcWZ/ebj838yYoqptRKN1WZgy407/me/BdxHP/Vl9qaYZhmEKbhcuW4Hv9M78kU22aK/pDQuLV9gcs8W06mxxEh6benwiW+bTSgzM7Q+JtVo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 1:50=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Tue, Nov 18, 2025 at 10:37:30AM -0500, Pasha Tatashin wrote:
> > On Tue, Nov 18, 2025 at 6:28=E2=80=AFAM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > >
> > > On Mon, Nov 17, 2025 at 10:54:29PM -0500, Pasha Tatashin wrote:
> > > > >
> > > > > The concept makes sense to me, but it's hard to review the implem=
entation
> > > > > without an actual user.
> > > >
> > > > There are three users: we will have HugeTLB support that is going t=
o
> > > > be posted as RFC in a few weeks. Also, in two weeks we are going to
> > > > have an updated VFIO and IOMMU series posted both using FLBs. In th=
e
> > > > mean time, this series provides an FLB in-kernel test that verifies
> > > > that multiple FLBs can be attached to File-Handlers, and the basic
> > > > interfaces are working.
> > >
> > > Which means that essentially there won't be a real kernel user for FL=
B for
> > > a while.
> > > We usually don't merge dead code because some future patchset depends=
 on
> > > it.
> >
> > I understand the concern. I would prefer to merge FLB with the rest of
> > the LUO series; I don't view it as completely dead code since I have
> > added the in-kernel test that specifically exercises and validates
> > this API.
>
> The test exercises a simple happy flow, but it still does not validate th=
at
> this API is what we'll be using in the end.
> It's quite probable that the first upstream user of FLB will use this exa=
ct
> API, but chances are that it will require adjustments to "the real life".
>
> It does look sane, but without an actual user (sorry, but the test does n=
ot
> count) it's hard to anticipate the potential required changes and potenti=
al
> corner cases.
>
> Let's hold FLB until it can be actually consumed by HugeTLB or VFIO or
> IOMMU.

Ok

> > > I think it should stay in mm-nonmm-unstable if Andrew does not mind k=
eeping
> > > it there until the first user is going to land and then FLB will move
> > > upstream along with that user.
> >
> > My reasoning for pushing for inclusion now is that there are many
> > developers who currently depend on the FLB functionality. Having it in
> > a public tree, preferably upstream, or at least linux-next, would be
> > highly beneficial for their development and testing.
> >
> > However, to avoid blocking the entire series, I am going to move the
> > FLB patch and the in-kernel test patch to be the last two patches in
> > LUOv7.
> >
> > This way, the rest of the LUO series can be merged without them if
> > they are blocked, however, in this case it would be best if the two
> > FLB patches stayed in mm tree to allow VFIO/IOMMU/PCI/HugeTLB
> > preservation developers to use them, as they all depend on functional
> > FLB.
>
> That's pretty much what I'm suggesting just without "if they are blocked"=
 :)

SGTM

>
> > Pasha
>
> --
> Sincerely yours,
> Mike.
>

