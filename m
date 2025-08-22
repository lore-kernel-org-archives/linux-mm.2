Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B26CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0806B8E00BF; Fri, 22 Aug 2025 13:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 058B88E009D; Fri, 22 Aug 2025 13:47:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89D08E00BF; Fri, 22 Aug 2025 13:47:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D38008E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:47:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A473D11752E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:23 +0000 (UTC)
X-FDA: 83805125166.19.E46A2BB
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id B1275C0012
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=LOVpFdSf;
	spf=pass (imf10.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755884841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDpjZc97n4U0egjgFALLU1N3dP/taaCunEfrlMVFon0=;
	b=peWJ1cQGpmbJfzN3MJ+WKho5otx4Wsj4WH1IgdBlK/2kYJg/FhwSg3RGxG2V7cPstkFrYf
	At004lcjfNTduWqyXBeK40AmqC0/gWPgKglkeDCAHN77BpXzHXdMJQfWBXAFIQjBW1LWH/
	E5V350AFLN03WchlnzlhcIaw8cCkimw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=LOVpFdSf;
	spf=pass (imf10.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755884841; a=rsa-sha256;
	cv=none;
	b=K0B1xjdKjxqgmxqvlP4Ay6OuFBaKn/ecscpeaEjJ3sQ6oZk6YNLEQoNOKvujDzsNo2sTZH
	QZxOr8wAJpBdhY7kkGDd9IarCYX0/kMdc3oSZeKC8jWSSDXCFQCq4+iYJ6c01WU7kM7B9w
	nvMau+xip1dUcG78C/PgaKPPwwt46YI=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b297962b20so21365391cf.2
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1755884841; x=1756489641; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aDpjZc97n4U0egjgFALLU1N3dP/taaCunEfrlMVFon0=;
        b=LOVpFdSfL6XR30Xcsza2uIK2jcV4UXivF1BZfJAz9yv/gEiZhLeIJWW8ZGPTgPaV3t
         SYxbMdiL/0AuYUbid+HyFDdCNYfAjL6Itm60OnnNYrK//Jo8VxzyuodM02to+gEWD1zr
         NyCDeEl803xOA20URsVJogvaedyt2S7ec+n/b4BatKIXxuWCEPSHycMPhcWEvhcFpMkL
         c3bvIwiyT4Hp9N2OzeO4qNWYowNJhXqX27j3feojUeKBZVU2GICeyatWJiZlRXavDEjQ
         Shay8nGum8RDZ9EaSMh3/XCRUO3TK8xDHUnMWoEYFehVPcIYiwdJm3HVldJEn+QAAIVS
         SCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755884841; x=1756489641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aDpjZc97n4U0egjgFALLU1N3dP/taaCunEfrlMVFon0=;
        b=w1afwOkWec4qauY6ofgpIhhdESaWgCMPetv3o2/Fu8vys9hLXIPNWUGT31MXddodcj
         KJ7HMQ41IFUKcEoZFY1r0wPjGi0jK82Nc84IQjyvkLtY0NokmdV3G5qSj94FYaT3zl/r
         LRK6wE1HYDlxh+NXaKrxcorGxr9iwMwwMxsbCh7+920UjUEPWklPTNRyNhPAOk1a2PBM
         BMLS17K/sKs5XqSCCRwncDqlhj1POoAwwxB4e2hSQPBNaDYwB98Trp/rklRhj1oy6HFW
         5VAC2CSULZyMr0rb35TukjdiwefQ15FqEjYv1JBbjOuKgHpgisoa4mzBeTOTu+M7OR+y
         13gA==
X-Forwarded-Encrypted: i=1; AJvYcCW00xS3VcBxjzk8aojeAMyGdCj7yY+UZf/WBueBaVSqDKY9hLWvg+QBGMMLfMum8SyMD+BbogcZ+A==@kvack.org
X-Gm-Message-State: AOJu0YzQjCvSpgckqFnbZXEvv7KMpB6CEmQgdi7rjUflgd5wwB2G+xx+
	vly+6flb2xpVA1DvrGEwCFko8EsIEoujxXHSGOXVZ/PkXTvT/zQy2WJ7a5ovTNIQbg8=
X-Gm-Gg: ASbGnctrabYf65ZUe/Fr1Ssq7ouLVxa1agV/yvAEc3JM6nXdlDFRxihzTk+WdF6Obop
	Wxdhx9eYuNeEsEag6NJ9+6SFrh0WHJ/wlfHDTAHnS4mgUPbMlx6s4j8CZMiXU3275Z7xiO/G9DW
	sw2ehhdeHB1n8Hq/DtNvYWX2zThWVSYhL0YJlsygpKxb/TC/mVH/d+2CfrqQXWnTb+L9CvP0XMq
	qpMMOGUMUrIpEkq4RL3r7FTFYwwJW6tK14WrwMG+Igk7XmVTY/VhgsikpyZCrvlYibZfZXmxSlc
	ScfH18WhA8LUUCtc86C68mCCPY3wB3gtgu5cmCFHHyiXXZePYCMIy4v1v+s1e+wU6Sq92NGNJI4
	VZvEItsuUJPLPcHsJCezJTZNGepcojOW6x5kF+rgS+0ZsqakdUeIyE6sJrt8jLHjMnDqw4ivpoe
	46syBxBWn3UcKW246o
X-Google-Smtp-Source: AGHT+IHNrCDOw6FL6pCo4DbPw+v/tihYCiWlLKD99o6wPnSaszr779gTketdS2R8nKaudoSSWZudpQ==
X-Received: by 2002:a05:622a:4007:b0:4b0:89c2:68e0 with SMTP id d75a77b69052e-4b2aab5d1f6mr45761641cf.60.1755884840514;
        Fri, 22 Aug 2025 10:47:20 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8e6023asm3121361cf.53.2025.08.22.10.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 10:47:19 -0700 (PDT)
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
	"Liang Kan" <kan.liang@linux.intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Jesse Taube <jesse@rivosinc.com>,
	Himanshu Chauhan <hchauhan@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Deepak Gupta <debug@rivosinc.com>,
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
	Ravi Bangoria <ravi.bangoria@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Joel Stanley <joel@jms.id.au>
Subject: [PATCH 1/8] riscv: Add insn.c, consolidate instruction decoding
Date: Fri, 22 Aug 2025 10:47:08 -0700
Message-ID: <20250822174715.1269138-2-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822174715.1269138-1-jesse@rivosinc.com>
References: <20250822174715.1269138-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1275C0012
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: cjztpmwq1k94hqger5p7h18kci87rbh3
X-HE-Tag: 1755884841-858759
X-HE-Meta: U2FsdGVkX1+S0LYWSg1fTeLGT7YG66Omj2f+A0P3PQtg+A3UQ5xN6rUbQxmkVSck/XG1c2Xd+D8Sp095wjCfvVwyRvDWHaF8bcAVjDGv4D2D5dXh4ycOWaRj6i9TnxTCUo+jYVmjRWZxkQvJZ/wV8vFcGhuezYl6rWdwVCYp/bMFNnrPDWVhCB05B5M7H9upmg/b61rwfCkMShCvHLAC9QYfyJSxEI8nKlAqkQSYKgkmv3Nwu793V7UpyGlnmO4G4nUVzEC6LUv4pBHy6FPX2arfeWJ9ceC4ilZ1XrFTHRTa5JSh8f3NA3lvY58Dx8fPDhYPi3d0P9KvmetP1JrN0dQo5om1x60jKDeB15gJ6DWu8+E61cgUpuQlqIPkOS7qB4xcvCQ49rgO8B3A0ArVZmP/corXbjI8xHzOMAtvs6l9SlZWpSOxDVsuW0vJG361nfzIGme8JXhz8MewU4FKPz38E63c2hn1oYIsOO+NC5+/+WMw52NAQde1G3yDR6odT0CohmHmx0Z2BYBUW7hbss74R5TF/X2PGpH/Td35h7sUOoXURaRk3NgNqShtdpl1nVVnZwMRmn2dn8yEpHSTGMSkSSOgGq/Xw44QOxl1TyhR9U35NCNkgumIrZAI3DlqXCgiFBhKj7ZMtlJ1yfQ3W4KkUiRTdqt6BsBlQPIYndK2dJkax+ypM2QwRa3WAcjca2E79L57ZBuIOKk6h/Dlg9DzWsyAAGDF/mcaNrgHzOgAYX8ko4rzOflTooWEQLsQYdjj5aSDdH5sDhkCpuNikq7ARRBD++SLm00+ERVT6R8H6ZoRPub87GOmx9c8cnPnkqjManH31yurNfE2Tq6JoJzKsnXoir9jHCjKJhNcWtMOJDmjv83iwDbOxRN4zuz1EAiuv29gr9ViYOuAW64z5h/DxIIWTm7HeqIkBTbpuQ3qf+DNXhmeBKhcKQ5jvW+9kMa0nCuFlYshPhiQTYW
 Ka+X1N7T
 adrILiWSY/+WqEaUKNGIzTNojeh+iMZnq6MVMVUxlNS6QoxDBYnvQ7uBSRH9UE2PaYrz0JMKU+g+YfFb+SfgAJypoTyT8Pa1k5N9nqZz9iFuObz5xpxkp8bxtzLkuds6H+b71y5tm9eVNiz23rYej2zibjk0mhz6VUXXUYbpCl5OnZbc0U3cJsCcSl0eXEMc8Bma7OmWHAgVnV3USUu+l9QvlCXnLqsQusimvJBhdzPuzAasr7SLQgfZZLIztlEzvNRAApFrMV6uIWWC2dBNBjkCid8YpVpnQL5cKXg/cqPKVidwSspasK8O8p+t1owpGTMwjFM0Az+JUriU=
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
V2 -> V1:
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


