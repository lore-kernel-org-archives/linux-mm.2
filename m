Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D13CAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062868E0053; Wed, 17 Sep 2025 12:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03BAB8E0002; Wed, 17 Sep 2025 12:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E926E8E0053; Wed, 17 Sep 2025 12:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D358E8E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:14:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76E1ABA466
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:14:51 +0000 (UTC)
X-FDA: 83899240782.24.738BE55
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9D3BA180010
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:14:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nptjwt2H;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758125689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OArBKu/OVLMzSppvTMJHRKcjYiNm1Tha8BBwDyvcaCw=;
	b=IrbifzHUYAZkSedDc/cwlV/3T6mXiPnFZ6fXQqroufjyhl5VcRwfDEO8Jls5Z6JO6ieca3
	tINg9DJmrDThPcRwWyV2o2NQuqUiL+dg+898vcF+3dShfwNvBLjZ2UwF8hzYcbbBlpgZRr
	c7CRKDqBPsbzfOiMr/G906gfzPU0IDc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758125689; a=rsa-sha256;
	cv=none;
	b=flfWdgCo65C1qrTReBdlDGPqAoF6AWe9Vsrub37azVqosbLmd5aK7Ec2CdrZ1rqKuSxvsf
	xl77VhHOMjn9yCtB65vMtRxIEkGqZbOOe/Uhq+CxkF1GrGAsSXvZql0zBwjVJFobg1fAjG
	cs/8Da90BHQQgQ+FGCpn7ZRboev5tkk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nptjwt2H;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b78657a35aso326021cf.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758125689; x=1758730489; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OArBKu/OVLMzSppvTMJHRKcjYiNm1Tha8BBwDyvcaCw=;
        b=nptjwt2HtRQfKAvXiPwIYX+Y1ichTwvujVi4AiLxLn9S4JKxTTnqLU0Z7Y+EPe2G2b
         2LQPEPJAYXJ0vQls8k+v3gZokMVpSSmtRAoN3Ev7xvZj6oTsVsKJbofYFZbVxoyR9lP4
         L4wHJJO1esKFt6S2rVfrTPShJER2gJzFrNOF3PGs0R7T9JxbuWSCPjiQYbAxFJsQ6F/v
         5iFL4wskTB1XiDmI7tFsnSQop/RsVnHXDB3uVTTl9URazYPA57HZUMdZirV5e87oDw6Z
         GochTweMiK+jEBimuC6xtE76jVKA4HZb7B8cBuvxfqyIIIX2QkGvTectd5VH2Hqzua5Y
         Lryw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758125689; x=1758730489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OArBKu/OVLMzSppvTMJHRKcjYiNm1Tha8BBwDyvcaCw=;
        b=pzCwXZFq6wlbG006QA5LlKKg0tKw1qwdppoEaYsSN7/soqe8bzfqL/K4RbYWh1ruuC
         oflM0rFv35F7b78oB3OuqTZ0WCOXvd4EaL0LHfh/M9kKytgkpb7fPQRfaBUb9GbM78ha
         AriZ2DEZha3V8RhvL2QAIQN3dYQv+GMVR3vOCPFbl/fFdFyBWs7ZLgZ+Wd+0QL1W1mZJ
         16jaHWbf2m/BdAT0zsPCvu9J+yakTqJGXGL97av9KBvmz4GlXN+UlpldCVOYoN0pIOw5
         m3QSer7W1xgTrY3LV9kkfwmIxPnYHo8vaOOQeX3BHLV+7Ggfxh0u2QWcbzoqmdAoTJ+a
         1tcg==
X-Forwarded-Encrypted: i=1; AJvYcCXpGK4CJmX33osJVaNK8gk9uPZ9ARLiOrFg7OhZ0+nNKyQcTnado8jCAOAC46wPDRX/Rokh3zdUDw==@kvack.org
X-Gm-Message-State: AOJu0YzJ5d4BTuX5c83s7HGGDcqyF1FugdLCELYWSVy2+cXZjNRkJ9oD
	Zan0M8oQJhg0vP9ofoZsW7LJwSWI5hDukcm/3bWtVauO50tbc30shLKg5FW7qdfSAciSZI3mJOQ
	WfkWbEFNA9bKDLOYUlROjjC/RozIPokAQSzPk2E99
