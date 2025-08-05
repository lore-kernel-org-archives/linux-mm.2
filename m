Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7655CA0EC0
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 19:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD67F6B00AB; Tue,  5 Aug 2025 15:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86E76B00AC; Tue,  5 Aug 2025 15:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4FC66B00AD; Tue,  5 Aug 2025 15:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AC5B26B00AB
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:40:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5280980E0E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:12 +0000 (UTC)
X-FDA: 83743719864.10.9FAEAEF
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 69B311C0011
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="Df9o/yxN";
	spf=pass (imf18.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754422810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=thXWESjgb/asehL5NdNra0dnr/Mi+exiNBPp9wa9z9w=;
	b=bryksBpTos7WxVgLsaQXmSNAeyeSNTwKo2M1XLVwWrW5X9OMY+41dUNfv+KB1LXMZR2Luz
	Jnsyd5LWsSqmRSXiu1AJ4skvjrV2Gmwxm0f2voM2XiMazHVcpVXFoLQm1I5BUvwdyqUV5V
	nvpbFgPoAJS+n/5cRTZSL5wiMuSTWqI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754422810; a=rsa-sha256;
	cv=none;
	b=OoUygksVS+lE/UjHQerT0J+xGMjEGV3U12UV45gdplcblKyRnqZRYxRmtuNgTR3300Hl00
	WYCtL5Z2Bcb+BzxSbgtQwy+Dhc1c4LPbQiW3XHkGbtxIc7CdFuSHxH6r39+0vgCqIXQzbt
	svjVPqFbnszbTSq+cSHcVL/mUN9E26c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="Df9o/yxN";
	spf=pass (imf18.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=none
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7e32cf22fdfso540782285a.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 12:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1754422809; x=1755027609; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=thXWESjgb/asehL5NdNra0dnr/Mi+exiNBPp9wa9z9w=;
        b=Df9o/yxNRD3fftVPPC/7IIq5Kcq1AfiqV/NrUQ5oTSSSfCh4DolG3nliVuvRVOgMei
         vwBZWUL9QbFgccDKjlrsgRWmW05Kt6t7v4oFgJM3zv9mNgZipYokXbBqLUgIb3KeHVIh
         XL1BuBC2FvK3r5rU3ujMkx7Pv3AwrMLMirfzos0VxZQVD54hi5053JPWjnGwRxA1YxUH
         o66CaSkSIVYf1Vn+UfM08A4OjCRgwfw6G8Hga/5L+zvggxsVXayytPxTK2UwgE7koZuF
         E6QVI/2MkB3rF7SGuz0Xh+yhczNd4jLbbZQhx7FX0A6qyC4L3YxSK0Rf0lMyeSw4C7KZ
         FRow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754422809; x=1755027609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=thXWESjgb/asehL5NdNra0dnr/Mi+exiNBPp9wa9z9w=;
        b=bwUOB+670tzcspphmi7FJRELggPq1CSFNv5gDWjFbWTrb0xwKGUfl3OjL3Q+fgrD80
         MFiFqZBTnIjB1ynQrJZZHWMnxKtuey4jx1UmjrNOG44gWDibbukdCDzixzJAx+27v+tn
         gf5DvgJBVO+OmzJifpc0MMHBMenoup2HFgCchwYSk3X4jOyxEI4TFMZvXUdWApfDZ/ft
         /yWbPGWljVsA8JprzbQTtZ1lAR5UlUCR4S/YVqBUmnayAuZpw6NzBQ8YkETyf96/sq+Y
         jV6CxmAuMsNN7mvbUXoRM2yuRd0KZR4CEttgiAlD681HT/ZLgUMsWbfNAT4qIRXhv97j
         AfUw==
X-Forwarded-Encrypted: i=1; AJvYcCVaFW5MkBcKS4TkNxESrOsdd2wqxCeEu3inxAKxjMhfNMk0x+m0N9oReQiJUeAlYiiJgfSA9af4sA==@kvack.org
X-Gm-Message-State: AOJu0YyvM6i3ZdGMTM386bElFF51JQ+f3uJHapSeT4FdI8bvEglKeOvF
	wQwTFdgBXblQPXsYtsPfGc+M2q0auulGCoAamsnv5fZB0AJe9eU+qYWFVPP9E/D8qyw=
X-Gm-Gg: ASbGncsxg3oUkBCSMYG69XIYwyzBgcZ6ksmfBQpRLPFiUd/OL+4OwKseMWdrbhexgAX
	EC3rzDjeXRundIgffAIhGAWObeDoJ1yO1xK+xP4b7Zik0ERr8X+0NMyhjDxdHtA830xY3ad6N7g
	SQB4/YitMfll9lIITHndPsvnjD4pA43JwMUb9Ds67gJF5qO3nU8YJdpRrDU8bnEzFP30pKYUt8j
	Xmjmv78o0OHI9qlIo8+/2coeInXqKYEdD4ubm5FIzePTFq2qxGlM5ldCzo2REtzj9U6DPFkpRa+
	VsN+G/GFJxBflFQNYj99TPvf1GXGTSrte3sax7D8IruoFUmzeMgEZuJGN9mjLqvau4diINjfCzd
	6JLS8SxUyN3AaohD/VvDnjT+b2kuRjw9EIPziVgLUE9v2m74T4oFUe+YsxkBkgQuwRZ7oxfo45y
	wPDiBeWSmAR4v0mQ4b
X-Google-Smtp-Source: AGHT+IHrWQTDjfjzvi15pRX0IO+g2I3D2NOE+Jn4xNMsUSUmEfPtUaNSg147K8LghQ8X7ApzfEv/sg==
X-Received: by 2002:a05:620a:15a5:b0:7e6:8147:e683 with SMTP id af79cd13be357-7e814e1cd24mr62137585a.47.1754422809200;
        Tue, 05 Aug 2025 12:40:09 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f7064b0sm717855685a.54.2025.08.05.12.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 12:40:08 -0700 (PDT)
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
Subject: [PATCH 5/8] riscv: hw_breakpoint: Use icount for single stepping
Date: Tue,  5 Aug 2025 12:39:52 -0700
Message-ID: <20250805193955.798277-6-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250805193955.798277-1-jesse@rivosinc.com>
References: <20250805193955.798277-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 69B311C0011
X-Stat-Signature: wow6mdtcuguou9rsaozgg9jei957nirb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754422810-779470
X-HE-Meta: U2FsdGVkX18yMvgMGcI2uTu+bVuImZaEpjMLFx1BYSZZJTU7r+kREJ172GtZq5vP7lD2pnX4DD53SojxI0JxS2ovNfiA5pHClwj1ZEX9yeZx/gCtdqCQnM2ieXFnTMW5rBHr3V624xI+mO44Uuiz+mNlhlUVlWUF6ESxwmwF7nym2Cpmwer9H956eQKNOxQYRqQMAxBUb7GaZAFcZFXlDvHdjXfXEnbP3PsN4/oGbNbUDjckW1pF7X6jw6PWeK/glmBQAgmSa+bXZotoVmF86frzd2kqhtJXl72oG3/9NyDX0jY6r8t+VV6vgU8lJgpdTov39hBn5hX81gGUn8iQXb8aYVJemARJPRk1AMVrXrl9S28kS5LOVJeI+tG5+SFbvZRnmKGvpG12spdYDl2o4ZboCC3kqM2wYgJQVrawTyyM9h6N27dJKSQsJhmIkDVpRw5DqPH7euoyXEyN93I80SdOISWSUIG0s+cYU3oSGNdgZgQh7KyEJJa5/SsBFr849YoSUzuJ8ezb+U8mPrAY0DXHoB1cU7nWFPZftKWuxtIn4AWqu/WkJIOOc31N2cki0FbBimNRmLyPyXZnNJLTlPVBamb0FuUtrzgc8rzllAXSgeUZ4fXhdkDIlrqa4p1Q+56DhrSO6xNwnEr1cO5g5BmO6nTujGmG/o1AAuwdvZJ96KXL6yMPVzVmQAirYMeTyc+HeU/U03gOj8SuLMzMECER1wq66rofFO3P9pZTtfr5+QcEQKlSGe4EcAz4gRndnEO7f2hTsF44Tom+QNCD7bK5pN1QRJQ+3g/awVxonazP3iZGjgoiSRCt/MEZHMFcd0apLnH1ybItMbtqbLe7rtEJLuCUX+xHlUjfL7T7rn0Rn/vDLoqMRwnwRLIIGg6aIg1FzuvX0wdZzPD7Jr2tMwPLFgeaEj8OZNDG5t9R/pYUEyGGC/piIm0YQBMwS7hrGnch/lPCV0ZY2G7m+Z/
 2dctd2C3
 E88RYdQB8Nt+g2VHDBP+SL6Q9csHu4ptiH8qSlz5+hA3yoSTtxXMeWnwM8+AWgCdOFOsPBdvll18Hy8Ezx88Vww3qOv9dmSLgwhxeFh73vNnRqXWBh54hrLlqCBTQzgQwpsAb02aq5HfQoHi+KIL0Q4dq7P53dj+vK9BKcnL/SFXQmAaa8EtieylRvJliqBhzETTJA00ZwIKciJmk6YKxNANaKj0liIsEUMZiSMCBeEC1kFS9Lqk1H3bL4/ZnLkx8aTDiV3r1e2qXrHVjTisB4grb+Gnyzhr20rXhHQG4VWQVtmjZeunKXiRJ6wst2t+hwDu/0Ns8yakU7uIWI2skXQWxjJcu3A+VWG01gojQywQsYo6VTGaUSTn1i8tdiow6KxuybRnjIJqfzJv5/6SmhQstlWnq2qDLxdfLwBmJViZ65+M=
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
---
 arch/riscv/Kconfig                |  11 ++
 arch/riscv/kernel/hw_breakpoint.c | 179 +++++++++++++++++++++++++++---
 2 files changed, 172 insertions(+), 18 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index fd8b62cdc6f5..37f01ed199f3 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -546,6 +546,17 @@ config RISCV_COMBO_SPINLOCKS
 
 endchoice
 
+config HW_BREAKPOINT_COMPUTE_STEP
+	bool "Allow computing hardware breakpoint step address"
+	default n
+	depends on HAVE_HW_BREAKPOINT
+	help
+	  Select this option if hardware breakpoints are desired, but
+	  hardware or SBI does not have icount functionality. This may cause
+	  unwanted side effects when reading the instruction from memory.
+
+	  If unsure, say N.
+
 config RISCV_ALTERNATIVE
 	bool
 	depends on !XIP_KERNEL
diff --git a/arch/riscv/kernel/hw_breakpoint.c b/arch/riscv/kernel/hw_breakpoint.c
index 3f96e744a711..1e70ef9e6867 100644
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
@@ -143,6 +154,25 @@ static void init_sbi_dbtr(void)
 		return;
 	}
 
+	ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS,
+		DBTR_TDATA1_TYPE_ICOUNT, 0, 0, 0, 0, 0);
+	if (ret.error) {
+		pr_warn("%s: failed to detect icount triggers. error: %ld.\n",
+			__func__, ret.error);
+	} else if (!ret.value) {
+		if (IS_ENABLED(CONFIG_HW_BREAKPOINT_COMPUTE_STEP)) {
+			pr_warn("%s: No icount triggers available. "
+				"Falling-back to computing single step address.\n", __func__);
+		} else {
+			pr_err("%s: No icount triggers available.\n", __func__);
+			dbtr_total_num = 0;
+			return;
+		}
+	} else {
+		dbtr_count = ret.value;
+		have_icount = true;
+	}
+
 	ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS,
 			DBTR_TDATA1_TYPE_MCONTROL6, 0, 0, 0, 0, 0);
 	if (ret.error) {
@@ -151,7 +181,7 @@ static void init_sbi_dbtr(void)
 	} else if (!ret.value) {
 		pr_warn("%s: No mcontrol6 triggers available.\n", __func__);
 	} else {
-		dbtr_total_num = ret.value;
+		dbtr_total_num = min_not_zero((unsigned long)ret.value, dbtr_count);
 		dbtr_type = DBTR_TDATA1_TYPE_MCONTROL6;
 		return;
 	}
