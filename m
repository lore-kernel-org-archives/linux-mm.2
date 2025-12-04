Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F2C7D29FB2
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24576B00B9; Thu,  4 Dec 2025 15:04:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FC376B00BD; Thu,  4 Dec 2025 15:04:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EAB86B00C8; Thu,  4 Dec 2025 15:04:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 784F96B00B9
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37EB913AA2C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:16 +0000 (UTC)
X-FDA: 84182865312.04.1323602
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 275BB2001F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=A2OJlrBV;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878654; a=rsa-sha256;
	cv=none;
	b=d6E/IKDLQ7WbCvX1avgOlKh9+7SJAA2/xpRz1vSoI7vjeLYxS0vJ8+89uRo06NOLOW6vgG
	tSyBjvcXECijiti+zjZ49gN4P71dE1qNtkLtyGGgc1jI0Oyim1PPvQrZhwFxx3fBzyH7il
	A5qBpKi8J8IGTMOIaHSz5uDYcJx4r4o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=A2OJlrBV;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FldpuJVG3boWADnTyrci9WEZv61t3vqu/iLtDVGsedQ=;
	b=xwCJ2NBCly0SxHc8LtBf8h1VXviePAw2TVvRNL2o8B5BSZbv4Di1mjMOL+cJpMltAN9J/y
	GBDlRp6qwD0D67ZyomXaErliWP3iWEPsmTGgu3NLunSRYpSDWKJvQLvWqg29ZDdoCg0i0g
	fwkDUiUX66pvE5BObkWUhfxDn1EMRJY=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-297e264528aso13645545ad.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878653; x=1765483453; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FldpuJVG3boWADnTyrci9WEZv61t3vqu/iLtDVGsedQ=;
        b=A2OJlrBVVL2jTm8rsl+WzZbnaA82jq+qOuArB2dpvFl+PTF1rDgX2tG2JmZH+okjVi
         b578GwL0mJKvHvrXnZbiDYMps6FH1KYAOEhION4eqclphV5a+9gmM62z7GYbdxA+/lAB
         mTBlzccvYD5gBC+xo8XoJcV0h1pvEB4tMpnNxzgvPBPIUxugP2ChMO0kCOf0JKTkZKib
         NosbRDhdTdjhAUIiQqelgXp67wXou9b6/b53oCfQN3CCzmZWi/bOhKmksovNPru5LJic
         Jui8P5npBJi7LCQcslqD72SalmxnMeqD1rYF3LQF6dsMq2l6AYb8gBAPu/JVBanTo2mk
         AqFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878653; x=1765483453;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FldpuJVG3boWADnTyrci9WEZv61t3vqu/iLtDVGsedQ=;
        b=ZFumiVJQDXwgeAvRfBjU/2F6qGCleM/F6oXXAxAZpdAlJ6fYL2+u1H79Hx/Tu+31z/
         PMmFQ2RqnB7/bFI/Jw1DVA084QzABHnElK0DyDFlAPzQj6QbyePHvW899Kv6rz5zfYSU
         i5hVo7WnQ3Mr3TLwzRkQVIFTfQA3wYeCWRGRN1iifZ8k2UUlgN806aV5qEpx9mOCOgGD
         iv6PIuD8ikwHISFpydl+qd/iHo702h4AlqgRID/gBGh34qxOm/hYfmEGeA1TjMaWWM30
         HWEX4wYaPaoQr0DQEi1AUcF+FsDzWbjPJ2KFbZWQKhRiG12EFuU7QwqdNfOwm5TwIcVf
         injQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0tHe5DgPNQrE2Q9IMvAWfHDBtgzWBSDTLc7mYAuqFFTbfW/FySM9QqAojTHm8CTenaoj7EIE27A==@kvack.org
X-Gm-Message-State: AOJu0Yzdd6oZHLltexPnctnJXmqPNuW+exZvSV54mDUoCOwBo8ayZnLT
	nFoEKe+1toq51ZmU9suqbR+S68EU+mL+iT8m1SVJviyKQfP+lL8E6ITNv5UrWV7Ifpo=
X-Gm-Gg: ASbGncsyIZeVZ4jlrWv6uRdU/yO9nQRY12yf41tUtPdNCV3D47vjwTQkQjbbgObnn1A
	2csteR2fFobYT+kekmcXefyVxz3C/1hPtLWHS4Pzsn+boVAizmWgXci1tQXvSTaKphFEnM0KuRF
	kFxyEYeOpWLRnNjRrOEA3uGKAJXc3ryOT3ylvWjla+EDsWW1ERoYowZuXZqFbnHw14zAmgo5Kq6
	fgl3b70INjcKXkrEsy5rFFHGDkI7gAZOK9OnR6HIrFPMLfYie7RUh8W+c3y+kne9dV5yqHGH3l1
	BBU/cyPNgXKgyOsqhPgQvX9rcqC+u/t9QBsCWwzOlBvGvcxePyK2OWNQRP6hISuaFPx53a25fOY
	+Xd3NgvP6lIOPfpWuASL/JmiIAHpymw8ZDTpjk/HqYKTFHn7jlShea1usqMjoqvCTz9bl1sOYX/
	twyxXV03x2O/6sdImmX0jT
