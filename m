Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0EE2C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 21:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AA5C6B007B; Thu, 30 Jul 2026 17:26:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B376B008A; Thu, 30 Jul 2026 17:26:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A026B008C; Thu, 30 Jul 2026 17:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41C106B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:26:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB01F1C0222
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:26:52 +0000 (UTC)
X-FDA: 85046727864.20.A823AB4
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id 59AE7C0002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:26:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="hzwLx8/N";
	spf=pass (imf10.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785446811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/UfwfMQb84HOLsF5rxaMcowx7tLIOiJ1m0KFTpO5g5k=;
	b=rLXcu6ZM0uKLDNvFtD+qzE7yXVddT8n7P93CSJ7av2LhNmWg3fMeLZ9qVKBE12FZF4g+Kg
	tPdf5vddZpxSONnJatpX1TQuI90WDrRUX5tUxuN2UJ0T7RHP/2J7fy4RPNcYkzwaypAbXs
	MJOaLnOFShy93yohs7HlUtN9od93Pa4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="hzwLx8/N";
	spf=pass (imf10.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785446811;
	b=dj1OPJosXpKzv45+YI0Na6pKa4d6inVGutiIwZvF+uC5EUYILedSMyM/a/H+3STyMoyVjg
	daS4RcmgAJGVe2pbAgxBM819w5o7wx/FYGlHzjvlm+CDgIuV7aVfpKW1tdbHDEcrKhA3v3
	3J4pJBeKGVwMkC66aNIBFnwBDWlIZiU=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A246440E014C;
	Thu, 30 Jul 2026 21:26:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id z5j5ovdkJOp4; Thu, 30 Jul 2026 21:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785446792; bh=/UfwfMQb84HOLsF5rxaMcowx7tLIOiJ1m0KFTpO5g5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hzwLx8/NxVyYc2ZU91vSepHfJ0kTKRdNfB/swQ/gtxoViqb+9nhMeHFve2yG3EBsK
	 LpbyVCmZ4sVijqY4pseFE1/yhEIkJgiR1/pwKNBs+BYz+nFgGCrLBHkPsiyHKfFMTB
	 XXD5ZYP1q7HmB7sjOHrD/0dlfTtZJ3+qZLd1glMTKCQiO9Aac46JIgfLN0JPLJeFPy
	 LSVlbV915O0ojrU8eSpiW1wFdtus37f7nhtvXOrhzPTOt5ISd/y/WjSOousRgwamhD
	 CPG5J+1r1aDXvhL6ca2xSyDO41neVbc5+5GEgYPOflquh0YsWaCqUbRq5VVXSkSQsd
	 Y75vKiqBd0MpL/FX90z5aq1nBxXK0wsozBkgZ/Ptk/WFQDj5dfSOTGJwDqB+1aIhLK
	 0pyoalk+evpySz2wtUc+i1eH/n6gfRQlPA72tVN3hUs47DXNicflwqKkYizFS/D1tf
	 TWAW3jh61wYYLITD6XSGtKGAzyR4Eh/IcQfZCxwbGvcp63Ak9lgiY2/1KQQF9Isp4E
	 02+zXHfY0gUctcekGRIGtJn6IQkZmQ0AKhXeDCpiIPy5oxQnfFcBrTFW6Uwg6OxYIh
	 lLnw1dwxnA39WkcTmJuHBZoZp4JhhOyuxmDOKlV4P0b7Guh8n1ULhqInzVXGW3C5lf
	 Tc3NoQnoTLaM3cJ9gTbSCz5A=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0FF2740E00C4;
	Thu, 30 Jul 2026 21:26:16 +0000 (UTC)
Date: Thu, 30 Jul 2026 14:26:13 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>, bpf@vger.kernel.org,
	kernel-team@meta.com, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 5/5] x86/cpu: Don't reset boot CPU cpuinfo in
 identify_cpu()
Message-ID: <20260730212613.GJamvBdRJ5H98hTWS8@fat_crate.local>
References: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
 <20260704002046.3859585-6-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260704002046.3859585-6-ihor.solodrai@linux.dev>
X-Rspamd-Queue-Id: 59AE7C0002
X-Rspam-User: 
X-Stat-Signature: ukmt3iu8dx7kyfz7jwzwafcxi5yrpdxg
X-Rspamd-Server: rspam04
X-HE-Tag: 1785446810-89096
X-HE-Meta: U2FsdGVkX19pH3bjLf9y8dw9RtbKwRtMKA84NumO5nXhLVac3OjBUWjffB50Pth+K8RPJzls2vKvz1mK0UICuAczxetY2NDXPP8G51e3tj1mvmfyaOA/VlFk71GrnGWGTmTfRmgtRKKFdZMXK/f9UijBkgxn0+NYaMdwVLuWreH5TGEvNJyeyyqwuortOVSMu71F7fO23bMJpyDBO9reN2aqkyGahtSGXcfsJwrIsXdTS+xBOHZP6foFFbKS5YqpPpcyL0qlz8iLrNMbxED+UmMoYBuHqM1rLbIDDJBCkGr3FSG6P03ZALT1RtPpddiRS+5C9/9HeRkp2sA4yZ4fMK9psg3ykJsKnOtPCc8jA3qKOkXGUjG2bxMupC14iEyhrPqNQwgGJ58tfwwYyCwaPU+fHplY6MnxR9ZaOfHvPsABkNedE4Dmcd5TAdluOHguEaW/UPl3RuxtyC/sBii6ZSEoWTSRgvGxeGrsP437TnSESNbcPUe+jBQPy+AkhzkamQb4+1l+i4pfZ28fe5/BFmyJI/+Ax7evAfBg/1SosFF8LR2GIVsB1+82fWEz/2BR4LHqEDADxBrpQ5mGDzc8J92Kq115+fYY+TyxgpNKwCqh7UyeDKemWLQLJoD7NPBg24mteC2T2EpGpxGw5b1Rxf7i4ZsyyjaFCKp516lEFhWEhxqjx4vAoZPY2cqFTmF0z92Uy9nAOB6wqD4DwLKgLGNOPrntPSIKmR21GH0nV5zmftzVlwClxTxSp9opNXtyXHfYx+G/fw4pBFDjp/NagP/GFVNDVBPlFmcJeqFnE5mToZSOupVDLDL0g6JQ3axHLf96CblJz3IJa2JZTBStED/2ItkHiZcRs6yl4asugptVI/rzA99voBlCmKplym+JB+jkhle/BS96Z/HUdOldz5qBPmlWAUOI9AJoxYl/OARZc9cKgZgJCuH0IgywxXnObPm5W6qfTiuGEjdpxKE
 GR66Lo7V
 vXAa9L9viaLLC2mUuyAgTQoJNr1VtsNs/OSwBPM9MM9/vhl7ehcx2hhSvmN6tNnL9zfpOLqI2u8efs8UK0jpXeVQyNAhy2VaFldzVKeqoDKbrgKVuw7hM5fuXX6yFH1J9BiRYZQBPe9V2BWuTF9rOGwMJvQ61rsv8WnTG1Q6yxZ40YivBS8LRfaciNEfVazWZ5/iowHFHjcSOSgEkRkCry0PZHSW8Eu6WWc+nMatVgPlTsKfFBjtMRDw0MDdkLdPUW5S/3hRp6mOS00F95EPqU5/VF6+v2nCFWW7MBaBRbO7MJkZwQhN4yBMwigJOWeR7sxDF5WzMMwwzh87Z19KGVi5uAQhQXQhD6+2+mg/t0OR1tsXDxBMLwOLKD8Hn4hWcn9LEn0tDSRiQsBJZG34nT1CIXJqDoLYhNU3oqHDEqB3WGQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 05:20:46PM -0700, Ihor Solodrai wrote:
> identify_cpu() used to rebuild c->x86_capability from scratch:
> init_cpu_info() memsets the capability array to zero and
> identify_cpu() then re-reads CPUID. On the boot CPU identify_cpu()
> runs after local_irq_enable() and before alternatives are patched. An
> interrupt delivered in the window between the memset() and
> get_cpu_cap() therefore will observe cleared x86_capability [1].
> 
> However the boot CPU's capabilities have already been scanned, with
> interrupts off, by early_identify_cpu(). So move the init_cpu_info()
> call out of identify_cpu() into its callers, and skip it for the boot
> CPU on 64-bit.
> 
> Secondary CPUs call init_cpu_info() then identify_cpu() from
> identify_secondary_cpu(), with interrupts off, exactly as
> before. 32-bit still resets in identify_boot_cpu(): it relies on the
> reset for the no-CPUID cpuid_level default.

Ok, this commit message is all over the place. Please structure it something
like this:

1. Prepare the context for the explanation briefly.

2. Explain the problem at hand.

3. "It happens because of <...>"

4. "Fix it by doing X"

5. "(Potentially do Y)."

And some of those above are optional depending on the issue being
explained.

Also, do not talk about what your patches do - that should (hopefully) be
visible from the diff itself. Rather, talk about *why* you're doing what
you're doing.

In the patches where you do only mechanical movement, add

"No functional changes."

to the commit message to denote that.


> [1] https://lore.kernel.org/bpf/20260610175651.647515-1-ihor.solodrai@linux.dev/
> 
> Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
> ---
>  arch/x86/kernel/cpu/common.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 8f093c6c7ccc..cd3d7c37c174 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1986,8 +1986,6 @@ static void identify_cpu(struct cpuinfo_x86 *c)
>  
>  	c->loops_per_jiffy = loops_per_jiffy;
>  
> -	init_cpu_info(c);
> -
>  	if (!cpuid_feature())
>  		identify_cpu_without_cpuid(c);
>  
> @@ -2156,6 +2154,13 @@ static void identify_cpu_32(struct cpuinfo_x86 *c)
>  
>  static __init void identify_boot_cpu(void)
>  {
> +	/*
> +	 * The boot CPU's capabilities were already scanned in early_identify_cpu().
> +	 * However 32-bit still needs to init_cpu_info() here for the no-CPUID
> +	 * cpuid_level default.
> +	 */
> +	if (IS_ENABLED(CONFIG_X86_32))
> +		init_cpu_info(&boot_cpu_data);
>  	identify_cpu(&boot_cpu_data);
>  	if (HAS_KERNEL_IBT && cpu_feature_enabled(X86_FEATURE_IBT))
>  		pr_info("CET detected: Indirect Branch Tracking enabled\n");
> @@ -2178,6 +2183,7 @@ void identify_secondary_cpu(unsigned int cpu)
>  		*c = boot_cpu_data;
>  	c->cpu_index = cpu;
>  
> +	init_cpu_info(c);
>  	identify_cpu(c);
>  	identify_cpu_32(c);

Also, when you look at the final version, do you see how identify_cpu() and
identify_cpu_32() are soo close together so that you can basically move the
body of identify_cpu_32() to the end of identify_cpu() and then you don't need
that helper either.

Other than that, the flows do look better. 32-bit still needs dealing with the
no-CPUID case but that's for another day. I can't really find it in me to
care, actually, 32-bit needs to go away and we'll simplify a looot of code. Oh
well.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

