Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 961DD606A88E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=o1md8Mhx
Received: by kanga.kvack.org (Postfix)
	id 36A836B05C4; Sat, 14 Nov 2026 02:10:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F43A6B05C5; Sat, 14 Nov 2026 02:10:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E476B05C6; Sat, 14 Nov 2026 02:10:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEC9D6B05C4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7763C1A02E2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:34 +0000 (UTC)
X-FDA: 85432851588.20.826C1FC
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id BB4A6100003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=o1md8Mhx;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640232;
	b=7cegic/HKIEi/tq+V4+6QhfxrOzIHi7HsfS6iRvc3/BA8gvwQB/hf8IW66kqQmUDcNyDol
	Ky29arETYq0uuxZzWvly1pM7pwN2CzeMDMgd61m4IuV91ndVF767jLkl5V8LxbvQdG/f/X
	ItREINsAroNPeh6Ofz8gKR7OMfHyO3g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=o1md8Mhx;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5RFbW7qtEXFgFx3OLZ5ldAh4JcKSI5CeWW5dNwakgac=;
	b=Aj+bK2ToK5I7wMznZbWNhoLlHXOvyrrLhoOPRp++NO2SQugwmqGb0xQSeCjl8obKaCFgkP
	bYVJ0ZxNHQkigMGSxvRsYvRtf6LPqwAl3n32wlWuteCxdUO64i80YMw4lSkbYgtYLvfW5b
	CLEx4fm/kruX9XUAZ62k020bK5aWDnc=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5430f70c827so28734151cf.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640232; x=1795245032; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5RFbW7qtEXFgFx3OLZ5ldAh4JcKSI5CeWW5dNwakgac=;
        b=o1md8MhxCyaIqDQwCCpQVURMeNZwE1412VzelaCCHrc6JfT0YcF70tcH+uX5itQSFe
         WZjLHjC+2tnZNw68UaYB1brSPPUrwCHaaLQs7kK8nG4JkFyIUxmdMFHYsK6O5OAO/UUN
         J92HKgzkGut+q2hJ4qU2akSIP/o/t19T5/ePqf2mAmVseZI8pNinEeXRfEbl4shcUeSX
         pxeNDfSXdLCo78TxiF6l7zUvg/1rDw7VKYQY+qUrwsq0EO3R+fc1hr8a4w4dOwrLmbwK
         5eULqSOnVe5BG0pWlvn4Hv+7d3tKiSCEc8PbFgX1X3z2JfzvYrNUcmW/oThEyG0vU1Ot
         tALw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640232; x=1795245032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5RFbW7qtEXFgFx3OLZ5ldAh4JcKSI5CeWW5dNwakgac=;
        b=Oibg5biDIGS+witR9iZmPpfv3AXb+4H70Yv4spWxq90ErZHoPrDEGq8Ggg450nRLCW
         /JjpRYP8E2ca9ym+BZLTYNoN8xu0Uwh0RY5kT4EF5X9VFbBdlbzWZniem0THCvEuuvA9
         yziH4jq9IMd2MMZ1USCJR8IeucU8XKL+37UlGBPSph5pvcItgO4z3Nf1YN4WGFfWpSR5
         UhBUZoGnTSshhVQu+31JuD2VNxUQGgFbqQbpUvqfdjWtH6ZGfA7KKgVsBaSrPrUBPZ+I
         5JVQzoDTVs0at9aiaIt/DsFG3xN/mhenuIKtNEZPkraLzAyrEGvlwuPjOa/poVptwiBb
         pxdw==
X-Gm-Message-State: APuU4Z/2dGUml7VXxXzMT1L2et4QKnjVwNsfeNlg89qdMI+a8sZyONuP
	ECUPgbJohy97ajfAxYQrpR2guZbQxmFnn66AcGgOVLXZFSR24DX7/n5LhfPdADHRQ0RSljSCGgX
	K2F4a
X-Gm-Gg: AYBFou2uQfQsAd0knTXCl8EeCQg9XwLiP80a9xw01gCnUQFmUr42hNCIIdrpfFsGeiX
	OQIAxrNDyeY0TDL3eyiII4rpt6o5zGAeeoDWnyv/ipIKyg6QrtQc/bhBeKaSA3OHt2XRhWddRen
	oSCe3LEEZgfg2uAlHET2AMMQvSVz0USHq/UO8Rg/c8JhJRZTcQzr5PJ9PY9cGGPiAymEX5XyCFK
	Bj+mp3JPPnhd/b/k2d7DyhWmVRb3p1OoGxdp1iNBJmNLVauahjasskRRJ1iJJivxf54h+Vg5xKV
	DVTdeMWtMJpxOmguJpxyqK3z8TcjxdPjAFD4Ue5A4qI0va3R1P+0G6UrDkmPu3kKs13lGwE+yu7
	ceo9YFYaWJRoJKT/Uq1JU6u2cc5EqdkroUeXn6YZ8x0GdhXMlS8VO+awYlnirTbYkCTBLKLFU82
	p30kW5AUyZoP3wmcuw9PZCNlJhqFR61m02SqhjHMed8ph9rbI2nNIs7xOy3Pj82tFdBOIFMHE0f
	4UbvpTkiHtX/PRLkjgf81Xdqt3uf1fCX91lqDGEAmLzMeSMxQUP2qwtNMvpqXQcnSl7LFGn+kd0
	4DL8Qw/SyduCS8ejDI25IJ+Um0JKM3T6APu+6L1A5+S10oIIdbpJqsvQdBhceTsXUbo1KhxmJog
	vxiULfGPgUDVPHzcCp918+Gl/yVRNiY0Y9u66
