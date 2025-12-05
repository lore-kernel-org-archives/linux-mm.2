Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB14D339B2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F209B6B024F; Fri,  5 Dec 2025 13:37:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAA796B0251; Fri,  5 Dec 2025 13:37:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D726F6B0252; Fri,  5 Dec 2025 13:37:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C807E6B024F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:11 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A37081A029B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:11 +0000 (UTC)
X-FDA: 84186274662.27.7F14316
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8F248C0016
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=PSAH2aMc;
	spf=pass (imf10.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959829; a=rsa-sha256;
	cv=none;
	b=PbO7JGA3VeH45YCipt+mG4aNskbgQNQItZcVj+LShMO0YLFsbEz7U41BedVY6j5TNh+h1/
	Llbc5lTRuEVLKdzbiPpod/1CQ6d15C2hK7FkmH7OFmryFbs3kJjrrebBqqpGowYdLFSQI6
	GTDXMIpcaniZNLXMhHYERY4eW97ovKY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=PSAH2aMc;
	spf=pass (imf10.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BhzOXQIeKPGphLxrrOEUt0Oa58R/DXqd+aRrNPmfj+E=;
	b=U0SF9jRbuXFIj12KVrJ/XNin4CtWq5JeGN/8YSNVFGoO9fGhZnd//2MhNaRRNB2feWFGSb
	6TFwdL7g4Pk0oiqakFisi/TnAeI75clp4QxoIOFaA/lU93gdI7fEhVhHQxSrOjPmRBYjHd
	4s5gJhdzToBuUUsgoRputdc7t+soKHg=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-bc1f6dfeb3dso1414757a12.1
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959828; x=1765564628; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BhzOXQIeKPGphLxrrOEUt0Oa58R/DXqd+aRrNPmfj+E=;
        b=PSAH2aMcURz/NlnRZJp/lwalCTW+070JwMFS8T0NGb5rNHQD7RZjR2H1VNrrnUT/6C
         Y48R6bRqd6APU3D+mScX80iHBx66YDJDTk+KSqxgLw9oxtEerciYVhzafEoPpELvdk0w
         kfoaZU353NGqu0Pc9mSDZRGX9xnHG1efLieLQRTk9j+d+U4vgV0hCyG7xqcvzyXtS7qe
         G+ZmcA8TrKkHSiKaxQqYXw4E8VQiPhagbsapMQ11GUcXJrhTkePOoae5KZA9MAWRIfBH
         OEPzf4LKUqdFNNMq1NfYcQMQBOl4cGxxksWvPR/1kscnhyUPS3jGoxhnje0EJzp0HJ78
         Ozdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959828; x=1765564628;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BhzOXQIeKPGphLxrrOEUt0Oa58R/DXqd+aRrNPmfj+E=;
        b=rosofTRW1DW+Rhc4PepFS1/dbqdkQ2oLV85+UQ8dmnMeSdFbeCE8DOMA3dWptoTlCt
         l6i4CsVwjKQAIeEcGnR/awlVbE+priJCuQj87azEazy5ZFcstYhczrKvXYT9+EIPPv96
         Rq6agSs9/hvzWMy98z4es7+1KliCC4/f3VUJF6rgyZJ2woZZajedL1fhNTVh7Q1De39J
         3korVnHXP5vm959NYUvCyIXNNoGopg2Sq78/f2ZRC75ye8h5rymTn22Z96WrZjHwHldH
         8KSChzh2KtV2NbNrCQPKZHVJZ/VhxBzr7VE7p73nEkJqEiRkgmgM3feoiV0e5JRCdz6z
         bQfA==
X-Forwarded-Encrypted: i=1; AJvYcCVSVl7P3ZLISWP5WsTA5684ik5H98YG4SF/V4Yq/+so3KhrZH55eKdGj1c2Uo1JoUdF609OXlo+zA==@kvack.org
X-Gm-Message-State: AOJu0Yxo/zOOKgxlhjhhrlbH6Tj+q5Ew4qCDO6ZOyXTMzsjBnTUp7mhL
	H6XqOAJzBaJF6hGNdfUrQjvS9KHSJZPmgcmWD1Z8Z3mhRzoHc4F1nRYhlL9D9yreEsA=
X-Gm-Gg: ASbGncvBY8WcsRbIpwHdZ1NPsyK2KoL2tAgWqVu+f+QJfxu+tzqma62fODVXywlxF7y
	sQoZR9TXk0tVE0g564G6tiEKbGq2JZyjcinLkpaZZihyLO5tut+E8wziOUgUh/79g5hIKpW5qS3
	QmRRGMa8IOocMwYg3gu+oMr+8ygNv9ycE2VeMzSuqrWBNAKrKbCha4J5OEb2nJnlIlSZl4aedro
	mMBpQboacrkhA74API4eporqc3xSaWWqVf0pAAgBG7n50kIbpL4NFNTG+Nx9HArSkBIXK1QGVqK
	owdLRpXBK1KIvNTv8TlaTLLNEaLXqSjV/avCI77ypmASkikrx7DMImrhOGxcqM3g/sC+j/Orz5E
	lKEUe5i4Zx9TrgIvTP67XUTCuP9Lk6XLVif5pYGMyDrxX2LFLZFxegR3PxqGIKUZ3H59fRYN6BO
	PjanCTcbSQl0hlvHd3CREA
X-Google-Smtp-Source: AGHT+IFTiX7E4nhtg2oLIOiIJsymgB//WfrL2lfzuDUbhfqZQt/M5VDYOlkYmCvfxcqp8BpnyoWHBA==
X-Received: by 2002:a05:7301:1c83:b0:2a9:9688:6ee8 with SMTP id 5a478bee46e88-2abc7201595mr81379eec.22.1764959828290;
        Fri, 05 Dec 2025 10:37:08 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:07 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:36:55 -0800
Subject: [PATCH v25 09/28] riscv/mm: write protect and shadow stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-9-8a3570c3e145@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=2600;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=DJZ2aJIoeyTvFOiDWAJGj4EuG7hZunP7odYpwBb+3MA=;
 b=C8TEEy1gs5sN7rJ+eYCVF1t4T+o2d8VuOmzt9c52Aq81heygn0UsWcug/A1KC3oo9oTAcQtSt
 XNDDFyGKg7jBvPECrfnFz1PZnqJVtsC1fQcCVVCaZ/Cl0mGP2aeU++w
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Queue-Id: 8F248C0016
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 1timkchihm5scx8q8pxictb9zd7sqy74
X-HE-Tag: 1764959829-574072
X-HE-Meta: U2FsdGVkX1/lu9k0bXFfO3d0Yvc74vsGGBSFjTnjINuJK4m8hx+4IAcTtimFMkQmSsUNqCvO4JZApj0Cjqwnfaz8FfGh3QmXTUVY2+4jVKhq2Yz75F8KWVHv/SEf9OLb0oXyNhy59v4Ej9XthzIQAn6seXj6bwVPYBr/J7+is2Wu2PrOKml3waQG3x6TjOyNT3qW5YNhkZd+1aqmuFvL/bEbsJP1vPbpJrwXHHuvgk5xjUofibam5Lr5ItVC8wYgVUEp7ACM+JOddK+zoJiM3XvU+GOCqNDxnICNyEV6+ByvztfTnpyRQDukQ5G4xLIvtPhXEYlPIAbCKKCkYzpVC8kLMAQ4PwhBr/RqhzWXNIWOoqFFZnsvDOa3w9imubjqoyDVbs+7Rie+ke8NyA27VKatLH49G1lS9S9Ws19dljX7uEGP35MoIH3IZf1kusRS8ZgCWy1np1XyGepJdOTOiPtqERxB8edbjQ3ZqN8sFIrbnQZeOY3BZ3syq1j7DbQnS2NHkkMrp7uZGlSKSqV/4h81eJkyTS1WAOrN8nXKHQeMMw02ZYVvoneYjb/v7z18LbjEXIIopAIFPX7lOkG+Yspn6JCyiCzDk89kW0m88fNuB75dD1G7im6+bHLnl1hRPkwNs7cpcPiwbxJwglBD7liz2N0ayArWIKuGtc9uAXIL1102AQS6ljvac9BWNeHrACWwyPIbdbcJJdNXp1dMWexV3DDkEGEAuG1OSXjl+20vZJk4WlbITZy5XYcrO0YXFUbnPBCZSfqK6P03cY2IueY72txOZAMt8qUBHnPp8DLOWBFzr6TEnuQF3Qbbv0TvTxDVqKQusERpVdgx/Y86Pzf/AFYOKh78VL+cRfTgBgJHjQ1lD3y7Qxx+Qy/WtpH3LuAXuvHaCBQvXbzUaF6AVM7QVN0JfL0ob02CTk8nJwe4Rf9MSoaEPhh+sffzMZVihr/4+cUHaCjv+cF7RG5
 LKO3+6q/
 oK1FlD7xxswgbVVWvkzYAXlLuFRu5KnmLciDlVYU28Urq/LsAFqD/HhXE1hqgzayp/U1e8OWOdEOijSfxQsNfiDYUVpPqG2FNCKIpkMvJbaaZOoUinU/Yjn4HqhBOCDH5R3shGuE3Ft+eIFD/xHIFDJW+ICgP+5ragsuR9cIpRHWYSLZ4KOT5KBQ4BA3sZS6VQXxrkBax8cWyFoy4gZ+lxesNPMtun13qX8fhFmQtrRnWGNRlA3auDCP8G9FEuxfgtGpxNPnYwQbk/4riaDA1eT0V6ColYEICnoC03fPqWE0tX8F5ECOfn5tzzEs0J9es4Bza+1tN+66SlU+JFATjtyDCiSj8jO8Yxn03wQ7TlUDjp9sisF4j6yBihDuh2CmBF8pOP8VC9t1+8eL+quuhgqIAxxrVjJ+oAbnlDC4q1dPQ8XoFni0CwBDRuGyD9UliMabXSMsIZRTqxOmzJS+M4IhgSmdRjDZ8VfA+Yov34wRQXozXg9ElXd3ccdmJqhzR1O3+UYN74FPoH67wSrvLPijLN4ijVMQCW/rkkmXLTwYFkRMNgkjYpOUjXbR99to+R/Br
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


