Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88079CCD192
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35B408E0098; Mon, 13 Oct 2025 17:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3335D8E0031; Mon, 13 Oct 2025 17:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FB368E0098; Mon, 13 Oct 2025 17:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3D838E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C173986FC3
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:19 +0000 (UTC)
X-FDA: 83994450078.03.A69BFDF
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id BEFA040008
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Shj0TprQ;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392577; a=rsa-sha256;
	cv=none;
	b=KWBvSNuuBoKqS2HHBx+cWuNiIjDD4WeLBTA01Fh27ZsgxK3dOTqOYSh4MFlq3PGZdSU7UB
	2qknQoUDpwx24pYxKoUhkx3Dmj7YPj8eRpLnERT5Ab2jAi0umsxBQEeH71X2KgqP6kFRc/
	g3iWhEo5S+HmhOWF7g07fNM5Sp4XmgQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Shj0TprQ;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
	b=nC/iBRJ82YOryRCIPV2QgIlXx4o4JFQCSxc07+yheeopGJIJyDbLRQgq4WxNTajgfi34lD
	l0FLTIJYJ0OZ3LKbeH1IMY5C2h+eekCS1jRhE+AATg9AAlbbcjQXgwdhEZNVJStDbHHqx+
	h9LCH8mb/6lE+YWcbr4uEZP6o7jNzI0=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3383ac4d130so3988998a91.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392576; x=1760997376; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
        b=Shj0TprQIIpjQWfTef4KO2JxsGca3S8uxmtrfom8OrGn5ooA5ZH3P9S9nyzCsWKjRw
         wtlrP5vOb+cPP2g4PaGSacB0SmarQVyp0NMfL8cN/cKzDLkx7xJ5PLNHo0CqVfR3FmXu
         4bS6X6NvI5f9+53R5LY1lHNb0jZN4E/wg6/JH42cfmEPXPxy1EtCXCmbkEUVYz7TJcjF
         Mhay9v3ZfnrKES9NZWRKe3SkLqGbFfPaeIX6Qtl5EJ6oaUo34UIA2vBsKM9TsCKIRLqv
         HAfiiRFxwPLN/ZKcc7W9l3rGPrw9kCs3K67cAEMRMoSNaBS6h6danWVxCxAMT6XriO1H
         hc1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392576; x=1760997376;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
        b=JtzGVGwdGLK5NedqSJbwI4B82sOTJQFUBYRDEYnDj7+7V7It82VPADjFPm/K2a/aeR
         VUIQSLHsUU5Of5ph5xyrlN3ibGQEjo6aLwEeXpAAYAiQi4MGtfMbX4lRoAQ7aSKNGpOd
         zVfFv5AMHBuw2N2gdAV5yorOtp33BU5NRL3qMaaPsRG3uoQEfORAnVeHvFY+k8VuJr0l
         3B3Gxj06eThzsIajQHX63QRbB0lKwBH2bq5w6if6GmD1AYlmaYQoNwJKJiUxP/KveYxA
         GVdKivq23By4ArTL3FPwS+xJSnpY7/nUR4STke0HNi5dhBuhdQPgsVo0PLBFb4Dso2Ji
         989g==
X-Forwarded-Encrypted: i=1; AJvYcCWVYrtyFxS2tm5bgEBdxbhfHz/z5757L9504KMwJdBTRLRVWKBj1lTDLt9NjF3789RTErLKEtirbQ==@kvack.org
X-Gm-Message-State: AOJu0Yz45fMllBEOepaUSLburO+hY4X+T7NKvgS0RbY0oqGbtr+eWUeT
	gygRNUiuCKeBMXIJnRl6vMRk3TmfeKFeLAkJFSqkeKpgu4ES0mHcR9aZlJ/t2lTpWCo=
X-Gm-Gg: ASbGncsYl/uoAAt8F5MByvYVgCmvhPJSMZC50oXB5B3WJ98bJQc1rF17QAyGOV+VoQW
	fj4P6dtguyqA10W+E7KAwzqmiDFRi01RR5eHnF6ibeIh7b3mGgBMkRckfApdGAyw+KO5+eC0TBw
	Kix9YnfAaVfGk1PoCqQjbyDcFp/aw3InAXaybSyRNCuLYDmJx3IQ+FVWQXBBVPBRp65ulZKgaPK
	s1iFQYwnOG62SIJZqQSBDffNp1OtvMYjawJwwrRJMzGkz13/bSqzlzlOzoahr76qkPL1j+Lf+Y4
	EEOrLlhRc5iKjxIkzo+gsqYkK53nvvAFvAPIafYBG+R5eGxkP2JvPq+tRrHOermMFdstWFGDkTJ
	5DA0S9w8pq4S+7L+R9YRlT9IuG7LNDRIEM47Ov7GVFV59YAWJUc8=
