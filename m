Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8019AF34C45
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E767E6B00AE; Thu, 23 Apr 2026 22:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E00456B00B0; Thu, 23 Apr 2026 22:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEF886B00B1; Thu, 23 Apr 2026 22:56:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B82FF6B00AE
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:56:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6EC88A094A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:25 +0000 (UTC)
X-FDA: 84691935930.06.0A8E74C
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7571BC0007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="DiiA/DWk";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776999383; a=rsa-sha256;
	cv=none;
	b=PL+YHeJ6txMPgvOsQTNCVzPL+1LL5/IgupxXBNZrdXMm+cmSsvpBt3kJAsmbJTvGMDd+YG
	6ezkvZYs5Lt7L5vE+E1OAX28vdw55yrZgd1D5i5q/WLeAUEu+yc5E1mvfpjECGFQvwRDtT
	b8oKxIdZqxQnc0rpTwg4w/QouF57niY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="DiiA/DWk";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X8jAPi1Ug7YtuxDodtBim0VZYTDek6DS5vd5ro+n0/g=;
	b=kEUnWLCMQCxNXziNXs9D37goURL3xzaYbIg4hI4OYsB2EviZVkW4LSUlFXY93Ar2kQDQX0
	hhkH0NVYDIbKuqMh+ly2gL/gar+b8SSNOnU6j9wa+1AaC3UWqnILAbR8vCofS9Z5Xq02Py
	w8rm2tNlGnrZgRasT8InCRvEzvzeDLM=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b2429f98d0so43400035ad.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776999382; x=1777604182; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8jAPi1Ug7YtuxDodtBim0VZYTDek6DS5vd5ro+n0/g=;
        b=DiiA/DWklPRVMdN1lVJWQIcqUydjWfqtoTjo9pKDTTTsA8znEyKg4BwG+xFPRiN1l0
         0tmvnkExWlNmK5my1CDiHeYkAU4HSVkCsmm9ZjdRVi6N2xI8m+8L83aqXENJVYmQNhGq
         Q+yjaSev0OOWP+VgfE1U0zyiXWlYnr+yjMQBNiv5R1SGgkex2x0Yb9GCAHbEuiIIFUCI
         XouzQe8zQ6CRsHcqNv9G4LbBph1dqJ4C6mC0D4O082kK3GXMGA3OFVz2wUwfTrbZZExi
         vNJAqs81T09HgdSIGIvcG8Ras5XRgZfK9++fb1s1cPviLy3O22lhyjyTQJGLmAtg2jTI
         N4HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776999382; x=1777604182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X8jAPi1Ug7YtuxDodtBim0VZYTDek6DS5vd5ro+n0/g=;
        b=aVBwpdHR92nXr8EPLs4oym18GKDUWB4R+y7eHS/MstfZAVjXwchqBEgytpCEcsJonS
         KRGxz5tj4+afmx1WJy661x9q+wlUryRCrroe1BiRr2z1q9ctj9BoQZAVmLyGs691yLJk
         GxVQno4uJiP/nlnnrnLpHrEpQhc+Ffsp6S9klHxh6VIgaSSx3qUf7MznxXcMkT0EQ5aq
         ikp9l7DJwZKiRSpkZfv7FYk8D78aoiCM3rELNXdzlOA9wNkGhwHhbn04ktYW7vjz1r10
         9zf6o7erlZ8z6TPo/imCNNpHAHBI9iZJ7a6hab9HZ6Hxc+zq24iwefsdwLSjNtAWQJMz
         GF3A==
X-Forwarded-Encrypted: i=1; AFNElJ/yylHgLpDeTBF0DXKsPbGGBQ6O4yYpO2DU01k4tm0NH75YsVflFo8YiKYRa/ySjJOtQuSd45Ztkg==@kvack.org
X-Gm-Message-State: AOJu0YxImvAXracXP/UZFnPd2hUAiX5rsTGEDs5fXzVm6yFr1pKVjOk6
	Q45jgPG2SbzUDn4gBI7xXtNMo2u+EqFWRkDMRUO/pEqsNyxqqVFzBWZLKfHGv8LvoEk=
X-Gm-Gg: AeBDieuFI/AGNT5lvRJS8DUW64GazcgHo8sPTMKagsWnuq5efE5+ZlIuTxfV3cQO4jb
	JEB7fqjW6CJtIWXSbBSKSKL/kYhnedZigzjhN206HlEK7Zbvs2JaLt/LG1WflIT+Uyjwhvu46pz
	NRhFIpZaeZTxJBgsWglBtC/7ZhNDIk3hz9ToAcvGwkmKOW0cYEw2AoYu7fQidzQF+3fO3du6UU7
	awESisxexyCiUCBKuAkLNXJOKb3Xdzcj90qV/24IZgRI3ujk5QyLT7x782xbkXPFxWFJuCsmPEb
	HMM7I0g93x7FIpbLeQX3a8xHHBg/LVfnWMU6oPdQOFhL6lsIMVRiGunjcphGI76Uk2ehd6XfJ2T
	oc93waUTHzm0ofzbfH3/c8wlITXynE9kCeKYyS5OgcSDtPb1sYkbHz16mGvzOgCaUSnEF3jjBcG
	JY3wkTKryjjwn9K42NQK9YMOeRYokQVOxmrv/OwqSqtOh+NXK+Fo5j7wU=
