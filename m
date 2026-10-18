Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AFD8CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 10:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302916B0088; Sun, 18 Oct 2026 06:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DA0A6B008C; Sun, 18 Oct 2026 06:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217326B0092; Sun, 18 Oct 2026 06:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E51816B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 06:05:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 61A8A804B9
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 10:05:32 +0000 (UTC)
X-FDA: 85335314904.22.2EA82AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C21BEC0004
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 10:05:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LlfOH1BE;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792317930;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETvWHCv+YWAW/95X/rvxXWNfuIrsc5FgmN2eiPSQKro=;
	b=HFJUf/dqqYKsTht7X/EIYPZ+yjECYm59TA6inYxnZip1Mp0v48XFck6EmL7sweJZs6FjwG
	t0Y9NDd4+sVVt4JxiOoC1wXhBKuDWL82nXGGQsXbjgbD+U0s5/har5RPBSIXXcpr2jAn+2
	pdf62Isq5j2oMiSJqeikATsHqubpkK0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792317930;
	b=6kBhzxQoK6kx/tCRDoW28/rAlUnBkj608yOhYonZ+Oi7uXacc/I0/RxSbamCo3QoZgKFRO
	gariebzCDRTEIRumneFvZbqWzE03g988+QeR5B//7e+6xiE3x/UKpqh2oNQZPR68jFZ778
	qhjTB2QJzmL/6rhZDunXYHGiBengqcE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LlfOH1BE;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED5F960142;
	Sun, 18 Oct 2026 10:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F91C1F000C4;
	Sun, 18 Oct 2026 10:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792317929;
	bh=ETvWHCv+YWAW/95X/rvxXWNfuIrsc5FgmN2eiPSQKro=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LlfOH1BESOD3TFjWtxVowgOdqStNnwpSNO0UCNITUfYyI8YUy3xCWjk/GtjXdWN77
	 3XQDUkQBonf82Kvka0zwwX7J90NzQ1YX/1zQlTkzKKXfGMfxbS4M/SleV0C1kZtjGj
	 JjTmaBxLkXxvU9zEkhlsVvWJ7GI0Py3MVm9gwAdzGmSinB5XfqgZflFjAmoc1Gw8yv
	 WwaPzYuFNl2dlVF6EKcTPF1VD02wvQMlPn+SHFkCXt8Ek7ZIMPydFL+98FPSRa4XIS
	 NBBq5I2tFxz1kYSrVrXmYJyMHst13Y3sFUNCfqfXjM0Xn4SAyJDaYOIVKM5y8+HCB0
	 DEwSk/DYfSFtA==
Message-ID: <sashiko-outbox-176036@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] sparc64: Randomize the load address of PIE
 executables
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stian Halseth" <stian@itx.no>, "Andreas Larsson" <andreas@gaisler.com>, "David
 S . Miller" <davem@davemloft.net>
Cc: "Kees Cook" <kees@kernel.org>, "Michel Lespinasse" <michel@lespinasse.org>, linux-mm@kvack.org
In-Reply-To: <20261017100451.2266781-3-stian@itx.no>
References: <20261017100451.2266781-1-stian@itx.no>
 <20261017100451.2266781-3-stian@itx.no>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 18 Oct 2026 10:05:28 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: C21BEC0004
