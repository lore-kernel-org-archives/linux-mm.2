Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D39BD339B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83016B0289; Fri,  5 Dec 2025 13:41:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08FC6B028B; Fri,  5 Dec 2025 13:41:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ACE16B028C; Fri,  5 Dec 2025 13:41:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 88FA36B0289
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:41:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F6E113359C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:58 +0000 (UTC)
X-FDA: 84186286716.28.B070EA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 617A7160017
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sj9th8uy;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960116; a=rsa-sha256;
	cv=none;
	b=KVjdymnR7HkyH5Asy/mWQmMAeqkUcuwwkOg0kQYZg0e/WVAWZj+DBuiQDHgeazpa7PlNiN
	bqTPyaK0XjIhTEVsjP2WrvVAXYncyfmOhuYSPVG0IKRBeAzWZIVN2jUPgtGxPg6k2PZ3U8
	Y6Yylq6QojVXUPAY/1DSrzBhR0ePiv8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960116;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=15a1Dqs5yQoouK8HtEhlg1dhMxgzwFQcZfCgG6XGWSs=;
	b=Jr4iyo090pTsBQkcS+j8uLlDfpirH2gHUTT5kWJxOYtAyDoAVQZm/hLZRQJW2hAN7wsl49
	FP08islaxLeBK/Xj9tgAKmfixkH68l+IEubjLA/QsR5N7NGwSS07d6SVoDOJAACqcShm82
	h2XVayCcTx05VfnV/z5fZQO427aBS6M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sj9th8uy;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 297C24453C;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5A6EC4AF1C;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960110;
	bh=4LvuRng/siwmu1oFj3UqAUW5VyWVgQ3fjBU+uxBnUDc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=sj9th8uyo5eOpCcjg+fKssFKd6Za8RyKS1qs/rvU/f7viC6l8sqnGlgvc+vLIQjIY
	 hyDfm7/GnN3CkBFiQW8tTWzN7JQXv0RWze9VjKoJGj7IwEiPMwEXgfo8jSKNcV1zTD
	 YDdgc48BFa8TcrC+CYIN6wU74vua3CrNciMweLTDnzHvbKFHREQ7K12rDJGdfgcRVv
	 +pK4Bd9qAUvEC9kbpW2ojcN7Pbh8rXAZMfRH+FsE05RI4tJHeAfqef4bn3sdrUJF2/
	 TPUQABHq7Mulr/YrkErkNEP5OATREj5yakpxjANZULUGhvTKgX4f6rTkA/TyH7yoqj
	 HZPM/oM3iKhng==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE359D339B2;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:47 -0800
Subject: [PATCH v25 09/28] riscv/mm: write protect and shadow stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-9-1a07c0127361@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=2600;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=m7ME6PGl9KI5AztkhWmEf8JbroLdBQJ+d2uYeaaihZ8=;
 b=OfaI4Xk0SE/CEsch8fnFMs7BcOTZvMSxkM+Yd8iq8w0TjiFlepDXeQmTi+YE0JpUmchqwv41Q
 2imZhH+IVQNAh4/5Xw29E+MR6Km3/BNv21XPsodFkc14BNLEd289Nz0
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: 617A7160017
X-Stat-Signature: digifjhtk7qawdd3q37mfo1a1t9yu14h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764960116-261878
X-HE-Meta: U2FsdGVkX1+8rIhwJU2o+Xu5lK4o+ZbIEMZ81clNOTX7PmZfK37ExtzTyy93H912t5AxTaZjmF4GvT1rtjYhFn+6trMiSjK5zt3iRHuXeSb3JDZqo7ZOmag7ZkeoVmf4k5D6JOXFceACqd9NTXYd9xFVcpUUxN288a0n5tHHzagFTS25Laq8qowowkSz8Hoispmf1e2qsivU/vzrrYk7PHRGA3+J1lAR16zgGRJX5dM8OjNzv/b1zCZvomGZ8YoydMyDn5rK/o/J414Y8hS4RgxvwZGWJJCuIpk1E25VI8qOp1MKvkjg0sYIHTrvinBXkPwRAKpGKEP7nOwBa4mHSgcE/GK8DrNOMdiHZAhCvWHkjalpFxOKsdvQ4OrLXfLMe3d5v7RRRC9Ha64ZqTpQQOrsSVszW01QWnMgWErnq/QQ/dg0dvwFO+1UYcqy3WbVmvNIX4+vN3nr3UfFZMtoI1Pzwe8wMr0oKzM8nAoPF4KDw5AaxdIgx1QjZeIMgfbOnm0GItb2AjPzSZ6f0m+eFcbUQNuJKpVET2Q0TZTkOpLG/VZSAqNK4aqAPkUed8K1dcC89FoIMAHnXcECMOv0FPCI2QQJ2CrSubdQ/pQyDwW0XxJM4/7fovSDR89jqMw2zDH/Et9tnywGCB1EKFTS6Ux7mzVApsBelXaqKh5qaztL+v532Du2Sd+nOh3C2XWc4QDVV+Mx0GHO00NCDIHyPGZYzsmjD7KhQ9NdlKKNpYJdIb/dxlus0YbpjlUWjW001DQ3hnqRzTOiPq49nHoGJrkH1bjz9E8ppp6W5KZY1HKI2Tc5Ow0PSWzHw8aKEu4ANLWvw6iBfn6Y4RKuI4zNP7AS7jGLYGgJPLXK0TLvhxju45gv33Hn6d/h3ElZWsk8W5ldkvp8Qfmm9izlZVkaRp4A3/wWBACi+Mad/e5KChSOHlL3LDN+8c40cCuJgFKDEXUJ/isy33rq6a17qcd
 dvaiYMfQ
 jbJYzXB2XmwgEjk6h1bhwIYmIDtR+O2M9vB/BX1MYTiiKvvDDXsyx+DNnfWptTJdrdrR9tL9gbLtN5gv/EVGHrTyvdsC6hi2zrKkD0iR/chnPXD6xIkOL2DKc16zTehDgUTY/35FHD/mlIWlqh+pes6xRDkwif0Z1WcJgdqx8DuSs40RYYzvgriv2CRO6Kc02Wmf2PWGvwYv3u9o2ZFvv0wmBmxEfc4+4+MW15ClBJ7Ick1cR5ecFSGW1VCvdOQCStZNAuOdMEgvFyKiZarZFQHkqrgNsouE8jxoxe/6Ee8jMpXkk5zXp6HqliK8rsRAhEOKomnZ8UDybPbHAjTLAdxk/8y1y/rFjo4Mh4+uwl3v5wH3+CaDVZiOxKCW8baizpbtoJt+mZqoGvgIGx3POvfTseXk8Znqt4FoFfXthHAsvu3cH6YiIqmeUEAi4hvDFT9QSVWOGs9iVWNsCQ5tArn5iDYxhTAZOwD5lUFn2MR8YqOMBQs/L1JqSZ3yebksrpMtlL3qhGBBhr+dEn/4j+g7jqMuv72NszuCboqD6Qj2QVy4j/orllyKQx50Rttnz0dQYInjxbefu2x53qw4Ua26Ji0qJCTLbK1jY4IQTM1q2I/SYu68oMyQD1CiqlSE/f1d8
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



