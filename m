Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49547C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2046B009F; Wed,  9 Sep 2026 09:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8BB6B00A0; Wed,  9 Sep 2026 09:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6906B00A1; Wed,  9 Sep 2026 09:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBB666B009F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:34:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 27204401F3
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:34:33 +0000 (UTC)
X-FDA: 85194318426.08.3DE5FFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 49731180009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:34:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZelQ852V;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EfFkM8TVdbGE2NG2Pg9PpUCdJifdmydrKyHEc/A5FNg=;
	b=bk4jb4zbFLHLHX8bk7J3VWURhBI7Qlp5Zu/2qT0qd8yW0YryeQNpqLnl0bf1PEm2INmB4B
	cKABEW2DbV3xcQ+VI5OeMmEvTGb/0igXqOMbs5AEHkhSJk1Do9ghbtt2aJKp4goDfqegP1
	Bo86MBYYT4shQQaktTUqT20nOjRbKIA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960871;
	b=oK0UFW1Ea+w0tGB2seUcJwwJbAGt+Zf7aA2FumV2cg/KW0QYT2Z1qkYuybHNj+qcUH98ja
	HwFJAZjzmbMUh4S/VhL+qLGdsLdQy0LJ4beMR4UcRf252pIaqnRi4lyfmBr4LgTznVqEwM
	Ize2aOzZYQQ8mq4kOe6bckm8hgaT+zA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZelQ852V;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CA1243A7E;
	Wed,  9 Sep 2026 13:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB38E1F00A3E;
	Wed,  9 Sep 2026 13:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960870;
	bh=EfFkM8TVdbGE2NG2Pg9PpUCdJifdmydrKyHEc/A5FNg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZelQ852VoOuFMeQYlpa1x3hPLSEBcmbHr/anV1cxsUAXZbU4Q5UyYHEPxH4ih1+0P
	 izH9qgUZlMVymte2q3uRmLw9/JQiFCsNpX7U/MlzLkYBWu9shEbx5HPSH+KmfDlrTd
	 arhjR1E7ccoi14BBCfMhxmd2F85EApCvid29inQNclly453UllgucI5jYUcge9USbI
	 6dMDsN01ZpUKXTL3XtyFl6qdXKtzDo11qWD9yjrkuWpfLZPXCCD8pAZAMlzeqNbrph
	 uGe4wsD1cPESHaN+3KOwYl45kJESPBhLIlf7dOzS4dMad9l5EP9icvfoPSmt+uLbOP
	 Nf1AMeDO01jZA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 09 Sep 2026 15:32:57 +0200
Subject: [PATCH 04/12] mm/sparse: rename and cleanup sparse_init_nid()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-b4-sparsemem_cleanups-v1-4-008fc8d579fe@kernel.org>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3010; i=david@kernel.org;
 h=from:subject:message-id; bh=22aLutJEtYm1F1P07TqVwcTSIGuZ5EPTXkGcwZd1Z9w=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIWJug/EP2qvX5Rr/5ab7Y3etta32/kz7uebGjWHKIga
 7G7ofx3RykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABPh2cTIsPXCsU3TilYZ6avM
 f60osnipg1zpgRX+Pk9+n9hy7YrV04sM/12tUwMX/JfRUjlQwL7L68iE28+eWOyt/MxZH1qbwGz
 jww8A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49731180009
X-Stat-Signature: yigi5garsfwu7crmsthrtbhe9wskwxic
X-Rspam-User: 
X-HE-Tag: 1788960871-763605
X-HE-Meta: U2FsdGVkX19rVFEen8FLfx4eevShgPVaFanlLrFwYAeiGLcXJYKufV/lacbfhd2igZm9A6Mocj5mlYt0vL94p+nEtcPDTQtDrOfLDdy7dxEYOQxPOUullXJFlcF72v3WLsVDIuR1S92tLY4MzWBMEgoaAhha99pJ2YB/Zdq+G4ih1/cbHiYZWgdtaHJzVSUvC0WVFXb1gipemgt8+GTsSniAuCxnVYiHPU19wdG1CFwVjT7k0O56mTl0gU82jL2b0C0jNYd98MA5U0YOpbG1Hwr+M2KFOUwnHyR5fxhUkI/dBCyeo0/njAjG9fZ0GHbVCsuvXr7gIXB5xHSpdN9GvvwKA6Bhi86mBoZdOH98x+bmfExsfRxqsz+ll0G2kHyJKgVH4gQvjX6xrffZvf6vDPkewYPRr70svNjoSPrc6HSrofcIXEMQSBIfCtmSkvCZUNCmdJPwkrm74Q9QG+eWheLAjxMaRFh2DH3W+pOq8MHBxRU0r+ZPxVEbnJ5uEI+D+iRdWw2/Q7JD7JQhZTDG+m76GTjB2XbW0MJnsogyOKdZMNcjbRwx1d2+8GeNmrtn8aW0X69bBWlSDn18v4OO4xOpTsOF6RPtepwZnkiFj9ymfGdDesinMe9G3fiSmdZY5Yc8khHjHS0jkg3nuN+dYOX50fMKoplDO3asLKt0I6HBl7NLx5d7FKM3uVhV74sjaAtefkvK5HoLh2ftnZwZm13rV/ENza/KAQzooLiWO9YeTPybWPDXsId8U+Q3DRFjyPaMWIu/2M7coByeRYuqXDZmO5SDDjVNCNNfEbXdg/LqZxfkhw9wnPMiWg8+LYttlubUjWcXgT1hRPDNylOfRvaI2yPpBPo9dJtaM9Rh1xqzzu4V5LOtk7580OhF8XZfF2Fdl8sgAX6Hru9MiDniM3U1uPSvWEj8vD6JNJi5MI970HMzmDzPKyxdylM2JSVLzP+ox0lkfI0cHZvOYlW
 YOy/WWkI
 yxoA8XwY7Uhz1wgR8nUViKXr9Eh7iq4AUFn1XngRQdYDd5vErmkslbcF6SpDZmxq1gm7AATnh3MtsxzAheQbSCyfUvpAjoE6cUEKOuwDJfccD8lUR5dxIJVYBP1VFTMQuQkfYDXJdWoOxbtgjbi616/o+S8WC/IOOWGUWkCNBdBySuYvFrzJJgcnl5DmlMrT2HTqckluL2AsfGjFi9OM8FArjrgtYhPoqY9aqwtEv3tOW1y1lyiZqee5f0Q0186AmRx8+tgXuQnlsjSp/rNfp1m8dIKZ71Oyi8Wre
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's rename it to "sparse_metadata_init_nid", avoid the "pnum" terminology
and drop the function comment. Further, rename the "map" variable to
"mem_map" for consistency with other functions.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index a85a9c3840f6c..f84bfceb53060 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -222,37 +222,34 @@ void __weak __meminit vmemmap_populate_print_last(void)
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
+		unsigned long pfn = section_nr_to_pfn(section_nr);
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
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
 							       NULL, NULL));
-		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
-					SECTION_IS_EARLY);
+		sparse_init_one_section(__nr_to_section(section_nr), section_nr,
+					mem_map, usage, SECTION_IS_EARLY);
 		usage = (void *)usage + mem_section_usage_size();
 	}
 }
@@ -270,12 +267,14 @@ static void __init sparse_metadata_init(void)
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


