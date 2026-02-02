Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E81DAD172AE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 00:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1073B6B008C; Sun,  1 Feb 2026 19:55:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1B86B0092; Sun,  1 Feb 2026 19:55:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5266B0093; Sun,  1 Feb 2026 19:55:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBCD46B008C
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 19:55:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A22361409F0
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:32 +0000 (UTC)
X-FDA: 84397698504.22.6C49E9D
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id D552A140007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I4Se2Dli;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769993730; a=rsa-sha256;
	cv=none;
	b=IFCbWvlDe8tKvh/cwgLdwNIKuXuCep+FVnryXZFxQQKXsgfU8n0aoyZNs44PB8aHA5aPtl
	jTWQPNoVCpFcO3QUdYvfBWLjb3oV1mREjzxG7VtkzcoiPKI/q2uIDxKHLwDC1j9+asWW/+
	k3p6AKFNNuHapFCECCiTl9WLWWaibo4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I4Se2Dli;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769993730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rQf42l81vbrWHLFD+4Euf1umigy7cZsac9bu9cfg5c=;
	b=geIHN/QrrPRknO4kNxXJbdTePj5IAGl+9Cha6qcUSxagy583haXYGWK+6kGbmluTP3PfZm
	rGS4Qp0Zk9eIB+NtiBCK+XFGNcusPDbpmwXHNsH0P24U6z3WSOQHQPyFglsXP8QajQwgga
	8zamASmD4JcUDJ3t5VTdkhMEsbVYh/U=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d18c654458so1508951a34.3
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 16:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769993730; x=1770598530; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rQf42l81vbrWHLFD+4Euf1umigy7cZsac9bu9cfg5c=;
        b=I4Se2DlixN+wUFZxL54HrEbt1C6oWwi2UWKndxdf5m8Y61AZXxVET0ptwd40zMUGzq
         wcI9tmnjHmvm7i64rtUl/xDVTnz+rYfCCgj7E5ArVNjXzzW2ayqlM3HrE8TjdqxO8jle
         Gr0mutzv//LeFEE2LJFo/RVuYhH9XzqUoOq3sD5afCkHSRUPkzMVJUF0jxz1pLQzo1Pd
         rE+mPm/1GZNWDMC1GdF8V+Iz4yjO4eCQb600lXuGF00W3cYjuPpeEizV9MLoXOckuKo4
         DZkiNiMRmhjWvLU3dblJLzo3bBBwjFTniKZZIWfTRVrev4DhDFpUlv/mb2VMrjBIuXdu
         8plQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769993730; x=1770598530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2rQf42l81vbrWHLFD+4Euf1umigy7cZsac9bu9cfg5c=;
        b=XRe2JPMzGzlA6WHsQTCB9jCkAWzcQ/h5uIOhHWLm22BGods60nApMGrcOsjUc1stLm
         NPL7sMiu2mbBcLBD6f0AWgKZcOQb1kx03PgYT51X2z+DWKff+P4yKEJ97TB8thbmXRgB
         q/d/zWEU5N5oj5iiW3VoqL2IZLnYV6muMCIgOp/24ozHwERRttBY3BFpaWI6JI3hSmJ/
         /Sly6XsqjIJFNsZsisTpji71LH0BQBrEwNpisNSajGCW7AwEBSQmhrqiaBX3EXEEg7sd
         gtMbcs/ZYHAKWcYcZd6z1mQm5PrHIIGWqWcDfvH/pKL+llnrTjAwKFlGAmf6sRXvwiC5
         JQsA==
X-Forwarded-Encrypted: i=1; AJvYcCVt22yUiqNz2a1VaX/U8nREBdr6QgJ3KEXOJ2RePseX+AhvQZOw0NU3TvclnanCzu7PLXCF9V85Bw==@kvack.org
X-Gm-Message-State: AOJu0YzpaJujSj2eeeCCAtg/dALVMh0hYMfo0nPjpFTElcnWskuRr9WG
	+X+Xho999PHRaRJ/I4s1n2YG09+W/+YsMv56kxi+LrVNBaNhmOVm2nMG
