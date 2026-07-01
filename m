Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 164BDC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 05:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB3E76B00A6; Wed,  1 Jul 2026 01:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B63C46B00A8; Wed,  1 Jul 2026 01:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7ADD6B00A9; Wed,  1 Jul 2026 01:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9DD6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:06:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EABC2120217
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:05:59 +0000 (UTC)
X-FDA: 84939020838.03.DF7F624
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 568C140006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:05:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=mRXPPDS0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782882358;
	b=fpSJHKsbq0+FZxupKj1+qJTp3FMQFjLjKJCM6319QRTUkuJPRJl6U6Sb76h4K3CiwkCp9v
	8zv79bYWUPaoaTM722/V1sZjiZGZFU+E9dsoeqSQjIzwyKYWdOqZyV2O0hCEmqgGIIkLWi
	Q5wpTFxOnce65RH1oCPjT9pBRbv+DgI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782882358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cR1e3wgK4GDElvt4FzjPKvAbM9xG45FsEr5FNPN0UPE=;
	b=QBI2T641zRxtDltQP4eCKU1+QFzHy28rOOUwTcKB1u6czGKL3qTv0w2uVyYV6+WFYBi6eH
	5+0xWZNQFV8kQA2vgpW9OMnhrwLNr5EbSesBe5mfRs0zuWsQg2yYJlJkopCdIjgiHiGD1d
	vHO7ArCLqS9XrmhFCmJPyf5ndd8NqvM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=mRXPPDS0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A20F435D5;
	Wed,  1 Jul 2026 05:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F4D1F000E9;
	Wed,  1 Jul 2026 05:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782882357;
	bh=cR1e3wgK4GDElvt4FzjPKvAbM9xG45FsEr5FNPN0UPE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=mRXPPDS0ZZjbX/ABIk8RUZppNUKF2fdO+GefAa2ypmx1NYKWKqfKz6gkbybOlP9El
	 Fsq1M/qn7hn6nUob/mTvGscUqIhCvWtpQxLlXRyVZpf7l3N+dLRu41rfRKAd9ROi7S
	 PprfyhyxOIoPj2rM5rUT+Uyvt25W3eC7DMjzbpyz69Oo/cwcCuwLJSCPH747I/ulFy
	 Zy50Tj8K1lcvUxHAaDO8kDI6oNYQ/nxp3XoZ6L1zuxP2ZIQfz1YjhRqJ/VBnqG+I1B
	 TleHoSF3LcqFyOSkj4KFCE+uHtseQYfeUW6v1CEY1rBTHOS4oiiKYk6pz3bjWeCD5u
	 OcZpLy/5jMOGg==
Content-Type: multipart/mixed; boundary="===============4104290110149668795=="
MIME-Version: 1.0
Message-Id: <bf03528b891e5f09ec46d075649474ce5f2228e80afe1d6fe5481789e9dca9d3@mail.kernel.org>
In-Reply-To: <d6afed2c271de42efe2a3580ea30c7601cae9c0c.1782877663.git.cuiyunhui@bytedance.com>
References: <d6afed2c271de42efe2a3580ea30c7601cae9c0c.1782877663.git.cuiyunhui@bytedance.com>
Subject: Re: [PATCH v5 2/3] riscv: introduce percpu.h into include/asm
From: bot+bpf-ci@kernel.org
To: cuiyunhui@bytedance.com, pjw@kernel.org, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, alex@ghiti.fr, dennis@kernel.org,
	tj@kernel.org, cl@gentwo.org, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com,
	memxor@gmail.com, song@kernel.org, yonghong.song@linux.dev,
	jolsa@kernel.org, bjorn@kernel.org, pulehui@huawei.com,
	puranjay@kernel.org, thuth@redhat.com, ajones@ventanamicro.com,
	ben.dooks@codethink.co.uk, rkrcmar@ventanamicro.com,
	cuiyunhui@bytedance.com, samuel.holland@sifive.com,
	zong.li@sifive.com, conor.dooley@microchip.com, tglx@kernel.org,
	debug@rivosinc.com, seanwascoding@gmail.com, andybnac@gmail.com,
	menglong8.dong@gmail.com, cyrilbur@tenstorrent.com,
	wangruikang@iscas.ac.cn, atishp@rivosinc.com,
	apatel@ventanamicro.com, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	bpf@vger.kernel.org, arnd@arndb.de, nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com, morbo@google.com,
	justinstitt@google.com, qingfang.deng@siflower.com.cn,
	linux-arch@vg.kvack.org, er.kernel.org@kvack.org,
	llvm@lists.linux.dev
