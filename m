Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD0C8CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:39:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B528E0018; Wed, 22 Oct 2025 14:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CB6A8E0010; Wed, 22 Oct 2025 14:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292DB8E0018; Wed, 22 Oct 2025 14:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 158D38E0010
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:39:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDB5E48C02
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:39:29 +0000 (UTC)
X-FDA: 84026613258.11.7D58311
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 23C644000C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:39:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i6mpI89q;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761158368; a=rsa-sha256;
	cv=none;
	b=CzBQD3p3TVMaiQiDZClOFAvXXpmpRRnsYeKT1zWULnHaRNDASzn2zaFqLMA5gVSBnjYl4/
	6K6/5NUS+jkDrhkXs8isunq4VVjJ269Kqzzr4gxjuezUeEh3HNS2b0podKmsFsU9SwjTPT
	LQPeCQ39y93xxHepcxmL/ragfD4E7E8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i6mpI89q;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761158368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zERItD4tpTSTLZu1EAujIdQUQv57c0MEV45Tz1yZd+8=;
	b=chPpcicMaPZ85yQ25dbCSXe2LzSYdn4qUIRlfAA9pCEMkSmxwwLQjX/W6C2mY8PdzIC4cA
	AMFks7ASODFaqX8cwvmOtn9qs5NeAJIVqlfuhv1awd2vg7OzpP1WAkOC8Q+8mwm7saz404
	cL1MUdBMak4TMRa142cNrArFWUnvlOU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761158367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zERItD4tpTSTLZu1EAujIdQUQv57c0MEV45Tz1yZd+8=;
	b=i6mpI89q+3WWoucFozpOabw9NWZ6AHhyG/f2McPnOEQgyU1wlVO1DQaIaoPWxq/vmGMVBT
	4azjrk2v6hJdFkjW//aazDCsvb0zyWqihA1R2OhjQWir3xEcmcsR1H0B1DYVw7gVzM0QGR
	xsG/kJNxGkDwdLb9EOK73GngxnekPJo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-182-CNNjUI14NuKWDUrtXV7l9w-1; Wed,
 22 Oct 2025 14:39:25 -0400
