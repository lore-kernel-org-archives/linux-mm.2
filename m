Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD392CCD18C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C4388E00A0; Mon, 13 Oct 2025 17:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C968E009E; Mon, 13 Oct 2025 17:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863558E00A0; Mon, 13 Oct 2025 17:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B71F8E009E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E61E0471AE
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:37 +0000 (UTC)
X-FDA: 83994450834.05.46299F4
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 03ACF10000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=FLf3FcRe;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7mqmvp4qHGKQdbAY5xXRef4U1rroaCrQF5ZBjvUPr8=;
	b=tItQl7+A3ozDAv2yu71+urrXdWdDlNRMRazYWbxxvvo9bffw7vvOk0aRBbtF7J88hXdoZv
	Y+ZXBl8KDmLvu1o4AiMJ9wjIgGZ1Zl2ybY9z5sk6P7mQIkRQoC9AzNftr3yeKk+LWRzxIO
	uco0t82sHV4pyBAndl/S/oEEQw9Hj2M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392596; a=rsa-sha256;
	cv=none;
	b=AXlPmEaSBQFrTGsbJ0TCQjsYdm8pPX1WyMuvbdvNdkeNaKyAW5WaVRzLolUn9PviQXIgZy
	5eFOWjapNo6Hdixn8ZMLgtz8stALiyqNTmvvMBxcxMRwmv1AVT5qzsiGD2CWjtyieG14ok
	JUatFgtY+PQmJcEyXRj7jXpGG8Ye65w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=FLf3FcRe;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-339e71ccf48so6604952a91.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392595; x=1760997395; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z7mqmvp4qHGKQdbAY5xXRef4U1rroaCrQF5ZBjvUPr8=;
        b=FLf3FcRecJ5Ao+irebtQxtxViDeQCs3qklOkPkBRhu7od42LraSj7EQX8NbheHTMtl
         VtLtHP66e83yevB2WruEvPhRQ0A4M8pTFXYQuvft5/rzqNEpNsjyxTHTX2nAMF78dFRV
         tOfK0ZgpSXHWR5f9etpQomnPTLfP3JFYw4Juc9P6y/eN4jw4y+hX2iHTIaSUANoSaqwY
         T0cvsdnk2eUQUwQGLd4YlXjrOR/G/762EDnCmSElP2zD+h6dAfHMDbEJU/68vYWdA6C3
         c2h0IVzttO+X1c9RDqWkxDFITLLNnJ8EnsLeVMaub8h2RxTCm36tLAzAApRlAHZ6rNdE
         0hRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392595; x=1760997395;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z7mqmvp4qHGKQdbAY5xXRef4U1rroaCrQF5ZBjvUPr8=;
        b=FudfOQQ81oRjuGLIvY2CMAThvxz9JiISW/MBq94XsldSrKVg3J+qeO4CtEk+ZhFOYa
         0QLiMVf425qE6O77XRQUuu1h8BiJ/aEKz6IkXVcwonvJ8AfiHH0EWqNFCEx2+s30rsLo
         SiR4w6Br7W24tEAhziyR7cQX1x7bxSHFbQCL/j5lduFDKS5FkJpN03yOx1e1DEoAGEuo
         qjdvDwFwJEFQ6QPwFjGHeOwROoVtTlUH5PpbdtAYjjyJMy9iFuybcS/4OY0+wgSg/SMC
         GoiaybDM0YZPpOoU2AS+ZcV8mEjJJEl6i3+xvwLcCw1GNY2bf72gFqTeMMkzYw7RF6gq
         54qg==
X-Forwarded-Encrypted: i=1; AJvYcCUDNZ7iVSdXLRYilIk80MkGFmpikViC5or5seWMikvhV5vE4cP1xqfAxSkvIjfQ4c/iDH7dgnkC5g==@kvack.org
X-Gm-Message-State: AOJu0Ywxmjl2gQjxmUy2/dxgarFxPHSwitBA84FZgbxhRSTm4pudYQur
	42ef1zkxK5H/mh3LM0pM6i85pMH3Aw7+BsD2sjHTxYzbrxuzjr0MhqZ60r3T9XcmQms=
X-Gm-Gg: ASbGncskC41hk//oFHtArAm8BESxWCnw9TBv4HS0tf1xfphiEpydqy/qOxLr4TIPyry
	6XGH0vLQfJpDx2a/mZpyGFbFQkxaIFeCiIYLEar8ldkQU99nLgS88nk2N5bjZYG8JDJdR85g7cp
	XIdiDKToEFTnzYCTHwp4SiHSGigvlS4eAFAhAfuoDT3tQZvY9q1TWnta1CVQsHmGhFCYRF3MOD+
	IgZxQAt00OsUa7i5GN/uhbKmUaPDUXgMOxdb89r3rCtcJpS9nDIFiOMVkUFN9mfFrKhEN126SWA
	ZSswlNNnlh3aiOS2Zv01mRqYvaLJkdvuKsQf8c2hGDglw3ByPhaZ548NqywodXnoqCjjAbrNbWd
	yydrSgWpVlRTiiCdlQl7v14VGln2dS3ismuxKmCJz+WGyuUDcCPc=
