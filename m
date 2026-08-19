Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 659B9C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669AE6B00B9; Wed, 19 Aug 2026 05:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619536B00BB; Wed, 19 Aug 2026 05:54:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB1D6B00BC; Wed, 19 Aug 2026 05:54:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2699A6B00B9
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:54:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3E491404B0
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:54:10 +0000 (UTC)
X-FDA: 85117558260.03.6602319
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id DCDF0120004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:54:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=N5fBT8gJ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dl94Y3Ocjmgq20YN+NWMCqSvUO2QWpmbB00opElt5jo=;
	b=LDqLUSin+9U4wwjkpSbC5i/t7p7xEQqNBo50wrFem83YSpcMWYURHApLyrs2ZHplPWdgI+
	Wi0U/B1skIxhMfKhYG+VcycVwArhrcRol/eqp60YxL3FkUxo+JyzT+jytEMn3PNotdzZRa
	dAewkrPUzO+sDmlfHHB/O7dBVMkCQ04=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=N5fBT8gJ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133248;
	b=5VSZ7CUu3dMa8Y/rcgbm9weT5lL/G+yyjSHA/G/Fo/f24mcsga/BKRDVbzo47atvvRJgx9
	sucOFdA10tq3ZOEq9hEOZ+BNG9DWtFdjUUI2uPz0GFqx/S7oYlxI8U/Ur0hlZwYe6XGMQS
	qUGY6g7OcUdvNA87cSJ83LiubKi6dfs=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cedda2ce6fso4521855ad.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133248; x=1787738048; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dl94Y3Ocjmgq20YN+NWMCqSvUO2QWpmbB00opElt5jo=;
        b=N5fBT8gJdXuJ4ElbEeVSra6vNx3mWTJJjYh2E2YZeK7l6ns1mVVpdxsMLnbJLinv6G
         Z8eLk3UkUh5ABaffm4uXmsNg98aYuBQX3crAbDdxqvwVvXxx9tm0QUPwbBfwZ8kg9zGX
         YGVFaVLbu3wwIz2kHddSBinIb0e4u/y3szuL1sgkWQawsircZrt5LLz25aczD0+T20lc
         wnWvGgc5Qs9zcFD+su+9w3gu616nqOxtPJAecsdymVEYcL9hOwkQh+NW28bKH94EkTFi
         7zgGZwVZges/LRyz52d8tvvKrXc7fTnma0K0Lhd9Yjs7nj9bdMAv631M4iO34eKJO+tk
         yR+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133248; x=1787738048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dl94Y3Ocjmgq20YN+NWMCqSvUO2QWpmbB00opElt5jo=;
        b=B1eg0xlJ73i1fDq5enUgVoqrWRLI6yzl7VF+c0nBZNmxp7b78RFYJye9ey6XBdvW/+
         c/hXJfsl0i9PJSK5gFsFHT7Y/IhmoTqsKw+lwppZ5Yz/V1pkWAJJDWPyPDsIjP/OZ7+s
         X9MmIfAIS92vtKLm0+61bbFBhFjX9JZId2MoL2XuY+xSDOYLcJCBjnfoZpSXcu/iCbk5
         bUkzUqDDgcO72B7/8boMH/qQMb9LgxAvfoK3yEKbdKcJm38VDN3A/dZbbC2VJGy/2XIm
         oUZKhxAEWfDQQ1rsHlmOX/V2RrY70k3bJfuwrlX5LP51AMpu1ZrTfFXtQdvfQXkVn27R
         a0uQ==
X-Forwarded-Encrypted: i=1; AHgh+RrYK8/TEM+9IOs5+2OQccvoKXa/49wiOCPWRvFP7f8NcxLR0Ma/kBGNE1GWPUmFz7CxBtrXCKe1Sg==@kvack.org
X-Gm-Message-State: AFuF++mk1TxnosziNThQoFyvRn2amYlaU2cQR68Ttx9WsXuUrWrpUCuK
	ntQ6Oov0nLG2BxTfjR3h5JLGBNxUEs8PtZiU5n7j+83kYVwMwl3MO28U67nQg1gm2Vc=
X-Gm-Gg: AR+sD118DvwdtG4ObSJMtgNv51ud7n5cAgXyKYtD8TIxr9Pt7JhkjPJQh7rw5RW5hYI
	gMSzUANDw+c/9kKGXLmA21nGsatK4lMfP+VCtjIV/BOWWhznGiW7lqOULMjCIxue2jgKuPIr4PN
	kr/+RFMaSDa1ghKWH8E2AN8bnrLZ1WXiMMwTS/GLskRbVDCyJVkAJeGOTi01pDJJ8X2Azr9r3hX
	zOQr0pyN+mF4KVFh8L766fhIZd4JU98UyPS1xXylQgb0y6jGPgoc0bAB7HegsuSyWB6xc/fDVxg
	0NLPelutpyAeICloSBKyUs/ALlWqSSytBdmRjFGh4KVpOKNE+oB3T3WZlzv6cmFRI/xF62KLNfP
	PwoK6t5z58YVPGqlhCUfmjS2Gs9jHnaMKI18LfPwtm8SkwKy1I3dLOSTrAiJEUIyRZW7o2TPPbt
	534ZLdhabUbaNYSaE/NfremymQhnxpIz81+Pvt+fzRQ9168xci44CdaLfKTTo1sk5kQN9Mkxyc9
	suaAoyBbCFbbLBxCDOWtnvCNg==
