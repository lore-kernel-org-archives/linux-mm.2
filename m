Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B35AC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 14:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E63066B008A; Tue, 28 Jul 2026 10:04:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3AC86B008C; Tue, 28 Jul 2026 10:04:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78356B0093; Tue, 28 Jul 2026 10:04:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9204B6B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:04:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC6DD12026A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:04:10 +0000 (UTC)
X-FDA: 85038354660.26.37F50B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 438C018001E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:04:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V7vCzb67;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785247449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=66CFSKBjIR3I/xFltSKtBPbEufWyPg50Fofda3KYJxg=;
	b=c03ZDKXaZMuQTaRFMB8U5pPwCDYDWrTkorTerGPxarcAn7QXwf3XXBmQFHlCBKxzkqT7rZ
	kFQRV2A8tYZnyqCR67bh2/0p7NPW+tOgf1dxczlS3PZGuiJORH+1/EdxngWffj9JzSwZwd
	OgIQnOMuNQa2t3nmJ5Nj4h9UDcAoAjk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V7vCzb67;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785247449;
	b=1I7VpbJszIz7dO9okK86hA2l/udCCXS5fVnNDMPGh8lQ+dZFcGhKHbyO+xPr9PE2Cli+Uz
	Yb/qd/tneiA21E3zMjU+R9kKijtWQf1TgDNmMxX30CR9kY2KZKF8LvJieO7G1TQPwIQT1z
	JF/1eeYP0c0CA+Lk4xwp7Y6B2Yqmco8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3A7B600FC;
	Tue, 28 Jul 2026 14:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BA11F000E9;
	Tue, 28 Jul 2026 14:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785247448;
	bh=66CFSKBjIR3I/xFltSKtBPbEufWyPg50Fofda3KYJxg=;
	h=From:To:Cc:Subject:Date;
	b=V7vCzb67PwUnlf9KUIkZeTYUAwkwY6498zx1mIJeUZmSHIw6UcXOd33Oexb7eo7dT
	 mqX4DDA4GYRv3S0YBhdx8qyMJtyCzaS8UPspkdtdA4cPa0KAEtSzl3EQAYK6UXzIcN
	 sL6JQie3qQLPX+y8OcOp8b1pV2+BBuNA0teXZXaJPdrwIu5ydhbCtZ19pjgTTgnjnU
	 yV2u4yrxwe6EJ6RCtdo0NzHQBvtRmkgi+Tgrjt4awqF6ri0obg6LsJfrYDdywaG//R
	 DrlgqNcSAA1B7KvbQeHL/mlbsF8FV5R0NRZO97aZVAhwjV98N6R/OarbDDcucQKwbr
	 ++NoZXLGpdiAA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Honggyu Kim <honggyu.kim@sk.com>,
	Hyeongtak Ji <hyeongtak.ji@sk.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon: adjust isolated pages stat for DAMOS_MIGRATE_{HOT,COLD}
Date: Tue, 28 Jul 2026 07:04:03 -0700
Message-ID: <20260728140404.94476-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 438C018001E
X-Stat-Signature: jga1onu7gwdkm49k8bktdcb3b3nfycaa
X-HE-Tag: 1785247449-801382
X-HE-Meta: U2FsdGVkX1+/0Dwsgby+JnGwc7+C88JnwZYu2r8CsOOYnokkF6Wr8BByhzPGjRMLoo6HUdEj+pm7Wo7yLs1zvufWAP5BYPqe1yUA7h6jMzYsWWw4dUuzaLAgGh7RXcXpEsD765GwxoltqNtpp5qaicVDOiehYvxpuwPjnp5pP6XXoIvVZiOlO2jOhaAgU80k6bwWFKWJi0T71dD2d2Yj0it6SEBOAUu6nO1U4OAVqGgClBOTMUpomr6EMxSv1R+pc8jgBcIXNKM676XI7gM+lqmInr958lUGdJBJjUD89mpmWH23liLaZxYY16AZMPYqnOfNbh+UpXQu1lU8zsyCyydHPXDLhOeqys7y9AkjKwKWob6ew0Zni+uGg3gm9CBM9uxNVDIwwAB0rN+7QDcyYSO35PW7YNLktgriu5J330476huRK4CnhNbAOtuuEK3r8qBfjmNVp5XpZVlEjAcCi9/4/ATSP/Px6I+wfldCOg5USwpHnmpBdOcOmbBJHXTYEoMQKs4ImAfRn5dpy+f7egRYSRP3GrUd7ADjwzcu3S9u5XT+BRLMK2un0X3imjzOvPxLq6x/ZLVLsVE14u1J2xLYBzsn7cso3HEOhYHilI5rUaMRtCKHmzkU2GrwhV2wvcTjLs6mCjMbzCNBf2YP9R+bknYiOWRCLLmbkLkHz9RcPpoZKCRZWWiKvnPzho2oZvnodZpJeIaJVXgWCMuhi+Tu1NYfiIQCdBLUv/kdZfbpnjzNUL9+Vj1pglq+A2TDQzbQA4trYBd5h+H4U/LOk8wPyY1/DsPuORb2tWOF2XeVOcZEhIPDJEJHqtPX6yWpbbp4edbEcEqub/hohx/qv6y2UnHsi62jWQt7zmBb2fJkooflKsmAS4zVgMkqBU3zZ3d/x2GvZIzEwra7fpU7Sq8Ltr9z120QcyCc7b8193RhByGP537elTwortnalNTiGIPEZJf30RzcHkz8ce2
 nVup+hkd
 uu6fcmhIiXlwjK4ga7IZ6lZl5phtit4s+1feop/0HvLKqVj6tVoF5RdAw9Tm2NaAPC064RkLccVKp8tElfvl1YUnsEutIFKHADYHQATolspDNl2omy2yat81UAXmW01TW8viEIV6Gtqg7vj3enq2ejb6PCfTPD5doTePssQf3iPH2zLvHBkZMjGmp0nItGsLtI3SL1ccZM6usdQcwgcTcH/rr0xHNOSDmpaO6F0nwqpHGzDKtbniPMYjQdGtJtZnbIC0UGTPR1pde9nAUlRV8E27o6uZxQ55+ZD/vLvLKd64u30A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Callers of migrate_pages() should adjust NR_MIGRATED_{ANON,FILE} for
