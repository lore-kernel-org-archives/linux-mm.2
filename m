Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F210ECCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 23:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 437A68E0006; Wed, 22 Oct 2025 19:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40F458E0002; Wed, 22 Oct 2025 19:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FDD28E0006; Wed, 22 Oct 2025 19:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 222878E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:29:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D74F913BF4A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:42 +0000 (UTC)
X-FDA: 84027344604.27.DEC7B94
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id A601A100003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=akcBmApy;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761175780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
	b=SnC/R/C+dnfqorTTgkqGricX27bI703hiaRE181K+8r5eDjeMlGL7PqwVAdXVQjmA3s6bX
	ajh8sNIWCn+t8OaG+dchwfhP9utmhUWGEbEkMn5nXXwo5Xfcz+TVY677rNaYeHt3sfLbKC
	ighfDH5zuAlsdznBJZKnX4PSmvh4aiM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761175780; a=rsa-sha256;
	cv=none;
	b=6NDSNX2YetJ/NUzeVLO1+O56cXYjLlXGk6i8ahLwrVhdFsU5po1sup50RmOxaVT8wkHdKr
	BJSR82DPnUjuWRXf5NwVAM3heCyvPYwGD1unusAA34QcV59ApwYhdvI50qXBob6Mzjdgtb
	OtG3NsOK1oNaN8p4Rq3Y0ZC2hsTqdTI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=akcBmApy;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7a1603a098eso125760b3a.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761175779; x=1761780579; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
        b=akcBmApy/bJbEd4R/qPAUM+UOpfHTCHDTv+onPPMTZZPBpyM7JkQ5aoU5fSqhBCRY9
         Xih27/vbF+ZB2SlA4YfEoH0c9RELnQpH4a1U1EO1Dv6SafvAcR3zMmYQn+YVqqLGObyk
         oRq2E1xJ6V/xX/mOSnzzpFcJxQdkmjnaqO6Jm66IxLMEIF/fTuzwww4+5lGPn6Rz/NpF
         3xuhJ8GQQm97Dnm2/1K8KQ9MdO6HN+ZAJfz2GJ4WKGpVl+CG0d5bdILBL92E9Gdf2yfo
         o7zlFBv2ju2EoBBM1nrIq3MvZ0DG7c3OSkJBa22SmgghnNFFIndobKQR3p7Loqe9zrnP
         aL+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761175779; x=1761780579;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
        b=bcQngEkRC1cydwT3/rKd38iPWoABSv+nrCIVjSEimX1JElcNUSO8LyeX4aZ/SKbnHQ
         E+AJae22VtD4iCADQv4nUqHFgUPCpMFtZaFnXEIl1m2TaqyLJ32s+AVo66oHMSSYmSWd
         8awE5UydqJLANhGgsfuO6s751oVq6JCmpAAMl51jh6NUbTeBbB5TboCo045eCja84bhc
         cPULNB+Qr2wR1pYwqXlo1QBtrXaghxBpfKxXWcs5yj/gxsvEfSigdQmlxwNz4d5S8WcC
         F8ryIOSn1lagYoPADGirDcvqLaNu48NoOHRPgcVMSzDnk/c4J1J591PuDzRBRd1dQ1eM
         8n+w==
X-Forwarded-Encrypted: i=1; AJvYcCXdpHJVqaOHh8CCIRoxME/k2Q8JKzfzutcIwkLwLTAaB/+UPi+SUeaAS4403SSQJnxAOgoIYcQhOA==@kvack.org
X-Gm-Message-State: AOJu0YwkL1qkwRaFdOAzf8C0RWoEBu2NUHsBPlMifun6a/GaoXOEaGfA
	Q4dhhepyL4ZKYPowUfijV/YM9qs3/vPOdJL97n2LZUW5aoSKDe/CMpRI2tl6OvEWEgw=
X-Gm-Gg: ASbGncsuR1xpnGNq3L/hLPVfDQccA9OUfdp5pKkMqHrGV2nhksqcrHHDvVrjqQRJX+5
	2b/1vDDYPS58Pmdy25jSgi5BU11QLVwu1Z/GEr2q0x4xniYReqbkCQ/ZyU7h+dfO1lxR4b719dp
	j8XkyOUETj42z3btad7YGKIN7sNZg1UVoUbCgZPsvTr+LTvyLCMqC591prT48JtIUyz9Uiq0sXG
	zgZc1pj1coV5xKIfQ00b24MvldgPJ/dK9MpR1e0KrY+/GFXY0pkSF2IMLGq5maOzVuw7t23sqct
	pTH376T2teU/LMA/CODNJSjMClRa2Pq9mwUa8uBnmVI2spV3NKTtXmE4eLu8S/q23vXgl8BYHkS
	V+6rvZErM1iNXeuz3YaN78qHI1OYB7Hwgny9EAcelL2j9YmYO/asCFZVYH+GJSgyX/iaTHZLB8J
	ElwBgqrxWtYcRjeQ4TGhM6
