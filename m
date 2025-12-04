Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4725D2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78C3F6B00BD; Thu,  4 Dec 2025 15:04:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 764936B00C8; Thu,  4 Dec 2025 15:04:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B216B00C9; Thu,  4 Dec 2025 15:04:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 57A206B00BD
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0825912C8D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:18 +0000 (UTC)
X-FDA: 84182865396.24.B29ACFC
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id F36B84001C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="bDKZG/Lp";
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qazkzNjoTGNZQrm2wNpnFtC3xWbAXmOxYceHXxLC8bk=;
	b=cHc5eXA1+SXOfO5u9u509IAa1GRA5TgVaBDw4QebUUz61IdItkFyOJUVgZ+G5fF1DgP/yn
	1+ao0442v0rcgMoCdmFBXQYPsKxrtla3YRP5yMci0wBj/nT55bqyr8CyO+cqcEsKdQvVMB
	p/0oggfc76CzAYlXmzMw0ju/yGuL6f4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878656; a=rsa-sha256;
	cv=none;
	b=usTt295QHt6ZdA+qspYGLxIcotyqc2BkhA6YwQcOwy7XMzWwrJRAbanwR2vFnDeVjqrSQ3
	nGnkrr04bOSTII65ZhDQScuUGdHoQiiuSQjA6qNf/JHROV0wnfDDuF/PEjimAv9L8NOLtZ
	wq/9os3H2DLqe7pFhHtMwfLqFGzvCHY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="bDKZG/Lp";
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-29568d93e87so14085485ad.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878655; x=1765483455; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qazkzNjoTGNZQrm2wNpnFtC3xWbAXmOxYceHXxLC8bk=;
        b=bDKZG/Lp5YTCxnQmV/3bZIoGBKKeFQsnnfG0JE+SHqvX3HZT46Ucdfj/1k6YtPnWnK
         YZT9jeGPlrPa1ELEjteIgCRY+fxhIinrkp12VyQNRYuvjrSExAgrKL47Zr4ubfoRSKCZ
         XYLzh8lfBEOtrntLmArqPBojcg4YxQVeThxm6dVfc/2yaTik+0MlBnpFwO67y0qfyoQZ
         CphnlR1F6ioHF739qPgoi+aPEX2RFzQhVlxJyGCnko1Q51WXER6v3T879ofAXMlCc9HV
         H6F6tOjNaVLxZh/81ufnZluyOvVeys98ZbuzUkVKJP4fKP+avxHTk8LCXN82d7VxGOyM
         FpRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878655; x=1765483455;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qazkzNjoTGNZQrm2wNpnFtC3xWbAXmOxYceHXxLC8bk=;
        b=dRzxM4Ny8N8amk59PMA0Ar2uiSKWOCvTbDCT7Sc3efkRVRYy5KFKNV2QBOog5t0B81
         va+5HlcVYBJYwC8+ZWQInf5SCEAb8gpTOOhbBbTXlPx+ehcV0U5Oc6DO/egzNS4XEe2p
         B7osf1NGprfX/5mvu54iUDGb+GGaE16uir3NixAAGkq6Zfdpm1NsYzQvq1ygTaFksByU
         EF2AdWP4MHWXLYyZNLkKsKb7XriXUbN0D7Ld/KTIfIfR+zQwkej3noA8stOKxsVLNYxj
         gbnTIkwnVZX/chNo7deUDq9WG5rxCWgKeULl23enocer/Tm3cu85F3E5jhnCGCCbeGBo
         EjVA==
X-Forwarded-Encrypted: i=1; AJvYcCX7BZyfG1Hz2bZNIx+RNgCoE1L+kFZ0YE1pWyrCOd/jnlRxTuY+iMHtL8uAyWXYHMxuDxbqfLM7Vw==@kvack.org
X-Gm-Message-State: AOJu0Yw7ZhKV4XLK4c0dUFPeCxv7y6T1UhpydiVheImqIb0Z10natjMY
	IBYWF9WC27+lo8gE+L1Eoept0LvOaVoID6ob6VLYk0AGx8F6lqrg4ifkdNP797BSlo8=
X-Gm-Gg: ASbGncsoI+YfzZ1ygDpAgvd24e/+UgbkQiwB5HDN1BtS/zuhF5iZjmIL4eB/P1fm9JZ
	ifVoPs3V+72sXjBs1dIhy+5/AsAo2WV8IpnPaQTVBPiApcKx0hnoFKtxX3b7SSur2OrOJ/W+U5k
	U8UdTT0KvTirz1rup/eGjspI8FWpe6GpnmPu3DiGJFZx05OFV/MJQTQZbvs2PaxlW2qgCvsMiHD
	Jp6PfbcH//Ui44g02Kwup9El4MZKad3mrN0Qty1JqXFTIyRM3jxGsq+o1Ip+qIWbil5FbgazqQl
	0GZrt5refsc3jZxEa2DUgJnVeIcuIB7F7IZ/kJOQQGRcWPyKeyNz1Mw9cNSVDAma1T9W/dg+RXu
	/VtnQW/eKGhtnSg9MzKYtfKuEb+WQ37gGOnVYbjc4LJeJvgaJejWlPgwedi3HVTOwtSQ0MisaKu
	IktDrQWGCcCP9yG3IjymnU
