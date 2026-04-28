Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37670FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4B086B008A; Tue, 28 Apr 2026 04:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22756B0096; Tue, 28 Apr 2026 04:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95FCD6B0098; Tue, 28 Apr 2026 04:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8616B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:19:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CB721404E3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:19:34 +0000 (UTC)
X-FDA: 84707265468.06.8B82821
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7A7ABC000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:19:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ax0slnav;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777364372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8jAPi1Ug7YtuxDodtBim0VZYTDek6DS5vd5ro+n0/g=;
	b=RBmIJ0FY9EdpPopr7bY9jblnEPwmYJ93OvE5dtKBnYyiJkRB5U/HOP6CfpGwK6o+b3Vstu
	3ak19L3N+Kwp36xQW3FPGpyFYUu69prS1whkG1GfzdQnXpPYDPtuKlV26LsIQxRcrIWa4e
	z1N3XLQXprGwyTArRnY2fcEVkOvLEBQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777364372; a=rsa-sha256;
	cv=none;
	b=kr1MbGrmmiHyTdSJ4shqZPY2qnTpn9PuYDVf2OOmPtjMDXemSm7mC6zjmXM+0qTTPuSd2K
	PJWeGKD4t8EIXVxIqBKqnW/jwsvCp4caWgP7dI3oZNriJ1Jr1LOVlyX/1Apq2qhQ3q83O7
	f8xQYn11DQDupwt3+DDEWy7B75Wor5g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ax0slnav;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-362e30526f8so2065111a91.3
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777364371; x=1777969171; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8jAPi1Ug7YtuxDodtBim0VZYTDek6DS5vd5ro+n0/g=;
        b=Ax0slnavy8bumLmkMpGVb/snWdsyF8g96G8wXRvOuh2Cj80IdHohjeZ+NJXC697XuP
         MpMshY0LWFatMhYP/HQzQjMc5c+mIJ03hg+c/I7daQ+4/bDl+B+LY5M/dUHv1ej1wkv1
         T6xV1JVG1+qAKvgfnBqmmJiLnt96gfzwvuXmegKDV4mntqVee+QSjb2jCy57W+kd/rwp
         fvB9fOZMzlYe2kdwbrJdtMd6QMUriwkvw0T7AM0E1qgHoQ2noF2VaWdTg4cZFhb+wvLw
         Fb+CvA54JNAJByHSiEsTrNLA6DguZWXTZ81Iyf3lUqXq/OfP446rFagKRAgsG5yANy7Z
         WIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777364371; x=1777969171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X8jAPi1Ug7YtuxDodtBim0VZYTDek6DS5vd5ro+n0/g=;
        b=hQQArDxW+Ci+MF/wUv6RwelYsXauNDluOliYzgbd2+0j4pd/xPOWi2j2q3zB7giXBC
         /3WC9xNrW1HEFR7wleRbTysyEVBbtOCN4kZ1ROanLGG9suerWAYf3Rcz61Nlhd6npbH7
         mGN6YIkG0428IjRvH+zDkcHugSNjJKo0tCtqV3SbRug6XfXEoXJpmYLG9bmWFotmfEUX
         TDlMM4DhSsE089MfW2qMLuEKayX8TL8yASdUOs7A5laaYQ3DCi+ttPGFMiveM2+u79UA
         t/RjPZUDEs+b4bxZOGFipI/7StQKJSFaVqirxrWKnIooPuvAG+yDv4R6j9qsKxrIZnNn
         5x4Q==
X-Forwarded-Encrypted: i=1; AFNElJ+adacqoTF1KdWOh/GfmaY9JwKwVO+fSiJXAj5/mXuNZ6ZITcuivx5TvJzlPTGm1nsvZQC8bKvITQ==@kvack.org
X-Gm-Message-State: AOJu0YyAXOdD3c0gwngLZeM/bBwjyR3LDWXocawNR7zWP2mWt8hS9eIr
	A1lzSPd1I4OWxHSTkd3115LECi143JE50gWf28Q8IoRKcQgq2S2E31GPikCwXYCs8f4=
X-Gm-Gg: AeBDiesNULV4GnHy7zyLyqyLT1TYmAIpS/ONIUOKUbqgD3f9I5XskNSgBVTTQtHOKY0
	SeODuhhsxA4Rte18OlBzwcRYaQgqrUTVcQ1A+VjGwVbNKIawVWvJXcvAimLjA5TCaabjoemQp8J
	5R1zoBrITf2S1aHYmwFpB4hba9mLRSFZJOPxcyh3Xhn06sUTLhch5Fxawm9UW9pWUdExrrB6Knr
	74tsWESWUoSnjKOaJNhMCYS7NS4/MiSzaZGQa9J+nmKTgZqEo/iHr6SZP42p9V1rZU/A+SAbnIR
	syWqx5+IAnTbDf/8cubvp77iMEY4YcMWthShW/t8UlZEql7fO+6TFfN7tI00FE3IL9GqXf9asAC
	E0Bb8HBY0A4HvfgdBATXe3es+AnitJ+cFGnf5JiO4GqEnba2Gz+YxwKBrr3Y/50RYHogOE3Y4va
	7K/9485+20Ix/Plpoxqc9W3uCsCoH8m0QY3VGvWQjc+v0u1rR84UUEB9c=
