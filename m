Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0E0BD339BA
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DA806B0277; Fri,  5 Dec 2025 13:41:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B24A6B027B; Fri,  5 Dec 2025 13:41:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659136B0277; Fri,  5 Dec 2025 13:41:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC6E6B0277
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:41:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF4DA88D18
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:53 +0000 (UTC)
X-FDA: 84186286506.05.BCC8AE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A850940009
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dC/TljCe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960111; a=rsa-sha256;
	cv=none;
	b=j97TAA6d3hC2tt8rDZlKcKF6fZtE/I89pKhZ5iwokAGfH/wpKiylgloW2RXg5BugPv0KtB
	RA50Yd5j9S/SJZhhxkZ5TOuNj6dcXqkyhnPitU8H2NHFzKRZ+IDCRIlb6M+zHs3wlSJVwM
	7mGX1R+r5lChibD8QExyRs9pie2PZcE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dC/TljCe";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960111;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbxuP9nsCV4z7jt3eyxaq+Ns/mHC21kqlVx477mm3+4=;
	b=lJOclxoKHKffo6S0BNX1m+osS62ZZeLC4I7CJ5HzGWYA9S5jcsaTaHTRDzLjO80Oa5TbXy
	XOgvptVooOL4iaFFRaYabuHKbS53nXUCJxpqzYO8BFkM0EC5oM1e4ClASaRHyl9jGHXBD0
	d+aYZwBa3Hc72L92VO0DtwY0VNd5vU0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5981A444A0;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F14AFC2BCB8;
	Fri,  5 Dec 2025 18:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960110;
	bh=s9Nd8OrIdmTzTe15BEE4fAoU+yUwpq+wRGim3URhRCA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=dC/TljCeQTmM9QyTTClRVnyhHyedBNDcIxptohaOTqiV8LlbLmPwB+gLXYwx/NJMQ
	 0ozNHbgWR1CIEoieVP+Ycu0cD8Pn2tUtZq+MI2StKE/Bk2edlegkfwxfoWr+3Z4LYz
	 h7hTKSY2xbi3gyIV9+4F7qoZBgmOBHvbme0Rd/7Q4j85tvV5wcYzcCYCz1vJULO+cy
	 EnovN3HVYNHRGCsDYjV3KHhep9zDQ/ZEUVXILaKmvFc66ZsH/W620lz8tAReypXVJz
	 RhKebo4jqKHXTyRE2D8U8+80o+ggvfJp4BwSXkknoRq+aeOJVDH7jkFLTaAbbNpHc/
	 rkkxMiWRWxtyg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE98D339AE;
	Fri,  5 Dec 2025 18:41:49 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:39 -0800
Subject: [PATCH v25 01/28] mm: VM_SHADOW_STACK definition for riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-1-1a07c0127361@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=941;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=DXRwVlzwdoQZD1P4AgHLEInq/8iOZjrgGgTHzLAJMYU=;
 b=YaFqIGVEEgAinBOcot+5GK/TIE1JWkV3ZOIjMlei3bYV2a4/QHRD40EpwGyWa44u9/gPioyqW
 EZmD3ziaznUCm1eIKcb6LCqGrPqgkz8sk0QS63UwyhgoGqEP8uYLx36
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A850940009
X-Stat-Signature: 3c6p85gk9jjbyfwj84njsrc156da84o7
X-Rspam-User: 
X-HE-Tag: 1764960111-144307
X-HE-Meta: U2FsdGVkX18yVubNHsGEchCUZ5fqAp8GjRoYRSK72jzpbu/PZEn46dsCP/cRUPMcTtEo7658CxqUk9+BLDFq05aeTjoDAu3lSWnAYU++9HjR0JcMGQlZcXwTa2UVc4iO6kc98A44z9Rvjoo4RKnFNeepa6CSQJC+HNZKQqq6craKJJ3HKl43dEQJbJaqhorjTRw613POaQHyrfBJvnjxGVaXCfSj8B7hTSp442cyplIcrSfkGXK4bfN8+a4bvy1UcCWv2dRY0Cbyv5Jl6CeI4Rt99G00dtQmm1jKdlrUVJlNT+2lTGkuIJcYPTFX+j2FNomursd2Ea0ZgwCwnDYQUmepltV4MXnETmiX7XKTQhB/HjzCVhiCy98bdTpFLNspzOz2rQ8nDxgeb3lWjJJacRGsS6co4CSZwZdOaj6Y+BgX6H+BkF27VMsRrBJrsBvs1BP+k8VuToAYkNZY3s1yz/ligIH4fJlxzk10021tkHWLZXCgxE0MYrLMstJTCRdqHH68mxMPOIhjWhrU9M362IyLqLH+S8XDBmaLcMx9y3vfMNuO/hmhPx+Q1n+kga2qZjo6nV/Ap4m9tn9Mwo/TZuw5R4ubs3Z80YR3hM7H12kWKmeDkWJQtT2AzQFl0mp89jX3LMQDuvC2SZpirn5MUjGScOVzVEzIEaZG7QBcK0IKnXMqFSdAmAKxciEASF6FuL6+Y+UFrImS83wX0ND3TAGTxEmDdm1Xjt+akpPfVl7Gr7jVzsFv4BSKH3EdQMsEro8Rl04qQ9M9Ws4pzULvLKFjBoQs9FLMXamG2g17AJmjaw5avvLGuaV4qSPXeI7YzWRej3pOCuxE5Qinor5UjHyQVEdHEX1i6W2V5GIVfKgvTlspBMoIbhBrIllyNNG97RH8UGtOxzi85VbqijiPh/uA8iW/K8vtvG2YheJRAGSMjTX0vm5FqGTe0KEchI1ciPchSau+lge4R+1GgPd
 Nq6bZB4V
 FA/wDGkWWm8bDO8zTwyLc+p5uTODr9NiNv6DJAsKZo070o5JFM7J2PeSKGO8ZPL+dOYarKRBMRLWk8ilocqzJUk+U2xDYzWyJI9duolfPgI3WqAjL8/Ja0frOvNJV1WtUV3Zu9841cWIXKCAEsVBcZ3/MUYigUx0w6Gc+KU4Xz9JvLK0OdgoLzVd6AzUeLYxi95oYc++naz77pwwGBG6dOiCjpPT7YUc1ZV7vTCe7/Sl2YMjQbSTcxwMtITyIkjL9oAQv1cXexs322qo90ZBsGcj62psWzRgcDkDYpyilEj74NDf0LHMLYxh9s67kCnbUCYWVAa2nWV+WqKkbGKxkAPRiFo1d7l4bKu9VZ07U+FIy2Yl24qa6LccTEj0s868PDJDZ4XQaBgTjpmNmsYerDp1hwZG2rKoJTtMf2oXxvXW1HC4wnR5UhP25C1C65znk0mMAduQQvLmRRCSZOJsqzP8u4Ls5YEGwieQxg0K1+0DXh3x/0iCH6/rCscqt43vWeMHuc40/nGixfuNRrx4+CqfiMYEUWmuP8IVbEraZ2zo1VXA+zLQr4Nuiyr025im4IYe0Gvna1Z1Xwo8xfmiWTk63aelKCkqvhYpKnx/qGknTk1rABb+H4TqaNBh10RokWvCzTAM2NV1waQvTy6CUoUgaTHPlRqJlvjL9nOqHXSRAcqqAjtL0BX5TENpjVGkVze1c
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



