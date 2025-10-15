Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA4CCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0952D8E0064; Wed, 15 Oct 2025 14:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D398E0005; Wed, 15 Oct 2025 14:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E4D8E0064; Wed, 15 Oct 2025 14:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1C968E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:13:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77E37B7803
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:13:49 +0000 (UTC)
X-FDA: 84001146978.17.60D09CE
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 86F81140010
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:13:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=RnbgS88L;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf09.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552027; a=rsa-sha256;
	cv=none;
	b=Ri/CFuK0/C3l/0EDJjctYntiQ/bSAUg+g3PcJghmjmlvEfyO7YSrPiUickEJV1c2KYA+3u
	GURHaWuEVERu2gqGiVBVe7iH8SPpFJXBPA6YHeQ42NCzhq/3dof4ok9gZ+uFEhmpkF1pPA
	fZUmnEpe5wUUGTcnwPrjBVD3lWOqthA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=RnbgS88L;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf09.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
	b=loeVy0nraISW9VcaNYvzYeGz4zb2t2otqgm7Q+CYptdX57Hvz2fGjXN/EL7SW65EM4TlkT
	tS+CwjA199P1SwOnF49GXZlqT3k5Qq+hG28NnfHZtPtKVstZ1tF6XmBirzq3l6YWm7P7Pw
	su3FE1bP9I9C4oHMM6l+/14KPXR29kw=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b6271ea39f4so4746815a12.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552026; x=1761156826; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
        b=RnbgS88L7EzfkE1b1zfTmsPhpuuRnnSJUkjmi1AhIN1p4nShgHWDVcOM1+FY3ILUsj
         1/cD3ibCkUjreshHmJkp2Nwj1bid2the6hLCBj5sZjISD8/f9qbErX+FK4OxAP0n8ZOu
         3ZbS5VLxcuKHQJUMKPuCNWgp0nQNykuc3ioVhqTYO0aLaZYd0sfP6NEAO9fF22Y52OHq
         nh9PzssqY+nLRDL8J8UNLzwo2tg8H/NdmZ0EbErqFa723nWCyUL0wNq69Na3KllxdEWK
         1GY2t7htXAyWc9Z2+bmnPtS/XAjiUIzEN8MlCCwoIDPitV8/L26C2UuK/6BfBn++cTAS
         SjpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552026; x=1761156826;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
        b=dwhPhlBsl+xB4BJ2rJPosQgqCUqJxRAwzNj+5TfrgsT4PfxblDLj6sPgn+7ukoVlFS
         r7t3xPf5lx/gZF6/f/fzxGtdtNBQYhrMphgl+m5WUka0Qd3LnfdXIawx6P8B6D6X6rxA
         KwcfF+ob2+sVJzbbv8T0fR3AeJWUXvhljjYGu+Ld9pGjbG7y9bN+N0+jBHOWjJVWt+zN
         mtRj7aRK1BUdn03oT26VPztszXz1npN3q0Z6ViHdmpI9amJxvs7BBXyM0vkV8pevLQ5t
         Cn7vseR8f4Rkmu9idCUjcCXbh0dvm4zVSeochfbcBug7C7tCCxzZ4yrEYiDMKczjOcyR
         9DsA==
X-Forwarded-Encrypted: i=1; AJvYcCWOms7qVMuOgNceXbnGRBhtbgHwkcnaOsPg+EFoKMBUgq7V22SYC7tGgIezQejW/ZtsPOARlXw5nw==@kvack.org
X-Gm-Message-State: AOJu0Ywa0skv1W1aI2M5vh1fm1AWGQOA/bOcKussX7y7yoTZrlBXd3n+
	wbZW9HHQFMry76lIgbtLDORxgo+Ti4pVxl4vJX2HtzK9Si4A1YqS1DYYlnAc8dFqdBoYnNcGQGy
	o03Aq
X-Gm-Gg: ASbGnctsxB+2djg2llircpqDS5f7FH+2xQxyU22c/YwL5+DigBitEtwNT4tPG8vRmb4
	hrGAxVi4m2nLIM/5mza0O3HgoE343gbo/5VPKl6IUI0RuTF2hJh4q4Al6HcMz+MxoS8CJyBSmNa
	+93+w6RrL4Ppw6dcVjnTLbEj0jZtWq5sjFn2uHx+49gmrsSCfaWPV/W2HevJzZNEBOQtZCg/+WU
	Tknn9j2CHiRYv73b/oFxUuzpmnfIpbzdQIDhfOaYKPH12uZO5y8FGJkZRVABBQFKC+Z7x9XeWvC
	SWNFz8b/E/6GCNXzKtAv9UMeUfCKe5hv91kWuD0MNwrkpHJmmLXjO89gODWTFcqSyhh7J2uiqkn
	ZdEI6eQI0Bk5aBV0Qu+P7QJpXgZ/SN2FEhnUlDms0r7y9xLwFFLo=
