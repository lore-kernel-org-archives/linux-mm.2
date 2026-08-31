Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C473C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15CAD6B0092; Mon, 31 Aug 2026 09:35:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10DD96B0095; Mon, 31 Aug 2026 09:35:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0243E6B0096; Mon, 31 Aug 2026 09:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D56646B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:35:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6927D1C0243
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:35:48 +0000 (UTC)
X-FDA: 85161662376.11.E8DA4ED
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf11.hostedemail.com (Postfix) with ESMTP id C2F0E40002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:35:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LWrUCsyp;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf11.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788183345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/ZOvr0cFnO+KxNXzKLYo9hHd8muTFSoABjiNPb5SQo=;
	b=VSlhn4lcmcBjWgr41TiUMdWQXFFpM3nFY4a/leSW7QM3nGIHOV+5h2N9LsclbjCzEMyP77
	HhPlwFIGUl4rb5fRfn4F1GHpSsdadrtupVM9fstQ4z4KFdJw9l8S2E8MPl7EWzfxWbiZXb
	2DvfD8lB7F3rD6+FEmJZnm3JPzJc37Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LWrUCsyp;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf11.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788183345;
	b=U7Vg/EQwd/++iy6Yow2oIvYuIZnHUfYLiHedgaiUqeppcqh83CpZz8clFlgGLHaF7P/DxG
	F7g5+/AttQYIvm+WFNe4aqS7fbcZhGQffcTM3KJVCwOtp4AmD+K47eyJyAuGJWon4u/elG
	lDHsWl/M1qQugxzuL799cTuCRpI6PMM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=w/
	ZOvr0cFnO+KxNXzKLYo9hHd8muTFSoABjiNPb5SQo=; b=LWrUCsyp6sBJRjuFFH
	WoX/i60LcZJIhpl9tb8texE4kWXekPjEjDwGD0GBLWceXAlSipmfOb1zX3SH5iGW
	Nndy4j6SMPn2S98e9bLe+YVaEsNI7xnQl0qloYEDZnJH2MgTjYLRYO3oxjymQtLj
	9Ag1QdX40jVFjzUjGlD6nfAW8=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wBHHmEbg5VqFKS5Sg--.13223S4;
	Mon, 31 Aug 2026 21:35:27 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	mike.kravetz@oracle.com,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH v2 2/2] mm/hugetlb: cap demotion at currently available free pages
Date: Mon, 31 Aug 2026 21:35:19 +0800
Message-ID: <20260831133519.2505020-3-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831133519.2505020-1-xialonglong2025@163.com>
References: <20260831133519.2505020-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHHmEbg5VqFKS5Sg--.13223S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxZr17Cw1xArW5Aw45tF1rCrg_yoWrJFy5pr
	W8tw1Sk3ykZF9rGr1Sqw1Dt3WfZw4xKrWrA34fJ3y5Zw13X3sF9r1xJryUZa4xuFWfJanI
	9F4DZ34DZry5XaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jc6p9UUUUU=
X-Originating-IP: [39.144.46.203]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+B-n4GqVgx+NqAAA3m
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C2F0E40002
X-Stat-Signature: b4d95qzmmoeif9hhkntixyzpj83rbeae
X-Rspam-User: 
X-HE-Tag: 1788183344-469420
X-HE-Meta: U2FsdGVkX18SrR5NUQkp3+oTNhFQOC50akueIzkX73dJkvLHWnuLPRNfCmAox7T36kFEXrZHQAykmg1UoeNBADg+s5ONzkQbbV8IKP8n/oiDM6D9fFjW78+taUeHtbWxzWzgN8TSACylec1YDZ6B2iGtid/PPLVN1dFDcwd16tTjftZSuViumbUoIU8OEscwy9SJawgSGsipOmmvy9IZHu6XZyGrEtmh4zaPJ1CtR6q9zQpGQrWoHcgzy+aFDaNkXAUbsP/vc+A4eO5FESs6NhdbXKYIufJD3lbnyWwR+9nbO9FO6XpylQkOIvhflsKf1PwxCnotHPFlfqSfYhRx9UuZPUbpifvX6pQZaVzUnbhpVw7rbJHsSly2BenibXlivEzEsVH0ZdwiIIXvapcTN8malg/Gq2G/1AYJ2y4kFxVIGR5WnQ0ilg/TKM4oISMPrecEKtj9vC7wQyXZzXPW7CLN77Eg1FdPvLGNcjxz6fmNqPCoh6UeZXtHkGrTgdSNIrMbYLVJQaFYDzKOWVpV0DWgsaBssS3QKBNs99egDPW6ps98d1OPnzsYQz08HRf4JYZl01S+VjZXmKLjGl3wKiv2IYcA1CE8GOLlyBxzhboDSiEX2gn7IdB7tRlHMsJm9EtQZHv7ZuO0jZF0BIoyh2H5Q8/FpsGEFXr4IrbR0gGD+U7IhW51/PNRquZUyU+TWRvqUH3eLoPa7zdEO3J9E6MPlsS3gH48ebez3eZoCbELKaCEL0iJsDabEZEgzeMeKg2YoecmkR5lY1tRTIrHqNcRi5Q+LqNdu9DOeZ0jhYgkBCUssS8Qx9dHLl17EztzMYF8KtZMaiwhMrQTDeHzKMciBRxbCvCx6UfdFg8dSf8dy9uUowAgW1SjZprRPbwRfQRuJ3Z1UVyYFPUwM95xOFo5mE1y5M5T4o0+JKpvd4DwWQcsO8PmrNMKW5Bo2Gz3cZdAZ15oxJIDa3KgltE
 WtOgIvnn
 6Kyk2T8vGRjZkDo1ynhqh6tUzjzY7cDyLcKfwzyK2qMdt5zmZPsqhs9V3on8rW6lVWuMtr1DLIqYqC05zu2qCBHHEzfcXSEXBCCH8KtaQ3Vbsff7eSXBxjAKi1rGnjVjy8qo8/0Ge3tMaKUb3WX08xwqMtB/2O2OYne08/YvUhWppCnZLsGSXm+e5iDFrlYh/qB9K66JPDSwwz3HNNG2rEHM5mALhiBwqQL+e0K2/2XtAWO6AaOEOjXouSInaZKi/72Bu8/BASmPdn/itd75swACQwBdPLyXouHe/a13HyfQf9cEq6Qzg4KQvZg4jmoMDcwlC3bK7Ye6GF34nixaSWx+b3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Demotion must not remove free huge pages that back existing reservations.
