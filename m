Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C592CF531C2
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1982E6B0096; Mon, 13 Apr 2026 14:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16F9B6B0098; Mon, 13 Apr 2026 14:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085E36B0099; Mon, 13 Apr 2026 14:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E87556B0096
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:29:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5F888ACB4
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:17 +0000 (UTC)
X-FDA: 84654369954.05.9440558
Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	by imf07.hostedemail.com (Postfix) with ESMTP id B30FD40016
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=tU3LuWoK;
	spf=pass (imf07.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.85.4 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776104956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZ9QNHVh4+uhbJNai/qeDRTtUjcNGDJs+CZJDfExdHo=;
	b=M4WaP3QAZtUhqQvw7VpCTfT5NnKYIoFFuKzs3rr+6selluzhDd8sdjgnNv8gAc8D9t90Ok
	RZww08yvItINoYRX8MDu3vNaYWLhxT4BGRhEvGL+AyTeheBIESrjVkDI+vMAFi06Z/PV6u
	xaE1zpopeWS4/HJw0kh/xDM5W33OoMU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=tU3LuWoK;
	spf=pass (imf07.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.246.85.4 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776104956; a=rsa-sha256;
	cv=none;
	b=pAqH/CSLGrTn1yiXH+hpt/VJL2+9mObOXjNQj/H4xYISv/62sQoWMBRBKaEjAMyDgoSwww
	YEYNRxFSENXXiqKXkofZyOcFLJomiqRZd0HxS2MrijvOVs16tlFV2Vv3tBlcgP/2lvfMSx
	EEGilwfxIoOKstuqOiodx+4wYU4uGJg=
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 40AB54E4296B;
	Mon, 13 Apr 2026 18:29:14 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 12D465FFB9;
	Mon, 13 Apr 2026 18:29:14 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C1BDD104504FF;
	Mon, 13 Apr 2026 20:29:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776104951; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=EZ9QNHVh4+uhbJNai/qeDRTtUjcNGDJs+CZJDfExdHo=;
	b=tU3LuWoKhbTd/7Bxp1dXOKmfzCbIyM/apO7e06VCsD1jAsO4aLusD9iNvmTwRoTGhYfuwa
	wQZ7Rhbfb4u6sA8kE0gRYqT1AsgMWfuInBNGDoegkt/sWjx5ENCvIIXWwTgo20otsCojZP
	qrlqmy/FI1dRvldQRHMleciN+IrFbLo2xJNLYZvURj2eGuPQxDXbJc0BXHvub1UsIRBf4H
	mkvyg1Tslg616M4ELISPPqoHcW+Kxr1M5uTSiYfx3ITKBUuAg1vOl/i9+jSYHNNg73X48w
	ntFV2SF9Jnvw+i/JAmppuCLNjEJUuRSS7aTexPw9lUZ3mBum9FcJl9syieudEg==
From: =?utf-8?q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
Date: Mon, 13 Apr 2026 20:28:44 +0200
Subject: [PATCH RFC bpf-next 4/8] bpf, x86: add helper to emit kasan checks
 in x86 JITed programs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260413-kasan-v1-4-1a5831230821@bootlin.com>
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
X-Stat-Signature: z8b7cq3zomck7pnduy63rqn17jqjw1c9
X-Rspamd-Queue-Id: B30FD40016
X-Rspamd-Server: rspam09
X-HE-Tag: 1776104955-247696
X-HE-Meta: U2FsdGVkX1/brsqSzpL3qRCsVXRpDbGDp9Aaba9H53tlN5hfVK987HAkNecxikDkUYNysVdcZ34F5LrdkQ3BFXowRhdWyWLnj2bYtmAmLy0es69hRI+24Zk+ghubLMEO8FGz8ZTUoFcUtQRCyzVyrg/fP027NKhQButS/55jqjalabE78UrY2soLZvCW5d/OBYwLIoxYH5YdeRyrtQLjlD8XWMVoTHol+/um02FYQSGZBmLFcoCK43FLM3jCKmeRY0X+SZMqtvLtS/4TxFnOLM6nqSx3NN71IjpEP/ZslSzXqdy+2r9v53xKKkL4CJcQDFmuaiFwIbUCzHyeiy0YYtlKD7Yhi0WuUGQZIPgPAjZ0uLnROu6E6P2wdy3c2IalOrmRz/AUYx/jheuUZE5oYmK1KjmYG8DWOMUufNt/sE+hV5mGZ+XpbDPPpt4joFupDC8xqivljdIQH4gGIpNP1PJ2JEcO999vAHJcwuW2M1D7SjHbzBK86Jvm6EDI4JTBSaS+/3mwzT/A0zlfvfnSn+lJ7UT7arf6fKAAO4oufbvP8BoyIomT08tWmif1MsKln2SDehGIPq8iMS+xVaSmXnewanpjsqFUZHLiCoriWVgxCbMiq/sVufh9jnXbv4p1w4Fib5VTtE3Zt0WhlPP70HM0OtCjb+Ia4/LXEjSMUSRkuq+yw/12RwG40yyO2q2xFm0a5FQDwshxgyyP71GyQDjd26WwlEnDF42dVrio7shh0C776V5wSrY2iSuKjSC4f0yDEjGPg7NQulwIweXIWeXmngDzHbrV6h5EmaUzqJqqhRMwDYUpXL6DG5blFkppPFJuU9uz9iP15neNBWccAj7Un+sU0HyykZ+I0Jep/t6jDQkAbE0qs1SJFTKxeEqj+HpLqGS4bGZFbzni1BIksUKlhs7zucC/phzJtsPb14GpaWoSk5KLqTIfgXmkgXOKtcelVeIAswcG35gxxkT
 4EpiYvSW
 Nt7TDjAoKWTg+Al/xU8FWODaDj4O4c17/dpDf8PYBCkZXVOyAE4QyFrenoxxZp5KzwPkljovYofltfgkcoymlKATDDWKNMz7l+birRZSNX5/OH47dS5H1nuhJmxxYlzXcYCjl8nPMi2CpWxDJ3nizojur97sAAnSjby9GaZxevsrd0XGrPrO+ACPAoKZE77dtrIv/pOgTPLeznYc8jB+pVACghE+u7nIF5D88IaqiNiHbDfpGqFQITrPaPLaonGy02AczjKTEEYBQ+vAAr+Pr1eOVchVPjuXPaWRRt6yKLlqC+nuuMkMr6ma23abDx/CVYCb591TgiXE6AN2A4k3/tGPp9KXcY9GuGSrUcbrbiTMBkxC7Q3+18Qxx2SW8sgFVSA1wxljtuG3c8phZ6IuYTQYfMoxYScavl1LK0suFnbPcNaGgo206dTPAIhV1NUV6xpyD63PWCSRIT2tGQvCV+onPpQTnFZvSInjw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the emit_kasan_check() function that emits KASAN shadow memory
checks before memory accesses in JIT-compiled BPF programs. The
implementation relies on the existing __asan_{load,store}X functions
from KASAN subsystem. The helper:
- ensures that the kasan instrumention is actually needed: if the
  instruction being processed accesses the program stack, we skip the
  instrumentation, as those accesses are already protected with page
  guards
- saves registers. This includes caller-saved registers, but also
  temporary registers, as those were possibly used by the
  affected program
- computes the accessed address and stores it in %rdi
- calls the relevant function, depending on the instruction being a load
  or a store, and the size of the access.
- restores registeres

The special care needed when inserting this instrumentation comes at the
cost of a non negligeable increase in JITed code size. For example, a
bare

  mov 	0x0(%si),rbx # Load in rbx content at address stored in rsi

becomes

  push    %rax
  push    %rcx
  push    %rdx
  push    %rsi
  push    %rdi
  push    %r8
  push    %r9
  push    %r10
  push    %r11
  sub     $0x8,%rsp
  mov     %rsi,%rdi
  call    0xffffffff81da0a60 <__asan_load8>
  add     $0x8,%rsp
  pop     %r11
  pop     %r10
  pop     %r9
  pop     %r8
  pop     %rdi
  pop     %rsi
  pop     %rdx
  pop     %rcx
  pop     %rax
  mov     0x0(%rsi),rbx

Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
---
 arch/x86/net/bpf_jit_comp.c | 93 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index ea9e707e8abf..b90103bd0080 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -20,6 +20,10 @@
 #include <asm/unwind.h>
 #include <asm/cfi.h>
 
+#ifdef CONFIG_BPF_JIT_KASAN
+#include <linux/kasan.h>
+#endif
+
 static bool all_callee_regs_used[4] = {true, true, true, true};
 
 static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
@@ -1301,6 +1305,95 @@ static void emit_store_stack_imm64(u8 **pprog, int reg, int stack_off, u64 imm64
 	emit_stx(pprog, BPF_DW, BPF_REG_FP, reg, stack_off);
 }
 
+static int emit_kasan_check(u8 **pprog, u32 addr_reg, struct bpf_insn *insn,
+			    u8 *ip, bool accesses_stack)
+{
+#ifdef CONFIG_BPF_JIT_KASAN
+	bool is_write = BPF_CLASS(insn->code) == BPF_STX;
+	u32 bpf_size = BPF_SIZE(insn->code);
+	s32 off = insn->off;
+	u8 *prog = *pprog;
+	void *kasan_func;
+
+	if (accesses_stack)
+		return 0;
+
+	/* Derive KASAN check function from access type and size */
+	switch (bpf_size) {
+	case BPF_B:
+		kasan_func = is_write ? __asan_store1 : __asan_load1;
+		break;
+	case BPF_H:
+		kasan_func = is_write ? __asan_store2 : __asan_load2;
+		break;
+	case BPF_W:
+		kasan_func = is_write ? __asan_store4 : __asan_load4;
+		break;
+	case BPF_DW:
+		kasan_func = is_write ? __asan_store8 : __asan_load8;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Save rax */
+	EMIT1(0x50);
+	/* Save rcx */
+	EMIT1(0x51);
+	/* Save rdx */
+	EMIT1(0x52);
+	/* Save rsi */
+	EMIT1(0x56);
+	/* Save rdi */
+	EMIT1(0x57);
+	/* Save r8 */
+	EMIT2(0x41, 0x50);
+	/* Save r9 */
+	EMIT2(0x41, 0x51);
+	/* Save r10 */
+	EMIT2(0x41, 0x52);
+	/* Save r11 */
+	EMIT2(0x41, 0x53);
+	/* We have pushed 72 bytes, realign stack to 16 bytes: sub rsp, 8 */
+	EMIT4(0x48, 0x83, 0xEC, 8);
+
+	/* mov rdi, addr_reg */
+	EMIT_mov(BPF_REG_1, addr_reg);
+
+	/* add rdi, off (if offset is non-zero) */
+	if (off) {
+		if (is_imm8(off)) {
+			/* add rdi, imm8 */
+			EMIT4(0x48, 0x83, 0xC7, (u8)off);
+		} else {
+			/* add rdi, imm32 */
+			EMIT3_off32(0x48, 0x81, 0xC7, off);
+		}
+	}
+
+	/* Adjust ip to account for the instrumentation generated so far */
+	ip += (prog - *pprog);
+	/* call kasan_func */
+	if (emit_call(&prog, kasan_func, ip))
+		return -ERANGE;
+
+	/* Restore registers */
+	EMIT4(0x48, 0x83, 0xC4, 8);
+	EMIT2(0x41, 0x5B);
+	EMIT2(0x41, 0x5A);
+	EMIT2(0x41, 0x59);
+	EMIT2(0x41, 0x58);
+	EMIT1(0x5F);
+	EMIT1(0x5E);
+	EMIT1(0x5A);
+	EMIT1(0x59);
+	EMIT1(0x58);
+
+	*pprog = prog;
+#endif /* CONFIG_BPF_JIT_KASAN */
+	return 0;
+}
+
 static int emit_atomic_rmw(u8 **pprog, u32 atomic_op,
 			   u32 dst_reg, u32 src_reg, s16 off, u8 bpf_size)
 {

-- 
2.53.0


