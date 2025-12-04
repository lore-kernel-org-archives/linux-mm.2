Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BF1BD2A522
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B8C6B00D9; Thu,  4 Dec 2025 15:04:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBDBB6B00DA; Thu,  4 Dec 2025 15:04:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1176B00DB; Thu,  4 Dec 2025 15:04:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96E916B00D9
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CEEA160328
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:48 +0000 (UTC)
X-FDA: 84182866656.08.5B193B6
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 49DB6180023
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=bo4YcR7J;
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lf00JiW6xSRH4nKpJE2Wt9C2ia6JwPjEocHrM3GZrHQ=;
	b=IPc/Oqkr28U0cIvtKtpLrcHoK81vUAuBFIFYWlYfT8t3YR8lbXLFELgmUp790bZB4pV5SM
	4jwdYGCN2+Lj3Hth9/UnbIbVDaxf4eJl/z0dU9TDXNDStAbjpPSw4+G/q2k7kXaoLTa73m
	8n4zxE2RFTudyH6LfIdGt1VMN0qf0Dg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878686; a=rsa-sha256;
	cv=none;
	b=Xemy/vxofgRO4tAXf14iu39QguB9ry9kfFKl7aU4mZ5pdsQF3d3KVapVixLnaK6jg3xj9Z
	9UVJFauf/Okgg8te4MEXyGOfDljLwI/QPAPn8hn3R6I6mFzmk6QBuBK/zq+PifmIH9ikBx
	ze+547qQXZJzCU50DdNCJLyC5WSGyt4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=bo4YcR7J;
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7b9c17dd591so1187291b3a.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878685; x=1765483485; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lf00JiW6xSRH4nKpJE2Wt9C2ia6JwPjEocHrM3GZrHQ=;
        b=bo4YcR7JWZSdbRZZ2RpKrDEcd/NQgqrepNOD7NzQkWaZ4eW3xQ4tmBMHKgR2XvMAbU
         VE5Dz2rqapsbmwCa1Gl2J6T3Q6vs2JpdH0umhTx7zUPpcJ4rY7a+w5mz1uhYuk0BmL/R
         l+w/7x9eT6Yt+ADXH4RlxbB1+UQAAnuFzu5ZiD0utK7KI48Vaxa1mzP4GuIeqnOVFdJe
         Ha/cdQPLJhDwAe7mpWeFZBZV8IFNOi93j4l0C51bP7BMTzuPzNaRopYH4D5i8WOulQr+
         gJKlGh0JXiITX0WL5Mqrc1rXk5r4QMbzislkDl2FS5nwnDl+NgowjdWVdoiHbIF23vEF
         Oa/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878685; x=1765483485;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Lf00JiW6xSRH4nKpJE2Wt9C2ia6JwPjEocHrM3GZrHQ=;
        b=JqileetgFlUlPRyGybckOODe+dnACQo8Rt7++7TzPeIQFn0Ay5jNGHfR8ywWpB5d2x
         0/+GGGZM5OrRrXBOoOtS9m32XognAL4ORh+kczkCyG9IBmUU9dPFk4IpDXmJ6pU0ih+8
         nww5ZCai+T4yjBUDsjODmGDVTJYT8+787ueSIwveiCmVb5iBUihIOLq3mt54Zm8PNL6V
         eZyQXbLDvTlAWQ0GfpQNOY3UagUUC6smP9f0ldnn+RxCf4M/84LIVp1Fw2WCw+ReMWcy
         WExTfy+eeqKoplAz1B9Ov8KsRtXVwOn7pceiBLzoVlCAZXJlis+vqgYLzMezzLNEyb9T
         09lQ==
X-Forwarded-Encrypted: i=1; AJvYcCXP7SaSuT2j1TfRFL588ZFPQ+6VO6QRnJ3DmFJWIGigYrH128CV8BmleR+vK62p5X31LtoWHb1CAg==@kvack.org
X-Gm-Message-State: AOJu0YxQysVyKiBqnJOO4pSgwrrw9q5MkNxGGSykHyiqCDBx7gW5Li7+
	ZVNQtSobD35ruNNMA9hjToIDtSMJnwNuUwRsziZ9coWS1avrEmyN2A06qYkpMnCKgPg=
