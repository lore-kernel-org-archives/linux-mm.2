Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2E76CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 03:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916C88E000E; Tue,  7 Oct 2025 23:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A06C8E0002; Tue,  7 Oct 2025 23:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768558E000E; Tue,  7 Oct 2025 23:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 622DC8E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:18:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D480F1DF429
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 03:18:39 +0000 (UTC)
X-FDA: 83973489558.29.5E4D4E7
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id DE4C7180007
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 03:18:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=f6rLI1m1;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759893518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lY0lHDo+ZMYjiI3WrpH7eJfFGmGqKDcMD4+kuNAqXa4=;
	b=dsfjt2dxW7lSRk0C3rl7ONDLl4VV7WQdirYkZ5zmYyvBPhZoqYyf5EW1xe7BaNvu8+2cNS
	eapWCCJCaFf43MHFsNHs7Ko+LAvpT6fTK22LgG+tBngKhj6WzBU8hjvzkkE6LkNXOG0qao
	W3+uSD1tGJG7JUEj8u6M7d8sBGlYY5w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759893518; a=rsa-sha256;
	cv=none;
	b=sKUoSpejced34i7AGIdP7nyz5EcIsmTqXSi4sfj34/NsdjWssWCpgz7xFeGEPm7pxEcdqg
	tZPePrqNWiiJ0abioYCOqm1HWF+dB1n//7CHc4SF+vAfRcPgCedywbLYtXVt58Hjg04GMm
	qJZi2fz8ekbEMt2Xt1gxT0DeI3jwH+0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=f6rLI1m1;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4df2911ac5aso43053171cf.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 20:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759893517; x=1760498317; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lY0lHDo+ZMYjiI3WrpH7eJfFGmGqKDcMD4+kuNAqXa4=;
        b=f6rLI1m1lH2T/wfF+xOckrjHNg7aMQ91j22zZww4CYc6YZCNZMgx1FxuihdY0qiWMF
         Rf4s7koRGf4m3Tj6c3cWedt3IMFUCxhPiQRRMhtiAF+07U62jxNVMfl5U3ttZopnXBl1
         pYsGD0PKbynaQg9uZuChtUPizubV8IRcAMIxQYrflGF4rlomInNTPTqizN5YOXJp754u
         1RJCFgjvtaULATaEYFs0l9zrCgfOeQ0ibFWC2cPhI3YiH1y7jmOn8UVxAYam9WLyVd+D
         5uhQtWOdCSKXIEqRDuDPY634meOoorKSQi4pIlx46+vfAtlZaBdMbVQDUcAu4y5zOnGT
         n1Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759893517; x=1760498317;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lY0lHDo+ZMYjiI3WrpH7eJfFGmGqKDcMD4+kuNAqXa4=;
        b=qs0Kk7/PgJ8hFeNmiXnnRSIvPNGAOO7q0QTJ7oDGK0goMHyCdUG2f8eGtlr4AstemM
         scnKr4saAnA/53nC12SGy916hKjPJcZch1gho4Xa1eG77GoZgGluaktKXxwKEE2bZYmC
         x5Hd0CilqVZGrtUtxhDLZRepSQ4RTUFSC0qnOJTFCN9ZDEMY27U+MIBh2Hmza+sxQG8T
         kcwZ4EZ5+04RQz1B7Tk943wNNwHwf7lingzwIlQqkgCe3dl8qvaZwY/jqBs4DKhdCSIZ
         tPxxjp/XpO2DC09pQGVz260VJwP6VxyDeaIi0A6m5fSO2zJRq8QRjMMRPzzh/AIdOWHg
         qA3g==
X-Forwarded-Encrypted: i=1; AJvYcCUaJ6Y3jVsZUr0YfeN+2g9m9Qdm5pLHeo6lqNbAO2peHYBLpm+7nxAv7dI9A0mXtajo1ZfHfhvZSA==@kvack.org
X-Gm-Message-State: AOJu0YxIk15ylEIktjaexmUXCmWhcuo2OH0ND92s32tNhAZkcwq+cBtB
	BmSLvbMhOYr4rUE8KQC61wY6/DvUgarfoAph9kQY4agDz62HjTo/XDVk4cOyPHsPnscSnABW5rG
	rt43VgDJjyJlGwsGLxBAEEvxMaKyr4txhcIbU/hzwzg==
