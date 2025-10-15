Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66229CCD199
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6D138E0065; Wed, 15 Oct 2025 14:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58538E0005; Wed, 15 Oct 2025 14:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91FC68E0065; Wed, 15 Oct 2025 14:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 71B2C8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:13:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 183D8577E2
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:13:52 +0000 (UTC)
X-FDA: 84001147104.12.C03ECA2
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2D6D280013
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:13:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=dXQaeGmj;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf02.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
	b=aEx5iOG6r7Be0u/AaFRx8ZzBDgxEfmCpZY4LkdG2f54xu7orTtd750Jrlfe9tN3ufgtPNJ
	zsxfgRsnLsuoJ0iBFezWNme41cbzxMzyE91i/KrmxYq2KWga4bC8haqgG3pCLcmZIbmi0g
	h2/uFYW5jAa2jm2Abo7G7RDLIE7vgsc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552030; a=rsa-sha256;
	cv=none;
	b=H2ffVbG2kIkVxDrldLmTSa/0BeJQKwt6Vb1gpCnq6RRzOm96Q6PnIqyTfiOarOAKdwHgaW
	QTX3y121IJG0SIZyYhf/4Cbrn0aI7qklnrAlT2bMAfA/G6ODAnMgqoYYa5uP3xhwgjtTt0
	1wJaHKAAL4Qtyh3RdsQIN5qJIZ1yem8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=dXQaeGmj;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf02.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-279e2554b6fso51740295ad.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552029; x=1761156829; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
        b=dXQaeGmjgVKUNBQh5VKRlQeW1L1tkx8BBgT+w9DYKobPcW+7l2DKtFyRSSvnzaTtq2
         1Y80r6Gr3lWgXVRwd7DKPPU1Wj398PR/ORgTNoFfspaEaB8TXP+zKGt4ya0vl2s3yucc
         nFMzhTm1db8962H7/BydjwismKIqHiw0hFIWW1x9N4In0jB9SCPZMk3Unib32m52hAvi
         ZMjii+0COc/traij/7n+J+HgfryB4ogF9cJexL5Mhir+YWe/eEGXRPn8r5t7oDtX7cP4
         Is/JBIpX1MpVTVntnh8y/B5U1zS4UTbdRpY+xVKhugfFmuTy4/SdukdH5uBnkE0N45rJ
         YC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552029; x=1761156829;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
        b=A2hT29pHY8GXLFtFIxNuGnyo9dLGvDJgqnEZPz/bVpqGQS7hYK/Njtv8VtH3A8u70w
         FOXTwAWKQ6CtawjBH5q4RpGL0LPtBozC3XaEqkl/D0BQC/RYIStg2drKQr75wtRHFOM2
         R0VR0mm26+TWYHt+NPALzmMGOFWkYkP9Vm0ny6t5w46lb4+GhaFDRq/lK3SJfFK5c3cr
         92dhV5CKTxK0A6UVcSyJTTmCIpR15qTz5zKpxESU0KJ/DszPZR2Cb4i/WEFFQ02wNeKl
         LTgxaZaEjknkqEl1SZOWvr2Vhrdat0NilbABcvXHI8u7X4k0eg3h/mx9Si0WY2dmS2j8
         SR1w==
X-Forwarded-Encrypted: i=1; AJvYcCU7Hw7L2YRTrNEZa6fdWhRN4UXEzLrgXoXxNCFn78KNdRfQNKMy5g3+h7w8KOm8GcE6MqsJPolmMg==@kvack.org
X-Gm-Message-State: AOJu0YxjcwjI3PfckNhMdX+zMokErL4KEGGaSDQnOJyTxad2DMx5TDXP
	YzMhPEiyTEAp/dkHVXosM74mia4rIJNYvtf32KF9yTRiZDCWlPDWW7Er//wr1J2lLIrjMUyUN3D
	rlvAa
X-Gm-Gg: ASbGncu7Emov2HheSQDRkwHHHdkZIk8wnxUPdAuKTOH6Ci7l3VlMscCXOP/nIZM4YBS
	DYHDZ9GuD6L0TeSQ076xrdAL8uiixwxKPybcXqSXRUCBwo9Zcsz/uy2agpHMewBsqKTV617U3P3
	ORTWlSuGhQCAOAGQhVwnBoTVLZJ8ccBrWj/hApw3ZLO+U8VyB9R6dGUvZuaxC3WUVyx9ZKbOzBD
	CWHJMk36EgzsGa0Mn6RMiOSBzEsCKI/Onk1wlS7dYxntId+IjKM/8YHvlpx7vFqngc9TVR6RArY
	tCYTE+5q6oE0q9Ko4pYQAEKkojTc5M10gLJQ/9odtZ8tjHalMeS/UUHV9SVkoTy+LFrIl/wm8pY
	vKPoE6p4N1UnJtSwlFir+1oJBN1Gm1NLtzQps+wiWploKCwkLanI=
