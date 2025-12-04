Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FD39D29FB2
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6066F6B00D7; Thu,  4 Dec 2025 15:04:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590BD6B00D8; Thu,  4 Dec 2025 15:04:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4310B6B00D9; Thu,  4 Dec 2025 15:04:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3886B00D7
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0196113A97B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:39 +0000 (UTC)
X-FDA: 84182866320.25.1342B85
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD5D020013
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=HOAKdMLt;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dN7+nGNlab1CM7HVM/7LyQrPieDz8A5oMJ4/DSch7hs=;
	b=FUOkNotADzOTT/tOqnaAy2UmY0eecRPiox8mcb7pAKB+jsUWklfHg0Ieu4Xlyt2F1tZgOq
	0Ds1yl1Q7VdBBdZN2MJKK4o+uv34Q+Ci0nUV9S5jpGjH7C8TBY8dUrMdoMsFrGiVXKEujn
	Vx3LdNcyOc/p2UZO8afpZggX5j1tj9I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=HOAKdMLt;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878678; a=rsa-sha256;
	cv=none;
	b=Zvnau0PN9RR/6/Z14HubFT/PACoK7vGfw2xJ9kFbtDMfTzulOe4W86N2duiZOndYXEDkxY
	iInfiAeMQ301oSxKsIAapz7UTc1Imp2eQDLmWNW+Zw8Eo6ztFv1yKXzFtdRb8l2Kl0/BuT
	PxXS0nR9g36hoLzj/JyciQYopDbrNVc=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29ba9249e9dso18465875ad.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878677; x=1765483477; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dN7+nGNlab1CM7HVM/7LyQrPieDz8A5oMJ4/DSch7hs=;
        b=HOAKdMLtypnaiSWvxjsU21cVlE2FRHTThqcV58vQ+ezKuBFEIBY+LPyvfOBvc/MH0q
         NcVj0uFjM+I1Qz2X46gBlVgKzxe35aJde3RTzwUOJmFEPq9wns9d1tSkxiwi8FGfwfG2
         gl8cUM3iuLOaX1FIrICf174NDEEKqmcbAp/E7DDBuAvZAlkPIs+w0yXO/ssjrMEpuyWS
         OEHaozVisvHiw9JEXR5p8chRF+K0Yra3iBPfKmITSn+t9Ox8WIPBotpqeWb1cCfYZ3eh
         8fX3wt3X2od5fx5ZxZsAgeU5Rkwq/qiWrDa3aV9PZ0Zne0UJww8PnoqgAzNmhrWwlm87
         ++kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878677; x=1765483477;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dN7+nGNlab1CM7HVM/7LyQrPieDz8A5oMJ4/DSch7hs=;
        b=pJsUvZz8ZMt3jZ+d0dFt3N2ZwLIKVgAN+aBjw7cVWafUj2oynCN/u6L+yC+d3SXC7B
         FLOfNkItLcdBmFNo+dnoVkb2EHR52vNvmvsvHmvQCW1odLI6rTXPbZiMBq/API8UARoR
         ifS8uMeTMJjYkHLXcS6rZrSGhNr0bYeXabqLufsS2951c1AFQ7H0+ns2UBN9t78kAHQy
         7y/gG9BoCIpiKHw8w3wYiH49K0fYTvK5DH8NS4iC7OK4Hu62tb4lPgFWPXC47dL4DlCr
         HifCKjfiQtGVuBP2Z6KR2mcawDw+OG1CuovAQvtCvkWMIz4ynab+u1nBG8TKQgCQc34m
         AZaA==
X-Forwarded-Encrypted: i=1; AJvYcCU3XtT9hN42J/BFZJtgcceP7yAHcEtUrZCCaBD122IaDpL9KCleOPXC54sqYTe+vWzIptmbHN9kLA==@kvack.org
X-Gm-Message-State: AOJu0YzB+wblmE4Ch9kUwi7/FGN0I9asgxZJ62jx4Yz0Gx+D3c3Wj/pw
	sIWsQdhS9TCTvZbgWzBIvyh1yXLxUoRusqYltujcYUop3KXjiIbsqph4QX/39H43rVo=
X-Gm-Gg: ASbGncsZQsdGhJQ69uQKsIj/4nCsK8HS6T8m06Mx4cF/D19w0GiUsRlXyBsUh/8w5pv
	3zyu6lro1pTPi1bVO/alruozsl/0jdpC2BGaVOnfE+ArLQzMI9ErXAieI14CUCAel87wjjKBHRP
	0Hc1KaXzf6Ut1Gf+DRgmc4CjniWJbxTY5nMqFILTdx8CP1XXUsm0XXthei9nt0Ul5dVeVkzosVx
	0B/zWj05/BUbrjuv+7W6BMnDUzxvo5WoOIopmpIFX0lhShTY+xZ7jt0VfQ9xqI6LpDLxyQLMQPD
	eAPoPTup9IHE0JJAB8OGBKSzAGPkced1bFmP5oLw+SsolSzwvPAu/YYNh3MkjAKWA2ia4sv7k4X
	CKc9Nznxe2xE+QVMortfYohVIP4iOv2oE2AYTq86/nRxBo2RU0fwh/MubZRA3Fi3pJEE8KPhkOk
	p8zto2XaO0TjtF9HdZuQ88
