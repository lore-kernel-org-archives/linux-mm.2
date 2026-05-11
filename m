Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28CB4CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 10:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9312C6B00BF; Mon, 11 May 2026 06:52:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E16E6B00C1; Mon, 11 May 2026 06:52:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7C26B00C3; Mon, 11 May 2026 06:52:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BB7B6B00BF
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:52:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3036EC24AB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:52:20 +0000 (UTC)
X-FDA: 84754824840.27.0AFF94C
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5DAA21C000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:52:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UuVv3B6c;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778496738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9fjW4dLeqWiYQdk+4k4SbCTrPHj2YrRsMiHdQFzx+K0=;
	b=RZVXPVHTm3LIYjgcDs7/DLtQkQqo7JbMWbseshjwlNHz0CtxSkSl2RXWO3zW6f59WjdlDG
	WQI1xMOWTds5JExxGSsHIcAG5dTjG+1WvKPXjpwlGkqyCSFfBl4rILk11EHfVvl4G3rJ5V
	EWsOlRs10sDeO+72xsmhv1c3X5Ad4Bk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778496738; a=rsa-sha256;
	cv=none;
	b=yHLLS9G3cjGd183DAaKeZOusrACvc23lTC3G767Qb2Xa45Cz12cmzK+Qox0NM5mnuE95DE
	JkTyszePPkdI6JcqQikYTYb62jbt/e41b2N5zxVuw2J7tdb4sEAk2QqCdqfWWp69JWD9Ab
	ypNmkbKSS/ysxsTNsK9o8XYr+A9Y6GE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UuVv3B6c;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-366330b6751so2561495a91.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 03:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778496737; x=1779101537; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9fjW4dLeqWiYQdk+4k4SbCTrPHj2YrRsMiHdQFzx+K0=;
        b=UuVv3B6cV3vN6UBw14QpqXaKktE2HSydW33nCr6rmRF16yghfMfdiwbHFN7z/RE33W
         ohpSiN3LqsbjxqFWmD2SuTPlBW3zlc5dvt7hjBJeBX30aQk2oikT8fHRrtqOWC6V22yW
         BZC4hYk3WqwuMOJzLddPc10JyCoDH3B+DIAl8GkKXilUlGwxJCzPD5/hxzI7YMvxfyRm
         fo3aemYHkAz0kkh35McprmgLF0KMdvBJbfzcLi2yKjIvboL0CsRbLrN8fCRQt1uFitQn
         NYNXS6uJ1aX90z/eVHRvaO3g5uETMvDz/jayaGdj6D6XPIwfStFuJUhLvZZNmLSFqJ2L
         mueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778496737; x=1779101537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9fjW4dLeqWiYQdk+4k4SbCTrPHj2YrRsMiHdQFzx+K0=;
        b=T2Ftfcf6W7GVjIfmK8VnVji6rPCW9ZiALyZ15S65wYJxafckJcgsv82nleOsE7tDp8
         5i1pHDN3ZctPHKcnILyyXtGZjASmQ1eYnlEleZAUmG9iunHrrmT/XS60eGg6vk8+nmoV
         1dgD/zioApOIVA4irnfGh4HRTIjEmsrnJipeRxfXOgoJ2lksf1lT8TS38/Unz6ZsYtGn
         iVvruIeqbUQSvzvxuWV2IccvQvniVte3chMg7akxZKH7xtdQZT9ggWisQBvqf2tPUSww
         zH+eB9DhYvMbsAEKeOtJVMbgavvCVsgYUy8+1v6h+goCDMAjeatqJwlJHgWs/CVcTfDl
         ld/w==
X-Forwarded-Encrypted: i=1; AFNElJ+EZOv/bb+Y5PA4nJH0KMiq54aIrCFbLV/mMYiLQpciQhKTxC3u5AFqYuyXn/syupqx10RuqSawTw==@kvack.org
X-Gm-Message-State: AOJu0YzNmVYln9l+I4Wp93b7LXDEOmSNfZ1rv5qwT7ZNVKRu6RtSxZvV
	njHEmtODI1fbQtP7+i7ZxWNqKS3MQavBi5KLN51/gR3jDoadDfBQtatn