X-Received: by 2002:a17:903:468d:b0:2cf:afe8:b722 with SMTP id d9443c01a7336-2d601ea52fbmr64639885ad.11.1787133247576;
        Wed, 19 Aug 2026 02:54:07 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.54.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:54:07 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v4 17/17] mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID
Date: Wed, 19 Aug 2026 17:51:39 +0800
Message-ID: <20260819095140.17252-18-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: s78ccfmq3m6hyp71t9wtqsrdjr1gpqtr
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DCDF0120004
X-HE-Tag: 1787133248-598403
X-HE-Meta: U2FsdGVkX18TVQW5uYH9EurKE6XcbugknT+TiABV9W+69peQoX/8jfOEv7w93BTDwuVvvlYIT0kHaNTMSvFBPZQ9lKuMUmLreq2VRO75hm1g4aU+ATACwwm9XiNMsLBTFe5H1pbu4IIU3fD7kS2suwipil6LYxohHPh37Gx1qUXKgTF974wzI9CKLmdWt2j68acDW5k/gTK22r52ODtV7Ve2N1FzG1OxUFMV+9+pd4mPhOrEO0vwhA90EGYJdnzEWkGCh7essDVGGBGNq/De6bI+p1KzQZepA38UFO92nuzvxc9/iVbStqGyJME3v/8Gp+6AttumrFrtzeN3IpFOeGHLIEY8f2D7zM50zP8JVRzDb2itI9WkShYvBXH1L1n1eDUggCiy5hk96oKCxcdMhpOA7gPiOC0eS2mY8ltAR2az9PfAxrmN7vgqcHCjqEcvTvmAm9YRI8lyrtqCRvS6YNF0GmZHLwGTFog1IhyYG2DmiMZnjPIilfS2FFblEvfNJUQLV6RqgcFllMSw0ZkKBB5yiXig+M9tvjgCjCc87XBng8iY9Ou/GABBCrWtJ0Hq3ZL93Rv7ZG41ZuUQlHvgG1lqf9Q8bh2z7+hzMtdqDaiWRKJzAtfpssRNorvQ39IWHrd19BNVHzPHQFFtmMJ96+5UlTZoYvFoLQ9T/PEh/hA+rhjz857lruUCWouqbj3PrdiWvrJI3zRsS4ERYMSrkIw5wo8zZRng13HK9/oPsTaRFwzudbgMY+QbhnFm+Cuq7QPf7vHKgv2VXSFypo1LY9dtVwQttCNQz7bmIh8gd1XxUay7POd3Bv1Pk1VxK6xZuc3+khLY8m8jDTx8rdvVdiFsokGhP9OQPMsrG+imKfk+WCyya177lFneECT/E6jkzT1cgKerbvXYlrWuwJvI0GKrGUT+AgvvezUO0hkNoA7W3uE38arqtnrgYzdsuERiDU3G5Cixo+WCMg1LGut
 ewlC1PP8
 wBMwNZr7GjrTRH67RsL1eNu2XsfKERI2KALXBOBg7eMHeEYkwzdA0erU/H1JsYKZpeJWzGseiy+G8+bxhkwXgmv4QK2Somki4ZuBQGRRyybAmKdQW7KtpDk2TOKqSpRKqz/MoY9OqRHT/VTDpMGNIBknjNelJXaOCrAo+XxXOmzSiVqrIrkQKXLy3gpei6UjZ9jgZ7QCtuvVq6/u43/Mk7dmWyM3G2KQ761W+14K4XhMhxv8Uxy5DpHRjgUCrMqb9qS0jubGO42wkm75kVd8j1bc8/5mXRaFOqsF7CmLNuhK3bYXXePgdFwhjEfkuXBNl3+Jqf9UvJPhzUyQ4iNB3sqbjeId75fb7+Emg8WLbzzpZg2z1GwhanKFiMwQ2078hiawp99u3Cui4SGlRZGybrNiEoY2HCcZWVYmajzrE/ABLEJt0GUXedtwv729LgQoxoHlpY0CvnwHSK5Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HUGE_BOOTMEM_ZONES_VALID is only used by the huge_bootmem_page flag
handling in mm/hugetlb.c. Keep the definition next to that private data
structure instead of exposing it through the public hugetlb header.

No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/hugetlb.h | 2 --
 mm/hugetlb.c            | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 255a258f11d1..900c95e346b2 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -675,8 +675,6 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
-
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b2b80284c4ce..3116e323fe31 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -55,6 +55,8 @@
 #include "sparse.h"
 #include <linux/page-isolation.h>
 
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
-- 
2.54.0


