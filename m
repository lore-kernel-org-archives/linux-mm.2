Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D1F01125876
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F1596B009E; Wed, 11 Mar 2026 15:52:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772986B009F; Wed, 11 Mar 2026 15:52:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AA2C6B00A0; Wed, 11 Mar 2026 15:52:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 469606B009E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:52:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1DD8A1C437
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:12 +0000 (UTC)
X-FDA: 84534828504.16.C655BD5
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5093D180009
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HGuLu0yv;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773258730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WGJ9MJa4Q34Av92QC7yL+Kbu9MyB37hTyusSYsRh4jE=;
	b=Rn/Oy1PFwpEOIrGjXit2HcIRFblLS+ovyuQLs5ffvYhVrLelawW7VF6dwkL/fd3Elql1cM
	c+AVJjMICffswnRXxyuX4VbYk20nsqfXmEaExtzqsR2uCBXFHQzsQxccsd3Bfk4+9Zvxex
	DgJLTuDudgUTC42huTDSWkuyeZmp0i4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HGuLu0yv;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773258730; a=rsa-sha256;
	cv=none;
	b=0vvwJZdhcAaoi+2GLnWn9Lj8hlTUXaERxpzyCmX9vO3F/xSaWJfi/btkW/enJFe8/nWqmp
	KRQVmETfTa16npnalWC+utovZRwM2+Yy2Ho/9G71UJXNL2OixSfElgpvbg6YXW22sbpbSx
	6xeuBvnrA7y81y7Vn0bkXExvt7i7T0A=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d7412cfb9eso298250a34.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773258729; x=1773863529; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WGJ9MJa4Q34Av92QC7yL+Kbu9MyB37hTyusSYsRh4jE=;
        b=HGuLu0yvYyDdBmARuK/H5ESmFbUlbxAQO47BsxP70O9wiK8nKTEHkPJR3f9ODkgGvV
         8K8Z2Frlau0lqoC/E+YW7/03i+T4ogae8Dzb8HpMucLE5ZSDUb4pK7WbjGTPKI0reKyp
         aYXG7BI5Bf0uhLYqSWu9DETLi5lWZpkIAjeHEI4jNNrMdvpD2YCyYsxlh2ttUOU+Anp6
         MzT5fsRVd78GRVuYiKra9nHdpCcwBiQB5cW6ZNABv7yJ5hbzeuOSK9J4NXtkGpnojAnH
         WtiGHiB/scEN5hWa/ZI8tELL7/m7KhasQFu4DhUogxLMxLYOvzzGR323PAVsEh30St8n
         slkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773258729; x=1773863529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WGJ9MJa4Q34Av92QC7yL+Kbu9MyB37hTyusSYsRh4jE=;
        b=nKRot13XnCeiC9Hs7KoAVXqy9U3OWzDnYgbC7r3mkcJVcf0qhLFd3dJ8woDyEqM7ei
         G5WQrrpfHmfpz4ufT5AUp3xAWSapjJKCp7oRf5nh0en1LKbWGgzaq/GMN3e96tA7ZjlX
         oIwcZqRGBTMdYxyeiukKIYAhPyJAdtlNpc/uaUYj7gdR8XqmJiPvGtT8ZvlJsdc2Yb0Q
         eZpZ1hj+P9KsZnlex05OXEr5E1HBmkIlLOKWT4utNymAttcG3v9P1V8PPXS9qbLm7ARc
         03UMyOTWtib/n1b2I8HznhmqWwes5CxOTpWYs+3KD8d+JFqqglVabmuJ0sb4nhHcuWUc
         3U6g==
X-Forwarded-Encrypted: i=1; AJvYcCUGup48tZFZZlq0pHcu8rbnQNEVDjtg3YFST72Ju7rn0UGSDmY6/pbtuxAMb8o0xdAZPazPpgKICQ==@kvack.org
X-Gm-Message-State: AOJu0YyKNsQpd9QpCfi5bOPJA0qRv1udutAOyCiXO0CDd8Q/DfXLL1st
	iN3FGeH1D1CMeaohOO3CzZoKkl9luqLC7IGrXR7OaGoUddQIw1DL+Nnj
X-Gm-Gg: ATEYQzxrF54tcv6geACoLq8A28eaY9FY9EjCiQhF6j9Wfz60lP62si/rXeUSvuVuHkH
	Eu5m9/wHS0qmxq/8/TMBd0CwuGUhGKRTIDJHWj+hfsr7Nxr/xINO74GVpj6iJpvRmwdOSZZWDs6
	+r5+RSe6HcOFU1em6RjDAicSY8POJEENQAWYHe1Dp+nDS7gc1fjUmLMzv4z1pRkJ2APEHcxswEO
	z/mDRoasrXo1GebJv87oSPCZRSLEAUOz4sqmnukUOnPXerkoP+3sYrTgRoyGHNGAhrSqwVsxXeu
	sNz3y6cnmW862CqPlyGRWR4ausyDkrgEOEr/5z01VmkoJMKgbwb+9SL7hJ2xXUluFMrK+UA3vXp
	RgoDDMujUrBPX2fXUYP+OMki49v/87+ATrUcTn3q8An8Q56y9Sf/pAIojhmTjsyrCTGEA8SvvtJ
	wxWYQ9wheqismB8y8zz7Y+fcxSA2F17S02
