Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A97DCD98DE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 04:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B38B6B0093; Thu, 18 Jun 2026 00:49:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163F96B0095; Thu, 18 Jun 2026 00:49:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052DF6B0096; Thu, 18 Jun 2026 00:49:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C28E26B0093
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:49:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B39112060E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:49:50 +0000 (UTC)
X-FDA: 84891805740.08.E921D07
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7198A100004
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:49:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MDqKxLqZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781758188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1papM2W9KLSMiQ51HSi85TiIoRBa0nUKenc379MiLQ=;
	b=ecM32KtanOc9Ll+9DkOy8LoNGr0kmLC2/NAOEgCEpenezT/E73qrXE3po+FniHv6sR6xKt
	c79+poCxf9BpiF210OElK5+eja/SxJnXKobEbxMQkuwxiMN7nPPIotaEdB/XpYZaoXjriV
	KnyJteG5LJi0/IGgvhBapUnsnjmSJVQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MDqKxLqZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781758188;
	b=iRU0eMZFFh1NkpwFExPD/474uxG0hDxrhclgR22aPSHv4FgiqYMMT0dC6Rk9JODXF6Z0hT
	AiZ41SV3mQ/F2CAoGLHABr0dKvAV3rRaBV+QhuReitresaidSqLaA4MDnPUos4PxaQHYTc
	eQ6ELHb3ywLZwR7Gxcm+Xx70EBNm+tE=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8452a597afcso231019b3a.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781758187; x=1782362987; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w1papM2W9KLSMiQ51HSi85TiIoRBa0nUKenc379MiLQ=;
        b=MDqKxLqZBaJd20gz2hOEJfZIPZM3VBEvaRwgzyo5xj6ceV2oZrtnqnifxNY4WUQlbG
         oMxPxb9+jSzTD+Kqo8nC00BeMw1RZL5VmnuWRLuwTlQGfaiIQFOBiG5Lrvubu9rvPR8J
         lJxMvkZaYCEzP48owozlIGHJrElI6XXij/4NZWWrfp9B8FlKhhjPWJfVdwcOpcECJsum
         RuaadurX636jAgiYbLSViHvngXMwb0WrWGPFaSKbGNAjRJW50QPndveqXi0UGhcXz/dG
         6PVBqDS2C5gCmBd9nEwh1PXvbUpSPwr18zcHKg1JrNBB9Y/5aCJNQG36Oa6dbeEDLv76
         UNUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781758187; x=1782362987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w1papM2W9KLSMiQ51HSi85TiIoRBa0nUKenc379MiLQ=;
        b=NoBzgGoJ1FEzFb/YFgk+Xn965CU1leIDVJzEgJe7WSAhXFHhaWuGBDCUJKNegaDNeR
         OXH+meDNfNIwrRXPUgfVdW9EHnibF/5gtvifmx8cYJv0v0Tf7G70CWIVLlIs1Vq+Gwj7
         GvyQD7xz5oGbLiU0IuhbB+0svOmJFHDDGZ0g+gHysHJSd6ij2TMhhcYWRDocCL6kkNaQ
         s8g/ibUJsOyDx7A9wUO+MA7GieCFHx/8JqI/ThkvNwZ2Zl5hPwdNG1EjlHxhOUkfo6tI
         hjc5NyWIkWKe8N+mSqAaqpCF3w78JSEsxl4GCSbe7qKb0RWqMYDzm8HjQyW4ZzKdNnlz
         nxBQ==
X-Gm-Message-State: AOJu0YyHajj5Lwi8TeNy0CWBXYnn3lCGI3HwkHr+VTgwXRV5Q3wR6k0F
	hGxrgXx/gm8OqIcXfa+2oZ2OwUmf92BUd9+64ZHNGH4F4lcXZOpHEl4N
X-Gm-Gg: Acq92OHc9lnCUt5GUDbjUUJgfkMtoBxevRnytI3XVH/Gj/5kZSWRDxrJMlKdkGp5i0M
	iS2tovxcHymOC64NoGYaiGhm2PeUlJQd26QadQ+SOA6RoiCBSL7/TIfoZmLmoHAAC/bm9hPw7cL
	d57vgzFJcspl+h6opcMNMEj3ImtpleHynnF7m7ljfvUbHWhpk/13G82IhAtJxISZd3cNUxNLaj9
	CZ/XqvMbHIZHGTcV8Sl5UQFWrgNJ5RN1fsvHCgzpy5YeyXVzdr3Jk7Wa5DWE7wPWmUatVigSCg1
	oiq2Hh9jcT1ujweRXIUQH4j1feNg0Zxrq1U6TCUoANydOxXyCQRCTWYTgNJ1VUEpzbTx+hZaVyL
	MO/PgmuF6tZSzL4hAIQFJW8Htcn/PPFjy42BztFr3C0EkpcQhQLiG7HIqgFHLUhBgwgkQmcyCeD
	7plJDGzkECcaC+47QP5XAcRtaQJBORG2s4c/m7LeHta7YqevvtmWo=
