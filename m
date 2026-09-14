Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8C66C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA85B6B00BC; Mon, 14 Sep 2026 08:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D80416B00BD; Mon, 14 Sep 2026 08:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDB16B00BE; Mon, 14 Sep 2026 08:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADEB76B00BC
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:32:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C54FC02A3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:13 +0000 (UTC)
X-FDA: 85212305346.05.0277733
Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	by imf16.hostedemail.com (Postfix) with ESMTP id 65E64180013
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:32:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=khIxBPYu;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.87 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tM7AT4CySnXG9qnjJlIVZqN32NxrLsvL8Z5QcRuM4tQ=;
	b=svrwLCZYA+mBuoQKv1shCXj0SON7FxnGbydrNJPY6uxhB+vHHLTPh6r73BPxSfHdHlgC1u
	ukkjhRvsLx1Qrxy94dWbxim8385q4Inr6EVDghpCVh2wsBZ6iaWliTwyOOxynzCuxm3xUG
	S7X9uG8ZJDuNyxmRUypvl7lkcKi10p4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389131;
	b=nMO6Ws8Lkc27ak8b/6yoxJ5KVwMRStWdmh4qfrptswLnxjXIh07cOih7V9pTMRWaZZAa/S
	QaXDPBk0ZTnjW6DrPMb9KWg6kE3wt9Wb6uxrZ7dUuhiY4Nrecbh+t/tPLmV4SrC9J89pT0
	05lGY3gbkT67AYzXd1QvbXqvqEhrk6A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=khIxBPYu;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.87 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qHCwemBvEHnl6RrkodLgJVOAA4pYdgV5Aeyu0ypk9I0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389130; v=1; x=1789993930;
 b=khIxBPYuAg5FmSdTIET+iSz+77DhfXdHs772s08vMSFKGBywDQZueERFl7DI7CK0If9efImv
 ZPyIUvWxC3N4VWON4a0G6fU74Zo7yq5wwEhIb49oMvcRbfDpYnQ7CQPzYcTGKLaeJq2Ee+1xr9Y
 7YdPKV8nQQ+GGW7CdnRoxiTk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id e967df5ce3b87961;
	Mon, 14 Sep 2026 12:32:10 +0000
X-Mizu-Trace-ID: e967df5ce3b87961
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [RESEND v7 26/29] mm: don't PTE-batch a swap-in over a hardware-poisoned subpage
Date: Mon, 14 Sep 2026 05:28:16 -0700
Message-ID: <20260914122950.3283997-27-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 65E64180013
X-Stat-Signature: dcgk37oufdkusywthjisrbmzis9ofuwr
X-Rspam-User: 
X-HE-Tag: 1789389131-971019
X-HE-Meta: U2FsdGVkX1+gnpY4wcPyiUWKn+8Qhzi0sa30mvWi8ucStlwv+5E2PQ852Yxo1WGij8RO/3EL5MNznuwNrsujTwd43waQRpVO9u8RRI9K0T8JQqgHYNsYR0yEpEiPboRX4THExAZKewxRUt/nd01rEbr9WzX44DCY+E5/Qu1El4ehvLBSljCXmYq5ahPi2sZ4IDn8nrqgiFG925StDJnCJjOVyTQd0iEd1v3jGq2Khjpk9uWtyeHhNyY8c4l3sgZPKdgGL72uv/aMe0swNsLRxP8ZmX3rmbD9u+QqTjXObcd+tKX/yLA2KD6pjmHZqrJJ3rd5MWhtT6oli4uvG/rRDfyWlW56rRuvMgQn+S3IQ+y1Z+l+B1nr9QG1uI/ET1vJf2Keo40ZvmFGWpqwDNdYEHupCZIC+AFSSogJ/+YJQUpgfYGz+2Kk4mRzPO2sO5ACXcPv5thodqhMKbdmDQExpFqh5VXoXSwHYQ9x9smJXyAAJU3WaVhSS+Q27BT9xw6NRIe6wcGl67Nmxb4qj5IFMNNH1iJ+TpCzoH1yKNqN+OF54d+wg4OscspPUgKKG6D1fqh8FlDJnOKrU+gm9Jw0XycqTwcF8xwWmC05CVx+djPrA1yrKVWE+fCrSbMtMUObGHBu4xdvWRSG/m7Z8uUrZ9OsGJwxAYZtcFhZdKwbyQZpVxbgDP1HcYwEoU//n/tQBvZzmgt0K/yGxi8EZeUxI0Fg3LbacIVH/yQd0msb6RmMnJxyXFSyn6ZyY5/4Y6oT9px7doq9Jj9pSzpHwowRmpRzpG5liZBAjp/7PWXWr8RCQZt7FbLkBALzi11ZjbllCJeL3QvKFI3jAhqZYi+LPaYLUqdGXQoO3CiZGc/CxzBhF2G2dRaw7wkMJEadgbNBRXg0ENJI8IO+E5v6DY3NU/DIYDmx2APVL755vSgSZTikRVXD6mAVkihuU0wYPNvs4fS6JZLAM+1pEff2K5I
 hKgt+iHq
 I1WF6ThKBnZ3W6TlotXKeZwbur817+e8l5/xbVVSbI8TTaIFNmUtJiCAeYhQT2FQ16VG+mGPKZqGD7A744burc5vESDf1VB9uogYDy+Mlvw1i5E/kGfQCWDzvx99m/olt3zkrCjSZ1oySocFhbsIo59CxUzDuSLqZeOjjJIaLTG9Kapo3a2dojJVTAHhIUZoHcyIqs9OKZzjAyqOf8gHLSSITVR5skWWz8zHf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_swap_page() checks PageHWPoison() on the faulting page, but the
large-folio batching path then maps the rest of the folio without looking
at the other subpages. A poisoned subpage that is not the one being faulted
gets mapped anyway, and the fault that would have reported it never
happens.

Skip batching for such a folio and let each page take its own fault, where
the existing check catches it. Test every subpage rather than the
folio-level PG_has_hwpoisoned: memory_failure() sets PageHWPoison() on the
subpage before it acquires the folio lock, which we hold here.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/memory.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 84e1e1c22bffa..aa1f67b378587 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5020,7 +5020,14 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	page_idx = 0;
 	address = vmf->address;
 	ptep = vmf->pte;
-	if (folio_test_large(folio) && folio_test_swapcache(folio)) {
+	/*
+	 * Scan every subpage rather than testing the folio-level
+	 * PG_has_hwpoisoned: memory_failure() sets PageHWPoison on the subpage
+	 * before it takes the folio lock, and we hold that lock, so the
+	 * folio-level flag can still be clear here.
+	 */
+	if (folio_test_large(folio) && folio_test_swapcache(folio) &&
+	    !folio_has_hwpoisoned_subpage(folio)) {
 		int nr = folio_nr_pages(folio);
 		unsigned long idx = folio_page_idx(folio, page);
 		unsigned long folio_start = address - idx * PAGE_SIZE;
-- 
2.53.0-Meta


