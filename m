Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7097FD8FCF
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625A76B015A; Thu, 26 Feb 2026 11:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3E46B015C; Thu, 26 Feb 2026 11:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452416B015E; Thu, 26 Feb 2026 11:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1FACC6B015C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:28:07 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BFFB21402DC
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:28:06 +0000 (UTC)
X-FDA: 84487139772.09.9935DE5
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5A60D1C000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:28:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772123284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OTHNJJvHPvQjN2xeyejeP82xCwvLUcEn/ox/O4XGLWA=;
	b=7iwaKbt+l9vjfUg5OBoFh7jSH/YIXz1c9FiykHtQazhI56dDq+e70SdwZZVM56rESsmSpA
	LIbPBhmL9YDl7IV3sDuxxXlSFpxig6FSsX68HtNL4sK4ZAte60DI4jaeQM2vvy/Apy85+h
	qxgPc8HErYfzXpIVP95YKubx9JLiBiI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772123284; a=rsa-sha256;
	cv=none;
	b=Jf7ntFCEGVMAl1rZf2Tz8zEZIU55Hb/SzeDhgQxyptoCGCWIN54Rtdl8IDMelelEC2a3vj
	gmwTvv+0Tk0dRMn7ztZG3f+lVbGtMw/aMSk+BPoVaz/16eaTupuujSpG2sCoeWSgiD3XiJ
	rFb5k/DaS1Jw1qga1Ya28zLH9RAVwGo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fMH1M4PN9zJ46CD;
	Fri, 27 Feb 2026 00:27:35 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id B163D40587;
	Fri, 27 Feb 2026 00:28:00 +0800 (CST)
Received: from mscphis00972.huawei.com (10.123.68.107) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Feb 2026 19:28:00 +0300
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
To: Ilya Gladyshev <gladyshev.ilya1@h-partners.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R .
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Harry Yoo
	<harry.yoo@oracle.com>, Matthew Wilcox <willy@infradead.org>, Yu Zhao
	<yuzhao@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Gorbunov Ivan <gorbunov.ivan@h-partners.com>,
	Muchun Song <muchun.song@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Kiryl Shutsemau <kirill@shutemov.name>
Subject: [PATCH 1/1] mm: implement page refcount locking via dedicated bit
Date: Thu, 26 Feb 2026 16:27:23 +0000
Message-ID: <6bf6eba6e2e6a74e2045a3bd08d58fd91bece7be.1772120327.git.gladyshev.ilya1@h-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1772120327.git.gladyshev.ilya1@h-partners.com>
References: <cover.1772120327.git.gladyshev.ilya1@h-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.68.107]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: od8x1onayq6wib4mgno8r1uuzqq5zhx8
X-Rspamd-Queue-Id: 5A60D1C000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1772123284-482056
X-HE-Meta: U2FsdGVkX1/XBdwCTgSg41XT5SPSIfuuh87pQQn1pLPgyXOz+/Xg02+moHeqAsaPZVJXmqs+XVxvbXL9qTmcAjdQJNdC3/RFRTvDkhXryMpoLc2IjJLS5jByoK89f/i8675aQfs8zubdkue4nqJYFHvCAj0y67u1SpvshXQRiZkF2KajX5+IyqDvwCA5PXFVR4SHQeBvGAYYmIJW3cqsiy4aBM/9gW2xcRZw40VYJC3kFMpgNx107bKshTkPHAEnC7tEGHFzx6fULJIlvrbQ5X8r8AHtiJPhTB1DAPDRfwZ4vo80cU62WkFigxU5infL7dzs2gQdHw8JdkA3ooUjG9aI92ld/IvbwfHfilXLpylX+DSwuh2wy15QaXmk5YcWTxll5eTJ1XfDxtfSkcLGjPo/cyo/EeSN17wrkse+WmHBoYyRmFknZSam36cSyfzOhwYHKQNKRVs0oJIae48DAbxlutqdpUV3yGlLkSUm11L/sRWlFL4I9zsizKYtl73WJsvom+kjb6xuSXwhDDvnxQEnTp090QxUsC0C3ojFZwqwTOBsoASdR+B9CPN00UFgny8iKjq7vczOnqV0WPcAX+XJ9Vux0rCKI3D7SZq8uRuk1nD3UFRvMgV4WtwJeh+XzuZR3O3BLOiIb8u8UX49CQeWVCNw66Mj0ppU4+knvN19S/ysUeXCxS5JZyiHFjkMaryXpsjLudUzRs4x+G79U1bIcfIsgXvRezGW6F0DwFF1lutjYBhU/ksDy1drxCE3iejQs/RqRPl5G8fR9t7Ok4KhNREuN3H+xBhyUHwez3kefuGKjRqySvKC755Z6oJfIbZypfYrrgxN1Ye/Dk7r+cjX1GxZKijKfOZyrimIJg8QYinlTE0brOTAGrV8gGJ00yTdSlsxeA3rAdbA/nCadpmD15oDLseFA8WZj3UIImqpjvnR5BS9ow7V0vhZTE1KWOQsunKsCEtbF6YVY+j
 tnLyzTz0
 jiIiQQ3P6/XYSkWk2H20VSAFiYde9wmI/EpoLhvtkRg/RdNSTd4jtFYWtt5WSOYTRXgdNLadWUT6tFy4PM5mq5kzY7nnUiUoWvllmIctDwgkE1jJx/B+nE1CAq7zaFU84sot4+Bp2uIR4a6bp7mqQLqLgjc/r7se3NXI1Kh5sJHQ8ihLu8NihLBtG3cCyEfc7kQJefhaP9f/idEM9WzhjMknt9gVYcRsVqwE30LBxEH8/yuGaw5FlFzlhCa4dHQc8LbNg+WW/MW5ZYcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current atomic-based page refcount implementation treats zero
