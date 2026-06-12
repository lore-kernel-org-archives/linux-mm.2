Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0D89CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 19:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448646B00A4; Fri, 12 Jun 2026 15:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F906B00A6; Fri, 12 Jun 2026 15:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335DC6B00A7; Fri, 12 Jun 2026 15:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 224F36B00A4
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:42:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E5EDE1C0A56
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:42:37 +0000 (UTC)
X-FDA: 84872282754.27.44E80DB
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id 718DA4000D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:42:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=brOAb7K2;
	spf=pass (imf27.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781293356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QLZc+bqOjpJQqkbYIVO2qgsWd8vMlqHdKvbCmBuh0Y=;
	b=SQCVSIs9QaxAoh3Qd4du8KTPdggjc6SbavEc9a4gcg7rZVoHBc6LlvRsYtNB+CkKjqRUFo
	A7620p7wUsGa+tMebMMnfuKZ3clfDVaGv519bjtT4BVvJE16X4XO3i1yYpjdIdASosrSG1
	gpw7uf+3O/ARi1h5+b/NN5srPB3R9n4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781293356;
	b=Q5Vndw+K945jGOTWAgrF2bWA06ZgfWuH24XZgfj2aEvttnVIJ6oT2MCZ2R7dPbjldMcvGl
	7bWVT68udWElpYYMpRHAzmaQjznF8TdSJd3IiKMPVbkDlRZXI9TTj9kUvXvSZrthOP+5Pu
	i9xx9RNIHIsD7+hqzwSLFQPFOHTrfvE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=brOAb7K2;
	spf=pass (imf27.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <a9aa8bd7-4b3e-4ded-ba9c-6115bb1a5bc8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781293352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8QLZc+bqOjpJQqkbYIVO2qgsWd8vMlqHdKvbCmBuh0Y=;
	b=brOAb7K2GmoEqTh0l7IiYkch0zYK2c6+jUxruMDFAQD9tKJSt3HwYn6JGIZIQmrppMrU2H
	VVABEx9NGfPgJuo3eDtc9l7efrJkdw7klR50XggUB+zmfm+RnSkMruSU6Rz86wiQCXBz1z
	cM+zBQYUFEWxqCFlQuU5XrBs9I1S+q0=
Date: Fri, 12 Jun 2026 12:42:25 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Alexei Starovoitov
 <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Eduard Zingerman
 <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, bpf@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260610175651.647515-1-ihor.solodrai@linux.dev>
 <aiwxWk0gOV4ZlKcT@thinkstation>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ihor Solodrai <ihor.solodrai@linux.dev>
In-Reply-To: <aiwxWk0gOV4ZlKcT@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 718DA4000D
X-Rspam-User: 
X-Stat-Signature: qhbuc9x67er98m9j6erx7uaa1m4zayd1
X-Rspamd-Server: rspam08
X-HE-Tag: 1781293355-486134
X-HE-Meta: U2FsdGVkX1+3u1DXqwfhNl55XEG77iuqdD3UCgzszdQgxoqX4Gn2xmBFCj3VVNXa4xuTK8NZKUkPrZB9I056BQZbOyJLpLNexbUE5Sn9zKoREDHwSTsv56yxfaSRPDmkkFBqVANj4pU+oOu6dSD2C/QkZDgzeXeT8+dmrVjNa5n3b9WuIC0SrC2rg83faLQmgw+mqrrDhfuwe/R+E3eXqxqdTj3Njkp8FOXe9n3TVb1cPWOsMw4j0Lzbwr1l2mcJQqpuob8fCj8nUngI2LuHhcQZdrQtdjpeN2yqGhFdXmIhK6bw5hsqpy1NMJ7GKtsET8CDSU5zxlu7lBJEpMj24MHoDzcQuA4SaYLG7X3rEs1VLv+xrT24fJnIgCkFFBsMT6dPDEtSR1SiCNyWGKJMsvKmfyUbA4RFCAECvvejlZGVlU4HShI+tFk2cFC/mUwIeHtv+5uQqV6K1T8HygPdgx8l3An+eUP7lxo28voZz5UM57MswZQnHOlP6dcJN3C29UQBzzaKCpbgoWJ48RE9raqj2p+Hh91ulusIa4tPlrgeCKkOgfGJQnp36rV3Tw0ct5GePiHI6nKDvyaSEkdChGaulI/7kqFh0hQeZY1C5ODOK9k7mxZW4okbcI92+NRTI4z9EsLi88nkdwwMkiYm3VghcehJNkjlmYIkp0yYxUY07iYcZioNtGKynXNmipMbOWj93O3Can+qZFe0HVkle9X84bNxJD0af+hWYoTvw8O3JS5BT90s6/L+p/9EQXKuMLNdYohw449cO1phc/F0uiF4h1ydvB8B3jmF7fFPmJwfNaW0gNA4YZ1vAHMJEnL042+IosSwAkT+4irOacWOuci5e7w0AJ7HyqtGVjqtbTgIA+ycbu8X8cidrGaosEkF/byhkuZCmuSDGnNtGGCl29vPi/YvROd2VN5CHNWSIhJQVlOEcK8MhlaxWSzn9POpLpktrrfq7ifcLhuwYWv
 vm3Zic8i
 DqBh7MxxuGM8VrqVRHskOM9t+OwxaPogMVpnkjtpeqjMUTu/GHUfWrODUygxz8ZwvkgQ000hLwsdIL1DM50U2wfl2H/iZ11k1ahEupvwurLXh6/sC5Q5gogz0cLADcQiWeHQcpiv8bkXV16mSLo/p4xcy+4p7A70Ngxmb2djAVVWSiog4ezdG3B9dqOUYgaCsYsc16e3E59z9gn3nR43G+3YOLfEHoY/gDZ4bwAMhcGtz2jvp0ZSxePAM5RYnVnxFHZT6sNlD241+Y4cO9dyKy+BZ5rrUlSFDdqwssSA6VehQnMzRFI9Bc1Nu+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 9:30 AM, Kiryl Shutsemau wrote:
> On Wed, Jun 10, 2026 at 10:56:51AM -0700, Ihor Solodrai wrote:
>> On x86_64 with 5-level paging (LA57) and inline generic KASAN, the
>> following flaky splat may be observed on boot:
>>
>>     BUG: KASAN: wild-memory-access in do_raw_spin_lock+0xcf/0x260
>>     Write of size 4 at addr ff110001000c90b8 by task swapper/0/0
>>
>>     CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.1.0-rc5-gcba33e0b2907 #1 PREEMPT(full)
>>     Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>>     Call Trace:
>>      <IRQ>
>>      dump_stack_lvl+0x54/0x70
>>      kasan_report+0x117/0x150
>>      ? do_raw_spin_lock+0xcf/0x260
>>      kasan_check_range+0x264/0x2c0
>>      do_raw_spin_lock+0xcf/0x260
>>      handle_edge_irq+0x35/0x770
>>      ? do_raw_spin_unlock+0x51/0x2a0
>>      __common_interrupt+0xae/0x120
>>      common_interrupt+0x7c/0x90
>>      </IRQ>
>>      <TASK>
>>      asm_common_interrupt+0x26/0x40
>>     RIP: 0010:identify_cpu+0x2b2/0x3460
>>     Code: 00 41 c7 07 00 00 00 00 4d 89 e6 49 c1 ee 03 43 0f b6 04 06 84 c0 0f 85 a3 1c 00 00 41 c7 04 24 00 00 00 00 31 c0 31 c9 0f a2 <89> c7 42 0f b6 44 05 00 84 c0 0f 85 ad 1c 00 00 41 89 3f 48 8b 44
>>     RSP: 0000:ffffffff97807df0 EFLAGS: 00000246
>>     RAX: 0000000000000020 RBX: 00000000756e6547 RCX: 000000006c65746e
>>     RDX: 0000000049656e69 RSI: 0000000000000000 RDI: ffffffff98632fd8
>>     RBP: 1ffffffff30c65fc R08: dffffc0000000000 R09: 0000000000000004
>>     R10: ffffffff98632fc4 R11: fffffbfff30c65fb R12: ffffffff98633050
>>     R13: ffffffff98633048 R14: 1ffffffff30c660a R15: ffffffff98632fe0
>>      identify_boot_cpu+0xd/0xd0
>>      arch_cpu_finalize_init+0x24/0x1f0
>>      start_kernel+0x31e/0x3e0
>>      x86_64_start_reservations+0x24/0x30
>>      x86_64_start_kernel+0x13a/0x140
>>      common_startup_64+0x12c/0x137
>>      </TASK>
>>
>> It fires very early in boot. If kasan_multi_shot is set, the reports
>> are non-fatal and keep repeating, and the boot CPU wedges before
>> userspace is reached. The accessed addresses are valid 5-level kernel
>> pointers, so the report is a false positive.
>>
>> The root cause is in generic KASAN not seeing
>> cpu_feature_enabled(X86_FEATURE_LA57) set, because the bit is cleared
>> in identify_cpu() when the offending interrupt happens [1]:
>>
>>   memset(&c->x86_capability, 0, ...);   /* clears X86_FEATURE_LA57 */
>>   ...
>>   get_cpu_cap(c);                       /* re-reads CPUID, restores it */
>>
>> addr_has_metadata() then uses the 4-level threshold, and 5-level
>> kernel addresses fall below it, so kasan_check_range() reports them as
>> wild-memory-access.
>>
>> Define USE_EARLY_PGTABLE_L5 in mm/kasan/generic.c so
>> addr_has_metadata() uses the stable variable, as
>> arch/x86/mm/kasan_init_64.c already does.
>>
> 
> I'd rather not push USE_EARLY_PGTABLE_L5 into generic KASAN code.
> 
> It's an x86 paging detail in arch-independent files. It's incomplete
> (report.c and report_generic.c also call addr_has_metadata()). And it's
> a permanent slowdown on the KASAN hot path -- pgtable_l5_enabled()
> becomes a runtime load of __pgtable_l5_enabled on every check, whereas
> cpu_feature_enabled() gets patched to a constant after alternatives.
> 
> And it leaves the real bug in place: the window where
> boot_cpu_data.x86_capability reads back zero is visible to *any*
> cpu_feature_enabled() caller in interrupt context, not just KASAN.
> 
> The window is opened by identify_cpu() itself, so fix it there:
> 
> 	diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> 	--- a/arch/x86/kernel/cpu/common.c
> 	+++ b/arch/x86/kernel/cpu/common.c
> 	@@ -2003,6 +2003,7 @@ static void generic_identify(struct cpuinfo_x86 *c)
> 	  */
> 	 static void identify_cpu(struct cpuinfo_x86 *c)
> 	 {
> 	+	unsigned long flags;
> 	 	int i;
> 	@@ -2022,12 +2023,21 @@ static void identify_cpu(struct cpuinfo_x86 *c)
> 	 	c->x86_cache_alignment = c->x86_clflush_size;
> 	+
> 	+	/*
> 	+	 * x86_capability is cleared and repopulated from CPUID below. On
> 	+	 * the boot CPU this runs with IRQs on and before alternatives are
> 	+	 * patched, so cpu_feature_enabled() reads the live bits; an
> 	+	 * interrupt in this window sees e.g. X86_FEATURE_LA57 as disabled.
> 	+	 */
> 	+	local_irq_save(flags);
> 	 	memset(&c->x86_capability, 0, sizeof(c->x86_capability));
> 	 #ifdef CONFIG_X86_VMX_FEATURE_NAMES
> 	 	memset(&c->vmx_capability, 0, sizeof(c->vmx_capability));
> 	 #endif
> 	 	generic_identify(c);
> 	+	local_irq_restore(flags);
> 
> save/restore keeps it correct for the secondary-CPU callers that already run
> with IRQs off.
> 
> I reproduced your splat with parallel TCG guests (-cpu max, kasan_multi_shot):
> ~10% of boots hit it, 0/~200 with the above.

Hi Kiryl, thank you for testing.

I thought of disabling IRQs here too, and AI bot flagged this as well [1].

I wasn't sure it'd be a good fix, because I don't know if it has any
undesirable consequences, and whether it's actually a complete fix.
For example, can a NMI hit this?

[1] https://lore.kernel.org/bpf/7b6d449f-c70c-4e8e-bfc4-a2f75517395c@linux.dev/

> 
> I am not sure how wide the irq-off window suppose to be. I scoped it to
> memset() .. generic_identify(), where LA57 is restored. Later code
> (apply_forced_caps(), ->c_init(), setup_sm*p()) only refines bits.
> 
> Widen it to be defensive, or keep it tight?

If we scope this narrowly, then it remains LA57-specific, because we protect
only a portion of the capabilities array.
IIUC to ensure x86_capability is "ready", a proper scope should be
entire identify_cpu(). And this may be a problem, because mcheck_cpu_init()
does kmalloc(GFP_KERNEL) [2], for example.

So I have doubts disabling IRQ is the right approach.

[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/cpu/mce/genpool.c?h=v7.1-rc7#n119

> 
> Any better solution?
> 

What if we define a static key for LA57 feature for KASAN?
This will avoid the performance hit we get with USE_EARLY_PGTABLE_L5.
And KASAN won't care about x86_capability being cleared.
Is that feasible/acceptable?

That will be a KASAN-specific LA57-specific fix however.
The underlying "capabilities are temporarily cleared on boot"
issue would remain. Although it wasn't a problem until this bug surfaced.

Something like this:

diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
index d7e33c7f096b..6c1ebcb4a417 100644
--- a/arch/x86/include/asm/kasan.h
+++ b/arch/x86/include/asm/kasan.h
@@ -36,6 +36,35 @@ static inline void kasan_populate_shadow_for_vaddr(void *va, size_t size,
                                                   int nid) { }
 #endif
 
+#ifdef CONFIG_KASAN_GENERIC
+#include <linux/jump_label.h>
+
+DECLARE_STATIC_KEY_TRUE(kasan_la57_enabled);
+
+#define addr_has_metadata addr_has_metadata
+static __always_inline bool addr_has_metadata(const void *addr)
+{
+       unsigned int shift = static_branch_likely(&kasan_la57_enabled) ? 56 : 47;
+
+       return (unsigned long)addr >= (-1UL << shift);
+}
+#endif /* CONFIG_KASAN_GENERIC */
+
 #endif
 
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a4268c47f2bc..79bad61f4891 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -28,6 +28,7 @@
 #include <linux/stackprotector.h>
 #include <linux/utsname.h>
 #include <linux/efi.h>
+#include <linux/kasan.h>
 
 #include <asm/alternative.h>
 #include <asm/cmdline.h>
@@ -2581,6 +2582,19 @@ void __init arch_cpu_finalize_init(void)
 {
        struct cpuinfo_x86 *c = this_cpu_ptr(&cpu_info);
 
+#ifdef CONFIG_KASAN_GENERIC
+       if (!__pgtable_l5_enabled)
+               static_branch_disable(&kasan_la57_enabled);
+#endif
+
        identify_boot_cpu();
 
        select_idle_routine();
diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 998b6010d6d3..3cb20b4d8799 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -11,6 +11,7 @@
 #include <linux/sched.h>
 #include <linux/sched/task.h>
 #include <linux/vmalloc.h>
+#include <linux/jump_label.h>
 
 #include <asm/e820/types.h>
 #include <asm/pgalloc.h>
@@ -20,6 +21,12 @@
 
 extern struct range pfn_mapped[E820_MAX_ENTRIES];
 
+DEFINE_STATIC_KEY_TRUE(kasan_la57_enabled);
+
 static p4d_t tmp_p4d_table[MAX_PTRS_PER_P4D] __initdata __aligned(PAGE_SIZE);
 
 static __init void *early_alloc(size_t size, int nid, bool should_panic)







