Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C204606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=TQcEhuYs
Received: by kanga.kvack.org (Postfix)
	id C9C1E6B05C1; Tue,  3 Nov 2026 21:36:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72BB6B05C2; Tue,  3 Nov 2026 21:36:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C1D6B05C3; Tue,  3 Nov 2026 21:36:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B31B6B05C1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9FA2160615
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:33 +0000 (UTC)
X-FDA: 85395873066.19.F8F4C57
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id 06D9B100002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TQcEhuYs;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793759792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzNBix1nrXAgkPziKzHxzDac28NAhHx2suDgNBU8pFw=;
	b=VkQRN+rDoKKfnIubd3hfye12yt9F0LkQQ0rC08AcgxDf3xANsH0maK97KElSO8sof3HH8Y
	Tw02ApMoL1oamegb60t8scYXNz2/Ogc+j1ef/L8Bg+GQQ2ReagD4cx6JiBS6aC8KdHLtmM
	GB/fS/pX3wsTgvycQgaJWuiZ2lIdlSM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TQcEhuYs;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793759792;
	b=1qRXikps0tEBMdmQjm3sEd4dH8dW616Vs5WdRPgHLEBdatffxeIqaBoql9n6a6YPpQeQmC
	ad5Emrp7fcg9gaSGCkVQ43q8tr0u4jhGAdEnZVaLbwPc5F2zrnbpgcNG4BO42HPVbGVSa/
	fWP31gPE1/RDt5hm8YLoeuIJlSJaVS4=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8a058f74a54so73072b3a.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 18:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793759791; x=1794364591; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yzNBix1nrXAgkPziKzHxzDac28NAhHx2suDgNBU8pFw=;
        b=TQcEhuYsOJZeYqYgLaa8X/lGg+e4Of2oIKyD0eMf/cgpgtWjYPb8J898KU/+YMQkzJ
         w88fQQZ9ofpHLXNfttNmunz0oN0nV0oNzBSimuJBqAzO+UCXfgb2MHmDppk7XxutgPe+
         Gq92R8E/sOVTx8AbsgjUK0bqZaL+FWLHjURS38NQAyDQnoi2CRYoV2qVzlOxgrfqm8kN
         obxEIh+C4cojQ/yR8yDYFldrZTt1XPIpP1nr3tq/okIhNNGY0UYYuJ1xV080Qr3d2QMy
         D31aROo54ilavGCgjZmR0kBC0jhu2S51qq8NYhuBUgOhsbrJyuToKZNYADZV9vPLz7kq
         DB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793759791; x=1794364591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yzNBix1nrXAgkPziKzHxzDac28NAhHx2suDgNBU8pFw=;
        b=c9D0UhHyQ2I24n0cU24NlvPPSvq9IIOl0rNAmUktJwEH+A4A2RkSEtmLctryx61Lk2
         RfAwGgQsJYKm8anTh2S73tkh0r3OgO0EGfvxTSRrs01fWgbdr8QRnRCw1eKRUFjAfcPG
         dYsNKJAHIM9/8/AcLFBVngb/AXNXNp/g8An75zjsNIRDGYLs824SxHA+wZAR12FuOtPW
         JzZUEdaxhxgm07Iiykh/biRAETQUC4Vv+3Ic4fD5D/c9X+rXt44mtLvroxWDmIoMWoUw
         ZEaH3v/UfeQHBw9v+HFu92rf/XM/kqOFJmHVB9TX1zrf4CTjSMYDcZW93vZgk0lRRsW4
         WJ/A==
X-Forwarded-Encrypted: i=1; AKwUvBy9IEDzLojX89zRe0zIwIn9ebDS5iTDI8C/4adcBIDvt5rih2SVWkLpmAN5/LY6BT4AzA1UPtTczg==@kvack.org
X-Gm-Message-State: APuU4Z9smwK426yLUdiZp/BDpZPFpMuVO8wXKRSaVmaQdMPDpDZjk6bl
	usfLNScYPrLXSP6qGxY+3PajCNkGGL+mq7E/j2qVIWwOUzKJ0nak47JBNbPvf/sWdfY=
