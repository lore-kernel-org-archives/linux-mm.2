Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40A4FCCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39558E0097; Mon, 13 Oct 2025 17:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E91D8E0031; Mon, 13 Oct 2025 17:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1C58E0097; Mon, 13 Oct 2025 17:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 767E28E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 48AF71A05F0
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:17 +0000 (UTC)
X-FDA: 83994449994.24.A59D1B0
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 59868100007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=NoAIVwpI;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
	b=ldXtCeMk66ROCMA22ye6/DeOSunSqnZODbNIcvHs4iu0a4/iS6kmbm1gpKluHoucaowAF0
	6dox0+Tgel//22hsLQ2RuMQW+X4vIYrP7ocYplcGm7q+wnB0zWFn/kGETYTBWF1wv51QOz
	x18EBx/hpYRYId3zg6CY69ivgadkO/A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=NoAIVwpI;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392575; a=rsa-sha256;
	cv=none;
	b=hnSsBq0xT46HvVC2WDcDY2HgrxbFCjF/w2lGM9lmRdiYNpDIDiOBphMD/xVM77aMamz7Jt
	jZgPFBFU0yVRxvVvMFAAhgEuYwH5DWIuGKNzNw6uzf0meWmbaCCXZ19V7iFHXyiAw6/1GE
	Izzo7SZ2WzSprJOuLAavzCSYgNExFxU=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-32eb76b9039so5992344a91.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392574; x=1760997374; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
        b=NoAIVwpItJo0LluJngrT/zelY4Mmb6TznWgfNTHaAnT8eyuOwBH8AiXd7g/WZwpABB
         kvJNR+Q+lwnpe1xzcGU7zngOBrM69foKTdK0gMKU8276PyR0S8bbeIsc+913fgu5XB2g
         zxEVzTjfIGimmdkEihKW9KfvaYwQv3PP4PlUzH+eYp2fL031biZylsVI0x7i4wuGngkt
         0tOLIVQ20x2PxdyzE2wy4v4JKKTaotcKmXLeEFVqMrQtr72FhWyKka4W+0Mn183Eh+6Y
         0t4uzYeWrw+91cdYIRVFCtgPpr+acjzmB6km95Jbdx9gWDe+I2Hs/P/gnNyltpt3ZMCf
         T1yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392574; x=1760997374;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
        b=qfyCjrRJYHaI0Cj1I/8SQls3lBwXnZMDtRDvpp/U74PPx7SMB8THYaQCRa2b6bdevm
         lwbbUcGJoyfaMqT6VWfcACzohkCaUR3+y8XLMQgfehejpBvF2373rOjbLHA6LTHMp+g/
         1X7ii2rVdQjk+gOwZloBEoBLr/cCAYUVvqvBVBe6DVis3QSuYcEqHuXgYel4VrDwdSSN
         MocHdAcAz+Of9NthmyFgoLWB1NbjGCBggHWUNcLV8OUWS+D3dYmKQMGS69ULbvrjiX/O
         DD1ct1AEvdh0Zhe+bfasOtH33DVkYWi4h6gwZUjoCuV3e0sxHzAuS609W1NVq/QnR/YE
         DDvA==
X-Forwarded-Encrypted: i=1; AJvYcCWONVK3gpWwfs5mQet3/7T7Aim+XsLYxy5oK7pWU9gZ4HumuB6QD2iYQXQEBeySDCvjSLse3DOBfA==@kvack.org
X-Gm-Message-State: AOJu0YxCSimSEoREMY648pnzahVNtVte9ebrT4WdtAKZBMUtZkh+yX1z
	IeVj5gcdQi4/cAicrurFTgiHAJckrOY1HkJRFbd5ODGBtZzlLVtJT+E4tUVuYFffJYE=
X-Gm-Gg: ASbGnct6PYHTQQQvkvOQNC8RYakIEuWrNM1zWSaXcVwMpeILzxKU8gBxVH9pSD8alml
	eiMn5unjcCpAERmdNLUaVd/jWLkuM9CMs1FjPOGza/A78ChFsKc+Q+ftSbf4RBbD+govioLutoj
	+2+LE+XrAE1WXo5wsuXmR/XYmQUWLdlmfob6zc5C/Vr0ZZ77SXbALgn07VmvYyub+j0XYmO7Kg/
	5491sSrFq+H9LfDUqYxUeSt25/w6sPQ9nyXeK0z0uWdL4qieOXroDWz/slyrlEaY8xxww9qCeH/
	uEcCnD5T0mb/K91bQZSMQ5feAA7xgTP9prTX0nIO3pd8au4elufovhot0ptsjTmB0FacAqiORJD
	9B4Lp45Z2VnWz51lzpjKEgPJaUIajXK6rpYb7xcXbv8q3ibmn/1Zx4iTqqjf6PQ==
