Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E54CC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 152276B00B1; Mon, 20 Jul 2026 05:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08D626B00B3; Mon, 20 Jul 2026 05:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C7D6B00B4; Mon, 20 Jul 2026 05:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C46796B00B1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:32:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51D6F1A079C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:47 +0000 (UTC)
X-FDA: 85008640374.01.82C8DB8
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 75BD180002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=haaxxIgR;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539965;
	b=7fi109pSnKN8pk2A6Cy0GtbnneCROqM5qh+GVxtvhW02oLw1GtBVaaMKi6jP6lVj7uq+/B
	5Pnw8IKXWfCD++7RdGZD1WCt/jOBEJLERBIoyqsrtSyIvGgPMFOEbWSAMMvXLcTkBEx56/
	FSA9Lgd5S7kcQRxIZl6Lci1NhVvoVP8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=haaxxIgR;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tEa/ZPXIktSh9GylaagybywGK91Ia7MaQl8ZD0pcrE0=;
	b=PU/CV9+FGqpCqdD4LQHzt01BEozYilnDBe6QlZD+YIztypGyd6I6pMkTdQfNcjWb5T/yMh
	GCyvi25NjPvaHcHiZig8SZlTbZmE2bnGxOWinl6LdsVAqJtbpqOTmKC5EU26zFgYlbfuXX
	avE0e4ZLvvtfs2Pl13G8HH0xOenOTU4=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2caea3f742bso118939755ad.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539964; x=1785144764; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tEa/ZPXIktSh9GylaagybywGK91Ia7MaQl8ZD0pcrE0=;
        b=haaxxIgRm/bz53jep4nuwF7r37vqFIV9bl2C34mXbCId2UqytjeAvEqCFGE7s17xYR
         /k98NPNSOn12Jgpe4UXC1j/YhW1Qnk0miQmuPQldaFJjSLVmcMthR+CFtwRmm3fkRznh
         ncWKmWSLXWtQavDYm2Fd9NeYVA4SvorWc0JrWZiHSPbWMkKlQDdWsvmE7yODg2JtTSTj
         absropARs78YtmF5Ot0toxootBvT6xXKlDoy1cTz4PQbI2GKZgefR6+7Yls7q8802uC6
         Trx+yCoRzOvCeRvEJ5p+1XqfdgkCosdUQBLjzQmgXhGxRPBcEthXxo6oYbA9dsC1+pxn
         uxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539964; x=1785144764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tEa/ZPXIktSh9GylaagybywGK91Ia7MaQl8ZD0pcrE0=;
        b=EG7mup+5S6CdQESLI5cKfjC3Z8fVpk/G2jyVo/kl/2Og8GGFDbJ9m1h6InhQQ4MD7K
         Tfwha7t8QRvAEmrShT68g/PCgYYZOKm+Rs784jh+RSWVOYEWcNqKg+4uX0e1wdbAGw1A
         Bn8l1Fa9780ef+OWyGsGONyyvSOKBob+/TGmhGBhpF7iVxzO5mFWAi6d4hlAjJLnt1DY
         pAJxcf0wK+rLX/D6bkEhCPeQ82dwLUTDOSYIiFmE9uYtYMGWJJDlwGyv5oUd84kRKp0w
         u74q1N9oclg4OVbFtpHTCyWD9Ajl9I9ib846+ngvQ6koPqkNhOOWKtZmtCYqdVJg1LNR
         YUUw==
X-Forwarded-Encrypted: i=1; AHgh+RqEeZHQryFP4+LgoqsqtnT3QKIzndIbrSVSGyfpUziusAW1w9RFGwrJEkZvOR+jzWTezvQrw6gkXw==@kvack.org
X-Gm-Message-State: AOJu0Yz/lS+CLkkGXdMlwImf2+AkAPNMSmQGCpDLh+ot9/3L+qJetHE1
	QF/PVfOJLIePZm3NdQv1NFTCOY3JpqEmoA1ApeODaZI0jq+QWXwFUN2vfhvSx8skjt4=