X-Google-Smtp-Source: AGHT+IGLJo6dWzbyiMLfZeqj0X7MFaITDk1+T71ftISWllJONzXEpgCvzxXwD6lN4wBAx5b9omdSsw==
X-Received: by 2002:a17:903:2d0:b0:25e:78db:4a0d with SMTP id d9443c01a7336-290273eddd5mr362160075ad.36.1760552028613;
        Wed, 15 Oct 2025 11:13:48 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:13:48 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:35 -0700
Subject: [PATCH v21 03/28] riscv: zicfiss / zicfilp enumeration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-3-6a07856e90e7@rivosinc.com>
References: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
In-Reply-To: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam01
X-Stat-Signature: m87edbq4apt9xbujxfj4f5npza3wgbyb
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D6D280013
X-HE-Tag: 1760552029-279948
X-HE-Meta: U2FsdGVkX18eMrsRdK15Gp2edxAvKdN5SnresZB1NiOo64S/jIO1CCte/EmfRtOelwiomIEY71UxeD+C6gdckyELIOF1eVJZDGxGVyKuYe0GmvTCEWFotf98WcRt/eL962pxaZQBvcVf/zQOZuNEUryyLOrwpxYAY8VBWKGR4LiS8ub3OJqbP0qZItQn4YcsA3oi3LAnDt2JVceVeIZwPy2wqbc+5KQwiwYPx9w7RqFypKsgq4rQsB3PMXRr5XOX5QddHhbDrt7hTpHnvm7mUChX4PnwMxXCqZ1Z1TqAMZFGMLuTwpzVNwEE3HlpiCoZuk1RWqt5uoYBKXpsllbfz+p2i1+I5esqzeMP//r/ncI4z5/u2c4pJ5cese4X9vsHjXTgzMR8kbAq1LNPdUK20O9bqWcgOWlm11tLc8mU67xhrNfbv1en272ort28HbFVukUzn26O6ARbTjVke8DPFlr4bgJ7YjFRJlB3nSuk6HB+xqx3c7mBLTH1GriL0Z92rNuzimvVkS+/Z1nn9+V00mXSHSh74qjEH7tj9KzHu74BdTBScQldrb3BpaZRdlWuRFSY3K3IIKL1jE91OCYZlF8jUl4QhYmq2IBM04gpyx7EhpSDoEPiEsIzID6yFn3ilffqtbgPsI/58jeKMvfbpFt2blsaWgy97beExoxafsXq3Nb6ca2InBV+uCtvKixjz74ofERLrIYTON/IIaKGywb/WasFHMiJlm/gBYY3dpmURtPuyF4OxFi3J1SKgLKbMOprw7W+NaTQh0ySAE13y42N4F/muKjfOBP/e92rvmTGrJ3pozamzPtt9SjRG7LEB1fz2Bb5fonm3oeDaDVR4xB/nfYO97lAvBbqK3ojL9Ca1ioQJgQ3M+HKaL1Qj6k+6xS15/Le6bUBiqJLhaBv56/XFotR2hjsKWEc/DSvm6lIkuDLToveJ6r9tR3x5r+Q+IvnSg1oMXq/cqbz4Ef
 LXfMc1na
 S499Kf6TmyxOBvcQ8Y2p+1QylrWi7Z1bmICdSS3PtCTfiRUjL3mjLGW4tegC6ZLSTwtutaIHoYq/FfnSZzh7b3uDBQxMzt8goT5lw1lrCefLzHXqkaof/zhcqax2B+el0HVWCrXM9S3MoX2acPbqNokCk6aJYY9R8QAR8nCkweXRrhbjsEDVxf5ofWzy6mIbCENKvai9DdaLh38nzio8hD1svB/5VFcXFjhC7xxykubSZodE+Oon2bFVD/7jbGEbvtGeoBNWvisOR0faO5BZzQTF+85bagqNNuakHiZ2QtUamUEtXGldGpG+7tQasxCJcbyC7Q56HjkWHL5QLRpjd5RBTjKA9fsFtOTI7hQn5Kj0YlGJwxMeToFmueo7PDyXChE7zlHlTEylnIGjKe4J8/JiAnc1OhwvyLI6N7i+6ShgaEXa7WgbiH7RdBLkK/79x35d2OsPxrZStQiFNr4szogGPkCXYwldRjRQa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds support for detecting zicfiss and zicfilp. zicfiss and
