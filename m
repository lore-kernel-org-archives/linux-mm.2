Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDFF0F531C1
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2821E6B0093; Mon, 13 Apr 2026 14:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232A36B0095; Mon, 13 Apr 2026 14:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148B86B0096; Mon, 13 Apr 2026 14:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 009066B0093
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:29:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB0BF160289
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:08 +0000 (UTC)
X-FDA: 84654369576.28.F264CD9
Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	by imf25.hostedemail.com (Postfix) with ESMTP id A62E2A000D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=KLIXIQrj;
	dmarc=pass (policy=reject) header.from=bootlin.com;
	spf=pass (imf25.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.171.202.116 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776104946; a=rsa-sha256;
	cv=none;
	b=gn3qwYWWV8Rg99OYmugGt4kLMCUMWuLyph73bM27Co75rCS/m/Jt1xpSYB1RUt5qp9K0Gw
	K+NiIlgyOViJbhyLf/NEtEdKpCoJgfMwFDh6hsT4W2O0xSIXpXFjvtzfBJmMw/1Rv972QD
	peaVB1cgLoitqUW3syCPED0RFbEFP/o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=KLIXIQrj;
	dmarc=pass (policy=reject) header.from=bootlin.com;
	spf=pass (imf25.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.171.202.116 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776104946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIbaQ9mg0ZbtaBPZTfhJW0y4Oug6knq3Mk42IMQtkEk=;
	b=wAAv9cincAPJ9VpMufIWMDjoX8PVM+GJn7BhfgB8cyYv7z/qnrLBxKIbA/qWsqvA7lFmUK
	pyEn9HqTmq0NZIcb24ZDwC/g9gTvgh9Q0BlEnImc0fQyqH/FSO20/bdhz5M5ZERQlLGl2x
	JNoifdsPJAuLER0lB9ATPf0zPFYzqBg=
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id A43C0C5B1AD;
	Mon, 13 Apr 2026 18:29:41 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id F191C5FFB9;
	Mon, 13 Apr 2026 18:29:04 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C7044104504B7;
	Mon, 13 Apr 2026 20:28:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776104943; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=SIbaQ9mg0ZbtaBPZTfhJW0y4Oug6knq3Mk42IMQtkEk=;
	b=KLIXIQrj/Dt6o6ylVSJmfcaGlqn8TQDRCQGBXVjGupGskDl9p5aoxmau6a5GMRftUxpFpP
	XXob2LzYqw709cOvxQ5a6hZGYrx/bejjqgSFQM7M3yCVGCevkepZRsrW22JHoJF1sJdmYj
	i+d3PdzlC1LjCfqZTgrnQ66Lzt9Q7VBJLIq352bEOs30qOllcgBqkwoZ+xBRxoIMSjdmbG
	2XqEp8UhjW1u3aJYbkCV4oPPq+JzqKyxPU/N6g+sv8PuS6VSbWtBmO71EcZ3QVymVhCtlo
	qjIaEb+/iC68dcXGm9wEQ/ZTOVEQ204pR+3wpucVloW80kqFyZL8TKyYRm8oKQ==
From: =?utf-8?q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
Date: Mon, 13 Apr 2026 20:28:42 +0200
Subject: [PATCH RFC bpf-next 2/8] bpf: mark instructions accessing program
 stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260413-kasan-v1-2-1a5831230821@bootlin.com>
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
In-Reply-To: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
To: Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Martin KaFai Lau <martin.lau@linux.dev>, 
 Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Shuah Khan <shuah@kernel.org>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
 Alexandre Torgue <alexandre.torgue@foss.st.com>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: ebpf@linuxfoundation.org, 
 Bastien Curutchet <bastien.curutchet@bootlin.com>, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Xu Kuohai <xukuohai@huawei.com>, bpf@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, 
 =?utf-8?q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
X-Mailer: b4 0.15.1
X-Last-TLS-Session-Version: TLSv1.3
X-Stat-Signature: bqirbi6wgkhoxtbnbqkr9y3y4smxezea
X-Rspamd-Queue-Id: A62E2A000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776104946-869837
X-HE-Meta: U2FsdGVkX1/5di6Jmy5SqSm516Ec3igM8C4q0wpTr/NmvpsXrcfV2rAWiOQTH1go3Bwomijzg09LkFQonsRvjCtmcpWG+vgfRZCQPTTLOovnZhdLm+fDiTW9mc7f32yGEPg0UTThmFkoSHV9lCm6icXOBFqRlSH1K2o8H2MNHBlmlfyyAz/3xog5xzpQaZy7WwdIDEJtHHfl+J9b9d0U2+ArhBpnBbBYqcyj4MfLPCg9MmLONr29ZWOwdfoTMHRXXHeq0XXYDWWSandLxLrq/d70MqV3DF0U+V4e0UPnh0x0YZyCexGh2TkhKqIICvmlmhf+uOYnjIqvfat8YAJWQgsI1j4vFQIhk47iAALM+rysLPGAIsbEgEPYJlYrpVhKw8PhIxpvKa4tp5MpsPH/SIZ0BMxhSYzE19larojt20O+AzT1frWT2JsDsG6kAqI/+7vVuQtDZ1qU+0NrjJtOHYzogQg7bm49rPP9KiMGimLc/0Q8Y6GG09hofms+BEx8r3TUSjESdzbiZaciu9dgeyXbW+gcldoG7S9vzWKEYLHmXSkbw8Cj/IF0dvhl7PEP5O/0STx9c2/0Wa6sAAe5mEWnArcZFsCT3ooWbi1s7TwuRZY+oacAp0g9AmrPnazjjPsSOltZEnNaw2JPhLVozkzuJYWTkJ9t09L35BohWeAe8qLcNdP+A1/rLVD2FMaDe5vatt7tnxK6T1j72TYyTWLZ5GYcTk2xXHKKsuAZTquw5x6mA3uAhXnhw4gKBgHyoOnCqFQMtWd+gxeP0mLM4bsOi6gTPrth8gp9F8FAHu4saYiIkVAOZJLE88zJ9kbdFrsdeTdgNE2vxo3+dXMIUf5UsmCL88hsIEuj5mYAaopmLzh57Y+ph7z7uQMc3vRfBFb5vT+66jkWzSIpdlwsaFlhTMh4hPv5fo09aEufIFHOtf0ndBzfL1U24qFYFyfQ7AWvK7yaTRTihx3tQb8
 Im3XBj9G
 vXVLViKZGlsz2WwCEQm9IOw6cGZT4F3/Q4sObad5u3tiQW5pDJNpXMkTKK+9L98V/e9eOajFO8B6Y/Gch+4+cWmNfrfVGMnPirZsCe3nEFl4qIHdlWpj9I1xyoarOe6FdalzmmkA9d6Zo1QVXQ3fVihzjA2UJ4i0dtxY3PuYhlyacSwyKTwcGxjRVk44jmcpwvj0xkahS9dzZwaVGzc3Ek+i/dbMy6hF4CySNrLw+nlm0dqZZOGlCP+2buCHQF0vrwr3GMnpA76VR9bqEbtfS9VQoogG+pq1polRvuvaDddVg9zY6O2vzKAO9JcCVjaSL5g3XJEIfCPeXVSYQoS5EujmQP9KYhCcyuFzoIeY73BoyruLStV/evNf0bf3BxFvKfFgBlQdqyIC5OfCZY3msQ3atJsm1d+y08M4yLa+yGtOSr44nmbiXHrIsMl940kvmJUy1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to prepare to emit KASAN checks in JITed programs, JIT
compilers need to be aware about whether some load/store instructions
are targeting the bpf program stack, as those should not be monitored
(we already have guard pages for that, and it is difficult anyway to
correctly monitor any kind of data passed on stack).

To support this need, make the BPF verifier mark the instructions that
access program stack:
- add a setter that allows the verifier to mark instructions accessing
  the program stack
- add a getter that allows JIT compilers to check whether instructions
  being JITed are accessing the stack

Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
---
 include/linux/bpf.h          |  2 ++
 include/linux/bpf_verifier.h |  2 ++
 kernel/bpf/core.c            | 10 ++++++++++
 kernel/bpf/verifier.c        |  7 +++++++
 4 files changed, 21 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index b4b703c90ca9..774a0395c498 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1543,6 +1543,8 @@ void bpf_jit_uncharge_modmem(u32 size);
 bool bpf_prog_has_trampoline(const struct bpf_prog *prog);
 bool bpf_insn_is_indirect_target(const struct bpf_verifier_env *env, const struct bpf_prog *prog,
 				 int insn_idx);
+bool bpf_insn_accesses_stack(const struct bpf_verifier_env *env,
+			     const struct bpf_prog *prog, int insn_idx);
 #else
 static inline int bpf_trampoline_link_prog(struct bpf_tramp_link *link,
 					   struct bpf_trampoline *tr,
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index b148f816f25b..ab99ed4c4227 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -660,6 +660,8 @@ struct bpf_insn_aux_data {
 	u16 const_reg_map_mask;
 	u16 const_reg_subprog_mask;
 	u32 const_reg_vals[10];
+	/* instruction accesses stack */
+	bool accesses_stack;
 };
 
 #define MAX_USED_MAPS 64 /* max number of maps accessed by one eBPF program */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 8b018ff48875..340abfdadbed 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1582,6 +1582,16 @@ bool bpf_insn_is_indirect_target(const struct bpf_verifier_env *env, const struc
 	insn_idx += prog->aux->subprog_start;
 	return env->insn_aux_data[insn_idx].indirect_target;
 }
+
+bool bpf_insn_accesses_stack(const struct bpf_verifier_env *env,
+			     const struct bpf_prog *prog, int insn_idx)
+{
+	if (!env)
+		return false;
+	insn_idx += prog->aux->subprog_start;
+	return env->insn_aux_data[insn_idx].accesses_stack;
+}
+
 #endif /* CONFIG_BPF_JIT */
 
 /* Base function for offset calculation. Needs to go into .text section,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1e36b9e91277..7bce4fb4e540 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3502,6 +3502,11 @@ static void mark_indirect_target(struct bpf_verifier_env *env, int idx)
 	env->insn_aux_data[idx].indirect_target = true;
 }
 
+static void mark_insn_accesses_stack(struct bpf_verifier_env *env, int idx)
+{
+	env->insn_aux_data[idx].accesses_stack = true;
+}
+
 #define LR_FRAMENO_BITS	3
 #define LR_SPI_BITS	6
 #define LR_ENTRY_BITS	(LR_SPI_BITS + LR_FRAMENO_BITS + 1)
@@ -6490,6 +6495,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, u32 regn
 		else
 			err = check_stack_write(env, regno, off, size,
 						value_regno, insn_idx);
+
+		mark_insn_accesses_stack(env, insn_idx);
 	} else if (reg_is_pkt_pointer(reg)) {
 		if (t == BPF_WRITE && !may_access_direct_pkt_data(env, NULL, t)) {
 			verbose(env, "cannot write into packet\n");

-- 
2.53.0