X-Gm-Gg: Acq92OGLvCrgeV6UMUg91eFUBTlc/oyDlqYS2XOpSyMKlbZgNpaCSMwr0pshCKsND1W
	BsDoOmTlCS4KIYqvsh7hubxH3JUIsat0lRvHJDcxhqUa4ATqmMpvTg2Zi354cOCDKpR8SgsGpax
	FxP4NepXWi1dAptS71FTWWd4qO72I8jRJqni3nuAnggoxNT013UfhGvbQivA5dW5ECWwE/gAwfV
	OaLPWqVpN5SddJjiGH/5O91I0t+EIqR3bdKSz9KNcUr3t6tUa5R1VBZFaPxZRSlbFRHGmYikIEQ
	AYcNkeRQpz+jzLncRTeuA/23wDwA50C9eLZmJpErUtmIgFTU/O88nDcCw4kTGfpbh1Q/B7CH5cv
	4DApxPV1A5FwUXR1923W7LrRJp4SQsuw7ufUlopcmg4aGkD/LMdPXtTw+fNE7yD7Nw9iCVW3DZJ
	Azf+ntZJMPHRzoqmR37WAvOWbDHCT5IFdjKqEcaTYfGvxSe5GSpD1R+vsnCvPf6A==
X-Received: by 2002:a17:90b:2e0e:b0:366:469d:98ec with SMTP id 98e67ed59e1d1-366469d99a0mr14958354a91.13.1778496737121;
        Mon, 11 May 2026 03:52:17 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d409eesm98571745ad.32.2026.05.11.03.52.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 May 2026 03:52:16 -0700 (PDT)
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
Subject: [PATCH 2/3] mm/zswap: Implement proactive writeback
Date: Mon, 11 May 2026 18:51:48 +0800
Message-Id: <20260511105149.75584-3-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260511105149.75584-1-jiahao.kernel@gmail.com>
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DAA21C000E
X-Rspamd-Server: rspam04
X-Stat-Signature: pmefmcezfbh9ypurugpmtfhtpnp8c1sf
X-HE-Tag: 1778496738-435054
X-HE-Meta: U2FsdGVkX1/QRufctuqvtD5mTgizoxentSiIYRI1fNj6/oD9V+ZkzAZ1PxVEJhnIJeGrrfuh/ePAFXAZiVFEdxiDkAJofGKeZ+lIy2naLCjQ5gsaAhHPXAkoeLwk+VESeCaeHQq3gSMt8G82XPkxQd13FVvee8RRt2ehBzUbL5FVyCdsksxc9XPlfzLU553zukMpc+283ycjAO1KPBO5k+71hFQIc5TkZf0upBCqcWGggSDw85e8Qr8Px8/fhRea3KzhEEmnzVZjv/s4smXNSa0orwB+zgKD1TjrqdyA1loF9RqUMu8+4qDEcZDvkA9LJqoaimKqJylCrJ2dwZFdXMTtoTtMFtFp4QWhl/+XSmb0ruHo4ALKnHxRphcEj0iFpxkZQdK2gT19zGarkfdy+j8I5iP9eZ0+FPHpDGIjVg+pGRi1o1OG3oHbja/eILqOOvHKrfhKdTdlk2izmE581pad6AuGLrsjiNvAfwYUPPynLalhMfBscIfUcckGBpQLvF2XHYKtdb/jebIxkBqElp3iZUgqJlo1GxGOMEc9hQVxhmkgpP6cWKnN+qZ8f6PdeKBeqRzIzErWa016zeXc4bYao+MLlFOg/nxb76ZGU2ZLQy19I347FqU5RstPaKBrZ1rKwr5qYIIOVmQLSDD++ROIKf/KUZ+xX5xDmv6IpHo0s2Z4vXCeS2Fh9adxZoiYv6IYguX84ngqanPtQso23mizeb2+ewnOgZMIiuXCUivY+yR/HrqoB8UugFXgE2EEi7a4QJs+YZ1aJ52r/zIg2WppJ2Vz8jR/pj76gCAozyIxSFas87mz4hfL0tWVF7zpWmS/ZOITdxlgFvlNne8ERAHrsHbdgG4QW292ADvlEni+W+MekMLpnVaD/xfiCU6fQs1dB9miq7QKJgSapmqojufu/GebVRtH1PpS5NsIWIVqOWovd/naAgbiSuZNJ0ku1NV6/zorOYGurx7/fJl
 07D0j1cF
 xhhLDOXX88ZilEgS6uwpA6s8Pqyy6o+U3ON2Zl9xE+G7OsWjIQrVwCP2/psBED7Rp2+2QmVyKJslmuOPP9+gRan0XpxbA4LcKkp7B6GVKzo1wZvz2CAj501cIvJY7OTk6l2gpU6S6K1Y/4JRmtY7bhLT/ZveZjOaBxVeqqR6HRhLx09kFrNAudz5oLovNIgqKvDBGCMSwCmRJEKUutzLd9rJ8OSJgkaUEY0eri2MhuMiiIEoEN3LEBjUgCqIDgjHsTDs6nhb6+WN8zGK0mFWRFwaFOKMPQLOEv7OXW78oFNGW/4HhHvRujIZjKwJB+H4ehhHMVodgz0U5SVKW+FhVWud9GYbkBOzkHmm3VIEzeBmDewmoYjtrPQQFoF4TgjdO6PKFdNlmzH0tB61bwf+Xl0Eah7DiR+Do7XxCARtaI5M5+xYlkrhD+T32AESygVjj4dc4qdfAcPiL/4uFP71itdMmTDGIqN8SNhXT8gr5bgn63sY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Zswap currently writes back pages to backing swap devices reactively,
