Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FEF2CCD1A2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80CBC8E0024; Mon, 20 Oct 2025 16:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798928E000E; Mon, 20 Oct 2025 16:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636678E0024; Mon, 20 Oct 2025 16:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2328E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:53:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A5641A02D0
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:53 +0000 (UTC)
X-FDA: 84019694346.13.E411292
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1C57C20008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Y7HKmve5;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
	b=FHogEbSENLtqA7INTbwOCErsNhOLazHdEwjHQoT4irZ4x/mCBhTr9tIt6PTaCXz/Lqv5gx
	0Q5W9fhyQsQVj+pe051RY5m6ELJVYVRXuaJpC0zx3ZxcuDNHMijZxSkcjmdV9EHkRW2rZx
	cyH+/ioVfSIv8vcHaleKWr4P4XbrbQo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Y7HKmve5;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993631; a=rsa-sha256;
	cv=none;
	b=jGC5snTFrO4EvX9T0JdqdQ6GMrVCRqPHQaLGbWRPmyp0Po4voowRelfGY2vjd5Quq1xTDl
	k9v+qHOwb06cugFM5aVO2wJ9QmKyPHcMbpuGYAEfocbxFheZ9FeX8Aa/12cse5QAyLBOM7
	LefnOmfIwQQNi/jKX3AjI4JFhB+GFi4=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-782e93932ffso4105272b3a.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993630; x=1761598430; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
        b=Y7HKmve51SiNcXljkCNtq+NHVsBCmqXnVeR2ROG6SkwIWzJozy05N7ju0CKWK7oJwz
         ekhrVhoVLy3TXJJ4h8SdkNb6DAsdGqyTjs/lSC3c/HkWb03uo1R33fT2hFzgoeLbs9QU
         UyTMGW7R5KhJufv6pHLpHO7eTGXShvUFSjtmbS5x1HWz/iYgm9iR7mVnW0Ob1UD56eou
         FnrtXA4g1DJX08NARTttr0sdGFJ5I5JkLhlNm1wNeB9NoHwbakcDIM5cwS3KPz8GIryp
         7dCh9dfHGw99zN9wyK75AjRbAySeuLSTFYBEEX0mrL+DiZKYxL/bT0Asqs16ZjH/266d
         VJYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993630; x=1761598430;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
        b=a57dAhzut0Kuh42eqNHTLHQBlXBe6ylI5rnFM+agh2Ofwqq6HzNDyl3ArnjTXpk3iP
         l+kPlV4bcIuKHYN0QQMHWwQN+KL7PVgPuqKxBprdA0lr53uKvytobYsRZe97Zt1LiWwI
         O64slyIyaP/5mbAHhbiixzTo/RIT2N6L40rGvR4sYoCdMU/6wH+hsMM5X8EiqqjCSSpX
         UkFVBCzNiFD7z+cb13XNVhZnTENDUsjACW4UgHNj73l3JkadWM2VOv61jmFi0pRa3rU8
         GmFlRXKSYXY5PjYYADVU0ymswZnhSYOyov0wYlE3VhEytMwlfLvQJTOrsibDA5nUYnje
         af0A==
X-Forwarded-Encrypted: i=1; AJvYcCWUPXJ6oZBkXbi4SFj5Kh3yMZovxJSJ1lTX9+vaIecbBOWhtXsVG1xrXGLgjhndFET8ocAzUNU/Qg==@kvack.org
X-Gm-Message-State: AOJu0Yx8RnfEmcubvMWkNNFuM/xU4LlbmH8hw9fR7jPpEaEpL0epycdL
	+tyke5sdX3xAyn/FJGoczjgIBFB+YavsT+B9LpRl2CoxCXj6Eh9hLGel+EJpdFOAG8E=
X-Gm-Gg: ASbGncs2SU/DCYC3deGuCct2TqzrZaRyXcqdPDmPNYQ2mkQKqhWnMloQg6hUct/0Mzu
	zWynKXvS2sFCt0C+sURqUObcnZBfTPuof2pas4gXsv+ikMjocSLt+NWc/EClw3nCzzTQX/7DB71
	Sr8cY9KBIFFJrJ4UYK1qjTaOHQRMiX+FzAjbA/r2PPXz6QMqR903De9fmrCFJbDx5qYFsU4lJmn
	4/3JL+S0OmQ7o+pyHddyQe77OYfJr4JPgScZS0SvwxCW6icDxNzfj6OkrcuRFpHK0J5bGdAbBW7
	eILpyszjnxebld/J3bMNJJgVyyIAiVm9d1lGX5dNF76RpItgCp+1CDzpfD13X9wJk5wdvMhqu8L
	5Se4rwzBw4Ez7Z3Q+8lCfLZ8VlGADseP3kN/spY0pLMyQMsw2yt8T8iSar2S0YE//YDJgt4W8sG
	wTj11vk64mrG5nY18CE5IL
X-Google-Smtp-Source: AGHT+IFyzyRYR8N4pw/RqABJpFBkHAgssztpR2AfShjzj8U9HBjqzgn01yskrDk53sXzLiQsCgAq5A==
X-Received: by 2002:a05:6a00:21c4:b0:780:f6db:b1af with SMTP id d2e1a72fcca58-7a220acb6a1mr17244647b3a.16.1760993629790;
        Mon, 20 Oct 2025 13:53:49 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:53:49 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:36 -0700
