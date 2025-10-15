Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6AB0CCD199
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34368E0078; Wed, 15 Oct 2025 14:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09A28E006F; Wed, 15 Oct 2025 14:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838198E0078; Wed, 15 Oct 2025 14:14:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 45ACD8E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E99C139AAE
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:35 +0000 (UTC)
X-FDA: 84001148910.01.B3C8B4B
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 09CD110000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=C7H0rY6F;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MB48/j6I+d/gCcARQ8TfLMiFMxnJjaIkZzUmXgVit+Y=;
	b=1FP0H92aJOEar7NeIrHjZLvZOrwdnMMcpwIO4rc7A95fED7p6JQQoL8VFKpUEFIAFxcGFP
	5KqgNE0l90Vi5A+pg+9nIyL9gc6dQunTalcsHVruaFGYoqothSH/NDlV4tYxJpYQBm5NNo
	pI5/AoQX/Rf6SZyOaCvteSU8UEcWQec=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=C7H0rY6F;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552073; a=rsa-sha256;
	cv=none;
	b=UDRMbglP8I6P/rOmqrxqaEwprgh6CQ/N5atOkTaROcqz4+5Or1q/xk0i1PI6kEZeJkRb4N
	4YRlum4Jon7558sRVml5coy5jh7ALxFFVP9H2E5n7tjHAYg+PKaSG8Dth4LHpvG8VSDip6
	13D8kJqDJE38MHwF+aAN/9Q7sKMg6WU=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-28832ad6f64so77372785ad.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552072; x=1761156872; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MB48/j6I+d/gCcARQ8TfLMiFMxnJjaIkZzUmXgVit+Y=;
        b=C7H0rY6FMn83T3thLzMvVUS435JxpflYiD8l8fQe4VwhUR49KQ1VIv9kflAZWl44EE
         AfUs4gLmKwhlV6p1jtl+/0cjuehHa1V6kXlWQc0ef1IPZRN36RyYYQEndOIL9+sL6vHp
         gTD5LbyMhsUyo8+XeOfsake654qPdbEt1h7F5EAt+qP+G30TlX2DvuNsIPxAFAoVtj/g
         QgUfZouYq1YycdppmlbfAmrzQ3scoVLeTgI/9JicN78sOBb0Z0IFoMkTTLeOxAmx6jqA
         y5+YnZs8vVEPd+5PtDBy41cvAW2sfJRFuItU6uJeOMSFm2/gGytyU6MIRX8/AcChBjFj
         Kmpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552072; x=1761156872;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MB48/j6I+d/gCcARQ8TfLMiFMxnJjaIkZzUmXgVit+Y=;
        b=ak7dagfgEIhRce7hcD6t89FmKdvD1/yScGdwPzrb1JTL04m6xloJXMPSogg2iXoRlT
         xmM/rx1/NdjdsH4gUD+8CPwAj0xu7Gu1KRf+FktTJL0/HlW2OBkWsue7jx1RvBAHf21u
         cK+roQSt6FyMuIjdBBWH2WHEgnbRm+GCIo7t6dNpAOeSC5e3nhA9f6riUVJS7oVwG22/
         iIuyd7c3Wp8+xqTKntfNwcvxZQ+dxObR5vyk98UTI/z+P5h8OSftMUEJbD9RER3Fbg4B
         r6WdD+159dI2Ye+O6QU897i8ehLXxM7XKJqmbCQS7x5HBB451k8PtRGRoIavEyChDP7i
         ko0A==
X-Forwarded-Encrypted: i=1; AJvYcCVIvafJdA6DlVf9iYhEKFyPeDX+AnoZp63105a4hDEdg6fjQlsxXC47hpXXOu/O8ImCPvdCAxNn+w==@kvack.org
X-Gm-Message-State: AOJu0YyA1G4DjLHTjOdnymmo7zt5n2MSBqEpIjLfnBW5yACINO4VnPuo
	xnUKswgy8A83BRPNlhEFGeHiSZygp3wu0ZtpccBt0FAOvKhRODlS5cTQpqm9Zt1deM8LBFK1nd4
	j7DOP