X-Gm-Gg: ASbGncvfTukBK+h2Y0yTQmY0COsvei/UIFyRwVD0SZerJZRYGyvFuKZS1UZ6O1Mdyg+
	1r/0Ag2Wd7vVPoG0ltNL1b8560sv2JxBo0q2s5qkp3KdlD8mDBmghVjXqBqBXxjJbg4FdhsN01K
	fsGuiRwZwIIMv/8DBs/uLzB43r/1raofPfZTFbjh37v8DTbb3/i9GJHOHFov3pQBaeRS7ZdA7bB
	f/5XaDTK3K4HiMpbRsfJT5bfPmh4W0pcAd4w0xcQnhynfC+E+gU8RwvlrUzYTXngV3uLfPdK2ro
	2gZWpLyufS5QcP2KaMHJhPBJrQpuGOUrDH07lmhZmWFV/joyXyEzqPxdjNGmlY3jxr/BzMJNcUz
	wxBupVFeDYsolVWb2UQiQ83qVk7ghBu4Id3G38JtOv2wdReI7Vmsa2hIjgX8dHZ4WNCvBJ6BagU
	zRGjPiiR0idnZwV+Lg/5zPD5xXpQo62R4=
X-Google-Smtp-Source: AGHT+IEmlytTfjyV5KegMM2acacRs+AEkDnklcbN4HRDx9sA9/iP1WjhBoOdxfEbHhqy99Y/5dmsTw==
X-Received: by 2002:a05:7022:1002:b0:11b:7dcd:ca9a with SMTP id a92af1059eb24-11df64a443dmr2945382c88.34.1764878684820;
        Thu, 04 Dec 2025 12:04:44 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:44 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:12 -0800
Subject: [PATCH v24 23/28] arch/riscv: compile vdso with landing pad and
 shadow stack note
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-23-ada7a3ba14dc@rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
In-Reply-To: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878636; l=8747;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=0Fk/r+Qv6bmSDhChMXIRunw7/t9Xkhow9/FCLfzokMQ=;
 b=x+X5fiIkbxX47yRxZpezka3j7flf8FmN74RJeyWDNF+LxTtJJe8PYXxJUmQfTbzyJCGgtcyBL
 56El2LgibpjCWn5HegEszM2RgWRPy8d9VGA6n/Jd3DWkZHf54liKkC7
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 49DB6180023
X-Stat-Signature: 47iy8gwa6aacjscyuyoeebpzjoafx9ee
X-Rspam-User: 
X-HE-Tag: 1764878686-550298
X-HE-Meta: U2FsdGVkX19euTjLYmapm3M39JnM25Zx/e+7vtWVpym6c3a+g93Zi+H6u8bYaFbM2aYZS7rdWVvqGVXxXgQAROy4OPwsOJY5W6torIPZHFfnnUfFVWH+ReuHKiDDPnXsrJERAdmly95iPQmXfP7mDneUsOy1jYaNPrXwOyJawbgzhiyJ4it4NJJzBURBwGQPNzTOOquwdEql+y3EAfQucZX6bDvcnfMcrwLfjQHgfAJxz6iTyANQgqvpx2V2pDegS7fPmHFKMP0t7Gv7tlMTRz6Zjjl51DIghfge7BMo7YZY6EqI+BZY4S9krkAh0qn0aAOAzH9mMrpEubawgkLoEvY5NxE+8px9Q1TSrJI32AD6EKhysv4zQ8jQHpirlU+HwJRTgPLEc6+QYgvq5DNQiZlYflLIph2ony7j3DvD4BCCYh2PZO+FRC9YDH3MhenDVIQN1yHE+uuqcGLluhr6bsnCVUjIDeDCN5mK4/hXP9lD2OtoJWykGsf+agUzcj3CLkJJk1TNLJCf+ox+0quUNYX3IyYSiD6GeDiY8GDfAxgxwvhxDH0K4haHNqfsO1CQHFV3wzxKqAD1sFzGzEwfMIR3jE2CmllUymW8/DY+/Dnv6QXDMDETGV8K+EYCsxFWmROSV3bFSNreEY+lTdvJQ6+lObO90zMQqa9hG0BRJyDP8pOuKnj9IHpr2TmczhoW2XHCwaGV2X9JLB22zXk5edaVwNL8LpWvF8DRYVVJbDoXFYo9Oh4csFPCOIrNHgwuOUbVLxO78QcjHnc8PS3B+nyz/ECV8j8sfISDBMhy+I4Cl0aztpcEsthDHBuXLI4T0GlviVbljM0S9pxoj6s6JOlGVD3DuwHISB4WFTAnqj61DA52WxyPMcFAeywDR+er6QYAD6r3tw9KmdAI9JrL/mg012IkZmZQJHlile1dk3lhIsDCsQGUHguyHWaUMln4Su7L/lIvvUV9kV9Cc1D
 XUAQ4ato
 r5P2O/xO8MiRl1rWZ87y+IqAtqAzuB5Jj3MWBHyZfzYyHU5tfvCR31PE67+PcNJUalTnIgcQ7Rx5jPdtAGf8eUdTdlEHg4s8VxBxRZgZe4ATGjRVif+C8gLk5iroiFYH8JVqSVDdWshPuMA6K44TSlLj5VQz9fQBLYGzTDdGSO3KasbzZGGmeKl7srdlUeoNino0vKg6fo1t+vIuq7kkwuXv0LBe+itfF4R0mwD78cMXLgMhZ/wzPs04JPQLB74sgnl+4bQSyRo6C3sxcMvDpxLLTWm5pKWYFRBNnLHWstp20baKMe8epA5ABBY5IMjPs2Gl3ztSgntXZc39OkhtgrdslqnX5fhPYuQ7Cp8I5VJyGj/Rq8EB5Sz/ClzbaifCiTaVGpIERPrAFWS1gPRA7t8dNoiDhwc0n3Jq1+nkk/TMUHwpemni6VZU+1zzxql3Lj0rBIot6cZADn9flmtjsfYq3nHhcWZsbKIPNTDHQyEif/S4Af9RYpDqqaC97/HnEnZbPldUHXmNXqVwTefpvPZFBf/saCDf6b1IS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jim Shu <jim.shu@sifive.com>

