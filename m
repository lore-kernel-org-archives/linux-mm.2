Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453D1C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943AA6B0089; Thu, 31 Jul 2025 19:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91BFB6B008A; Thu, 31 Jul 2025 19:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E42D6B008C; Thu, 31 Jul 2025 19:19:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CAD46B0089
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:19:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32C665D0BF
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:24 +0000 (UTC)
X-FDA: 83726128248.07.4F5C3F8
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 419A1140004
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=JzIVl2Co;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754003962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5+3IuIbTGtFY2nGYSuEXP86kkX+tfkAPCryfH6oHp8=;
	b=0EWWInzhSvMyBxWKXbl2DyHryMmECCoZ6McdC9FVZa5pvOQeh6SRTByeemC9vpJ3Bq7UTZ
	qYH+yMNBp2XqfG7Y0Kbib7jP1rNjRTe/NNkeuzOuGMqVGOtbORLgU4UmuE6YDN312G2cVQ
	y4Nu1CproYBlid8lUQBbFBeSRur5zeU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=JzIVl2Co;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754003962; a=rsa-sha256;
	cv=none;
	b=abjlEbxfvxBzHwOS/uRglZVCqeiQ2/kZnOVaGJyfXwPkBL/2kSHvqjB3csDf8GHIStwm4T
	O2YfN46A4qgZL0IElHb9/IoU/Bq0as4LayFsez6zKSZQaKSsBnd/lV79fCgeux1qT47iF+
	h/KIQUo7PcOG0kiv7Cx7a8CSOb9N2Nw=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-313eeb77b1fso198234a91.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754003961; x=1754608761; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t5+3IuIbTGtFY2nGYSuEXP86kkX+tfkAPCryfH6oHp8=;
        b=JzIVl2ColnKHqMwM2qvwQcpgOAcdA4DZaFB0HYEZTgvEfxNl01aJWete8edTlNn8N8
         JC7rDsw/TfZxOPYrp0VCFSgu46tFSO/VV7o5Ma7d1GPwl4LiGl/emqv+zBklOrk0r/2x
         rBJPp8/O6cdKKVcnqit4jkBdL2sgOKTKt1oRSmYzlSbMEfo5p/kynS5dtZcAHAtLrGG5
         CwHqCch++5kHlbyhCkZJggIXVN1ajXBEmwV0n3S38bhsOZcOwupxbwhvtnr8OPLJKww9
         Z4wEjYflbE+aoE9PahMaE6sJFrctHAHQqP4rE3nGKFnnl2A2I4gu/cQZT1y2E+83KvPp
         IkNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754003961; x=1754608761;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t5+3IuIbTGtFY2nGYSuEXP86kkX+tfkAPCryfH6oHp8=;
        b=clOfBXtTDlzSaKsEMuPjOBQ+BjR/oNnDkw0vAcJEXhT0IrREY86sXTDrolOYST10Lf
         p1ENAXmUX89D/k/rnIUByRlGDBYJJA+kmPwT2/BwtuXDyYuNhDShxcB+AUrHnWlNyWtY
         qiO6pl/+krOQuuYWptRh2g9DN/VFoUCDfO7/qxuHSdF+AC1l2rAB4R0noIh735qaeIZ+
         kMj6cnRPwBYA03vJ1fQSt1sQdGrGxfH5ua8JezoesKBH/91QaTE8Q4ZvdOqJ7meVtrc9
         G8EYeVaXqx/tY1+pysFtM2IEZmd0in5tM3WjvzRwU1kC9Q8QPSSngfD6Ff8DVagKZf1K
         2t2A==
X-Forwarded-Encrypted: i=1; AJvYcCVuu4oUmUdunD9G/zJjqgF2L/GAXTCyRLbEUsRZaEKyl5m/2cyJGgRNTaucRoBMYRY6XDCeZzZyNg==@kvack.org
X-Gm-Message-State: AOJu0YwH9FEQFkC68/Af/B58omKXGTKKnzBqPUgHAnJf7KMlIciJmYnL
	UVLGcZJEZcWln/INqM1XzhCRPdr1CAARhQp7ZvfqnMcpf/vwqE8zZiRCoM3LGupTjAI=
X-Gm-Gg: ASbGncuXdJmDt9ET68MuaZeaC57Wu5/hh38XB5Un3JbZj0eOEo8WLZWRAWy6HlhwJiR
	aoNB4dlVbOha3MBOa4CAJPbqx4HEBdH5axbZ3jUcRKpSGVKtGfSdOdKsS1+Wg8ALwyDSUa5evHB
	f3se3kcgErcMOy9mwDCP3DGlGLrPttqqe32jhK+8pM7jw1Ws8xCPdNGdUx5djA9pqQT2gI3HlTL
	Mtu5rD8Jat6a1EvANyLw804gXixEW/jJeMf2kbyg2v5Noh5OJgsTKkfm5fmGHw8ANAp/QFosbQY
	BQ8leuAMxqGupXrhB4LVeLAk/GGGIx62/SA7P+w8TMZaLGDWVyex+5alm7jCkmxkJcay0HzPKUO
	yIHG1UChjU3FafguFPTn4DRcyfaRX8XLO
