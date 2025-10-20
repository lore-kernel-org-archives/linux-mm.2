Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C023CCD1AD
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C614F8E0018; Mon, 20 Oct 2025 16:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6EB88E0016; Mon, 20 Oct 2025 16:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E7A48E0018; Mon, 20 Oct 2025 16:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 857078E0016
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:22:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24D491602BD
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:56 +0000 (UTC)
X-FDA: 84019616352.20.A052B29
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 68D072000F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=RlRJGBvS;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRwldBzHIQH4g/MXesqTddRa2wH3mKxscowbsdJ3rFs=;
	b=mBSKdzPiAHbg2h4/Jb0OksHVuYYfolNbbZ60DyGa8yyaubTpeuMdwTw/gQV7cVqeLwo/kK
	G26jFeFnmJlNhJC69CSadjxHaABRp5CMv7PYZC4pdY2yffqcphH2Gmz+wza6W953U88nCN
	SOiW2ankJK3wTAPrP3fUv4cdoYKfSgM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991774; a=rsa-sha256;
	cv=none;
	b=FstpjbnaG6xpUC5fLjYmMJUJ2ZrIU130DDdYVbkxvqWSPoShNLP3lD/iRVTIJeHg4V7zOR
	J+YjTNrZ6SrXugI9gvAUZA0cOxM9mTeGlRqZmS1RuQgM1AQAtKzXXkX0GIfbhq1UQmC60I
	QTAEeyB6k9Kuq+do3O8B585PW+sx0yY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=RlRJGBvS;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-781206cce18so4889362b3a.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760991773; x=1761596573; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cRwldBzHIQH4g/MXesqTddRa2wH3mKxscowbsdJ3rFs=;
        b=RlRJGBvSPCYHlHXjrWWdtP7j9BtJfdljdOgERfrKRTNg80QGTZwnEObpuziJo0Y2EM
         LZnq6301DBES6MZ2aa2j0QHSq0OFncDMjyoHDZNblwkx/8FGCPqQTNvtBpg1et5rYyJC
         b2raO5/6i/IKUwviFw3IcPT5Fy3rg9KNL4WtBFYAsPShPSWedJO1cfJcfZMkw9O7AemM
         LDiNQwDv1JMFF6wTVURy8V4Lpx1MDPV5kUXsdi/f2iog6JENjmFmDAhaOBEnFfvKffhQ
         3B7hTc1p8qC4iW4svu2vuFDgHBc2RbvKrItGpuKScklEImPYnFtJAd7FyjN64jtOq73L
         nWFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991773; x=1761596573;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cRwldBzHIQH4g/MXesqTddRa2wH3mKxscowbsdJ3rFs=;
        b=CAF4nTXn4+l1PPXlxzGdaaMbqWzRY7AgGynhcKpd6pv94d13OSlX8EelzxE6RfS250
         OekWRb8ryKEvta+xdpNU2MM5gOFd9sRGQRyisMK6WEjGkeNfE3Z0wgOiLzruUk2+7/i8
         DR81iBgQqhwsFJDavLnXX+Fy5lDvn5h7ZoyVVzjT2DNxwfrZ/gDBjb/FW5el6kxn83Ag
         R/OAe6cY6jqkBxgWxwCQNeUohyuvOZ9uKplxGIWXKqZDSD26uWxNiMUwiNDH2QS8NM74
         QPZN6uX09FvGp/ci5j6pL3/0VoeJtZgp2u4oX4ppgs3ug2saZXc1NFa486qz6KkRegZL
         DiOA==
X-Forwarded-Encrypted: i=1; AJvYcCVSYNKM0i6zwHvKrzTrBHvRgQTdT+3Z5HVr3kjrfdO6VYJBE4yzx8Fg5M92A+DKI1gAIcPhLFsL4Q==@kvack.org
X-Gm-Message-State: AOJu0YxlwknT82wfCQ4SbdGJNevBxfIBx+Kty8e8s+XKuaNR4P/Zgbpj
	4TOLGZWtMPCIhjuzNVozGrmSY0GsZPyy1uGSFn5KuAdAiuxcpYsCad5xkn3jG2Ij+ws=
X-Gm-Gg: ASbGncvFut6y9jmXwlR0K8RZzPTZ/TOBIYLtBCtuZcR3rwZX3a626WO7/ZgrHtx750Y
	UXqkfeMfBROaRzFN0Oo4F23eveqwnGsr0dcwHGlLZuQlSq2SooVbJvKAYpKD5xyv4ehFPClNbKw
	S/mms8GXwqKVed0KtONG3/d85HnrtMPRWMREV24/cldc/k/5lMY4XX5gvccSiJ3kS5/9bRVRTeH
	9A4EPZv4kRQayYTWcQZkvHAmKlipJAUM70iKkfY61FtxmD5OSJNV4Fi2fUCH9JfU2ZYctLQE6qV
	sK4g/EvhcOD2MwnayPLpj1UlSOc0PxeeS4zT1JQV32H5g36M32LKQvv2EwjRo87Lho/j0TqC99l
	FFMXWXzzaWzsH9VpNInBFqAaePdf3sYjoaRJWc2X/JQIxSH+ofUuB74nrEJBNY01LUsc4vyyYM0
	42BH7RcyFXkQ==
