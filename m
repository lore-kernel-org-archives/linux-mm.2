Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6862606A31A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 02:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oqUWd+hL
Received: by kanga.kvack.org (Postfix)
	id B0A2B6B05B8; Sat,  7 Nov 2026 21:41:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6B1B6B05BA; Sat,  7 Nov 2026 21:41:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A81B6B05BB; Sat,  7 Nov 2026 21:41:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6F26B05B8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:41:45 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE4CEA7ED3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:41:44 +0000 (UTC)
X-FDA: 85410401328.01.19CDB4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2E0A480004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:41:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqUWd+hL;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794105703;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DRHvIw1u2uHJfm4qV+SPn2XIBsYniEYEKzVAR8jCY1A=;
	b=0N7NAsc1N0/wzB3WK92X4KMZ2TkSzfBbHwHEQftJQGniAGacO6+ZQIK5d1QiKJmmKdcX1b
	aKJVthyQ7qcBLYEEfQjZxIidoOEVSAXaNbO5OvZtDsNSpgPp2uDIpB0dGcUe32AwyrHgVN
	sy9mu9szQoyLrILT7/R7dyyo3++bmpg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794105703;
	b=A89pFwVpBJv2hA7WBPG5jQJUm+3OXhRU+JCa+odjR1mZyzZzcQUK16qI9itVaZoCWLjWX5
	U8M5/FdMHr2RTWJP3FXC1TuM6lY+gsF1Gp3PLKt2ec0bQAWgLvvLgKtTjEhHBi35iUzAu/
	prt/TiKy5cteAX7r6mW9KeDse+Ib3X0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqUWd+hL;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C44E43B89;
	Sun,  8 Nov 2026 02:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081DD1F0089F;
	Sun,  8 Nov 2026 02:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794105702;
	bh=DRHvIw1u2uHJfm4qV+SPn2XIBsYniEYEKzVAR8jCY1A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oqUWd+hLytVSiXaShntxJ/FH6ebYoenXwjkB9WjF8xdIP9TK08Dh9Xzqjn47s56ch
	 7KoBDwXd50TVDtjwEXovPtiCkyYlXtEr3BwOS6a93p/AZEB9TDeIHiO9qbe+YsBR+Z
	 XuJzX0XhdbQpa5rBhsehMz2MdyRTHPO7GAiR67Tdazka+5/RH8dHKZP8CssenSJ1e1
	 QYvOpnsMdtW8urPtpht5KxYez3hnl3PTg/Mu48LtuWFSSTHjz5auNtQjl2C8Jlcl9R
	 oV6mFU0aDuLKmxJryJztXlPThGc60u6nK4T7hvnXa5zvciDkO4nsostq7CIZ4ljntp
	 QV1pOlmiOB7zw==
Message-ID: <sashiko-outbox-203527@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 6/8] riscv: Add shared instruction fetch and decode
 helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Himanshu Chauhan" <himanshu.chauhan@oss.qualcomm.com>, "Paul Walmsley" <pjw@kernel.org>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>
Cc: "Alexandre Ghiti" <alex@ghiti.fr>, "Jesse Taube" <jtaubepe@redhat.com>, "Oleg
 Nesterov" <oleg@redhat.com>, "Kees Cook" <kees@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Arnaldo Carvalho de Melo" <acme@kernel.org>, "Namhyung
 Kim" <namhyung@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Alexander
 Shishkin" <alexander.shishkin@linux.intel.com>, "Jiri Olsa" <jolsa@kernel.org>, "Ian
 Rogers" <irogers@google.com>, "Adrian Hunter" <adrian.hunter@intel.com>, "James
 Clark" <james.clark@linaro.org>, "Shuah Khan" <shuah@kernel.org>, linux-mm@kvack.org, linux-perf-users@vger.kernel.org
In-Reply-To: <20261107023917.40606-7-himanshu.chauhan@oss.qualcomm.com>
References: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
 <20261107023917.40606-7-himanshu.chauhan@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 02:41:40 +0000
