Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A94CCD192
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4206A8E00A6; Mon, 13 Oct 2025 17:56:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0D58E00A2; Mon, 13 Oct 2025 17:56:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FCD38E00A6; Mon, 13 Oct 2025 17:56:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0737B8E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3F2B1405C2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:48 +0000 (UTC)
X-FDA: 83994451296.06.000E699
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id D4F194000D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Nnn9KtO9;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MB48/j6I+d/gCcARQ8TfLMiFMxnJjaIkZzUmXgVit+Y=;
	b=a/W2weH61CPPdEqBHzDqML4WT6rPuL/OqxMwnV9OTwFnrGykkouBVNtlwjg5PYdqf/Bgmi
	UKtKPO9Wj9/5OgPf5bgDYLEVx7CSOKY07suoeNbRFbJfM7fXTkhtgbzcZWGrNfcSd0BUIP
	kSTFdHu2kR3EB0koYNmsEToNoujRpzQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Nnn9KtO9;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392606; a=rsa-sha256;
	cv=none;
	b=VkcaVdIahuCERMZaR2SHx3SucR2w/D1xbf6PoWcoAQrfR+0l3oQniqkWKwa6kvJNbIppMK
	Em/PoQ9kGeq+5CUZdQarzjjzvwPFpxFHwvDqp3/bsDK352e8pd3YFupZCgaltz2VsBt4FW
	3qalXbiQvIUltAePjl3P9rIbt0x55Ig=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-33b8a8aa73bso494017a91.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392606; x=1760997406; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MB48/j6I+d/gCcARQ8TfLMiFMxnJjaIkZzUmXgVit+Y=;
        b=Nnn9KtO9OTDC5RjJbQlbibNdX+D+ceCGLmbx/4OlSnF+pAoofNLCw6ryeI6UzGZGPf
         QwvFyodzHaMtMtr/PAlTj6mVkpPbSdjDwgpGgRN7EUk4T6aKir83QDsUkf51MUU7r/8W
         e+nriEYuar4fOcAlcD+B9qkoVK0puT93bGWCApC+XvXYY2esC4U5WuROV7CcEhu/3Oqf
         2kqxgJ7Qga5cu/Rka66UdwlpnapJpCcuOGBQBFo3IgvjrRGeUGMDRsTsNzc/yHUOU5yr
         VPcKC6CeiHjxkxDHBEQ/ozwZRKdhe1GtyAC0b5NN2NAzkvVSbQPY6lPp2kuQA4XfS/Ck
         sBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392606; x=1760997406;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MB48/j6I+d/gCcARQ8TfLMiFMxnJjaIkZzUmXgVit+Y=;
        b=p5/YWUR0H9JlP5DpLD/cM/wJoFjC++uK+AoCZW44IGw1I7z63lBVe7MBKREqa1cQMR
         VezqCiTj4K1L3E2B/2Le/IdqIHzh8OaJpjp05SWmhuCVzS2jN4X+vFzD6a3grC8m/slo
         AEXL8ovQ1v6G1N0Vyn/77BNOTqSkU0TKClziS+GtEuZrkdOwH4RphEKkYqhaIcWFXJfm
         nUSITRhfM++03REzUPhmtY1BTxvXVyHOCPPDiYhd1M6kJQdjVqHlfqWzo/Mlk0y8IQLn
         9CBNbqsWiWlUNTIO/VRjEO9XEiT9+IkjK5aia0sK7wpx2+kxSAQC+PrQBkWwwT7LvhC1
         q5ow==
X-Forwarded-Encrypted: i=1; AJvYcCWdk19TWHw6ZznxI0uVvWMQwUzhEeRJl1jQwjYHnNa/DzIY00oP78auJnponlJyODhVBnFWGu27vQ==@kvack.org
X-Gm-Message-State: AOJu0YzJUkS2iGvFdIJFqfbZFu3BJ6/Lf7a9RAqDycaxRzSaXrVRjqa5
	Q2Co2zp2ji5PFH+eePe8xeWo9fI5gsVsUhRXeD9SIoLKhPUSniiFZldvKwtH+IDM8Ms=
X-Gm-Gg: ASbGncvEl4Dgh+biY0uimRtH57Fe2yiSQZ6BeiMbLJINAOJGD4dZEBYsAG/XqkwsxNk
	OyKNvLyRP5+L/hG0Lw8ttsYS8QE0rPJSVeztZgAuEMNb0RleIuAdLWb0uIZ+V+TpLeaeTMHDMRP
	t3KpGvmXKJm3n5S/Yo6MVqX+Bsyxb3lORkQLlV2v+cENPLzEPWyRZvGkyl93IpvnnIyCRbP6D9f
	5ja/GTAxlczjbFUcpk3nAe+ehMm5kO0C/qKDSaXJpomZyPlnjqNM6C9oqFJIzyHagLsRShz/FZB
	CO5JjcD+6IVTyGZyJx7frq1DV0T3YcCrEfpuHS8NHcg2Ci+it6AjqqhAy8lvXOIChQTzGBLXIJg
	rNOuu7dE+h852hDwPD3JtMdRVhZ31uTR6G5YWCurE2K4isO1emVYYz2vQ1AGKog==
