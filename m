Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F3E1D2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828D96B00C4; Thu,  4 Dec 2025 15:04:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D90C6B00C5; Thu,  4 Dec 2025 15:04:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6048C6B00C6; Thu,  4 Dec 2025 15:04:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2A46B00C4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 137DB13AA03
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:08 +0000 (UTC)
X-FDA: 84182864976.06.30664A8
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 095FE20005
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="L/3ozQ0T";
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dse2BU+tFA5XFpg+kLbFKrS+f5gCoIar5kBy1XNyEFE=;
	b=B0WjTGGx5NG0IpTdQlfk9walKAwwP9FnbnJgoJiRE6ATCz7AGIlArDIxsBS1at2IgftpWN
	EkdPbK76WNlQfZ4xL2f10T8shtQt+6mOHb39nveIHS4yOOhTXdzfENyi58BkNMUlCQZl3h
	kElluawVurEoPa+mRYAfj4W9iSXiu2s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="L/3ozQ0T";
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878646; a=rsa-sha256;
	cv=none;
	b=zh1cYOOYGMON13UAoQyGZa57qRQZKkKeaAPaJxuMKREDJTuay145u37gNkjikD7zLjK0ZA
	04BOlrMpFxkRLJhO4uLpfsMYiwv0GmjHFRdR2yK3MB2PJ8f2yM0wHJzs1RveYXNE7qb3R0
	4cRMhtOFaIxvITnib8jMqAElSY1qA3Q=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7ba92341f83so1631565b3a.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878645; x=1765483445; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dse2BU+tFA5XFpg+kLbFKrS+f5gCoIar5kBy1XNyEFE=;
        b=L/3ozQ0T427tjlBirE1xVEC9nN60rfFAXLf19bUXAzWc3gPJE71VpWmOPjmYOwoXvw
         jUarrJBKXk3R542HKheAEZ9MfbEDgRgIqgjR7PSfl4fhmcvqH/FX+J0VEf2bK/ZnNHrU
         LpchSiL+/HO9r46I30Eg3UmHVFWWamQ0SLGtsxqFDAY7itFMdkpXh7f8yrhCmsyt1OIY
         Zbo445lJzhdj7+m7YzSZTb46k0fuzyBeNuYoJ5l58y8i/Nx/x6SMOKJX8JbmrmJJYX07
         ginNqQAhlgszkPh2875S59fuc9A1Rkg0GNdWSjKuynmVe0EYwO/Ym++wJivoEOI+lwNi
         Ubug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878645; x=1765483445;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dse2BU+tFA5XFpg+kLbFKrS+f5gCoIar5kBy1XNyEFE=;
        b=KBm8joe+bDm9ZuA643KQcWqWkvMGYAyYxTsNspLNbwnhdKU60p3E9+fEbyL3hfoP9b
         iJNPiMvNjT/rv2DFptt2n6JAslbg66j3F9XyYxnxkUkOrursVX6KIGrThPo7NuGOSPjx
         19pGcc0b6z5YSZzrsHyLn+WS+93+A677vHNYoDEl205c2XUevA9SjQb2QT9OL+GVtEZO
         HtcqKD/0n5dS4/KqBUA4ZX72qgpBwj7T0PR7P+j7T4IrSV1J6yFeqImVrAJnqDM2g1rp
         aB2FEQeweJCizYImKPkR3G3cq6d5TEjU+uAGUstUqdKdRQC99BEz+UfBD23ANC7zIWWP
         gzHw==
X-Forwarded-Encrypted: i=1; AJvYcCXImYeTmbRFsQlB74notA0pme+oVeoZfE+Y0iRwsKbbDMywoTLyMSccW8/DzKFJKb5aZStSAwjm2g==@kvack.org
X-Gm-Message-State: AOJu0Yxzy8Jh3P8qpr9iaU15FMPuWjWJHDjLZmsGSB9TQBGBXq0lbP5z
	Fundlj0bb4+kgCVnezmJTvRx1neche42UBPThD+lv6xXSzp627rGQFsWwmXDYJQWdyg=
X-Gm-Gg: ASbGncuCqLGAIlWfVMh82gR3Kh7pceKku3uOYc7wpIKhvBy8LDmRZ7l+IAIxJjG8NAx
	rK75Wmvf2Ze7HRmed6rWTSFc8PNpOIfCC7+QT+rRIQZRAe/HeQ3AKruKdVVoxbOuVyyMv0muCE2
	DLmjNqeKmbiqRoPrH6c9uI83sgspXbVD1CUH96rblEokuySAjYtMsQMUioqoQMGEKAE1Mlpgrn8
	W+UotlOpz94AZDj19+vmEwByBBZzBYtjAHmyfklEWBgBqf2eiuR1VkGfYGYlQ7taUdTm1knUTev
	AjW/aMWf0LLU0I2peHo0yYbCoU1rxgRS4pQZ/xg+D/UrsTj9L0+2Rksjcbm6HjXXk8tRflYEh2M
	IXpqVWLjcP3BGGbp7xKHknTzlCcntpsNGgItIzA7AKwrNxNl6o6gZNj0bfPf1P1qGrjI3pmTl5p
	KfyrdpS6wKdfq4pov98sGw