X-Gm-Gg: ASbGncsQJ9vgFLr0iD+ZKywB3c06+CMyPEokkpVN5JMM8F4gWXOgP/mYTapubNHyZvc
	soytfZZN2UsisUEqUNdqtL0oOx9toLBfy9m6LWNuWVqZcUPlG/i+Mt6MOFD5tQbstLTtmueY4fx
	UQywsS4ku0DL21Z8RZm1Gecqr3MS0o6QmPL7YVF/QT79bkHZ3CgXNxkKLt55M4gbNMmE3ro8wg6
	uBhDhyxGR3YlAz6FRnAQvyexpW2tgvNId9DDbo2N/F0axRVBCaduw==
X-Google-Smtp-Source: AGHT+IG9w0PDQP5VzsbXW+qZNvO2uClVZrTUiqPIC6ePHQIbByt0FQbuPg77WNGmS8ZH42TU2TS5A3kWp2z/r71KEQ4=
X-Received: by 2002:a05:622a:1818:b0:479:1958:d81a with SMTP id
 d75a77b69052e-4b9dd4b6fa5mr7747081cf.6.1758125688026; Wed, 17 Sep 2025
 09:14:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250913000935.1021068-1-sudarsanm@google.com> <qs3967pq-4nq7-67pq-2025-r7259o0s52p4@vanv.qr>
 <f5792407-d2b9-42b3-bc85-ed14eac945ec@paulmck-laptop> <d1ef1cbb-c18d-4da6-b56b-342e86dca525@suse.cz>
 <CAJuCfpEQ=RUgcAvRzE5jRrhhFpkm8E2PpBK9e9GhK26ZaJQt=Q@mail.gmail.com> <aMpE-oSjtlDU4TSl@pc636>
In-Reply-To: <aMpE-oSjtlDU4TSl@pc636>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Sep 2025 09:14:37 -0700
X-Gm-Features: AS18NWAl3tnnsDRXh1YlHaUElOip_SV2qsqTsXfBx-HZev1MuKyA-GY3Dn540H0
Message-ID: <CAJuCfpHQ_JedSRHKKoYXyVzaFOm=dDWzgFZwqerfEC1fn35j0w@mail.gmail.com>
Subject: Re: Benchmarking [PATCH v5 00/14] SLUB percpu sheaves
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, paulmck@kernel.org, Jan Engelhardt <ej@inai.de>, 
	Sudarsan Mahendran <sudarsanm@google.com>, Liam.Howlett@oracle.com, cl@gentwo.org, 
	harry.yoo@oracle.com, howlett@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, maple-tree@lists.infradead.org, rcu@vger.kernel.org, 
	rientjes@google.com, roman.gushchin@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3x568eytj9qd5u18nxae44ipioe1w7au
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D3BA180010
X-Rspamd-Server: rspam10
X-HE-Tag: 1758125689-125217
X-HE-Meta: U2FsdGVkX19oK1DbrNfJa6CfQVG5A0VSG/4UrXif2bumugItBsX3tbRVorwP0dDdkiIJF7RhrcDsbuyAi4Q5daOpRglQijIGCTvcHCEyK/PTi6pw0Xzw5hsQJwQ7U1KftnNwo2k0Ti+oLGcd/hWKFX5ZCtYl1Jof2LOb/DwD9wY3bDJCnEwsEUyCOcsNu9BmzXFgU6MPFHOcAAmB7MxgUSqpqEPhNArdajVCN40tBe0/R+rLqqq9pMT05xn6C65fb4X/qZQoBz/lSkRjxW1No7WT+DpwSN0oEUEdaxAJ1GRbMuOoeX9gQ71m2twZfCErHOv5Rdl2wlmo6DPNntmx+L43HWqWjNmJJm4L2uzIZWryJzW/cQStUQ33CBhktfSDPXuXq79fGOjqOKFuW74rTkSv5kKQ9cA1ioxClaTrpI80OmzmwqO6B+lCRwnY+OiCqEJL+S2KJoWfEBqo38uz8CRGsm5moz7Rx/ssPrJ8Jm92WlqZ+3IvtlC+lUk2dlZL7rvEKNEJZMKUAvDSe/VeIlZMWPrYXCN7tMHrzXaoUnzSQPYlu7NgOMRQv1T02HQv/EEivNB0rJxRrO4NVV9w03yP1Tc/8fSiNiIt9g8id1Q7+jCMloPu6xbvAKemFvAY62obNEAAGorctZOkpQ+9qg8Eh/bIiuQg/4lL+54iy1MuVufyrFhrUYYUgeIOPEv584cHQ0BxVwIeL94Ub//0JzTrIwTHblYpOmCh/AqKwoA4gNIKuaAqmjU9zG1sG2Lmi+tsf4sgFDcteIXXc/LEqE0zWA5C5/su4PxI9rMyP4kab35a4RqoqLQsB/TZUud/P0S33VEuz4sanA+MOYnmvYgud3sOQwU/0m4IjBv4dqbBdZbLXrb7Zzc4lHfPkA+TdfIO9gPWUTctogmSV+DaUp4c/uEl9Fdu8LaSiv6mVZguFt49rBCh22jv11dXA2ULX72s1zQSBiMT59fip56
 iEZcGvoP
 AQ7lTmjAzoDa1gQ0M1/tGZGnQsJt6W9pO9pQtBW61jxvX/T+KYUJ+/Vdc3Yodx1Sq73qB0ZMihxvE6pPWOtQ1Ggrk9lJOwnl9cbNCSICic/DMGSY7CgpEM2zcDB7tmZ7IXz/tsBml6db+D04zBi/11AQVpxqzMb9mYy23OKznbKGBna4oX6jDjbqqPTSLWJueYf2UTaemVoDljXEkl7H4OBT8CqqvUPMcNlqA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 10:19=E2=80=AFPM Uladzislau Rezki <urezki@gmail.com=