X-Google-Smtp-Source: AGHT+IHj0QFs6DrL0ebWPEV5RuFpxKFJlt+LdfkWO+VR/ZCV6Jk0jLfHTAA1dSjK+Prpj+cXoIojMA==
X-Received: by 2002:a05:7022:6b88:b0:11d:e40f:ee69 with SMTP id a92af1059eb24-11df0c46f1cmr5502645c88.36.1764878676554;
        Thu, 04 Dec 2025 12:04:36 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:36 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:08 -0800
Subject: [PATCH v24 19/28] riscv/ptrace: riscv cfi status and state via
 ptrace and in core files
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-19-ada7a3ba14dc@rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
In-Reply-To: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
 Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878636; l=6975;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=10adw+B6s48GPS/UC8IWlsl2AVRKonZeAmtNEJH3LPo=;
 b=CMZQRWz2W8CrkddpWb9ozS+EDBkizyUuT/D23DUG5KA+ZTl0kvMohkWejR2AbP4Ckfzq8LmK6
 vbl0smGVKKlDeejUnXC5Wfh1RECC3yaX9MC67oPNwQa+KLqt2UyMs49
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Stat-Signature: iw6s8jjyeikpqusyp7a6gj6qaaraydga
X-Rspam-User: 
X-Rspamd-Queue-Id: DD5D020013
X-Rspamd-Server: rspam09
X-HE-Tag: 1764878677-214586
X-HE-Meta: U2FsdGVkX1+R+VZ7/H0tgeYjY0zeiaB8wqMudfIDcle6rqTs1scuTPqvD+NkAQfVPW8E3ADrHFAuHelqnhgtA9EsXbpAhuraIK0BNx9z9n9HSQ4J0Fc2fIlmJTkb14U1fXgRp4pbqhZEohSuTcROWi2BEe3FzBrRN/B4hivtc+OlwdQyr/PnXzEPbb2/RPc18oe53bRXHGTY4gjt1AsaeF2nefiWhEHKUDethXyQICt7WOD2gdjOEtbgW9cVJrEwhzbk7RHZFe7o/cuCeHd3PE/T5jy3k1rjCxP1RG8XjzlpZ8P15DQhke7a2DWCtWlN55xyJHeeqwpXkdTOLSJqyvKGY08SG9bmRHW0DLDZNFEoEyA5+ZF/nO9FN20YkJ+2GGPog21vyGwKIB/lfPMUS23ZLhv3Y4Z/CqUagqSt1lXSVWGuMQnZnK2imqnvSzt5sDTyIMBGDaB2tcJUcr5wiBf0IouQU9W7TpFSSXRTMmnqPIhoI6ys/P40CTbWMcLlclGxr18c2lcv9Z6Au9W3rm3llJFZHYvdOW9Wje9Om1Cqmhue7iPot9qgfoLPQLZHVlNula8HPkGrSwI/+S0pFXMFVHZ8R8Av8rhl1ig38ZyOER3haDL+rPvfLBA0OnkV1hs8kDsVFoarZh+F0X4pdyqrrFGecxOjs7tnip4SrpVvNaIuL6Ve5LvsZ00kowYIfshJUYSqNanwsx8yRvOcfrxP6IKmq1deWRfJL+5TQQS4Tm/yxxZXmBbon2vJaL7ZQFwmDAKBOg7DtMh6LlmcMKHbrdofgvRuhUbSJuLx5yWm4lISSG5+fimwFNex+OWCvGwSv15M5Jv596VGDcS1u/OXT9Vu0a5mj7tit+/7NPF78h67h0qfBKq7/WYsWLU7TIeASiR8+9lVDM7CJElyTlockgxC/fb4qiReD2Ax0LhnWQs8hDkmeU+TseF/XUskqt/ObiD/b51muIIdoet
 ZSte9PcM
 B0vGBCBPCkZh7gkmzBAXx2jSjf3VwgGH5k98aqhaRywg8oGQvnAeRhQB5lGk20VfX7UN4STdMxa8mtvL0fY6keEzbQI+iTyNTNbMrH6sd35uQXZI+IIu4QI88gzIH/KkCkjq6M7PEC00A9s/YCSpSNiBaj3feRWqH6/N9GOdhlC5hBYi+sp9+LEqSXJmyWNizG2mgP6Vj0KvA/ffHtQQU1/2VHI5S2VOfpPN+U1Umq7y/JGbe6Dx7AtX41VQ2eRRr39qfaQeacR1UfnQlu4MCdkQUDr7t1C48ee1ad3ti1oN+cO8Q05izgxkMU8XdZ292GHCjsoGfK9rkFuuvQpVdjwfu+SJaERw6wtRwxantKSoMfaYRj9gv8IkJojmqP5LpUx4cTslfEugxHwiPRa5no7TpnKvNHvgSPTDRg1uQxP6vT2vik9xv9r0V0AsAyd15zaXeNugLQ5pLmWHAwpfKDD7g6kIlWXc661Ni
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose a new register type NT_RISCV_USER_CFI for risc-v cfi status and
state. Intentionally both landing pad and shadow stack status and state
are rolled into cfi state. Creating two different NT_RISCV_USER_XXX would
not be useful and wastage of a note type. Enabling, disabling and locking
of feature is not allowed via ptrace set interface. However setting `elp`
state or setting shadow stack pointer are allowed via ptrace set interface
. It is expected `gdb` might have use to fixup `elp` state or `shadow
stack` pointer.

Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/uapi/asm/ptrace.h | 30 ++++++++++++
 arch/riscv/kernel/ptrace.c           | 95 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/elf.h             |  2 +
 3 files changed, 127 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
