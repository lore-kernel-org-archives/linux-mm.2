Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD63FD2A522
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4B6E6B00CB; Thu,  4 Dec 2025 15:04:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24376B00CC; Thu,  4 Dec 2025 15:04:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C4566B00CD; Thu,  4 Dec 2025 15:04:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 799416B00CB
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A4C0B802A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:24 +0000 (UTC)
X-FDA: 84182865648.30.D1673A1
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2CEA1100013
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=ISPIt8f+;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf05.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878662; a=rsa-sha256;
	cv=none;
	b=gQopWw7Bp9+crYtjXX4gSd1wfQ7vfULvt+XWUwXQ0gMLWw4FP1r6KiQbndRM4e1nEGAIEf
	QOnraYf+f2mEFarAk2IIFy1oethB9uxDeytqJp8J2HLr+YHp6qYfNIVvgcoS9atVCblYsc
	7/+k9lR6qYfY/gsoTeMdgL7zoWDYzUg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=ISPIt8f+;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf05.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uOhhdkkT/GBGrrgN/a4ytoXXLlwvK7c2y4J1FUwAKxk=;
	b=TViMEphKCbUJFthwHF0RdF36AiaGGQzXB3yz+ZDK7ZE9cMBg7GmUF9SK4NZ2CMGHBWsGKz
	E752My4EH17nqNrqQKwxEZlywbS9FFoIK0fMLQ7DILFpm7NoIgaVvIhgPq5n/VMeQW/WZf
	ngE++jW4/jo+XlXT9npaS0vcssm+3Kg=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-bc8ceb76c04so879020a12.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878661; x=1765483461; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uOhhdkkT/GBGrrgN/a4ytoXXLlwvK7c2y4J1FUwAKxk=;
        b=ISPIt8f++hxVVDM4pWylHqPBOejZi9Y4kJMM6YGsX1geTF4Ult04pmzRN//F5gLP26
         MU69WUM/cE6HUJMhE0nHKauRuT1aKBGimjThaanPQ9IU+7qbMY4SpaNVhvhnqFN9WJz0
         0fw/oKdF8vGLqxRMKG1qFATzLR/y5Vk5Whwadrdj5Q0Vm/0Wz9clu+Cn+Yn5QbBglUWi
         F0itIAPRlSyed5+CqQx4jhdQ5UHGY1hsDk+Sub+wMbXx+BTg3ZBFAlQXJGMwoeZrkJ3v
         GdGXmFUzvSDl5WwghTyOXddcyjRFzG3DmnvIdJhc7Cg7y59cLyN1kLGNGVqvKce0gH4Z
         DmDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878661; x=1765483461;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uOhhdkkT/GBGrrgN/a4ytoXXLlwvK7c2y4J1FUwAKxk=;
        b=e9tW9lCIU3r5ma8txze97XuZ2DZ3Heky7wOkKIcaCED2U8sp9BJiFIP/UwC7y2r35g
         kgyyUmhNePsrE+LOELDyOEZz3irknUP2gk2O/gxJNZfNiB4vHRFOaoFLFZz6ZyNsOK3W
         S4s9/xr1gDx3LRTeYuYNhyhph9Qiaq+95yIqCybRQrgDCRsvjcS07eDRIcS0H/FKnk19
         DXgguM4sg7dPIfQUD2K0hW1IzYVIR9UFA5yLP1i01VUIOz6TdSWJyDAJYtdSSfED0Mgj
         L7gRkp1XafPI0dQb3cNhLiSdJX4us8kfiJWJ64f9Phlk5GKEJUHyyc9YJzbmy+eyKD9/
         HGaw==
X-Forwarded-Encrypted: i=1; AJvYcCWK9kVmMUiYZsuebBeq/OvT+MfqnMhVt78YQB/0vBZIEhdJOnnof7sZTIQrw3xyhnQhYSdS3SIssw==@kvack.org
X-Gm-Message-State: AOJu0Yz+pKFKSZsETPK+FUzmE5uWYtNUS78v529KAKR7NDnZhr6YAqig
	iMK4X2GGt+sjt0D4UMGr78AsH9a1zDJjL7voA3C8iXZmOPJQKkp4DoqAKFKEn/lILf8=
X-Gm-Gg: ASbGnct7oA3BUsPrfg+74ooVbihNM+1uwiaBuf42ocZ074ReXJeFcoHMAQbLiW19K+2
	h+DQmhhG2BVMP312me35Ic2AjaYwp80Y1+kOS6copwwK/7/unmOwzQ+AHQTr8cidIx7Ch322NQ2
	RJ/1ZpKJZ3zzKUIuPeAF35rYIVa/GOArmQFxMcF7rJzX4tXhrBdWYyE39UaQkQp25rNVCY2Rrf2
	/V1slC7rH2T4pQ+rvJ++15VWnkn5ySR34jTMFnSje0S/MIIDXAKCgQVNPzmCrbf5PO+bN4gNDlq
	HR2YTTmQGaHEgDXbnykV/2R6b1cVW1ln5Rs+4PmPh45xvURFqVXPOsUqKlhnZ57U1ttoY1ROEw0
	5t02TS2FzPiP6i2prg6Z9UT48TJyg5DomG+d8+jVqUgHI2u9Zm6Nrz7cPEuoFoEzdac4twZsGgU
	xd+lYIXoMY5kfPn3aCFgpp