X-Google-Smtp-Source: AGHT+IEH44+OPKURq8+T8AnOKShWurctpSh+ROm/XJMSmxz+G/vZXXdz2Ne+7bhpwqTninNTw5WBuQ==
X-Received: by 2002:a17:90b:55c8:b0:311:f05b:869b with SMTP id 98e67ed59e1d1-31f5de58622mr12166749a91.30.1754003961009;
        Thu, 31 Jul 2025 16:19:21 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:19:20 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:11 -0700
Subject: [PATCH v19 01/27] mm: VM_SHADOW_STACK definition for riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-1-09b468d7beab@rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
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
X-Stat-Signature: x9twrp1bb7wioekpys7pkh9ntyqknqs3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 419A1140004
X-Rspam-User: 
X-HE-Tag: 1754003962-313188
X-HE-Meta: U2FsdGVkX1/dltJ40eAT7y2s8eUfBwqtlgCxo5haojhBLYAI6R1xXoPR3SRSifGbLJmhrs/lqjfLT1VipS9kbVnYPtkwHPVXv6bEKuAnLaJW10mKduroceGup507SePbAyw1J/+G56zihqEqpIMuULDznLBdXYR8pIMbdfioNvsbkIs91PQemSRgLevarbScWZV79NmsssH4Xpjp24iU7wM9Q4+dd3jp0DBvZx1q26Plc3AaVhjw82mRZbgDM32Him5RnObQAVsqafJeTnSlXjku92In05AsRJ1Wvwpz/cg5/BKNKkH+jpTWHs0gBWijPxsLvSaQb5Cgk1T0Cg2KERp1CL8GQtav7YD1Z2zdYyvG/IDsi6hlEqTDASYhd3VKsumTqRUYN+9/zCPmg80N17DoxnTo1s66jxztN8xPy8BqGkZI/8hcSO+GJAhfr9chRANRYzyZd/L9zyOC25ktrz7xchbKhdLqV+mTGKcwTRnYU9lhuVZoR3HsOVxMG/LvgtCq0O/DqiOMrDhM0Doczl1RR5680IX4dd8nEKuEa1Jroty6S6JgEBk+I3gWtrbjO45h6uGKahKKVAtvVOyYfzXi3UZ8NtaQQBfUNPP1hZRwhR+RXncEAdPRSo/5NMdpSAfI/Y+Gn2XR1ls9SENnDw15hyndHQrbtfRR8FpTyy6E6fNuDCMmheqvpWfDuYYHgJ2Q/zOkkk9u4IpQUqRahYCVPS7Bk/t5UM4Oy1NZgV/TTJOLzqcNF6NxjjjkzIx+hWA/aujayNqRUT2dp4JDzQ+uUkj11TAyXTFzxVpCLECi3wrb/8oHGtv/8KQWLWhsaV1rKsSnckgvGxjDQ0kjqBLZ8lKBFchPq9yLDKK+l0eCM7Ech+O9Sx0uWRyoV2PY2Ji5JS4qDYey+jVFFuXRKJS6hnsGdsKz/TLnLDzNH5/lPBwFT+enwZwryx5hHA9hfsSD8InoGlUvnNQkNwe
 sUSVhGtE
 NjPYRXEV9Hk3ITo99KQBxuQBDKyJsujJiTx8JPie3CbiEkkGPhx81RDnRAFi7CQ73jXsBPeQcSLgRp3biaP4pIfVIoc/Rk7qF2fqjMeorlPNHCVnuCadj0pJTAkenpQSGbudHKzCag09HazZqlpjqshXKDUwEMjY3E0k75gL0ZhD9f0xjt5wt6KPcUjFqoecGSbLQ0TGjiLMHQ4ULNCE+6TtCxW09NZSJB46DMPnSuB+b5sLP1WGrbvHMKXUxWMPVscItiMCMvrRlAklRPTojMfJ2RGEApxw9serN4RQcBEptq1ITTjif/0EgP+LeEfUlzOLAjOkCnzvLYNk/QnxsB0qJm0qThksi4h6sI/RKFCYeF78MQx4K+zi4R664cA8+ivKrMcG8u/ym1jxiw5u9lLY3cOKVsW7PuAYN0m6nGU6cTbuEFiL7fa7xDA3VBjUMxIxv08RHtV7ir318qRPSbuZarYHh46V69biqz2chwEsYEgVIHOcZwadlfsymBdooOyKoQ4hJPoBH3N7YFxl+t6icnH0AeBx/5mmMQwecTSE17EirR5fe+dNWOJtum8BI9Or+i9a+yBnjN8UynYmKWYrRm3FrrCANjFiF/u7rU3ZdIP7XWUTLtEQTCMe0plFzjMF1wsQfXXzOA4lrH0Kphhx0qMqKPLxFF2Hl
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
index 0ef2ba0c667a..eb48924105c4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -353,6 +353,13 @@ extern unsigned int kobjsize(const void *objp);
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