X-Received: by 2002:a05:6830:7004:b0:7c7:61e0:a4ee with SMTP id 46e09a7af769-7d76a73b581mr2550615a34.11.1773258729419;
        Wed, 11 Mar 2026 12:52:09 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76ae39b39sm2746167a34.15.2026.03.11.12.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 12:52:08 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 11/11] mm/zsmalloc: Handle charge migration in zpdesc substitution
Date: Wed, 11 Mar 2026 12:51:48 -0700
Message-ID: <20260311195153.4013476-12-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5093D180009
X-Rspamd-Server: rspam08
X-Stat-Signature: e7xcrynyiignjtg3a93j3c3gszzb1bnc
X-HE-Tag: 1773258730-37364
X-HE-Meta: U2FsdGVkX19YFhHNikM10s1arxZ54ZRnfoL1shE3lbfA4bywvtRq8WDb3mLV8fhJ6zdju3RltyRwFMYq7JAoM/A7SRBzVOwUEaCrEB+j5Kfri1kKCzabj6nc23WudsXfIqWKLY0sUKnZS8NxnFZakUqEAbD0nsS/2OImLXSacSpQgYuaxiGGbmYN0oiQ+PBoHqpmH3480v5E+zyHXjcD0Ee6UzWTa1vgNrM+BBz2b2ukNn8aOsH1sYcn90no1Kybldzpm+GInwBmuhV5t5hKmYlT/wQO5bfEhJo1WQT4QRC5pVVF/kvW1FWtAcPjj8O6p7M0fczHk/eDjgYQ4BMsJEUWaIZoe4HEJyn9Zr5PvaKjlp6F/cs+WlM8q5zkjERjUQ2y0pWGYHQiNcHSWNqNuSIiN/DXKjO4J+5rpr1LlKf7MLO4M+P8BOfqBvocmlEvu2E1+JR0llRBEFmUnCEpCdNWvKHwSGe1+gbmDj9EUwTAcoub87Rtx1AOMjFQkp+djfpwc51HqKiVMS5QIBs0gXhMHuaP7T6qSRCaoLHpKcAOozoucD3dYakqgFdwZFVWqUJ4/8K2ETBNsc8jvatpa6x2xpFeI2wA4vRWFXk4Jam86Owdix7QmOOeAHqA/t/8q4EDxEvJKhC/dTOFR2AGI9jA5khLF0AFyDCEKlfc6ny1m449V5ISQeFxdec2BmT3ohEkpKU63cN314gexeIeFH7jNHm+ICPq7vOvBCpxVejeYPkNyH5JMsIjI33l/9GWuid5t4r9o8hmo6DjMRZRrz0fYZg3sCkbojfqWenrx/vBGjiUS6qFss4ud1O97BErihPq7jdf14rcdSMmDWb9LiBItQ0eN/N+f5YdK03ZZ++0kQcReAOpEvRJo45PIWMEXAbBGwFZuIA7g9fsZHk1VTPbERBElVRAJnKlHAMTM8uutjut+3SyX2LGvW8BtGDzoRT5I4VLC5CcpCfyxQV
 5PAHoMV5
 A/a2655i5CbvbThfwSSZvfs+1EucSmNtXwqLJ3kEbMqIOB29L9ggYPCu1BboJxFz5yTETcBwxphvRnAP9jgV92Vv8IZjWFOcByL99ZCDLuA6vWUu3Y/a6H6g43mg86r9eLaC4Dv0+udJi5Y86WZ8jlK1i0QMp7qUDqXIZ+l8rAUP5mG+UukntoG7BPpuVJLHj1/JLWN9l0obBBcEerBuYgvcmRSnf0xWTqU2hK/8X1BGFfzFo3B/OW+PWHHmshJSTC9uTsvsModJBFe3IrfXtlZdhwqpuf+ZPONmBjynLkQEtei3530fp5C/8BDzbeVgukZMlEnAeePZUeM6Du+t4yauypDqGkrfgIyiDq0GwAZpAv1xUlw3siwCyEI9mcoaX/QmNi4WexcOS33ITYRzDSdLVmZYUDXWmMgV56FE2hrlvI9tg1eOytBNdM2EdhNg5hTnmIRbG2ZyM0tg/vM6skzWmqCyoo0qCI9GzfInYBA2nMK1cFduqDZ7HUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In zsmalloc, there are two types of migrations: Migrations of single
compressed objects from one zspage to another, and substitutions of
zpdescs from zspages.

In both of these migrations, memcg association for the compressed
objects do not change. However, the physical location of the compressed
objects may change, which alters their lruvec association.

In this patch, handle the substitution of zpdescs from zspages, which
may change the node of all objects present (wholly or partially).

