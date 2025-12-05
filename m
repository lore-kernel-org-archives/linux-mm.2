Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF88ED339B2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054C86B0253; Fri,  5 Dec 2025 13:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C4F6B0255; Fri,  5 Dec 2025 13:37:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0EC96B0256; Fri,  5 Dec 2025 13:37:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9E286B0253
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9411812D54
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:15 +0000 (UTC)
X-FDA: 84186274830.20.9029B93
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 849C320006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=P+cjsqLw;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959833; a=rsa-sha256;
	cv=none;
	b=Q1hRm+SilLpy4XN1Yorgaxd7Drv9oavYw1/1tgo3+IUT31CDcejTxvRZ30OCU+SzYb/ila
	Wzk/+NVs4JVjE38MQfbVXBZBKgr97vywpXcZeAYNKMq949061KJV23gpogLYh71O80hAwr
	KSYZg7dL8nJhDoikkSSsCkJrGK+aEXE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=P+cjsqLw;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uOhhdkkT/GBGrrgN/a4ytoXXLlwvK7c2y4J1FUwAKxk=;
	b=peSLO4Q3YhCEa351KWWVmhMYykuT2rGudaZpaS3C/iQXzc/kQtprscqim0o3bPXx/zG18Z
	58anaPAStpNIv/Mzn7TuUrPGwQ7m2JqCzfARqEyauhlU+Qagth8cnNa599cow+oTUBB/7c
	e40oG84fDlhu2wOrTUgExKvRIG8p2+E=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2a45877bd5eso4567816eec.0
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959832; x=1765564632; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uOhhdkkT/GBGrrgN/a4ytoXXLlwvK7c2y4J1FUwAKxk=;
        b=P+cjsqLwMiFttIdDzufofT4yW7Tdr9M3sP5Ad9ftwk3nuWmHrrpGy21clLimblDigH
         +PKAHw/e8IbLg51AtK3JIjv23aDOpNVni2SkgYkoHLU5YUOsjHKemC3VKFrNhkdwE07q
         D7Hm1HoBMBYEdOMWAzfMttdMnvgfZA4m8p/apkeYp6717dPfOqFqxf2sCdZKF+0hjGKF
         JTryOVCVoI+iZ5AxbJK9u36kE7cMPz5jA+VnURepC6StcLen8Api+7zm/SFaQuWpbWz7
         6lxXJTMJLHgktmM3RkqFSZktqan6H3k2qi5lFzstQXUIV8MX57syGOFr3ai7IkBNW1ph
         Vt8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959832; x=1765564632;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uOhhdkkT/GBGrrgN/a4ytoXXLlwvK7c2y4J1FUwAKxk=;
        b=Ou4YQZSWKmLD3009UUdiDV1Z31Iy95ox3hl4GsnHMhkA1sw2gurdEgk7gJwb5OgP61
         V3eD/svOWLbOTuNJHx2MPY+dD6wzEccNo01Yo5GWw03SR7GnlEI+5ePE55Pc1cQlIStE
         Cejme9HVJyaMQzM27A4zXfnrhIxIH7OeHQmO3rYaTfPeclv0okN/rHIJicezQjfEeO1Q
         bRcdxoforg0GTayXw9k6SvH5ULDcXVc3BBx5AGGcwbEyBiNgk1Rt983RoYmoRNkURFil
         1Og6MNkMvDF8smR1MNGEPQHXCfnqrEzYc8D/7mm8BIWeSvbxtty1c4RZABDIY6Na6IaE
         6gCw==
X-Forwarded-Encrypted: i=1; AJvYcCWna41nhjrNAIPQlo0z4H/SqLD5W8g8obW5VCvlj43vwARPiL0m8gKgNUF1rTEqI10lhAYNbIgWYA==@kvack.org
X-Gm-Message-State: AOJu0Yz6Vz0PstBeelFGzk1Zl+mAidY6M1H1tnk8lDz1OaWPBc+dpd8H
	IqxEu/wEcFIIAW8OtmKNlJOwcEoGVwDTLUWkf33C9JjU3jfBuubjGBB44dkYfkUKicg=
