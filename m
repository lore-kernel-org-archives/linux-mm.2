Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA1DC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E3118E00C3; Thu, 24 Jul 2025 19:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6518E007C; Thu, 24 Jul 2025 19:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297168E00C3; Thu, 24 Jul 2025 19:37:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC518E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:37:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCA6CC058A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:19 +0000 (UTC)
X-FDA: 83700771798.22.B19C9D2
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id EDAF3C0005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b="S/pds26i";
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gkm+U+Z8JovOoe8ArAZBSUqCVEx3YFZYKLxHXbXYTzk=;
	b=IBIYYtpecLUInkuw52TCei/3CZgjxmMzIsFtiIpdcSjfpoYJ95HJCzu0FcDd0NWCpfATnR
	JM9fdYOqgaZXS2bZ8KxcCwTXIs/C5Osw0bebyMbl6klDoF8AxpidpdxgSyd521OYsFSozl
	rQjfmQTyxPLdy9imRiRKoF908eUqm2Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400238; a=rsa-sha256;
	cv=none;
	b=Ze3XRRhTwtyvAFmYm1MecPQ5U20owe+UJ2TL17FR8w2HyRKFV2Cnna5WDEeb88TSUj82Ji
	Vcue+15jRKspDOo4K5muKiI7viIm1WSa3kt6FDM2lPoi8VepIWdT8aExZTWMVWHRhuEKez
	9Ma6hRiswdwAV1fbvfGKaxAcmSl7+qs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b="S/pds26i";
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-23c8f179e1bso17966365ad.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753400237; x=1754005037; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gkm+U+Z8JovOoe8ArAZBSUqCVEx3YFZYKLxHXbXYTzk=;
        b=S/pds26iwddS3A8mA+UCYQ7D2Fdhc1GPHp+yviaTe2nhxiO7dDTYPoDuvvBriPwws/
         u557R8gFN57K60aHH9W+UQwo7PYEQ5vBLder1x3HEdBdz93YonIhM6RstCDcwWa8Rmut
         oVw4NJaTGh2H8o3CN+SlKPbaWVk5o5P6u17YPDbpIQIeytN4W4y1hrQaJ/MSjwzDryhA
         av8NI7j1nJUS/u4s1LHDMGivsCWikfHsz4vM2u9xkXMJpIrTKkuce4/1A5oNo4yFB34/
         bBWGFpiZJStWGzK6v2EjwQhQ+d3s6brq/0GewkN+FbeA3XvGifcbJhSFYuy5krpW4hDf
         RNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400237; x=1754005037;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gkm+U+Z8JovOoe8ArAZBSUqCVEx3YFZYKLxHXbXYTzk=;
        b=HpeuQvqAjWWBO8FXCCDDc+xhRWlUDQCkpGGVNPopz2imXix/fk6mCwast5KLQkuM+N
         LEZGMckKjmXrm3QK/4+ievBZLnhEXOOrfvoghP86U7Sewjq5AyFcvdpWvHvXQm2JAWTm
         5UoEh48fAvZ2sq6c2VaXJNFXHEVVOmu0rfmd7+1ZcQw1lVC41aUb4sEOISpS+ug/zJyG
         nrodD/+Ik9oqRQkfkDf935yl9gwWZOJGcOCPbP3yeH7xjkumcHqb9IqHTOR3fz6DENkI
         YRNeF05k3qOyOp7gCbEU0ivDuqjgND6mPvFUtfNnfif7aBYUCF3/DIuTT2yqD7SIR7Gs
         EK3A==
X-Forwarded-Encrypted: i=1; AJvYcCWG3zDpazdps53zAJn8o/k8PvFBixT2aIofoq7PFK4r2aFqE8ySbfe9EGO9PP6S3hLQZtxQEkdmdQ==@kvack.org
X-Gm-Message-State: AOJu0YwCWspc+h6/vIFxEl4C0GN7CaToW06QLzcV4NJ62ORfMGFCGx1z
	PfrtGU10q5VyxMQ4P+3pBoEn8KqTyx1hPw4u7vjcs3Hdzv+uWn4CJj0A+4jx+JgyHFCWeAyqO2K
	B7skS
