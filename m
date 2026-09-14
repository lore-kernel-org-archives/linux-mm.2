Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84C45C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82F726B009D; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FB6A6B00A4; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EBEC6B009E; Mon, 14 Sep 2026 13:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 064536B009F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:15:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D039401EB
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:59 +0000 (UTC)
X-FDA: 85213020438.30.B65A2BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5911D40004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JByXqX0q;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406157;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LzE5LDsRKWp4syshM/I27mCoMfncqItz/14BUbMkrc=;
	b=JFetTnD45dlF2bjy7SWMr4z3Uhfz7fGw9GET/7L36KQJ0YWgNBsJZAo1X3DEa762OQglDC
	vOdgLbXPNFQkUt/YwhfHWjG1fIG6F4KVax0vWeKJMsnp2DPApGgqchpWDbrGzUiCHXRzJR
	17NSIgK5jUtskXAkOkEDhZs/em3uGZo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406157;
	b=3C42Jk18OveLgFpbQIiAxQx73y0e9a78BpoPnXAomRKSMqTtONgbTWVUHFWRuD3cRQXk3C
	v7XRFNMD5dQVM4tj0wo+z3g6NqDIpLVDhhtRZhcBOr9gW+1iwikxn8krjBR3iAYrGI6vyx
	cB5iRi8dpkcikxLo1lLEthyRfmyvEoU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JByXqX0q;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2621043E7F;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06E07C2BCFB;
	Mon, 14 Sep 2026 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406154;
	bh=sKZDHoz+RJ+OQK9FQGfaH8WBjdnFCdhcSJKgZrGIdmI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JByXqX0q1j26XX2lDvOpIH0Jm5gVey8pDRqt4XSl1DQFUmeOZSdQ2TuiQ+CGWcpk3
	 J5hwpSeCfkI0hpiXzU1KjX0RNxSdIpHTFsrVh9zhkzalsY11iz2Mt0Hx+YpiBqFhzp
	 ve5BRisXHzo01mQaHxAp0AKk9juJVh04MkLGvweISMIFe9dwlW3+QyzT5Xg8V9ft3r
	 AKwbxdGYIHLKE3tXPRsPZqaWeNAPKqMmcS38Cr8FiKNR5t2VXZ1Lfb1spvR8yMtcQj
	 ettM/u3220dM0ySii+u2liQY1Dmjow/AKrYd0KqSRGFZYxLy16EwluTVFC5JOgYpXB
	 tPzmTNy5nLurQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E766EC88E6F;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:47 +0800
Subject: [PATCH v5 06/17] mm/huge_memory: consolidate irq and locking for
 folio split
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-6-39878b37dfb0@tencent.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
In-Reply-To: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=4898;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=9nADEDAf7Q9o9bXChgiHRbBnW7jE6WqRyVFeq9s3Ky0=;
 b=03mBbAMWRAHMpV7mScz8iM+udOGiUuGVdjnxWdWseAaIHfdPl7Iv3bMw/akl6nNTGxkjw4FWx
 TwBHbqINGedCi2EC3lsm3zWPq7OC7McZmGyyaBUcB4nwGRvpu8c9i3p
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: s44693fm53szd58wyoryzbmsr6415snr
X-Rspam-User: 
X-Rspamd-Queue-Id: 5911D40004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789406157-230917
X-HE-Meta: U2FsdGVkX196xt9rnExSsKMUffLqRyUDKppEySg6Hg3RjGgwMFVM3gup3IOnZ4PT3V9XQMVZHsOjuM9ij02jdQILmoRfsiSyibcvtP2BLVagxUFRSNTAPlL6CWW8w3kwwokwt99LDqB9vPneTyVeMDjzzTisfHF4nbK2P47P2ehdwZJxdC/qcOMGaTii2R/H3v0nx6tEYttYizVM6fA8eTxzjatoQjBv6r//LF4aLrf9Nx341V92EGjplYZxsYG/kUyLgrShVFXr4GSVac+cpfUxrDAM4ry7A5yUkWVxYgEvEWHH9Vjd653rnLk2ditqNHk/oV5OeIBxNdoCVV+/2hzmCFA92l6FmcrAlzUFSM9QZ35oaaQLeRC9g8J7s48kUXGU2BulyQIC5DazUp1H1a7+e9E2C3+JsWn3PJhsIlShjTlhm/1byDtUCxDDK4aXmVwDcitbSZWHqpOtSn7u+4hWq7H35ROiWp4ryfxrKE/bfP5SRsj4m+gFrydelGDqOkBs+UxzJy3HjbQJ2wFJ5hBthDVCapjXs4Jkp9YxlXcQMcWWDusaGr4LyqQcQ7PALGllvksD0cXGD+2EFrtPPEEJjRrWKaXuPmWlLwwETJB6gf7kDYB+jjW6ZqgnJJsUXg2hL1/Yr2GNi5jxQjfsDbPMBDebo3iJdlBq1kysW7ab8/8n3DGxR1b736u72l2eA8lHI3QhGWYfJg5cIoCh1mQeB8nB8+mH3lQlMd2WDrxLZi70w2KUMYZvxziDjF761BZZo75BKMNsohguqr1FrvZk3sB9wSy3ehiut2EgoeQq3pYsJ+HgcZpBt5fQGU347o5sRXpxLQcTL/wvChRdWHdRJtN++IOXbtwsTR508we3Av+PywirsJQXnpjUaLo9rCnuQeIjhcTtLrw26C8qUue6z7eSL4ch7z9xYs8biqPRxa6bI2/zuMDcuVHw2gSk9oYtD9EVSKRUR5DbOWa
 odVnm7VG
 t3osFRnR4daGEHjQG1v9iKVt93zvnEqaxwesMvaHqDIq3vgRuA3tBgUiA2+aazge7irAzlatFcQ42vZKhwuL0jb3ScHHxgUg6G+r/Bge3SJQnDR2B1EiOjU0FNeicj1FZyr8ZJAU+QjJvc5RFEyPuYJkRGQ4HOCifiiQH05nZ5bsRqyJcr+tkK4k2udb01LKmC68LumIcuuj8YajYbmed+Tkcvjggz0fI3UAXhMqp2kUsDnhpJt0xf3gj8IS9scdNpDJor75ZXkvLfSMZcfaPzAYP9MsQ67SyxQPcKCUXnKkwLSb3NpyI17sRbHKTrYOEMgO48cuStyleItURYGVGMb41ZTbRlMeABgVXp05Neh5B+Cq+zo8OsjIH3VHJ2ZLqMBLKMMZ1O5cy7geJKUrvJrbXWADsED4KCij3HE6fw+k8UzqHP/Ntd4vEg/ZBnKMkRvoHJpaS73oXNdU2ZYYoARBVN4IbI/docQwzMV0CXaupEk1IIgahu7DYX5icf7cS2gEeHnjcCgKlfl7qx8zEGkT28SRlr2xng0bSHrFzbxOOjpqe/EBz4tbM9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Let each split helper handle its own locking instead of relying on
