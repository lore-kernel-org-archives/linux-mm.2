Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24500CD4845
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 20:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DC268E0010; Wed, 12 Nov 2025 15:41:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2FB8E0006; Wed, 12 Nov 2025 15:41:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8E28E0010; Wed, 12 Nov 2025 15:41:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4740C8E0006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:41:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA6744CF46
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:41:33 +0000 (UTC)
X-FDA: 84103125666.28.79400C7
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id D3AD810000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:41:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HszrvRjZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762980092; a=rsa-sha256;
	cv=none;
	b=QogiM24KxkP5iqxfW2pl/3FnmBIpRRn0qSo97kPHezmSpEAHZH3YivyuABrVM97z+YksDr
	6UPJoQXG+16mYqjcLcTNGMtNv/C+ll6sD6G/AxsfIsYSUubJWIDY3Fy2Z2u8a9fCYwOKyR
	w4LBhEHx/Lu4/yyeqG9Ug8QLsovEOoM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HszrvRjZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762980092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhyXtoYIzmR1qHGhz6TVmqBXuiqas52bqmxrLwkY3s0=;
	b=7OsWLFmamwVKLdLnU5mVSNM5uAAn2yQGZieOjKpAVfOKID95IwbkSKaPfRyhRVaq51jvbw
	CMR//oldoZAemYzUq+3LF6Sst2F7nVXMU2Swb1hFHOjOTDoiGcmP1zhEpAZ1xHYasW7x1Y
	JzmBwpcDMHCUb5cZABDVnqpZfke1MEA=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-640e9f5951aso2054331a12.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 12:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762980090; x=1763584890; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dhyXtoYIzmR1qHGhz6TVmqBXuiqas52bqmxrLwkY3s0=;
        b=HszrvRjZwywGjOBWWv61mGEykBDilf2wZ/8I2IWDrAbbpgmbFxwwLYKm/thhYCi6Yc
         1XyitckRz0q68WiYwRHas8Xe0Nu8GHkmpItWGbNE/TRvPuX89/OtPNeV+Zx1xVAi8PMn
         vcN34/cqfZf06x/fsMuRXrB+ES4UkPu5hDQGUEgwbaGNEBwHIxZ2CFD7rFRccLBd+Z1W
         QhwORevooLWvNJW2moFmEYAdBNMxl6RpKOr8+YMZhcIL2FkrYGc+/yMkxI+wB49FV8hi
         kdToJx/iGsraevqVouLdQw0+9Gtq4pZuzi3cuTD0qz+0rppbKa9f1Y8fGfWjD2iekXTn
         SGAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762980090; x=1763584890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dhyXtoYIzmR1qHGhz6TVmqBXuiqas52bqmxrLwkY3s0=;
        b=wd6t/o3n/4bf/Fem6CKUXEFBh6X5fMb+UP1x+r7f+VIJi0t7RFy1vvCQRbuR4Bj5cw
         RxB9P11zAVX80jCfzAEZOCpmAYuw51A+tz4yw+YCOT0bJbaH6PCdgHuAnYGNRNQzEl9S
         WM55xYiiIjs2K9bQGB+rDCFrQ7tnuefeIpPumpAjjOxBovn7c1/30aE1/EE0eCnbt8ze
         X9BkHycjkMW7D59Mh7pSKnXjGiFyTnbtmVWAILSVy/Pb7BEIB9igz7IDJ7Y+qhRi39xt
         +3SLlO9hoZIyKseYTV0k79F/FTuATnoRINZldFyGWQj1IWwwklRIX5H3ILHZz5Sj7TzG
         2I2w==
X-Forwarded-Encrypted: i=1; AJvYcCXCRp2aw/+57FsluZo9BhOM9mvgoyMavNzOiO3+YYJDQwq36PpPVd6gi8yvcR0YjYFNTdyiOwp+rg==@kvack.org
X-Gm-Message-State: AOJu0Ywh4WSEVuc33CZL3rzvWgeloA0zYUe8CO68ySSfOqTqMQ9wqLXF
	IJd2xY3TIkmdfj2m8yR6i+3syWE8GU0fJcamCYwzRAK1U+5RAk0FaywUXh8WUIINknhdQzeOOyW
	52x4IX0YlPifXdhEyaE0a5rGIl4Ay6WF9c/dZhfKh/w==
X-Gm-Gg: ASbGncuFIgrP9EJLm9XXSyqqDL6u4nwDajUsDb5QvfeCQir6uINqcJnoA7n1+73p4x+
	TfWQIpVeO4TRGSC80O//pJSv6L2simhrMqGOJUE6llNgwu/DrHzoGQIbeHT2XDuYF/mVAcyFFaA
	+euauTOs54+Dq2c6RcgHkZQYBKQKVHYXJr/JK5tau5ARIHh1iiULMKt97l0s88ya0LzeSLd3PB9
	hwuD+6ItZ2p/WEiVJ3zmaE2nRNgvTS0ErDK7f64dum5RqIClgEq7j93bQ==
X-Google-Smtp-Source: AGHT+IHqo0cWs4d/0+ME7Pp4LbR8c7We/VnufInTVc25I/poQ6OzmFZFO8BkwH4hrLb9dn8NI1Qgpj2DiapmSAwzhV0=
X-Received: by 2002:aa7:c9c4:0:b0:640:e7bc:d3ce with SMTP id
 4fb4d7f45d1cf-64334cf0fa3mr536431a12.11.1762980090000; Wed, 12 Nov 2025
 12:41:30 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-23-pasha.tatashin@soleen.com> <aRTs3ZouoL1CGHst@kernel.org>
