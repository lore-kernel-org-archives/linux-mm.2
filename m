Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52DA1CCD19E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 467828E0073; Wed, 15 Oct 2025 14:14:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0E98E006F; Wed, 15 Oct 2025 14:14:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 291C78E0073; Wed, 15 Oct 2025 14:14:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5F28E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1555119124
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:23 +0000 (UTC)
X-FDA: 84001148406.01.8C7187B
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id BA1D040009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=f6dsGfm2;
	spf=pass (imf07.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z7mqmvp4qHGKQdbAY5xXRef4U1rroaCrQF5ZBjvUPr8=;
	b=jSExTFe7ZqKlb2NJ2x7T23Emo2drpIgHcqxRg8s/BGM0egiQNqmzKLgg8yLh0/IAgJvAre
	cVKyv+E0h2PmfQlZIddHBf1W9EK+Ww/rXEyWyRK4YYbbNTgjWkF7u9xZOHbpDJ4E9+OME6
	vU+ZrfVF2bc6E0vJqpRmd6vKPQ63sts=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=f6dsGfm2;
	spf=pass (imf07.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552061; a=rsa-sha256;
	cv=none;
	b=ayFIce2xnq/ovCKHW8xJUR5G6WIkTJPgNCQubg0qpz7RlNvoA5tYONrTdLldfLiUETv1fP
	5q6eX2/u3FGL++WewL90b8SNbuVJ6NEGV2elcdr8hKoR+KKoBL2xCSSUyHOUtxw7OfQejT
	h3g4XWN4RWWwg3m0AF+W1ue/Eng5dDA=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b67684e2904so4207906a12.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552060; x=1761156860; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z7mqmvp4qHGKQdbAY5xXRef4U1rroaCrQF5ZBjvUPr8=;
        b=f6dsGfm2vTYCJUvfBF6bMy/Cqsq7f0UGCwWvg0Fj4HgZDHbjpHw5SUbi1kT/IZCW6R
         bsYRi805e2FOphYAISnUWPByPErrKRbwDpKGKEFqABBbEX6Mrwf54yXD00qAQYbSQDYo
         vPej5hm/8R9bvhAOdbzNpZtwKdKupqhwbpa2UGGuYWBR8+g3X0CqVwmC+eTk3Zoku7Nb
         OzzKE5s5FdMrW9sClRNdpVTKhqyvHn6icAw6uUigxEINLCP7JHee0Ef9g3QqGr5jU6TR
         jdfCGv77VcDOGQ7HMQTpQ0B+fNhMF5D8xHZOM/fovfQmkFwq1f6L5rKIQg7YlMCXLLl2
         HE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552060; x=1761156860;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z7mqmvp4qHGKQdbAY5xXRef4U1rroaCrQF5ZBjvUPr8=;
        b=Qx2KjG7inVDgQqeXAtp+fwyaYRVptboiBJpyKzyuceHyVpteHoNNyOTzcGo5oBTrhQ
         twYnN1xuPJZcSjcKMnFi9mjP+waAhe89+grGN6RU9wM8Xgtg8yMnJVkMWfQ4mphk0kRl
         e5qpc+iYTJ+Q9wvLwftA9XOaXvyydzChxOnOTpNRDgZ2bPj+hH5X2igcRkHn0XrEQYRl
         MV0vQ/1EUkAYOCwCtUU4uC4LXdnNAv05a+5/xEqkfKIPlgLryDbMPcXN+yArcjqNLJIJ
         qywtUsoSPwxxkerA5KIHQNkWajRitoQ76IeNlPfB+Wjr0C3mITBjXqTKflMDFzP/GgJM
         oZfg==
X-Forwarded-Encrypted: i=1; AJvYcCXfQpwjnjiS12z/r5ftB43dKgBzDGO7dzkdoiLcoCKR1WdxxLzfiDmnCW98SreeObw8YGQkjzfxEA==@kvack.org
X-Gm-Message-State: AOJu0YzDlxIhdjzVkqYsL9XDTDjYK4SDq6Zd4UPaQZgtYFxBPK1bck+2
	HL1oH+3pYo90NDWfjahx93Au4B66b85q67FWFEKy6WpYz8hwoI+G7yKMypds2orKSv8zKchvbpv
	Seg1s
X-Gm-Gg: ASbGnctRpGjPgPZ0ZS75ljk17PcOkyXtwEHVlo6QI51RWQ/1WfS7oF4vfDA5QnJZ7/S
	TpIUL/QNvr0yalS307I1KcJcFy2N6LgQeo29HlqbgRpQkmQvz3E6DZFdqFvLOtlEMZoDdjrLRm8
	VWoEfK90lroykk8Qnoupnj5yXdFTg7bahcPknqCujSpo/gWayEJndVq44GjQGE4GktbwD4dv29i
	RHqd3PoPqBZ15M2DgHVoUu+ScHEBWj00pybEpNlk0vtSIOabIihmjmJUJMpDW9v19wv1rMBaxZj
	9cHIWUeihO/N/HLVAKrP+/8BjL+rE5M8KByRVdBk3P7fo2RNLqUFHLp/C7TijvokT3ADoGDGSjz
	d9a1WTqJzXmT0R2eQ3unbpy8n+sflfxSeU+BQ/3gOVdc245kYS2y5tSpympwGrg==
X-Google-Smtp-Source: AGHT+IGYHawen/DIH/6zDXsEucLMJ4nT2ZH73QD1ilWz2b4sp/DIn4gSAkeANmmS7z8UPAcMNV4bZg==
X-Received: by 2002:a17:902:da8e:b0:26a:589b:cf11 with SMTP id d9443c01a7336-29027402d24mr426479065ad.43.1760552060287;
        Wed, 15 Oct 2025 11:14:20 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:19 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:48 -0700
Subject: [PATCH v21 16/28] riscv: signal: abstract header saving for
 setup_sigcontext
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-16-6a07856e90e7@rivosinc.com>
References: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
In-Reply-To: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
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
X-Rspamd-Queue-Id: BA1D040009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: o7xrn8guh8b7xet9emptqrnhzie3dg9z
X-HE-Tag: 1760552061-324064
X-HE-Meta: U2FsdGVkX1/Jatd0L0fbOB/DBhMDRE7mg22ZtnJqZsttiMrSZs+FdcQaR7p5X0/J1upORoG6Ls5gCCCv4EkXsmcLkqlxivEUNgWOc7N4mohNLbML+112cGOS9may7xDsEvQOX8xQ5iMaBOwcCEmnFEjGjtnsI6J7FpRSV22zqQMKupJ+ywpsqJsD2zYaPKYKYIFW1eLtIDqd4g2yAj3LQaiJvxlwN4Vka50bbMuALx37sde8sNnWhBEhponWJrCvYOLF1lYVMsthMIlTGEav2n7cHDoe0lviYhUvrkTB9m92rxSfOtSXFz9Korfyt0727iDhRLogIiICtav1I5OMp20TxFPqYXBg+Og1s+8mDpLBeEjO0L1BCeNZU1iukZXTY0mQmH0krmdvzIH+p0B/68BJ8Ubv/H0WD5Ul46oHSr6HOsGjWBxOZortUN/peQ6gzRN/qiCbhU+eAS+o6PBQx+ceapir8BjVTOgf4R8Kv7N6+r4/vE9RtfoptOw5BupMjXni5d3i/P70F9vtyFzOajeYofnYnJhC+X/CJJog+1jaMf59uF/Me+E8Xc6iiNceMaevBDyamMAzfiYpdYE1uym5HmG2HMLpmLU8mUT3ku0oMVtXhptwjKZXynqfjGGBZndinDLp94HrRBBRp0RjdH/MrZhiq6D39NGaPXF0BI1Ss2zC5TNVNfXrx8UPThu9FcdyCkgWlkQhnibo7wWkhEosS2TVVJqU/WIk4q3ZeoggBQS4ufPqVFz07AmktPKUcDsk2MLep1k0O5+8YSPwqa7ng5LFrUMcIfzNVS+ULiDxBCVoHgi6/gUz5ZkfEGMLMWQKFbIJW8VNyfQ8LMlCaf31uZjndD523defJfs1ZFnyW3BdZMinV3wqY9Lk3bC0HqaRhPQLBURLkkRKi99aJQ0r2s/aPXJCFxI84aOozkv2ZFM0qT9q76cgnVWvcU/0CBt0ynubIg8tRMQ9B3b
 ry4WbJQ+
 +xboDvJN9hPcPGM6X8McAgGhWsbrnS8LeCQGbqjbP01Ktxa6exvm2wM/G/m8fJB4ug91UJ00K1GiKr8ps08jwJ6dxhjz7zHxuRfifh8ctWIiKLrCttUoLGcy8ApunC7pq9FS5xmsQo7Ctj9WI1/SASVKLPgnJzDBcbDPNRH3MP/QVenyF5sSyyp54pk8Cc5VsECzvKCVr7vkoeFbcCgo09QiFlqAInly8UnBSUayAVLcB3TCXbfgJlnp8nKPfc/rlKIPzsqU5ls7m2vD3p1I+oEY+qhUSADQSkX8jIC2OjM+WETZEHxwx/OaIRU0OHh2dcJhkMG33FSs3f4H8TqLGPTlAeIutW/9V74ojQC5KODTbsKT05GXZtE2coWkQRLvB3WMF12Hrozlvto43iac7NeiQIsPia1gBEJDBFb0nhj5HcFTSCYZBRo1CtQ==
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


