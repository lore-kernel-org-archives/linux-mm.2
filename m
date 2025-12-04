Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14344D29FB2
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6A726B00CD; Thu,  4 Dec 2025 15:04:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C7D6B00CF; Thu,  4 Dec 2025 15:04:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E216B00D0; Thu,  4 Dec 2025 15:04:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B29416B00CD
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:26 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 662851A0382
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:26 +0000 (UTC)
X-FDA: 84182865732.25.C019543
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3D58C1A0016
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=UpVIw3nX;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sAn4eyifcNxkK4OJtkwndj7H0VvpEsY65F3VIiHjxfM=;
	b=YWJbI+HHHUwiJiMZSQ6jovUdF0eE9Bn1Cn7ikqU/pQ3NpaUinkE1X0y6JTrjsxcPwjex+P
	QsWyGSAtnIPQWigv6RSRFKcEhpEPbKKTvK0mGSFQ83ZnTSEs6MSCQbvuWS8QhU359mDTrt
	bFlbIKUfPHVwR1JlVfIEPifdlPeVEQM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878664; a=rsa-sha256;
	cv=none;
	b=YV6AJrtXuIz5/jVPL/rL/Q3Cfk2ZQOu6HadBF+6JMvU0GNlLSIY2ebkCTkL2Bu4yzjtKVa
	qBWJt45D9cuEqhC8jlNVlelZsI3OsyjrBuSknrQN+5rMfUPZaS9a6SnIGvelWzrEruRRS+
	qC5kZcQjFKsqdVylde85Yvkdhy+dZvk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=UpVIw3nX;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so1181133b3a.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878663; x=1765483463; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sAn4eyifcNxkK4OJtkwndj7H0VvpEsY65F3VIiHjxfM=;
        b=UpVIw3nXWGJp+1RMroUH1+08x5rPte7idiEJQNN7/QNAakcUgCNAlQ1c/cBh65f30h
         Z9wWWV4OX1/BpRyp/JW8UNlmQ61o7PSZRLkAhwU72b4D79Va9zeBeQ/+3gBy8wM3tv/j
         RVyyKC2F/UOWJONVR+ENeqRtg/45n6Dv8FtkHgsNmb8swgJrq1WUUyClxIFI3wc4ZMFe
         qb/EwY2+v8HnjAD2R6NWjqNQSh0A2bff5RmkmXXNyeEksq/g7FDvHrXlcE+ZutmTLcXy
         0YgoL6xx314RTEOpfypKU03jXY0jxKlv6bh17w0FijLYNZ57sYvF6M1CkkpHvH00+Mmu
         pp+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878663; x=1765483463;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sAn4eyifcNxkK4OJtkwndj7H0VvpEsY65F3VIiHjxfM=;
        b=ATomib9WW/Jrxw+WnMenhJMxPBcAqc6dm+JTr4RWNZ1mm+AGwXUFRIOU04dVaHR2+D
         E6pCOXOrR/ycgB/IXTMM7FTsammYDk+SaM6q0IGxpGKJzr3x3H8oAb+/FRlHmyvBLTC6
         bIcrz5JFzO/b0pA8jTt5aa1mOy/aQPEvBOU3QjwTJrjJPaxYMeGyEJX/p9FTvYoLM+4L
         yrol5V10dcHTg8mJYNmxnOzxFdworq7KIHd+qvgbc0mChVlVGVQPzSRCY5opFmjak9Aw
         FyeITaHXRGEXewICUE6NcnpXrOV2y2sagMIHYy2TTTT0rx95hln4kU6vhDCwXe/OPTEV
         mCeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW7da2p65Gxcgf7YfVPWDxXm4CaFbVvhYaF1vjAmGgJTGPPci3rKDGUutM/ZttrryZ5KkNNIzv+w==@kvack.org
X-Gm-Message-State: AOJu0Yy5qHZT1VF1AH7zzZNvKbZ9zFWABrGBnTN2yqpCTQlQXmJXTAm5
	hYqUFUcyK+SwRV0LohWObYcZZ0d+gu8MI3Mv/1fg5vNZkGlfwagy1WG0kSVAjiBnhfg=
