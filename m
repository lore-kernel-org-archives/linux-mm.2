Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0F64EEC2A7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 22:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D908A6B0089; Mon, 23 Feb 2026 17:38:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73266B008A; Mon, 23 Feb 2026 17:38:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88686B008C; Mon, 23 Feb 2026 17:38:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6A2F6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:38:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6CAD8B5F5C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:38:39 +0000 (UTC)
X-FDA: 84477187158.26.6E5E145
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8E317100011
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:38:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="RRuB/760";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771886317; a=rsa-sha256;
	cv=none;
	b=VrUZxuBmNHXihnzSchUvXl0nyl2QiOqduQfR2ev5OYB3ou1ZRx+E9S3y3+ah6yoDYjd9gz
	4A/MIbtxKH5wJ4bm9kNCY9+o1BhDGjui5DkoteHhgBUYgBatK8v3EEDTB+Ym5gHm85ITe9
	MUSXLWdGybnmu8XZxVD271688kmnkdg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="RRuB/760";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771886317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQzkmrIS51etVi0n5gq17TgjaIpr+hzH+jF14jX4sdo=;
	b=Uu02vJNyjJ5bj2w1xXFh3aNyudBxZUaIZ5T822uyoG5NBTbprYt3DRian/MkI7Ul0nO7sy
	9TkP/WvH5gqngt4vg9VrsQPf6SQybfzrzhgUEsX3A8Uxw8IWSaVjg1a6SGAHO9AI6uyxlk
	zYXx6TsbLoLisXgwcz77S6hNf/LxM78=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7d4be94eeacso222471a34.2
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771886316; x=1772491116; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQzkmrIS51etVi0n5gq17TgjaIpr+hzH+jF14jX4sdo=;
        b=RRuB/760ygIJm+KTeCYKTIJP0C1277piP1vWuf5emJF341z2/EgWMNJS/IXqM8Q7xu
         LaPa06X/bvpkPWg3b3nCBGA5db84IJ9dCyWRb6tLoZLh57FCFECgGtoLAVWlS8VerY5F
         qyJDP8zgl63ISC+PF7oaOn9jc19dn4OQsCXiTUoLgSihQgikAdIUxTsT16OzaWj0AdRr
         dMzBFpPoATzvPaC595tCBNdHSQfTA4LUKKaTdHX78qXzawuNDXMGbJk6XGAfNIWqcJT3
         AKJPNdk7rjHmvC/2bDT0UhWVNkLJHFxSWngK9/yi6L7yhMd+XUi+wqYw4JeobUZPNuu6
         /ptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771886316; x=1772491116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yQzkmrIS51etVi0n5gq17TgjaIpr+hzH+jF14jX4sdo=;
        b=sjpb58ENB+9l7FDDm/XRgRP2v9yHvHritNWiETb6kc5Z8aezTENzcfblICdoMj5FLI
         cvzVJr+P4DDO5Rlpfiv+DLQsKG/hmMAlig4oqEsdcT0862qGZY2C4gwfYEN0Uid1xGzU
         czoB63xl8+S0q/dKHdBp+nrHtKRvN2dxpZ1vtUCL23OPNcXcmBCIRchhyyIkOtEuXBbi
         TjkjogFmdHIPzL2xnTdlQPYMMK8NgDjPnD1qUa/1gWs+3BUBcf27i9GpABeC8cuZm1QI
         CqsGZwCLuqMn1luFCzQQ/LPyK9ilmAMsgeXb+FEuDHSZ7HJn3TQ8buLchSQev1nNnMtZ
         T8+Q==
X-Forwarded-Encrypted: i=1; AJvYcCU9ns7UPYCvYmslAxHmQWSc93uTYUaH20zT4TBmycdeHW1wvUnCoMOR0E7xRx3GaNSuCI3yinLWtw==@kvack.org
X-Gm-Message-State: AOJu0YxjZ7tzI8nQw0zyMwRz4lhFohE7BNQWukjOnVZLYuL1U4BXK5vw
	EmvuLu9dUSVWSpiOdvP/7xw8/2s3FBHk963plUn2lCRhULQ4cscz8Sxj
X-Gm-Gg: AZuq6aJnNBJuSTP4dgUxA8Rxh0UsnJZPM+Mjy3UT760nXmet1X3TaF2vW7B2SRIyM4m
	J3TvVVw3CFwtP79BVovOO8psUUc9ZKnJj8WnJT2B0L595z6xvMMj/71Pl7H6SIvUxCk2DzW6TlC
	2psFU/etCZ0MkB5kNUNsxrSkRSQDWHuWlP75aaHeO+1kcZn3ejuwso847V2gkeokAq2WLwAqN5d
	4v0TXATfmtoBqcEr8uSAPyr2+GghBUE4ljgpOOh1OFbSuSfHlYd+Kd4YU6Zs7PpJwaoDawvptFE
	m7TILYQOxc2VeBsrOG9V0+GWlDxh0WS7CMaVu4a4TWr1F/G9yjTO/Vzk0SYARVpZpJ2hUOD86T9
	ANvcjq03o9sRwLdzECjARGyC4FgJKHK3NbL8k+L/Q8gxR62uoxQZTWCNgifprZIqzxn8DBMNP1f
	z1dC+sbdg+cMKHFC0UegFP
