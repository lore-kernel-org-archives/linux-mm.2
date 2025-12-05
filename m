Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ADB1D339B2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFA006B0029; Fri,  5 Dec 2025 13:37:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5D066B002A; Fri,  5 Dec 2025 13:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B936B002B; Fri,  5 Dec 2025 13:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C399D6B0029
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:24 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C17E580DE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:24 +0000 (UTC)
X-FDA: 84186275208.05.0078E07
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 674A11C0018
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=SNYArNbr;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0tPpl0ov/HCTJv0Ge+5WTQ7N6IiaqvTdbW7E3j8kAg=;
	b=C+uKfcAouqTubVFgI/NTz3tZ8gSbPBkTNaI/E8/DwXMHY82JSNVIFHU5+4xU8Iaio0AfrA
	XqrwRiBjVIqq5T/9TYdtr9tHde1PR82IBQ1c+f8/J7H/VBKFTvyxfAKoWgRYHz2YKJtbfo
	x6wsB08DlrbpcY7wBRbiaM0W+kf3htc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=SNYArNbr;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959842; a=rsa-sha256;
	cv=none;
	b=8E1P1GnijOV1P42PeaSGMDPMSKO43rqOa90hhbbH946QZJJFIZlz/bIQitRY2TeH/18S6z
	utn2Elw+a/1ZubirXtK1tVcomJlQFAg8kNVFdO3KOzATN3T3K5ICE8nTSKXnzqkJbjY5IW
	L5Gvi3iDvq3Q+40U3N8yHKtplyDZ8hc=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-bc29d64b39dso1466171a12.3
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959841; x=1765564641; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d0tPpl0ov/HCTJv0Ge+5WTQ7N6IiaqvTdbW7E3j8kAg=;
        b=SNYArNbrKanqWJvPT5tJqCaEnjuTdeBsx+0zW0IStOtxnQAwJAlqYmCp+YAhZD9wLG
         1nkx52WzAIeBB/lesnoAqNCiEsHvZAMb3F0+0eFiPqsXGFen6OE+R1i8Mu+4Ed80zKK0
         qYRwdD3883Sj4aXFlRO/O9eXodm0VdBeLhMT2O8EVI3QugHWHUq5pnXrsqTaTXp/dxRM
         4sQ0hBrjQACcd56qGp3SuHmkn4Q7u6zsWj9q9KI4359r0B+tgChWvjJEqDzksgh56/AP
         yPBhecjhMNU2pyqbrJTc7mm2ZKRoQBpyyofAGucJ4AZsKyZ4Y08ds2SQ6+ecDJGbC5Og
         jHkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959841; x=1765564641;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d0tPpl0ov/HCTJv0Ge+5WTQ7N6IiaqvTdbW7E3j8kAg=;
        b=Yj0kc4IG4iNYeAQnECAk+UpOzvW2ADW1hiL99YdEc5a0Sshh4ZujhikoirZBlwkCHZ
         OQnDXWzbKqDOQc2kYo39zvPf/vWScnG58J0dW0zjFlqzCOcebv+tXOZaTxRWsHPRuVg/
         VihbEro/IPPkXTvABXys9DKP0Z4MgZ5ki249AFyukGYOzOy63kNnDenvdrwf1wKezEBv
         C6FPOvky7t53O+E4zIEozEwYndebbklZX8qtjYEN32SPVDOIMVCwpjtkQBgBJIUGBYnM
         TcylAG+K6kqkIVhnWR2RHB+caAlZbPJ05UdhJGxLb2TE0OPsGU6MbljTZX1RqEVyuGXv
         Ebng==
X-Forwarded-Encrypted: i=1; AJvYcCUVk5GBeBeZNp9iTrAcYD48ClHWdyMxjb3UzmZZCMcRKVnqTynrg93MH2WIIM9cTxWnUbQuKcFJ0w==@kvack.org
X-Gm-Message-State: AOJu0YxeLhk/a8MtHRstBiVq5nzpAbAjAM+vvQEIsOnpBeKPbMSa7zYq
	ITpUQSbx7yxbbz8Abfmx6vNHztWm5QlmVZFKn7DpABwzNjotDK+tanaxUXRgsW3I5YE=
X-Gm-Gg: ASbGncuj3IDgY0fmvoWnnYxwtH/45icYObVEXMpYR5zGhwoZRYFx2tdH8MsPsuQlrys
	bHLw8D+Ymnuiv8Fb1tHeH6WZDoJzEM/vSaTfPP313mayBRjO3ABsD/y5OeXq+Ys0UtOhrsL5T6K
	1CLRvz9cumhqBOktY9eRIRc3QjCKp3UmID0DyHOY4cCO7gBgsxx9lQYi/o979c6sLkPERzwFMQo
	Y+xbRVADY3lZ30lydQKGjdGRJRU00FIPq6eR88h+L7FxG8GcoGB5Az/OSeI+eBPbPepCtzUWiaC
	+KiVTCUimOkX9DmMaUNIjkdyetjX0kKd7qrBlSy0lPmsI9OH0V75PMopcdfTQ2hgN2kWpL8w3SO
	PU2KMalO70mfXb+2ASjmPzAG/c09ywEy6aP6xqmOuyYtJJPf5oyx6qJBnF/Y3+3b/1yIJwrHQpJ
	WREIvZBrqvCefhNV1RsRlHu32VnvN8qmA=
