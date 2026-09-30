Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B2F5CA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 16:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FBCC6B0092; Wed, 30 Sep 2026 12:04:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AC396B0093; Wed, 30 Sep 2026 12:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8F1C6B0095; Wed, 30 Sep 2026 12:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C17556B0092
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:04:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F5F01C00D2
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:04:48 +0000 (UTC)
X-FDA: 85270901856.23.3FDD3F6
Received: from mta1.migadu.com (out-159.mta1.migadu.com [95.215.58.159])
	by imf23.hostedemail.com (Postfix) with ESMTP id 04E32140017
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:04:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uG+xLlU4;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790784285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XnLGPnxPup1Qwuu3VAeNT5u6KyZXRlv3vCyavwbVWFs=;
	b=6RPWeEzkSsRWqAlmws0xKsXDk3bn3viO9pGPfHVQaPDoC4ww2QodlatwdWLFTvAE7n0PIr
	zlbYDYwkoR0/c8RvdtLZ51r/tCC9hf8PWpCujQqcxCF05s54An2FJs5N/h1Eg2+7zfNcYH
	QRVYLdYUb10oLywuyZ+XTTMS+o324Is=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uG+xLlU4;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790784285;
	b=5HBXtY2Mfo8Z8TZPySoxmR8nL7k32uep+JixmBeDiAX0HdlaoMGwoM7yEJ5Iks5hEEJgL0
	J3YogRuUKtzaCn5tJXlgmRmhnugJFLSASe9SwZTj2nAs7md/v+lh9JNyybS/9JF3bLKUhY
	KbAEoolkNNy2M+TE02dYwKBBQvmUnIk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+vcczYRy1rNmcGvWO3RhaCJIFdsbwMwez0v32TjbTB8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790784283; v=1; x=1791389083;
 b=uG+xLlU4sGw7EqoBVo99T2gQsThTMjyQzYGcTJupxalP3wan7nQJNGc3Kx3jLbr1Jj1KXb7J
 aUmILtDc3r40i/GSBkxKy2+mfCgIsFiPylGlM2EsYPy+ONMcHX+nkytYqN6LA1+qtWfOgXOpubS
 J8KWlbHKtkaDBVN4srGkn2m0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6e927973fa05e775;
	Wed, 30 Sep 2026 16:04:42 +0000
X-Mizu-Trace-ID: 6e927973fa05e775
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	osalvador@suse.de
Cc: akpm@linux-foundation.org,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/1] mm/memory_hotplug: fix missing rollback in __add_pages()
Date: Thu,  1 Oct 2026 00:04:32 +0800
Message-ID: <20260930160432.5564-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 04E32140017
X-Stat-Signature: 4pghg7x1epaw4u6w68339z1eb9eapqtp
X-Rspam-User: 
X-HE-Tag: 1790784284-76183
X-HE-Meta: U2FsdGVkX1/z2+66tcV14ECLA2au6lyVBH0bgSxmr+hfklNw4vZSdH755sRgaYJprIgZi+Gb2h3Fo/PH/lKZf2UxSJ0BULdMpvbKwc8z5vlAsN992rQ5G5G8x/CZ3BvI1tUVdcap1CCZxNtzxV9pRxouXfctKMtUVV4PHvWIBnguhh9BYAfZOc0n5wr+EH0FIJzUVe9AeU9RRzkB2GcRsMVkIG1QBBfjAAhXAUKRrl9AMnYugqN3cbj5GE5yEkEExIPpM1TIdwmcu9SZYAUNnDiGvyz0bD5vRh8M3Jwg1oK0P0ghciMIIs70B1xLJXVQqt1F6VCfKxvpSoNXT2zS1pY7sFanOSTSKlVITwMw23YQSG5RxOPB+/so7KeMrOVNk//PZT99V62rUNpzCG3uCGuR2eFtp+kiHXonLL64GV+im+M+HPupAfQVUZLD+Cr/Ne+0bi6QlWCEaCwbSY+DHXDLouCXFnnAGGKu6X/Iyws9wNfqJHoz47MpoDh4QZKvaErsPoGwhXYMPENqkHGw0K9ObL5i2IuWkkwF+UhyL/g/QvDn7l3S37vplO1Q7QNVyQxv7a2KB0gCBGDQjGCLXN+Qs7EscNmY2JpOyBT6ZIt2cS+yyjnjDfrc1utFtG/YN4S1KKL8Gqj+4KTGlHZsEnFm2wJlDfJa0NBci4CNifbP5KiEp1eTnH7KKPWBJLK9YwxaB5xfNUtDpxqfjtMbQb5EQx/pE+Ll2bu3/2w9THdvvh65bpKBHX18xkwsxjKCbnhGpTy4cycaiivpg3fQqQWVrx5OtLDO6fxO2OMdGsEhDAETFZ/5Knvs9D6lw25dvSWSSeZSgv8INoODfR+fgvq2mt2ldyIbsrVThHnyHybMoSrAimjUgGKFftMWfjf/+WIpfY210AfwSJYy92l2oD9yKbxy75DpLrU+0kmZtHvUfU2b1mbZN9w+HZ4LZ4Y/IkF6CqL2Y2Cmu9F9pDX
 RpyUcKwc
 BzEuu/sLHKJ+FFg9hhoiCfsCi6WV07TN93YomA3Cg6Qd5JgGNKcteVy+W7+mB4S3bXur7XKZ4V2bxOJLuI18XVPWid2KhOg706RrVlrSiW83MzDidAXUU1SBfnrfkHWMNtvX6N+rzRQZyEae8s9nVDsLOHXwi1tmjtw108AHXyqgoDcNd5YerApu/cox77NTvi6+qsGZ4ESFTPkkYLyBUwZOYD3jsh/AHFSb4VJLiI74jYiCmuHhLb9+sNeR+eTYxDp1mbLb7USR6LTNsHLPm0gmf4s77YW9em0P6h9gSXSMdQho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__add_pages() returns on a sparse_add_section() failure without removing
the sections already added in the same request.

For memremap_pages(), the failed range is not counted in pgmap->nr_range,
so memunmap_pages() skips it. The sections already added in that range
retain their vmemmap mappings and subsection bits. Retrying a
section-aligned range can then fail with -EEXIST.

Save the initial PFN and remove [start_pfn, pfn) on failure. For a vmemmap
population failure, section_activate() already cleans up the current
section, so the rollback excludes it. If the first section fails,
__remove_pages() receives an empty range and does nothing.

Link: https://lore.kernel.org/all/BAD58999-1EDD-4A37-ABA0-DB1BD8AB3453@linux.dev/
Suggested-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
No Fixes tag, as I couldn't identify the commit that introduced this issue.

 mm/memory_hotplug.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 796af1028ee2..ca4656698148 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -380,6 +380,7 @@ EXPORT_SYMBOL_GPL(pfn_to_online_page);
 int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		struct mhp_params *params)
 {
+	const unsigned long start_pfn = pfn;
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
 	int err;
@@ -413,8 +414,11 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
 		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
 					 params->pgmap);
-		if (err)
+		if (err) {
+			__remove_pages(start_pfn, pfn - start_pfn, altmap,
+				       params->pgmap);
 			break;
+		}
 		cond_resched();
 	}
 	vmemmap_populate_print_last();
-- 
2.39.3


