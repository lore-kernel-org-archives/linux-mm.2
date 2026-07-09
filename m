Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AFB2C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4C76B0088; Thu,  9 Jul 2026 04:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73EE56B008A; Thu,  9 Jul 2026 04:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 606256B008C; Thu,  9 Jul 2026 04:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 249596B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:15:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E3D340458
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:15:32 +0000 (UTC)
X-FDA: 84968528904.11.6ABF73F
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf20.hostedemail.com (Postfix) with ESMTP id 38D271C0009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:15:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kCxesqoZ;
	spf=pass (imf20.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783584930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48+51s385OsDhp5N7LQ5qHC6FAjEEUm6ed4fMfXeBFY=;
	b=vXHGaCqwA5unik5Vz2VgVF/bpAPTfpg2DUa24BSWE8/n0oIleCUdiwkz6n7k0H7yXFvqtn
	qXNEyKct9PR6RUrLu30DjgfqXuEErKeCpiGx9GTmkac4rVjYXVuDM4ol7e/NmJJJ26LCwK
	eReEG0dAiK54Vf98mq40sm4hNdupQtw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kCxesqoZ;
	spf=pass (imf20.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783584930;
	b=4yjByTvPp5PerwwMlHfMGUWT6j/aBsjvr0rmIOoJOTa6Nz+PvamUwY6r4Q3cnxEJP78Sba
	hwVdy1Ob6H/uOlPc2Ppq4vVLjLEy2KUI4pIC1MAInTeyWaC6LD6thEjqnE6nfNKRI1P47c
	GDmDh2pAzVu2Bri69/asLXrdfUGrhHM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=48+51s385OsDhp5N7LQ5qHC6FAjEEUm6ed4fMfXeBFY=;
	b=kCxesqoZlJiDDihnZyAzF5o6+WjRbCD++5bvCV+W0tELEqX7VwTIDS62IobikU82bv7sl8+Y1
	2yCD+9ZYiDHYfjsAjS3Zn9Bd2SI2V6mn7KdFbxeGgCuBgK5A7WIPxe6IBYKwyHnFX9K58lcg3UM
	OCKTRSDGklsZpCIPJLCzdso=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gwnbX6pZrzcbR0;
	Thu,  9 Jul 2026 16:06:16 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id CC36D40561;
	Thu,  9 Jul 2026 16:15:21 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Jul 2026 16:15:16 +0800
Message-ID: <d9c9686c-dfd8-4539-b301-8726bab7443b@huawei.com>
Date: Thu, 9 Jul 2026 16:15:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 18/18] arm64: vdso: Expose sigreturn address on vdso
 to the kernel
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
CC: <oleg@redhat.com>, <richard.henderson@linaro.org>, <mattst88@gmail.com>,
	<linmag7@gmail.com>, <linux@armlinux.org.uk>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <kees@kernel.org>, <guoren@kernel.org>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <geert@linux-m68k.org>,
	<tsbogend@alpha.franken.de>, <James.Bottomley@hansenpartnership.com>,
	<deller@gmx.de>, <maddy@linux.ibm.com>, <mpe@ellerman.id.au>,
	<npiggin@gmail.com>, <chleroy@kernel.org>, <pjw@kernel.org>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
	<hca@linux.ibm.com>, <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
	<borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
	<ysato@users.sourceforge.jp>, <dalias@libc.org>,
	<glaubitz@physik.fu-berlin.de>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<luto@kernel.org>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <chris@zankel.net>,
	<jcmvbkbc@gmail.com>, <peterz@infradead.org>, <wad@chromium.org>,
	<thuth@redhat.com>, <mark.rutland@arm.com>, <ada.coupriediaz@arm.com>,
	<kevin.brodsky@arm.com>, <linusw@kernel.org>, <yeoreum.yun@arm.com>,
	<song@kernel.org>, <james.morse@arm.com>, <anshuman.khandual@arm.com>,
	<broonie@kernel.org>, <liqiang01@kylinos.cn>, <pengcan@kylinos.cn>,
	<ryan.roberts@arm.com>, <yangtiezhu@loongson.cn>, <sshegde@linux.ibm.com>,
	<mchauras@linux.ibm.com>, <austin.kim@lge.com>, <jchrist@linux.ibm.com>,
	<arnd@arndb.de>, <sohil.mehta@intel.com>, <andrew.cooper3@citrix.com>,
	<jgross@suse.com>, <kas@kernel.org>, <x86@kernel.org>,
	<linux-alpha@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-csky@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-m68k@lists.linux-m68k.org>, <linux-mips@vger.kernel.org>,
	<linux-parisc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>,
	<linux-sh@vger.kernel.org>, <linux-um@lists.infradead.org>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-19-ruanjinjie@huawei.com>
 <20260630172619-6c78c2e2-c2d3-44be-88e6-6c82de12baf4@linutronix.de>
 <21875fb4-434b-480d-b68b-e2ffd5fff5ae@huawei.com>
 <20260709090525-b1e5ae06-1fb4-454e-919c-6503dcf3d073@linutronix.de>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <20260709090525-b1e5ae06-1fb4-454e-919c-6503dcf3d073@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 38D271C0009
X-Stat-Signature: 5dppg8gc4szc8rgh7bzj7ydpy17qm99g
X-HE-Tag: 1783584929-295155
X-HE-Meta: U2FsdGVkX18TZc0R9pk3/aJiwxxfbUJNwC6EaKKvmbUOS/P74v+ER7os6T66Kp+XiL7Mufb7I8OGzvqdxlYoRjU9fZSJ48nPSCg2EbVBKmiQZDqke5mEqmoi2CHdz8dTedQYsarSTiT5AttgCVCbRAN3ZzQ7V870bsr5N9j0yRrbKz1xiU0p+902WnhpLOhX9N7uvCzOtvyrbH/jLUMTzkFvqHrQc/OjcV0+4sepZGqkWoLEMd3y6rT/31jQx2KfFT5wDJ68GRouobvPPHf133SD5Qq9gluMOyvhCW0JXaihyiGRq2jFqon2P2IJTW/TSSyvJaftq8Be4TrGxq+e8AyqNzoCJhf686wpH+aZS0yT0e9b+0wGtAWj8yJXC/rIeOdmHTC4tnZyGulOsl8rWP5CIx+WoB89FopuFTju0u3RSqYZ8WDylrCz3wrGcI6sT0uUAkusdbtNKa8hidc8bA3n8c6D2NaLNz86eaYESnLdPHvkkBSqh83QZrBQFfBibdHyC/yJsxaEcTRZ7M+fptOI1mI0XXMX+0L7fvtWAezwPRhHzWuTZ1UOBG8VU3S0sol9hi9cwMuGRnP5GHYXdQrPm5Hato1vApIR3Wf501J3lXaTfsi09jciZy5A1INfWygYyxIuX2/jxB8VQcPpgzRqrpG8flJY0mUZj+k5hbtVCeWnbFEsW3x5ZjiUoznt4m69zGA9SwFIctDy4clBH9n6CYASeKYhLijQTbDhj+3HsWJPwSRjNen8LshDHUMPTaBfB9QgW3bM/zMiczmfuvuO26HOD/4/fUejEHGc29qmPqM3U2zt5qFk/J3ZIvCSUr8Vn1Fz/WUc3q5zSAgCZ9HGwFp/JlVKpfQkCVBgp9KhgvDeoQLYK7r+vRFaGMjZjtW0ez8al2HeqI5BhUyUFpq/MntbRLIg3C2Abtc4c2RfUuges+jstbgYeg6uho/CDM6cAV4hvHIiFPzv2kI
 glz3BS+4
 8P9pboSnAbD4RCdAKk2wbb+Xt11l11fqponKXY70HFxtU4R4qx1RvJSFkpM2Aeu8btQ30iEgSNGFqtScY7h0Zy/OUk5KSjdN7FuSX8Rru/d+zjemuwL84e2UhdroCMTmt6q2c8tIQvddMmdDkOOQyduXCpJBPyYj4oJvMph4Vvhm3Ex/WEMvHQm6P/RtvyynCagy6ftJBblZq94V0/M8pcz+Owjtu11aFPg3M7ndeqS8vqNsX2ukLs8BaF5YPuOBuneZqyglH7v53BTMEO6115JTKytOCSdie9JRqAsAYX+T3o2svBV4+ZYkI/tfEJhrAtYXMib5Ff7R701dzQu9HA2JcryHpHOkj+yrFEu8SedxbvBZoQ8J+SKyrMtK6c/nA2Zs2rLT/2+E7/59HPM6w+F6kbXhPUFuudVAY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/9/2026 3:17 PM, Thomas Weißschuh wrote:
> On Thu, Jul 09, 2026 at 02:37:05PM +0800, Jinjie Ruan wrote:
>> On 6/30/2026 11:32 PM, Thomas Weißschuh wrote:
>>> On Mon, Jun 29, 2026 at 09:06:16PM +0800, Jinjie Ruan wrote:
> (..)
> 
>>>> diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
>>>> index 592dd8668de4..5a0314a3c26e 100644
>>>> --- a/arch/arm64/kernel/vdso.c
>>>> +++ b/arch/arm64/kernel/vdso.c
>>>> @@ -343,3 +343,19 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
>>>>  
>>>>  	return ret;
>>>>  }
>>>> +
>>>> +bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
>>>> +{
>>>> +	unsigned long sigtramp;
>>>> +
>>>> +#ifdef CONFIG_COMPAT
>>>> +	if (is_compat_task()) {
>>>> +		unsigned long sigpage = (unsigned long)current->mm->context.sigpage;
>>>> +
>>>> +		return regs->pc >= sigpage && regs->pc < (sigpage + PAGE_SIZE);
>>>> +	}
>>>> +#endif
>>>> +	sigtramp = (unsigned long)VDSO_SYMBOL(current->mm->context.vdso, sigtramp);
>>>> +
>>>> +	return regs->pc == (sigtramp + 8);
>>>
>>> Instead of hardcoding 'sigtramp + 8' you could add a new label to the 'svc #0'
>>> instruction and use that with VDSO_SYMBOL().
>>
>> It seems that the modification of __kernel_rt_sigreturn() is not recommended
> 
> For the changes to the object code of the function this is obvious and
> well explained in the comments.
> 
> Such a label however would not change the object code of the function.
> In fact it would not change any bit whatsoever in the final vDSO,
> save for a new build ID.

Yes, and using labels is easier to maintain than hardcoding offsets
directly.

Similar to the code below?

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -86,6 +86,7 @@ config ARM64
        select ARCH_SUPPORTS_SCHED_SMT
        select ARCH_SUPPORTS_SCHED_CLUSTER
        select ARCH_SUPPORTS_SCHED_MC
+       select ARCH_SUPPORTS_SYSCALL_USER_DISPATCH
        select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
        select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
        select ARCH_WANT_DEFAULT_BPF_JIT
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index d2779d604c7b..a8b232c5c6d9 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -293,6 +293,7 @@ static inline int arch_check_elf(void *ehdr, bool
has_interp,
        return 0;
 }

+extern bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs);
 #endif /* !__ASSEMBLER__ */

 #endif
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 592dd8668de4..609d7bcd8308 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -343,3 +343,19 @@ int arch_setup_additional_pages(struct linux_binprm
*bprm, int uses_interp)

        return ret;
 }
