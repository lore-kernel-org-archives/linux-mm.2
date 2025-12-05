Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB89D339B2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3142B6B0271; Fri,  5 Dec 2025 13:37:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C57A6B0273; Fri,  5 Dec 2025 13:37:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F7B6B0274; Fri,  5 Dec 2025 13:37:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F298A6B0271
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:37 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7EFC1602C5
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:37 +0000 (UTC)
X-FDA: 84186275754.24.05345A4
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id A4EE9180008
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=cmOBAP7E;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf16.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959855; a=rsa-sha256;
	cv=none;
	b=SxxVJPpg6P9Wb+9K4+nQ2cjbWjyUjSXJe8ksxyUWEMtfdSWS/arN40A51wnRfbj4ENo7v+
	KAp5aHSOIxZkotSe8J8hObRVPgGAuTnzvp5aKO3SU6/qoRw3OfX1OC41uLuuunXXAX0O2B
	CBRjxKfgCBTbu0RGpCrZygcCv7QpBuY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=cmOBAP7E;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf16.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lf00JiW6xSRH4nKpJE2Wt9C2ia6JwPjEocHrM3GZrHQ=;
	b=2NBNlLWRIH1WP5ewJxqaGsdeQjDXqLDm3pYE/34TLD7kApsCTbuilqQeUlf5/3pLxU1bGP
	ZvQi2VDtYdWRNS0HIGtWz9OyBqw7tB9tPVVMlgmAY6cIe+pjxEMZ9IuPEuPHjOBCfikDOJ
	8v8Bt7YHZnL5OcWbkeezofJSvpxVJK4=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2a484a0b7cfso4134203eec.1
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959854; x=1765564654; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lf00JiW6xSRH4nKpJE2Wt9C2ia6JwPjEocHrM3GZrHQ=;
        b=cmOBAP7EKyxO3ijAmjkfVNCaCu1I77qUxTIHkFLkAmf2BXPoBU5XzAMW6yzWAcSOxP
         L8C2h078cq2HUQmssxUuJgOuCRwKeE2olDKFVHg33n8W+8stKRu6b+zSJgcwRHWxS26a
         O6x1cVRJwCGAZYsrvNAN1/d8f3h5oeVh3/2zNZXfLnEBQY1iD1cpDSYVkYKUVCgeKmnp
         avlaqc3cW0QVCtbmZYZZwwOXNF949RiofhUgb6GeUGhQNQEVjznOIyJT9e8ZsQ9++aNf
         rntYhebwgvWL6rH9X+Bvs0WTfxG9ohUjruB77Y+BQaW95m++4yX+0yO6EKTKC/+pbdCd
         XvAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959854; x=1765564654;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Lf00JiW6xSRH4nKpJE2Wt9C2ia6JwPjEocHrM3GZrHQ=;
        b=FqqL0Qkpk2IYRWdp8yCCGxHnRSvacvRXwpF7xBebOLD1eIrUbyJeIAsopuo7Zdki5j
         62QyDk1HZBVSmINwIjVuLqHI4/zp4rVLuBrfCB9SYm+OJu3o8r5LHc6MP0MttuLp1T0k
         8avW0Nn1oanc9BM3WmhRPxVYgg/uQbMPttYoCt73EeiZSpjAKL+0skeaXsbfsTvNrqgY
         KdsQwoLTBY4Lgg3jk0OLGHAXn2tBmS6VeXm6mm7oJyt26xyVWj59YQlK09nE506qLJLK
         SZ6i4TQd5kLb6Hoz2FrsRSZF/KyuFybqo2S2a8vZxUp9Zn1Tof0Ylsxl3+059doAIch5
         lL2w==
X-Forwarded-Encrypted: i=1; AJvYcCWygCAHlJzXNkQPXdM/x2VIN/4CsappYS+tLPSbckRxle2pWJfuSqJwqQ3ffgIbz3pU+TtCwYoZ6Q==@kvack.org
X-Gm-Message-State: AOJu0Yx6rdAgNb34tuJqcc2xkrAn5h+0qDbluPFjsovGPOHz/wVVrNkP
	AUOhrOIJSAMlL3m7Wv25T5VaDF6mfcemJYqLHawLHBVQ7D/xKvgyD765Lf8IdKdpFBk=
X-Gm-Gg: ASbGnct/87HWze9kYgSZsPiGsYhRGn6xjhHIkh720apKb0YY9Ya9Zh9Ahu4oo3gfvOx
	zv/KbKoxvHDZnwMszuVJogeDe7RIwQPFO5cAA8wuCrQZdq7QdK6OssZs4lRjZg9TNCytIQf4O/k
	34pv+7DREhNTn3b4siG1MbhfZFmZF1AUgtQ0TtnImDt463YyJZO+0isVCTkPpE2a6JTeeGjBUxW
	Myb5zO6NUXX1yi3x1XZ8o4KbcjIPzh99UKzKSf3F/laqz08MtsSiQ30qKl9ORrStP6ydRzkMihS
	le/zEI5q9JVP5vvAB+f9PLtAn1MAEvQH419HHJ2OadDOgLD5mG4mc8V9EafixoEyVBUvsJPq/me
	fsNnI+VfYp70JFf5z2PEw8XMEX7N0z4ABt8zvXmbekyaD/cTqVbmq0R3GKmBKx6PzPGcayH8E5d
	1w+7EeBx8D/7MqwBcbsRTk
