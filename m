Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B859BC79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69B76B00AC; Thu, 10 Sep 2026 02:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1ABC6B00AD; Thu, 10 Sep 2026 02:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C09F36B00AE; Thu, 10 Sep 2026 02:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 963856B00AC
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:34:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBF528040E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:17 +0000 (UTC)
X-FDA: 85196888154.05.67DF7C3
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id F29A7100007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=M4gyik+n;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ytFcTktewPTS6VkWuTaJ4fUtmqPUIIlqGvc8eyNaYzM=;
	b=2Ju+DLYuPUfKDxTLRsScPCRu/mjHJEwFkQTGBhfuwS4HNRn2JRRQrZx286moqkDelJLRNY
	i4W8lfx66omSdryQ+Kjrh0WnQL0+TWQXSWy1O7Yc3Y1TKuEVzeQZ2vF0x1TwqBIPuotSIF
	VwUEySZrQlUClknL7IliPYQpdkpn4gk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=M4gyik+n;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022056;
	b=pLDRNT3NokNx5Q7iKh2au1uaSsOR9mQMEsZtzF0J2fne0C7xTIkk9KU3IZfb9IH4ceU4xS
	gYvsuNakmsE75ZO932nx2BD2m6Q82w8tl+9NQLUlXqzPiHAbO6FLVCgRq1Qq+bSjEPPihc
	W5wplt00qRsrXTI9SsBWlUNtpyRXiMU=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d6d28aa26cso43788235ad.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022055; x=1789626855; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ytFcTktewPTS6VkWuTaJ4fUtmqPUIIlqGvc8eyNaYzM=;
        b=M4gyik+nfHJYNERW+1rwoNaoIQ9Btjp8Mbmd+tYUmh3jmeb36Nvszag9L7epZyn+BR
         llXNWWXGwyLM/p/Qb3ebjhcrLd9fU6RlG3HN0KtJX1AxjXuKrkAF6Kq84WliBvI4GIcH
         UsMUWuaYhRtVEnZhnlDFmWfqKYeGXrAav0dvcgZ+v1U8BkmMtmLR5WW0CuDZcYQVe7H8
         0l7j7XEmXhRVTeKuNPoZLzN/d3rKICgIGjU4QVDroBNApdKQvcemUdKMyLi0mBNz5Dy9
         ghGSUeTVyr8jJVVYmEPWAioNiFfnF9EI4egBNJsXGrvIi3IFjMPQRHwjor/p0nATV47t
         LZcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022055; x=1789626855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ytFcTktewPTS6VkWuTaJ4fUtmqPUIIlqGvc8eyNaYzM=;
        b=DhC4ZMHJtMb+20X68XPPS58rQSy1nlZvClYIJBOjyk9tIepQSire7KZg11BH1hqEwj
         s8Su2DVOZhSTEoZkmwCH+M0paM3lo+qyJZqXQ2HxXmBnw3IJ1jL3vn+vhMeNxYFjLvZ/
         +iC+VLXoIG8CB3BdnaypCmKXCnJpnecGJcQPms7HHJr7bGOUO/T/IyptFhiuppyemFfA
         64haY3nybEDvnfHVUCsNL7BpuR1+dJfdJJ/KhE/ZS06OAwnjVwsy1ZveGP9eCvAdXIS9
         +LFDWte1Pky+HYFnuRl5qlllI/Fr6cYBi0NgX7puZrVzt9r+Lzv9yZg70DexuUUNvkpu
         IQ3w==
X-Forwarded-Encrypted: i=1; AKwUvBwVUL2GjlaP5p1GdSY5U+peORy/4I55M/T/LNoXGd3t8CSwripF7Zog0zG/yykELAQDrBsFcepf0w==@kvack.org
X-Gm-Message-State: AFuF++mapwAC7/5W9BvTowmlMUG9W/dYqdsMwuiHQWYC7ctBJwAzeh4p
	XY+PFmd3bqBCobI6bPDwkR85BU06KuOzwXWXtdEeAChmLg5ZC1qqDVW6Yu0XJu5KIbk=
X-Gm-Gg: AYBFou0ibXGG2GsppJe1UUCBwv/2tWGjjoMvPRMJJ/RyIji/NMacj6aOi443xPlGn++
	0h2DC/6w32eK/wz8HZVIZVKxM+n3+1IYjfogeuZHl+8pLv/Pqzqgp3hDam3PPE+ARGHvWzDQcTZ
	08lSOg9wF7l+9RC83CE9+9/mPZ2xwCA6r+tYYiuSS09JSDItcqjlzwpUW+X1pvX29yFmjRyfm2f
	wrgai89H+Gmb8MOOtK0MXnq3zmKeDysCZXZSKy5uKCnay7mKmWn/gEUU9x3yDhpqh+lOSyJaY7b
	tLc6EQZsOwMKEJnmKke9zRGIGhMIc3e0mwvQqYpkPJvZgKxkebDgHIx84YGr5jWcMU2gNpDOVpz
	IMnQo8gAOYqXDdWZtCuKSa6eSIQLULdNF9prmwkwyAXyqNcpleNaF2Q0k2yb2GWjvFHzviRwXl6
	CFUCQBFmh9azskZmVm5l4nlRad+zF+6w4sswOrNeZ1bj+EvBStNefwculykgogKidMvq3YOSkrA
	5MixLIcdfkkzNsFtwHpYGKgL4zzF2YEuv4BgFfQ7IeROw==
