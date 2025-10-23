Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71DB6CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEAC68E0026; Thu, 23 Oct 2025 09:26:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C761F8E0002; Thu, 23 Oct 2025 09:26:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9FAE8E0026; Thu, 23 Oct 2025 09:26:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 92DC08E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:26:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C9BF13B96A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:26:00 +0000 (UTC)
X-FDA: 84029452080.05.AF44578
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6E52640007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=BSrNKMqk;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761225958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
	b=16N+51Y11BTyiIUAYvLarm/NHTR3xTE1XkUiVZtVLtopobmxfs6VAF7dAYV1VzMe4320rg
	BPBCyzFWekn0ar68E0qsFdOY5QUXLcEXZFJQqjk0BOqh4o9X9Q3Tyr1Kdqv8y4q2g09gFA
	9TPJv8F+FS/VDv+Mr4vvQFM4U/X2D2g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=BSrNKMqk;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761225958; a=rsa-sha256;
	cv=none;
	b=KZCogdyGk/smaEmPCYrdzNg7iq9Ghld9yAPp4hNPKsS+ooe714Hok9qjCAI4VGBtAGyfvW
	b1yKRERqblQMadKTvM9yBXFwXrcs7ARU5WBpsX5aH1Fo8Z9Isky0oIykYPuyQXGVWHQ02Z
	kQ93dNEUlhGLwQQtMFr4Xkf3h1aJq6c=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-27ee41e074dso8079865ad.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761225957; x=1761830757; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
        b=BSrNKMqkmjADHa0Ag7R4EeddslAjEkzRG03GZ3pZAfRJnXnydApExJtGjkx1JTRWT8
         RC5aiXyku+nXR2oorXo3FsFeL8SJ8ELuj3PG7SkgOcNNfGPAPVVtPSIFNmciMyUsKcWf
         n58/Ide1N6Z+t4gvx7i/09ZDoAGFYSiYliWsRbzEXH/b+ldvhkbv8dRVnA0anlW/mnAr
         a7LK4g18ssdfAsydsxBG49E58uF8IE9zYztqy2kS9EJMiqSqqBAqvwRVMONNEiLt+8eK
         JiKAQGHBdncof2sJH1pbA6ZZuKlrWT4lqwn2coNWYKguorMgcTnpvaMQcfLoAnO3YxV6
         0IKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761225957; x=1761830757;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
        b=YF5oj3tp+/LtfWBkOYmXv4m8jODbUqZItfPQUwYlZm2uT9NyXiI2eBGBFp7JahWbG3
         YP1vtHKvFJJWz1MQfyKBA4hAZQ6zLQFgmP7i8e98fCxyvIwy+uISrJo87NUDJfSACsT8
         CkHn/y/6+G2B6xnxJVirUfQmjwFBOsCkXP03GK14fOyix97bCmbz+vPkRrreOte57YcR
         3gFCs36btqj4gyZGKgPigVD0P47LAW6wm7EfcCxzlEqZn2B1EznRKHBwJuGxYGp9KNYq
         e0Nk3IsVhsFD/m1R3R+zeoan7RBSdRBxnwnzXYHWCVbIehLDMLQ2+oivI/2wy7VmIiIj
         lu9w==
X-Forwarded-Encrypted: i=1; AJvYcCVAm03cL0yY4jMrgYBaOCgHRi4N21vVoEq4ccoAKLttmLjeJQQzGflNr5Ff9/zGw/8Is2BQXOyb4A==@kvack.org
X-Gm-Message-State: AOJu0YzXlSHxaBPhBNmPBHHDBaDfG7ziW21Vk62xd4VO/T9l9sKpqHts
	8Gtkp+k0567aMh4CNHPS6uLdQRR0Ia+AAWtaVToyYN/ScC5vVEJWAApiV0mgufANE68=
X-Gm-Gg: ASbGncvnZdKQN2UTojqHQ6MHNKZJgxp9aw1Xwoa1P0VtdKuN+mQNvqKbgPUkGsRCHdO
	j5lEOqKn+JR5da7lkDxpfGaNwYkGqksdoDSH6+X2aTMt1lIDNnt7x6u4OQOrgKUbkhyhoMCgmqw
	S8TuXEY6e7T0YEqAVHJLijb8NM2G7QcViVv0QTNx6u3y0dXfHqi3iNvMDIPglE2QA1i0/7gTicg
	dTciubBDH4xN1Ya4GE1/jqo4gpY3Xmi3vqLmi38p/tC3Jh1UrneokJmAtNRvkF+psLUwR7o2KeL
	I9ClkpaC+uf/kTyvNjAoRjBnVPPbv41WXex+OL5bZHgZy+avhumtf4lva1N7EfsOWUdL9WhBblP
	dyQeBhA+X3hVdVM/Is/am9W77bAyXhpvIppIFHQaRqONbvut9PnxYhpoRsC3ZEneKSjx+rQo+ep
	pyMzW9kwfKPQ==
