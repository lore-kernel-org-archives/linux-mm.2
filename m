Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF7CFD41D6D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45296B0007; Thu, 11 Dec 2025 12:21:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B110E6B000C; Thu, 11 Dec 2025 12:21:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962216B0008; Thu, 11 Dec 2025 12:21:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 824036B0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41B5688BB2
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:10 +0000 (UTC)
X-FDA: 84207855900.18.E9E1F73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3B305180008
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EQyS+uV0;
	spf=pass (imf24.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473668;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbxuP9nsCV4z7jt3eyxaq+Ns/mHC21kqlVx477mm3+4=;
	b=SEt0PqlujuI09ReZWEwNbzMHwyyyd48pdWOdehTbEJBKAVY97rUzqVtyn621TFETwrwe0b
	Vs7fq6oogAn7z+wa5VeQszszJyvviXyFvWjsY8YrwO2LAFyNboz7hlbQY31HB4Bd5N8GgY
	pMK5gRTrsOOXTW7/HrNyNIoGVmdOy/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473668; a=rsa-sha256;
	cv=none;
	b=vsc80ZGI7Q8ffUObwW3HytxEcQk4CvWkLVm2qexoHPj3LvSS4tPwb8POcqexHDOCgq4KEu
	/6kcmnPBUhrwbPUOquXNTucrnw7qnXuRDBRR4D29/MskXNyQF2HD2GM4tZuuzuXuZ5hhDe
	O7Cd7HGIDYvNERw5PqPcc44U1iCT61U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EQyS+uV0;
	spf=pass (imf24.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C58FF44349;
	Thu, 11 Dec 2025 17:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A2B5C16AAE;
	Thu, 11 Dec 2025 17:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473666;
	bh=s9Nd8OrIdmTzTe15BEE4fAoU+yUwpq+wRGim3URhRCA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=EQyS+uV0U+SCI3XKmW5ij21lzLSY5/r6FFdHK6UdNPWASDaVW7X6vqQy8UFzq7obp
	 xNquXMSvaGbYh+O1Y1QHlYjFVXEVzi/KAT5FtYIO2rbGMIPMDkmOrXouZDFnL2XDQ1
	 /Pc5oqCur4NqxRbepSYsRcW+7uGBQt6UuIqJQC/H8/7DWCYrdXzeRGz1D2A0ssrDjB
	 Mwr/6tG4ESESK1COpL7kDvI0bKB0+/9jQxFkmlmnbZS2WGk5p5epcH4ik/LdphIQkY
	 e4BIlP9Vd9pTuhZDTsVevQIemhh/kABtvpqK/OKY4M1vzcxnvOtcxh4IG7rYjssZ+U
	 N+TLwFIChvTMw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522F8D41D6B;
	Thu, 11 Dec 2025 17:21:06 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:34 -0800
Subject: [PATCH v26 01/28] mm: VM_SHADOW_STACK definition for riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-1-f0f419e81ac0@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=941;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=DXRwVlzwdoQZD1P4AgHLEInq/8iOZjrgGgTHzLAJMYU=;
 b=0Dv74hXBGeBWjfcrTvnDOWwPkPd9Di2kldY2KrnrI7XBDo3LnCyqAM/EE3wTg03KyqefMIxt7
 jB5QQy+W8tED+wmP1c2WDSx9gEcyu7GDFvkzXMucAUjsZp+DrZPXcOM
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3B305180008
X-Stat-Signature: ism1qcuc5yp98qgykpcoza6u85jr1ojs
X-Rspam-User: 
X-HE-Tag: 1765473668-480303
X-HE-Meta: U2FsdGVkX18K7q5ubrmEKZ/QSljDbIZjFnUcF04u6QLCgyh9EeHyhCPdBJ0ipMeXFSEBIm964/wFLmghws6V85gR4KvFGnmzH+Yibq2It9EvxqMKUmfbhlb/xEd/OHeIJhpzCa0LRYRd8CYRqIYrBagK7RFggR/xxOdhpeyz88eR41es/Ft4Grx3Ja85MrXTS8Y9PU/KMjcXQVQMvTxRHS89dPqqvj/2SMYvSoSJra4KVj1XmTzYm7l4iBJFCGucpg0YlVLUkWFxZicYZald6qyrK+gsdCv9g1nSSf3uThEdoGcUTmzZ4fGVBLxlxQhAZiz+6ZsjA/5utYgM+OtjqziFtcCw6MBOk6NUpkNnIYJErMq7ca5IuornoidG0T2xc3YEJH6wq759dJ8dT/Cox4SzpJFLiprO4qoYuehZCZeKM1fEJx13cLEWDpoJa5k+NDSpRZ6WxJI7p4hq58JnW5llruuuM+wHsM35udr3RvLXckBSnfo0IwHOnU2KwjgXQzof+smTfI1/4qyA/5pSgJlBQeuN17kncmWTtSwZ3JjLWa8GW/uwYyaTa3oI/fs79PCYgWU0lHJKaDMOieRVUXw9XHCeKRqTBBGCFKpZOHpDfay1PUx6jccfiE1yR3s03n+tLI3M3VLQnQYUstWmGsRicgLQlqx07DBNEOoUpsuNbfxunJpYMd4obZJ61kF3vCEldRYFnX254Wla9X609Dgl+/nr/lKebfvjQi4fH92Mcv2KF0RmGL6I6QG7cVYJzjKBDiEFOzXqmA9qwU9eFQlctp9+1/3zGqlm6k8y17qNWvdpgavHg9A3DNry4iZsWgvnB59ad+O23VbTA6Ino2mClCsX5jMoDUbL/Jm9GQ7ceKPmGAAAPEsYi3pothYpicPOO9jPS4cqvmjfD34v3RTqz3hd6aNswWwg0ddv+m7wAcoj2pkxWrM+j5sHSqvpH9SeqBU1Y4BhQF8DMZe
 5HIGw/WM
 vGoR4TokkNFkdKufZaMeeJTlVWCnlzc8vYe+Ike+nkSrHzOhiV3Ivt5rVjX7Prs+tt8Kmu9IsXsTscUD7YcCFRlLlzPmyq51rrBeVS5vqgeMuFqOKm6g1MZzdrYBV2sYgSDHn/zy0OoIrp51ibCD7UVu1IQD+Uo+vbsvVYdkBjJ1+hbXy2aTyrn8YQ3ewRuRgDWrbRNYh+B40TbpF50OQtv9MU+bfGlIlmMXCZbuFpD4m9McLhwuBohfmeeF/wdLlxrkDT5lbqeboWkqzG+Hz4IQ3d05zBcMC0Nz+ff1z/zR7jVaO2WdHQ4fFwhM+sIk5zWWBKWUm4kXVpF2jXrCywvcvdOr4RVxGyMUmH/G2kTnkF/3NoUsZq1aO7u8Xp3stebrooBZwbfwp3si/33fyTncyTEp5KTp2+/pZJavOe1pKaRLunlBO4tTQw73Y1z7FRcyFdNVvTppfjOt/OYQWN4RADZ+zX6VBJdOGU0BwONBEq1XX1eELV2a1yoO6+O5/59yB7hpmKUQZooHeKcKTMTpvVHXVpoC/1QUbnrj5X2gOxyTzfR+ZTfOsuI2YwVRSNje1Gc8UFR84AFrX64lhcplaxprDKHS8AE8DoxmJCRH0CHTOwJmoJp2UH1eP/p9MMxWuKzH7Rj+e1sg2BIAe7BQT8DSr/Hm/MFwr202ESkjanXHGHdqsx+mOymyFykPU1n5g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

VM_HIGH_ARCH_5 is used for riscv

Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 include/linux/mm.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..2032d3f195f1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -380,6 +380,13 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_SHADOW_STACK	VM_HIGH_ARCH_6
 #endif
 
+#if defined(CONFIG_RISCV_USER_CFI)
+/*
+ * Following x86 and picking up the same bitpos.
+ */
+# define VM_SHADOW_STACK	VM_HIGH_ARCH_5
+#endif
+
 #ifndef VM_SHADOW_STACK
 # define VM_SHADOW_STACK	VM_NONE
 #endif

-- 
2.43.0



