Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFFF2D2A525
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988706B00C8; Thu,  4 Dec 2025 15:04:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960256B00C9; Thu,  4 Dec 2025 15:04:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F646B00CB; Thu,  4 Dec 2025 15:04:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 620AA6B00C8
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:20 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D24813A52C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:20 +0000 (UTC)
X-FDA: 84182865480.27.7D02D15
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 238D220016
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=JmgBT05o;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BhzOXQIeKPGphLxrrOEUt0Oa58R/DXqd+aRrNPmfj+E=;
	b=XDzqH/wCmQRcKtAIQgohNQN7wgr58jcDSH/XEgeG1G2Y1PKVsmN8a59WPTFTR0eBMR8iyL
	sbEnRCSdA0lWhBYVMvUHFSdg0wsDep8yEjFpg9maFxmaBs6K3zWK9+RAtf5564opy4qs/C
	FW2GL9oaHycUzDxjkO0eJ4MGXqSWLoo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=JmgBT05o;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878658; a=rsa-sha256;
	cv=none;
	b=PWpNpeKagUdgQt8zQMjZ6kgFZAu+bG7CZbuiT5XZxKv31RoMO9jDKazHihx0kOcu6wXH7m
	5M6N6XVMra2sF1fpaZkNTCGBWsZwIPPWFh7DrW8JJUMFdFIdIaI8DV/Nkx7jnjMSpTO45/
	K/+CW0iss0X0cCYZ+eKERWrqb8jYYFc=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7ba92341f83so1631842b3a.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878657; x=1765483457; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BhzOXQIeKPGphLxrrOEUt0Oa58R/DXqd+aRrNPmfj+E=;
        b=JmgBT05ozE4qymiK9bN0PzJZtbrrOIw/BHl8O/T6jEHrOPZzl1Jk5ovNs47aCMJnpq
         ZILvig5vYgctJK3waaR2av1NWgXFV2y9S1A63diI+gCr108UtcG2QQBOWRoJJ5vohNYj
         8yNSNAxfyOCS6sHDHH/zsLShVXRemVv7A0vAi7V3VIgNFJ+xvOW/FespHdOCumBJ9Cp2
         K3ZeFD89b6Y2tD2uRhHm4L0wi+Ngq4IWiAKz7c1SPPYmFPczftAG+N5jl2QwX6pslTNe
         2RLBM7Bbo6fuoPl4dHptzHnYbpKTEwSikMQnQvTGOjlSPYFdIwb+OiXiPOn7XCDXJ69+
         +uww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878657; x=1765483457;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BhzOXQIeKPGphLxrrOEUt0Oa58R/DXqd+aRrNPmfj+E=;
        b=DF+31lnkjAff6IGpzhO/xd5VgoCkisVlziFGWovJgoPJCcknIANkQamCKG5oRPBiWi
         mO6GR62sQtvTaY3QwqKBnyNCY0yu16r5rfFkUvuBj/Mx/B9eQ35PalnjYqyTYmEsJiAP
         zWojDMyRnCYx2bIfnfg4wgGBKXkWaZH0ma+c5swf+fsm66+88ePabm2H87RBEzdxaxA8
         X7zwicrM9IcyG8hUO53/9GvZSjxqaEICbn7tPACaXVDi72VBr2TWNKNGsjFf275RBh2K
         QTax7C8jEZj68YnH5z0PGF7lrJn0mUSdWa/s2+OU+5KRLb1KyKm1E1XhGsawS/C7Z5cv
         MMTA==
X-Forwarded-Encrypted: i=1; AJvYcCXflxPoKI3J3qDrfu1GizTXCQxDASXsWVQvxoXgRfQ38Ngqawj6PQEfzamraCew+hPu2P1n3enZFA==@kvack.org
X-Gm-Message-State: AOJu0YyC1yZoQs/s9t+TyM9dwsViENiQHPOzRwcM4LxOImvTEA9Rgya+
	rk3AgACHFN2avMVlFvYhsCwyPy6uGGA4Wimv4mNrwIaVcizaq5nPALqHf1G7KnNqIvo=
X-Gm-Gg: ASbGncv62qIPeiqug8Fy1zGt+yr+ewmFCk9SVLJfqLTJMqMDv52RJ6aKe1JYRBVAwp4
	64xa13T6E3neLln0z0fivQXVlPXTRPOOyAOr2SafFJnw0GQwnGcNihdXSzMygA4iXN81HcHQaHp
	ZGQOFog9QhiUgbo6razbOR1ESuU8HwSE54y+CbIEEpstfyIf5jnHk1l6aJ9+sfe9Ir7bzy6SIDj
	oD4bmYiIX8xZT4BbumKFuXVxdvwZE1MQ83HCVYMCQP9ZgRAAq86gufpLnbElbFIlAOag6ARHfVv
	Uxo4oQ197P6lXt4zFTg0/itQCOvst7u+XjxvI+OS3q9wNzF6o7SRaXm7Pr9JHu0Gc7GZxCESjWH
	QlXPxP9uU9zzNFtXCoQsUM9GR9rOOMkbuQC2S2T/zQYF7d96iU09E3KtMKTYsGBoViwrvUeTCfd
	PPxMHjMNJUaEUA3dyLut6v
