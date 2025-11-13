Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A216CD4F3F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D4768E0027; Wed, 12 Nov 2025 19:43:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836A08E0020; Wed, 12 Nov 2025 19:43:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D77F8E0027; Wed, 12 Nov 2025 19:43:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 573C38E0020
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27DD71A070C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:54 +0000 (UTC)
X-FDA: 84103736388.08.C90E683
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2B484160008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fEL7eGAF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994632; a=rsa-sha256;
	cv=none;
	b=MfVehjSdiuVDsaCGjH2DtGHjAhNElQj9pL9ryL8B5UsgLxLGnZJq6KQ4BV2d4XC0n7NQUF
	iyetmNzddN21QqCVkeXOQ9ZyXqU9TDax9xOVZg+m242fFmFwlmLUvcuEYm5rnLLUb5OPes
	U0JX96UNUX9nwsZkE/rDACo9B80RD/Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fEL7eGAF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994632;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cN3/7lOT67NnTh1CS6MpJi+T5vl6FBPHFr4zVQ9mQo=;
	b=RfEo7t4hd5c180t/MgkcLnLuzQBUiW9Aj9hBSYb3AR3KfmBbvVnb5eINKeq+UkK4p8kxVO
	H4UIoVlNW5yxOxf3Jqm8dzlOE82NP+RemUK/lBJnusVhiD2hX8zjFgLKCxzPfF9F1k5kDL
	FJIPmNjohGUhcLAHGSxywUiBoFYuP/o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B602044785;
	Thu, 13 Nov 2025 00:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9ABDFC2BCB5;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994623;
	bh=5xhSE1dBYEdbptq+ZzfRqUM3E9VQ41muuqcSuh8NhRI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fEL7eGAF6/ZbogNJ19beCwSkkzBSDuuOvOa1xeOK/1rnE2BDVv5F7aBxzp7Qpa+Ib
	 G6c8IV6JPE/65CoIYd4s4RbVr04F3GMwF3cPnSmpv6zkCyr6OLhFa+0GjCfnTY2jjc
	 Tx3aIQVS6E3o7jCywivvLZO5W6y7rePHnPbo0FAcSQzPXg8upFUkWIfh2T85vuFtDa
	 3A0+tRsm0F6T/MQykNep6Y5rG3TZu8KswHV7BKLCKOJ+yaRAqJFX7ZNa/DY0bAgPPH
	 nZQAGnX+kWwEdFmjeDJby4qqbZntMu4sDLj+EpARS+1Cc31FYSMmMONHlOgbMZBWYY
	 hKNr5VnHb1nRg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA35CD342D;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:18 -0800
