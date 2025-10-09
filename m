Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F306ECAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AC8F8E0053; Wed,  8 Oct 2025 21:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80E8C8E0002; Wed,  8 Oct 2025 21:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE7F8E0053; Wed,  8 Oct 2025 21:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 528608E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:58:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0079F1A0882
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:58 +0000 (UTC)
X-FDA: 83976917598.23.B493CDF
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 15548C0003
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=V4AaZ202;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf10.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qox8adEL3NVTIaNLXzvlCmJaaMYPBhbok62G/+ufmI4=;
	b=TVWej7wwSU8yt+RmHtjxSPPY3PqeMOm9jQhcLLrbkgtxGb2Ak///ULqqWsqkmzzgf/dNAa
	sCDbGXhwQr+TYKYODHIcwu98r/mU6wjwtALONeCl+BQM0hGpUXHYop/4t7Ym/+0QDj/xex
	Inr9bwgbvaRHIjCPAncKes/+i4KfLD4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975137; a=rsa-sha256;
	cv=none;
	b=ZdhI1PLQ0iN1BHYx20wxMgX9z+IWW4Rl9pHPxiuW4OdH1HsBgVhfnW6oGNGsirnuHGHf8y
	bFIgN0cCPLrYSaOvjEpwZPvCf4VXROrRzRNDNa9F2OHvoRLGR9U4MQe+fGWvo1Hsl6OZXJ
	x2hmqvKlNAL8xzOtNLECK5WXYv5nodM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=V4AaZ202;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf10.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-27eed7bdfeeso6737805ad.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975136; x=1760579936; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qox8adEL3NVTIaNLXzvlCmJaaMYPBhbok62G/+ufmI4=;
        b=V4AaZ2024YuSoKYAYdHrIsrU327aD0hhqUkFZdVJ+z9yB/g2UmDy1EKCU3CVdgEOB5
         NE/5LftDc7XOdnyRokd3RttNB0v0MD3920X3HBgRBmow5N208DqSUWixmq/XDBA9xFQa
         CJ3NBTgkAbwFFzOHUx9RcyaNEkhzeAGaaUO3oehZCGHT7rjID2XXkCE25toAHhrkrbYe
         utHuG96dTw9veOJ74m4yQVKtzLIrG1v2rTp4hukcCeioru1Qdx1N0/4eyGqYjaYqhyT6
         7pQ1dwOaW5Gjw6aa331yXXS5KDlNF1rX68N1uHnCCSd7CkdNQUH9LagvxkT/VIVWzaHO
         1L0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975136; x=1760579936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qox8adEL3NVTIaNLXzvlCmJaaMYPBhbok62G/+ufmI4=;
        b=PWJyjVJqPpvVWNzMy64TKWCkbEJ477EDiko3Ha03t0VcydDNT8Ody9yvabLYJN2JMi
         I+xdavfB2f6N5VOYTV71LcxWnPb7pRlatne1JUmGSTCwyv+JmTZkAhkRz1K1o9RDM2l+
         14ryx69AJbJ3bo6b6UEAUd8yET7TqgBjoZCc/Ipvwq6a6f2cPvYdAhCpxHL0Y89axjB0
         ZKS07yNM4qUmcq0mcsPunfs/rG4Qxxnh3oxHJmpC8svza9Wuy+YH6XJWMT8lf1YIKpo2
         fPkeFAXhWYiksiJd6veb6kg5q7oDraKNjUSdnw/gEQcFCF+BcCXF4oB3eAhOYG08+Dn3
         Jhxg==
X-Forwarded-Encrypted: i=1; AJvYcCWuTK60Tol8rjwLxYvwI6RGJ4uYp6uGZV3cwh6+4gRAou1OyzAA3ev+FgKx6PRnZqjM7iGZzanzTw==@kvack.org
X-Gm-Message-State: AOJu0YzfAicJHPXc1qLhOzXvRUA3whPmqKZuPUR47I1bCfB1geWTPRvt
	nht37AdMwabSdl6wnLBclbclV/PDQ2agsX2W6gecW1fnCtZM0XB2aON/h0vKV94OgjQ=
