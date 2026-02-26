Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA082FCE076
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E976B020E; Thu, 26 Feb 2026 14:29:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739056B020F; Thu, 26 Feb 2026 14:29:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B866B0213; Thu, 26 Feb 2026 14:29:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 365656B020E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:29:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AABEB6540
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:55 +0000 (UTC)
X-FDA: 84487597950.20.FED00C4
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 51B21A000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UEsf15Pg;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772134193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPksRk4LAnsoFLQrd4UcyaPDU9XJzdmOlJT+foKyitQ=;
	b=CAoUXZCC/oh1t5quREuntzyuMpo4JRNV/oziX1WrcDE4bsln0oqzQSB/lJ7AuEfrp+a4L8
	xsA2pTD19jETTp0SzrheHpQlu99VczNttR/gUBLKXyBh/j4atJAed6WyjZ6VtryTGU+lhy
	UAJ+4KZmHYrbuvxB2/a4RFgwOTUyES8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UEsf15Pg;
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772134193; a=rsa-sha256;
	cv=none;
	b=Og8mJFBic5bGWfkDd18H+gWhKrcUQ7LlZHRJ5wdEI0SzmkZY3uf4QMmvoXa8rt59Fw8RJ/
	zgyoXI9AV5J0Px+4pTduujnkHO/mVE5EZqHXLiyUonNDOwvG0TiZUoacg8ttF0/+BqWW1T
	m+Sl+uITmKavtYmFOk2L8G5taIG6My4=
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-45f126d47b8so1010673b6e.2
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772134192; x=1772738992; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qPksRk4LAnsoFLQrd4UcyaPDU9XJzdmOlJT+foKyitQ=;
        b=UEsf15PgyPELV9Sn87ucFA4lblmcV3BrHZ5aIgIK/iVezQs1gWMxV2BXvrKs5reOeh
         i6TH4RWTOiwf+XRjAdWX6UXIUrmgqZP/ypwEdbYFjUvTdN6ReBkdS/WYt3V6HeYR7xRq
         fwU3UXUjBKjjdDt0tG2EmrH4HN8y3UhVtZrRioHd35J4rbbEKpuSARjD+b9nzRcQsX1o
         kPQ480g/hqEyC7am3j2Cuo5PQp9C4tUxmfJJtLOEHLEk4oNnD4tCvI6kAFW9sqY+zm0r
         nEjpb78/2VooAYH6Y/yuEZBO0Vxo+4pNtgSnaYD4FmS4+SXYoRw1+OcWLIA5uL1zXwFF
         Mrbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772134192; x=1772738992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qPksRk4LAnsoFLQrd4UcyaPDU9XJzdmOlJT+foKyitQ=;
        b=EPp/BbKKr6fWMar6MEfLrJNcH/BH13+dD3h9tGVwc9vfuiZyQOHGnKGC6eSJXoPXA0
         YNxTRpmEB3+nMqxq3XaExPDaCn4pf2iDKQBSiNBDjp9y8OT7aK6Yn/UamWG7KHJEwXkq
         w4CnXmLyX+Irnp35b0rbuquatu9XvtiGwe8FodWB/Lb1yPKWxVuFaNk2T0FZbjF9YOO2
         +WOd7iNRliJlFRnzykgLWn1zLkNKieZZufSZolGlup+jpP4dCjXiBCmYmeggkQAjmaY2
         uus/8ePOfipq4kKEy++AeRPM79jly+nJgeO1NeRoG2vSnb+dBav6Om4iTMx/AeTGTPVA
         g3Fw==
X-Forwarded-Encrypted: i=1; AJvYcCWxEY0Tdj86y/JNv2qHYv3Ol/SSC1xJQY+O6NL74rxOIjFVtAvvCXzNv1jKh6ME9OngAMp3lUmTrw==@kvack.org
X-Gm-Message-State: AOJu0YxnGjeaRD5e0CUSWXJPAILxNcwmr67xIgn6c+znENpkRrNA/RR+
	0LAOhuI+mB29KfKjHXoXE7sM8++kUBSRPXUYl8Z0pvsyKRwacAseKF2x
