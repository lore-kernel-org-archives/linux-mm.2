Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19FCDCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80F88E006C; Wed, 15 Oct 2025 14:14:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A323D8E006B; Wed, 15 Oct 2025 14:14:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836AE8E006C; Wed, 15 Oct 2025 14:14:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6DEA88E006B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C2D811914F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:07 +0000 (UTC)
X-FDA: 84001147734.11.BFBBD20
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 26D6A2000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=TRwJ9o0y;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552045; a=rsa-sha256;
	cv=none;
	b=60G3tFJkEdzI0F8CNF5G1QCiwVmROf7QC3dg2JbPIyWmdYwvt3GOierKXLC+4gHZBIs3XM
	BKZ35eNZS+kpTQtrbbNbQ55IJtaP63TyFd6XHJQtH4HFRfIhYZZZlNhYknHfbIGqf83W2p
	qSPEODcfE1JwW9jx9ETJuA/Q7lmirYU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=TRwJ9o0y;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
	b=c4QYisl6Pz9VmE3clVq8b4Cyrvohc1mFJ0PQbwVBjtrPc637S88mnFLvbqkHEDulVPEXRM
	3mg8NGu7HtoaNtxm8Pu9liAOZNAuF7sFYztvJ2D2SH+0ntzwttYXMAyC3aQAPXC+VmxYDm
	uFNb1NAxNjIsSRyo4ZSoqJBDmBPtZs8=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-782e93932ffso6133186b3a.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552044; x=1761156844; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
        b=TRwJ9o0y4TUJfrozzFOo2B0PVzCsat0UiZiTS/MqMBgpYUkGAGaCCddssIJK59c3pW
         03cWoLXXsmRY4GoLbNDafCDq3ccXq7HIo26jdckafNwrI/ZFKZnGG0HpIAoaoGCJaOLv
         Fn748Yob/DnVqY8qB3ekHvfl7ej+WyBFAoXp5B/gJdK6QYMt/fK5TiPNcOYZn5cxD/G7
         onezl3XhVl0cbiUsXShDw9cjHpKR24PtNk5VtIxNuPDfKA7OQkePNdnmTuC7+/Tgcure
         Eq2TT/OX5IkpkhmGFReur6dGjWtWiNqxeMaQOXY2HNlZYSXfXsoWJcYcbF87zdb0+IGz
         /xNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552044; x=1761156844;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
        b=IuKdKkzhZcCy8cFqqC0tLmapvXI2EtNWCMO1xJRgm21gKHcs/3/31Tx0G4B9poLh0w
         ydBWFbhpMZO7bD2tQn/UNP0lxwpFTNa+5ARx0EbU7DCcnL4QgvFAoq2KiclERWbA9YtE
         vloSjO8oPplS5PvCFjx8ekCprIMy7RoKVPdZDC1WWNmlGcTGqHW66ukMsTJYuIDI7HW+
         tyr8wPbeHEk8+lhxzK5z99IR9ARNe0/tGdqf3GNkaon0AnTgE0ZeAoRvKNGgb4Q/UPIO
         Mh7sBLblhsHn/LjzY2SE93vL/X2xHm3Gx5jVVldTYGxeJ7uuRVi8Nafvc8x3hvRVg9Dg
         yYwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNdxHuR9JfL6DGYSd8F/SR6czWhL7w09V95FR0AyddUawPRGI8zVsBDdDCxkPIiE10qxm1+xViYA==@kvack.org
X-Gm-Message-State: AOJu0YymBKd8xJxBJM6nxFiMGOxOm9RvERUFYV8n2z11dOT2/mkoIdb0
	Td2QKtQOvpal0cXWPLaGAPGskOMhoG5kjX/y2Emf+BXtQvWYUlmABtjMNoLCbMCMgOeEu85bJyK
	Vh4DB
X-Gm-Gg: ASbGncuKf0Z14/N905G+Ffb0GLQZOYET5IoZWOTcD7rjQiIbWwaRwDus1Od/UlYBawa
	fGAEl6Hkfe44EuQXiOM9c5+SW1gnxToPjGF+yJo7UcpLNqvgdLd71/l1RRmLDA3hhVoidWzcPAq
	bTJ4HdkmkoXmJ0ss1leiAOfI2YDdpImm/5V9s0YDEMX1LKptUcEM1uYJubv3jc8V0vp8VZfHly7
	/tjms2E0pE94faQzL6srJy/tK8rh+rvA5+F0e61lnZPDcGYnHGNKt8QHsQsCluJ0eQdQEP25xxv
	SLqLWRO9vrgj1iwA3mEzfu6AjiicTrfkVT4oBBYLo+Cj/Cqox7S/npuUzamITDYATX12oxvYLkV
	lM6dYh+AgRPV4bbp8DsUAaNVIo9E9WBEQDU0+2PDVfadQTURg/8cVeOnBqTIvvQ==
