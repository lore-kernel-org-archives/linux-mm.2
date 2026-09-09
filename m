Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D06C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B5986B00A6; Wed,  9 Sep 2026 09:35:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68E2B6B00A7; Wed,  9 Sep 2026 09:35:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A35F6B00A9; Wed,  9 Sep 2026 09:35:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB9A6B00A6
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:35:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F6D61A01ED
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:35:31 +0000 (UTC)
X-FDA: 85194320862.21.8EFDD22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C03F214000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:35:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FwyGU5F9;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZNdkM0u6O9tZXo2WJInVc9+4wXdTph9vPW/LWef/ec=;
	b=7q4HuSMkB7uXcD3jJgyJ1EDMkXAoCXpRFnT8dXM3KrHurv1TJElqpV53sBLds8BfixdtYj
	/n8QwM8RjT/CT8bO1wwmY+awQC0BIIMf9WtW2wd8Ia3t5chfoRCrCnwlz2edKfxrT5fHV7
	XI6gBXK+lAd7wwbjUxddka7Ga6nZeWc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960929;
	b=i0zd689wQNr8oARn4lR9VoAWpG66b1rBf9D2rBv5HolVA8Y8MxDeMO0TcKEsUy5Dlm9Htq
	EDINGiuPTqtU36qjPcvJXNS2BCcRBTuTDiJ+sSr1PC3l5sbhBAO0mbDl6EV/sVbP2CC/Ub
	GgSjS++vZzThvnzjzAmFykLdlhtmscc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FwyGU5F9;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 326E3400FB;
	Wed,  9 Sep 2026 13:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887071F00A3D;
	Wed,  9 Sep 2026 13:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960928;
	bh=yZNdkM0u6O9tZXo2WJInVc9+4wXdTph9vPW/LWef/ec=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FwyGU5F93doyR2e+TPh/mdOmwUgenFtb2TP+XJNz3h+GAaop9V50jXt3fURujWDff
	 844XCCU9pS4FYYnocBM040shpJTZzg1504KOaOOFjpbpw6yaW55hBDNAYN4gZGelNJ
	 ihdNcRxfV8z+R21OYQncFMNeyXGi+GqxojxD1Tm/awQ61Cf9zcEYnvtz6c6YoVCuYP
	 /esXF2U5FYahncfNaVAfyyVTJnnSJ0XZCY9E+GO1YsW+vTrPyS7LyiXQWGgTPzPtBl
	 mg0S8dObY9asNAhWG1oHEKPZyQtyrW7lNHEdnMQUc2zcEPuLc1MbVJ1iDeqhPEap3W
	 2q5EQjdyVe0IA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 09 Sep 2026 15:33:03 +0200
Subject: [PATCH 10/12] mm/sparse: remove flags parameter from
 sparse_init_one_section()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-b4-sparsemem_cleanups-v1-10-008fc8d579fe@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2131; i=david@kernel.org;
 h=from:subject:message-id; bh=DckWm817GDohe+Jpj0X2/MGpAnLdf0iSl2oq+0nv+DY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIWJpiGJ8Q3l91f3ndj9/ytd25uOvJENPJiXveMnvgJG
 rPSNjUYdpSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRpzEM/6yXpcS7z3Bcy9Bt
 3ZL/dF3H7HstSeYHrDlieadzlPUnLWf4n2HY+OJTruOio0Fd1m7VdgLyj/v/cjssvHlvwbyEwKr
 /vAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C03F214000C
