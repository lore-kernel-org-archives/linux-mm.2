Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB75AC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 19:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6E36B0098; Mon, 21 Sep 2026 15:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8DB96B0099; Mon, 21 Sep 2026 15:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB686B009B; Mon, 21 Sep 2026 15:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C34016B0098
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:59:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84A1CC02D3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:59:35 +0000 (UTC)
X-FDA: 85238834310.11.09A52A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CC45816000F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:59:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gue45uXD;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=znuq93Je+7pg29stX/zTy75KNbIkjx5/fhMhp4Iv7CM=;
	b=xKiX0JSWjHKj++5P/fTMvR/SZJOjc51sHZB5dqUpGnWSK2xb/3KUACu9P3BBASjZbnTKp0
	7mPLBNg3e6EgnoIqt5d+U4Cm3ZyWFJJigIWOLf/LbbBR1ALh9G3/2iEw4AkvjoiE195/cM
	75e3M0oB9O80dJ+JDcbLCJfNvUqWKYU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020773;
	b=0/BomdGfqvuURaxxR/QfY+EIn9jDBxzwUtrJiFPq2QZ7RJynJf9SztCZHBzC+atd38ngLJ
	2LbPINdi4geUrwgkZlD5VCmLb4OhJ860gHdXrEvBUkarUcQag7FGvyAdq+IpRk9lpecZxr
	KjEtxiA1JqhhZXLm9EixFXPxuv58U8g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gue45uXD;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64ECA601F9;
	Mon, 21 Sep 2026 19:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809E21F00899;
	Mon, 21 Sep 2026 19:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020773;
	bh=znuq93Je+7pg29stX/zTy75KNbIkjx5/fhMhp4Iv7CM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Gue45uXDlrtsZghs401ZxlvxAFCmKJrKoIl9vhZ6icV0q7WVvfPCHPvy2WCC8yGKx
	 zp+4o8cJXp3NUMtGILz2Um8/Zk5qYS79fV/7v9IEc88LdsMMJnDdjUCqDwNCT+QrId
	 vssN0OshCSc8ydk1Hu+XjoTisNJffkwsomYb8b82J8+2Kx9R2z+anPC9f53PPHBzQE
	 SgSXFYAxitEU2ZO+tm8zMQYwKmz7g0JPJw/VjspV3LnNsdAYikWF4QyPwzbJieyLPA
	 ZPcaV3xjpNoz4dlsRb1tWJLzC7q3u7jQ8lfJnQsgubv0ckAHHFAJS2z3dulC9y+km+
	 Jruri0AeIi6yg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 21 Sep 2026 21:58:54 +0200
Subject: [PATCH v2 02/13] mm/sparse: refactor sparse_sections_init()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-sparsemem_cleanups-v2-2-54d81d65e125@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2850; i=david@kernel.org;
 h=from:subject:message-id; bh=sr/2UUrbiIspfv3UAleZAwxwTqvNNou3addI+WKCBYU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI29rTqtW/P/ZulHPP1677Qrv9fnx+6quA1dRrfxuUGW
 yLfyqpO7yhlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiH9oY/iepyPyyzjMsnin9
 sZChKnYDk/IUzjs1kx/N2+usW/97Zi7Db/bbvs8nnVjFomnkv+3TG/bJ8XM/X+75vi7vq0q/ZvQ
 eZj4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: t4wqya6wdqu6zxfre1fm7uygw8zrbkzt
