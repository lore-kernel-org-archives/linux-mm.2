Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF383C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F22F6B00A7; Tue, 25 Aug 2026 04:49:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9A86B00A9; Tue, 25 Aug 2026 04:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DF976B00AA; Tue, 25 Aug 2026 04:49:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41A646B00A7
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:49:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24130A31DE
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:40 +0000 (UTC)
X-FDA: 85139168520.17.3EBCF23
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5BCC2180006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BZYPoezE;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vfVcATb8qZsBfkQbzRHSDHUI/BdsmgHAfHU8Cx/Oa8M=;
	b=1BirMt3O88nI5uQed7UiqFUpnLEg3u1rr9qutIi3a/OapXQuAMp5L39hJ+H5bR2ojAcbzw
	OxTssvc+nV2vE5RJIGZdZ85v9UIOIHVSBUFhLz0tZHf6tRWO11BXj6vBjtRlN4FxYExryk
	ExjuTLbNHNZKiQ/dJ9DlQAkVVoIG6ro=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BZYPoezE;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647778;
	b=jREWR6qZLZPGFz8/fZH5c6OwVSqBgn8vLZRmew+1tyyeHl2+q/zaSUHePcpSX2Pr8tCxDi
	49WhHyw776roWNgvGTC/JvlK2hyKcif0OK9piXX2aYjzpehZNavPgSTOIgeVFGB1lW6lRP
	lOyo/fNp/CUHJluCqRxcNXb2Enw675o=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c9aea40d799so2732250a12.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647777; x=1788252577; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vfVcATb8qZsBfkQbzRHSDHUI/BdsmgHAfHU8Cx/Oa8M=;
        b=BZYPoezEOaTuqbf2ltbtj2NMV4Eqmd50+Y65D+7/a1li908nJE6TMqRlTTrrQK9WmD
         B1hkJ7vCmuyk9LiGdaY4ZjQyMthMLdbRzgk6rLlGgogk6HU5UIhNRqp6QLaRsiFxb8JP
         gcD+sxR1257K5q9cIKJuON8R9siCfHC2cDD4Ad3+/dsOUd22eeLh3hgoxYvVE8Tn0xEx
         9HOCBVn3NbaXo2oEI83IwzQWOJokcEylBYkKiaT/DFET0Jcw+28hNu8iTFObFcJ9iwNT
         5Q17lBLzWMWyjtoRskf/rlcnhxp/JEzKJALvtI7YsUkaN2UFF3hgHGsOffDnBYWHh8hx
         WgJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647777; x=1788252577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vfVcATb8qZsBfkQbzRHSDHUI/BdsmgHAfHU8Cx/Oa8M=;
        b=j9lPsgsT93fGGtp8xSYtJQER3I8VFFwUFz5Uzt7ZifnyKPV9S/41QdR17ZBkreSUjG
         6qEfuBDqaUktYiOn85mBeezC27t23PwdjuJKfiOGAZOkX+d7cubOOwrYEZ8PHCWJnrif
         pCIJI5hu3js5xJa7jBFYSkaPP1S2qsruMZ2zXUFWpZ3fyjeR7OusFDEskrcMbw1aDsn5
         4Hsi8NJjZ02qQMBYR0GGTP+uqL9jDy1R7LrkxH0hWKTQVxYqoC/jCuzgXYWuBolzYsEf
         DcQ0DUmi/exYPC2S+agK7LspymzIGPqqo5HgSDAxby+wkiYYB41ronmKXAn4ImWWBwcR
         VFmA==
X-Forwarded-Encrypted: i=1; AHgh+RrIW/aVnckUotG3kjCSyfxTpuE0xyVUW8Sia53bhr2mA7xLwI0KjwY4UbiWbeUTSrMDd9J/7CLWaw==@kvack.org
X-Gm-Message-State: AFuF++ngj7Ym2O1POyoxo/L0qGpN/8LKYgY2qFkqO8TcyTBAG1qYp7ps
	M8tuTZY5Xstkca0KvxW6YNu0LqWFEKbkcf3XiFACROtWH6oZaV67PQCbBLbrP3O+V8QJsHqSfm7
	jRkhA8oA=
