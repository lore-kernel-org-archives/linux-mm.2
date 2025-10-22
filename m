Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AD30CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 23:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28B0D8E000F; Wed, 22 Oct 2025 19:30:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C59B8E000D; Wed, 22 Oct 2025 19:30:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08D478E000F; Wed, 22 Oct 2025 19:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E5F5A8E000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:30:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8E3A1604F2
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:30:00 +0000 (UTC)
X-FDA: 84027345360.28.0512C65
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id BB0EB80008
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=DctuJ37p;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761175798; a=rsa-sha256;
	cv=none;
	b=7AtgT4WqrNx9RmY/GoqWzCTSHDmZTzePm2y1vYr3IzxBWMrwnU8pal1pBdtdnDid8vFcUS
	CtSppY4Rhu0PBEmCcgBM8PelvBihhU5GM4TpZWKa+qJrCZ/TwZbX5TTZI6x+w1j2eHQPsA
	59XAfPgKdgy0eca1MEk6SvpYcR6JowA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=DctuJ37p;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761175798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
	b=kLauEdccxUBmpuuq3lFFm4HtFKkM0OtD68/EbPNxVYYu7V0uSVJ2XD7PeqxVLxc4n9m8Ny
	i2GTFhIhx0PwddQT2BoAa3RoF39ifTJ0IBgoAGjd76WPB1rAXdrgIK8T6stPWgwcfqiQ3D
	No3L6vq3hNdEI5VEH8hQZWR5JiBN2Dk=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7a2754a7f6aso195309b3a.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761175797; x=1761780597; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
        b=DctuJ37pwDekQEXmFX5tRIXr4t+C2NixZEEQzeW5kOVRHqdwuA/TgtT9bQnmy3mqu5
         pk5Fka1m3/U3oZHCp1KI1RMSHmTUQkOu49Zkr8FPivJUkU20St1nAsa+5CRMsl1ekKgp
         gKl5tEbRBRv0oFuxgIH5K/Tozf2mCyb0K4BdHUkxBVcZpxCT4wlfp8ggEN/AtIS/nxm2
         OVIYj9Vk7EN1G10QvPHR9+1O/hpISMk3K6egJlBSeEWI/ZQilS//6lXQDyQBTlCPoEV4
         50tj7tDAZlue/bo+zDxWx0oKoZDPHQBuw+fTxkFIW0iMatsAwfLMe65PKDyn8XXdqgV+
         Kx9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761175797; x=1761780597;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f9H2LPWU9+l2k2EeL07qQml9rdpRAXigNCc3vd68LC0=;
        b=jJyvGH+W6x6bWR8eKl5oV64kTwVY3H40JMfw7J9HKPuSplnAgRLhVbNak0d46lIYSz
         ft+n4pHaLq+oXVBD6Hcrcx2q7XlObqHeWG+H+Yzshf3RfI/XZnLIe45KCUexF5MhN1QY
         28SWIq2BTawaB0qcgSCP56JboXn8GjXKtj47J5Ekc+c7UGdwWW8De9GRRnqGWHVPsMQp
         MWKS2HpyBehMQaDUreITZsRujVqVKneUDyCJsWIRMCOBJQwHFkXUe1k4GY7/BrXs31JM
         fZkE4dJiUoi2E3uldMZihVggVr6o2OoTq8XwzFaxPF8Bg3wXZYdglrIjr35fUcSG4nc2
         AIQA==
X-Forwarded-Encrypted: i=1; AJvYcCWJoB3tw6+8yRSpTWOpsqdMtCDbyweNPiCCn1DEZBWG3gWF7aP/zhKEEiDEQfxJ5MScMi8Q+k7UPQ==@kvack.org
X-Gm-Message-State: AOJu0YwGOdnHcROxstdE+ZOGPJDqxV3AGeJrT0TRlC5m0/2KNxH3bmBa
	bpBIwoRpp4+7kHWfmqd61B4efMPWdBwallEKD7+yAaH4qRxYl/qfLlDoxZ87vza1BDs=
X-Gm-Gg: ASbGncvqftfMJNX+Zc2zPQZvjIR8swZwQDboa+dN3VTHryLFFww4k1WGCReQzGeP99j
	MEN7DwlIca5e+hKfNGOT9gwYrPZ1fPE6dDKwLBPX1xwd5qqLTMJe2t1k3WcpsayYcnhPP/Sq/QW
	h7V/bJ7iiAUvNrPzGLWZv8ZKGdJyrbkMdKA5vIEzhOtiT/aI8cJ6TJy4R/yAeFdwEnoCluqdIF9
	VZ5Gx+1jPAPuztC+7whHAG2pvee9RJG95CPHUievAzqzb7XoybKvjbWL6C727nKmwPfMNlufXf5
	T7Q62A+gy/IyFnx/B4qXmIk8XB2hL+UaQFOccXW2bnfOAIE79q9cQpJ27kigThDWbOxQ7vHlgDd
	Q2F4pQ+NFegE/RiSjKg8MHK6ysBpYZTuzj29hOM8/VhzYBFusqoASsICULiqLAXXzn8+Ct5THic
	u1vPQ61J5k4w==
