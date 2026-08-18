Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F2E2C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27B386B07E0; Tue, 18 Aug 2026 10:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252666B07E3; Tue, 18 Aug 2026 10:12:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13FAE6B07E0; Tue, 18 Aug 2026 10:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E837C6B07E0
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:12:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8208DA026C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:44 +0000 (UTC)
X-FDA: 85114581048.08.6E7E9B0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9B8A580005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JNpG2ISg;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/6AdaurJomovgQpuCT6pDJ8BD4L4GObzjBxl5R1J6g=;
	b=DfWVKA/7m+gyKZmoUO980Rh+vm7HB10D/5ruuz+X8aCbpHDcBfku1TZ+gbFAKzld7epsU/
	9GHV8BrS3gBmREl7XzUWe6N/w0Xw44uxlQyOaiZrwSnuMXjvKahagIOpsCphko3j/vWxrf
	nWAXiyIR62/CIAPv/ztlfNSdNxJNGWo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JNpG2ISg;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062362;
	b=fKfOlozuhWn4Jodb5t7v/jFmjYFEnP/UY4D+RJy+QA2VouAunvNpO9Uc1gIwqUssTnpn1S
	VoLwzZOq0NPiKot6CxGDF7amoRpP8h9Qsz+3y4OtFBZFc2HzhBAn/vjP8XYlcnUO0pgyuq
	ZgtjLV33WaAkjT7TC9/ik21qhgHOqiM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D7A7419F0;
	Tue, 18 Aug 2026 07:12:37 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DD243F85F;
	Tue, 18 Aug 2026 07:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062361; bh=qzHxEWTQUowU9JyBpIleSksX3kOfPSpORtiEeE9vrLo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JNpG2ISgeXbDU6EHIpC4+0vrtGwt76HzvdOMWRTJAj6NAn7AdafCVjI4bRyLdR7jT
	 k0/aB9/MNBOsf6E2gupjWaYFBzzW+O89e7lXJGf/Vb9TfdYxpuKtLVnJZvWZKkn3nZ
	 iJXjQ8INUF17DzLw/BKXa+K2MQVeJX1Puvb4yHLQ=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:58 +0100
