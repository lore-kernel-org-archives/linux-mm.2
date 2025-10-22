Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3CF4CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 23:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75D58E000E; Wed, 22 Oct 2025 19:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25E48E000D; Wed, 22 Oct 2025 19:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78608E000E; Wed, 22 Oct 2025 19:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5EC8E000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:29:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54300BC181
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:58 +0000 (UTC)
X-FDA: 84027345276.14.ED181F2
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 63963160011
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=E1p8WQ+d;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761175796; a=rsa-sha256;
	cv=none;
	b=h6q+5YEk73EGQ07JC78aY5+2iXCU+cA7UyGrodvn+Xo2wtzXMpE6TtKoKrpm+4vlFbU428
	LrpzWI7TfLLYtuTn7YNZ4zvqVX8RzO8cQQB208Ivc9M8OWuioVOpD2cfDg6dOZaeVSX2AF
	jiQwCphtwPw5muZSvbnqRVfDE41BWAg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=E1p8WQ+d;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761175796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
	b=wbZCinQtQ/n11ljgSGhoCeJ91rquXrsUwy+46ZCkhO9g8UZ/0bZ+IqG2pO/RZJmkwCRuwl
	+fJdVDNdVo3+3S65S3c4zGBV+VFOSjqMRmIovNoOUqstI+7STTalw0t5Evj5g91F+Ztqf5
	Codv3+KfIrI+bynL3DKDB+M8TJyWUqQ=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-77f67ba775aso227977b3a.3
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761175795; x=1761780595; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
        b=E1p8WQ+dV1sJwlChhodUbQR0RqD6KM4iI66vZH55shj+hyZAV55a/3g9eMh4bmj0Tp
         IzzrfeMoCEARo4GMZunrsfcDWmt84WbJ/RyzrdPJHzweKoeHSUyHCiAqz60ZcF4ccZYK
         pmKiksddR/wNB7j4rFOyZzY9HFZU6bhCE30FPxnWJdHw39+55Zb7yD5okMUrVGBwewRm
         jmDKgU0KONtpwh2vQTgfCvVLL9sw4ioJRAm2Ae7h9ChVpQmKm8dyVlp6irEYx1nQHEsH
         4aWxvRx5dzbFV9ZWKF7W/EftnLUvIL+yrzMVuj/SmLQT+B0qeGI8KlDJoPFcLWKEf8ts
         qQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761175795; x=1761780595;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
        b=YxZAsp7OyjZmng00Rc8/6vYHaegK42MxgIuP7LNg7VAB+foZ6mWGVjZvm7Eye1auB6
         nqz5fKZLhpIa4tssu7wc/R9TGny1G4xsh7sTQKqi8N2CDhoQ9cqgNyyvIP0ZM59jLaf8
         0b3Pokpg8M9VrzAvLS0INaUPvCQ/QkOZRdryNUNyjwyoJ1t7q6x1Mh6LDajCGfgp1eYX
         vzwBQiGb6u1PG/pBw4OINAbhvkvL1GSRhlcbHmMwLA6QBAiQlV0DEOgJi00LLpSYR0oq
         zhhhuNtK3fUaxrVs6gmaHp7o5XM7WtCy6LKu/6W1l/A6rSYqNSGeilrxHFOcm9FsOT6c
         0JTA==
X-Forwarded-Encrypted: i=1; AJvYcCWqEVKoHUkvsfjF0LJbDl6heO+yb1tYmmcJrLD9pkDqd1nSizvhugusQMDURbpCvjMi7/wyGbbfhg==@kvack.org
X-Gm-Message-State: AOJu0Yw0k+SLyLXz7E3UdU2a+8iMuqhFJR3R88y+nOit1wHGaFiYgC6F
	Ewv88mbanPwDRlYnR/7Kyc1uxNmaWSvEWNTCmNPsom9uuYnbDroupT1n0sTh0bNqtj4=
X-Gm-Gg: ASbGncv/aVkfIxbrWrV7R1Kh0RHE7/dzKZmNRVATBMmMbM1OpHp3wiKXlT1wmlsl0xS
	4NFmO4tRhmmd4a1QCzJFqPkQOs4IovICJjhFOt0tNpMNLEHiJPnTxnlCV7zDan11Ufuuwpeoub6
	8yg+iqJqa4lyxV6Hq7rSFK/SpwbKREyY20MUwDrkTg0AdMsRyscT6gBTUZbq4mF66QTpNlPDBUI
	7pwMRsDe61yiKhbv86ZDezrMDa57FQ7OMcvWWvZddDhHpsaKDH6m8enBPY+gM4zrIN0UJLMW+aq
	DNQZb27nPbquoRvImFOunHYzoAXtEDMZ6/1sMpMcqO7gqbO0rY6PYEgarDm7sfP46vgNpAa6EKm
	Ri0gdj3nZMWUn0UxsAE9/8yDQ8kIbDqOYyUBPV3gkc8qmST/PaFUcCXqHvZoOzyn8ktlYBGDNDq
	PT9+5Vn2Meog==