X-Google-Smtp-Source: AGHT+IGjVnFtxoq+ijVcDtx0OCHTq9OmWeXCmlU4QkZIcha6VRvMSqK/PJx+/0y8YF7KOcJH2N5m7Q==
X-Received: by 2002:a05:7022:ebc6:b0:119:e56b:989d with SMTP id a92af1059eb24-11df64571cbmr3629950c88.4.1764878652823;
        Thu, 04 Dec 2025 12:04:12 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:12 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:03:56 -0800
Subject: [PATCH v24 07/28] riscv/mm: manufacture shadow stack pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-7-ada7a3ba14dc@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878635; l=1430;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=nBM+gKOHTmPMkti0DTh5flAX5grcW8t0U+G6mikLn4g=;
 b=uY7iQ2LIkJgteQ4Sw4sUrLdwxATM/reMziN4oXAuyJmOqbeIfYCABxovYmWTfoYHQF59573Pn
 VjYOzhAFsF+BgJRsL7YkYitn/mU561XLQqyY2K9okW1m+HpBcCwq0OE
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 275BB2001F
X-Stat-Signature: y84e7su9myrrt4js5tnxsqe3m3i3jjth
X-Rspam-User: 
X-HE-Tag: 1764878653-856116
X-HE-Meta: U2FsdGVkX195SoXRiIfCF5lEwbNmmMtXAvsN/VH/QAVa1Q+ceLDAXSFeY4XIqaxGtGscHdU3G9U2wrxXQgdbfuavfQKgkukxWVybaJu+Ob1uxC71LfrrRE8iysCGzMlUqwG/bKcy/6itI5TGMFFeTVa5vtwVrZQF5zEQmruUutpY9QjXysjxAZ5bKcF+WfJBfyVjpV4qYUYZrp2v85KptyhQSxcwhbK6RWQqPEyl16Apj38/t0DikCilUQacMe8xfQm41bfUzkXkCdKFu+RPLlwgLU1+ekm54a05nHPzxrbzgGXzYGIf+oNfF5J0jLWY6E8wN6xoHNBFsLLE7WdMnGy6UN9H4Wmb+dVhQHkzIKNE9eKJcQmJMQ0vZnuznIjXNFdpCIt+qgZQmdgE9m/GiM4Z3dzwpmkLkDRfbLHQWyxPT92ziQyzcxN8DpNI6qaqP/jH2RUFm96N4V0vjOHt22Cpb0ftIyRpMvG2qIj9pGwFwU7wj7D8tGVtp8ezMoWNE1Bq1oTify+62TLDvXMjlDjOx1uGhJU/7iVEcuqFZINHfkdL3d9pV9IXcd0SguNYkQIV7J/dMOncPZOEhAzUAV0C0JQdDYee8OsQOvPujkd7b8UrjxxsOiHDSBcV2TijFDBnMG1sjLpHB8Cwaglw6L5OozldRBPq0bHmpmtM5Medm3WZrh2ZbJwidPekMrERdG/CaOiFq5bAtM2ay8N2mqAE75ChUxUMlEp3WHySXvhPnjjE+WXGy0i5pJCFBGYK8KCTrciZ8+r4JY56M20ekUk0mfKsojMwU1oZFzTcWPEz6OTvgSbG6Kd4pUdvbUjekLNZ2gkNCNFD5laIhj+Ki6ICBafnkYHUZRUXwInqe1f6qn4B/5xNu7jrCbYKYaY1N2p4U9e+piGNa6pSga/TPS9SDSNpigHMC8wqfUdJi5JWf+9cgGE6CBipJvUDpAvDwycK/irn7D6+Y7SmOVt
 u6VIeCe5
 9jU5YQdcTzPQfpbo51r66sc+lWeT2jKo/11L1k8NQ3Ncg24r4u2Pem0LXx5QTS32lp/wgJvD4JFzFcxw40IGRl/Qb2rwe1wPobxaa/fBgV4BbsIy2cvaq+f6Bv9FHYB0lq0ahFUeFo3rViYnuFug6E/fQ/cvpMVrYfBZB/oXidaO7EAVTC4yRJ32QNnXilpIgxmTEA04azrjSvtdnZLnI7oHWoGJ+YC9hWa8QtOaUGmUryCmwesKr42R62yWvYUWhdKw0tt+jTmZ4ORLFsrlC5600wQYg5q7y1BCXoVcNtmtCmq3LS4PGBGy+CaybIHoBtXSgfXSQNw3+xvBfGDNBB2bNCOxnjGU3AAQVbtLsGW7/CJlm5th07msvklNfUkLVZAx4z/obszupDvJmWDZs8VAhckhWabbenH0Uvg9rei/DEcIGU+3tXkFkqlSsVKlwNDXF8UCj1CLWJEqge7Rcq8SwxXdm8BAxAwq8r89Ji0IBgJUnyGbRH9cjoejJmzSQ5SyMaGS4hrqFbHioP4YJm9Rtecz2FITJhaDb
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
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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
2.45.0


