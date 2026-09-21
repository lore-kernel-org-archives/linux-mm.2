Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D64EFC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 19:59:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62BC66B009D; Mon, 21 Sep 2026 15:59:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602E56B009E; Mon, 21 Sep 2026 15:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F936B009F; Mon, 21 Sep 2026 15:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26A626B009D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:59:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 992BC402B8
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:59:55 +0000 (UTC)
X-FDA: 85238835150.28.F09CF4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DD5FD140003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:59:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L95Gueio;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CdS+/4QTYMA6mkMSAisNrxryoW61WoDFfQTO+/5sNFg=;
	b=39TA8CNpcUr6rAECiwNgX5d9TlYeCL/GhJyJw/4eFSMY32gYRZxYur4Uf055rr36KkFwCt
	WUMV/npiVY/IPQ21l1JywFbTI9uZGwewmEDStDeotdCpH0HwPy+1AmR35LkAwAlXWAXWIH
	AcQKEYgXnXmkeu2KtscCWlSrbEKHtlQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020793;
	b=tR+Op3sAb9862pXzcBvpSgs9z4ETB5dbotrs6F+iuR/eOeeUDVVk/unvPrzbfqMkuHrUpG
	+q9sJQI5IlCDL4kgOvN7LSnI+eRIvr8tVme1MUEeYlOFmoheQKUyaqJ5WcZh6plnVD8spd
	eOj5+oqLmu5d+5Ygws9uLTGjJEuUbBA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L95Gueio;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 77CE960A6F;
	Mon, 21 Sep 2026 19:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA18B1F00899;
	Mon, 21 Sep 2026 19:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020793;
	bh=CdS+/4QTYMA6mkMSAisNrxryoW61WoDFfQTO+/5sNFg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L95GueiosaZQg0BKiLrbDQ2H76JOpx5XQ1JBgC/3WRgTV1pywD/hQQTFC2hczp9t7
	 LMcAMhV52doEKKJ4AJbaFqNNQwCzbqlfAzjnxTCgOXC91q8dFTNEXWIb9dKIdV4aBq
	 +GCCxnVLAu8jfyg8d7Yy8ruPPlblSRPcKUZ4oetaeD+rH2oXWwo29MkQiyq3iS1QsZ
	 qH/+dBLdHmdZiWClIDnwrLnkbE9fZHLoD1hq72mRd4Plq5YnZSgrZUy//gjUJ7EOKH
	 9O/bNQRqIlECpcGhMzppG2nCCP24W+8epB070gor6ECTUmc5+FwG4XEZXEDEOpInQ+
	 yxJxT/11+hMLw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 21 Sep 2026 21:58:56 +0200
Subject: [PATCH v2 04/13] mm/sparse: rename and cleanup sparse_init_nid()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-sparsemem_cleanups-v2-4-54d81d65e125@kernel.org>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3145; i=david@kernel.org;
 h=from:subject:message-id; bh=jRIGnfYse4fXvQGtvRSVJN3HkWBLnWHH94529PFkjgA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI29rSm3gnWi/35I9XhnvDe02Fc7r81Pky0njvXLCrsN
 PMmuZaPHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEwk4jUjwxxHpq7rex3tClv4
 EzbP7j6U8Upt9ZwYj3RbfaU//48qMTP8M74pVnHzVI6q/7I1L5O+1i1aHqBy+1W7Wd8lj0Cvp7e
 62AA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: s5tqj6tntqjz1t3axmgpqff8rri3ozd6
