Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF59DCCD1A7
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A9598E0019; Mon, 20 Oct 2025 16:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7BD8E0016; Mon, 20 Oct 2025 16:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E071C8E0019; Mon, 20 Oct 2025 16:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C06188E0016
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:22:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 889A113A4D4
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:58 +0000 (UTC)
X-FDA: 84019616436.01.7EB70A4
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 99912160010
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=ABKOVz2V;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ouwtbe8R0Oh+n2FlVTKPPjmDEW3Po0ayDuW4LCokLZU=;
	b=mfAX6r4SEuG4srnHRSlDpLZJTl3k4dkDWosufSeoMGC9G2ZBWFunrjg8A34VQNK0G+7+GR
	1T5Hv9DEuoihzbFVHgFyoXNjEpq+KgXre7d9ZVycS2g6k6gM8rfBs68HKofViUqHYMmMcs
	pz+cwEsLEpaiUQPIxZ7x1DV+OrxsxUw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=ABKOVz2V;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991776; a=rsa-sha256;
	cv=none;
	b=kzdylf7yZ0k9iDndLbqX3SoUxcNGWMosAA2bnrD2USthefdoFx4DcKBtO9BiHaIW0+1sYy
	iqQRrHtb2DTxZna6typJs5lqVfG4AkdoHEs80DnYIO9HfEtY+SjZWOF1ldJhijXgrcD6K0
	nU6OgsH1OwxFKnvhb82O5DwXVoTLy+s=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-77f343231fcso3219102b3a.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760991775; x=1761596575; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ouwtbe8R0Oh+n2FlVTKPPjmDEW3Po0ayDuW4LCokLZU=;
        b=ABKOVz2VJ63O0yMsbopPZ7X1QXg+7MnkSnWON8zTQ9/BSo8kWI+vRSOQj8/2pOdnY8
         Dfb7dcCLPJaWQnu4zv4GzXfkXBx3kbM0Ru8Maufu1g3H6fEkln3jIgt6QS2PCv7xBnSB
         o6q8LPyocaRH2AQulr6cXEFAC9Mxbll2L4ORrtfoZL0FOS878SAjmIiJsTUIYQbMzpZt
         f3/S7IAz2Uyso+fjh53tYHVklJiGWiieNmWxt3XxStssnWcHZZZaYyevG1GDYQiXX6Wp
         tozDayDnHrLvueUbZa8jtbD3+2gs53xZ4VlPoiWGxIg/9c5KHvLozBNLUH8PJ6dGan+H
         65tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991775; x=1761596575;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ouwtbe8R0Oh+n2FlVTKPPjmDEW3Po0ayDuW4LCokLZU=;
        b=ZyguIVpC1KF/SzKS+Ok6hUaSLm+TLRz6DNlosSjr2Xs8mZTA3QypWLpw7vlz1XpZ6i
         XsLTBHnXvtCTfmUYuoT3QKuJEQ3zLHlEEajMBX8QKDGKdM88o2cPstrRTezhqM6e8gtv
         TcSfCcCezAbJbtjgUfS0sJ5U8oAmGMtmpPtteYc1uPRI3Vj06JgxeSLmsI9ml43Lzm7w
         MJzoSQd3celC0CVBsr+D/SHXHez1yMuLrFcVrUMuBLI1TMr9PFyp6xuODORGcYWtONYF
         kPX7igvsLElydbhw1Ckrf38tMBkidwQnHBPRt+Tm4n+xSA6sIO9aDrnvaz5eU1PpnSK/
         c/eQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5PeG2RNO/iqdSIvUAs+wmSywnf00om/ZMu0u6HfkmH7JXCDNV/p1OryFCfXtCtLSl2rFMWYKGJg==@kvack.org
X-Gm-Message-State: AOJu0YxZnNayaJ/red1uev0Vx1BDHFbHumbrblE/ktfcNex2HMJ43a0s
	juRn6+1sM/QDnriFtzfpU7xzMbdVmA3H/WRM+3nDntNTXXkg95Js0qELuM6ht/krWOg=
