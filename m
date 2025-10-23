Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F77CCF9E8
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA938E0012; Thu, 23 Oct 2025 12:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F998E0015; Thu, 23 Oct 2025 12:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6498E0012; Thu, 23 Oct 2025 12:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDDDA8E0015
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7DA1C0BF3
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:17 +0000 (UTC)
X-FDA: 84029969394.05.EED2433
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 91E9C18001A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hB38mnwV;
	spf=pass (imf24.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238275;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1nI+rh3wmH9XtndnILOW1DI2cZC3i6DB9bi3SvCfL0=;
	b=X8ds+yVqWLzvu4HRhYNWMz2JLH1272Hl2WC+GqXrKrjKFdc+3ilMwryOjaMSNRG5WKENmt
	bk07INw6hioZD0D4ttxqyUZsq6Bm3jzrmsdTTd1tAdCGT9DNhdDZYG9buCWdkPrRLhupnB
	wyR/DcxnpQ8r159MEQvNpAK/FsTRGMA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hB38mnwV;
	spf=pass (imf24.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238275; a=rsa-sha256;
	cv=none;
	b=HddQBjiK/TvVuoF4hhMVXOLDXhjXv/8izgTyECjZ1pvJoUIulEzxZ2jUaF4xPcO7lTzsl/
	PZWttCj9u52GDnZdFerfJi1ygQsAWPTx0T6Z8I5zTTM/eX45hVCFWWpvTv9f+HIyFCl9CE
	hwxmRJd/WLrBLS4kwufaBfBdu+Q641g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CFC0C4AFD2;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7EAD2C4AF0B;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238270;
	bh=F5ju6oKJAylkflMB3tXqXcd6vIuwrr/MPiKJ+B9Ss3Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hB38mnwVB4iSc4U7WceEGAPxYIoQXtuvh/qLqmFMSno7Lg9kC1dbWLTSN50cSRFAv
	 nokoc3Ywv0M/nt0XhF6tMjg2zuZxjlIr0Mc9UZ9B390Lp6AymoWQB800DEHGUAfTHf
	 0yHxKeit5+6PtekFnJg9ZPEWL9A4aCHfNPfxlXMkQZvHIqWJhCkG8MYKl9DgR3O3uM
	 FbQzNKxLkffKf+omorGPrDmTTlqNDI7LuWiY/eznSexT0Pd/FR1DmTM6Tvj6Dl8u3X
	 43Mo/BqCRWxlfwPwhj7ActmhZrGqv8uSXezUTem/kJ+zbEfPx13/S7ZWvb/GBY6q1J
	 s4oyV0aVGWTFQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDAACCD1BE;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:14 -0700
Subject: [PATCH v22 09/28] riscv/mm: write protect and shadow stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-9-1935270f7636@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=2474;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=zG1PvbsubgVB7UstpLjRtN915FxsRLFbcnYegAn0YwA=;
 b=MOYH+M9XiFkmQH5an8qIwtNnNTe1iJrM5qBubNaFXeuZXU4mI0i4qcQSg1NxEzkrxbT0MUI7S
 ITCfjXuPAzxDXT5Plujjm5jZbk7IyOgVCHGjcXR9u7LZ4cfKuG1++rd
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 91E9C18001A
X-Stat-Signature: qd98kkc6m5d8puq8z7j6i5qswodtkqhb
X-Rspam-User: 
X-HE-Tag: 1761238275-244237
X-HE-Meta: U2FsdGVkX19xiHOYHEF+8twPu6WDEgx7qs2sdU7IOQ8yVorXNHLb5LTSDUGAb2gWilmXyUx9iXs8GYZXE6xwZfkOXZNY6rDgBNcpLFoQuwXSJYmWzv9FuKSWXO7pScklpHgazEw/W5F0VSolFuG/GcaHBO2T33+e03pfjGdvtdOpbAWTV66z0wFzcYQULjo2oIDjp9rzA3J+dEiDVKkQpbOGyEJaJfSO2I2pNoKGVBAKP0D5AOCXp3d+sTAnpvf1IK9iQqru4aFxvMO0NIBwtdZyZqqhiyeeW83oSTPev/uSkRchDKSxlbm6ZKB5+LQ5acCvIrqBE7nb/wu14HHwL5pCckYjLTRJ+Ws7ixc2qb6sFXBfogfm7QMN3/IwbPf/TcnSqpUXW4XDiIhcTxFs/YM/6ARUkweq9rMOaT8YwDBSC63xhzXvyRqag0AJjjRuXFiiZEMz7ofzby5qgyUZ4DsQqiXHJauidxjj+COL74llB08+erm4ZTP7CxVGuDnrslt8dScs0/ZANC0Hxo65paYI0UiUR8zdb8lGBgw1SHnPOVFCE4SZE16YuX+sUXXYGDlSPpml7i2W2qrg5fod2G4BdNIGXzinyyl8cNxq2SlRrmLrozYY7j3USw1bStkCzbssoRwjuEr0rE8WckSpsKxJxPsRiX4WjndceZcS6CwriT5u5mWrpkcdvGZhiNmkwmgnkC9SIBbDCRpFjKAiCggWIHfDoOfjvGjbyTc3515/zvpxQLwINCE3uzwBP0CRX9EAsXXyQViK73hs6Y8VVpRWvXElJzvdJdJpO6SYIB5mmnt7OV4v1iA5UWTU0oGROSNU+Phcw4pgnlA7CFF8tKa3kKXFkPICZbQaBC3TA/EGaGkQJjEz+kubdchtVnmbufoT68iQb4Bbtc3Vr39J53AIZrqTqhcSI2FusZ6VIWdbh8WcpCiswyMqTuqC7nmnFThKw6L8D8tw+9gNrxA
 qGy7uQnq
 WENtTb2ZEvzqw3LFo+VLO0sXeTc6QXlOLk60a/vZ7PzwKjRAy8SXOItZBTTWLvyz3xBJtMg8OAf+GJD2EDDpSasBivyWO9S62I9KZOEVCJAW4zzerPrrRwC4sxcqOJomC/bn+Rov+p/hIB7lGHdfWlLDPGSY+DjFu816ATOaVbk2iP6UG5BppJSsYEEzAf5WLdbvWqrh55a5Op+D8UwKNj6yZMf6WL36m4SUN4tLiDqVSJdWAqrqZ/5mUO0S0MLU1ZeK4Vz+p6sAtDL2GD4UbMWx0G7xRJ17EP7I2vygFMyWt6jXWh3AWwY7DFWlcQjwkKyym5uQpHTTAvmmz3aFGswUIdOXYRahoWvKHY+L4ozS0y9ewk2L0CjmicSb88MGdX9qdJii53BAW58QYCH/cahaKneMmKrBDssHbvhfKql1HzN3Nx5+sDjHVEUeNRHgvZKtMRu4D47Sz+OrB4LOc/5d+Uj5Zw+Q09ZkUoMXaG5ttL55K+ZfUvAUkAD3XpJOv5JRK4yJrYJ5pDDRyx/dzRyFSNad7bZQuC92IZdQfjbUI+QZfx7PsvxD/5w7WVDJ7+pQy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

`fork` implements copy on write (COW) by making pages readonly in child
and parent both.

ptep_set_wrprotect and pte_wrprotect clears _PAGE_WRITE in PTE.
Assumption is that page is readable and on fault copy on write happens.

To implement COW on shadow stack pages, clearing up W bit makes them XWR =
000. This will result in wrong PTE setting which says no perms but V=1 and
PFN field pointing to final page. Instead desired behavior is to turn it
into a readable page, take an access (load/store) fault on sspush/sspop
(shadow stack) and then perform COW on such pages. This way regular reads
would still be allowed and not lead to COW maintaining current behavior
of COW on non-shadow stack but writeable memory.

On the other hand it doesn't interfere with existing COW for read-write
memory. Assumption is always that _PAGE_READ must have been set and thus
setting _PAGE_READ is harmless.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/pgtable.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index b03e8f85221f..df4a04b64944 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -415,7 +415,7 @@ static inline int pte_special(pte_t pte)
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(_PAGE_WRITE));
+	return __pte((pte_val(pte) & ~(_PAGE_WRITE)) | (_PAGE_READ));
 }
 
 /* static inline pte_t pte_mkread(pte_t pte) */
@@ -611,7 +611,15 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
 				      unsigned long address, pte_t *ptep)
 {
-	atomic_long_and(~(unsigned long)_PAGE_WRITE, (atomic_long_t *)ptep);
+	pte_t read_pte = READ_ONCE(*ptep);
+	/*
+	 * ptep_set_wrprotect can be called for shadow stack ranges too.
+	 * shadow stack memory is XWR = 010 and thus clearing _PAGE_WRITE will lead to
+	 * encoding 000b which is wrong encoding with V = 1. This should lead to page fault
+	 * but we dont want this wrong configuration to be set in page tables.
+	 */
+	atomic_long_set((atomic_long_t *)ptep,
+			((pte_val(read_pte) & ~(unsigned long)_PAGE_WRITE) | _PAGE_READ));
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH

-- 
2.43.0