X-Gm-Gg: ATEYQzx6zwAomaz1JI3ZLmYQOGWVvMqgCpap/1RNHx/2aW/WUZY2A2aKTZWLDMCSV32
	fwbkv4y9O4gjtei90fKkySBkQVL9ONbjybonhsPcL6FJhyc9fv8fco4Rz1K9GUGuKBtRNGXEOcZ
	/hLeC6mK/7H+ALqdbMxudcCnDt47Ji8V4zzH5zYvev9ZFlV2ucNO/GIGKpTnRj7r3LWGBW/Mdcx
	5jdwqXrbuWuq6ogc8iTNL9Wn+eA8JEJ4Tbpm6KGv+tpvHD9nHQYL9psrlXSAbujrkPOMGIDFzB8
	b4khUi5lpipQrsnCSmRguAQLC3KtGZhPXVe/yke/MPhCdS4CYLGkQ7RZy1ux3XbEYafWjD5mYyG
	Q8VnhgEi0J+ni0UG9tsLimAgUuK+eLfjxZv4EIgMGa1fLTK5DmfimripHI4YNZ9FhJO49jsiu1a
	NbNrgcrKHm+9pcEuDGyCUO8Q==
X-Received: by 2002:a05:6808:4707:b0:45e:f0ae:bc0f with SMTP id 5614622812f47-464be9cbef3mr147302b6e.23.1772134192235;
        Thu, 26 Feb 2026 11:29:52 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:59::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160cf9b24dsm2713097fac.7.2026.02.26.11.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 11:29:50 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 7/8] mm/memcontrol: Track MEMCG_ZSWAPPED in bytes
Date: Thu, 26 Feb 2026 11:29:30 -0800
Message-ID: <20260226192936.3190275-8-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
References: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1nt6bx37h9ww4u9ex7j3m5hew5rz7n3h
X-Rspamd-Queue-Id: 51B21A000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1772134193-76892
X-HE-Meta: U2FsdGVkX19eZqiHyd9OxgdGeIX4ts5GBPzcmWE+Zbtr+33OrZDcDfTHllOcJxpMRoqORHJosYX2Zs+9c2qoOiagMs1EmYewRNsYzhFcvk4ODcsUezjYTBEz8K/M8TWJ+pR6QCMAfpyJRbsfoP0EgJo01BJYk5ZK2t+QV9/CfwHI4Li1UZyP+Kjl92KSzFp2AlGLbPtL1Ncdgm0RDgFGw+/8FmL8KdRGp7DtnrJEF2o8Xx58pZGfIYddTATncVZO9uInQigbK8CiKf7wTB0VNXhU9A8C5NmCYZxc93ouyTl4YRgzaGoIi0GfnPPxWabsdWUWdN+IaognbqRpZUmMd7kBSbJm3zEClgxDUi/PHxFtIlOQUGDncH/xG60p1vpmDvvSwrcCsmBc4fSZtF4+A+bnld6RIKqRt2qcefOS5o0YFoVa90q1vSSYlGriDKYt8d1m+cT2SZMvd4McPaIVw9E1dKeDUn6q9C3gyH2gd5l+45Fu5GxhP7ayTint34DxAF0cNjrOPuwFEpGjNroZssiQfzMg+ppVOFv0fzp73kSRlnz2QiptOnjWmPX3nXzFYzlvsD3EQVMtiO2lWKXa2Anw0ddTKmJiRJSlsUO2Dq09Q1F2a3ZgDeCiiOvzDKerzIlvslQEhfxvUDDt7eHkD7hxVx558YUNpYFRrdU0x4FygqtAzquouVZPi+STwk1f0VR3Qw+fHdnWH9zCrfja0uK53KvfJ4cyhJs/ONvgqHERpc6Kn0AQjlwcAJEmiXy4ivauhjtNs8jGtP/Zy4FYrztdwJh2pA8y0Ki1HBz118zkRKsslOly73K8poOE6m6zXj5JUK3CPWj9SU7vwuNPnrpRJROrfAuUt0nrtB7K2P0TJISx7bjZzBfiBfyl0y7HPHmTpNrCQEv6KssWzNJ0yh0xIjVPVqKlvdLV5iJjtuFTQfcsx5mLvgHPjzWzkQOuOpABAToh8kwIohyv293
 rDDAQAaS
 wsu8ZxQEyDs0+60t3m0LUZKM4uRB9/kpm/DbXSS+M5StRDj4Iw1xNs9kLUjuAAZ6fHJVjSMH+nRdNVqNDbpBzwcZZwNKn64j1looAtg3OrtQaiuanYly5or5Zmvgm+F4he6XGmQwLhjEhmCOwLBbRSIMg0ObLeqFHjiw6leKZLrDcAY7maemxNH9+nZwoed1t7N+nAc3ZKDN0qQhLGhmAWjY7/C/njHgB5kcFzpRoJHTHZpur/s14bkGbcRoa+k+I13kVfwKKvzBEx/5u0CSne1hEM64Tk1adxOU/gfi9c7YyyvdZabvzwY18HnIPIE2vezRVkPYPtnyexECXic/L9P5FnCshUWpKuAyBvbfIR/Bn0q3hvSIy0ylEOU+OeWdxnxGuBlouCX2WJDH8Z1OKW5qDuARixWObQ0NmQfim14tmQDCHQ1UaJomA5fWizAPMxof50gVWEUlMXnyhht7Yxse5sFDMVIpNINClckWQBLcGpti1NWf0nCgssQk8JVG+2Gbphvj9vuymXfmsoQjxvHijkpA3cpPFWIBCLOqQJ3r6/HI+gaAYvddzQP5fOvXGY3Xaew/gyzmIUxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zswap compresses and uncompresses in PAGE_SIZE units, which simplifies