X-Google-Smtp-Source: AGHT+IH4ZZjXE6CRjcaUUDddOYCxWrMkikF4wXTDboM+YAeQwS+9+Z5nilbrQH9D7uqvoUJQSq+yZw==
X-Received: by 2002:a05:6a00:3e07:b0:7a2:766f:518e with SMTP id d2e1a72fcca58-7a2766f52c5mr169475b3a.23.1761175779371;
        Wed, 22 Oct 2025 16:29:39 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274dc12b2sm392646b3a.67.2025.10.22.16.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 16:29:39 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 22 Oct 2025 16:29:27 -0700
Subject: [PATCH v22 01/28] mm: VM_SHADOW_STACK definition for riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-v5_user_cfi_series-v22-1-fdaa7e4022aa@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam01
X-Stat-Signature: 6155z436nyxe58hy7j9y9831c66cgs5u
X-Rspam-User: 
X-Rspamd-Queue-Id: A601A100003
X-HE-Tag: 1761175780-971827
X-HE-Meta: U2FsdGVkX19s512E83tXxlI3XIdPdaAx2KemW9GJdtzDRgZhpT2xAinh5DjCiSIdRCRY98hCDFh1eDXqHFh0LPlQSsvz3vyZ/RnU9DQBzarVthy0yBytPGH5Cu1BbNZKQ03Ma1td7DbsPIZtKGXGoFxTUY+rkv7wRqqY7av6uN06W7jAoOQB8Tfg5l/VpQl5m2uWSJHvPP6w4GbNxIz/2H5sGx/tvI2oxdHif22L7DqGukBKIttr7AZ4PteyzgEp4hxCDVIpdXIwDJLVxv6uCRjQ4sIfsikE/olUbbUt8jTzTSABlrZfGtyrHDtx+XjmvOkIFmu+40bXJCIRftLhTrQ5O/LCpy3fs7O4IzK1hVBLR3MwrBxthKqMgm620+SGVoHIgZPEh9fX4gDjC+MemMRCVPdHFpnPbunM0yiaI2VdFRlTV2bAxxMUEQPIZv/inM/dcm3sU+k42rW77cbvmEAAQe+/gw3UgLoCQjyZeYGqqgj9lb/tv//aeeB9gs46u8espknO2vXpinRPamYj+9Kzvk6ss5yGOsFtaabszc+GUT1a04beHfcTF0XMDLkdfpTRMKtj1ygXb7WiY1zJe6PG8jTmVmAOEhHq96M9mJYdT1hIGPqRhMgQQT4Lmu2ETNHnSrKT46gkbw8rYXBERjfUjWExf1Js3o+tPnLVyVUS3yl1GhyLRd0BbNo+MeymhLg939JWQjwtq90JNl0iD6RndcPnbNPwr4UikRdlvYzDtDilkKYe+6ny1x+38PyR4/YIYgnf59GJGkz+NsI9b1qk1Ggxkhu8II+TpU0SahYB+UyQNtPTzZ99HQU6heuUm7G0hV4oqI6I5yL4UIw2S6ChoyBTDxTXVndQYMjjDctoPpphch+DY2tIGO3GXWlY3Y9PXVHVdcK4MTVs8Hh455/YJLASSEKvsyy0x8+OwKukJWIREhbhZUNk3Q4jQHWW6Ma4ADwU/mF13h7UlwV
 NU88xwbo
 DnWgYrzCkzmg1DE7PsgY2uZ8l5dQHya0HYPnbFue6F5f6Bmf2XSe6BXn81GaUFY+bT02yj07dFefMyWvlcPV9kTbT8jR6GgBWeTi5tiWDWzireYJwHlr+8D/uQODCKPXz13Ng/uf6uh93dZ5RrCaeGivWesO1ljcG1/VXXH4xfwgnZAvSxaz1C9PpmIwdEoE8M5onpNVqGc7DDf8sj+v3y/xJd9KOHG/i2d2NS/Io+sxWUvNfvk8WBbDmy0lTVl/mLn1zW+TvvAuEFTQWM5x+CvgIM79oNO8ReSqGDrEQL8BXtU4en7+XgM+ctzrHndq7wL2AMxmyTfpqoRtLMYaHC9qKIwtMpncD4iFDyCf8/QeCHhc2QyHNtS3Smh6jrdLCMrdRYWtQx3pgKLz+kJdfZ7rqOC/tJNnMUmuVQL+SdqjAxo7MdWzevlO0bch3sjNknxQxyftmzl5/TcPLVZ4iMwlg9/voy6WO2dvkTWtp+ogOhrNisebwuXsO/R2jKPGwipFL8uv5rIYXX90vfSjoPzHuLIkfiQWVCowa0LecJD+eXeG53wS5Ml3/Y0LeF3FfXTs5i0czB0UTn/M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VM_HIGH_ARCH_5 is used for riscv

Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 include/linux/mm.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..2032d3f195f1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -380,6 +380,13 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_SHADOW_STACK	VM_HIGH_ARCH_6
 #endif
 
+#if defined(CONFIG_RISCV_USER_CFI)
+/*
+ * Following x86 and picking up the same bitpos.
+ */
+# define VM_SHADOW_STACK	VM_HIGH_ARCH_5
+#endif
+
 #ifndef VM_SHADOW_STACK
 # define VM_SHADOW_STACK	VM_NONE
 #endif

-- 
2.43.0


