Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38BEA606A329
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 19:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LYqVyDMf
Received: by kanga.kvack.org (Postfix)
	id 2201C6B00EF; Sun,  1 Nov 2026 14:41:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1556B05B1; Sun,  1 Nov 2026 14:41:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C00A6B05B2; Sun,  1 Nov 2026 14:41:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D87AE6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 14:41:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD8D31405F4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 19:41:00 +0000 (UTC)
X-FDA: 85387568280.06.91DA826
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7E4E720002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 19:40:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LYqVyDMf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793562058;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7XMDi9CyJyqlkPG+GPZu8bn2Eo00P3/ky4TB2vvOoyk=;
	b=rFIvyuDIjrRlBq5vbomuCBlDkGQP3A+QdAujcPe727jU4h6wo0Cejzrj63c2k8JkoHLybv
	11p9ReJVWqxBkzKrp2RIEOfSM353VtgkVvAkj59UYBzGXd4C/eNjRu/FycVV6IBd6ZfTDj
	/BSeZok3EWAqDKqPMqjyqNy/KGNHmqM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LYqVyDMf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793562058;
	b=U/iqg71LLRHGH6WuIKiInjx7bi9O4nx2HTFY4g4s1bDliX1F7l+cRTIYWpTw1dh1tlvCcJ
	yMnBYFLM1RHNr2IfHXuGrBYadhWd5lRqb9w1t0wQ/XVljv2yjm77q2eeYX5UGjUNYPF7OJ
	cgalvWq5NmQrbmQ020JmYaVCeBXHJ6Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF8D442B5F;
	Sun,  1 Nov 2026 19:40:57 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793562057;
	b=zxZV+Oy8wV1D+AyQbLyRO0WlY9+e48SJoHoI3ba53/7kVdXYxU+YyJJZS/T2ox4UIg/J
	 hU1qHvLuKTHaw42KHaSSbnLA/gAYqMD5EPQndtlPBoi8oGTiK8Hhyr7KsNTw1v7c8n6+0
	 1JEotGO1s6BRK//BWGTV6nCj4sE/qkd5zXDX51ZOHwFj6W9i8r2RqDJ0aULEOmCe0QOfN
	 wik3Yx2iuOOvLhjgPh1Nf/ARUqbATfKTxtwI5hRNRsfjma4nyb2hcG7Fsc0o7STzjoFy1
	 dggr8Ld9N97jV/IDF5XgxEU36s92jI2ji1XQmTIFcMXanz4u+xpIItb4lHxS5C36ZtA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793562057;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=7XMDi9CyJyqlkPG+GPZu8bn2Eo00P3/ky4TB2vvOoyk=;
	b=yV6dYbOEhu5JSD9PZm+qO7GCj+GKioutI2rBIwDtrBnSplwzk1gaMoatfFeMGfHVNFvI
	 Gmg9RrksfbCLMT9Q3RPRHsOTYyU7kmfoyqIP6acFkA3uc/cVQAIQDJBHvtqKQ0np2HStD
	 2yfctUnfimcJhox5ZSVZ5d2YM5OxQB2T7S82wKV+j+JoC+8JsKzL/z1mFzewa/1wOXRFI
	 dYnOn0hhFP3kAw1c3C32FwCaUAnz3Ly0b3NM384g/S8oHghGe+EcIDkVqp8CP3zCbTKD6
	 ScY3Q751oXn1iFfETMXqH12TE9MQD6Ll8WSxZ1iqpX16K/nurTGY/8u2llnVIcPK6+Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 030231F000C1;
	Sun,  1 Nov 2026 19:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793562057;
	bh=7XMDi9CyJyqlkPG+GPZu8bn2Eo00P3/ky4TB2vvOoyk=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=LYqVyDMfZgOyNqQRM6wvXgEYSfdlTOIM0SKR3H5shrw+i0/XRhQA7JeuOpfdkj/QB
	 dlYHRh7G4IibxzD7/fQ5MnJt/ErZCfxxDAf9nIB7ecTjK6G9gS+Fn/LWtqkDHFeE6c
	 fZXivq0fOwDu5n6QK7kAVfjAUJbGNc2WnaBj19zy1iG1BiUfj358mdrnzzTipnQog/
	 i9dhE9qEP6SfaYXZB4K4uC2nW2l9Pcluzrxs+h+5XPw5FnUJYsb0fDdJRKqw3GqCcb
	 /6ZdiLzZrFw7hlqdOb+IcIkRBr8OG0nw1lrQAe/8N8y/5fkzI+6Ak87UDE02QRa5Px
	 gb1MlGNkv0nug==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 573A546250;
	Sun,  1 Nov 2026 19:40:56 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Sun, 01 Nov 2026 14:40:56 -0500
Subject: [PATCH] mm/memory_hotplug: don't offline a hwpoisoned page still
 in the page cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261101-memhp-hwpoison-pagecache-v1-1-ed8785ca44eb@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMyw6CMBBG4Vchs3aSUhSjr2JcjOWXjglt0+IlI
 by7FZff4pyFCrKi0LlZKOOlRWOoaHcNOS9hBOtQTdbYvjX2xBMmn9i/U9QSAycZ4cR5sPTo5GD
 30h0N1Txl3PWzrS/Xv8vz9oCbfz9a1y+oKOfyfAAAAA==
