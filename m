Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4FDE606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B+eJfwLw
Received: by kanga.kvack.org (Postfix)
	id 030696B05C2; Wed, 28 Oct 2026 05:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008CA6B05C3; Wed, 28 Oct 2026 05:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87DE6B05C4; Wed, 28 Oct 2026 05:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAF136B05C2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:55:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 54853140BA0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:55:49 +0000 (UTC)
X-FDA: 85371578418.14.32A4E97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 84BFC180006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:55:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B+eJfwLw;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181347;
	b=0Tj2GfD45jbHwOp185BXLtd9Hf2FtP2bvRrahJtBxJYeFXMLTQk6+g3xHguZyO0VbGaZWu
	3/mrice49vklQKhQOIjLvhszz6hwamcOANy8w3ITm5P1fARx8R1qKbIJ8NRGFH0F6Sp4Vs
	SVjYoJh2vBJpJXpRpDMhDw0WwqladZY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B+eJfwLw;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9eiRA9OkFCUVhYH0CVOKfXufpFXWjFThguNF2Kcag8=;
	b=BQFX8e+AdLaGhmMGQUzJHbnLSxs3yruwVuB6kERD6W5hRw+0+4i9LP83FLLo24XHfgf/Fx
	bDtEqI775ZhrJk4mlHOt0LxMWqPrZzdyUlyfg1jmHvJtTBv7KIf25fb4IvMUv8Iqdd4n0u
	ouRvrRZwhdCc3vDlyodxFWXQmuDgGXI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D6EC8400CD;
	Wed, 28 Oct 2026 09:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A7E1F01825;
	Wed, 28 Oct 2026 09:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181346;
	bh=Z9eiRA9OkFCUVhYH0CVOKfXufpFXWjFThguNF2Kcag8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B+eJfwLwaQEpxEQ8wPvorA6PpFP35jEEtTjJnBLn3AtCU8/JxR685LCoWhKO1KJnq
	 eQl+L8nCKaLEzhvX2YOmY2n3Dxa8FyH7xr/pzfmdHTLn2qpd4B+ZUJILsEggKmRG2O
	 94tw04XthaJBZKwuh9pM7Dh58s6XxO0wIquUPemUGZNYw6CUcXLG4WYpwZLm685k91
	 dmkfR1KujkIuhZeJ9m8j4zNAd5xJgZZwbmZvm7CyeX5oTerHInRcNBWYBUjmAYzIHW
	 BMt6B+t3H1eWnsqUPVVK4gQnKqfO+SWd2/aza/wZrS2Y//w5KxUetKDkUJzjU+5fUl
	 WxWqB6M8ECVlw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:55:01 +0100
Subject: [PATCH v3 03/15] tmpfs: preserve explicitly disabled quota limits
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261028-fixes_shmem-v3-3-4ce3baf2db4b@kernel.org>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
In-Reply-To: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3973; i=david@kernel.org;
 h=from:subject:message-id; bh=mHULKBAMs4xjW0VzLP2nnjZNPWIPFmkQhWvVe2XbF4s=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHmtkiX5k8Hb9o6kqH9IyoxkE2EO3y8R7fJvwL2jpl
 C1nw2be6ShlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAi7BkMv5i52Kr2v3XuCJk3
 rz308olH3LLvFrrbX3salcmtdffBnZMMf4Ws+/iuFf18G/VOqmd6T+mlv1FVB/7XKEp8WlSmd/L
 TWg4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: un3nfuzct1p3f5qmomn1qabyzi7uew4o
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 84BFC180006
X-Rspam-User: 
X-HE-Tag: 1793181347-58681
X-HE-Meta: U2FsdGVkX1+wTf4T7HQK51yFoqH04w8vFysrBD5iuzvKac8YpnEcHFSQVmOUw1oHIqYLGsE5tZXSS5WjUX/vGKVvL9uncDMVB3LyjZ37qsd2b7XzSdgPyyiHBU1f/EqNxCB+FUyHM7wsMo4SR4fkCMHS+EqVaGC4sHC7JI8664lNWrFtGD0xaA1M5YnSu+fUAAr9BgY+QfN1kZGw6bLDIYKyfw2HmTuCwgeuNB8EXRd9mSe3IDf/ly5EjZAsXw+nFNrlYBFUWRLsdJBdEPH9hjhShK2RTzg7VxACK9inUxKw56fz5lyPKAXVi7RWw/+AiFU4sEsQeMUBR5n4gObj40osXFzWF/cscOxOvv+9DXAq+u4/L3xHXcEYLBN1tQXfOPz8/JowaBsWqTn3o5+g3yvI8X7VDCfHHO0WKHiMHfM6zy0GdRkuPmnd00M+IPyci4h9sKjThcF3bqmQ580r9HTGDYaDWZkuRwA/iC1gO4+EVPcuIAg9e6Npzwi1YAto6VtZ+4eGdjzI6T5qM1cNKX+7eutQDaH3XqbDuhwu08XaJTXQkZI84lfU/x75ViLT8kL3fEY+Z0Gr/mZTrkXGSYVSV4rzBOefNwRCDg3VNl6i9II1qC8eHp5Mnu9z3TaxCkcX2vnEhg4xQpkSlXCqGyI/TJz309xP0pCyk8KEC5YUYQNksRB7Sd0iS3OvLU2mcqhldFZl81XZINehZq8QOik+JRHrbvr7PNNJKcDCRA4RaOA9woq74mUorjdUDx8Za7VrprinO6LfcsB6+IKIricNVpESXwM0Ghj68S1bIWWtG7ZSbhyuoJR/xLKvhWj7Ed4Wq2y7ylHSbX6w5LuuOBjFKdL0WEtpTuO24qlZ4hCfx+vsL1glviMmXZjF94xNa2pyBqD0lM771jlW1XUZSKFaqWLNAo9/4EQZK4TqeHVRUMw1KWnTj+N0DTenslz/4TsMiSHMIfXceuQ/wZU
 mUfD00i5
 zM8UENDnwyjKoyD7D2umG0KBUB6dTmtxytoXb2tElvuvRkVxQQ7O7uUFop6TLdYoH8eaUHP9dbvokbQ4VYOuI9frMrsFH21mjxVnD99BG0I/9qRuL6OGVQiZUVBIa/6QyN7VPXSHgEjeboz4HG/hRiSIPvs1pv79BJB9Bz+XSi9KFAqgg4L0B+Gz1AIn9aErX89TEOLTEhngNVQScdq+pBO2VQXeQhHiSYI/i/jwsvgjMy6p4GCPbfqR/QsfSTU82WknuzyMXANVEBRK3Da9JGmWnJUDaW1p0tYFV5i0bwrbOgC8BhRnB8frB3UGi/LRoV+m7XUzk+WoA8oy23P6jq8Bmv9iYcxLlxfAT7fjdtDvtn+wA1zZ8ILLJA8weVNTZNIZX5oyTsd7mE/kpmpgyQuOiMHEIxh97vbgIuJAohbTZgVOA6klhIqT+j67Eu+T+wiD8H4BvaMuAGHQMMtFyf3L0Kw==
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
Reviewed-by: Jan Kara <jack@suse.cz>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: code cleanups; rewrite description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem_quota.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
index 43d3b4fd6cb1..d191ebda3f00 100644
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