X-Google-Smtp-Source: AGHT+IFYp0ny70CA4NAOgoFbnGMlXPyOpppEdL0vT/v/zgXSwVQA4g/6+fINYUYu1VCsjkOYj2gtog==
X-Received: by 2002:a05:6a21:8881:b0:33a:86cd:1553 with SMTP id adf61e73a8af0-33a86dc7f16mr6439638637.12.1761175795311;
        Wed, 22 Oct 2025 16:29:55 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274dc12b2sm392646b3a.67.2025.10.22.16.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 16:29:54 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 22 Oct 2025 16:29:34 -0700
Subject: [PATCH v22 08/28] riscv/mm: teach pte_mkwrite to manufacture
 shadow stack PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-v5_user_cfi_series-v22-8-fdaa7e4022aa@rivosinc.com>
References: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
In-Reply-To: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
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
X-Stat-Signature: rf7w4io3wfzdg519h8cjhs84r4fiw5ga
X-Rspamd-Queue-Id: 63963160011
X-Rspamd-Server: rspam09
X-HE-Tag: 1761175796-906417
X-HE-Meta: U2FsdGVkX19pbDVg9lIOKcYvqwq6uMQt5C9X6wehXUIrChgkrf+n9IEHXQj3e2GGO+ENPgVzKB9dVgYMVor3bcwnahqct06huTkKjymLyl3nHqtTsHvmke4qzl9RqULHzEY8JbNc0cEF2WEIg3QpVuOAYHyF8h6NcxJXjCpJE/IxwOBvd0tGjkidInb6T+3yOWY+up0vVl8iH76XMQPeCsCmioyfd775YqkEDRLhuhwPhZOr/05jExTlM6TkPST8KA4kHlohLqZ8fH9ehlY4qh+Sfakhoa0bbLvW4s+f0r92LEvniZmkV3qe13zjQ1bywnpDKHNkZEowaZlsMMiPoT/zrMHHw8NSMIp5uLS/pUOi+XEdcR6k3tdixAk8oQblgZXFyUiCI9xuIJTGu/ntjbWBapitJ7qvnqG7aPRnhz4ImUXlKXn1BM2XcLGEUbs29RMupmsZTzuYlAUMG8f9w3M/T+xBFgMFIVvNs90SpzyPCicXS7pPXNownmbZZAZoXutbtSEfG+ff4tXNMHDeA38w/2a9w/h1n9lD+ckP1CoyvGp6LS65th3oMQSdjwdDBdRU3b+Lxuy2NMdRx/6plsMXL9fMghzrv6kXydqAlQIRDzRWjbv+IZbtxyShXJF9adpmFhp5Jl512F0TweRM2OR1fbYIMmJsaTDslYx4crU9RpHmJJfXL5gi+liFhaquimUSx6XHWANxNXMsirpx4QOgsXwJ2/LFcu8+BO+kRXICCvXnJPBI0f3Q3i/sHeGi6G1kvfJO9TK4V6uY4IvuqyX5tRqCILY4aYVWw3z+w2bXofo+qB+6wESpsHNrNQZTwLxfXugkjtOfQmkSdWxbXIjzw8szU2/D/LynDHbqI1ghNTYpYsbG6tuKPQPcJ8Bku+paygO7nC8rcP1QMoFP8RFZwt2h6oYQaKeVi7RbWT1nWbndF+LbxqfvfruG+6g1dTlijaEwq1OwGxGcevG
 T00k/cGB
 mVLh1pi7OIckG++4X3hPkeS/ezL7vOoqEHFt/Hux/eKgRDugT7QRBHlzCZqv+Sn4xGAIwgdD+ikvgDeTUKe+0VVCWGWyzjovj/76M7/kLrz0OTujjLxayZbsZUaIEUiy22DCuzjrvMQX9eyExRBbzxMl7LyGDRMmeq5m53NqQIjFS3gjikgexECH+LDGBN9vHv+gK/tmyxlkUK5V9a/8iA96uWTFjv9rxq89tY2VCK819c0LKoht6PSetZ0wabXd80okB9ncJN4BXH9DPqwis/sKN2ymAz8rY9G9oL2Ys0cTP3GNX4XNfoZlrJYglZzeCz5hvcHBzRDPM8xYuZeg9IInYgLKefwpNvLoA6Up8ABwAPTNf+nz8jePjeP5/+4BI0rh2WRSBnAOs8XzPIry12S4P29iN0Lo554rwyJN2nYvfrj5Sxqdsswyvr7My40NNcNjMUZ2RamsJjbSvvRBzeklP7wMIuKs9wg1ROZm5NmvplT5h0rVSKPg0734gW9GhWOHKjfN6PzbaxxI=
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
2.43.0


