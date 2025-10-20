Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44669CCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991CB8E0020; Mon, 20 Oct 2025 16:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE8B8E000E; Mon, 20 Oct 2025 16:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E668E0020; Mon, 20 Oct 2025 16:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60C868E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:53:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 234AE13A21F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:46 +0000 (UTC)
X-FDA: 84019694052.16.8FEB025
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 349281C000A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=V9MAKMG+;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993624; a=rsa-sha256;
	cv=none;
	b=gL2TGcpb9E7d0vKdJert/W0CkhK6WxbydA74HBMKxzR7xxvvKQhKkqP6A2J5If1QxK7Lrp
	/UUakkwX+7G3H8bGAhAQMjbKLIh8jNH+9WLV+Jd7mOaAaXkPx7K/JVEb1R3OZFL4fpnfB5
	TzGQ7ho7Y8TGlonYuKConmYk5vvNjEU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=V9MAKMG+;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
	b=sDulbojHQoUOQe+X6MIJIUtM2ta9wqIbGBi4wmlO1FSlRsmTE8dEA78//FiD9iZqBGtPf/
	sfwn9T6IPMKEyndIwbjO3l/g4XKtieT66SfSaRr+FVBEX3+OxFtUhiAieHV5fK12SAehdU
	WJrjnYdSyvBfbt1QOLyb0nNXPAb+Qxo=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7833765433cso6034911b3a.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993623; x=1761598423; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
        b=V9MAKMG+ftvgZ02HSoFjuW7Wu8SngoZgLBn766u4fZ7n+WFypZpo+K+I5cupwmY5vQ
         Hs32Z37KENtryEn2kRGVPUHBLsMuizqK2tI+4ZVqfyVuvcxEhvZwbwOk60pUURPY/Rkh
         vdd4x61y/YiNlWRZYejchw7dQ3nvSqQOXj5iswMVhgXlAYOJBLd6q1IPGBOV1wvxuh1U
         QBgxn5KscxePTh7lPl+ikTG8ObceLOMG+ZWT6aoOudI/MoH3SUV35GwaFXEpGi22qfOl
         KvB+XyFqt5f/ItKrQDVoZ+5/regQqBsMiv1aucZrbobRrv+QO1zp1Xc/TRRGO2anb6JA
         ziyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993623; x=1761598423;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VM5DlrQCbRYqN6WQC0IO67CheqmNFMHVu1qXR64a+aw=;
        b=jMPMChvqgkfjIXkbPFUXmC7wSshyZHPUSSNrdgVP7DBtMRXx9Vc9Acqv2UJ5aOnQpF
         qDrJBhI/LKYJAsAAjydChH33KKcqY8T6Hx8HpTDAXqCATl+cHYWBZUppMfuTgg6OHZ5H
         gPgHmO3ipYi+LCkGdAX2T11RHWtHebdzDxJkcfYlNpsor/SzinEkE91PHgyfEBC6IwGN
         qrPg5PYAEvVt/wFFk5EUwRA8s0dsjoP8IKiwxuLZ2xJeWbJskT8R7qYktmRr6gqB45dz
         rlb/pEvSBDlj6x1A/Wjhqga7LvknhzOaVXSiI/xnM+2ePI9w22HlveKzotDLQzqdPZgD
         joXg==
X-Forwarded-Encrypted: i=1; AJvYcCXVME5XnXTXcaSH3JCkB48CvfOcpSTPbMgCDqS8uEQjOb/HmutH+LSLjqForBUxg2XQLIQKwJ3ngQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+G6MqaCgCa9cOluFH/ohckZAK0FouCgUJxuOL4iHZmqzNgfsa
	7c4zjErrZdYGF8PKCxasdi8CcunOmandWSeNNwTPk8pLJUjMMHX6qnVHWgU9oalNKrM=
