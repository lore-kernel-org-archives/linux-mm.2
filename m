Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CBF0D339B6
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02D0F6B0251; Fri,  5 Dec 2025 13:37:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004C26B0253; Fri,  5 Dec 2025 13:37:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E37476B0254; Fri,  5 Dec 2025 13:37:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAB316B0251
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:14 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91D48C02DE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:14 +0000 (UTC)
X-FDA: 84186274788.25.7AA0F2E
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7C91740008
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="P/NDCgyz";
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf17.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959832; a=rsa-sha256;
	cv=none;
	b=vIXc9VrmiumkqF/6AZFdu6FqmWFdBvN2OAAkLVLfzNsu3PGEzKak/ZPHk5KJosz1kByBii
	Vfjg+keU/hUV2mjtbft4GXSJlWaiUTYgzg748O9coa3VJh5vvKTtkA9wUQys4zuvduliIW
	BLOQU/hsfYiAViqFKMEd5Vi3lqunZUE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="P/NDCgyz";
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf17.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6P3tr09CNDNlcbFQiO50QN3vMyxHMFQbRxl9JwF/4jk=;
	b=3qsIATLcftXBL9nFDqVvflp5J1FjSs9m0P45IJvQfgrhTfnvumXuZV6zAZusjYFnrPUQ1j
	J/s0ffSbS5VY9hqsmTcevCuEscqUp7ltPnTe5IZTNPR3ru0avC/NtgMT/VL316dcG9CeBs
	NJSp0mgBXg1yFkUKh/xfBbNmRc9GsoI=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-bc0d7255434so1367435a12.0
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959831; x=1765564631; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6P3tr09CNDNlcbFQiO50QN3vMyxHMFQbRxl9JwF/4jk=;
        b=P/NDCgyzUQ4Hzp7r7p8to5VzCgzW0faWYOE7DDkiwA0ZgSudu2nVcoTvRd3/ZWiHMr
         D+72Vp9WGKW5Jdkb3GNVeWU0Ato22TOjDk0uZ9l26T7yLi3ch5EYfBh8jYzWTy5coAYN
         Pn7j0qu4sTFO3LWEKKh8hpQbtxlAINIDOOYCCex59H67W1TnF9Apvo7Fnoo5by97YNyP
         VULT+vG2G+VGEwr8vEZSdyMsOhANnqbfQEGi9pWPwGjsGW6cb3Uf3bY5jkdh6x8Gow+S
         GJ9VDcFUxymSpg6xYXaI90O7GZQ2pGUNL9FEhavCQ7xIFX2YmMqM6fBks5dGSCTKvgVP
         SO2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959831; x=1765564631;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6P3tr09CNDNlcbFQiO50QN3vMyxHMFQbRxl9JwF/4jk=;
        b=b8SJgk2tGAScHxL1wl9CBYGlgfdKbDMeYDYAe1NOAkCLCBN3Qf+6YEUGwERk919ZCM
         8pyyqkUS6wvVtnVbwlpulMfr32zti8XevTJlfd0NOpJXYGMrBggMIQVZUfzKy8rwNiGN
         Xfv7MVLWcAqnQCP5QBkppJPvbAEC5PdN0ok2hI64Jj8H/4ZGEae1HLapXAQv8JVSk95w
         mjCn+Tq8SGS+C86Rw26N0p/ku+/4qjald2iyFyezSDwxQmNWKhIiroitIaLynzJAANoJ
         6LlwycDZGk1XUUS5X7XrptHk/y3TAoZRnzcboxIY08XedP70Ctc0VfyrGMpYpp1V7mwX
         ye5w==
X-Forwarded-Encrypted: i=1; AJvYcCWyRY34nWzCJ3kkIo81BH9XWHo4/KYvV5gZTU1ma/YMcu6B/DtFPYxOv0QIVaKAnAKqphG/Obewqw==@kvack.org
X-Gm-Message-State: AOJu0YwjPC0NK9ZNMN5k9pw7/Z+EMqsyyoP2A5Ka2Nz/dn+bo7OKL7xW
	hcysA5i079h+lstrz0WAFmfO4HZTQZ6f/J0TuG9GWeSf1FdgU9rjwZkXPXDbPpqQxwg=
