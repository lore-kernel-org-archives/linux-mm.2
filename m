Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D8AC54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1BB46B00AA; Sat,  1 Aug 2026 04:49:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0ED6B00AB; Sat,  1 Aug 2026 04:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D5B6B00AD; Sat,  1 Aug 2026 04:49:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7533B6B00AA
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 017B1A1358
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:40 +0000 (UTC)
X-FDA: 85052077362.06.9958564
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 52BBB1A0007
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IygCmeR7;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DcIy9f09G7AFfaW0m/xEV6z6X9TFYUkoxNnVWt25+18=;
	b=XNAFtLNAx1recG9j+oYC03zASYMrDCL9TGKQicct9lqvqI6QPRFzCtiZx+BTIv/qP+qR7R
	ACxYPUnXnynNsdYgeFm2Pneg0eLgtyS6lxYd9h1BMcB+tiS3iwb6jSlqaRl2p/N4X8/ele
	FnXCygGANS5Zh/Ho7xB0ozhBt1ntQLI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IygCmeR7;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574179;
	b=ah7zIGkIRpmpRlaYb3jn+9t5m8l2fV5A9Hn0QY0VME9/DfEt8zl/mPqvgAUT38E0Gt0Py3
	F8yLALulXWjyYc9OodV++OpoSWmqJ69MDGO4nkX3kDM+d0c3qK55lbl8wt1ptcG3FjMbSZ
	HcihUY5pRtyONCi6k91dYMN3edvHVMI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF01D45271;
	Sat,  1 Aug 2026 08:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BF81F00ADF;
	Sat,  1 Aug 2026 08:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574172;
	bh=DcIy9f09G7AFfaW0m/xEV6z6X9TFYUkoxNnVWt25+18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IygCmeR712ERaVNGY3E7VqhV3DY/W14mNeAS42TBhexbvQmzSwMxzK5hayLtEpm98
	 rGuTR741l4DbCb0rk9Dz+cyeSO2r3AkYhm1lT2gDC42bUav8jn5KR43bxs35SBEw4L
	 1+qcCZN2Vb2kUgL9rp+VA8/tT63HG+mEg1G1GDQW0iqdm1essHXttw/dmf6padVHhR
	 5R9PvjgA+dM+ilQI/DySB7jm6Z0rzcS6w1jjQOrHe54G3rQSCwS6RbU62gmBKWfdBL
	 iLcmhKAVEbZcOmAvQ45vZpJluIuWWnxpzx2IMEh/W5aGfPJ8+MBNiIpUFEYUFgzWcN
	 CdAKM6EFcRWJQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v6 16/22] mm/mm_init: simplify deferred_free_pages() migratetype init
