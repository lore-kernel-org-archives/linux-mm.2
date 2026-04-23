Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C08F99342
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 07:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A096B0096; Thu, 23 Apr 2026 03:19:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBB3A6B0098; Thu, 23 Apr 2026 03:19:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA426B0099; Thu, 23 Apr 2026 03:19:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAE7E6B0096
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:19:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 899DDC1CE4
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:50 +0000 (UTC)
X-FDA: 84688970940.12.4B7D509
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id A8F8F1A0004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Fz9JxlsY;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776928788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0E6l7+8OUQ4Tga+WuEBz2tFLFSj0y7aaAPGsd1rn1yk=;
	b=bfgpSS/NRuq2C00E043eK3vE95mfywhGRpTQmu/Tv0R34BCAiu6bZAct+URmcQHTFaXu0H
	VUB1wqFWLtd/IOMZ6ePTccD9rePcfdGh1tdAVJJhQ+bdp/3h/SKxe4UJH63sEm3s/qR/9+
	ymFWT5OGXNOQDDJUYgVBXyrWQRp8CTs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Fz9JxlsY;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776928788; a=rsa-sha256;
	cv=none;
	b=uk1BwIlenxYFmPdk/TKSERuBMVg2+J1pDsVMJFiam0NUojBK/DT2ae9g13SizUiv6sVCnd
	dL/tA/YAdI2eiG+hyXy42kw5KgDj7I1BlGBgxp4N760mpWjyVuWIuJVyMDAxhNmfPdycCb
	abF8b4esdgorB5jfWYbVHp/FUNGn+RU=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3585ec417f6so3439049a91.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776928787; x=1777533587; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0E6l7+8OUQ4Tga+WuEBz2tFLFSj0y7aaAPGsd1rn1yk=;
        b=Fz9JxlsYtzZ4MPKuAecZySmSQsNTBLRjoSK+PudHJ3DQbXXijW29s1eil8/aYWq/+w
         JBoxgywkzpbC7u8YJo9UOXIJ2cp6ttxkcVOk6OYUlp7yDETbVdApp3S1rcdLxJCJ8LcK
         radPH4p95CJoR4GQWdPv3qUxXMWZuwuVKTznZk4ZylyB5SzO+ugYC5iGFk+Zt76BDuqO
         /MfRB+5uLL8hfawbFwbhZGwt8XY5PFdD/apkb7CQiPv7Pqc6H4VVYKnP5EGUAPal1xmf
         z2jj/O58WVOPNcZqMvYoSUNV0q18FTCwFvIsQYbE0l9d4qixzRQbISMZGq7Hqn2hro7W
         YC5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776928787; x=1777533587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0E6l7+8OUQ4Tga+WuEBz2tFLFSj0y7aaAPGsd1rn1yk=;
        b=bsy9Svsh/9WtXRnqxBv+XatBE+WXOjEkftlLi3dQMBCAIS93VVHA1wkMP9tCFnO4AT
         K7JCgXU4dTPrxB7srf8BUYPbknaZhCMC7UY+FVh2IlB0UrkNcAASx92QwTTBTPSKpcjM
         JrbrVflnIKa0ctZdHxf2sn//PnRdwJiEGYN+Y4/94IfILh/iDXWeUS/xnor+Ep5t8j+w
         T/NrYz6ajomEWpFrAQpWH87TxjkLnVqbr2c1jrwqfHg5I++nzF6gUmAaujxW2cfhhLIP
         zV8DcGHIRzhhSGxTSZ05VEZznPZCTdl/gjbMRqd+p7HEISdpYjnL4pxf2D5fy8yW7E9V
         AHfw==
X-Forwarded-Encrypted: i=1; AFNElJ+xBsg/lZHN0wue0y7LLMkOKRurM6A7OrI8hdzj+rc4zt44Br00v7x3YyY/QMaKgra1zmoeR7sMTQ==@kvack.org
X-Gm-Message-State: AOJu0YzlzXZg4J6hMRToXp1jKDZ1nltgf3RSfw8oF8OOC1LN6CaqqqEH
	6LFCQH4+BdiMScOjExI1NPAxUjRD/XExyc1JhE3KCKJFgnu8PVY3jDfIzGv8sxp0WRo=
X-Gm-Gg: AeBDieu8ISGUa/yzKypFAgkqOjhgrfmm7eLyvCt8oHNledh3Ue1WNMiVPRo819/weZa
	J7a1i/Bg+jJv4lDWJ5/zZGdy6YXTH4+Ntep8E44nc7b/X4klEc6dkdQeFtv2DacJeS3ON+FIAsA
	uQGx8Sl2cjxJuH4YqoBmi/kRLCQSyMkHcL58xfg86K7J8AiIF/KfvcNpOOWiOwUWek086re9gOq
	sugtHK5LujqThgNg4hrkFXuchQ2W26pmIqhAFwySBw9FKvwaIxTNahijJ7JeOmsgJmu1C96o8gk
	mO7oLuMgb9RQVXQeSo5XffIKaFwKlAWLx+EW2reMfdf6RBkg0ZuKydtJhgoqgnZvMGhrxRCiQDM
	Uq32B8RpihNww0wGQPEZa+svmZw1VQcWRTTEABI/NZT+i+FeXKCzCtCthDB3VIorir3iuskG7IL
	qusQ2QlA3dlSUWWa2EH8MEXNWNaSDLaPqJMqrzT6ri64sVtaOFN0HpgA==
