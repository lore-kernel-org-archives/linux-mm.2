Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32F43C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 282A56B00B8; Mon,  3 Aug 2026 23:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260606B00BA; Mon,  3 Aug 2026 23:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FB156B00BB; Mon,  3 Aug 2026 23:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DFE9E6B00B8
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:57:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DEA6C08AA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:57:01 +0000 (UTC)
X-FDA: 85062226242.24.B1BACA7
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 941E0140004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YcDC5E8I;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mqxr9eZTBHl5pXezv3m2vidjAQ6kefgcXwuYmW18Fa0=;
	b=ZrxVX+lYuBANmZ31JFo59B4u3RJQTWBhGgTFlIBw5oEadkzM28OljBwiZW9eJgwJseFpv/
	1kIJgANPv+GNYibno+bjvup3hnrupuqp5ZAdUaPYraBHeBvKvrmiq0uncVe4ah0toF4Fnt
	TbUdx3K1ifanIrFfMpiRGzu7n1ZxZ5U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YcDC5E8I;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815819;
	b=zqOivSpnB5xH2NZerJt2riw4CsNdWXUYcECuww07rtSishB4l5yXlRtfwfJ3fyK/WtcI41
	x/XAZ8X8JIKR9Ny0I06eFT3/6ZkXKeQF4D3XKTBE+KlXuclq0ghqlhtKZqqHe4ztCMWeTA
	pPSvvwMkMMJ75D+NNcfFxELxouO6D4s=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ce7d2adef4so65479045ad.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815818; x=1786420618; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mqxr9eZTBHl5pXezv3m2vidjAQ6kefgcXwuYmW18Fa0=;
        b=YcDC5E8IhzFveHBlm9wf04L2hHJQ4EksLkxD36EMrJXF28q15t+CPV0bUf1L6lS2ss
         53Fy1i0SVlAlju1rWZ6xPvKXdUnnSQh5EMRYAZlDor+v7Vg5wYeUuAczNgfVlZUTpe5B
         sLsPz+0OzzM/crHUjktLFEXp4wPEUtr+MHUdFunaxI3lsEy7Whv5Ma1WathhuTTtZRZV
         Psq7o/s+68fskUgK6DJEjwY99FtyQRH1UTwyFCUWBOKrb3lZQsiw1RZrM8pyc5GsHbJM
         stCWUXYP8EejiHG6eEjPsFabLik1VlAiBokdI0JdqTzZRusj4JEPRTwHWml4bVVwbRU9
         F8Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815818; x=1786420618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mqxr9eZTBHl5pXezv3m2vidjAQ6kefgcXwuYmW18Fa0=;
        b=Vy9nBnkWxzHQ4hkUGlx8c1H03L2cPAFL/L6D9BK64DI6ZlZ0pw5pdmD9q2cr1mfi8G
         S7WvyLF5YGjKYnOBsIVycV0yE15ErEkM+tH+AgTh8jyN9vEdQXZAYbnZDzYXmYZXe2xJ
         80OhvXz7o61FedBsQ/iQnS+kKvgOWBy7yNhR8HKA/0f8u7Pxt17P+4g1q66foJdliDBh
         hhVhqF59e0U9VYPJiK+EqQE7Qye4c2jr4UQd7lM4lsxB3wf0BVYItYbrSLSg4AFI/xrt
         fyUPkKiVweNqK2OEEevXkqePnH3RyxgooPYfXvMmnyC7cxo/QfssCd725FcUeUbEJ4Mk
         ra8g==
X-Forwarded-Encrypted: i=1; AHgh+Ro4mPkdmV3Q/lvtz79u7t6o88DFKLmkktEVNohdfanjWqKwNymVJ+7uRzWqWW5QGFRTbUCp0vqIDw==@kvack.org
X-Gm-Message-State: AOJu0YyNNksbOH2iLnhvykmigH/N9arnupyZiP43d90rniFXHTcC3Rkx
	+n7gDh72UTEu8BQyG8YhBFfXcr76kp28K8ApdcgF1co1yn/5FpcUkB8LfRDdoXIYs+k=
X-Gm-Gg: AR+sD1355qQM332cf98B+AD6vDecs+R/0yE6rjWWXU2PgxqaC9lgkFm41FTVlHxyP6z
	lkf8ObV59Ir9yc/N8OmbAprTR7WtIvEXK026RrAvV5/9mzU2ZtY9wyb3WVi38igRsBJoU5jTnYD
	66tASi3lNQxwLsjNCdOeun70WtpAGKrd/88cQgABhUmAIeK4ytIR2oFNx4POyzRcdalw6CHNyem
	mTwaAe+z+HZ5+1j21pzvI5+HWFvErAHdd1ySw1G53fzmvF0FEzOrS1qUunE45qH56saGH0ORzyH
	dp2SgIKl9ebwBKIVGkc3w+bChbv/aHdsv99k105KBW0fVS59qTDJcmUYA4g8zUu3055Gnc0ijlM
	Nhm2vf/6+G7pJ6TVWWJjOyip0UTLl2iEtpDgKQiMMlWjuVYe9bSj+GyxCqWr+NJUR7YxngHdW72
	F8Pr4dCk2tDSYk08awWFbS/NqE2GQPfZ74CfxKs5QZHQMrVXxHtLdchDuNhPrjjXenppsX9FGPp
	NVl7Rtg
