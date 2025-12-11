Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0DD5D41D77
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71126B0026; Thu, 11 Dec 2025 12:21:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21D96B0027; Thu, 11 Dec 2025 12:21:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B38046B0028; Thu, 11 Dec 2025 12:21:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A18336B0026
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:14 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6941913A546
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:14 +0000 (UTC)
X-FDA: 84207856068.05.D03F29A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 54A3180005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OCpAsr1O;
	spf=pass (imf30.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473672;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnS3sSaAmKH1sjlEJ414W/TvDIeFPTUnUNVNL3eOopI=;
	b=g/oyZCfcNjex1fcDrRZKdPEc2Xck5cH0H9yJeJZQ1uOwJ5xYLIobocNvxnxWweOD6Qs5Cu
	Ne37fzjZcPNcS4hWWRnDX3VJxOZ2/9hpL8Lirs2zEe+fDvodUrbh/BhkPtSrMi6IhQKUxk
	uh6Irb57cj7LBZ3Y4pa10h90hA+I16g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OCpAsr1O;
	spf=pass (imf30.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473672; a=rsa-sha256;
	cv=none;
	b=pIElqcf2Mkyma5Y3rxvS/wdDQbMD5i4wF3++4UE6fQ74XCxLafri6E7aVAzZlt91Whptxm
	o2Dmi+4DrdDj59GTwNgEiUTTajHr1/BX/FFsZP3DgpDOp4k71Oq6ZlnqX7Xy8npD7lSSN1
	5yePenIgn16rbvcfT7bsfNOlD6uWAyI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A7FE8444A8;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39381C2BCF6;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473667;
	bh=04gVJXOYw7Ju2c/7DpEHB2s0kbuucyi2foZBfgP2tHg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OCpAsr1Oah2IC1WUiR+F+qmoVx03kfKjO5ul4TmrKjdNWt19LHqvTST4ZB2RUq1CR
	 NEtzlpt+tbK/vkBJH0OA2icZt4KiJe10Ga7WLcHVbiJw8lXe4haTFNISBchUT8Ebj+
	 XnBvRjgRnEYVnit1J0yPzGqQWyOQRE2EMwcOBL6y0Pl02vaxZbe9z8guMNqjZHZQqH
	 W0oW7Xs3l+QoWhJETZ/gXR695ia2e2aFysYWXbliVb4Cj0jIiIKo0eNIdWHAxmDn/Q
	 3egHFl7g9dZTsUeUVzj8ot9W/2oexpllzYecP6QUqxo8+QagY3fcPHzeJwKp4yRwwU
	 t1IlUnZxHNvCw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255D5D41D6D;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:41 -0800
Subject: [PATCH v26 08/28] riscv/mm: teach pte_mkwrite to manufacture
 shadow stack PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-8-f0f419e81ac0@rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
In-Reply-To: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=2371;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=t88tD6h5jGJWywn6Tz9bzXAVcX1Z5iY6bKQeGfJKelY=;
 b=2eVX9clVHze7ulKPpPv+R2k2xcoyYfboAVjhbcXbqF72Iv1e7pp49F2bHxf0gP5GgR/QmHs4n
 ILGolFzplBOBXJnDxgwDpdGNoU+rmmyqKLAJdAaQWB5pGIXvIhx5d7p
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 54A3180005
X-Stat-Signature: cpb7hgcrubzs781b6etpg45sepp8ugj4
X-Rspam-User: 
X-HE-Tag: 1765473672-795806
X-HE-Meta: U2FsdGVkX19GQCR7a4aFhcTyhJ4bNjlmlFImCQenJYvro/wxEhzZSYTZ8eQcNw9pzdzqtAv7jWo4F9OwAjajD3LIYjym3nhmNlAPJkdmEkoCTwNBYQytm2Dgil+xIvB3EQ251F1e29+wIbl9AA2GOEZtQL/qQZhY4L+Lf5QHkRaiaOvM/5E6i1XKxmL5dH9uyIbw4fAAPbGaPchNQsyGAaGjb00yeClvTBt3UdOqr+IJOclJ/6glJn2s9OETIJyQ3TiuOLp5NywaWbwl1EBUyFBMEByF6kgHwZnNIXi2GBECHQONoTYx27R2eZ0uj3VB/u6TdbQQl1lz1AgwPT+t7clkxm9hkxVqS5Wcl8/uSMCKxtzS4MfQ0dJJlJiZnKv8bBd6/0DnzkkZ1bl+BG31XT3cybQlvLKDu8rf+iBExq7z5HJmoy+g4vdi0Ee84RBtkkCc8+OyDvcIZr4n+/dFwTm1wK896WDyRR/BZTHDfmLfIgVgMDOvuvJ2IYzP6F+GuzebVQKsBH3U/zAAGDCbUermWItTppLVcTp6kcJOuQafF0jhpG0xxHLMyVvktedUpZP4KYwBh2YNGHVTRmrRKVnOPgcxzyc1pC+04bMevga02+iNu04+XhJtw7gVU1Lga9lXk2r27a7+D0Y/jVpAQbL5sFFoVwScOGx2pi6Gthz5fFzC2uSlw12ywBWwDEFvBq37kOF/yGgWSwRCuOhx468kGfAV+fYWag38Z4k2mEFcoiNKqEU6QZIq2OYU7zUysWKH6VjapxfFIspJ3o8fEr40PUdzuxRXafvyMAYwXV+9i7iV7gsixLn73MB0NHSGIZ/YmELiLGl/sVHlGp93QYWuuj875Mic9Uh4+P7AQAfX769xuqVSaCHq4nLKl7gYF+jKH8rSKz5ENdONWSRXTsCyd6dsIRcpnnvNx7CMxuPVvAUVVuIddr2vicM42j+VbtXHa86kxqqM2yYCrs0
 1MLTLfC/
 QkCOCNl+18NLpNqfC8hAxUhC4t7fe2Sh3m7buFweDgJwDAIKOCubtxSwIqUzZHWhd09uQ3GiT8apVsD10voUmbXqwvmFd6x09Yl7jKqmmekbW+ppVEIWtUIFnUzy4Tprh1l6gAhrYy5w4QXT0bwc5/3LTcJ1C2W5hGX8WNWeIyxHl9TF08sjL2LYhkwDWvy4AMi9TG4fkEzBeyV+BM/EadEk5f8spY/p98jQ3GXfUKkFUySf7aC/vBWXI3GOIQNhvYkN0OLWdU3IKWYRFeBakR/mXribiLt8wVvhPJu2SGS78m3K/HJMgX4LpMUuTjoSJxDYy+JlM27IaWP+BBkeIXNmcN3yLQFIjlJd+9N5DW+u6LrD5+3wMKRbIdw9I+w6rZOaZccLtOb5GanRgPQjNRibPAj9LoCI5eG9/ZWrkaNwNAYXEh1Gdft9qFnmbnhNZnoyz3xASy7wPkTxAuhhcIi+kqkmdcLyDpQvGGGZxv5IyldKVHR5UvLsnNCMvg/plOIpKF2ivyVTDFdxab6+99GofWLxCy+AhMp3Kxm0p5WHiTJkk1eVnHJhyLAaRot/CpXUUuBN3pGM74bsgCXImZpCKWAEeTPgym/7cLQ0ADMFMrvG04usuvv9DR2j7VtzWKHcg31CKvKDM8pU=
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
2.43.0



