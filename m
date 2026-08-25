Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D66F8C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8B396B00AD; Tue, 25 Aug 2026 04:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61F66B00AF; Tue, 25 Aug 2026 04:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4ED56B00AD; Tue, 25 Aug 2026 04:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7916E6B00AD
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:49:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E4B614023D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:52 +0000 (UTC)
X-FDA: 85139169024.10.37BE3FF
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4F6EB1C0007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BmO3Zv78;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tfN6zKvJyOETRiPLuhLazGAgAbhX73SzFIauwVYcbkM=;
	b=74Ca2u9hiDDRfMB6QVh3OWLDUFQnoRk1SXuGRB/A0foTF9+lTODE6FhPtyd5DkYt9EaAUr
	QF5YD76nWiBCGPakNr+Ac3wayH+V1PFgyQ2kvy3Sdx5DeS377+NRVCwGv7joKmDU96QuGC
	MyXUqAHLy7EGOXfVobkRGxxmgz/izEY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647790;
	b=Rw+2WI19MCCps2Pt0D/eVDVqOXlPIoJ3p1h7W+BwMYOKkRIe6A3y015IggL3klFSV1Ju4y
	L9R71bNXuYn8YyxF0Cv+h+5fJvlFLBuA+7Dz0N66DjafhWMWOZGWyoJWq5T9ClbNwRIJ6w
	MfG4YCVb5jyoVmimb/h3b/8ehfN3yPg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=BmO3Zv78;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3964b061528so744744a91.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647789; x=1788252589; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tfN6zKvJyOETRiPLuhLazGAgAbhX73SzFIauwVYcbkM=;
        b=BmO3Zv78GUuuwdEu1sOqGaVGkUXjc2N7W2gXZnNS9HRVPtbsVURHDRStDk5fnjvuyA
         FTClvcEchqKucp6HQy9cHs7eRrtGYhWjqH5hErzxClCgz/AbaE4pGuuRgeGIoSj7urht
         OSrK1kuOQAGHNu2r7J8WljlTQQMDallKveEw1ss4OfHNXde2bhjiIJbpWRXB7CFlyUFn
         LNffHg0aH+/t/UEFtOcwUQ0UySLTcQgabcHFU0BcQal4hImHWz2gSG+huDpRVYHBLAWj
         eR1KwT+v4Rb45LIGHO3eMsj8JBkOnlAuWt1GWZgTOgTDFbB+XmzNXR33lGpPnRwPGQz8
         AYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647789; x=1788252589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tfN6zKvJyOETRiPLuhLazGAgAbhX73SzFIauwVYcbkM=;
        b=KxIUFwjVzgPbclmQCIPD385wz+egg+MqtYUpHMP2rL9ksrWVZe34gi1BmYetQznkXO
         5T0uTKHZtMRyhz+UztPeR7X7QBf6WS5e9ikc1SXS5H/ad6mc01KC8NjSJxZGYJJGnfxK
         bSJWRbZ88JpYgODntxGNGAUmTdN8eFvrY0X2GpKynJQjYICcgHm7SjQkzh7C/GLacQrp
         GYmQKF2s1vfOHa2A36VvVRluJPzKbfgOcRsWNJYQtu1bU6rv5kNXISq+mRM6bRQQ8ZGV
         qjWX5yPGuJ+uGZ6NV5oyAPXQzhfCs1Iy5NuR7yK25GTlXxCF2gIJiyIkLpnllcgyCYm3
         h1Xg==
X-Forwarded-Encrypted: i=1; AHgh+RpR+voXoE5vZgn4uF4QvH899gggU+ugPVREMKY9M96T2wAACTXkNb9k7Ph1RHOO6kFYC+67nxyDhQ==@kvack.org
X-Gm-Message-State: AFuF++ltMM8h/lwwuT9qnCMtaZxW6mBp6Wpw/2N6gW8IE31Mea2mhaVJ
	OAtqaBYcc2+slr2nAd5dWoWDqknf6xxHsLzuWgE8ihmWVL4Wt8FMYxQtdGOV2MqX6uA=
X-Gm-Gg: AR+sD12Pc9dMFLLf2o3ZgLSK33nfbxqo+se4z+7OGU13gedQFrprzZ+jWKePLji6Y4x
	qv90rhqVFrj9H+lJ3L8WWprhREjx4kaXPkPGcEon+n9zJuoVJ/NGemsbztqhueqIz8LPkTRJtPh
	HD7QNGUpYDzHBO3eww1l81+XuXPeBPvXwSX2Jd+l8SnZo+pdErjBJUoEe4ixmBrgu6aWqnnKuCH
	uVolm7VILLwxDpnUQ0+PVEQ8bZ1iiDny/WDQzY7EY9W7XdfZ6kfFWXiNiSQ1O0Shw98NstvfNN8
	vvADkQxh5zlqc7f26K8ZZlT0OnD6WlfdG5wyNf5VZsj+sQKHC3hcmO3YLkrIWThNJHovwMHQfy1
	kHAhbz8gRMdnq+T1WvFV/tMd+3TVVrltzqfPF/5ESWGH1DCi5t8GKDCQYbpbvQKWaihMzFuhCZr
	vY0SPnlphzjn2705iQxtToNhGpc44bUlS4GotcOrBBjDU9zO1GFE11Ni6GTc5Q9WJz6+AbptFEB
	vvsWEXqeiP16v1iJIcXlPPPFg12enfmZjpxVg==
