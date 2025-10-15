Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43281CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80F328E0063; Wed, 15 Oct 2025 14:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C0108E0005; Wed, 15 Oct 2025 14:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0338E0063; Wed, 15 Oct 2025 14:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 56FFE8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:13:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C3371A0254
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:13:47 +0000 (UTC)
X-FDA: 84001146894.18.E3EAF30
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2E66C180007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:13:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=MInQjv8m;
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
	b=cGJxIzSRoKrlPFTkfPkSa8qES8fv4do1y2iYyU3lnK/9bWIsUf+LnO/hKkwzVT5pIu30IR
	wLgHk/fgCAnGB66InzZu5nCwobdIxOKSkgEzzNEOP0yEUmGV7CHfipOmwj9fUT/JZfeGQl
	0deaH9VMo5RsmdgHF2j3AF3vrftEi8g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552025; a=rsa-sha256;
	cv=none;
	b=PRHR9sWy4c6thSZu6TChtkZ3VIMsr49Irev4WT1u41NCz5EfJ1q9WtM2hklFyIzmmqW/+k
	wnX+v0+zd+o972dVKDoiD1gDX3H8m/n0E8QQSEd7GMWcc5IMpalVhD8YjWdwtJC9g+X/Hx
	EuJ7/MsW+Gc2LvuYpakwalXBLer/A9w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=MInQjv8m;
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-782e93932ffso6132839b3a.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552024; x=1761156824; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
        b=MInQjv8mESG9IIbeCBBcm2Z6YUrZ1jsRqL1q+obZIr2ZmWdWVvrunQIHFk6lfYM0xV
         tCS2NpWNqRrSarhBLxMuDaeBNlu+iKZNKKnf2oVb/hK0HYuxk7Ass+pXnPWP6AbGQ/5S
         j3aYPLRQaLaTpp6O9cuzHXw3qrkjBoS8c7Hsd8FQ7faZwVeOJYXiqLMlV6Kvr87nKIMw
         0PYNuw0U+JSSZ4TLxrV+1kznJdA02MTzmJo6j11mzhry8tzYPjPdqPNARXLkiwGfaPFt
         Cad/IMdhLGtGi1g6tS8kgnZGp6/iC4mLCTJm7jHmVYGlslAChoFmkFrpCNNwE6uW2x14
         DHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552024; x=1761156824;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
        b=Rqk2qW+ATZXnxvbLTkhJBkTNYnSFSeUMFv5GrF+78M+geW4BwKnSUQjBJacFdcemk3
         7w78KbJZDq23cILGuWW3UEIg6o4mTItyJsZk/Q8oTeoGJKDcrvKQJmzdHJ+vjN6ODdf7
         MnF1SR4fJ/EoMmS6yxpsOv/EE62JpHuTMhYrxby/21GQC5F0B6TSS1Sf25vja96a82Uq
         yDJP8m7X+K7lz8LeURvfls5L7fdrcgRBXpXpskkZDbobdYjbCfVaINQbVykbD9n2JM1n
         ey4pZUcUvEa2pvcMh/Gf0WcEcxd1KA1yBRnDQIoR4/4tzsBHDMQczgVb6hy1wsUA7+c5
         eIwA==
X-Forwarded-Encrypted: i=1; AJvYcCXcArRGpawjzEEATizSatthGBHjkNCQ2dpc/5YWgdJJ1NrMvKjppF78pJAkY3Zb2yTrdayDWUcbjg==@kvack.org
X-Gm-Message-State: AOJu0Ywq+hz5Y8zulp8j79+G+rsgsFWiQJ/zYMu/K+Fsb3mnzl4pa2en
	Od4cP0EEQQa6Jcz44iJIjyGrNLUTMrwZKmuIWtRpPmoDFTh91OVTqqR+cFj0j9iNIpAVuOuyCjR
	oWIEu
X-Gm-Gg: ASbGnct+jy2G9fqEcnm7j0bwSHPTFEVX8ScAGgUcN+juVLChhS1D1LViWrhhZz3B2Wc
	MxlsrHol2LHHzG+9kcsoBsM1h7eB9P5xlxuf0i5kyCpUidYU5G+n3IJcMoQUYX1d+NMwxoghWUw
	3jTnq3ZAbV+hXqrGmvZedDKPOPVqyEr61Vby8De/tR6oj6/AFYXaD/PZRahCZ6JcDr3M+DLYkcW
	5TQ96i0suSXXoezTek3Xb66IsG3tu9s9oRl+RkqwMhrmCbecnuFZ6S4/Z3EmyQAd5GKUjULSHhR
	Ur1TD23ENM9jaNwX96WU9X48oIlounDc8hhNLTHBsZRnnreXnF+HnfesrDgFOVFWZyCEAzh1Lfe
	gBSvGHW5EoGpRPf+ey1Y/MBZYR2hNO8XGLx3rTaa8yY4UL4fj6bgKfSeidk40cw==
