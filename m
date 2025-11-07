Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2400ECCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 11:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CD2B8E0008; Fri,  7 Nov 2025 06:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656188E0002; Fri,  7 Nov 2025 06:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7CE8E0008; Fri,  7 Nov 2025 06:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 384AB8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 06:16:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5E738883D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:16:17 +0000 (UTC)
X-FDA: 84083557194.28.644803D
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id F1F83C000C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:16:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=flczYDEI;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762514176; a=rsa-sha256;
	cv=none;
	b=UOCh7bKz91h9ODPiN4n9LrZPbLnTAU447wmrSIqgvll/ziu1qzovtnAa5107AhJODneEtO
	yjJ5TnN6HcgJNtusbzdwlwOBemu+t1z9bE8YwDUhCy09S2BvjtHKt9pRC39DuXNaaiHcW8
	O6gqev1TClwmQ9HjwMlmm3sSpYmjZX8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=flczYDEI;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762514176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSUGkowFk1WKX5H+ZdfFcGFCiZM/bHFtpcGhU9ZSod0=;
	b=szlip5nuIft591OhJ/WQlorvFb7CRZHRK1z3vRraFkimH+SmWLJ5y9h1qkJhlluppUMTBG
	AsWIQyyBdSK7kXFwBmlHIAf1HGfQ1WOp1IeM0p7aL6tTWKytWa/0+Fc6Ru4VAniBJeqU+N
	vzjPAEDKPRbHwmpBfk6t1BjKm9KlJBI=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6407e617ad4so547025a12.0
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 03:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762514174; x=1763118974; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vSUGkowFk1WKX5H+ZdfFcGFCiZM/bHFtpcGhU9ZSod0=;
        b=flczYDEIjDZUvFqMNtngtzfn1UyFO3FKXMa+i4y8j4DiO05nbdkDybEMlbjB7X8YlY
         J/+lDV+3xVtqdfZaaWHPfTQW6IkwrExsdCww8Uk/G+25uaZzWEbCwklA+bhNVPD7sojJ
         0FNIYP6kZMQiDBK0IVuGe5VZly/erfMpz4wZoh8/IMcWTKE/rF47fPPVK7QuIxDhQtku
         EGYHh0MMcymigAET+LlEtUWKLHjkOGIltSDrlqPcAm23R9pumfX05JOWHtEXDGJ2PLb6
         56Oxk7qNNnR4PrU2uoc8jRPHn9QXOvqXs4QnpFwqsnd1D16OxjirwOT0RCinUGAaT/Zv
         s0Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762514174; x=1763118974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vSUGkowFk1WKX5H+ZdfFcGFCiZM/bHFtpcGhU9ZSod0=;
        b=lA2i1GUzKIbJQq/VvWCZo/HnqFhz486zilb0Oes/Jhsk2NCXVrnkjTtrH5Q2mjTz82
         ejIB7eNQdfbFqIKxzmcztqNiPsfQXeobMMURjeATN4MAPZEo2TuEBubnSjw3Z9FlXTGk
         BVMlf5+O32HZ38K0mBnZmWPEylMYkyikD80u7iX1wmnySh4ikduNHEbGMNuhUNcrL+fj
         GTG/bf76G5TpxOEqBZffh0s9Hw2Mk10D/enSQpZzeXmIhHeii5ShqY4yof/o0Sw+PvDj
         KiOIjYNmrRT/WW3+VqmIFYiGKpOVSTY4gm+4D3PLPwcEc82/My7/pmP2olnXzt7DdzZ5
         +y7A==
X-Forwarded-Encrypted: i=1; AJvYcCVnpFcl/GinNqPlbU39+LUZGysD9ReQ7A44BPb+auhGrKQBFMfgozTHknbuf3jxwjJjZxiaX0V5Fg==@kvack.org
X-Gm-Message-State: AOJu0YyhkB2EaYnQbEl3oZ1uz1UYDieGE5cra7v/p11UCinaSQAgJlkb
	eg4DxdYoUziycrsN8f/Cl3/oiYB1TTP2Zo48LeFZtuEC4STzj6TyYfxxW2zOx3j4kNy33e/mlpq
	l2PvXCWDRtfRPRdRVqyK79k97090bgY/P0gHXqd/COQ==
X-Gm-Gg: ASbGncsDwngZ4ie7DAW2+KfZgGanzv0OnYVnWRaYDLy22W7MyvnaHJLaWLaz7YuQdA0
	HP5nVMP6a4b2UcN/JhfwMem3OJfPNlLpHPksG6HSYbO6gMEzkr0W/S+8ogZQU7Gwn+Bvu1mn6Bb
	OPjS4saKH7XCuCA/pY2XPl4ag7M2Yh8iTKttKaNkIQchFn5fXCI6AjK4yOzN0FL1M5HWmoJ36GI
	MTsH7oBlkl+bHZBqY5vhP0s3CVTj6M3BkwGLzxOTJZ6u0Ab/ASLYxO/jA==
X-Google-Smtp-Source: AGHT+IFs9fzvpDPTsAFkSsf2g/axFVw0DqyasrrSTQmpvxxJwCZ/vRFmpg1oJNrPGFoNM0eCGfjdIow3KjiQqmHQR+M=
X-Received: by 2002:a05:6402:84d:b0:63c:3f02:60e7 with SMTP id
 4fb4d7f45d1cf-641470a5b83mr1085673a12.17.1762514173924; Fri, 07 Nov 2025
 03:16:13 -0800 (PST)
