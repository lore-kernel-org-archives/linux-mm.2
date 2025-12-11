Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A24D41D6D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5B76B0008; Thu, 11 Dec 2025 12:21:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8396B000A; Thu, 11 Dec 2025 12:21:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96E66B000C; Thu, 11 Dec 2025 12:21:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B22756B000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E5C1160267
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:10 +0000 (UTC)
X-FDA: 84207855900.25.F919ED7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C150A40006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I8L5c3sd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473668; a=rsa-sha256;
	cv=none;
	b=YRfrweAV975/5vYk9hN3t1utgQlPqkgu1mBp0zvXLNI0Q2JoLVg+dJ5QSaPIhfKT6QJseo
	l5Q1hyS8cONxQfvVDD0cbKFB69wxTH0IAS9K6K1F7OaCfDNDzICM1CgXDxi+0RW3liTvCo
	sGEwfz1krljBrlCUmXesaKvWgYIrKug=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I8L5c3sd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473668;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=15a1Dqs5yQoouK8HtEhlg1dhMxgzwFQcZfCgG6XGWSs=;
	b=XidtmpDPBI23ve8idP7Nc6UFkpuCvs/cXwenztB20WyNHHwSRwPjrupWgnhA17OgVwGFIU
	rY3fJG+DkyesoXyWV6SKv7b2SqoSCUSCgKI4EA4K4w43NM2jb9qmXPQcK9HEFSuDCydcfO
	X1NR5F2cwNCk158agGkp/IBubJV6WwA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CDB7860163;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EF3BC4AF62;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473667;
	bh=4LvuRng/siwmu1oFj3UqAUW5VyWVgQ3fjBU+uxBnUDc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=I8L5c3sdnFHyk8y4eKujxMzAwyziRO8M7cGRGcx7q0Hm2I6MAR5nLwux0EBflmse9
	 fiGeEniz8/ehR+f00KFNfLo69v2p7er61m49RahVfLCD5TgRqMg7wbm7ZIPnl+b57h
	 i5X+vwP1MX5RnSA0qWLAnxzqtEQ3RVLcsWn2OKJRVx3INrF3WdqUJ2aFr7QMhqcWPn
	 +7QXrR6EYZgQVhTiK0wMH5tuhLh2DX4NFzcYZglZoAnQgYweluIen6sDBGSarj1J7B
	 EbGcH/BtghV02jDwtB0M6TC2zFgrmXWA33wRHp/7wnOCsljom+EOXxJAdIspwU1pLG
	 SxYaJBCLdLMuA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D828D41D6B;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:42 -0800
Subject: [PATCH v26 09/28] riscv/mm: write protect and shadow stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-9-f0f419e81ac0@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=2600;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=m7ME6PGl9KI5AztkhWmEf8JbroLdBQJ+d2uYeaaihZ8=;
 b=7r7tctPp48JTpLLMCrtR05us6p7SdJXkKkEEO06m1B4TlLQ16GoFfLyU9wxmcdOzT74COct2N
 jaVecpC/SXpDU0mrIX2zLnqJBo7xwa+24wGsDowi+y2qRTtlpBOvsDN
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Stat-Signature: wykq6sd6ibo7df6suup895co7c1rokmb
X-Rspamd-Queue-Id: C150A40006
X-HE-Tag: 1765473668-512267
X-HE-Meta: U2FsdGVkX1/d9oPHVFbfl7YbeL+sIyA7e6goLcNTIOz+pX3xlLSPu9uZJCegODTwG94EFxevUo9KnYWtf1nZV+P2y2S+HX7YkIfggiwLhjxihXxH3yovAMNSNbTs+IXkvGyYrgOeXD8Yz1oDluhkyAQkUjIthFhZFb0Xcyby159ZFVLHHbXG3VuUhDP0qctFQCQaLdDfJzqlYP+n9CA1By/3cWuKQ+/czcCDcvC097jZxQI5+y1fxBiRPuDg+P51eCVy63wfHXIyjzNniBhfrOIs9AhA5Q3e1GbXb2vEBnlpYdx0pHKJnehzpvw5d6U4Jtjqowiq51isCGBLMfuAuMAs0erdh1b+rEgToJPHOVf2lmp7POhMDUTN1qjGw89KF6rF44Eg1KTDWOeLGhC1xNq1P/ttTrUI6SSpg7A0N/is3KWLrktkTE2alf2BTRSwNz5/C/MJqO/QkINVg75/QXsz/4kOdD1XHhyDaNEvXgg/OVAtmhwbNUc/ftDfKGBjgKEYN2PT2G8LhEBLzUJmlFMUD46dwcxF9YD9187okCcPvSl0s8gJjTqky3vSKGZA257RFytSdZICd3ARRe9CDvicQ+/NjcuvW+EbORXTGz56HN62SOE9aQKryNkHAarqlTL69p/2RrNqxqt73Zqp2aM84/BWxikfPfhj7spBqmVZePCkE4wPONhyRLyoL7Wwq8t0kLCv9kfsrszhuATCmrfTwSkN3/EcPY/BxHUwe7AZD/dga6Nxs5pB+QXQw/UhQ/KOqByxtLiZGYEq3eWbLAm9AEjhCxe/P3Wsz3XIiBHFscjVUv96If8Z2V4+U/4naLrbGvGUG3fW/TkH/rB3QD3eAGODaOKQdF/CsJSpKMH0FDZmI2nU3kOZizJfFPC0O7ZINubFkuaZiLLug5Vj3WtyBtTwFlo5+ZOuMjyXvZEoF+J1b+zYl5zaKjj5bW8G6qwhWfAfisfq+br7Ajw
 3QXaXvGb
 jTYxd6QN1tfyjLzg9r2zMIFOkNtxK6oo0hUg0VAqKNtvygh5dvdVW7CnSPts6k/I5Jb39s4JF+bz4lW0i0JIRTGQCjadSpSaMq8bnIh2kfY0NGml17tqLrU/EXL39LZ1Rq4j31dO3nNjdW0rG5kREdlDKyDEPO3ufDJIF
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
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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