X-Google-Smtp-Source: AGHT+IEWBLf7wq6f3FV6257yUouPbLkY/Mk/oWHqmnpiJ0fcsMsMtz1kgTZV512lCf/qTagDTur4QA==
X-Received: by 2002:a05:6a20:9148:b0:2be:8ead:1bec with SMTP id adf61e73a8af0-33495e6781fmr24121585637.24.1760991773177;
        Mon, 20 Oct 2025 13:22:53 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a766745dasm8443240a12.14.2025.10.20.13.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:22:52 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:22:36 -0700
Subject: [PATCH v22 07/28] riscv/mm: manufacture shadow stack pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-7-66732256ad8f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
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
X-Rspamd-Queue-Id: 68D072000F
X-Rspamd-Server: rspam02
X-Stat-Signature: j8aztefde96tkibyo8t77yug9kmk6got
X-HE-Tag: 1760991774-652188
X-HE-Meta: U2FsdGVkX1/c29f+FOfA4HuiHFxpiAWDXFNyCC5wResu/PpDBRf9rVqWu2xD1rzL2SUzOAlcqVzG0hgfk7j5kvrNwfmPWk96DWLmt2ZbpRb3W2XXRoPOpm4qTC1H2A8XOg9xzFMoAqnZ2y+C0T1PNVfHmNZ0BVlbOzHhFAw75UzZenzN5lKCbSfxNKH5/ZBzW8NMXIFMa9zGIhT4QWxwJhqR8enwjfiHHw4FkjEQoUhztqM4ugq28/1Riagzwc5eqOPVlVmAMmEhrqRl1Duqr1kG9o4VIJIjCDfYZeMNIE41xuvhDQdwIwsRXy8e0ydbh8vZfcLlIdMHFYpkVDk9uEQuyGjde+4pZmXEMpmZWbszScGo1rHMWu25nvQ7KGZ1O37b9KZYZlFWpKbAL8Y9RZR3SRhllvHVqQFUSRfaoxvPmYeBBaTzMAY4a9t/9kUtG9eYZ9af7mOX9tUo9fl/LpJRh/Y5P0gxQ+hiNeB0j/uA0tPZ+DvkJCupPmM2VI2lvsr/gCEqY6s6r5SKmWMiR6ayFs5wtWO2JTIoibwNAoRmwXBqj5GE8CgU6Ik60yFTRdDiTIwWMEFsRhxBtmkR4clgwOFXInklQ5XG0rCKSOuHP7MMSaX20DkWzsC8OjBrHStMlCelQ57kyBL8mCqtJkusuiaRXu2Rh317Lp7Yev9vVrPjMKkDGz+H800PPTUBW4wBGZ0FQsvmICDfKZpm+z054wTCoc46ts0+IxqcYQcu1zPxDkbLt+tI6p1OKlB2cUpJWXF3LIYanSh0fLgf8PEvDCRJL5rddBomm5OGkKPnCaPBr0q/0Q6LF5fBZE027nG2nSzz3Y8Bg0cCr9+YqUqqP/ujjaPf6thDaxeM8U+6gHNpmTKNIrQJD7vaatzF/iI7U3C8I7RBP20cyLb9u+DKN7r5BCOYuqi2KJ3crSdDqtrRVL9hIYbTLFwXgfgH9Yu35glXdshXtskTBM4
 dLr6NpTN
 hevfAOfta+lA8PqG12ECLIK5HT+vFpAfiJUg7R0KCMd62u8fauPS4imU67Sflj4r7yB04O2M2Sp3d+YNu3bnqFoObXaGc8ZRmXhDw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch implements creating shadow stack pte (on riscv). Creating
shadow stack PTE on riscv means that clearing RWX and then setting W=1.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/pgtable.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 4c4057a2550e..e4eb4657e1b6 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -425,6 +425,11 @@ static inline pte_t pte_mkwrite_novma(pte_t pte)
 	return __pte(pte_val(pte) | _PAGE_WRITE);
 }
 
+static inline pte_t pte_mkwrite_shstk(pte_t pte)
+{
+	return __pte((pte_val(pte) & ~(_PAGE_LEAF)) | _PAGE_WRITE);
+}
+
 /* static inline pte_t pte_mkexec(pte_t pte) */
 
 static inline pte_t pte_mkdirty(pte_t pte)
@@ -765,6 +770,11 @@ static inline pmd_t pmd_mkwrite_novma(pmd_t pmd)
 	return pte_pmd(pte_mkwrite_novma(pmd_pte(pmd)));
 }
 
+static inline pmd_t pmd_mkwrite_shstk(pmd_t pte)
+{
+	return __pmd((pmd_val(pte) & ~(_PAGE_LEAF)) | _PAGE_WRITE);
+}
+
 static inline pmd_t pmd_wrprotect(pmd_t pmd)
 {
 	return pte_pmd(pte_wrprotect(pmd_pte(pmd)));

-- 
2.45.0