X-Gm-Gg: AZuq6aJr8HKjTWbY66deIOeBn2VBo9gqPZnAySRHhOM9uZhmeMTEbejjJHfmeD9f5Gj
	3ijeiu/moSQ4docaX6/W/XSHDd0JSfzlAk4Y8PIv85RNcj8TKRjJyR0UJ2bMBFfZ9rIvVnqwqjq
	ebvJhsis7jZ6dy2baWZ/3TXWVScPyAO3ChH3Aqlb/T3u+5TgDLk/4wy6Rkz3NgS3We6AP8t8Ap9
	Yqe650WVMV2X6EtpEEGe3hqv4ceEyQEojwxcUz5gaKbhrjJF3kqcVhwF1xpilnRe+1VCYTNPoef
	Cg+DvA8AFtAHmMuGnFm+PMAUwdX64t4jJuqi1v/j2o7ruEXVl5WPELiAk89gs/IW+oLTJv+pmHs
	rBJxlwnkxgEs//IV9NwtjRdkyAUTmQKXb7QuitzgiQIAKg7aM7LYRYfXiU72jjlLthtH7DlUwsg
	MhHSBNflpC
X-Received: by 2002:a05:6830:4389:b0:7c7:8280:9207 with SMTP id 46e09a7af769-7d1a5335f7dmr6749201a34.37.1769993729809;
        Sun, 01 Feb 2026 16:55:29 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d18c69ac16sm9771704a34.7.2026.02.01.16.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 16:55:29 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: ziy@nvidia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [RFC 02/12] mm/thp: add mTHP stats infrastructure for PUD THP
Date: Sun,  1 Feb 2026 16:50:19 -0800
Message-ID: <20260202005451.774496-3-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D552A140007
X-Stat-Signature: mp8a8wgsogoaw5emo8x8x3f514jak74w
X-HE-Tag: 1769993730-128856
X-HE-Meta: U2FsdGVkX19e3ETWMd8CR1iDj1FPU3z6mtIEC4FcYckcmAQrLCaPpjsuhuF1lqGOnIfXeMRwkEeGu4/bA60s+GnC2AC2yQcdfHV0VhnxcCkCPOfzzt5Vk1wzlNSvXJPE4cc+b9toC4Y74oLm/otDJBNnFxUtNXygIhjlzGmfDYws+8U4CKwzQlBhmGh2EAnyGqIgPn+DfR8EvkgbksNRBK/dT+2AyhWfVvWoa39YlwwXwW64Wo0vkFeP6OH1qYX3O6iU5uWD0vhk3fIzvASy+hbAYD4m7QJCZoUs3NI+bKMFlHRaUcCJtcrjZBV3CtDPCS4JoKMTtkM4pWfWpCqQBkRZbgXH2YMzRvvUUUkzxS7eIIMMY7+WGAsRE0GpaZRay8YiJaECqMVDN/s9E/bQb5InWmJ7yImRYBY4gIbrZiZ45p8XFjh0V3/aFf6J3S2jtRcdh1cWx1rtD41UAUHnWBdbt3m+nO0zndw/5ttd/nxJio8reafsA/AXL+hU/GHM5JVSrdaPZqIgOTFvRWtEJlEWfRbHPSowpHdMZJjSsudi8Wlv9p50ebuY9Kn4abRahvnzOT6YDges1qNorKczWM39x9NGeSYZc0HtKUpE7bKI+MN24Qik+UVK0OK4YTEd82aGkdnVnOS/x6lyHzZKu0hfpkH1FHLZTPmEuTB/YZb0b67BBc6ZwqZco0S8+osWyL9SGJYKt/rbnVYqtOLI0sbg6PNp6kj0ELTWQCb//oeDECsXt951xRDqOYEONEh+ySDwKhz+LUQ2+K7yxuLQdmrte62jjp+rvPysNCR6JUUOTcdTE6bj3mPxYSzJxsM2era1lRX0T0FLxMzJflwfE5T52mVjydKPI4hmy/rWM/sskLiNua2zdzPkyTZbL1yseX8igEyCGMa4DHjlvuNU6KDYufcXjhe3B2f4UidPFgLPFmIUNx4+FgxUuedV067a5RdNY0AfiW4m+UUOZUb
 e7ZqP5bA
 oLQyfrrxwFBuNx/+6MUokmM1Zk+iMEGIkOYtKR5kEMJliIbiAOSrP/Jp0msr0MxU2ma0/7eLJ6hPwe+xwT+XPHJxlmmCNR82JWDL/bxuvt3U7pypKsXPaXls5H/mifPLoRUDpS1QTp5FIrAATMyfbUfZ5ple6qmnPWx24GxFuEoORM4Mrfkr0UPS2drUYvJQHR3RTaZvR4qV629VlpXAsr4Op9YIeptrf/xGo8a6ObF69ZJ7V37+BM1NpDE+KsMKBL6LiGjxtxkDhjpyW/zL63mKQpH6mR2qMoirB/DKX5yrBa04qCOZBtgYUE4yrF/cPcT20L5gYQ7y3HKW+D1+e2iib0sza9T9WcsLrcqv/lVSxI3e1uNsGQn3ixM7HXZOGLvjfk8BZYU33hwIelql7ONcmQMFITRHGVAtFTCu/HozAnEJkKlcQd+lVoQGnPMp8GCKxD5Y2Vxs7Fx90RdfhNrZGL8HmXnwLyicbA1c7tp6rKac=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the mTHP (multi-size THP) statistics infrastructure to support
