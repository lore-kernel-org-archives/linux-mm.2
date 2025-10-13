Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2832CCD194
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668B68E0099; Mon, 13 Oct 2025 17:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619CA8E0031; Mon, 13 Oct 2025 17:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2038E0099; Mon, 13 Oct 2025 17:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 300C28E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8E32160652
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:21 +0000 (UTC)
X-FDA: 83994450162.14.F789796
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1568340008
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Pu6qsvMW;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf07.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
	b=PsWztLj4w90WBXYJoV8zhoUXVHJdhaoNGfxSZUBhE4wI5hQ3hUCh8AYqYiic7zBJv9jkxu
	x9Q9u/57W1Z8kAcrk41b+pHSxdOMsBUIyS3yQugVr1cIR+HPuVSoHeTXA9lnXCsM9VXHAD
	sKV6MTUKwMYX2KirLFrP0IseuLxtZRs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392580; a=rsa-sha256;
	cv=none;
	b=SW92yfC2GVNWAAquT81a0EJRb34cgM1sy2hVWtF9X7QqsFaoc4zmn+2Us1n5DxSO+DeHxn
	vkUgVJvUCpHT24I46MAifNdxU17NgSOlonyd/oaXR7uYdWP4HdiVUq+ekzGU6SIQoQ5I/S
	6X1yI+oSrdsBmzCDWYjYoqGvH9ZJXb0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Pu6qsvMW;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf07.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-32eb45ab7a0so4987653a91.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392579; x=1760997379; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
        b=Pu6qsvMWxv6CAuvrKiv2ocurFC5A2auxBTPWuMqRi+Q3o5vzrNtm9uK9UA6zIlBhcX
         nVheWIF6dxuwTjcVzxORWBDYM5N1imEVTR6p8ProtbvCRsqFzUUK0qlQKPARa6w19DMY
         t5SlsurNyS38N6d25+lC1fxDWWLC9l0/sebxAygzBONea9vbump3TK2kw78jxzuIPGfi
         oHm23bWTIT2p7I6dlY4K30X8vo7tgQo/0bECt+M5/7FTh3D7g/imrWonqp/f69RQQmEV
         vbt+vo6h1WM5jFz+h5z/MHhiICZ7ylQRLqvdiGR+TW1IGBW52xltwjuhk0vKLFaVljgh
         RzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392579; x=1760997379;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
        b=DawIbMWJ2y+nucVZD9wxhX2nQKX/7s4Mqmz3D2E2ctYkW5cRyeg12hnt63RpORgwmR
         0b2Fv4IM0WtLUtU/1bRd65EGPE3vUxRgcFtp0INltwNr8f3WtOid00Bq5J7WCcPWJFeu
         d4Utde/4YwLIxEkQoEFJ6QP9JjVwydzKr9NaOAPzVsZ6/UNwMHLJ9Bk+EqVCrvBHTJsJ
         3omWd9lESwueFgdet7X0Ug5KrIegC+XawPPVHzLNkrLdJ6LawRDHT+uJjc0+3w7AqgRt
         KgnhlyvuePOM6W292Mhg0lsb5fw60VQsWeYqSGPBPzps3cRYJCzjRSB7/CmkZ2tWb9Da
         EZ8A==
X-Forwarded-Encrypted: i=1; AJvYcCXqXbyTlf3euu3Nq75q6W+kwMZsAsl0IzWyNGJP4AnmdSVIzbA4xJ34ZtIP8k45lGL//AvYLlGJZA==@kvack.org
X-Gm-Message-State: AOJu0Yyf3uol+IAhgZ+s6BeXmLjMiJ3tl7ygusM8t4B9vo/bvQXry7Tl
	ysrOtwFYZ1fqSAbTxIb69ebCF1pyjNVjCyKtA0wfM8spPvOXxVS30t8P8zSS3VugsXc=
X-Gm-Gg: ASbGncuLMTcjtJwzY7g5A6MN68Y0cV3wM0viZfdsjFjuDOBZHZ9ks/92W6/+Aym5S1p
	kwHrTEIx2Oga9I2/U31iHvnBUSKZ0Y0qbPElkjm1FKQ5JvIUy/BexF3TN7e7cgbO7mQP56UUj3Z
	/ZuwYV1h1LonV+Q66vfCUxVTppNJAmr1jEh29AUfscDTYycLBTD73l41URATyuqOwa4sTacBmoK
	QNIRu/4yCimPObHFSqdB3f9EB28K1BDubEko+H7sRsRUEhxgiYZOTJl2yITBExeubVIP2gfUbKP
	QrCx0rF6ddjVdlvdZhDgWoE6ucfzniGn1Vk3lO/rg353uHz3eZHZz6Bb5rYVaYCns3EoWUR6XVi
	bsP/IpwS/N8KsSzZZsMs0Dn58COMWxDKKRzyXfm8D2vB5l2sidoE=
X-Google-Smtp-Source: AGHT+IFzR9QDYamHYpCjkFw7ZosGRTg3GUVmZHKGAXWmLamhYw9LpV35U9SRuq2pbLs+pbK1awqRow==
X-Received: by 2002:a17:90b:3a92:b0:32e:4924:690f with SMTP id 98e67ed59e1d1-33b5114b5c6mr35939819a91.6.1760392578914;
        Mon, 13 Oct 2025 14:56:18 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:18 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:01 -0700