X-Google-Smtp-Source: AGHT+IFxSnvrtPb82qr5ib9bhwoJeOWjfygKUVwtQcSWlWfThazTDvOAZi4V19JSYtkXRbZuKDL0dg==
X-Received: by 2002:a05:7022:e98d:b0:11b:9386:8269 with SMTP id a92af1059eb24-11df0c5d953mr5864046c88.46.1764878660761;
        Thu, 04 Dec 2025 12:04:20 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:20 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:00 -0800
Subject: [PATCH v24 11/28] riscv/shstk: If needed allocate a new shadow
 stack on clone
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-11-ada7a3ba14dc@rivosinc.com>
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
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878635; l=9079;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=HCf+HC8ynJCm12KcC9WUCCl/+mvqE6Cq5HvlkCpoEk4=;
 b=oNqNrld7PCyKV0kf0AiQIXT8GyyUpjtqKmMQM8FepAwK22KmfTxGXN9h7dNrdov4PYBUwacJr
 pMVqhaeJkZ8AGDbc9FEiX5JFI4rfLmi1Cr+HOk6GLN4tDDwVW2a3xMt
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2CEA1100013
X-Stat-Signature: s1c1a8937675wny9eshkqmx3wp7ffetp
X-Rspam-User: 
X-HE-Tag: 1764878661-566904
X-HE-Meta: U2FsdGVkX18fJ4PHtayxKvSJ6OF8wb7nBxfLykN2UNo+cDGPYWwkwyElZWKM9zciW7xQfKXYeEpMN+JqLmr5wU6AK8cC8I+3h47hwVKdfqjhHEMltPEyvgjIUKtlfKSr6ns2B6rPevjx+Git3jIoe5QfvQ9yBQedk3Snd1DbvYBJORURvn1qamCtsge5N9FoUQ5bBWRq4ydwkKL6fvDnmXklYHsJqj3KnPnY3KxXcvBG1mPFStssyXGkZMpiXu9yMLL1dXaLGv/jDz8mh9G83hEoFMrNQk0fY7bHF/1Ccm3JOghBukOdNK33hvliZrD1PxxBVMYmWtnhvr4ujDfVJ8RFdVwPwGzZfjBzisTKFgkFQPSIYJHSTvmisV4OnjpROGwP6o4Cc3rF5JwCp02cMdQERL6cZtTAbw3NTSsNZkZmF6FEJ9aQ4iHjdTO1iF+ekgoKH7m/QTdzMFwdGvCbMrb7nJjiPWUv4VnIB/ff94LYJw9cG+ebsJWN+Bi00m1G7nzeOHzFvL3P0hwbODmNEfPqT5VmRHjqLCe4QejgqbQm/Sh5A2vj1blUUKe1qEjpH5rupw4DdNENRC14LIVdCuFLiTjFMNMXNRnkIYeUpc4o8MKewUWyfK0ahTPd/+w74FXpXXoHwUvFybn58bdG03/nTQIzE4UwrzHJR5GAWla9Km9CJohtRJXFYfzmq5d6R9vrsRI/l08eT5aeFNpgGCCNm/Hbw25ngw0ZknD9fLsqXAomCM2kcJl45oUwrkIE41QR5qQAzgHE2w9th24OSJgCHyAonz8zJ5SPUdjsX8/Bys0eoGvamWMqTWczt5LGqwMQDZoZarfMDOZ/Z9tCrt/izoYF3D+wTy4p/hsDbkF69GkirIBHjO6VnaBTolW/Ll2YQZ/RwFqt4M10xml6EzpDXzBLz/3QP7BMcCBeGaP8LUfCWI8I6+KizZHh02OnDYblciWzDP5KeGMGHf6
 lALrp4EH
 GKgs7DYUk+MTQjlYVreRGlMB4Cl6eSflyCKq+CjDf30yWy5x9sHgFfsfIE4Kb2rXIcEVcOPwynSeyojJpgTw7MeN+Jioo8f2uN0+mxCRJ4/3CYFC9ocsABHyIgFaMbPHuAx8YdA4cPNRGNG8v8s6l63mn9WJJ7VHtZpYGYzUVJTPH0QwmAnTdS+CQmOSyguDOrxO+NTOlPBDgeUlxxElN0YVPSaokprAjOwir/3Ul/tjUEC0+N6vIq2rJTWtYUaCHGK5SC2Z3iFPHk4Pe1dI10CIZtGjlfEitNWRgRnXZDZlhzEIwmmlGNK8buylbUfKhRYUwF1+h3bW0ASutTJNMxBkO3ovqICEYLeylP2FpPv2Gs11hoI4fXmGsz5qpPJOfrS/TQ3IExtA3GmmR131MPZhkVj6WNp2xdZvsj4w/6mX63zKG+PNMNI20N+rnobUgylFCekfprLCJ0XZbw2zIAn2oy5BpaUJ0q0ZZ+qQi7v8rLSXMyEy6JXF3t2FaOHk5gqQRwkzR9f1DKTZFhpt3ufXSmDaMrlV9gdp5
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