PUD-sized transparent huge pages.

The mTHP framework tracks statistics for each supported THP size through
per-order counters exposed via sysfs. To add PUD THP support, PUD_ORDER
must be included in the set of tracked orders.

With this change, PUD THP events (allocations, faults, splits, swaps)
are tracked and exposed through the existing sysfs interface at
/sys/kernel/mm/transparent_hugepage/hugepages-1048576kB/stats/. This
provides visibility into PUD THP behavior for debugging and performance
analysis.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 include/linux/huge_mm.h | 42 +++++++++++++++++++++++++++++++++++++----
 mm/huge_memory.c        |  3 ++-
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index e672e45bb9cc7..5509ba8555b6e 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -76,7 +76,13 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
  * and including PMD_ORDER, except order-0 (which is not "huge") and order-1
  * (which is a limitation of the THP implementation).
  */
-#define THP_ORDERS_ALL_ANON	((BIT(PMD_ORDER + 1) - 1) & ~(BIT(0) | BIT(1)))
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+#define THP_ORDERS_ALL_ANON_PUD		BIT(PUD_ORDER)
+#else
+#define THP_ORDERS_ALL_ANON_PUD		0
+#endif
+#define THP_ORDERS_ALL_ANON	(((BIT(PMD_ORDER + 1) - 1) & ~(BIT(0) | BIT(1))) | \
+				 THP_ORDERS_ALL_ANON_PUD)
 
 /*
  * Mask of all large folio orders supported for file THP. Folios in a DAX
@@ -146,18 +152,46 @@ enum mthp_stat_item {
 };
 
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SYSFS)
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+#define MTHP_STAT_COUNT		(PMD_ORDER + 2)
+#define MTHP_STAT_PUD_INDEX	(PMD_ORDER + 1)  /* PUD uses last index */
+#else
+#define MTHP_STAT_COUNT		(PMD_ORDER + 1)
+#endif
+
 struct mthp_stat {
-	unsigned long stats[ilog2(MAX_PTRS_PER_PTE) + 1][__MTHP_STAT_COUNT];
+	unsigned long stats[MTHP_STAT_COUNT][__MTHP_STAT_COUNT];
 };
 
 DECLARE_PER_CPU(struct mthp_stat, mthp_stats);
 
+static inline int mthp_stat_order_to_index(int order)
+{
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+	if (order == PUD_ORDER)
+		return MTHP_STAT_PUD_INDEX;
+#endif
+	return order;
+}
+
 static inline void mod_mthp_stat(int order, enum mthp_stat_item item, int delta)
 {
-	if (order <= 0 || order > PMD_ORDER)
+	int index;
+
+	if (order <= 0)
+		return;
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+	if (order != PUD_ORDER && order > PMD_ORDER)
 		return;
+#else
+	if (order > PMD_ORDER)
+		return;
+#endif
 
-	this_cpu_add(mthp_stats.stats[order][item], delta);
+	index = mthp_stat_order_to_index(order);
+	this_cpu_add(mthp_stats.stats[index][item], delta);
 }
 
 static inline void count_mthp_stat(int order, enum mthp_stat_item item)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3128b3beedb0a..d033624d7e1f2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -598,11 +598,12 @@ static unsigned long sum_mthp_stat(int order, enum mthp_stat_item item)
 {
 	unsigned long sum = 0;
 	int cpu;
+	int index = mthp_stat_order_to_index(order);
 
 	for_each_possible_cpu(cpu) {
 		struct mthp_stat *this = &per_cpu(mthp_stats, cpu);
 
-		sum += this->stats[order][item];
+		sum += this->stats[index][item];
 	}
 
 	return sum;
-- 
2.47.3


