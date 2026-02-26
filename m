Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B409FD4609
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D746B0092; Wed, 25 Feb 2026 22:24:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FF216B0093; Wed, 25 Feb 2026 22:24:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C0776B0095; Wed, 25 Feb 2026 22:24:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AB036B0092
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:24:32 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 276561B74C4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:24:32 +0000 (UTC)
X-FDA: 84485165184.30.5014F2F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3712D1C0002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:24:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hiH/PVJl";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772076270; a=rsa-sha256;
	cv=none;
	b=qKHN0Jo37B92yyA9DBII5yYkkVVTjwLmRJIwOo2el0Nu/v+Bsli07nwpWyxTKqgmXK60Zx
	MG7M7u0Qk5vEHhmbyLPff+F6mdwa8mYnrE5ayClgC3MsK3TaHB0qIo5BDVG8RvURY5s/L4
	74hBszDplNmM3Ikd5+1E19r92p70ALs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hiH/PVJl";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772076270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q8AaiI+gTK7kOsUYQDfxNlCUt5iMnurxFPbLsxLyfO4=;
	b=7P8iVzTT61MX5MR5jIgW4jKP/nFVknUamO5Fd1MPtTMUHClloZUVd4M1bJKXDEEV8VlyyL
	H+fSVIAh94SNOS6QiVC/0JXn9wkhwCUqU9OkrnhQtrao6MWLg6CR4ldoAfmrx/9upo4ZGz
	yyfx0JQ0u8qamYEtMACOBS/5ldlqIMA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772076269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q8AaiI+gTK7kOsUYQDfxNlCUt5iMnurxFPbLsxLyfO4=;
	b=hiH/PVJlpmtu9hW4JRjdViODenrRzSw7MRjDxELAG8dGor8hlzj8bjSJ9Cs/EE6NUHpV62
	VFxjZhYEuHjE3uUkmtGbhTAspnnHPRHTN2lR8CyoZ82lASE+AiIFjJidPISkF/WZkkGQtc
	VPCxVG1B9N999eqGNGoeMHT+Z3EqdsQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-196-GIdZh1_0Nla76VCBM1hO8A-1; Wed,
 25 Feb 2026 22:24:24 -0500
X-MC-Unique: GIdZh1_0Nla76VCBM1hO8A-1
X-Mimecast-MFC-AGG-ID: GIdZh1_0Nla76VCBM1hO8A_1772076259
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18AEA18005AD;
	Thu, 26 Feb 2026 03:24:19 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.173])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5615619560B6;
	Thu, 26 Feb 2026 03:24:09 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
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
	jack@suse.cz,
	jackmanb@google.com,
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
Subject: [PATCH mm-unstable v15 04/13] mm/khugepaged: introduce collapse_max_ptes_none helper function
Date: Wed, 25 Feb 2026 20:24:07 -0700
Message-ID: <20260226032407.233121-1-npache@redhat.com>
In-Reply-To: <20260226031741.230674-1-npache@redhat.com>
References: <20260226031741.230674-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JTaxnkF4bW9wbFjKp9i4sM_KGWCFRjhupnXN-uT2DT8_1772076259
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: waejesj9gj5gzo5i5g1br3ih8yhxrbw3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3712D1C0002
X-HE-Tag: 1772076270-447458
X-HE-Meta: U2FsdGVkX19mPHqpL5AQDmhzNFH5BJscqYiQMdIryakxXMWHq5MfpjgqRDbLZbBlkmGUgBFG5sYpD9VBKI+RK7PKFEanwKXGEU6Rjv7shFDAFKFeswGrUf4rV7zcT/4e8N5tvan6VbyqOBX8s//7Qlv93EIuWRBHq9vwq+PLRL68sSzv+TcypKE/HkjH7M5GMPKp/tOFNO1wH0ndDq/dtJLY43DWu5/bY5i5jy5UOSCqB05VkOCe2p/HLUIqjowFtRYX4TQmzrkTRrfze9AsXkBOAoVYwzRL7GfWQcD+ZISHSEPtm2eNu0Q7xR89jI4YWxLSd8LyqmKSrg9nGHv3Fv7AEymOZyQOLLrPf242kzvw/GrS73o2XVqbIfFE5kKGu8FSh1/gTQmSb9ABGPkdj2vlqFDg+ceNLEmFnjVrJ6uPnRvRlFXNg7hbaUSpKVd5nsbRB7DBcYDiXFwgmTpxE4aSOOpR8VkXxuyEW/UmZ9mLtkTs/jR69IiRkU4bCqr0JrXgOgq9Z8bgR1BYUNIGfV3T2ZnUONaKus8JSQkuibaPWHYP/Nifs2hDSpMPdQVeCYcVX/z3BjOBaWuA6q3PihhIIERtnYJk8hF48VG7looA1jPxro8LEZRWazkHGyjScXtchBlr9gdCoodA3yZmN5hKaif9DQw3kKLkSf2W4kbjxoEqO1h0v3NFSqk0Rn20x0gmt1Fpu7YnqislEExnmmfJBzeB9+xRdkc3nRun7WWrs9kX9n65Bzd/zMjkJT3mWbJKkEuO7NayNQU52m0u88H5rUtu6fE4iVaujP3qZ0+pj2zQBpZDCOT9gJ4ifmq6TbhSW8wOGZ+NWZM8hxj9Z3SKrsV4p25RABIpF9mE80OzkgUA99IScKkshsLtxAVCciKVfIhKdtvST+jlK+2E4NWuK2JG+1e1DeV5942Axvc92d0/JozTMU16D40wmGPunOOLfDqR79kVrufQmGf
 unpSzQfu
 nxGyQJHm6GIWnvc+eP6D2hLsXVLKAT4rrIjeg025CXhZ3PGrCgYlcxix8wEHBNGznQTLlyOc1WY1/dFwbaHYrr5nJyIMkVouAhw5SlEZXw90GtIcKy7wpynnzsubEPJQRCQ6I7pxaIWM5OSprLdVkW0HNtIXzvVUhLfoy2qi4U5A9yx24dDaG1jyejElix1FP0JxS8IIlcsbeyy2W0HQFd/eXTb4CgHWJUBPYePX1Uvou+hJbplPMftizGKo3zSU4/0PeBdfg4nFNxH7Y6whxtY5iPI8Or8U9xAoOYx/bkThi/v6hYg1bN2m6Kl82ocLK72THTFJYaXdZnmef+/qECn+V3xf2Jp49ELCxdqFStxe4Meph5j+q1POniwgHM6uQ8oK9XnIjR0mQk/e4+d3NJL40AmTGBweQQCq/V/7H/ZM7z72lQ4zlt+uGHzsenj1rF0pMnkvQZ3nn9ZXakRL0ZrH6TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current mechanism for determining mTHP collapse scales the
