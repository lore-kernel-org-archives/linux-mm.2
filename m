Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDA8D1125875
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BEAB6B009D; Wed, 11 Mar 2026 15:52:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E7A76B009E; Wed, 11 Mar 2026 15:52:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6276B009F; Wed, 11 Mar 2026 15:52:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 398FA6B009D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:52:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1EA6B8EBE
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:10 +0000 (UTC)
X-FDA: 84534828420.01.0BF9337
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 27AAB1C000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:52:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NocezPh6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773258729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lInkB9M3FDEV05WLG9mmxw0Eg6pj3q7yDvK5tck5dXo=;
	b=CjfKR5lQdQvBptCoHpQCuc75a9Yeku0XJ8DfjvytarSKtmZdUh1ACqdQxfQs1oA/xU+9qg
	9WWtfgnaHyrZeVTL6bHhrXllnkTpP7B8Bs+NDfLD/mi34dAsCXOZ8HRFb2S98CHGWSm66q
	ousCRfrc4VvvnRmgNnLYTcHVSn9pJQ4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NocezPh6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773258729; a=rsa-sha256;
	cv=none;
	b=CD0VxYIzf+X7vFL7zgWRWBz2nIxyGoVFx+GKSp6HnxieC7s+RDbxFL09tyEJMoH8ug3vbo
	5yvD/EsD3CRq5TlEAFjtfnOaMWrRAK2WNUrbnQ/Ao0JcWJOjnS1hjTGVSnQEHtAO3fENHg
	4LDSgReIEAAEQdX9exypinqXzFkxtLc=
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4672076355aso206398b6e.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773258728; x=1773863528; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lInkB9M3FDEV05WLG9mmxw0Eg6pj3q7yDvK5tck5dXo=;
        b=NocezPh69QARd6jivKyg6b5BzYn32ElZYQ3RqqCb1C+clR3y/WC98xmyo8qpMu1lm/
         BYoS0HvaMwolSNRKQ0GJ2EtA3VfLAt9oEeBLamTPRpmJmQEoam3O849RB1G2yGSYWhCZ
         y6H7KQrWb3rHWV6x9+UQOb9qKGJemVPzaQ0cTAQqPsT0wvOawgW9h/l7DI8zKGgvNvpL
         9mQnkjFKhB2GGxsmerycEDazRBeFsLc3XHQyvwB7wCbzHEpJWyF/9lV1o1cwBvSzDwH5
         U9sUe8MNKdrm5aSrOB6b0NEBIGv0ddnMHQ7DRehl14HBCJqo3vO6Bu0a9qybdtI9S4zQ
         jD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773258728; x=1773863528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lInkB9M3FDEV05WLG9mmxw0Eg6pj3q7yDvK5tck5dXo=;
        b=qXS2oxLeTZxEZCIHOL12w9xtkw3Zb+zORmxaOYsTeBa0AGlaiHFDoLCcivNA3XAXbx
         dlugfF6s9Yh0ELrxfE/3HDCW4r+6B72FLfewRqYQoLO7UfsTPZUaQDTbYoT7GHFPtbEz
         uyNMKxsSMEmcPuSuDrlGkMo8thDx9siPAqcRpMkzOHu1ryCyxlYV0CA7GPizJTL6cmyM
         hNGNM/SFaSR2+gFKVdL4pEkW4HuPOIzQF6GG+XKtcgNtJIri1I+maHxi80bO44VM6m3W
         8eLPR4rCFyiHHVnwmShAZy7WAheBmHBTejqFQXRz+c86yWSHgQwGfRi5KKyMCP6J59I7
         PleQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlObrMjeC8K2xXudCsEkCV5V0EowG/NVwwribLUYkOdXP2RCRwiorHxLsCR8xS8NgN65ScyMIQnA==@kvack.org
X-Gm-Message-State: AOJu0YwkQSnT2sGrkCpqoyPmYidIUD885qp0dibNSTh73SB5O8PQAT3v
	6s8tLd3S1JuSaM+tLWGoZq3fq+viltIcCrT5xpNgh72e9cEhc3mckxK1
X-Gm-Gg: ATEYQzyG2c3xkPQPKpEPIEtRyhP3nBDiU845pgnusyWjixI2xMCv37DeL70fVOd821Z
	PtaF9vPQN2SVmBlg586YnTtsxWvG1PFPRzr5CQVnBQJurSdPsKJTH7Sdtj/QBdAtp492ZJi3EhA
	uZCrtA+xE2fKBzIq1PrxxTex4BU88PPyh39sUKD1O4EPkcwB4hmLQ50czCQbY4PfeeUbug7rSf5
	0dW3qIYEJE6fF8I8w3Cj/qalAmiZZ7piuf1KQ/CiAfjIslr4Dlx0aqPt4vOyoA0riqBeHbcdkQn
	NdEJ6lg/GdwV7RbdvjjSA5huxY246RYB0MGbq2wgtjgS0Ws0HQkFI1f7791HLSYJ/AQEGfchFWk
	cmQl/NO8EVQGP029PXllnV+jCS/GErLOvwN9PzU3dIeLUpMsqyi/1NenRtKWlwVpwyCIYMA6hMr
	2s6tMhFtPJubrZO9sBfxtCWg==
