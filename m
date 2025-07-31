Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB1FEC87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17C8E6B00A0; Thu, 31 Jul 2025 19:19:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155236B00A1; Thu, 31 Jul 2025 19:19:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F626B00A2; Thu, 31 Jul 2025 19:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC1546B00A0
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:19:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4A31C0ACC
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:45 +0000 (UTC)
X-FDA: 83726129130.18.8778AAC
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id C254A40007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=dwSa0Hks;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754003983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k6HnUvt7E9ZR93PM/Gyja5rS+Mx2C6I8XGI70UUGCh4=;
	b=rj4/C4k9pGLMxM6J1zbAA9y6cNrBKE2QAbgLt06aSTTm9pwUVxIFL+VJ45SokZo9kmbE5J
	WVWZTh4S49JgUcSS8HWvaKO4wClut0Hav0nJ1+Ddkp/V82eV7FlYYZ2KFvpqvswymRLV+T
	sdBQqp+YkGAc2cJdlhtXocbqnJHPoGs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=dwSa0Hks;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754003983; a=rsa-sha256;
	cv=none;
	b=kpoF8Ji2L8R7iaNb9sE9k63Gj1Jfs1VJ450Zr/jETBuhH+FnfFBqA9QPwtvpKeQ9o2Nb6I
	ChMIW7HWN3OtjPP56qYYX48+5vjUpydeJAyazefdavgG2mrqXreyyCoJdkuOlWrkAHFBX8
	Wj8Rq/IxDqos2j9NnmoEEfxNivFslpY=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-31f53b3b284so2774160a91.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754003983; x=1754608783; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k6HnUvt7E9ZR93PM/Gyja5rS+Mx2C6I8XGI70UUGCh4=;
        b=dwSa0HksCXbAlP9AJulPZJqLvUXWvR7KFpoZm2EVYZAZ07Zxo96RysLxcrfajyrs+Z
         mBEpEUEqZoikesVYrFIEmEncp3l2jXmYPzNR4g1TeBk6OL/LvQFQrwaJV/HiDRA6HK7A
         lZLrONgWISXJslNVhIgau3DLEraYgwTrjzppCq+AVlr1fxHe49SVJIIkH1TtzlSBWGCV
         TC/zQGYX6mmltd0THvrboD8oVIHE4RnSV0FHbdonwiFvhjrkrHz4dF1LBEmUUwmgFCuo
         PnjAxvwf+rWdP21O7muMO8O25jfPzSBiu2RqwyvqizZ+GXai1p+I4XsWcVWT2MRJLHDh
         269w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754003983; x=1754608783;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k6HnUvt7E9ZR93PM/Gyja5rS+Mx2C6I8XGI70UUGCh4=;
        b=ddMAOWg+nsOAyICwlQxRq/gt1TVQdj15HFktkckZ3p2prJ30cK2dbgzR2D7DgnSMkY
         S3Y508J+52YK+mZxrh2w6WV5gzAGdcS0iRMwl2SWK1XQ5kc9AHrQZdwe+wQJ89tgABZT
         ub16KGKK9xf+IFNSeqrLJxI4QqMv2eLXusJ/FtbQ/f7AXvjx+NxdxqldaaoE9PjVB/Hl
         9B+s3eol9/Ku+cV88pa8IiC9DWVPdcgiZNreol4oxlmN1hNqtHQyg547SSK9O1/ZKy33
         jvjdRTsNy/zIbgHhJzQM5bLkJxpY9325P/uoFmqSYnt38Xfp+GB/fYzI5uMtQJBIUsBp
         V0EA==
X-Forwarded-Encrypted: i=1; AJvYcCX0XhXTuqCUz7JiqbUWpKV9m9PrDNx2DXxIHXTv8Veg9LSnooHB6MZddGx1wYoPzLGhlobLON6zVg==@kvack.org
X-Gm-Message-State: AOJu0YyQNlyh7Zef5aXHwPzs7+gBMEt1ZpIbQj2EcL8M186Fq6AbhHQj
	8lrWy6sLzD+8HnVbLjfFtVNcvkqzhME2O6WUq19SmRC7TYPxKmQ81qzza0VLMBS5VJw=
X-Gm-Gg: ASbGncukMcbk58Xxbp2gVVX3Ne9uguQuwMlPWimoOkJS6pookWY//Oy+7q632dUVzj0
	Aq/TdTLCxLXQdKe+g/c3IAWcQipo0GuQcW0rn9mqAAfbgnHuehG1BHlU3qKLbggGzf5uCFNPRC4
	3MIDjDEoi5+RnqPBbe89lVmZPioQU9JaQ4ff60U0AuhpgFO5iRZ4u6EmLv3Bxf6ZU+GUew5Pk7U
	hVL/PXyrzkDrE0vy73cHva+BBbXbI3o0hpDq1JS0jj5dDoTz23DcunLoCnR8amtG6ejJkuCTQXI
	jRCkRCxAX5fvv8bLAFNIcR72jBZDNNB2jCGFBMYA7jAH3CAdFnYYJMqIzve13aLZmtr5ocXnLdx
	/7gx7eIYHGgOjl/HVhLPrQDvfA837KL7V
