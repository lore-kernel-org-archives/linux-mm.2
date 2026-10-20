Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA8B3606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=AkapyHJ8
Received: by kanga.kvack.org (Postfix)
	id E603F6B04A6; Tue, 20 Oct 2026 07:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38E36B04A8; Tue, 20 Oct 2026 07:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D006F6B04A9; Tue, 20 Oct 2026 07:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DCAF6B04A6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:58:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1830C14012E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:59 +0000 (UTC)
X-FDA: 85342858398.27.1231842
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 55000C000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AkapyHJ8;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792497537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTNbLYZNYoZPK2Bg8RLgUq3mJiYqux3Sp5looZ8MiV0=;
	b=C9koSE+jVTrXrLRBuopWmcE76lDw72qRm+id0iY7pbXa7ZvnH3yU60dDdYJa3mv9S6NtmI
	mNiHEu0lxSqYWH7h2U5rkk/YfbLo24dy7HcYgFh6opalzlgrEI1TN5co/uEZSlKXjKJ+fZ
	/MtKe0Lmf8Pqh4uGcwX6H7JxKhEWVdk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AkapyHJ8;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792497537;
	b=UBY/J73DPPpoSHhvWVl+SGWRqJQlfb50Tf3JEwzCCkVSPnNc2d6A15m4zkkfa5e0dKY8Ns
	hT2gpYkbWIECzK8OgHJARYjq7xBAKsYq0iV+a8kP//TOFepYcV2RWnOfvlGIrcIoXRddFr
	gDifx8VtuicHtLz5TSqmeqhvuGW90Og=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc4dbcf2b85so1277477a12.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792497536; x=1793102336; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dTNbLYZNYoZPK2Bg8RLgUq3mJiYqux3Sp5looZ8MiV0=;
        b=AkapyHJ8H23dW9uXJL9m5B34rZxt1AaE3aCcnP75HJCXg4vn1lIhtrhWi8EWccLYLU
         3ChknrFyCKAGjqu/IJHZigDlvcyPiHabSdUtzVnw5wQMO/ZSQSMt5HYTbjKeJF/2LXEq
         2rDysaKzWBQPj+md/BRXx8Xph1Bnbo7wYJqNPtHr4xZb9PPTpTmKAG9sAw16ENkbvt7/
         6jMVEIUh/QsSGYzX6DBJUfgmOGHj8GotJ+t2Tf5FqBJ4apJw+8bjDcRWiCD1XN2CFYZU
         bLgT6d6I/3iZdkCGh01JBPTGzvkL46iZyU2cmnUkDcmnOknSvtaM0YRGLI/LtAsI1x8c
         lCiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792497536; x=1793102336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dTNbLYZNYoZPK2Bg8RLgUq3mJiYqux3Sp5looZ8MiV0=;
        b=Dpubv7sxI4/slNVM8P6SewNRacw4O6Kf29QPuqOm2ySOllcJk6zmrgBMQzVRd4gHup
         BPT5Dy3w/vMoU9jGByg4zaVh0Luv4YS6eXvsyPuSAmKtAEMOAh4wXaCRQsD8FpqNql9O
         wxmeWFj0TUjp16SCh1udLyI5mpNKZ8s3u7/u7Xd8565sou3NsEs+3xZJwpeBB0WfuAZ7
         mxERhee0uyInqzcr3My03q03WFSHDjuFRzSHsYPqcHnnXuWYl7rwlklGuyVX7jc4FZLO
         jswxDUbKqh6oxcvRRtl6QfFqsxDrrIAP/JE8kBig0mt2hiN4Y/lbabasbC6Skx5KRtvH
         4Mvw==
X-Forwarded-Encrypted: i=1; AKwUvBwxJ5/54N7YviTgkck8DTxPnGORyf0NXVgyw7Gb4YT48LSbQSBJqPu+UiH66PIkbILK7Lf0PNaOwA==@kvack.org
X-Gm-Message-State: AFq9FYI5sqW7uMnMio8Pi6R8unQ2D63w5ZFWQNrRPdiGUEECG96TUuyE
	FLXvJlEfbL9zVGXSnJkbePCfYibtVtt+LGPG4G6+H/doG1SOpXXhlarHikUhJwhVC2s=
X-Gm-Gg: AYBFou2Wkq+W2jZM9w+wiUgst/rgi1vqk/hYg+Lf2C1jsBNdaXfDVtgtrA+SlAHM29D
	FEdrlMMFmGV76sLbTd0DWL1+4X8cvwiigbCrdSLJ8oCSnQTNr+nBBhBDrBDdZ0twB19dmZ1NPe+
	8/qAohFTmBytIO4nYDVM5EiFtpdk5AmIObX1MB6W2MwalQwokywf4N5Dp+2e1BHyuzxLG1JUVNW
	1dAdRgSXIQzjvu6QFdKth+YtM75vHQjF7jl7k9dBM6WwSllzFU5Lc1LHO1BeSObQp0ZesDbRS/r
	qKVD7p5hYhIzHIAcir/0Pc9jEDIiHJjGE/7G2UlLgIHApMbcbJTM9dPyCThokiwK7gBjUqba4LM
	6WEqPa0r5hW6R5pwXpXf385aQXKGkkSZgiblp4BSG0Wf2DVrmIEkW1YWXVOF+W5asrz/XFNBrJv
	VnVEueZ6s+B0aVFnwfC2ek7qTBsKGsZpZclkZp1y6GRJpVxuV3LGjtuyhVGhPSK8pM35md+OboL
	K3QLY7dYLcUif3TIb9aLKyM2azOpCEgArkTUtH/4+7ro6lOu7ZLd2PDwOTaONQwU/jGeIHuuXk6
	iQ==
