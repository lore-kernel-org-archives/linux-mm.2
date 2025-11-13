Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AB65CD4F2C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6878E0003; Wed, 12 Nov 2025 19:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AFBB8E0011; Wed, 12 Nov 2025 19:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502B18E0012; Wed, 12 Nov 2025 19:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 222BF8E000F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D706789949
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:45 +0000 (UTC)
X-FDA: 84103736010.19.014CF9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D1E9980003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=feYpVEt5;
	spf=pass (imf02.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994624;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01TF3C3IWbmDJQaVCIvSXOwIY4WyGGy+JpyFPRSFpf0=;
	b=sm9fAW4OMiOWTHooQ5O5huugA5IYxiDGazBvRuQmV6t+QtsoRsJ84p+BeKpeRvh46yAaMD
	jyChx1V8NbDgRbl4BVj92nBfzLvyIqk0K7YXp4tclBSbweGNPti7f9zPYV4GyvREnIUWGA
	rxXRNWNtAgui66PNoqc6vionnJ864X4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994624; a=rsa-sha256;
	cv=none;
	b=sPrlAuWBSu4MxwJgl+shKXLOS4W8KjVxeD8YANjuhbk9SfK8RyEza9u8IVpRIpekHvKrU2
	cm1j3eMen3Od/R4czuaUGbQmSoys//DPCgCxXX2fBBoYIAvI+wizQ4AtWYlHfWfB5V2WxY
	WDmE+NbynoMXHo87ssIxemOJFl9r1dE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=feYpVEt5;
	spf=pass (imf02.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E9DF4375E;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C74ECC2BCB5;
	Thu, 13 Nov 2025 00:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994621;
	bh=B6oYBetl6TQXfW1dNsiK6ccjw9VFfFfmPrPyliUaQyM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=feYpVEt5T6Pt6mtjJ2lbU3mQ02+3hD+t3XYKC3ke4n79qNkv8EevgsZfxjjBoUohk
	 0cF9/zjyktU78jI7tzLQbKJ6WekCa4hMHiTYQSVD6RDD5CsnojJf5zurLnKF99J5WY
	 /zlm5soAE+eP41XOpYdN52gjHm5BwUATyYTnUUaKxfz+onSkAD5ocXHES/hpQNIJdn
	 iKWTYnQzcn05lmVCc99NMoiboaB0zQ/yAH9iIog0ds57/a/hiyhnaQGJbuefHNMXJ9
	 ajFABArm6CgOvJhujF2tSzAsLE7+OiQj/Ot7sV2eZ409DQjRijDiJ2r7QSI98ZiBog
	 W95PacosRmKWg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F7DCD3445;
	Thu, 13 Nov 2025 00:43:41 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:00 -0800
Subject: [PATCH v23 02/28] dt-bindings: riscv: zicfilp and zicfiss in
 dt-bindings (extensions.yaml)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-2-b55691eacf4f@rivosinc.com>
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
In-Reply-To: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=1500;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=onQZPDO/5PI+EGQWomoauY3V7EJZG9au2H7fkbOgnBs=;
 b=OnT/qV3NRR+X1tWh8ldGuMTLiLCvfigqvKHaNt+5sZqvMoTbXTa23m7SnLPqA3vEWfUvkZtqO
 Qi9cVcJvwN5BhFiBc3Ochx1g8K5SeWHMPQklKtSvMY87j+SRFEATuoC
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D1E9980003
X-Stat-Signature: f5fm3tuw4nyy41x55yu3ha8r9cdwzh3b
X-Rspam-User: 
X-HE-Tag: 1762994623-49806
X-HE-Meta: U2FsdGVkX18X+YTuNFso67lNXiFY4u76MN7Bnv4rmNi/e1qV+Pm8lrsATtERBkMrmGYrxBn9cPNs/N1cBrd3vldKhPtKGfF2N4YPSk1EBbTv7ZW8BCBTWfiONpCVTNHVOlO0Kp/wqWaDAseRxd6CHqAj3XgYVBkXF8MRHdaqJWZzwmqdgaw8x8y98vIG32j8vVFfl2X3TBgot3YJ18a8nbvW+9PX/rO2VKQu+Aso9E878Mu3phZjBnMRXZt7gJpU82o6pU7+/y+DmcbyA/KE1nSJ9RAMmv7r/gFlbDRXpqSUSsjD2+gKPK65dyone5Eof2iJ74oKLdp2BzXQBC/aKGNZfr3aAT8LSpRQNikioOD2wePsZT9/iWEBrfDi0zbrmG96T9hnFR6n9aHIH1KR6xWRZ6afYiK8Mi1y7HhBdlebfzNn1YlMn5IHRTSU3qLaKEAbtxUu5H1IRYTi2zGFKRJMhsByhHv8QZHJ8c4epWS/p4Da/iL0cQVCT55vQ9OKe33g1CgfQ7bkpytKarfLOwBv7lsLtakIrClAHqfqK8jH3rB4MXSXMwmuYhPCWP6iYxi0mnEl79mUYanAIewENTosoUXYGVE4DSNepArswb2OmZTGPVpgQQmXCdR/Sitw9QqL2RLHahqOFy1q3gmJd5whEJ7taNKNFL2mdmWFf21LQOakR7P2auuheK/07qk/mLAJL31I4iUWXcIMabj/kLqv5UgtjyBKexyGDrDv1ekPIX3ppeR3t09Y2L74wjW9UERJw0VPeGKXMmx+5aul/cxLyIPAJqBscFl2OFU0WTHzemgFAs7oCVziijgEXApl6m5i0+2rS1rzBPcSJqxe6zUNaVvJudtvJFjSq0sWK1LxfcQaVMSe9Iu83dYn8FQ8iDDAmSEcHT1wMdjmGhEMAZkTLgowywEvlieE4jucPjjIkDtOo4uKA3vXsR/szQKO+O94wkPbbEru/11vPWo
 UcsBBZZK
 PcGVREOv8BSb8oUrUhk5pe+rpAeQA5HlK22N0h7n2nrSrNDKTy9gMuEW+NZ0AK9xs47iv1w4gkJZbHC4XyLukuaQaHjgS4oBYSaRS326xUsJxb4cCt3b56aErCZaVlZVnCkpsgl8R0qSXp/A7AUYeM7nwbX6sCCRrO0H9JVSzhY8c0wzAuN6sujZP2s5Ee4LrrEAnkUHizLJ54JpyeRrA2VGidZFeoBbMYlyXlFhSG+9k8Ys1jHSWvRpzWJ3s+h8jepGYROcxssyoXj5nkTOygbjdFXpvp2tbgH0SHG/HKQHfezJg9I0QOnN1c9Jkh56HZQxQSTk+ONR+YN0mivLCgmUZTR5oy/f0HOytYD+lGBidfnt2lXFzFcsg1THgeqHQkc1fRq/ON96NRZDt0l8cbr9xgCFohQDdCIRQCOWh33DA307FYYqpLRlJ531iMxIL48JYJRDbL7Mbn7TMS2rM1Zi6WywFoHpbjB2h4Nx8tMre4MCXMtpK1FO37Xg4oB4rMvm/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

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



