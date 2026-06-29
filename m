Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01240C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 11:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D813F6B0098; Mon, 29 Jun 2026 07:21:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D328F6B0099; Mon, 29 Jun 2026 07:21:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2856B009B; Mon, 29 Jun 2026 07:21:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94C036B0098
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:21:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 234A81A0659
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:21:19 +0000 (UTC)
X-FDA: 84932709078.26.8F5D7D3
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5280240003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:21:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ceGn//Wr";
	spf=pass (imf27.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782732077;
	b=i2k0dv6usosjNbUyx2vOxiPXkBqTrh2BgjyZi6HTa8/EbOoLbiUbGr6h8d/hIgJDQ1QAj9
	SDmsXu5rogEDH3Iik9h6yKUCilTOIJbjZ/oziQBCQykENkzl9wLDWCYVEWevEJW+vyaCsv
	LQQWrcLMIQAp+fT5kn00SdBFOsWxZCE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782732077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZhyMCX2Xpon+A3J1pvJv/6ZmIfArBWFkybN/rEQAmc=;
	b=pJiGtwp3u/sJjntOcqtOQ9NQgxrgwLnkDVxQmbRJuvtxM55uRczA3sBG31Btf9trkMuEgM
	d04u9mx+gzBrrQfibVHagxEtjqWp34xJeoUzTTpXVP+w/nr++eTO7vMclWYq/kcABdp66G
	k8po3Iwrl5AXL8UTtKTMpbZziGZwudg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ceGn//Wr";
	spf=pass (imf27.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c82da9504cso8472045ad.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782732076; x=1783336876; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZhyMCX2Xpon+A3J1pvJv/6ZmIfArBWFkybN/rEQAmc=;
        b=ceGn//WrGIUVJDywMh2i62U6t0xRKOBajUlAgd8vwm3IeDqbb3Jajecr2FeIbyhVKb
         vvHEQRnSg15E2Qnaghs6mp2HtXZeQbbhww+a13ZhIzGPsf7DRlZApjYbq9aG665Q5zgT
         Uu+pl5ZRIy0TGEuHoXRWnRNBSlIcvsbd56Ai3SNGA6UL+lJLUv1KGB173U0GM551F58e
         OPTOJKlukbo6x0z+DQJ/oSjLoVRmLpMxOQNvrLXW204cI1dBb3Y5Mk7hVl+VNfCinVfy
         dtf7eTSNmbHp9JK8u/p2t2SKGwgtYXBUWXVAc74VoiDNPHIeLH1d99neEV1FH7HyHe8E
         Rnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782732076; x=1783336876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PZhyMCX2Xpon+A3J1pvJv/6ZmIfArBWFkybN/rEQAmc=;
        b=mrR6rU5Qzer47hwQxpdPn++Thj4mz7SY4Ey521XjFABNhwpgxnsn8eadwnV7rDmsSW
         NBDTbQdyJGFZ8isn9ty22QHzi6LUJFfHzaEVD9ul+rjvyeB/QoQGfZO0cqj9UbZVdT/F
         UOhF13yQwfjbXzL78rASqt03mw9fEg/g4dqDsxedbhd44nuCOL8TN/7OhQLCKfsPRR9J
         3jDknAtcFbwuz9cm1k+SKjMkzctviZg4iiwwjABLsZXG+GBceAnim9S8CpSq4gTn4kSf
         FQp9s2r/mRrgj5RTmUWSg+6K/aPeSHMIzKHmwv8S7RcxzPc/z0YnR3NBxgyg6tKt20oJ
         2jOg==
X-Gm-Message-State: AOJu0YwN3+JFC63yRnwRr2+DPq9DX5DLhKaqBTRmog83hGLkGQhWUYq3
	9BKm2zcb805kJYZGO3A504f3C6c0AdPPu9AM2wEDOGahaOBZpG/81QZa
X-Gm-Gg: AfdE7cmgOxDhWFSY+pQ8cXh8nwjH0/3YLo2z2ER/Bpsct2tdYRklcePB2AC7NgHBH4D
	YEE0UBPlbqYWAo815K4idlYJeNZEoKSFM5OvL0XrJebQ7drJSVQmvHBKsIN87F6/fbz9+ptsdbn
	Nqsbx0u3Wr5ZzsjWZ2JCH0+L0cIzUDrM8mXXtjtba5J/KYgDfUhrSvz1DJzwT60peM/1H7qkvcP
	aj+dNa0UGQ+VOFPx7Xo2ytdIqhS57FzXbtQe2Vh2uNPUN7NOpDnwUZrTGMWgnIUiKdH+LDg42pI
	O74vyViqPZ2ilimRfmyXffQR1a9pccUD7wzcT0V/95usX0Xm/Y7aa+5sKmXJZRNZFh5hK+i3T25
	W7oHZpHoMqyl0utkZiwFfImmLnSi41X/H/wdns+telSFeXkaCC6QKl632po4KIo/Yin4KsMOvDq
	2nKlPxy1IfIR+qth5I67U4xXvavDhAoxbHNa7WHnl1
X-Received: by 2002:a17:903:38cf:b0:2c9:97a7:328c with SMTP id d9443c01a7336-2c997a7340dmr98402305ad.46.1782732076224;
        Mon, 29 Jun 2026 04:21:16 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f63d09f0sm92759085ad.56.2026.06.29.04.21.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jun 2026 04:21:15 -0700 (PDT)
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
Subject: [PATCH v5 4/6] mm/zswap: Implement proactive writeback
Date: Mon, 29 Jun 2026 19:20:30 +0800
Message-Id: <20260629112032.20423-5-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260629112032.20423-1-jiahao.kernel@gmail.com>
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mmmn4wqagfrftg98459s6i8yoqmgygim
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5280240003
X-HE-Tag: 1782732077-654302
X-HE-Meta: U2FsdGVkX18SKDHDbG/WVMXRs8BEassusnDurTxSxQ52R6GWRrXE+rM8AvXLBgaXiOxonCqH057xtY4R8JkoY+EyUC6C6UpBfiS8bw4OuugxfJo7UnAvK/U4KdvNHEG9mnb4cYhXvJkIjFIDPTco3Nm5Gxf7PrfsCQikjaR3Yu1/vKvpBjcOP4ctLLDLSrcn/PGlBmQ3DfWYYUsBmy3xCXwUQnwDrqI71a6fexKedK/3htH2wctIQ/Yj3VKc2n6iDWI4rlkD2KYrDpxa7l83Qlr4UX186yLd3bH+bD/p42q6qE3OeKuh+0n0rpflIYrL5AbFjc+mU3GqPFW3p3I+feT6HdMoW6HWO9uyqz8a/OE79G/0ZapMM0NjCwCBqCwbehICDZbbj2TbV4tyKbndomI6i5SWZLBrxNyk0EzJjWq79DPujz1OfNm7FfJkaZZdSXs6vVcdYEy1dzPlN3Cg0IIGHxpUhRMjLf7m+8VUpC+lX7J+uVqosxwMtGB5OUEGdRyCV5SIJSuVtYabxO2OJ27lDnXm6EzvnV7yhGmRTrZLVDHF1uGoakn90H1dAhPUOnxelolvfTrn39/mif05M5UNwArmbzKPgtkGODHvWUyCcwrmDKxFwaQ3Ie4k0ga/e62rnkEO/o97toi7yNiF8XQhB12m+GuJldL6oW2hB/o43cRq1PO/fBuYBUYWi5zfpATnJnBLIVm801fYB/Qz/8k2sjFUFsaOxuGG4B24l1W8ML3qYwdz9M/6MVKcFsh5ZYvLazBL7ulxJGkpdEaCEv2SLVJ48lp/cPGJyu9N5nQWMnX1Tr909uDZ5vJBVMjpOyZQvbyQ/KmRsYrqgzSrShn8KW1MVD+1Di9emKCe/UqvAUr0YURydzhkjWIy1l79suLzbMi3N+mLOjGTeYjXIRJ2YbvewBnKShbptOXPLpzX4AkPRfvC/sA+YZYl2kUXh8mUvsKk90lF2dSOQKv
 VRPGygS+
 b3J+m2FalpBTPVX5djnvO3cqMizg2F6mxFOpy2lP9RT2dGx2HFYk29HMJekXY6W4sECvFlWhVP+QAmZF7a/9H0MXCXI7ZkRx98SuuP3ZWKszlzT+oKF+G7BppEsb9iFpBqgYB+5/SkZ+5B8XWrZDU7PCcoN6h0dsuiAOnkQqKmFUrkUijpw2AnbZCQlZmVxMoIsycN1ZUl4eKUGUW3OkkLcUA1F74PsOL1yt567zWVstKENEqwRYfV4V6e+QkusIVqt85uW7rpQe13bJibB/Tml0oDZOx4mooJmSKQElrs6rQvI8VoDWNw3eE+KGS+O9dwWYlXhNrQBaS6sRhKKf5oeYmYA9tC4jTOD3XNDG4c3ga+0LgBp7q9fJpjdZoKoHiTs48g7CMg/NoNkHemnBGjgXVHYSepZq2QBYCEGpZM/pOXuzpC9TJNNpMZwPj3LTVkd+9E9xQmj4MKyThCo62JGEAH7hb04m0LoG/cSIG1vTL9kZTAxF8NeTbXKfm3n3VhspM+cSautN9Id26s9xqEZbs6A==
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

Introduce a "source=" key to the memory.reclaim cgroup interface,
currently accepting the single value "zswap". When set to "zswap", it
bypasses standard memory reclaim and exclusively performs proactive
zswap writeback up to the requested budget. If omitted, the default
reclaim behavior remains unchanged.

Example usage:
  # Write back 10MB of compressed data from zswap to the backing swap
  echo "10M source=zswap" > memory.reclaim

Note that the actual amount of compressed data written back may be less
than requested due to the zswap second-chance algorithm: referenced
entries are rotated on the LRU on the first encounter and only written
back on a second pass. If fewer bytes are written back than requested,
-EAGAIN is returned, matching the existing memory.reclaim semantics.

Internally, extend user_proactive_reclaim() to parse the new "source="
key and invoke the dedicated handler zswap_proactive_writeback() when it
is set to "zswap". This handler walks the target memcg subtree in a
round-robin fashion and drains each memcg's per-node zswap LRUs through
shrink_memcg(), accumulating the compressed bytes written back until the
requested budget is met.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 18 ++++++++-
 Documentation/admin-guide/mm/zswap.rst  | 11 +++++-
 include/linux/zswap.h                   |  7 ++++
 mm/vmscan.c                             | 24 +++++++++++-
 mm/zswap.c                              | 50 +++++++++++++++++++++++++
 5 files changed, 106 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 993446ab66d0..bbcc9695aa8d 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1425,9 +1425,10 @@ PAGE_SIZE multiple when read back.
 
 The following nested keys are defined.
 
-	  ==========            ================================
+	  ====================  ==================================================
 	  swappiness            Swappiness value to reclaim with
-	  ==========            ================================
+	  source=zswap          Only perform proactive zswap writeback
+	  ====================  ==================================================
 
 	Specifying a swappiness value instructs the kernel to perform
 	the reclaim with that swappiness value. Note that this has the
@@ -1437,6 +1438,19 @@ The following nested keys are defined.
 	The valid range for swappiness is [0-200, max], setting
 	swappiness=max exclusively reclaims anonymous memory.
 
+	The source=zswap key skips ordinary memory reclaim and
+	writes back pages from zswap to the backing swap device until
+	the requested amount has been written or no further candidates
+	are found. This is useful to proactively offload cold compressed
+	data from the zswap pool to the swap device. It is only available
+	if zswap writeback is enabled. source=zswap cannot be
+	combined with swappiness; specifying both returns -EINVAL.
+
+	Example::
+
+	  # Writeback up to 10MB of compressed data from zswap to the backing swap
+	  echo "10M source=zswap" > memory.reclaim
+
   memory.peak
 	A read-write single value file which exists on non-root cgroups.
 
diff --git a/Documentation/admin-guide/mm/zswap.rst b/Documentation/admin-guide/mm/zswap.rst
index 2464425c783d..b49b8c130389 100644
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
+	echo "10M source=zswap" > /sys/fs/cgroup/<cgroup-name>/memory.reclaim
+
+Both of the methods mentioned above are subject to the ``memory.zswap.writeback``
+control. This means that ``memory.zswap.writeback`` can prevent all zswap writeback.
 
 A debugfs interface is provided for various statistic about pool size, number
 of pages stored, same-value filled pages and various counters for the reasons
diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..e5f217759894 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+int zswap_proactive_writeback(struct mem_cgroup *memcg, u64 bytes_to_writeback);
 #else
 
 struct zswap_lruvec_state {};
@@ -69,6 +70,12 @@ static inline bool zswap_never_enabled(void)
 	return true;
 }
 
+static inline int zswap_proactive_writeback(struct mem_cgroup *memcg,
+					    u64 bytes_to_writeback)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif
 
 #endif /* _LINUX_ZSWAP_H */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..56ed7ff48ec9 100644
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
+	MEMORY_RECLAIM_SOURCE,
 	MEMORY_RECLAIM_NULL,
 };
 static const match_table_t tokens = {
 	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
 	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=max"},
+	{ MEMORY_RECLAIM_SOURCE, "source=%s"},
 	{ MEMORY_RECLAIM_NULL, NULL },
 };
 