X-Gm-Gg: AYBFou1JcjVvmZYiYLaGTBNtwJT/7860zUBuMSOZEZvuDxWqYjkv6mQ/nEki4cFDfSG
	uhVAdqONse+RbXrDFvzuETzHhDMB1nMZk8Gs2pjrpCX0n+vBlXSDPaUbrTUC49FdvFKHtOqlQLk
	V+BIpqe8zf/bFhpGiM3JG/L8QkJ5tTrScf/dXrOyq/pomOr4VKsuo5qCLDCNLJvpaLUBkY4kRDJ
	tdxf4bdkEA5BaMgXiZp+ctnHv+vRHHMI0H4/lO1BRPgfwW5RJfD9plXeacdG8t4PP4RgE+Ilgzq
	HlV3+UrfrB6AVD0biVcqQ3OdKQ8JCgDfGlWjNCwyFSVFrVyadYhyGshQE1RXgsZsBQGs7auBNGV
	3ejtzgtc9s6UPhSj1XWGkYPmf+nG42GMl+TYTcVA92SSMshXSu22OKSSvRiaSAS74zWZ4eh40O5
	91H91QwY28dAzSzf8b2mw6oDBOiU9RK2b6uvCwjpwkynYF9cSGYkvqviJIzu9cB/QqKAkLWwFjc
	m2sSOox3XkA+3ITe8DwB2AGwPyYVSa2rQYy1cOrbXogJ6E4YehLYTr1ho+If9HNuU0YoQyC5+yH
	NYXbHPn/d0+rwxi2t46GUSozWsQBArBChuqBZbiro0mYhoXnsw==
X-Received: by 2002:a05:6a00:1c85:b0:899:74d0:8a72 with SMTP id d2e1a72fcca58-8a9c0b796d7mr11334632b3a.59.1793759790744;
        Tue, 03 Nov 2026 18:36:30 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09bc3d1f2sm240815b3a.50.2026.11.03.18.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 18:36:30 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 12/12] mm: hugetlb_vmemmap: make vmemmap PTE conversion folio-oriented
Date: Wed,  4 Nov 2026 10:35:10 +0800
Message-ID: <20261104023510.260766-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104023510.260766-1-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 06D9B100002
X-Stat-Signature: k4egowj6bg4brj1kscx39311fq8tgboc
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793759791-171986
X-HE-Meta: U2FsdGVkX18UQGtlhJrVfZZndEdFeLnVZPeJ+b/ucA59DEAqKk7ROMuB1D5+K9em0mFNCcZFL/CMxeVdPxerou+0LUk3NmFijSsdbpVhdtaoZLcGAzM7TfbJJDhFb8idpdBACtTapy10LwrdHPwpCdlbmxjd9LTHSoijLvQhuHDJ16qii/VfuTiuTzidbdmMI0qR5U7GicZhW0loBENN7eUAtvMjzgZnh8Cby9eP+7zsjUZA/lt7ttBr/Juc+TwloOyS7LvOihvGF4kV0dopiOtwp3Ry3gpHm2UjJHfaFp6JipSZv8j4uFbveWf06gkrvVidx/vu+ZS1eSP6iw0JTqc+uENAmr7SUgsgQ8c3FKWf0d/5XS2yz1vigK1jt7Sbw186hb+qPkACEXJ5JsXAxUiObp6xCcaJnP/mBfjese4qS1YNxn3IW0KaqOg1dAak1gsvXX/Mh1TCBDAtrNM5k+HAWq/FYllPL84JDUcCs4Ng5MJ12owQAA8FZuwNT6EjtgrEPAR2uiWAxWCmvlwd532cHGYWQYjESEsWSoH43GuGtspoGgYRmIQgn21LuXDHVBEgsUWcoFCPmX45rrl7YDpo8UHxhg2yjCRBrgw/kNTgLcz1FiT7kRTZNQgxTngezkgC0FLPQBb/OE9KdYdG5FK1E3dwEM1DhRgg5CQwQm+73o9XkZpnTHO90LJtjBpp3mqwcMm7pvRxJM5SXhqS9lmzaS7Golh+friUkFyryq0bzziH+tETSwXONA5LXAm1QwSKHCyEPuZ0xaIh64pKdI8xrx6y83sWNPaityJ7VmDAeoJm+NbRUFPVccat6/2x5GsrlbOi7PmY00DZ9ZG1+7t6Lla2xTKl1SVABqALIdWQRKXUw5yjR0ygEVwaVh4ncxWfGfqTcOSD0gm/9srrJqZl3axcBEiE43ADm99GmA2HzcE2+cXgXIQc3GGWpUBzwUX/AMbOsCYT+6ZkVPm
 GAudUtUv
 V8nZUoBp3yn0FASJanqlUGNxsUwLi4NIQwqMNCberG/U79Uu66g0palSmjZemoyuyj3cx0JhGkBLFcsRx54vIpjyjGAvaLqXjZLEIi3QLqLLUc70Jj5GbLr0D16IvzZmAS2ysHoqoTp9gxUqWuIw7vv0ovEZ1iTbkxCGkuP2cJ9VXkRIIq5W5hbKHgl2RpO6nEdqTTPcwgp2fi+IZ6gQAn4V7RzoJLe+SkPYz2HTbBcO6Iy7HfnOEeNQ5tY3lECtqjwba1FeZVi95RbfSgUZwYYo4/uhJaV0kBY21TzdlD3W4lQlLQM/T/LPps7J3Xu+fw2obGdGH7KxfiV7801gC+sz99J1w8HAwdyF/QiC0od9G8sdRdlh+NnLtjKiboaguRAmM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Converting a folio's vmemmap mappings from PMDs to PTEs is a per-folio
