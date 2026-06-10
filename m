Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B855CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 21:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5146B0005; Wed, 10 Jun 2026 17:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C2D6B0088; Wed, 10 Jun 2026 17:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0ADB6B008C; Wed, 10 Jun 2026 17:55:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFE896B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:55:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E9C31402FA
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:55:53 +0000 (UTC)
X-FDA: 84865360986.11.71F9C63
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7496A100013
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:55:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NZx5kQWa;
	spf=pass (imf05.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781128551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Xq3T8jGSwlCoS9TBcLots22CwpjKVQ5tiqS1ynXAs0=;
	b=EEV2xByGG+8QQIJgDBJVxjY1uJTeQXZDUIFThqsliGjE/6y0rWMJns6bKAu+bNhDvfRVRu
	nzreJbiYj5jpj0qBgzoxHZstlOiWifaug1AvADkE7QBLN0z/8+AaJ/nAHgOnhTf8VY8r56
	lUnTAZun16y/uHjCVtt7DcmYmUZNRI4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781128551;
	b=AeQ9UufggZXxhe0Wdc5stkdtcqkLtlCiIf1O+t38j06HIg5XTEbjXwviJAClf27bywtQW1
	o2wu2A+qpLzqaZqeYtykNdFNHyPgvG3NDJm6qfS5SZ1rCwah7+x345q4iVelJ/CYttF96J
	bK1ocE4SJeC9ljgKtIXbPGRfgU2KuEM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NZx5kQWa;
	spf=pass (imf05.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <a56eebfa-9fac-44ca-a3a5-80c0a41bdebb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781128549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Xq3T8jGSwlCoS9TBcLots22CwpjKVQ5tiqS1ynXAs0=;
	b=NZx5kQWaP3w/38qQC11nz4BQvD9L76TDbmaNJ5n5o5iZ5epV6H+HYWaKJLB+m6YcrolrNB
	pxs2I/GGTwF6LVABh2E04hBajrRJpfvEXIbfWaB/Qt1H9MgDMg5mbL4syBW/TsJew6bs+m
	9M7v8eu16pO4qVkBmGyl78S+X4kc2No=
Date: Wed, 10 Jun 2026 14:55:42 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Eduard Zingerman
 <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, bpf@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260610175651.647515-1-ihor.solodrai@linux.dev>
 <CA+fCnZcRLZS4r=FBB6EX-G3+=X675q96hkdR_wLJexeuW-tPVw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ihor Solodrai <ihor.solodrai@linux.dev>
In-Reply-To: <CA+fCnZcRLZS4r=FBB6EX-G3+=X675q96hkdR_wLJexeuW-tPVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7496A100013
X-Stat-Signature: ja1qrmjzkm1bc7tw99o3sjpt68eqe8ma
X-HE-Tag: 1781128551-647049
X-HE-Meta: U2FsdGVkX1/R3D08MGDDJtkD5AedFS55++TpBa343TaM+33yvsZiZ3Cf1/v1EnU5C0OOnveC5PZ3AUspFRxq17Z0J7EEbYC9Xek8NpH+n2HoGHGkJ0hKLjktfuV8cAmcomijBUe+z4L3w36fHot+oNQ1Bf3dwsiJWqj3DeT2hw3Sbol+MWXbHXXSiwH2CdTA7E4OWToBQkTI8rg9KsqKy9fnbhwUB/AtMISqhXG3ldo0/g52uuvhInxbHKw2iQOLeW0BrVbB8zVvfn+ZssmSDA9a2lpe/NNM7+xrjJCkwbPtsYKQ1otZWA+QHULrRSYpyC1SlXwth5cdZu2vOjoqLBA8UXJ9gYad+3VSntRU0TE7C/daJPI3ZZE8GxCcanHf58HvDDiWpdhRI3f2BE1tp5cEGKMoHXS/l02ZX12CYcFzvXGKZ7zSwSvrz+sa9BcJTtzNy2A0WEKsmMZxf5II4oD0uFcuywU2pNdDZLYJYUfHJi8P+sm1mvSb//Wr8JPAqCAJL2KdgTulVa2jtFmAHqx0ifI5Lb0IjpBO4lkN8ha2QI6MRQM0I5w/KQrHQfP2WF2rJxHfo9FMrRQDEv3HfdiGTIztvG4doq5hnanxp2rEluWru8bxpgMf2R7646rGVt8lZTsY1bq+kLoPRSnkE9oNeQpMiLYw//9BrNwkHfdUDqugVLn4utu2NOBmvAakZ9pMxdyjZWJ15cpvqpU/0C2XQpXNrkQl4E7fLVdGhEuV9SRA3o66VquKoKjX7pbBiAazsiKSKqecQXfLl9ASR+VuzuIFevvMzUpDONNmAjW2g3Eyg80VvwPaFzXYnvb6GI4zgC9JflKjNY5ifYYH62M6lp8d6Np8HT51eV5ea9Y+Ekn65jb7vv5WWq7IlgqMNXWkhz9BcfWzMED/hqNKR0ILBq4eOAPQxe/dmI2X8JQ29mm2P9IfW5xYMda5gccGKur5kSheU2uqj1TKvvy
 xHbcj/vs
 kwekTRzK3OLD5FooP1H10C90icCRVSpS+OnkXwf2sFJzeFGiItIgftZCUyZzFnaSIvIvxzmB+KYPDGS1nKzEA+YQPO5uSj/F4jv69CKbrwS5PsecOQxCZ0Zd3GkraHAqeyqch35JI/hI6lxPWwm0A1ka9AEvFZ6jCv7p+KjzHXGE2WrhisUKq978+mSYeE0e4MEEQ8kZcm4YbXnRHV/R4iLxffevk5LO0ejc6K5PULXy6wNnfQf7/GgLe7fdmQSZ5qrMKt57wP5smqM/D21TUDh85Ce+P+GqxHYHIQptdu1QRVWIyCKOCIk0GK/57DvCu7Up3363zCmoB832jrA3mOD6EZHTJWHWFlojigVm6TAQvW/KLXXiLhU+cejn5JiOqSEl/6exzlNLByPIP8ayG1SkLkAN3vaLaSdDW/fJZ1/W0WKgfjvWNHWoaNGZb1JA3CaV2P7jpRAR7+0IZmg78gQ+b3TxO0KDSs1pmdK0KJiv9Q57r8GTj2RrUjVyknpVTlqaT9ilzZ75Z2lRnhoPe3IY8JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 11:39 AM, Andrey Konovalov wrote:
> On Wed, Jun 10, 2026 at 7:57 PM Ihor Solodrai <ihor.solodrai@linux.dev> wrote:
>>
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
> 
> It took me some digging to find which stable variable you refer to
> here; I think this needs to be better explained.

Hi Andrey, thank you for the quick review.

Yeah, it's:

  unsigned int __section(".data") __pgtable_l5_enabled;

I'll add more details in next revision.

> 
>>
>> Some context on how this was noticed and reproduced below.
>>
>> We started seeing flaky splats as above [2][3] on BPF CI runs after
>> runner hardware has been upgraded. Specifically, new x86 runners are
>> c7i.metal-24xl AWS EC2 instances, which are Intel Sapphire Rapids
>> machines that support LA57 feature, and have it enabled.
>>
>> The splats can be reproduced with qemu on any x86_64 host with
>>   -cpu max -accel tcg
>>
>> Build a kernel with:
>>   CONFIG_KASAN=y
>>   CONFIG_KASAN_GENERIC=y
>>   CONFIG_KASAN_INLINE=y
>>
>> Boot it with kasan_multi_shot. The fault fires fast before userspace,
>> so no rootfs is required. For example:
>>
>>   qemu-system-x86_64 -display none -serial stdio -no-reboot \
>>     -smp 4 -m 5G -cpu max -accel tcg \
>>     -kernel arch/x86/boot/bzImage \
>>     -append "console=ttyS0,115200 earlyprintk=serial,0,115200 panic=-1 kasan_multi_shot nokaslr"
>>
>> It's a timing race, so a single boot hits it only sometimes.
>> However running several qemu instances in parallel on the same host
>> significantly increases the hitrate.
>>
>> I confirmed the proposed fix eliminates the splats.
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/cpu/common.c?h=v7.1-rc7#n2001
>> [2] https://github.com/kernel-patches/bpf/actions/runs/27271262414/job/80542509369
>> [3] https://github.com/kernel-patches/bpf/actions/runs/27260143782/job/80505353689
>>
>> Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
>> ---
>>  mm/kasan/generic.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
>> index 2b8e73f5f6a7..b5f430f2dbb6 100644
>> --- a/mm/kasan/generic.c
>> +++ b/mm/kasan/generic.c
>> @@ -9,6 +9,13 @@
>>   *        Andrey Konovalov <andreyknvl@gmail.com>
>>   */
>>
>> +/*
>> + * check_region_inline() and addr_has_metadata() can run very early.
>> + * For example, in an interrupt taken while identify_cpu() has the CPU
>> + * capability bits temporarily cleared.
>> + */
>> +#define USE_EARLY_PGTABLE_L5
> 
> There are other users of addr_has_metadata(), besides ones in generic.c.
> 
> Thus, should we place this definition into mm/kasan/kasan.h? And
> likely guard it with ifdef KASAN_GENERIC || KASAN_SW_TAGS (HW_TAGS
> should not be affected by this AFAIU).

It appears setting USE_EARLY_PGTABLE_L5 in kasan.h will not work.

USE_EARLY_PGTABLE_L5 needs to be set before 
arch/x86/include/asm/pgtable_64_types.h is included, which is very early.

For example, it arrives to kasan/generic.c through a long path starting
at linux/interrupt.h:

   In file included from ./arch/x86/include/asm/pgtable_types.h:277,
                   from ./arch/x86/include/asm/processor.h:21,
                   from ./arch/x86/include/asm/cpufeature.h:5,
                   from ./arch/x86/include/asm/thread_info.h:59,
                   from ./include/linux/thread_info.h:62,
                   from ./include/linux/smp.h:119,
                   from ./include/linux/alloc_tag.h:14,
                   from ./include/linux/percpu.h:5,
                   from ./include/linux/context_tracking_state.h:5,
                   from ./include/linux/hardirq.h:5,
                   from ./include/linux/interrupt.h:11,
                   from mm/kasan/generic.c:13:

So if we want to cover all users of addr_has_metadata(), we'll have to
add #define USE_EARLY_PGTABLE_L5 in multiple files: generic.c, report.c,
report_generic.c, maybe others?

Any other ideas?

I determined the include path like follows:

cd linux # at 9716c086c8e8 torvalds/master
make defconfig
./scripts/config -e KASAN -e KASAN_GENERIC -e KASAN_INLINE
make olddefconfig
make mm/kasan/generic.i

# then modify pgtable_64_types.h

diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 7eb61ef6a185..c6b754143fb4 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _ASM_X86_PGTABLE_64_DEFS_H
 #define _ASM_X86_PGTABLE_64_DEFS_H
+#error TRACE
 
 #include <asm/sparsemem.h>

And then:
eval "$(grep '^savedcmd_' mm/kasan/.generic.i.cmd | head -1 | sed 's/^savedcmd_[^ ]* := //')"


> 
> And let's also extend the comment to explain better what's going on. I
> like the way the issue is explained here:
> 
> https://elixir.bootlin.com/linux/v7.0.12/source/arch/x86/boot/startup/sme.c#L36

ok

> 
>> +
>>  #include <linux/export.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/init.h>
>> --
>> 2.54.0
>>
>> --
>> You received this message because you are subscribed to the Google Groups "kasan-dev" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to kasan-dev+unsubscribe@googlegroups.com.
>> To view this discussion visit https://groups.google.com/d/msgid/kasan-dev/20260610175651.647515-1-ihor.solodrai%40linux.dev.


