Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5CF7CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641588E00A5; Mon, 13 Oct 2025 17:56:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2ED8E00A2; Mon, 13 Oct 2025 17:56:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41EA18E00A5; Mon, 13 Oct 2025 17:56:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BDDC8E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EEBF18837C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:46 +0000 (UTC)
X-FDA: 83994451212.11.8F05A81
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 10EDC1C0004
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=IYi2ppqY;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf21.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392605; a=rsa-sha256;
	cv=none;
	b=nJMF788HY+vSIaKrmA2JXAde+AUihgo/0Ovp9mTZcGNM6veZJKWuI53n/zmaHUlaMPYGw+
	Qy0qeOx1SXG80bvPLb4WwxajtluobVfx0IDbUAzata/EU8mmmygAXfSJAl3bHQTf1LqmEI
	sTsL1U9jyGWofK0Nl2F1ORlMzVzNjws=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=IYi2ppqY;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf21.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tlTCabZFxINt6Lm9QbVDHZ4MzlWsICTGzKM8x7gyE4c=;
	b=xFzeB6Jk/sbmapWxEH6+7cfpN3negMl3e8h+v3UwyH/K2ldFvS++DzdAxwGhJYrjtOR1Of
	7XoVaaQ3wBv7zBXm5lYBn5VwfLSCRb/W1Uu9U5OSE6F06uUh74AnV4bmsdSNzgIUb6BVQ4
	QCThq9pIIrLlUOICKmVN3S1VcH8yygE=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3307de086d8so3805966a91.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392604; x=1760997404; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tlTCabZFxINt6Lm9QbVDHZ4MzlWsICTGzKM8x7gyE4c=;
        b=IYi2ppqYO1vA3GXz9Mo5es09lfD0rDM4N052T7kjAvy8i4THA8kXte2eiFQvQ23Mcs
         s3V+V7Bxcpu+/UGWIu/NvhbDLP8FRqtDNbXIKDwFQl9986AcgFOQWB5nXFgS/idyMu+M
         W9YXDQIy9zb9fdhQQbFH2XCERPFN2MsBLZkWSyp+KXKA+Q7SMK0cawMh7wrKO04cQ9Oz
         hN9U5XWJiz9AjCOQFhVWE1Vn2NYETKwRKWrGybxDpuvnscuei8f1rDOc+fu7lXmFQ6F2
         EFDUf/iqJCgKgPc5bzt4SOF4jQKLIx6CFmarsuOh+MhLyxIkB8qsoSOikEvmqNgwtH6N
         Q+fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392604; x=1760997404;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tlTCabZFxINt6Lm9QbVDHZ4MzlWsICTGzKM8x7gyE4c=;
        b=xJhzsD2bhHqdot5Vt4fGaLyUJI+CpY6bbwMuVzwKGAPwcilM45HXbqjBXMGj5R4wxE
         oDEwb96gZHqNmvDyUO7H5OlgwfIHtCSV0DdBJSOg20eVT8buGVxt14ON9sib3tF0qn6V
         0V6ZU0JrZDxxr7k7bAHtOReHcTbFERvneAnsTfBVyjI9VrmdIPOVAiH3vnYcw8RPVqFr
         6bKVyZE24s2AU8O5TAiqulXch7wU9JTerp5vdMFww1oFKLqDLig5OeaJ6XvvfdH+TVp0
         LwDXsSbaQptlks1x8lv2KDoWOyAESsXEvyx2yWIOn2eCSs45OUsAv5bqwIACAHEnXuu9
         kS0A==
X-Forwarded-Encrypted: i=1; AJvYcCXZS87U84hnBbM2qnPdFeBeIKQwIzbRlvct5WHxZ0kLsWnpSBWMIebJYYrudHrR97RLh4KEVK0MIg==@kvack.org
X-Gm-Message-State: AOJu0YyEp9Yu8IE1nUrEm+zgUXR5g2qxVtZBhQat/Oq0V2mcjjLsk4n/
	y6nvmEA0hB55i7GL8Thbmqk8+0Ep3gXIBYlrV/tvD7rEe/5IBgDOWhBQMbvxUtun60U=
X-Gm-Gg: ASbGnctqsq5YbT9uby/6tZ5FIsprDa5g7eP4Q2xZQ3vguB9doRIvS6zpr8Gq3hgmj/f
	4e/Rf7OAHRe2Ms3fnRhdFAGaeY7SD7/TTnVU2m4+IuDajGicrrL1EPCsfbi5ujivTqcbZYiwEAi
	hXoJQHcXdc34IEvvvhHMDH68kuiWIWdBN3u/SwOMIsKYsDg6zlCfZUxlyFuTMVezT3IRVkzlfxp
	1ymbUtSCsVbWODkDjfyT+QSzjHDlE8tFnRP4GmHNtIOBob+oKuk5tzjp9C4TzVbeEYYnDWzKxt8
	2BFl65CLwbZxIhKmX7U8bpDWOP2g45MiAKjbf0ZG5VB0WwHVFUk/9S48bMHpjGTCnxpC7zgse0j
	pJKDmosZE3gCpfUIsIcP2oe0IjBaETnpM58TmNNiHW4cDb0JPEe0=