X-Stat-Signature: tchcbar44kr8fg9epgn51nyj6poc8gtu
X-Rspamd-Server: rspam05
X-HE-Tag: 1792317930-912997
X-HE-Meta: U2FsdGVkX18pB/EgPTZb/eQocjVUFzzEmFiUz6HaprbTuOoTpubxOWAfvgAUPFlxhkx8Rx/uM5xcC/8jsW/8zrR2KeKis5gG7IWzjreiPKgpXiRZrCK+DtE0hMK/ScjimdW6d193cdcIFcouDgOC4sw3hVwU6v1dqHfWoQw6I/cLXN0YxpMtrCh6OaH1CoNvUp+aFU0fB+bI42AVBPbArucBIljZMhuTVhZGU/SiIMOhEriixgSdWfgkDTEO4R9w1ERVa/GGmW1fh3N/7P7z/kLcX1rRBmyNZ0xxRY/ugwhqNg3OW014r/nD47H7Jcv9EHXO1w5MwCIZPdJFp59ZD47aPy9ZGu6RNj+RT5nVXjCGnhp2gSltrDk/e9oqeDQTA27u4NqLgia8sEp3qB4QM7W4i+TDRxI7IRlhXdLvUEZEBh6dfzpB5N9ninovbttXHq/kFyCfYTOvZs4Q0rJD9r+fG9eYV9pwa2bD5sTP5YoSM3rwdinAUIKG9I9uOznszCId0ef0V1T5Axc1p1yUfVLpBKFXaswWNH3LgUoj9aTJoTZTCwfYpidt2OUXrPN2v4bAW/5rJvoWr0PVOlB+GlRWQEw1GR+8/B6JJ5RYQ4H8lafwoZv05ZBJuzIj+dwebwdMqafRIbJQOidOJl83+TOZzjvyGOlMhImxZFnqYLShsY+1LwlVQi/xCu3A7WCt1Lne618u41/NIt93mjowdvU5enCJXLwEbbwD3xE3U4+Ub5ZCEKBrUSACvlXOGwgnofr00H73nXSFE8FiNZDkZRj4ZBri/qlLZTMZwPD6/6ZxZ8kbTVwd5Q+plj2RXNN3pOWHK3vV/1mnWTf7frDNCyT7XwDahXdlKlvN9W+erfKDGwmO6R6dOLtc6QyUvQY4fVD6jEpqqdjvvSaTqOr9ghq2IUIFiSummXCQXt6iFDBX6Q19xF373QNC7FtN08RgDSJ+u/UCs+xggyChHlt
 byNr1oZg
 Avs+uZ6bqYIPFyCM7nscndRFU6fgQo+OpEdnKIuvk3kBsuiCCFqYFTx8ISeV2vn+z385szOp7tegn6EZPhwbt8oh8Wf6FEsABdPe3pjm4iu2Y29OlXjD5jPETEolQ6zsi9amqKOi7/WWYehF1dxGGSo2caUpA4kwwGruSxqNONO1rraNmFu2Kt0McwIE69Ucse6kPTDh1bMbBB2IU3x5k/r8X58E4ZddVKeZUSvkDeVP62I2MLOWbbhCAprUN0PDSIym/KlThpYnd2o5APQgiNpoqTDpopqzgFRA1dOEJCgslOTaoqlyi7w2YkLjFxmUIuBCOKGaWSNr/RD5SpiouEXmIrBA/O0JaxCnayaucNkyVjtc9VjPHyAr8kST4nzmMTGYQcdWa6vhipYHn/CPOB4mVAugYtwwKeWGUonEWh8vBBGI5aqKL4UZh0SABi/XvuWWSeD5reyCaHic13VMX3pipqZLZhWezh63ZAjftsPPzLZ0vle1UgWNsvkO5bPHIoNiDneHDTBA6ei3s9UNr9D5xzZOSLhZd3HgEXfIHrVsum2XiGKb40jCwDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] sparc64: 32-bit compat PIE and brk collide with TASK_UNMAPPED_BASE
--

commit 91a8982a72732f896c36479ab4e561774ee258f9
Author: Stian Halseth <stian@itx.no>

sparc64: Randomize the load address of PIE executables

This commit enables PIE load address and brk randomization on sparc64 by
renaming mmap_rnd() to arch_mmap_rnd(), adding arch_randomize_brk(), and
selecting ARCH_HAS_ELF_RANDOMIZE.

> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index ab77d3f2536e1..82c989b9e7831 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -71,6 +71,7 @@ config SPARC64
>  	def_bool 64BIT
>  	select ALTERNATE_USER_ADDRESS_SPACE
>  	select ARCH_HAS_DELAY_TIMER
> +	select ARCH_HAS_ELF_RANDOMIZE
>  	select HAVE_FUNCTION_TRACER
>  	select HAVE_FUNCTION_GRAPH_TRACER
>  	select HAVE_KRETPROBES
> diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_spa=
rc_64.c
> index 087595fa43081..2948d5769e768 100644
> --- a/arch/sparc/kernel/sys_sparc_64.c
> +++ b/arch/sparc/kernel/sys_sparc_64.c
> @@ -26,6 +26,8 @@
>  #include <linux/ipc.h>
>  #include <linux/personality.h>
>  #include <linux/random.h>
> +#include <linux/elf-randomize.h>
> +#include <linux/sizes.h>
>  #include <linux/export.h>
>  #include <linux/context_tracking.h>
>  #include <linux/timex.h>
> @@ -280,7 +282,7 @@ unsigned long get_fb_unmapped_area(struct file *filp,=
 unsigned long orig_addr, u
>  EXPORT_SYMBOL(get_fb_unmapped_area);
> =20
>  /* Essentially the same as PowerPC.  */
> -static unsigned long mmap_rnd(void)
> +unsigned long arch_mmap_rnd(void)
>  {
>  	unsigned long rnd =3D 0UL;
> =20
> @@ -294,9 +296,17 @@ static unsigned long mmap_rnd(void)
>  	return rnd << PAGE_SHIFT;
>  }
> =20
> +unsigned long arch_randomize_brk(struct mm_struct *mm)
> +{
> +	if (test_thread_flag(TIF_32BIT))
> +		return randomize_page(mm->brk, SZ_32M);
> +
> +	return randomize_page(mm->brk, SZ_1G);
> +}

[Severity: High]
Does enabling ARCH_HAS_ELF_RANDOMIZE and arch_randomize_brk() cause 32-bit
compat PIE binaries and their brk heap to collide with TASK_UNMAPPED_BASE
when using the bottom-up mmap layout?

On sparc64, 32-bit tasks (TIF_32BIT) have COMPAT_ELF_ET_DYN_BASE and
TASK_UNMAPPED_BASE set to the same address (0x70000000UL):

arch/sparc/include/asm/elf_64.h:
    #define ELF_ET_DYN_BASE		0x0000010000000000UL
    #define COMPAT_ELF_ET_DYN_BASE	0x0000000070000000UL

arch/sparc/include/asm/page_64.h:
    #define TASK_UNMAPPED_BASE	(test_thread_flag(TIF_32BIT) ? \
    				 _AC(0x0000000070000000,UL) : \
    				 VA_EXCLUDE_END)

