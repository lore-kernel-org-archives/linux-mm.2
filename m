Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46DEA1099B43
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20B46B00EB; Fri, 20 Mar 2026 18:14:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8F86B00EC; Fri, 20 Mar 2026 18:14:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A359F6B00EE; Fri, 20 Mar 2026 18:14:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 920B36B00EB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FC9F1A03F7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:24 +0000 (UTC)
X-FDA: 84567846048.02.7CF1AAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 94C20180006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q/60OwKZ";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYjN6m3GbPxdcjc7OzvpuncjiN+mQv1MilFoKJHlNcI=;
	b=XrE41VFdP9JpuEO8/qtUIgUON5RgCD2C4z5k8+DguMjCpgDd17xfALIMG8Ki8y/EhvVPT8
	sdw/w3BIBnNMWlneEIa6qEuRG+DAxUJt8fka9p99FxLalqL9Tg6ZH4yCKdTiNtZlhOqVkq
	XLbNUKisI9tGveft3ONa1WwRN2eIvdY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q/60OwKZ";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044862; a=rsa-sha256;
	cv=none;
	b=T7vvX3oM34zPZt/dMfHI9kmO+YiUxOy2QHXV3OaSsORkAKCxuiEbkhHXW28YfdqQhbSpPY
	l54JzZ5JC6SvkOAediEU7jkrBPZOpI9sbqjCMijcsYwzciktGA9n21bIrgAkCU/LTKeiHJ
	2VhE+FMaAk0RHS8h87Fl+CxAUWZcO5Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C7EA8442DE;
	Fri, 20 Mar 2026 22:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076F1C2BC9E;
	Fri, 20 Mar 2026 22:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044861;
	bh=Vtv/qpTDQk/7inFFI0u5qucQjzvddf+x5J6ke/XAmFA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Q/60OwKZJgZGnc4cuE408V8PndBf1ubURGRU3pC92Bz5GciFz+8dzq+3HsnIocd0n
	 gxzy4ohI3Ime2QOU8SrTS3Kw9GahO4smn/TxyBflFuU5M9GxtyE1t8d1tpjZ7wKhx3
	 Iuos+t8Rdy0j6ZwSK5llN27ldgM6i2wHL2f/4eYNoM92JypVg4++ZRszDwNpxWBpWo
	 K3XYvT9MoB0uuCrCf8OsJHhhnoc+FTuFI24fdT08ifh1HNPsxqtzBSaxC7e0oLpMBO
	 oRACyLlddYQzfCjcLx2utXgz9aRZIzmsdiqbULKAwd2U8r728s+/99zYbP9sf3IgQ3
	 9/vkIovCOHohQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:41 +0100
