Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F4F4C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5BF6B00B1; Tue, 21 Jul 2026 04:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487136B00B5; Tue, 21 Jul 2026 04:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 350906B00B7; Tue, 21 Jul 2026 04:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09F116B00B1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:51:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8279EC039E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:51:43 +0000 (UTC)
X-FDA: 85012165686.02.67E8A13
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id 91A3120004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:51:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=jDOYsNOr;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=xZBtK6Qr;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784623901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9TwKjeZoFGEHgdNTQQols46LO/1SYqRmMIWZsa4kgQ=;
	b=EoeKqlOS5lz5OrPIt5AXujGOX4POHcVZa1NJ49EM3pJCqhoptA52QymHX6SaW5N7WqRsLH
	6Nl3wQojWCXvpKdLJDaIK81exNOa1fdD+U9dVT4omkxKevTBm6xI6Vsz7vH0J3Yyjdam8E
	hJ8HFIqt+AGq89M4bxK+mMpdTfgZalM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784623901;
	b=SE+NoAzziRIPBF9t34WNPu7SPbPap8Lj+85lrM+szT1n2q9VJKAuwjhuwHvN+TugAGn0zH
	SNPM8hxBqedhIvzSsH3sXlzdsszputCBqu0BxboYwBRAL0I+FULm2AftwjVXl5pEHrITiV
	tmOoImf+NeZAXAmVWPlKPLcIMCIcH4s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=jDOYsNOr;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=xZBtK6Qr;
	spf=pass (imf13.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Tue, 21 Jul 2026 10:51:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1784623899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W9TwKjeZoFGEHgdNTQQols46LO/1SYqRmMIWZsa4kgQ=;
	b=jDOYsNOrU1yusQhNG5aeS0V+izFL5Y2bD5K3ObzlRU7GEt91WIWtcrmhqwTeVdgbU9jgAj
	cO6xFFutXUrcQ7SEv4egvGgbxV/eMrfKG67ljoI9+JCCrxlFatL3RSUj5U5A/llWcxbC9W
	qg5R+JJQ8TaGMIemWmZ30/zGVHLEZE3MmERNWXoDnzhQNiVX6AHjwfUN55R/a5beTzX5co
	8vLOUrKiJgkGiAQDcTDHPKHgRtfipw1AAAKJwbEI2qe1F85vTu5TrHl7lFMPwIv0s0HFQV
	J3sDwT1M0d59KnbTFo4CoN+teS9Wp15UtTs3rSIsk2mcgr/Mm8bz1tNyMu6b7Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1784623899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W9TwKjeZoFGEHgdNTQQols46LO/1SYqRmMIWZsa4kgQ=;
	b=xZBtK6QrcF4AbeXA19rBSObL+K9ljnWUP2jHK8XRJbfunVzvMbLbLrMMs4LQYsO2x4hN0x
	sffALUD3WomVk9CQ==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, kees@kernel.org, 
	oleg@redhat.com, luto@amacapital.net, wad@chromium.org, thuth@redhat.com, 
	peterz@infradead.org, mark.rutland@arm.com, linusw@kernel.org, ada.coupriediaz@arm.com, 
	kevin.brodsky@arm.com, yeoreum.yun@arm.com, anshuman.khandual@arm.com, 
	james.morse@arm.com, tglx@kernel.org, broonie@kernel.org, pengcan@kylinos.cn, 
	ryan.roberts@arm.com, liqiang01@kylinos.cn, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v17 15/15] arm64: vdso: Expose sigreturn address on vdso
 to the kernel
Message-ID: <20260721104810-0a8ab042-2705-43e8-90d2-74e221f3fab5@linutronix.de>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
 <20260721081858.1169276-16-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260721081858.1169276-16-ruanjinjie@huawei.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 91A3120004
