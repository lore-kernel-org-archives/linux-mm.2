Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAA70CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 10:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FE198E0143; Sat, 25 Oct 2025 06:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5B38E0135; Sat, 25 Oct 2025 06:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EAE38E0143; Sat, 25 Oct 2025 06:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 12F298E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 06:07:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA91549D8E
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 10:07:20 +0000 (UTC)
X-FDA: 84036209040.20.376E302
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id B6A571C000E
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 10:07:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=X+lXwJdZ;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf21.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761386839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMoOUP8YPuXv/puO8vDWRWdRTtB4oFAsNjhiFeQqdvc=;
	b=W3rz9K+VgS2UCAXZNGhk2BATziyGfSkapa8/WTZ8QJO5m9v+8nSk/eF+/1YFI4y9+KwdEb
	iS3xFrgFBED+oaHAWuKMObZdh6QedCbgbqy41V4qfGMTran/sqmOjjaRL1EtYDOkXg+asb
	iD3RSXtto8o4eyUlDsVbRnUoV9RVylE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=X+lXwJdZ;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf21.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761386839; a=rsa-sha256;
	cv=none;
	b=wERSyPZmoy60Pn0llFhsb+qyoaHzBlKnQcEd9KoS4WTRgeHGofzZRTGZhtg6PkPyS3M/w3
	n4/pKjNQHru54Ofzyki+Lezs8F3QEpZUMyVMiYugg2D+ffW/EVGdzw41jYXsaARkKg7gbK
	gYIWFYTMdUt+LsX1KyAPzTnnE9UCbUc=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 2669040E019F;
	Sat, 25 Oct 2025 10:07:15 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id rKwqvsflQOVQ; Sat, 25 Oct 2025 10:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1761386831; bh=kMoOUP8YPuXv/puO8vDWRWdRTtB4oFAsNjhiFeQqdvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X+lXwJdZ/8NGNTTEMe+Kyw8cOzXcrJyGOHMk7EJJ+QScYTrklQj0nJkj3D85/4nIR
	 oUIY+B6d4uVEsmNF/WBMkld1X7lpFIPf1bhNCmDKzBOn7fZV8wzkjWIU0sXbtzOV66
	 Z+0MsuSNojWn/lfiDIaKuyoERnBfelGSSxs1uSFFzriODc3bF+0LA4aISmyDdCv7NO
	 KTu2W/cteIHMsPUrr4ZJltVcwZgBQ7UeLv9rmeiAX3FXLAMMSkCuQs4BmDZ1bjte4d
	 pLzphIXf4j8+Mw0eM4JJPCrqwqcq8/zOISUAAzn5cayIkmQzD07RAUgZQlhG8Lj1kb
	 4QkE1TtRuxeGsziudb5ANXzEnZxsCG3JuLbPkGzzBzaaAYHk3TllgZUqZsL2Fx6hwT
	 c/6txnWJiVpoNcyhZgG1LH4WIqrYyF9Dwu3QUMPmEv6NeyJqmcIy6uD1/v+DOFSsAO
	 HdkbaQ7e0U9x8tun8oF3IWrwHhfEyxCZDVtI74qZodVVfn4F/9f+JIOuPB5WwY9mBT
	 n2KlCXlJZa4zRsRcGYA6GsWbXBqE8uLJE2ANZzxSf6XQfYcio3WMiyO5hOqddQHXHR
	 8YMgG5eryRXm8zbQqHITvdxetr/Sc7B+Kwiw+zmIUYpLDTsnJrkOOjhUWyhT74CK1D
	 jzJZM4inMOprSshv5SIaNbSE=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 046E340E019B;
	Sat, 25 Oct 2025 10:06:44 +0000 (UTC)
Date: Sat, 25 Oct 2025 12:06:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, peterz@infradead.org,
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de,
	akpm@linux-foundation.org, david@redhat.com, derkling@google.com,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, reijiw@google.com, rientjes@google.com,
	rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: Re: [PATCH 02/21] x86/mm/asi: add X86_FEATURE_ASI and asi=