Subject: [PATCH RFC v9 16/25] arm64: kpkeys: Implement
 arch_supports_kpkeys_early()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-16-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=1895;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=qzHxEWTQUowU9JyBpIleSksX3kOfPSpORtiEeE9vrLo=;
 b=1nVIMH/i6iHZpxUI1TCtH+LBvwdmacwViJE9z2ALy5M+p9gUos6coUDPLFQlFXAV0qE9Z2b7Y
 PCCxFd0xpn0BsMdhASbsERLqg0Gj0WrHKqUQ04TKHxLK06yo1rCDmho
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: nhd87mb1pabnkkfcwzzpec3zyjdmj6je
X-Rspamd-Queue-Id: 9B8A580005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787062362-395180
X-HE-Meta: U2FsdGVkX1+b/bfn0SXTDmgCCzlEa2q1X3HrXfBujQj/h8FiamEmET7i/blz9OcogV401HSxjRmMAqhpodYLnc9Fwx141m1WfYwejxlm3EHWHi3rfQH2jcSXVxwh1sRn3vDihF2Njjh5G//+PNy8qYplAqUYn6m+YUDVEBhSU7cPkSGRJG9m9FZeaLr19GApzMbMfcgBPHXlS3BSS7ngPc1Q9m5WJNOn1Qu0Fu7zo/1Ogujk0+U1ug6GIlVpUS7F47oeeuUHvn5tvnkXyAw7RVwVmdWCFPtiDkGbUCmLvYktlX6xG2gEyOVnGuELNz2Gjn8CGt2KlLBaXVI6YKmRcPee+IcXyTeaHnxTWBVO9D+Tt5V8FqCFQ1BPJD5B6qk0mszfR89ltEjBYzp/LAaLwzuSiAHVg5ZuBFj88vvdmFFlzWFq/pXYXKY8LERgAHxG0Sy7WnE51r7dy89+F7rWE+wRTOMS2Fa/3mJx4g/z+lSRYwgqgBzQKbd6YfvFz0n0PilADBfA4TRiNjsMu2Y7JA8CyfqanW+9VoGbUsnD6fuWdLjBREmQXazJKjAmIdes9R6tGxeHiA5A9au+Gro171LGK2GKv/wgUAaezFzBtwXM+6KbY3ivRVVyyrPXy5VGm2DbcdWYRBrFbY0hZjjiVwWGMKsTYGsKswwRd2OMLFO+45RMxqXnB90/k7QmdXwoW5GJr2BTa6nl1D4YynUuLld6owaj49JnQMyjZJvIGTtiul8faVyNEOzkpDQ6xIPO+8ZUUx1Ef3DBFYtDTG/F7s/9mdOq5aV4P1b1yW+/g5YDN3Dq2JYyzz/caqblFikdrBBcYIHmqV89Un7ZjPTFgQoDFuAuX5Or2TkPDZeJiVGskiQl6HVoXYvHL2q2icRDgBPL8yXOCIUYLE6UVyduSQA0cDiJVONPTk/UxsX3XxGA1IqQ/1r37LaarsqwFkL7z0PP4EVIo9nkdh+DL75
 WIJRPSNt
 +BQZpQ0BM9CVuFyg5Pwd5VneDybeu1qawUsOx4gFFu0CVdlS2qpVU7j6c/ZscpQXK6vrKFiti6jXui1oahb2/qU8Mie/OsbXaoSefdLED9csqAOX8VGunR3s9gjoCmRZD2r29Lpwk7qeoVvTBysFXmezasdB0ZL2Ik+uFM4eNWi3fwg2X+zk3uglFbyPHYr32BLoID6SxXBmNQDvKncd5KFJnJId/RO6T9P5DaNK00I9Mx3YLtWu+JosIW+7l5JMYWssyWBHZ1RLWcMN19AzkhfTptLWrbuHDVWeU3T1lk78mvuw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We need to check if the kpkeys_hardened_pgtables feature is going to
be enabled very early during boot, to decide how to set up the
linear map and how to allocate early page tables. This happens even
before boot CPU features are detected.

Implement the arch_supports_kpkeys_early() helper by directly
checking if the boot CPU supports POE, if it is called before boot
CPU features are detected. It may also be called later, in which
case we simply check the POE feature.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 12 ++++++++++++
 arch/arm64/include/asm/kpkeys.h     |  7 +++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index a57870fa96db..37aae60c2d7f 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -1085,6 +1085,18 @@ static inline bool cpu_has_lpa2(void)
 #endif
 }
 
+static inline bool cpu_has_poe(void)
+{
+	u64 mmfr3;
+
+	if (!IS_ENABLED(CONFIG_ARM64_POE))
+		return false;
+
+	mmfr3 = read_sysreg_s(SYS_ID_AA64MMFR3_EL1);
+	return cpuid_feature_extract_unsigned_field(mmfr3,
+						    ID_AA64MMFR3_EL1_S1POE_SHIFT);
+}
+
 #endif /* __ASSEMBLER__ */
 
 #endif
diff --git a/arch/arm64/include/asm/kpkeys.h b/arch/arm64/include/asm/kpkeys.h
index 09fd5a849cb0..284039e9a244 100644
--- a/arch/arm64/include/asm/kpkeys.h
+++ b/arch/arm64/include/asm/kpkeys.h
@@ -21,6 +21,13 @@ static inline bool arch_supports_kpkeys(void)
 	return system_supports_poe();
 }
 
+static inline bool arch_supports_kpkeys_early(void)
+{
+	/* POE is a boot feature */
+	return boot_capabilities_finalized() ?
+		system_supports_poe() : cpu_has_poe();
+}
+
 #ifdef CONFIG_ARM64_POE
 
 static inline u64 por_set_kpkeys_context(u64 por, enum kpkeys_ctx ctx)

-- 
2.51.2