Take special care to address the partial compressed object at the
beginning of the swapped out zpdesc. "Ownership" of spanning objects
are associated to the zpdesc it begins on. Thus, when handling the
first compressed object, we must iterate through the (up to 4)
zpdescs present in the zspage to find the previous zpdesc, then
retrieve the object's zspage-wide index.

For the same reason, pool->uncompressed_stat, which can only be
accounted at PAGE_SIZE granularity for the node statistics, are
accounted for objects beginning in the zpdesc.

Likewise for the spanning object at the end of the replaced zpdesc,
account only the amount that lives on the zpdesc.

Note that these operations cannot call the existing
zs_{charge, uncharge}_objcg functions we introduced, since we are
holding the class spin lock and obj_cgroup_charge can sleep.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/zsmalloc.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index f3508ff8b3ab..a4c90447d28e 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1932,6 +1932,94 @@ static bool zs_page_isolate(struct page *page, isolate_mode_t mode)
 	return page_zpdesc(page)->zspage;
 }
 
+#ifdef CONFIG_MEMCG
+static void zs_migrate_lruvec(struct zs_pool *pool, struct obj_cgroup *objcg,
+			      int old_nid, int new_nid, int charge,
+			      int obj_size)
+{
+	struct mem_cgroup *memcg;
+	struct lruvec *old_lruvec, *new_lruvec;
+	int partial;
+
+	if (old_nid == new_nid || !objcg)
+		return;
+
+	/* Proportional (partial) uncompressed share for this portion */
+	partial = (PAGE_SIZE * charge) / obj_size;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	old_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(old_nid));
+	new_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(new_nid));
+
+	mod_memcg_lruvec_state(old_lruvec, pool->compressed_stat, -charge);
+	mod_memcg_lruvec_state(new_lruvec, pool->compressed_stat, charge);
+
+	mod_memcg_lruvec_state(old_lruvec, pool->uncompressed_stat, -partial);
+	mod_memcg_lruvec_state(new_lruvec, pool->uncompressed_stat, partial);
+	rcu_read_unlock();
+}
+
+/*
+ * Transfer per-lruvec and node-level stats when a zspage replaces a zpdesc
+ * with one from a different NUMA node. Must be called while old_zpdesc is
+ * still linked to the zspage. memcg-level charges are unchanged.
+ */
+static void zs_page_migrate_lruvec(struct zs_pool *pool, struct zspage *zspage,
+				   struct zpdesc *old_zpdesc,
+				   struct zpdesc *new_zpdesc,
+				   struct size_class *class)
+{
+	int size = class->size;
+	int old_nid = page_to_nid(zpdesc_page(old_zpdesc));
+	int new_nid = page_to_nid(zpdesc_page(new_zpdesc));
+	unsigned int off, first_obj_offset, page_offset = 0;
+	unsigned int idx;
+	struct zpdesc *cursor = zspage->first_zpdesc;
+
+	if (old_nid == new_nid)
+		return;
+
+	while (cursor != old_zpdesc) {
+		cursor = get_next_zpdesc(cursor);
+		page_offset += PAGE_SIZE;
+	}
+
+	first_obj_offset = get_first_obj_offset(old_zpdesc);
+	idx = (page_offset + first_obj_offset) / size;
+
+	/* Boundary object spaning from the previous zpdesc*/
+	if (idx > 0 && zspage->objcgs[idx - 1])
+		zs_migrate_lruvec(pool, zspage->objcgs[idx - 1],
+				  old_nid, new_nid, first_obj_offset, size);
+
+	for (off = first_obj_offset;
+			off < PAGE_SIZE && idx < class->objs_per_zspage;
+			idx++, off += size) {
+		struct obj_cgroup *objcg = zspage->objcgs[idx];
+		int bytes_on_page = min_t(int, size, PAGE_SIZE - off);
+
+		if (!objcg)
+			continue;
+
+		zs_migrate_lruvec(pool, objcg, old_nid, new_nid,
+				  bytes_on_page, size);
+
+		dec_node_page_state(zpdesc_page(old_zpdesc),
+				    pool->uncompressed_stat);
+		inc_node_page_state(zpdesc_page(new_zpdesc),
+				    pool->uncompressed_stat);
+	}
+}
+#else
+static void zs_page_migrate_lruvec(struct zs_pool *pool, struct zspage *zspage,
+				   struct zpdesc *old_zpdesc,
+				   struct zpdesc *new_zpdesc,
+				   struct size_class *class)
+{
+}
+#endif
+
 static int zs_page_migrate(struct page *newpage, struct page *page,
 		enum migrate_mode mode)
 {
@@ -2004,6 +2092,10 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 	}
 	kunmap_local(s_addr);
 
+	/* Transfer lruvec/node stats while old zpdesc is still linked */
+	if (pool->memcg_aware)
+		zs_page_migrate_lruvec(pool, zspage, zpdesc, newzpdesc, class);
+
 	replace_sub_page(class, zspage, newzpdesc, zpdesc);
 	/*
 	 * Since we complete the data copy and set up new zspage structure,
-- 
2.52.0