X-Google-Smtp-Source: AGHT+IE532Sc+sFZCiNmEvoJegTZ+cHh1Xu19llh3mJ+MHzVrRYzHyEQ1nhDnGpeZ7e3G8zwayd1Xg==
X-Received: by 2002:a17:903:2c10:b0:27e:e96a:4c3 with SMTP id d9443c01a7336-29027374b5amr339106065ad.14.1760552023763;
        Wed, 15 Oct 2025 11:13:43 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:13:43 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:33 -0700
Subject: [PATCH v21 01/28] mm: VM_SHADOW_STACK definition for riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-1-6a07856e90e7@rivosinc.com>
References: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
In-Reply-To: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
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
X-Rspamd-Server: rspam05
X-Stat-Signature: 8zbbwzdauu8hpxsb4a8fek15q45bskw5
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E66C180007
X-HE-Tag: 1760552024-518264
X-HE-Meta: U2FsdGVkX1/46YuTYak9TF0OCPVL/yqv0cy5UvK9w6LFuBUTmxuqqayCns1U0fORpVUWylltXwIHd3CONKDSJnkNnPHsJaCT/qUyZMYHIjJet/unKU+0w6eNY/3+Ee4dfVRq0tpiBevAVy4TOkMKnvk6E91nFOhdtVlj91ARx5MfcZ6gAqqsDd1VNMEkU9lIbiBPd/t5120Qcnk2CWUWTNmi700vpnrmb6n4jlIb2icpPEe8boPJbYCZfVvugqTlxSTc7+jKgLszgRvCMMOj8+XY4Fj0Jod52x3f7WPyx0VMLtWCAQQZ17YP6V+M+Zfr2fK2o2oTzvoHcDSUVwAtGrFq04JUM9F1nyl2TX1xVElcXI6uwAkP0Y8kPyZyHEaYWyz/ioEl9iramZuitd/glvZ37A6+hk/ef21rDz8vkbFiJinSKD7B04WJO7zT8Nj+UGmHkNfaCdjSKqdC/vATUZpsQfPESqrG9Cj1lx1u31UcAOhYTYPV3MxsvuQ9ShgAHO95/PzK5f9COTmfOVqoTsTcz8oaJLTsMAVeGC4yHpgm5icNja1tNnRmLljJCkkU5WoNMwXfxmnDXC5SOB7t/ewlAhOf3K0yvTBycXpptT8sbiTTPAmCCQIDgtOdXcb5Vdq09+wWin3OzR4ZYPH0+S3cwBIGoU1S8Qd4UdLltWGk3n4eQ6pCE6shFYJW0PCleeoeauprcxJvD+oXYZZ0n+plKbdDrsBQTW7zjhp0wSv6xE4JF93rNOmInX2GHA3rNE53dbpjL/Rs2bV6S/JRP0/vhBGWL7m5rON2GmufuoaBrryNPCiX4iaFRoWKEdQzbkvQxStcNmq52nD76hwsfJFQysjjy+7WqMknF0bi9jwyE4CcMlxpi4Z5Uw+SGaLzylbIe1D5w7xisyt46Y4mvmv0lCNp/NfV92saXzgPHlh7EHvaR0EupoEYvb4J53oZhsxzIoLJKCh02hdKGZs
 Kpj1JsB3
 v6C7L8SEZk2FO7G6zp85O5J17I62/LHAteaQFtXjAPoZD+4tffDT+Z6ONopprfNdCttFtjoBUPJ7vOzAyRcIFc3WWtVOQYev6VOfXGt1XUjRRU7sq0cYMFiYo53NUOu6eEbS7is7R0v0fNr9AsdUrMc41ZrtjfdIq75lQV60vs1qkir5MVKXMfFpc6eeIa6AocCzMPuHZBDs8MkpUw3FyBOjilSD1o1DqJ7zsk0F+Xe3IF+aJ2Mt4GvyqFC5f7icgCQHUGe2a0cWJ55u+O8JbipiDV5k9AkUQdk8KSPvbddyH/JnyrwPy4yi3jsVzfJKEGTLs7rWvbnq6KAHbNlmFJ0vbGi6ZBSAMVmBc1Vzfh5wwMpBYpaDmYZc6SwdjTixPfQjpYUznDmrTYjHZlm7l74uwsmBuNRgw436Ap9hWSwjWdMIrO/8x9mEI9R20pIlFgRIjc9PMjacKAAPYdk6C3SNDUzvjdnzWmsOS/fuTCtzKSKnOnui0FALgZIQZeWbb/uUueh3MsgRpFo4cm3nveMdeG520AONhN8P54PSx9G7P/Fy17VJ32C5Ecf1S/p8OHZsc8iISvAucDac=
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


