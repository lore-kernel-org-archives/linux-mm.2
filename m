Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49613CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666C08E000B; Mon, 20 Oct 2025 16:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E798E0002; Mon, 20 Oct 2025 16:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52CD78E000B; Mon, 20 Oct 2025 16:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 459C78E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:22:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7FFA86CA9
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:44 +0000 (UTC)
X-FDA: 84019615848.26.D5F1899
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id D4D751C000D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=LM0XOPYv;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991762; a=rsa-sha256;
	cv=none;
	b=CI08V2EyRrN1MBYiLZMk94pWAT7m9A90/5OpO89XNAxYa6Bwd53YfRukqg7gR+2r9m/Qik
	GICZ0p4MM+BNnuSGRYOrsWHWP1AvP3R6kMHmAbJjtl/c2ZDMBm1suzWAryNxmDEDHWroMS
	CBhXxnojQq6Djj8+mtw1M9q1cl5Zq9g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=LM0XOPYv;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5X0eU5n70apxl8FByquMpjWi58YW7xT98Nr31GIt0Y=;
	b=QIQ9JaEZD+Nwa4Gkw24dzi5Ojo3ZAaOkPXAK8xhgxF1w5kVlOqxNDslNZtfHoKj4zMj4bz
	VNPW3hjmPLQhe/261BuAqUIzLG0iczJVc3dI67QQibS1g8YiaWGNfrs5x3mAmcpjJ2MAGb
	GCPdKTHYA2utUfrhQgyJx6wfyJhBbXs=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-79ef9d1805fso4430559b3a.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760991762; x=1761596562; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U5X0eU5n70apxl8FByquMpjWi58YW7xT98Nr31GIt0Y=;
        b=LM0XOPYvqp4saW2ccHLuQ/GYuRFQ0NLsOCdnyieIiHLFRHs+4xQZ9Z5oIK8pbJtgx0
         paGOREvfrXQpG5MC027uRx5vJ7SnRBwE+28Kd2ycwK9pYSTWMS6QbZpcbUojF+HekgAF
         rN+nUXAlh8dBzYR7XIw236fkSEP3nhAbi1p8vMiKgrcdohvdlR1YxFqtgp+dLBroOG9r
         0TZatvMv93mC+GIkXLQAWk8FIOujC5qkHhD6ygRFp7Q83eSm7WzmVRasIhhRkjScF3et
         Ft++udvJD9ISlcjUsmb0tceB5hFgAkcjvGrAqGTOczKX6NescRkjpPl++vEvbLPsUFkI
         lYFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991762; x=1761596562;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U5X0eU5n70apxl8FByquMpjWi58YW7xT98Nr31GIt0Y=;
        b=Dj4M+a4xWa5WVvCAa8FfAyMsLeo+RYXKWaFC37DqgpSdeKVaHuBPVQFhDoUDbEoP7z
         RkrN9c9DzxqN42YFV6NMLwo/9sUAmm5Vm0b8GbCaqkQw4HINw6E2dmxKJ5IyQI71hUC4
         vuJnTI6C+qbwW1OPxLezAG5dON4bpZ2GKiOMhiwUPzJ407RCzk5oL/2S27/2LMeQjHLR
         st0FsimNoymSFR8hrRYy2ITajTYxveiByqXUdYuOQ2WbedYOS3YLItPckayxt1wy12UX
         8jf5FbyXa4dEPxX9ysdTXMbq7Hplqu3/zsZXLVFTr5jPGQPOk05FNoqJyPyCjmMkhxrD
         zfVA==
X-Forwarded-Encrypted: i=1; AJvYcCXwDg/3uZB33eiXv+epXOwiSF80a1N/45rNARftNMTcruXe0bb7++mcdRgM83E8nCVRmeWPxCIWqA==@kvack.org
X-Gm-Message-State: AOJu0YzBeRLjzYjh4UzMWu2YviHF7KBNZGgSkfsDB4Dppg4S64ZSpcSy
	p4RfMDG1GVBBSDh48hZ1OQbj1ylVWjuorSF+LhMAn5CDHCo0JREbNjI3vey7zT/3hVY=
X-Gm-Gg: ASbGncvO189v6U9dxl9d8UfkgWu7VF5kGYSC0rd8EM/lydvtW+Piw+3TJlypLDqGEMc
	vUJRE183GIdqP5JFUhJC9GnvTQKbOTWwIgBlhTPXC8NJbs5YRj5+wopRfBEvO7BgggqKbXjWHMK
	EwwE/7wFY1TZUtpX0QFSvSOuEzfy7pluCl7Wb6Gw1tDcnWb0Z8BPn/PQxopLOu2h2Su6BNTe/8V
	24ZhXy/K8pVTebBX14zihhZDETYebVo31WeapF3CDMFjrtVoogd5tgsNQQTkkCHgWgPk6SWknJV
	iTmRtvyK+hyPTFR8q13jdiBjmaqJw9/E1c9FCEMe7Qm2JBQdGzDnJruvRgAWpyxsyzJgv9MncSQ
	w0Ks6aY5CHdsVoocK5caKnU7kINywjW8XPWg8fdI0j26YedarriUrGK0fXnRNoShFQzHSnu3zif
	7WE8wYht8M1g==
