Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E183FCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 356D58E007B; Wed, 15 Oct 2025 14:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307E98E006F; Wed, 15 Oct 2025 14:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10CA78E007B; Wed, 15 Oct 2025 14:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E84F68E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5997B7848
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:41 +0000 (UTC)
X-FDA: 84001149162.26.DAF3560
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id B2C38180008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=HoIPGY9W;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf16.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552079; a=rsa-sha256;
	cv=none;
	b=dyVvOgSbigki9PY7CQxTWm1uCq+qPphiSRCNj79Y0g0jlohcIkeM2fRxKfife24aJdE5VE
	2bpnaCPuqEPqm/VL/CoEtPYWxzSpTCn/NA9E3LJu0LvuV/5KhgoKKCml+MU+a76z2szRKC
	kSnr8YAZscAoaMSObE9qwVedJvkVW+k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=HoIPGY9W;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf16.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmCtoITTqmZehva0tB3sITF3D/xHoyXvDzDor4cab88=;
	b=Q971Cg/aaXjhzvGeUDuKARWpBFjh5LL8vBTPYBiCsie0ob0BqoQwF2WMvsZTQjL9r67/UO
	SsjIUnec4w+2xaLA7Lfs/VBF5xomoihdHxiQArp0Cl5Yx+Gip/V46YCkIqEGO/Qxkylk1a
	E4OlmDbVdKkmUaI+ubnuAJCqVCDhSGA=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-271d1305ad7so108259755ad.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552078; x=1761156878; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PmCtoITTqmZehva0tB3sITF3D/xHoyXvDzDor4cab88=;
        b=HoIPGY9WN2G8kMfLLE5EBMAbSEez66wr96GccSqsi2qbymS+btI7LD52G5ScpDVsii
         ikWeoI6Lu913esgTyzCypCT83Nyh4D0vspIb5Ie4o1j7Snz3kWhN35GE6wXLYHr9TqwH
         75H0Hq64Li/G66xnqC7qkxxsYxt5TocYZU73P5pX39xoTKG+fftAHWZwpz8sSFB6jtq1
         oZUn9Yd5a2LISB1YdavMTZOjYUsy7+Kb+bZ8+3KdDO4oN2Ix41sor+SI8z0Ob0/Sgafh
         IkQpy/gUllI2iKHV+zZF+N1mVtgVk6BhVO0S3mp+F1/CIRwU4onBfriR88PoyV2K/0O9
         7kGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552078; x=1761156878;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PmCtoITTqmZehva0tB3sITF3D/xHoyXvDzDor4cab88=;
        b=m1q4afwEqXwqaHQDjH+4Y3Q3WX4W4UhJwnr5jwuZvfl35gcSQ9u+/FcjYA4heJtrKu
         q45P02JHpp/GVwU/s0xqWTiHMsYqtkMKw7zo+y6C0LVCwkVCOFv/64P1eakjQKitwHmW
         U2N+IFC98F8BBXYHHww2+qDhcuKdnhi50HCP3iI4V1ucCI/1xiM4imS+SXq1UJ85lV2h
         HSSugDNjid/u0vl2Vz3DaZP5RwOFSddM1LhemICmjPKSJodGuosGht9MHEwY9WW02pv+
         9FJhvEIOd+w+EH9dBTMy7+WkrV9oRwmbTEc8f3cT3opT57e3u6Nh+8+ErWlmQBRhtPzL
         YY1A==
X-Forwarded-Encrypted: i=1; AJvYcCVtgaKoO7tQkBsrTP0eI3uE0vZTW7npakoxPjfXX85BZLgkKovYVCUrigW9IAmFI/JogXzxYygU4A==@kvack.org
X-Gm-Message-State: AOJu0YxnRE/8WQCzByq4h3KLii4sxMvtxdei0uF/L/re0dwb5klAkv0J
	a68Zm+vnRfj77UZ422M9JQ6u1oU1//jcfnoOb5XtQQ2ELbsLweOuuBFk9D+nvht4brNpWcvLt72
	n5f6m
X-Gm-Gg: ASbGncvH24YDPaJ2qzos3R4sIAGIk5fADjUqqVtz0j0h6rlrfxM/9IhZgTyIrBVll8a
	IAL7dWOGmqAj3dBytoFJEBwMOh2lBbyF1f5Wy8J3Z5bOTLY80i0qrIERYRYTIPvwk7MKGkVo18a
	RgvpMNMXx79C8FhKIffK78W0JyvNusXyQ+Z+PF5SGsfsNivwzMbdlpadrv5fdTuRuzBsdzQyb0n
	RysRxX1TiiVGXAdyBm/LD3tfKN1u10pa7I8zKFOPu9qfVFnheXZb7yK4MonfXLLxpuijl474DH6
	BjR6iKF4FunSwS6bbI7h7gGszbZ8M0nQYeZoyZTN2x5TWVD7WmOiA3xUH1yB9d91l+YkdH1hOH2
	2LpBd2xHjg3U41XFfcKE8fDWRpVaqeddjVfGNX/7zSznE2WejZvwvtODu82pnNQ==
