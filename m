Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34892606A327
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tz9fODLA
Received: by kanga.kvack.org (Postfix)
	id 50D296B05E3; Thu, 29 Oct 2026 16:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4FA6B05E4; Thu, 29 Oct 2026 16:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FA916B05E5; Thu, 29 Oct 2026 16:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21BAC6B05E3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:41:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA6EA1404DA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:41:38 +0000 (UTC)
X-FDA: 85376834676.13.61A6AAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id F0FF41C000C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:41:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tz9fODLA;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5uSiir5kVbedebaZsFGaz4hqB6R1E7mLyr2MzNoLngs=;
	b=kW0Cp5YR10BGQT++7blQ2OzKa/MYG8YeG9fR05Jz8xNvhiwg3Er9O5+sNppZi8O6Ys5qZ7
	PkL0fwqaOiIjsN+shA1a4jvz4a2L/pHd5Lg/hewNaahdccFqFICKcNbgUDn9eo2i+7ivf5
	DGPG3HaPqUJSlitAr4XwjrSlaXSvVAY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306497;
	b=zbbCGiWdgMP/ctDoLGd46siVfdeMpcIB+t6NiAd0gA7E/DOsnrIQY76BxuuO9QnliHedYu
	hLyUbz994lO+F7xRB94ckO37cvGpf98qI+tfMO4lPax/fNY9QyzvaTYMSWMs6WXnC7lFGp
	wVFZ7uEXCn0uz7hs4uLXn+lVuPzFrR0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tz9fODLA;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A350600DA;
	Thu, 29 Oct 2026 20:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6C51F01816;
	Thu, 29 Oct 2026 20:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306496;
	bh=5uSiir5kVbedebaZsFGaz4hqB6R1E7mLyr2MzNoLngs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Tz9fODLAYQG594yPNH75AeKGyE5cFdBIpvZVoymg4hDw3mti0G72s02fvYCaVCUD9
	 lt8Exc8l8x1xV1p7UpPPu00DRqu1tPXmV2/pctBaUJFydsCRxtD4iT8RTWEzzIv2D8
	 /zH+dZt56YPixFKyK9DnQKCpaudqze7p+L1zR7/mL7E11HewLLmqinTJ1K7n8/Nfj9
	 IfCN0pIc+ff0kFboqS6a5ZLKM55gHo3muvDnalvvf151ZywFvHCvY170kgNbNM7tXC
	 og5+8uu0N/RIhshEfKUph58MECD2INqomDBTAZ5HCuHM/JbWs1X7LTu17UzbxGvru2
	 jnwfdPJDCCm3Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:28 +0100
Subject: [PATCH v2 33/47] mm/memory_hotplug: avoid races in
 pfn_to_online_page() with dying pgmap
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-33-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4287; i=david@kernel.org;
 h=from:subject:message-id; bh=K/Rz5AheKAp1O4iTIfDAL3ySR9IndGWc0AInEz1GWlE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+2Q2HP6vnFJwjbR5iWc8v7H1nGs/zFtM3+9wLTXx
 rctJ5QFdZSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjARzv+MDNNYetk5BC433npa
 bWNiyFHyuetN8VGDR8tfL8n5cNO38xzD/3qNiW9uZEV/67rzcvkCrrt7TOSOm11TfjY3SIf12cz
 MNFYA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F0FF41C000C
X-Stat-Signature: scs7jxfnqoginecbdjwq6mc9az1jka4h
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793306496-402078
X-HE-Meta: U2FsdGVkX18gUKm00f3DIKmsV5u5JoKIjmwXH5k6f3KXaLANGbSgw/lisGcoK4SjdIxhhtlBgxBb7cIDaQ1ZL/cnZiiiPnyqt+Iv3N2cgx2JdN/V1HHqCo3xb0iFtR4tM1+o36IVI6FVGK0YQ/EqWDyc8uW0y5v2p9lpj1RE4Mv1YcZ2G/dTh1dWUW/SfBJ5zIQ+p3HCOk5Af88iQ2ptonFa2j5ZXzURzQWS4eCQjfClBYuSBBFHp3zsKbgj8d/PWxZRqpDKeP5xHHfq59mL0zBkKrkMpMqM6X4DNol0QZk++qJ8GYAhdYBW6EmnRfAjsjNvqT/lLtiZ/1kwvBPfbKAiJCcMyqaOqf0N3R2uN4mj2llBAYyX7zhG6dP/xEcix8zcHCQk6Gds4BzfY/+FJoLYLUWLfDxMCFC6/gbDalMExLuACEom7HNUT5NuyuNPkulSOenlOjkpEYViPYut25Au45S9mxog8+VjsLbn2FYmRz6XMKUGfvZ8yYaJmWSmjj6o7YEyU5ChASQRmEIyrP9RHSSqzAc17Y4m8H/Z361nnk9LVrE4EcAgxZbjbLE/S6uvJwsqupVCyASXiPNLjYqGh3HI080/Xzif7cTdcakYmlAVN5SSPiRPbpg6C7i3d6tZ7zJogYy+fdQ+BtYaP+kVCDEZfVwJ0amyyfYuoNlfxqajwUKMXoqK+DyEh/3ZJ2gtQING/+WOuBpiGZCA74PCyxQ18Rp7jhGqFAx/6DvlbrXyIyvKLMyoW4xR8GtJiVYkXfyQ+CVAEd4Kb72+IMe+y6qVmOmxTfh+ihz84VQ4ZQa/XVLHER8MJPJoGWMxNipDXRdugFIRk9Hkhxh4RjsBSWVPvJ5xn3aTX3Oiwmo90hDaDvH1faytsAsUEhHEreJ9zIpYiHQz6eqVBoEyo6RKH19sgG3cFaqm/vs3mYMrkOD7h5qfSMumf8E0llAkRBft8RBm7X8yzp/TnOq
 XRNxVUGd
 AVbK6//fROFX0rb/UKOFH19OLWzQ3TM/dWB0i/sSgBlmG/1yE712l454NE0p07mrYpkO0/wuwhxQupEH2v8PHSd9AFT+Mp7QeVjlgxwk39cspUYH8p4cLrHHNYuNlBLEOkEVj+Lv3iXtipRPwvF5ciKKawkN/iZ7hrFkNoVQj92H6tlxDoaf9KHEZgoDghmfvVp962sdx3QEbTbR/W57SKdFKt7e88B0WvSLt2FO6vRQ9XN33wcwzThP5IP28xkpoMA6LaKXDKV4CT4aEDqCH3vl5dRoulfHQ835BqJHu8ynF2NgMenENYaxfnC3kdhmk7o+KXbCJizZABPiIKtBaeMv1ftsDsVSe6LBc91LOpOl/dgV129DA/5kanAz6tOcArtVpoHiC+Yompjee5Bg82TlCIVEH7b/R/BOsZc3Y3/HT4leperKRREF7Wb4npKurt6kxOjLXOQXCSm/bO0UlkbPaJg8pG7aY4SZjQvhj8OGMqGg=
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
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/memremap.h |  6 ++++++
 mm/memory_hotplug.c      | 13 +++++--------
 mm/memremap.c            | 13 +++++++++++++
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index e3c2ccf872a8..b5e5e626c7a5 100644
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
index c9cc42e54f05..944ea6fd8856 100644
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
index accba23aef28..a1e99a4c55c5 100644
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


