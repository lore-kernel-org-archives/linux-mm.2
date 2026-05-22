Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18FDECD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D226B00B9; Fri, 22 May 2026 11:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CDF76B00BA; Fri, 22 May 2026 11:03:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3DA6B00BB; Fri, 22 May 2026 11:03:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5EED46B00B9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:03:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24DC21618F8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:03:56 +0000 (UTC)
X-FDA: 84795375672.22.FE8AD2D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 178A22000C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:03:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EEgzLZ8v;
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKzGCsvRV4B4D7Qk2zsKisWUnK/qFNBnw0Wayfjefs0=;
	b=M+TWIpaaAW0rtIZ3QZGUGKaiOQotqfGWG3+1Z7cjDmqkDL5ayb0D+6p0Fxwhsw6GS64oBV
	rixW1DEe+aAgENIJTrBFo+PeqDOoH77iTH51b/gQTuZXYMm2c08xn/2OD/b6EM+nKbCeCt
	jin4rCPXuPlyioHpNOhSNTMSslQ2KLI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EEgzLZ8v;
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462234; a=rsa-sha256;
	cv=none;
	b=lMNDakxfmG0/MmrQp31BNH/ynW0T/E7Nw8oZXgV1QC/gyvN7iyukxuG3e7DjcRgX6dyarq
	93CUzUnivpE0kMkjN6nHdA/qidgEMdTWiMjDWQg7P1gPzrn2Lcoq4DETc/xn5B3F0h2sMg
	XcAMJ4VxX/ao+XBKz/N8MXpPjGz4kAs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EKzGCsvRV4B4D7Qk2zsKisWUnK/qFNBnw0Wayfjefs0=;
	b=EEgzLZ8vqyP9Cnl64baEcWiU3aM0zGGkoWwUYIyYX8IdyhrKxOnbTf+3FrS7nrUVuVYUsc
	NYkR0QKunQxkWCyYzuBJ43pbwYLhozqq2L9rTJsUKGqmhQcV1sJpa2Da5sOtdPkGChG2S1
	uGSOGYetdHtByNGG/v0CnU3GbSqh1i8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-p1Y0jKTSODWizkMY6vY71g-1; Fri,
 22 May 2026 11:03:49 -0400
X-MC-Unique: p1Y0jKTSODWizkMY6vY71g-1
X-Mimecast-MFC-AGG-ID: p1Y0jKTSODWizkMY6vY71g_1779462224
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4DC761800283;
	Fri, 22 May 2026 15:03:44 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.24.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D2D961800576;
	Fri, 22 May 2026 15:03:25 +0000 (UTC)
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
	liam@infradead.org,
	ljs@kernel.org,
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
	zokeefe@google.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH mm-unstable v18 12/14] mm/khugepaged: avoid unnecessary mTHP collapse attempts
