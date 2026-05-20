Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5186ACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 02:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1B16B0005; Tue, 19 May 2026 22:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2EB6B0088; Tue, 19 May 2026 22:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8866B008A; Tue, 19 May 2026 22:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0858D6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:23:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D54D816155A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:23:05 +0000 (UTC)
X-FDA: 84786200730.29.82497E2
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0E65F120009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:23:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=perXELn6;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779243783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xESyquy9XilXzWqANuLJoTmgMkqpFkxFEj+q7nxzhzs=;
	b=73KJVN+Y5sid1h8SJ6UX3WMZEOhIlDsBmPpVxefD66THJAYJI8xZYbtGAAQ19FgdkLP/Aj
	zepm19wAD/IyBRSZTlgOm6VuL/n3s7AWiS3MOiV8W2EVpvqFDYp1ab1jq67cxGzjLgUMz9
	HSUQtcXyH87jcl0ZFalcPqwPPnWgMPM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779243783; a=rsa-sha256;
	cv=none;
	b=3JlyTn7lF5Xnlj51I9qc53rhIpYRgRlkLVDZ8cUoXm22oa5JGk/yTcStdszO9E1X0hOku0
	xXddR7uPbEzZIFWD2rrOevyX2fHjVK4ks3OhBaLxT0HFvP14C1uopPPF/L+I9xu6Q5yRJ+
	UpkdnMVrs0mxFYtz8Wn64c+h13mSqOE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=perXELn6;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xESyquy9XilXzWqANuLJoTmgMkqpFkxFEj+q7nxzhzs=;
	b=perXELn6JjszDpLp2P7vAjeVoHe55x9jI7ailgLmSf+1gOeC2D409KV5uyirKG7vrFdhmOiUG
	BtuhaaajwlujKFTwBMUMqyeuaMx7djalG6RnPDsMs95w8AMgvfakW+jJOUGS0kY5Bk5UT/3TmaQ
	H8XAu+btVw5qRlfhTdc+wSA=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gKw9j75QSzcb0K;
	Wed, 20 May 2026 10:15:21 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A0B7202E6;
	Wed, 20 May 2026 10:22:55 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemj100016.china.huawei.com
 (7.202.194.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 20 May
 2026 10:22:54 +0800
From: Wupeng Ma <mawupeng1@huawei.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
	<akpm@linux-foundation.org>, <ljs@kernel.org>, <Liam.Howlett@oracle.com>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<mike.kravetz@oracle.com>
CC: <mawupeng1@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3] mm/memory-failure: fix hugetlb_lock AA deadlock in get_huge_page_for_hwpoison
Date: Wed, 20 May 2026 10:01:28 +0800
Message-ID: <20260520020128.3506168-1-mawupeng1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0E65F120009
X-Stat-Signature: u6akjj34m3rp6ocoxft8tro4f8w63yq4
X-Rspam-User: 
X-HE-Tag: 1779243781-946680
X-HE-Meta: U2FsdGVkX1+WPKD3vrK1WK7Gjks9VaJzlzq/j2cRD+IYy9akC9ylRmRt6HkhwNe9BEAMnAMeCWoyApPGG6hhyZJZBdDnKeKUCRlQW5tQQiwXL86X3dP7Iyjs55zZm47m6JZ3YulPw9cADtOYeekmPD0mvhoAOXZVlekz7zQGbYSOOM64qaFahyWyPmXUCJhMy4+XBzAglYxKNrcnhMmCx16c5eaL+J9gZgMrvCkOwthajp6qWSIZqItPEQoqhVrYyYR9BpJuZMmxsZ6qmE9pnZ7jqh0FZkghcC6pIYBd4uQPF7+DwkBex1LOQ6TYcoTSe2S8KYRQep7KKAcKQfkAcu8gFnyvk7BfTnmEn8Ef1wMQn1SMVA1DUTJjmT0d3vvlePaPILlnseDCdqL5N9ibNPe/oLOjOWjeD48OBzpKurV2LqGSXrUbOHuqZSkBOtk7f8sS5q4MmLwsWnx9INZ93hcXA7YHGYXkmeCIxdHT/py+B2PR7nR+e+PtjsaH4m3eFG6ml43MXJc8nKNQ50tExKlVovqMc7PnlpY0m8hVPZw8OqghgDrTpDr7Miheee3NPOtGhe2Q4iu1KS2dZMsW/8fb37a0hNGwo6m1bAKWcLTytVWs3bO7mtxesc0/S0B3Xql8ihUZAY+LXpGr2r5Ui1CRUP4d1LTCUEs2ituW1E59I/bWhDuCrz6J+Y5DfegrnI/sJqf3g6HpihVni2NY/UU7xbxTCZRpzHFLUSvmKfB/q7fZIIMlmZ6B6HAZ+oG9+gP5OwT9zDrqNygiO3R3SWTgq2Xz9LyYvhq5giZhbLlzJNvNF/zIMFesFD+0S7BxnsTUikwvgjivrB78ZtxTWoPnglnXbhShV/cU+JNXpJ9GkBLsZsn9y9AsyP9ZweYARrMkrUjUJcQGk3DM6ja7fLK+mBCOMXPO1YO5SozQ/uP0jpG9NOKvsrsilIoIdeZ8yfOQYOiuTQubOjlGWLt
 2xmSjrvT
 MNo5j8bF56mRCOrrM4iH5thcY89AlUcYEU3d5ifJL4GW2SMRWK1hbZJoojXa6JTxO9I4SWkh9u7vlMjVnfw/epMSEhzjDOMd0TjZa4sSuXsRPfz7/C+pGO3TnHtbmEeX6vAEzK+XIR0sIiY34koXdB5mmpiRdds1R9v8M5xqqv8nKZDZfSc0hq1Z8JjgbUkdM2DtjhgZhQ1447kgR+OrAZOlgsZTj+1nROv3UsYpyLAbTNQRsXiFZnMOi539s9/ZaGyN/REq05TMThFhj1aH6hzkUUoIajyBeF+LrJVjdAdXJ8Vfoohe0W2vB0Wb3aDjH8MSdITW1R25MfiJVn8VEBUwmOKRP9Vt5jR4POQ0TLqnjugrkNkISPZl7ivRRMlVrQaS3Ido8Qm33sJZeJRR4AkhK9hw+1/K6MYjDZfOViCsJCWg/trjCpFGgpgLipKuVoHQE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise(MADV_HWPOISON) can trigger a recursive spinlock self-deadlock
