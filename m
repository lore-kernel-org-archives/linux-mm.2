Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22D1606A33E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=eBXA9Wc6
Received: by kanga.kvack.org (Postfix)
	id 773C36B05CB; Mon,  9 Nov 2026 04:58:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B766B05CC; Mon,  9 Nov 2026 04:58:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689356B05CD; Mon,  9 Nov 2026 04:58:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 430B06B05CB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:58:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8C22A0629
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:33 +0000 (UTC)
X-FDA: 85415130906.11.5441C7D
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 88FE240003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:58:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eBXA9Wc6;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZTW9tD9mNMY5t4i8EBaHTJulg/a3E+adgD2YdbO2jyc=;
	b=7lKwcMDEX4zHO6sngKP0+Qc3SjZX2GPzFr6mPlN17maCL1OSnWz4Vw02hwMSMZRMeUyQ6y
	758spYhQ7a6CVNIbu8QdULLfABz+MyLQrYcH/DEOjLB4CFdtPMGlMPhxzxRNT22/TI0DDP
	VBdsw5q0DtXlBodjGBJeBeidrNyNgfE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eBXA9Wc6;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218312;
	b=zDxNLc7AB4HbvqGtcNh+lYrB/fxQ0IPijHXamo5x2D3dbVlZAcFYTwnGIIcZFOFHXVlP/6
	O4YG10gCvR0DPJPY270fGZt1WfQSheXVzARCmCIslDBXQdgEoYulANG+RgyVCodquVJztw
	w/W1CY7Wa7N4jDPsIg8T7707mHbTuNw=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1a8cc11ac42so484000c88.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794218310; x=1794823110; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZTW9tD9mNMY5t4i8EBaHTJulg/a3E+adgD2YdbO2jyc=;
        b=eBXA9Wc6PPBhA3379RV/xEwOlW81Fg39CN3CHkcV+Vbgc1RqQB5LU7YBdNTGyE56Nx
         K2KQyh5VmafgKcf6UedEeA91amzIklgLO3aZfrESRT2SuDvIzCG7zBGn6gm1dD7Tm15+
         BYccJ2ZYcMlJ5gxhu6xjgFQ+BMZDD+KEy14xwV/a4g9njZagfUjJKOMDaO5CuKBelPnN
         xRKm+1Zbb0ZBpo3HQk7NH1M1qeNaeI4fZObE14zjD5Z9CJ1fVN9FAP8ruxau8B6X4Gwc
         +3b825E31rNiNfWkEmMHeRVAL+2SKq67MoPsyoZSDu6lwcv1eoISIuuScmDJXYi/gJ4F
         RlPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794218310; x=1794823110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZTW9tD9mNMY5t4i8EBaHTJulg/a3E+adgD2YdbO2jyc=;
        b=EskbuN3GXAmffbxmVKixqM4FCEAchM1TIGMIDSDLzrosWphfMSQrJNAnjclDuumnj0
         u7yqcyJ3VduW0TQCS501xpvYiOgqmynmuXeYtThVJEgl/9Imi9uoWxyTK2hyC93sj28/
         9wzjuPW41f2P4HvKcjFwJR6OVhYDRc08rcGgmfcWxZhOQ+jyR/EJYHt6Hc8e1l0vfuF9
         gaj3t1g6I9psaMNNHOGyjEBVzqcdPWj/+BvhN9rbJBEnU801FRJz4Kuf8gAbRpBGk8+O
         GhZRVR+nNkSQBVwkr/ZwmgbXvQme/M7PRvWiDDyr8QEXXpgVQI7K6FtBXzRYNpCKVcut
         B9aQ==
X-Forwarded-Encrypted: i=1; AL+hErGAWD9DqYXlW5+cNNbtA/1Jj61SL9PfCw6SfyzQzGbc+li4hMWoc+ESkxIoNwGO1nPzSVMeqsPh8g==@kvack.org
X-Gm-Message-State: APuU4Z+Y99neNNGmLfiXwbIqqKKg6V4npZkaa7oDmNgAuTN2ismBpp6V
	MQOiCoJrVXmrS0qrWaTCWphlBhU7UDbpDuC9jfkr3SQNF3tYelp9AbO5EOyMsWMKr1I=
X-Gm-Gg: AYBFou0Oq+qqq6XsXisW9hFObZzx3ibHWLWz7A0F/GNLQbK0L+LFYOlWff8tvNA+yvK
	dwgMYZBP0c+g6OMDxLdzhfKZh/eT8zFV8LXFpxmr87F3kHO3ggcjFg+iPd8hrncAwf/NRqpeDwR
	M8GgY0wxY+FS5FD8hX8yHTFJetbTKvLBX+abcTdIBL7B6qucJxVH5QVzHcFOJnv0l6JEYrACYPq
	CpMp+Lm33P0ohET8qbbi5ZuQPg8O46WvtzTM5ujiKNc0hkeHFn2nCQOYR6KKHf3Hk+WS5GqOMFI
	yGtxae4LKGkSdzIhkW39TL0bAt6v63pYAXhJuXIHjcnFXMMvPtuoFv2fsYszzzzJjpDlpKRlOUR
	LEmAKIHEcSA5RWS1n4Jr2LaA+w6gojRBvQbQJYE9tKzJkncoC2YZlueDYd+ElmqLMDNbOViwF9h
	PGveDXtp6tWwTcEOi6NDniP35MCYyJ2X0Yp+dSgja8+6+iwsTbEZ0NIu12Ch4hdJzDUZNoBsohs
	3pM2oDzCz2sDGjdnhhiWBmkX0XCHCuDZSBKISl7v99dAbCIJeFfwJ09bgX/V1zXTSiWTp6GYWfJ
	BTSH7Z9k1H2fP8xi7Rweha/1awkpL5ZF1nxPV5AG2n/Q7ydvDC3Fx8X36VQL1G5B/AuRzvrxIBx
	alCx89xY=
