Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C047F0182F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 13:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904B36B008A; Fri,  6 Mar 2026 08:36:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BBA96B008C; Fri,  6 Mar 2026 08:36:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4D46B0092; Fri,  6 Mar 2026 08:36:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC496B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:36:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A0AF1C78A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:36:07 +0000 (UTC)
X-FDA: 84515736774.29.40B0012
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 40F90140009
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:36:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UAl4alQM;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772804165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IjfwJVkjFCkurXfXgkdOOF1hpoMOxoLVQDtfObgZD/0=;
	b=IRfOt724CtDw0x3afgOhCLZNPlZpGpgf/HQMAPUPUduuLb1bKVOTyuMD3ED5uYwk0LFELd
	wHLKdBZyCjCL3K9OTSxoJWVjCSHesLNxZn4L+HLupJVbuiuelS+KkuLK6FBqAajWPIQEkz
	aodPiD/a7MLv8tdi8K4RnJrt+WHS2/w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UAl4alQM;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772804165; a=rsa-sha256;
	cv=none;
	b=IUd68tjdQlCypohqt7Mip1D50rKCPYRF2C7GLOf8aLZzyHFTn0upkG+2+FVe2D0STI50Lh
	HQ9F6cD9qjMrrQtgX6UB0gAqad+wabFhABcwTT2AMWME10hN4D2m9j0EZFZxshy78rkBNc
	RfNxaqF8a+nqeQBI1drRIFD3sHgoe44=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772804162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IjfwJVkjFCkurXfXgkdOOF1hpoMOxoLVQDtfObgZD/0=;
	b=UAl4alQMAOg0EZQY/V24xC6fW1H9N94cbihAUUK5qjEw0JXQy8U5Vg6rTtPyL3ZYXx3o9a
	8RIRQ1Y3KECz+R3V+SoxG2rCSZ4i9LDkC+YqUYUl4nbjOe47xBUsHTZCghLoEailLYQPbZ
	tbE85dNIhzmg4dNGEB/Cq+lzgPTI8P0=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	npache@redhat.com,
	david@kernel.org,
	ziy@nvidia.com,
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
Subject: [PATCH] mm: migrate: requeue destination folio on deferred split queue
Date: Fri,  6 Mar 2026 05:35:56 -0800
Message-ID: <20260306133556.2051251-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 40F90140009
X-Stat-Signature: qmiz9xgwq6d9ao84hguskj9kfpuf7e3i
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772804165-590140
X-HE-Meta: U2FsdGVkX19juGWtokZMz77KlPlK5ZGZibJ3JmWc/JoKHj7TRqai2bhsTgSsX708UjoHOqRjfK4GT4lWLEt+E8cE5GPLuNIJi4FdmPCrVtBD/o6LnHe/2sLkSvU6gUznKruOmg7+A7V5Ddkv/aOYqjGS/MiOoyzc1dwTrZXUoZA7UVvQRr9aG+Zc94x7mCo/5Ad19dlQDQCOwOkWYbK2Tetznnrf6ZgHIfQ+cA3SsQxdxEn4kjIWytOcbXpuvbbnQsbDhxUHutWUGFBieywdZnfpA+BSrum87wXoaArWgUc9xfSEKu2Fm07k4x8y1U1wx0uhl3IXAUixpa5iX2soD8SOc17Wkc8Ssu7ZBBhNd9Hdv1uDlDhji6Srmp/mLkyol9PN9ZqfTTX2qWu7m3vTeYmEdh8sMcsGISkXx26sgar7QWHvmwmhZvbzi4mHHG3WkkgF4HZ9HRdpDL6c4KGMbXAFAPkcp4fheoViEShdLJjTRaWCpK67ViXoN9Z7IO1y4LiZOMHgfxdraZ3JYP+ABj2EO6TbXCKuEm7NGeb6hRjKExrIJU4XgkDuMuSQNQ2Cu89F7Voh1c4t5aZ9JB8devbdHBHZbswcjzLBeth70uET2MHgJdZ3geP3CyDVPxzEp8Kv+0En+HWCnghm0mf+z1wNoAAPWk+HPZvZHQ87kmx/VrIEbhQNSZyAbApaPrkikQhWXrOl8DZCzPqy/v8rZeUWzF5avCCxVVy3oSVZH92QkBUdSZkRg3YxHbtWc0z3JtcN1ydiM/i6vlPXSAGkTTvpfSjq3CvDy+VEhJPRYahmJPZ3diTwmYB0x+Uq1w3R5YOdl6CFJ0InkM4V8wj8R1WSF7q6lnGz/2nivKGYEvNwlbQIR6zj/NOdReU6Omnze/BD0sgHzUqvEf70saRfr+rqhfJQ4o8JzuaxdANeh0nYCU3i/iO44VXq1x2UOgX0p9aujhx8tZucdiYxaL4
 t5d5/k/b
 l1zoLtuxvrL8rA9wnmJarNePGmVJ3GnXV3nRBWy6ool/1KOFpU4cbugTBjv/oir94erBaDpKNykDGmVRLJHAZe64/P5BFG2/gFKg8Y1tr5c9QETSpJ4wLdoexQXfiJGOI0Z8RT7JZG2wEcJu//jtQo1FUTYpooXg/YQEje+RvEuqTGe5IYC+NYIEuL5tByGB99cDmt0DaJhyuKZgwrRjvloELbblUBuOlPWzs7u8LE90nXBUTCs1F8kSAlk92fgVTViLC4+gjKwJ41kc3XaowatLUrXoY+wwe9iCu/VAKCWgU7wzR4T5E4Z12MES3zr+yrOOWPCgoQuC6M8A=
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

Fix this by calling deferred_split_folio() on the destination folio
after a successful migration, for large rmappable folios.

Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Fixes: dafff3f4c850 ("mm: split underused THPs")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/migrate.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index ece77ccb2ec0..98d0a594f7b7 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1393,6 +1393,17 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	if (old_page_state & PAGE_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
+	/*
+	 * Requeue the destination folio on the deferred split queue if
+	 * the source was a large folio that was on the queue. Without
+	 * this, NUMA migration causes underutilized THPs to escape
+	 * the shrinker since the source is unqueued in
+	 * __folio_migrate_mapping() and the destination is never
+	 * re-queued.
+	 */
+	if (folio_test_large(dst) && folio_test_large_rmappable(dst))
+		deferred_split_folio(dst, false);
+
 out_unlock_both:
 	folio_unlock(dst);
 	folio_set_owner_migrate_reason(dst, reason);
-- 
2.47.3