X-Google-Smtp-Source: AGHT+IG0kvBEZL2UesWt3Zf4jl6C+rIEnaQvMgWf27eK5kYtzg5PKWU/1867wQV0n3ggQ6xsWgb06w==
X-Received: by 2002:a17:90b:3512:b0:32e:345c:54fe with SMTP id 98e67ed59e1d1-33b5127ac29mr31362526a91.20.1760392576576;
        Mon, 13 Oct 2025 14:56:16 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:16 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:00 -0700
Subject: [PATCH v20 08/28] riscv/mm: teach pte_mkwrite to manufacture
 shadow stack PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-8-b9de4be9912e@rivosinc.com>
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
X-Stat-Signature: gxxhss67pmafby995kms1ogcjinoynr5
X-Rspamd-Queue-Id: BEFA040008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760392577-959485
X-HE-Meta: U2FsdGVkX1/sCmOulUMgweH+Zi9rxiufjgMrFK6VZ3VeOdutW/WmfmEA6P3khi+tDqd7yHywflyJ0BGGZOrW/W5ptI0BviPKhItEF2NseLWHd7WsR76U6qoB8mbDp+0WaCFkxAWdqaInCIBJc9xglEX7CXFofbCloP3+oWrHUl7+4O8n0dwANQaGqRIBb1QmZ/IxB+99EXnYBTNUiYf6DTUc8mUzkd/Tl1QSzS/yRuNMSG6rdco3TQvKKZRVWT9XdD2pC+dtb0OlI24r/EXdrJSa0ZFuD8Do60stjoAI44Rbo0QtfOpQhMWr7F2sZ1vnPrNQf2YhsKYiDFlwMA1g22YmfX7sJeVwDnhkSUMZlRKAo6qRsfuBQ6t6XWcAR0Z7PkHIh1mYPUj9BL5TqBhAR0JduiVnDkOCSC+5Jgc7L+4OqM2yn5tRAPt48eO0XYBKRuZQb+kxfTuRsnN4EZ3+O0Wt7DHEH0UK8Kx4SjGGvSO/vBg8n9kI7jc7cTXbCmz+rNHR8clnXlK62tx5Ujl8cq06ZKcbYawKTiZKVY52MzdHPsX5f62+OqzAzrbtiDY5INNHC0dG4fRhRGKZmcqZYnfjX1bk3TD5aMn/RiPCPXQPoUW+lsyurhnbl4eqjp80bPu8Bj/2zZXpdR759sWYe/6dsouGZaMAtuUK+S8Wb2Ce74NSlTXN/R8Uc7ER2uCTn4SiEi6PVlugoQf4SiWHZB1AjXF5kPvx9YTNRanLEglryeKS2R1sVJFAf0hpmX0LIfLiSiXzgPgyZwkw7PrV30XXfBVdNr0v7duHyhq5sQH0Y9mAejSDweUMUa9ECCdk5hV/uLYhj+aAK/s1psp/A9Wbi8cMdPa1tSeQd+t035JwOAP5TvHXMOnF+5ra0wMF0PN0IcbC2lJxGiVB/OV/y4Z2QfAE8XkG2GDwiShpF0GfCU8JL8ABx96ElJR3XXbfceYkBN88F1zXAlh8W8K
 HKcC8Mrq
 dCnSrZhBcuolh599zr8U/hk08snUaiEEUA+x0Xzu4/OkVp/98MHlxO3olkUEMvIbLqy1Ad3pPFy6p0DMYM0e/Hck1D5v4/SQo5hbtdEvL4CkD6vh+8dFNN44oEfFaqSiRzXLYnhP9Xy9zgZ+ww1mDo0raDa97RJsUPNOcaDECXZel5sFiHtBsrV2i0k2ZKKV4r3QlpeF4cg2BZYkQEahvC0b71GIBbHekY1UdW9j06zMTruTJSEJqaMK94hnLE6m/tEDK2yuszClPrIpUHP+9y/Jt4zZlhWG99zMBLp4ZpGwD2Kf/QFiUXAtjYa7qDoOv8F3dR38GU8UfmF5V0lZdRqC1Dq8akAWqZMuPIHjjuP5z1qdwJtF4cAkYoZLvdaXqUJdGaq/Wu8EVzcZEOPMojYPOqbWaP62pUOfQZAm7Vm0e0Z59obANcQqdEj7J1Gc+25fT2QVBY1c+ntfdDsqF1QqDmh0n0u+1we0JLUuVLI82wYrpDroTHtaHi1ipEwPn1xvgGIjUvOUAPfZpKpuZhiJ1tQ==
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


