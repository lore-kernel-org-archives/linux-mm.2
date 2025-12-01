Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19345D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 17:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A1B6B0007; Mon,  1 Dec 2025 12:50:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D95C6B00AD; Mon,  1 Dec 2025 12:50:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57AA66B00AF; Mon,  1 Dec 2025 12:50:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 436116B0007
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 12:50:00 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12BD81313E4
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:50:00 +0000 (UTC)
X-FDA: 84171640560.29.2BBEA33
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7D49C100012
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 17:49:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NCbYGrSa;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764611398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ShTcDLxXyZs/NuRdOzDyMIIPzg+5zGuWDXBHW57k34=;
	b=4OnHrQT93nY1gFrVlRxlPJN+uBScj76Xk7PxZrJBZWKq1M6lN6QMM0c3ttfk1Cmrt2Dpmv
	4zhJBqQShYaDGKm0OX7WIkn3MbHAkrdH4VTJ5Eah3CLejz4Z6XQ8eSVME+fHOZCRVmzXSe
	KpVzh8lDKs5lpeU3aM+ho3HS1vvSMiA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NCbYGrSa;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764611398; a=rsa-sha256;
	cv=none;
	b=wepY4OdVXJkpig6GgFtk73slKbBVH6+zVlqGhhEvjLBLgEESW5xsxqH87h4VYE/VdTYm3m
	NO5u1HV1llb80PI35EH6kYL9B1pnRIVQVLVpybcjrKB+JH1ESIgo0c1R2qmhdZu/r8MZuQ
	vsXGYwLO+U0sRzhau0P802SD/2cwF/M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764611397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7ShTcDLxXyZs/NuRdOzDyMIIPzg+5zGuWDXBHW57k34=;
	b=NCbYGrSaBNW65ehrEhDTXgk0reE2/nEZckY7G9eX4cZaRiKUAo9MxU5S6pZ0o3v69tuf8a
	IknYyECw8rOY1iTs/V2bxlXyNVbX6spypzY0mrcyPxulOAiqJOqmWXm034+ekCvE2r+NFD
	BPQ1W8ixD9t/7AU0G4lTRgsUzb8B+LI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-17XU2vohN7OLwRxYhfKiNg-1; Mon,
 01 Dec 2025 12:49:50 -0500
