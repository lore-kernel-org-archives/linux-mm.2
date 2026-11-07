Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96957606A333
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=E5BFEPiG
Received: by kanga.kvack.org (Postfix)
	id 33AB36B05C2; Fri,  6 Nov 2026 21:30:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29CAA6B05C3; Fri,  6 Nov 2026 21:30:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2956B05C4; Fri,  6 Nov 2026 21:30:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C80536B05C2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:30:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F0CB120214
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:30:16 +0000 (UTC)
X-FDA: 85406743632.05.831862A
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4BB46140005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:30:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=E5BFEPiG;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794018614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ubKwRSTsTIlPsoKjK1De4SkgUdRisqKqmOzxufJfKKg=;
	b=VljyBY6gbob2qtSC8lklqvArMAOr1ucbPtyXCmQVWN/ArnSS4LuIXpkK8DmUXsTdzPmo4P
	tjItxIPXEvwGYQEiSvLupjtMrDD7Dz+v7QM0BJc4/pHPlGKvzQIXj1cWi0dPRO/fyQfFSa
	JGCRTsUIPrtbn6Eedjv+kMVCsN7GtS4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=E5BFEPiG;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794018614;
	b=tesuMEToXNQujzf31oWXhPO+M1CmNfAiseczoXlCwRa7QGFH5zL8pWqoBv4GdqpBva6mr6
	eVLiJk7Y0TXQDFsFwDdXfTsJEpg6XM53tLb4w+Mbl5u6MEniYAVxZ7BUolNrd9o1wC3ZwD
	VurGtN0yack4/a33BsLn3SMVLaofOSM=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-36f8cdd30beso2036319eec.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794018613; x=1794623413; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ubKwRSTsTIlPsoKjK1De4SkgUdRisqKqmOzxufJfKKg=;
        b=E5BFEPiGkwLFYbEaXsqCf1VplRQ1wgJTNIXR6bz8JKnfsshtDlkVNqhhJFMtWrzMFW
         uAhpFdMeWiI9XL9pBe0lnmvuy9g+9PNzBmJAf8L2pbdpQadj35dZp5zeqJfx90qqsqF5
         S+0BECqMVDnZ4KE29YcIFxxlIlHxO5Kmkeb5qKTMtOxwGwQ42+y5i7udmwHqEiCeG9oy
         aAZglFiuDECE9JV8keLGRCxYh+Qg6OBlRNu01zKaddcBPjWnTOXdOyo8xDKTa5m1eE4X
         gh/xaG7xktkKAHFgESe5eNIbfon0yGD/5AW1T8rC+fCUNqSkbtIqVaOnBqKvMR2LoL+p
         yIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018613; x=1794623413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ubKwRSTsTIlPsoKjK1De4SkgUdRisqKqmOzxufJfKKg=;
        b=D9Ighng2kDI/ulerbfUUByQxx4jJETerEi793oVDMUyDszsS+Eg1OtZrkndPXy4hqB
         fPb6m0HZVGBWMqHkdwx4EpcUp+4Mj+cxHKOx1qZv6gEMh1KEv+/H/WTRybnCH+htpN81
         z5lWgegEzfXhRf9Xk3jHhQlhbbStCoHAtxKiSHyOjjrAGK1COEk1Q19WRiONeGVx+wez
         htGJplvMmAtlnhOakfAE+4E5V6ik24bVoZzgl9iX8oAQALVqaDfe7IDNr6/IfdrnwmpV
         f78wO5Vxpx/rSdn+G5+IyATCKoIvgxYzRkoYB32fYKkKaYYafqeo+RM8Wd2jOkSG9P/g
         WPCg==
X-Forwarded-Encrypted: i=1; AL+hErFfL7/bwmuD/UHIyOlOZ9xe19BdG868pybX5vGebbE6pNwGLGp9nxliH3WoLQO2I2msEKYCHDMW8g==@kvack.org
X-Gm-Message-State: APuU4Z+YwmpDVJHH/2th+GU1VK6qnREAlqUc4npq3/Uu1d7ZhyzgTKQw
	UzHubbIW7Qpw6APsVQAuzkUfI4nYgI/IWeRdhfc6Dq77Yw2iQfWY10bcTWRBBBgr5K0=
