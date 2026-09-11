Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD141C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 12:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6FB6B0096; Fri, 11 Sep 2026 08:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E6C6B0098; Fri, 11 Sep 2026 08:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0FA46B0099; Fri, 11 Sep 2026 08:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D41E96B0096
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:17:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76E0E1201D2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:17:09 +0000 (UTC)
X-FDA: 85201380978.19.50A2B9F
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by imf16.hostedemail.com (Postfix) with ESMTP id 405AD180009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:17:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789129027;
	b=NJ3HwFgDt0+57C3lNZUoNb9kBFrQkfLiwqMv48uyiywAYWlOiludUIyqQCxz6FezqqGfqN
	4Smvgvga/nPRpjIIK4r7Jc8B30R7g7zRM3jkDimEwtEriYJvheRSz5NeHGfrZT5lt75jqb
	mbdABbJOLyzHneIVcQIXvCPGE/X+K1E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789129027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QScYvYaIVWvx8ri28KE5vzR10ElcNGAwKM1+82oD6JU=;
	b=GQ1BX6ApdhiZKcC0yIeP7NgFtinfvldghALT+gvks+mt83r4M4LvqreobmPOLtg4nOL9US
	4NVyS3Vhxa5cb9MwAEiGKyCCxnqXfjy9mqGf7cEFdeWVES09SNIwYYpuGXAW4FHhflMfq3
	scLUOPWFVOJktauzzXJ1MKLVjpZAjCQ=
Received: by mail.gandi.net (Postfix) with ESMTPSA id F311F3EE2F;
	Fri, 11 Sep 2026 12:17:02 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Tal Zussman <tz2294@columbia.edu>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v5 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
Date: Fri, 11 Sep 2026 14:13:30 +0200
Message-ID: <20260911121341.178028-4-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911121341.178028-1-alex@ghiti.fr>
References: <20260911121341.178028-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTGjfH5CE7EP1PUuoeu/l2HFd6FdF++hpOgW9bG6M/BTM9F3kapSlk9U7ADtn6kKTISwel0dj9XMJHazyTDJbuCGf1+V6dtQFmMVDsz/j6U8zJS5UWFxlLhlncEBXEX9YRxi/C/PDeW/pyF/LEG1lC35hb8/T6rd2drmQXNcsrOJKh3DWo1SZ4dO8uSsp8GEYnEzEJX5QWflCLS80+j+zqwa+6xD+CuZg9bY1SF9yIU/qkfoyyWDW3JGDJ+aEoJjjp0rdWhKxA6l0J4myGoeFOAENCEQex0bOWMMxHXz5RPKc2sXHCvtKxjhZn7rZZwnhvVGcaI9kZTf2hXpEZopWDbcmhuI+lkgO1VZkGtngqreNfPmyf09XQyJBcekrXeysSX6w+3lqnF8NI/Sss5Y9CLV3j4zFIVtAvlLtHyzjI01JS4lDYoffcBQM7HP0VdS8IKursJsgKwnxu844P8/eGsX7PaeaSHiuGSsUeJrNPKAHUlC5OIcapVTLWGKEdCVdnt4Poaya2cUHRSJJfNVtdy8HPTF8ZTFiplDr9GK5+OWkhuRKiGPKtsY5bCnmQ65H5rYfs2ZF82vh/9baR+n6C7HASFm0sLmnUyyJsJbrU2U6AtoFd2H8ZiO43+6SsmE/N8qdn+EU909sSEeMIJHFlxk/nhu4blmsYlbO56LUzZtDw
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 405AD180009
X-Rspam-User: 
X-Stat-Signature: atug33wgpz9dhdydmtx4j5bwfseqnb4k
X-HE-Tag: 1789129027-720697
X-HE-Meta: U2FsdGVkX185oapH3SIdkhdzsNvnwguzYzXjQWYe9xDcH+AhKQExULYIVDcputufGMWjSrUQIf+KDCFQkp8fDt9IdluejlFzqBB4LN8L+LSR9kskf3QOXPbTeTGFDtMvO2IHybuy3FKUk1WywwGbGDgtvx4imh2Emx9qfKOMdzAd/VUrNer2+HfyQSXctwX4RfU5jdMgdHnnzkIvthhTIGYNY1aMWC9z0SLcRuPqWFtRDqsnPLqSjQTMptSziicv3/1e2e1VSKx1d+USmdssWyjPr1Npb3u4KkhN5T2/OqZTqkdqoMSRdDAIS0jMKYZdHNFUVm/iKVZGVL7XkKCsJCtaSO7x69XuDlkquf+VVUP+C/4heqJtke4dcBqFOVYdfL5UGrIqMxgacSJZTXpgh4zyLEjwmS4Fte2YcGmn1tm5y1vFeIsX7bwMb/RiCNipSAKgbix5+od8pNv+wyqF+paA7AvLUcrRzeIydNIi+6QuDW16/u6XKPss2RlN22VQvRci2j2FBJ7h+USdM0CzgHYlmcp4vMo6BUxqycXevaFPQiyvnrFUdsQA8JnkFP73zBMf5ZoOQMTU22L5fVt8phS77RLX58Isyaye3foLVEHTg4101WCR8mj4UClypLtVJPvzzhfmbCgq11LPW/tymYxWo9Tt1aNgQTX6YReG5kFTlSCO3vBmpdT1IzIq2Pm9ys/prRnlN7UbAELuFYEk9J+J+PEumOrdcQD3LUnpbjLqdiqV3jp7LlwxChPXs0Hh1wLwPkgqgABHsMJGeayh0+eYjaZBnIH4DxLHh5iPLVeJEHZOlzTbVsML61XqHZIYOW+PGhO5qNOjw/vCodavjq3n2YJTBoCv5bt9pxJBbEv7KCI6Iq+cgjUzuIKa2kZdX8KVZZrLLGky1LXwaf46LmVk7L+MmdFmQUWvXyo/ZtS7iYOLgvh79Y2r15n20iC9DUG3igQ3R0TrEN2SGdV
 dzMXojaA
 XetKJzDbBiQKIDDwCGRrQhkFuHigObMuCNelmmV3D8bz2aeisV7lthEElJKWtrFsnsNCCB2BtcM2pYz9O8ep8KcOoHc+4BwxDwQ9gbIhoqlBn8r06y4d8HyZpaKFT0FCDaJwu2Ci0F/IYRRRR6ocRlBpyG3UxXvLRB1rzEPEAmfXRYvW9gUn+gLmqGRxuBAbLZHM4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap writeback decompresses an entry into a fresh swap cache folio and