X-Received: by 2002:a17:903:1a83:b0:2b0:61c2:8e83 with SMTP id d9443c01a7336-2b5f9f36f53mr299091855ad.20.1776999381981;
        Thu, 23 Apr 2026 19:56:21 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab20d33sm221668325ad.63.2026.04.23.19.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 19:56:21 -0700 (PDT)
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
Subject: [PATCH v6 5/7] mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages
Date: Fri, 24 Apr 2026 10:55:45 +0800
Message-Id: <20260424025547.3806072-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260424025547.3806072-1-songmuchun@bytedance.com>
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7571BC0007
X-Rspamd-Server: rspam12
X-Stat-Signature: ux9dtgiko6xoq4ketbtcrdcxzmo8znwx
X-Rspam-User: 
X-HE-Tag: 1776999383-50350
X-HE-Meta: U2FsdGVkX18byod2I0/Q429gpEkYhAkG3euMVqQShmDUPjEZQNR1b5Witp2z3c9tBscD3UuxTYQbtltXszIx8jcsQHIgST1SO9UW7KEezGh067ClHCSPOjkHf1BVCZY2qzsipqRcJ1oCJYpc1ocChDhWYaRuHu0OxXDQZ38kiUmwvZTGEseMUV/B2ITLX7ZXfoYw3hgqDgx5bc9dvpJEdGfzESpuR21LyaIVB17j59OQUHjoUv5/793Nj10JsnUKaTAFw52eCTX5PMRIpOTxaPCJrSZoYZ2lTMbZmQaHrAUuA5/m1+wZh2Cg96KPhnqwrSA0xfQt3zYW60iY0WZwQiqNp2+L8CdFJ/3I70EwjD3jAplVfk6Jf1MiVM1JRL61YBAzNriDjQUKoKw5KBuz71qB8ojz8B6yYCrHvSN0j8J1YnwYQyFJoH3Er8tjCmwhDNsU+lEPIBQTYpBwkifkXaEKYDyHK7/5gkLHhKTPkpcO0VGQyRZ90ARssZZGRR4JNOwDt/ZG0dGwdtzDA+2sX6V5p/VxdTnatfCl97E8+eKBgFoBYz6GoAcMEElOENDowitRu96YKi5r9VWSpcmuLJQ8QnE/OYzsMv9eOu/wzDMb+71stFmrbtR8TLtuqytm0l3OFWdk+Xvq+iMcolD8QO4ing/rlMTX0GzgY7lvz8NaLv7MlLdAw56Uwn1ZMWfAXlBBP2uGIlzmfxH7kIcMJpsC4CihAdZTIrOaQdV9fhvhUD6NSIVogxVTymBHQqJYoqltaLiyucnpZZXDBx1/XfbLUxIaiRtWuUhSGSHVgVxB8/nMJjra/rG/f5gUADvbSAImCdwFamFGEzVvuZ0ZkL2hyE00AYiT/MwQRPeQlJbajgToJFomZEiPpnJ0B1DwuaPMKt4idiP69OAIy7mi1sGZaiLfNJir40J4RUSqGaOUpu41LMXOPNi63agU7WuP2CpO11d3wcGPToHYC19
 rcTHxVAP
 SPtoQljieFA2KibcRySa5ezQghUh7icrkxPOhOkUSvZJ7V/pS1Bor5Alz6YxVJ0CYgp9shNfIKX8OzZy4JuJoAV8kSrbSdRZ4wzmSzcOk4SEnEUGP39v6387QdDseU1qnNulvlDaZqp0lM2+40jfyV0is0kKOgM9Qk0gZImNnL0faoXmT6g7SCvIbb6I6HChlrXSSxOZx195Znt4BueYoDzU+j9XC9CC/KIf1f5A1foiE5foqMH5WkPbFn/j/uX4aO+SkoG1H2Qtdc0wc1EvLPPKYnnZvgCxNXQtvKtd7suU0oH0jr+lVz9+uIeixu9WvC40k89EWjyxi1CXwbb13pz9BHr50se8Frl3VtVTcaI+OK5gBAWYMOK+RO1W02xr3ONeG
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


