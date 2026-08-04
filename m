Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B83FCC55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D308A6B00B0; Mon,  3 Aug 2026 23:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1146B00B2; Mon,  3 Aug 2026 23:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1E796B00B3; Mon,  3 Aug 2026 23:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A11326B00B0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:56:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 485DF1A01C1
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:44 +0000 (UTC)
X-FDA: 85062225528.18.A08813D
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8DB23180002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="OJc3bU/M";
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815802;
	b=BI3MoXsZ9E5YU2ml7HyuJcMYuUow9mYStQZcDqsVhdUK5YcQYECutoDBCNnPOAu++ZK8ln
	pp9M0dUvXLme7ceixGNVZaQWbETPKF8H5nAqCjQ017p3z+ZNS1EuDWo0veYXAdXzOBXMpZ
	L7r52VYha2+PNfJ48hbvMg7SQeCkaOg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="OJc3bU/M";
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AD8u4rMpjqzdKGZCDXb9eLWKbdh2DMC0CGOyfVIpFQ8=;
	b=Qa8dPEORaviyG9n9Jr9KkzJV3XNTi9fct0OQmXKpe1GyHRFo66+0iv7tEuMf4lmasV4OrL
	6FYzYp8KBxugLsSXvTHqvTE2eHm9xiFcFg445+8aD90HwYhqE1Z1gqXjRdrOTK9zRDUCEz
	zbDzD6pGVoL1WiT9NHx16r+d5QCaUUs=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38e7109321dso2401454a91.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815801; x=1786420601; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AD8u4rMpjqzdKGZCDXb9eLWKbdh2DMC0CGOyfVIpFQ8=;
        b=OJc3bU/MZSNO+l4ieLAB3ze5R9jsG1dvb/51gr1Fzi30mYbSIqfTQ44XAzulI0UtoU
         G/AGf2b9/xXjXotK1EZishDMfECartvV3DfgxuZi6nu9Fde022myxN4BNH/Wv8AiiIb9
         Y/uNepH+b3Y3W6qgWF/hZm//x1yrv5dA1JN67FJgRhXvkwiXAH7IKcROuw7ZE+3EkvsI
         O+xhT0nJJnD2EsP5YXWvYW5qIIOaLkZLRKeRnb3WYr727H+SX420iQnHGarSzT0vJDj8
         Me3LNfqJBmWOWu1cMJmxX4/Wzn8d3edd0lpl9eNPg2pDC/BkeohwUAk/Lehvr5aL5wh2
         R+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815801; x=1786420601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AD8u4rMpjqzdKGZCDXb9eLWKbdh2DMC0CGOyfVIpFQ8=;
        b=SMHMwznKZUUqK0T3mmDwyXgrboaXUeGznTEy0F8Gu0NCLbahBHeFcUhmBbaGli9Jqc
         fhlHp7CwFyaIPdS5FqkZMLjroIl1tcVmlC6IOnfeoja5Htq50a3Lmfr27itifV8DLa19
         ET4r5vnGuxAGSS5r/7NMvzvFNBCJUmSfpLkQDC5885ifmlvFGb1+sCICK8ODEyB3r86e
         MccyfCtrbOR1uD0/EWyGDliu4goeqOJbMJmFClUHaIvHMGdwtuVkznrxezxeUKPJ8kAq
         m1y1pT92Fq0a1Spr52iuukzR0cWmFNjAYZfsFPE/8qC/DERzR71KBkxslfcHTBHJNhnn
         VCvw==
X-Forwarded-Encrypted: i=1; AHgh+RokGCjcrd/HTC9HLDMsW96PTPTpdrGNNObPPT0AmBuJYWiY9yJ0nO712fGZBZA3h3WRdW+QU+QsOw==@kvack.org
X-Gm-Message-State: AOJu0Yxo6ot/Me2/7HMKHc3yJWyd4ohivoCvyC3z1PO1WWmFVnE/LeZ9
	E3ECysu4LRnXTmk1ZPs0k4x1wj8XyailIKrAOk34BBvY4oLb+ro1NlySOgxLoZczDkE=
X-Gm-Gg: AR+sD124IGg9wGGMwlfks2qteI4h/P8ufwrNFUN5toANL8v/lLxTZszehhbtTWzEWvR
	vac/vWhVOmYSjwjl28kegAyVPrBd9S3urGydQ++rJIDrbwCK5HrFvg5iss03AFouB8wsZR4MGbg
	GF7/Ez0msQgloQw+K/wEffCDrHOPY1WaDTeRQAQs6aPQhu/GVoFGqB0HYBHs7hqnUQI6zLqFtgD
	CaDYaxf48EDT1MHnJJHeyNGoFG9vEPgSAGQ5m4+8E1idbo7uoSoxyx8oW8GjQhnQH5a0OXavG4T
	KKwRmMVNi499vC1Av4/kfWm8B+Nx2lzWbp0tUnhonijtfZfcTfOgTiiTziFS24qfRMfhGWO/ytn
	CtKm90YOMLENQJTro9tMzlZTY3qemT22/OHS6PJRR5jX530I/zt1fjLh1SYPlgXTSdEKlQ61REM
	yGN1SpwH0oOkAW/KBM+tTC41rXJDXkY5Mn5c1BgEgP1CKiok8uXSdmp2VbGw5XbGdddaT4aBk2f
	+DEyAw3aAcdW1K98FU=
