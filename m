Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E63D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2D736B031F; Thu, 22 Jan 2026 14:30:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD13F6B0321; Thu, 22 Jan 2026 14:30:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3DA6B0322; Thu, 22 Jan 2026 14:30:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD4EE6B031F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:30:26 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8986C1A0A7E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:30:26 +0000 (UTC)
X-FDA: 84360591252.08.1A752AA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id A590C120002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:30:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MOAuTiit;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vx3v1kWdLAeDnpT9dcpRX6ygzmWenOuVe38k+JYMvBg=;
	b=v7cd0w/ClB/KAQU42JnOr8jVhPNw0ntmVFSbPvn2y+NPgT/pPry2ucTPDUv5ADbVQ2BnMb
	5dfzaVEaz0WzYpXNz9WRoE/Iw1XYiC8mR1z5+CCT3BMwUcamWY3///e4Ei3TgxO80qWpEK
	CVOUZVw03SwyXQGqLaKB/WEig8+Kn4U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MOAuTiit;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110224; a=rsa-sha256;
	cv=none;
	b=jcG7nqWpqnRPzMQ8kh9q7+o0Q/3c1+fgLimOoXQT9w9pqBlEfSzCWstG488PHpw/eTW0Rz
	gT0vcZ6q4r4xuAcmZfdHUVWIq5IAoIgT2Ska7dM+SN6USVyEGYJGuH2BXiuxcMA1HIFUJf
	/yrzk01Q8Q/f25H8ZHces8Hy6hYGDUk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vx3v1kWdLAeDnpT9dcpRX6ygzmWenOuVe38k+JYMvBg=;
	b=MOAuTiit6DQi8O5WYZt3Zgu0eGFYD71ZhLdNkDkIyFMhVwH2Oc90lL7GtepIcCLHgv53HO
	hv5v0NCeL5V/bc9+g5DAh+s2m33qurhkS3scpU7ysWt1UGDv5q2aIGgcuC9xHX2VuK9Ryl
	5LJc3ZUdNvlJZ8vlp3oNlgN4DdDHTn0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-3LURbvBjM1OzzajpRT54qg-1; Thu,
 22 Jan 2026 14:30:19 -0500
X-MC-Unique: 3LURbvBjM1OzzajpRT54qg-1
X-Mimecast-MFC-AGG-ID: 3LURbvBjM1OzzajpRT54qg_1769110213
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 871C319560AA;
	Thu, 22 Jan 2026 19:30:12 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DBF5F1958DC2;
	Thu, 22 Jan 2026 19:30:01 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: npache@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	willy@infradead.org,
	peterx@redhat.com,
	wangkefeng.wang@huawei.com,
	usamaarif642@gmail.com,
	sunnanyong@huawei.com,
	vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com,
	yang@os.amperecomputing.com,
	kas@kernel.org,
	aarcange@redhat.com,
	raquini@redhat.com,
	anshuman.khandual@arm.com,
	catalin.marinas@arm.com,
	tiwai@suse.de,
	will@kernel.org,
	dave.hansen@linux.intel.com,
	jack@suse.cz,
	cl@gentwo.org,
	jglisse@google.com,
	zokeefe@google.com,
	rientjes@google.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com
