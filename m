Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B81CBC44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE23C6B00CE; Mon, 20 Jul 2026 15:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA016B00D0; Mon, 20 Jul 2026 15:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8A06B00D1; Mon, 20 Jul 2026 15:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96ABD6B00CE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:36:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14A98402AA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:36:00 +0000 (UTC)
X-FDA: 85010160480.21.51A65CF
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 674DF80014
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Bwp7rIu/";
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yyvPve12WhVPZzxgug/++OGUAj2qo04o06OFhCcQQmk=;
	b=Jq03JeglgfZ9Rp7OYHCggOJ8RF4RthUT9G+PRklbdbEaM0qtkTW6BRzcg7icL8tL3T6ss4
	bbgh1P7dx8H3wM32AOpZL2wVO+omA7GjHC+a6Sev3EOo7mAaE7mhNv7PumWlamOTnzXHZD
	HhoFOIK9S1P6uYVKDoTDXGyhNnRVGV0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576158;
	b=gsGVqmeiyhKdqrTtG2zPwXY65L9i99txjZevmEW3rwuu/487z2mD6VbLfBnmmUmxPGiojD
	cSquiDWVwX2x7SaqL7oMaqIzF7zBllwj0HYNk4tvF6Z7ndiMDwp+hIVjYtIal7imVS+f3H
	xcnOQeS/p1bcvFOKUMePp3zU85vuwGo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Bwp7rIu/";
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-930c0f9c1b1so259184185a.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576157; x=1785180957; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yyvPve12WhVPZzxgug/++OGUAj2qo04o06OFhCcQQmk=;
        b=Bwp7rIu/t2SyeNT9hGZ1hkDdPEDyNy0ZiskD6cEZQ95bdThOpNOBRuGk2axnzUc8dn
         GWBI4KAzi0t5iAtZdKU/htep+SFKn2G76gGiw/h+yIIm9NvWqZFS534GYdzZJ1uxDG1J
         6qbjQDxgtqHzElnGFtnzuEbTb5LPNvPvIUukQ1ZPL0ul/jCp7ZA2mvHF/t8SLfhAC7JG
         WN2YXz6ilTn+x1p0x/Ln5oGStUw30TUVDB2cNU3vQbiVh6nPFpnf8gIk0PnGdimWQrbP
         utNaB8X6ZB0ArQiGdi/5nGAFje+jwOz0yaqqSG+2wwTQ2gc6w6s7CLNqY6Wv1CsG7+S8
         W2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576157; x=1785180957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yyvPve12WhVPZzxgug/++OGUAj2qo04o06OFhCcQQmk=;
        b=GSuarTOnNs7xXW3kX9jeBkCP9GpQU9feoUYX0CALHuv+jCCREQxWOpSzYB1IW/hJj1
         orsSqxis60vMHydYxH2K81zYRXOn4QtyBfc8VUSow+lnjOvnvV9k8JBJQ+jfhEW+A88P
         N2XH5BS8+11kshRCTRbokF0edDi5fUbCcFKqlAmLsU0Y5dzMNQxQibY4yznheVsiUTjp
         yo82J1vFhe7pgXpoLRA0g8N8htct26bHhZZUW/cLogoXvWw5qt+G7B/bMs0MyrDjfNrN
         H5TJPcwq/c7nM5cX3ceogOxpmlGr4pmMe+/X9tg8slSmvp0c5Iba/oN5HHxqIA9Z8pJv
         SNoA==
X-Gm-Message-State: AOJu0YxXisE+3zv8trW0lKip0lskWkUOJNmJcf6sIKcBBVgbxX1xQidf
	9MeOcupGBpCHz4ke04VIBV4hQbabTTT9nmts19f1l7ck2vOOZmPSFtHBgnQk38C7RuRXHune8E0
	O8dDD
