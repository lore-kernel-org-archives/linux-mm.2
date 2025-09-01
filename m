Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36828CA1007
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F2028E001F; Mon,  1 Sep 2025 11:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9248E0076; Mon,  1 Sep 2025 11:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4C38E001F; Mon,  1 Sep 2025 11:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 646C48E001F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:06:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35EB0C08E9
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:06:32 +0000 (UTC)
X-FDA: 83841007824.07.E6BAE93
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 87C8740018
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:06:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eA747Ep2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTgr/pqX3UqVNNKIBPC5IiEd0D/dsfuHo0zqlHJEFcE=;
	b=ZAESr5/V/q30EiA1Qo7S33ksR5gu99V+hmK9zUq6dbEHcF7DDe6/69FObM/kT/+lwjYw0V
	fGOGDNRe6GmzQF75wifNi5lqVtbg7AY/LKUvZYCAsXrklFtRkSGUAcxTGWpn1v7f+iRoC8
	x4wxbXYBKRZ/2n20k1XCDRB5J8+7JiM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eA747Ep2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739190; a=rsa-sha256;
	cv=none;
	b=hw5Yw4QI0a9UoKwZkzQ9MYhAnnb1YV2bqKvG3ObCde2qkV5TIHSXX/Z5Hws925L7vaNCWR
	LiPwWqUOb8BlRNXVCKr4KikYvu05r3fKLsWlNjXWh3FDM397jNNsXIb0xgQj1f0mGz0Wx2
	qZGrIeqAYH1mEVBhnT7o5Y6ffdGazQM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NTgr/pqX3UqVNNKIBPC5IiEd0D/dsfuHo0zqlHJEFcE=;
	b=eA747Ep2cF4HPCLTUtI5YTDsPmguX2kDtowiYtA1+C0NNGTJJHlQGkP8MBAdWjAn3u+dVc
	z+SV7BrjDunLhdf1dADs2TMwqiPbH515TfslMqD+7az58uayEqrOc72J27Q0aiN/VHtJa8
	pP0MrKS4iXnp2GDi4QqLLL0xTjDxdhM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-LWOuJP0QNQig9xOBt6uhiw-1; Mon,
 01 Sep 2025 11:06:25 -0400
X-MC-Unique: LWOuJP0QNQig9xOBt6uhiw-1
X-Mimecast-MFC-AGG-ID: LWOuJP0QNQig9xOBt6uhiw_1756739180
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 330D5195608A;
	Mon,  1 Sep 2025 15:06:17 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 344B51800280;
	Mon,  1 Sep 2025 15:06:01 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	SeongJae Park <sj@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org
