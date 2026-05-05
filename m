Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E652CFF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 395E36B00E0; Tue,  5 May 2026 12:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31F516B00E1; Tue,  5 May 2026 12:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0986B00E2; Tue,  5 May 2026 12:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 005426B00E0
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:08:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFCDA1C0E91
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:27 +0000 (UTC)
X-FDA: 84733848654.18.636A780
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id E5D3718000F
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aHA3MyVL;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997306; a=rsa-sha256;
	cv=none;
	b=px8pQWoixg0mxBePr6jaTLH2mDhOeCgJs8W5sm8/5kagvBmZEDJPTNx2oo587/BaDeisiu
	UIcplJTKVkH54AkmJVqC8/Zd12YL1yHlplCby2ApCpBVhAPp0FQD8UGyUb0Hh7YQJm0sKR
	YAxJk+ytXcUK4pi1sRYZ7HuxY1bLsH4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aHA3MyVL;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7iuMBgPRvHIKWyxDZv1acMtW9fNSsseOOaQ+J8qnE4=;
	b=T6/hPHbmu7H7HWiZLGw2WhPQar5HPeWj2Mriugg8f/JpLuxQaM/qXiodj03GUOoZ8vRcpc
	UH5f/ic3wampuPl2w8rko6CEoeNlxoKN/n3DYqh79BJUDLuOeCD6uVd26LnL9jWEjeJS6v
	RSpltW6Y8Fxt/gHQIER2U5Ty2vnLLP4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B17DA3029;
	Tue,  5 May 2026 09:08:19 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E8FB53F763;
	Tue,  5 May 2026 09:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997305; bh=idlh122mOshIsCnWLTnqYzkLl5s0iSNqncP0VdGsTMo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aHA3MyVLuf+5i4DP2qj9SudVULlGFDH8dE6NPpi9c6nhYIrrri46XjX6OCBqudX8V
	 j0vis73I+sFpPUXrgf9bKmCjTD66Ww0RUm6vzxbGwgCzfI5i7qppZwSazuBuEYS9bw
	 scYKnz5bu28Og6MA0zWiOV7T9gXuKU183rmkhimo=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:06:07 +0100
Subject: [PATCH RFC v7 18/24] arm64: kpkeys: Ensure the linear map can be
 modified
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-18-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
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
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=1874;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=idlh122mOshIsCnWLTnqYzkLl5s0iSNqncP0VdGsTMo=;
 b=YhKJ1iNbJSMLHBSCs37q9uovxZza1VNm3qfB+SaYI7GEOCzzkRINrgLZnozpVrSy+E9thbqHl
 JTqh4bXYKA6A9DESUgq2rXyIU20gXRZyzZnigKBwPUS979L027rubMT
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: nffceuwffpppskuomphrq1m3s54dog98
X-Rspam-User: 
X-Rspamd-Queue-Id: E5D3718000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1777997305-653252
X-HE-Meta: U2FsdGVkX18PJEfcz6fa7CBLDyqmxHAqdt9U3YRbYhK0NqklLkiqI8Y0FRMPQbFyOHK0BDQmsKAjoqtJppDQ0XETqoz5RLzZj1rraHt9EL2ELqlzAQiuLPSRbfatJbmgumdfRj1PumUvHlHzEA+aKp+Yaq4CCtRcsTPVxc0sZ6/ehB+afb5V0l84YKugaEw7YxMHN+jI25hWGl9sdqkANn4DM6yBCijz1hr67K0uWlvom0T4sB6uCjR2RhCdJ4PGVCNAUbBKA7Qv6Tkh6CIIe/IKrC6ShuW3oDFDNXqHvwaQISPVPZlfmbjuskgVIGzIU+52LS89Al+Yw4mE07eNqKZo+ejP8ewBvspyWymZP7P6rCqEKEjY6wSeuw9314UxW5Xxupyo5j1Csb3aP6VwSR7Cmf+HGrPlE097xyFKXYTL3A6aobmr78f08a5g5qkz/nj+WDUc4SHNna84EHN4FVEcKJ8wTj6BLy39BKtYbkbWrK3Ke+h4MUhhwvqWS9r0LpHH9MpLfwffMjXVb7j4qh/V5kDRF7ehpO3hxozqm0pJ3/6sumviioWbtOg4gwEGDcYeyHOa0zdRWQHDgkKoBS7b67JZ8gNwqc/C0VB14VuEa4uPdk0pVI7xC8rC5+LoHUPCMDtZ5+x+Boj71oGkXn57ugrR/gFZKogJAud6+lNlNlhhyLdWyuts1PLSHhSnNZklDLsxQjQkkskLDhgRyWkyLEn6UHBS5L9oPnDVtviuarVe27f4dc1m7q67nqhx8fxTEqoadEpIIqsVsvJIuhaRVj/iRSKnsz9FpWpxFkN4cRtII9fYSjg2w0qWtmUlR2E5CAO48SnJIK6ab4FHJ1Ts1bZ/Ty0C0U31yRI0KXx1pPVHQbVehsL+ZC8RJI9CxmBU7vEi35xwb2qJeWo4tYYYg7VKMe4cqjhDwdXa4kiPYDG0EBnp2NvXyWdyzNOG6H4+VobZsmeCIl6eRA6
 d6m/gRj2
 TX7Y3qPiruvn+kiLM4+hBdQrj3V70VubrTjSqtW07U+2hNebiHWDv4nljaR2sM5xiqCdyjUfuUKQnRwCdN3oQdf+kc+FTdv8G/JffoknML4p7n/rIfjym4SRBQIvkKxXYtUq1bOZsj7qEhuodwYCLjFHXNjSKbON3zajgRjAfLOwdjcJl8V11d4vZ0h9lgYFgut0DiFYSo9KTN9f85MZqtHcjJ146lHllcf9/46rCleFw67iIqwIJj6i8mRm7FOPifX/3
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
index 493310cf0486..f79e82c0674a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -760,7 +760,7 @@ static inline bool force_pte_mapping(void)
 	const bool bbml2 = system_capabilities_finalized() ?
 		system_supports_bbml2_noabort() : cpu_supports_bbml2_noabort();
 
-	if (debug_pagealloc_enabled())
+	if (debug_pagealloc_enabled() || kpkeys_hardened_pgtables_early_enabled())
 		return true;
 	if (bbml2)
 		return false;
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index ecdfaa9701e1..4405f93f1586 100644
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


