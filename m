Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A0C3CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817168E009D; Mon, 13 Oct 2025 17:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C2AD8E0031; Mon, 13 Oct 2025 17:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57DD88E009D; Mon, 13 Oct 2025 17:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6B78E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BF82BA661
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:31 +0000 (UTC)
X-FDA: 83994450582.24.CB59333
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 13B09C0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=K7ScHxcZ;
	spf=pass (imf22.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujHqL1CkFocnxfBg/TilHgsDv7qqfxACnquN+j6SpiE=;
	b=i/9WgaXe/r1va5od5zyziqNkSrGRDw3zTTZ6RxCZdpz010nqQ42ZxK2daLsGg7RGmsmwr8
	TLVKjG1NBjWxpAHH4ZqR0yV032W3aDoCUL0/G4sBZNfG61J4cqdwabV29BL3nC/0ic5xJd
	h6WHfhIE2kccGTKXg2vkz89VFioLKtw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=K7ScHxcZ;
	spf=pass (imf22.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392589; a=rsa-sha256;
	cv=none;
	b=zrAuXd4mmRN0c5gD2Ff9yZSO4z4JtmMUrnJLAhiru5XxBKW+d6Uv7iXKxbesY3CI8kCCG5
	uRsDAk5cDJtV+huA+WqpEOwSADDNKmClIPBquVz+9TorrFYKiLuNQ1uSpGVnDT5Qla4FHS
	KD07PrEyCdZ1Mps+OSOW/AAv7fiLWeY=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-32ee4817c43so3732950a91.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392588; x=1760997388; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ujHqL1CkFocnxfBg/TilHgsDv7qqfxACnquN+j6SpiE=;
        b=K7ScHxcZ+LHcM8fYy2OyTzK2qm0zLMXgWFTdU/Hufm0ccvVQbUWG+g0QLpNdgZXMbg
         ptW8u/NcHx7Vj99dPy1SRAmkAWwq91XDZ/TukmopXIv7hsy1DwLf22UDLApaAhWQPkAB
         10Ln9sQAv5Ky2tN+x4HDoQ5lUMrTXmuX1dMRC98g251iWIwkgZ5d7P0g9TuMd6nGKQyx
         DyeR0lZEqcc2W5WqY05nbDjRQL/K7ECS0czGOxzA/pWaPw/suW1B8rlUVEv1qlrs0nR6
         lMj8cd0qjYoyrgd34C7GhPRpuG3ZbSOEC23nkR5vYwCKY7i+omGBgCpmB3MIYAJgHLGJ
         pd0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392588; x=1760997388;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ujHqL1CkFocnxfBg/TilHgsDv7qqfxACnquN+j6SpiE=;
        b=hUFhwzE7KM7VZDQANHuaYFENUJAWio7p8LXBQv/A6NJH3ycJxkHMd0EtEJAaF8Uuah
         XSHeHpqHiNmlM1bs86a/fD3GsIXSp0Yb4dOAFE9RMomG4OuHhWJ8uPiBqgasaliYjBUL
         qptfTnphbWkoZPJH6380VCzYRU6udsHctx6hqhy6U0VEBMLgAbq+3hiumgjiTRN+joOs
         PtaLIDVDHOrtoL8M7ni9WGxcf0TSuE3AwUQq9gaPtp2pN5412FjOA9DAdhUmZJS9pJkI
         Jyb28OSIS2K9+tbh2AW5z66oNf+0drnqZviKmrvJaDDzARuiZ0AqZnLzgipET8dJYWYr
         p27Q==
X-Forwarded-Encrypted: i=1; AJvYcCWECCeqFoXALt+/ckKJ0r0FWY9f6YTeVsiqfdXcY/TyTIhdPu8IzfFPSdHlGiHvt/vnT/l3uuZtaQ==@kvack.org
X-Gm-Message-State: AOJu0Yye92vlhawGYEl5BHyg6htpiFnAY/bSBXdw0VRx1q/5cpoeCMuh
	FdUftUDhS0eM8Wh4Wq2sO3d1YdzWaxUHsBAQyL1pafmqUqFo+PuSxaBKgwGf/PZWtmA=
X-Gm-Gg: ASbGnctDadFCGAk2mwt4GUndJ8CSIUfjrc/XdS1MndiH9Hkd8/RoUzEfXsKFJEh8a4G
	ycGWHVUzpbkMmOt25X+6ACDYygXzLRkIhW+ALoSDNj55PRoUyTWbVcOlDliGBZla/kn1MYt1p4+
	GGGzbcZTBYXM8O5AjQxyMnBD2qJZXa/ZN4s2k4/nUMGwW/BeQ/jzbPvZMgz+yVUXtac8AjCYoUq
	tUXrFtpgoiVPE1vRhDp15iOPTmFW1gGdknshMSjde12IwzNg2UCAYBrUo2mwKC8J1+s5WKXViVN
	bbp6LqVs75v7V81EiW9Y50Dz3HoHmdExMmh78OQY2AjOV/8VurS60qC0z/f/J9+yHvCsgZMKNv8
	o7eYkIM1gjo5V0u/urFBBcLl7Ykf60eCuScbskIpnIkf3DE8Hye8=
X-Google-Smtp-Source: AGHT+IHzrnjGtxJjRjy9iDbKJuxIo/nGd1V7rPMVlGrq9rf5a1cggdhBtK3oXV3eARlMl/WPRj8kzQ==
X-Received: by 2002:a17:90b:37cf:b0:335:2d25:7a7a with SMTP id 98e67ed59e1d1-339edaadd9bmr34454171a91.10.1760392587917;
        Mon, 13 Oct 2025 14:56:27 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:27 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:05 -0700
Subject: [PATCH v20 13/28] prctl: arch-agnostic prctl for indirect branch
 tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-13-b9de4be9912e@rivosinc.com>
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
X-Rspamd-Queue-Id: 13B09C0007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hkyhgkg3pg5dgg4a9i8bn5p5ixk6qrc7
X-HE-Tag: 1760392588-402465
X-HE-Meta: U2FsdGVkX19FCsFb2cLPvMar2fIAqR7+f1EGBlMMt7ki5LYbEYCgVAF/W1YJLpngw0O6EpJGmnarXX6wmJO5GBAW5g8DSvH9R0BdGdSnfQ3LgWoUS43PO2+01mIInkL+mcCVUid0gN3Ic9r7PT4ACMfc7KGDgyPaf16e5qEtoEj3YvksrUQddXH0w861wq7/LNOxKnm4g99nhkOkzTWRrrDhjb9iNgjiG+RZ8kDVLG24/0Si/pszvhnYAx4R07W/smalO/4Kh9doSNSkLF74q13wU9nwa3LT0xu0l1nWb6uI7VRzO4Cb1gr6Stzi4qADq7iMAmHflX0Pe22i93KaOfsTfunCecv+BI8mUa23Rr+3wifvjWju8gByNLEm1OX/QXAV+aYTYWhl8YQlnQ7TmZfebFjmLAXVNfZZWVW1bc+jPbTyIldthZmXoKHaFNTVNmEfTeLeF356urNQKioNYxomWduUyfsXiP1f3MCz90pq9h4+Hhwq+tRGS9Ixh6rrlhql0LSJZA3dZuc/fI1XyyHpq9uzihrqHYN6cqoMvKR4rq8HU/WFQWdI7czbhuKYuH8OanNMahGgr780rYS4Bvtbc4WeloEJgpvKCkW0ttOubjUSJRpH+PUCw1fyBOHu6DgXgWUv3RZ5AlAPRH/ZvFKQPRRZbPEeegX3Pt1WByqBnYwqJrdfkF0UHlmxwT/5H66IgssrmiIQHaqdFSxPKu+va1TIA0jzSiWzQnD9WPMs7AqBvpqksJwHzP3pu0C2sbZMS9ys9hVdruJS4PcqEKh7M1I1b7k7R9hmlf+uCBAIKYqniRoOsUq3qxpocbTT1tb3lyl5iYX47qaAIieoYIC9NbZOFhQIam2Y07pDOT13o7O+bup9LXC8Qa61/0H0vHQ9k3aOwPgt+h9wK7MUmk42FimQt5Osj2bnBzKIAoxJ9oF9F8lpIrzlTgFT052Fbc3MtZdcajvDHpOKLz8
 a6NbrIsO
 szB/5uOnj2Fgdfx+Rr1nQ6HcLhXhDK7AUir9OU+Wxc8XiS1K3IrjBxvsx47JuzS4u5GYR7pQ2miZUtY3lPugCbgwqnPlxjIOjSkjJ0FL0M07CeVq6nSBcfT/YUDXKYjLg4QV0fXzSjuAfca68+NIjeZP7pzb4Cn8vryt6OanafLgsTKrCKl/jwfmiuKXc9BTWCBsht3ptjaOsH2T3m9F+bMuULVPK8L3yOIsS9mbgkGVNZpUJfrCw3sTbA4T4aFw039BD/E1kW+08AIsGGZJdVduwRznWuza7BKl9bMTaaxH5/g7DWCbZReDcErde4Bri4JOXJ2MhT50JCzlBIUAQgx8qm4Fg+er3lSlgQf39rrRm7Vvt0BxrbNxIOFvLKY1WizZ2DUQX6u+RHYBAGUNm+lakQMVLooniEQq3oekFtn/4Wl9dEhuwXTGvd1bUPDxC+hmT+YIFdvEsFfdo6mCoZAn5Wm4ICIr9pFZwE4M1/o0LnPiR25nL373E7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Three architectures (x86, aarch64, riscv) have support for indirect branch
tracking feature in a very similar fashion. On a very high level, indirect
branch tracking is a CPU feature where CPU tracks branches which uses
memory operand to perform control transfer in program. As part of this
tracking on indirect branches, CPU goes in a state where it expects a
landing pad instr on target and if not found then CPU raises some fault
(architecture dependent)

x86 landing pad instr - `ENDBRANCH`
arch64 landing pad instr - `BTI`
riscv landing instr - `lpad`

Given that three major arches have support for indirect branch tracking,
This patch makes `prctl` for indirect branch tracking arch agnostic.

To allow userspace to enable this feature for itself, following prtcls are
defined:
 - PR_GET_INDIR_BR_LP_STATUS: Gets current configured status for indirect
   branch tracking.
 - PR_SET_INDIR_BR_LP_STATUS: Sets a configuration for indirect branch
   tracking.
   Following status options are allowed
       - PR_INDIR_BR_LP_ENABLE: Enables indirect branch tracking on user
         thread.
       - PR_INDIR_BR_LP_DISABLE; Disables indirect branch tracking on user
         thread.
 - PR_LOCK_INDIR_BR_LP_STATUS: Locks configured status for indirect branch
   tracking for user thread.

Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 include/linux/cpu.h        |  4 ++++
 include/uapi/linux/prctl.h | 27 +++++++++++++++++++++++++++
 kernel/sys.c               | 30 ++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 487b3bf2e1ea..8239cd95a005 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -229,4 +229,8 @@ static inline bool cpu_attack_vector_mitigated(enum cpu_attack_vectors v)
 #define smt_mitigations SMT_MITIGATIONS_OFF
 #endif
 
+int arch_get_indir_br_lp_status(struct task_struct *t, unsigned long __user *status);
+int arch_set_indir_br_lp_status(struct task_struct *t, unsigned long status);
+int arch_lock_indir_br_lp_status(struct task_struct *t, unsigned long status);
+
 #endif /* _LINUX_CPU_H_ */
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 51c4e8c82b1e..9b4afdc85099 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -386,4 +386,31 @@ struct prctl_mm_map {
 # define PR_FUTEX_HASH_SET_SLOTS	1
 # define PR_FUTEX_HASH_GET_SLOTS	2
 
+/*
+ * Get the current indirect branch tracking configuration for the current
+ * thread, this will be the value configured via PR_SET_INDIR_BR_LP_STATUS.
+ */
+#define PR_GET_INDIR_BR_LP_STATUS      79
+
+/*
+ * Set the indirect branch tracking configuration. PR_INDIR_BR_LP_ENABLE will
+ * enable cpu feature for user thread, to track all indirect branches and ensure
+ * they land on arch defined landing pad instruction.
+ * x86 - If enabled, an indirect branch must land on `ENDBRANCH` instruction.
+ * arch64 - If enabled, an indirect branch must land on `BTI` instruction.
+ * riscv - If enabled, an indirect branch must land on `lpad` instruction.
+ * PR_INDIR_BR_LP_DISABLE will disable feature for user thread and indirect
+ * branches will no more be tracked by cpu to land on arch defined landing pad
+ * instruction.
+ */
+#define PR_SET_INDIR_BR_LP_STATUS      80
+# define PR_INDIR_BR_LP_ENABLE		   (1UL << 0)
+
+/*
+ * Prevent further changes to the specified indirect branch tracking
+ * configuration.  All bits may be locked via this call, including
+ * undefined bits.
+ */
+#define PR_LOCK_INDIR_BR_LP_STATUS      81
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 8b58eece4e58..9071422c1609 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2388,6 +2388,21 @@ int __weak arch_lock_shadow_stack_status(struct task_struct *t, unsigned long st
 	return -EINVAL;
 }
 
+int __weak arch_get_indir_br_lp_status(struct task_struct *t, unsigned long __user *status)
+{
+	return -EINVAL;
+}
+
+int __weak arch_set_indir_br_lp_status(struct task_struct *t, unsigned long status)
+{
+	return -EINVAL;
+}
+
+int __weak arch_lock_indir_br_lp_status(struct task_struct *t, unsigned long status)
+{
+	return -EINVAL;
+}
+
 #define PR_IO_FLUSHER (PF_MEMALLOC_NOIO | PF_LOCAL_THROTTLE)
 
 static int prctl_set_vma(unsigned long opt, unsigned long addr,
@@ -2868,6 +2883,21 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_FUTEX_HASH:
 		error = futex_hash_prctl(arg2, arg3, arg4);
 		break;
+	case PR_GET_INDIR_BR_LP_STATUS:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = arch_get_indir_br_lp_status(me, (unsigned long __user *)arg2);
+		break;
+	case PR_SET_INDIR_BR_LP_STATUS:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = arch_set_indir_br_lp_status(me, arg2);
+		break;
+	case PR_LOCK_INDIR_BR_LP_STATUS:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = arch_lock_indir_br_lp_status(me, arg2);
+		break;
 	default:
 		trace_task_prctl_unknown(option, arg2, arg3, arg4, arg5);
 		error = -EINVAL;

-- 
2.43.0