X-Gm-Gg: ASbGnct/3k6OH9YuhMlvCUjo+F46cjFLztXBBOjWS8iIgDwnUmT1LpxRopbGWAnO2mZ
	PHWUmFb8r/F14X+M/J5m2QG/PWxjFVOZDMjz/U1Eoj5PRTm4BjgoT2yVp5jrGh6/9aNuvY/mACT
	J4zDE82MkzQqcRMGxFaBpg69ZEUzyQSjr3X2HXBSvU+ZD9QPluDReG3KPFN9qvp+rhBv87Pu2Rd
	RHeRIjnQmJ8BnuVUj4E8Y7oREW/54HKBOkChMXVROUYjN9Hte/5JeigBm5RtmVk0MgdHZ5s9zid
	mgZDDJDEYaMhX41IXQOieKvTBvHR4TdUKa4NuPeRFSNrLBHk2NoEaXSS/pkpqryNWfACb4XYuEn
	I8f3f2/hCoZctZqqSWeBWs3FNCj58S6MQdBAEEp9A0HoRmJz0Av5SFyamsWYj5sM3N5fOvcOhdT
	9afXVQopbVmGNFJWF8dsBq
X-Google-Smtp-Source: AGHT+IH9TW913zfh4PW7FMgstLMuYEwVEH5t9QrKLz79ZwULZBMVRXbb7o1uPrVG0bYl8xQxOppecw==
X-Received: by 2002:a05:6a00:99a:b0:783:6042:114a with SMTP id d2e1a72fcca58-7a220b289bamr16527524b3a.25.1760993622997;
        Mon, 20 Oct 2025 13:53:42 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:53:42 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:33 -0700
Subject: [PATCH v22 04/28] riscv: zicfiss / zicfilp extension csr and bit
 definitions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-4-9ae5510d1c6f@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Stat-Signature: 11f63mrgsetknx9y5843bp6xxbfjozdc
X-Rspamd-Queue-Id: 349281C000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1760993623-874015
X-HE-Meta: U2FsdGVkX19V35U96e1Tm/zREW2CCwu8XEFdzBME+P7zro9CwYaEqJqxxvFeS5uT91ftQZCAOP2QEUTjqm5rBSHF5aM/QKeLYo4AL3mGIFHKl0BCUaFE5B6xxgFEFZYMGvPKxKhg7ljfFtYDc7g1KUAF9rU3vR9zrxERzYlkxZYVL/BB0tfhEWePz013UBLKXkDpKa+Lc3qgMeIZENIMQS3H7pc18Ramciq158N1675ozlL7d8ZdwHE4eZC6DET85eFkZuIgttwrdg/eCWrzvuisK1nPHdj4b44Pjk3kwGjrvleBn0iOO5/86vPK5TmllAMIVVQ5NGUgY2Y0NqE9Arn1fWwwZFk6vHG0ZzB1dI0I+KHLXkwRNK9xG8XlaSeOLjoS73amtDXL6BwOrw3ej5uC+m5S0NoxgHzj8XTqK9/SjNK2OXqF4QJ6vv9Mbm0Wg7O1m/CzxCzkivFRUBe/uQ3Rg6Pf4lkn5gnyYaN/ZR7qxQKOzFeKD2wKjwWNmX2EgVkDLS8ifOKTJfa/bLXFCYBB1nw4GhK8tHyIAREavnms6OZ/Uc6zk+A/pYzDdcUw7s/1MvRsCUA6TWIzbTR1PRjC+pC7+QYkWq/KU8ekBbnUSK4xEVF5ZS/lYar3of1UdcYwKmRO99HM7VOlYjSjTVVaJK44+ESq+A14OwpZBxLWKCbcJQVajJLpQqmjWOT6MTEfUYgfmVcSxLlWTkTAtDtKs2cTXeBROmrcSLSpMke7OVtX5clRJVlRHl1s4iaQNFGrdGuOMHmtmJr9fH000siIYyDoQLT7tDA9vGqGCj8aAdXpamfdFT4E+FefDX2n4+riH4zy3p8Z8P/GDvWTrM+AD/LAfyJrY5IOwH29TiZtUB+EWmFfbqMp7Iziy6YVJlBPR9nv/LVQPFQSD0a4dNt9tpl6EN02IxjQoQ2JrjT9viK9PQDiGPPSe8w/GsGojZRIuQqi4HTf700uUX8
 vu1ghvMr
 si9TOZVxXlHtd3M50/yH7zrbvcJwoCNlRPPhHYABgGUq2ny58MaxOtaDaJmhl8Q/0V/064HFmLtnUUpPVv64HtbErddxKTYpd71v8YdWUDs2m65zjxdZeRsJYh6935Q4fAibR//pLrm39Diy0ZpJbSX/sKgBah3JGhMoVVQcDTG6ru/X2SaFuX5DUSt+y8DyGGy20XSbhrWtzflxVVTIThOSJ+Ed65dGYXdgx/kOfGTnQgCDW8hokByqjIEAuu7k/j8qfxdiTbW0NNrbH9xk4yHTBNs2/gv8IQuLWxBsMzXMwaSS24WcPnPTzWEXc9z9MwqdJ96FktvKalpIH++VfnG9Ykolb8PanNZVEI0U8XiuCJX/lAjgoRD8IBp9cxiZo+cWeBFk3h4HhgMfE/Stkp4VAVmyrj/d1+ll5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zicfiss and zicfilp extension gets enabled via b3 and b2 in *envcfg CSR.