X-Google-Smtp-Source: AGHT+IHetZQQxpaUW6Ligrelt0t3SG9P3lR8csbC0fN5hsFXEFcboGQK7fC7f7E0BUqjK+kKMsFmwA==
X-Received: by 2002:a17:902:e806:b0:261:6d61:f28d with SMTP id d9443c01a7336-290273ffe94mr346464585ad.50.1760552043546;
        Wed, 15 Oct 2025 11:14:03 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:03 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:41 -0700
Subject: [PATCH v21 09/28] riscv/mm: write protect and shadow stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-9-6a07856e90e7@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Stat-Signature: fqkwbbixbwt1uqp81zx3n98ckgnfqtyu
X-Rspamd-Queue-Id: 26D6A2000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1760552044-491270
X-HE-Meta: U2FsdGVkX186DI5SxcPeqiNFAdwdWd/H3Kt4DXpEw9sW1TAX0exTC9dNtuPOmsQVA/7dEaF8RMMHDvvXWRC5ZzQCVPkUiRSF9FZYf+DJe+ORXvvRXE3z2/dAEYffGHuKLYp7dc25vxEjYOga8ETPX/V6Oxk4EeuPU9lkewod4/4VmFR/w1g8+4eB6MxRa2edynHSxzDzBPUz0W+IlE8r7uiiCuhVj5q4ehxqBAJW+Lk139N8uxEkZJVoQTTZIyTBQyTRfIGwZ3MP2UNM0i+xiXLzkRocq4n9FB2ABhfetsq+cgGPFzo3kCheHv6bU79bluXTWD7ZslDLX2/MJGmhW17jYNCV/ys84mk85z6PmeMgjxWEYlxGp5U6y9W9mdByWJ/l6b+nc4K3f8XxL5AiPBetWDptPhFn56i5BiTyo7WuIFf+zxZmhR7d1wYTai+ucKCDl2aF7CyBllUJeFIb3dDpJ6LxmnVUmCx7cRF5DNeaxZFIG2r0CZGPRShcyXf+0j5Ev950Mn5YVHQTmAwamz4i7mnRGxwld9MGduHOi1bz98TFtDMeYW1/9EiCev3Pi5kswaXazocd77CGmtHZ3eR/IAtLnsyS24+zPIXi6+zQ6EoyxvP8SFUiW2XiZPZo/qfHqEJUCD40shTfMrt63QRDAXD7KlkFBczaH+JA7l6Lm+k4YunIwKbLCF+c2NJlem4q3B765BQAMrU1chfP6y9p82Vplydb0662qRyoqPHF1lJ1Ukf5T6EVdPE0yXXowyBXFB3RspRXKQQ556O2C2VRSUBQv+g+r66gFxwvRBdc6VfDjGxAzDzN+kjedjexvMMCCZ0XRLHpQNIVk5+YsXjl7lDfy8OYBn/CaySo5iTyzJexYiB/KnAFldwhaON544bgtPjHba4UB26fbyHOmhOQA4KApnNhGHd8Pe6lOwdt2IqwZRqzPmhOqaO7erREu3QRsBcgMQj2UOM1RlX
 6c0BLQH0
 vZLZN7FsF1BF5CHSFJYzSxOCWzx3Z4vfBV4HwaRDFxtczmkBTqq8KAiM3XaGONjfPsbGR+mGfTPAfcLPBhmMKbY5JJLILlkGA/Wd7ORQQZtQ0pJ4RGorcIFItGwBZjkzb+hlISdKgemU80nT3+BI+3U/p7SCnn80TtFA1zxj5SJmHaHN4gsCfpBlsuGJ9wsT5te6nwitJsk2FsKiAisAcoTrg/lLKglDop+DwCHW+jYvfDncFIzIsFzRJk0HhEms/JVRt96ZqE/M4tQFFqUnpkxRhxZEcIKPpyhMnDQ8EnN+aaofnh1hjdJ1g9aLjuYmuxlqO/EbMmEw/MGnXcex/NKP2wL/NT5EiwGpQmPOspH+fZWrrZY31y10oVZWq6XigmF8TYJyfTEvNRVOC9zL/PwRQpMBrF5TS54nEIAo70wvHS9aHCOGYYunvJcva3fHjo8YdVbA94KQ9hHmUqUSPvzNM6yS5l51usyRY5SeECvZIh6RFSYbn5dDP3YbbGkcUl25k
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


