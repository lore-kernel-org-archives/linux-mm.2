Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ED9EC88E40
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 08:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B32C6B0098; Sun, 13 Sep 2026 04:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B986B0099; Sun, 13 Sep 2026 04:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A1D56B009B; Sun, 13 Sep 2026 04:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0536A6B0098
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:41:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DF2BA544D
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:41:06 +0000 (UTC)
X-FDA: 85208094132.27.CE93FE7
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4B89D1C0003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:41:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b8ox090f;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789288864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NjqOF/lS/S8Rdm36whah2xYfroMiTrYUBQ+49bShAw0=;
	b=ddmHsoxUvCJXUpICqsSRel+oR/qTVEvQ7LFugxe5Vw1lC1qiSp8pz3MDTdszpiGUD7vtuJ
	zBUbxtv0zxgd/ervcJ54axuaj04GJPTFM34r8F/NDiy5IYSQrAAR4/u2JqNZbp2/rpZDc4
	/+lMkmwO4KOOFn1a9+Qx0psmPXXrbEI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789288864;
	b=UWHTqMyh9Ot7ArxZBq1mAIqBojGzZ3PhUspdUpaGC20b8Hm90OejQNLhM3qduiBTKPS8ua
	EQHbglvnmfpSqmB6R+8yEk/dudG7lgvZCzj+GZ8/dUv1Mp34ACXXUDuFvrxIs4h/YU4CT1
	hhW1iHBebTIxkXipo7hBy0HzHufs7ec=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b8ox090f;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-8625b35df89so54090b3a.0
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 01:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789288863; x=1789893663; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NjqOF/lS/S8Rdm36whah2xYfroMiTrYUBQ+49bShAw0=;
        b=b8ox090f7+0KK8F3N+9P/RLJ6Fc6Y2K/iYFNNgp3HbfFqS3FLu99tqUGo890jhkSMv
         cYbaUlBHoLanpQuzbPjWaVJKY+hOEulhf1zcyyHHi9pNRgabvE1il/2pKTCx2hjccMsd
         om6YAlCWZwNUOw8LXuU+qTnrlvmawR5zSVZ11tKr4dk/AlHlHIoKLTe4zgGMlqWr3wJq
         OPJa2Dwqsbfh1zOk0H3hVLxuOxDieBUq7aDEUiAbWRQqXGCYMe8wu+C09gk74yHi7PW3
         gE8lHar25igAykRbuTsRXJMa+FXZ3AwtFM6HVymOTnAJce/kWhWxyzAg5Bq4GqZKI1Sk
         4bQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789288863; x=1789893663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NjqOF/lS/S8Rdm36whah2xYfroMiTrYUBQ+49bShAw0=;
        b=m27Zqo9zWPtInez03A//Oe1nHkOdg4+TDqyK3KD518uQHg+zYq17T2t1nGp15Y2Y+z
         9PTefWFgXFifwjErpoZZs+aQJuB0xE0HoWoMs7jnLKiuuIk27xpdNgrX9PDrhimPt0Mg
         D+deQru8S2plWxU7ohRaZXUyX9phXZt983o6HiXTLPiEe+qLAFOwkc6ZJj4ywpjYjgHO
         YNBj028okeagAHn0KYAeaVJwmxlRMczJktDfF6QMUBIGl9wwh6EIB8SJdtiwrQzM5eOv
         4SeHpkOkpk9fnNiiwz8L0ZK5Hn7vQEP9aOIHVZVG2Gj0+vrAENRnzsLgoJ79/f42Bknz
         dyjA==
X-Forwarded-Encrypted: i=1; AKwUvBwaLPs+oohbnIipRrZnbMKB8AV20A7k72Q0jSz6BPhX6QTinGHJhyBJPy1IcAeOBYP3qJ1aCxZD0Q==@kvack.org
X-Gm-Message-State: AFuF++nKPpld5+AGYtNxqCjN7sQ+kkqcnTiAneEXqKx6iHftIL/3PXLV
	F/n3vD2xhIYY/Quo5kSG8dhFXxzBqfAKkuJkpHJyL8zQzdCw3rbtviVguThqPi0eyNM=
