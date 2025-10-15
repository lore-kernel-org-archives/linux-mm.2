Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9009ACCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA46C8E005D; Wed, 15 Oct 2025 14:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7C698E000C; Wed, 15 Oct 2025 14:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91768E005D; Wed, 15 Oct 2025 14:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C829B8E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:50:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7826E139CCC
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:50:54 +0000 (UTC)
X-FDA: 84001240428.20.33DAAB2
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 914CDA0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:50:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UxTFHJVS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.166.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760554252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYCQTmcwAOXbAVYyQVpb75US8clqghkkSeMpq0zlPIY=;
	b=LorbSbmCmCMW/8xiC6EUY49zo42Oqm1BCmlhSHbLCLuSGe4xtwdbDSqmdYX0OI+l6pu3K2
	KGoO1MCvkSVL8mc9Tp1R8wA8J8MlcH6MnAyz8Tngrjq7VfNKv2kJpUT3nXqTqe4rDqGKN/
	eR58/BPrX6s8annMRwyZ4DWmeKeTkIM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760554252; a=rsa-sha256;
	cv=none;
	b=5Bsr9ilLkbUwsA1AbGTtcLttdgkZuErmWSmRMWt1ZKTAHlR1/ZgOU4ZYIr+Gp7t3U/ADk0
	sdI57EdF3Eymq8OpfRzvzySPxCS2yhMKZzf1f5NRItKvf/1G14VitmvCkkI4o19axborPq
	VSE4xhD/qclUhipVuuh83IcViigJuOI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UxTFHJVS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.166.180 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-430a0a715f9so51805ab.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760554252; x=1761159052; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RYCQTmcwAOXbAVYyQVpb75US8clqghkkSeMpq0zlPIY=;
        b=UxTFHJVSkTelkQfdbEJ6nt6+17jafSIw0t+b4uQn5d7frsoBtSxOIAz7D+euA7WMJd
         CW8wX5OcLyaQxRk+N1hnW341sSBZqT39V6j0PYy7aoA1PqALu7iVu7pvIncDu7S+rlQE
         YkdhtLIPIO2vqc3cnQaWNA5YNRBpgkhYCJ3ewTqQP4atZc5t1+sWqQsf2kV96DIqVomo
         XNITbQpv8XgEWfqCkZMyQCs09yn01AksRKcgYvinrVSssYXLPZtTFim8TEENCoZ31fgp
         lF1/Onpus3V8rIJflcHQDHzXzrJ0LuLxww7IbzN63jh1ytPIfsfIXqZByRhu7HrCkzee
         78lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760554252; x=1761159052;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RYCQTmcwAOXbAVYyQVpb75US8clqghkkSeMpq0zlPIY=;
        b=dh2t+fo9Bab6+oFktnlk71n7PV1TsWOGYMe9DNBIMtcdNVLZ7eOLkBo/esEUJCZpbY
         ibEwkxhw+8kkTKdDagB9Dzd9tPbm7YZXvlGnJD6HGKXTj5xZWtwVNE/io0LCQburd/xx
         aHV6vHFQl0DIGAo+DffGeTByJ9JxNpZKJkjLDLxeoPFjdaoJeA5th13I/bO+9qhgc5tr
         XjBmBk0pXXMmGcKAN/0aIWttKtezORQ3DBwkQ4EmNTc91yzJihp3LwFjspM/WyivduY3
         fPumK/bPmnPYjJoHehS7lcA1xsh96H4jlB0v1Hw5wcOaRORqRCid70FYjoDSSHdsXKHL
         5EPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjr0DUn+0vf4bxnXpFYhzgWxQJcAzYiYeAMct/N3OUx95m6yjX6jeih7xpn4XBZY7J64JWRx9AMw==@kvack.org
X-Gm-Message-State: AOJu0YzIa1PTx8l4WvQ4drYMg4svdbT4rNCy6KLjyBVbAk10BvWqus7v
	7XXSm/uU4Cl/WXlBw6hmwaMLBqXgSzzdIBD83VpiT2wkQWH5nHcn92DwIS+jumS3R7nl9obRPYC
	piLqOWO0gOmnv7clCSJdMwXp2HIba7jK9f3Hbv/OH