X-Google-Smtp-Source: AGHT+IGuu4ieAoskSnK0aRmIGPqN2OyEA89eLPHGbA3PzgHJnK9CeRThHGgT7ns/KwOFsLnXFzdSBw==
X-Received: by 2002:a05:7301:1698:b0:2ab:bd9c:284c with SMTP id 5a478bee46e88-2abc6ddb229mr172482eec.5.1764959854278;
        Fri, 05 Dec 2025 10:37:34 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:33 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:37:09 -0800
Subject: [PATCH v25 23/28] arch/riscv: compile vdso with landing pad and
 shadow stack note
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-23-8a3570c3e145@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=8747;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=0Fk/r+Qv6bmSDhChMXIRunw7/t9Xkhow9/FCLfzokMQ=;
 b=NQ0IgVRZKBbtE3ARBerBM7eNrrIEceCW3FYcRTtR7NpcGipR+2h5NHqcQRuWVj9t8bdjQHyWY
 r0CEcknxKdXA1RWqROX8tMSnmbh2tDn4b3tkzGvVj+ETzO4Gwc566gj
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Stat-Signature: krqtch8u9cqfmzj1rqj6oi1dajdat5s8
X-Rspam-User: 
X-Rspamd-Queue-Id: A4EE9180008
X-Rspamd-Server: rspam01
X-HE-Tag: 1764959855-370208
X-HE-Meta: U2FsdGVkX1+/EKOAbShLMf2/IaOgsxMt1R9lKL9BzdwieiBaEaeRwItRn2v9NRMimb5McB7ZbnbQrC9OtHAooQq1qjhDfsysQ+scAugnFdE8pQGlKx4t14B9GUW7sjGPsUpO4gsp0IVB2wOV5uVEU//CFUgK3ATAFtYDlErerwKDV+X/wJnJcujThN69tOYnpXtncbledBlIFfRdx9jBIXIZw4E5LKwDJBy4rgcGCz7lOIbCW3kq22U19icgVJ5Ie5L+XNtf83wPTTTq3k2w6727M+JSM1qF7NxC3b12MF0jIzT+X+UbXV+mo7AWibDPUvpX85G8WTJar20ALdlQw+cjISBMRhU+UuCn5x5XnGsTBEuOpOSyHsfB4wMyazILN+p0Rb0tkHEk/FBR6wnk4aAONGBT9+gSUfzgoMol7SrbE4sS0wKDty0tQN10AE3DARtwC0v159ymIQv7Kcf4f1vmCkuINPDR99WiFvtjlH72yxiDuRhZ0GFYj3wbH5b4xGSMf3pymVFYmcQqADoZjiG5UvT2IM7AZPLU4pw0Ew9ZY/S8uBZJFLe89+yHTfNSZkgwpKij09cHJM5NmvDu7qD9kqiBnZCCnY2WamhigYom/WrTTzH5WVT/Md5nR0UrXwXe7FaA32soKmPJkBMFRheTyOPE/XdnjQ5c0609ap8sBOnxuwFP8SzzTqL9syYrGV/fnrZ41n+FWgld2UKx16NUVqV45989lUBIVbz2foiGieWt9RnpqzF+59YOqyf5t+eg4jRD0CAyX143YPyr4momno9Czcz9jVgAJkubrE/bBiB6CcaemjO2g5VrKVsJ2vSnbch2m+FuxgMoi62ulco7qEXKj7pHHwsHb78iw1SP7mjXBHgZZuVgPPDOiMXASvh4xZUsgSYcCWyNg7SAvLnBZvQ+fzdtRaLX+uaNhe5pBN+GSVIqlOFl/+tKLttWBSImLAXa5AkIt65gsII
 pj450RQW
 CSn+Mc359t6IidZ/gd9ZSXsU38WJ+tA0bQuf+zkqXIMNLxn6JBO8Az9f4ZLNM+3tk7VHaMRvcKoojfILYgW+mZmtbAJlvvTJKThyHXqvOjYMbBjb1do+n16j3rlkW5RTzpN2TvBUqxbKuCvycT6xfsloM0IovKbwsHLvP3/C4r4eJKVXMtjyPlem/oNQUjVf3oAEKLz7C2h4+sNyZd9yXUSYKyItMNCEadtk1M6jVCqhBU8mayaoLk0fODVjtbDLsdarmJcEIEPgjWIhmecqCSrv9PY//9gDau9vUMYeHtZbJ2QcG6ei4CejMSIgmxw4hxgXtnfcVBOdp9petCzgP9J8HxRpzb8hElI2KU+m9psUAIsGp7k9+bGKu5pMKHiZ207POCyYl23oOS0c9Ydaf7sZmDWT88SaIIyqZLKN/wCeY13zScb+iCgAxrW8cIGocLRGEwhpeYc4qG1vF+QU1U980rZGdz4lDJFgmMF6Gz/tU3Fc2Ha7rCkwB/Wsf+4O+N5qy/uMEekHftC5eGYmGgb6HTA==
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


