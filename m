Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8F5CCCF9E7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2158E001B; Thu, 23 Oct 2025 12:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D1E8E0019; Thu, 23 Oct 2025 12:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4218E001B; Thu, 23 Oct 2025 12:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA88B8E0019
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C2B1129D46
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:20 +0000 (UTC)
X-FDA: 84029969520.16.482879B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5EB85180020
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ozu6c6zW;
	spf=pass (imf24.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238278;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UupePdgYh7jBN7QzBPs45mdHzf8g/GuQ731Ho0zix4w=;
	b=0D/jRHl/AXqkdmtoyOXscDLZr+t68MFwx5PYYnISWEy8Ncqut8JBPK0fFqBzMJxm7jh46V
	O3h8cKejXc/6JT6wlljXvWk8nt13/B/OTIuzsRZ2h1aalONqU236923JOSR4EbWtFHPnw/
	2lrO6lzZqD0oryg8KwDlYb9yZSfUB10=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ozu6c6zW;
	spf=pass (imf24.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238278; a=rsa-sha256;
	cv=none;
	b=NDkrelKSJr/q/4By5rkQJWvDqY8jHZDUV1KujY5wUzQ29kun/gpWyY8UOmYR9LjO32219T
	Y9OFKEGmZ0vfvdyXnuiqXXdIOA6YGGz7TzTG3tLY7psBwwatwUerT8Zi5jyLqdUnZZX4Gy
	iSCT5yo6NeBzl/NQnDtOchvv8wqlSSk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 60B4E4B09B;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17E94C4CEFF;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238271;
	bh=JxdFhs6m+jpZSuVM0h6LrugZL2h/LmWZ4qPYhd8l21c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ozu6c6zW5YuVEEMMTwPJrPeXOq5xt/FTeOhMt9FoDm4P1PkMwgZnSOAVN24KjtPkf
	 cqlugsUx+DmVDQIeKPK84BpHnttwlb8jITSDekMPPLUFC9QUogaBkRRQo6wVqfVmNS
	 MGAR/gv4Se5OU9xuceN0xbh97rarWS6XiZSBl0o3Pg3CmgEqkMg1lFUIeJn6omhBmF
	 qm4FPdcIFTmGvLJT/Le77VAef6Fdt0kh2i7Bf+5pWkxsPOMBqD9bv6lbtODajpbqwS
	 PDe4puUKP7wY1WfvUc1buxa4wqYXIsAKbZ8hYO7WxknDuLlxwKqYp5IejneyW/1qB2
	 U/nqNjbGSInVQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A83CCF9E3;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:18 -0700
Subject: [PATCH v22 13/28] prctl: arch-agnostic prctl for indirect branch
 tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-13-1935270f7636@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=5257;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=//BKFL/B5DGzgzNcxCALX3+BH8HxJjmHBkOpM1C2zRA=;
 b=8w38XN3fpWvxghP9so4m8W6hU0s3vWBmymgOTEGZoG1n837CzqTylYWDsbYuATki/OCII29Ee
 XGgTEL7dJ12BlBrq02CpzZ+QSQZhZRR63qh9X7D6rE1glFh2AYf2bH9
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5EB85180020
X-Stat-Signature: qyi86jf4fp8pgd9ayjz7ofr7ggr7in9y
X-Rspam-User: 
X-HE-Tag: 1761238278-468057
X-HE-Meta: U2FsdGVkX18tUC6aoe7yxZr/oGMbheJTD5iDLRHKaq7NG+II0rzKE3ibxpDsMdv1DHc/eK6+wCGykkJ2R6ovL7Z2sd16If6wx7QNWAFBWwHBu7m8LKnvJ8JZ0Af8HVKsqLhsb5SLKXVz4AMUO/U/H43WcayRHNNFyAc4j6A/xXSbfY6bsAJValw1+i5wc+zJZPhIdoUDAuN7AMVdtTBWsslKl9TmQoJTMoFIOSeZzNIzFnzvz8/IYVVucyxKFy5nHCpyQMdFGj1zxtB7AXF/9jHT9UxBnlWcUGg04MB7tKYhthsfUyOpO46ghRFQD9awWxIeMvXX5nLmFLXE/ZLFxi8H+W4oQFYVXm4unXwnfbIOKnqSrvEgnpWRen/lwvdkKAazF4vNiHnpJ6VLaoB9HdnuyN66dFschA2x9T8PY2uWV1W2B71iTaeKZxk+aMDSy3MvsF8YUSkOVuEXwwom4KjGJnyhtVhqPP8CxGE4oMi6ypGNRVHn2HgWUDfq1xV5fOLFkTGgd1bJS259cfFaiVjq4Oi6RUcsyeoVCCvx8hmtPT6Qj20K+baHDaYD80pWq3Elw0uFwRbZezfqbqSEYuiNypLhZ0uRrzMIMT9tq4kGi3xLaWw+DV4PpMSJbGyVlPG1lSLE4TxCY2LgJqcaQ6Qns1bxHddXgG/9bfMxHtPPpbnB67NBo5EXVbTP3dj14/h/mnOiq3rE9cQF3DDqxhe3b389QjAu02/t+LpWGyzjdx1+OrgTfGnkHwjo8LbcLpud9dJWsxhbHUzdahf56JkUNrwy9Ui1ew3U66EFjur24paZvuLxoCKg+fN76TrccwbAzAL0z1/BM+S4sGE6dNFBeAsS8b2n0EwvSG04UQpo3pE2uRrvAeoC9vEp9bQ3lM8xUW6TDADn10dWjBINocrPIYfXwBeC/hU3gqsJ9EWBtZDBNL8TkrQ6EJsEyBjxJu1bqMIf4PhHKuUgrus
 CPfQVUZ+
 VKHjgNXOy0/CtRm1UkQnFKLZV6tBad3L6EHcbrnJwr1xd8yharl4to/BhPdO1w1bT9SCNNcBSaChx1Su5uRVI4X+uoD6r8P16sggBprqrZP6jxZmhmsnZeZGqYjyiwUvh79t+Bc5z9Xq5y9jPMFGocydbduLdD4Fh+MXCEgeHEx874hjhzwBZTIHE4ry12YB7Vbc+FczeCcNOYIqIyua+1Vn3HqFip9Ryf3pVya8ZoeH/Ro6zF9W6EfUyoz7cYpm62GJsdMVdg9ychYTkQHNHlmHxy9cK7J9HPljEgSj0MLLY7JDh1/w3j0MoYbN+G1lKpzgRQDpDPz747Xe8pl2m1crOEkqPcOph+T5hrfvD91edxCdRILRbiAsIGztoacA4zbN14V4tvK1/DF8jDsC2HEbbqwPd1kxESXD6II5iS5q7xQfsQmAz18tTGBE+oWU9S+xHF+cYE+4GHAztnbsr+t6hRC4LyfTVUiWvn6A6ev3OK+veiwb+YqAtHsX5BrN9d14NBapSh3u1bU+cFvRURrikd2IKoHg9iedtSL8/G489pjhCiBmVj+iqUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

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



