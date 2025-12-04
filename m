Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E3AD29FB2
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93C1D6B00D2; Thu,  4 Dec 2025 15:04:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C41A6B00D3; Thu,  4 Dec 2025 15:04:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78BCC6B00D4; Thu,  4 Dec 2025 15:04:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62CFF6B00D2
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 31F36132CE1
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:34 +0000 (UTC)
X-FDA: 84182866068.25.E96CEF4
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 116A910000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=D8+xNe4r;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878672; a=rsa-sha256;
	cv=none;
	b=HphcfO1TKu2JznIhfoJNzp3BKsYD3gJ7VHYsDLiikZdhMdU7UEjTSgQbONA9oUJcjk7fH6
	B16BxB52WEXYvDWTQ+1hURNnaJG6iiYvFuDDFazlJrsSeCPJoPouCVOdyABDdDXW4sS6Ry
	WUxr1dGfQM4hRiRlHQGAz1ZohXvPOas=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=D8+xNe4r;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0tPpl0ov/HCTJv0Ge+5WTQ7N6IiaqvTdbW7E3j8kAg=;
	b=iPFS9gwjZT6xWsMd5L7uGlKOExwdt6bNM5porhNjnR2n+rPyN9fB/uKg1alKm+vJ6kppCQ
	jizZwTbIxbfbUHqJ9hts9zkFhIUbQgDDKei/Ktccc5w7WpBkh1s2ntCaHgIvgjTPla0ZHr
	vRl+pAq7txbuymsAJ3JXXOUSV3OjfgQ=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7bb710d1d1dso2108458b3a.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878671; x=1765483471; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d0tPpl0ov/HCTJv0Ge+5WTQ7N6IiaqvTdbW7E3j8kAg=;
        b=D8+xNe4r08o6BO+PqoJGF3+5yAID1iRVUMF6NcNLXiZndtwhjkBqBPOwlaj0TyoWqp
         5x1p3fOHxoohvuiK90YRLxK6kx27c5kIUqSrqT6JUSPO7ZkDboAel5p7xZSZp287n1E8
         lvvB0CYkS+FrFdhvcSZqnQ+guAK7Fca1Nv5iU/T1JTUdRPyfTrX8HNXI+ZkrNFBjEZRo
         W+c9g5e69yBBC1Atg1d1jjrBHuSOdclZOZrBuNZ5gP29Z6Pv5vZGDxbcK8BS9bcoAMHq
         mRXe0OqZ06fzvoaYCpv8XarSrf5kBG95xvyOfW3MQ9qRfb4J7x/WZGxIkaVHLKIsjeTq
         1veQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878671; x=1765483471;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d0tPpl0ov/HCTJv0Ge+5WTQ7N6IiaqvTdbW7E3j8kAg=;
        b=sBiVbsH9f8d4TMqpRUeSUQ+Pu3GKo3HA5HlGqeJYxFcs0+152VrJ7TGkxKZPUtP9+v
         TTV+icqv6I9URVKPZfqI+jw3opdCm4Qa2XEVOZz9PGcWskdDVYjylFkkGXEXIFniRfbi
         azojhl0qe3ZHugKCg0DxI4m6k6siwGlthlPAgdGxPueRow4IqMcR9I4gJR30SeJgEfLH
         5bDoacw7/aeOGA78Qd6qKwr/SoPqnPuK5vE3bIOQBPLHqzvYReP/Q8FcvS+PuZwA5oRi
         QDRCuYxyHhvXPGw+QOy5CBdRHnVcVQCNNxNKl7IHBM0LnMkkMsBumu0/tm1Mgb0NfUeQ
         aScg==
X-Forwarded-Encrypted: i=1; AJvYcCVPyOq60lkdj0sbtq+FAmcnf+pEPKSq7M0Ui8KfXW+TNx0NC/SANkx6tkAyJUA+4qhu46XCNjdCBg==@kvack.org
X-Gm-Message-State: AOJu0YxKWreLfy5H43BT82FXEIdmJCfWAo7xJg27rnvBlXDXmjIARwIJ
	Urk/b7j9Ay1+NUqk8jzI3yvoY5hthWrA2mSc0idpukuKbRvyxWUKKeFmU+UN/V55uQk=
X-Gm-Gg: ASbGncvX7symAoQiD0DpUiLI5g0lkUeLO+B6HwULisGDwSnMh6u7dLwGSzNIP+x4fP/
	fuE2zfEfphxSXPbMuwLSL35ZDZiU5PtigvXPf/y8ZL7anlQj9I2jsTJ0RkIB2ef+4ISVFbniQlA
	1mQjlJYV+liXuIcDQDlZHrHHj7zJ83RRx+S3227i0eZDljwVQSybmrLdxNfIDug4hWlrO7c/hVD
	KnQ6C4xjhWAjYv61pCPLWrLPg0675H57Xgp13J+OVDJUF8k+Z/+NxD4d7ddHNvQQZVWysGXkJON
	5laSIB3RpGRZWg/JK7H7dO6vFXIZpVGxRHEiTCMikmlWU9XMxRKO46bdMNPqES8FjGNr8xIm8C5
	N09F9TJcqFBW9Fyri5PUMdzpAUcaKegs7tubmnlUewDm+9JeLMw2Uy63cFT6TvsrfgTq3wC0dGt
	Dp7JpNzXkAWtp5GsVWW7Is