Date: Sat,  1 Aug 2026 10:48:25 +0200
Message-ID: <20260801084833.1897543-17-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 52BBB1A0007
X-Rspamd-Server: rspam01
X-Stat-Signature: 7gaauj8gjdqdiiawoadc7csjntiqmhcz
X-HE-Tag: 1785574179-355907
X-HE-Meta: U2FsdGVkX19/8OfTFWl0vKbwTnMIyKY5eyUQS07/825MqXzVx51Ed2QX4hBdz4AoHbXVOeba+gFEvyi8hHi6lMu0xqFcPg33HZp3smaunWrNSIz4Z3CJBstmsSzLWSQmUtUWlrApk6p5TjnwmxnOS+iovfv44EvH+ObxfBvFwE82eHx7NbUg/xMju/2azmi63d10U4jOwYjSjZBjIaBsm32WwtImMNTCXxddR5oiJbws+Q7dSwJh2dm+kzWbcrtAoHCsTXAFDCkdU3t+vPcVtXbwnqUyuOIR+8OBy+7E1bgpA1zPVhMVcs4uGeX8nP79P7hJ4jBF0bfeKZFqfQzuT2f1reMyqqTbvqcOUfbR2nF6CDyCZE8k19SebK2qJGxuYNN+/fApWHYN1kGIHLaYSN9gMuZpAH07jJTeJYsngTIE1ZeipFaRryfxWjDt5fJjDSryDZRlqZfCoDwtOraRebyOuwYkYoZ3UwK0WKzqviN8cgfveuLYxFWr7DOiRIzcHpuIFkZbvVhHCxAvNRIEfdPkF55tukeUMA8FsePwGbhteGlkBM3YGzSF+8j2CpBQ57N5D/784kGVqnZs7h+BrWnuzJxl74aFyUA21DvVD1Q2wtqZxxUrm5t+h66XDC/uuCpbzFwM84O8H0TSQ4QRxkKdV0Qv803wLUNstzAjLTaVhsY5SN0DlOZqaZw6YLxVhkb+p4onaNc6qFhcS31hW9u4pW6g8osHmNUlrZWDqLIAorqZrn97glpZkjjjnYc5JCrvaUjPGZvUGBxqgr78AM7Zo6VzlrcjH9bNRRqnVI0IDhHKIAOihwIIM1aNG9dPVRsKQqxc5qn/x3y8AwPWqLA/cqaqd8r/i9yd/HjFP6xnE+DnG0Tq+xCfQyVq+tMTysQBoHa48as59mGqE+RGMTRx2bnPAbF8OAJ7L7Ueo8ZAfXOEtXjjf1sBFBDR0bcR4xTB89ZJUF9OQz4vjng
 ZgVl+htD
 ba/RdSXSy0L2vx4rlPo69VdtNAdBOlgDSNdHAy356RNCK9j5HYyXkbgV/29joTQFjTdvk3oWqE6+ruzAyPDeEtAlrFIocN+o5mkgSoHVs7aB+Hy8lsQsgKsQ9yUkZW2GkXDXLPY7OJijFWh+EeP/sbtSVdIZFaqbYOZXwcH3uen/i/Pl4tUuNnCUq1IEnnlEyUFhyeLKim+06UIdGyj//KOtNvpP4UamWU84ssUwWiYlOEZ0PKXYL49yr3yro/x89tv8O1So+PFvQCtnwzSPXrU1kF33wiEksCeaPAnqBdWEGnwyF7yYy6ZYhNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

deferred_free_pages() open-codes two loops to initialize the pageblock
migratetype for a range of pages.

Replace them with pageblock_migratetype_init_range() to remove the
duplication and make the code clearer (Note that deferred_free_pages() may
be called from atomic context).

Link: https://lore.kernel.org/20260612035903.2468601-6-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---

Notes:
    This patch is taken from Muchun's series [0]. The patch as of today is
    in mm-unstable.
    
    [0] https://lore.kernel.org/linux-mm/20260612035903.2468601-6-songmuchun@bytedance.com/

 mm/mm_init.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 84d4b1c997bc..30355effe1f2 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -674,15 +674,15 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
-#ifdef CONFIG_ZONE_DEVICE
+#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
-		unsigned long nr_pages, int migratetype)
+		unsigned long nr_pages, int migratetype, bool atomic)
 {
 	const unsigned long end = pfn + nr_pages;
 
 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
 		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
-		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
 	}
 }
@@ -1142,7 +1142,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false);
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
@@ -1981,12 +1981,12 @@ static void __init deferred_free_pages(unsigned long pfn,
 	if (!nr_pages)
 		return;
 
+	pageblock_migratetype_init_range(pfn, nr_pages, mt, true);
+
 	page = pfn_to_page(pfn);
 
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
-		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
-			init_pageblock_migratetype(page + i, mt, false);
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -1994,11 +1994,8 @@ static void __init deferred_free_pages(unsigned long pfn,
 	/* Accept chunks smaller than MAX_PAGE_ORDER upfront */
 	accept_memory(PFN_PHYS(pfn), nr_pages * PAGE_SIZE);
 
-	for (i = 0; i < nr_pages; i++, page++, pfn++) {
-		if (pageblock_aligned(pfn))
-			init_pageblock_migratetype(page, mt, false);
-		__free_pages_core(page, 0, MEMINIT_EARLY);
-	}
+	for (i = 0; i < nr_pages; i++)
+		__free_pages_core(page + i, 0, MEMINIT_EARLY);
 }
 
 /* Completion tracking for deferred_init_memmap() threads */
-- 
2.55.0.571.g244d577d93-goog