X-Received: by 2002:a05:6830:369b:b0:7c5:2dbf:4a7d with SMTP id 46e09a7af769-7d52c1c04c4mr6267036a34.31.1771886316479;
        Mon, 23 Feb 2026 14:38:36 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:9::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d52cfa03bcsm8389594a34.10.2026.02.23.14.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:38:36 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 2/6] mm/page_counter: Introduce tiered memory awareness to page_counter
Date: Mon, 23 Feb 2026 14:38:25 -0800
Message-ID: <20260223223830.586018-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
References: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8E317100011
X-Stat-Signature: dgxszqeay4bt47jbqfq9c49pojza58n3
X-HE-Tag: 1771886317-726093
X-HE-Meta: U2FsdGVkX1+c3dbFcuuIP46iz6J9414wde6j/2mEnldt9MxkpWiFnQe4aHUWGinIkbDcOzGUQ7pMSdRfse7pUR8Vvdr2zRVw0TWcsfdfVbfxpK4gHgYwb/lrvuyZabn2Z+w68k4Qo7BhN2H3glDAg9Ptuy9yGjyII5h6Y0gbIMgdnjugF0rJHTfhVCvxm3wOqVqKxcx+R1RfToFQejnpTh1hyDZCP5iLJIqYX/NgETVMXWNMYYkAUUFgSjAq3gNTm4tJt6ba5LIM+hbzsDbtIniXNPrKxthrkGaRdpXsIzYyJl/qpewnf/AT8/DYPtIJSN1LWznLoQVRHV/9j5hHMJdOSe9Xec38GkPsS8gMx4wznnHL6EykhrtZd2VfaaK+ITmxPhdboOvNQiQ2YA26sc7UuwGSwu3hzmwA2YWPggyauAd4NxF9I9DPhmnrG0k9udGHhHygQUkSlB4+a330YJCVo8Nu5FsOvDQVr0lqMK9wPtvvFXtYj6r+H54vAV6ii1vLS5bNwUpucerg92RFQA5o0q25dBBEczVqcMRAqbt9dVPNZDZCuxh3PhGWhvyHQAgFsMXsqomVTNadk8IBVU96JcICfjwRhI/+Rr8AIEp5PbrbiNvjeuQxI2Wt3VzVnG7kt1L1kc6RRfUKCvaLYSHc63HLt8kgJTEQprB3tND1FFtEJs9aGq24ZR4DMRHONHf65Zs2Md3NUUS3Zjmcgoi1vEy8EuM7ZHuGVTpuv8e+QBLPDun1aglLTnegSdxsPKxuLh3uPafz3J78KQk6uQj9mGDFgVKVldM2IXTTCYXuv8Y0PtQOpqY4zws0y3A6ozdjFGvhVYelbYpVQewFxrXnanOSKVgXWD1JrRo+19Um0e1lJIvXYuqxML1ENWNVb0wNrmHJcT3nSPoQ7iffI/3BFJ+EEBRuZFapYpbc328aGSXCw15hlZE1GZlbaxdaQDzkn8gXKi5SechMpOr
 w4QYG4UF
 muLBi/j8iOrwUYilcNvBBJ+jePSjfGoAdSaRZqacSjeLwY9JIto1Ehtw5XxYlBkgcWjYrf4dD7YHByyXmdufOTbknE3GDEx+yQRk99GhuUrS4JnFbwDfYrwr+UAbw9p7vAItA7SI+C9WtK5jxNhTbIBYz/6Iyo74NbdcDyv88mT1aEcGI6lOODyYRUtTxwCf1S3nD6k3ljWN/1z9s2Ql/MLBLovPJFYf3sfxCn5OGlxwPiudYSgxRX38sXjrqFqb+BsmdK5n3Ayax8sb4uD+nGOzbX2nGMTdRMVNlfSmJ1XHUpW9T5xYrvJjmuGOTIF9GYAowTEQKydZIKde0UP8Wjf1/j5vhbtGu/fGg3cI6b9P8xTnfRsMB+wbrng/HO5Wpmtecv5CIFfnR66wVilQxlJfMWEPiyHe6quuSEuXv7kOIbdbYyx3chL+dUtElDNLW8hraRabUvc7zTXaObqzlanB/0TjF/Dt8PHG4/4yPTDoLzXu8Ixc1spgVQWHr+BXjgul+83bOZeD3vBKqmW/i6TjtXwCqZd2blzE1d1cPzqsOa05mOj2t3WZm9QGe0Sx0Y5c3V0kfL9xeGA18GeyGeKtnJTaHDY78Gqbf5BjJ3B4EwKCiDOeDfhX4RO7+Z9QS1snojRUpt5mfLaNfsYBbsnKc60F2U/1ScVi2vsifl8p4X2NAqMbQ64hoJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems with tiered memory, there is currently no tracking of memory
