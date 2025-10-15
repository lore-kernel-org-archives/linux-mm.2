Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92052CCD1A1
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90DD8E0075; Wed, 15 Oct 2025 14:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2E0D8E006F; Wed, 15 Oct 2025 14:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF60B8E0075; Wed, 15 Oct 2025 14:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91F018E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34DF814025C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:28 +0000 (UTC)
X-FDA: 84001148616.01.36B5E14
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4E7F380007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=RQfg2Bk6;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552066; a=rsa-sha256;
	cv=none;
	b=8OH3AbnAHRH2CdFNNYV2neAsdpKRM12b5/HAH9Xd4BgfmFrBPegvIETX4uFgrpeFEcGs/H
	iI9P92oYoaH7x9fNWDWmupPNvdiMx809YGmHmFz4i83Hqo6unOpL0WuX5x24ZlscoUUcrZ
	lDu50SYukcxg0HgCiGKk3vhG2jC+xSA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=RQfg2Bk6;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/tg1KhEMZfMefo+THEb4ueoLXzfJu3WY6LEuxXprwk8=;
	b=YK9td+NGDE8OoDvmL9vvl6f6+zte6lrgbyV4x2zA2ekj4+NwNNCFSpQ3VlnQEmrG+jC9Nr
	pvWjdOGFFpJMUU0FpgZaieoMO3Hhk2byJo9al6WcZhZMEEiIUScF1mbEL8nQzTZmnjiJLX
	d1rnPoQg5HBpvyltg5FSlNF1O69zSMg=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b62e7221351so5671815a12.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552065; x=1761156865; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/tg1KhEMZfMefo+THEb4ueoLXzfJu3WY6LEuxXprwk8=;
        b=RQfg2Bk6GUgd8VB5FTMW8N0+87dfJmIDDf80thoyCYE0hS9yEfzuyZ1Tni6JkVnSK8
         pfVRIW152QOCuibYx1fXhgWmRMlmElb9n18x2ZPuvPk4cKEYEWGR9RFSjQsQ9iYkQY7F
         2L7cacMmm8lN+Jaf1PtPFS+hvCWtqqWJpweyqZRnvLgLwEGMxpIQdxqTI6tRSzalwNpN
         7heuQOibWEC+rAr7HS9faG4Dy4nuYpiZMkOff8SLWwmWYpdKDKngBT7uu6TSn4UKbfFT
         L4XAyhGNGybJRQuojY69pdeQoVpfvXVdr+E6WRnrvNioT1D7/84HKVzASyYEiCmZCqu+
         Oiuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552065; x=1761156865;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/tg1KhEMZfMefo+THEb4ueoLXzfJu3WY6LEuxXprwk8=;
        b=JLBWPVOjZHMENytFBgtW3oTteW/B6zU9hlsAa0j4BOC5RzCtoQRan0SdQbA8XaUj01
         R1hLAusl2bkk1R89/SlQQGu0GSqh8sLbBC0x7DRLtFF0xmb+tMD2ZPmAqFYYDkK0OI9o
         mejuFMR/kd4/cY2QiJrX9nEqvFDjlx8VBOg7TrD3dFDHj7E1NxE936AWCUQOZVXHaMNG
         Rrj68wXWhvdkNfH72I+cZ9SKotYvT2IQY5u5jVQG/tPAkYBGQAuqKPj7E4bRX7i3FJk/
         1qT7emRCtMWP6siFUjj4DCjuD8+DcdfXfY0ocnC2N0NSWZ0ZDQWHjLACCoH5VS5pG7Dc
         /zCA==
X-Forwarded-Encrypted: i=1; AJvYcCXVuHjYGzNQWCzuZgEHUAx2tW6OG7kmEEggIWBWCJAE+judV4xiNEn+g+aGkE+k6AZrO4vNgkTjuQ==@kvack.org
X-Gm-Message-State: AOJu0Yx3oLWneWN8DzgozXeF2K2JLsqYk9jbpT9KMfONqkkjAYd2bSA7
	2GlVfi/varwqAXlFdXI53L5WB0sYH6CxZ93yIEEQkoYOQcBJYUOXO5DeIisrPA0Wo9yrclFQpS2
	mLoA9
X-Gm-Gg: ASbGncst3A4Dj67oRF2lB5Fd+VC0ovdf+FuCVM1/jznj/BL1X0x/r+ao2EiC+xGUnhA
	Bxeydj41UGAjTamN8VcwJkZtGxgWb3V19dz9Smd5HVp79pw59pEfCXEOyyn9hV9u+9JPH4dNeNv
	65/Rltc4ow59mcKRoVsyUDmc+L/s1pvpmLeFVUphqiJqYwU4Z9dxmGUImpkKfGMbGhlGky80nxQ
	yXUX7gOnEZKYE3n0Jh6VSdDLRcFx5zjSyx6rBApCGJH/ANeZffRnj1JGkyT/NDCRf4MF5Dj2ETj
	IXXMpEdh3foZCFV8Aup7ZbfT+yyfQWIfjBoPjmamn+fChqalvMAjR0SN6f1iIHRtb+LgmEUy2Rn
	MtQsT5XYj572dnvCmhKVGtYi6x+d6Gc5vtvnaOpYXBrzsfibhLMM=
