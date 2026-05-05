Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBCD4CD13DA
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 07:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9AA6B0093; Tue,  5 May 2026 03:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533046B0095; Tue,  5 May 2026 03:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FA826B0096; Tue,  5 May 2026 03:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A0706B0093
	for <linux-mm@kvack.org>; Tue,  5 May 2026 03:20:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAFA91A044F
	for <linux-mm@kvack.org>; Tue,  5 May 2026 07:20:08 +0000 (UTC)
X-FDA: 84732517296.07.F519D69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id EBE7680013
	for <linux-mm@kvack.org>; Tue,  5 May 2026 07:20:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=UbYVNIBE;
	spf=pass (imf30.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777965607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vrj5b4WOphu6fINKSrfQVerPtRmyNP0BzBawTpQyOOw=;
	b=RhWPdaODEiou/xL72hnXko6SPUze8wbppnCAc1eN+OuduPf0rDuRXvvMKHSmxWtq9CEeVH
	fdHIG5Q0GaEY4y99Mms8MnRdUZGuwVYg5cDgjmuBhVBmk4EhwPOVonoky/WMSEy5c72ieR
	aStwPdMgpuoUkzcz+HsXzRetk8PhW84=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777965607; a=rsa-sha256;
	cv=none;
	b=xBzH+FDjZovyhJ6LIQPqCMgkOwQun0DXkUx2a5auCfsmj9U5EqpvF27iKKCdBAOypSnPok
	soKDbS6+VKkOufuSyD3h0mNkrmVcXB5HHcipv7k/fCqSrv5ZLkXJXcrWxYrUgklXDq+DSo
	osWuec3fPGn121+/UZpq9c0dPJOEdXM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20201202 header.b=UbYVNIBE;
	spf=pass (imf30.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 73D9460128;
	Tue,  5 May 2026 07:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2729FC2BCC7;
	Tue,  5 May 2026 07:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777965606;
	bh=zPPm8mihwsbz7WxUEStvO0kZKAy0ltxaxF1GHCofeUU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=UbYVNIBE6sc+bLcG5VB3jRT5aaI9HX10eZMSHquInKwsLB1b7iyqM2vF0JzAmH7XT
	 p9ZmK/bjngU/rJa9ABtJhkFZkKLASZcSPBilMRPyl6aImHjAdvgXbhih+1Kfnv4qEG
	 aE+WBBN/n9sIpfYA9fMjYbJ1SJsuKjYK3uk9FYEuhqNaIDnQ0FsEHvZKqnYD8Jyydu
	 Kw6bsO3IDVideB4GJYRelj8oHSCzcIuPB4SrSShubmInr2UJ0fEGwsdeCcoPpln4pE
	 5RhFG+O05a9oLmidZHaBUg+kJ/KLk3U6ZqWyBz6MUYyyxrJA12Eu+c90PGnI6/HuYA
	 hSTFxLlnnDF2g==
Content-Type: multipart/mixed; boundary="===============4438461894692283644=="
MIME-Version: 1.0
Message-Id: <c25e14be97cb01094d1590d1f89212cbf8b5e4f22ed85b6ab4b52853b7cf1450@mail.kernel.org>
In-Reply-To: <20260505062026.91724-4-cuiyunhui@bytedance.com>
References: <20260505062026.91724-4-cuiyunhui@bytedance.com>
Subject: Re: [PATCH v4 3/3] riscv: store percpu offset into thread_info
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
Date: Tue,  5 May 2026 07:20:02 +0000 (UTC)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EBE7680013
X-Rspam-User: 
X-Stat-Signature: f4ofbwtgeyj1soff3q1wx789h5dkd7rg
X-HE-Tag: 1777965606-515789
X-HE-Meta: U2FsdGVkX18OCRyYSmBHPJ8CNzZpz60mKvtKl+rJ+EPOfykNHOscwX+ECVbtPHiMRm24Cu02xGAnsJaq8AYHKtvea5fXN6i5da10AAa19sfM6DZJct9G7XdQUcsiP5hz2d+e9VAV9gdtLacSSgL9cBY4XuS9OJsiwlZpgdzcpP9Oa7rmWLfCRWpZayTsPpgQzfaRRNDdA/KCrkIxRjZpHJsizaPv9IHgMWJsq3vcy29Wx6syKlGYEpfJvSmUb/fBl1D0X0Cc10dY0rBFHDlkF7ZtN6ABfNDevpxgQEwy4A4I9uLlG1pk93pvWGqe55lSwn5hzx0C/XF75s2t1BAUFDJsagb+xjvTMV/GN4H1QpnkgvnNAqlulHrOLyeF+2f9iEwZux4sqzIuB43HIkkRI/Mr2Gtsfq+Y1JsulB60Nc3OOmi1IbGCr2oE4Jdi6nObutb3CEYo7R14PONPlUNBDInblFi4+Lu2NTuf6Gkq7X7zAHiVYbH/pY4mTJ3bP+MzML/Vx6miVDrRb4Z+PmCqC+b7vv1DZMRiDkGiWwyhrCq1Rh1UcBMyKuR+VdJ3TWVq558Q9P5gIW1kNN9qqdvVdVgrGzWDfE18lD4ye0qWsGjOnolyExHLwbzNU7/kservqUKbENrNU6qFUksnYydG+Nzfb3n27Q9oyVReJdBkgAFfKEE7U3jChzeoevj38XDd0JIizARfDOAzLPNhItMFe8dCkuBVHgW+ozTWoR6OCC6LBboL8XypVk+vM+VL9JDkKrBtDkyZK9dL5swd7dmU8aeYu+b/XyKNC+Tzj/48cVsQ8m8gGF+OJ+0FyVjf/SVkTESwPKifIaEeJEnaHajq5yMG2usN3/e4b0OCiNbapq2lrBJHpR0Y15w15hKLt5mai26AkzCBjIAPqvlAyNoztki6Omx+FxYivupR1cmC+rJRun9Ca9gWDc84a/Jo9lJwR9VOmr7ZifXUkqSzEmz
 tUFhUUIo
 Z7o5ur+l8Byzcb4yTwjTNPWqhAmGnIYIutPP2Q4N/QZ0qouQJ5DDKLLiR1s3aDOXHd3Z3HAWDH7VixMl8KAO3fOCKVibka7/iGWzTQKOJKfzjfSAUTlP05AyNPeURzHipa7RV3BtExgsS9Jvald42zSGYZbdn2vB/UFOHkRFmPDlKwa44JTCy6DqrhnjqVl0KA2jLo5x6O0DHHbZkaMK5QA3ROdbxDDmlDgWogj8axW4MuLyAAy6AGAQW1oxKmeOyVJcrB88ZhwZWfp9qjqKPchN+BULv0beMOEro51FAPEucOpJCHGxRt2vi0ri/XPur2NSQnZIbL2b4kpALiaLVB5eDW2SwbRFQnB2nxHcbZpIX2f66K+asFrrcK1++NZNCs1rtG8f2rwPbL+W5efOTYvetPCL8AdvQHS2sakYS/TfZkYSviE9MISo2vUOGa4i7Tlrkic+j4sVyhUusjl4F35/j19a54ILxU5pTdLgm6d/zsBK6cndeNVq1oLVZI/gzyyO199RxkY8fjrZasL0rFOLLSNGlmWfdmgq55m1FXyby13ZsA+FgMw0o42R24BniejV7i4pQYJWMkTLRf6ji4zO7e+7+tjPWnBQJ/HguT1385Jg+1QdFJIC0dwSe+VemHwEw2O7tuWuUE1Q48uEnJHAc0RkuVjUkNduthsatvMTFYQBqmkCEunqCqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4438461894692283644==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/arch/riscv/include/asm/asm.h b/arch/riscv/include/asm/asm.h
> index e9e8ba83e632..137a49488325 100644
> --- a/arch/riscv/include/asm/asm.h
> +++ b/arch/riscv/include/asm/asm.h
> @@ -91,11 +91,7 @@
>
>  #ifdef CONFIG_SMP
>  .macro asm_per_cpu dst sym tmp
> -	lw    \tmp, TASK_TI_CPU_NUM(tp)
> -	slli  \tmp, \tmp, RISCV_LGPTR
> -	la    \dst, __per_cpu_offset
> -	add   \dst, \dst, \tmp
> -	REG_L \tmp, 0(\dst)
> +	REG_L \tmp, TASK_TI_PCPU_OFFSET(tp)
>  	la    \dst, \sym
>  	add   \dst, \dst, \tmp
>  .endm

[ ... ]

> diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
> index 3b26fe45e70f..84612d672105 100644
> --- a/arch/riscv/include/asm/percpu.h
> +++ b/arch/riscv/include/asm/percpu.h
> @@ -7,7 +7,9 @@
>
>  #include <asm/alternative-macros.h>
>  #include <asm/cpufeature-macros.h>
> +#include <asm/current.h>
>  #include <asm/hwcap.h>
> +#include <asm/thread_info.h>

[ ... ]

> @@ -275,6 +277,8 @@ _pcp_protect_return(__percpu_add_return_amo_case_64, pcp, val)
>  })
>  #endif
>
> +#define __my_cpu_offset (((struct thread_info *)current)->pcpu_offset)
> +
>  #include <asm-generic/percpu.h>