X-Gm-Gg: ASbGncsImlRc/9wK7L9Qa0KL2zcmxP4YRVev9Dv/ULVd1NMmNHz7HyBIWvkhCfO5UT/
	Cx8A1sbua8+mHNGelLfmgtgzwZjoOjH2ZVWKeKlKkbQppw996GhX/zVDbJeJSDxQBHpWBPEFauB
	JW0aIf4eKFGdAC5WY0oebSOUC3tSqpO4RX5ir5ZuAEQG2IgxAlKkeROPQmP5fL2zh8OaZAY0aYF
	51YXUJzcoaVXASvKd5cc4zX3sooXCchKzUdhKZcsIO8LScMzCCUIl90SKbIJcAE4jUIXWHUTdPz
	K8UJvyDQ0YLLP6Nmb5qejs7nYs3rHq3bQfM+GPGKveiS/IVHvW5Pn0a30YtqHfMdyaw0F09lQBb
	TO6nOOAqiZrpotqhWRlVBstCHfKSzoV1Hp1mLhMV1ldojEYsfIa8WbJAtMHdBrtiUMEUCtDDPG7
	2toMbTXabpp8qS6EtJgK5i
X-Google-Smtp-Source: AGHT+IGVYGp6RpoHZtMEnuKRtaA6P+e7vcil/yBZ6a/LspeozTywnKWSGgV4o1nOqkaRYdNcLLQYGw==
X-Received: by 2002:a17:90b:2686:b0:32e:e18a:3691 with SMTP id 98e67ed59e1d1-33bcf919f1fmr21052145a91.35.1760991775439;
        Mon, 20 Oct 2025 13:22:55 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a766745dasm8443240a12.14.2025.10.20.13.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:22:55 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:22:37 -0700
Subject: [PATCH v22 08/28] riscv/mm: teach pte_mkwrite to manufacture
 shadow stack PTEs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-8-66732256ad8f@rivosinc.com>
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
X-Stat-Signature: cekxmhuthi15ks1uzm4ncoyoj5qc8csd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 99912160010
X-HE-Tag: 1760991776-292993
X-HE-Meta: U2FsdGVkX1/q89rOqsZswDcu5O/QsQkA9ss95iurWFSEoG1g79VJN5DYo8IwvF46FSgF+Npm4dcN9bkF2BKKQwOS/4vQX48ibTorlBRj/4dUdpfq5S5+ZgssG1VsomeX6AYXTRF5qcz11EY+mdNnA6bKMZt9zuI2VehTkG1rI4BIf81vaxk7/JbZjQAprT6ENOi2X+sBS5S7aSYF9rpOHhoW2Ij0HipNBmV96VJu5gh5UV01eRoR6tOghqc1NZEpdds/KGeiMnpmW6HGyNRaZXAPHeHNE6bdG7p3kbvqXVILEI3zXAAbYRUvN/JuAqMrO6Am6FXcYlnZVdYD33fL6Ymg8y7Gm6u9nnNft/7fMPcVQ4GRhO5Os0UIZAUPYVr1zdJ9UWdZRmSVxo3v2UPHkyMTKKCKAN5m7nkW7kAc3/2QIOkmc3qJKnZM0pwx3AV186hboXMOJHG7sbgr1DyccmgKc0KEYtEV+k+N5ch24JUSIRYn0MnZxCDBcHSDKkwOFiI/u3HV++rjAiiim+u0ZqgHsa9gzFUf833y9i02qNOmkplhEUqiWQi/XFLTfV/JkTQlc2Lu0OR1c/pf7OzQpZ4OjN+jCtu0FZ+HVZDr+BKd6nZAs/+zXiikqkrqMHQqX+76JuveD05+PwwGF5pQgyv/dso5jt373YAj91oeZubg3Fk3FD+ySYxoUefUJs5jcAABRSBOwM9puNOi6eQEXecLvTBSVHnmj0Meu+KzRczRl+OpGgJBIRs3Zk5hbtGNAgL4BLGrnKNik7rzjy9h+EbsNdzgFJXLbUj6QfxPUWaC+kFsV1KMvG65oVFKk0vKxsgp5ygCKIiPlUBRsMQZ5X5w0GYQxeYk4AbHU84ROWFvbK46IYM+BG3hx22t91H7U51JVxGpvCwpTSYDwiF/XXGEHz/wfdvzQzG6gR6luu7eG4xyqKW+/b5IU30yLk6Nm/37673Ko+Hd0A/z42H
 jTo3ulGL
 8LhcpPRNwsNuBVa6Shbcw6b2CpkRco8pUf2qZypXwQAb9CLL4eL+OMOVs6dCTLX4fXfXzEdeoeAD2mMlPr5g6wO6OCGcU6p3hGN/b4p97hbWAGEfklGcnkObxgdS+/QYRb0stMOiqpnbTScKm7rra0GKTragMyMLFu49HYAK5VaIhEuMKPh4EU3iusY3ZB4dMvFXs/5lGfv8VZifmrnJn/ay7Vl7BbRPmh1nLXoWUS/TmRrUODrZKU5OJS4grNDYM5f/6P7dbkVTtv+uRTXppdFQJ79HheT/GiIfs28uybLpb4J7R0dhtefwwckd1npfM4DwQzBfFu9VAyPTpznsEIccJ1uQzTDfzUx9gruENd0UUk6vF25hVTJviCGFBgBwhuTtM3vV0yrGcmxfLkUXC+qtgHniQ+3i7U5+VMiMnBfxGMseVorxeYRBu9pdxuxX2qOyh8oyMjXbZqKUasVinOJ9f5U/UGtDfD5AGUxeGrcs9i4duzAHfT4Rwpk/1NSquoam3PBJNBqJ9Bkw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pte_mkwrite creates PTEs with WRITE encodings for underlying arch.
