Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB53DC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15EDC6B009E; Wed, 19 Aug 2026 05:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1361C6B009F; Wed, 19 Aug 2026 05:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 072F36B00A0; Wed, 19 Aug 2026 05:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF01C6B009E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C8A01C10D4
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:06 +0000 (UTC)
X-FDA: 85117555572.24.688863D
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 26929A0004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OflA1tLC;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133184;
	b=ej5TEuAk20CXIdVe8LRxiidwCosh4YObUemp3igyuk1LBY+mAO4ne/vUWMf0Tgo9abJyF4
	jiogWlxIL53SIAsqDa1eTBeelBZIhm6zl6tQdRkfVFFK/3fKuFPGkGhv93j1Vjd+EHt+dT
	sv7xaeeSZr7Pa6TQ6AOnCuHxPge/IB4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OflA1tLC;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w63tlQxIXv6hFZNtC3XunmfoLQDKL59/Pnvl33aJ5Uo=;
	b=AOmtI5B7kKIa1tb6ThknSeDszrAC0mB+TLSojXLGiwIsS/kORUCtC2RKgaWr5w7RFIVRC8
	Q4ICX2lC0N3w15esq/ZwddZbi6Tbgz1a/FbOKdjyhVPxVBc50mWap7tEZdvrB6tk74VXT8
	kBUIk2LI8v2DIHABBMGjBMwqUGAQtXI=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ceb096e675so9341385ad.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133183; x=1787737983; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w63tlQxIXv6hFZNtC3XunmfoLQDKL59/Pnvl33aJ5Uo=;
        b=OflA1tLCmelLv7RhTwGoHHEI6PS3vinJQ7O7lDQP59B2N7JS4Rw44tPSxaaUBWYT0Z
         IQZZ3SfZcBEbydtjffJsqlLf7cEfeqaD3NV+IqgyZcapVaA5K4PDlYfcZPIT7iPWu1s1
         5WrBKTnv2OD7ONxfcMvd/aOXm7ir/y8cnvpva41jg2pJe9rRN2Q+nBi7JYJ7YAF5NszX
         AHYnXSyKKZ0gTu67zKRXMGB6rSiMohVPSTgh5B1pmuzSDXYENZ1P35xpxE2dTbA35Sr8
         Oq9wVuoCj02MzwqzG0bLukQ3NljgEP6eCbpYi7tQxzYuyZGaVZUBYkHpuwR6h4dv8o9u
         9CnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133183; x=1787737983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w63tlQxIXv6hFZNtC3XunmfoLQDKL59/Pnvl33aJ5Uo=;
        b=jAjYM9WYfwUDZSXRM1ILYGBM8h3/Fu1/+U7yDvd2uqX2BnLEa+DVGGAjmHW+v2HClh
         Tu/gnmNaWafuoEMQXFjzHYDO3V5XwThcoFkLu9mRtHYL0wi1+4A4aAywNxU1Cqcgqgme
         wsXVYSF7/tkOZ4iU7rk7JFQhHE+NmB2kLVBG0CnjAY8GRmuxnuNqeol21mUEla2SeJTL
         1AeDTn+z8OCHmumxMo5rqsH56b4rdLel5CO5KAN+qLeAmNPe3VMszZDOkFU4HPz8bJUq
         RSa/erpCM95Y1LhYwEQypG1/VJoA4Y45nZZTF5ffJqXLPrXgGkxrdIQyXeVfCeWrNSfx
         wMWA==
X-Forwarded-Encrypted: i=1; AHgh+RoxLyDsbB8p8BOVK3X5FiUVJ0hOGq8EQS3O58ASLCiOSQ7HNIyf1Uj8c93zrgeyiDIO7fKoGCp+FQ==@kvack.org
X-Gm-Message-State: AFuF++mtSDXDVojxGruCPuBefxkzQlrgsBspU6rhhnLi0EcbgdHFy78y
	Pn5OY31Kjz0qPCftlcroH+naTJMEuxZD5L9DT7rMA7vp/dYNF4kezObvamKoCXn5aTo=
X-Gm-Gg: AR+sD13i4rpC2FkDGM+4B8wHMiddeaGa4F4Lpb5oylJA/56HSdgju1D6QnPoKqW3mQN
	mDzjL5Q574Cbpc96S+W9CzD0IU+qAlqYmBKWAhdflafv3auDo87mfp4tdU3QMdqn6rH42A4MgnN
	at+vFsB84K8CuQLeWHqPCqpDpDxdGNJ8qQjkFV40gE/KUBQY3zh7FvSiSpzTaLjNKh6osxuY1J6
	Xy0o0+cAR950ZulOkkB5QFVBvSDB5mfeekqTMyCes0THIopXXje8Qhf10pLDVhRwwiRAhSj0IZ4
	Lnha1L+WFz9UbJYYFz86JYo9W6Pfm7EWmqZxcHgv12a3GRdwU97WcpjuI4WcEfwXHF496VkHAi+
	p3d4V5Ogj3wEXB0cVI3ivFg5+R7aVcoGzjp9Jnyx+D+3AXLI/1kkBtemduwdz/aMIJ4FBvzD6+C
	ha0V33u6I9Pz8xznPpPZ2tgDPXwB0lAqiWNxt7y/mKKSp8yJd6aTGA4CYMhUAcpJKcPBS8HcWT0
	Tj2EjpGBPS0YXUt0aT/AA9AAQ==
