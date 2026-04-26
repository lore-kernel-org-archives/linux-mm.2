Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8400CFF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE016B00B2; Sun, 26 Apr 2026 17:48:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5E06B00B4; Sun, 26 Apr 2026 17:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBBCB6B00B5; Sun, 26 Apr 2026 17:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA22A6B00B2
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:48:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BAA112057E
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:21 +0000 (UTC)
X-FDA: 84702046002.15.DB4E280
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 612231C0004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:48:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a6T2JzsQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777240099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8jzD5+aaEj/qpAoN4ceRyyQr8AzYBOgh6GvhLOGpHCU=;
	b=8GtpEHM3XuG3ZEuEBk3UDnnH2xlE/wjcM/HnQeSGShPbqQ165TO88Tp/LGJhZaa6tbSHHb
	ddSQqDMYAuwqcWimUdN2G1C/B6TxG3jX9y32qJgyusyQQCLxowoUMPBtXcLWZaalCyu8lr
	+Kzm11uj5yG/yfHyqRVSODj9FueMcU4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777240099; a=rsa-sha256;
	cv=none;
	b=CGXn21kErs9rtUtbKGjp3nT06rUgf3kfeacQp8bmMKmL4hTZUQKZCXfgvfGyQOlza62vqx
	grrNkajlIXNwGIV+eWru2ne7MeR1XhdxiVSCKDCql49U9C4rvrV/nXzSwqKvAz7UgITDDV
	YjBHDjpCfUtF5E0OKHGt+XnD9Gq0YKc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a6T2JzsQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777240098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8jzD5+aaEj/qpAoN4ceRyyQr8AzYBOgh6GvhLOGpHCU=;
	b=a6T2JzsQibgyHcY7ss1SGU/lOrwYhrPOB6cjBv//n4xr6dfSNUS1+rDM4zCqS7czA+NNpQ
	UtLoR3n9DJCo5pSjqH3mf/5FwkudY1QkdEVoZfqS8zJMBrbZXVpDVPF5HWmNHhD0qXfgsL
	vRgE3HzlkXTq1jFFDBPfoj4FVK0gulU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-0xvu-5I7P3eFMRaTCL81PQ-1; Sun, 26 Apr 2026 17:48:17 -0400
X-MC-Unique: 0xvu-5I7P3eFMRaTCL81PQ-1
X-Mimecast-MFC-AGG-ID: 0xvu-5I7P3eFMRaTCL81PQ_1777240096
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4836abfc742so85048245e9.0
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777240096; x=1777844896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8jzD5+aaEj/qpAoN4ceRyyQr8AzYBOgh6GvhLOGpHCU=;
        b=PESQBLSe2AAddQyjs8HeJtVc/kgqIfOuCw0DEeaBAl44UfNozYCX7DYX7Ifxu3Vp3n
         oB+3pid0DIP1L35WG1ulRT9tuuO1iF5STJ4EihD33ps2wAYoQ0Rp8EINGWBNEgNvSznh
         8gBRcHf81k4OteESKPw4fjOc/IkSmynkVgQrDlWkkj3/APnPY6cpecDOqdNiJs2BToCP
         u2wGl07mOEhx6u1ZBiFlCx1pkdjIUPXXckO4GLCuo8WBJFyq6m8Vn993gJtRyE68n5ae
         fTl03D/pfpqYZ16vE1vPqjSzHgAgaFXMGfDmV2uH1MtgWFpdiYOD1QV17BYyKTmaO6Oz
         XA4Q==
X-Forwarded-Encrypted: i=1; AFNElJ9UkNZiv87kK6J1iVup97hPsyEMjhJ12yak7FA7pbWRIzWzK5L2xRjMGe9BNJ0zh3l2Gr+Ct/3kEg==@kvack.org
X-Gm-Message-State: AOJu0YyQpW4vLOIJlx+HVOco29u1OhT06bNErdaSo5QdUim8XXIHU81U
	zplA0p90k2OSsNG+JTuFqTB06J0s77uAHglh1bv6AqYJfoydQmtREBQIciMYHw1pQX1mOkiT5fX
	SDGzbS0KQucr6/SYqiayXV3Wu0ozC2M9BVX7Vfuoi/ViTmtm0Hi1R7o1JyF5L
X-Gm-Gg: AeBDieuuz+UbDXG4BjNXtb26/lOPFasbnQUirPd/eBMdi1wfguacP2c9ujjYrJschs1
	cACXXcxaRi3R7oEhSWZmZZ96VwAR1n2FMpZE7Uy764pTwgO4piVzknEFTo4/Hahq9tXMU9B8Jek
	Y6Vnt5jyZxH3aHtMHjoI4ua8hXHuHh1wKj2LLul58pFqeEZ9zat0k8S9qKJkNu4bYyntzAbkqYe
	NIk+XLq2pdytSfIRSP7zwW2LLrLKfE9Ze6uph5AlYhkhGfgC7YyLERzu982LvrMms00eWb0ngVE
	tnwONRD8MTQpo5Ei11O6+733MTaJBpz25q/7d8g7FGagNkBoBPW3Oz+S+zGVkBTu8FarM1AqOFe
	+DrFDZhXUvH/AAI8zGl7NqrvzmFZ3lIoYqdwaTWILVHg3xYuWr/+fpyDO
X-Received: by 2002:a05:600c:820d:b0:48a:569c:abab with SMTP id 5b1f17b1804b1-48a569cadacmr341609955e9.14.1777240096114;
        Sun, 26 Apr 2026 14:48:16 -0700 (PDT)
