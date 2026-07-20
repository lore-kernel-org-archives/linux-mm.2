Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E11A3C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3E76B0092; Mon, 20 Jul 2026 05:31:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DABC46B0093; Mon, 20 Jul 2026 05:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7C26B0095; Mon, 20 Jul 2026 05:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98CEA6B0092
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:31:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2EFB31207CA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:31:58 +0000 (UTC)
X-FDA: 85008638316.13.3A733B0
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 075C8140005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:31:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kXtVf18N;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539916;
	b=mRtIRmQxhjohV+l6GCNaOAMhweJkAmr7bsTHlEWLWyZdLm4JN1QmOPFv1smHeXmi/vtum/
	nBx2ng3/rySesVyres041+gcg9BIZYuPVhtrjsJBEQga8YFugQctkV8IensU74OyCVeP+W
	M8ynK5Bn6RiI8TWK/F2j6G/tZ9GNBWQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kXtVf18N;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xuZ6BXpDFSgmVKQGs+ltcwR2zNvZZ9A7kJPisvEZrvg=;
	b=6nt7DNZRkXDPSatip8dI/LgQkwKUlVb/xINPbxi6ZevfaK664eYIf6fIuZ8iMO8v1oY6FM
	SvgNL2nzeyo9ZOPi48MXzwfDrN+ua5tynFr2fUvXo12ATy1ajdZafhzAeebdzhmgLlkx+G
	2PUNuJiBugzYuvNkzSe0Xo0jxbdo9MA=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cacf197759so107866765ad.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539914; x=1785144714; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xuZ6BXpDFSgmVKQGs+ltcwR2zNvZZ9A7kJPisvEZrvg=;
        b=kXtVf18N7KYPMvyX+So8RkE9YWmfNmv1PZLO6kUetua8RyZfVOGprCRgDiTSb6ibbu
         1fmkKy82Lvmu492Dq2uLIKtXov7ExvcfFGQBXuA9WSDfeGy0OIDOBnjvaELGueYgvJtm
         FkYOwh+8OUqHbWmMeIFPUrrFxbNgHXT6GPuJxWLD3m2rE4I+nabVbFgDJGyFdNy6WNPq
         5YXDYmWaNbElD+enPEYTcRZW94sqvJGGfgzjN+KngSlPXYD9dobnd9bzn110g97OMh5z
         Byz6Ihm3fm1iP84tNHIYAuUmWCW5oUtJtSbzuESj1/Lhswk25RbSOAmGFR9O8jA0VM6P
         n/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539914; x=1785144714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xuZ6BXpDFSgmVKQGs+ltcwR2zNvZZ9A7kJPisvEZrvg=;
        b=XzLIdATZdKl1Nj7iRhX9ywL1D8cgF2X9l9TYY9sQbi1PmbK9+7kBar1M4wJykPaPuJ
         7bpV8EsJg8rNwE4kVU0IXf1rGCYklHYVaCwB1udakx0QipF9wqY0jEgXl60B18aSXGQ+
         leYNOWqM6Wqng8OPt2JWkNqL9GYxvJT0i2GEL5jMTKbPl+QMQXcHCR0Z/oFm1ZbtPjqH
         AP/sg4iuOm8M1NBSqShrX9nNwgtYKWSCRBTkzCxz1tqHXmq241uL4W5B00utBQrjrzBN
         oOb2p+6VwIgE6tsY4/ldwvlkJsSvWl30KG3jW363p64OCHMYi49ZPZQhjN9kNgo79I7a
         JFxQ==
X-Forwarded-Encrypted: i=1; AHgh+RoYYhfo124SztNQ6hiK22bmUPYQIvNMXa20155UXWSYHEsWnF/JxZDgzcWDI7VkXFTCuFK/90XPxw==@kvack.org
X-Gm-Message-State: AOJu0YwdK/CYeXL7Z5h08aHIWYIm9CsZMNOcUfAKAci0N26KU4GakE/y
	zZ0e/sozLKYDtLRxRfPud15rcmxJl+cw460aovRSScUgRQhKnZjchYhrrtZ/Wxno+Xg=
X-Gm-Gg: AfdE7cmIyeRP3+iZIKvJj/zjYAmO4iPpKIiG7gWLvguZ30Z4ePoFzWwa5h5cmfagVmW
	2KqaPxlpvOQQSTm2OfVUVSMFw4OUywTg5I0frJKw7Y7a5KhAjPoFeaZmsB+lITK21J0oJmKRuU0
	Ft/xHByxVsCMvKkOSjt3/P3A0/+PqeLBCbS1RlVsOENtHdIGkNWu5LdVEFsbA0BbsO4owzXcplO
	n+SW7O6IYGmJzIE8Ay1k5O2JUDgG5B+UeBbklIkKm4JJC7QX0vHpeU8Q1EXXc00qMYXKVOsCqds
	nB6+8GjouzXUM5l9Zdv01y6MTqBFi6jnAYmkcNnbCxnfDSPlZuO/JK5h3Et0XV2z3dHM5ADFof3
	ExN8e7cu/8e5dkMfS2MUj7PXoi3twJRYSeW8U78ghhNjd7vwntWnhuDULg8yCFNzqtMSUuQRNo3
	Sio/JbqXSxLlGcpmxqgxIgSv4=