X-Gm-Gg: AYBFou308F6kUP3IqUGFaW4kLvgvgW4iMNFPDYV8d289I1uRqghi5QcMMklwTEQ6URv
	yStmLHEENc/kF2WXqgDel83GWWezdBohtIgSk7orMlOQ8a3AUlngUA5PNl8cQzjhT3gm/ym2q9J
	OHK/QnyltpbjnxahH0YZJjCoD2Z2B+1MWQSQcvPdbLG8oTNeGh1kS190P5ycBxs9f7ObUUjG7KT
	oxqFrFYXQ16r1kGbL/bmBt+97z4hFfazTW/QeapeMK16eXoH0tq1s0AXddGecPXyMAIY7hVK6DZ
	EWR2eFllu/HPh8Jaj59ycC/1FIn9+B7k3QmwLli3DKyMqEw/4Nce17xEhuSRHhozGuaupRdwo/0
	weX9du3ugNzan4HkpfqMgtmO+BWAqD1dGUqcWs8lq1ieVPjB6toogqo5SE6c/sWLrui5wqTajWB
	C8l6Ow7GjFVkF1Kbq+S0HjFaplE3NL3NTtufMqd/08OXQ9mPCCYLhbkx89JynWCBXEI4bTMJrAk
	Zcr71KXMT3pYGCeaPk/51ReJ5uiOxgKgRDYrOkvJbIChPYO6fra+u+dmQ1y/iXxrBAtJFwtAxCo
	dVI3bXzc+x69uzPb/njiXwePfFx9KkGj5pJ2cps4jxs/maRdLe46/Afee9u1
X-Received: by 2002:a05:7301:6190:20b0:369:f05d:6c5c with SMTP id 5a478bee46e88-36f771ffe67mr6158095eec.28.1794018612849;
        Fri, 06 Nov 2026 18:30:12 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faa4b8aacsm10457077eec.23.2026.11.06.18.30.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 18:30:12 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 11/13] mm: hugetlb_vmemmap: make vmemmap restoration folio-oriented
Date: Sat,  7 Nov 2026 10:27:54 +0800
Message-ID: <20261107022756.77731-12-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107022756.77731-1-songmuchun@bytedance.com>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4BB46140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: sfiegknatws19hfos6ci7ke3wirq6wof
X-HE-Tag: 1794018614-977580
X-HE-Meta: U2FsdGVkX19QFhmYMfR4N6tzCS10/VZ2af8G0V9yuIDVGeKTOHF8eyqS/kco0xLVK6U2bugDIZkb6OYOjZZsrDicGt/lqEFmf/6w24tuNjD4IF8fwXj/yS0zMEtvUO7g+IVh6/QiEh0e+O0bAX5WnFekqe9pe7yE1VA3nAMTGVLJc9HC/XUBxA0CVp/HFtaI3cuJlvo5VuvUPXer2LSWwCvu35c/zcaCTI34bzE7TdaCpUEfpzyYWhMActL7I0KYIC5A1T49P98jDCtoRyDW4rixsR9OU4ZC+w9mBn55cM/J1zzkN9slFU+L2kUlIO/ThWdLgsOhksdAt/nac5806LPOhnFxSyYKM1OPNDRuZoF0BB1Ln6jP1EGxaiBWFfzhqU8v3ERWwYTaVyQPgM/SSVTOO4WUKM6i+ykF63iV772IXHbhGnRqS/lizXfiBV9jFQilfh7K6TSZ4EapSgPKlOX5MEFQ80LFpqQxgFKWP0mhQ+ECSNe41occT6zyFPXDGKnh6rvPriBYR7seaCXnvqtOLqPmx14sI08Kg9FqUknSK0x3/dd7ix3OCUoybG4iaS986uVYjG6xLd0dUQNUkNU6VIf1TqFGmhdPiBkfYdpIBRuROBFCHPPRlglbc/ZttWRMgD+H/GgBbg1VnNsfFCSRlBndLiq2gjHkHXg/6HDL61IEKI9Gtko8i1eP2pd+a30Wm5VCNwJK2IPF1NuapYHqV7Z9zADBZP1bUNMWO6d/zt+QWvbl/14zNF9fFacK6lj2mdX1x6FaLzdkAbuPq8MYRtgWvxFUB+vL6W3tKATqGa83qXdgBG+UwUgS5PKJ4ZB4vwgYD12ExJau5cudop6WjaxNjDkSzue46xRkK1XC7juHnMpACm8AFfBTSZqXEFeR+MwFiBNiLbQEPgx0uc0HW6zOoUSQLj+edcazsd8oDV34HsEGm/bpgT2tDt40AyyjQhzrv0Myu5ASRkx
 0hX6npnW
 Sa+t2L6O8Tf3XZ8XAi0rzuZd1lOlGmfCM4V6uNlpzg1vnZEuosdSvFrICODDA1ooJaNlwGGNLe7++Xir05CA6Fq3MNiv1WVgvHrMW8BiByhXuNXdzyPBYNWxSwqtHyhNq93/kWOtut9vMQSON9NikD1dYVUF4KKdDq7/4qKSKO44nCeeDDkieb489S0vITf7+3ITSDl6BcVWF72QsACnH5U9Gr881NZPF6gJ79hDr4D6dLyxS1TZ2T/N2wHEUaC4D4ni8VV1ZSyBldxxF6asBMtUkQBIiDjeIf6mua3G4pZCaX/JWtBH5uIuh/YVgKtfTFiosVGSYLHtwPkWrNemPISvPkGvzLUXQaHUVS2c55gy2x84Mi4Q5ikrGeeuTKt4o03XNgNpoMND/8p+SbNAJbCfL7r9LOdla6zv2mo/DCCE5H+8p6CPQArZ6bikVf9MoJvpP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Like optimization, vmemmap restoration operates on one folio at a time,
