Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C56A9D339B4
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472536B0249; Fri,  5 Dec 2025 13:37:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44A476B024B; Fri,  5 Dec 2025 13:37:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29CA66B024C; Fri,  5 Dec 2025 13:37:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0EBEC6B0249
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C608D12C6E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:05 +0000 (UTC)
X-FDA: 84186274410.07.AD50022
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	by imf24.hostedemail.com (Postfix) with ESMTP id BAC7518000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=KAz16BpC;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.194 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959823; a=rsa-sha256;
	cv=none;
	b=BTSXGpfFEEdgweTkWGTIsvDn0PvPxaKO0iahH6R4b8h9fHHmbDQoS6OYdSQWoNexIj0IR0
	2U4QAQIjzUMzGvlL29ZgBF9a7248L9QixK5oiBGjrQcA963uoq1QBbH2HdunfXQBQSMeYL
	p1GU3DcLMhetCzNCJ23y/gb3KVkhr38=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=KAz16BpC;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.194 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qa06X7BN7aAxeMRj1RtrRZw6MLM+PhxlK6i/AnJxckg=;
	b=4TVlLCwJJKP2V48gaztGTsPi4+oxBut893geWiJLVWgZNrCZQGL9sAZNTR5anuX77kSpo7
	egQJ7eztbxJ50M/DAqZbksZ9CMB+nCehHvjGaartzA7q0wDLpd/U2LJ5RNxnifJLkPhTFq
	fFTX9vW5BhaDPtyzFCnyy3bMzQ/Cil4=
Received: by mail-pg1-f194.google.com with SMTP id 41be03b00d2f7-bc0d7255434so1367376a12.0
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959822; x=1765564622; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qa06X7BN7aAxeMRj1RtrRZw6MLM+PhxlK6i/AnJxckg=;
        b=KAz16BpCtjuzT3O2eEEErsWcaLQrrrTr4J+DKxVhmh2JQerxqdJtFm4SDonnsjIQq4
         cAuMJqt5lrE6Poxe+tx/WImQW9M4mMXURals05aFTgxnx+agh/r66ai87kUXszZhOGhI
         /iziu8W86p/sr9JWa/y4WKvwBHWTLk3JsHCs37S4Wz0/EHSYTUyyGA9suBzJ56BCjqUl
         vArNS0xNuu70H4lm9o0CxCe9z0/bEa0T9+fBG7cJ9IP3byuc66OUF/vObNXwhHUBAB5P
         coETPtUTV4dO3BO20eaBN+92bDo0yf7mrWk0DJlCcNC3YSKCb3kDm/o3FyzlRdgvobuZ
         l5Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959822; x=1765564622;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Qa06X7BN7aAxeMRj1RtrRZw6MLM+PhxlK6i/AnJxckg=;
        b=Ms9OeMXIt0YXB5wc/BcXkurwmd59xRkpOK4o76Kp3F/5hj9/mUvRUTQ44QlI5GAXo5
         4hT2DYJxDMF8+YbsyadUkWgfVadZo56AUKDiGfqOrtg4DO0fiYbdISwt/3QNUbnNBtYb
         dqEtBKl9E3ckE/YYVER7obRHyvfhwq0csfv/QAG+srKWXWZw1EjsUfpQtqENyNcLmx2i
         MI3Rk7aeMwI8dn6ohXFnuug6kwpnhkXgD158+KLFvO3IENyNayAsTXAS/9Lzuae+Ta9D
         Yu/O9J9L4lpx4KcKkYB3RzA9MVmm9/5ttaoD6WwgCy2rFcWe+EjrHMyu3nT1vJvVbx5U
         7e8g==
X-Forwarded-Encrypted: i=1; AJvYcCVoOUfiu5VN8hRVriXL0Xb1DPEhvX5JxqB4yDhNd7Zp1AgBZgLHH/b6LHHXddEKjSIDsF/X1m8PIA==@kvack.org
X-Gm-Message-State: AOJu0YycZ4hRJm26hRhYXtKbAyPrBCIWJxnElDrI10kdPtEGPReK19dO
	dE+QioMuTyKZVbEhu/RLE/hKlf5zfWk1OTU9kPaEZvcdfXtcNc0GdGg+fRztsVUBVAc=
X-Gm-Gg: ASbGnctkWQ2sHS/sCT52ShwigtmqE+GqTX5CW/FXmHl5SvaZuNAIsjXbVMaEyBkfPY1
	NqpbNBFeX+0RKUO2rGWXCyxXo0yMqeAUMIYq9QitN30tWu7e+7xe/k9MtMzt1/4Oy+T0tgPipj8
	lyBp8BmRr8DM8BMqfVDdUUI+f1JsFaIY5grubWST7WBwTjcbyLVoXNgImkhw7Pjoaz7pSrdoBVt
	ntKRIIY6PdTj9bI+1qfHlEk9qz5QjKkNshr6DI2Tbfei6FUgsAXOftmCXtDc54iML1D3BmaMV3J
	/tTy+pIz9oAquprGtuSmOJikLDbpUs0NCU7RwXHh0i41Yxkt54sL5rplJBoTUWCX4QyrsZccwIj
	Ln0lKQPYEnK7rPwByvlds1nJqTlmPzpqCrPFYHXw2aXWQkcsxljE+pTh1T54zdopdaYHSM0XnIl
	uLRHeawYojUTiNBSJ3InT74Lj5DR5w96o=