X-Gm-Gg: ASbGncsNLJwqn9h5Y/diO8TLkFYWFJtGKZd2uU0Gng0K7gXKwrWcHB5Q9dPjgRo9DSK
	yMqnFErmtxAc31ANArZ4DoV0BRXqdrg0uair+hpXXcnfg5Z50acgoF28J7437pzviHFwY2cnXde
	SUexTAsDNEPMrZ9V+Hp0xZSdkS5J9N1UglD7wfAzT0BXDNCZIHTGhBB6ktqFbpZNXrKQrXrVefg
	xhWjPqtUdj0N/2eeUIw3rakn5PfWTXlsjOEPb6gzp0OgxWhKlsLcVk0KhvO1JQskZZYOpYwo7xy
	Fm9fz8QMoTwRhwUI0oNESACPMm/SfFa47dYnuxdFul/sFZCnoqwfQW24LTrVxpRLRgW5/wbLwvi
	epF5Gp0bTXmrxGaMHZrGyVcC4qMpejpfidhRAxhfZN5/QdOHu/Yk=
X-Google-Smtp-Source: AGHT+IHT4WceIRdI7BzOsRLGnPi4SCm8uMKo9uLH04PZRO5LR0IGQ3DVJW0DhAWSyLls8tAW/d6Qaw==
X-Received: by 2002:a17:903:388c:b0:269:a4ed:13c3 with SMTP id d9443c01a7336-290272161edmr398577465ad.5.1760552071446;
        Wed, 15 Oct 2025 11:14:31 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:31 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:53 -0700
Subject: [PATCH v21 21/28] riscv: kernel command line option to opt out of
 user cfi
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-21-6a07856e90e7@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 09CD110000C
X-Stat-Signature: 5in8o139byaxf9oie3esrf7qdt8ahum4
X-Rspam-User: 
X-HE-Tag: 1760552072-171290
X-HE-Meta: U2FsdGVkX1+Pfi5aJNyQ1VMQtL+bFKdpjz5PClY6eXMk2BN+L3GWIxKMGk85hsD3QbM+g2Bcn5DmwQPTQlNu1nGqerb1yZDuAsew3yIQbBWKdi04QNjoIZFvGmBp2DuZIX8sro3FnR3thUVvXnCdAtcM3y8U6NGBqa5KRtQ7lgBifeQINwUhoNXH/Yoivu3swBkOIheA7Up4PzkVoOmD/3KeuAk1nxQzfn+9KIdiWa1PRdTyQWdmhLVpVaSUUr1fyxF3Aw+ICPT+YdAC45Cw+WMBYVUkmkVry9uZnWFyMcH86wbWFPyUfIp//BzQuefwbexwuVm2LJy9UparpPrx3PMlN/E9BRUx5vVcqp5KXKhnPP8PhyomYs75BJOvQg/H4HIgwNTvivv/WIqdL9kZMwuwBLhcl15kLrWSPERiPSUx2TwMMS/D4PkJFaDR5a2MjXZ80048yF5VDyUinT+QrxIlkNqyfmiiHenACAeUGm4YIPvPqp2T0iHyNFUx/rlHfGknYTzB5dqvCpB58Uh/91NsRhf3EFt/z+lPO1xMZWS4ULBMnvaA+tBbLvkfONIFxJByz+x+I3RHx2I5rrWtU3GpqQG54G0fl7YsI+vhxzKLZNGRW/dkXFrVw1TvRAK5+L4cSuSCTFUUER7qVKHFLqyjFQTMRHCzGtoWZ1H2bjUtygQGCY4iWXiTG6oKHjyuQE1ZLvXE1sdIbkshLbO+BiLS97CU2266zJzJnV3yU8g5J5DPROidEhrEQmanTeBdC1QjCI/ux3Aa5L025lrSWLdoNXnKq17IBda6DQzp/DJfEPh6Pw/CDUVIgn39aFuDy1ZhukuSmtOUe4N1XTLNwrRjQuMoEw+WsNkRyPB6U0dUIyLYCnaSHc3563KLZxma3Tt1E6VKmkrR8HsADMGOnGMpRQarnoCuQvcIOME05WJF45RkVPJ1STZSi/m6kEGWWKHKcWquUv+tHf/pFch
 pkilOM+b
 4WDOyus3QaaKVgw/OnA2REvvzmQ82rLJZZgEYFDuiKUZnFZRlOH+YF+8B7b0JNlyDvxOdklgnRFgKuK4QJeZmWeLmw8jq14DtioU5KVN4IPm9rYCcY2stJBSxnm2ldmY+ldEMuVE4r7plcVdwf0yROG/fxGaVbVKeCMj1YJvYNXn3OR9SvcjirLDnFeDEUxcdtCNEKgPoeTY5RHiFjxOt6Gnj17RzWVXFBkEtBXz0QMf2IS5xJ2aUTP2RzBQHjAcE6XVPJzl5Imu4zky6kJ0NPT+Ci67Aa6b9lWXIisr/TUlrOSQppxJ8w4zb6rQ7HHf5F0MpFB5yrKRlVNWWC/PXr1hk5VNnEQHcRZu93Y0zag31bY6oAnjcDcsm6cDjeamHJnIJXnTC5nlTJsKAt+NlM/R4uhtIlGn8yYkX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit adds a kernel command line option using which user cfi can be
