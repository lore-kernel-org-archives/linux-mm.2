Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6ECC606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ihNaqVgL
Received: by kanga.kvack.org (Postfix)
	id 6C5776B05CB; Tue,  3 Nov 2026 16:20:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629286B05CC; Tue,  3 Nov 2026 16:20:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F14F6B05CD; Tue,  3 Nov 2026 16:20:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0A66B05CB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:20:47 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 838971C3DA5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:20:46 +0000 (UTC)
X-FDA: 85395077292.12.B8027D4
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id B696FA0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:20:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ihNaqVgL;
	spf=pass (imf15.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740844;
	b=4K7x6lpmVtA6vicfts5wBj1l/UJf5qT6RU7JDagLkd8BiOvYrvBcl/8V6WXV5vwfjk+K0N
	N1uGfNzvgG4mKAyl+9WSmZt9dA+SUy2yq3M1a+/3Askp/dlqY8ycCSw396SrztrvmZtpG0
	7BQnKR0nDF1vkxsoGa7fi2mVpFHIAD4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4pOPE5A6jUDaK6xa2dQrzrV/Yk3MC89JG2gVzXYdWLY=;
	b=zAg+J4U+7u52fq5ogKxlXn+AKZiWL4/J6eUAAqDkO1trL1XRvxk5kcGiKePTc//WktAoR/
	sZqWzzdxauXMQa9E29Nu3I7dyyc1UmGRsKsbfyMj6xe+5QIPSiOxi6u629PeRCpCkQxate
	CEwgBufyEdMG0D9UustlDlqYkgJHRpM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ihNaqVgL;
	spf=pass (imf15.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cdaefe02d5dso41929a12.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 13:20:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793740843; x=1794345643; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4pOPE5A6jUDaK6xa2dQrzrV/Yk3MC89JG2gVzXYdWLY=;
        b=ihNaqVgLddO4IA1fwiea69Ae0x+r0kn3XNHHfbiRMd+rqvY7i8/uzJsi7rt2XXQAXa
         bYdF6HfEmWbLJ1aJq/kplk+eau14IpHkFEGJ03Bu+QHNZc+4BvRr3PmGOKB2knJ2BZqH
         X6NDLhIkYjOIc0PwcTsBS9EPsMSmGCsQsVHiCJliYQPuQdfsRO2Xb1+plu/AcvEfhKwQ
         kLBJFsmSjo6kV/Q76yR+9P7Dmeuxx+/0LFq81mO06wlhwWw1mzQrm7RfLc4zg3wfcBrb
         f3mruwl/i9S2cCQ+cGjRo35C4eIiRVgX6opS916F6y5D//CCclHmzkg+p6JuFQOQU42l
         A06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740843; x=1794345643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4pOPE5A6jUDaK6xa2dQrzrV/Yk3MC89JG2gVzXYdWLY=;
        b=SwgLVd5PqM8ndddL9QRBH9KdHGAO2kae6aM4WIxOf3qxmuXIP1OL93OK2dpqO96hn0
         69LJNoSncQkf3u4xMx0nvF0IIaeKoTRYMV5kUqXYlYum3RnlaWZ/0xNUGHNCTvI8XE8W
         d6YeU0d9++Y+GIPMzbeuT+5LEL8opNzLnXPpWOaMJ+uwaQ2y5S4FcTEwgHmPGPcLCfCe
         e19Vt1qH3ExW8MtFTJi/F3flNNO2gSeLnYkd+SyZo5863RMwcjjfoHvjK5azFKWt3L9I
         j7Pc8Tb/n5VR8BIItM1g4GCZvpI6TaY9L/ZyK5T2grDt9xEVmM668LbT/CWIikOiYga5
         X9TA==
X-Forwarded-Encrypted: i=1; AKwUvBwUd7xlh2wx9jOa9R1h1dm4nBr7TBJbiC2W2DN0EBAYUz+HYlEIRKTUBWJu7VTKeavwvP8hPpdClA==@kvack.org
X-Gm-Message-State: APuU4Z8bFcJR7TUCh7nY5l7kyyikoyEg9bX+J/AkdfXDRwBBfS5C9sQQ
	tlkV/ejX0QOxK3DAVT12M6bRAk3NL/aQ7CDkRT6ByNz4/lD8+BMH6cZm
X-Gm-Gg: AYBFou0RKLUuasyCOeXWvKsrqzlLertr/PRW5RpLo/DlaRmLMEcIpuozrDB4Ms180rG
	adUnnoJkfHAuwyU5aNQPcrT7fjGQh5VNdgQ1RcyAJWKLt4uOvjnwIEuEXQ2RJ9mZiOOKczVREiD
	ipT9Vb7G9uk6xVsmSA8f36nmfzce/AX/v66wx2ck/vpoKwX7Cdo4OwcoJI8CkBItukgEcMw50U4
	CAGJ4rlOckZpW54NGGpCpX00e2e6eNUFaYkXgc6OrHmNB3vkgqtr4iQDVNAgVhZCu+zqVzV60a+
	J867Ve1FDWrY2/OtoZCkZ9LJJG6lbZANI8Rh/GyaepyBAJywbqI9smdYYpOWe24aW91ZG4MvTHG
	y4mgqMyC4HKES6Lp+LmA6/X7W4RUoi3SqB9YMML9t7U79ca5nl8kW82Cud0tSbn5oRUDDNTFqD0
	arWU6r0p50MJFW1+F23xnMRbplLppgAiXiM5DrWQzOMTQ6lBle9wjFuOujEjIygpd5kbls2M32h
	BtOJ51K9APoa0YCS80wZt1Jnj4GRORZ7PM1i7n2yQ1FM0NHgNAP+iY4fyllyZfCDRmKcK3kUX2r
	Ep88L3/rJ8hP0lr3V1DT/GQahzVQjZ1ZpQ5mdK+M8WSaFO7FinwMUTeypPyUFwWk/ZeLhFHzCUK
	gvi/C1cLZ7tVjl1AfUAvpZKI6bKo=
X-Received: by 2002:a17:90b:5111:b0:3ab:3384:1a44 with SMTP id 98e67ed59e1d1-3ae897c64b4mr11082684a91.12.1793740843551;
        Tue, 03 Nov 2026 13:20:43 -0800 (PST)
Received: from localhost ([2a03:2880:ff:44::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0944ea360sm712904a91.14.2026.11.03.13.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 13:20:42 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: baohua@kernel.org,
	usama.arif@linux.dev,
	hannes@cmpxchg.org,
	kas@kernel.org,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v4 3/4] mm/huge_memory: add a per-order counter for underused splits
Date: Tue,  3 Nov 2026 13:20:03 -0800
Message-ID: <20261103212004.1356327-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103212004.1356327-1-joannelkoong@gmail.com>
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: fdo15w9caoaa8f49xs7c5uiq1uomimdk
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B696FA0005
X-HE-Tag: 1793740844-978301
X-HE-Meta: U2FsdGVkX18VeNubZoZlWYvZIPtJvH/xM5Dy/K5Ij7VX9+kd9cYYzxALrmyxZqH1Jwx417Z2h/Ca/xUDSjZJ6JjBOKeYqeA3pTHPTXL0O0zVr35iKqbskUTUa98JPi13WrsfLgB7+xOGffoR1cwRkQsKb5HBB49k1QsOcxlC2eMqcrUYMcq+Udc9TSvccZ2rpJW+IUWyQfllPeIVVe/J8lH2emudy1XdNiKl4RSbPT+AWwBLBqgLx+B39gg03GnVe3v5xH84dcKeTKAiXj5XnWMsSY+ANEmaNd3CSq5WoDGcmhxB4LNeb14rEUAvAEslIj+TsxqoLxzXJri5Vjud/NUdJ+lSQkEJN5R75MVDv76v0dVTAwbeY+yxfcf6fNgHY0WCtLNBO+8NFkJeiRjttaQFXKCgpn9y4e3nspqfPbxw5cMxLyHXPg2daZux7dH+UBJDnBdcxoWjHkT/mYlajW/4pEO1mDqlJEOwmJ50XTn3XZjDWRszptUCwUo0wqD9HyxRME16esIZD5xFGXEYjDqDG1uQgrj/KBSiku/k8YQ7ZeWLKJSPn/WyqlD+WHXOTa+lPazPZ4tT1xZmm1zOZNxaFMCI5IEYfxg8synlkGZX7lk2UW2D1Gtpkxb6r5oPwdX6v1OYN4XlEbes+q2azSyzGxmczAPNBFw/OQHi7RvgKKF5/OpSs6LAV9cQku3V79tSXZCUlecuzgIkGw/+YBlzm6xGtL+aCeP/UPUkJcNg80qx9KSLC3Oec9mzZpazg3zf++EBfkrtVwL1UGpfdWNvGLrZ2E8nd+BX5HuHV6aFifMkuSgBk/O/K8jpIgfROOSiJp6uiINs20kSet/ZrPUncPtEg/8zZoj+e0frC6ePptbRcc2ZtMxrqrunpdKJHOJJjUMbF6nllGvi9RwGuRrU4Umozsptvankir12D3CGnDjLlrYvkCjsCW5VTvxDrDX4uVqU5MFyOMNkbJh
 a/t/CX1Q
 nbrw2E9+2TBbB07zk5rGQb1Ta8B+IWCkmAxWJj9GjuLlZOirZBiWnUScpbRqott7nMp49dZTRR/obrtZ6E0upqMWi4sfuYj+X4ppTYYiV8xrbcTWXWkzwQxoZKqg1ECsQydTLYO9D8H1lnpAjkaS3TgWgV4Yy0enNPL9qzjfWP00o8t7Jevf+b1C/2RhHeLRLGXy6vdBuyBYNdLXnBTlPB4eiWDfHozDychWH3Hc/n2tVvDe3uUjNBBmADqxGT1wl0V9aRAlFbX/KwQRCLszPweQi0shozSKhNVuDVhrMJYsWyvSfQ3UcEKiVGubp2Le8gl0ZQHeTTt43CCr/c4HZJYUwFovy5LjiomOz8RWdLu55iuBU1UuMedQQxWIpCyLboJ7qdy2mTp9hc9WuftxiNYn/qSieyAr0fH5Hnbxg6KKPFDif/PvPH5pOGkXpubF1wHiox2lil/NPX62XeNQoQi9nxF4rn9pXpd9MmGwi9WxnnPzTE+V1UjkRnkouVlHXuXQCL5wF65cW04SHyyrebHeb3hB4+r7iSvt+w2cJTsy9LA4gh646F7LthBfDeSACBEjvCdDisVRLEuKiYoBgzDrO2AzIdP3V6sTAf6jQAEXPYLe46af36Zr8jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

thp_underused_split_page counts every folio that the deferred split
shrinker splits for being underused. Today that is only ever a
PMD-sized folio, but a later patch queues anonymous mTHP folios for
underused splitting too, at which point this counter would start
counting mTHP splits as well.

thp_underused_split_page could then end up larger than thp_split_page,
and there would be no per-order count of underused splits. That doesn't
match how the other THP split stats work. In /proc/vmstat,
thp_split_page and thp_deferred_split_page only count PMD-sized folios.
Splits of every size, PMD included, are counted per order in the split
and split_deferred stats under hugepages-<size>/stats/.

Do the same for underused splits. Only count PMD-sized folios in
thp_underused_split_page, and add a per-order split_underused stat that
counts underused splits of every size. The folio's order has to be read
before splitting it, since the folio is no longer large once the split
succeeds.

There is no functional change to thp_underused_split_page yet, as only
PMD-sized folios are split for being underused today.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 Documentation/admin-guide/mm/transhuge.rst |  6 ++++++
 include/linux/huge_mm.h                    |  1 +
 mm/huge_memory.c                           | 10 ++++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index b187d618452f..6f2d92a2a556 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -719,6 +719,12 @@ split_deferred
         it would free up some memory. Pages on split queue are going to
         be split under memory pressure, if splitting is possible.
 
+split_underused
+	is incremented when a huge page on the split queue was split
+	because it was underused. This happens when the number of zero-filled
+	pages in the huge page is above a certain threshold scaled from
+	/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none.
+
 nr_anon
        the number of anonymous THP we have in the whole system. These THPs
        might be currently entirely mapped or have partially unmapped/unused
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c745f7ad2298..421217aca4ed 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -142,6 +142,7 @@ enum mthp_stat_item {
 	MTHP_STAT_SPLIT,
 	MTHP_STAT_SPLIT_FAILED,
 	MTHP_STAT_SPLIT_DEFERRED,
+	MTHP_STAT_SPLIT_UNDERUSED,
 	MTHP_STAT_NR_ANON,
 	MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
 	MTHP_STAT_COLLAPSE_EXCEED_SWAP,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 903bbe972011..8f90fb609e57 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -822,6 +822,7 @@ DEFINE_MTHP_STAT_ATTR(shmem_fallback_charge, MTHP_STAT_SHMEM_FALLBACK_CHARGE);
 DEFINE_MTHP_STAT_ATTR(split, MTHP_STAT_SPLIT);
 DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
 DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
+DEFINE_MTHP_STAT_ATTR(split_underused, MTHP_STAT_SPLIT_UNDERUSED);
 DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
 DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
 DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
@@ -842,6 +843,7 @@ static struct attribute *anon_stats_attrs[] = {
 	&swpout_fallback_attr.attr,
 #endif
 	&split_deferred_attr.attr,
+	&split_underused_attr.attr,
 	&nr_anon_attr.attr,
 	&nr_anon_partially_mapped_attr.attr,
 	&collapse_exceed_swap_pte_attr.attr,
@@ -4703,6 +4705,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 					    deferred_split_isolate, &dispose);
 
 	list_for_each_entry_safe(folio, next, &dispose, _deferred_list) {
+		const unsigned int order = folio_order(folio);
 		bool did_split = false;
 		bool underused = false;
 
@@ -4724,8 +4727,11 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 			goto requeue;
 		if (!split_folio(folio)) {
 			did_split = true;
-			if (underused)
-				count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
+			if (underused) {
+				if (is_pmd_order(order))
+					count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
+				count_mthp_stat(order, MTHP_STAT_SPLIT_UNDERUSED);
+			}
 			split++;
 		}
 		folio_unlock(folio);
-- 
2.52.0


