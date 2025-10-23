Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 607FDCCD1BF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEDB08E001E; Thu, 23 Oct 2025 09:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4918E0002; Thu, 23 Oct 2025 09:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B3F48E001E; Thu, 23 Oct 2025 09:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3308E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:25:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DC28140AFF
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:44 +0000 (UTC)
X-FDA: 84029451408.27.392CAE4
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3B47B1C000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=KB7ZKh5G;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761225942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
	b=MKxxAogObraNHvjkcSqOMlOFqjkx+T2fHtWGDhOqa+GnlBNeU7fxe1UzkChAgpJZ9yoMkO
	7QrctEx3S6Z/uq58OpEbQVCfyy1u/mqLHrMvWMVcHaApw14FjNj1qxfTxHOYGnf1IXB6KP
	ByZk67j/th7buDgANv8aHRCmWSA0rsI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=KB7ZKh5G;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761225942; a=rsa-sha256;
	cv=none;
	b=ZXWRnGerWAUVMzaKQZNEHootJVr4UeLGzzoXOFbVK9o/YDcBMqvrgXP9KRKqpq+vx7K96S
	x673wIWwvphLiEuxiMpjYVGMxy+uxkTJbcI2R7U9njPU+ImvHPwpafnJyDFFXN2kf5Vape
	JkqFmcM1B/IggvsShRHEZoQPbBgO4pc=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-339c9bf3492so1066205a91.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761225941; x=1761830741; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
        b=KB7ZKh5GfPbBGX/qV1mmns7eDELxia8cW+wRCCPfazNNgu3Zmw6ripS4lVF33+PXM/
         9WzJ0opw9Sbfgh4HZIyd2Vf3FQuMlbOY4qF4sErelgmNdBnsEk1YhzmboHSknNDDIaJf
         b06Zp7W2DekhPUOIzZqs4fcotOzkynw364Iipcr0JSv4cvbH6EvcAR2332P9VH6EpMiU
         lzRf89027+Iwlnmsy/CtAiSJuisF0SGVhbGhjRWGJ22Rq/kQr9R/tEtV6Mxw3ZvlI4Wc
         axICJRJ3+u+TWNbbNk0jNFXgKXZTZh3cdCQFHaRwxeVsB2wV9SjOzR/f4CwZFRJ/e64F
         rgNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761225941; x=1761830741;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
        b=e4uS84KC/svh+TFqBPLd+5zxlo0JMTIdSJRTy3aw+/onyzEHEaWH+nmS9fLejyrenb
         UONkluGfQj8CuMg+n6U+0gKtsgYwZAFpvmGMltAW/kLDHlFPxxiXSrJLuGC6hP5V1hgR
         8rUPXJK4dN9JUGu6af6gKYruj3SZkNKYA6HTCVip4TrxpRHar1+1QAbxQ3XZE5Q7eDeJ
         VRZk4siWAqFcYV+M22i4WJGzuwlBIL7vjIfDT90E8QkuRV03dUMPvQWmV2A9nKWCbDsJ
         d3yDoha2Jhr2adu/1SEoe8bMhAxKV/3SapWIWXOMz6fthPQWTLIuoymP8w97UC15PQjY
         5rpA==
X-Forwarded-Encrypted: i=1; AJvYcCUtZuHs20IJV4+4q7AtVfcalGtkIKZFOuhj5iQvvxBB0kLcPCYNQSoCS4MSMpmdlOHymG4viiYsEg==@kvack.org
X-Gm-Message-State: AOJu0YwxHPQqGo388PDi4JNNBqxn4iLA6yGb9n4b79O59SdwORWW+zft
	D2pMs56xDQ8GvubcYn288NYm9SpHu/oMOcA9UxuO13zjFxPSQApW1vmjszfzfzAFlL4=
X-Gm-Gg: ASbGncvC64ZkdwnHCnbqEVIikVEJXFfgQXA2SvL3+YNoa3kLZmmgM3LYB5mZrDqiIHg
	N85/USg+SXthIPeNXab8iJGoJ6MrSA537bpqnCXg1eifDnMHINkWpZFooJLgA36hmtbNM+DmMKi
	XfKfLuNDJfbCzolgwJswn2U2IQfzDzXOvhlSvOM2VjO3jFYV6bz/4aCKW45uWp77z8h4yUW9v+1
	oH0PqfF/aLVF2IERNegptmdEhPFNfw2PKO+nt+WjNchY/DHWRpSPs2rFQgnXESmvllFreWfwXFY
	WSQKAqqDaDCtXCWQGppuJmE/g+qb5S+UtCMtY2Jwcgb990l5gs1DYWMRY06vJbcV1V3XrJ8Dp6z
	g1ZEBZ2Q74+KwsPX+t+/uY5801CJGpoCD2KDcf6Zkmz1v/OvWF5rh/yFXeH1C9uaGaBK+nl5LIG
	jaYQGNBy0WsYvLIIRCz/ej
