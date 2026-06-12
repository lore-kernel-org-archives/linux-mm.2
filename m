Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD609CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 469A56B00B9; Fri, 12 Jun 2026 00:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41AC16B00BB; Fri, 12 Jun 2026 00:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 309F96B00BC; Fri, 12 Jun 2026 00:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF2F6B00B9
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:00:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1C3CC27E7
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:44 +0000 (UTC)
X-FDA: 84869909208.10.8F24DB6
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0211D1C000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KcAoAeAU;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pqeOYOFlkduDfAEfXJoLwswwYJKmlexz4b6SAwRMuQ=;
	b=gtFzE4tO2gH8eWZhId1Hce19Cg2Ys32uhA219z6rBwLUBQpxGWEvXF1YLKbvuvIsN605uF
	O0dHYp2ZWurW8ysNf5EFF+0cvqh3c/RkMrhtRbEr7/DODaCNKZpTj02LpLVWmPDNmPuJh3
	2hTRtTgbZDJDxNdcRzauF14ziv039mc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=KcAoAeAU;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236843;
	b=xNAeQUa6AXaF27vYNpKbE1YGfF2pT6eyh4uG3+o5fkAyEuPD45UWLJJPpE34HNqfoL4Dmv
	/Xb/uSreEinhLyZHBt+SzH/aml0aRDglb+j58SJ2B+2cTSxBSv/3KS2ZuWmW8eVL29yOL5
	LGcy/6G4woolRkZgFb8jB+zlDcWs+Vg=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-842848fd613so527325b3a.3
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236842; x=1781841642; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3pqeOYOFlkduDfAEfXJoLwswwYJKmlexz4b6SAwRMuQ=;
        b=KcAoAeAU9ODgw+5fFYnQc6lT16qMIox4jfVeHPRnMsQP7PuScZ3Rv/MAKz7WPtnBUn
         5SJIvZGbw7klR5rk9og8OoNJJ+J/T28vPLzgf8mY9sq/6uJVZcVah/tH6pljqsb3pw/L
         SQGX2Aj4R7KU8Bv0yDG0wQuYDg/Xz5QbstTbPyyZ6+LxoWWacy6azxQWR6YRh6Ngo6nW
         /Imc6G5q3jR6BgkasAiTOx5bUgL05V6C9Cl/QOQA1UfrUofLXbd5kGRgI1mNOUTFtTzN
         alFOHrM8Q6JzwI72CPjAdsVK3jegL0v6M3SLV+7exU7WrP768wYFpCPd51iNk1O3FUnO
         9Ujg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236842; x=1781841642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3pqeOYOFlkduDfAEfXJoLwswwYJKmlexz4b6SAwRMuQ=;
        b=E9u/JQP3K40EGDdnQczPs0Q38io3al/YVbii0+GgMMG+AWBW0GikQ90RezCwc+/bLl
         THVMlk0uSXY5NtD20IWeSDlNPa8/yozonmZebZcgKrVZokInqDkCoc/Tu5o5MBC1am70
         p3MjxOmYJ5tOk6kijkImavD3dMUA0ZRwfhf3EiSOqm+Vvb6zKPWRk9bl80QwqC8jwdj+
         DSt1te7GSDzystOcTcISVsgeppMVOiWG1TPWTknTvVWjKzZFC/jIoSTowc9l/uvZM399
         g7b4BldU9eV7ddu8qROAAUecV7y/MbbswZ3mnkyK2Ri/2Qf3bPg74CPEwTBC+NbRLTiY
         uQtA==
X-Forwarded-Encrypted: i=1; AFNElJ/Y0/dS9vT5jPvQv9o0IJIUD7oMHT/HeNAsWtBKWpnrkRwkKp83sA+gyppehzHa7cqT6iBnShFloQ==@kvack.org
X-Gm-Message-State: AOJu0YxOc01keJcE7yJTCUli6fsVpyatlS4EOJMVD0p9yDPt5f2cf5av
	pxfPbCKMPJTSipzeKM0WoeT/yI0BXJTvpb+tf3xnkscv6HNfGplmxDAjL616JYuBDNw=
