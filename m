Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F304CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41DE68E0092; Mon, 13 Oct 2025 17:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC888E0031; Mon, 13 Oct 2025 17:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226568E0031; Mon, 13 Oct 2025 17:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03E218E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C000F160657
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:07 +0000 (UTC)
X-FDA: 83994449574.07.C456717
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id D7EB91C0005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=b6R+bRUa;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
	b=BYTq6TbuL7C64Hcg8W4x1T5RRzcQfFNCZRKYoVBaNkZ8NaayeA6DHpQnPJVN1GpIg5ZaoT
	Dfosbs82mfDsZi2ZYALftS4APYy3j8tKpV8BVnhBfHfojaPXOhErs4Nag/JaPGn0szHbIH
	O/82F+/YiPq6E1vHHhxVZeyk721Q9QA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392565; a=rsa-sha256;
	cv=none;
	b=GKh1Mf4SZoGimcCa09jBEARvnF/09fOczz7rZMGSUHlfB/5eqfjmnaK6T+mM2JJChOK+6a
	Anv/0JXZGDWiMIYofBkG8+0nevI6gutTMJr4oncO4qNf2vo/Lge7VIvCiW36b+RE+gPVJA
	eXZUN3DRXFIVbg9gCi1GY1y+PC7zUrI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=b6R+bRUa;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-330b0bb4507so4134178a91.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392564; x=1760997364; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
        b=b6R+bRUa5xTTaF4sQiJR2LAK/zswAZffNjtoRrAZdg5ZBtIjV3zzN2495wg50zm3PG
         AM35GODum8E/LikKBIc/aG9UPikLWDb+riGROMmC14MU62APq7WJYXrCouZYCsUtwMxE
         bXoX2/P8oEVvCZikrZ6bVRMiDCeZOFlIvk3m5r6Xub7AqRV4n5pEjZoFJozjqgpvE4QC
         8kCu0CTRcfmccXA8MKzGV5zjxOOvdBe6hqf/az4ZOSvArAvqBnlX25LHVeYIJ3g8WRj3
         Q/5Ak09lbmoWyi9h1Z1LgOWiR7Vm2KxyQDLr+BDdYBtk1XNBhbcJu8BdqzxwrJkzJa6w
         AsMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392565; x=1760997365;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=njWxpRWfJB7aZ6YZP/EJ8dyU7DPEUOfUxx+ytpaopVc=;
        b=HLEAMp3YdEss03N3/RwPOAWfRaKaojTvt7f9uFPk69HdlAFlC2FsCQTyyR6x5NGapq
         bRyaPyXqycEsrspKT9mBpJz8pCUNLwNqkCbBr6qRxwHIdgNJvD3M0zC/CYtgQ5Y0zf6C
         az/wvMEy4z3QPGXdU914z0erUjE03PcpuzwQsCQXm8/29bB73cKemPyb9SxiLGMDSM6X
         WBRvu6FNLtc/jOMOvvZVjk9Rjbp6lVfyKG5PaMqxdPRPy4+4H/8B61Y3KSdd1y4pA3mg
         XJeJUkdvY86uJUQRWkcP+3IHeIwIecflhngKIBYGZ9q165q8WNBjytctXC9DTIVcSrir
         I37w==
X-Forwarded-Encrypted: i=1; AJvYcCWy53RoqQuy9WtIdEWRB+7gdaeAFOqW7WVjik8fwLhARsSxDuc6ZZOhEHU9rxRp6Xyqqn5d3rL/dw==@kvack.org
X-Gm-Message-State: AOJu0YwsOFsxqiB+Pzo6WS1A3AoYaGLmI8XrZh53GX0DD9QB+yqVbTpP
	vbJGFaybA0lmmJwBAVifbKieKhvqcVzyXDBqzQMZB7eH1Zl30owFX7Fi29BLUF8eG5E=
X-Gm-Gg: ASbGncuNupU19gg4KH+TDeKrpQSZYYFs81OLRQYhczF9sDmqYCZQsWtYBBIchyczBwK
	2Sz+jwpg4fc7c5OYz0pMx+/E7ANWpw3z0xv5R0VyyKH8K7VP0iHr51ppelK5cevjnPxA8g1W+TC
	ayJaChZlHO7d3O3yheaRk4deSkZBhCoRYrtVQAU9u6Rp+TZvxuTpG/wDeBi0QRTeLHwM0RqrhoG
	z0cveKYsV3fmAhsjIKM29QkiSK0JRzeKXoKPNSePv1FNMBKsQlWoAZpJT/Ge1aLOdHZQzBJ6GMc
	GkcZKZJSMuRimE46RIEUfCi5jhiq7nFfevXuDky03MQflkRkSBfOWzNI3pKcXgJDFWJUqb0VHqX
	2dxIjP/47umOjod2AnheDOeWQGbKWm1kmdcQUEcdNq5wWrZLUu1oJQKksykaO1Q==
