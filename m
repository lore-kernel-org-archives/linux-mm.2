Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DC9ACCD19F
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E088E0005; Wed, 15 Oct 2025 14:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9E288E006B; Wed, 15 Oct 2025 14:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEEEE8E0005; Wed, 15 Oct 2025 14:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5E4D8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 842B2140278
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:04 +0000 (UTC)
X-FDA: 84001147608.22.25A77B8
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id 97DAE1C000B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=ggBZaJb+;
	spf=pass (imf18.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
	b=teP8pYrPTebnwQ+09ga/naghogdLaBd2QvsqScZ0Z8zuMb3Tc59pfWPEBfodsWYi0v737p
	RYkppCvF4uXuX/eKdx3Mlg/+y9pySa0Vhca5nBQ9lLnMMMRIgo3EjgbIyYkH+eM699+Qmr
	V6k/ZC1BqfgS7UP0xYTQg2X9DKNgOWU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=ggBZaJb+;
	spf=pass (imf18.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552042; a=rsa-sha256;
	cv=none;
	b=kAyUn8sf2IeW3eWajdcHXfD1zFmAPGl3G+JZlUJjHO4US5sIGCJ/UDwIk6zJTigXBScbRD
	E5gRR5tTxo+/+xeuBxEfteNXlbts9W36F1z0idmEgG3p700N8FubUang5BPCk9DQecEfFs
	SW6hI4pB4VvWUBHm9hReKUbmQD4YkfI=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-782a77b5ec7so6253543b3a.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552041; x=1761156841; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
        b=ggBZaJb+/bgMCEQNuuWZ+TEzGfsbW/ZvgmngTiZ///fh0HPw8wCxGjCzE9dfpLW3Bz
         cM45uR07rPKuUuhhKWOWoFZv384mV1hyB6QloV2ILyUH/89Jgy2ylxvUE41/J6UtqZtV
         PvVnvfrVda9+Yxp4B8r0Rrgw7yiiBFo5oDm+nh+ldp4k2naF7YRUKH06/8gO7WPYqPbE
         /bpnV3sae1O/uQFixr841P98tUYA9Bs/dSohHS078+KCCTBndk5LZ1UkMLjfeDmvde1y
         cnIzMg2uSsZXH2i3GArZE+8J7gCd26VXaZc5m1fWj6OeQYR5mIqOldCY89aOfLX7t9/V
         TeqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552041; x=1761156841;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
        b=aoIZHXSv0m940Ip0Q5jQWDKLmSqkHDbCe6nw+7z8SwRcT6qPXPGiE12+o/XeZjFeav
         rYvr4CFIbAM2zmCY7nHyaXYuJ38R0CVCNIg3QPu7bWAkDcXeDWAiln/XetRTACaLCOMv
         lqOj8IJDuFRIVVCR6pupABJ38EOZ+V7lavKnAbBP0wGEY47DFySlYxmwXab8flImACqH
         dx8+81ESUfLNX+mB68ikosQ4HulCaJ/ek1NSr3ABQnUIbUQy6ufmutDmONI0bGwmWiMW
         RFqZMx5H5E4Yg6z2ZNIotRJK8vNuG3RFVCJdXZWz7dlPZ+RIurC7vCRREWlFMGh2z/sd
         ysQA==
X-Forwarded-Encrypted: i=1; AJvYcCXsDxJhB/9Pc0C2SQO/KRXkEO7JsIiEXD0C7EvP7/8rUli3w9wbOu/NupV4Ah+ILlSHRMq1lIzQ3A==@kvack.org
X-Gm-Message-State: AOJu0YwBBNUG0iZXvueumvCU4p2OlK4t5UPWryUbrx9JVdKLhKriueCi
	irRxUDemU/wtanhNJAG1fvUR9TUGjWskqib5BmxZ+tw0IyiweDpUdmV0rLakaXG6Bl2Ge+DyVA/
	8mxCN
X-Gm-Gg: ASbGncv95v2U/JLZvgKAA2iauBlCfFVPVtw0KrwFgEHSXtDFhLreV5TMbCmr9q/c4H+
	awICle2gZLYl4NdTRZBQG0cBUkXDL1nKA1ShafdnmW7oEQj0kAt/9TAFdZx4Qf1tnpqAtIZkC70
	BbZYz1I+aOr/NKLQtiXCZXn6+2lO5udI0qncBGjrEOOKdoaHxWCrlTAU/VwdKysH7xCBEttDiZx
	xtPnv1kafhkq39GhBXN6Y1zdIw4PStLN3vEBXwzvYFXKscw8VQYlC389++Flg3rERzISkJprECd
	DWAp+wWIOUszI7ucx7MDI1eGSaogI6wZ1m7+0ESNUWA58zv3doaVyrcSSN6oy8W2NkwY94u5fHY
	7X7noyxljoeEb1KpZnG4HinYywaReS+zi17fGVfxEqGr5FpVk/4mCXBCyXHZPBg==
X-Google-Smtp-Source: AGHT+IFrOG3ULzvwQS6yNdWhBAVzXbLv96KEjuoxMPCKu397hcHmuMnjPrfbwr8q4JTAGI3XJs0nvA==
X-Received: by 2002:a17:902:e784:b0:269:ae5a:e32b with SMTP id d9443c01a7336-2902723eef0mr366261105ad.13.1760552041166;
        Wed, 15 Oct 2025 11:14:01 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:00 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:40 -0700
Subject: [PATCH v21 08/28] riscv/mm: teach pte_mkwrite to manufacture
 shadow stack PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-8-6a07856e90e7@rivosinc.com>
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
X-Stat-Signature: 4gceta788ijh1c66gmxrqjtfzu4ott7f
X-Rspamd-Queue-Id: 97DAE1C000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760552042-625378
X-HE-Meta: U2FsdGVkX1/8/lX1Xg5IeEQsiszWdeYSM66Qw3NJohQjuJh+whNSoumjd6/NWjoPmNBQzpt0Q9VGwBpD5mRkEiwqhChbTz9Tw9rfWzl8doEjrhtWn44kiyavNmkOJInLUNw9e4eYqJNhtxuQjjeyhpHPz3SLpm6dlgx6mmfw6+ZOnzsnLQAMfrvK2TKvDfKhq+7dIT25+wUNVHd6Jl8xVOe9pIArZqX4FHkCmoQa5+qzqKr34Joy6MZe5VuWDeY/59VMKQQ8Vu3CzipvkYIG1vmqIuRQ0SvbV9f7TskAiJ60iJnscr12KnN1EwirRa8PBf2+/vZ95HiV5lzJFl00i9+6RVwEHtVvaIwAT2cv9YjKRLUvYGBwoGOL0kiwNE4TYzlG/eOAQS0OlbWCC6WfI6l2RHKu3pX6CstD8ocpWgAJFrS/B+h9fWcmHiZa781e1RVGKyj9pdv50Z71jCpSUNJstV7L81/7/+ZGqyeFDQnoG9S7Ri60Vz3mtAq7brPBigY4AJqgSLATVXmEiG5mBJY98NEn1d/tCOJrCttKDzO/BOLc7VSwVh+j8oEu6jAWA5A414hFFhvhA+aGijGOceiu93fJtVyFIzUwXxe4+YINXbd87/UaU6QmVSCqLqdNnTt4M/GNnT8b/8AqiLfc5qDXXaWCJ5Mg5pd0xUZd6XU8EcmoeePQK5ahnW2P1945yCTn5y7AL0UYdV2kx2Hngi3l+5lDqEi1fUawcgHJewP86FFGKa5hiGh6+zleciOsfWa1t73Os0LKc3RjdT1VtBAD0NpzMuZQqZodcrKM+b5F8YBe+x5ZbYn9eGSnqEfCPiRx4C15zXxQ2d48uidb5X5NO4lmhDF39l45+pGkM3Qu1fssUkCUF/SnIZX9PcrHu+FVGEEUHcECVCqrJ8zPMpONLOIJziX3/Q5nIpVqElcMLfNKisV2p3LuBokaeA6GT1Escq8sYLez468wKqh
 /jLhyuF3
 aR9PMPBGGfYuzhKVyfgsqv46f+dQ7of+XzCHu+bJCf9BF9TSB1Vimxmu795PZT/YnH1Jj/myVSaydVd5Bfk305kuPQorgqrZBy3OMapw7f/lRUBfleD0JAn+gIWd2usnGGnKg6GtGQIYYpIJB+tKfFkpQ0OXpexNBwJMp3lhg39dbYvAd2KZbheDaRsHYTOhcDCM97sxzuYNWMN0jk376O2i8ZWY/X2FYvdFA6+rqNhIFEgyRvKve4+JJ8SCyUc95KqcQmscqOsmXkrq/Na5tm5EWN9JVnmCeZmxCBMu9fVptAmSBnJqnRMbVnJxgkXRRteYbAP7OWaJCUPF7lCY8qL6hXz0bz7DzLlynjbczRKYEPl68MuxHSMHC/ZB4V6oRN4pbr13g0FVAvYG1kR/l2C4Qn21XCiGnxTZYr1eORYFcr5QCuyzxAWkos3Z46bRuZxu6LQbae2PIUjSub5XkTkDCht+x5VMje14JaORtKToBxJQwuB48I9QF934sYOCsLBEkw/y2OdsDqzs=
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