+
+bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
+{
+       unsigned long sigtramp;
+
+#ifdef CONFIG_COMPAT
+       if (is_compat_task()) {
+               unsigned long sigpage = (unsigned
long)current->mm->context.sigpage;
+
+               return regs->pc >= sigpage && regs->pc < (sigpage +
PAGE_SIZE);
+       }
+#endif
+       sigtramp = (unsigned long)VDSO_SYMBOL(current->mm->context.vdso,
sigreturn_landing_pad);
+
+       return regs->pc == sigtramp;
+}
diff --git a/arch/arm64/kernel/vdso/sigreturn.S
b/arch/arm64/kernel/vdso/sigreturn.S
index 0e18729abc3b..8d2d413ff45e 100644
--- a/arch/arm64/kernel/vdso/sigreturn.S
+++ b/arch/arm64/kernel/vdso/sigreturn.S
@@ -73,6 +73,7 @@ SYM_CODE_START(__kernel_rt_sigreturn)
        mov     x8, #__NR_rt_sigreturn
 //     PLEASE DO NOT MODIFY
        svc     #0
+       SYM_INNER_LABEL(__sigreturn_landing_pad, SYM_L_GLOBAL)
 //     PLEASE DO NOT MODIFY
 //     .cfi_endproc
 SYM_CODE_END(__kernel_rt_sigreturn)
diff --git a/arch/arm64/kernel/vdso/vdso.lds.S
b/arch/arm64/kernel/vdso/vdso.lds.S
index 52314be29191..5fee2927e4c5 100644
--- a/arch/arm64/kernel/vdso/vdso.lds.S
+++ b/arch/arm64/kernel/vdso/vdso.lds.S
@@ -104,6 +104,7 @@ VERSION
                __kernel_clock_gettime;
                __kernel_clock_getres;
                __kernel_getrandom;
+               __sigreturn_landing_pad;
        local: *;
        };
 }
@@ -112,3 +113,4 @@ VERSION
  * Make the sigreturn code visible to the kernel.
  */
 VDSO_sigtramp          = __kernel_rt_sigreturn;
+VDSO_sigreturn_landing_pad     = __sigreturn_landing_pad;


> 
> 
> Thomas
> 


