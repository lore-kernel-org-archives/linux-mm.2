Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9815D78763
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 12:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0E2C6B0088; Fri, 19 Dec 2025 07:47:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C608F6B0092; Fri, 19 Dec 2025 07:47:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF136B008A; Fri, 19 Dec 2025 07:47:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B07C6B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:47:03 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 391461384BB
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:47:03 +0000 (UTC)
X-FDA: 84236195526.22.41A8903
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0CC5F80002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:47:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf30.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766148421; a=rsa-sha256;
	cv=none;
	b=Yr35Ybfk8rowDut9zN9phA7MRNVubFM5FvPRaNa6el1DOAV2Y+bQ0GOPVgAy7PL+HSZW8D
	HTbqKTz/p1DpKrIrG15SFtVMJJE+uVRheZvOfn0TiHKEFKG9JbjM9RMyH/3rCBrzvozQ9u
	I7fUItOIKn52ITnqRuRppBlAuh+faZU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf30.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766148421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fgc67cs5af5Hr0JkmeC3d4H1dLMhjzjVhiJpw6wcnOU=;
	b=lb+EjEbUPPp6z9AUdeb4ICCtQyJFkIBM45UxPDTR2qX4yhE6HYDUM7rZsbXrOOVg+0nkz9
	yTJavr8UHlohJTvrbtDUh3S3+WvUG3JtzdvlR1WuBQCo2LnltuhqznjjIRZCB2IFHyTz/P
	fkdb0kXQ9pC4r/Bm87fTfhiFyER/z80=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dXnN406H3zHnGk3;
	Fri, 19 Dec 2025 20:46:28 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 2362D40571;
	Fri, 19 Dec 2025 20:46:57 +0800 (CST)
Received: from mscphis00972.huawei.com (10.123.68.107) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Dec 2025 15:46:56 +0300
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
To: <patchwork@huawei.com>
CC: <guohanjun@huawei.com>, <wangkefeng.wang@huawei.com>,
	<weiyongjun1@huawei.com>, <yusongping@huawei.com>, <leijitang@huawei.com>,
	<artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<alexander.grubnikov@huawei.com>, <gorbunov.ivan@h-partners.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<harry.yoo@oracle.com>, <willy@infradead.org>,
	<gladyshev.ilya1@h-partners.com>, <yuzhao@google.com>,
	<baolin.wang@linux.alibaba.com>, <muchun.song@linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 2/2] mm: implement page refcount locking via dedicated bit
Date: Fri, 19 Dec 2025 12:46:39 +0000
Message-ID: <81e3c45f49bdac231e831ec7ba09ef42fbb77930.1766145604.git.gladyshev.ilya1@h-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.68.107]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 0CC5F80002
X-Stat-Signature: wgpnyr8px6fu39r1ezhfg4cf3ca3kg1s
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766148420-424464
X-HE-Meta: U2FsdGVkX19seQpE/4zO2wBgSLYm/uvL4XMMZPd/WTBzAVDh2IaiC0M5iOSvkMQT9KsyhcA535RiPlluqBnDSoNAvDOcjWX94GV8NPXsYe+EU1+RaZh7LokX22e1osSD+EGvNiugLK2F6t6ym1waqTodhRWDp1sNgRh3HkfoCj07G6x/I/NTHD2KJTatARl1bwloyy2c/k+bKvVoMfZcKI90/TQ1M+n3urViphIACBqdsr5ilbIAYaJsDbl1lKyT1hY8Eob+uG7StNzurWDv2saXGqTAF7NWrwOObyIJts4ds387ahK/ZeWwrJki9hf0A1FmBAw3p9ABiuwmm7qIAMKr5OZJjdC5FpW7TB4pMOq93vWKn0zMdZcnmwCSb4PIrpwN4g71YRgmdE+GJNKDB0eDGcGWQTqvGbjZrTBj6M+4SLl2jcjrcLMNoLm7G9HncRovrIqWfvogdIIDtu5/NwjEPenlgRT3OKbEcr4HyWBNIfdCERVebFZoLik5Gaow1q/ID9f/cL3qpkEH+TfCjnfLKuLCitN3eUlO8JLTrBzh1UtoEFVLvP9MDwDLX+kX/Rx68A8Qicy9aZInihIldcWol+7v1eohp6fF4Iej2lj56KSwKB2UbBThjLdcO0C3ERas+TZ8YGRTrIt3Yc1/ZxjtgjRwRhDmvVD3jTnalSdpOCszWU0RzFZud+nXhLWssTeI6PLIbMBULGccpqno25TYvUFT7X96vpFNxdoICYvlN2+5Jc5wKjmk2qP/8zZ7/R/kL1JT2Yg6sd8bCnh+Ixn3g4DtraJt0lCKFz2QDR23cZh9SQo2EZVhlq3+zbfzljk85q5wQVDKMoNMlMzNCh1nNKyDf7wKxzofoKnInURDZuKU9Hx4aNhAl6MYC5gnvGMtVnCVxk+wDlqFZjex+17+xtRPISQ/IdWfHJUKharMts8IeW8jEi0CUXJ/7SjkNYUN7EAtu/SuDVmr9L2
 6b0C1W4I
 fP6eVd5njQBpdmkJzVMhvw9TIUSjRC/2VHLKk5JM7uDliwRF89wNtkO6JbFsMtSOYjFXfOq88ibA/Y5eOzcZB5nAofaGvCJm440v2yeFgMnUXfz4b5O90lJaWEB+hm+0GOpe3vxCCiVnWEwcQ3pVh0VzpO0xY9RGtY/O4ru4yqOOKv6lEYq+h6uNgUOxAyTJSkkYvq6dWPQ6bgtAZAsYFObjpEHiPcfxbfA30YhpRBBFkh5EF5nLDEYvy+/22e1Pmsfu/3yqBBsLZGg8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
possible to use an optimistic atomic_fetch_add() in
page_ref_add_unless_zero() that operates independently of the locked bit.
The locked state is handled after the increment attempt, eliminating the
need for the CAS loop.

Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
---
 include/linux/page-flags.h |  5 ++++-
 include/linux/page_ref.h   | 25 +++++++++++++++++++++----
 2 files changed, 25 insertions(+), 5 deletions(-)

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
index b0e3f4a4b4b8..98717fd25306 100644
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
@@ -231,11 +242,17 @@ static inline int folio_ref_dec_return(struct folio *folio)
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
+		if (unlikely(!ret))
+			atomic_cmpxchg_relaxed(&page->_refcount, val, PAGEREF_LOCKED_BIT);
+	}
 	rcu_read_unlock();
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
@@ -271,7 +288,7 @@ static inline bool folio_ref_try_add(struct folio *folio, int count)
 
 static inline int page_ref_freeze(struct page *page, int count)
 {
-	int ret = likely(atomic_cmpxchg(&page->_refcount, count, 0) == count);
+	int ret = likely(atomic_cmpxchg(&page->_refcount, count, PAGEREF_LOCKED_BIT) == count);
 
 	if (page_ref_tracepoint_active(page_ref_freeze))
 		__page_ref_freeze(page, count, ret);
-- 
2.43.0


