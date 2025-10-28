Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56B75CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:02:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E562800D0; Mon, 27 Oct 2025 20:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8951A800C9; Mon, 27 Oct 2025 20:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C33800D0; Mon, 27 Oct 2025 20:02:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6028C800C9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:02:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FBE51402B7
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:02:41 +0000 (UTC)
X-FDA: 84045571722.05.B9D1CB6
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 09A51100003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:02:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=K4USA5my;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761609759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRrW1VGqQYsOj9O2IaLW2NSKFc6wcY6W7P8omZBsZSQ=;
	b=CRMXAOr6QTE377+KNaXLqkRKIzJb/yBQ0TzWTaRVHLiTauEUvBaTzGXXz0g+srWqcxbalR
	ZfxFWxSn4FP6CCdKCc6ddOhe0BtBm/QtWWq+AtzOoUupMCJjJmVQjCR4VAVKsjjHRUfz2B
	wXcWiqDS3XuiYJgneSA5q7rCdDdpWLU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=K4USA5my;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761609759; a=rsa-sha256;
	cv=none;
	b=HUJISIvIDFQjQNyP62fyIBIwiU/1twvOdMkdfUyCV7psrDg15wWkAzfrcSNrJYwDZiliZz
	IQb5x/fsq3wKtnCHvkPF1eH4Y9q86zrD514f8nSaaiA9Qmru44SJEMYru8/5ijpk3hhH67
	+l1rPFKvsqBsJfj5Zxv2PHL9nVmthMU=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63d6ee383bdso11429762a12.2
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 17:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761609757; x=1762214557; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fRrW1VGqQYsOj9O2IaLW2NSKFc6wcY6W7P8omZBsZSQ=;
        b=K4USA5mysbt/4RvcOyoH7ncQQtco4xr9bkfqvWeBEwTTJli956BzLl011Rrcvn4iiW
         T8xMyb09I1NqulQ/Z0F0a/hdPzpVNhSJOYHXZuq3vAzGfJhNHU5Vqnh97IdBCDF4jQhi
         3tGQuUEvnwJt1nJmHBRQzNyY8+WIdSZq2mJ1GdB3AT/bDfj69hsXmzS8oVr6hCLo1ldk
         gkVPcTPkGYC71TTH++D/jl5+bKJ221ndksUbQkOYfTrvNUaFMjqLrMVDXHTcv/6elxbL
         aDI+hTXcOIrfpRw5GWBZdloBBjScBQSMxAvLSqyy1u9ItMqmhT/s3Bql9B5BR4ohmNKp
         Un9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761609757; x=1762214557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fRrW1VGqQYsOj9O2IaLW2NSKFc6wcY6W7P8omZBsZSQ=;
        b=FmIsoTvqiNzVRE7tNK4X3wH6rexG8xlPyQEjyGx+PZ/Of/dmhJGRjvmTBkSTUKg1sq
         nLMUr7hUPsBCgx4MX7JwsIfsqOQgXZdkOB+bqCxnJ10Fuc5UbjCqMd76W8AKMOqr7r8L
         HD6iV/oNHWsy1G67a2FNS9gvxiKJ/tnbNpdImJVkfvpmec5VNpkNz7GjbjAB2X7/iOmr
         mteO5UjJvdDLOuAtCn3afHmmmNXfSINO1X+K8By8U43nrn3E1dMwuEkh1g5CG8zVzaR3
         qGdvAfjhqoFLjBkad1bTtO8vDFApkJpvlLMMh6afq0Wq2BiPEzcKV1WuiyQMQ5uAOiDq
         xRgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkR9Vx8pVjMUfDCaqkVEmNW6YWTS+bd1KFg2kI/UYToovcSSsKwfr2iam/Ajp+CPfKBWwAFRI2hg==@kvack.org
X-Gm-Message-State: AOJu0YxZrbwUOGF0uLlX90GfJ20F15M2XVk6GMqRNTESYYy6YMGTc+Am
	Qi6G8haSDoaKReb/UyX6X0nH9uZ51AJ64Yf00nOcJbCo2+VLffZwbcvd3/3cn/+Isjyf0EE5vyC
	pxA3x8cMqMr56XirWYADm79zONkU056+YIfhl8mYDHg==
X-Gm-Gg: ASbGncuHSd0sIgyOD6oiNHdfUoHhNKhetnL6Gp+wDKYC1ahpx0FCB5y/L12oOYkrp2G
	7uwYOI76A8jp979dCIcqruvkf3lgkTu1MT23VWJYL+NnrURdB6jel3YAr085JPb9Rg9IvGS2QRp
	c3Oph7V7rYeNjiRnFeNOFxOeloBp3vMZU/LE/5s4cdziGha1lvRRh+guP2n+a2zJQSpDMhQyI0e
	QOTUCMJP47Oea2axn433RFmaoEeH26PqLz9eACHAxBVkHUz0F7VtViNMQ==
X-Google-Smtp-Source: AGHT+IE0d8IR6rsEgJJ5sEY6LIPZwkDDtyCP7uhxPzIsZylx0Ljo5I5H+E2VC1AYiZBzamjHuFflAzaW25Tk+RHARQ0=
X-Received: by 2002:a05:6402:2811:b0:62a:a4f0:7e4f with SMTP id
 4fb4d7f45d1cf-63ed849802fmr1583600a12.29.1761609757208; Mon, 27 Oct 2025
 17:02:37 -0700 (PDT)
MIME-Version: 1.0
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
 <20251021000852.2924827-2-pasha.tatashin@soleen.com> <CALzav=egQiF6tanYxR9Tow7TnT_UK9bNAR_4DQ2P=2EJ+H4ZJA@mail.gmail.com>
