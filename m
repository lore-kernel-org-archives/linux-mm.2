Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07FDFCD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626598E0011; Sun, 16 Nov 2025 13:36:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FE198E0002; Sun, 16 Nov 2025 13:36:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514048E0011; Sun, 16 Nov 2025 13:36:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6178E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:36:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5EE912F286
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:36:54 +0000 (UTC)
X-FDA: 84117326748.30.512084F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 306A2C000B
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:36:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fJys7Lvs;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763318213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1KLf9g9eRsyKU3YHNNleyg6ZBr1Q7RxAULhWibcGVbE=;
	b=1pJx//X1olltJOmvZo+zkeB5kxfFTbTHbkkjoRXwWRLUcTsQYls4CKBF7ZyDYV9HyGgbZ/
	h9njm0oDMeVyiBWYeZoSzr9k2o8joTCG2J4KtNHtJUp1okaMRnWM1Z5xyp10eecyUoZXDU
	jYRtPINNviB8mgyIAOwyo9GuwU4St9A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fJys7Lvs;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763318213; a=rsa-sha256;
	cv=none;
	b=HVAI7L85CiBBnaRODRODQ59YBYfLV4y5m5H5BceLh/q6rC9DJSgPJUjjiH8v/8nWMwZLeQ
	z6dDbDt8i+cgT7eRMR1R0dXQvO2JKtVHoOHIZsUaZeLrCNxZURfx0ZhPHCbqgZCUaU5lMk
	OGBKp6JBS5s7TkbFYmYWtttBrm3RdZg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23DD243C8E;
	Sun, 16 Nov 2025 18:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DB7C113D0;
	Sun, 16 Nov 2025 18:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763318212;
	bh=pUFOQlfWPQVHlNRZMItbyB86PfyTKPMdohxZA/z8UcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fJys7LvsoVVVknZjFngPHDcjKFn3LaoAIMuXeiTvlE4PVCSe5jgn0CdghHhAg0i+7
	 Nq2qRiOkWybWy+d6dFjpmNUOFeenqV4chIXDaxJFsmRi8QxmuCeJmveoJXBeOTxPRX
	 RvQpXRKnKgfMyhMMLeI3nasaM+2YMYesYC1x13IagcjQBxX4f5mxyem4INd98mDX8c
	 xSC7aldwdEtvZR8m8wMMPttXxkPwxxcJODN7Sh0tH8UU/kpioNP9NBhkpuNI63jLtT
	 CnwTwjspBvrn4SdMhyLmlJNsnoJCP+E1Za+iJKk64XotlBKhWUoASH6Lckowy5wylQ
	 GlPK6D4vo4kmg==
Date: Sun, 16 Nov 2025 20:36:27 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v5 22/22] tests/liveupdate: Add in-kernel liveupdate test
Message-ID: <aRoZq2bYYm5MGihy@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-23-pasha.tatashin@soleen.com>
 <aRTs3ZouoL1CGHst@kernel.org>
 <CA+CK2bBVRHwBu6a77gkvsbmWkQFDcTvNo+5aOT586mie13zqqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bBVRHwBu6a77gkvsbmWkQFDcTvNo+5aOT586mie13zqqA@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 306A2C000B
