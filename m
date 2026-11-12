Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07026606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oA970PEO
Received: by kanga.kvack.org (Postfix)
	id 05D966B00EF; Thu, 12 Nov 2026 06:05:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034BA6B05B0; Thu, 12 Nov 2026 06:05:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3A76B05BA; Thu, 12 Nov 2026 06:05:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF3376B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:05:53 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C1B14053E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:05:53 +0000 (UTC)
X-FDA: 85426186986.09.0DDA8BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9A7D1160005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:05:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oA970PEO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794481551;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S89kIsd7BUlNlcCFv+9S+QJBXNwSQ/ww2MZ5b/xIKxw=;
	b=FE5Zcwi/aO2s/Q/I9+fxL/S2zXPMSvKpQwpnxkx6ic8Jyvz9CmtFUcklUmr1UQsT5K2hB1
	FryR+W7hmgcp7wsOn4QS8Fbkm/+2jiiwX8jEjjYoqMroYcBDoR/H1N/iph2zVAoWU/HoYe
	AqyujKPzkD3gyL7MoRFVnUAxGr5s1f4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oA970PEO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794481551;
	b=qfmG/VdDpg+EUFXjksb3WHoZ55zCyB38uI63bFfKxprA0n2IN/syNHwaR+O5Q+SQa5l8fD
	HiBr2wS8whJH20l8I/Sl++9uck43TaBym3MK5G06M2xSy994gYS+AEcR5uUJtqmkjN7TdF
	+b4vtcBC9Ze7R1UYwK9Q1gch1E6BaQQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D1EF6343C;
	Thu, 12 Nov 2026 11:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096681F00A05;
	Thu, 12 Nov 2026 11:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794481550;
	bh=S89kIsd7BUlNlcCFv+9S+QJBXNwSQ/ww2MZ5b/xIKxw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=oA970PEOuLEH/aI6RiajFyeNZAl4rDhQbuif1X1YEtlCcn8f2VvX5zNyjcgEtM+w1
	 LMumGtAQKRoKfB2FEhatsvGjYvQuAts20+c25DfIJ0jQvaqJ2vuyMpsU6xCIn5wldx
	 Awi8pRUt/jOSJksmknaiEDYsbiQTfvzb2Keh+gd0GQYNPcLGz9hmJlIbuytou3SU2y
	 ld8fW2+dYAQBVR9SXudIP+agL9pUjTuTCAkvtYTk85W4cLQn8D8pVovdEV7XSdcuit
	 rJu3lL4WmySU+Gaz6RP9A9698+ylc5Yjvj6HGZI4AiIkJUy+DbWsyDHeLlSylN6oIs
	 OJZqj98/E80kA==
Message-ID: <sashiko-outbox-210988@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 2/9] riscv: add infrastructure for preemptible
 this_cpu operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yunhui Cui" <cuiyunhui@bytedance.com>, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, dennis@kernel.org, tj@kernel.org, cl@gentwo.org, oleg@redhat.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev, bjorn@kernel.org, pulehui@huawei.com, puranjay@kernel.org, broonie@kernel.org, dave@stgolabs.net, david.laight.linux@gmail.com, jszhang@kernel.org, tglx@kernel.org, conor.dooley@microchip.com, thuth@redhat.com, ajones@ventanamicro.com, ben.dooks@codethink.co.uk, rkrcmar@ventanamicro.com, samuel.holland@sifive.com, zong.li@sifive.com, debug@rivosinc.com, seanwascoding@gmail.com, andybnac@gmail.com, menglong8.dong@gmail.com, cyrilbur@tenstorrent.com, wangruikang@iscas.ac.cn, atishp@rivosinc.com, apatel@ventanamicro.com, arnd@arndb.de, nathan@kernel.org, nick.desaulniers+lkml@gma
 il.com, 
 morbo@google.com, justinstitt@google.com, qingfang.deng@siflower.com.cn, linux-mm@kvack.org, bpf@vger.kernel.org
In-Reply-To: <20261112104149.38589-3-cuiyunhui@bytedance.com>
References: <20261112104149.38589-1-cuiyunhui@bytedance.com>
 <20261112104149.38589-3-cuiyunhui@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 11:05:48 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9A7D1160005
