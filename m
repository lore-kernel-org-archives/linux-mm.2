Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8912CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 129736B00A1; Fri, 12 Jun 2026 12:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100BE6B00A2; Fri, 12 Jun 2026 12:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016886B00A3; Fri, 12 Jun 2026 12:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E44246B00A1
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:30:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90D691C0D1C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:30:14 +0000 (UTC)
X-FDA: 84871797948.29.34E0DF3
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	by imf12.hostedemail.com (Postfix) with ESMTP id 44C8140017
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:30:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="C 83N6X9";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=kXVVRqdH;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781281812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPWIUmv7o85y77DNU8cNkhUSgD6pQKzFSK9Rh6/dB9M=;
	b=bs4e6XgF7jC7ta0kIIIDkQS3p5WapTCZqCgnmFhuLXIUKYLHA0isWOprlxWIwdcsiu2kNU
	JzKp7jBMqxDYDf8CvzKs/+fwn6UBRxcR1JGvYLVcpchmXhjIhkyUf3RSbxaza8ZoimHp5a
	YXHXGzhaGAYUgMz0mA4GDtwODZgmCAw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="C 83N6X9";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=kXVVRqdH;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781281812;
	b=3WKQazFHEUM4y79yDK19Jl9Pk5WWuUmqhxKKzVelbQ6/GNjj0SCE/BgSIAl6S1xNVLiJv5
	76ECRTbHbkXiLbqfd2In2z2NM4v2GDCbyvXAjuWXBFunnOGcDyEU760TJynyDrHwqS+en9
	nR1c4ItccDQIcHx8KD20z9WWdbNDGQw=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id 8C4C91380117;
	Fri, 12 Jun 2026 12:30:11 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 12 Jun 2026 12:30:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1781281811; x=
	1781289011; bh=JPWIUmv7o85y77DNU8cNkhUSgD6pQKzFSK9Rh6/dB9M=; b=C
	83N6X9YVBl5cOmSZUJ9pC7/NcHioDQkEIDEmefxCV83WSGiqh/zG75U49EB9gNhL
	eQpdLKC50sfDjQ4PbF+RcylSPmYW5yqXjsADA5m+Jq6fFd2WjMJZA55Kwx9nqPyC
	s7+aHctdevRwRuwAkavgBpQswSCu2I9VCNOISXpoZeNhgTZaYJEfzkUTnmj9zUpT
	YHT+bldDdgWkEyedj9bOnubtID67wUBwk3B0hE8yFL7LFc5ZVtH++D60wklkWoKa
	xVRjuBrHOfMeV5C/GSvl73VZ0bkw3aVDRgpVh5/PqHyIS4KhE1nu86Amh9A2g070
	N2dKgqER2ir9ciEG7/SWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1781281811; x=1781289011; bh=JPWIUmv7o85y77DNU8cNkhUSgD6pQKzFSK9
	Rh6/dB9M=; b=kXVVRqdH7NvGJXoomPyI6L1DzGjLvTGSK7GqXxbO8y6STXl5Cy8
	FO12TsMfGrtscwVdx2I6SEESmPG6my7nx7Pi/COQT78eF0DepOXU+yc6teBVfKEz
	Q53UbIxlDWxjzh3SH/BA/esBm7NuZDpgRmgW+rBK7DA4WFXf95grtkomaU6A+s9j
	HzcWVDJY/GnMeOAoLLv4c1Tz09K3/p22w0XIpgAys7IU1oXs4w2kSsUyXCbObfGL
	CaJC7Kjla63UwECAzQM6mbFvy1LJs5Gkl252AwMDKsX8dN4uhk7lfPircRMVNRPZ
	ppqhj2mOeOZKg4vMHRAFfKK2wqWxgnqk3zQ==
X-ME-Sender: <xms:ETQsah_K7dW98Y7oWvRFzjwl-EXYcJ85m4Z6fFaK78ow6-uglhnJ_g>
    <xme:ETQsag1M1XeMtw0fS9WBkhBQApkqYi6eS3774AtIiGSmhsCZUHJmySkmcvvuSUw4k
    RyXpBxMVeN7Jt4FvEKPT1Uj7r-o_fP-HnyYks3VZQW-4OP_VhUPQDo>
