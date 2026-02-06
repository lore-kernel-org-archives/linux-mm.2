Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5507DEE20A0
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 13:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAABE6B0096; Fri,  6 Feb 2026 08:34:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95CF6B0098; Fri,  6 Feb 2026 08:34:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABF226B0099; Fri,  6 Feb 2026 08:34:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5866B0096
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:34:59 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4783EC07F3
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:34:59 +0000 (UTC)
X-FDA: 84414127518.29.F461AAB
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5710B40006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:34:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770384897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Ek9xXpyxB7RWqvoD0KJ9YQ7rIi4F0Xgb9AWn4cpPhqs=;
	b=5SNMoveBuWAPKH1X8RBpuFSxyky4V5JLwtCn6esdbooDYBqDbc5YvxQxO8s2Di2hFu4eau
	37Fu3cEG7+HYd84tKjZAPN2JC2mFEi167ih0myx8ITg8MqTzyzRju7cSWt7hp1bEpl3Pmb
	hY+soJjWqljezy3sjjqdF5SGA7EWBXI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770384897; a=rsa-sha256;
	cv=none;
	b=2p48CHFyulL77QlEZtDV50w677TJSBt1qdbCsRwGMtBzfPFSjzuZ39UbxulYOBg/RP/WMQ
	9C56X3C3NySG6UOHKdHWKvDFYviWm3hkQlwaArem8TO/Izw7gd+AZL8Z/T5yX0EfpogddG
	5pnb56chof1SBid+F7ed5gbFcae2DdI=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f6w645B89zJ46FB;
	Fri,  6 Feb 2026 21:33:48 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 1402840584;
	Fri,  6 Feb 2026 21:34:41 +0800 (CST)
Received: from mscphis00972.huawei.com (10.123.68.107) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 6 Feb 2026 16:34:40 +0300
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
To: <gladyshev.ilya1@h-partners.com>
CC: <gorbunov.ivan@h-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <alexander.grubnikov@huawei.com>, David
 Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry.yoo@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Will Deacon <will@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: make ref_unless functions unless_zero only
Date: Fri, 6 Feb 2026 13:33:02 +0000
Message-ID: <20260206133328.426921-1-gladyshev.ilya1@h-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.68.107]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Queue-Id: 5710B40006
X-Rspamd-Server: rspam07
X-Stat-Signature: d7ef1b8pn6z3hhb7jeigemy81997qr6r
X-HE-Tag: 1770384895-630779
X-HE-Meta: U2FsdGVkX1/Ks7Gnr8EnspEKzUcyJhEdy/0RZJESgl7DSszbetmIE2yJvzGgeKF4KGdeqfLPpbX9D1wwG4Ik9XLN6NGp1Yn7PZfZKBUdrSDnVumjYUc6IfPqUKZbCa/uv7JgaDAGfi7DbNTJ9RjVI5qqtJYtTOmFx3eA3L1n/jG3mKFhXaQr+S38TvuKKai4MH+EKC6yntzWhkfpKheWOOJzTzMjKNeR3NWtwHRzQBu8158yI6HG29Kiv9BznQi1NePWO8RohZ+MJFAOCiALJyYGSgwAIM9q3z5OYwAN2qgWCN5taRcJm8gMHQPXQz/0taus60W0FbEcufBIPNaYYv92wa7I4UAhJsR3SRI1cVc6VYaXIzbaHILutZsvy0f1HhWyIUS51Ee2b69gbNaEJiZOb2VMy2MIzXVrpzCX7q3AWlZab5pv8bjURWS7eTi5BJ9PRV3oFB1QsD0dw8DBR0VcTRDKJNdtw4iXVvCHhGMDIDvFe7IgCp5BMIaGH2xbxUzbzWjhiA5cqqdJKIGlOiDEWvbCuHEIKH2v6HJ68A8ANN8yxldlaD8vr+W4KiDuFur5VTfpKAylLrm2GvAA5GHPSdS22el3ocbdVyHMp+0wt724Lqj0i7UgHPZkzHK767JAR82mJRsRXHlbVroMw9iY5C1tLziWf8wqWzaRBz3N9SJzHudBE2iznxTvN3Pfy9PlxLiPLk7888+ljGGUZuDUiIFoSSxyWe01W8MAm2W/DUWM0hqBX6IC5nG3gVPHAs+jGq/sIBUNz+tOHDWcOYTTF7+whzUQVz6oUh2NqtwHftdi25LPYeIIE4jpbzky6JddUNeQ03QcHgawydfcTwB9PryYZxQq3T5K/BCj0qINW/zFZtcKN+d7RbUFtHlznVfX2NOLb0iKSesXt8T/3I7/kdSM13Sgv5ARQ//0IVklOEFhLjZzVLacFjWuw+KTFkpHd8XjFJkLk7J7/4G
 LoZP0xXq
 e8JQUtvx5r6OpFdcrIPGiSm+M78cQJ/oRu2V0XCQGrLYwnIseK5uAlc01MnYtp7lTHbRBKiSNt7fuD/9OMMceHSuS1F7YkLVw1tAvZ8klrahxnHOdbXcGOyTn5AhWFL+xOjoxeqle6P/kbES45P1BMEY7yCrh1ojfRqIYGsjYym60hqjZaKlqPvXvDA9eVTsH08vIhsUNpU4hoO9yRrML+hJmwZ3L9c1wBjBZh0qtrUr8wp8TBZFQHXLKOAUEyIH7s5R6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are no users of (folio/page)_ref_add_unless(page, nr, u) with
