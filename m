Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8116ACCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 23:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375268E0013; Wed, 22 Oct 2025 19:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326158E000D; Wed, 22 Oct 2025 19:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151538E0013; Wed, 22 Oct 2025 19:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF59F8E000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:30:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC86148DD1
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:30:09 +0000 (UTC)
X-FDA: 84027345738.01.50532E5
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id C506D80008
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:30:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=AXQhfC67;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761175807; a=rsa-sha256;
	cv=none;
	b=YcwmLB/9GLDFvQp9dXDF73dxoE3pwejSa3RCDIoy1i9ZNOssKtO916ty0spLiB+glyYCVv
	oGW8ZUhYjrjKAUryXkhiWkjOz8/ECy+6EFIdS5Wrgy9wGyvBPPEHSjbzmuDNyUtyHnklb4
	UhDWTnO5juQMdR3R0VmbRGJ1uBt3xyY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=AXQhfC67;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761175807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujHqL1CkFocnxfBg/TilHgsDv7qqfxACnquN+j6SpiE=;
	b=mATCTBQMrlBpptqSstPfpa0dqrE3G80MZCHvKcoSs8DcBMUpPp7yX/10Q4z75709QkhM6t
	K6tuWg5/uG/nTpW9pwfB+Apofu+A0dSRlS2WjeFAwYGVetfb9r/7d8hhmMYvad6490Wnsl
	n+UdXYxrfclPmJ2l+/RA6e06TpcUrPM=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-77f5d497692so246091b3a.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761175807; x=1761780607; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ujHqL1CkFocnxfBg/TilHgsDv7qqfxACnquN+j6SpiE=;
        b=AXQhfC67LFIsrSZG6YCYUOl6JeLN/vKJfLjYrt9gEFrSzzGHKTBsu2469CPdveUDBo
         r5OxBEBZ5Sk+Gh56NzXkMuRT8yzT3AX0F6oNOqZFrJ03aKnQeBYh0lSG6mt/kNltfMVa
         Jfsh55WBu9f1UgDSu1guC0ezEkv6Jjf6BBaKA/95QjR+ckzsEKuz2ysG5m8u58vXY7yY
         VgrpIRkD/HTpkb6OQJKRO4k0z5bDJ437PyR7bFYAQAKLRQDHt2WJhdbFkri1dfcyQhz8
         nemXUKbQrjNK9+Hnxm9A56Tr/eowzujFnitYsHRmUeePRXt8XkZ3CpxwO2cu15QIXaky
         RqRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761175807; x=1761780607;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ujHqL1CkFocnxfBg/TilHgsDv7qqfxACnquN+j6SpiE=;
        b=PeYIxgsWsC78wrnUFNXcZuCqHfdgSWFW1AD5kvy/uNxD0HvsJEquhFxoQkXgeaUhh7
         0cHt224Gagq7To7Waj2ytcCJZsp7YfMIV0iCSz9pEEl/zfLmQwzh1so1Y/x0IX8sYmps
         3H6Fnrm4eeeOlgun+I32GwhnV7fnfRE/yRfWs0hgrUEO1BI4KF/8wAMnKNvQId2EhZIG
         D0kT0ZWB4Aqzr0p3VbFmu3fhnKB4r/wsZInp0bvHnoNxihJrWwU3SxHZBiLYwWBirYLp
         vJy9H3MWiVzsAtW6ufM8Dn/FEcCDn97d1hzAJIA1Qe/xtZ7tn9ElQcgilxAPrKgliHGC
         nH7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXRhyBUolrt1ZjBoQfYmCIJgN+ANdSXCGMvluiyMB6lv/YKYbJguM+RrZ8QTo792Ztk4vwwujJs1Q==@kvack.org
X-Gm-Message-State: AOJu0YwQawtZxQK0dreAoJcIiZJ+NfrE2dl0cIXd0V6g6pQPIBU76ja6
	rpJ8Yv3hoW86PRVUOc8fnqIKT64DOKUnOWQRuK2gNrawNeGrnV1XWe11u3GzjM9Uk9c=
X-Gm-Gg: ASbGncsUq+4Uu7ony3rtEa7hKhUln7rTT8MBemrIrSkYH8RWAeXEkFIVa9kqml4RhEN
	cZS+Q4sHnZ6Zh610k1AAC49HETSGsFaL1bA/h6KsodQxUZvhQKqDElZmmuwwp2OpcV6XweqeyOk
	Eh7uee5fPe20IFHT0RFE/B+PpPGMVcjZbaBFVvNV11WdVuFHzGCEmp65+wO8vVqpp3LKy9tIQtw
	A3VRK8gSuS59Q+JfEuvBOALlApC66BzAmS8IY3iZ5TlWVj9qcp8ztMvGQvYAvOnlWitYQhmaLwF
	Hc7QczeLAkAApujTQS8Vna7R/NqKxFTDXz9dYPR7Zj/ffxnRK8g7gsGgmRA29aO+MpJEMOzWK1Q
	RCZ3ncqTMFrj7FlmrXJYrGpUGqpbVKWtek9hZ0h0nTEpgxv/0vC0HIazU35aw3ytvMBX/IOcT8Z
	65g+9V5kPsEJL7OofTt//a