X-Google-Smtp-Source: AGHT+IE3NXVbgrP/RYPydbW9+drnd1N+r2sI087097hN50jn9gE4DDohow4FO1i/KcQ8Qec2oH8NZA==
X-Received: by 2002:a17:90b:3908:b0:335:21bf:3b99 with SMTP id 98e67ed59e1d1-33b5139a3c6mr28585062a91.32.1760392603453;
        Mon, 13 Oct 2025 14:56:43 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:43 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:12 -0700
Subject: [PATCH v20 20/28] riscv/hwprobe: zicfilp / zicfiss enumeration in
 hwprobe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-20-b9de4be9912e@rivosinc.com>
References: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
In-Reply-To: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
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
X-Stat-Signature: e1rwparddru4nss6sgj5q3towmukppw6
X-Rspamd-Queue-Id: 10EDC1C0004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760392604-701794
X-HE-Meta: U2FsdGVkX19MGW32bVE0C343D7kaI1ah23Iw6oI/1W7pWXIzTQxFhGEf5+bmPs3sve9q26e5EH/qoEhiDG+aCJLO7hoKqNoTUFT4ZjSnhdefSufh+vSRqxKhh8rxHH709gcVgtrv582+Up4DHYYVT/ErPvEEnav8zcD+DeeR0FkeCTRZlTWykEsAnyWsw8rfvVhKyCYOFfxccrN6uQX7YZL5+ZxJdKQrarjTC6L4E+yoSopXwFvaGyVS8JeA192qFG85/wt81hNU95p9EZos/JhPdFH3g6FNihSZad215Ei3UEzN1OG7DKverXdD3XTc+YSxI66HYV9yTRLuOYcvovwhCecDVb0rMIWaR4nw9EF1SdXi2eSPJWnm+XPeyDV06QFrCELPshqV6hteNW6D6KM9PEP4dt/Hnfe0+iouZ+mr2sZeLffcHosAnUxdl3ot+hRfgowFf4cFxyKW+fan/iABfUFmvx38TvWV2tvss5GpgGXFLSlxZk7nDVbAswlF6RxO9Cwcz/t+K55Wxy9U3KZw6ZtR6SJofg8TL9530+WTCfrwTglXgpV/pxDeu9+aRLcxTT+4y8VMFNe5ZlpJeVZ/TEz6BSDiDbSw3d27XPtMQGC2tIVXQR/U5sheqq6JjIpiwayBDv3KZqNgHRx5If0pldeW4v2GTeNboA0e6XtR2FDofVCdSELMG+S+zvHeoplNovNugsW8alLCturK9VupkKwQG7ij8B9ddOdSGppkYAwMIslRdKHBr3abhFSt0Ey5F63pfoNB3/XjahmMJcCypbkdL1bPzkm/EPHrrdLhcH5NFgBf6qO9zsXquXLhclYj2XvhrpwxBMFPLk+NphP5CssOaw0zUfNTcxS60F7oaLmB5NU+nqVoWsv94BJ75UuxnbOnXuIWjK0vtK4YQnTVLpZydaNczUstndLifdVycug+knDfP40CBhC2kUHEwtOXsPuivqkHxWApjNb
 Qie8LbB1
 6Q8kyIFjUb4rMXXP6eYAALPXyRWyAHDn5k2dmELDr/IN1KuKTrZVZ8/OXg5BdF05/JRFOPqo+vHIU3aWhSOifC6J4kd5AftcH1DKAYyj/e51TVEi0rEeKti4+49NlDDFoVErt1XAMmng0lpuCrQOEhJ16S0TMD3lsWXhfPYt9PgDWKTqSv3cv3Z5sZerj5M+YaZQwRXmgASG9Dx9nvOrXvDI8TN8MN6Q8f25PErT8M+B7gO/ZQaFum6c90MsS/K18btOaYJIY7icTrtR1dZkiMGAXSExjk8Xk8uBCewgdeTwprcIaA1mIZUMKHLyk8GL2bPyMVZY7upi+d9S5DouN9odtu/BEeIOg18xwlmuHv9PNPltTEXA66Dk4E2B8vd3QQ6x9X61EQetOkFiUj56cX0pA6VCTm4BKkDQiJzdtPjZdlMBgYc03JRr0hlQCmEtsK5XGuaiUEubbSVea4VxDLB7f/R635smr1+Mn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding enumeration of zicfilp and zicfiss extensions in hwprobe syscall.

Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/uapi/asm/hwprobe.h | 2 ++
 arch/riscv/kernel/sys_hwprobe.c       | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index 5d30a4fae37a..0efc9c7d1199 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -82,6 +82,8 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_EXT_ZAAMO		(1ULL << 56)
 #define		RISCV_HWPROBE_EXT_ZALRSC	(1ULL << 57)
 #define		RISCV_HWPROBE_EXT_ZABHA		(1ULL << 58)
+#define		RISCV_HWPROBE_EXT_ZICFILP	(1ULL << 59)
+#define		RISCV_HWPROBE_EXT_ZICFISS	(1ULL << 60)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 000f4451a9d8..d13d9d0d1669 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -114,6 +114,8 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 		EXT_KEY(ZCMOP);
 		EXT_KEY(ZICBOM);
 		EXT_KEY(ZICBOZ);
+		EXT_KEY(ZICFILP);
+		EXT_KEY(ZICFISS);
 		EXT_KEY(ZICNTR);
 		EXT_KEY(ZICOND);
 		EXT_KEY(ZIHINTNTL);

-- 
2.43.0


