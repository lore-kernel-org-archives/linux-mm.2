Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 567A3CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B85736B0005; Tue, 26 May 2026 07:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5D976B00B4; Tue, 26 May 2026 07:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A732E6B00B6; Tue, 26 May 2026 07:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94F1D6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:18:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6215C1C021C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:23 +0000 (UTC)
X-FDA: 84809322486.18.F031E16
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8AB4A80008
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="f2YD1wn/";
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=suadXFjqUeYXYgOScGS4rRxyj1HJ35c5fal4EZbJOu8=;
	b=V1ChLx9gbZVpTSFFIesaEynE5hsTRKYUfYJTJU1DllqGGZ2BAoCTEh/4NGgARKNDm2vs1J
	s4u2x3tmBogJqB6IBMeVRTKzpF22l8o3gpOYugy31cuthMC5VQJ1gUZNbycOUi/tBmvBWR
	FEDaSySJwlpr+dm5H4gamc1jmq0Tffg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794301; a=rsa-sha256;
	cv=none;
	b=6R3XO88fDoGqiS7yhzAvPAsA6sj732i8TwG+MW6fcwZiLB7e/jPjEHXll9u6p+w3bRBXYh
	w+ebz83cGG0ETOi0QgZCJx1NINBXciimp6kuTGtBPjdKvIwteHoAKiyWNksHRMWYqjazjO
	/HXBlHazBgC/7OMjfN9C7cZfx0r235Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="f2YD1wn/";
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7300169C;
	Tue, 26 May 2026 04:18:15 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA6693F7D8;
	Tue, 26 May 2026 04:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794300; bh=m1lwmokEjD1HoWjx/wLPpsDySzIAvlE7LuDL4EQvvUQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=f2YD1wn/UgAq7EktZoIxNhGpnmsMTZu1NHXu6M0LpQzX8aM1efxJoXBHYJ+Lj2a1Q
	 rrc3NAp66I67k2y8c+DeacsqlbfE67hn9p5EBVo0zj+UYEmnOEMCqs/Pw+jhF02uFI
	 DWO0meIz5z/ys/hkYufQlSUY4Si0Gp/oJDp9qYSk=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:16:05 +0100
Subject: [PATCH RFC v8 16/24] arm64: kpkeys: Implement
 arch_supports_kpkeys_early()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-16-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=1883;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=m1lwmokEjD1HoWjx/wLPpsDySzIAvlE7LuDL4EQvvUQ=;
 b=PF9qkQuhpKVS30hRKZUdA4i0w6tAhzaz0tLGjykXAtm5KnRdCWJF/YeucL6q1dyrrK3YwJk9i
 d4zP53BkOW6DBGpZtXPjYkMVMAfDsR99jtotryWZEn1eJP79d2NbAGt
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Queue-Id: 8AB4A80008
X-Stat-Signature: hcjcpne8keosixqmbcu5kydeq9cenfoh
X-Rspamd-Server: rspam06
X-HE-Tag: 1779794301-299845
X-HE-Meta: U2FsdGVkX19WXV8zJBYgOtClRXsaEwfXlQFs8FnXxZk6iK21mNLRmz7PtImPqYMa8Utydi7xLNU0i1wmDU5HHWMm1X5e/bavB/wMecAjNM4SiAXWpLHwGQWDnUF9By5qMLDrofRGNfMgFDzJ168P+Qv7nO0SOyrS13X2yP6MW+TpDpFEOrphZnWk8lc/IC9Q/kFO52ULkR9ZfbNYzhQpiVLzjnz19BZ6uWWUD5vkx8Bd2eL8g9aopWA5ndnhYr1ySkmQCvaJitBllVuURShInXCVpQeI/SLGr+JGsEw8P8pfQhe80JupIstqdiUbItFtD/lkSNuQg2p8nyg+HQdjhnIMHQhcs5kUlBqbCuwmF1vO7pUlUGAsO2OFNEf/Fmq3tPc173fMqJPfcYGA0B94vat22s4hNQ6Q2/IsJ+HI/JvrW4jq5a9yKha7LXh2L1C87tS2knJ4do1+PGMU3UAkX6pGFMHoIovUC3ELJ1brU2Yo9kVy7CZEy+MegPbQ4Ps9Al1Moj7EWe0LG9tuvA9+5Hb9Jq+Ac68oInBy5NSlxfWEPjA4LfnAGcFr79s9RGqB/nLcF9TeccuB0/r1O9WkCgCdBEh39LN5Uz/k2GGVJFY1PpPptHf8HmGiPgEPpfIidAsJHVBZoOGmAi6sfUwsKCdasz6BXxCW0nT9HBenMH8iFg8myECgWWIpRd6NbpxjYYmmO6CwJEjQQFt/0CN+VS/nCeB6IImvAgERbxkjHjVTOqwg0Nn4EpB5r1vtF94S4XPr8slHmf5jUleEk8qRkXYXIlDqb+VshjH3RffqS5Nf65YlJbI31WnX7S/jKc+c3TZBVLEhJp86aCN2skMiKeC0nR6zG27XCHiWuGU6TN8t7B4lBBn1NtPxq2Xn9dGLQyGB5EhPe/1wFEp3Vt6rJF1sdtsmCqv/3AqyMLipNaau7bkr+S6bVWFFVv5e8oNBLLTQGH5IlYQ11iNg3uW
 hEy2fXMe
 69svzefce6CczY9FQCmKUDj1NTAo9/GM6PjbeKL2y+/dZeHJxNnxYwEsbOu9EC+ovT7dHg0AMfuoMpIDtQbUmOszSfQt/RBXtme7J4sok8u+mOhk8OioyINW2WeaxCmDNjXWnFs1tyvfGHRJDUTZu7oB/2EqS8GwKBuWZ1B1ODy2n0C65heqCRnPCs81G1XbKTqKm+QQhlT2BUuqA465ZaV5FLQ8fkdneQDoyhlwh51kCSLpzNl0qDHN9DleJq+8482ji2lGNp99AgJ0+ll/37DXo4A9PGkYNfHSHshcNfJFG88s=
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
index 4de51f8d92cb..8722e9e62702 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -1078,6 +1078,18 @@ static inline bool cpu_has_lpa2(void)
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
index 4dbfeb3dfcfe..fdf3ebe92810 100644
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
 
 static inline u64 por_set_kpkeys_context(u64 por, int ctx)

-- 
2.51.2


