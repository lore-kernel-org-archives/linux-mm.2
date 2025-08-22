Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B813CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27D3F8E00C5; Fri, 22 Aug 2025 13:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22DAE8E009D; Fri, 22 Aug 2025 13:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A7708E00C5; Fri, 22 Aug 2025 13:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6B818E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:47:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B94FBC0273
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:36 +0000 (UTC)
X-FDA: 83805125712.14.3C6869F
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id D8048140009
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="C/YCEdKY";
	spf=pass (imf09.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755884854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/NZ3invqjYii7VgIefIBIrdQlA4A/NoIleSlxqcTKI=;
	b=VNwmo56IO5MwuTxPSfa/3bj2+Ltw7JOKPK8zysNsGCCyCeyufKraEfulvkdpZEtMpd9Erg
	SYKD9NaJJkGy/jFGeIfQGpPbasyzq2btXMI76cbgxQ196/RyQYi1EJh+Y4wHxfgvQvAc9S
	wjNjEVVWtMOOnc4uZR5l0dI26QGNCqc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755884854; a=rsa-sha256;
	cv=none;
	b=bABRyS8EV84Ct1nPOyLrw4qHtfjNuBnLx31XmpsCXGsTvQXgE/aQbAlAlJatoZMrN5L18+
	cov4qigW5vGbXwcbRw/KryoWrdTOc3feDJEOdfVB/s7XGouGd3s2YVwF/ADfos82YIw6AM
	FyZTEXrkt5cs6lDeD7Pv8IsSztMDUhM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="C/YCEdKY";
	spf=pass (imf09.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b297962b24so23403751cf.2
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1755884854; x=1756489654; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/NZ3invqjYii7VgIefIBIrdQlA4A/NoIleSlxqcTKI=;
        b=C/YCEdKY/HshbOaTa8NJmz6wVUpmx+IYQ/UfRMS5SYX7HLCCJTz7lnijNbyh6HWFYb
         Gam4RuDvSzl31c4Gub1+ewSUa/zjGP33RWyrbMl8qh7qSuRONxt2kL9nZh4LPHlrOKA3
         0SbMheZNx1NYouKe2IHI6iO/wP0MxwqyMJZNesjWSGPIgPMGkGGhN0WkqZpY+xTz0dBj
         7Zg1tdjpKknYrwKKP/xEBnADCdYmYQywIivdLBFlbRMNxSjCAjgtMmvJjwlpZqyqNu1d
         NBCyuX2JpwHq6kjKwqMgvsL2WV1g3lVlvJDO8Bsvqe7jHOPfH+j0IkI44DtN3fk3BUhZ
         K/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755884854; x=1756489654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1/NZ3invqjYii7VgIefIBIrdQlA4A/NoIleSlxqcTKI=;
        b=CphabVTN7p2GZpuMOoLN5i5kVZ2f+4PP7TxlsY9xaFepFeHUWH24bvxv7Ou7+kgVLt
         /QKb84+3tuCZPt/cwhJQI0G1tpVW/rg1DAsdnITaWZmWgNP8Y7IswcFFOzF/s+krcPcP
         mVK9106CYNOspVlnr+5/gSbokaf4Y72+mpCM8Lmgc3DKUbSDzC2vqFuLTKYli1HmL8Qg
         IuPH8mtP53itVK5PVjFOi7D52iuEakcHs8mzNZ7BAwn1Lc2sNvAYZ1pDiGOiUR/VOpTl
         2g9FSO05jeyQC2dgxSyHSdFu68yynR3N1xVUAlxwZK8qa9vIbhUrxC1CcWepjtGM2ZhX
         h2XA==
X-Forwarded-Encrypted: i=1; AJvYcCVj4tpykS22mL7g0PuU1AXs45yl9R5rerVmQdoLvvySjFjbAzHq2l9+TKvXh95tp8/MHIdg1cultA==@kvack.org
X-Gm-Message-State: AOJu0Yzmx+kgyOb1BF/+sDpuMfaIiwy4hkFLiH7pSmKPIgF+Whhkcwt/
	+3rA5vr+CtakRRNc0FEIzzC7SD1dkozWXmeGGXDEMQonuVnKlYK4WtBNia8OLy51X1s=
X-Gm-Gg: ASbGncv1SjmOSaPEr8kkDIUHoPR+XnkVyfbduOuu9yAnkbBwvFLmNfhH7ucXpdKeNy4
	crY3/D7H/GvFT8goWeSbBDNyY+vpgZ+5ivfzhhgF4WPIayNAtGcp5i1ojXP98tlk/XuJIbBBnYC
	tIoqbTwAhd/+ekFH3J/WWkZ2S62uDhz8U9xqt5YM/UQgCQKVZLxy5nqngK9msBNw9uaw+JC1Bq8
	ci6OiHIqCNQ7sRdKLGoFDDTKPvOPhAuCfQqHr4kw40WWq5W3I1QmSqxnpq8mNySpBxY53adX4+r
	clDGRGSf0iI+uEWqgECORp379CdPR7/SioZI4UeGrOT4bHfam+CvvVA7hBOjV+rP8/JiPB5h7B5
	o+i4SgJwHXVNxVn4d+Gv4dhPdo7t33uZ82yLxu0b14gM77JPFkfdjA2rUhs/z+ppKGAapsYAdtM
	YkGOaRXw==
X-Google-Smtp-Source: AGHT+IFZbeEwjqDea0hlGgRVd9Xscw2cIAz+36MfAAXzcnD0U+Bx3mxtHkRwJItm6g9vdsmkz7a3oQ==
X-Received: by 2002:a05:622a:50c:b0:4b2:8ac4:ef7c with SMTP id d75a77b69052e-4b2aab4abe8mr43670911cf.75.1755884853830;
        Fri, 22 Aug 2025 10:47:33 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8e6023asm3121361cf.53.2025.08.22.10.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 10:47:33 -0700 (PDT)
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
Subject: [PATCH 7/8] riscv: ptrace: Add hw breakpoint regset
Date: Fri, 22 Aug 2025 10:47:14 -0700
Message-ID: <20250822174715.1269138-8-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822174715.1269138-1-jesse@rivosinc.com>
References: <20250822174715.1269138-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D8048140009
X-Stat-Signature: 1jocphmyzg6fziiif9yre91xdwchn7j9
X-Rspam-User: 
X-HE-Tag: 1755884854-778955
X-HE-Meta: U2FsdGVkX18KUI20XFHHIWC+FpPQzayZWO2mrtoGkKQJieMLQ+c0TJWk5ds73UvJMx1S4GTHyTEPRjOSR4IWkOZuih9k2n+d18EkyOkAfK5izdetXAxp7fTrqWd9FcKJpn2veSHh5EO/Zn3F3rSA6iE7MVsoMWAIJHYwOSOG4fLwdF7fOz5jaeMfwn/5h4pX6nShvRlllwkizRVQXP8pkQKS1ytI/7RY4FM6EcoDYc7YdTZptd1CsqVRXCZLEuBK+wvRSF28j3bikEMDY7GfMzQ1ZAvSA2i4e46W6uyBfBEnqKqH8W8k3pmdijN9dVc0DY4//2YrEYxsBQtoORibbYC+cSpdP+g8NMnd9oXUdwTG2isiUsS1wbf+cefHrpT7KoLtXlrJRWqGgXeIJgfIGskmSG+HyOl2pyuuJx1mLPvZ0kg6Ss0DXxnxBWxRg2NixRbVEOo46qRlEjUG2suQdfBnOdfbA9DMEj6P4w4OddabOlAxV5gpgE9tkUhyubQEO2hEmSryycX/MsfA/7ZxVcW9cH+9dTFR40UYWBsKH9Tkzm3jknpJB5XkcQpJfHMMx1B6/O2IfmQvTzMZ+8IlighaXglJYqWXaYJBSqrfg1Xas76wKC/wLJQJ9VfCd605mqvo3wpD7cZMm+zM7HLx8i/8cR6F03VgixiZTTnQT3Rqm8zpuE6phKC1MsEiWJQde5jqGAqeaN4Oa2xJTVd3HOuZWS+zaXtHE/YqJbzohLmBdXtQG4siEs7MHxEcByaFIzMA5GPuPsMfeoYVMhXq0RNqVCYdxJ8aYanjQ4jMUpmvykScxia6PicOIkznPSQqAQ+bS1Apr6Xvvd14Y/uaigwIzrVcKA+oy1jgVpYE+SyDekFZa4KOCfUk6DQ3vQAuzFYPL0y0gkygtf7nYwJXedpe+lUFCL9q+tFjz19WExQWQ6l1SVgSfDx9Qrmshva7SQlmDty98lkZwdKvqt0
 +ZlEhjek
 chzVGsoi0GrIBn+Um1OBcFvVOhDPdeqrRbGyOI97PEDmDJnsB2sl1p0RlVG9XjXXcs6me7xnSnbCQykzVyjT9lE1fKND9gxAw3Qz9VNdlj0QweRZKShWbmjnMypR9ipkMi9OacbX4N15oa3vr1ziTjCrnnz+vvzYlkyEenuNFpkoRhKQS1iSfvMOfljdueZ0TubWU+39IG7OSpOudb6uM/BNKMAfcAGEmwJSCleRJFaBnuegZDEzj7+M2i/7egapIxYTyb0oWncPMdaOiMRDgISJPrA09G+cRS64cJ2E8VvOYc4WExdbs96eAUpo1lh4QA/wId2+Jwue7+44=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add ability to setup hw breakpoints using REGSET use the
__riscv_hwdebug_state structure to configure breakpoints.

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
RFC -> V1:
 - New commit
V1 -> V2:
 - No change
---
 arch/riscv/kernel/ptrace.c     | 59 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/elf.h       |  2 ++
 tools/include/uapi/linux/elf.h |  1 +
 3 files changed, 62 insertions(+)

diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index e097e6a61910..fbd0097ec168 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -33,6 +33,9 @@ enum riscv_regset {
 #ifdef CONFIG_RISCV_ISA_SUPM
 	REGSET_TAGGED_ADDR_CTRL,
 #endif
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	REGSET_HW_BREAK
+#endif
 };
 
 static int riscv_gpr_get(struct task_struct *target,
@@ -280,7 +283,53 @@ static long ptrace_sethbpregs(struct task_struct *child, unsigned long idx,
 		return -EFAULT;
 
 	return ptrace_hbp_set(child, idx, &state);
+}
 
+static int hw_break_set(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			const void *kbuf, const void __user *ubuf)
+{
+	struct __riscv_hwdebug_state state;
+	int ret, idx, offset, limit;
+
+	idx = offset = 0;
+	limit = regset->n * regset->size;
+	while (count && offset < limit) {
+		if (count < sizeof(state))
+			return -EINVAL;
+
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &state,
+					 offset, offset + sizeof(state));
+		if (ret)
+			return ret;
+		ret = ptrace_hbp_set(target, idx, &state);
+		if (ret)
+			return ret;
+		offset += sizeof(state);
+		idx++;
+	}
+
+	return 0;
+}
+
+static int hw_break_get(struct task_struct *target,
+			const struct user_regset *regset,
+			struct membuf to)
+{
+	int ret, idx = 0;
+	struct __riscv_hwdebug_state state;
+
+	while (to.left) {
+		ret = ptrace_hbp_get(target, idx, &state);
+		if (ret)
+			return ret;
+
+		membuf_write(&to, &state, sizeof(state));
+		idx++;
+	}
+
+	return 0;
 }
 #endif
 
@@ -324,6 +373,16 @@ static const struct user_regset riscv_user_regset[] = {
 		.set = tagged_addr_ctrl_set,
 	},
 #endif
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	[REGSET_HW_BREAK] = {
+		.core_note_type = NT_RISCV_HW_BREAK,
+		.n = sizeof(struct __riscv_hwdebug_state) / sizeof(unsigned long),
+		.size = sizeof(unsigned long),
+		.align = sizeof(unsigned long),
+		.regset_get = hw_break_get,
+		.set = hw_break_set,
+	},
+#endif
 };
 
 static const struct user_regset_view riscv_user_native_view = {
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 819ded2d39de..7a32073e0d68 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -545,6 +545,8 @@ typedef struct elf64_shdr {
 #define NT_RISCV_VECTOR	0x901		/* RISC-V vector registers */
 #define NN_RISCV_TAGGED_ADDR_CTRL "LINUX"
 #define NT_RISCV_TAGGED_ADDR_CTRL 0x902	/* RISC-V tagged address control (prctl()) */
+#define NN_RISCV_HW_BREAK	"LINUX"
+#define NT_RISCV_HW_BREAK	0x903	/* RISC-V hardware breakpoint registers */
 #define NN_LOONGARCH_CPUCFG	"LINUX"
 #define NT_LOONGARCH_CPUCFG	0xa00	/* LoongArch CPU config registers */
 #define NN_LOONGARCH_CSR	"LINUX"
diff --git a/tools/include/uapi/linux/elf.h b/tools/include/uapi/linux/elf.h
index 5834b83d7f9a..b5f35df1de7a 100644
--- a/tools/include/uapi/linux/elf.h
+++ b/tools/include/uapi/linux/elf.h
@@ -460,6 +460,7 @@ typedef struct elf64_shdr {
 #define NT_RISCV_CSR	0x900		/* RISC-V Control and Status Registers */
 #define NT_RISCV_VECTOR	0x901		/* RISC-V vector registers */
 #define NT_RISCV_TAGGED_ADDR_CTRL 0x902	/* RISC-V tagged address control (prctl()) */
+#define NT_RISCV_HW_BREAK	0x903	/* RISC-V hardware breakpoint registers */
 #define NT_LOONGARCH_CPUCFG	0xa00	/* LoongArch CPU config registers */
 #define NT_LOONGARCH_CSR	0xa01	/* LoongArch control and status registers */
 #define NT_LOONGARCH_LSX	0xa02	/* LoongArch Loongson SIMD Extension registers */
-- 
2.43.0


