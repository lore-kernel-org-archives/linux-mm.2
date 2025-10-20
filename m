Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C385CCD1A2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A48E8E0026; Mon, 20 Oct 2025 16:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B678E000E; Mon, 20 Oct 2025 16:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74128E0026; Mon, 20 Oct 2025 16:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC5C98E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:53:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7046E58378
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:57 +0000 (UTC)
X-FDA: 84019694514.29.821C8EC
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8060A80008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=A3T7b3GN;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
	b=SFn0h4CJGswvKuXzZaAHhQU9GVj/1RBVunNKmUaSRbo18HDyr2mVUfPPlQIz7hzX7GurC5
	cJP/If35SaN9Fy4ODt80K1oFTsDjvbpHHuD0Cfnly45wWVXTK3rsnvpchi+hpbI7bMAMD4
	NLQOGWV5oecnky8kRLXJHHjNbx2rf5c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=A3T7b3GN;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993635; a=rsa-sha256;
	cv=none;
	b=fE46czH9O0d1QxaoobkHIo76uW1xTsmz5MYjBeYULcODTc/MRRHMaEMMZPo+jqiTF4z6Nb
	mVQQb353AxFIljYZPQP2PJceRmL90swoWnAUKropqicQ8VYP2ZIUraXlyd8JtQfPYd5BLM
	YR3Gbh2XxYHq/HbC/XI8+1lF5oHGdGA=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-782e93932ffso4105356b3a.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993634; x=1761598434; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
        b=A3T7b3GNXf4IpdQyXczzRR+d88yERfqe++HDryO+jAkHJCFpUKAywUqr8dFacsYnXm
         HuVRQBP19zK71RGcCsW5yHLFh8p6raxvSmM+H6nnGKAWKUiWdmsg+9orrZV4VoCmfP/N
         BAjhE21aA2/zWSLGnvj3wsfEEiw9fAYRITWD+q6L0Y8FnVRVAZXcbxrvbPYekQxf6GFQ
         HAPttqRT7xOzgDkwhlxsdl7/iLSsHGVvPwlqh1k5INOcAC1jBUhRqtkOtfv0djwCprTH
         nt4FW3kaEPH1ROs7ueRr+RJ1hnuCtO0pjbf8JX1RDoZmIyWq4cAXwWFJMPaQh0TP/jLS
         6gOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993634; x=1761598434;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
        b=fXYWWGwga4IbJJRZPYCemNlLfn8MyHii+a87YyZlfgRt2JfNU92yBNew2Y7quz03cf
         JAQSWWiOryocI9uGIl63N+s4OqxMzVhJmT4bdLHyz5UoYv/tFOPWE2rTO3oWAN0U+oI9
         6MF/MbmiYQcnFIxJDI9KR+dT1ttj5+8nhI0ijj8H81iW43U1nMvZ3SLlGrKYjLY8SABu
         WFVc84fFMKheBqwojY2RI4QkWy89zwr3f6XBrNN0cnsOk9qVue7EQwUF786RmRbxLi8G
         m37LTNwaCW7kltRqlQ39PPROJnMu5UWhQHA2dWntoazTSN2eIh94NAKoFrW8zLZcs0th
         uSNg==
X-Forwarded-Encrypted: i=1; AJvYcCXdymUItp+RmpjwrlEPi2O5LCIij8W5VhVev9wYJsflelqja+xvhz+dOe0yjxQz/Gq6TNWV/TKmrw==@kvack.org
X-Gm-Message-State: AOJu0YyKEiK4xntW0c1ZFZ9M5D4bLa8nXDKobKVkBtsXw5zHtMZNQMpN
	j83RDa1l7wsUEsKP+i0cnr/oDbzkJXcMDtwz3bWoIlyEm59LuZj7CpoSbCsqAQOGbQA=
X-Gm-Gg: ASbGnct3veAU/yV5r2L4g/im6BImu1b1EfgvYbGZcbzOzQymZCBYOtgga2Zn8uGUgRV
	lNHtK57Z4z826gJr/LFUxoXEp/o/N6ePK1uJDcLGVCKrRfQXJ3kOeJSCHfLV+My76gfL+bM2tXr
	TWHfgd31gvBNf+f/g44a/Sez/5awUxlasvnq+y+RX0XfEEXLZ2k61fVvvwzBoUDALh+HuXDy8bE
	AdOxn0dbKwi3cTyDHLF781v4K5YT+rvsymBgeJTy3zw+eJJx3iJPIEkly8VDhXn6RLFYGfwrNKz
	qGv4y+DqfMcjgX2HVeHL9YofiH7P14282wbqGrQspxuUmfeFx2Jp4cXKCkIHpjFjUlY8TpX9PDb
	ZX2/3nGk9Xr5uM756pFVQHavBzxwGU4/aLMBLNr4koYwwJLULQJXtaatRrfqe9WHLaYx2ZCtf1w
	NmjXdhEWR+VDtZpifTotyH