X-Received: by 2002:a17:90b:2f46:b0:398:9c39:520f with SMTP id 98e67ed59e1d1-39b261e763dmr61270657a91.15.1789022054775;
        Wed, 09 Sep 2026 23:34:14 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.34.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:34:13 -0700 (PDT)
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
Subject: [PATCH v6 13/17] mm/sparse: remove section_map_size()
Date: Thu, 10 Sep 2026 14:32:52 +0800
Message-ID: <20260910063256.64386-14-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F29A7100007
X-Stat-Signature: ywzxshzkbsjhs9yzefxs81zyi9seunjn
X-Rspam-User: 
X-HE-Tag: 1789022055-350306
X-HE-Meta: U2FsdGVkX1+0lbpQugKfN+XfNNyKFktfpBtN4J/ruwnEvRQ/r+3R92KqZOLGh5R5Lw79ojL3n28JkrBXh1p64iBkFlWIPTKR0bS/uAAaYtbJMSMhgo8G1raSI+FZAFzYE7khoiPDbFDN4tmvFuVKO5JYLYzfVcXqUoLBTXtJsFdzbpTCJ/mt4M7TA7fQmaUGfea+qfr7fp7lq+rNxuNJ5ydVoL+i3E7HAqWUlgh+AE2vUKHcOWXcAUkJi1I8uSVDvycie4qVZjUckd30AXWvB5dwHX0qKTbiwE0wBMo7GjPZpDckww9LOlNQKp6OpDVYCkbGPbeVV1w+UAzFCdz2rk9w3RwDzM03nmggUYL4ejB40hdVmDFTJCv7BxNw4TrQyAolPUZwIRvuX2VYrBiKzq23vfgXrq5jj2MPiFXswf2oMUZKXFy3eUbeH+jWmKRmfNT6UpuE+q5ldR5rdCFbYhXMypVNrP7+fC6KIPwikWR20+cKiZoHM1dBJBL+EB2lRDv7Gyeq1UJM6c6kbDGPGMxOM8WJken2isIy8dX+eWc/u9FB0DFLU0xSf/2N0WFiUnEUnXwamlI2bxMK+ItPQ8rB87kb9evUgHzSkjSrIdKIvo0eI3eBgbDVyCRHQwF6cfx3ZFStXi6R/HAF6DCgop881kx+/Yo7GKEabXrb+mUI1up8H1XzkBhkwjcTdazpGCFx5FfHuaDlgykxIVO/Cz4oDiQB9NUV1QxtbYAFLchxh7q7YqYReYT0ahqiNf/VXYDuE6Jd28QWA7jE4ZoT4QE/RQkka/YdS7g5UTPKC4cTNel1JgFYw0vLQE+8K8SfWG6nmDkDk9w+3+RB/lOF/35XFk/EjwzVHo9z7GdorteOjTpoNGlRfAWmV5Mzcj4DQJ4J0A8HOKoGu+3ZMW4OxV7B1TuVL06BSp5cdvENGSgWwY/9rbPsJQJ8OuvtVgn2HoU/TFlfgHfNzRe/2XN
 o3MV2U8v
 9dfsnCvYcovPH+PeiuNJchpTIDeS4PtCvmwma+H+VE7MGotkgtsKq+BOKPcQTGtJ1F9mjX8J4tX6bJ+cIY1vkWHKYVp5uXM4GOvbIEmSDy6MWj9Q7BJY8W21AFpa7nLw/2/+rZlNM6HWQTAkQDScjA6AcxO8NsOMbYpslCWk3VQ3/I1t3aRbjb/rTKVSMDClbObDhY0d8Sg7HVGVeO0AqmJ9MRhMMgfsDcMRqRfbI/Bmji+I89iJPNLLaLLd2hQaQWo9WG+Z6MrP5B/6jFHo7lscitnXLFAyb1cLXngxllDIbxXzIbQwKPiF+zhVIwsMKGZjR2ccf09ieyTI+XF78y6rxRHwW7tDqYz7KsIjox2/Kfo2EkwBuZo18u7zN1ZkYc3hIXbzGdQCgrwyRCxPUhtk8hbZSYQn42+cPTc2reYwrK0PHwc6DptzNMwu9CUGOxJFdk7om9YEPe8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_map_size() no longer provides any shared logic.

After the sparse-vmemmap changes, its only remaining user is the
!CONFIG_SPARSEMEM_VMEMMAP path in __populate_section_memmap(), which can
compute the size inline with PAGE_ALIGN(sizeof(struct page) *
PAGES_PER_SECTION).

Remove section_map_size() and inline the remaining calculation.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v6:
- Make the local vmemmap allocation size const
  (suggested by David Hildenbrand)
- Collect Acked-by from David Hildenbrand

v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/mm.h |  1 -
 mm/sparse.c        | 15 ++-------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 441bd39eab73..b19711b6dbc6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5140,7 +5140,6 @@ static inline void print_vma_addr(char *prefix, unsigned long rip)
 }
 #endif
 
-unsigned long section_map_size(void);
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
diff --git a/mm/sparse.c b/mm/sparse.c
index d19c173b40fe..cc28bb41fdb1 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -208,23 +208,12 @@ void __init sparse_sections_init(void)
 		memory_present(nid, start, end);
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-unsigned long __init section_map_size(void)
-{
-	return ALIGN(sizeof(struct page) * PAGES_PER_SECTION, PMD_SIZE);
-}
-
-#else
-unsigned long __init section_map_size(void)
-{
-	return PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
-}
-
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	unsigned long size = section_map_size();
+	const unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
 
 	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
 }
-- 
2.54.0