the caller, so both helpers manage their own irq and locking state.
This lets __folio_split() drop its local irq handling and fail label,
preparing for further cleanup.

The file path now uses xas_lock_irq() instead of local_irq_disable()
with xas_lock(). The two are equivalent on non-RT, and
TRANSPARENT_HUGEPAGE cannot be enabled on RT anyway. This conversion
also buys consistency: every other place in mm/ that freezes a folio
while it is still reachable through the page cache already takes the
lock this way. This was actually the last plain xas_lock() on
mapping->i_pages left in mm. If we are going to support RT, spinning
on frozen folio refs could be a problem, but it already exists in
many places and should be fixed generically.

The anon helper keeps a single local_irq_disable() as before, because
it has to cover several plain spinlocks at once.

The dropped xas_reset() was a no-op as the xa_state is not walked
before the xas_load() under the lock.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 58 ++++++++++++++++++++++++++------------------------------
 1 file changed, 27 insertions(+), 31 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 35c48eaf038f..d0e2f1801d6f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4021,8 +4021,12 @@ static int __folio_freeze_split_anon(struct folio *folio,
 	struct lruvec *lruvec;
 	int ret = 0;
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
+	local_irq_disable();
+
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+		local_irq_enable();
 		return -EAGAIN;
+	}
 
 	/* Take off the deferred split queue while frozen and memcg set */
 	folio_unqueue_deferred_split(folio);
@@ -4070,6 +4074,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 		lruvec_unlock(lruvec);
 	if (ci)
 		swap_cluster_unlock(ci);
+	local_irq_enable();
 
 	return ret;
 }
@@ -4088,8 +4093,21 @@ static int __folio_freeze_split_file(struct folio *folio,
 	/* Currently device private folios can only back anonymous memory. */
 	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
 
-	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
-		return -EAGAIN;
+	xas_lock_irq(xas);
+
+	/*
+	 * Check if the folio is present in page cache.
+	 * We assume all tail are present too, if folio is there.
+	 */
+	if (xas_load(xas) != folio) {
+		ret = -EAGAIN;
+		goto fail;
+	}
+
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
+		ret = -EAGAIN;
+		goto fail;
+	}
 
 	if (folio_test_pmd_mappable(folio) &&
 	    new_order < HPAGE_PMD_ORDER) {
@@ -4161,6 +4179,8 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (do_lru)
 		lruvec_unlock(lruvec);
 
+fail:
+	xas_unlock_irq(xas);
 	return ret;
 }
 
@@ -4300,32 +4320,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	unmap_folio(folio);
 
-	/* block interrupt reentry in xa_lock and spinlock */
-	local_irq_disable();
-	if (is_anon) {
+	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
-	} else {
-		/*
-		 * Check if the folio is present in page cache.
-		 * We assume all tail are present too, if folio is there.
-		 */
-		xas_lock(&xas);
-		xas_reset(&xas);
-		if (xas_load(&xas) != folio) {
-			ret = -EAGAIN;
-			goto fail;
-		}
+	else
 		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
 						true, list, split_type, end,
 						&nr_shmem_dropped);
-	}
-
-fail:
-	if (mapping)
-		xas_unlock(&xas);
-
-	local_irq_enable();
 
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
@@ -4409,8 +4410,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  */
 int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 {
-	int ret = 0;
-
 	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
@@ -4419,11 +4418,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
 
-	local_irq_disable();
-	ret = __folio_freeze_split_anon(folio, new_order, &folio->page,
-					false, NULL, SPLIT_TYPE_UNIFORM);
-	local_irq_enable();
-	return ret;
+	return __folio_freeze_split_anon(folio, new_order, &folio->page,
+					 false, NULL, SPLIT_TYPE_UNIFORM);
 }
 
 /*

-- 
2.55.0