X-Received: by 2002:a05:622a:58c:b0:535:a5fb:6459 with SMTP id d75a77b69052e-55ac8e98474mr80004781cf.68.1794640231712;
        Fri, 13 Nov 2026 23:10:31 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:31 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 13/22] mm/hugetlb: restrict pool growth to common memory
Date: Sat, 14 Nov 2026 02:09:50 -0500
Message-ID: <20261114070959.3490008-14-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6pp8fdmt5f8hee6dmkww8sghetwxbh57
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BB4A6100003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794640232-419131
X-HE-Meta: U2FsdGVkX1+XHupBjVji1V3pls4cxen4Lv8ntY7nE2V6lsSVBNv9sghboEq9mnz8AOccgeau/TQQE6lb89hAhhSqSw8RVw9WLZ0N+tem4HI2Mkv0Ss0S5kcW5XWoVwERbV7EAulaVHV0SYWpKAx9dtCBU3ffC7xXBFZFAaMQO9tZJY548I4Eu+QfwTWMj6E3oSTy5/AsxK2CWG7ljWFpzkYnzLPDf5bTi5/lq26D0etDzwgYdrIixt+vntB00YuRwlow8p1GpmpiaDcURyD5xTZDsUebBBkCDg3ONn5iwSekkc9pYFoDel1mH0iVcoMXTBUpjMmuih43qk3InY7Sqj7xzAvCPb/pI7K6RWbrIim1g6rshiz+6ChBLXmTxW90OWrrpZQO5qCKp5JwJ94G5neecN3IMx1yw9Lvs+enrKLFS0/u7CCIk0LUO14eF+hQbXRJ2b2O6q9OExrvymY0AMAiw9g9HxsUghmZxWYVhIloxpnFgxWFYWfy/tLaQ4f+oNyyXVOyLge/3z7Kro6m0CyGoRB8/xFiL1s8ZiWvJAfdRXN8s2WXu7tPKCaI8u1rdqfaTUz/mjviksjmrWBnZEkyPAKAzJ3oTi8Ieocpgf/exnag2VH4hAQKCYZltWnLqo9BcgIJw0PsmrlXfgQixPpeAJH0DnJO/reaWjYOpXG/w0mqMHSrTHkfphhJn5SakKmEqxpPkYRgzjUaQVN4BfiLvpDVlwXVDIpV3pVfgnFuJq42ClBbZaXzIlMzU48YyCEnW7mG/i40PopCIB4QugvjM9XOA9OwWlrbafNy3vi4xsnx7CRX2HOPKjtGre2VLO5wlZtWsf7EVCvdCu87xkVqKjskLY8B4/9/WodOUgi9lQhTvwktq6wR7hrT0r7AYzOFveCO0/PBzfuvzapHYz1H7Hgd5+8CSjn15PyJsfduPgWOjsg38nSJPiut+ggesgzwn7MSXXghjYKeJQz
 y50wRmaI
 RRW0lF/mSPP9fhLGzWJ4RpbmqmxyaKw1DonWU6AoDCkBgepBJAKuLLRU/fTR44Yw9SnQgicHA6jmHG4DqET9UO6TTiMIKXB8RTZwQaKNXCamMBnxNZygQgvFNTu4X4USZTMolzt7OwoXgSaD0GF+3KovsolCylBL15XOZ7eWKrS/4vcUID3CpmWwcHCmqVeax1/oP/1/PhswtSNWcvseMfSMu2KS29AY6N2AI5DZrbD1jT5PWptjSH1MxvcTY8sFyGXKMjsHDRCf9yds1RGRgnIRmlBqneNbwQK+Yvz/FLGVYEr8F5+Txqpw2zHxT8z/9Q4UZAdrAHXGngz+/vkI6W3yJ3ougQeUxaletG8ttfvxZFZYx9ZVVHF3MaEndcjAJCPqz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fresh HugeTLB pool folios come from ordinary allocations, which only
N_MEMORY_COMMON nodes serve.

Restrict HugeTLB allocations and pool-growth to N_MEMORY_COMMON nodes.

Keep the original allowed mask for pool shrinking and demotion so
existing pool folios can still be found on any online-memory node.

The result of this change is that hugepage allocations will fail on
nodes without N_MEMORY_COMMON.  This restriction can be loosened later
when/if it grows a user.

All memory is common at this point, so behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/hugetlb.c | 44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cb2de24affdc4..cc1468f68901b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3452,13 +3452,13 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
 			gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 
 			folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
