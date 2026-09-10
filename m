Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB931C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B4B6B00A5; Thu, 10 Sep 2026 02:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021396B00A6; Thu, 10 Sep 2026 02:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2AD56B00A7; Thu, 10 Sep 2026 02:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB87B6B00A5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:34:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D3EA120423
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:00 +0000 (UTC)
X-FDA: 85196887440.12.431C946
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id D7BCD180007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QBB5S24I;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsqJXB+7FTTz0HgjrZ7vjc10S/x3pwFsj1u1bd3Xfng=;
	b=AHH1l8M+BSyyO6SWGHTYX7Hmm3w4l3vlBuQ0XKymvy/ijoqKZHrrqDBLgexB3sekYRKjkx
	GntYlXwglW2qq3VrHtEHMyc11P9pHrjJ+QhYUCiF6xOYBj2jw0+L5sGaAx19uP++7rqJS5
	HGHGa3TVzlOyTeU3jEuFi58i6tuI6Ms=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QBB5S24I;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022038;
	b=eqG6VirQTWWctCA04nrdoJmJ849EgukI05WWq0KBArDjEJvIy5fAIFnoqmqJQNWS2fU1D7
	gtRvYTpgd8QwJryRstuG3R/KuHGvzDqEA/X1VOov4+0IjPlgmA5iwDvht9zIhT20XIpdSP
	ux22V6D3JaTGCHZoDugWEORFxQ0ynKM=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38e42560ebcso5205355a91.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022037; x=1789626837; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BsqJXB+7FTTz0HgjrZ7vjc10S/x3pwFsj1u1bd3Xfng=;
        b=QBB5S24IqoUWs5MRJqMkfrD1e/6Q/Q+QGWXAvwFuUlvsyarCCeLY8ZuwPzauOh9lI9
         CJ/TDcCMK+YQUxZOZLHQXZkmVIRtIUpkIy8luM2ORnEHsUH7kIj7RFgSUU9xrW170TR5
         f/8E/UHbNFu3i2IGHHQLwQnijAQCv+NETR8nhgiZ14dMfjv5AVBiCjPXhYK6NztWgw4b
         BphcUFTgp2KhmXE8TnmG4eYM3TVExxQ8RBn6fznhX30lLfhjWy7OPx//QGxNx1dncQvH
         CchjMiDF3jIoLpVzlj3oAhBg1moNeDBHpXBeXzSvW3aF/lhcaVwk1pL3QtI+L+KNVKdr
         QvZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022037; x=1789626837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BsqJXB+7FTTz0HgjrZ7vjc10S/x3pwFsj1u1bd3Xfng=;
        b=JDFTtUXUJyxebakHU/A448gLVToe/uG7KfezCTEZtgyce38JEwHHxk1lUTfwif52To
         Jt+qOYlK6taK6V9OlDKkxhHVpfw7OFdrY5gLrH53h2zJDzyuTYC450dnZom7GLtgNsdU
         1fkLgidKzdQ5kj5jCnsqyx/WZOfEkUztfRyI393+FFWTGmvMnjOCLgeiiJ85NJg2sXOj
         lit1livmLM0gjxZRiHjYRP7TX0Gvkw3sg/9jpdZHAq6b70//PH8ZeBNGQ8ZhNldhpLEe
         PSS4+H7FGfpqxRG8GHj8WHCqvzXt55v1B9O/eegsqupffDL/Ph0LR+RUnxNd0ua2MG+2
         AusA==
X-Forwarded-Encrypted: i=1; AKwUvBy13YNzGhgsp+1uTF80zL8W+AJgmlpQs3+S0P2v1l8WIFRSgCwNgQxjEt6jd8a6QSFhxNU6QOBRqA==@kvack.org
X-Gm-Message-State: AFuF++liRi9FkHeodq09HJju3RlWl4P1lvpPWfC41+6o0UeGN/WVCD8b
	J9/HmLCnVm+69+lz8/SaHDJeU+kh6Z6LVRKUOwF/nt4/JPIT/GEwkzGM4YVtY8lIqgc=