X-Google-Smtp-Source: AGHT+IHQNsgbR9ZhvUDO+8XIqhhB5S0bPoonwHjZoVYPjQlap3Ktgwx5TRlqv2xhIowva8Uttq5czA==
X-Received: by 2002:a17:903:22c1:b0:278:704:d6d0 with SMTP id d9443c01a7336-290c9cb2666mr309074665ad.19.1761225957249;
        Thu, 23 Oct 2025 06:25:57 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e23e4b3sm23432035ad.103.2025.10.23.06.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 06:25:56 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 23 Oct 2025 06:25:38 -0700
Subject: [PATCH v22 09/28] riscv/mm: write protect and shadow stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-9-1d53ce35d8fd@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
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
X-Stat-Signature: yt77ghc1imwhsjtyrb5nprwubrfzjtop
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6E52640007
X-HE-Tag: 1761225958-736621
X-HE-Meta: U2FsdGVkX1+07ilf0hd1X8WB4brq6NEus2FG6pbtPmq19AyWrIrJfxF655pEXobGl+6PxJ5erxihe7TV8oka9Se7VVAlv69odXxvg6yAjQYjFj3sXQI6MBCstwXLz0sWE+qMplTT1R7x7dyf9c0iw7YgwzFRN02T11ytrMSFeXtlxA57qVpswGPU7hUaZ2UfmcGnnzvGYqLA1dqWhL+WsS4U2xWmFosa5Lpa7s8AdrOJDnBEGF9Af/6OjTPuuLeqQpxwShwEACsEaUe9Z4rMP3Vr3tmNTBsn7Ta7jg5kODYtLzxq6dmUPsTN6UYVmjoCvzlamQ/rpZ2oOzrG4NQqNHm4yKh0DgDUEjvKOH/pKM87rK0nORstPpec/PYwOPrc/YVBmLAnE0toBvcvJfqky9woRWeWZx2jIw1DtiAXQG8LW7paSqKcckMMTGvD59VUDi8o46SMQ7bgS9bOd07picOoxzj0NYBojk2pt6TPXmocVVU/qCyjhq5gzD/TP+uaTRWuAfL6Knmz4Wvt6PQNBwAQmzbUTceLj7PV3Uk8un079ff8CZfLVD5lxF0587d0B8PQAXMQFxSxUGWbsmU08U5H919R+Hs9HCC1TOmrtxN8M2S0Ap52NhozmyVLgFgoIY/Cad9Ep4/UYjqGGqdhig5hvXfgA8vJbWOP2zWu/hbygFxISx7p013LmmaUD+h1UTztg1PJLWG8VvacyZly/v2fEBnWNFGtRfr9Cq2u9l9Jxz3uZLetlOgWM89AGXuBLu7cDHdr8C5c1+e4633srvyjZH101CWnnghCHR+TsIhS7DopIWxs4nfKUY8jWfedOGvmRkWg9cJMTCPCxhENWQX2WEfw3xdSBRoH3/oTOzMIlrhG9DVhUcyvGo98xHiCkMA1/t0xkAVgv5YFeH83kQmJNbJnNHxeyKaqLgT7oWu1TXgS4J/+yrNaywBbKVJsVha+xt/Avgg7J1ZJiza
 P8j4pDUC
 DT7OlH9aGMNMU8MchEy8tUAVe8SuDm8R6q/xV1kmpeP0d3oOZSe/jpzXvNALLvLMgeR0+QQ0q1apA2rwVcyfRHtf2MGK2P1pJ0vfosu1bD5QpGpos0CFTd/fpGm89NRzc3GeQPYjV3i9DkooBsJ3QwpPphCzbYYHXy8eXtr0rhyhBEtoFAp+/aNcG/zsNqnrl22lffMpAUH9Ztp+KIh5ZxMVleB7uIKHoE3JI4vT413SmlMGib/TtB8Ydz7Uv/1yUl4s0kbqyOVnt1+Evdi6BPHjX/mseSQVNATTm/2eF0jCn5bE3aEWU+izZblALUOcUIWn+AKtF3YJrC8g7/Gbua9pYRdMZNuEdWDWNNN2rJqPxl+IldCqSCDDGPJxJIfCt6MldjyiloTAVywyg3xE0PGfLX4gvdWn4FRwm1evJJF4M6IaylzcmJyPAqrFVo3j9RwD/piW+TE8if122Kcn4UeSufVpUwAPfvRjj2Ke6yodcl+uWKj4JE0d4JMujabONv3oL
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
2.43.0


