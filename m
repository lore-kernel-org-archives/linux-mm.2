Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F39CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C326B00B7; Tue, 26 May 2026 07:18:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653E46B00B9; Tue, 26 May 2026 07:18:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5433C6B00BA; Tue, 26 May 2026 07:18:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 427506B00B7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:18:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1062CA03F3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:34 +0000 (UTC)
X-FDA: 84809322948.24.A1DB445
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 20C31100009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G6Qh4uyO;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rOgGyybA1RFHUYhGBde0hOiuSxoA2CWz/XAXRbLfO+Q=;
	b=J3PJQQzSl1/6OIlLeT2xBxgS8h5BhBU1MOixtpqyFAPedsv/yh7eBSFoj1AsKuDvGWOFg5
	KbLv/FfLUoNZIaF2oAUxZRNrGZxgr1PSoqLByb2F2gaZ3TED9UoI/cjYAX7OXjwSvLBjM/
	5vq3QZ4jFbODYCIs5sA0WpZoG3M/TS0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G6Qh4uyO;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794312; a=rsa-sha256;
	cv=none;
	b=j8xg7xIo0GAKQZOiMo5SYpGkn1S8OpwfbN3pWI6ayl9efjmTLCKvqOqlt0cBRhvBHSqcGm
	r0a/2ybjoOCp0bKDNfEMKMXw346Nv8Y5obWkFnKoGqcfqx26i56QSc9uJLfJZPjzZRJZ+G
	Wr4okhmymQZ9jZl9NRrejZ1hWG1+I5g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AD62169C;
	Tue, 26 May 2026 04:18:26 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5ABD73F7D8;
	Tue, 26 May 2026 04:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794311; bh=tdSh+emP90ANDDLr4gHqcl2n9jLxHG0p28D+Gnc4lOo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=G6Qh4uyOUk14RrgWwvp7BlKMYZOIJVQPQyDyGrJ/wn6FiXKVFkyn0lMuRcFJzfGej
	 DFzV1DszD8XXUocbHQkip3oFVB/VukZmNPLOUC4Fwgsk/4enrFmlAsnPDK1b4vca8o
	 t3Hil7XQ68LyxySvYJaOj8elFG/Qyunte2v8kDGw=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:16:07 +0100
Subject: [PATCH RFC v8 18/24] arm64: kpkeys: Ensure the linear map can be
 modified
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-18-eaaacdacc67c@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=1874;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=tdSh+emP90ANDDLr4gHqcl2n9jLxHG0p28D+Gnc4lOo=;
 b=fr6yZ8zM49YMzbl4pAqvIkdQX/UfKJYoPwtJoio3Jal7ikmbiUIgCdawtO09/ldvib7ULH/Mo
 AAKCsH7PRrcAzXVFFVEK/p3goI1iijinMde8JrGEBNZJcPtBkmoSXNV
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 20C31100009
X-Stat-Signature: 1cwfzix4n3w6qbyiatyuhz6ynx1xomab
X-HE-Tag: 1779794311-302087
X-HE-Meta: U2FsdGVkX1+nPTEs/hF6C9bOSj2s8ldTh2zmmUe94Xzb5mc0ODIEJfU6eqAuBuxPfoJ+6f1IGxwTB7Grc5Ue0Eno7TzCLeu0vcknnpg78yJ/AkRKuGOqTMXdBa1Q3p8saFqoBWPThMPGj/xAfc08IND5P7BKqWAJ8ekfpUNT+VJRW/vANZYvdivJlHTT7aGgDrAfRtdxIj/ngWl1lVg2Y4a8EXlurLb6ipSBSS/aMQahMFvwdUoC8GnogS3Qrqj9A5SXo/laLp4vUg4p/JaMf/yQ919cOwVOo8o0YTSvZD/0XC1CDYBk82Y2w7FyOxMjfDDm1V8J0sVcgjpVdCJolYnt9h4C2xZKO98Im2dkYvJiH4Kb2GHsKb93eAUKp1LHwhY3AicLHrHG7HD6kTWZZIgux9dBh43ZK+GjFYt7uBGxAb/ZdI5KFVbwnAH+g1565lRyuRXxaZoOCr1ZKQUWIclMmN+lMfnsQyjDiQaLdcXG4TKIUYDSaRXKXG+/GGUDy5cl1UAk7e1r+jRFnZQs+fi8dSnRiIsUMc7SBu+dhIkmlPTmb8NCV++P92LxCD8D8hE84zlDgk0KaNn91SMD4rFwARPrMlfXhPDx/1mgky0rnI57IWGq//rl7AMJm0fJvK88evBd2cOiDT1bYPk+rZJAcwd385+SnUvc3V5vRisLd64Rq1IV1/6W1UvTo+d67+MSueSQobzRMGRxgSQseXewgueOT7pk1JEsbWUkDkTWIMbfu1wKLuZDfO2cGXTNUY0dYNtkwu3YWCPM8F+PUCxU8neG71g89kzoQjd0CTW1Z5GGzqp2/ou8Hxe+/BLZCcNMWrgRSOru0LjF+XD1yFLg2Kcd9XTrqWQnVljNVBqO7hOMy7RdvB4WhlPZVztjCtv8K/VbUsgXBfq9C0Yno7ny+GlQ7YyrYOIkRn8tUQ+gCBInP0oyagCS3Jm42u7fZHiNcPiR6dSFfVG4coH
 ngunrXT1
 tKLkr6sskYGCrBLq5WWGG6H6qdPadcyeYjE3pnD8RHBlb4lVLSUkIMXVe4abTi8zHnUkZiW+9uzQcuVjGSMHB5O6jXDfoPqiTb27fB3+abHboJgg49gq/2NaKFb8m4/3YKdV+b9ccETLsO7nzUYZv4Kz3rN1BsM2FwOxLjXOdUmyIM9j8EPTLSnMvjUf5pFM4XItMc4k2cBAllKb4Q2WkZ7wfuDnUzmqZpAxy09isQNvacrFmZ01s3rJN2ohcNqAqHdgg
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
index dc69553d6326..c67b46592af6 100644
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
index 8f3519400bd1..87543ec660f5 100644
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


