Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E55CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71D816B0088; Mon, 22 Jun 2026 20:36:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6CC6B008A; Mon, 22 Jun 2026 20:36:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570A56B008C; Mon, 22 Jun 2026 20:36:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5256B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:36:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 80A998D262
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:36:28 +0000 (UTC)
X-FDA: 84909311256.12.BACE1AD
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf31.hostedemail.com (Postfix) with ESMTP id B8D7A20002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:36:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oSEJJOft;
	spf=pass (imf31.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782174986;
	b=WTNngZzOCazNmKL6tTkZ7fVe1HS+bM9/97XG8R/FBrizm+W0MzQZgK2nS3nR0bXqd9t0ug
	j1dOq1RXIQW1Q5QXPORIJFXEm/quJFDC+mogm9dXYrqh2h12EKuRHHIpZBNRtWDk6sCXK1
	YrlbIxpNvVRuIj3jNt0QEzcspI6frFA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782174986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eiVSLMbP5JKIaX7duhxu9i0pxEPSv8jIkF1+C1nDh/g=;
	b=HiEJyZOMyt/bcuAx7mj7uYeLkG2VBn/3IiO4yWtZFAbONMDBlokE+kCntZq/JIpFbPC8LV
	/ZFgMUX31P5CCkRdKJkcUnyEuLnAU8Nn8jmZ0kdG5u2UPZoQ7BrCehZqVGtfYHLK9PrgOa
	73vlW7GC66Ku3juhOaSNLAYIiUGCD+s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oSEJJOft;
	spf=pass (imf31.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <fdefc4f4-12d5-4c16-a452-3bdecd032176@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782174984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eiVSLMbP5JKIaX7duhxu9i0pxEPSv8jIkF1+C1nDh/g=;
	b=oSEJJOftTnWmG948iiJVXISS8aMMeb/h72Hkg3EPhrOrP/dXubbUousJmdRMIlI/DSKEBJ
	iSAPATuspskVqtyncqJuP8bz61ns61Ll26p4r8XK3fln1qu3SD1ct+Pfn5ps6tlXv2kDQ5
	Lr8avKCxtPtEatfKTzbqgabjTZsk3HI=
Date: Mon, 22 Jun 2026 17:35:50 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
To: Borislav Petkov <bp@alien8.de>
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Eduard Zingerman
 <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, bpf@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Andrey Konovalov <andreyknvl@gmail.com>
References: <20260610175651.647515-1-ihor.solodrai@linux.dev>
 <326b85af-c41a-4387-90a0-60720111934d@linux.dev>
 <20260618170913.GBajQmOQyOiBLqopUl@fat_crate.local>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ihor Solodrai <ihor.solodrai@linux.dev>
In-Reply-To: <20260618170913.GBajQmOQyOiBLqopUl@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B8D7A20002
X-Rspam-User: 
X-Stat-Signature: n7wca164ozr1xpazknkkny7u7okwh9pb
X-HE-Tag: 1782174986-439951
X-HE-Meta: U2FsdGVkX19DfgnmbzxDjNvM/meEZyNcSP649WSjdMsNCFZp1fVNyDkCDBRJZtdAfZUfaTXYAlhnn8A5X3rWSMhdjQ16TeEnCHwu3TgP7iPUYXykWHn8IWK7Vbxo3eWgbMdD7bfvqnloeA7LJ/380IbRKk0AhBotqAqA8LY7L2bbbkP/Z/N8+y/K1rl0BCrsocQy1SWWSqwJIVIUuy+2s6OoZwHTVD6IDaaKzBUDSBsU78HF6OczYiXexiE5imp7WEe3/2rFPJfcU/VuI0ePfeNjWVt07b/dg0twtE09yAAzdZjOKSbNxb1Xqx0IbQ+60sTTBFA12U6aK/a34GBABqIi8EL2uaY0N6f75LQnF2r7dXGkTwEvGvdNruk5OYQdlTJj5OpT0qxLKBElD1AGhzpldpbLbWzIGeQomSckV8P4dyfP/b+N8ZpWdxUlSaAwx7eP02Hr0iuK9Z68Uil5+6b6t0HiJpKv6nJ0Fi+XMVcNhTfDQN9BDdvEUplt74gA9dJ41jr9mE3f3xHzK7EV4CqeEEpfk6lNxtG4kPRKhEXWAapz1kE2tvVB8UyT/K5MIDNGY0JgtI1t/oR6Rrhj+/XbUHxnik8HebnDGKlRjNZfCpMQyS8TOngwhEj6Q6u40A0gbOFBu8+SGNiQwvNNy2qVqvvxwEq9XMe+PcfNPnA1s5flC5sRZVO3Rl5LJdwlUVxwHfSrfqbp4yRbO59M3CJ5WdKxsoHMjtMnp2hgbmCLEh4mNPiGDYZg1tMToWYk1lzxqbY0crRnMTPfDGL5Hlz8y8QJiNWfkhDtf9Xjm0EmEKqJbUFLpNlycYHrUtSE4aiWpAAbOgb1FtuXCBe9BSSMQamdKHSc7woiw6jhyV3P6GlanzpEd/vx3CtU8FZaSqkWySCqg9/lpfqsvXagQUUHkImFayC6U7ypZvs6NfO4wWWa7S13xLGD6QxsqvM2t5DUBo7AJ/cFTk+jY6H
 cTB/eS9+
 VO0bgSCAjdIgk5IwdkElxiomcS1Ib0Umd25GOlxXb5wwze+YOgHrT10a730v94KtUvIOZiloVgzqZgwfHfPMYRIJ3RzBcnLYBUJ6kL6aX/V6C2Of/03ldPKyCFLsrO0L4kT5Gxz+p4IpJbkD0b4yYCe4LC0aDeLscE86kBpD5pWQdNJWe1PyKhxA3iDerJvWpGmG0ZqPsGX76bQITEFdsjO9GCIgoOQuLaf7yPlpjT61JnjHBv0X8H15+1v8iuZAd01lF6qWZWM7tn4Rm8sux4nKoXJWlQSU4Gp7kdbsX8Q8TFA78JTJlYMvz9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 10:09 AM, Borislav Petkov wrote:
> On Wed, Jun 17, 2026 at 03:13:33PM -0700, Ihor Solodrai wrote:
>> So my question to maintainers is what approach seems best?
> 
> The CPUID stuff is being rewritten currently and it should address your issue
> too. If not, then we need to rewrite it better.
> 
> Can you reproduce with this set applied ontop:
> 
> https://lore.kernel.org/r/20260528153923.403473-1-darwi@linutronix.de

Yes, the issue reproduces with this series.

Here is a splat:

[    1.554117] BUG: KASAN: wild-memory-access in do_raw_spin_lock+0x121/0x270
[    1.554117] Write of size 4 at addr ff110001000d10b8 by task swapper/0/0
[    1.554117] 
[    1.554117] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.1.0-00120-g0f76bd3ff8c1 #19 PREEMPT(full) 
[    1.554117] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-5.el9 11/05/2023
[    1.554117] Call Trace:
[    1.554117]  <IRQ>
[    1.554117]  dump_stack_lvl+0x68/0xa0
[    1.554117]  ? do_raw_spin_lock+0x121/0x270
[    1.554117]  kasan_report+0xca/0x100
[    1.554117]  ? do_raw_spin_lock+0x121/0x270
[    1.554117]  kasan_check_range+0x39/0x1c0
[    1.554117]  do_raw_spin_lock+0x121/0x270
[    1.554117]  ? __pfx_do_raw_spin_lock+0x10/0x10
[    1.554117]  handle_edge_irq+0x34/0x8b0
[    1.554117]  __common_interrupt+0x6e/0x170
[    1.554117]  common_interrupt+0x77/0xa0
[    1.554117]  </IRQ>
[    1.554117]  <TASK>
[    1.554117]  asm_common_interrupt+0x26/0x40
[    1.554117] RIP: 0010:__cpuid_reset_table+0xf7/0x7b0
[    1.554117] Code: 49 8d 7e 0c 45 8b 46 08 48 89 f8 48 c1 e8 03 4a 8d 2c 03 48 89 6c 24 68 42 0f b6 14 38 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 <84> d2 0f 85 da 04 00 00 45 8b 4e 0c 4c 89 f0 48 c1 e8 03 49 01 d9
[    1.554117] RSP: 0000:ffffffff84c07d98 EFLAGS: 00010202
[    1.554117] RAX: 0000000000000007 RBX: ffffffff85a7c990 RCX: 0000000000000000
[    1.554117] RDX: 0000000000000000 RSI: fffffbfff0b4f91c RDI: ffffffff83c2dcac
[    1.554117] RBP: ffffffff85a7c990 R08: 0000000000000000 R09: 0000000000000001
[    1.554117] R10: ffffffff85a7c8ec R11: 0000000000000000 R12: 000000000000ffff
[    1.554117] R13: ffffffff85a7c990 R14: ffffffff83c2dca0 R15: dffffc0000000000
[    1.554117]  ? __pfx___cpuid_reset_table+0x10/0x10
[    1.554117]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
[    1.554117]  cpuid_scan_cpu_early+0x5a/0xd0
[    1.554117]  identify_cpu+0x2c1/0x13e0
[    1.554117]  ? lock_release+0xc9/0x290
[    1.554117]  arch_cpu_finalize_init+0x25/0x3c0
[    1.554117]  start_kernel+0x304/0x3f0
[    1.554117]  x86_64_start_reservations+0x18/0x30
[    1.554117]  x86_64_start_kernel+0x116/0x130
[    1.554117]  common_startup_64+0x12c/0x138
[    1.554117]  </TASK>

> 
> ?
> 