X-Gm-Gg: ASbGncubnFjXD/EsD4JoPDK9ioZDk+HLWYCkdDojs6E1yVFC73RoUxMMc52BS6YuANT
	r2750VhG/YW1sNtf6LEenOzV/sYkhqYwrCxlYouXypGsBqZ34mpFvljIty1WT7KHiisVxAr3CqZ
	zrqLN/EFNRkLZU8MbuHP6JnE+TWCm4PDHZtHVmm5PdxnY85PGxPEqJm52I8UyAijSmg6UlSsO6t
	xx+sOT23XZqNztT2dSEW7JFP8xdpxRAc96NfzUITl5m62P/FWE9DIUWgNPqTVLrd8R9tLp/FMgF
	cGg3MVgVuw/B2OXMVJjVHYvlCKxn148J7VktrBYIIcEEPg0Ju5G66Oflz9Hnxyj4a36uDJDnAiv
	d/h4+VrtYgU/1pwNcmMzBvJMjunspoVEn
X-Google-Smtp-Source: AGHT+IH5SBpkVu16UrwUXGB277v+OXuJbFLj21IH8FU8jVfnMFq+cBM3PPB90wB16oPa9iIZanRWnA==
X-Received: by 2002:a17:903:24c:b0:234:9094:3fb1 with SMTP id d9443c01a7336-23f981afcb2mr126281075ad.35.1753400236613;
        Thu, 24 Jul 2025 16:37:16 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48bc706sm23598685ad.106.2025.07.24.16.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 16:37:16 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 24 Jul 2025 16:36:58 -0700
Subject: [PATCH 05/11] riscv: enable landing pad enforcement
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-riscv_kcfi-v1-5-04b8fa44c98c@rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
In-Reply-To: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Monk Chiang <monk.chiang@sifive.com>, 
 Kito Cheng <kito.cheng@sifive.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 rick.p.edgecombe@intel.com, broonie@kernel.org, cleger@rivosinc.com, 
 samitolvanen@google.com, apatel@ventanamicro.com, ajones@ventanamicro.com, 
 conor.dooley@microchip.com, charlie@rivosinc.com, samuel.holland@sifive.com, 
 bjorn@rivosinc.com, fweimer@redhat.com, jeffreyalaw@gmail.com, 
 heinrich.schuchardt@canonical.com, andrew@sifive.com, ved@rivosinc.com, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: dejmbimzgfnqgetwxpme7sxw7trxrj4d