triggered either by memory pressure via the shrinker or by the pool
reaching its size limit. This reactive approach offers no precise
control over when writeback happens, which can disturb latency-sensitive
workloads, and it cannot direct writeback at a specific memory cgroup.
However, there are scenarios where users might want to proactively
write back cold pages from zswap to the backing swap device, for
example, to free up memory for other applications or to prepare for
upcoming memory-intensive workloads.

Therefore, implement a proactive writeback mechanism for zswap by
adding a new cgroup interface file memory.zswap.proactive_writeback
within the memory controller.

Users can trigger writeback by writing to this file with the following
parameters:
- max=<bytes>: The maximum amount of memory to write back (optional,
  default: unlimited).
- <age>: The minimum age of the pages to write back. Only pages that
  have been in zswap for at least this duration will be written back.

Example usage:
  # Write back pages older than 1 hour (3600 seconds), max 10MB
  echo "max=10M 3600" > memory.zswap.proactive_writeback

The implementation consists of:
1. Add store_time to struct zswap_entry to record when each entry was
   inserted into zswap, used for proactive writeback age comparison.
2. Introduce struct zswap_shrink_walk_arg, passed as the cb_arg to
   list_lru_walk_one() in both the shrinker and proactive paths. It
   carries the per-invocation cutoff_time and proactive flag down to
   shrink_memcg_cb(), and propagates the encountered_page_in_swapcache
   out-signal from the callback back to the caller.
3. Modify the callback function shrink_memcg_cb() to proactively
   writeback zswap_entries that meet the time threshold.
4. Add zswap_proactive_writeback() as the proactive writeback driver:
   a per-node batched list_lru_walk_one() loop bounded by the
   writeback budget.

Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  24 ++++
 include/linux/zswap.h                   |   8 ++
 mm/memcontrol.c                         |  76 ++++++++++
 mm/zswap.c                              | 176 ++++++++++++++++++++++--
 4 files changed, 276 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6efd0095ed99..05b664b3b3e8 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1908,6 +1908,30 @@ The following nested keys are defined.
 	This setting has no effect if zswap is disabled, and swapping
 	is allowed unless memory.swap.max is set to 0.
 