@@ -166,7 +196,7 @@ static void init_sbi_dbtr(void)
 		pr_err("%s: No mcontrol triggers available.\n", __func__);
 		dbtr_total_num = 0;
 	} else {
-		dbtr_total_num = ret.value;
+		dbtr_total_num = min_not_zero((unsigned long)ret.value, dbtr_count);
 		dbtr_type = DBTR_TDATA1_TYPE_MCONTROL;
 	}
 }
@@ -320,6 +350,36 @@ static int rv_init_mcontrol6_trigger(const struct perf_event_attr *attr,
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
@@ -372,24 +432,28 @@ static int setup_singlestep(struct perf_event *event, struct pt_regs *regs)
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
@@ -400,6 +464,79 @@ static int setup_singlestep(struct perf_event *event, struct pt_regs *regs)
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
@@ -460,7 +597,10 @@ static int hw_breakpoint_handler(struct pt_regs *regs)
 
 		if (bp->in_callback) {
 			expecting_callback = true;
-			if (regs->epc != bp->next_addr) {
+			if (have_icount) {
+				if (icount_triggered(event) != 1)
+					continue;
+			} else if (regs->epc != bp->next_addr) {
 				continue;
 			}
 
@@ -477,7 +617,10 @@ static int hw_breakpoint_handler(struct pt_regs *regs)
 
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


