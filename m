Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85F53C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C0236B00B0; Thu, 10 Sep 2026 02:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94AD06B00B1; Thu, 10 Sep 2026 02:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 811D86B00B2; Thu, 10 Sep 2026 02:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF066B00B0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:34:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E61748040E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:25 +0000 (UTC)
X-FDA: 85196888490.11.58A8554
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 14600C0004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="WWB+hiC/";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="WWB+hiC/";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022064;
	b=t5lo2AXc4Ft2QF7tSPSwbYk8q/qNAfrYc92dujtvJ/mfsefn3lWXGC/UgTJbyqeile3bIs
	IQd1XZ43GQQPLvf6DvZs/9hZ7qHz+7jHnRJ9q5gyzjo7DUt2vj0anfnWxGXusjWUJDFQ3o
	45Mr1MpssM3zHWzf9gPPHf29U0HQvnc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXG9/IxdCoEJBswfQ8yvwYsfNZpsrq28j+tV3JTmESo=;
	b=iXybfs2Et+QtY8qCHSrObk4Joawe+ghvGWIrbOS2Gz2PVZZc7GSDCmxkhUMTz4Dg+g7G1E
	nOp0/Os3aDdRGSFYi+SGXGwBDCipcwVyhvRiWfazDG28enEGwL5sEcQV31I9LvXjrPFNCU
	GdvvD2i8731OEINZyB4GmqnzXLhrQRc=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-39b9a99469fso2647241a91.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022063; x=1789626863; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iXG9/IxdCoEJBswfQ8yvwYsfNZpsrq28j+tV3JTmESo=;
        b=WWB+hiC/a26D8E4Rj5ctiNLmIt7pLM5FrV7Sc4mIqU9R4MMBd/qsyzhMHkZg0rIv7m
         /AAg2wsLCFj/BVHX2o8/9HgOVH6fxH+8XsCt46dg6vtLUeC4v4UIf9uG3lYReIDfNyjt
         p8RJwlwcmR+AjihhTvc3ySxURX1JoWU8xYYJ1irU72frCe7y1nzXttCsllnjB4pUmKiS
         kWKN8MUfR9MYVQ/J+elxgKJYYg+QEGv11lfWNcuyzOFBIvSDIZLIhXl3+Zm5iufYNZHN
         ibfxVPGeRwqgQao0HbMlCZPVfJPI2YhCkNKnAVXc5aACLdMYFHm+njVdlWPjlrR7RmuU
         pUNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022063; x=1789626863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iXG9/IxdCoEJBswfQ8yvwYsfNZpsrq28j+tV3JTmESo=;
        b=ZdkpQ7Yl7mCT05lJVLFmp0dwz3gWfqcaqYktzCjyjijLvbzYYs1WQ4Er7GJ1ww7fdL
         ibg5mQ1eRbB6zn7md0xzGgcSoCMhIYqtLlu0wItnbKA8/tDeMlklSuvWEZtG1E3AIh4s
         XhLwfj2CqdElu4uxOEs9Ay6JrZZbqaSXi8Z47DBDIQPBn8z+cDWwnSmXGPSwj1SLlKc8
         oXWMpiV74GNssBSp63BlP5yV9dsnvS6ZQMnnBBdk1oilR2D+iiT8w/QFkMAGvclWbz4x
         jUMByJeHzgP+XWjgwkrX8o2CVgD6tos4cvtDr925tSLlreDY1Vy08mjd7O3aBfTZxrOJ
         n3GQ==
X-Forwarded-Encrypted: i=1; AKwUvByWUL/puP+UgMax+vFbxpVJvX/xGcvcNQ7NYoVgV7Ty5bsUpBGj5icTqnZD4X7jH88BnDf8WMVcfQ==@kvack.org
X-Gm-Message-State: AFuF++ngDSj2bGszvS0JSFrjLbxoH1kYILg8udMyDRpo4TxOh129MHCv
	CIJARk9MbemtskxJE2blB0KKVjnM/1XI9XwLpYTwZq/x+emIte1LYgo8Ej+lSicOHyc=
X-Gm-Gg: AYBFou3t0b8SRl0xesvwK1A0b3IWbLnxkVPlBNWpNL5wMJAs7zK6pq6LEjuZRIHKwa2
	7SQNwfbW+o7pxSeqpbxox/Z1U7iU01vZlsexKpK1mE0qWCBsq4MIK2kua+Jk4qckyP4xpKu9t5u
	GSv1VhPNfzIAaOS84vhg5k4Y+44cmvEPKGVMZXixNcGxCcSuZXBFuk00txIx1PGVzBcVJXEkQ76
	z7sGCfbQadJa/mhk6PzJWAMhXZ5xNbxbnWLVVYxUacZCBJLJNOb5AyDOKv+6LkU1wylykumRVOj
	FzJpCwzHW4U1gSL53+KNNtwWCUbFqARNVfHg3lTonf2x7TmGvQXFcSLFt3AdD1QyPE4ehFEECIz
	V66ILnkBerqSsrxB5t095X12g5IQj5dlAoG5+vp0ICIsqKN0BL1qhRaV8rNpynilE56fnAVXAAj
	4ZAt5yNDjky23++TO7Tzs11p9qbHn2UruGUygr1rO0hufjiDWKsgd+UU7/dk7owt+AMbVD5BOtS
	OdDfS3qOvZMRiiGyZL8kortSZ/JXlYw1ys=
