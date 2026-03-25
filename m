Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3DB3103A9AD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0426B009B; Wed, 25 Mar 2026 07:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587AF6B009D; Wed, 25 Mar 2026 07:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 476DB6B009E; Wed, 25 Mar 2026 07:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35F9E6B009B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:41:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0845813BBD8
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:41:46 +0000 (UTC)
X-FDA: 84584395812.09.008D353
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1720D4000F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:41:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="AlY/SwMX";
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774438904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpAMGReJ5HEw2g+jWb2G48bdmeRb9Igjsn8yjS6J0Rk=;
	b=ZfkFEndy3FX0ildHuJ5sTTxJMMYGAcLC/An9vtnSBveqNrI3KajuB0eqhCqo7rImJv8kFK
	WsJuiCySQbOfUIwxRJxYSMPs1gfh+kJifV7HHVs5wVG7D/HPSxH8WfjhP5gKrPUaw8LXD3
	CcGJDZGtoPjQPL4TVnVnDsEjF5JFspo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774438904; a=rsa-sha256;
	cv=none;
	b=nDcVfzyaIfgZ4y95j+0ffRbtqYqpLYVpAMYFVkD4kos3LD14goasDaE1+0uqofehzRCvLu
	yx651lwP7vE4ig4+R5iK3Zx6Cq4jHVzL2cV9i/We//a1n8Xn8bgVprwOB/dbl6EFsfbLQ3
	8YnynrXxXnGvexf99ZkD1vLQYhdpLOs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="AlY/SwMX";
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774438903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wpAMGReJ5HEw2g+jWb2G48bdmeRb9Igjsn8yjS6J0Rk=;
	b=AlY/SwMX3OXFRqmT3qjz68eUZjR3szcsWTV2ugf9/hge5ofCXn+Fs4DQpq2r8nx0xwJc7u
	0HuVBXwyd7zbtI6vVhp/sFjx4wN0zpMb2Cs5QAlZliZyYjGGaeJ/mH4NlyFWI4jBKdS6T7
	8ZWgRnEK3Q7tAoMUloJ0bmS5czBBywE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-350-JdvYhEHNPr2E9QKuT4GmjA-1; Wed,
 25 Mar 2026 07:41:38 -0400
X-MC-Unique: JdvYhEHNPr2E9QKuT4GmjA-1
X-Mimecast-MFC-AGG-ID: JdvYhEHNPr2E9QKuT4GmjA_1774438893
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 690F519560AA;
	Wed, 25 Mar 2026 11:41:32 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.2.14.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C62E1800576;
	Wed, 25 Mar 2026 11:41:14 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jackmanb@google.com,
	jack@suse.cz,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: [PATCH mm-unstable v4 2/5] mm: introduce is_pmd_order helper
Date: Wed, 25 Mar 2026 05:40:19 -0600
Message-ID: <20260325114022.444081-3-npache@redhat.com>
In-Reply-To: <20260325114022.444081-1-npache@redhat.com>
References: <20260325114022.444081-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jy6UnWwm2MwRQS8U1j_JJ36Wmy3jEnXPUB-yRSgk1NA_1774438893
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 1720D4000F
X-Stat-Signature: im6y8zim4r4s6eqyctfeh5uqzf6ieaj7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774438903-179304
X-HE-Meta: U2FsdGVkX1/WhkzS6oy1wrhOenZwp8i9DpcO/dMbzXDtjOtXltP1EIBbqp85EdybDnQzBLYZ3mUwSY8K5eySiPZ16HgHdRcdXaAv0KmV5uPUNo9Y1XiPB5Vr7QBGM9y1KU0yS9C2KW588z4T0v6jE0Rlnvzjzin37irgLSDrpFtqOOiLWneg8W8d7rAf0bvk4rDU7nEpqqBjA2gAucD9TUm9WHJ4YIPd10ncg5sGlx6XOUceNIO59U1DlVG/kkD70r49AFG36uQ2ih+/CQwZTPfXAq+ClKMLDefyJFVissEEJEWc7+xeemMx6Kojru3eZZktydF415WyA3A7h4B2tDtEX+iiFHlyWz8ocQ0sZ3SMesME1Tl/9n4bEdzjJ8cP3fKJ2wB33FlPmZU9jWmx9PwLlO6sSx8SrFWVMHM8QnWmxjyjDEXffEwWrepX0n37z5ykhiO7o/C0aZ0b/7EZvJWH4LemHKyWXvqz3kIiAvOyKCoRuQ1oA5/1sBs/nN3/O1IyP0h8ytvPJQjr8zWhB6Y7QJdAM8zYVwwTH0EuZZft8R0bJuKRn63494ZCFnxhK8o6AzpQspUw/sOpZiiV7t61iLjizJ5tXCVweVqEuBCHq2zQKtDtwynudZ3Ow9dHU3m/g3GqM4PycdT84iZAWd8d7stHWRxCrePMCN9E/wyJ5OULDt2LUB1mG1FbztlHs4mDhPDcfH/uAzkjD2qOAcXBpDUpj5UE+CbIEiH3M9loPqgccjbb3m4dY6zpt3yEHQRp5Dsjq5Fa0QsfuKUoS3ObHzNhoNjVTsB93tmwxYFjYo3Txoghk+1M2xN4h0wNd0qjRm4xbZRmKJpUcvgFLYvd374ki4GUFG6EzylW5LfziYY04C8dtKYRieKBSNWwevy3WhGuEuzAtlaPU6VKJTUdWzKl9+T6u/XrGqxTwsFPBAAihLN68wu/Nf9HL4j1h0FQf89U8kasPcc05SE
 NBjhKrND
 bCVXzE1+QI8zEUcQJlBom7ljFT/fssSo28gTbQHcDio/+CF0XDrBcJDLPGdHpCIovvaUChqAcvho5LfhqGDLooaysXqymy5kL47WIcCokNLRbXgvMOk3Xs7ZTmlXALV2BEbIYm+xM2NsolP86J5elYgGdwHJOo5+vGEw2DnLAX68Ub/5IDvxnz5WEYPu+DQ4gEHJ+bsgiPk0bgNq7xw+TO0gf6pG2DQJiSwdt0/xwjw+ZAphXD3UG7E4nwcEDKLenkKSQx60N1oV3uSLGr3Q/497k7phJImYcSTSbSraDcfS3ITb4Qd1pY8ht2dMabt9YkTL3vqfas8IH/FcqTyjg62sEHzG8evq9R3qLLUwCmu/dbAiiOdCcyqNysQc7U45pmbbripnS4Lhh4gFCFQsItBxpCVFnKOXVQ0HwxPHnj9AWCTkoheqIKvhDKwCyxCqPSRWsel5R7izJxfhWZm0MSUfeMd0K+iVq8fhLAV31PtAHPKPY4Bxe7Hwy4Zvy7yssqK1uZtO4CvEVPAYvzm3grpL52hlf5lXPMAAs5Wf2h5Wlos4Ojbf699h2zhTYhnOQNc4yOaart3zv8YH+45MgCXBpNOvvNDn62JNieIV2fgt8Xjc6SaUjCfm3hPneGieZXFlU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to add mTHP support to khugepaged, we will often be checking if a