X-Received: by 2002:a17:90b:4ac6:b0:38f:18f9:785 with SMTP id 98e67ed59e1d1-395df13ced5mr45406324a91.8.1787647789251;
        Tue, 25 Aug 2026 01:49:49 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:49:48 -0700 (PDT)
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
Subject: [PATCH v5 12/17] mm/sparse: inline usemap allocation into sparse_init_nid()
Date: Tue, 25 Aug 2026 16:46:03 +0800
Message-ID: <20260825084608.47437-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1pw6jhqkhuyi9uc4z3gf5145igqnrw5t
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4F6EB1C0007
X-HE-Tag: 1787647790-477969
X-HE-Meta: U2FsdGVkX18Q+pe7fBIoZlKJuzm9+KNU6ChaZ5JMC6k1QhordrKXAqOi6U/pJ7QkjgYoaDhV4GKxivTWRdhKZYynIq/69c3D6yxgC0rIg6oMDW2WLzjx8K0blq8B7tloxx2rY2NvtQ2+l3GteMAFQ0F97vWacJGc5sbnqZ79bXZnRak4FpVFEhwb1RM+EwSUbb0tkj2tzrphmisGJ0OXgHnlJtozAu4Hhz9upqo5T6Wxp0zpVVNLF/KoQ8ILwUR497VWdnkSD/aNUEIDLK0yBwnVUz5ozX0gtuSxxxZNStqKV9AwV9BTnWQeA6/B/yLJ2mI0Hgq4cdXlYo+ut1p9YS+YSs8ZGKGr/huMsE/B33MnfSzzJe90ubb/J7FNyvFTrxLwGT3d5mMG8sjLVW4SuOOCoT8yNXPLoDfdXjZ3VDIy4aRaKzQA952sFM3rAhAVWbR07kTMAOwOKcOjswZXGYozlnvWi0jkcZ9pNYs5UCH0wvx3cEj5jHoaQi4qMr3gXzSK7b1LBcvE/sJxFRaBNe139rzPB7EwwE/FgnbYpDS8/UkAktDUMwtJxDZobLxQoC0OCquMUa5XTqrociMSlwQdb3aL1yAOJxzedGYr8j2aiQyQhd4gvqu63aV24XFZs23P7sV0JXJvkfhCIUad9PDeS5nlaX/srhcw0jVUYCGAW6WPF97uYwvcn4p3B7ZV+EVCTCbEPUakxBHk09xbn/xvKLfuDnB/ZkRBFt0JWrMqxwS9z2CxwDgi0StoBkSR18K+q/WzZm2OLT9XTMA2qrz+CFcYPBQrDeY/VZnQspfGl5s5TqpE8tHnJcUM+bc1shAO5EG5GI8Hy9Rfi9IQVdonpLivvK1/SCI3hHQ94PQF27UQx04Coiashmx4z0roEOIu9dCg3hioxQFop6JU6OXe0T5ZO1lGf6exyfsvTEawtc9Qa3fXjcU7W3TmKemdswKCgXbypmpumwsyaCG
 uoE6WLtN
 yXGcEMVJ2LufXgXif+bTWqrErUJ5d/JcuXbGgm7dcx3PyJ8bx/CQ+WaUfldujl6C8JFBWRuNHDXlrQ2xwhgj07bh+KA5SCC8JJPDWUPZzHsWjSLB1EXLyTvxX/8A14EyEwW54E8DLBuTzi5PsVz1122Q7sjDiEXif6KThPi0PUlHyRGjarfaNxK6lTx1MTTIQvIeNpt0nZI4Oav3YuDk7iuj8I/p9831v7u+5VOK9LFx/3roqAIjgLtrxjihMpKgBJfHCPrc/x8W/MSow2P+g8g2lZzf9/3jwrraYixIy6MpcwwsqLacOkbxbZDgIkO5+Tf9dWpX3ahp8VQ12xSy9exMyiyU4qPNBfv/nsBRo3kLwxVeUsw7l3i5D4+578UUqXZexT5jkYyKR98Mfy7g1hSErugOqBlFXyuLTYlKD9jreHBlYJKOsvS3KI0hFPbqMw1FluF6cx9udaHs=
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
index 8bcb522645ba..67c84a8a7258 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2223,9 +2223,6 @@ static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long
 }
 #endif
 
-void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
-			       unsigned long flags);
-
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
 /**
  * pfn_valid - check if there is a valid memory map entry for a PFN
diff --git a/mm/sparse.c b/mm/sparse.c
index 948839621f83..7096d8e13802 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -235,42 +235,6 @@ void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
 
-static void *sparse_usagebuf __initdata;
-static void *sparse_usagebuf_end __initdata;
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
@@ -280,8 +244,11 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
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
@@ -297,9 +264,10 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
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


