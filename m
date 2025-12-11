Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AC64D41D6D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6334D6B000C; Thu, 11 Dec 2025 12:21:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56AFF6B0010; Thu, 11 Dec 2025 12:21:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4D26B000C; Thu, 11 Dec 2025 12:21:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15B776B000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BEBAD133A1E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:10 +0000 (UTC)
X-FDA: 84207855900.18.2CED060
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B0B3F1A0016
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PaOU5q/4";
	spf=pass (imf19.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473668;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k096bzoeNIbJgTxwdoDjbWsWVyg2pNFcVSFhbME6zF8=;
	b=nLPCa9uI2F5rEbOGFWiviCu2J0IV54xE3kePVdTXEp39eGq+MSVkQ5sMRxIS585OxZW1so
	BURKLZ7enH248Ws1n+hIxU5l2W2vn42/Asyia5vy8joocrJwsD9l7qOm0wMuX7RXgjubwN
	3eSfkqLM70ZE3ymkKDsFJzvfN9Mz7g8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="PaOU5q/4";
	spf=pass (imf19.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473668; a=rsa-sha256;
	cv=none;
	b=X8H7h1lXmHCwkfZhmyZ/71vFNx1fCkB0gbn8u6AB/mrHyn4qwykESO5x4NXMipMTIj2lTE
	rBOw8E+ZvTdTSCOHGaG5aKFrshJvz55vTqyevWjoUhF1O2niXV3INw8AAEPoTeiAs2rNzx
	QhrKgG/SaHPAJ6X4Rc0dCHinviFaNNg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E097F4443B;
	Thu, 11 Dec 2025 17:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82175C2BCAF;
	Thu, 11 Dec 2025 17:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473666;
	bh=SwvYyMJ8jltPo6WPCQrainmSZ0rXsiaYOsy+DlyS5P4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PaOU5q/4LHkBxKCrX2o2OkthmS9Rm/gPyd6T/9GsIScaoD8xO8aVbWuRsZ4XEXXBl
	 3ymT8j1ye7Mju2/xcya7luCFJhfP7MYWDU6ImVJmMEwGo+d/pAdjPSEvKAOYkk/SHU
	 43cpkQaYBUB5KqTBfJRl1b8LfpWG4lS6CbRsend0Hz4LqsRcOFN0SDqKFfJaJj0Grn
	 IZMf+CkbQNgbedwsVzi8yvqHlrDLwa9TflKJjW77x5nIeg6LnoTbCpT+sAqJYX3BES
	 Q0qSu94Dje2FxlGidkde+7arakF3hrwEIoRe23CGj/MPyFBwFonNhZ/mU70Q6N8pJl
	 rFCbHL4OOwkeg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E7BD41D6D;
	Thu, 11 Dec 2025 17:21:06 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:35 -0800
Subject: [PATCH v26 02/28] dt-bindings: riscv: zicfilp and zicfiss in
 dt-bindings (extensions.yaml)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-2-f0f419e81ac0@rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
In-Reply-To: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=1566;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=xVWLAEPepydYQ6s7EeRUY8AnaJIHlB02MFurLGKlnxI=;
 b=kNbqp7oCDhhupamqOi/vHg2cwk+G9eo8Aa12OAjehqsIQTxAq2O3Bb7jKK/YT2VWKZhhxfQ5o
 LMXcxRBHFktDP4nlXnRnB8vi/GzbNb4vMKH7ZkrTJWpyWfh06pyjra0
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B0B3F1A0016
X-Stat-Signature: 488o1e5upxarwtt89b9n7181wd3ync83
X-HE-Tag: 1765473668-658162
X-HE-Meta: U2FsdGVkX188S/NHEHhyDWCy7PycraTQ6v/c8SXE3ElGihsX/5uiLsFDfQxKhJ9Sy1OxmvXQ0pWoV1KdRk3CuGUYf8RAsHcXT4GLFLkZswIbOKzuPQMInAetbS1YWSpwljKSKl+otyZIFSyuJUdcFLDZd3DYVlyICwSXiVwLqzcJXXHAuMBX+KQLPhPOx1/Pb3+plWSHnjksAvrrruuF87YafjGRAielTfTi18GvHkBP5u4rMq6BRwM6tRrRgmCucv90B+TZMqPCf5Y3VWKPRmi8mdQvexxy2ccq5TaL0nFnEt3d2vX4VRwZHWJSt/k5XBnGBE+tUQgQX8/H9ffQUmbbw2getpGCk4tDVWzJlKmOFNfDh+OXaOUgyEvWpoYj9F0kvSlmmoJoonvAo2EXn2hWgOmY8VFmxuxBjSccjNCUAOxP9zdyHiSWQMOc6vy4Jg+qgdckq1DRagOWK8OxYIRApD+4ntCcaz8Z9X0wViqIoriUvONaMr8pdjtqP3tRd4Q1mzMvmUG7hE3G12X4fjnKuzCDbUA/d+HrHPwi+rxoNLlusPaS8TRpeBds1NAdj541Z3dZKC5v+L5R3QZuAO943Xb7wOnV5U8elxjnbtm3QfPqno2qTBkhGzdLMgpgVbo6/tci6tXNF352PmdVmVRn9MEa42xiBX4uUr3F0cxwXxH4g1y2g4aaBS4Kh4A6RJR3wlbtMPVAxT7WtBTj/ywUPlb8k46ru3Z7QKC8xrdiieTdOtLpTCSLXVUxVoNKQL2F2AtZdLLJautov1Jhco++qjrmav8EyvUzoSdHhcJQ8mRI6SLb6dEX++etzgrBmHALbAqYN2fj5SmhdBPcaoZWS0p+oO2cYnOXTqnR3eWpW1SkanFgsI3d5bB4eTLijXnIbcQB/ya1nGIO5UtczsNvnl0FUsABMMfcpaSETIPV6m8dP6EyViNMaK+gCYpE57x9u/qdGI8YTcEj4Dn
 4rhtrAZ/
 fFCS9t0bv2GFlqtethbyRypryZAtyfDh+qEcmWaS0BsI0hJz3FxBrFATOGUVV78W5ytsKshEKlB8xY5yPl1a/yRiKNOfCYeRigjMOd4SpSGZHDRmlQ14EnKJd29rxdlXh2g/HdrLxqvnibmJYalrOBlRcFJxtFfqG6oMBCk8svAAA9RC3TpIXFzm6MLZ9yGCyDzTVQmse+Rl+UnOliwPd7i4oTWI4Ekvnrdjr+kh+sz77Egn4049+nST53gpLyTHhjxb0fO6JQQgdNRgqz8/46UL7FCjEfjQok9VHqdkj/tsTQTTFoyyuCKBscgJKFFA6irIIa4PT+qjCg+o10+uYDMNUz/prEmwJlpnSnEFsT6k2KNu2mUIpfHjgl/pUa/Uhk0uBnY32y9mwN1+yhSHhOGGWZ0MawVDrQpbLNmDti3EMSMasRY9k+BZvHt5zkPX488laFBqXmZAkk/H7N+mZ2XHn7LJLHwv/8OeOCf4CTpe1JAeynqR/D3rORuPJpS9n+lY3ngQJiknRcWZkMe0DfX9iICuVYjfqj7rsJe3oAeKfhMv0y4/mK3hMsw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

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
2.43.0