X-Stat-Signature: tq3zq975b8b8dzisae4grfzn9b4u4oji
X-Rspamd-Queue-Id: 2E0A480004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794105703-421615
X-HE-Meta: U2FsdGVkX1+mayFfYS3Nw9LpEZuK60MyiNBoFX0idgdn1hQerN1syu/53YRwgPlBs/PWtgcKy5wKlu5cvPfL3c0uMSprBf2x0iYSe4hxyry4uF9wzHSSRVD85URTugSDIDanq0q+dpelvT1/TC/mlIZ3FpHjTYI+Bx4a0hAkiGKG4GhS4+0oW2JEd97uYQX36NcUv64FDCldNNBjOA68V1NbDpt968JYxyms13aPaYsFxYiY2wtOG8t/cBfbAq4QHPKU0v+3LGEqUdzcblSzCMcXOrZw5uqjoHTvSNQK9oKBYZxzZqId5WYRhjDii9OqYjJL+au3UPvhskNL9MEexsfqviqwzj02+LByw28dhmBYvRxMm0M3IDocAwieu023dr2o09eQaqVHI+oJzsETGiXSH9DHTx/W16FwuwxAoEpTOswK0ha2kcaILdzqX3z7Mw1o9/mZzgkOi13DJkfCC0eU/L9u/Udu9JfqIihHWWIKxERL1Hk28kYQXWTMBz5V4nOWIYOXpbhet0PVrHzyjca5KCc3p3vlp/hc/zBZe8KPI20VqjPamCA0igHtiIr0xgnCJ4aanQ4S72aMgntqbBLECMOj6ePaRJRP3eQ16D36ldld/qp5t0+WJXvgX9j4Z8thBhhDAIwH3m8hZXW+QpnXlgEgmFuJenDhHIXdPB2HvLlERgxxC42+9zJIDO8STwPCq22lfSX4tuinz7ErqqsGNqtyhVgp4I88kzFJT024YaHdtMPnklUUsxjFk085lSV4fE2M9I9JTy6WtxZ/AxzBfbJdMkUfy3qLCcipNEICHBS3xe89pzCve5zVHY9Q0TkacipeOKQEk3I0xq6Mhe70aS8cKHm8MRWtoIalRWeS1HzHoDc/81dsCs/BYzD3VqPdg8GY2mm6HRQH9kzufgMM032I+RSQ6dduyvhLJd8dhhv/TWpg165ZV362Efv70UxLmoScdbOVJymci8o
 bVemqNN2
 EgtCZTwZDE4C4RqwM4dY5wgEcsw9SQ13HxAlyFzb5uhe7AJKI/Rwp1Qst+C2y3tyi9mIA5KpZ8ywBxsraJaAzXKSTjJ4nb5v/gZdYcYG/gAA0Q69dh3QVi7xyCH4HA6Uk/oqDV0i/4B+H39syFDgQKcj0QIGf9RX/y1PezqbUMgDYZpvV+MgLZpLVHu4e9yGwQlSuQ0YXgTtQ72slAHIfgflvecdU+I9Nw/dCUbB0NdmfuVeIts6920wUML6E0do1DAZJGaPUPbZOYWuoPoC+ORZM1JilhA5VIyKg0YQnEZqWo+N5WoAx1Bn8ywH8rJAXzfYXixXE/6b+E0JJUfZ5sDel6+ASrQdXxPrluyPfjVofWNzzW/M4Cvvkot4OdnI3kyQ1Q82HBdd28B2sByq17q2V0G2lGlG0awt/liyjb2AlSQ9vbOQdTbNzGZ732ClTcBLvqqj7JNAruMjC29Xlk5IoJ7LjeBabLqlMZChRYxK/AAXvRJ1p6C9PeYbMGY9+B7qgAIK1OVQjFjDXEZF0LzVqkR6quDVAYiOnp9UxhjyV89a+JZFJj3pAJqSG7TacIoTZlCJavXFBlKi01XXqcuyuHA==
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
- [High] riscv: missing s32 sign extension of offsets in
  get_next_insn_address()
- [Low] riscv: duplicate include of asm/insn.h in traps_misaligned.c
--

commit c0540231e3e0c755203ccef775001d61bb9b1fb4
Author: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>

riscv: Add shared instruction fetch and decode helpers

This commit moves get_insn() into arch/riscv/lib/insn.c and adds helpers to
fetch instructions and compute the next PC for control-flow instructions
during software single-stepping.

> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/tra=
ps_misaligned.c
> index 6e8ae6c66322c..541e6a5b80394 100644
> --- a/arch/riscv/kernel/traps_misaligned.c
> +++ b/arch/riscv/kernel/traps_misaligned.c
> @@ -10,6 +10,7 @@
>  #include <linux/irq.h>
>  #include <linux/stringify.h>
> =20
> +#include <asm/insn.h>
>  #include <asm/processor.h>
>  #include <asm/ptrace.h>
>  #include <asm/csr.h>

[Severity: Low]
This isn't a bug, but arch/riscv/kernel/traps_misaligned.c already includes
asm/insn.h a few lines below.

[ ... ]

> diff --git a/arch/riscv/lib/insn.c b/arch/riscv/lib/insn.c
> new file mode 100644
> index 0000000000000..fc44e2aa6f5f0
> --- /dev/null
> +++ b/arch/riscv/lib/insn.c

[ ... ]

> +static unsigned long get_next_insn_address_compressed(struct pt_regs *re=
gs, u32 insn,
> +						      unsigned long pc)
> +{
> +	unsigned int rs1_num;
> +
> +	if (riscv_insn_is_c_jalr(insn) || riscv_insn_is_c_jr(insn)) {
> +		rs1_num =3D RV_X(insn, RVC_C2_RS1_OPOFF, 5);
> +		return riscv_jalr_target(riscv_get_reg_value(regs, rs1_num), 0);
> +	}
> +
> +	if (riscv_insn_is_c_j(insn) || riscv_insn_is_c_jal(insn))
> +		return RVC_EXTRACT_JTYPE_IMM(insn) + pc;
> +
> +	if (riscv_insn_is_c_beqz(insn)) {
> +		rs1_num =3D RV_X(insn, RVC_C1_RS1_OPOFF, 3) + 8;
> +		if (!rs1_num || riscv_get_reg_value(regs, rs1_num) =3D=3D 0)
> +			return RVC_EXTRACT_BTYPE_IMM(insn) + pc;
> +		return pc + 2;
> +	}
> +
> +	if (riscv_insn_is_c_bnez(insn)) {
> +		rs1_num =3D RV_X(insn, RVC_C1_RS1_OPOFF, 3) + 8;
> +		if (rs1_num && riscv_get_reg_value(regs, rs1_num) !=3D 0)
> +			return RVC_EXTRACT_BTYPE_IMM(insn) + pc;
> +		return pc + 2;
> +	}
> +
> +	return pc + 2;
> +}

[ ... ]

> +static unsigned long get_next_insn_address_standard(struct pt_regs *regs=
, u32 insn,
> +						    unsigned long pc)
> +{
> +	unsigned int rs1_num;
> +
> +	if ((insn & __INSN_OPCODE_MASK) =3D=3D __INSN_BRANCH_OPCODE)
> +		return riscv_branch_taken(regs, insn) ?
> +			RV_EXTRACT_BTYPE_IMM(insn) + pc : pc + 4;
> +
> +	if (riscv_insn_is_jal(insn))
> +		return RV_EXTRACT_JTYPE_IMM(insn) + pc;
> +
> +	if (riscv_insn_is_jalr(insn)) {
> +		rs1_num =3D RV_X(insn, RVG_RS1_OPOFF, 5);
> +		return riscv_jalr_target(riscv_get_reg_value(regs, rs1_num),
> +					 RV_EXTRACT_ITYPE_IMM(insn));
> +	}

[Severity: High]
On 64-bit RISC-V, do RVC_EXTRACT_*_IMM(insn) and RV_EXTRACT_*_IMM(insn)
zero-extend negative branch and jump offsets to 64 bits instead of
sign-extending them?

Because insn is u32, RV_IMM_SIGN(x_) and RVC_IMM_SIGN(x_) evaluate in 32-bit
unsigned arithmetic (producing a 32-bit unsigned mask such as 0xfffff000U),
and bitwise-ORing that with the GENMASK()-based unsigned long bitfields
zero-extends the result to 64-bit unsigned long. Any backward branch,
backward jump, or negative-offset JALR in get_next_insn_address_compressed()
and get_next_insn_address_standard() will miscompute the next PC by +4 GiB,
arming software single-step breakpoints at the wrong address.

Casting the extracted immediates to s32 before adding pc or passing the
offset to riscv_jalr_target() (as done in simulate-insn.c) would sign-extend
them properly.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107023917.4060=
6-1-himanshu.chauhan@oss.qualcomm.com?part=3D6

