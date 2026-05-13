Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C74A3CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1126B0117; Wed, 13 May 2026 09:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3981B6B0119; Wed, 13 May 2026 09:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AE896B011A; Wed, 13 May 2026 09:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 188636B0117
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:23:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA03F120126
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:23:00 +0000 (UTC)
X-FDA: 84762462120.25.0636B78
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf03.hostedemail.com (Postfix) with ESMTP id C6C5620017
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WGesHs5W;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZ/NHdOll26b6UfKrMWj7vaap4nNj6N/arSyoQPAGBw=;
	b=oNoHFWchydJzuOQ4o2okzg5YvncLlpf2i0HyLjULYpWC8b3aAPtiqp9yhT/5We/stIBQOv
	b7Hyq3XIbhLiRwyB+LeWU+3qHJ8Po0PhOnplidzULtlTTuqteOR23ur5kLSj1cvIh7DkXs
	8dTbA1oK4joLvMTb5dcAX7w3bgBV0f4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678578; a=rsa-sha256;
	cv=none;
	b=4DQJXRF67bsrUjCpRk3T/LzALMsr0x6a4pygKS8AzYfnS3K8u5keyiELFm7UGi5e2Ky5hW
	Fk+tX8pujHQmjMmUGWbXVitM1bukIJ+c3S8W0CKbY6BXgQuXuPA10E8FuJwDDcurz+rswD
	flUpnRPvnuYgbVQZxDVEJj2gcnfAb2E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=WGesHs5W;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3664df32e91so5496154a91.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678578; x=1779283378; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZ/NHdOll26b6UfKrMWj7vaap4nNj6N/arSyoQPAGBw=;
        b=WGesHs5WmZ7zJvkVZ2NRIYT9ZbB0kXWgkvm9TwA9a4bkOKkZGQae0SueRNp9Zi2/uk
         vImy4tbY3/w8ewr6yH01cSD7lKuuW3jYdoNF9fn6WLhkF3Qkxdz/8NxerC3L2QJMqaT5
         NhQAv/r+G2AWoF5Kz2LUzqfHfA7nRhMBkcd2m+h2SJBu6bQr9pQ0N+Kmy0JROMZaaoEq
         cBl1Tm/OmnoWROyw+vuig+0lwU6LhnG6IrmA4IOdUG5Qcc99Jhu+QixuwYRceSVq6onO
         3lzm+Fl3xXBXbelkgW4mPIudUqE1qBzpAFa/CTcogZ8SrhIJjAHDNuVYOgl2bjG6DQUm
         iYRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678578; x=1779283378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PZ/NHdOll26b6UfKrMWj7vaap4nNj6N/arSyoQPAGBw=;
        b=OApsJaIVtx++X2YrWIQamkZOWXO+kP/jREIQkO9fIvMEzni8Xai2Gyxn1K0orpr8Kv
         wg9vPK3XwnX+xDEI+DlKi1i9PwPecY5sY4mqkTUsX8eV5QuB/WGLzxT1jDddMzVKjmqV
         A+6z8ZItHvUMwdOjMHhksv3NPccCMDSfH4MMol7CWB5S8SMTJA1s1no6TuKUvDBAyhIH
         h9c3dmynTvsZqtNtYSTvfMS2XEMPXi0iTG4DD869im/cpil6zP2rWNct571H1UDHALD6
         GBBFi6o2ICSmh6QPYk51qBCuQuA2Zg6Qs01MkO4tWb1G/MlI+Lb3ctonAUHApSf/tysS
         zTgA==
X-Forwarded-Encrypted: i=1; AFNElJ/x2ysvpls1jeeQJPwaQfLtmVhM9GdwP/ayqt7QlAg9iYivxwrY1kt+uUvxs2nXBhqvI+0qaHLgAA==@kvack.org
X-Gm-Message-State: AOJu0YwxtpYyw6UtTOciC0851AUot0TmPvP+jLphNzIvN0GxTNq7uX1o
	pfIe5muoGmteyWtS3PX9/ihX/qjdGy5dQ/fBFJt/dXX23qhkrymbpd7jevVidPtc5/A=
