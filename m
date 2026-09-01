Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 656E3C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 20:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B03B6B0098; Tue,  1 Sep 2026 16:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 187B36B0099; Tue,  1 Sep 2026 16:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09DD66B009B; Tue,  1 Sep 2026 16:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB9256B0098
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:14:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F2E814051B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:14:59 +0000 (UTC)
X-FDA: 85166297118.05.868B536
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B2548C0005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:14:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bur9NIA5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788293697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f1/Jwq5+t6tQe5v6CVe+ERoBwhfQo9XFyVXChFbscQ0=;
	b=e3H17/yXQ66fN9/7Vu2RH9xFsBDbt+9xLeQ0kCdAqtEOOPWMdVAc53y+cJ3sz/fFWj4+op
	g5f8TdXDO9tQKWED1zxxxsUux7vHRq22vxAo5rj89Dx+dYqbThcXdf+3ajKnAZvaQmNWS7
	YQjXxAC2gQuZz/FZTc1zTtOGiET6z9I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788293697;
	b=LGVWnR9OqS/jobLKdSOIXhelE3yhFIsA7sCvz8/mDsHOPsB3puSU09V+BaBgqwtsndfHYE
	c7D8FpT7YaMPiv+kBoI7DbNaz6n7+3PoWwXR7OjW1LJDGpZD2cwgV9fW0nTVK+pxZPdGYh
	S3ZQOU7I4MO+hgnTexFzJaFgw/gCXTg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bur9NIA5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF20D43345;
	Tue,  1 Sep 2026 20:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C7A1F00A3A;
	Tue,  1 Sep 2026 20:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788293696;
	bh=f1/Jwq5+t6tQe5v6CVe+ERoBwhfQo9XFyVXChFbscQ0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=bur9NIA5VjZqJ3jA9kvUAsKCinpmhYAyRbr8Hb1A0OQctcuO7N9DscX1sNVWHL1V7
	 T80F+vdakutewH2IMUKIulhBeYbTt74ZvhHoMosmzBE80N+qc3JJtFqfa+UOgi4b5H
	 nhJt07pq+F5fJOJSXkLDfT4qSN/I+piV60qOEI6PAZyKdu1ycpYXmW4JdbL3YGBRSO
	 QhxKekth0A8llYBOSGx9oqJNnoi3gtqRLBPJlVRvjImiywEubcsr5hoj1xB8ayZBwy
	 q8rGlbxN+AW6qnyVN4sOrSL4v4mH+oG0IpyaHj57TG+k/Vbf4tA5+oKuV69TJt709Q
	 ed/bhiUFFcOQA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 15/17] crash: Simplify CRASH_MAX_MEMORY_RANGES
 handling
From: Mike Rapoport <rppt@kernel.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
 chenhuacai@kernel.org, kernel@xen0n.name, maddy@linux.ibm.com, 
 mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, tglx@kernel.org, 
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
 akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org, 
 pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev, 
 kees@kernel.org, thuth@redhat.com, gshan@redhat.com, jic23@kernel.org, 
 james.morse@arm.com, ardb@kernel.org, leitao@debian.org, 
 yeoreum.yun@arm.com, sourabhjain@linux.ibm.com, coxu@redhat.com, 
 tangyouling@kylinos.cn, hbathini@linux.ibm.com, adityag@linux.ibm.com, 
 ionut.nechita@windriver.com, liaoyuanhong@vivo.com, seanjc@google.com, 
 fuqiang.wang@easystack.cn, makb@juniper.net, piliu@redhat.com, 
 ebiggers@kernel.org, jbouron@amazon.com, mclapinski@google.com, 
 me@linux.beauty, graf@amazon.com, bgwin@google.com, robh@kernel.org, 
 takahiro.akashi@linaro.org, palmer@rivosinc.com, x86@kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org
In-Reply-To: <20260826092541.3905933-16-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
 <20260826092541.3905933-16-ruanjinjie@huawei.com>
