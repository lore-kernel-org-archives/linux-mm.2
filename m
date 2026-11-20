Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E9A60A2619
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=E26qAPfr
Received: by kanga.kvack.org (Postfix)
	id 3AFDB6B05B8; Fri, 20 Nov 2026 05:09:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339166B05B9; Fri, 20 Nov 2026 05:09:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 228576B05BA; Fri, 20 Nov 2026 05:09:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E61836B05B8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:09:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A417160EA1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:09:38 +0000 (UTC)
X-FDA: 85455075636.02.3F82C86
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 28E6F1C0008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:09:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=E26qAPfr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169376;
	b=K4JrFZOrINuh+FGUPVLuu1ip8+RAlXeZgSc1X+SEkEIMrSDZvwUpl8fdfOIQs77gdxV/eu
	YBnGmHePBIO5sCXK5PlZPeqTsmk2Z+FmPuTYQPUZSPJ4Rrm3sNRjFe9pUmjzTSy5Qxm4TF
	dC77Yv6C6vTv8vMMkl0LfWxk7Ij+ObY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0M97I6v0mM+QmRgb7kh7Im8w/4SIvsqvU/x63FN1U0=;
	b=S4Qio38uejwO3BDZ7kHh7UABansNEwTrrdwBn4MnZeSuK0plTwjxeN/Q567m68T2j7isH+
	n7Fn4nA7JLQxFSuLxVwJ9CPhN0ggsCwvYd14lx5TqTWok+aBino6oWLSB122TZsLwoGFvM
	EaDmfackSptwjObMIJIc0e1cKE9zCcA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=E26qAPfr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3b3af93b85cso468567a91.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795169375; x=1795774175; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n0M97I6v0mM+QmRgb7kh7Im8w/4SIvsqvU/x63FN1U0=;
        b=E26qAPfrlWrOvlT5UhZh6S3KxC2PrzWc0cbnWRR+KN5d0t27YxxUv0TFDV4V/ctd5s
         BwdW/sre+qd8CVFPau3UOvP/NA9E7eMmA2LoohDHRdv+BtorzvtteEp00ULTnQqcWYwH
         U3ZV0njODShPtuuUuwmq065KC0sT2QhS0AFTL+tNwYL5HqAR5XHPA+KDV/O08csCUyv6
         iH7XV5G9hNlvym2vJP9wAnVEYlIesuAuVGN+KheNDT9hdNvQEPY5wuK+EqncUS+Z7bdK
         aCC5sMQeod/U9cKkESV1oHhPXojFNQ5RGItgui30MTtauAWHsZGUFuwBlfuDFoOj6J/u
         4+wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795169375; x=1795774175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n0M97I6v0mM+QmRgb7kh7Im8w/4SIvsqvU/x63FN1U0=;
        b=NIfy1Hl16mp+r4qsOsX9WR32k2fkA4/uFLF9+wJpFkIFEQYOYbGboHD67B7UaazZx4
         un1HY/hbjROnHBXxfLZbghhJzP/jipzqZS6ROcFq1NadNfQ9iqhcIpBdMiGOm/VpDNQ7
         FFziqXwzKkY+2GH5DM+uzNe/lhK45MVkrPO1dLiMW7fj03iIrESx2wV8X0HfUx0nEyPn
         RdvGpsuTO5Ezpp00EZzNI9rSt5SYzU04MZnGtsxFRBUXxE61JKWuB4Fx/M912/qPkzdd
         9zEdYUyQfN/wfLUpVjhh3XJnl/NDHEjlgOcOIDgU99AUaVJPGlp6b+F+mChZcuYwJq+U
         Jftw==
X-Forwarded-Encrypted: i=1; AL+hErGTSvEKX/RQutZHYEzoakaV6lIyQ7BK5uiUgo9dI+uEML6zxfzJzBzsEaRGeauFTnMNwcRefaI9oQ==@kvack.org
X-Gm-Message-State: APuU4Z+9gsrJMsaaLMwA5KjogEO0ZBY8GJys4ek4qclaPI3spNLdMsLj
	o3aZjBz6i35oGGgawa4omGuDpEblUMocYth4VxeJ8m/suslCL/69l2WaC1u20Rjmj2c=
