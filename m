Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65D4CC982FE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 20:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8538A6B0005; Fri, 16 Jan 2026 15:53:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D74F6B0088; Fri, 16 Jan 2026 15:53:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9FD6B0089; Fri, 16 Jan 2026 15:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0696B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:53:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08A2EC0632
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:53:10 +0000 (UTC)
X-FDA: 84339026940.13.E460D02
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8896EC000F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:53:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kcHkbaNO;
	spf=pass (imf22.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768596788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tfmijTxxqbRMuICsoRtTverNeZ8jwLHJm8kbNLNJYC4=;
	b=zzfWXNI76C+KBG+Y9Dv3GbUKeqSs2QFNizIHRKDGXfFa0r0YxnOBasVdYnsvyB8GdJ4EWd
	LuG8eP1h8HIJiKXFhCEdLRuvDRi+eS5KGQ3vRMjNs9soEe6NmP/aULlPhsUTfMOSscPRJ1
	QMQRXlek+N5v1RqO6IAH6CzOFHVdw5A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kcHkbaNO;
	spf=pass (imf22.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768596788; a=rsa-sha256;
	cv=none;
	b=Kmhg1wm2bZWrsM7gcnngHM0+zlecg8Qf0zP5H2BHQYj4+Nojc3oPC6Jtvi7CYc+rpO3dbS
	nprdsBEcVq5gtyBQhw7ycsJgmA5Dqaob7ZbZEuoz4hN3YaYYIBcnxHUN55DeROK7f8FYIl
	kzYpOmZ39kP0X1x2H+vu6dK7ugrI9Ss=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768596786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tfmijTxxqbRMuICsoRtTverNeZ8jwLHJm8kbNLNJYC4=;
	b=kcHkbaNOCn+GafJjIS7kkYKMxNb3mCgXzXJr/82xwYjAxL6ENTLg3HG5Jl53QiozqjlgTK
	J87kA9WkOkTx+qirmSaM/Bn4RTxWN+XmXZeJxqpOnVc6dAO9enpaEmrRvQ085bBEWR7q9p
	5S06TvUh7TM4SJhuaPDbnA7kmaXWf2o=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH] mm: Restore per-memcg proactive reclaim with !CONFIG_NUMA
Date: Fri, 16 Jan 2026 20:52:47 +0000
Message-ID: <20260116205247.928004-1-yosry.ahmed@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: qighg6a68wobpcrt9fbydgkb4oxqmcus
X-Rspamd-Queue-Id: 8896EC000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1768596788-878505
X-HE-Meta: U2FsdGVkX1978a+LAErv1Ff7wKX3149JBvN/Egi1sFwdBlcNqfwvlUkUoEtsp+dXgKP4ftgIdxxNxLaaaeQQkEecZ2np+4R8NlBLlQ+EHfOo6V3GpSgOLvbv9Fc49dpGsHeyjiQo/8YVO2+4xX+TW13NcVfzoA4MQEtCC+tpKXn0+48THAH/br5tALOmvUHYxzM67BUbc04jWMBzXyxXzLXyZb+4E5xH0qkgA1N0o6nFFr17VAikl2JVoj3r4BhwPmnS0YVGYjVQ6xAq9EPrtw4h9WZy3WZhiMKvuThDOLBtKXGjnVZ1F2DNExv/zGGFEW3YClX6sGpHrMMsyItPVSiXWicEtO/qJ31DBum0bVgTgsnG+jxdzbKmUuz19Ap/s9/ADCDByUPN5FSTfPhLQitztdyEJgYjUn6tpNseGICa+B89dR+ZjmGxtQnWSef94f/xU2lOgigWbS6UibMus4ScA7sCarE+YcRjTRmfeCIgmKG2h04UrEaEKuS+P4aajaZKwdeINgZjPU+UKblMNChuyFKXoL8jW79PfPzoWqkC+VniBye20Rypuvueu9d/+Rd3TOEWMumjoHrPTvA+6Wh60IqPyImVH/+7M9Iz7s1MdTVnCuikBYeyNl3jN73oUY1eK8RgN5oZKj+8a+gjbt+6racEMOk5+YuWmJy2c/JvzN4D3GNruHDtJ9HgXvJdwhTqVmpsAnmTTkaRKqLHhKGaxTUNyEMJgqJe3xpKXCDFG9G7mqWegn9xPetuH1ubN/LrdyVNFKWEU3o6urfm8IWMgkg5lX/z+o7xCSg9UYMTvZHKpnRO5ntoM/onojmRHtQwLwbMkfGTAFuhDOqUhy8IFOYN/ZgRrDNsXaCibM8IJTAbVlRqMW087qkps4j77tdnVpHbzszpZ39+ee1EPDJlsFDLXP1MGAbonRoRHZqnJG5rqHT0Lpw2FMCQeQ4oECSQU5mHdvjtvPjAD/w
 vN/riSCu
 CiOngkik5U1XXBbLQXlYcm0P8SA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2b7226af730c ("mm/memcg: make memory.reclaim interface generic")
moved proactive reclaim logic from memory.reclaim handler to a generic
user_proactive_reclaim() helper to be used for per-node proactive
reclaim.

However, user_proactive_reclaim() was only defined under CONFIG_NUMA,
with a stub always returning 0 otherwise. This broke memory.reclaim on
!CONFIG_NUMA configs, causing it to report success without actually
attempting reclaim.

Move the definition of user_proactive_reclaim() outside CONFIG_NUMA, and
instead define a stub for __node_reclaim() in the !CONFIG_NUMA case.
__node_reclaim() is only called from user_proactive_reclaim() when a
write is made to sys/devices/system/node/nodeX/reclaim, which is only
defined with CONFIG_NUMA.

Fixes: 2b7226af730c ("mm/memcg: make memory.reclaim interface generic")
Cc: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 mm/internal.h |  8 --------
 mm/vmscan.c   | 13 +++++++++++--
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 33eb0224f461..9508dbaf47cd 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -615,16 +615,8 @@ extern unsigned long highest_memmap_pfn;
 bool folio_isolate_lru(struct folio *folio);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
-#ifdef CONFIG_NUMA
 int user_proactive_reclaim(char *buf,
 			   struct mem_cgroup *memcg, pg_data_t *pgdat);
-#else
-static inline int user_proactive_reclaim(char *buf,
-			   struct mem_cgroup *memcg, pg_data_t *pgdat)
-{
-	return 0;
-}
-#endif
 
 /*
  * in mm/rmap.c:
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7b28018ac995..d9918f24dea0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7849,6 +7849,17 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 	return ret;
 }
 
+#else
+
+static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
+				    unsigned long nr_pages,
+				    struct scan_control *sc)
+{
+	return 0;
+}
+
+#endif
+
 enum {
 	MEMORY_RECLAIM_SWAPPINESS = 0,
 	MEMORY_RECLAIM_SWAPPINESS_MAX,
@@ -7956,8 +7967,6 @@ int user_proactive_reclaim(char *buf,
 	return 0;
 }
 
-#endif
-
 /**
  * check_move_unevictable_folios - Move evictable folios to appropriate zone
  * lru list
-- 
2.52.0.457.g6b5491de43-goog


