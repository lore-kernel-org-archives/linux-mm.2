Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C5A6D2A523
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0AC6B00C9; Thu,  4 Dec 2025 15:04:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911DB6B00CB; Thu,  4 Dec 2025 15:04:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D4C6B00CC; Thu,  4 Dec 2025 15:04:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD316B00C9
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:22 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D6A1C03A4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:22 +0000 (UTC)
X-FDA: 84182865564.29.BAED869
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 047FCA001A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=VnQOHdEG;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf15.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878660; a=rsa-sha256;
	cv=none;
	b=PZoUR/rzzf9B6Gp/ZvmxonqWu0Pm3iqAInyC/sMX0McRLA/cNG4W8GDHOkDSpkQebSon92
	p3hP4+kvblrfd8kNDgmXEunNkfOGKTW3uXQ3UjFGVlAg/k6a5M7YmLz+QKb0bwfBta8z3x
	9nODaxlpN1ILzFPnnHATQBnjvyzm6xI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=VnQOHdEG;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf15.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6P3tr09CNDNlcbFQiO50QN3vMyxHMFQbRxl9JwF/4jk=;
	b=7+TFoVtep2BpuTdzh3lfxqDqo0VyObPDckQuBp5lp4e/WLwcdeJxz0dRFKN8IKU/EMsUzT
	EYkTZDwW3pqZ+Qxx2LAvkPKKY7yIQBM+6LB//1JND6N5nS2DoaRJhuL2OZIv8U4W+zrcWw
	9FGNzn6o06bXACsoEkkDHkBD0SogJB0=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7e1651ae0d5so1074776b3a.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878659; x=1765483459; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6P3tr09CNDNlcbFQiO50QN3vMyxHMFQbRxl9JwF/4jk=;
        b=VnQOHdEGjdRFQuAuDEL1D2CJBUSpankf4JI9JX+F2ypOIhY3e17GiAnEgVjR1UgbW5
         v1QT42MluzJrmAKVCLsbAwS9vK8HVw79AS/xgjoSk4iO98Bp2NY0HbBxjv371X7YIfYG
         NEueMC6jV28z4pxpgdrPMqgjZojWu/l+u5GZmlomSppHxazKujb3SX1V4FhZgyyJFTLa
         5TG7pnFxjQvIV7UfHc0i2HF+n9VWx8c8xj1bHMFCV/utB6+fvX7XFeK7KEVPbsf+lwv0
         MZ6YIpPejZhs7n9BgLYzidqEYt9hpWNF/pb6N2e87rMkqv5DM3AcV6PEhiE3289XUAF0
         efLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878659; x=1765483459;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6P3tr09CNDNlcbFQiO50QN3vMyxHMFQbRxl9JwF/4jk=;
        b=ksQwI4g/+3v+XvHMe5gzEV0McFXD5DTHkVSHu/QAWu0CIN5jv5xwujEoWJF3hcS9tI
         +v3c5fyPZwMAd/uuVwejRjAQNA00i8eYe10kEGG+a4uolicv++JlDMKoPYQO1+olWYK2
         J7ShpGeo8XI41XdSZ8rfxujpNQYttOUBSXqHEa9BDGz8z4WpK3g/UkhQOiu7ldwxxkRk
         qLoRFGw8llsLoS+4um9VIowuWzfC4Q/WXXL8RLaM0R10zQKLhRyxHJ4CIRjOs1SwapNr
         7HpS68YuG55aDXJZQ5Ml1rjtEyaOhaKRhFDOOLgmEpgqpOPJ1Sy3+0buEXSwl+2CAcxx
         GOUw==
X-Forwarded-Encrypted: i=1; AJvYcCX3xucW5o0vvlw6LDl20vi/N2En/tOhhlbsrLj1c/qet1HG4Ey1Hfv2bysGcGHZAKtks/vUGkx7Aw==@kvack.org
X-Gm-Message-State: AOJu0YxoyptfEgOzasGjOcpWjYiRXpOmNTUukQOL58QiGrxACDAbD08W
	0J3DivkKHJnGahG3kNPe5pZEE5YTj0qKD5R/5qNBmj0O9bDEgCEnhdUYmUXfSnuiDgs=
X-Gm-Gg: ASbGncvKITj2u6wPLsMp21mqiv0I1oNfQj6s958UUCjt6y+SKKrroBpv+h/NMB/CbHn
	9EijXaEyknm8FXbGKjiOmyF1j3XRdoRwvSeMp9mIJGcFn0RJFi45LHviuQ0kEBwHxzC+6KJLFbZ
	YQJHGVYOl3eZ9oqqGYTBZrVLqkx9E2C3MHd5ZmDchGH1K5SnqDu5qlUooCdfCWSrxFspi/5ky8Q
	0NbPjdETIVj5QMfMJfvJ0HvhMv5sTUKkMdsGdNMoHaJwMXz1FAjYzi0QQB7vMBndBskhAIvoUuB
	jCfMptlqXdTQMIe9C+SFH1/yjN8YoVJ+qGBaiLJrMt/5lfHdbZflf22Dqt44bh0uhvCtV+PD33o
	VwPR+mfZnC1sQhwN0IKgDvaxix0WWv+kBflRlZH5pyu1UHAH/8wNqj4/r39nlE2jGQGpxdMRe1B
	aPIPLOzUhd91I7plES2A5d
