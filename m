Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49D1ACCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 23:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CBC18E0002; Wed, 22 Oct 2025 19:29:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87CCB8E000D; Wed, 22 Oct 2025 19:29:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A57A8E0002; Wed, 22 Oct 2025 19:29:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56A928E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:29:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 039A0129818
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:55 +0000 (UTC)
X-FDA: 84027345192.08.0485B1C
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0FDBC1C0009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="P/8E+qrv";
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf18.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761175794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
	b=QCtrjzZaNzs9dDu7c3ztNqnyj1BkYjPOjYOoBimk+BV88ThphHoO4okvK1X9VbXwHOWSPF
	0I2Dbh80cgh8wMEmUP/W8d5zEzwh48c1QE6KA4AhzrvuUyL4iOSN8I8vMObVXoJSfYBw+D
	EVl/fR0ENtd2wEhNT/TF0zorg5iUGMQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761175794; a=rsa-sha256;
	cv=none;
	b=k2YWwWFUP/TcwxpkJq2KUhooNzyFbprljKyQyFDCtcQK+LbjjzwFrzlaFi87hBfk5LLI3/
	2kHNnv+fxSZWvjsFOxihGOOMBubIKqCXsW1QH7Ef7yUvAreKUDNhuikMkRMroHJ0AlRfhO
	kj0oKZJd4J4y+kj4YUh8zG5Gxu51m0A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="P/8E+qrv";
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf18.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-782e93932ffso174624b3a.3
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761175793; x=1761780593; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
        b=P/8E+qrvoj/YiV8plDsWNc3nkhZ5P0uuhrF4MQK/WbPW/ggDKvcQPrvhpXxEeG1pOS
         QFGJnPU9cmiWmg2VGpxnlSeThvNXtihyX2E6c5Xg595kEbbOTiTPtD1SjeljrjBzdj0Q
         X40XZXULOXMdi8wMnzwpVC8jaTssgGvMDIQMKqdoOk2qhTObjKer5kGZLWA1Jcn2YBbK
         9lGEZ3B4U8LBiT1mYwLaeXGh+paKnlvrMRoREyxxCUCVapakt0Ugz9bbR+/HHU6F52I8
         lDQmVKM/Ywsd/CnK7a28s1ncckE+RrXL0S65DevjRp8+YMqMwK5/6sVHTTTVy0pBMUqz
         Stiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761175793; x=1761780593;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
        b=XTvPlI8xpjWXw2MO1cbsey4EL8vTc+XuhBJYHJuPT+m4hA+PrH4rWf7Bkt6fRWOVly
         opJqC+N/YJBINlYaupfoQSgJCX+lPTFUNPHl7WIRZ4r8DOLH6ym1GR63ast9DrKwwpgF
         GRXtDx23i2sNbmbhyxvNu1sTB7j6mi3oSjMR0ivYhp8YTQeHFk3y32EewFMiZRAvUn3x
         c18f5utzd00WlhjgRnbXxak6q+q0+yDfKqfCDVcy+x1UvabLWTAuqTJvliXCe36he/hh
         1D1R3m0nI1NtPkY3zZFFSPB2+J3UNQ5c6Q8VEw4IFcEVIbJzGG8ivJIYsn8j5VmRj9vm
         4MJA==
X-Forwarded-Encrypted: i=1; AJvYcCXGBgivlRS83R4prg07r9v91FQgjdi5zMnxb13qSOj12J0vVano6u3Pjqx6VR8mmaGC7naxSx9T0A==@kvack.org
X-Gm-Message-State: AOJu0Yy4cNl1SVthxrpQX4yIvmeyotOX5dp6fLCZKbCSTBqgHb+XLB3+
	cfWOtsgW6mHBVFrFRvV4SoeBR58fksgaOxisU2pVxK4MZEtYZTKsZYS5HgTlsdf9KHA=
X-Gm-Gg: ASbGncuITdd8NIpJ/zxWkLZbhyOwSxrYQLEhGIl5qi0dvsDKpW7haREluAkLUwjfoJN
	M7i5HKdrUJdTdyjXaPjjvBYt+mOyX4g6PkllPNIW+XHWoB8a5DopXcs5e6i051bLzTQccQtu1g+
	jD35EaAPXsmA4gcrvyLQEevhMZoh1U5WNGTCcgneM9VCAtdfZwdEgg2t9bTMJQcKBqfr1EN0j+3
	x1JHBWcP2dvhbLW8EmZeuIo2UgiIp/izQrcnYat2Bp1hsGntwN8FRR4VtoPNcpPKwrHDAG5eCqi
	Gp1rpBgf/rHFKncjOKIrN7jatZPlfxL9tgxHYytRGgyzd7+06XbspSl1qUWK72NsJDlwHmNScrU
	GqrR5pc0c5Xp5L9jYwb7MRZPTolTuEu00t1S8/YJhmQsuKCxiSS02yi2SbxLHKpNr5aeYT1wq2x
	5+6oCwvHDZAA==
