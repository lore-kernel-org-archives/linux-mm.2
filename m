Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B030F34C45
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4686B00B0; Thu, 23 Apr 2026 22:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4F36B00B2; Thu, 23 Apr 2026 22:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993EA6B00B3; Thu, 23 Apr 2026 22:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 805786B00B0
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:56:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46621140AE9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:30 +0000 (UTC)
X-FDA: 84691936140.30.B785894
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5AC9B4000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=S3L2LwTJ;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gorQ8nwUKwQQqSP5JrI9Qb+od9YHCs59YbEIcdvGJzM=;
	b=qSKCLHk+d+G+x93nBSYvoeI965thlM+x3jCZr9txTycliiKnTWbEqqf8TuMxmPOhDLa8k4
	8cC+y+0y08udRKYHdzOAI32tmDKq8nRlG5TcfHLtMF0MjmI4QBOvUEGSTEEJWpapCjjV5c
	dbcxXo7OQh7cpSPj/4T9SUtqqSgw26k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776999388; a=rsa-sha256;
	cv=none;
	b=f6tbFbJTkKfqW5ciRDPgc2uQzEC4yEbndJg2SNAj8nALF8g+hpIxB8xCFpPmF+PdvsxNYj
	Vu/cj6OMrmWp6QkbLY9mGh5fcJg1sAXI4iInSP0wAh7NjaGRGoBE7V5SJPNvr0TQRga4/+
	akc/rnTRMygxZFfURQzf8MbfsxdPvJQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=S3L2LwTJ;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ab46931cf1so58196315ad.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776999387; x=1777604187; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gorQ8nwUKwQQqSP5JrI9Qb+od9YHCs59YbEIcdvGJzM=;
        b=S3L2LwTJV7dkVJBcxbIOfoWbM+I6gUz7ySb2kwcMhLUC859K4WAp5s9pvmfl0TZ4E2
         d8lYyMWqKSjIN+D2Pxj0xRDDWLnExCx6jVBMT27vPv7PzlRC92xlXLQuIWXBTMktll4w
         kKPkMg39f1KsZMKdmmMqORddNOKF0axezegTbCJogGcFWIzvSF/MRsAnSvepcCGkTbGa
         R3/FI+Mft10AxpTjn1lmy4hei5BL1asYxo3iSv2ecSALfxXyTZ+go5ePpmQKr6nQbUeX
         kribuPajN8b1owOJ7LjAQCar4c28WSySIsYmvjKBztUVZxnOYfTx0rdElLPJVXeCm9h6
         pOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776999387; x=1777604187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gorQ8nwUKwQQqSP5JrI9Qb+od9YHCs59YbEIcdvGJzM=;
        b=MHt32RyE8dQyI0tWzwMIkWA2yVCxThPUR2qzc4+5DcZZG7b/sP0+aH8LEMyeiJiQ6x
         tT8CJ6oOga+fK+Y4tonUYmcZoOTdkNVk7yM38z9nIUfpY4wOfg37gMUm/J5VbAuvrw8r
         GQ7gPpq/k+OzXY1LXNUxXRyDbWNNX3yHb6ejFg9k1SVsx415MEVbFis4WVTLCABauAGG
         4FpqWnyRZnbmWTRjjIFi0xEPrIhKFOcN+0vGbYuAO/xPqFzfkD49THRPhGExmys552Us
         c6HTmqE/WZqvCE1HwfAMKvXP6B+WkxZhCGcnls3aDTHy/C48IodPaAYv3UR3cbnyjdad
         0kvw==
X-Forwarded-Encrypted: i=1; AFNElJ/dejpV/FCLVShGWGA9JEMSI0rSJVXsuU9CZwiblOVyi3X5kUBghpIFNN40tspLDnXJ/h8NPJGJfA==@kvack.org
X-Gm-Message-State: AOJu0YxCJ+99tVj9pp28qrZWxbmBwC3RuzybM00/NX/BJV/joetH+gdK
	K2+zXWkSku9Qkc13FkVON65bYXGXTeAZo5PrvesoT6RYrfFNocU8YZ3U/DMoyf8pczU=
X-Gm-Gg: AeBDievkIns0C7ONEOpMnbTb5AVJItqCsEv4hAc8te0TGpk/K7/zdfX3txnThZDOIij
	3xxP6dPAx7SBwGkJLc98L3iMIfdTEk1HKXmNVhZF6WU6XabVZJ/2Pfokxd130wFa+08YMG05dXG
	dXM0R5Mi1HJCOT3nTIvKSCMJgxYVib7I/3vZbp1Z06MtvStspBuuOnURXIc9dHqCL352eEzbZob
	oGlxLnGfVyeiP7huywZzFbxqgTUdTD8sAvelAk02X/r/zXkP/DkLs9lbwiihlxgv85WjtybNPGA
	giNJ8xGf50QogZ92y/zSqE6c2dHJbu02kUxTr28aYrwA2uX/2k15kkGTcAo7Kp2MCUR6zEarYDx
	Y38tMU6+hsyllYrIWb8JvuOA4uYsR1MVY94uDaBXSTvRXIqoRKz2KJqPLjQV21lMQ38FBH8nJiI
	6L2g7Bkm1m2NLv/0D9Tov08iPo1IrJAHacEZQevzfkr88gBAiY3fHxnpKRcG6zCCmrWg==
