Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27300C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 19:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2E56B009F; Tue,  5 Aug 2025 15:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62F26B00A0; Tue,  5 Aug 2025 15:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A03CF6B00A1; Tue,  5 Aug 2025 15:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C67D6B009F
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:40:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 421BB1A01FA
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:03 +0000 (UTC)
X-FDA: 83743719486.21.E47FE7F
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 53A7D20005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=RYOfdrYL;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=jesse@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754422801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9TqRmdHx0+XIdlIKQiKbhA+RODUHyjjv/NDNl/D8gI=;
	b=VxVqKxIEs+PbIO1IKaSzcBzZPF+mmRl2mQObGhaPk9x5qiZDD2QjlxzhTSsXtzgua4tExV
	Gci/7jR40FFzhpeaj6Ov3K7V0tfhKEBamR9Bz64/NL5gptPd/Ly+ny406U+QNn1qTsNVz0
	KC1xrVy05gDQeKX5jiuhVsex5F3PsnU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754422801; a=rsa-sha256;
	cv=none;
	b=QyjHCyUEY3q1BD3mVWmj6lMZ022DLMD2btXHwPNHIVXDht1CWeRdCw3tw1P7SkH+FHhhtB
	1bxSk0WhsXbrLusxs5PFQIvDpwdhCxl28zzW65AImsZDi7ds67mYXJTBjxxY9f9LAoNfdJ
	9ItyVu+InRkiWORh3WMUr6xkPaGiUQ0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=RYOfdrYL;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=jesse@rivosinc.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7e62a1cbf82so297450185a.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 12:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1754422800; x=1755027600; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9TqRmdHx0+XIdlIKQiKbhA+RODUHyjjv/NDNl/D8gI=;
        b=RYOfdrYLJScmv0uzuqoUX9pZ9EB+oCDIF6b6joYebsmoIEtiXjzeB3dEh8JgKJ5Mor
         Ai9pNAX5B9ILwEzQXQVEMF6wSPjaYjmDgHCZa2k9niSiAQqklJ//L4SWuOU8vOZdZHgC
         Whk7mU9fNJERGAzRb3Llcw/F9PoIxJt7mx/JUG1G4MLjPbLT5Vv8fwqFtJ8KKPerPAaM
         tP7++bUtOkFKpgakdKpOx68x947KzXKtopxan8z46Y9SxSoz2xyoNuowscxv3G3z6ZP+
         9iUW9vxMAI6BeSC+wp1nBzwCBV/W4lZJ8wVfmJJ41nyBUDkLeMVDcp5Wch2EsIjAQAG8
         dX/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754422800; x=1755027600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C9TqRmdHx0+XIdlIKQiKbhA+RODUHyjjv/NDNl/D8gI=;
        b=Id4zGpxzd254jPnUTr316lHREpAJgtDpS43Dvugyiv7iVY32BTTbnSSak/JVHNj+fD
         cm5p7Dd27eAvwFqp6LEPDdClaEY5DsmeFPUt4s3t0pZWbN0p6QBR+4M/ODAFJsKWe28q
         rshaFEf7sQM68QCbyMp7PYYstlUn23zKKAjI57nno49wxrn/nKfLWgfqZzCdxNCyrTuq
         nCsfDGU4Njy0wav/Ycvf4PlXowRk5R1dNJwNUjYIyDeYbwp8Zw8QAFbRkbC2X5g5zb6h
         xB6k7IFobILCjpayIdudPay0dXhSRILrrGYFYqbW0JN10N7e0Jxp6E2cus/pgnflWw53
         U2nQ==
X-Forwarded-Encrypted: i=1; AJvYcCVupnGwng6DeVXmptvZ0gXheGT4uNG+K3dnTfzec64OrWzuUlgIw+4B4kU+O2NGTaoGZjiVjbZezA==@kvack.org
X-Gm-Message-State: AOJu0YzmWZwElKnCRdWmh9JnVkYRX4/vQ4ggGD8Bd7G2gHI7NEhT/vtj
	aLZNDrxlRUbIsxDYZAaL3TDbJWO0xSoLZboJX12tCwYjGeWUp88oYMET1gHEjJooiYY=
X-Gm-Gg: ASbGncvfVplTiIkxHnJdkoClDQ9fWuz89W9Bm0pq0ZRFewUh6VvnKXHJip5xPGkIefe
	kQdCjdixEEiHOtX8S+bKL25duZWR5GyVuYhmbQJiZ/htihMt88T1DNhTHMnB1ZdaV7bicGQL1Ib
	ltoNAuLh+gamqdpOlYBWLR0rrwPOnH/0ZzrtULn0jDluyPdvuH824MWbPr30UlvSbPJdKpGfESB
	jzc1FuR/C1uOwKGkXY6/Wqy6nVdtCrMiGkeqDV146vlpjCYw2Q3eqOaimfm4+x41U9rbbYR/Dq4
	pn3ufnj1Pxi2bXP4gh5x14yq0QzOt5HiVe9gCzY96J9PmZunKE/emq3BLPgYvbCrOy8qdCXwgx2
	aGpv5t8yxvl7H8eDDWD2Dby7GIZ05c2WymQWMKjqGSiSHaPQjcY0XVl20VzSaTYraD39fBtwm/x
	t3b7XbZL8tB4U0L3/V
