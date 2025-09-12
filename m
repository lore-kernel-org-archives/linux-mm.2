Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C12CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598286B0022; Thu, 11 Sep 2025 23:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549006B0024; Thu, 11 Sep 2025 23:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411F76B0026; Thu, 11 Sep 2025 23:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1816B0022
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:30:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D10BB86D56
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:30:31 +0000 (UTC)
X-FDA: 83879170662.14.F32216A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0D0991C0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:30:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MqzidTVb;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01Jz9/k0vzI/AACRV7RtMTOuI2wxHsxgFib4uYq4G7A=;
	b=gqtrcIpq1lH5XaQwWo2SLG4qVGlBQo8Vj1mMjmKq4UHiiA1wGR/0g8O38BzL4YkPWlDprj
	F7wIc7oo7iyvQq8tMRyx2vWeGmqiCuOPXKY0UEHakJB4MbHpi37au5hN0Yu0exmuK+GaKm
	79hsYDWWeALbMpGk4m97NU6NFA5aYZo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MqzidTVb;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647830; a=rsa-sha256;
	cv=none;
	b=aoPUsaRPnrcutIU9lt6yKR7QDR7BnfKsEq3VxOX7ye3vVD1mNZYdXwlmMBVZwHq9ervelq
	LyoVMfehDtW9aXJf7jVAM5bcvT9j7BekJncGNYByhS9gpnOzg6sdPWTIfbK6G8hsc78pjx
	6GxgogvcYCSI/vXVvH8Q9EstGxK3Xq8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=01Jz9/k0vzI/AACRV7RtMTOuI2wxHsxgFib4uYq4G7A=;
	b=MqzidTVbQ2p4rsfNj9bL4xf1USTtjumg5XOZoVyYrgDeZu91sndtsAjn+6873M4RimZWIN
	w8vc4RIRhWwyAh4vdYVZFuYyB7UX61nMAbKBMl/2I+bWQoXYf8IChHb42Azu9lPWfqKaOI
	jqzQA3zMBBIH3SicGU9UwMfCgh0n+8M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-34-ZY1NzjJ6PU22UsrupP4zCA-1; Thu,
 11 Sep 2025 23:30:24 -0400
X-MC-Unique: ZY1NzjJ6PU22UsrupP4zCA-1
X-Mimecast-MFC-AGG-ID: ZY1NzjJ6PU22UsrupP4zCA_1757647820
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D3A41800343;
	Fri, 12 Sep 2025 03:30:19 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D81BA1800451;
	Fri, 12 Sep 2025 03:30:09 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	corbet@lwn.net,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
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
	surenb@google.com,
	zokeefe@google.com,
	hannes@cmpxchg.org,
	rientjes@google.com,
	mhocko@suse.com,
	rdunlap@infradead.org,
	hughd@google.com,
	richard.weiyang@gmail.com,
	lance.yang@linux.dev,
	vbabka@suse.cz,
	rppt@kernel.org,
	jannh@google.com,
	pfalcato@suse.de
