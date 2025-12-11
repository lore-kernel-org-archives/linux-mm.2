Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12EDCD41D74
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2346B002B; Thu, 11 Dec 2025 12:21:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98AD06B002C; Thu, 11 Dec 2025 12:21:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802FD6B002D; Thu, 11 Dec 2025 12:21:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6BDA56B002B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 388CA139114
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:18 +0000 (UTC)
X-FDA: 84207856236.08.948246E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3D85DC0017
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=joQ2+ocZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473676; a=rsa-sha256;
	cv=none;
	b=zfvrsHCNvjVY4sT6A4YeexUHHLcSs9OOK1V/gnmkgmtLYVqXdeqnzIBQOYn5Fq+pEWxM4n
	Amb3Vj4tasZXidq/+TWMLZW8L3H3I2QoMOtTKG0J1tYEyXfZ6xkt2cDiZZDxc++h8cTozL
	COzksYOIlRrCgbEG0Q4TLLIBOG3W1WQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=joQ2+ocZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473676;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=llOUb7S1/3qB1K7VPVA6sgsbeQ5kMd3KBHPwfrXybNM=;
	b=peVbX1XUjgsTpAxv6fq3w7guuVXRSTRK7TN/D5ChR23HM1opdhYHVvk3uCc/vI9hXNV5X7
	StRXRzmAM3T3oaw3VqJtTF7gspZvAB+vXJk0aToNRbA9OOKPOKePVfHb7Kkn3q0ULhbMs8
	U4nvs73cAJgk9SLd29RUzvBjADv3Tbg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D75E44528;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48A31C2BCFC;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473668;
	bh=gKj05EfXWRzFgsdHcGDwkowJM1p6i+3gIjza9qiTqkA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=joQ2+ocZmDicQ/80iOJxvajr3vmQx4nRpb5ckojsPu9lwQzjp2YDYvIE6QPlou39S
	 1LyZ38WVb7YMa9Q2dDAoDbm8Jz3srPtLnoz7tCa06SEtQ7HR1Bmz5yP8PPpW7r/XDW
	 6h0Pdg4Rz3ZLJePZb5Ot2w1Eyt8+YSWpd58FNbQ9jwcga3ZvmJPQlQrwGgb2YH+c8C
	 6QqHZ19S7Ci9j3mXfGa7saRyW+J7ogeQFtTROVd+1VLtpzQ+nWl5ODpw3hfqCr/A/0
	 L2u7qGMhTmdgbmQyMnh+EVZ+T2UZig3h9TiMl+5edoeKSUDJVrxtaxYnAEB4lJoy2t
	 i9/3zDcuyxMAw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3810AD41D6F;
	Thu, 11 Dec 2025 17:21:08 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:51 -0800
Subject: [PATCH v26 18/28] riscv/kernel: update __show_regs to print shadow
 stack register
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-18-f0f419e81ac0@rivosinc.com>
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
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=1182;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=XI4ppsK62Fegg41RmjuRUH5R6YykPAMiGtdfLotNIGk=;
 b=ettTKylRb+21RNIE6aRXlLKnCuNPUmzGJLadoF6KC5Cj1C8lsSzyz6HZsSQgomqLUbggJk4kI
 9bhNG1WlOXtB6CRw8iiWSpE8JrYyW2IuNIAq4YQ5fBFrO1eV7PpQecT
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Stat-Signature: pq47oectofbrhzbmjriw8bd74x8zrgsi
X-Rspamd-Queue-Id: 3D85DC0017
X-HE-Tag: 1765473676-438383
X-HE-Meta: U2FsdGVkX1+0AdQn1mscjPYdWGEUAScKOvnE8GfwWICmhGZElm59EZ3we9NWySIDellQRvd6vv3FfxmOBmskNvO9+EzZTSGsA2YcSleU1PlxVtha79iLbiv8WNZ+8YmlTrMsdOHAMMyWE3LOKdH7MKuSYVwPbbaCLFyeRoVUH2Rm4llu3BiKa3nf6XE0lOXGUWRoSOUB6QiS5e9ZWsWuXwYxpdO3hv0NS+FfRYFFyM9XPav+OPkhL8TqgmZcGXnXerH9fXxzOK9gnmaYqUBUgo9S26wxgsrpKs53Kd/5Ij+hoSnx0EvLjiWH3vI6U9siycDgsIdqX0lAzd71SBJ3QJHrXGQMS4cLpcPYZ4cl87SYpHziXrf7ex6kxGdSI/fQLPr6j1/qf0GRLwZz9Ge5AinoaXp6vaeDBEvu1hODrRM1EVUnHa74F3agBLOO1CmKIbap1rJ8H34Ba+XGpaUhM1L5Ze9rmIQUrQOLt5lNAS0+xliLoBEU7o8aoTIW6GStipVp9rqgXzltpRAhLd/AUrpAgQ9T9VlBrArjKsmIBAkD0fv/eGHaYdh/Q+q1UIziNbV0iUdQt31VNPoOcMlFBeeHjMPHXahdeSPNILjw4LsCIhjF6rY9YVwHgnnaN2ltRKOGe8y+XhI+/ZDvYVFG+SzpBYts+Ap7AxgkkYJPw8Nb6gL0YFKxsZS/6OGBYjEBbSKbCnz4xdWuLCHeBIREC5aQlLzch0rvEr7R6UVu5VlWfLvAh6CxgxFDI+9+6s5UiIV6ttwidbDBPqbGtrwOgrF/rJ+ys0+KCTsqI3QQvtDai2AbneSSfh9juZyl2hJvRdX1+dE4b6P+cFend28F3WBbX4FWQXEYQUqQtz8SIqS5hg8BYgzXt9g+1TzAB0aEO8dlY38oFp3dXq6srk6t9Rgvo2InttMws4ccpIA84NpHoTDcX385rQFfmepceeB/3GEfzlMpXFBP2Kvb1Az
 OVpqZvqo
 w8nJF/R/5eOtjR9UnBUtIdMkDHuTUFU6z8K3SXJZJ1/wS2MQQY/HMuzjgD3jr0OsmaWkBtRRBnb1S4xBc2vTF5FF5ALTJ/Ky/eFLmtBgNfGTHlrhRVV2+0eGQUlDjBF4LYhflCLAeKnCqDIeXBPb2psCvxDneQXQer0IEVhM3w5elICpYQzwlcYmXJrfzGt4OhX9xU3C7Lcd3OWXixc2NvZLJ/FhNxLuX5twAs9U7w9HrYnWFMEvYT1sk+55nbC8AJ9e8Q8+Na8c6fLTJm6vBrs+7OCx3X2ce5zCXtT6IB47RGxNwKrgjx5w47+bhEoll11QoitXMuFRBl6D8LQjM7pMv5J+Fqe5ttgcndmUDj5wlEV9ZK5dTfUr/X+G3gLYHInuEHv9fEkKWWZkKqIbO+PWAmJD42cwqohnvbAEQb3c8FAIkvziM00Hy1XSosA8oXLGf1OjgmU7eROW6PnsLJ8SYzABhVWGjC7XnArQSuu1ahVoC0IPt9csFgDx63LlwdP3T19o77ZPv4n93fB+At5SuNgaekMj8lTpv/FNSiRVS3KDRwbS0KgGnNsPogYoTVR8KpFVVXAgwTiI=
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



