Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C689CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C294A8E0014; Thu, 23 Oct 2025 12:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3138E0012; Thu, 23 Oct 2025 12:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A746C8E0014; Thu, 23 Oct 2025 12:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD958E0012
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 534464936D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:17 +0000 (UTC)
X-FDA: 84029969394.11.C14A471
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5907F2000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c0DQuGe9;
	spf=pass (imf03.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238275;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAqEPS3SfxDKdGPyihZ/nXY4lv/vNE/ScHHIWleq9wQ=;
	b=MiL+NrcTbphREdljCKN/lXnKifWSMLsxwPRRsNDqA0Xny0Gb17Hl7ho7gW8xA/gc87jILn
	/p2LZgTelHXWgedTZO1YkDqUVseHCjVmYdlm4v7MdIZfajoUAzPHK5mAxW6cDbqcRCC+Zt
	MqoQ8VaEFWu6CfNwElpv3N3L9DQf3kM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c0DQuGe9;
	spf=pass (imf03.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238275; a=rsa-sha256;
	cv=none;
	b=WBmu6Lr6iKJg2h8hoX64OSc8nLsQZ0/eIGltwhIQTuEyOMufB0VD7V/nTu1pAIO8o+uk9j
	7XPZI3M37+73wNvZIhfJnfTxOiWMmS/fz68HJWVIRPAG8BOCJDjq8Q5Ktwc/KrEp71yjlC
	Q83aWykdiauZKYnK/zImQj/XzZUMVb0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C70E54B03F;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C46BC2BCB6;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238270;
	bh=2XlQzHo8TfXDA80GJfcRCvbRJVXsgMZd7WmYI4u56MQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=c0DQuGe9Yv8wcbRUZX6wECKv4P1ij1PHvwifuPQDhiwNWhncEUM5mKa8KNFXvk4XJ
	 Zh2WYyJs7uyf7CIdxExA9gPebOrzotUTiZ+Zha9lCtBlm4yab+In7taN8DEcmRrSbL
	 x5GW3uVtizFJBazYhQi+auoaRwHlN0xQAD0hNHXsvzSPnI6IqYX9kd+MJz5Tiptofg
	 HASdfvkp5s3yleD+1nPJs3n0c2CP0Tw28FQXVoMJyk9ntHuYVkFUJ1CrQ5TNk3P4pR
	 ifQ0eDo3n7zJ1jN/gsU64Ezsov3jXqgifyyG7+ZtNqBP6wt/IWrL9JmqFVzaK0xZEH
	 riLnY2FgVysYg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51707CCD1BC;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:13 -0700
Subject: [PATCH v22 08/28] riscv/mm: teach pte_mkwrite to manufacture
 shadow stack PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-8-1935270f7636@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=2245;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=hYnrlxG2aSy5XgBcW07Fd+5qY0pd1xI872KUOKzj6JI=;
 b=uOUnZTSYae+1jU33LWJifpgmGC+oR/EMiZvhGu+tnHOPhB1RKqIVVIeCONun501aQFM0l8Qxe
 LB3LNaY8WQNAi0/g4infWveW5c7mSAInncPv0wFTQBcDMWr+lIOblri
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: xgcqf55jx8p3f18x4a6oyw5j18fjanux
X-Rspamd-Queue-Id: 5907F2000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761238275-613256
X-HE-Meta: U2FsdGVkX19c6Npel6mcASR5APJAmrgDtqueUiVezVQuVP5KaN2WLUgqvJm8vCj+saQUflJM89hxJuHVoMLKNdQt7uoAwsAbhjiy4o96fIx1SYQ3+Mzctf9KsJvuBa3nlZgyQ5JChtNzxS/C0d7l+dw82QNXOrCdCy3CPYHaZmlQPv2O1jBAAa+SY2zoAc0G4rUl/Pd535qaVtMFYjfMKWJrahC1pF3tL9gg4Kuoa7pw7c7YNUrwrZN8Yevqj59ARdn4kdU/pIzflTFN++y+5MNhS8J2zu6+SfftLI9t1Ds7l4PgUS0YEP5jxcn8JTfTsAihz5RFRMzhtzKAjDqLY3bhhd3D2K7ujuB6HrfjCpy1xtfCVPUN7We27vtQjEnkusPYYEhFtN3tT76HyslWnQWPwt12qr+2By1LFPUzEqy2GETFQV/T+9mvYn2iRRaVONBWnDEcA7oftaOs7mfzMRgv75cMN6cetImMexhe+YdW+oU4hR8q5tVvzWQ4eITTI+fvQQZS/VXeG0nRFmIEipdP/aELBZTz/eNOzVVX1ThcNics5LPfCz91gC5ei8e69RPpqEhH6f1kDqwv9tb+BOR2Q8q/tSsRsJEz/L7nfScHfG3CwxJMDBLk2XBymZHtNuXG00lIT07m+kPVoaoMfXzVz8+tVxPxnUOjypzmjdq59Q0yF0uCE3TgZuTAVUDd1RElcWURup5dVsa243q3CLs33V3vBml/HleasojAYihcBJE30nrv/+luPfWFJ/dDHyTPmB8oRxbjkTUzPSmkOd7zu8gIdYLdNEneN3U2NNsri7jhPh1Tyi38I5+gkF5MyLueMJ+xexevk9KPpZnqhTLtMn0dlc+CpeBeEKUhoGbWNLgPv0YJDdxsrvtkO+eGa3w5+2DK4iQld+AgRDxv8pk07HDJZ11oRwSZb0qZQ60PJ6+G48ZWaUY/RBbVQq93pIah4fC+7vEEyu7fUSS
 //f3R8Gv
 2M3aB9GFogY+v5sxe+mBgICOcR7Osfd6UH2PT4cyVdS4zG/q6sE9o44wXzlYyk9zDsMZRSDUgPYCxmmzcwRwmCnzeKkqGpa3NsRhZVMZdRZFgaSuHeC8r2OQ6OsdgOUTN0NOvn29t8ZtJ4cGsIp8tCPlvz5TaYLGeEJGLDJisqgdGtBAV+zj+1uBaz8yLhpg8SteyRA3TfrNk/x3JKn048ntSPX4vY2YymccvMj7hjBiLBJnuDRyxYANKTYnuz5Xfc02oqzwivkx4KssqpHTA4h8aDQmNZZgOHjefGU0Xc97+GK8A1NXPuSGgo8Xgr8FVIHSvk16TqtLX5UbO+I26I1tQWbQWd0/px7QyDZAokM5o+wfRlx+YOzquLD6sEgWlSdhwGTzF/6lTxjTkgHGIOFHOusgsxNI4eUpxMN1UftslCc7lJpYNXZ8tYEafNclpTsbTTaGIoPcic78RUEYY4o3nhdEg+XxdcROvBjb8/7/lollsQviumtWz8OM4mlkE+5u9NTV61mxzbONTdb+OVJ6kuBze1i9xAf2gka4/cL2xz5DJD+/HeRGnwL0ttMW4P4xtshBAVxdp9/k=
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