X-Received: by 2002:a05:6a00:23d4:b0:842:7476:2376 with SMTP id d2e1a72fcca58-84541db467bmr952550b3a.41.1781758187176;
        Wed, 17 Jun 2026 21:49:47 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434b020b53sm17214781b3a.47.2026.06.17.21.49.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Jun 2026 21:49:46 -0700 (PDT)
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
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v4 3/5] mm/zswap: Implement proactive writeback
Date: Thu, 18 Jun 2026 12:48:55 +0800
Message-Id: <20260618044857.69439-4-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260618044857.69439-1-jiahao.kernel@gmail.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7198A100004
X-Stat-Signature: idnaog8i4udi8m9mwfrzkmh9gwawfnsz
X-Rspam-User: 
X-HE-Tag: 1781758188-735428
X-HE-Meta: U2FsdGVkX1/9/1GmhVTP94pBqFgIItkCT+mAvrnCvRzKNoDdchMlmSQEMziuAwG5JyFhhutfgxLJ9NdU1zv1C1kIcycU4Cv0ilkTFKsqdHksI8iO3M7xwsGBjdXqEVHAmTECgukyiZM9YFGEcItRhAAHQRhZjn6+98u0Yvm1Ok/YGwfSrXTLwZZwG6GATcNVw0BVsFZeQq4jliUuz/2dZknP7gU4vd3pGLD2SlLDSGq8Z4nqfcFL2HisVGCs+zQkXSF1+RgLSLYMxYBBbfdoOh3OcS0pBvbNsBFVZjBHE7Acz7ufqSyxTeIJQWV1jJ9mb7HI/JbhvJxn8YG0YK4Iu5YgJnT9cVZpXmcL0eqWaCKKHhOuWIEv5GgABzn2SrnVb6vzRyA3Wcp58Wh4889LKG6W6ysKNprC27M28l6wvbdFuhn31zYji4Iy1N8aFCV+4+Smf0ODrmipxbbnX03N1GysvXHtkz4WAaC86d9qZM5QnpRXbmJTci5ePMV1GZPTXuswyZysqRW6jDRUfcQ5VkyyXHmaTFe+t6yeW3Xa2hdwwQq120YUuE/XFJfaAjl0wha2jXyPjIRJrefdykmKscXTDKcAGVvTrzOj5c7pGm6KkJJ5uSUjF+Spdebqqk32DlciYmjiQ+wybiX4IxnQGDgzpqyNym7QR57wzRvrf4QCKwpK38TPyXhLNUyU4yVA8FF2PLikzFgo1Fw1w4r4tmZYRE5WLYsYUKBR1mG3zNjy4Ji3/HLX+RNN9/oWGLQWJyAzrfCPLhl1DjIsEU5JL4YGZys+cM+BZInUIi7vI/ZFfI0dqQSfIlLvHSanaEsrTchFG42AUcyH0TyACFO7k6ROSkwIBmZ3qWNAXbMrGRJNPsGD8pCauejtVByyZsayIExZOZUGrXIvZOHG5nEyWCfQbFV9R2Y6ihFXLMANlwloHVx3sNuwf4VXDwItZcBz7VCAHEnbQ0th+bRfuhB
 Ssk0nlnM
 LWk/rn+m5fmGoAbvjK0SyqAJcydvvun3WsBAfJ2gzPInob/L0EgUer/bBCTNHsNzqm12/iu5K6zRMFsR4gjPqREJuw0qUrZUGeJ9RwTEPpNW5LbQZzvOI9h4Dqt2ya9ED2kxEBnkEKrnMB4nwGQGPR8nrcbQbmLObRdFTG2qDTqAzFTa8ODwf9VD9QVzGMHRBmq9KBrfxMIWlphpEzsC4WE1YWFd6/nMcG7J47oc2UAU/1AnP3esaapq9nRnBQR/HbAoc+AkA9qjfi9UesmLOGDougjGuOJwfAPt01qMJwafNA4UgGY6smt8T1hdMu2aVmahRXjqj5l84vUrsdvMREaJvq0qLPgcUuHABXMS2MNUINpLtH2mkT8VF3BnkXvLFYGtcyDBuXAjpNDYJ+lLPKbUBiR8RbDoeF7rsK8QST3IfZpNUT7wMQwfyYskclsWs6mp/h2G3304ltVSINzXwEY9PUwNhkbOhEO99jZ8r/Zy3f3cA2uXiodwg7MKu5l0WiSZISc1k8Es4NQOfjU1dQAuM0w==
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
  # Write back 10MB of compressed data from zswap to the backing swap
  echo "10M zswap_writeback_only" > memory.reclaim