Message-ID: <20251025100642.GVaPyhMp4CEmsYW3xy@fat_crate.local>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-2-2d861768041f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250924-b4-asi-page-alloc-v1-2-2d861768041f@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B6A571C000E
X-Rspamd-Server: rspam03
X-Stat-Signature: fjs4nimxb7z8j7yp7kgeki14ns3wyddp
X-HE-Tag: 1761386838-749175
X-HE-Meta: U2FsdGVkX19Hy4lafwRfsWw+kKH7bmfu5MOpuhypG6NgrR2wUN7ybfrru7xRIb4MrsCvwy5DBG6AJVZyITfWZM+QwOF7qNSfxttIS3D7oo8pgEaOJPDhap/67jAAi2kjaBcREolRYq0kgvqUkatLQFHnlH8aSsPNLTMtd8WhqT7p2MlxoORA1RNXkP4Hu8G4CcyYXAda1T4Z0blyuZeyvCt1J+fU7t6YJG5iV2DsrIEr3HvSeAKm3xLxt5Tmuv1/UwfluhCeEZFI++BgVJxPQCok/KDMn45Zsgy5izf2l+gMRMrM3+yXyMSGG1l/wYgRrcO3X/GfzeOD3lVDbw74za04w+L+8+EBtozrMjy+tcy+V4FGIfQ73SkSKb9yFoVUB1dV+OSjBVnXsevL6b84H7TL1YuKl1i2EWCnB1sRUq3u5Y6cw5VzoJmGhq3UIDhYoJ2ONkLUg4Bnne/fIgK/j2X8a2mdcZu1X8I0YIE+AzKS+BibNA3dqXIfTFW54fEEgQXnI1pCDkivqaw00/BiqHoGdyIC1JrKzZLwQsxMu+KG3D0BSRm2i6obKFi/PHJINhPfddqV8gHUSgSVpdjhcTRWOQRuKKrf3J3C9fW3Fd8R0YMggpsdSpd9t7pK+JdSDBE/E1w4LRNswskBQQi2chFTjzF5r4dDXPuN7dtHdYKiJ4mQyLHpMLAAdb7npn/MyklM001vAny8x/dtbzypsGONvx6+wRQ9Um71W0BZsrX8HS1it+MGvqg8E7m132+3Y5mttSrimgQ3arAf4cGCR52NXtTrCXdWLYO+xME6frNtqbxyhJdAytUO4d84SMR9OiX6Ui+wOUMsu2fr63Eo+ZtpvEM28QTQ7rn1hQQcHvgKNJxTeVbzdKyjiryE2g9O7iXjwt2K1zxTzEatnv5sQpmwbTzVoC8nSMkFBvLtjUdOSiJfeN5yyqj3FGnmdYlf/kqu6Li8IZcUCuBZUv2
 41co9FxD
 vT1voqtVRb2FIuKbDbMAEuQ3KvfPjB6TQcURp3lsgjrLYxNr4Aufku8130lgDITNxvYEUim3dhYgOQWVLQ3AGZ9TezzHa+CCVHpDQP5nZaJ+RYp/H1wnVJtsS5aVyOWq6M7dghbMysOkAbdseSQwSH6MTgdJhJ/h2rjZCcv5cyE41YyBV3Hl5pxcQ2uLHmPYgzjQokAGEpoC5dLKOWpCjFVUyPkJr4NQ9QryGHHapjZ69gAK/v+NGKawG137RTg/uNZriXmumjGRMm9N25sonCWTpxYKoupEUQJuaiP+adS/2NA9srsepkOJItQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 02:59:37PM +0000, Brendan Jackman wrote:
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 6c42061ca20e581b5192b66c6f25aba38d4f8ff8..9b8330fc1fe31721af39b08b58b729ced78ba803 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5324,6 +5324,14 @@
>  
>  			Not specifying this option is equivalent to pti=auto.
>  
> +	asi=		[X86-64] Control Address Space Isolation (ASI), a
> +			technology for mitigating CPU vulnerabilities.

> 			ASI is
> +			not yet ready to provide security guarantees but can be
> +			enabled for evaluation.

Yeah, no need for such "temporary" statements in the help text since you're
going to have to touch it again once it becomes a full-fledged feature.

> +			on   - unconditionally enable
> +			off  - unconditionally disable

"unconditionally" as opposed to some other setting which is conditional?

