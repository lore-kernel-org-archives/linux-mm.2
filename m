Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F432CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4F56B008C; Thu,  1 Oct 2026 11:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C536B0092; Thu,  1 Oct 2026 11:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D95C6B0093; Thu,  1 Oct 2026 11:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF3346B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:34:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 826EA4040C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:34:22 +0000 (UTC)
X-FDA: 85274453964.16.6480592
Received: from mail-dl2-f12.google.com (mail-dl2-f12.google.com [74.125.229.140])
	by imf30.hostedemail.com (Postfix) with ESMTP id AA6CC8000C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:34:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="QYfc/dQG";
	spf=pass (imf30.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.140 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790868860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYLCjPpLfBewvYdjBDkNxTVbyP/bcB0jfIhL2wBACGM=;
	b=xpsdtICqpLrGUTufoCBqQY5fUWhLvXuSxD3UrZq7VmuOCZabLKfW+KmtWEJwVEelU3p9dP
	1vdpYV249cBDbwUkeThV1NAgW+wiY+GDo/uR2rUFSPrCVGE+pFnHshvGTTc6YaYh0jj3Bi
	4c/zySjkqzFLq1NlCODAQw75qAYfM4s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="QYfc/dQG";
	spf=pass (imf30.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.140 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790868860;
	b=hZWUydfpFWsb6JaCB8vuUiPDY7AEi/1iNQoRIh8weXxlQ+6csON5X0Ix0RXqYHLwgLEJI8
	S+Ir3rzVOgrxSwMSBIhi11fUXgaZG6UVoVg/1BaDn/byhxn2Xyf15rZyrqmdvKTPUrU2Mz
	H/h7A7xM76I7dBHRzYzd54AVPrWhjhU=
Received: by mail-dl2-f12.google.com with SMTP id a92af1059eb24-142dd05d97cso8848977c88.2
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 08:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790868859; x=1791473659; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UYLCjPpLfBewvYdjBDkNxTVbyP/bcB0jfIhL2wBACGM=;
        b=QYfc/dQGvg5AMFftoZ1ZVisuKN8Mj7vbno7cubrNNIP4i/LOHYOSprxtpfc44Kw474
         Tuv7pfXfpH58x1Php9zv5WOO06z4BK4sq5yotZEbiz9rfmoCYc2FqE91OWA91FsOVoyp
         fqTLgMgRUHx2Bu1061N3ZTBZxIPOblV3CJNL4GbcbBw+pChMTN4cC+z8PAbgGQ79yCQr
         oUxuY1bVl3FHZtGybc9R0tRCWnCeEEK3UFIfeWnIYUVcrHBz0tJ1mnWsr7ryaJ7kHfUe
         ftu4uxMyQg8glPIs70VDbYcL5F42wTcLaLQmc3NydsbBgnIUrQzABgsdIrmAwKl8h9yS
         lZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790868859; x=1791473659;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UYLCjPpLfBewvYdjBDkNxTVbyP/bcB0jfIhL2wBACGM=;
        b=GMlqG4ER+r748he0uPG5euZDShqsnswqIO+SOAXAQyI3aPo36pYYrfsEvoXGRGBQJe
         lThpABtslUhviaDH0tsAlmoqLK+fKaKZdCwIybfIJTwV4LMyykNx3Rq06MBIaZz8HzSg
         UzlPCulC5dLB4HzG22phSjKBRnYbpyXfw6ka9g5f+hhrr3kgqn4vguWO8C0OQ3wvHP9V
         83QvGMQP+5/IfcSQsz3oUlck5GV0HKNyEHfJa5gCxks1wsPPFmqWvz9wXjBkVMsRGOcX
         JsnFBrH6ccDCrHc2IdMZph1uRMrChDoXEHj4RoZvjWPE6m3G92yEVYrvAujC0sPvbtj3
         8Psg==
X-Gm-Message-State: AFuF++nRaG/t/pk4NjSf/9y9H+jzJcxkqdlkQIVpFzBCpHHeUu7xqe/y
	w77jHKeWNLLJ+kd6T4p0qY977jmYpqp3Cby5DreYzrR5jj8WpleO9vEM
X-Gm-Gg: AYBFou0uGukVWyuO+WPRgRxqubBn2f0OAA9Nax4kzp8MRnrtLeF8YvNTm6y0+kqB55/
	2ty1OF46QUmaKsQyzyYF7q95xe9JlgQwPVxkYKVUSpz0SBpMRSS2w9rPKPQH/rtNRQg2XGuj0rZ
	JucQ8kHTUN29OaijsZ7fOmzlOSlimuMejQpn/WWNn6XKHsD8Tx7b0pB1wk/fiEkB08LRdy68arY
	T2tmBUzH91Uwfn6aIxUU67Wj4W1sQ/YCjKexVad3+RnOsie90FpE8PBbB1epCka3X0NJMjeOI6z
	/HJMvmCIkrC0ysbI7n7NG8Zel5k+OdrO8R9euRaz35/BrAyZfH6FKXnxtZtRY9Hzab9Yh4oex9K
	s99XwcDWSC6/2XQNRgF+2UJETJocfhEYTDhl6lfnzsReRl5f+vGit5vf128p2t0crotiqvlKOdE
	F8aVAdw4jOeeXiswOFBy8vUXDXgjOT6sN87sZnffAgRxW7PRHWRHsFcD7h7L9CM2tZTw==
X-Received: by 2002:a05:7022:e1b:b0:14e:906f:9c8e with SMTP id a92af1059eb24-14e906f9dc4mr2454634c88.20.1790868859216;
        Thu, 01 Oct 2026 08:34:19 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14f266d1156sm146683c88.6.2026.10.01.08.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:34:18 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Thu, 01 Oct 2026 23:33:49 +0800
Subject: [PATCH 2/2] mm/compaction: defer failed async direct compaction
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261001-bug-mm-thp-async-compact-defer-v1-2-0174c7923430@gmail.com>
References: <20261001-bug-mm-thp-async-compact-defer-v1-0-0174c7923430@gmail.com>
In-Reply-To: <20261001-bug-mm-thp-async-compact-defer-v1-0-0174c7923430@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA6CC8000C
X-Stat-Signature: 69ijsjkq9fhpy4thfj9ey7gomqsw958p
X-Rspam-User: 
X-HE-Tag: 1790868860-222282
X-HE-Meta: U2FsdGVkX1+YJtRDe9PDKEIGUMDFZO5SjflCX1DUbtflR/ylTsMxgb5eIOEETW8F9ZqB/SDf3DJCkXPZD2SLj/RnYqylDsyeRDKAdT1sJOwG9KxWU5ojTZEQtpIp8Y5BCIMaQGtqvfnhIL75kiCTDajFDGlOFghgcfpA9qObkIJb6UKv3xDU+0A7i+6WhrrmQbidkLj8/+j0FqxB7w5RX+I+UuLUvwvRO1J5FJ0rA+olb3u9Cmhtj3CwRIuaPikQGqrL+obtNmCI8B3ZtIIvlNSpgZNIT0G0PLh/Lvt9p9dTgdG+n7eLQzMG3lZByFKZFtO9G+OVNeEcdBfDGhIMh9Fd7l+IMbvsy2fc596EGDbakwNZIFf8SayMTXNzYeq0/lhAYyq0dy7cP+qQdag58Y8R1QfX309+CWjPgLP+Egjnx4gyop01troB7YbQYy3Ww//oHPvzgxk9CaymFXpHbHkZDYzn2j47ljcpe/Us5QsjJ6S+sC9xp7eObX4d5h4l9CF4chwOBNfT06YzQ6ttBv+ySn75oI4fsWDzzwOlBDAtBg0IeUlXXmxvk01374queJ1ASKnawllvTblNI9+aqBlVcamNmhzZuteibykPwX6mBpbMSuk+32W7O19FNEQAFSOHQt1vy7dy9iWDja4ZtaqZFD91bFNE1HEwdzhGS5jh3M6IOgT73ZnWlUqH6jF+4xSpoJYV075ZGxCnpHB7xUSaNbN+x8aG6okOhBJ44ftoZLFAR+FBhO/Z3mhLUIOLVP1q/9AxNLYOyhK3kCQeGTRG5HgOqwcPzKYtox5C77CGxgqf31iMucVPI4/NpVMvyz2w6mY9w7PXdk3fG2/s88FW4r6SYzHoS5dSSVEyQ/+VzgguEB5nqJerRv4SvmOXG0pYFOUJkhWnTiD8iaVEgPSzebqccIzQlyUoXYUBIFPK4JUEHRX8g7rxwEKY9wUmepoqfPNufLp2UKXv9iR
 M2LOZiWJ
 nLPvJR8lkA91ptH3ADBsiqeeMnFutN+evjpDtdjLlmSCGmI1TX5WF1iY0MwvIhbj+KWf4pfiHZZMc7PurLiQydXheAqTDrLHb0G3wk1YJ3BH68Yc9VS654uH5M43NTahFoJ8M9Ii3jcOIs4EX0phB2M9GDzZct1hze8ldr2qtIoXeaY1I6PJEIiapT+jnyjmuPCWieAmCGVzyuYlxrbtJLQl1XGeKlxvy4C7ueF8DYoA589t12+xZUdzZUVUjJaOh9WOne14QSIcUPgxPbenaNMtyVB9VGJsFb745Murfn13ORI22XwyF/VDWI6DJIuV3RuL+J96CUBLoIi8Kqr8CQimHVGmSSZ6L4CJeGtU595V8bQjMn5nEu0gHa7WGD3XPfdw2/cR07tPVEgncf95Ckh9oSGhOiLPudg9sENW9x6xUnG1cz236HL9V7dbojCEWvdY6kr6U5pxQaPc9sCMelwQfauQRa6q8pZjWuOs8MFL3eqdFQGFWncsMRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A THP fault on a MADV_HUGEPAGE VMA first tries the local node only,
with __GFP_THISNODE | __GFP_NORETRY, and runs a single round of async
direct compaction there before falling back to other nodes. A failed
async run is never deferred.

When the local node has plenty of free memory but no free pageblock,
and what sits between the free pages can't be migrated, such as memory
long-term pinned for RDMA, each of these faults scans the zone again
and fails. Populating a large buffer pays for one failed compaction
per 2M fault. A KV-cache store that registers hundreds of GiB for RDMA
reports registration growing from tens of seconds to tens of minutes,
and works around it with MPOL_INTERLEAVE.

Defer the async state when an async run fails, and check it before
further async runs. Sync compaction keeps its own state and behaves as
before, and a successful compaction or allocation resets both. Keep
resetting the pageblock skip hints only when sync compaction restarts,
as async relies on them.

Populating a 4 GiB MADV_HUGEPAGE buffer from node 0 of a two-node VM,
with node 0 (24 GiB) fragmented by long-term pinning every other page,
median of 3 runs:

                          before     after
  direct compactions      735        15
  time in compaction      122.7 ms   3.6 ms
  population time         380 ms     273 ms
  THPs on node 0          1313       1126

The THPs that no longer land on node 0 come from node 1. With the same
fragmentation but movable memory, compaction still succeeds and the
median run still gets all 2048 THPs on node 0, as before.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 mm/compaction.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 7f8845d1990aa..25f758bc54f06 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2600,7 +2600,9 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 
 	/*
 	 * Clear pageblock skip if there were failures recently and compaction
-	 * is about to be retried after being deferred.
+	 * is about to be retried after being deferred. Only do it when sync
+	 * compaction restarts: async compaction relies on the skip hints, and
+	 * clearing them on every async retry would rescan the whole zone.
 	 */
 	if (compaction_restarting(cc->zone, cc->order))
 		__reset_isolation_suitable(cc->zone);
@@ -2858,8 +2860,10 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 			!__cpuset_zone_allowed(zone, gfp_mask))
 				continue;
 
-		if (prio > MIN_COMPACT_PRIORITY
-					&& compaction_deferred(zone, order, true)) {
+		if (prio > MIN_COMPACT_PRIORITY &&
+		    (compaction_deferred(zone, order, true) ||
+		     (prio == COMPACT_PRIO_ASYNC &&
+		      compaction_deferred(zone, order, false)))) {
 			rc = max_t(enum compact_result, COMPACT_DEFERRED, rc);
 			continue;
 		}
@@ -2890,14 +2894,17 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 			break;
 		}
 
-		if (prio != COMPACT_PRIO_ASYNC && (status == COMPACT_COMPLETE ||
-					status == COMPACT_PARTIAL_SKIPPED))
+		if (status == COMPACT_COMPLETE ||
+		    status == COMPACT_PARTIAL_SKIPPED)
 			/*
 			 * We think that allocation won't succeed in this zone
 			 * so we defer compaction there. If it ends up
-			 * succeeding after all, it will be reset.
+			 * succeeding after all, it will be reset. A failed
+			 * async run only defers further async runs, as sync
+			 * compaction may succeed on pageblocks it skipped.
 			 */
-			defer_compaction(zone, order, true);
+			defer_compaction(zone, order,
+					 prio != COMPACT_PRIO_ASYNC);
 
 		/*
 		 * We might have stopped compacting due to need_resched() in

-- 
2.43.0