X-Gm-Gg: AR+sD12Z2sVdIqzug5q2c0vf+BqGnwEkHe1ln2vdNbAy65jF7VgP9ck+TAQn1LfRGQf
	neKOaNd/pQJ8MJWUWCp4jQN1Hu9Zxn3xBBWkGgASitrdc0YQU9jZsmg7FRmaOEuEHVbn79XnxFQ
	xxOt6M2631XVx7vKEiK3R46d9n48VGPgHEzoKM1magIB3mTuR2jGfH+ecHSdnBtNMHdMzUggvvL
	WZZKpe6hgYfTxxxJuhH/2RglJLfiwBOUDIIQEo2zjv0NtSnFxVbyhMvUNOBaNYMORy/YlSH4n7h
	d+uD0/0Z+vytLI4Auik0Xbjkg7fTpbB5wkpPTiyUUmN2SVi4QTN9pKLxnwSqPpROt4Tu25l9tmA
	VXbS2KtRBXSX0cFdC8+aUbTQ3Zou6wQijT2dtdxYE+ZRAeRotrF/eqsBnMXe0uFmOwfGbjLbZ/R
	p9yjXvFqys+jpaCMMt7toZFLMWQht9EhVVCn1IL1cVegMhFYyMtV6MRQ8DAcWbt2ipemPlASikZ
	ASbQSHhIyCOaC4zsFXCjlNYvw==
X-Received: by 2002:a17:90b:524c:b0:366:10f1:3d91 with SMTP id 98e67ed59e1d1-396462b6015mr10760110a91.1.1787647777141;
        Tue, 25 Aug 2026 01:49:37 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:49:36 -0700 (PDT)
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
Subject: [PATCH v5 09/17] mm/sparse: initialize memory sections earlier
Date: Tue, 25 Aug 2026 16:46:00 +0800
Message-ID: <20260825084608.47437-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5BCC2180006
X-Stat-Signature: nqe7rnyngmbj6eyqigpghc1k8tu1wmyo
X-Rspam-User: 
X-HE-Tag: 1787647778-90167
X-HE-Meta: U2FsdGVkX1//DPFFo6DruhMxGLROmxx+2fBxkFQGjGSShTKiP40n5KZq/f++wzfWcf6OMBO2O/1SvDaV+Fjh4/5oVIZLyT7khy1FKeBpCqlGnU/+xO9DXF/JL/RlZ9hgT6UQu3Zzy3pBEy4KeC6cemw1GXNM0xLSg/kVu8lqJNNEHEmLrNQoJk9Xo+VfDMcbkRvINGCNyy3vZokZUsLU1r7AkOJ8HaaLu1Nse2VILuEtCYDR3TbXesjBAvZBPZNp4QbFYjkMZnc0cY9lv5K//2DM2Zh+ItVPucZEBNHsY0kJExEhXi2xI+tGYNliMeUjou3UGgXDoLECzoUanbBslPacSoX0X+zo/SRBEbcfTd/29sO3Oaz6ULUQ7LaAfUcczs17rjjGUNYZW9cC64h2aYc3IGirRUtbJwh2jBVx/2YSl3P9AZ0caX/OldxAFGyauNG6y9r8jYMDvHOfU6SDgIQXhBZ4w/DxaB35aSBnQObPhxpq7rDqh/67fZFcVVLsFxllslCct0Vq8RgM7O/OJLsh5Fdy8capTSuhztzKwtbVQL57kRCyLw3L+AzZuvAOTaEBsWHQo1nt/IYx/fCMvd2umFnraYiG+sr0N00s7672hwrZENdsM2ETglfmfe6m0F2Qz7vTRqVGF2YKEElCQXbWRAvG7Tyn8NmBD4neuYKZ6/Rr/6mIVAosk5bBxe+8WakFdkUMnmX/mbzPyhK4Ty97YwjoVP9LzcOfOAyj49JLLfC4bbDWzZGBKlacTaMGQWOwRYeR+TqIVmo4lQEVWkdGUJNirN/6IX9WgDUPwW2dNAdSXJKC0gmCwxWbu9wfeGy+8a3ovyfhpfdXEPK41SWV1WAfkqW2TgC5NNxdHp+x7wFGU95dXeKaO3uqE5lQKC+pNCIr/J4A+XrIO/mlIre1/nap7kxwsRjaoEG7wf1S4fX3Zh/hh5sNSY+hOzy4WRYk/95p3huSVtcZ7OF
 zR9/6Cex
 YJEtmGNh7hfIahHqCI/9Yv94qyGGFMaze4D7KAmQDROjLjQZ9lVdsUrD11ddalOD5iG7CBKzMU+HTuxP777DkxislMz65Z+Y0hPW5s5Ss/zmjrCGFd7oC78KRFsKp6gtNzK/ql2AnuhzN/+VzYapY2bXTSNCaBBA76xP1SZpKnfTeizqcQ9p4eQgKpWRm9mW/qiAQNcoFWbP+zkxqg3/kPq9xdHUjpoUFrds7RtjDGP/wVnmrSoYnvN1jbcK7HrXqEytkO0lvm89iXZ68Fr91V1SGoAqqRxb2Wj/thyY57p38da7LoZaNzN3I+ylaIwPjvvm+L9OvzpaMvXLD/c0NWgipCL1+SPYNDDudyjRIZWo00gF8dWIxkuh5LDT/SSqJVPZoCK95HoMa9nrdeQdDWIP5ioxcn+yM0wl7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Upcoming HugeTLB bootmem changes need sparsemem section metadata before
