Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3EF5C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860F36B00A8; Wed,  1 Jul 2026 09:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EBDB6B00A9; Wed,  1 Jul 2026 09:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B40F6B00AB; Wed,  1 Jul 2026 09:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BEE86B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:12:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4048F167D30
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:12:49 +0000 (UTC)
X-FDA: 84940247658.09.6BB1867
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8C4B51C0002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:12:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=O6B704Mg;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782911567;
	b=SJhMR+Ego8WtZgNw4ysPzQ4S0GHyzGOukFnc1Emocf5x9KGkcr+4YYtxmLoEYZtXQeBTkI
	yj6G+Om5TOv4gzgZMJn/alQqbKjhgysFnXHxvRbpcxsRWzY2pgQ8mOFo1LYTot07PPePsW
	qqqKob5Qu5TrgDHgKWAETvFw+M9HYMg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782911567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91uk3L99OWz781fU570Nvcxs1RgxF76hCIkEAl460QA=;
	b=7B7lMn/tdRQb1XGc2xjR4U2Q8eYEMbbiiQngqb8+rREsr9meQTrwaEqV8dx7rPzicWxLkJ
	gae2u5/qbUa3RrzXPkA/8tPx1Dwd9PNCpxDHg4cJTiwuaTCkvwd4T7/+gHjmVxAgCTgJKK
	djo8Rr+mlgXKMDEWr7zz3snqrVR7fMM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=O6B704Mg;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA5E46001D;
	Wed,  1 Jul 2026 13:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D301F000E9;
	Wed,  1 Jul 2026 13:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782911566;
	bh=91uk3L99OWz781fU570Nvcxs1RgxF76hCIkEAl460QA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=O6B704Mgvju/Ngdd1VbVKl0dbadn+4zuNw4UCqU9OwhtQxYQ1fO1eeNawxcTx7Nbw
	 aXfOMPV5NhTp9JgBqcn7SsZlimNjZ31SGM/Hd0Dh2tV8YTyKpycqS2V7v1vILKeoRW
	 5XJgR5/Bozvjndkz/hfuiOlHcALUeKsilMlgMk7pMHjKaUzvK3E4EytUGgeub5f51F
	 QRwY5RumucwkLPyq60/BGF4+6Q4mlvKfzGVAK4pcJYe+Qe3pMsiWAQY3nya5ud6NQK
	 cVyqKkfazNv1oPEvdn4YyoKLii7qUC+Lg7jlaYiI9qA//lBx6Vql9SdH0Ef5ft1I5G
	 70jCf5SchPRdA==
Content-Type: multipart/mixed; boundary="===============4080985512832073215=="
MIME-Version: 1.0
Message-Id: <fcc8e7d5146cf4c85f081ad21175c0da4b359b8c68c8305b2671c49de1a19807@mail.kernel.org>
In-Reply-To: <20260701122948.57584-3-cuiyunhui@bytedance.com>
References: <20260701122948.57584-3-cuiyunhui@bytedance.com>
Subject: Re: [PATCH v6 2/3] riscv: introduce percpu.h into include/asm
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
Date: Wed,  1 Jul 2026 13:12:45 +0000 (UTC)
X-Stat-Signature: synzbjtroj6xqxde4ugdrykyjae8zjei
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8C4B51C0002
X-HE-Tag: 1782911567-714763
X-HE-Meta: U2FsdGVkX1/Xt8vOQtTMskw+VnkWViy3znuSPp/rPxlw14s5qA0kfwNDcS9usqz//lFUH2MkXJucLHu18NJVjfiwOrzmT8wBfAZtN3/s60s2tx0xi+ZSbasmR49GUmqOkJ99dRWhAfIRtPZ5LjJ5/rb97E2a7z+QljoSG9NovExYVWUlJjV+Fa7GVW3SB/48+92/I7XUAwOe5iXnz1ishCNRpZQ6nlkuxGhFzjbnNm9gFpjGi+D6ARBSxZNi7R/v9Gr50yh5QurmAYUyKPdIO+HduxrbB4zMuujsYf6lJ3qAWaOP/X4iIF4gpywzx+gpsBlQOlHepI0g6/Sa0W86Kfdlfuz6gqVdfRyv+S6eRt7vLs+DPRsqE2G4yRjR208tf3ClnJbBUnlHgmSSRkmNJm3TyLy+d0PWfzWohzljfFu7ZPbNCo9SIqFqS9kEigLVNfbJVWnzyZ7pEHx+2E9cahj35hGjsoJOWjUNn6rhavT1Hu4bjXPKWF5XpibiXGAttwYNwflcKX7bh91y/VKZJ2k602wCZsZZcOyqzpdqPJDWWMe7snsDhqiiZXnXZmfCwQJQQKCAeOERlqrgyCEZmGuR8qdZP1R4skfD13kz1P7mSOg9BsdB0W2cU/4n3w2GLFKeWsDqc2qLypDPfEZboCpKw8LTnrMLjBk0XRj17LWmSz3nY9ZzXj1EoGnjEq/BsfNJZ/aV6tgsNQN27PfZrewEL7s3Q1zXCZxeXsH0S0/wkJJ/m6mzix3NB2kSrpSdNtTcLuY46MRcKjl8yYkWlhfN5PWFX3f4z9NOzO7XU11D4SdAUocKAUEZUliXluk3CI2u/HdRenXct/Jy5/cwnew2P37zNYD9v0ubtVQYX+6qcHfQI02/ZFivh/73u64JDskyReaYGei7qR4V0+wpPS4a0pN+9KAF39C270F24pbRyAlbIE7eETI3mQPykW0iim1nUN047ZtuEdo5uzn
 GnUZjD9z
 Ev6AsHGsWPjui+FW1vCj1CthbzBu1RJcsk0aCAuM4ulsVplWfWUl0w1mPVG13KLJcli9F8Cnl16Cc/4d77tDQb3g6cdY/mF0ot2F/gQD2BP0nyYAq/3LNTZqNxphBR+nOoPpyIr3czpk5deVnadIRbH7qhHKW/hayiYfdoaWFBttH5qaWG0otl8CQ9D3CvfUN7+dQmNts/mIAVXJwh9fO0PWrETMFHPLzBJBsBNvdHTbsyHzjHbEDk3j/MjX39+JfVieFL+m3vi3zTNfrGQDsHBesHOh/xfEFAyN66QsCYuTPVK4YtFulEiZisZ7/m4JqxmZZie49rwlMjiaCDkp9vFU0jMZOFcH2hcodeFUbtFPDzmPVUGe1SRLvXtmY/Obg5EzKNFHdBzf+LJIxbfR1/f0WED8BxOh8mBGu+saObzO5WhK2BPiEEry0lVCliyeGB8c5xZgxvxIi9rTiEZip2+mZYjcYN89oEfDMB1YrEX318+EfwguFKj7HJ6bbEqIpUvIQ4tyZLnOuESN416co1PVJggwXejfqhFv7bqr/FK1O+aKYN3eAYsuiWQcgKkAvKCsmTGHgZAAvPeTBxxgPt9cosb7PX5AN4MwBneOGQkfY//ZR/YOxX1d9eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4080985512832073215==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
