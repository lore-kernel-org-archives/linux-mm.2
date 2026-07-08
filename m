Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 972A6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 16:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81DC06B008C; Wed,  8 Jul 2026 12:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CEBF6B0092; Wed,  8 Jul 2026 12:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BDCD6B0093; Wed,  8 Jul 2026 12:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 378B26B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:50:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F7FE8C915
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:50:21 +0000 (UTC)
X-FDA: 84966197442.23.BECADE1
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9BAE21C0007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:50:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LdElPW52;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783529419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDnpig3MZnB+M3jCpE7pEOtfxRospLvUmeedSs6shPQ=;
	b=QMEJzo2UcP+pooVC3ruD06xFP6UIQpDTHiBHetqIKra4jOgi6gdxAk+MXyDtUoTpG3ncgs
	xzpBv96rLxW3vLma37q6prZeIqHtnK1ygMdqFjsnl7TV6SvpLFtYc3DzomaeCCV+t13DJ1
	5l4oG3muj9woGmWQ7YhuMsyAa0p7PnM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LdElPW52;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783529419;
	b=P0/MnvE5d2dEuBNlnnV25jk6QUBx7CBGS5MdYCfT77ooWC8io7cWXczGNEt1RznJ08x20o
	rnuORkLmrRPxt5MPW2//8P2Cl0lnT7mOVgWNStRUVryzKKNJgcbpi/afcpcszPRHnJQud/
	cbs/JTsdvUU1sqLTTa7yBsTU5LqgvHw=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15dd4b9132so1680466b.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 09:50:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783529418; cv=none;
        d=google.com; s=arc-20260327;
        b=LuA4h7RlTZXpvSaz1NZ6Jfi6LHB0Cwwzs9+kBNw4AnAxauYaSjdBh6ZSk6TK8zu0Dy
         52knw9V4r1ha93NqZELD3V52z56FhYnRVCmL8hmFCNU6+l+Eiugxo6LfQX8iQeEcCkh6
         R/94s9OICZyhcQgEZ5Q2Qu1QIlyOASiWSsUmj0UDC3tbNuF3ME905ioWYTT8VtOKwDaK
         8SoJTsaGSMlkDulg63A/zO9vQ8Ag4UWucPPpZm/vRh48GruD4wr4vpv+yFwyKj0WnsdF
         T66DA7d27YS8f60ELea/HfxRBlmR9thhLl6r3vLbSPUGjOySQVYsH1Hh6zxEpd3lEHdb
         uilg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DDnpig3MZnB+M3jCpE7pEOtfxRospLvUmeedSs6shPQ=;
        fh=zRbCqxurC/XLZJOfLlBpJzP3eX+Wa0dBTXJrB5mONvY=;
        b=htg0t0T1g50GDdvCRGXNNTYj5H7wmIYahzV+Q7newqmed4Rg9jakemZID14eRk+KFx
         Q7OLNZHohEe4mCvgtl0dWWDZNynRZnQvr8Ax7zJ3BHKFyVDbxkN+4H9L1MREyPTxrQMv
         7HyGpOkN0y4AKgADznEs0I945WpIm2AtSb64/Oxk5+gWTQSM9/bzIwZdDE30gK1qXbQA
         d2Xlwat9T37BHJOAgEQbGFa0VSQ0cLHrrPYvojt08nQTP2VkAK/eN7FYMTOVmE/Seb/R
         TpippFwsQjimpKNowmtEpJ5KYMw8yPBM9fpo70dSiN+6BP9NPY376ejUB0mzuyyEuQLM
         /lqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783529418; x=1784134218; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DDnpig3MZnB+M3jCpE7pEOtfxRospLvUmeedSs6shPQ=;
        b=LdElPW52xdUSYzAaOUaKe5z3+7v9QNUn0A3qQvwtkL8Q74XzSfoUCHfebsnvOwo2xw
         OnMfIvRVvH75anI6DhNf+jLVdcfCDlYFPlGn0cczVhZmTsNk32JFKP1ufB4F0i0VeGDZ
         IoeHmm4S7voufYFibUL5KJmM5INdI3EvvT1UiWLQmAB6sWHgoegjjEJQcf2ISLyGwQDr
         dRbhlVnH3U8HpmwaprQxEiSnGMiqpuPLwhYbbv8EaPyiYCuhF4BWdCVORf9dEClztZAa
         cvERBjn5IIxdIc41FaoyCP4uh4Y9ztpIQjgvx4wRW+IQqspGoEoMR+YLsKycgpcX4Mx7
         PxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783529418; x=1784134218;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DDnpig3MZnB+M3jCpE7pEOtfxRospLvUmeedSs6shPQ=;
        b=puwUKmZHqqsDzzeL3vZiY3+NR5Ystcjihx37qXgZmXpxcl9X6RDhe2W8alWhI9EGnG
         +bZwYvarDguAbNEUB6ykeOfelIMx6vfCB4j6navjTK/4y07keFdIAm+vC+BNKiRmlXSP
         lqrCXI02DN/TOmAb6EA/U6FKPASuSuIbpwAA7FsSwbluC7BopmVPNDzhVEunGCFjJZBc
         EUnHe37m0xvEQ3hq2Z3+tBlG0jW1lW+rGuir0L0CuFDICTej0ZIjfiBNJFASernPl036
         +PzaRP0WMwZSDeM6b3o+RCg5I9AKwMarqb+9DGk19T41uSuYm2NPtM2jzvKiUeIbtnOH
         JPCw==