user mode tasks compiled with zicfilp may call indirectly into vdso (like
hwprobe indirect calls). Add landing pad compile support in vdso. vdso
with landing pad in it will be nop for tasks which have not enabled
landing pad. Furthermore, adding support for C sources of vdso to be
compiled with shadow stack and landing pad enabled as well.

Landing pad and shadow stack instructions are emitted only when VDSO_CFI
cflags option is defined during compile.

Signed-off-by: Jim Shu <jim.shu@sifive.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/Makefile                        |  5 +++-
 arch/riscv/include/asm/assembler.h         | 44 ++++++++++++++++++++++++++++++
 arch/riscv/kernel/vdso/Makefile            | 11 +++++++-
 arch/riscv/kernel/vdso/flush_icache.S      |  4 +++
 arch/riscv/kernel/vdso/getcpu.S            |  4 +++
 arch/riscv/kernel/vdso/note.S              |  3 ++
 arch/riscv/kernel/vdso/rt_sigreturn.S      |  4 +++
 arch/riscv/kernel/vdso/sys_hwprobe.S       |  4 +++
 arch/riscv/kernel/vdso/vgetrandom-chacha.S |  5 +++-
 9 files changed, 81 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index ecf2fcce2d92..f60c2de0ca08 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -81,9 +81,12 @@ riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZACAS) := $(riscv-march-y)_zacas
 # Check if the toolchain supports Zabha
 riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZABHA) := $(riscv-march-y)_zabha
 
+KBUILD_BASE_ISA = -march=$(shell echo $(riscv-march-y) | sed -E 's/(rv32ima|rv64ima)fd([^v_]*)v?/\1\2/')
+export KBUILD_BASE_ISA
+
 # Remove F,D,V from isa string for all. Keep extensions between "fd" and "v" by
 # matching non-v and non-multi-letter extensions out with the filter ([^v_]*)
-KBUILD_CFLAGS += -march=$(shell echo $(riscv-march-y) | sed -E 's/(rv32ima|rv64ima)fd([^v_]*)v?/\1\2/')
+KBUILD_CFLAGS += $(KBUILD_BASE_ISA)
 
 KBUILD_AFLAGS += -march=$(riscv-march-y)
 
diff --git a/arch/riscv/include/asm/assembler.h b/arch/riscv/include/asm/assembler.h
index 16931712beab..f449c4392c29 100644
--- a/arch/riscv/include/asm/assembler.h
+++ b/arch/riscv/include/asm/assembler.h
@@ -80,3 +80,47 @@
 	.endm
 
 #endif	/* __ASM_ASSEMBLER_H */
