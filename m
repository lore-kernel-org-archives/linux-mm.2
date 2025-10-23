Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A167FCCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A04608E0025; Thu, 23 Oct 2025 09:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5888E0002; Thu, 23 Oct 2025 09:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82EC08E0025; Thu, 23 Oct 2025 09:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5858E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:25:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2EA13160ADC
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:58 +0000 (UTC)
X-FDA: 84029451996.27.434ACD3
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 334E41A0016
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=cJrzsBqy;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761225956; a=rsa-sha256;
	cv=none;
	b=eP3JLWl52ty8PqnE2vZAOMQXo3h4HBMNWfIpS5HdPrlY1TV0u27stGyynSmIO5bZYFsU6a
	rkiMitBnkmZijBvCxRQKRh5RLslMjMwatVH59XYq3Fv1eDOx/y5uXL5IsHpBXYtShpc+lO
	Zf4rD9JEWJXit/v2aTqEsWIbRSocPDA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=cJrzsBqy;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761225956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
	b=sYfMXhnEwLd4iGa+MvrS4oN7zhhNMQ1/J5xWo6rOcHmf2FMwPgrpFB2Sk29mx04LYr2wc+
	sO5wcp6cdbIjM8TPXJXX4X/QqBEoC8MP6ovchlNuq4RYxBAqS+mpV4xImD9H+K7Nhn3quR
	4tQ+593EWLb0Vtx1ZiaC6JSUHQaqF1A=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-290b48e09a7so10115095ad.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761225955; x=1761830755; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
        b=cJrzsBqyuFJxAiX95KI+GvtBH6ftOb0Z2D709hXQeZAQyisuxSKSP83PJMYX+N1+nS
         FMUKmiQWuXztdR1dcpg1qxEehlqCaDF0Yt8lb5KCAiOF/sQ5xYHJ3+yUKUDAvcvDWlxK
         dysWZdYxRBonJchV8fP6+D0fsS4lBs29njyXOT8jybfWGu3JKQybxJOacvfJxy80On1w
         8qYf67TrRUt5FoQYa9LRbJEkia6BPS8kkXsmd7mTcUC1t7aAYcW2BTgQistB1inPTLC0
         lY935lT5siv4Ci2ENq+dc3Z3vlIHCGoz3NttDRBnOCfXZe026bR5AilWN013xPz5qiQF
         Ru8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761225955; x=1761830755;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aU5JHaPOPUGgukhD3bad891ElerIE5ocm+VeTPJz1C8=;
        b=c2HC+rclbk5/BThUciu1M/e3ZPApseSfwXte/7H6Xr4pmywDlVK76PeneftPDRyA7K
         v2Ev+80neMc4NL7VD0asMRNYE2kt020t4w3eYJKVI4pshlEMcdcc2eF9iYxZrUTWe1O6
         VzphB19a1LI2LSc6FKmVYA7klaK1KXY6Ibs6+iGKHHbXuuh683+1xsBeZAxsE4QfM++4
         MPvunS36lxX91jG9gC33x9wH0ypGP4fguaafDPy6sviz3ub0GeU+ssrBtkLN6gS1Xat3
         Kwo46A3OkfeHh5dl7W0xPepN55XKxvHwPePu/DnojLBe/fMcR3teKF4IoVJYti++/aOb
         vyaA==
X-Forwarded-Encrypted: i=1; AJvYcCW7ryiTnXrfeIY83OpWkmzMtvKvaMPdJgrVcVo6l7yGBF3wReRG3pLmoZmkCo8iSGeDBX4Xi0HSiw==@kvack.org
X-Gm-Message-State: AOJu0YzjG93TygbRcj6Ncz7F6i7ap01+l14nZdr07x2pqoqO10L6CFs7
	KwYyC46SbAPAQ5+aby3sZ68Qg2CLqKTzLJOwH+FT+MR6MObr3mQ5v13u9SlgGjmENmk=
X-Gm-Gg: ASbGncuuRekNmmbVrcyHZ4rxqI5/xdAZwwGGp/MeKvPBYqy6ELRBEclE23oKnqQFcVm
	9Y8T1pcEARrq1+QGk/q5q28iLlQaKchp6K0GXFUDzvCrTPaioBKmUXwuNjnFpObewHFM4L7pJns
	ERMzjx+5W+/fVPLnZUe3K4cr+O2fJoaK3w2eb1QTiHHyC21kS5gmTsFXKbKaAeGDPFJaHxToMh7
	zTbxnamZA9dVM5XubiPqRooQZvQXvOdcsneN5Sqk6LFtkxgC4/z3yjkbPYv6nWlNmxr+XdAIKnw
	vTxMXxinKbDteT0MPTvbGuOLZdRcnVTHiV8EQjMk81sL7/AzGb+gQTiqwa8HL01o2Us+jmXk9Sr
	yOQkShs0UMM/VPk7SAWnRtvEtdrFdXPqvdaiMsXKmjvoAOw/111NHvEph0jqEf/2J8GwXELbe8c
	gWN/QUgiRa8w==