X-Rspamd-Queue-Id: DD5FD140003
X-HE-Tag: 1790020793-356618
X-HE-Meta: U2FsdGVkX18Np2MOpus5uqnXdXvh8qZI/sj8kpRIL5PmZPYXMjXqPkQeamzQkgjaMkivXi0HatAd1QeGWItWtkZznf84ljnJcA0qfJhdgMhmvkMtgtks+/cy61l7t9D4KrO3yrSlypco+sETD+P60CvTj/cqQFUgDFPniLbaJCtpo019IiRppvDg4TsZBvT419u3RyS09SkyX1P9ACCi/+S0T3Jtv/i2KnjXk23GUD+tmZL2aTZFLPQCAs2BgsIsVT+5xw4p5bbhNaicNapklDq9et+u5asGGPRXZwHV16LK8VBbrfU2wV9UJh+itqs0pXBuZwCxVkRBFFGyoOWEWHEihgFfT2an98/FJo7JqyaQTgkg8taFEe7TdkYZ/i2DdPjRLjewOVmFwZjlkWkrNei6uDPMK0nHe64mOmrELvbq2vG+QSI4WzFUR4HjR4W6OpmADBMEa5Et2vb2xDb5R0FvfYz4tuVgIQXGVG3wZkyOfXECyEJfmQehBsynEhObjKjFzxBvafPWcHFAgCKy/mNDZbosDNCKwMQhmBu/bsa1qZV5X07Q2OIbFtJosYDAm65hfumVITvc2HuFUqIX1sGtapeMtIKd5JtMrvim/+p9HDWYcDswKKNwUoVIPleck+O8EN2dq2Zn1ObCoUtJS0/hCCp1jKpj4IPxzVbXP+h+ilhNMHAjHKl8ujMJlCw4jddQW6O2GyzHD9AiIxVPqGhRkNamiTh1xI2C9084DPNENjtQsFdsimKO24oUT7nT0Zo1tPUqT7q6DQzmSPlUdDq/hSffGK2yKNPkbSg1uM5XGbopnGx3MO8Rc8+227zsopjdxg21VujGl94ylEbEjcthcOQfk9/aNR9n9Ri2txcg8/07s/JHL9HTF96S86s9+peHz7n3LG29Ecjv9crYnksUTWvM8q28t0AIvphuoaWfwpIpsl+p9/vzAGCkTsQefxtl1EDdUWtq+NGSgyd
 hFm7oqEr
 +NXzgpi5Efo9xDIRvSkJ2tAWx/zVVMI3YgjxVh7/nYNmoEv3lCViImDMMSjJPQ2HhfgKN5xhOJ9eXfPnRjxViLnK7B+fh+VaFc6V/TWkStKIrJZdg6JsYaPmVpYfheyKv85eRb1Ie98wxsPHRy7lFyJyLn36faqfkY4xszLxYZPpDvEJusTSEdkypGn/j+37PyA6gzm4uNMkbNaYte82svrxEXZyJjUMQp/VcpSUMC3YxprmS3KNj72lkThFCl2GQimqJDr0C25W7ovbDUw5O3EsOxY9QDEKrUXKM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's rename it to "sparse_metadata_init_nid", avoid the "pnum" terminology
and drop the function comment. Further, rename the "map" variable to
"mem_map" for consistency with other functions.

Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 71288daeb3665..3c19d47559090 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -221,36 +221,33 @@ void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
 
-/*
- * Initialize sparse on a specific node. The node spans [pnum_begin, pnum_end)
- * And number of present sections in this node is map_count.
- */
-static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
-				   unsigned long pnum_end,
-				   unsigned long map_count)
+static void __init sparse_metadata_init_nid(int nid,
+		unsigned long start_section_nr, unsigned long end_section_nr,
+		unsigned long nr_sections)
 {
-	unsigned long pnum;
 	struct mem_section_usage *usage;
+	unsigned long section_nr;
 
-	usage = memblock_alloc_node(map_count * mem_section_usage_size(),
+	usage = memblock_alloc_node(nr_sections * mem_section_usage_size(),
 				    SMP_CACHE_BYTES, nid);
 	if (!usage)
 		panic("Failed to allocate usemap for node %d\n", nid);
 
-	for_each_present_section_nr(pnum_begin, pnum) {
-		unsigned long pfn = section_nr_to_pfn(pnum);
-		struct page *map;
+	for_each_present_section_nr(start_section_nr, section_nr) {
+		const unsigned long pfn = section_nr_to_pfn(section_nr);
+		struct page *mem_map;
 
-		if (pnum >= pnum_end)
+		if (section_nr >= end_section_nr)
 			break;
 
-		map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-						nid, NULL, NULL);
-		if (!map)
-			panic("Failed to allocate memmap for section %lu\n", pnum);
+		mem_map = __populate_section_memmap(pfn, PAGES_PER_SECTION, nid,
+						    NULL, NULL);
+		if (!mem_map)
+			panic("Failed to allocate memmap for section %lu\n",
+			      section_nr);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
-		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
-					SECTION_IS_EARLY);
+		sparse_init_one_section(__nr_to_section(section_nr), section_nr,
+					mem_map, usage, SECTION_IS_EARLY);
 		usage = (void *)usage + mem_section_usage_size();
 	}
 }
@@ -268,12 +265,14 @@ static void __init sparse_metadata_init(void)
 			nr_sections++;
 			continue;
 		}
-		sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
+		sparse_metadata_init_nid(nid_begin, start_section_nr,
+					 section_nr, nr_sections);
 		nid_begin = nid;
 		start_section_nr = section_nr;
 		nr_sections = 1;
 	}
-	sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
+	sparse_metadata_init_nid(nid_begin, start_section_nr, section_nr,
+				 nr_sections);
 }
 
 /*

-- 
2.43.0


