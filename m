Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24ED9CCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 329BD8E001A; Mon, 20 Oct 2025 16:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B2D78E000E; Mon, 20 Oct 2025 16:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154268E001A; Mon, 20 Oct 2025 16:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F34C08E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:53:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB39CB6D8A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:41 +0000 (UTC)
X-FDA: 84019693842.14.CE6D8A3
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id D58A740012
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=fUMwnpnv;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
	b=AAiETPJKVs2pWwQJJSUwEZ4TORPIlrXEpsV4FWfCHRZixwlF5EwnSaQBusSwJ7qqcr7DaS
	FMJIebtHh6yldB6/8dj24onsQs/w3td6QXsMQfnmYBHBMpkUy+D+lwHKNW9B51PQIEUk7I
	Q2mkRdgBRVeeejPOV7/NZNWx47KU1e8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=fUMwnpnv;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993619; a=rsa-sha256;
	cv=none;
	b=m3GS1obGnCnErZhFPArW3z99AQLmJpAdAJ3EQBi3CLsvOZlaYaDRcVvDeLvVfK4VM6o5H8
	PBCXAXcPkKZlTEutwmu/Cmra7XyCLxVlsTwwd1uDGb4pfj0KznYUDq0+sHidpNA0wUmzwY
	GDyf7KCkMZkzJSUuTLnbYhr7Vlxa9nE=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-77f67ba775aso6266431b3a.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993619; x=1761598419; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
        b=fUMwnpnvRBhR1B4Vok1nEuVBFmn/YywFcY4dAUTRcNWRbAbzh186mW6beKrfwiRmDx
         Ort3rRXjHgWjn7dfbwLojv87vtgHup5DoEXtkp3Rr1mEmdwdvi6F012yfbN2evsxwT/X
         aqfp0p0AYSZZy8o1O0L5gnmrF6m9Ps2PXHrwk9/zYQ50hh2dswsvBAqR3sdm9yP7bdth
         Wbp8jXSLxQEgh7YYS3L8OzRfd79jMi8KradhVVbhNVr+wYt/J3GzX9GO380M0RWMf4od
         5hhP6bVzda2PTZJYMUgQEtmszN8MYDinEvkkGFpul4ju8ywPu4OEXXYCA+0LS4Va2Uk3
         nbJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993619; x=1761598419;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
        b=aJtFmFyle8hcemknaMoV5CEvVPhMdHwGS4bsv9AJMxgZ0Ds2n4paNWdtWi/7KenvWa
         Q3TEKtliOTMt7Fdjsg8pH7b1b/9+sM0bRbOZEqKRzvg1xqpLHWJYCm8VxjzKR59mseMh
         xuUEWHomW3W6W6O564nE2BtE+nLdr5hLmCV3aPt7sBjLV1OmGOjXjfHj+wTdmd7nVFkX
         Ezo0n8wi7GFoPMDpngXwYZAL4B08fu2H1Sa58dnVYkxnQjAfI/RYHiss8/GM4VMlbaa8
         5cQSFqKWnMc0ZlopSI/1z11540kXQNF0sxH3PAqTg4IXRkAMiwB1CLcw3NNgVT78a6Ma
         M7bQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9X5vQlgey1Z5vmC5D2qmfcwRjRtbi15vp60BL8cRgW41uRCNhc3JlS+YnTC+sCRkkXAZv9qjNGw==@kvack.org
X-Gm-Message-State: AOJu0Yw14xKWxuC9LjQVbnmvkL+xAvq/6xyj/Q6KW3GBIbubtOurL76H
	bXVulBnG/CWRbky0uhYagqpJAWtGvp5GQlD1Ve4mqytoUclfTdRFH8tHoR7M5sK4yWQ=
X-Gm-Gg: ASbGncsTb7pXpXWVYTXGU0HAu13tB42S+P6TeFf/LrL5b4rxrRaD+l9nbRoSoZViYvM
	LvbRSOlAuycudYoWK2uOCxkA8eBl3ts+Q9WDMNMOyhicg7ply7lL39r51CTYqWd5hSg0zXqq+TX
	VcNBED6dvEXvtbl9E5h9l05b5dTXWHFOGNJp0AeQY3y3WqHDvmZsne6sv8yKic0Vf52Pe+QRNeg
	19MRIdix0qgF3KmicuISToFRPViF1gzp5MQDMyW6JwTjlQCZpi0z0/XPa5gyzx4fO5L7cEr006C
	SsxG70O3SX6Z5Pzg48YZP47wxwiJF81+CiE0eaHGN80r6QPbarlsJB4IadHpdvoZwW/K20gQcBN
	luibMr2iIozrT9qYn3r5/oC9Tn0BaY6cCY/5+oKA4wkb/La3/DCbsGqxYb3r8FMZZ7TQDZPpD8W
	CqZZSvlWj7YJgXVs9ZhlXl