Subject: [PATCH v2 09/15] mm/sparse: remove sparse_decode_mem_map()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-9-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94C20180006
X-Stat-Signature: epbk63g8u3o3j9j75xhainzw7in63awd
X-Rspam-User: 
X-HE-Tag: 1774044862-412391
X-HE-Meta: U2FsdGVkX1/ZKMlQQagF6AepJcseAYbZfZG9qme6sQ8iYacMvqxEXACZHLUaj/JBSWIprkdVnq5qyjKi2fFwZVnseXdKCoOBGDVCQ9QZ/yriXg2yfjqIDSVMZpAfqa3oijwoZZlhPWb+TVfgSphlJerdI2IBRT9QWGSV2zPZ9j79pYpO40R8paY1CUqYwtInGoRGiki3hdXzGABLfZBN2ISptHNtEmvXNuBL5pL/KxNiaawMbsBYhqEkxzNgLevhq18rR44m/2w31veQriid4nakyj9YURBuh0mdXvpN2P9o/jr9kLz19Xed74UlMlRmI20FfQBwyupoHiEfS5XfaaOasokrMOwOWjtvGyb4XahVTIwpM8zyUlBcrEwXrbS0FHGKOtQM7ozM4hJcHFBKFrekb/xrvy8fXwqA0meLe/O14c7dGsEzp3xTc9MY/VTwkRDCaspjTo1Y1HjfUUyIgbx5+otdFOZSAdXRzcJUOBMXVNoneNIlCbSOQFgtmc5PJEsgGFmCps1YnS/jOD0a0u7m8YdQ4sSLdrug38Nfr6fvfKlVYYTatA3kWdDnztWc6uRYC3kYPedNjPbM1urK2FvwVsU+sFKlmUS4q4b0RLf/nL7Fu2RUwCDsiELKQvLu+JsNtd6UBrFzm7oOJ5UyJNxc4eSzMTVwgpu9vrX7bpZKixsgsuvbNb2Dmq2BQVGihlnIoMew8Af0t50zm6HKj7l8ea/6foKuhWTxupYbawlmARgxtpYzWywBKePYicsjibsHIjXxmHD/z4R/u3zshuIccPtAPlhDegCDIKY8yOLNx+grxH8GNy00zpzNMmBnG0mPhJQ1cnvar1mG5clNzHXsHV3Lrx1Un9RQ8Zrz6VQrErWx5sLRIdez/K54VzkYo2vlgUAR7oYYsQjz+fvwmb5Ikr5jqbmUIVMNzORHUyLtwIJlSX8LlYicoo+/v7teW8e66ugDIAXsMPUcbmT
 8ywLUUmO
 ZIccbGsJhmV2kz91+Sw0DxUvyaTzb8FW01TZYr3/jpGeoGgxf+6APxauL/dg3+ME5taW1edpCFs2mSSszo365+ofe7E5N473sS+s+bp1vy+cnr8Mu57V5MuWzBdmAvWXdAda53NQ3mYL9k2Ei3LKt2zyojOCO7rLgHIBOmdVT4wZEF3xT0PUh3AT3OhXlGxqrpooFfLXMCzTPInCt0Ga56oy/c5ivJMzmA/5HaUwJ398Jjp2r169uF6WnZrRDQfnGqoJj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_deactivate() applies to CONFIG_SPARSEMEM_VMEMMAP only. So we can
just use pfn_to_page() (after making sure we have the start PFN of the
section), and remove sparse_decode_mem_map().

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/memory_hotplug.h |  2 --
 mm/sparse.c                    | 16 +---------------
 2 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index e77ef3d7ff73..815e908c4135 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -308,8 +308,6 @@ extern int sparse_add_section(int nid, unsigned long pfn,
 		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
 				  struct vmem_altmap *altmap);
-extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
-					  unsigned long pnum);
 extern struct zone *zone_for_pfn_range(enum mmop online_type,
 		int nid, struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages);
diff --git a/mm/sparse.c b/mm/sparse.c
index 875f718a4c79..b5825c9ee2f2 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -274,18 +274,6 @@ static unsigned long sparse_encode_mem_map(struct page *mem_map, unsigned long p
 	return coded_mem_map;
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG
-/*
- * Decode mem_map from the coded memmap
- */
-struct page *sparse_decode_mem_map(unsigned long coded_mem_map, unsigned long pnum)
-{
-	/* mask off the extra low bits of information */
-	coded_mem_map &= SECTION_MAP_MASK;
-	return ((struct page *)coded_mem_map) + section_nr_to_pfn(pnum);
-}
-#endif /* CONFIG_MEMORY_HOTPLUG */
-
 static void __meminit sparse_init_one_section(struct mem_section *ms,
 		unsigned long pnum, struct page *mem_map,
 		struct mem_section_usage *usage, unsigned long flags)
@@ -754,8 +742,6 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 
 	empty = is_subsection_map_empty(ms);
 	if (empty) {
-		unsigned long section_nr = pfn_to_section_nr(pfn);
-
 		/*
 		 * Mark the section invalid so that valid_section()
 		 * return false. This prevents code from dereferencing
@@ -774,7 +760,7 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 			kfree_rcu(ms->usage, rcu);
 			WRITE_ONCE(ms->usage, NULL);
 		}
-		memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
+		memmap = pfn_to_page(SECTION_ALIGN_DOWN(pfn));
 	}
 
 	/*

-- 
2.43.0


