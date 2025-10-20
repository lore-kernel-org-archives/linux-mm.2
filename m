Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54BD6CCD1AF
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A058E001A; Mon, 20 Oct 2025 16:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E368E0016; Mon, 20 Oct 2025 16:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4918F8E001A; Mon, 20 Oct 2025 16:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32EBA8E0016
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:23:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA1A4B7EEC
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:23:00 +0000 (UTC)
X-FDA: 84019616520.27.C238710
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id EAAAEA000D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=JpWqUoDF;
	spf=pass (imf15.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kF1sb2xLtNJ95mXf4y9UUDJse6Qaa7/WyS6RZ/Me9sw=;
	b=aMaDbcY36nWWCvnO5jO2Gq0erORAzxlu80Y+bbE/vhCMGmJM1bwtHPF0Qlpa6n3o040gq9
	dboBB020UAhZmOzR8pz+ZfeUGB+Aor3w+amWE9GGQ9/GlLTaFekBq/OqglLU+tLlToXxdC
	WrSBUcHek2xCfva5fbFqguhnuokabqc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=JpWqUoDF;
	spf=pass (imf15.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991779; a=rsa-sha256;
	cv=none;
	b=uNm6OJdRxDHPAlofYyJDDeyZ3K6lHFLJCNfsTQNZ+EAeXNpmbMuR0z8TZdtpxNk4XDPJwR
	qqTOnZ3iQj+FqNmgLQ96qHcm85Pm5fh6TpMSLWkQLwMwO+zJdg+YAcob1W7NjFxIR62wAp
	v+m9GI/n4K8A+1eDOILhneu/KVe1+G4=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-28e7cd6dbc0so60310225ad.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760991778; x=1761596578; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kF1sb2xLtNJ95mXf4y9UUDJse6Qaa7/WyS6RZ/Me9sw=;
        b=JpWqUoDF0qwIzohNADWbWG69dSLgd6BcwaqhRxMZ5qHHPRtPApGsFM+0C8e7xmzGBG
         CM8y0+BwV+rGdPO97ZsnR2iSz0HhajuEFhr+gqm8q3H1Mph+cJU2W4Gm7Bioslr0Ifzm
         qm0aPhinvJQmURSoabtYK544LWPPXK1ViG712fc1uIaFVg9AoXW52MD664pTi1Mwf53K
         taPvcTuOpKON/0JWvLkkz6DTlW2KQdq+IBlsiL4uKh9aOw36hYLSnv2FJvAVPctZvC8A
         hdpIbORRrKcTGjb0yt4Si79JCzygvMX0bl24NaROpzjM/gzEE8oCjFgoEYooSQGMQN8j
         mYKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991778; x=1761596578;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kF1sb2xLtNJ95mXf4y9UUDJse6Qaa7/WyS6RZ/Me9sw=;
        b=QLcWv+HrsSIY88CVed/sCYXqKvpW5cclRvh4QF11nJXdsGmh7qRxrJYlMbA530Rkwe
         0Nv5qVcgp55bImL5GXWOqr0DpYVUA4IjIhT7AM6eaf8WHRbOK+X2xciv9nT1jGkD/OQh
         CynazM6BDn3+SOxlRdpzYEsbf65TyGXSwXhwThQ16zgyIBbwxk2n+QfbvzW6dI4s6/6J
         HwyKyhK7rlGE2vzTdyhDL8Xx3oCEOWdqPwAPTzKC2vgDqcDuz14HwmyB6K67v4yUBVYO
         OgCXpyrRG/uMslShI2A+JS30MD4sCgatgkqBN5MAQWSWO2RtuefT1raxCQd9sS4Ns6Xt
         bbDA==
X-Forwarded-Encrypted: i=1; AJvYcCXTHSpta/Afz0W3NW3tJN+PJq0MYIoWATNhTsWcSNkM8VduYARN1T8NrA0kSH45ZJHiB/DdiUFuSQ==@kvack.org
X-Gm-Message-State: AOJu0YxCTZrgsybROXzS67KhOFbYvRQAHD3h/hfkrhaHtR7d5lCzRMi8
	Uf9WDPLfYvQ/15XXeCVYrYmJ/cN3KKjpZuAStQosJtyeyUqIyPcf7fPaWmlnI0i8GRo=
X-Gm-Gg: ASbGncvBWe6eLm+9HtMEIYr0uD6hO9xBRV1TM8d+LZ4iQl3QW0zSLBU6gfEZW5FBUHY
	L2owclNxwOdlIHioPop4eiFzoR8uLNwDTYnrIYwxrcvn1kuHTcADvtyECi/kLIZxl3Syuym2BgO
	E55OaLpAHiRit1JwXcYGtCfbyspBx5X+p6Y3gomV8bgoCHo/jZ9ihmTwdLsbaHU90YwB7TF8Dur
	zK7QOfjLSCyej3sS8saoY6yzF2wppJvB4p72MCpN7HPFFGg0nyGXb/OOLCAhFrYcG+2E4MpsHyk
	OyZ/NCWFIRIz+UJirH5oXu612rj9JzJgCjdZHJ1P+8bjZ7NTzElA/rsegoVxzd/7V1gPIAgif9u
	uK0hZLYquw5pewHJA+D+4WrJ7Ej9CJ83IK/7IP+grdkJhz2dHa8ItLhc4P6bE8fFKM4YjWsrtdH
	3i4ZPrkXOcWg==
X-Google-Smtp-Source: AGHT+IFjI+Eo/gAZahP1YhdcXcRCsIf19VRdgdLmzm3oNcVwOeVwlLY6tG5kcvmHgKRdDvnCUjEyIA==
X-Received: by 2002:a17:903:98f:b0:277:3488:787e with SMTP id d9443c01a7336-290c9cf8e7fmr180686115ad.12.1760991777715;
        Mon, 20 Oct 2025 13:22:57 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a766745dasm8443240a12.14.2025.10.20.13.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:22:57 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:22:38 -0700
Subject: [PATCH v22 09/28] riscv/mm: write protect and shadow stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-9-66732256ad8f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EAAAEA000D
X-Stat-Signature: 11c938omr9x16bb647jatn5jp4jwqjeh
X-Rspam-User: 
X-HE-Tag: 1760991778-384156
X-HE-Meta: U2FsdGVkX198IBM6L/TYdY0+xK9MHvX4vdW4zQh42mFG7b+dWEiKxIHuyhxjvBGA2iHOHh57Nrhc+iX4Q17rDOXwadBthYh6XLvV0bEeG/QtRKgnLb7waMSzzuXQKc33b/wkClZnfVTZX9SqQhpPvuTSX0rdyPmfntsaDzjnLsY1hRkOcdQRYKo0S8MeCNO3/3DMn6K0Asjq/WCdB5x6AaOFonhm5tSBwml43hwh5V5BtEYGlJUqv2dLDm06CTY7vft6so55v6OL8C5WmpgelZQhXYvisbd/x/A+WmFveU41ReYdXq7a4WnmBpmIgvTDgaWxSMZYIwt/3obP2fM2ew+BYMBhU0x89/fY3WJkonHATNbhRf2wo8jCwqFVY+TTpiVDfVk22CvWbtAx+iJcIAMXH8OHpx/qoyaaUPFjTslMSwfPr2Fkoiwvicoccd5yMI6gG5XbzxnHz3LxvawGSJ9N+AoLM4K5RmE+hq2K7Q3T/KXWbSdGNwWWSLrP+xJ7/a5qJ7E/yBOQxWeEl4AxRrkxSCr4p/6KiAhYC1GE105sJLNWcuR2eHEOI8KsI9YZE31g3R2/eP9HS3AA3psKAx3j29D3eCoRJZw70nAf3woesDy1GCRJ4+p2uGuOePEpNfteehdaOfWlpAH5s/EfaWgxfvD4ow2jUIA6PVLiDi8aVK4gulpm3pJ5MNSZtZ+fxV7JrwEfqe5kkSge4D9r1bNHQi7M2Dch88EJfpq2r5S29YC2hhBAOZrVrU9vSm3ON/JTChgwFzjCEA/tDqRCMAdqMsirZTlMIhnWCLpypf42tKcqqY2SIA4itXAMEkmA/DUv4f2YKkHIa0cwnvPZnL7TzCbyMySPjIjfPPD84ZAnXor/x6TXclF2gjAFS0C+CPraEqXgwsSy0ZOg+SszJrNvzqy8F8P2vlpOVoGHLbJ7O+aBPuVvLSdAB9EyV9r9V8/DVM2eU0kA9+bCHxA
 Y6swPfkq
 KEeP1XASXrVPyc63g5liYCuCs2pOvQF2R9m7Fyl9dJfOZTvVVB6uOcgXgyeGosm62kSdkwVJPaLJB8FEGmiQ/eK3XsCl/KKF+VNaF/UzRODaLpxeL+DsYisjEfcQr3LZPGJcNzcpcdy4pGpkFP9gM6u67aVvY07GS8icG/VbhwcKN7LwrS+6z+RWJMYny10VmDIkEr5NWpHjEsAMzYhDhKTtnb9xvatIgP+ghBZDaX410t36TleS3DSg7RUY24n7y4gC5pJuqH03RBuo3ZQvOVrnG2ghzxR+71K41EY+sw+houwjs+QNDS+gvO2dfBOi8hzw8UzKRMBtNyIKstlUDC4P36vGQYnMIQBss6sgw4uXXCNOpJZ3lYhemmkMywQseaal0nz0+VM6+N5lRUm3kK43Meh2RquK3yPxr79FCG4Xw6pLM7xenUpr5Y/xr3BAhqznhMZunVjTg1oe6ZU7SR8GhB4MnQjup1PVa4IEMA5WsatXd9Ung7mUdk9djFfaKmYoM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
2.45.0