Date: Tue, 01 Sep 2026 23:14:00 +0300
Message-Id: <178829364021.3691424.12328056849597833403.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B2548C0005
X-Stat-Signature: b113doq5jqce4kfjozimew7sz3qgawne
X-Rspam-User: 
X-HE-Tag: 1788293697-902137
X-HE-Meta: U2FsdGVkX18yexNB0DkRF4+1w8nD8G1Q4Z1ImjnJipkLCdyUHWfn61ZChCBUQYE8zTAWlsLr19AvjfpzU39i+nG9QQQMEhXFGSiqlgegFEfDt7XiW7qpQos2mH7dWh6o4A4Hy4PRWvIz7rxvpcS66XK1y45bX/jqLc2AKDdfx+oOkbI1kHH2SeiejKEacjtvEZNDREh9RxoqdLffax01s8iDF4E5Hy/zTZXho/2Ua2eAeuTDeRmOsk4R77capJJBCh+6i2zGrWngnM434lCgC4S3hu6+Z18Hn4kLPjFBa03diSFDXoitefC+JRVT3Nr6yn3bybAHgis1VG/eIkCbvNKM8arj+IuSYWPKZDcbdKtwcjufCVc3aPqAFeRGC0puqcTKbxYO78eOS0/+CKHMuwhCHfR1pDBKhRn95KqXBPWNofgb1okUo2EPR6g9GGhV4X2713uGOR1f0crenqDm6xfoQ7YwPRFnGF8BgXAcnradKa7KhGfgQXdj4PL7EXhg+ltdsSurK+G+k5KhoGXrsMR8XYamiVIWXV/lw73I3m86ZfTtMG0N5coa61YcQwEJR8C1oCamspwxzkkYlwrNZ9yr4ZVaq0bv8iF8a9/HGLM1ZTqeg2KukqSzVi/PqwxXw0lm0CoBUW2hWTjlRlSYyX6qw39aiLVK6QMVRThqP/dkNHqNqRHSEt9xjCWVsrmosT+f6HFMeeuMH2ph5I7sHDvThI3j8F19oZPIvpsctFVh5IEXDXf2Yoyi5bgA5Wczqg7PFHBSrwEmkS2X7cmZasExc76KBdIYUfNWGHTgMl2D751K/o225Z/YIrYZbw7F+Kl1YdnsEb0XrxuWHxVPpnTHXwJa1VWnXkPqc6rOMGxGI22KI6JJSpZMvZTfh1dPHgUM/jGsPb7YRsH3nFN3MfabwedeJYZkInp9zWYzXvuZjpGXrBd79asCZ+D6XPQM7ZwdEIDXS1S0u2eAuOn
 mDdh9cph
 8tzke8XcKDcqqbfuNGRomtrAH+sdGesWkI7dL57X7hfzEkSCvVK/3Sics9CBEzI3jQvG7hXO4VawqD2DrZWE0wlCZ+hRDQIfZNga/Mhe7JtIi2qfZemOkepedMQBuQ/l5M/MASmKWnT8ivpTVFZnWjrL3tWemHVUPpspVQ5scNng8pC+pEUeDjMAICkhxuQoLp+1UAHVqY2hPY+ZrJJL0l8QMwCABuGwL3H5o+2B4CB8OMycY7nzNpUyWlFbGPQ8z3tLgv6OcflaFTQ4G+1xtVbJDnmrf1DWufrZO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> Set CRASH_MAX_MEMORY_RANGES to 0 when MEMORY_HOTPLUG is disabled, then
> remove the now unnecessary IS_ENABLED(CONFIG_MEMORY_HOTPLUG) checks in
> powerpc and x86 arch_crash_get_elfcorehdr_size().
> 
> No functional change intended.
> 
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>
> diff --git a/arch/powerpc/kexec/crash.c b/arch/powerpc/kexec/crash.c
> index fc0105c7af4c3..c47e3f867ea1f 100644
> --- a/arch/powerpc/kexec/crash.c
> +++ b/arch/powerpc/kexec/crash.c
> @@ -474,9 +474,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
>  	unsigned long phdr_cnt;
>  
>  	/* A program header for possible CPUs + vmcoreinfo */
> -	phdr_cnt = num_possible_cpus() + 1;
> -	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
> -		phdr_cnt += CONFIG_CRASH_MAX_MEMORY_RANGES;
> +	phdr_cnt = num_possible_cpus() + 1 + CONFIG_CRASH_MAX_MEMORY_RANGES;
>  
>  	return elf64_phdr_size(phdr_cnt);
>  }
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index 99eb8583d9321..116410ac90fb4 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -407,9 +407,7 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
>  	unsigned int sz;
>  
>  	/* kernel_map, VMCOREINFO and maximum CPUs */
> -	sz = 2 + num_possible_cpus();
> -	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
> -		sz += CONFIG_CRASH_MAX_MEMORY_RANGES;
> +	sz = 2 + num_possible_cpus() + CONFIG_CRASH_MAX_MEMORY_RANGES;
>  	sz *= sizeof(Elf64_Phdr);
>  	return sz;
>  }
> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index a97ed9605602f..e6251dfe451a8 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -160,7 +160,8 @@ config CRASH_HOTPLUG
>  
>  config CRASH_MAX_MEMORY_RANGES
>  	int "Specify the maximum number of memory regions for the elfcorehdr"
> -	default 8192
> +	default 8192 if MEMORY_HOTPLUG
> +	default 0 if !MEMORY_HOTPLUG

This only sets the default, but a user can change the value explicitly.

-- 
Sincerely yours,
Mike.


