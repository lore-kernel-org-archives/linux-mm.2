Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C782CD98D5
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 06:56:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11906B0005; Fri, 12 Jun 2026 02:56:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8206B0095; Fri, 12 Jun 2026 02:56:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF166B0096; Fri, 12 Jun 2026 02:56:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B06796B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:56:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 587468EAC2
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:56:36 +0000 (UTC)
X-FDA: 84870352392.05.2F083FD
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 480F91C0007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 06:56:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xh4MYPwQ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of glider@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781247394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lBHS9HDKEcHXBILsrP2x1PQFt4q9srNsFjMrwfX9Vs=;
	b=a1mA63JBw8DUOJkNiDUFGWimU7yjoaI/g/n8m+NefO3JTjlkuEJIbzz0iH7JF/bdwyQYzu
	+m6refBoTBON4AGzxTkvAc8QS89Q3owaoMqYG+lMRPCgzth/SLRNYtWiAdGTRA1RxO5ehI
	lcHAX4cIZpmNdPIQVNpCIlw2jMhS0C4=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xh4MYPwQ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of glider@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781247394;
	b=bcZjFUEBa5aTjiZMpd/l3cnANtjqSJIaD+qG1e+/i6IgBJlJ6As/IjzZNgIxPjy5HjHmaj
	TWfSsJay1nIbQw5DwdT11VJe2jWidG44/5ofYyTNamc/OMIo6KxtZf5uwzFA4K0r5uRN3U
	fOAr0FCnd2sCvW5rr6ObcJAKZGloYLc=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-68ced97b6eeso1032950a12.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:56:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781247393; cv=none;
        d=google.com; s=arc-20240605;
        b=WLbaWevT7c7huJ4q6PSvbW5Cmb4ewHux1PRemPGrzefFvUTuF4XTYk+LYvtXmjNVnk
         hhzeOSiBwLtG/Dgla3pxucOoJF582CLo9buL+GVe0/PQAq1SFAeCWZKEEJdBpDioN8wP
         E2loToEo3/HY491bykkkP2uajQxBk+09FtJ6GKbLqIYuKeufVnZbu3Ge2XiABeILjfR1
         srSqXTluTWDbGx+CAFY2d1ZeuZvSZWELzy6LDtjCK9gq+K/N1P3hxMDnncR2FFWAUlfG
         7dkDQI1q/W5N+sZ1zTgFV9ribwUinwXcr5vV8zFs0erYHpT11YZeZuW03/44HLP/ZZxp
         FIqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3lBHS9HDKEcHXBILsrP2x1PQFt4q9srNsFjMrwfX9Vs=;
        fh=OxhpzliYY1Mi7KrB9pa7ug5wf5Wnun0slwdUNV7wJfA=;
        b=IIDEZ4h5Tu0XlDsdWxzeD3K3ZZTx54G1eUEW2roxDVrof4JU6yHOrGyr6N2qWH1e1/
         jQN+lHxBHH6F+125CJCNJKtnK9xrNRRvSKsMRC5Z/YHjhLtVuLMWelwUjksGj9oGHK8x
         JJcTUMpBYFcFSL5QVkANlihTdXfYwX+Y1AQEPg2gD9MGMPA30SV14yZtUkG+mSkxxFRI
         dFL30wOWxeKvwiPmIyal0EETCWFsAsD1JJVdegDDubuZfadMYjncnTxrsU22GBuQtw4M
         BHTfaYmbJWRaoBDuvas0PNKofNWkRSHSB3tbVhRP0S9OCVMXD01XEvv8USVhK9i4s6ur
         4wiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781247393; x=1781852193; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3lBHS9HDKEcHXBILsrP2x1PQFt4q9srNsFjMrwfX9Vs=;
        b=Xh4MYPwQMRQ7RVk1QUczVPg2EYd+7WZ1ocAZWxa8HyUlrqZiWuyUIUw8MU/s1bMyYm
         4BDe3lYEZpQXhQtpDuY3QMTcMIp0zfCW1t3+tidSxtR1GKv1MPnppRQ7WfMsPK8B9f8X
         pukMBmOsrOTbhc4eTRIGf1jEGeympYONM586SU/d9tcLjmY3xRyHy8+yHqN07qSwxG5q
         FBPE3dC1p3r5nGERUMt2aDeCxobjhPvfrTAo3lLEkqRfc/EhNJeSEQ3h/nBDIeus3hio
         cU3DdBjIeGZCl6Eyb8wpLATCMZMpBKyKljhFrrW94xZQR4x3SAp/ApYwBnmNt4m5VOpo
         b4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781247393; x=1781852193;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3lBHS9HDKEcHXBILsrP2x1PQFt4q9srNsFjMrwfX9Vs=;
        b=iQg8XY5lJooLaGVSzSe/HqyH1slCyy7WrId/6DJlqlFXgqDGMHVY11YQDwm10gaS1D
         ijyJnulG0mgv09Kpmy03YH2KJFCDjvSIQy7WcFM2pPa5t2I4dx05+iHk3L3LwXVba2hk
         6MYhqZgoYSiHP2qJr3Sqrc36HRpLL8Gl5nTK0N3VbnMQ1pG/rBe7wcgTrQWgxZOD8Aoi
         L9iXsE0Jj21P1wB6TaKeFLXWDC3kRCoCWciGd5r2P3k/pBV6neqUaWao7Y40WD/m6YxS
         WrwiR4U7mrRtFf/4K27+t3X3q2k/cEL3RHQ0hxicvhKz3yhpLFWRaiTcg6zoUjefH1OF
         +4Qw==
