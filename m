Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9520EC55172
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4A906B00B4; Mon,  3 Aug 2026 23:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22596B00B6; Mon,  3 Aug 2026 23:56:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911986B00B7; Mon,  3 Aug 2026 23:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6759F6B00B4
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:56:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0905C120836
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:53 +0000 (UTC)
X-FDA: 85062225906.10.CFF082F
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4EAF4140009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JentvLbg;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815811;
	b=QdFW1AkzjwpgrdV7EaA65WkEgwAYsMU0FFOvFeTEakPIOLJK2y2oaVAcP03BJdhk4Atu54
	Syexk6dO7BnauUJl7Ya0pchnFG1f1BfdJXkc4nblwVbBzpuEOd/pSG6QnBNwFHuPLsMfPT
	F2dtWs2FK1+CQTyslfm0KOjd6KFEzYM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JentvLbg;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9bQlBBDcNhy6LJjhudbhYloxJ0liqCISFNIfGIIeqo=;
	b=qV6Vcd9u5NhFLf0HFLGsgAnFQjhDr4H7oZXzZa2FfnABIhIeUOs4t3GGJo+WKoaN3YzXOE
	4SRKEnwqVSTYFDZZyAPtXelbBwRwhWCL9ByLega8b3dIpKq3Biwsic8urU6Yq+ISO2nGBu
	DpY+in8VsBkJlmW4h8J32Zx5jU6tqjc=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2caf228a910so30346765ad.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815810; x=1786420610; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p9bQlBBDcNhy6LJjhudbhYloxJ0liqCISFNIfGIIeqo=;
        b=JentvLbgv/EpZJ0C5SKR5Ux4xEJQ10+yCD43Qrczonu26xj0boig5XZi02xCo7Dk6T
         2yHKH+PDMEkdQionBagkM6RSZGbIWmwNU9iadJR+rF5AUm1XdZpKHLO1dP4iDFSRtc9R
         XOuJeYbPedEkQPpbixUSx+NgwfLlaoPY8wz6G40p+oniHg/eh8OqwAXBAmUior0oxQlK
         9/VOJPEh5S9+VoSlWuN5DY00Ru39gsFYZ1wblGiBb5y0lRVXuCtavnG1Rm3b8SvkEVI7
         9bIWNBQnaswxwbsO1dp6q9FInvcF5syjoNTuBjpfUBEYN3fgOi9eIhX3ok0nWiMgC+pH
         7IQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815810; x=1786420610;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p9bQlBBDcNhy6LJjhudbhYloxJ0liqCISFNIfGIIeqo=;
        b=j4olSbgZqH+0W5eM7gOw+ptq9eLFwgK6gmNNrkLsErt9YZCwZYH8cTCWSJYw7ddToJ
         iO+8Ckzw2RHr9Dw5VbRe/LN3uTgDJfVeOOR7zNaadpdx6k2IZKCHwxeoQ8Xa2sTObEp7
         U54PHytBcY+1gl4lEgmlr6Cdia4w8fCIWMvj11Uo/ixzH2nezqB7jN63GPWas5ekkm0L
         kklwnkWk3AIeWACBpeEqKPTRKK5ln5kEA+QUNrvmp0Amy6aKszZbrAWMpBC9iaF/M/si
         9DUy5CH4SNs5lrvgwFl91BehRRn890eAtC9aqeR+flBRlC2U9tAZPbWhRbYpVkhKlDsA
         jK8Q==
X-Forwarded-Encrypted: i=1; AHgh+Rp04aQ070YQxZL6Pontl4eRK/obJfdxXgd6dCcmne1vK4f9L4fANVWhNeQ0/iLd81mrZPMFW2yw0w==@kvack.org
X-Gm-Message-State: AOJu0YzRTte4G/heoUOxsakhxnF9I881oT9WmNIM/8hCYCycv24Qh8WX
	YiLQvIVoYFMvee+wUkkcFPVejBdnG1G+jTfOqvkS43te944H5jkU3P/gdKaPoTZUIEg=
X-Gm-Gg: AR+sD10HviowUkTNjudeK6oUAiXJwadtVI1ATGos2C/g0wd0gfWx5e3N40wkurr9fIQ
	DCMM4UO+xII++Id6mwL15wcPS8pH3qgzWC6XqgCzIWT5HO/K40O4uTfq/VQpbLrJzELvSSw/gVT
	aOKDCkY/RycbgmZ9SqeFJmF/wZ0NS5YbXJ7JQuN4iIgR0HkMR/Tg9HDzhHekWjcK+YIkfuZRd6t
	cVBPOU/i4rpaHgmZGYnPB9fN7SbtzMfrFPFrr5YyQu8xiIQTAIdB3GZqtbYaWgwBJL4CSlhGQq+
	9WKW5ylyBp+AcF2ex/xgsU3ZfqVfDW94Dhon8/H2I4F8syVXXe0uqjzqgNvH0PnZsmJib1P2z3l
	2sPTbYvdQLK6CQWUYUOhtl0/2n1uk9xC8ANZGkmEOQRwkKRTiecASn1Hj+F/VUYDrKFXEKClCAU
	ujPfgg+89PktwW5YMpQu8gNjoYaMQ5TNfcqlNp54g6M0zNsmVAzpXR4lESFUnHJ5G026CCD7Iq7
	TN6GxtuhmwryoQHV8A=