X-Google-Smtp-Source: AGHT+IGL4wpVGpFAR6+71Q3uMu9smAAvPQjPoICYz6gHBaftPyajfTVLLzLP1i70rrv4AcCHkeSJkA==
X-Received: by 2002:a05:6a00:acc:b0:781:1b4c:75fb with SMTP id d2e1a72fcca58-7a220b0719cmr19998820b3a.18.1760993618646;
        Mon, 20 Oct 2025 13:53:38 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:53:38 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:31 -0700
Subject: [PATCH v22 02/28] dt-bindings: riscv: zicfilp and zicfiss in
 dt-bindings (extensions.yaml)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-2-9ae5510d1c6f@rivosinc.com>
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
X-Stat-Signature: qnfyoctgp5bwa869duor956nhema8634
X-Rspamd-Queue-Id: D58A740012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760993619-502159
X-HE-Meta: U2FsdGVkX1/YZGyMDkYo/9roLQ1NZgFraedU0vD9d6pLYQ3sxklLE6ckbHener8orzxVTQefxITn9D8XNy1aYEnCf+Zm25phbEYIZGp6OEUhX8HkZyRM4nj4JKgA+OKyEBDXZohtjTWwl8PsUnMXyw210lIlxHFEZy1LxBJIi5Ruzu6tlWgznKCUAGZudzSlqX8gJud9VpDhRDvBuShRCpNEaqctmw4nPY8nemAdaKawrVbqjfzOA71IMlDTlAAzpIm3fLobGrz7DDvIJabP1p9HhMV4mtL2O5UQMMbhTpiUIM1+kjVpE9EeHrsdHxKEF5TclVY7tYWKGDeuFnfcBAFJXShy5s+RLNOoTe+1PxUvcDBjfEl8+z+sQXtX1Gn/naYpJ3WwK0uMcxjBNOc3Wg/1PZ7c4oaAvsfsk51FxTuzA7xS4jLm5mEJiZzWES1WSczfSvbOW8kt990xjtJA+BEJLfAUObSVamfCnZYUZZI+NnkVxsn+/pBqn/BRZQk1Mwhya7iOW7zhhDMMk3Wj0Yl8c4vBeED/9r1Ibq0GKQTheTV54VD+f3XfETi2UKLIZm0Qd+ZzgK9y29bM7M7kD9SN69jMSPtQqngMsdpyOgNS7az6Cf2mqhntzfts5n5yAL4jsdHUsG4sXqV2ueqG8xyHdW217a5mRVqEgin6rI9iHKGlN7EElzXA2QrJGYmvY35oMSAHW6Qrw0NEuMesgCZ4OkZPpp1dY0t0d8g8kXpdu3uIN8OTxrF9gOelXNuhdDCtl7G6SBNJ47HjlqHdW255IlTBoXt1E0JVLDR/Yry5HNPO/PucQBBgyysk88f2AuCmjIbNACYXVB1TasHtOhsZInBOztwUSgNWTjJEi40lpam1tTzprGLCPc0LQClsTEq1IfQpf+OohHEjOTUNTAax+76PVvDJj+6Zr0nbqhq7f3wzNi/Ca1VOiGDp7qmANcGAhIbQsNFH2x/zjC+
 VqpLJPkd
 T3Ewr5hPty91fJh9PJYjWRwinntbH0H+lffg40iLanl1tOH7Tz0dTsJD89nb6qW3bWR70aeFGMcEs8qiSiCfKw6VswKXybs3Ty0dYs6fvy+v5oJOrdujycEdJ13t9KxLn5+xxOzE33sQy5Kfsq5cyjWifSyZzjMTYJXabWxqirpRLMqGs3Y/dceZA/LsN7Jpdtvn02mPfZ0z51vSKr4rhL/K/6zVCQ5dmr1ZmxfIsHMUjgGH7RMhf6q78YDFJ/CRtSPDnqJYLia5cEIuc9xj0AABN+SURO+f3/T/cW+rF3AiadXbeByU+3S0dJ0pjmJsGFWlvLZZcfkjTxOOPFXloiv0aZyog6A44rZDmqBniyypiAENlWmd0igox2HEOmoNXK3grKuQNHcAExwxrlqOa+GufCrbLkkgdvdxbjjuQODAFcDG9dcaCfNUwkh71A7m3StW+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make an entry for cfi extensions in extensions.yaml.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
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
2.43.0


