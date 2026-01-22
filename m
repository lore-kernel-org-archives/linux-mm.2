Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82EA8D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6606B032C; Thu, 22 Jan 2026 14:31:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD506B032E; Thu, 22 Jan 2026 14:31:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785AA6B032F; Thu, 22 Jan 2026 14:31:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 62F786B032C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:31:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 202BE5C0E1
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:24 +0000 (UTC)
X-FDA: 84360593688.19.2BB98E9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id DF0E540008
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:31:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dN52gq+y;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4E8ptoTH7R+DRn1I9NeMb51UC/7t3y9Bwu4ndN7kkE=;
	b=JHSvBKCHuC6/5IHEd/q2P0/Rkv+5rzvevobotV/dqBsfQebLUaZiFc49O4dDWm/aK5X3mD
	5pgqys2q+XIH5PpXcawsYX7lISwwy4Ovn882/P1f86MwXc7n5Zi3MUYATyF9F4VVAhpCTy
	Sk7M6SYIt9DGF4K9D9/MOzYgU2iseww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110282; a=rsa-sha256;
	cv=none;
	b=pMnqvDsmzUFOK9M7oU0pTEEeeYUAcs8Ec1IfJIIc0vbyjoAoxuoxUqcrL2jQShC8on2Mj4
	7Mi6Okgac5siEr7BHjWUfCEhxgvOvdAswVuiAHFtJJwWQt//PUsGEJEKUoTUo3CvbRcZmW
	hE6nAYr+m0a9xAQpx5Bge9y3kFpxYnU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dN52gq+y;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z4E8ptoTH7R+DRn1I9NeMb51UC/7t3y9Bwu4ndN7kkE=;
	b=dN52gq+yNbD6MWAePhFveu0NFDpeVprbNCEteTpzut2ltKS/QVocj+ski6sAGOQ54oDXmq
	4ltSXEW9RcUkY+Nxee92/Fb/+clyBcMd2OEWpK2md/FaQBF9AaczfkCcxeGILtsenMm4gR
	m4mDzQGAUEJJEdGtf3xsBCyyboM8HMw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-t1Dm1WfjOpSFCagqfQXt2A-1; Thu,
 22 Jan 2026 14:31:18 -0500
