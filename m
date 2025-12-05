Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C912D339B6
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1AB6B024D; Fri,  5 Dec 2025 13:37:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A646B024F; Fri,  5 Dec 2025 13:37:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB246B0250; Fri,  5 Dec 2025 13:37:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DADD46B024D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:09 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A487458359
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:09 +0000 (UTC)
X-FDA: 84186274578.05.6EF77E3
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9EBA21C0009
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=XKd7RvKI;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf21.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959827; a=rsa-sha256;
	cv=none;
	b=BqUMbue7EYY4gmwq4cw3HMX+v2Lqo8NtVMCVQ+FSUnDAw5LpotcKjQJ4aLkIR52pUX4H+G
	j3SP3ceIXlR0JAf6/mm/H7i5gQUDs3WOnGBawEgY+WJWGD/l1vo3y8gfRBbVaelUTMP1N5
	rLt29fgBe0KTFk9VBAJPsJlrI5vjq5E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=XKd7RvKI;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf21.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qazkzNjoTGNZQrm2wNpnFtC3xWbAXmOxYceHXxLC8bk=;
	b=Esw2Sk2Vo5CijaRVf3rmOSVSJ6AHw6D6S6eqdOLt+FPk31W3fvdg5MS9QVLrTJGF6GGCkR
	z461R1vIfu2VzsRy9rtqychsGU0w8fuWtt/DcIQwAUyBKP7dl0HsfXw1vFIpFO5rflWGlT
	h1FMoFgG8XtDknKuc0DsOG0zW4VhYNs=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2980d9b7df5so29011665ad.3
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959826; x=1765564626; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qazkzNjoTGNZQrm2wNpnFtC3xWbAXmOxYceHXxLC8bk=;
        b=XKd7RvKIddf0UlEvarzI70Egex3mnIJBK6ReJCvOnkWdb6oTGrgOnvF3EC9J4DLtrO
         CSZpGW0xOGFRomLGSaA9rQd9giL/nXh6w37zjhvLZOljyVq1fF49+05Y1EmEfpVdU4fL
         yOVastNH3sjAXhlg6MkkBcr3LsznCN5MHub23zlU5flxcPXOLbHHryAnSeiPTo/46nwU
         nvff2eh1s+X7gUy8bdhiSKILueBbo+uHme6ruyWH2N20KxuPxNH36WDXW2ksz3WVrlWD
         y5X/u8xAsjaWzWL6t4PhcpSPDfxo5n69wbzuRACXsCQINO2qHjCprz4v6MpcEAo6KMH7
         WSYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959826; x=1765564626;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qazkzNjoTGNZQrm2wNpnFtC3xWbAXmOxYceHXxLC8bk=;
        b=oRM7UmfrWg8pzrgGJk3IFADe51VnkAmm+Hp1khwsd84foF1AJp+ZinTNx3MosGCCjs
         1X9C7qLtFyyE43POEDOCHP82yD2EoRtQ7pkCT+fD5P1+BqVo5PjsmMMJuOM9lpvqM4td
         jaJzlWWzdwKcTysBbZARfFSiGRInkPw1tCnLHZxjS4ZD+nh7+HqcM5y7cINwoFcHL8Y3
         ckas9wAar7i4jOdxdcLMzHDFC5y5qt+Oy3RaowoQcXV0+F1SDl4Xlbz4ZywJMFU4TO+7
         NWRW+gObEJV6RBPzE/0L6RdZJR4MTq2YeTx2Fm83I8R3gyKIhONc2jhpWdjAM6Q/Nfeo
         MUYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuXWQnqcgGlHURgHzEei6jzylkYXXC1/OVxiX+cbxNlRZnhq+hEpLRwG4mvGFOytNSuuR6i+u7ag==@kvack.org
X-Gm-Message-State: AOJu0Yx0G53bFKB+i1/GJRmA6WhR443IuTCzvNLbRk8kUVel+4sLmXP8
	2wmEe3orNRPoUQFjy35PI9iR5vZVS7oOF6J0SRdvkkg1HK5shUTh/eXerzHhIdI4Bzc=
