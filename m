Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D752FD339B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F106B0279; Fri,  5 Dec 2025 13:41:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6F16B027A; Fri,  5 Dec 2025 13:41:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABFD66B027E; Fri,  5 Dec 2025 13:41:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99E066B0279
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:41:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64E09C02E4
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:54 +0000 (UTC)
X-FDA: 84186286548.19.87A7335
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 437F01C0019
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f9/TlKd1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960112; a=rsa-sha256;
	cv=none;
	b=6Jp/qXFmoQp3IbGQgedhvsKKif4vALsPFJzCgnyHersY6dSg9VJCBmCVdNXjZXDntJwV55
	HBb/DawuW3hm91WB7v9FOCHfe29QNKw/VmYPSeK7B15Q9BWThUMAYVsJosaWl6cJzWwu8r
	me/7DvhNu3QaZ9PXE3Zmt7UMkV8KLPM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="f9/TlKd1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960112;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k096bzoeNIbJgTxwdoDjbWsWVyg2pNFcVSFhbME6zF8=;
	b=xy0wXUNhMlWHtHfeWAiEm8oGcLM0FRnWmlxDvF75apBzI6JPYhpIVGguJ3MCk7TCNJa8Q8
	1F7zizwYMTi2+uM1ZNampGHYAyD8AzeyvkKCP9lVGOrBOAYuOjqAFgprRbUJD3hIZQOzaW
	vIJsUYlvgO5098l0AmJEFjXAEsDw0Js=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 710AF444B7;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 102AEC2BCC4;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960110;
	bh=SwvYyMJ8jltPo6WPCQrainmSZ0rXsiaYOsy+DlyS5P4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=f9/TlKd1uFYQdrtu3cWKGPbQXo+NmShHvvMGO0+221b1Rw4bQHC0mroUyYlGAsHmI
	 wkwhNpqPXbwCZPo+asfnv4czah57f8mbGJ8/Ju+GIved3sRZuRYbz7W0QRVP44pA7a
	 p/rUyb2SJwNQFSXqUKi2XKfLs69C4wdio90XfkvcD7SykJ3tQi/+rALnZX4OM3uMaL
	 JzRdXx5G6Mq2YaanZO5omT1FeZG8cC4cQU0JKUSCRgp/rPR9xTosQg/345rh3KoF9K
	 by+BtlW7e1IclhzaBrxc6B+xjsLA3bLVa0m8gP8h/0K8DLb3V6InS4a7GCbHLMyb7D
	 uY/bWFYpbIzfg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AF1D339B5;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:40 -0800
Subject: [PATCH v25 02/28] dt-bindings: riscv: zicfilp and zicfiss in
 dt-bindings (extensions.yaml)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-2-1a07c0127361@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=1566;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=xVWLAEPepydYQ6s7EeRUY8AnaJIHlB02MFurLGKlnxI=;
 b=oeSwSzZPPKDskSnzZOYr7uKMP96dMcUeWODFvOaY56CpqDgs4GTuWyeYeiWLwblSnVxrcKcuI
 ctwaU2KvGrOAwscNB1mCWNoYFXmPy2+R+oDV9bywqCaiWLH+qFkuk1X
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: 437F01C0019
X-Stat-Signature: 34mhzw5j85kxx6neiwwzqfo6thc8z78u
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1764960112-550944
X-HE-Meta: U2FsdGVkX1/Rz50ghTYwp5lTs7lShkd1q7aSBHjLHNXN3kpqnH8S4IsPEdlvCsID+67aLObjeV/KTAf3eqoL38W6vCz4qAMAHv5JhBbIE787QBK051t14Me8G/0IdJ61WMahoVCCXudm7AtlyqlVbr1Cb33mCHg7g2I5gp24mf+dSEyGxJHJWWg+18yz2Rb3b0/YT6yOstKs1RvoML22IQ99UnXR0N9dV3ExX3b2fCCc/anu+81ZpNiN5dGZD+YoaO8TrwdW/1yzfwFKqv1bF3Sd/9O5ekv9Aim6uOZHI5KuRjYHjIoestDOifjcTQ1myiiU2m/fG3CdxJ0QlTgGQYB75a09tY6BOqdBSLbs9pHZc/zTYT94ui/4z3qyHo1/mtUA4GsbtZ/pn2G7oXGVlE4kLmJuFtOK0EHiCv2Jnvt/DGaWQ5uqyhdTVg6QlJ6dqdTEu8Y3Jrl1PANVYcREpanotdcWUDWd+M8t0iDawZ04qjcrdaOe9HTc+czZH7KK525r/kgYK0IqQVIU2v3t4ahEW9VLhV0Bbtv4S1TgVj6yf/UUFRStBFJUXTHl5y2SMYOlPLw85rjE86/EbhBkVLjr92orRFtGQP+xw+WkmWBU9gGwL/CGAy9X2VYnSgNJAmHlQLPZrvrAEjwopSY8tdlB50vH1PRhEEfRsToDhK1bCqOGXUcAx5lBrhVBZFMg90qNnxSPEcV/afyW7FPUhiVO9Ep2j/dd0S+uz1T+yPMcfFgbnwWOVhz9pDzsd+QoICPy52CLtCE5mNGkRfSCMxl3pxmzHddXbMKb0JD5m9CeqoyG3teO7WUm+LsvCPVU87YnKzwwxZ9QlpkXiPpARs5m/Og+UkwRgvyyAhoWTQLRolIWap7/X0QUW6T7KHPEaxhfGWooAiGNTm2l0dLsLdoFGZx56KyG9pftExjdgjsVBb4Pve8v0hkcoIBW9AY0pDxn3T2U+iseWXalTgC
 5Rq0LZwr
 IxKMGoFvWTPiWzxvXVt15CNYEmcpIIzcwpAvnxtOBOgKERZZNLzFgssI/9o7jRkpbr4mv6adzQ6MfGwARvoK26W6G9O/YtGHUN4BwHxcRVRiPsioFtpoNssYZwFhLKDg/y2+KrO1IGWjIBbkbXw7sgf58UCmzI4zfMQCBx8JQJ1MKOmbFK9++lfvPZHdflSmkhEQT1taExNGP2Lvd20c3fDkgQB6oPkXoc7R+eRtDFqKj5lc38v8mZadozMWibuOB+2GdqtBcLA5gVMU5cjW/D6Z+4mRtTno/ERIbFGwBvZthYhMPlgm7WzJBJa+TmYe19FzIGqLcdpjD9yr7Ku3YHSXbbcFHh2lr6X92g9GVNiWsDrPDNAYwHbnIE18/gpWpDbhU3zzvHO+4d+Yn7WrIqIrqTo8Selte7vkx9MFt/dGi7kp3ycp+zWwWcdwff9fzjl3YXb321VTgs2GfZUSOWPiwPTBAIp/Ph0Cg2ZEHecw7WYB1E7/DAelQd7RD4uBL+2Pjg8Xit77a4KOhkKISqeJvUBo5/XEBKRoX9qcTPslAVqG3Qs7k1Ie82g==
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



