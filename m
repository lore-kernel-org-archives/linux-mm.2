Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D848ACD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5299B6B009B; Tue,  9 Jun 2026 07:46:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500B56B009D; Tue,  9 Jun 2026 07:46:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416896B009E; Tue,  9 Jun 2026 07:46:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3120C6B009B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:46:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 098601A04E8
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:46:22 +0000 (UTC)
X-FDA: 84860196204.24.C2CCA34
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 142E61A0006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:46:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e2uqfCws;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781005580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ObOhARDnYoUDbb8i2n+rNUP4GwUq2eJPlLo8BLvhF8w=;
	b=AesL/i9p1HGLOyDfDBNiedl+0tQMrogGlHPxDfM373qWS8GOIxOFTD9M7Pj85IH1+KLLb0
	V0/JnZ5IdhgZTIIVyRgMA4b0y3TQk8oHTg5DyNHJYRxnoh4UJOd9XM8ofA6wJq2OggDQ3n
	arzzU0vy3fNGVZ/uDsUGaG0Y/uRDQSo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e2uqfCws;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781005580;
	b=DOuAKf6VCFGxT52jPMKDTuFNoOiX0LMr+iKl3cBDY0sTGgcoQYY8Rb4TP3NHgRkoVNEI66
	RH+Hbr8wu5fWxPk68A1WHlqgIQlCLmqwW2jbSTrTha8QprYL1uPnhvuq2kLbt/f8m5p9qv
	H7Q8myIiZG8FYJZQl5XL5if1mvy+/Bg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781005579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ObOhARDnYoUDbb8i2n+rNUP4GwUq2eJPlLo8BLvhF8w=;
	b=e2uqfCwsi8WMrGUm34kkHdcu+mxCpQzMwKWi48ra/Vf/etzwkLzCrqr5NqHjN7OeCcLMmx
	+NH3rwF+aIAiGLDr6QBIIy/1rzzVoJg0nKsIx3tP0eyk5L6EBiV24a++Q51U2mG4Eo4o/6
	gZh70Ty+Mj/gcoAz1uH3BJln8u8OY/c=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-349-FQy-Xck9MNmZwWsqXVTlww-1; Tue,
 09 Jun 2026 07:46:12 -0400
X-MC-Unique: FQy-Xck9MNmZwWsqXVTlww-1
X-Mimecast-MFC-AGG-ID: FQy-Xck9MNmZwWsqXVTlww_1781005569
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C943B19540C1;
	Tue,  9 Jun 2026 11:46:08 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.44.22.33])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 24004195419E;
	Tue,  9 Jun 2026 11:45:58 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Usama Arif <usamaarif642@gmail.com>,
	Yu Zhao <yuzhao@google.com>
Cc: aarcange@redhat.com,
	Nico Pache <npache@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting from interacting with KSM
