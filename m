Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C946CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 01:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0D46B00A0; Thu, 21 May 2026 21:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 571506B00A1; Thu, 21 May 2026 21:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 461646B00A3; Thu, 21 May 2026 21:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 313AF6B00A0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:24:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABEC01C1923
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:24:44 +0000 (UTC)
X-FDA: 84793311288.07.56AC7C8
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1929140006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:24:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=dLCuvDnQ;
	spf=pass (imf27.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779413083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cBJvlhdX2BSZuFuaHgzoJ8EYhaT7BipLqr07dC7wr80=;
	b=3Xn/IocgKC1QXCx4w3mqLmFmbYn34CGUJ5CIl2Vs2kfkC6iyYGcW+XxlQhe69tR9Hhs6/R
	QEOFgyuUY0cZf1aRmWfEJH1gQ0W78yZA1dXqnSZn3hEluK2/aOhRv7L9TCli4rx3JN9o/6
	ViRoV9tXiepu7FEuvNnCOa+l+5dMb5U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=dLCuvDnQ;
	spf=pass (imf27.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779413083; a=rsa-sha256;
	cv=none;
	b=JPAyJOCpJ8sEV5g8VASCmVKppEodlGYgh2B2MX2QmzL8n4NRMGg79S/afGRecUqsCmIUlB
	thmsIdeUbom83JUUj+XltlrxN6vW8KuYLN0tqCLDWJVVyWNucHlTH4qsbeIbsMqFet5cku
	ldLPNWwQiw1ZohOsG/RQBzCE1tK408M=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cBJvlhdX2BSZuFuaHgzoJ8EYhaT7BipLqr07dC7wr80=;
	b=dLCuvDnQglDQSdOrCdk4gDNwpU4VnCtB0l+7+ui+QEU6WFA1xz0p5Fkr8SyMG/ygfHATVreRg
	XqH1Y95g+pWq8+mxPv0DdojQ9pL8JAoQmvYIL6SIYMFee6w9e29Z3bF9IjJvXuNheJRw15/Hy2B
	7QKvm5nBNmAoHUVFgzIt8ko=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gM6nr4TX9zpTLk;
	Fri, 22 May 2026 09:17:20 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 58DD9203AC;
	Fri, 22 May 2026 09:24:37 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemj100016.china.huawei.com
 (7.202.194.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Fri, 22 May
 2026 09:24:36 +0800
From: Wupeng Ma <mawupeng1@huawei.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
	<akpm@linux-foundation.org>, <ljs@kernel.org>, <Liam.Howlett@oracle.com>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>
CC: <mawupeng1@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH resend] mm/memory-failure: fix hugetlb_lock AA deadlock in get_huge_page_for_hwpoison
Date: Fri, 22 May 2026 09:03:05 +0800
Message-ID: <20260522010305.4099834-1-mawupeng1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Stat-Signature: gtubtgnsbxafksi151pbb78oo8afk1sj
X-Rspamd-Queue-Id: 1929140006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779413081-254002
X-HE-Meta: U2FsdGVkX18B3vwYL2xuyozrXiyQ8T6dQmaYHGcAxMnk47ABb4OPJ79cvlnYyf7YpZWY6d0wK2Hv4+hOwvFeiZiDnmf79mIzIr++KqThN3sv0hpkB9QAT0LdkqQrRYrVzeSxIfMd7hmFXyM4yrAV+ohfaq5+RYLVMNojmSJDgkrs8j+CX20QE67n9PTEByVw1y1cvBqg5S9q4uLR7XI0Q70Y4sD8Jp/PKSTaKEAcvsLsuvj/nuIJQ7znsX1m2E9UCLP5XDhNGbYKkfRgnAcC8OeSHpLSdVEQbBEVl8YvaYufVusxzN9aYANqueiZWORch4E5UguclEeSXX9QyGTN5JnXtfQDadadbFWJidYt0tSFZVNFjvkOZ38b+ykhYYIK47bTF4ZyWCe4gmxWbazXmYjbtN3l7SXMDiuQfrJZ+VRlMI/YtyUi3xq0IJ56JIruEl+IyJHMYi2NyhZfzDFNjPeZmyGQjRPZPlumTShcyj9FOvho8ND33u9Flxs8pGsprXGn8h+uOpA0r7L1C0L1zJUiwgAgIxNY9RNfl66PuQrMi4xfWzlV5fArC++OZosDycjY9yZo7WeVM7r+f+3up/DwjRperlSdLC9p0LBjGhrq4CQsGWRFz85cQSGX1nGHpbWgZOpMYq7CavBt0f3yTRCMrT8MKK+1/MZXNqefk8SNFWxFqLr5/ISgZ5jaMSN0rg19aLTxD+cOkjwFlBvwYQOsUj4I+dhOukBXN5CcVQKp66gFfV/5YSQG5rFX12I2UPUW59Hv9DSwUljRsOvUCPnGHwhFhGUlejKrZYp69sziazK5om5d1T4eeGDbuFovmNo67t6ddLrHVFI09GfzcFqxUcybsJdKjpXG13UmuwIZ5EixCiEOM1YJgOujXyNhcCl4XOhc0+K/CkcDGX/yuHxzGcRux4CAJ/pJACxHXsc3MAd8vREyt6/jKuZpwKauhhJIJGW+KwSO5phTRob
 o1C4iyKS
 utD9CpV6JoX4gKBH6xlhcvYz3vM0oLfNUv/68nMnEgki3x6Z7lBKm/O4lQebzbPjrfzxzoo9olN94dAUYjDM31dmnS5weAI7ouvnWl/+nAIvPs0vRWLZ8I6c1GP94fLsonvHwBPc+ZJWdJrZafVDmDEG2k0yqLFbUFdwp7s8wzdPo/ti1BXcaGvx7Zmz4X4IZdFsz3+7y1Qh4tA9MlnblpATIXWQ1j5uoJKp7F2eeltobexbadr8RbKPaEPOoEW5/hsYjCI0bPg4RNXqs8ToTQCBEnBFy1MHYsnNqdayt7Afwa//7ZOQOPLBND9dPZEiNYARveQMCccAs0jX9tMey8gMTdH52JG5cgMWYUn8Vo8SxPWLjNJ+efLdQz48ooK/jHPxYX72hkAPsTmMQQxf7RRt2zW1/pKk4H8EfuGfwgQseEEapZQnWzy0tx4nWhaA6D23RaRTHEbygtmaLTf1HQcYPEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two concurrent madvise(MADV_HWPOISON) calls on the same hugetlb page
can trigger a recursive spinlock self-deadlock (AA deadlock) on
hugetlb_lock when racing with a concurrent unmap:

  thread#0                              thread#1
  --------                              --------
  madvise(folio, MADV_HWPOISON)
    -> poisons the folio successfully
  madvise(folio, MADV_HWPOISON)         unmap(folio)
    try_memory_failure_hugetlb
      get_huge_page_for_hwpoison
        spin_lock_irq(&hugetlb_lock)    <- held
        __get_huge_page_for_hwpoison
          hugetlb_update_hwpoison()
            -> MF_HUGETLB_FOLIO_PRE_POISONED
          goto out:
            folio_put()
              refcount: 1 -> 0
              free_huge_folio()
                spin_lock_irqsave(&hugetlb_lock)
                  -> AA DEADLOCK!

The out: path in __get_huge_page_for_hwpoison() calls folio_put() to
drop the GUP reference while the hugetlb_lock is still held by the
hugetlb.c wrapper get_huge_page_for_hwpoison().  If concurrent unmap
has released the page table mapping reference, folio_put() drops the
folio refcount to zero, triggering free_huge_folio() which attempts
to re-acquire the non-recursive hugetlb_lock.

Fix this by moving hugetlb_lock acquisition from the hugetlb.c wrapper
into get_huge_page_for_hwpoison().  Place spin_unlock_irq() before the
folio_put() at the out: label so the folio is always released outside
the lock.

Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
---
Changelog since v3[1]:
 - update commit message to fit current issue  

[1]: https://lore.kernel.org/linux-mm/20260520020128.3506168-1-mawupeng1@huawei.com/ 
---
 include/linux/hugetlb.h |  8 --------
 include/linux/mm.h      |  8 --------
 mm/hugetlb.c            | 11 -----------
 mm/memory-failure.c     |  8 ++++----
 4 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 93418625d3c5..059749ed519f 100644
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
index 0b776907152e..4c4d1a61a6a7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4975,8 +4975,6 @@ extern int soft_offline_page(unsigned long pfn, int flags);
  */
 extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
-extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
-					bool *migratable_cleared);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
 #else
@@ -4984,12 +4982,6 @@ static inline void memory_failure_queue(unsigned long pfn, int flags)
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
index f24bf49be047..67243923fa24 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7154,17 +7154,6 @@ int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison
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
index ee42d4361309..28522180cf7f 100644
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