+  memory.zswap.proactive_writeback
+	A write-only nested-keyed file which exists in non-root cgroups.
+
+	This interface allows proactive writeback of pages from the zswap
+	pool to the backing swap device. This is useful to offload cold
+	pages from the zswap pool to the slower swap device. It is only
+	available if zswap writeback is enabled.
+
+	Users can trigger writeback by writing to this file with the following
+	parameters:
+
+	- "max=<bytes>" : Optional. The maximum amount of data to write back.
+	  (default: unlimited). Please note that the kernel can over or under
+	  writeback this value.
+
+	- "<age>" : Required. The minimum age of the pages to write back
+	  (in seconds). Only pages that have been in the zswap pool for at
+	  least this amount of time will be written back.
+
+	Example::
+
+	  # Write back pages older than 1 hour (3600 seconds), max 10MB
+	  echo "max=10M 3600" > memory.zswap.proactive_writeback
+
   memory.pressure
 	A read-only nested-keyed file.
 
diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index efa6b551217e..7a51b4f95017 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -44,6 +44,8 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+int zswap_proactive_writeback(struct mem_cgroup *root, unsigned long nr_max_writeback,
+			      ktime_t cutoff);
 #else
 
 struct zswap_lruvec_state {};
@@ -78,6 +80,12 @@ static inline bool zswap_never_enabled(void)
 	return true;
 }
 
+static inline int zswap_proactive_writeback(struct mem_cgroup *root,
+					    unsigned long nr_max_writeback, ktime_t cutoff)
+{
+	return 0;
+}
+
 #endif
 
 #endif /* _LINUX_ZSWAP_H */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 409c41359dc8..ba7f7b1954a8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -70,6 +70,7 @@
 #include "memcontrol-v1.h"
 
 #include <linux/uaccess.h>