X-Gm-Gg: ASbGnct3WBIjAk5ZLlvFAFILjLV6/F8J4ysowsn6HML2WQGO0DwFPCTyP5lUMilEQ/m
	+5m/BlSFPj0N6+NZBSaNSdwUjVKdn1TwbjjaBYMaqerzJKSJaL8Sb4IQrDOpUF8Qxg5+W29vB2R
	TFfLNulBRazJnnUjiwQRYkZcLNAMCcyu86VK1OHScBitAFN5b0rl5PoS3vONLJEPjoHcJLqLHRX
	+ftPWUxgz9g6rPzdb8/s9BAWNsjUG9ZU+Js61OV/PG3RVDI89/NQJskj63R3W5VKsrYouAt/REi
	AefKd4F+Y4MOp1lW897KiNmJ5oDqYgeSwkqNjukxbilsRQjOYfz3Wzyuc7lfP1GX+PV6b12+lsT
	zs8AhilBqZq7c+RqCb2IPuA21/Ei3mqv4JLOG+XLKvmllgD51zz1tvcfIUqh3LmuRMeDYRWDF2y
	pXN0YRXIeeMy8PwhMDjhk+
X-Google-Smtp-Source: AGHT+IGWPgA52pVKY392RWVs73+ODbHTzrwBl35/Ip/bb+MqX23pPUpCLekpfaEmLltfbDW+jGlEKw==
X-Received: by 2002:a05:7301:4b0d:b0:2a4:3593:645b with SMTP id 5a478bee46e88-2abc713f251mr100407eec.11.1764959826450;
        Fri, 05 Dec 2025 10:37:06 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:05 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:36:54 -0800
Subject: [PATCH v25 08/28] riscv/mm: teach pte_mkwrite to manufacture
 shadow stack PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-8-8a3570c3e145@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=2371;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=c+59GLf/oXo60d4AM3tT5Dly1CdoHCtus6ztRRar0mY=;
 b=KhD+UIU/8v7BJ40QxMa3DFJbPyhICkmZOWVU8sWEQ0K0JX2XjnwtAs3NAXwpAsMgnytUbLEY0
 tCh0LHo2nu5BZL8LeCtCwXo00kOQ5pMdYs9gGJ55ybs4tzUu22/zeTK
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9EBA21C0009
X-Stat-Signature: q6jtfnyne91xnkxebimagwxmaq5gb8ed
X-Rspam-User: 
X-HE-Tag: 1764959827-653083
X-HE-Meta: U2FsdGVkX1/eKvRiPs3pZAYdj5Vr1B/FFK0oTb07xhAiwXfZvC2hKEve1v0szBF1YHCF/rrF48ytlq1ANyJEHG2ABTZ88+X0YaDOSQXhX1yqVM5Z3zyWE+L7aKCRUSBXgzglkvXbSSkX4Hfer14w+QfOshq1BdjzRBO43f3UBjR29Ufn7ON/wdFhCAxkuLqXWDusz9QEi9o1LeC2mBFn9dJZRIBSSLxuDNGHYo5qvMNEikakg3RBSvbeTO0D3uUycg4dKMfZF0y2zyjepK1UGUwXFgLMXHjpqexuyAlvmuBT9611mbfYAiOCqvA0IzegPGnGku9JaJp+A5kAGELTzwlNHL9r7cjkWmlsKkTmjmxJaQYk/16uowGQKeoVpgN2JKX6seto1cEf5jQIdvqnMRxFfj88ErkNg3hM2BBVYLi9knrFaZZtsp0F9OeJnLV6/TZ82aa1xK8it5+8VM5JonEYbnatfi18Gxa5Aa3jfZeEblnhqtJlyCNByPhWI18pyZmzxezetSckDHiOMn/OJw+243iThPekXGsltaJmgrCd2r2Y4Rq1filU9OOaCu8xI3YsCa4BR5VCNabBQ4RZqLSk5NY+daCasp2kpuZt/KVsiL81M9yKGDlSvhfL2i81LBvLzp+DTDj8sQOf9m8RtixriZb1khD7JRYms4sMsKVx9p3EEpFD2lRrI28/NUo597glPMCodgZ03ctBUWTdHSQmZUzs5A9x+bw2kh+yC11UPRljmGNXxWcSMi087w2cnQ3gFTV+cpeOQ7A6TOuDvuooC8DZcfWE8twovdBrir/z9JALn2gwRRpAxm90DpD8dlCyRxuh7DVCqQhbV7X73JsqsWBozPoWy0pSDbmkekaK5GyWsknYCwkXS5hS3phH4OiUy3YLV42gbCceSpO3v/EKt9SygkGWnFVkkwdgCTNXmLG60HTorkfm/8MFAhoWP5tRCTFG3qBK6zJTAFx
 qhcz4T9Y
 poVS+jeKUminJXCUUuOkMNwl0ZHpZMoLe6pM3z5TRdCsLoIrsxI/xjMLeLqJ/AFRbY3CR8bfg2+2FDotoIf3TSit0mzs5oSnGEWjdopSQs+qaYijuliEXDA/o8sLKV+TVI1tDouSJFZ3rS0MT6r6aSh8LsrykdBzqECpB4Qgd9KWKFNC+oRTG15MZu+Ta+sZo7tQGLIjefM48nukgA+KvXYK+wQ7iwnsjXiXiUUcSyNDH9pZWaw6Wzc/Tje65/d1vln3iAh+xZ/pvH3uWyRmai0bT4SISsfT/RqHLTwJwAttqy8YisdQL3Oxh6ES7/vFjrHjkULSPs96v5jAoXCIyd4o7EvrcZaU1704cuYxNx8pkzec9SlDBYnt3Bsyknfkjbrzo/4+rg6dvpvYy4J4ZbBGSGIPW+dTLNJm0V+2hPCQOZ60EIy/GZlmN/gqdsEGoz0qOmQRPjCurb31WXifTLbO6wgmO2YgzBINDggB6tSMUi/1bWViIhtRt7yWvxZiz7IIYTcPge2na4mICueJNi9XGBvzNE/N0lwom4anq120XfwOmcnJllTTicsHTEspHRu8TjdDb6/q25lo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pte_mkwrite creates PTEs with WRITE encodings for underlying arch.