X-Google-Smtp-Source: AGHT+IG5lE0uCP31F892Rhz+3o+LdNX1Rw5571X/JjIijPM/WottLx6odEgFGO357kvJF6BtLvDxeg==
X-Received: by 2002:a17:903:3c25:b0:26c:3e5d:43b6 with SMTP id d9443c01a7336-290273ef107mr347052995ad.32.1760552026115;
        Wed, 15 Oct 2025 11:13:46 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:13:45 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:34 -0700
Subject: [PATCH v21 02/28] dt-bindings: riscv: zicfilp and zicfiss in
 dt-bindings (extensions.yaml)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-2-6a07856e90e7@rivosinc.com>
References: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
In-Reply-To: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
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
X-Stat-Signature: 4n8e3x9dghxrkh53w83uwsk3u5tnxfpo
X-Rspamd-Queue-Id: 86F81140010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760552027-568786
X-HE-Meta: U2FsdGVkX18aU1kquSry2RUuGgQR996b7sj46oVneHu9LT6Q9gLvMQYJUtI3ikVJleQvPAuoIA40ksWkgrQRYfFeBXy1xegyJzNSZzNxILIRadbzVAznXEWspykYc2geeRrU5YnEVCUux4pqty0C5EfMMGCjbjDGLveK5xwOzjMgMVdss3vRoSMIGtAfqMOYzoAq+5dsg8GIck4mIom8u/4oVEXwhWhC3N0k+Cq9KnsBeGwoNpYxj+zeQKW8JblTbj1XPwmL8LR57kNS9D6uou+ghu/je6Hypbc85JxVxydDSO2+9396B6m7oYTpUmLmlOJoA5J7bScgIzqQjXerhxRtOeU42lo8nfB3ZgWfpkch4f6EJVe3mzOZnSzSsphmpbSXNCt5ATM9elfiJ7iRPc0fv0Hkseck1VVpjexujiLdYLtLrhL10eoRZqbei9/YZnbW0JkvOxW0IXWKOHzLIg4XkzBbXwIvmF/LVrIhTadCGfodQ6jKCORfCTNqYfEYOntrcvc5942azg0OJfsWOY8mhN6iDvV+U5h3G/oNAetglLB7yYoNWJXhXLnXBDsjq/MsXgfzwYJvpqfgecjvDr1ozLT/mBONaiq3zSFU0JR0m9EN9JAKvwbF+aCwct2JahJPk2GzOYJFqWwy26LsNcLLVTnmFhFQgaCwl9is31zPobpow2czvMmBkdrTR8wG/EfN1VdpHz5wy4zdqnHbG70LI5vTpJRxKZ0WoytmyQ6A9l1y//VdlMUBuzzcZbH2A1pzD2RT0n8eoumNFXcl9NWj2+yHw2QC+N2rhKxlVkRQBff4XjaneHvGCh4A44s+j0fxgF5N2tPt4RnTIGTgXPWRALk5Viy7ypgsRmCEvvCX1pPN8RP/TDB4End0z49vdUSAV7zKGvYZsTQI0iFxUIISWr8GwcWB3k7N4LOrb+Cl2dlQG7WTIgYUj/yAr+knVaqzlepiaAAwK6CIfAe
 1TVdKbwE
 33MMrXm+WauqBhJ7VqwDhTZVPp35v2Uu9BXp0IyRxcWzYWKf1+W9vbufRnlMf5V0qS/LwUtjza62DKSfOnxrn63H+c3C/SFL5ckICu9ZSzvRTpnZ8YRt12moS8f40VZS3Lb5Atu6lfa4jRiDS2yJwPO6gN16shotilERrxfF5SLWX2YSnbwlfRXWsFQdRqZKeX36KkoUXaSTSycW1IcLzX8YWNzCVt9WdRc1kZVVBnC1EH8IzVllvios3phPFom4ZTVLHX1tcOBasgUdS71HVw4d5G9y4U91/oEX7nnpLbZOmmJH+fB6tf7MoAIRLJG6o1Jh8NIBfTO7qQ2+cB2DHFu8uIe16G9tMvr7RVWNsvMP7WRsRwoDBLXdY4Xb9s44xsDuu7/HQo+YykSFxRcj+wyZXLThe2aPQYWxJsPFDqK1UdklJHPD4vCLSeeWrDgs8empk
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


