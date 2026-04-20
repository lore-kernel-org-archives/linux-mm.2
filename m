Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB9C8F36C51
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 08:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CDD6B0089; Mon, 20 Apr 2026 04:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A277C6B008A; Mon, 20 Apr 2026 04:02:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD3A6B0093; Mon, 20 Apr 2026 04:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1DF6B0089
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 04:02:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 303158C806
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:02:04 +0000 (UTC)
X-FDA: 84678190968.14.652B5FB
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf21.hostedemail.com (Postfix) with ESMTP id 23BC31C000F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:02:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of gorbunov.ivan@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gorbunov.ivan@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776672122; a=rsa-sha256;
	cv=none;
	b=SLOPrn3Yz5vSG0XhcECADoWtE5ok0mdtwXgUCmgk9+EDUqPnhVJd4UwCDOshUcpLvCfnga
	6jhbinmchY8RIljnpMs7lYx+b4YBfRDsU5+cXDwvt2cfbQuvNV1xTsrbK5Mjmy4nfGfxZt
	wawuwp2zTKHO8O35AKNmCHf7WQ0qiFQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of gorbunov.ivan@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gorbunov.ivan@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776672122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5RaFZFPy3SIJiwVMclRqUEKDDyAcSmOftiMuifnf0Ec=;
	b=a+TUefr8FjPAVCxFJS+9sg2Ymais1WWScY/HMSrtbvuS4wXyyLH5jNGORt5yApQm04/qfj
	OchElFWD12eD3A4b7dms6I5DMLY7PuojWbs/8i6eiKPj1nbR+qumCWBJDBFDwrtiLOJeja
	+obGQhkJf1CMrgoC/7bjEmM6PGEP8uk=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fzdGX5JK7zJ46Bd;
	Mon, 20 Apr 2026 16:01:08 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id BF04440577;
	Mon, 20 Apr 2026 16:01:59 +0800 (CST)
Received: from mscphis04371.huawei.com (10.123.69.39) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Apr 2026 11:01:59 +0300
From: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
To: <gorbunov.ivan@h-partners.com>
CC: <david@kernel.org>, <Liam.Howlett@oracle.com>,
	<akpm@linux-foundation.org>, <apopple@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <gladyshev.ilya1@h-partners.com>,
	<harry.yoo@oracle.com>, <kirill@shutemov.name>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <mhocko@suse.com>, <muchun.song@linux.dev>,
	<rppt@kernel.org>, <surenb@google.com>, <torvalds@linuxfoundation.org>,
	<vbabka@suse.cz>, <willy@infradead.org>, <yuzhao@google.com>,
	<ziy@nvidia.com>, <artem.kuzin@huawei.com>
Subject: [PATCH v2 2/2] mm: implement page refcount locking via dedicated bit
Date: Mon, 20 Apr 2026 08:01:19 +0000
Message-ID: <9936cc799ac8b637ee58ae3bf6ec0e5eeb5306e9.1776350895.git.gorbunov.ivan@h-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1776350895.git.gorbunov.ivan@h-partners.com>
References: <cover.1776350895.git.gorbunov.ivan@h-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.69.39]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam10
X-Stat-Signature: c8pykqrxx67a8mmku3rhn4hg9oyfjbs6
X-Rspam-User: 
X-Rspamd-Queue-Id: 23BC31C000F
X-HE-Tag: 1776672121-828517
X-HE-Meta: U2FsdGVkX19tMN5NBgj1Y7pZlMR9XVLYNKGZme6WCHjajsY3K73ygzrsWVJM8QfAN6udoAS38gT4SMIIhFb5RhYYARmXp/VvEHOqRLdZgND/Pi0Z6COV6opslVs/orLlpiOUbE/Hxef2cJkBHUiMYzM/PKNYAlThVhDy/+G1bASuhKg+J8ZXDwYzuGDnP7FiJu2p+Z6GxKZB7vFZOsUmGsUKQHQw8lHu2bjyPJ09X24xADkOaEiX/jFeeKR6VF7Ty9PvRRpjq3TNRjsLVaoICsIfvKRk3tIvWPn+olva/u4LkbG3YTnlQd5ajJg0C/i+6Vw2Wz6nPkwB33u5WMdzFSZcC6j+qAisplqkgr3YMNsv/XER2n/6HxqMjq5MQAgD3doSgWPfd2kPs5WQCHt611OZiddPbS69Uc44vI0Xx2XZ4gPTykhcLKwa1l2qAd0QfVEgeOz4M+8x/NMBJvMoxoWedSmCHl4hFV3v2kHzkpF8QCqfE6mqpfvxqMTIgVnpQW50y9SG9Dfj6bDIUgIb5WfSNqLQBaAn4sobOiuxljJY1jtcjk/SE7JwASAx2vQ5u1OFYxCCWxAFAYDmIm85QEKp5TXO7D4HhVDMlJyZ2OAflnlwOgnDLquB6OfQN79c30RKWESy+pnsY09bMN8VB2RkfE2SeUsUOrw0sI38Pr1+k0LKYoSnuBGoQKogSWzI5MCnZ3jLT4qwEikRkmZscLAYyf4AiAG/WaIgzJa9CJ8/9cdqhSWq6blxQfdSF2NrvVkTE9XW6wf5YZ1Eqvp6tWnWr/5e36NPxjGueTpe3p9O/PSoo9Id3Hkt7Mhp5yarseBa7R9aOF37sp+wZiLkEq0kiayxKkhh7tb/MejReShcPddNYkV4VdOiiKT18kjlekZa529qizJTosjxPPocXHrFn3+a1iU9RPWVH9528XpnYrEQXCs6g8AewnHzGBC+FRZMyNjWvGjV1sYh1cR
 c1vPd086
 KBIw9Afs5vqSp5Yn42U/imbxaMhOKjqiYIlYzXwF6keYv6p9JHIwGUAWOTxGNyfwAOIbOx82WPc0knoJVAEFjhjCAJwgu8QU9Dyy/iJ6JBQjx/QaWr6QMOLARGmSshEJCP1dwYXWSPeemSpYwDpm9PhwpYiHAmU7K3FMgbyM1EAcRSHNScJmIapNmtuLxY+V9SqHz++GssJ8bQQxugpKDOshuO/RCQBhgkAz+om6jsVmuLhPlI7vfdRXNdPM3dnR+364wJXlGESV8MqjG1OFl+2QqayD5JgaxWgcN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>