X-Google-Smtp-Source: AGHT+IFSuIato7By2LD1j5BN0WlXvTN4dkTg3+zsfi//usJ4CscSRgzvoiXp1vgnstjZYR4syaJugA==
X-Received: by 2002:a05:7300:3084:b0:2ab:c151:3534 with SMTP id 5a478bee46e88-2abc71139a9mr127815eec.5.1764959822438;
        Fri, 05 Dec 2025 10:37:02 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:01 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:36:52 -0800
Subject: [PATCH v25 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ |
 VM_WRITE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-6-8a3570c3e145@rivosinc.com>
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
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=4345;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=7yLe9hWq2WlkWVyw5cBB8KO8waygymuFRUw/WyJutrk=;
 b=brRg4Sn8vtoSLKpcwx4+loNsIV5h3ZB1DTXP5anyC0qWKOWE2LiMPjioo+IiPxRaUxf/54FOC
 aXStfisB/ojBRwd6CwGucPTtiKuZH9f6XIZV3TLOlrJBIxk+6atHMhk
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BAC7518000D
X-Stat-Signature: 1c8jh99pmckt883opfxpe1otguxbxwtj
X-Rspam-User: 
X-HE-Tag: 1764959823-383813
X-HE-Meta: U2FsdGVkX19qWRXKBzGAtkEsaIOgodOWJSexVYuYkBhL6ndPhRwSh6V4nZ5SvRNGRUYaqZp2d+UOW/qn9KeVTiPySRmoLU2DfAAcZ/JsJFWLDFWf05Wig07OAVA1XowWYBI8B8zstGrTgwRP9pDaJvTU1NBQViKcjyIIX99izmJiE4RBmolzhrp7tViRDjx0MQtQqGiaSbOXAkahCmlESiqOEWjTdh9ogtlETvsncMFOZ+LpbepjN6bN4D/LlbaAGiBpILCdxpJ9lzon5qgH/ssYRXVcYNJGYmpGVF+L1RaRfIVzIV+sQDmkWJBd7UDRO1kNelqIQLb61lVPHHDDIp02s5Hl5i5oKYB5fZJhhH8TPp9eiNt8UsObnGkcQCHaVaezn5Go973RXxbaG3VGl/ld+zP6dL2bsU3qJ0PqY/kxiCWoWNlZr3KCbEky+NLtu87dwfCTkVG/5b2HULfPq3UkI3WH9Ua7WtAB2U/MDXkf7mbb231GnupBxJOylsihvQrAVAvwf5UYzLIFDDx8rSgDfkmQOTIpCctJQ67N70I67E0FQNEoRP2TYV2zh4ONyLevjHuq6S/K8NptEKxh2LCEiceelwT5AQtWARLO9YSKxGBjKxrbU2l4aufb4/Kp80y5d72pkgYZFMPIUnqwbhnuHSFsyJwHXGAIi9LjSIPEJFBmmQWuWawvQd7V7sWE0vruYkSNpIBdmT5HCNKHrWjuqs6cZdIt+XyeZMZkbIGDF8D6qM2lEzMtSwK1oOH9n7lozPmIuVZ+1FY/5sk6/JGWKqW4+HW3VEsZP+XLlTUks3DfQ6dyGqKTHSMzsz2dtmOvJcrRIaFD+FyfgEghTcCMaFE4ltt326ge3DneClXCN9KaAhO3UgSCn6EtQdfpJevwc3alguJ1ddAVjQ0wV4AWiIxqP9YKfQ+DyBP9dt+RCVZWdHdnm96ShIaGKbGrC1Wcbsl1BDMLqDYLSJt
 lkYM0uNx
 xWgJMo9mv11Ul9Mc+aXDHb2AhrXvWgOHc7FUPQ7yQ5dtrDhUTvT/x5tjH/oublXt3MteQMpPvXlpnlM/jqUtnpYPPt1eYQAReQdC8h5G1JTNXRHD7dPTkwnCU2Waj+/tODtzpeDgpkcswcg5y164ntPQaBjF+HFvd0KC5imvWzmly//hfqBribkqiDnz4IFxFEbJfHNgZja5TLpdqXQZuMGLEa3bvV//QMjvXfYf5ndd5DL3KEWpq5W5zCQtBxnkmusx9OlB4+6n/v7xnWa4Nry4NtXQttdrHWAKIEeijNoZlgePQ9FL8/LsK2SOdl003QFO/39ePYd4bd57qE0cbVBdl2RhdCCam+trCGgZIS2v5P6MVKnbTOug21YBy4F+Itzf3aReBaXrWqoU6xXedWN9zy04Kt6wIGg84ANreTSp1/ed436WVewOxph3W3IKSCoZTsFmysQnZ2oEOKYhW6cXF7zF1wLB6xFlCat2yrqK0NiYy1/xplcL+7PChMyxwGefwfnayPr0Bjce8VC0Nq+DLSZuyILzpW6le6mQKJeM/u7+xtFsNuf8lVaT32fatbNZ2Ef9r6urTBXA1IU1u5STJcroc4xH9mTooIFVKh2xjO7aokDdD3SYdTSEi5ggHvLM/+NXFFJqsb64U8ujmJNz5V6PDcYxyisoC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`arch_calc_vm_prot_bits` is implemented on risc-v to return VM_READ |
VM_WRITE if PROT_WRITE is specified. Similarly `riscv_sys_mmap` is
updated to convert all incoming PROT_WRITE to (PROT_WRITE | PROT_READ).
This is to make sure that any existing apps using PROT_WRITE still work.

Earlier `protection_map[VM_WRITE]` used to pick read-write PTE encodings.
Now `protection_map[VM_WRITE]` will always pick PAGE_SHADOWSTACK PTE
encodings for shadow stack. Above changes ensure that existing apps
continue to work because underneath kernel will be picking
`protection_map[VM_WRITE|VM_READ]` PTE encodings.

Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/mman.h    | 26 ++++++++++++++++++++++++++
 arch/riscv/include/asm/pgtable.h |  1 +
 arch/riscv/kernel/sys_riscv.c    | 10 ++++++++++
 arch/riscv/mm/init.c             |  2 +-
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/mman.h b/arch/riscv/include/asm/mman.h
new file mode 100644
index 000000000000..0ad1d19832eb
--- /dev/null
+++ b/arch/riscv/include/asm/mman.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_MMAN_H__
+#define __ASM_MMAN_H__
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <uapi/asm/mman.h>
+
+static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot,
+						   unsigned long pkey __always_unused)
+{
+	unsigned long ret = 0;
+
+	/*
+	 * If PROT_WRITE was specified, force it to VM_READ | VM_WRITE.
+	 * Only VM_WRITE means shadow stack.
+	 */
+	if (prot & PROT_WRITE)
+		ret = (VM_READ | VM_WRITE);
+	return ret;
+}
+
+#define arch_calc_vm_prot_bits(prot, pkey) arch_calc_vm_prot_bits(prot, pkey)
+
+#endif /* ! __ASM_MMAN_H__ */
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 29e994a9afb6..4c4057a2550e 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -182,6 +182,7 @@ extern struct pt_alloc_ops pt_ops __meminitdata;
 #define PAGE_READ_EXEC		__pgprot(_PAGE_BASE | _PAGE_READ | _PAGE_EXEC)
 #define PAGE_WRITE_EXEC		__pgprot(_PAGE_BASE | _PAGE_READ |	\
 					 _PAGE_EXEC | _PAGE_WRITE)