disabled. User backward cfi and forward cfi can be enabled independently.
Kernel command line parameter "riscv_nousercfi" can take below values:
 - "all" : Disable forward and backward cfi both.
 - "bcfi" : Disable backward cfi.
 - "fcfi" : Disable forward cfi

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  8 ++++
 arch/riscv/include/asm/usercfi.h                |  7 +++
 arch/riscv/kernel/cpufeature.c                  |  9 +++-
 arch/riscv/kernel/usercfi.c                     | 59 ++++++++++++++++++++-----
 4 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e..453127ef8746 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6453,6 +6453,14 @@
 			replacement properties are not found. See the Kconfig
 			entry for RISCV_ISA_FALLBACK.
 
+	riscv_nousercfi=
+		all	Disable user cfi ABI to userspace even if cpu extension
+			are available.
+		bcfi	Disable user backward cfi ABI to userspace even if
+			shadow stack extension is available.
+		fcfi	Disable user forward cfi ABI to userspace even if landing
+			pad extension is available.
+
 	ro		[KNL] Mount root device read-only on boot
 
 	rodata=		[KNL,EARLY]
diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index ec4b8a53eb74..451bfa607745 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -5,6 +5,10 @@
 #ifndef _ASM_RISCV_USERCFI_H
 #define _ASM_RISCV_USERCFI_H
 
+#define CMDLINE_DISABLE_RISCV_USERCFI_FCFI	1
+#define CMDLINE_DISABLE_RISCV_USERCFI_BCFI	2
+#define CMDLINE_DISABLE_RISCV_USERCFI		3
+
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
 #include <linux/prctl.h>
@@ -83,6 +87,9 @@ void set_indir_lp_lock(struct task_struct *task);
 
 #endif /* CONFIG_RISCV_USER_CFI */
 
+bool is_user_shstk_enabled(void);
+bool is_user_lpad_enabled(void);
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_RISCV_USERCFI_H */
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 5a1a194e1180..f7f3368bd8f5 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -28,6 +28,7 @@
 #include <asm/vector.h>
 #include <asm/vendor_extensions.h>
 #include <asm/vendor_extensions/thead.h>
+#include <asm/usercfi.h>
 
 #define NUM_ALPHA_EXTS ('z' - 'a' + 1)
 
@@ -45,6 +46,8 @@ struct riscv_isainfo hart_isa[NR_CPUS];
 
 u32 thead_vlenb_of;
 
+extern unsigned long riscv_nousercfi;
+
 /**
  * riscv_isa_extension_base() - Get base extension word
  *
@@ -277,7 +280,8 @@ static int riscv_ext_svadu_validate(const struct riscv_isa_ext_data *data,
 static int riscv_cfilp_validate(const struct riscv_isa_ext_data *data,
 			      const unsigned long *isa_bitmap)
 {
-	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI) ||
+	    (riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_FCFI))
 		return -EINVAL;
 
 	return 0;
@@ -286,7 +290,8 @@ static int riscv_cfilp_validate(const struct riscv_isa_ext_data *data,
 static int riscv_cfiss_validate(const struct riscv_isa_ext_data *data,
 			      const unsigned long *isa_bitmap)
 {
-	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI) ||
+	    (riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_BCFI))
 		return -EINVAL;
 
 	return 0;
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 8bc3e1e3f712..92f536d46fc7 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -17,6 +17,8 @@
 #include <asm/csr.h>
 #include <asm/usercfi.h>
 
+unsigned long riscv_nousercfi;
+
 #define SHSTK_ENTRY_SIZE sizeof(void *)
 
 bool is_shstk_enabled(struct task_struct *task)
@@ -59,7 +61,7 @@ unsigned long get_active_shstk(struct task_struct *task)
 
 void set_shstk_status(struct task_struct *task, bool enable)
 {
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return;
 
 	task->thread_info.user_cfi_state.ubcfi_en = enable ? 1 : 0;
@@ -89,7 +91,7 @@ bool is_indir_lp_locked(struct task_struct *task)
 
 void set_indir_lp_status(struct task_struct *task, bool enable)
 {
-	if (!cpu_supports_indirect_br_lp_instr())
+	if (!is_user_lpad_enabled())
 		return;
 
 	task->thread_info.user_cfi_state.ufcfi_en = enable ? 1 : 0;
@@ -259,7 +261,7 @@ SYSCALL_DEFINE3(map_shadow_stack, unsigned long, addr, unsigned long, size, unsi
 	bool set_tok = flags & SHADOW_STACK_SET_TOKEN;
 	unsigned long aligned_size = 0;
 
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return -EOPNOTSUPP;
 
 	/* Anything other than set token should result in invalid param */