X-Received: by 2002:a05:7022:1114:b0:1b2:471f:c4c with SMTP id a92af1059eb24-1b39feabda0mr5619021c88.19.1794218309995;
        Mon, 09 Nov 2026 01:58:29 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3755e8911sm12841684c88.5.2026.11.09.01.58.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 01:58:29 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 03/11] mm/mm_init: simplify zone device page initialization
Date: Mon,  9 Nov 2026 17:57:58 +0800
Message-ID: <20261109095807.41547-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109095807.41547-1-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kewpt4bmfgc5ukf4jh61uxzqjfd15d6o
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 88FE240003
X-HE-Tag: 1794218311-691811
X-HE-Meta: U2FsdGVkX1/Mu2ISMGr6WoVk4vKLiV3WIdbabbuTHD6VsMMDmzoQ0OiCxTuiYzrZBBfzJFipd0r8mpDlLC6mclsug3xif4PG0MSQ1oZhFx6Pi1WZkCYoE0r0KYe01ksH8xaVXRbgzR6cZYKvoxdnlO47qdue8m0brFtzMue8S87xLo6jJOUC1Thlt2V+UqT9aYT8gfQnYSGYQA52Ycbr0jWiKt2Moxq5jS4IoD0J3DPemcPhmGYhddDAY0emWfZ+jXSMZovnlKs7q+g084DliT1Jf+Ap7lnYASZk7HaMyuJfB3j5+KNTz/j8rJEtWpaKf6l+3MNEyw3azXLK6Bv3koP3NferHfSFqORKdcUMu+5yuawQl44U+txRttU/5h6XIxOperMn4F+xvX90/ZpqK35FOpZKhUUtHmGQd+5CrOuZiHuzcu1AcP2MA8Qs5XPrTNk5wbNgm9wrQr6ILCoJ7PAeLXzWROMM5iolCVkVd0Nb8ApAEaedZrnDc0xHU1YC8qpcFEaXKaFC1tTDrCPKYEg2O1vi6PXZmxYtLF2rJ8wNmhIaE4wyv058GhSRRXD9rCFQZiQUgBYYP5YQtUd8aq3833v27cJLJRdYxeDlCO3PsLnbfZsQhwIYtrTeOCbuGfISRk2ZomABrdAnHaEaPmTmUgC8nbaKB94+iPrcQyx7Z3RE9momgFTw+iTwnPrTTFKETAs1vncQfy5Z0rfhQnDQImttZEgaxpUQ0sOb5sJt5MEqXR1I6efGjs1532BO8SjfRYGkk1L1ddnl+TDeeq8bB04LZ0YvngD4sKiG4r+guLsAxJXq2hHK09GOYhTURn34i2IO8T7+xIA3bWa2bOtOlQDxxDptPd7lUGmRJ18X1FJS1kvjKWI9rXPUhCA1DG45qZ3so6wqVNkK6fJttLpEAsUMHlEJJmdcSv/df48+cGk5a0E0KQ9P8ZUNLSyWycNMtdUnwom+MLC9PIM
 qTUm95GQ
 22Kw7GKMu6HZL3wZWQBofsnijq2m/3syaTcIGXdcn8dWZA+F94TjTU8l26NDilqYDKRXaRVP6CtJpWjryDbQIeZZOXTpSIQcdZvhk31S93OFDoydmniSvnW1C+wJkuJCmikzbA+9OJYGh1ujTUEMhA07GKrtKDzCWMki6JIiQNfwUD4L1Sb0sPrY/aMffVBO2rmiEf8Ig2fJw9c2ESHYigTZR6pI3PBAH7okUTEYFMEZs5GYwyLj8SgQU+nwewolrre2gNcCKvsBJX6TkXrkXvAykxFBWRt7Ye1YJoMfLAd+jeSeehR+8uYopy+O/7BvbdJ8Lb2dLIahy3LdIift7PVcd20hdWW7ZxzRCc4d7w2jLUeQ=
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
 mm/mm_init.c | 91 ++++++++--------------------------------------------
 1 file changed, 14 insertions(+), 77 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 9677698f30d3..6cf74f6840de 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1044,48 +1044,6 @@ static void __init memmap_init(void)
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
@@ -1126,30 +1084,13 @@ static void __ref memmap_init_compound(struct page *head,
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
+	memmap_init_page_common(&template, zone_idx, nid);
+	prep_compound_tail(&template, head, order);
 
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
-
-	/* Initialize the remaining tail pages from template. */
-	for (pfn = head_pfn + 2; pfn < end_pfn; pfn++)
+	__SetPageHead(head);
+	/* Initialize the tail pages from template. */
+	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++)
 		zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
 						    &template);
 	prep_compound_head(head, order);
@@ -1188,22 +1129,18 @@ void __ref memmap_init_zone_device(struct zone *zone,
 
 	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));
 
+	memmap_init_page_common(&template, zone_idx, nid);
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