X-Rspamd-Queue-Id: CC45816000F
X-HE-Tag: 1790020773-952091
X-HE-Meta: U2FsdGVkX1+Oyu7jaLcvrav3ZcCk8gBMjB1pEmox8cVvP4N4zIgPlemfqgEvNcc/ThKVNE3uInCmcv0ez9peOdL0/6nRUFJCo2PQIhHO+uVr7kY2cBVp+fw4I3GEzHlgEsyLTbQtFZDB+YTStuDiP1+iP4x/FLjPQBmUOjZtLCM6hux1C4Ppt4l6RfZIo5/qLrtcETl6ODRO3FDDxKak1foGV53BoY3lx5RPrz6kn7UnFYhu6+qG+SM2asBkvY6SD2pmQ40EK79lzHho7Lq8OXPLAEtUhU2abX+o+39+XyIK3k87FudFezhkwI/wF2hwXq6SRJbIh9S9O69/lpqu5AXkaiK5TJ1IkSUnOLTu+5Sh3hb7VIt/6S2ZDNvLX3cqz0FJxYoEXAHvCiXtEUFrU1OtRclwTe1kV/pdVPPo6bhxm9AynFMtuKVrjNbA8e/HoHE1w535cOB2gvL0PrXyoYEhxF+tiMBjzTZi+PSYaBN99MNi1StNVrxRcjfCbeYpeVbT3EEszEaR57f2J01pfOhrg+HcSYwbdEvQP/VzO4jd54hw30zTPfzuZl4frkXXQipKHRt2RMiPGa3HmFdcbPDGbKj7IHzjB/A0Xk5dSEPatjUEVArzjB83aqSCQGtIyESnEzZnfm+j8WNJ90vebRgvUEUBfmmCyLqWYHzDNYsAEAvdNKcYdw2neBDv4N190bIquIQNRlfco4xIheKLgwESrhN+Kyjg07hpFfpXd5cZEBxk4nQojFwDRJqsAFeKa/F/cXsJYLFHg8NS9PBUmCqIlbPRpmz12SQYtcgDMu2J2bSiVhCcClam/rFN2qfqFRMn+mL6r06gxoxIUiSANSpARdOj6PQhi0SWm8+tQJ3fVRV5F1pShiAAlHQMh4+pqv1HBX4LS1bpwhmD3W1hiqSYyTTBgcG99Ow8X1rS9R2Is8vtWyYV6+b2U2uEfg6pG2Gsq+L0V3NV++8hENk
 btwfutUU
 L7nlnYPHQYCFTz+OFB8k2RKNILxijod+fvAfKtwmee5jwktGFYM1zNQOlT3aCWO5H3/zVON3wBPC3QaeC0xM4l1+xCeNwbl+aPZosI85kJQLtxmFdook5OaWaGuQuxVPGvcMaWNM6E5m8CaNRvPChj9GIViZE7AQrWs1DMeTohvn5Hlpkrsem9wlDr7Slq8XSPgs2EXkKxezDDOWe7M2rRmv/DPDnG0C+YBu5VLR835hA80grMdfkeICX4n062yi/fqK1yThHzt+07A2eZPy+TFcQD4H3UFl4ukz8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memory_present() really identifies+prepares all early sections so the
initialization in sparse_init() can properly iterating them to
initialize metadata.

Let's just inline memory_present() into sparse_sections_init() and
cleaning up the code a bit while at it: make it clear that we are operating
on pfns.

Note that we call set_section_nid() now only if the section
was not already created earlier. Now, there is no more inconsistency
between what we (temporarily) store in ms->section_mem_map and what
we store in our section->nid array.

Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 8cd2b06b231ac..2b285653abf1e 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -179,40 +179,33 @@ static inline unsigned long first_present_section_nr(void)
 	return next_present_section_nr(-1);
 }
 
-/* Record a memory area against a node. */
-static void __init memory_present(int nid, unsigned long start, unsigned long end)
+void __init sparse_sections_init(void)
 {
-	unsigned long pfn;
+	unsigned long pfn, start_pfn, end_pfn;
+	int i, nid;
+
+	sparse_extreme_init();
 
-	start &= PAGE_SECTION_MASK;
-	mminit_validate_memmodel_limits(&start, &end);
-	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
-		unsigned long section_nr = pfn_to_section_nr(pfn);
-		struct mem_section *ms;
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		start_pfn &= PAGE_SECTION_MASK;
+		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
 
-		sparse_index_init(section_nr, nid);
-		set_section_nid(section_nr, nid);
+		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+			unsigned long section_nr = pfn_to_section_nr(pfn);
+			struct mem_section *ms;
 
-		ms = __nr_to_section(section_nr);
-		if (!ms->section_mem_map) {
+			sparse_index_init(section_nr, nid);
+			ms = __nr_to_section(section_nr);
+			if (ms->section_mem_map)
+				continue;
+
+			set_section_nid(section_nr, nid);
 			ms->section_mem_map = sparse_encode_early_nid(nid) |
 							SECTION_IS_ONLINE;
 			__section_mark_present(ms, section_nr);
 		}
 	}
 }
-
-void __init sparse_sections_init(void)
-{
-	unsigned long start, end;
-	int i, nid;
-
-	sparse_extreme_init();
-
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
-		memory_present(nid, start, end);
-}
-
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,

-- 
2.43.0