Date: Fri, 22 May 2026 09:00:07 -0600
Message-ID: <20260522150009.121603-13-npache@redhat.com>
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
References: <20260522150009.121603-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -A8qjgqFXwhB9yTD_j9KslCoUUPmnopCFUeF0gkDfys_1779462224
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 3aujp5xro5d4f8fwrcmmyjh549g5tcna
X-Rspamd-Queue-Id: 178A22000C
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779462233-825693
X-HE-Meta: U2FsdGVkX18ypIbkW6zcADCL/4oJz8Jsks9+SfFgGxqXu85CV+EJG2gP+qgK/cJ0iUrSN5+lE+0hkfQLTajYq1y1crTxNyGhBl6Gq+zGay67N4RWX/36zjy3VE5aOAiYPiG7FM/s6dk/+BMO5N8bHxfqAgpT4xRPxgys91Uvw1WNxhzJuoftORNAsiNiS1Qfb5LGB37NwoX+RD7YnrDb0EmIJ23t4tBRuIIUeUbFM5OgWeYz8U9YYmeLkbv8wuKBUA98WJrfa3OGOAjEXa1mT6/LN58Ufg0QkPeT9rtTrcHs0no6JlKULM5TK9fPtnzk8F+FNs2cR1bf3/PtTwXsVbsgpzGn9NNIkW/52mZh2BmdJ4MaKuy+2EGmMYRQ8klRy/CG+eCaDpzp+h4fVtCQdmt/kei/pTQRvIwSLsaqBcjJGRV9tlbJAm2U0vS36BLHwMUxZhgqf8/AE1AKQX+9cISPYZNU0k0JBBewcxK/jtFRwuovSEMDEd51zEDd7zjreVqmY5N3B+FpMnmcG0Or1Utnl4pW+V6YiywBPzi/r5rnkkIYM7uD1SbZoCZvsW9/5FII9sDuGAd+09220eaaRJvKud4jqHpLMmz/G6T/O71SLOWzqMF82ck8+Y6RBPIG3MOb7ipuH4BTGrvz5EVd5FD36PApaPtVz5UoFQEB0fP2TD0Ou7HCauHOztf4Tx2ytLBOEerY0Cj1vhAQVQgAeo8NS3oFFH2T1QKoueB71Qpp+Yq9ncEZ9ZbVLSXPP57PzgL3x/wTTL4A4kN486ntiQDosWhYwWfKL2tmsGXlrH24xop8EHP16KExN9fD51R9D4vS+1UfpcNCt2qCfDizMM5du61S9YDJ6pEwPbbeRVGqCHRV1ND7jqcWr9tORIVJgEw6O4sGEGid9GigE8FxZ840Go2IM8rTxImiSzNim8J2mzeGbaTRmc7XsFwZTjQRt09Z9+/Lusr/5rh9UTf
 7xcC5JOB
 KG6J8wXTghILedSYS/WgXnFEuf1TMSxbJhqJOnUPeVxR5tlQD3OPKi3YpYiWmlLT1/PJSWTsmnNCBF5nAwtCKpE/0bBNS49WV3U2464ulCUYwvOfBOBpXr+/kLabG/yAGzNjhjedVkrFAkODp1cEnHWZYTVqyKUVNjVwPs8UwPtMR+TOBo4VYq4IpY6ZzqsLvBGg08LObMoXIXdCKRl6tCHwknuRndOw1SHzyoEmIOKX8bfdjjTcgA6Ar+RXmDZGBMpPukIHsOnaRlNpQehjTaqgGiyMPrJ/Bq4OR1OnihxuJ4eZ3ruxBNiejfU44N+dbihapvaSnli+S1fy0BGKvyMjdwfeu0rpZ+oMsrr9iWyhIcyi7Z3ulRRtiDF1OX/348myeNYWp/o6WBxWY6cCL+znNtwyqosPDPdXw+yJjrmmjS5FsenN6DmCK3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are cases where, if an attempted collapse fails, all subsequent
orders are guaranteed to also fail. Avoid these collapse attempts by
bailing out early.

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d3d7db8be26c..15b7298bc225 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1535,9 +1535,31 @@ static int mthp_collapse(struct mm_struct *mm, struct vm_area_struct *vma,
 			collapse_address = address + offset * PAGE_SIZE;
 			ret = collapse_huge_page(mm, collapse_address, referenced,
 						 unmapped, cc, order);
-			if (ret == SCAN_SUCCEED) {
+
+			switch (ret) {
+			/* Cases where we continue to next collapse candidate */
+			case SCAN_SUCCEED:
 				collapsed += nr_ptes;
+				fallthrough;
+			case SCAN_PTE_MAPPED_HUGEPAGE:
 				continue;
+			/* Cases where lower orders might still succeed */
+			case SCAN_LACK_REFERENCED_PAGE:
+			case SCAN_EXCEED_NONE_PTE:
+			case SCAN_EXCEED_SWAP_PTE:
+			case SCAN_EXCEED_SHARED_PTE:
+			case SCAN_PAGE_LOCK:
+			case SCAN_PAGE_COUNT:
+			case SCAN_PAGE_NULL:
+			case SCAN_DEL_PAGE_LRU:
+			case SCAN_PTE_NON_PRESENT:
+			case SCAN_PTE_UFFD_WP:
+			case SCAN_ALLOC_HUGE_PAGE_FAIL:
+			case SCAN_PAGE_LAZYFREE:
+				goto next_order;
+			/* Cases where no further collapse is possible */
+			default:
+				return collapsed;
 			}
 		}
 
-- 
2.54.0


