Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ED9CD339AE
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADB1C6B0209; Fri,  5 Dec 2025 13:36:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB2E6B020B; Fri,  5 Dec 2025 13:36:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1536B020C; Fri,  5 Dec 2025 13:36:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AAA56B0209
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:36:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 425AC57CF1
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:36:56 +0000 (UTC)
X-FDA: 84186274032.13.EC2D5F8
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3C669140015
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:36:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=bEqLhwKj;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZzDCu7IaTRxcq9mEPcCPJw7K7qmz1vUabcyA8OBdm1w=;
	b=IGtKoSAhbiPg4vXdZeMBwukDXc3/neMTEi2VJuGGQvW3geMM3LWYxIJiNU57nGXs/HfJXV
	5sZUzHPc43Y4MpImNh5tGW3X99FfIAbFj5NY59KgkUE6uLjjxtgqOLmNY5JK/OVEliOfNa
	GCztDz1K596uFbMOPlD5msfq+0OmxF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959814; a=rsa-sha256;
	cv=none;
	b=GfmBTZVaPdx0b1qa+4ViUiLLhwh0Nwgw18lQvcTRU/BwCXWyU0hfHm9vQIbP27rU/FWTFg
	uBvJi3mizKw02+2vMVGSerPx8nsSpcgiNdFgQ8az/8CHOEo/Zl+XJEj7TjwCUF7/Hog6vZ
	+YtQ+G+az7HLqy0hIZK20jGWC8vqXT4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=bEqLhwKj;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-bc4b952cc9dso2160928a12.3
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959813; x=1765564613; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZzDCu7IaTRxcq9mEPcCPJw7K7qmz1vUabcyA8OBdm1w=;
        b=bEqLhwKjc6OJVqFmboRqL0U0tyLCUyDJjEZIs40Btg+VbrL6iFPCVZ5TIP+a1VKu8Q
         anyfCf2n6dbX19SOLDTXTW/kpq6Fn/tgvO0qVbOOkI0m0tL0ujTOtChbRxqxtVVNxp/F
         eq7E45Xbx6CRx5yoBOSt9iy2uXfoxUQidCHtgF5clI3jT0K79LZ7giPWWIW5cjvTdtSq
         A6X3oA2cMeE85rm+8HVm2tybCigU2wQw69cS6U8HZltk68FJkGSUqWmOcBD+WBl2dStG
         Pj/py5yY37RhbkBmrn1LegDYtJsV7akdK43nIvCPOl+/Sylu1dGltTMBna1jHi9zTqve
         Tw2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959813; x=1765564613;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZzDCu7IaTRxcq9mEPcCPJw7K7qmz1vUabcyA8OBdm1w=;
        b=NbnaEFBAOLyWhTG/Um3V52EUy8iHEkqj9Yz7z1A2+IAC93X1IAO5iKXMkxAuMcVnnB
         6Mnn4JapyReTpQjgZSxHsUJWQZcQ5MkEpnaQCIvNofRZVlgjET6MbeEyk2QiX+sIXAph
         9UjIsgRZmGudexkt89uTdWdMModQ4eNTRLDZbkDlk1FKvNO3JcD8YrHrMTi72ddcq+i5
         U/n7paCjl2SPImmC/L58BuhU/qbcfFpAii2HjXZdMQ7RfFM8DrvDySQHSd+HzS+kTjmf
         FqmmDmWqNyXtrk/f1TRj4nkOVHc9UV+QSmYdFAFGflOxz/jXJh45qbIBVGECPt+kjNoW
         pKSg==
X-Forwarded-Encrypted: i=1; AJvYcCUwbLXJFo+m2orgcn+k4CYLICc0MSM98Q4coEggClpgEPiNJ8cAnUHhts1sTIuP8YgJbBDPPjRNjw==@kvack.org
X-Gm-Message-State: AOJu0YznzGKhsQKIVX6OUGAdNbW+dC6i3tydvsBpWLxf0Kw9EF60rUcD
	h4E0w7wfGEM2MW7VpcEZt3YKSE76yjXYag29K7oOsAkN/mTv6CG8W9ytB2aGwp2kfnY=
X-Gm-Gg: ASbGncsasl/n09n1ZB4giqNSWsVC+fsnXb4j9KsXNeQ0iEMLFHoKzccR/kILwpiozV9
	yWhknRAnkD1v8EBPPQnRz1NUNPmU1ThxtNy8gJo0oE46f2kSlecRJm6gZGBrM3+jImm9F5J8S2A
	7SRv9V1oixD3LPxYZna0iQ6x2lx4/XLscuIcK0A/BAk/kHY6R9YRjHkaGZy1OXPRZSEipkWxIwJ
	Y3bMHq5vMwE3RFYynY4Lz+1hM0mNJkeIaM/pubsZeTmsf13uW9xaWtfhq6l6cdkflk8UuJA7IJK
	1zev8ExmU40JuI9/B58NEgFmv4RyOC8TWe0LTTrHoB4hS2ZU028piMG5JwRw/HRyF03U6Cm7anX
	XbyV3YgYVmkATDD5PjtVZjdq0B9lu2OKqTBdrvsoMe7CGOgEOzY/IZ3FB4syMZyZ7qvxq2CQtJP
	VaragIxmFRTjk8ibiFUnoC
