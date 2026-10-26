Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6492A60A2616
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bkq44vBo
Received: by kanga.kvack.org (Postfix)
	id DC9846B05B8; Mon, 26 Oct 2026 05:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B236B05B9; Mon, 26 Oct 2026 05:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19D26B05BA; Mon, 26 Oct 2026 05:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 869F66B05B8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:41:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5A4812073F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:13 +0000 (UTC)
X-FDA: 85364284026.23.4542660
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3CDC9100008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:41:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bkq44vBo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ju0wQu+417wa892fYJVYM+soH6OLcnP1RPOW0oc0dDM=;
	b=25H3d6XJDI17ZLEY2iLNeY9YHU5Q4CHqCvCX0QD1NscaSruZ4Jx3T2w7DQLDBYGAe59Pd/
	6iRgX397SmQqGRjf2HmzFWrovjQAy1WJQkShXKF2LV0wdUssekzpBbN1UAOrgEMvHl96Cu
	UOO0VENQDXikxydjIBUgsAFwuho2SpI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bkq44vBo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007672;
	b=3n6gWM4TDyS/9PYd79gLiDz0KZ2K7fwRzImf0HjL+Bn6WaSv/+lLkXez7ZEkw/SK8LLceu
	5WrfIcTPtsHIho5LjoFnf8DMhJ2E1Y10WAj65q+e1tiB+gBRv3aSveRRwV+zk5MYnD/+XP
	xsVXXLV/g8u7W37R3Jr4ezQm9AN/wm8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D1A8160A5E;
	Mon, 26 Oct 2026 09:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4491F031E4;
	Mon, 26 Oct 2026 09:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007671;
	bh=Ju0wQu+417wa892fYJVYM+soH6OLcnP1RPOW0oc0dDM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Bkq44vBorzSIQqNmE5BNdeuoyahOtvJ9i5Y+eF290s5oC8VnzESCnaiifiDGgU9Pv
	 /oihNsBnllA9zdlu0zmW+ZymZeMRlvki2nWcLwiMILvzfhn2dGoICcdpKQMgT/1u7o
	 0RZ5jMTxBTP8Hkqj0bkn3hpNJJw+PrSrKrGCeqnBMDc1AP3xhYcGogJBCKNmYOlMgp
	 Re5+CA4YLl/NlVqmLzZeDVBOaUo0GlojAkKFiUU/H1uW6MMtBWETGbQfPxYjT/t7x3
	 1QjOlu2g6QoIBXRNUzt7Wr83/+1As0Shja16nbj82qEDcwk7ptskwHIjvpzKkQ5qfV
	 WtwS7/rQfdlgQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:36 +0100
Subject: [PATCH 03/16] tmpfs: preserve explicitly disabled quota limits
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261026-fixes_shmem-v1-3-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3884; i=david@kernel.org;
 h=from:subject:message-id; bh=CyHODL1qX+fF6X6EwBAvC5OXSBg9riD9JUneF+nbOeM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK4jdrV6/fb3hxrsPVVz9n6q+lD7MXLzwfk9dBNvuN
 fJFqowdHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEykT5KRYWetUuzuMLa/M9iP
 LYw6H752h5PKTQ0WDv5NKTFfTgs5tzL8U+icE1EXLplc5PfcZdLdbvMnH5maJ5htnXa7y7Zb0+0
 NJwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 3CDC9100008
X-Stat-Signature: 9i66itj6xijux8t861upnhzz5rfxh4yy
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793007672-193348
X-HE-Meta: U2FsdGVkX1+Ot5V4SGgxc6pnuP2UusKFou3QZPXcH7R5qn9j/bkbXu8a1WmVsLbSVjVEiXYhQxuGTrVGq5OwHfuJyYHi03Fnv7hw431c0Ej74BcLeJLPm+8brHHCvVQ3KSmJZRkOpcB6xyO0ulkQo7iGKoZn0a58ngXPpR5MJ9qGCwarotD60HLzhdvbwSut4zMIQXQqOvTVs4DBMUoLfQq70w+TaF07Q3vwpHsQSnfKyA6S0GFBOGFci8sODz5YrPJGUv+C4Cu6F8ns9swZ1B9FUzwGZdAYOYbRG0Ig1CT8WjJjatWFXvH7XC7VXPfrk6qoQZTkhsYpNOYlwTXryPVzaTkv1JQlU5fpKeB/T/k/r0Gvls55WG3yPeC4jqIxSA5Hmz4GhFFP2fyTKtypuprkBDLfHEPu9nNBcZc/Z8M+vyCX38gCnefJLpyD7US5SLWzrBN6Khn+2xx+9I3R678Z6D0vgw8dbtcIW7yUrlQy9zbZKNpkPTi6F/V+PeRJM160JzclpJD+ir2joCAxWZGmM3vpTpsSGTMNcGdCQpVeAMFNdFOTk5oXhi6XSuEpsH27tzELPvTU+u8sjhz8TDAxF+ax6pPU8zTco6X3iysRbK1JMXNMKxwBZZC1W8LCtSH1U2XI19ZIKN+64L8KQrx8nj9vwVMFOO+dgklfLBPWbOcSEUkZwfNA61H3XNzF6spj8JnH/ORsSKOlZ3kPdaDlTpdCyyBnBScnT3rcjx+SDa4ho+j/7AdIMr6tV6cHEScXmmxe08g99AcwnVYP3hr99iL9ELdmIiLGxMmgCGfHg2rTYlydgWuducs9GdKbWFDZOQQ34gG8AOEfJABjxMFMtj7tUSR0y78SLItRxVM6Ia4kunL3VNbONwxi54kbHVx0D1WKpFNdoSwXQDS1qaWB/qL+H8NY48z9H9HaKDsXi1OMAauB3h0Pr9yyCFgN+JlGcNNbtEdk85zS0QP
 W6/aGhku
 UmN7l9l/GrcXLzKP/uoYYSUv8cULsfWQbDwJxNcAGvZg/uK2h4FBIUvosW2vJHfYcCFimB0zJQs+H3fn13KA6AG1LBTF45GGfy+fxxhmB27ZLaRFYQanYhuggPKe0afG8N8d+hlNlWbwmScuToT7R2RMxHKghg/Jxg2HTgNgXxhUNHDlXpbPzNFBbxS+78qG/DGP5vN6LYzizJ29eVG5772trtV+gknWSEC3Sx6yg9dq+PbJ8TUe2rNqeTCXQIaStU/mKcalOJ6DGHnqN57WpTmIQPC6LQTP4ulrenwhvj0ZBflm0Hc0qSWDwdIIKo1m1a+hqV156L9sZ1QAV6lZwCXhSXtKtgdQllt0AjJyvvTuWy6CqLi5B2Gy7HrVPTUHKNYOgAPpvUpg2enlHvDxjWG7r5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

