Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3572D339B4
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BBAE6B020B; Fri,  5 Dec 2025 13:36:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693BA6B020D; Fri,  5 Dec 2025 13:36:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E73D6B020E; Fri,  5 Dec 2025 13:36:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0DC6B020B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:36:58 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7F93C02DE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:36:57 +0000 (UTC)
X-FDA: 84186274074.30.23BAC67
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id E321A18000B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:36:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=LlBE8loD;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64xLkyzyDt+G7LhAFS7W5T4PZ7pgqwloJjIatj/cxJQ=;
	b=xgAvMjAB4/2yKpy/cpiFdSj06U7FxxaVdujgNIOa2jpw/ZkYtV31qYPJMpAdIuZmSkt0Dy
	Fvh40CgN1Mh/bXPwGppkN+QsU5lSaDchlOTLFM/zU91cujmsXbcYphkn5jld5zzT2YYFs/
	obOkElHAclujvOrTbM1wEoQQC5U1Mwk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959816; a=rsa-sha256;
	cv=none;
	b=3UcvmE3BXB24Tq/LPo3CXzZ+o3+VzWACW7ePn9U2BVSBB44Vzc9Qy8us+nEvsMNWOuCekm
	MAcXBf0wgwhNDMXIaMrNwDhyMB9PDLgNKF+diQ1lSvZ5ny4iittqb1R4eeqawUG3l7zRTD
	NzgOqzMhAWCeUVNF2MIeN2fr/HHfZdk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=LlBE8loD;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-bdb6f9561f9so2313675a12.3
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959815; x=1765564615; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=64xLkyzyDt+G7LhAFS7W5T4PZ7pgqwloJjIatj/cxJQ=;
        b=LlBE8loD7V4fKmviKluuX71Lbi6H9FeHLsQpuXF3dIizhcQdFS1zuEhMON7iefvsG7
         NmiYcPxscLZGe8c6Fq6/0snxQLecqvkP977B2yXui48ffNzHnz644so73xK40Gf8yZyo
         Ec9zDfO8UshWkdrj6rS88cfJDF21lEKgJKL1OpBXjlvkG42qzwFmwZOxuowy8uFIDWMd
         XncnmjvnOExd5RuWwBXrDZHE3z9PU5gnwuGZLdqxT9DadAbJi0tHZ+w2xc0Dqvak9lnf
         wJkoxisWwk3sKLE2vNTuYI22C6bqjYV1Uy4PTd47uaNXqa13UaZD+3sDMllSfs4pYH+a
         IkhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959815; x=1765564615;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=64xLkyzyDt+G7LhAFS7W5T4PZ7pgqwloJjIatj/cxJQ=;
        b=V9beksHT32HWTy8kW0wNbwH2iNZClFwhropG+adIS0AI8jMEA/V2VAoPT2r3a2OckH
         Buo81OSLcyoWapkS+Sv/n/uwZqf+HPCPVgMqEzmgKCnbRQJGffQKxnWyOWQ3cyJryMK4
         Fyun30KxYlvkOvuyr6jGHG3Zj4gMRc9rQ0siA4S48KEs6rmPMvYh2W8cn6bV9iaEdWyj
         h92S641I+vuGt2siZ6iuckAways4rEs7PbauRaGkpV6D7dG8aeO1H3Rl00sAdQszy+fN
         HYvfxIM8RA1Vc/5NW6DZxwVqIVw8wwJXRcF8TmCclwmrhmJp9EtOla3Msgel+mWM0R+0
         CE5A==
X-Forwarded-Encrypted: i=1; AJvYcCUftupj+WCaPH4ycuTEkgWwvcNhNY7v7RDHm4JtafHuvrlhDPogFm+56jCW3bYz1KXCmFylIoIEFA==@kvack.org
X-Gm-Message-State: AOJu0YxYG/dN9BM22tp+x1nwGDYSmZIY8wbR1GhAvYCOUhrOXqAnBUTc
	WJJdZoyzimuT8Nwor3ojB2ARoLXG4zFP/ATqa2xUHyRx3GuLtsFXBxLTL/gCmit70Mo=
X-Gm-Gg: ASbGnctFychAE7pSPSz3UbGojZZ+gRFzg/fRxF+Ox3uUarnS27WUbezYTZzLw0CR2TH
	1cuZzsshEzWHMGNawKrXp7gzR8WXTEihozfQMQ/D9P4/ySVkJhf3MWhNH6ByZzPrDbgkHoeY9oo
	+xcz2LNFoRNRQwSoY9BksBaYsnOMHzAmBldyVATWmOZsov3pdP0H7wmRJrBaU7Bu6laswFEG7u/
	8PA7cIlgpgnGYV9f8uLYVvyL+TlSVKgEYnNGZU75p+YqH+Ho9qJwTiFYtEBIIon3z4lG1VllAMC
	ixXSnfrf91qV4fkCqx5DiHtaV5IVjI3NUKwkXnmfueqGiBbqepdg53bW1D9QF9YR2l7ESkHIgAs
	8xxhoCZMJ/f8rZ4zYmc9wAK106vtjTIh3IB7LlqupIvowroMdWyCLEExFfi20BT/L5jsYmdKJIt
	wDE6r7GmPPjQFSf/ZVSmev
X-Google-Smtp-Source: AGHT+IGU2sLP85/lJ1hQVHbc76Oe28ZFP7QFL3n7WXxEEBaxhaqoxKiUM68PA0g4YWByoTPd/kSlLw==
X-Received: by 2002:a05:7300:cc8f:b0:2a4:3593:9699 with SMTP id 5a478bee46e88-2abc71f7ee3mr78452eec.22.1764959814725;
        Fri, 05 Dec 2025 10:36:54 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:36:54 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:36:48 -0800
