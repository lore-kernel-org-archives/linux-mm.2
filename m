Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2474BC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 02:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75536B0190; Wed, 12 Aug 2026 22:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4C706B0191; Wed, 12 Aug 2026 22:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89106B0194; Wed, 12 Aug 2026 22:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A75F96B0190
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:28:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23492A04E0
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:28:11 +0000 (UTC)
X-FDA: 85094661582.12.18C5701
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9DEAFC0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:28:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pry+E9fw;
	spf=pass (imf10.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786588089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbMrYczuLJGJ2Em3eI4fBqHwLZ3RULwhI9SXiSsO3yY=;
	b=twvE2mcKmyl3Wwoa4I7mPWiAVp7qo+1BU+hHVkBCrRdOyoq26DYXnN4YAonFzQfFV9RvXS
	V8ZXdgcgnr95HmKX29ZBRIRffiOTqdrZnwtUvTdKgrk8LwMwAWWGBeRZ8mTHpFz/LH7fVa
	mNT1eSC2qzvLBIkdeo9dL/Zs/oJl2Y4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pry+E9fw;
	spf=pass (imf10.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786588089;
	b=RUAnRP+YddPAYRmV7ZYxvgqs068ojBPSr55r9hKeJkk7i26GKjRX8xcAgB37188eutQ7oR
	WR55MXO3AAqdwuK1T7M2YUwlDqKr1r3d74hxMsWRSBAU4FJSpjQFok9ZTLZspOpLfQvR01
	6fC05uIYy1o9cGu89P7Pmuu17sWzKWk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EbMrYczuLJGJ2Em3eI4fBqHwLZ3RULwhI9SXiSsO3yY=;
	b=pry+E9fwsBwv5+gfkKkrYUgbSH5DYc87VcZVRIkyCaIn5DyWdzXPuAKQLnYAOE2kMM6GZZwDw
	v50K6iyVjwHsDt8J+pOaO32WeSCR3yl4wueowhdtTBcDxAull15C05mnMYMgrQcZH42Vm0JcyH6
	78lcIyKjvZ5aszcG/B9FW1o=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hL8Bn3RhLzLlTt;
	Thu, 13 Aug 2026 10:17:21 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id C70F04056C;
	Thu, 13 Aug 2026 10:27:58 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 13 Aug 2026 10:27:57 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <rppt@kernel.org>, <david@kernel.org>, <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <bp@alien8.de>,
	<byungchul@sk.com>, <gourry@gourry.net>, <joshua.hahnjy@gmail.com>,
	<liam@infradead.org>, <liaohua4@huawei.com>, <lilinjie8@huawei.com>,
	<linmiaohe@huawei.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<matthew.brost@intel.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<rakie.kim@sk.com>, <surenb@google.com>, <tony.luck@intel.com>,
	<vbabka@kernel.org>, <xieyuanbin1@huawei.com>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if MEMORY_FAILURE is enabled
Date: Thu, 13 Aug 2026 10:26:16 +0800
Message-ID: <20260813022616.9050-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <anxOypktGGq_9PZw@kernel.org>
References: <anxOypktGGq_9PZw@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9DEAFC0003
X-Stat-Signature: 1d1f3ecfmzab47yped9uq51irqwuzcjt
X-Rspam-User: 
X-HE-Tag: 1786588086-602198
X-HE-Meta: U2FsdGVkX1/7hddMWoryPKiK5CmgMf+qov9C0pXiY/NCAO0a2/XyAjdQGpo7Ca74W93gsRBHGczXkOoYt1bmedslCXRgBcukI74O6e9yfTH6DizXUmIj1oi2q8bPgfn2hZBaDf1Ijg0T+x9AOOq+EMmVO5dSUCYbx+2dJ3g9TtZuXX0uRaz0TYKceptpLbvCrvSn8fFbJjTweOFHKZdbaUIQRfTXqIE7nDCRnERnW6ROxENj3ahTQoRN2JcsltyhPND88AXjUj4G1l+0bHmbEaBiJyWgwutgo1x9YzpYoSSqGDVUmpXcKQv3uVSOxw84tMxSufc9L4+p/ykF+JbaAQVvlVix52XkNBcohhYweD9XqW6vAiJg6XJhlENwppRK2r2q8iFKL2vu1hEcF9HVuezbP6BIJOUtMYvNEln/RrHIq5s7ILlPo0GM3p0DjzWH60JYJlT0d58VAZwV6ddY3VLG4a1Y2OaGrgYoZ8cwXVDikMFsCtnSW0kGnnezYmBQDfWNrsShj1wQUtU/5k/LO61f37VmvIY2RvMlUGgwNPoz1SOSkLzzXY7VjeVpDF1idwh7kdBImvHqL7DT4m93t8t1IdCRZeuCdZ3KPXXTfDyMAdAVaLueRrTe9pP+FQEViolrJ+Rsv6jEUNDWv7cpowy5nDtsQ37EQPoJxXNlXUWZ06b6XpNHXnbFymGo3za/O79ONimEoYEQUr6eCL1fH8afKQmMpOeRZUr99HWk7lx0OzcXk8OcTIEeYSSks5b77Gu40V75Q7djvV0Af8gYhKiI7EZ9FulWaTik/GeNMLuPL1B87Hub7vxS6L70+UUosecHqRS6Rb05yY04V8eXly6HcGciFpx9qxt0aMw3eV7ZlCnqAWSRN8Il19dvouo4Mh7UygtIrG3MO0tnxLaI6b2QXK2KQPgD2HAxDJkQkVKOgjxiNUdme2Ao8gtX70FB2cOYBvmcCf4GuJODZZd
 ksvIDT3v
 7ICmKe6M6fZqxa7ozl8OAiU3EwSeMs1oPr3zZCjCWEwfTEfAQUnoXK4tpqcHa2isNawU/fuVuqyX9g3QaOA8idAN7nsgpKZyjv41Rl6WtvPPQbzh+yN7thuLNw3Rz6loRVY+O4GF4Yn/bskFvQNM3Ght52INgz1NAVas5IZD5vSgDFCWrd0razDj9QGZu5Ud6NuJdFd5jQGv0r4+3kaQFneAKXAzabpESaBycyBHvWuJZ7cBP11UdgCxH67D85UgJOX+/9R7RpS6aqPLGc/Ny0Jo0T9HqEk0SGSy+OIkWurrk86rAbSQO/BOnhq+nfS6Mxyz/oc8PuYyZZEjUJxgGRa0upYZX5PR6ojTOr6VDJQcvjGO2Fz3FFDJ0QeaLeMlosDsSuvzid4V+3bM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 13:45:30 +0300, Mike Rapoport wrote:
> Do we want to make users decide if they need MIGRATION when MEMORY_FAILURE
> is enabled?
>
> Just make MEMORY_FAILURE select MIGRATION.

I agree with this solution, but I discovered another way: just like
commit 6ebf98d71f9b509e833e ("mm: introduce CONFIG_NUMA_MIGRATION and
simplify CONFIG_MIGRATION") done, add CONFIG_MEMORY_FAILURE_MIGRATION
to select MIGRATION. The Modification is also very simple:
```patch
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a8b03e2920ba..500e54ace6c9 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1340,9 +1340,11 @@ static inline bool HWPoisonHandlable(struct page *page, unsigned long flags)
 	if (PageSlab(page))
 		return false;

+#ifdef CONFIG_MEMORY_FAILURE_MIGRATION
 	/* Soft offline could migrate movable_ops pages */
 	if ((flags & MF_SOFT_OFFLINE) && page_has_movable_ops(page))
 		return true;
+#endif

 	return PageLRU(page) || is_free_buddy_page(page);
 }
@@ -2028,7 +2030,8 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 		count_increased = true;
 	} else if (folio_test_hugetlb_freed(folio)) {
 		ret = MF_HUGETLB_FREED;
-	} else if (folio_test_hugetlb_migratable(folio)) {
+	} else if (IS_ENABLED(CONFIG_MEMORY_FAILURE_MIGRATION) &&
+		   folio_test_hugetlb_migratable(folio)) {
 		if (folio_try_get(folio)) {
 			ret = MF_HUGETLB_IN_USED;
 			count_increased = true;
@@ -2051,10 +2054,12 @@ static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 	 * Clearing hugetlb_migratable for hwpoisoned hugepages to prevent them
 	 * from being migrated by memory hotremove.
 	 */
+#ifdef CONFIG_MEMORY_FAILURE_MIGRATION
 	if (count_increased && folio_test_hugetlb_migratable(folio)) {
 		folio_clear_hugetlb_migratable(folio);
 		*migratable_cleared = true;
 	}
+#endif

 	spin_unlock_irq(&hugetlb_lock);
 	return ret;
@@ -2903,7 +2908,7 @@ static int soft_offline_in_use_page(struct page *page)
 		return 0;
 	}

-	isolated = isolate_folio_to_list(folio, &pagelist);
+	isolated = IS_ENABLED(CONFIG_MEMORY_FAILURE_MIGRATION) && isolate_folio_to_list(folio, &pagelist);

 	/*
 	 * If we succeed to isolate the folio, we grabbed another refcount on
```

Would this be a better way?

