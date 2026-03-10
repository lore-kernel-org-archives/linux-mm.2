Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48A76EB1049
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 10:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F3996B0088; Tue, 10 Mar 2026 06:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1786B008A; Tue, 10 Mar 2026 06:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582DC6B008C; Tue, 10 Mar 2026 06:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4731B6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:54:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE1991A0583
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:54:33 +0000 (UTC)
X-FDA: 84529844826.05.B597180
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id DD15A18000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:54:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LarhKTNp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773140072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ARuq7ZjC8dzTxJfI/eCppeEwZc/OqS1stLK8KFLZlIU=;
	b=NRPjvG/hA1ro0sAQ/xLnrZGTVRn7RXQTxqcjqK5tQ7h8DjTlDgpj9wYKk+G0V9cmXzdiG/
	fzjVkXr5ggr6MRfpuKq96Ganl1QFc+71QzrSwdcgSPvVD8FO9pTFL7TZxCkaIX1MJ1oGep
	+PcMJmtuTUuySpHL2xTsNTXjM1qHheY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LarhKTNp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773140072; a=rsa-sha256;
	cv=none;
	b=rzsIV3wOrsmtfGYer3MyKAQBiZNhcgoavpVkKsv+sce1TQ9NEsHBbAhd0NPS6/oadxx1WN
	7SlOnuiwFImZZmZE+pbcQ151tKC6YbsS24xYGbA9VEaUI0gLSojUfYKlrgrr4LtqSnjavf
	TWqEAf+4fxL1+JpR50s+KO/AMDUM4NY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773140069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ARuq7ZjC8dzTxJfI/eCppeEwZc/OqS1stLK8KFLZlIU=;
	b=LarhKTNpjI/TYV/q7TK86qYjr8Lnagqv1M10Zgm8AXO1/FpRqmsARvg+QRMhwz5l3nytTf
	22BuOIKQMy+8fuqwHScn+th+0PYhWhpZVo9NK0j52svTZUd8I7KhrUmZVQAihh2NFOJA9z
	RWrM7Q5bk0SiZgOwI+LJJi8/OwwxM+w=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	npache@redhat.com,
	david@kernel.org,
	ziy@nvidia.com,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	hannes@cmpxchg.org,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2] mm: migrate: requeue destination folio on deferred split queue