X-Forwarded-Encrypted: i=1; AHgh+Rr2ZtFOZFeTtbTMwtPaFShGEgMxkjiuF8QVg2mwDoUbhYIl9TEV6tmH+xvKlJ9Xs1D8o3votK3cIQ==@kvack.org
X-Gm-Message-State: AOJu0YyAjIyXLWcCk9JT9XBA0EVJxAhD7gnICrmUoU1lJchv/Y/0W0BB
	O1nhDYyslYOi50XmDFvzmGMqsbKtXh5cT0UgZqsEKCaixTl6GuUHrMWq5ivbV5isjDKye7A2RQc
	0GpsxKJequbq+5M8AOH8Frn1kFvQTswXxJhxmufHH
X-Gm-Gg: AfdE7clw2/pdSgTqFDWZ2nnaQo7/CJwabcLaAmt/hOUCpgvDzCND0VU74xSznNWx/YW
	smNfuTOp+b4xYXcfnKf+ZRYKmNZmcmVZtt7MeqyE42/35+TSfCesdaqiiURu5IQ78ODWhuoNnwj
	O7KYLg0XWwn/VoyFmgkpOWfl12VoZGEaNKhwFxEpYBGlbfneK3QNuiSmu++vHlw+G8gpw56VKXe
	WgyrLnpXTRM8FBw68YAQkc2yVG1HvtZt2U+LBEKruHGWkjVFUO+X0KtAOtH1ytjT5DD+5GuZLpB
	PodbtNFO3keifpmNIn5DOd1hx39zqRY/GVGIKEtk2KjO3ZaaCk/Bei1lu3w=
X-Received: by 2002:a17:906:f58a:b0:bee:6806:d69a with SMTP id
 a640c23a62f3a-c15ce0fa3a9mr165048166b.38.1783529417441; Wed, 08 Jul 2026
 09:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com> <FC9E78F0-8FF7-44AF-A848-8401B4702488@linux.dev>