X-Gm-Gg: Acq92OF8awQrsbwNCvl3Tq1teXlPK72YdB73lJ18jv7C/M8N33CtmHw7WeBg0slyxOQ
	99EfpxXR4MXz0A8MjKlTPfjPQvdfPQoRKMdjN3uZrwUau+0+vRMah6THDPWJ6RXmgf6L/QL01VM
	wCYKPh/jkOdIPZm2m/ORoNpN1DrghB1JM9mLG3VexHvc9lIHpQE+c2F1DQ8VDM1RhchcAr7daBh
	GRNGBn2hfE0WYdm7zRPHjOKm31UkP/Qgt4IYAmceHA7Gy/lESFAWgESRRDvAzyEgOZgYDgH1vwU
	IG8E6+JL9N5bqPVDhO7EaxLvJsK1aFddeu8dZ8XxS0vGpZic1c20mtpJ5rKXm6uc2JGABZYBrQO
	WhKf6QZR69p3D70uTDnflmD96xTT5FAGlCB9Vkai1LutfeZr5vqrC7/sR0tODBg5hQcvyraXKlV
	YREvtLAFDqXlJgAV+rgw6svdFg7RFg/LqihBzpxziZ0dqxO2klPGK/OnjLcNhS
X-Received: by 2002:a17:90a:dfc4:b0:366:5c38:fd61 with SMTP id 98e67ed59e1d1-368f3ac4a7fmr3960604a91.12.1778678577410;
        Wed, 13 May 2026 06:22:57 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.22.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:22:56 -0700 (PDT)
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
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 66/69] mm/cma: Move CMA pageblock initialization into cma_activate_area()
Date: Wed, 13 May 2026 21:20:31 +0800
Message-ID: <20260513132044.41690-20-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C6C5620017
X-Rspam-User: 
X-Stat-Signature: zwp8j8k1dbij38pc3j7qwk9tysomhuk9
X-HE-Tag: 1778678578-62859
X-HE-Meta: U2FsdGVkX1+9eQOXT36xtGc/kaTlT97QeYp3Yp9780dbRLw+L9P3mBx+sg+Z/OIIHgsnHGGUc3dXqBtpFYSO8c2yk7SJ2vS6lFNsZsRnr0tqRGgrEHNKD7PB80EiaUlApYC4VNSl55KxBPVEa4lV/FRXX70rLS4vXYOztfg8GTMbtrP9oKfVmzMRfdaIvpSjue96WtxUY9IyK4cLVmZFBILxcQf8+Ir8llTPz5FMI/lnKmxlllMGNEaMm9q9tZzm2FyuCwPH/uIv15xvcCPbTJTE06jWNlI97yV6tzQi1v5N7jTmalxbkUH2SFtajo2TeBy9G64FXzZ+23TRYe4HPL4hbmoXfK4yHTaRN07g4Eaxnh9wyOrhmmej/ELraKUlR+GtfAV4yUw4EYaknPtVRBCJGIL9WR6K/3U6IDqQQT8IAOwfZ4KwBaPZFd/JzFcMpDvt6oOBMFijb+4nB+Qj7rOHYIwS0d3mRtIrWsYX1o4uES8XZEtldHbAvnFF+Jfze1L7JWWGD0rn8lkNsdQ4/87aP3H4JT3D0rfFwoBsO00O1emjGGcLEZ9XWOiWCJXSlzdq8yTagjEaDNjaVNkMaGEGvBcPyHeswmgo7DDN/8KiLzvCTr+vQ3s3jiEx3auSTDkJdDv7BkQgkqDPY1dEZrSGOFL229SBEPbYdSi59zUvg63srEdBNFXF0uVVIqB2YzeA6LpHnBwg+eQ1rqCmcJ3j+9anQZRYHCwkr8bwJvj5oDm7O31luO4Cm0P3ujpjAn4gav6AC6IZfafSs0M/Tpiwi/oL+9LxJamSq3SWHsACNLCx7xn7FzGJqcvC5mYI0bRwHLAJCmO0LX561LNiNuXH5CebVC33JDYJmlY6wlzYSY+oghbDXFAnohjRXhIQiKIROYZ/O+EitznZlEdGxrNtF3cxNt6h2YZBhba+c4xidENKMGURbJMnj5OgDL82OnDFe23er2nwGRgFrkb
 JgVq5GcH
 3xtcvUvlhlxIeKNT9gO5Bi+N7PYch43Df0x1rWGmLJHWxjPwe+w1rDDppMKyoBplrH0Qp3X8qn5KrY4B1KDCGnOB/w8Edd3NrdTFKyHlpHw384NJph91lC4YtjT7T5kDDqCLGIhJqBw5FzErXfFm9805dX+D4in0eymOK3DUq8ORoa/pMZrheiFLdWcFQ6CUj8CvhjTPb+L6RAq/ZSZdAyzUpmuyvSyIU62/paJUZkmykoBx7H054ireCmGl69IMfSNrF1yRF0LidxLgX0i2qhPktQTu8xMFLIhqZXRW30YLt/0VnQbJn3y9rRz9dzEB1ffUoP8FmdaOu3bE+pnHATUdsQNf5I9lOh0dOi9BXWHtj75PwKi3nnxCDY3gB7/S0lAdLDt9zWi3dv8GnyI8YjbaZzfHtdiO1L6Gb9fN/rLObkBnbpzh6ClRYxyDuK7WvBmM4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move CMA pageblock initialization for early-reserved pages into