given order is (or is not) a PMD order. Some places in the kernel already
use this check, so lets create a simple helper function to keep the code
clean and readable.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/linux/huge_mm.h | 5 +++++
 mm/huge_memory.c        | 2 +-
 mm/khugepaged.c         | 6 +++---
 mm/memory.c             | 2 +-
 mm/mempolicy.c          | 2 +-
 mm/page_alloc.c         | 4 ++--
 mm/shmem.c              | 3 +--
 7 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c8799dca3b60..1258fa37e85b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -769,6 +769,11 @@ static inline bool pmd_is_huge(pmd_t pmd)
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+static inline bool is_pmd_order(unsigned int order)
+{
+	return order == HPAGE_PMD_ORDER;
+}
+
 static inline int split_folio_to_list_to_order(struct folio *folio,
 		struct list_head *list, int new_order)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2833b06d7498..b2a6060b3c20 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4118,7 +4118,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (old_order == HPAGE_PMD_ORDER)
+	if (is_pmd_order(old_order))
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
 	return ret;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6bd7a7c0632a..1f4609761294 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1547,7 +1547,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	if (IS_ERR(folio))
 		return SCAN_PAGE_NULL;
 
-	if (folio_order(folio) != HPAGE_PMD_ORDER) {
+	if (!is_pmd_order(folio_order(folio))) {
 		result = SCAN_PAGE_COMPOUND;
 		goto drop_folio;
 	}
@@ -2030,7 +2030,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		 * we locked the first folio, then a THP might be there already.
 		 * This will be discovered on the first iteration.
 		 */
-		if (folio_order(folio) == HPAGE_PMD_ORDER) {
+		if (is_pmd_order(folio_order(folio))) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			goto out_unlock;
 		}
@@ -2358,7 +2358,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 			continue;
 		}
 
-		if (folio_order(folio) == HPAGE_PMD_ORDER) {
+		if (is_pmd_order(folio_order(folio))) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			/*
 			 * PMD-sized THP implies that we can only try
diff --git a/mm/memory.c b/mm/memory.c
index 6396d32c348a..e44469f9cf65 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5573,7 +5573,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;
 
-	if (folio_order(folio) != HPAGE_PMD_ORDER)
+	if (!is_pmd_order(folio_order(folio)))
 		return ret;
 	page = &folio->page;
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index ff52fb94ff27..fd08771e2057 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2449,7 +2449,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
-	    order == HPAGE_PMD_ORDER && ilx != NO_INTERLEAVE_INDEX) {
+	    is_pmd_order(order) && ilx != NO_INTERLEAVE_INDEX) {
 		/*
 		 * For hugepage allocation and non-interleave policy which
 		 * allows the current node (or other explicitly preferred
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 915b6aef55d0..ee81f5c67c18 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -652,7 +652,7 @@ static inline unsigned int order_to_pindex(int migratetype, int order)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	bool movable;
 	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		VM_BUG_ON(order != HPAGE_PMD_ORDER);
+		VM_BUG_ON(!is_pmd_order(order));
 
 		movable = migratetype == MIGRATE_MOVABLE;
 
@@ -684,7 +684,7 @@ static inline bool pcp_allowed_order(unsigned int order)
 	if (order <= PAGE_ALLOC_COSTLY_ORDER)
 		return true;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (order == HPAGE_PMD_ORDER)
+	if (is_pmd_order(order))
 		return true;
 #endif
 	return false;
diff --git a/mm/shmem.c b/mm/shmem.c
index d00044257401..4ecefe02881d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5532,8 +5532,7 @@ static ssize_t thpsize_shmem_enabled_store(struct kobject *kobj,
 		spin_unlock(&huge_shmem_orders_lock);
 	} else if (sysfs_streq(buf, "inherit")) {
 		/* Do not override huge allocation policy with non-PMD sized mTHP */
-		if (shmem_huge == SHMEM_HUGE_FORCE &&
-		    order != HPAGE_PMD_ORDER)
+		if (shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
 			return -EINVAL;
 
 		spin_lock(&huge_shmem_orders_lock);
-- 
2.53.0