X-Google-Smtp-Source: AGHT+IGlwU45flmYdaT7CFBd/e0XI0MWINYKO4zgsDKiDfv7EpCABBJOvQmSNH1o68fdzHRtZXasQQ==
X-Received: by 2002:a05:7300:fa06:b0:2ab:9bfa:c4c5 with SMTP id 5a478bee46e88-2abc71c6177mr91891eec.19.1764959841145;
        Fri, 05 Dec 2025 10:37:21 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:20 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:37:02 -0800
Subject: [PATCH v25 16/28] riscv: signal: abstract header saving for
 setup_sigcontext
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-16-8a3570c3e145@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=5649;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=2GiS+EndHJhzHiRyV/zPGID65gK9NoTUr/4b8/a/2Lk=;
 b=qFTTRMr3TiGP0bwPKTHpBoSxRJuw9HPDs0CweiJq/PRiW/xKFLLVo37REZ6q0wkI7yYpI7xZP
 mdx3S22FRhmCDgEcyiR6czKwJt71g1vkT18zSCKHm9CcmmWUfvO94+0
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Stat-Signature: 875i11utzwsfw1rb5fsz1rouwwxzrquu
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 674A11C0018
X-HE-Tag: 1764959842-773118
X-HE-Meta: U2FsdGVkX19hk69Y7iWsdnN7q+/wU1Z2VnaPAH8M2e3Fxo2K4hejgqup/Jiy54gfMZC50mc5fAPTVfHPbkY4CmxLRekjHDqugtfqAW10CVSF166Lm32zUXVs70s+EYvxRmZiRoVbfdhIIfcNVNxHlNBT9AvVtEH4hs2mq7pavRhzufssLmSVecH6oVQu1IpdkLGWq21S0IC7DTqIixonCNOVhIn1L8oycDoxODBSEs/3bhE4NDJSnpuh8BEEAmOod2PauTexEzn41UW0+Ft57HH8AecPl0nZSsQxbvkGIkpFsal/0UrIOnpfPLvLQvVkxqyWwFxkCrlee7EIeTp+RBtNCJ9E0DS1YvxweRyEnkDyabMpWz1s2fV9rHETNtbQl2O1yzRUdRoF2XmeTH9NpbRjT6wEY/4UhbrzTiKzpgVuaKzPlmX53BydSVsg4Ihu+z8pHh9TgU74cQdOe59FdEEttBjYdX+ON5QVWu6aV8VBkGTqMcOuf3IxifoPG60dzlV3ppuOawXkVqsU0/zB5Ya2fTbWdLUWRalNmwQfTmbuCpG3mdcM2mmVPCp82s4vJH6xwYj2vs8qPMyueOthRwaaGuxycWXoCRJy/Jq7LWjP9llxGGWkoVmxfIZMBpxVdDhhEOYjgkecZ5DGTnVCSipFjlbeoqUNhccDJm8H2wYgLyTmJ99ogj6uZSckyf+KKugp03dXKqo6QrCI5xbWkFry0CLEESwYaaAk9hJs2G7Wrb1TI6iPcesbAPB8qWZrx2pFJ4oUw4FyamZuG6pPqEh/9+ixD6V2abdtJoElqQbCzkbD1oj9weGiY4Hlvtzr9IUhrLo2Kcv5ER4iOXZoCdk/7KyOHnxmIQ9526MnjDlFbi8ejuGykzeixbnX4EpN3mhW6T+hkRsSg8HZrEZ53kLod1eHYVpq4+ZBPVfwh8T+k4tHDLeJSYdE/eRudaCnXpvEbCbx5b1PzrxZpj0
 exlZNTuK
 D1XEDF7kMY+ahtYksvJ6Kb1/Ibg1tlb0dlcdqjkkoqr6fvSsXFckkEX6Q06sGEqG3PbHYiI0a1kyY68te6JzdBNBRncoakO21L3+Lj+b1zzU/QSdzMFjzPynASFiJKHhuXBEm1J0GkFU4HdcNVywbqdQC9rflNKqNr+V1Y6dX/SZPnBEoni2jtVgGdcbkaxNpq7YgrBl7yDGuGy0cDW/gfVRaqQK62ZZ3CRnjSmO1OkKgkiv+BEoMU6iTBtvKqjY6KqvzmRTZx4YKOGyd4zxUxM0sYAuxdKh42nxfHAzFNlJkMF8IwqOWKAgnRwYKOrhXKzjszTLac5IFaHWFtNqI0eAxkgP7uE5atpYW3KVKrtCGkBVj4e1fK7IejEKZf/hrp17Bn/VTzjt1Uu9bAoofnuJxpZ578SUZSEV2xSYTcxYfHjOuutpQGBK8n5+Y4If1ehXBxGw/TQWMqGZ+1y5tPF15ed2wHmEEhTwezydKGoHR2nU=
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