X-Received: by 2002:a17:90b:3b8d:b0:398:b426:ca4b with SMTP id 98e67ed59e1d1-39b2624f10amr58077953a91.22.1789022062790;
        Wed, 09 Sep 2026 23:34:22 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.34.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:34:22 -0700 (PDT)
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
Subject: [PATCH v6 15/17] mm/hugetlb: remove HUGE_BOOTMEM_CMA
Date: Thu, 10 Sep 2026 14:32:54 +0800
Message-ID: <20260910063256.64386-16-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 14600C0004
X-Stat-Signature: 93meyasykhj3mtccuo6ykicxtmeijyci
X-Rspamd-Server: rspam01
X-HE-Tag: 1789022063-930783
X-HE-Meta: U2FsdGVkX1/f+kgNmnK9E8iW+9jiMzcgAM2347YyO4K4MdkM6sdNT7t6l9dRKOIqrTZfVYhmV+vIYJU6VXspEuo/SLPN/ovGZQvyHFsQASzupl+sU+sdAACyR1qVIBRxgkvLTKRum3b7QHWOBZ9zgPeVAqLFyWbSxycGIY3wZe67FxKCc4e8sHkBqHRkkn0pCfHDOoYUajXfJ2vviGWTPHdSTZny6fCVue5l+yXF8haX3gFPV8BKF8D0z2Xu2AXnv1psF+gBEFucIy3G5MmterP7YMbyjnQ34jc/J06lbekULc2Izf+F72wj4Q+aEwjIbmVG776ZE7AAhyjKN4Rcn4MPY4XUyB6qGCJcGRuZkW3tGgmdr914ob5sLmfLl9M0rxxq2pKqIIVSFz8tXEMoGITGMKeOn1dc3aT+OJHnb5ZwOAnwWPB52fvpZx6BtH5aDdgtvvcd0LHw6P3kWCGlCp71rFTFG0tykM1lV1AMjRixokZQSXWDOGqHfsm6iqAZq/FuOFPW5dhNH7Uh1t3UYmeBm2uOAcITlq7BQOuYn1v+GWHfyezDTxQUsx4jN8CyVzEeoW8UTMkirK3rKgc426QtnL6Wob5gDg2thG/6KY4JQawf1fLNcNBZq5tYNFlfXyVw8Kg8QiqhLhfghLm5udH+o8NpGLja51n6bMaw0neISRqdJGAwTfRaPDTZaWAWTcH5PRUIVmWPgF9PMZYpPVr/7HCkauoyWqOC++OCJYf1tP0aTChqDJjtpIDdv4bAT1Ppe97Drvp5oEkGUaY0Yluuu3rI8AcNbD0lHCv77kN0cvSkQ9g/i2F5QE3ld2VhKblZqkaazR4YkQ+DEQnOP7k8uWSqr83A/cDVcTIL/l1i0ACOqEldluNmNqkqZ1RXH3D3DeV50tCvz080AkyquoXo133/HeQs9ih0TJKei60J6VciYxdmcwr8g9kiZZ/ztplE2KUfDMgwchsjYWJ
 hYofeVLk
 s0BJxXpuNjK0ZmULx8Ze0JitCzQxNHuq0jIKMYZvdSFghsN9zrjy+M68DOPu1fQX+w2cvVI1DNaYmUoQzU6BDa7m9AJR4KGIA+b8xF38k6XzwgcMmWcp3hV6/CB0fP/o2NziyTFKgTUZ9M6aTTNl+4wQoZaQ1rk7oFkE6g46AH4Dl4Rerv4grmbxRMuF4boD+q0yo9njIfivqL2JKT0k1jsgskTdXKmsBy37+PpEs1D7PhpTB6qf/39jtCNxNEvhxgv61WnbHVVvFyWraiJqSt639mkgqRaI54judHe/DwVgVImch+OTCd34ocvs/8zvyO8LwYrirEYx3jEQ8+CG9OhapkiSzs52rijURUFDqmm5CeviofPPqI6qqgBeaaPlkYtOUkXN4hLqmNust5vaKpusAzrKf4WUSbUqB3ejBchMvKQWNcpLv0sDe0HOepUByhtAG9SH5U4I2YEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track early CMA hugetlb pages from the hstate instead of storing a
redundant bootmem flag. This removes the unused helper and keeps the
bootmem metadata minimal.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Collect Acked-by from Qi Zheng

v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/hugetlb.h |  1 -
 mm/hugetlb.c            | 14 ++++----------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 3559041a5a57..255a258f11d1 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -676,7 +676,6 @@ struct hstate {
 };
 
 #define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
-#define HUGE_BOOTMEM_CMA		BIT(1)
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index fbc2ecafef9e..f9b609b84509 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3144,7 +3144,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	 */
 	INIT_LIST_HEAD(&m->list);
 	m->hstate = h;
-	m->flags = hugetlb_early_cma(h) ? HUGE_BOOTMEM_CMA : 0;
+	m->flags = 0;
 
 	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
 	if (!hugetlb_early_cma(h) &&
@@ -3220,11 +3220,6 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
-static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_CMA;
-}
-
 /*
  * memblock-allocated pageblocks might not have the migrate type set
  * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
@@ -3316,9 +3311,6 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_compound_order_range(pfn, folio_nr_pages(folio), 0);
 
-		if (hugetlb_bootmem_page_earlycma(m))
-			folio_set_hugetlb_cma(folio);
-
 		list_add(&folio->lru, &folio_list);
 
 		/*
@@ -3329,7 +3321,9 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		 * For CMA pages, this is done in init_cma_pageblock
 		 * (via hugetlb_bootmem_init_migratetype), so skip it here.
 		 */
-		if (!folio_test_hugetlb_cma(folio))
+		if (hugetlb_early_cma(h))
+			folio_set_hugetlb_cma(folio);
+		else
 			adjust_managed_page_count(page, pages_per_huge_page(h));
 		cond_resched();
 	}
-- 
2.54.0


