Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9861ECED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 04:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF6D88E0019; Mon, 17 Nov 2025 23:23:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7388E0002; Mon, 17 Nov 2025 23:23:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B96068E0019; Mon, 17 Nov 2025 23:23:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A53138E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:23:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E858C0351
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:23:34 +0000 (UTC)
X-FDA: 84122433948.06.BA2BD0D
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id 67B75A000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:23:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LNaVDu48;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763439812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHOZfK0pWU/GvMRSsb/xaHbV4r5va663wkrxdVP9VvY=;
	b=N9qVWFqt2ddvp/bwqjOeCtR9suRLs+hEGTU5ZlRJezaLQJG6aOITDdNkBjbMXuh11uxcir
	tHOtAeU7Yf8bYBVuYAT9Rr7lGUWDa2S5v1/uG9XqxeDoaVqHc/uy0iAxqfOdJYzmGb3X4H
	MAsoGf8kohmQOv0QjxCPZ8Au4RgBdOs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LNaVDu48;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763439812; a=rsa-sha256;
	cv=none;
	b=cKbmg9EItsHsN7plDOvG0RJ3+Snjmctp56HLiaNc4zJ11GVpCtHzJz7+faklOfBkYRJvtJ
	NwtHJ6OPjCwD2/LHt3CPwts80zzZlKKQ3HKgffD3aPLJBB8VFn6CJthYfYqDYErNIEhLor
	54Ryo2cv/xXmEW6XV2jtQO/bHw8VOvU=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so6627875a12.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763439811; x=1764044611; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yHOZfK0pWU/GvMRSsb/xaHbV4r5va663wkrxdVP9VvY=;
        b=LNaVDu48PKMxk1X5SQGzQUux9KEMxLRAp4AT0URgh9l2fCmly1IiMoEXsMijpCKNMH
         W4f/03rtvNcL0aYk2J6S39lnwgIoRjGXx5i7zNwyKNLmin5k1rSKjyoAQz58dJ+Bdgoc
         a/206c0ts3X2UAJxBxWhpxOe1yfwt9uDwQL/hGhueElbx8FFI5mTfAAB3V1es4q4Jkfe
         zS6JKSknniXwNSv/kiDGVWOy7VJ7Hx29wvVlMY+Zrk79V5jV9Aym4MiQRXNMhsa2hP5M
         4oBOliQmfJKjBbSJKucNjZswTse+UBXMDBy17dUup5iEfOKH/RHbMQpeKRzYxhRoHkzQ
         wUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763439811; x=1764044611;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yHOZfK0pWU/GvMRSsb/xaHbV4r5va663wkrxdVP9VvY=;
        b=QV5iz728cOfVaEeVc+HG4N9g31biVFf+Mk/jo/A4Em8y8nDWglPom9ZW00Seo5s5fk
         SMxNxgnLi89l6Pe5KweF+ZxLgki+5spR9Pbqeklz7+iJkJaTAC5UcfgSizy61R538Fqn
         M5y42GMykj79iy6kpLMWK1ZgVEzT/4MmPwMpX/ZHFqOX4IMO2kN5FRoBXUvKfHajMcOQ
         gdOypn0cQpvd7/4of0NXnrRm9KOn2A8OHyr5QjyYweiY4bnWM68kw67L5yfaOgkwu65W
         YwG//iR/YZqJ4UzU2VAyXXADT1r+c5ywlqgLAb78JN4pJ1tQT8eFXfcBZpn5V1/nP+/j
         8cCw==
X-Forwarded-Encrypted: i=1; AJvYcCWYTZg5gu4Z4ImB9l2d1TsDg88SOIcFZc13H9aZfQFSdmUiSyBdNE/fP2BgRzlZV5IORdOq3U06lA==@kvack.org
X-Gm-Message-State: AOJu0YyJ/+mtzceb8qKA/vQ//hzKqDYOSrh+8p4V3YSfN2N1hKevSwGX
	xNqLczjRfcOr/VeNkX47v43GniuRETatB1+ZJ9zAdfwrdOO+k8pC+mNa4y4gvrVRby4mggD6uNj
	pQYfbVPxln+Pdqbj/GOGLPOj3NOgikCJeE5t4/Y5QCA==
X-Gm-Gg: ASbGnctlwc/e+G5cFTQ3LxewzYwBYmdoNAVsktYMvzeRG9EdoUsga3F/FFRSD57L4Hi
	fBwBaE2NekpYby+2XCB9/QvOSoP/UZ+snJDq863HDRY/jGBGlp/3R7MQobF/0LgWjHM9SpqSGyV
	YB34txeLdJGdDQ3OdMczcOipLaJlztLw/FVixiXyjDr11gibOOi5JOi+yn0kBoHP5Iwe6xNusQA
	OG/MMSU6DRcCuKI4WDLv1QU16H+lM+NUGxUh+4xq9Kw5hcJ2JHSUCKBAeam69Lf4sX2lcnd2SPv
	PHU=