X-Forwarded-Encrypted: i=1; AFNElJ8MYrnZnaY787SyMEjEMUNOfg8DeGehUH+sqLmwzfHHg7SrXk0bKGcSzpG8hiScXQbgOK+pBAZBRg==@kvack.org
X-Gm-Message-State: AOJu0YysczBaQulpan8CabK2lWgigGOq/LPGF2i1Tgz1lLOELYkldO4F
	AQ41sR3HWz9IkbW8k1sT/FfxXy1SFHbnYH1PFJr5mlbuNtvJhHbZp10NcZhQfB06bJAVrCGxqJE
	5aOxA5anqvtu2IzUlQOwU4JCaSTGWEjVb6yZLmQWV
X-Gm-Gg: Acq92OGQArhFA2IevQtv9iGeo587nvku5hVAS9G2M2VtZbLioKI71qKFNjVcpmD/rkY
	YQR9RoE8u8QCg3dVKr5scHjzzkDVRKVzSi+1O5PXVjrBM/jq8J7NTsdJ8HdinSoNx9bP4VQ2FSk
	DmqxldUdFQf2D5sKHpBKD4HOszyMaGs4aOy8k3I5vGCCTETX2JtcmCtOQizSh61FJhNvuWnwaDF
	Y0H9Ihn2ruTk4JIncU11aIY5Ev6S1NsMXc8Q4yUNT6bBSWQ5nmSdPTP4ll8e84NqqS6sV5vug9n
	u/dKGgzHkDrvu2ke0PF8fboPUVyjZdM6fDaKtg==
X-Received: by 2002:a05:6402:434b:b0:68b:d10a:a48a with SMTP id
 4fb4d7f45d1cf-693784fb02dmr602313a12.11.1781247392123; Thu, 11 Jun 2026
 23:56:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech> <20260611-b4-kcov-dataflow-v2-v2-2-0a261da3987c@est.tech>
In-Reply-To: <20260611-b4-kcov-dataflow-v2-v2-2-0a261da3987c@est.tech>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 12 Jun 2026 08:55:54 +0200
X-Gm-Features: AVVi8CdLRn3HUIKr4oSFNxeMmeQ95IhSWpzIU1V25ylhb68DqGsVy-9EpMVuQUY
Message-ID: <CAG_fn=V1+_xLgCZgdLnT7Y-muRO0CXkrNKkC8AzrqzWoL4eR8w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 02/14] kcov: fix INIT_TRACK race in kcov_dataflow
To: Yunseong Kim <yunseong.kim@est.tech>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>, 
	sashiko-bot <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: nwaxkjo9imjrkr69sahaxz75pb3uo8o7