X-Gm-Gg: Acq92OGaI5QrIorpN9IKE6wKEgF6Dm4AI6jHZORDO8/NFYvB8VLJciOZsyUwekwwUwb
	uM6RpSTYpS92R+gzZuPINM6veS/St/CUAkjjKQj9sAAEk1mdWdsj8C2u7jxu6D8S8tMOi//eDYm
	1hZpxCUpyge4MGkzwVnreP7xQyju3uSU3P2fIyx6QhKdGwu/7QoXLTrVZExgmrG/il2Q5yEHCHj
	UevHWQsu9vFsl/q9OptXJZkiL79DQ4BtdbXadzTZ+CiAcy4CaXmtAljOhA4zPFkDbm8z1bsoq0z
	zalKzvgzg4VpZ14qGaHoJdYRPb8hCB8tjQBM3kDS/j05w8vjZClWB4Uzl65WqkoUog4fapph86T
	AYNed9uVG7vdh5RfBuouJq9gE6HqE10tvNonDmjeNiVG5YNG/IlycteaEAl7ljk1dqBCIfwyKCR
	4e5PX7RVwvc4xMLvlLzaE9fAmzUxsm6iZBuYo1SdfaYwU=
X-Received: by 2002:a05:6a00:2d95:b0:841:dcbf:e82b with SMTP id d2e1a72fcca58-8434cea0464mr1038514b3a.12.1781236841705;
        Thu, 11 Jun 2026 21:00:41 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.21.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 21:00:41 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 18/19] mm/hugetlb: Remove unused bootmem cma field
Date: Fri, 12 Jun 2026 11:59:02 +0800
Message-ID: <20260612035903.2468601-19-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0211D1C000B
X-Stat-Signature: xhup8omdski1zprzyx7hu35rz7xjjnns
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781236842-895964
X-HE-Meta: U2FsdGVkX19VctFEURtq9oUmyJL6hNZxS8R5Cw+sl0h7vnK3OYVoWo4zQdlWN4CTbd3SASgUT8/QYEBXPmyCzRKrJO4iYzuMlCHoAIm9ukRC/jVutubbC3//DxLiDR8Tz6bRasIw/ArPTig1ih02hN2SNjAezQFZ2JDlZ56wCKtTpmoza7i8C+NivgK0ZHcTVX2/XNnrrD3gJCqWiFcHumUq8G4MxufkUBvaQABmnmitEm/fxjFi7p/j/CC9oD1ap6qK5Ctu3WMHaHcmBPzk03B9ifL4guPWrqD/6Kt8R+IHW1VOLtf221bG1IFL36I1d+tMnHARblk70bgcWygM4He9sLKoD+7AauBfurgb1jN9B5BeMuEscy1/vQvGTv3600JCumzMXjDCN8CICeJggpLABkXeY/PhLVEVk/g1Cf5WNzWd2ZuFxlzJTTj2qdhu5zx3xaTWfNKWw587hnYYUvor0wFFfnyNkCks9PDRZIgHpGb1H2uhOd/mJa3OKbZScCpJZyn03KCYcfymaxyqN06EOY9jH1OBkO2XYtTTQeK73z88gZbMD8sjM2Cze1AT+PkXAr7c9JPUJQXpYjVLz7UsCBX8BIHP5aV5tbNkoBw5ipc26MCgeM4ms6fDZz5YuK6hA/nlPGqp5en52Pbiyk0WGdulVi40DECnphNFylpfXJNzBybu4VwQt0bfmweJS79t8a+yJlvbGZxg0E1fHZK19LvwwOy7xKxF1hIKMY51IRj4Nm6uzgpGRdXsfiAPjbRSz/CfyxoSupcPIqiTVZPcysEat30xeisGPSu8MYMOktTzwZoJrZKtF3phGezY4yhvh7pkR/ig/M9bwnSDc65c/JA7/yRekvjgKoV1CExZHNKoVlKV5wLe8BKmnhN2/JQxGZb4OXmEe5t5lnUxVGBEVTwyBZbd4aIJr5UHbpkFCEsu3Qov2czpeN1/YOtmEuME3VCwIpds23UeIcY
 huhxcJyZ
 Zl8Hc7t/XJFAZaAeha68j7CivnS3vTpmQXeGcCI+lKge/nDRHf8mbJ/lU0cIqREjSkVpA/axRy9tinglVUu4eSLQcYAKN5J3Pqn1xFLmjfdWGfHIGpIP7yDSrc/juNQbmUqj7ujpzSVNE/FUwcxegXUbSMifK5kgOkQMc7QPJMkxvJJWX2KAI40yH65hs8XdskppsgSadWvp94XzpKXFoIQnphN0O320jg3M9vhMSJ/IsMZvsvI0JTSc6aRHhs+a93uVIaPxmurCLxwSBgYg/OMJOOcDKbHB8H3W4Ywjgj6KoD5QcWlIy0Jyhgmbv4PGrZbj1DNA5MC2wiImz3fiWoOUd82E5BKS/KTvWUqS6gdeZoflejgLdduHy89KdV3WSfTPM4/vvFkQ5/pU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct huge_bootmem_page no longer needs to keep the CMA pointer. The
