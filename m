Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2278CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 19:31:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B2718E0006; Tue, 16 Sep 2025 15:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48A408E0001; Tue, 16 Sep 2025 15:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C70F8E0006; Tue, 16 Sep 2025 15:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 279C88E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:31:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9F4C586B2
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:31:11 +0000 (UTC)
X-FDA: 83896106742.14.7F8D91E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 38FB3180008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:31:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AlDQEdc0;
	spf=pass (imf16.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758051070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0xFsZI8OPS+4kV2H8RyqcgVFs/zzzOZHJrs+93uaEC4=;
	b=5CLlg2LtRCrogN9XY6hYQOSlSVf49/RMTllSInHWc1FbRXufGrxYoVNScjjh4byhLuIXY3
	/ln8XlKIrCXi3UojG+Yz3WO6cEQli8shbAxbIJKyqEy/+uS8DXWEFYH6VC4vskDrWkgWiD
	OxNSUloAlZ3MSA51s6fBH5FLlW3zJS4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AlDQEdc0;
	spf=pass (imf16.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758051070; a=rsa-sha256;
	cv=none;
	b=39IkP40CkQNo9TG0i3qgR9vragTpyiIxEgJm6LRWNn31qOsaoXhH1+YMcVgtGKzbsU0UkD
	KnvrwQbV8UBrq89dyjjuOCv/V39HaSCQzHcHjOWizbMkkafZUjvPEzxzl6Le4o1YDks3Ae
	qk/GQEGbp1FO/P7PLmcZJLZNKLus3Cs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 79715601B3;
	Tue, 16 Sep 2025 19:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1697BC4CEEB;
	Tue, 16 Sep 2025 19:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758051068;
	bh=N49H9fou0UCpbCTf6jTtg2kx/FPk8dM2Ik20j+Oj/oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AlDQEdc09HmzC/9s1VCr8wF2BT2hvOdmrkUyhzvIQqlAdft1VDLtl5Ho1w4XzEihL
	 8FGJo8hZJnyWVj0xRfE84U6wZ50Ji1FWF+kZ1o7PtJLb3HxZOmvfU7pbErjFyG4LcX
	 Un2pOqeAhX5/Nn8T6HjAhV0AJ3hcopqnycaRB0hYiOwkKKC/qSHYy/WV4avw/wisrX
	 Uf0mKamMoW34VAyRsuzsrBK/Wp5Zx917SXGKep2jYh7TGbuG2kJpj+fTFWwm56S9Fi
	 uUTNIADkGV6RBGXVj0H+wNvDPN7Bx40u5EdY9iqS4wj9VEJTUW33iP//U0nT2wTVE4
	 DnbICveY3izOw==
Date: Tue, 16 Sep 2025 20:31:00 +0100
From: Will Deacon <will@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com, corbet@lwn.net,
	catalin.marinas@arm.com, akpm@linux-foundation.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v7 1/2] kasan/hw-tags: introduce kasan.write_only option
Message-ID: <aMm69C3IGuDHF248@willie-the-truck>
References: <20250903150020.1131840-1-yeoreum.yun@arm.com>
 <20250903150020.1131840-2-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903150020.1131840-2-yeoreum.yun@arm.com>
X-Rspamd-Queue-Id: 38FB3180008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qq377s1k6xyzbhgzzyc5mzs7o6cdym3x
X-HE-Tag: 1758051070-124230
X-HE-Meta: U2FsdGVkX189KJbZ8YVpMFFgXSk5AOuUHrCt5nCurBVPsK8RKwFBhSj1+hoe5MdMrH2TXLA+OBDemlRSAEkcmchnW87OTa5KAJztPFFIfHHZvZ81ele4mqclQSeIPv/zcfFrlxcaBvEZPg3RtdlG34ihp43iGHTTpZMrWn9kbY8ycGGX7XOqenU88AvU5tp56H4WOa9bBGUczmd6lIJLgnawkksi6qBGaPq1xgH+f+Qw5FDwfvTpZItds7VGVgeAkAz8BDnOrtN7ns82CqifgSu1MovfJb+m6M1YuuAqVdP8HGtBVmnfauqbSM3e6rTbCRP/rdiIqjgloUFjZLypmj/vlpkjjWbrwbp+h24gpjWTR6tc1oQyCIZDnS8CB7tqIXiFHPJxtO65yBLtJ+pF+VIXxIlJ+Qv4F35ph2IgM0oRyUMH8ErLgseCmGl8JPEllt+WK5BoHyyw3cWqm+9R3izb99QS+QUDEK0rBVtGZMsZdgdVmvN5Ww/ooi5HIRHWVASJ6UWxQP8kPpSsRt6oJHGHNE9CArN/jyjul/YMiC5alZnIm2rZXcDlwqp7x3U7NRT5K8byKgRD0lMPTVjqu908yGIPlTNmp5hzaENH0VNkxwZDnqsxUKP5HKkO+nJHK9HBONidJH/i/JLnaJ/kvmN91QlHMBnBiAohaqfiHREUD4Ev9+aB8zZZZ7JxzeAuNitCEHgqopsMdOIBTcz7rEgr6qU2Rnqr+aOo9Lwqc40gQQrYelAiYS8DLewMpICM7XbwhSebgvYDNAldYx1++beE6B3NFBzBn12XsRoz+rzTyK+f5RUx3wjuDlDPdBs5deTep9NrtwC1aiKZyHq2O+Q0XH4rE8h6o49qX/KxgEI22k8u436ESav/Qn3Izr6dzw4AHvZ60rewF+UJ4b4tFha9iX2+G19bq1iHI3YyD62JHsS6XV6YxtmUZK2kdev5BNwwZQdPhqoKLywbNp6
 +ydvsJaW
 FFgkIU5DVry5xlXw7vtp4/tg/aH/5VBxFOT3CUIjNWuXifGVQMS8hXkRClM9qnS/lBzSeXp3poQ39+OR1N6JbuDb2ymdhXKB1oTfslIAGm0WnUPPWPePf14AyPXs6Yu+CzdaIKhzuB21Y36lG4H9v2GKiUKLFFT5bSZWbsLmH/URMzYsUr7wsP+z6cjOioSGPKEYcxofM+FEhO+KBHvz54xTG6vskht/bSPcj0qWEtbk1ow3Z5igRyd+x8IflIRdh4CVdfK4jw/mmtdXqW3W+lZ9t3oBOCJJJgxaCCdmOwXE1jBCZgZZIdHYcxkZA3zcAD1ZR8KmxiuUktl9wL4ZptAs35O9pIor0B7TTPkrUbpiRhYCLOQ9nMBm+Y/2nQ7ZWI3FpppE2Bed1CcKzjYRQKXjv+0GSb6V9l3NBUiZ/fzQuIWHmaLh70XAO61I7B1cZ3nLlFcpjMWqBizo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 04:00:19PM +0100, Yeoreum Yun wrote:
> Since Armv8.9, FEATURE_MTE_STORE_ONLY feature is introduced to restrict
> raise of tag check fault on store operation only.
> Introcude KASAN write only mode based on this feature.

Typo ^^

> 
> KASAN write only mode restricts KASAN checks operation for write only and
> omits the checks for fetch/read operations when accessing memory.
> So it might be used not only debugging enviroment but also normal
> enviroment to check memory safty.
> 
> This features can be controlled with "kasan.write_only" arguments.
> When "kasan.write_only=on", KASAN checks write operation only otherwise
> KASAN checks all operations.
> 
> This changes the MTE_STORE_ONLY feature as BOOT_CPU_FEATURE like
> ARM64_MTE_ASYMM so that makes it initialise in kasan_init_hw_tags()
> with other function together.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  Documentation/dev-tools/kasan.rst  |  3 ++
>  arch/arm64/include/asm/memory.h    |  1 +
>  arch/arm64/include/asm/mte-kasan.h |  6 +++
>  arch/arm64/kernel/cpufeature.c     |  2 +-
>  arch/arm64/kernel/mte.c            | 18 ++++++++
>  mm/kasan/hw_tags.c                 | 70 +++++++++++++++++++++++++++++-
>  mm/kasan/kasan.h                   |  7 +++
>  7 files changed, 104 insertions(+), 3 deletions(-)

[...]

> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 9a6927394b54..d5b5fb47d52b 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -41,9 +41,16 @@ enum kasan_arg_vmalloc {
>  	KASAN_ARG_VMALLOC_ON,
>  };
>  
> +enum kasan_arg_write_only {
> +	KASAN_ARG_WRITE_ONLY_DEFAULT,
> +	KASAN_ARG_WRITE_ONLY_OFF,
> +	KASAN_ARG_WRITE_ONLY_ON,
> +};
> +
>  static enum kasan_arg kasan_arg __ro_after_init;
>  static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
>  static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
> +static enum kasan_arg_write_only kasan_arg_write_only __ro_after_init;
>  
>  /*
>   * Whether KASAN is enabled at all.
> @@ -67,6 +74,9 @@ DEFINE_STATIC_KEY_FALSE(kasan_flag_vmalloc);
>  #endif
>  EXPORT_SYMBOL_GPL(kasan_flag_vmalloc);
>  
> +/* Whether to check write accesses only. */
> +static bool kasan_flag_write_only = false;
> +
>  #define PAGE_ALLOC_SAMPLE_DEFAULT	1
>  #define PAGE_ALLOC_SAMPLE_ORDER_DEFAULT	3
>  
> @@ -141,6 +151,23 @@ static int __init early_kasan_flag_vmalloc(char *arg)
>  }
>  early_param("kasan.vmalloc", early_kasan_flag_vmalloc);
>  
> +/* kasan.write_only=off/on */
> +static int __init early_kasan_flag_write_only(char *arg)
> +{
> +	if (!arg)
> +		return -EINVAL;
> +
> +	if (!strcmp(arg, "off"))
> +		kasan_arg_write_only = KASAN_ARG_WRITE_ONLY_OFF;
> +	else if (!strcmp(arg, "on"))
> +		kasan_arg_write_only = KASAN_ARG_WRITE_ONLY_ON;
> +	else
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +early_param("kasan.write_only", early_kasan_flag_write_only);
> +
>  static inline const char *kasan_mode_info(void)
>  {
>  	if (kasan_mode == KASAN_MODE_ASYNC)
> @@ -257,15 +284,28 @@ void __init kasan_init_hw_tags(void)
>  		break;
>  	}
>  
> +	switch (kasan_arg_write_only) {
> +	case KASAN_ARG_WRITE_ONLY_DEFAULT:
> +		/* Default is specified by kasan_flag_write_only definition. */
> +		break;
> +	case KASAN_ARG_WRITE_ONLY_OFF:
> +		kasan_flag_write_only = false;
> +		break;
> +	case KASAN_ARG_WRITE_ONLY_ON:
> +		kasan_flag_write_only = true;
> +		break;
> +	}
> +
>  	kasan_init_tags();

I'm probably missing something here, but why have 'enum
kasan_arg_write_only' at all? What stops you from setting
'kasan_flag_write_only' directly from early_kasan_flag_write_only()?

This all looks weirdly over-engineered, as though 'kasan_flag_write_only'
is expected to be statically initialised to something other than 'false'.

>  	/* KASAN is now initialized, enable it. */
>  	static_branch_enable(&kasan_flag_enabled);
>  
> -	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s)\n",
> +	pr_info("KernelAddressSanitizer initialized (hw-tags, mode=%s, vmalloc=%s, stacktrace=%s, write_only=%s)\n",
>  		kasan_mode_info(),
>  		str_on_off(kasan_vmalloc_enabled()),
> -		str_on_off(kasan_stack_collection_enabled()));
> +		str_on_off(kasan_stack_collection_enabled()),
> +		str_on_off(kasan_arg_write_only));

It's also confusing, because now you appear to be passing the funny new
'enum' type to str_on_off(), which expects a bool.

Will