X-Gm-Gg: ASbGncvmQr9iPbIHkWZ3wpI6i61sCDEn6mu4nU5GBH/ZAdWnFNB7xQAW/WbJkzYB7/8
	n2OYL7zt7qikCXIpSDuz0OgtYtBj5oEGbhtWsgXSAOOoVlMDqw8DDcSgiwJSWPjXfzsSVYV8YZA
	iOH34JDoIeW3J/SRdHLcEK1UCPtAw8SY9HwCwAjqDcacnen9RuB1/JSzf8Ov0TyatvmJcetDFry
	wvZHiUIey22j44AwEO0Vak7eC9KPV6J9kaHx3Ukai3MWuH38rxtbkWvxetf5vSfRKZPx2vkt1Wn
	H/f3M0pvPSOdwAnuRCqsZO/TFxrRBeyAp0FG2tBmR5z0EAGihFIRqBWCR/u39TFlmF2E1bfyr8/
	O8khH+Hht0GQcSaubqWVc2FjQGdTwWCCnmIuJyjXP/0W66ZCw5Tk8tRdiQWBGLwh7JUrs2GwusT
	qYVhoL/8tZrtbqvgeV99uX
X-Google-Smtp-Source: AGHT+IHfPJoQspWLM8P1tntFJ5N6afj2MUQjC0mHBWKRPF4XAtzpunstEh/0lsp5M70ve6j1zhL7kg==
X-Received: by 2002:a05:7300:c618:b0:2a9:9125:ac0c with SMTP id 5a478bee46e88-2aba348736dmr6314012eec.9.1764959832074;
        Fri, 05 Dec 2025 10:37:12 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:11 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:36:57 -0800