X-Stat-Signature: ucuwagyz6wugqf4hip1jgkmrx4zohnk8
X-Rspam-User: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794481551-83208
X-HE-Meta: U2FsdGVkX19VxU2PC8DHyK5oPwoytIiPSsv8OKGTgHO0RY7J+P8srq0YMi4XdZalJfUsEurRPrFUgMCedZt1yuffJwccbhhaJMJNgDFXGUb8IGu+IxrBhbcdqKzNHhkKY83OgZv6eKXE1m4uBP270/OlEx+buoKyAEguGtKQIjLGm9d/jDp/wYp8VBDH3byjcvf9kjLs123UNrXPyUdk4waaIU1SqOqxMJE9TsJ223KMSqaS/56CtDJgYZEApCY42HBhd2VWCZfc67yXQS48T+4jSdLAJqspDEABHUJz+ommlHRG1cfJAUrkM0Er1mDUD4YQyqSjm0kvmj/gj5WVdSJAnO4p5a1Vvq1yZmc0X6Co+SQ2om3Zx04jHi0dfeUeOBlO0CRzXPCE2eio09i04Yqwk2lfqR3yvx+G9/EXCx0ga3Ai0bC5UWYEh9qPGI2Nz1Qa++1wnFOcpom+my0Kzj9FX36x3+B/xHerR11U7G1zuCT5uasXf+kjtNXm+AV4opnFeWEhfvWwXqitLsFQ8jqNHwGTETOsnI/j9Ir7W6kntT4m14ejYH/d1ugUjLGK2qTGj1oT/x2q97fzS6wkc0Zg0JG8s8rj0VTS/vhGTC1TGCMLm6Z3PkxkMnsImPEOpymcaocmIKnDi4RjVnXfNhhelRcekrN4GYCp12EyrPEqmbMPW7KJ5+2ANjRfDlBdbSA1qLZHXct+Kwg2bmbEYeJv5mRZvTEX51YoqOKACk6hD8QIWmMSKToLHmpY+1gGZmXieh7NaalXxMVmZMbdGDlefYURorpCemnbVmc2CGHOmwzKDDgnh9yE2ao7SvWnysyEiSzpd1wpV5sRVRiDay7M/6LlQYmEdBnrazm5bo64KDzkaUI7mT22DuDh8cTqCa9lIQJPrSXkJbszrHgTqxf9k45VK0b0FB9GRExaURIeJgSp4jDDC0zfuMlOIgWLt2MAu2oFKaD3MFAFjrL
 GvEnsK/i
 Ffn66miKg/qPVRZHgcf6rv4bVVEB53xVsHs+aOccl8gKPxInaFDPq3sv3BU0g3Vna6FKG6rOR9/kemnys5ramilTJvND12w8Wqu/zvjpLrtvg/cWFLYuHg2BY0h+EZjz5Gt4w+wU3XxOS9u3hDwaFh5am5GkB727uZkAYnVRzaCEi7og+56ZQWZjYbnBLihL+gGkBrVCKtfXFbraefPgb92k1PnVl2XxVOGdlcfJaClHFtZ4cIS8czpNTIUtAb0Xc+/1QP7JjIGnMtOvxkGhKSiXf8N6sjzvejsjNbw3DaQmhexjPo1xiHgnftpG4eJeMW+ENMSBbGcfeKAyTVcteLLpi33XsVqywaJ4t3w0zo3iY3Pb7FiI8+Wf8WHqKw+22RVmznDetYg7d9FDjc5PdBCE+Xh3w132St4q8z1kS6Cw1clQ59Aca8FP6p/+GejT3OjsGoeeoNNLRL7XWNSGFkjsoTFj3640jH1ZKYjyJjxF9qWnPcftEcrfZSpV4JyLhYwYV/+p3+ABrhLblAnwhiXopao/Uvj9NmQi7UKoUao5XjaY7g49q9PylpkiUeqqdrf6TdCXFzasLhESGhzdpdtw8v77FArEBoxEdduXDw8yuyprr56AfubV4RwI5jxoZ9YXw6tCxMydw1xdm3j4FXRjpXolPta02QA1hz8g10ORnEZIVRRguhL5koNgB45a1gb0oWncA+dzW3VMSrpDAxdIkfvE3ig6vAHMzHjAA6hzokvS958WP8H+Jgzpu1EhD8AqsaW2jOq4LXZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] riscv: ptrace: wrong x0 offset assumption in
  riscv_pcpu_regs_fixup()
- [Low] riscv: entry: non-__always_inline helpers called from noinstr
  riscv_pcpu_regs_fixup()
--

commit dbc8e3fbcb707ac729e711e7321ce4a62f50767e
Author: Yunhui Cui <cuiyunhui@bytedance.com>

riscv: add infrastructure for preemptible this_cpu operations

This commit adds per-task and exception-frame tracking for registers used in
preemptible per-CPU operations so exception return can fix up the per-CPU
offset and address registers if the task migrated.

