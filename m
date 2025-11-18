Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A31DFCEE343
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 18:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB786B0032; Tue, 18 Nov 2025 13:56:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C806B0089; Tue, 18 Nov 2025 13:56:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D526B0099; Tue, 18 Nov 2025 13:56:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D52926B0032
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:56:40 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E4BF140198
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:56:40 +0000 (UTC)
X-FDA: 84124634160.26.B7E2C73
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9B14A160013
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:56:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kAUgzCr2;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763492198; a=rsa-sha256;
	cv=none;
	b=DLgA7k7jGXKtn+vHfJxtMRrD/iBvqUSvFLKLPWnidu3XRUq3Jf5KPBNhLT4a2tFHBHcJry
	ApDrdHB9N9TEm5aV+zAqgJo1f6c9n4yAm5tzfoWW9mkvnspMU1wufJWW39M+58L2JgDFs6
	DFXG84SRUUnqce+qard7TIH6Z3rfs1w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kAUgzCr2;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763492198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWpkfHNeylofE0Z6h0WbHIO4zlaztsQ0FoG6F0S+GrU=;
	b=Vhln6wC0FnHPmAkoctRorIu/sUWVerSh+ybAbKRmJTNJyl4prE9EXXe/eB+DyMWTu/YSAD
	Zn6ADAJYdwLdYllfzDDBa5je2XP6Jb1RNX7JBA4YM4uzxNtn4kzz91x4iC3jk4icPTeQ/z
	4jdvvXw6KxLLLmm6W7inwt2deR2u4tI=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64175dfc338so10932191a12.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763492197; x=1764096997; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EWpkfHNeylofE0Z6h0WbHIO4zlaztsQ0FoG6F0S+GrU=;
        b=kAUgzCr2zv9AHdmLl1Y4DkoB+uEItSEyG3Ec5SuEwEAL06Z2o+lEHudr8oC9cMi0dc
         LbkLNO61mBBRLfvFHQSSVjPKUhIK65QKfO0HLo15Xx6INlSNkiAhAoLpK/O3GsXNtb0E
         katTiRtLGRo57oL0VFd+6WrdG3Tm2I6Y3QdUENf59g8gwhJhPhrbO1wSY7E7PcD89911
         CSWB9zU1NDRX+Arjz7D1m5hlYiy5ZQK72x92ES9c9rhoOUt+lK1+2O9UjdPP8zY8sTzX
         SxafYN89Za7M/Mbg2n9Sb4v9+jMuavzD0LnmwAIM0WMdl0arS35vuVWGRdf/L/3hGqYb
         3Oaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763492197; x=1764096997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EWpkfHNeylofE0Z6h0WbHIO4zlaztsQ0FoG6F0S+GrU=;
        b=M/ZtXif8+OpFIFMWmhcei7/ayKymX4pAd1CbWuB1adp4tQVMkDibrt1+oL/qifeus/
         dRgUoKi45XDwP74G07e+Cha5614mZgV9LBptmiCDLtjQGthns3nTwpMjAYKLdupgutjG
         w5sD0MNLsDa1LM459cwiFFjHpvOKQ5WmBTZeNFvlh/WteFXoYcKwDEtHujoMw9zjOa6p
         8qzCA5y3sqG8+JFzc7ta0zlKNmWAg7RIxTaevwzY5ocT4awSDJL9XD10XfSXwnwRyZuH
         UlkQ6dR/9567HjkIzHqWKU5vj2FZ159KDyirqK5sVYIjmpPaYWgB3av9FjNJHLeX6UAK
         OCow==
X-Forwarded-Encrypted: i=1; AJvYcCVZBKUB52Y4PA0bFQ/1jufNp3fy5AfzAIbxuRp5DpSbJ6PuZVenZZTMHZ5Dh9L1y4mmBUypxfVp5A==@kvack.org
X-Gm-Message-State: AOJu0YyO3aWWGsdZnyKhupv/pjDHkUJt7xT5qqfGwGDkv2qRShNzDsma
	tgFaQ/ybHdzsIHM9QovEDneFg5bf6l0IF66zwvbwfx002JLPshfSayZ0oMKXiYD6AtZOGPwSeve
	zlsXB/AmuGFs/YHWrFSxgtBASbeXTi99OA5OUyqAgRA==
X-Gm-Gg: ASbGncsYkcF403k90bMGAyIk7ByjupL6Bok5bEDsFsooRpGTnurCXFJF2150aFym/Fo
	/w2aPE0zUlprHQC91IFg6yuW6YxVxCHGcZf3q7mMhFWSy5K9yGpGOAfDGZ3fgBnLBWtC/9xKpUZ
	itisqI7JuhGcMhRgcnplqwlH5C7H1rAoT+dVY2KU5wbbuKDR5e9IiXURwDCPwKDlaKjby8FEQIL
	wP0M+FcRw2fYhsc/+q7BLH5m0PleAya/jy+tst/CnBps23srlFpwmv0IU22Xn6MxA+V
X-Google-Smtp-Source: AGHT+IGgDybvpAfSTAM0QVtXWFCd8Zz0wmhZ1cAG/e31tljPdau5VCVWsoT0ybcXYQwiPkOov7XlapMJ2f8EsH3dOmU=
X-Received: by 2002:a05:6402:26c2:b0:643:e03:daed with SMTP id
 4fb4d7f45d1cf-64350e047b2mr14705623a12.1.1763492196993; Tue, 18 Nov 2025
 10:56:36 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-21-pasha.tatashin@soleen.com> <aRsDb-4bXFQ9Zmtu@kernel.org>
 <CA+CK2bCfPeY558f499JHKN7aekDzsxQkZJ9Uz4e+saR0qtXyfg@mail.gmail.com> <aRxY53gBbeH-6L0Y@kernel.org>