> wrote:
>
> On Tue, Sep 16, 2025 at 10:09:18AM -0700, Suren Baghdasaryan wrote:
> > On Mon, Sep 15, 2025 at 8:22=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> > >
> > > On 9/15/25 14:13, Paul E. McKenney wrote:
> > > > On Mon, Sep 15, 2025 at 09:51:25AM +0200, Jan Engelhardt wrote:
> > > >>
> > > >> On Saturday 2025-09-13 02:09, Sudarsan Mahendran wrote:
> > > >> >
> > > >> >Summary of the results:
> > >
> > > In any case, thanks a lot for the results!
> > >
> > > >> >- Significant change (meaning >10% difference
> > > >> >  between base and experiment) on will-it-scale
> > > >> >  tests in AMD.
> > > >> >
> > > >> >Summary of AMD will-it-scale test changes:
> > > >> >
> > > >> >Number of runs : 15
> > > >> >Direction      : + is good
> > > >>
> > > >> If STDDEV grows more than mean, there is more jitter,
> > > >> which is not "good".
> > > >
> > > > This is true.  On the other hand, the mean grew way more in absolut=
e
> > > > terms than did STDDEV.  So might this be a reasonable tradeoff?
> > >
> > > Also I'd point out that MIN of TEST is better than MAX of BASE, which=
 means
> > > there's always an improvement for this config. So jitter here means i=
t's
> > > changing between better and more better :) and not between worse and =
(more)
> > > better.
> > >
> > > The annoying part of course is that for other configs it's consistent=
ly the
> > > opposite.
> >
> > Hi Vlastimil,
> > I ran my mmap stress test that runs 20000 cycles of mmapping 50 VMAs,
> > faulting them in then unmapping and timing only mmap and munmap calls.
> > This is not a realistic scenario but works well for A/B comparison.
> >
> > The numbers are below with sheaves showing a clear improvement:
> >
> > Baseline
> >             avg             stdev
> > mmap        2.621073        0.2525161631
> > munmap      2.292965        0.008831973052
> > total       4.914038        0.2572620923
> >
> > Sheaves
> >             avg            stdev           avg_diff        stdev_diff
> > mmap        1.561220667    0.07748897037   -40.44%        -69.31%
> > munmap      2.042071       0.03603083448   -10.94%        307.96%
> > total       3.603291667    0.113209047     -26.67%        -55.99%
> >
> Could you run your test with dropping below patch?

Sure, will try later today and report.

>
> [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu() operati=
ons
>
> mmap()/munmap(), i assume it is a duration time in average, is the time
> in microseconds?

Yeah, it ends up being in microseconds. The actual reported time is
the total time in seconds that all mmap/munmap in the test consumed.
With 20000 cycles of 50 mmap/munmap calls we end up with 1000000
syscalls, so the number can be considered as duration in microseconds
for a single call.

>
> Thank you.
>
> --
> Uladzislau Rezki

