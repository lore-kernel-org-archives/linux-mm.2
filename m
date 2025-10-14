Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66AC3CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC648E00CC; Tue, 14 Oct 2025 04:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E328E004B; Tue, 14 Oct 2025 04:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73848E00CD; Tue, 14 Oct 2025 04:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7358E00AB
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:35:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F8335B326
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:35:48 +0000 (UTC)
X-FDA: 83996061576.18.0FDB2A9
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	by imf08.hostedemail.com (Postfix) with ESMTP id 83F1F16000F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:35:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b="xSuX/NcK";
	dmarc=pass (policy=quarantine) header.from=unisoc.com;
	spf=pass (imf08.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760430946; a=rsa-sha256;
	cv=none;
	b=gu24mrVFN12awjdmAGCS7EKRwRXsCnuZRow1f5gSME5OwWYS+K7cpfuxjWIgGsyIuiAJOB
	8BJz9/+Eq4s17qL9Yo9aOrHmPvrTMvYHWxfL5itbR6N7KAwLlr0Ho/s8y8OORI0/sYQMb6
	eW5PoH5A5aRvGXb2+YeFkN9HIHUfMAM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b="xSuX/NcK";
	dmarc=pass (policy=quarantine) header.from=unisoc.com;
	spf=pass (imf08.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760430946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7+5gnU0m4ULo+Ba+y5s66MuVOBWfTtrRajsj8ay8+0=;
	b=f/6/0MXvNXNibPiLZW7CXPqiSOwwh/Jj2/wL0R7/hcFypnsfAMPQH+2UmP4RP3WAM8Spiz
	iyH1nTng/5HP9DVrc9Db5w2uhvZT8K7g5olvdZqWFTMev4gBBZdeB8kJY+FhbhrXaE9LbB
	8YnZTc14xHa7nVTIBOnhWg/gynOvwWY=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 59E8Wojt086369;
	Tue, 14 Oct 2025 16:32:50 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4cm6q862xFz2Nc5jJ;
	Tue, 14 Oct 2025 16:30:28 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Tue, 14 Oct 2025 16:32:47 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand
	<david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman
	<mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Sumit Semwal
	<sumit.semwal@linaro.org>,
        Benjamin Gaignard
	<benjamin.gaignard@collabora.com>,
        Brian Starkey <Brian.Starkey@arm.com>,
        John Stultz <jstultz@google.com>,
        "T . J . Mercier" <tjmercier@google.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang <huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [PATCH 2/2] driver: dma-buf: use alloc_pages_bulk_list for order-0 allocation
Date: Tue, 14 Oct 2025 16:32:30 +0800
Message-ID: <20251014083230.1181072-3-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 59E8Wojt086369
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1760430784;
	bh=K7+5gnU0m4ULo+Ba+y5s66MuVOBWfTtrRajsj8ay8+0=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=xSuX/NcK03y5esnExK/NNHsgEI0OVUwyBxdOhoPg1QqdB5l1iFdFp6lug4g1HSEeN
	 98BXkanBOwOKSVWebSeadOW+Awoa8DA7l6Qy9PUc/AU3bjHNyqF+1Pd2qYZzt1OZlb
	 SOOuN9wCeIqUAd5axIGA7v6UwZxQxfha2sZr5bGzD7kTsIAvJNzPTIkiuxFTgNzmtc
	 ZiXttiRlixfhILDlObIzhdM6Y8js4uTDTugnamf3zDFU39likolRlTAqYgriDo9dFx
	 LiPujVT1bcIL/QFWMHXs+7UAoYG8CT2eliKXmu8omC8ucBJCc0Eb3/fzR1b4u97Uui
	 sr9i4BpJ+wj7w==
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 83F1F16000F
X-Stat-Signature: zzqordjqww6fpwrx6aec3j4453y8e1gf
X-HE-Tag: 1760430944-430452
X-HE-Meta: U2FsdGVkX1++OITaYnV/QkQWoKn00aXpgNGCvqZDPoEVem9rnw59Cnle24AHIzR0iP9dMnbVB/BeARbESg87vowK03QjbEt9m/+jEW61sJvvGbJ7nlxrnrKx+I+oCANOnJs0VgDwW0vK3pBn3V1Us5AXdIf3zvXvJ1ib1R4oIDUcOEZEiV23qXCxRQLHZObHF1x2GPCJFZ+5k+w5+VVOibVn2lEej7rA8Zpdfl8OaLtTNtcz7N//xHCzoLWAm50rwuwjbxZR25Vl3PLZadNLWjP9BT6zpM/kOVP3ZC/NugEHKmyABPfdgNID+g02IfV2flq7Cl7FPEO7abrm/JiviiwvJeJI3rcnRTz9oAfH/Lm5q6sMNblj0+YCou2zLpbI/ZdHn3m8QXGr1gEDnRrx2FRkGndiVm6Ow12h/5UYyX/jQInpw12A27BuJRiWSeyQ2EY1j0qmLQXIsq/nZRqG3o1hpnSXHe8DLeQT4j02sGqeNgmJvy/Aelr1Q8SwTmJKxW2g7FGbRFUabZpwP7AcQfqC8COCPNYKWtFgAGJWTF08CQCegpb6QRhAQ/0XoFU0d0Noo1qPeVc0oVOM89DBN8tqNDM2NelinRU+07sp/2tLpAJFfAkvUPy7z+agInSOCjqx6dzEw4fBA8ydsHHrLFU4lg+bMytqRktxvHy3O7qN5BphfsEMsP6+yEI7t5FTz9NeT7S2JGGgTks8A0yVNs+lfV9IeB2q40n7ishQW6EygRHL3nUnX9vuJGDiuiNq4qjGLcZ5MZoduxOGSITO6m1oQYHTsrk8fb9+gwTLF5rKFfS21SuEDtBlYGl26eamn4Pl3i4gqJ/I3IDJsGKzaCvBT5YU8UYaTUpx701S9ZveztobSrsfQtnwdZBOdCfqME9UXhdO0aoNsTKh3UF+OJeM8wLY+eLrwLXp4ufzN9bvDOYuLT5HtPwxu2Vz6zHVh3y0mpW1Wm11MAaOBnM
 6yjBKnIu
 o5VEuE85s/5WHa9YYuAzloAi+4fZZyIvcIwzB69EPg2X1kjW0EfimCie3KFRyIDD6EgI7wuENfZdoGuU2DdbS557DLmrVRw1BlR1H4WBssmrLrelvsECxTyVEp5sjV523u4IdzFDumxMvL9FAuXSVQo+YAA6C5/ea7zse6zMDsAqE3xD/D1afQuyV/u2RH8fGDWa9xfwCOlSZhEhW0JDXLewnS1tMZn6jjVWgWHU/HYm4B6khgis//HVuXiOMeLX1xMLg4YQOXtSLBUpLolQb0H5NDkHxkHAAQMWxPiMUTJL4hhcODxe4v0wNfsHt197EvkV8v2XdVW4pYDFLLUZCxrwTrF40d6mCxE47BsT177X9HD7DHCYnXAiTMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

The size of once dma-buf allocation could be dozens MB or much more
which introduce a loop of allocating several thousands of order-0 pages.
Furthermore, the concurrent allocation could have dma-buf allocation enter
direct-reclaim during the loop. This commit would like to eliminate the
above two affections by introducing alloc_pages_bulk_list in dma-buf's
order-0 allocation. This patch is proved to be conditionally helpful
in 18MB allocation as decreasing the time from 24604us to 6555us and no
harm when bulk allocation can't be done(fallback to single page
allocation)

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 drivers/dma-buf/heaps/system_heap.c | 36 +++++++++++++++++++----------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index bbe7881f1360..71b028c63bd8 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -300,8 +300,8 @@ static const struct dma_buf_ops system_heap_buf_ops = {
 	.release = system_heap_dma_buf_release,
 };
 
-static struct page *alloc_largest_available(unsigned long size,
-					    unsigned int max_order)
+static void alloc_largest_available(unsigned long size,
+		    unsigned int max_order, unsigned int *num_pages, struct list_head *list)
 {
 	struct page *page;
 	int i;
@@ -312,12 +312,19 @@ static struct page *alloc_largest_available(unsigned long size,
 		if (max_order < orders[i])
 			continue;
 
-		page = alloc_pages(order_flags[i], orders[i]);
-		if (!page)
+		if (orders[i]) {
+			page = alloc_pages(order_flags[i], orders[i]);
+			if (page) {
+				list_add(&page->lru, list);
+				*num_pages = 1;
+			}
+		} else
+			*num_pages = alloc_pages_bulk_list(LOW_ORDER_GFP, size / PAGE_SIZE, list);
+
+		if (list_empty(list))
 			continue;
-		return page;
+		return;
 	}
-	return NULL;
 }
 
 static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
@@ -335,6 +342,8 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	struct list_head pages;
 	struct page *page, *tmp_page;
 	int i, ret = -ENOMEM;
+	unsigned int num_pages;
+	LIST_HEAD(head);
 
 	buffer = kzalloc(sizeof(*buffer), GFP_KERNEL);
 	if (!buffer)
@@ -348,6 +357,8 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	INIT_LIST_HEAD(&pages);
 	i = 0;
 	while (size_remaining > 0) {
+		num_pages = 0;
+		INIT_LIST_HEAD(&head);
 		/*
 		 * Avoid trying to allocate memory if the process
 		 * has been killed by SIGKILL
@@ -357,14 +368,15 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 			goto free_buffer;
 		}
 
-		page = alloc_largest_available(size_remaining, max_order);
-		if (!page)
+		alloc_largest_available(size_remaining, max_order, &num_pages, &head);
+		if (!num_pages)
 			goto free_buffer;
 
-		list_add_tail(&page->lru, &pages);
-		size_remaining -= page_size(page);
-		max_order = compound_order(page);
-		i++;
+		list_splice_tail(&head, &pages);
+		max_order = folio_order(lru_to_folio(&head));
+		size_remaining -= PAGE_SIZE * (num_pages << max_order);
+		i += num_pages;
+
 	}
 
 	table = &buffer->sg_table;
-- 
2.25.1


