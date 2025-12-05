Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99ED1D339AE
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49E36B0098; Fri,  5 Dec 2025 13:42:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1EDD6B0099; Fri,  5 Dec 2025 13:42:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE55C6B009D; Fri,  5 Dec 2025 13:42:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 984916B0098
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:42:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6226D13A5D0
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:06 +0000 (UTC)
X-FDA: 84186287052.17.27995FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 62F2B20002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:42:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uVT2rsHn;
	spf=pass (imf03.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960124; a=rsa-sha256;
	cv=none;
	b=DmBcG1zbUX2wq3QQvr02dox2vcJ7ef6wybg8L5B/vIVaQb1G2VvO8hfkqoGz9bZwCxbS23
	YK1hSBtGFjYo/19bxOWUfUGsSLlSz8p++l0tWSGYFekxQxs93Al5Hz7K5uN+eZMMP8R5Mf
	BqMMjpsodk6Qs4Pm4PYx70NtuXDK/h8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uVT2rsHn;
	spf=pass (imf03.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960124;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnS48bKMQsMtZCukJ8wi2xh1eRnamsascJRkL6MQJEU=;
	b=UztqY+tucdPDlqY3p0mHj6/M+1LCgsHJ0Wsi3RzCeHomFn8LvFLt6D8vLwWIudP/ah+HuQ
	y8Z+/7swoFunmEa85E/cmliISfwvd6GfrSA8Kb9SLiKO7JKLH4XX3ue/iut3wK4TW3RHFY
	Ud7duZKCBtqf2noh0GmzbKvgaDSOYD4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98B374464C;
	Fri,  5 Dec 2025 18:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60DDBC2BCC9;
	Fri,  5 Dec 2025 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960112;
	bh=pSevc+phD1fBDgaqvt0l/IWjr9lXWT3WiB8a6qBRwR4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uVT2rsHn+o/6JF2AVQy5t6bSSyTFJ+/DcCEuFiZrQzzn2mkTukNAZLx74sBgUbQuT
	 CqVjhB16DUpaghtMsbpNH6lQT+badUkIKU+9uowmBKpbv4E634CjoN9T9lmfYvzBRl
	 ctyAhKNAO9AmzPH3JElpl/AVJ6IQosMDGnAHm9pnTW2rIIgVwZSzUHH4FzzZ/0xghM
	 JBaPhjprBJLmz41L5TWwW0njqA6CI6NKRY2a1ry23stZiftSCBSr1VGjs2fbS3bsbf
	 5ijTYc1QpOA0PT6hGWApcYTbZtg7oCiInQx/2rTXgOYfKjwa1k7OtT6dXIlWdd3VBm
	 7D4lQSib8QDvg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521AED339B7;
	Fri,  5 Dec 2025 18:41:52 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:42:03 -0800
Subject: [PATCH v25 25/28] riscv: create a config for shadow stack and
 landing pad instr support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-25-1a07c0127361@rivosinc.com>
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
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=2507;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=ShEpf/mdXmXiYjxpPm2TYnh4BcOrM6EZbWr5d0sAVrg=;
 b=Im+5jnxuIPQo6DUl06oEYlBQjitdutc40AsyN4qPupKlVzp5lwfX0S6c/IstZH66/KbG6xM/T
 cGI2w5Fx9Q4BiCo7T8juXcnlGLUMnbMH6S493wuwcI0FyrqAgx5IGfl
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: 62F2B20002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: nxbpk6oj9m5umhp8faemthp8nryxsb7d
X-HE-Tag: 1764960124-408714
X-HE-Meta: U2FsdGVkX18lUDiKhkBi5K1Rk9mv/5w6oWdzbzMxTdarmeNYzbS5MmlkqBqNW8boam+la7ZJNSmIFoMMobtzP7C5QBemfVJ6lbarVA6jsXpevK5Wg+zwGnwxuxBajpCqVPjYPrYQMQv0n6ib3LfBLdim3+VQhjllvYRJou1P00bt6ajf9ElhdlEA/ttC+e3lJzkhr8J3GENpOQnrFKmYzi4cK/G/sAo31Q0Ak+a6BbcAqCpyQDcvINPuUml5/ID55uDqdRAtOjUr8pszoanrJg16rcnSUF2Fohvm1gVdEADSP55AQVibmQPwePg2iAK7oq3aRELYAM+aOacUUDhFpAV8LJooDCBIHcFu1rzBLVzYr9PFY7beTWzngDKMZ5NK+kALTZ6VkShQOEXj+XVtGEEI3/AGOq3ef9tSqGAIbA4UJPg886hd1Xmvmyiwlc+dQC83zKZ67rtYWGExiPFucgeK6lCDyqyKJCdMxh0zZeI6mcMS8FrS9JyezJQgtlZRXVzWvKfxX1vhjqYcDosAirh85bWP6zW5133HGvETBNud1KvcixiKEa5a3ptv/2WPz1sTg67kHq1Wk/N/fBebdWYnFrbnUe8r1pzIW5HB0c73ErmIMGqncyrXb51zE3agYKy+Nc7+7GnlHJGW/Xj8vccFUXHQ3JJFURBAUPgT2EcCTOR90UNmbdJNvjHQ7CipW+NSC8Gx24EzRL1kD/XFeN/f0oVxVb2oYebm5Y3af+8j5pQDspLKu2w1hH8cawaxXAJTBv0v1cZeg2+8roczII16l9L15Eif7GFSo1NWhntu2Jq/lBNYTOMPUW95uSVj+NLWArd3BfhUSasnnFVX+mjxHriUXqwDXNsLdgogtZTJEJaMYEI1mrslpTTZS3/f6h5j1VsRocO4Mkim0wNHRDXoOEl6EzShVMgIpkTvTOgFVYTp5gaNDwu1jjI2cOAEjB3oVeCNRNdcy6pvuQM
 J/Rmacba
 Tq2GTPRigt3iaW0oXw3FVvflMNIBwmZ4uBAr433blkercb4mQze9xkdoTT0bdBj3mNLZRmmAXqXb1uqBb11TdVhzEcZiUId6KcH/xAuqaASjRqYsgSSfZ8xoTZ6Xh8RCFscaKQJ/lLBWsBI/RXx/NvkKwpsUUi32y4+IcDnjvBrtwyUVs/eFkaoMN4Dlshy8LPGE6IDVPf2yUGkC1PxdZsDfNqux/APIxsNIZvFINOn3biSSeibF36a5nZc5ychWzPkQTQqrKcITrchPjomkdhHK+9Ht0bVkQklFV2baY4HXswfMBk3nzBSjRFy4ud6DXzIKTobtxebr3pvpf/nYGCLkmfFGd8Yp1jqBXOcf8jbPnVPPQ+D6qIY8PiGcccadPVbdK1IM8bV2ZKE5PSuAKt/Ax8AxNgLJ5ajiDodouNiLz9hg6N2lkDQBJq35xwxB9BZP+FjeLJi6knn/SoTG5irA5nEj0Bk8iGDtDQqI6ItoM09gUmBz/RAGBdIYAe8xr2M4GZRH2P1GnaAOn3kp5W4Fm49gzHIhMMQc1CPy0qeg6JPU3tP7Sew2nM8bNcBvhl7zjIf/0sKWN6Pf6stAvYvLakIFOe0l+Y3tD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

This patch creates a config for shadow stack support and landing pad instr
support. Shadow stack support and landing instr support can be enabled by
selecting `CONFIG_RISCV_USER_CFI`. Selecting `CONFIG_RISCV_USER_CFI` wires
up path to enumerate CPU support and if cpu support exists, kernel will
support cpu assisted user mode cfi.

If CONFIG_RISCV_USER_CFI is selected, select `ARCH_USES_HIGH_VMA_FLAGS`,
`ARCH_HAS_USER_SHADOW_STACK` and DYNAMIC_SIGFRAME for riscv.

Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/Kconfig                  | 22 ++++++++++++++++++++++
 arch/riscv/configs/hardening.config |  4 ++++
 2 files changed, 26 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 0c6038dc5dfd..be3f036e18d0 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -1146,6 +1146,28 @@ config RANDOMIZE_BASE
 
           If unsure, say N.
 
+config RISCV_USER_CFI
+	def_bool y
+	bool "riscv userspace control flow integrity"
+	depends on 64BIT && \
+		$(cc-option,-mabi=lp64 -march=rv64ima_zicfiss_zicfilp -fcf-protection=full)
+	depends on RISCV_ALTERNATIVE
+	select RISCV_SBI
+	select ARCH_HAS_USER_SHADOW_STACK
+	select ARCH_USES_HIGH_VMA_FLAGS
+	select DYNAMIC_SIGFRAME
+	help
+	  Provides CPU-assisted control flow integrity to userspace tasks.
+	  Control flow integrity is provided by implementing shadow stack for
+	  backward edge and indirect branch tracking for forward edge in program.
+	  Shadow stack protection is a hardware feature that detects function
+	  return address corruption. This helps mitigate ROP attacks.
+	  Indirect branch tracking enforces that all indirect branches must land
+	  on a landing pad instruction else CPU will fault. This mitigates against
+	  JOP / COP attacks. Applications must be enabled to use it, and old user-
+	  space does not get protection "for free".
+	  default y.
+
 endmenu # "Kernel features"
 
 menu "Boot options"
diff --git a/arch/riscv/configs/hardening.config b/arch/riscv/configs/hardening.config
new file mode 100644
index 000000000000..089f4cee82f4
--- /dev/null
+++ b/arch/riscv/configs/hardening.config
@@ -0,0 +1,4 @@
+# RISCV specific kernel hardening options
+
+# Enable control flow integrity support for usermode.
+CONFIG_RISCV_USER_CFI=y

-- 
2.43.0