X-MC-Unique: 17XU2vohN7OLwRxYhfKiNg-1
X-Mimecast-MFC-AGG-ID: 17XU2vohN7OLwRxYhfKiNg_1764611385
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFE881955F2A;
	Mon,  1 Dec 2025 17:49:45 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.66.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 06CED1800361;
	Mon,  1 Dec 2025 17:49:35 +0000 (UTC)
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
Subject: [PATCH v13 mm-new 14/16] khugepaged: avoid unnecessary mTHP collapse attempts
Date: Mon,  1 Dec 2025 10:46:25 -0700
Message-ID: <20251201174627.23295-15-npache@redhat.com>
In-Reply-To: <20251201174627.23295-1-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D49C100012
X-Rspamd-Server: rspam11
X-Stat-Signature: cibx3k6dothbgguoqbrf8dthtyz8npbo
X-HE-Tag: 1764611398-84520
X-HE-Meta: U2FsdGVkX18xH0JNT9qUEb11iIi51BO8MfwYFbN+1MyYV+lD5F40hxa/91+pbnisTe1/yWVJ8uVopG5zl4h+vU7lDgRlq/lkS6GNZmU+QJWLsvz30Q46U3+60fM2Tk2ADR/XP6skZd6vMGKdGUX+Bc0ijE8C7pNCb5SdkzdMfyCfTdlus7Mmj6GnkSodofZckYhs7ZV4H+5bUsvaVVDusYddyNWjBTeFAbSxhE9ywWTL1+9pIOhrpxeCxvSq/0MrERAOxVs+uYJKZmfRDxXqssLtgnbZimMM4fFpwy5UMCqjeUnBQqxRycZtDv+4x183kwOKLrcLFw0+a/wHp80O9iEOPYFjszTenrEgrA5R4OSjH2EeEdUi6Mtj/q9XabyMudHsUpSdYkPepfF67cHWTWukO4P8btj1UfqY4KiwYkHrtLd8eO+VrV9ZwXhYbx9kH3aTksyEC4bljczTfqEZVifX3oDQ3W0CbHPAPf/0lyOzaGxFGUAiwd8wInGWwsIILq2yzHRIg2Hutp5f4nE+VwNLIW0RiHP54HbjhmhXpAU2M+bz+ZoKdKylZEWqnYnw2yWBzmVgsBt0LFueBPyjAzFcB8EdmLp2E7ClKX7tKmZ0J8+Sgr8DEuDd7qNtoxT+cLbcQjjslG14QCXDKavqqfUAaIeFkWhiGdo9by7r1TslfvOTfslCgUw+P82DLId+Sa3n1FmgCL9TqENcMVzE4WY+EUNcrckPTA92Rhxmz0dTux9ObPtE8YqOO4BbVqZowhSQK/mj9LvozWtm20ewBmBCXn5bCcbLodGn6uPaixv0jQytnb73eB8QXBQ/qgH57TRXU17x3ll4j8OV2S/Nkv2vTBW7ANAm+77DCn1JcTjmz60XrMBLYiwBe5GDSaPyEAbCzFfh+qifmlemEljUTP9pL1GEQ/mtMMKyMK+6YiHcX+7TQSC1nIJ6UUliu4eDT2v3tSLoMofMRwsQ0hZ
 rj0QgiCg
 VRByxtkDEvJVlMF6mGtQFA94OLeXtwB0GJoZt90Ysqql2JGptKpwEqCv2GRoCGl4DKR+5nxyJUXqWwa5O20i28CNFjwfW1QwaFoL30Z/aDTkiqsIzNB9wZiU1gK/CeLXZMlb4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are cases where, if an attempted collapse fails, all subsequent
orders are guaranteed to also fail. Avoid these collapse attempts by
bailing out early.

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fcb927cd5456..daf39aab7e86 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1503,9 +1503,42 @@ static int mthp_collapse(struct mm_struct *mm, unsigned long address,
 			ret = collapse_huge_page(mm, collapse_address, referenced,
 						 unmapped, cc, mmap_locked,
 						 order);
-			if (ret == SCAN_SUCCEED) {
+
+			switch (ret) {
+			/* Cases were we continue to next collapse candidate */
+			case SCAN_SUCCEED:
 				collapsed += nr_pte_entries;
+				fallthrough;
+			case SCAN_PTE_MAPPED_HUGEPAGE:
 				continue;
+			/* Cases were lower orders might still succeed */
+			case SCAN_LACK_REFERENCED_PAGE:
+			case SCAN_EXCEED_NONE_PTE:
+			case SCAN_EXCEED_SWAP_PTE:
+			case SCAN_EXCEED_SHARED_PTE:
+			case SCAN_PAGE_LOCK:
+			case SCAN_PAGE_COUNT:
+			case SCAN_PAGE_LRU:
+			case SCAN_PAGE_NULL:
+			case SCAN_DEL_PAGE_LRU:
+			case SCAN_PTE_NON_PRESENT:
+			case SCAN_PTE_UFFD_WP:
+			case SCAN_ALLOC_HUGE_PAGE_FAIL:
+				goto next_order;
+			/* Cases were no further collapse is possible */
+			case SCAN_CGROUP_CHARGE_FAIL:
+			case SCAN_COPY_MC:
+			case SCAN_ADDRESS_RANGE:
+			case SCAN_NO_PTE_TABLE:
+			case SCAN_ANY_PROCESS:
+			case SCAN_VMA_NULL:
+			case SCAN_VMA_CHECK:
+			case SCAN_SCAN_ABORT:
+			case SCAN_PAGE_ANON:
+			case SCAN_PMD_MAPPED:
+			case SCAN_FAIL:
+			default:
+				return collapsed;
 			}
 		}
 
-- 
2.51.1


