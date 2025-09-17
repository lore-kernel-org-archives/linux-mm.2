Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A909CCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 23:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E85F78E0092; Wed, 17 Sep 2025 19:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D918E006B; Wed, 17 Sep 2025 19:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9AB28E0092; Wed, 17 Sep 2025 19:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAF8D8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:59:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69DDCBAE21
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:59:58 +0000 (UTC)
X-FDA: 83900412876.02.DB4F102
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 748EA40005
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:59:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gsdotJLG;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758153596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+k4UBANduixrTliP8GJRSvLIs5e04GQ1F54MlhsKt70=;
	b=SP/Cc5p1Fh5fGc137jddjoa4lgxIskU+v70GMjv5XqClHM5zpU7VXZdTQZu7O9AD8YHgo5
	cR1GZkFuviWdwz/jXrYdvUTlH65SbdQgNONN43amTd/HUqvYTkTHCG6WO57Qa7UDoYj6ZC
	czZySdoCXf0qSKGTMpMNJJEaZAzsk+Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gsdotJLG;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758153596; a=rsa-sha256;
	cv=none;
	b=yI8Nr64HhkkSLr/TtRs3JDrfw4jlBEyL2LsFGPbBpXX3hBot2WZ+g2GSb0GS86Lh17NDmA
	Nk2yVfE0HwzrjM0DWPx+SRUbmUTEmlSgDWfiQ4KhmdeO1rUnq+b+aA+M78zuEVFD2frX8i
	0K4V6vlRXoQfUp4uf5FQ9CjGFHqRRWA=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-62faa04afd9so85a12.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758153595; x=1758758395; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+k4UBANduixrTliP8GJRSvLIs5e04GQ1F54MlhsKt70=;
        b=gsdotJLG5Z4j9nDAHSNoKpIv2vsO/R0dQOXpUtNMCo3jDykXK0itA1eRH+WhhIrmsa
         0SyuFcbLnVfBi/PNH8Urcxsku7pmqrHnOQxUmysp+gP/ZlNl1qWdfbFOLkh73a7kp3cJ
         u/J6oE/FgMRcajLtnIXlcKc+4spG3F0/n9fw3FtN+pqzQaeaK/cyi9jYzMvkHjCRDY0Z
         bMthmALpJ8FK2BBNvip2sobfGTrQiKeN7sUigZRBWOhrz4GRh564+CWyZQyYqkPDeEi/
         xJjs4BKEtlsEb664XI9fEy3CYQh8nXTQUKVvX9BKfylNEUB14CNytcP7DMtoWHjjGJ/M
         +z5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758153595; x=1758758395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+k4UBANduixrTliP8GJRSvLIs5e04GQ1F54MlhsKt70=;
        b=frLx/xNF81QW360fERY1MyH7NGuDWsaFNU2aqay4fRo8liIlPLWkpRD740xBcOHSSf
         kFHLQeTjxwDFDQhAzISkoR9S31VgQXFYKdDtQbHCcGAS79/+tyorczCs2Bzxb/fWODrt
         TowfWj8O2RGnw6VNvg8jpr21osZY9UvikfWY5ntlJJe0pk6llBh6ee69fu0yykbEiVRY
         JWMMZ8MVcdgnd1c733p4IctRspNcAUqWqVMhKOBUzeOjp+TS3128kIXs/lb70XSUFatr
         AcaK9xhyNd5MarMUCmgQgpztNbyd8CEl3l8+FlYg5k0UQlTOz9FoFU8cq0kfGJ7pRpEW
         PZaA==
X-Forwarded-Encrypted: i=1; AJvYcCU9NbgSnau9XhAzQO874rAiLG1pG+2+TyyK12XZCJRPbtlnpjH6EisHe6aigJnK+KSKWtslVEJg0w==@kvack.org
X-Gm-Message-State: AOJu0YwotgCYsHUGvwMqLLV8JCsj+DiOwkd0Leej3GrSeslOYxPUGJWM
	C0EI7mPAFOm4jJTJoFECpKA5Mb4DTWgycIcEy7NR+HYbMIChbw3ka9jpxw6ehhvQ5vRMcPpLfCp
	HXoNqZt0azdObCVF0i2ndLnVro2SizcptpZzgKIcr
X-Gm-Gg: ASbGncvJFyq3Y3+vf9wl/BVu4vryVJtULPsDBSd6QEQtGI9scKSvBUjiIXxZQOLp/Kw
	bIS3UuMrpL2wTQwnAWW6d3EGlKjcQgZyCVgGWGKpyi4UkT1dgdWVoLnl7s2tNJExJwyFpH5DZVx
	9+RyNneMvFxnDkqDZcDT6JF5Km+BAYHllrBNEe9FHLFaSUthDdIG8ixzbq9+RLmvTc9onpO+2Sf
	MGdEs15HBdskn/+qwvEkI9jx5kLgnE=