X-Google-Smtp-Source: AGHT+IHcXQAOPbW77p032BCA1yf03kdrt9TXEreALO4fe3G9Md4L5c16ZrMCE1/XunuQOVa5pqVrU/kpO2uPmj8xqWM=
X-Received: by 2002:a05:6402:3508:b0:640:c849:cee3 with SMTP id
 4fb4d7f45d1cf-64350ec18a5mr12648190a12.34.1763439810816; Mon, 17 Nov 2025
 20:23:30 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-3-pasha.tatashin@soleen.com> <aRnG8wDSSAtkEI_z@kernel.org>
 <CA+CK2bDu2FdzyotSwBpGwQtiisv=3f6gC7DzOpebPCxmmpwMYw@mail.gmail.com>
 <aRoi-Pb8jnjaZp0X@kernel.org> <CA+CK2bBEs2nr0TmsaV18S-xJTULkobYgv0sU9=RCdReiS0CbPQ@mail.gmail.com>
 <aRuODFfqP-qsxa-j@kernel.org>
In-Reply-To: <aRuODFfqP-qsxa-j@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 23:22:54 -0500
X-Gm-Features: AWmQ_bmu9XJ4F2q03zVpJ7QCWl2e5iEfuoUmDpvTnYNqaWiEdVtcHIOkeQ1NtZs
Message-ID: <CA+CK2bAEdNE0Rs1i7GdHz8Q3DK9Npozm8sRL8Epa+o50NOMY7A@mail.gmail.com>
Subject: Re: [PATCH v6 02/20] liveupdate: luo_core: integrate with KHO
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 67B75A000E
X-Stat-Signature: qwf8dfui8sseq6add59e3drjm9tczww1
X-Rspam-User: 
X-HE-Tag: 1763439812-783558
X-HE-Meta: U2FsdGVkX18nvNzgBvZZvKM2TDr6U7iGagLjj1u2SM78rtz4M6+C91izJPfR7ElAb8JPt5b/Qrv2nq+Z/U9r8lZhiSYY1XXzvdY4WoPPH7Qb9aUOefPI5gae6IxyPOebaRZsVpV9DRmAOORYDf76tc5UuMF9GSi9F0emf3iTLWhM9TZgMTT1tRgTBkNwsWDGD9N4pZht+0sdOD1atBFzWvf8KcTgp9de3r73CRjATt8LrwMFQBkbhK2ufX3MMBm16d+GakYt3M8qPvLKi6eWRbI5TR2CjEL4QOwMLuU1A8AfbksViyktgwOubSRzqJamn+4lURiUr95sMRWsDNN4xLKMPTD/VULAsE4MX+oYcAvbk6r9Fw8Qf9/sdIQDc4NSQlN2jrsVc17F+bJiucXGE5drxBrX1CUfE30sJUeZ+NpCvOlCQ38bD7vEv9ZTdtGMFTX/s1mus0NNSDKaDQts3eOXQt1YQLgMU68soZwa/Wf87lHQP5vSM2e+kOFxzR2ucaibXk+I0DRHEQ61TGMdh+X+SMojqHcx4lmyfs5SQAt1nFjoCS5Jv3KClwaMzbQUeDc0qDaeo5hs4f4Ovq9vvvp7uHJshDsT03pWRKMSLF9QObhUEQ4+Dk1fGUnpRhpy+XAzp7JuhDwmmUQn4ksNJTDL07E5bij8Ceo1qaDWR917ExQhI925x0qVbiQX6WipbCqU3EjY3PH/CETmFBfMdiaAAfTXVQxBOG46OTgceCUNgCeOqlK3glNw8Lrzqv2etUbiP8DIPoybC/HPIEnRB4nzsSfUeR3UzONiDRv3nVfUeTWem5nnSRdq5FjMW/rTsl06A9xxzbi2kUPWjACSazUreK7X+UyW82ym5z0DEkbK8ziP65o8ColO9k0mmZZ2a588AhN2XMJxJyHoSffXdJpdnryoa7yTtI9Q4JzERZYjAt5J1yWFva93eER1RYe3jivR1zZMSHrtRxSJMLe
 TLLfBlmg
 Zb6gh6HC46ARCCVyWK2lhS/4nhPwxVQrBbbnj85ovV3KZ2HSBm53puq8Awr++NUeasSbg//WbmDahmZkeCagZgoEqwPnGQioF6zpXUqlQqqLrp/cXbgmNlypS+uzX4K4nEcgJ2lA3+9B/u5090vAX0montcytrmePw3fD/ML1luWYBoajY8FWI0VxQtyzxYGKK8ihP8Ll2H52t3EfkHnMR/fFILYprwQ07BfpwDdpw0VPocAZ+Wxfjm42kw6i6jtqOv6S3eVAH58BoA0wONgqMAeLrYf3dOxpvLhmZXQenCK+8BK7Hq9ieXnxBTvn0TmJJT/UeWLdDL6j0Xs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> You can avoid that complexity if you register the device with a different
> fops, but that's technicality.
>
> Your point about treating the incoming FDT as an underlying resource that
> failed to initialize makes sense, but nevertheless userspace needs a
> reliable way to detect it and parsing dmesg is not something we should rely
> on.

I see two solutions:

1. LUO fails to retrieve the preserved data, the user gets informed by
not finding /dev/liveupdate, and studying the dmesg for what has
happened (in reality in fleets version mismatches should not be
happening, those should be detected in quals).
2. Create a zombie device to return some errno on open, and still
study dmesg to understand what really happened.

I think that 1 is better

Pasha