X-Google-Smtp-Source: AGHT+IGY4EyF47I5kfM9sLiEWB0A4XrZi6suavhQ3DELNJWCbB/8MtVPQAocTammVkTvv5k+HEaGCA==
X-Received: by 2002:a05:6a20:2443:b0:303:8207:eb51 with SMTP id adf61e73a8af0-334a864aaf2mr20366099637.55.1760993634353;
        Mon, 20 Oct 2025 13:53:54 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:53:53 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:38 -0700
Subject: [PATCH v22 09/28] riscv/mm: write protect and shadow stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-9-9ae5510d1c6f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-9ae5510d1c6f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-9ae5510d1c6f@rivosinc.com>
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
X-Rspamd-Queue-Id: 8060A80008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hj8jmdas8x5yss6pnogdpwpy1ih8pmku
X-HE-Tag: 1760993635-767412
X-HE-Meta: U2FsdGVkX1+/Tr/5/KeJx6WvQap6dV6Ar4tjlgYfvBlxpg7aQ+CXzo95tVuGgyVYwhzHZTEcl6FbXLXJL6fIlFEhWYj+tyx47NT69lSVJrPowwJpijZqrv7Zo2eREWZBcih+q14RqE5G95oI1u0PIm7Beckp/vmUR8Ghu6JXMUJyt2MHUBpJVgf4E4mllDRh9P7//YutDtaPlG/keJFA5/NGj/ZpdXDjN1ieU0vS9rH+pyx/VpdmBryuf9+4BShdBhsButrIEycthOfkJdA+EzQuN48R4WQbXv0guuzS+4mZWJfQLHKu77sqmlYEiGoxYIQSA/yjTxn43yQqjaXb0EB5vxn7d/2v10f5ux+/HMFVa9NkHdS5P5Hoa+FL0toYCfmrrOJ24PIKOsmi2FZgRBKa3jkRWzX9Tj0dzV22kRUvdgNm6P3Yf7XWvjUEkr77KXd+Y53ny2J5QIlWnMPvVi5lVyocHCmhvIJGAIWbj1qg3bsdX5XUtnV/8hPpKK8MtVxtgfCsWddCpu1WtxLCgDRNxmtX7+PG8bWfvvAytOwIUr+ujk4tkMcVVGF7vg2B8O45SA021MtXB+CN6+go1Xg5QSbnA+sEEhrlprfpYK739fphmtYxPTDn4r85UNRDkG0Dib7ZmKvvdZv6aBEo6ynKyQh8Szcweo26ZYH3NUpykm9N09NODUkoT3hSP7fQKmZVpp/v2rc9kRQAGb9JxlDfVfL4qTSf4wskG5WA3OK9efG7EmMHzJvz2/Az97TnKnORcgWHvtLI7iw8q3vuz+vFTzbDRFkDv+lKN5AhZofckKeWJMzq5gKZZ8MLWQICgGJdOrbLU/7WEwmy5WSKHqzEI4Yqt7RscdTlq8RrzurUYrq3XJGrPNBx2YMVTuWWxqfAiQWPtHDDWElfnnEnxWfyyhIMXY2UEECQ3wBtERS0ARmTK/7Z/74CHy+D/t3BmSkUGsRsL1YTmmFMTSx
 F2cFc7MV
 hRBQqQyrIRbNfMCl8SJnYutQ/pvdto0tqHJFEyoJogBON6wTWeXP6ta15NsMdbGpbD/ZWWVBgibCNu33fuS04wEcYeSPPXUIav5t8qCyP4REospjGrglF7wFKGIIpb/+7Li0OilyUqRxT+BMptruvjJqbl+cTTT7lz2qqx/QqNQrxhwqTI8gSmqGPKq3J9+eqi3/htGTD4LMO2JhveoaW+dFBICWJuY1/pFI/srAlAaWz8JLt0awvr7zf382yYPiyUB6n2NQkWXrDRioyITE4E0DRiDHQliDKsKG7PlRfJaxGw/HHKMRbhNeCCyuv3DgNCCRyFe1NKkKGil/BRN2fnKFE98gdgWAAf6hnFGCNoY4iecjuxArRKrUQDku0yNYvI+/4owmURCOEVpNczN4YuBGzMLat67c3oIifQKmiz5qujMqwHDMdDpI9P2FgSRk0U9cYkB6W6HJftTPAjcQvdpd3+b/J/SG5P7moxGJawYQujUfZRrFCPgnKox0YPD9Yp+Oj
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