> new file mode 100644
> index 000000000000..34483253e946
> --- /dev/null
> +++ b/arch/riscv/include/asm/percpu.h
> @@ -0,0 +1,284 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +
> +#ifndef __ASM_PERCPU_H
> +#define __ASM_PERCPU_H
> +
> +#include <linux/bits.h>
> +#include <linux/preempt.h>
> +
> +#include <asm/alternative-macros.h>
> +#include <asm/cmpxchg.h>
> +#include <asm/cpufeature-macros.h>
> +#include <asm/hwcap.h>
> +
> +#define PERCPU_RW_OPS(sz)						\

[ ... ]

> +#define __PERCPU_AMO_OP_CASE(sfx, name, sz, amo_insn)			\

[ ... ]

> +#define PERCPU_OP(name, amo_insn)					\

[ ... ]

> +#define __PERCPU_AMO_RET_OP_CASE(sfx, name, sz, amo_insn)		\

[ ... ]

> +#define PERCPU_RET_OP(name, amo_insn)					\

[ ... ]

> +#define PERCPU_8_16_GET_SHIFT(ptr)	(((unsigned long)(ptr) & 0x3) * BITS_PER_BYTE)
> +#define PERCPU_8_16_GET_MASK(sz)	GENMASK((sz) - 1, 0)
> +#define PERCPU_8_16_GET_PTR32(ptr)	((u32 *)((unsigned long)(ptr) & ~0x3))
> +
> +#define PERCPU_8_16_OP(name, amo_insn, sz, sfx, val_type, new_val_expr, asm_op)			\

[ ... ]

> +#define PERCPU_OP_8_16(op_name, op, expr, final_op)			\

[ ... ]

> +#define PERCPU_8_16_RET_OP(name, amo_insn, sz, sfx, val_type, new_val_expr)			\

[ ... ]

> +#define _pcp_protect(op, pcp, ...)					\

[ ... ]

> +#include <asm-generic/percpu.h>
> +
> +#endif /* __ASM_PERCPU_H */

This isn't a bug, but the header defines a fairly large set of broadly named
helper macros (PERCPU_RW_OPS, PERCPU_OP, PERCPU_RET_OP, PERCPU_8_16_OP,
PERCPU_OP_8_16, PERCPU_8_16_RET_OP, the PERCPU_8_16_GET_* helpers, and the
__PERCPU_AMO_*_OP_CASE helpers) and never #undefs any of them before pulling
in <asm-generic/percpu.h>.

arch/arm64/include/asm/percpu.h #undefs its PERCPU_RW_OPS, PERCPU_OP,
PERCPU_RET_OP and __PERCPU_OP_CASE helpers once they have been expanded.

Would matching that here be worthwhile, so these generically named helpers
(for example PERCPU_8_16_GET_MASK) do not stay in the global macro namespace
for every translation unit that includes this header?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/28518481105
--===============4080985512832073215==--