Subject: [PATCH mm-unstable v14 01/16] mm: introduce is_pmd_order helper
Date: Thu, 22 Jan 2026 12:28:26 -0700
Message-ID: <20260122192841.128719-2-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NNn05zto8J6ALkahQuogJXLeMkm4z12AD0BKqgRLPGk_1769110213
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Stat-Signature: d1kwpp8i5gmutd41xq4qy3rsiru5kgb9
X-Rspam-User: 
X-Rspamd-Queue-Id: A590C120002
X-HE-Tag: 1769110224-102355
X-HE-Meta: U2FsdGVkX19wDaWV3qr7STFPse7Cf0ZHcvlYw/wKyd/3FQN9z823iGAH8WeWCoyN/cyZUoGFsDLvHRdiIkJtQfZHuIgXN+0hMh67ky2hAagfiWYdoRR7r7J4lbuR1zmJDm0nfluoW46jD5OaGTZ7qsJcLxD0oR3oxB1mUxNo6wOEq3gzP5bDv5PzcRZ6oP9Y3b6eOvGAK3kmh/6SNnXYFPSB77v9owV9A4zRv0A2LOfnWskSbVxnrf1O7OyDT40jWh3V1pyK+QDG00fnXY13IBs90qos1r5gtCrnJj63Y3IZW5C9Jz5KHcqXPJ0t1hQa4zo0ICS90zifaGrjKnAvBInJ2VWRUie68C1oFeQxgzwhvai/bqk1s85Q0/RxpDYk7j6GN5FKF8xfXTE5BrU70rST2V06QEgf6rmqxdPrBwseReK5ejcr1QKTO0npcacLY9Dbt/0dITvCLlRJrJIQQPmAnBGzcPQ68BP/RX3LGyncbsMfYhObY205ntS0jbd0troLfMT1j15v4t8mSr7uWQlbfAvOmlS3mXuoBfYdZRxmfJIE1otRZj1U7YnehqibN9C+ZOw5YW9Q6Uz3pfd2Wkum8JZLDUM1nb1M3EYDH/bft8bXGwwo9s9hXmRFMmmCppneSnI5BHsEtDXygy1bdOgT9gv8Vus+UIiBvR0PQpaMHBN+rkJmJ6aRClf6BKYrW8YPCuaOXQ47xHoQWHHM2AAKROtu/Q0CN+ytfAj6zS32vk/S7jN7dAignRyMBS/qpwfH1MPtEaw+bcLCSa6ZfqLEpQAIrxl7G8hn++6tnFfWlbGP2YJDZdZ3Na2/Ry/qWITWqfY5IZgZK+znOLPnwEplYpqBxK4q+fDqiVsQO+cwB5SpoqDVwDjSFQ6A76YZpKFzsQ5QSoq1qbowNycfI4MUfd2mMX0oqAjaEo8WTQpjR0naFFY9HlBgHSIPcW06jwZX6K4T2hnuB9L8H6y
 fajWez7q
 huMp6YhRDbY8rNmr4bP1jEPbFxqWFdUfoQ8PN3IrKnr1HIbF/oK0vukbT5EkqCvfchpWV05c5M/5+SGtQQ5wuXxhwkOQavFr8d+MBZ0XWnKAkDWeexFQPfB5NzYuLAbnWNIC7QCPqrby2LoYG035faCtVWztyULsPOkF1h6+NxqfyyZMSQWoMEGuQDh4DXyyMOy7JYdveCLQY6upnwYBsvZRsCGaE5kao5Yo42pPkJIeFwAUBy2wARBISkTGl/YyVZj39BYjSZKnw0B56HPRSNj/g31WO+P3HQX18edHL8aVVzmmy1oLozbnH836LtXYM7ZlddaNFjw0FWLC+G69yzre+K8/dzIyre3VmFP79i063qzZFupODIzeLNRhBV/DGX+i5Z0z0Xij++fe05WC+FMwFnfIm6X7CsdxVYBvwbRtwTNMWBd/LpoN/+lL1ZC52O0M4+iLpJvopdK2NqceE3+Fopqx+H7QO+s/8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to add mTHP support to khugepaged, we will often be checking if a
given order is (or is not) a PMD order. Some places in the kernel already
use this check, so lets create a simple helper function to keep the code clean
and readable.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 include/linux/huge_mm.h | 5 +++++
 mm/huge_memory.c        | 2 +-
 mm/khugepaged.c         | 4 ++--
 mm/mempolicy.c          | 2 +-
 mm/page_alloc.c         | 2 +-
 5 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfde..bd7f0e1d8094 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -771,6 +771,11 @@ static inline bool pmd_is_huge(pmd_t pmd)
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
index 44ff8a648afd..5eae85818635 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4097,7 +4097,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		i_mmap_unlock_read(mapping);
 out:
 	xas_destroy(&xas);
-	if (old_order == HPAGE_PMD_ORDER)
+	if (is_pmd_order(old_order))
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAILED);
 	return ret;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fba6aea5bea6..b85d00670d14 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2000,7 +2000,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		 * we locked the first folio, then a THP might be there already.
 		 * This will be discovered on the first iteration.
 		 */
-		if (folio_order(folio) == HPAGE_PMD_ORDER &&
+		if (is_pmd_order(folio_order(folio)) &&
 		    folio->index == start) {
 			/* Maybe PMD-mapped */
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
@@ -2327,7 +2327,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 			continue;
 		}
 
-		if (folio_order(folio) == HPAGE_PMD_ORDER &&
+		if (is_pmd_order(folio_order(folio)) &&
 		    folio->index == start) {
 			/* Maybe PMD-mapped */
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index dbd48502ac24..3802e52b01fc 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2450,7 +2450,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
-	    order == HPAGE_PMD_ORDER && ilx != NO_INTERLEAVE_INDEX) {
+	    is_pmd_order(order) && ilx != NO_INTERLEAVE_INDEX) {
 		/*
 		 * For hugepage allocation and non-interleave policy which
 		 * allows the current node (or other explicitly preferred
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e4104973e22f..e8a6d0d27b92 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -719,7 +719,7 @@ static inline bool pcp_allowed_order(unsigned int order)
 	if (order <= PAGE_ALLOC_COSTLY_ORDER)
 		return true;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (order == HPAGE_PMD_ORDER)
+	if (is_pmd_order(order))
 		return true;
 #endif
 	return false;
-- 
2.52.0


