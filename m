Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D60010987A1
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 15:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9B16B00DC; Fri, 20 Mar 2026 11:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81C16B00DF; Fri, 20 Mar 2026 11:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98316B00E0; Fri, 20 Mar 2026 11:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B858F6B00DC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:57:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 61F811A027B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:57:23 +0000 (UTC)
X-FDA: 84566895966.23.AD11F2A
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id B7B9D80011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:57:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="F4SoQ/1Z";
	spf=pass (imf02.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774022241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oK6vwbMjQIiUdNKsZRuAWsUjoKK5vttOS+cqd5buiAI=;
	b=AkRLG12t+bbhmjoNG6Dfrlf2zElXvxLlPGduL8aUxIkH0B85RHgT4ZV7eiHNcseo78ciGf
	TW0QtB1KEYOqy/Ez3ZzBaXw9/gtFG9ncWvz+OxcpoSGS/mnztuk2FOJifXrVfYD+Pae4wZ
	52F+24DBR8OHp+CDZ8SmoTgAPaSCyPA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="F4SoQ/1Z";
	spf=pass (imf02.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774022241; a=rsa-sha256;
	cv=none;
	b=a2m3KienvLFfspGZE+hKtOXl5XXVa09/bs3m6+l+ZRkF9DXYdnlQQyAseTN4Fw5+jZyhUl
	x7eclSZGms2OLB8z+xsw72mbhkCwZ7Fq4iejALQcQlS1FqD3Vz1wd07pVjMff3ZLhvRMq9
	n6ayG3Cp0IcPJc2d9/F/WGPS2lXSmk8=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8CAB940E0251;
	Fri, 20 Mar 2026 15:57:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id i_66GO8Hl-pe; Fri, 20 Mar 2026 15:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1774022234; bh=oK6vwbMjQIiUdNKsZRuAWsUjoKK5vttOS+cqd5buiAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F4SoQ/1ZCCAN46Y/6n7nC9Xgw35pEYUtEmr06Sbu7uWqtgoF+NlFhArtM4fb0EeYg
	 XzQMWFk0LFbHVdcaQ8Y8CuLtK5uQJSDAUI1R/MS52Biv2rtEjO/e8weNxOGjTpF6nq
	 LTpMJe68dgrteo1pGT0mzRtsjo3zLj0CQlpoFHg3hBs4Vjzis6JkPTQF6SrC3Dzcgc
	 /qv0n1FggvdE8Q1HVsUWs25WUAgB3mTvzfWe4mSH96xQrnZbRl6QX192jy/9zb6AEH
	 jFM6ae4kgKhUfppnZ5T6RU2Sb3wZwaDDKeh0RYT79BEfi7AHWGwNxJAliX6j/ig5Gg
	 7jeLbunK8Lg2bbAjkgWHWmhTZHSii0aXLF192MCTXaPw3D9Xs2VFXYf6JzN0WgojUn
	 ht6DyzR0fEW62CUpcUadEjrfQH3zJ1RjcLO8zHQWlRa81arYSo1dKeP54bAw+F5bPT
	 ewypeezs5qhKUXhqu880qTD8jPxmPKPVsuYhcA7ClVfd6PXDXAl4FSN2njJYAJybhK
	 3a/x7d+4W1D9jlb5FX2pBSvk0ZPHMJcc6HzE/48JRlyHgSQkiZDRtVJN6NpmPU8JBV
	 ZuL5TAuABQ8RJZKPV8C7jvmXkKCPhk0WwhD1R8ivJCfAQTPS8F7qI0ocFbnZg4djKK
	 2TlAgM89Jf+bf8aQDDB5a1pQ=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id DB6CD40E024F;
	Fri, 20 Mar 2026 15:57:04 +0000 (UTC)
Date: Fri, 20 Mar 2026 16:56:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: tglx@kernel.org, mingo@redhat.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, dvyukov@google.com,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/kexec: Disable KCOV instrumentation after
 load_segments()
Message-ID: <20260320155659.GDab1uSxYFWCUGcvbN@fat_crate.local>
References: <20260317220319.788561-1-nogikh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260317220319.788561-1-nogikh@google.com>
X-Stat-Signature: 8jwxjdz594rh98e5c5h5ekq5by3y3yfd
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B7B9D80011
X-HE-Tag: 1774022240-699200
X-HE-Meta: U2FsdGVkX18AMy3IpmeWug8x+y9pdpxeCDvGVUwFNl2H92VWcWzdm3YuQbq6r+FamkUCivt5JcNe5UOzkHF0EO0R29J1oTQPjhccWIaJqJKLRETVJ0CeCnhFj+wlsijq26Ye2AruT2EDhz+1/FxbLTSIuKom3rizZg58/6RufnX2AAYF1mEuQIPdGEavKo9Ua5m2B40L+AYQCqGPktI/LOjkdd939W/AjA42Hhe18k3cGB9lz1xUF0Pj6xIwjk8va+RdGmS6NpvMcI6YvFCPbTtTzd2UsmwoxAVedPIhQiy7HpcokjdLDq5IYZqT0+1TMqXM4N0W5FEkSvnj0F6UKlPohbp4l7eYAs+eAbRacMgTYQtNvLejWMwXcziOxdd/KixBwT+wpA3Lp0WewzAWyApvcUEAEwe7KayA08OFOidoO/Xc+1YWRrNKOVAMVYzyyQpuxGl4BF3iIdrKVRN5iQ+jVoUJuCxwuntmevyWanzAwaZN6voUbtUc4lg0bmVK+OdeePuJxdn9m5ggucbXpHK8c5PxfPmQhrji4OFRJpDp+gu4vT19D3uvE2RVn+uVnN2Y0x/EZhBnfQZLJe8tkpImrWfD8xWSm1Ta5wvyLKsiSu42yuTbXrnCAo1FbFfV+yxttHUuj7BxMX9164jlKhoWXOFY474Lnz9bbBRbUMrNo6oXQLusgwPpbC5EiEnVPBc9Fms+ePhWlTXl+7NnlTMYgnp+QtJevmtA2TMpIW1hpdjt1xPF93AnZjjTVTGswHNKRKKitwbV7NqrvNHk+pj+wD7uaj4ZPS6bvNoTxYShID50vOR2LZA+GcB3453PDSI7u+KTFMN8gXGhPIvZdW9ym6heqbvb9nhjwm3XopYqhdRFEfy9ku184dvOj1IHxv5Hnz9WW/JNB8TPQnIR03NzBR/fJqauSlpzkIb6CSpV6Yu0Nt25Y5XF1nelymqnews4HLabKRenGcLzTl6
 jmsMVwg6
 zd2yuoehEyMcFmaIsxksaUZIc2RdIWFiz9hyXoHlXuAKMMKnaTqTW6OyEiLlpcAGcuNcnE0bksBw3yxSFqLjlYTqD/cay1gbmMqMA2gzxk7DE2OVCahvkep+wC5BjoTT9JwzCIeZF2aBxxTfxptSrH43NlrZ6TWpOJ965LTEH0jEpGJ0uTNi6WUfietwIvbUYiiNbyM0Gw6+fh+DPtm4d/WIke+tLtlhMrpZoweOKb/iBwn9jbPN2C0YW4IOvpunnBBLtESxn6umHyjTj3wXZHNpUatghrYHxDbFF0yYjAP5bJxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 11:03:19PM +0100, Aleksandr Nogikh wrote:
> The load_segments() function changes segment registers, invalidating
> GS base (which KCOV relies on for per-cpu data). When CONFIG_KCOV is
> enabled, any subsequent instrumented C code call (e.g.
> native_gdt_invalidate()) begins crashing the kernel in an endless
> loop.
> 
> To reproduce the problem, it's sufficient to do kexec on a
> KCOV-instrumented kernel:
> $ kexec -l /boot/otherKernel
> $ kexec -e
> 
> The real-world context for this problem is enabling crash dump
> collection in syzkaller. For this, the tool loads a panic kernel
> before fuzzing and then calls makedumpfile after the panic. This
> workflow requires both CONFIG_KEXEC and CONFIG_KCOV to be enabled
> simultaneously.
> 
> Adding safeguards directly to the KCOV fast-path
> (__sanitizer_cov_trace_pc()) is also undesirable as it would
> introduce an extra performance overhead.
> 
> Disabling instrumentation for the individual functions would be too
> fragile, so let's fix the bug by disabling KCOV instrumentation for
> the entire machine_kexec_64.c and physaddr.c. If coverage-guided
> fuzzing ever needs these components in the future, we should consider
						     ^^

Please use passive voice in your commit message: no "we" or "I", etc,
and describe your changes in imperative mood.

Also in the comments below.

> other approaches.
> 
> The problem is not relevant for 32 bit kernels as CONFIG_KCOV is not
> supported there.
> 
> Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> Cc: stable@vger.kernel.org
> ---
> v2:
> Updated the comments to explain the underlying context.
> 
> v1:
> https://lore.kernel.org/all/20260216173716.2279847-1-nogikh@google.com/
> ---
>  arch/x86/kernel/Makefile | 10 ++++++++++
>  arch/x86/mm/Makefile     | 10 ++++++++++
>  2 files changed, 20 insertions(+)


./scripts/checkpatch.pl /tmp/current.patch 

...
 
WARNING: The commit message has 'stable@', perhaps it also needs a 'Fixes:' tag?

> 
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index e9aeeeafad173..41b1333907ded 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -43,6 +43,16 @@ KCOV_INSTRUMENT_dumpstack_$(BITS).o			:= n
>  KCOV_INSTRUMENT_unwind_orc.o				:= n
>  KCOV_INSTRUMENT_unwind_frame.o				:= n
>  KCOV_INSTRUMENT_unwind_guess.o				:= n
> +# Disable KCOV to prevent crashes during kexec: load_segments() invalidates
> +# the GS base, which KCOV relies on for per-CPU data.
> +# As KCOV && KEXEC compatibility should be preserved (e.g. syzkaller is
> +# using it to collect crash dumps during kernel fuzzing), we could either
> +# selectively disable KCOV instrumentation, which can be fragile, or add
> +# more checks to KCOV, which would slow it down.
> +# As a compromise solution, let's disable KCOV instrumentation for the
> +# whole file. If its coverage is ever needed, we should consider other
> +# approaches.
> +KCOV_INSTRUMENT_machine_kexec_64.o			:= n
>  
>  CFLAGS_head32.o := -fno-stack-protector
>  CFLAGS_head64.o := -fno-stack-protector
> diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
> index 5b9908f13dcfd..ea3a31b54e49e 100644
> --- a/arch/x86/mm/Makefile
> +++ b/arch/x86/mm/Makefile
> @@ -4,6 +4,16 @@ KCOV_INSTRUMENT_tlb.o			:= n
>  KCOV_INSTRUMENT_mem_encrypt.o		:= n
>  KCOV_INSTRUMENT_mem_encrypt_amd.o	:= n
>  KCOV_INSTRUMENT_pgprot.o		:= n
> +# Disable KCOV to prevent crashes during kexec: load_segments() invalidates
> +# the GS base, which KCOV relies on for per-CPU data.
> +# As KCOV && KEXEC compatibility should be preserved (e.g. syzkaller is
> +# using it to collect crash dumps during kernel fuzzing), we could either
> +# selectively disable KCOV instrumentation, which can be fragile, or add
> +# more checks to KCOV, which would slow it down.
> +# As a compromise solution, let's disable KCOV instrumentation for the
> +# whole file. If its coverage is ever needed, we should consider other
> +# approaches.

Instead of repeating this big comment block, just say something along the
lines of:

# See "Disable KCOV" comment in arch/x86/kernel/Makefile

> +KCOV_INSTRUMENT_physaddr.o		:= n
>  
>  KASAN_SANITIZE_mem_encrypt.o		:= n
>  KASAN_SANITIZE_mem_encrypt_amd.o	:= n
> 
> base-commit: f338e77383789c0cae23ca3d48adcc5e9e137e3c
> -- 

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

