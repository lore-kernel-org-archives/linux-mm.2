Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238FAC87FD3
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414846B00B8; Thu, 31 Jul 2025 19:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C6346B00B9; Thu, 31 Jul 2025 19:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E436B00BA; Thu, 31 Jul 2025 19:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7686B00B8
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CFE755D0B3
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:25 +0000 (UTC)
X-FDA: 83726130810.29.6E6C531
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id DAF451A0006
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=JwN82ZvT;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754004023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7zhOiw8hxjkY2w5hPCBsj8e5dMVUfbCJ3iXjsowIqM=;
	b=iiOVRs7WoZnsaoLqd6TLT149A7v+g8C8mvbQ9WVTA/TNnDGvKiN9txHX9Igs8xEmpqasP0
	4dbOIdz5k9+ML+0nuAJN0MnYmQWn/Im9Gto56k5T5dM01a3c7BrStYJthdhZKzxEphrjyd
	2bXpV5UaWBJPYhe8d7rxdcLtB89dvqc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=JwN82ZvT;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754004023; a=rsa-sha256;
	cv=none;
	b=c0siszgR+jqAsN9AjMUAHthZVPpOsjfnfvUB///OGaQgNkthAxaFR4MWuj+snv97E0zIzA
	Pqu1e4ReJM+HqawjVN8pb8MzYexP15v8iiynMh/eFjsuDJh39RQOPbIR/E6IrkYB9uVEgi
	n6pdzTAeHhsxenN6GoNRlxSMYRfziHk=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-31f255eb191so1378635a91.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754004023; x=1754608823; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y7zhOiw8hxjkY2w5hPCBsj8e5dMVUfbCJ3iXjsowIqM=;
        b=JwN82ZvTwbiNyE8W4/90bo8h8mnt+L2WEVFwAyu+akQ+whecM3f+PP7gP2BMIyOAGI
         VkuwlIKXKqYTfNstJgl/IdnVOKSnMF2XUXNoIMqk8ndbj498rlJ0c633w/esbKqHUxto
         MuTJEkOc9sF6drxLHnZ3gLd2VEtu0m/hDbZxH0sWoqtT9Ln260LuIijnvsn8mXEQUe+f
         Q5pI2QExUorWqYQJ2qdUWAIR4ntphDwaXLsuvthcME9RToc6ZrbY5KrfdFjRODphcdkR
         JopFcunzc2E3+waub9b3QNUtQii75pC2Ucz6nkd1/tkjYMyKIUOD/mGGC8rFuinZrSm9
         G8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004023; x=1754608823;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y7zhOiw8hxjkY2w5hPCBsj8e5dMVUfbCJ3iXjsowIqM=;
        b=p6iuXfqrP5SoGKnIjJaxaflbpLtmiXUV2KnMzKTJeJ8NiPAM/wHQ01tY90ozNgvN8C
         UEjv+JXrZr2UCChpUP4figcndS/h7pq5wfv4H8YrGeAmIjQold/YLcCjk6z4IyR+tyiw
         RaAdE3BfZaxkMA+ep4ljBLWZLoSBs1JCEewXF5vtiaUWYBSM9gGxqh2dL6wUhJknFjjU
         HW6vv0NntgpM4wWkKhiFcHAY3SuaLdxIShCY7Zg7ZKZaHk0NuL/dkir6Cw8GHk0Us9sJ
         fKv6StWhXnLUqod+XbwL2uwnvqApYQVVxNekjRPDqrrZhde3kgBcD1BhoRorT45N/ngG
         3v9A==
X-Forwarded-Encrypted: i=1; AJvYcCXwjbENs4nKC2w9Ush4/DgiDBQ8CAXzYyCyRvAKc6KNQJdy7O3JJMNVtYHaAXSBytn1Lf0QybM+PA==@kvack.org
X-Gm-Message-State: AOJu0YyXKGaueeDs3jDJyt9UvbnofDWi2wqJVpQxvzivCA+nDK1SNlkb
	PSNXuNauErf/bW6cwdSMxqXiUgqWT8WK8+W7F4RVlO5SVeX2ainrgfA9HOB53BDcWIA=
X-Gm-Gg: ASbGncuvNST4S7GngMnyJ7HIvmBPYukqdLoIrbihCHt7wQ0Ohq71IKUrhRFzERSX3iI
	PZhKGeQRIIGUCDgVKTAGnR1NUuRhDX13orSoRDi/IiXmVYfEfcPO1DO0Q4ylXXaICTBGtUQT1My
	USbBrMX7++mtRhp0JQ3N3i+A9IS1PodxDASGrHtZbc1XtcbblBJRI6QR8kFfL0JodZXNCA90OW5
	rejKw6hQ3G2LhKyt4FrkeWtjj844eXf0DjvIA0gUyVDDY2Ax3ESiOUT+vHuva/Q9klAIMxTxi/z
	Sl2eiVDvdA1+zBvq+s4GZSCv9ssQR2AaqyJKGs5nLqcwI+kUpopHLeKuEKA/YxpHGYbkvutLveF
	ToE2mnf14NghJsvvyIyBiIv/oHNL0djjD
