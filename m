Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC95ECA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:47:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E63998E00C0; Fri, 22 Aug 2025 13:47:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3B648E009D; Fri, 22 Aug 2025 13:47:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB59F8E00C0; Fri, 22 Aug 2025 13:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE40C8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:47:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76C11B785C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:25 +0000 (UTC)
X-FDA: 83805125250.16.1D988BB
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9BBC71C0014
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Wl3QAlgF;
	spf=pass (imf21.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755884843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QfYucjg1h8+O9tUzDFG8M32q+vBz17OTGpTy9qZYkXU=;
	b=T+HW4Ut1rUgmjCjoe5WXZwsR3w/kG/ZHrrYV5gf6ktWSMaDHEb/4vokYO5vY7JvDeiGclh
	qoMeaA6LqdOa5B/IO0ppbfxHrgmOuAFuAabbpypBkmrW+qB33bK5cWTAXyszmJX3J1Kjl8
	vsZqizBwdePtexD0kOWHjtPZh3jkTS8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Wl3QAlgF;
	spf=pass (imf21.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755884843; a=rsa-sha256;
	cv=none;
	b=5XGWIhVohz2TkrLs29qADz7b3cuxAX4z0I3xuw3GBwT2SMG61aRS80qfphyzrYHwuDZn+j
	HJmLSbl/qvE356rtVLlGwCmXt2EsvaU6pQ+ABrmwzbalcnrlVXlq4pdrgtDb30msLSVDHd
	m4ypq0J5nklcCyzWCkAyjeHI4U/xARk=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b10c1abfe4so37042811cf.2
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1755884843; x=1756489643; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfYucjg1h8+O9tUzDFG8M32q+vBz17OTGpTy9qZYkXU=;
        b=Wl3QAlgFcqiE/DuR1/eEW3IO2rbJSYEcWKA/3VwjfDaowkCW2z5av5B1muBL2wjmgq
         2zhpGHka0hZPt3jejYSYMrXvaSIZbzYfHzOxbuglTH61l3Ho/4nPru04eDVpweN4OnZW
         Vb0Tt1FJKHPfFuUmZ1zpv2FKzUp0hwllAM0/nx+pgPx80b+B6E4FrBqMK7AnsRtfq6bU
         w9BU2pW0qBaJiFymVinAtvyNFguVTUXk9eOQtTq37q2Ib7nUOXkgq0WFwGyFEE5sqw8l
         6yA05BO36eUb+nSbbj0dSW2ap9Bngl7kxEi2nhO13K/ZI/mGWH2/4zlljPRU2R7slhlK
         cruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755884843; x=1756489643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QfYucjg1h8+O9tUzDFG8M32q+vBz17OTGpTy9qZYkXU=;
        b=C+1bLwQIvF9BCO4LK9dkn0hnIPAWL02smK6fgmGGu1oOWPnNzqe8qlF+xsTvC2hoUV
         dMP4v4imbTKUewiBxbqi4QhdHRmO+j9LzsuNB7ryVBEyFjXkFBtdpu2vkAEhkpuGnU+z
         t+K3+EyiuPfyRo2TOQ4BAxxBE4i9jcPZI+6cxCAAGBGl9ITTwZL/1llQKDUS+eT4rAeK
         sC9AanTrA+buPNZqn4a7oM3JWy6A+f1tkT1uHgyVob7XGO47mhWQccXQ67Q2xgsbLDRA
         CDjOnSNg1f9r1lGZ9HJoqmkFurKaMjRlBnSM3Gsx1nU3nmjAfVbOvK4XPq0DDqi2cNK9
         Gd+A==
X-Forwarded-Encrypted: i=1; AJvYcCXmdjz0Orc0QGWb0DdSXokuZ28g4wpwGmQz9T2iI+3S/PM2KXC0MCILQohL/jNYxB/2VOgG2ant+w==@kvack.org
X-Gm-Message-State: AOJu0Yyf+VKAaGaXtidTmHuhCTa7tDSqg3Ct2+nTncaQ7LFrHc5yg/CX
	pwQXVfvmZS9+SmH9z41zCHG53JMw+QkbdOXA5wuac7CWkySUKTAsCvZtrPmSKuIlszI=
X-Gm-Gg: ASbGncsWYVR9g7XBM0Xxz6SK95oZ235UwXIV6jGSHg5L/Xrunsu9reNgzajdm5J5kr/
	xHtwah0fMxsk7dXbVQjV3tl1f7AlPbg+CQm8L2unno6tvQ5Ym1YR6m3zC1W4CDRdKw5RX4Ef6rC
	j5DCKY+LchLuCnx3T5CNPfnzjPL/il4GZOITxC+S/YzcDDPSQHHKGLEnSjkxB992z0ye/3h/VrX
	pQ7jtOghSRrPi7G3rdlpZVvf7+Q8R1FAiSEh4y9JlB+a6TxN3nRIu0NqwtCaT0uBxJrFA0vzuv9
	aqImxxpNGKH4hoAOC5dna3t2JovSFOoAMI8Gl0ueg7tXqXp+5Q6sHgZFmSV/CVODN4hYiE4ht2W
	nOeS+iI0V+4PBJGGCYhYF7mPCRiHK5kkRXhMJStTGNU0AdoX8khnpLDCr7EVDPlX74OHkikQpqU
	ry7JmciA==
X-Google-Smtp-Source: AGHT+IGIVSOen45mpOt0xYdR05GnbUoonndymEzs2Y2tUjKO6oUDKgrfkoqnPSp/0zNTXeE4BQVymQ==
X-Received: by 2002:a05:622a:2615:b0:4b0:75ed:bbf9 with SMTP id d75a77b69052e-4b2aaacb9dfmr44784981cf.33.1755884842505;
        Fri, 22 Aug 2025 10:47:22 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8e6023asm3121361cf.53.2025.08.22.10.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 10:47:22 -0700 (PDT)
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
Subject: [PATCH 2/8] riscv: Add SBI debug trigger extension and function ids
Date: Fri, 22 Aug 2025 10:47:09 -0700
Message-ID: <20250822174715.1269138-3-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822174715.1269138-1-jesse@rivosinc.com>
References: <20250822174715.1269138-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yz9mesfp6gzthwjgfepnkt3wk3d4kkzo
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BBC71C0014
X-Rspamd-Server: rspam05
X-HE-Tag: 1755884843-171078
X-HE-Meta: U2FsdGVkX1/OojmHg3GsVMsk5NE/a9dVKj4MoCPExYHdlJtnMf3B8sGJi3bvoOxupccp2+HVkyzOPOr2UAsrRJtEuMdNFNKDKB38dU2ml2CZxhs8ByokAMrOa+b2Zkhtqi64rLK7zT6qN6mdpeT0Cc6O+Z75oNC5DszuioKZapCSV7BVDFp0V3EaIOyCSx7canIYbaAj9S8cvdXz98Bn2kYkQnbSMvp+qk+ntuI+ZC7JXW72OLC64vc6zB/mQpXCFxVA+VXxT6eWPgbYHNcYFGEd4kgy4cRjPvvH6aeMlyMBvZyMI6OUSNqjGMEyd/d7OIbcpkawAi3FNEUd6fnL7YShxHyQT0WB3WpT0XnJfBTlNng9v7Xj7jiOfPYm7BKOPYVruf4hS1MMIQnvKkM+PWoLVvn0GSUpPuIExUVOHQy1giYzNwTgNZiC4S2OUsQh60mjiFxXA7oL6t+StnkcJl6hlrrgS5CR2xwn8EYFTH3wVcnzXJxK+DVya1kBXYCoUo7ZdnzyFdKH8UBGPkeiYDOheAjcDlZrI/TSZizBF+SZCPhrJ/aosA6sa2YMVwSgKPTe4m6q31EaMNZ2Kh/14kJkEudQ4PEdcEqc8Dfmc76SKRWEiVi/ZeygaMX2N/u4GpA7n4o8qJtxI42/L42tNGNAZoEXTPaDLaxQ8lsqmshwCDH0iB/c//scwyOH2ZQipbdoZlbwLCEce9DIzbHrseOV/qYYZXbpui/Fh4rLW1Mj7FhgC6sAHNpLxE1owOysS5O+Ez0MG9Kr+SkJs3FrIUhB3/q7UFGq/kBuPO8eVrRM2nsUR2oxyP/yk6xPtjMOjy8bGxdrRX4IDTUAMqhbbAZqvWcyFpADPfl06tdXaY0H74GvocqQ678a9QdFH1E93JGd2PXniL4F68QBuvWqsJulLnyNt+aD+YGTpi7EOX5J+syazQNph7tg0GkWrgrexzOReW6uXr6bOiK4bZ1
 tiHAVz62
 AhQhQHCTjd4rfHsOWr5myHSTvIhRYqKL4RyOo00OusltM4lq8UtkDJQ3fBJF5CMEG+NvGzUxVYdJ704qfELSCSPpNj+r2fCckvj1ekVuCuSlHfswLi2LP17kqet5IJzH6HM3FY9LSDSxVp+uKt3hlMVOoR5r0fRF9Fmp1QCkojpCQOock2BmaFw5P1+SNRXZ1LKDB1tPkbB+Ih1+kH3CwIjUnrGCC2AvB7f+CyireAKZyEnaS6+PZd4Z5O8d85NPDR5RwfMB0EHpssmHA3XbsQfGK7bx77oxXNVm2ydpM+vbmF8R/hqZaIVD0y4NtWpN1iHcihSoY6sL541azBKeVV/Q3hLaqa6yVGsbBaPCrJvepc6KYlzAzWh9Hsmf+zoPAnrFY/EiS3+Xi4ss=
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
V1 -> V2:
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


