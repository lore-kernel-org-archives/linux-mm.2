Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2314FCA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 18:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721F56B00C1; Thu, 21 Aug 2025 14:11:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8846B00C2; Thu, 21 Aug 2025 14:11:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6D76B00C3; Thu, 21 Aug 2025 14:11:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4818A6B00C1
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:11:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBDF21389D0
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:11:52 +0000 (UTC)
X-FDA: 83801558064.03.CE07519
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id C0641180011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:11:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HthMCG+7;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755799910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQkE0seXAq/T3Nrv5ePjrAqrwGHMqBbMT9R5vFioxIk=;
	b=Ob3fkLTwpdd/+5M25EU6t+SeUnFSetw8JuF5k3YttyaOI8ADnx8LSks57EUX5GMgbroLre
	74xIOsB/As/wVIBGWPT6jdHZIPprzs/lhRWJGFsPR0NiJwRaqmbv4j3FiPS+3VUlrLML6c
	ou6kfBeegIdJ+YscpqgHEqrEgfKTlf0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755799910; a=rsa-sha256;
	cv=none;
	b=HGC66sVE8ZTz8DI6iYGBL+2GsUZdU1FJODsbZSEy5KwUmZljNs4nyRzkrubm80pPdcF+zc
	TUxZfTLpQBtWRd0A1+Zw+gVUfptLwwRvhwPc7a7szD15I9khoRXlEvFeIgq/gl/6Z944qt
	75Us87wZ/18GR1wA1BlKo53MF074xtI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HthMCG+7;
	spf=pass (imf24.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-61bf1542ecbso921636eaf.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755799910; x=1756404710; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQkE0seXAq/T3Nrv5ePjrAqrwGHMqBbMT9R5vFioxIk=;
        b=HthMCG+7Iu8blYyc5X1oQfa752pgNpn0MTBDIBjZLOwYA2cQTQHq/rQYjQEHnLK9dp
         U3SClFrSZ91H8oYL++NpCXdMoBcf3ptKSrrXMAOs8EsaQAObimhDtn1vhv437F8NVKUC
         /7WBU4aoek6EuU4qSdfjFYXtzf5Ch/FuPPJF3L6Vww1n2nejTA7EVNJovINIn7YaKqkZ
         JW881ZKfTJB3Ak6kvAWuY99Ge1TGtiqXqiFNsN8hIu4KWkJrkG+0imUi7+aCukAa3VM+
         qvOm+i2+0+RKRRnXJfANclueEyn+upFmMw4hYKAl197FGvyVln5xnTvY2TrcEZE/CddJ
         0HkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755799910; x=1756404710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uQkE0seXAq/T3Nrv5ePjrAqrwGHMqBbMT9R5vFioxIk=;
        b=ZwYJjEdyDpz1COp4ojo8XtjZTMWXoJS3mfQXbzZybsCYChJlzCvlQDqcC1AcGP08sq
         +PA5qfay5GTuQNOM+m1X1HPPuqJnUAmc9TifJHH5DkU+bq8EQxzIF8pQMIb4l0r36AEz
         l64BWP7ISUoJF9n+sRtNnW2MT22mFohBweKSy1c0iS73MrZZOBKtYHR2hv/+4WRiM2eu
         6Kos50rhu73xp/Su4/DzbIzwJJeeWBh4bICKUFm4CtKsP3rlr9gyXngPYr1mNXyI2fMP
         9txht43uvzXL21xSGFjEzFgdp0oh4fwP3m/GFHv8cpeirJWWAjxj1sxjk2Jhm+oVhSZr
         pVyA==
X-Forwarded-Encrypted: i=1; AJvYcCU4MmhM3tPe8jnEet9Oh76xVBTv/GWg+AgY2LEYtdOB0zXQ8p1LXeF4gjyXktXWOmgUSxsgcvLNQw==@kvack.org
X-Gm-Message-State: AOJu0YwyqGe6M7De+giizR7njfwcvfViJtDzml7NS4rDtR9PCvx2quUx
	Rw+lsUOgNWuELy4uACIlTvUCvpiCahZEvz60xEwicXpAlk/PUMBsI8ahRZn1q26nM1fJPbBW7Wp
	gICF8fc2E6bJVdHauXHXie6NoNqshBlw=
X-Gm-Gg: ASbGncsbahuDMtjuY7Db6yR8Hr3h4ZuLqtnh/WHALLynXIRNLj5FsWNyzt882mPwA08
	ebo/SjhK/XewlBZkkSLKu9Rqgg9e3AGyJ/rmezxEqTDqr6PY02LPqUyFvsL/c3aqnWl4RsE5Cme
	XFsppETxNnqkAY4RpTwVSzdBZNcvsHiJoDolKsUsyvR73/7NiuTxmmrAinON2FJKudPOkTltP6V
	EX+
X-Google-Smtp-Source: AGHT+IH5cYePY4LWF+yUbkxUmI19KRzSY9VkjyJnD/MWSa1UbpylRasKtorNCTewDJ8FF3suBgFD7LYcg9l9HBkHfr0=
X-Received: by 2002:a05:6871:54b:b0:2e9:42a9:be4a with SMTP id
 586e51a60fabf-314dd38b1e9mr45823fac.2.1755799909600; Thu, 21 Aug 2025
 11:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250821163346.1690784-1-ekffu200098@gmail.com> <20250821175307.82928-1-sj@kernel.org>
In-Reply-To: <20250821175307.82928-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Fri, 22 Aug 2025 03:11:38 +0900
X-Gm-Features: Ac12FXyjW6YGm8vBrKSBZJTi676GRJ_lE4WNPgVhsOLOvxK4NT6otMlFppJi6xE
Message-ID: <CABFDxMFk3TbzOcZd8tgLJtQTav0+7=BV98f9=YVYfea9ngCsEA@mail.gmail.com>
Subject: Re: [PATCH v3] mm/damon/core: set quota->charged_from to jiffies at
 first charge window
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org, 
	akpm@linux-foundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0641180011
X-Stat-Signature: ouj6brtn1jg7cdwrxeukwucw3jj1bzdp
X-HE-Tag: 1755799910-243351
X-HE-Meta: U2FsdGVkX1+iJTe6MMSdMEbnCQumOL6Klw8hxTqJB26k3vYHLjYgegauxpmJZoJFNg3NCHfNYGdpZgV29V+cAg4SsNyp78uO58AZlVMCoTX+HFSXNl+Nz+lMkbARq+v3f/kN3XSNNrzHYY7xM9zgzhtudLgVdyHJFK4cb8Vdm11iQt5aGUjQ57Cl0iF6wy2zdsic2YiQrVA3lpetsyWvOMFZKukzVuCrbHRsU+qd58dRYnuRXH2Um+bUTRmhES92wwp/oFBLhw5r9f6FOdVHVvj+w+mBWvINNY2+1mr14khayS4PBEeIeDM9hapvMx36VSEeYZUZpNvNzkZ5DzCUezFD3rLXZHeSh7J15cvvK7RJhaUQDbzRUR3RN4GP7TKBWnWry5sSfwrsX6GYkuwQagFEcOoOQ7DhP1bBvqsWGySKzDQ0cNKZacN708bW8QMFPxKIyWS3M4lFHxEPPyLfToDttRYnbeINqCWeWFzg88I0U2F03Mfi9CJj/o1Etga3USFK/ReJxeHk6EJajjZwIQNK6BL81AyqJFRZ8UyXoEFC71wHLHKD78BOcRaqRL379aYua8vnDFMSJAOg2KxtGx6IJ0w1GQ5X+OvefTDvTnxKLlgcvTSy32Y5UVYkdKPo2HHfAUJoIqTTX7Kij7EHDcMkhr8Huuv/wdcZWyrSADPm1RVYx/UkzRLCz0pr9igqHtLra8Afm53zF7lWWL36+v0rEs/kWLB8+6L4xYw3GSOMXqxQF1b4jvjRDG+EebRJDJ1CvElHpMvYRrXE+5pe4vOLoeBNq8cRO9NF576T4epfdf8h/jl73LD62LVIQcPMGLgU9lJBNp2l1iDjQXNCjMYNm+5KYfYtqhQxvwjO/gADStnAjpmDaQC23XeDRz+IzsZb+6ErLSQ7k87KwuQb56ClGtGMfw7JnSioge5jEq9b6+Z7TkfvVGTelfANKPjAb5VZ/S2+Xlm8xf/wJUF
 m3icZdxH
 7QhPi5N5pWzFicmF04TbKwMv1RWZeAZbUaE/YbyzrYWw0lttfRFTlu1fQVkvMZORs43J0TzmmIoSzMetWkbJs4nQvGEQmnTPrMHVAbdVXmxLVCYJmCJnFVcYp6S7I8q7aDqMbv852E6h8uWpBiIAxG/04r91aGGZYdfrq1mhZ1fbaam0c4HiCw1BJ1fIFhcFyQcLDLnBTD4wkampZPk2pe8uBQk4DS+w/EZ3FRhssgms1LdFzsCovwWRYRsFAwgP5cyo3tjAw5IHHwi7hxSWJQ8/Q4DrzsdaHXnzFZ1VFEoqpQbKWhqWmujSbU49d3wBA2vq0KK87TnyOTdDGe7gpyrfePN0D1kMW1/v7YUD1ud6klpdR21tRqq+/JfkHQ2XuxOsoCE6sPzJZUdzmgK9K1yRFOYmbrXFzH+x5uSUL23Qqa9+aSboiv5fWEpxQG/tWqlgg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 2:53=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Fri, 22 Aug 2025 01:33:46 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
> > include/linux/jiffies.h
> >
> > /*
> > * Have the 32 bit jiffies value wrap 5 minutes after boot
> > * so jiffies wrap bugs show up earlier.
> > */
> > #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> >
> > And jiffies comparison help functions cast unsigned value to signed to
> > cover wraparound
> >
> > #define time_after_eq(a,b) \
> >  (typecheck(unsigned long, a) && \
> >  typecheck(unsigned long, b) && \
> >  ((long)((a) - (b)) >=3D 0))
> >
> > When quota->charged_from is initialized to 0, time_after_eq() can incor=
rectly
> > return FALSE even after reset_interval has elapsed. This occurs when
> > (jiffies - reset_interval) produces a value with MSB=3D1, which is inte=
rpreted
> > as negative in signed arithmetic.
> >
> > This issue primarily affects 32-bit systems because:
> > On 64-bit systems: MSB=3D1 values occur after ~292 million years from b=
oot
> > (assuming HZ=3D1000), almost impossible.
> >
> > On 32-bit systems: MSB=3D1 values occur during the first 5 minutes afte=
r boot,
> > and the second half of every jiffies wraparound cycle, starting from da=
y 25
> > (assuming HZ=3D1000)
> >
> > When above unexpected FALSE return from time_after_eq() occurs, the
> > charging window will not reset. The user impact depends on esz value
> > at that time.
> >
> > If esz is 0, scheme ignores configured quotas and runs without any
> > limits.
> >
> > If esz is not 0, scheme stops working once the quota is exhausted. It
> > remains until the charging window finally resets.
> >
> > So, change quota->charged_from to jiffies at damos_adjust_quota() when
> > it is considered as the first charge window. By this change, we can avo=
id
> > unexpected FALSE return from time_after_eq()
>
> Thank you for this patch, Sang-Heon!  But, checkpatch.pl raises below thr=
ee
> warnings.  Could you please fix those and send yet another version?
>
>     WARNING: Commit log lines starting with '#' are dropped by git as com=
ments
>     #16:
>     #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
>
>     WARNING: Commit log lines starting with '#' are dropped by git as com=
ments
>     #21:
>     #define time_after_eq(a,b) \
>
>     WARNING: Prefer a maximum 75 chars per line (possible unwrapped commi=
t description?)
>     #26:
>     When quota->charged_from is initialized to 0, time_after_eq() can inc=
orrectly
>

I will fix it. Also, I came up with a way to prevent these minor
mistakes. Thank you so much.

> Thanks,
> SJ
>
> [...]

Best Regards.
Sang-Heon Jeon