Underlying arch can have two types of writeable mappings. One that can be
written using regular store instructions. Another one that can only be
written using specialized store instructions (like shadow stack stores).
pte_mkwrite can select write PTE encoding based on VMA range (i.e.
VM_SHADOW_STACK)

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/pgtable.h |  7 +++++++
 arch/riscv/mm/pgtable.c          | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index e4eb4657e1b6..b03e8f85221f 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -420,6 +420,10 @@ static inline pte_t pte_wrprotect(pte_t pte)
 
 /* static inline pte_t pte_mkread(pte_t pte) */
 
+struct vm_area_struct;
+pte_t pte_mkwrite(pte_t pte, struct vm_area_struct *vma);
+#define pte_mkwrite pte_mkwrite
+
 static inline pte_t pte_mkwrite_novma(pte_t pte)
 {
 	return __pte(pte_val(pte) | _PAGE_WRITE);
@@ -765,6 +769,9 @@ static inline pmd_t pmd_mkyoung(pmd_t pmd)
 	return pte_pmd(pte_mkyoung(pmd_pte(pmd)));
 }
 
+pmd_t pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
+#define pmd_mkwrite pmd_mkwrite
+
 static inline pmd_t pmd_mkwrite_novma(pmd_t pmd)
 {
 	return pte_pmd(pte_mkwrite_novma(pmd_pte(pmd)));
diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
index 8b6c0a112a8d..17a4bd05a02f 100644
--- a/arch/riscv/mm/pgtable.c
+++ b/arch/riscv/mm/pgtable.c
@@ -165,3 +165,19 @@ pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
 	return old;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
+pte_t pte_mkwrite(pte_t pte, struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & VM_SHADOW_STACK)
+		return pte_mkwrite_shstk(pte);
+
+	return pte_mkwrite_novma(pte);
+}
+
+pmd_t pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & VM_SHADOW_STACK)
+		return pmd_mkwrite_shstk(pmd);
+
+	return pmd_mkwrite_novma(pmd);
+}

-- 
2.45.0


