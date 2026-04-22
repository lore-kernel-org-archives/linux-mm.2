Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFD7AF94CDE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 08:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522876B0088; Wed, 22 Apr 2026 04:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3336B0093; Wed, 22 Apr 2026 04:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E92D6B0095; Wed, 22 Apr 2026 04:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7636B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:15:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E11BCE5BD8
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:15:10 +0000 (UTC)
X-FDA: 84685481580.10.F401F41
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id B4E4F140011
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:15:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FGjvnlHS;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776845708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bFvE9gY2jdfvM/7z3bv6AJAQ88eqA1v0Ow6s9f2y7sk=;
	b=jvg4TKy6MzBBvHNnUc4BXU+1cnQQmLuXHs2nRwxg7MpfxiqKpnh46tzcUm+hjMQ8gt5HPC
	+Bl+AGVEn40ShhYWt5A4alw/Eo6PWBl7NyS9O7u88C/1Z3BfEVXIzzkdGiAFxq89x6+z5J
	t296aQXCO9EMh6gN3uMVI1tkeNFTPlo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776845708; a=rsa-sha256;
	cv=none;
	b=X2rZALY+69xfOqFbe7aiO2aSFEOsF/WJFytXEfj3Ltz/f/eZ9JThQSFDBzgS3QcaJ1r1wj
	APoLmAvjBSAYn9dbHqr6Am5+AwYlM+54Jznm36YOKgQlz5IfY6hgL4fU43d1mhu/jpIXma
	4NrB0kw1u83izqFk179cQAngPdmDZ2Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FGjvnlHS;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8296dabef74so4437167b3a.1
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776845707; x=1777450507; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bFvE9gY2jdfvM/7z3bv6AJAQ88eqA1v0Ow6s9f2y7sk=;
        b=FGjvnlHSEpmX/fIyjnGBIFp6nWNWKsLECZg00QxJA3FskkyaG8b0VbkpYq1RZkIJEm
         sgd9TVQBrcn+lQNziNcW+EF4rxKKSq9AH7WVmP3gCqNx4dyezEnnaHE7M0pWbgyySmvq
         BmywD/JGnRMB7dvDqKDaVLGllmYp3faQ+XzLi9EwizeVCGwkK7Z7DthsOIpouduI6GS2
         3yibsnOtppyZkwcXD/7x7Ag/68kXU98/bu5qW7mquZ32ERK+tLwB5nwY2TVBQbohW9dP
         ina5msl+OFd0KtpgFO5841rEJCdlsVgvJLkh9daS0e2W0FbqUiQQ4WIVJHETHuyxZjBh
         EChA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776845707; x=1777450507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bFvE9gY2jdfvM/7z3bv6AJAQ88eqA1v0Ow6s9f2y7sk=;
        b=mkoz6vxoLOk+Hulu9Cf0TfAvOS7AU0BolGFYMC/w+79iS5yK1ct+/hk2dgAqol6eya
         EsFfJsX4f2ee4IOw9Cms4tsRWtOFZYV3o2KDgzBVXelZBj8Z1mkM2fSC8xQP5XzRIauf
         YF415CDRa3DTTIIdcvMzlkyXFg1MDMpo6L323S7n82bk616OrcWehEPAh6rt4csGROlz
         WbqoxyL7U8qNPA8mZFaQAPNsD+K6T2NmyPCoB8ZMiOPolfvDAP3uwdxuBe/FWk91sPpF
         85zSSMviE2KC7RjLLMx7Cciq4YGCXLgRzCWytleuiThzTNVfo3bnck/5vKoXCF8SLCZt
         hijQ==
X-Forwarded-Encrypted: i=1; AFNElJ83UfoBiUuQjYNA+iIu1sXLggF1j23W9pnLCsdkLdAVkAsFPGtZptUhjIjhFFckzWXnP4yEOSA+3g==@kvack.org
X-Gm-Message-State: AOJu0YxoVu831yuwnjdmyCh8ubjlpvudLL61yz+/UVuswFruv2LuDUpu
	ir/qThMcBEaieesI3zYCCoNqj05YHAu2NcOeHlHefLkQR1Jy5lxmofl8ACoEg2sQJGY=
X-Gm-Gg: AeBDiesTgjMS1eFO4YXDQ5utK0xZqvoeZ6iIhKRilcY4lJ8SkhB3fd2nI3KHBtdvIWs
	gfsnTxmIwZJ7+PoT3bI3pxgrS52a3aVb+X1SngqlQhGJXy/XUhUZ71iQMrsVOpw5u6nPCp8Vfy6
	IcMptpc0thvh4yfsB3tBmO4GCDeKl54aTkwb6n8C7Qm+Ap9whcIGtcjlNmb/XN08gzfkqMs+vZQ
	M3OFWaIEHnp2lnoihegvRWnpKxnSkoX/JweoY0vO8Wq2yikX05aY2nOU/vZZgXCOHMXeFlAETH3
	4C7X+c4Wrmfto3e/jtI8bo3xO+ZMLGiEk0fjUe7rkV23+S29d27y7s3uPcNO0eIBqRmL26H+Mgc
	4tzbe28wLr069DcD/8N09OuYtr7cFHu9KazaYE/cYCw+HTIFwbp/GLLMrR5gaUBb8Tz/UuARDD/
	y2U7kmlQ6Wr4A+Gl6aOfEZUHMbMvWz
X-Received: by 2002:a05:6a00:3e16:b0:82f:5571:1a8d with SMTP id d2e1a72fcca58-82f8c8308e0mr22842732b3a.2.1776845706907;
        Wed, 22 Apr 2026 01:15:06 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::34f])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec0307esm16522874b3a.53.2026.04.22.01.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 01:15:06 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/5] mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages
Date: Wed, 22 Apr 2026 16:14:19 +0800
Message-Id: <20260422081420.4009847-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260422081420.4009847-1-songmuchun@bytedance.com>
References: <20260422081420.4009847-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w83ukj5s9idr9p9jw9tbjqpthxoajebu
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B4E4F140011
X-Rspam-User: 
X-HE-Tag: 1776845708-521253
X-HE-Meta: U2FsdGVkX18sd7oiMB/GwyE78pqM4b40bKKQK2robZZk0W8/YRNs58EtYIUpC030j5p9gdqkzPnfFa0UQ7J98NM+3dJy9aHb6IKaEOHjTEjFjQJBs+AcTLXldpO+mRyPxQy5k7dpPRzGwkQwdYldyw8G97utAFfjHdph3i6fk+SbVydZeVWAuBjL4ZeuTK51QlvzWbzBVmBJvvQtpX1uLq9EsZMxjiANIb2Zw4fTFE3408ftnUH8PBRAqqxGd8aKywEVWSl9jXFUmSL3iqM/yFQqpJJXQH5Oxfea1mExHg6k6rZRx+S7QOf4zBipQ/PII+LqOvFllC8+P0b8N/Jzl2/jW7Duohd9Shhk9eWCt16Rc6RQdDXDYT5rksRXr5qKdavdulOqCN6oBuQIEF4wryYLZelR4Chq3YSUfeDR2qdy0va9Jt0WJaEUwaZAuQSZP49N8mz+87KrueztzD6ugYNuFgE403c8EE4YfraNaLQsSbYXX1Pwpnw98DlXddqtPF5ZuoYC6lIgIeEMawMuiHS/VmdCMHRaAHuoAZhM3pafazTQP+or3J7xc1E+F7WPDpxVHm39+7p0KhieuqupLlv6OmyulFCy6XFO7KjA14wqBGJNEWUUqvicwSGZ32h2YPse35BxnIHsCnvTLhlm38Sbux1zE22F3NefLNVvKrx1bochFzqx+qLi93GG7ibmYaJ5qrIqzT5+OSaOOM+R8TjJ44eO4pBL3KW78j5lsaQgYjeP61NMXzCD6KbdYxJKdI76q0DsTXawJaQ+H2m/LwbS5oBAMtdYsb8SIQJD48jnpVgz29aQ+C7ZP9N7uuwPk02Sr3XD7lz3O/TFhXPs03Ef/efjpTCUh40heBk9elvlPhBAvwqbgEXb4R9G3hzKHwybMgWAosYM2mZV8XPYdRAOTpwHkqwKQCA1cvId3Kgarr0M05XzVhhWklBIomcYJS4Q+Vu11ioKNqIm5+E
 2bn3EC2x
 6ESUU5Zcxi/WZQyAiA3UYxAhiHDW7jKhzzNV4PSRsA1jIlcZ3HDHkMqiJqQyGD+BzZmNvHKu/t4SsgxhwaBu9OClbmRm1INKIm9DlH6YDd0nhO06yNfuoIvVF3j2hQkAmElaZ2m5zKbHVBuehOPfK16Dqvtyl+pu/+CBwE5gilowAT2rV9Ft+k6hajRhorijnBKzPUyxtjd3CD9xFkNrB+9WuufLlxhiZU0FmuuPAlut+j/r7txMmtrBRQctHOO1nJXprU0FJvsHPlc6EZqui74Ae3JAVqY1Tk22iMOZoiFN5+zRG15x3PvuHRV9rio/agad1YFFv6KkxvtXBvsuy5NmxZ3hBMeayCO9G3B5e/FFhQo96/5C4yiqZlAu8QNfr0Uaa3rPOCHgZ+Gg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memmap_init_zone_device() function only initializes the migratetype
of the first pageblock of a compound page. If the compound page size
exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
subsequent pageblocks in the compound page remain uninitialized.

Move the migratetype initialization out of __init_zone_device_page()
and into a separate pageblock_migratetype_init_range() function. This
iterates over the entire PFN range of the memory, ensuring that all
pageblocks are correctly initialized.

Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
---
 mm/mm_init.c | 45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..9d0fe79a94de 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -674,6 +674,21 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
+#ifdef CONFIG_ZONE_DEVICE
+static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
+						       unsigned long nr_pages,
+						       int migratetype)
+{
+	unsigned long end = pfn + nr_pages;
+
+	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
+		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+	}
+}
+#endif
+
 /*
  * Initialize a reserved page unconditionally, finding its zone first.
  */
@@ -1011,21 +1026,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	page_folio(page)->pgmap = pgmap;
 	page->zone_device_data = NULL;
 
-	/*
-	 * Mark the block movable so that blocks are reserved for
-	 * movable at startup. This will force kernel allocations
-	 * to reserve their blocks rather than leaking throughout
-	 * the address space during boot when many long-lived
-	 * kernel allocations are made.
-	 *
-	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
-	 * because this is done early in section_activate()
-	 */
-	if (pageblock_aligned(pfn)) {
-		init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
-		cond_resched();
-	}
-
 	/*
 	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
 	 * directly to the driver page allocator which will set the page count
@@ -1122,6 +1122,9 @@ void __ref memmap_init_zone_device(struct zone *zone,
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+
 		if (pfns_per_compound == 1)
 			continue;
 
@@ -1129,6 +1132,18 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(altmap, pgmap));
 	}
 
+	/*
+	 * Mark the block movable so that blocks are reserved for
+	 * movable at startup. This will force kernel allocations
+	 * to reserve their blocks rather than leaking throughout
+	 * the address space during boot when many long-lived
+	 * kernel allocations are made.
+	 *
+	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
+	 * because this is done early in section_activate()
+	 */
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
+
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
 }
-- 
2.20.1