X-Received: by 2002:a05:600c:820d:b0:48a:569c:abab with SMTP id 5b1f17b1804b1-48a569cadacmr341609585e9.14.1777240095687;
        Sun, 26 Apr 2026 14:48:15 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-47-179.inter.net.il. [80.230.47.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4412150a071sm39398823f8f.21.2026.04.26.14.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:48:15 -0700 (PDT)
Date: Sun, 26 Apr 2026 17:48:13 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v4 13/22] mm: page_alloc: propagate PageReported flag
 across buddy splits
Message-ID: <68154113e50456eb8adab9bc5419c30effc59144.1777223007.git.mst@redhat.com>
References: <cover.1777223007.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1777223007.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _3ccn7Mm5ybDcMUvUwN8xrmJsY_GK4UwxLkdEQdhmGg_1777240096
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 612231C0004
X-Stat-Signature: a4nykqghhcmkm5grhh7ni4pk1be4kn8w
X-Rspam-User: 
X-HE-Tag: 1777240099-879729
X-HE-Meta: U2FsdGVkX18O7/rCLQps9S4zk5R6Sv0STQrx9e4TmCH4R1hnG35zzMWusKPjHHfT/vI6RxaExTY+Qmx5znXwk33aEJBrx7UvvcvBgMO2nqIGgkR1S2YX+tEcGXKPqO7aoVL6IQyU/twlctXIcyGVNLSNfNV7GKHEIcJ4HRUFXGcPqMjb0/Mi1YIoeIZMEoUW5qN+nBU2ktudnGgJvg0IqlIIoirSsVkR2AfbHEjelIarcZYEpK3x9wKwIE5nIBetxkPiauhSlh71Q875TFRGdWmT3EaCe/rP1zPnz60Gk27i3CDK1CsRzI9ejvSc73NzHoKO/vlfT0//hxr5T6lZADWuCydPtSHLAdLd66bybrOoG69lo+VXOIYAcez6SaJGR2o3wS+k4+YoSoDpEV+5aBl45L+sKr4Ot9NSpnuAw/fsDXW4SxQBpmU1tvpqbEmO2DaARRy73Z50JcdK0Pcovrre1Y80vH6iKM//+hGIw3YCMkJhtEB6QWAaSIPTHsRUi/USoOVN64F8VcYUXYaRsXyRHF/BQnfe7PvoAvCDPyiznZFRwom0vCXex71FXod6wRQ2Xndixn+S9pEXiEt8VgV9+ZJbuYFIqH6TXWuCRdPVFS877gUrxXtuoJ+WQMzEvnSPXEAlhYlNLz62PKq2sweFXJPvmRBYZMZ7fu1wYkum7gyBiGGhvjCSVLRIPwMipPkFbEWKt7Y49mAqLs7OhmUCklYr+khEJSSv76FOukrgs7bRMUcAiiKMxPJQUj4xk+2nMKAQjd2YEstX8El2TUCwTu4cbV0h7eHDKbWV7bGav++XFam026YhZDHx50Lb4aDVcogo+EkrsskDgU0tKgrngovEdR8IQPdhKAZPLDI/RelbBpVNUcZp8iKaQ1Dogf95GMkegRPHtx3dzBMSXd/ZvipOfrRgsYKJPA9JInUuFj9/bfAzR0EFAzYNhIj4Hi24LGePHDLArqRjS/Z
 kUb5Q5ZD
 DDMpZexQ7uS4NI4Rm+NJlYRBfqqCOlQEKu69uNyua7qe5TRi43WI1v7E2ArohFHFVraUkVzPN+ogD4Nb/dshzxgPkeSexgActNuZFlFDwQYanwoLnRSkM6I2RTmt3I7kiH5WNlhtFZdVZeZYJAFp0X7CYgI1sC2XexoYcd9ESCIYYSZBJwx4E0ntEWiIFbadL89+90OkAwLQ+TB/ZLDl0nH6ajja3Qvy5pfN2dtRGiMTE0o0fi1wdC3dZT7AbIa7fDeRQN7RZqcK7XW+7tLkZsq7kXP7VDUEvhpzRipD07jA2Gt3vPEbVb/nl1sH+kcJtYD1hxrzhBrQF8pC7q5uwckZiqWrg850+zAu2vVbIj/8MINxzoCLkPHNGqolEomkth1wnrp1Al24jETRWsZdfgN90xc22cwGXB+IS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a reported free page is split via expand() to satisfy a
smaller allocation, the sub-pages placed back on the free lists
lose the PageReported flag.  This means they will be unnecessarily
re-reported to the hypervisor in the next reporting cycle, wasting
work.

Propagate the PageReported flag to sub-pages during expand() so
that they are recognized as already-reported.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7791bc1eeefa..ca4f9c0948af 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1730,7 +1730,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype)
+				  int high, int migratetype, bool reported)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1752,6 +1752,15 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		__add_to_free_list(&page[size], zone, high, migratetype, false);
 		set_buddy_order(&page[size], high);
 		nr_added += size;
+
+		/*
+		 * The parent page has been reported to the host.  The
+		 * sub-pages are part of the same reported block, so mark
+		 * them reported too.  This avoids re-reporting pages that
+		 * the host already knows about.
+		 */
+		if (reported)
+			__SetPageReported(&page[size]);
 	}
 
 	return nr_added;
@@ -1762,9 +1771,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 						int high, int migratetype)
 {
 	int nr_pages = 1 << high;
+	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
-	nr_pages -= expand(zone, page, low, high, migratetype);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2334,7 +2344,8 @@ try_to_claim_block(struct zone *zone, struct page *page,
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
-		nr_added = expand(zone, page, order, current_order, start_type);
+		nr_added = expand(zone, page, order, current_order, start_type,
+				  false);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


