Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A642AC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 19:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C29606B00AF; Tue,  5 Aug 2025 15:40:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD8A76B00B0; Tue,  5 Aug 2025 15:40:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1CA6B00B2; Tue,  5 Aug 2025 15:40:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 959DE6B00AF
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:40:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 530BC10C206
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:16 +0000 (UTC)
X-FDA: 83743720032.15.CFA8FB7
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 807DA40004
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=LmXjubOL;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=jesse@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754422814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sy5rnGanwjtyLCbaD47CPjt7MxkuRZTNweHSGmibXvc=;
	b=Um/mh1/+EcJn30/ebv2TWy8vvp2/h96EqidXB4EOA6+sRtOX95W9oZW0XKokNjLq2UoayN
	d+oSIw0FFVoaMbd/+3HzstReqbMe2W2sXha7guuX5tIvcxQHZ+Z8/TuBsLnfReVWGJSyWw
	ZTaAkhVlIR6SjxO4iv/bvwbw48f2Yd8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754422814; a=rsa-sha256;
	cv=none;
	b=VrzpqQfQUeKJLs7RVa7wsQ5XsWUw6uk1rjqU4AoVRylRds6IvOUOYR05RwULraJCB5vVHS
	HHtolIfIClbeyelavSve2uqantZJ/2U4eYEhXICWdZYbR6jH1HQuDPBgbas4c2C7pD3pJA
	7uT9SkPq1XQtxC1J8jWc++YslkNKAV0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=LmXjubOL;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=jesse@rivosinc.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7e6696eb47bso638101685a.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 12:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1754422813; x=1755027613; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sy5rnGanwjtyLCbaD47CPjt7MxkuRZTNweHSGmibXvc=;
        b=LmXjubOLlyUyGlUz2d8i8e7folfXrRhl1aQgh9xlE7th+FY++CwvxsqvHIjY8HvAxk
         L2mO2THxJO8n+YSscEQBOEZhZSY8oHl1f3sQpDnfRbjM1SgL8VuYkZpRJTJzrAcQXHYO
         7nzt8fna7N5jzmaQx+7RbvKw2lIe07Yc0ITtN9Pc/OlJpBEJ2pdT8foofOiWuLmCdISf
         ojCM7iZ0KV30V7c+acSl9cd4DsU4aeo0beVTfOZr4oQJZJYqTAAmMSw5F//zJ1d01CHx
         QIS5EMrE1RlsUtPu7kusxppERPMuseIZC76xODHCqaFhrrYGrRfw0fktz90HqvJowYR7
         xy8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754422813; x=1755027613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sy5rnGanwjtyLCbaD47CPjt7MxkuRZTNweHSGmibXvc=;
        b=cWKI8sO7qcxuQmiTKZC+cq6eC3j39/y7HngnKsPzmZzJ0Rlrih7D/0Yls5MBKcps1G
         DxHic9rhMtgpWU/TxmMTJe5H3tQ5xu1GJAj2Bv9z5hKEoaC/6SGtn28STBT0SV5ZdPWf
         vti3YwRqZQibzjwhIxng7+/kVQ44QQFAunggd+Q5zXMoQArkUaoJu9r7dn1fkJvuwDrD
         ENu1flL2IVsBrNobP+1c7YKBD75lcPGFsMqGG+MCdsxxG6sjD3+qtMzmj/1wQdI9693W
         6pVsnI6MReweTuoIbfQM2cvat7A6+jZ+okJ1LbNMmk1ZKMnAQtXDr4Hf9z9UAme0Gh4i
         kLdA==
X-Forwarded-Encrypted: i=1; AJvYcCUWAW6Klummdu9TrAF4NgRCpjJMcpnf3Dgu8bB+jLEjdyeusMvrFxRiEsy92sLIH7ZYr1dYpBNQ3w==@kvack.org
X-Gm-Message-State: AOJu0YwO4Lrvoop+uLDVt+kPDHLSUaghGRvnpSwYnIOvj7sQBx745b53
	KuBOkbpynthWZ/D4BTA6kXt+SbynoxMOo+Da00//bQQoQF6kbk4eosILUB4j32qH2yQ=
X-Gm-Gg: ASbGncsFs01gCSA+cqnGl5vs2OokKSicFXqRwibjmlaJCgRrWf10ecYl4e5i366AtIZ
	iswYtPTl78Vhg8e0uyqtxpIjoguGk8WIBvDDuW21Fg/op5nDhUXMSlaRJyuZSCaBvbHIjPo3fGx
	KhwcDIOGmJqfiGjQKlXMsbtdTnPlR0pVvLS7nK0pmqA4LKBkcJcLjEz5xzLLZjOCOb85ZkU5xOD
	0wuKSDZtoxrFTUpDJL6+E24OLdLBk4UDlwVKeNoOTrUkiP2omYfMy6uUxJfoplymthgG+0HPVka
	QFaAu0nBWHdskkd+HYeOJUwNHWG/FAwheGKATHcrV/gWpRr7cUhw4QoLtRtcRdxKsDAYzpZVHbv
	Z3rK/gy8XsejYWLAQ4EZTCoa5eRvunWPPe2lOqNiR/zRm4O2kbNUQz9Pg6hjwMd5u7J1ZnZamLn
	QP0uXjlA==