X-Google-Smtp-Source: AGHT+IGwvBQ/ma4OjhAb3mJBBGrTHlUUNFKF6gBGTFjvv6da4khKOL5MOMEB4k37fIEHnqabA3kXBI6Biko6ndlOJCc=
X-Received: by 2002:a50:c05c:0:b0:61c:c08d:359d with SMTP id
 4fb4d7f45d1cf-62f7e134801mr85622a12.4.1758153594515; Wed, 17 Sep 2025
 16:59:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250913000935.1021068-1-sudarsanm@google.com> <qs3967pq-4nq7-67pq-2025-r7259o0s52p4@vanv.qr>
 <f5792407-d2b9-42b3-bc85-ed14eac945ec@paulmck-laptop> <d1ef1cbb-c18d-4da6-b56b-342e86dca525@suse.cz>
 <CAJuCfpEQ=RUgcAvRzE5jRrhhFpkm8E2PpBK9e9GhK26ZaJQt=Q@mail.gmail.com>
 <aMpE-oSjtlDU4TSl@pc636> <CAJuCfpHQ_JedSRHKKoYXyVzaFOm=dDWzgFZwqerfEC1fn35j0w@mail.gmail.com>
In-Reply-To: <CAJuCfpHQ_JedSRHKKoYXyVzaFOm=dDWzgFZwqerfEC1fn35j0w@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Sep 2025 16:59:41 -0700
X-Gm-Features: AS18NWBx5aUJDxzgSbTWFT8kC_EPDfnr02N4rctMkVtLm9XJWaAMV1S3L1bSwvY
Message-ID: <CAJuCfpE48n=QM0nY8yE3drqZU0wgC76=70EyftL1WZewEcykyA@mail.gmail.com>
Subject: Re: Benchmarking [PATCH v5 00/14] SLUB percpu sheaves
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, paulmck@kernel.org, Jan Engelhardt <ej@inai.de>, 
	Sudarsan Mahendran <sudarsanm@google.com>, Liam.Howlett@oracle.com, cl@gentwo.org, 
	harry.yoo@oracle.com, howlett@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, maple-tree@lists.infradead.org, rcu@vger.kernel.org, 
	rientjes@google.com, roman.gushchin@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 748EA40005
X-Stat-Signature: qnzqht7oineo77wodimr9mtb9m7nj7ws
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758153596-540147
X-HE-Meta: U2FsdGVkX19m2VUZumLtugHOdC6Qn2O0BkEV26m6y7ym2fBzUW+YvADEOk0nj1qkYq6WTPMgI5kMsWM0gHc/8/GrHrDb/uYjwdhNvbXUtUm6kpgntp9jotQev7veHWH+krwQEsh0+d9BlWHOlpibAMwYvd5Kyr2O0WOVJCkw5nki1MEHBYZ05BL8l8IdCudodGn533I+yiR+x1PHCVhgmLbdd3mXcuQe6f2Mb1cS1lBlCRbz5mmi6dB21v49mun4S51923/NrcH8Xr01pVicTEmP1yDDftIcRJdmflgEXeB5vodm7B6qB0KSPqeNtqnRRJ/ls2fforVakXUZwqLkABz9s6//Hr+3wJZfFELKggIg4LCObMSPn6Eo+dlG69llEP7sD8jx2ZlJUrJQTiF0PlM2cwdj8XsEHW3Orj3Gc6xRqVJ1aF3t5bidRr85z9erZ9XSO7ff+7chkeJjhwLsw7x5nNdj/Fop1zGAws4lxVXkDsVTeUsEK3WTxTxJ7SMuOdYO8a7cJI+wOCeHx3/Faej1D1Hy9Ri403R73P4BdADfRPyw7YYGW6crSeT2O261d7GurkFjWUBcmwyj+66xSgDNnd2qnFOgyTnv/SFW9lu3a8ALSTUtkh+yi7aq17VtehZG/OMxkTOnfbAs2AxkC7PvelofLsbqVC0/rV+bgROhUPg903z0wD8kO3wtFuK2Y/358papmWugBVY3qYNY85dp8wAB/dZ3r5YrkzE7ZWqvqPudRwbQMhp9gO9SyvxTVD0L+aultWjCRBzF20scIxGHvDJLQngpzb5fTo5DrmowdSz5Uz0ZYWzfaXC9UVRMEXW8e5wC3WAAlyl8oSGXK81O/TvO2e6z8wXBIfphVvY23NGb1IWjZEgZxl5X1tVarTpoMShSse7SXqts7wfiBSfAnKwrkY5RdM020Ml3FqtcrQOqH4Y6X/H/1+96mBfTltyCbxyaJQF+ewqz1EN
 WM4F0kG+
 vvfUFX8Uk6X6f9+01cAhfhG9m7k/smBCoOMDl+F+S1NiTvyi2h3IcYxt63/EqvlOby1jjYzY+jF6Xdi3vo9d7Kh0QpNoPi+mZsZYWXY7dLKzywPqcMpPYGIP+jYj/rB2WeRNE38TpsIl6qdEA9+PD1n7ea9NGPC54jgyPpFD0JZGIR242UsXskz/yOU1fPjybsDVp/GJsV0vwsh0GnRFxDpbDnSHdSwFsCxThKs1S2k1o9DM1E3aVIjB4sA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 9:14=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Sep 16, 2025 at 10:19=E2=80=AFPM Uladzislau Rezki <urezki@gmail.c=