zicfilp stands for unprivleged integer spec extension for shadow stack
and branch tracking on indirect branches, respectively.

This patch looks for zicfiss and zicfilp in device tree and accordinlgy
lights up bit in cpu feature bitmap. Furthermore this patch adds detection
utility functions to return whether shadow stack or landing pads are
supported by cpu.

Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/cpufeature.h | 12 ++++++++++++
 arch/riscv/include/asm/hwcap.h      |  2 ++
 arch/riscv/kernel/cpufeature.c      | 22 ++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/arch/riscv/include/asm/cpufeature.h b/arch/riscv/include/asm/cpufeature.h
index fbd0e4306c93..481f483ebf15 100644
--- a/arch/riscv/include/asm/cpufeature.h
+++ b/arch/riscv/include/asm/cpufeature.h
@@ -150,4 +150,16 @@ static __always_inline bool riscv_cpu_has_extension_unlikely(int cpu, const unsi
 	return __riscv_isa_extension_available(hart_isa[cpu].isa, ext);
 }
 
+static inline bool cpu_supports_shadow_stack(void)
+{
+	return (IS_ENABLED(CONFIG_RISCV_USER_CFI) &&
+		riscv_has_extension_unlikely(RISCV_ISA_EXT_ZICFISS));
+}
+
+static inline bool cpu_supports_indirect_br_lp_instr(void)
+{
+	return (IS_ENABLED(CONFIG_RISCV_USER_CFI) &&
+		riscv_has_extension_unlikely(RISCV_ISA_EXT_ZICFILP));
+}
+
 #endif
diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index affd63e11b0a..7c4619a6d70d 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -106,6 +106,8 @@
 #define RISCV_ISA_EXT_ZAAMO		97
 #define RISCV_ISA_EXT_ZALRSC		98
 #define RISCV_ISA_EXT_ZICBOP		99
+#define RISCV_ISA_EXT_ZICFILP		100
+#define RISCV_ISA_EXT_ZICFISS		101
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 67b59699357d..5a1a194e1180 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -274,6 +274,24 @@ static int riscv_ext_svadu_validate(const struct riscv_isa_ext_data *data,
 	return 0;
 }
 
+static int riscv_cfilp_validate(const struct riscv_isa_ext_data *data,
+			      const unsigned long *isa_bitmap)
+{
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int riscv_cfiss_validate(const struct riscv_isa_ext_data *data,
+			      const unsigned long *isa_bitmap)
+{
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+		return -EINVAL;
+
+	return 0;
+}
+
 static const unsigned int riscv_a_exts[] = {
 	RISCV_ISA_EXT_ZAAMO,
 	RISCV_ISA_EXT_ZALRSC,
@@ -461,6 +479,10 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA_VALIDATE(zicbop, RISCV_ISA_EXT_ZICBOP, riscv_ext_zicbop_validate),
 	__RISCV_ISA_EXT_SUPERSET_VALIDATE(zicboz, RISCV_ISA_EXT_ZICBOZ, riscv_xlinuxenvcfg_exts, riscv_ext_zicboz_validate),
 	__RISCV_ISA_EXT_DATA(ziccrse, RISCV_ISA_EXT_ZICCRSE),
+	__RISCV_ISA_EXT_SUPERSET_VALIDATE(zicfilp, RISCV_ISA_EXT_ZICFILP, riscv_xlinuxenvcfg_exts,
+					  riscv_cfilp_validate),
+	__RISCV_ISA_EXT_SUPERSET_VALIDATE(zicfiss, RISCV_ISA_EXT_ZICFISS, riscv_xlinuxenvcfg_exts,
+					  riscv_cfiss_validate),
 	__RISCV_ISA_EXT_DATA(zicntr, RISCV_ISA_EXT_ZICNTR),
 	__RISCV_ISA_EXT_DATA(zicond, RISCV_ISA_EXT_ZICOND),
 	__RISCV_ISA_EXT_DATA(zicsr, RISCV_ISA_EXT_ZICSR),

-- 
2.43.0