The current atomic-based page refcount implementation treats zero
counter as dead and requires a compare-and-swap loop in folio_try_get()
to prevent incrementing a dead refcount. This CAS loop acts as a
serialization point and can become a significant bottleneck during
high-frequency file read operations.

This patch introduces PAGEREF_FROZEN_BIT to distinguish between a
(temporary) zero refcount and a locked (dead/frozen) state. Because now
incrementing counter doesn't affect it's locked/unlocked state, it is
possible to use an optimistic atomic_add_return() in
page_ref_add_unless_zero() that operates independently of the locked bit.
The locked state is handled after the increment attempt, eliminating the
need for the CAS loop.

If locked state is detected after atomic_add(), pageref counter will be
reset with CAS loop, eliminating theoretical possibility of overflow.

Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Acked-by: Linus Torvalds <torvalds@linuxfoundation.org>

---
 include/linux/page-flags.h | 13 +++++++++++++
 include/linux/page_ref.h   | 28 ++++++++++++++++++++++++----
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0e03d816e8b9..b3e3da91a90a 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -196,6 +196,19 @@ enum pageflags {
 
 #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
 
+/* Most significant bit in page refcount */
+#define PAGEREF_FROZEN_BIT BIT(31)
+
+/* Page reference counter can be in 4 logical states,
+ * which are described below with their value representation
+ *        state              |         value
+ * (1)  safe with  owners    |   1...INT_MAX
+ * (2)  safe with no owners  |         0
+ * (3)  frozen               |  INT_MIN....-1
+ *
+ * State (2) can be only temporally inside dec_and_test.
+ */
+
 #ifndef __GENERATING_BOUNDS_H
 
 /*
diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index a7a07b61d2ae..32194e953674 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -64,12 +64,17 @@ static inline void __page_ref_unfreeze(struct page *page, int v)
 
 static inline bool __page_count_is_frozen(int count)
 {
-	return count == 0;
+	return count > 0 && !((count & PAGEREF_FROZEN_BIT) != 0);
 }
 
 static inline int page_ref_count(const struct page *page)
 {
-	return atomic_read(&page->_refcount);
+	int val = atomic_read(&page->_refcount);
+
+	if (unlikely(val & PAGEREF_FROZEN_BIT))
+		return 0;
+
+	return val;
 }
 
 /**
@@ -191,6 +196,9 @@ static inline int page_ref_sub_and_test(struct page *page, int nr)
 {
 	int ret = atomic_sub_and_test(nr, &page->_refcount);
 
+	if (ret)
+		ret = !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_FROZEN_BIT);
+
 	if (page_ref_tracepoint_active(page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -nr, ret);
 	return ret;
@@ -220,6 +228,9 @@ static inline int page_ref_dec_and_test(struct page *page)
 {
 	int ret = atomic_dec_and_test(&page->_refcount);
 
+	if (ret)
+		ret = !atomic_cmpxchg_relaxed(&page->_refcount, 0, PAGEREF_FROZEN_BIT);
+
 	if (page_ref_tracepoint_active(page_ref_mod_and_test))
 		__page_ref_mod_and_test(page, -1, ret);
 	return ret;
@@ -245,9 +256,18 @@ static inline int folio_ref_dec_return(struct folio *folio)
 	return page_ref_dec_return(&folio->page);
 }
 
+#define _PAGEREF_FROZEN_LIMIT	((1 << 30) | PAGEREF_FROZEN_BIT)
+
 static inline bool page_ref_add_unless_zero(struct page *page, int nr)
 {
-	bool ret = atomic_add_unless(&page->_refcount, nr, 0);
+	bool ret = false;
+	int val = atomic_add_return(nr, &page->_refcount);
+	// See PAGEREF_FROZEN_BIT declaration in page-flags.h for details
+	ret = !(val & PAGEREF_FROZEN_BIT);
+
+	/* Undo atomic_add() if counter is locked and scary big */
+	while (unlikely((unsigned int)val >= _PAGEREF_FROZEN_LIMIT))
+		val = atomic_cmpxchg_relaxed(&page->_refcount, val, PAGEREF_FROZEN_BIT);
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
 		__page_ref_mod_unless(page, nr, ret);
@@ -282,7 +302,7 @@ static inline bool folio_ref_try_add(struct folio *folio, int count)
 
 static inline int page_ref_freeze(struct page *page, int count)
 {
-	int ret = likely(atomic_cmpxchg(&page->_refcount, count, 0) == count);
+	int ret = likely(atomic_cmpxchg(&page->_refcount, count, PAGEREF_FROZEN_BIT) == count);
 
 	if (page_ref_tracepoint_active(page_ref_freeze))
 		__page_ref_freeze(page, count, ret);
-- 
2.43.0