In-Reply-To: <aRxY53gBbeH-6L0Y@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 18 Nov 2025 13:56:00 -0500
X-Gm-Features: AWmQ_bmbYhd-e9mYzXSDDQXbPDAXR6c91g_2UNYAnLwXIGaKe1n58qU41N1HZlE
Message-ID: <CA+CK2bAc2p=_BJ=P-GJ5tNcxSHLckZP5iv+4bV0zrS-RVLH3Fg@mail.gmail.com>
Subject: Re: [PATCH v6 20/20] tests/liveupdate: Add in-kernel liveupdate test
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
X-Rspamd-Queue-Id: 9B14A160013
X-Rspamd-Server: rspam07
X-Stat-Signature: nmoncyon4gcr5ueg16ftsq3sw4wterxg
X-Rspam-User: 
X-HE-Tag: 1763492198-114517
X-HE-Meta: U2FsdGVkX1+V7wHfGFdvbx8Yi1AV5x3/OqR/0gWb2JaxFN844QodX7Ji8ecUnp8eAainRio7YltnZZ94xgEz4pgIqOW0OZtUz3ftWUnRThrEInktXAZg1DsSo8P4jXDgXVPoNlnIEGre1IH4slSkTZ/fgRecPSKY2KGiNMCop7wr9dc3PoZr9Hrav8s+l1lOg1XjW+VTMLYKkliJONxvsdSjsuR1v1fDR/YPelLAZbYVI9x8in0MwNQedq3ZbAqd51RGSS0RczQUAdzqrbbMhYpdicDSbuzeTy2t6iD7JVCCRTY8OQmip1qfuKc3P2mh7sYpy5CaoUna5D3vojtnttwVg0XkVOPxD5b9VbLVfmy4EaE4dqDOchkppNSmFw7sE8aCTek5wpyYP4BFAbumlYByfBW7uUHVK7rinhY5Vc5PsrVItwohU5nVngJcRQ1rLttCi4kIqZyFdwc5JzaLnQ5miXVYKHLzfWreA/z6HvJukEo+3PTLamnPTpx0itNz5cp6I17X1IFscH6W7QA5ynn2qTlXU6ahBueDT521DOMfxuRqHUQ93MZK4PHN8UKUVc3WQoo9HtMfd1SLrq7Vl5jasmwyi1DCD9H6TZgp6pHdNQJ87qZITIM6U3Lt0zo1FLX4dzKeN6r8015c2k6cGDf5xMrdJagfmuZxz/L84wPBm5TRiujeQ90sNo+MvkdBEHppjWOhDkLCLh7a1yZIqKqYYnJObYupND/3zgYqGqbFNCUgL0XhRzNk+Ws7N3UspFh45hucSdqkg6bbLRolsvThDJ2bPXTxKp0KxDtofBDrIyA7OI1n4hb8HWLrHPkgMFaQXiONCzC0s3ofO8rwnMxvNMRr7xdoYV7yRHZt1ITNxSbRRm87XBNfaHwbpxRpFvK5WeDb+Mdbdf6IQDJA7FaJvdxidCxkAj6bOAeuT4XxOP02j6JT8eSWqAQ0OhBibTFHmaUUK+J374NqlX8
 y6mJMBXK
 IOjJpqSXgeetlOGYlCl9klfNMWD2yhf8nxbKCvjAtm34XH9ZabmM/sUe39qYw93Pg7p4BWj5Wx+jTZdAuAH9SV6Hdl66cEcFu42gQbgf2KcFihhqNIDyelAvLzZvmJz4ZmIfTAB90Iu77IV48juN3P59h3/7cKt8cZoL7JLrrhrEt5Jp0Biv1FpL+qo7thLtzM6Z19SIAdsnpBrUgb8DbOZH05KkfpbxpWhy8H1FnAS97NU/lxixrMaXI+j1zPTM6BsoN9alVIwbOiu0pRjg7VbSaGWqdRjm/ybXR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 6:31=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Mon, Nov 17, 2025 at 02:00:15PM -0500, Pasha Tatashin wrote:
> > > >  #endif /* _LINUX_LIVEUPDATE_ABI_LUO_H */
> > > > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_f=
ile.c
> > > > index df337c9c4f21..9a531096bdb5 100644
> > > > --- a/kernel/liveupdate/luo_file.c
> > > > +++ b/kernel/liveupdate/luo_file.c
> > > > @@ -834,6 +834,8 @@ int liveupdate_register_file_handler(struct liv=
eupdate_file_handler *fh)
> > > >       INIT_LIST_HEAD(&fh->flb_list);
> > > >       list_add_tail(&fh->list, &luo_file_handler_list);
> > > >
> > > > +     liveupdate_test_register(fh);
> > > > +
> > >
> > > Why this cannot be called from the test?
> >
> > Because test does not have access to all file_handlers that are being
> > registered with LUO.
>
> Unless I'm missing something, an FLB users registers a file handlers and
> let's LUO know that it will need FLB. Why the test can't do the same?

The test needs to attach to every registered file handler because we
want to ensure that FLB scales and works correctly with any file
handler. For this in-kernel test, there is no need to create our own
file type or to drive it from userspace (where a user would create a
file of that type, preserve it with LUO, so FLB can be allocated and
checked. This in-kernel test is self-sufficient.

> > Pasha
>
> --
> Sincerely yours,
> Mike.