Link: https://lore.kernel.org/r/20261108213254.67805ef0@pumpkin
Link: https://lore.kernel.org/r/avG07pmpcLGkq5i-@xhacker

> diff --git a/arch/riscv/include/asm/ptrace.h b/arch/riscv/include/asm/ptr=
ace.h
> index addc8188152f7..ceff8f63bc866 100644
> --- a/arch/riscv/include/asm/ptrace.h
> +++ b/arch/riscv/include/asm/ptrace.h
> @@ -53,6 +53,8 @@ struct pt_regs {
>  	unsigned long cause;
>  	/* a0 value before the syscall */
>  	unsigned long orig_a0;
> +	/* Active preemptible per-CPU operation, if any. */
> +	unsigned long pcpu_gprs;
>  };
> =20
>  #define PTRACE_SYSEMU			0x1f
> @@ -145,6 +147,19 @@ static inline unsigned long regs_get_register(struct=
 pt_regs *regs,
>  	return *(unsigned long *)((unsigned long)regs + offset);
>  }
> =20
> +static inline void regs_set_register(struct pt_regs *regs,
> +				     unsigned int offset, unsigned long val)
> +{
> +	if (unlikely(offset > MAX_REG_OFFSET))
> +		return;
> +
> +	/* Register x0 is represented by the first, read-only slot. */
> +	if (offset)
> +		*(unsigned long *)((unsigned long)regs + offset) =3D val;
> +}
> +
> +void noinstr riscv_pcpu_regs_fixup(struct pt_regs *regs);

[Severity: Low]
Should regs_get_register() and regs_set_register() (or the GPR helpers call=
ed
by riscv_pcpu_regs_fixup()) be marked __always_inline?

riscv_pcpu_regs_fixup() is a noinstr function called from ret_from_exception
after irqentry_exit(), and under sanitizer configurations such as KASAN or
KCSAN the compiler may not inline plain static inline functions into a
noinstr caller.

[ ... ]

> diff --git a/arch/riscv/kernel/entry-common.c b/arch/riscv/kernel/entry-c=
ommon.c
> new file mode 100644
> index 0000000000000..023d856b1679b
> --- /dev/null
> +++ b/arch/riscv/kernel/entry-common.c
> @@ -0,0 +1,32 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/bitfield.h>
> +#include <linux/compiler.h>
> +#include <linux/percpu.h>
> +
> +#include <asm/current.h>
> +#include <asm/ptrace.h>
> +
> +/*
> + * If the interrupted context had an active per-CPU operation, rewrite i=
ts
> + * saved offset and address registers for the CPU on which it will resum=
e.
> + */
> +void noinstr riscv_pcpu_regs_fixup(struct pt_regs *regs)
> +{
> +	unsigned long pcpu_offset =3D __my_cpu_offset;
> +	unsigned long gprs =3D regs->pcpu_gprs;
> +	unsigned long pcp;
> +	unsigned int reg_pcp;
> +	unsigned int reg_off;
> +	unsigned int reg_addr;
> +
> +	reg_pcp =3D FIELD_GET(PCPU_GPR_PCP, gprs);
> +	reg_off =3D FIELD_GET(PCPU_GPR_OFF, gprs);
> +	reg_addr =3D FIELD_GET(PCPU_GPR_ADDR, gprs);
> +
> +	/* pt_regs offset zero represents x0, followed by x1 through x31. */
> +	pcp =3D regs_get_register(regs, reg_pcp * sizeof(unsigned long));
> +	regs_set_register(regs, reg_off * sizeof(unsigned long), pcpu_offset);
> +	regs_set_register(regs, reg_addr * sizeof(unsigned long),
> +			  pcp + pcpu_offset);
> +}

[Severity: Medium]
Does riscv_pcpu_regs_fixup() read regs->epc instead of 0 if reg_pcp is x0?

Offset 0 of struct pt_regs is epc rather than x0, and regs_get_register(reg=
s,
0) returns regs->epc without special-casing offset 0.  By contrast,
regs_set_register() treats offset 0 as read-only x0, making it inconsistent
with regs_get_register() and regs_query_register_offset() for epc while
duplicating regs_get_gpr() and regs_set_gpr() in arch/riscv/mm/extable.c:

arch/riscv/mm/extable.c:regs_get_gpr() {
	if (unlikely(!offset || offset > MAX_REG_OFFSET))
		return 0;

	return *(unsigned long *)((unsigned long)regs + offset);
}

Sharing regs_get_gpr() and regs_set_gpr() (or providing dedicated GPR-index
helpers) would return 0 for x0 and keep the byte-offset regs_get_register()
API consistent.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112104149.3858=
9-1-cuiyunhui@bytedance.com?part=3D2