Cc: ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed,  1 Jul 2026 05:05:56 +0000 (UTC)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 568C140006
X-Rspam-User: 
X-Stat-Signature: 6xjyjb5ok19b45jwzeijoj96fesfoz7p
X-HE-Tag: 1782882358-778805
X-HE-Meta: U2FsdGVkX19KlatbF12Lyh3WFD+BaajXH/yKx0RtuYQxCo38dvU+gEfCLilJ/9wWYIgOkqq1zN+3I3IIS+heixxUK++ENmWr4809C/NuC+Sq/alohCK6PDl/YsolDuCNcRxKKDAvyfrTnfPk/X+L9Xef+OgbM25X8jfR5I6Ic5gIcTrWZEj/WZFuvv8gOwq/foiT9nFNVIs09hNzOcWGjdr85dEBaA2m1simNVknI5Fo2w70v75HMir6LtrpgVqYOldJ9yoNHiklZV56ZvF0Ko+dI50avcuoABLENOr7o8c5y0Nw9hp+WSKoxUlaIp1YqoMYlJzfFVafWVs2cULHXR9uVINdopudlIV9x4DWcjDm4UalRrgMHv2GH5j6fuxSJsjvwSLxhQfR5eK7QX6+qn1UdkxkGLBHe2PmxNMf88/LVjuRJXdtjvF2D69VRfiyiAAUW4Q2O7tzPKlVhv5SzQyLA6hWNCGy/Ls3x9MciB/4lKgs9mOrYv2yf9Xj1vGbmW3SNhitcfafvk/APrdq8P4usWDYadRDZEZt1iK4jro+Q3Y3Sw8qsSdr65msEN+C8CdY0Jh9aPkCACAntEIeiUWL61WFIjBcWJdLOEKcoG6AbsYo69ar+s1GV8B8a9N56TfqqbNndRq3Jaihl/kMobDam3qQdf3JHAwJW3HRBK78iIDzUZ533+YoE9+9MhnTXX8UKkPMCCfh3ieoxQmFncoAKiRJ0yciGs84/PO3gZ3sYK8vm53LkrF371Rw4+GgWEWVdH7nRuHP7knHQnAKx/jUdW6W/1YfMuovDprsJxLsr52kJgqOriLQlT9RM4FVbUTwbau8QCgC2CsehuxJvfp0ZiWSKfFuGbQdDnbDqtWTg9xhqFPOQKRXv21J1Az90rFw4LiyiB/YTrkEohp1oALdnHEaJnGT6Nji1fo5aFYJIF46pDSki1c0u0Ygzz9/luSy13+7D00mxAaYP+B
 NhtZ+0Wb
 58T6nns0SOsm+oU/hVOYWGLkCimhBBjtF3FNxh3/Nm8gxj/ZFpSv9M1yi6VimMqHiPm59u3HC0YEcyA0vid+5JITJ6pOWruMbRo7U6Fmqw8Ob4DQPfedO1NbdnPukQV2Ulf0ESryxyEe95quzC0kTuw3E95eSobLFjBZfh473OOwMvBQHRYO9lxFfdOIyUdicskaMBjLGC3YgRK+axr7hsz3gTSHxpo02PrW3v0f5tYUsidn3hTt9EZS03RlWVNxvQk29O561cTX8xsBBXfvAonwccrnP54JcV7Gze5Q5yu/CKK5yeqN96v73tyW6Hst/7D6e1t/E5olUwhlpYK7O+z9+X/aeWyk6J/SI39jOMpg44KDnG6QJ+LZlWssOyAzdOuQDPtoG+Zce+GZhiL7u2k4ARR1e6ZOEBxrN8t1lj97XkwRSYVsEp2Epdmtj4EMUAvrSEfpqk8JKum5S8MxMd/lkbossECd/BeRrbG8zjVixJtR44uwIdR8U+iBZ8lPHzB2HrmkZaixDa9w6P6Go0EbgXvnjOdQcmHwLmLCRHzhvy6uTiv93UfDaVeyHI8kSrJe4NI+1Pww/9FaF2krypdcOUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4104290110149668795==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
> new file mode 100644
> index 000000000000..46f1901d3bb8
> --- /dev/null
> +++ b/arch/riscv/include/asm/percpu.h
> @@ -0,0 +1,283 @@

[ ... ]