X-Received: by 2002:a17:902:e5cd:b0:2c9:d8c6:1db8 with SMTP id d9443c01a7336-2d052298492mr116429075ad.28.1785815801366;
        Mon, 03 Aug 2026 20:56:41 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:56:40 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v3 13/17] mm/sparse: remove section_map_size()
Date: Tue,  4 Aug 2026 11:55:31 +0800
Message-ID: <20260804035535.2846016-14-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gminh4zpyw9pgq7hmnx99tc4d7bu6axh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8DB23180002
X-HE-Tag: 1785815802-607337
X-HE-Meta: U2FsdGVkX1/q3Loyd7m5u5kfdMBlQ0LOu/7/CxQ/qrMu7PJWSn/YnRqmp10H5150XhID71UZ2bw6VqYxQnaxS6vkWUH5886WIZ/q0lGN0Mh9xebRd0AhpUoOpxqo7qCImIlTchLwZ6W7g1e+2/DxAJ8jizCb24Dz9AZCaV1czro8faRKeyZhcosJukxzWXVXdzunxViS2ZDhOEdRZqdY7VSRir9q5Lbi37TxmYn+bM8d47wB0eXZ3Pb23U1clodMZ+PchhZafoOA2heH65k134NJdOqOY17QBehDUlFvVP5LzPzV3jCY67ThYs6cq6uSGplzabrGK00/URcw92hDxGgLcTIlwUDqrg8g2DgpaxB/TIlbeEKBow7eF0u03wTveFNyEasGxs/YxxqXkE9y/F2BCUW3j9viu8qXlf0NXHlyVyGW0GuZ3lKpRjWTKupwQCpnC28/5iDQMgt8eNrEkKGNO6Ko9uHgIaIZ06zYsnbVHPoJaj15bvjXBsTFUA5nrL/bPCs4DZPuV8MmPpkFAA2NA2Hz3gYM6Ba29ZVqJDOrEtPLHNJsxY+qKyXxMtDkcrpg3e75OMcyyepFIipNu11TBw2g2OKOwL+AY0xccPsEfBtiCOskEgN2FinM5TxUCs/egr/5rxa3Ku680TQkXYHIRXTHiZ6C26AivyrEF4z5QYPQnfFStEkdG9dB1eX6VBbNb7bQiL60atFKU2AFApiqHfRQkHyst31g5ijaW9wuCfjrAHYmBD1Jf9jYfMyZv5xiiPgwdoFkouwyP3FCnLk4BD+eMFiZFFXHWgcEPiNFjuU3Y6MKi6n3dSyd9jXEvtmjblKH+IMcxF0NdXTLT0hosZy28Wb12++0RxpJzNXXE9jUnQZh8CWJewURzCheWNUlNZo9JLparKnLnNE1BuhV8X5StA59LdfgNnSXlWTOXARiDUGLA36wSIC/RA1q0VjyOqe/L4OodqU6QHs
 V0djdSOj
 17vGTQG9XkexKd8+N/rSsWGcgy291XLxiLPxhWhEheehgIhF8eWXlVvAVU+x0iscvGOHAuOhidBQI6ru99JPJk8hyEqLnm/DQKmPRCf1idhpGZMEWNh5rhrGL1jTWLTc/pUGKyVkqWsbQGymYxvuSzqYOE0ECfGhmiBLrl6btYahge2pY0IHH0WsF9pyU+OV9VqzJJ2JaQsq22xBEDaLi+59vP4uczPHCmR9ivmt2QiWNkln3A3TOnNB/lEBqadZ8W+SfTLti38GiSLiujJ8332S7QQlTIlbnngpAS6Stj6PqXDyFz/aC2q8h0V9ofD8xyq1EBgfiHDJPG8GTbkK5MDu2tmjroCCXTrwPTHvie+9IS9L180RBDNOQ6Z3edek2NSYbklxc2n3U2qeUkHGb9RzDnOrU7EwQa4T/O+APyXmYfw6rhe4ZA0/isNeO78W4Gpg0ZmvU4wa1sF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_map_size() no longer provides any shared logic.

After the sparse-vmemmap changes, its only remaining user is the
!CONFIG_SPARSEMEM_VMEMMAP path in __populate_section_memmap(), which can
compute the size inline with PAGE_ALIGN(sizeof(struct page) *
PAGES_PER_SECTION).

Remove section_map_size() and inline the remaining calculation.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/mm.h |  1 -
 mm/sparse.c        | 15 ++-------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fd7dc85f58f3..1adea81e80c5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5078,7 +5078,6 @@ static inline void print_vma_addr(char *prefix, unsigned long rip)
 }
 #endif
 
-unsigned long section_map_size(void);
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
diff --git a/mm/sparse.c b/mm/sparse.c
index 743112ac84b1..785c0be80aed 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -219,23 +219,12 @@ size_t mem_section_usage_size(void)
 	return sizeof(struct mem_section_usage) + usemap_size();
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-unsigned long __init section_map_size(void)
-{
-	return ALIGN(sizeof(struct page) * PAGES_PER_SECTION, PMD_SIZE);
-}
-
-#else
-unsigned long __init section_map_size(void)
-{
-	return PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
-}
-
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	unsigned long size = section_map_size();
+	unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
 
 	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
 }
-- 
2.54.0