X-Gm-Gg: AfdE7cklfI5QHxCNI/ZkNYVMm7kF/BHNry0aJ+SR0Qd98GIfLOt0QdzE2umXgMQkveQ
	eutRmDO/XRUBiAaFTBbW9UirEXW+w44ZEb7PQmfmm4++DFHBAKCjdFedQ+4Pf/wttJe58A8TGTP
	JEK8tIpt3tedIlWRfLjT2SDguuWny5SCFJAW+XzdGfjxOqvgLkC9G3XzGh9B4VYCfXSJbe/ssu9
	kIXbkyDHzO9hq79Xdd+vi8CzaEL4eLpjjdu90bKIkewNdTcCEgt5LTVNpS1D2/bZF+nieJsazq5
	QbgYY5T2b727bqNcB4cgUmPPxzyFE9+sgaNeuKYnEgi725a+1ibMV/sAj/1gmb4iQNsM+tzEUgm
	SiixzHUd9Z95si1602I09o4AmlMZfyenKqNhDwD3gkKMtMmDJ/se5RiyYgETzxG0S6ywviRXqiX
	HZZeKcxz6klEGyBMTMKe/osHA=
X-Received: by 2002:a17:902:f549:b0:2ca:481:de45 with SMTP id d9443c01a7336-2cf348953ecmr149854895ad.6.1784539964372;
        Mon, 20 Jul 2026 02:32:44 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:32:43 -0700 (PDT)
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
Subject: [PATCH v2 12/17] mm/sparse: inline usemap allocation into sparse_init_nid()
Date: Mon, 20 Jul 2026 17:31:22 +0800
Message-ID: <20260720093127.540540-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 75BD180002
X-Stat-Signature: oss14pip18uojdnu4aqy5i6tmf5djn8j
X-HE-Tag: 1784539965-493829
X-HE-Meta: U2FsdGVkX181Kt3P/hMwOUmuyqs4/6Y8YgwM/Gw/Acxi9udMYUynS2UkDn5xkpq3OoHQ4oC3bq2a9uXUsTSM6avVd3r7FidV/tuMiaQL7lMM2f1Q0uhQVm9plhSkK7xRHaDxvUN6oNz6YHKp0FBCfpWnmdUt2/vhPHkVIZGN27B37HhDhtkYD1q85XIRdQ9gbd5nZv7pAG26gHeoI/JjAatU4CkqaIal2xyBzM2Syz6WsOCE1NGa45J0Sm7oDgDOP1PnLRt9gib0uudCbRV21KB2HQHOukLumZ6GMkvXym0Rayv8a0hbEQc+V/AqHWZVARZTb2+3ztXL0iUsTqU2uMAcNqEjntDDNeKWQQWnU9CxBxzckbhuSCleS/A9VakwZGRd1M73kPi3uKfhruG9gUbCoHPU/KBB60ogOubEJ1Vu6OphSB3U2L4ZNPtnzHki7UuWQt7zQPQdaMaz3aXzqDayuaFu6DenDXbmSuKGcUk6M8bmadwDsSRsPqG5G7QLiZx50NDK4trLgNEBIMwKdtFvUQundYvibqTn2zdyvSZ4J5fPWAHkbskSJroJps5+8849xlsQA6cuP4FL7V1lH7+ubn9yUxfzXw1cV29QdQdfA53zPEglIWwLRFOywGSoPafSafgF/CjLvImJ6Q+9oaOJw1AQaBhxIi1Z81KJ0UQCxmJu9Gj5yPJA9Gog/TUwuGpvNr3yj+E5V+2S7bmJtl2K47ItOjSR2yn3Y/zejJpfie8fYKblolc92fGLUWjEkBA1kZGcNEJJESBPk8gic7j/tSh9+53pfK7CYwC1+N21Yskunb6WvktFxtoj44pqyGmYHUoQ8ShhJu/yabadZlfH9FjCDQmCNB/Ux3RH/vv0HSpyhKZqrC9/eQygVWIE0YiVw208sNBkp5hiiIMDv7tTvSG2SytFnY0TkeNteAaBcnbjQhgi5ADMlVL5rN8mGQJfs1fNYhZVA8d3dma
 WYTk5Xfu
 nk56Y/ecCZ4Zmwj5cBmHZnDck45ZSqRAi7icm9vibnWTejL48h5lbjA1QqNORmiXpKVsdSM0XbfhBIfTW29pw8989yen1enLNIGD6xIbDG+j1imfYRNCFKtntZBZsuC1j+7w5aEy55QydcAKroYdoPZmnm/Ch4bvp1Yz7Ugm4W+0Z3YJ9gzLqktUjLc+R6AFjcXp6hVkPrKRodmGsTH0zF+U6+JoQ3DJxx5UHrAON1qrETKCTztHUF7XuA/A1TvHjC7LCnFYGXcv3yMRKnEfFLS+6kOJNvCBlVgouoW8Y4on/dz4YemedvYQHuRKZfA/IpazDTwiDThS7fE6zooTtvHevA3pD+TptLH7RnE4hwxj7FH+afWkmIFS+maLDz7UrsHrm/Q4hxgDPO1nGmL5Sy59+wGx6wxgLAtHuaQxn31C97pbvOPCCUdrorsIcRtkFnlBwKyAp3bwjN9g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After removing SPARSEMEM_VMEMMAP_PREINIT, sparse_init_nid() no longer
