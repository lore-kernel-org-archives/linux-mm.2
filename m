Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A8B5CD4F2C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2478E0016; Wed, 12 Nov 2025 19:43:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32D0D8E001B; Wed, 12 Nov 2025 19:43:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5FB8E0016; Wed, 12 Nov 2025 19:43:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E27C08E001B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A553512E241
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:48 +0000 (UTC)
X-FDA: 84103736136.30.A44F19F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B0F3D160010
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YMuwT3cc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994626; a=rsa-sha256;
	cv=none;
	b=nAPMsQG0NHnUGKYM7mkU0y4ujlticZYRy3zUt3+M8mdhRqdFWuSkBu87if2/HDSp5aiixA
	51i9CJPaKYz4Av+1mZ6Zo7yclyEQ6jRmDiOpANNNuiNLA+oq1cfAWgWUxbXiQqkGGrYPPK
	kNzkdisF71RysKWxvRPlzh97jksKfaM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YMuwT3cc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994626;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1nI+rh3wmH9XtndnILOW1DI2cZC3i6DB9bi3SvCfL0=;
	b=i/FDs0TYGTBvV/zTowlQjSB9zv0Sn5LL0cglFhQebhbGriHmlr8yaPbrnMWqDncAOcBZDK
	No9Eg2XffZSAn3u7JzwecZaWVjwD6HU4CwRJqcfiOT5JTGQquke6uAivkKAbEo4w1aA3Du
	QGjHJP2uQt7giafG39pglmjuLzhpFvU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2F084471E;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75831C4CEF1;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994622;
	bh=F5ju6oKJAylkflMB3tXqXcd6vIuwrr/MPiKJ+B9Ss3Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YMuwT3ccAGn0u94CHF+Dx9y5fzq2N4QZ3u7VGH54jLyGVP1ev7QZI8ZEh4nkyLKO+
	 p0mQZN/yUsnIxkUNM9h4P/RTvkBk2RXTg2vStbLxTiP9eJq5glde/IyjdOYtfv4YEL
	 0m/liAHgiLcw6ZUo2e8JKgESdTgYIsYDEDW5WzIBWlJqtU46re9ZfsqHyL6z9Hcw2w
	 AJql1n6Mz64ps2hgiFYcGNIKlGxAG5xW8zkAANtsdvjB9pBM7wut30sj34Bkn5sMPO
	 Sbxsc5sEEZEF4quIoFWl/3dnT6X9Nc8ul1bQAZHlioXLIiAFcfZW3GfK6o70pLvNfP
	 F7Geb4960u3jw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 626F1CD342D;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:07 -0800
Subject: [PATCH v23 09/28] riscv/mm: write protect and shadow stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-9-b55691eacf4f@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=2474;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=zG1PvbsubgVB7UstpLjRtN915FxsRLFbcnYegAn0YwA=;
 b=FKCr3/Ui4FXG2aRjLaj7Bx4a0kox4VrWj2DzwCIF5I6cf+LNdrUU6Tjg4LTlaGBDZSKei5O+X
 pJPHCn/esEyBeMzey62D/9z3ZrS2EQL16Q0b1ugcS2Q1NuwOLduJLd0
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B0F3D160010
X-Stat-Signature: ecdj77gkopqtuj7xq8mt391fmtdwktbn
X-Rspam-User: 
X-HE-Tag: 1762994626-56253
X-HE-Meta: U2FsdGVkX1/4CqDuBFG3b84u0JTnmDrKqvpHE1jOSViFjIlXyxCPgr8KswX2G9Dsb7w1W8HdtqFBBXYoQOylSA3Yx15DIjZYEKzokpqqYjBlySqe3log5RTnv/fwvCFCQkgkKpQirVyEIzK1bdlFUIwncLN/EXE36zvROCdRZ03u5dh+8z3OD3pdcY5oFj274s58baIsXsIzCHmNbwCoIkX5PLBIyhfUgiQdfrmmAffnUvlPKptxArFE7ZxFvFa+2wZCtM19by6ct3Ca773d72UOL6/SYNHbhgfWifPyMXnyT0Vfjfzr8ZitzwTly28s3FYzoiErLQ7ovlqwMjMRVLOrIOfkK28k/ylt8M9Iqp+UzAZ73MtuBtcMnC7wQcfGmAlOLODGYBmUPKhFLBU2CQYnVGqiaJ8jdAeccbGTDWfa6QWy5kr93Pcn2iKvNFW+L3EkonmDxZ/cQY9HijXx0DTaEAoipSs01gjQ2tqcboCIRDBxn+2Cop8c/PMo/M6XWzmnMbfRcGV1FoC1gMJtpe1nA6TrU4UYi30rjE4DV1zO46Ci0xuPFoMg/6wh9dAg6jsNUSZwl0X2NHxhsPAV/lydS+zGfk75HKl35bH+vRUAR2w7/ip1eLXV9qUtqjuG1JYsgbFogRYrMXYM5qpeBEfAFdGYClXVDVs5CAQDVArqkwPOZNta6RNx+23nmyIJSY7zRcW/TE996GyQUtJu1m8ZlVorVmEs0JYuUzIhpw4KZ7HLd1XpJmlEvZvRJuxilu4YXfRqrorieTjAzMkCrzG5prgI0H17MBoUMyri5Zsf7sDYXuDd3VkLqJQcYjBx6KP3zQ12wmo4yzc5DbUZNQCV7Px/ssHeSY9wEkIIyxZPxkJ7fhMx6yDPyNaQzF93+G0WwDKDDrrxzMzJDAnZpcmhN0A30mR6diAAgIvYYL3+pVOA+3Nq9P189YdNB2SlDwnizbc1biiPQL7wkac
 /Ptm29od
 20Dxg8dQMpY1UGjutK/qga/3HlnRP8eaJ+3pPtJ71TrcQ/whngkj/22GHh9J+/CcP2vVWB5ppvUwhj5FFwNpJ44cG/Fr5YLgroiIEHbkPi0WCuOFsJau6aKgjt9WBwLxN7qHxSpnY9zhRqUwJIyzH/YDbP6yqCLBc25htwlLTQR+fku+eLDEu/55r+gVVy31BrdiPn1TNMoEt04c8pOkFU6apc07CD6peRjTn7ztPsHVadpYzZimK2aA0QOYkED2gGTv+Q2cKtm0MDBWmlTx1X9/u0xLXYrDw5B5rmQMLb4k84gT/n8Faif/Uv8rBmwBCGISOgAsiLzmKY9FmSe9lyeX84sJto7NjdQXD5GKH+UbdPsyFpTHzrDAf/1gv+Z8xGEWs/0qJZopndR1YRH0J4+KVVIVNpZtmRdxSLQHW9VDt3Ok1RjOdmk3IQwThEdKMi/NSMNTXdATGJFtI7fTKtkZt/RXsFtNKoaR94Zvcl4AZ0CmlsJ23KL3LLV/ykkimObbHeYYfiWBiPfm4R+JQpXW9OaIUVnwa96HqDxHHOp+FaaAl6zlf0UKsVYph4fRzVbi7
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