An administrator’s decision to disable a user’s or group’s quota
limits can be silently lost when tmpfs restores the mount defaults
after releasing and reacquiring the quota record. This can cause
later file creation or writes to fail with EDQUOT, even though the
administrator has explicitly disabled quota limits for the user or
group.

do_set_dqblk() sets DQ_FAKE_B when all block and inode limits are zero.
This means quota enforcement is disabled for that user or group.
shmem_is_empty_dquot() treats the flag as a reason to discard the entry
from the mount's quota tree. The next shmem_acquire_dquot() finds no
saved entry and recreates it with the mount's default hard limits.

If the cached dquot is reused, DQ_FAKE_B remains set: Q_GETQUOTA reports
the restored defaults, but enforcement is still disabled. Once that
dquot has been reclaimed, a new dquot enforces the restored defaults.

Remove the DQ_FAKE_B test. Only discard entries with zero usage, zero
soft limits and hard limits equal to the mount defaults. Explicitly
disabled limits are then preserved whenever the mount defaults are
nonzero.

Explicitly disabled limits now retain a quota-tree entry, just like other
limits that differ from the mount defaults.

Rename shmem_is_empty_dquot() to shmem_is_default_dquot() to describe
the check for default values.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: de4c0e7ca8b5 ("shmem: Add default quota limit mount options")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: code cleanups; rewrite description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem_quota.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
index 43d3b4fd6cb1b..d191ebda3f00e 100644
--- a/mm/shmem_quota.c
+++ b/mm/shmem_quota.c
@@ -239,7 +239,7 @@ static int shmem_acquire_dquot(struct dquot *dquot)
 	return ret;
 }
 
-static bool shmem_is_empty_dquot(struct dquot *dquot)
+static bool shmem_is_default_dquot(struct dquot *dquot)
 {
 	struct shmem_sb_info *sbinfo = dquot->dq_sb->s_fs_info;
 	qsize_t bhardlimit;
@@ -253,21 +253,21 @@ static bool shmem_is_empty_dquot(struct dquot *dquot)
 		ihardlimit = sbinfo->qlimits.grpquota_ihardlimit;
 	}
 
-	if (test_bit(DQ_FAKE_B, &dquot->dq_flags) ||
-		(dquot->dq_dqb.dqb_curspace == 0 &&
-		 dquot->dq_dqb.dqb_curinodes == 0 &&
-		 dquot->dq_dqb.dqb_bsoftlimit == 0 &&
-		 dquot->dq_dqb.dqb_isoftlimit == 0 &&
-		 dquot->dq_dqb.dqb_bhardlimit == bhardlimit &&
-		 dquot->dq_dqb.dqb_ihardlimit == ihardlimit))
-		return true;
-
-	return false;
+	/*
+	 * Defaults are zero usage and soft limits, and the mount's hard limits.
+	 * DQ_FAKE_B only means that *all* limits are zero, which need not match
+	 * the mount defaults.
+	 */
+	return dquot->dq_dqb.dqb_curspace == 0 &&
+	       dquot->dq_dqb.dqb_curinodes == 0 &&
+	       dquot->dq_dqb.dqb_bsoftlimit == 0 &&
+	       dquot->dq_dqb.dqb_isoftlimit == 0 &&
+	       dquot->dq_dqb.dqb_bhardlimit == bhardlimit &&
+	       dquot->dq_dqb.dqb_ihardlimit == ihardlimit;
 }
 /*
- * Store limits from dquot in the tree unless it's fake. If it is fake
- * remove the id from the tree since there is no useful information in
- * there.
+ * Remove the ID from the tree if it has no usage and its limits match
+ * the mount defaults. Otherwise, save its limits for the next acquire.
  */
 static int shmem_release_dquot(struct dquot *dquot)
 {
@@ -302,7 +302,7 @@ static int shmem_release_dquot(struct dquot *dquot)
 	return -ENOENT;
 
 found:
-	if (shmem_is_empty_dquot(dquot)) {
+	if (shmem_is_default_dquot(dquot)) {
 		/* Remove entry from the tree */
 		rb_erase(&entry->node, info->dqi_priv);
 		kfree(entry);

-- 
2.43.0


