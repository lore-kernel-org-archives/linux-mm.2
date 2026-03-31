Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D5BE1061B32
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7926E6B008C; Tue, 31 Mar 2026 07:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769C26B0095; Tue, 31 Mar 2026 07:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F656B0096; Tue, 31 Mar 2026 07:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 546836B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:30:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1A21140D09
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:30:36 +0000 (UTC)
X-FDA: 84606140472.15.63F7E99
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 505A61A0004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:30:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VkwWlWlI;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774956635; a=rsa-sha256;
	cv=none;
	b=c7OhJlO5athgEWvRlh9Tt9RxgCpu46DhVpnETC1bBI//V8avhBs76rj6m89H5d+FfEFj+E
	MkLPL1BPZFJXZ/9GYAr6PGYZ5kB6WfLdtimTtcz3niH5P2a9Fbk5lT3FNcWmB5nU9CjLT6
	51tZt9zeXHnfV4i3uozlEXezsFn5TZU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=VkwWlWlI;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774956635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XBqHhaDGqoANwlAvn/RbjCMLx5VT6iQBfuPcDypB4Ao=;
	b=IQxcbpKSPR0GwBRpxjnRWUzZ9gOtjPaN6dIU0jnsWwlMA1CRdXYa1TUX5xXXhkhOKvWKwt
	PdBLA2+dQ6JpaszrppRoNZ5vPbmbgfOACwngFovweBpyQ63IOW3wNX7AYZf5EvAup6yBJO
	XsIJP64aaOuhX52tmKlXNny8P4YYMU4=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2aae146b604so33012945ad.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1774956633; x=1775561433; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XBqHhaDGqoANwlAvn/RbjCMLx5VT6iQBfuPcDypB4Ao=;
        b=VkwWlWlIzWuuUGQjK8R0WfJYUqradG3x4BqmE9uze9aiW1ZAILiI5AsWC/qW6dBgU3
         5XN65KGLbh20gOK3FH95LYlJBBFb+4sp0xxxG06fZ9jHpwZmye40HASFkPZq39ieYr/f
         81nLJsTInVE5XsKuFBFhK0Aaa//EVdfCV4E04qUodav+8gD4FY+W65AJRl/vVc5wQqTr
         D4NVAdRXIzotq7r38fpSN4Gt4cEtnVQ8Ezd26uzxwgHe4xQkb8kLsg98BZabCSp9wVsA
         QjCqk8CRoGwoQJHoCCPRM66KKxhS9QstfNygCEpoywZCzmHFJdCJ0KUqhEuc+RiWkBsu
         XKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774956633; x=1775561433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XBqHhaDGqoANwlAvn/RbjCMLx5VT6iQBfuPcDypB4Ao=;
        b=WwHygJgUSii8gsgm+q9ShthtnVnDzHgmmGKxwLRK7NI0kniHJ3JxxA6PS4sMfzxbZy
         93F7WWbEkHuEs4bFAijRfpJb62uA4L4bIsJntg/RLBs/NXmjxn4a230W9eRGiUitTXwF
         MPE4HBdHZFF7FJas1ai0lyxGauzLwQ4WYiDvHrS0EwMdz2aOCyTK80gfgOIVWDzfhSUt
         0hR04HXrh2GBXfNNCNT98hLai/EU5x8O1er18JysnvmblkHeIUBTNc3tJ0aBpU2VxANB
         M+sZD3N5+aUZHzkS19bb2LBoTmbqS78hJQQQJ9ubPBJ103BxnbENvmdQZUO4Sp5YcEmm
         g+6A==
X-Forwarded-Encrypted: i=1; AJvYcCVzJAOk25uMMsBFHGxCM6p0Zi76V/bhtJpstRPLknXb98fnNS1gGZBDrjKMAoK6h9cD6swJsN7LTA==@kvack.org
X-Gm-Message-State: AOJu0Yzn9g3NAmSAkvTj1S/0i1WRe4mYjXkdtyWK94PSpDZt1pqFzh2B
	uWBkq9WEZiR6HijLn2iSRFoacACtoo7ZM9jsf0WqyQy5KqtFXjjhQ5q6x6mPVid7cmk=