khugepaged_max_ptes_none value based on the target order. This
introduces an undesirable feedback loop, or "creep", when max_ptes_none
is set to a value greater than HPAGE_PMD_NR / 2.

With this configuration, a successful collapse to order N will populate
enough pages to satisfy the collapse condition on order N+1 on the next
scan. This leads to unnecessary work and memory churn.

To fix this issue introduce a helper function that will limit mTHP
collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
This effectively supports two modes:

- max_ptes_none=0: never introduce new none-pages for mTHP collapse.
- max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
  available mTHP order.

This removes the possiblilty of "creep", while not modifying any uAPI
expectations. A warning will be emitted if any non-supported
max_ptes_none value is configured with mTHP enabled.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ecdbbf6a01a6..99f78f0e44c6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -456,6 +456,36 @@ void __khugepaged_enter(struct mm_struct *mm)
 		wake_up_interruptible(&khugepaged_wait);
 }
 
+/**
+ * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
+ * @order: The folio order being collapsed to
+ *
+ * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
+ * khugepaged_max_ptes_none value.
+ *
+ * For mTHP collapses, we currently only support khugepaged_max_pte_none values
+ * of 0 or (COLLAPSE_MAX_PTES_LIMIT). Any other value will emit a warning and
+ * no mTHP collapse will be attempted
+ *
+ * Return: Maximum number of empty PTEs allowed for the collapse operation
+ */
+static unsigned int collapse_max_ptes_none(unsigned int order)
+{
+	if (is_pmd_order(order))
+		return khugepaged_max_ptes_none;
+
+	/* Zero/non-present collapse disabled. */
+	if (!khugepaged_max_ptes_none)
+		return 0;
+
+	if (khugepaged_max_ptes_none == COLLAPSE_MAX_PTES_LIMIT)
+		return (1 << order) - 1;
+
+	pr_warn_once("mTHP collapse only supports max_ptes_none values of 0 or %u\n",
+		      COLLAPSE_MAX_PTES_LIMIT);
+	return -EINVAL;
+}
+
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
@@ -541,10 +571,18 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	struct folio *folio = NULL;
 	unsigned long addr = start_addr;
 	pte_t *_pte;
+	int max_ptes_none;
 	int none_or_zero = 0, shared = 0, referenced = 0;
 	enum scan_result result = SCAN_FAIL;
 	const unsigned long nr_pages = 1UL << order;
-	int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
+
+	if (cc->is_khugepaged)
+		max_ptes_none = collapse_max_ptes_none(order);
+	else
+		max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
+
+	if (max_ptes_none == -EINVAL)
+		return result;
 
 	for (_pte = pte; _pte < pte + nr_pages;
 	     _pte++, addr += PAGE_SIZE) {
-- 
2.53.0


