Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA245C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 00:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A3F6B0096; Mon, 24 Aug 2026 20:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9937E6B0099; Mon, 24 Aug 2026 20:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883776B009B; Mon, 24 Aug 2026 20:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59A746B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:18:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EAA3C402A3
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:18:48 +0000 (UTC)
X-FDA: 85137881136.24.3403CE8
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0BA5F180005
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:18:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UeqEA61X;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787617127;
	b=3oOOPk7muUclqqp8A2wjjlSTFRkiniyBZDWfkLEJ85JKGk1mgrdmeYDK43JY5So8i5zxBx
	aahSMh+VfXGvyXBgBBssLWs0zZckYUNxgjV4fxgfKmM6jnPKJU/g9uR3wdyBESq8vUc0AL
	BUWOGu0A6eitlXRdOnvfL807jrXHZPY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UeqEA61X;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787617127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTp1QihCYEXpe6qsqboacrSH7t7RIuheiExabYlABLw=;
	b=jb6JgmlteHj91ygFR2uywJhXgwlrxuHcx6J3W5cGD6Qbk2fL5/3G2JeJqxRRv2h8CQWvEB
	54P6B/VUj/Fybp/PFZfzPdCodzOy62gIXWNy/sKe+5AjAWcnyYdwaU2AoQgn2ENk/Xc7Og
	oA22X9JDEECZVIny8JxeSeBqM1EeGb0=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c1c26d7e951so627059566b.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:18:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787617126; cv=none;
        d=google.com; s=arc-20260327;
        b=ltzl8gfOhkLNik5quoGjrwrGeQjKi3p/V/3TdogjFzZ41k33CgOBrzKx0UZeK0DHEo
         +kZe0wMXZlNrwq8zVP2av6sdwwqCGCYKIGsB8h+ECM/3czIyVUpdHtnMwLPGuOYzAtOj
         69/EhuBqHSQHeLaQ34Y5cH4xrUpXcMtXhluWh1owMhCHhnGGyhdiMHXCjLgYjjPGpWhJ
         ygO9qlmR9a9CrRR5u2gX6iICEMZpXKykgmPtLE9QQUlGYWwHuGKivmTGXRtoRwkEjYq8
         v0fcWdxD2judjPZVIrBWfl329/5TahEKciE9U+mF/lfWE3V5J8DyA8ZJhojIB1KlPODK
         9GwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lTp1QihCYEXpe6qsqboacrSH7t7RIuheiExabYlABLw=;
        fh=iODILrCJVeij5kI/9P15bXMt5kIoOLmjJlQ34x9SK9c=;
        b=Kbt7veZZm/ka78x6O5M6FfKus7RP1FfXPoavf3h3Na6S4WwUC1l3I7tqBOpw5FZ1Gw
         ddlcWzUBeiI8OV7TmtUbOdj2okFbfgW89d2cgKAihUHpxgvkGxlpvni8723xVPffNx0F
         UZszJ2OKIt6IcNO13otH5JDjLi/CkaHoRLGqkeTvxDWHj3vQJdgdGamG+AgwEFbJCZiO
         t9zAljWC/qJe7zG5+kSIi+oYInh4Swe57tzPDv2clIULQxhIWPvIasRWNirzJhcbU+eo
         hGRlfx86o6sceycwZNbpQL5wJuDPyRs7UG7jWrmCZ516poAdMcCmIueJJKWetuu7Sy/8
         0ZLw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787617126; x=1788221926; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lTp1QihCYEXpe6qsqboacrSH7t7RIuheiExabYlABLw=;
        b=UeqEA61XsKzqFPZUwLduePNORqS3kiPCZestAVMwHPeiOguqp2gruRMK1j5sYSQHsb
         2mp8CU5W9dGhjYQ6kDwhwNAkP6grIx6mqYuIZMZe9E52ObPC4j2nx99omKAgp7PdarYb
         /PLbyFgLExucst39XRCgU/YCmiLcxNXYyOgmi3fJPESgkBlry8tulRyo2HTFeWltxM7f
         zp+Mc8xT3vm7WA2UICJpsB932pSmNtRbkwfYOz5QRxzgWfIppqF20uDEser9gtOuRn3z
         /4pEzSoSludAKquHWlqIDWgymcja50so8oh0IrjzxPqK1h7EYFhibdOku72Wcn6gWBEU
         sdBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787617126; x=1788221926;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lTp1QihCYEXpe6qsqboacrSH7t7RIuheiExabYlABLw=;
        b=Zsedi7NadlSFlOukL5f73GeTbFCtta2mf6Tfpm7bJZrwEkFvL8+NZl812pQhKOdT5o
         a62Qdk2hl0ohFhPlIFBnqM75fE3PLUg12lAckWOCUeCcmIroLOl2awPQvIQAyB9MobDg
         OnYFKBeCaseevc4rcNDzAKXyNXzYuP3p+hUjD8ii3iNzelYZlvKdeyaG4cvbFVfel+yl
         kL9n1FWhHIsNo0oFL5xpBeo8lAdobHrV2ckOI7reJ05stMoecwngM8+R5056QekUZvcK
         Bh/+xrBakoPrxm5+NuAZ9tmhqyCtipvthhbAw8YIlnyb16MkWdPpSR6E/9h+WBiY7jp2
         uAFQ==