X-Google-Smtp-Source: AGHT+IGFh0sV8K3YM30SGR/TeRRCbuWQKSsLII8uaKG0pjWDWdO9phApXXsMABddoI0pDrEfs2joRg==
X-Received: by 2002:a05:7022:608e:b0:11b:c1ab:bdd4 with SMTP id a92af1059eb24-11df64af432mr3149166c88.38.1764878656793;
        Thu, 04 Dec 2025 12:04:16 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:16 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:03:58 -0800
Subject: [PATCH v24 09/28] riscv/mm: write protect and shadow stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-9-ada7a3ba14dc@rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
In-Reply-To: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878635; l=2600;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=DJZ2aJIoeyTvFOiDWAJGj4EuG7hZunP7odYpwBb+3MA=;
 b=V44PsHIMigORyGMx65St1otJQpXcs/c8txcdP6sR8t3hFePxiBSJJTUudJDieXaQDuwFWIgx0
 Fsn4n/4NJ/rDp/0y8KXbf/bVJBdFeXiZH1dd2WqsJ6zjcjREaYj7YBZ
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Stat-Signature: 3r5jigt7w134r8antw71cofswkt7c9i8
X-Rspam-User: 
X-Rspamd-Queue-Id: 238D220016
X-Rspamd-Server: rspam09
X-HE-Tag: 1764878657-151372
X-HE-Meta: U2FsdGVkX19dn6zUVtB+44FAiuwBqGwK+9B2wFZssyMQaEtmY6eQ84qzkHeUBAPdXA2yxdS+jukcZMbHanq2hgRNMFP/VDgY9FuG8y+sCdH09SVfmXJS/+rQxW6LkX8oxho1nVsCM4TyA4Rew4FPPnI3iX73B2t9Xm4Ywtr3W/8JvYHZeAlleCVTEpV916P6iEcP3GgUE/MJHRuNnM83eGYs9/sq9u4L8cpjqcn7Zmq1c3y5L1XBXijRnfOz/AY+7AzbqB+lPiDfgBcFDMnBI5frJDl0xYnAfvV2hIAoW77Mm5MmPKmfkIDJ/YlmJmypkfxyVxHjCBaR6maD5FeUF1/+BU40y4k59ciUVvtNnO/Wamso3Tx2rjd0X54ytWEl8K1xsg1qogv/fNaN0Q4csGfdBNt4mgeRkUrhJUJ8plI+Pt1FOEpuI0tkr8bZmtFe2cuoeywp7uaDNgueanP1bFn5rKmib6Tbxr/K2EVNXaINK91XPXIbt9AzG5CjaE07GPn3PWPr3CqWDXjCDh5Ak/itEN4o/YXEdgrklhxjWYCKoIMZTnoGAMSOhtuNzdFJKZ/hc37QO6SaWJtdL2i+gHhi4FCEksXM1CbvvespGZ/NqqeqqZqFqul31QzvS6F5fFzy0rLA/7zBDWZev4gzZpMTSuslecuXipqlXvWg7P07bajojlstc6Sa1/s5Ak+GRIcSU9aqBVWAwUuXiwhdl9h1yT9jouZ4d97wudmGKRiplnZWKZpVSju6cOO8ur5RYBreOhfggYhv8jCqKwU9qjaRsyK1kAoL83Z48/G3ew+SJVCJFjZ5tviVdam9SkOdPWjYNU3wEeda0CSEtEreC3tfMm8PMO3ZqE+7MnLFynokWjeg6zDT121jVz0la8BokvfIu/xNX9Ww8SZu5tqJZiYcmAYmsrOPGlNeZS1jr2L+H3piIvmiS5PHyy7KaXyKpMIZFgpPBaqomBUY4Sg
 Pm7+meBi
 OQnMBzgqR1FnkBcSuJLB+4uGzucQFUZsoHrYoFm28PgxdV6uk5/DSugnyyrHCRysRy4DBTngNSMmaN630SJA2bYF4vbcMwE3YKvnUZYs4kFkVZGj+GWfKfORtV+ZYYR3YTxDJlGMYyyEs2fq6tEcq4CcW5ssAgobvasEm4p4LVdt3q4kVqEUujgT7WtrsZ/I1i02QtSr5NkvdFlQ5P02vGFeg7jfJHQE0v2mC9Lxa6B9JLkCwKS3pU2KffCyBRyZWGiRVO/lOqcqHKPV3B3pqmrcxITLjcuKfhQws30A6sqO+hB1PpJWEoQAOYRI6MQsIc1rYPKyd2rOZCgXxJrXyupH8SUe1hvvP5E8M9JahPjQxDClm0y7mS+HvxaEgI9IwsJHsT9onOZxljWsHobjpRi0Kmq2VtqMpI5orY9QbUVuZ/PBa7rIR3zCbHrtSDpCga0+9VihSABcLc5+vW1Nfvud2JZP22Vc+qRg8enSMjVGukQkxf3IWCXRB2+XfQS+E5xWQz0Awimix2tJr1Cb5TdajNN1RIR4sxqdGKu5F8sjaf8XuLOrQujta9fmTODk/gdk7
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
2.45.0