X-Google-Smtp-Source: AGHT+IE6g5en90WXrl3ZEnboKqts+eBcZS3P4Z0a/whlRK6sw4bJgNhh+d5L/+hs3tXCG2T1uDOqfQ==
X-Received: by 2002:a05:701a:c949:b0:11d:f682:e475 with SMTP id a92af1059eb24-11df682e6f1mr1767600c88.40.1764878644680;
        Thu, 04 Dec 2025 12:04:04 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:04 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:03:52 -0800
Subject: [PATCH v24 03/28] riscv: zicfiss / zicfilp enumeration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-3-ada7a3ba14dc@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878635; l=3702;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=ZNC9a/En39m8CKIDJtxwHFeTcpc9wzeOUsHgDemdXXU=;
 b=5o2zU5rsxOxcJKC2p1yqW7GuhtDJPFoThZH8CdeiyFSiUJMGHC8P2JMq2k+6z9+4nWVfwRGik
 1gzSe/qpXZgCW6LPHP+kjurdK3b0lQ02ZbqKtkuHdzcrl2GjgJMK9O/
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Queue-Id: 095FE20005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rpyixs64ndrxhfdeujpmitmt1e5rihhg
X-HE-Tag: 1764878645-351726
X-HE-Meta: U2FsdGVkX1/jOjY/0M/A4dZyOmThHwQBVK2U5B63ISHPc8rv4QIe89c+Mcz3cLWm3NByze697e4nOAXOYUvFaTibRDFi3ZNuIdHLRs7xeCl9w8oy2+NVgYMads3QPMjSqJYbWGeTpW3Q/pYjgKjYyM5gYfqVoXtd6s7SdmAMr1BilZe8dIrAWYKL5OaPhlVgzN1ADl8L7jSUXTbsaaTRlyKe7PprpUCwqNsTMJ7sMbTq/lfkSokpJ9Ctnfa0lC+bbdqYtbsIiNiSoO1lba6N/aKugeqbuyJjsxc5VGR/KE1kLDsJAa/claLahoS3q/xExqOf7dW6cXQcY1oRB0P72d0SdQf+LsXUAU7L2bQ7RnL5z4PoZRumw3DaPYYxynblN8OzJw4yezEcOL8e+D1IfyMDhFOoI+JS5SNtnvwqxoPv9fa628wO4OMe+QMFgrYWcryb1OaDe1r3KyMTIL/0JOckAz3zTvMUk9fiIzWSNRmPDVeoppg7LGDiNWkr3/qTh0yfyNusjRRt7PNff7rO6NPC9oduwARNeo/BuFm8Ij5UHl2upH+hYqvJN6AYfsZOccDzUT2MqqEXHaiuNRDUuRrfD0AO0Kbv12LfcFnaF81o2ClhnqN7R/un1orfI0XlpCzm04yCAHoiBcscQiutYiVcXxiBsmHivkk7QEhThU9DN5gvUc+sfPRhZvd6OhK8bljzCjOwti3qPMT30ees79GIm01Iy/4c/PX381U6AcVVlmB7z4NsWF7MHl0LKduWKm00fyLsX9sGSIwtkdHIA7TfPsXd5pxxTI8b48tRfuwoDpxc1TIuZOH2NAuK62cECrBYGiZ4af6Kw5OPI5pksJ4fXlDkKyvnAtxdsmU88aX2Zd3oefBqmOgEYOC3k90+TJoxej2LTYU/bvZiKkUo/Z5uyIFi0cWlPpTeIisK+h2alzCkcXNk30/Xx8g31HxkyJyVgyNQ7lRwdsk8mQT
 o1me2OyI
 kKThE9yQl/9zIpImiiXEbelxNEE07/gigcIv6gQuiSpiaVYTw2Qo8a3ixIzAvgWqTaNlzgLNAS3o2+AB/FFFF+GsSHI2o1rEnGeX1oPchQEmEMjgjFxw85eyYp0qJqdFp+dtM+NLkmqhR71AR/31Tn0SNwepl7+x1EQXbfCFcdkUVw6P6DAytdSFXHX7mGEpfcLspJRBY5UJj2zP6wAOX8ardqSzi4MSYeB5d2Ej6co80fQYVovm0ltDgB9vPhC/1OD0aO0gKvcdfL1M31MveYDLVDlOEbNyI9BSAVOu5JlUhaHlEJG8Hahr4Ax6TCK0tgcqawdp66HyQbWzcKG9fpsMbQ4G2iPetMYKNmua7gjHGkhjPb98akO5QXo1X7klApZfz5L4O7NthFRB83EOz2wrmMCheWk9BV8NIJVbmCO5r+1Ylp1I1ZgqDNAM/EPGvYlH7xSSkklqblvoFZoMC4y5tjyXfIIUxOtsj2a9ztIDGn6w//SRwALFoFd3xAtnUY5DI9IFoEwGR3fxuzcaHEYxHffObUmew4ev3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds support for detecting zicfiss and zicfilp. zicfiss and
