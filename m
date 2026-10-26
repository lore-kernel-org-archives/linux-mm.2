Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8952D606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wax5YaVW
Received: by kanga.kvack.org (Postfix)
	id 8C8AB6B05EC; Mon, 26 Oct 2026 19:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0A06B05ED; Mon, 26 Oct 2026 19:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6856B05EE; Mon, 26 Oct 2026 19:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 578C96B05EC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:27:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFB801A0891
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:27:57 +0000 (UTC)
X-FDA: 85366367394.15.31F923B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 198BC40004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:27:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wax5YaVW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHUznzbhtn3AtvFPFOcCt9tvyez2ae3rJ1KObV9N9d8=;
	b=IKu4WbO3e80K2FQllBkHpMfxlFHsB2JIUyCMT0SmcPBaqyA+jsz8+mdUvHSurnodwY+MMV
	SWcGinE3CiKQkSIQbY5K4cbdBwqe3iowYncyZSMyGCKF8kwmanBv5a+87Xw6qZxOLGRqEc
	0A8LoUV7kAswB1rKNJaM6mJCIqi8FdA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wax5YaVW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057276;
	b=71gm2h5GV4yodwJOSZWvthgHHrAZkGBjfjGLsiUbYLz2PpFdFuBmfDk6ZrY6RfpWITJ/Fy
	FSS9YE0F4scC0N3H0ZzKlS7urGttQcj/YQIxwi+M0KX/txwG1AnMVPGfmfMORFAV+S/gxD
	GtwntVqNnMgjjdDs/ypP5OiFquSfJvY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9AB860A5F;
	Mon, 26 Oct 2026 23:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B271F031E1;
	Mon, 26 Oct 2026 23:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057275;
	bh=NHUznzbhtn3AtvFPFOcCt9tvyez2ae3rJ1KObV9N9d8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Wax5YaVWlZWtTyF1cl336nJjKdkNmG46OgD6dxRlnHVJj8Cbu/sv1aOd3OtX/XYgv
	 aOdlKrCsUrZ98XB3SksCIIOmcUjGLEvQtGQGJVeaemTMwpsJj9ahgppeTtpHPd40F+
	 jvYOYs9DHDRRfJTZb+t3Ez41u+L45karzC00vwIuxjfyYyOeMH1iBD798L0fsDEMlD
	 IiFRsjyubm5blmZwKQSUQIsHP+XrFLH1hX38WNCQ5pdkYFPW31DiHx6N+6JdLpuvKg
	 W8Mw8HIHbW1azLcj/SFBIkJ+dLBGpd3p8aUSBTN5r89kufzYi4k3Mxxnq80QzNL3m4
	 WUiPj3dN6cZMA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:52 +0100
Subject: [PATCH 32/46] mm/memory_hotplug: avoid races in
 pfn_to_online_page() with dying pgmap
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-32-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4238; i=david@kernel.org;
 h=from:subject:message-id; bh=HSq6X/4K+SfPFkviF2rs567Nufb8NBDKLoe9P0lK1SA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/OsvFGcH2Wo5bmDct3yy6Eyfkcepkg7VWeznVXV
 OA8b+bTjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACbyopLhv5/tl/2M77RcfY0u
 aHKYGOlJqt7fkrkle85nU9N5lduDXBkZFrqs6/fxP278dlJVj395qVda2efLWs0N9UrH55Upsp/
 gBgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 198BC40004
X-Stat-Signature: ngs745j1q5umhtye47k1fahpgiujx3g8
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793057275-271572
X-HE-Meta: U2FsdGVkX1+GqucVw25Qb/BkAIxpIp4LVaoLCFThmdQKev4Bl67cdRl50ESZZgfwbm0XjPaz72ifeIE38LGmInZ4lIZFgXHvksw3yqFqYr8n7tBDuoOKosqJcTwfUkmo9gPkvlcx3YTsrgoV/RrxdE9FmjtJtTTI9pNwKcsk9UsSQFrb7gPWQnzC5bAJ5Pgp9l9ieCh7NwgXS2txq3UE+zRLzZnxc4eQNzDuDp2qwK1zgTLQc8FsK8iyGQZamo/t7/IOkqmNcxpgnSg09qzrSBcrU8d3PeaJqjLDfL+P4UdvKkQuGhaiJ0KYXWcAxiLs+KUKCZKkoO6KsfLViht/9opbyRuP6Cvkr6SLhaTqTjRXvvEp5p73wDa/imhzXD1uRgdhbqCqMQKf6TKwHloaX/ea/I792MdPqu6fS/UhqiEuz6O/FroU945ijUZ+glvzznuO4Z8a++zqf03/l5AgVqvruAfnRQ8enwEJkk2T13nxmtPsZNXv51kxSbtqG8shL3zZapV3vrqy3FvxqEs6QLke1dv9gGRCkpGJyM+WS1Nv4dGXj2bBgzx7yh7FdDoDqGLDV8+4rYZ+XeMv3XnN4U7eITAfCQ0DMk77AyNZOgmDqEhS/rqjDq7i8JQwPHEvGo9XG7OYW3tvjC9ng1w8a034ivOQPC9YtQdWSdTtvu1B7m/NbI2GnDGuaC/TnjPjqj8/rToskhp/QBPao16AtbD0SrJuhvrbbacEpFIpgFJPYNwYR5BhdPi7n+iUaAblLYCcI/GFwC40QwwDMq6XfoVIhLju/JXSlO5Om1YFGjrc9OMCDASn2y0Jfocz46L0EMDpLXpm7et0PrnvxOA4X1fUq56txl2G/EVGMD/4n7T36rOHhpG4teoYxbgiYnM/vppU9yoQlI+ZEO5u4KQj/5jFROIP92lFZZP3CTYkj2ocyYZsONeXzFbfp4PbSRzUe3WV/H3rGJHLfBiqYDT
 XKtljTP3
 8z5xiMEr3BvVNFcJ7aRdI7MhZyPsdzxNXgp3WF7gqiyL9gOvxQ7u/fAd9KeMSBJPAfwAWV8uIBOlgEILVEp/DXMo4OKXShBaNG4zsLBeGOvEamJlxYdeGPm64sDEm1gLvdHNWfoZ+H+ukfpVLc5fvnKcDjIG5oHUHpppFq0MzrgA/79t8ON9YVovOGks1iXHtuu1H629N4WgPkknTtlUmkaxDJ9fuMshUckruPTFBn6wsDM46tr5qI7/GPW9yV8thqi+Ws6u7Mrs3BUeLFVfN/WJwZksa6+brDak658AtlpHaXbJZsYvsyFDTdVh599dlYfGifhIUlM0+2V5uu38BJxMzP7IyiY35BGLRhCxJasMonByb4mwTip+ub9ajTWMllCQdt0LWbCQ/A9w2xprSIx9VmIarbvjz5cI8ITU6Xz8xjq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