X-Received: by 2002:a05:6820:1629:b0:67b:b627:349b with SMTP id 006d021491bc7-67bc8a92e0amr2511581eaf.64.1773258728114;
        Wed, 11 Mar 2026 12:52:08 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5e::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bc9118bc7sm2041227eaf.6.2026.03.11.12.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 12:52:07 -0700 (PDT)
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
Subject: [PATCH 10/11] mm/zsmalloc: Handle single object charge migration in migrate_zspage
Date: Wed, 11 Mar 2026 12:51:47 -0700
Message-ID: <20260311195153.4013476-11-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 27AAB1C000E
X-Stat-Signature: 1mhojijhup7pkrc9hjbgbimz6secr3ji
X-Rspam-User: 
X-HE-Tag: 1773258728-709089
X-HE-Meta: U2FsdGVkX19Lj/4Y5TAIeglVIZ38QnwaZxlP2t3oL6ByAseF2u/1WPRPhIb0r5ZZc9Lzo7FaSDu/D/cHtM5drXqSy0sDMbDUD4rBBeQ1Btj78k4csPHsSmVHpYVixv8dGLavXkFVLdr8nB6ccUdsBRYXjasoBHHM/zZG4sWOmVEP2DFvou+2sFIHrI2wzJeAXfNZfNf3zu6vW+8md50ssxawHCV61Jm2ZVs7LYxBGtsWXS4WyUPl268R5WuRbLdAC6QGHV76rcJspx9iNAzfdm1R+P1t9r5WlHe5EDHY8RI3TzSHCIkuBIGd4mycAyN2XWbzzJ3o9Q5NEAHa4Krj33dlIEjqUub7ubCDlhFGY9VPRBIqbMwiLbr7LQgQFSVj3bL245gJwAQp+F66y3PhsfxO+U29gtgIqt3PHv7fYe5qTQXNwmeJCAwI0X54BNc3x0d3wrrm2zK+ByPyvPUEYiIlMx+zozCpUzotyCdGP+xS/n4LYCkllhbWhunn4sBoZcgcM0KKPe8YxxiElMtLdLlElFYkvhXnCz6KNcZ/fQ+bbFuGSp7tpNH4OtEXswt61mGjvj7Fv7GU5zm1BYJVC4VU1roh7vgBukFgCgVzRCBZrjk8XBc8mNu+0Ol8n3pqA8s/uoh31aooVzoUWN5nsMlHJLLFNDzMem2aL2/GbvCNPD4kiLnETVA74W+7pgfzcjEGdO8kxs95tXKA2+eno2DZzcxOonbZdpM83fGGAyBn+grQvuHNt8aymyddn+uHUref9McALK/Ttyen6lqyXJUt5iYnLducqgQNWoHAMxrCC82JGWgbwgPuZhQE3NYxweWEIb9tUC6UybPh6dWj3rnBrMKiP5p7RorT+pYjXToBq90mMPHwAV250QJn24/e03HuxRxqUwd0F0ZbNlY1DipLjtAmHAOFljdXHu4w1QfHi1Tvbd3dnNLVzOxVaKPMUAb35PoISXOR5rDaICK
 uilBuMZz
 uhjppg38Mtby9lYDsBTik5egNQ9mOSNEd5k5NwJPt19fhfHWD6ouIn1Sj4HMF2FstgYF+pyPnqW2WNFLKwT3awo90LliR+9UKLqFEDr3n5O9NPtmwbzP2cfAc4IQlJPl9ce0v+a5ocCBspP9CY7oPc2R10XIOI/4eeGM5lbYVvFuhbdspaSz0G3oIc/CMwFf0DneSCRsNiEjQOkUMyKVXMausywc49T/qnoCruXDgmvcvoMoyiFH4ez5qvck+ZsCY6majcRwlUGY2B0C/kF+zdx/UgyUzkC7kxoc8vCFcUKct571xNhQKO+RgBk6Pcmgz+odZSrO08pMLP/iT0T0u55FfDNrREWuqsJwnRt/PllaQeXKZjpTr1I7WdBr9mKivqyTMOt456YjJOcpcVYiBtgmy0mJSn1Jp3KqhOj1wxk0HcFQnP3m9jl5rSLOhpRzXGRy84M1IS5vXEwlUwr+kZ/ha0lN8dg8y/7+Nu793aT/P4k7OMeJEvq5f5U307AFu4FWI8RsTn3yCx8y2ay7XvASYBFrKrkDZ/dQf/d1+XrHrk5fPbw8f3Ss+TGw0rvfAbUkVl2gLGAzewSY=
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

In this patch, handle the single compressed object migration and
transfer lruvec and node statistics across the affected lruvecs / nodes.

Zsmalloc compressed objects, like slab objects, can span two pages.
When a spanning object is migrated, possibly to another zspage where
it spans two zpdescs, up to 4 nodes can be touched.