X-Received: by 2002:a17:903:983:b0:2cc:8ad3:423d with SMTP id d9443c01a7336-2d052299eb4mr125935575ad.29.1785815810135;
        Mon, 03 Aug 2026 20:56:50 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:56:49 -0700 (PDT)
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
Subject: [PATCH v3 15/17] mm/hugetlb: remove HUGE_BOOTMEM_CMA
Date: Tue,  4 Aug 2026 11:55:33 +0800
Message-ID: <20260804035535.2846016-16-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4u5fqj5613mjf51zfjs773goug7oop4s
X-Rspamd-Queue-Id: 4EAF4140009
X-Rspamd-Server: rspam08
X-HE-Tag: 1785815811-729845
X-HE-Meta: U2FsdGVkX1/z/1FaKyQ1Ho+mfs5hhCzm93FsdqVdOgSbOF+xcCHPrQi9urpRbNO2hTIhcxDTAEDml5SIflazJO80xNqHYlqsKxQHaSMN4SBIelbuT1xatzALB1LFq5atYYgf4XD9U/u7y0NatnUfzSiRCP6ZtVmmpMZpKDCoyt9aiP4KcU1Dhfi1Bkzqs40dwLODJR0h6aZ6RtzhcLt/dYalXc5ueQaJIX4M3pnk4AzwLEQEJgxozI/5mxe48zDlc7WJFeO5R7Wyk5A6xFwipbF3C636LFdh+K2r+QDQlRuPxX+JDjrHNM6CV21IIwbELl0o3Y3TOTiQ9PVMeLyeu6DDVM7+0NKtRGO/Bf++JS2EBpZwIPgb5A6sybnNm6HwDnNL9E+HnUiVLudP/P1CJp1GK+RzzKyEaaktDnjhwDktNmbggs7bBsGUy/v5xAC1izLVkzIfl0lnaPKgze2xVoz3+YBYTKiy/IGp3xbMjP/Y5oLcrzrprOh6G37WdjRPXCRph9K5u5wEdZ22f9ek8M9mteriiUGlpIBUtWpamXFXRVW4Czj6Kn/bi5HiCU3qZHyk4D1MVpJiGo3M2iQaofF4W1H2efUhf3B91OkrYmi2JFUCVMveJPlGlqW1nmeGETPOuSluEHh6GxBiXFb2oRc3HI1NJVMYp/DcJlmAR4GpJYSkwU7P/c2hMysVCPKCEA1iBfIcFmRcAQDVSBffe2tPFBqcFfbh6JmXU++fNgkzD45SkFG1mJq11I/nURPSYC8A595hAhI/0BBhiZ39guLs4MdcH1v3TT9JdQqGHUH0icA4p+Kp1ewKrJROYoCDymlqMkis+GS9J29IbXEgAzzO1YEm2gluj2RKTr4/S86FX4heH1yg0T2w9G3SANnMuVwsLzPoMsVat8FjjNgiE6rMm+YnvkTSpyfMkUCZL8yChKB8Grkt3J5/kFCqO4m+asBp+eNvvcmoGuNei+v
 AMQV0nFJ
 3P6u8LNvMI+EMe6qv7FSBwugcYd3TKYNyKEVp/rMqLv2X7+muiqaImnzLbeEPXX+/XrHJnCH6d9cOe9FdQPxxebDkhKtDvobJ1VeW5Ig1VNK+69Wv8E67M+amQZbHgqW3t5R0jB8AVxZftP722+9Qk8M7m4AwhniEVhtbYRWtII58kpjuMJXgzc3Wtu9JYU92CvwO1sF4Saj++RJMg4iDglMbJkP6zDA11hHx7QIYhU2GgvTR7IeDUfCWo0pJxypkV3NKqv9/TejfW8W78h01XWRlZ8wN24WegERpTKSQw49F/wYEDcBy/IK0yJv5cVOUiuGniazUXOgJTjs9H+V+Oz4iuKtl6q2v8zUIKhUigOi3VGA+plCM6RgL7rqkVZqnzKRGf63XR54bSKqVxTzCLNpLou/RsERxll0OQ8pRgu4H8iYYp7jjZtOFm0QqgOe/yHU7lYOAV6llNPE=
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
---
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
index 7e2f186fa224..df5944651b9a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3120,7 +3120,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	 */
 	INIT_LIST_HEAD(&m->list);
 	m->hstate = h;
-	m->flags = hugetlb_early_cma(h) ? HUGE_BOOTMEM_CMA : 0;
+	m->flags = 0;
 
 	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
 	if (!hugetlb_early_cma(h) &&
@@ -3196,11 +3196,6 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
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
@@ -3291,9 +3286,6 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
-		if (hugetlb_bootmem_page_earlycma(m))
-			folio_set_hugetlb_cma(folio);
-
 		list_add(&folio->lru, &folio_list);
 
 		/*
@@ -3304,7 +3296,9 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
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