X-Rspamd-Queue-Id: EDAF3C0005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753400237-95230
X-HE-Meta: U2FsdGVkX1/78PDqsSFyQunzD5qlctv6pdXjREF9r9oDREFyJSQXsW9kl5bvskMyXHIKVssdJl2lUlo1tUaG+B0p9UoC9Vf2jul+Q7KJJM0twOm6kFJavyjBtRxIeihewsP9mIG3xAmRIR1KTAnWYNL7zPzXD/vVtg6sE54jfxwc03DEBnud3DB3IIEzLZHlb2I5r+pHkF5l/UC//Pon1sqiTbSqomIGQFxbhch3J3O5dLwDHajw9LbqpGynPkwOI4vCZhqZcAB/mJOOApnX55b0sdiLXef/LDZfkRRrpCOscwypbnyawoxb8mviv7mokxnhJx+txQ7T6BPBXG5UjenwRWEpqE0P9XBmTfWDq584vBWYasiUb3xujP5418qZzu1F96AqvJqm4lGHcv9bXx0m04CJNe9gLoOMGyG7JfVC/oLjkegq5nJhNYeXTI2lomNJzV+z0PmyxCxJ/BjCRUbyUsRvdjK+OA/gVIDf3sfOx2zBuBlcv72t1a3A/NlKqL8pakdu8O/mdm2CfCJYiJJkxqFS+aWG0HVg5iv5ozNo16aQRpB9EZBbawqqa1TNx9iyfGdazJTnt7saA/VIN8WsmJlm/5yJ7BbyyjXq8pFRzx+nVdGhmN0qUHqikXDXFm5XJQOuo01AeP3vZOKgAvAazY2H8LYpjdU9kwhl4Qsd2rzJSh/8mwqo8mHRudsoIrKL7DXDiHLDSq87YjZmNKX3eeEwN7lJXt6AzS3THGeaYgjPurQq1oaXk8ExpYWyIJJop/p6x4xj0Po6Xcwr1m509OhEKFlhLDfM+xuzsT555ZQjVQhod0XpjjwZ+CVrUjxMOPTf1e97R6kytK5AUAeFyCjeRDxINGH4edNpHedbs16nvcCJDnKbHQCNho1xj0lpd9IwMZUFJcPHC499rXfZ2XfccuEVtYeAWj7MZP1VqCPiGc7XNQftfbsLmIHnY1V85bgnsuviw2N2f8/
 0vMDy2hk
 xOPu8FHsnZpifixO9IIPHVJpgCXWChr9pqAHpiPeWIJWvAQ7cT8ImzV2dOdZ1ZUYbO+9fFV6VvqTxBpU6LqG2vxsVs31UB8mzIvjP5AVSOwEBPafanje+r4dBDRbvtcFCowmV1yeFfO7YnOyUv9TWz5Q8FV08Mb8yrPbioTlhLssDXU78HplTM8PLkqOlCsHYVY1U/dKIaAI90lq3cwE2b05EHHCT62G0fbcAouzWLFL8uR7yJ1gWqfrsVikmPnrh4w+tYaZBslnusn4tSq3HQBhkNtuFIM8P+X4jjWjytvMa6vQ42VKkhsx/tV6+DQuJw+RCtJUefeIK28nx3V5C/w7V7W8HgeL9x4XHuJyElYeND/9YMiCkUCJszja3CkE6L9dScVujGVXkXbzjf0xAyVEpEySkH2WLy1NUxO9vMmn80QNHUeIJPeG+KuumNn3baUSTcrh8hM2b2w0wabcK581OEneB7VF10zr1AyfORMGAX1IDrLz9UoelAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enables landing pad enforcement by invoking a SBI FWFT call.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/kernel/asm-offsets.c |  1 +
 arch/riscv/kernel/head.S        | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index e4d55126dc3e..e6a9fad86fae 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -536,6 +536,7 @@ void asm_offsets(void)
 	DEFINE(SBI_EXT_FWFT, SBI_EXT_FWFT);
 	DEFINE(SBI_EXT_FWFT_SET, SBI_EXT_FWFT_SET);
 	DEFINE(SBI_FWFT_SHADOW_STACK, SBI_FWFT_SHADOW_STACK);
+	DEFINE(SBI_FWFT_LANDING_PAD, SBI_FWFT_LANDING_PAD);
 	DEFINE(SBI_FWFT_SET_FLAG_LOCK, SBI_FWFT_SET_FLAG_LOCK);
 #endif
 }
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 9c99c5ad6fe8..59af044bf85c 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -185,6 +185,16 @@ secondary_start_sbi:
 1:
 #endif
 	scs_load_current
+
+#if defined(CONFIG_RISCV_SBI) && defined(CONFIG_RISCV_KERNEL_CFI)
+	li a7, SBI_EXT_FWFT
+	li a6, SBI_EXT_FWFT_SET
+	li a0, SBI_FWFT_LANDING_PAD
+	li a1, 1 /* enable landing pad for supervisor */
+	li a2, SBI_FWFT_SET_FLAG_LOCK
+	ecall	/* check for error condition and take appropriate action */
+#endif
+
 	call smp_callin
 #endif /* CONFIG_SMP */
 
@@ -359,6 +369,15 @@ SYM_CODE_START(_start_kernel)
 #endif
 	scs_load_current
 
+#if defined(CONFIG_RISCV_SBI) && defined(CONFIG_RISCV_KERNEL_CFI)
+	li a7, SBI_EXT_FWFT
+	li a6, SBI_EXT_FWFT_SET
+	li a0, SBI_FWFT_LANDING_PAD
+	li a1, 1 /* enable landing pad for supervisor */
+	li a2, SBI_FWFT_SET_FLAG_LOCK
+	ecall	/* check for error condition and take appropriate action */
+#endif
+
 #ifdef CONFIG_KASAN
 	call kasan_early_init
 #endif

-- 
2.43.0