X-Gm-Gg: ASbGnctaOn5cxSIs/IkmqBVDR0lAMYTkqc3VVYp78YRWUyIpP+a5BFoG/HpVjzk5wTg
	c3VaHE8eV2ocUj/ebWSYRslKgYe7MAdO21EBAqPd840rbyIcdrCRMO4E3V17JcrS8rN3gZHcb++
	FntLco2IPe1WvYxcoeHGy+v4V9fIi2dANKueFFaCGOYhl6ah5X+UhkeE2ZCr0Clx6u7eD382tX8
	R1x5wnqcwVe75JIdW2FKJGNwjBYbJ7A4IF/jZijD1H6oysLw01PfmEpS6vsv34/JPvRQWfImbFa
	dxAG+uyfaJBB33cM2MWqObJjQZVGMhm+xCgeWJrtJS0/TTgEVITLDCI7l59fKdRkF1KvmnkJuRR
	W5Py6KJE3t+xapfVsXszJr02UG71esDnYRFKcSWMx0Aofbt3IlcHEByJGQ1xHAYUS4oruLLLeT+
	h+yqyGQ+4gf9afe/mzLN9q
X-Google-Smtp-Source: AGHT+IGDq7mddOOrT5fT0Dw4BzEYkKvr1uNa0kRbW9ertdtHHkwnSfKDy52Tr0rg2A05y/e3YvLdfg==
X-Received: by 2002:a05:7301:1c0b:b0:2ab:c284:4ae with SMTP id 5a478bee46e88-2abc720156emr81281eec.18.1764959830279;
        Fri, 05 Dec 2025 10:37:10 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:09 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:36:56 -0800
Subject: [PATCH v25 10/28] riscv/mm: Implement map_shadow_stack() syscall
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-10-8a3570c3e145@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=5985;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=RGAXmJC+2fh8R4zAuN/S3Zb/P8BdVNqgePwfv4Dyl+U=;
 b=wzOeyy9ub7akChDr247/bvDfsiJXNhWs7TK8AtgdVcYtCGYg512MiwqxGKRQa5o9K56e3HUaH
 GXiFbxYAwoDD7LsNoCi5swhK9l/rWl+vo6bRTfrxuC/n0A07XZVyOHg
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Queue-Id: 7C91740008
X-Stat-Signature: zsy7geqyrt6wckpfymgthucouhzpn13m
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1764959832-259801
X-HE-Meta: U2FsdGVkX18JfsoSw/wsDTaueZ2/g/3Vnys1rOesrOUr/XQr9cslqAyTcwC+l1nm1LZGXhvaY9hJyZx2KdZw4YTaze/5Q3fAkEx7yjACe3VK36QZXd1qgai3t1a/jmSGOkg0t2rH1HoJJ3M3bA2OrQMBbaMOH8tH5fEDyxNrkcBnY4m386eGf7KcccZY4+1zzCtNrF+KyVZ3QgOiNv0mD+q9dkORFaMsHB3gzMtwnFm3o0MqpCBKa2kuBCWzE8FjAatd4X8uy8jeKR+53I6zi0Lnq28blMGiFXyxRnH9JUZ2CvL6nIMdsWRmbxu7VxrAZtViTJVL1jfuTL8cK9pN2vCGWAbsCZwPyNtbvjL8cip5ezwonJ18EfF/1/D8wtDLAdtn6VuMi+3H1/ui7tU0CjbxdAsjiWxocVy8Iorwt8VlSdPBsyWXehJKDl616XLQkegKG0oE08teC5x5lqq8UChQkIQ/rJ+OOVUUBBTyrwvNsCFW447vSEgR0n+44udiA+HOD7iZDgS9tqibUmyKuCByKfK1VYZrLb3Odh1Pl5xqrTGiUmG4jRkGrGMhyPZyTKHcsmCU+KbnwDgOBprNDIopt1oRkRSyrF8YuNUnPgFMuyi2fHF23Rdp8bOvrvUBYY5XgFxVAF+8yeVG274kvv1Ak1f8/SXhqAFJwUSquQx74SbSNjQ33CR10gfjbogfB4DfSzryIeqWIDtjlfDlZqEoVJuqkVZXaD95vi3R6iZgSfuIz6izuSEbG0rG15aQhKlYMf+qnV7gR5czTldJEHl3KUOt0upVOdtgzBTOOfdCz2dkB7+LnkjqLruzHGherujPHpaOlsAGtpj79j3tL0wpeQjwzSzBA8UAzY+VngBut9ztadj+ep1qjHY1O6U+XWNppHFGdsnXZFo53MaQxXKbmkY2fPdnGu66Fm73+4E+3N7eyFjgsONz04bsK/d+99OG30zvl7UWhzfoJuc
 RkcJwlxJ
 Ld8a25qusOkNN2n7EBat+Rj84OZL78GC2I0AXfhXI+HsmumTkJt1FI00GJyozfPyaKOfN0LXipPVb95mpgrKA5cFYJwZoszqAEnJPqBQWweouO9R8DIJeAzxv3ofZRmKB8Mn7yeqcnGraKblO3Dgl0UH5j+zov/S3G7jNLl/XfJZKLaqmHV3kEMFezkGl1hXfrUBbXAQsXMEvifhFA/afMey/UntKAOYVaOT7FIN68/gfhwOqfWqBP6/rQHYfyW/T8WD4fQiV3WEFBFc/IiNBjJd0V5aQV4erX6QGlOifjlBdxsjvQSfkw7WpIPR9/UdouUmlULLpHOmUEjy99Ib5pRyKyDdRK2JoyT3Kq9FeyWWDm0V+J4lN00Ylhv2KfTf/CCLKMX1bWnFTJblk2yGISWUCcV/fsPS7ZenVu+OOG34jvm9rlPA6F6atMfeFQzoqX+wYxZzIV1DN1LSOXmcZYjFqLD9EE5ni6zi0IHLoS2TmBDriNN1LtRWPKF0eKrWCUvN9VgZXOxmCPyxPctq490RgqgUl0UHGSX9o8VxG60NzcGSUrQg/bfOz639PUyyng0fqCoHH4z6bTy4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As discussed extensively in the changelog for the addition of this
