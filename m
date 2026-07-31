Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B0DC5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235536B009E; Fri, 31 Jul 2026 16:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5F66B009F; Fri, 31 Jul 2026 16:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123506B00A0; Fri, 31 Jul 2026 16:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDF906B009E
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 578211A0140
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:19 +0000 (UTC)
X-FDA: 85050158718.04.1DCC12B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id D29DA1A0002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="qJsf/3bM";
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2ER2w8+MMrXnv4m+kudfL9RHNepNzRG57k1o/CVENk=;
	b=GP10b2ysGE4b/5gZrckpFmu80gQO55LBxVJtmrqZyY+fF5EvEnShaj+FiuqVXIyokFFbLc
	JMCbowhOHBIRjSmsB6WZyqCUo90AlR3nVu6PIyrC7IG2pB5FShmYFuHH53Yq7K7UWJPMz7
	EjAXkAMyKO8u5b5eHLZujej5WAnrUe4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528497;
	b=FmAD7IO4qmDpWyknee7jhvHu0Tm4QKaKz3rZUPG3KDAd+Nh1n404OXnbnqDjP9Yha1Zzak
	u8jRctSrj6PkNJZT86Ijbb022iOYYkIknhINZOR6BBqIBF85ieHW3gjkdkoMRLdexIs/XI
	v6Zu+EfkA1sWye4aDQ3WZeJhKO4XiJg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="qJsf/3bM";
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=E2ER2w8+MMrXnv4m+kudfL9RHNepNzRG57k1o/CVENk=; b=qJsf/3bMrtj2dJEDjuQYieP0wM
	imeGJ0ZCm6W1R+mBxI7fQ7M39VFQPgA/mnlyG/cCEjl4JYDab6gYhR9YOJe8CZdHzBPC9RTEGC0EM
	bjHuCmJ7NCF+SJdoi9cO44GGlhAqv+u6Qx04Z/ScIEbf8+y4EwpSD7rGmwHp+uyFd1Mnf6zwe6t6z
	B3pEbUxkZ6OYFm0xMNxSwRbLhafjAxSUHRmjfsUOXIadqe4qPb4v17tdmn5S6OL1yFHpTfBODxcap
	FFpqIXHMUIA9LhsHDLLjuww4c2l7WtK7YGYirQgSSm9WU+e2W42TM35cOC/w/paXToiO5ZufbVhGa
	XXMArKzg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWW-00000002PfF-0X1B;
	Fri, 31 Jul 2026 20:08:04 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH v8 02/15] memory-failure: Prevent hugetlb freeing during unpoisoning