Date: Tue,  9 Jun 2026 05:46:14 -0600
Message-ID: <20260609114619.144416-3-npache@redhat.com>
In-Reply-To: <20260609114619.144416-1-npache@redhat.com>
References: <20260609114619.144416-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: ZXb9G-WhMbhYPr-HKvX-6pqgLodIQJDFJ1jDmZgVDP8_1781005569
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 142E61A0006
X-Stat-Signature: 8mkysiy81cwjujupn53irniww1nrxaz9
X-Rspam-User: 
X-HE-Tag: 1781005579-574452
X-HE-Meta: U2FsdGVkX1+hnGEXP7Dep8L9fgD5d9alajXgmS0bBY3iouWj+WLRNh5WVtOTDxx2ubGMc8FHnivIXi8sHAaIXPEHjkHLYVcvb5zqKK8Y8r4vx8d6FpZ0lVVP1St1MWDcxVuMTgdRsR0qjCf6nVf/TB9lDETOjiZtQwju3s3mQI9g3VY2hdq4Ra43z6QFfVOZSCb6/868INAwnUNs8Aey2Zez75UoaNxdPPz1wS9bLDA8+VKq72CVCcMoCTD0g8Q4T/Ui2/fUU62T/mR+pG09JE6u88QRYz1FBmT3twdSwVZXYCgyoE2NwVNOrpUL0huwaktfSOcIrOXb+YLvGK8TCQEv6M8kTqDuysyOU43LRk7MRxeFiaM8u7b8tksK6zJEXc57kToV1JD1F7SNPBh+TSUxJwAuUwErmACV6xu4t9U8njzc13GaRQLekSjaConjlpiL1/9wdXLYd2wA1j6RF9qLcMVmSaml6D7WuLBlsHDUlsfmZXvXmo1znshDNHu3JvateVhbqASC1bPErg1Idsvo3H/AjHMVYPfIGxP2XlQIPJEuZWOJdJ1ZS9ZQmc8JmFrTF1u27++n77xgfcQ7UvrlKPrnosLslCCBk2QgZ4XENmzPB9iWEvzZCE33CP424uwpP1UeM0Ig5cRBahVn032gF2IpTVCHc3SkyhWcgCu7sd8dWA0cYsbrlif+1GfR+h9wxPyEt1qxEm9nd2iTCT1WXxQUY9E47rJIl4RTNG7tu6CWQLS/pv8SEmLe0oXyUb6WSiYLaPVTuBK4K2gNU13LcTbN2AsW5s6fQn+bbWx6/cWcjXB7/hlgsOYOnQ6jbuc6GmsMC7X1EbwxJ6v1dHssCW7uO1LnB5xElbsF6C1BdY68ZOQquXtcpLEVMGAkLw51+LvRBBfnJMcGKJ+UsE2eLRIvhbkmKsVIp3WTS/cP+QJkGmm6ywhUuRPHo0DCdTOEmjomgr9Tr0uhHhx
 rx4YZRiR
 QO9LQTYumgEOkrO/Tyz6F1aRFWWEmboKBspb1AbrYCZG39ETFMwcE6F3Ph4HFjHp8/2rV0wuVktnY8AhLt5zb059/kGPCcABc168olBlA1h2ikSPMe3kCD3aPYD13xooMht1RTbnO7YREJB6vNtptM9wCAKKGQsf9yG444v0e469R1cBacE7+7scJMwfXXQd9j7Qw3fc2hntwpK+uQCNO5Cq5PzeM751bHMlV69fuaAdCQdAUuLt8Mo2ykiOjoJ3fkgF2ytsRxZpdKoBzB89svycDnzrv/dzsxZRloQl5nm6J4W54b3bl1MSRzqDsB6lu5r3XHt7GKlOvt9pEEjhKyHsilp/uAtpKl2IFFpf3lbQNIjaoc95ywZ5eTbL57p/QNA+GZ1VKBaSfNNYR4D1zWaIPZEY5CZiwcOCz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
when splitting isolated thp"), splitting an anonymous THP remaps all
zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
This flag is set unconditionally for every anonymous folio split,
including splits triggered by KSM.

When KSM is enabled with THP=always, this causes two regressions:

1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
   split_huge_page(). The split remaps all 512 zero-filled subpages to
   the shared zeropage at once, freeing the entire 2MB THP when KSM only
   intended to process a single 4KB page. This bypasses KSM's
   pages_to_scan rate limiting, causing ~1GB to be freed almost
   instantly.

2. use_zero_pages=0: The same split side-effect occurs through the
   stable/unstable tree merge paths. Each pages_to_scan iteration
   triggers an expensive split_huge_page() that silently frees 2MB,
   while the scanner wastes cycles on tree searches for zero-filled
   pages that were already freed as a side-effect.

Fix this by restricting TTU_USE_SHARED_ZEROPAGE being set in the case that
KSM is running and the VMA has VM_MERGEABLE.

Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/migrate.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index d9b23909d716..f410f972fc5e 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -304,6 +304,15 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 	if (PageCompound(page) || PageHWPoison(page))
 		return false;
 
+	/*
+	 * Let KSM handle the zero-filled page deduplication according to its
+	 * own rate limit (pages_to_scan) and policy (use_zero_pages). Without
+	 * this, a KSM-triggered THP split would remap all zero-filled subpages
+	 * to the shared zeropage as a side effect.
+	 */
+	if (ksm_is_running() && (pvmw->vma->vm_flags & VM_MERGEABLE))
+		return false;
+
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(pte_present(old_pte), page);
-- 
2.54.0