The sysfs path checks whether any page is available, but passes the entire
request to demote_pool_huge_page(). For example, with two free pages and
one reservation, a request for two pages removes both and leaves the
reservation without a backing page.

Cap the sysfs request by both global availability and the selected node's
free pages. Recheck global availability in demote_pool_huge_page() before
each node batch because that function drops hugetlb_lock while restoring
vmemmap and reservations can change before the next batch.

Testing:
Tested on an x86_64 QEMU guest booted with:

  hugepagesz=1G hugepages=2

Reserve one 1 GiB huge page with an untouched hugetlbfs mapping:

  nr=2 surplus=0 free=2 resv=1

Request demotion of two pages. Before this fix, both free pages are
demoted:

  nr=0 surplus=0 free=0 resv=1

Touching the reserved mapping then fails with SIGBUS. After this fix, the
request is capped at the single available page:

  nr=1 surplus=0 free=1 resv=1

Touching the reserved mapping succeeds. After the process exits, the
counters are:

  nr=1 surplus=0 free=1 resv=0

Fixes: c0f398c3b2cf ("mm/hugetlb_vmemmap: batch HVO work when demoting")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/hugetlb.c       | 22 +++++++++++++++++++++-
 mm/hugetlb_sysfs.c | 10 +++++-----
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 640df58be4e5..ae26d400ad31 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3998,6 +3998,26 @@ long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
 		LIST_HEAD(list);
 		LIST_HEAD(surplus_list);
 		struct folio *folio, *next;
+		unsigned long nr_available, nr_target;
+
+		/*
+		 * Re-check available each node batch: the previous
+		 * batch released hugetlb_lock for vmemmap restore/split,
+		 * and a new reservation could have been added in that
+		 * window, shrinking the budget.  available is global
+		 * (resv is not per-node), so 0 means no node can
+		 * contribute -- stop the whole scan.
+		 */
+		nr_available = available_huge_pages(src);
+		if (!nr_available)
+			break;
+
+		/*
+		 * Cap this batch at the current budget; expressed as a
+		 * cumulative stop point because nr_demoted is running.
+		 */
+		nr_target = nr_demoted + min_t(unsigned long,
+				nr_to_demote - nr_demoted, nr_available);
 
 		list_for_each_entry_safe(folio, next, &src->hugepage_freelists[node], lru) {
 			bool adjust_surplus;
@@ -4012,7 +4032,7 @@ long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
 			if (!adjust_surplus)
 				nr_persistent++;
 
-			if (++nr_demoted == nr_to_demote)
+			if (++nr_demoted == nr_target)
 				break;
 		}
 
diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 79ece91406bf..326a54b4d991 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -211,15 +211,15 @@ static ssize_t demote_store(struct kobject *kobj,
 		 * Check for available pages to demote each time thorough the
 		 * loop as demote_pool_huge_page will drop hugetlb_lock.
 		 */
+		nr_available = h->free_huge_pages - h->resv_huge_pages;
 		if (nid != NUMA_NO_NODE)
-			nr_available = h->free_huge_pages_node[nid];
-		else
-			nr_available = h->free_huge_pages;
-		nr_available -= h->resv_huge_pages;
+			nr_available = min(nr_available,
+					   h->free_huge_pages_node[nid]);
 		if (!nr_available)
 			break;
 
-		rc = demote_pool_huge_page(h, n_mask, nr_demote);
+		rc = demote_pool_huge_page(h, n_mask,
+					   min(nr_demote, nr_available));
 		if (rc < 0) {
 			err = rc;
 			break;
-- 
2.43.0