In-Reply-To: <FC9E78F0-8FF7-44AF-A848-8401B4702488@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Wed, 8 Jul 2026 09:49:40 -0700
X-Gm-Features: AVVi8Cfv5yaxCo1wy94skRAUBfR5X0m2laz06imtAANj8KZpWB7cPkC9ZIIhScg
Message-ID: <CADrL8HVkrojXbBuEX-W=UHBmyyFzqxdGBvtAoPP53SyYa10uag@mail.gmail.com>
Subject: Re: [PATCH 00/18] Another attempt at HVO support on arm64
To: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9BAE21C0007
X-Stat-Signature: 95ysq546idsp8pcbdtosikhy4mm4otnc
X-HE-Tag: 1783529419-70473
X-HE-Meta: U2FsdGVkX1/FEOoTrpbJH4xL0qiu933wNyAUHn370zFaSWVHwwYPYtdyPQ7x8smVAvkUievXEGcn80/kVnPBAUeUgkPbd7+MJK3WlENaKvE7kH9j+86akN5Oygg5FxbbhGOusB2Z8aWK2PnjW+fGHcwamU23B0kUmm0V78ovU6cKLdaija6fyY+cLlyUpLii0z2xEGRvvrv0WEREAB7Is4Z4bZnfg5Efpr+s1Pvt/TTVSTbp2ivu+/9XbXV7IbCJh8FDqMhsnSudLBrTxlCXw4ty0YjCHZhZ5uR6wwsnf2M8dq1s3PEc2AnjAiieg+TiBzmQ0mNwC5jQYzZ3SQSBAK/GK3Dwfopxyfm8ZN3kATXyl9aYnwMOvcxxKE9LtNFigoHYgBHYwzxIm6mQMu3OqaV/YiiU9L45i/7nW430Ez3gu4B0IaumPnUAGa94s4GA6ydgp8wBJWzSCWcOop+/AQd4pZd6f9Oah/lsQh+zLB+IVDv4CTe+3G2/J0zcSmrbqzKo3k2YvsRQcdQ3MWMNFmoKEYsmpY5qz5VfORPd9Gd6hSYDU1C1DFhr0kxeHyqd13ZUunEJM/znFufmgaigWxelVFRqUdjbFT/3LgnPzwwBTIp0kj5n9yRNRBArIdUEiR4aadFw6qHbNSC2FsKByFMcdSA2uISlDZ6wVkVUrs/wWHxIcSZrjaoHkHxfqIBdoGwXe6/5o376qtjEckB4+pIp5qc0Dq3lIfQ+gobSlHNagnd5e8TZhb28nV+fuWUrcMHFqGmQWkiDDZqk4ORBCrIsoNp0Ry7m12SCwiRkvcBJxdG9zhz161wIqJjdaPMoBwNKcCB2wXQdef2UkgJB3PAEtU7LreS0vihUWJ1IWQi10LdUUa3ZO2bytOF7eIabyrl8PaAHofhI3AczCjh8JdHTR34kabfWuN1JfMzDHOz3DjYlLpnLHuCzsQEvvKuU/ZNT6KYg/aE9se+hMzN
 FK3KGzMJ
 VTSTEKSABtQCStCAmhCXXjFN8mcTsrwHgEOK87BeFpeTOmW6o/I9lzZ21tLdcwm9ul7Bu1U8GFK0x78ASimgTWKvFEl5dLtsP2Ggscm1dJUJlLfNgS/Itx7LSft+puPNA61LfZbcOa1ee3G1SLHugvAFrG7eYFf+YIwkenqEXVAUXmzWiezU9Vjd4U19ohgrTavnk1Tl3p+Tp8NQYhgG3Hd6exYEaJEUpvThDqzCQWmRvggnsBQvTbi9xRvQYWer+5O+oNPAio5a3D2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 8, 2026 at 1:41=E2=80=AFAM Muchun Song <muchun.song@linux.dev> =
wrote:
> > On Jul 8, 2026, at 11:11, James Houghton <jthoughton@google.com> wrote:
> >
> > Hi everyone,
> >
> > This patch series uses a trick with the Access Flag on CPUs that suppor=
t
> > hardware update of the AF to update vmemmap page table entries without
> > introducing a time window where CPUs accessing the vmemmap might fault.
> >
> > By avoiding faults, the HugeTLB vmemmap optimization (HVO) can be
> > implemented correctly on arm64 in a much more straightforward way than
> > previously attempted, most recently here[1] (please see [1] for a
> > breakdown of the other approaches attempted before).
>
> Hi,
>
> Thanks for your ongoing efforts on supporting HVO on arm64. This is truly
> one of the most useful features that arm64 has been missing for a while.

Hi Muchun,

Thanks for taking a look so quickly. :)

> >
> > For large-memory systems that allocate most of their available memory t=
o
> > HugeTLB, HVO saves a huge amount of memory (1.5% of system memory).
> >
> > This series has four parts:
> >  1. Some preparatory changes (patches 1-3)
> >  1. Bare minimum HVO support (patches 4-10)
>
> It looks like there is a typo in the number here.

Oh yes, so there is. I'll fix it in the next version of the cover letter.

