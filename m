Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BDABD339BD
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73D456B0287; Fri,  5 Dec 2025 13:41:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714BA6B0289; Fri,  5 Dec 2025 13:41:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B186B028A; Fri,  5 Dec 2025 13:41:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DEAD6B0287
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:41:58 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10AD412B73
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:58 +0000 (UTC)
X-FDA: 84186286716.07.EFC8C81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0F1AA20014
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qJRZHyzJ;
	spf=pass (imf03.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960116; a=rsa-sha256;
	cv=none;
	b=ZDgBYjMai1vRWrwFi6H2HcCF8BN3IQmYzE4NWHWG42fAsK1RdcFYw2hWNYIidAc9ZHOfQO
	j+PrPATfphu0vDhKJ0mpHyha7ImIV9tzMUthcIZ1fUbOge00uNoXYMAaUEFtQQtQ4ymCm9
	jFR63eLFX5oC3e1rMDEMTqxRxR1eps8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qJRZHyzJ;
	spf=pass (imf03.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960116;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnS3sSaAmKH1sjlEJ414W/TvDIeFPTUnUNVNL3eOopI=;
	b=Eq5SyLlYK7juYPpU20jEFFxqY/i8fGEMF4m4fuDTKPQq11W6Ad5Z7fJhTMZ76vtXMjCXoK
	gjnsvOtONLPVOAxcmaPnjS9bgAwkMOTbIHhkgVNYWNeun7k4KGcxPo9pYkPSNQ/mel3yzS
	YjAC/vv7q9mrnXgNs52vgEFFwJS8NE4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E9CFF44527;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A39C1C4AF0E;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960110;
	bh=04gVJXOYw7Ju2c/7DpEHB2s0kbuucyi2foZBfgP2tHg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qJRZHyzJu2ng2T7+QcnxvUuW5qFDRntvNoU36U7lMP+q/wrd2WS9ZeHiZxa8jj/CG
	 yMc6rnNdnNdXXtul9iIlTLORZngNPwglpavErhXvImT5OCQ50LWmfI3q92wSOYH0xD
	 maWCJJk95yX+Dgd8GCroB4kj7xs8IWDTDMKbbQerZ63h7dqdspRWNUAg2pfE2aBDsJ
	 WtBrC8XvTCJ6ZE1NP7UuzfzSzvA744bG8FSPvLB2PMSCtULPhAMH1/5jaN9YtSBnoa
	 rAX9v5trUwIvEFcDVWGHpCI5GktP//+8mKsnsB+16mjaDZyIZtfirPZTAEv42qytwh
	 9KKwlmKR5D/SA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940D5D339B7;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:46 -0800
Subject: [PATCH v25 08/28] riscv/mm: teach pte_mkwrite to manufacture
 shadow stack PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-8-1a07c0127361@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=2371;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=t88tD6h5jGJWywn6Tz9bzXAVcX1Z5iY6bKQeGfJKelY=;
 b=N4xtbVOv6lrVA6wKy86XWTPRYm7wr/n+y0/kgtebmS9buXcDZzbf/D6MfqGEe1Bu3tcMMb54a
 Ld6+7x5sDGnCUsJLpuBvs/MBw8Z5DkzSxijh9Av60LC4Pll0qAgDXRl
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: 0F1AA20014
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: t9zkxe1qjfsptrsoktqk9m5mm1dxrmcr
X-HE-Tag: 1764960115-926129
X-HE-Meta: U2FsdGVkX1/pA9KoOZJiQdwMEZNSMsbz4Fz8W1J3grTzGMUtp16BkyLdfbyIobHdlXIKRttq0qqw3dhm3qKOXVFzAFkkHp83eCHaKKLarlFXwacgGrMRU5WuCR84TzT3/16Ixm7rGy34wGuufLdb08vJvdbpCEJlp/o88y8wo39Ml/9zONA/W94thwk8OmM2MKNRwVKCtCpJtj/rt4hx0hh0oDajelMuObqDFMtU1BT+UF8H2et3l33WkTpiIWteZYCAmyBVUwji2DgJFGofs9hWosi00Pl7l71D1XTw/Av7J5b2Uv+NQjufiv8kuPon7H/oiMIqA13t7Ho+71uUgCFMeONY0oS/zSVB+FXRSOmclsSTvSQayoQrwiMvp68vY1Qy0NMiWQfSaT4HIwUloftp8upc3TTrv47YCrOXPWr+Y8+I70+X3dM1o/2TzcLfcCcs15NbMmR9WucSPeo8f5RhCVWaJbzoqith6iy3j35JG9b8OaUNbEu5r85f528Iv19Yc/Jzyans2MQdCc+0pwRO+C5LXcBDJBCFsaqT2DvqF282Fh7Kb7NXcIOB345obFLyraJY1MlmiKvaH2x4OScvdI7TO3fOaLJKiHVuRq9X9cFv7giJXoyaBzyB7T9NG72S25BVoWzBFCjQvgHbOWJZj8n1NNWLPkMRNiRjTe0Rcmcwnhp1jvEtwSyUnC/HePLjmfZ65H3jbXMhMC7XIMom+aFopFFTQsr1TICbTthY960+imthp5Psvd2NHQfiEOaOtBh2jZhEfWhqg+dcjeiM6Ky2lUMV1fmaPKc2I9MwAzqfLTEKkb4fY5Q/iEyV5WfZY3anHJjcUXr/cuXAYrnMQGk/7ePE27lsISy3SxlKEDhmjfktkvW5CDxxmAGc9JWfus+Ie0iEmxEFnf9xU1v8tCevZZE4KX3jmKAbqBidnP7kcdQ5CfZhyfABhwfTIM4NL047WQjfoYbRY7h
 /Wizw/8X
 FI60nKxai0SAu+bKyZZVb1FMP/wgs1piABPb3bz8Ph66SkYkqTsus63YGczm++NOSU+m516FHAKhcbRV1L3wOg+I5jVMggl4YiFlLXXvuYQfbz43RQ2AEqCu7sk9Zm2XQZApHEODGsY9wUl8y2xeLtZmYbcmnzfxtwPeI5delCs127bAW14EXs/rh79aGJcintBbegAb1ILzwgG7chiIKuwlXX45ylTzfxOhZyk1Ov/BdM/NsFl8hZmZCd5nrfYApzBRp7KvkeQgyOj27MfTY8hDghvNDXq5SorwYVHx9pZ2NalR0/gHN0yjk6J34SNPfLnwkfrdgknsJJ6El5xVr4AKqnWYM2+nUgps8Cu6IbrAFuDUbfjfus/S6tq8lOLpuACbaRcMy+IKxvqKPJRrR5KJVuQVDRklVrPkrtbeU6gVpDr/6T4vHXmTRXy8L72tHT4ZMVmxUduoAikzmq3/MK6wnIcAmy+qqEogzWdGlDnHRqx6Q6DpM24zFubJuL/S5ymBBXFfr4nssPLm8lhy2mhUsVwAiDTOxJHru4n1hIAnXcSiLr6HZIUr1dkzp5PXE3B7pBNt5++cYzN8r50zDir6Gx8hpGdkaHWzqYir0k6PBD3JfBUACMi7I+5vVRP/F4RCbHhcftTRYTUI=
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



