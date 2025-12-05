Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 240E5D339BA
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7E806B007B; Fri,  5 Dec 2025 13:42:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45026B0088; Fri,  5 Dec 2025 13:42:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32F46B0089; Fri,  5 Dec 2025 13:42:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8DBA96B0088
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:42:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 562E313344A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:01 +0000 (UTC)
X-FDA: 84186286842.21.4EC4C0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 505E314001B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6gB2ixI;
	spf=pass (imf26.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960119;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6bqbDqI1OxuzT7pHAz8MwWOQZQ4coeGZsCaZoxD/afQ=;
	b=Wzge3aDUT/8S9QYmw6bDeZexkGVHOOA8QaR71WcB8zou1atiSeso2bAGVLTCmgjY7XpGJ+
	w9UFeObTY3C9Z6GFmJW9cmaPCVSv3hwnxoq+aV0Nnh++7xZ/h7L2izbz+Sz7vKHBjkCDyT
	q4HrcgkdmIGHGWAjj7mG0fOsOJw2G9o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d6gB2ixI;
	spf=pass (imf26.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960119; a=rsa-sha256;
	cv=none;
	b=8g8/SazXOcM5VY2J8boD9Kb8k6P1KuUGSm3W3i+6nXF01K6WCrwlOEWmck8YqESppdNhUh
	Y7dzQM9Qa9fH3FE33rzFngdtk2zTNGQvsIVMaGWv243+J7Un4KSEIedrJ5yZ64JXRzuNle
	yGzIIYGL5nFpaiinyTx1w+Y2Wt0eu9w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A83FC445A5;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6892FC2BCB5;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960111;
	bh=/b2FRBPTiW4dUJ/S4xBM6AsIWGjpQgWYDqVUhP9+hDs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=d6gB2ixIU1r1RxjTJhDYKaS3lHxZvUV/nqXg3ZSPj4nO8D6+ovuOL4wjS18h2Ls+Z
	 ZiwbjCpMHGMBpGdaOIUwaHgIIfA5A+jDLPaUpo9yvNsu8Q/sCO7bGSiC65Z94mILCY
	 7T75Zz5rN6HSHblz7dJN9dcDt4Ti5ETPy5zxu9CWq1+kIt/liI8hopkIqIyccNqghV
	 qhiE5/0btRKlDxYQXsvNaRJyeKEuxqCr5ooJ31eRgcJp9mnns4DTURU1XJA1RfRxGA
	 cKm7wRgk5kSYwg4vg4khj5c8SymB64GAuqcT19MAxQq4CrHYqqcVt5U7C4TPBI03WF
	 T7mS8xvwmUksQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55170D2F7F6;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:54 -0800
Subject: [PATCH v25 16/28] riscv: signal: abstract header saving for
 setup_sigcontext
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-16-1a07c0127361@rivosinc.com>
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
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=5649;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=qLyvnvAoLt6aZ4IZ1fb5cJfdBRhzOsfjSKqwh/aUjZg=;
 b=AGjF853l17FkirVWxV5W1qWqYKIiq7BbGE1ydith1NDbkFMhj5R7I0j/+b/aaSEgLQ6Xs49RI
 NL85ARo/x/4CNES5kKDr8mS2HJ6Xyex2yO5H9oqUePByfmLK6PNwamt
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: 9gydgotww9yyiwqdyfa7xm6iimnuf8rj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 505E314001B
X-HE-Tag: 1764960119-602693
X-HE-Meta: U2FsdGVkX18MdJHued2DR0dHUjrdmFLA4oMXdwMlZA8aRotYXJM/hK7i0cM10O4atqU9XbUtBQB1vZnFh4sO0aCsejuSlcNUj50MWe8qxYYxgoJ7oOagVb1THHxdksTLrwrPZ0q9fBG9Ybf99zppzuYcfubA/uKa+pGDNFfbxxTH3xDGl+Zs2wEiDYSxjPrJaju+3YCfkwYv6picE4UU42QE2ODzXsCBKX/Nt9eTOSI//QV7AFmGxb8HRLHn4Ysyvu5CrMIbpQIcRWVLdM+LDHf5BCgNtvilAg7wt/4CXSxJ7ksiBp/nR+toUT87WYfSMpF5gyO32rpQ+aioski9Fpoui4YEWTfHv4GCmdbzo3vFjEutBRcSsE88Q1HptV7d7Md37KMnWJg++joFzSvP/DcckSFLYnVp7VSXuR32P0pUOQyNZH0UlN6vmLFiSpufnEOO0Mq5X0IzpMGV8npQ02st8k9r976z9Bfgb8hhF0pzJG0zGRsl0clynQfmX4PiL+nZ4sKYz3F0lnIyZ76vxRTiCtlqVz7dNu+iCbtFZVLs+AINJ2lzgf1X/GWPl+IPTBBwOKbi/sTy3+W8XuOXSA2ERBqf1mObYOlKtHQxkP/uqdZJO7oqNkFCF1lVQh6/xJvUUJYw5mgvhB4lAGEcVUaHtf8RdKmYWxIZ6rOi+KKfK93k7iK+gqsFS/6uK620YAb4lIxnx227SxDTZHRvaGgXxZgwvnyIwnlXiuTepBMfkL6Cu/nbKowyl+OirS9ZKf/hQMcVWP0NHEqCBnw8KUWq8mmUIyF7VdhfV7yGaiPwATG9bf5nlcklJ/xkVXu1CFXinbc2Npke/lDuqY805/wLVqcWbm1Tdas0APjqO5vrbtmHAaARmpZ9Blln9fhDivsz5++ybs42/YC8XNrkKCdq8dpYUjC7R9FqA5Kgl/M5T/Eh7qgHyY5glPRSqrsdFObQwUh6VcV6K/F3TRV
 ruO0oRFu
 KA6TJmcjjBIglbT8Cyw7/gHQ30YeEMJCSGkF0Ddo3ajTF2w04gQcBudCkxNtihj8i2hyBKN5YT7DarukOEqmIJF0exDg2kErcHXqFwmm3mitfOtR+FZiifuljyem7e5e0HgWsekByWYRt77BzZTCAOn+BmFo6Mvk1QHyi1bo9rd20FpZKRgtzTztfyZY96Y918ruF4P5sUlW2MEUOaods8UVcmPNfb+m+ViA6unZiYpdZhmXx3bDET9IeKdOnUfRJz8hDRGVn8NuEmS+1z8yx6kPjbB8OLsOqc++6K+mAX++AFA5kog2z9enPmYKkO7FZHBVaIk/L6zhdRfS89ig7F85/s6NzEWYFDyJiD3bEZ2u6z1mmmun4q3WH4i5CIP4PDWsxKkcHLkHPPE5+njuX5vaUg8Tp4bI1oCQ7OBPnPGFJ8YtNH3/392jqvDi0/Z08wQFPKzfV4tv9milt/sqJxynwXEVxrZkhsj2Q1jXNKadkMv2EI88NNaHN/9+Pz7HaSz5pF7TrCOGaXfImsIIeE7pMQumckYYTwHKKLGbmC650tvQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andy Chiu <andybnac@gmail.com>

The function save_v_state() served two purposes. First, it saved
extension context into the signal stack. Then, it constructed the
extension header if there was no fault. The second part is independent
of the extension itself. As a result, we can pull that part out, so
future extensions may reuse it. This patch adds arch_ext_list and makes
setup_sigcontext() go through all possible extensions' save() callback.
The callback returns a positive value indicating the size of the
successfully saved extension. Then the kernel proceeds to construct the
header for that extension. The kernel skips an extension if it does
not exist, or if the saving fails for some reasons. The error code is
propagated out on the later case.

This patch does not introduce any functional changes.

Signed-off-by: Andy Chiu <andybnac@gmail.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
---
 arch/riscv/include/asm/vector.h |  3 ++
 arch/riscv/kernel/signal.c      | 62 +++++++++++++++++++++++++++--------------
 2 files changed, 44 insertions(+), 21 deletions(-)

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index b61786d43c20..75d8bd417797 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -423,6 +423,9 @@ static inline bool riscv_v_vstate_ctrl_user_allowed(void) { return false; }
 #define riscv_v_thread_free(tsk)		do {} while (0)
 #define  riscv_v_setup_ctx_cache()		do {} while (0)
 #define riscv_v_thread_alloc(tsk)		do {} while (0)
+#define get_cpu_vector_context()		do {} while (0)
+#define put_cpu_vector_context()		do {} while (0)
+#define riscv_v_vstate_set_restore(task, regs)	do {} while (0)
 
 #endif /* CONFIG_RISCV_ISA_V */
 
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 08378fea3a11..a5e3d54fe54b 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -68,18 +68,19 @@ static long save_fp_state(struct pt_regs *regs,
 #define restore_fp_state(task, regs) (0)
 #endif
 
-#ifdef CONFIG_RISCV_ISA_V
-
-static long save_v_state(struct pt_regs *regs, void __user **sc_vec)
+static long save_v_state(struct pt_regs *regs, void __user *sc_vec)
 {
-	struct __riscv_ctx_hdr __user *hdr;
 	struct __sc_riscv_v_state __user *state;
 	void __user *datap;
 	long err;
 
-	hdr = *sc_vec;
-	/* Place state to the user's signal context space after the hdr */
-	state = (struct __sc_riscv_v_state __user *)(hdr + 1);
+	if (!IS_ENABLED(CONFIG_RISCV_ISA_V) ||
+	    !((has_vector() || has_xtheadvector()) &&
+	    riscv_v_vstate_query(regs)))
+		return 0;
+
+	/* Place state to the user's signal context spac */
+	state = (struct __sc_riscv_v_state __user *)sc_vec;
 	/* Point datap right after the end of __sc_riscv_v_state */
 	datap = state + 1;
 
@@ -97,15 +98,11 @@ static long save_v_state(struct pt_regs *regs, void __user **sc_vec)
 	err |= __put_user((__force void *)datap, &state->v_state.datap);
 	/* Copy the whole vector content to user space datap. */
 	err |= __copy_to_user(datap, current->thread.vstate.datap, riscv_v_vsize);
-	/* Copy magic to the user space after saving  all vector conetext */
-	err |= __put_user(RISCV_V_MAGIC, &hdr->magic);
-	err |= __put_user(riscv_v_sc_size, &hdr->size);
 	if (unlikely(err))
-		return err;
+		return -EFAULT;
 
-	/* Only progress the sv_vec if everything has done successfully  */
-	*sc_vec += riscv_v_sc_size;
-	return 0;
+	/* Only return the size if everything has done successfully  */
+	return riscv_v_sc_size;
 }
 
 /*
@@ -142,10 +139,20 @@ static long __restore_v_state(struct pt_regs *regs, void __user *sc_vec)
 	 */
 	return copy_from_user(current->thread.vstate.datap, datap, riscv_v_vsize);
 }
-#else
-#define save_v_state(task, regs) (0)
-#define __restore_v_state(task, regs) (0)
-#endif
+
+struct arch_ext_priv {
+	__u32 magic;
+	long (*save)(struct pt_regs *regs, void __user *sc_vec);
+};
+
+struct arch_ext_priv arch_ext_list[] = {
+	{
+		.magic = RISCV_V_MAGIC,
+		.save = &save_v_state,
+	},
+};
+
+const size_t nr_arch_exts = ARRAY_SIZE(arch_ext_list);
 
 static long restore_sigcontext(struct pt_regs *regs,
 	struct sigcontext __user *sc)
@@ -270,7 +277,8 @@ static long setup_sigcontext(struct rt_sigframe __user *frame,
 {
 	struct sigcontext __user *sc = &frame->uc.uc_mcontext;
 	struct __riscv_ctx_hdr __user *sc_ext_ptr = &sc->sc_extdesc.hdr;
-	long err;
+	struct arch_ext_priv *arch_ext;
+	long err, i, ext_size;
 
 	/* sc_regs is structured the same as the start of pt_regs */
 	err = __copy_to_user(&sc->sc_regs, regs, sizeof(sc->sc_regs));
@@ -278,8 +286,20 @@ static long setup_sigcontext(struct rt_sigframe __user *frame,
 	if (has_fpu())
 		err |= save_fp_state(regs, &sc->sc_fpregs);
 	/* Save the vector state. */
-	if ((has_vector() || has_xtheadvector()) && riscv_v_vstate_query(regs))
-		err |= save_v_state(regs, (void __user **)&sc_ext_ptr);
+	for (i = 0; i < nr_arch_exts; i++) {
+		arch_ext = &arch_ext_list[i];
+		if (!arch_ext->save)
+			continue;
+
+		ext_size = arch_ext->save(regs, sc_ext_ptr + 1);
+		if (ext_size <= 0) {
+			err |= ext_size;
+		} else {
+			err |= __put_user(arch_ext->magic, &sc_ext_ptr->magic);
+			err |= __put_user(ext_size, &sc_ext_ptr->size);
+			sc_ext_ptr = (void *)sc_ext_ptr + ext_size;
+		}
+	}
 	/* Write zero to fp-reserved space and check it on restore_sigcontext */
 	err |= __put_user(0, &sc->sc_extdesc.reserved);
 	/* And put END __riscv_ctx_hdr at the end. */

-- 
2.43.0