X-Google-Smtp-Source: AGHT+IGWSssHxv05WGBZXj/9fYa8D5uh/lj/EPEVi7pvaKgyx0FNyPE4wMfQvdjCBO2rNHFNuJ462g==
X-Received: by 2002:a17:90b:3ecb:b0:336:9e78:c4c1 with SMTP id 98e67ed59e1d1-33b5111580emr32329494a91.15.1760392605671;
        Mon, 13 Oct 2025 14:56:45 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:45 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:13 -0700
Subject: [PATCH v20 21/28] riscv: kernel command line option to opt out of
 user cfi
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-21-b9de4be9912e@rivosinc.com>
References: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
In-Reply-To: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
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
X-Rspamd-Queue-Id: D4F194000D
X-Stat-Signature: py4nafzga1eupjyq6771ystrq8w1fjjb
X-Rspam-User: 
X-HE-Tag: 1760392606-668229
X-HE-Meta: U2FsdGVkX19cbyQCwIuog0SnqQHx1yPdUfV5w9gp0dIRdVRWQZZQVpFvOyyZDIioGmsxxGBBGaOTALZhg2IgHd6IT+klVJbDvA8FidZcmOf2lnsJwuHPP168Zufpr5KgucUm7KWXOf9j3sB/hCaoq0PRZnQ62hdbaMe3xzcV7Y/l8NNNWNnzliNI/g3L0hMAo0TKIRE6LNZouWFYfPvY57O347OKu2oO4zVpj+lXZWKG/SxGx5GD2urSONxVs4dGjgDaGiEd08jzDp4z+RX30Wosd5Duqh4t/YzryheNiwtduzzJv8srY2r9DlnxhPxV3nxGA4tiSb1xIzB1As4g87ENYWCa3pFtbNgIoypqNQqF7k50F+C4l7ZNXThegAadCzLGqFC9jKlYJgFllsUREs5Wtb/pHWnres3QN/71rHN2G0jHF1o4KGbvAi6Mi5DYY7EXw0WPil4huELc24oz2H3oSZGvgnItfOQt2a+SZAbHG9OrkGsoP2jt8LQGjrOZKR72ERxWUGfIeCKLiWmrIX574bCQ1vWbZb9KpnwrpzcS8ZtPYHh8V1mrl5cliKD6n11ClAP06T7Bo+gbp8V4z0095IueyLmTEciM9kUP1K7IV1dvnNh+4Y+Ulk2BN8tC15Kh3TWk5yAbRr67tS463H3X+6VXxk5oIl7eKey2itDxn9+S1u5AJdehLtpItZDDb/aqTCryWiCpp4VC4l2W5yWu4kNYOySGQRGsZetM/mqnfixU4r+18KC5s2Kg/dvLj1WNvwK5RFYaeHUlHaByhhaiom4DfSixV5WgT1tl7ecSDy4dXJ/089NQ915uALeL3k/x84//S0zpq6QjIzKEBN912SbGiLoOL57UVivhT0DOUY+59LNUlOS/5Mpr4Yk/cp1jZOd/zR6Pih90Z0UKjW+lv7s35ia0qsRCo9M5+IeclgUKLKXSu58Wf8SjVkmyb5F5eiu8qGNKpSin4M/
 0+iugvIS
 f8QiNUh0tjVhI0W4muD7wTcuQaI3BMFzGdYK1mM6g1k0ZS0RH12LIxOk6os3GcSnsHX/mipeEaEAFJ22S0qNZe/Cvxb5TmV9Yva3W7xuxyjaoIcYrQH3dywzogKeNRsEvfx615V3ilFtjSKHy7gq0cWhmSFnIe62OwH1ERaOmPMd0pRTrfSpg/pIk/PtfF9mkG0HDXL/mko6y6xv4oaRB9NYTD+LZ6r9LruDyR/mhbbcoWz6QbSHHo6bQI1/ZP3jav8vKBBJ7xa0y7f/CAnT2EoakKUfpw/n103JeTkEl7nND09qO+MNfHdj6lMVTMf/cR8jgRgzD2wQ9JemyemAzc+xPuuYs0Dci21xG8EHPnh1yVfLPloiRlguXM97whgQWxN7gjbutgU6tArLs/A1ve71eG+l3yKcHHu06
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