X-Gm-Gg: AYBFou2CPemmfJicipD5kzW9A69h4fAMsyywSIogcavLGTs8xZ7d+DxBaWG/a2vjR5R
	UQd/FtJV4HjCIflP1BO6YKUEBbdi0N3noaUsxhCWavso0itzbKMHtUdMTER0kaL3xFIT78rUAN2
	D0x/8d4j34Yx1f43r0H6XCV3oqPNaV3ReSpWdDqHkGNNKQ8l77Q6jDpeBsfxWEKMx2b3M9noI5k
	eAwybfFLCw7iVkx+P5IR8e9PgcKtMsKoly6I/+djNehe8DZm8ZECJQgzuPySUOeIBqy+OD2LvJl
	dX/9qtpxoGu5gqMbtfD4REjMWJFsVcgmf2CtQTGCJXxdpiZz1dFYcgr+z+1Z0SwgsEtwhTU3P2I
	nZT0VivVOfl4iBmgd+Vz27NVJS8a/ZMvy/VhsZWWnoxlkUAMd+902GT3XM551TcqLjY1QwkOUaD
	VI80fRq0HZQjIoRt+GOub8PN0HJ8aZP4BSKbWY7XEMTuo1RVEVl7vUCj1n2aiRp6P4rBuEptTi+
	CvIZ7HJ0MpCR3Q+WMr2OBOP94HJXCHqthM=
X-Received: by 2002:a17:90a:616:b0:39d:8222:6436 with SMTP id 98e67ed59e1d1-39d82226893mr1803358a91.7.1789022036378;
        Wed, 09 Sep 2026 23:33:56 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.33.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:33:55 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v6 09/17] mm/sparse: initialize memory sections earlier
Date: Thu, 10 Sep 2026 14:32:48 +0800
Message-ID: <20260910063256.64386-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7BCD180007
X-Stat-Signature: njcakqqkt5weuuq1xo4rd7kwozn7qd5m
X-Rspam-User: 
X-HE-Tag: 1789022037-734715
X-HE-Meta: U2FsdGVkX1/VdN0TxmcNDDD1g07axBIPCJ8fMZAdct/sOCToplT6mpUH+Bw5bRxF4J3ZCrQ67pl202KOk7QnbsUebSqgx9xpIOniipK4hkEpxhIO7//4X+45I7uTHpw86fH9K5iBLgfwfW85XP40SChEvuh+Teb0X4YF2zevoLSJmjD92/iSZkcQNpDNvvsEgS6qx0klvkbarbPiZK5YVv/bh9cIgSK6rSyUyqFSj7LxEZRfllWERRupURmgRINPbxosfkw5cDi5Tv12chlK4+CDmH22zF0h+gPqDM2JYPA0b8bK2Me3FLaCjUZ9fTx+w1sXycA7j22yijRSDj74M3klRjgCmZ8M39kQ0kr+BTB0q2aWXwP1DUBmzZF03dDIhxFKal/DlCZpXgfsDj3BSCrM8o7ilUNZppk/9/U4/EHzqClDbibzkvD2nlZ+w8hNxw+/PE2VbWbKceka48jrfdPR5WBXjQJXzDhZh2oB7IXMXqKHTZe2+pWHPVcQNRlfFxone594Gt3tRCsQtszpswxRpgu0riPcQ8flhnII8b3QaaGrrSXfIUHvD9i8w1t3edLtU6aYE800G5TDrdmkJMUBzxDd0ngdNz3/umFtQDmO7am5ggZV5DRLhQL1zcjEBRgmmlzOaYM6AtLos88Hlw8p3slNifwRojzQK8EA4DTrQx8RoGxsz6R6exMceGyMoT4NnqzBPV/cAx2dEL89uhZrhxr10wqJZIBGIJWtMlBajwpY/gIgjbYDqdfWRULOmt3qSPvU22smy2NCXP6WRZ+0GwkRTcx0m5FIYEjlT4osFYg9JxE5l+yfZXBECImQbQzYssCTYYb/qWkVQDPZHFQPc6F9+3Sx2WfLpagS6pto7q59ZDFsLSqi9k1mclUASoomD5Qvpg4PuECRTJrFYLgpUktmGRfDrbBreLM7ez3a43H/zZopRsdARPX+66iYrEFgNi1wFLtEvx9JL4V
 HqBLPHFh
 tlxpjo85ijxBzmIqL8oYerYf0jQpGWMq146ETaHvJQp6KuRKP9IJEtGwufm745EmsvHZbBPSG/bNqo3Ad+Oq0HqnXpNnUwMkBSAaGyiYZvolEeYxmoTelQeL/Z7pB18pM29YZ9fa8/swsipXhcEIC1dYSVaFB2gocYS9LrHnvP9xAjotpRZWbjcNGj2PDGkR+ry3QPqSFURr7QUbvmd8QGO7CLd0vPVEaIfH0FNJ4pBeuopF//WB7gVJ+cMflF+VTN3FIJ2hHZcqcDFbWkjMRoTqUaQBk8i37m9HaAo3+0uWTXPbBjICIa80l77awkam4920jKJWAFNvQdXG6ypkCuLQyG0S2gYaUhorsukc+TZf1tNwuU6Piz+fxN02nYVak4P1Z2EOV6jGjjUPqzM95cpUH8Z3eByGjRcjY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Upcoming HugeTLB bootmem changes need sparsemem section metadata before