cma_activate_area() so CMA pageblock setup is handled in one place.

This keeps init_cma_pageblock() in the CMA core instead of pushing
special handling for early CMA allocations into its callers.

As a side effect, this also fixes the zone->cma_pages accounting race for
early-reserved HugeTLB CMA pages. The accounting is no longer updated from
parallel hugetlb_struct_page_init() workers and is instead performed
serially from cma_activate_area().

Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/cma.c     | 7 +++++--
 mm/hugetlb.c | 8 +++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 0369f04c7ba5..c1896c0db63d 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -162,6 +162,10 @@ static void __init cma_activate_area(struct cma *cma)
 			count = early_pfn[r] - cmr->base_pfn;
 			bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 			bitmap_set(cmr->bitmap, 0, bitmap_count);
+
+			for (pfn = cmr->base_pfn; pfn < early_pfn[r];
+			     pfn += pageblock_nr_pages)
+				init_cma_pageblock(pfn_to_page(pfn));
 		}
 
 		WARN_ON_ONCE(!pfn_valid(cmr->base_pfn));
@@ -1098,8 +1102,7 @@ bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end)
  *
  * The caller is responsible for initializing the page structures
  * in the area properly, since this just points to memblock-allocated
- * memory. The caller should subsequently use init_cma_pageblock to
- * set the migrate type and CMA stats  the pageblocks that were reserved.
+ * memory.
  *
  * If the CMA area fails to activate later, memory obtained through
  * this interface is not handed to the page allocator, this is
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7e9f49882395..df798f9386d6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3136,9 +3136,7 @@ static void __init hugetlb_bootmem_init_migratetype(struct folio *folio,
 	WARN_ON_ONCE(!pageblock_aligned(folio_pfn(folio)));
 
 	for (i = 0; i < nr_pages; i += pageblock_nr_pages) {
-		if (folio_test_hugetlb_cma(folio))
-			init_cma_pageblock(folio_page(folio, i));
-		else
+		if (!folio_test_hugetlb_cma(folio))
 			init_pageblock_migratetype(folio_page(folio, i),
 					  MIGRATE_MOVABLE, false);
 	}
@@ -3206,8 +3204,8 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		 * in order to fix confusing memory reports from free(1) and
 		 * other side-effects, like CommitLimit going negative.
 		 *
-		 * For CMA pages, this is done in init_cma_pageblock
-		 * (via hugetlb_bootmem_init_migratetype), so skip it here.
+		 * For CMA pages, this is done in cma_activate_area(), so skip
+		 * it here.
 		 */
 		if (!folio_test_hugetlb_cma(folio))
 			adjust_managed_page_count(page, nr_pages);
-- 
2.54.0