X-Google-Smtp-Source: AGHT+IFb6cpAcJPsH+LUbeFd0vrkmWBYPTGi6FJej6weAXxvh0JJMsibgik4Cf8cTbGnwRHM/yFM7g==
X-Received: by 2002:a17:90b:48cf:b0:2fe:85f0:e115 with SMTP id 98e67ed59e1d1-31f5de6c834mr10940442a91.26.1754004022726;
        Thu, 31 Jul 2025 16:20:22 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:20:22 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:31 -0700
Subject: [PATCH v19 21/27] riscv: kernel command line option to opt out of
 user cfi
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-21-09b468d7beab@rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: DAF451A0006
X-Rspamd-Server: rspam06
X-Stat-Signature: 8ajqgijws4z8pepsnea1wjf3e1t5ci1e
X-HE-Tag: 1754004023-93777
X-HE-Meta: U2FsdGVkX1+i/db0/I1Pz3LlgVOU/ceZekW12aXt0sxwjkuIPPVj0W2cYIDpXyF5p16sh/FZhhgYAwoSOqY0tYwwX3KR1+GnKMMCNm9QprAe6QsBd1CZRqYiPucSel4PsApBOjuaTf3BVg8rVUmw6gCAXGOFhTjKI1cgvSknza6T9h96xeNbqjn2BoAiID62lBRpwuAy6vM7ZnFYEOUOI3xx9Tkj0lIFk4pC2bEoRmSH9dhNB9hn9kjqnXmF38yQkcwFwOZXD+R52w2j4xcX9xhFZL32ZKyXozHoJOgWfP44cP3g1+Ome+gEOEEtYhXLMB38i916EaW/JwaWkesBd4ddHDlQqzlg3em7T9wLvO12b9pcqzCYVLuANh3DSTgAnzPQQhWgVe4elNIV9bWxz9M9h++j6FlvcwqE7g0rFQRLP+8uFhFqOYTOFVhsWT+M4pkcBPizeGT7s8CWKwjCEfnlhfSOceCPMWvcumfeU1OlP12/LWe+bu4lYisx6kepmPw69ORR5w1TKhZcWws17GYZc7JUOVDBZokI56vzj8myApquL5yREbDd8/D60iyENhOOzfJSY6+4+XQWV6wA7GbDGZyXDxdTrM8Qx+fbhaLIcC7Xoovf+4LBIjlgrqtz1Pe/xidbz2PTViPBcc27n9Tx4P2lnimH/iyjIjGxick1KE7qIrja3WUE51rtaYXM0QV/R3GiaJFkZ64LSPahgtLZUZ5GHBkSJtnMU1VE2N2zRWpazVXHtC1slwfihwoEuYiYFJFrPMjt4l2tFH+KWxTKXFftWQMehazqgVFdeWbJFtZ5nKfI5QfUmVtdiRgqADcJHKQ23RX9fdBu2cVtbhk4d6LmZYDguuOEF0npQvoBZuHAtfQy349+m6QPO+qPqGprRz66hfiUlvpVFXu97Vkg3iU9/Ep7vyvoynYXHveb0k95U3R/uFVgN2wvE0FbBOfalFR/SkfX0i+BYYK
 9fdgfJyN
 9F4m+GVpdne2e2BT/CNdRgKEN7uOk4MHStwRkKFz8Q+cacStq8nfzdib1dGfkxELRHN4w2NZDNzI5BmAMXum4Z1ahdWYptkgr10rDfmehVVRJA1UwV29x08ZMGDcB8mTjgy+23VLGlYIkGxZiAlxZgJE9J6VQqMq8f9d9+RxNKIJ5EqhC5oPVCAY3tG1fsi6r1kjdjoNwc0lK2tfG7tc4g4zjrNRGQ8Ga3l151p/xZoYoHUdvuktnf033SeCvpXrWhMZin3w19/xtXIAs2E1IgJg7h4HZzM5X5ptTnMmJALxJfDA13fEHGScrSSupojBujpCL2cvsFdUzL/o+yE5bXcxjNpS8HAPAhDPPKqe1JemWcmna3R3SlgBBx5IR6jrzgFxENkjX4uR9vYR0+EpayuHi9RFERp+snqsIaMy63wdXngA7UAjLsWZz7nMciiW82kZ7C8MUb0MoYy6gQ6f8hQtPDQVDKaHCNr2ALE7qrh0dZAr0e1JC1B2Frw==
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
index f1f2c0874da9..62aee3fc2256 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6312,6 +6312,14 @@
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
index 54add512a4dc..afef69910601 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -5,6 +5,10 @@
 #ifndef _ASM_RISCV_USERCFI_H
 #define _ASM_RISCV_USERCFI_H
 
+#define CMDLINE_DISABLE_RISCV_USERCFI_FCFI	1
+#define CMDLINE_DISABLE_RISCV_USERCFI_BCFI	2
+#define CMDLINE_DISABLE_RISCV_USERCFI		3
+
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 #include <linux/prctl.h>
@@ -83,6 +87,9 @@ void set_indir_lp_lock(struct task_struct *task);
 
 #endif /* CONFIG_RISCV_USER_CFI */
 
+bool is_user_shstk_enabled(void);
+bool is_user_lpad_enabled(void);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_RISCV_USERCFI_H */
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index d38136672650..08f2757340c6 100644
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


