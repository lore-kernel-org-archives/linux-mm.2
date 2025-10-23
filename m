Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFFFDCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2FE28E0022; Thu, 23 Oct 2025 12:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9248E001F; Thu, 23 Oct 2025 12:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6598E0022; Thu, 23 Oct 2025 12:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3F838E001F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 227101A0BE7
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:23 +0000 (UTC)
X-FDA: 84029969646.30.86F6913
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0D4AB40005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZnrAnwis;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238281;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/aGqzZSf83e3BL4STJAS5xAogQzzbwUaAeIgOA/xLv0=;
	b=syjwSka7Qedf13MaqwhDPXFAvPeWN5zF2jsCAYijbFbdFcHngXK41wb2eiEOC81NB6cNCA
	X7AuK3tVRatjYNxIqmpH3esT3YqadZ+y9jbQFQeD5jm/gxoMgalAmnblJZyg4Pjo1bQ+G3
	dVb8ntFLGm+n5+O91ypdzaHi2W8ptA0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZnrAnwis;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238281; a=rsa-sha256;
	cv=none;
	b=hgjScltP0iVSdTHH9XxTTAgw/xQU5g7gZ3DcuPhrfEv46YxCXQOUiY4WucVPLz8wllAXSZ
	gFK1MMNhOBHldv6dLcFQcfoaeDERA/O1z0p3c/5Q5TqedEt5wLNDEcpFZj+0cR2BDKbomC
	3FmreTeN0SMu02fIdWOHtjIIBkAwZtE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 097C34B0EC;
	Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE14BC2BCB5;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238271;
	bh=W87iAvAtwPzIao1Kl3uJdHgPAstNdwcXUemtLCbZFyE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZnrAnwisfWXesXdZGRkda9uXbFVbo1OPr5zzVhjwBToh2zxL2toNtb7vgSLpxIo5N
	 fTIbfvXGQ/SIum7MtJEzGcJG6sFA2ZLKyLU35Xo7WYi4rIFdiDhEFFH86yQ2k92l45
	 gXK4l5R2rPprk6S1OiqpCYIrv92QaHHx/ZcyvLVtqCM+lko87Y4kSHkQ5lqWAPdVjw
	 wjRlfjo4KwHrp7Hb6nEvjPbhMgJC39JH5b2nXnhubZ9JrS21qeCVg65dliCEU2pJIU
	 MAfblaG5tSW9zSEgdHdIvXLMhaK4Y7ov7y3bNRzDWTubBY6khzlzB2HwgSEbdSXjU6
	 lA7XoOsSfuY8A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A69CCD193;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:23 -0700
Subject: [PATCH v22 18/28] riscv/kernel: update __show_regs to print shadow
 stack register
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-18-1935270f7636@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=1056;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=wP5UX7zWs0Sv1DUPgXKgMTygpamqW2/FxBkyaeLpPmk=;
 b=cOimIoa1X2is1Y41a/4qQZE+fBUFk52El9b9X40fsXGZFt+o+jE1enWeNX2BX2/X7O8eqkUrJ
 AIJ1cQtXvC6ClkxVVYXv3iIDm9TNp602490d/piu38b6mrM1c8+mqj7
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: qyt4ufwgrnoh7w6kmeenxqmqusjfmhkg
X-Rspamd-Queue-Id: 0D4AB40005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761238280-793674
X-HE-Meta: U2FsdGVkX18lmoC1Ms8iMG7mEGK1R7iZg7J652J8UgDG5Nl/BeKPjchYK27K0MMgcEhzim6uJ9Xm2zxY3UFx7mDRWbbF2Wg+fx8N+dptWDRbR+UkK3qmGzb2n2/EZfcwixJiQwmEtMZ+0JRxePoAUjQUwLHOVqnec9PSFL3ycO1NRON+HtZcBQsbeJhIp3McYBnqnUg5vQQMl2V4Q4gblY4f0gvTm311YGr2DFd3lPwk4O1RZmOlIx4D7W+Bq3kjRGGAn5uaufhAsf+RALr9U6FX7n04qOb5s5k8BxwJB4QVnQIWy6yDs01LAFAIXwSxd/D8ubwoqMaeTlVkMTxRVTRwfBNIsTqCTYEtZ7i4ERmeBYgl56aTQHo4TghAz4PQ2vBOQV8VX/o8O9DzEhyhQcWmRAFX9r63geuUcIkq6PzvfeNjbpxsMfVA5yGVqqH3dnHgZsWP9qlja0r0eB0C9VhZoFAMOsEPvHaSAxVm1uwAYzvJQa/ARrZeGKNfyjIB3ZCOxTEnNo2yzfP00iGmyX1ZMAS2RN/P3b6dZfPlFDnqqLGzQ/vrbHJNqeayGeai/eTVbQBOASI0BC3FSRWkWTJUSC/d9AqQXtjfwjIAuLN9YYrULUiC3oYAqvv0NwxdOwli6JWB9iTnc3h3BLtx4b8kR4yelm4+IcBmS72F+38oATjzuXe6Hz5rJxZi/yaQYJHTY/lk6hJ1WhYDkjhgvAsveIQcAyhhe60HO9DHGNdmoPBJWH4xOcezGHTN80jgdCuM2/xJ9yWwDmnhmiBVCR6Q5SFikzf2UOsedzj9YlESz73jlrh4HoazLAI3jRdKch68Kn3cCfBpijUYCPtXMzRBGswyziehWN8px4usgX+4hjzXP5gTVix5dPckmw+apIiqnzicDDTl6hr14OKQZfVSJXs1jV5OHzu3ZD09vOqaTGfGN/ASDvxkxxJKrha4odz2Y0sEI/O7k1aK1Np
 1YOZGMog
 bDY9fD87ReRBhft0QCKMN2pqBLuG6V33538OXbLT8OEzu/MTRSmSC3BSDB2cIHIA3m370uDZWKIU9x4TZVVTVdqiJ4xArw54YYd0s/Yfcw55Yw3xeaqBkLCjXcEjTlyDK9ll23uTWh+buo6kymsH1NN6GGlGuXKO1LMnG9Ftl0CMXWizHYlEirFG+N+hIeEf+YnzZ2mUvu5ibWU4gqXZxiQwUM6+7T5fGLGJ5ErL5vNNYWQrD6hrDbI1iLqZM5nU5NzpDwGbCuEIVuP8fUkytqI+VVyI9astnIUzO0wJQLWtbOZ8zCCXdMjtnLv74XHxQoxYhbPDIUklr2vlymbiRF4eKr60Ww4YS7w6U8xz9njPCGmeQnqGb42EKUaGwWdi518Bx4T9+ya02Dx24PLgFDdYjad9rmCBtpRnqZ//Xt6kwFKrajvsCqn3Ldj++1Z9YZBnO34crgXuR85UyTr5Nv5hM8Fy7qOI576bXPf8kNORv7sqCKSF/bFL0i0EQGs55SEOesQmeummfWqJzoNWWjOG9sw==
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



