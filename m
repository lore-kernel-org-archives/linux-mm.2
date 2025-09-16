Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4802CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 02:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123B08E0007; Mon, 15 Sep 2025 22:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FC1A8E0001; Mon, 15 Sep 2025 22:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011428E0007; Mon, 15 Sep 2025 22:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E24A98E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:55:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74AE91DF95E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:55:49 +0000 (UTC)
X-FDA: 83893598418.24.E66FBC0
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9E5C918000D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:55:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y6LkAI7O;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757991347; a=rsa-sha256;
	cv=none;
	b=HJ4zCK2uRaUNkZuD8zx8fzZyyyvQtis2fpfY6pcsrr1VXDDc2934BxbugumqugF3eMoP0q
	cjryZxvz4bnbmtXpdthdh3mddEwHPrSbQ1snmT3ocxLAUiOEMKMTrW3MdpQUYJ/fQmK2+o
	H9HLsWngciJBshB/Z0nCRTcuXrV3i94=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=y6LkAI7O;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757991347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxEox390mlmzfZQlt0WupMXn7LJmHwWOckP19HmZZhM=;
	b=SMjwVmoF/x6kLyBU42ekXEYOCr3AmobjnTX4/CVFNVi2PUnr6EcniM7d+V4AzdVww6csWz
	0M5KkLfU/RrAF8YkGJjjB2F47F0qR2Cs1KS0CG7+oH9iYHu4UKocA/Bin61o2T6dKsfuCS
	HEntb65/Q+axGI8RLvsNwpDZi0PM658=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b796ff6d45so123351cf.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757991346; x=1758596146; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DxEox390mlmzfZQlt0WupMXn7LJmHwWOckP19HmZZhM=;
        b=y6LkAI7Otfq+0PiguYomd4ATq5O15HmSJIV7QieCw+/8LAADzKAK/lFAVgzgFXmg7A
         7PFUgC3bGTnx3wDBe8/8I8idwRMZXY27f1llpELA5QGtUZBDqnOKZ4cibv/nwerAvTiU
         wd42Pvy3lbKFX4IM7TC8JLLSTMwdC7BmItL72ThnXt+HeaaR0VQcdqCMKkeWcxx5/aIQ
         jNTFU7urwk4fX3hi/HHc8V5BCaXZ26NJ3xjHCOc1x9JINi55GyDubqs1WSpsCYnrA1AL
         diH69rGyJfA4BP84vdt22CCy4heYZaaq+2UlsW73XYk0Y2DnLRa089EJkTk4bJjbTJMz
         8eOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757991346; x=1758596146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DxEox390mlmzfZQlt0WupMXn7LJmHwWOckP19HmZZhM=;
        b=Zl7W5zPTjPIXxEXlc+aJUBlLKzlsP19UipXf37JsaVNOePzL7nZYC+WI0IxPgq3W/j
         xN2LagAhi/Du5wUF24pRW+WWjzgy19yjSbG5h0Cw8kzMlZPSY65xRMZ1jU9NBAnjcT9Z
         sDZ2xL9pGVNQehyqB7FQlRbHC/P+okfzouVtKJBBRjbrVQyu1ObdsHalO3j7DS3eIUfr
         rfRwVdvBAaA2so16ecUykTxExf05QXCi921ffeZ/0NbXZ5ektrzSEozverXMeiI7OsaM
         QbRcbFcUXh81EfGNVZ83vrrLgIa43kj5Ti7addelOOueHUM3OYGcyOmj9F9zoWaQOZqJ
         sxUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDaJJl+UTWDEDAdcI4dRvjZ5swVg2J9XMLn4bKYTCbM7UqHVQUrWW7xemkOXx5u8izcVuspKA/Lg==@kvack.org
X-Gm-Message-State: AOJu0YyPMe4ok68Mfb7eKhlmqPTxIffHJZ8NoyzzdFnmLz6tbyEZAhvD
	IOI2K6SU/cFypg9cik+tSYPskbNvMTHY0wi07aU/OYQFpXFF2LefbZDyaIDLt1sm51Yka3FSwb1
	03EYa0o+CJ+N+V4C7b3LGF8jcz3TMcrE58OtJrPpZ0JqT2JWXk8Z/kjAFm0s=
X-Gm-Gg: ASbGncv3YysQtlZ7GQh/UEvl+q/MygYHsTJcxquS2XIHHEER02kQPpSzAyHLCDUpv62
	eT/OfquWU6FaIzxEVC1HRHIMt9OimgDek7wF8/7AaLJIw0Fakup5TynqWyev1+U3DGP6e7MtI1B
	L85z1RNNrD6jaOyK+SO8a7/Jm4ylishf8dr0tt0PhBuXke8lTvldNeCDJTeLAEZnYm7QvKWNW4C
	rr+uSJl61tXN8m6Jl0dZeo=
X-Google-Smtp-Source: AGHT+IFDd0Nuxxs/LA4x0JG5lZ5KWPmeQmRNJmQLq94G72TMqfquRYxp0j07viY0Eb0hK7xURqlghERU04vqdw4TREU=
X-Received: by 2002:ac8:7c56:0:b0:4b3:1617:e617 with SMTP id
 d75a77b69052e-4b7b2d81b34mr2040931cf.11.1757990904843; Mon, 15 Sep 2025
 19:48:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250915230224.4115531-1-surenb@google.com> <20250915171112.f71a7606a7f9fd3054662bed@linux-foundation.org>