[ ... ]

> diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/asm/switch_to.h
> index 0e71eb82f920..733b6cd306e4 100644
> --- a/arch/riscv/include/asm/switch_to.h
> +++ b/arch/riscv/include/asm/switch_to.h
> @@ -88,6 +88,13 @@ static inline void __switch_to_envcfg(struct task_struct *next)
>  			:: "r" (next->thread.envcfg) : "memory");
>  }
>
> +static inline void __switch_to_pcpu_offset(struct task_struct *next)
> +{
> +#ifdef CONFIG_SMP
> +	next->thread_info.pcpu_offset = __my_cpu_offset;
> +#endif
> +}
> +

[ ... ]

> @@ -122,6 +129,7 @@ do {							\
>  	if (switch_to_should_flush_icache(__next))	\
>  		local_flush_icache_all();		\
>  	__switch_to_envcfg(__next);			\
> +	__switch_to_pcpu_offset(__next);		\
>  	((last) = __switch_to(__prev, __next));		\
>  } while (0)

[ ... ]

> diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
> index 36918c9200c9..17996dc094fd 100644
> --- a/arch/riscv/include/asm/thread_info.h
> +++ b/arch/riscv/include/asm/thread_info.h
> @@ -53,6 +53,7 @@
>  struct thread_info {
>  	unsigned long		flags;		/* low level flags */
>  	int                     preempt_count;  /* 0=>preemptible, <0=>BUG */
> +	int			cpu;
>  	/*
>  	 * These stack pointers are overwritten on every system call or
>  	 * exception.  SP is also saved to the stack it can be recovered when
> @@ -60,8 +61,8 @@ struct thread_info {
>  	 */
>  	long			kernel_sp;	/* Kernel stack pointer */
>  	long			user_sp;	/* User stack pointer */
> -	int			cpu;
>  	unsigned long		syscall_work;	/* SYSCALL_WORK_ flags */
> +	unsigned long		pcpu_offset;

[ ... ]

> diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
> index af827448a609..fbf53b66b0e0 100644
> --- a/arch/riscv/kernel/asm-offsets.c
> +++ b/arch/riscv/kernel/asm-offsets.c
> @@ -38,6 +38,7 @@ void asm_offsets(void)
>  	OFFSET(TASK_THREAD_SUM, task_struct, thread.sum);
>
>  	OFFSET(TASK_TI_CPU, task_struct, thread_info.cpu);
> +	OFFSET(TASK_TI_PCPU_OFFSET, task_struct, thread_info.pcpu_offset);
>  	OFFSET(TASK_TI_PREEMPT_COUNT, task_struct, thread_info.preempt_count);

[ ... ]

> diff --git a/arch/riscv/kernel/smpboot.c b/arch/riscv/kernel/smpboot.c
> index d85916a3660c..9e95c068b966 100644
> --- a/arch/riscv/kernel/smpboot.c
> +++ b/arch/riscv/kernel/smpboot.c
> @@ -209,6 +209,11 @@ int __cpu_up(unsigned int cpu, struct task_struct *tidle)
>  }
>  #endif
>
> +void __init smp_prepare_boot_cpu(void)
> +{
> +	__my_cpu_offset = per_cpu_offset(smp_processor_id());
> +}
> +