om> wrote:
> >
> > On Tue, Sep 16, 2025 at 10:09:18AM -0700, Suren Baghdasaryan wrote:
> > > On Mon, Sep 15, 2025 at 8:22=E2=80=AFAM Vlastimil Babka <vbabka@suse.=
cz> wrote:
> > > >
> > > > On 9/15/25 14:13, Paul E. McKenney wrote:
> > > > > On Mon, Sep 15, 2025 at 09:51:25AM +0200, Jan Engelhardt wrote:
> > > > >>
> > > > >> On Saturday 2025-09-13 02:09, Sudarsan Mahendran wrote:
> > > > >> >
> > > > >> >Summary of the results:
> > > >
> > > > In any case, thanks a lot for the results!
> > > >
> > > > >> >- Significant change (meaning >10% difference
> > > > >> >  between base and experiment) on will-it-scale
> > > > >> >  tests in AMD.
> > > > >> >
> > > > >> >Summary of AMD will-it-scale test changes:
> > > > >> >
> > > > >> >Number of runs : 15
> > > > >> >Direction      : + is good
> > > > >>
> > > > >> If STDDEV grows more than mean, there is more jitter,
> > > > >> which is not "good".
> > > > >
> > > > > This is true.  On the other hand, the mean grew way more in absol=
ute
> > > > > terms than did STDDEV.  So might this be a reasonable tradeoff?
> > > >
> > > > Also I'd point out that MIN of TEST is better than MAX of BASE, whi=
ch means
> > > > there's always an improvement for this config. So jitter here means=
 it's
> > > > changing between better and more better :) and not between worse an=
d (more)
> > > > better.
> > > >
> > > > The annoying part of course is that for other configs it's consiste=
ntly the
> > > > opposite.
> > >
> > > Hi Vlastimil,
> > > I ran my mmap stress test that runs 20000 cycles of mmapping 50 VMAs,
> > > faulting them in then unmapping and timing only mmap and munmap calls=
.
> > > This is not a realistic scenario but works well for A/B comparison.
> > >
> > > The numbers are below with sheaves showing a clear improvement:
> > >
> > > Baseline
> > >             avg             stdev
> > > mmap        2.621073        0.2525161631
> > > munmap      2.292965        0.008831973052
> > > total       4.914038        0.2572620923
> > >
> > > Sheaves
> > >             avg            stdev           avg_diff        stdev_diff
> > > mmap        1.561220667    0.07748897037   -40.44%        -69.31%
> > > munmap      2.042071       0.03603083448   -10.94%        307.96%
> > > total       3.603291667    0.113209047     -26.67%        -55.99%
> > >
> > Could you run your test with dropping below patch?
>
> Sure, will try later today and report.

Sheaves with [04/23] patch reverted:

            avg             avg_diff
mmap     2.143948        -18.20%
munmap     2.343707        2.21%
total     4.487655        -8.68%


>
> >
> > [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu() opera=
tions
> >
> > mmap()/munmap(), i assume it is a duration time in average, is the time
> > in microseconds?
>
> Yeah, it ends up being in microseconds. The actual reported time is
> the total time in seconds that all mmap/munmap in the test consumed.
> With 20000 cycles of 50 mmap/munmap calls we end up with 1000000
> syscalls, so the number can be considered as duration in microseconds
> for a single call.
>
> >
> > Thank you.
> >
> > --
> > Uladzislau Rezki