X-Google-Smtp-Source: AGHT+IEzHnlXMLFLFH7ARBb94c6v3DpzHk5tOCrNEnPmOxJKtABtAWgi9vM+SApe2NKHi7ctYrnBfg==
X-Received: by 2002:a05:620a:a50a:b0:7e6:87fc:54b1 with SMTP id af79cd13be357-7e814e17d1cmr77758785a.66.1754422800100;
        Tue, 05 Aug 2025 12:40:00 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f7064b0sm717855685a.54.2025.08.05.12.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 12:39:59 -0700 (PDT)
From: Jesse Taube <jesse@rivosinc.com>
To: linux-riscv@lists.infradead.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Oleg Nesterov <oleg@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Jesse Taube <jesse@rivosinc.com>,
	Himanshu Chauhan <hchauhan@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley  <conor.dooley@microchip.com>,
	Deepak Gupta  <debug@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	Evan Green <evan@rivosinc.com>,
	WangYuli <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Joel Granados <joel.granados@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Celeste Liu <coelacanthushex@gmail.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Nylon Chen <nylon.chen@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 1/8] riscv: Add insn.c, consolidate instruction decoding
Date: Tue,  5 Aug 2025 12:39:48 -0700
Message-ID: <20250805193955.798277-2-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250805193955.798277-1-jesse@rivosinc.com>
References: <20250805193955.798277-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 53A7D20005
X-Stat-Signature: pi4sexugq1zze1radathsf1et1zagw5x
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754422801-599244
X-HE-Meta: U2FsdGVkX18AvQn0WihUjL53PLlqH13NOe0mBxn6BN7wUuxm4k5w605FyNj/8yEosb73bP61GU3SDAypbHOgF8Tnk1FBLPSbMIjWiGMhs9dmHwHr2i0PbZVLakI6ozTYILs6hiW0A8s/a/cV6CnJyYND0Oegewssn1Cz/Zfl7mrjfoGsYFplYq3iZ/+9g/ySQ5OIBWeT5ExMwaucCRWLgHnQceEKpX62yXAjtX9sIcd206clhBBo+NyFFtbLgBhTbLKjWB8A8fgI7REz+S1SvA0wnkv3mFhKWz/NSpr8bsIwCwGHLfd29y25eRsgprz52X88M9EwoS2espCm73UCx/KiYn2aYpjC/+mocevzkobIw/tok3CBYD5AuP4W59nOXzNDDC1WHxlUFDF7WTuFRVpwW4hMS6y6OxkHsX9L4yDxo2Pegz50TpxhnMD4MjimLaNk9OWo/4gbju1W7g52YOtXNTn5PupcEqzhUp/1uDbP7E4RB4EXkqjl/ak0RpAqxnwj5a9WqOnUh4Lxu/NPFiMEoR3UO+ko7zEHNyuT64tS7MoQ91LRqsfum6vFJ6SzexA7TU2HveyTLAFD2wPxThF1ASed2HPTEXInQ473ojsmGvllTXBIjIeFpmj/uJ2A+xlO9Di+pBp+fl1ZjXuJxhmDsWnv0ihLPNyu4OwobufAvKQqXdWafQE7oGYMXF8ZOfad6YtkV0HH6Sx9+BpqZw5sG+q2hNL2XeKdOdAakICGWaT1nUokSWOPLk5gplNqOijde+Nl//4nytW8iSr1JtxozIG+9oR0oazzr7AuVHtNjVLIYs/cm8UnWEYWS6ZJlVp4a3DibIgQF4Yknett6AgUtM1JadoCWxMzbDYSHXgk+81fcwNSK3EKt8m8yqMlE4McOCMRKL+AKygxp/zZ3oNxclBWRtIvoZ8z3Ct7QDMcOEYMrgKCQYlHyj0GrMg6ntH+slyp4qnZ8KPUuWH
 c0qd32/0
 DaIzi0qTXjeN9i/2pVfusu5HD/LBthpDEhq87A9P6IsOHEyUsCwqftFhMRUCdvXYoCgIJQu50lmxaftk0Q6nDgjVkKhqn/8uAsUy/8mZps0trLojRE4IzWJWnmCOmxHCfirXPD4ovHGxVZXd1ced8n3fVBj3EJee+SzjcnSPHPf+x4h6Jfs0/1mjuB+wNtWtookFJ2YU0dvk+BW2GoG6wsuhKWNzZQht/koMO8ZSzSQGX/RTtgir9q1dX3hsFvjlJj3oMtwzV02aOM1cYxxoNMpwllGqqEORQwsfC2OSFVl/IR3AkJAQtbB3chQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Various parts of the kernel decode and read instruction from memory.
Functions like get_insn, GET_INSN_LENGTH and riscv_insn_is_c are defined
in multiple places. Consolidate these functions into the insn.h and the
newly added insn.c.

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
RFC -> V1:
 - No change
---
 arch/riscv/include/asm/bug.h         |  12 ---
 arch/riscv/include/asm/insn.h        | 131 ++++++++++++++++++++++-
 arch/riscv/kernel/Makefile           |   1 +
 arch/riscv/kernel/insn.c             | 151 +++++++++++++++++++++++++++
 arch/riscv/kernel/kgdb.c             | 102 +-----------------
 arch/riscv/kernel/probes/kprobes.c   |   1 +
 arch/riscv/kernel/traps.c            |   5 +-
 arch/riscv/kernel/traps_misaligned.c |  93 ++++-------------
 8 files changed, 309 insertions(+), 187 deletions(-)
 create mode 100644 arch/riscv/kernel/insn.c

