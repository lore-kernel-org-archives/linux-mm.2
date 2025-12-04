Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D0FCD2A523
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A72816B00C7; Thu,  4 Dec 2025 15:04:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A229C6B00C8; Thu,  4 Dec 2025 15:04:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D3E6B00C9; Thu,  4 Dec 2025 15:04:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AB4F6B00C7
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:14 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36B7087B2E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:14 +0000 (UTC)
X-FDA: 84182865228.13.1CE652C
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 35B4120004
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=XC+6PdT0;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qa06X7BN7aAxeMRj1RtrRZw6MLM+PhxlK6i/AnJxckg=;
	b=ga4nIQu95CN8sPBzL5ZZYf9BrZgPRJWzPTrK+o+PXq3JnC8VTd0LDZCtd00O/H/qtZDH9c
	0m3wCxy2ZbaO0xhSSX/Q5e+L946VmjE6imMl4wDOiOeUxUls6gyC3stmFWVR32eJxfhjEB
	IZET/lNxOTBFuJoQMxTuQOVkO4oKX7I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=XC+6PdT0;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878652; a=rsa-sha256;
	cv=none;
	b=3opYCgOvANL7u9lmJsbuBOgJvNju5XjgsAEWuZFcYrkPGrM3L0ZCiyaea5F/z2m6/7zOtX
	5SRKvqskkq4e1wogg8GfUuYwKlvesxX3Ro0mcS++JXxHJy5T6wZZyn2tdxs+u6d2mU/La2
	YhGJgTiZ4DyNH5ClzJnByDPBbL89GxM=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29844c68068so18526375ad.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878651; x=1765483451; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qa06X7BN7aAxeMRj1RtrRZw6MLM+PhxlK6i/AnJxckg=;
        b=XC+6PdT0ks4V3lnRkTSm4VzOB+Z18UD6NCX/CKNi5DlSCO3VvokH607jHkcWLWgTJr
         8YtX3RCX9Dk1tk/9vv9T98OD0Ruxyui6fxziuggrpC/jh74AvQ0gPlIYvsag0fp+N+3l
         KXPhsHoEJ9G9TUugcNH5MBYd7Ac1a9H4d528VVsW/Cmh051lOHTkbCursB4giXqxlM29
         F5ladynuvQ+IuwALGXL7oH6lL/j4IRUsaLkND4341PHkalI77xUeJF93A52KSluw+Dvc
         OVtWkcgBrEuN1u0sfi8mA1/yb6KwxMaevh99wF97L26VCFDGcYHY1c3d7RPH4QeetYoQ
         OLIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878651; x=1765483451;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Qa06X7BN7aAxeMRj1RtrRZw6MLM+PhxlK6i/AnJxckg=;
        b=hct8eSDjSYJQW8mdMit1QAN5s8Hqr5tbTYLdSV2IDRzNsoxTf1vn9uMFWpSWvu4odR
         Tv8MGPH1Ktr20MPHcYvvKYovjFVh2GBY8uaToHkdG/pDzCE7zZw+YzgXQLWzR1j3usN5
         cFcEfXeGJhq94JY857fWbm+4RffQvNAbSisDc7Futda4Mj4GrAOUsoffHArhGjUOWNmq
         urUcUZ0PX2UUnWT5g1KhNcwJVf4wurvpzufvBWmn2GQWQVa+e6566VMhpNHfL5SeVTyx
         uwCta3zbUfAChKcWiqGOLGcmFzVUtqouT/YLZoeKGDFRiycoR+HaRB7AdIyQJq9bzCPu
         XB3A==
X-Forwarded-Encrypted: i=1; AJvYcCW1LqFfafvF94x5CDGeabq36jIp0BjLxZes8Nwn2Rwxuq0AVOE+P3lezBNfvQS5p7zJ/+kSd73LSw==@kvack.org
X-Gm-Message-State: AOJu0YysJuW7sZJd7nFlbb3QOM/sgGggtetRGfre+/RqebAcWlP8COVb
	tePdMLdXrzaHB6RN2Un4aSD+Vw1sdc3x/rUQZfVGt4ScpN98WsN0E12u3vIw+eXWJHc=
X-Gm-Gg: ASbGncu1PtpwG82Ys3GXXkBPIHL3CbXIaKV9FtyHdmeKHFEiKSA18lLw+EJFqn4mAcc
	VUStpl4a+krdXC4teC/fqnUgJL8lRy/RVZ8+/Hzeg8GzFIgK2NrgiyMH3cQfF0axuKRI5UvX5V3
	6WcQnYPPLmmKttIYWsW1/d7fpX96xLXZqH4ucT022wU8Gl2Iby+a0xZ18sEUoVWwOEDcGguv+NU
	7zTxh14Kzs9OtgrnrmCA/RY0S06c+4vndXIwRHF2TNJdlPgfbMYtMW6dQtG13K5QOnAYfU0x+kW
	GX32+mmz62mw4oYc5URyPKl/ogs+iDaBMSpPFMuuCJYF2FO89vbnWxstK0JD5pfw3sLCJvtsmu5
	SExVzEg9NVptrDI5dKF793ox17NCcXT3UDQzIlbzTVC3gmarNqw+c/qvNmQWZbGPxlaP4vM/Kpn
	bDZ14ZhTrgrGPbru7EgW2mTJ1Hm8RLWrI=
