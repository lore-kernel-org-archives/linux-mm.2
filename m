Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07997D339AE
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 409826B027A; Fri,  5 Dec 2025 13:41:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3902D6B027E; Fri,  5 Dec 2025 13:41:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2330D6B0280; Fri,  5 Dec 2025 13:41:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09C6F6B027A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:41:55 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B27A5133516
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:54 +0000 (UTC)
X-FDA: 84186286548.15.9DDB9F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9E0FB2001C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iTFXgqvx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960112; a=rsa-sha256;
	cv=none;
	b=kYZWtLLsW6XdZx74aeoYFC4AJQEdUITA391Xfcw2YTIDBpMegb5CGKuQSHtVKn8MGf0dL2
	54aFkN9H1P6xaFRXBaQKm1LRB163czsB1rKBEp4zkEdTN7857LlPTnfpwvP5CrfGO8K8aA
	Yt7jSysQoVIknAyZhzCNQjI8kiSNfo4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iTFXgqvx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960112;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SffyuK5GCVuIGJkkqfZl/rcjNamup4GISt21xN/0eCE=;
	b=WvGQa7jKQEwZVBNAHRMPC2TbRVrPlMti2NiwE/EHxhKAf+oc80levB9ssJwYJjrfdi+OSX
	3C9DIxUqVaYz0I1LIT2RPID8NX8octHbWLfKqsSoqp+qpXMk0ArwiQEDUonKw00XJIrraO
	fSeWU0indT8XhfFO+5fhRdiVGAlOlc4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 82DC3444CF;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2126FC32782;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960110;
	bh=uDer5meXOB/owYL/ZK1ACAWj8r+T+Qrdn3VNOnnw9Z4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=iTFXgqvx/O7rNlU0BufTECjcWmYpYR0Z6iU11yYlFc+eMLG8HFzuGTPBsavRXA51G
	 gVORSHj/SgC3LUbG3a4WATtF+vz4OIOWWt6W/1bt0Q8Kv03YSv/RL5/U4I7Ac1p/MP
	 8jRMTJSfmZBP2X2l1s3mQ+Nu/JZJhCJ0L+poqQs1+TYHts61sVhUaAEuj8Ub92YeT9
	 zNod85sfoU5vc7FKICWmcRa0ZrzRAaVnkHxBF5P1ELHgyJFk6St+OgNz9Im+O/EsDn
	 p23Xz99ROwsyPF36S7bNoHbHVoPTo7cxaGUoybDfA3oQgeu6MCs2TbQOjmIYX9Vvhy
	 9pMSWbVybjUyA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F74D2F7F6;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:41 -0800