X-Google-Smtp-Source: AGHT+IGvZf6To3hIDIuPP1h5aY9xKK3vy32PO8rqsycDPXi+APixSYDQ01ElkQxBZ+x0aZsdxcUr1A==
X-Received: by 2002:a05:6a00:6f8c:b0:7a2:6519:f90c with SMTP id d2e1a72fcca58-7a26519fb7fmr4281251b3a.1.1761175797589;
        Wed, 22 Oct 2025 16:29:57 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274dc12b2sm392646b3a.67.2025.10.22.16.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 16:29:57 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 22 Oct 2025 16:29:35 -0700
Subject: [PATCH v22 09/28] riscv/mm: write protect and shadow stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-v5_user_cfi_series-v22-9-fdaa7e4022aa@rivosinc.com>
References: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
In-Reply-To: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB0EB80008
X-Stat-Signature: jih3aeuxgtjf5uxsj6cx7rzn69k47y1w
X-HE-Tag: 1761175798-388760
X-HE-Meta: U2FsdGVkX1+axp1LP8Sn3lB1ZBV4dvg2z93mfq9CF2sQJTKV8WF9Z2HIy6s+OgySSFycaO3Mm7rQnhBXzpLn4mh8Unhx2KPwd6pa6oSsvACkRNYLufRD1zkPhQoqSc3LSLOj1FjX61vCBMVq6+/J+vid+uwq3956D2XR7gbNK1T07P8Oq8qhWRgFNdnFcgLyBhtN19iXw+5JeBLYekN/Eo50AP0eZbu/maBb7QtfRgh+lsdIrdZv4gRijuvRRRvENgOIgSvUMmCk8m9EnZBetOnSkgagGIWZ3GLOTuDf2w8QldnpgiCUpCjO/e0svrRTbUMod9/ppL8RQAfvLWCGlmsDzya1fEz4vsS8tJ/xtCvHN5DKxrSUc37WLA7hkW7vD3Q2OXDgdy4PNvzMwMu43MD8ghVMSvmXeWTDlI7JnNa7TYVVuKBCWF5WDX+jXBIg9TweWPiGn0RD0XyWHGweytcUoNfIjSa8N7jGF8F3/W4ly4Xq2B8Z7rzhDBiRSLz97nWu2r2Nb2bmXNTIfwtvp5Cpn+0jCKXRsf61Z5P0/EaEmtNd5KwF6WpeYRvXdTWq0H7WqWJTAg9sWAclvlaJlQh2ygffM/dBBVls805qxtYh3PwB0BUsoVTc/B2pgMq4KVIJK/I1/GfAJIf3ehWz/P0xW4ofe4ogmsWrS+UgZjaD91Jduo/GajKXpqpr5X7VlZC3syZKwrPF5Q8oYFxMisaXN9RlPDJBSQFnq4elP6vKKcxGBYvWFd7ZYMyGhMbTM05cvL9uLQPuH5kZau7BswXG8dr6+GQ8t3q8uSSQ5vGc3AacgfYfvlUmsn/5VrRi5PA/gjTTW1zLDjQkQWqfm9boMLljlc/D5jEQVd0s55eug+3NAcCCnMsEOHAmgpFbFNz1BYOzD7EumrE2iR8js8VzANMf9nOKxUGx7D9SGZ6fp4WyXnj6dKKinK/clzv7R450/x+0L9GUimqga0A
 zFiVqBwh
 KqcurkJa8nOiLLiIf/rlNpHxyHltCofBFXmp0fZOoxL2fnD8fztkCAFj1kKTLuVSsYia0+SjOgMkGntZbI4L+vh+neTL6hhj/40hM5NtQl815RluYBxcIlE1c6j9+Szfh9+PWKwg9z2IYMtOyvzPI4G1M7aaQ/29yc16U3yosRDgLMpK5/0AL8YPKYmVs03Q+BTPlj4sK81WKrrDh5AtxchplmPBH1z9TR5m/rv7zRePxA00IeUE6wHfXVODkJj9k8OE0tPzDbc65xFgZDxnk1aWRvbnKXBcxZQ472wyxqlydHJrbJR1jFmtG5Xy6XOpLx3n+XHcVl+cygVx7F9lcH12Jcj6L4BJ/2aKlZpOuZXymHzCJRtBuQnWIj/EIGO+VyuL6vVifPe6N72WXjEv703sQHHOktpFDQNtX5CnZZ379vUJafxP0XC0Kmdq+1XUpfDcgcJJRicDIr2tOUP3pEnqCMB4X6roAA71ihFKjMZNgx+gig5vxcMxcrIcZCl/tqebX
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