X-Rspamd-Queue-Id: 480F91C0007
X-HE-Tag: 1781247394-83835
X-HE-Meta: U2FsdGVkX19+h8sLlZyLNDGfLQaECJiJ+KF5hZq3yUZveoiNFq3Xdcc8UQ6yBOKLINXE55iSm3htVaNaTWQWPyeyWsbahGirN1ibVH4PxegcyDDCzMODlNq2O5Fv1iFzjJVzEFIAkSz+xwpsKAbAPsqcP47l4ZxPo3EjJtopN/OtuoZuNLBoRLOvkUYEDF2eGUDzqr8rdMflWIKsKRFxvXMHKKa3X9RuFJ7/W4K5eAPv1en+SwyzwQi93kfKq58fJBV3dxHVK0sP67nuIfFiKIu3LrQQ690KST1vO/wAXoCc21c6VZNJVGOrPM9VOkc4ynGh6b/WOpxacLMdBVDz/+67ezTrxQ4ABHw101Jl/xS4Nblkkd2RwHJm54qKl1miPOIkPYcj4N5QykNGVITbTEusursS4CtXosklHFujOweRKKk51CPpjPrxpdJvyWgNMAS0q47Skzrkqv7HvvgodBnRxSMA8IQLVkn/jxboLnrN2y0ouE5w4HJIYgLawtQIMXr6mxgK4F9HpUEakQPZbD1LoIX++lZYMdpmUKAa3Rz6uLfoSQNg0QX6tBsQTpEZbW7pk9EUSrfbPwfUyphrhRCm0Hnt9zxcpE4jgbdoLEkotvG/U94Ysx/1QX9h2zkpLCHGK5uM1Bd6M8oimRBKXKVHLCAtI4hvu+6g14cKUMzNA97WmEUtq0Vl/gYis7WeVC83KxUVYvozYXmm9EX0ijPtp1fqR5bU6dnTJtLNiCvy1j1jhrzAh47W8OsgqDn0f0oMk5P3mUE3AfnpS3GxAFL8tdxyXxoT0CeYMmfgfy6hCGJgdU4Eve4WoGTfzAwY5IqrwqrU3LLTgifro5rRBOd7bR1HT5i4BG9J659/C6CUYzidSuFbT+uY8d2Fwo4Q1/Hy4oXwNHx3/+hZ61s6ASB16PAhvw4fUVClozkBgEj3qn1pHoRsLQPV/wkRgJJTKfQm21uU2veF1d2KL7W
 eJI/TSoe
 wMcESHKaIZF579ZXMDnt0fdkVOr2DO2gym4Q7GrPFPV7FxLnQ4OY7DdNlYRDgRkH2KGiyQspWMkMcgHhz0Bc5HHR3GtC3GEyb8TIR4sDpP9jG/mrNZda3ESQr3i3aX93OU0ehHP/WSNjvbE5AczcxzUhItWXte+kvSh04jvWxImv8HLJm3NBewW9yqNoCrDUmAW7oBhYYcg5W5QLLsNP19Fol9e/ZZJNeVYGL5joubQjbY73meBv0+DrEGkZiWvJb8+0JPcmGlRXA81CsFAijifTGGk7u5sqPdTiiusCdDBKJMabfh6UswTqFUeQilaw2uqAF7QzLddmK204Q3BBIBMRFDBtyHWGrDQ9I2k4vp5mwAxnDzLCzUuM1RKzJ8gEpSgrQRCGL+N/sugsFKoXbjMAbuMzk4Qchs+r8lkNC510fx+hHQAGwyMq+8jyfvKddIvo+D80gYW3cw2QP6/ei6vZ+8PrBgOW4/FYADB1zjURkBb9rdrSZBe6hNRQqPs8NidEs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 6:21=E2=80=AFPM Yunseong Kim <yunseong.kim@est.tech=
> wrote:
>
> Two threads calling KCOV_DF_INIT_TRACK concurrently could both observe
> df->area =3D=3D NULL, drop the lock to allocate, and then both assign the=
ir
> allocation to df->area, leaking one buffer.
>
> Fix by rechecking df->area after re-acquiring the lock. If another
> thread won the race, free the allocation and return -EBUSY. This
> matches the pattern used by KCOV_INIT_TRACE in kernel/kcov.c.
>
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260603-kcov-dataflow-next-202606=
03-v2-0-fee0939de2c4%40est.tech
> Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>

Can we please avoid this?
kcov_dataflow.c is being introduced in the same series, there is no
need to send a buggy commit and a follow-up fix - just squash the two
together and note the changes after Signed-off-by: separated by a
triple dash.

