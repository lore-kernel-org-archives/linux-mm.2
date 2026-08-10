Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C32EC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 15:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6F636B007B; Mon, 10 Aug 2026 11:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46A96B008C; Mon, 10 Aug 2026 11:30:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984236B0092; Mon, 10 Aug 2026 11:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73B7F6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:30:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08831140146
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:30:00 +0000 (UTC)
X-FDA: 85085745360.13.76DA2A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6469BC0009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:29:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QVQTE9Sx;
	spf=pass (imf28.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786375798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJHxMoAsHSsVZqOYcaAsiYvNb67TlWtmkhnQradvAgU=;
	b=aE6/MwlQtiWNnE8t6y4QzkbjCOLH/nIKpaTReplKm2quVdnGJh8s5zmMK8h9MUIpOC4lU+
	k9kXHNJxS5Sc4EWa9FAS+tb30fGiSSei+b4AHoM55XgVYjcf94oXdhOCRmsHOWip1NujX7
	VchbVsIz4l0ChcsGS1k2qo5iUsRPb6A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786375798;
	b=MHnwlE8MrY3Y2mpjNgw+j4I8OV4i8iqw0w13BSxFZ/Njvvg+VmShgehK+tDl05Mgv/sacd
	uKKtcUNlHfK3JUQuvUJBVPmxY5kG9MejRTuc3ANAi29wKlJ11X6IygCb7MXqHf+XGS8Zem
	POhqTpf9Ak4S2eopFYZUNG0CDSWYr5c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QVQTE9Sx;
	spf=pass (imf28.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id CFAE8600C8;
	Mon, 10 Aug 2026 15:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0627F1F000E9;
	Mon, 10 Aug 2026 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786375797;
	bh=eJHxMoAsHSsVZqOYcaAsiYvNb67TlWtmkhnQradvAgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QVQTE9Sx+ZOo2ET1ufSAOSNyChsbD8cKAdhf/0TXwWaeQt+616jOgS0ZYgtLxkSt4
	 PCypRg32Ftwi6LvwaukyEqGNG0GjUwIf1XlNG/jIX2aS8XYRX/h80qaHjyPSz8QB/n
	 0rNZcXY5vDjqnnwjZFpRbqvyTufeeQX5MZNJLyt9k80DXwlbBrL8dz6g8FhzH4NVhy
	 2D7A9Rk66q+8tC5aQc2kfo4qJd9nsWYT7fxE1Ih3/rDAGwUzmQkXDtZeib3DIppQyY
	 fr4odB4h0oW7q7pODzB20eeYAc/EpwbEq+4UEaNQ4JLS1LFAwPkU/O29imjhqx/IEE
	 GYkzTvZfgSpYQ==
Date: Mon, 10 Aug 2026 18:29:54 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Jan Sebastian =?iso-8859-1?Q?G=F6tte?= <linux@jaseg.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	David Howells <dhowells@redhat.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>, Coiby Xu <coxu@redhat.com>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, keyrings@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org
Subject: Re: [PATCH 2/4] kexec: add CRASH_ZEROIZE to wipe secrets before kdump
Message-ID: <annuciDaFKSHYObm@kernel.org>
References: <20260731154608.153258-1-linux@jaseg.de>
 <20260731154608.153258-3-linux@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260731154608.153258-3-linux@jaseg.de>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: qeebyq9b1nkjdhb1nfu7mwisuyzydhxq
X-Rspamd-Queue-Id: 6469BC0009
X-HE-Tag: 1786375798-247897
X-HE-Meta: U2FsdGVkX1/8s7pa0S7U19L2NfWP9aQCIsmPNQtu72k0mMpG25hx5Vi5eNqMianyYEBO9dEYXZGIyRDBCh+mrsVAVZowFyI5fDKKQPG+tHcXh96MwrXwHDB8oG6Ix9kspIgf9JC00Ue9NpoZKVpjGH5GT8I/LR1QY4FjoFjovKvD+TV3MJXrN7zxFqEQRU6+K3gW560KxwpYYAWOw6ArAZTiSAx0H9yVae6DautpuqlUid8EgamJdl6oLANvRrLJfbvpWuIzyuLFu/SAj7bfw6LVJaIXqKiCZxqRt3cYxYA+n47/FTqBqd74iJH0bDGXhI2oHti0gCPu2MvwmNZ40FGBdN8IjsWkleIIBCbuWpY7CgmqXDx65Mxx8vc6Mc73VHBkM4rNqPi5hKN5QbqmrhOnbIH5V18nn8LoKpf7vkskL1FuVs4zeen+FVcF8j9wx1wtQwplJXEM3aQdLyQHmTdOxlYK8vOD1XAlFaYLTDnvRqM6fyV9tH9NkXTuWg1NVuA36hlQq+WZ9AWC66WDnzNCmSCLrBkZEtrDls1Ta6WawemD+5jWQdSLnJPHb74YSqAcjqjSu1GArdYMhHFXSLrT12d3YC3GTbKtqsI1xvM50A4WybsmsupTzLq3dlmyT0+qaE+JHztQiJwLqVtW54o8vkgQDP27DeR7sf6yXGLpMuffOt5AIbWmyLwPqgYnDK8UTlggY1PhU++Ei/zppuQAfxmzXt6B+fxC6OP24ImmEgc6n1/sr7Nlek4BgxgyYlU8iMyGY8N7NxDJwwafOF+l2XmCW3ih7EXL1Q/QP+FcACDGoFs2wyxq5UosnzfbB2ZElVsGeTHUCu2a5Zu4k8AkCV6eSkfeKvxAfl6PDjuJxb0iN2emiJ6bQsvSDPpo579kuZjLk/zA1UKrPxG/oT+NYF82NbE96xE4Ocq5pNQQzDNmmHhvhNQtPNN6Pr91dX+/jqJaGb8Y+ZxhgLf
 Rzxcukve
 mxEBqSa/qqOsSIxGXLBfZQQPK6vZ257uTbTeBCxsxwUYRUjFDog8IdLKkLf4Y9qoij0TOn3O2NBCGx5bUOo8THTLSAMfl9wqB3SYuARZl5fUBOA7yHPkdWJMdDyldiJgD7LJs2et6SmEPuJg4+qKHWG1vyQFtc8V9EYMXZO120Jo0RnGfZl4WZaMueFPqpGjutVYl4+QHcfqADO9+E77oZ2OQ5XIU4iO5MvdMPgmmx7Z4muTWx/rBOXLcM5s9eW83iga2g+7efUYz2A6vW/b3eQGOtazxMVUV0k/yPDN1Q0xiEly9p0heBiAlTrFn4+/FvRBz30Q7ylD4rP5yOlgP4ZEGgpFoGxVWUr2aG8h1bfIKTV1t1jSIRxwX3su0FyDJbBceZ/l8T7JPdjc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 05:46:06PM +0200, Jan Sebastian Götte wrote:
> When kdump is used to capture system memory after a panic(), any secret
> keys currently in RAM end up in the dump. Add an opt-in atomic notifier
> chain, crash_zeroize_notifier_list, invoked late into __crash_kexec().
> Subsystems holding secrets can register a callback to scrub them.
> 
> Callbacks are run after machine_crash_shutdown() has already stopped the
> other CPUs and disabled preemption. Callbacks must not wait on locks,
> which will never be released.
> 
> This is a best-effort, defence-in-depth measure, not a guarantee.
> Secrets in flight on the stack, in registers, in DMA buffers, or in
> other places in memory are out of scope.
> 
> Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
> ---
>  include/linux/crash_core.h |  5 +++++
>  kernel/Kconfig.kexec       |  8 ++++++++
>  kernel/crash_core.c        | 18 ++++++++++++++++++
>  3 files changed, 31 insertions(+)

Not a request but for me 'crash_wipe' would be more intuitive than
'crash_zeroize'.

What do you think?

> 
> diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
> index bc087124cd78..5c7207c0bba1 100644
> --- a/include/linux/crash_core.h
> +++ b/include/linux/crash_core.h
> @@ -5,6 +5,7 @@
>  #include <linux/linkage.h>
>  #include <linux/elfcore.h>
>  #include <linux/elf.h>
> +#include <linux/notifier.h>
>  
>  struct kimage;
>  
> @@ -34,6 +35,10 @@ static inline void arch_kexec_protect_crashkres(void) { }
>  static inline void arch_kexec_unprotect_crashkres(void) { }
>  #endif
>  
> +#ifdef CONFIG_CRASH_ZEROIZE
> +extern struct atomic_notifier_head crash_zeroize_notifier_list;
> +#endif
> +
>  #ifndef arch_crash_handle_hotplug_event
>  static inline void arch_crash_handle_hotplug_event(struct kimage *image, void *arg) { }
>  #endif
> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index 15632358bcf7..92ab0a69c8ec 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -179,4 +179,12 @@ config CRASH_MAX_MEMORY_RANGES
>  	  the computation behind the value provided through the
>  	  /sys/kernel/crash_elfcorehdr_size attribute.
>  
> +config CRASH_ZEROIZE
> +	bool "Zeroize secrets on panic"
> +	depends on CRASH_DUMP
> +	help
> +	  Wipe secrets (e.g. kernel keyring and memfd_secret pages) on crash or panic.
> +
> +	  If unsure, say N.
> +
>  endmenu
> diff --git a/kernel/crash_core.c b/kernel/crash_core.c
> index 2b36aa9fade0..d3a7763e2759 100644
> --- a/kernel/crash_core.c
> +++ b/kernel/crash_core.c
> @@ -23,6 +23,7 @@
>  #include <linux/objtool.h>
>  #include <linux/delay.h>
>  #include <linux/panic.h>
> +#include <linux/timekeeping.h>
>  
>  #include <asm/page.h>
>  #include <asm/sections.h>
> @@ -33,6 +34,22 @@
>  /* Per cpu memory for storing cpu states in case of system crash. */
>  note_buf_t __percpu *crash_notes;
>  
> +#ifdef CONFIG_CRASH_ZEROIZE
> +ATOMIC_NOTIFIER_HEAD(crash_zeroize_notifier_list);
> +EXPORT_SYMBOL_GPL(crash_zeroize_notifier_list);
> +
> +static void crash_zeroize(void)
> +{
> +	ktime_t zeroize_start = ktime_get();
> +
> +	pr_info("Wiping sensitive secrets...\n");
> +	atomic_notifier_call_chain(&crash_zeroize_notifier_list, 0, NULL);
> +	pr_info("Done in %lld us\n", ktime_us_delta(ktime_get(), zeroize_start));
> +}
> +#else
> +static inline void crash_zeroize(void) { }
> +#endif /* CONFIG_CRASH_ZEROIZE */
> +
>  /* time to wait for possible DMA to finish before starting the kdump kernel
>   * when a CMA reservation is used
>   */
> @@ -142,6 +159,7 @@ void __noclone __crash_kexec(struct pt_regs *regs)
>  			crash_save_vmcoreinfo();
>  			machine_crash_shutdown(&fixed_regs);
>  			crash_cma_clear_pending_dma();
> +			crash_zeroize();
>  			machine_kexec(kexec_crash_image);
>  		}
>  		kexec_unlock();
> -- 
> 2.53.0
> 

BR, Jarkko

