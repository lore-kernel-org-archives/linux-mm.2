Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC42BFED2FE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 10:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878876B0088; Thu, 12 Mar 2026 06:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826526B0089; Thu, 12 Mar 2026 06:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732696B008A; Thu, 12 Mar 2026 06:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 633306B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 06:47:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CAE4A878C7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:47:35 +0000 (UTC)
X-FDA: 84537084870.26.8C945B3
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id 58F734000F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:47:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TgDbANuu;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773312454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Z9DQbHHW1dPvMB4o11ZEk2vL5DcdEhVBsPWn+VR0fEU=;
	b=7mjpfmHYhmupMTb/GxH0ZWCRI1uEqpWPM9vRPF7ts4iAOPT2Jbj+C8ZETxo2M8IKbesMOk
	BPkxtypP6SwEae8ODpJtO6MghrrcF5yJgY2D/qNN5+9dfvef8j+GfwXyoSl0XvpMAW3dsX
	pgyCbO+05Q2shnPNtyVoVtPH81neiyI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TgDbANuu;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773312454; a=rsa-sha256;
	cv=none;
	b=BvOUP0njSM3ll9BeMa9V+nv6i/E3ZPrXBFucrNTCTx0TGvIg15QLehi23Va4mLPzk7vEDZ
	3DDwOv7tFXem+tN1sXw7sbK4IJ2JgMauSXSbHqnMviw9gifx4JpoNqhiBCRa28FlsqTJ2J
	FMoOrh1E4oQIJFK7tfn7E7E7EUz3A1E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773312449;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Z9DQbHHW1dPvMB4o11ZEk2vL5DcdEhVBsPWn+VR0fEU=;
	b=TgDbANuuswluEbHqZpcvyx5hu6y6a/gg3AQfgRWhBzMuiwPpQfEqXOJIhcFZS2sY/Xmc2w
	+HAKNKPj08rzL+Hpd2Sv4psJeoA6TTZF6jUesIiLpOy+BcrDcNhA5JPpdn3J4o7IwxQHKd
	r+o53IZDQvRpzSBLvJ08ctbMCkj3eSs=
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
	richard.weiyang@gmail.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3] mm: migrate: requeue destination folio on deferred split queue
Date: Thu, 12 Mar 2026 03:47:23 -0700
Message-ID: <20260312104723.1351321-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 58F734000F
X-Rspamd-Server: rspam07
X-Stat-Signature: igz4i5wgsbe53q5jb8yr5j5dytja6no6
X-Rspam-User: 
X-HE-Tag: 1773312452-561191
X-HE-Meta: U2FsdGVkX1/DgiwJWJ2hFT9NNSNoRl6LPqcBUKz+NBKO4lrZIpISkON1ZcmyYOFLGLDBe+s8JDyBmRS/9EzSWytMNYXQYlHe9hOPhiJ0wT9crQx3/DVnKzuTPGnuDKrPn5vrPXG2SUQ1ftO8k53AiiTKrLrPwPMsCmj32KTDSP0KP1U96tVTGA9RsZOiCyF5iA3DldVJKZWVBT5ldO6J4/DZWo3GMDFBD0ddnr7jIef9w92tL/kUYnpUofCn979ldAmN+3ifHiY6bPZhf9w+XRGbG9+DKzSFYrP9HtEdDpQ0ltkSX9Fx6fgbzL9xOU84gtCySuAemqRQ9fM40MNxPvtEajd5xTipoPL9RUeVw41z/9bvcmOzLOoowNB/Az5TVWHw1eUwXXSzmw7Uq7qMddAY7zAnQ/Wk7rdpmAK8Eg0XXhs3NX9WQh5P4kKy2dup4l5F4Dm+a73k7NVRlEJS3KCfqBBxGFtzENQN+g2LdyirXRvVTZywxvfg+kPQREmC/ZtaU4hDLPKQmZVJMyWz5oo6vJ3/wFVR7eRJIPqWLR1OL7yTw7x1s9HOrZ9zKCORy3L+dIcYniryQYHIjJon/Yq7haxBi6mMnF5MK5hAvXZk66EfIEhf2QgBMuYbc4VO4/boaKDVsh1D1DtIUhD2jYeWGOOJHaUFscTFM+jrIto/GafBwH6lPbHgSI5L46Ligwcg9GeueciO0Ce4aXApeAHCcLvPC54Mx3PrDXgrjUXjLDehAoTPJaHyVgdszCVj0sZqQjIADWQ+1lccAEDRMLakTs8kfRT/lwCTJuiHKM0vICERjZXRfhM2GZxHPnnaXYrJy7bB1dtEsnQ+EI5TZ5Nlvo4rAWqfnGPIwpWnYK4FrVisqk8be/Aws7ghiz1PGP/mBqH6hf1jehhKd0DRQJKEks9FNyFfscGcJ1PlK2mZbosZOWWCFLU/LImtITVL4iySBAMdPlnNT8kOl6C
 fWhf4rBC
 WJbuNV+rMyLqvZAQd6mx3X92e+bPG7tRWy8fJ9uuM7xOUmVMA/cvHfzvau17htPWecLFwVsMUTsQCvCZbo0qmYZYC+rFI2Q0rEwV9FclI/9NdDz9/ixdEhBOdIL13Q4G87RMKDnkgNbd2q5BL8ycChYEtL5THlTAkN6vhqNlNMwIh0r343DcEZiJzZyYGTxQFYFcDX4ZS+PQebvHnwDMMtpfURFay8+JG/bmLZT8OHG4T/h+QSgr/JBdw3EVy02+AmLooaywwoynTLV3wil+Hu6Sv2IEYX/mKDEmgX1kI6AcUxpAmOjEYLGSOkyUySTF1jj470s9cELHSgYtq96IUQxeIjLFuGWvtwNjCqelJP650+820PE9indHvpg==
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
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
v2 -> v3:
- Remove redundant folio_test_large_rmappable() check (David).
- Check order > 1 (replaced folio_test_large()) (Wei Yang)
---
 mm/migrate.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index ece77ccb2ec0..f5169a9f8f24 100644
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
 
+	if (folio_order(src) > 1 &&
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
2.52.0