X-Gm-Gg: AZFdTZe6V4y6dbhxlSbSZ35S82Q2s2vn3FWpZZ+/txJJ68OXnI6ZIzmasbliGDlKz9r
	iG75eIeHxwGo9NCjiXMAxFCSSelVNJFtx4Pbp/w5chJId+xvrcEb6Pco9ZJ3F8XX31RtiVoViHT
	TIl8sLPxAuHxfyzkLfuBvfPYcK7ApPEp/P6sH3Rr+MjOAgcmcuJ6ulbx5zSaMLATQZ5h85X2ZTJ
	jDRSms7Nx5AQq70USwX0OzFM0Yaaw/ax+LsMoBHPVtQ3StxV2BcnF6lvBqutNZbhthKlTzK7gmc
	g/N3oPRRRwVTsHB1p3xsuJ3nmVqWQaoqsm0QPvKxEd3Zd9Jz2cNVa9NFTZ6WL77F7ftZ2l49Be9
	70DZ9vXdCv4UNXD1xhEp+tQ2VHY80nm7Fr1ek8CVGzHCUvium55TmDX55yXeaMlpzVhQsX0GTkO
	v9V5QJ87SwSWVCw4ijBk9fsNddrV7+fGj9vs49sYptfoll39aUQMvQvVqXX8+y+681oKsGh+70E
	U3UkkRLjNX9x1GnUjcfZAzBUVY+KvoLjolIqgr2PLJO6rvPp7o3NcTPn++DZb+R5HGsTMnJ497L
	NNMswS245PgsJb6T3VT6hF6UNlLilpNZGE6JQruxMxxhx3iGGEvHswyZx61EYVwZ2+HY1Q==
X-Received: by 2002:a17:90b:442c:b0:3b4:a90:7f30 with SMTP id 98e67ed59e1d1-3b41c9802e1mr2330494a91.55.1795169374795;
        Fri, 20 Nov 2026 02:09:34 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([203.208.167.151])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm3727321a91.17.2026.11.20.02.09.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:09:34 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 03/11] mm/mm_init: simplify zone device page initialization
Date: Fri, 20 Nov 2026 18:08:48 +0800
Message-ID: <20261120100856.16929-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120100856.16929-1-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 28E6F1C0008
X-Stat-Signature: gfh1ioh5gdhgi3ibhpexjo5hn4i6wbsw
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795169376-323874
X-HE-Meta: U2FsdGVkX18pvR+SXvWEQ31h2D8DPceWWlJOiNwzjR3M6uzNw39HYsL9RJ1dKYOwSccqNSzFDhkU0Wc1+8vK+03bfpvRnNokvEXv2zGWwMOVq525TTqLnEoDRR7nRV7mLCIEdHzeudqIisNEofLHfzCl9VRCNarcfBHaEy01AqtJ4pXoTuTwBoEaoJ4EaY6Ji1WyG8mVvY/cRHvs5GF4p46WB/HWF/o7xupPtWb7vB3sOaVWgIRGEMqN1M/w4ztnMPRxSbw+v4cPq4IAKiP6qdlhAw33xWczTqwVjt6EcNDsTsB/vAIycG+0w+gC7owk/KZyj7ZheCHLpMsW89GWiQWwQsgywTEoDXaosL52ILPOF0DQlyooFsjgF+BnIEBYw165csb1+xf9P83PqSugnFsLgVl/qW+NcpU58Xxndzs4l13rte1goFPcA6cGSncf+20jnqZlTVsSjjjSGT3ey1ZfRxc/lOTm9iDSSa2arGp2kVBNPmkul6cNjzjP/iU6EYOfpy/IlhJy2xwUVOtXYXl8a1NQTsYPxkHFjh89OTchwpThWGmB/ILo4oEEY85WyCwCmzBm++plhZYCY42h/jOakiXbKanWn9foQyawAnsGGj7ub4BgooQwkEqSlSdBmVhtDYmHY+dC+r6Pioe99zGrOzmLXxO9USlEaAYKg6SJtouvV90OFb914N5sQz06fPcmd8ZkFSz0sVeN6DgWzQzhweAhjLdZjxmMulzyz5A5T9HAjApeqcYOl76iEawCR0T3hzdk6ykbMzBmxb2zbA0F5hYrr7KXxmNSeqxFI/lWavg7gb2RfokhBDam4xNI/dheooHfLCc+oLexfBUO8H4vy9ZNi7vl3N4li+NyYVzq1EPCPvaWVi6xjsBvqlIvlP340jx35i8+CQYvUFufEX8Ufbz4cnDzxpT8wMsDQGws5Q29YgQCGS84a3w7FJgzyI64SvQmMOxPYH3ywG9
 tAc3S7es
 pRBWh8yi5q9vzab3AQJE9Hz86xhWHA+KJ7zZZOSt6BneKEG6q4nXEpZK8w9ob9kJ1hR5Cam5i11e15i8C+O1lkaW67VJxehABPYIVwBLEwXuf44wyTN0TEYuu4wlqQvztJdynzX68Bh+NNswhh9+x5L+chs7/XdrkEwPERbvPGvZ2/fE3j7j6d+pv5t9hmFGw3DBXpSStO16yjfw14oC2p8SRNgAI6R95neEYHzSAmBKWlcUOIghLa0UbYFnlKhpoAPk8+8uILlm9U36BdnBIMe21xfzNf92oTIPRbPcKHyyG+AELgJdurAPJwDcsJwPfE8NVWgtNar2tLx2VMsQIUO4cDTDrRzMaBOpd2lwfct7ByrUVJnGHdUdTVQ7i5sX7GwPkGHtaSOaVQ0DLr64nLFzheyVP8lBTFqzjYeICztzupFtrHWdNm9vmVBZqhvyPhkHXpCQd6UGbyk2hIoDwRlRq/C75J+cYa8HSY30au0eVIxsr0OnM020C/K2E8XEjcOttWlXDESbEIr0XMczlUjbvpTz6Di8k+qJBtB+hySmdR8ROLZDyXlONZjiqfekpHitEk2cKuCjk7gtcE64kQXZE6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memmap_init_zone_device() currently seeds its reusable head and tail