X-Google-Smtp-Source: AGHT+IFK5NdFXAB7IoKpdbqOrLQWep91KhtVBkahQPqZIs3AVxChdKclTwDK0V60c+zsRWOqPN/wCA==
X-Received: by 2002:a17:90b:17c1:b0:31e:a3e9:fda5 with SMTP id 98e67ed59e1d1-320da626cf1mr5388757a91.17.1754003982599;
        Thu, 31 Jul 2025 16:19:42 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:19:42 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:18 -0700
Subject: [PATCH v19 08/27] riscv/mm: teach pte_mkwrite to manufacture
 shadow stack PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-8-09b468d7beab@rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
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
X-Rspamd-Queue-Id: C254A40007
X-Rspamd-Server: rspam06
X-Stat-Signature: hie16t8cnh9jqaz5wzp9j9szf3pgx35x
X-HE-Tag: 1754003983-51158
X-HE-Meta: U2FsdGVkX1++wy6Pm60un8apbWpEg+M9/gD0c3qt8ruMxHgqdnkQhtdDUU5f7v7bgs4n3JtN9in4Y9qkqJjzDTo4OfA6QVM7cCuAk52dGb+fP7mfj8jOAf5MIEVVE4IlOhT38/pRWAZvPaTLdbiOIV0LJk7MOXhKzWTKQy2y30xmFL5+Yo0/xsEQLqyPlTdinJNA2wm5t1H/fGhQVCYSxVCljZVgba5AROmVK/FZm16tgawN39ITUTpsKWM3QUpXd0FlyM5Sc6gt6qwsDpRA4i1rmK4r9IJVL4pmihEqIL7B0JaiJ3hlDC/LAGSWCGiOPVi/gFSRSJnXaGg69sQNelLIKRndDCi+LeXtihJERK2sY0OL25kBZ3D9EsJeogp0fr82q22rIhm3SNuoHAwK+RwSYUU+r+StFFMsrjmbneFP1dce9C/1lKbrItqVd+xyc8L8hwzQzrwP3BAZ/lixfjJGauBn+VWcWolegNiBiTjLtagLVRSh2mQCVik+9jYCuZ9vApOsYLJSrqkp/gyJC4Vbrp67v2pX33T8GxXSGROiVpNNmOd9+g6e7AvnGMhVvzhJZiYyjgjAXynDZWZJgNXekwWfAZgxfJUs5Osp8CyrfxrYtzegTx70TBOqqJKg0CdW9AXyJY1GZ7rx8PUtLAKjUwhZC3usNPGMLRJyrcXSXTmBD9fHWV/LQWu95rwFC9uRie7Q/7/BWStVhPzG2Pen6wNQSgICmRxHj1ECgsGr5GO+HtvTFvRgITet+N4x1VkqSKYpf4UAB9NPjDFS+S7W0SVnuRPx4lbSvdF9n7JUGrRdmgLijPdGB1jAIVQjryJPpELF1UxZLZSruiP40pyR5gV2tvEJRQGPpMskc625dfzLCqNC53u7jbfFzkQMLBtcD7utYE+7M0DQnh+OCqyRMeAcANzzckg96ULOUwhXbaDEX9az1mg6uxgoNxBr36errH514eDDQNLOIC4
 fHVQBAen
 zhjd5/THIXb1xFVVzucoXoTWSe/uSasUGTr5E15x4aGkuJbF8TcMcerJoJHaJRDCj70vo0amroOHbO2P7O6No+Ti0ww+pLa0H3wHK1smR5mRTHEJCUal/xLypzkGiFBIYEJ6aAOvMzeTA8DOJTILhDC/vzI9kqgqa93QPnY3FIE1QeklLGzl4fYu/C7/vQ0xctrImjhQ1yCZySmLUdJpNG4PUvnzsqsz/O0WXviJs+cJtE3PuMJL6vRheDXxq59ZOAdRIvvIYaVj8D3LjNm75tlVTGecguD67DLPWBAVxhPbLW5Hit5iOFkSQJoUIuyX0j/6TJ4Xx+toadfKIjmDVr6YutjN64RcQDisj79Rle9i1qEM2Jj6/Rh//z1PkSYDNATpWhOOVyGD2yq558kMpHMMXtBiUUJ1mQdRfC+qhO1vTVtbBc02fE/uX2XQ6FdcT5lIrFpk+CKOQK3/6/XqjKvJ/NvDvkt3DdSKbEwFF8ak/oGbgX/lvaDCc5WM0X7Hz9aBdIAsfFKnzTjp8+81J5pMgmidRyPTiaPruvRsqRG2ph0NpUzs7KC7Kr5gN+ZbB3tP3xjXT3URElRHXP5nhgmrYXuQCpLCFF+93
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
index 792cb9792e8f..2b14c4c08607 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -426,6 +426,10 @@ static inline pte_t pte_wrprotect(pte_t pte)
 
 /* static inline pte_t pte_mkread(pte_t pte) */
 
+struct vm_area_struct;
+pte_t pte_mkwrite(pte_t pte, struct vm_area_struct *vma);
+#define pte_mkwrite pte_mkwrite
+
 static inline pte_t pte_mkwrite_novma(pte_t pte)
 {
 	return __pte(pte_val(pte) | _PAGE_WRITE);
@@ -776,6 +780,9 @@ static inline pmd_t pmd_mkyoung(pmd_t pmd)
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