> +#define PERCPU_8_16_OP(name, amo_insn, sz, sfx, val_type, new_val_expr, asm_op)			\
> +static inline void __percpu_##name##_amo_case_##sz(void *ptr, unsigned long val)		\
> +{												\
> +	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&						\
> +		riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {				\
> +		asm volatile ("amo" #amo_insn #sfx " zero, %[val], %[ptr]"			\
> +			: [ptr] "+A"(*(val_type *)ptr)						\
> +			: [val] "r"((val_type)((new_val_expr) & PERCPU_8_16_GET_MASK(sz)))	\
> +			: "memory");								\
> +	} else {										\
> +		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);					\
> +		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);				\
> +		const u32 mask = PERCPU_8_16_GET_MASK(sz) << shift;				\
> +		const val_type val_trunc = (val_type)((new_val_expr)				\
> +					   & PERCPU_8_16_GET_MASK(sz));				\
> +		u32 retx, rc;									\
> +		val_type new_val_type;								\
> +												\
> +		asm volatile (									\
> +			"0: lr.w %0, %2\n"							\
> +			"and %3, %0, %4\n"							\
> +			"srl %3, %3, %5\n"							\
> +			#asm_op " %3, %3, %6\n"							\
> +			"and %3, %3, %8\n"						\
> +			"sll %3, %3, %5\n"							\
> +			"and %1, %0, %7\n"							\
> +			"or %1, %1, %3\n"							\
> +			"sc.w %1, %1, %2\n"							\
> +			"bnez %1, 0b\n"								\
> +			: "=&r"(retx), "=&r"(rc), "+A"(*ptr32), "=&r"(new_val_type)		\
> +			: "r"(mask), "r"(shift), "r"(val_trunc), "r"(~mask),			\
> +			  "r"(PERCPU_8_16_GET_MASK(sz))						\
> +			: "memory");								\
> +		}										\
> +}

[ ... ]

> +#define PERCPU_8_16_RET_OP(name, amo_insn, sz, sfx, val_type, new_val_expr)			\
> +static inline val_type __percpu_##name##_return_amo_case_##sz(void *ptr, unsigned long val)	\
> +{												\
> +	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&						\
> +		riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {				\
> +		register val_type ret;								\
> +		asm volatile ("amo" #amo_insn #sfx " %[ret], %[val], %[ptr]"			\
> +			: [ptr] "+A"(*(val_type *)ptr), [ret] "=r"(ret)				\
> +			: [val] "r"((val_type)((new_val_expr) & PERCPU_8_16_GET_MASK(sz)))	\
> +			: "memory");								\
> +		return ret + (val_type)((new_val_expr) & PERCPU_8_16_GET_MASK(sz));		\
> +	} else {										\
> +		u32 *ptr32 = PERCPU_8_16_GET_PTR32(ptr);					\
> +		const unsigned long shift = PERCPU_8_16_GET_SHIFT(ptr);				\
> +		const u32 mask = (PERCPU_8_16_GET_MASK(sz) << shift);				\
> +		const u32 inv_mask = ~mask;							\
> +		const val_type val_trunc = (val_type)((new_val_expr)				\
> +					   & PERCPU_8_16_GET_MASK(sz));				\
> +		u32 old, new, tmp;								\

This isn't a bug, but the two LR/SC fallback loops name the same roles
differently.  The non-return loop uses:

	u32 retx, rc;
	val_type new_val_type;

while the return loop above uses:

	u32 old, new, tmp;

The loaded word, the scratch/merge register and the computed field play the
same role in both loops.  Could they use one consistent set of names (e.g.
old/new/tmp) so the two loops read as clearly parallel?  As a smaller point,
new_val_type reads like a type name rather than a value, and new shadows a
common keyword.

> +												\
> +		asm volatile (									\
> +			"0: lr.w %0, %3\n"							\
> +			"and %1, %0, %4\n"							\
> +			"srl %1, %1, %5\n"							\
> +			"add %1, %1, %6\n"							\
> +			"and %1, %1, %7\n"							\
> +			"sll %1, %1, %5\n"							\
> +			"and %2, %0, %8\n"							\
> +			"or %2, %2, %1\n"							\
> +			"sc.w %2, %2, %3\n"							\
> +			"bnez %2, 0b\n"								\

This isn't a bug, but the read-modify-write LR/SC sequence here is nearly
identical to the one in PERCPU_8_16_OP, differing only in operand numbering.
The non-return loop parameterises the operation via #asm_op, but this loop
hardcodes add:

	"add %1, %1, %6\n"

Was the intent to keep the return path add-only, or could the two loops share
one templated sequence?

> +			: "=&r"(old), "=&r"(tmp), "=&r"(new), "+A"(*ptr32)			\
> +			: "r"(mask), "r"(shift), "r"(val_trunc), "r"(PERCPU_8_16_GET_MASK(sz)), \
> +			"r"(inv_mask)								\
> +			: "memory");								\
> +		return (val_type)(tmp >> shift);						\
> +	}											\
> +}

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/28494034360
--===============4104290110149668795==--

