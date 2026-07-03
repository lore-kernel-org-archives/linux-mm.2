Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25DF8C44500
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 11:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8896B00B4; Fri,  3 Jul 2026 07:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52366B00B5; Fri,  3 Jul 2026 07:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920196B00B6; Fri,  3 Jul 2026 07:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DAD06B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:13:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D03DDC2531
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:13:43 +0000 (UTC)
X-FDA: 84947205126.16.5ADAA12
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 00AAE4000D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:13:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iifCFiSs;
	spf=pass (imf07.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783077222;
	b=Bmmtc9o92rbSwIPFNp/6vmuxYI95iY/pURqkLccaaxkXkshFVLymycby+z94rbVBJ70Jkq
	qmPerpu2QPkl11MyPWGwPpiDdZeM4SkIh66RH++3xbZ35kJ30uQ/kHOMku6aEfzdefoOME
	bHbf1E2lfQrchdgQIyHPQL8qLM1eoz8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783077222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/K+DNLo6Rw5LUNC5Lpk7uYC0BgYbu/q5E/KtMAPChI=;
	b=jzFlnRbjLbQTVsdE2Vt0cYiBzMn2PfmSMHtw3OsCx2OPsLHmk5FNrJYO0tabX2FHM3hzxU
	hnLWrnrMxUqi+fPWRVp2pQuyVFjli8fVA1l3STvjFcEQG01KBUBb9qXnxRy9zZJIkFBTtx
	LNPr+Drwd9cZG4N0bty86v9vAhVFslU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iifCFiSs;
	spf=pass (imf07.hostedemail.com: domain of mkchauras@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=mkchauras@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-845c92bc464so319332b3a.2
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 04:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783077221; x=1783682021; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A/K+DNLo6Rw5LUNC5Lpk7uYC0BgYbu/q5E/KtMAPChI=;
        b=iifCFiSs7O/jOt83QvwS7kSAFv9QcX6fghMcz9ubHz0pbrShBYsU/Smo0G09jbitql
         IOuQNb5W6sUhGEFBxnKuM30Z7C3qdn8eGTKAs9X9P4B12e8QLa4kfOMbQLtup3e0QvJe
         XPXA+/dEtnjc0Gr+fgREZ0dObGnQr8EAAl4/2CKT628ZDRJqXhH24f134Y/l8++UuAKm
         V7u2I06vaq9b5RuZDIrVVfZR7eOnrurUFLmYxmRC6aVmS7J6HQrW5JILNQxU/qTVUdA/
         v/f5iuXL7CBqgyiPrzJcOJycH8UTPaMRtWmKxEqkU1PBhebDrXseAisM4JGmRMpzB4bh
         H3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783077221; x=1783682021;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A/K+DNLo6Rw5LUNC5Lpk7uYC0BgYbu/q5E/KtMAPChI=;
        b=CkKvc+tEmBaKCSwNFVv+2v+U6NjjPWkxIaDob7SBWSC/CVBqdn34/l7BM1NCkL516h
         JTufQ97wCLUxhTrzLPSKTxxdA3vaaHQTLLQMeemKhFOt71+tLyD8yglR+Dp7CqS7hpnF
         b6/Y8rnB2162ENqbitYn4A/Vi867tJXUb+7cZvN2w0cmRY7rImL+bIFXAD1hfRGQHkPO
         RcKMgyIn1SnmIRFPrmTWFP63JqNcTLwKbWsjKvUwBFxGZIDWfj4X6mlGMz18CcRfqp9R
         5U1EfL6TBL6GBNxXDS52UngnJ8vIZ2v5HXnjbZo4FwyKZYgo5xMNBDMmiixxy09SwmGe
         Z/IA==
X-Forwarded-Encrypted: i=1; AFNElJ8TwBbEzfpZegk7YxZySQwYPBTDaEswAF33CDmWdNO8Mm6MixrcAhtVvJIWRSvpUwG2whNSq5kecA==@kvack.org
X-Gm-Message-State: AOJu0YzEOfkxBG6mBjCxtXokz1b1GUy9GxRIpnoxY0mrDc3RsDnpw15s
	l9uNCICfCZyzj53rHnAV8M839n0eU/mIX+tNY/6uDEInqhAx/dNMdjKe
X-Gm-Gg: AfdE7clFY3c8GTb1qZPBbFrxHYN63wWFPeQSj6WIV7pYv58zXncrecgi4o3qJB3cd/g
	FuxHjYxPJP4ja869MeSn0FMUNlek4v/Q78BqPFVDw/osn79K8d+fRXjpMprzYe7bQtFpYFuWSBl
	8YFgpNQGBk8kVIqUwxnuH1LKa0ERvZTQT0ypdDxaTdVeHG7nkmKZmF3m5MZfhaGkmcWBxNEhxwS
	bpV1X8yTAXHhJgy371B/I6LAv7K7ZdzrPE8gi1Y61uFzxuG9HoT25ydO8cVsFP82l5wbOBInGeb
	pE/5RWRMDEABelhNOw7hEnnV2eRvb8+tkfurfw75fSje+j/yMyXEBL7iuN5ugcGJcEIXg5U3YkH
	SkOJ/HFVl79EFUWYEXHmlab0mNvNckXFjiqB5cNCtLLmFm0zqZtCJ31hnTXGk6seEPECGVnwFQC
	TPHYOMfiAb3mSFvPxZ2skuGN8Ke5Qq43Ka67C/8ho6a9YGUZ2zUDVlHeCzMxS0
X-Received: by 2002:a05:6a00:ac8a:b0:847:9c3a:b77f with SMTP id d2e1a72fcca58-847c512cab4mr8348296b3a.35.1783077220720;
        Fri, 03 Jul 2026 04:13:40 -0700 (PDT)
Received: from li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com ([106.51.160.236])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb6dc4d0sm2701298b3a.3.2026.07.03.04.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 04:13:40 -0700 (PDT)
Date: Fri, 3 Jul 2026 16:43:11 +0530
From: Mukesh Kumar Chaurasiya <mkchauras@gmail.com>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: oleg@redhat.com, richard.henderson@linaro.org, mattst88@gmail.com, 
	linmag7@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	kees@kernel.org, guoren@kernel.org, chenhuacai@kernel.org, kernel@xen0n.name, 
	geert@linux-m68k.org, tsbogend@alpha.franken.de, James.Bottomley@hansenpartnership.com, 
	deller@gmx.de, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, ysato@users.sourceforge.jp, dalias@libc.org, 
	glaubitz@physik.fu-berlin.de, richard@nod.at, anton.ivanov@cambridgegreys.com, 
	johannes@sipsolutions.net, luto@kernel.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com, 
	peterz@infradead.org, wad@chromium.org, thuth@redhat.com, mark.rutland@arm.com, 
	ada.coupriediaz@arm.com, kevin.brodsky@arm.com, linusw@kernel.org, yeoreum.yun@arm.com, 
	song@kernel.org, james.morse@arm.com, anshuman.khandual@arm.com, 
	broonie@kernel.org, liqiang01@kylinos.cn, pengcan@kylinos.cn, ryan.roberts@arm.com, 
	yangtiezhu@loongson.cn, sshegde@linux.ibm.com, mchauras@linux.ibm.com, 
	austin.kim@lge.com, jchrist@linux.ibm.com, arnd@arndb.de, 
	thomas.weissschuh@linutronix.de, sohil.mehta@intel.com, andrew.cooper3@citrix.com, 
	jgross@suse.com, kas@kernel.org, x86@kernel.org, linux-alpha@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-csky@vger.kernel.org, loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-um@lists.infradead.org
Subject: Re: [PATCH v16 02/18] syscall_user_dispatch: Introduce a weak
 fallback for arch_syscall_is_vdso_sigreturn()
Message-ID: <akeYzL3uQoxaddgU@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-3-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629130616.642022-3-ruanjinjie@huawei.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 00AAE4000D
X-Rspam-User: 
X-Stat-Signature: spy5aitzdq8uqjxwp15441i3pf3kq6iu
X-HE-Tag: 1783077221-870699
X-HE-Meta: U2FsdGVkX1/mtz+NoVwNxwh72l/+HkVaaM6fgzd/SgubOmJAOVcsWKUnY/LAa3rGTNl7hNy0LjwisaTvzCxawanMFultFTdRGKioPXUNyMtFGzGYPtlWcsbm7qjsoa7eyrsPC5WB8mNwkViezrrI1jHrswYRjOXAmyHIDgVRGo3FIlz38CrcXOiat+vkNoyJAvHXSfAj5epcxgx6RVHFsCfZz9fj6d7d7oeA7vIj2mdNsCGm/Bhr04aaGE9UsuQs7zuw2G41wqJHUaw+qOIvXYEDihEmDZM+MZ3kIOKiArI5JjXeqONvU/bfIXWATdXVeucDrAq5CxtJAnA46ORMVDrIPmsehDfK+VQ4jVVQfvCa7UYPEbYJjtIRCg4bWO27Gk2Aov7hx7G9lAuVw7tMRh9j47z+SZOZ1KLwurI5ilRq0pTjooVwissvzwi4xS9sxOasQRExDT67t2yUex7HsFhT3I+ofX20fuf5+ajaS4DQ1Oxg2b/OUAY8AWSU1+Z1e6sfaFZMGDSW8Nt6RqbBXCdI7fdP4H1xnMWRmN5pKSqatTlaWFYf8l+cRKrP+915tGA2krfaJs0tt5QOZpV0NvSJ0UUuyioKaOtkzDpXjgJO4mI4/R1MGbr4yBZ1+6tE8NJxy2L1bdnD7+XXyYj/4Pu5xUnjz66zhaW1OCjeJB4kGScy2x+2yL+jLdh+KmO51CzhONajz2DL08IHN2MyiTLMTpgOYLlCx+IPDR+GNaY6UbPhuTgrPifkpWgX6kNTJbPqpMkY3TOF0hQ5GFBpPXlcscSRaU2x7/dDRUGo8UcBtGtLK7j87imtbf4ItLFK2y4lcHLVOjMyuYpiIf6zSVOQ0tZTOs/235NQM0JOpLkt5csNhioXUT1IKb8961yHr3szjZAZ4RTtBpG/Po+c/G7vpmYIW6n64lB+JmJRDaHq5loOXjR31a7zy79wgwHPBmF7KiBE+0SFdNqjbOR
 CZ5KDOPf
 lxBWLSE2iP2KSZrPcBscLnTmTO7o/PLwzALBDJ6W4fTtyfkf1UM+2txZpOGH7m+DoSpQzlTp5WDnQzS9RdXPqNbjJCQStaU7ozFwKTgkm9qU05bQq9CgAq0hGIaqPOYy5oTCEiKSdKv7DNM0k7gZ3/3InyvmUx2/xT8lmAoW2DJe99VT6AczlWsw7Q7HtPFPCTVksYywoKy7aH8iYD2dK/mptjfdOhhr0AcHSIPlqzz9Mh9vaL+jKv7RF7N+2CXGoQYwcPxE2ukpT0IDyXpbvyOCWhpa8CpySXVAT+9LOw5w+YQviEbXtbw61xX/Im4KsLG8UCUQQ4Gd+JXUTlemFxejDzUIbyDt0/RVojCw8nrcqsl9MA7jprqvIljXayD4jbAzRRK2QhTyAuXYkffA6tOPW/uiGnnhTXUB+YziMfWk22rpNWOJnd7xzomjAXfAYkUccjka4Qmt9a+cvlaouki0SSJTgs/9o9fVW8LC7uzEJi7gsnc0G7RSwMtyqk+g/vSXz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 09:06:00PM +0800, Jinjie Ruan wrote:
> Currently, multiple architectures (LoongArch, RISC-V, S390, Powerpc)
> provide identical stubs for arch_syscall_is_vdso_sigreturn() that simply
> return false. This results in redundant boilerplate code across the tree.
> 
> Introduce a default __weak implementation of
> arch_syscall_is_vdso_sigreturn() directly in syscall_user_dispatch.c that
> returns false. This allows architectures that do not utilize a vDSO
> sigreturn to entirely drop their redundant inline definitions.
> 
> Architectures requiring a specialized check (such as x86) will continue to
> override this fallback with their strong symbol definitions.
> 
> Clean up the redundant implementations in loongarch, riscv, s390
> and powerpc.
> 
> Cc: Thomas Gleixner <tglx@kernel.org>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
>  arch/loongarch/include/asm/syscall.h  | 5 -----
>  arch/powerpc/include/asm/syscall.h    | 5 -----
>  arch/riscv/include/asm/syscall.h      | 5 -----
>  arch/s390/include/asm/syscall.h       | 5 -----
>  include/linux/syscall_user_dispatch.h | 1 +
>  kernel/entry/syscall_user_dispatch.c  | 5 +++++
>  6 files changed, 6 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/syscall.h b/arch/loongarch/include/asm/syscall.h
> index df8ea223c77b..946886794ced 100644
> --- a/arch/loongarch/include/asm/syscall.h
> +++ b/arch/loongarch/include/asm/syscall.h
> @@ -85,9 +85,4 @@ static inline int syscall_get_arch(struct task_struct *task)
>  #endif
>  }
>  
> -static inline bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
> -{
> -	return false;
> -}
> -
>  #endif	/* __ASM_LOONGARCH_SYSCALL_H */
> diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
> index 834fcc4f7b54..4b3c52ed6e9d 100644
> --- a/arch/powerpc/include/asm/syscall.h
> +++ b/arch/powerpc/include/asm/syscall.h
> @@ -139,9 +139,4 @@ static inline int syscall_get_arch(struct task_struct *task)
>  	else
>  		return AUDIT_ARCH_PPC64;
>  }
> -
> -static inline bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
> -{
> -	return false;
> -}
>  #endif	/* _ASM_SYSCALL_H */
> diff --git a/arch/riscv/include/asm/syscall.h b/arch/riscv/include/asm/syscall.h
> index 8067e666a4ca..987c9a78806f 100644
> --- a/arch/riscv/include/asm/syscall.h
> +++ b/arch/riscv/include/asm/syscall.h
> @@ -112,11 +112,6 @@ static inline void syscall_handler(struct pt_regs *regs, ulong syscall)
>  	regs->a0 = fn(regs);
>  }
>  
> -static inline bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
> -{
> -	return false;
> -}
> -
>  asmlinkage long sys_riscv_flush_icache(uintptr_t, uintptr_t, uintptr_t);
>  
>  asmlinkage long sys_riscv_hwprobe(struct riscv_hwprobe *, size_t, size_t,
> diff --git a/arch/s390/include/asm/syscall.h b/arch/s390/include/asm/syscall.h
> index 4271e4169f45..5f310caad1fc 100644
> --- a/arch/s390/include/asm/syscall.h
> +++ b/arch/s390/include/asm/syscall.h
> @@ -89,11 +89,6 @@ static inline int syscall_get_arch(struct task_struct *task)
>  	return AUDIT_ARCH_S390X;
>  }
>  
> -static inline bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
> -{
> -	return false;
> -}
> -
>  #define SYSCALL_FMT_0
>  #define SYSCALL_FMT_1 , "0" (r2)
>  #define SYSCALL_FMT_2 , "d" (r3) SYSCALL_FMT_1
> diff --git a/include/linux/syscall_user_dispatch.h b/include/linux/syscall_user_dispatch.h
> index 3858a6ffdd5c..73d69e02807d 100644
> --- a/include/linux/syscall_user_dispatch.h
> +++ b/include/linux/syscall_user_dispatch.h
> @@ -10,6 +10,7 @@
>  
>  #ifdef CONFIG_GENERIC_ENTRY
>  
> +bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs);
>  int set_syscall_user_dispatch(unsigned long mode, unsigned long offset,
>  			      unsigned long len, char __user *selector);
>  
> diff --git a/kernel/entry/syscall_user_dispatch.c b/kernel/entry/syscall_user_dispatch.c
> index d89dffcc2d64..acf545774d37 100644
> --- a/kernel/entry/syscall_user_dispatch.c
> +++ b/kernel/entry/syscall_user_dispatch.c
> @@ -32,6 +32,11 @@ static void trigger_sigsys(struct pt_regs *regs)
>  	force_sig_info(&info);
>  }
>  
> +bool __weak arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
> +{
> +	return false;
> +}
> +
>  bool syscall_user_dispatch(struct pt_regs *regs)
>  {
>  	struct syscall_user_dispatch *sd = &current->syscall_dispatch;
> -- 
> 2.34.1
> 

Build and boot tested on ppc with P11 LPAR. LGTM.

Tested-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>

