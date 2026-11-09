Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7046606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=QLRNhzZH
Received: by kanga.kvack.org (Postfix)
	id EA8026B05CE; Mon,  9 Nov 2026 11:02:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E588E6B05CF; Mon,  9 Nov 2026 11:02:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF98B6B05D0; Mon,  9 Nov 2026 11:02:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A69476B05CE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:02:06 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3CEFA1206FA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:02:06 +0000 (UTC)
X-FDA: 85416047052.02.C74D8B9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6BA2D1C0002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:02:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QLRNhzZH;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PWH/40FIqyLP2HM1UmBjogshcVKge2e/eg7YNNWZxRA=;
	b=3hapaQHFYIyEMPZMYpskK5G70FFI3F0kg1ZJsIgLKAV7FZttBmeteEXg8KYPSIotnqHUGQ
	tcLItsVFliwe0pg9zYnALqy5Ej3V3q9aPB9uVuWrqeFR1+Lf5kCNErqPMbAsqAhx1iy+ka
	BK+cIHM8z0hIwfJj7D4GFyJpI7Ewrmg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240124;
	b=L6EFt+KScq5xW3M7L/84MQPtjbjvFB5Li+ylkUrGKNk75hq2Pe3GEbJb95jZS3MA5v1/z4
	RyQD7lTf97nMiKGsKQoC2go1EvOV4pNM87+eJ+3OUhGEDPGEa1XnbnyXcDTVn16omnKhSY
	ghN9yP4b+vANZPhKybzcHB6TDiIw/hA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QLRNhzZH;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A7EA14BF;
	Mon,  9 Nov 2026 08:02:00 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D8B03F632;
	Mon,  9 Nov 2026 08:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240123; bh=4sCNGHUK8a+nA0I4Chgpt6cz5TZ6O43DyF+ejpn7dJA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QLRNhzZHekFuUQsq0AWTGQpNGB046jveGgekZe61G9dbHw6pQV6whq0aia/ObCBvD
	 GJvVFMvBELXTCmcMfJNPrfCHxQtRcb68AtE9sefGlUCYy8GSgQlQyBhrymk9Q+xSFS
	 BoIiDJGW6o0ZJFGFRaIJVFMsdFTDLRa4F46BsE4Y=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:42 +0000
Subject: [PATCH RFC v10 17/22] arm64: kpkeys: Ensure the linear map can be
 modified
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-17-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
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
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=1906;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=4sCNGHUK8a+nA0I4Chgpt6cz5TZ6O43DyF+ejpn7dJA=;
 b=zHz2C3i1VBSSKWpf7Zi8FAzpoWhJ399jCh5pRME6NVSQtdP3NuRk9Ki9LSALcptG8C/7FVprk
 Q8GTwsRXUSLCG2F2oyUmrzX9qBqX+adtMO0X3w7NQkER0tvzXahhAMy
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam06
X-Stat-Signature: gc9fy98444g5fm4udi8d1np4z9p4ujx1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6BA2D1C0002
X-Rspam-User: 
X-HE-Tag: 1794240124-83438
X-HE-Meta: U2FsdGVkX1/o1ewM8BZGhDKOgfpAnkl+QLemymYO6W3KeIdMguNNCs+8lNrezaeR7Z/CHJN3yGXtW1kBAqRL4Z96Kq6soIayPmOztgRv/+DpNQOIPXSe501qYmNZ5qhP8JdyEALCn5jLC9S642pyPtSo92NNpAAm/yljU8fIW8OGCElJcMaEwk+tbHVXSKUyH2xgFSrpJFoOCgv4TLCflNmvDbo+AkiKaCPpIahouiMQBp1v0t3kYBd1TFcF4HD9NixfYPAS4p39srzRIjEBSebV6+n7GtJLHfp7xpsQc3rurZ3lXvW682m0btebi2YmPA8977kFRB5R1O3amjNCS7wVm3EHa3oT5IuEYH/LDLq0POP5sNl77MQCyWo3plb/jH09LRJa7pDNnYl8rk/6LXQF3K7kajuPsA0cCY9S86fnHWS98r4iDW5wM0HW36U8gkEItc74QsPkjRXzu1g8AWyoaBKZpVbS6Uow8GMFlgc9QUTL+D2GqfQ9J302jJ34ubaS7BUKFyAxJAOBGF+avC0WBalFUCYaf2G3QAGxfFHDnABgHlZWi1WzZWu6HwuVAj0s05IJ8aCR8odoyAEyluD/B0V5Kl1MCF5uwJNJCe9Vd9StS12Y/l7XCyaV5d/AzpGv9ZfyrQpCQKmgr8iIMt89ulidokhnG09C0Qt6Rh/3Al3PhAa02WG1Gw+jwmnWYyPPBrBW9/95XYDdLAZxBmSJrcjuyH1Urwr2TU++p36y1oO+sRBYd4HJ8wtYydRdSaf+NFynlnJW0v2wadmi1JiiRvQrcCTrS7Q0+GhvemjBOfgKEVLcyukgWzIB8Olb1UD6mr37dL8bZVY5fTLndEXUcgwqw2U61CvDNDE02qkEiNU5lsJNoHfzTlsnUHnri40eEOSYDQiD8H8iQFUdde2wbBF+YEhEq467VdxmXjL8NQ0/3nVza89ZNniZGNLMryerUFZzaADysihROlO
 1k5oPw5Q
 J4yTW1F0udpV79FiRhu/GWXBwXZO5zHblfntdN5rZmDWW1zjU++37Ayp6d/aTmDEZhdWN77q2EUex73Pkk99GfRQ/6LizcwTI78Wg1FIWR7YTCzwxsLQ2ZkGWgklmP5NTSDSxRDqVhw7COXdhISv3GBtHhcMa6SYZak86ZGt2OUeidLY7hXU5CGjWT6ywXwyTd1Tv11Xz+se16S3lFXsmT3CocY+FORVsSjP83ZE7brlshCVrmjUq3a4bP7KnMPU6h66bw21Zdl8nw9htGGVQzjP9ED0Tqf1FtO4+kFOrwTw0MK5jMHXnRn4rYkRPSVGOBMhSq7UwGz5kXgdYBKizIFirVLyFkHMG2tIQU4LjMegiVxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/mm/mmu.c      | 2 +-
 arch/arm64/mm/pageattr.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index a61ea65bd496..c1e3260bd0db 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -781,7 +781,7 @@ static inline bool force_pte_mapping(void)
 	const bool bbml3 = system_capabilities_finalized() ?
 		system_supports_bbml3() : cpu_supports_bbml3();
 
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled() || kpkeys_hardened_pgtables_early_enabled())
 		return true;
 	if (bbml3)
 		return false;
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 7143bb2dfecd..35f3e8ab0baa 100644
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
2.56.0


