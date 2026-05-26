Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F80ECD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 064016B00C8; Tue, 26 May 2026 07:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B5B6B00C9; Tue, 26 May 2026 07:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E943A6B00CA; Tue, 26 May 2026 07:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7E5A6B00C8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:46:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E504A03D3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:46:39 +0000 (UTC)
X-FDA: 84809393718.16.7B0D084
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id A281D4000B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:46:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JmdXOamN;
	spf=pass (imf04.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779795997; a=rsa-sha256;
	cv=none;
	b=cgGEgu8TDc/47OG6uVCIjr6tXhbP9VQqsdREF1E5klanoHMaSAWRy0DlnB2c3RmCozEtPf
	8r5kQpmHd5ZxUxgyq/bZK+fwIuOJRduOODvPbXTImzWGarOq+kMRTh9vCNhSOniZ0YDi4V
	ugzslzsUZG+W/kCI7jkxj1l7+p51QBQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JmdXOamN;
	spf=pass (imf04.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779795997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUCd8YO/TGnxTv33ZbkeaZ1htMubaCTkJySuysD11rI=;
	b=ZbeM449/JQcAtvfcJjsuAfJH3/gkOx574LuF/va5nSKyo0iliiu//p8hOzHvTjgW1n7qEd
	L0qiIeOgU2QEZ95kNUDbS4BJyMCnVSie1Df6ZfBUU+5ivcoL26kQM69FNRzScxGYT43xU0
	YVCoA0e3tx5M03960cjwNN1Kbz6lyF8=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c736261ee8dso4690126a12.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 04:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779795996; x=1780400796; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wUCd8YO/TGnxTv33ZbkeaZ1htMubaCTkJySuysD11rI=;
        b=JmdXOamN62rzcpzdrb/jh7vuXZPJT5kxCvZSXiAiQtkU35McZGx5zCjwHq7Dk5Tey/
         6Eheq6EwoKk4eB1ftUig1JECRA3aGWUlHcwYnlXcrZNcGkPOHtLUTcHnT9H16P/AOSen
         Y+OEpFhAy2cD7HiL3gBwWL75NvIZZrziMCJ5awvNpaJ5hkphbwWLaRhwU5IeJwhySDXn
         ynltyA7GmoFDczYBofsG8iCdGYu1XuFwMmb3a/7Z3JBzv2U+qWlRhxFQ7V6o8q5hV7yS
         PZr9BIOwaN6uw+c2PwDTAh3SjR/Kqj7dIALq7cAU3tr6WGcCS5rpFiE6O/1o7hu8IaW0
         8kUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779795996; x=1780400796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wUCd8YO/TGnxTv33ZbkeaZ1htMubaCTkJySuysD11rI=;
        b=IbEUucWK+qOcAoPkGrE0ISJ9tWFb+vo+C38TSlb9FKzmhopQ2b84NrCeXhncYXRoja
         kV+inLGkw681p2sZqzsSyhgdNynqI5FFhC0BIP5t0RdlYAI+R5e6tHLZan8iTq0mPI6I
         Qrn814p2+hu4XS85j3aDDmB8s+6UmTX4f2Byzso4dB9C+V/Nh3Pok5aQGIp4OHwFlh4x
         QPv4fCRVy0VmvIwfe16P7EDNhWJ1YjyUgSjJcQQGC27aIPloXtzZ7O184t+c8m1F6BWT
         cOzp/EU0wPz7ZS+cxL0R9uBOHi5b7vrh+0+cHCP9hV7sNne7Pkw4GXMAwCUuxxXVBkqi
         cQrw==
X-Forwarded-Encrypted: i=1; AFNElJ9UxOM6Nhz65rLd7deea43th+MFG5ETELKIUlu/wAS0IVySy1zMro0ccuZ0it7xQCSiGw+cRQEdBw==@kvack.org
X-Gm-Message-State: AOJu0YwmDqKPtSONq4qrSwwguwy7i2/Qsmp/PlKygfnb6NQghfGW7ykE
	GtCMegLrRzSJ5piPJYpWo+kFkkdHlaxIftuzhMZ4m5DLMjceXgKbqi9y
X-Gm-Gg: Acq92OGJQSTh76iNaDLPiV+9xkBx7JZgiE+oPQPARmZfr3Y+xZt5O3gWVZ0vHwealzr
	uhheTorxTf2UO9tYWPRTE++FO5pRegvJUWO3m4fX7C5eT+PtdQ7IVwFlRIpefIKTjl+8VV4DZ0p
	sNzdkTke9zhEZx18baPzhN1FpSZpQ0NSQEQUHls/wLAngC0skRhnOJQ0bYiEA2Mmz8QeeRx6SZL
	p1jKQBeHdNo1J6/gIDnNjSbinPQRIs+viwleUCVp+nxPVBkr9qiTzZKBb6Uz2TE6AiGSoj0HYc5
	GSH5v7FX7OEXUjFkmjMrTkTs9VOrNy+ChzPmUJGx/owMdf/RISTXM/iO+wuE901gXsQj0XhugmY
	HV0R+S8lUvgaz4dZJF2COmXdyeGHSOqZOKsKw02yTCxrswRV4LswDvGqHivCHreXdf9uLk50kx+
	YqObi8sTI+AOc8xmqOHQ+cvCq4Qzw2TuRWSqm09Zxi2eMLxp3Y2Is=
X-Received: by 2002:a05:6300:6d8d:20b0:3b3:9199:b1d4 with SMTP id adf61e73a8af0-3b39199c626mr3929480637.48.1779795996335;
        Tue, 26 May 2026 04:46:36 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c852028fe99sm10304341a12.4.2026.05.26.04.46.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 May 2026 04:46:35 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Date: Tue, 26 May 2026 19:45:59 +0800
Message-Id: <20260526114601.67041-3-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260526114601.67041-1-jiahao.kernel@gmail.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A281D4000B
X-Stat-Signature: ojbk8ertgnf8of9es749c61ttgtq63u9
X-HE-Tag: 1779795997-491080
X-HE-Meta: U2FsdGVkX19tz6bH9cbe6Y2CXUj7AIbuH1g0v3OohYHzQNyNfTnpUJ+PUxQYi8SxgbqErKVMjIykztD7LAYymjbqMoe0ZeJrfVsv9RgsYCm5htXsCuI4OnrhAslIZbjm97fLdFu+cIRrYYGoGu7P7BQW3nKCC9XBdhBfoS2GI/DDrYll9/vKvTvL7i63tsXMzeWC8drUfIEnHrZDDXXgtDb+Z8yj7+PSQ0fMZqRy8R9p+RM9kwgTdeOjZ9QGBe1k6MQ6zfDe383a94ueLFjF9R1aS6g39u5WqVUOP8JDWVjBY7q/ciFFvcAfp0O52b+KImMTk2l+Sr1wU+lolr0bxKZdn50wu9qaEkxmAAf3s0iIh8MnEpnlHY/wQX3qNJAGKjKmq1ae9lw8Q61dBBlvhRJtqPnVMHoZ5d7konpg/u9Y6AkO1f6HBbW1oKjTl65bxodU5KOmH6FMUhYpUXpi8vHyvjxkFAL8QKK00ESDuLOYmnSnKmV20EB1kvpmVvYGpT/sKj+n45GYIzREU/md6wyqjx1of3eQgxu/tUlH9rbcG3odJNXMb44jo3utz/uy5nWavIzsNDx0ynHStPaO9cz4hAe5JtU5x+XRZ2pXzdN7Zy4jxPtZ5YIxysZj0YUDYQQs6lB7RYeX5QihI138s8MY3bcAX/BwtwxDXDZxdKf6Hy94aSxDq33CW+Xi56SR2oZyhqGdC1YE+grz2TM9yvdoc2+BD4BxGZN6kWrH003N1sv404sLYhWO8brAjuB26LjRcMLx9qx8qklqAEjbJEhrCTsfHNLgZTavf3bLRuHkrnOE9ZP79BrObRvQQYEXFVIBo9r3Tgimbhqc2R5Vic6QHDqP1+MiEbC/64tZyk/gK7JWlDbf99FpLuZCTYXbrFeEJlH+VbcahIchWOg9bPX2tlrMB4NdbGo/RLy/Z8+5CD4OgEov++0OOCeEwt5kJHm3ir5kLsvBtcmj6z5
 5Z16F7zR
 o5RN2/DCg7StqwdJ30n12gCVyjsDBJmYgc20ms0aXYdZ6thfxEYl2LEtoPR9jIYIv3c/QBxAoNGH/a3ekuKKdP0lrIg7RuiS1FP6AhQxR+qAHShGiAn1fJkXyTbaAzKDuCPrNb2x/4TvGnNZcNIbj/JocwqGEQUMt1gofxPaVGZJQfEWXtB2SFbCRhrKQMl7gWYnmkRJCAPZlZ7xl81+acE47zs6xadC46qs1HPHZfyl0PDAUVssEou5BRp9h4P+A7Gk+m+IlYPIVzqjMyQnO1G0Ci3JOqFTzMA4SJe168twp+Eyt8mMkUsvaeYSkc+QoIZSwho4aNqjUjRey5n1o1FxSfzUqig4N1MMMqdw/tNxnBtYQMStzWNQsQJmFe8LLBJw9PNnNoRjXgDYdvUJRJcLtUYFIzXHL55KamDImITkn9+ysemPwZBPPXKrqvxuKVpPf3WxSf2opZ7nPv9jWwHiaJAnsHYnvzmRS/Wmcm8zbV2HYh7sPaemHj7zupLHavUe8zV+Yc2T0WhUNmLzFSWUgv0D1/mJbpLKkNSZZSDBzvqF4VzqJTmRvGCZIy5N7olrwJJQ4jO9PookMMJ+LTfQy6zKFT2CEZoqZSOGS78RlfPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Zswap currently writes back pages to backing swap reactively, triggered
either by the shrinker or when the pool reaches its size limit. There is
no mechanism to control the amount of writeback for a specific memory
cgroup. However, users may want to proactively write back zswap pages,
e.g., to free up memory for other applications or to prepare for
memory-intensive workloads.

Introduce a "zswap_writeback_only" key to the memory.reclaim cgroup
interface. When specified, this key bypasses standard memory reclaim
and exclusively performs proactive zswap writeback up to the requested
budget. If omitted, the default reclaim behavior remains unchanged.

Example usage:
  # Write back 100MB of pages from zswap to the backing swap
  echo "100M zswap_writeback_only" > memory.reclaim

Note that the actual amount written back may be less than requested due
to the zswap second-chance algorithm: referenced entries are rotated on
the LRU on the first encounter and only written back on a second pass.
If fewer bytes are written back than requested, -EAGAIN is returned,
matching the existing memory.reclaim semantics.

Internally, extend user_proactive_reclaim() to parse the new
"zswap_writeback_only" token and invoke the dedicated handler. Add
zswap_proactive_writeback() to walk the target memcg subtree via the
per-memcg writeback cursor, draining per-node zswap LRUs through
list_lru_walk_one() with the shrink_memcg_cb() callback.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  18 +++-
 Documentation/admin-guide/mm/zswap.rst  |  11 +-
 include/linux/zswap.h                   |   7 ++
 mm/vmscan.c                             |  14 +++
 mm/zswap.c                              | 138 ++++++++++++++++++++++++
 5 files changed, 185 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6efd0095ed99..6564abf0dec5 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1425,9 +1425,10 @@ PAGE_SIZE multiple when read back.
 
 The following nested keys are defined.
 
-	  ==========            ================================
+	  ====================  ==================================================
 	  swappiness            Swappiness value to reclaim with
-	  ==========            ================================
+	  zswap_writeback_only  Only perform proactive zswap writeback
+	  ====================  ==================================================
 
 	Specifying a swappiness value instructs the kernel to perform
 	the reclaim with that swappiness value. Note that this has the
@@ -1437,6 +1438,19 @@ The following nested keys are defined.
 	The valid range for swappiness is [0-200, max], setting
 	swappiness=max exclusively reclaims anonymous memory.
 
+	The zswap_writeback_only key skips ordinary memory reclaim and
+	writes back pages from zswap to the backing swap device until
+	the requested amount has been written or no further candidates
+	are found. This is useful to proactively offload cold pages from
+	the zswap pool to the swap device. It is only available if
+	zswap writeback is enabled. zswap_writeback_only cannot be combined
+	with swappiness; specifying both returns -EINVAL.
+
+	Example::
+
+	  # Write back up to 100MB of pages from zswap to the backing swap
+	  echo "100M zswap_writeback_only" > memory.reclaim
+
   memory.peak
 	A read-write single value file which exists on non-root cgroups.
 
diff --git a/Documentation/admin-guide/mm/zswap.rst b/Documentation/admin-guide/mm/zswap.rst
index 2464425c783d..1c0598e77958 100644
--- a/Documentation/admin-guide/mm/zswap.rst
+++ b/Documentation/admin-guide/mm/zswap.rst
@@ -131,7 +131,16 @@ User can enable it as follows::
   echo Y > /sys/module/zswap/parameters/shrinker_enabled
 
 This can be enabled at the boot time if ``CONFIG_ZSWAP_SHRINKER_DEFAULT_ON`` is
-selected.
+selected. Once enabled, the shrinker automatically writes back zswap pages to
+backing swap during memory reclaim.
+
+If users want to explicitly trigger proactive zswap writeback for a specific
+memory cgroup without invoking standard page reclaim, it can be done as follows::
+
+	echo "100M zswap_writeback_only" > /sys/fs/cgroup/<cgroup-name>/memory.reclaim
+
+Both of the methods mentioned above are subject to the ``memory.zswap.writeback``
+control. This means that ``memory.zswap.writeback`` can reject all zswap writeback.
 
 A debugfs interface is provided for various statistic about pool size, number
 of pages stored, same-value filled pages and various counters for the reasons
diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index efa6b551217e..98434d39339a 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -44,6 +44,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+int zswap_proactive_writeback(struct mem_cgroup *memcg, unsigned long nr_to_writeback);
 #else
 
 struct zswap_lruvec_state {};
@@ -78,6 +79,12 @@ static inline bool zswap_never_enabled(void)
 	return true;
 }
 
+static inline int zswap_proactive_writeback(struct mem_cgroup *memcg,
+					    unsigned long nr_to_writeback)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif
 
 #endif /* _LINUX_ZSWAP_H */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ca4533eba701..63fa4341b823 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -64,6 +64,7 @@
 
 #include <linux/swapops.h>
 #include <linux/sched/sysctl.h>
+#include <linux/zswap.h>
 
 #include "internal.h"
 #include "swap.h"
@@ -7856,11 +7857,13 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
 enum {
 	MEMORY_RECLAIM_SWAPPINESS = 0,
 	MEMORY_RECLAIM_SWAPPINESS_MAX,
+	MEMORY_RECLAIM_ZSWAP_WRITEBACK_ONLY,
 	MEMORY_RECLAIM_NULL,
 };
 static const match_table_t tokens = {
 	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
 	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=max"},
+	{ MEMORY_RECLAIM_ZSWAP_WRITEBACK_ONLY, "zswap_writeback_only"},
 	{ MEMORY_RECLAIM_NULL, NULL },
 };
 
@@ -7870,6 +7873,7 @@ int user_proactive_reclaim(char *buf,
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
 	int swappiness = -1;
+	bool zswap_writeback_only = false;
 	char *old_buf, *start;
 	substring_t args[MAX_OPT_ARGS];
 	gfp_t gfp_mask = GFP_KERNEL;
@@ -7900,11 +7904,21 @@ int user_proactive_reclaim(char *buf,
 		case MEMORY_RECLAIM_SWAPPINESS_MAX:
 			swappiness = SWAPPINESS_ANON_ONLY;
 			break;
+		case MEMORY_RECLAIM_ZSWAP_WRITEBACK_ONLY:
+			zswap_writeback_only = true;
+			break;
 		default:
 			return -EINVAL;
 		}
 	}
 
+	if (zswap_writeback_only) {
+		/* zswap_writeback_only and swappiness are mutually exclusive. */
+		if (swappiness != -1)
+			return -EINVAL;
+		return zswap_proactive_writeback(memcg, nr_to_reclaim);
+	}
+
 	while (nr_reclaimed < nr_to_reclaim) {
 		/* Will converge on zero, but reclaim enforces a minimum */
 		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
diff --git a/mm/zswap.c b/mm/zswap.c
index 73e64a635690..7bcbf788f634 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1679,6 +1679,144 @@ int zswap_load(struct folio *folio)
 	return 0;
 }
 
+/*
+ * Maximum LRU scan limit:
+ * number of entries to scan per page of remaining budget.
+ */
+#define ZSWAP_PROACTIVE_WB_SCAN_RATIO	16UL
+/*
+ * Batch size for proactive writeback:
+ * - As the per-memcg writeback target in the outer memcg loop.
+ * - As the per-walk budget passed to list_lru_walk_one().
+ */
+#define ZSWAP_PROACTIVE_WB_BATCH	128UL
+
+/*
+ * Walk the per-node LRUs of @memcg to write back up to @nr_to_write pages.
+ * Returns the number of pages written back, or -ENOENT if @memcg is a
+ * zombie or has writeback disabled.
+ */
+static long zswap_proactive_shrink_memcg(struct mem_cgroup *memcg,
+					 unsigned long nr_to_write)
+{
+	unsigned long nr_written = 0;
+	int nid;
+
+	if (!mem_cgroup_zswap_writeback_enabled(memcg))
+		return -ENOENT;
+
+	if (!mem_cgroup_online(memcg))
+		return -ENOENT;
+
+	for_each_node_state(nid, N_NORMAL_MEMORY) {
+		bool encountered_page_in_swapcache = false;
+		unsigned long nr_to_scan, nr_scanned = 0;
+
+		/*
+		 * Cap by LRU length: bounds rewalks when referenced
+		 * entries keep rotating to the tail.
+		 */
+		nr_to_scan = list_lru_count_one(&zswap_list_lru, nid, memcg);
+		if (!nr_to_scan)
+			continue;
+
+		/*
+		 * Cap by SCAN_RATIO * remaining budget: bounds scan cost
+		 * to the remaining writeback budget.
+		 */
+		nr_to_scan = min(nr_to_scan,
+				 (nr_to_write - nr_written) * ZSWAP_PROACTIVE_WB_SCAN_RATIO);
+
+		while (nr_scanned < nr_to_scan) {
+			unsigned long nr_to_walk = min(ZSWAP_PROACTIVE_WB_BATCH,
+						       nr_to_scan - nr_scanned);
+
+			if (signal_pending(current))
+				return nr_written;
+
+			/*
+			 * Account for the committed budget rather than the walker's
+			 * actual delta. If the list is emptied concurrently, the
+			 * walker visits nothing and nr_scanned would never advance.
+			 */
+			nr_scanned += nr_to_walk;
+
+			nr_written += list_lru_walk_one(&zswap_list_lru, nid, memcg,
+							&shrink_memcg_cb,
+							&encountered_page_in_swapcache,
+							&nr_to_walk);
+
+			if (nr_written >= nr_to_write)
+				return nr_written;
+			if (encountered_page_in_swapcache)
+				break;
+
+			cond_resched();
+		}
+	}
+
+	return nr_written;
+}
+
+int zswap_proactive_writeback(struct mem_cgroup *memcg,
+			      unsigned long nr_to_writeback)
+{
+	struct mem_cgroup *iter_memcg;
+	unsigned long nr_written = 0;
+	int failures = 0, attempts = 0;
+
+	if (!memcg)
+		return -EINVAL;
+	if (!nr_to_writeback)
+		return 0;
+
+	/*
+	 * Writeback will be aborted with -EAGAIN if we encounter
+	 * the following MAX_RECLAIM_RETRIES times:
+	 * - No writeback-candidate memcgs found in a subtree walk.
+	 * - A writeback-candidate memcg wrote back zero pages.
+	 */
+	while (nr_written < nr_to_writeback) {
+		unsigned long batch_size;
+		long shrunk;
+
+		if (signal_pending(current))
+			return -EINTR;
+
+		iter_memcg = zswap_mem_cgroup_iter(memcg);
+
+		if (!iter_memcg) {
+			/*
+			 * Continue without incrementing failures if we found
+			 * candidate memcgs in the last subtree walk.
+			 */
+			if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
+				return -EAGAIN;
+			attempts = 0;
+			continue;
+		}
+
+		batch_size = min(nr_to_writeback - nr_written,
+				 ZSWAP_PROACTIVE_WB_BATCH);
+		shrunk = zswap_proactive_shrink_memcg(iter_memcg, batch_size);
+		mem_cgroup_put(iter_memcg);
+
+		/* Writeback-disabled or offline: skip without counting. */
+		if (shrunk == -ENOENT)
+			continue;
+
+		++attempts;
+		if (shrunk > 0)
+			nr_written += shrunk;
+		else if (++failures == MAX_RECLAIM_RETRIES)
+			return -EAGAIN;
+
+		cond_resched();
+	}
+
+	return 0;
+}
+
 void zswap_invalidate(swp_entry_t swp)
 {
 	pgoff_t offset = swp_offset(swp);
-- 
2.34.1


