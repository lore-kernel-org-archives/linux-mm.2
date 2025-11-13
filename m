Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2841ACD3445
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B15D8E0014; Wed, 12 Nov 2025 19:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6629B8E0003; Wed, 12 Nov 2025 19:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4180B8E0011; Wed, 12 Nov 2025 19:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D83A8E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9279BAE2B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:45 +0000 (UTC)
X-FDA: 84103736010.22.F8A75EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id BECF0160009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WJlJjgOW;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994623;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqLXlUHCdrJc9SIAhad47PFB8nBD1ikmT2vr+1Fgc3I=;
	b=SXMYpGMrPipCM1zp1W0Z0Zxe1FtXjZQTYetlxLS9rUWYQyICi7eYb9KxcNS1wd6YpFLh/s
	FkF/BqePuEZ4hzWULElCUB+G8zAd3fwrSY2j8FmWdKM4c2qE7G7nbZAPfqPYcl/w/Z+QM2
	W0hYzQ3hvU6u6JnLYJE7GDA/k/wQ5pM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994623; a=rsa-sha256;
	cv=none;
	b=sXj8S6VW1QFd9eeSGP6YHsXxAOskVBFLWyclJTiBQ1QQJRy5C0fgRQeMr+5T5pWpMy5L5f
	328NK125DCSF84YOqhR7eYU6pwI74EzaN6BxRpYdDX4E3pc28ln2oCZyX/Bgc9s8GgaSqt
	+3IIDUf4YVM2scrpAnKYjfEdC7YCaWs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WJlJjgOW;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B991444F7;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A684AC19423;
	Thu, 13 Nov 2025 00:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994621;
	bh=a58bONVF1hEXJcHKI9R0Y6L9RqhnS7srP5e66tDrhlU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WJlJjgOWs49vJXxKO13IQ5+ZJkHPeUNUmt9Qa5lHD/QPpdKCS1l0j+D2E4LsItkqh
	 nR1lgYlaqLKJtjxBDkcXOd2FfpVfmuvuXooPAufwoZxRs0FmjahauvplMbV7JY2fnd
	 jYp6vO0f0stJd91blxsMgCLCLtJHKt/K9k0wWYvbaJZqgN07uIf9brhZ8eExmvk7hZ
	 iFOW3GQtVJ6MkTSPnLfbRzEOzLDpLDrrBqZaXRnYPm5oINizX/i1s2flnCuR8BRZjI
	 faITBYlPc1liDUyQHPQe1xaIFN3jAqGVNO3K96NgQ4eAhCMT4Ao6uCSDYPMaezg5H8
	 iAMw+cO189Wlg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6E8CD4F2A;
	Thu, 13 Nov 2025 00:43:41 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:42:59 -0800
Subject: [PATCH v23 01/28] mm: VM_SHADOW_STACK definition for riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-1-b55691eacf4f@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=815;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=pkBAvc0IieGGas1vvYQtOkKUWHcQF724uRmRqVMGgPs=;
 b=WN4zwZFejV79pbUOQoeRssm2N7dfg2ZW9rR31scsgggIJR9B+lZ9rPCZ52x0Nn8Xgk8o87/g5
 8gRdhV0/INjDZLdEyI3y197h4MQLHhbblyWw2Jxls08mui5lccpHYqZ
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: tf66boqmannq9ab9ef1yp78am5d7syd4
X-Rspam-User: 
X-Rspamd-Queue-Id: BECF0160009
X-Rspamd-Server: rspam01
X-HE-Tag: 1762994623-590193
X-HE-Meta: U2FsdGVkX1+Za6AdReKRolK5GfiSylZYF5tbtVu9F/elutqOmvHUFSRS755/nyPl70GH6XENoX3AUVM0N4/N5gnQx1RfvQV7ZsUw4NWCQ8FKVt3UuTGYvO14C+OcKyWJ+d0/fkYdweaTvZlxUnHD2bhysPHi4PheMz30YYLWFumkh0TE4laPpwOQpurlQ4deKHBY/qdXYHFeb21dh17iAlZmDRUinum/opUBdwzpshjYR8amcK+eaPSIrP+X+rcuw5emt3hviLg52OgzCnyBbpVEamr4DZ+feVl0schL3AxjQdSPi0XueAVCRj7UsH1UcwxZG0LvemT4v4Tv3eY5n7U4DPP/gnN4whYeLoAc4KBBQe4VSjMtyKdSVd8tkJiF6weGFKYUYIveRl5A0CciTy0BNFod/U756X1sEIX2dxCC9rq2hZpfQenrORExEQ8Bh2+GOIGq/VVuD8WV35lEwUZT2M/LaV+WI9bKi9B0v94enoCD8Yl2fiAciUfCEGnlLD5Ey7gDiqd7EMJLuGI0mRd1smubBqjWA3cJ3FFms8jLPy6SIQpILmRUPd9k/VXkMXvJJWFHEogSmXJD26LAJaG/FNURKxuQ4iocbIBRdkIcNY7t7rIPtYqqhcVavMC/yvYoRx1waRnA0K1y0hMDmZiJOfNdXkwLakUzJCSR2tvdGi0f8m/fkjXvuQM1SRzmSSVF3glEGsUW81sR1gGxhq56WTwmaA32iQ2GOwNqFuKXrTxKRwt87uoTlwcqr1RmraAdJkeW6aA6e8kJkZEsghU5eADY3pLdwoRVyzYN+mP69uieDHw6A4HeDPaxQLGmutj+jGrJ/D6KHh1f40ELfe6jUchmlckQ6QBvn61Yo86MxPNQSQhkf/1dgwjBfwWTC2QtWCtqaZseUbrb4UO1Zk+24KjD2k3ZHI25KNO33frSgkgpVSRTkFcbBfgbPeTQEZYQfHg1q7+qgBhwJZi
 tECzDjb4
 YUWrCnvdwr9H4ix1XaJyGVLpIgdLRNiglM8qsZbxrcoPLoLJBQ+LlbFslV54/NzEU/BFX2BXHbJdssVcd7JXzol7MFBbuFmwQTOjR6qMqmqJN9KvNELERhgha+hrt4Gxn6cYtdgqlsPeRQcR7GxD8a0wSvzvh4awxR/G3DRrsmDeAura+t+EShQvgWys9rf2uU57XMoSeC2WBhoL54aQb50xfMI1g5UKbp4GUF956UCTu6iPvpoTJaHS6c8aiKhCK1cWh+ljyEBzNev2KBXeHhBwmURxEFuzW4Cr6qyxGhzGnJ1n2XGGo7WSj3je8PPWfm2XvP1hkCdvo5Akdw3SKqMPeGt0kveT6rDD7x4FZpO09ApFFxLoCe9mXT4QArRNfl56Jhu0vTBK967wfTZo1my+2lMCLnc/16WEtPh6n4T2FDEt7lMsyCBON0vHTbTvT9iUGZJ8XHvITvIY8YErXheb1NTUfjaUcAdsFryAkD8Z9MyMeRGE/w4X2CzHWbIaHfvA57bQMm2wcrr54fVhf+DYGwlSNKP6j4EYoOBrQd01xdF/6LRioK+bhLWi4MlO2+C2+xTJcCo1PQrG/lyjkrvVzWHJ7RpHZb2c7ZRpiKWesOLaAkYVUA9BPPUBNYhmmxFhRz8xZ86N05Hg=
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