X-Forwarded-Encrypted: i=1; AHgh+RrWdRi37+vpLlaMF7P30l13iCEHu6VJoVoNx+JTW65NyqywugNuXDMLs1/VjUFrhZrz0632D3NLyg==@kvack.org
X-Gm-Message-State: AFuF++lAMrZyLReV76tTYPOHUoJF7hmjJtwayJgyXSl9EzaVTX1nCf6T
	ur9Vha3meH1lLEtOpiTonhx5RChDDIDmx3oUlqi5jIkGpbzbFb76yTGc5p+ATvIExvTjyfhihtQ
	8TQ1N9CDc7N6Qs2a0xf1YhWpC4fdoFEBF/Atc3WMu
X-Gm-Gg: AR+sD13KWxumIuea/A3XzMc3hT60tdw8Fla/sKdAkG27xtvo5O1Ph10nvD1SE346/mP
	bbbRy37fzDPsDKOz6w2Wz5I4wvKrNKGYycUMefEzYpY0vuEN5X4QGH0Q6X4/LIRVuoKufWbLto7
	0ohV0M+ymoYLpakCWTxtCn2C4D7RblxpfLXooLQOC+0iT82Z90Cwb6ZvFYmvISjWIa7GQNYubkf
	bBPn+zikhFYiVvRnP6fk93Uy4PBWWbQINV73WsFke5g+IvZsVVco5WvVYg7ybsEpvTPeF0YoLcy
	QiJ87tQ1FWMb9KFuN0r3uFtzWktg+LKu3z5WLRI0j8DEEqlbIJSoR9o1Hpik/gGpBTdWayDcdWk
	5HfKxiVua107BuXppecQwuZxwRCe7GCM4nQPISM7u419yY0pwoDbOO51GnitDkjbmBlsrJ+ZOV4
	9Aq4mFatl+2ufc
X-Received: by 2002:a17:907:8b8a:b0:c05:b9db:68cc with SMTP id
 a640c23a62f3a-c2469f7b668mr3312806466b.0.1787617125394; Mon, 24 Aug 2026
 17:18:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
 <20260708031129.3503195-11-jthoughton@google.com> <aoRpJxCMTQ-RvTKX@arm.com>