X-Google-Smtp-Source: AGHT+IFp98bHY82tmn1SWytYtV7IsOH4MNT5CrcOIzKcMZAK7rnYCRSLOXMz8X4skJhf2qDKjmrSCw==
X-Received: by 2002:a05:7022:249e:b0:119:e55a:9be6 with SMTP id a92af1059eb24-11df643c373mr2741142c88.2.1764878654709;
        Thu, 04 Dec 2025 12:04:14 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:14 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:03:57 -0800
Subject: [PATCH v24 08/28] riscv/mm: teach pte_mkwrite to manufacture
 shadow stack PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-8-ada7a3ba14dc@rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
In-Reply-To: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878635; l=2371;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=c+59GLf/oXo60d4AM3tT5Dly1CdoHCtus6ztRRar0mY=;
 b=DBHza92aj+k0BS2czHCo1xp8g9Cp+zSzm46DfBTV4xMmhPpMOTYeBlej3lCSUVel0u+uvkiuX
 hMVROXA+6ouD+BJWbNswx6PxOLIYpQkgCDWYd1oT2RkSzTAuLozzwnl
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: F36B84001C
X-Stat-Signature: k86ctoo1k6k8krjijht6hemiitg6t7hs
X-HE-Tag: 1764878655-158266
X-HE-Meta: U2FsdGVkX1/PD1H80nxOzEXPF1oBLwrt/vcJRvAqUK31ypi+hruolL5eeTDibGrAiFxQr5BzkFdIJt9LAMPGBlBbXz/5fXlJh3iH8LS/dI+1wQBCI+3R18i/mxFLvqoJ1wDf6eWmzPfbxOPP09T2XyFW4J59jUy0Jtge5XVA5/3cVL1U74guxkoSGp0//O49udhfrdqxNoelNuoypJREzeY96op9VDgeu8Fv0Felleit+c25BQ7Nmv2JHlHwkvYf/ZWcPAxgZoHbm8B3Qt3byxOfC8lTcm4M+LNhes+c9W6Qp5jGngekhhlDCwnzp88zB8CYub6i9zDsGbYDPmcXWk3QHkt1ouxvjpGEMqRI/kh0MyiihYPq0zmVqsbxfgWelJwFUlaj5klZa9jSHFtGp+93a5tSjUXIea2yvr60JjCr5Ft3wyKDWLe7Swj7CDCEUx4kz6XyS2Xnm9qK3ycfPb7eTsbDOSLB0FPw38Wvi+qlfOuKoOe+afQ7eraLC6EJ0Wp3ONkP/Xo2yaFg8TRk53KeFJKg92E/skxeM08TBVkpZ+4OsHKIG6UkQhghI69MbkPerCpmWoZtm/fImmZ+DTqaLOYfRjCWJXJFnhsTvs499KrGMvADSp6D9GtNEtgToIc28HECQEYAc6C6GDPnG6/geqOFQFbYi3SYBDeALDGi+Y40VqBCnrU3FUEH7CtgVeZo4a1XLNOmCWfb5Crb8/0+PQ3d0MBIxLSyvuEX6nuiLDBVw3ay6CeqdcUhjHs7RjcSVDy0ak7iHvA2yKKsXX+TDijKHI+R2ixXxxTzBF6O/JoGizX/VLfWNLLFfhad88T6XAy2Tkleka+/o6Vz1i0Itht8TDm/h8jdYB/W4Zor9V4AZSLIsN1iGNKZS1T2SbCeLJL20IgKISn4Y2AZhJ5L+8icDzev58MooJIIk6042PNXYuK1oD4X9YAnIw0RjngrlytRxZDs5PM3UG/
 l6I8sAX3
 /bdTA5b/irHUEVDgVdwwCe+AU/zjrCbiLkOTabkc6LCU6sOG+M+SRGBw+6NNcaXTxabq4zZqPzHs160vkQWKB8FQqux8DTS1nK4sFENEu5KSkQtD9Qn7ZtbugbqdFD8bM1bY1RAYzMzk5kAZGurUBn2FVtUjbAlzg++WLle3k4v/HwmERjh704pTBmRI01gveW0nPpkyTOQQ3fNn7jVAEiDLWErJz5bdITpBdqTYxOU88hv/dZAQMiUzSV/PRJam7yKrVcQnW/lD5vFm3iqyenBDKRVO6T3pLF0R7HdDYiuVqPd6Z+t9DK30fS3K8IwJho7RoP62c19jnE9acWPqDhBiRmASB1t2L18jeGiVhPw6I7Kg1CRBpgTXLMPZj9WWSjMX/eO5cf1Ge0FY6LzJqUUe86F/r9xf4LVvjKa1Odv2TldL20p/VK4di2L/Wv9vSs/fdx3CghVNXlJjETxx/lfQ3SHUtb9jevdaIU3gw6pc1YOrhbYNR9wZwECmcgapj7oKKievElMzzK813pzfxYWy7O+AHDcEVG0UzN2TXR1olQEo6vLc+JuUiFJRht+h2RVO2MLUQg2yBm3s=
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


