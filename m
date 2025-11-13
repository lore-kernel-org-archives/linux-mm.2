Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63C42CD4F3A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDC438E001C; Wed, 12 Nov 2025 19:43:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3F928E001B; Wed, 12 Nov 2025 19:43:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B068E001C; Wed, 12 Nov 2025 19:43:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6988E001B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A14C160761
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:49 +0000 (UTC)
X-FDA: 84103736178.30.3FF197B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7472B10000A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WKngHvcA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994627; a=rsa-sha256;
	cv=none;
	b=l+3j0NEUZYtHPeW35DxSgFoFgi2yUn9e9ARPlg1acOL/tbFV9UIakUyzfYOEHnOdUjKfg7
	e8sXdNMySDe5IonvA5n431Sxj7QslbJ33gKH2vCImPXn8mNcynxfXz1YY9PaaNCLqy2tBN
	PUKER5RL3Yd7v9SASsNxTzR2noeafTg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WKngHvcA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994627;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAqEPS3SfxDKdGPyihZ/nXY4lv/vNE/ScHHIWleq9wQ=;
	b=ZXHewfX0aAiitSoZNuWdGk8jLdYnqdS4zt0TAlS4FZLZAtfFYgZslLRVSmLumJpn0WjCno
	F18Nq7oQSyqWSqg+edhcuHLz+IJUohVtPzv3PhFC01IUGVt60rQmUGecj5cULU6S+GOzkL
	1dNzlsgG0BvjAdOqymXvsML+EanYfpI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B52044726;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68E51C4CEF5;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994622;
	bh=2XlQzHo8TfXDA80GJfcRCvbRJVXsgMZd7WmYI4u56MQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WKngHvcArORE8Ekb59KWEn5irIBQXcLlKCT0NupMdxqIa1PDx/ShjTWsYOd4/0/yx
	 cKVvtJngzIo737LDfmtnVfwiTpO8mr03B3QGttdHdJNcUdLj/Qzy7e9nH4faEG5Tyh
	 wSpSBO2xzMPdQbusB0ET9mRjI+cEstDLOBsSuxTLCJVF0gdUmhF/pvtbY5r3mmNcD7
	 7L8yLKgaoIZkOM0nGxDpQAHZ9aiuMPpw/h8ODKeJCus9c/UshYVt2tZW5RR95u1CiX
	 TrvGZObCmN79x7HKeZxURzxnGamwQLZnJwInmDZthFLrQqonwozmaBfC6GKOfFrllN
	 nPewobKPIlUZg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502A6CD4F2D;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:06 -0800
Subject: [PATCH v23 08/28] riscv/mm: teach pte_mkwrite to manufacture
 shadow stack PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-8-b55691eacf4f@rivosinc.com>
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
In-Reply-To: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=2245;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=hYnrlxG2aSy5XgBcW07Fd+5qY0pd1xI872KUOKzj6JI=;
 b=9ok5r07h6mzeIXJwHolXHySrmRTanvUTGfF2I3aVhPCjV6Mxjnt60nmbtqMs6pFU09iMgfbsm
 tERVLYgAGpDBpzOKh03wreoF+O7Q4pPQ6kYkXf5nL0IscteFlQRT1I5
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7472B10000A
X-Stat-Signature: je63fbaae9aqcfwq4rw5s4516nnq11be
X-HE-Tag: 1762994627-511097
X-HE-Meta: U2FsdGVkX1+4qaIFxGT5t96hR4ih6KFCxWr0KRwoi0kfnGV2YH+XIfpXzjqXsPoFct3nuWdofzXmjk+fgvmrY+2KaXdTrWnE3st0nWQ8mU+XJlZCLWb/oGcFplQpGfwzSqhGcNoycqa7Ch67uidWjgOq1EPK8TcBW1yBLRjwV4DnoqP58iWY00HDWElRdd8GToZSPfR76XoKwHbvo5WgBYavmOf+UmR0p3uotm5s+f/fo9oKcXC1vZ6vmOqTovjO/tsAJJlYwQud4f5nV0uow1HSLxO7iFQIvplOGcuATZq4u3sZyc/IvlYKYmAmgBSrr4ycTkXV2eutKsU//bfxZYkKfKofnQSqwrCgr28LLLfl0h8R5oP+hdoa+iCrbnjRVi9tmGI2YpNblunoTsMvRwr6Bzti6gbCvWsWpg8qe+hlkNWqnvJzXKfF/xqUJjN/+a7+auho62aaMPkDcl/Qg5vnhbw1V0dXlHaBqh1zO/Wo4LbZTVhM2NzOwvVVemAw5o33RzV4GLI3leMHNLFBYlhCUsC3SfJJP82dz/Cy/ZuKUJ7ezcZ2nn1NPdriowLanR2u0B7XT3nbNoJPOvjaqECixEPvCA4zQx8UtQ8PKEpoVVEmFdn08cdBr8rJpJMqDxttieoWp621pQvo5IXWeuZthB8gAADQf6xg1knMF7cIPMbpX5kVyQFsCk+1UQJJzojua+zM0xqkr7ReIj/d3GC7F4hT9g+Zk1uiExZCxTBRj/3g2F6v5Rd3/5GGYlpVJLm1Ac4sel96ELO1kELvHgUlhqDm5+L88hbvskR8qfCARqtce6hIWNE5mINr9cR2vIvkJUbGDc2QpBNvSrkX9FxvuQN253b3PUta30jFHmB1IF2vk2XOjNs4b4uuYn2wYXu/laUopz2K7ztvU5yo8qvboxqt0PVdH2IhZSLZ1b+CVILsw0x+NN2rdNib2P+2YvyCAFhTQrHG1n5ZHtS
 VagN3/iD
 dMc5RzvFTKisO7UQhFvUpyX1y1lj3f6rIKvHdmv226vU35ffXBn/efVFffgri0mBFvh4PHsIfAME7RvFuAGAwSimtXYGvD02MkgLaZwXVUprdIin0fyHrTyxJnmAWBIFrwwWiNhttWVQrUUlqrwsZFkcYojixl0S2/qNZ5oJGCRzSF50cTpLYlaZwHySv1HeckJqFNf16VBlH2uHsb1F62qOpFhiAPbm7+JbbW5Z3LDGe5atoAGexv7j1xRSyWbCj3dJgqXCSYRZpgHd9qxts5LqRwK4WM84aug8p1xR4KyqFFTu+tGsPDJWg0t+UxtVk6bw0Fw2UXj2fPuwX0AX8ZIuAE/s1j+urhvAC/OiTyaVnXRO56hT+43tW48XnUsA0F+rTX4ZAH9F2Tzn+YlSPzL6FieGT692csYqGbQWbl7iG8IUL/rAWEsb+nvKWpn7wVivVzRcTT8g1i58r8NHcJseaydSi/xgSrPOdPn9ecTUKpgnRPmLBd1rLagRlOfv2ANdPOUpaoUy4H28zHM3FQsPZkYtN2tvIvjxA/ZbIrm1G1Pf2ePDDvIvJNqouU8gSTBO9YZVjlqlEWx4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

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



