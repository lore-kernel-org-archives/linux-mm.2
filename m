Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA1C8CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 23:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 152158E0008; Wed, 22 Oct 2025 19:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1021C8E0002; Wed, 22 Oct 2025 19:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70248E0008; Wed, 22 Oct 2025 19:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D57278E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:29:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 895C7160919
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:44 +0000 (UTC)
X-FDA: 84027344688.24.0523854
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id C2722C0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=VqiMXmbk;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf10.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761175782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
	b=woAN9IfTGKkZd7jPtC1Hqa7IY5Ghh+iTwwZiE3fguh+Hw8iwNvIBayrYZ/jZj9K/INlxgC
	QyhgWg4Ti/xn2mGAFIueXcSEuJMqT4kBl0iw+jDGFwJ6GenEnGRasJFmjgSCTASXCjL5ne
	rjX2Poimhze7vME8PpBiAlEFPcAkXg0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761175782; a=rsa-sha256;
	cv=none;
	b=QEKpNj0unfkq895gtPVdIJZ3sDz6m5HFAEiUhFNWjNIF/F7lqSvxggZaDwHm3O0pRctr9D
	hZGNhXK51mHJ5VSINzeExHBY8wMb0hVfuL2f7U89JrCdhpqRkpSJ/jWDpnBvY5PgW2bN0E
	Ddl6eF0k8S2nec1/SphGN5K8tuLLtKo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=VqiMXmbk;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf10.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7a2754a7f6aso195000b3a.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761175782; x=1761780582; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
        b=VqiMXmbk61+ELCa0b7ryPvwkiMFUIhoyDKF0dM0NQ6rRrQjjprvWbyXDG4ZS6S9gBY
         lAwoDxMlqjO8WCNyuCcfMB9ZLC9+8ibYmNOTOxlPNbcPPpRbAYTGapNbjvdA0Dr8yJUj
         qob50pyObOGa6GfAhpOdDq6GxILVoEnjYKLbBTtIiOr7UB4qzHCvt2wnDdll3GYm3cwH
         utpcaLS0FPR/0/hpKYN+sfF3J5yh37Hn+sGBR6QMZEMD++JO6TU8Zz7FHqe/8LkAjoUK
         QKnDABpUd0jl97384HrbrzdzkH2zFk96eSVfxANn2bxtbamOEOKRLnyLn4bSAZqkpZ+S
         ge2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761175782; x=1761780582;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
        b=NBuDFyBMoj+GugmjI6VAHjE7jANZGK7j8OW8x0HJCFYprJYiYk6iLarENEd/xyrkWy
         vLxJEqvtA060aNBENFwEbxcIOOpjfBr6nY58bFZC++KzE1pHk7KVeHKKutGBQlmJ2BDX
         BygdTwkfkoUvsf6gptxfZWCgU4EtEGumG3TuRbRfHhyJ93IR+tPoS+81Os9kx2qPLIcV
         kUBLX++ZlqpFG7IPZYWhTeNthHPQtU4sa9sgxxIrWv0/IPyRSO+M5qBj04XnxkoN3aI7
         Jhabp0ok7JRbSaPUM195Ib6f2Y/nlWoZlkH2cJ5Kn2a38MXYjK/iA8bFvxhNWZKC1l63
         hygQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPqImEV4D6OFRMSzfdFJB7KK9/NUWQubwXSECnOLUOaIaxIPAsQFOfKKBNRIUSvibTd/HhOxAZ8Q==@kvack.org
X-Gm-Message-State: AOJu0YzL32y6HzjBc9wEPoFdR67Mri4q6M4Zk/hEabc1htYS7RcwQL1q
	hrHinZ5VLcV41oQp1TY0r9aVNlrBZq8rWriEm2v0qkLHXPg+kwHCaHEjGH/YUEOYWkw=
