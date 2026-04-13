Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F32BF531C1
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A723C6B0088; Mon, 13 Apr 2026 14:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49856B0098; Mon, 13 Apr 2026 14:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA2E6B0099; Mon, 13 Apr 2026 14:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5DF6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:29:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B3231B72F5
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:22 +0000 (UTC)
X-FDA: 84654370164.07.122F3E0
Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id 244B8180008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=plX1wAia;
	spf=pass (imf16.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776104960; a=rsa-sha256;
	cv=none;
	b=iQGk+sLFd8aGoqZvMOeDm4Il9URU+Gjld3qrIN92ukT4R+ux/N9bYcURRoWvOQtsHNylTY
	JlYATmtdnwNgSl69OMAwzZnCWwCNQRkC5v5WjFyAy9yW+VS5ckkaMZavi67EaLHdS3k5hx
	pUPoal77HLU7NEcSiMP5P1iuv/Oseh0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776104960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEqpkfSG4bvQgxtPI4x8t4f5ElxNEGTXzPOFRzqjwCY=;
	b=IfAvA/zVxXjEroC6yI5bJAlZnNAHytibSQQfnwd3PkP5t4fbixz5J1ZlgUdB6zER2JeGN9
	5UuN+6GRCwy0n0enF0QMLCRscId7ONGWl19MU2GOGC8nrQue9pvMyk0638H35tlHVJZYhq
	5bIWnMOaLFXMmNYM+X2SU7EOaN3GxC8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=plX1wAia;
	spf=pass (imf16.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.84.56 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id B63791A3212;
	Mon, 13 Apr 2026 18:29:18 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 8A00C5FFB9;
	Mon, 13 Apr 2026 18:29:18 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9615210450503;
	Mon, 13 Apr 2026 20:29:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776104956; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=lEqpkfSG4bvQgxtPI4x8t4f5ElxNEGTXzPOFRzqjwCY=;
	b=plX1wAiahNNvYLrmKHyngjgbUZTsjXMi0XkNrQqatZIZfwi5y+MpfMYnpaPSrFPPIx5z1o
	DjTmJalfQiDo3KOvAbGJ1qE8SiwJJI0z30hz7Hh1mg2vocPtrjUgfmRmqgaiTA1AVxu05f
	TSmPLflLKUoX/QhZnH3X4nY86J0jvLHmL8Prsn2b5oH9X82bb0dFnuzoVhoZEXNtsuu8LG
	RYUj2X6gdbavH0vUvSLXR3PcQcqHbq/u/pQ6CScqPoDPnGCm0BxblVPKU5DjB93iCZrcYO
	uXojuVumNxIojmUJCrrBnPbAjhBsiAlqNEnuhQUM5TcX823OQvFjhzlelwNoqg==
From: =?utf-8?q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
Date: Mon, 13 Apr 2026 20:28:45 +0200
Subject: [PATCH RFC bpf-next 5/8] bpf, x86: emit KASAN checks into x86
 JITed programs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260413-kasan-v1-5-1a5831230821@bootlin.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 244B8180008
X-Stat-Signature: d7w53ipuhcfwtyq7z8f7sx1zfkjzrby4
X-HE-Tag: 1776104959-144867
X-HE-Meta: U2FsdGVkX1/cj5FnAjOinIkUhPMutu3I4hUYTJz2l/2x+91kUMupv2CLpEuUNVOo7SjRA2Fu3inNGyBxpiIC5hIeu2Xf+9VRZgY1uHyxo6hHEmi16lZmZxPgJ7nG2dUE2poewpwPQkt/QtFFfn7uQFwqKpj/OtF6Y4z6C9agEfucQytSCYNb/yFVqYZ4liCA6ViKOdyhaFl0Fhdkm28pXP6o7UirWGapnN88aq+lf0Jqe3OIP0kSEkl8rX28Py0fpRqxyqvWeWs9OD4CdviBlBUTTXbr0eFsGAzEI9LdoCUSsbpX2Q8pVWrJHZlDXmCLNzO0Y6FTBBWPYJHRZTx61K/b5xjvV1h6KPncjEx/cBZZzhkDDxkNH3xkRMIgkJhUHuTdH9qWrFJew3Q+nacdbKQ2lqYBcRcFM20HHfmWFEf2qcSaTUhu+Yk/pk5AWdgtDK4Qi/5OBTB8jxawtwmyfmoPhyemCGyjERnLBp/oozQYbH4QmMITBd++bdDlWgMgw3Qn4l3+5arDCOkMEq9qHhnILOe3r4uBDdqsgXy5SrgrkytufkaBFhznhznYZ+aNhFYbnBow/9fIczfR4oZtpQLNb7XgqvNNYS1T/PJbufdDCd91TGv6OOE0K9BE0jBfBzhpoP3jQpKJ4Nh17bCWq9Sdd3t51QotCWdVWBMybXml6sFccfY5knMqRcShtwGAENWFiRH0tivW/VRhSFv0JgsSC4uBK8NWgt3Ho+KMxEyUHcT5C8yRgPU2pMtjMGNtUiJYMFFsOEcxQOhGVIFw8dMaTPHHgqLfdTlAhqPMZ2CQE8Xy54XIkFb4aNAv4sTGjansrz/BbiDrc/btKmr4cHGUB5jCFAZLTRlJA30uhVBI5CZSiKYoCXyT8medp4WyW9hbLtD6+Ns4laHGGJk9j1sLjsEZHMueX1SxCCrYYx5AZGT6ltHUIe7UK9JlcAopceqAMbXhEBiQKcWkPPG
 ifDKbu9l
 EJRR+c0d66IgRT7pRv/yygI2NkYPt52HpY1ddjPtRdyorho0RpDRwsMZJ5d/MTOQaZsYO2bo3+QUC5nbHJzUGZnY1Cqq55YCKBmTkV2TpX52oGR4lqbwp+MrvJHp9aIlkwWypthVmHuJiGS9jHpRatnhDWcxTetc0AjrGU9Xb0JJJLTvIVhxhYOHXdm3ULEFcrGgSlCke3rN9KppOw+2nmMBOG7E9d9xgTy1dGd/kMHw2ns/kvBKjDsjPxQ3Iu6WPMO2l/yXa2QqJJW/JlDWqtqPSjJ7Leoun6ySkTI5xirNO7BChiQFLGbvVFvN/piI/IAt34MmZNJ4er9I369id6FSVSSjgEFbhsrHFnDrOEHgPezp4u/IfnjOpyhECT6inKAr+zHDVzjuEkg2w2es8K80kXEorMN9KDp1chl917LeU9BF7U1v3RNKrPvBjBt0OkaoZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Insert KASAN shadow memory checks before memory load and store
operations in JIT-compiled BPF programs. This helps detect memory safety
bugs such as use-after-free and out-of-bounds accesses at runtime.

The main instructions being targeted are BPF_LDX and BPF_STX, but not
all of them are being instrumented:
- if the load/store instruction is in fact accessing the program stack,
  emit_kasan_check silently skips the instrumentation, as we already
  have page guards to monitor stack accesses. Stack accesses _could_ be
  monitored more finely by adding kasan checks, but it would need JIT
  compiler to insert red zones around any variable on stack, and we likely
  do not have enough info in JIT compiler to do so.
- if the load/store instruction is a BPF_PROBE_MEM or a BPF_PROBE_ATOMIC
  instruction, we do not instrument it, as the passed address can fault
  (hence the custom fault management with BPF_PROBE_XXX instructions),
  and so the corresponding kasan check could fault as well.

Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
---
This RFC also ignores for now atomic operations, because I am not
perfectly clear yet about how they are JITed and so how much kasan
instrumentation is legitimate here.
---
 arch/x86/net/bpf_jit_comp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index b90103bd0080..111fe1d55121 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1811,6 +1811,7 @@ static int do_jit(struct bpf_verifier_env *env, struct bpf_prog *bpf_prog, int *
 		const s32 imm32 = insn->imm;
 		u32 dst_reg = insn->dst_reg;
 		u32 src_reg = insn->src_reg;
+		bool accesses_stack;
 		u8 b2 = 0, b3 = 0;
 		u8 *start_of_ldx;
 		s64 jmp_offset;
@@ -1831,6 +1832,7 @@ static int do_jit(struct bpf_verifier_env *env, struct bpf_prog *bpf_prog, int *
 			EMIT_ENDBR();
 
 		ip = image + addrs[i - 1] + (prog - temp);
+		accesses_stack = bpf_insn_accesses_stack(env, bpf_prog, i - 1);
 
 		switch (insn->code) {
 			/* ALU */
@@ -2242,6 +2244,11 @@ st:			if (is_imm8(insn->off))
 		case BPF_STX | BPF_MEM | BPF_H:
 		case BPF_STX | BPF_MEM | BPF_W:
 		case BPF_STX | BPF_MEM | BPF_DW:
+			err = emit_kasan_check(&prog, dst_reg, insn,
+					       image + addrs[i - 1],
+					       accesses_stack);
+			if (err)
+				return err;
 			emit_stx(&prog, BPF_SIZE(insn->code), dst_reg, src_reg, insn->off);
 			break;
 
@@ -2390,6 +2397,12 @@ st:			if (is_imm8(insn->off))
 				/* populate jmp_offset for JAE above to jump to start_of_ldx */
 				start_of_ldx = prog;
 				end_of_jmp[-1] = start_of_ldx - end_of_jmp;
+			} else {
+				err = emit_kasan_check(&prog, src_reg, insn,
+						       image + addrs[i - 1],
+						       accesses_stack);
+				if (err)
+					return err;
 			}
 			if (BPF_MODE(insn->code) == BPF_PROBE_MEMSX ||
 			    BPF_MODE(insn->code) == BPF_MEMSX)

-- 
2.53.0