the HugeTLB bootmem allocation path runs. The memory sections are
initialized from sparse_init(), which is called too late for that setup.

Move the code that initializes sparsemem section metadata for memblock
ranges into mm_core_init_early(), before free_area_init() and the HugeTLB
bootmem setup. Rename the helper to sparse_sections_init() so the new
caller describes the sparsemem-specific initialization step.

This is a preparatory change.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Drop the inaccurate sparse_sections_init() comment
  (suggested by David Hildenbrand)
- Collect Acked-by from Qi Zheng

v5:
- Collect Reviewed-by from Mike Rapoport

v2:
- Rename the helper to sparse_sections_init() to describe the section
  metadata initialization (suggested by Mike Rapoport)
- Fix the !SPARSEMEM stub name so SPARSEMEM=n builds compile
  (reported by Sashiko)
---
 mm/mm_init.c | 1 +
 mm/sparse.c  | 9 +--------
 mm/sparse.h  | 2 ++
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index ee3bd7921768..304c88da5cce 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2642,6 +2642,7 @@ void __init mm_core_init_early(void)
 {
 	kho_memory_init_early();
 
+	sparse_sections_init();
 	free_area_init();
 
 	hugetlb_cma_reserve();
diff --git a/mm/sparse.c b/mm/sparse.c
index e6cb67ca9c8d..428d81838ece 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -191,12 +191,7 @@ static void __init memory_present(int nid, unsigned long start, unsigned long en
 	}
 }
 
-/*
- * Mark all memblocks as present using memory_present().
- * This is a convenience function that is useful to mark all of the systems
- * memory as present during initialization.
- */
-static void __init memblocks_present(void)
+void __init sparse_sections_init(void)
 {
 	unsigned long start, end;
 	int i, nid;
@@ -322,8 +317,6 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	memblocks_present();
-
 	if (compound_info_has_mask()) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
 				    MAX_FOLIO_VMEMMAP_ALIGN));
diff --git a/mm/sparse.h b/mm/sparse.h
index 74dd79c51e75..e998347867f4 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -59,6 +59,7 @@ static inline bool vmemmap_optimizable_order(unsigned int order)
  */
 #ifdef CONFIG_SPARSEMEM
 void sparse_init(void);
+void sparse_sections_init(void);
 int sparse_index_init(unsigned long section_nr, int nid);
 
 static inline void sparse_init_one_section(struct mem_section *ms,
@@ -104,6 +105,7 @@ static inline bool section_vmemmap_optimizable(const struct mem_section *ms)
 }
 #else
 static inline void sparse_init(void) {}
+static inline void sparse_sections_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
 
 /*
-- 
2.54.0