When a 32-bit compat task uses the bottom-up layout in
arch_pick_mmap_layout() (when RLIMIT_STACK is RLIM_INFINITY,
ADDR_COMPAT_LAYOUT is set in personality, or sysctl_legacy_va_layout is
enabled), mm->mmap_base is set to 0x70000000UL + random_factor (with
random_factor in [0, 8MB)).

With CONFIG_ARCH_HAS_ELF_RANDOMIZE selected, fs/compat_binfmt_elf.c (which
builds load_elf_binary() with ELF_ET_DYN_BASE defined as
COMPAT_ELF_ET_DYN_BASE) changes behavior in two ways for 32-bit bottom-up
tasks:

1. For 32-bit ET_DYN binaries without PT_INTERP (static PIE or direct
   invocation of ld.so), load_elf_binary() maps the binary at load_bias =3D=
 0,
   which resolves via arch_get_unmapped_area() to mm->mmap_base
   (0x70000000UL + rnd1). Then load_elf_binary() moves elf_brk:

   fs/binfmt_elf.c:load_elf_binary() {
       ...
       if (!IS_ENABLED(CONFIG_COMPAT_BRK) &&
           IS_ENABLED(CONFIG_ARCH_HAS_ELF_RANDOMIZE) &&
           elf_ex->e_type =3D=3D ET_DYN && !interpreter) {
           elf_brk =3D ELF_ET_DYN_BASE;
           /* This counts as moving the brk, so let brk(2) know. */
           brk_moved =3D true;
       }
   }

   When ASLR is disabled or randomize_va_space is 1, mm->start_brk and
   mm->brk are set to 0x70000000UL, pointing directly at the start of the
   mapped binary and causing sys_brk() to hit the binary's own VMA and fail
   on the first heap expansion. When randomize_va_space is 2,
   arch_randomize_brk() places mm->brk in [0x70000000UL, 0x70000000UL + 32M=
B),
   overlapping the binary, vDSO, and bottom-up mmap region.

2. For 32-bit dynamic PIE binaries (ET_DYN with PT_INTERP) in bottom-up
   mode, load_elf_binary() randomizes load_bias to 0x70000000UL + rnd2
   (with rnd2 in [0, 8MB)), mapping the executable in the same
   [0x70000000UL, 0x70800000UL) window as mm->mmap_base. Next,
   load_elf_interp() and arch_setup_additional_pages() map ld.so and the
   vDSO bottom-up from mm->mmap_base, placing them at or shortly above
   elf_brk. Then arch_randomize_brk() advances mm->start_brk and mm->brk by
   up to SZ_32M past elf_brk without checking for existing VMAs, placing
   mm->brk inside or above ld.so/vDSO right in the middle of the bottom-up
   mmap region.

Should COMPAT_ELF_ET_DYN_BASE be separated from 32-bit TASK_UNMAPPED_BASE
(similar to powerpc, x86, and arm64, which place 32-bit COMPAT_ELF_ET_DYN_B=
ASE
at 0x000400000UL or offset from TASK_UNMAPPED_BASE) so that 32-bit PIE and
brk do not collide with the bottom-up mmap base?

> +
>  void arch_pick_mmap_layout(struct mm_struct *mm, const struct rlimit *rl=
im_stack)
>  {
> -	unsigned long random_factor =3D mmap_rnd();
> +	unsigned long random_factor =3D arch_mmap_rnd();
>  	unsigned long gap;
> =20
>  	/*

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017100451.2266=
781-1-stian@itx.no?part=3D2