X-Gm-Gg: ATEYQzzSWEEEaxEHsQK9xmOgmLzjp1NkQh4cllj6bH/y0qa7XPiNIpc7/Fmzl9kWeob
	6O8YtKd8RpheqlxliLEXix8LE/nxy3OYXgYqAPgk+jtgV5LwsgfkL+5H9akadIHyw6jf6PdqvO8
	3yTq/qbmnJTgc3i1bXfCUZOL8ZZ+l8kQSLuzYuKRmX285pMKdntWPwxdB8nPYH/WQ74JSqYpCaK
	14rB/wRHenEF0+LhvhooNttg3nZppFLHYHUN5suEs+Z9Pvb5raIJHBCNfDjuRaUo3apbKfzlYg/
	gj7JYlbVcIIkGt26b85zDry3iJdvI5IwoUzRXF7kW1LzfzLoZ5cgxq6exgOMOaassYz45yyLNbg
	ZCFlKlwlifNLG8xPV3HjGjf3kAzSYz9zNmsl9lVTyXK6W+BFpZtBi9paIS86fQbjHhMmZCUE7mM
	ufgJkwtpq7Huh0dKng4GBKri70Hz0W67GAgo05rZEKAxo=
X-Received: by 2002:a17:902:e883:b0:2b0:6323:1758 with SMTP id d9443c01a7336-2b0cdd1ad56mr170056755ad.48.1774956632637;
        Tue, 31 Mar 2026 04:30:32 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242765b9fsm132159255ad.43.2026.03.31.04.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 04:30:32 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Petr Tesarik <ptesarik@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	muchun.song@linux.dev,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map alignment
Date: Tue, 31 Mar 2026 19:30:23 +0800
Message-Id: <20260331113023.2068075-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 505A61A0004
X-Stat-Signature: s9fiau8bp8xu1rpw9swej7dhd8wbxy3j
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774956634-983799
X-HE-Meta: U2FsdGVkX18G5pV83q4dfC1B0nAYXgKNt3/1J+EbF1LyRt8huWwktXG3bbsJx2rA4YT3plBnbuNlHLaevD+UhIcbDfaJgK2Zq3iXHpSNWooXgo+pUfoWoubu1VZdqSAavbvin0TwUeEkbxuaTN95Gjc+Rkzdbjv0b4h0rsuv/VB/W95Aq8xof1feHeG7ZEfetrg5p+w68YtnMaIpF3MtlGI1+TLLuKtWitdcQ+dnJ+q9NFk1AwTGT1cL0pzOB00A28ehXNt1CowTA8A2QbRoY91jPgDM3fZ/RfDf67RfKMp8V5CaFikFzyOxL1p8dAkI7zEXMYfhIohLws21aWDTQZ/pvPVmNdictIneHUOTdon263BLc8Voc7/YZLFocfKDn73xPEShLvfah4BICIir2TUkg6gOVyA5KtxL73iYtYCTTGjutfru5obEP78ommZ965iRPJgE6Rj4t+t136HuPZPYjOAZE8JaPArG6S5psrE6sDJD/EzQATU2Qs/HLGJ5GDnpJQalnZ/OlnrjjCp4/igeZVHsQb3+Nnkd7D2i9yrqMNNpObNyx8+/twrYuV+Mn3nDIPGT6w6BQMo91Jd5+W/MFhaC6Yr8TIBEWJIBlwhKs6UXMg1ZCpznjNQRYoKSDjpg4QpMH2SyrCpL091J3MRZbsxT4VMX6hSeY9C3AtJnPGxmFeP9xuGIyI6SirdNNsEmbpfWDOJrFHr9BNbrFiOZO+9OqDP8jr7JUUF1WFNKKrmaH3a7J75WnRpVza6mPZvJmHT4kFtbZD/eQhgdFLnlGyk49o06eJFPwjSsxLYP2EXn3LxY4A3JvntO+VSWj0wmtUH/DecsHRBw8ugRuQNcRx+XB4/48p85OAmiq4dclRqzeZLw+Hwc67ADQm4wdXN1Yskcysg0fvUsHkpQu+aApJeG0Xc4tEbgFwb2aSZNH3Y7qef6wSze5p+0wRU0Wp+Q2GfjC+NHzEfg1EG
 J8zk814b
 0dspQl3Qd5vbYL+cjZvsN+oHzylA4IN8UNzOgQBsDubBP6N9Fy/ES4PshOiKChFNtyCWZhhntV8ViVshuLg4lQPIEwiMqIW4pVhoscGAFdGpxDmrizCvx8+d2uL9OSifS+WrxYMXbODs72ZJmo2pSiV70xR9QmMeYc317lIfcx8encNni3ukP9IvPt/IAgZtim2jyyVUBA4cv7Y9ZBvm9BkCcJpto7/z5NRwH41bsDQI6QR+HKtll6Ih9Dpp3J7rwXOlwGxl+2vxOAV8DKUX21MpCC9iG1gQDNVntq+L/DjlMLXX9ZX8yA90qPV8HZwWs8+AW6NbGtz2ylx/9NkPSm3VImBVA/Y89DxLrIkiTEAaQJg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment in mmzone.h states that the alignment requirement