In-Reply-To: <20250915171112.f71a7606a7f9fd3054662bed@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 15 Sep 2025 19:48:14 -0700
X-Gm-Features: AS18NWDAmjcDHPaqjm_ox-UPq6pVOhgBdnCZ0vDyLGlpeQhhpI16J7KRUmTtxL8
Message-ID: <CAJuCfpFQCgQLSrzfVjV+J4tkYbOx_W9v-kWmoo-rmh5hs9gEXA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E5C918000D
X-Stat-Signature: n8z4k6tc9mbidie5yhkiudg9emqybr5c
X-Rspam-User: 
X-HE-Tag: 1757991347-951823
X-HE-Meta: U2FsdGVkX18EQ72+q1V7rCzOKr+vBKDWKdA+EQIwS4F5IGUA1EeYYVBeQFRzozeasr6Turce7TmshREC6+sr5VzwSfkMCi7MLoPXo0em95WCLRmN1kGnyibvfiRCDBsXSXZpx4GDHEb2/zXLjDB+HXBkkXuTHhZhqxULqDk6uP4wi7Gg0Mqfv7UF8FjbOyemHSLkti6k+VSm97EBjJC8BC6olA5FdmPXGlqKJYvqBumoqnT6MyfhfkwWl+2AzUqkwOtE10KhvVGXpftLrVJaZ7JjmSuVgIVtnTavW1II+uYrP/j5etn6ewjuXvoJ4JJbUMV551PxTLqee1sNJ2NjnfaIGnMJG19ImDRj3PyrFl5w5YWl6mr9ldEklqWvRjUq3DlHPeLgPjzd6T+s0dwzsNVGJYY3tbyVhsptMGlZJa50WVSts1cs+xMn9pYylys2Fipt7qBg4cO73PWz32KGAkn7iS96pP9nS/h8wHPLkSixK+4zD48JGQiThfJ1dwT8ovBxbrXMJAFMhZRSO58g7ZJLdaduKDyoco8DOAEqYmU0TPdTiPCSXOy98s+3VLdDHVRPW7Hkh+FNrP5k06fP/Bi3ZkmuEgusZN3RoOoH3hB12u9taxRzoogAk52fyBHrXtXgBpuIArw5aNu4IZ9PzYUsXJJrZVujBLfw0VaVukia0xfhNRVvUK02ChpGr/Norm/wSzRCl8UdLXrExdBwaUkg1C4aCfeWZ/O98XZuoOR6LtkX39bKWzfNea+dwiKg/zPI/W4oD34uxfi9x2DXgVMvWT+EjvEBCQDMRcAdOmXD1XfXVatg2SPOtCPeKyMhWH4/zvw6YrrlA6xixkAODhpQqZmBxMTgYH38hGKT31TwuJapha/XAg34je2yZKIo5s6Qr9ZVVGLoQ25KCMHARmzra0K4uJ9ftP+2ueMGk7/iSYwBUEUeAZqXu+QXg1Gj5ydkZ86FDjNcQBKS2sZ
 CmInUmzA
 yMAhT8g0sQljU+qXq2f2xubs4aTM8juQFoYMuUiiL+PqaiCMxq7/Ee0bYxJgiUk1ywPwxpInGdDJSFnpjOAyWFZ81eOga6uHRO3MsiLj/LCFCOil+ERhTDOnIJGzCmzElONnpcmm6pnGGSIWDU0HkMutZgys1nzXv21tRmUpR0gtIPpZ5YZujzO4myz6fpuKB3DpL34YjAJdVdFk3gOd9NPBEwDsarUFblR4m4lOCUYvGwZ0jbPYn03ccVKyg9slj1976txiGShq/jfFAycxqaEP3oHQwff5ZuuYue3NK048jRuqPH5wYJB1aGpVyjpgMbvfj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 5:11=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 15 Sep 2025 16:02:24 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > While rare, memory allocation profiling can contain inaccurate counters
> > if slab object extension vector allocation fails. That allocation might
> > succeed later but prior to that, slab allocations that would have used
> > that object extension vector will not be accounted for. To indicate
> > incorrect counters, "accurate:no" marker is appended to the call site
> > line in the /proc/allocinfo output.
> > Bump up /proc/allocinfo version to reflect the change in the file forma=
t
> > and update documentation.
> >
> > Example output with invalid counters:
> > allocinfo - version: 2.0
> >            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_=
data_nodes
> >            0        0 arch/x86/kernel/alternative.c:2090 func:alternati=
ves_smp_module_add
> >            0        0 arch/x86/kernel/alternative.c:127 func:__its_allo=
c accurate:no
> >            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_=
set
> >            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_re=
alloc
> >            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_en=
able_hybrid_capacity_scale
> >            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:=
init_amd_l3_attrs
> >        49152       48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_devi=
ce_create accurate:no
> >        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_ge=
n_pool_create
> >            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_thres=
hold_create_device
> >
> > ...
> >
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -1009,6 +1009,10 @@ number, module (if originates from a loadable mo=
dule) and the function calling
> >  the allocation. The number of bytes allocated and number of calls at e=
ach
> >  location are reported. The first line indicates the version of the fil=
e, the
> >  second line is the header listing fields in the file.
> > +If file version is 2.0 or higher then each line may contain additional
> > +<key>:<value> pairs representing extra information about the call site=
.
> > +For example if the counters are not accurate, the line will be appende=
d with
> > +"accurate:no" pair.
>
> Perhaps we can tell people what accurate:no actually means.  It is a
> rather disturbing thing to see!  How worried should our users be about
> it?

Right. How about adding a section like this:

Supported markers in v2:
accurate:no
              Absolute values of the counters in this line are not
              accurate because of the failure to allocate storage required
              to track some of the allocations made at this location.
              Deltas in these counters are accurate, therefore counters
              can be used to track allocation size and count changes.


If this looks good, could you fold it into the existing patch or
should I respin?

