Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B7C7CD3445
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 441B58E0018; Wed, 12 Nov 2025 19:43:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3C08E0016; Wed, 12 Nov 2025 19:43:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8628E0016; Wed, 12 Nov 2025 19:43:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F18698E0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 89DA85A791
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:46 +0000 (UTC)
X-FDA: 84103736052.11.8BB8CCB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8562F8000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RZxQc6OP;
	spf=pass (imf30.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994624;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7mqmvp4qHGKQdbAY5xXRef4U1rroaCrQF5ZBjvUPr8=;
	b=bGaqAY/b1lcO2/Njouay2YGVm/kaNYFtrCwUAFmURzoapfjVB4JfpcLYmyssOPItWpjaGW
	yZyod3Ddng9xk223FISBkcYMDNlTnbLf9A7BC12KB+ffSmCIo+nogABwt9yEAKErK8/6qt
	HRnWZTzmNS0tKlWkUkLFqArI23ey+iM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RZxQc6OP;
	spf=pass (imf30.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994624; a=rsa-sha256;
	cv=none;
	b=qM+8pG8hoqbg/Dk2G+i9dsPsHngZYL+L6qN9cf7L3u2OuGjkPghZp/4V7oLM6IGkzNh11h
	KDLP9KMdt7zyMLucQ2KDRaeDzuzjumtG0CekmNGytnyl3An8TU3S6vMQhnwVhTd/Tr/FIf
	5XxjWpEj44qrPhp8E8IPs5DFq4vrKdI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E99A2601E5;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42578C2BCF5;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994623;
	bh=qtzfTIDLQudHuwJbPQKZOmfk4VQHfbiISADd/7PYHv4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RZxQc6OPRdJa/hxTNp3cnl4+Rdr86NLaW5RlHQQXwHKb2To/hwutjNO+We8hzuWwr
	 pyANtITzMgC4yhImGLQpFH8xnLQIn86jBewX3tK2gvlhUoYQuFE7LoWwjDNyHHLhUS
	 HOE2q+q6m/hYAHqM09INnMTlG99sQQ6vPELFer3Ez0WXFPV8CH299pBQIBaHAslwZt
	 R1adgdRcTf6AbAUqsn8S33KorwqWA3TgBbmcyly2ArolJYHbTKk48vewJdshn/v1m8
	 gAc5D6vL/6NP4IVosXeCk0t1vfGZ2AawV4GNO5VTsC9L/N/narv+VGYjSquFOiDklq
	 PtLD5HpjBxTag==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B82CD3445;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:14 -0800
Subject: [PATCH v23 16/28] riscv: signal: abstract header saving for
 setup_sigcontext
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-16-b55691eacf4f@rivosinc.com>
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
In-Reply-To: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
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
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=5523;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=dExd/Izz/D7h0D55LYL2T1f4YGSOKQzNdmSpGgskn9Y=;
 b=7Y9IPCAi0R+Bv8dvNA2iDJYExV3dQpvEBZQEFuoNySuYeSx0VUBxahfMI/5oasH+zYwQ7wIiD
 RV1DNR6Ew5FAAagKY97r2LaL5Sqwg90FwB/HZkG/FjLTykyHYZycxjS
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8562F8000B
X-Stat-Signature: dp5fn94qqb5z4fktucbumo1ncz6hbt3y
X-Rspam-User: 
X-HE-Tag: 1762994624-942546
X-HE-Meta: U2FsdGVkX1+3nG3laUo571jrvO2mWO0nwzOZVkEBSimP0oxr0k12I8aB86fvWj5/EqlTeJBr6Ka6emh84w8RpiqfOpH9wzTTT557jhbsg9y71E4Rf59giR4uss2kjUVhc6tcNK/VFU7wX5MymSpYB6n84+90DE8qnF4VP5F6iAEeomjn116mf2wkSjftUDftjWatqGB9shvZHjEll/9nZY+e1WCS7UeHTOZk5XWAiNROZitzOFJJpcX228kXRA3mUWFDmsIxvhKXUmIggWnMtSUUDNlW2mFGwJSlPzOipS+LAHUMHUQGLxwDRH1WAOuZWVm/x8XrPDaDZ1R3SVYxqdD4W8+sm2n7/u4PXOF4/C74gUMIKnVDIZHYceY6MZb0S4a5zib2G/+eTTWuUvm3nam1CdfW6BpSqNuA0fK2tHAwCBrG7CFcsEhpb5fTHrEknnEd/ycsLxqUsBpJkls3kA3qWemKeH17uaUF33H64taGASu3fjvirBi83GcmKl0Q/AlFhqxBJmHRJaHQWxdQXdHlZ+ouhSuJTk9Rc7QRLAW1Cezkim616JdiH1Q3oU3mXKT7O97PeQ1pNly48E2V1CIIIykDYHdFn6O3v+ywgS3BI/Z+A4NU3TpRNTT7Uq2qtdQ3rgoDFsSInLSPwedR+eTa6zr+uQdNizsQhFMU8LINNNcfDidqxSNAfgnYvbOlTruT7kvB+sREu4dHJtaVUjDveBv0Xeriz+jawD87daLIMHXoXwGliWdD8GiD5rphWGo0GfgEjQ+zmdKXQOKC0ML9wna1oTCxJBLPDBgbr5/DwspxySpERzvyUs5CRnoTSHpFj96l225LL0I4cSywVYNgqEErf5jtiZv5zCOEFKt6SWOiHglNAzMP2fN7gyWnOXCcOw4uss9pEQAuNz+psgBahhyh7gJY61DJMU2iXunmJ8f6igaxiAY6Ww4UWp5khHreU75AaYq0GV9PtK4
 vZa6k2c/
 6DAyvaYljqWya60DLelmbyOB2cYYJqFBcDfylPlgQH7O/caDbNPs4+sJsHMXcFpBKIM4BlDrrWumE/QLfVQkbb1BKV2yjj9hozQESKsrKCVdRDE7Yw5rjguZoZuP18Lzr86co4qjYBVFKnnubjPusC7RfkBRjKTShQMf5SxI4JHpk6hLvgwmWUm5AzBqJ/XYie58l4qKNHOfEIc3HTFpok8EJVQmgF6MKmm41O/ExZ6SDxQ5uKwcyGHTF+y/s7gwb6zhRWxcEuQ/slBuXzk7XYMczf+io7hX7t5WnBV05LwKUf8GTXTWgk3LVwHLBgdcK/QX3d3dVYzgGO53glOK15azv6vl+gich6xfCgZtd3r1GzdLyxAufvLcI60Ru243xfDR0Sji3ULSZ5URqaPVXxrf/RY/IFIfC+8YZvAVkkIDQefTyFX1CDjDOAqb/Ij4daymjRBk8iL76FbC8WouWcj+lTkQ/ZqfSY/S10S4tZnlIIcc=
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



