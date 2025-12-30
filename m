Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19DF0E94120
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 07:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6D96B008C; Tue, 30 Dec 2025 02:24:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D91AA6B0092; Tue, 30 Dec 2025 02:24:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC4096B0093; Tue, 30 Dec 2025 02:24:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B69506B008C
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 02:24:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2FAA01A159A
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:24:54 +0000 (UTC)
X-FDA: 84275300508.14.B836B0C
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0B92DC0003
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:24:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=X2XxnEYc;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767079492; a=rsa-sha256;
	cv=none;
	b=4v54nlMKPfWGexJzSdYJJVUcdYVYitGKmWmNtxtp46LyYFUv463pNY4mFtrGH8SaRRYbWm
	zPdBZMnVccAYSU2H6E4xTDZ/c21RPKPwK3ZV+mr13uAvMR1poMQ5lgnnQJoG5agIb6ttxp
	qCL4yw0dbaS46Qkllva0mzVGXEbsAsA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=X2XxnEYc;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767079492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jvn7amaYZlXvkJeuNXvZcovPJDmyG3lpoaMhcFaZmj8=;
	b=l76XbtEFRG4RAuBs8+Ao4Qlqe0IYwhUTk3EHeLhTfsmq09N1c1keKQFUBwvK7swbSHAOMa
	zRaCxHIJLMx94hDUbL7/H4aoZrzEbvXXcvw3ajhwk1aZZC14dtsPI6erRC/u0k6vPhzlD3
	slMOpUZ8vFzsXHHYCOw+byHvw1cGwDI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Jvn7amaYZlXvkJeuNXvZcovPJDmyG3lpoaMhcFaZmj8=;
	b=X2XxnEYcYpHOFngJfzbe7Bb3OOj6lfJUa2qxsUYzi8aHCnFrPQ9s7l3VY3L43hKEzH7hicEc1
	LTGWWU6B1ht4CY3zZi1OwoFaxBMQn5BMaBm/gSFfTa/up6Sbu4m5+/iujoZQiXuJ/vWi2t8ofOM
	AmHe+0Lk5lQq9uzaufRA5hQ=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dgPf84GLpzmV63;
	Tue, 30 Dec 2025 15:21:36 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id BE6AA40565;
	Tue, 30 Dec 2025 15:24:47 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 30 Dec 2025 15:24:46 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v5 3/6] mm: cma: kill cma_pages_valid()
Date: Tue, 30 Dec 2025 15:24:19 +0800
Message-ID: <20251230072422.265265-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 0B92DC0003
X-Stat-Signature: 84mtx53a589uq3xgzetr6khr681gemos
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767079490-848081
X-HE-Meta: U2FsdGVkX1/Fv9Ggwzlvo/wfnz5Rt2lqo2GIRXkqKLjLMkf1uV6pXQ5jYOnqQLMR23nd/L5xz8Oq5xCm1hzdVyyjlG+Q0r19rnWLmGO3aXQQ/qx9EGh9lXxquUO0rpLWJwGSMzdtjaONp3pzIYaEVEh1f+oDdAGSPtB0hmEbnx06Z9e7DIge9piu2ClBfCDK6FZUoltRNe8zT86bkxDfeXHyhSmsnpmUsQ0e++UUN618UGK+1S6bB9/TdYc5hhzEuJARczRvUGNLiWEKVKrx11hcL3m60niuecrzKeUSqJcIk7mVn8Z3pjSYVmBF+oJ7eq0GruZFjTfC7T176KU4B3JNttSjlogpUXYav9cqmkyoP+RWdDvOhLOxt0C4dlohdM1ERF34/irTV1ab8Y/imhcgx4EE3XTUIT9RHlo09oZgn3wF2MFsMx/ef+zHIWAP7vER6YYd2ibzR4saXpyV61PV0YhohKgKT7fZvdL6HOOhIO9wDrQTy3EhcbPk/EyWD2FBipTqHnNULUwJ2/iIjquVVSmva5/XvY0hT28kn4YON4iamXK9/66NkpzLayiyFe9/m+3Kr+aw5cwbKRKSjR2IPYzXQDpMBVWwPb6gfQOgdFDB5y3NvX+WN+cx1sKVuYOtyh7X07xUpsQgEdCzNhVWaUKiuu8e8iYxwN3j6jCkR84LF6zy0Js+kCIT213c6c2M+1PP5feksmlv0nFuzvZmmR/WTONOohVltmghRWPuP0G79KTSHN0cY2Dw7T0kZepmjez2Ji7t2F7wnBJrWWMya6V/OxMqMn+VrhrwqXolYvy/Mg7BMdGYjKwrGr24vEjahS75IQ1mqqMUFeRD2WGnj5YgpdSNyQAau9QwIiUhwsCr8tF4pT1u519jnC7Ue8l+eO+eWt33I4po0Tsq8OOdbX34xU31HAanvQJqOpr1zsBthKjDZOhIMdG8umGL4wQuS7YBCGgJg6VHI1F
 X17gltpm
 gK/3Gq5QUr+Yp/f9+Ocf4of92ID7ned4GWijAiIhY80U3Li78UPyxxUJTKgY9C0nBweZAKLrOagFLP2nZqpblRhXVeCs6bKPWFLZJf0CJdKAShFtEmcdij0IDHHwK3kyYUIP7inrk6Ae9FYqcgUi92QRRQxhSw22bF6a1ljwwheCck246YWdPZompBtj8x9/lJT8rZTBGvH7+HlRlL5Yx2KNH4tlU7c/svyVoNFoGaUT3ieoXz5mVskJ1o2KHgTdEC/88v6gL2nVMXUYtX1jlMjwFkS6ZnmeK8DYM/YgQI4D9Iwbf7ugoVsPVb7zDiCIj26qEf/Zf4t334635dRIPY+EsFa/Yw9AyRWxgQVllqgYE2wzgcksxKPW4qx1S2Ncvur6oWtwsPeXDNCPKAk7LaDHNhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kill cma_pages_valid() which only used in cma_release(), also