If ZONE_DEVICE memory shares a memory section with ordinary memory, the
section is online and the pfns of the device are valid.
pfn_to_online_page() tells them apart by asking get_dev_pagemap() whether
the pfn belongs to a dev_pagemap.

get_dev_pagemap() only returns a dev_pagemap whose reference is alive.
memunmap_pages() kills the reference first, waits until all pages are
idle, and then removes the memmap. During all that time the function
finds nothing, and pfn_to_online_page() hands out the struct pages of the
device as if they were online memory. A pfn walker reads them while they
are poisoned and freed.

The entry in pgmap_array is only deleted after the pages have been
removed. Look at that instead of trying to get a reference.

This is probably not worth CCing stable.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 1f90a3477df3 ("mm: teach pfn_to_online_page() about ZONE_DEVICE section collisions")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/memremap.h |  6 ++++++
 mm/memory_hotplug.c      | 13 +++++--------
 mm/memremap.c            | 13 +++++++++++++
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index e3c2ccf872a8a..b5e5e626c7a59 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -231,6 +231,7 @@ void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
 struct dev_pagemap *get_dev_pagemap(unsigned long pfn);
+bool pfn_has_dev_pagemap(unsigned long pfn);
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long memremap_compat_align(void);
@@ -284,6 +285,11 @@ static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
 	return NULL;
 }
 
+static inline bool pfn_has_dev_pagemap(unsigned long pfn)
+{
+	return false;
+}
+
 static inline bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn)
 {
 	return false;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 796af1028ee23..5a972d7a9e478 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -342,7 +342,6 @@ static int check_pfn_span(unsigned long pfn, unsigned long nr_pages)
 struct page *pfn_to_online_page(unsigned long pfn)
 {
 	unsigned long nr = pfn_to_section_nr(pfn);
-	struct dev_pagemap *pgmap;
 	struct mem_section *ms;
 
 	BUILD_BUG_ON(IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID));
@@ -363,14 +362,12 @@ struct page *pfn_to_online_page(unsigned long pfn)
 	/*
 	 * Slowpath: when ZONE_DEVICE collides with
 	 * ZONE_{NORMAL,MOVABLE} within the same section some pfns in
-	 * the section may be 'offline' but 'valid'. Only
-	 * get_dev_pagemap() can determine sub-section online status.
+	 * the section may be 'offline' but 'valid'. Only the presence of a
+	 * pgmap can determine sub-section online status: it indicates a
+	 * ZONE_DEVICE offline pfn. That includes a pgmap whose reference has
+	 * been killed, its memmap is about to go away.
 	 */
-	pgmap = get_dev_pagemap(pfn);
-	put_dev_pagemap(pgmap);
-
-	/* The presence of a pgmap indicates ZONE_DEVICE offline pfn */
-	if (pgmap)
+	if (pfn_has_dev_pagemap(pfn))
 		return NULL;
 
 	return pfn_to_page(pfn);
diff --git a/mm/memremap.c b/mm/memremap.c
index accba23aef28c..a1e99a4c55c56 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -413,6 +413,19 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
 }
 EXPORT_SYMBOL_GPL(get_dev_pagemap);
 
+/**
+ * pfn_has_dev_pagemap() - does @pfn belong to a dev_pagemap, dead or alive
+ * @pfn: page frame number to lookup page_map
+ *
+ * In contrast to get_dev_pagemap() this also finds a dev_pagemap which is on
+ * its way out: it is registered before its pages are added, and until they
+ * have been removed.
+ */
+bool pfn_has_dev_pagemap(unsigned long pfn)
+{
+	return xa_load(&pgmap_array, pfn);
+}
+
 void free_zone_device_folio(struct folio *folio)
 {
 	struct dev_pagemap *pgmap = folio->pgmap;

-- 
2.43.0