X-Received: by 2002:a17:90b:17c1:b0:35d:a3b4:2ef6 with SMTP id 98e67ed59e1d1-364920601f9mr2483211a91.21.1777364371205;
        Tue, 28 Apr 2026 01:19:31 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3649003650esm2181356a91.8.2026.04.28.01.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 01:19:30 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v8 5/6] mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages
Date: Tue, 28 Apr 2026 16:18:54 +0800
Message-Id: <20260428081855.1249045-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260428081855.1249045-1-songmuchun@bytedance.com>
References: <20260428081855.1249045-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7A7ABC000C
X-Rspam-User: 
X-Stat-Signature: 8ux3mro6z41g3myzdho5dchoja743gst
X-HE-Tag: 1777364372-950732
X-HE-Meta: U2FsdGVkX1/B3v/FKU7K/2jdwuIN/Ahu2zrybMrngLfWcmcYQJRSy/Ma7LJ0crJzO4KW+qdoLT/lTGF2S+t9HIqifqLOAl5HOHoslVhX1vQRb32wUvBvYpuSu6bRrTtRkaLk5uJXXqESllu30eCPPTwkMPtddX4qtPnVEi7BsZvjhwvSRXLmGORvC5mwDJjwjc7rRdGMRYzrDjIIcy7EzAo8fySKeSo/nPPA5GnRRDKYePaFp4fWCGdEftDS+c8liEiMKyQUJ/Mrr9Rm74y5xcnQuaNcTquBFSxWtuL1f2lBU3+AMduzx6w39F5ZMA64WydIOfF+R55qULCw83l+6b6cA5S2rrRy0vAePSs70un+60mzpbLkxPW/g8FQcRCZw1xCtPvb0wD0NK3t1iovuSQ9zc3Pl5D5MQqLXtHVzKLHn1wvsisutV2Aj4TMfFEmvyadaJRX+pdEfFzwxI+pYFzazvaEncWrJHriSHBt45oheyygs1IGtf9Qz9GCAA2u0nOjKBIVtxnpcmCF0VOSHpEojz5oYKL7on6zkAHKiRLi4/YBocCR3GShyCDBGT4VgLkE4m1sEr7SaQHL2L80+BytsdQN7TumF448UoEAtTo6N5W09fEAHSeCD2j/DsaegOrjTCL29g/bikLe9vXU78a0XAZetWBKHhb4urmjODsgTmKxcXKKJy5UMeWe0XXQRJzzoM+eKBKz7osqENGs2JiRsxQPwai3ohAU+dLpcuzRYeValm+IKknbk4+Toml1Xftc00PzUiBQXWj63EydWAT0BOAnK8nYFchR8hrw4Hy0lziBVGVSBsa3dSBBQ73BDdJkZRo7Yp6uc2GpGidp19KWKOpMssqxj/cKQJGcBBr/NGEXGRTajNNSB+zKgrTxjkmwoYGQSoZA4A9ymXMJ0QZiqrf+yDX9O+UeAC7uxbxEauI+6BbfwXq0RYYlT+UFJCMIXzpsCGE27N2Rypr
 vGielJol
 a0ongJiPKRFOrbjr1qOi5TeezH6oMdfHO1SKAp5a94ohB1XIukzhVLFFXGiSDR7XbrVku54O2B6eY/t6WE4oXSCDSW+HJQPz+IRNV8ugIHjAmnLPOIMROq34mThDRlBIAE+Xe/MfuXwHtAzJYGd4Bk9tnmlcXRD/A3lkjHzfRxdFnNU1dOnFSND4UpVc0z67DI+V1iHtnCVuV8qbyj3GJ1/4YxsGJbK/GEJc/pDqJfF06eKJRxPFtSF/BlasUVe2FKg3IcAsgErOJnO0KcUVGkS+bO71JcZYZsDWb4UgqRvQGHsMXrXZjyeQrMQ3ro1nPJiGRKueDp+sJBOZxq4BdnkPEu16/QSg1JRP7qs+w7ji1sr/Dm0V7rf81gDoFG1UJP/Oy
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
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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


