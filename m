Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163B0C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 018386B0095; Tue, 25 Aug 2026 04:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0AD76B009E; Tue, 25 Aug 2026 04:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E208C6B009F; Tue, 25 Aug 2026 04:49:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D65D6B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:49:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A507A3414
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:08 +0000 (UTC)
X-FDA: 85139167176.20.14F8C95
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id B70A31C0002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DkHzGIRc;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w63tlQxIXv6hFZNtC3XunmfoLQDKL59/Pnvl33aJ5Uo=;
	b=2Zj1xSIOxYQ7Y24QpZ5C7Zprup3E9YjP4mVIoTTB3V7X9mqAP0OUe7kXHCRENAejC4f9le
	ExWnF3Q9sjRCm4JBTv9oKExqe0DWu50y2zpceV8T3HYMyUFDqdQvtEPvVcrGb5BNedej93
	unKiU61p4Nvrsg5VBIsvV2xx1jNcLLY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DkHzGIRc;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647746;
	b=XdnB4TsdcxHm52Sg/aYR7HaX4k7Sl5T9o0xSYkW8sdA7QZQmAr/t2YfufGQpbjF7kv6VMZ
	L/NWn9NqIihdU/k6HA6R+TK1kXZbG9tSG/FGzVNA7CDxpEDCS1TR0UliUW8LDU9UdMMagN
	pRY/ZsLEXCYlYGyL463EPPBuL0cx+bM=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3964dfb5b9aso605555a91.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647744; x=1788252544; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w63tlQxIXv6hFZNtC3XunmfoLQDKL59/Pnvl33aJ5Uo=;
        b=DkHzGIRcIDrMrxySL6P7TNeLrSVoweFqAqYx+cVDmnMgMyoGoBZxQ6TfZSYLA711PN
         LOS1Z4kSXAdgVPEa3FX8Sy+ssy38wJe1kRQCj+od+bOZjX7Zxd59AoGjJTeoRVZo15FH
         5WTjMLg7F59dTJ3hs7LPoh26potEPJlAfItZNGzYADwFVb2pKPEQvnIaqKiGnaEqdV2T
         zumaF43y8lMMFo24DtN2ElXmn7oYqHAET0PSyxKWYMVZbeAyYCe9wGJCOG+NGFR2u5vY
         4xDhdu1X4TDKkf3APLUADgDgmYJgL1kXLAgLcPlpTnK5+FwDhMm3jy0rdip7WXU0bjjs
         12Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647744; x=1788252544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w63tlQxIXv6hFZNtC3XunmfoLQDKL59/Pnvl33aJ5Uo=;
        b=K1g+UB0BAqNPD1hgADEBbrpcBwfNgpI/7XYUn0X4qCOz7SHeM7oTH5shVgYCHM7AZn
         Md2XEGwRO72iTBmkKzhUNB6EiYq6FzVmgxUd3Alk41bh1ErPkHXcTROWRzzCQtkeaPEL
         khCrYOqsPl/M0Iboeq/YQVbPNgjz8lTG+KK/L5BBQHEnUouDSuqL2VgIaKQYgICoqriL
         HSMcYH5YGqLQSRxihzhCtsRHPjJBUtSad8LKE7aQrB5ELmHyTuqs9S1L7C1pXLgoVd56
         /5ByljBAXBNGwkHMKthgBQEtbScwUV7Tg2YAqfvPQ0xxfin+oclJAWzuIyZT5CD8QaAZ
         SnQQ==
X-Forwarded-Encrypted: i=1; AHgh+RoMdKfRvH8+UNt+zYXc/OO9QPH1T20Uet9T7YREa3yhKXyChM75r6/8mh7EZjLa6gu4EENbSfu9Zg==@kvack.org
X-Gm-Message-State: AFuF++lKnfGFmcGgI6AfV4N+q83y22KquL3KnhoXoETW3FOz19sZJSQX
	wSEVDqxaoE1u+4gC9Hoyph7WiF5ti+EIfn3I+hT2Gjd5+3MtniJGa2v8fOweqvVM4c4=
X-Gm-Gg: AR+sD12mt+vRZuv92Xp5IzuYryoTafnoNbS4fSe2sQLrz3nziBHSiEmeO9FhUajXhVC
	cDmZwVKMaMx5wzEkGURBYZQe3u2Yw3b39Oy8LoG4eNs81vDGdhJ7tKH+coNxFz86VNTYjQFUP+7
	xMImMDHcHwMKT7x5OlFgseNJeij3qrjGtHiLXntq+z1XvHyFQLv2j31Dlk4JsEhyh/qNVjajjsu
	FboPadC40hYHgafFs96H9Pp6aEtr61lkP3dleXhOVj+gG+XX1e0WjYtTCwyM0OBNn5ZTjpCv1Bc
	mKQTn0jDryGK2n3S+ZHj1/Ai/ommnYGJV6rwlTcxyLspidXdRbyPYHlbxK9GzAVxY6qoyAI4W0d
	/7WQgOa7HAFWHy2sbkGW13k7ngi9CuECv/+EGiA8iOt2J582cprJ0Oyv4ZvsVKZmeIrK94TDDVX
	U0VljcCiQYxwnjMrqacZFv4OxmucFwe8OO/vpa6Of4OvaCnrVMSZOT6GI8c60+Mtmuw20exGCid
	Iugt2nC+oSc0K+VUyq1Lu4c06A5WVU=
