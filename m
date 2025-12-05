Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98531D339B9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58F8C6B008C; Fri,  5 Dec 2025 13:42:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53FB26B0093; Fri,  5 Dec 2025 13:42:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9996B0095; Fri,  5 Dec 2025 13:42:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 265716B0093
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:42:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7CB4132E3F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:03 +0000 (UTC)
X-FDA: 84186286926.14.CD726B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D046016000E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fYLkGLP7;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960122; a=rsa-sha256;
	cv=none;
	b=cVUiPJQjOFpsljRyIZNXNJJNQ5ZlO+1t+mM8APHGyfvhX1HjpKm2bAkOnocGDpulaAyA2c
	Pnt7uiq0qnCrvefL6By5FcU7Sru1aVE95I9SwX03omU3CeWBSIyyhFU1QjrA38hGGa4hTV
	h7iHugwAFk/x0Ho+f+efwcwBekbgvzo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960122;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iECMerTAUVLGlPYW00F3cIDorrFSBKHkEEaZ/glZpso=;
	b=rc9AWI1y3SZQ6N1RiRpjXKlLuRMv/fNqkeFwmpjAYIFMje10dmH93jQLj3V5uQKD+TH4vy
	mZDgnz85QExeUN3YLH8113YMzAJqYt9ys00wSF1xsI02AjayhtDN2/V+eJrGT6hj9PwOpB
	+SyvFgSc4XlY8736R2MHPKgSfrsFF98=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fYLkGLP7;
	spf=pass (imf08.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 381814460D;
	Fri,  5 Dec 2025 18:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC188C2BCC9;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960112;
	bh=ly/QAA/61Anju/BdG7scvRW9qTC7lOqM9OgO/9B56Tk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fYLkGLP7QG4MST1qJWMY/lO1dQihSTzN8xUrHpZNtXZOObjR6QRGV9L3jBmxRfM6U
	 QmZ9551fPOz+WTp+CKvEhLY5g91W0K3s8vnk/AspIt/ds9h7KBr8AzVQGLDxnAMZHX
	 TZkbgVHC3Uch0oiA+CJTSohz+3+F9TFBec1PJDALfI4X0KCuuBjLlI7HbmHK3rt1Tq
	 tpjy55N6Z7DTOoo6FKNRtdEcy4Za/999+HL3YZNHshMxbOUOiFQeCvRc+xyaEltMs5
	 tLrsEpUz9J9IaJqrdQ3NkG3AHMdmHNX+TgNMtdLDF445T41KSyOHyVycKTxSN8uIjw
	 +LoxXqTB7HaPg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C73C6D339AE;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:58 -0800
Subject: [PATCH v25 20/28] riscv/hwprobe: zicfilp / zicfiss enumeration in
 hwprobe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-20-1a07c0127361@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=1494;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=2JmRNzctibGknEiF/lJdumXBjnp4QWFhVuzyNKM/ZLQ=;
 b=iAMJytv5AiKmMhM1jdAOkPwLYhrQoQ6RDr6kVcqvXCzllIjhh+x7xpSu5Wn/WvI0yUy+7DXHr
 ofdbTkVpWaLDeEt2Omkxwp+WoVWtY5cDCJy3Y1iErifoLKCZE/tOedh
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: D046016000E
X-Stat-Signature: uihiiisiut5em7i1g8g6cxxgjo9urm9m
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764960121-332715
X-HE-Meta: U2FsdGVkX1/L/Xg0jv42+hh41cMsxnlyeA9fY36OUwzKAoP0JqQarod6XSliSQJHfvMRMPcJUVyKBVQ3slVFpbN4iWLMdi27ZoaIgLzar9H0bGivk+wM19zGpCu1BBGJB9w7/IvSfQ3DfcVoyyL8PXHy9l0loBfJc/c/s3XdrQcRhjzJdpe2azCxHQRvlj/uV5S+ieVHIRmZcaLIXAe/y4xj9e79wOYYcwl5rtESQVGJFIs5Plw7cwT47Be8+JCoq3vxjNFfHfoWKuOnMHrEFlk/Juxf4p1Z+brqwbATb257iqdhHgm10aOQmccvYvDm6ZirtIk8KoaEVVsxnCboDLMVRoYT4RYIEkoaBjzrM9L+2VeOI+lxADUCSreWO5FJRAr3SYpQieEytOFgVOB3uZBbKCZo4Zr0SCoarEExHFCt/O5cfsDDwY8gl03iHxYe2iAMqg0wrEcPbuF0KvTfd3l5SjSKUhfn8ycMzYiTJMMjJFNtmpMqIS9ZSqvK0nvp8BxnhAUWHnDscI9E5dMkcK/SmPHFR/raByy7yat4Ba9WAEU33UmPaEyaL5HPGvLFOxW8bk5FMqImdVS1uiGTfxtX2SizVmyTELdm47RKvq6bY3Byrss97wUghKaXwMe7zUfZp0OQf91EZajnkbEiUgcpK8oCWKw7mBSfVIevTIoA7BDYBKqoNTzb5b7gas9Wpy6nA5kafQJQjOJ0I2Z93hjMwrzd57EDZD9T6t8JZWWZ5kjIoIuoTdZQMNvO+PONG3K+fev3hokUyjPSJ4zdOZ75TOE6L1kaZaK3LtinvCHRAEE6trFsZMVh1R+tjz1sa/YUdTnsmT/apVeio99IB7J7dHWAWGDMhRKzPSb8KA/UKvpTDaoglaL3NV9qAwyo1WzH1hThOUvKFbg3JMsYBNQdSkaD2aAzMPCL58ZaBAVb2NBsBAgiEK0OCLamel9Vuw6edyOs3x/RmK5oofA
 +0oHM/ZR
 cGC4LRQxWlFZW3QrgvLirN22fVEQCH/8aHC0qnEtKov10ZTEzOaxYSVCYlPS1lrCkf5nR1/Pn+rl/LV8j2Jx/wten0jxQQuug7EnfmR48M1tVTrx1pSxkPQ5hS+bOwv8AKZ43sJiyrD/m6A11Q9htFEwrkGjU2U6MPeYPF2FITWlvVRJywZsJT7BdaHWa06XiH7Tf3s9jSLhOQtvwBaa/nAy1by5T6klrjU2sqvRs5NUuAT2ObKEz5egXSkRdWa/r2uxw7v/v/v+TzdjLx9P5e+NR5tAHaAWwiQ9OYYWcqD09ELKGMKiFhrLfP917rcixzbgsPiMsNGwReNx2PciBH2Rs6KI90P92s8Micy4qGFJkwXxPyE4A4Y95Ll3obK1ukdizeWQzdY53NwMXi3hfmJyRKpWc1smmhHRZpfEO7uyfaCG0PbFjpFDOJ7JK1q9K8+AeqxSHGaaQ2QaMrrLJM8I7ZK8of3BI/RkpvGD4G5n/e2V61IvTNBkd/5Qkc4TBAYzrFDYp+EuFqppEJWi4MKGYNC9HoEuKNRI5Dehu9F3F079CedCeP6Gh4GXZeLOAsOE/1EBfa8AoBL7rZnj5xGeeCFQCKasQz50y
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
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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