[ ... ]

> @@ -234,6 +239,8 @@ asmlinkage __visible void smp_callin(void)
>  	mmgrab(mm);
>  	current->active_mm = mm;
>
> +	__my_cpu_offset = per_cpu_offset(smp_processor_id());
> +

[ ... ]

> diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
> index 2f1109dbf105..177c19216013 100644
> --- a/arch/riscv/net/bpf_jit_comp64.c
> +++ b/arch/riscv/net/bpf_jit_comp64.c
> @@ -1395,15 +1395,8 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
>  			if (rd != rs)
>  				emit_mv(rd, rs, ctx);
>  #ifdef CONFIG_SMP
> -			/* Load current CPU number in T1 */
> -			emit_lw(RV_REG_T1, offsetof(struct thread_info, cpu),
> +			emit_ld(RV_REG_T1, offsetof(struct thread_info, pcpu_offset),
>  				RV_REG_TP, ctx);
> -			/* Load address of __per_cpu_offset array in T2 */
> -			emit_addr(RV_REG_T2, (u64)&__per_cpu_offset, extra_pass, ctx);
> -			/* Get address of __per_cpu_offset[cpu] in T1 */
> -			emit_sh3add(RV_REG_T1, RV_REG_T1, RV_REG_T2, ctx);
> -			/* Load __per_cpu_offset[cpu] in T1 */
> -			emit_ld(RV_REG_T1, 0, RV_REG_T1, ctx);
>  			/* Add the offset to Rd */
>  			emit_add(rd, rd, RV_REG_T1, ctx);
>  #endif

Note: A lore search found an unaddressed review comment from Arnd Bergmann on
v4 of this patch series, dated Tue, 05 May 2026 08:33:04 +0200. The comment
references arch/riscv/include/asm/io.h regarding null-pointer arithmetic in
PIO helpers. However, that file is not modified in this commit. This may be
feedback on a different patch in the series.

Reference: https://lore.kernel.org/all/3720c3a4-cc0d-4ba8-97ae-35def0189e2e@app.fastmail.com/


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/25361792504
--===============4438461894692283644==--

