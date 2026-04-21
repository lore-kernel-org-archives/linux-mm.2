Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E3D7F5A8D1
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 02:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F14966B0093; Mon, 20 Apr 2026 22:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEC996B0095; Mon, 20 Apr 2026 22:21:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29806B0096; Mon, 20 Apr 2026 22:21:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7C776B0093
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 22:21:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3DC7BCDB3
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:21:32 +0000 (UTC)
X-FDA: 84680961624.02.37C37A2
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id C82AB16000B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:21:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UebpGI8V;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776738090; a=rsa-sha256;
	cv=none;
	b=1UBNjYlm9zPyAQfkv9Sj2apjZFSi/QK+76iWvf/DycDONHGpPb5g6/489MeMuOxIAR6RaK
	p2jTLbO8aQ5GYrSmfSMJ4XDUIYIzmMIQBAHqG2bXG0Q5tz/5d+wgr4v5QI2qWOk3QIe1xh
	6HbDKRdKx/xd3eR8euR8KAGpIjcDXfo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UebpGI8V;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776738090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AHmsLfWP4VqB6EidVCtZitT2oU+Ddzspq2XDJx69+hM=;
	b=lvvSsNa/Y/0vmUP29TBwG3rk7xHsQyaGIWKEZ48CUxBQbZwrop11MdNXCdhTzUieuDt3i4
	dDEs9GdrwqYtGpHc59zMjvrGkqKK0eEfNTWpk5+RHlhT6/IntiGfuKyMwzQw7iz5gDD8mE
	EuPaEbb8WUqUztAvBaLVMujcPCMAe2c=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82418b0178cso2274811b3a.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776738090; x=1777342890; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AHmsLfWP4VqB6EidVCtZitT2oU+Ddzspq2XDJx69+hM=;
        b=UebpGI8VggpQBFqmla0VsX0n4IHoe4rVY5KOItIzEv1JzS3Grs9QzFSktkDcHpYiGt
         MwiWL/9u4cQVbb5fIZ+HG3OrlJC4cM2w0+0dG1nNl20U+IE7uqgRvRL+IGnFk/I9IoPZ
         slb0PJ61DEDYmKV45c4y6qu2y4iBAa62B51fh5BUQIZ864wZ8o8R0T1u/g/+mXqm2Lsx
         jUs2vuGrK7XHK7JtcsJiTjN+FJNRtS3nQrrzjAu+lYSTJnmoFZjOrEGufEHKK0kklxvp
         //e3g9SLFipTalOAS0KpZ3LX//+zRYETuogVbC2khaPXnrdV6+k8JdgMOBd05UJsY33t
         efLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776738090; x=1777342890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AHmsLfWP4VqB6EidVCtZitT2oU+Ddzspq2XDJx69+hM=;
        b=RMGRjsbOQ7gczTjmI8kQSFCkcy8DmRSHqqXNRTwQnglNDdkTqmP0/F0zikt1BuiZTZ
         Pj02QXLKUkibQTl76fb9zQEjkxdOqnlnSDv6HqBYs4iwDULgxPuY5vn0Va1RFzJCIYUl
         bwTN1NGS51Ea4DQd4UHUyCeq94p9w8qPwx8YJ7Mv+8SKltVGmc4Gznru4HROHUMtlPT7
         i3WeCfAyYRAT8rPyNTcYPrmt2hccHAN+FQL1v88ycdMSAYF9sC1+BkS2vBOqTp5xbNkW
         MHL1YYUdumSicDpMgulh4XRd3srsD0RfPjE/6azO3Q5Z0F/V33cMgodT3z0AjGH3TcdW
         PeyQ==
X-Forwarded-Encrypted: i=1; AFNElJ9XNa+qfp8LsYC43WKdu9P+4MZzCYsDU2H8tvWz7gI5RePeCnkaBQ5H+gbrb/pdk9IFbk8vupI1AA==@kvack.org
X-Gm-Message-State: AOJu0Yw6yUggIDQWXqUlDG8V2GzRu6MKfYCQq3nhqQj1xkyBzuuvpFZ5
	8MvLkVXQ4bIXsvwos/37ZWFL8cKV2uJ82zMPQOndvOc+jqMxsjHwBODiPfIACSoheSo=
X-Gm-Gg: AeBDieuREkMnsO5zuIqYMIpalKxpWOQBB8eGqUBP7Fwv/b1ZRFqhVOLOCv1NvkKAHFQ
	lxu4+gYJxvtIfz/0Z9ntkD0BA53apK0l1kSmwHrqdQ9pBlwY8t08kRcbJT+k24mjz50v9ftVGYd
	rQXFcCNgFQ4SW8JF5rFo6/6tARvs4urerCMwcOnJcieTheMRNjeDBWb6dSN4xIGoIOhvx6HvzlI
	oWmgO9jkSMvJlcMEvj/Z57hTbSdDS2EcipZpWhc+Uk9B/ANvs/m2fgaCPcRusRdILSlSBSULK/0
	rArWkNDW5VHdl4iY7Y7STN89vmSzgJUCZMxnL99QxFtttea8JQu7KLD/zu39EKtIRpOUY2Od8ZC
	47DpkWJ6FFtQBBiEmxXLRIKqC8oI/Ha5BJKd2LHL8kVqaWauwnHHCzDJR7ilRT752BtKZa/k/cA
	56wDxzQL+mWiuiJkl5aDEG58gtCgPtMJD8+yiR4IA=