X-Google-Smtp-Source: AGHT+IHEvyI4J6sPrBxVlVCaHky5xMHxaAzs+PZxvL80WqSoNdemSVWitLZhoB4ljrrK9RkRoQOjQg==
X-Received: by 2002:a05:6a20:4309:b0:2f8:4558:ad9e with SMTP id adf61e73a8af0-334a860747emr20871921637.33.1760991761685;
        Mon, 20 Oct 2025 13:22:41 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a766745dasm8443240a12.14.2025.10.20.13.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:22:41 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:22:31 -0700
Subject: [PATCH v22 02/28] dt-bindings: riscv: zicfilp and zicfiss in
 dt-bindings (extensions.yaml)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-2-66732256ad8f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
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
X-Stat-Signature: bzmw9u635ydhjgwwkuyxb5bw4gr3gqmb
X-Rspamd-Queue-Id: D4D751C000D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760991762-11254
X-HE-Meta: U2FsdGVkX1+qDgfaHs2TsJch2pIpql9gHBhV3VSvWFjzcPeBlmzH56aNJMX1B1eolpzYcWK0JffdH5VF44I7Mx6vKTq1sktFJajkIF5K7pl/glKhQId6hvLZ1MjdKF02dX75R9ukEn/87fvOadB43HRg/lZAV0sAbC2An9nfj9DtfszcrdTy3xajItLLITMf93GBn99wzgSuCJi71MhE0rSMbOE7gjAO2KoFroNao2SFoRDGP7RfPuKdFNIg7NN8Qnlq0PL5SvobmwYU5kDSxg3M/TP85ECdXyphs9ninr5eB2snDUM+C8RRo7xqtDVg4sv4QfYuo4oImYgKDmq0h8wjKBd886YAVsvlqF9cql8f1oJamYf6CvnrOfRMBMKlTeGAna6KZ20xwYjljhhKLhubwJ/uOtmY1Q16MijlxDXcXbhn1Idmam8mtSfa7jJsdE+Pgh0Jdt/t/PmmmJZbDcuCmTp7JnqS5x984euvKaueuoGd4xPMZ930cYZNLPrpBPSlg9EU2yRyei3mP03/02C3cEZwmk2Y1enqgCtaBmz/CByDrRKHqGKtKjGdlqdZx6CDOIRh9NZ5RxYMKsD0GJbLvtGYrqLJEVmGpgdKNl/RxfcZhaRQJPG9OXcAIRaN644N0hC4G3enM2At/Q3MAGE2dG/Q3Sa56IEUOPNFHSasUj5kLhlSlSqHBTjJa4BqpxFU0H5wHVbaJDqGxp6gcPkGPH5j/DR6WMMTezg15i6KdtDBDydPb9b0BdvBkgxcaKMRIQ/Ec2l3dFzbczCMp0zQgrp0Vrzvib9CrvLRR7EoKssJu2L4hbZsZ0oxE1XV8aS+8S7Yw3VHPcAJxd7NPsLKBhnERKfAFmBPmC+do2eE0c+8B0mEfXufZEgswQULOLJ9nwdioT5CvR8isy6X+df8UU4E/yhV188bx5UYej+GJkJvoZSET0lpF6amKA7dOeYPHivTZAH+AM6OtNc
 ErkDWdKa
 3lN/cfYn1r+W7+CJCjt34uWpgNTokZOxA4xkycdZytxZ+Pn7aR8awLvokho35AXqYvlFTsDe0IYt9oUM62TdQgyjLgPHmzv+m9h6T47ZPGpVpDrnzyG1sxbLbEBO3k95b0H3PSFqq15gUjmMFq/8b0XYoRfQyV81ypjsd79V+U+d3DTAWo9slCWI7GVg461BA5hr5q8aJwxI8DjuGrWnWvwM0MRtBlaSRqKkbpCsKysZzZR0n/ZHrLEL/R2uCNw1sEMJRAyrNZCwzN+Rdp5DnOs/u1XAPuUP9Is6UsA7qa6RmChxIBw2tptTzFzsn+ojY3b/0giyhs8oG1haSM3mio6k89PycWe2/ZLtVG+JiVF40UthVbQjnWXbUAVQ/c7nxUoP/jWD2O3mQp/FxLKT1q/XAWOkt6B98uTqOplBAs3JaS2gfrzrKlLzaEZPeqFNSYLEN
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
2.45.0