> +
>  	pty.legacy_count=
>  			[KNL] Number of legacy pty's. Overwrites compiled-in
>  			default number.
> diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
> index 53acdf22fe33efc6ccedbae52b262a904868459a..32a4c04c4be0f6f425c7cbcff4c58f1827a4b4c4 100644
> --- a/arch/x86/include/asm/asi.h
> +++ b/arch/x86/include/asm/asi.h
> @@ -2,4 +2,14 @@
>  #ifndef _ASM_X86_ASI_H
>  #define _ASM_X86_ASI_H
>  
> +#include <asm/cpufeature.h>
> +
> +void asi_check_boottime_disable(void);
> +
> +/* Helper for generic code. Arch code just uses cpu_feature_enabled(). */
> +static inline bool asi_enabled_static(void)

"static" because? There will be a dynamic one too?

> +{
> +	return cpu_feature_enabled(X86_FEATURE_ASI);
> +}
> +
>  #endif /* _ASM_X86_ASI_H */
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 4091a776e37aaed67ca93b0a0cd23cc25dbc33d4..3eee24a4cabf3b2131c34596236d8bc8eec05b3b 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -499,6 +499,7 @@
>  #define X86_FEATURE_IBPB_EXIT_TO_USER	(21*32+14) /* Use IBPB on exit-to-userspace, see VMSCAPE bug */
>  #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
>  #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
> +#define X86_FEATURE_ASI			(21*32+17) /* Kernel Address Space Isolation */

I think we really will need to show this in /proc/cpuinfo as it is a real, big
feature which gets proper kernel glue vs some silly CPUID bit.

IOW,

#define X86_FEATURE_ASI			(21*32+17) /* "asi" Kernel Address Space Isolation */
						      ^^^^

Not sure, though, when we should make it an ABI - perhaps once the whole pile
has landed...

>  /*
>   * BUG word(s)
> diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
> index 5b9908f13dcfd092897f3778ee56ea4d45bdb868..5ecbff70964f61a903ac96cec3736a7cec1221fd 100644
> --- a/arch/x86/mm/Makefile
> +++ b/arch/x86/mm/Makefile
> @@ -52,6 +52,7 @@ obj-$(CONFIG_ACPI_NUMA)		+= srat.o
>  obj-$(CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS)	+= pkeys.o
>  obj-$(CONFIG_RANDOMIZE_MEMORY)			+= kaslr.o
>  obj-$(CONFIG_MITIGATION_PAGE_TABLE_ISOLATION)	+= pti.o
> +obj-$(CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION)	+= asi.o
>  
>  obj-$(CONFIG_X86_MEM_ENCRYPT)	+= mem_encrypt.o
>  obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_amd.o
> diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
> new file mode 100644
> index 0000000000000000000000000000000000000000..8c907f3c84f43f66e412ecbfa99e67390d31a66f
> --- /dev/null
> +++ b/arch/x86/mm/asi.c
> @@ -0,0 +1,28 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/asi.h>
> +#include <linux/init.h>
> +#include <linux/string.h>
> +
> +#include <asm/cmdline.h>
> +#include <asm/cpufeature.h>
> +
> +void __init asi_check_boottime_disable(void)
> +{
> +	bool enabled = false;
> +	char arg[4];
> +	int ret;
> +
> +	ret = cmdline_find_option(boot_command_line, "asi", arg, sizeof(arg));
> +	if (ret == 3 && !strncmp(arg, "off", 3)) {
> +		enabled = false;
> +		pr_info("ASI explicitly disabled by kernel cmdline.\n");
> +	} else if (ret == 2 && !strncmp(arg, "on", 2)) {
> +		enabled = true;
> +		pr_info("ASI enabled.\n");

I'm not sure about those pr_info()s. When it is disabled, you can clear
X86_FEATURE_ASI so you won't see it in /proc/cpuinfo and then it is disabled.
And the same when it is enabled.

> +	} else if (ret) {
> +		pr_err("Unknown asi= flag '%s', try 'off' or 'on'\n", arg);
> +	}
> +
> +	if (enabled)
> +		setup_force_cpu_cap(X86_FEATURE_ASI);
> +}

Not an early_param() ?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

