Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 132B8C55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121636B0096; Mon,  3 Aug 2026 23:55:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2006B0095; Mon,  3 Aug 2026 23:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02F86B0096; Mon,  3 Aug 2026 23:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BBEBF6B0093
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:55:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3AD79120836
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:55:52 +0000 (UTC)
X-FDA: 85062223344.26.2783C78
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 67A2740003
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:55:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ErnvIkW4;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815750;
	b=O0fS//K9qmJQHdzqiivnRCtR2lnStT0lA3aCzjsIjZtjwi/8hYR/M4RmO1/eDMOkTEy2XL
	Kl/qMC9xy41M0iC1rNfDsPk8vTdqiKMevZV2z3Hvfwv06v9wWcRiN3IHunJ013orP8ZbdB
	7NiUpg+RaTg6TlVV0Q6h82/qZ4/EGJI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ErnvIkW4;
	spf=pass (imf04.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yICpqG88O94O0jXrkeJyzojk9mtxZcw6jMcQUVcEauY=;
	b=XjwptZYJQYpv3g0nJiqgsYhTYD1cWfU5J444kp3p1q/eB++6zRp31UQ+HAbeED0/C/y3H3
	/3AGcsftA0biuKEYDjOCFSqBf/B7fhsWfrkvgmy6zPTqb+Dr9bUElEULtbhI7TAg4ehLwE
	Tu09K1HHDs5HxJyzaBj/4zhmhJH6Kn0=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2caced6038eso6997195ad.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815748; x=1786420548; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yICpqG88O94O0jXrkeJyzojk9mtxZcw6jMcQUVcEauY=;
        b=ErnvIkW48EQr/wkBnzh4JSDgWcypyVD2RXrzlzN0tO2iiIdVbDetxMzGQuVkSainQF
         q4AYI98q9pw3dl4DP1tydZt2UpHY6T9kbmIUtf60koiinOxXYnfsJJ/GilWOL6kN2uyd
         1qu9Oig3vxyFipCrRQiReZeJBNBzUHEABwVJumwnMjl3b6BP0wp9pMwbcJpqYEgr8e1Q
         RYfvg6T3Yf1vOJ0hXECleCt44dEs5w803JGLj2A8aEwQaCB4Qt8/pdHvbTS0A4D4CyFZ
         LLnPFDcp+7EBNvcP6hw/0JmHC1WrZvby2Qnhy5B5wQSXz5tKeirMz1865iv6EOUEuoYV
         KCcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815748; x=1786420548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yICpqG88O94O0jXrkeJyzojk9mtxZcw6jMcQUVcEauY=;
        b=LcqTbRshEmKwnq1ATXxvfzfPaNoCxn4Wp+IuYZn9XUP1J77E13NFez+p8RqIXPcEol
         z8mWHoqTiJHZ/h24rjw9psvn+nAT74R8GR7NRdM68uzHMChz9+9kfH9p+MIBR1qatGxj
         D9EW0MnwKQRjYbmdcv0EnCHeBTDiKBuaqp6XcHkQTuKoDK2VDAQYkX/dRgc8BhJocONU
         H4TcYvbh95cE13u1uocwtHJgtmWYF9Uco24vTkb5qnu3kg3DyZXtQ8oNXMO+sK4wM5G+
         0S0xL2KNo25e/cepNeE2+5rtN/vxCwcYlnU87yhQ5yxmu48YlI5cJ3uLlRgI8E5FOqVH
         SejQ==
X-Forwarded-Encrypted: i=1; AHgh+RrzMJYMDPShB8S8Asp0fL25mTsBsctRrCaRvNheU/VTcONySNWfhNa4u6hd9hyHJRLE6UQ24I4lpw==@kvack.org
X-Gm-Message-State: AOJu0YyFe71F1pzUauKRjkwLhFS65saqkg0TxeAQ5JZPHQ7biLZTbQ64
	nYSJon/X7wJnCRvPFVn2zW5tMo/9K98WBzhA9MA5o1MqbFY/MOEY8TIbmVxRPn0bmhZz3HeCW99
	JHoCTGZPL4w==
X-Gm-Gg: AR+sD11UH7RRlUO9ahW14fd6OjuCLdzaXEWBosBd1EYYohGLKTsVjnbm2CduB33/7KM
	OcNAuYNU+Bi/coQEitKHHlmyE/iuzTjVnL8uOaHkAJs0mh0Oi4XvRhc+hu/VsBpWhxQaq/qmKyz
	8W2itPYkWOA0bkeuKymXPXfsK/t/+7W+Auwy6xRPZ9FvU3gKyrGtm3vXiYCqV+TqEjEfehexGKc
	F+H1LJegcfKJo2wFqyxKL8UNr2pfZKGWmWoHuy88SiIHuVSIA+lafIDHm9kmwCyVSjZy9bHwtct
	uKVptHIOvRuMpvIP8e/eC9xFTWKsIxwnOyoy3jstR4VW6Y7j2+4Xbk6CGN7RFntd9ZMDfa1m6wn
	cLynFwIBjNmOzBkgC3kgJCx0MbiirNLEUFHFAU21hG7oCIm17/criO9iXEttJo+PlvO5gdNFyjq
	cxlefyGgWWf6x9QGrUxH/kGxuazI3uLkxRSxQbNxaDf02vS6dph/3ww+7CbIWdEGwvil1Shdh5Z
	MnlCJXZ
X-Received: by 2002:a17:902:ec87:b0:2cf:bbdb:425d with SMTP id d9443c01a7336-2d08ab5dee1mr17986345ad.18.1785815748049;
        Mon, 03 Aug 2026 20:55:48 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:55:47 -0700 (PDT)
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
Subject: [PATCH v3 01/17] mm/sparse: relax struct mem_section size constraints
Date: Tue,  4 Aug 2026 11:55:19 +0800
Message-ID: <20260804035535.2846016-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 67A2740003
X-Stat-Signature: rgx5aebz1oq7yxi4zhm8w8mhoojf64w1
X-Rspam-User: 
X-HE-Tag: 1785815749-97875
X-HE-Meta: U2FsdGVkX1+qiMuR9qeD+FyAWkJ8f9/iK4e1mNC/DB2ihz3EGMlf07l5GDV65qBcofCRRE3sxt7q3I07jwn/2mLdIPzjvptNJUjEmva1QsXBl3T3Y9CIKoAARSQlwDrZ23dSaI8qGd7dya8GKvewohG65fL1Gbn1qn40CFq8jbaFEv6/PGc3lkH4jz8FdpDv+7cH35giQmWSLhbjXOoC8wr9RDeMNA369ydF2NVEhDqYu4MIYyDn8Xplfe4OS20weNF6Q9qqJ7NgdxBYeju3tcOuOFasEs6od1R0ZZjoUGZNfuSJoPBIP8DLOKjyvLl94R7uqBANHJOaij1+mR9G0UtVCiJU75XfmZy44i4G6gEljAQIok3R5QCZYjG8yQOhhohwkKko3dTjFw92s/eP2En3x2MMrtRdNdSQGftw0dJUu2FZKHZ5IVqFDhBOeXNVRutxrtqXF3+JYG4/pvBWwGcHNZYo6DQXpP3LU1nO/3afTprcDieOnva2bkGFxEKN8MEhASi5CuJroJ+0tCXxr3i2diu4gZieZSVDTDnj89KFWDuUbyVQkZxZ4h8Go2dXwXg09w4qMFLCst6AVnxOV1zdHKUx18FcXBhTHR0euEu4eAGSp69C09YdLg9ehsIch96meXIMoG1GBNBtB/xN8mLhGlUXhWQiSAJQKzwiHLDchJqXXoMUpWKXNR8h7RPt3qP+npKIFNh/hgnh5C4e4SgE7rxjcXZzISNfb7+G31C1u9gSLNC4hYsunU7d6HD43ql02/o/W+GxA5D3QKz0Wvp7XrVATkD+juMn1dUKQZ3SZBXAU6htyyGmgqFsmWR7bqjxhs40esNPDt3rcSceNcdKpQDlOuPeHUXMFeh5BE4iQtVgitXkbGgr/fsgGHoQxkWDZnPoMfqb1LpWum8Fjpxno/47u5E9iF8+RYGHQZMcjzgcW3TxTr8DABWr+6/Hx2DZXEzr1TZjqkHSxdL
 sj6OxGWa
 BqaZ6EM7f4jfujkvMDEE9qn7HfTlucJ32g5h8AjsKm///WO5YTkQ1Dzqy3haYPmALpfZZOVVRCVsG2wYiLsuq2TMp9m6n4uDFAS2q3wXmXQgXwylEdUYYTW4wliHj/a9NGWgFES4gRQpURu9XAn/Hm44pdFsXgUqrIWXdDeW5WoCv/5kTioLS2KhXKNab/DtoK3PHCoz7Z6qIBdtvYY8cttjYY9a8+YN+dMJMS7d8l1kN5Aj7M8or7K/RSoN8PLlPsyEos/Sg6UBToIjW4UZNnLfrZ2AeVexGlu5fYNR4QPaK2F56JM+NHdtZLpckqzO66Gh0De7c2R+hUWqE+vULHDjqY+l3002ok8YpFBI0iceNpZ2TPbbw2qeagfhOkAE28M9VyWx8TKRXtq1mdeEuLVgjyg1+oec4BE891nydADdX7BxviWyiCJZciBMl2r2D7VQb2FhkQgx+ccWSjhPl6cix6sI1VgbXwTz6
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
index a26c8b855222..acf02c87900b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2028,13 +2028,9 @@ struct mem_section {
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
@@ -2044,7 +2040,6 @@ struct mem_section {
 
 #define SECTION_NR_TO_ROOT(sec)	((sec) / SECTIONS_PER_ROOT)
 #define NR_SECTION_ROOTS	DIV_ROUND_UP(NR_MEM_SECTIONS, SECTIONS_PER_ROOT)
-#define SECTION_ROOT_MASK	(SECTIONS_PER_ROOT - 1)
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
 extern struct mem_section **mem_section;
@@ -2068,7 +2063,7 @@ static inline struct mem_section *__nr_to_section(unsigned long nr)
 	if (!mem_section || !mem_section[root])
 		return NULL;
 #endif
-	return &mem_section[root][nr & SECTION_ROOT_MASK];
+	return &mem_section[root][nr % SECTIONS_PER_ROOT];
 }
 extern size_t mem_section_usage_size(void);
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 704a9dec2b9a..ca9875f568d3 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -332,8 +332,6 @@ void __init sparse_init(void)
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