X-Google-Smtp-Source: AGHT+IGyfwBg5AHNUiCEs6P1Sr/v+BE3eR3xlZlJmqiAzt2NHZlNOJNx+MuCKeu+fA2SG8YQM/vztw==
X-Received: by 2002:a05:7022:ea52:b0:119:e56b:98be with SMTP id a92af1059eb24-11df64a450cmr1960547c88.37.1764878658724;
        Thu, 04 Dec 2025 12:04:18 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:18 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:03:59 -0800
Subject: [PATCH v24 10/28] riscv/mm: Implement map_shadow_stack() syscall
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-10-ada7a3ba14dc@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878635; l=5985;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=RGAXmJC+2fh8R4zAuN/S3Zb/P8BdVNqgePwfv4Dyl+U=;
 b=eBctS2It1wu38uuX/N9GJsGvr6MahM53Eyuv5N3XAOLMGL1a+9Xk5p819GMjF+UPlJIU6KtQZ
 XfIIM7aoeHLBB87EqAE9lU8YKKsFeXiJmVf399Yeew+D5K6pf0kGrOF
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 047FCA001A
X-Stat-Signature: g1fmgzrzoqewfjxkdyirnntj3pcbprxz
X-Rspam-User: 
X-HE-Tag: 1764878659-622331
X-HE-Meta: U2FsdGVkX1+l39xaQsrG55tb9qVXq5JrerzpqjK03Tz1zBlF5bk4KZzvxfhNqB/CQTRIia68+eyQ4wtLNSZVts+Np4GlCmrk0LinLGbOzNGqOKfgSqe5BlB2oIHFM75umVm58q3+RkuqRmy3C+AFR5Wxey+k1ji9pds9H1wpOPHtLewYcDf9ljllFhstEN9Xe2fANUhO7iAQKd1ibbOL9F5WY5ddFUW/sAH4JwaP/yj2xir0KAhRzoAltNV+iqUyfXpziAyUtWCr9AGoumsGUmXf9F94D6vku4Zqcz0L7l+ElPiHYIecDAqVB1M1cHA/4SrqAijPYxo6UcPvmPOZu0ihcV8xIzby5buQnEPZTg1Q3UrIUOCeNRVNUSO1olSYy/ckE8A2Aj2D+rsyy5yl8Hvc6QDrJVNAH0HTqCnx7lYxoinSZwHtQG1+5GiZR2rf4XYk0PPjAR6FX5Toa1qYjh3p4TAEjxdruJiDPsWpK8VvLRwYE1PfWwkJhFiuXwQB+vUgdHFuAWwslTYwDHnqVhSMUVR4e+UPBr51hDEzp0SBpKUAC/Ngci3w5ScWVg/ChzHwyLZXJ/E4MXcrm6duIdBn9Lixn6fceDbVSrLn3YXL/1IywB4MhSXsp/tftsDxJAdb/bMbfcZouuE3n19QyUQQuJtaeNfpYVKwfOqXFF1MV7JG1ZlDqjC3DYKPciNuwMF59xFxNpDVCnZGTVjp9EcPwScJ88Uoo09e/BbfoGGmA4AhT6Xd91FQhsG7RELGBxXsN2biB9xdZnBAx/sgkiH0PVu0HeIWdO1Fm1rggcqs6wkBOxFo9mx/XINl1c8d/0ovNmSynoJVt8T1GGvHeBE4iDkxv25yIuIE5wTMtK4wkY6NHUNARn99D6kgRIUkgLOx6+6uF2nZmR/EHhRqUZUC236VUZJp5zbzEoGvNdzjw3vkGnTT8hrv2h0C8FhwHRNY3i/UNc5lbWSBOeH
 PFLwMITn
 T0w4w0C0Sx+yvwLYk8P0QGRLY1GnHzXWU1l601fPmZbXvXFQX6VZohk55q72eCSrqMbHs7jq9xSONSW6QiJSoEWkqpNj0QhzaFawwnC8ubNYxhw97pM/0HWwHG7zO60MKV3cYWxIKD8F2IobtpN3btvg5fjdMitI5P8l1S49WZ2xFcxWfcFafcyp9h03CjkVBpuAI/llaklNxm0fnAwr7h7itAkiTx+7U+lz/qW/q97xDg/R6yYDr4HTNaVGS7d5xFOnbtLiBLM7azVYKuWpx+2JJX6boWB1TmokcIymPqpyJL1QMgDNeHod22BxlCS3GY9obTtLNJWdhzeA5G9l7rqJKDJWoe7g7gg9lDw9jHbxDaJTqz9AK8OVJnTndlOYsIizeyz+USPDoHh+bPuAbQj+sKidchwHb9xExw0JB9O64lbUT08jfwNXpWNOV0vc6ikmRKx3tLmtempBTshASaOerf3TUlSGrSChLhsuRGJ3yX43p4T+vWd6t6YkNyoDV1Rop41TJurvOau1SPD5IguKZXzCdkwqR1o1yu8qr+f+Pnzv04Ds1MTRodJdhuGGm21WOZ5JTKoiws/A=
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