X-Gm-Gg: AfdE7clho2JIk9S5wWn5WA/G1oXdKLf+eWlLDat1eelPSbcE/XC2wbNuCPUvUfKrpry
	FuWEqLRzDVvHHgRm5KbcRU83wN717oQslvHaVMplpY0GDOw+fEtS9FvIrUvZcEZdIJgxG/ZCJLL
	zhm4yoIshW1hD40i8TX5PcTIpN9WKR1L1SUW/B2II76kpn5eQit3f3xXteCVKrxnK20ovWvqN49
	dA5rbBqLiMHNFKiHBYqa2sWWLlzup1qJVjK3O/qjV2oG1fUBRbeiCPSa+Ff4BTfNHAFnWIbLMpa
	K35/JS0erhxmoHDJbzBJWeKIVmf4zrjQ0WUPcrJbQqX0HpQQniUjZm2J1OB1OmDoAgOM8fcPnkJ
	1Ye630WiCgPmJEHp4637xn0whIndO2QEwmdhs6mRVp5LRDSfM0bwDdaLdfmNyD4cmr2hZXZRDQe
	9TjOMYYrMU9IJbi8Ou9sK8Y56mNOdZwQBXSNYa9CpW8IRd39Jo87lmo9Sw6RHcUxw=
X-Received: by 2002:a05:620a:2855:b0:92e:c118:18e1 with SMTP id af79cd13be357-930b437e3afmr1539338685a.88.1784576157342;
        Mon, 20 Jul 2026 12:35:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:57 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 30/36] mm: add NODE_PRIVATE_CAP_NUMA_BALANCING for private-node NUMA balancing
Date: Mon, 20 Jul 2026 15:34:24 -0400
Message-ID: <20260720193431.3841992-31-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 674DF80014
X-Stat-Signature: o68j45azqfr8597tocmg4fii34bf1g4r
X-HE-Tag: 1784576158-459518
X-HE-Meta: U2FsdGVkX1+arBRJ1PIZkPOXMXrf9fTBnkoIV6GbRw6WRp3eASCHz2L3Lag04W2okEASFOIwvblcv5UqNvCYBT/3xEDxmPd8i+hYEw4gj5G0QigSsxHLtHL0gleXh5RaEVDkEfxyn+qSrP4U30VtVrJKT2ENM5NE4kdZM0udeVZwM7L+rKvp8SZB326CdC4tuiXM0CsrcH8Hp2VA8znlgzbOZMnmzf7P3wHrQsODTKAiEn0qtKftwYcvlENsUkzjyIlN95OzC5R7c9a/ewqFlhGJHXe4Y076z0R5+RA9cginllCw1TKHaD9sOjGPGXSG6e5QgaxEHE9MllM5vbJDqzD1OImivYzkA2glHcvsVrA1q4i4/OKtaM2HZdHUjhhORCOK1qiCzBfxqfMCEh5kK0XfOMULq6WwOsFfemeKJ7j7wwq5TERNUE6U0ByJPDYaGUrX74lBeETu7PVrUHF40ngmdT4X06sTuPUyfykuIddKk2AVHZ3nenuKJFiNhkZhQH7q03ZKM1lrPCy16/J2ZZLmjDQM0iLlbdmvhJ4RRKNptcoskTNyMkXQb/AhPLfFiV+Z/VKGKy01YlkVslJaQ1WYur1SNEcyqKOY/p8pDRCfsuVR1EZFuy/zcOhQDPqACzx5xEH/uIU050x4Un+K9xJgJA5FT7fzhNzt8gj6G1g35klB9gosa5x5+MBWcYZg+Lzg/wNUJ1pROyrGw5oDZkUTdwVLgs5tkxry+6O8UmItBL0XJRzr3jwAEo7tT7xcJqjPSI9vhj/bRkW06dfvuDfME0Cg7P4epeSurBmYD2jhRHWb7TqEIcIPKqhCryIic1Fg7+khotNMmXVmKYizJj2wbd+dciEhDEUv/Qx0Lv5ugx7yq305AQziDqq3lACSkP8uldrDbk4wF7r6FIQiIObCVc0da9guczO/3ssfOVqoEOWx7tl7c8/cWxwuGmHAYSjae4y3J7AU0aVwl75
 /UIodc6y
 fxaE+pifh75FtBoHRy2N7qwwDOB5cG5i7A1TbVFrUJB/VoYfq/K0Z3K5bpwbM9G0bcM+E5hs2zTh8ykHMFysDRZ2NbDWe3pY6TIPZYsdzV5leiX0FJZ5T0FCuoBbpE2ETiwRq3kdirQ/nNFGDrTVjjjGUsn8oV+beokIyVxvVS5zpaBJwMoIp2Tqp+Kq+VDE/uKFXA2Tinray0UN/isU9kgj/5SJT5NCjcv5poq7n0M2stYTiQhk8hgsRQy95Y8DpaFeNLUDyUJygVKAlW4wfOMXVvZL/KPLH95zET01LPVX6ypm7P20/muz4iPKFjy5UukpHIEYG7i0LKoXPxXzGULZbYaz3LeFMV8uOhYzEloxi/S2qqXjBXpP3/CjHyATGNtMKlknVOShKBudF6bamTwD7mW2wy+y7vNq5y2lCGqvoKUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