needs the transient sparse_usagebuf state and its helper wrappers.

Allocate the usemap buffer directly in sparse_init_nid(), pass it to
sparse_init_one_section(), and drop sparse_usage_init(),
sparse_usage_fini(), and sparse_init_early_section().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/mmzone.h |  3 ---
 mm/sparse.c            | 46 +++++++-----------------------------------
 2 files changed, 7 insertions(+), 42 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 4a4310552976..2e9e5369f599 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2213,9 +2213,6 @@ static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long
 }
 #endif
 
-void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
-			       unsigned long flags);
-
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
 /**
  * pfn_valid - check if there is a valid memory map entry for a PFN
diff --git a/mm/sparse.c b/mm/sparse.c
index f0d9b7263bb2..743112ac84b1 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -245,42 +245,6 @@ void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
 
-static void *sparse_usagebuf __meminitdata;
-static void *sparse_usagebuf_end __meminitdata;
-
-/*
- * Helper function that is used for generic section initialization, and
- * can also be used by any hooks added above.
- */
-void __init sparse_init_early_section(int nid, struct page *map,
-				      unsigned long pnum, unsigned long flags)
-{
-	BUG_ON(!sparse_usagebuf || sparse_usagebuf >= sparse_usagebuf_end);
-	sparse_init_one_section(__nr_to_section(pnum), pnum, map,
-			sparse_usagebuf, SECTION_IS_EARLY | flags);
-	sparse_usagebuf = (void *)sparse_usagebuf + mem_section_usage_size();
-}
-
-static int __init sparse_usage_init(int nid, unsigned long map_count)
-{
-	unsigned long size;
-
-	size = mem_section_usage_size() * map_count;
-	sparse_usagebuf = memblock_alloc_node(size, SMP_CACHE_BYTES, nid);
-	if (!sparse_usagebuf) {
-		sparse_usagebuf_end = NULL;
-		return -ENOMEM;
-	}
-
-	sparse_usagebuf_end = sparse_usagebuf + size;
-	return 0;
-}
-
-static void __init sparse_usage_fini(void)
-{
-	sparse_usagebuf = sparse_usagebuf_end = NULL;
-}
-
 /*
  * Initialize sparse on a specific node. The node spans [pnum_begin, pnum_end)
  * And number of present sections in this node is map_count.
@@ -290,8 +254,11 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 				   unsigned long map_count)
 {
 	unsigned long pnum;
+	struct mem_section_usage *usage;
 
-	if (sparse_usage_init(nid, map_count))
+	usage = memblock_alloc_node(map_count * mem_section_usage_size(),
+				    SMP_CACHE_BYTES, nid);
+	if (!usage)
 		panic("Failed to allocate usemap for node %d\n", nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
@@ -307,9 +274,10 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 			panic("Failed to allocate memmap for section %lu\n", pnum);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
 							       NULL, NULL));
-		sparse_init_early_section(nid, map, pnum, 0);
+		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
+					SECTION_IS_EARLY);
+		usage = (void *)usage + mem_section_usage_size();
 	}
-	sparse_usage_fini();
 }
 
 /*
-- 
2.54.0


