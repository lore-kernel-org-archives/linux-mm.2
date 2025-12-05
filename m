Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C59CD339BA
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42E06B0089; Fri,  5 Dec 2025 13:42:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCB586B008A; Fri,  5 Dec 2025 13:42:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07D86B008C; Fri,  5 Dec 2025 13:42:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCAC26B0089
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:42:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89D1E1380FE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:02 +0000 (UTC)
X-FDA: 84186286884.19.8E0CB9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 84AD740005
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lrA9+hoT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960120;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=llOUb7S1/3qB1K7VPVA6sgsbeQ5kMd3KBHPwfrXybNM=;
	b=FU8GEEh9nUj/3Hp2ZE+mbI/pHeXqVIoQeNFKa2kZSG9v189yNH2opyCZm/hvW1TVY/NgDM
	LB7OkSC2url3b1u16yA2MmyAVv2u+Q2L4bkCSWv724EFyTuXLS+58PnpNzn4PFf62hpV6Q
	jXUoQ8QQwrWS/b8uPoTv3X+J+Y+WjFc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lrA9+hoT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960120; a=rsa-sha256;
	cv=none;
	b=TR/eV3MKg7RbNqyJfv5sTKkRVkfbbP+/Np9kr89XJm7IANn6DkeekSNe+8t1gnLZ902pSi
	l2KUF/YogxLtCGM9mvVBrHa3kvrSx0WRl1k1gcuNcfdvOCaPR4SJzzzDQlmRxn0CKAbhSG
	DFIBs1+kbO0CcPV+KJBR1ZTYSZkNNRo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F4097445D6;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB00CC32782;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960111;
	bh=gKj05EfXWRzFgsdHcGDwkowJM1p6i+3gIjza9qiTqkA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lrA9+hoTr2rXtUg3iXXS/9M9Jv5840hMcRepNTJgpUxDVzm1+raQrK77SQYuDEzNH
	 GJogM9EuVytNk5wmPOa/jAOUZvXObYgzuRR4ZknaF+v2zDM45YdRIA+9IM3w6NByFr
	 Ch7G8laVMENMImxp1btsjJ23j8pE/K7y5IN5Rf/OWZ0FqShFmhFzCqLaPhpOMV5rww
	 jhvPSjSve+BHc/1fIf4NV8uOtncVBiUbPjDK5dNVatIEya3QtDkt9Uxmt88FW3lbiq
	 NQgVJIfTc+fBUufFb15XI+/sVpjqsPEV4YHvVT/3VPhXN0hrVtX0RIUFI2QH8rMJuO
	 LQYIUPy+K56Bg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C0B8D2F7F6;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:56 -0800
Subject: [PATCH v25 18/28] riscv/kernel: update __show_regs to print shadow
 stack register
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-18-1a07c0127361@rivosinc.com>
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
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=1182;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=XI4ppsK62Fegg41RmjuRUH5R6YykPAMiGtdfLotNIGk=;
 b=l6Q7qF73uJomHw0ehkP1t2QZ7pGlMrNsJbPbw5cJvi95Vi+ilYXg5KGXrCDdAnxDZhga/lxhp
 xahKwdn8tu7DmrT3yXGJiEa3qCcNZ52OENO38Q/98iauV2pY4SXd480
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Stat-Signature: 3jzzg1p9o58hrryjo1i1sks8xx1tgwtf
X-Rspamd-Queue-Id: 84AD740005
X-Rspamd-Server: rspam06
X-HE-Tag: 1764960120-196351
X-HE-Meta: U2FsdGVkX1+42QlmHURAjZqXfsft3m0i7i0rWwPMIKPM3k9Yf/tWRET0296uxS+vhbWofU9zYMayyT6ftLIEzINvcnV52pjPvyZT5YXiEtioe4Gqhd5Te0wHUApH2aknFtHCt7xTaQdNRlWEPHj/yprsAPoZyR6SDl+7SiJNgg3okW2ltRXR3Au2d3evwy7p4QMprrqy4+18e9PLL6dimeBoIAFfnooFg+xjHnb32X2imx7EKHwVVLe9A8YeFdJh9lEWTjJUJApDbPOhektiIikAPwtzuvyqAhkAFFXPRuxPazO0s8MmHUE3kUY2UCf9ncc+p7dr1CrtIrlTZkheihjyiAxFtWrd+lJyJJYotRZAr5tJdzF6rWfkKJWzhbIYaCrNAl47tyA9oDf6KSfVjy8bVQy2Tkhid2fnRxtIbeHxIiX0ea4rqg4f24qUBJ5joauWTfff2ziw5/TMNktjq0YsTNX0q7PymKTNxzl2lPv7RVv7vHPUfTnUJKXIgyqeCaKk/RlwX/Gt1B8fy30tGJ4KGVVlmvbFlUp7xNjlQfRf21KmACHjgEZYGkxzzEc+FiGiPhf8ubSGEmo9qXuDX27CgUrA5jaW0HK8NWikusgPbwA3k9BXom9LfrlZZavMfIxNIOZyukMGPUZVHYZDdrwHCPqRgG9qf4oGnYPrk6tJHf8Vu9FonFSTbNYOGQ6NXNN6MOZE7wpMb74MvDa+W0atSswLtpbsg5xV0Mhg9eUu8R69rcnZO7mNocc8eV6YwhQtyRiu5hBsKlM3z5r/YJX5VzPKrH1PTKSpxW7B/BUZAGVIvfhl16MrSKLSWBPRv2FOh1slouRG0y2zzWiIak45153SuyBm6Me+Gn0t0Qi0F1ngIX/XpTp8UzCiTnm0b8+/hK2a0fDIEWW+YDiq2A5v7NWvfOjLxsudBSMsbnpfkTiG9u18nnFMhEZjoDLbqVbxiE9cMiSLcDi20mg
 oj3lK3kw
 rEZKyfyBgGmTm6LPanqiP0aKkzlBVP89JXjUKPx2kmSEnJ37Nx4dV9LHfkJ64NGleLpUafIhad41SoAjQO1/smeDq5CpK6zlxgENfkMa/e0ka0ar6Q+o4etdz6m3gAoRQCTQspfdSlDf7vRQ+SCoCWyfbxtseraSF6II6iK8/MnOGPtOlFtgeLrEc9z8lAL1LzVtwmfDfYu6JOU7p+8jny0+huUDgZ6vzVdMMJcLnb7t5Yn195hREfA8euoNh+yxuOnHoOYtDFtS/ojonjpTTUJsdWwPYPbalzDtKASQDynhq0zZevcR94+qevKBP+tGCdceoLlxQBauaUiFSUZ+BenlfYohiDluvIUhfaPXmggMoKgX9tIDYgaAMjZijatxXOAjtbSujnoe3uIiqjq31OxCgIei8B89kcm/w8/jetOCixdBNkYjoN+o1BWaa5AlAs1/99Jim6gETrc6Ua+5safzt2TGXpTTfGWkjHCiC1U2YVPwTd/dudpnoonNSkRBwzl8hJZNGfFkGRVLSeUgj5C52U23i3FkhGIdFMSSyTlIHLNCBgzRMBiFAAbdG5ZSH0HoDP0BuPzNXEgc=
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

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
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