X-Google-Smtp-Source: AGHT+IF6gkZs32tv0Sc+yHY/6hVbkvNJoMtqK+eojdM3VMRuuvu79OFo4jjiqTiRVOGksRWCeTn0Nw==
X-Received: by 2002:a05:6a00:2e03:b0:7a2:6b48:535f with SMTP id d2e1a72fcca58-7a26b487089mr3870490b3a.12.1761175806653;
        Wed, 22 Oct 2025 16:30:06 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274dc12b2sm392646b3a.67.2025.10.22.16.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 16:30:06 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 22 Oct 2025 16:29:39 -0700
Subject: [PATCH v22 13/28] prctl: arch-agnostic prctl for indirect branch
 tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-v5_user_cfi_series-v22-13-fdaa7e4022aa@rivosinc.com>
References: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
In-Reply-To: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
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
X-Rspam-User: 
X-Stat-Signature: i4fbgckff745u9snordsru6g4ew8zayc
X-Rspamd-Queue-Id: C506D80008
X-Rspamd-Server: rspam09
X-HE-Tag: 1761175807-922668
X-HE-Meta: U2FsdGVkX18bT+cdSDZ2UlWhDfBrJcqDF9Edbz6xV8ZSkh0p3nv1CwNYOprRkYW8Kml2c6zWk9zVcKwAm1a42re6KYzyKVGv4cBb5mPU1iGsbFoRNGh17ZYFF0DhLBsFaoN2Rvit0bs3r2SwHPdmGwq7oehphySX93MMS2KzUOiAxcd9AeIvLxtvpps/Nm9h5h5hltY3nCoB48onC9PaJvdwE2GJeo78Y5q80Q/t4XzDtRHR2O0Z/IjKx8pPrEZCn645LNdHAvrXi+arXboGEPdKGfzgiIvCDx/om5ckw+skCYc+RXzf/QsKOvnEs21Re9Di9pzqHDwxhWZ9SJwXkaNKicKIFvmmN0D2rjBBlSsTjE3HZu+9IU9O8zOlC0afIBy7CRL1/EtxF2kmZZ2pacos8Bozzj/Vwm8YsV2LHn9ol7FjDi+mgSGOjBpLGWnSQFZ3tOMm0m1oU+8+gEy7Wztr+Bga6vp9thUXRuJtf4JyOTOTIm9jfLPFWVOtIQ9IL5jykP/dp8BJ7e04RimDJ5LjTh52DJzkVge0nKG61HcDyXfuf4RNve8UGj1fSle3gMR2wlK06ggbybHjong1b/VH5Oib3kbmMHlPNcYoh8QumVI6lxce5DQfWxe8yEQpd/5GHlxnIMCGIeakMRS9d2U/1DLsIU2M1RNgO//6lo5qmUKnXLdgpDOZxUFyCJMWbsgs7RJhG8LH7JFnmeqhsuygXwVfXOmKGaKJopTuxeM0uDow6Gzmnp797jTWzZqshPOlLAhHY8wB//vRslouUn3bM81aeDfRpmRaMmFeOBRdbK38HcENacHTB8FYiWcm9uSRgPRady4ypKy3LXRFroVFPglx7mVQS/D5+qNwrCbmzqtRLrmcb8YhAbFzN1dDC+osFJqbVhaev79RBWxpA4GTsT/WgkjasiPQERgsdP0UZlHpjr7CTceUmc8l3uLSr2vC+ph2A6o+OHGki/g
 OEyoxjIQ
 IQ1THCj49YaUeo7Dcq/GOWfOtYz4sOc4NPkjj9ceU7yH5qlBlu8aGbJcYaQn1AvY/xfeKchwYXKQKHYz0B7R4gAVGvnwfC7DIJ4sEh3+cAenc64af/JB4A59OtpyEGB1vABdY/PGlMUvWxh80f70LjfYvc3bOaMj71rQE5MTcONpoAYWDd5G2a0/1NEFGCqiRja3tFtehdLJwMcZPVcbNOb1Eb0LA4AtW8UlsvY7JKFn6BMujVQR6P+M5mYvP+gKVDR7LnoLMNxk5Zqo/lMzX9MrBPZdcxfMG6Fdkd2OuL01INLDT3wJ9c5HqP5nJmkKijPgVJxA0fUS6OtmsoM1ueJV/F34u/5oDSPCokaHWFq6oGNfRHvgkW7czO8/jSQJ98OZErIn6d/ARbQaYgFzi+LYq3B+8YVM0+URChWfToImLso07H/JtkS/AEBgy248oqloAmPhft8z/K6dbGKY68qyJmqb+wYen0U6SH81e8kuWAeK65Y3byFur6g==
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