Date: Fri, 31 Jul 2026 21:07:47 +0100
Message-ID: <20260731200802.574821-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731200802.574821-1-willy@infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D29DA1A0002
X-Stat-Signature: of6an79y83iefijt7raxn854mfd11tnb
X-Rspam-User: 
X-HE-Tag: 1785528497-295310
X-HE-Meta: U2FsdGVkX1/5VlDq5kF37/+Q7cTHOFVxIk5t8jMGvggYvPSj1qcwEtocPROLwKzNxyu2Wjeww+4w02GH6QMYg+UpoAX0WpnKNOxOPmPkBzIQhtht2WZHQmu9CItxDdmAAY8hRDJTAO8i40OJXw99fVyZluToMhBBUalp7fUqJvFMmc0b0N7DmuHwD6B03JhOAlDBJysOz/03zLExqkyl09BfII8TagVEwL/Ktr3kn6mOiZ8ZncLT7Klh3pS9W66tSn0ueBpEtze61XtPLzT0CcwOgu0pesoUY4N91O7Iny702VV8c1VrjTfLXfms2irZyqOSZK0b5GKmqcC6SY7bjgnXeONO7NuFYbEC7y7ssJUgALFsMPd3ArhjT7HYlQCx5ZpI3k4r6nbiwSQNOUkvU/JWKwiXhQouIi2jJ8eQj4YEbAgpU0IrtbXxvO4MFvVyPMJgyrwyRcr88MZNwknupEZedAC+tVyB5fZ9tIIv9xKZjCfH12QBJDl1J74aIZXEfRTmaU0VhZaDBFdzszTTUeI1lZyVjlDipKxTsGsNg8GOgKS9auunY46EjmQg+m39XSd+xiGMDTfM+mVyyi/JZ8SYzyRQ56lqvpjBWOhY+yjZwNeN2CDDFFsUm7RwpEA/VYV/QgdPI0Nrzflag9g02gvTzQq458F+ao3jC08kxHdeGHs0Q6kYu1rpLY/Q1/JyBOS55ENmcDpt9eol+xUEwAGsuJsQHCBcZw8A1ALmSu9WlP6fjEMLOti5AZRjtyH3Z8JPX0cuaRQEDLOp6ZG6nDM+t1wxJAYE3fB1GmGhXrWgRxVrkCChCa0BSKxBYsAY2cbJSLlvPAamkwX/gvRtpaiU8VWYuBrXhhbqH3qIFQaQyT82MH9Q9dIebosV8aWbiCot+bvEzlLlf5Qts4h5ldb6DgdS2LYf7djNFy+SBlbgeOPuT0lRWCpTWkhAYshDW9bPI9TOCpL+U2mISUi
 KD8udngZ
 fEfrrxX/T3yyeLKKrIhvrwtq4aV1EpEjQw0oyK2nG0AtEYZSgg79d2RtOfCp06eoI1XI5CSyunEpPdz3Idq94KCE/ADPK1ZgS5KkBVcFZhVRCfoMmMUg/MqmRQyrCIsZXKFctq67rho0tiFER/KBZ9+iE4SsXZnWt/p6fKU4c//ylZ8lBBmCVM8WzWX8NNKDfvz1pnKItPiSZVY8C8Z9YQcWpF7eb7FhGD4n6bSaEoBDYlhjaneSqurpf2ouzQvhFwLKrEZbc26Zqs5K67GJl97z6gmnh2QLXSY9a8oEWrdMd3UuXbqhHFSTzTNfyU3dKoCcDIHg2Vf/oK5pH3r//Ph9phM3akDgrOvsXiIPpkU7Vd6iglD3rPU3QmptOQkZl8e46vSkuHt1ah+hYsuspWZ4sRoFjw6rGeal0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If we fail to get a reference on the hugetlb folio, then it might be
freed as we operate on it.  Prevent the freeing and the attendant races
around manipulation of the raw_hwp list by holding the hugetlb_lock,
which is also held by the hugetlb code when freeing hugetlb folios.

Fixes: ac5fcde0a96a ("mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/hugetlb.h | 19 +++++++++++++++++++
 mm/memory-failure.c     |  6 +++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2abaf99321e9..50eab2c23299 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -110,6 +110,17 @@ extern struct resv_map *resv_map_alloc(void);
 void resv_map_release(struct kref *ref);
 
 extern spinlock_t hugetlb_lock;
+
+static inline void hugetlb_lock_irq(void)
+{
+	spin_lock_irq(&hugetlb_lock);
+}
+
+static inline void hugetlb_unlock_irq(void)
+{
+	spin_unlock_irq(&hugetlb_lock);
+}
+
 extern int hugetlb_max_hstate __read_mostly;
 #define for_each_hstate(h) \
 	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
@@ -279,6 +290,14 @@ unsigned int arch_hugetlb_cma_order(void);
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
+static inline void hugetlb_lock_irq(void)
+{
+}
+
+static inline void hugetlb_unlock_irq(void)
+{
+}
+
 static inline void hugetlb_dup_vma_private(struct vm_area_struct *vma)
 {
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 944e6e1d4971..1dd0e7b99bb1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2725,13 +2725,17 @@ int unpoison_memory(unsigned long pfn)
 
 	ghp = get_hwpoison_page(p, MF_UNPOISON);
 	if (!ghp) {
+		hugetlb_lock_irq();
 		if (folio_test_hugetlb(folio)) {
 			huge = true;
 			count = folio_free_raw_hwp(folio, false);
-			if (count == 0)
+			if (count == 0) {
+				hugetlb_unlock_irq();
 				goto unlock_mutex;
+			}
 		}
 		ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
+		hugetlb_unlock_irq();
 	} else if (ghp < 0) {
 		if (ghp == -EHWPOISON) {
 			ret = put_page_back_buddy(p) ? 0 : -EBUSY;
-- 
2.47.3