In-Reply-To: <aRTs3ZouoL1CGHst@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 12 Nov 2025 15:40:53 -0500
X-Gm-Features: AWmQ_bn7hzYlz1CnwhflDe9tj18uCKgXHbii3rFfCz-B6efDQe-vtqY1VtpWQlg
Message-ID: <CA+CK2bBVRHwBu6a77gkvsbmWkQFDcTvNo+5aOT586mie13zqqA@mail.gmail.com>
Subject: Re: [PATCH v5 22/22] tests/liveupdate: Add in-kernel liveupdate test
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
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D3AD810000C
X-Stat-Signature: yntiekaxp1jcqjbs3ojfyhx5ddgu688f
X-HE-Tag: 1762980091-226448
X-HE-Meta: U2FsdGVkX1+lRie4Sv91I3phWZTdNZYmfVWcCWQnx6h7w3aeowgxq53r5ibNZF8Zze6LJQenuwL+xSWUuJUop8Zkf/sbpFDYymQsrq4axoHtJ3Sr81+mkMpW/hO/ONlCeFykQfjSJkhaKYWTaecQhVPncTiwEDRujce6s5LAvGNbvjubmxqBKYLCFmhKFZ/SFfwcwGEzzndnY3R3SbsHdNM7UEGljgqX3/43xcrE1gagicwOZ+a9mHYoWDAdM3lg3qlsOh8q2LBqi8//zTIzmw0LT15TvX7AfEFVSv3agylwxEIz7xiWknzfwODSDXeH9fG+anQCxFGAWCuJrApGZ5UntPNjlWnvjARfn1WwHvCB6l/H11l9cXEtZTDU6fgKHfqN4lPiGqlVoFob4wAeMi8qKFp3Qwi2kAWAzDcI62ToUjGq0XvSKsOx6aGh0O6kJgcbC4sl9RQNXVLrWLBnbHn6wqlRAVoVkMUqjJpAVJyjO/srjBi6jsPQjrGt/29mi7KPGu8hsmSMn/OjSkPo2mKpjlr8c7up1SvtDn6Dpm3eUEpujPnN8F3xQqge5I3zEfFIs/mgGo2FCQY85j10FlUNXct3sgLsES/MIuLYLnT2attpqbInhra8oTRNodNG/drLgN2Bfp0CRTfNB0PrLyeOQIv7QGjcZ//wOPrqniIVRzI+DiDp1NgDt26mYeeq8ajbCVOcLDjQ6pRetO557ZlxbkrJmeFhAmBxHb06u3I1zOiCfdpOgove099THIly/jgfoTUQGM8MNhsJNZzgSLSjhgQ9/7HZaHTSkg3N7FI7jbOmbXaEu/diJgxvgDH7bMGzGrAXac4v7pZIob99UPmZlVB9MoHhfGgGTO52pvmrcmi571111D0VpWmQCLmIgeoQGCkq5FCu+UyjUOCv9glHPzy0ZuCn9glkytqITSyjJoYjAq6J4ENJuwQ2ju6ccPVfAT5O7fh7uDjStLD
 5d8Fcyb3
 56EgfgDqk5dWrDMyTkw8VojZVi1KV4lKdxyARdq9iA9S+3lgBiSa0fqT66cJqnsLJ1bmNRhTKO/lc+SE0xo33wqPpef736SJAVIOXcG430/w1PBuWMcc52w+g++7GHPXBH2L6Xsy1sPfwlGTR4pMLpJVAMdAtPQuPLRzFoSm6NuwwGJg5b7Onqntc0oxCLpbl4X3lpKS1+Smb/oj6y3axQliLQtqZpTUndqnqyng+/BrqBOduYqweX7/31vR1h759H3NZwxiSLE6dbxfR5FQqvd55ykSnFhB24r6YSNszYjvw/DETvspZI7Wf7QK3A5MnEfV/vbfd6CUFlVXYLWvaQn1zxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 3:24=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Fri, Nov 07, 2025 at 04:03:20PM -0500, Pasha Tatashin wrote:
> > Introduce an in-kernel test module to validate the core logic of the
> > Live Update Orchestrator's File-Lifecycle-Bound feature. This
> > provides a low-level, controlled environment to test FLB registration
> > and callback invocation without requiring userspace interaction or
> > actual kexec reboots.
> >
> > The test is enabled by the CONFIG_LIVEUPDATE_TEST Kconfig option.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/luo_file.c     |   2 +
> >  kernel/liveupdate/luo_internal.h |   8 ++
> >  lib/Kconfig.debug                |  23 ++++++
> >  lib/tests/Makefile               |   1 +
> >  lib/tests/liveupdate.c           | 130 +++++++++++++++++++++++++++++++
> >  5 files changed, 164 insertions(+)
> >  create mode 100644 lib/tests/liveupdate.c
> >
> > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.=
c
> > index 713069b96278..4c0a75918f3d 100644
> > --- a/kernel/liveupdate/luo_file.c
> > +++ b/kernel/liveupdate/luo_file.c
> > @@ -829,6 +829,8 @@ int liveupdate_register_file_handler(struct liveupd=
ate_file_handler *fh)
> >       INIT_LIST_HEAD(&fh->flb_list);
> >       list_add_tail(&fh->list, &luo_file_handler_list);
> >
> > +     liveupdate_test_register(fh);
> > +
>
> Do it mean that every flb user will be added here?

No, FLB users will use:

liveupdate_register_flb() from various subsystems. This
liveupdate_test_register() is only to allow kernel test to register
test-FLBs to every single file-handler for in-kernel testing purpose
only.

Pasha