X-Change-ID: 20261029-memhp-hwpoison-pagecache-a6e3a524a370
To: David Hildenbrand <david@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Gregory Price <gourry@gourry.net>, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
 tz2294@columbia.edu, stable@vger.kernel.org, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793562056; l=5557;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=4LOLUja2zhU2UmZEiAhPn4FmO7n0a/B92rAAWeju898=;
 b=id4ER9EJOI/KEW5CRMKHacr3GbM19oDkiK8h+mizdyCCmDEw/R1+cUw4WSv8ve40O0ZIjZKFC
 wBbU5QsS08nBzG1vzh9tN0wgXi5yoVweIBBzOmid+9oGZFmLC906wZe
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7E4E720002
X-Stat-Signature: 88951qdsuyibyycjy9cn1ctmuw51ap7y
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793562058-733060
X-HE-Meta: U2FsdGVkX1+AIQ5j7mzhrXweU9ylFSFnDsd1URBqGys/ROhJlQl7owek2ZgGkNPcJotR6PwnlDbrQJn+/fWSUnUpwNAfec6QWxzyLxUJ1rVt6eWzgFxqUW3ZvZXw0a3z6yJdJ8eaGO8EJ5vZY3b4e460RvFaek/Ebc5fPhY7j8B9R455JrFI2OiHAgg4JWU+8zs2dCaR4pZmzggzqrzlFKPzfyihGffvr6OVTe80zJnw9qmCnd5bDudDdgGgvx/rd6BF1QB278E95GpUAtE9NVR0wXTu38gkkBos3WKl3bzbSATtLRcqGFMERGGOoNzMaboqiCFqRotI+hkkbqYTYNfFaZQ5lnVvFGJjm7yijwq3vlzVlAyjFPZRlC/3vI7nY6tlo1bkm9iqlXMLcqSbWG/hZ5yCIAUPDIGkUJBx8lSE7qDEAHxgB60HpOFxra04kcu/n/R2F2Jx77yzesl8jmvyCIcmo3DHlWYUqMA7pTQwLK0I4TnOSFqiFuJGcgXDEOKVezB0Y4b0k+lp0V0lLxHM/U552GIHK/P+fegG5luZoi5isB6SK0kZxPlpd+jaofsnnZpR9MT1BQ8xgRld5mfeuxlGYnogQaOduG1ezxmOieUGdy1Y1LHOodAgmLksSrRq81ODPZ4bvZkbV7I9u3D3Hi26/eRKlKiUf84mUaSQlaCtTja6N8MGRUiwfOXbym2UUXtg6lSbblOPaH3ozSEIVCz70vdtQCtekguV9a+1PruP8gGAA89yafkGffTxuXOXvGTRxd7CyiBY1492M2GlXzp79spxQ7mFTtG6hy712j7S8OJw876GdYCFQFuASfMaZ7XO1kzCi54SmV2kgpT6c4er4GcEwxD+y9XDixokMkyEKI8v0zU3f3qRnma4GLrCwtjpGLghD5CtWKzDsFHHGhvsHYPr/129/zyC2BknnJL6Syp6w+Yv24ZLZiSOsE3wMpb4+G2Iij7O5as
 109HJGGR
 rp3fCfy/G4jZP7JY4xN1YuGNa4/HM+Z+q/iHsb2fBAMUN04ON/F+R71K4WyV4QFGeZbJ24DmGHsTTyr2nAA3J69jg1I/dLTfHSHypE4bAokfOIN4FhuAeOx9OytbY3vedmZU/M21ZwRzpHFRmby4aGFe5hixyatjb+Fyr8mLQ1bqKmqfTQZgp8Om6vtCYAguF52t6kXFeu8nPiFpIip3/q/5gwX1fVWamSLfYQvqlAcq1UpRsYpGsolOgG/husxDknEbMtRibx1IGDVuyjAqI1xagWQ9Oo2b7Hpz1YchqW9UQp23rdPLMqYYvhQeTHL7JOOguJUXOoKuWET7fM1EoyyWrBiVLHJIh++0KUwjWay7QsAQnW6KGR+ToL0C3W6eK7+M/WiQrwTTFPHGGJxeeeixqqt7Ci9nYRk7CVLX79ztrbtTLNGqdL3ssZMq+qVhNI2f7PYpChY/1oK8ZJ59kPhe8iwqWwXwNBIOPapVMCEFI/geDYJMqV1As3pD7oO8Sb+1XJbuwkGO+6XGVfjLTrs6xCIgpw5nNV0dbh4v6gfrMxTCEBO6AQf9Iiw2TdbUuyhk7ywgWplsa3L5uxfZB+Upw5bPx9H+yZfpGlZbKOq970c74rbkwaH7niE0JiC8xTmSgSXi1hEY5bnqC2kULMYL89zP9E3h8Yp705TuxV1Am2r/vkpWKRvmJYFPPx3BOv+4ZfXiil9aoEoQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mani Tofigh <mt4022@columbia.edu>