X-Google-Smtp-Source: AGHT+IFJldQrTahc3Q8sVNu0r3ng0kmfHptGVJgLteMAPNepRvaTO19nK3n/je32vdUKI1tH6x0IYQ==
X-Received: by 2002:a17:903:2f84:b0:28c:834f:d855 with SMTP id d9443c01a7336-290272667bcmr408470055ad.27.1760552064765;
        Wed, 15 Oct 2025 11:14:24 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:24 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:50 -0700
Subject: [PATCH v21 18/28] riscv/kernel: update __show_regs to print shadow
 stack register
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-18-6a07856e90e7@rivosinc.com>
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
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Stat-Signature: wczztor89mxbkru6guhzr8qtpzbtiz61
X-Rspamd-Queue-Id: 4E7F380007
X-Rspamd-Server: rspam09
X-HE-Tag: 1760552066-649846
X-HE-Meta: U2FsdGVkX18Dd7J0sacG1E/Cf5Gwyp8E+cF99xoFRpxTOiuGZ3wynb42I2Jr8N63v+h5p7Hvl+i6yqrLLsEGbFxVWY3HNsvBJQskZrHnjlm47HTN7OJ109Nc55Kpyl7fz8D7pV4q7Zc7ruvj7ocsbtbU3bIL3fXBfbUsQp2QC6fotAKKl69nSv7Ag4LIqnwLkD9vCyblc9cCucs2mvxH0AjKXyv3RTrxQp5ThPQrS1g1InPTYCMZQRMpMa35mcGh0BYZbiuNzcznN14tVsUsTc/ze0Mz/T2+A+fQO7i82ru+N8LtfZSdGHQ23hSQyKQoVMYxW2oopuwMcge18r5PPhyGjeKO2+B7gkWWAD2qDPDyL6C9Rt3fNMpbLgXVon6qmjsddvF/qUhKicnRl8fZakcd5LIoEpGJddgP4OFoKO3dBu5/2b/S0pbVodubbUY8xjgcCMVCXqWOE/IWtC/AkSotPKELvzkgq6bWuwNktQoyfo4Bw4n8fxkOrSqTt8HxxnxF/3lhWWO4rGfaZY3drrGWLAf2VCRa5u5TB/YMUME6Azgds341oOAfflK3Nc4Tdut/skE+VtmlY7Gdp95rGEOo2Ut00IvYKcmip/EvDT8ZNe1KJ0QuOJRyRa9cKBYdYC+o3oIqIhcnAi8yG9vXavcpMd+MJ3babYMOICZWYIibZbiC+axpxS7gjhUd/ULTsUx3mBd1v/c8wGGYc6OoNGPZ1htxplyBXceWaoD6fL7eUH8L8dMk1heOiPVaNzVaI5RDWcTSSjsr6iyoTcePqbeHhXbW5rdIigA0dXYLOT1Mjxn7ilfrb+sdVbQafMNowTfNKPnblD358gt1ZThqpM4gnBenUJCyNYTiigCHAzwzt3ObvQ51TKr/o2iOQlstt2b1gf62d2OaLsetPwNNn5VVa4/bSymp1l0PtYG5fjxi+uW4ob54ETWqSHL1LA+eTLqNRF32g5g40dW3WgK
 FmcQerw4
 eWYgPEMiIl/vChu5uLIDZmO45XUNa2J2ikSwtYHmefQr5rtu77pseDOwFZFrFMiVOjmg9TguyosnSlSIaeDugVaJb9fbj+5+RICHGHSw/ItkDzqZNow5C+QruQopHT8qKJ5q1wIAeN2hNTiY7HAek9cnkxlqDiCa5E76N99Bct+8a/wvVL1ae2ejtIHmp3emMZG2FisDJstT1q1MjsS5bxjicOPZswfBb8kuw0Sbe4Vy5hbsuM5vsluzx/FbUg1oOULEt31ahG8MrKEAA7IDmOTHSJMIOS0zg/XH+SJrQLxMuos+yqx9OxcMJ1YF3RhOWp+nxoHovEzJAGc3uNsIr8jR9zgj0qMW0TtfpBzVDvLkRFQ7N5I6AD/28lf3L7KmkxwT9jXWgvLQvf/w128DgKITzJ6B7bA4Xk338R4K2NdOEnw8nQMxW4YUzc9aTrXpSZvr7qk5gPlfgq311d1N1NkScRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Updating __show_regs to print captured shadow stack pointer as well.
On tasks where shadow stack is disabled, it'll simply print 0.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/riscv/kernel/process.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 49f527e3acfd..aacb23978f93 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -93,8 +93,8 @@ void __show_regs(struct pt_regs *regs)
 		regs->s8, regs->s9, regs->s10);
 	pr_cont(" s11: " REG_FMT " t3 : " REG_FMT " t4 : " REG_FMT "\n",
 		regs->s11, regs->t3, regs->t4);
-	pr_cont(" t5 : " REG_FMT " t6 : " REG_FMT "\n",
-		regs->t5, regs->t6);
+	pr_cont(" t5 : " REG_FMT " t6 : " REG_FMT " ssp : " REG_FMT "\n",
+		regs->t5, regs->t6, get_active_shstk(current));
 
 	pr_cont("status: " REG_FMT " badaddr: " REG_FMT " cause: " REG_FMT "\n",
 		regs->status, regs->badaddr, regs->cause);

-- 
2.43.0