Date: Tue, 10 Mar 2026 03:54:19 -0700
Message-ID: <20260310105419.3256755-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DD15A18000F
X-Stat-Signature: m9debbwo14d6b3faztooks115ys1s3wt
X-Rspam-User: 
X-HE-Tag: 1773140071-485458
X-HE-Meta: U2FsdGVkX18+ApUa8BBRObbzGd2Liu2pOfS+aNS1INVuXfXPZt1j9QJLOAWr4VqEy5H9E1qETmtdPuOOd4TOCXv4lezzTSPP6IjzfNU1waIMYeP8xlkVSTAvn443uB2UGn+cPPPCaUNYHXzHKtwpgAbMoqHyj/i24UYXPfH3Vf80c0sRMp6h+IQrPvN4CR2k1KVLEl16f/fMJYjkZVDcquTeVQ043kDDYBv9VMLsWCe6ZcoBWQrM0vaD3im3l0jK46gwczX6hciad2KswKL8cKE2qEh86e2RhsGWPOUHtik/I7+3W4qGA3V4wh5IyU7SJq3YmzbKK+UjtSbYchXKqpqrtqOTuklqDNbXHcHYiGqdM/om9dlwUA1c8JeFYLtGCzvsSBHi2Bsb6OIC1pcGa6MKuXF553VkOAwZ9mkL0hJqwbXgISbpvXlZets9JCk/NHvRR5URpUWlz/o3Zh3QrFNhTuU8B0X1UFb1uyFtn4hukQFW32kHJlfzCrb+uhbLgymEpIttqkI3wlkG7Pjw7o/TH/wHyN2ThnpK9X2aENvtv8912uO0xyt9ik53dNTbyw0IdalbBBHAGEM+EhhZKV+dRJl/6ddvwi2OvTJcjbg/s77/JkiJqiMXOg+quZ5J8Yliedj8zC1FvtUln33J6UcrRTThOd4xAxKOmcTwNotTcxmDcShCC4+U9I/p6L7Aw074e9YU8A0d1BjigHabiDXS5x/211inGGeN2Tfc5lCvJ0qYLnRg5ggPuEiRqNi0zlXJfo7p8AEYoXw02CSmEog49pGz+um4MvLZwpg26o4viKICk4flnw0q04GP0QrNSvqPOEXJsQf5w6LsP+4Tb35wvUdkmcdlru5u+TxvVha1cFAOWCs8uhTyVygPQd4+dnAp+qXkX9qDyB0eH6yAjZaQT0FfVj0XUx8TKAqiQfp3dleXkktln3GJw/6Z+YIAgvMFBdYAQO6t7/dUFoP
 /uEwmPWB
 Rm4LwGVwwbT9NS3Wf2YHRFfStRSPTw88xxn7ED5OptUVAoV2U1Bp3T69GMi/muFAH40V1OFrbZ7fF3l17ptPR210DhoIFwOZfmedMQE6Oo5AR87Ww8IH6RpMbZbK7DXAMjSZ3zwzi7hdaWj17b2yfUp7Fr1nxuiQS2nu8D5b5PPFg2A+deSx95sxRSzB7NuoEUJBh4CX1WMUgFEXG/nmQH9r4YDW2fJz2Mi1+SZdmWM2JcioQHuw+Qb4lOGTT0fZwuTWgXa0lIeTZonkxzGGPuaLawlJ3At16OveMgYDnuWbY8+9Ids045rYfRtBFrfv7LxPig3XrQy1EKwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During folio migration, __folio_migrate_mapping() removes the source
folio from the deferred split queue, but the destination folio is never
re-queued.  This causes underutilized THPs to escape the shrinker after
NUMA migration, since they silently drop off the deferred split list.

Fix this by recording whether the source folio was on the deferred split
queue and its partially mapped state before move_to_new_folio() unqueues
it, and re-queuing the destination folio after a successful migration if
it was.

By the time migrate_folio_move() runs, partially mapped folios without a
pin have already been split by migrate_pages_batch().  So only two cases
remain on the deferred list at this point:
  1. Partially mapped folios with a pin (split failed).
  2. Fully mapped but potentially underused folios.
The recorded partially_mapped state is forwarded to deferred_split_folio()
so that the destination folio is correctly re-queued in both cases.

Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Fixes: dafff3f4c850 ("mm: split underused THPs")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
v1 -> v2:
- record whether source folio was on the deferred split queue before
  move_to_folio() (David)
- record partially mapped state and update commit message (Zi)
---
 mm/migrate.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index ece77ccb2ec0..61013d258eb4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1360,6 +1360,8 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	int rc;
 	int old_page_state = 0;
 	struct anon_vma *anon_vma = NULL;
+	bool src_deferred_split = false;
+	bool src_partially_mapped = false;
 	struct list_head *prev;
 
 	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
@@ -1373,6 +1375,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 		goto out_unlock_both;
 	}
 
+	if (folio_test_large(src) && folio_test_large_rmappable(src) &&
+	    !data_race(list_empty(&src->_deferred_list))) {
+		src_deferred_split = true;
+		src_partially_mapped = folio_test_partially_mapped(src);
+	}
+
 	rc = move_to_new_folio(dst, src, mode);
 	if (rc)
 		goto out;
@@ -1393,6 +1401,15 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	if (old_page_state & PAGE_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
+	/*
+	 * Requeue the destination folio on the deferred split queue if
+	 * the source was on the queue.  The source is unqueued in
+	 * __folio_migrate_mapping(), so we recorded the state from
+	 * before move_to_new_folio().
+	 */
+	if (src_deferred_split)
+		deferred_split_folio(dst, src_partially_mapped);
+
 out_unlock_both:
 	folio_unlock(dst);
 	folio_set_owner_migrate_reason(dst, reason);
-- 
2.47.3