at the tier-memcg granularity. While per-memcg-lruvec serves at a finer
granularity that can be accumulated to give us the desired
per-tier-memcg accounting, relying on these lruvec stats for limit
checking can prove touch too many hot paths too frequently and can
introduce increased latency for other memcg users.

Instead, add a new cacheline in struct page_counter to track toptier
memcg limits and usage, as well as cached capacity values. This
cacheline is only used by the mem_cgroup->memory page_counter.

Also, introduce helpers that use these new fields to calculate
proportional toptier high and low values, based on the system's
toptier:total capacity ratio.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h | 22 +++++++++++++++++++++-
 mm/page_counter.c            | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index d649b6bbbc87..128c1272c88c 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -5,6 +5,7 @@
 #include <linux/atomic.h>
 #include <linux/cache.h>
 #include <linux/limits.h>
+#include <linux/nodemask.h>
 #include <asm/page.h>
 
 struct page_counter {
@@ -31,9 +32,23 @@ struct page_counter {
 	/* Latest cg2 reset watermark */
 	unsigned long local_watermark;
 
-	/* Keep all the read most fields in a separete cacheline. */
+	/* Keep all the tiered memory fields in a separate cacheline. */
 	CACHELINE_PADDING(_pad2_);
 
+	atomic_long_t toptier_usage;
+
+	/* effective toptier-proportional low protection */
+	unsigned long etoptier_low;
+	atomic_long_t toptier_low_usage;
+	atomic_long_t children_toptier_low_usage;
+
+	/* Cached toptier capacity for proportional limit calculations */
+	unsigned long toptier_capacity;
+	unsigned long total_capacity;
+
+	/* Keep all the read most fields in a separate cacheline. */
+	CACHELINE_PADDING(_pad3_);
+
 	bool protection_support;
 	bool track_failcnt;
 	unsigned long min;
@@ -61,6 +76,9 @@ static inline void page_counter_init(struct page_counter *counter,
 	counter->parent = parent;
 	counter->protection_support = protection_support;
 	counter->track_failcnt = false;
+	counter->toptier_usage = (atomic_long_t)ATOMIC_LONG_INIT(0);
+	counter->toptier_capacity = 0;
+	counter->total_capacity = 0;
 }
 
 static inline unsigned long page_counter_read(struct page_counter *counter)
@@ -103,6 +121,8 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
 void page_counter_calculate_protection(struct page_counter *root,
 				       struct page_counter *counter,
 				       bool recursive_protection);
+unsigned long page_counter_toptier_high(struct page_counter *counter);
+unsigned long page_counter_toptier_low(struct page_counter *counter);
 #else
 static inline void page_counter_calculate_protection(struct page_counter *root,
 						     struct page_counter *counter,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127..5ec97811c418 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -462,4 +462,38 @@ void page_counter_calculate_protection(struct page_counter *root,
 			atomic_long_read(&parent->children_low_usage),
 			recursive_protection));
 }
+
+unsigned long page_counter_toptier_high(struct page_counter *counter)
+{
+	unsigned long high = READ_ONCE(counter->high);
+	unsigned long toptier_cap, total_cap;
+
+	if (high == PAGE_COUNTER_MAX)
+		return PAGE_COUNTER_MAX;
+
+	toptier_cap = counter->toptier_capacity;
+	total_cap = counter->total_capacity;
+
+	if (!total_cap)
+		return PAGE_COUNTER_MAX;
+
+	return mult_frac(high, toptier_cap, total_cap);
+}
+
+unsigned long page_counter_toptier_low(struct page_counter *counter)
+{
+	unsigned long low = READ_ONCE(counter->low);
+	unsigned long toptier_cap, total_cap;
+
+	if (!low)
+		return 0;
+
+	toptier_cap = counter->toptier_capacity;
+	total_cap = counter->total_capacity;
+
+	if (!total_cap)
+		return 0;
+
+	return mult_frac(low, toptier_cap, total_cap);
+}
 #endif /* CONFIG_MEMCG || CONFIG_CGROUP_DMEM */
-- 
2.47.3