Memory offline skips hwpoisoned pages, assuming nobody uses them
anymore.  memory_failure() however sets PG_hwpoison before it takes the
page, and taking it waits on pcp_batch_high_lock, which offline_pages()
holds for the whole offline.  A memory error during the offline thus
marks the page and then waits while the offline skips it:

  Task A (offline_pages)               Task B (memory_failure)
  zone_pcp_disable()
                                       TestSetPageHWPoison(P)
                                       get_hwpoison_page()
                                         /* waits for Task A */
  do_migrate_range()
    /* P is poisoned (not migrated) */
  test_pages_isolated()
    /* P is poisoned (accepted) */
  zone_pcp_enable()
                                       /* P is off the LRU (Ignored) */

The block goes offline while the file still points to P, and the next
walk of the file's pages (here drop_caches on ext4) crashes on a struct
page of offlined memory:

  [   11.710348] Memory failure: 0x24224: unhandlable page.
  [   11.710372] Memory failure: 0x24224: recovery action for get hwpoison page: Ignored
  [   11.765371] page:000000008c304eee is uninitialized and poisoned
  [   11.765389] page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) == 0)
  [   11.765440] kernel BUG at include/linux/mm.h:1990!
  [   11.765458] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  [   11.772284] CPU: 3 UID: 0 PID: 85 Comm: mfoffline Tainted: G        W            7.3.0-17087-gd865f2677c44 #1 PREEMPT
  [   11.777970] RIP: 0010:find_lock_entries+0x8ee/0xad0
  [   11.798761] Call Trace:
  [   11.799297]  <TASK>
  [   11.803284]  mapping_try_invalidate+0xfd/0x2c0
  [   11.810571]  drop_pagecache_sb+0x111/0x330
  [   11.811572]  __iterate_supers+0x2e2/0x370
  [   11.815863]  drop_caches_sysctl_handler+0x74/0xb0
  [   11.816994]  proc_sys_call_handler+0x2ec/0x440
  [   11.821360]  vfs_write+0x545/0x1250
  [   11.825220]  ksys_write+0xfa/0x200
  [   11.830202]  do_syscall_64+0xfb/0x590
  [   11.832084]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  [   11.848423]  </TASK>

Once the memory is also removed it's a use-after-free of the memory map.
tmpfs and the swap cache can end up the same way without the race.
Since commit a76054266661 ("mm: shmem: don't truncate page if memory
failure happens"), memory_failure() leaves a poisoned tmpfs folio in the
page cache on purpose, and it does the same for a dirty folio in the
swap cache.

Treat a hwpoisoned page whose folio is still in a page cache or swap
cache as busy in scan_movable_pages() and
__test_page_isolated_in_pageblock() so that the offline fails and a
waiting memory_failure() can go on.  A later offline succeeds once the
page is out of the cache.  With the fix, the offline fails with -EBUSY
and the file doesn't point to offlined memory anymore.

This bug was identified and confirmed with the help of a deterministic
hypervisor currently under development.  The C reproducer below however
hits it within about 10s.

Fixes: b023f46813cd ("memory-hotplug: skip HWPoisoned page when offlining pages")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Taking get_online_mems() in memory_failure(), as in Gregory's series
[1], would close only the race and not the tmpfs or swap cache case.

[1] https://lore.kernel.org/all/20261027042204.3741307-4-gourry@gourry.net/

Reproducer: https://github.com/manitofigh/files/blob/main/linux-repros/mfoffline.c
---
 mm/internal.h       | 9 +++++++++
 mm/memory_hotplug.c | 2 ++
 mm/page_isolation.c | 2 +-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index aeebb3e49ed1..ba7b1650a5ca 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1195,6 +1195,15 @@ static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, b
 }
 #endif
 
+/*
+ * A hwpoisoned page can be skipped by memory offline only once no page
+ * cache or swap cache can find it anymore.
+ */
+static inline bool hwpoison_page_offlineable(const struct page *page)
+{
+	return !folio_mapping(page_folio(page));
+}
+
 extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c9cc42e54f05..3d36f7f2e04b 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1820,6 +1820,8 @@ static int scan_movable_pages(unsigned long start, unsigned long end,
 		struct folio *folio;
 
 		page = pfn_to_page(pfn);
+		if (PageHWPoison(page) && !hwpoison_page_offlineable(page))
+			return -EBUSY;
 		if (PageLRU(page) || page_has_movable_ops(page))
 			goto found;
 
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 5aaad037384e..beb09ef345ee 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -593,7 +593,7 @@ __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
 			 */
 			pfn += 1 << buddy_order(page);
 		else if ((mode == PB_ISOLATE_MODE_MEM_OFFLINE) &&
-			 PageHWPoison(page))
+			 PageHWPoison(page) && hwpoison_page_offlineable(page))
 			/* A HWPoisoned page cannot be also PageBuddy */
 			pfn++;
 		else if ((mode == PB_ISOLATE_MODE_MEM_OFFLINE) &&

---
base-commit: 243e8cdab64129d6207c398f8cf5fbb1962ff7e1
change-id: 20261029-memhp-hwpoison-pagecache-a6e3a524a370

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>



