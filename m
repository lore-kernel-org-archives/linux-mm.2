Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29282CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368748E00C3; Fri, 22 Aug 2025 13:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1D28E009D; Fri, 22 Aug 2025 13:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA7A8E00C3; Fri, 22 Aug 2025 13:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 004988E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:47:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C01C6B785C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:32 +0000 (UTC)
X-FDA: 83805125544.12.CE84C03
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id DB61F18000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Pqq+1xPS;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf24.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=jesse@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755884850; a=rsa-sha256;
	cv=none;
	b=SvJWCPiyBRHXHYt6LyAPqT7z6nRKdALSJnyfUDJWwxW0G5kGW+1ld525QFyFWhjyoMEGO2
	NfYcOwBMktSNy/tS2hwyhHFGlKrpBDHe04sJ1jF9/8lpmNzPTH8ubp5KeOpj1YeN36kWOO
	ijqhqNvY02K63xMlKTHZOCfmLL7Q/K8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Pqq+1xPS;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf24.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=jesse@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755884850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4pk2Is3iINvVBYx1tiVmoatjTI6H0OmVzvfALLTxnFA=;
	b=QFnfsO6pSv06uolLoxCpyZB1y/AAYXEhYEqA338AKVnIDLGDfSU+VEOjJ/zCvq5VgFE6AW
	ahMGaVWjBJfhRprF2W/Wga8VmXpxku791JKYEOk5MeouVLRxjv8mCEk/QUUq+JXIXAc3Kq
	cx+BcGMjjyLd5MlLqYev0WkneQmzmNw=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b134a5b217so25798211cf.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1755884850; x=1756489650; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4pk2Is3iINvVBYx1tiVmoatjTI6H0OmVzvfALLTxnFA=;
        b=Pqq+1xPSLpn6Z7GkoSZ03axpOLLbRZgFMV19MPQJYA33sNuPF3jG7zGU7mo5DNB5I6
         JsjwTJXQRur67yN48oUZlKxfhz8p9D68/gEJqv9bKZoz7Ts7CDo4O72yOurfkEWaizNC
         cDeywngJDWogg7HvPNmnghJLbu5jWR3Sb+FvMQpxxQkNzND2w/obmSX3IXo0lQM0cJJE
         c55KwV1ERU5K49v/TEgEnQC6LgB4+miPF3/ZAelCIPiwQhIPeNOdecJfp8LNu77FLDw2
         7S55SRgyG1r8VLa+DdpKq2ZIy5aaqWroi+fr23CQYbIix2sr5xnZwIHsqWXB+BOfDl61
         6Uww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755884850; x=1756489650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4pk2Is3iINvVBYx1tiVmoatjTI6H0OmVzvfALLTxnFA=;
        b=w3CxHRXlRkm7NZIqN5GctlNk7igbWI9d6ejFv+JlG1TWELTlW4MXWcFMD+pQwNEv4D
         ipAwEIUbKBhZSR6/6Ycc+zIlVTGoIYELLtnHYHy3WVPw3mr9sVLvM7fp7lyQPuPxhV6O
         GjoHJCdoMMJLZCMVsT5+98la2uo6cWNwA7nYBjLT/sJaCVjY366DSr0xdxk1wjvIIISX
         vJGguuquBr3VJspE9VgFflHvvFMzBN60sY9aqlstrkRt1M9CLMTthTfkAyEnyTPCSdAf
         vkmeJmgiw4MFncot08525+Wkk785MNT/NT98tCQIUZRybuWbJqSZdJjZklcmZ3HOINy+
         WIug==
X-Forwarded-Encrypted: i=1; AJvYcCWAssA9CoDgqMrR10xw9/2jjWIAKXENXxNw2T7ESRQdyWpw/5/9X6JJn0lyiJ+mVETT5fM0jPW/qQ==@kvack.org
X-Gm-Message-State: AOJu0Yw001ZYCngS/r4QKotoZc99ssnWH3QrTnB8qYQGT0NaPN7+xZdY
	hfFaL2vrQfDww+9VztEu3hX/B9yJVes9Zdt1quILMqlmFpDjKERKXPsExTai1VIJn2I=
