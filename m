Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 983A5CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FFC58E000E; Thu, 23 Oct 2025 12:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988C68E000D; Thu, 23 Oct 2025 12:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84FFF8E0005; Thu, 23 Oct 2025 12:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D85B8E000D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3128D129D4D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:13 +0000 (UTC)
X-FDA: 84029969226.10.B5AADF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2698C40004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SUn7ybvs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238271;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqLXlUHCdrJc9SIAhad47PFB8nBD1ikmT2vr+1Fgc3I=;
	b=2+p4dn5RnspfMAF0XdVUjcwI/D2HeCcmP8QjahfGVdxz/iPkeevEeDXN2VPn8Eloz0IVVT
	6TELOCFkgw16c7+XwnhptSOW8OOIUFMwSMGuyVZnFNsdb0Ea9/4plDnzPeyfrEkn3BIdUB
	xT3HmQQ5IV7h6IQXhp5qV2UAFgdhjYY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238271; a=rsa-sha256;
	cv=none;
	b=8Wvu8fC3Jjxe9IWjiaf+hJxlTiO/d0VIgEdJE/UNcpgNWvQN77GvlcLAThUTcft4iTUl8x
	hh8sX90XT1JVuVG2sM9+b5UV4k52c3/a70XntTWL9BdiETDkCqpiOOxC7j9NTi8mTnxi+0
	s8R8GbhZsnMu6b9jaKtKpUF6TShZFs0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SUn7ybvs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D57B64AFD4;
	Thu, 23 Oct 2025 16:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93E59C113D0;
	Thu, 23 Oct 2025 16:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238269;
	bh=a58bONVF1hEXJcHKI9R0Y6L9RqhnS7srP5e66tDrhlU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=SUn7ybvsW2sSbfh5QDyOqiYItuRrVMBBoik2oR/X6jSwcw8xCzZNSyAH3kJuYQvAZ
	 fIo6KUEZadxQPinmEALJmDOm3rVfShb47JolGUfcf+te3d9xJlswn8jZeW/8O8wLVy
	 qVDuoLA3cNRlJnw5iW+8sXbg9y111abFquceknyyEmquq+BHDWZUCJyEbncq8Lp7FY
	 DBOSPEacPYHcs2qLyHELmI5eHiRMdbV2uafK8wtCt+/1zu7kM9h7uIwxJ8RrozD936
	 GUnXMp5w67haXA84AA0J+Tq1l4mt6rPFB7Oxr28WLlSg8fSnsYBNt5BX2iiOeYJtvm
	 K15fjqJq3qDhQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A904CCD1BE;
	Thu, 23 Oct 2025 16:51:09 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:06 -0700
Subject: [PATCH v22 01/28] mm: VM_SHADOW_STACK definition for riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-1-1935270f7636@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=815;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=pkBAvc0IieGGas1vvYQtOkKUWHcQF724uRmRqVMGgPs=;
 b=VUBVVTDAkz7jwJ2C3jgClL9f8HO15z25YA/BhpcXvfbmCfho9WWkdfrHc1G5gnRgD+BziikYB
 zc+am72yislC9qPgWwy1p1oGuBPGxvwQo3I2eAaQqJILROv5diw4iqI
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 2698C40004
X-Rspamd-Server: rspam02
X-Stat-Signature: burfmd3jkww4xy8degmcf6wbgucu793p
X-HE-Tag: 1761238270-262534
X-HE-Meta: U2FsdGVkX19YzRhpHDcI+5PBTM39wl3UHI14GCs4IanW6Ok1CXKKT7NpiOElVybBX4BHZJEhqr8c2Aoq/gDkot2InC6KJORvzsynl5iGPENL3yG52Rq6L2LuO37oThXp3cXL+EE6GLMsOjSLS2gHfSWLwnJQoiqw1a6oLorR8Nm395IbN+8tZtXCuTJMpprUnV0FAfoI5HNGWPyj+dGBcgyzEyVDp452XSSUmZDOspGM0pNFr1Gw+dhiEllVEbFZCtDLU86d/x3wIiyEmWdRSBThjeh6V86TGXi9aSGKjTq9urcCOonTaERjP6QA0bvXvjnbKwHUST1rQ5lEdQTAOhyEenNbrkXtkFLAATHNEd5oF3wrXfm4NhuAa1FzZQFqTkP06sEPkLjU2O9RIPceUJdT1xzkV0BfMlo7kUDvDvn9A5RGO2WVml82brTtJdC/V1fl0DtGHh6y+uqniet98rCmVA49IX554n+KTUVSc+99ozLqQIdSU3QivOsrmG/CskyO5qwR3WR6/eeUwgvgrbqFAA9SoNs0H9DuD1qnqxz2s/7nRPZKxnLxc13qGKiXxxkBxluwdbv562ZD++yQ42QSzPL2d13e5Gk41EXvIVQUGgve/WB52gIqRyrpwmF1QBBnhwn7RpJw/VG1OmiJlojtDQJthJT9U3H572a4RHmmeZH2vmfzxPWcCmXQqMCdB8oc1vLMx3JehWhiehAEWSW5p51FFgBkY5LDHHpnqCOCj1UH5KbYyOiir0J25CS9OchVzLwvxBFwrEbTVzRwOr6BhAbuHXm477a2YDGsL4EEbBi5ctA1a/O12/0dtqup64DJqPzc4gIpofVYTBd6DBoqw+Hi4+oHVdoh4XMw0t0ZtXK6uvGzUENxoZpkRcliHJrEUo9Oss91LXzThjvtMV9DrCOZSDacpSnTqiKCWpR7OPpH6m7R0dGvSz/XftumBSJqj8eMfucrLRBaFHt
 EqMZg6SD
 V3TRHFBD5LBSCPmA2PUU4FNeuqfisKu+vv9xyv4ds4S1cHGB3Pr3qNglyIEbn90Ni3rlYDVj8L+R43BU355ttjAS7bMi4+AEY5gAzSOcJDPR6D+Owtht/Nx+ElG2ApohjhTr/GQ1qCeN7mNYTfthZ0/S+ZS+WlNau4NeJ+qtgQZ1TxQlZgVqhD/S0bJC0dvLCzaADTKcFiODXMJQNOXE8jEwmSs9TL6TA/B/LpfZCHRyvGe5YN2mwUDoMguInA/CdK1YwPt8XWYG+bgeUeFUmnzrxzSK9hwMUdz9UvBMj2xY+xn1hNtpC7xLCelqF8YmHVMKvAo5B17sXsAmVfTU1Lipfk0P71rp/dsDJ5HkJDcrlL8Tee75ZO7YmDIYhaiThvOlgOKIxiF7xawuJkR2t+08oe7Zri29oW2xAsFi+UBiKMbzd9JLzaDibiW3RZzAbYXKXtMfOZ/LhhFbiTsOvB428Cn7xjqrYvDfQaWv2FARqn0arRomELFNwS0BPf+723XpiIBp8oGqf08dVyHZ0qrF00Pk6r/3Tv0ryjlJBVMbIrJXccxOLtwJDnlC3b6jH+ZTwAezj+cPjdBZ2TGTcXZqKViqNyRGpjpwJFGi/H5GZCkOoV/bzCrIdlGDk+TIcSdnvGUn14PoVjbc=
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