Subject: [PATCH v23 20/28] riscv/hwprobe: zicfilp / zicfiss enumeration in
 hwprobe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-20-b55691eacf4f@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=1428;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=I1jqcPRPd1hxfvYCXrKsXB3tX7WWaFK9J8/4Z0z3BE8=;
 b=BSt08YCs7xLBEQT5dpuvvAu9O+lBseVVR8v23aYp6HASGq+N+Px2GXx6caHvfA78w1sX3E9Iy
 9Wms2FWS91kDG1CtC91i9Bj3d9R35xFYEBEB8pDKUt6nfSOLPuUzNrS
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2B484160008
X-Stat-Signature: kanheg5h3qzqgjbjidq9c885r1mcqhb5
X-Rspam-User: 
X-HE-Tag: 1762994632-826893
X-HE-Meta: U2FsdGVkX1/rjsKGaxdXHqN2/8ySoPZgIl0HN+ggawKppZzl5rp4fj8F9yJgGiUkx/4MO1N5DpQtn8nM0OT4bHPTpk91WOUhgGqJUFg6nQvWhS9qHqPU3JZlcrd3WUA48smNxs207JYa+xJCFvhsHwWp3ezylkTzFWOjYUnA6Nesd74puP7w61tjNlRXvitOdijvVcBRHimzRKDEA5G4x+fQ1W0sdUCMt1lJ9jtyYCoPFVQ2wjBGwWmHrPTpzigYvq6M5J1LlwQSPPMSO1jjvcMq7I0rZU4GpdWrz2CjDAh5EZvhalHIazdO0YeA9I1l+TMHS9CTM/KgYqLF2E/8Fs+hxB2NXAWu08bTW6gG3XCcW7hxM7PTdZYTUe33CIsPwWhdff9uZndCYypbC3xRwLCuAd6y4KuztomNIR4QyivlXM4R730Y1NLR9eJ2614QFHI08MsIbn/v4qvcolHZOA6O6D0xw3PUdFUyPI4GEapmaNNNLUXeZ/d6xSVHTHhkHhenm2a4OheauBEizmu0dCP6D2YFfVsUULtW5jeD6jyC3j+kHU1jjsHd+4DXx4RbFShgwuQL7x6bx6kkmj+JsoazjYG2c5O6UOprURYthG2ejvQ4MK+4fKAAyJw7RGjhOQ7H6drGeu5nnWUfrDxSgBCBHzE9WlOWWnGpmXGpFX/ZSkCb04j+s6Me3yLnKLYyIS1HiHp5Wgwoq7RhLbbDd2Jd8Ni+RMQlqpfP3090bSmXU9W3Dk2ARmcJCsa6O6D9yMB82OhDLOEtCfN4z00Lcr1ZSTnymbFTRgzNxdNABEvlR//FCQFjO4N01LuHOxdXDTBfAY+x/c1gMosMlp7587eUeIpTygYDWgDiHBqPB8BrF27dnZE9Sud01O5y6ELKL1gzjMYIyN1UlEVzV8KKGETPN7mM5vassjvONvU9VI1I41aNSW5dswgLKBhtWc5TK15oWf7vrNQg4+i0K6G
 W4cJ9cDk
 OtwntUahk0M4cBel5U4T/THtPryA1q3+TVjWbwgj/glOARU3FpzLWwLMsqS/d40/SPNC451p3O62o5L6O11Pez6TTQHVosGjgttqLpSPjTn05a/AeEZ+yLnehIk8TQcIiUseFnQ7B6AE1ILkiFJqv6PM1kY35Q0nQSs2OlkTeMHASZE7DKEq0yhYkZKu0KGNiZ8JBmM6DhCL91OCCQaZK0enrkjVmIyKEGpeumIOsqiwSpAU0HQnbqXhAl0hc09KrxHZj0KRpbpYKQC+JZkPe5yIzoE3rk4RHRBXmbs0qN89WRALgLH9qd8rjXxJ2vBpkKiHdv9LU8Y/4Ge3787ubceS8samnGrkgFcbUPYm3IKdtRwVy4Q6NQhrUXJXQ+lRQ1PKjlm/v4nocHhveJNbk6R8YjTSOpZtbl0/Ns+5Gby7djg5R71ke7omNF52jSXvwEgW3nHxMFIWVSa8aR7dOp0z4QbPjYJakueOziSU7CLD640QlAVzjhcMrESbWecttIJlsXMH5Oo97W1Eq7q42fx2UHFPw9Z6hLKp+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

Adding enumeration of zicfilp and zicfiss extensions in hwprobe syscall.

Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/uapi/asm/hwprobe.h | 2 ++
 arch/riscv/kernel/sys_hwprobe.c       | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index 5d30a4fae37a..0efc9c7d1199 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -82,6 +82,8 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_EXT_ZAAMO		(1ULL << 56)
 #define		RISCV_HWPROBE_EXT_ZALRSC	(1ULL << 57)
 #define		RISCV_HWPROBE_EXT_ZABHA		(1ULL << 58)
+#define		RISCV_HWPROBE_EXT_ZICFILP	(1ULL << 59)
+#define		RISCV_HWPROBE_EXT_ZICFISS	(1ULL << 60)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 000f4451a9d8..d13d9d0d1669 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -114,6 +114,8 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 		EXT_KEY(ZCMOP);
 		EXT_KEY(ZICBOM);
 		EXT_KEY(ZICBOZ);
+		EXT_KEY(ZICFILP);
+		EXT_KEY(ZICFISS);
 		EXT_KEY(ZICNTR);
 		EXT_KEY(ZICOND);
 		EXT_KEY(ZIHINTNTL);

-- 
2.43.0