X-Gm-Gg: ASbGncuCfvaXgDTPWOs3bU5wymmQIqn8if21IpRF7YTwIq/KRkj9IsbygDX6juEAMTU
	SwsEA1sHh22pgqigyHYQPYfHG7w1FTfwCUQqI4h9oHMI3GInZkPZBVfHn7pIDDQ1a82PDgz2k70
	fsihEcjiXqbuZoN1vfObdcatQqwLcb4/2gr7SOtyHspW/95bwXAipUsTwIVQRO6vxwzDNCAB7ll
	TjpVq31DOrdRroSeoSTKS43qDzzYNtBKcrD1S5I+8w7+q1cFOXvBvZ9xaFS3psPiqpc2J8AkSSv
	iud3veKHeMLEJC9DD0stXM09tQi1BwwAA6iaKL62DgqqUWVSrllvE9msksJHArlS8h5qkVps99C
	s8FAmLDDGn8ve//bWsYe6LFu98BoaOwqF4Odj01e53POrcjI9nktepeDspGoyCjzCbFknxynWg4
	SVVTHAqw==
X-Google-Smtp-Source: AGHT+IG4XIPTeocHGG5I3A7e0qgtcyCqA4EPCtUSBsRUkC4IO4uwiAhBHdemo1KZUiyuqkEmO9OVJQ==
X-Received: by 2002:ac8:5d47:0:b0:4b0:7620:7351 with SMTP id d75a77b69052e-4b2aaa0545amr58372551cf.13.1755884849786;
        Fri, 22 Aug 2025 10:47:29 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8e6023asm3121361cf.53.2025.08.22.10.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 10:47:29 -0700 (PDT)
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
Subject: [PATCH 5/8] riscv: hw_breakpoint: Use icount for single stepping
Date: Fri, 22 Aug 2025 10:47:12 -0700
Message-ID: <20250822174715.1269138-6-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822174715.1269138-1-jesse@rivosinc.com>
References: <20250822174715.1269138-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DB61F18000D
X-Stat-Signature: igugghkhn9acm6rksrz5xouck7mx6q6k
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755884850-115865
X-HE-Meta: U2FsdGVkX189UoiX0WfyjtsS98Tp3InceGEjo4EXo16im+P0NROGb8m0sPg4yK7xcXw8WciN0IUbxwtkq6IhHOheFWRA32qi8tltbXaDYne/YAO+g9BxaadgCeFkM2XpQFhr5NhRwd84rOSOlNhF1mgcW9z3NwL8ww02GeTPGmz4UxP8xn+LeQFZbEypFVY/IDf1/2EU48/W2QxEoTn3erzOHA6m1a3LPQOfxvnek0E+xiGaGAp4s9zWB0l2ljBqNR8VajsgAvalrCMuIVc/Lfcxw8v2DXNiEb235y6kLSWvIfLO22rD+ZOZG2cucXNiNvNzrUHdAHu8kSEdvLi7wQloJ/rJ31F/k5qI27UID8RWTkFgBhL8VR7U8M2huGVVKOSRvYsb5SpZl25FZCYop7aB9X2rAf/zXU9ziTJCHJEaMavInEi1IwMY6kEnEHz5lUb/Z1m9VpCrHfcmbekeFDpvM6uGyCHsZN03UnRJ7pHg/2s3wL9XajrkcHJbkUs+azEt6M7WQ0X4mmJ5QL1Hp4kJ5nNIDaFRyiemN2JG2yIbT67eQ6JYTJ0bnSCttOrOghUIy4HnBuD6w8Px6xsXgN0XZEtALen/phVnjYyAjyTX94eLlaMJ8Z/wqYn1nh4tzHBn9hs8F20gM8c2ERzIgwGG1aZrM1J/orKP2NFVaV/N8K+zTVU+s5PvQ0GD6J79KZi6iexDlbS+MtMNA++r763AI9MDePlhVzldOYa5d/PEtp0jx/SPRRbHlhll4zWp1s6ZLF4FG9m0bdvM0iqiIJ35K0o91Ku9gSfIXfxZDUZLxpsIM3Op7XGMmyia7BkfWQjpE/DVETwJ0HfZEkDxAODkBApH/x5z8qE8s3VAZUCECEPAawXYq+Fyy1bziCUHbU7d8rAf9IIICcLm4B6E5/uuiAAD4jrCipdhs4vShgyfhmDj2hcfWaQuM5Pvh/lpW3V8VKLpGcSkeAADFk/
 VAtdVW+m
 /hVPn0PgBE3/Ejxh8HLS769WFb2YAfrBfyBbkm3A99AajQa6hnIwwKQvpLSXTTshq+5M8A0YhmYHu7Hw9JNYLd2Q/nTtOVaDdbuHT2GL182n8xUGZpbDN50T6Xmb57Auygn/1OLxygcbSTUnKMouArIk5Iqg0CR6o+oPsC29XZjKM3ungFQGK4d9531D9uOLZbVGuq38UQ5NHdlQPgUpwr+CWS4lFKCFkpbmJmA8vCBw/lLEVVSRwD6lrZgXeqvTFLlZWEzUUO2Ch7j3uI9XSwctnvYhK9KvppPdJZJfKRJz4NTyu+twywm2CWYLLzi5FCdD23iUgjJmFMILZm7qBrbgne7w5RZMbrWiUBBLncmsuP/I711FWqF/wzxacXt+jfi87QfIqfEEEGjF3OEX7Y90wbrbDD2n1PiUkw6cBsvR1c/KAV8EZXfGwDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Sdtrig RISC-V ISA extension does not have a resume flag for