is the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT. However, the
pointer arithmetic (mem_map - section_nr_to_pfn()) results in
a byte offset scaled by sizeof(struct page). Thus, the actual
alignment provided by the second term is PFN_SECTION_SHIFT +
__ffs(sizeof(struct page)).

Update the compile-time check and the mmzone.h comment to
accurately reflect this mathematically guaranteed alignment by
taking the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT +
__ffs(sizeof(struct page)). This avoids the issue of the check
being overly restrictive on architectures like powerpc where
PFN_SECTION_SHIFT alone is very small (e.g., 6).

Also, remove the exhaustive per-architecture bit-width list from the
comment; such details risk falling out of date over time and may
inadvertently be left un-updated, while the existing BUILD_BUG_ON
provides sufficient compile-time verification of the constraint.

No runtime impact so far: SECTION_MAP_LAST_BIT happens to fit within
the smaller limit on all existing architectures.

Fixes: def9b71ee651 ("include/linux/mmzone.h: fix explanation of lower bits in the SPARSEMEM mem_map pointer")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h | 24 +++++++++---------------
 mm/sparse.c            |  3 ++-
 2 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7bd0134c241c..584fa598ad75 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2073,21 +2073,15 @@ static inline struct mem_section *__nr_to_section(unsigned long nr)
 extern size_t mem_section_usage_size(void);
 
 /*
- * We use the lower bits of the mem_map pointer to store
- * a little bit of information.  The pointer is calculated
- * as mem_map - section_nr_to_pfn(pnum).  The result is
- * aligned to the minimum alignment of the two values:
- *   1. All mem_map arrays are page-aligned.
- *   2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT
- *      lowest bits.  PFN_SECTION_SHIFT is arch-specific
- *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
- *      worst combination is powerpc with 256k pages,
- *      which results in PFN_SECTION_SHIFT equal 6.
- * To sum it up, at least 6 bits are available on all architectures.
- * However, we can exceed 6 bits on some other architectures except
- * powerpc (e.g. 15 bits are available on x86_64, 13 bits are available
- * with the worst case of 64K pages on arm64) if we make sure the
- * exceeded bit is not applicable to powerpc.
+ * We use the lower bits of the mem_map pointer to store a little bit of
+ * information. The pointer is calculated as mem_map - section_nr_to_pfn().
+ * The result is aligned to the minimum alignment of the two values:
+ *
+ * 1. All mem_map arrays are page-aligned.
+ * 2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT lowest bits. Because
+ *    it is subtracted from a struct page pointer, the offset is scaled by
+ *    sizeof(struct page). This provides an alignment of PFN_SECTION_SHIFT +
+ *    __ffs(sizeof(struct page)).
  */
 enum {
 	SECTION_MARKED_PRESENT_BIT,
diff --git a/mm/sparse.c b/mm/sparse.c
index dfabe554adf8..c2eb36bfb86d 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -269,7 +269,8 @@ static unsigned long sparse_encode_mem_map(struct page *mem_map, unsigned long p
 {
 	unsigned long coded_mem_map =
 		(unsigned long)(mem_map - (section_nr_to_pfn(pnum)));
-	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
+	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > min(PFN_SECTION_SHIFT + __ffs(sizeof(struct page)),
+						PAGE_SHIFT));
 	BUG_ON(coded_mem_map & ~SECTION_MAP_MASK);
 	return coded_mem_map;
 }
-- 
2.20.1


