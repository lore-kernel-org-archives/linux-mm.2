Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B29CCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66BD46B0005; Tue, 26 May 2026 08:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6437C6B0088; Tue, 26 May 2026 08:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F0C6B008C; Tue, 26 May 2026 08:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5106B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:22:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 67267A03E7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:22:51 +0000 (UTC)
X-FDA: 84809484942.24.8410338
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	by imf10.hostedemail.com (Postfix) with ESMTP id CE0DEC000E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:22:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=vjF9ylLv;
	spf=pass (imf10.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779798169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uLM7/NlopyOMxo2181Ezg67uHn3G3gEhhqZIJrXI3j8=;
	b=rfG9nRO3Ur/qIaf4CxD80cXKYh5VGP8gfBxyIay37g/4vDuOXOkFeRWViT7yk3rSVInwA4
	LiwCSZ99LCSmpeR1dGIsT7JhrCe3765l6Glg61XPRJpDHKgD1VloIBUSKZi1No6UDFaBzK
	0AkkrRxBPQjFw36R4CksKl3xN4XVNDs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=vjF9ylLv;
	spf=pass (imf10.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779798169; a=rsa-sha256;
	cv=none;
	b=dkO1+4RlfyA/mFJK7GjfZQTRRBmURSSt9LchNodkcjrhbarJ7rBR0ak9VSqBl/omN0ON/O
	WCjxc3yNZ2QWiEPpWrVkUavxJ+roiISuh4qbwKQTWzlLfRY48TIWxwoOduSp+esbzfq+HB
	RCisogzeOLy0UMXxUBk7vLbCWW0Z6M8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1779798164; bh=uLM7/NlopyOMxo2181Ezg67uHn3G3gEhhqZIJrXI3j8=;
	h=From:To:Cc:Subject:Date;
	b=vjF9ylLv78QN4ds2Kqn8tCTTfZwLfYeinXb2FKY5oWNhU+x9eKX5+xERXpebYtjW/
	 rxXFB9TchFxl1kQORSvIHtzFI7hCoPNDJiu3qsxLQAcCFHxYW31ozKDY8dPdJXD54q
	 wOtycmiZ6tCNyJdJctHqt0Z+32Ci2xUEy4b0hj18=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 5A9A9C49; Tue, 26 May 2026 20:22:41 +0800
X-QQ-mid: xmsmtpt1779798161t1d4m5qgl
Message-ID: <tencent_F59F2BA2CC5779308E10DF54593C736D3E0A@qq.com>
X-QQ-XMAILINFO: N9lasXYeZMXW3yzfmkc4S95cmtDONwRrGXy7pxZoIOlHv2m5QUm1v/pKsxH3jh
	 P9cFmdRsBtHJGp5jf+MCQVm3pzY0FW6mOmd6pMkNcU6meOMRPRNm5jjaXYQ/+kLmu/Ly/+JZAOB0
	 n9XLxBLeXSHkhAauXhPQTiyO0awxRxxG7U1pAU2C1rpjFMIvS2OTKAAtI3h9JnB6LwrTFV3ZcIg+
	 6d74K9wGSuismigEBmT5RAGPUnPXw7Bk+kvN5OF2HNTDo5W0BO2SwfzQ2en6xqN2x5VMVLcYmi04
	 dS8FdhPhi6Dh4DjdpMvdQd6urAadNtbpL3+6SAf8asePWFVSZzI+41PhZOAmKzqrx346+KX5oqG5
	 5FYnJ0/W+os0QdpYv8VNY1e7RYtvBgaUQt3m80KogU2cIvkFoVQyMd+R2F2Wp2jAu0eZqh58KV/Q
	 fGHWUttqxp8bWABoWZPrivaHpQ/6eViz6C5UGeKkTcqtbgufhyRlKoFyC627tLDjnt4NaLsKr905
	 OUKPh3LJVC6HGPNlxpuR/7sVTDjnbiDsLNOo0jYpbA8gbwA4Iww/zB7bZfpgJgjxLVmfKpTRqq00
	 8oiVjnqypFtPXH9WtEEJycSv7i/UBAbSbLNCLQQriK6soIj6qZUDemuvTB9ceNQECw6u8HHnEvBV
	 IoAw27byIBTJxQpR4JD3J8LCex4nYpcmp/tbI9PaQd8Fxug+vH6o/plpravufCMPkcJdLcI14ctO
	 WXfmtQkY/QvfUtAsUVvHk2KTzWxxkej7+uQxDQiJElc5DJaO29pKLWG/7z0JjDA46pxB2dFi6O8r
	 RPSPbz3Re4eJrgvmxrebedZ/a4FaW6h3GrUqj246BPvUVwsfMq+f33M/Y8vKImDXGYxC1CWwz3/t
	 yK0ygVrSJZdPBBbOR4gO5BN2EyJ7XNYQL9jnLjmy/V9mQxTuTkwL9BZvOTg3b2D+2BMx3JnV9jh7
	 MhlZTS91ca+gQioHWSrEzQHWGrtF7GoyVwDPZX1RRrNWlT0IymbhADrutZC93NOpuZ2U359tQHfZ
	 +bH1Fulfv8N886Msi57mxj29d4Seo=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/compaction: respect cpusets when checking retry suitability
Date: Tue, 26 May 2026 12:22:41 +0000
X-OQ-MSGID: <20260526122241.609248-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: baoitemrkccdtdybnx5n95btmm9d3c74
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CE0DEC000E
X-HE-Tag: 1779798168-923481
X-HE-Meta: U2FsdGVkX1/9EJpvWUEVqEuqPx6uB2B5TSt0pmZF47+oOwvoElOgT2jcvBEuY1yl/iXLgbCjSTah+NeCzM1lB28m9N5VVwb/w9ZaTJNbo5KCiKFEfH1ZRW57sQNbZIuKLI5UMKomhXBEo6J+TOBkGrlTApVE4W9W7V4H06ylWIgafAy1vF2+76g2E38XZPduSh3Rs+ROf+FKT7gavSBOFHtaot1JB5pxfEeD12NjC9dsNAjukz2ikx/fSNT1R6REbaOTHmf5Z1Ub4h1mHxnZJ9zkmKyEjfB4tNdmOeaVGxn+bXMLy/9MbivP5+PLktEdIx+0xPH1+dXMBOV77JMHlgLEaBtNg5BO4pvU4x4qMlhz7o3R4prVqzuosSJo28PBHmZQeYKu8x28SzbUZzgEEPid6bY0kospMQNkV0BWubkK2Z4n+ON1xA0+S1cENd7JMWPd/r+XpbYPEtVZjkeW1bAZZNrzyd5KoaFqCbbvXfljACVfUevzhB2umWUw6pPm1PpL1h7TFWoyIqXb4bJ7Pktvb/uG8GVuIHveQWaf6xqXlAhfwzErx0BJ3fLN3Mdadncn/MKFkCdO026M2WmExl/0hV8P0ufPn7MMaXtqzFjNYW7wN+T8wazlClEqLtSsz+Ecwr2Gc9+ia7/9/5rGhaUBieUR8xYYo1mp5/krFnYDVGLjXOZl2kGsM6BXskypgfUJTIj4vHk01IVB2Q8Ua4BtaYbiNroNCXPWntxJL9jO7jWJogAI8dsP/VGXm0XqjFzX5WJk1AP6bL+/CiG3ysLxFyiwPRzRUQffDNCiz5EY9MkHrfVACY7qkxxagScty4z3zCxjkc/bPMD4sVit15ijNSKkIZIa3QahTmcKICTVTMKG9vgK7Zt57enRP/EVzRIIpejVTodcY0d55l/yPS3+0ZfbJU6bm+qbGDXTi913gluebOAGMDB8laPsvjSnmfvMjF8bFqj+zx20v65
 7Z8LuXkU
 H4dtb+SwRejefooSo15Kixx+V+jTnRZomEUoIAHHL5FZC60kqZzmEPCM6d1P5Sh3UMMpsHRgRhF6i8SzlpHpXF2Nv/qKjf5IeR7motEw3blPEq57AqkIF3K1qbZWAMLcetJgZEbcSP+DAzBnQmGZOeUcpRnVEITRos3UBWN3XL0nev2dkRcQ+3ao0X+7UbIW7a5AahFTggk0Xz6uLN1paueuOvyK2nESy+OE8mHw0fVrSmQunmcaWV6lFuXUxtp0zWaXkS+EX3cLkaFpVzzV/ZxrT+xnNBKmBTGIe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

should_compact_retry() handles COMPACT_SKIPPED by asking
compaction_zonelist_suitable() whether reclaim can make a later
compaction attempt worthwhile. That answer is used for the current
allocation, so it should follow the same zone eligibility rules as the
allocation itself.

When cpusets are enabled, allocator slowpath decisions are marked with
ALLOC_CPUSET. The allocation path, direct compaction and reclaim retry
all skip zones rejected by __cpuset_zone_allowed().

compaction_zonelist_suitable() does not apply that filter. It only walks
ac->zonelist/ac->nodemask, so it can return true because a zone that is
not usable for the current allocation would pass __compaction_suitable().

That does not let the allocation use the disallowed zone. Later
allocation and direct compaction paths still apply cpuset filtering.
However, it can make should_compact_retry() retry based on memory that
this allocation cannot use.

Pass gfp_mask down and apply the same ALLOC_CPUSET check in
compaction_zonelist_suitable(). This keeps the retry decision aligned
with the zones that the allocation is allowed to use.

A temporary debugfs probe was also used to call the old and new
compaction_zonelist_suitable() predicates in the same two-node NUMA guest.
The task was restricted to mems=0 while ac->nodemask covered nodes 0-1.
After putting pressure on node0, node0 failed __compaction_suitable() for
order-10 and node1 passed it, but node1 was rejected by
__cpuset_zone_allowed(). In that state the old predicate returned true and
the patched predicate returned false.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 include/linux/compaction.h |  2 +-
 mm/compaction.c            |  6 +++++-
 mm/page_alloc.c            | 15 +++++++++------
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index 173d9c07a895..c829c48d1c71 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -101,7 +101,7 @@ extern void compaction_defer_reset(struct zone *zone, int order,
 				bool alloc_success);
 
 bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
-					int alloc_flags);
+					int alloc_flags, gfp_t gfp_mask);
 
 extern void __meminit kcompactd_run(int nid);
 extern void __meminit kcompactd_stop(int nid);
