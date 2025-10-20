Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4498CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:53:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414FC8E0025; Mon, 20 Oct 2025 16:53:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301B38E000E; Mon, 20 Oct 2025 16:53:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17C968E0025; Mon, 20 Oct 2025 16:53:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F00E48E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:53:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE3741402A7
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:55 +0000 (UTC)
X-FDA: 84019694430.04.5989A5B
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id AE9C92000D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=dLpeBV8p;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
	b=FTt/nl9Ww9bCFjoHFmqj7atBjF/Z47JGGrh2KhQ8S0cTrPRm8+Atqxcqroi5xgx5VB1vMy
	7jjqz6qVYHCtQzTTsOhCKzo22NJdzkhwioAaMm5divyIuzJ2+Lkrvn1kIx12LywuxaG11w
	0k4x4jB5WwvoUqtOrrW6BlOwbtOZ3Ec=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=dLpeBV8p;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993633; a=rsa-sha256;
	cv=none;
	b=Hx2a/PLAXnx6S6YibRUU4gbRuLfbO9SZv+VW7DRtdnVjIQ0DUXgAMeoF4S4DSHxhN5qAwx
	6BKE+BVokeHU5xva7Q+FN4W5p7J0N1ddzgZXxMn/M2ktJJBn6S1yMGt0wFQjDXgp1KCxkq
	NROSeM4tNHtcNBuwdnZJkZZsUX67fqo=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-79ef9d1805fso4455849b3a.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993632; x=1761598432; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
        b=dLpeBV8p2sjWYPnuuelAxZNvCrN7MdvO6HM5yPDFUA8o8+KnNffDpfGECkHwvpvHPA
         Z5DvjAHBcufx9aX+wehqyR5u0/7DLuMMHs5DOLuCK6eQyn3+R2T9u3+ZEcxr9d/VLWDF
         mivWDQ0SW5yooi/IF17AeZSCRiMrg/DjxRVizXxcJmpOtm3+NTqpGOWeyLpknqhGwMKE
         nCD8dgQS27XaQjTMg9hF7IMmg1z1Pgqsv01C2YEYCN3tNAeNY1vTV2kdsdrBuSSzTDSC
         ZwDVytjw+piCRG8kChxDB3RNGW/NFoHG3tuap+U5Y86D0RU3ri1P5gRqyw32j3dhFfLK
         Xj/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993632; x=1761598432;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
        b=N0SwLb4lfuAWFnMFiZawhPTY7y3QBx3Jgearcv/n/z66/YHiOC1LDDJCEDXAA/7Opr
         vT/dmRhQB6+a9kobFvvtMvVUWhMGwPavfeJqzH1QjXei3rzEBoW8Szhr8OqRGDHEAju/
         mgUAo38C0GoeTpxxwIliYPTBj8UNhuiUCUmqZHTi9WhTCHrfv0TV2rzmYOijNHfHEd5f
         80zdPis4ZDQOVLQjzOIGwEXWgay9oYOWRQYyjdFaB6O0ed8YG3q4GkbjdNLj/238jtKy
         fABKNq7rMHMNkx9nEKGaeMLP0l9euZ4Px15YvMhuGxG1EjpGYx0CXzOmKZKKEAoywrw8
         XENg==
X-Forwarded-Encrypted: i=1; AJvYcCXGatfooUuvRTKMMILHFYy/yImlDa+xuHCbgasAhg2Xpxlm7rjqY/tB4K/adaCzEUIrgj9wljFajA==@kvack.org
X-Gm-Message-State: AOJu0YzLIhq09ZaOGlTgSUhU4fsTPcuz/KZrTPpdF0suBQscpZCkt16K
	y53GPO8e01Vjb1WdfURrCJ9WKfEbh/uf4LL0q7WhAuAQdvQrlwXp5ZoKfGiCvMbN1L8=
X-Gm-Gg: ASbGncvNsozifkpOlT3RGtXUmPU027ndWzdNGtnFayZh3EfIsjTlpw/PpKf3dVzAzLq
	0fuAHTVlX3mUnRqUvRhTZLAG/hjqxV0evRgdgXPf0H0Ej2dVeQAgeV/PasDO1VcI6DCn3DzRMpA
	SDs51/QmlNWb54xFywurPjsaMfnVpVCx0tuWtCYxNXC36p1wTMIZdyTspJ4Q4intFgGbofO50xd
	VgwVvU7uOrCi6sEYzRM45qh1iZ67KTT1H8ScEnQ040nAS0SEsVf89x7waWN9RjOZfuNB71Fp21V
	TBXwOy7zxrqyA3X3slGp7CFQzgcwBlgJDwcVapGXG3FtwcaY4uMnr6gTAMH8kWpt2+OSA+//2Lu
	g4fa1u6C+NtVdtYhm0xvyC/rzpMnRw4bG3JosnaFn85vicqtJkOZWcvpIJmlPcXwyk3x1RJZ/Q/
	2YzStMiwbX6ycBj+jna5IRZN3dhqZBewM=