diff --git a/arch/riscv/include/asm/bug.h b/arch/riscv/include/asm/bug.h
index 1aaea81fb141..a2777eb67ad1 100644
--- a/arch/riscv/include/asm/bug.h
+++ b/arch/riscv/include/asm/bug.h
@@ -12,21 +12,9 @@
 
 #include <asm/asm.h>
 
-#define __INSN_LENGTH_MASK  _UL(0x3)
-#define __INSN_LENGTH_32    _UL(0x3)
-#define __COMPRESSED_INSN_MASK	_UL(0xffff)
-
 #define __BUG_INSN_32	_UL(0x00100073) /* ebreak */
 #define __BUG_INSN_16	_UL(0x9002) /* c.ebreak */
 
-#define GET_INSN_LENGTH(insn)						\
-({									\
-	unsigned long __len;						\
-	__len = ((insn & __INSN_LENGTH_MASK) == __INSN_LENGTH_32) ?	\
-		4UL : 2UL;						\
-	__len;								\
-})
-
 typedef u32 bug_insn_t;
 
 #ifdef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
index 09fde95a5e8f..ba74e5b8262c 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -64,6 +64,7 @@
 #define RVG_RS2_OPOFF		20
 #define RVG_RD_OPOFF		7
 #define RVG_RS1_MASK		GENMASK(4, 0)
+#define RVG_RS2_MASK		GENMASK(4, 0)
 #define RVG_RD_MASK		GENMASK(4, 0)
 
 /* The bit field of immediate value in RVC J instruction */
@@ -121,17 +122,27 @@
 #define RVC_C0_RS1_OPOFF	7
 #define RVC_C0_RS2_OPOFF	2
 #define RVC_C0_RD_OPOFF		2
+#define RVC_C0_RS1_MASK		GENMASK(2, 0)
+#define RVC_C0_RS2_MASK		GENMASK(2, 0)
+#define RVC_C0_RD_MASK		GENMASK(2, 0)
+#define RVC_C0_REG_OFFSET	8
 
 /* The register offset in RVC op=C1 instruction */
 #define RVC_C1_RS1_OPOFF	7
 #define RVC_C1_RS2_OPOFF	2
 #define RVC_C1_RD_OPOFF		7
+#define RVC_C1_RS1_MASK		GENMASK(2, 0)
+#define RVC_C1_RS2_MASK		GENMASK(2, 0)
+#define RVC_C1_RD_MASK		GENMASK(2, 0)
+#define RVC_C1_REG_OFFSET	8
 
 /* The register offset in RVC op=C2 instruction */
 #define RVC_C2_RS1_OPOFF	7
 #define RVC_C2_RS2_OPOFF	2
 #define RVC_C2_RD_OPOFF		7
 #define RVC_C2_RS1_MASK		GENMASK(4, 0)
+#define RVC_C2_RS2_MASK		GENMASK(4, 0)
+#define RVC_C2_RD_MASK		GENMASK(4, 0)
 
 /* parts of opcode for RVG*/
 #define RVG_OPCODE_FENCE	0x0f
@@ -226,12 +237,26 @@
 #define RVC_MASK_C_EBREAK	0xffff
 #define RVG_MASK_EBREAK		0xffffffff
 #define RVG_MASK_SRET		0xffffffff
+#define RVC_MASK_C		GENMASK(15, 0)
 
 #define __INSN_LENGTH_MASK	_UL(0x3)
 #define __INSN_LENGTH_GE_32	_UL(0x3)
 #define __INSN_OPCODE_MASK	_UL(0x7F)
 #define __INSN_BRANCH_OPCODE	_UL(RVG_OPCODE_BRANCH)
 
+#define GET_INSN_LENGTH(insn)						\
+({									\
+	unsigned long __len;						\
+	__len = ((insn & __INSN_LENGTH_MASK) == __INSN_LENGTH_GE_32) ?	\
+		4UL : 2UL;						\
+	__len;								\
+})
+
+static __always_inline bool riscv_insn_is_c(u32 code)
+{
+	return (code & (__INSN_LENGTH_MASK)) != (__INSN_LENGTH_GE_32);
+}
+
 #define __RISCV_INSN_FUNCS(name, mask, val)				\
 static __always_inline bool riscv_insn_is_##name(u32 code)		\
 {									\
@@ -260,7 +285,7 @@ __RISCV_INSN_FUNCS(c_bnez, RVC_MASK_C_BNEZ, RVC_MATCH_C_BNEZ)
 __RISCV_INSN_FUNCS(c_ebreak, RVC_MASK_C_EBREAK, RVC_MATCH_C_EBREAK)
 __RISCV_INSN_FUNCS(ebreak, RVG_MASK_EBREAK, RVG_MATCH_EBREAK)
 __RISCV_INSN_FUNCS(sret, RVG_MASK_SRET, RVG_MATCH_SRET)
-__RISCV_INSN_FUNCS(fence, RVG_MASK_FENCE, RVG_MATCH_FENCE);
+__RISCV_INSN_FUNCS(fence, RVG_MASK_FENCE, RVG_MATCH_FENCE)
 
 /* special case to catch _any_ system instruction */
 static __always_inline bool riscv_insn_is_system(u32 code)
@@ -295,6 +320,10 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
 	({typeof(x) x_ = (x); \
 	(RV_X(x_, RVG_RS1_OPOFF, RVG_RS1_MASK)); })
 
+#define RV_EXTRACT_RS2_REG(x) \
+	({typeof(x) x_ = (x); \
+	(RV_X(x_, RVG_RS2_OPOFF, RVG_RS2_MASK)); })
+
 #define RV_EXTRACT_RD_REG(x) \
 	({typeof(x) x_ = (x); \
 	(RV_X(x_, RVG_RD_OPOFF, RVG_RD_MASK)); })
@@ -322,9 +351,41 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
 	(RV_X(x_, RV_B_IMM_11_OPOFF, RV_B_IMM_11_MASK) << RV_B_IMM_11_OFF) | \
 	(RV_IMM_SIGN(x_) << RV_B_IMM_SIGN_OFF); })
 
