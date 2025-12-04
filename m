Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B017D29FB2
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716336B00C1; Thu,  4 Dec 2025 15:04:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7576B00C3; Thu,  4 Dec 2025 15:04:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F376B00C4; Thu,  4 Dec 2025 15:04:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E9826B00C1
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E680387B2E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:05 +0000 (UTC)
X-FDA: 84182864850.04.1F769FA
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id DC79714000D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=HXwGDsfc;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878644; a=rsa-sha256;
	cv=none;
	b=vKaq12cKMASRGrQ65co29N2KecfkrhRipdsYnAySY+Bg9BWQYVfuQkj97eeXerIDLy5UHV
	9QkUfunsq1IPq+FZ/wxHaAFH+UfXZ0uFA3KYFonzj+RGowbAHeROYpDwLEbXMKu99AEHE7
	gzQ64NdH9TF2WsBe0RH38vOJSCn2jl8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=HXwGDsfc;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64xLkyzyDt+G7LhAFS7W5T4PZ7pgqwloJjIatj/cxJQ=;
	b=kh8D5WWSk2DuXEeYvToJHuq8EJL03GZ25QthXeAVCz4m30eNl8jfmOcUBCrHB9Va6JQxHB
	fIvmOQvW0Pu46IXYaXVppXeqq4HKxaBOntmcBK8XdlG8Y9+xlUlsGQiDMgDsV0/t07FAEe
	1HDFjfk07jD8AQqIu52VFJlKfSwuPS4=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7a9c64dfa8aso1145834b3a.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878643; x=1765483443; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=64xLkyzyDt+G7LhAFS7W5T4PZ7pgqwloJjIatj/cxJQ=;
        b=HXwGDsfcGFPVRv0ZyQ8iRLgz9Q0lnfx0h+l4eN5XLgy3gqXBSRdBYisAjoQAV6oE97
         jvC/ymHfTsnNo6Z2sV5nSqEpMrhYR/ZHgRD8/nqmK/EjLcqoRDahS7Eb6HJdtRVqb23o
         ZGpag5Vo2IWLK6A6iPtiVnztY8wv1UhtNEooE44NepDXGUe6kn74HzBlhQOxcYXSIhFa
         ePiq1UWkZ7IW+Cp4S+bO4ew/EaIde86l+pKRwgMUqc8SHGhjzEgSgvEZ/gemJPoB3X3n
         Zl94A0f64GCkLJU4ENbA+PKfohMv9jIXbuFpJx0vcD4cgC9ACB2+F1sIkTLR+L/fBMdY
         agNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878643; x=1765483443;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=64xLkyzyDt+G7LhAFS7W5T4PZ7pgqwloJjIatj/cxJQ=;
        b=fMg7beYTC2BD4DnF7RPKeNdVKGEGYkQn7Xgbfb3muJJrp4z8zQTyMMfX9rs1epv463
         7o67WQIB5fBlgUxKPIX1MW7Duw1edyVOweUmfjD/Z9DEmlxtcRHq65Bpd1f8dF5Ql5Kd
         oTBam4oAAOgFCfMs0HqQtw+cadPI0W85BuVNvlphXpy3kkqM754FNeNzQ95R1YkmNsRF
         ERcxD6C5yooKJt7PbwIi+e+eOnNdHZBUgr2KZe2q+PKdOAcRNQDy6f0mJX8Ht2O4CPo0
         ZpFA3RTAmC235QYJmlvDD3oT110RUV5ZGZnKQve3WHdUmY7QfNoMe6hqhRgjipqYk7dp
         mgyQ==
X-Forwarded-Encrypted: i=1; AJvYcCURYNd0w11vsxPiS3/EOWue9mXraC4Wp7h1fxvn/iN/Sk2f6hMtSM6ZabGbYIw3ju0+QdOoq7r2dw==@kvack.org
X-Gm-Message-State: AOJu0Yw0jqnQ6DYaCRHl1+X+R68X1w5omAGTRbaOzG85FcepsVoFs78Q
	UPV7qZb+FRaQgb/JUJ6TmotWr4A3E7WTig3hzTR8mTpogqyjN+RVx2etCa2K2jmk5hM=
X-Gm-Gg: ASbGncuFGVk1zXQtemC7CAmL0UhJN5ISfB9pKbNEbP07hkfWGIUIdDG7FsEa05asBrx
	hNdbXFKtbCiWCJL0K/aoM3EJ2iiQYhdZHBRwQRmdpm9sNg0kMFINGhrW7Xj77bQiHggYsRefiMp
	G9t4jZOQzkWZCB7oxGebql8avgXSwR0cfuxYl3I1McsqBUjCgB9M7b3RmGjZ5MQo6nMBH7Pi8zL
	5/jNuBdfJoiEFvMVO7AcbKR2xdCTU8yWDzzoneIpvnw1QpLWtWxI7ovV+7Z5UuNO14GvA+L0p71
	wCPiyLyTrUTR7/Fvkp4lUy2VEKl57mKhIisUqGlZwN99cxb1UWvpvChPuFtCz9KGgoRr11CQYEc
	bQVwp3Oz+YbivEHqvqt0vBsbPlhylMM45crc9SA/NSbxP5rR3EVSNRQAvs4nEqTCi1cilgf3Bz0
	Uvqxxd5WtYTmXNW4xwlPB63P+BuEerMKk=