returning to and executing the instruction at the breakpoint.
To avoid skipping the instruction or looping, it is necessary to remove
the hardware breakpoint and single step. Use the icount feature of
Sdtrig to accomplish this. Use icount as default with an option to allow
software-based single stepping when hardware or SBI does not have
icount functionality, as it may cause unwanted side effects when reading
the instruction from memory.

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
OpenSBI implementation of sbi_debug_read_triggers does not return the
updated CSR values. There needs to be a check for working
sbi_debug_read_triggers before this works.

https://lists.riscv.org/g/tech-prs/message/1476

RFC -> V1:
 - Add dbtr_mode to rv_init_icount_trigger
 - Add icount_triggered to check which breakpoint was triggered
 - Fix typo: s/affects/effects
 - Move HW_BREAKPOINT_COMPUTE_STEP to Platform type
V1 -> V2:
 - Remove HW_BREAKPOINT_COMPUTE_STEP kconfig option
---
 arch/riscv/kernel/hw_breakpoint.c | 173 ++++++++++++++++++++++++++----
 1 file changed, 155 insertions(+), 18 deletions(-)

diff --git a/arch/riscv/kernel/hw_breakpoint.c b/arch/riscv/kernel/hw_breakpoint.c
index 3f96e744a711..f12306247436 100644
--- a/arch/riscv/kernel/hw_breakpoint.c
+++ b/arch/riscv/kernel/hw_breakpoint.c
@@ -20,6 +20,7 @@
 #define DBTR_TDATA1_DMODE		BIT_UL(__riscv_xlen - 5)
 
 #define DBTR_TDATA1_TYPE_MCONTROL	(2UL << DBTR_TDATA1_TYPE_SHIFT)
+#define DBTR_TDATA1_TYPE_ICOUNT		(3UL << DBTR_TDATA1_TYPE_SHIFT)
 #define DBTR_TDATA1_TYPE_MCONTROL6	(6UL << DBTR_TDATA1_TYPE_SHIFT)
 
 #define DBTR_TDATA1_MCONTROL6_LOAD		BIT(0)
@@ -62,6 +63,14 @@
 	(FIELD_PREP(DBTR_TDATA1_MCONTROL_SIZELO_FIELD, lo) | \
 	 FIELD_PREP(DBTR_TDATA1_MCONTROL_SIZEHI_FIELD, hi))
 