X-ME-Received: <xmr:ETQsauZT-l7MZqAyxCUqmNjUGoCdvz8UwJyew_oLWjRjomajE6yeReV56bq97g>
X-ME-Proxy-Cause: dmFkZTETIJWWZf8ko10xeT8E6KYd8EuVMIA0Cz31xlXx76CsNvlZ3aEUn7dUUu82qH57kj
    f2RHsSsq+OSFmAT1A70MvbNlhjJU6JKSZ4oW1PC5b87cZH2YRQGUPuqTBi7c5zWzu2BTi8
    1Y9gwX6IOu2TYJdFRacCRB2gCTH+AZAvbt3kMiMJ8pFUIikJM6Ltb60os/2XTy9AHUgqvg
    58puxntgllAItlimqthqFv3/AIZJHUe5YEKQPXEQAVE+RLo6418I8sItQ0/B6/ggIpj+c4
    FUJfO8C9CSTsYwkKmfBBbTLWCdzFN8hsWOk9I+5WcJO9zCIsY9nSYflQbQMCh3Jpc+0Wgr
    GLqM/erXuyvNJftHPZTjsinHEcVMkhqjCBFAsUH6AWO6HUh5v8CgRKQCXFQkpYPzIgPK0h
    Hypq56bGvBWafx3fie7CNXDMlxtDDLaXfJ72nz70XhumfvirXDwWwx/3iIbI5YZpROWJTM
    Gj+eWGH+usWort9ZVE8kvc2SAQm6jXEkgAHvTmY0CY5NTuCMG4FsNfSl9rqzPKAg3xub3Z
    yl0CpSRjxScDZx2J9epC9Bn8dGm7oa9h7iovTPUR6m4BR+sXOMylFJnMsgEkQsdwIIhKUM
    /ZkwABCnDfq+K7P45sX42uD8BxHWFpGcASDaQ9x4HKuU/3ss9eE9+OWbSSBw
X-ME-Proxy: <xmx:ETQsaktLkBo8-R-vi0ogXEisCQDRbozJSPTJqsStYKwiqyP5VMuq9A>
    <xmx:ETQsatAacXQ-QWA8VdFLims196dSrzFIKwCDiVKO1qMhay_FJ11sMA>
    <xmx:ETQsanCUzn4c11x6bRq2zYJEALigfkvbqOuT7MssNJSSlGq3cTfsVA>
    <xmx:ETQsavkWZt5zXs3ROnobBNlkThMvcgjfbT92xbLC2piqVmgCVFa2-A>
    <xmx:EzQsaktksHf3FF8v3WOEzbmdHkMnPkTQw8lNY5r6T56sCgVCCZlvyox5>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Jun 2026 12:30:07 -0400 (EDT)