isolations and putback of the folios.  That for migration succeeded
folios is done by migrate_pages(), in migrate_folio_done().  That for
MR_DEMOTION reason is an exception though.

DAMOS_MIGRATE_{HOT,COLD} call migrate_pages() but mistakenly not doing
the stat adjustment.  As a result, use of DAMOS_MIGRATE_{HOT,COLD} could
corrupt the stat.  It could confuse too_many_isolated(), make compaction
and reclaim to behave in unexpected ways.  The stat corruption can be
reproduced and confirmed using DAMON user-space tool [1] on NUMA
systems, like below.

    $ numactl --hardware
    available: 2 nodes (0-1)
    [...]
    $ sudo ./damo start --damos_action migrate_hot 1
    $ sudo cat /proc/sys/vm/stat_refresh
    $ sudo dmesg
    [...]
    [   80.215554] vmstat_refresh: nr_isolated_anon -5578
    [   80.216842] vmstat_refresh: nr_isolated_file -34400

This issue was discovered [2] by Sashiko.

[1] https://github.com/damonitor/damo
[2] https://lore.kernel.org/20260726164356.87940-1-sj@kernel.org

Fixes: b51820ebea65 ("mm/damon/paddr: introduce DAMOS_MIGRATE_COLD action for demotion")
Cc: <stable@vger.kernel.org> # 6.11.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC:
- RFC: https://lore.kernel.org/20260726205548.2287-1-sj@kernel.org
- Rebase to the latest mm-new.
- Drop RFC tag.

 mm/damon/ops-common.c | 4 ++++
 mm/damon/paddr.c      | 2 ++
 mm/damon/vaddr.c      | 3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 0981a5e3af172..fbda70d8ea4d0 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -374,6 +374,8 @@ static unsigned int damon_migrate_folio_list(struct list_head *folio_list,
 	while (!list_empty(folio_list)) {
 		folio = lru_to_folio(folio_list);
 		list_del(&folio->lru);
+		node_stat_sub_folio(folio, NR_ISOLATED_ANON +
+				folio_is_file_lru(folio));
 		folio_putback_lru(folio);
 	}
 
@@ -396,6 +398,8 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
 			struct folio *folio = lru_to_folio(folio_list);
 
 			list_del(&folio->lru);
+			node_stat_sub_folio(folio, NR_ISOLATED_ANON +
+					folio_is_file_lru(folio));
 			folio_putback_lru(folio);
 		}
 		return nr_migrated;
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5a6a78054784a..5c6c3a597fd0b 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -346,6 +346,8 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
+		node_stat_add_folio(folio, NR_ISOLATED_ANON +
+				folio_is_file_lru(folio));
 		list_add(&folio->lru, &folio_list);
 put_folio:
 		addr += folio_size(folio);
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 4976775fe2762..0648400b2d65b 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -627,7 +627,8 @@ static void damos_va_migrate_dests_add(struct folio *folio,
 isolate:
 	if (!folio_isolate_lru(folio))
 		return;
-
+	node_stat_add_folio(folio, NR_ISOLATED_ANON +
+			folio_is_file_lru(folio));
 	list_add(&folio->lru, &migration_lists[i]);
 }
 

base-commit: 53f9deb696041883ca3d03b33b565e4cd3ba54dd
-- 
2.47.3