X-Google-Smtp-Source: AGHT+IE+JdCeZGv7FSdthWVtz0gtJyMGWPAO1FpDwwqSqMwXXyh6LvI98IT5a3IjOySd8DLk8aNzsg==
X-Received: by 2002:a17:903:3c4d:b0:267:44e6:11d3 with SMTP id d9443c01a7336-29027379986mr377861065ad.21.1760552078134;
        Wed, 15 Oct 2025 11:14:38 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:37 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:56 -0700
Subject: [PATCH v21 24/28] arch/riscv: dual vdso creation logic and select
 vdso based on hw
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-24-6a07856e90e7@rivosinc.com>
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
X-Stat-Signature: bzxedfcjcr3ugijrgbww81aii4t9fixo
X-Rspamd-Queue-Id: B2C38180008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760552079-380620
X-HE-Meta: U2FsdGVkX1+hrmmPjHTlrjxlEV5LUkPAIXNrJnhkSl4KZrLYgoN6DzuGtmI5vAI/d0F09Bvg6hosTtS7B1cp8DU7pQbJkHHgiXJK1k6Ga9NwkriONWax+wf/jjBC0X9klvBSnRs+q6nuJCMICGK5tlofoIFEcU+XUznlzn/e3UWhvteoPt3nXPUoLm2l+I/Yxe4j1Z/s0JglNvV7uCdTLpx6tfDBH+wLCLe+Wos6zIZjwDhhbd0JDUfuHkNbldSN0LV1fJsH0Zzz9qGlSTyduqrv9bXLFmQiWitteqCg8Di5uPrG+uf2MTfDQvaDzNEpB2FCSEyXGXfdeJiMa98l4fIp+TjP7vOp5AkUo0gj+sODp3sRlXiiE4Zm1zX+ohayl0rzyG2jf/6B6wUqZchibNnVPI8Gcf9IGSJ+lSQOB1L0EvBvY00Id3M2X+MX84aVGqsbT+R4sojN+okZ25bS1du+Es7PLPtMcJjXhrNocRUM1aL5stp83ZVwp6lcjx7k2swxMLK29CyrYV8uKRgFKiNgp3Min+rHXQzzbXTQQ0dGp5FJlaItq8jLU8q6uM6KYecd+mFT+Iu7wD6JQDiSSHrZ/tO5Mo44grk7geq1iYVwDFlv6Ilx9z8vpF/hcJLAnHUailJn2r6KcdlOKKM6F5Ag08VZKVZ2CBPjW4Ksv93q/N8rR35dZ9dlqNqm187zkNf8QOwUpARqq6NcneSvnzSLbN7fU7BALdNILoiBiHL9ahpSRAfw3yKBgb/PbPayZbsiKw0WUroscLNEOheJhbTn+x8/UTQcAuMANavV1SFk7W4awRGGR+F51W5Lf2sXyYFthWM9LyD4F0eVmJ70o0X1dsTuAkazTUiwc2rHhiGECVZeI+UGVm7EepMkYfobx8ndblCef1qGK5QSlqWI9dqbsENX4Nto444zuzLtgZxzo02hL1X3c7xChez7ZJWzLCiwXAS6kK4cjUZjUWU
 wB5U/GLU
 S/JvQVEuuvQqCADqGSO2rYZi/+OqtBJCBT8COz6QmV+9SzD1EeVyS81KWYVfhFY/ey7zAEMQm92VptkdLwMyFqLZioLA7PzSAgPoFQZtp3PeDbpe/HcghF2jrzgvmiZ94tFsvR65s1tkJ9lmIwFOweYQSvCaE8o4xyhrppT9SWsw1v3/kGNo0P2/MvLcO4LuLyia4jZklC40JTIzch0CKINLKMbwvfOk6mEZW7j0Dvpu4OrI0qmDfZkRJ5lOd3cIKoCGgvhT9E9fL+CDWnvM5rAHeOG6cWV+cEAxBjGBDR2G63it+aAuKlWkj1FutPVFG6X4eRDwvi2lPQiEW/PCnhFf+NYh1321d9bNm1AI/7MazUTnwzSZz/KnBgfj642efZnqtCQamlxa+AypOdJj13hD/u02bbFjBTqTxwZMyuJ2BvPM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shadow stack instructions are taken from zimop (mandated on RVA23).
Any hardware prior to RVA23 profile will fault on shado stack instruction.
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
index 3a8e038b10a2..bf080e519101 100644
--- a/arch/riscv/kernel/vdso.c
+++ b/arch/riscv/kernel/vdso.c
@@ -98,6 +98,13 @@ static struct __vdso_info compat_vdso_info __ro_after_init = {
 
 static int __init vdso_init(void)
 {
+	/* Hart implements zimop, expose cfi compiled vdso */
+	if (IS_ENABLED(CONFIG_RISCV_USER_CFI) &&
+		riscv_has_extension_unlikely(RISCV_ISA_EXT_ZIMOP)) {
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
2.43.0