X-Gm-Gg: AYBFou2DcLqGjRnUl/4Bv504tm+4lg8R7c+qbgaID4kO4tgytdFWJN6PMnZCdc3zObV
	wFj0brQAj4Bh51eqYRdo5KJip2f4WDreDTSRVzOffTl1b0eWddWTrD2bMRL7ZNE9ZpHRVjB2zU1
	HWe88YEAvfxyBIUFi7MbaH3xMnkOlNT99toMbk4O5vZ/3p3IXjScqsMkcllotxWJZRd8pLuOe9l
	ZfA+PzZCIgxtKnPs5bH6ww9rOqu248oTqcfa7ZOs937WdKzzn2C/LSsY8bNxJj8GtGeRyKpL4NV
	JU2nO2RSucN/cuE1+96FAJClS9wu55iO/Q6yXi+XLLJxeASjhllcmNpX8ddhpUIZC+1s7Gi7B+H
	vhqW8kcp0PZsK4PWQpwLf5wSv102LCdGWA65qKRWa7iY7N7dzgZK8fbdaYdv5goityemZiFOedH
	yOF6kcTPQzJoBqKYktu8O9cj3PzG8IWv95HmBf/AGudKv5OPheb/+IpvQeNg2HDeaPmsp+Q8+00
	FTdKWhy7Cj3kgZkFW+KbIx+lmI=
X-Received: by 2002:a05:6a00:428e:b0:851:8bde:7861 with SMTP id d2e1a72fcca58-86e2a4c9a44mr1541510b3a.1.1789288863105;
        Sun, 13 Sep 2026 01:41:03 -0700 (PDT)