Date: Fri, 12 Jun 2026 17:30:02 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
Message-ID: <aiwxWk0gOV4ZlKcT@thinkstation>
References: <20260610175651.647515-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610175651.647515-1-ihor.solodrai@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 44C8140017
X-Stat-Signature: yxb41ywrxy3i1k1bubjf7fteya9cukzi
X-Rspam-User: 
X-HE-Tag: 1781281812-41872
X-HE-Meta: U2FsdGVkX18/R4/02LCnwg6PdOOYK5L/bCsJPf1INpjharoBfvqBm5OYjA7zKW03VovUWDwt/D2NG+apEBPYHGDyCUG/aXGV/Ug3NFwzt31gOz0pj3Pn4IydwzznTtLUML35Wi5V8295pqHom3mj65I4Rxhii4L7y/bYsgY2n1jJA+0iQi4Gk96LOZHdHKkl7DVpn9onTQhibcIIO0bZ/ahONk1qunRtdrPJAfucZ04UhxT+MbBT5IUDjGrUERh628juw3avUIA1gyQFMSJBzB7cPi8BUVsQHmT4AQe8cJ77tU2CVUGJ2/+fTXmpDg2oWR0g4jS+ojWS4gAtBbVwY2cV9LLivlGLYd3tWR5itmPyEAMquV52gQA5t+bdby7pEOFvPiaF2KFjuWL+CmxFXfpFTigNsKpDS4bhIBP/do5V9s9Ym+7cobzLijDDve/q21DVyqgqNfxg+f53AXUnnXVLgoUUy4m8RbPNiaiNhClhXffwcgu75YQ9eYuL8TGRCwanpVbkhvyNO+NdHFxNzKf8+hQMkTByY3HReY02+wudsAD0Bkt+/rPwqWC+iD85v/2CdI1OrAsm4vewg161LLa8NWDugKjCMnAhXzZ1Cjompp+VR/hIIvDB7KCuSukFvHubOc/JZm6JNk7MXYweHOcezKCnpN/Ti+tJacq+GsmHo2amQryn8WbwVSvKKVoniip6iS2I8Y1ptsrfSgS+YpnuezzdIrxx6Beh4gS8HPtLEnWCzfzHN3oN3WFF+cI3HcBFu9Lzs5vJValQt3RZbBs/eC9osEYkMpR3h9t3RnNiK+Ak0YkdQDp49HEssOa0lBG5RhCGuL5nsRhlCb53xVdnHeyGhCuq49iWAvDwh1wsIidf4TP0sQCXLcEfwL+gKDLVshxxGZuzzoTk9+XtzvFFvHdC5rl8Hz7q8t1HnXD6jb6vfGeLcJ2p0p81f02bgSuB2wBecb5t4ablM2N
 XV8CpN7x
 nlCMrcvFHRx86vvY38+CD54cOUgz91veXPseYcpdUDDgvjQixLmP7TXUa0lL7xl/L14txrlBj1UhihrlHqqafF5gfRs3PhvQuVdrEdUjYN0Fzj/H3EWw+X2mRwTFsXqDtrKdKLjHbrcFud73W3bjeIfFMUSW8M7oQaZgDmv+NpR4dcszJaxVnqAj2ZfPYDx4tkNwFX7GVbEcKjP6mHyDlTSlRDCRdSam6RjKmQPd6NfX6E+N+mpUn7+7O3kDBncmWc8NzXOM6/P6WqyfzuEBzFRq0VP7d9B++N+OoOi8qC4opfU1rwxwpVUduazsRuoAnDXuK60h7sbegmJxUsIIGgFxW3uLV6qypYEnuLlIHQcEVlZ4XyxyZssuWbVjtdoY1/q6JkmY+9nlcZFvQRrg96Ih+3LBpbh8aDLqBbkv6Sp7p/bWFlnOJ9KQn9FThC/xyVLbchiiPtJk8l2Kg/CPjtVAbhJBLEngKFSEC5E004sSvt+cCbSl/spC/WxyjQzQSK4yOGQRljgwO8S4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 10:56:51AM -0700, Ihor Solodrai wrote:
> On x86_64 with 5-level paging (LA57) and inline generic KASAN, the
> following flaky splat may be observed on boot:
> 
>     BUG: KASAN: wild-memory-access in do_raw_spin_lock+0xcf/0x260
>     Write of size 4 at addr ff110001000c90b8 by task swapper/0/0
> 
>     CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.1.0-rc5-gcba33e0b2907 #1 PREEMPT(full)
>     Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>     Call Trace:
>      <IRQ>
>      dump_stack_lvl+0x54/0x70
>      kasan_report+0x117/0x150
>      ? do_raw_spin_lock+0xcf/0x260
>      kasan_check_range+0x264/0x2c0
>      do_raw_spin_lock+0xcf/0x260
>      handle_edge_irq+0x35/0x770
>      ? do_raw_spin_unlock+0x51/0x2a0
>      __common_interrupt+0xae/0x120
>      common_interrupt+0x7c/0x90
>      </IRQ>
>      <TASK>
>      asm_common_interrupt+0x26/0x40
>     RIP: 0010:identify_cpu+0x2b2/0x3460
>     Code: 00 41 c7 07 00 00 00 00 4d 89 e6 49 c1 ee 03 43 0f b6 04 06 84 c0 0f 85 a3 1c 00 00 41 c7 04 24 00 00 00 00 31 c0 31 c9 0f a2 <89> c7 42 0f b6 44 05 00 84 c0 0f 85 ad 1c 00 00 41 89 3f 48 8b 44
>     RSP: 0000:ffffffff97807df0 EFLAGS: 00000246
>     RAX: 0000000000000020 RBX: 00000000756e6547 RCX: 000000006c65746e
>     RDX: 0000000049656e69 RSI: 0000000000000000 RDI: ffffffff98632fd8
>     RBP: 1ffffffff30c65fc R08: dffffc0000000000 R09: 0000000000000004
>     R10: ffffffff98632fc4 R11: fffffbfff30c65fb R12: ffffffff98633050
>     R13: ffffffff98633048 R14: 1ffffffff30c660a R15: ffffffff98632fe0
>      identify_boot_cpu+0xd/0xd0
>      arch_cpu_finalize_init+0x24/0x1f0
>      start_kernel+0x31e/0x3e0
>      x86_64_start_reservations+0x24/0x30
>      x86_64_start_kernel+0x13a/0x140
>      common_startup_64+0x12c/0x137
>      </TASK>
> 
> It fires very early in boot. If kasan_multi_shot is set, the reports
> are non-fatal and keep repeating, and the boot CPU wedges before
> userspace is reached. The accessed addresses are valid 5-level kernel
> pointers, so the report is a false positive.
> 
> The root cause is in generic KASAN not seeing
> cpu_feature_enabled(X86_FEATURE_LA57) set, because the bit is cleared
> in identify_cpu() when the offending interrupt happens [1]:
> 
>   memset(&c->x86_capability, 0, ...);   /* clears X86_FEATURE_LA57 */
>   ...
>   get_cpu_cap(c);                       /* re-reads CPUID, restores it */
> 
> addr_has_metadata() then uses the 4-level threshold, and 5-level
> kernel addresses fall below it, so kasan_check_range() reports them as
> wild-memory-access.
> 
> Define USE_EARLY_PGTABLE_L5 in mm/kasan/generic.c so
> addr_has_metadata() uses the stable variable, as
> arch/x86/mm/kasan_init_64.c already does.
> 

I'd rather not push USE_EARLY_PGTABLE_L5 into generic KASAN code.

It's an x86 paging detail in arch-independent files. It's incomplete
(report.c and report_generic.c also call addr_has_metadata()). And it's
a permanent slowdown on the KASAN hot path -- pgtable_l5_enabled()
becomes a runtime load of __pgtable_l5_enabled on every check, whereas
cpu_feature_enabled() gets patched to a constant after alternatives.

And it leaves the real bug in place: the window where
boot_cpu_data.x86_capability reads back zero is visible to *any*
cpu_feature_enabled() caller in interrupt context, not just KASAN.

The window is opened by identify_cpu() itself, so fix it there:

	diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
	--- a/arch/x86/kernel/cpu/common.c
	+++ b/arch/x86/kernel/cpu/common.c
	@@ -2003,6 +2003,7 @@ static void generic_identify(struct cpuinfo_x86 *c)
	  */
	 static void identify_cpu(struct cpuinfo_x86 *c)
	 {
	+	unsigned long flags;
	 	int i;
	@@ -2022,12 +2023,21 @@ static void identify_cpu(struct cpuinfo_x86 *c)
	 	c->x86_cache_alignment = c->x86_clflush_size;
	+
	+	/*
	+	 * x86_capability is cleared and repopulated from CPUID below. On
	+	 * the boot CPU this runs with IRQs on and before alternatives are
	+	 * patched, so cpu_feature_enabled() reads the live bits; an
	+	 * interrupt in this window sees e.g. X86_FEATURE_LA57 as disabled.
	+	 */
	+	local_irq_save(flags);
	 	memset(&c->x86_capability, 0, sizeof(c->x86_capability));
	 #ifdef CONFIG_X86_VMX_FEATURE_NAMES
	 	memset(&c->vmx_capability, 0, sizeof(c->vmx_capability));
	 #endif
	 	generic_identify(c);
	+	local_irq_restore(flags);

save/restore keeps it correct for the secondary-CPU callers that already run
with IRQs off.

I reproduced your splat with parallel TCG guests (-cpu max, kasan_multi_shot):
~10% of boots hit it, 0/~200 with the above.

I am not sure how wide the irq-off window suppose to be. I scoped it to
memset() .. generic_identify(), where LA57 is restored. Later code
(apply_forced_caps(), ->c_init(), setup_sm*p()) only refines bits.

Widen it to be defensive, or keep it tight?

Any better solution?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