X-Gm-Gg: ASbGncuTFi8qySzJQhOwoaUT7UmYdjnVLFteHIB3DN3kmo5k/S5TUg10lETKlM7rHPV
	PkWcpR5oVZrcRXHPrQLtR2yMKYZzBJQRxeZGiuQMgBUkxxnSZVUZ90lwE5pg6LgRSKRzt7U+VPL
	CckgcBNcl2QB4v1P/0BTac9GiQBTlXoP7tIV+cnIluptWji4PyN/49x9LHC9g8JphisiVUTfy1t
	RUW9PWDLwkDWaRNoC/e3md9DMBQ
X-Google-Smtp-Source: AGHT+IHi4LrH7xm0oX6hym8jBnuijo8ZiVZrjt2jN+GojnDTB9cmqow/7uayxXgJT25O+sPIp9pbSmcuL9HcK/iT90o=
X-Received: by 2002:ac8:5885:0:b0:4b7:9581:a211 with SMTP id
 d75a77b69052e-4e6eace7e6cmr26859261cf.24.1759893516637; Tue, 07 Oct 2025
 20:18:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com> <20251007175038.GB3474167@nvidia.com>
In-Reply-To: <20251007175038.GB3474167@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 7 Oct 2025 23:18:00 -0400
X-Gm-Features: AS18NWDS3Ynl4RAV12cPYQQtkZzPk1WVwFfWilu_AD9DNETBUGP8gManlWckAdM
Message-ID: <CA+CK2bAS5ZSV8xE4OpP+fWUvmmv1TcW57YB5Stk1dDZ28DiuNA@mail.gmail.com>
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
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
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org, steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: cngc5dch7imbmteyi8bw95miw3bcxoxn
X-Rspam-User: 
X-Rspamd-Queue-Id: DE4C7180007
X-HE-Tag: 1759893517-180200
X-HE-Meta: U2FsdGVkX1+6hD94rc3jOLgCUWg0HeKoaKPegihOPQPbXyDEfpSBK3e9D6X4YB5zuG6luzqLg2ESR3cHob4ygCIcJjY6Qe/gbJ5JnxE0xI66JMRKG5Ggzne/wr9xQF+OOE5bQb9nX6OoXmmEt4o15ywW/rKE2pKdD38dP+fMcU3QfpZOHFhpbWp00TxNkHV4OgkbxY+RHcUnNCRPwwWgwAr9MchYZTBMekKC40PVGMyXQyRTNa/SH6CorXKgU0ZcqFyBddl36Wu1eGHna8XbWb8pqFj8lwOd3K9Pb0xjPdB8DYIUNrr0leDz3Y1h+EYARtKXBYnNUxxZ909iJymwOUH6R5rbtQgysrXl/7Nc1pf2PJKKVeSYUQ/WX6nzoqfZKvj8KSDhycoLG8EPM9xQc51YJIPAazgUFymSm2MHCuVdOtF0YgRKhGpWkSb11Fdy4trRM7+3aiXvRXJ8ShlrA31GC5YEqK1zjrTvZQvFjoljTtG2zOkXlmhbqFSQIKtsp93yoztczxUjOQA6BUCzJidda2qPGFdQtJf3nNdlyoHdpvc9Drhq06WfEjuGGXhzFKMsi94x0Zy/bc6LfQYUxKcOuDwDqwpenbwaCLpZnw5b2gsJFX00tThX3XfRZMcShl/VIulZoEV+DJge8z5I0b7MMCiHQjqguZXLRrC76V3jgo8Hvdf6XkFw7mgVfORUurGft8rGuv+MLCduwM5tTe78OieFNsNIyIQF42T/AtSpsNJzO2DH8w9HS1SOOUC0hLt05+0g1m4z0FzjaZzj06AR37RRyGit26R2b1fL3egv/uhVsN0tO7qmx1dDd5XnSPpJ90iK2bAZQXjWx7OGXmGsmOvkZGo88Ktk8Xdei4K8d2eEBpZUovYY77KGp+MqP0/mZ9lzEhvfPXKUFkzgYPXMoG8IrO8BgbANzlwEKbriA0Cr0+cE2q6Kf+mCbT0VUB86AEjJj9vgj8TQPjr
 +9Zfba1G
 jNgGhsJZUny7wiTjxCchSSgJgRWH68Y31IVV9xGgTUNhSXJnV8UHXtQ9gmXHLt3e2poECCDl7dOVTy/hC6y1fIyUQu6nwkjESoapviPAMyGrTSh5IeG1GGEoCsOnwURSGYqJgMo9JkROiQUGPmBDuCielqsxwXsXVGCwkmdbWhdLFaGQw1ICAk2h00jk5DPp4kJnpcG5HjJ2tB3g6nQeWa8sFQA9OtUpBKF0qEolczF6260QFBbpwvpWqatfmEEIliYDUCyNAXT91imh58ci4IZHhTRtn4MXrAhBb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 7, 2025 at 1:50=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> On Tue, Oct 07, 2025 at 01:10:30PM -0400, Pasha Tatashin wrote:
> >
> > 1. Add three more callbacks to liveupdate_file_ops:
> > /*
> >  * Optional. Called by LUO during first get global state call.
> >  * The handler should allocate/KHO preserve its global state object and=
 return a
> >  * pointer to it via 'obj'. It must also provide a u64 handle (e.g., a =
physical
> >  * address of preserved memory) via 'data_handle' that LUO will save.
> >  * Return: 0 on success.
> >  */
> > int (*global_state_create)(struct liveupdate_file_handler *h,
> >                            void **obj, u64 *data_handle);
> >
> > /*
> >  * Optional. Called by LUO in the new kernel
> >  * before the first access to the global state. The handler receives
> >  * the preserved u64 data_handle and should use it to reconstruct its
> >  * global state object, returning a pointer to it via 'obj'.
> >  * Return: 0 on success.
> >  */
> > int (*global_state_restore)(struct liveupdate_file_handler *h,
> >                             u64 data_handle, void **obj);
>
> It shouldn't be a "push" like this. Everything has a certain logical poin=
t
> when it will need the luo data, it should be coded to 'pull' the data
> right at that point.

It is not pushed, this callback is done automatically on the first
call liveupdate_fh_global_state_lock() in the new kernel, so exactly,
when a user tries to access the global data, it is restored from KHO
for the user to be able to access it via a normal pointer.

> > /*
> >  * Optional. Called by LUO after the last
> >  * file for this handler is unpreserved or finished. The handler
> >  * must free its global state object and any associated resources.
> >  */
> > void (*global_state_destroy)(struct liveupdate_file_handler *h, void *o=
bj);
>
> I'm not sure a callback here is a good idea, the users are synchronous
> at early boot, they should get their data and immediately process it
> within the context of the caller. A 'unpack' callback does not seem so
> useful to me.

This callback is also automatic, it is called only once the last FD is
finished, and LUO has no FDs for this file handler, so the global
state can be properly freed. There is no unpack here.

>
> > The get/put global state data:
> >
> > /* Get and lock the data with file_handler scoped lock */
> > int liveupdate_fh_global_state_get(struct liveupdate_file_handler *h,
> >                                    void **obj);
> >
> > /* Unlock the data */
> > void liveupdate_fh_global_state_put(struct liveupdate_file_handler *h);
>
> Maybe lock/unlock if it is locking.

Sure, will name them:
liveupdate_fh_global_state_lock()
liveupdate_fh_global_state_unlock()

>
> It seems like a good direction overall. Really need to see how it
> works with some examples
>
> Jason