> >  2. Drop BBML2_NOABORT requirement for HVO (patches 11-13)
> >  3. Drop the user-configurable Kconfig for HVO (patches 14-18)
> >
> > Parts 3 and 4 are technically optional. More details below.
> >
> > The main functional caveat with this series is that bootmem HugeTLB
> > pages are not "pre-HVOed". They will be HVOed, but because at pre-HVO
> > time SMP CPUs have not been enabled, we cannot query for full system
> > support.
>
> Do you mean that the support for AF might vary across different CPUs?
> I'm not that familiar with arm64, so it seems a bit strange to me that
> such basic hardware features can differ so much from one CPU to another.

Yes, hardware updates of the Access Flag is a per-CPU feature. It is
available for a CPU to use if TCR_EL1.HA is set. TCR_EL1 is a system
register; each CPU has its own. (Linux will always enable HW AF for a
CPU when it is onlined[1] if support is advertised, so we simply need
to check if support is advertised to know that it is in fact enabled.)

These days it is not uncommon for a system to have two (or more?)
different core implementations, like with "fast" cores and "efficient"
cores.

[1] See the CONFIG_ARM64_HW_AFDBM bits in arch/arm64/mm/proc.S

> > This series is based on 7.2-rc2 (0e35b9b6ec0f).
> >
> > This series almost 100% cleanly applies to mm-new, which has some of
> > Muchun's HVO patches, with one trivial conflict. I imagine this series
> > will conflict pretty heavily with some of Muchun's other patches[2].
>
> You know, as we iterate on HVO, the codebase is becoming increasingly
> complex and difficult to maintain. Aside from the work in [2] that you
> mentioned, I actually have some local patches aimed at refactoring
> hugetlb_vmemmap.c as well to reduce this maintenance complexity. I really
> want to avoid piling more code on top of it right now, as that would
> only make things worse.
>
> Therefore, my personal suggestion is that if this approach is
> theoretically validated on arm64, it it better to wait until the HVO
> refactoring is complete, and then review your work based on the clean
> codebase. For now, what we need to focus on is evaluating the feasibility
> and soundness of the approach itself. What do you think?

I agree. The first order of business should be for the Arm folks to
tell me if they think this approach is unsound (though I've been
chatting with Will about this for quite some time :)).

I'm happy to rebase on top of your refactoring work when it is ready.

> >
> > -- The AF trick --
> >
> > The trick is that translations with the AF unset cannot be cached in th=
e
> > TLB (see Rule R_DWZCQ in the Arm ARM), so they can be atomically update=
d
> > without needing a full break-before-make sequence.
> >
> > So the PTE update sequence becomes:
> >  1. Atomically clear the AF on the existing PTE.
> >  2. Invalidate the TLB.
> >  3. cmpxchg the AF=3D0 PTE with the new PTE. If this fails, goto 1.
> >
> > If there is a CPU on the system that does not support hardware access
> > flag updates, clearing the AF is problematic, as those CPUs might fault
> > on the vmemmap usage. Therefore, HVO compatbility checks all CPUs for H=
W
> > AF updates.
>
> Sorry, I am not familiar with arm64, so I will leave it to the arm64
> maintainers (or experts) to verify the feasibility here. Once the viabili=
ty
> of the approach is confirmed, I will look into the HVO-related implementa=
tion
> details and consider how to support this feature on top of the refactored
> code in the future.

Sounds good, thanks Muchun.

I'm hoping you can look at patches 1-3 anyway. I think they're the
right thing to do, even without the arm64 changes.

> > -- Application to HVO --
> >
> > HVO relies on the following page table transitions:
> >  - When enabling HVO for a page, PMD block entries in the vmemmap are
> >    shattered into PMD table entries. The first PTE remains mapped
> >    normally (RW mapping to a real page of struct pages), but the
> >    remaining PTEs in the vmemmap are mapped read-only to a shared
> >    page of struct pages (that is, there is an OA change and a
> >    permissions change).
>
> Just to clarify, does OA mean Output Address? Please spell it out for
> readers who are less familiar with this context.

That's right, sorry about that. I'll spell it out more clearly in
future versions of the series.

Thanks, Muchun!