Instead of enumerating all possible combinations of node migrations,
simply uncharge entirely from the source (1 or 2 nodes) and charge
entirely to the destination (1 or 2 nodes).

              s_off                         d_off
                 v                           v
         ----------+ +----               -----+ +---------
     ... ooo ooo xx| |x oo ...  -->  ... ooo x| |xx ooo oo ...
         ----------+ +----               -----+ +---------
             pg1      pg2                  pg3      pg4

            s_zspage                        d_zspage

To do this, calculate how much of the compressed object lives on each
page and perform up to 4 uncharge-charges.

Note that these operations cannot call the existing
zs_{charge, uncharge}_objcg functions we introduced, since we are
holding the class spin lock and obj_cgroup_charge can sleep.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/zsmalloc.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 70 insertions(+), 4 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index ab085961b0e2..f3508ff8b3ab 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1684,15 +1684,81 @@ static unsigned long find_alloced_obj(struct size_class *class,
 	return handle;
 }
 
+#ifdef CONFIG_MEMCG
 static void zs_migrate_objcg(struct zspage *s_zspage, struct zspage *d_zspage,
-			     unsigned long used_obj, unsigned long free_obj)
+			     unsigned long used_obj, unsigned long free_obj,
+			     struct zs_pool *pool, int size)
 {
-	unsigned int s_idx = used_obj & OBJ_INDEX_MASK;
-	unsigned int d_idx = free_obj & OBJ_INDEX_MASK;
+	struct zpdesc *s_zpdesc, *d_zpdesc;
+	struct obj_cgroup *objcg;
+	struct mem_cgroup *memcg;
+	struct lruvec *l;
+	unsigned int s_idx, d_idx;
+	unsigned int s_off, d_off;
+	int charges[4], nids[4], partial;
+	int s_bytes_in_page, d_bytes_in_page;
+	int i;
+
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		goto out;
+
+	obj_to_location(used_obj, &s_zpdesc, &s_idx);
+	obj_to_location(free_obj, &d_zpdesc, &d_idx);
+
+	objcg = s_zspage->objcgs[s_idx];
+	if (!objcg)
+		goto out;
+
+	/*
+	 * The object migration here can touch up to 4 nodes.
+	 * Instead of breaking down all possible combinations of node changes,
+	 * just uncharge entirely from the source and charge entirely to the
+	 * destination, even if there is are node overlaps between src and dst.
+	 */
+	s_off = (s_idx * size) % PAGE_SIZE;
+	d_off = (d_idx * size) % PAGE_SIZE;
+	s_bytes_in_page = min_t(int, size, PAGE_SIZE - s_off);
+	d_bytes_in_page = min_t(int, size, PAGE_SIZE - d_off);
+
+	charges[0] = -s_bytes_in_page;
+	nids[0] = page_to_nid(zpdesc_page(s_zpdesc));
+	charges[1] = -(size - s_bytes_in_page); /* 0 if object doesn't span */
+	if (charges[1])
+		nids[1] = page_to_nid(zpdesc_page(get_next_zpdesc(s_zpdesc)));
+
+	charges[2] = d_bytes_in_page;
+	nids[2] = page_to_nid(zpdesc_page(d_zpdesc));
+	charges[3] = size - d_bytes_in_page; /* 0 if object doesn't span */
+	if (charges[3])
+		nids[3] = page_to_nid(zpdesc_page(get_next_zpdesc(d_zpdesc)));
 
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	for (i = 0; i < 4; i++) {
+		if (!charges[i])
+			continue;
+
+		l = mem_cgroup_lruvec(memcg, NODE_DATA(nids[i]));
+		partial = (PAGE_SIZE * charges[i]) / size;
+		mod_memcg_lruvec_state(l, pool->compressed_stat, charges[i]);
+		mod_memcg_lruvec_state(l, pool->uncompressed_stat, partial);
+	}
+	rcu_read_unlock();
+
+	dec_node_page_state(zpdesc_page(s_zpdesc), pool->uncompressed_stat);
+	inc_node_page_state(zpdesc_page(d_zpdesc), pool->uncompressed_stat);
+
+out:
 	d_zspage->objcgs[d_idx] = s_zspage->objcgs[s_idx];
 	s_zspage->objcgs[s_idx] = NULL;
 }
+#else
+static void zs_migrate_objcg(struct zspage *s_zspage, struct zspage *d_zspage,
+			     unsigned long used_obj, unsigned long free_obj,
+			     struct zs_pool *pool, int size)
+{
+}
+#endif
 
 static void migrate_zspage(struct zs_pool *pool, struct zspage *src_zspage,
 			   struct zspage *dst_zspage)
@@ -1719,7 +1785,7 @@ static void migrate_zspage(struct zs_pool *pool, struct zspage *src_zspage,
 
 		if (pool->memcg_aware)
 			zs_migrate_objcg(src_zspage, dst_zspage,
-					 used_obj, free_obj);
+					 used_obj, free_obj, pool, class->size);
 
 		obj_idx++;
 		obj_free(class->size, used_obj);
-- 
2.52.0


