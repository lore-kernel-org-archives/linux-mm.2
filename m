Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E788606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kywdYZ9U
Received: by kanga.kvack.org (Postfix)
	id 4AAFB6B05BB; Thu, 29 Oct 2026 06:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 481E76B05BC; Thu, 29 Oct 2026 06:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398446B05BD; Thu, 29 Oct 2026 06:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 042D76B05BB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:44:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 980018034E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:18 +0000 (UTC)
X-FDA: 85375329396.11.4B7A4AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C988F1C0005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kywdYZ9U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9eiRA9OkFCUVhYH0CVOKfXufpFXWjFThguNF2Kcag8=;
	b=mvcojzOd/0H17cNBIxoTxsX6UbP5Z8TDTrRDIwYDXTclLT85e1jTsIX43xtiQOiyvcArML
	GClgpTB2jBbq+VAvB0SBuEdz4djM/N8bbiVavS3KdRDC303H54b0tfbHN3yW/tCvmkpnL4
	im/k0rW+azzydbLbtsijK6Yy9zUV24A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kywdYZ9U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270656;
	b=u7pc6qUazI3IEIMoRpScpfeKO1Ak457RGE2axmosALjfSIVZqsXwObkNi0ZE8NMfWudcGD
	70dKDZNnRnLIVeqVoteDqap8FYra7PEbpoZmq0/VgcRYRUZnVJtqZJQu1mcj6JPHMUjsHG
	IUPoUiLpZml76LOt6x7uzt80imD+Ets=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29AA540242;
	Thu, 29 Oct 2026 10:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8C41F01829;
	Thu, 29 Oct 2026 10:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270656;
	bh=Z9eiRA9OkFCUVhYH0CVOKfXufpFXWjFThguNF2Kcag8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kywdYZ9Ug0e28ktD9RtmZAUZDu9cJqQrgac0jhHi9o0dlkY7O+X0Bju4bd39AXgHi
	 EgLCIcRcvVcGG1cgPmENXxWWIREr26oTP1eZkn5SWyZsTbAxWzt97TtA+M9MUj/HqN
	 wABeNhmaozTOpR92/Ki0RYVT0A1Q4pgP564kyotL2zzR8YuMW0hZePN/8UFbzF77+e
	 O0fIfA8MrnquopUS5/QwEuc/ebmJDrtv9ik2HWl10hl5BzTv7VLJ1BwFjrhIAYdd08
	 vPWgT9XaF3oFxqIMS9kfKX91ZMXCjrQNBabgbkQXDTSl+0qZtYYU2O0/171T0Y5Cq9
	 kC4jQyFoLxMqw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:24 +0100
Subject: [PATCH v4 03/15] tmpfs: preserve explicitly disabled quota limits
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261029-fixes_shmem-v4-3-392fc715d8f6@kernel.org>
References: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
In-Reply-To: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
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
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK4fN2Gv+OF4x4gej59Z7/7ftM+9pXHLJ5Rmj6+7Xf
 4pkhWa86ShlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAi3skM/+y/vNxv9PrZ9qgQ
 RfP5pReWrHULWe2TdeTmkTsR7gLlNnYM/wu7pG2ent805f/DtZYFbY+vf/1y5yv3wXtP+ycdqVr
 ars4BAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: C988F1C0005
X-Rspam-User: 
X-Stat-Signature: shocbeq5grts7ohmqcfs1z91cuyb6tnc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793270656-533644
X-HE-Meta: U2FsdGVkX1+8gUCrXK3x60sQjXjD/rDpKm8OCWstjxjK676cPPXKr4niPzWQaSluQr6o18YxMnotL0M7XcPa42wa65tw+QchA43Ko3eq0+bT1Nohg5JmZWRiw2wbMG7MX/NiSzTxcVTzYa2h0aQDaHwK9+vewabVfi28WJtl6mwcByqXhyY88ARiL3E419NIZa/4WofpgOAGeybtnuVbz/f/LjndzwTi9P0HBZtgtLW09tKyYLYiMKdF/lv5KQDUs4MZF/L3Ch0IlKGHt4zsaytxL4ynKTR2htBvYr0Vl0OpZBtFTQL2m0lZQLUvttuMR3mPhR2lTqj+1i9nDwKgIe+rOxfxbzuFG23Akt3XfP9dhAccEoODcttm6cq49v06XPyH7jyn7NueFoUR7HcDmIL+cTI2hr87vmPY2/y7L/lNlK5hrS0mjlo8BcFbbFnJnbsm4V9SoC+LdImSSmzan9Yr+yCLnUPDt7S7F761I7oMcvFlPiy14tZTr0VrFOt+CNGJFGmsahn3Ql4yOWLqIhmOgubhbi1xt+D1fQgnX9TWkt+rLAvcT+pAudfPhUve1iM1/6hoMTsAdpLGmekhn5/k2y3zOszualtUdYkO2xFLbNn6rZGdsP3xDSQJJnZWZZUdxeooXIruX1DK3VOFu9qidGqcfb7q2/LZKD80221W8i2xu6yGPIHsNEIJ5WdCxKhcbprB0KROhQAbcG+DgWp/qR2cyFNfGFI68m4Qt+peqr4+/t64nwSVfp/2gaywlhzWaJWRmRKFcAB3O7oD+DXiKRICIVTHaOMz5y6+HlfQSQmvOhgu551M/h2HRm0HM2IaBLL20AgJeu7aFys5fMimwX1mvqfIF6ltSha1C/tgAGSofyxmKm/fkOphecUzeCYp6mxWPhBEF6vPPgdkTEZZrlMokvVQ/WnZYibCy9Tk7JZnroWvGj/6Jdb5r1cOzJyeuNDtp1uzvhoRnPy
 3XjfdxVx
 QzKIZfLxO/EXYthhetCwle9FTUxZdfsd9+sMCFL0wg8Zw50o6hMrZWw5pwAAaizaP8pNealddk85IYyJnEO7ZSHi0UgtSGUeXxOrmvksfnPZ0aq5d94rOnN7Xjm/pZAUBYuo/3KHRuZKyr+mNOfhGoVMtAgnzJYcqJBgx0k0XCrX27eq8nZzH6DZV92aeBFWOBDP03yxWBOh8Ts2agIH0QNsdQ70gQMIEAno9uYZm//F/hnXZROlGxSMq6xIr7D8cVpz6Z/5ZsgvK7kM2qm7Ft0EjlHP+GOsD901IDkIE939X0j3FA8erxrHEv1uPyE6qUAWEPUxI3NCPpaN8ffraf7TRtjA3VavtseYigTVVn/zRCpcHrb/0UTBsrYik9EKgxUMdeJ6bDvZIlo9GUVChQ6HnBpa2sRRMITgnXspZLJiQCIat/k3lPfkl4e3HMLb06IrwmK8e0zT9hw23fjfHCk7KkA==
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


