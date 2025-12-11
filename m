Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B43D8D41D7E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D9BC6B0011; Thu, 11 Dec 2025 12:21:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78EBE6B0010; Thu, 11 Dec 2025 12:21:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591E36B0022; Thu, 11 Dec 2025 12:21:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30F876B0011
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE56CC027F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:11 +0000 (UTC)
X-FDA: 84207855942.16.F6099C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E3BD120010
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m5gNFq9t;
	spf=pass (imf13.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473670;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SzF2fVt06sO3RiDJ68n5VSfIXPMuwHIlX7ypxE/MZQE=;
	b=jfdZrpciPkssDl62rmEKWBPIIKn72DeY5DzO/T9nb/d3CT0KEGtIAL9qxvftlSOrIgF0Vn
	7R2mT967fyGSYYn35y2DuhhwBFjxUVfH4V1d64bzCybCdIbEVVMGEESHpCJA+s2k+W+Ffr
	KlhV2r6MK3o9FTkfx4WjxsSlL0JQXgQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m5gNFq9t;
	spf=pass (imf13.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473670; a=rsa-sha256;
	cv=none;
	b=PF+qFH0pvgHakfSOv4jAuIL9P+qppNRvUetEy9grAfLotjPxNi/i3QTbljjvi0/YdGdz2p
	ABsTTFig7CjZCDeXqF2En0V8errPowRJiogElDivjzOfx62u+MLaMO0HJCT4s8hLBBgCHJ
	qVLGck3Pvt5yLf6ABD++/wVlENpex8U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 29871601E8;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C60F7C4CEF7;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473667;
	bh=pkJZoJzLF9iqeLVJl9eFC230COFBkNODo1ptXRHWVNA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=m5gNFq9tQ+3U6yQfrjM8YDqMqVBfKOIiJkvvgOANDGDD8d2crpzji0PY0qgq5zp4K
	 dCgZwN8/vl6TXpCXzLW/s+KZkA6yI8zrX8f+lZoACPcMxr6W7QTdn/4FK/GLKT9LmS
	 rTii3M+ANaJ1+wXGZkOZzaJgs07XHV0Vl+Fm1HAJK16lFi1It5ond4HZUebura9rjQ
	 92nlRr3Br/AC8dS9xK26qZt1bL72Uyje8XeFhiVD/atafmZhIPSJUxe1ZFWon9xeOm
	 SAHCGdlxooqwqa0liNJxHCbYj8EvwTILKJlYTANRbzBfn+MW42itvFZ80CvrLImgW4
	 2qqZiTEFKL3JQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB82D41C15;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:46 -0800
Subject: [PATCH v26 13/28] prctl: arch-agnostic prctl for indirect branch
 tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-13-f0f419e81ac0@rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
In-Reply-To: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=5383;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=dQCuIcBeSqS4/Ez6/HvMZQDTRacbK0n/H+7Nb0rQBYg=;
 b=wun7sECMHen97xUGZGSyuhJBaMbIiRfV/5iGmjkQxnyqufnQ/fep/FxhojWajQkTUy/g0XHGZ
 VvNvho9hKRLCZN4KnOzLIVRYPAPyVKwmbYaAV3CcD2U7jYDMTH7KQPn
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: E3BD120010
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Stat-Signature: ifcc31y85qj5c6cgw81rrsh5eksqoewj
X-HE-Tag: 1765473669-40550
X-HE-Meta: U2FsdGVkX1/nIxI0Hv4CiIWtIO729OtcRe9nvPsjv1sHQ7dLtAF9OhvfUKKJLSV5PrgldkcvwiI0B3oNAcceAQm0kK0SAbxebMUx2vVDZMhgsvfgNjJVg8xSxI02sMO6PzLkaDTOv+L20m6/srSbqiTuMN8h42OJJrbZqawUR3uS1z/9RKrk7B6h1bUNZJ+8sQgvo3WjsBFsX4rpAPqCfK0dj2AfhDCo6pvEJfS5BNLATrkdH7GpiYyuX6U3lm3ULrla7zd0s/2gMpQ54Xfni3NORTsYBEvrcyNqI+j8mH1i6n3xNUsMokIqdth0XW0NDAo0rP8Yj1xV9OuaPpLQGmY9PsCKMPQi7ESacV8ouVwmQ/PSprdVxSj6TMjk+N9A1A1iHEgkv7b3xWRmF4yzuaN+BckGQB3rSwYnoBivwlmXy1LSCVrerqyaQkKyPqn9qYmn1jdFgf+l6OnWhWJIgW/c1T4VMwRjYeq1zrn8xlYHbK9/hk96aJcftPBowx3mturhS99GqUh3AtpOUQeh+omQvyzEQEEekgfn4FHY8r9wtW38BGsugilbu2u0rbsqAznBl1h4vSQlBTBGBP6UVO8vL6IvyxGT4DMhgVH4S7xDlAoYttXx0v1k764AitbOPxG29cZQ2YJQNheaWGZHmHndjODGa5WnaCxcN16rMqHIRQic0/2cV+L2ToZAHQav3UusLFMgWiqdqq6+rIebNnQ2yPuFy03vH54HpBhxD0TIj6CB/4gGRwf7cqPORNIEsMTFfj8nVdDOuBzkQBpvgdsiQnT2fFY2clMnW4wjYxIFrp7fgn5Q55jOZc/R1SHkrWDHhETUEX3XPOuuYWDMmRKHu/5pPqIGSmKil43jjjld/V2cR3YE1Qs7TVSJSaaKlso1haMcu0tyar2oUC+scEICU1WqtUayxgPlLoLSdAdBWp/i9hCsFuMYTOlVgAXy5A/4selZQ76LaFDz0c7
 +wmez2BJ
 1syj98+fW3CBJ+4KDe8cr0abDfRPmFnssPA+UJPbmlsnIXlujIWLSEIH3IsBMpDvzp+nmamhhqy6hYLAwUJkZ5hFQpw4nwfyN/etVPFu1GfGOJE5FmgoIr4JGAfhr3X4bwwyV9HT7sJSuINNI6SDZ5W8hDWVIS0VXh37s4QW7pMBHA9u1INyXV9wHb7TyRABFq488qN605aXRo4qD6Ai95KWwqzCwTrIavB5g9eZ824FNYBTYhX/zstK6JaARfO09Nl8/gk7F6uCzaqzk20UmxB+hCDm7HhHNlFDeFRNVgl0kqVPQ4BEgQ1j8n81PTh3xKUrJKEneJXcaW8KOd4jLVz3/bC24iXWFOS89rtoH2KS5UKDEaJMEJHQNmDuUo1rM+tc4++cqT9ycJGutww/EudPIiVCmAfh1nQxo4Hh0SKDaDAoor+ZjdNSZfEKw8L0benXXVHF09tijxZNfbzyWLuJ3TkWIts36Kg/U9bk7Cs+Mn7mu/ctALc/L4pVSNpMxAVJyCwUQSPxAOvP0ybMTmeHJs13bP+DORC4mvR/rJjTF7iVDaMPmo62dvItoTRPMIyOKS+l/OOq9S+XiPNGH1ifAuk+ncfG+e4R7vkW0boeUaBY=
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
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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



