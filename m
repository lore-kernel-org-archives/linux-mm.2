Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA1E0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DDEF6B00D9; Tue, 30 Jun 2026 12:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5476B00DB; Tue, 30 Jun 2026 12:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47FD86B00DD; Tue, 30 Jun 2026 12:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6F56B00D9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:37:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67F9614055B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:37:55 +0000 (UTC)
X-FDA: 84937135710.12.B19DC11
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 43DE718000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:37:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IGK2WudX;
	spf=pass (imf24.hostedemail.com: domain of ada.coupriediaz@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ada.coupriediaz@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837473;
	b=GOwjmfzGagqdEu4tvRv/O1JAkJpesiyvF7zLXcKNDw2X4draEwuSKQS7eolpf3uorzeSeD
	Y4vYiOHcTnrNPYW+fI28vRw57l5d3z25XcuXfcr7D1Y7ZkK7suUiAuaXHaqasCGG+eX+vF
	7ORCuziZFzdyLCpwkXqptaFatxTJ7Nw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kz+SuXE9j9za15YLoAB+zy98OKmA/lb7I/FlxnUtLag=;
	b=Qudi0JIc8xHnp7k9FuKXHbWSFw57zWRblm834YtlnJwVpYtJxNfeD8otDSAGZAl5sY9CuG
	IbB4LiaaqC83934exY9SaATttkxfbYUIZmqv9VhfhXfOIIUZsdEtNBo3Qu8/6+RftypdfO
	EBiXdre6boOWKTeI8hYTeBcu0grbZUM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IGK2WudX;
	spf=pass (imf24.hostedemail.com: domain of ada.coupriediaz@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ada.coupriediaz@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8C287302A;
	Tue, 30 Jun 2026 09:37:47 -0700 (PDT)
Received: from [10.2.213.21] (e137867.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B88B3F85F;
	Tue, 30 Jun 2026 09:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782837471; bh=g58E1RgBOT17YggIpVtjm4i/yrYpROSWqIGglQToKUc=;
	h=Date:Subject:To:References:From:Cc:In-Reply-To:From;
	b=IGK2WudX+PJaEpGGXXw64zx0sjng8/eaN/Rh3Y+MvJrSMyCQKQtzGmNp6HkLRKA59
	 UH+tXBYKY5mFl0tT6enV58lfXSTXvmDvSwWLrhGO+5GYcT+gQbhYP07y57q7fZhefg
	 NWM6IkC2lsMLKtWLWUb174guV8D8FtaPJLeizbpQ=
Message-ID: <b8f3b5cd-8d8a-4396-ba0c-011a83234dd9@arm.com>
Date: Tue, 30 Jun 2026 17:37:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 01/18] seccomp: Convert __secure_computing() to return
 boolean
To: Jinjie Ruan <ruanjinjie@huawei.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-2-ruanjinjie@huawei.com>
From: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>, oleg@redhat.com,
 richard.henderson@linaro.org, mattst88@gmail.com, linmag7@gmail.com,
 linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org,
 kees@kernel.org, guoren@kernel.org, chenhuacai@kernel.org,
 kernel@xen0n.name, geert@linux-m68k.org, tsbogend@alpha.franken.de,
 James.Bottomley@HansenPartnership.com, deller@gmx.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
 svens@linux.ibm.com, ysato@users.sourceforge.jp, dalias@libc.org,
 glaubitz@physik.fu-berlin.de, richard@nod.at,
 anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net, luto@kernel.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, peterz@infradead.org, wad@chromium.org,
 thuth@redhat.com, mark.rutland@arm.com, kevin.brodsky@arm.com,
 linusw@kernel.org, yeoreum.yun@arm.com, song@kernel.org,
 james.morse@arm.com, anshuman.khandual@arm.com, broonie@kernel.org,
 liqiang01@kylinos.cn, pengcan@kylinos.cn, ryan.roberts@arm.com,
 yangtiezhu@loongson.cn, sshegde@linux.ibm.com, mchauras@linux.ibm.com,
 austin.kim@lge.com, jchrist@linux.ibm.com, arnd@arndb.de,
 thomas.weissschuh@linutronix.de, sohil.mehta@intel.com,
 andrew.cooper3@citrix.com, jgross@suse.com, kas@kernel.org, x86@kernel.org,
 linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-csky@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-um@lists.infradead.org
Content-Language: en-US, en-GB, fr
Organization: Arm Ltd.
In-Reply-To: <20260629130616.642022-2-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 43DE718000A
X-Rspam-User: 
X-Stat-Signature: qazebbxrjjyytboqpy6k7sdps6zikdca
X-HE-Tag: 1782837473-693673
X-HE-Meta: U2FsdGVkX1/VnKw2Fuws+BGUBN/ZwIa2V9jvIiDWLVlW+jC7w8diY+zVlhCGQUq3tG2wlM6FIJ9G6AaTBSYeT/ewDYh0envFeJ/M5BUm76yuB7ayY5DxmZ17RcTh7EP4U0KuwBlulHni7UJZzPgd4ACIBUyXOLXr5FPUpPZqLWMzx/Mrd3PiRtUGariEDn86vxq+VK/0/uGFlfGf6ZzwlVPGLr58Thf70+Cdte+IeFG/2uMD2R6ipKs2h/nef5rgsxL4Y1BoRHdb3bU0aDRUf94715SweY3iWz1bBmGe1QPDxd3709bYx1PTyWWyhasfIEQK5bzq32wuyrbyjN4kL1RgCaxIWgRv7qQRy+XFFzkDY6RQhxcQAI3LJ+hF1RFKWbU/3w/qcYq/UC/4I80HXiOp450tPQrBx6ZcDLX+YFVcuBOkz42j1QVV3hj/BOY8duBCEeYv+u9Wm4KEZI6drK6HijTxgnQ3wT1Y1CmS/Q166OXtUAuyPU8x6y1NXbKefOXk7pOflhwmjg9AydJMFkWR1o9pdDV/lnGiSrU/01uPCkeLRTsGjHiUPhFClRDVMrfTjRm/Bbyn24Bpo+dnr+kr/mcB3iOtAMAoskyJzntLnT+oHSnG2tUZgKnjH4DiugYB0a4tWKQF/IvTM3vCoz2EIDTuJfWZNhntFniLG/Eodr0vg/FA9qhpr2j/LhUI0AqOygPS450a/WYMkxmi/ngHjaLTC+2QzfLLWoltM9QrQfgZFarxhMs+zQPwPBQ1a7tTil/wBYODWsRLT12M9dydCB4bnvJxr2eZdUy3Oo066XHYObPu8Wt5uFMD3Du/BzJejCXWu42ip6CbRF6rjDGBS3gSUHOMofap98/IQhpjJ8NdbdcPxi8nwHzFpEfnKdRheZvp07zk7/JW7XJBKtMh9FDhRUrk6batKRBIFcPZzeeiN39EnJzSSlL3frAxZmYTF+YhkmVjDF80vCd
 gWSw3GKI
 MZMtyS/eeM4L4sH0sp2W57c8iWWuOtFvns09+008r+sJ59TR/UVCFtP0fUS27seInfWcDuQ0WCxvKorAh/28Ga1y2UF/qsZfuWyTaVtv0n5rOTHXg5Gb9VKhBxloUQYAskPEOTSjynzH4MirLruHaz20NCuGUS5Y5Bo4s6hJWilD0VQM55dmmI0doqam67PPSS6jAYRPMpw57JgVs6npClAfc5LyyTRQ7uq380TjHLCC5oaE1POqnlDFIRXxnlZgmaMMpTUm2nN0v5uz1yrr5zIPGZvjjbj4w5egDOWtj9CzWx4J4WuU+7auP6BCjgWUUS6GQBDPvxOE62Hg4tYCUd3QjK3sHhuNEkKGpD0NP1R4L5lBWXg8EMa3oSpqSCcrbMNEPxH2IGWgUn7puNJOkJZZn8Jf02KbW/edxNIJ2fyW9/88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jinjie,

On 29/06/2026 14:05, Jinjie Ruan wrote:
> The return value of __secure_computing() currently uses 0 to indicate
> that a system call should be allowed, and -1 to indicate that it should
> be blocked/killed. This 0/-1 pattern is non-intuitive for a security
> check function and makes the control flow at the call sites less readable.
>
> Furthermore, any potential future changes to these return values would
> require a high-risk, error-prone audit of all its users across different
> architectures.
>
> Sanitize this logic by converting the return type of __secure_computing()
> to a proper boolean, where 'true' explicitly means 'allow' and 'false'
> means 'fail/deny'.
>
> Update all the two dozen or so call sites across the tree to align with
> this new boolean semantic. No functional changes are intended, as the
> callers still return -1 to the lower-level assembly entry code upon
> seccomp denial.
Would it be relevant to mention that this fixes the unsound return value of
`syscall_trace_enter()` in generic entry, which motivated the patch 
initially[0] ?
> Suggested-by: Thomas Gleixner <tglx@kernel.org>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
>   arch/alpha/kernel/ptrace.c            |  2 +-
>   arch/arm/kernel/ptrace.c              |  2 +-
>   arch/arm64/kernel/ptrace.c            |  2 +-
>   arch/csky/kernel/ptrace.c             |  2 +-
>   arch/m68k/kernel/ptrace.c             |  2 +-
>   arch/mips/kernel/ptrace.c             |  2 +-
>   arch/parisc/kernel/ptrace.c           |  2 +-
>   arch/sh/kernel/ptrace_32.c            |  2 +-
>   arch/um/kernel/skas/syscall.c         |  2 +-
>   arch/x86/entry/vsyscall/vsyscall_64.c |  2 +-
>   arch/xtensa/kernel/ptrace.c           |  3 +--
>   include/linux/entry-common.h          |  7 +++---
>   include/linux/seccomp.h               | 10 ++++----
>   kernel/seccomp.c                      | 34 +++++++++++++--------------
>   14 files changed, 36 insertions(+), 38 deletions(-)

This is missing an update to the Kconfig documentation, a possible
suggestion :

diff --git a/arch/Kconfig b/arch/Kconfig
index fa7507ac8e13..9e3d40088afb 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -637,7 +637,7 @@ config HAVE_ARCH_SECCOMP_FILTER
           - syscall_set_return_value()
           - SIGSYS siginfo_t support
           - secure_computing is called from a ptrace_event()-safe context
-         - secure_computing return value is checked and a return value of -1
+         - secure_computing return value is checked and if false
             results in the system call being skipped immediately.
           - seccomp syscall wired up
           - if !HAVE_SPARSE_SYSCALL_NR, have SECCOMP_ARCH_NATIVE,

> [...]
> diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
> index 416a3352261f..3f66320e46d3 100644
> --- a/include/linux/entry-common.h
> +++ b/include/linux/entry-common.h
> @@ -100,9 +100,8 @@ static __always_inline long syscall_trace_enter(struct pt_regs *regs, unsigned l
>   
>   	/* Do seccomp after ptrace, to catch any tracer changes. */
>   	if (work & SYSCALL_WORK_SECCOMP) {
> -		ret = __secure_computing();
> -		if (ret == -1L)
> -			return ret;
> +		if (!__secure_computing())
> +			return -1L;
>   	}
>   
>   	/* Either of the above might have changed the syscall number */
> @@ -113,7 +112,7 @@ static __always_inline long syscall_trace_enter(struct pt_regs *regs, unsigned l
>   
>   	syscall_enter_audit(regs, syscall);
>   
> -	return ret ? : syscall;
> +	return syscall;
>   }
> [...]

Otherwise this feels like a more appropriate change with regards to
"safeguarding against new `secure_computing()` return value" !

With the updated Kconfig :
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>

Thanks,
Ada

[0]: 
https://lore.kernel.org/r/20260511092103.1974980-2-ruanjinjie@huawei.com