templates by fully initializing the first real struct page and copying
it back into a stack object. This keeps the first page outside the
common loops and leaves __init_zone_device_page() only for template
construction.

Build both templates directly from the PFN-independent state. Add the
head-specific pgmap and refcount state to the head template and the
compound metadata to the tail template, then initialize every page
through zone_device_page_init_from_template().

This removes the special handling for the first head and tail pages
without changing their final state.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v3:
- Rebase on zone_device_page_init_from_template() after integrating the
  template helper series (suggested by Mike Rapoport)

v2:
- Rebase on memmap_init_page_from_template().
---
 mm/mm_init.c | 94 ++++++++--------------------------------------------
 1 file changed, 14 insertions(+), 80 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 08d6e47bde22..75d8d17601ed 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1036,48 +1036,6 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
-					  unsigned long zone_idx, int nid,
-					  struct dev_pagemap *pgmap)
-{
-
-	__init_single_page(page, pfn, zone_idx, nid);
-
-	/*
-	 * Mark page reserved as it will need to wait for onlining
-	 * phase for it to be fully associated with a zone.
-	 *
-	 * We can use the non-atomic __set_bit operation for setting
-	 * the flag as we are still initializing the pages.
-	 */
-	__SetPageReserved(page);
-
-	/*
-	 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer
-	 * and zone_device_data.  It is a bug if a ZONE_DEVICE page is
-	 * ever freed or placed on a driver-private list.
-	 */
-	page_folio(page)->pgmap = pgmap;
-	page->zone_device_data = NULL;
-
-	/*
-	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
-	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
-	 * the count again when the allocator or driver hands the page out.
-	 */
-	switch (pgmap->type) {
-	case MEMORY_DEVICE_FS_DAX:
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_COHERENT:
-	case MEMORY_DEVICE_PCI_P2PDMA:
-		set_page_count(page, 0);
-		break;
-
-	case MEMORY_DEVICE_GENERIC:
-		break;
-	}
-}
-
 static void zone_device_page_init_from_template(struct page *page,
 		unsigned long pfn, struct page *template)
 {
@@ -1118,30 +1076,13 @@ static void __ref memmap_init_compound(struct page *head,
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
 	struct page template;
-	struct page *page;
 
-	/*
-	 * We have to initialize the pages, including setting up page links.
-	 * prep_compound_page() does not take care of that, so instead we
-	 * open-code prep_compound_page() so we can take care of initializing
-	 * the pages in the same go.
-	 */
-	__SetPageHead(head);
-
-	/*
-	 * All tails of the same compound page share the state established by
-	 * prep_compound_tail(). Reuse one tail template for the whole range and
-	 * refresh only the PFN-dependent fields in that template before each copy.
-	 */
-	pfn = head_pfn + 1;
-	page = pfn_to_page(pfn);
-	__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-	prep_compound_tail(page, head, order);
-	set_page_count(page, 0);
-	memcpy(&template, page, sizeof(*page));
+	memmap_init_page(&template, zone_idx, nid);
+	prep_compound_tail(&template, head, order);
 
-	/* Initialize the remaining tail pages from template. */
-	for (pfn = head_pfn + 2; pfn < end_pfn; pfn++)
+	__SetPageHead(head);
+	/* Initialize the tail pages from template. */
+	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++)
 		zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
 						    &template);
 	prep_compound_head(head, order);
@@ -1175,27 +1116,20 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		nr_pages = end_pfn - start_pfn;
 	}
 
-	if (!nr_pages)
-		return;
-
 	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));
 
+	memmap_init_page(&template, zone_idx, nid);
+	page_folio(&template)->pgmap = pgmap;
 	/*
-	 * Seed the reusable head-page template from the first real struct
-	 * page. The normal page-init and refcount helpers must operate on
-	 * a real memmap entry rather than a stack object.
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of one in the free
+	 * path. The remaining ZONE_DEVICE types start from zero here and raise
+	 * the count again when the allocator or driver hands the page out.
 	 */
-	pfn = start_pfn;
-	page = pfn_to_page(pfn);
-	__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-	memcpy(&template, page, sizeof(*page));
-	if (pfns_per_compound != 1)
-		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, pgmap));
-	pfn += pfns_per_compound;
+	if (pgmap->type == MEMORY_DEVICE_GENERIC)
+		atomic_set(&template._refcount, 1);
 
-	/* Initialize the remaining head pages from template. */
-	for (; pfn < end_pfn; pfn += pfns_per_compound) {
+	/* Initialize the head pages from template. */
+	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		page = pfn_to_page(pfn);
 
 		zone_device_page_init_from_template(page, pfn, &template);
-- 
2.54.0


