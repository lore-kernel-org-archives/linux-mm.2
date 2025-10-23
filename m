Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA1BECCF9EA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C97648E001E; Thu, 23 Oct 2025 12:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48498E0019; Thu, 23 Oct 2025 12:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74038E001E; Thu, 23 Oct 2025 12:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 84EEF8E0019
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33386BDB6B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:22 +0000 (UTC)
X-FDA: 84029969604.21.BB376C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1A7A02000D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ll1nOhcH;
	spf=pass (imf03.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238280;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7mqmvp4qHGKQdbAY5xXRef4U1rroaCrQF5ZBjvUPr8=;
	b=DaRb632Hj8+pYns5lV5Lj5pX3x7nWuSF9KSDQ5kBgEVzRh5zgA1G3G27n0B+BNj/P/XAOB
	j/5AZgqmw1OeNdUImwzNx/1p2ZoiJ0r4o1csITw/uus8crRfF5FN2SbDjz9VzsAAzfYhwt
	b4jgmYLIdg1bKSIvo7Gdm3UL0trP1/c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ll1nOhcH;
	spf=pass (imf03.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238280; a=rsa-sha256;
	cv=none;
	b=S7y+9286lO9uGCTdt2WD9vGZGZXmephd/eidEKotqeZFrz/fRn1aRHjso5yPyXrfO2BKcA
	t0s3fVgL/w5PqU0lMmkMhRhieZbofmsWN5QyC2Qia7kwLAsQgUDO/744vJDU977R9F3NTA
	cWy99bnod72l5mwJTcpfqpN/jnaPurc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2BAE4B0D6;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C196C2BCB0;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238271;
	bh=qtzfTIDLQudHuwJbPQKZOmfk4VQHfbiISADd/7PYHv4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ll1nOhcHYOrNY+XAKUhJxZde0l92pEu1y+HSMdfYPM3TJjPBAeryAkvR19RXk2SAu
	 37aTLm7pFKYx+6mDVU9UvJ0T3OZaMeIshrJ2usXwHAE2Ai2zLAItb5Bcm0LgbIjnro
	 aEQfqjeUQfjHoM5SQK7tGLyexbCbY12903xe6XG1lKE9gIr+T1EtL7zOpFnDA9pSvH
	 LU7O/94ss6d7gZad9LB1g1gvLJyaRTJz+Jtohdgm0q3gxrG3Bok+L+8WpJOvS99eve
	 qCMhKye7F4LkNAF5QNq2uwNdn3dAJOADawFDQdmNOGFInN375rgHdddAJUz/ifqEAG
	 fcbHJLOYsA0qQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6830ECCD1BC;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:21 -0700
Subject: [PATCH v22 16/28] riscv: signal: abstract header saving for
 setup_sigcontext
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-16-1935270f7636@rivosinc.com>
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
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=5523;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=dExd/Izz/D7h0D55LYL2T1f4YGSOKQzNdmSpGgskn9Y=;
 b=QgQTfB2eNI0QYcfrnurHQIJGNKVcsYThxrj1bDCZwBl88dFrH+7Jbdd0RU1NDoKAViMFI5YOs
 jiYNmXQLPGuCh9z1zp6WkxjqL1loxigsdW9DRAq1TOlSVRAOiPBN95V
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: nuf44u1bgz6qbtyx4jgxyuaddoooso9f
X-Rspamd-Queue-Id: 1A7A02000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761238279-510837
X-HE-Meta: U2FsdGVkX19uBg+LyZMgXB8aeD0o8C48Uli2bUBiU8Cn0MpPDC6My6Y+7b2s3LTYMs34J5IRKaZZ6C6fPrtIIWPghkhxLG//bmmYUqt4kopoOKAqnak6Ts6CdcsU7HCvEqF0Kj9opFBLrfIrZyywbE2l/TYD8FLHxS0t8eZD7r+Bz+396c9JbrNh6Tkbt1xU54uU9JAPeJCgbxaNrXJlkRCqTky8XuyP/n4eAQ+YQUNDJSGk53qG8m1DzD7DY9Pi++Mv23C7HbcQ4wND3apOfIaqrNrEdkE6g2y3GO/VJamaKACLu2SvrxJ2alPsokPF8ZT/G4wrRuKLJrcr44WNHPJ7NtsA2b0Ko6rd5yuEPcNspBQtxVVRt4HHpYE6ZRGuOXiKsa4yACm1LkfAbzRNDTvoCDWYrNLSvRJWC5GWnv7qg2sxQcgI5UERwRXwwQMMPm0xDRLD17ajmafZVCmhthWvrTAi4Cetw+Bdfu2J6G2ShQelWojUC1N0YqCtm7IoxB1dt1JRo/0B8azpw6Dr7q+h8i2UtwhDtUWvBM2VKwRy5QyXUVVP1E7FU1g+Wei+w1oi8onL7GpeX7IWKgzP8mqon+QNil0VRj84egkQKu3sOBPEQHlG548PaxEuABTWc5IuldAmxvF+RGdxQgItjPILn+VgPEvqlV4rYhy/66rbyeiSd1hNWlYJUCeQ87Sy0JemmESKF0U0AgSgiSwrqw42/XxJzNw8wRK2GqFVP1lkXoyviPhhNR6MhM3uqvMPNGwkoPfsNg6um+w5WTCSCZF0oo1pCJ042521ZnX+XukZeoogZSJLkoLexP8xLc9cUci2VCGNxXyy4CkEi7jdpnvUgFVRQ4xi56S3fDokG6n8qANjnnWk5VXGxkjdbg/GPdNFPaQB4fS+KmaGTUD/zDExYoJWffWw4mvDRhjRk7bCcivh0R0a89OuiiKInVW94ePceV4BHPhFoN/ekBL
 RvKNQfzL
 Bud/CmnHuFzpUzxwt2Bylu3cpOz8ep3by1OdwAnLRP+mtfwahnozz8lGUenAVdpgeeR/SUwTzBx8KHiMsYG9ADHGL2u08RRPZ8dgOa1g+v3xviFNlg7cgdVc+faNtwebqvPXcWiYs1P8biCvJNffMnU4IQE85BiQseqc/lrTvQcCBW1umrchRvIiVtYH0KbwIj788avyWQRLbhi8/E1AUUVpeF+Tsj4WqY0vKNvH2p9oVoDbAmoTg6zhSmUqLRBM8SkMCrg3XB1bujISO75O6henCIDoYlmyfKZdm7zc0f7NRtEG0Xym4POlR7UVy3Koq2slJzwY3t8hN/s2v93EKF1kmKhBnCYnYtxxyspwbguEYe6G3sA5K1HChC983oCjchq+cx2tozZxwHqcxT5ZNF27i/aFtXrmsC3HpwCYtkKScj9QqR6QC/TCiH1T2K8TyFYOA8/8M7I8FiBxGo2drpb9KiGqO7PeYAkiVDN76EWm+Ly8eRZEk7WJcJQ==
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