X-Gm-Gg: ASbGncvC4+B2tIr+9PzPZdHy5TDFMbKBk339pNhG+cKjZDh7WcA9J12gFjzR5aE1wSd
	aK3tc3scFPuDsWzM9rR6AaGd+odLgXN5rLIIF46zk9zCB5N/dIWoj/sgyAI625+Sh87Lqnh6RjH
	z0xVtTfsV6O/DMIOHSyInBdTt63KeVnNlJlh8ZWd6JyOd+MipO6YHL+ibhntnxN+i8DaniV6E99
	JuIXEx8vXI+CNNN47PSJi6RscEq1xvlGBVYSs6b5RxBZ+HFkfV0Sb9bZJn/Zpo3iOX1lJ2jM7Si
	Lg1hEFFQggvVVhqQsRSafzEmEbykKYS7KyrfrdiIdh5bV6d+GdRwxcY2qgoZne6IKameEav7uRF
	OQYvAxRnJtqR40KjasqV5tfpDOFVgccSOimWbbk9EbswlKbgfBzkJIIYPYqakhvEa7RM0
X-Google-Smtp-Source: AGHT+IHbkVL7EPb5KjicSw4KSoOokG99J04JG0lwtTo3UaOYe/evftUmF2hr4J/jh5vQhBOg6irmTg==
X-Received: by 2002:a17:903:1a03:b0:267:44e6:11d6 with SMTP id d9443c01a7336-29027e5d1efmr77364885ad.6.1759975135842;
        Wed, 08 Oct 2025 18:58:55 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:55 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 12/18] riscv: mm: Expose all page table bits to assembly code
Date: Wed,  8 Oct 2025 18:57:48 -0700
Message-ID: <20251009015839.3460231-13-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 15548C0003
X-Rspamd-Server: rspam02
X-Stat-Signature: 7ac9cyyxh9h7b77j5dg8zdubb6hpujfh
X-HE-Tag: 1759975136-297378
X-HE-Meta: U2FsdGVkX199WvU1qYnq4DQbqXSz9ihloTN/s57h/K6ZIXDgFchkUL0fplYzZKR4AbjCeW0WrfChNpkgjpmf1ufINsbpOhSyKjzCHYyO8MSoQBZ9RQHSwPsZZO3h1byAGGxytIvnALuId5PmesG0vYsP3KGVpNnGjh7KvwGLln+JTzF5a/Tx68/wZe5Twt/QQLM1ACwHB+t8Q1NJR445XS+YONGy1nOqvK/4ffrc/yn29vvmWAUBjYGk2KeB407vWJ3ddmOrxhd2l6PiZnXepaPbotXKkml/j7wQ/6VPW0ge8NGZENWGE1roHEbADO5kMv706cXkSBfuqPwjfKHYdIMywkra1tTmAytmxlIZi+3v2mDO+VMlLIjXCmA/ogzUxjN29AedUParqHup+NSliGtRp7+c7PewNdPimGNL44ZckJrdakLywU2tU8r0bJ1GS8DIoQ2N3mngHpBfmhBXy8/HHPZLeQGC2zm7h96WvPDQDKzLJGvNdxwjzyvL/6s4gC1dhRlnNNHD22l1QYs7yzZ2gnDULz0UFZVAG6RnZ3KsiaccpoCdCnRCqOyfm55tCBq6GndRPyEQ4Mxt8MPxvsRoV9mweOs8DdGOZI7rLODOsVaLmCIp6YkqdHGVUOmxqLno4HEK/7qcBQcGRAUP5uXuJDCE0M5VYcdVicBAUdo1je1zS12VDOvUgAMzmV8m5GqsVYsBg4Sztd2N39l/Z70AvaQbdCUdAoFFOSGO3SITAEHiv+I0HjTQo5HjLAsXN3BjrFDMy5p4QyJBgp0Dn2t1obZomUYPrMYPeFF0mfa/6Zt24xwflw9qPvu8xYqJme2RltmhpqFcULP5FjroMnQ1Uui1+KzHR5vvfWju/L+INMNhpFz8czLBJWwK4ZmnUhaeSLb5lik5+fua7orFrrzr7BRsCE57O/7tVuVgfMPUlJHRCo9ZnkTUKUzFvPf5zX5r1d8d5OCkdkLMYse
 +Tegdsjf
 APewqooaa8Q/fYLYLDJL3ughXhyTwppScbuNT4FtaGlbbflrrPz5FAFuC8nwi3gkM/C4LMWidP2Z0Q3lAqDCNe0qpRfJrwMXfE6EHPAmKqxOkFVXZDdYdl/AcPEyTs4fCIDKzYb2FyDKvtUfl2CXLMHIz+wPVmbEl0EEX6cqcxjdD6pnH8eKy4EVXa0nKr2bD5wb1uEUORr/grokvBP/EEJNBrRzbb7cCpXZbxqFGIQpI4JD2AyCs4j15xhagRvODSXqyFAcuMsaCDhZmgARdx/G/dRiQDGl10Q6DYUQ9VoXdmQXhAntEn/dqVQLy0FlEIU5iIsg+vlfxXVV9tDMxNTdd22jqtE/ubFIFp7pgzP4etkocIOKHWC95bvhaTFZr+UtItEvQI77sUFzpbraZlmW7sA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pgtable-32.h and pgtable-64.h are not usable by assembly code files, so