Note that the actual amount of compressed data written back may be less
than requested due to the zswap second-chance algorithm: referenced
entries are rotated on the LRU on the first encounter and only written
back on a second pass. If fewer bytes are written back than requested,
-EAGAIN is returned, matching the existing memory.reclaim semantics.

Internally, extend user_proactive_reclaim() to parse the new
"zswap_writeback_only" token and invoke the dedicated handler
zswap_proactive_writeback(). This handler reuses
zswap_try_to_writeback() to walk the target memcg subtree, draining
per-node zswap LRUs through list_lru_walk_one() with the
shrink_memcg_cb() callback.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 18 ++++-
 Documentation/admin-guide/mm/zswap.rst  | 11 +++-
 include/linux/zswap.h                   |  7 ++
 mm/vmscan.c                             | 14 ++++
 mm/zswap.c                              | 87 +++++++++++++++++++++----
 5 files changed, 120 insertions(+), 17 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6efd0095ed99..e52d97e8e9c6 100644
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
+	are found. This is useful to proactively offload cold compressed
+	data from the zswap pool to the swap device. It is only available
+	if zswap writeback is enabled. zswap_writeback_only cannot be
+	combined with swappiness; specifying both returns -EINVAL.
+
+	Example::
+
+	  # Writeback up to 10MB of compressed data from zswap to the backing swap
+	  echo "10M zswap_writeback_only" > memory.reclaim
+
   memory.peak
 	A read-write single value file which exists on non-root cgroups.
 
diff --git a/Documentation/admin-guide/mm/zswap.rst b/Documentation/admin-guide/mm/zswap.rst
index 2464425c783d..fdeb197d1683 100644
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
+	echo "10M zswap_writeback_only" > /sys/fs/cgroup/<cgroup-name>/memory.reclaim
+
+Both of the methods mentioned above are subject to the ``memory.zswap.writeback``
+control. This means that ``memory.zswap.writeback`` can prevent all zswap writeback.
 
 A debugfs interface is provided for various statistic about pool size, number
 of pages stored, same-value filled pages and various counters for the reasons
diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..7bf38318dab1 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+int zswap_proactive_writeback(struct mem_cgroup *memcg, unsigned long nr_to_writeback);
 #else
 
 struct zswap_lruvec_state {};
@@ -69,6 +70,12 @@ static inline bool zswap_never_enabled(void)
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
index 299b5d9e8836..2e6c14569fc2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -64,6 +64,7 @@
 
 #include <linux/swapops.h>
 #include <linux/sched/sysctl.h>
+#include <linux/zswap.h>
 
 #include "internal.h"
 #include "swap.h"
@@ -7855,11 +7856,13 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
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
 
