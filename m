Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB967CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E05368E0023; Wed, 12 Nov 2025 19:43:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64A88E0020; Wed, 12 Nov 2025 19:43:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0AB8E0020; Wed, 12 Nov 2025 19:43:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91D0A8E0023
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53B92140780
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:52 +0000 (UTC)
X-FDA: 84103736304.23.96D88A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 558BB180006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O5zUw3jq;
	spf=pass (imf06.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994630;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/aGqzZSf83e3BL4STJAS5xAogQzzbwUaAeIgOA/xLv0=;
	b=B2a0iysMWE+eL3k9bBE77Z5t4XERhtxu7bhSVvMpQcvkOw9+RIYNINMVFVkNlPMiTfSmz4
	w3bMfnmLmGAa4a9YvthkeKrbn7cfZP+b1Qtoax7tn/ivMFsp1PB/lwnk9C8Hmylz/fYG8X
	hQAp9+4s2B6UNBuTT9SUrBXt6N0atmk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O5zUw3jq;
	spf=pass (imf06.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994630; a=rsa-sha256;
	cv=none;
	b=SdDQMCsCw+szkNA9P57vwHLIMCv49OxlND6L2VYrxSHsjF+Vpe8zQ9WmhjK9git8PLkkJP
	O0R2k0Vcxu9XzNvd8K02+NOy6Z/FJtYc8grb0AH8OAsJA4BzYKkq2e7skgTzdL8DYMUmSl
	LRKiim034Froa0vWSMEAzcga+d1nEyE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 45506446F8;
	Thu, 13 Nov 2025 00:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F35FC2BCB6;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994623;
	bh=W87iAvAtwPzIao1Kl3uJdHgPAstNdwcXUemtLCbZFyE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=O5zUw3jq69q2sOEMbrExGGGKWS3tUpArS8wVzkNAaufxEnr1mAGRGJmSjDO8XiIch
	 rlOdWJZCDxGvZTp5i3L1zs4gK3ICRUIY6Cb3x9VrbRosT+8HzpoDcM6gHlVfosnq5+
	 a2D2CjnigIQTW15fQhCpjzATcxnou1uLIAr7nI+7CEXunNosSaDT8WBymZOojY//7c
	 Bfh1kf0roSHmEe0JRuf+TmEA6Xovlspn9GfYM3PBO6MBXP7tfd+T2YRSCFXRlqpzs+
	 CPgHSLxtJt/PP9RgJzU2bO/opQNqM3O+miB4/7Q5+2g/RaqyxhaXDmg55jVd8qW9Lq
	 bE5Yazgz/0b6g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56261CD4F2C;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:16 -0800
Subject: [PATCH v23 18/28] riscv/kernel: update __show_regs to print shadow
 stack register
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-18-b55691eacf4f@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=1056;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=wP5UX7zWs0Sv1DUPgXKgMTygpamqW2/FxBkyaeLpPmk=;
 b=XgsZAeUT1sXG/F+4ZdUQXPJ/oLZzD/TzpHQHvsP50reqdgPJEzc+FCBukTyOsqVOkj0T+wXh2
 XFdHxvNuumZBb+QoQcRR0YeS49jg3I108jb3DjkhZSD4rRxZ/9FUKEk
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 558BB180006
X-Stat-Signature: rhhxhcr35g4mt8n3hrhnx4aqicmd11kk
X-Rspam-User: 
X-HE-Tag: 1762994630-419271
X-HE-Meta: U2FsdGVkX1+AGzuKqMHwsdvrD680Ler3C90l2Um2YeVsqSLPkPtrbozYymoWMY6lPd+B1sq85dxaEXiYK5zgjHvgdKd7lMB/Zopz9DWuQSrbziMcq7WhXutQfbu9+kfD+al4KytraHycW26fNisomuGgPUIvel8FeJ7yPKEqLA8wEAES8JPOHIMEccQMDL7dAsPdzq+EPUvdGhZVR4b4LT3tsqmdlZrrrOs5TuylJro0/6EAc7kfohZAkWmlLLQPdhu/9leOm2OKJeLX96UHTHIT+Kt8Rl8gOGj1FBLvL5ztMRp9ZZLzUiIjQyJPLYPQJslDUu6r8YHQfv2kyTzpH4Wvn4GJTDRsJYvewT2tdljLTaoTXAQay8HJZ2RdLQGHIKEEeONImNGrf8BkK6dxKTBiwx23Nd4Kx2kg3miyS8oftAyQCu3t0UWEye2a4d2ucP7x29dvcn2mpvaGEm4t/X+ZsQKVY8t/fAKSu0WnCBBvWLo51rOSNByoGw9Xt30FqDF5MmV5sMzGJYbEMYrC6xdtcwcTDW6EDDZX3jE8zMlPjEi49C6SjKIDtUC+5OW2uHIQqQ1XTPjJhNxolhYon14XlqOtFUzjuAIqTSpp99kr/IVM0czz+AP/ci/HcfND5dvZOV0FxeSo/w3zILyi/qkJKq+TG0T3aKEOv4lqup/LRwMNUv03E+MBwsqt9Ezbl+H+UCJG9KEP/hxuEzuAt4YjMk2hLUL61HNSUrOBwTnSDQ/xkm6FWIeKsmZ3tcEP/djU1rMsZAxLFhysHquP9ihNjlGaiiAjVPyeTFyLxSizUVrLNpluavMpiXxSlh1VZ5UaSTHJhWvpbX86Sx1/l8SV21axjcFDiyNLU4iGRqfslkCG7b/UEC5WH2wqnxT/+1A7bppPjJlf21f37xWdWwsOE9+TD5I1zFdiq/G28AS2qY6Nhf+3YySOrgc797kLkAN61N5Kni3lCBiFruw
 yyO+B6Ir
 4b3RGlp7Zwe/dNvaEpnqvKMqGGuYdmDvgg4byqpd4dhpQu+Ms5QNlbmT3W+w6dC+Lp/clQgTM/k0AUSuJp6/jmw41iTrFN1o/CLPej0L6iaTM7Gwn6scv05X0mtIwezAMAsgeOcjaLx30QHDJZhuIVojtvexu7rjF6/QFnt3ZWNH3H0SdgEvqwLfmqXIhi0ly/OiOhUFFEyZTDxJ5jGMB3CE355ueRHbfh4SGdsOo9urHyATfHn9GHtahCty/yqUHQc/dkRc3vB8L5rQe1ET23koiyULQdhLMIS/nZIpPT/AlReMe4GaLo1iChuy5eB59AL3mRx53/v0CNpsV0xTLixZ7dLr13bCWiICNmvyCacH78gizt9sfOnNvkeMaCerj7YNr4xX0lJj5RVxxEmhYCaukqklvmlYNXQleiL1Bh5ZRJ1GtC0rQsv0KyCrYxhQ3bqj3pa30tp4aZ76akbssLrddmpHkVpPkVPliXBY2aJ64XUXzfqtCq9kBdWzRlyxp9Kj7u5qfcHJ5QZqqqqkWf+aUIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

Updating __show_regs to print captured shadow stack pointer as well.
On tasks where shadow stack is disabled, it'll simply print 0.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/riscv/kernel/process.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 49f527e3acfd..aacb23978f93 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -93,8 +93,8 @@ void __show_regs(struct pt_regs *regs)
 		regs->s8, regs->s9, regs->s10);
 	pr_cont(" s11: " REG_FMT " t3 : " REG_FMT " t4 : " REG_FMT "\n",
 		regs->s11, regs->t3, regs->t4);
-	pr_cont(" t5 : " REG_FMT " t6 : " REG_FMT "\n",
-		regs->t5, regs->t6);
+	pr_cont(" t5 : " REG_FMT " t6 : " REG_FMT " ssp : " REG_FMT "\n",
+		regs->t5, regs->t6, get_active_shstk(current));
 
 	pr_cont("status: " REG_FMT " badaddr: " REG_FMT " cause: " REG_FMT "\n",
 		regs->status, regs->badaddr, regs->cause);

-- 
2.43.0