+
+#if defined(VDSO_CFI) && (__riscv_xlen == 64)
+.macro vdso_lpad, label = 0
+lpad \label
+.endm
+#else
+.macro vdso_lpad, label = 0
+.endm
+#endif
+
+/*
+ * This macro emits a program property note section identifying
+ * architecture features which require special handling, mainly for
+ * use in assembly files included in the VDSO.
+ */
+#define NT_GNU_PROPERTY_TYPE_0  5
+#define GNU_PROPERTY_RISCV_FEATURE_1_AND 0xc0000000
+
+#define GNU_PROPERTY_RISCV_FEATURE_1_ZICFILP      (1U << 0)
+#define GNU_PROPERTY_RISCV_FEATURE_1_ZICFISS      (1U << 1)
+
+#if defined(VDSO_CFI) && (__riscv_xlen == 64)
+#define GNU_PROPERTY_RISCV_FEATURE_1_DEFAULT \
+	(GNU_PROPERTY_RISCV_FEATURE_1_ZICFILP | GNU_PROPERTY_RISCV_FEATURE_1_ZICFISS)
+#endif
+
+#ifdef GNU_PROPERTY_RISCV_FEATURE_1_DEFAULT
+.macro emit_riscv_feature_1_and, feat = GNU_PROPERTY_RISCV_FEATURE_1_DEFAULT
+	.pushsection .note.gnu.property, "a"
+	.p2align        3
+	.word           4
+	.word           16
+	.word           NT_GNU_PROPERTY_TYPE_0
+	.asciz          "GNU"
+	.word           GNU_PROPERTY_RISCV_FEATURE_1_AND
+	.word           4
+	.word           \feat
+	.word           0
+	.popsection
+.endm
+#else
+.macro emit_riscv_feature_1_and, feat = 0
+.endm
+#endif
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 9ebb5e590f93..272f1d837a80 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -17,6 +17,11 @@ ifdef CONFIG_VDSO_GETRANDOM
 vdso-syms += getrandom
 endif
 
+ifdef VDSO_CFI_BUILD
+CFI_MARCH = _zicfilp_zicfiss
+CFI_FULL = -fcf-protection=full
+endif
+
 # Files to link into the vdso
 obj-vdso = $(patsubst %, %.o, $(vdso-syms)) note.o
 
@@ -27,6 +32,10 @@ endif
 ccflags-y := -fno-stack-protector
 ccflags-y += -DDISABLE_BRANCH_PROFILING
 ccflags-y += -fno-builtin
+ccflags-y += $(KBUILD_BASE_ISA)$(CFI_MARCH)
+ccflags-y += $(CFI_FULL)
+asflags-y += $(KBUILD_BASE_ISA)$(CFI_MARCH)
+asflags-y += $(CFI_FULL)
 
 ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -fPIC -include $(c-gettimeofday-y)
@@ -79,7 +88,7 @@ include/generated/vdso-offsets.h: $(obj)/vdso.so.dbg FORCE
 # The DSO images are built using a special linker script
 # Make sure only to export the intended __vdso_xxx symbol offsets.
 quiet_cmd_vdsold_and_check = VDSOLD  $@
-      cmd_vdsold_and_check = $(LD) $(ld_flags) -T $(filter-out FORCE,$^) -o $@.tmp && \
+      cmd_vdsold_and_check = $(LD) $(CFI_FULL) $(ld_flags) -T $(filter-out FORCE,$^) -o $@.tmp && \
                    $(OBJCOPY) $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
                    rm $@.tmp && \
                    $(cmd_vdso_check)
diff --git a/arch/riscv/kernel/vdso/flush_icache.S b/arch/riscv/kernel/vdso/flush_icache.S
index 8f884227e8bc..e4c56970905e 100644
--- a/arch/riscv/kernel/vdso/flush_icache.S
+++ b/arch/riscv/kernel/vdso/flush_icache.S
@@ -5,11 +5,13 @@
 
 #include <linux/linkage.h>
 #include <asm/unistd.h>
+#include <asm/assembler.h>
 
 	.text
 /* int __vdso_flush_icache(void *start, void *end, unsigned long flags); */
 SYM_FUNC_START(__vdso_flush_icache)
 	.cfi_startproc