cleanup code duplication between cma pages valid checking and
cma memrange finding.

Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/cma.h |  1 -
 mm/cma.c            | 48 +++++++++++----------------------------------
 2 files changed, 11 insertions(+), 38 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 62d9c1cf6326..e5745d2aec55 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -49,7 +49,6 @@ extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 					struct cma **res_cma);
 extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
 			      bool no_warn);
-extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
diff --git a/mm/cma.c b/mm/cma.c
index 813e6dc7b095..fe3a9eaac4e5 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -942,36 +942,6 @@ struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
 	return page ? page_folio(page) : NULL;
 }
 
-bool cma_pages_valid(struct cma *cma, const struct page *pages,
-		     unsigned long count)
-{
-	unsigned long pfn, end;
-	int r;
-	struct cma_memrange *cmr;
-	bool ret;
-
-	if (!cma || !pages || count > cma->count)
-		return false;
-
-	pfn = page_to_pfn(pages);
-	ret = false;
-
-	for (r = 0; r < cma->nranges; r++) {
-		cmr = &cma->ranges[r];
-		end = cmr->base_pfn + cmr->count;
-		if (pfn >= cmr->base_pfn && pfn < end) {
-			ret = pfn + count <= end;
-			break;
-		}
-	}
-
-	if (!ret)
-		pr_debug("%s(page %p, count %lu)\n",
-				__func__, (void *)pages, count);
-
-	return ret;
-}
-
 /**
  * cma_release() - release allocated pages
  * @cma:   Contiguous memory region for which the allocation is performed.
@@ -991,23 +961,27 @@ bool cma_release(struct cma *cma, const struct page *pages,
 
 	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
 
-	if (!cma_pages_valid(cma, pages, count))
+	if (!cma || !pages || count > cma->count)
 		return false;
 
 	pfn = page_to_pfn(pages);
-	end_pfn = pfn + count;
 
 	for (r = 0; r < cma->nranges; r++) {
 		cmr = &cma->ranges[r];
-		if (pfn >= cmr->base_pfn &&
-		    pfn < (cmr->base_pfn + cmr->count)) {
-			VM_BUG_ON(end_pfn > cmr->base_pfn + cmr->count);
-			break;
+		end_pfn = cmr->base_pfn + cmr->count;
+		if (pfn >= cmr->base_pfn && pfn < end_pfn) {
+			if (pfn + count <= end_pfn)
+				break;
+
+			VM_WARN_ON_ONCE(1);
 		}
 	}
 
-	if (r == cma->nranges)
+	if (r == cma->nranges) {
+		pr_debug("%s(page %p, count %lu, no cma range matches the page range)\n",
+			 __func__, (void *)pages, count);
 		return false;
+	}
 
 	free_contig_range(pfn, count);
 	cma_clear_bitmap(cma, cmr, pfn, count);
-- 
2.27.0