X-Received: by 2002:a17:90b:560d:b0:38e:9045:bac0 with SMTP id 98e67ed59e1d1-395deea6acbmr49754716a91.5.1787647744397;
        Tue, 25 Aug 2026 01:49:04 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:49:04 -0700 (PDT)
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
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v5 01/17] mm/sparse: relax struct mem_section size constraints
Date: Tue, 25 Aug 2026 16:45:52 +0800
Message-ID: <20260825084608.47437-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B70A31C0002
X-Stat-Signature: 3ahzu5sh818qn83qtei8p94h68eyjdf8
X-Rspam-User: 
X-HE-Tag: 1787647745-838290
X-HE-Meta: U2FsdGVkX18yYdJB57fuQWlnFqwwr8CuVniGJUgFnmMIqyIQdD66Vj+VVTEfReEY0Vd/3QUlYVzNXpY9UylYWRLGkB5jH45paMpP/BFwW9KeEOSsfgO/iPDVxS+QNQ+zoIhcZvUiE+aEOqoBbmpanx0vg6AmvLm4zZDzOB0eqwyAhI31/D6qNnJEanhnINCfZC08fuc/OSp41eIEoPei6dMh96ds3mMrUsNR3IJDn/mhmcOAhS7Ck0YyFpeI7gyRhPbl/n9hqZqnolqo0Ublmd15YE9x+5LjSuASKHSdc6fGdZ9IuEZk3t4QVlKl5aJFoBMryeEui41GPWtx4kfJSu7UQsyG7J/0kg46zlKWUfD7t1xejNUcybBrODtuinrpsn4aJFLYOIEoYUf1bzYjJ24pGE/dbdwTL4mINwSpgYC4o0nHG1KMA+pCogfbNjQKhDkPBFIHltWWW30CJuWGWAjiE01ElEETMnxf5B3+T3yr378Vqk3cj4dc/LipLyC0WhLCgR+SqrtN8PauwXUcWIX1VzWNOREjEfcgwL1yxiUhEbrMytwjPuQqC54aPx9bmyY466AkEONPcSq1ZQA2+H+cvK+uzkol1rYfpQNaWmm16QKbaEdfd8SUewsdeLkq9FdvJCR7zFk1Th2Jm9BIXaZXMJ5iO29rCLV+TpbdHl+umbzh/+TOi22vbbXVWVM/naZ7ZzGHx8rq3t8KzRskeByWcWyQTU2ClGJWXHq+JxJGb3yIdqYR03fAZyDIneOt4zu5Jse5DLuZp3am/bCwoOFn9i5gx/Bp/3Bux/aQw9z99UX76vnodAtgScNEqquB6J7ze4heox6v/deaR5QL7SLnu5F7TGphQ7IM2tVeBQdfI74nkzj2SGnawLkVNQpR6w4XWy0D+qSwoAKbm13jZIj4+4GwyB/FUaVTB3cTLKULaYkd4ctDJpoxH3mRdZa9VLmGPlzYfPMk/JvMK7T
 nx0Bj1ly
 sc2zU5cD7NEj2v99eSZTCgFJnpmwBbx3womF0kks6YbOGyiHfHSpiKT4NQ0C0t5o7LXE/yU5z0v2W7hT/cSokI6C3iOXkcTeuJ17rCKg3Vo6cGnPWaJIcspS1nHALEuGVPye5jvTnsiq8HfnGx7DY64d9s2p+JDGPbVxbrLpz47MhDU/bfGHkC3uGC1EDZH0fYKyMA2uQJt7dbt4eHB9fmbziGgAJSkAol+2ZlhAJB6S3/gn1SuIBNuEED7BM4H2KveuEvZ7oPMEEyrBeb7+dTBd/Hc1n/7HNFuGlTfvq+DfkhI4qfEOpjzSRKZQi6x+lZf+n1B5qYzSiTEMhJCoeT6/S/XnUdUnprAWR27Tyif0Oefq2hodIIbBxNmLoNpvn/mtunCbAoaC4UZehHVVJvkXiKDW+uuN3YhOMI9I02EIFSfXubOdACfFzHqpVCneEOy5bHdrcVYe6J2mVe6LIXesP8o063bkvKl1c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct mem_section is currently forced to a power-of-2 size so the
section-to-root lookup can use a mask instead of a modulo.

