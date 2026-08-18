Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D86C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059426B07E3; Tue, 18 Aug 2026 10:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010066B07E4; Tue, 18 Aug 2026 10:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E613D6B07E5; Tue, 18 Aug 2026 10:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5F446B07E3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:12:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67555A2B15
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:54 +0000 (UTC)
X-FDA: 85114581468.13.3955CA2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6DC8B14000D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:12:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H0K4pOHK;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062372;
	b=icZdKfEBSI2JqRmr89piyPflU/4/b/IELNKUUOgMPXGG7nKhTTpheWclD62UODJF6b2nty
	OSjesYDiPceWnhhnC1AyLSJHIEMz1INn9xw01U4MYmlF+qFDJZmV4I0ta4ZcP85bxEUT7F
	mZ7fkIw59g/pJXKHMph3DWFR7EAYF2w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H0K4pOHK;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4H8wiF0hgCK6Z14cYnJGVcovNGLfVG4d+Txb2BMUNWU=;
	b=aOUj6biOD7yzVkWmrCRx7/gSW4SZ6moW1kzPImn0IqCYmf4KUMOsG7TO4BtAeSyc/KStyq
	VAO3MZnC+JK7RrtwIgxtKTHIoUQLs8e6/uYCi/OkuD9B/QHbS0yVTLMrHAkTyRH/JajWdr
	b7j1xu83wU/90LLuN1tUD3lsyLRFMUM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC68E19F0;
	Tue, 18 Aug 2026 07:12:47 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 142D23F85F;
	Tue, 18 Aug 2026 07:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062371; bh=R1haHsQJIOzOTzusDWwppuJ0KLrMbMhqdKzsauz9u6I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=H0K4pOHKijoBA6BddqbgCg+GO9Apt+JU8l3qYcyNni+40SZ+DTe9z8vX+f/k+hrJU
	 vGrK4rI64sAjKuKkCh8aI75z4U9iH98YuoJVRr9YAoxBj7lID1j3SfVRLTF6BREc8Y
	 2yruhbM1PPQdfccY71wHasSTDfPwR8zgQnNBLRss=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:09:00 +0100
Subject: [PATCH RFC v9 18/25] arm64: kpkeys: Ensure the linear map can be
 modified
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-18-743ad31b2c8f@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=1874;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=R1haHsQJIOzOTzusDWwppuJ0KLrMbMhqdKzsauz9u6I=;
 b=h/hATSea2gyFxuxheDf5h9PYLRP4Xr93yT774GfTwnGYoGj8W7S4imhB5RE/RpTtWPfFlhSVf
 X8lC8/DKhxrCDDJDZblU8I4NK/0UNli0csjRdIbeLM85c8/Dc5cMiir
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6DC8B14000D
X-Stat-Signature: pbs95e138ztnjbsssy7byypimex3aq8y
X-HE-Tag: 1787062372-55315
X-HE-Meta: U2FsdGVkX19tVVNKTOVI0/RbO0xEBZzHkh56mA1sH+dF7JpGdjZY7iuIF8x6MqCDBXwx30nJIstkAR21F/npbtqIQQjRMDU5kpEQuebvO1TEW5sGtPFTCWaDEUe4wsTk3aqhuaXWSwHrQIp1sI2fMhdPINA+w44FfiNDd2jVxtXn4Vx6D1AI0PDdwCR2QROkLEK1novRTFvTYoh92ITK6ZN987m3bWsT1YV2u4lrsq9HDSk2dP+YnQ5amjZqU9pn7CDn/rM6AWhpvWW42WCiKzCtT1Wet8kHVyEHBEnJO2Gz2pJRINnkUR3p3ELbkvgTD3mBn7UHNOrNX2FAvOR/KcDcFHIHVbRSSmAl66zxAzoL4DN3MMB64xnnMFG6lF3l3wJ3k2zfmsRnsNImgxYvS56kArwH0Hd1n6BkyCW8LgGDI7QsfjVeKil9BwDKX5VJySDmCSVrkNaRLNIFITWzQ0IZzc0Q0xAnqVv+fKYv7qR8O9FPOrYMsQ5iR5ciWSuwjFmBFX8ovwA0lOBMPViIrG14zrwufeNtmYM+YZ39UPyJMi2+N6CVriJXl2Q3QJWBAA9yI2tiD1DRhfMnZVwqNdBZKKzg9DErIpipGzLVu+qGD4sXc1jL9t1xrTvpAziX2oO3nnxMfWTnXDrYhWZ19VvxnkJ3xx6AMZ4GfMQPBNqnYVEsz/ttZC9Sth2V+m73HzFPoXlmHArpG1j9DLaC+PyassTBW1mDvEOorc7YDLKyuMNbxC78x9SwZDb1R4IEJ58DeWdyx9rQRuAnoKDRb8yGSjEENDidkY3flaHqpnLZXtFr2krKcjZMmehehMHogdhrPEKptCvLyDD0CtwdFQcw7h5pUhvnjf54VVUz7vo0aldVnUXh2DUFLg1hA5NFOIeLEyRZRoeAl7nXJQ62u0/D23IB7FQRm3QA/dL+1JDv1OpHkE07ET/rUX9kALBcBLxzU0hevu8IXEI4RFL
 Av83xAyE
 xrmitb6XVFMu+coRW5BilwW6IuWHwFrThGDgHR+LwRZmc3LWULt1eX6iR7qqBVnglymLrhnPOp8y4MEU6+FMkKfrhEasOR3xmrCvcnzHAHWt9SUqWOZSicBuf9LfZTVeXE5bFmnd94PNXQO54dl2O6CxZ5tBwg6TGkBcWynBI/kkf/VxOgiL4Scig7f+MD1lBibBhqApDAwaVJ6YbG5XGgDkGLoKiAI4CIkSZGE3hZfcJonFWJbMs9l+4DNsFD/Er+8rJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the kpkeys_hardened_pgtables feature is enabled, we need to be
able to modify attributes (specifically the pkey/POIndex) in the
linear map at page granularity.

Add the appropriate check to can_set_direct_map() on the same
principle as rodata_full and other features.

kpkeys_hardened_pgtables currently requires the linear map to be
fully PTE-mapped, so we also need to ensure that force_pte_mapping()
returns true, like for DEBUG_PAGEALLOC.

Both functions can be called very early, before POE is actually
detected, so the early_enabled() helper is used.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/mm/mmu.c      | 2 +-
 arch/arm64/mm/pageattr.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index b071f128b9fa..0d7e41d17182 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -780,7 +780,7 @@ static inline bool force_pte_mapping(void)
 	const bool bbml2 = system_capabilities_finalized() ?
 		system_supports_bbml2_noabort() : cpu_supports_bbml2_noabort();
 
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled() || kpkeys_hardened_pgtables_early_enabled())
 		return true;
 	if (bbml2)
 		return false;
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 4d79f39570ed..46fbebfc5100 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -101,7 +101,8 @@ bool can_set_direct_map(void)
 	 * Realms need to make pages shared/protected at page granularity.
 	 */
 	return rodata_full || debug_pagealloc_enabled() ||
-		arm64_kfence_can_set_direct_map() || is_realm_world();
+		arm64_kfence_can_set_direct_map() || is_realm_world() ||
+		kpkeys_hardened_pgtables_early_enabled();
 }
 
 static int update_range_prot(unsigned long start, unsigned long size,

-- 
2.51.2


