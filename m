Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58237CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3F0B8E000A; Thu, 11 Sep 2025 23:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15C58E0001; Thu, 11 Sep 2025 23:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C308E000A; Thu, 11 Sep 2025 23:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91F7E8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:30:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 525B359F31
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:30:56 +0000 (UTC)
X-FDA: 83879171712.06.50CFEBF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 93C4CC000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:30:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SsAx1+Ta;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757647854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kc/D3R1E4tB3N46/xRvTcnE3zMFjQQ6ARvrOttPH00=;
	b=S3WPrkYgMIomQmglMecRDWp0kqUCMlMvnECerlSgqJ2ApXORuG/XU4Gg/Z2oHVAJAH5SDC
	5JrisMfTewobWM/tGT291J9xVRnYX1bkBSNZdQqeMjyTPPq/2KUPx2lX6Q3wus6M0RviTT
	fqoq6dnrrrr/WVvR9q7lL7D1XrJ/MHI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757647854; a=rsa-sha256;
	cv=none;
	b=QXmPATsmNA6sIlj2zE/S34j7FFAFZm2ymVDRugmrQoHPQEm/cVs3a15VoGRvcyVoOE6NJf
	WPiz1fkPWgky8M0SrYgWw4Y6ZqA9jTQioPbsLe7Vs11+CXqLbo6gOxq7gvbT7dRC97BE0J
	g09rQmrSIeBUQDYJiqJ/oUKgcDl7fVM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SsAx1+Ta;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757647854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9kc/D3R1E4tB3N46/xRvTcnE3zMFjQQ6ARvrOttPH00=;
	b=SsAx1+TaOFg5VOYMMGNJsXKHJ/PQBV3Jd17+6j9Z6QF7xO6O0ybG3FqU8jRBImNfuPJvos
	xChSCKp5+y8NcZpBxU1bMeHRAVzvSk8uj0HUN5GYVxpnjpzPzfbQUV1jIyFYnwn6wpAhKf
	AV+frWkPZk3imIA0vPtDq/9pfg8A2ys=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-322-iImcHlBZOBqp8n-HOYvhmg-1; Thu,
 11 Sep 2025 23:30:49 -0400
X-MC-Unique: iImcHlBZOBqp8n-HOYvhmg-1
X-Mimecast-MFC-AGG-ID: iImcHlBZOBqp8n-HOYvhmg_1757647839
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A3EDD1953943;
	Fri, 12 Sep 2025 03:30:39 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.80.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0FD5A180035E;
	Fri, 12 Sep 2025 03:30:29 +0000 (UTC)
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
Subject: [PATCH v11 08/15] khugepaged: skip collapsing mTHP to smaller orders
Date: Thu, 11 Sep 2025 21:28:03 -0600
Message-ID: <20250912032810.197475-9-npache@redhat.com>
In-Reply-To: <20250912032810.197475-1-npache@redhat.com>
References: <20250912032810.197475-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 93C4CC000A
X-Stat-Signature: cwi1tja9z5u87otysh6yf3emubx9yahm
X-Rspam-User: 
X-HE-Tag: 1757647854-569084
X-HE-Meta: U2FsdGVkX19WCfB5X1p/FqBRR2IRNoExMmwHiYggJpXqeMe0EfzYHbZOYyjd87K+0toFt5TTIJzKj16577cfacVLRBSZZ5t5S65PHFOx+4ac7rg6/klPhv9Qq9YDS4xW7rBw7XOn7cuBDnBLmWeSYyVUTMVN4uauuoOpj5J74HUrGBO/0/ppmAfPC3SDAhNf5wsbvpSSk+mJeMW7wQjDuavuvHamwuWW2+Jixmw/ZTOlFSwl0RJ+7PoXOvp8cVtgPzh9xoKdybv9bONidQF32He0bvU2DzlnMrLhf2hUlHF8vnx9SoQYQSpwziYpEVZzNRtD0tkxzOsNgwQB9VVKa5CiU2xfmJDvXukY9MIQThVCauF4Ys6BzmJY0Zt+5o1iLnGRBErZRw0T8zdirgr1QUxKVoPYSw0VTUOIJo6cVVtYnQbDeYLIfscLx7R6yRz+D3c2BNrCrXWoQzP21MybvkJgH9rn2CRq9eQKYCRu1N1f+lkDpo8E0lB9qw5qHbksiOzyp5Jzbl+c2hpGA3T8Vdo9vgh2vfPdru1xdsIdlOrMEys0PIQRg4CZi5q4YTPkuoGF/AzqoYaTGyTmTSVlr9jT6sZxnmPtt2rHMoJuG+nbk0OrDFcYKtTqhTyhUnsv9tfqrWqy2Oesd4GqgklV4dUpLbtBBkN5kK9RaSUnLJvY9vce/WdTUm7QVNaoKsQgfBReKeqEuxsPTrFXKfcSXPr6FUzOSqU6QHr6ZVFXb3e6gP0NJEMuKyUBVBxAHQ8MQBwt8U00RmluOJq1vxW7OF0UY7Y/Dic8Y0pxfeuZUN0o6rOtYqAH3xlxdhzrm3jfJVGufHwnUtH1oa4vBQz7xM2dv9PuSD483AzTwCUmtTSPPP2mw/YtnJQ40Z9dIjTfylzgrRZvWdoPCz8EyVJBqN8iZni4bhCW/x92TkuX/QkyeyJbvfw5BRLwdCfFxHT9Wx5IM9i2dkDsjo8qe6a
 VYJHC40K
 dltKs66kQ6mZz60n/p5kzJCSuxTAgHbKDB28V9lqZWgbwRvpSrXVRPqBk0romcY3YAsq+ibxzAEs+7zG91uLOywXgKHryBpy6qopBTGqx9kXdIG/PaRACWOqWeDICo6ou3dXjXZI+S45nzyKTg/ANL7vT5jrYgR8HLSvjz+ANTWRcX49dMin2BVsVvwNuaB5iDUV8ajSPNRUg7lNHpBKHGFttXz1BrsRS4piHh8UEVvQP/Op9OO5AefhZW3YHQAak8KptY2qRTEQGt0vZHKAwFNWFu2EPw/gv3kgFYUlAQbkPzMe09T9QwHxMckQE1zpzUbdXyFUtzO2ep14VRdi6JT+6LBvXUmyTgbh9ikGFof4PlJ9Slme5+i1V+MwycJcPFFV5ONsVFNM9mpuPQ1l6is0tEAeY+DxRiXQuMyB4GAObfUatean37wEC0BAcDyalIyaHF+s3jYIlUE8IqXk6QHS3W/IvNEw9FS9nsjX7pha/Kq2hj7JGNy2yBNWeD6Y+9dw19E7+ErM+7GPw+20uJR/EIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

khugepaged may try to collapse a mTHP to a smaller mTHP, resulting in
some pages being unmapped. Skip these cases until we have a way to check
if its ok to collapse to a smaller mTHP size (like in the case of a
partially mapped folio).

This patch is inspired by Dev Jain's work on khugepaged mTHP support [1].

[1] https://lore.kernel.org/lkml/20241216165105.56185-11-dev.jain@arm.com/

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 248947e78a30..ebcc0c85a0d6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -610,6 +610,15 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
+		/*
+		 * TODO: In some cases of partially-mapped folios, we'd actually
+		 * want to collapse.
+		 */
+		if (order != HPAGE_PMD_ORDER && folio_order(folio) >= order) {
+			result = SCAN_PTE_MAPPED_HUGEPAGE;
+			goto out;
+		}
+
 		/* See collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
-- 
2.51.0


