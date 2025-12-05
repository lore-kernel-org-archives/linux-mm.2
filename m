Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995E2D339B2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81DE56B026F; Fri,  5 Dec 2025 13:37:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2FF6B026E; Fri,  5 Dec 2025 13:37:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA586B026E; Fri,  5 Dec 2025 13:37:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5079E6B026E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B25D5803F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:34 +0000 (UTC)
X-FDA: 84186275628.11.54DC2DE
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id E863A100005
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=WnuF1Hcn;
	spf=pass (imf05.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mBQdVJcI43GOmFo6ZJhh3xrAwK5rYOL/dPt9oIjyNSI=;
	b=fGsOMCzuOwEQ4Wr7Tk0mOVjw1RS6tj0dInQnYUKDvzu43uAR0965zdlScKY/eKaQ9St5rR
	YRhQGMd/l1wQ9HR8ig6eQaH+QS09FGFtAd/yXIydRQoYkOFC/I1KkXKT4SVm5pjmGAHs7d
	qJc8LxRa6yTxPzm3vPAZqI3vOoL2LSs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959852; a=rsa-sha256;
	cv=none;
	b=VSXG4M8OZla3lU6a/I/NENo6MyPzBzTUNI++Vh6d8fpupPsQDGpEzK4J3/kWOB5zELPBRW
	xbQbcMKVJaLgRvWrydsqYl4pj0AC8mH8fAgsasxc3PRVhzt+rx+dYpLY1SzWSynyJVghOE
	BI00+9g1iekb0Cixlg2ijmQozHRiSEk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=WnuF1Hcn;
	spf=pass (imf05.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-bc09b3d3b06so1401512a12.2
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959851; x=1765564651; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mBQdVJcI43GOmFo6ZJhh3xrAwK5rYOL/dPt9oIjyNSI=;
        b=WnuF1Hcnh+KRtPBAQEhWDrrTkQ6Z7I7R2wyj1vOKvYpAqcMzv8Q+agqkOcllXgg8T/
         +FnL8bwKmeuzv27AzIq4+Gwx+ZoD+rvBKXtklaTUSCRc/w1ICJI8cedyFtU/NkIF9pri
         iYlV8WZSaNq3Qk6KP2wUVrCv/XL3wzGQ8QB9VBKI7WE1Wtkk51AGqaNOKjZjfAHyyvF/
         5dQIeC2spGwxt9HVFnm2vC2l4ynHEmOGDyK2aCalDAbpKqb1/T8Rn0pVIQh9aPoMXfUD
         gJ135B4Mpn/2myRbSCIff/SVuPhVknczdg7IuFYuY+RfAX7nyAz3oKsgsadoVQOCI3P0
         XaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959851; x=1765564651;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mBQdVJcI43GOmFo6ZJhh3xrAwK5rYOL/dPt9oIjyNSI=;
        b=KJ4XaHEd+g2JyPKTimNqW+Mr3UGXJbGkyF+vyT2JVl+ZP1VzVFj5sWHWTncHjbi7o2
         hDZ4Z1Gv3ULe+/6fiH4lGnDzZdkLrTxk9fbIRtTN7cOovy8w+4ga595qiv5XOdXaQygl
         Yx9X2Su3lziF0QdGAdgUnpzhmpueERCZM5pk3L5zpAGnHPmnPr/4b9/F1CqJ06yXqjYT
         mNVBghW+aig4eQQRuBf0sJt10CgMB3XGK1R8Wft+zQ087U7viXvcqT5YqI/BfLKiMAV0
         mhffh6lPe0SG7jEPhZQRjx/Ifz9vPG+BHPP/3FxVbWJW7duYgDKK5UzHeEYJVAJDxFp7
         Hm8w==
X-Forwarded-Encrypted: i=1; AJvYcCUYiME7WYLZcGQZkv8RbxJJDwCRqdHEr/s8BMpfRnJTfJIg79y+Xm+vhnDgcuC+jK33WvO43dwCSQ==@kvack.org
X-Gm-Message-State: AOJu0YzJzJ1IK66aGieHX1HP/m3l0Q3vxbkv8kqv1jlFxYd1SbyyOrvm
	wv8Cykz1xGvYCgH/EEZKbjtkxonVJ+whIL+YJjhCesS2+p2KIjLlTsxjJ5lp+Hrq9bQ=
X-Gm-Gg: ASbGncvBa/oOTRce1/t6VZoeQuY/MnmQx0jVN72W3ehbbfOiIqmuismeyrg/luO1IKe
	H8JPehl7O1T965ArAtvMs6PC2X8GQv0aUD4vIqqleDreYtIsY0IfC8Hd98j6erBTb0CKLN/REcS
	uHUp/C1BGTqtyKMdxRIZ2HoSAoGNgyaVxmiC0s7BIfunMbV7NmkuE1CsvGlvITC81OKHmQnOeDf
	h5a4vvd9+1aTixt6a48QS62EmvPe0Yem0agHerCEgRL7xvUdpVetlLZIOXEkwNqfrSb/svd3um7
	dO7zVhT/tUTcQjtjfmPMrdz8vdnyWl90O/Aow0Ac73sjqtzseh19wAJE7HB0lyVV0+JQHPBEA2b
	kC06iwgZ1zrjieUcpcADNs7NCj78qJwxqIKM7Sud53tMA9MaF0yojCnWkZ+bgO+QGyPyJGyZp9Y
	781ryCccdOh7PfneQHGdAC
X-Google-Smtp-Source: AGHT+IGp7iqVIbgReIe349M57zcaAwAAqbXZ75PoD/aRxoEr7PBLcgs9PCnxDJDHIhkmKsY+feG43g==
X-Received: by 2002:a05:7301:da8b:b0:2a4:3593:4689 with SMTP id 5a478bee46e88-2abc725a729mr63051eec.37.1764959850655;
        Fri, 05 Dec 2025 10:37:30 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:30 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:37:07 -0800
Subject: [PATCH v25 21/28] riscv: kernel command line option to opt out of
 user cfi
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-21-8a3570c3e145@rivosinc.com>
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
 Paul Walmsley <pjw@kernel.org>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=8783;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=s7aGrFdVNwwtkxcsJPpFVS+aOTes7FH9SYpSNwarzgE=;
 b=m/Gqbo+50xmCBVFhWkamN3oTwOFuohPMg61Uh32kauHlEdUzHUvSIWPOUnhy6ADpZ0VjLaNrm
 a2t7DdOS17lA9NTo0Ck3sbSQSWIclrIDlQw3HlOH4vAtvLIUycoGCtx
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E863A100005
X-Stat-Signature: ppwjf7yqdujq8z314cqu5dz48kf3mn87
X-Rspam-User: 
X-HE-Tag: 1764959851-267503
X-HE-Meta: U2FsdGVkX1+aVXi78tCFBWuEqu7dmXu7qd7labcqA9rPVJucibbdo6XNaXNZU27XfLtg/Y43x7ExXSdnbK1f18aRdiSF4+WvrRcFhpRnYxmKOHT6riqbzZpzaoYwhNrR7kblMCjePIYF86c6W1xJxoQrRAfquux7qenGTtFXYEyUQjHXOMjs7NWQuEan+GHZAtqFHolo4iuJk+sjEtv8cGl+E7TZ0G0E97ins9MfsZFIb1vdlrrcalahjT7qSQ6oRe5zloP8syGRDCdjAbixSYq4KuGsOXI/tpbsN5SrC2wP5mCteNAo23quW3/EKecJgNM7G1MrtC0S3+QHdOd7wh/9Nwri9sBETAyC+57q2rNFOBFlIE1pll1ixauKZPiygWG9+mN+ohOSERz5UTTXI9cjg/B3chnExal8LtKtrNsUV5zAEx9izoUvQ4qNgFz1CBYGhWWpHJHVpIddwG9NHSqrarsyFfZJWRCiFOPf9nJSpqLEgtZu8kwad9X28t6waJa3xOq3TEIGX9D783lwwvOW57X1FAaSyVco3Bhms9zEPwNnwvrai0H6I7mZZfMLObxfskJhFCFwjYdQWEbzDX8GjFy1qoHNbS8g90bUBcOanxD+uSQP8WOK0QIWB1k/gM5WyYVcJRPexstFkN875GUwiQw2RcZv427EFffMfogok5mXUaGDF7+vqaEtyYTS4QFn5qL7djPXM1IiuAhtWU0p6jJeDTwWFll5odxZ+ClH4YuB9ylpIBKlMF2NvtcnoBvghHJ4IUcjJDTb0VCePcKbHY+/uw7+Q3A1rfTbnvXK5GMGrve5fIXSSy6R5AMOenpHkXYUNPIa+6e3b9fwlmPnY4hWl8ZKHSq39stUnC2ALm7cd2p2xRZO3pa+wagZ1TKzlDDa38F0aH+PG3WJOIK+NoRk2p2ebq5lx+7dzmcO041n6QzxmnOhaAPVhdrxRZSfoF4dVzhN5hsW0y3
 4gYOXl4G
 h6XgH6Sh5BPoQX5ORdNdyMShkBRjJ/mbDEjcz2E8wbK2ahc7s0nCLtvT1ENrjRlWsx1/Wlp3Yr5XfcT4uhS2AVcdBqjfumQ9XrGg/AjHsGcMb6hRMzyOfhFZ8k12rbVer9jyUoKrz5OCAr0hoA7PyXdJWqGsOjyAMvvofkZvnsMBDxdbSSg0IGhGU8hwCn80k8O4C/hIZuHusUAEG4Am+ialYn5akE/U/cqzGRiVC6ZxG3EajXOrtoG0DbQIrMzk5/MyyzA4pTQrUDy9pMs0XWxbaJIl35JaVH9xkNN1nZ1odztvzlsps1uC05GRq+nHwgekKF4WDYmg4jO3p6Q0QfUrloDFXcsvNIIIgZRI/ekHME3nOto2xniQkykRKUrmyCH7VzRvT/OEJfWs284gBs+kF5amwkWwMZ/4Xf86XdR65KzuUcZvZL/WsnIp7EYk8RstOkZ0MqLoNoqrjRYRyEhGqSUoO9CD9hQnqT04qSATRstoIMS/WFVwTYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit adds a kernel command line option to disable part or all of
user cfi. User backward cfi and forward cfi can be controlled
independently. Kernel command line parameter "riscv_nousercfi" can take
the following values:
 - "all" : Disable forward and backward cfi both.
 - "bcfi" : Disable backward cfi.
 - "fcfi" : Disable forward cfi

Signed-off-by: Paul Walmsley <pjw@kernel.org>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  8 ++++
 arch/riscv/include/asm/usercfi.h                |  9 ++++
 arch/riscv/kernel/cpufeature.c                  |  7 ++-
 arch/riscv/kernel/usercfi.c                     | 59 ++++++++++++++++++++-----
 4 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e..a72bf9fc6f06 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6453,6 +6453,14 @@
 			replacement properties are not found. See the Kconfig
 			entry for RISCV_ISA_FALLBACK.
 
+	riscv_nousercfi=
+		all	Disable user cfi ABI to userspace even if cpu extensions
+			are available.
+		bcfi	Disable user backward cfi ABI to userspace even if
+			shadow stack extension is available.
+		fcfi	Disable user forward cfi ABI to userspace even if landing
+			pad extension is available.
+
 	ro		[KNL] Mount root device read-only on boot
 
 	rodata=		[KNL,EARLY]
diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index ec4b8a53eb74..f7fa9d602aae 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -5,6 +5,10 @@
 #ifndef _ASM_RISCV_USERCFI_H
 #define _ASM_RISCV_USERCFI_H
 
+#define CMDLINE_DISABLE_RISCV_USERCFI_FCFI	1
+#define CMDLINE_DISABLE_RISCV_USERCFI_BCFI	2
+#define CMDLINE_DISABLE_RISCV_USERCFI		3
+
 #ifndef __ASSEMBLER__
 #include <linux/types.h>
 #include <linux/prctl.h>
@@ -12,8 +16,10 @@
 
 struct task_struct;
 struct kernel_clone_args;
+extern unsigned long riscv_nousercfi;
 
 #ifdef CONFIG_RISCV_USER_CFI
+
 struct cfi_state {
 	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
 	unsigned long ubcfi_locked : 1;
@@ -83,6 +89,9 @@ void set_indir_lp_lock(struct task_struct *task);
 
 #endif /* CONFIG_RISCV_USER_CFI */
 
+bool is_user_shstk_enabled(void);
+bool is_user_lpad_enabled(void);
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_RISCV_USERCFI_H */
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 17b9e77bafc3..32ad463545fa 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -28,6 +28,7 @@
 #include <asm/vector.h>
 #include <asm/vendor_extensions.h>
 #include <asm/vendor_extensions/thead.h>
+#include <asm/usercfi.h>
 
 #define NUM_ALPHA_EXTS ('z' - 'a' + 1)
 
@@ -277,7 +278,8 @@ static int riscv_ext_svadu_validate(const struct riscv_isa_ext_data *data,
 static int riscv_cfilp_validate(const struct riscv_isa_ext_data *data,
 				const unsigned long *isa_bitmap)
 {
-	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI) ||
+	    (riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_FCFI))
 		return -EINVAL;
 
 	return 0;
@@ -286,7 +288,8 @@ static int riscv_cfilp_validate(const struct riscv_isa_ext_data *data,
 static int riscv_cfiss_validate(const struct riscv_isa_ext_data *data,
 				const unsigned long *isa_bitmap)
 {
-	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI) ||
+	    (riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_BCFI))
 		return -EINVAL;
 
 	return 0;
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 7f01befabd11..27b36034ea85 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -17,6 +17,8 @@
 #include <asm/csr.h>
 #include <asm/usercfi.h>
 
+unsigned long riscv_nousercfi;
+
 #define SHSTK_ENTRY_SIZE sizeof(void *)
 
 bool is_shstk_enabled(struct task_struct *task)
@@ -59,7 +61,7 @@ unsigned long get_active_shstk(struct task_struct *task)
 
 void set_shstk_status(struct task_struct *task, bool enable)
 {
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return;
 
 	task->thread_info.user_cfi_state.ubcfi_en = enable ? 1 : 0;
@@ -89,7 +91,7 @@ bool is_indir_lp_locked(struct task_struct *task)
 
 void set_indir_lp_status(struct task_struct *task, bool enable)
 {
-	if (!cpu_supports_indirect_br_lp_instr())
+	if (!is_user_lpad_enabled())
 		return;
 
 	task->thread_info.user_cfi_state.ufcfi_en = enable ? 1 : 0;
@@ -259,7 +261,7 @@ SYSCALL_DEFINE3(map_shadow_stack, unsigned long, addr, unsigned long, size, unsi
 	bool set_tok = flags & SHADOW_STACK_SET_TOKEN;
 	unsigned long aligned_size = 0;
 
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return -EOPNOTSUPP;
 
 	/* Anything other than set token should result in invalid param */
@@ -306,7 +308,7 @@ unsigned long shstk_alloc_thread_stack(struct task_struct *tsk,
 	unsigned long addr, size;
 
 	/* If shadow stack is not supported, return 0 */
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return 0;
 
 	/*
@@ -352,7 +354,7 @@ void shstk_release(struct task_struct *tsk)
 {
 	unsigned long base = 0, size = 0;
 	/* If shadow stack is not supported or not enabled, nothing to release */
-	if (!cpu_supports_shadow_stack() || !is_shstk_enabled(tsk))
+	if (!is_user_shstk_enabled() || !is_shstk_enabled(tsk))
 		return;
 
 	/*
@@ -381,7 +383,7 @@ int arch_get_shadow_stack_status(struct task_struct *t, unsigned long __user *st
 {
 	unsigned long bcfi_status = 0;
 
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return -EINVAL;
 
 	/* this means shadow stack is enabled on the task */
@@ -395,7 +397,7 @@ int arch_set_shadow_stack_status(struct task_struct *t, unsigned long status)
 	unsigned long size = 0, addr = 0;
 	bool enable_shstk = false;
 
-	if (!cpu_supports_shadow_stack())
+	if (!is_user_shstk_enabled())
 		return -EINVAL;
 
 	/* Reject unknown flags */
@@ -448,7 +450,7 @@ int arch_lock_shadow_stack_status(struct task_struct *task,
 				  unsigned long arg)
 {
 	/* If shtstk not supported or not enabled on task, nothing to lock here */
-	if (!cpu_supports_shadow_stack() ||
+	if (!is_user_shstk_enabled() ||
 	    !is_shstk_enabled(task) || arg != 0)
 		return -EINVAL;
 
@@ -461,7 +463,7 @@ int arch_get_indir_br_lp_status(struct task_struct *t, unsigned long __user *sta
 {
 	unsigned long fcfi_status = 0;
 
-	if (!cpu_supports_indirect_br_lp_instr())
+	if (!is_user_lpad_enabled())
 		return -EINVAL;
 
 	/* indirect branch tracking is enabled on the task or not */
@@ -474,7 +476,7 @@ int arch_set_indir_br_lp_status(struct task_struct *t, unsigned long status)
 {
 	bool enable_indir_lp = false;
 
-	if (!cpu_supports_indirect_br_lp_instr())
+	if (!is_user_lpad_enabled())
 		return -EINVAL;
 
 	/* indirect branch tracking is locked and further can't be modified by user */
@@ -498,7 +500,7 @@ int arch_lock_indir_br_lp_status(struct task_struct *task,
 	 * If indirect branch tracking is not supported or not enabled on task,
 	 * nothing to lock here
 	 */
-	if (!cpu_supports_indirect_br_lp_instr() ||
+	if (!is_user_lpad_enabled() ||
 	    !is_indir_lp_enabled(task) || arg != 0)
 		return -EINVAL;
 
@@ -506,3 +508,38 @@ int arch_lock_indir_br_lp_status(struct task_struct *task,
 
 	return 0;
 }
+
+bool is_user_shstk_enabled(void)
+{
+	return (cpu_supports_shadow_stack() &&
+		!(riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_BCFI));
+}
+
+bool is_user_lpad_enabled(void)
+{
+	return (cpu_supports_indirect_br_lp_instr() &&
+		!(riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_FCFI));
+}
+
+static int __init setup_global_riscv_enable(char *str)
+{
+	if (strcmp(str, "all") == 0)
+		riscv_nousercfi = CMDLINE_DISABLE_RISCV_USERCFI;
+
+	if (strcmp(str, "fcfi") == 0)
+		riscv_nousercfi |= CMDLINE_DISABLE_RISCV_USERCFI_FCFI;
+
+	if (strcmp(str, "bcfi") == 0)
+		riscv_nousercfi |= CMDLINE_DISABLE_RISCV_USERCFI_BCFI;
+
+	if (riscv_nousercfi)
+		pr_info("riscv user cfi disabled via cmdline "
+			"shadow stack status : %s, landing pad status : %s\n",
+			(riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_BCFI) ? "disabled" :
+			"enabled", (riscv_nousercfi & CMDLINE_DISABLE_RISCV_USERCFI_FCFI) ?
+			"disabled" : "enabled");
+
+	return 1;
+}
+
+__setup("riscv_nousercfi=", setup_global_riscv_enable);

-- 
2.45.0