X-Received: by 2002:a17:903:4405:b0:2ca:ca48:c380 with SMTP id d9443c01a7336-2cf34a07a97mr145241885ad.47.1784539913858;
        Mon, 20 Jul 2026 02:31:53 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:31:53 -0700 (PDT)
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
Subject: [PATCH v2 01/17] mm/sparse: relax struct mem_section size constraints
Date: Mon, 20 Jul 2026 17:31:11 +0800
Message-ID: <20260720093127.540540-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 075C8140005
X-Rspam-User: 
X-Stat-Signature: jbb8zxenin7u9duefmdcj6ijqut7t84y
X-Rspamd-Server: rspam03
X-HE-Tag: 1784539914-398237
X-HE-Meta: U2FsdGVkX18RG8XBYyQUTJiAKApkAeQWGYLHtM0fRefqvdEVSAZKjdwyGpM2wt5rBY0GRhHMdFZ6FbiMbr2JxAPyxbTt8PZUujJVfl1r+JJ1hg6Y857vFQytL0waJeEwso1DQZTN2sGVkyg3DwrtKLdCoBifFljF4gSn3Trks8OqBIUZqv1iPZOk8lc9tmreTACEH8KdrDECQmqrpLu6094UgXSIdSmMzd9Nd3AklDIX0xhB6FMWLI6ujc4q4ivN7HxMR1ScDJNT3dxYCyYGlfHYWRPJeCfkxw8jk0kwifj+LcW+QUShfJ9B41Ac62ZKPb31Tw1jKiasr0m5xeiPkf4WoU2bsGeDzhyI4iNuRhD63eyQgFu5dCfh8dCAdjlnR005Q+tw8TqOTS9ysUBk8u3DXuzm7SmDgHxB7rrcFTP843+MfSG2eVnlE7HAHvqBGBu4BQ1IN5p1tBizyaVE+QBtKWTqQLXHKQDGGjuG236AnygWpfj3Xh3oPtMHYalKAPFNMlOPasaFQiBqunq6IPJH5x/daB5LzAXHse44cZk+e6UKvL4UWLKIjig6fr8KfgeJ42dsSO3XWDF00xyGFWDB8ga+PaWY8O9h/8TCmsVlhxhANMb4Pxxh1QUnwdO1Ca20dMOOW6F7urm4DXrUMy0tw4usJUBV68A0+BsMNizK8l7bVuut/cmyX8yRrRpgGVr3rOH9zZ5vqHNDP6bFYTFeWw2qC/D6Ensuaj/ueIUPFPmgOkg1Qqynln1l6mjjHMBny1NiHG6mqChc2Pmqhiw/IHhpIE+mKY6lNDzaK2paETDPV9bh3rmq4qe20BxW+lOj/qOSh+OqFjmDvqv6zz2H4T5kMO+9qlBOARIRffS+9jYZLZ9NblhADLOaLclQwsVB8yFi+ZYOeZwdEValdwN2fi4o764vp+I/d+ldaMgr4cIKDiyEXLPcj1NQpEzPLdcxy6AuDU3gQC0h0qx
 5dwLz+hk
 dQQ2WYhM/Nz9qRet5R/PElU/xWKb2jM/V7Ly45LEWYbXBiAiPU6ICrVk0G/B4kiuDDDcVG3bETAtsroW37Kg58hPY1/DtSaWGFy5sffvMoZ01obS27mkCjnOma8Eq3EN/lCjrfD/rlbcVusXgduo6g3ywvZbugUK3InMYAdJ8BAbQRH4u133JqTGpLHbZyPttpGHr8G1YH/ER9yWRAT9J9y8cqDgy/S893CBzcm5rZS4gpkxWMmbafk+huGPizsBCnVw4XqqyTkEuiXoEuihgb3kUvkROqtsCMVCwbBRt2rpmsnEktGVMaJn26P+gSCaq+nwGiTvTWEdhOyiYvkXF5UoVtt2Kyc2J3ZX+tmbQAGccxYbLzCLA6J8B8iNCQC3mBpsBBIISrGJNMG0bWt6THh3qgwrBE/Wd+MafGi8/Vt5qjORUESVjjRVWUdW+LsTZnzMp+dfgsPALaIk=
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
---
v2:
- Align struct mem_section to power-of-2 where possible, but support
  non-power-of-2 lookup (suggested by David Laight)
---
 include/linux/mmzone.h  | 11 +++--------
 mm/sparse.c             |  2 --
 scripts/gdb/linux/mm.py |  6 ++----
 3 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0507193b3ae3..04f3409edacb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2016,13 +2016,9 @@ struct mem_section {
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
@@ -2032,7 +2028,6 @@ struct mem_section {
 
 #define SECTION_NR_TO_ROOT(sec)	((sec) / SECTIONS_PER_ROOT)
 #define NR_SECTION_ROOTS	DIV_ROUND_UP(NR_MEM_SECTIONS, SECTIONS_PER_ROOT)
-#define SECTION_ROOT_MASK	(SECTIONS_PER_ROOT - 1)
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
 extern struct mem_section **mem_section;
@@ -2056,7 +2051,7 @@ static inline struct mem_section *__nr_to_section(unsigned long nr)
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