+#define RVC_EXTRACT_C0_RS1_REG(x) \
+	({typeof(x) x_ = (x); \
+	(RVC_X(x_, RVC_C0_RS1_OPOFF, RVC_C0_RS1_MASK)); })
+
+#define RVC_EXTRACT_C0_RS2_REG(x) \
+	({typeof(x) x_ = (x); \
+	(RVC_X(x_, RVC_C0_RS2_OPOFF, RVC_C0_RS2_MASK)); })
+
+#define RVC_EXTRACT_C0_RD_REG(x) \
+	({typeof(x) x_ = (x); \
+	(RVC_X(x_, RVC_C0_RD_OPOFF, RVC_C0_RD_MASK)); })
+
+#define RVC_EXTRACT_C1_RS1_REG(x) \
+	({typeof(x) x_ = (x); \
+	(RVC_X(x_, RVC_C1_RS1_OPOFF, RVC_C1_RS1_MASK)); })
+
+#define RVC_EXTRACT_C1_RS2_REG(x) \
+	({typeof(x) x_ = (x); \
+	(RVC_X(x_, RVC_C1_RS2_OPOFF, RVC_C1_RS2_MASK)); })
+
+#define RVC_EXTRACT_C1_RD_REG(x) \
+	({typeof(x) x_ = (x); \
+	(RVC_X(x_, RVC_C1_RD_OPOFF, RVC_C1_RD_MASK)); })
+
 #define RVC_EXTRACT_C2_RS1_REG(x) \
 	({typeof(x) x_ = (x); \
-	(RV_X(x_, RVC_C2_RS1_OPOFF, RVC_C2_RS1_MASK)); })
+	(RVC_X(x_, RVC_C2_RS1_OPOFF, RVC_C2_RS1_MASK)); })
+
+#define RVC_EXTRACT_C2_RS2_REG(x) \
+	({typeof(x) x_ = (x); \
+	(RVC_X(x_, RVC_C2_RS2_OPOFF, RVC_C2_RS2_MASK)); })
+
+#define RVC_EXTRACT_C2_RD_REG(x) \
+	({typeof(x) x_ = (x); \
+	(RVC_X(x_, RVC_C2_RD_OPOFF, RVC_C2_RD_MASK)); })
 
 #define RVC_EXTRACT_JTYPE_IMM(x) \
 	({typeof(x) x_ = (x); \
@@ -354,6 +415,66 @@ static __always_inline bool riscv_insn_is_c_jalr(u32 code)
 
 #define RVV_EXRACT_VL_VS_WIDTH(x) RVFDQ_EXTRACT_FL_FS_WIDTH(x)
 
+/*
+ * Get the rs1 register number from RV or RVC instruction.
+ *
+ * @insn: instruction to process
+ * Return: rs1 register
+ */
+static inline unsigned int riscv_insn_extract_rs1_reg(u32 insn)
+{
+	switch (RVC_INSN_OPCODE_MASK & insn) {
+	case RVC_OPCODE_C0:
+		return RVC_EXTRACT_C0_RS1_REG(insn) + RVC_C0_REG_OFFSET;
+	case RVC_OPCODE_C1:
+		return RVC_EXTRACT_C1_RS1_REG(insn) + RVC_C1_REG_OFFSET;
+	case RVC_OPCODE_C2:
+		return RVC_EXTRACT_C2_RS1_REG(insn);
+	default:
+		return RV_EXTRACT_RS1_REG(insn);
+	}
+}
+
+/*
+ * Get the rs2 register number from RV or RVC instruction.
+ *
+ * @insn: instruction to process
+ * Return: rs2 register
+ */
+static inline unsigned int riscv_insn_extract_rs2_reg(u32 insn)
+{
+	switch (RVC_INSN_OPCODE_MASK & insn) {
+	case RVC_OPCODE_C0:
+		return RVC_EXTRACT_C0_RS2_REG(insn) + RVC_C0_REG_OFFSET;
+	case RVC_OPCODE_C1:
+		return RVC_EXTRACT_C1_RS2_REG(insn) + RVC_C1_REG_OFFSET;
+	case RVC_OPCODE_C2:
+		return RVC_EXTRACT_C2_RS2_REG(insn);
+	default:
+		return RV_EXTRACT_RS2_REG(insn);
+	}
+}
+
+/*
+ * Get the rd register number from RV or RVC instruction.
+ *
+ * @insn: instruction to process
+ * Return: rd register
+ */
+static inline unsigned int riscv_insn_extract_rd_reg(u32 insn)
+{
+	switch (RVC_INSN_OPCODE_MASK & insn) {
+	case RVC_OPCODE_C0:
+		return RVC_EXTRACT_C0_RD_REG(insn) + RVC_C0_REG_OFFSET;
+	case RVC_OPCODE_C1:
+		return RVC_EXTRACT_C1_RD_REG(insn) + RVC_C1_REG_OFFSET;
+	case RVC_OPCODE_C2:
+		return RVC_EXTRACT_C2_RD_REG(insn);
+	default:
+		return RV_EXTRACT_RD_REG(insn);
+	}
+}
+
 /*
  * Get the immediate from a J-type instruction.
  *
@@ -428,4 +549,10 @@ static inline void riscv_insn_insert_utype_itype_imm(u32 *utype_insn, u32 *itype
 	*utype_insn |= (imm & RV_U_IMM_31_12_MASK) + ((imm & BIT(11)) << 1);
 	*itype_insn |= ((imm & RV_I_IMM_11_0_MASK) << RV_I_IMM_11_0_OPOFF);
 }
+
+#include <asm/ptrace.h>
+
+int get_insn(struct pt_regs *regs, ulong epc, ulong *r_insn);
+unsigned long get_step_address(struct pt_regs *regs, u32 code);
+
 #endif /* _ASM_RISCV_INSN_H */
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index f7480c9c6f8d..4f719b09e5ad 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_RISCV_ALTERNATIVE) += alternative.o
 obj-y	+= cpu.o
 obj-y	+= cpufeature.o
 obj-y	+= entry.o
+obj-y	+= insn.o
 obj-y	+= irq.o
 obj-y	+= process.o
 obj-y	+= ptrace.o
diff --git a/arch/riscv/kernel/insn.c b/arch/riscv/kernel/insn.c
new file mode 100644
index 000000000000..dd2a6ef9fd25
--- /dev/null
+++ b/arch/riscv/kernel/insn.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2025 Rivos, Inc
+ */
+#include <asm/insn.h>
+#include <asm/ptrace.h>
+#include <asm/uaccess.h>
+
+#define __read_insn(regs, insn, insn_addr, type)	\
+({							\
+	int __ret;					\
+							\
+	if (user_mode(regs)) {				\
+		__ret = get_user(insn, (type __user *) insn_addr); \
+	} else {					\
+		insn = *(type *)insn_addr;		\
+		__ret = 0;				\
+	}						\
+							\
+	__ret;						\
+})
+
+/*
+ * Update a set of two instructions (U-type + I-type) with an immediate value.
+ *
+ * Used for example in auipc+jalrs pairs the U-type instructions contains
+ * a 20bit upper immediate representing bits[31:12], while the I-type
+ * instruction contains a 12bit immediate representing bits[11:0].
+ *
+ * This also takes into account that both separate immediates are
+ * considered as signed values, so if the I-type immediate becomes
+ * negative (BIT(11) set) the U-type part gets adjusted.
+ *
+ * @regs: pointer to the utype instruction of the pair
+ * @epc: pointer to the itype instruction of the pair
+ * @r_insn: the immediate to insert into the two instructions
+ * Return: combined immediate
+ */
+int get_insn(struct pt_regs *regs, ulong epc, ulong *r_insn)
+{
+	ulong insn = 0;
+
+	if (epc & 0x2) {
+		ulong tmp = 0;
+
+		if (__read_insn(regs, insn, epc, u16))
+			return -EFAULT;
+		/* __get_user() uses regular "lw" which sign extend the loaded
+		 * value make sure to clear higher order bits in case we "or" it
+		 * below with the upper 16 bits half.
+		 */
+		insn &= RVC_MASK_C;
+		if (riscv_insn_is_c(insn)) {
+			*r_insn = insn;
+			return 0;
+		}
+		epc += sizeof(u16);
+		if (__read_insn(regs, tmp, epc, u16))
+			return -EFAULT;
+		*r_insn = (tmp << 16) | insn;
+
+		return 0;
+	} else {
+		if (__read_insn(regs, insn, epc, u32))
+			return -EFAULT;
+		if (!riscv_insn_is_c(insn)) {
+			*r_insn = insn;
+			return 0;
+		}
+		insn &= RVC_MASK_C;
+		*r_insn = insn;
+
+		return 0;
+	}
+}
+
+/* Calculate the new address for after a step */
+unsigned long get_step_address(struct pt_regs *regs, u32 code)
+{
+	unsigned long pc = regs->epc;
+	unsigned int rs1_num, rs2_num;
+
+	if ((code & __INSN_LENGTH_MASK) != __INSN_LENGTH_GE_32) {
+		if (riscv_insn_is_c_jalr(code) ||
+		    riscv_insn_is_c_jr(code)) {
+			rs1_num = riscv_insn_extract_rs1_reg(code);
+			return regs_get_register(regs, rs1_num);
+		} else if (riscv_insn_is_c_j(code) ||
+			   riscv_insn_is_c_jal(code)) {
+			return RVC_EXTRACT_JTYPE_IMM(code) + pc;
+		} else if (riscv_insn_is_c_beqz(code)) {
+			rs1_num = riscv_insn_extract_rs1_reg(code);
+			if (!rs1_num || regs_get_register(regs, rs1_num) == 0)
+				return RVC_EXTRACT_BTYPE_IMM(code) + pc;
+			else
+				return pc + 2;
+		} else if (riscv_insn_is_c_bnez(code)) {
+			rs1_num = riscv_insn_extract_rs1_reg(RVC_C1_RS1_OPOFF);
+			if (rs1_num && regs_get_register(regs, rs1_num) != 0)
+				return RVC_EXTRACT_BTYPE_IMM(code) + pc;
+			else
+				return pc + 2;
+		} else {
+			return pc + 2;
+		}
+	} else {
+		if ((code & __INSN_OPCODE_MASK) == __INSN_BRANCH_OPCODE) {
+			bool result = false;
+			long imm = RV_EXTRACT_BTYPE_IMM(code);
+			unsigned long rs1_val = 0, rs2_val = 0;
+
+			rs1_num = riscv_insn_extract_rs1_reg(code);
+			rs2_num = riscv_insn_extract_rs2_reg(code);
+			if (rs1_num)
+				rs1_val = regs_get_register(regs, rs1_num);
+			if (rs2_num)
+				rs2_val = regs_get_register(regs, rs2_num);
+
+			if (riscv_insn_is_beq(code))
+				result = (rs1_val == rs2_val) ? true : false;
+			else if (riscv_insn_is_bne(code))
+				result = (rs1_val != rs2_val) ? true : false;
+			else if (riscv_insn_is_blt(code))
+				result =
+				    ((long)rs1_val <
+				     (long)rs2_val) ? true : false;
+			else if (riscv_insn_is_bge(code))
+				result =
+				    ((long)rs1_val >=
+				     (long)rs2_val) ? true : false;
+			else if (riscv_insn_is_bltu(code))
+				result = (rs1_val < rs2_val) ? true : false;
+			else if (riscv_insn_is_bgeu(code))
+				result = (rs1_val >= rs2_val) ? true : false;
+			if (result)
+				return imm + pc;
+			else
+				return pc + 4;
+		} else if (riscv_insn_is_jal(code)) {
+			return RV_EXTRACT_JTYPE_IMM(code) + pc;
+		} else if (riscv_insn_is_jalr(code)) {
+			rs1_num = riscv_insn_extract_rs1_reg(code);
+			return RV_EXTRACT_ITYPE_IMM(code) +
+			       (rs1_num ? regs_get_register(regs, rs1_num) : 0);
+		} else if (riscv_insn_is_sret(code)) {
+			return pc;
+		} else {
+			return pc + 4;
+		}
+	}
+}
diff --git a/arch/riscv/kernel/kgdb.c b/arch/riscv/kernel/kgdb.c
index 9f3db3503dab..aafc1424fc81 100644
--- a/arch/riscv/kernel/kgdb.c
+++ b/arch/riscv/kernel/kgdb.c
@@ -23,111 +23,19 @@ enum {
 static unsigned long stepped_address;
 static unsigned int stepped_opcode;
 
-static int decode_register_index(unsigned long opcode, int offset)
-{
-	return (opcode >> offset) & 0x1F;
-}
-
-static int decode_register_index_short(unsigned long opcode, int offset)
-{
-	return ((opcode >> offset) & 0x7) + 8;
-}
-
-/* Calculate the new address for after a step */
-static int get_step_address(struct pt_regs *regs, unsigned long *next_addr)
-{
-	unsigned long pc = regs->epc;
-	unsigned long *regs_ptr = (unsigned long *)regs;
-	unsigned int rs1_num, rs2_num;
-	int op_code;
-
-	if (get_kernel_nofault(op_code, (void *)pc))
-		return -EINVAL;
-	if ((op_code & __INSN_LENGTH_MASK) != __INSN_LENGTH_GE_32) {
-		if (riscv_insn_is_c_jalr(op_code) ||
-		    riscv_insn_is_c_jr(op_code)) {
-			rs1_num = decode_register_index(op_code, RVC_C2_RS1_OPOFF);
-			*next_addr = regs_ptr[rs1_num];
-		} else if (riscv_insn_is_c_j(op_code) ||
-			   riscv_insn_is_c_jal(op_code)) {
-			*next_addr = RVC_EXTRACT_JTYPE_IMM(op_code) + pc;
-		} else if (riscv_insn_is_c_beqz(op_code)) {
-			rs1_num = decode_register_index_short(op_code,
-							      RVC_C1_RS1_OPOFF);
-			if (!rs1_num || regs_ptr[rs1_num] == 0)
-				*next_addr = RVC_EXTRACT_BTYPE_IMM(op_code) + pc;
-			else
-				*next_addr = pc + 2;
-		} else if (riscv_insn_is_c_bnez(op_code)) {
-			rs1_num =
-			    decode_register_index_short(op_code, RVC_C1_RS1_OPOFF);
-			if (rs1_num && regs_ptr[rs1_num] != 0)
-				*next_addr = RVC_EXTRACT_BTYPE_IMM(op_code) + pc;
-			else
-				*next_addr = pc + 2;
-		} else {
-			*next_addr = pc + 2;
-		}
-	} else {
-		if ((op_code & __INSN_OPCODE_MASK) == __INSN_BRANCH_OPCODE) {
-			bool result = false;
-			long imm = RV_EXTRACT_BTYPE_IMM(op_code);
-			unsigned long rs1_val = 0, rs2_val = 0;
-
-			rs1_num = decode_register_index(op_code, RVG_RS1_OPOFF);
-			rs2_num = decode_register_index(op_code, RVG_RS2_OPOFF);
-			if (rs1_num)
-				rs1_val = regs_ptr[rs1_num];
-			if (rs2_num)
-				rs2_val = regs_ptr[rs2_num];
-
-			if (riscv_insn_is_beq(op_code))
-				result = (rs1_val == rs2_val) ? true : false;
-			else if (riscv_insn_is_bne(op_code))
-				result = (rs1_val != rs2_val) ? true : false;
-			else if (riscv_insn_is_blt(op_code))
-				result =
-				    ((long)rs1_val <
-				     (long)rs2_val) ? true : false;
-			else if (riscv_insn_is_bge(op_code))
-				result =
-				    ((long)rs1_val >=
-				     (long)rs2_val) ? true : false;
-			else if (riscv_insn_is_bltu(op_code))
-				result = (rs1_val < rs2_val) ? true : false;
-			else if (riscv_insn_is_bgeu(op_code))
-				result = (rs1_val >= rs2_val) ? true : false;
-			if (result)
-				*next_addr = imm + pc;
-			else
-				*next_addr = pc + 4;
-		} else if (riscv_insn_is_jal(op_code)) {
-			*next_addr = RV_EXTRACT_JTYPE_IMM(op_code) + pc;
-		} else if (riscv_insn_is_jalr(op_code)) {
-			rs1_num = decode_register_index(op_code, RVG_RS1_OPOFF);
-			if (rs1_num)
-				*next_addr = ((unsigned long *)regs)[rs1_num];
-			*next_addr += RV_EXTRACT_ITYPE_IMM(op_code);
-		} else if (riscv_insn_is_sret(op_code)) {
-			*next_addr = pc;
-		} else {
-			*next_addr = pc + 4;
-		}
-	}
-	return 0;
-}
-
 static int do_single_step(struct pt_regs *regs)
 {
 	/* Determine where the target instruction will send us to */
-	unsigned long addr = 0;
-	int error = get_step_address(regs, &addr);
+	unsigned long addr, insn;
+	int error = get_insn(regs, regs->epc, &insn);
 
 	if (error)
 		return error;
 
+	addr = get_step_address(regs, insn);
+
 	/* Store the op code in the stepped address */
-	error = get_kernel_nofault(stepped_opcode, (void *)addr);
+	error = get_insn(regs, addr, stepped_opcode);
 	if (error)
 		return error;
 
diff --git a/arch/riscv/kernel/probes/kprobes.c b/arch/riscv/kernel/probes/kprobes.c
index c0738d6c6498..6a9cfb0b664a 100644
--- a/arch/riscv/kernel/probes/kprobes.c
+++ b/arch/riscv/kernel/probes/kprobes.c
@@ -12,6 +12,7 @@
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
 #include <asm/bug.h>
+#include <asm/insn.h>
 #include <asm/text-patching.h>
 
 #include "decode-insn.h"
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 9c83848797a7..938a8b841f94 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -26,6 +26,7 @@
 #include <asm/bug.h>
 #include <asm/cfi.h>
 #include <asm/csr.h>
+#include <asm/insn.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/syscall.h>
@@ -409,10 +410,10 @@ int is_valid_bugaddr(unsigned long pc)
 		return 0;
 	if (get_kernel_nofault(insn, (bug_insn_t *)pc))
 		return 0;
-	if ((insn & __INSN_LENGTH_MASK) == __INSN_LENGTH_32)
+	if ((insn & __INSN_LENGTH_MASK) == __INSN_LENGTH_GE_32)
 		return (insn == __BUG_INSN_32);
 	else
-		return ((insn & __COMPRESSED_INSN_MASK) == __BUG_INSN_16);
+		return ((insn & RVC_MASK_C) == __BUG_INSN_16);
 }
 #endif /* CONFIG_GENERIC_BUG */
 
diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 77c788660223..42a50e21b1d2 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -10,12 +10,13 @@
 #include <linux/irq.h>
 #include <linux/stringify.h>
 
-#include <asm/processor.h>
-#include <asm/ptrace.h>
+#include <asm/cpufeature.h>
 #include <asm/csr.h>
 #include <asm/entry-common.h>
 #include <asm/hwprobe.h>
-#include <asm/cpufeature.h>
+#include <asm/insn.h>
+#include <asm/processor.h>
+#include <asm/ptrace.h>
 #include <asm/vector.h>
 
 #define INSN_MATCH_LB			0x3
@@ -112,25 +113,22 @@
 #define SH_RS2				20
 #define SH_RS2C				2
 
-#define RV_X(x, s, n)			(((x) >> (s)) & ((1 << (n)) - 1))
-#define RVC_LW_IMM(x)			((RV_X(x, 6, 1) << 2) | \
-					 (RV_X(x, 10, 3) << 3) | \
-					 (RV_X(x, 5, 1) << 6))
-#define RVC_LD_IMM(x)			((RV_X(x, 10, 3) << 3) | \
-					 (RV_X(x, 5, 2) << 6))
-#define RVC_LWSP_IMM(x)			((RV_X(x, 4, 3) << 2) | \
+#define RVC_LW_IMM(x)			((RV_X(x, 6, 0x1) << 2) | \
+					 (RV_X(x, 10, 0x7) << 3) | \
+					 (RV_X(x, 5, 0x1) << 6))
+#define RVC_LD_IMM(x)			((RV_X(x, 10, 0x7) << 3) | \
+					 (RV_X(x, 5, 0x3) << 6))
+#define RVC_LWSP_IMM(x)			((RV_X(x, 4, 0x7) << 2) | \
+					 (RV_X(x, 12, 0x1) << 5) | \
+					 (RV_X(x, 2, 0x3) << 6))
+#define RVC_LDSP_IMM(x)			((RV_X(x, 5, 0x3) << 3) | \
 					 (RV_X(x, 12, 1) << 5) | \