+#include <linux/parser.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/memcg.h>
@@ -5891,6 +5892,76 @@ static ssize_t zswap_writeback_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+enum {
+	ZSWAP_WRITEBACK_MAX,
+	ZSWAP_WRITEBACK_AGE,
+	ZSWAP_WRITEBACK_ERR,
+};
+
+static const match_table_t zswap_writeback_tokens = {
+	{ ZSWAP_WRITEBACK_MAX, "max=%s" },
+	{ ZSWAP_WRITEBACK_AGE, "%u" },
+	{ ZSWAP_WRITEBACK_ERR, NULL },
+};
+
+static ssize_t zswap_proactive_writeback_write(struct kernfs_open_file *of,
+					       char *buf, size_t nbytes,
+					       loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	unsigned long nr_max_writeback = ULONG_MAX;
+	substring_t args[MAX_OPT_ARGS];
+	unsigned int age_sec;
+	bool age_set = false;
+	ktime_t cutoff_time;
+	char *token, *end;
+	int err;
+
+	if (!mem_cgroup_zswap_writeback_enabled(memcg))
+		return -EINVAL;
+
+	buf = strstrip(buf);
+
+	while ((token = strsep(&buf, " ")) != NULL) {
+		if (!strlen(token))
+			continue;
+
+		switch (match_token(token, zswap_writeback_tokens, args)) {
+		case ZSWAP_WRITEBACK_MAX:
+			nr_max_writeback = memparse(args[0].from, &end);
+			if (*end != '\0')
+				return -EINVAL;
+			nr_max_writeback >>= PAGE_SHIFT;
+			break;
+		case ZSWAP_WRITEBACK_AGE:
+			if (age_set)
+				return -EINVAL;
+
+			if (match_uint(&args[0], &age_sec))
+				return -EINVAL;
+			age_set = true;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	if (!age_set || !age_sec || !nr_max_writeback)
+		return -EINVAL;
+
+	cutoff_time = ktime_sub(ktime_get_boottime(),
+				ns_to_ktime((u64)age_sec * NSEC_PER_SEC));
+	/* age_sec >= uptime: no entry can be that old, skip the walk. */
+	if (ktime_to_ns(cutoff_time) <= 0)
+		return nbytes;
+
+	err = zswap_proactive_writeback(memcg, nr_max_writeback, cutoff_time);
+	if (err)
+		return err;
+
+	return nbytes;
+}
+
 static struct cftype zswap_files[] = {
 	{
 		.name = "zswap.current",
@@ -5908,6 +5979,11 @@ static struct cftype zswap_files[] = {
 		.seq_show = zswap_writeback_show,
 		.write = zswap_writeback_write,
 	},
+	{
+		.name = "zswap.proactive_writeback",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.write = zswap_proactive_writeback_write,
+	},
 	{ }	/* terminate */
 };
 #endif /* CONFIG_ZSWAP */
diff --git a/mm/zswap.c b/mm/zswap.c
index 19538d6f169a..1173ac6836fa 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -36,6 +36,7 @@
 #include <linux/workqueue.h>
 #include <linux/list_lru.h>
 #include <linux/zsmalloc.h>
+#include <linux/timekeeping.h>
 
 #include "swap.h"
 #include "internal.h"
@@ -160,6 +161,12 @@ struct zswap_pool {
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
 
+struct zswap_shrink_walk_arg {
+	ktime_t cutoff_time;
+	bool proactive;
+	bool encountered_page_in_swapcache;
+};
+
 /* Global LRU lists shared by all zswap pools. */
 static struct list_lru zswap_list_lru;
 
@@ -183,6 +190,7 @@ static struct shrinker *zswap_shrinker;
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
  * lru - handle to the pool's lru used to evict pages.
+ * store_time - Time when the entry was stored, for proactive writeback.
  */
 struct zswap_entry {
 	swp_entry_t swpentry;
@@ -192,6 +200,7 @@ struct zswap_entry {
 	unsigned long handle;
 	struct obj_cgroup *objcg;
 	struct list_head lru;
+	ktime_t store_time;
 };
 
 static struct xarray *zswap_trees[MAX_SWAPFILES];
@@ -1148,10 +1157,19 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 				       void *arg)
 {
 	struct zswap_entry *entry = container_of(item, struct zswap_entry, lru);
-	bool *encountered_page_in_swapcache = (bool *)arg;
-	swp_entry_t swpentry;
+	struct zswap_shrink_walk_arg *walk_arg = arg;
+	bool proactive_wb = walk_arg && walk_arg->proactive;
 	enum lru_status ret = LRU_REMOVED_RETRY;
 	int writeback_result;
+	swp_entry_t swpentry;
+
+	/*
+	 * For proactive writeback, rotate young entries to the LRU tail
+	 * so that subsequent list_lru_walk_one() batches start past
+	 * them.
+	 */
+	if (proactive_wb && ktime_after(entry->store_time, walk_arg->cutoff_time))
+		return LRU_ROTATE;
 
 	/*
 	 * Second chance algorithm: if the entry has its referenced bit set, give it
@@ -1160,7 +1178,9 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	 */
 	if (entry->referenced) {
 		entry->referenced = false;
-		return LRU_ROTATE;
+		/* Proactive writeback is an explicit hint; don't rotate. */
+		if (!proactive_wb)
+			return LRU_ROTATE;
 	}
 
 	/*
@@ -1214,9 +1234,9 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
 		 * shrinker context).
 		 */
-		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
+		if (writeback_result == -EEXIST && walk_arg) {
 			ret = LRU_STOP;
-			*encountered_page_in_swapcache = true;
+			walk_arg->encountered_page_in_swapcache = true;
 		}
 	} else {
 		zswap_written_back_pages++;
@@ -1228,8 +1248,12 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 		struct shrink_control *sc)
 {
+	struct zswap_shrink_walk_arg walk_arg = {
+		.cutoff_time = KTIME_MAX,
+		.proactive = false,
+		.encountered_page_in_swapcache = false,
+	};
 	unsigned long shrink_ret;
-	bool encountered_page_in_swapcache = false;
 
 	if (!zswap_shrinker_enabled ||
 			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
@@ -1238,9 +1262,9 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 	}
 
 	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
-		&encountered_page_in_swapcache);
+					  &walk_arg);
 
-	if (encountered_page_in_swapcache)
+	if (walk_arg.encountered_page_in_swapcache)
 		return SHRINK_STOP;
 
 	return shrink_ret ? shrink_ret : SHRINK_STOP;
@@ -1508,6 +1532,7 @@ static bool zswap_store_page(struct page *page,
 	entry->swpentry = page_swpentry;
 	entry->objcg = objcg;
 	entry->referenced = true;
+	entry->store_time = ktime_get_boottime();
 	if (entry->length) {
 		INIT_LIST_HEAD(&entry->lru);
 		zswap_lru_add(&zswap_list_lru, entry);
@@ -1681,6 +1706,141 @@ int zswap_load(struct folio *folio)
 	return 0;
 }
 
+/* Cap LRU scan to this many entries per page of remaining budget. */
+#define ZSWAP_PROACTIVE_WB_SCAN_RATIO	16UL
+/*
+ * Batch size for proactive writeback, used both as the per-memcg
+ * writeback target in the outer memcg loop and as the per-walk budget
+ * for list_lru_walk_one().
+ */
+#define ZSWAP_PROACTIVE_WB_BATCH	128UL
+
+/*
+ * Walk @memcg's per-node LRUs, writing back entries older than @cutoff
+ * up to @nr_to_write pages. Returns the number of pages written back,
+ * or -ENOENT if @memcg is a zombie or has writeback disabled.
+ */
+static long zswap_proactive_shrink_memcg(struct mem_cgroup *memcg,
+					 ktime_t cutoff,
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
+		struct zswap_shrink_walk_arg walk_arg = {
+			.cutoff_time = cutoff,
+			.proactive = true,
+			.encountered_page_in_swapcache = false,
+		};
+		unsigned long nr_to_scan, nr_scanned = 0;
+
+		/*
+		 * Cap by LRU length: bounds rewalks when entries keep
+		 * rotating (young or referenced).
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
+			 * Account the committed budget rather than the walker's
+			 * actual delta: if the list empties under us the walker
+			 * visits nothing and nr_scanned would never advance.
+			 */
+			nr_scanned += nr_to_walk;
+
+			nr_written += list_lru_walk_one(&zswap_list_lru, nid, memcg,
+							&shrink_memcg_cb, &walk_arg,
+							&nr_to_walk);
+
+			if (nr_written >= nr_to_write)
+				return nr_written;
+			if (walk_arg.encountered_page_in_swapcache)
+				break;
+
+			cond_resched();
+		}
+	}
+
+	return nr_written;
+}
+
+int zswap_proactive_writeback(struct mem_cgroup *root,
+			      unsigned long nr_max_writeback,
+			      ktime_t cutoff)
+{
+	struct mem_cgroup *memcg;
+	unsigned long nr_written = 0;
+	int failures = 0, attempts = 0;
+
+	/*
+	 * Writeback will be aborted with -EAGAIN if @nr_written is still
+	 * zero and we encounter the following MAX_RECLAIM_RETRIES times:
+	 * - No writeback-candidate memcgs found in a subtree walk.
+	 * - A writeback-candidate memcg wrote back zero pages.
+	 */
+	while (nr_written < nr_max_writeback) {
+		unsigned long nr_to_write;
+		long shrunk;
+
+		if (signal_pending(current))
+			return -EINTR;
+
+		memcg = zswap_mem_cgroup_iter(root);
+
+		if (!memcg) {
+			/*
+			 * Continue without incrementing failures if we found
+			 * candidate memcgs in the last subtree walk.
+			 */
+			if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
+				goto out;
+			attempts = 0;
+			continue;
+		}
+
+		nr_to_write = min(nr_max_writeback - nr_written,
+				  ZSWAP_PROACTIVE_WB_BATCH);
+		shrunk = zswap_proactive_shrink_memcg(memcg, cutoff, nr_to_write);
+		mem_cgroup_put(memcg);
+
+		/* Writeback-disabled or offline: skip without counting. */
+		if (shrunk == -ENOENT)
+			continue;
+
+		++attempts;
+		if (shrunk > 0)
+			nr_written += shrunk;
+		else if (++failures == MAX_RECLAIM_RETRIES)
+			goto out;
+
+		cond_resched();
+	}
+out:
+	return nr_written ? 0 : -EAGAIN;
+}
+
 void zswap_invalidate(swp_entry_t swp)
 {
 	pgoff_t offset = swp_offset(swp);
-- 
2.34.1


