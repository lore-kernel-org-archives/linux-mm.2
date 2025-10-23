Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 787A3CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D342D8E0013; Thu, 23 Oct 2025 12:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96888E0012; Thu, 23 Oct 2025 12:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8B08E0013; Thu, 23 Oct 2025 12:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6BC8E0012
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48620140BBD
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:16 +0000 (UTC)
X-FDA: 84029969352.21.3AFD08F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3A2EA14000B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nxjJCcsu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238274;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYcu4Sd6OsMripcFhuhkvHVXaHCzFYqcLc4Vzya10ic=;
	b=PYJMd38PWLbSY0TKQk5AAOUQbuv6bQ7oY2JGYnxri/CcT8xkYY5TGLY6xXLokrHz+voOIx
	2pC31wxT5eD0Jq2zrnMGf4F3XJhKdx5Bi1XOnVL9TDI/fbDD794kv1owBru4zSK7E8VYuo
	/LvZZN8+vPBba0DYpQGrWypNYeBM3bY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238274; a=rsa-sha256;
	cv=none;
	b=hz9Jm0hWr0ohIHM+rqxkdM2xE90R0+58tKM66AibrfNuVi28JgNM2PRE2L/+cTR0H5j3Zm
	86FiF/TbrHnkZO0WSyjaw25XUa0PLJQXGqkprR4t46NI05ys3Zaxuqj6K3w6YmqsCLx55a
	OFERZdMs1x68ulW5Q8buHcFLYMMaq1E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nxjJCcsu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EC7B4B01C;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 475EDC4CEFD;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238270;
	bh=JzYM+AFpLozg0DQ31UnaFL3ZRNHAmvEstbFF5dbOdbc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nxjJCcsu8BX1GIJj6qIu6m+yzf+lzh7zHVKhw5XSti3a8ylwRlPDjEp0jGrAjx2FR
	 N8zDwpR5v+nVBi/Mu+ocU+GQMoBQr1OIHie57GAptX4LVwn+9wGmauFCxOWPG6Ukw2
	 b0hzCXovMMZH9orhwEYiWy+ucmjlexq3Eh+B1S/Ov2INZuHh5KmNHgHaRDK4wiyyus
	 n0Ni7RaYm0u3kZ5Vzz4ndh9oYmxEzrksukC34PgdPcGx6l3qnI3F/S2Pg85rG6Kanq
	 tI/KvLafeeTBSrdcbiCm4Nhq086B8Z5mUI+f/IDlEHJF9HABTTeWycUN8SdNynpr2Z
	 lfI5xrvuROmag==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3848ACCF9E3;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:12 -0700
Subject: [PATCH v22 07/28] riscv/mm: manufacture shadow stack pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-7-1935270f7636@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=1304;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=9AtWvDKQ9q5op9YLRgkrDiWaHEAhrRbEgloHu05lQww=;
 b=+dm9mYjGoM5tguhKJhCeDS+GCYQNPbTcoO1hBHORKmhKyt329FWJFaW9QLB/N4dBqSR0uBKJ3
 khcJ5aEfrGEDlHtAlbKqsJTvZ+omlQ+K5u89JygZ8WxJdGlTlyQsxAs
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A2EA14000B
X-Rspamd-Server: rspam02
X-Stat-Signature: e3eaptfqdke3eeebwyutrqjntf7gbqwn
X-HE-Tag: 1761238274-707329
X-HE-Meta: U2FsdGVkX1/h4NOR2xCvQ2aFBk/+Hc7cbP7ATRuZC5ZKTJHzhpXnvp6EqLaqeBziuj5suPg+3etJ2xBC8NVbWq2T0QG6XtzlusH+qcR+j9tMdDEVi1gKR3a+XD6qd3xf04+fWMz5yS4Vg5PZb9xvH5a0Tlf2i+1OiiSZH5XcIr7KSd5zhn0j9YBKI9xWUfQMO4RMhtdSc5pwFT0F9N89G+za40AxXjXM3Umg97nkEtNSb+We1eUqY9BhFK6oroU0lv75Kuc2IIhSIsVXHfG+fwrBtKGpKpxbyrSvjv7fjJnUMh8ejL+kmrx7ZzLY7rYco5voXwDgOX4B2vnf/UL/iXE1WRXOUVTaw+pFSpS0mmWgXny1DAOwpP0Tx1FwtvLx3S9K1ejVhlCGKBXUGvUXHR8qRyZczAZR5GYoR27Q/nvZtR+vZwivzghy4EJB9XTqX5ALJDN0JLC3LymZYzv3E7hTbl3/QhbYDnsm1TEsnNrdc6efrfrCk2Hz421H619SScMXSA2isjoD/MxXMhKyPg3S7e6zE/DmBpzDY2I94hmWw3nHA6YYgtVzIFoGJg0jBipt23vNmnf0FzNcctGfUHRAPw6+Sds74kRYhwBec0SgZkGmA4llnXLO+sqQJCDNwxticM5zybbDJd6tLmDJySwTLgxFPyROMh/HynXqqqdqeuf1v0yMbJpCePDb/gJihDp9C17pMJtsedeIfXkdPpN12AZrA6zXmThg/N7bjl2wYcOv579ZO8g7JtANm3lST25hL1aEvkXn/lk1h76TjiIVOJKmu8dj2Lpf8B9om+hfEyfJfFYq/uZhNjHel/gYSzEGipfGn8b8aP8AFM+qXdz2p+5prIsbLIJOayBUIOkfAe8XP3Rkil0/UXxOjvWVMLUdCLBQE7WKz4EWXLWpBe/upvSY38VBxmHFuYJxyAGWDNdg6SoivOiwIvDmlsGlHa9LgdNiY3BgNaJ5Ztu
 PYubaQI4
 ia80ILoLPDAn6rrfJ/jeVfEQ1RLhmfQLc8JztgnbYXa5DlSrF0/zndjawFIIRJZjuH007FyECibnMLXM+g7iEfULAP3a/i3zavQcdePIzIfqIBnHMFaxSaFZDGJ742udb94OokmX8jWnt5YZ4dRNyAc+k43mNahL3rABvwBUNPiP1quX4u+BaUEpXjx/yFF3rJpeJLDEYvaf+s7xHk/1Tcl4K7O6j+OlpP3IWPao/JN4ZTYo4gbQIXl9yzwY9HclN3ztjhdp6uEJjfr+kOWBYzz10/+SpsHK2TimTch7rjoEUJWOsTKChJuZ2BHsVkDr/zRFpGyns9Z/6fWvwca0cqqpkFMmgTFFrCvhNfPpISS2MsIjzNB9f9En3PKviu+k6TnjqbA9Y892BuVU5Ry2/6VITGLFXnLxuPlt3m5HfHIBZz6IgtsCu576FOVdWDxdyWEtIHD+3iAMEYckuzKpYW/P2acbg8bYeqVsViCJh/AgJ2PILd9s3VuBdRXUSpjtV0oBiRT+xGAZNA/3rfI1lRU07LFHn+Bvb+1WeMXoQmhcGvSfqcJ6JvC/x51MkiBwfPG/w
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