-					 (RV_X(x, 2, 2) << 6))
-#define RVC_LDSP_IMM(x)			((RV_X(x, 5, 2) << 3) | \
-					 (RV_X(x, 12, 1) << 5) | \
-					 (RV_X(x, 2, 3) << 6))
-#define RVC_SWSP_IMM(x)			((RV_X(x, 9, 4) << 2) | \
-					 (RV_X(x, 7, 2) << 6))
-#define RVC_SDSP_IMM(x)			((RV_X(x, 10, 3) << 3) | \
-					 (RV_X(x, 7, 3) << 6))
-#define RVC_RS1S(insn)			(8 + RV_X(insn, SH_RD, 3))
-#define RVC_RS2S(insn)			(8 + RV_X(insn, SH_RS2C, 3))
-#define RVC_RS2(insn)			RV_X(insn, SH_RS2C, 5)
+					 (RV_X(x, 2, 0x7) << 6))
+#define RVC_SWSP_IMM(x)			((RV_X(x, 9, 0xf) << 2) | \
+					 (RV_X(x, 7, 0x3) << 6))
+#define RVC_SDSP_IMM(x)			((RV_X(x, 10, 0x7) << 3) | \
+					 (RV_X(x, 7, 0x7) << 6))
+#define RVC_RS2S(insn)			(8 + RV_X(insn, SH_RS2C, 0x7))
 
 #define SHIFT_RIGHT(x, y)		\
 	((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
@@ -146,7 +144,6 @@
 
 #define GET_RS1(insn, regs)		(*REG_PTR(insn, SH_RS1, regs))
 #define GET_RS2(insn, regs)		(*REG_PTR(insn, SH_RS2, regs))
-#define GET_RS1S(insn, regs)		(*REG_PTR(RVC_RS1S(insn), 0, regs))
 #define GET_RS2S(insn, regs)		(*REG_PTR(RVC_RS2S(insn), 0, regs))
 #define GET_RS2C(insn, regs)		(*REG_PTR(insn, SH_RS2C, regs))
 #define GET_SP(regs)			(*REG_PTR(2, 0, regs))
@@ -270,58 +267,6 @@ static unsigned long get_f32_rs(unsigned long insn, u8 fp_reg_offset,
 #define GET_F32_RS2C(insn, regs) (get_f32_rs(insn, 2, regs))
 #define GET_F32_RS2S(insn, regs) (get_f32_rs(RVC_RS2S(insn), 0, regs))
 
-#define __read_insn(regs, insn, insn_addr, type)	\
-({							\
-	int __ret;					\
-							\
-	if (user_mode(regs)) {				\
-		__ret = get_user(insn, (type __user *) insn_addr); \
-	} else {					\
-		insn = *(type *)insn_addr;		\
-		__ret = 0;				\
-	}						\
-							\
-	__ret;						\
-})
-
-static inline int get_insn(struct pt_regs *regs, ulong epc, ulong *r_insn)
-{
-	ulong insn = 0;
-
-	if (epc & 0x2) {
-		ulong tmp = 0;
-
-		if (__read_insn(regs, insn, epc, u16))
-			return -EFAULT;
-		/* __get_user() uses regular "lw" which sign extend the loaded
-		 * value make sure to clear higher order bits in case we "or" it
-		 * below with the upper 16 bits half.
-		 */
-		insn &= GENMASK(15, 0);
-		if ((insn & __INSN_LENGTH_MASK) != __INSN_LENGTH_32) {
-			*r_insn = insn;
-			return 0;
-		}
-		epc += sizeof(u16);
-		if (__read_insn(regs, tmp, epc, u16))
-			return -EFAULT;
-		*r_insn = (tmp << 16) | insn;
-
-		return 0;
-	} else {
-		if (__read_insn(regs, insn, epc, u32))
-			return -EFAULT;
-		if ((insn & __INSN_LENGTH_MASK) == __INSN_LENGTH_32) {
-			*r_insn = insn;
-			return 0;
-		}
-		insn &= GENMASK(15, 0);
-		*r_insn = insn;
-
-		return 0;
-	}
-}
-
 union reg_data {
 	u8 data_bytes[8];
 	ulong data_ulong;
-- 
2.43.0