+	vdso_lpad
 #ifdef CONFIG_SMP
 	li a7, __NR_riscv_flush_icache
 	ecall
@@ -20,3 +22,5 @@ SYM_FUNC_START(__vdso_flush_icache)
 	ret
 	.cfi_endproc
 SYM_FUNC_END(__vdso_flush_icache)
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/getcpu.S b/arch/riscv/kernel/vdso/getcpu.S
index 9c1bd531907f..5c1ecc4e1465 100644
--- a/arch/riscv/kernel/vdso/getcpu.S
+++ b/arch/riscv/kernel/vdso/getcpu.S
@@ -5,14 +5,18 @@
 
 #include <linux/linkage.h>
 #include <asm/unistd.h>
+#include <asm/assembler.h>
 
 	.text
 /* int __vdso_getcpu(unsigned *cpu, unsigned *node, void *unused); */
 SYM_FUNC_START(__vdso_getcpu)
 	.cfi_startproc
+	vdso_lpad
 	/* For now, just do the syscall. */
 	li a7, __NR_getcpu
 	ecall
 	ret
 	.cfi_endproc
 SYM_FUNC_END(__vdso_getcpu)
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/note.S b/arch/riscv/kernel/vdso/note.S
index 2a956c942211..3d92cc956b95 100644
--- a/arch/riscv/kernel/vdso/note.S
+++ b/arch/riscv/kernel/vdso/note.S
@@ -6,7 +6,10 @@
 
 #include <linux/elfnote.h>
 #include <linux/version.h>
+#include <asm/assembler.h>
 
 ELFNOTE_START(Linux, 0, "a")
 	.long LINUX_VERSION_CODE
 ELFNOTE_END
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/rt_sigreturn.S b/arch/riscv/kernel/vdso/rt_sigreturn.S
index 3dc022aa8931..e82987dc3739 100644
--- a/arch/riscv/kernel/vdso/rt_sigreturn.S
+++ b/arch/riscv/kernel/vdso/rt_sigreturn.S
@@ -5,12 +5,16 @@
 
 #include <linux/linkage.h>
 #include <asm/unistd.h>
+#include <asm/assembler.h>
 
 	.text
 SYM_FUNC_START(__vdso_rt_sigreturn)
 	.cfi_startproc
 	.cfi_signal_frame
+	vdso_lpad
 	li a7, __NR_rt_sigreturn
 	ecall
 	.cfi_endproc
 SYM_FUNC_END(__vdso_rt_sigreturn)
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/sys_hwprobe.S b/arch/riscv/kernel/vdso/sys_hwprobe.S
index 77e57f830521..f1694451a60c 100644
--- a/arch/riscv/kernel/vdso/sys_hwprobe.S
+++ b/arch/riscv/kernel/vdso/sys_hwprobe.S
@@ -3,13 +3,17 @@
 
 #include <linux/linkage.h>
 #include <asm/unistd.h>
+#include <asm/assembler.h>
 
 .text
 SYM_FUNC_START(riscv_hwprobe)
 	.cfi_startproc
+	vdso_lpad
 	li a7, __NR_riscv_hwprobe
 	ecall
 	ret
 
 	.cfi_endproc
 SYM_FUNC_END(riscv_hwprobe)
+
+emit_riscv_feature_1_and
diff --git a/arch/riscv/kernel/vdso/vgetrandom-chacha.S b/arch/riscv/kernel/vdso/vgetrandom-chacha.S
index 5f0dad8f2373..916ab30a88f7 100644
--- a/arch/riscv/kernel/vdso/vgetrandom-chacha.S
+++ b/arch/riscv/kernel/vdso/vgetrandom-chacha.S
@@ -7,6 +7,7 @@
 
 #include <asm/asm.h>
 #include <linux/linkage.h>
+#include <asm/assembler.h>
 
 .text
 
@@ -74,7 +75,7 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 #define _20		20, 20, 20, 20
 #define _24		24, 24, 24, 24
 #define _25		25, 25, 25, 25
-
+	vdso_lpad
 	/*
 	 * The ABI requires s0-s9 saved.
 	 * This does not violate the stack-less requirement: no sensitive data
@@ -247,3 +248,5 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 
 	ret
 SYM_FUNC_END(__arch_chacha20_blocks_nostack)
+
+emit_riscv_feature_1_and

-- 
2.45.0


