Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEC54D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211C16B033C; Thu, 22 Jan 2026 14:32:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1912F6B033E; Thu, 22 Jan 2026 14:32:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0287D6B033F; Thu, 22 Jan 2026 14:32:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E70E06B033C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:32:34 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E23EC33CD
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:32:34 +0000 (UTC)
X-FDA: 84360596628.18.77F3C9F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7F88940003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:32:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X4lGLBPu;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4RhMmE0j15+AytfNHqSYxoudGtkDedyV3jj2GyoY8E=;
	b=ftTvjuWvI9f1W0H/BSJaPPv3SxAoWOjTVAzwyyf7NERar6E+EmIgPUBbn+63WzNUr0Zs2A
	pfvz1nU9EOqRRYltkt4TpiNWXA3r6vJwLLWgOaB0tVkpbVSdTSNJF/4XYZaATGgt2y9Aav
	3/W4W14YBh/9DxIIZ3LNSimfdLQU+sU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X4lGLBPu;
	spf=pass (imf12.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769110352; a=rsa-sha256;
	cv=none;
	b=5FRlbTkwBEJs+0CUX4J0X8osX+twp0lQrSiWpjpIMcrNpvYxArcaI7IAPDwDSJIK7pG805
	zv3lBQ3i8ofmtMN4klMX4B78uO4Uu9xhzlBQbIfMdfuq/vLMBVi3POzycvz+U3ieiCRz55
	cAnZ3N5/3mQLv5s+nSR7ObiZSkukG9E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769110351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d4RhMmE0j15+AytfNHqSYxoudGtkDedyV3jj2GyoY8E=;
	b=X4lGLBPuhGVSRcSTQnazyEC4rhKB89VmBYsaagM2WU0MWxoOMk2X+wYqYI132chQJdJYCC
	kYt7/BO5le7sgxmhK+WaqayL1UcCyKEaY9shgYPNsyTG0n8uu3QNJQY01rzbNyL9uk8ZRy
	L2Z/OkQrJA8BrAF5spgiq3O8IZ3DwD4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-497-jBjK4Bc1Oi-5nCt_Q7lo5A-1; Thu,
 22 Jan 2026 14:32:25 -0500
X-MC-Unique: jBjK4Bc1Oi-5nCt_Q7lo5A-1
X-Mimecast-MFC-AGG-ID: jBjK4Bc1Oi-5nCt_Q7lo5A_1769110340
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5EF55180045C;
	Thu, 22 Jan 2026 19:32:20 +0000 (UTC)
Received: from h1.redhat.com (unknown [10.22.88.59])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2D8091958DC1;
	Thu, 22 Jan 2026 19:32:11 +0000 (UTC)
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
Subject: [PATCH mm-unstable v14 14/16] khugepaged: avoid unnecessary mTHP collapse attempts
Date: Thu, 22 Jan 2026 12:28:39 -0700
Message-ID: <20260122192841.128719-15-npache@redhat.com>
In-Reply-To: <20260122192841.128719-1-npache@redhat.com>
References: <20260122192841.128719-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TsYaH6nbZkbimSCCi9hUz90Pnnvncc-ZLwi2PFdj070_1769110340
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: zpabzwpudjremgqbubj5t855pxwy3qki
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7F88940003
X-HE-Tag: 1769110352-60631
X-HE-Meta: U2FsdGVkX19wRZNmU1h4HlMXA6LD/bvKWNiOHcXcXtWQhUUi3jPlFlGI8lN7zv+UwwH1ov7sF8q4VCM2GA2WD39Ph0ItyEORIINE5JoBKFtMFoUl2Sqnw1uX5q8RrPzLPU77EBLSulojXC9BmQwdbMPN12FBnplPIJWJCJnW+jR4ezDzclOsfpFAZgDjPwxE3H6W9eximzEwec2HdRreGivjp08TmomCzc1EZylO8psOCHaIXhmJACApQSCfNd5CJbq+K1pxoLim+xAbuwR96ZNNfdKQ2NOzmNVJYlVIP2kz6rLfDZYwHkfnGZZ/gOk/KW50PzrbplbPQgO/fUsI9GjmSrWznfYNPpd0k1UCtPUZitIeMlk/29LbWfFyYHrmliQ+0xUFevkl2jjuPUlRunPdbHZODdBp9gqsqcLfbvXUhpY/2j2VbHuaXvGxJKN5lenO7V9lSVAMbw8m5TASPGkrMNaebXlOGuXDeuSBa7RxeoP20FavvHJ2CNSnoj9spQGS1bd17R1oypP7F7U6WLyfE+IRBd+dsHOTcqsx0C+OXwwsFhleM3JjszAKXNM2+Z4ulBgZPcVX2sB9+4YaEHvqMEoyf46xPckQm6xW1UBYP63KsqFIMgpXzJ5Db+TLHawAMaYzoWXwuBs0spM8st7755/RXyolv65wpomGh+vzbGG4PQpAn7BWF3dlJVm0P6VTGAZr990jLYdjEK3HRt8N4eMaTBSNNZiPSub807YWiG5Kyov4xMKEPc7LwZSZO6JAbrIL+5q8mHgRYVMNVTZSW5pRvjdI4Q3qMmfcoYpbzL7PAuz7W0HhUStcvY/SoWYo2L3YGXIrVV+lA1sGrFQt4jEdpjG8ZGoBDT+mL0QrAUT0uVornhEafVw0ESgtvn7hTAFro9vF0CdqoEwx5C8+Agd/LpBP5oH/qNIICaxLA7cAELQr90poFOeUlwRqIc5JeKLG8Icwl6+ePh5
 VMT/etny
 Ltd9cMeBwFfv1j505s2Ycx5K+7880KLoa2RAvVimESoT2CeCAB8Jsgapg39JuMoIR36d2si5xj/WhCD7sz85+2/8jAI9Mmt5RSnf8kryM9J3mafVo9iRDUcDYuHUqIaRuwfsdZuL+E8m8MOltsynhwhyLt1IZXa5NyXvRRx26rCj6GJyIa3P+5F6BQRJEqXnURoiO7XcfkavRvFpKISwDykuP66zPzAsZ7vp+A+4ut9Y4T16aMNXQ1Y5ETmyMfUWKmVGEwrHoJbQr7fBgJek08i8rgr31PXPS0At1Uyl1Fn8H3JfKuoZhM96DuKOGaFFZEi0WYb8DPIj4/ztQFRVsVlc8Zy9hg7FScZxQ2Rk/rRuehsvJbj73updQGkW1B4+kxZQSGCO058yLayelC1SXriJ+kQNSz2nJk5/M
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
index 5947faaba85f..344f7cec55b4 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1499,9 +1499,42 @@ static int mthp_collapse(struct mm_struct *mm, unsigned long address,
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
2.52.0