zicfilp stands for unprivleged integer spec extension for shadow stack
and branch tracking on indirect branches, respectively.

This patch looks for zicfiss and zicfilp in device tree and accordinlgy
lights up bit in cpu feature bitmap. Furthermore this patch adds detection
utility functions to return whether shadow stack or landing pads are
supported by cpu.

Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/cpufeature.h | 12 ++++++++++++
 arch/riscv/include/asm/hwcap.h      |  2 ++
 arch/riscv/kernel/cpufeature.c      | 22 ++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/arch/riscv/include/asm/cpufeature.h b/arch/riscv/include/asm/cpufeature.h
index fbd0e4306c93..481f483ebf15 100644
--- a/arch/riscv/include/asm/cpufeature.h
+++ b/arch/riscv/include/asm/cpufeature.h
@@ -150,4 +150,16 @@ static __always_inline bool riscv_cpu_has_extension_unlikely(int cpu, const unsi
 	return __riscv_isa_extension_available(hart_isa[cpu].isa, ext);
 }
 
+static inline bool cpu_supports_shadow_stack(void)
+{
+	return (IS_ENABLED(CONFIG_RISCV_USER_CFI) &&
+		riscv_has_extension_unlikely(RISCV_ISA_EXT_ZICFISS));
+}
+
+static inline bool cpu_supports_indirect_br_lp_instr(void)
+{
+	return (IS_ENABLED(CONFIG_RISCV_USER_CFI) &&
+		riscv_has_extension_unlikely(RISCV_ISA_EXT_ZICFILP));
+}
+
 #endif
diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
index affd63e11b0a..7c4619a6d70d 100644
--- a/arch/riscv/include/asm/hwcap.h
+++ b/arch/riscv/include/asm/hwcap.h
@@ -106,6 +106,8 @@
 #define RISCV_ISA_EXT_ZAAMO		97
 #define RISCV_ISA_EXT_ZALRSC		98
 #define RISCV_ISA_EXT_ZICBOP		99
+#define RISCV_ISA_EXT_ZICFILP		100
+#define RISCV_ISA_EXT_ZICFISS		101
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 67b59699357d..17b9e77bafc3 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -274,6 +274,24 @@ static int riscv_ext_svadu_validate(const struct riscv_isa_ext_data *data,
 	return 0;
 }
 
+static int riscv_cfilp_validate(const struct riscv_isa_ext_data *data,
+				const unsigned long *isa_bitmap)
+{
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int riscv_cfiss_validate(const struct riscv_isa_ext_data *data,
+				const unsigned long *isa_bitmap)
+{
+	if (!IS_ENABLED(CONFIG_RISCV_USER_CFI))
+		return -EINVAL;
+
+	return 0;
+}
+
 static const unsigned int riscv_a_exts[] = {
 	RISCV_ISA_EXT_ZAAMO,
 	RISCV_ISA_EXT_ZALRSC,
@@ -461,6 +479,10 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA_VALIDATE(zicbop, RISCV_ISA_EXT_ZICBOP, riscv_ext_zicbop_validate),
 	__RISCV_ISA_EXT_SUPERSET_VALIDATE(zicboz, RISCV_ISA_EXT_ZICBOZ, riscv_xlinuxenvcfg_exts, riscv_ext_zicboz_validate),
 	__RISCV_ISA_EXT_DATA(ziccrse, RISCV_ISA_EXT_ZICCRSE),
+	__RISCV_ISA_EXT_SUPERSET_VALIDATE(zicfilp, RISCV_ISA_EXT_ZICFILP, riscv_xlinuxenvcfg_exts,
+					  riscv_cfilp_validate),
+	__RISCV_ISA_EXT_SUPERSET_VALIDATE(zicfiss, RISCV_ISA_EXT_ZICFISS, riscv_xlinuxenvcfg_exts,
+					  riscv_cfiss_validate),
 	__RISCV_ISA_EXT_DATA(zicntr, RISCV_ISA_EXT_ZICNTR),
 	__RISCV_ISA_EXT_DATA(zicond, RISCV_ISA_EXT_ZICOND),
 	__RISCV_ISA_EXT_DATA(zicsr, RISCV_ISA_EXT_ZICSR),

-- 
2.45.0