menvcfg controls enabling for S/HS mode. henvcfg control enabling for VS
while senvcfg controls enabling for U/VU mode.

zicfilp extension extends *status CSR to hold `expected landing pad` bit.
A trap or interrupt can occur between an indirect jmp/call and target
instr. `expected landing pad` bit from CPU is recorded into xstatus CSR so
that when supervisor performs xret, `expected landing pad` state of CPU can
be restored.

zicfiss adds one new CSR
- CSR_SSP: CSR_SSP contains current shadow stack pointer.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
---
 arch/riscv/include/asm/csr.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
index 4a37a98398ad..78f573ab4c53 100644
--- a/arch/riscv/include/asm/csr.h
+++ b/arch/riscv/include/asm/csr.h
@@ -18,6 +18,15 @@
 #define SR_MPP		_AC(0x00001800, UL) /* Previously Machine */
 #define SR_SUM		_AC(0x00040000, UL) /* Supervisor User Memory Access */
 
+/* zicfilp landing pad status bit */
+#define SR_SPELP	_AC(0x00800000, UL)
+#define SR_MPELP	_AC(0x020000000000, UL)
+#ifdef CONFIG_RISCV_M_MODE
+#define SR_ELP		SR_MPELP
+#else
+#define SR_ELP		SR_SPELP
+#endif
+
 #define SR_FS		_AC(0x00006000, UL) /* Floating-point Status */
 #define SR_FS_OFF	_AC(0x00000000, UL)
 #define SR_FS_INITIAL	_AC(0x00002000, UL)
@@ -212,6 +221,8 @@
 #define ENVCFG_PMM_PMLEN_16		(_AC(0x3, ULL) << 32)
 #define ENVCFG_CBZE			(_AC(1, UL) << 7)
 #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
+#define ENVCFG_LPE			(_AC(1, UL) << 2)
+#define ENVCFG_SSE			(_AC(1, UL) << 3)
 #define ENVCFG_CBIE_SHIFT		4
 #define ENVCFG_CBIE			(_AC(0x3, UL) << ENVCFG_CBIE_SHIFT)
 #define ENVCFG_CBIE_ILL			_AC(0x0, UL)
@@ -230,6 +241,11 @@
 #define SMSTATEEN0_HSENVCFG		(_ULL(1) << SMSTATEEN0_HSENVCFG_SHIFT)
 #define SMSTATEEN0_SSTATEEN0_SHIFT	63
 #define SMSTATEEN0_SSTATEEN0		(_ULL(1) << SMSTATEEN0_SSTATEEN0_SHIFT)
+/*
+ * zicfiss user mode csr
+ * CSR_SSP holds current shadow stack pointer.
+ */
+#define CSR_SSP                 0x011
 
 /* mseccfg bits */
 #define MSECCFG_PMM			ENVCFG_PMM

-- 
2.43.0


