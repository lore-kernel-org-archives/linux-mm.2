Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F207FCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66C116B00C7; Wed, 13 May 2026 09:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6431F6B00C9; Wed, 13 May 2026 09:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5590B6B00CA; Wed, 13 May 2026 09:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 462EB6B00C7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:10:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0EA3E1A0670
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:00 +0000 (UTC)
X-FDA: 84762429360.16.2DD9010
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2AA6C80011
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LYWbhcC5;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcJbixi8CH0+fCoBl2UtMRXMhZzJhhVobMYZVtSUs0g=;
	b=nZR/yBBz2sSqZwIWTYGEn4rD3lFWMBrOHLQnH/u4p14XTwulvX5GvBb/ldkVgbBg8flkq0
	ZT9p0+JxkJHl62JmeU/GZCxVVDubHZk/ZjX6yQanw4S+/Apio48FXx8rhevX98RVLlF00p
	RVz5klCH5KcWhX9sByG8EAG2CrbIHvI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LYWbhcC5;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677798; a=rsa-sha256;
	cv=none;
	b=nFDi8FbGMUv4sewziP2hZLJyo/D72ByeQk8ONwb2EfC5BXQYz+fo0+WJU7K9IyRBAimmeR
	hZe1NHtPJ8dZlm/jZXbxgwnPJrh01ee3jCaB9QGHgUPghBLEmTZYQMx63xiMVWvTG9FGi0
	mIKse5p5BgEIuHGBYNRN0P7JL06DftA=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b9fcf7c91bso67466795ad.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677797; x=1779282597; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TcJbixi8CH0+fCoBl2UtMRXMhZzJhhVobMYZVtSUs0g=;
        b=LYWbhcC5Gu8bAkq7pO/dXJZqBZwMV5pDdF3b2bYJzoSkF/IET6TGFZ8IqtLR9Q+avj
         Pj4+HKLEONSKPL5LXv1ZuCqelkYqnr2/zPl2SP8tb4hD3kY3Bf5fwB29vQc+XpOxJxUR
         A5u1y9xDFqEw5CD/Lw2EFDk4CnDDAp/22h60s8MeG9H37AcPsU4PO189XCLkOUZlsIUJ
         EO/mf0JzxqHOpyb0eBx3DGDU+VYhyuvFBsW2SZoYQQ0PXFgmOAg4oERmjMa3WioStguy
         2of4Wcb1/tIiqmlJcPINypq02yViaE50n7KOrcEux5qh7ICR/r3nEqBnmfNUbhEzYAb2
         fiuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677797; x=1779282597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TcJbixi8CH0+fCoBl2UtMRXMhZzJhhVobMYZVtSUs0g=;
        b=LXOJtj7TOSV9U9/F/wau9Vv9DroLDAwJpaCX6C8bGi8abkZ2H7VeL+cxq3V9ucfZzM
         vgqmkDOssiukY16IqZBgVxbPzNyx2G+bS7ZUoW+UXtRdt3rQBav4g2cqew9ulqnhB0xp
         8JlMwBEAz+HcCaF3UDCStwPpbNREx7NWRTMk6E1LQ2KWDuGsWCIwyB0QAV9BEb8HS4+s
         VOPZ1p1BvQixWz2+jTivGuPk54pCGnagSisFCiOsoGsIiE7kRi0dYIitURpKoDVa/U7R
         WKaQDa+UPQEQcqPDQFQr9nOYdoLA6hhs5bYP97av/gZZ8RsL6bz4JDDJt4dq7vI8qizj
         +w5g==
X-Forwarded-Encrypted: i=1; AFNElJ8W5sFD6Cdmf+9/zZDeobW+1XoDA3KqTtFxDC19K11dr4k0Jjvxp3ao/bc2aZ641ZbdNCe17jrjVQ==@kvack.org
X-Gm-Message-State: AOJu0Yy1fIOJaOVT579Z+jimDh3yUJngO5W1qxY1MBUgNtdADGvAHVKN
	YXUPyz8X1kfsPOn3o+XkC8H3/D3W0Fe1PvfIx5S7y22u7cxniMKSZqL0PyUm9pqt8MU=
X-Gm-Gg: Acq92OHN6XM1PQyVkF6ZWZqkUMIogF5tjFk7bk6snVGbEi7NlskdXC5W4VtM6AnLck5
	etK0xCJOYzrdKOnO03Sohyris+WwcrpHHwWg0CZf7UOdX9bTAyROuYUhwY3Sy9VB+ia60StO4VV
	C1iUdsr9P1H119ypki/8n8hKuXy9Qnf/qhfHr1MxOvl7PN+Hj1KV8/Xpfn/YbDrEr49voZrt+Ex
	vEOr6t01WY8pNUuCpcCxf6Iz5RSDDUbp9tX71g1LksEaKDAe2a4lNYaDMoZCTJd+8f+G5qopV8s
	gCwlXd7Z4rrusFfE9Jc1jczCQiwcgaALFQLyGneL17oqTXVwNSD3qkZjQfLjS8t27tsv33p5Ms6
	QGj2eyClYXVtAHYsf8RGyvU/EDWL/TV1KO3ZWcdoVpTRldUdn398FYqp4N3O4aICWWVwJfN2Gmd
	oJ9uFQa6XokQdr1/j1DpQXumANrD0Z7hkl0TIbZM5ereR0TPR6PTIHHRZ7K70=
