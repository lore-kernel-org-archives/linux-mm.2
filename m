Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8275D339AE
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EADC36B0273; Fri,  5 Dec 2025 13:37:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E848B6B0275; Fri,  5 Dec 2025 13:37:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25AE6B0276; Fri,  5 Dec 2025 13:37:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA55C6B0273
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 854C0C02A6
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:39 +0000 (UTC)
X-FDA: 84186275838.10.84CF83C
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 756B920008
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=dheXU8MB;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959857; a=rsa-sha256;
	cv=none;
	b=t5HtG8Y7iP+LmTtMDcNgJGud3GxJO1kuzkSJ0DewMgVl+sefjBucioH+0AAf1QzQMmHynC
	LHHTu6XdDNxOttEap1rFfCJZ/9zaPoXppoFGvn9w8NuSfZyYcD5kUrcn/l6IoJsBytgyUz
	zzkjAhdNI4crp7lSS3cTS5ALcY6uBic=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbIk5cCPbojOJ9uTDKoU4N3fqpVL6wCeA1bHhTiYoys=;
	b=1AWLQ80f49udwWk5/wzLgaFrQQeqdZJn+yuKRIWZ9PL9tEje1qEFPojUQ+VXPvYJfhbiNU
	Qps5T3JoSb4U6laK/h/bohZsUzPMUlcAjTfMmYFYflEtyEyV7KnajatFhE6lu2p4intEwg
	AEL989+0Eb0W1V99EzpyVqXnKdT7/FA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=dheXU8MB;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-bc8198fbaf8so2122305a12.1
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959856; x=1765564656; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FbIk5cCPbojOJ9uTDKoU4N3fqpVL6wCeA1bHhTiYoys=;
        b=dheXU8MBGeHxNgKULObAmTru0+ybyKCPk3pBMl4Lp5kfnSi8xBXlxRTHEsmadGx8L9
         yF0tYLmDmKV1NAfPh9yQW8LfUncka5R4Ae2yLmq1SRGPGETZnZBOQwzz+mzoJwzQfOLu
         XdPAklQATbJucF+A6sfmlRRcpAirZrxG9SERf8vJ5Lt2roV5SNZ9Eiig2HCvD41WgVAW
         EIud16kanUDsXmDQ+UNvn9aAe4+8KeFKB1NSI5WTHgRKOQP3Xjn9J4OQen57U6/svpAI
         if+LMJeRPNKJrZZdW5Cz8VVIOORMJKuH8dI3GTC7TrIviqOdkznaMkz8K8jQ4HPonyug
         1S/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959856; x=1765564656;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FbIk5cCPbojOJ9uTDKoU4N3fqpVL6wCeA1bHhTiYoys=;
        b=rWmXEztHhKV9ViOphGzWbshPq1q592E/R0JsI8lrIpp3xdmJh0vW0sRosrzzO3YZyD
         EL/9kFRqDUnznjZSMclAvGuIj1T8Io+NPeJSuhTVsmIEvhgviPi5ZE3mDejzPod8ouOj
         fYhYBDPvAJb+ROQmxupo0gDuNlbYbiZZffzbLPqFUjb3+4TC2lA0Oek4wLbHjuVJpHpg
         Y2o8ySuc5SEg+XZDiGy9G4yjqpdHqiTF6yc4P8LS13e3fy63p8kj5DwrVPKIQU3X+hNI
         sRwGkQMWxhqe60nWBG/NbCOQaC3fOeCslv5ItnqixEo7OlmCY9R3CfuTedL1js56Nh+J
         2JCA==
X-Forwarded-Encrypted: i=1; AJvYcCW2koqWefZBxbcHEsa+wQsDzdn2FpwtZ8RQ01CO273+m37ek/w4QYLPQVizYC/ArUjcEqqJRQIiCg==@kvack.org
X-Gm-Message-State: AOJu0YwvlNa95IEmaF3Is5f2CfNVH14xuXGqKhqXR2AGSSjgz6ttM0Tz
	YZJ+WhrJTnaRA+iQ+joa4qmVqg/cjX2U4Y8mYHADuTQ0yFR1TLhgjf+tMBAJXGsDWBY=