X-Gm-Gg: ASbGncumKtu3cxpkb7UBH84AnXr+uio58nULga/U48PVmXZXVRXKky/ppI5BecrB/Ft
	MXV40RO2euQe2LDwtWBTVwOkunY329KBmXB5yvrJ2JfDuvwOkCEOhbCheHCPBJupy+nuE8Ihiuc
	xU5xURTHkRbYtD2w6khZyTonDVpbqePRtF00q+5HVgutTcvmEZ+9uSw0mJJLm56Cl+OrkIPHSLi
	XcknU4kStwm50P3NzetgBv1jZF1x4H7O/Je+w/ihJd+LW87OzjlAPYeG4+7wRE9BIBxdq8ORua+
	LGYDr/TqpXgtCuNekMldNfUQjed2n3hSW39kFZR0snCGdqt/PUkxVEqNdWyiH1TOSsuwYqJJJFG
	16gNLavlZ2mfZlRhvD4CzZWUxmpATYbojv9es5Xc5mp+U340JYpomKq6NTd6A/6T0wGzl26bly4
	mSR4oqaCOSfw==
X-Google-Smtp-Source: AGHT+IEmNDRmBGQ90oJZVfBuso221N4gx1WrV0qlXlFna773Bu+yBYH9fzM5J7wk1l162T475OZz0A==
X-Received: by 2002:a05:6a00:21c9:b0:781:32e:53cb with SMTP id d2e1a72fcca58-7a220a56abcmr28815176b3a.2.1761175781543;
        Wed, 22 Oct 2025 16:29:41 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274dc12b2sm392646b3a.67.2025.10.22.16.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 16:29:41 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 22 Oct 2025 16:29:28 -0700
Subject: [PATCH v22 02/28] dt-bindings: riscv: zicfilp and zicfiss in
 dt-bindings (extensions.yaml)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-v5_user_cfi_series-v22-2-fdaa7e4022aa@rivosinc.com>
References: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
In-Reply-To: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
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
X-Rspamd-Queue-Id: C2722C0003
X-Rspamd-Server: rspam02
X-Stat-Signature: x1f9z1kqo1d7hwmgfgxzj9spfd6qa4oh
X-HE-Tag: 1761175782-892724
X-HE-Meta: U2FsdGVkX18SOtyJ+/zwxyqcP4sKsu97zcny+BOT7/kR5WNKQ1fkDQAEMUlSEng/DhN/4l6m06AknJmPFPyI2kd/5WPvF/gRfg+lq8YElNfFLDoCRtMsNBXbGGL5zw/1DXuW+UllUxCP5aDrzs06ycessm8jxrDfn/nsWy0hutOhU/MZ4pgLBthZ16Yz8PUuHsQEpkwImBArdBw31inGdHJDmbCfTIfv6j3nWVB+nHhOpWyGmR2FTNHbMWH/ELiOpyCNI4k8V3WvQN15yWGBupttc0aeip9crLMj1Cyf30yLGQcayikup4e+C3B5h5ZnhTCjwOnh0O3tVQTpHSH1wQYSl6u65Ze/hyR2eGeVNisnOvB27vJaJKz8LqNQpO9sQ4g1w0F4TcizsnFpIrLsNugRb5QhMNKuxHxujWeUCawdYPQmwulpmiSC93bdf6V8Ynfhj+Jkft8S6PT8tCfOnhhRljiJkvrX0/oxoMlRhJRriaUU4ipDbN8s3BKJup0FkZWxC4ftt3rYbpJEbCEM/t1QNzuKgI2HS83THSk6YsUyA+mM9MyCJ1fWkdEf5/jaC/Ja5Fi0lqWF503M+6t6z6F6+OgTIXB0IyrTWr0wRcT1ki+eUtAxegW521e1GFgZSz3BPdfa1Bny6OEBh3h8MhosqGPuTa1+Sfp4FhTzFccVyam+pExbq1d5g869Pt31UblfqUPpotZ2HcKb7V8mICM4QLtU8uC33mWriLOB8nysqoORKLA9wCf/Y/bpmhABSATywSSIon0Sbx3IFjAhLXRhHaYV57ngx9boGRkkIdtaMNuFyzMuWB40S+nEPm4MF9ULXsOnsT7NHoA+Ce5Gt4ZSBWmbjPgMpfm7KwMUBDhpCF9M9uKM7kPfbADs95YlwFEPVN4HvvdZN1AM0chIAl6UF9EXZ0cZCvR/NxUkCllbUbQ2AaYfJkmTHlcnQjiWxlbdsFhnyoZTRbJ1RZf
 trtUJ+0f
 QATlF1/RoV7iECt63aSvSVUb0CdBFMn7yVgOMRpKWZZvTE6yAqIMOzFsNzvTx1UdofNj1
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


