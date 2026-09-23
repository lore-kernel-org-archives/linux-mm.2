Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E81C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06C9C6B008A; Wed, 23 Sep 2026 02:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0440D6B0095; Wed, 23 Sep 2026 02:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C596B009E; Wed, 23 Sep 2026 02:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C80DC6B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:37:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5FFFDA6A9F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:37:12 +0000 (UTC)
X-FDA: 85244069904.28.74C1A4E
Received: from mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1664B140006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:37:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="eVFv/uIS";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790145430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mqstWNbImJ04fhpAb+SAcI2X/c5d1gv9/4hMM56s6uQ=;
	b=inpYJBpxMSvrX00ix/N1y/FOefZJuYE1yNuCPKOb/GQdeEgc4rbjjC/HM3eo0anhD949os
	hyYX65LN8c2dJkHyQ05OvyL4jM0/9Zp8kYhcHIHKzvujhgw7Q0w0JjHWYiHfZVoq4anZUT
	CZo4Jktn6mA5/1b2rVM28WsuR6NvM3k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="eVFv/uIS";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790145430;
	b=XZSHw7AJ73gWJK7sVV529OGwNWSSxh51RvgCL3yHmO+zrxTtzTJfAkKtkzCz/9HHvSjrRT
	Le/mfO0g70HAyGDfYiY5acudC2Mlc3nK4swXtS0Q/uiZ89frGZrGxOzXEcxIVA0wTs7tz4
	bDz8ULZbQLhj+8S6ErDQthEghRftv48=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=q6FUjfAvrde7ObIfU3V3bTgB9v/JDqJhh9doDVfzOdI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790145423; v=1; x=1790750223;
 b=eVFv/uIS+I1VHWvWtO6OR22sC3Wuuezbinq6fogB4nWW7v6eQkWcSATeQY8bdJ/bU8mATOlw
 567/twCJ84E0AErl7Ic1oz6B3YECEkoGeliM3lgzczHhxv4vCHLsVigRFA3csi5PAoeOQGLVrMf
 g65B3MkOV26laY79W7spbPIM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7a7d515496bbdaf5;
	Wed, 23 Sep 2026 06:37:02 +0000
X-Mizu-Trace-ID: 7a7d515496bbdaf5
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>
Cc: netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>,
	Erhard Furtner <erhard_f@mailbox.org>,
	stable@vger.kernel.org