bootmem path only needs to remember whether a huge page came from CMA,
which is already encoded in the flags field.

Set HUGE_BOOTMEM_CMA when the page is allocated, drop the unused cma
field together with the redundant assignments, and simplify the early
CMA bootmem allocation fallback path now that the cma pointer no longer
has to be stored in struct huge_bootmem_page.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>

---
v3->v4:
- Clarify in the changelog that the patch also refactors the early CMA
  bootmem allocation path (suggested by Mike Rapoport)
---
 mm/hugetlb.c     |  5 +----
 mm/hugetlb_cma.c | 29 +++++++++++------------------
 mm/internal.h    |  2 --
 3 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 47c3d6d11c58..fb7ad2a4a26b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3076,10 +3076,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	 */
 	INIT_LIST_HEAD(&m->list);
 	m->hstate = h;
-	if (!hugetlb_early_cma(h)) {
-		m->cma = NULL;
-		m->flags = 0;
-	}
+	m->flags = hugetlb_early_cma(h) ? HUGE_BOOTMEM_CMA : 0;
 
 	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
 	if (!hugetlb_early_cma(h) &&
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index e487d0ffffc0..4dfce68b354a 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -59,31 +59,24 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 void * __init hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exact)
 {
 	struct cma *cma;
-	struct huge_bootmem_page *m;
+	void *m;
 	int node;
 
 	cma = hugetlb_cma[nid];
 	m = cma_reserve_early(cma, huge_page_size(h));
-	if (!m) {
-		if (node_exact)
-			return NULL;
+	if (m || node_exact)
+		return m;
 
-		for_each_node_mask(node, hugetlb_bootmem_nodes) {
-			cma = hugetlb_cma[node];
-			if (!cma || node == nid)
-				continue;
-			m = cma_reserve_early(cma, huge_page_size(h));
-			if (m)
-				break;
-		}
-	}
-
-	if (m) {
-		m->flags = HUGE_BOOTMEM_CMA;
-		m->cma = cma;
+	for_each_node_mask(node, hugetlb_bootmem_nodes) {
+		cma = hugetlb_cma[node];
+		if (!cma || node == nid)
+			continue;
+		m = cma_reserve_early(cma, huge_page_size(h));
+		if (m)
+			return m;
 	}
 
-	return m;
+	return NULL;
 }
 
 static int __init cmdline_parse_hugetlb_cma(char *p)
diff --git a/mm/internal.h b/mm/internal.h
index 3401759924d9..39c9564fba0e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -24,13 +24,11 @@
 
 struct folio_batch;
 struct hstate;
-struct cma;
 
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
 	unsigned long flags;
-	struct cma *cma;
 };
 
 /*
-- 
2.54.0


