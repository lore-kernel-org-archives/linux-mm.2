Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 834B9EB270C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2356B008A; Wed, 11 Feb 2026 21:19:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F8A6B008C; Wed, 11 Feb 2026 21:19:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58B86B0092; Wed, 11 Feb 2026 21:19:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4D6D6B008A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:19:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C8E2C26A7
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:19:25 +0000 (UTC)
X-FDA: 84434197890.01.B9EC5CB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 882A740004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:19:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="XACn8/l3";
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770862763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OMwzVZ6Pva3OZZvdMPb7Ru0uN6OFYrizNjTFcvvE/ds=;
	b=lM7gsWA3RnzgOzZP+BxLjIslVkxG3xDa6j8kWEU5y9pEcWjXRIK6PcjhUnWGhXoh34v7sS
	BYkBzORNIvWfa/RcbmInVqkNXLvZ2GSt9xn84eWaHf353yd0DwYNQ3pis1AtbXLpOjBH6f
	U3rKnMYDoRgfTbK0weWjdY/FI0rYQ2A=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="XACn8/l3";
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770862763; a=rsa-sha256;
	cv=none;
	b=6oMJyLdvkcjg1yfWVV8HSbyqy/SXKxVctv+JgwN/tBFJmaNe62FGgWV2WfKaTRTY/9pVh+
	CaRJrt8JEq0cNQjqjWDLcehRddxeQuB8c5Pd1XQILVvP4dTpfYLfhz+3Z76foQqhVxTGbr
	79o6tUtgJno9TyczEondTT1Xn/DU25Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770862762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OMwzVZ6Pva3OZZvdMPb7Ru0uN6OFYrizNjTFcvvE/ds=;
	b=XACn8/l3TV84q4eii10AT8gL6U70Fmo+CGUfQP32afDK2mf9iIl1Q47GWQeEhcdX3Tijw/
	dumxjF+RxBIlm7KpHLU872uOSaL4NseKhVblRGmFrIBlYBEcOgPXrlrMKHFF7r9hfjAg92
	yP4esFJTNi4b2H/W8aa5rzlFAyJqUdc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-260-vPFQ2WpoNsm1-SjfiRAnJQ-1; Wed,
 11 Feb 2026 21:19:19 -0500
X-MC-Unique: vPFQ2WpoNsm1-SjfiRAnJQ-1
X-Mimecast-MFC-AGG-ID: vPFQ2WpoNsm1-SjfiRAnJQ_1770862754
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BEE751800352;
	Thu, 12 Feb 2026 02:19:12 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.91])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8D8B91956053;
	Thu, 12 Feb 2026 02:19:02 +0000 (UTC)
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
Subject: [PATCH mm-unstable v1 2/5] mm: introduce is_pmd_order helper
Date: Wed, 11 Feb 2026 19:18:32 -0700
Message-ID: <20260212021835.17755-3-npache@redhat.com>
In-Reply-To: <20260212021835.17755-1-npache@redhat.com>
References: <20260212021835.17755-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CIV9C_2_j0oRKdQJwade5FnOLfkwyXbP_Ewt40bXfKk_1770862754
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: hqw4zn6tynaaiytb5z91ct3nz61o8na6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 882A740004
X-HE-Tag: 1770862763-297851
X-HE-Meta: U2FsdGVkX19ACI5Fdo7v2/3lICXKff5xLlGR6H+kvsw6GSJDi0Ka/OAfw+T2dnqJy8KgXDDlEBCh0SQoGaebC1J6s03ws6NclOBJw5AjT9WsJOsB2tTpoIWzB04ZuHjDUV+zhlQ4caRFIBJmkE0i9HYc8YbBQ2hhPZMyhFMTmcHnOAkx9On8g2vtQGFEDgNnOQ+J4NDnrrnpgBjAqllApfjYv0JCwDNB87vbFL00fwPOj5VJhHji1idYYDqEbKuPSOy0Nrhlb79Knj1R3FY+vrla+giVDp8ZbnqashQdlCgTp8w7UQ3J7zIcBtnRlTQaXybdjc8SISqc9tS/Wh1FM8Wj46R6ZQxlWl6mEU7Jfpmnyh96UCLoqnlSlcGNb66wX/lsoF/7nqNwbgg5+Tv9SQ6Bd/YAIVKF1hcfMx/VZysVbbiCvQOd4/qehar9GGIjIcNY1Ql5y8+gTpFePVykSqF6lh4eyfLiuPANiBZmIrvIM9ZyOzf75nhEoTmq/QCScgoScZi5ZaaajNFf211C+4miw1DOwcgZrNeZcfrCBQFYaDvzK1xKIeyDpF1vOeBEcAbFHigH/5OOpJyblEUxby141RlGTDzQxRbqm23N9a2To8SNoD1Lh5O0I+vSSMCXpCyXY/bS1NM/3n3R/KZOuByJB2VbYiQDRMSuoLsdXzB/Iqkcl1oWWHQpcRgBdonITxFmHoRVjZKGHTYQagnKlH2JHb4d2VzJBwnY9VDBY29bEyDj+3dPIm4KzxkjQ22LtPJtMdeHp8uWTmd0yC4TkKo391RYd52squdveFpJo68hrULylH+5ah1tzCrYCj3VGdTJd+xcyPdR2Evq6L+uIV8FIq2JCyLauQUtKKXzoFBXt9n5K/unLkCRb07P7fgZxQzRPYZip7daxaGC32S/iBLx5PzO50zZ4kBPRVlwnoz1CMRkxLLZnmYo6xE5TvYEGw8cgPbWowU+8IPWqap
 5qFW1v21
 /baCKWIwP9K+a89BT69j7BQksKUz648x7vx1ozxae1vfNdt55JazQ9QI8UDUm9oEyokkXBdX9yqrB3+Zq+IS/2eFQvaDwLvgpJz2jl8fH3FZrpJY/CjjqXc43Nn2b28FFqY1YqCDxAsWbLhJqskxnnWx4A+x65hEX0949sXfmC1IXxokrxUiVBbCqa5s04DqGCTTMJ/SOMeiJyeqc9aT7usOEsZ5/ZR7SQrAz8GfhabYlgNusQOJvbKENcKl3MfefHlA/V+1oSThwresjv5XCUCq7aGhq/wCzYDRpw9khiRTAjYvf0SGN+5JfNdFxvHT188xmQiVzfXmsfguV/phYz4zP6Ao2MnByJlwY8XviDnvU6jEcHtonjw+lnmi0inYqHPjyllEBVGs5vtULFXfnURLFoVug4A3bi4IZ98LnB8elBTUkHNZ5fJAvW+uFdY5LVEsBilZspmctokLXqCx9piysP910zqLQjSBp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Nico Pache <npache@redhat.com>

arches#    pick b3ace8be204f # mm/khugepaged: rename hpage_collapse_* to collapse_*
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
index fa1e57fd2c46..c362b3b2e08a 100644
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
@@ -2329,7 +2329,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
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
index c2e96ac35636..2acf22f97ae5 100644
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
2.53.0