X-Gm-Gg: ASbGncupIWSWL0xfozysEUFUsPSlmlNJx5YFEr5iktRRjArOhJmsPDF/g0P5F1L4Z4Q
	7W3W9mWSO/QYRfBMwmLkcD6Pm26AY7uLRz7+RG0e0iRYlnvYHDYHPg9th7BAp2Yg3ZFvCHZCwgp
	PX4oA+X4Plsg9M0bOssx2dNU6Rrmjz3QHyG6O5zZ+T7O38tOJxmiwgLVrNzmipXLw6Qq8RJH7RL
	ruJZ38/P5hzFxsYpvW+UK0HTaw7SUzKZ158hppj4B2vDg4m/8EygdzI96H/9fSznaKYVG7TqH93
	idVv24Th7evlxc1uQvOebRDodZ6K1I5tY+NLJHXklwviooDeHXSog7409Acdc5Mvp7Sc9gtzjlM
	FoK9fGxUzp9hBeafDk5vXOoQyVG5UUy8mtiBM/ykyEVSh1zfRaEA6vthPO1py9iS7Qd1oIMC19Z
	jx2X+cWrEtyZ1G1BBs85nx
X-Google-Smtp-Source: AGHT+IHkjjsKzqNtkRXJFYg+Yls4ZdsONc5juLvXKNvtnLO3/ZLQmkbs2RVd7+58iM/Zo5/Mwe0wYQ==
X-Received: by 2002:a05:7300:f40c:b0:2a4:432c:1e63 with SMTP id 5a478bee46e88-2abc712a348mr94020eec.5.1764959856105;
        Fri, 05 Dec 2025 10:37:36 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:35 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:37:10 -0800
Subject: [PATCH v25 24/28] arch/riscv: dual vdso creation logic and select
 vdso based on hw
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-24-8a3570c3e145@rivosinc.com>
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
 Charles Mirabile <cmirabil@redhat.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=9634;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=x3JVG0Npt7Vp6FJ7VZ184tzfxWj7zfRDDLEdRgBiASw=;
 b=DP0jaDo8GMIVR5mv16tqNdKkiXt+tqgS8UirLPKq+8lp6UPqdjFktNR5NSTnwQRkwH0UgQ58P
 gpSrWB1JqGOBa+zu4fC/nK7ifQXFg/wW4GVPQ/FV3XBbm/HuPXFvCVB
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Queue-Id: 756B920008
X-Stat-Signature: mde18n57o6yx1rymb4k17eimoiqu1rj5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764959857-886061
X-HE-Meta: U2FsdGVkX1/hy1/GADNTyhSO533gD7WECE9ohQfQTFc/nMQdIdstp2L7LdFuOC/Szb+8Sm9LSn1AGLTuQ2qtIEYQvg/YHFDWR5inV63P7i1qoD7zBY80mdDge4IhntDmzvvMZgaH489eTHgOdEUfqp5dqijIJKRInngPNcVxaJkCAwjVrkiC/IskreZrc9BXxGR2Sip9j3RP9HcJ+CGRUhH2Ou/HUpr1lH0Ki+qBR4Mhxhf9gk7XtOG48IYMcf9nx6g1roTXdmhzEH191nmMBw/T7dle7D9R4dZhi3IsoLzQOKgBXLtN7cIDyziVX5v7tOTo9ZYNlLp96NLab6nxRvfTanjLGmgnrk+FTOQ7jWxWLv4Oaczgs1d7xJJLLIPQXBA8lPMfTodFkzY0QaqokauxZCuxyRCods5BRUyIRnIqIplRPpyMnK/w7RsGWrrzUKodSu5ExYpoWtMkgEiWY22858MHoZ8gSlM2F1beHxQTV59/+rgslQ3obNa/SW7TfqMQv4Lcn4s9weZo2+XrakadCuCZDwc2vUFACz3Fa14kfTS87eY8miFKpJc4M9h9FLhtxQOl+h6a99kH143nz1TclbRlR44gaHchyD0JLIA82JP22RTFEbhIMxPt2Mm2s1PlobYvPr/2g3UaMRzzqAxSrpO6X/uLcW5iB4ANkAgqNt61G3nYxsiWilScqpJRyhc3BFQF49uPExP8x5gIbBOChbMMXdpx2JDNWGs+HtCcSuvMRwCgxRqyCJN5wEhL8irTn85l1T/SKOpV/rhf8sF3P2UjpWPszT167cu2ud6+cW3dm4F4Gfl36X+PXK39Do0E65yRwf8CLJM47pMpd/Nz37yYViRzb6cTmheb0ZAea3PPC/6T8Njxlbocxaa0JDAT/pbT2Xiqi2qkdILR0u6AlsbdZtmV4W0PqoW/9CcAhMVZfiTBmo8s6ktOVnkcH+gcv/qJGH2v/wvZCG4
 I9/pFfTM
 HInZN3YexmSRaryJrX+/8RkeeUzHFBhpq3rTSuW9FXEXn3WSYDHIdVzXH/L1BJWuAfxWGTEfL1Un20OFRp55a/C/gk0T3TmfB/IXnh/PTSxQ+ey0DmzPyXDyKc63eCibAZtWhvNhnm3IJtGVSTi603t+xkpcJftrlxBoRBEq2h5BW/3xzSXJXUBtA/i1Wez0GlpLkj/AINPzW9rkE+lAzn+IQvnTuJdm8e8mW8s1jh7MUkLZ69YpvsIfYSLjqOt9Z3HQu2HCrdfZFi17T42/FiequYkry/28P+hzTUWNC3H9WHLhILyQHD1gfgHO5sWo4DO/mMhswldkFUD8EsxRzMqlp0Xc8IGFNDgCgiPkd59iKLtlqoNepRSiyvfosqTUcVmcCCu55vf55XIkrnoeJBMDPwHdXk6jQ4t9pKFCFag/TIoavy2SK44WAbaQZ4mnpuE4yUEqsyFemOTcDnu/Ippx5UPYdKXpGZFmQ1s8yFYFr8CGrJHxb7IYe7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shadow stack instructions are taken from zimop (mandated on RVA23).
