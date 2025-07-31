Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF31C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2E86B00B0; Thu, 31 Jul 2025 19:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73D26B00B1; Thu, 31 Jul 2025 19:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3ABA6B00B2; Thu, 31 Jul 2025 19:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF3D76B00B0
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8B5351A0B68
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:10 +0000 (UTC)
X-FDA: 83726130180.25.B2E1B36
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id A14261C000C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b="OL0l/6mk";
	spf=pass (imf18.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754004008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0g2G8JO8ClgrSp6ZGVjcEGOVTZbBaWMTLG2i8iznTE=;
	b=xP1kW3hLIctn7bJImK6h/GTEySQhZB5mIuiYTEybxIr3+HnvnnJRlbrgvqxZJF7ZpW336d
	I4yiqn4eMMovMSw39Jzf/gQTgLQtpHYorIUvNImzYl18M/PHXn74Lukn/PzgoCnZVwGFtt
	iWdZhYyrFk6fHGyE/48YP0jaIwekT40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754004008; a=rsa-sha256;
	cv=none;
	b=QngLBBZohY9tbQ9nuqu58iIY0ht5T0WwH/T7QuEjLcZIttWc3huQJf3z3lqA0vOpI3FP/9
	k/jvtdCjBwwdl58cTsPgd8UYKc8YIEex2obTprxN8gJVq4P9CVUNY55yP2cNhH/ijKKONz
	HgdMIzrX2y7XwXRVSwgGhYP8Uqjsv3Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b="OL0l/6mk";
	spf=pass (imf18.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-31eb744f568so832077a91.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754004007; x=1754608807; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q0g2G8JO8ClgrSp6ZGVjcEGOVTZbBaWMTLG2i8iznTE=;
        b=OL0l/6mkO0IYKHEgq2xuoFbut6WCfcPT5SZE4H1dBqsHaceHWAAr2Mm/JTDodkLUQq
         ECJzkNyvLxOoimNVkjHabBZxCgC3OVxbwEJu0DD72TnyRBsa/5WXuh4LySa2jyjRAP4N
         uqXNw7YJdjRB1VWAhN+UcrqfkZAXr7fw+//DEW2WiP/ROfx7zhPRx6y49M0Xz3djIZtM
         Ixh1q8+elSCc0eQoNlkn8QDIXQ1VoU/npyC2Dv+ScivQDgxop0DAlfW6iCmTYWicx5+N
         r18Exqru/+9YptqPmzKUVQ5DgKJgrjJKyPLGmxKr4MWbNycPQEj5EE4iEOWkWOmSk6eB
         +NMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004007; x=1754608807;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q0g2G8JO8ClgrSp6ZGVjcEGOVTZbBaWMTLG2i8iznTE=;
        b=M3zrdzxFIDvDe9dfWIWFnfJ/GDpOuVF5YzvABzzyAYyz8jGWx1Y7n+z9kWzdRmomqE
         ftQk5Zg+KpJ8+/zLWoCTJDmrNyJ8GjeZB1Mwbx17en8Sp4FQdBG1Li6CwQPzvcTWl00c
         bLx/reltvYy/pEBYt1yPS+lRmVH3CvvtzLevZIdn1MJN7zlFkG0TnSQTDme7Mt3mRm+8
         VLDrvgCxD8t/zw+DDFeWuiZ2e2Gvy3cWD1mZniGc1GYNsWwRntrLS8JeikpcFXJcBreM
         sBxwMm4gAOocmY6k7Wp3Fm/Ttat0GxSpNSeKEn3R1K4oI7go2CSQOUUetuVxfKg5Stb5
         x8tA==
X-Forwarded-Encrypted: i=1; AJvYcCVn2UY3gUCwLoKwTqHfGTxBEqZ3MzAi9rpmu39B6Pk6UPzEO4V726g4CTZc8Ai9goryF3x0Y57oww==@kvack.org
X-Gm-Message-State: AOJu0YxWwWUQVk0jBnyM9Csdoyy+viGmm9b2lQxdZIjS06hXZiLcHPgA
	xr1IFZ25j48xwC1k27WPTvT6sTHkVcRLCEBFTk6VuFGsua7bdIRdYcRLv+TSYT4o6pM=
X-Gm-Gg: ASbGnctkvI45zy6OBRmTq57vsDcbTZtpSJ6CEKe1YOgYfGo9h4D/1AF15KNggVsAVz4
	MiSo+g6l4RmqmmHXQSZ82PGYuRcrYnZAnn9gchCJNhTHbDv6QHmNXvWaGgcm91tct6i6x1Kd8Eh
	vxJ950lmUCfpSWGRZw0pUPIfsev0O8w+6BetD7uRLUt6afuF+vlstuDtE1onWl8QqXz7W2ERtoY
	LPGhcqN1kqDLyCDpeeBiSK0HHTOxJD4KpV2m9kt2XTGLebgpYeDAXkLJk/I/sDtQSxqLHTwUHml
	1e7/5MG6XHYprv/xzDQMMyYbkBxq6hNEUaSHylK/GhMqi3SE3AZZ5nNCmSRzonJAOz8eXJxugeA
	oNeRN9oBBOZk9fmSOQUZVPOjYwsoFc0gIGNPGHOtGv3c=
X-Google-Smtp-Source: AGHT+IGmVT66KBSfLvPQK9nzVA+D0DZUugt+eK3Rg1hWCy4BpG3PYkKdpMEDbRLD16rmnqHpCC5sQg==
X-Received: by 2002:a17:90b:1d8e:b0:313:5d2f:54f8 with SMTP id 98e67ed59e1d1-320fbf43174mr943622a91.33.1754004007287;
        Thu, 31 Jul 2025 16:20:07 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:20:06 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:26 -0700
Subject: [PATCH v19 16/27] riscv: signal: abstract header saving for
 setup_sigcontext
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-16-09b468d7beab@rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
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
X-Rspamd-Queue-Id: A14261C000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: yg95tnrianfuc6zzi8qbify9nbd3dxe9
X-HE-Tag: 1754004008-546458
X-HE-Meta: U2FsdGVkX19f79+omGtJi46krVv/vGdbFqDw+eRePhNBa+R2iOP4Am+VUgpTxbFcWm5YsvJsXXllZ0sd5MX4Jt4jfm5yT/VxNHjRTZmQCBZi1hbksq1X6npN2Shdw5IsUByfCiA0DSYeoboGwZncgguB8HPA7QbTSCRHJ3xdanMhR+zBd34xUcC2/R3zc6dXtzBKgKQ+TSVuhjFjTeEkS58ibo5wSyoxF5AKH6Gt5eczwnhNOkGweNn+gjXMkxiBkGmSV0+s3oGBGoRSb0QPlPtThi/xz+wi2OeoNwZL4eSKMDD94B+YLa1cKqaN5+q4sGI2hFs9zG/b+pjG+lwVYBiR96fCkXP5ez0IKjzToJt6NKAVpFPc8delI4wrEL2juzDmE6dnN4NfoLpJfQRx+F891ozZYlTnfexZ1mRx4DxetGkRIMMb2t5TNODRpfPm8G5lu5aKeN6JDyxn7Pe056caJQ5v4phEvb6innqKkY2wmeLhX6Tm6AubsRmYKgpWxoISq17yCTnpM2cxve6D3EU88hu8wRXt73eotWACRu5Kl3X5jWAcu3FlHF3C9Kd5Np3CYB23mGJiMRFbqcMVspRefjiVCuOEBFEQKoQEEktJs/qSTLsUzckYg4NI0PI/ITz5xFiD2Vjdgn5x+1ijE7wi/PoU1k8wNaIuOELJytx9jhkz8c7+sjKPt4lZhfroaVkdofjOjvCAIoPJ3ZjJhD9ow8Yz5V36XA4eyIKXy171MIsilwWkqA+CwnmbzITveI93nIj9XwgaUjikaQ6vJibjvltYzFGmhSaWlKaIaFgnRmkZ5AYHNIgzBGDiXB5MJI+EiH5l8mcmv/KiA8aCGtSBlnPB5B1LAKI4HMfWvZm+F8dpjQ2s3D/suyL2vnf0JcgfCLdZT0INL7S1LY1jm6aYKsIFInJhkrZNiqwouHs0dgMjmL85ipd0U1PlZpe/2Fun3Xuv+H3LwDBCrkw
 0OV2Dao1
 7e9VLz4E1UgSgaZO4EM1CIWXmakmWnUf0wf2YFt8F0OK10dolctlrZN5We/DezKEUfbDFVCp0JowRnyyYUdCPaPwwjBi+zFrd0yZWCzS22Lf5YHr9M/b6WSRYd378EH5D6vJOap2aIKu5zEDLRzYPgERoCcyzZjl6nbOeUOHXqcMnOU2BTeV8bNmrp1mzkfd6FmYW+ibfN2tv7DldO3dFesxQYajeGXKKTf151sSbJ/buEA4oEZFILLEBLVLejq3pUuOOd9EtjEr56hs+2DRX1HYocd8H8BF/YsITuw/UxRzAk86KfaSE4M/KdyXcR58fJyiw2Qojc4tt/ApCEzwX0dENE5K2lQ0lu70m37PUKf93AR5BTktDcoQDM+n2niVMc3fbc4eXet3i6pg21l+m7OLk0IremkDUU8+uyZlW7HK17ad8R4a+dYwE63SgTYf3J62oZ8D3Ao36O2M1Gsi0itbXV9sAXfGFU5e/3+hpKvknu3QCXFobDxJFAexqxqUJVk95
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
index 45c9b426fcc5..f93b849593c3 100644
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