diff --git a/mm/compaction.c b/mm/compaction.c
index 3648ce22c807..2295b2487dfc 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2447,7 +2447,7 @@ bool compaction_suitable(struct zone *zone, int order, unsigned long watermark,
 
 /* Used by direct reclaimers */
 bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
-		int alloc_flags)
+		int alloc_flags, gfp_t gfp_mask)
 {
 	struct zone *zone;
 	struct zoneref *z;
@@ -2460,6 +2460,10 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 				ac->highest_zoneidx, ac->nodemask) {
 		unsigned long available;
 
+		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
+		    !__cpuset_zone_allowed(zone, gfp_mask))
+			continue;
+
 		/*
 		 * Do not consider all the reclaimable memory because we do not
 		 * want to trash just for a single high order allocation which
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ddeb79fa12db..93d56ba339fb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4199,7 +4199,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 }
 
 static inline bool
-should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
+should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
+		     int alloc_flags,
 		     enum compact_result compact_result,
 		     enum compact_priority *compact_priority,
 		     int *compaction_retries)
@@ -4221,7 +4222,8 @@ should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
 	 * migration targets. Continue if reclaim can help.
 	 */
 	if (compact_result == COMPACT_SKIPPED) {
-		ret = compaction_zonelist_suitable(ac, order, alloc_flags);
+		ret = compaction_zonelist_suitable(ac, order, alloc_flags,
+						   gfp_mask);
 		goto out;
 	}
 
@@ -4274,7 +4276,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 }
 
 static inline bool
-should_compact_retry(struct alloc_context *ac, int order, int alloc_flags,
+should_compact_retry(gfp_t gfp_mask, struct alloc_context *ac, int order,
+		     int alloc_flags,
 		     enum compact_result compact_result,
 		     enum compact_priority *compact_priority,
 		     int *compaction_retries)
@@ -4892,9 +4895,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * of free memory (see __compaction_suitable)
 	 */
 	if (did_some_progress > 0 && can_compact &&
-			should_compact_retry(ac, order, alloc_flags,
-				compact_result, &compact_priority,
-				&compaction_retries))
+	    should_compact_retry(gfp_mask, ac, order, alloc_flags,
+				 compact_result, &compact_priority,
+				 &compaction_retries))
 		goto retry;
 
 	/* Reclaim/compaction failed to prevent the fallback */

base-commit: e8c2f9fdadee7cbc75134dc463c1e0d856d6e5c7
-- 
2.34.1