Subject: [PATCH v11 06/15] khugepaged: introduce collapse_max_ptes_none helper function
Date: Thu, 11 Sep 2025 21:28:01 -0600
Message-ID: <20250912032810.197475-7-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 0D0991C0006
X-Stat-Signature: rxsyc94potbb356mduziua31b4of7cpg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757647829-902660
X-HE-Meta: U2FsdGVkX1+yUnay6dIvuBkRIDjGTYMpXEksOQkjKqhjR1nLQv9LkiaigSjhpvBfzu014Bnlr2IP+Y8Yb1r32T8daiokGnY0Os3gEmAUFwSjP4hdC+Rped03uoBExjtuBhF1JaQtgP/8ABM57KQr1gsB0pzltXrBVaehSrgPElnPWEIJvaA/5QzfExnCdhQtPDQw8l9F0AICE2gTy9BNJPFV6C8YskFMHXywyskw5+ZgJwFrnXJrJMw/yu0lEC6KnoJDVwCsGpGcliCFSvPLgHPCz4OXIupXIiXcogRD5spf9delz8F3mG42lE1tgYl7G2smBKWcjWKT7f/GNK3Er89tteLXBVvcxXwsCNvNSbQ86FXACEJn3qbGPe0WwXpa09JjuviZFiJeGWp6zgYRpXrErmCtvRZTi7iGyaG1xBh6aGTA0c5wKKdl8P1cx5OTJRPgAho4pXEFUYBuxdYu8ZZU3VPp9jQuYMPitfOXj/Affag/aXDj9IN8vVf5+GWZUk9vwcBGy7jU7+T6Jx9dw2+7eSztP7PDT7mEupLYPfPbVwF7teoK/jLv/XX/Sl791hesu+DST3jP1XtCbA+IMFa9Ilr2v4SNDL4eoWNO1DQopkzusnBueE6k4J66RwOP/z640tke0UaNjQL9W1WjQa1NvKCLveBDi5dtes4y/Q9efjUR/MX62VcUoBdKc4KbwtOSyJWrxvYS5e5j/1bY+5fUwGDASuou0RkwFJ7LLAwKZ3d5uA4qs8IVHyLBkBrWbOW3fNlhuPQpIlwP4EH+6469kM67cZXbGbwX5m1p8+jc7WKZ+Bix5l91/duSmC/zpe79DT7uCCk0yRqnDwUn1wGd9SzvdIakmWkGbcvv06nTwXI4d7iB90hNL3wEB6YCL1Rds402kdAdOvOTMa8+UH0OrsuogLF7A9EiZCHNaigAR4WvDqpZF9vQeN9A+tR7/UZauCrQZ13uNkF3png
 pVioYrE5
 RvNLQwqSFPgGWvWFF6dhmmw87RHAquckvMtGauvelpySHB6cQXf8RbRIJlupmIPFas21Ehf1XGTqZMGrRyKBiSzgBfKQb7sxvlWZSZsAo8SLBOkfs0axKe66lWJirE1ED1SWRzjR1fhwDyVRIT20kPfTJ8aD3HlvAp5zPoOzzu+P+GNm1YVxuNd8+67AFgf6BDVrKd8fN6xY2w9htkxKwbApYit2C9LyPiNvsKC3sIf8suU6QOp6PEYNjwALeTmKvgRPLd2ABnFcFIauNzfz+RrkjH9dfny5ixoNai0bi0jq49y9EbX8UWV30UtUYbZKs/3PbB12sEDLhlG/qXCN3k4h79K7jqycI+c6hP+VjZbvMcG3DqMOV7pSfYD+1hPpi04S/MZmRF8UMX++32Px9SByyrY6DV7ZYBRCO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

To fix this issue introduce a helper function that caps the max_ptes_none
to HPAGE_PMD_NR / 2 - 1 (255 on 4k page size). The function also scales
the max_ptes_none number by the (PMD_ORDER - target collapse order).

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b0ae0b63fc9b..4587f2def5c1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -468,6 +468,26 @@ void __khugepaged_enter(struct mm_struct *mm)
 		wake_up_interruptible(&khugepaged_wait);
 }
 
+/* Returns the scaled max_ptes_none for a given order.
+ * Caps the value to HPAGE_PMD_NR/2 - 1 in the case of mTHP collapse to prevent
+ * a feedback loop. If max_ptes_none is greater than HPAGE_PMD_NR/2, the value
+ * would lead to collapses that introduces 2x more pages than the original
+ * number of pages. On subsequent scans, the max_ptes_none check would be
+ * satisfied and the collapses would continue until the largest order is reached
+ */
+static int collapse_max_ptes_none(unsigned int order)
+{
+	int max_ptes_none;
+
+	if (order != HPAGE_PMD_ORDER &&
+	    khugepaged_max_ptes_none >= HPAGE_PMD_NR/2)
+		max_ptes_none = HPAGE_PMD_NR/2 - 1;
+	else
+		max_ptes_none = khugepaged_max_ptes_none;
+	return max_ptes_none >> (HPAGE_PMD_ORDER - order);
+
+}
+
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
@@ -554,7 +574,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	struct folio *folio = NULL;
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
-	int scaled_max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
+	int scaled_max_ptes_none = collapse_max_ptes_none(order);
 	const unsigned long nr_pages = 1UL << order;
 
 	for (_pte = pte; _pte < pte + nr_pages;
-- 
2.51.0