X-Google-Smtp-Source: AGHT+IEnU9JmJAW6XUEpBFCvWbUt/eXN7ETKyltouGiw8zgeBwTW8/YUcqQ1OslTqOfhR53w2pN6Cg==
X-Received: by 2002:a05:6a20:7353:b0:2ca:1b5:9d45 with SMTP id adf61e73a8af0-334a8607501mr19932803637.32.1760993632128;
        Mon, 20 Oct 2025 13:53:52 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:53:51 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:37 -0700
Subject: [PATCH v22 08/28] riscv/mm: teach pte_mkwrite to manufacture
 shadow stack PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-8-9ae5510d1c6f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-9ae5510d1c6f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-9ae5510d1c6f@rivosinc.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AE9C92000D
X-Stat-Signature: w96rwsntipnhx8m1dac55d9k3h6q3qg5
X-Rspam-User: 
X-HE-Tag: 1760993633-448858
X-HE-Meta: U2FsdGVkX18b4f2p17kUNn30atPBuct+J9kIQN5dmWKUB2ImyhLGtl2lWsb5SJmvG9QnWp1MSEowduQiqncFuZJ6O7G8V7b0EfC8QGnjO+XahZ+6vsjKI3jubxtmTRC5a3y+lq7eqEFMHTVt6ojph268O2tKI/S4cOPExlu4TIGx2ZRKxhixMmcpf1L9VjOTLp0/9JmA0OPxjJrYFMAHvTIDb+XWzQYnAjWUSI88XHMt4oYCelaFTqCOzqsvy5MXoE1cLQPT7DMn9bFBN2UrOEKBSyttuG1B6gSSg3P+3dtpgCqQXe+Gf0IKOgUzmICkxckABHhOLfnKlzdrtQnfvkW/Av0dIlyCHWXCNe0yfxN/syFcSjzhhlfYvmktKyLk02h9JTovLptZTmEV+FgVO+WVNXSLeEmNpgwrlUG645JcYZJ1dxENB1XkiXITEOY34UPwVm+WEKhb6Vv2QSDxyfCoYPKyTxO+/vTZ8zQYCHjMZx2ZPRYIgHkd8cfY5ad6r+4nVU4ue6EB+ZeE7D3yPfEjGIMzqLoo4HZIPO+l3DIO5be7rGTInurZGYuvj2akQgO9PO/KQ16rbg8pXzVxKV2/uw+oWsylGyQhOzfzeWre56M94bmJiHpdyaath5vvWk/U+sZH64Llq5aCRvqUkpJK1/o7Be2h/Toil9O0N48cS+fwS7wbke/2AcReefZZgjsEVUHk3UvFvdmmNknCYFetfBoe38JIyOqaf+W3pXDf8eVMeWtDrDy9VNHOqFQfKeXdIO8M//+FC48pVuLbhXlWMLWbtWWT0VWhhrEOklaqjk5edf5jxkohsNE54Wvs720iZA6VqRJiz1SLY3TnGIc+mCZct1pZ7e98r7JSGtbfrgLKFvZstyjpwpUTtYsT4zoJSLmcMQ8uvz7tyDlFCIVr2HgfXqZrFFa44lhqk6EGejIaSct2cJ4JKs/GOOtIQ/aXW+fKM5mIaFsor/o
 z9BOGJAD
 MFZorZptyQ9aesr+a0rAGSZR64JRA3aDOL16+8eETREihaOdC5BU0GIQL+EL9AZtx2VfnkTbpZhlgK5A92mJG1CA6DCencLQ5GI64y69SQIidzF7JkMROyuj2bHYh/StOtd40n3QWOYxEUe/XT4IPRqKNDsZu3wczsi2UazybBQLffAQfBRuEEyBq2IHWmUJCde0zOI6qO7+8RUNglXEA7uzDLRb3PT1B5QEy/9JStO02C5u8JD1aQcnH96GsAjm+7URbfUHLonmGcgPE9jvx71b2S1ZhAzy6g7aE4uSMNAxOfz9DVrZOXj4GTKnAZKeoVlTbq1ElWYNA+5FgS2EauN20wYk8C5WRo+fZfGGkDGMfIZDQBFxYOmXUNJp1I/cYPTMsMAhTaPV0Az2e+Dn7D5EB4iDnVoMWFa9KUh1AdKKUaxrg77nbdZI6yRiqMzVlZAP4M4f+5McGpwz12xopp7vPeEy6hKbUJnO/PUu+IiG8u5zETZik3h2LcboU3QSxKeHdLG6R7o8Wk3DzD3OeH7nggQ==
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