+#define DBTR_TDATA1_ICOUNT_U			BIT(6)
+#define DBTR_TDATA1_ICOUNT_S			BIT(7)
+#define DBTR_TDATA1_ICOUNT_PENDING		BIT(8)
+#define DBTR_TDATA1_ICOUNT_M			BIT(9)
+#define DBTR_TDATA1_ICOUNT_COUNT_FIELD		GENMASK(23, 10)
+#define DBTR_TDATA1_ICOUNT_VU			BIT(25)
+#define DBTR_TDATA1_ICOUNT_VS			BIT(26)
+
 enum dbtr_mode {
 	DBTR_MODE_U = 0,
 	DBTR_MODE_S,
@@ -79,6 +88,7 @@ static DEFINE_PER_CPU(union sbi_dbtr_shmem_entry, sbi_dbtr_shmem);
 
 /* number of debug triggers on this cpu . */
 static int dbtr_total_num __ro_after_init;
+static bool have_icount __ro_after_init;
 static unsigned long dbtr_type __ro_after_init;
 static unsigned long dbtr_init __ro_after_init;
 
@@ -129,6 +139,7 @@ static int arch_smp_teardown_sbi_shmem(unsigned int cpu)
 static void init_sbi_dbtr(void)
 {
 	struct sbiret ret;
+	unsigned long dbtr_count = 0;
 
 	/*
 	 * Called by hw_breakpoint_slots and arch_hw_breakpoint_init.
@@ -143,6 +154,19 @@ static void init_sbi_dbtr(void)
 		return;
 	}
 
+	ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS,
+		DBTR_TDATA1_TYPE_ICOUNT, 0, 0, 0, 0, 0);
+	if (ret.error) {
+		pr_warn("%s: failed to detect icount triggers. error: %ld.\n",
+			__func__, ret.error);
+	} else if (!ret.value) {
+		pr_warn("%s: No icount triggers available. "
+			"Falling-back to computing single step address.\n", __func__);
+	} else {
+		dbtr_count = ret.value;
+		have_icount = true;
+	}
+
 	ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS,
 			DBTR_TDATA1_TYPE_MCONTROL6, 0, 0, 0, 0, 0);
 	if (ret.error) {
@@ -151,7 +175,7 @@ static void init_sbi_dbtr(void)
 	} else if (!ret.value) {
 		pr_warn("%s: No mcontrol6 triggers available.\n", __func__);
 	} else {
-		dbtr_total_num = ret.value;
+		dbtr_total_num = min_not_zero((unsigned long)ret.value, dbtr_count);
 		dbtr_type = DBTR_TDATA1_TYPE_MCONTROL6;
 		return;
 	}
@@ -166,7 +190,7 @@ static void init_sbi_dbtr(void)
 		pr_err("%s: No mcontrol triggers available.\n", __func__);
 		dbtr_total_num = 0;
 	} else {
-		dbtr_total_num = ret.value;
+		dbtr_total_num = min_not_zero((unsigned long)ret.value, dbtr_count);
 		dbtr_type = DBTR_TDATA1_TYPE_MCONTROL;
 	}
 }
@@ -320,6 +344,36 @@ static int rv_init_mcontrol6_trigger(const struct perf_event_attr *attr,
 	return 0;
 }
 
+static int rv_init_icount_trigger(struct arch_hw_breakpoint *hw, enum dbtr_mode mode)
+{
+	unsigned long tdata1 = DBTR_TDATA1_TYPE_ICOUNT;
+
+	/* Step one instruction */
+	tdata1 |= FIELD_PREP(DBTR_TDATA1_ICOUNT_COUNT_FIELD, 1);
+
+	switch (mode) {
+	case DBTR_MODE_U:
+		tdata1 |= DBTR_TDATA1_ICOUNT_U;
+		break;
+	case DBTR_MODE_S:
+		tdata1 |= DBTR_TDATA1_ICOUNT_S;
+		break;
+	case DBTR_MODE_VS:
+		tdata1 |= DBTR_TDATA1_ICOUNT_VS;
+		break;
+	case DBTR_MODE_VU:
+		tdata1 |= DBTR_TDATA1_ICOUNT_VU;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	hw->tdata1 = tdata1;
+	hw->tdata2 = 0;
+
+	return 0;
+}
+
 int hw_breakpoint_arch_parse(struct perf_event *bp,
 			     const struct perf_event_attr *attr,
 			     struct arch_hw_breakpoint *hw)
@@ -372,24 +426,28 @@ static int setup_singlestep(struct perf_event *event, struct pt_regs *regs)
 	/* Remove breakpoint even if return error as not to loop */
 	arch_uninstall_hw_breakpoint(event);
 
-	ret = get_insn_nofault(regs, regs->epc, &insn);
-	if (ret < 0)
-		return ret;
+	if (have_icount) {
+		rv_init_icount_trigger(bp, DBTR_MODE_U);
+	} else {
+		ret = get_insn_nofault(regs, regs->epc, &insn);
+		if (ret < 0)
+			return ret;
 
-	next_addr = get_step_address(regs, insn);
+		next_addr = get_step_address(regs, insn);
 
-	ret = get_insn_nofault(regs, next_addr, &insn);
-	if (ret < 0)
-		return ret;
+		ret = get_insn_nofault(regs, next_addr, &insn);
+		if (ret < 0)
+			return ret;
 
-	bp_insn.bp_type = HW_BREAKPOINT_X;
-	bp_insn.bp_addr = next_addr;
-	/* Get the size of the intruction */
-	bp_insn.bp_len = GET_INSN_LENGTH(insn);
+		bp_insn.bp_type = HW_BREAKPOINT_X;
+		bp_insn.bp_addr = next_addr;
+		/* Get the size of the intruction */
+		bp_insn.bp_len = GET_INSN_LENGTH(insn);
 
-	ret = hw_breakpoint_arch_parse(NULL, &bp_insn, bp);
-	if (ret)
-		return ret;
+		ret = hw_breakpoint_arch_parse(NULL, &bp_insn, bp);
+		if (ret)
+			return ret;
+	}
 
 	ret = arch_install_hw_breakpoint(event);
 	if (ret)
@@ -400,6 +458,79 @@ static int setup_singlestep(struct perf_event *event, struct pt_regs *regs)
 	return 0;
 }
 
+/**
+ * icount_triggered - Check if event's icount was triggered.
+ * @event: Perf event to check
+ *
+ * Check the given perf event's icount breakpoint was triggered.
+ *
+ * Returns:	1 if icount was triggered.
+ *		0 if icount was not triggered.
+ *		negative on failure.
+ */
+static int icount_triggered(struct perf_event *event)
+{
+	union sbi_dbtr_shmem_entry *shmem = this_cpu_ptr(&sbi_dbtr_shmem);
+	struct sbiret ret;
+	struct perf_event **slot;
+	unsigned long tdata1;
+	int i;
+
+	for (i = 0; i < dbtr_total_num; i++) {
+		slot = this_cpu_ptr(&pcpu_hw_bp_events[i]);
+
+		if (*slot == event)
+			break;
+	}
+
+	if (i == dbtr_total_num) {
+		pr_warn("%s: Breakpoint not installed.\n", __func__);
+		return -ENOENT;
+	}
+
+	raw_spin_lock_irqsave(this_cpu_ptr(&ecall_lock),
+			      *this_cpu_ptr(&ecall_lock_flags));
+
+	ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_TRIG_READ,
+			i, 1, 0, 0, 0, 0);
+	tdata1 = shmem->data.tdata1;
+
+	raw_spin_unlock_irqrestore(this_cpu_ptr(&ecall_lock),
+				   *this_cpu_ptr(&ecall_lock_flags));
+	if (ret.error) {
+		pr_warn("%s: failed to read trigger. error: %ld\n", __func__, ret.error);
+		return sbi_err_map_linux_errno(ret.error);
+	}
+
+	/*
+	 * The RISC-V Debug Specification
+	 * Tim Newsome, Paul Donahue (Ventana Micro Systems)
+	 * Version 1.0, Revised 2025-02-21: Ratified
+	 * 5.7.13. Instruction Count (icount, at 0x7a1)
+	 * When count is 1 and the trigger matches, then pending becomes set.
+	 * In addition count will become 0 unless it is hard-wired to 1.
+	 * When pending is set, the trigger fires just before any further
+	 * instructions are executed in a mode where the trigger is enabled.
+	 * As the trigger fires, pending is cleared. In addition, if count is
+	 * hard-wired to 1 then m, s, u, vs, and vu are all cleared.
+	 */
+	if (FIELD_GET(DBTR_TDATA1_ICOUNT_COUNT_FIELD, tdata1) == 0)
+		return 1;
+
+	if (FIELD_GET(DBTR_TDATA1_ICOUNT_COUNT_FIELD, tdata1) != 1)
+		return 0;
+
+	if (tdata1 & DBTR_TDATA1_ICOUNT_U)
+		return 0;
+	if (tdata1 & DBTR_TDATA1_ICOUNT_S)
+		return 0;
+	if (tdata1 & DBTR_TDATA1_ICOUNT_VU)
+		return 0;
+	if (tdata1 & DBTR_TDATA1_ICOUNT_VU)
+		return 0;
+	return 1;
+}
+
 /*
  * HW Breakpoint/watchpoint handler
  */
@@ -460,7 +591,10 @@ static int hw_breakpoint_handler(struct pt_regs *regs)
 
 		if (bp->in_callback) {
 			expecting_callback = true;
-			if (regs->epc != bp->next_addr) {
+			if (have_icount) {
+				if (icount_triggered(event) != 1)
+					continue;
+			} else if (regs->epc != bp->next_addr) {
 				continue;
 			}
 
@@ -477,7 +611,10 @@ static int hw_breakpoint_handler(struct pt_regs *regs)
 
 	}
 
-	if (expecting_callback) {
+	if (expecting_callback && have_icount) {
+		pr_err("%s: in_callback was set, but icount was not triggered, epc (%lx).\n",
+		       __func__, regs->epc);
+	} else if (expecting_callback) {
 		pr_err("%s: in_callback was set, but epc (%lx) was not at next address(%lx).\n",
 		       __func__, regs->epc, bp->next_addr);
 	}
-- 
2.43.0