index 261bfe70f60a..b2a18dfeb2fb 100644
--- a/arch/riscv/include/uapi/asm/ptrace.h
+++ b/arch/riscv/include/uapi/asm/ptrace.h
@@ -131,6 +131,36 @@ struct __sc_riscv_cfi_state {
 	unsigned long ss_ptr;   /* shadow stack pointer */
 };
 
+#define PTRACE_CFI_LP_EN_BIT	0
+#define PTRACE_CFI_LP_LOCK_BIT	1
+#define PTRACE_CFI_ELP_BIT	2
+#define PTRACE_CFI_SS_EN_BIT	3
+#define PTRACE_CFI_SS_LOCK_BIT	4
+#define PTRACE_CFI_SS_PTR_BIT	5
+
+#define PTRACE_CFI_LP_EN_STATE		(1 << PTRACE_CFI_LP_EN_BIT)
+#define PTRACE_CFI_LP_LOCK_STATE	(1 << PTRACE_CFI_LP_LOCK_BIT)
+#define PTRACE_CFI_ELP_STATE		(1 << PTRACE_CFI_ELP_BIT)
+#define PTRACE_CFI_SS_EN_STATE		(1 << PTRACE_CFI_SS_EN_BIT)
+#define PTRACE_CFI_SS_LOCK_STATE	(1 << PTRACE_CFI_SS_LOCK_BIT)
+#define PTRACE_CFI_SS_PTR_STATE	(1 << PTRACE_CFI_SS_PTR_BIT)
+
+#define PRACE_CFI_STATE_INVALID_MASK	~(PTRACE_CFI_LP_EN_STATE | \
+					  PTRACE_CFI_LP_LOCK_STATE | \
+					  PTRACE_CFI_ELP_STATE | \
+					  PTRACE_CFI_SS_EN_STATE | \
+					  PTRACE_CFI_SS_LOCK_STATE | \
+					  PTRACE_CFI_SS_PTR_STATE)
+
+struct __cfi_status {
+	__u64 cfi_state;
+};
+
+struct user_cfi_state {
+	struct __cfi_status	cfi_status;
+	__u64 shstk_ptr;
+};
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _UAPI_ASM_RISCV_PTRACE_H */
diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index 8e86305831ea..56b9e3871862 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -19,6 +19,7 @@
 #include <linux/regset.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
