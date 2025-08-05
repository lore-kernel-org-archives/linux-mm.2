Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6E1C87FD2
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 19:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A54136B00A1; Tue,  5 Aug 2025 15:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A039F6B00A2; Tue,  5 Aug 2025 15:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC886B00A5; Tue,  5 Aug 2025 15:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 784DA6B00A1
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:40:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E83BB1601FD
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:05 +0000 (UTC)
X-FDA: 83743719570.07.525FEC0
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id 148361C0008
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=OiJgFPfe;
	spf=pass (imf18.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754422804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBx+S5U+eiCq8pUooPV2kB8TZrzcZaWUvNy/30cjCv8=;
	b=GCqoulIQDs16q1ujghGXl+L37xWKr4edz4FXPz3lX0msJ/XGgsWtdHEXmtXzRerrYcdqPp
	1lpXmlbKVs4bxL6S8bdFzKGrD+mEyiQ4ApnQdeW5YAlngz1Z2GieDV3QYGTOyrHfVt5rD5
	yeA2mxxo9otE57Yz17TE1I/W2g9UFlU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=OiJgFPfe;
	spf=pass (imf18.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754422804; a=rsa-sha256;
	cv=none;
	b=WO/LMAaJrXwy6x4KF36WH0Pk4s+vDJ/e+3vv0xDLtzp058DkKQSeNcePvA2Ko78FBy9hKf
	W21d2qXk6XwkJVQKZJJ1eFKn1xZPJXcWQdx711/f2yWw8kO38c6FL6UQ9PQTjxT9F3o/L4
	a5D/fvm9tKwJNT9u08xWrKY1z9dEkng=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7e8053d3382so27229085a.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 12:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1754422803; x=1755027603; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MBx+S5U+eiCq8pUooPV2kB8TZrzcZaWUvNy/30cjCv8=;
        b=OiJgFPfeHkxWRHCcEtgJ8vpPP4HGvckx9O0mO8FWzQ2z422tRh/PBHz74DA35wPPmn
         aoba+w9Wt31J4/Dtx31CAFgj2ZU8BwtZX+KfnVMv6yGH09BFRwbkX1rkuM0ETSftrXiZ
         jJql9K82qacBns2rY5sUncNsPI9OZOCywPSF9iFnPw3B1h7hhvPzdcjGCQs1SI78+Eg3
         ixUssaBzwHimgVoeXNNj64nG1qqILpFFWpp/mZuOE9o3YgrQP7+PCFgDvj7rG8ZyHVwq
         m5ywCb1l9jRrjaFJyQ/u6NxsVwsxRnd6yExs1QdMHETZ73Y9l2FG16wKXcy/iBqJYBM4
         gE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754422803; x=1755027603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBx+S5U+eiCq8pUooPV2kB8TZrzcZaWUvNy/30cjCv8=;
        b=u1UGAA3yBppqNu5708E4FmLnQYEa55kSCV8Jm1bAGcNrUP68DzoXsANqEwaIXbHyFZ
         pSUQ5fh+bKv/chm0aDoJb5xMD15fUn2DlTA0wMGSzTNCtpTPnqiClj3wQ0+UrYXdOTPa
         Od76xQNGh0iAySLaUttq38jFXIBpmB9s0Gtck/bCGk4UjFRmdunVj1LDz1qh5LWQvwdT
         cSIJCHCfUYzlso2aUofLln2PNYX3SBHR6oGlWe5UkDL9p1fj7UljBXltYZvIpZm1DBaK
         sta/3Vb44SDfzt/3NpRD6aurI7XeaeFg02+vcvVAI2Q/Ra9Zfd1UjseTfgN6IFNY3ic1
         2cWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmMT4scXVyMK2nNkpd6yCDEkd0K9GN6HgFR8c7R97xQlW7e58IInfhjYjChdP6qX4z9DjAU+yCeg==@kvack.org
X-Gm-Message-State: AOJu0YzzIKK8QZ8PKs1DWiSUAFuX7DuVonK7RbVHr9pecbU3tSSlFki2
	SUpD+zgTHqg/VeYVk7EaQmxZYz+3TO9h+X8etxWQFzmzOKZsXT4K5+2Hvg4L+ZJIv/c=
X-Gm-Gg: ASbGncsKrbz9AutnGDTw0fxpT9JfTwjCsoxl2On9wLdNRrQ+4mnSkiEWmI3IssecL6w
	3dBLBkOr0ho6SfWTvNHy7+I5LLWOXdjg3SwrjzfRTT1dIKazcPt45J31W7vGebpIZdEck5sclae
	vYB9mmsbEZUmlV2ukmg4SyB0MIwuB+g74fLgFp4ua01PafdLmRHtnpNEDf3Nd+/97re0VtQX11b
	1SSVQEmk01t8Z8vebn5h86JIOLKg0DOqDU8zxZvOuzY8TrhOdatFybhnDqY6MbNi4FDecfD0ekH
	0BqrnCqp7fiPTEeb9W6m8FvEVb4F+osNSgWutzNrd9BtaZ8rIQuZnBbWrTB4jX2HjAzLTkfnJRX
	zef2RUT4lW0ICejYMn3B5/lwobrgq5SY5pNW9fjni10I3Lis+ISRkTtC7tmprkYz1BshVmzKvIx
	M800pqPA==
X-Google-Smtp-Source: AGHT+IGX7OQglHEEPOq98awptA6J/9DSpmeeKDOZlvbBLWPX9HQBX2UPCjNuTmMSORoLz+090C2k2w==
X-Received: by 2002:a05:620a:424c:b0:7e6:99d7:3340 with SMTP id af79cd13be357-7e8156bcaacmr32337785a.12.1754422802272;
        Tue, 05 Aug 2025 12:40:02 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f7064b0sm717855685a.54.2025.08.05.12.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 12:40:02 -0700 (PDT)
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
Subject: [PATCH 2/8] riscv: Add SBI debug trigger extension and function ids
Date: Tue,  5 Aug 2025 12:39:49 -0700
Message-ID: <20250805193955.798277-3-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250805193955.798277-1-jesse@rivosinc.com>
References: <20250805193955.798277-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 148361C0008
X-Rspamd-Server: rspam06
X-Stat-Signature: i73d6tqw157fyd1ea5ksa9eq9hehs6hq
X-HE-Tag: 1754422803-153069
X-HE-Meta: U2FsdGVkX18xC+aeQA+GylwjnXFS6/JbDEnt9ClYTMKCZwiNxHoLVTu/r5yxLQYiHfoOq91t33qj7Rgzfd3870kc2dr1aCVCXxE/qODTMcbkbIQAdZs63msJAQSXA3knlEXEjN8fvCbTPiiSd390RDn88nCJjuBydrNszPXzoHm28q0hIk7xIpHzGRX9whf8n6H49foet8vc8vM0wTP5iuI4R9yDiQQ0GO6hQopPrhE2plHK3N1sS8j1x97rFvzW/yaCCHInoqRVn/p6ie+rpgBUXJzoNA9DVPKcbGdhUEoz/GDDiYLw6Mk9cR8xs8r9+oX4vjqkM+8tzrufu+zNVUflkkZz4QDgrSLTeH6bww+PjcRWYceop5Dt8k4MR+FU1ZoyyitJJ/ZUtgingWB2+CTLtOKDURgSiHkt6aYX/EQJ+ul0MzBQg+94fhxTZ//T+2Z8CAHhiAicc03gfppMPsT3DpvC/CSnpqbNCtBtI73EIbMQCG6z09AIALt7ZkasgJKqyXvqQhH6VOW5QXEZU8digjhqdcneBQRjOWJhMYNm7IsBsynfJg2Aj8z/nKvCWaVO47/k9at7WqAFiRsSO1/OtEtksTxfXKOA+uxBsqUJLlXTYGqaYL2htsPPxibN/LNR7zYZ9B4Gc9z2osOlGciKlqHGK4tRcQY++MlYS1m5lZIT/vsNMrDMfwy+vJKSRY/5YXNLZWpLXeDoM8LwKo31MCPKQ9ibethQerULRBK5Ctd3QGkbWivKmDaRFRGCfjs2kiAquK6XCsbTq9S8CSG9pHqTOlVrSzHg3Xv3EynlZGJFH6R0F+nxvBJyxoHtWE5xnTYBRLNsny6nfE97HYLIIt1weBVWfdsL9gkqaFV1em4Tc5wshjv8W2nQXNKPauWL6nDKWHYEiKGhkq96H+9x0n2biS+G4CuaZ52shgfeuC1TUMwTsV+eCeuRixwKoiIJtz6eaaNd6GW3Zf7
 lquGy9sX
 eWMzlreWCGJVjCfQvgwvFXuhXziGy1c4zW6nX3ejD8F/FgnfcB7+W5sB0Z4AIlN3FLUlox3WU9bCpOcvwSlQsg8/EQlIK773XpHp7XAYJAATVRGyEwfCzdjaSGDaMy3ZAtDCWuC3CFq2gAcCtrQn8kmr+is/cC6Fo7pxAeFqUEL3TEqPsSFLGuYAV5EfzqJPjNziousmRIcaRPECBJf+dM5h1yrPrglX7qvPwdIbun4+DHTL3zqxA5OP+R2WmKVtvndUwD86Kfem/KJo8soGrdNJz7yMboRO2MasSxiwiA+xpwDU63YzolAKdGKKqDB8ZCKWU7XWXhOVS72wXx7NDVnIkguNS0BQCvmFtAm9ZGXea9ZMLZ3EDFU+haQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Himanshu Chauhan <hchauhan@ventanamicro.com>

Debug trigger extension is a proposed SBI extension to support
native debugging in S-mode and VS-mode.

The proposal for the extension can be found at:
https://lists.riscv.org/g/sig-hypervisors/message/361

This patch adds the extension and the function IDs defined
by the extension.

Signed-off-by: Himanshu Chauhan <hchauhan@ventanamicro.com>
---
RFC -> V1:
 - No change
---
 arch/riscv/include/asm/sbi.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index 3d250824178b..be2ca8e8a49e 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -35,6 +35,7 @@ enum sbi_ext_id {
 	SBI_EXT_DBCN = 0x4442434E,
 	SBI_EXT_STA = 0x535441,
 	SBI_EXT_NACL = 0x4E41434C,
+	SBI_EXT_DBTR = 0x44425452,
 
 	/* Experimentals extensions must lie within this range */
 	SBI_EXT_EXPERIMENTAL_START = 0x08000000,
@@ -402,6 +403,34 @@ enum sbi_ext_nacl_feature {
 #define SBI_NACL_SHMEM_SRET_X(__i)		((__riscv_xlen / 8) * (__i))
 #define SBI_NACL_SHMEM_SRET_X_LAST		31
 
+/* SBI debug triggers function IDs */
+enum sbi_ext_dbtr_fid {
+	SBI_EXT_DBTR_NUM_TRIGGERS = 0,
+	SBI_EXT_DBTR_SETUP_SHMEM,
+	SBI_EXT_DBTR_TRIG_READ,
+	SBI_EXT_DBTR_TRIG_INSTALL,
+	SBI_EXT_DBTR_TRIG_UPDATE,
+	SBI_EXT_DBTR_TRIG_UNINSTALL,
+	SBI_EXT_DBTR_TRIG_ENABLE,
+	SBI_EXT_DBTR_TRIG_DISABLE,
+};
+
+struct sbi_dbtr_data_msg {
+	unsigned long tstate;
+	unsigned long tdata1;
+	unsigned long tdata2;
+	unsigned long tdata3;
+};
+
+struct sbi_dbtr_id_msg {
+	unsigned long idx;
+};
+
+union sbi_dbtr_shmem_entry {
+	struct sbi_dbtr_data_msg data;
+	struct sbi_dbtr_id_msg id;
+};
+
 /* SBI spec version fields */
 #define SBI_SPEC_VERSION_DEFAULT	0x1
 #define SBI_SPEC_VERSION_MAJOR_SHIFT	24
-- 
2.43.0