the HugeTLB bootmem allocation path runs. The memory sections are
initialized from sparse_init(), which is called too late for that setup.

Move the code that initializes sparsemem section metadata for memblock
ranges into mm_core_init_early(), before free_area_init() and the HugeTLB
bootmem setup. Rename the helper to sparse_sections_init() so the new
caller describes the sparsemem-specific initialization step.

This is a preparatory change.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v5:
- Collect Reviewed-by from Mike Rapoport

v2:
- Rename the helper to sparse_sections_init() to describe the section
  metadata initialization (suggested by Mike Rapoport)
- Fix the !SPARSEMEM stub name so SPARSEMEM=n builds compile
  (reported by Sashiko)
---
 mm/mm_init.c |  1 +
 mm/sparse.c  | 10 ++--------
 mm/sparse.h  |  2 ++
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0317fb781e77..e2a16d833635 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2642,6 +2642,7 @@ void __init mm_core_init_early(void)
 {
 	kho_memory_init_early();
 
+	sparse_sections_init();
 	free_area_init();
 
 	hugetlb_cma_reserve();
diff --git a/mm/sparse.c b/mm/sparse.c
index e6cb67ca9c8d..439802e6a6ad 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -191,12 +191,8 @@ static void __init memory_present(int nid, unsigned long start, unsigned long en
 	}
 }
 
-/*
- * Mark all memblocks as present using memory_present().
- * This is a convenience function that is useful to mark all of the systems
- * memory as present during initialization.
- */
-static void __init memblocks_present(void)
+/* Initialize memory section metadata for all system memory. */
+void __init sparse_sections_init(void)
 {
 	unsigned long start, end;
 	int i, nid;
@@ -322,8 +318,6 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	memblocks_present();
-
 	if (compound_info_has_mask()) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
 				    MAX_FOLIO_VMEMMAP_ALIGN));
diff --git a/mm/sparse.h b/mm/sparse.h
index e427d72e9c2d..e4617f9c8876 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -59,6 +59,7 @@ static inline bool vmemmap_optimizable_order(unsigned int order)
  */
 #ifdef CONFIG_SPARSEMEM
 void sparse_init(void);
+void sparse_sections_init(void);
 int sparse_index_init(unsigned long section_nr, int nid);
 
 static inline void sparse_init_one_section(struct mem_section *ms,
@@ -104,6 +105,7 @@ static inline bool section_vmemmap_optimizable(const struct mem_section *ms)
 }
 #else
 static inline void sparse_init(void) {}
+static inline void sparse_sections_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
 
 /*
-- 
2.54.0


