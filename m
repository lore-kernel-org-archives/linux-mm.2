Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD82DCD3445
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1AD68E000E; Wed, 12 Nov 2025 19:43:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E3F8E0003; Wed, 12 Nov 2025 19:43:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1CBF8E000E; Wed, 12 Nov 2025 19:43:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C0278E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F56412E238
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:45 +0000 (UTC)
X-FDA: 84103736010.26.39657BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7E472A000D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JlO/r7Cx";
	spf=pass (imf15.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994623;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIfGp0HIStp1tu7SsYUjcI67h5Rn6PIuvSgXA9FIiMU=;
	b=rJCW352l491NHpURzuw8eiI982URfGo+ByD8njADXOgj6ehUBpx/opky9LP3cYLfbeRqrW
	5kuziZepodoQ/aW2TBBllzCkqnyKXJIMCuy9oqD2VSDPQgYoXwipvKSrQSyyzC7+manJqh
	HbJ1dlYlV8kjBEZQeoSIdm5/+jjk3CY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994623; a=rsa-sha256;
	cv=none;
	b=pKhFPBRB9yOMmHGbEYfey/IgogjectugWyliGkdvR9fe56ll4GZZ3gRYIfZ0Yoo/k6D2nq
	hpWYElcAOmx8sUTnm6xfgKluFDarbctpPNznodp7qqscgYxWeWfHO02UXhVrLkNj0PntCZ
	zo0EUGfBybPKst2IVe72VGroeLeMe2A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="JlO/r7Cx";
	spf=pass (imf15.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 904DE6021C;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D928EC16AAE;
	Thu, 13 Nov 2025 00:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994622;
	bh=CqInFrBaKchBNEHG/Ro0YLP1E73335mzqEPzKeUi6b4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JlO/r7Cx1UBHu/+nCR5M6M99Z/CIXyva3iUie+1Fe78Po5XBJ2qZLXXg18Id+TO+J
	 4EYx+uCUhStqOMgzFVjAb/7geAExX20WE75AXElMxTbYcu/BR1INmP5xBZQSfbOE0J
	 bbJTaNnOT8BRTsUgcAEobNMQZYQ6KHuA9Wxn/y3WDOhYUAmZ9DRZmsRAvf3F+TcbIq
	 KWjZVBQJI9IOBhs6viOM7ggoI18Dypt2Y78CALny/PxTEZZKEpMzzSIvZP+3AZvo0T
	 yEY9ZfNVFWwlLydFCef8Ql+DKR5FYp7o13XrshXbtRwJlPL4aXiyUHY+Tnt0Fza4eZ
	 lLL8uRBQPQDTQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7DE0CD4F2D;
	Thu, 13 Nov 2025 00:43:41 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:01 -0800
Subject: [PATCH v23 03/28] riscv: zicfiss / zicfilp enumeration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-3-b55691eacf4f@rivosinc.com>
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
In-Reply-To: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=3576;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=taPijq5zqeNuOB2Z6LTam5E9/MI20PvhyLXut1PkwcM=;
 b=Z4eC5Y3hzcpETeoJH9MnYdZa3a1VYcQrqMeJHdm7BsJdI8PpiUTqKiCbevMD2eWdxODTQN/lA
 vl1G3BtQa8ZCqCMVzgPxCz0RNDiqmWJD6/SO9jwjUlVoI80mB++H8xc
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E472A000D
X-Stat-Signature: 593t97gb677ensuofcuhhi3fxr99cmwh
X-HE-Tag: 1762994623-748523
X-HE-Meta: U2FsdGVkX1928MtT0lDa6bIoFv4R0sEa0Twx2SjZjGZ8o0yiK/t0b67h8TDtH8BKrBUlOrZJe7crFO51okgp8af3qRUmWWXnXMw/RPdImhMk3zlkF/lZEeYYUAQOfvR1XoL515VyTEZI37+wsAmTyT6pCE5f2FaFEK9D4hYh2ESG4RWMSBMFIMXpViuCg444YXOc03RXJhydM35t2aCmZk3Bv6gVIOTgsiwpS0l8b8JItVqDJEd+gE3iBazYh3ekmyykgcG4mycSM+DohXrOkuHErI6oqB3EPtFH7T0I2hPFtMYw8n4e/PBs4gsSUovogwJsf4Ub4/ivaamoI6uv+vQ9aYj+Pop9nBJ9m/YTeFLTsJain7maIIowg5C9UXgaqZ7zXg6uk1Sx3zfWjTR3MPE5HsAPQ5fAq2iq79Ltp70aNRIjmfpvGgRWais6XEHbmt6HZSRbi5yFIsXHdW9LFUF+cW7FjOz4zacrbCDMfRm8B7JZDgDijvsktmEDq3dGJXtjON21zYPNVkYhsQ9joxF64YBVMnUl6v01VNR2kkxTkf+0xGxDOmRfpHYO4Y9/Jhln6MNk/J+G4M8aRulHSk88kwn542HnzeREv4vMCA+qn8mGCZJpak308nxd0lMHLl3N/xC5wHKZ+DvKKK3/6B7dGo0SNmytKgFwvISzxpGCO8buWTCYZnhB41KM8zHYbPsY9FvZO6wXHtzBBxojJEs7o+WTsFUVqKxstS0B//eZ0KR8Ntb8Z1PEI21Fiq6nWACJxV4oWub7ntHqHaFOY9Ez8Se2tadKYVZ/qPmvW6PQHhMfV4Z2OAkjDvogsamafoaZkVSM84EGfEgo5sQz6Mdo/JKX5s5WJ/CIA4F5DmicuPnmyj1YxceEdOigBnUSj1B3Yl+1SVl9q4OldLkLFB8fAR9OTr5PiHziPva+xoyjagvi7GFuVxYLTzmVPHqidCgzawlkELEm6RAaJU2
 GKfz3JdE
 /RbctvdJ62iH/+ZoUSPg9bowoWDs8ngi/7VVKsl0q1NVyjZg3WtoFplgj1vlWJjMkppOhTrqm+yGbNKZrzB0aYWMvsjgRPDU4zwDAWULvy8eedFRn7WtMX3j2XQ==
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