Subject: [PATCH v2 06/37] mm/page_alloc: reject unreasonable folio/compound page sizes in alloc_contig_range_noprof()
Date: Mon,  1 Sep 2025 17:03:27 +0200
Message-ID: <20250901150359.867252-7-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 87C8740018
X-Stat-Signature: dcohyb5ioacautj1rtx5q9y5rapq9npu
X-Rspam-User: 
X-HE-Tag: 1756739190-948163
X-HE-Meta: U2FsdGVkX1+PahPFbyByhmgUeO2P2oX+PUSQW7ucJdLINXW13aX8GTxMHZhoKRtHrbyu199UMMiUCs6OeWV7iFEjTOYeRW8FSIdXv2Jq+V7GQ8UQwiVmPahmAxCUKvocex7X7Np872Wvxi5MClb+5ofC47OBMTXyiCyq9v7NvGTwWfAq1WdOFgEyoWjJcaNeR2vS6k1RAkCZq1FMkp+lJbOpiROtuamHKzwuvapW/6BKZJZ7OSwKPdkCDQMCRLnR0Ax1QB9paMcMgF+vhRSkMMvR1dUJxw4zLeTGX6fMZEjIne+g1pNCGFL9nhHnQlvJzb/KKBOVv2/M6ZttKUj3+Gz+MaVXfNHq2n2xUTxGGDMWzpH2WMTaPb/dm/xZry/+XZtA239UuuV3s4XusIt6L4w+BN6oVwUnBjMPmEq4txNsiDgBPo6Gn28e8VYLxNb3+XVXC0sX/uFlrADa2X50b9g4YcKpBheukCPeKy97teRNQNcVia23Xv8ir+LHEdYzQ5zPt8Gptwn97B3EZqyKLl1UsmOqM3t1v5LZxU6U5b26Zocnpg2y4gi9GLM49qPwFw9y2Jzo1/Iu0nBlAnME7WoKrS7GEtKcf2JWy60ReTBKxkevKS1vFtxBQ4TtpxbjYa8x/MMWISRX+Xxn/F3ODos5QsA9gGjcKhkJAu77WSVzH/N/kEQpEzZdkPR6VDPj5qMaQIox/672Sua9z/eqtuvtY1u5WgfmNdHW63l0bOr30ikUILyJ68GVt8H+7INA1iqMNXQ777uypyEwU9WAMpRVYKGqq/nBAsQJNxnSQ+iHTQx+kj1KGvNn2bbiXVypeZgyXZL4/LW9S8Cl93cIVNLdf7caVkWTuGd5FoVl8xqbpoZn1y3FtZexkzSqGME3WsM/yuTWP/DJtQLrboX75tyuqPMij9Q0Dg0iRVOxNstwoG/MSIo/nTWbRsjGkdlfUb0cujAed+Z7dO/as0x
 n8S/zpFj
 VFLB/38GQ5mv8x1qYsqD77wTtdUQF2o77skQygd8NcsAg7d4DSEv0WWotZPDQcU+MpowB0MGoj7Xuex1yx5I9o2oEakjobi7R9jpSBy1ASQvKuCsG9aLqnRGHMc/YusXeaYqJjROM0honzHUOParjCRmzFIThW3Se4799FcgJ+2LI9wm/6z+EQt3HNtKVPYn70q6YRLa6cwwb0s+1pjN8oBje2UmSM2rR6jUfaZgANQebKQ2PcM9z3Njhg9EII3o1S2Xz/pBG5Et58MhEYz2B6AZoYcefhiun6082rmqmjFOeaJ+wD+c1zk+RrvV0lguxfg1bF4o/24oq6DRxZ0fzmnITxg3VNE6tM+6//cni5Ize3uIJ1nocGaQBjmvOuOCgVI0pD0FYEp7zdH3JByrUszhG0sHCOWpb62HoQsw7ReucDFEu0bSBkjvNNCciEU9ME42I+ZlHN8PGE0PLNgGdBcDZ313XyDQKXytYchEWzX7dbkaEICdoa9EgHZbXQ6ypww2ShcqL5BwwlQeTFiZTTpc+mHFn+j3OSIs8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's reject them early, which in turn makes folio_alloc_gigantic() reject
them properly.

To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
and calculate MAX_FOLIO_NR_PAGES based on that.

While at it, let's just make the order a "const unsigned order".

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h |  6 ++++--
 mm/page_alloc.c    | 10 +++++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 00c8a54127d37..77737cbf2216a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2055,11 +2055,13 @@ static inline long folio_nr_pages(const struct folio *folio)
 
 /* Only hugetlbfs can allocate folios larger than MAX_ORDER */
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
-#define MAX_FOLIO_NR_PAGES	(1UL << PUD_ORDER)
+#define MAX_FOLIO_ORDER		PUD_ORDER
 #else
-#define MAX_FOLIO_NR_PAGES	MAX_ORDER_NR_PAGES
+#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
 #endif
 
+#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
+
 /*
  * compound_nr() returns the number of pages in this potentially compound
  * page.  compound_nr() can be called on a tail page, and is defined to
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 27ea4c7acd158..7e96c69a06ccb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6841,6 +6841,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 			      acr_flags_t alloc_flags, gfp_t gfp_mask)
 {
+	const unsigned int order = ilog2(end - start);
 	unsigned long outer_start, outer_end;
 	int ret = 0;
 
@@ -6858,6 +6859,14 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 					    PB_ISOLATE_MODE_CMA_ALLOC :
 					    PB_ISOLATE_MODE_OTHER;
 
+	/*
+	 * In contrast to the buddy, we allow for orders here that exceed
+	 * MAX_PAGE_ORDER, so we must manually make sure that we are not
+	 * exceeding the maximum folio order.
+	 */
+	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
+		return -EINVAL;
+
 	gfp_mask = current_gfp_context(gfp_mask);
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
 		return -EINVAL;
@@ -6955,7 +6964,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
 			free_contig_range(end, outer_end - end);
 	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
 		struct page *head = pfn_to_page(start);
-		int order = ilog2(end - start);
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
-- 
2.50.1