(AA deadlock) on hugetlb_lock due to a race with concurrent folio
unmapping.  The race scenario:

  Thread 1 (madvise MADV_HWPOISON)          Thread 2 (unmap)
  -------------------------------          -----------------
  madvise_inject_error()
    get_user_pages_fast()  <- refcount++
    memory_failure(MF_COUNT_INCREASED)
      get_huge_page_for_hwpoison()
        spin_lock_irq(&hugetlb_lock)
        // refcount == 2 (gup + map)
        // MF_COUNT_INCREASED path:
        count_increased = true
                                           zap_pte_range()
                                             page_remove_rmap()
                                             put_page()  <- drops map ref
                                             // refcount: 2 -> 1
        hugetlb_update_hwpoison()
          -> MF_HUGETLB_FOLIO_PRE_POISONED
          -> goto out
        out:
          folio_put(folio)  <- drops gup ref
            // refcount: 1 -> 0
            free_huge_folio()
              spin_lock_irq(&hugetlb_lock)  <- AA DEADLOCK

When Thread 2's put_page() drops the mapping reference while Thread 1
holds hugetlb_lock, the folio refcount drops to 1.  The subsequent
folio_put() at the out: label frees the folio, and free_huge_folio()
attempts to re-acquire the non-recursive hugetlb_lock on the same CPU,
resulting in an AA self-deadlock.

The same deadlock can also occur on the folio_try_get() path: when a
migratable folio is found and folio_try_get() succeeds (refcount rises
to refcount+1), a concurrent unmap and a hugetlb_update_hwpoison()
returning pre-poisoned status will land at out: where folio_put() again
may free the folio under hugetlb_lock.

Fix this by removing the hugetlb_lock wrapper from hugetlb.c and
moving the lock acquisition directly into get_huge_page_for_hwpoison()
(formerly __get_huge_page_for_hwpoison) in memory-failure.c.  Place
spin_unlock_irq() before folio_put() at the out: label so that the
folio is always released outside the lock, preventing any recursive
lock acquisition.  Remove the now-incorrect "Called from hugetlb code
with hugetlb_lock held" comment, and update the stale
__get_huge_page_for_hwpoison declarations in include/linux/mm.h.

Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
---
 include/linux/hugetlb.h |  8 --------
 include/linux/mm.h      |  8 --------
 mm/hugetlb.c            | 11 -----------
 mm/memory-failure.c     |  8 ++++----
 4 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 65910437be1ca..aa3eb42e0a01a 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -153,8 +153,6 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
 bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
-int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-				bool *migratable_cleared);
 void folio_putback_hugetlb(struct folio *folio);
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
 void hugetlb_fix_reserve_counts(struct inode *inode);
@@ -422,12 +420,6 @@ static inline int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb,
 	return 0;
 }
 
-static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-					bool *migratable_cleared)
-{
-	return 0;
-}
-
 static inline void folio_putback_hugetlb(struct folio *folio)
 {
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index abb4963c1f064..46e5936dabaa8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4602,8 +4602,6 @@ extern int soft_offline_page(unsigned long pfn, int flags);
  */
 extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
-extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-					bool *migratable_cleared);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
 #else
@@ -4611,12 +4609,6 @@ static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
 }
 
-static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-					bool *migratable_cleared)
-{
-	return 0;
-}
-
 static inline void num_poisoned_pages_inc(unsigned long pfn)
 {
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 327eaa4074d39..4c99bb868ad08 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7170,17 +7170,6 @@ int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison
 	return ret;
 }
 
-int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-				bool *migratable_cleared)
-{
-	int ret;
-
-	spin_lock_irq(&hugetlb_lock);
-	ret = __get_huge_page_for_hwpoison(pfn, flags, migratable_cleared);
-	spin_unlock_irq(&hugetlb_lock);
-	return ret;
-}
-
 /**
  * folio_putback_hugetlb - unisolate a hugetlb folio
  * @folio: the isolated hugetlb folio
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d43613097..28522180cf7f8 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1966,10 +1966,7 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
 	folio_free_raw_hwp(folio, true);
 }
 
-/*
- * Called from hugetlb code with hugetlb_lock held.
- */
-int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
+static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				 bool *migratable_cleared)
 {
 	struct page *page = pfn_to_page(pfn);
@@ -1977,6 +1974,7 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 	bool count_increased = false;
 	int ret, rc;
 
+	spin_lock_irq(&hugetlb_lock);
 	if (!folio_test_hugetlb(folio)) {
 		ret = MF_HUGETLB_NON_HUGEPAGE;
 		goto out;
@@ -2013,8 +2011,10 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 		*migratable_cleared = true;
 	}
 
+	spin_unlock_irq(&hugetlb_lock);
 	return ret;
 out:
+	spin_unlock_irq(&hugetlb_lock);
 	if (count_increased)
 		folio_put(folio);
 	return ret;
-- 
2.43.0