X-Received: by 2002:a17:90b:3ec5:b0:35f:b4c1:91ea with SMTP id 98e67ed59e1d1-361402ee818mr20270410a91.13.1776928787371;
        Thu, 23 Apr 2026 00:19:47 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613fbd970fsm7092372a91.14.2026.04.23.00.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 00:19:46 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
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
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v5 v5 5/6] mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages
Date: Thu, 23 Apr 2026 15:19:10 +0800
Message-Id: <20260423071911.1962859-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260423071911.1962859-1-songmuchun@bytedance.com>
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A8F8F1A0004
X-Stat-Signature: 7ksshroydesddw9wn6c9csany7iw6y3w
X-Rspam-User: 
X-HE-Tag: 1776928788-129511
X-HE-Meta: U2FsdGVkX1/iqd/B6k2Sf22eXatdsdctESEuQSMmsbI48DHJLM2ClALuK/i4pVoJWg3bVJAQGMKyxyhAWDEH+SrMGfVyA9W8tOcyf89zO3f5DQlBRDKmMk8Wqu3ZsDp1C7h4TBgIcyWCCH0UEMQ1ZJRuYDhFNFeYsxzZvhHhDh4EYczFo342lTI09ijM6jeymxQVuTn2XmWH5LaEi/609Oj29Y97p3DHQGuO9U/uTJD2Pj2YYrZmW8A4QYkHQ5xxkqT1Lk38NJTPDiH7SezHo1l6y0wS76jgM6a4fpGYNm1n71LYXOek0lrLhYmEc8sF3/zssX9A9CneQtjd89LchAOD25YuYJiIqpcMvMplaurIvWGWGhmMSPszM0fQZ89fNv9T4644usUphQeX3toterQfDaBBZ+eSwCgOdRS3h5fgySUncljl2vCnDiI2HS5efcW0hUCFIjy9hVkkDCggyXfJmwldF2CgwYB8CW4R45cGfF3D0PGtjA+gsBtQFfsW4s1bYsfpa7dsCWUTlGrOU0x2nhJUWrLJ/eryT/7UkZvLHW/u/VIjoErd/bjXs53CfdQPzVbx/TxiXLSAVWmMYkjBi6urB/5MAWdaQzT8qLJEf5b1hCR4o0vqmB7AV0rDo9B/5G/9Mb4Zw4pGQpdSTfUGC5lM7N8cmQq/m7zGVCFsrmYfzyUNjTJ/zslycl2y7nAoseHdCtcR8rIXrnNzoN6+NIG2CJMSRiJT05IUrj9H0Jxlm5cpc0HhijS1AEz/ijVSVcQA15/NH7xwN9ckLf1w4qYYASaa7dQeDolQ1p/3SDyu1wX5lOrWAZj3y8B4f/nsxHzLol+BBJnjget0NWKCQNkE+inlr6gBoR/OrR2lrYHXb4OvLYJefmR6+JyuNXllXtAS80COAjrIx3TNRdQCcHXD0+uH8RWmA4wnxlsuQd/W7y2NcOsU21S72w58nBkFCHLM5zqmFOsKRaW
 em+3fqU2
 7BvUW0R9ec/vy87xdT//Qu40xEzrllcFQE04vXNSAQBXdCeXbZciwkteS3mBiYe5gyKOJyNcAwCMKiU+dvuQsyLIHGiK/f+V/D+rPOHJaPKUs/RedoiJXq5+R+Ye48yYrxLYF+0tQyelhMjbXEJ6dfhRq/E6fiXhH30kIuvqw63eMfPNQ3EZwOQ899fF6G+gJKTeDeANqL+G3zojygMKklFppALQ0SLUGEQHEG8ZNPcb04ZcjLCmf0W/E6cmxlXgVZrotwqN7gqJ/FASsu51jVBePLCklzPJuPje28qaBVlaJD+yMn9ue6/bzfLQK0jOy84f/qB8ojhBSYl1IuN2xiIjBw8XHlqWw2IUrsKAr2Isgx7s0d4hJX7+iWHY4K+YXuXGk
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

Also remove the stale confusing comment about MEMINIT_HOTPLUG above
the migratetype setting since it is an obsolete relic from commit
966cf44f637e ("mm: defer ZONE_DEVICE page initialization to the point
where we init pgmap") and no longer makes sense here.

Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
---
 mm/mm_init.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..cfc76953e249 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -674,6 +674,20 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
+#ifdef CONFIG_ZONE_DEVICE
+static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
+		unsigned long nr_pages, int migratetype)
+{
+	const unsigned long end = pfn + nr_pages;
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
@@ -1011,21 +1025,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
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
@@ -1122,6 +1121,9 @@ void __ref memmap_init_zone_device(struct zone *zone,
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+
 		if (pfns_per_compound == 1)
 			continue;
 
@@ -1129,6 +1131,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(altmap, pgmap));
 	}
 
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
+
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
 }
-- 
2.20.1