X-Received: by 2002:a17:90b:4a03:b0:3ac:6e91:3f14 with SMTP id 98e67ed59e1d1-3acef134d44mr10171363a91.22.1792497536105;
        Tue, 20 Oct 2026 04:58:56 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60274fc1sm3448095a91.0.2026.10.20.04.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:58:55 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 08/12] mm: hugetlb_vmemmap: move alloc_vmemmap_page_list() next to its free helper
Date: Tue, 20 Oct 2026 19:58:20 +0800
Message-ID: <20261020115824.823278-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261020115824.823278-1-songmuchun@bytedance.com>
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 55000C000B
X-Stat-Signature: 59mus5prxz6bzoiiqbswiifgbacnprgd
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792497537-767996
X-HE-Meta: U2FsdGVkX19Nyv49KSeaDzh0ZgykGsxgU9DauznHguKwx+5NgU+qRFSSwXwHr5K2TrA4NfTlagDfXBchrHFn1JjS/40XnWOVcrQsnSbEEREond94aZsBqdDpyKIoFRymLGPHOCdrTmMK179tTifwPHstJPo3BGfwoddNof6VrF4SWg6Zmma82Dh+nU57pwR+RcWGqxqOANtqraklU5exRrrAEbuvhx8Zo7ArHI513VFOqnzDxvRi2NQOo3868AbsKAWKWfmxKVbZo0wmO+USXmhEnC4TvoydeOStC3KkclQQcjAfxnMw09T0oIJAkJ+gBNta1BRzcdzKHP7lGq9el4e6ftQacA9QDYHQwYsLPhU4jp43QAECkN6cJ8j+rlAhdehwmhg2eT7G1cjQnpPQScN4XruWUhZvrkjOxtSD3RG416uoYjVfJQnS8n8JXFBhRIKwnTgx580Xg6DaAPU14GWdyHLF3eXeOrGoyIxKy0toYzvMZunKaeyj+oB3PWt7yTYl//90fMDbGYYmg0G8/iDGSINUzqL504UwxGem7CizAfkClRq2WPlzfh9TtpliuzDJlINiBsgZSAgba8b5Cc2UjABHLKmzkfL4dkTNJ1vnlFaTHzd9odpb/Y1nIDF5PZAsgNcHf6dLa6xjcuIOZz89vVWPH7fgb7XUrKL+GhoKg5IhNLfVygWrUaXQYAS/q5GXOW/VIrnNCbqNyD43jywNrgv5ILQpje5DY9tWbcoNrfMLUwjjenaXDYnN2liwrmX/TBq1ZSpW7XCGa8OM6/UjiRqlaSyZH8/VsBA+arhMeatCkeXhighm610yRmO/daPeEXo6/SknVlO37WCgEcr0h2GShvqcV/3OSfpZf3Eyeuq4PUQot+VBNCN9BYUwPeKP42/XupMWpGsTrurPvtAz4PJzd3l7WvQoevUPALIo4JX6Rkindx1NvF6on0UseN6c8Khmr8y4v5c7VpZ
 YFDXVkym
 40WyKrS17f+bzmyO0TKYOLRKyZk2Q98mPuMmGcx8m/LqdJzyfIT3QZncRzFLrgep2qnLa/ValYxrypC6kA7O3nSlEDbZ33E3QJxZsKBz0wha0ZWA/G5F7+uvx3Dx1wD6f6l9S6Xq8FI392+lKCUTZ/PMpQMCGtw0DSYur+4P+mkOKXZN9JONz9rx21ApUL1RM1kmug9ebmIKSivyLLpQnvZjYNloN163Gg5Jl5zS72irmwWLY6O1JhMs3pCo8ZayHw+3somY51jTjeL61LVa6C1JGEfYz1Y6DcI2vzie3l0o+R4yCdDNFOiJQ2QwTAXwir7bdB7jhxaImo3f+vlptNhG2aNAPL/hZw5PIWYyUgIrP2xM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Keep alloc_vmemmap_page_list() together with
free_vmemmap_page_list(). This also allows the folio-oriented
optimization helper introduced in a subsequent change to reuse the
allocator without a forward declaration.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 8fac61b7d74a..89f000227d4b 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -197,6 +197,27 @@ static void free_vmemmap_page_list(struct list_head *list)
 		free_vmemmap_page(page);
 }
 
+static int alloc_vmemmap_page_list(struct list_head *head, unsigned int nr_pages,
+				   int nid)
+{
+	LIST_HEAD(local);
+	struct page *page;
+
+	for (unsigned int i = 0; i < nr_pages; i++) {
+		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
+		if (!page) {
+			memmap_pages_add(i);
+			free_vmemmap_page_list(&local);
+			return -ENOMEM;
+		}
+		list_add(&page->lru, &local);
+	}
+	list_splice(&local, head);
+	memmap_pages_add(nr_pages);
+
+	return 0;
+}
+
 static struct page *vmemmap_dup_page_from_list(const struct page *src,
 					       struct list_head *vmemmap_pages)
 {
@@ -323,27 +344,6 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	return ret;
 }
 
-static int alloc_vmemmap_page_list(struct list_head *head, unsigned int nr_pages,
-				   int nid)
-{
-	LIST_HEAD(local);
-	struct page *page;
-
-	for (unsigned int i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
-		if (!page) {
-			memmap_pages_add(i);
-			free_vmemmap_page_list(&local);
-			return -ENOMEM;
-		}
-		list_add(&page->lru, &local);
-	}
-	list_splice(&local, head);
-	memmap_pages_add(nr_pages);
-
-	return 0;
-}
-
 /**
  * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
  *			 to the page which is from the @vmemmap_pages
-- 
2.54.0