but the current interface exposes a raw address range and requires the
HugeTLB caller to prepare part of the operation.  This splits the common
mechanism across layers and obscures its natural unit of work.

Make the folio the unit of vmemmap restoration and move the common
mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
eligibility and state in the caller and gives both directions of HVO
consistent folio-level interfaces.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
---
v4:
- Pass the caller-selected allocation mask through
  vmemmap_restore_folio()
- Collect Reviewed-by from Oscar Salvador
- Collect Tested-by from Andrew Morton

v3:
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 148bd27bb327..359e53302a67 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -366,21 +366,21 @@ static int vmemmap_optimize_folio(const struct folio *folio,
 }
 
 /**
- * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
- *			 to the page which is from the @vmemmap_pages
- *			 respectively.
- * @start:	start address of the vmemmap virtual address range that we want
- *		to remap.
- * @end:	end address of the vmemmap virtual address range that we want to
- *		remap.
- * @flags:	modifications to vmemmap_remap_walk flags
+ * vmemmap_restore_folio - restore the vmemmap backing of a folio
+ * @folio:	folio whose vmemmap pages should be restored.
+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
+ *
+ * Remap @folio's vmemmap so optimizable entries are restored from the shared
+ * tail page back to distinct backing pages allocated for @folio, while
+ * non-optimizable entries remain unchanged.
  *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
-			       unsigned long flags)
+static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 {
-	int ret, nid = page_to_nid((struct page *)start);
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
+	int ret, nid = folio_nid(folio);
 	LIST_HEAD(vmemmap_pages);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
@@ -388,6 +388,7 @@ static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 		.flags		= flags,
 	};
 
+	start += VMEMMAP_OPTIMIZATION_SIZE;
 	ret = alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE,
 				      nid, GFP_KERNEL);
 	if (ret)
@@ -407,7 +408,6 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 					   struct folio *folio, unsigned long flags)
 {
 	int ret;
-	unsigned long vmemmap_start, vmemmap_end;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
@@ -415,18 +415,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
-	vmemmap_start	= (unsigned long)&folio->page;
-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	vmemmap_start	+= VMEMMAP_OPTIMIZATION_SIZE;
-
-	/*
-	 * The pages which the vmemmap virtual address range [@vmemmap_start,
-	 * @vmemmap_end) are mapped to are freed to the buddy allocator.
-	 * When a HugeTLB page is freed to the buddy allocator, previously
-	 * discarded vmemmap pages must be allocated and remapping.
-	 */
-	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
+	ret = vmemmap_restore_folio(folio, flags);
 	if (!ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 
-- 
2.54.0