+#include <asm/usercfi.h>
 
 enum riscv_regset {
 	REGSET_X,
@@ -31,6 +32,9 @@ enum riscv_regset {
 #ifdef CONFIG_RISCV_ISA_SUPM
 	REGSET_TAGGED_ADDR_CTRL,
 #endif
+#ifdef CONFIG_RISCV_USER_CFI
+	REGSET_CFI,
+#endif
 };
 
 static int riscv_gpr_get(struct task_struct *target,
@@ -184,6 +188,87 @@ static int tagged_addr_ctrl_set(struct task_struct *target,
 }
 #endif
 
+#ifdef CONFIG_RISCV_USER_CFI
+static int riscv_cfi_get(struct task_struct *target,
+			 const struct user_regset *regset,
+			 struct membuf to)
+{
+	struct user_cfi_state user_cfi;
+	struct pt_regs *regs;
+
+	memset(&user_cfi, 0, sizeof(user_cfi));
+	regs = task_pt_regs(target);
+
+	if (is_indir_lp_enabled(target)) {
+		user_cfi.cfi_status.cfi_state |= PTRACE_CFI_LP_EN_STATE;
+		user_cfi.cfi_status.cfi_state |= is_indir_lp_locked(target) ?
+						 PTRACE_CFI_LP_LOCK_STATE : 0;
+		user_cfi.cfi_status.cfi_state |= (regs->status & SR_ELP) ?
+						PTRACE_CFI_ELP_STATE : 0;
+	}
+
+	if (is_shstk_enabled(target)) {
+		user_cfi.cfi_status.cfi_state |= (PTRACE_CFI_SS_EN_STATE |
+						  PTRACE_CFI_SS_PTR_STATE);
+		user_cfi.cfi_status.cfi_state |= is_shstk_locked(target) ?
+						 PTRACE_CFI_SS_LOCK_STATE : 0;
+		user_cfi.shstk_ptr = get_active_shstk(target);
+	}
+
+	return membuf_write(&to, &user_cfi, sizeof(user_cfi));
+}
+
+/*
+ * Does it make sense to allowing enable / disable of cfi via ptrace?
+ * Not allowing enable / disable / locking control via ptrace for now.
+ * Setting shadow stack pointer is allowed. GDB might use it to unwind or
+ * some other fixup. Similarly gdb might want to suppress elp and may want
+ * to reset elp state.
+ */
+static int riscv_cfi_set(struct task_struct *target,
+			 const struct user_regset *regset,
+			 unsigned int pos, unsigned int count,
+			 const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+	struct user_cfi_state user_cfi;
+	struct pt_regs *regs;
+
+	regs = task_pt_regs(target);
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &user_cfi, 0, -1);
+	if (ret)
+		return ret;
+
+	/*
+	 * Not allowing enabling or locking shadow stack or landing pad
+	 * There is no disabling of shadow stack or landing pad via ptrace
+	 * rsvd field should be set to zero so that if those fields are needed in future
+	 */
+	if ((user_cfi.cfi_status.cfi_state &
+	     (PTRACE_CFI_LP_EN_STATE | PTRACE_CFI_LP_LOCK_STATE |
+	      PTRACE_CFI_SS_EN_STATE | PTRACE_CFI_SS_LOCK_STATE)) ||
+	     (user_cfi.cfi_status.cfi_state & PRACE_CFI_STATE_INVALID_MASK))
+		return -EINVAL;
+
+	/* If lpad is enabled on target and ptrace requests to set / clear elp, do that */
+	if (is_indir_lp_enabled(target)) {
+		if (user_cfi.cfi_status.cfi_state &
+		    PTRACE_CFI_ELP_STATE) /* set elp state */
+			regs->status |= SR_ELP;
+		else
+			regs->status &= ~SR_ELP; /* clear elp state */
+	}
+
+	/* If shadow stack enabled on target, set new shadow stack pointer */
+	if (is_shstk_enabled(target) &&
+	    (user_cfi.cfi_status.cfi_state & PTRACE_CFI_SS_PTR_STATE))
+		set_active_shstk(target, user_cfi.shstk_ptr);
+
+	return 0;
+}
+#endif
+
 static const struct user_regset riscv_user_regset[] = {
 	[REGSET_X] = {
 		USER_REGSET_NOTE_TYPE(PRSTATUS),
@@ -224,6 +309,16 @@ static const struct user_regset riscv_user_regset[] = {
 		.set = tagged_addr_ctrl_set,
 	},
 #endif
+#ifdef CONFIG_RISCV_USER_CFI
+	[REGSET_CFI] = {
+		.core_note_type = NT_RISCV_USER_CFI,
+		.align = sizeof(__u64),
+		.n = sizeof(struct user_cfi_state) / sizeof(__u64),
+		.size = sizeof(__u64),
+		.regset_get = riscv_cfi_get,
+		.set = riscv_cfi_set,
+	},
+#endif
 };
 
 static const struct user_regset_view riscv_user_native_view = {
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 819ded2d39de..ee30dcd80901 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -545,6 +545,8 @@ typedef struct elf64_shdr {
 #define NT_RISCV_VECTOR	0x901		/* RISC-V vector registers */
 #define NN_RISCV_TAGGED_ADDR_CTRL "LINUX"
 #define NT_RISCV_TAGGED_ADDR_CTRL 0x902	/* RISC-V tagged address control (prctl()) */
+#define NN_RISCV_USER_CFI	"LINUX"
+#define NT_RISCV_USER_CFI	0x903		/* RISC-V shadow stack state */
 #define NN_LOONGARCH_CPUCFG	"LINUX"
 #define NT_LOONGARCH_CPUCFG	0xa00	/* LoongArch CPU config registers */
 #define NN_LOONGARCH_CSR	"LINUX"

-- 
2.45.0