Any hardware prior to RVA23 profile will fault on shadow stack instruction.
Any userspace with shadow stack instruction in it will fault on such
hardware. Thus such userspace can't be brought onto such a hardware.

It's not known how userspace will respond to such binary fragmentation.
However in order to keep kernel portable across such different hardware,
`arch/riscv/kernel/vdso_cfi` is created which has logic (Makefile) to
compile `arch/riscv/kernel/vdso` sources with cfi flags and then changes
in `arch/riscv/kernel/vdso.c` for selecting appropriate vdso depending
on whether underlying hardware(cpu) implements zimop extension. Offset
of vdso symbols will change due to having two different vdso binaries,
there is added logic to include new generated vdso offset header and
dynamically select offset (like for rt_sigreturn).

Acked-by: Charles Mirabile <cmirabil@redhat.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/Makefile                        |  3 +++
 arch/riscv/include/asm/vdso.h              | 13 ++++++++++++-
 arch/riscv/kernel/Makefile                 |  1 +
 arch/riscv/kernel/vdso.c                   |  7 +++++++
 arch/riscv/kernel/vdso/Makefile            | 29 ++++++++++++++++++++---------
 arch/riscv/kernel/vdso/gen_vdso_offsets.sh |  4 +++-
 arch/riscv/kernel/vdso_cfi/Makefile        | 25 +++++++++++++++++++++++++
 arch/riscv/kernel/vdso_cfi/vdso-cfi.S      | 11 +++++++++++
 8 files changed, 82 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index f60c2de0ca08..b74b63da16a7 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -176,6 +176,8 @@ ifeq ($(CONFIG_MMU),y)
 prepare: vdso_prepare
 vdso_prepare: prepare0
 	$(Q)$(MAKE) $(build)=arch/riscv/kernel/vdso include/generated/vdso-offsets.h
+	$(if $(CONFIG_RISCV_USER_CFI),$(Q)$(MAKE) \
+		$(build)=arch/riscv/kernel/vdso_cfi include/generated/vdso-cfi-offsets.h)
 	$(if $(CONFIG_COMPAT),$(Q)$(MAKE) \
 		$(build)=arch/riscv/kernel/compat_vdso include/generated/compat_vdso-offsets.h)
 
@@ -183,6 +185,7 @@ endif
 endif
 
 vdso-install-y			+= arch/riscv/kernel/vdso/vdso.so.dbg
+vdso-install-$(CONFIG_RISCV_USER_CFI)	+= arch/riscv/kernel/vdso_cfi/vdso-cfi.so.dbg
 vdso-install-$(CONFIG_COMPAT)	+= arch/riscv/kernel/compat_vdso/compat_vdso.so.dbg
 
 BOOT_TARGETS := Image Image.gz Image.bz2 Image.lz4 Image.lzma Image.lzo Image.zst Image.xz loader loader.bin xipImage vmlinuz.efi
diff --git a/arch/riscv/include/asm/vdso.h b/arch/riscv/include/asm/vdso.h
index f80357fe24d1..35bf830a5576 100644
--- a/arch/riscv/include/asm/vdso.h
+++ b/arch/riscv/include/asm/vdso.h
@@ -18,9 +18,19 @@
 
 #ifndef __ASSEMBLER__
 #include <generated/vdso-offsets.h>
