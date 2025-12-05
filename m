Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A85CCD339BB
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BACD6B0283; Fri,  5 Dec 2025 13:41:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36B276B0285; Fri,  5 Dec 2025 13:41:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5C66B0286; Fri,  5 Dec 2025 13:41:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07E336B0283
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:41:57 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D268413A43D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:56 +0000 (UTC)
X-FDA: 84186286632.05.9BFF845
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BF2874000B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S6M5ZvQh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960114;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHzBUgfJ0WOwFwyblJV2skqbFPZG1hANPnZUguzLKzs=;
	b=puk1U7coRMxr6++Nh6O9ZjbboXym/SDusmuLbDaJ+cZaRAWK/lmFblu8xbB7wgHoK64yJU
	AumbvrCraMl5yLrYVjOd3yUC32uqpkhOIxo4c/IBE9k98FNv/zxC/WZ0dFFmlLe1VBLMEo
	Uq4fqsZnJ4AJ2o+1qp+meCt35Q2f3uY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S6M5ZvQh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960114; a=rsa-sha256;
	cv=none;
	b=IQDEAoAYg8UM0qNlMhdZ2r8GLOKe7BhO20mtE4MFhC+mAkuXgFB6waZQps0gVDStlbc3ES
	Nm4g02zK4Rp/NDTipTe+9tZDhlomEq8ugvHkamBp/9y2N78bsfTQUgoMufcfvCnKPBYGpU
	CpzDb+FO+pOqO6xhl7xQNFCv6L4WoeI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C502844509;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8963FC4AF1B;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960110;
	bh=LAJf90nF+g60beJiG5QYxHSIluys/8oDXRemvNQeYOw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=S6M5ZvQhqvVD5F0QS2ZsaZqG9/Ff5CHSPgQYbRJ23AOcs62IDM8EZVU568dQOzSkt
	 dhiL2Vg39hqQp9mGZhr21Mn5+gr39BQVBtVELnstCb2utX1rYE+k3IsrUUrnvTI6n0
	 CaoWiTREC7hvqdxcV1QvqEw/Sk2ROdORtByyQJk+J4Rv68dGEiMMaIytRVUwQlyOZM
	 /nJSderYf+Ueu8aUTw2bNmLtDyBp8AKClEvxQAAw9Ez/GwxOV51oktQysEW2I5EKXd
	 u0vgDMnGr+iNevHiAzwdOILAevpdFcbQKd15Z/c21W9JUPCm+WZpPx2yh8g3SRuzFA
	 y3XbLxCjo5XeA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76CA4D2F7F6;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:45 -0800
Subject: [PATCH v25 07/28] riscv/mm: manufacture shadow stack pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-7-1a07c0127361@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=1430;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=xg60sqaex1DpMRqlc6kxZaEeka4CnULn8wlCIX4f9Wk=;
 b=FeUvykLJrfx/Bx62YVwLSBRd4tiOMI1wQodP4x5CTmbkL5Ei2JxUy9gzi6n8H67+hQBt/aKLb
 vRuIFYVQ7I6DPsrGaXuPK9GKzxZw3Ry38RV+cpNV9qneCbZdDnsoUhr
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Stat-Signature: 8wquguz5t93yujyijomow1zbkbswhn5m
X-Rspamd-Queue-Id: BF2874000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1764960114-895492
X-HE-Meta: U2FsdGVkX1/BUrnWZGMe9XHu7k+mxEyPiOMOLZSkPwWHxxsPvvkHrnGIGAaFoQ30t0U8SvErxyDGQJ/VFRUXJa2F7Uqzc63qARf25apwp+3POZf12ekMW4o1hnU6Pf3c0QOsg9/ifQAR175sel06eWjUTCJYbfv3/PUD1eLpInHH8OWT6HEqbxkTBxDbMC3zZyFT6gxaUzuqEcxTvIuy+VFRg1leEx8m3rxL6nMBY7h9dNlgVvSObV0Snz8w6POH1N0/eNC/Hum22jDrX8BcWnreBVa1e6F9dpdYL3FI0DZXOIbMRSBEkI0PxKxN6mPMTD8qiNTmIZ8AJ9OFNKl3+wZMiPcNdDFl/kZIWE5E8wNbhPzuHdgGPTp8VF2uQGOkOip0iUpewqrru5JQgnGJLZDMaNHC34/ueDlEjtl382NM0gQ2KUOV8IGLUcUIznM4gTILBlB3OHiv5T4gJvNK+Y0fL0z15S2Os3dwbTkJGaoVwKyJZGFpbdSFAD9VDwYMypWZbb5tPMpRpTzhKJwmhJBaELS8PL4wrwvxNtR5TB3axf0ne/cf+APBEh/0L/DbGvH6ZVflNhzdSNIn54adFF2xQJ4ScGuKAMxSqVznfenyDm56556RXsZxd79+EXLC2YOflNjfadkzqJirNn+VN39Ayt+6aqhYIePzqr1bKNdCbCiuKtMjceWG1p6aYXUzDbnlPar9HzxBkVnQ6aBPj7bYqr3kwpjVuUMzckntNUKzUx2R/Tfoud/viDAHdZHxQaPI9fqYih1t8kMi14w3go4GEpL2FSPfXX4AU99i6Lp3n27935uvQ4wyz8Ux5SKOLgEd38wb7sTtSUR6fEyNI5uf3qEkrgCXLq9FC5RBNvPatClNz+DDowZg997eLEc8d53LvxRvLGdOHJgR/6XT61v/aVBmiQHfzisOo1YNC3zaeZt26ZB+qiZvtm5Dj4IMK2Z+b4qJ1e/QNuBrRdY
 SevVE2m3
 X4J5Q5+E4nJMz83F8u3uDikSrTkYzHrcIgmFxpJqbZVKNfUqG8jyHTnZLIOxX1C1Mi22pDf7DUsc68MPpou/m/LVL530tXIWqKQtaU2sqoyC0GGr4ws/x/uT7E6nrfR6+e1ieMTVqYEEinE6yZMobjbt1fea/O/4mig9HEP3gNGO0uwtPRRA4x00CuqhP0GFhtBabg/grO7fyGaNhwctOGLflAvHAYP5nNBkzyiHyPfNW9/TOs0L0Njksnih0CUBx6iXkPWOravnGFHXAu/xoMi9BlrIS1sh9J0JoSH2fehGmBbTQe0RAW3D6PYcZ5wYAR6kIl319F4M/Nfc0gvknOilenpuh3wvPKPeforQ12EvGp2oIkAJtyw4yjBw5vScoc3WMRIGueefRYdhYa5PDeB87gn8sQPCvh71K/hUthvxRPMuYQqQGmyGx29mS3UqfzCegG+ow/VPWTfPuSyVV+U5jQPLrUBt8S+Ex8RA4//R+OAY75TvokZnNE1W9BvMduAkgNaWhfEeXiRr2SqqqWAwd+FB4ADf4pB3EQnVfYjgYxHCjROOr+w/zbptXpMG5kGDJLd/NmxBVvWsUgax7RUK1uWYKFKj96HL+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

This patch implements creating shadow stack pte (on riscv). Creating
shadow stack PTE on riscv means that clearing RWX and then setting W=1.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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



