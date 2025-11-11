Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD4ACCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 20:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6BC58E0007; Tue, 11 Nov 2025 15:43:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5768E0002; Tue, 11 Nov 2025 15:43:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BD768E0007; Tue, 11 Nov 2025 15:43:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 875058E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:43:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D094140192
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:43:05 +0000 (UTC)
X-FDA: 84099500730.09.CC18549
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9AF5F20005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:43:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=M31UQG80;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762893783; a=rsa-sha256;
	cv=none;
	b=qkxyT6NqSmme24bYwFOy2wrwXUxITuUntkPfPmeRquYM8nM6qw8nMGSTDO5dBlhb9H6lga
	SGUKy4aOcZwo2UgqwWl9JfZyojjoUX5TGPuSrIgnX2gGv/wc/CZofTuSLUXvu0E5gfN/t5
	OxDZ18jx/lLZ0tAciWNiqd8BQnPGEcc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=M31UQG80;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762893783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SPkvNL6hC2GnwSkZWOxF7zaqo/2CIWUpjYpRKjrtIiQ=;
	b=N7cFLh5jo/wv9NXaSoXMcZuVvN6QRcjhl9+frn/s3pnqII0LIy7Yh+nMxgvR/Y0tYzx+Rh
	XwUXKYvUR44bE4mJJiaJM5zciaC1Z7oo/6qs/4BmlyjmlaQOBAk2JSC6XyxCdCk+9yLIHT
	vz7UbMjt7X141LNb3X5f6dFFFT8D0q4=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-640860f97b5so127581a12.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762893782; x=1763498582; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SPkvNL6hC2GnwSkZWOxF7zaqo/2CIWUpjYpRKjrtIiQ=;
        b=M31UQG80iCHaasSPxj3WLmU0SiMAzyODtAmyvTvr1dPtwZb01VQ+90ZFhMQlk0ty9u
         q0ASrIQ7uSyhrsl+qkZaZoe6mW2Ur+zaChyLCRTLVabfFnb2A0bo1aQyqhkqBeNu7W1M
         dEBxxuvCrtlpWK4mSl73IjuCidmYztrkj9BZIOAbSlF6LkDwHSJ8HJeGhNKDcvLxIORm
         QM3R7szGQVvNzQUJSD/efxPTaZrDDHh3RMPeXrNbWhMcOi4YsQeVJtvvqPwPNzwBxu8K
         GZ0FyACgt4frRn4KClreWR0E76aY7XXUanx0aHgyaEi4hM7MbDDpnVQemy97U31/g+0P
         Sz4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762893782; x=1763498582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SPkvNL6hC2GnwSkZWOxF7zaqo/2CIWUpjYpRKjrtIiQ=;
        b=vscaFUQUFnAPH5TZFhRXBgtKdExn0YDbYwA0jWLLzhR/vW5tM2lHEX3142p4ABblKA
         vnoy7x6FYhZyTtvoTXUKkQ5wel1ZAXJaXVKb21A/0iGZdiYAjkfuKUpQgqWshXzfIcXJ
         OVHZZtYAUJttfA3Kb2H/PPjhW+F9mOVfUAYbNixatuJZRc3bQwnxCgrN7nwVgpzmMUG3
         YnevRmhp3PYnX9U19hPD00qoeTjRVOI41q+fU7WVSD+S3unxrcJDZ3pO4cMMYuQkgodQ
         4misTHSZln2jieLvI0yLjpZJ7Vabos2cLNznJqKwuJQI5bEJqzdn/+egcYIjuQ1hxb8x
         JuZA==
X-Forwarded-Encrypted: i=1; AJvYcCX0mBFWwbJpy5F+N2TEOKuOpbmlONHQnTS1QLpQqo/oR23zSAAfvhQ3Z1EHoC4mnTGLB0r8JMkB1g==@kvack.org
X-Gm-Message-State: AOJu0YwT8ML7KE9Piv/z1YItfkaJZmu8/eS7s1LkIeHr1v5cHQrg+CJa
	UWO36uGF0pePzf93dMYAFb2NVaHNA1yi3v2xeTlv3eM/Z+q/X9eq+LqbRQEoi2FjWjCuSCh9nM2
	Grhs1u4XPZFOBZRRxh2KjP0+xU+sCaZ2uHH4KO9ve9g==
X-Gm-Gg: ASbGncs9+MMtT0uOn+VsrY60JMypT3PyuO5EzcLRU/qj9eCrBbPSZfHUzKdbAw8+LX3
	YNDJ4Zyaxeky09L67g+7iUoKZpTJII+5ejm0gmk9WBox/BUM0u88y4DXjt5Lc/OhbQ7XrBqvyRK
	dB24O3pO7qvQ/vL4vlkpLFYt9v9T4DyT5bQZCGq24nHK8Sj6YcesG+dkwMy1dQPoABN+oL0QwK8
	GCrjP2SkaQd34rlME4N8t95pn4J1zUGaxHNnW9RgMpVDVTH6JEuh7q6UJMBpZRQ3od7