X-Google-Smtp-Source: AGHT+IGMTXNhEE0AGobVo0Q+Qpcz65YU2t6Uoez+HvjFdTXQk2XlyYkBUQRk9w4i9DYExo/tp12ayw==
X-Received: by 2002:a05:7300:bb08:b0:2a4:7270:1788 with SMTP id 5a478bee46e88-2abc720149cmr114273eec.19.1764959812961;
        Fri, 05 Dec 2025 10:36:52 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:36:52 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:36:47 -0800
Subject: [PATCH v25 01/28] mm: VM_SHADOW_STACK definition for riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-1-8a3570c3e145@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=941;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=BfqrkDAmEYT+r742gKB+SlFctae91M/veuPAGWY6Q04=;
 b=wb8Cvp9WwhgSAwjQuZXG2bfRw8uKBYeoYJuQ+D08ldqWnIr/+SHvUA9MzZ7+c1hnN4WDZnkHs
 M6IZRQCZeBaCy67MIkBFvjWj4owucJIYwhEmnGzRtLdXw0MOWKyNECN
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3C669140015
X-Stat-Signature: qdsw3wkymxhnqn3rz7pokmomcqtzcf6a
X-Rspam-User: 
X-HE-Tag: 1764959814-296627
X-HE-Meta: U2FsdGVkX19K38iCayFYZjKnvn19OBV3TsxbVp7ENpfbmq9sA+00BEH5kOYtPTEP4Pj4ZvveTai2VjfkiFkB056q1nNl0fNVcnNflb+AylNIp1zN/05lz+we3qNap3IG54U41fEGSa6IOLTumlite4cKrz71rLWSxXHdH26AcRZwgPv5jsd3ZcQaVERazN8u9aEgI2fQaHpKSvcj4A46qn65NFCtpTKPTIGmCVVNl1MEcOlCCy50vdkzxgKfjNSloLrlZAH0BYtqCn10sEqzcTtVoCotBzc5PuBZMYH/MXQxG5Yr4yjp5yX96jhsgAAw7R03WKU9UFTkizWrbtyC0Ddj/5Alxywek+gTV2ahWUxS0W3VUjYreOcCRfz/NLg+/7Fs6Bf/8crS5L6IW6pNo5O6M0p+QND+WK5NBqgS0v7E3BcoZjBC1TDwrpvG4UCJryB3f93nxqZzvYx+pdaUrXMlmSVg/8A4AXLCIyHEcwvVjcjq92a6cUTq1rwv4hvJMpggPcU1of71qoA1al09VB9gXqyXg9N9aGjMINKgeSj33ZEQaVXTjlYr08yWVJAOmdAi09a6CkkuhnrtUj+J0FoYoeJNzBm2QhF9xeJxR7mmjEkkOldEEkebVGcKYxNy2UQ4tymxoOwsqrG18GXGWBdK/YwwbYdakiQqA4ds5m+Ky5iLNvK76VqLHEigzZgMQHTidqXfhOEuB+JSgtc/3v/qLegiNTA2N1jwGASCETrOKPLSt6vK8QvmBt7F+tB7eBbBMOnmmCcVWCW8FiyuFoGL6EoskpgvLKXANC1jP8g7AGv/QBgFU+7fmMqNb9TBxbR4YW0atcaIQlB/vuo6VNNDba51xzy+gD0cV4oelyc3u8giuf/iPw0V5Dolp+TLlXH2bFnl750RVESCPWR2Ktt+yUwnjZ+ONg8XksCpc+18iuiMI1iJGPc2eiepf0dA95/FV4Hu6kfjjpnt/8Y
 kd4tD2E/
 xM5McNE94ONI4JX302Dfw6sGgfBm8ku+W55QmnJwMEm6dSb8zXaE+m2dWPA5gv51hQfUYitEv1+6p0WaIqK40F9zyL5ZPxqNOuKx/7yNDiYgWc81i80IRibgmC8290ybWiVhvriuEsdQAxWNypVzxnAVr4UF3J5anoZ8yOgtHg5pTmZk0yxfT8O97JIRjjMmJl3R8kJhjPkKxtsDeXamQOVz5A2oB5rjbNjEzdEphm3PE8dNBEKRpE5KZaeD5nxNkgU3K0ZPRQloDJCKU2BX33tvFg4mvO/2Jp8Y5WN+0vEGJt1R5jPtQWgP/MQoObaQ3Siid7mj+eVZtJdvSRoTWWIQ2C/Sx/IxCwJO8FDcI/Tj6IVz6DfOTiernGRig4CN0AAhnU5pQn8q9rJuaeyE2icdCVYmEu/LvSG81oYGgS22Ylt3yUyb3dHxLUqau3ppRVmBMUqupMkg91DZsbSAbn3cDVeqwhMOTG73NVpXjlUD7IOd9GpSvUzHtV1pY8oPQCaKK3jelL0wxGj6Vz2mldYjGCNNDgtU3T6C58dcjRajdkw4QS5aqBALVPyQWfWrkOviI/IkF/QZ3TSscMApTxBVYSdrHo3554ot6EEUBQoWq8qkK1YqfGDrirT3NMlrJyeKH
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
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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
2.45.0