X-Google-Smtp-Source: AGHT+IEyYaBVYRUloskvUCZ/yxzw7bPY2t7mEI/bU4QrTEjElNpmobT/VekcDiyMNALIqBN5WCBgDg==
X-Received: by 2002:a05:6a00:2e1b:b0:7a2:7157:6d95 with SMTP id d2e1a72fcca58-7a2715777f0mr2234795b3a.14.1761175792856;
        Wed, 22 Oct 2025 16:29:52 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274dc12b2sm392646b3a.67.2025.10.22.16.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 16:29:52 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 22 Oct 2025 16:29:33 -0700
Subject: [PATCH v22 07/28] riscv/mm: manufacture shadow stack pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-v5_user_cfi_series-v22-7-fdaa7e4022aa@rivosinc.com>
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
X-Rspamd-Queue-Id: 0FDBC1C0009
X-Rspamd-Server: rspam02
X-Stat-Signature: 5jsyopzfknq56to1dkckrtya9nbg813t
X-HE-Tag: 1761175793-628954
X-HE-Meta: U2FsdGVkX19RJOVVCbRkQUHufLY+zUP/wk2arlaNRcfSQ0sgRJXgFLVwVn2zp3IUjoxtC6MyoI7JFNtxF92aDpyyxxIzznHgsO8Bn/vHGcO5RGaCesXjHqYVwQ99hnDynNvUuYHHGge6SoyVwMk3+oGoSCiOdhleTaL6zrKE+4nRwefm/TsddK6ElFTP25MQnga3Pn2g8r0fWf4PHaI1BNtXPGYODAd/QQ+UUJtqVebke2l56So5cTaOhJGmcbx/rLCew+IYKzcjSk/a6IpgPMIj3JfieVqTU23yBqSzVtS2lFZYTveMmnyiQ8jvGbgWadGLrbs7pAgVhmKSphk1opWF3qTLe1KhzBca1LaUxj9PsmKV9eA6sByF4HMjtSkE3xdBXODvGxSVAsQPTDfhgeDemmXRk8GK/FtbT9qZA5lYlpKouplw0u/gEVxviFuNzhZglf7PU8/F6Y6xXk48HEipQsP1E63M6MDGc3zJwc4RTKkrFkBR1tZeppr0Z20jY2L1BLdc8oaEVfp4vQLVxbRekGa0M5e1qJY7Z/HrvxVi1l/HwlLI1JHjIqEsfs8jlFiXR0UYsoGmThmD/bE0yhtxydhJcgc7qO9JewPF+n4s7VtzJiPnQkEgTjtnXzQn1obmNHxLEd4yfbe7mc552/ukF/ZLRZ2T6h5OnmSpqClfOArLTsHEg8mKHHOz6VRbRVgpCEU5kpIlybfz5fWsi459DRalVqbc/ffhexi0P12nkBWxp8bkYkJS21gdV6yQFw/OVi0EyUltEBlTh7zcHEWWIke72KuCEfZd5lOYMHxEiF0Pm8WhpPGfqIrv5GqoIIwkems5Uz1pSHo3gqLjDuqVCTwkYM9HCRtNOtiTF+VjrEZErYBfjZGIGqUu+cKyO/E54c3n8HR4wjYgYswLzevZGbk7b5Cldh2BrS1q20Mn5Ejq+OXdzD2Jay9czt/Z3PTeUA5kMu6PbbfNtGs
 d2L9W2Xo
 zT6ifIPIk7BWYphj0mu5O4MK12icH8yvbwiHPZ19yyAAVCcfXzib7JnoCHapqbyNn7IzsxA5402DuWgGyHH8WidygM1jI2g8+w9+wBhbq0qPIXDTIgIrFYA9nqNUssazFagO35AMgG5k6UctTHmYNHjBamrYjLRJBr1qogXCFNWgqM/vXyjvnOmWurtcrMxa8ytRTvOuyTytVV6mUSFq0sAVP1V5JKly7gr75pAPzk3DRoFaiC7IOgZBpplwpNjUunPzfoFXwEzXOvgfbfWlAmPSs5D6uDDwCIVWMcd0W5pkHt5YLeSqNEPCerJrCJDBKUX2bxeJ7J9R/P/bY5fRSctp9OYPTWDMe9jrlQyd7gD0lFhsm0DYw5hKzDoVdBBW5/i2E7CqJ7Rs47TSGQsu+9lGq1hHm3dDhgjW/PN2Syay9b5WUKfEzfvwt9c42YyoFxl30COvydZWLi/AbExDBQh0tmqXeelFqYNrAkG3gh0FhA3IBS/kuW9INQx8engqMDCxl
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