X-Google-Smtp-Source: AGHT+IEUAWjhmzUKMOgHv62clTaql2Vz2Fmw36KBCgN93ODbgLaTEoxZmk2agT6d2TO/fNRpseH/5Q==
X-Received: by 2002:a17:90b:3d87:b0:32e:d011:ea1c with SMTP id 98e67ed59e1d1-33b51112272mr33908736a91.15.1760392574224;
        Mon, 13 Oct 2025 14:56:14 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:13 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:55:59 -0700
Subject: [PATCH v20 07/28] riscv/mm: manufacture shadow stack pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-7-b9de4be9912e@rivosinc.com>
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
X-Stat-Signature: qe58wu11xbcf65fksbbuxayahw3i3xuu
X-Rspamd-Queue-Id: 59868100007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760392575-298731
X-HE-Meta: U2FsdGVkX18p5qqO7+o2Y1G6797yHJmOtc6YflDT8Jxrx/aMOUTK4YXe/gfQmMGQ/iVX6U2hVy5E9OJVJ3sbKXbm2svtEUc/nvwxkd217Gsr7bI7AG99WJ8PiMP4+wB18X/HbSof4DQVojYa9s/iwrlahOsgoUvTcDFp2MO1Zz3ta/V2A3gEOYHPc9PBtzky6xOd4rzCizsj9tDO38c+K2FnALrdn9B64V30GY5NwZ6sGxgVPlikcu9v9SK5Eg7VHrbXYPNX1uU+Y8R0nqcuWnz8X3CUvaGi1l5MrS46iHs3LOtq3dZjhC7ChLvVLHe+n//WkLXp6yRzaqt9C6/OLy/Y/gVmkAOiRGgqxdmG4yH/DU37wgMSc2jfksvTw1ZNQ4+BKe4jxaP3D6nwjIrf7YtzslXS5nFgAhbsvxgXADwetmFwfBtxOdq8DsqH3HTvPOiZRtdQ0B+c3aWQlVZFqJQKuttcwMbc9SCEmHJNd0DMEoMX70pah5nNxFlIFMTruzZ+babc1hGGncV0Z6tPnaN08CUixXkmH5iGmSl8b9Sigmb4SIGf1OUggOKmqwr3nzmm5sAjz/DEgk0R6IDQseYD6WF5X3NyDVav6i0ut6SpXvvQYpRMffPRbTfSEguDx+5J3ZW5Y9GcyViccSHqnrn3dFY5QG03oma1Kek6tmUNFtDDwwtdBJKZ5pdzkroes0rGR2M6mQiSCioUjKqCmrDK48HtWDzVgNMddfJw7vbppwHdgjku1hi+gmwfvw86cNHwymUhUAhE0re5KOsnL0ibh687axZXnLmvGmeZtqJzONL9aLspWg4JnDuvZ8rOOH5V0OOddOdpa9sWWzvnajE8F0zKEUBjPbHbYRiKLnG6P1JKp8P21UUMihbLMTWQO6DLD5IMsYOmgsnKyDAOaXyC1L6j0EF9oomhfunYGAOKmI5nK4gZh5VoMP/CjR8kUrko0Nzj6qMDoTb0etZ
 hdJSO0UU
 mwuUMBVaa38aE4Xl1LIGF7TITa/UJCLUgSeS1umCxnr3086SvgSTVOPZKI34fXz/CNNZSTm7bPCLFBGVJyJmW9eaN10c14Wv9Ijn9QGB4LDX/XijqVp4rWNnFaM4PwB0jX9fwTcmN2GylMTahqZlun8hZHMQ8OJEtqe1ErCJ1sm9P56BcU0gdBfBDzQpJDg6c+FRnMiP6GxC76vpEQHva94OczLMh1qwF+yPejpnXMCtz9nXKHLPryK2Z3UrqHdhyq8xYKpo7Uot4f8sjF152M5SWxvQdEwULhQfusn0UfqiSot9DIHjUwg+G3pPipfoCyFKb3TSyuRCrjbJ0Wk9Rf7GvxJkwuNw4UfcuxLuvUzYsyrZ4gYlBzELgpq7WZUeeeHLHFBq8E4hs+SUFPANMehACplaUycF5rbreojEMf+E4z/TXqCLR+gNf0Vdp+f2u9UOBjLnjh0T7/VznW54DZJtwIG224faDovEnPZHc5JTi65+onfBvOHiTJn3ZGqekYa8S
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
2.43.0


