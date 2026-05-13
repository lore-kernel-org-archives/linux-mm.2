Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48847CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26DD6B00D1; Wed, 13 May 2026 09:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE9E6B00D2; Wed, 13 May 2026 09:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14BD6B00D3; Wed, 13 May 2026 09:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 924FE6B00D1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:10:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F9FE1C0513
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:27 +0000 (UTC)
X-FDA: 84762430494.01.5B81FC3
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8606040003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lpmmmc7E;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIg/xuUWJQhpBPpGQxQRETv9f5LqZHFddPqDq17HTHk=;
	b=pWx55eVBlpkRCsAfhPmsAhTiUFuGERS7i3OPX4WiGQyDo02Cp+Gi5isGpPscp5gsQPIrSB
	WhfI13bPKsZe1WsqYJUyXgyCt5tiJYPK9n9Mt5A9QmWfbfxa2Juu5tkX2+LSSR+uTkxbEb
	SIHNwzf3JzQ8i/OKKnN6HvB59DwxFcQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677825; a=rsa-sha256;
	cv=none;
	b=lyNqmYwxX/Nogarpnt1CAXXQ8xWGVpFRkgT18PrdSzlgHtK3i22ps3bVkQtOTHJEpSsUNN
	BfPntjhZ/GFLyP+1vOoeOGlzhgvbL56z6uaO9XvSBMYBaQCakiDBm774CYjGM+q6ieew1n
	v4CTSqTNEbUi3/mGaJE2pjzyJUEOQaY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lpmmmc7E;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2b458ca2296so45045515ad.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677824; x=1779282624; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MIg/xuUWJQhpBPpGQxQRETv9f5LqZHFddPqDq17HTHk=;
        b=lpmmmc7EnKiNLlbYfpDjX1DR3ulh2Pzr2M88/Y6+/Iz6GF8tAX0EjRH6y/kr0OwQyw
         EnctofglyloCl9BAYIv5W/r5loPBHEKLWmKfDIE9wTCm6TShND8H+Gb6ott9BWKCXgkV
         1EKf0hokvL6cWeaCgxPixcoGmRM3Sp8g8uLfCmjmwj005tRki1039C6e/rODyxl3Rnym
         /VnaPWlaAFRLI0t+uvjX3ryqTUvPjBF1p04jDn4Ea9nH+YY4YF2gnoHaiIvfk361zP/+
         Wy4n5yCmqSvfehMx8VqPZ8M+2mrs/ZaNWHOJwvszKSXchLtl1K1rgbP0DfdkaS8ssHgZ
         ONtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677824; x=1779282624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MIg/xuUWJQhpBPpGQxQRETv9f5LqZHFddPqDq17HTHk=;
        b=GTyyYeaU7IyWkZLCo8DuSJtWwYevqN6CZQnL6YLnQb2yrR1Z+u3/xRGVuHZ7jLrMZg
         oXCP2aQG0iwxamMKh4v+6RyS0cF0tnzfaeL/QSj4QamA5So+dfbDmfoHoGzNjZ0Oo8NV
         gm451lWpoPMHsBA8xAjGDihLYcz4496hM44qpnb0VR4jf6Vhq8Bthg+EJwZi0t8+g83R
         HQID+R4J0FOvpW55tpXPyVQP2BwwxRd9prmfaD7FK4k715zlp53THE6Y+EuH0TaXQkpd
         5KOS/hykqKVy1YoUbdCzXHMvh2frSuB5WOWFk4zMt0OCLcwoiDkaS9in5252cFTjXxPd
         7nEQ==
X-Forwarded-Encrypted: i=1; AFNElJ9I2egp2A18NTFimt8u63aeuLbmU5vlyuZEzG8btfz0d73E/rJoRp2BpftrVu6VyMIvU0xK78+WPw==@kvack.org
X-Gm-Message-State: AOJu0YxCxgRof6sbuLOCt4GNw64bq/m/IIvFvW5XmBERKE9WTbFSIJh+
	wC4pfQRoOpKMAUuChaQbwY82ez8EmR/ybBdh01gEcc65JbOOl+HfqbKox2LLq/dD2K6SNIqTnt5
	Bz8vJdhk+MA==
X-Gm-Gg: Acq92OEWzdNt2hQltBpHbQtZRMg5Bc9yH0ilt5kD2Tkd/WWhdpY6Pk14LrV/jkJQjAM
	CSI6igSCTU1QDr67oFwMzMEUlXRk0pRDc1Bt/hTtosKeTjGSNEpS+4/plj+EQM36XOPVmP+SbPh
	PuI4S0dOB0Vkg45qT2kyzNbWtPidl4ZYtTyci3ftNTCHT1RWYcet3m5tmvymQbSMy5EpPmh1not
	j32U/1lI04aZqM3QV7MJP2HU1iplGXYB5npWkxpxW21dphCKr7uEywVU18nm6DzXB32R94gIgAt
	UKEWLPnr2UpR89EsJUh4kYTwCZ0pOleXcsaOuqO/NHPKz/m7+U5sQev8MLvZyPsdBpMTYF0W2ZM
	Hl3fMXhfrs4s2yW6fzOFE8lBZQuHDevDYOlUNnnq1F3t9YRLmA5XEXzcOqZJhUa1UFo8doV6pG3
	lgUHQKdy7X6jAXpm7/qukGVM5ov8ZNiy0nI3pOaEiTzBvNyPhjQcCkHKNVrZg=