X-MC-Unique: t1Dm1WfjOpSFCagqfQXt2A-1
X-Mimecast-MFC-AGG-ID: t1Dm1WfjOpSFCagqfQXt2A_1769110273
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07D0218005B4;
	Thu, 22 Jan 2026 19:31:13 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C07CA1958DC1;
	Thu, 22 Jan 2026 19:31:03 +0000 (UTC)
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
Subject: [PATCH mm-unstable v14 07/16] khugepaged: introduce collapse_max_ptes_none helper function
Date: Thu, 22 Jan 2026 12:28:32 -0700
Message-ID: <20260122192841.128719-8-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: otGgw-lXILei5XVGQW0mKZYjcRocM4JXznKjM5qoyYA_1769110273
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: DF0E540008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rg8itd4p4qxzib1zano9gxemfur86he8
X-HE-Tag: 1769110281-999991
X-HE-Meta: U2FsdGVkX19G1XrZWf26cKv2FalYRz33ZkhJekWMJrAZlS0OZl7qxx9l/4Tow4CirXHRCoPc/Ig0QWL2Xoe/9jok0V9mEsQ3RVFX7bzPeUflg/oOdqnUueua1tpNoH+k5Q1GRpE4lL/gGTbWRU7PwCCRMuA7c/wyJVe+9pL8i1+SSgKe9FBf2U/kfDqimaGG+ZNSarqwqNQ8RjfLlaUxG5w/dUUUwrlVN7SXkQQJSr0bpMhXDXhwjVcXhDa219zYkk/JZh4sT1lGdUxGzFOjcpAmjiJ/ii5XwN5Altn7IjKbSohStea/XSZUnYoDnp7oMtXLZbnGhUj6tEUBXUUzOiWB/620p8cT7/oQNmlcvN0yfPczzyCsXLnoOiSycg4ec38pmMedxR4Hftp8bW7i5EGTNhBjgK9qHJkSX+Jt6dKA7nlpwT0uhtt+XgD0kH27vSHmvH7EGBxBH/eR3eAQC5CV4qTyBqzHGcAy/MP3LMDypSxHJmAaT+Fe5p6FHw7+cP43SSiy6I/ksTlyMsz8FJblhtog4KaXdbFVfbu9NO7lQazIo2oaH7Zerrl/5Zdcl9mkObnQWQCpr/rDLuvNCMEgHhHeibH5wTuMFEcMRQHOL5TwtPM28gGTy7Lj6Vf66KWPm0x2VXKPMXeSWWOsAL+HVVmE9mKFLhW8JGIcNY5hI7luoyUiFRlq6Fp1CBmIc190z0/cFz+yCECzkUrcuHfKZ9n7xi+YbmVCO1dou4nsjr2I5nzgukjwzi5p8KLzS/gs7sES001oKCiNjOAuZFn75bfC0JmKyjq+UAsiZpByPFjt2gAJKUoi2TtMVsGum483ecxCtJJDmOyzTRBAbhOue8e4XEpk8Uc81mTcLjRTxkBdhIBnLbcMbaqdQ5MuwgcwPNUjP1xzPgCfMWVdOpunMDpxmjyYAquE9vvQmDrPGav4YnGDKdY9fT4FVV/Z1qB4+uCK2W0qgzDEZkB
 WhT72E1Q
 0rcmhyFj+wvFybW4TwKhfJ+P6AuEvGqzemAROwpFCafUrQYPH+yogA04rXaAlT+P5PxA7dt014GkzCJDNCGoeOin2mGp/I+BlVd8AnsLaIQJg0m3EOefqpBKwTy9ADcdojzxwcmgIjT9v2j8ogbSUAfRSIJ6GqMKvC0tsT86/3PYfiGTP9heGpSXhwUregTWAdbOaF2xtiAXuujt9m4TW9gFQ3r0qPIZSbOCsYGT/+77Ogr3/+avJLH6udhMl7UNFvbX9KJcOqSmZB7POes/Kmj6QvicwgfVN5ZR38FjaLqokplHPacVDVNuuyA4a4ox4ZP7qhex8FHqChFhACksJBNdGox3XAmOX4vhCJb/wP7pKqHhBqhiAqEyZdQvb6zV42p31c/zrQEvsmhI5Nyr3KunzEGsmdGH3NPScb636syP5UZi3mz43mXi0QSxl63fAVeY3nnNwgmJ+ryA5aaoDNWxJaY0iItopiXHI
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

To fix this issue introduce a helper function that will limit mTHP
collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
This effectively supports two modes:

- max_ptes_none=0: never introduce new none-pages for mTHP collapse.
- max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
  available mTHP order.

This removes the possiblilty of "creep", while not modifying any uAPI
expectations. A warning will be emitted if any non-supported
max_ptes_none value is configured with mTHP enabled.

The limits can be ignored by passing full_scan=true, this is useful for
madvise_collapse (which ignores limits), or in the case of
collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
collapse is available.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0f68902edd9a..9b7e05827749 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -460,6 +460,44 @@ void __khugepaged_enter(struct mm_struct *mm)
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
+ * For mTHP collapses, we currently only support khugepaged_max_pte_none values
+ * of 0 or (HPAGE_PMD_NR - 1). Any other value will emit a warning and no mTHP
+ * collapse will be attempted
+ *
+ * Return: Maximum number of empty PTEs allowed for the collapse operation
+ */
+static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
+{
+	/* ignore max_ptes_none limits */
+	if (full_scan)
+		return HPAGE_PMD_NR - 1;
+
+	if (is_pmd_order(order))
+		return khugepaged_max_ptes_none;
+
+	/* Zero/non-present collapse disabled. */
+	if (!khugepaged_max_ptes_none)
+		return 0;
+
+	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
+		return (1 << order) - 1;
+
+	pr_warn_once("mTHP collapse only supports max_ptes_none values of 0 or %d\n",
+		      HPAGE_PMD_NR - 1);
+	return -EINVAL;
+}
+
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
@@ -548,7 +586,10 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	int none_or_zero = 0, shared = 0, referenced = 0;
 	enum scan_result result = SCAN_FAIL;
 	const unsigned long nr_pages = 1UL << order;
-	int max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
+	int max_ptes_none = collapse_max_ptes_none(order, !cc->is_khugepaged);
+
+	if (max_ptes_none == -EINVAL)
+		return result;
 
 	for (_pte = pte; _pte < pte + nr_pages;
 	     _pte++, addr += PAGE_SIZE) {
-- 
2.52.0