@@ -7869,6 +7872,7 @@ int user_proactive_reclaim(char *buf,
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
 	int swappiness = -1;
+	bool zswap_writeback_only = false;
 	char *old_buf, *start;
 	substring_t args[MAX_OPT_ARGS];
 	gfp_t gfp_mask = GFP_KERNEL;
@@ -7899,11 +7903,21 @@ int user_proactive_reclaim(char *buf,
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
index e29f8a61412d..28200552dde3 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1423,6 +1423,27 @@ static struct mem_cgroup *zswap_iter_global(void)
 	return memcg;
 }
 
+/*
+ * Local iteration uses a local cursor to select from online memcgs
+ * under @root in a round-robin fashion.
+ *
+ * Pass the previous return value as @prev to advance the round-robin
+ * iteration, or pass NULL to start a new walk. If exiting early before
+ * the iteration completes, the caller must call mem_cgroup_iter_break()
+ * to release the cursor reference.
+ */
+static struct mem_cgroup *zswap_iter_local(struct mem_cgroup *root,
+					   struct mem_cgroup *prev)
+{
+	struct mem_cgroup *memcg;
+
+	do {
+		memcg = mem_cgroup_iter(root, prev, NULL);
+		prev = memcg;
+	} while (memcg && !mem_cgroup_tryget_online(memcg));
+	return memcg;
+}
+
 /*
  * Walk the memcg tree and write back zswap pages until the
  * (lower_pages, upper_pages) window closes, or abort encounter
@@ -1430,16 +1451,23 @@ static struct mem_cgroup *zswap_iter_global(void)
  * - No writeback-candidate memcgs found in a memcg tree walk.
  * - Shrinking a writeback-candidate memcg failed.
  *
- * For shrink_worker(), it passes lower=thr and upper=zswap_total_pages().
- * The @upper limit is refreshed in each iteration by re-evaluating
- * zswap_total_pages(), and the window closes once the total falls
- * below the threshold.
+ * For shrink_worker() (proactive=false), it passes lower=thr and
+ * upper=zswap_total_pages(). The @upper limit is refreshed in each
+ * iteration by re-evaluating zswap_total_pages(), and the window
+ * closes once the total falls below the threshold.
+ *
+ * For zswap_proactive_writeback() (proactive=true), it passes lower=0
+ * and upper=nr_to_writeback. The @lower limit is advanced by the
+ * compressed bytes written back via shrink_memcg(). The window closes
+ * once @nr_to_writeback pages of compressed data have been written back.
  */
-static void zswap_try_to_writeback(unsigned long lower_pages,
-				   unsigned long upper_pages)
+static int zswap_try_to_writeback(struct mem_cgroup *memcg,
+				  unsigned long lower_pages,
+				  unsigned long upper_pages, bool proactive)
 {
-	int failures = 0, attempts = 0;
-	struct mem_cgroup *iter_memcg;
+	int ret = 0, failures = 0, attempts = 0;
+	struct mem_cgroup *iter_memcg = NULL;
+	u64 bytes_written = 0;
 
 	while (lower_pages < upper_pages) {
 		unsigned long batch_size;
@@ -1447,14 +1475,17 @@ static void zswap_try_to_writeback(unsigned long lower_pages,
 
 		cond_resched();
 
-		iter_memcg = zswap_iter_global();
+		iter_memcg = proactive ? zswap_iter_local(memcg, iter_memcg)
+				       : zswap_iter_global();
 		if (!iter_memcg) {
 			/*
 			 * Continue shrinking without incrementing failures if
 			 * we found candidate memcgs in the last tree walk.
 			 */
-			if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
+			if (!attempts && ++failures == MAX_RECLAIM_RETRIES) {
+				ret = -EAGAIN;
 				break;
+			}
 
 			attempts = 0;
 			continue;
@@ -1465,8 +1496,17 @@ static void zswap_try_to_writeback(unsigned long lower_pages,
 		/* drop the extra reference */
 		mem_cgroup_put(iter_memcg);
 
-		/* zswap total pages might have changed, refresh it. */
-		upper_pages = zswap_total_pages();
+		/*
+		 * Advance the window endpoint owned by this caller:
+		 *  - !proactive: zswap total pages might have changed, refresh.
+		 *  -  proactive: accumulate bytes freed and fold to pages.
+		 */
+		if (!proactive) {
+			upper_pages = zswap_total_pages();
+		} else if (shrunk > 0) {
+			bytes_written += shrunk;
+			lower_pages = DIV_ROUND_UP(bytes_written, PAGE_SIZE);
+		}
 
 		/*
 		 * There are no writeback-candidate pages in the memcg.
@@ -1478,9 +1518,15 @@ static void zswap_try_to_writeback(unsigned long lower_pages,
 			continue;
 		++attempts;
 
-		if (shrunk <= 0 && ++failures == MAX_RECLAIM_RETRIES)
+		if (shrunk <= 0 && ++failures == MAX_RECLAIM_RETRIES) {
+			ret = -EAGAIN;
 			break;
+		}
 	}
+
+	if (proactive)
+		mem_cgroup_iter_break(memcg, iter_memcg);
+	return ret;
 }
 
 static void shrink_worker(struct work_struct *w)
@@ -1490,7 +1536,7 @@ static void shrink_worker(struct work_struct *w)
 	/* Reclaim down to the accept threshold */
 	thr = zswap_accept_thr_pages();
 
-	zswap_try_to_writeback(thr, zswap_total_pages());
+	zswap_try_to_writeback(NULL, thr, zswap_total_pages(), false);
 }
 
 /*********************************
@@ -1736,6 +1782,19 @@ int zswap_load(struct folio *folio)
 	return 0;
 }
 
+int zswap_proactive_writeback(struct mem_cgroup *memcg,
+			      unsigned long nr_to_writeback)
+{
+	if (!memcg)
+		return -EINVAL;
+	if (!mem_cgroup_zswap_writeback_enabled(memcg))
+		return -EINVAL;
+	if (!nr_to_writeback)
+		return 0;
+
+	return zswap_try_to_writeback(memcg, 0, nr_to_writeback, true);
+}
+
 void zswap_invalidate(swp_entry_t swp)
 {
 	pgoff_t offset = swp_offset(swp);
-- 
2.34.1