Subject: [PATCH v22 07/28] riscv/mm: manufacture shadow stack pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-7-9ae5510d1c6f@rivosinc.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1C57C20008
X-Stat-Signature: sbg67ryy9rbh14d84zff8yaaxndit4f7
X-Rspam-User: 
X-HE-Tag: 1760993630-420618
X-HE-Meta: U2FsdGVkX19j0Tfwbe+a8jrn2ItBKRSelYrFNroXVd2Ps/FkE2MpFVoxkOdzupQjvESFb856s0CUnSmWEAIPsyxELMKWRaYe6EAMC4t9OrckmmQcPz/yczIVTFuA7A7naIvNxofpQ7nmv5Shd4K0LwzCfoio9MYFSl1jK8GOvOJym858RL8hLT4d/OGiwIMSH9x4aln1U7gIs3Mx56IV+8XGL9hkdGOVtYV1bnWQcooC2v2Oi8fv9p3E1zsJzZxwCLCJv0UmENyVDhDJAiMJIL6yAniGxjM9iUeMcwdj0JGvMGRWfoTuPGHB5vKwvmLao6qOXC3j/erh7vrL81rblFQH06GBsSs91V8p/Pr4OH/UfGZdHg1I55vW8ChTnCUTi/r0l2DyOYHay1Dna5nOCenJxAxkgc/hF9v6YFjR/XnOMoRN/3RJZQ9pj5r0nNIzSBOwww2gySKuX3JimdXL9InOyGim2G0ZEeh8VgSbC8y94eFOuSq3mMD4CVVPN8bSb0QExlPF6q+rSiW1LNJqtcjSKHeqhYfJ6p7a2su8sxTOsxdDOHJ3FU2QsbQ07P2flRmXoAUwUgPjkdfM1Ge3vhWnJ9IvJQ9SUglm1xdMHq3n7Fva1xflGRtxbWjkzNGPNtTGOL2WUfFtAC7gluN+36q9Zwvz0HL2Lu1rygUc7dLd/8HKZEz7t+oLuMSY7aAlX7tu6x0IX1Ev/hCbgoZPx3HprRS6XbOlv/6dScrV5Cn7DcI+IX8tZ/RH48IXsnse1iVDSDHDafOPsvEjhq05OteLORKBQu6QnL8kIBnYfpz3g6Z6FAGXBzcJPh2OA1PqOWAHcKalHV4k2HVgfWmELEYoaYPk3pawJgsVNgYnz1CyePw1OE0MzUPLbQzajEXsDelS/YWYOhAXa0kEUSj4LVOxuRukjdwIlLoNle6K0Mt5rGoEY/Vy/FtMEQ2wWgGQhCmUkKpZJ44DD98hDm1
 ws7ekKMy
 0RURqWYy4noNEqx8IaKRQ9Z88JmE3wGehydr4QuEec/sFQlSoB7M7b+f5EK6Rk2MItOL55rNrj2Yc4m/Kb0UELzi//kzRP+FAHPmO2RjbpS9ch1rc1XtnRdgiumNOjIDzdMiJNNjOQRa6w6W5zEeXKbvvTnuV+Nq1os2pBh/ETv0o2cHkhpIwifO+3SQAvz+NIMVMXUVNWDX+o7kxXlaeaY1odW8qRjRMtnS0Qts+RDlohag656Dlk3WEwgLqVOZ2r8DBvcAAeJVozKr0iRQPqlXc3YDt42L1T+uTVO3+AMyCzPDcqS4BGSLbYts/PTu7M3P3xsjSq0j+wmjBtE3x0jNXScVk8wl2ENmRkzxIhCUpradrW/JdON4AWs6mQAMH7OTIb2UBOkN9UsEszgbmPDbdZ0a5AauvxMk4WtcNRFwQ8O7KvDlyBQMEj2K2fKTqK/A7a7rNf2TDKSyKuvNHml2DlkcAuSEXsRVUGlmW/4CtrYjRCQdRdPA+wd4MrV7uFUu0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch implements creating shadow stack pte (on riscv). Creating
shadow stack PTE on riscv means that clearing RWX and then setting W=1.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/pgtable.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 4c4057a2550e..e4eb4657e1b6 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -425,6 +425,11 @@ static inline pte_t pte_mkwrite_novma(pte_t pte)
 	return __pte(pte_val(pte) | _PAGE_WRITE);
 }
 
+static inline pte_t pte_mkwrite_shstk(pte_t pte)
+{
+	return __pte((pte_val(pte) & ~(_PAGE_LEAF)) | _PAGE_WRITE);
+}
+
 /* static inline pte_t pte_mkexec(pte_t pte) */
 
 static inline pte_t pte_mkdirty(pte_t pte)
@@ -765,6 +770,11 @@ static inline pmd_t pmd_mkwrite_novma(pmd_t pmd)
 	return pte_pmd(pte_mkwrite_novma(pmd_pte(pmd)));
 }
 
+static inline pmd_t pmd_mkwrite_shstk(pmd_t pte)
+{
+	return __pmd((pmd_val(pte) & ~(_PAGE_LEAF)) | _PAGE_WRITE);
+}
+
 static inline pmd_t pmd_wrprotect(pmd_t pmd)
 {
 	return pte_pmd(pte_wrprotect(pmd_pte(pmd)));

-- 
2.43.0