Subject: [PATCH v25 03/28] riscv: zicfiss / zicfilp enumeration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-3-1a07c0127361@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=3702;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=tN+UqM0xPUhz8OyGQ7x+rHI6rGO+XR4AZvntK+Oh3u8=;
 b=6RekYDzXMw9UPQcIcqadjj+X3iIHo0qHEDCURrQgKmW/dLJf23UYHzPhi9fZEAbD7FJJ5gEhm
 QTKxffNUSNPDWc7OU11CQJRix5VbNfiEPf/EX+WD/6hra8RimAuLF4H
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: 9E0FB2001C
X-Stat-Signature: kaita7dsc4j3j9eys9jgbrf66k1tycxf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1764960112-949911
X-HE-Meta: U2FsdGVkX19Nig49JgK4OUYJMK4BCrjh/UwrrWk3lfrJURwXrq4tcAz9YtNBugqyplK+GsmHhGxiHhYhWzhsi6nSQa/PJzs4Hf9b3pAqF2ZjPgYSEttCEOHuwGmBOOkxGRbReBkpwR0GKxe7u6tOdsFObulFGtrQdcWxehwAKV1ujTwe5GTG571nfDQxriHxmwD1P8Zwlm0Txbvz32TRFcSMgUODUHk01KJ1ScZJCH3/d8iu+QybKPzeVY8kX2yKcEN/YW8rg5m+WUteriVO2on7RgC4RTKjqqm8oruF0KaHR1wpCWxJD6K5UEwyI9kM9x/dvWwl6RpYRWliiFsUsmeqqDxIhigEaSZ1uFY6xdm+AgKyCCDw4Dt2EwjZsiuCFz+OsXQyBOmJhCJ4LouUnjtmARqL8EYfOMvI9KrzjiJDFkaN07sx+LUSkFI1GUNXT1JeFj57uWS2NYbsw/jRuwCXIFrsAiVKC0rf38W+RsjMVR+SEy4INTXWu2FEDCXsQvdXPAMNU7TrHjbnlVRxuaAo+SKUd6fkxXzPJIj491CpSwVSlw3LMtrjyhqfhlzZULebw+1VO8WOsEjjyFMAxGylQP+sghVgETPyLBwWc/4rNr20j57egbDHBuayMHRK8UxvJjPBoB/tyFoFEJrU56EiJQAQw2J0TmdTl/e9BKO5UVkPx9G7Zy5gxijKUlQW8vhOf3nsMrk6s1jdm1r82G1O9XF8HzCGZuv4kVGcJvokO1TtwD9CyXXFLEyQuqgebA988+c56XVVIwlVlPHyXZFpGXC0suVaVdezI41Olo1fwuG+ymbia2/dov5ysoCQ7bUm0eghPKzHmdf1NswK1hccRsLfOKdm3Yu6Iynkj5NQZQI9U5zhhaVA1JGv11wnC2seicwFSwn+8U3/w096kM3vt39e/PMTBahMghN1Sul+TrRz1HMkKrVtzYtmPrcIQVO1kGNPNkJT/H+uKzt
 TeO9eaNO
 +KwGtmCB6hDKWkhSZumd/c71ngP7pwV6S+cwWprakK50TkTUi5DQLb74cYW3CXUf2OHeNI4pV5ea4C/TaFmSsYIhAnBFgN4GIUSayENpykbIE9wqQ5zGMovzseLW6+3zXhoC+5NwdgJ3TmjsIX1KnBZzUet6diC/+gi6mXI20NITBaR68YYDce4hedfkQrROe33JvVg+z1i6cDfF6YaGcmc8cSc128GstmUyF5PW3coZqSX5lqNyOCkdzErDlVYh2PzmyKcmV6KRWgRk4/bIWPiq1foxUUsGyy33c3Kia5LUug5KeDvHyx3MZhgnpMfhHWymp7+lA37Rtv/UGdR4j+dreL1r7WrTMWPgk2k6Azk0AgLkdQHnnVu02q1GzLz+CtlPR08Kpw2NRnA0SO+6b7Myy+sFj520tW8kmcNjeHlnUiQG3WKZF2vBMAD0dF3z/sSFBhAxKCnrBTK6Bodmvx3hHHep+m/gN/vrOPrCfp7VYkXW+s01QarP3o2qKg+hBwDtY2Ba7HrGEz6IcnqVPo6m0QcrH3GXsxzf0+wDRbZtf8pYyNy1kp4/+NFpo2zXTXcEeK0fabt+qgCMB+/f8P3HwHocOCJe4vtRk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

This patch adds support for detecting zicfiss and zicfilp. zicfiss and
zicfilp stands for unprivleged integer spec extension for shadow stack
and branch tracking on indirect branches, respectively.

This patch looks for zicfiss and zicfilp in device tree and accordinlgy
lights up bit in cpu feature bitmap. Furthermore this patch adds detection
utility functions to return whether shadow stack or landing pads are
supported by cpu.

Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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
index 67b59699357d..17b9e77bafc3 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -274,6 +274,24 @@ static int riscv_ext_svadu_validate(const struct riscv_isa_ext_data *data,
 	return 0;
 }
 
+static int riscv_cfilp_validate(const struct riscv_isa_ext_data *data,
+				const unsigned long *isa_bitmap)
+{
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int riscv_cfiss_validate(const struct riscv_isa_ext_data *data,
+				const unsigned long *isa_bitmap)
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