Received: from G6L4RL2QG9 ([2409:8a00:1832:cf0:5137:990:100e:cc7e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b29cbb0d3sm3070531b3a.42.2026.09.13.01.40.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 01:41:02 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH 5/6] powerpc/mm: make vmemmap_populate_compound_pages() static
Date: Sun, 13 Sep 2026 16:37:33 +0800
Message-ID: <20260913083734.86802-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913083734.86802-1-songmuchun@bytedance.com>
References: <20260913083734.86802-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4B89D1C0003
X-Stat-Signature: i1a5j9zqqdfju45wyf8da9shyqy5ruiw
X-HE-Tag: 1789288864-172829
X-HE-Meta: U2FsdGVkX19RiDPfxtVYA+ZASzqBN1Pger9NYbX6qcX1UyF23xRK34si3YxZxnOw3bGUd+sjmvLbTFWC6UaggNAjMRbgwnLR1Sru+0tiEgbUkWO5UT48yqsEXrOxx+gsh845vD1kWsE36RBjXz1QJldAoXn8ybmWVYuLElmt5WaanW1VSiImUfeZrfDG4hXbilw8ESONdjVEmy/zo/rQu5YgBk0wGbD0ZMRV9fYBFhXWkuk0XpLXxRvdevp+sr5yBcHdwOK1X+32/G9kzchJFAHGrQgqM5I9Dyun6p9Higa76JeYEzo1trcTCtaWzagvU3NqowLzd0uUqqn2EDMFgXhWKZjphoLcwWiV2VQh9FVCWeJg5hd1b9blBzr/ATzzXrtergoO0ERDD8OU4B5YudOp+kEAizc9WNIgExTDtXhets/JDXiprvhiErwP6KhPSGzjUMrS9hxbDBCrSF9Z/9OIXBB18blENwmUgtrxhviCGuMxGEVFqtHwHDUK24/OW8vCRM2H621B7Fp9DFjo26uycbEFnZCA8b9v8YAPpbC0mcFO/mlgo1JRmVjaYoQw2ueLRCTFD0kFcwu6H3Ayw2RoWX3B/kuzjEAZzzsHbl1DFjFc+D0YalVmLcBHPNgo5J9oBt1hUGBtwxitYsKR2kOXLItPGQOvK7EYj8Se6PSn9ri8HwgBGZ/vjUyxCOMwLPws0SqvXZb8LB6jp/ncl+Lv7O6bc0De/YzV/ps2M+qiW9X0uEWYsta9Sm4x3WcQKpFtSOG6ymc7DuhjTBaX4EloJbo5TcMI8Pmetq1H7h9H2huIB3HERaHX5zDey/iegmDLB11Jh+g5GRuUUlfWlKjHPNaraOiXNak/R1FsirssJ/shUogIqjSM4hr9PnSnUPx6fMSUb8e9FsrIvovRZociHsDC37OUtghy0lY/O81FKeH2xWStVDCyK4dVafS2UI9Mh4NKkpIVDl1sQhs
 0/gnmFeO
 5On88inM6NhHKp3n9rOlhzRpIBvoMGjB2uVepC7t85EMAHymwNYfSWsb9Sc2NSPWmsW556V8Y+aPiswyetgSZOeW5fmDmCeLdu2qtq9gW5HwFEBCKK8mLzX32Kj/SU9XA+OMeM13FX+ur3QZiPWBwXI9Pu7npf3Lw4382nPDPtzRcREohyNdOunOZCorWEhdgTeT/c4aBTHab1O/wS5RrGw65URjqIEIGmaPN/jSkbFZZ6C3UXRV51Ez3DYhAkpCTGZVtuvFAhA8nUzKvhDsc6MWq+QtRguXNfUjrj3ug0JiFWD0F+MVSRRfDKlBKMpebeqKehWwuDPUW7Samkjmc96ahT0ht76WHuPVZt6ylC9ykMqY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmemmap_populate_compound_pages() is no longer used outside
radix_pgtable.c.

Make it static and drop the unused dev_pagemap argument from
its only remaining caller to simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/include/asm/book3s/64/radix.h |  6 ------
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 13 +++++++------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
index da954e779744..8452a2714cb1 100644
--- a/arch/powerpc/include/asm/book3s/64/radix.h
+++ b/arch/powerpc/include/asm/book3s/64/radix.h
@@ -356,11 +356,5 @@ int radix__remove_section_mapping(unsigned long start, unsigned long end);
 #define vmemmap_can_optimize vmemmap_can_optimize
 bool vmemmap_can_optimize(struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #endif
-
-#define vmemmap_populate_compound_pages vmemmap_populate_compound_pages
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap);
 #endif /* __ASSEMBLER__ */
 #endif
diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index cb72d9ccf747..ee121cb4fc12 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1110,7 +1110,9 @@ static inline pte_t *vmemmap_pte_alloc(pmd_t *pmdp, int node,
 	return pte_offset_kernel(pmdp, address);
 }
 
-
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node);
 
 int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, int node,
 				      struct vmem_altmap *altmap)
@@ -1125,7 +1127,7 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	unsigned long pfn = page_to_pfn((struct page *)start);
 
 	if (section_vmemmap_optimizable(__pfn_to_section(pfn)))
-		return vmemmap_populate_compound_pages(pfn, start, end, node, NULL);
+		return vmemmap_populate_compound_pages(pfn, start, end, node);
 	/*
 	 * If altmap is present, Make sure we align the start vmemmap addr
 	 * to PAGE_SIZE so that we calculate the correct start_pfn in
@@ -1221,10 +1223,9 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	return 0;
 }
 
-int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
-					      unsigned long start,
-					      unsigned long end, int node,
-					      struct dev_pagemap *pgmap)
+static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
+						     unsigned long start,
+						     unsigned long end, int node)
 {
 	/*
 	 * we want to map things as base page size mapping so that
-- 
2.54.0