In-Reply-To: <CALzav=egQiF6tanYxR9Tow7TnT_UK9bNAR_4DQ2P=2EJ+H4ZJA@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 27 Oct 2025 20:01:59 -0400
X-Gm-Features: AWmQ_bmk9AWMUDPf-FAMZS-KNcWHzhS4VhXBKhx2xU2ISRIlSsLkq3B9EbQYovg
Message-ID: <CA+CK2bAibAPzTq+edRTXS9g7Cs0w-zCiSSrXUkoFAHe7=3C0QA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
To: David Matlack <dmatlack@google.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, 
	tj@kernel.org, jasonmiu@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 09A51100003
X-Stat-Signature: mm8dsjw57h4c8bmqqcpj1qoajoi3kqs8
X-Rspam-User: 
X-HE-Tag: 1761609758-19054
X-HE-Meta: U2FsdGVkX18PFDeNJOkb7AMnnDWWmAD8FNGqnYVUcZMVet4KNBRqZ4xQVK+kliomoXuUZVrrsziqjOAOETMhuSQohAajQ1iRKN72qYxZI7xNrZ0cXHlFtMFlfQaCFyNmRqdq0nQ4gP0+G+G02pcsA5jyUDemkQHyYPohIxYTBRMHIcUIn+gLWlgZTylJWW5bXmuYGj03vIeGH3rXBz63YWJOpKjmPR8VmdKuneeF9DJZhX/9UWmZCb5MEcZ2XOWTn2BH4WW1DaBWF7Xc0vwWJo/qDVwy4m1k4ry/GL989wYKueWk7hdM6MdP8Ke/W3AK60zBU1HArGpUv87109x9lDCENbJMQ+3oJ/Ggzi1mWNfCdN6xd8ZLLVCqPfQmEO4V/966MyYSyHszj9Xwb91ny+bgoDyZWlIzEZH8I5So9SsZVyOHsR7Qt/+mcsIb228wmDXjmMytn8HH9k7SBj9iyX2k0FIjpjT6mWytaKXNxHqs4f/Pd7mSnE3poiCatf7zOrbDs990JgcnEJVJohRsd/Ic+udeONlBO+sd3sbn8wFV0pIQN8PmDG7e9p4vtCmLi7rJh4/fl/ipJozvuAFhkjTo+RtMxp0MA/ucFxz022Ey7NiEFud6ETPvpTzY1913nxRJbThDwGxz3MkUeA7pAU2+37EkMRtPE/9diD7B0/FA02CVhLydxtX69GYEc4GB0h14VSJEIWqa4fPWotHTV/APY5tHM9ORNAFMRmg5XBJNW7P9buKieRHaJKzsgeRbF1AzT5ZjCY1n8upSj4qfXVybGRbr/UcFXT5FuPqoQKPwgdKSg4QRFPtEyQ5bUW8T/gp3ngYJ75XyM2iC37Vcodb8l2CZTtr7MtSzKMwh/BSl4xmiWuqG422Xk5fxG+pf7MHB8IjGKdjNdC27IwcIFt14kNBsphmibrNvEbvl3Q1GomHuZpVopwiXhFYTp6ipM3zg/vfk+5jAqscXYoK
 f7XrHPH7
 Uo6E0DBF4oWD9QKpM+6RKJa4/8UpjVZ5aWaWL+CndFpf19paHUW0avx5Tm9qryq+Ld9C0GoSj2DMtIBDyW73xbkut8LHzVizOh/YJldl8nZsZ4rVdmaBTTJKGR+QJa/F/qWgIZJPI4Ay8r2tHGy/urRpcmGPkNpHy4l2geKin08tj/Q9japcqXadoMaSTRZrabhMzbl2qj0brthMNob8PBe1LI5M/SMWsooYmvi5RL9VBRs+sQlC1ZgOdmSEfHHYmx3xQqSRT09iADcUHVgulusEQZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 6:29=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Mon, Oct 20, 2025 at 5:08=E2=80=AFPM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > It is invalid for KHO metadata or preserved memory regions to be locate=
d
> > within the KHO scratch area, as this area is overwritten when the next
> > kernel is loaded, and used early in boot by the next kernel. This can
> > lead to memory corruption.
> >
> > Adds checks to kho_preserve_* and KHO's internal metadata allocators
> > (xa_load_or_alloc, new_chunk) to verify that the physical address of th=
e
> > memory does not overlap with any defined scratch region. If an overlap
> > is detected, the operation will fail and a WARN_ON is triggered. To
> > avoid performance overhead in production kernels, these checks are
> > enabled only when CONFIG_KEXEC_HANDOVER_DEBUG is selected.
>
> How many scratch regions are there in practice? Checking
> unconditionally seems like a small price to pay to avoid possible
> memory corruption. Especially since most KHO preservation should
> happen while the VM is still running (so does not have to by
> hyper-optimized).

The debug option can be enabled on production system as well, we have
some debug options enabled, but I do not see a reason to make this a
fixed cost that can add up; the runtime cost scares me, as we might be
using KHO preserve/unpreserve often once stateless KHO + slab
preservation is implemented during some allocations paths. Let's keep
it optional.

>
> >  static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, =
size_t sz)
> >  {
> > -       void *elm, *res;
> > +       void *res =3D xa_load(xa, index);
> >
> > -       elm =3D xa_load(xa, index);
> > -       if (elm)
> > -               return elm;
> > +       if (res)
> > +               return res;
> > +
> > +       void *elm __free(kfree) =3D kzalloc(sz, GFP_KERNEL);
>
> nit: This breaks the local style of always declaring variables at the
> beginning of blocks.

I think this suggestion came from Mike, to me it looks alright, as it
is only part of the clean-up path.

Pasha