syscall on x86 ("x86/shstk: Introduce map_shadow_stack syscall") the
existing mmap() and madvise() syscalls do not map entirely well onto the
security requirements for shadow stack memory since they lead to windows
where memory is allocated but not yet protected or stacks which are not
properly and safely initialised. Instead a new syscall map_shadow_stack()
has been defined which allocates and initialises a shadow stack page.

This patch implements this syscall for riscv. riscv doesn't require token
to be setup by kernel because user mode can do that by itself. However to
provide compatibility and portability with other architectues, user mode
can specify token set flag.

Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/kernel/Makefile  |   1 +
 arch/riscv/kernel/usercfi.c | 142 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+)

diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index f60fce69b725..2d0e0dcedbd3 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -125,3 +125,4 @@ obj-$(CONFIG_ACPI)		+= acpi.o
 obj-$(CONFIG_ACPI_NUMA)	+= acpi_numa.o
 
 obj-$(CONFIG_GENERIC_CPU_VULNERABILITIES) += bugs.o
+obj-$(CONFIG_RISCV_USER_CFI) += usercfi.o
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
new file mode 100644
index 000000000000..251c3faccbf8
--- /dev/null
+++ b/arch/riscv/kernel/usercfi.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Rivos, Inc.
+ * Deepak Gupta <debug@rivosinc.com>
+ */
+
+#include <linux/sched.h>
+#include <linux/bitops.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/uaccess.h>
+#include <linux/sizes.h>
+#include <linux/user.h>
+#include <linux/syscalls.h>
+#include <linux/prctl.h>
+#include <asm/csr.h>
+#include <asm/usercfi.h>
+
+#define SHSTK_ENTRY_SIZE sizeof(void *)
+
+/*
+ * Writes on shadow stack can either be `sspush` or `ssamoswap`. `sspush` can happen
+ * implicitly on current shadow stack pointed to by CSR_SSP. `ssamoswap` takes pointer to
+ * shadow stack. To keep it simple, we plan to use `ssamoswap` to perform writes on shadow
+ * stack.
+ */
+static noinline unsigned long amo_user_shstk(unsigned long *addr, unsigned long val)
+{
+	/*
+	 * Never expect -1 on shadow stack. Expect return addresses and zero
+	 */
+	unsigned long swap = -1;
+
+	__enable_user_access();
+	asm goto(".option push\n"
+		".option arch, +zicfiss\n"
+		"1: ssamoswap.d %[swap], %[val], %[addr]\n"
+		_ASM_EXTABLE(1b, %l[fault])
+		".option pop\n"
+		: [swap] "=r" (swap), [addr] "+A" (*addr)
+		: [val] "r" (val)
+		: "memory"
+		: fault
+		);
+	__disable_user_access();
+	return swap;
+fault:
+	__disable_user_access();
+	return -1;
+}
+
+/*
+ * Create a restore token on the shadow stack.  A token is always XLEN wide
+ * and aligned to XLEN.
+ */
+static int create_rstor_token(unsigned long ssp, unsigned long *token_addr)
+{
+	unsigned long addr;
+
+	/* Token must be aligned */
+	if (!IS_ALIGNED(ssp, SHSTK_ENTRY_SIZE))
+		return -EINVAL;
+
+	/* On RISC-V we're constructing token to be function of address itself */
+	addr = ssp - SHSTK_ENTRY_SIZE;
+
+	if (amo_user_shstk((unsigned long __user *)addr, (unsigned long)ssp) == -1)
+		return -EFAULT;
+
+	if (token_addr)
+		*token_addr = addr;
+
+	return 0;
+}
+
+static unsigned long allocate_shadow_stack(unsigned long addr, unsigned long size,
+					   unsigned long token_offset, bool set_tok)
+{
+	int flags = MAP_ANONYMOUS | MAP_PRIVATE;
+	struct mm_struct *mm = current->mm;
+	unsigned long populate, tok_loc = 0;
+
+	if (addr)
+		flags |= MAP_FIXED_NOREPLACE;
+
+	mmap_write_lock(mm);
+	addr = do_mmap(NULL, addr, size, PROT_READ, flags,
+		       VM_SHADOW_STACK | VM_WRITE, 0, &populate, NULL);
+	mmap_write_unlock(mm);
+
+	if (!set_tok || IS_ERR_VALUE(addr))
+		goto out;
+
+	if (create_rstor_token(addr + token_offset, &tok_loc)) {
+		vm_munmap(addr, size);
+		return -EINVAL;
+	}
+
+	addr = tok_loc;
+
+out:
+	return addr;
+}
+
+SYSCALL_DEFINE3(map_shadow_stack, unsigned long, addr, unsigned long, size, unsigned int, flags)
+{
+	bool set_tok = flags & SHADOW_STACK_SET_TOKEN;
+	unsigned long aligned_size = 0;
+
+	if (!cpu_supports_shadow_stack())
+		return -EOPNOTSUPP;
+
+	/* Anything other than set token should result in invalid param */
+	if (flags & ~SHADOW_STACK_SET_TOKEN)
+		return -EINVAL;
+
+	/*
+	 * Unlike other architectures, on RISC-V, SSP pointer is held in CSR_SSP and is available
+	 * CSR in all modes. CSR accesses are performed using 12bit index programmed in instruction
+	 * itself. This provides static property on register programming and writes to CSR can't
+	 * be unintentional from programmer's perspective. As long as programmer has guarded areas
+	 * which perform writes to CSR_SSP properly, shadow stack pivoting is not possible. Since
+	 * CSR_SSP is writeable by user mode, it itself can setup a shadow stack token subsequent
+	 * to allocation. Although in order to provide portablity with other architecture (because
+	 * `map_shadow_stack` is arch agnostic syscall), RISC-V will follow expectation of a token
+	 * flag in flags and if provided in flags, setup a token at the base.
+	 */
+
+	/* If there isn't space for a token */
+	if (set_tok && size < SHSTK_ENTRY_SIZE)
+		return -ENOSPC;
+
+	if (addr && (addr & (PAGE_SIZE - 1)))
+		return -EINVAL;
+
+	aligned_size = PAGE_ALIGN(size);
+	if (aligned_size < size)
+		return -EOVERFLOW;
+
+	return allocate_shadow_stack(addr, aligned_size, size, set_tok);
+}

-- 
2.45.0