+#ifdef CONFIG_RISCV_USER_CFI
+#include <generated/vdso-cfi-offsets.h>
+#endif
 
+#ifdef CONFIG_RISCV_USER_CFI
 #define VDSO_SYMBOL(base, name)							\
-	(void __user *)((unsigned long)(base) + __vdso_##name##_offset)
+	  (riscv_has_extension_unlikely(RISCV_ISA_EXT_ZIMOP) ?			\
+	  (void __user *)((unsigned long)(base) + __vdso_##name##_cfi_offset) :	\
+	  (void __user *)((unsigned long)(base) + __vdso_##name##_offset))
+#else
+#define VDSO_SYMBOL(base, name)							\
+	  ((void __user *)((unsigned long)(base) + __vdso_##name##_offset))
+#endif
 
 #ifdef CONFIG_COMPAT
 #include <generated/compat_vdso-offsets.h>
@@ -33,6 +43,7 @@ extern char compat_vdso_start[], compat_vdso_end[];
 #endif /* CONFIG_COMPAT */
 
 extern char vdso_start[], vdso_end[];
+extern char vdso_cfi_start[], vdso_cfi_end[];
 
 #endif /* !__ASSEMBLER__ */
 
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index 2d0e0dcedbd3..9026400cba10 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -72,6 +72,7 @@ obj-y	+= vendor_extensions/
 obj-y	+= probes/
 obj-y	+= tests/
 obj-$(CONFIG_MMU) += vdso.o vdso/
+obj-$(CONFIG_RISCV_USER_CFI) += vdso_cfi/
 
 obj-$(CONFIG_RISCV_MISALIGNED)	+= traps_misaligned.o
 obj-$(CONFIG_RISCV_MISALIGNED)	+= unaligned_access_speed.o
diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
index 3a8e038b10a2..43f70198ac3c 100644
--- a/arch/riscv/kernel/vdso.c
+++ b/arch/riscv/kernel/vdso.c
@@ -98,6 +98,13 @@ static struct __vdso_info compat_vdso_info __ro_after_init = {
 
 static int __init vdso_init(void)
 {
+	/* Hart implements zimop, expose cfi compiled vdso */
+	if (IS_ENABLED(CONFIG_RISCV_USER_CFI) &&
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZIMOP)) {
+		vdso_info.vdso_code_start = vdso_cfi_start;
+		vdso_info.vdso_code_end = vdso_cfi_end;
+	}
+
 	__vdso_init(&vdso_info);
 #ifdef CONFIG_COMPAT
 	__vdso_init(&compat_vdso_info);
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 272f1d837a80..a842dc034571 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -20,6 +20,10 @@ endif
 ifdef VDSO_CFI_BUILD
 CFI_MARCH = _zicfilp_zicfiss
 CFI_FULL = -fcf-protection=full
+CFI_SUFFIX = -cfi
+OFFSET_SUFFIX = _cfi
+ccflags-y += -DVDSO_CFI=1
+asflags-y += -DVDSO_CFI=1
 endif
 
 # Files to link into the vdso
@@ -48,13 +52,20 @@ endif
 CFLAGS_hwprobe.o += -fPIC
 
 # Build rules
-targets := $(obj-vdso) vdso.so vdso.so.dbg vdso.lds
+vdso_offsets := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),)-offsets.h
+vdso_o := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).o
+vdso_so := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).so
+vdso_so_dbg := vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).so.dbg
+vdso_lds := vdso.lds
+
+targets := $(obj-vdso) $(vdso_so) $(vdso_so_dbg) $(vdso_lds)
+
 obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
 
-obj-y += vdso.o
-CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
+obj-y += vdso$(if $(VDSO_CFI_BUILD),$(CFI_SUFFIX),).o
+CPPFLAGS_$(vdso_lds) += -P -C -U$(ARCH)
 ifneq ($(filter vgettimeofday, $(vdso-syms)),)
-CPPFLAGS_vdso.lds += -DHAS_VGETTIMEOFDAY
+CPPFLAGS_$(vdso_lds) += -DHAS_VGETTIMEOFDAY
 endif
 
 # Disable -pg to prevent insert call site
@@ -63,12 +74,12 @@ CFLAGS_REMOVE_getrandom.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
 CFLAGS_REMOVE_hwprobe.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
 
 # Force dependency
-$(obj)/vdso.o: $(obj)/vdso.so
+$(obj)/$(vdso_o): $(obj)/$(vdso_so)
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) FORCE
+$(obj)/$(vdso_so_dbg): $(obj)/$(vdso_lds) $(obj-vdso) FORCE
 	$(call if_changed,vdsold_and_check)
-LDFLAGS_vdso.so.dbg = -shared -soname=linux-vdso.so.1 \
+LDFLAGS_$(vdso_so_dbg) = -shared -soname=linux-vdso.so.1 \
 	--build-id=sha1 --eh-frame-hdr
 
 # strip rule for the .so file
@@ -79,9 +90,9 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
 # Generate VDSO offsets using helper script
 gen-vdsosym := $(src)/gen_vdso_offsets.sh
 quiet_cmd_vdsosym = VDSOSYM $@
-	cmd_vdsosym = $(NM) $< | $(gen-vdsosym) | LC_ALL=C sort > $@
+	cmd_vdsosym = $(NM) $< | $(gen-vdsosym) $(OFFSET_SUFFIX) | LC_ALL=C sort > $@
 
-include/generated/vdso-offsets.h: $(obj)/vdso.so.dbg FORCE
+include/generated/$(vdso_offsets): $(obj)/$(vdso_so_dbg) FORCE
 	$(call if_changed,vdsosym)
 
 # actual build commands
diff --git a/arch/riscv/kernel/vdso/gen_vdso_offsets.sh b/arch/riscv/kernel/vdso/gen_vdso_offsets.sh
index c2e5613f3495..bd5d5afaaa14 100755
--- a/arch/riscv/kernel/vdso/gen_vdso_offsets.sh
+++ b/arch/riscv/kernel/vdso/gen_vdso_offsets.sh
@@ -2,4 +2,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
 LC_ALL=C
-sed -n -e 's/^[0]\+\(0[0-9a-fA-F]*\) . \(__vdso_[a-zA-Z0-9_]*\)$/\#define \2_offset\t0x\1/p'
+SUFFIX=${1:-""}
+sed -n -e \
+'s/^[0]\+\(0[0-9a-fA-F]*\) . \(__vdso_[a-zA-Z0-9_]*\)$/\#define \2'$SUFFIX'_offset\t0x\1/p'
diff --git a/arch/riscv/kernel/vdso_cfi/Makefile b/arch/riscv/kernel/vdso_cfi/Makefile
new file mode 100644
index 000000000000..8ebd190782b0
--- /dev/null
+++ b/arch/riscv/kernel/vdso_cfi/Makefile
@@ -0,0 +1,25 @@
+# SPDX-License-Identifier: GPL-2.0-only
+# RISC-V VDSO CFI Makefile
+# This Makefile builds the VDSO with CFI support when CONFIG_RISCV_USER_CFI is enabled
+
+# setting VDSO_CFI_BUILD triggers build for vdso differently
+VDSO_CFI_BUILD := 1
+
+# Set the source directory to the main vdso directory
+src := $(srctree)/arch/riscv/kernel/vdso
+
+# Copy all .S and .c files from vdso directory to vdso_cfi object build directory
+vdso_c_sources := $(wildcard $(src)/*.c)
+vdso_S_sources := $(wildcard $(src)/*.S)
+vdso_c_objects := $(addprefix $(obj)/, $(notdir $(vdso_c_sources)))
+vdso_S_objects := $(addprefix $(obj)/, $(notdir $(vdso_S_sources)))
+
+$(vdso_S_objects): $(obj)/%.S: $(src)/%.S
+	$(Q)cp $< $@
+
+$(vdso_c_objects): $(obj)/%.c: $(src)/%.c
+	$(Q)cp $< $@
+
+# Include the main VDSO Makefile which contains all the build rules and sources
+# The VDSO_CFI_BUILD variable will be passed to it to enable CFI compilation
+include $(src)/Makefile
diff --git a/arch/riscv/kernel/vdso_cfi/vdso-cfi.S b/arch/riscv/kernel/vdso_cfi/vdso-cfi.S
new file mode 100644
index 000000000000..d426f6accb35
--- /dev/null
+++ b/arch/riscv/kernel/vdso_cfi/vdso-cfi.S
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright 2025 Rivos, Inc
+ */
+
+#define	vdso_start	vdso_cfi_start
+#define	vdso_end	vdso_cfi_end
+
+#define __VDSO_PATH "arch/riscv/kernel/vdso_cfi/vdso-cfi.so"
+
+#include "../vdso/vdso.S"

-- 
2.45.0


