Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E09CC624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108E26B00A1; Mon, 31 Aug 2026 03:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9BA6B00A2; Mon, 31 Aug 2026 03:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB3A6B00A3; Mon, 31 Aug 2026 03:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7EC76B00A1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:55:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48EC81C1EAF
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:55:17 +0000 (UTC)
X-FDA: 85160804274.11.CF8CC87
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 94AD440007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:55:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IGxjSqrr;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788162915;
	b=rOvgYAxMTmzdw04zJUdg8X5cdN6xozyL+5M2wmmqDa7TB8hzVr9vVB7s+e2B5yF26Y07Bg
	s9tGxStMnLhM0UqcJl/BB4plXTiyuVYW8Ja9bqjtG6/DiDNffTt0Yl4RpWCOKPAi/GW9vs
	8aNik41Ce5AckgntmU26CfIjg6pBY6I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IGxjSqrr;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788162915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Uns/ZJlTRrXsZn1DdaJluablabo4P2O8/HR8HKp5bE=;
	b=RQWGm3VULfW5NWmmZBIT2jF7wQ4KPHMNktf42+vZXuWxePFAf8pqaJ1Br/5GmwTen1V954
	8F11eQEax80L3eyqQXNJq0490FBXurxQroXona8n2bS6+Ss6nTw3qtJITxNQ+egBr636NW
	9iweP+lGIMqqXO+faWvliFCPK0rsPzk=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8518b3ff3e9so3197151b3a.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788162914; x=1788767714; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8Uns/ZJlTRrXsZn1DdaJluablabo4P2O8/HR8HKp5bE=;
        b=IGxjSqrrMQH4cHDDMnj3yNGtBl+FbGGClP9LDRckh+Nc9JQJh1mqlsx3VOSrZxRxDM
         pA3ip5SpoCjjUGIaQjwOkogmGscx/vQc18WZYmCgbc4pBWUc0xNkiw8SZiqXZ4061EWz
         QouTMOsuR02VcfgDYqRHcoDLY7dyeu20JCz/8tkOgBFTfzKLCLiyF67tk5uwW5mM/AbI
         MPe+CPAu/wBqrGG8Zo5fHrDLF1KrRDol9TB6+sZWqGgYPbYkUKHB9MVU5yVz64OJjdsh
         0OY7wZueLIt3VAzBWf0y/zt9l5bZ0rf0+ytdLz7O6l2EUKu6rAo2Dyx/7kR4ZtH/zH+B
         /WIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788162914; x=1788767714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8Uns/ZJlTRrXsZn1DdaJluablabo4P2O8/HR8HKp5bE=;
        b=ko4eDDG5spbUJz2whUxy8by3lttsz3fbkwgR5ftX3iM3DD5H6n8Tv5mxPmAm04y5fS
         nu1nbE56jDtCsZKT+TcsvNDi8wLqBnNO5qFKWTeAVtUaHgUjYTQvrhzwXkUZ35pUA6g2
         8i8leHG1KVutQV+34R9i9sxgIb1Xl/Fu6ZlzSAhofwXWzQZf51iEX0MMrSmIwhjQRAFJ
         oRsbRmwMgpQbJTssw+BaNrYv+gWxaIyctsbRXylH6tL0pK/9kEXmHRPDChODFlD+lFKB
         VSWcJyYndywddtawRTzQnFJPmSPmcilcyeU8KR0RQ4ks0FFwzfNoGzk1BP8E5E/iw+I3
         H5zQ==
X-Gm-Message-State: AFuF++n8+DMH7T9LkonIDJPp9+tz2P/QKcEHPwTrDU5LRRq2AoQAX0JF
	jPvPKnUz0cEvwDwuDWAmG1M+tFEu3wYo/bMRb40p/zQ4Yd06WRXcLMIBJDYNxeZxm3Q=
X-Gm-Gg: AR+sD10rgw/AxINu2rjWOhFKuktecZ8P7FVYAKh/KLqsQJJ2V+prBfLZyKJJTG/+8Ui
	0E3lJmnAMmNQbYT1BJBp/FsE4qodCyDCsjyfIOBghgezqnAg8Hzpnx/eHLTM3Dvm+nvF7oz3LDy
	vZ38ogblyyWlqKfjFifUI33PHapAI3xBN6Bt0vW1lYOUp0ERNo0CIv9QgusxfuzWwl+kVtExt/X
	VupIna7+SmgILUaql72H7BtveOdgdrMOB3ASTzYxsMvHOs0XdFXBU7A0ki7G7NVF9mqMg0Zl6f2
	LQWyOe6zFuGO2bzvLV7mxIzAQA0cxchaB1UKa6C294P5dnjKGHu8T94MpPtTiGBfR8fg7j7cf7x
	quTFo0+zyGtlchSXWAPAQNr5a+U7IVhfA9ZVCXyt0D3+/tbPZnsyYZa2clTwrcxUUrClIwvhaxg
	a6JOBpFbtxtivCyJ6aGhmYgJbnyveXgbPT3WvTVPPT8Rh+uvcAMjKY95LOjdiRRpraYhvzsvLyx
	r6qK/lfrQzRmsNZA7Y0/dqT
