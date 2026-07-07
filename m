Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B955C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FA96B009D; Tue,  7 Jul 2026 07:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0E26B009E; Tue,  7 Jul 2026 07:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2DED6B009F; Tue,  7 Jul 2026 07:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCC496B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:27:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 63F7A1A0403
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:27:19 +0000 (UTC)
X-FDA: 84961754598.26.B7D7C72
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3230B20004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:27:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MCO77LEv;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf31.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783423637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=h/eXOacRdygoTlNNYt5Ne3MwbXvwRuPWbyCjVwOiNWI=;
	b=KTJs5y46+Y+thWQ4OoYW4QC2fzaqDMTcIl2A1wanTSAPBhq1XCWrVmBOgKyD6vVLCbtfyM
	ceg8GOGCwAMuzIUEiwa0WpFeKuKy19YhbRMB4A6ADdZac6kB/1CmsNXRHlqYiXY4LDauHs
	unZVeVpNuLHlGI0XeUX2eF2LSy7k+t0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MCO77LEv;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf31.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783423637;
	b=XjGJV8Z2xfsdLAjUdG3AOUkf0GzzmW5pZ0Rab7Fw85INYi3/gN5hPZy78yB79FzzfDn7Ii
	9Rzu2uxCytSQIKc16sFm3eqplPFuL864I4K4XwUCTRzeRI4+lJJw11SiOHfC/v8k7Q8EjR
	wkoC1Q9qOhqvyF7gvy55BALHms/PbIA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=h/eXOacRdygoTlNNYt5Ne3MwbXvwRuPWbyCjVwOiNWI=;
	b=MCO77LEvkwdC2ebCBq+MONBVJu+d16Nsz2fIyfzvdDI24k0M7hqHM/hL+ecqDPaf3P6rjTTlC
	8Q5w5mAYx2UjB0/DOQCwwBgzx4xaO8XAt3xAL7xHWoxRYrSlBqELFwM3SfAgyCJdFicmDiLAPna
	ACBNOUnNkk9QUoIAEEcqKno=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gvdxg32zmz1K97T;
	Tue,  7 Jul 2026 19:17:59 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id A3C824055B;
	Tue,  7 Jul 2026 19:27:11 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemj100016.china.huawei.com
 (7.202.194.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 7 Jul
 2026 19:27:11 +0800
From: Wupeng Ma <mawupeng1@huawei.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
	<akpm@linux-foundation.org>, <baolin.wang@linux.alibaba.com>
CC: <mawupeng1@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/hugetlb: fix missing migratable flag on same-node hugetlb migration
Date: Tue, 7 Jul 2026 19:02:54 +0800
Message-ID: <20260707110254.3147686-1-mawupeng1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3230B20004
X-Stat-Signature: 1hc1itz94fz9q4mn7myns5sgkbkprzsu
X-HE-Tag: 1783423635-420022
X-HE-Meta: U2FsdGVkX19IKoi0kqDtNiS1NFZl8MVKGOoS40YnGj/nHp79sdIVZDjvComZKiHwkqTvzpH6WA6DIYuiE9nW8rDeNa/ZslO79Xx7FkMfeuN4xnnQ35YZHJdTGSwoidkYLpaHi+2fkp8n3gu/vo4EMpT9g3xgUQbEGDa1eE9NL3fggLzWgEe9lc9AHpjQMILY1N4uBnsY+cHV6vVlnimtp0pjMV9nr8ynxw38dBtfU6lw1qUihrI+7mNqYjpvw+oFe4ynKqnJbPP23l6KLkavbJQHuOvwHUcl8rW9X1PcSGhejfuxamq9BVENQw+7rZH4T31MN8Rv4+S8c/kCgv3PM5PSTbiBhtPg189KgMe3ujRtiFhq3EDrlfyUgO1sdIOYpn3+dY0qFH4isRsOcqhcU6dgG8FL7CyOLrOgcUuwk91xyw0Z1vP2U9yk1TBh89l3DLmTQvdUM7OYNkgER6Swdjv287t7IYA5p3WOq7FB8SIkK5rqvI71DIQyqSWdYieG4+/QndB4XjZDNHcuyaqXmpH8tpkMtg6F0FhPrWpFZnrEzuvTU+c3QKTTcMJowrCe6vAtnCfXkCtG+dmZDMNnXo8kGAE8n13/QI+kAI6D1PJG9D+wO+Hzi0LM88/o3kCyJdU1+fadzMf/adIhxExLIux0E37qV60h9XSvIWmEffVeh5madrCcyK9R+ExHeXnx4+azpgq/5WMYYLoDkUliemEd9QXMaKSYp5RQCgpjKtYCqFfGaGF55ZpRQKgwa51wOiWyfy5qgjtIQ5BeFoWw4x+nYY9xx1auPmc6or2lVsEm8Mb3uTX34xTP93Jltavlk8bfgSc6H+RFUkHaikSfFMmRu37An+qr8JXQbedPom721bXdzXR78k2MOyMU+yKGnzYhXSjM1LE0M4VmKNZXUpyRWpvVRc2GDloW8s5UNAtrfxOAMwE2gXEJQrc9s7B7OaZbnBdE9zXHvrW4ddn
 kck4qpy2
 zA96Z44BC13xvgp93zkYz5z+3pNmQ0y9qCO7B31xkXnDpRx/mLKZvSmSK/q5pTOfuDhLhd4uHWSL3TI56wS7ciRUMI+yJ9RDpHTffgutvCsE1SQCKDWYnK9mk61uvmiGbZEO9IrtEVJXUXG/zBnatyqMm2BXnYsdwWk7VprxKX/kCnMX+Z3Rxa76BpJGY6LxYwzaXMUm+uXLzl1a3WH07wpsBms7Hnr9sBnB18QdvlGl//GIpZmDocyyI2+20ZG+Yqj+OJKX65c+O8+qQBUQhKhe+QmEsxIsDHi/6CzxeMcpLcHk3Y1ZeG99xcutlNds1SpoZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit ba23f58de896 ("mm/migrate: don't call
folio_putback_active_hugetlb() on dst hugetlb folio") moved setting of
the migratable flag and active-list placement from
folio_putback_active_hugetlb(dst) into move_hugetlb_state(), so that
the freshly allocated destination folio is handled where allocation is
known to have succeeded.

Unfortunately, the new code was appended after the existing
temporary-folio block in move_hugetlb_state(), which contains an early
return added earlier by commit 5af1ab1d24e08 ("mm/hugetlb: optimize
the surplus state transfer code in move_hugetlb_state()"):

  if (folio_test_hugetlb_temporary(new_folio)) {
      ...
      if (new_nid == old_nid)
          return;                       <-- skips the new code
      ...
  }

  /* added by ba23f58 */
  folio_set_hugetlb_migratable(new_folio);
  list_move_tail(&new_folio->lru, ...&h->hugepage_activelist);

When the destination folio is temporary (i.e. the hugetlb pool was
exhausted and the migration callback fell back to
alloc_migrate_hugetlb_folio()) and the migration does not cross a
node -- the common case, and always true on a single-NUMA system --
move_hugetlb_state() returns before setting the migratable flag or
adding the new folio to the active list. The destination folio is
then installed in the page table but cannot be isolated afterwards,
since folio_isolate_hugetlb() rejects folios without the migratable
flag; a subsequent soft-offline, hard-offline or memory-hotplug
offline of that folio fails with -EBUSY.

This was reproduced on a single-NUMA arm64 VM: a second
MADV_SOFT_OFFLINE on an already-migrated hugetlb page returned EBUSY
and logged "hugepage isolation failed".

Keep the surplus adjustment, which is the only part that depends on
the node crossing, guarded by `if (new_nid != old_nid)', while making
the migratable flag and active-list placement unconditional. This
preserves the cleanup intent of ba23f58 and closes the early-return
hole.

Fixes: ba23f58de896 ("mm/migrate: don't call folio_putback_active_hugetlb() on dst hugetlb folio")
Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
---
 mm/hugetlb.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..cafadfdb63c0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7211,14 +7211,14 @@ void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int re
 		 * There is no need to transfer the per-node surplus state
 		 * when we do not cross the node.
 		 */
-		if (new_nid == old_nid)
-			return;
-		spin_lock_irq(&hugetlb_lock);
-		if (h->surplus_huge_pages_node[old_nid]) {
-			h->surplus_huge_pages_node[old_nid]--;
-			h->surplus_huge_pages_node[new_nid]++;
+		if (new_nid != old_nid) {
+			spin_lock_irq(&hugetlb_lock);
+			if (h->surplus_huge_pages_node[old_nid]) {
+				h->surplus_huge_pages_node[old_nid]--;
+				h->surplus_huge_pages_node[new_nid]++;
+			}
+			spin_unlock_irq(&hugetlb_lock);
 		}
-		spin_unlock_irq(&hugetlb_lock);
 	}
 
 	/*
-- 
2.43.0