X-Received: by 2002:a17:902:ebc7:b0:2ca:e565:7b15 with SMTP id d9443c01a7336-2d5fd73d03dmr58751175ad.10.1787133182575;
        Wed, 19 Aug 2026 02:53:02 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.52.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:02 -0700 (PDT)
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
Subject: [PATCH v4 01/17] mm/sparse: relax struct mem_section size constraints
Date: Wed, 19 Aug 2026 17:51:23 +0800
Message-ID: <20260819095140.17252-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 26929A0004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 6yjwwg9u1i49rsc88ypgxhm6qsriz5hi
X-HE-Tag: 1787133183-551912
X-HE-Meta: U2FsdGVkX1/YhybR0MvwY+lQVhkXsK98syN0f8vzh79KtKR6kFFoDgPOEzb0NAaEs8Wyr8La49h1PIFbGDQZe78om8wlnt+uQDOhCBoNv9fjCFguwhQl4Hv4cmaefdatZdtDWQjfIhtYXNcI4j6Shf4qjQ2naKeijcLgiD7Z4lnLKuIu4ZPrg67R9ZSZBfxqGot9VqLpVY3rWycB8YN8vGesfk9UgvF03hQ8m6QNs7yrO0oe+r8zjzCAjP7+fsL0GgLuB9xEdTbrBCnyjrGpW4Hz90PhdH9gNXQH8ajY4MNVdF3dcUuoj/DkYUy/KN2Kt/yAtknz7HrOLr72cAdQ8aGWi1m/pfsKSED+uX8+ZRJv7DR1Y9cRh90SQF76NsxWjnMwqVQHH+XlMYtTNnxD2WqJC0C1QIr9EE4mMS2jFsVxLtTK7tRpaPjutY52ksqc75Kni3R673NzEzxSkEg0bSvUlxhkqTWxL7WKh5nZu3pgly8i8IRQ05J8BzL109CkT/DyVL/yXEG934OSF2lHqZ+sl4JIXDTc99SQoSHa5YdW8bIbfYKUIn/DZePqYWNmCZzQlUkaz1n0XBd92Xrj46bBv9WCOncztSkHki9HP0JUfx2pwZkpdbrlw6KXXJop6Gk5Q/fEgI5XitJJKzG524Dpp5VNmtjJj1O3rE65Wr549lGnZMj5ronUS3zUMW/JhgxHWhYfq6WLV5T8yQaBj0WjCIfu2b9Y9rrtrjThr1oSfF+eWskkmU0f6Sa0xEFryzuD7hrFPA4WCpw+ZyZ2WmrsqTFRprmCxP4OzYrBpoyN5X7PGlJ//XapT2kLhQC0DQvQXqifyprvsdE97bom/S/beMpjGFP7iMfgcLlVIgy4y3yP4RbQqLf6vxH0Y6dmpAZPKGR4drJslaXlzCUfOeieqctWGsoQuS9Ytb9vN39a9QdyGzcYsLJ5GdgBI8qcofzbzsuo8KQKVZWO9t4
 qo3AIJAj
 O8TTDNPAgf/BXU3gT9bqqtPerbyce/lz7CuLh9l3beRy/0Jl2qS6ixhOj4uIHhm2dhV9YCm07vaDs4UBCnj55Sxtoh6cRGM4HbmrWzChEIVtK1nWABjLVtNrYJHm19bPJqgIIcu72CmkBHxi0fKB2VQ9YqGY3ZX1wiutKA52MJa1b9Jyiaz55m8H8p1I9gPQIH9HaOJfHYkm7ctm8gNE7YY0xRExw7kr10RY8xi4LVomKoerN2CyUmnBBMOhjDsTygs3RJYT66JXIzNlbTYy4Axhe4S68qstJ9evxNjI2afTfHeFmycFs0/KxWRh73tvejbG1hWs0gXTZDyREjeruMc9M8JqMfJI0IUZNeKjY6nkl7I4Db0Y+oYGVoosQnsN/wgjKk0MzBFdeC4PzTUm6RSHwo6qn4onzYBvsyUHmD8M3g4wDYRv9rbLvzewQU972Nd5WU8At+HrKo04BFlm6qHPR6gGyjzBpu0Nu
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