X-MC-Unique: CNNjUI14NuKWDUrtXV7l9w-1
X-Mimecast-MFC-AGG-ID: CNNjUI14NuKWDUrtXV7l9w_1761158360
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B9AF718002C9;
	Wed, 22 Oct 2025 18:39:19 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.64.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 04CFA19560B4;
	Wed, 22 Oct 2025 18:39:09 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
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
Subject: [PATCH v12 mm-new 06/15] khugepaged: introduce collapse_max_ptes_none helper function
Date: Wed, 22 Oct 2025 12:37:08 -0600
Message-ID: <20251022183717.70829-7-npache@redhat.com>
In-Reply-To: <20251022183717.70829-1-npache@redhat.com>
References: <20251022183717.70829-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: ntb5m1zgkmutjewcejqu9qjrw3obwhg9
X-Rspamd-Queue-Id: 23C644000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761158367-613578
X-HE-Meta: U2FsdGVkX1+WLB8igAYiCWXbRA73LQI1YZSyRIApm+Hptfa8dNCYO5203ilrFj/L/aRCK2+KXYjNblwzMhlstiEXLUO5tcONAHdyYuTpBdVoZw8p8v4Sc7qlW+wy/1DvBKsTvpRCJ2SqDRxtWVB7KlgE5qd8DvLtmDPGpvPzbn2Q15jr4vliKQxKOy+CkK0vu8HcMJ+kar+uLZMmoAKuWZ20+DZequv8m9qhrb9MNyf9KLQBr+EaudlLusKHFRjJMMJ+QPNVhQtWpJ+5eS4wkhkIMijE2qHcORDU5TYJzQIK/97sKQ1LfuBH4FK2vREhCEnGux0y4F6c5xvVqybyHqeH12nOT5bM5DKk8c813o8a4CfcTRBrUIXKSsmsplMTJgVGWNOWb9e+FarHXqQABIB6csz872SHvV7o88gMg05/wxIyI/bWK1lqvata9mnZHWMdaoNDc6/Wbykt1eQPTSwKq6inlsECrZWf1GpKTI6lxWIPp1WMZoxwZMIvJRErbDNJP2HrfEGJ9386x/0M7QW5q8XakJGUHPbmt4s7ejapspz0L2tkwz/+9qBcnQwrmZCZEauif7J+g3B+PMkvi5KFURejZbzmNeghiJSzLBOf9vRgSz+RSrGOcxt3yHssPxlYGfDYJAk6DHHQp+0bEyB6bogNLBa7LMiNSL1ugb4kg8cxOhtG17WvC53ycRsHxXyWMC3PipcqnkJIoiZUqAtVr417tEGD3oFT34CIpDkyb58eC72GAGrANdsJhFablavC/SaPiNrO0vO6pB8n8o1m9joUoQ9sePmX6acNqsBImUz4vX4sG6eDghLmwNCI8hzRgTHwx+emIohwgva15xIz99qo+1V0cvDHuVd0EXGj8Z7XeYnGpLi1DAf5tCNRsDzou92b3Jaz7xCWECPRqTUicyps+pQChSJkZQ2Ey1ULMpb1KJ26hNKj73gD10NU/IJHeAZPOT+7VkUxLk6
 y9rdGUux
 G0WeImRDbZ78UTnOA7kRoP6i4+loJL20zWz/e4Pm+WxBLxxLjuN96GnY+1bz3H4qQkv5IzsiYoo5lXq0Wz7ID+TrURVTMDCQ0W6jxCgsugFdTeQBPi8EZUGbeby/PiIhFmhECGu81DLww/1i5qeMaaLzVnVCnilI+YaQapvhGzIilQHwmPNLpy9HYqdg3fwiMjKmVRkOLBpAgY2j7KQDerRZ0rfsB+/LvA+1fhv5CoszVsPRiyQnH+pz3ePpAfjSXp94+BpW9MxDqNd0xHgnVbsxTm07C61xJQNh9ev5U0ngl4pf39GQ3SvTi795yoVrAWio7yJFxOVILa/pwfDrWHKCLi2yg0f4Fja0fcnYqAk+H9XOaxt+TcF1G8wWIqKEwDq9i0ayX8wZsoWKwG7QBrbLtnLDnt09jYzAZ
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

The limits can be ignored by passing full_scan=true, this is useful for
madvise_collapse (which ignores limits), or in the case of
collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
collapse is available.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4ccebf5dda97..286c3a7afdee 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -459,6 +459,39 @@ void __khugepaged_enter(struct mm_struct *mm)
 		wake_up_interruptible(&khugepaged_wait);
 }
 
+/**
+ * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
+ * @order: The folio order being collapsed to
+ * @full_scan: Whether this is a full scan (ignore limits)
+ *
+ * For madvise-triggered collapses (full_scan=true), all limits are bypassed
+ * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
+ *
+ * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
+ * khugepaged_max_ptes_none value.
+ *
+ * For mTHP collapses, scale down the max_ptes_none proportionally to the folio
+ * order, but caps it at HPAGE_PMD_NR/2-1 to prevent a collapse feedback loop.
+ *
+ * Return: Maximum number of empty PTEs allowed for the collapse operation
+ */
+static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
+{
+	unsigned int max_ptes_none;
+
+	/* ignore max_ptes_none limits */
+	if (full_scan)
+		return HPAGE_PMD_NR - 1;
+
+	if (order == HPAGE_PMD_ORDER)
+		return khugepaged_max_ptes_none;
+
+	max_ptes_none = min(khugepaged_max_ptes_none, HPAGE_PMD_NR/2 - 1);
+
+	return max_ptes_none >> (HPAGE_PMD_ORDER - order);
+
+}
+
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
@@ -546,7 +579,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	pte_t *_pte;
 	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
 	const unsigned long nr_pages = 1UL << order;
-	int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
+	int max_ptes_none = collapse_max_ptes_none(order, !cc->is_khugepaged);
 
 	for (_pte = pte; _pte < pte + nr_pages;
 	     _pte++, addr += PAGE_SIZE) {
-- 
2.51.0