X-Google-Smtp-Source: AGHT+IGl4K3EWqXzwvKFEGfUV31SHiJxvtb202KqFHfU8YvsQJIOKEaNW7S6Y9DyIV9G23eYEwYAmQ==
X-Received: by 2002:a17:903:41c6:b0:25d:37fc:32df with SMTP id d9443c01a7336-290cb65c914mr349494795ad.47.1761225941004;
        Thu, 23 Oct 2025 06:25:41 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e23e4b3sm23432035ad.103.2025.10.23.06.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 06:25:40 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 23 Oct 2025 06:25:31 -0700
Subject: [PATCH v22 02/28] dt-bindings: riscv: zicfilp and zicfiss in
 dt-bindings (extensions.yaml)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-2-1d53ce35d8fd@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
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
X-Stat-Signature: fgyri4k35nkzbduynhqz5qd4ismgpkcm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3B47B1C000A
X-HE-Tag: 1761225942-160759
X-HE-Meta: U2FsdGVkX18hVq+SnU6lpFnvpt0or7MRdFQJynNc5W4xV9+3mQbvOxqSNj/i4PXaURcGfHKU2LtJEI+2yx5gKXjmCU7+yUGVWGwGSnQDhjt0vDUChvmd3arwQCT51Dyho6WdcGZDVL1eru18O33N6Q0PhTwQrCSoxARaLwdGXHWElxLOg6Xlu8PuAS6nEQxUviy24QHShNTUFokFfilvXIAH5IPRuL7dWs2VicDW/u2TujxDcJ49oHFmXUFf6s/tW6iIUp1FawC3BlXTsNGiONO55b7fk9yTXyUmzhdg9B8Lv1d8z/RxKQy1CIXnZGK5mMrUFp7oGzdVQuoAU1sfNEoYuHWc/A5lOqMpvIizLlOE37/yvHoxmCzebPg5LKEnpqJixVFUUinqxlAyGQKSViwj/CD/FcOJSV+WHMj7vNgeF+Mr9dmKpy0hhotaMnib2DLV4g7UQbpqBM2uav3XwfLqTxHcM9lSxQKI9dhcDfmHQl1Lwfu1gIZFP6V0+r7rhTnF7QQL14cCMsNHOE7DA/R+rtWqmK5XaaZYsMDZPDNZQouewIM+BwuM7SzIp+4ZxyIzbxsIBj68maV/yxanC5oJY1Ej28TMMLBDXMDxBc7T9kNLWHWVHb/O5KZMEY45QcqXYMvyfbTSPNz5s//fVzAU+H+vDkY9PC45d0dw6ZRctwNb5Drwv8P5cOASjWqS0f1/HE67e8DS4tka04E4rfHAIszLQ68Gs5f1RG92oH82r8QksvdI2fFc7B7MD/YkP2grko9PFxvgsQq0ssx1vHxf5mjWEZPtPmSoJfVLahXx6b2VwJj+l/Rxljv9gTaOJ+WygukLswuEVsCbmrJkxLeONvPRbv+n6dGo9si4O7QDatCVqFN2zRUK8BoMw7Spw2W9qpGLWm5hPyAiUFffyR833jw/40hWleSJRbPowYEypxdz9C0eupodi0ufmkgZMBDiDLwXeJ1lShcLHwx
 pCFqJRyE
 bZ24kSU2fmnKM65oO9TA+cQJJbr1jRXohn4pdgj4O1mVyarsxpyqj9Ubi8KkeChaHVBooVaBI1JYHtCQvivV5Gq/IWrLe6ZykGqL+0lPAq/xN7ewWjRlQutlMdv0/4ZHy4ethvLVz0ew/7zvLISnJjSYYbxnMgmRK2MfPo9Re/lajo4gctq0tDOuZ7gm+kyoITBDAMI3NI59McU3BtM1qTdCmyejuEJNVV5wsbmrQerhy3xxx21p6+t46ZCQMJaphtr9d4HTzzchtVmJj54MAAvJgc8TSnpfvDHm3ICUa4uBkmV3/vsFSgIp+tJ9ONCHbp0JE6RTZ/keob+QXeXH/W997OlyDJ9S7U0+2EV8N75sVdGstdlY2qKEMEdM6rL3wHNF3ZJ3fsb4I02+PNmXlt78BP/+dpDcrqnmIX1kcOKQpu9kenBumR5+lSp5XOgPL0Kpt
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