X-Google-Smtp-Source: AGHT+IG6XA8VhHC/9Z5t7TyajoGN/5DDGuOO01JZMGKppPhvnVQsp/F8STKyDdgm3AlZG+FdD4n6KA==
X-Received: by 2002:a05:620a:1707:b0:7e8:15b2:3f20 with SMTP id af79cd13be357-7e815b24106mr5235285a.1.1754422813351;
        Tue, 05 Aug 2025 12:40:13 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f7064b0sm717855685a.54.2025.08.05.12.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 12:40:13 -0700 (PDT)
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
Subject: [PATCH 7/8] riscv: ptrace: Add hw breakpoint regset
Date: Tue,  5 Aug 2025 12:39:54 -0700
Message-ID: <20250805193955.798277-8-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250805193955.798277-1-jesse@rivosinc.com>
References: <20250805193955.798277-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aq4ch664do7jq8pbxefmmko8ea19fiud
X-Rspamd-Queue-Id: 807DA40004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754422814-929218
X-HE-Meta: U2FsdGVkX19vquPvbVhS3amh2xQN3gxTaGk0Nghuei0Gth/624M9rJAMtL6Hv1oYEmzG41IFln6JnwPLqpFh7iZQ5N+oM3d9XzRj7B8/W9nU4fDxODQOiw0/Nre2XjyRu/zfnxhSM30ep0sxxCze1GFin3ZIX7OhB1exsTlC2A06Z0tR918/ws3gQ+lDAMkqY8RF8SsICPjU9QcgZanpt3clQfK1oh9KtR57jQQSbfky4cM9ZOIhYyccqvuuCA2kptCYtqC4ZLVPFciyXc/vjlOLtNY94t/7aKPXnM7NCPG84yHrp3NduGddXQzyHXtgrYGKNBIPPDJR40B2kJeuCvEzm/LU5h/+JRo/ida7ZjG2cIJ2Dy/BJGsDEUf4ht2HtBDrrIVFYX0oJrCdPRdcRNZTOjgscDiDirrbL/Q30oem71tBuBPzHYWbrkkWBjRmb9nH81iSffGcltCvN7+K5oNAkmKv4+FNmVDDd3ATvrgAquHp/0ude2t8gYJ6QzQoYA2zlA8YQnUM0bZ65BSyDH+u8Xj1q3ePd3eZycgu953wExIl5xwcLq6BwDqu4vYSCwgyS97L5uWIIOcISFzLMWB+TiU51ExN/LCaEX9mOfVDrG2PIqH+ihuPh1Qu5we5t02EGsCdW0HMLMhmfVW82fWEFsrGO/nZLr28vRLC2UI/cPZmyZNtwT/bJnKk3gHG7bk/UjjGD5/gvuS2BdMYLNgLfaWLbQCMtn+QTWjnBTAPp22Zz1+6wMhkaBTNnJai8BX3Ld4DT1+Guyq6ozjOtspIcrzqkw+Q8kva78OjhGOw+EIeSIfMpNvHpcobVPUYhUfqE+XZFQ0L2Na1b5+U/p19u4wE68BGSMc3GgUBx99EVBloInJGeUKJOChoZmVPwNPC3XQgAzlA6drgtfMJcDKdIe3u1XgDOPVNtTAQ+FHnerwjAwEzbvh6vQbT635Lm8Dh6DKlHNulMwVT+A+
 E0uXGnTk
 uPCivpa6Dw3IjsnK5W+dPDPAYw7MHqOnGgHLO7a/yJpA07Ys4Lhur4kFnAyiKY88ZG3MvVh+g8xyUZWo5inMSIPaUom06d18na3FyZRZcRUK9m0gtHPGKPpJwhMBL8Ce6Jq1zqr+TSbL6oG4HyhSAIm9T6W9vOwtx9Nn6rBfj8ODUE/gbYqswESP5uDy/xnPOInyVd6xMROCtiJ/6j7+YqoTjzNulLBbDo3xb/8iJKKtv8YHPH4zTUwk5a7FK88msOUe0BVjzGunDckkT4Z8ewuUxirN9akzl5CVKAZPEKkToxL5XT2XKlvyOFA==
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