X-Google-Smtp-Source: AGHT+IGaJ0hlMQvTUlGZru7b5N/J1S6cO4YB5MuFyO13Me7Mix+oEAnTW5bDNvBtx+FojGYD24gORw==
X-Received: by 2002:a17:90b:38cb:b0:32e:f1c:e796 with SMTP id 98e67ed59e1d1-33b5138404dmr29971759a91.25.1760392564584;
        Mon, 13 Oct 2025 14:56:04 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:04 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:55:55 -0700
Subject: [PATCH v20 03/28] riscv: zicfiss / zicfilp enumeration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-3-b9de4be9912e@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam05
X-Stat-Signature: 3tjxy91sugbh3n96o4eqyf74k93j9ejg
X-Rspam-User: 
X-Rspamd-Queue-Id: D7EB91C0005
X-HE-Tag: 1760392565-582732
X-HE-Meta: U2FsdGVkX18X/ivCOjH1xImyDZkbYkKnf01czLERGKS4R/2v1Myahl6g2VnwNB4OGkZsbcTbU101PeNaSr8rcbJdPZo0lg9jXPVVvTYN0lopn3hEBoZJhYTvfjiWBttEekJ+71mx3Lm9B6PuL2bdxGQE0X4E7RAL/slM2O7oCOZkGj4l3B6T/tuHlQX9S00ohILup05bf/0KQZMqIoN9SfNVbp65oAYG66/19Jdas4DTi6nDlmnakvYs3h0mLZMCzjwMqzdK2hTXbiIGFd1ImDH/6/bdAa8X/mijvAISfwPthlm91r7ZwubyVMLclS2kyk3PtV4lXvrRqCprcgPuHSrkvnp+AdbnghyZPJhS/Fa7K0WLFFX/+WhvWWTRnvIGw9Lf1GiJv6GZl9uXdnrAW7FwAOu4sg4NfuPZgC9Fh7ayLUO2zYPRBAQBfpYBttM+wsjzbSnI96lLGUCCejm6lv6LbNUcAvm6syLsJgoHLIdLn0XWuHyMVKOenDASliTrLJxc0nidZFzN405foiuBW/JSdlo7RFMEMJdPFpuNUwsPvAowAWlrh+4ABiWHVt27NqPQoXArAwCuHoa+PpZqSAZubQ59OSEvtfwy99+bivpRWAuqtcDT3BC0JmL/Znd+kjotKYbMIfnpP6ny5vHuSweCT+s0EYfH3QfW6x4cb8GsOBVBVs4f8ieZSnkbl8VLRXpb2Xg8IusKI+CMYdL0BUd8vB4AGrDR9Q5K90hv4HWmh7/zD29mayVhbYANSMSVX/clv4H1bq+bC0JPBXF1ldKAfgLsLfu4kQkjx1Raw5rSWKy375/DA4IoBWBwtBVRCNdAmdopRH+SXU7nD6kHRpM1YYvj/FFkXo4YHAdoBFNZ46yyHZ3r5p5p7ClPjvfOWWN8ejlziHkUVUS1J7zq9Hf2Jnm11HqFj2S4dTpdIs+C1sbDZlxl3fK6MyOogLUDFH3oXuWmPXh1Dgpydkz
 3fS3357q
 h8FcvgNNBXS9JxIY7gjvd0ERdKgQVaOrpT65p5IdKVxHPC9tRhhkiZPfAlubhqwwbI8bnoyanBUgQAXMh7HKWqj74e+YIAPiIUUb/JR1QlCNL9j6lezVLstr/PddL+Z32Ui3gfTlo8+BF5haZnSpIi0IKGKOtJdjr+PjK/LMW2DN+vNZzBHJ5INzLXENljnj+cY4T3Li+jX/kl+CNdk6BoG/iJCvv3ffLz+eB6tGf+SU/ypTIeUciFhEsZRnMYPQty+75eFmDvVwR7SDtx1ZLB0QoUB2DX5d4wkGsv3m/5ST9HuwBc+jRxuT6Pe23sD5I2gybLYdzckTntHwADRTdvcF3+J2rE+KzbeDgFZV71/x0PvOVXwcopsO1bY8C53eaubeFxzsKMuoYcw9lcN7cH3WEVUzIY3+hhzm5Fpx/7QQJ4TnTEHml7OBEEmidOwtmBiXCi3oOL4iU/A5ijS3wq42oUQco0h+PkODT
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