X-Stat-Signature: baaaaipb7yyi5cz87ejug1kfgi3tp3uu
X-Rspam-User: 
X-HE-Tag: 1763318213-846171
X-HE-Meta: U2FsdGVkX1+27slPpq1gN9XStT40sril9dAK6qnW/cTR63MyfS0/7yADKLb3W8qer6LR8h2B55bRDFH3R3azCIWrdkDAcL6ndpChCcLqf/BZp/ErsSy3KNQ2Xvxa2QKbD0IfnwMTlPcv5VPZ44JxX38aXZ0ToAxuGq8vkfqapMO6E6s6cvyDaKit4Erec3LYjQxpzuSpTfvnjAvSgOqvHBXhO/oE3ctxDBVqNkRz4Pyvf7P/xnP23OGgqjtQDo+iuxJBbFwYapB/bWWPxVJWQoOlmGeupy/vkbYEVwDtFf6N8JmYit6qjgoSFWtZSfFpDma7U+/fsSGah1IoZKcm6loMkC6gSrTGz5SLLcCt0CAhdx7o53FOU6fbdoGkFnaAIn2FkbJKSYi3eDlPvr0llB2/cIiqyEPHb/Lte4p3GJEoJN98vkfLFaV07MtzcYUXmh3VnOjrYNbVlKZUuS4F/ZVsUrSs7dwu5qw0iQDojZMqvr+57j4WV/ta58Xo5OKkyFOsjr7otf+o8+43RH3+KN0G9Xh0w+L7M+CiKDaGSMS4WM7Q1yxMN6qKp6t+VkcI8Cmiwys0buXGv95UJJ4IFePeORwL1WkIz+E589IEtXD5r8pZKihMoabseeyfN5F7bUXC/uwVgmbkwuopP37wx5hgU1rlHqquhSQa4yVUTbIPFRbsZmpmvM3K/Qarfgb4zCFPSuBlG0RIPhRPh2PKR0ZdPAvi7ch8qZ0uSrFwpXWPNkx3qsXmAUhTr3OtcT9xpMsiCsezEz6IffDpjw8pud6miubXPpr+QTdNK9OJsTj0mJ9caFRr1a6T2UAboL/y5Eq67gSCYJ5zG9dJkBeiUJE3nmbL+xwczY2jBPjFfbLfcBlaXkkU/k010Qk0y1XaADwm9BVAORfdAxyWf3EWec25pyaa3HE5qrCbB20SGKYsnKRWeqOqJqDahWVl65KjaSbvtYcFeV/D+8ij6DM
 KmCF/+li
 D5MQdzQMapahyO+Te82hoJxt7Q30fiMz7JnB67rRSNWOWCoSBn+5Tf3J61qKrEz7JIoZnIQO2LE53AlAwHPZxhFEyXDzmcwJCT3OCtOgnBsNSiKVi0Cq8PrhiqlxSJqVOLcgqZpFZCbI0P+x8Ydhgby+QX0pAUASnS+y6rIae3aJaf/lrd+B5dVGp3DVunmRoN45FqyEwMWzZnceLxgypvSGnYRlQyz0HbxGxsNsjWREaTyi2PHKFwixKLTMiFDRySrDzEuN1LFwbR1Ee+ej2X1Ca/mmbg4SoFvpTsfij32Jkmf1PwMTK+v96Un2dytFhzXW89D/HlBf81/qn4WJx3X12V0drdsZVqyzPlf9d5GJ/t1uoFm3/5Jc8o6vJ2/QPgU8DwKkvG8nFyLg+1J86ubvcdQkn+pgRQ4pPM+4/QAAEhyIB8y5ocQphYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 03:40:53PM -0500, Pasha Tatashin wrote:
> On Wed, Nov 12, 2025 at 3:24 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Fri, Nov 07, 2025 at 04:03:20PM -0500, Pasha Tatashin wrote:
> > > Introduce an in-kernel test module to validate the core logic of the
> > > Live Update Orchestrator's File-Lifecycle-Bound feature. This
> > > provides a low-level, controlled environment to test FLB registration
> > > and callback invocation without requiring userspace interaction or
> > > actual kexec reboots.
> > >
> > > The test is enabled by the CONFIG_LIVEUPDATE_TEST Kconfig option.
> > >
> > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > ---
> > >  kernel/liveupdate/luo_file.c     |   2 +
> > >  kernel/liveupdate/luo_internal.h |   8 ++
> > >  lib/Kconfig.debug                |  23 ++++++
> > >  lib/tests/Makefile               |   1 +
> > >  lib/tests/liveupdate.c           | 130 +++++++++++++++++++++++++++++++
> > >  5 files changed, 164 insertions(+)
> > >  create mode 100644 lib/tests/liveupdate.c
> > >
> > > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> > > index 713069b96278..4c0a75918f3d 100644
> > > --- a/kernel/liveupdate/luo_file.c
> > > +++ b/kernel/liveupdate/luo_file.c
> > > @@ -829,6 +829,8 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
> > >       INIT_LIST_HEAD(&fh->flb_list);
> > >       list_add_tail(&fh->list, &luo_file_handler_list);
> > >
> > > +     liveupdate_test_register(fh);
> > > +
> >
> > Do it mean that every flb user will be added here?
> 
> No, FLB users will use:
> 
> liveupdate_register_flb() from various subsystems. This
> liveupdate_test_register() is only to allow kernel test to register
> test-FLBs to every single file-handler for in-kernel testing purpose
> only.

Why the in kernel test cannot liveupdate_register_flb()?
 
> Pasha

-- 
Sincerely yours,
Mike.