X-Gm-Gg: ASbGnctL90ku/zYUkCLtSvPs5Wwl9IE4LJ20nL1glM3grFmrXUCsUn8WSsQgP/DWEXq
	ZydVQJYuvCEbcOKoI+rthzKCCRl49lhMzAdDxeVPRS9L7U0Yd0t2sZ+7VQC+mOAe4Rd1/0qaAx/
	GNjufSeRWBq1YL/3vlXn3I1PdvqEcPtu1KHi8yEWgfosfpu/hp+Ojf2mRMhsTRgtzboPLpveJLh
	WCitkR9SKrQqBa7FuPqqb5U4WVcqkXeu4B1HbtbvoQfftP4guoMvlqw1UOcaYY=
X-Google-Smtp-Source: AGHT+IFhtYvLnXNUH8ojZN5pHVMGppEJ3dHRLngpUPsGt/2HbLQnvaa6Up8QbYh+CMCi32sdwQK+DoIp2AwmDxVZeG4=
X-Received: by 2002:a05:622a:4c05:b0:4b7:94d7:8b4c with SMTP id
 d75a77b69052e-4e882c9e0e3mr8734281cf.0.1760554250891; Wed, 15 Oct 2025
 11:50:50 -0700 (PDT)
MIME-Version: 1.0
References: <20251015145143.3001503-1-joshua.hahnjy@gmail.com> <421c7c42-bf7d-4277-b364-525c63254205@suse.cz>
In-Reply-To: <421c7c42-bf7d-4277-b364-525c63254205@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Oct 2025 11:50:38 -0700
X-Gm-Features: AS18NWCIA6Box0YKS8r3evI7XRw-ZheLidTmF5dXIWqHzjDgYO5Jm_gzVDaEftw
Message-ID: <CAJuCfpHDr95JnAkK_KzTU+VMLnHAuDVkFjPn4XnG4KpLtqEGLw@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: simplify and cleanup pcp locking
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: 554bynk7tin5mdcjo6h76aderfo467j1
X-Rspam-User: 
X-Rspamd-Queue-Id: 914CDA0003
X-HE-Tag: 1760554252-618712
X-HE-Meta: U2FsdGVkX19sExPn3l+C7cbKdVdBqdUja9KVS9ZySScU9giszAwo78sh53Y4RTMjroULTaq/uZwCs4HGzDP6mFIzXSdKRnhfBbICnMWobGj59evkSqK8mk7YaBRHu/h9LX22VRVn4bcWCLF8ym0ajncI2yyqBAVREcRAFThTpWoOYoajb1o5bDsUzBW9HNxKrR4KXBkIEbsgTe6ABs8Ey9Kg7l3yfG6l6C+DQN0CboIGuCbnQ5crq0DBgczFMc+B3CsTkRFLf2KL/Y2uzIlBNqZIa1CdCosXQ4Qg+JeY2FJLlhUO7IXDUluQsFbQWlpg+BdMJMi6co3aVFRS1uJLDaBpVcygX9W7fC3kuFsyv2UIRwmCcBbvv9ickQBsnws/fvWVMzwtkaZS+6uRwHVU4MT+929YKLDalUHICQQShJzIp86QYzPt0AGZkOSF9XfHsPxmFDBzuMrOHaxbbOSeMVKHi196U+XQv97n7IS9Q0ndSMHYTx8UIdIdSVeHwvDlswGqEdyxiHSXoySpR2BeDGTjco2PxuNRus6EIwJt4jqQpud0FKCECFjj0AyOvowQJn/YEqEjVxMSmCtbr61/5OAQZGRqG0bsJlcVsiwD99xB1Z5sG2VD53ses6fvXiA1dtNTJMuN7Gh+iBVE/ChNcP/oF4r+osdUmrxF9P6IZh2nDMHoPcMsBvlDY9h4RgpNhXXy3/8XoIKd/4LmbfT6PlNKaHhSnDYu5lRm7FTUCMmY8lY342JEV/jvkA0G/CTOeCVmfFoP4Izlp6m6swiim62LO9BXLl67qdwSoacZyPCvHlf714kwAvXwj1rYLPDqG94zqZRr/gxEQoOS0EhtWdDkX+5RQbNnMiqSYU8Y+/q4iA2LG7/QoU2nhmGTvPMdIgnnlHXgqxQlsqrQnvKKi2FLKj6+m39EQ44A2NStBf/NGZ79i0QJrT418ryUDXUJp45D2vmSTAR0ZxhAMbI
 nZ9wlmyZ
 N7gizC41fyZgGm9TCQXFCa2qQ/SayWP+LMwhN2bIWJstJJ6GQq+euMI19NzkpuWY05+D65NvOtWNTz/yWlaIe3hdLdKhGN+W7sIVYPkOWfnBtFN743ikpA+uRW3z7QUvxngJWwQV+6xVfaHwnBvYnNPlKOUW3i6H+9XUDBGQUbKYPM7xFmD/qAgZi03eEU+keFhUQkzUqZQ2NOa9DlbYGHj36qImpwiPt0crIbnQOgoZ2rYwhaDy2gvRIHQJUsggT6/KnCpnnLNCLrQjuaMZ4Tfs0QskSCBElo0tSVoI+VmYkTvDe+7R/n6t84mOPg8C+LUYAXYvVfA0WgUkZDHMnAit93R3/jMSPzdNYBKI0wJ4UjTo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 9:08=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 10/15/25 16:51, Joshua Hahn wrote:
> > On Wed, 15 Oct 2025 11:36:09 +0200 Vlastimil Babka <vbabka@suse.cz> wro=
te:
> >
> >> The pcp locking relies on pcp_spin_trylock() which has to be used
> >> together with pcp_trylock_prepare()/pcp_trylock_finish() to work
> >> properly on !SMP !RT configs. This is tedious and error-prone.
> >>
> >> We can remove pcp_spin_lock() and underlying pcpu_spin_lock() because =
we
> >> don't use it. Afterwards pcpu_spin_unlock() is only used together with
> >> pcp_spin_trylock(). Therefore we can add the UP_flags parameter to the=
m
> >> and handle pcp_trylock_prepare()/finish() within them.
> >>
> >> Additionally for the configs where pcp_trylock_prepare() is a no-op (S=
MP
> >> || RT) make it pass &UP_flags to a no-op inline function. This ensures
> >> typechecking and makes the local variable "used" so we can remove the
> >> __maybe_unused attributes.
> >>
> >> In my compile testing, bloat-o-meter reported no change on SMP config,
> >> so the compiler is capable of optimizing away the no-ops same as befor=
e,
> >> and we have simplified the code using pcp_spin_trylock().
> >>
> >> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >
> > Hello Vlastimil, I hope you are doing well!
> >
> > Thank you for this patch. This is a pattern that I found quite cumberso=
me,
> > so this patch really makes the code so much easier to understand and re=
ad.
>
> Hi, that's good to hear!
> >> ---
> >> based on mm-new
> >> ---
> >>  mm/page_alloc.c | 99 +++++++++++++++++++++++-------------------------=
---------
> >>  1 file changed, 40 insertions(+), 59 deletions(-)
> >>
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index 0155a66d7367..2bf707f92d83 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -99,9 +99,12 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
> >>  /*
> >>   * On SMP, spin_trylock is sufficient protection.
> >>   * On PREEMPT_RT, spin_trylock is equivalent on both SMP and UP.
> >> + * Pass flags to a no-op inline function to typecheck and silence the=
 unused
> >> + * variable warning.
> >>   */
> >> -#define pcp_trylock_prepare(flags)  do { } while (0)
> >> -#define pcp_trylock_finish(flag)    do { } while (0)
> >> +static inline void __pcp_trylock_prepare(unsigned long *flags) { }
> >> +#define pcp_trylock_prepare(flags) __pcp_trylock_prepare(&(flags))
> >> +#define pcp_trylock_finish(flags)   do { } while (0)
> >>  #else
> >
> > I have one question here. I was a bit unsure why we do the typechecking=
 and
> > silencing for the unused variable warning for only pcp_trylock_prepare,=
 but
> > not for pcp_trylock_finish. Is it because pcp_trylock_finish will alway=
s
> > be called after pcp_trylock_prepare, so the flag will have been used at
> > that point?
>
> Exactly.
>
> > I was concerned that there would have been some area where only
> > pcp_trylock_finish would have been used, but compiling with W=3D1 seems=
 to show
> > no errors on my end : -) So it looks good to me! Feel free to add:
>
> Yeah we can change that if ever we end up with some code that needs it
> (hopefully not).
>
> > Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Very nice!

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> Thanks!
>
> > Thank you! I hope you have a great day!
> > Joshua
>