X-Google-Smtp-Source: AGHT+IEOhZnijBnNdOdOsVk4yoGiswhZ4mB9XbdEcOyRSW2OHSL2c0QLsA8JlQSctaVi4Fp5PYAbjg==
X-Received: by 2002:a05:7022:3c13:b0:11b:9e5e:1a66 with SMTP id a92af1059eb24-11df6457d6dmr1963954c88.14.1764878642636;
        Thu, 04 Dec 2025 12:04:02 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:02 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:03:51 -0800
Subject: [PATCH v24 02/28] dt-bindings: riscv: zicfilp and zicfiss in
 dt-bindings (extensions.yaml)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-2-ada7a3ba14dc@rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
In-Reply-To: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878635; l=1566;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=vDVmmVGnkAFlfQ8sB5tmt1wB1lda3XmsatvedsLasmU=;
 b=xNldZE7ggkUY4ump/fCL/1LsAC7onHMyBUwvRbY47zCFtNRuwaSA06AgdswhMqiJ56F1mgWuR
 UeXTJ0gNxD5B010/yIJ2qjv+tHksoFDtsdJiXEDcLJhe2dg4MXf1BtQ
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DC79714000D
X-Stat-Signature: mj465wq7qx7krqizac6y116s788iirj6
X-Rspam-User: 
X-HE-Tag: 1764878643-458997
X-HE-Meta: U2FsdGVkX1/zIkUmSUmxSdUIZVwS86ztoMyVNIn/HA9pYV3thVc6HYXNx6UBC0uKWUoohXyjYmgqoQiGhcT+s3RJfozxl2JmsT7lE1ImmdqDL/FyL6z6Fb4qtQ/Mu01q0jiuHiS/DZC/15I0hhVKRJnNjEOL2dBRJI8pUdjl1qSaahElGlUFQgjQDjYx2R28K87whaiSIcePBsVVD5S60GQD+K6ZAV9zzpHI9O3nv/8mF/toyeHESV+OOws9Sma+uMni+W971AA0C6RBaVuzBL+0pLZkQ7pUAm+nYwnxaaKjCmf4A4p021Ybg7T1VmJuWav2kR+rXobzVA2QpCQ5iaGkkYZj9qotGpSSU0U5XZLfOQV1XHAL5A1eJymxe/WR2jR1EGDjLlFqpm4aqSWhuPv9smjXflcIfZPp+QeQrGj9IdtQ0xtpMNGUAQgNP+cTg6NzVKuRN3P00EsQZC2Fijxmat3R7OZiOE/vMp4u4ZGjQRhgYQBHqlM/0yn/nY7rsx/W0qdDCn2h5l75QcboX4H4g9l0J5pT8s33ps+E1xC7yjS44yMvjieDknKtI820ZWtQJd66c4CKnwzEte7b8ebNgaVedB0MCqCaymhLIaR8xpGqJMXW9DZzWbwdVp59CTj/vNIxuaHl8eRTGob295Nr1ulZxHu/KS1Q4Zi2WoLNQrv8gtOnjPfY2CwqsNthlgxTjC3LHMMJraFR5NwbjzqBl1UbGWTAQDUyk/Ja5CcDGvhG0j7LM92VdGaHWv5yLNt+Rs9DaRQ1kL1cd7U2zH2fDmu8Avs+5x82AuLGBzF4t7WAdoxS7f4hvriQQdEz29zaQOLsD30ex6ZxLl6OFmVTL3+N13fEy2dNlmhi4NdkZFDj83eZhcxPA0Ebkn7mePkNkL0KmD8tAGf5CgOwdYDBIxr6eOIKQq9Ix7wlYYTw8kcrakk3y3VZCXxLjv8/AdbTGSYMzA7R7MtsFa4
 Bmu2iSXP
 TKSA3zcTBvHelkFfiHvEv1VsjBuvp/i8vXZ3sWFAtXuHPW1vHi5JvvDpAOYYLd5XQZNsS0Ub1pBKrG6XZQEtSBsq9GWOcRc/pvWcbjtXxzRCNDjBvSmf5GJx6TMy9+KTB50DJvLbNuNbJN1RMfWm4XvehvKZ8SBt7IXnccrFh7p9FqFvWUptSmGdDhIG01M0kRdF9SWQ2fuNbkr/p3rkHdG7Lhu7Ta639jnfSyzasNmIc0oCBpZoTAKND+ajmbaF1bbVqS99aGSB1scZg6ZuKkAYD3Ic8F8ULnAFkIib1eGKOGbHia8/Ag0xH4eAzCEIELG9WCLVA45HI1gNQTFGmMcl8zyFpkfx7C7AWbWU8OcmdCc9fc3knDdATLh4uKc58Mg8ZHXbx8xF2eoPWH4g4iL1FE/dkfqG6Ps3xJxukIvQsXIQTmuePVc3tBz1XAhDzAfmi55/6RrDen0bJd39YYi3UxamNicBqxeAmqGHql2CaDTitV1rxrnJiy3q4r69Hw6D4Z2cVJYE3wHrSwvlXu+PL9+b0nx0hMSmKibEJ7UWWiS+KxSgWtOJHVB7gafNAokwfLpgzaahY4qc=
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