X-Received: by 2002:a05:6a00:2993:b0:82a:6461:6d1e with SMTP id d2e1a72fcca58-82f8c92a5fbmr15190526b3a.46.1776738089510;
        Mon, 20 Apr 2026 19:21:29 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::340])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f932dabd4sm11538780b3a.51.2026.04.20.19.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 19:21:29 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages
Date: Tue, 21 Apr 2026 10:20:44 +0800
Message-Id: <20260421022044.1217503-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260421022044.1217503-1-songmuchun@bytedance.com>
References: <20260421022044.1217503-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C82AB16000B
X-Rspamd-Server: rspam12
X-Stat-Signature: qtbrtiqdixrgg313p4bjxmgs58wo4ina
X-Rspam-User: 
X-HE-Tag: 1776738090-858371
X-HE-Meta: U2FsdGVkX1+WIwyoUC99Oix6f4NcNoWpy7DXm18+4zkJs0x/S3qBvU3VecgqIE2z5jFOOIdxqpcuFvBkzCTpHCamXmVrQLJD5YLO9JjqDPxoXo6GtuU6y21ayAByrcCIfyIWhuvFWCohYNqjIaNW9VbFTijefVrWf+raViygKIOOAqRmdxH2X66vjxDVwwrl+UiPqDuY+GUx9Tw4US1FLn6qJoyZyc82j/s57oIydn+sCGaDXa53WjXPlBOGH09q0jmgonNEi0nFY/3PsTSrMXRRnup/XBc4XyCvnFskC4VM63aclaJMssXBavfFgk1Tnx/6u2bWzQRsEIUEYxISmjygdor/VAv8LlxnZn9K1TmFhp0aps+m720di0reKp0KMsBzNIEFCIZi5dBHjCfRuQwibNFZv2dn5xGc1yT4dijuF6GoXSh+H+aMVgSKQkvbmDO9L+eRWkDOL7n/IE4YTc7elL8Pkl7ar07s/Al1JU4lfrBMowca1vupHuu3QA4KExvZDyW2JfUMIauy+u0X0zmEx/elBi+grDZ7a+mAfld1F7Z3R+prAeiJ3bGrFE1aNVtlVcxjdBM/FMJDzzqY7jswKsgfEiwNawY11PH9yEm9UBCSpNALZCYRGHy+hpK+3iTZ3Jo8YWuuyg+jZOyRGZLqIzrwEEjAXLzPneTWYusMe5i3yRyqU5QjUHgfmoiAfBd1aRLMfKNhxJWQ72qt+xKJmI+V17cB4VuDvYII9qtEsrnj1WNj6zvUbTHzWsFeqWvl2HosHwQTfmnwJFYaIlB9YJb0m2F92qgHMYcDH3aleABn8DMwzrpy3jC5eVN/8SfFuycdRJ/Gpf9vxTTL1I9+kJl/n/3ph3+wuNvtjlPQUmn9Boa9nl60ASIULfD96vJthohg/3IMlamIvQL8POx9wLCTHQYWYMr4JIMB+DJgXvqpz0Ha04H52UHp//wtXd9T0gagKLLp0vOtYUe
 IPlbmTYG
 2+ACrXVZEKbXrppmy3hPP00wEUAtU16rZGjgEcOqldZycb//twA3Xx01g9b27DYekcjBSR7xa89SPOf2NMY5S93Dw5+zp3UBxdV3kYY3ot5cl4PEwVrMXNZTVlgPQ50DYYx5jv8fYholD7/AEVg306Iz6I9C8T70ZgG1haIfAaGi97mVl20C8bbXJ2166vd1Tys/y3ET7SGaoxlf1J5ZKWv6EWupUO5ukvqWvVKDQeWvUTfpK1PSjeiLl4twV3b1rhbIi4h2BWJF/Ezoi7Rr8IB40gI1XiY7U8AMl6W2fjM3xb2lXjcRPvTe+YfwjCDRWm/dDniVDTehMAqr5OO2qViARTO0/5isQRp5HRTMZGdQZO7jLnKKMdcSg1zYn9O6yuSopbpEvSfysJNMtJRCklOyDD1Kxn32Vx00YvFJcCoIedJlB+pfrJC09MDBHyUNJUKVPqQq5snZqqAFZSSha192DzcM/BU10v3gi
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
---
 mm/mm_init.c | 43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..e2d8eae23aa3 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -674,6 +674,19 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
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
+
 /*
  * Initialize a reserved page unconditionally, finding its zone first.
  */
@@ -1011,21 +1024,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
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
@@ -1122,6 +1120,9 @@ void __ref memmap_init_zone_device(struct zone *zone,
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+
 		if (pfns_per_compound == 1)
 			continue;
 
@@ -1129,6 +1130,18 @@ void __ref memmap_init_zone_device(struct zone *zone,
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


