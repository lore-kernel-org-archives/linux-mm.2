Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B2B9CCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2CE8E0002; Mon, 20 Oct 2025 16:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4CD88E000E; Mon, 20 Oct 2025 16:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0568E0002; Mon, 20 Oct 2025 16:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC77F8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:53:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 606D213A76B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:39 +0000 (UTC)
X-FDA: 84019693758.24.F8D9D64
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id A046A180006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=F2A4TvsR;
	spf=pass (imf16.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
	b=VwGPAasDiqr5Hg6dzgOGgX/393MdEGEKMvQqgWxMxW8hV1aBDkRL+hduE9EcuAszoeudCB
	7ySjI0IxtY2QSSsPXWtDLa/zYb+x1r9k9FNH7UCL9/buzHkvtGkWPehbzYJpU6bD1LhL+D
	pilbuKdZNK4QEcbx241+J3YnPsHwfIs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=F2A4TvsR;
	spf=pass (imf16.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993617; a=rsa-sha256;
	cv=none;
	b=6cOYRcpWwOF1EkpMQbFbjteKbBHnqRYWARY7r1JVhtz5T64ytAtIPKV2TfQCfijbEW0FuT
	aNcOo1Ibhu5Mb/yszi7wyopqudMu9g4Nx9obitnvTBNjsGnTV16tvT+xIwJd0fEk40GEzT
	de6Cc/7X2L3xK7LPJukJ+hJuR3PentE=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-791c287c10dso3732060b3a.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993616; x=1761598416; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
        b=F2A4TvsRCy9V8W3TakwJT5iv6v9NfQgyeCaHsLpFmSFtCYXiK2caMaoLxrYNf2nmRd
         Ys8ApgYXorzvAj6es+BscUi1P31ocALPcHfRLvWfSvt5D0ZyMdbfgm2/yXF2wZPF9aE0
         Z5oDSdkfPZGXTpjDlks9U0KK6UVoRYAukHh4ilLo8nXj73SkbpnEOAwNeb0fSj1pBW0c
         i9xsEUDPn0UxMJXDAx6vGjshHC819P9Y4lC9NFnFPj6v9piqyWxJjR0S+c8OrODr7SAU
         mq6tLkpUjHjp7I5Cw4lHjHpjam/PGTZGmtDa7pjne2cqB9NIx9dE81WMd5XtU4gzuqb2
         g+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993616; x=1761598416;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
        b=Nu915dVXiEDg4va8kICOz7/GP7sraoqvfSQER7YCHjMpWIzoX9ofAy0NWYEln1x8Q5
         ERHpfEVD+yqJw/eebZmIjurAnOcmStxM4OKlNwID+qEl7YrpRoI0UBMe2KcYx7AYjwSp
         Ytr+GS5nNOgNXQWrp/d3Gl05XPL4YbNmMuW0tW9z9TnaertutPvtSpKbr6flmrBpLmva
         QmZ3FUzpNOGRaMcJzE8j8+WMktXMvOxOKmudi1sEOcnQIwJOqUbuDb7YHjZmDcro0q4D
         UdjByJc9pezHf+5wytVpDIcpY8BALTsCBk6dCUAN6n7W0CkKRWBJUxMyKlwJTNIJyk9f
         s35g==
X-Forwarded-Encrypted: i=1; AJvYcCW0Po3Q1IW5YtMGXYYwZOm86RCc72DFuZzMXLkXbcfC2Q+TP/owunqfMro70LBcZ2+krGCCdgFxRQ==@kvack.org
X-Gm-Message-State: AOJu0YzLmzT3Vj2VpihnziMbcpTrnPPlXu8ELJDy2ACsHt6QDHFNQhsS
	IDofmM+dJkUnNAYBRM3mKeWmsGc3/QQI5uz8bPgbTs/oL7tUoZhcADZKqaEey5PnzNA=
X-Gm-Gg: ASbGncs7iToRig7QbfiMUigSM600SiJ6jemxlhIQmfHGyfpUhysoodoXdKjMUzmVdhW
	F5fuUmrlpdKTjmq5Uy9XHGzoMsIKuGAihzANiz5+NbPUaoIwB/LqKoQxreWMMAe9az9lfQLXHF0
	WjtTI1UpaVnLusBL6b64XcqGA7P1mzcq7KS5nBYmsME2P/vWHqk8SKucQOn3c7pdncDerCDFniQ
	uyx6JdNsNStykFsztzw60/xu+lZdV2GuxWw8BrirXlioWtCilZFTPbMIXLRyFcK8yeHRBE4dI+d
	1zUBsc9KMglM8HBpgYC3rOHsn2qXva1uFn/XvDhT6/Feq7st78GV1j5CGZgcAURhQPAwjpz0HX1
	4Yy9NPM8d4w78r2cYQRQCcVu25ByvRL8rP9V13xMbET3ouIs+Hu12SOUaGEd8RKXRNLk+txDza6
	8tdi5WpFa6Xg==
X-Google-Smtp-Source: AGHT+IEsg+UZtjwN6GyVBaH9enzTC3xW7GiUIy1dtvM7p6mWAAST23WNYHXDrDm86KscnwevzOzJsg==
X-Received: by 2002:a05:6a00:a8f:b0:792:574d:b2c with SMTP id d2e1a72fcca58-7a220acbcabmr20617941b3a.15.1760993616488;
        Mon, 20 Oct 2025 13:53:36 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:53:36 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:30 -0700
Subject: [PATCH v22 01/28] mm: VM_SHADOW_STACK definition for riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-1-9ae5510d1c6f@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: A046A180006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6m5h1bq6aknfqjzrmjfrns516gptqyri
X-HE-Tag: 1760993617-596245
X-HE-Meta: U2FsdGVkX19B7wex956rVvnvS5bFnt/pKo/NEx192oXeihN7O2HzZ98W9B8q5I5cuOL++F+HekQ7HWhwHnjfoYneR6NT50P5EhVf5ZJCbx6Wkt+9myx5NzQVPKbPnLwkS9vJH7s9s34MCVGwPmMFZG9IH50KyCJJLiIMmaEwCxcd5Kqk5BB1cMHZ9D/TmHOeLjevwh/77YXtujmKZmvLzjZfvPt0lWhRjCXEFjmXevLO3MJ1n0Oa+QVdv3b/Drw9MxloU9+fQ0mVo9hDvcDDQD5PQxQuNDCC3F6aJ3B0Nm0ckqnhUJrHTOGLIy97Dm2AM/fyUik0krZpmsxlUMAU1lzNGLAEMON4P6KP4iHdEAna+vmWpZFlOOijS5rLSQdelv/7PCESiN1YuDvLRU5bUu5DLfiB4jhRIWt0JSrvXqGCYEaeh5eRAXm9iNaHZ9HjFpJ4u8HqQTnxh6j/hIuCkMiFu1GnF9PJKo+xm0QmtM+zS5WzwrvJy8Wt8WB+De4DS8APqdH2CZ55WMWr31bvGqCPtMw0s6PYrThSGrlpyfNO0FWCtkQzaH3/jYx/ghKUYFpbj75+7cFji56gK6e9oBhGwySEsRFZRQYaXaSLR9c9RL63gzgTV7XxM3GAMSQPwlfIWdi0M5LNVI12Asm1/91nqVbEIGlbP1hQF2cbCCWHpCjZYlFcmyuyrUkWsGwozD8vraAQ8/VIYgXzWF6EwCf10ntV2BbaQ4rN84MeHQ5RzRBWXLwYR22hMjX4sx+mhhJ0G8AoUyhTpQk8J/aOU+1T4upLQ9e4c1wz/tjUr+jFG/PUl9Uglk2/ru3A+MZor9oSd3C/l0kEktnzo7J+HX9ZwrDV3KlFsWeeuNKN7Mo/tO8dKN76DuyeCYQwgVDGOdsFhI2w++JoXHKYyZ7lzCAQHvY5x1B+SmwiTpPahQ4LsnvE9gLkqfOAs+5q28rhdEm+kSfKRjAezASFZKx
 MirIaOm2
 mfXTRUZlQmwODZAUp0ktee2daCFI6Hj6jjtlA7wp8TP09ERZIlex6VDdZOkIgbJa/fw1T5AuzMuliTpnlueEkRRYS8qqcmq4ISZvQxivW/eJsjehzgvkiDXiwfDdixRA6e1JYXJGH1wo9waM=
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