X-Received: by 2002:a17:902:ced0:b0:2ba:67f7:9326 with SMTP id d9443c01a7336-2bd2f6080a2mr31395015ad.9.1778677796975;
        Wed, 13 May 2026 06:09:56 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.09.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:09:56 -0700 (PDT)
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
Subject: [PATCH v2 26/69] mm/sparse-vmemmap: Support section-based vmemmap accounting
Date: Wed, 13 May 2026 21:04:54 +0800
Message-ID: <20260513130542.35604-27-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2AA6C80011
X-Stat-Signature: 1snbfb6aikpyuxrpfwmogpofymgh5tua
X-HE-Tag: 1778677797-577749
X-HE-Meta: U2FsdGVkX1/zKR66BGxryh21jyMv+m5WkFssaG/SHcYPza3xQZ+eI0MXlmrBBSuzT52jSUwXxaYx/AwO1rMjEU0TGYy3u6Z4p4dtL2fy7VFihd7h7Gz/8rpeoowoIK/lLzUH0JSf9asaQAa37Gfl6y3y/7x2/DOzjDMjLjg0HczQGOIhNvwpAsjorLIffC6+GvMf67Z2OYSu3QNTQGbpRyHvxBMk4bASisqvrfldQGkAU/12mEWFEBpLUKvrl9ysaqy/88tFHveGgmTVnmuG1BdOG6NVa8nDG/APIBAIL16jzLGAAKGt/zND8o1VlMdhh6Musbc+648gyPujHOO08WyZl+/j6RLmvK9zDtaVQ+wyKlnEZ1hpW5iwR9t9PlvQPGX7SWGDozKXnv4LoTPxX4BOvZGF1/+eB+GlS7BIle3NB0xw0Z5Os48+iAQngxXSa0yE3HQzXN0YE93x26g/zZSWWtpihi+nKNHQXGTdO1z69ILgL6zrwoUV6GgoHMd+RV3azz9QRY+wpYIqBzrzxX7kzObNseodxoQSA2ztT3eW7PWM4C/3bVXubbT40qtH2YHfAKvHAegt4AbLfXTl7i8OOEvCVzQjso9blZ/uCc3tW1nCU3kyfVKvFevROBKsHhAVcsAtq+xgTVs26uGop1djxKZdy1Rp8VLGNa0OApGnrjbB8MDP10s8pOKtIHmrSo8nBHw+Ib5YqAsyDzoIeyDgL2QQe1mBdd0AQG3qIdN9XKrWKSysmQdf7Y2ea53CyxOrqDoPbq9QXjqpLb856NjD1BDowK+MqJZ0S74fV9OK+2KfOFvV8rb4ikmrFwH8cucZ8gg2TDFM2gKOTCUGBg+9vgqYX9z7IfM7wPVHYLlkOWnrINYQWIoy7XXOquMdMC+qRmARDESW2xQlWG8PXSxJnI61X9QKQhLMZ+F+jC/Bcj+W9pOo2NzjY2M3RF+XrO65G3dipUSIiFP/KrT
 eCHjEMbG
 bMbV4AMDDCWg/IzLDky3IfHMGklidK6VtuhPOgGO8i/Lku53G57HzOLXeibTPwTRjwE+Z6IpzU27djGsLMAVGzFQ/MNeGn75G/bG9IZ1vGxkTpK47j933CQaef8B9ufDM27Mf3MD2/O85xo4Qla70IhaCezbZHM31CcNWvv5dyKmgbA6Vw2OOTteNpt8xgOHHpdqeBK2LNEXmdkYN+6WVwbe7GtsuJJbVj6ErJlylwuQNArrbWUSHY9AOEVHItFlugn2trNVddByg4p/SwJs2q1NbzzWwOWg8SU+UDW9MuSU7OJiZrXUtH9smhl8xyFaZ8Zihn20HHwsu1t+8VD/sDKCppg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach section_nr_vmemmap_pages() to account for section-based vmemmap
optimization, so the helper can report the vmemmap page usage for a
memory section with or without shared tail vmemmap pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h |  8 ++++++++
 mm/sparse-vmemmap.c    | 13 +++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 5fc968bac1f7..0974205abd3d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2269,6 +2269,14 @@ static inline unsigned int pfn_to_section_order(unsigned long pfn)
 	return section_order(__pfn_to_section(pfn));
 }
 
+static inline bool section_vmemmap_optimizable(const struct mem_section *section)
+{
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return section_order(section) >= OPTIMIZABLE_FOLIO_MIN_ORDER;
+}
+
 void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
 			       unsigned long flags);
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 60d5330a8399..94964363d95c 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -629,24 +629,29 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
-	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
+	const struct mem_section *ms = __pfn_to_section(pfn);
+	const unsigned int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
 	const unsigned long pages_per_compound = 1UL << order;
+	unsigned int vmemmap_pages = OPTIMIZED_FOLIO_VMEMMAP_PAGES;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
 	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
 
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	if (vmemmap_can_optimize(altmap, pgmap))
+		vmemmap_pages = VMEMMAP_RESERVE_NR;
+
+	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 
 	if (order < PFN_SECTION_SHIFT) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
+		return vmemmap_pages * nr_pages / pages_per_compound;
 	}
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
 
 	if (IS_ALIGNED(pfn, pages_per_compound))
-		return VMEMMAP_RESERVE_NR;
+		return vmemmap_pages;
 
 	return 0;
 }
-- 
2.54.0