Subject: [PATCH v2] netfs: Fix missing alloc tagging of direct mempool allocations
Date: Wed, 23 Sep 2026 14:37:59 +0800
Message-Id: <20260923063759.34667-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 81cdqa9r3ijex5kn6148tmq3e3597i36
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1664B140006
X-HE-Tag: 1790145428-367539
X-HE-Meta: U2FsdGVkX1+NgnckZWeTSii3+lLuyMin9i9o9S3lJz15hIpiI3hAgmuI2px0cG/6zKq7oI2Kv6aHQ6OuBT8dfI9V9nwlGxuzKS8ZqwFx2Eu2dlTZ+sPd6I2PwrQRou2NZUCRYzs4U3vIJbA+W/YDAykPkzjC+l9gCg7tbKU1cMosbnKMyViKSQIjJmaWcBc7HNrsvX0lRXqow2WqLjj42LOjlBABSVhpnMvXmxoq5vwQqE1W8/ZeRazTq0MAOurzmKA00/HuaXAcJiOFkgYGkmqKvE2/p26Vldi8Zi9Ugu9bDwFQlToqtfG20gqvc4cGU0Wyv27HIxiJDxn6lExAgleQmdRi0hi8JP6oWR2cDMJWobjpUVXLC9XkgcbDfNMlD80rRzZp5SHzsl2RuQ1TsWoOgIvSXNBwgT11/AMmSWOa7z9uqzok6iyqAEgejrhjpNwU5Wa6eVrs34iw/zNQJsaC54DPc+zc+pvRPnTatukWg+pr+W0gNkD+7PFKynNKvBK/xPMEnEBvjeEZtsDD+IenQWDwqZqEPUVlBirPOlfiX2Ej7H8bVDyuyRd9cgD94F8e1WN9QsKNkDp6AF+flPLHuHST6VSJp2kB8u6+ZK5fscFuucJtsGpf7wGhVrm+6Xo8Nh+sTK4THHb6128I2zqSBvLeWlLRGMjMZn8YB/GSbSXqQnyJcJQCGCarsNErCdcUZpY2WlDKRpOOON1TDgvcEzx6aqdq1JkJRnVB7kQt91ZtS92jP4GzM61j2laXf3L3lTi5C5XTuPb1enlcUNYd378lrggx+7/VoZ9AlZKb4q2s1DYrCC+GzjmhCCduY1iPTiFBhlgzVk+FIgFL+yJXntw6szkP+dHGC3XQV+7d6F7brYnHGKTtxaoNlWPWXv9htjvwzOqLwchDwfZXrSUrjc9mHwcT2Rve2aVekAQOm4Pe0gI8g+qQ+i60bfqzmpQBixeaas4ZnA+QOJd
 HJZXYmoa
 xTpJIBcVkOkRIDDuPSssaTrmYrMAumwHqg55Ttb780UQgKCeW4EzUoi7yAPrB/9awyaWZ1OI019vBdkoOlDrw6GHXKRLtul6f8M/CWV4QEPLn4OX+gIYAbMuXSFcgU8NXnYdKea+6Sfqo2ZkVRE8QPTq4mzK6mtV6bg6TPq7Vg5GYLSFYwr29LS7fwLK9GmrKw2VKFzgIcZL0foIpzKvK+5GlTM/WEOvltHrZa2gqj0+QODESsZIOhhltxzy+3+GW2S3Jimy3BC64ONozDdmdGHSYPfjV7f4NoqOrMKkn/94E2N9gkud1ixX/JJPHOYmfSd53CHeRM+4VpqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 1d78d56c43ef ("netfs: Fix folio_queue ENOMEM in writeback by
adding a mempool") added a mempool for the folio_queues and made the
request, subrequest and folio_queue allocations distinguish between
writeback and everything else.  Writeback is part of memory reclaim
and must not fail due to ENOMEM, so it allocates under GFP_NOFS
through mempool_alloc(), which may dip into the pool's reserve and,
if that runs empty, wait for elements to be returned.  The
GFP_KERNEL paths, which can return -ENOMEM to their callers, invoke
the pool's ->alloc() callback directly instead.

The direct call, however, skips the alloc_hooks() wrapper that the
mempool_alloc() macro provides.  The pool callbacks, mempool_alloc_slab()
and mempool_kmalloc(), call kmem_cache_alloc_noprof() and kmalloc_noprof()
and rely on current->alloc_tag having been set by the caller.  With
CONFIG_MEM_ALLOC_PROFILING_DEBUG=y this leads to

    current->alloc_tag not set
    WARNING: ./include/linux/alloc_tag.h:161 at __alloc_tagging_slab_alloc_hook
    alloc_tag was not set
    WARNING: ./include/linux/alloc_tag.h:166 at __alloc_tagging_slab_free_hook

at allocation and free time respectively, as reported when reading
files on a CIFS mount.  The allocations are also missing from
/proc/allocinfo.

Wrap the direct ->alloc() invocations in alloc_hooks() with a new
mempool_alloc_noreserve() helper in include/linux/mempool.h, next to
the other alloc_hooks()-wrapped macros such as mempool_alloc().  The
GFP_KERNEL paths keep their failable allocation semantics, they just
get tagged now.

Fixes: 1d78d56c43ef ("netfs: Fix folio_queue ENOMEM in writeback by adding a mempool")
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/all/0b004319-9ef7-437c-a4dd-174d6a9a83db@mailbox.org/
Tested-by: Erhard Furtner <erhard_f@mailbox.org>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
Changes in v2:
- Move the alloc_hooks() wrapper from fs/netfs/internal.h into
  include/linux/mempool.h as mempool_alloc_noreserve(), per Suren's
  suggestion, so it is not netfs-specific.

v1 Link: https://lore.kernel.org/all/20260922023541.51532-1-hao.ge@linux.dev/
---
 fs/netfs/objects.c        | 4 ++--
 fs/netfs/rolling_buffer.c | 2 +-
 include/linux/mempool.h   | 7 +++++++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index 7f6a3e912602..ad549daa9c79 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -34,7 +34,7 @@ struct netfs_io_request *netfs_alloc_request(struct address_space *mapping,
 
 		rreq = mempool_alloc(mempool, gfp);
 	} else {
-		rreq = mempool->alloc(gfp, mempool->pool_data);
+		rreq = mempool_alloc_noreserve(mempool, gfp);
 		if (!rreq)
 			return ERR_PTR(-ENOMEM);
 	}
@@ -214,7 +214,7 @@ struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq
 	struct kmem_cache *cache = mempool->pool_data;
 
 	if (rreq->gfp == GFP_KERNEL)
-		subreq = mempool->alloc(rreq->gfp, mempool->pool_data);
+		subreq = mempool_alloc_noreserve(mempool, rreq->gfp);
 	else
 		subreq = mempool_alloc(mempool, rreq->gfp);
 	if (!subreq)
diff --git a/fs/netfs/rolling_buffer.c b/fs/netfs/rolling_buffer.c
index 424e77a9a109..d30d5ef6d86e 100644
--- a/fs/netfs/rolling_buffer.c
+++ b/fs/netfs/rolling_buffer.c
@@ -29,7 +29,7 @@ struct folio_queue *netfs_folioq_alloc(unsigned int rreq_id, gfp_t gfp,
 	struct folio_queue *fq;
 
 	if (gfp == GFP_KERNEL)
-		fq = netfs_folioq_pool.alloc(gfp, netfs_folioq_pool.pool_data);
+		fq = mempool_alloc_noreserve(&netfs_folioq_pool, gfp);
 	else
 		fq = mempool_alloc(&netfs_folioq_pool, gfp);
 	if (fq) {
diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index a0fa6d43e0dc..6da502aef2f7 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -70,6 +70,13 @@ int mempool_alloc_bulk_noprof(struct mempool *pool, void **elem,
 #define mempool_alloc_bulk(...)						\
 	alloc_hooks(mempool_alloc_bulk_noprof(__VA_ARGS__))
 
+/*
+ * Allocate a new element without dipping into the pool's reserves or
+ * waiting.  Returns NULL on failure.
+ */
+#define mempool_alloc_noreserve(_pool, _gfp)				\
+	alloc_hooks((_pool)->alloc(_gfp, (_pool)->pool_data))
+
 void *mempool_alloc_preallocated(struct mempool *pool) __malloc;
 void mempool_free(void *element, struct mempool *pool);
 unsigned int mempool_free_bulk(struct mempool *pool, void **elem,
-- 
2.25.1