X-Google-Smtp-Source: AGHT+IGYUAVyalha3DLCrgrEPs5rLvzNFvk3nI5Aa+DT+FlOsHmPX8AdFrLCKv9/3Bv4xt+45vECow==
X-Received: by 2002:a05:7022:ea46:10b0:11c:b3ad:1fe1 with SMTP id a92af1059eb24-11df64692famr2937600c88.11.1764878670821;
        Thu, 04 Dec 2025 12:04:30 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:30 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:05 -0800
Subject: [PATCH v24 16/28] riscv: signal: abstract header saving for
 setup_sigcontext
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-16-ada7a3ba14dc@rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
In-Reply-To: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878636; l=5649;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=2GiS+EndHJhzHiRyV/zPGID65gK9NoTUr/4b8/a/2Lk=;
 b=O5Fyex7rxQiwIH8Ny78pEWBq1GeBuNK6gjFgZaeXDSTejVDF3UQjdkUACDVMh0zIccddOhzzW
 FZC5NwBd5zLALUM6wq4k/C8X+GqiL6vg8wrmT7gvLqjhJ9+m6iW+sy9
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 116A910000E
X-Stat-Signature: zj4ib6p3qfiosmr7t64jjn4tbc3as5wa
X-Rspam-User: 
X-HE-Tag: 1764878671-583491
X-HE-Meta: U2FsdGVkX1+7IKCKlVGX8XPbCa/TzSYVzZeJh5jo8k8YPdieWaVEDK3X171LqnrvymF60c9UHjVQ9Dx5CoCBpqKE4BnErAwde5ImgLLKzb6FwEaEzJgM8j9dZhqqtqRk9R+1SnhKanOOHIOCziynz3aVpRc2xyEQCevFiRPKTW9bec+/e2PeV3tc35m6RzjH6vk/+3o923Sa1ZrsSGKeltZW7rQkkhJDnliMTXax970jktVeNRIB4AqCzWhwI7nimGGjx6Q6cOZpZyrp39VsfwY5YvlmJvQPne5LNNw8BGrL0tU7u/lzmjVVtYmPt3js2eYSm2GU7nob7XnXBC0hWNz+x8Lgwd6b2kWsJ7GAcDkNkgMJeosGqy635ertinobxdI2Bp8AaiGJ9EgA6LUBErjzEZkuENuJDbhBJhNenlJxd+lmxZwxcrV5yhFz0kKd7cyJiswPkODwLsMI2pcqNUVR5AXqAz0z1GPUFTcTRZ7kr8tuqjQaiPQh9n82v02g0F6OkVGEbuI31ABZDoZzMJTENjqThVniMH1Kt+hDZ7UisqrN4WT9v3S1Dxdf94Hm+FDFygknmIiKy5Co6kQNDFu+1FUPtSCzYhc0YQS5Fwmk7iiK8i/X3NazzjY8hrUZzppr7kXQY33a57dZ9MbF34fHsZip5b9AEBnms2K7nIrJ92LHYWF/T/dY5+rFFRkix5EE6Zf7yPXzdbEFgWZpPFDQLtAkJCHe7HYBAciElQm8vo8sZ4qoqo9z179Lf9BqRffPuTLIZ76sQjWhsb7fEurEdWOT0t0b5TRd0RvbWPCAhonkwmg9JJFW5R99HtHlPB5/DpT6Atc77s9RsIbSpOEPAAheI3nmzFVUzxM2llqziDbwp+Jc4Crx/VZQIGWsr5nBgo42bPR7ztOOS1wYGtAhvV5umcaGcozCJ6ekykLF7N56jxen6oPNTWmW/tp0nrl7aqw/l0GYEpHPH7W
 uV2lzb4f
 DJa97yiUGu7i61GouGOUj29oeWmjmXRib8Z1++CuP9v3PFOTpmPVSVReRv0y0PKWw4XqGlEcrpesY4Q7pJFq4TLNjtaUZerQmeHCdKzix/6S0TZo+zusOBV99rkhD4W6xsGHWYVy5HigBprNvJjNxi090+Q+7OJPQUH2As9jhdwCWEdw6F+3x4xt2zFJGpPjjoFdXfoKLDROE/NyelAsXOxl/fk9LG6lWhA5glArl1sCok5b/pDI9/+vuuY4XDxPp6Op8tKS/G+5ppy/PGoitnUs0vW5NYVU7AfscUKHQzHoGbOwaXnvFVyPneACqu91wb3sJD1W9vmU3CKYtdEsV17p60h5NUSHmKcmZwp7lQBiR6Ua7fRAlaaq1IeLGpeWpZIEjj4tsQiND/fUDyMO0tvXuSGlg5wg+vKvKDlRJ2hOFOFzjqrPvnmKjwsHtyTFIZ5ug8eepT6lsoOc2IXaFUC7hTJoCJ51BtHZFGbnGGkhg4o8=
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
2.45.0