X-Gm-Gg: ASbGncv0YZ8dEQBvmeK4K17XIr0bPJAaqZCkZpKToGXUjKO32OBBsAMmKLbfuyOyeWL
	9bbPDojtBgairxbsImu/SBfKe9+I4hk3SWNbwQcPoe+AdQhX5rGjpcifSVwQy1rE6IEOuKyj9wl
	+1XO7/1N18MmrddyeCWwAW2JZFtUZw/cLvYE96mWr1TL5cZszRte0koskzpAh1Fj4EqY0uQY9qG
	uVg2Z+5G/slMTNQVd6kXSAN0FTJDueIKP8/1UDLb5wPFjcWmjO3U5XPHotWEHmLAdMvA/msoRke
	mVZPRA2Lzou4pYis1K8BxPBeoTkDpmYD0r4UYbab5N7VzyKLK4WdVDPkaVJPSzX9/RoDLaI5BWO
	ZDPtwc6+rPedziHZZGGvWKRCk7wnY59A/MxFOSy8t/u4IXwt3B2VIERKtlLFlbQ0LiwZMFP2HqO
	bLVPp6n6Vq6U1mAxACG/kJ
X-Google-Smtp-Source: AGHT+IHZviKfh6rSZnrsc9H+dFkwapEmofO4StEYkFD85GschOZnYY6gkRvLJyPxgwRJZCF8j610PQ==
X-Received: by 2002:a05:7022:6389:b0:119:e55a:9c04 with SMTP id a92af1059eb24-11df649d534mr3010415c88.32.1764878662786;
        Thu, 04 Dec 2025 12:04:22 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:22 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:01 -0800
Subject: [PATCH v24 12/28] riscv: Implements arch agnostic shadow stack
 prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-12-ada7a3ba14dc@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878635; l=7555;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=UB7DB8iQ68E73LowKHzcTBS0aUXVgW818RL3xhZs1m8=;
 b=EztNLj7IiLpxHRmvhuGHyQdgvmiXSvDSgvCh1a0ilHstgSwNC7TEp3aPWzusJY9Mm/LJ5PoKB
 VmqC3fQlY+TAzIlTzrOdVtAVubIkz/oNzQGqjRabLW3mDRXYa+VDMJt
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3D58C1A0016
X-Stat-Signature: 9egicbjuf7m4yjqcrberju6cqxqy9hor
X-Rspam-User: 
X-HE-Tag: 1764878664-968549
X-HE-Meta: U2FsdGVkX18OoswSf1aGPGlk5KAaRf55L/SSSr5tS0L38dVQKJdTNFm07MUiWdwxKDzjkLp6jPOAh0J8TTQEQ7x3kMMYQHQz4OazKFAt/v/47CMJjtCiUijv2KIQPSaduDVyZJ+Uyz/bSj3vRS02gPMC/U4bgCD2toxV2LbqckjxUI4VKBgN3cBfes6kWvPmaIbRmi9Bx+HI+TDREcXuQAz806CrtaactLthrZrk1mHmPJzy/5SGj2p1xdwz3wmz9Y1M+Tzkuq1X3VpPcmBl8vtbzmxg+7CSNG7xgCEHQApVgq5fUEk3xdvZbVyQnmzI/6Rl8RNNj/lS/TeekjkcTK5seZrLv2AYrdaj8tkAEKr/tdUWAglij+LaqwNzYUl5JIzieABYTpacAzynRORLvwAySpQW90OCKQzg6cMzb8nMnO1VAOMQ1QRe1msonJZ+QwFrSi9CPoIHHajhIWldbWhZmUe4Nv8Xz4FNdI4p1PRa7aqcA0M3Womg7QrSnDqOXcyLUo1TyW62Ept3ysxlSwRWPrzaKPctdfkhu42RVDZf325XKUOPEyZP3GhNLAdwTq3xOQ2To7DSAwEtvwggvGeZdx7hdLoAwThkAYVmw+/15N1oYEPmOTi8UutI8JKbw69WCAYH7riqSVJXpvNoRlOZOxIDZRAgDd1oyt/4C/Yj16f7E3o6wCdNU+QCl8s+X7vSRfVom/pP309ktNpeaZfdomqGKvTVyuDbbv+ewQTohXsgTrX3wZ0rr/+XolzMp5uTTqToX58fekoo6IqI4e7N4leUsgZ6ezh7vKiqFmdNRnectXeZ3nFMrJ84UlJm3yHe/vRr1D0Oi66aKS8t00E2Vh5RukpLOhTl+XS1Iouo7TMA6lXpOK518W+t6QQ7CunKNm0nUU8T+P4WrnZEDGR/FIn/JowrKcKp3UoR63mW1iSQX2ScyAw9Zf95BF9863nljJVStK8UxjnKnHl
 P+/TDm6F
 ZWwhr3DBw8kPxLsI3uv5b+ibnIW2FCwAXGrnWFTeaRpBIlf9VFJBz5F/LR4LHQwrV0z/O6Aleko3SYWxyoPpCP6pZftGFeoYJ3rAY8FgZI1lRK/u/jL36FegUuhwWLAzeGQTKyoG2xAKYjT6CvFIJZl5HtS2NOghZ8wtwifiegF43SvxN9BouNDt4F9dv6O9YH9su7wxxNwXxhcPM/rORNke7mHnXhKMnnxZ7ZqvjhB6aQwAxIo4EyWflkpC3RNDrPVxB9RXjCMYgRmgkx1DdiiWfA/3wbEpCFZFFEaMz4wAiG4xbsv0Oq6TxVrrCPeZgoRSqTgBq00/Lv/bIFD7T/R9TkD2k1Py5npmpe2D4M96rj2S15ZJJnUu5rJNHgR6tsn9wQl0RAZw5a2Pz6z/mkzkMhdcS0/KRRWc387RXqXFF6pYTnMXfXnAPYwENTLMZNJFBtUMqB2ZUNwDrpPFqC5Bwn2T27S0L6jo+doWz0TnFI+L4ePLEd8EbtgbHEtPTXyygzhk8K86UTpCQekDsSGuQFIez+D3g0aOW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement architecture agnostic prctls() interface for setting and getting
