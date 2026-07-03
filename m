Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCF88C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 18:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7233B6B00B5; Fri,  3 Jul 2026 14:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC2B6B00B6; Fri,  3 Jul 2026 14:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573A16B00B7; Fri,  3 Jul 2026 14:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE0A96B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:32:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51710A0262
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 18:32:54 +0000 (UTC)
X-FDA: 84948311868.18.0C39284
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 540F8120007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 18:32:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dLceegs1;
	spf=pass (imf29.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.167.177 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783103572;
	b=LrRBwTVd9nk5jiWSlqI44JKlFiRRNNOHzqjRcKq2+tVL9jSk18hA6cQ5GQSkrAL2RExQEp
	ULCGtpVC3wjqHWmvlIjFkJvvKhenKMHNd0IRp+CBzdFh2ZlTzQvoAQA0YnGQ4coCB/og0D
	4tyZJpC+zYOcBFhebUgUQ0GcY6MhrFk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783103572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGxxuYIICA4XkrM04fmbBq4SZy/bQdrB/PRjF642fak=;
	b=hYF5eF0Qy0CboyXSkhlKrlmxevgbToujMLzFe07IxE1E6jnFYJr8XaD9d3xszFGrY8n9Y3
	oCf1SaN5kzXSL2PVcdHCWI0KlO8V9A/qmkIRMcavoyMAWquZ4hwlWdVjarLJjzyU8WU+Bb
	YK7z14QMsww+xYuQpmc7FEewQ2pOD90=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dLceegs1;
	spf=pass (imf29.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.167.177 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-495ecb0de70so488903b6e.1
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 11:32:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783103571; cv=none;
        d=google.com; s=arc-20260327;
        b=XTvhFhpUUIBktFcig+8nYSv9Ec80cSOHPrW0+6VWmJvRzar2pcmgrxEBsb3S6z+cez
         FmNHfTWa9j1sqB13ZmnHkNMIeQW3RmZ+XENx4Jsj89L6Ije/bHUkgDJXMl1G1AhRZK9E
         5/5n3oXgO4Qsa+Zl2UtA1GgS0OjylnkIQJ65irRADYaC46boz9tIRnfDvuoGgcAqFNf/
         er8zymtSQD+XDERjsdJK4Am/YVtPYr9vMPEXFADDP1nRhYk8CEb8+Nhr6oCSBR/fjFpJ
         kYRImAyTgvVUIpzJblWtE6fB2GllRw7/g5X/BRk5/LC9TqlRVbmEH7qqc4VefDxv4W7b
         OFHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jGxxuYIICA4XkrM04fmbBq4SZy/bQdrB/PRjF642fak=;
        fh=UF7TbKVNdLhit59PmcC94NKBHiHM35zIfziJUxpuw9A=;
        b=g8egNPDYjBUJTx470/BOzqS9wG1IFmJ5yrafe28fT1eSkiVEBUboxYST0XHhG5FBbD
         QRAC3uur/Av08fOGhm/Pdrw0jf47xTU2FzsiRC2GJR3CMrUscLnAqEElmbAH0jrirToT
         yDuL3nLKRHwusYB6f4AYewmTr5c+plp2jm3r/txzoi2ybwmmO1OvZUyvrF225NgN1gSn
         4fgRE55qXAqwNgo+BmXc9OVFZEsJydCFyzgJPDmVIWztu7DGP1FUnM8VmifqIwBDUz0y
         v/9b7B3Et0YefxIvQw36McQZlsC6e72DFFwecXVGrV/jxNKmrfeWSqzzFyLT1ArCVVuB
         l9OQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783103571; x=1783708371; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jGxxuYIICA4XkrM04fmbBq4SZy/bQdrB/PRjF642fak=;
        b=dLceegs1bkNSmA4wTeasvdqiOqWTQ4BBVBSDRLVR3a+kROwj693CSjlabtBSRMdivM
         AFasUMwWq492Nk+02GH+aMMJH7cG3JdyKcjHWqXvmSZkSh9ZBNEqIAn7OAIAA7A+auRK
         PLfEMnBySiyH21Jtp3O+MLmmzv8jqEpLkvXZ2QnqrqlF7SHw0f831WLYwtC3AB3ZK8Xx
         HQB2PD7lKjbE3RKoaFISgkY1+LaB1MgHFn1Rzz+3RBA7fRg/XjInWL+3nrRDvvAvK4O0
         4wl8DN02bUicfeVhuCwBZ8nyr0DVbJ8cDCkYGCDef/FOtZIE3q3pO3IsFNtpAmR1PhcV
         vNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783103571; x=1783708371;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jGxxuYIICA4XkrM04fmbBq4SZy/bQdrB/PRjF642fak=;
        b=Iq1R4w3on8BUfzhtnKRsp6llhQL83JtRy+EgmCZ7SYwSV3fBYOqo2w42H3iAdnrYK0
         zJ6k94QTU6Ud/A2k/RIZDcJHuH6bapK5Fu+g5yZCGVnkYC2IHzQxMsHn0ZWgKcZpMwpi
         QDR8TRtKbPCvEbNBJwr44SYlfWf07RZ7ha49AHscXDGJAZpgF59j+59k1KrHwi72DS6W
         3Mu/e37Tp5yiprCVqPh86D7Xw8zjdAuPsML83t4gT1rk3NIQtXtUnCccZt8rGZlgRs6p
         pcGTajqHStx4YS9FXZ3aTNDBYglgKleP5S8yrtH1YldkDmYuX3UHX644T+auq7ydhjei
         9B8A==
X-Forwarded-Encrypted: i=1; AFNElJ/+iEHKc6+L900Lf0sWL47Mmk4S48rl6e4balchim62ncw+drIyXdrdMhy1rNAaVykUU0Z2xV5Trw==@kvack.org
X-Gm-Message-State: AOJu0YzDn1Db+2ZaEMQAEFe7iZsCQ6RdGZeJVg7mNib2fEJDthPIq7iD
	mY/LXqLLUJUJW5ZPclHJROR+K5m3Jvelnspr9CpG6mxO6eH5JcaTJB6JRO6IuUrdEUzkudyYiTY
	ydJqGULChn+Q65qOSMtNizC8vavVgc+X9wCV248U=
X-Gm-Gg: AfdE7clSw9MueZLFMgd+mX8ebIDP840LByB7sCRHMxikTg9qSX/t9uBe55ENUrGjpTl
	hqYJcYN6UsrIDcgidpXeJQF7NkKZJk6W5dgI8JDmvaxAF+XQXchVJ4vSPe7ThXZkGFyALKzWIWv
	T2jXpGt+pZZIaH8q6S3jG+2U494PvSK4S78oru6gvAeDI6g6YxBJ+bntmx/KHX5zKvdBLWl1mfL
	NhqWDEtlwAN2NiLB+Pmr4zHDY8Q1TCwgBKXzZ8JmkuViKF+GJS2t3OUD6K+mYKDtpatqVuOBxRl
	UHb9
X-Received: by 2002:a05:6808:c145:b0:492:8920:81b7 with SMTP id
 5614622812f47-499b6477461mr229466b6e.8.1783103571184; Fri, 03 Jul 2026
 11:32:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260630185916.5a694895@pumpkin> <20260702214247.1253741-1-farid.m.zakaria@gmail.com>
 <20260703-meditation-ratsuchende-moratorium-9ecdf1f3f8bb@brauner>
In-Reply-To: <20260703-meditation-ratsuchende-moratorium-9ecdf1f3f8bb@brauner>
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Date: Fri, 3 Jul 2026 11:32:38 -0700
X-Gm-Features: AVVi8Cd92ozOgdmrIKRm-TUElsCXe-xdr671pT3QnWUHq6iaEWsPZ767F3i70qg
Message-ID: <CACCo2jkCFdqa1SQ_k1_42x_KYHReqcaGEScKp8ozt3FcAX7f8Q@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: introduce pluggable ELF interpreter loader registry
To: Christian Brauner <brauner@kernel.org>
Cc: david.laight.linux@gmail.com, jack@suse.cz, jannh@google.com, 
	kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mail@johnericson.me, 
	shuah@kernel.org, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 540F8120007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: saffma9bc1t7ag4nma5kx5yw1ozcwpnm
X-HE-Tag: 1783103572-207687
X-HE-Meta: U2FsdGVkX1/IOM2CSwVQfQk9lX3Q2aQwZ6DpNQlIlJIRi29QJZvDv2iwuYrhJ9Hm71kZJwwqgfMc5eenLXsqZr7BoAQx47OUjmWqIyIaHvXOB7l9U5fmR1ScT9cNmtE6dGaoBPrTRr5M3ROzzGnIa1VTf/BELvvHW35Op7b22DeUmR1MUGDhX0loApv74MIbqJfLRn3FYiC6hQo2Z5/Wg4cNy4mXwf+g4HA3nExjjjP7N3VKehSQ2r1VhjpgtgA7DNYqns6KYOvEzKmCHUPpAQMcqtFze8lX3y2b2tdnO8vosrTsCc8KEQdhiI8wcH2Bh1ScuM5mDAuQOeXQ7gT1TTJtGVXjOTZwEf19VTeF9GxCq30GudHds9xX4xYgQx3pINltOCpm1JDnscdabPtTSloU72GdUdVXFhZZiqPB5SKoJ4FzvRhqsk1eun2G2Gktg2Ir1AqaOFywH/DZOiFC7Kn+BCKZ7VZAp7PeI836fHVizhNjhGyOIzQxEG1U/LaCmuieY9LqujSqGQ1K07gEq0XjCN0u6I77+RIpZ6IEIiLFiv7c4Ska392PYSe1N2Eek8Bkp5y9f3wHNtVZjjrrhcx0h7Nj5bsmwUTlUzmb8pTH32CIdszFhJkBNPd4J0mqqCUWpvFJDx8NtDcobXHK2jHbP5+C5yvCuKOMWqSRae6GZhtkxd4YMZjv3GN+iOZ0P7Udff07MoCT29i4xQm2HlJdaPbU4NZ8OCTzGxUakjSNbMEpN5K0ROVp2sVIpI8MA0wM+trx8v7zu3fucSTOtoejRJ9lMc4jt55MLahNX0pHwcukyLLtEf+ZbzvaiBMXbKtVFHID/BlB1Brc6Bp/GVIsPPb5Qyc63LTvbNdszJGogR8JWuk0cKNQkt8V5cC0iSe1IyxBXKaTJqoKmZ69OAlAEAVJthba5wWAdtlXqvSs0ejqHBVmIt2ybqYjUAjP0DIvvLSRdqJKqbdV8p8
 IDdHAq+w
 +HohQSPIbqWxeSdZySzHYrnjlRJOcWUL10hrM00tlpDTVCxwmT+UzHAgXtp1tiiApsymeOPpiUtyqPSujL39K2TV9YI/KGu3L8SwxpnbeZjGnRrd5ArrrzkbduLNLZSBrXhYNWPk1w4si79bdj5TOYetrjWDMIdprNb05eWaUdzRo2kMu+bwoL40DQpXi+sOJYkY042QKUWWyxZdCml0u+7vb62b9NaqWvjELI3W/ESZR0xiPG8qjBHcK0Edet10zX1ySFo2tUYZiXiIoKYcXAr1OX0BjjOt7rtFqhk/7JsOJwIOxABDdf/FzpGbt4A60BHENzYm4LwZRCa4QE9nFFT9NAnfxhK5Ndn735MbC/5tRvp0wPCKLL0AAfYgBENW7LTqvXaJudAqWKMhSFRSxOlod0hlAPAZyD9OiGJfcL6+qUzUu/OmVHOAoREfTlxnGCU3DBz7QV+Cf6rqo7VQ0Y21/MBOzTX4yumIiA4lIYRUnUghMByK+n7UrhH6HLl8hnB0EFVSLm7tQGLtSvmCcv04Xe0yMOPJ6x1qqd5aY/25ujuZZ0kQ6dCZ+Jc5oio8lUEvO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 3, 2026 at 2:22=E2=80=AFAM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> > Introduce a pluggable framework for ELF binary loading to allow dynamic
> > resolution and redirection of program interpreters (PT_INTERP). This is
> > primarily designed to support hermetic path resolution like NixOS $ORIG=
IN
> > relative dynamic linkers without bloating the core ELF loader or compro=
mising
> > system execution security.
> >
> > Introduce a new registration interface for kernel modules to register
> > open_interpreter callbacks. Standard ELF loading queries this registry;=
 if a
> > plugin resolves a custom segment type (like PT_INTERP_NIX), it returns =
a file
> > descriptor for the resolved interpreter. Secure execution environments
> > (bprm->secureexec) bypass relative resolution for safety.
> >
> > Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
> >
> > diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
> > index 1949e25c7741..ef4277fd8050 100644
> > --- a/fs/Kconfig.binfmt
> > +++ b/fs/Kconfig.binfmt
> > @@ -38,6 +38,21 @@ config BINFMT_ELF_KUNIT_TEST
> >         only needed for debugging. Note that with CONFIG_COMPAT=3Dy, th=
e
> >         compat_binfmt_elf KUnit test is also created.
> >
> > +config BINFMT_ELF_PLUGINS
> > +     bool "Enable plugin support for ELF interpreter loading"
> > +     depends on BINFMT_ELF
> > +     help
> > +       This option allows kernel modules to register handlers to dynam=
ically
> > +       resolve and override the ELF program interpreter (e.g. supporti=
ng relative
> > +       interpreter paths with $ORIGIN).
> > +
> > +config BINFMT_ELF_NIX
> > +     tristate "ELF interpreter plugin for NixOS ($ORIGIN support)"
> > +     depends on BINFMT_ELF_PLUGINS
> > +     help
> > +       This builds the NixOS ELF interpreter plugin. It intercepts PT_=
INTERP_NIX
> > +       headers to resolve relative and $ORIGIN interpreter paths.
> > +
> >  config COMPAT_BINFMT_ELF
> >       def_bool y
> >       depends on COMPAT && BINFMT_ELF
> > diff --git a/fs/Makefile b/fs/Makefile
> > index 89a8a9d207d1..bd81e7ff64f3 100644
> > --- a/fs/Makefile
> > +++ b/fs/Makefile
> > @@ -35,6 +35,7 @@ obj-$(CONFIG_FILE_LOCKING)      +=3D locks.o
> >  obj-$(CONFIG_BINFMT_MISC)    +=3D binfmt_misc.o
> >  obj-$(CONFIG_BINFMT_SCRIPT)  +=3D binfmt_script.o
> >  obj-$(CONFIG_BINFMT_ELF)     +=3D binfmt_elf.o
> > +obj-$(CONFIG_BINFMT_ELF_NIX) +=3D binfmt_elf_nix.o
> >  obj-$(CONFIG_COMPAT_BINFMT_ELF)      +=3D compat_binfmt_elf.o
> >  obj-$(CONFIG_BINFMT_ELF_FDPIC)       +=3D binfmt_elf_fdpic.o
> >  obj-$(CONFIG_BINFMT_FLAT)    +=3D binfmt_flat.o
> > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > index 16a56b6b3f6c..53fa2681555a 100644
> > --- a/fs/binfmt_elf.c
> > +++ b/fs/binfmt_elf.c
> > @@ -35,6 +35,7 @@
> >  #include <linux/random.h>
> >  #include <linux/elf.h>
> >  #include <linux/elf-randomize.h>
> > +#include <linux/elf_plugins.h>
> >  #include <linux/utsname.h>
> >  #include <linux/coredump.h>
> >  #include <linux/sched.h>
> > @@ -870,6 +871,12 @@ static int load_elf_binary(struct linux_binprm *bp=
rm)
> >       if (!elf_phdata)
> >               goto out;
> >
> > +     interpreter =3D elf_plugin_open_interpreter(bprm, elf_ex, elf_phd=
ata);
> > +     if (IS_ERR(interpreter)) {
> > +             retval =3D PTR_ERR(interpreter);
> > +             goto out_free_ph;
> > +     }
> > +
> >       elf_ppnt =3D elf_phdata;
> >       for (i =3D 0; i < elf_ex->e_phnum; i++, elf_ppnt++) {
> >               char *elf_interpreter;
> > @@ -882,6 +889,9 @@ static int load_elf_binary(struct linux_binprm *bpr=
m)
> >               if (elf_ppnt->p_type !=3D PT_INTERP)
> >                       continue;
> >
> > +             if (interpreter)
> > +                     continue;
> > +
>
>
> >               /*
> >                * This is the program interpreter used for shared librar=
ies -
> >                * for now assume that this is an a.out format binary.
> > @@ -935,6 +945,20 @@ static int load_elf_binary(struct linux_binprm *bp=
rm)
> >               goto out_free_ph;
> >       }
> >
> > +     if (interpreter && !interp_elf_ex) {
> > +             interp_elf_ex =3D kmalloc_obj(*interp_elf_ex);
> > +             if (!interp_elf_ex) {
> > +                     retval =3D -ENOMEM;
> > +                     goto out_free_file;
> > +             }
> > +
> > +             /* Get the exec headers */
> > +             retval =3D elf_read(interpreter, interp_elf_ex,
> > +                               sizeof(*interp_elf_ex), 0);
> > +             if (retval < 0)
> > +                     goto out_free_dentry;
> > +     }
> > +
> >       elf_ppnt =3D elf_phdata;
> >       for (i =3D 0; i < elf_ex->e_phnum; i++, elf_ppnt++)
> >               switch (elf_ppnt->p_type) {
> > diff --git a/fs/binfmt_elf_nix.c b/fs/binfmt_elf_nix.c
> > new file mode 100644
> > index 000000000000..d28b92c30939
> > --- /dev/null
> > +++ b/fs/binfmt_elf_nix.c
> > @@ -0,0 +1,108 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/init.h>
> > +#include <linux/fs.h>
> > +#include <linux/path.h>
> > +#include <linux/namei.h>
> > +#include <linux/elf.h>
> > +#include <linux/elf_plugins.h>
> > +#include <linux/slab.h>
> > +
> > +MODULE_DESCRIPTION("ELF Interpreter plugin for NixOS / $ORIGIN");
> > +MODULE_AUTHOR("Farid Zakaria");
> > +MODULE_LICENSE("GPL");
> > +
> > +/* Mnemonic value for NixOS-specific program interpreter: 'N', 'I', 'X=
', 3 */
> > +#define PT_INTERP_NIX  (PT_LOOS + 0x4e49583)
> > +
> > +static struct file *nix_open_interpreter(struct linux_binprm *bprm,
> > +                                      struct elfhdr *elf_ex,
> > +                                      struct elf_phdr *elf_phdata)
> > +{
> > +     struct elf_phdr *elf_ppnt;
> > +     struct file *interpreter =3D NULL;
> > +     char *elf_interpreter =3D NULL;
> > +     int i, retval;
> > +
> > +     /* Find the custom Nix interpreter header */
> > +     elf_ppnt =3D elf_phdata;
> > +     for (i =3D 0; i < elf_ex->e_phnum; i++, elf_ppnt++) {
> > +             if (elf_ppnt->p_type =3D=3D PT_INTERP_NIX)
> > +                     break;
> > +     }
>
>
> > +
> > +     if (i =3D=3D elf_ex->e_phnum)
> > +             return NULL; /* Segment not present; fall back to others =
*/
> > +
> > +     /* Security check: refuse relative interp resolution on secure ex=
ecution */
> > +     if (bprm->secureexec) {
> > +             pr_warn_once("binfmt_elf_nix: secureexec active, refusing=
 custom interpreter lookup\n");
> > +             return NULL; /* Fallback to standard PT_INTERP */
> > +     }
> > +
> > +     if (elf_ppnt->p_filesz > PATH_MAX || elf_ppnt->p_filesz < 2)
> > +             return ERR_PTR(-ENOEXEC);
> > +
> > +     elf_interpreter =3D kmalloc(elf_ppnt->p_filesz, GFP_KERNEL);
> > +     if (!elf_interpreter)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     /* Read the interpreter path from the executable file */
> > +     retval =3D kernel_read(bprm->file, elf_interpreter, elf_ppnt->p_f=
ilesz, &elf_ppnt->p_offset);
>
>
> > +     if (retval !=3D elf_ppnt->p_filesz) {
> > +             retval =3D (retval < 0) ? retval : -EIO;
> > +             goto out_free;
> > +     }
> > +
> > +     if (elf_interpreter[elf_ppnt->p_filesz - 1] !=3D '\0') {
> > +             retval =3D -ENOEXEC;
> > +             goto out_free;
> > +     }
> > +
> > +     /* Path Resolution: Absolute vs. $ORIGIN */
> > +     if (elf_interpreter[0] =3D=3D '/') {
> > +             interpreter =3D open_exec(elf_interpreter);
> > +     } else if (strncmp(elf_interpreter, "$ORIGIN/", 8) =3D=3D 0 || st=
rncmp(elf_interpreter, "${ORIGIN}/", 10) =3D=3D 0) {
> > +             const char *rel_path =3D (elf_interpreter[0] =3D=3D '$') =
? (elf_interpreter + 8) : (elf_interpreter + 10);
>
>
> > +             struct path parent_path;
> > +
> > +             /* Reference parent directory of the executed file safely=
 */
> > +             parent_path.mnt =3D mntget(bprm->file->f_path.mnt);
> > +             parent_path.dentry =3D dget_parent(bprm->file->f_path.den=
try);
> > +
> > +             /* Open relative to parent directory */
> > +             interpreter =3D file_open_root(&parent_path, rel_path, O_=
RDONLY, 0);
>
>
> > +
> > +             path_put(&parent_path);
> > +     } else {
> > +             /* Naked relative paths are rejected for safety */
> > +             retval =3D -ENOEXEC;
> > +             goto out_free;
> > +     }
> > +
> > +     kfree(elf_interpreter);
> > +     return interpreter;
> > +
> > +out_free:
> > +     kfree(elf_interpreter);
> > +     return ERR_PTR(retval);
> > +}
> > +
> > +static struct elf_plugin nix_elf_plugin =3D {
> > +     .owner =3D THIS_MODULE,
> > +     .open_interpreter =3D nix_open_interpreter,
> > +};
> > +
> > +static int __init binfmt_elf_nix_init(void)
> > +{
> > +     return register_elf_plugin(&nix_elf_plugin);
> > +}
> > +
> > +static void __exit binfmt_elf_nix_exit(void)
> > +{
> > +     unregister_elf_plugin(&nix_elf_plugin);
> > +}
> > +
> > +module_init(binfmt_elf_nix_init);
> > +module_exit(binfmt_elf_nix_exit);
> > diff --git a/fs/exec.c b/fs/exec.c
> > index b92fe7db176c..45813bbce833 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -46,6 +46,7 @@
> >  #include <linux/key.h>
> >  #include <linux/personality.h>
> >  #include <linux/binfmts.h>
> > +#include <linux/elf_plugins.h>
> >  #include <linux/utsname.h>
> >  #include <linux/pid_namespace.h>
> >  #include <linux/module.h>
> > @@ -108,6 +109,52 @@ void unregister_binfmt(struct linux_binfmt * fmt)
> >
> >  EXPORT_SYMBOL(unregister_binfmt);
> >
> > +#if IS_ENABLED(CONFIG_BINFMT_ELF_PLUGINS)
> > +static DEFINE_MUTEX(elf_plugins_lock);
> > +static LIST_HEAD(elf_plugins);
> > +
> > +int register_elf_plugin(struct elf_plugin *plugin)
> > +{
> > +     mutex_lock(&elf_plugins_lock);
> > +     list_add_tail(&plugin->list, &elf_plugins);
> > +     mutex_unlock(&elf_plugins_lock);
> > +     return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(register_elf_plugin);
> > +
> > +void unregister_elf_plugin(struct elf_plugin *plugin)
> > +{
> > +     mutex_lock(&elf_plugins_lock);
> > +     list_del(&plugin->list);
> > +     mutex_unlock(&elf_plugins_lock);
> > +}
> > +EXPORT_SYMBOL_GPL(unregister_elf_plugin);
> > +
> > +struct file *elf_plugin_open_interpreter(struct linux_binprm *bprm,
> > +                                      struct elfhdr *elf_ex,
> > +                                      struct elf_phdr *elf_phdata)
> > +{
> > +     struct elf_plugin *plugin;
> > +     struct file *file =3D NULL;
> > +
> > +     mutex_lock(&elf_plugins_lock);
> > +     list_for_each_entry(plugin, &elf_plugins, list) {
> > +             if (!try_module_get(plugin->owner))
> > +                     continue;
> > +             mutex_unlock(&elf_plugins_lock);
> > +
> > +             file =3D plugin->open_interpreter(bprm, elf_ex, elf_phdat=
a);
>
> I have to say I do not like this at all because it also means you need
> actual kernel modules for custom binaries. Yeech.
>

Isn't this already true via binfmt for new binary formats?
ELF support in binfmt itself is also built-in from what I understand.

Anyway, I'm not too attached to the idea, I'm just trying to
brainstorm on how to get it done.

> I think you should extend binfmt_misc for that, combining it with bpf.
> When binfmt_misc selects the interpreter a bpf program is run. That bpf
> program is passed the necessary information to make a decision. It can
> check whether it's in the right sandbox. Then checks if the interpreter
> starts with the magic ORIGIN string or whatever. Once it has determined
> that a binfmt_misc entry applies things progress as usual. Then you can
> point binfmt_misc at a static binary that finds the right loader to use.
>

My audit of this shows it might be doable, but it's definitely
confusing, and I'm still not clear it solves the problem -- I will
work through an example on my NixOS machine. I think I can patch
https://github.com/nix-community/nix-ld to maybe act as this
trampoline for binfmt_misc to read PT_INTERP_NIX. I will try that and
respond back if it works conceptually at least to maybe keep the
discussion moving forward and to explore the space more.

If binfmt_misc has to point to a wrapper binary, that wrapper must
live at a fixed, hardcoded absolute path.
I guess we could bootstrap it for NixOS only but one other problem I
forsee: /proc/self/exe is now something else than expected

The entire goal of relocatability is to allow binaries to run on any
host machine without relying on global, hardcoded system paths.
Just to demo how Nix is designed to let you copy code from a machine
to another with *ideally* no assumptions.
Here is a simple hello world:

#hello.nix
with import <nixpkgs> {};
runCommandCC "hello" {} ''
  mkdir -p $out/bin
  gcc -x c -o $out/bin/hello - <<\INNER_EOF
#include <stdio.h>
int main() {
    printf("Hello, World!\n");
    return 0;
}
INNER_EOF
''

We can then build it:
> nix build -f hello.nix

My machine uses the default /nix/store prefix, so the interpreter is
set to there.
> patchelf --print-interpreter ./result/bin/hello
/nix/store/7nbi22pcc92y2fqbkyp7h3srvvklmckb-glibc-2.40-224/lib/ld-linux-x86=
-64.so.2

If I were to use a machine with a different prefix
/home/fmzakari/.local/nix then I couldn't "substitute" (download from
the cache), this binary.
I would have to build it and the whole graph down to our bootstrap
seeds with the new store prefix.

Nix then let's us then query the graph and copy it, including ld.so
and glibc to any other machine to ideally run.

> nix-store --query --tree $(realpath result)
/nix/store/adbwpmzwgdcmk5qcskyqwygmxbkffb32-hello
=E2=94=9C=E2=94=80=E2=94=80=E2=94=80/nix/store/7nbi22pcc92y2fqbkyp7h3srvvkl=
mckb-glibc-2.40-224
=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80/nix/store/fv5lgysa3hmf3l3d=
kkpwvndcg6xwhy8m-xgcc-14.3.0-libgcc
=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80/nix/store/qywg7bxskvihq62m=
s2g51fkzkrdnyfkh-libidn2-2.3.8
=E2=94=82   =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80/nix/store/hjwp=
pd89fk8781xl4r35xqlddwqi5f66-libunistring-1.4.1
=E2=94=82   =E2=94=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80=E2=94=80/ni=
x/store/hjwppd89fk8781xl4r35xqlddwqi5f66-libunistring-1.4.1
[...]
=E2=94=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80=E2=94=80/nix/store/qywg=
7bxskvihq62ms2g51fkzkrdnyfkh-libidn2-2.3.8 [...]
=E2=94=82   =E2=94=94=E2=94=80=E2=94=80=E2=94=80/nix/store/7nbi22pcc92y2fqb=
kyp7h3srvvklmckb-glibc-2.40-224 [...]
=E2=94=9C=E2=94=80=E2=94=80=E2=94=80/nix/store/ybp235ps7m4yd85v0pgvqkhd4xmx=
f6jq-gcc-14.3.0-lib
=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80/nix/store/7nbi22pcc92y2fqb=
kyp7h3srvvklmckb-glibc-2.40-224 [...]
=E2=94=82   =E2=94=9C=E2=94=80=E2=94=80=E2=94=80/nix/store/phpq5h7cp6y1w84a=
ysy29548irqy5dd9-gcc-14.3.0-libgcc
=E2=94=82   =E2=94=94=E2=94=80=E2=94=80=E2=94=80/nix/store/ybp235ps7m4yd85v=
0pgvqkhd4xmxf6jq-gcc-14.3.0-lib [...]
=E2=94=94=E2=94=80=E2=94=80=E2=94=80/nix/store/adbwpmzwgdcmk5qcskyqwygmxbkf=
fb32-hello [...]

I appreciate you engaging me on this topic -- thank you.

> --
> Christian Brauner <brauner@kernel.org>