Subject: [PATCH v25 02/28] dt-bindings: riscv: zicfilp and zicfiss in
 dt-bindings (extensions.yaml)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-2-8a3570c3e145@rivosinc.com>
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
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=1566;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=vDVmmVGnkAFlfQ8sB5tmt1wB1lda3XmsatvedsLasmU=;
 b=FTcBrsY29zH4CGwlbVTm1o8uVBkzLWVuJZRVdzWSvyaLQ+YCd1ACncy30R/KVfqxKm8RGhxIK
 fyUsZ0gvoQPAEuPbkBJtPN+hiBZ+Driu1BfYy5W9om0F5sqYa2IMOjY
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E321A18000B
X-Stat-Signature: w94nbixdcrra3ocbra6udnjfsc94mm9q
X-Rspam-User: 
X-HE-Tag: 1764959815-240594
X-HE-Meta: U2FsdGVkX19t1p25GuAH/umQzMs/7LFDlP1GfKttUQu7ab8SHdtY+Eb2uYs+FXEbZ8eHzTnsXCaqOd7w8l1FQtBAPkGj1RngKJZsltaw2YDUTfYPqBOHHrqcqw2v+TQ+Hf+bI+nNFTu8Qze5YnFa4hwF8JVP3D2k2AlkED90Byja9Ip2fHUE47UrI+a8asXy7aynKfu1esPwMoDr6BTHFz9tBABcmMrva1AzCLhBAQEcH5xUWG3qCxjTNkV0bHVYuf0/ZjKVHINrNEWdysqpvzRalfieuFn2+ETrs1sqn4gkXk07MujZ/71jh0qEg9t653UBc/WPGp7bcw5CJvZBIHaYCsxBtIYH2iF1rkaUH4mZHswL3xEsavTEajjCcSBO0xKoIu/nTY8+oSpU1nwhMTM8EHqucC4jqSibO2JFNtAgCJJotzCLNgEg+oMdC2eaEKs/omOINVXeAllM9KGhLErW2j/YjX+E04llJv6NlmFwU8pVQMbfqgQ1pIYm6uArnHvEcJyUbhYCPzhIeIgR6KBCy+Xwc/WvMwhnuhJ0TssVBII4fSXQFn+HowuhIxYRiV3Lc4x4LjuHrqzmS0TkUP6JsKFUmRaNFyxf7OCic9nSRhkOtsHJSjvT3/gjTt3qDAe+pIg4plir6spRQwVOz90JtCgkC4OtqDj+NvW5muJaxYNEszNF8/Dq3u/jZJ0YDAxRXcdbkvPBGkGVelEeTHxEYkdlZ4xDeLiNjNi4TQtKNY4vezMvqMCjCSBuKmOdh7QoKFcoSNGqM1GZomJ0103QwxAlquxJ0lHsEkwBjsLeDPc1xANK4q4LHXlXHk8tWSjauORBZE97+dksbiEEnwObHSkM/dnozCjys6Cd1mCfzgHfJBkpkqr9b2SMFBuYeof9xcah40GZMW6nBF8je+43otJnEcsWARQOnHiEg4mvv8R3/poySCCS4AYFfGDuUO9Gbc8geyf4x1n7Iu4
 hBoCCbzV
 01bMs9fEHpTEnptwiA6qEsJ7DAClxv0AYQapYwX9/I5JSU2JiTj0rCCgAYwvQQPuARWfXFHS4LxRYS2L7+83b74g518r3yedUOmATnDV9y92VHcVfooXK4Y6DsHcDiqS6oVgTjwwe2i7k1LC+lMAgCslb8EGAmkFYs4LI9rCN2KcECwDimdI2vBGAHcoit1O/sbPGow+/rie52r9H6iuvtKv1HteYn70cqZHMNZIoaKZJR+mkACVYLv9GgJy4AqczwIu0nUaYHXLTVlEBLNZEpzUfNz+syVWxkPdQmnLKJWEPxfhmopcizUduSDKGw6Jt7NfJbHVjSiec+6q0Xb2N8qczD0tgPnTe7dM5g6vGxUPzQXiRfSDqC2VPIpJGkdToWOLImkvOjEOX3tFK2jAgvBimBTWZX8RFOJzdlF784UfqDihWPnRi19/P7P5Zi2w6O+fYELGlxP+fVkUjgLMr7pDwjEyf6+jiT1nmTJACm1t9IAVo4p5Jfe1Y7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make an entry for cfi extensions in extensions.yaml.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 543ac94718e8..3222326e32eb 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -444,6 +444,20 @@ properties:
             The standard Zicboz extension for cache-block zeroing as ratified
             in commit 3dd606f ("Create cmobase-v1.0.pdf") of riscv-CMOs.
 
+        - const: zicfilp
+          description: |
+            The standard Zicfilp extension for enforcing forward edge
+            control-flow integrity as ratified in commit 3f8e450 ("merge
+            pull request #227 from ved-rivos/0709") of riscv-cfi
+            github repo.
+
+        - const: zicfiss
+          description: |
+            The standard Zicfiss extension for enforcing backward edge
+            control-flow integrity as ratified in commit 3f8e450 ("merge
+            pull request #227 from ved-rivos/0709") of riscv-cfi
+            github repo.
+
         - const: zicntr
           description:
             The standard Zicntr extension for base counters and timers, as

-- 
2.45.0