shadow stack status.

prctls implemented are PR_GET_SHADOW_STACK_STATUS,
PR_SET_SHADOW_STACK_STATUS and PR_LOCK_SHADOW_STACK_STATUS.

As part of PR_SET_SHADOW_STACK_STATUS/PR_GET_SHADOW_STACK_STATUS, only
PR_SHADOW_STACK_ENABLE is implemented because RISCV allows each mode to
write to their own shadow stack using `sspush` or `ssamoswap`.

PR_LOCK_SHADOW_STACK_STATUS locks current configuration of shadow stack
enabling.

Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/usercfi.h |  16 ++++++
 arch/riscv/kernel/process.c      |   8 +++
 arch/riscv/kernel/usercfi.c      | 110 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+)

diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index a16a5dff8b0e..d71093f414df 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -7,6 +7,7 @@
 
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
+#include <linux/prctl.h>
 
 struct task_struct;
 struct kernel_clone_args;
@@ -14,6 +15,7 @@ struct kernel_clone_args;
 #ifdef CONFIG_RISCV_USER_CFI
 struct cfi_state {
 	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
+	unsigned long ubcfi_locked : 1;
 	unsigned long user_shdw_stk; /* Current user shadow stack pointer */
 	unsigned long shdw_stk_base; /* Base address of shadow stack */
 	unsigned long shdw_stk_size; /* size of shadow stack */
@@ -26,6 +28,12 @@ void set_shstk_base(struct task_struct *task, unsigned long shstk_addr, unsigned
 unsigned long get_shstk_base(struct task_struct *task, unsigned long *size);
 void set_active_shstk(struct task_struct *task, unsigned long shstk_addr);
 bool is_shstk_enabled(struct task_struct *task);
+bool is_shstk_locked(struct task_struct *task);
+bool is_shstk_allocated(struct task_struct *task);
+void set_shstk_lock(struct task_struct *task);
+void set_shstk_status(struct task_struct *task, bool enable);
+
+#define PR_SHADOW_STACK_SUPPORTED_STATUS_MASK (PR_SHADOW_STACK_ENABLE)
 
 #else
 
@@ -41,6 +49,14 @@ bool is_shstk_enabled(struct task_struct *task);
 
 #define is_shstk_enabled(task) false
 
+#define is_shstk_locked(task) false
+
+#define is_shstk_allocated(task) false
+
+#define set_shstk_lock(task) do {} while (0)
+
+#define set_shstk_status(task, enable) do {} while (0)
+
 #endif /* CONFIG_RISCV_USER_CFI */
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 72d35adc6e0e..a137d3483646 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -156,6 +156,14 @@ void start_thread(struct pt_regs *regs, unsigned long pc,
 	regs->epc = pc;
 	regs->sp = sp;
 
+	/*
+	 * clear shadow stack state on exec.
+	 * libc will set it later via prctl.
+	 */
+	set_shstk_status(current, false);
+	set_shstk_base(current, 0, 0);
+	set_active_shstk(current, 0);
+
 #ifdef CONFIG_64BIT
 	regs->status &= ~SR_UXL;
 
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 872e0c52e034..0b77b812e4d7 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -24,6 +24,16 @@ bool is_shstk_enabled(struct task_struct *task)
 	return task->thread_info.user_cfi_state.ubcfi_en;
 }
 
+bool is_shstk_allocated(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.shdw_stk_base;
+}
+
+bool is_shstk_locked(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.ubcfi_locked;
+}
+
 void set_shstk_base(struct task_struct *task, unsigned long shstk_addr, unsigned long size)
 {
 	task->thread_info.user_cfi_state.shdw_stk_base = shstk_addr;
@@ -42,6 +52,26 @@ void set_active_shstk(struct task_struct *task, unsigned long shstk_addr)
 	task->thread_info.user_cfi_state.user_shdw_stk = shstk_addr;
 }
 
+void set_shstk_status(struct task_struct *task, bool enable)
+{
+	if (!cpu_supports_shadow_stack())
+		return;
+
+	task->thread_info.user_cfi_state.ubcfi_en = enable ? 1 : 0;
+
+	if (enable)
+		task->thread.envcfg |= ENVCFG_SSE;
+	else
+		task->thread.envcfg &= ~ENVCFG_SSE;
+
+	csr_write(CSR_ENVCFG, task->thread.envcfg);
+}
+
+void set_shstk_lock(struct task_struct *task)
+{
+	task->thread_info.user_cfi_state.ubcfi_locked = 1;
+}
+
 /*
  * If size is 0, then to be compatible with regular stack we want it to be as big as
  * regular stack. Else PAGE_ALIGN it and return back
@@ -260,3 +290,83 @@ void shstk_release(struct task_struct *tsk)
 	vm_munmap(base, size);
 	set_shstk_base(tsk, 0, 0);
 }
+
+int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *status)
+{
+	unsigned long bcfi_status = 0;
+
+	if (!cpu_supports_shadow_stack())
+		return -EINVAL;
+
+	/* this means shadow stack is enabled on the task */
+	bcfi_status |= (is_shstk_enabled(t) ? PR_SHADOW_STACK_ENABLE : 0);
+
+	return copy_to_user(status, &bcfi_status, sizeof(bcfi_status)) ? -EFAULT : 0;
+}
+
+int arch_set_shadow_stack_status(struct task_struct *t, unsigned long status)
+{
+	unsigned long size = 0, addr = 0;
+	bool enable_shstk = false;
+
+	if (!cpu_supports_shadow_stack())
+		return -EINVAL;
+
+	/* Reject unknown flags */
+	if (status & ~PR_SHADOW_STACK_SUPPORTED_STATUS_MASK)
+		return -EINVAL;
+
+	/* bcfi status is locked and further can't be modified by user */
+	if (is_shstk_locked(t))
+		return -EINVAL;
+
+	enable_shstk = status & PR_SHADOW_STACK_ENABLE;
+	/* Request is to enable shadow stack and shadow stack is not enabled already */
+	if (enable_shstk && !is_shstk_enabled(t)) {
+		/* shadow stack was allocated and enable request again
+		 * no need to support such usecase and return EINVAL.
+		 */
+		if (is_shstk_allocated(t))
+			return -EINVAL;
+
+		size = calc_shstk_size(0);
+		addr = allocate_shadow_stack(0, size, 0, false);
+		if (IS_ERR_VALUE(addr))
+			return -ENOMEM;
+		set_shstk_base(t, addr, size);
+		set_active_shstk(t, addr + size);
+	}
+
+	/*
+	 * If a request to disable shadow stack happens, let's go ahead and release it
+	 * Although, if CLONE_VFORKed child did this, then in that case we will end up
+	 * not releasing the shadow stack (because it might be needed in parent). Although
+	 * we will disable it for VFORKed child. And if VFORKed child tries to enable again
+	 * then in that case, it'll get entirely new shadow stack because following condition
+	 * are true
+	 *  - shadow stack was not enabled for vforked child
+	 *  - shadow stack base was anyways pointing to 0
+	 * This shouldn't be a big issue because we want parent to have availability of shadow
+	 * stack whenever VFORKed child releases resources via exit or exec but at the same
+	 * time we want VFORKed child to break away and establish new shadow stack if it desires
+	 *
+	 */
+	if (!enable_shstk)
+		shstk_release(t);
+
+	set_shstk_status(t, enable_shstk);
+	return 0;
+}
+
+int arch_lock_shadow_stack_status(struct task_struct *task,
+				  unsigned long arg)
+{
+	/* If shtstk not supported or not enabled on task, nothing to lock here */
+	if (!cpu_supports_shadow_stack() ||
+	    !is_shstk_enabled(task) || arg != 0)
+		return -EINVAL;
+
+	set_shstk_lock(task);
+
+	return 0;
+}

-- 
2.45.0