writes it back. The folio is cold by construction, yet it is left on the
LRU for reclaim to find and free later, wasting a reclaim scan and keeping
cold memory resident longer than necessary.

Allocate the folio off the LRU and mark it PG_dropbehind so the swap
dropbehind path frees it from the swap cache once writeback completes.

__swap_cache_alloc_folio() evaluates a refault on the new folio, and
workingset_refault() sets PG_active when it looks recent. Until now
folio_add_lru() consumed that flag and __page_cache_release() cleared it
once the folio left the LRU. This folio never reaches the LRU, so nothing
would clear PG_active and the folio would be freed with a
PAGE_FLAGS_CHECK_AT_FREE flag set, tripping bad_page() under
CONFIG_DEBUG_VM. Clear it after allocation.

That is a workaround: the refault should not be evaluated on a writeback
buffer at all. A fix for that is on the mailing list [1].

Link: https://lore.kernel.org/linux-mm/20260911092012.92399-1-alex@ghiti.fr/ [1]
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/zswap.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 0d2efe21f18a..dc8425d6b21e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1014,7 +1014,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	 */
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
-	folio_add_lru(folio);
+
+	folio_clear_active(folio);
 
 	/*
 	 * folio is locked, and the swapcache is now secured against
@@ -1028,12 +1029,12 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	tree = swap_zswap_tree(swpentry);
 	if (entry != xa_load(tree, offset)) {
 		ret = -ENOMEM;
-		goto out;
+		goto err;
 	}
 
 	if (!zswap_decompress(entry, folio)) {
 		ret = -EIO;
-		goto out;
+		goto err;
 	}
 
 	xa_erase(tree, offset);
@@ -1047,18 +1048,30 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/* folio is up to date */
 	folio_mark_uptodate(folio);
 
-	/* move it to the tail of the inactive list after end_writeback */
-	folio_set_reclaim(folio);
+	folio_set_dropbehind(folio);
+
+	/*
+	 * Drop our reference before starting writeback so the swap cache holds
+	 * the only one: the drop in folio_end_writeback() needs that for
+	 * remove_mapping_set_shadow() to succeed, otherwise the folio is
+	 * handed back to reclaim instead.
+	 *
+	 * Nothing can free the folio in the meantime: we hold the folio lock
+	 * until writeback starts, PG_writeback then blocks swap cache removal,
+	 * and folio_end_writeback() takes its own reference before clearing
+	 * PG_writeback and donates it to the drop.
+	 */
+	folio_put(folio);
 
 	/* start writeback */
 	__swap_writepage(&ctx, folio);
 	swap_write_submit(&ctx);
 
-out:
-	if (ret) {
-		swap_cache_del_folio(folio);
-		folio_unlock(folio);
-	}
+	return 0;
+
+err:
+	swap_cache_del_folio(folio);
+	folio_unlock(folio);
 	folio_put(folio);
 	return ret;
 }
-- 
2.53.0-Meta


