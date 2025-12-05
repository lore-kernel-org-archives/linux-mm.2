Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A1BFD339BA
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B6016B002F; Fri,  5 Dec 2025 13:42:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5670E6B0031; Fri,  5 Dec 2025 13:42:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42F946B0062; Fri,  5 Dec 2025 13:42:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33ADF6B002F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:42:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 024371A02A3
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:59 +0000 (UTC)
X-FDA: 84186286800.25.60C5FFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D7FE740002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XHTTffwg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960118;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SzF2fVt06sO3RiDJ68n5VSfIXPMuwHIlX7ypxE/MZQE=;
	b=aSFxAwTUyKipgECoRBgMQQgZnmuOC+inR+xuKkSWSVCNlMtb5TGYZ/uXanZFC//vk6XtSy
	6PBRHDXR4k+NqPM+MmV/MxjbxNf1s7+QJbTgLqCBXvsjoFUr+atqiYwF9lOuY2hcmxnURW
	dNXAa+aMIFW5VToYgYYS8L/dZJ7jNL0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XHTTffwg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960118; a=rsa-sha256;
	cv=none;
	b=AwiufSln0uj+vo9EMigbon9pWHmRQx+VLIvOWqPOvMezC7METfa4OCtAjr6YJPoOHGW3I+
	QoeB5JdZIuK20Rj+BmHhw8vMPAQ9yBs5GF//ATKvWUEp4+JFKEVpcJHVqB1KeLvB7cW9NQ
	HnbK/35p9LWkCYQv/CSCwmDC/gjzCns=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BE30444AD;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24FF4C4DDE4;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960111;
	bh=pkJZoJzLF9iqeLVJl9eFC230COFBkNODo1ptXRHWVNA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XHTTffwgPveQDemIvzWbUXi+fOXYWA10lFnLnLS3TsW+7fJ6XM8jyeXT5mbttlGJv
	 MKR9X+ZARcPUftZM9Pri2sT0PuJs9lKZDEmSX1bLgPMycOIbE7ZdfrajIIjY+K5RgA
	 IFEkWblu7fMOsc8KlF5ESUPe1LWTfO4dnoYIfnyBttLzYk4jB8RO4tNDfZ7gXQ1NCp
	 eBFiEW3ug9KxIBga9jEx9/86edIK5/ojlqTN0JFrHRb6HNaKQdcwgnalI7ExlTfLjV
	 UvGrrT+mDkYSKCszzwYExKO0wc78swaeiH2dbxmZMBqnnBI9eMGfWNAPcp5TrgKVsB
	 qh7Uw5Otfmk3Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11596D339B2;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:51 -0800
Subject: [PATCH v25 13/28] prctl: arch-agnostic prctl for indirect branch
 tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-13-1a07c0127361@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=5383;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=dQCuIcBeSqS4/Ez6/HvMZQDTRacbK0n/H+7Nb0rQBYg=;
 b=jotUyn1qZf7drFl/0uNNz2A1NcvkhXDNX5aDaAc5Q1FtmJ0Ih4tpe4NXihZZRVHqYz20KXKjK
 Q6h3y8sopx3DvlYeoyOeEnD1h39tpDjYc5ujFzAfoIdGY+g4RaoWRwK
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Stat-Signature: xyfstxd9m4s3g7aoaa5wu5obudmykfo1
X-Rspamd-Queue-Id: D7FE740002
X-Rspamd-Server: rspam06
X-HE-Tag: 1764960117-789851
X-HE-Meta: U2FsdGVkX1//+9DH4gb8xGf37BfJ06jwZCcktgqO0PhY/lZzySfiDQfA/5N8n50mdcHhsiJFWvcFWEr4RFz+bLOm47puznRroaDVO5C+i1mwg5of+kwPrRqr2ix29ynD6IeIMCbGqwWAjVlI7q6IMvwaudXQZ/frZUz/MNAuRwyt7QCYsNaq8/vtEGiI/peeoVhIro5EiRwJPROBaLmPOEIbI6RW3E2hbjNyYBbXA+Ny7bcFwD/hZ8Hn1uOFBJA9mxxjbx42EsZw1MXTiKtqVfhE44A+C0gcPvBZHg5oqvB/pA9Mjn0eIfK7rLQZh8LiTesQGq8/MXgD+I7yk37b577IjCxFz5txC5iV36Xa1dhaXbPa9nLvDz4/CEUCYcRgnochKjpej7eUwal1qi8mMFNakJrH73lZh4O7ngRhDk5yOnn9erOXRCuiTkvNj/2+VuyqdMYZhKHS6mozXK2hT2PvKpnaN7qdWhz4gTV2huTZuSeZnYDXUa7oKef78Xpf04wdLBrEPrbvrVMAzjJkG3YOvGdEMyk0whl45gcw0kQji1BaRFuaaf6w6vOtL6G7vD+pDS3dcwVsJOBIDsbCfB73pijFlUL/Wlj1+xex3465Rcoq3DSwAJJVdT5cBx3CTgq4QKLQG2FG8wtH5daPg4sjGKZN+ODUcGoWb9AVczwwg0CnGSkj5s+xY1LZuKPxXPYU5YIGul39UolapJSwK0Apf41/BFYIOwdyRdcixpJPIOs33P0a3F3AYyoqKrlnV6Gd0QELLynFGxJCkNsykJm5axA/inqZjBHZHGLCj+yzhs4z0yQRyn2rXNoWpHfBjC1mB32viXTeuzhpfSy6lHmjO/9keOFou/5dePG/ASq7GkaIKubYzhjY+ZaxaZq4KQXjfDVTDUnmuBg6RivebolT3cDpDZVHfnkqemb0E8cAh07fvSou+cOZ7EKeISr+zWpIrizCxJRTGbac3TP
 yTMJQni5
 pFYcrYPr+fsR0zTacxGK1l0wLznCr3ELUBLGzaVSkAqxQ70BT8fy8817XecgKALwYm+boTLtpzUYQTPF65pIqAHLv8WiscJimncf93dAsBSLm3Bqxy4cJUAMzSx1chBW2TI/lBLkOWqKNjsmGcSyJ9LF8sINUQ5SkqpEFOSBkjTU8K/8fo/QnkgY0GA0sklU0NFyyLCWgpA4mQLFVt1mI3H1tH/1iTniKQK6LH/QJUHAVuslycRh8+YBO+C1unZc3GvSm/yZ1x2V7f7OPi8WckFAz9ctut8dnYo8wFthRyvzuuH639409IvYHACmVd1BftwffGjkE7mP1fiZgui3NggX2UqwlZdUhwqEp3raar4v6X/8rLK1EYjhqxkXIH0KmmhxQjVUdP7ed6q2R67TsjgYBOL6nAg21e+or52wX6DHH+fN8Jq4dETk5ePyI9TQAp6917Ky20AbnUhL/eXwsHTVQbqG7qUj7SE001Im8cUz9KBO2xOYPPxzyqIjo/JgLBqhr+3WcXjgNLs0JfmSrDaHowvB2NMdgqPnyABKgo4h6mvpUqIJiOEIh7kf4fZJA+olsX4wlg4+mbMShLY+r0zZykMM/k+YoG1p9wmqwh1TXegqGADNdbMv0bQ==
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