Subject: [PATCH v25 11/28] riscv/shstk: If needed allocate a new shadow
 stack on clone
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-11-8a3570c3e145@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
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
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=9079;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=HCf+HC8ynJCm12KcC9WUCCl/+mvqE6Cq5HvlkCpoEk4=;
 b=wVQbLp+S0AdfG0FqS/T0rg2ZfQt1BlHH2TqdaQGzcB3zI5j1TGMBr4+PSPhnoktWGUb5aQZYT
 AiIWXh9gcn/CZ8h5xp9QpmGAeIlY6/KxUlRY8jGEhKpWIng6KNl2iZI
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Queue-Id: 849C320006
X-Stat-Signature: hrh1xwdwric4zotbm9yx6cn3qd1roa9q
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1764959833-820317
X-HE-Meta: U2FsdGVkX18yLsRtAN+WaEKGf/VTv4H1qYRqTwk7h+DNA8q/JmsoLJBVxWbRfQyYMigLrOj6zumj6TNIyCtC36eUD98L0ONs7Z45X7oDmUZ+81i419HXPEJustlRIqzdcedRVnZE3W92pv50VahugqfZchZsZ+YyiBEO/0ojd76sIR5GLDWFypLKheTmc+QIsh+pgkKm40XytmjL5Gw/m1XEeFQ0a1LIul8fltyZwpjkrinB0pWd8mfnL/oYCj2tQTyKSuhXtzRIGRTVAuRaJgV2B3nwMzaT7ShCa2PFLJuZNNZojnD32Uv4ywrj4V9m8uvlPfJ1oYPT8vsHrt1+Gexe/Naw1T1oVYfMjQVPnCuwhghe8eqNdmwDoleNJS3XfHToeeCl0oWU87CxYHZ1CHAIxBdhl4ZWlFXM3TdLCZ2LtvBaXaCnLwxjghazF65LIF4XL5C6cUHw3O9ai6bYKoEhkbC3UE0d2gCS1RQXPJCNe/TeRwLGLwEug8MP8ktUxtV9P2x+ZWn4ApMSUPDyUSdDQCiT9P32v0og16wraKoArR6bPhZywypUENRuvrlKQADULmLZiuacOIX3F7k+OvjE4vLfV/U3LkLeKdiqLOQG4tYhe2wHHN2bXJb02K2CqXpNV/NxigsbjkMN4jkPEvANKL2XSUMKyhbZauD0OswTLsIewj28ijSNqV+XH1KaJSYIims4SqoYWNeFg6ozrKbdr36DzQFs/pySNiWvE8cOP//S+i7ShuztlCwu9aHZc4eSVaoDKpgZ1qM8fA1GY3MJQFGsQMjXREzN7HWsc+P09arVFS1K6LDhb33uzHBzc7d6a9wh1DuYjfjnt87vG+CVqcBjGSBdRxVRJaA49inUEWyIC4eo3GcU3ArxCynaW/TvWKJBpp7OoAZtTcmkOXLtO1b0NTHFbaNgMBVHexEzbhcmoiEHDHMTeVjUGJhTHrXiT+ZcGF5JhmqkcGg
 M9aifl+H
 JSLeNn9CCD4Mv38NTgChY3gpeKJF9lfnC/+eB2uXFyAKb6eNjkI6jM9Pu/4O7cjc+WXo/AIjT2KT5gknAE8U2ZUYhd/DhG/wRLVEDh3Qp7vQQOREMB4JSMnx5ajEDtelF2XZqxvJHNGG0Eq/KuuI6TAUCytmkKcC5fYZt3aFiJHH00qT1Xyq1g/oGYXbFkiFgOgkxv5SrLN+OxIXYrsIvAdKEbD7LeyTXLJWpVE+De8DXZbCJ2IzMHt/U8PkGw54vLLOxK6ILJOOXCCY0tZTeO10GGgmlF4LdagGo+y9QzBTUfmVK5qfmaHn1MV2G5KBCaAvT8Sp7VIeP2oshxz3Tv3J//sOz/t4aZV4mZe7AkdlF2/BJp1D0COu3uuHYka+KcvLR5/ztjI5tzpR6nEThUcdlYyf/gsIACXYVoQ05DZRgKI1O11vdEH9XV/GeVd/T9cGHcIDsuiX2LSpf078EOTxeTGM6RSfXDO8wG1FEp+2BoBuplgnWsYbxHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Userspace specifies CLONE_VM to share address space and spawn new thread.
`clone` allow userspace to specify a new stack for new thread. However
there is no way to specify new shadow stack base address without changing
API. This patch allocates a new shadow stack whenever CLONE_VM is given.

In case of CLONE_VFORK, parent is suspended until child finishes and thus
can child use parent shadow stack. In case of !CLONE_VM, COW kicks in
because entire address space is copied from parent to child.

`clone3` is extensible and can provide mechanisms using which shadow stack
as an input parameter can be provided. This is not settled yet and being
extensively discussed on mailing list. Once that's settled, this commit
will adapt to that.

Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/mmu_context.h |   7 ++
 arch/riscv/include/asm/usercfi.h     |  25 ++++++++
 arch/riscv/kernel/process.c          |  10 +++
 arch/riscv/kernel/usercfi.c          | 120 +++++++++++++++++++++++++++++++++++
 4 files changed, 162 insertions(+)

diff --git a/arch/riscv/include/asm/mmu_context.h b/arch/riscv/include/asm/mmu_context.h
index 8c4bc49a3a0f..dbf27a78df6c 100644
--- a/arch/riscv/include/asm/mmu_context.h
+++ b/arch/riscv/include/asm/mmu_context.h
@@ -48,6 +48,13 @@ static inline unsigned long mm_untag_mask(struct mm_struct *mm)
 }
 #endif
 
+#define deactivate_mm deactivate_mm
+static inline void deactivate_mm(struct task_struct *tsk,
+				 struct mm_struct *mm)
+{
+	shstk_release(tsk);
+}
+
 #include <asm-generic/mmu_context.h>
 
 #endif /* _ASM_RISCV_MMU_CONTEXT_H */
diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index 4c5233e8f3f9..a16a5dff8b0e 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -8,6 +8,9 @@
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
 
+struct task_struct;
+struct kernel_clone_args;
+
 #ifdef CONFIG_RISCV_USER_CFI
 struct cfi_state {
 	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
@@ -16,6 +19,28 @@ struct cfi_state {
 	unsigned long shdw_stk_size; /* size of shadow stack */
 };
 
+unsigned long shstk_alloc_thread_stack(struct task_struct *tsk,
+				       const struct kernel_clone_args *args);
+void shstk_release(struct task_struct *tsk);
+void set_shstk_base(struct task_struct *task, unsigned long shstk_addr, unsigned long size);
+unsigned long get_shstk_base(struct task_struct *task, unsigned long *size);
+void set_active_shstk(struct task_struct *task, unsigned long shstk_addr);
+bool is_shstk_enabled(struct task_struct *task);
+
+#else
+
+#define shstk_alloc_thread_stack(tsk, args) 0
+
+#define shstk_release(tsk)
+
+#define get_shstk_base(task, size) 0UL
+
+#define set_shstk_base(task, shstk_addr, size) do {} while (0)
+
+#define set_active_shstk(task, shstk_addr) do {} while (0)
+
+#define is_shstk_enabled(task) false
+
 #endif /* CONFIG_RISCV_USER_CFI */
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 31a392993cb4..72d35adc6e0e 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -31,6 +31,7 @@
 #include <asm/vector.h>
 #include <asm/cpufeature.h>
 #include <asm/exec.h>
+#include <asm/usercfi.h>
 
 #if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_STACKPROTECTOR_PER_TASK)
 #include <linux/stackprotector.h>
@@ -226,6 +227,7 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 	u64 clone_flags = args->flags;
 	unsigned long usp = args->stack;
 	unsigned long tls = args->tls;
+	unsigned long ssp = 0;
 	struct pt_regs *childregs = task_pt_regs(p);
 
 	/* Ensure all threads in this mm have the same pointer masking mode. */
@@ -245,11 +247,19 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 		p->thread.s[1] = (unsigned long)args->fn_arg;
 		p->thread.ra = (unsigned long)ret_from_fork_kernel_asm;
 	} else {
+		/* allocate new shadow stack if needed. In case of CLONE_VM we have to */
+		ssp = shstk_alloc_thread_stack(p, args);
+		if (IS_ERR_VALUE(ssp))
+			return PTR_ERR((void *)ssp);
+
 		*childregs = *(current_pt_regs());
 		/* Turn off status.VS */
 		riscv_v_vstate_off(childregs);
 		if (usp) /* User fork */
 			childregs->sp = usp;
+		/* if needed, set new ssp */
+		if (ssp)
+			set_active_shstk(p, ssp);
 		if (clone_flags & CLONE_SETTLS)
 			childregs->tp = tls;
 		childregs->a0 = 0; /* Return value of fork() */
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 251c3faccbf8..872e0c52e034 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -19,6 +19,41 @@
 
 #define SHSTK_ENTRY_SIZE sizeof(void *)
 
+bool is_shstk_enabled(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.ubcfi_en;
+}
+
+void set_shstk_base(struct task_struct *task, unsigned long shstk_addr, unsigned long size)
+{
+	task->thread_info.user_cfi_state.shdw_stk_base = shstk_addr;
+	task->thread_info.user_cfi_state.shdw_stk_size = size;
+}
+
+unsigned long get_shstk_base(struct task_struct *task, unsigned long *size)
+{
+	if (size)
+		*size = task->thread_info.user_cfi_state.shdw_stk_size;
+	return task->thread_info.user_cfi_state.shdw_stk_base;
+}
+
+void set_active_shstk(struct task_struct *task, unsigned long shstk_addr)
+{
+	task->thread_info.user_cfi_state.user_shdw_stk = shstk_addr;
+}
+
+/*
+ * If size is 0, then to be compatible with regular stack we want it to be as big as
+ * regular stack. Else PAGE_ALIGN it and return back
+ */
+static unsigned long calc_shstk_size(unsigned long size)
+{
+	if (size)
+		return PAGE_ALIGN(size);
+
+	return PAGE_ALIGN(min_t(unsigned long long, rlimit(RLIMIT_STACK), SZ_4G));
+}
+
 /*
  * Writes on shadow stack can either be `sspush` or `ssamoswap`. `sspush` can happen
  * implicitly on current shadow stack pointed to by CSR_SSP. `ssamoswap` takes pointer to
@@ -140,3 +175,88 @@ SYSCALL_DEFINE3(map_shadow_stack, unsigned long, addr, unsigned long, size, unsi
 
 	return allocate_shadow_stack(addr, aligned_size, size, set_tok);
 }
+
+/*
+ * This gets called during clone/clone3/fork. And is needed to allocate a shadow stack for
+ * cases where CLONE_VM is specified and thus a different stack is specified by user. We
+ * thus need a separate shadow stack too. How does separate shadow stack is specified by
+ * user is still being debated. Once that's settled, remove this part of the comment.
+ * This function simply returns 0 if shadow stack are not supported or if separate shadow
+ * stack allocation is not needed (like in case of !CLONE_VM)
+ */
+unsigned long shstk_alloc_thread_stack(struct task_struct *tsk,
+				       const struct kernel_clone_args *args)
+{
+	unsigned long addr, size;
+
+	/* If shadow stack is not supported, return 0 */
+	if (!cpu_supports_shadow_stack())
+		return 0;
+
+	/*
+	 * If shadow stack is not enabled on the new thread, skip any
+	 * switch to a new shadow stack.
+	 */
+	if (!is_shstk_enabled(tsk))
+		return 0;
+
+	/*
+	 * For CLONE_VFORK the child will share the parents shadow stack.
+	 * Set base = 0 and size = 0, this is special means to track this state
+	 * so the freeing logic run for child knows to leave it alone.
+	 */
+	if (args->flags & CLONE_VFORK) {
+		set_shstk_base(tsk, 0, 0);
+		return 0;
+	}
+
+	/*
+	 * For !CLONE_VM the child will use a copy of the parents shadow
+	 * stack.
+	 */
+	if (!(args->flags & CLONE_VM))
+		return 0;
+
+	/*
+	 * reaching here means, CLONE_VM was specified and thus a separate shadow
+	 * stack is needed for new cloned thread. Note: below allocation is happening
+	 * using current mm.
+	 */
+	size = calc_shstk_size(args->stack_size);
+	addr = allocate_shadow_stack(0, size, 0, false);
+	if (IS_ERR_VALUE(addr))
+		return addr;
+
+	set_shstk_base(tsk, addr, size);
+
+	return addr + size;
+}
+
+void shstk_release(struct task_struct *tsk)
+{
+	unsigned long base = 0, size = 0;
+	/* If shadow stack is not supported or not enabled, nothing to release */
+	if (!cpu_supports_shadow_stack() || !is_shstk_enabled(tsk))
+		return;
+
+	/*
+	 * When fork() with CLONE_VM fails, the child (tsk) already has a
+	 * shadow stack allocated, and exit_thread() calls this function to
+	 * free it.  In this case the parent (current) and the child share
+	 * the same mm struct. Move forward only when they're same.
+	 */
+	if (!tsk->mm || tsk->mm != current->mm)
+		return;
+
+	/*
+	 * We know shadow stack is enabled but if base is NULL, then
+	 * this task is not managing its own shadow stack (CLONE_VFORK). So
+	 * skip freeing it.
+	 */
+	base = get_shstk_base(tsk, &size);
+	if (!base)
+		return;
+
+	vm_munmap(base, size);
+	set_shstk_base(tsk, 0, 0);
+}

-- 
2.45.0