By default NUMA balancing does not scan or prot_none private-node
folios, so the kernel never migrates them via access sampling.

Add NODE_PRIVATE_CAP_NUMA_BALANCING to opt a private node in.

Add folio_allows_numa_balance() to gate change_prot_numa() scans on
node eligibility. Opted-in private node participate like normal.

Unlike demotion, NUMA balancing is not reclaim-driven, so this
capability stands alone and does not require CAP_RECLAIM.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/node_private.h | 29 +++++++++++++++++++++++++++++
 mm/internal.h                | 13 +++++++++++++
 mm/mempolicy.c               |  2 +-
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 87b03444b2c97..5c3e070ed0deb 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -16,6 +16,7 @@ struct page;
 #define NODE_PRIVATE_CAP_USER_NUMA	(1UL << 1)	/* allow mempolicy */
 #define NODE_PRIVATE_CAP_HOTUNPLUG	(1UL << 2)	/* allow hot-unplug */
 #define NODE_PRIVATE_CAP_DEMOTION	(1UL << 3)	/* allow tiering demotion */
+#define NODE_PRIVATE_CAP_NUMA_BALANCING	(1UL << 4)	/* allow NUMA balancing */
 
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
@@ -143,6 +144,29 @@ static inline bool node_allows_demotion(int nid)
 	return ret;
 }
 
+/**
+ * node_allows_numa_balancing - may NUMA balancing scan/migrate this node?
+ * @nid: the node to test
+ *
+ * Access-based promotion/migration.  Unlike demotion this is not reclaim-driven,
+ * so CAP_NUMA_BALANCING stands alone (no CAP_RECLAIM dependency).
+ *
+ * return: true for normal nodes and private nodes opted into CAP_NUMA_BALANCING.
+ */
+static inline bool node_allows_numa_balancing(int nid)
+{
+	struct node_private *np;
+	bool ret;
+
+	if (!node_state(nid, N_MEMORY_PRIVATE))
+		return true;
+	rcu_read_lock();
+	np = rcu_dereference(NODE_DATA(nid)->node_private);
+	ret = np && (np->caps & NODE_PRIVATE_CAP_NUMA_BALANCING);
+	rcu_read_unlock();
+	return ret;
+}
+
 #else /* !CONFIG_NUMA */
 
 static inline bool folio_is_private_node(struct folio *folio)
@@ -180,6 +204,11 @@ static inline bool node_allows_demotion(int nid)
 	return true;
 }
 
+static inline bool node_allows_numa_balancing(int nid)
+{
+	return true;
+}
+
 #endif /* CONFIG_NUMA */
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
diff --git a/mm/internal.h b/mm/internal.h
index 62e68acae08a3..01ab8b32b0bd8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -123,6 +123,19 @@ static inline bool folio_allows_madvise(struct folio *folio)
 	       node_allows_reclaim(folio_nid(folio));
 }
 
+/*
+ * folio_allows_numa_balance() - may NUMA balancing scan/migrate this folio?
+ *
+ * NUMA balancing is access-aware tiering migration, so it follows the tiering
+ * opt-in: false for ZONE_DEVICE and for N_MEMORY_PRIVATE nodes without
+ * CAP_NUMA_BALANCING, true for all other folios.
+ */
+static inline bool folio_allows_numa_balance(struct folio *folio)
+{
+	return !folio_is_zone_device(folio) &&
+	       node_allows_numa_balancing(folio_nid(folio));
+}
+
 /*
  * folio_allows_longterm_pin() - may this folio be long-term GUP-pinned?
  *
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index fe42a510590a2..4daba81fff7c7 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -874,7 +874,7 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 {
 	int nid;
 
-	if (!folio || folio_is_private_managed(folio) || folio_test_ksm(folio))
+	if (!folio || !folio_allows_numa_balance(folio) || folio_test_ksm(folio))
 		return false;
 
 	/* Also skip shared copy-on-write folios */
-- 
2.53.0-Meta