X-Google-Smtp-Source: AGHT+IGQ93TqFVL+sx8jsqiI8XZ+MJnFlOmBjVkc1eOo+ShzyvN/Bpvd/OzCquioUD3nqZACMQrvyw==
X-Received: by 2002:a05:7022:aa3:b0:11a:f5e0:dc8 with SMTP id a92af1059eb24-11df0cc5e15mr5352198c88.28.1764878650785;
        Thu, 04 Dec 2025 12:04:10 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:10 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:03:55 -0800
Subject: [PATCH v24 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ |
 VM_WRITE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-6-ada7a3ba14dc@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878635; l=4345;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=7yLe9hWq2WlkWVyw5cBB8KO8waygymuFRUw/WyJutrk=;
 b=4OgDyO5tFJc8wg90W1KsiGKi047tWI8HtvaRrWwmNmenU8ADgWOP8b1W62zFmhDNTHv/KW36L
 xv14zidE25aBEmYL3yAmlNekT+HnSHKI91F7Dppn3WkodGabRQAR+R0
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Stat-Signature: y4e9skmbge6p3yqin7mcp1kqjf7itpmt
X-Rspam-User: 
X-Rspamd-Queue-Id: 35B4120004
X-Rspamd-Server: rspam09
X-HE-Tag: 1764878651-241386
X-HE-Meta: U2FsdGVkX1/0ox4BuaMSxjknkXZaZv/fw1fLz/KOtszdYAgwERNLPQU2Rq+F+D1O+TEjTBrQHSEyaKMGsTNJci8ioe0o8sjoeHwHGqXYWSuSZv+i0kwbE4MwB7Yzmzc2eiR8MceYTMVDkGfS3BpqbWJrcoNbdS2v33HxnoAC11LscrKR4uO98wHRnDRYqJVSyolqtiDXw7GUGCmeBIigOrMxVFMlCuGRSXqbPJPmTixo9i6fA5E6ylh7/2HHAd4NSkqk9yjajvAzKAt0GS1vySJEajVb60CZWMzunOZy+GmqZkHHxOfUE4E6W/34XnWBpLOM926KaQZScApdNlfyRZ9FxQuHTwLxCv/dO3jMCaO4dH01zOxpr2PpE1kC8FJXLmn3066q+nB/9z1NcZnnnMjkAZVAFmqbYDmxbn4NRKOhiGh/6riEXrCZL3ThT1nsTinSfeSDt/ecHTjGKn5iqNCXFW3k0SCpyWdr+7OK4dPFwOCD4F7c5BlrTdNblszo3u/FLKpBzV7YYLIq4DeYgwWOzyc8ysWmkmwpRZcMasgGqJICcKIwyTe0pihMrEgsM7zG64MrBQX4oUxAEOYl3zpsD2bZxM/p8jaIDdskDlLotNqPwQpRvAwhaqeAzGxbq5whN+QhnRrccPdSbp4cqSETVHcTCQ1wVDk7ELmI5jL0bWRHWTsmcBSYkAEbkKpaA66s6nxnDxDJ8k443EmMQxv+abT/j49KP4ZqJaCSYduyOzFxY0Dw/qMhkdaSJHdmstoPKxLGZ4LbjNL7/j2r/tTuTOhtNQGOcpKx6zNIJAVf9s/xyIgrn2bFK2eKdzWpeIhOI978WnxziKgbSn9TufZVbKP/qDUYYpMcPAVpuyRQzetAu14byGQw8SEvu1q5IqjtcsqCeANBl46LcPbXbUujbhvHv3qzsR4f0F4G9UW+QuJTMjBFbS+EYyCRQUDhYBanAC7V0vzcXY/Q1AG
 IALGoW5H
 8ih2Iuranz6Pc14oDfZDqE8r6V706/m3v3uadPIgUCtBvxwRToNDUkQIChSBDYXZA+p3UrvbdX0Gu0a8cmjvUW6I0HhSOSM9rSB5znHuAH+d608WqewKTBrA5jfY9qpeZe2L16d2tz+W5cl9CrRL/E7Wc1RisTpjfkCCT3yO1YrsNh3yAhAmA2/UyRgrfwFT7d5CCHhVYc5yPuNaptetKypLQEZSihPGT0LXqTVWy1g786l7MZhPfHvXBXAQf/G0Mjd6reb7NOVCG6/8L4VrknYdbj5ElBhQNjlfLb84GpVqwwkPXLaJMA+StrfdxRPDo51d2BHbHR0hkersCum0gO+6KuTZVVKLio2vlDHh7Kn+RN3tFPvmU/094vr+EIwuiJnU8hcqcpVwToVnDP0m12eyem6DlAIR6x79YiHakUyaNu9/Vwx0I06oGqX/LFD1puPiXmqDrfkAMte47A17lAjDxF1dQ1YDwrcfNLHjgP9Npk1Hrfc4+sGuUK8Php8nXFrWnD7MRpen2kYWjydT2ncTok4J2E7parzVE
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