That requirement makes future extensions harder than necessary: adding a
small field can require configuration-dependent padding or layout checks
just to preserve the lookup scheme.  Keep the lookup correct for any
struct mem_section size by using a plain modulo instead.

Do not leave the layout entirely unconstrained, though.  Keep struct
mem_section double-word aligned so modest size changes, such as adding
another word-sized field on 64-bit systems, still keep a compact and
efficient layout.  If future fields grow the structure beyond that sweet
spot, the lookup remains correct; only the exact layout efficiency
changes.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Align struct mem_section to power-of-2 where possible, but support
  non-power-of-2 lookup (suggested by David Laight)
- Collect Acked-by from Mike Rapoport
---
 include/linux/mmzone.h  | 11 +++--------
 mm/sparse.c             |  2 --
 scripts/gdb/linux/mm.py |  6 ++----
 3 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff5416..0a2428714108 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2027,13 +2027,9 @@ struct mem_section {
 	 * section. (see page_ext.h about this.)
 	 */
 	struct page_ext *page_ext;
-	unsigned long pad;
 #endif
-	/*
-	 * WARNING: mem_section must be a power-of-2 in size for the
-	 * calculation and use of SECTION_ROOT_MASK to make sense.
-	 */
-};
+/* Sacrifice minor padding space for efficient lookup. */
+} __aligned(2 * sizeof(unsigned long));
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
 #define SECTIONS_PER_ROOT       (PAGE_SIZE / sizeof (struct mem_section))
@@ -2043,7 +2039,6 @@ struct mem_section {
 
 #define SECTION_NR_TO_ROOT(sec)	((sec) / SECTIONS_PER_ROOT)
 #define NR_SECTION_ROOTS	DIV_ROUND_UP(NR_MEM_SECTIONS, SECTIONS_PER_ROOT)
-#define SECTION_ROOT_MASK	(SECTIONS_PER_ROOT - 1)
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
 extern struct mem_section **mem_section;
@@ -2067,7 +2062,7 @@ static inline struct mem_section *__nr_to_section(unsigned long nr)
 	if (!mem_section || !mem_section[root])
 		return NULL;
 #endif
-	return &mem_section[root][nr & SECTION_ROOT_MASK];
+	return &mem_section[root][nr % SECTIONS_PER_ROOT];
 }
 
 /*
diff --git a/mm/sparse.c b/mm/sparse.c
index 7c15406e77f5..c84b4c7b8c70 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -322,8 +322,6 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	/* see include/linux/mmzone.h 'struct mem_section' definition */
-	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
 	if (compound_info_has_mask()) {
diff --git a/scripts/gdb/linux/mm.py b/scripts/gdb/linux/mm.py
index dffadccbb01d..da4e8e9655a6 100644
--- a/scripts/gdb/linux/mm.py
+++ b/scripts/gdb/linux/mm.py
@@ -70,7 +70,6 @@ class x86_page_ops():
             self.SECTIONS_PER_ROOT = 1
 
         self.NR_SECTION_ROOTS = DIV_ROUND_UP(self.NR_MEM_SECTIONS, self.SECTIONS_PER_ROOT)
-        self.SECTION_ROOT_MASK = self.SECTIONS_PER_ROOT - 1
 
         try:
             self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
@@ -100,7 +99,7 @@ class x86_page_ops():
     def __nr_to_section(self, nr):
         root = self.SECTION_NR_TO_ROOT(nr)
         mem_section = gdb.parse_and_eval("mem_section")
-        return mem_section[root][nr & self.SECTION_ROOT_MASK]
+        return mem_section[root][nr % self.SECTIONS_PER_ROOT]
 
     def pfn_to_section_nr(self, pfn):
         return pfn >> self.PFN_SECTION_SHIFT
@@ -249,7 +248,6 @@ class aarch64_page_ops():
             self.SECTIONS_PER_ROOT = 1
 
         self.NR_SECTION_ROOTS = DIV_ROUND_UP(self.NR_MEM_SECTIONS, self.SECTIONS_PER_ROOT)
-        self.SECTION_ROOT_MASK = self.SECTIONS_PER_ROOT - 1
         self.SUBSECTION_SHIFT = 21
         self.SEBSECTION_SIZE = 1 << self.SUBSECTION_SHIFT
         self.PFN_SUBSECTION_SHIFT = self.SUBSECTION_SHIFT - self.PAGE_SHIFT
@@ -304,7 +302,7 @@ class aarch64_page_ops():
     def __nr_to_section(self, nr):
         root = self.SECTION_NR_TO_ROOT(nr)
         mem_section = gdb.parse_and_eval("mem_section")
-        return mem_section[root][nr & self.SECTION_ROOT_MASK]
+        return mem_section[root][nr % self.SECTIONS_PER_ROOT]
 
     def pfn_to_section_nr(self, pfn):
         return pfn >> self.PFN_SECTION_SHIFT
-- 
2.54.0