X-Stat-Signature: zsschemth6fxfuy1jxj5gdz5fepig4pb
X-Rspam-User: 
X-HE-Tag: 1784623901-634724
X-HE-Meta: U2FsdGVkX19nw5Z8gKDgdwDnGuVsfa1HvcSJi1eatk+IXs1uMNZ9dYIUAh2MSJZRaH5UPfXp4X4T2hB2RAP7DFKMvnBXxX96YgRgOEpIQgATUdh/jKd4ymMgmjiUVP/djdk+SaIRrBZcfdU4kcHLCEAK+F716rDPBeYfFfiT2ocHmxIvDCqvaJk2EnFfSHq9kGqx66rvjmgCcwS/gOGHRsX0SFiX/fWvdJc4ZQCcPw2bNdj/7B2m64txOdIoXKmXJy01XofQB/gS0K4jgTRWGtvSDjYZ/6V+ed3aZAXiAFEVx5QgZzfdPsYPs82muRX6mnPSxI68QDB2Y2bl96F4e+5QOg9x3IHq0LcnlGZR1bKAuEgfDKIaDX0hbUjWttsDZDN7UoeF6zSWr72jCweOUiwtORocZ/BdrMuFO4j9H/D6cxdVi4W4uB6bHisN7K4bK3rXaKolTqMTtl/Xb5+C6swx7baMlB4Z0ldDY/QPiyjrII0DW5BMjo5SiWcTHMgQpgSSTki8dv8u77Z+r/ZOGiI8ilKfsHcHNLUX2O1LBiB7a3BFsK3buHAmbCukRQ1nOYBU/H97Q4vVdEhKTJ7gwy+055k9bFVhR/7MdJ1r4L1/MrEiNEbz9MNzPEfdiDFxpHYsHgfQ/f3NzCVHOew0wOC2XLe40H9EO+hA6UadlfAXgtA+eh3QJxT7S13LeTkV0C3UZNArz56V4JLK0eo6xnSMxSNE6ir5/BEgsroJuZN3tE4chTcm1JH7GpCxKBTcyWBWtYMFBGp0CrTcOTkUaNx4YqTL5Bs9rFMYqMhTl3RmLCeDyknw8r4DY+EQFthPNLWZwS0mZ6tg0/SF2+9V/kwPuIEVL+bDHskt8rRD3KocKuf355PUueFv2pkWM+w5W22YzghK2bBLGaIHuCFhniqOEn7Hn6f+QWs1XdvvD9IzYMY/HsxPNjtmy75jy4ap7hPWPfCbtZQvZhNHz/g
 Z90DKSc8
 7UDgWYBRMsnHn11u/HMPrV3vzLnxRvRIbwB8ppABdKfarbJE2K/PBSrsQDU7y/mblH80uomlqI7PtxQxp9/1o8NBOKzYxXiID2jgeIqeLLKjWzyP9XN4n7Vy2B2qfXcYsxO9rYKSYDtrJQm0++RgLfJKFyJQVG2VMjfSpHnJb9VcyAbDHyeocVa0pmQzKiLoAjCa/5MguhI6VR/mjrkps1NA77Of2BGv2oYza/dXgJYulnwQc6irVxurThmr2y7cyYqCSuQpjwv+YC7HbGVFhqN5xRL/0MywYx19LTM1ZeQOouOE0FoeicXb94aKgn1W5/vEkaGt/i+EeMVgF3nzOO/hiycbrNH4z6L2cUk5z/oHM1d9M2Jh2R/Im7i5e8bNxGN7MwSsaDgps8bRxRoRIyFk4AgR1E1kAiCf0OQ7hTv1i3cruVjGfuPtJRZn9a1am1rU7Awt3DsYQkMzn5DixXfVs50VBZNtkfoWpyQrIdlnRAPfffnKdwnKr8dYBMPUWPIv+EWFGGxl2vR4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 04:18:58PM +0800, Jinjie Ruan wrote:
> Syscall User Dispatch (SUD) must not intercept the signal trampoline
> code, otherwise returning from a signal with a locked selector may
> cause infinite recursion into the signal handler.
> 
> Provide an arm64 implementation of arch_syscall_is_vdso_sigreturn()
> to exclude these sigreturn syscalls from dispatch.
> 
> For native 64-bit tasks, check whether the current PC matches the 'svc #0'
> instruction inside the vDSO sigreturn trampoline (defined in
> arch/arm64/kernel/vdso/sigreturn.S as below).
> 
> 	SYM_CODE_START(__kernel_rt_sigreturn)
> 		mov     x8, #__NR_rt_sigreturn
> 		svc     #0
> 	SYM_CODE_END(__kernel_rt_sigreturn)

With the new label this code snippet here shouldnt be needed anymore.

> For COMPAT tasks, verify that the instruction falls within the dedicated
> 'sigpage' range, since compat signal handlers use this architecture-
> specific page (not the vDSO) for their return trampoline. This prevents
> SUD from incorrectly dispatching syscalls issued during signal return.
> 
> Suggested-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> Suggested-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Suggested-by: kemal <kmal@cock.li>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
>  arch/arm64/Kconfig                 |  1 +
>  arch/arm64/include/asm/elf.h       |  1 +
>  arch/arm64/kernel/vdso.c           | 16 ++++++++++++++++
>  arch/arm64/kernel/vdso/sigreturn.S |  1 +
>  arch/arm64/kernel/vdso/vdso.lds.S  |  1 +
>  5 files changed, 20 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index aea686dce3d5..a41d2b593899 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -86,6 +86,7 @@ config ARM64
>  	select ARCH_SUPPORTS_SCHED_SMT
>  	select ARCH_SUPPORTS_SCHED_CLUSTER
>  	select ARCH_SUPPORTS_SCHED_MC
> +	select ARCH_SUPPORTS_SYSCALL_USER_DISPATCH

From the subject and description I would not have expected this to be in here.
Split into its own patch?

>  	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
>  	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
>  	select ARCH_WANT_DEFAULT_BPF_JIT

(...)

For the rest:

Reviewed-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>


Thomas