@@ -306,7 +308,7 @@ unsigned long shstk_alloc_thread_stack(struct task_struct *tsk,
 	unsigned long addr, size;
 
 	/* If shadow stack is not supported, return 0 */
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return 0;
 
 	/*
@@ -352,7 +354,7 @@ void shstk_release(struct task_struct *tsk)
 {
 	unsigned long base = 0, size = 0;
 	/* If shadow stack is not supported or not enabled, nothing to release */
-	if (!cpu_supports_shadow_stack() || !is_shstk_enabled(tsk))
+	if (!is_user_shstk_enabled() || !is_shstk_enabled(tsk))
 		return;
 
 	/*
@@ -381,7 +383,7 @@ int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *st
 {
 	unsigned long bcfi_status = 0;
 
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return -EINVAL;
 
 	/* this means shadow stack is enabled on the task */
@@ -395,7 +397,7 @@ int arch_set_shadow_stack_status(struct task_struct *t, unsigned long status)
 	unsigned long size = 0, addr = 0;
 	bool enable_shstk = false;
 
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return -EINVAL;
 
 	/* Reject unknown flags */
@@ -448,7 +450,7 @@ int arch_lock_shadow_stack_status(struct task_struct *task,
 				  unsigned long arg)
 {
 	/* If shtstk not supported or not enabled on task, nothing to lock here */
-	if (!cpu_supports_shadow_stack() ||
+	if (!is_user_shstk_enabled() ||
 	    !is_shstk_enabled(task) || arg != 0)
 		return -EINVAL;
 
@@ -461,7 +463,7 @@ int arch_get_indir_br_lp_status(struct task_struct *t, unsigned long __user *sta
 {
 	unsigned long fcfi_status = 0;
 
-	if (!cpu_supports_indirect_br_lp_instr())
+	if (!is_user_lpad_enabled())
 		return -EINVAL;
 
 	/* indirect branch tracking is enabled on the task or not */
@@ -474,7 +476,7 @@ int arch_set_indir_br_lp_status(struct task_struct *t, unsigned long status)
 {
 	bool enable_indir_lp = false;
 
-	if (!cpu_supports_indirect_br_lp_instr())
+	if (!is_user_lpad_enabled())
 		return -EINVAL;
 
 	/* indirect branch tracking is locked and further can't be modified by user */
@@ -498,7 +500,7 @@ int arch_lock_indir_br_lp_status(struct task_struct *task,
 	 * If indirect branch tracking is not supported or not enabled on task,
 	 * nothing to lock here
 	 */
-	if (!cpu_supports_indirect_br_lp_instr() ||
+	if (!is_user_lpad_enabled() ||
 	    !is_indir_lp_enabled(task) || arg != 0)
 		return -EINVAL;
 
@@ -506,3 +508,38 @@ int arch_lock_indir_br_lp_status(struct task_struct *task,
 
 	return 0;
 }
+
+bool is_user_shstk_enabled(void)
+{
+	return (cpu_supports_shadow_stack() &&
+		!(riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_BCFI));
+}
+
+bool is_user_lpad_enabled(void)
+{
+	return (cpu_supports_indirect_br_lp_instr() &&
+		!(riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_FCFI));
+}
+
+static int __init setup_global_riscv_enable(char *str)
+{
+	if (strcmp(str, "all") == 0)
+		riscv_nousercfi = CMDLINE_DISABLE_RISCV_USERCFI;
+
+	if (strcmp(str, "fcfi") == 0)
+		riscv_nousercfi |= CMDLINE_DISABLE_RISCV_USERCFI_FCFI;
+
+	if (strcmp(str, "bcfi") == 0)
+		riscv_nousercfi |= CMDLINE_DISABLE_RISCV_USERCFI_BCFI;
+
+	if (riscv_nousercfi)
+		pr_info("riscv user cfi disabled via cmdline"
+			"shadow stack status : %s, landing pad status : %s\n",
+			(riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_BCFI) ? "disabled" :
+			"enabled", (riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_FCFI) ?
+			"disabled" : "enabled");
+
+	return 1;
+}
+
+__setup("riscv_nousercfi=", setup_global_riscv_enable);

-- 
2.43.0