X-Google-Smtp-Source: AGHT+IEAy8cPLsziX/RCDUv2Dd6Ywa5OE8z1bKSydNZGkCZ2bkHrdBqmgyzeg7NbMT02IJqrhiQfoZnn25FUb9ZItfc=
X-Received: by 2002:a05:6402:3046:10b0:63b:feb1:3288 with SMTP id
 4fb4d7f45d1cf-6431a55ddb0mr392712a12.25.1762893781751; Tue, 11 Nov 2025
 12:43:01 -0800 (PST)
MIME-Version: 1.0
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com> <aRObz4bQzRHH5hJb@kernel.org>
 <CA+CK2bDnaLJS9GdO_7Anhwah2uQrYYk_RhQMSiRL-YB=8ZZZWQ@mail.gmail.com>
In-Reply-To: <CA+CK2bDnaLJS9GdO_7Anhwah2uQrYYk_RhQMSiRL-YB=8ZZZWQ@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 11 Nov 2025 15:42:24 -0500
X-Gm-Features: AWmQ_bnMmE_G9j7GUZRZnZwadwZMShQe0h1eQQimW1N6CMMoPEVysMT2zmRBrNU
Message-ID: <CA+CK2bD3hps+atqUZ2LKyuoOSRRUWpTPE+frd5g13js4EAFK8g@mail.gmail.com>
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9AF5F20005
X-Stat-Signature: z85pymuf963hnq1g6mqptwb1pnohksf1
X-Rspam-User: 
X-HE-Tag: 1762893783-59657
X-HE-Meta: U2FsdGVkX192Q4TbClNhKGE1Iqjk9o/Oyc8xyfWeplmnELBAxLE5KMzgFlmXmHr4xpZ59oX5fpCpqaE2APNEiJgK1xRlg7NDdCgnzioZidjQs3caP+uRzobO6eJLFTyI3pokoZaRebS8FzFOMAr01wJ/sqlJYDqj6mZYlT6tR4eHWrdHG0vCEVsnpgrc4pqZ+nVCk6aPkEWfzC5S/GHQkPZcZn0MR7dMo5IG4s12wQstdQHr2SakCjwSZNhlK893rFVeLoxv02cmfxSt1810yV+gA0FjlT5r3GXUM2eEYNHPJqzkfRt/Lknnt/BIEURRskYBeaG5YT3q+5u+JmPGFSgffbTmHIOvgTNIP4Quf/ze75EnYB3bmd/JahDBuFLeMA2tBk7ZqPH1YmmIwaiVgzTBIinq2qI4nd8DmrXtdUhQKygmVpqm99OtcuYpyrayuqtKLpU6iyeNboiHk0p4XFXUkkBiz5RW2mTOv6VWpU7XscJNXWoGmGK68gvTG+wtA2etdDiT8q6FnBqxbSsOT4kl7F64rQLylej3HnniZONIWRHB1yMYL+YiAiNglLoNEiF6ZccbTswvigdGAHSCK8QusCpQe7PPxDxx9QZvc8dtRRIPFSnStshvyHWm8uyXKSNbgGKXAKhYOjgvbKAREw47CO7z6aPZLtQ1+wZkqnV2uVzqZ1zdz2SzTDxzSLv3mhWJsxUB2zJgeZHSGgoDlCXvvLsl4YKAlimvbif/N+XjrA6PZYjsAqIlf2tHoTZf2qNsTWKdNuBn7qtAxmgCBhiV49lV6/q5xifMnuZBf4HG61y79g4/iEIEufmwJhciNd7dMGFTyBwh4uB90IFIDpN1m6B9wj6h4Cs6fa43ODZpTQsWujOY8V5Wjidv0khZ/jUsTOstjFba/jdkeXBRohi4L3C2X4319sG/8k6/6ZNYzpOwzCJ1DOpvxMd/Q5+X2iAQkcC/aGGqK+nx81o
 rCtXolBb
 GP0asm9Vf/OOO2MM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 3:39=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> > >       kho_memory_init();
> > >
> > > +     /* Live Update should follow right after KHO is initialized */
> > > +     liveupdate_init();
> > > +
> >
> > Why do you think it should be immediately after kho_memory_init()?
> > Any reason this can't be called from start_kernel() or even later as an
> > early_initcall() or core_initall()?
>
> Unfortunately, no, even here it is too late, and we might need to find
> a way to move the kho_init/liveupdate_init earlier. We must be able to
> preserve HugeTLB pages, and those are reserved earlier in boot.

Just to clarify: liveupdate_init() is needed to start using:
liveupdate_flb_incoming_* API, and FLB data is needed during HugeTLB
reservation.

Pasha