Underlying arch can have two types of writeable mappings. One that can be
written using regular store instructions. Another one that can only be
written using specialized store instructions (like shadow stack stores).
pte_mkwrite can select write PTE encoding based on VMA range (i.e.
VM_SHADOW_STACK)

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/pgtable.h |  7 +++++++
 arch/riscv/mm/pgtable.c          | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index e4eb4657e1b6..b03e8f85221f 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -420,6 +420,10 @@ static inline pte_t pte_wrprotect(pte_t pte)
 
 /* static inline pte_t pte_mkread(pte_t pte) */
 
+struct vm_area_struct;
+pte_t pte_mkwrite(pte_t pte, struct vm_area_struct *vma);
+#define pte_mkwrite pte_mkwrite
+
 static inline pte_t pte_mkwrite_novma(pte_t pte)
 {
 	return __pte(pte_val(pte) | _PAGE_WRITE);
@@ -765,6 +769,9 @@ static inline pmd_t pmd_mkyoung(pmd_t pmd)
 	return pte_pmd(pte_mkyoung(pmd_pte(pmd)));
 }
 
+pmd_t pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
+#define pmd_mkwrite pmd_mkwrite
+
 static inline pmd_t pmd_mkwrite_novma(pmd_t pmd)
 {
 	return pte_pmd(pte_mkwrite_novma(pmd_pte(pmd)));
diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
index 8b6c0a112a8d..17a4bd05a02f 100644
--- a/arch/riscv/mm/pgtable.c
+++ b/arch/riscv/mm/pgtable.c
@@ -165,3 +165,19 @@ pud_t pudp_invalidate(struct vm_area_struct *vma, unsigned long address,
 	return old;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
+pte_t pte_mkwrite(pte_t pte, struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & VM_SHADOW_STACK)
+		return pte_mkwrite_shstk(pte);
+
+	return pte_mkwrite_novma(pte);
+}
+
+pmd_t pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & VM_SHADOW_STACK)
+		return pmd_mkwrite_shstk(pmd);
+
+	return pmd_mkwrite_novma(pmd);
+}

-- 
2.45.0