-					&node_states[N_MEMORY], NULL);
+					&node_states[N_MEMORY_COMMON], NULL);
 			if (!folio && !list_empty(&folio_list) &&
 			    hugetlb_vmemmap_optimizable(h)) {
 				prep_and_add_allocated_folios(h, &folio_list);
 				INIT_LIST_HEAD(&folio_list);
 				folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
-						&node_states[N_MEMORY], NULL);
+						&node_states[N_MEMORY_COMMON], NULL);
 			}
 			if (!folio)
 				break;
@@ -3528,7 +3528,7 @@ static void __init hugetlb_pages_alloc_boot_node(unsigned long start, unsigned l
 			prep_and_add_allocated_folios(h, &folio_list);
 			INIT_LIST_HEAD(&folio_list);
 		}
-		folio = alloc_pool_huge_folio(h, &node_states[N_MEMORY],
+		folio = alloc_pool_huge_folio(h, &node_states[N_MEMORY_COMMON],
 						&node_alloc_noretry, &next_node);
 		if (!folio)
 			break;
@@ -3672,13 +3672,12 @@ static void __init hugetlb_init_hstates(void)
 
 	for_each_hstate(h) {
 		/*
-		 * Always reset to first_memory_node here, even if
-		 * next_nid_to_alloc was set before - we can't
-		 * reference hugetlb_bootmem_nodes after init, and
-		 * first_memory_node is right for all further allocations.
+		 * Always reset the allocation cursor here, even if it was set
+		 * before: hugetlb_bootmem_nodes cannot be referenced after init,
+		 * and further pool allocations use common memory.
 		 */
-		h->next_nid_to_alloc = first_memory_node;
-		h->next_nid_to_free = first_memory_node;
+		h->next_nid_to_alloc = first_node_state(N_MEMORY_COMMON);
+		h->next_nid_to_free = first_node_state(N_MEMORY_COMMON);
 
 		/* oversize hugepages were init'ed in early boot */
 		if (!hstate_is_gigantic(h))
@@ -3802,23 +3801,21 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 	unsigned long allocated;
 	struct folio *folio;
 	LIST_HEAD(page_list);
-	NODEMASK_ALLOC(nodemask_t, node_alloc_noretry, GFP_KERNEL);
+	NODEMASK_ALLOC(struct nodemask_scratch, scratch, GFP_KERNEL);
 
-	/*
-	 * Bit mask controlling how hard we retry per-node allocations.
-	 * If we can not allocate the bit mask, do not attempt to allocate
-	 * the requested huge pages.
-	 */
-	if (node_alloc_noretry)
-		nodes_clear(*node_alloc_noretry);
-	else
+	/* Scratch masks for allocation eligibility and per-node retries. */
+	if (!scratch)
 		return -ENOMEM;
+	nodes_clear(scratch->mask2);
 
 	/*
 	 * resize_lock mutex prevents concurrent adjustments to number of
 	 * pages in hstate via the proc/sysfs interfaces.
 	 */
 	mutex_lock(&h->resize_lock);
+
+	/* Fresh pool pages come from the ordinary allocation domain. */
+	nodes_and(scratch->mask1, *nodes_allowed, node_states[N_MEMORY_COMMON]);
 	flush_free_hpage_work(h);
 	spin_lock_irq(&hugetlb_lock);
 
@@ -3855,7 +3852,7 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 		if (count > persistent_huge_pages(h)) {
 			spin_unlock_irq(&hugetlb_lock);
 			mutex_unlock(&h->resize_lock);
-			NODEMASK_FREE(node_alloc_noretry);
+			NODEMASK_FREE(scratch);
 			return -EINVAL;
 		}
 		/* Fall through to decrease pool */
@@ -3873,7 +3870,7 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 	 * within all the constraints specified by the sysctls.
 	 */
 	while (h->surplus_huge_pages && count > persistent_huge_pages(h)) {
-		if (!adjust_pool_surplus(h, nodes_allowed, -1))
+		if (!adjust_pool_surplus(h, &scratch->mask1, -1))
 			break;
 	}
 
@@ -3889,9 +3886,8 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 		/* yield cpu to avoid soft lockup */
 		cond_resched();
 
-		folio = alloc_pool_huge_folio(h, nodes_allowed,
-						node_alloc_noretry,
-						&h->next_nid_to_alloc);
+		folio = alloc_pool_huge_folio(h, &scratch->mask1, &scratch->mask2,
+					      &h->next_nid_to_alloc);
 		if (!folio) {
 			prep_and_add_allocated_folios(h, &page_list);
 			spin_lock_irq(&hugetlb_lock);
@@ -3978,7 +3974,7 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 	spin_unlock_irq(&hugetlb_lock);
 	mutex_unlock(&h->resize_lock);
 
-	NODEMASK_FREE(node_alloc_noretry);
+	NODEMASK_FREE(scratch);
 
 	return 0;
 }
-- 
2.53.1-Meta