X-Google-Smtp-Source: AGHT+IGHNK1PV0WxVA1c0sdyGc2oNVJdBAlpVwCI2xGQYidVYBgaW93nVKJ3BlHkSgITqNPAsLfDEA==
X-Received: by 2002:a17:90b:4b10:b0:330:6d5e:f174 with SMTP id 98e67ed59e1d1-33b5127b458mr32381492a91.20.1760392594691;
        Mon, 13 Oct 2025 14:56:34 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:34 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:08 -0700
Subject: [PATCH v20 16/28] riscv: signal: abstract header saving for
 setup_sigcontext
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-16-b9de4be9912e@rivosinc.com>
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
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam05
X-Stat-Signature: xo1fq7joei3edgs4gy9qwsho9q6k4sn6
X-Rspam-User: 
X-Rspamd-Queue-Id: 03ACF10000A
X-HE-Tag: 1760392595-968384
X-HE-Meta: U2FsdGVkX19qg/aZexXN/tMuJm7UpZahZZ4wGLqFT6lFHi3WtEYsYqQSDDxp2AULwJfbDD6KDajt9PrzJsuyz7cSv/3uu4Dooq9JgGuwPEl2VPZAsz9jtPOTxfplE3NVQ4bblNlGrou0HybeSedrS/MICmInLxBxnIKs1DuOUOyEAFOnCHAl10u2xPrr1dFjsXd3uh5gTzme7gAl5tndPSLucoECcqVtofj3k+moKMJx+Tmnguh3KBKb+rBm+4qO35julTyS4gswp/DsV3ofeZkgIENa95LzeoZf2Hv3zb+5egTk/P3EIfuHgTmlYHZG34T1iaAaG7UgWBw9wdfYqgMgvcimbGDcm2isHgtiq0BdcjFTFVl8xKMbfd94vpLkibkqtpG93xkTksWIugQ1ou8KQhfflgKLG3qp2NZbG/ndUSNlaXdruUOoa8iN6ZPm6/bclphXfm8Z7oo8Uuc60jN+R36ss3qemt1sL8banakTwOBOJNSMrlSu/Hx0vD8EQoY14ZzpAhaZk7xAtK+CuMrUqYehses2OW7N7pnrP8N2k6MHyHkG6GxOadCj7O+GUxSsCnVzvvgqtdbf4NJJrt0/Dm2vzZIab/Dlyd7aF8TxwTy+T9/wuu77Of5LYDgeFJWUem5gz+aEzxMv1kT0xo75X1zUp8DnKso8Z7+eGzfglw8jPQYLCSpPTcAqCOSlgTzZ23JpwmvbA19o12K5VLnrAfANJA6AptOmT/t/bA0mYRlVAKTk+lywB00giZETqA3R6d3BGOyJdAfwm567FrPdE35Z9ugPFALplhsCM8YCWOJQBEFXs1eTHMIsbwBnTtLO/Ayvk5k9zG6WRkDUEQK7448r2FKRQB5yESlGKR0Pu1zusTox1KXt//eIGqGmO+sZefK+VdLRaPlWxoYDv1PMfE2TyQ4Z9t2tyuLaKr24yypIh9gsLQRHFB/NlcLbU9qb5TAvLkD5aRfEA4N
 HYgbOlkn
 dBh1xfl1H6S/EJU5DL1hftbR9vboeqyrmhT5KKt5fTZd+A3mxCaLU55d9MvnaxkZv6OvIT28zKhd8guhcAY3CZnDOUUdVWRHklxkg0oi43hxpq4j4v8pm2bQBMZ2pSWE7zW1K5OrdbUSniX8rh/IZppvQAVGfMniESwgOPjn+GRgICwpE6w9Iad8Bute8dgafm0B5K1LhiwNwGSzbURZK3dVLggNrGZ4wguuOY6LTqS5+udgo/bx4A+hv1NlIUNQduzOx3LWtEAWp8hstgfOoBNElEhEtq1aTwndnshXySrjHZYEmN9ty0mFm9w+pmHRyTCoKHk5M//qEYM9anjHVjbk12J7LDiDTjjFKb+J/WCnMyV4ByCwEypIl3cNQi1UkIQ4HfYVcky33eMF1B7aGd/LSJ2hFAUSfZSsdPv1l7fgGph7TBKhPpU99gQ==
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