+#define PAGE_SHADOWSTACK       __pgprot(_PAGE_BASE | _PAGE_WRITE)
 
 #define PAGE_COPY		PAGE_READ
 #define PAGE_COPY_EXEC		PAGE_READ_EXEC
diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
index 795b2e815ac9..22fc9b3268be 100644
--- a/arch/riscv/kernel/sys_riscv.c
+++ b/arch/riscv/kernel/sys_riscv.c
@@ -7,6 +7,7 @@
 
 #include <linux/syscalls.h>
 #include <asm/cacheflush.h>
+#include <asm-generic/mman-common.h>
 
 static long riscv_sys_mmap(unsigned long addr, unsigned long len,
 			   unsigned long prot, unsigned long flags,
@@ -16,6 +17,15 @@ static long riscv_sys_mmap(unsigned long addr, unsigned long len,
 	if (unlikely(offset & (~PAGE_MASK >> page_shift_offset)))
 		return -EINVAL;
 
+	/*
+	 * If PROT_WRITE is specified then extend that to PROT_READ
+	 * protection_map[VM_WRITE] is now going to select shadow stack encodings.
+	 * So specifying PROT_WRITE actually should select protection_map [VM_WRITE | VM_READ]
+	 * If user wants to create shadow stack then they should use `map_shadow_stack` syscall.
+	 */
+	if (unlikely((prot & PROT_WRITE) && !(prot & PROT_READ)))
+		prot |= PROT_READ;
+
 	return ksys_mmap_pgoff(addr, len, prot, flags, fd,
 			       offset >> (PAGE_SHIFT - page_shift_offset));
 }
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index d85efe74a4b6..62ab2c7de7c8 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -376,7 +376,7 @@ pgd_t early_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
 static const pgprot_t protection_map[16] = {
 	[VM_NONE]					= PAGE_NONE,
 	[VM_READ]					= PAGE_READ,
-	[VM_WRITE]					= PAGE_COPY,
+	[VM_WRITE]					= PAGE_SHADOWSTACK,
 	[VM_WRITE | VM_READ]				= PAGE_COPY,
 	[VM_EXEC]					= PAGE_EXEC,
 	[VM_EXEC | VM_READ]				= PAGE_READ_EXEC,

-- 
2.45.0