move all page table field definitions to pgtable-bits.h. This allows
handling more complex PTE transformations in out-of-line assembly code.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

(no changes since v1)

 arch/riscv/include/asm/pgtable-32.h   | 11 -------
 arch/riscv/include/asm/pgtable-64.h   | 30 -------------------
 arch/riscv/include/asm/pgtable-bits.h | 42 +++++++++++++++++++++++++--
 3 files changed, 40 insertions(+), 43 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable-32.h b/arch/riscv/include/asm/pgtable-32.h
index 90ef35a7c1a52..eb556ab95732d 100644
--- a/arch/riscv/include/asm/pgtable-32.h
+++ b/arch/riscv/include/asm/pgtable-32.h
@@ -17,17 +17,6 @@
 
 #define MAX_POSSIBLE_PHYSMEM_BITS 34
 
-/*
- * rv32 PTE format:
- * | XLEN-1  10 | 9             8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
- *       PFN      reserved for SW   D   A   G   U   X   W   R   V
- */
-#define _PAGE_PFN_MASK  GENMASK(31, 10)
-
-#define _PAGE_NOCACHE		0
-#define _PAGE_IO		0
-#define _PAGE_MTMASK		0
-
 #define ALT_FIXUP_MT(_val)
 #define ALT_UNFIX_MT(_val)
 
diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index 5531752b608e4..60c2615e46724 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -68,20 +68,6 @@ typedef struct {
 #define __pmd(x)        ((pmd_t) { (x) })
 #define PTRS_PER_PMD    (PAGE_SIZE / sizeof(pmd_t))
 
-/*
- * rv64 PTE format:
- * | 63 | 62 61 | 60 54 | 53  10 | 9             8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
- *   N      MT     RSV    PFN      reserved for SW   D   A   G   U   X   W   R   V
- */
-#define _PAGE_PFN_MASK  GENMASK(53, 10)
-
-/*
- * [63] Svnapot definitions:
- * 0 Svnapot disabled
- * 1 Svnapot enabled
- */
-#define _PAGE_NAPOT_SHIFT	63
-#define _PAGE_NAPOT		BIT(_PAGE_NAPOT_SHIFT)
 /*
  * Only 64KB (order 4) napot ptes supported.
  */
@@ -111,18 +97,6 @@ enum napot_cont_order {
 
 #if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
 
-/*
- * [62:61] Svpbmt Memory Type definitions:
- *
- *  00 - PMA    Normal Cacheable, No change to implied PMA memory type
- *  01 - NC     Non-cacheable, idempotent, weakly-ordered Main Memory
- *  10 - IO     Non-cacheable, non-idempotent, strongly-ordered I/O memory
- *  11 - Rsvd   Reserved for future standard use
- */
-#define _PAGE_NOCACHE		(1UL << 61)
-#define _PAGE_IO		(2UL << 61)
-#define _PAGE_MTMASK		(3UL << 61)
-
 /*
  * ALT_FIXUP_MT
  *
@@ -174,10 +148,6 @@ enum napot_cont_order {
 
 #else
 
-#define _PAGE_NOCACHE		0
-#define _PAGE_IO		0
-#define _PAGE_MTMASK		0
-
 #define ALT_FIXUP_MT(_val)
 
 #endif /* CONFIG_RISCV_ISA_SVPBMT || CONFIG_ERRATA_THEAD_MAE */
diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm/pgtable-bits.h
index 179bd4afece46..18c50cbd78bf5 100644
--- a/arch/riscv/include/asm/pgtable-bits.h
+++ b/arch/riscv/include/asm/pgtable-bits.h
@@ -6,6 +6,16 @@
 #ifndef _ASM_RISCV_PGTABLE_BITS_H
 #define _ASM_RISCV_PGTABLE_BITS_H
 
+/*
+ * rv32 PTE format:
+ * | XLEN-1  10 | 9             8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
+ *       PFN      reserved for SW   D   A   G   U   X   W   R   V
+ *
+ * rv64 PTE format:
+ * | 63 | 62 61 | 60 54 | 53 10 | 9             8 | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
+ *   N      MT     RSV     PFN    reserved for SW   D   A   G   U   X   W   R   V
+ */
+
 #define _PAGE_ACCESSED_OFFSET 6
 
 #define _PAGE_PRESENT   (1 << 0)
@@ -21,6 +31,36 @@
 #define _PAGE_SPECIAL   (1 << 8)    /* RSW: 0x1 */
 #define _PAGE_TABLE     _PAGE_PRESENT
 
+#define _PAGE_PFN_SHIFT		10
+#ifdef CONFIG_64BIT
+#define _PAGE_PFN_MASK		GENMASK(53, 10)
+#else
+#define _PAGE_PFN_MASK		GENMASK(31, 10)
+#endif /* CONFIG_64BIT */
+
+#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
+/*
+ * [62:61] Svpbmt Memory Type definitions:
+ *
+ *  00 - PMA    Normal Cacheable, No change to implied PMA memory type
+ *  01 - NC     Non-cacheable, idempotent, weakly-ordered Main Memory
+ *  10 - IO     Non-cacheable, non-idempotent, strongly-ordered I/O memory
+ *  11 - Rsvd   Reserved for future standard use
+ */
+#define _PAGE_NOCACHE		(UL(1) << 61)
+#define _PAGE_IO		(UL(2) << 61)
+#define _PAGE_MTMASK		(UL(3) << 61)
+#else
+#define _PAGE_NOCACHE		0
+#define _PAGE_IO		0
+#define _PAGE_MTMASK		0
+#endif /* CONFIG_RISCV_ISA_SVPBMT || CONFIG_ERRATA_THEAD_MAE */
+
+#ifdef CONFIG_RISCV_ISA_SVNAPOT
+#define _PAGE_NAPOT_SHIFT	63
+#define _PAGE_NAPOT		BIT(_PAGE_NAPOT_SHIFT)
+#endif /* CONFIG_RISCV_ISA_SVNAPOT */
+
 /*
  * _PAGE_PROT_NONE is set on not-present pages (and ignored by the hardware) to
  * distinguish them from swapped out pages
@@ -30,8 +70,6 @@
 /* Used for swap PTEs only. */
 #define _PAGE_SWP_EXCLUSIVE _PAGE_ACCESSED
 
-#define _PAGE_PFN_SHIFT 10
-
 /*
  * when all of R/W/X are zero, the PTE is a pointer to the next level
  * of the page table; otherwise, it is a leaf PTE.
-- 
2.47.2


