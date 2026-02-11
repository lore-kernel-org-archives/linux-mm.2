Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B302CECD6E9
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 20:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6FD96B0005; Wed, 11 Feb 2026 15:14:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B308F6B0088; Wed, 11 Feb 2026 15:14:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A127D6B0089; Wed, 11 Feb 2026 15:14:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 921446B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:14:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57E76C2061
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:14:35 +0000 (UTC)
X-FDA: 84433278510.18.F1EAC54
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3891F1C0007
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:14:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BE6CEEcb;
	spf=pass (imf21.hostedemail.com: domain of linmag7@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=linmag7@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770840873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28hr9LjidhOb4+7vDtUZiT7dYr2nuAMqMlceW5mXuOg=;
	b=ZMIeGUFuoOxtKsa6Gg8EfGlnv9lPmZLqi9oZVwinJCypaD4ahUmOd02+0oj9LHcLE3mHYM
	cINw2CkRwyYqmyN8daW3YmFamSxr8VNRb47DYcYg/Lxm5CFQ7gZUJH7vVxki5Q8AnwaGI8
	Rptq3rPFU2gTbVVw89T3+BeXj6o1Ym4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BE6CEEcb;
	spf=pass (imf21.hostedemail.com: domain of linmag7@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=linmag7@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770840873; a=rsa-sha256;
	cv=pass;
	b=Vn2o0gOrRvQ7FJlyGPzoEtMyURZcXFOQMbGyR9C52IJTwex3wKWqa9wKbMpob4RAlMRe4E
	jmSFO1D4lfHf0XB/+17ngXqUT0QeQ9JczSfZBuDVR1Hi4LUhvPeg2VFDLj+von2K9XT067
	vJBMUUClU7AtE2ILQRx/Ph8NBFq5jPg=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b8871718b00so909109266b.3
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:14:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770840872; cv=none;
        d=google.com; s=arc-20240605;
        b=fSMXlQH1IFO5oY3cE2y9jAUEAukWPC1uXVKWPmPaBUXlmq4tS/ynfZuR/T1A/4+75m
         YcPkCNso+irLNBxj0jBwVekQO0y4layP8Mu/JRteajNgCigT3qT2piT4iGfVDb0gWt17
         hfBN5kdZ7FtRSV4Xs6GNdkJalOct+0iM38rWkgfiQOS86sZgid02GBn1dHj1VKmgrzvK
         9yEGRdzvYcA0IckEZfTcSo678YcSToSSAxJxTlcn6VPlkbfFuoUn6VLLBArjPdAXCx6S
         r9lUykL9sUOgrKkAs+dVz7WjslNES5m3AmWhELcUDlqPbqYMojEnIaR7q++T4WveK0FG
         EzkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=28hr9LjidhOb4+7vDtUZiT7dYr2nuAMqMlceW5mXuOg=;
        fh=VN+A5oAlPiPZmll4xcZJnc09MnRSbbjDv1N+BYaT/+k=;
        b=kVzKTQtiH3MkejxZPLjxYKm+4P5K8/sFBSp66mkI0IqgdeuhkPoRWp3GI7L4Y4koSy
         PwYO+JhoQyjCVlxCvHC+OjwOnsWhcXdn8te5bqMiXxpVOhJe4wXw4aA3IiW1KJhzFcZm
         jqb7KspXF9QxS9QBFDJSj9XPpf2ZeFtCFxTpwveWA41m3ck+/s46Z8u+GovPKhKmMn72
         opf7s2OjLA5+kWRLGV/tywiVIG/+WuwHptJFY2AI6jUr9SEelo82TjyYW3u26noqDYd0
         /AZnaT6XFfoK0dDj5SSXTPvChFuzlce6QIYGKTBjTTfKHleKv7VmGAAXsA3VvzpnS7Q7
         XAnA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770840872; x=1771445672; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=28hr9LjidhOb4+7vDtUZiT7dYr2nuAMqMlceW5mXuOg=;
        b=BE6CEEcblB5Laiy6YrzjdF2miXoc0puofLt85IVcxPPuP7raR5g151VYcztdQOkT3j
         91dYldcdUPPhZ8P3Qf50TrnN5oP3cVmsv7OPwlkWM4x7REz0wKnRNqX6LLFBZaYd6ER5
         ZvQDHx+l8ll/Mel62h1l/mOV9F9mq32Nd8//4FprEAHbkxi8gmgRbQ3wmdCeCQQLzJ0l
         UFJILuWbH/iSWk4LJyFMFW2AEB+Pqsz4mUmrwqn0FMl8hHuCGB2Y2TJWqDXNoVrJ+flX
         Ha468M0Jr8B4U8D7ewhiMmrcmhZb798wyXHkxRWcOpL8qQiBIPX7mQfP5u+0A+/zVhSx
         yz6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770840872; x=1771445672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=28hr9LjidhOb4+7vDtUZiT7dYr2nuAMqMlceW5mXuOg=;
        b=wLk0Zar7gjvo1M2nCZvt1fJdKgQNvQPdEMGMeiuhSMLq/DOsHlc0BcYLT3V66BvLwd
         x5LJpuZqK872Tf0LdF/Ag4hKNRjq+ZpbI3mwtsLsqyoQtSsbbX2b2kjgBoggcuTmzzGt
         s3pSTeMjteRCCf7XbGYqFGUOXFPKBQJKnINjWm+vV43LFaZqg3glKziyoVZsQwZn7QdQ
         vVglU+pzbCLZMMAflbfcQ2ykJUz5OARyZrfrBpSpKNe0jEHoFfl9oCm9hLsGTdMBWszR
         N8y+ooHiWVU5WgISKKvUVVoowwxLjedsvlDZwOwfvlMQLKnsrBjgz+UmPfLpiL0FpOVm
         68Nw==
X-Forwarded-Encrypted: i=1; AJvYcCWr1bX3n8DeBwtzTUESbLWI50ifyCxqbdkVuuK8gO5bHw7azcwOgpx17hTkUmH8tQ4I8NVS4XXvdQ==@kvack.org
X-Gm-Message-State: AOJu0Yxc9mJMOkaHf2vZkGYpksoIzM1RVrPR6eqP1oT5LGB2eiKcktUd
	YbkvhoHcFm8sKeiiDzLy7dkXHyR1RWE5W3CrO5SW4QLq41efRtOgDnJkD1QjLog4JgliQRgERPS
	zwsSH0KyOCZG+Gp2w7/PFKWhJNzJDJzE=
X-Gm-Gg: AZuq6aJOM2EHbVYnSPFs2cHShDIWe21YZUGmCsqjiP4AtO0BUxiXydCazRYXfqUOl5P
	1lW7xeU8H1cs1jJK9aRXtAyRbJvcJjuiUzwCc9ErZpac0MspwdgpXB8kLgEg7XZoyg4Q3cMrS8A
	g++eKepacKqojpU4YzdpceX8JaJf92xUJoW2zGgldFcz0XzeL1339NFFE6t1QFQpRd+6JihTcS5
	qsq8gTYs8B1riZhiC0881IUBA8gSfivIIVujtjdjTLHLcx3aFqS2psGMpaE07WdeUi5SuSUi/+7
	Js4D39M2p4wIhkLNQOIFBR5CUMb8ZLfGauAM+t9Iyg==
X-Received: by 2002:a17:907:a08a:b0:b8e:64e:1ed with SMTP id
 a640c23a62f3a-b8f8f72d91emr17643566b.50.1770840871149; Wed, 11 Feb 2026
 12:14:31 -0800 (PST)
MIME-Version: 1.0
References: <20260211103141.3215197-1-rppt@kernel.org> <20260211103141.3215197-4-rppt@kernel.org>
In-Reply-To: <20260211103141.3215197-4-rppt@kernel.org>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Wed, 11 Feb 2026 21:14:19 +0100
X-Gm-Features: AZwV_QgdPAvH3hw0825YIt93LQPupYFvh_AV-2zMkwGhubC87cSa2iVxpdoZwag
Message-ID: <CA+=Fv5T07oBJweU3tURD4Nuh7VRWovsf0zjHtA1nDAVNmO=D2w@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] arch, mm: consolidate empty_zero_page
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andreas Larsson <andreas@gaisler.com>, 
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Dave Hansen <dave.hansen@linux.intel.com>, David Hildenbrand <david@kernel.org>, 
	Dinh Nguyen <dinguyen@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Guo Ren <guoren@kernel.org>, 
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Johannes Berg <johannes@sipsolutions.net>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Richard Weinberger <richard@nod.at>, 
	Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, Vineet Gupta <vgupta@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>, linux-alpha@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 3891F1C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: 36sqburzgaxztf9s6uhghck39y7tfrsx
X-HE-Tag: 1770840872-324308
X-HE-Meta: U2FsdGVkX19R+909JH9fhqVyRs9kx0UOP6Jw2kXdtxDsoqTqa8Nbe2wT6Gzf4fPp2P4DsN8/5pUQlud3Gs++jfw284wdKjoy/sfSjwRs+4AULmQn6079xElpX/k35f631hdTOwRJHce14MF1hUot3h5kHamvQTIE3tX1E8wne19ifx3X9bN4kbgFl45T0yo0+eK6cusOtTBoVpHCnr5vcwkWP+QFtsOFbmY53W0GMONJ751VCjlTcuO8iNAsfrqjccdzTmr21YGdOpMZh85I6jveIC00M1+45SPmyUE3QXNDya+u/5SI8cFKRchRtzwx/6lsZ4IuqgaJjGNdTgEnHtWwwdWCEG0kpOhC+UK1b7OWjFJz6R28grQ6LYFnJQ32/MxkHHvwez/xK7cHsl6eUFkFxLGT/7J7Nxdee3DhOH2N4fxNQBqsS2l3B/ulmvU7Fo4z7fgnjQmrvT0HYYsjrXnmMDCVuUJvoPWn/u+UQh0zI/mmrBo4+83yCrFBI3nOjy08CtFbctAzyN8jAAkEfreDiIC4yik2i0/s2nCcbHx7cV1nle7nwi4AJj9P5IQq9fIwuCy3+KsrB7xP89rf/WPNO0jYZSuW1f65gHmcFIXPW8MFtxns1bh+/g9Ow1oLjGT1MY949dJRpm25hilldxZ/jVhUbMl2mqnLQ2j3KZhlNRMOJDHhF5TG+A340TpPKHSydSzQPeytQzCXkEP958zdFtFsbqZeC/5yYnZl1S06Y9br5Ys5V6Dc+DxamNMXfHupiymNbZics+CtWT6J2HMlqs6VoiTevxSmcCQNFfVFXhVLAAA2/Asy6a8MiC9094TvDNHMRUM702gPWQo3SlTAqp72xWSy+Qpy0cDU/RhJaAE3auDruYyHC+wUaCOL/hrfFNw1Salg8rwn7Q/8A9gX9vHobR7kcDxO7YXwBrzhtDL92j+4mwCqNNENoiuCZHik/nFlDbP5AzP9vxR
 4ZeWHtz6
 dXAw4Q+wbQaPbV+CJtKj1MBdQ4kVGH2IvS9FE9slh73zKO5vxdJEILHvgHcn7rI7PfFMReqBMjA6ES04sVONYSoFgWyIKOA378SPfh165YELRa2OgRNElDF6xkMIxX/Ic7kJDNl+M5O/otDTwo9QdM7QgkM4idPl5jsB3eKpa4wXvvxAuH56AxsoIuwe4vDljO2iEp3IU4Pmuh8x2xgsV8MeHbp6zKtYxkBE3Gp6SIpiCgDxVOoGLuSLuDn8mkmJ7cmr+Q6PJ+IPeUz4966X7ctC6cgWst4s7KQZxIC+Y8irfDIzss95iYRp5PHe1QdxuFmX8ufus3q/B4pPLqn7Gesrq+fnSxz2S4CuYDQ/CuHTRF7qOrE4Cl0uGFwcxqJjb3uC8Vn+6EU0B2i0PXIEOrJ+/cEHcfJp1HVTUiTOlCxEMqzCBIQW9yTM8lFUiNu9QJiZ4RtAsjvr1YKw040x7sVT2sFII8PWKUUUntm3tPV0NJcl7Wfld1XZWy/hCS31ZElRPPD2xHgJdu22thFcunV51eWBhVGx+XARmzkr0Lid5QM/pF4skTKNqt40XYsGO7EaEFoNIUYJ8IJNmKvTlecA1zsN8qG3s8t5GUnBcPfCOFARbzdvPiqpOQRFwscMGeqOc4TzQblQck24QAehOS7e4iQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 11:32=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Reduce 22 declarations of empty_zero_page to 3 and 23 declarations of
> ZERO_PAGE() to 4.
>
> Every architecture defines empty_zero_page that way or another, but for t=
he
> most of them it is always a page aligned page in BSS and most definitions
> of ZERO_PAGE do virt_to_page(empty_zero_page).
>
> Move Linus vetted x86 definition of empty_zero_page and ZERO_PAGE() to th=
e
> core MM and drop these definitions in architectures that do not implement
> colored zero page (MIPS and s390).
>
> ZERO_PAGE() remains a macro because turning it to a wrapper for a static
> inline causes severe pain in header dependencies.
>
> For the most part the change is mechanical, with these being noteworthy:
>
> * alpha: aliased empty_zero_page with ZERO_PGE that was also used for boo=
t
>   parameters. Switching to a generic empty_zero_page removes the aliasing
>   and keeps ZERO_PGE for boot parameters only
> * arm64: uses __pa_symbol() in ZERO_PAGE() so that definition of
>   ZERO_PAGE() is kept intact.
> * m68k/parisc/um: allocated empty_zero_page from memblock,
>   although they do not support zero page coloring and having it in BSS
>   will work fine.
> * sparc64 can have empty_zero_page in BSS rather allocate it, but it
>   can't use virt_to_page() for BSS. Keep it's definition of ZERO_PAGE()
>   but instead of allocating it, make mem_map_zero point to
>   empty_zero_page.
> * sh: used empty_zero_page for boot parameters at the very early boot.
>   Rename the parameters page to boot_params_page and let sh use the gener=
ic
>   empty_zero_page.
> * hexagon: had an amusing comment about empty_zero_page
>
>         /* A handy thing to have if one has the RAM. Declared in head.S *=
/
>
>   that unfortunately had to go :)
>
> Acked-by: Helge Deller <deller@gmx.de>   # parisc
> Tested-by: Helge Deller <deller@gmx.de>  # parisc
> Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/alpha/include/asm/pgtable.h          |  6 ------

> diff --git a/arch/alpha/include/asm/pgtable.h b/arch/alpha/include/asm/pg=
table.h
> index 90e7a9539102..12a3c5f8ece8 100644
> --- a/arch/alpha/include/asm/pgtable.h
> +++ b/arch/alpha/include/asm/pgtable.h
> @@ -125,12 +125,6 @@ struct vm_area_struct;
>   */
>  #define pgprot_noncached(prot) (prot)
>
> -/*
> - * ZERO_PAGE is a global shared page that is always zero:  used
> - * for zero-mapped memory areas etc..
> - */
> -#define ZERO_PAGE(vaddr)       (virt_to_page(ZERO_PGE))
> -
>  /*
>   * On certain platforms whose physical address space can overlap KSEG,
>   * namely EV6 and above, we must re-twiddle the physaddr to restore the

This looks good from an Alpha perspective

Acked-by: Magnus Lindholm <linmag7@gmail.com>

