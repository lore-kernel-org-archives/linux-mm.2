Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C846CF4198B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 12:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11D326B0089; Wed, 15 Apr 2026 08:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F42E6B008C; Wed, 15 Apr 2026 08:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0098B6B0092; Wed, 15 Apr 2026 08:02:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E45296B0089
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:02:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B8FB8B746
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:02:57 +0000 (UTC)
X-FDA: 84660653994.07.F3B5C48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id AB8194000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:02:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dDqaIIub;
	spf=pass (imf17.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776254575; a=rsa-sha256;
	cv=none;
	b=cncLY7+EqVVKoBDyqHOeRHpVDmp52gvj7l+QDTbU5YFQeWl/XluyI1yInDUiFtHn/5/IQy
	6Wus6DSHXHDj11MHEHIGjCvdmINEm5l5AWkwWYGRdbJvD3i0CrLt+FNIA0tm3vS2xBMhpF
	DB45+w5O4SaUMLaz9DDaKXe3Y/ZsPdw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776254575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HoMaIGXyhpJEcgUNQSMOdguyei3/mYhC0SBbYHAkqzQ=;
	b=kKaStfMVayS83x5SvBHaWSxacLTuVtMZqv4AKdgRNBGr3IdJzRsFV2XRBl8iYfhQ5c5i04
	1UqhmQcFfkU7t7GsaTejAa/hU3VuI5+mP2J9mZrWaWZ9dapwPA5+4zXjAp/9hlsLcXGL+x
	TJp4sXkhZnV1Eo2ziqX/YuZZMV3Q5Dc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dDqaIIub;
	spf=pass (imf17.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71BE743FBF;
	Wed, 15 Apr 2026 12:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF24C19424;
	Wed, 15 Apr 2026 12:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254574;
	bh=eKpAfFlcF7u1s2jPRNx9CVvNstoHhkqQHcfDi4NbSzY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dDqaIIubJna8ZP2jWgq3qJm/LFyOcYl8FNtme5bdPRGBfmajV8Vx55SK8VCZ6epSz
	 cEmE81itZ5YJGUSx474OdIVgCBYgpGHw/yynmBNhQcc7t5mJctJePxrTOvzx4p3UlG
	 8wMccEaCVlKYf0eEYGMa0w6K+iJqMbOSCYmyfRth0GUKfskAOPXXTmpxOMfYGCqIhW
	 pGl+CfUmgnr3JxAGFoYl4Wy6ZR+zWSAacBk7e9Ya5h7ztpsf/6sAb6dpbOmrdSX4kd
	 +f+3UBwCTMPRRjTeDrEilwjLCuG68pDLJrLjBpe8tWNr68eGM68R0luoAlBlooJbIE
	 tFT5vDJ4aMYqw==
Date: Wed, 15 Apr 2026 14:02:51 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: Re: [RFC PATCH v8 08/10] x86/mm/pti: Introduce a kernel/user CR3
 software signal
Message-ID: <ad9-a1OtQ9HwyuzP@localhost.localdomain>
References: <20260324094801.3092968-1-vschneid@redhat.com>
 <20260324094801.3092968-9-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260324094801.3092968-9-vschneid@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB8194000A
X-Stat-Signature: d8mi6sf4ou5myfuwrkp6hg9tst7pwnc8
X-HE-Tag: 1776254575-644601
X-HE-Meta: U2FsdGVkX18kVU/FmqA07Nf/dp/mMB78M+mNGMwPwxCMfFDZxS7eYKyheR3saxV3fMNC9G2b7txjqZ1r5u01b+ulfwzWVRgNPbLT1Aw8XTDqnx8ncixYQzxGp+wxBX0JfV6Cf7Z2r0iHr7O578gAjEedJP/N3Hi3RaHNdUqIR7B9n/GgIG/3Xrxljlh/Yti8oZl98O0kwDssBRBQLNWCLOwzIcOIJxMkm+XLbV9oxiiBnn2a/qvN0ZvEIUZKHUzKn2bUyUmVZh2E+9bbZ3YBAx8KZBTRyBV4Xzo8rX9AoxurQhBe833Y5VUJYXbqNKvoFiezic+Oji7oZYeMdFWdAw5v1y11J8QWgtORByxHmzgHqrHoSUrrmwm6HL1tmM46nIW27i9Bf0F1bgvYYwTRhC3psj6p1OwletnETu1QH07JtXagXDXSsoDRUGC7KgkxjmTLh8+r8wot08tNue5IjdD8Q2C0CeDYzUl08TDJBJrCM2UwGUgZb58BKXO/oCRYp/aFzJIsojp3QtcE8cJ6dm9cv/sYyUUxq1T72BZQSV7g0hm0PAEjE0uwcHEh/hjJxpl2EwXdONTBGJqCu5TdkmEpvtJAIJVoWBVBh2WfkZ3aYb3lFDFQaSzMvgOcldusqLOcbzqlfnDrnMN0vt2fg5Z1lTbdJ7+pepXUjQAP5V3RFfHz8UPaShdATmY5SUxBZCjGqDc9vukIVLmRsOH5chz3ffcXwr/NSj3hbb14RyHl2dRtf/EGPu+9r2tyKI9FF+5tYf365Cz/tCVMh0sdoUUbON/Ue/dRO4RwiuWCgVpDEkTOiADN86vHqUm7M0OY5fW832ICCn7jy09jhcuqr24V83cg6aXasvDEsBobXTv/KreT4W5XTo81Md52y07yTrG6BgYW3/hvQJkb4HFG26iewM3nhAc1oYcTIMW41p4wk/NVXuRj4oGaDme7RmMeZn1W2YQudv3jq09ixEQ
 dGoxcfEB
 98sZayss64ylNQiOt5PL7dPtDmx9gkGKdGAwmglQ4pB9pWpUd1i3MbtfX65CHbnsi66lLxht3/NfCr518Isz36/aj/Htp8O9PtTWvUoMUlpPr/99wHxW+9PhnEkxW7oQKHg3CECcs6WXxUK1brBtobEiQd8CNR6EhVvzWmob7eQMDhiBTObqVWFtaOrcrJSbdzaY7lT+up8dqY6Wje4JKUAtf0RqfwXbF3TMtBOsUieYACQjxqIzFkO5FAUqK1UwLoHurgE2OAsI3y84nddYHiYn901KIO1VK9iF8/E5RuVNDWyjvFaK7z+CPQv9Zrp9zYErPeAW5D3Se63s/7DtNiMWPR3pFQfUy571wuC/oFLtfXVybImRlPCAXow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Mar 24, 2026 at 10:47:59AM +0100, Valentin Schneider a écrit :
> Later commits will rely on being able to check whether a remote CPU is
> using the kernel or the user CR3.
> 
> This software signal needs to be updated before the actual CR3 write, IOW
> it always immediately precedes it:
> 
>   KERNEL_CR3_LOADED := 1
>   SWITCH_TO_KERNEL_CR3
>   [...]
>   KERNEL_CR3_LOADED := 0
>   SWITCH_TO_USER_CR3
> 
> The variable also gets mapped into the user space visible pages.
> I tried really hard not to do that, and at some point had something mostly
> working with having an alias to it through the cpu_entry_area accessed like
> so before the switch to the kernel CR3:
> 
> 	subq $10, %rsp
> 	sgdt (%rsp)
> 	movq 2(%rsp), \scratch_reg /* GDT address */
> 	addq $10, %rsp
> 
> 	movl $1, CPU_ENTRY_AREA_kernel_cr3(\scratch_reg)
> 
> however this explodes when running 64-bit user code that invokes SYSCALL,
> since the scratch reg is %rsp itself, and I figured this was enough headaches.
> 
> This will only be really useful for NOHZ_FULL CPUs, but it should be
> cheaper to unconditionally update a never-used per-CPU variable living in
> its own cacheline than to check a shared cpumask such as
>   housekeeping_cpumask(HK_TYPE_KERNEL_NOISE)
> at every entry.
> 
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>  arch/x86/Kconfig                | 14 +++++++++++++
>  arch/x86/entry/calling.h        | 13 ++++++++++++
>  arch/x86/entry/syscall_64.c     |  4 ++++
>  arch/x86/include/asm/tlbflush.h |  3 +++
>  arch/x86/mm/pti.c               | 36 ++++++++++++++++++++++-----------
>  5 files changed, 58 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 80527299f859a..f680e83cd5962 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2192,6 +2192,20 @@ config ADDRESS_MASKING
>  	  The capability can be used for efficient address sanitizers (ASAN)
>  	  implementation and for optimizations in JITs.
>  
> +config TRACK_CR3
> +       def_bool n
> +       prompt "Track which CR3 is in use"
> +       depends on X86_64 && MITIGATION_PAGE_TABLE_ISOLATION && NO_HZ_FULL
> +       help
> +	 This option adds a software signal that allows checking remotely
> +	 whether a CPU is using the user or the kernel page table.
> +
> +	 This allows further optimizations for NOHZ_FULL CPUs.
> +
> +	 This obviously makes the user<->kernel transition overhead even worse.
> +
> +	 If unsure, say N.
> +
>  config HOTPLUG_CPU
>  	def_bool y
>  	depends on SMP
> diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
> index 77e2d920a6407..4099b7d86efd9 100644
> --- a/arch/x86/entry/calling.h
> +++ b/arch/x86/entry/calling.h
> @@ -9,6 +9,7 @@
>  #include <asm/ptrace-abi.h>
>  #include <asm/msr.h>
>  #include <asm/nospec-branch.h>
> +#include <asm/jump_label.h>
>  
>  /*
>  
> @@ -170,8 +171,17 @@ For 32-bit we have the following conventions - kernel is built with
>  	andq    $(~PTI_USER_PGTABLE_AND_PCID_MASK), \reg
>  .endm
>  
> +.macro NOTE_CR3_SWITCH scratch_reg:req in_kernel:req
> +#ifdef CONFIG_TRACK_CR3
> +	STATIC_BRANCH_FALSE_LIKELY housekeeping_overridden, .Lend_\@
> +	movl \in_kernel, PER_CPU_VAR(kernel_cr3_loaded)

Does this need full ordering of some sort? Like this should be LOCK xadd ?

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