Subject: [PATCH v20 09/28] riscv/mm: write protect and shadow stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-9-b9de4be9912e@rivosinc.com>
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
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 1568340008
X-Rspamd-Server: rspam02
X-Stat-Signature: wum99swgm6wr4k1niuwsnmdyp98r5iso
X-HE-Tag: 1760392579-192980
X-HE-Meta: U2FsdGVkX19eZn8EFuxxoOwkCISnjdYjur9IPSWgcVOdNB/lvqegvDOYwIPrt2QOAOg2XuuEn31EwS1pYnhDYdwptaAF+oeVzwXXGlm/rDzy4JHPDGeEbkqeIFpt839/PDN73K8Su28PJmfnGfQ1112Hte/P6DX6aPszbvfdtntqFW6PtRgHlBP5IBIShSJ11OcN6MV7Lvv9A176e7N9Tir5mIp0WzZIuMtaLPmp8C1cP6U5zh+CmX3hZxRyiFKh9EAa651N3W15dgNVkYv1yJ2tXDPfVUPaaKPVjj3fMn+TPliylYkYDlpfQNc86/JGYyRhJEob/hYlSB0LgbVuZ/xB+GJa5Vl17kkVwKcXDQF2Xp8YsMStuv/0PQLd2/XsqxYXfbf+dDXuZH9FStkPHxzI9Ww1Nct98hAvcArqrc4jNLHDAUCWlPSEsRAX/GeG86keeTyV3NZWKoblxk2wfdTBcOazjVmkUXKp0VSzG3eYCRms31IvbtISwULtGESVqG880QB648Gb4QuwAkt35jrhz6ino+SccWyEOjXPVZ26cG/Zk+kLzb04Jot6OrKrd4v7U2U+mmiXNWnCCTy9QqTchr1DsZA95734pF47UeQ86lO3huxi6BsSKgYvUnmgo3b2mXwE5iAJK4JR5yDFitSpBlv5Cfr0M/Dfg3TMFKgbQkgvAwXqnV0YPGCLax3R7ZZ/7Wpj8B5N1/ydChnCL3xT/dIfQH1B1VEoC+ModitRhDVMWcN5e4BOOCrwBQhlK/V/HHm/KFIsFNeA4DxtOfOrVyx2QYwMSNBOU5BOtl5cwYtYS5RSo1Se8QnsoFTH2OIEn88JclpQOPTPUoldJCX+YVtIYwcf69U8snyVgwWJKkAkzgrP1uddCyWFIBA6VSDh76K5sTtHCpSa1+ZfljVJvCYShHMI3rbBhq9WioH7o3T5gB/GpbP1jf5t4RHO/NAiGG7EBZMScc0wrLb
 7dZr96nh
 /AMYX4WuCRJqnG7wkUxZqJpK5YynsZgkbg8BdDri7wPBzMEaQVneS67CvQqs0gJQ20rvoj9zdXnRt1v94jWVFAE5VcwQoPj2IZnYZoQ+SSxmpgmrHGc/G+J81QsEdSBQxruTHXivuc+8SFXoxD5lBoWJwAvrzP+IZWfNTVQ06U3b+8ZhcLCQKwJEhos96t4mks2k7QUpeXFbBiDiPmhc/FzZd7xIrA3I597JE9CFTArwh8gURDcDyM5VpV68JFkwXtNpsr6cNX/Hm6a8MymcjiY0QKqt4xVF7ax8bzS+9gEBtwj0Q4uJ/fbKlesK90HGrY5KxI/YoIMu6B+z/y23AQhuwQD/jfYUjNUIsr9rW+fvlv81plNhTAX6ejxJsK7rY5/5RJGioa4CTLEhzyvsu09tPewq3PzjCvsbIUk/GCruQyo9TacqQMTdw6mO8472TZ7t8H5C4ceXjOXj1Y/6iRf3IW9tUeGowL78wHXxnopmkRKWZS5ekaQPPwKSt8PHy12XT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`fork` implements copy on write (COW) by making pages readonly in child
and parent both.

ptep_set_wrprotect and pte_wrprotect clears _PAGE_WRITE in PTE.
Assumption is that page is readable and on fault copy on write happens.

To implement COW on shadow stack pages, clearing up W bit makes them XWR =
000. This will result in wrong PTE setting which says no perms but V=1 and
PFN field pointing to final page. Instead desired behavior is to turn it
into a readable page, take an access (load/store) fault on sspush/sspop
(shadow stack) and then perform COW on such pages. This way regular reads
would still be allowed and not lead to COW maintaining current behavior
of COW on non-shadow stack but writeable memory.

On the other hand it doesn't interfere with existing COW for read-write
memory. Assumption is always that _PAGE_READ must have been set and thus
setting _PAGE_READ is harmless.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/pgtable.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index b03e8f85221f..df4a04b64944 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -415,7 +415,7 @@ static inline int pte_special(pte_t pte)
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(_PAGE_WRITE));
+	return __pte((pte_val(pte) & ~(_PAGE_WRITE)) | (_PAGE_READ));
 }
 
 /* static inline pte_t pte_mkread(pte_t pte) */
@@ -611,7 +611,15 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
 				      unsigned long address, pte_t *ptep)
 {
-	atomic_long_and(~(unsigned long)_PAGE_WRITE, (atomic_long_t *)ptep);
+	pte_t read_pte = READ_ONCE(*ptep);
+	/*
+	 * ptep_set_wrprotect can be called for shadow stack ranges too.
+	 * shadow stack memory is XWR = 010 and thus clearing _PAGE_WRITE will lead to
+	 * encoding 000b which is wrong encoding with V = 1. This should lead to page fault
+	 * but we dont want this wrong configuration to be set in page tables.
+	 */
+	atomic_long_set((atomic_long_t *)ptep,
+			((pte_val(read_pte) & ~(unsigned long)_PAGE_WRITE) | _PAGE_READ));
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH

-- 
2.43.0


