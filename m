Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F09ACCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40E2B8E0024; Thu, 23 Oct 2025 12:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31FF98E001F; Thu, 23 Oct 2025 12:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8738E0024; Thu, 23 Oct 2025 12:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEC938E001F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD4211A0BD0
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:24 +0000 (UTC)
X-FDA: 84029969688.20.FA9E9E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B4C5120003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIRo+BOY;
	spf=pass (imf03.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238282;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cN3/7lOT67NnTh1CS6MpJi+T5vl6FBPHFr4zVQ9mQo=;
	b=phUgeLbOXocfK/mUkOQWJ1BmvsdtU4iPlY0DfgYnlKYgzQ/ZXLtCkYs+FhJvYblDrQzLLb
	p7RYdQ+n7wbESaj4/RwxCxMLnBkHHapr0QqZ6OvrUXjgd9+O3HnbCheDP37tCwfr5IEGtU
	D2Cq8NOA25IJqfCnZWMxpjvkoM8FJpo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIRo+BOY;
	spf=pass (imf03.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238282; a=rsa-sha256;
	cv=none;
	b=4K7qJcwgoZSO2Vv5U7O6/OW25EAxw7i1inz9o+KYKB/U3VV9BPWyphSHZSvHQOfsArbU9x
	0BqPY60C6wQlVZdtJR2xFtWoVIUSkBR3grgSaA5MGLWIsYHgMzYSo2mFpJJSEJJWJHXLuG
	AV1PvGAKrn/bYMC0LqAXhE+1g/cMc8s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DBB24B11C;
	Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 130A6C4AF55;
	Thu, 23 Oct 2025 16:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238272;
	bh=5xhSE1dBYEdbptq+ZzfRqUM3E9VQ41muuqcSuh8NhRI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VIRo+BOYGmxz5DVSoARHWnB7a/DnuublOVSi03w6xkG+/pjzW7FsCqw+Rpys9u8S0
	 +krDDKoHs/ptaMY0Zq8kXVcm/BKX4Sbon533dy2RTpz5wjjubXjEOr+wUEjDBUwBW4
	 KtiUcd1qictohWq/hFIAgfhqsw8hsQ+LoQz5IDhKbPtAwTXKUEoJwIhg/ShLCWVygI
	 mIX53R7cEm/ofn4UY0BMXhgyP/MKsnpZtsVPYew4sGou9MB0Ei+zkHKvvgOaa5ogXn
	 k99oeQk2zVt/Q3/wW7H4h/f9h6+vm/wzT9qTxlXc209CZ1EQcascs/OeEYgjGv+kkD
	 M+lJrdxVctrrA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF4ACCD1BC;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:25 -0700
Subject: [PATCH v22 20/28] riscv/hwprobe: zicfilp / zicfiss enumeration in
 hwprobe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-20-1935270f7636@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=1428;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=I1jqcPRPd1hxfvYCXrKsXB3tX7WWaFK9J8/4Z0z3BE8=;
 b=xCBjpk/iSQFbeSy6+6gIPaOZhBCwwQccR0WZSjcuz9R2d+fRxs75EZfgTs1Ck7ISXZLfk8/vt
 1oOMYt+JiMSBeEnQK1MaOTY8fFfWj+WwdKJeydK2u38ORkBYHCZRvTH
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: 5ch9nmxnxkiyod7kmp3zq8b8xi1msgjf
X-Rspamd-Queue-Id: B4C5120003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761238282-920201
X-HE-Meta: U2FsdGVkX18904Uj1oO8m6SzMH8y80aBxh7MOY1fJgR/dkvEC/xS/EOXpXYH8s8zOSNyvaKm1X8V9FANl3PInrmFWNWa4sAc7N8WdjsORokY6221BNKGmhCmD2WuTRjitFihGTUnzmtQ0mtttTwAkr88hyAe13LM756m2DNG7yHa0nS8h3LZBV4jFNQcAMB35PKPiRefocDqmfCNZXt9AZFMrq6ix6dPrl3OrJpCNdQqleV1UNMQvvmdVPb2XiA7TUHqA5ceL8To2UBlbTDXjxO/6TV9ex0c4Dd6C0CsVacS99okZnHCP0Pt5XTc9qNU16UViVAgKTyeb1L70kwUQOMBfv+fh+IrAKUPOPhC74KBkRYVhq3JjSMV0pYJR6eD4NpYw6mj/iFeA/3QRVz1W9SuiQtLCqAGFZWsLV1igeToX7a7VicxqDst8SAOAqAv+hIu3GoWvTFgBWUcZGDPaNUDbLq8AxH8Tu1PB2NchWDzobmCpB+5+11ta1MWIJnvzEozVFKrGsHGyW7DlbObGzf5kBOYaPtEX4Wwwn6bQWPWZ16xhrXkYh/cpHNHLDGgszDTz3gSwYhlpwSzIZP213IPWRQQWjPvdgN71oRe8dcfkTIGoNtEGC8L1LnVJhbtw97nTswMAFXqVR6DFTl9IO7LPbvu+X8fZlDVrLDM/VazSYFnBT2dMn+LS+bRuzbJxA++E44BQZ1l2mfbnVTUy5meTJepAfO5xRKMlAHzXaJU7cc7CxeE4LR4cQ2B4xHaKRdg+jukovsE3Ces2o6UDpJybMN/jGLJqankplaGmhhjFyT1TYB2Cvx3eG4z6vPwK6R6lHh1ntlvV88g77ltV2/w+YOC/fjVgx/2yWRlmBxuP16hJEo+mz5/HHq3aZRacH0uZ0zmpZUGaXCGcIaDFCs5zCZImbi1kKXISnRGO5r8yocgQicZSGfylji/WZF4S+TZKvCBaZBsgtlWrTY
 w4u3gjJ9
 AZJYSd+8dP9AlD6b8rLgM3qbgwOdK8pxl8gVveEfWsdb/+A0erQsbJ0cm/RHj3aLRtHTdYKjSKAwnu45kR0zg5ticmVWlw70JQLJAoxH9qBYBjTRqgIHdwTYpuSA5bmhhT+Y5Vw2C7Xsbb8j5qfo0WqPvfrrxgNdAwlhTZoPVYVuUhMH1e5SFbdV4m8hblBpll8vS4dLpg1pwQxK+DX/RqmKTgfHzJCRJHcMFmuMdnZxBblWtbZZz+81lFITFZ5mqw4IToTT1ekdQu7u2ayxjfLvwPvshFiWgDrlNoGzBiVtgMIueEPPp6jpVN3BKKk+guXLO1d7FVjGQckXk4SGIO5w0hpJffnrTGA4RqRFh0IMpJJ/h2GC59qm+XTuQp9NUpbCe1ygHqfVstbhLITY3KkaeXPEyEIMOrdFZLB3+VtjmybqWaqaZBZbDOmfeR94SjZw0DKPQRTqFrKCmlLjz9flvXqjkPrq+Sg2VLQkoymy6q9pgP1td0bhBnKS1RqqADIQzr/D5+gNE/dmn7LuqzPPR+5886yUXyp3S
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