X-Received: by 2002:a17:902:e748:b0:2b4:5d0c:7a85 with SMTP id d9443c01a7336-2b5f9dbcd42mr277705665ad.3.1776999387049;
        Thu, 23 Apr 2026 19:56:27 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab20d33sm221668325ad.63.2026.04.23.19.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 19:56:26 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v6 6/7] mm/mm_init: Fix uninitialized struct pages for ZONE_DEVICE
Date: Fri, 24 Apr 2026 10:55:46 +0800
Message-Id: <20260424025547.3806072-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260424025547.3806072-1-songmuchun@bytedance.com>
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xbeg7kcm9kks6uyo4rifdfndqwz3w8h8
X-Rspam-User: 
X-Rspamd-Queue-Id: 5AC9B4000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1776999388-474986
X-HE-Meta: U2FsdGVkX18/ev3RBx4rfHKqBuJDnQyi16BwlcON3pkIBvKhb2BtAczsNxhyyYAhKxnKKHoBdYhRUZ62bWI0fYKiP2485mVzkXWAsK8M1+icLo1d1n54KK430wJjwQQ6DswLDZq/GRL64hEoBWNX/1dJ9cnTqKO/oZnAwQ18LzZQZZI8YRnTfRdfBA6GEJ5agNhI/Xl5mtk8SdeBHSxRedWLQ80UW+7xHib6I2eMG6LdJJAbWVAJgBlOMPUSSZg3bDVZ8313ZUp0pbvsqB8PmCGtJC2iELd8w9pTIRcNfEomYGXoNRQrbjzNsnyeXXiraOeryr56pPj7oSX0nl8/PSpzgmd5THuCrBtMIvaI6OGb6EhU/51fcpV8iwPT5uTZaDGk90RBL4z7nmFxdpjylgXVMkEMsX/fi7YEytMzZYo1pzclm1kCwYp4vgBm4qUwaEuYPaF+mXDLX8fdXnU9gdHSTcsZ4Pm+aN3N1j/Nf/0+oBkh+k1CysA6fWmtyg7NqKb/kHJNaonz7/8Sw2ZMIwglRSUnF9Kz1kje6Eygy8gJfcMc6//iQ7uOFpc2FC0soOpjxMT2VwGcHLb0jeCIUAJGaMAG3Wpa37GilWn23Oz/J/wl07GloaBiSYprNB4Da3tF+RpqBk+UFluQXvfoOiQfVAVXwAwytzpGYooFQcqJq7ZdiAdLuhsudHg+RI/KbmtwQsfCO7gr195bhqeP+6M0S+Wtbq2+j2VDW5CgCjpV7zOYH/5aCYYH5Zk8NLMmWL0XuNZJXGdIwzAORN0SglKGrAkhOPzue8I2QqtKVYNcVTFjbbyFKp9QqJXWUIYmkNDCBuTrncsJXHGJkPrn98XKgITvwvcac8x+UeyYwA35CzRpb9CCdTtGZASYKAD9MnrHzlmse2wQ0QieJieZhN2O7mivTcDtGQsqCF7fJrTqdX2ob3NiIFawIgCxhjaJvnB1BDNc2dFtcKbCcXb
 MqCYEYAg
 kd7qD7dY40YksXegCZ8HNfD7eUMB9wzfNQsYEgpSnYEWmEMwWdFvJoSfp2lU3mmgSvmvpnW5edzXhyNoJgs8s9yLff/1YDpXtg2veLZtmVZXju0jBmMCUSKXXb7DkJ7YcVbiIgWTnticC1z8w86VkkW0v5mazleCYFaabXc/l5OD4JoNHUdGl/KZJo279sPik2gF00Onx5jRNn8h5F9a3EPlkr4qcEcbJupzb/oByEOUl4x2gULzkNtOt6if/ekOtlorvGXGE1bK07ZAphiOdrMI6XoxjK55OHosASN9lLIbrb9+A+Bch7OSC4oZx3zKParu2TfabhJ1Lvi6cNp7m8NtbX2cntS3mx1rBZlG6D8mVcQaODxl6DFL+89fxnFprROgR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If DAX memory is hotplugged into an unoccupied subsection of an early
section, section_activate() reuses the unoptimized boot memmap.
However, compound_nr_pages() still assumes that vmemmap optimization is
in effect and initializes only the reduced number of struct pages. As a
result, the remaining tail struct pages are left uninitialized, which
can later lead to unexpected behavior or crashes.

Fix this by treating early sections as unoptimized when calculating how
many struct pages to initialize.

Fixes: 6fd3620b3428 ("mm/page_alloc: reuse tail struct pages for compound devmaps")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mm_init.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index cfc76953e249..bd466a3c10c8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1055,10 +1055,17 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
  * of how the sparse_vmemmap internals handle compound pages in the lack
  * of an altmap. See vmemmap_populate_compound_pages().
  */
-static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
+static inline unsigned long compound_nr_pages(unsigned long pfn,
+					      struct vmem_altmap *altmap,
 					      struct dev_pagemap *pgmap)
 {
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	/*
+	 * If DAX memory is hot-plugged into an unoccupied subsection
+	 * of an early section, the unoptimized boot memmap is reused.
+	 * See section_activate().
+	 */
+	if (early_section(__pfn_to_section(pfn)) ||
+	    !vmemmap_can_optimize(altmap, pgmap))
 		return pgmap_vmemmap_nr(pgmap);
 
 	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
@@ -1128,7 +1135,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pgmap));
+				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
-- 
2.20.1