@@ -7869,9 +7872,12 @@ int user_proactive_reclaim(char *buf,
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
 	int swappiness = -1;
+	bool zswap_writeback_only = false;
 	char *old_buf, *start;
+	char source[16];
 	substring_t args[MAX_OPT_ARGS];
 	gfp_t gfp_mask = GFP_KERNEL;
+	u64 nr_bytes;
 
 	if (!buf || (!memcg && !pgdat) || (memcg && pgdat))
 		return -EINVAL;
@@ -7879,7 +7885,8 @@ int user_proactive_reclaim(char *buf,
 	buf = strstrip(buf);
 
 	old_buf = buf;
-	nr_to_reclaim = memparse(buf, &buf) / PAGE_SIZE;
+	nr_bytes = memparse(buf, &buf);
+	nr_to_reclaim = nr_bytes / PAGE_SIZE;
 	if (buf == old_buf)
 		return -EINVAL;
 
@@ -7899,11 +7906,26 @@ int user_proactive_reclaim(char *buf,
 		case MEMORY_RECLAIM_SWAPPINESS_MAX:
 			swappiness = SWAPPINESS_ANON_ONLY;
 			break;
+		case MEMORY_RECLAIM_SOURCE:
+			if (match_strlcpy(source, &args[0], sizeof(source)) >= sizeof(source))
+				return -EINVAL;
+			/* Only zswap is supported as a reclaim source for now. */
+			if (strcmp(source, "zswap"))
+				return -EINVAL;
+			zswap_writeback_only = true;
+			break;
 		default:
 			return -EINVAL;
 		}
 	}
 
+	if (zswap_writeback_only) {
+		/* source=zswap and swappiness are mutually exclusive. */
+		if (swappiness != -1)
+			return -EINVAL;
+		return zswap_proactive_writeback(memcg, nr_bytes);
+	}
+
 	while (nr_reclaimed < nr_to_reclaim) {
 		/* Will converge on zero, but reclaim enforces a minimum */
 		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
diff --git a/mm/zswap.c b/mm/zswap.c
index ba01bf0e44e9..9cda96f05508 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1713,6 +1713,56 @@ int zswap_load(struct folio *folio)
 	return 0;
 }
 
+int zswap_proactive_writeback(struct mem_cgroup *memcg, u64 bytes_to_writeback)
+{
+	struct zswap_shrink_state s = {};
+	struct mem_cgroup *iter = NULL;
+	u64 bytes_written = 0;
+	int ret = 0;
+
+	if (!memcg)
+		return -EINVAL;
+	if (!mem_cgroup_zswap_writeback_enabled(memcg))
+		return -EINVAL;
+	if (!bytes_to_writeback)
+		return 0;
+
+	while (bytes_written < bytes_to_writeback) {
+		long shrunk;
+
+		cond_resched();
+
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+
+		/*
+		 * Use a local iterator to walk the memcg and its online descendants
+		 * in a round-robin manner. Upon exiting the loop, mem_cgroup_iter_break()
+		 * must be called to drop the iterator reference.
+		 */
+		do {
+			iter = mem_cgroup_iter(memcg, iter, NULL);
+		} while (iter && !mem_cgroup_tryget_online(iter));
+
+		shrunk = zswap_shrink_one_memcg(iter, &s);
+		if (shrunk > 0)
+			bytes_written += shrunk;
+
+		/* drop the extra reference taken by mem_cgroup_tryget_online() */
+		mem_cgroup_put(iter);
+
+		if (shrunk == -EBUSY) {
+			ret = -EAGAIN;
+			break;
+		}
+	}
+
+	mem_cgroup_iter_break(memcg, iter);
+	return ret;
+}
+
 void zswap_invalidate(swp_entry_t swp)
 {
 	pgoff_t offset = swp_offset(swp);
-- 
2.34.1