MIME-Version: 1.0
References: <20251106220635.2608494-1-pasha.tatashin@soleen.com> <mafs0cy5ub0nc.fsf@kernel.org>
In-Reply-To: <mafs0cy5ub0nc.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 7 Nov 2025 06:15:37 -0500
X-Gm-Features: AWmQ_bl_5IdSL2Kur2Xuap5Ta8FwDqfYQlgqfAVhcx3fkqLwvwkzYlLkk7DO3Lw
Message-ID: <CA+CK2bB+EpZg7MTKZhFtaGoYfLN5JNeaH9HDv_Avq9Qm+3e2ig@mail.gmail.com>
Subject: Re: [PATCH] lib/test_kho: Check if KHO is enabled
To: Pratyush Yadav <pratyush@kernel.org>
Cc: akpm@linux-foundation.org, rppt@kernel.org, graf@amazon.com, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F1F83C000C
X-Stat-Signature: 5wiuibpb8zwaj3pjfmeipx7kudqfpe67
X-Rspam-User: 
X-HE-Tag: 1762514175-879228
X-HE-Meta: U2FsdGVkX1/KZHiA0NbiHrZAUvZ7GHQ9ZN1Vm0EJnoBnulLH7NNjF+HfzRyYWXApGcfmmuOV3i3gDvG9i4RzGac5QOn7zvb1pvKicKq2erCE28iYopPQUAxVyETcPRaKavonmuHFOh/k6l0Iv8HtYsHjE9MdRpGcS9lYXodI7pvFc7L+UeUpBG4LIcJUPTsTwPgR5keHNlZRnu0aoTQYXQZxRWLsJBfv4vOstdFgbDl7AOzjQ0VrLPAf4NVPCQ+37L5xnd6T9dlO0NrgQUyUKVkvg/IctguKEXaWEeCI1+9L9INJn4wFbZacQp7C7kX1/hsXk98IzkczWYCGM01XBUhpZ7u7o2Nie22pWCVyrTfhzqn9ZPs2QwZLlTFgbnNkp6Zd3cLwMXtFpib7422f/ixCaWX6F4uTIN4gmVTtu0its8GnFUHvp/dph6C3XTlJXp4tD6y7DNG9tj7E0RhnjT2LA7w61UIVfntbFDWoRxffl1oFy76LoxzesfWQLr3mLmFlXh5Mj0bZCKvclCIZhUxoO9uIag6WL4lwom+ACcu+yt5UKpD2B0WDBrnR9qGCcnJcsm+qN4XnmMOF/2IBNChRAxaLc1Tq5w2JMB8oduIlBWa9eSJ1xYWuJNGU3vHzDVlinQJKI38g8qHu2iJAb8KldbaEi9wNTjbKMXc0rP6YHJETnguqqSLZXLPtkSLwX5jowuZ8ZAvh+PBNChfVLQDq9v/hWH6mfiZJ2hY4eBLpgTP3uiwhreMYXh9XqSBmCA5bSpv/Ri9viQnvTKwoQXMEefx8LzVNw/1cEsNgIErGq5p83XzSeuVZyxquFknXT6lnepB2p5RP8IyNQ6dSuJB9QeiMI0BR1I1T1eSnK7ufozAUSNN1AnkdEbyr3JGa3oHnRdA5Z776EUL9UgOW50RDOaPMn3BOX2qjgDMQBZol6R0Kkjw6LLJ4X9ohYwe63TBWNzB9ai3S9qwECTq
 1bf+iVUr
 0ZHuS37lNiZVO90r0GG89SpSoj3tQGppL64FPN8ctsKzGNyeeHNhTkhBtYu78KeOxqsjbP5AYTlyYHvNx2U0Np0tEFQnGyP5MKYePJ8nTMJsQteDF+X4IBHDv0Ot76M7Hn8bwNeEnniTpUSNCMsG6tvF4iNyG6fpaUQmVXlzhtdHn7S69GMOnKqTxLit60U+eev30qQeJImUpwrR+Lw/NOXHO/nn/9VM+Qjyqils/Gj7gGqDE+3ltfNHS9R3fiTS1mpsWA1mVZd3DHSylEdtN9D2h25KT+6Qe/xzkLPbqMDSroCl0QRMCyiW3gV0PlaB/zue8gG/pOX5aM05F2igXXmCJIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 7, 2025 at 5:24=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
>
> On Thu, Nov 06 2025, Pasha Tatashin wrote:
>
> > We must check whether KHO is enabled prior to issuing KHO commands,
> > otherwise KHO internal data structures are not initialized.
>
> Should we have this check in the KHO APIs instead? This check is easy
> enough to miss.

I considered adding a kho_is_enabled() check to every KHO API, but it
seems unnecessary.

In-kernel users of KHO, like reserve_mem and the upcoming LUO, are
already expected to check if KHO is enabled before doing extra
preservation work. I anticipate any future in-kernel users will follow
the same pattern.

We could add a WARN_ON(!kho_is_enabled()) to the internal API calls,
but I don't think it's needed. We already catch this condition with
other WARN_ONs, as shown by this report.

>
> >
> > Fixes: b753522bed0b ("kho: add test for kexec handover")
> >
>
> Nit: these blank lines would probably mess up trailer parsing for
> tooling.

Hm, if so,  the blank line should be removed.

Thank you,
Pasha

>
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202511061629.e242724-lkp@intel.c=
om
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  lib/test_kho.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/lib/test_kho.c b/lib/test_kho.c
> > index 025ea251a186..85b60d87a50a 100644
> > --- a/lib/test_kho.c
> > +++ b/lib/test_kho.c
> > @@ -315,6 +315,9 @@ static int __init kho_test_init(void)
> >       phys_addr_t fdt_phys;
> >       int err;
> >
> > +     if (!kho_is_enabled())
> > +             return 0;
> > +
> >       err =3D kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys);
> >       if (!err)
> >               return kho_test_restore(fdt_phys);
>
> --
> Regards,
> Pratyush Yadav