X-Received: by 2002:a05:6a00:845:b0:857:72ba:ff11 with SMTP id d2e1a72fcca58-85adca7066cmr2156632b3a.25.1788162914397;
        Mon, 31 Aug 2026 00:55:14 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f330f88csm3590256a12.10.2026.08.31.00.55.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 00:55:14 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 10/11] mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
Date: Mon, 31 Aug 2026 15:53:41 +0800
Message-ID: <20260831075342.57563-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831075342.57563-1-songmuchun@bytedance.com>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: mqsxtok13rfzkfnodkjgndox9fx8xawq
X-Rspamd-Queue-Id: 94AD440007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788162915-821047
X-HE-Meta: U2FsdGVkX19+bsUOTLdOHXfiWam2rzCtmX2rV/bCL/Mse2z/9DtFWWxS1iPTjM26cGeLAURQcCtjz6SgaZ70L+XERCdSF6znI5Ys4kfTYqO8jUNk/DlzTOKLidSaZKUtJOR/wPQWHP3OuQxmEuXO6SXI+FImQgqzcjFMvrpNZIBq96jn07koDarTh991qw5KNZpxQqg1OBddC9Ste9e6igAbxbNi9dkWivH2yBtoYK8IoPAbCXUHC7y5SYy+9anJLeZ9IgxteGE4Y85t9y1lc64iW8Fi7Yoy8MsYu2QqcIs2aP84x5NWv/F+JZxGcOaHRdSFDLPmBdwKS0XJqU+okn2foVeigWhE96WrxaH1QAPQ0soJQCnKOvMIOdQUXPnfA82QhPrnCyadWRodY3Xt4gF6a2GvcYB7GUxqRG63jsMncuRvNZDSljpZKASkCKuAABLyXqmP2foL5REL4udrMlv4yR96f+m1HAKXdnONDDkhc6bokfgddftRrl3lB6eUNb7W8HzOaoTh8UGdIdVt2LwZUd/6l2b7OzyLHmFsQQ0nIpSeWNLgBqGO4bGzItQmFc8PZeaCHke+/PXRdenWWh+A44RqfhXe1YVl3UXBj1LqxpTrKrChRhTKa+JN1pgRAmx7q/YbV106KDh1KAZZwZGsGf/5GkOOdrXdHWrI7v3ajgIe5eap33ihvlirUkFBApe1Sf5bpLsdtjvS1fjPXzHmjc/H2Cebl2/gRUiKlQyzQFBPidHPwcuGTY8WLMBPbxkvDqZy3FbG/eidQU7yLR3juN3gNmyYoCASudofXLjBwhV8tKFUy5VZjtbcGv/zRhEHTQNh22SLN2k4/QGVfzglnCgC3b1RlZgdZB9VnfbPhUnTK0HFhxqUeR9x14QP+EVq4kJNgwPts5TguMP3yvF/0PJF0UDy+bre7yjaWngLVSwfdUJjg9AIg0rRai4YkeDYUsRNCFRmSjcVC/I
 5yoeetdQ
 FI5rFmwFLM68WsYHkyP81yWfG0uk2Li5UIfKR1y6RkZby0bxflW53jfj0LodKDUmqFbUk7hDwexizKE1tc/h7rMt2mqktu9O+asA8QiW2zVlodtE40ghA2avNc5eU/sfEQW2s4SVWcheHjqKaSIPmSOHtfaj0juma+Ks96aAaZdiFKIzN7EEZzc1djrxUB8Mu09NbRU1HPFEe9sipLQR6LyZVNKVPe1cj+BNiF8nB8AU2f/NxK9P+abKC0qG90Jx32TGScQc0XdSXiRKRevp2BAzHsW4ojVNxEkw96a1UULwN2V9pHvon7ZiLMflUY/jAjcabbKVrMs3R6Xuw22sDnKEHZPw6h2sCVyuhx2GX1lg0SIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_nr_vmemmap_pages() no longer uses the altmap or pgmap
arguments, so drop them from the helper and its callers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 10 ++++------
 mm/sparse.c         |  3 +--
 mm/sparse.h         |  6 ++----
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index e655d9d1348f..4950ac2a1c01 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -131,8 +131,7 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
-int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
 	const int order = section_order(ms);
@@ -637,7 +636,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages));
 
 	return page;
 }
@@ -648,7 +647,7 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -658,8 +657,7 @@ static void free_map_bootmem(struct page *memmap)
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							NULL, NULL));
+	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 	vmemmap_free(start, end, NULL);
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 9349ed6326c0..adf057f54c0f 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -251,8 +251,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 						nid, NULL, NULL);
 		if (!map)
 			panic("Failed to allocate memmap for section %lu\n", pnum);
-		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							       NULL, NULL));
+		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
 					SECTION_IS_EARLY);
 		usage = (void *)usage + mem_section_usage_size();
diff --git a/mm/sparse.h b/mm/sparse.h
index e511d99fc26b..5d0f407bde7e 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -70,12 +70,10 @@ static inline void sparse_sections_init(void) {}
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 void sparse_init_subsection_map(void);
-int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages);
 #else
 static inline void sparse_init_subsection_map(void) {}
-static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 }
-- 
2.54.0