X-Google-Smtp-Source: AGHT+IHdVVJz5j5gdwIs7i1ckupc3MWiBeucKHlxMmPwS/HD5Gcn1QAjsoFkXcbrRaTvtAeB6lGYFA==
X-Received: by 2002:a17:902:fc8e:b0:267:ed5e:c902 with SMTP id d9443c01a7336-290c9cbcc96mr331173865ad.20.1761225955000;
        Thu, 23 Oct 2025 06:25:55 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e23e4b3sm23432035ad.103.2025.10.23.06.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 06:25:54 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 23 Oct 2025 06:25:37 -0700
Subject: [PATCH v22 08/28] riscv/mm: teach pte_mkwrite to manufacture
 shadow stack PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-8-1d53ce35d8fd@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
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
X-Stat-Signature: ig5x6jeau3q3scy65po4jbm6jtcneyi6
X-Rspamd-Queue-Id: 334E41A0016
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761225956-609301
X-HE-Meta: U2FsdGVkX19hF4QhUMWO4tLrDP3SEaH9kEcMX3gWccHx1G08CvsUuqONqArKPYTXsEg5/PszV+CeRM0Si4MlkigzO6jBxVNDX6esmjwfuTAz4oaNfGtyefdgMp2uAXD9JiPSG/6zmIfechq6NLHsK5rhPwzNOcg6Qbo34qfrANtIik6djMc/p879P8ozQw8sz4fZ99cnK2sCYjNwqDu9AJwwmz+G8pbv6wtLa2bCAOJeL+m8JPP9PgIbrwZzZFM4mm9zxANepS4jgpTqX9ASbwIvxwxgWS8jouzDDmJDO7bFplPsArBoHGl2g7t/pbG+D/8f7UMPr8+y5f6EDLcMHiGwnlS1VgQ2lFlk32CiaCIKzwhTC5ys4XRljgFTxvNrayaX7WxfRIKfpnpXg2C7L8Fhgm1jK0bp/Gm58syZV5JbRwkkJG5gNGak7lNaxkfDvcOjZjjiuckGekYXY5xziFkCxdt+4IraJOU6rbWWQj1pzZvCBaEvUMmXaZbskVF8c66VcnjgElczHTIAub0mws11tbCudUTVAzshVnHUtITSanjhJ0SIC4DUkaxNvdmXbB8ZlWB7fZeadXS1M6IfURnuybgSVG5/zpfUa0Lj3omJop3JNL4/KYG7sMh6rrbnGA7u49ByQOkwLtdaKr2nU90vriKabRzlVvN4jvkGQLxBdzx2/iZrIQ/MpXuqGlDkjbF30HB1FVNH2LG9KoxfWrofr15fUS1tU4qkfk02AgkJkugKLvEDewCrehGQCoPgwBx+rHFEQzXrpIDFWKEcUHu6BqAJfq7yVwaM56T+9RZeScE4J7qHpnwmyYbqSD0NtPtCoG7BoTx3KRqOXyQiKsy33QW8ncqjaB30j2RQp3Wd7K3qbzpXOgnwt1X6uP0DwMIhFSMhhB7HZvPba61AgX9z0B1kTbFWi3VZqRRfIeKPM2SmGrOwmaVsjdEm5p6IacbBrtdprUoX/IOo0NV
 DiqQOxfR
 dNpOncZ+mjjKVTNu1y+d7nCB1Nw/6bI2XIhJqGojh5VE/6LgL7bGM2NHrzx51JBa14TbX/o84Ht960yclasWwdF+is/vS9r2VYuDR4ogLT64vN15D0o4B7zMD6zIaL/gVRQPVW+yTxa5XEdLtLFhp4P3UIDlzaHhHeCM6a1txCzFvsW+oAItR24/i38RhOTa5GZ6BUNEhCKELMuwFrLJxivyAppmUtFWGC2Y/mn4kx3UU4/gAr4mNPbrusITruozvvXhX3ssj4k4ETefMxm1jDxotAuGMBMRdHTt8CN1iSzAZcHUUB3aBslJCGTMp/7VrW32zQ3wHPh7x0uwgikCEWbu5nAFkyOdGHCec52XdBf/6gYHzVoa47QzcndIs9nwRvBXtSEw1NoOc5lfhIvBedK1ZKoTPwOGXnjRHcA4etqJ0uumsgrkoULgZieK/sG4fAa+N75wlo7xvlrcx+2hgeiDv9kwqQWG9vqOduHagX4CHGO9tdL/+EC2mY/K8d0UML5HUxciTgEqwE+E=
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