X-Stat-Signature: r83febts4ojh1hpby6ss354ac9bxm51e
X-Rspam-User: 
X-HE-Tag: 1788960929-654782
X-HE-Meta: U2FsdGVkX18pohloaYh1waNMwpuncB4eQQuW72Z2Dxv9GEZcAcowIc52+8InPLN/7Fut9jTE1/PGQ2QR16wjXC1EKLKjAKT+FoMIosmYnyNep1AzkicwHz6beM3RXtL4aex+2OF1fzPL4NZ1W+4aa5tWWLWCEbaaa7Wg1vY1chP1DLkmt6Y9Rini+6Yj4U05xh3Ml3fVW/JhxA1NNQclkxFFkpAYdIAiU+rTl1Rc0M64koT7AuRdQZDVmTbWYxp9PftIpUVuTxyMUwK2BCSVLPanuNlvvBgFKVjgHAVp586qDQERwnMPEm1jhXWerOg8maFeH7MLRQXTipjyIRhoY4pLR3SsG3iJjumBrHfw5NOi7qmrcpkoAhR556cvwgoIff+RQVInWkaViWtOEubU4UddQ5I32+pPTQHVyqJNRAG6C6DiAexwQJpS+SbYI6oC3k8rdNcxt2KJAurbBlOdkbFgcqqBQe41lCdsv4AjTsGeQVhMU2OlUlc8+UgfPiROJ5Y1JT3FOyUd87INr1+ERGXqwU/teEtT4qBfQBVV2AlegKbptrsFE4KmIioGna+iC/bs44SqV91uy/HbQrp7gQElcI6b4q78+TG/4Ul3Czcesm4ObY99u7Z1PNTcp5YMFTiVPpV2V9wvr/eRYfa4qO/+8ufoSkatrWZaZbJdvDjEpum+XCrqdKerMYDg2roJQNpEFAbzZM98eLRihYEc8AMAuC+Vjyda4+na2zLB0zanUBhsikJd72WUblEiP+Mib07DjP9waGLbSAagluDcrJ/tqrU3mvPMfuea4cQjSO9QiIcK2RHmfjxvddzz57FSxEXoeaokIjbXL/2J0HziYvfl33gooV/bJHHh09S9TwlMVPJ1ONSLZXjMh9S7RzbRlsZDgy40cFaCJALfm3fBdD8fUbAmNgxySIRKRbgANU0Eeltfi7XM1a5unEHN0mLjMR0Pyw1UDwMwuD2drfw
 IcJai6Vr
 znbwPJr11sZfegs/yfnMH9o10Y/tHmpQ/sJNQLlHDoodZXLTMz8jfsP6lUUqFwabS3Iht+AdtgcehqzIb9wjYdeh/jviNHtLJWvhWZNojdV+uH+SJwZ5swNQ3cXMYqZ1m22cvlxA/l05S+8YiAZYfqx+yqtLypcJDZCjVRwUx0kWI4w8Xm4XMU7wc119m4W+tZ3fjQyHytBBmUvgSaUjZFXt44yInwkim906FqV3+AFvAOVcN44p1jevhAHVqXnIPW/IFblJwHlKqwt94b6pdZYMfEpRlSsrg5P16
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unused, let's remove it.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse-vmemmap.c | 2 +-
 mm/sparse.c         | 2 +-
 mm/sparse.h         | 5 ++---
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 5aba058df6b67..25d3472972363 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -894,7 +894,7 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	/* Align memmap to section boundary in the subsection case */
 	if (section_nr_to_pfn(section_nr) != start_pfn)
 		memmap = pfn_to_page(section_nr_to_pfn(section_nr));
-	sparse_init_one_section(ms, section_nr, memmap, ms->usage, 0);
+	sparse_init_one_section(ms, section_nr, memmap, ms->usage);
 
 	return 0;
 }
diff --git a/mm/sparse.c b/mm/sparse.c
index 344acaaed94db..d2e7c21319e27 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -245,7 +245,7 @@ static void __init sparse_metadata_init_nid(int nid,
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
 							       NULL, NULL));
 		sparse_init_one_section(__nr_to_section(section_nr), section_nr,
-					mem_map, usage, 0);
+					mem_map, usage);
 		usage = (void *)usage + mem_section_usage_size();
 	}
 }
diff --git a/mm/sparse.h b/mm/sparse.h
index 03351f2467e34..f45dd280db6ff 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -91,7 +91,7 @@ int sparse_index_init(unsigned long section_nr, int nid);
 
 static inline void sparse_init_one_section(struct mem_section *ms,
 		unsigned long section_nr, struct page *mem_map,
-		struct mem_section_usage *usage, unsigned long flags)
+		struct mem_section_usage *usage)
 {
 	unsigned long coded_mem_map;
 
@@ -109,8 +109,7 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
-	ms->section_mem_map |= coded_mem_map;
-	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
+	ms->section_mem_map |= coded_mem_map | SECTION_HAS_MEM_MAP;
 	ms->usage = usage;
 }
 

-- 
2.43.0


