Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C4BCD4F2C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642C38E0012; Wed, 12 Nov 2025 19:43:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440158E0017; Wed, 12 Nov 2025 19:43:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5588E0012; Wed, 12 Nov 2025 19:43:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 040E78E0017
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB7FEC0747
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:46 +0000 (UTC)
X-FDA: 84103736052.01.F0AFC1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id F0D76180004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jH7WepM2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994625; a=rsa-sha256;
	cv=none;
	b=RibhgT13zUDy/sPOF+dosT+lcjHv4GHtOJqrhSsnbutwJUijCN+ZCOtg2wMhpE/4gdGVV5
	WaYH8dANY83Gdnp4g8VkQ8C58QhUZD5O5mC/kUIHGsAR0Lv242uNsUOSg6TyqoElr7EA8e
	cwPXpZcSqwNhfh3QpjTml5StEVeBkWg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jH7WepM2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994625;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYcu4Sd6OsMripcFhuhkvHVXaHCzFYqcLc4Vzya10ic=;
	b=F9appdx80F5gSrFOQ3fht9nJJ3f6fJoOVKJVc1NPhVt4eKA8Ck5GfMPv/BjnpyiqxnWJ4r
	Tp4P9MwrGo+zAMYBFTEiM+gmdMJTWHTilQNbX+za3/fffUq+3SrEz6hRYvqf4fz2GKwoNr
	kajPFKh5gUNnbiKpS1ZKLoyfDLpalGs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B291B44708;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4ECEAC4AF13;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994622;
	bh=JzYM+AFpLozg0DQ31UnaFL3ZRNHAmvEstbFF5dbOdbc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jH7WepM2OrZT2VFYWKIai3VMfvyVc5faMlEUtDbpGlrX/kreymCoeP+7tVnAFxCMI
	 YhMmg6Ps2qvjHttj9Dt6aKPNlCZxqfiXmssPcb++LrnKi32ysGKDkQO+Bsg+HMiYLd
	 1RIBKmXr9zSjQGU3ATEUfavNKEBuzDkV6G2rgmHhkTPIzYYbaYLw2inv8SA8wk+eLf
	 2DyPr6bqaEcpVlbXrSMIBcYDo49XYPzDFK2FxcYZ241Z9mMRA0b5nPXMlA+ITmMXFi
	 4EMuVE96QbpdeklYXRGdqg/Nc1UB8vDcR4hLLWBFRWTMgui2sqEsC/17SPfl2vrJ2T
	 36w+lacv2RmhQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BAFCD3445;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:05 -0800
Subject: [PATCH v23 07/28] riscv/mm: manufacture shadow stack pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-7-b55691eacf4f@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=1304;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=9AtWvDKQ9q5op9YLRgkrDiWaHEAhrRbEgloHu05lQww=;
 b=klt8FiZPtlr/9l1uIpe6uypjZ3LdfZ4nkj2HhX1JBpitvUPsAmMBqSFJCjrw2ItTc70FqbyRf
 EmJ0QGprDlqAyinY17aFb/UtNArFl3GazG3sK1Pnfa6dOuuCyY84CGG
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F0D76180004
X-Stat-Signature: c4uoaj3xkhqyf8zqgi4ed59gor6pxiz1
X-Rspam-User: 
X-HE-Tag: 1762994624-677989
X-HE-Meta: U2FsdGVkX18k68ASjCkbYmEvNprrIRRW1U4Ut1sifRcI8Eyo6HdoCRPRf1lAGd5Bd5zv6EX2w1j9fOuOVA0HMrXUfmW69BjzpPfmIjXPmhEHc9qYLEPRZYuqfZiTw+GZyFKyavp4hAkUDniglmoaNtK/jgO3JTXUXqGbfWfINuO512BMXorTA+FB27teRLtim4Kvnx/i9KhEjcIaEdZplm8SBUY9dmfM1Q8Tog2sGd9iCEPAmiOGlL364Vk/rEgtwXwJ/Fohxid5ZHOFNlJzl6yqqs45tGEIX5CZYZGx+7pOzBl9jzczYegKt9duPK9Ept9YEA9zPYthceGTqTDU5t/V0wXzj7vaHdhe9CtDpjB0aEG0QR2DqYFrfJPkPvMzgntHR2DAeBTv1hRbgvAwJsV7I3n88apAyFPmbg7RDfs1o4T3UdqVB9IaPHvDl6M3prPTEiVEmDaSfn1lN5qnUFqfN768PqxBC9cPub8tQnXH6b6SQ0TljvnlT0Wv+knf112n3B/alvwWZ437M9l23rMDc6RCW/iPY1DZh2nDP245OBx/TFzOgqx9IgwkQNJc9WGR7PE3ymRVv7QeoXmB0R6Iy+OrJ/dUfgRoyNi76p8g3/6NMkz8R6OTrcUKPsOSxCjMMmYEh3tMw50oIyle1pH9M/J9vbd2li2niCursLgH82pKW4/wW0UgNQnPRCV6X6gi8jqeANs7V+YPYPSO5hv92QlwWyWdfYzEpt1GuvkFdDnWEI4QZVfq+Dg210xJvzYcWYKkp1O+gT6iLqlAc0kt5Uo69LnAdo4PuMi/M/F58L4IO1rEo5H8ZGEMqZNk3O97G7Ww4pVeTdO2RY0FLUPwX94mfJ0agiLs5BkuiF2W6zLoqo23t+AjOcbSTjlIIWdntSUV55z0fBOBi8tGnJznuYIUvQJxcdqJ3etSzGiSlz9jlsj6ns+OBw/lhT8PKC7PPJUtE8eokeIki7L
 An6Mzu45
 e6qJLIoVQVjxoKC14Fnt662uN+uw+GiFO8JTnehZJcPq4f1UcR1KrEYEpiS/TfMfLS5x6NpUVDIow4RzUvGIUFVS0E2vmYSn8DWdCN4zmufqccjShWukGC7fR0g==
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