operation, but the current interface exposes a raw address range and
hardcodes deferred TLB flushing.  This splits the common mechanism
across layers and couples it to the HugeTLB batching policy.

Make the folio the unit of PTE conversion and let callers select the TLB
flush policy through the folio-oriented interface.  This keeps
HugeTLB-specific eligibility and batching outside the common operation.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v3:
- Use two tabs for the new wrapper parameter continuation (suggested by
  Mike Rapoport)
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 0dcbc2b72384..17fac64d411f 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -300,20 +300,26 @@ static inline int vmemmap_restore_range(unsigned long start, unsigned long end,
 }
 
 /**
- * vmemmap_remap_split - split the vmemmap virtual address range [@start, @end)
- *                      backing PMDs of the directmap into PTEs
- * @start:     start address of the vmemmap virtual address range that we want
- *             to remap.
- * @end:       end address of the vmemmap virtual address range that we want to
- *             remap.
+ * vmemmap_pteify_folio - convert the vmemmap backing of a folio to PTE mappings
+ * @folio:	folio whose vmemmap range should be converted to PTE mappings.
+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
+ *
+ * Convert mappings covering @folio's vmemmap into PTE mappings. If TLB flushing
+ * is skipped, the caller must flush TLBs after all pteify operations are complete
+ * before remapping the folio's vmemmap pages.
+ *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_split(unsigned long start, unsigned long end)
+static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
 {
 	struct vmemmap_remap_walk walk = {
-		.remap_pte	= NULL,
-		.flags		= VMEMMAP_DEFER_TLB_FLUSH,
+		.flags		= flags,
 	};
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
+
+	if (!vmemmap_optimizable_order(folio_order(folio)))
+		return -EOPNOTSUPP;
 
 	return vmemmap_remap_range(start, end, &walk);
 }
@@ -532,21 +538,13 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
-static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *folio)
+static int hugetlb_vmemmap_pteify_folio(const struct hstate *h, struct folio *folio,
+		unsigned long flags)
 {
-	unsigned long vmemmap_start, vmemmap_end;
-
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return 0;
 
-	vmemmap_start	= (unsigned long)&folio->page;
-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	/*
-	 * Split PMDs on the vmemmap virtual address range [@vmemmap_start,
-	 * @vmemmap_end]
-	 */
-	return vmemmap_remap_split(vmemmap_start, vmemmap_end);
+	return vmemmap_pteify_folio(folio, flags);
 }
 
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
@@ -571,7 +569,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 
 		nr_to_optimize++;
 
-		ret = hugetlb_vmemmap_split_folio(h, folio);
+		ret = hugetlb_vmemmap_pteify_folio(h, folio, flags);
 
 		/*
 		 * Splitting the PMD requires allocating a page, thus let's fail
-- 
2.54.0