In-Reply-To: <aoRpJxCMTQ-RvTKX@arm.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 24 Aug 2026 17:18:08 -0700
X-Gm-Features: AcwNN1UFhVuLrUR3HXGvEKpoyqSN4DfWxj3pmibwZcQrKAo3zbJpABjhy7myW-c
Message-ID: <CADrL8HV7_9AyNS7gPmSMD+qrgTFvMNu2-RiDLf8mroZf2rFC9w@mail.gmail.com>
Subject: Re: [PATCH 10/18] arm64: Support hugetlb vmemmap optimization
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0BA5F180005
X-Rspam-User: 
X-Stat-Signature: 3skomyfwh19exbrhshpirdqcfdtddnjb
X-Rspamd-Server: rspam06
X-HE-Tag: 1787617126-504025
X-HE-Meta: U2FsdGVkX1/LAEV2/BJz4sD6vpTqpuooLIZR+En29Yf9KmrQal39gN+BBp+lKodL8XqOcoq07s6xnt6q87BiQDkDFg9t09EqG9IuNPORTadtF4ZtMFcmex5RRMzrs0DGo8uFSFkh8c7kobKrP1QqR0iHETisvMOcD6+8pLPBSs6BSV+hTylxalfHl6ZRE6DqPbBmRMQ1iAczPGCd9ecyeyJnLbPaZ/+h3rmoBz9jWaAjCL1SJX9UCgiaRJ+u3yvfOUa+NxvBuhMAYw/PdT+supcUnWKJYMW9IMtGObR4gTBDr5UJOInUUgx14vwZRgN94k7DLo7ycVmtEXFaHTODm5w8xoukDmQ5TOsKR6vIS766A1bv98aIEdkWvHwD2qDViT6g1WZCuRxnWl8ufXzod6WSDzGEnemsSaSuTLfJ8NDVBMPhNyUiuquNN5CaZVeYAl0HTW1XKHNmPgePUN/BUoRmsYdOgD1NYCYRvZZ9x5ND2kiSDWJbw8VfobJk2zH8qhFYrgNpGG4He3SMO74R6jsPmGZnU0nTnpRpw0JMdV6IsxerT9Ewmv07YYVDoiznVAAL1Jl3EaNhEUssgjMmPRNdJvOdjRZJEMNDktCwFA9VtuVpOnPyHX6cyYFIXtDCBrlYFFJDGQ2fSqoRwTgMEboIDiyqoqTyr3OeJTIXlwOByk5FdMLpdMhgtCGRZuJx/3VoJPoKgHAkVVy9ly0LEPiZmS7gMbncFV6KZUQgmtHE7YTS6GgKGhU7Jwbi5P2UjIhZP1+GI2VLwpo0/N9WwFbJdMVG2hoq0hv5xdc/aazuXJFAgA/jADwiq7Q9g8LCsAprkqmPD1jhyP6v6Iz52rL4c74czoDki6Ah1jRlVltpza6TYdTu2CBQWEtoN/z/+VDjjUvQcyac8+tW8rn8jLwmZEwScYCVHk7ks+8zY5qvQypJHCRNbGQYLOvKdwZf8MKGb4A9UcPfSHU144Q
 bFWSdlyy
 ctn0IsVao59Gs+zO9LmkCdE3raVS6tt5WuOH01vvljCyn9+sr1bq4y/JQRKoako9zZrfmj7/6oE0DByl01EkTTMdhxZIFZ2+Wa4POKzH3N2Y1MxcdK/2myuYuU4jeQE9x6+G1i1i6eWFpTsgdu1xkjHUWMLEGDApHLPiwPOjrxMaaBOs/x3zWmYfUi2B9F7ngbaDL5t2t3JbAOqpcH6quOIhfJbV5aFtKMi9PH2+xkKWE7ySYWlA1Q4TY1oNs9aRFgtQXK640VXDvSZGnWEEdDZsmrV35PMyj4/gvJXBiMqitSMQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 7:16=E2=80=AFAM Catalin Marinas <catalin.marinas@ar=
m.com> wrote:
>
> On Wed, Jul 08, 2026 at 03:11:20AM +0000, James Houghton wrote:
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index b3afe0688919..cf4bd6bd7f11 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -259,6 +259,7 @@ config ARM64
> >       select USER_STACKTRACE_SUPPORT
> >       select VDSO_GETRANDOM
> >       select VMAP_STACK
> > +     select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP if ARM64_WANT_OPTIMIZE_=
HUGETLB_VMEMMAP
>
> Nit: we try to keep this list alphabetically ordered.
>
> >       help
> >         ARM 64-bit (AArch64) Linux support.
> >
> > @@ -1607,6 +1608,17 @@ config ARCH_SPARSEMEM_ENABLE
> >       def_bool y
> >       select SPARSEMEM_VMEMMAP_ENABLE
> >
> > +config ARM64_WANT_OPTIMIZE_HUGETLB_VMEMMAP
> > +     bool "Enable support for HugeTLB Vmemmap Optimization (HVO)"
> > +     default n
>
> Nit: 'n' is the default already.
>
> > +     depends on HUGETLB_PAGE && SPARSEMEM_VMEMMAP && ARM64_HW_AFDBM
> > +     help
> > +       Enable support for HVO. When enabled, late-onlining of CPUs tha=
t do
>
> I'd drop 'of', not sure how it reads better. Maybe just 'late CPUs ...
> will not be onlined'.

Thanks for the feedback; I've incorporated it. But I think this patch
is going away in v2 (with patches 14-18).

> > +       not support features required by HVO will not be onlined if all=
 boot
> > +       CPUs do have such support.
> > +
> > +       If unsure, say N
> > +
> >  config HW_PERF_EVENTS
> >       def_bool y
> >       depends on ARM_PMU
>
> --
> Catalin