u != 0 [1] and all current users are "internal" for page refcounting API.
This allows us to safely drop this parameter and reduce function
semantics to the "unless zero" cases only, which will be optimized in
the following patch.

If needed, these functions for the u!=0 cases can be trivially
reintroduced later using the same atomic_add_unless operations as before.

[1]: The last user was dropped in v5.18 kernel, commit 27674ef6c73f
("mm: remove the extra ZONE_DEVICE struct page refcount"). There is no
trace of discussion as to why this cleanup wasn't done earlier.

Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h         |  2 +-
 include/linux/page-flags.h |  6 +++---
 include/linux/page_ref.h   | 14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f0d5be9dc736..0b30305512dc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1306,7 +1306,7 @@ static inline int folio_put_testzero(struct folio *folio)
  */
 static inline bool get_page_unless_zero(struct page *page)
 {
-	return page_ref_add_unless(page, 1, 0);
+	return page_ref_add_unless_zero(page, 1);
 }
 
 static inline struct folio *folio_get_nontail_page(struct page *page)
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c73..fb6a83fe88b0 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -231,7 +231,7 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
 	return page;
 }
 
-static __always_inline bool page_count_writable(const struct page *page, int u)
+static __always_inline bool page_count_writable(const struct page *page)
 {
 	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
 		return true;
@@ -257,7 +257,7 @@ static __always_inline bool page_count_writable(const struct page *page, int u)
 	 * The refcount check also prevents modification attempts to other (r/o)
 	 * tail pages that are not fake heads.
 	 */
-	if (atomic_read_acquire(&page->_refcount) == u)
+	if (!atomic_read_acquire(&page->_refcount))
 		return false;
 
 	return page_fixed_fake_head(page) == page;
@@ -268,7 +268,7 @@ static inline const struct page *page_fixed_fake_head(const struct page *page)
 	return page;
 }
 
-static inline bool page_count_writable(const struct page *page, int u)
+static inline bool page_count_writable(const struct page *page)
 {
 	return true;
 }
diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 544150d1d5fd..b0e3f4a4b4b8 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -228,14 +228,14 @@ static inline int folio_ref_dec_return(struct folio *folio)
 	return page_ref_dec_return(&folio->page);
 }
 
-static inline bool page_ref_add_unless(struct page *page, int nr, int u)
+static inline bool page_ref_add_unless_zero(struct page *page, int nr)
 {
 	bool ret = false;
 
 	rcu_read_lock();
 	/* avoid writing to the vmemmap area being remapped */
-	if (page_count_writable(page, u))
-		ret = atomic_add_unless(&page->_refcount, nr, u);
+	if (page_count_writable(page))
+		ret = atomic_add_unless(&page->_refcount, nr, 0);
 	rcu_read_unlock();
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
@@ -243,9 +243,9 @@ static inline bool page_ref_add_unless(struct page *page, int nr, int u)
 	return ret;
 }
 
-static inline bool folio_ref_add_unless(struct folio *folio, int nr, int u)
+static inline bool folio_ref_add_unless_zero(struct folio *folio, int nr)
 {
-	return page_ref_add_unless(&folio->page, nr, u);
+	return page_ref_add_unless_zero(&folio->page, nr);
 }
 
 /**
@@ -261,12 +261,12 @@ static inline bool folio_ref_add_unless(struct folio *folio, int nr, int u)
  */
 static inline bool folio_try_get(struct folio *folio)
 {
-	return folio_ref_add_unless(folio, 1, 0);
+	return folio_ref_add_unless_zero(folio, 1);
 }
 
 static inline bool folio_ref_try_add(struct folio *folio, int count)
 {
-	return folio_ref_add_unless(folio, count, 0);
+	return folio_ref_add_unless_zero(folio, count);
 }
 
 static inline int page_ref_freeze(struct page *page, int count)
-- 
2.43.0