X-Received: by 2002:a17:902:d2cf:b0:2ce:93a3:c168 with SMTP id d9443c01a7336-2d0521a4f6emr120492725ad.7.1785815818485;
        Mon, 03 Aug 2026 20:56:58 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:56:57 -0700 (PDT)
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
Subject: [PATCH v3 17/17] mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID
Date: Tue,  4 Aug 2026 11:55:35 +0800
Message-ID: <20260804035535.2846016-18-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: isxtayquh6rcect3kzq1wx3czciwgcdf
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 941E0140004
X-Rspam-User: 
X-HE-Tag: 1785815819-600200
X-HE-Meta: U2FsdGVkX18z38nOZeB/0wvn6p2vQqazWThdIM9kgXcV7aHQIjY6oC7LrwZQpou88Rj2WfAgEFBrcmQ3j3CSWcd8jy/S+c6HMXmhZYywhZ2keSmVL21wZm6jNwD5m3OT/l0CNqWtAdoWZCQjG7cGIlXhkiPzMzNE2fVMmPlYCpGRg4P9YYQjq6L8Ks9ZnASb1evzh8y2ZFnsD8FrpGbBlVMqHSPs3XAMPZhsoGJC/LCKUyLJVW2RG4/ll5wZAnQXlxhw1BBnfMUDipdPU3Mcs6f4elIigyN5yz5yX3tlQX1uoCwwJ2h3vvCsXrEuScgGyVGQbvfuW61p5OfpjKJ2AWyCEmnFCfuPnlHVRS9hpp9/9PHXp/dUN8BOeW7iu0OsUf0v/Al8r/t+/aEzrqp8MOVeVl1r93r0lAxOCOn24O6lvVUqsJbXRdLF1Kh5JGx0i61i3UR7GuT/YeKRikzRgpWE8IHCDBXmN9xaEHiQnJiEglvRhBOwg03WsQVLDzThWSq15H8/AgtL8W4GmRjntv73p+P6vZ6oaBzCt+9PucM21+sk5OB1/FzlqBqquYDq4Bg0qOQVgqmywjGJiq2UKKDLl9hP/KcKcbFOpJ8pHv89qc+YS/cnKeulOsfwu1HwoYHcEKZuZcN/ZIclRv3sT4RFrjXyYrbSidKMeNvoPHm+8vSF/5Leqs2iJOzWPuqg7/K9uD+tyfCyhtpVdXUvE+PJ5ab1K3cHCOaZ5mbJGjH6YdpRKumY39Nqy+RJUlnHI2D2gD05VEwV9Q8DuPd5C1Xe0tsthCM1eWAB/w/4HQjvEdyNA6057ZksoanhCdboTA5jFEiuZztOa2i+TlT4ccAbRZlH+lF77iltJB1GmEQ24MitLZH76KoZs2uimaDqXOif8JI1Qedv/9+FhivV2BXNuWulEaCDZfBLPSpRmA9BLiR8bFIa4Lf86qXua5H5TdrenCcYNYDN1Ijwo0D
 kSppfwok
 xwvQr8PRGMSPNNdeTk0GXkNPXtDKjKd166gZ4R+lYyEHOiXHWqkqBCZIb+JSxgIKagp8VJcL0L9GJLxQ4/JCZ2I0LJZAU0Y7iuh5HlNQYvPaE/XLRgaI2xPmTPN5X5YBHrUgVaWe0Ht7WLTiPyqbpS8EWraWbqrP+ZIBoObg3FRUqe5CWhIBpjoVtHTT0kmabpfmsDNTGGR7Mo8n3WrFdCtuCx2X1B7wvKUR2y3AJROn4W/bTRVI8/7pcXh5UHLUIm1wsfK8cLgWiHeW/xoD7RThWljqJDl57e7vkwHIH/H16FI1k3FJWMob6G/0mKTjB7kQHzWuE0nvCY7QeHe5mJrZIwym+QORhv7OJKIybFAOPARoOjJO4/P0/f2R0b+W1dpInP+zysK86PUhJIOd/mH3Wx49uNdqgV58NE3o3B/NEjlmZJ7SIQ7jqEL2X72A8CXykDPFCVyLH++I=
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
index d978992e2770..cddcd752505f 100644
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


