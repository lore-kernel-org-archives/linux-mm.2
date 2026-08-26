Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB1EC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 01:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F5E26B0088; Tue, 25 Aug 2026 21:07:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7AC6B008A; Tue, 25 Aug 2026 21:07:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7F26B008C; Tue, 25 Aug 2026 21:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C97BE6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:07:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E03640147
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:07:58 +0000 (UTC)
X-FDA: 85141633836.04.33D6571
Received: from quail.birch.relay.mailchannels.net (quail.birch.relay.mailchannels.net [23.83.209.151])
	by imf02.hostedemail.com (Postfix) with ESMTP id A8B6280005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:07:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=qck9ykgG;
	dmarc=none;
	spf=softfail (imf02.hostedemail.com: 23.83.209.151 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787706476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMsnr23HP9lPV0KenSxGVhzn+g2nKrwYjINjwE+8ptg=;
	b=YA/MVc91VMGhmqV9VL7VX2C8H2r1uGitUcVbV4emSwgD6COC7JgA+FJKKAOUyaOfLbMI35
	NbqCgii5V83bromVkwce7Nqzgp30fJRka/+2TEkhtdlQLAWqocYoM2jWQj8HVDk8pBv2dO
	TSsJBoPTKVTlOwg+hY/682WvHY/PBec=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=qck9ykgG;
	dmarc=none;
	spf=softfail (imf02.hostedemail.com: 23.83.209.151 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787706476;
	b=1MeMkxI9Au/bhIn+7qeW9X4bsWhMOYF1dYmupQ92iImuALLvbJy6MXPcRgdFcnBD4iQudY
	TFdm2jPjh/qJJqzeLQJ79vABO+p7X+VK619WUh0ROPENmuif4/T5vLehHgX0qBPUvAIv7G
	bo3cXF/jqi7Tiqts+im7D36YsDX09Lo=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 459984C0B62;
	Wed, 26 Aug 2026 01:07:54 +0000 (UTC)
Received: from pdx1-sub0-mail-a204.dreamhost.com (100-96-49-23.trex-nlb.outbound.svc.cluster.local [100.96.49.23])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 5A7254C0BBC;
	Wed, 26 Aug 2026 01:07:53 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Whispering-Illustrious: 4311d38559935212_1787706474061_3231139894
X-MC-Loop-Signature: 1787706474061:2906846316
X-MC-Ingress-Time: 1787706474060
Received: from pdx1-sub0-mail-a204.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.49.23 (trex/8.0.2);
	Wed, 26 Aug 2026 01:07:54 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a204.dreamhost.com (Postfix) with ESMTPSA id 4hV62Z53fJz1V;
	Tue, 25 Aug 2026 18:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1787706473;
	bh=eMsnr23HP9lPV0KenSxGVhzn+g2nKrwYjINjwE+8ptg=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=qck9ykgGD0FDGfMzf8lMjKxEz2+IBhaxPzncYO2JYJfqf03CmHex1/UlCDMf3GXeu
	 VBZ/D3+6NvU6kWUg4PUXEXnHXcMQpeEMv7muhjd1vcVORYpndgy/RedANS6aeWj1Hc
	 f6rLBX+goLntJYBBIQzXf3HnBpXEJOQaxYeBYo6ekiNBFNBAoIisqODuQSYnzeRFg+
	 mhM6EAjJlVen2M8PK8NxTfciUBwxLj2cYY8b3rUmn9mQfPjkBm3nQ10icYXGbTX07J
	 60k8ivrsNekvlJSNVkIE9VYGeAwYthFwpzuSvo1KhoCHJa0vcB6dUkFNAI+3H6yElh
	 LcL757Rqy4zxw==
Date: Tue, 25 Aug 2026 18:07:48 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr, dennis@kernel.org, tj@kernel.org, cl@gentwo.org,
	ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
	martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com,
	song@kernel.org, yonghong.song@linux.dev, jolsa@kernel.org,
	bjorn@kernel.org, pulehui@huawei.com, puranjay@kernel.org,
	thuth@redhat.com, ajones@ventanamicro.com,
	ben.dooks@codethink.co.uk, rkrcmar@ventanamicro.com,
	samuel.holland@sifive.com, zong.li@sifive.com,
	conor.dooley@microchip.com, tglx@kernel.org, debug@rivosinc.com,
	seanwascoding@gmail.com, andybnac@gmail.com,
	menglong8.dong@gmail.com, cyrilbur@tenstorrent.com,
	wangruikang@iscas.ac.cn, atishp@rivosinc.com,
	apatel@ventanamicro.com, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	bpf@vger.kernel.org, arnd@arndb.de, nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com, morbo@google.com,
	justinstitt@google.com, qingfang.deng@siflower.com.cn,
	linux-arch@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v8 2/3] riscv: introduce percpu.h into include/asm
Message-ID: <20260826010748.zphu3wh2hlm4t4o2@offworld>
References: <20260703122832.15984-1-cuiyunhui@bytedance.com>
 <20260703122832.15984-3-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260703122832.15984-3-cuiyunhui@bytedance.com>
User-Agent: NeoMutt/20220429
X-Stat-Signature: 1bg4g5mtdntg3ghshr11h3k3rjwy4gjq
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A8B6280005
X-Rspam-User: 
X-HE-Tag: 1787706475-838194
X-HE-Meta: U2FsdGVkX1/czlziQP5FdarBgflb2TCtTeuhjAgedtAibtBG++5Ui1z2N6kUFk3CNpgKx60TNcLkSZxP/gVKWpucop/A3+hv55N3PhPHsIcyt+p07tWz/RxUexCpTEinR3u/SeQ7qrwVwFvWSILFI3O92nGppmL8RI0TnivLyUK6eH8w2uR+mRjt56VRkMt7h0GkvI62GI193UcUkZ1GjB/GfYnjgeQ+7SqdXAg6k2g9OjTrZ6SkOGMbQwH1NMe1YXbHBJqM4PPjFVCaNey8+kY8v73iX/+T87OLnMFJ7UGo74rU3AcMzO7vG+I9E+RnFLtE4OV66bqeOFwIB9nGVAyGvrUPjYn5ra2SR5SRmQolnSCzsLg/ngWQ1kVEuQgyztUTASlM4Ol9Qdyc6FPHp8oz/j+O6LhdreC5SmcUjfBq6jgxez4hSKBDzHTfzo24e2aWk4l1oKs8Xn5Xvg9i96o1YU7w4JLN6VJwHDY1YSNGSPkGW3et/Iqg+aVEldTPyULjL6m3n9E3k+RXe+ndyfzYbUCiX+jbS6fF1UlztWXat3QOKTxrJ//fEg7kmZXIaT0k1MJtA+NgfdK5jcYR24EJvJAviDUCvQYX3qNsuEMsOA9VtKOKSnno0heI3G5QI0PbIsEnzvLVxEd/Z5Rp7gJ2YzP7WdK3BpxwPQeypGgcpTYmxHxwSoVcu2pkirVHWRQJqVDJKRgb9v+YT5NXGnwtwbBAbj8ogoLiRaMVrDbCFk0akiYI1CmJGvec98KCdlF1OYwrwSqUIm0HQTYnlmcJHLTTOzEOy5owchFTZzR/+AWUinMwF9IGD8U7rvEUA0AXqfUP8illyzdM4LKjQ0goMeYbA5HWOcQLXhq0Qmj/pJXne2Njyt/tMk7DyEezEkwLIzJ+JQ7XjxKZlDivjSfumO7TjojlAIVqPUJfOBjOd1jyw2YixC/ruVGSEHTlBvnZtX220nAWPX8wBD6
 je9SciPD
 ZQWroeI2iOANkhwytBlYtFLyPm4/SpU2+5O1BrfX1zjo9kkn9ii2EhS28viDVvGOCMdlqLGAh5TnyQGVgOmaIMlebXicNXrsLTpBFbs4etvpwBJSUSqGHnfrLNP0jgGGaZTMV4dMjfFnqwWDKxdkffF0CivtbHKLjqHQyum3Kn957uuoUdVN/RTnVs7YU5p6yrruHgqujEBKBX84W9UTT+stL6dpjwf1twgkASSKaykf9uC2PqRgBIJEY3++va3/vUw1AU5qBd6EOsZu1QBAJjSCYPhJ5FAvB9M8tl2nbZIlHb99NeUKMgyGQiXhbwnT00puOoq269v9ywG+Y+FMR2c/veRdQmPSc0xSmwzh+C46hJbfWIvN0WWCVEJEapqpIJYevQOgGa/hnOH5huZqHPbKZSTPYkfrs9Bst3n3wAfPYaToc67Z9VAlS0sU66chtNaKazcvZOow2SoLKKauVFq4UxA8XrbWrxgIwQMgsLntr6AY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 03 Jul 2026, Yunhui Cui wrote:

>Add RISC-V specific this_cpu helpers so common percpu operations can use
>short architecture sequences instead of the generic implementation.
>Native-width operations use AMOs, while 8/16-bit operations use Zabha when
>available and a local 32-bit LR/SC fallback otherwise.

The subject and changelog could use some improvement. How about:

riscv: implement this_cpu operations

riscv has no asm/percpu.h, so every this_cpu_*() read-modify-write
takes the generic fallback, which disables local irqs.

A single AMO is atomic with respect to interrupts on the local hart,
so this can be replaced by one relaxed AMO under preemption disabled.
Native-width operations use AMOs, while 8/16-bit operations use Zabha when
available, or a local LR/SC sequence otherwise.

Some comments below, but I ran this on my sifive p550, feel free to add my:

Tested-by: Davidlohr Bueso <dave@stgolabs.net>

>
>Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
>---
> arch/riscv/include/asm/percpu.h | 296 ++++++++++++++++++++++++++++++++
> 1 file changed, 296 insertions(+)
> create mode 100644 arch/riscv/include/asm/percpu.h
>
>diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
>new file mode 100644
>index 0000000000000..76b1b8c1fb953
>--- /dev/null
>+++ b/arch/riscv/include/asm/percpu.h
>@@ -0,0 +1,296 @@
>+/* SPDX-License-Identifier: GPL-2.0-or-later */
>+
>+#ifndef __ASM_PERCPU_H
>+#define __ASM_PERCPU_H
>+
>+#include <linux/bits.h>
>+#include <linux/preempt.h>
>+
>+#include <asm/alternative-macros.h>
>+#include <asm/cmpxchg.h>
>+#include <asm/cpufeature-macros.h>
>+#include <asm/hwcap.h>
>+
>+#define PERCPU_RW_OPS(sz)						\
>+static inline unsigned long __percpu_read_##sz(void *ptr)		\
>+{									\
>+	return READ_ONCE(*(u##sz *)ptr);				\
>+}									\
>+									\
>+static inline void __percpu_write_##sz(void *ptr, unsigned long val)	\
>+{									\
>+	WRITE_ONCE(*(u##sz *)ptr, (u##sz)val);				\
>+}
>+
>+PERCPU_RW_OPS(8)
>+PERCPU_RW_OPS(16)
>+PERCPU_RW_OPS(32)
>+
>+#ifdef CONFIG_64BIT
>+PERCPU_RW_OPS(64)
>+#endif
>+
>+#define __PERCPU_AMO_OP_CASE(sfx, name, sz, amo_insn)			\
>+static inline void							\
>+__percpu_##name##_amo_case_##sz(void *ptr, unsigned long val)		\
>+{									\
>+	asm volatile (							\
>+		"amo" #amo_insn #sfx " zero, %[val], %[ptr]"		\

So afaict that rd=zero could steer the AMO away from the hart, no? From the
Zaamo chapter, it notes that complex implementations "might also implement
AMOs at memory controllers, and can optimize away fetching the original value
when the destination is x0". Similar for the others (PERCPU_8_16_OP).

Maybe use a tmp register instead and force the old value from L1 ("near"):

	u##sz tmp;
	asm volatile (
		"amo" #amo_insn #sfx " %[tmp], %[val], %[ptr]"
		: [ptr] "+A" (*(u##sz *)ptr), [tmp] "=r" (tmp)
		: [val] "r" ((u##sz)(val)));


... which arm64 now does for its pcpu ops:

	/*
	 * Use value-returning atomics for CPU-local ops as they are
	 * more likely to execute "near" to the CPU (e.g. in L1$).
	 *
	 * https://lore.kernel.org/r/e7d539ed-ced0-4b96-8ecd-048a5b803b85@paulmck-laptop
	 */

>+		: [ptr] "+A" (*(u##sz *)ptr)				\
>+		: [val] "r" ((u##sz)(val))				\
>+		: "memory");						\

Should not need this clobber either - these don't imply barriers (but you also get
them with the preemption disable/enable).

>+}
>+

...

>+#define this_cpu_cmpxchg_1(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)

This triggers that cmpxchg variable shadowing issue you mentioned in patch 1 with
that __cpu_fallback_try_cmpxchg also using '__old'.

>+#define this_cpu_cmpxchg_2(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
>+#define this_cpu_cmpxchg_4(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
>+
>+#ifdef CONFIG_64BIT
>+#define this_cpu_cmpxchg_8(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
>+
>+#define this_cpu_cmpxchg64(pcp, o, n)	this_cpu_cmpxchg_8(pcp, o, n)
>+#endif
>+
>+#ifdef system_has_cmpxchg128
>+#define this_cpu_cmpxchg128(pcp, o, n)					\
>+({									\
>+	u128 ret__;							\
>+	typeof(pcp) *ptr__;						\
>+									\
>+	preempt_disable_notrace();					\
>+	ptr__ = raw_cpu_ptr(&(pcp));					\
>+	if (system_has_cmpxchg128())					\
>+		ret__ = cmpxchg128_local(ptr__, (o), (n));		\
>+	else								\
>+		ret__ = this_cpu_generic_cmpxchg(pcp, (o), (n));	\
>+	preempt_enable_notrace();					\
>+	ret__;								\
>+})

With those above this_cpu_cmpxchg() you could now enable HAVE_CMPXCHG_LOCAL.

Thanks,
Davidlohr