counter as dead and requires a compare-and-swap loop in folio_try_get()
to prevent incrementing a dead refcount. This CAS loop acts as a
serialization point and can become a significant bottleneck during
high-frequency file read operations.

This patch introduces FOLIO_LOCKED_BIT to distinguish between a
(temporary) zero refcount and a locked (dead/frozen) state. Because now
incrementing counter doesn't affect it's locked/unlocked state, it is
possible to use an optimistic atomic_add_return() in
page_ref_add_unless_zero() that operates independently of the locked bit.
The locked state is handled after the increment attempt, eliminating the
need for the CAS loop.

If locked state is detected after atomic_add(), pageref counter will be
reset using CAS loop, eliminating theoretical possibility of overflow.

Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
---
 include/linux/page-flags.h |  5 ++++-
 include/linux/page_ref.h   | 28 ++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7c2195baf4c1..f2a9302104eb 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -196,6 +196,9 @@ enum pageflags {
 
 #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
 
+/* Most significant bit in page refcount */
+#define PAGEREF_LOCKED_BIT	(1 << 31)
+
 #ifndef __GENERATING_BOUNDS_H
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
@@ -257,7 +260,7 @@ static __always_inline bool page_count_writable(const struct page *page)
 	 * The refcount check also prevents modification attempts to other (r/o)
 	 * tail pages that are not fake heads.
 	 */
-	if (!atomic_read_acquire(&page->_refcount))
+	if (atomic_read_acquire(&page->_refcount) & PAGEREF_LOCKED_BIT)
 		return false;
 
 	return page_fixed_fake_head(page) == page;
diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index b0e3f4a4b4b8..f2f2775af4bb 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -64,7 +64,12 @@ static inline void __page_ref_unfreeze(struct page *page, int v)
 
 static inline int page_ref_count(const struct page *page)
 {
-	return atomic_read(&page->_refcount);
+	int val = atomic_read(&page->_refcount);
+
+	if (unlikely(val & PAGEREF_LOCKED_BIT))
+		return 0;
+
+	return val;
 }
 
 /**
@@ -176,6 +181,9 @@ static inline int page_ref_sub_and_test(struct page *page, int nr)
 {
 	int ret = atomic_sub_and_test(nr, &page->_refcount);
 
+	if (ret)
+		ret = !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_LOCKED_BIT);
+
 	if (page_ref_tracepoint_active(page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -nr, ret);
 	return ret;
@@ -204,6 +212,9 @@ static inline int page_ref_dec_and_test(struct page *page)
 {
 	int ret = atomic_dec_and_test(&page->_refcount);
 
+	if (ret)
+		ret = !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_LOCKED_BIT);
+
 	if (page_ref_tracepoint_active(page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -1, ret);
 	return ret;
@@ -228,14 +239,23 @@ static inline int folio_ref_dec_return(struct folio *folio)
 	return page_ref_dec_return(&folio->page);
 }
 
+#define _PAGEREF_LOCKED_LIMIT	((1 << 30) | PAGEREF_LOCKED_BIT)
+
 static inline bool page_ref_add_unless_zero(struct page *page, int nr)
 {
 	bool ret = false;
+	int val;
 
 	rcu_read_lock();
 	/* avoid writing to the vmemmap area being remapped */
-	if (page_count_writable(page))
-		ret = atomic_add_unless(&page->_refcount, nr, 0);
+	if (page_count_writable(page)) {
+		val = atomic_add_return(nr, &page->_refcount);
+		ret = !(val & PAGEREF_LOCKED_BIT);
+
+		/* Undo atomic_add() if counter is locked and scary big */
+		while (unlikely((unsigned int)val >= _PAGEREF_LOCKED_LIMIT))
+			val = atomic_cmpxchg_relaxed(&page->_refcount, val, PAGEREF_LOCKED_BIT);
+	}
 	rcu_read_unlock();
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
@@ -271,7 +291,7 @@ static inline bool folio_ref_try_add(struct folio *folio, int count)
 
 static inline int page_ref_freeze(struct page *page, int count)
 {
-	int ret = likely(atomic_cmpxchg(&page->_refcount, count, 0) == count);
+	int ret = likely(atomic_cmpxchg(&page->_refcount, count, PAGEREF_LOCKED_BIT) == count);
 
 	if (page_ref_tracepoint_active(page_ref_freeze))
 		__page_ref_freeze(page, count, ret);
-- 
2.43.0