X-Received: by 2002:a17:903:bc2:b0:2b0:c45a:bc2 with SMTP id d9443c01a7336-2bd27139901mr29366285ad.16.1778677824098;
        Wed, 13 May 2026 06:10:24 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.10.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:10:23 -0700 (PDT)
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
Subject: [PATCH v2 31/69] mm/sparse: Remove section_map_size()
Date: Wed, 13 May 2026 21:04:59 +0800
Message-ID: <20260513130542.35604-32-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8606040003
X-Stat-Signature: x1cq7dwxmc9kfuw8timmj7qpumjnmr65
X-Rspam-User: 
X-HE-Tag: 1778677825-212766
X-HE-Meta: U2FsdGVkX196GIvgaQUCy/Y8KV3gKG75SQuchRLHjWnwxwWhkFil8xzq+oXb731VkmUDh9Hr7w+WCWm8cIBG3f3GzDvfDjQ9fqaUXmVxSDCtY0OoQLifwyW/xL4xaOZdWlZfm1R+h3WvupZuazniwlNwLzd3xhNzqXrSI06qmjiyiURiftRHZa1rV8mp8DVdj/9T/7DzoR4R7eJukj1d1wIVjOjx0mQfHk/+tLrKLjx0pD+qNn+mBvjwobKVroQXEqHKT7ifjHodd4IUu/jJhYppIBEyzELvUXsYmOSUlPbHebu6dAY7TfApuh9whIYMrjYyqM3dJe8t8fJBzl2cKp/Keuu9m/Cioh8EA9JhvJo4Exsz6KBeHAQ8LvX0vGKgK1Iealht4xBcFgqxLtSzEWKQ9CUTmUp0api4PUqZIwmZgzNipIIEHxfCnHuUoLKICh0XkqTGNKINmT7dB0uX3Yr2NN84/J4nfs8GxJFzlrvpRCYTiSDygVJcudXUso2pZtFmsKuBU+n7j54nGl1tZ3nEK+94z0RhGAj/pK74sn2DMWry3RWGKnMkDSRh/yzI0zsMin1IxxRTQNn3mZcvQH9Ik1wZ97ifRHJQ3Q2Dr6soQBJ2FX6RtNWRVOIbAQOw1KvDWNd6KqGEYaBnefKf22TnOxv/ZhGzis6CChETlsCN072DkzALgYFS8ZePFebJ+FMwvQ15G2VZP0SiT6f8dva7Ksx4qifYvyWRYvOyHY6/E8UWvmlXiugTObQfP9sj/03dwoBocFxA2AFfEeLroMZa+hGxtTQxFTe4xL0TjufdVrWg/+LWHWOIW4IMTuqGI6wOmaAoEKDKPY+kSy5BWjwlv9miBxVIYS+xkdlisSrW4T4Hqo35e/ARrWaevOhPBU0YQtZXwgrG4asDgGiXLjl3MbPDrtLsjd2sN7cE1o9dNvhawqZ6IyoUkwTr8dd6SdFVqkXYVsjxOWWOd5b
 JYcNUxsC
 xDnXFjQnzxlxr5HygrunZa1OV/mCGtANMXpEXLKK0d/lUsYrko2bTc/NpCtcUNhcFAf9nEi1lSxnpyQMFsEipgHav3H9fXfmFcQVU2opCnTE6as33zx/EFfC9KU7MYS6X8tFMPIxHUe+ObohzuOkv0cCIrRUuWWovAREfNPXsSCGnfwX714Wl0O8UlD3BscacdKjcvKIMhzQPQinDnBtASf76uBXQBlblrgfCnkLh9xwQKlmcYPg6ZiIV9wqoqSPcIq0Ywclqqkt9fGHHzlbYOJplD7picOSU/mKTPwfFSbAL2gqVHzZy1hWMej7aNuoezDXB7YxGxVWMfXPKkJCWcP5nJ27WyVrT2oZ25NFlqJESqe04sBbYsHBPMovrpKf0FpC5uuQqwsi3Q+o=
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
---
 include/linux/mm.h |  1 -
 mm/sparse.c        | 15 ++-------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f39f6fca6551..fef39be8acd2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4845,7 +4845,6 @@ static inline void print_vma_addr(char *prefix, unsigned long rip)
 }
 #endif
 
-unsigned long section_map_size(void);
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
diff --git a/mm/sparse.c b/mm/sparse.c
index 33e89bf1ec0c..47349f6f463f 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -222,23 +222,12 @@ size_t mem_section_usage_size(void)
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


