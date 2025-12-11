Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F06BD41D75
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95436B0024; Thu, 11 Dec 2025 12:21:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48386B0026; Thu, 11 Dec 2025 12:21:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A886B0028; Thu, 11 Dec 2025 12:21:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA7506B0024
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 940FC1A025E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:13 +0000 (UTC)
X-FDA: 84207856026.07.B6642F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 966A6140005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hBnti6A1;
	spf=pass (imf26.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473671;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHzBUgfJ0WOwFwyblJV2skqbFPZG1hANPnZUguzLKzs=;
	b=hcK1MYJ++pSUP+AS+cbdsWmw8MSo/eIDJYh/mGVT36EaBFH7hfDBF6qlBdQH7hg1PMwSIt
	5uxl6W+HIr1Aa67zDVwWJoIY7Yi1dUva6oHhjY0N0pawP3UF6+3SvnT+F3H3ghABaV6Jhk
	AxyGjCFzxs04fvkCt0Vp2DYHRfmrqrg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hBnti6A1;
	spf=pass (imf26.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473671; a=rsa-sha256;
	cv=none;
	b=dyKNeERq1Ebw0BDFRVgJvvTHGrki4a8EGX2d0OWCMd6dzMJ5DhM3ijBH+iSsRAIFg6Uw+R
	PBzK3y+j157zAz3tRW3iq5Eqm0c/Oa81yLRlC6Hc+imDuNpwHpDdWczMrtTAVtk45C20RO
	W5rF2lkQfHeOV8d7nmLrpKRNVaomRW4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DC234449D;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24973C4AF0C;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473667;
	bh=LAJf90nF+g60beJiG5QYxHSIluys/8oDXRemvNQeYOw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hBnti6A1+kGvwfgN9ynSNsyc2BYkWMWytmdDdoYkU3xlmj89n462SYI7lK/4sl6l3
	 r8pYhrvqe54IGFC95kxAYKXRnEaA7TPy2ZuljsDYQtUDlZceymMzqru49Wvqs8DMfW
	 AxhJSKHIxIddWfp/69NHmMAW/zriUzU7yfwBlArgUXkYuyk9OgYHfX4csZrohwu9sb
	 PSAm6PRN2xiJ6DJoPzssWNERNCeafkvJFW6qJBSbQA2y0O77yFs0n4umz7mb+OAPan
	 HpGY+KWhYW7tYRF2GTLF+4UiBnd+jLn8D2gxQvBCr57kyepIJsXggv/Di4Gih/J+0k
	 Bey71i0Ur8Avw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C302D41D6A;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:40 -0800
Subject: [PATCH v26 07/28] riscv/mm: manufacture shadow stack pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-7-f0f419e81ac0@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=1430;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=xg60sqaex1DpMRqlc6kxZaEeka4CnULn8wlCIX4f9Wk=;
 b=9aXPTKJRRbqimTxa4no2pzOoyRYQrf6TO4oBjB3wtUvF+KkSWYrKl81bNR5VzhKBD9mma5FYF
 eUm6lOAKvXVC77v8nPZTaQQz6BZnHfntKvXunBX15m0HkJ5UHnxHIHo
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: 966A6140005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Stat-Signature: hjt6amyrbnjpwdchda3kbz9gu5zshecw
X-HE-Tag: 1765473671-777465
X-HE-Meta: U2FsdGVkX18zKXm9M+c0V78xY5w/LedOrB39PX4Aq7p+4tLBjnTicC/qjIIoWAY7TOblx0IqtbXC6ZV+g1eKymRDjy50jiM3kLsefIBlQS8ijDtvIAJ50zejCLcMVMIfWGxOphJct12Pms1/3DXMW0PYYyNXAvfIEhg8JZ1aCOqu46tdHwAlMPJiHi2rCC64Og/K5rAK+QA/D5ImRb4cGorbL+6pzzh7IzqtztsGgGNYOXixQhq+2y3xjM6Hn+FNuwDchoetuvuZohMtSrucobV6Qp9oBJx2fYscm25GyVifv6Um+J2gGBWgshNsT+8it+FcXIq3TQj7JIzJonLLTrMT13tA7MIWmV+jdCHFvAS8QeWrD1ZRudmBiu4MoRBUfOoL8ZYugovw+J2dTaYAsxzy2mwSjczG3miTt2wpy6fqbaHd3iIgKjzx1z1dTYtkuRka/8rawbwKIxN5ASlDk3JTDtrSdJ/fi6s/kNMGlEhq063fIg4DCa7vKS7JkChVJKjbTLv5sq/Tohi0esNBikxtOw1msfI17p4L5XAK+4HEEsljOSG0qNsgSiSQcInhJByR2h0JrIiNgg1qfi4itSfvn+fQfTJ8negaO2kOivNxMR5cupg08yvrscQzqFRpQ9Aasd3A5HAkqBZ6uVT3OzXZscbUx2v0M4Xj0dksbaVhYa4vS231rUfxUdapcdRMUME4/RJ1uVZ8w9sGMhujDmKvtR4tCyYqQ1XuVpnzfrbUCrJQynsYBJ8I365ub/KkKVoNUcTL0Opb0D56BOX8L+aHQzP66dTEow6XmlgpltaMj2JAU8Wt02RrrXHcrpRh3issGz/CggiAKBBItXrlE3ucC38QsaMH2I2Ge1lmz6kSe0SbXQl/rENMln+2Cn+uZZuAmBXyeyvf7av0gFgEQWHozfUmKYGOsewCIZckjn5wM6hF1NtJvxBF8IEnI3xkP0b5iEBd7njnfGWDzyl
 sJmCgw4N
 Ao1W0jAX6PMTTQlRqPBnyE27g70jcUWiR8tLqI1IIxf5X6YrP3Nhr4pHJ3vYl5Pekj2NcdSMcv/U2iLVSW9ZFYE82vIgCjf0/ZIh27PlX1SYdWrkPL1SxU2Lc8TRfDGhE2mQ/zWTQAKbKI2+BxICIbXBN0czgy4/je53XsGiGvlUTg/srvuvPxDZf7dldrZWVyIxLiN4Fmp8OirAjsA0ToFDwYz4RZKzquNkOS+VtIoGdsciyb2JvYX0GsLmHC3R6aAbRoviKAYhafrZVZt8IR5wPimip4oglw/S58TFD1ugxUGNOLWkBR6v1Yjtuy4mFxBBmdTIzMp/vMj4Ba40wjzh8ljABUmqVMHCVtleqSQ1HKCvCi2mTanZNPAXogmGW1Rwtlr39E0XV2bVuh0/K4Zq0BkXGaFopDHJ5gzZlbQbXf0fEu44FteiAZlM72ep3Fmd6Gn0kPhTEMvPwTNh0KaKmU2B+IWcC1jMePE2vQw/Ll/EhNgpFyZXLF08ayHqL8GGDcOS2kpXZYWJiGRh4W+jZSHXmhncg9ykNQgbhMec93ICjpDiKtclFX397zKBT/iyujTPqv59pNRbLX63MujZB5w==
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



