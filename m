Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E63BCCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2BF08E002D; Mon,  3 Nov 2025 02:53:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDC4A8E002A; Mon,  3 Nov 2025 02:53:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2DA8E002D; Mon,  3 Nov 2025 02:53:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA508E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:53:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 355D212C06D
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:53:03 +0000 (UTC)
X-FDA: 84068529846.24.65D1A87
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6EB7EC0005
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:53:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=g2IoVVaU;
	spf=pass (imf10.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762156381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBJR74pL2UFLaHc8oAOxpJBTbxd/tOOTfgjPB+YfL2o=;
	b=wg1iBpggHB6FVP+XSkl+O0Utt8Y2R6BG9OwbPx/wZIlt4eqygqkokOkgD13whYA+XDGbKa
	nGilNpiJ2eWNeRiMwylx2NzfzsLOLj6vOyiEJe9mnN4F7c9527rQgA9ueLvr9J4c/EbPXw
	hzKz9twFgB6EQdf1Q5oFZoMrmKJVq6M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=g2IoVVaU;
	spf=pass (imf10.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762156381; a=rsa-sha256;
	cv=none;
	b=GSLohmQiNa6GjK9gSgAe8O66d+uWZxQf0uPxkPSNDKirwC1emjay20Rz9fmDPft766AXIi
	nioJ7jFDh/DY9bYfsfdFemIk1L/BQPk5ZkKdf+3Bts+9YgxYehYWDsXsDu4JTLCzUYmmEw
	ceF/htUqYv8JDu4hLKI6eOGv8NhLGh0=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-34029c5beabso3707295a91.1
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 23:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762156380; x=1762761180; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MBJR74pL2UFLaHc8oAOxpJBTbxd/tOOTfgjPB+YfL2o=;
        b=g2IoVVaUN4VGpb8zVLiCwMd3e5VOv/OV2x3Sjxmqdn85zuu3aQj4SDqeYrmIXkvRgJ
         PqK4fc0gzkAj+swVrhcIwONvx4AFBSeSava0U+/aUBoDbgdGNW64c9qHH40lUxaJ+2Uj
         KlWH4VbW/2x/O3gPtX1bKRnwrTAwhgmF17joGNl6nfQmU38vNpWXwvhaNt9MoPI2ID5H
         zP/nPdbA4GtTTUtRQZUvs2qD+XHgJhb3E8PubQPnRoAEfqFtZ9kyJxtSn6Efn7BCgyhF
         4c8V146HW1pFKghaMg7LrerMrAzEAl6/d3YARO0bb5I8yaxQFzOsPUci/6OxyDhrBs4G
         GYew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762156380; x=1762761180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBJR74pL2UFLaHc8oAOxpJBTbxd/tOOTfgjPB+YfL2o=;
        b=YCiojSYWKJFNaVA7STvitMNBe7zcDSCgB7TaUMSLXqFSaFmecRYn2LEQINKsWLxbgQ
         E+CCinAzrL3AseCkRmGrxFVYuS5Cn0Qcx8XH2IT68dwdvgML6jjDJBjdHhrWsoYq2q0L
         FAUZ6E7tdyEEl0G7M3jjG3liUR9wgNESJ6YZ3+I7ShMmD/lW+2O4qzGKRgFcg22rt7lL
         q40d8yKOuGyb1nWuQDESNx9f9qos74k61AfgeG+eVruVfP4JqWXrrySZn+lgDB3bkouT
         dGdzB5+x/PCAWGRmgvjzUDIwZB16vFtRpQXetKRWPD6uIwZCFwLIht6+F3bvxWh0d/X8
         Ix/Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3CDzXtVBWbYhBgjy3N+nO1gUhrCqz8PNCriSCwJNvAX9+PBqY/NvkZ180onNWSljYmIfJ6nabfA==@kvack.org
X-Gm-Message-State: AOJu0YzwRTXc+16VUTEZIiuQ66DD5Ie7CEBJETLflffDEFd8VS5NA9Dm
	AllBjAWDbbpTaUu55pSSYoHzwZ9wdtq/QdF3UaERddjMMkwOOfSf1jQvrZKiQFFiFXI=
X-Gm-Gg: ASbGncv/PidMUw5IKrvF+QfLHRn5Aec62ZnJ57TfMDRj470WcyNjjqRMtM9v78ZUN6Z
	UAKIOxCU9MNpxJWuZSsgAtM2qaXeOum8zYOoR+HhCdz1RXJ36/CyyB302/nRQhRxvyHpXk8LEIl
	SRE9GDuNs8YiWxVqfXYtnzlgkCG7ADuwahwHcG3xZXGiGUCMfFR4i7AkOlqtK1kmDptI4VLLYI/
	2I/QOlOWVQEZxd5pYBEDQ4E3uglxW1g0jDRlT/WGzT6dEOo+sJqpbyCHUppDwbxV282MHWRfjp7
	fdsx/qwyP/UCX6wt5CjIx3ca5fLEcW1p/2zKYV9/wTzVOhVlL+hEbDi5zTFu3CPM2gmvz1wkDOQ
	9YZdk1ifXIcPvGdEIsrczHI7fWP0BbNi/X/mf7Sn8U3bf7n1gNz1g3rAGDH7EHaBTLS5GGTsIcO
	nwyo8+0amwsxu1RtgQzkIjqoqR
X-Google-Smtp-Source: AGHT+IHCeuWblU4UX1TsHgam4EVLA+G+yYi1frynG5wZVaDx/qokn9yyEJcHgqKW4FWQHlMPmkrGgA==
X-Received: by 2002:a17:90a:d450:b0:340:a961:80c5 with SMTP id 98e67ed59e1d1-340a961873emr10029797a91.32.1762156380212;
        Sun, 02 Nov 2025 23:53:00 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34159a16652sm34552a91.20.2025.11.02.23.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:52:59 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: stable@vger.kernel.org,
	greg@kroah.com
Cc: tj@kernel.org,
	lizefan.x@bytedance.com,
	hannes@cmpxchg.org,
	corbet@lwn.net,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	sjenning@redhat.com,
	ddstreet@ieee.org,
	vitaly.wool@konsulko.com,
	lance.yang@linux.dev,
	leon.huangfu@shopee.com,
	shy828301@gmail.com,
	yosryahmed@google.com,
	sashal@kernel.org,
	vishal.moola@gmail.com,
	cerasuolodomenico@gmail.com,
	nphamcs@gmail.com,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Xin Hao <vernhao@tencent.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 6.6.y 1/7] mm: memcg: add THP swap out info for anonymous reclaim
Date: Mon,  3 Nov 2025 15:51:29 +0800
Message-ID: <20251103075135.20254-2-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251103075135.20254-1-leon.huangfu@shopee.com>
References: <20251103075135.20254-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6EB7EC0005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: wm1ds6h1ggxruc7bkjfi7gg7py3n7rhe
X-HE-Tag: 1762156381-168100
X-HE-Meta: U2FsdGVkX1+LBf8vPoU0iYKAkU7iWfdm5RlKgSmcuNeARNcoD3uNXlJOlbxe95AUZawqqMG6eulNCGGuCmuh5/mzPJDfQBl/3rhGH0BOu+abAHPmBzhjheQ6CLMXBgxgsyZIRmJGKNuJTybf88HLaDMFwyfm7t6WRyefjxGiXqWYHYwJCBvsG708k7/6J5GU6+CkzluDLYOpg45LgB+LkEmtOZ9hRkPHl1ktlDZV/laW5o240LPwehcEhQACytiMoYzgBvJ9UfhgxFBBp4N38K8A44jSXc6oahXk4VeGpR/4aqqJIB6aUBdYfhV2XDeZ5GlCr8XqNCU3KP8qr0hDc8Ko3IUGKuGqkP3DaUQ9TJAp92Xg4GedGEp27XEo4mi48lANb10qn8IWtcas4bbXdHzKtLYAQ3bzKRk31Zwo7P6iK4tsrEQztnhOuMkq8nxnNJHQ+19ZHf5c1Lea0u6TeSVuw8hbasG0w1QiZiS4K1MgKdiHFzzNI9aI+FNA7Uw1qCBLO8mLi4KtSxyL5UXpPgWaclt2sJnNAO//vbJSmwtylsxON3BAyXvmP0p1/njgzP6kB8eq8DCi6PRSf+/rVuFsl5aHdjhDyySr26oGpxlBNKMibx9Gju/mWOI84/lVpbxB9yFUz4fb9MQM7D4jfePnzQ9D+RWedP9vnYi3e40uThNe1zCK2WzTrREDe+lgahdkGOHeJLDW+um+QXe1+1KXh/y/Q6iD8Dv8j0B8u3HhwGKxjmt8ax/EyryyX2Tb3++Owh8WosoLcGIWZ+oxxwP55jTg3VEoUzXeiLms1sSUc1ERmtQVkaSKtLlBWAULsU+LS8ikG65pdh/B8fUY13r/rpC81ggvR8jWZLQraRL2Fj52FLynFE82GGtKgCrdh4GxpHngl3pvSgIUNq6+vRKnSF98yP8E+G+0Sm699kyqbC2Io3xCRwChLTliPsGeK8MjAN3CN4ZZHnNCUPx
 Y8y3Vj0v
 +eqshxIhQgG4ZUrwc89FoJqN9C9qEi5368u3CsM0EMUUUuV3xf1aQXI9DKoKWh4bPGJWA1Aq+I1jtEhCDMOMCYuD2fLv0y30kwuH9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xin Hao <vernhao@tencent.com>

[ Upstream commit 811244a501b967b00fecb1ae906d5dc6329c91e0 ]

At present, we support per-memcg reclaim strategy, however we do not know
the number of transparent huge pages being reclaimed, as we know the
transparent huge pages need to be splited before reclaim them, and they
will bring some performance bottleneck effect.  for example, when two
memcg (A & B) are doing reclaim for anonymous pages at same time, and 'A'
memcg is reclaiming a large number of transparent huge pages, we can
better analyze that the performance bottleneck will be caused by 'A'
memcg.  therefore, in order to better analyze such problems, there add THP
swap out info for per-memcg.

[akpm@linux-foundation.orgL fix swap_writepage_fs(), per Johannes]
  Link: https://lkml.kernel.org/r/20230913213343.GB48476@cmpxchg.org
Link: https://lkml.kernel.org/r/20230913164938.16918-1-vernhao@tencent.com
Signed-off-by: Xin Hao <vernhao@tencent.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 9 +++++++++
 mm/memcontrol.c                         | 2 ++
 mm/page_io.c                            | 8 ++++----
 mm/vmscan.c                             | 1 +
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index b26b5274eaaf..622a7f28db1f 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1532,6 +1532,15 @@ PAGE_SIZE multiple when read back.
 		collapsing an existing range of pages. This counter is not
 		present when CONFIG_TRANSPARENT_HUGEPAGE is not set.

+	  thp_swpout (npn)
+		Number of transparent hugepages which are swapout in one piece
+		without splitting.
+
+	  thp_swpout_fallback (npn)
+		Number of transparent hugepages which were split before swapout.
+		Usually because failed to allocate some continuous swap space
+		for the huge page.
+
   memory.numa_stat
 	A read-only nested-keyed file which exists on non-root cgroups.

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2d2cada8a8a4..c61c90ea72a4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -704,6 +704,8 @@ static const unsigned int memcg_vm_event_stat[] = {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	THP_FAULT_ALLOC,
 	THP_COLLAPSE_ALLOC,
+	THP_SWPOUT,
+	THP_SWPOUT_FALLBACK,
 #endif
 };

diff --git a/mm/page_io.c b/mm/page_io.c
index fe4c21af23f2..cb559ae324c6 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -208,8 +208,10 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 static inline void count_swpout_vm_event(struct folio *folio)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (unlikely(folio_test_pmd_mappable(folio)))
+	if (unlikely(folio_test_pmd_mappable(folio))) {
+		count_memcg_folio_events(folio, THP_SWPOUT, 1);
 		count_vm_event(THP_SWPOUT);
+	}
 #endif
 	count_vm_events(PSWPOUT, folio_nr_pages(folio));
 }
@@ -278,9 +280,6 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 			set_page_dirty(page);
 			ClearPageReclaim(page);
 		}
-	} else {
-		for (p = 0; p < sio->pages; p++)
-			count_swpout_vm_event(page_folio(sio->bvec[p].bv_page));
 	}

 	for (p = 0; p < sio->pages; p++)
@@ -296,6 +295,7 @@ static void swap_writepage_fs(struct page *page, struct writeback_control *wbc)
 	struct file *swap_file = sis->swap_file;
 	loff_t pos = page_file_offset(page);

+	count_swpout_vm_event(page_folio(page));
 	set_page_writeback(page);
 	unlock_page(page);
 	if (wbc->swap_plug)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 258f5472f1e9..774bae2f54d7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1922,6 +1922,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 								folio_list))
 						goto activate_locked;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+					count_memcg_folio_events(folio, THP_SWPOUT_FALLBACK, 1);
 					count_vm_event(THP_SWPOUT_FALLBACK);
 #endif
 					if (!add_to_swap(folio))
--
2.50.1