the accounting for how much memory it has compressed. However, when a
compressed object is stored at the boundary of two zspages, accounting
at PAGE_SIZE units makes it difficult to fractionally charge each
backing zspage with the ratio of memory it backs for the compressed
object.

To make sub-PAGE_SIZE granularity charging possible for MEMCG_ZSWAPPED,
track the value in bytes and adjust its accounting accordingly.

No functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h | 2 +-
 mm/memcontrol.c            | 5 +++--
 mm/zsmalloc.c              | 4 ++--
 mm/zswap.c                 | 6 ++++--
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index dd4278b1ca35..d3952c918fd4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -38,7 +38,7 @@ enum memcg_stat_item {
 	MEMCG_VMALLOC,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
-	MEMCG_ZSWAPPED,
+	MEMCG_ZSWAPPED_B,
 	MEMCG_NR_STAT,
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3432e1afc037..b662902d4e03 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -340,7 +340,7 @@ static const unsigned int memcg_stat_items[] = {
 	MEMCG_VMALLOC,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
-	MEMCG_ZSWAPPED,
+	MEMCG_ZSWAPPED_B,
 };
 
 #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
@@ -1345,7 +1345,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "shmem",			NR_SHMEM			},
 #ifdef CONFIG_ZSWAP
 	{ "zswap",			MEMCG_ZSWAP_B			},
-	{ "zswapped",			MEMCG_ZSWAPPED			},
+	{ "zswapped",			MEMCG_ZSWAPPED_B		},
 #endif
 	{ "file_mapped",		NR_FILE_MAPPED			},
 	{ "file_dirty",			NR_FILE_DIRTY			},
@@ -1393,6 +1393,7 @@ static int memcg_page_state_unit(int item)
 	switch (item) {
 	case MEMCG_PERCPU_B:
 	case MEMCG_ZSWAP_B:
+	case MEMCG_ZSWAPPED_B:
 	case NR_SLAB_RECLAIMABLE_B:
 	case NR_SLAB_UNRECLAIMABLE_B:
 		return 1;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 88c7cd399261..6794927c60fb 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -980,7 +980,7 @@ static void zs_charge_objcg(struct zpdesc *zpdesc, struct obj_cgroup *objcg,
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
-	mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
+	mod_memcg_state(memcg, MEMCG_ZSWAPPED_B, 1);
 	rcu_read_unlock();
 }
 
@@ -997,7 +997,7 @@ static void zs_uncharge_objcg(struct zpdesc *zpdesc, struct obj_cgroup *objcg,
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	mod_memcg_state(memcg, MEMCG_ZSWAP_B, -size);
-	mod_memcg_state(memcg, MEMCG_ZSWAPPED, -1);
+	mod_memcg_state(memcg, MEMCG_ZSWAPPED_B, -1);
 	rcu_read_unlock();
 }
 
diff --git a/mm/zswap.c b/mm/zswap.c
index 77d3c6516ed3..97f38d0afa86 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1214,8 +1214,10 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	 */
 	if (!mem_cgroup_disabled()) {
 		mem_cgroup_flush_stats(memcg);
-		nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
-		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
+		nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B);
+		nr_backing >>= PAGE_SHIFT;
+		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED_B);
+		nr_stored >>= PAGE_SHIFT;
 	} else {
 		nr_backing = zswap_total_pages();
 		nr_stored = atomic_long_read(&zswap_stored_pages);
-- 
2.47.3


