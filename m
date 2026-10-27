Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4171A606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LntWz1aq
Received: by kanga.kvack.org (Postfix)
	id 57EB56B0719; Tue, 27 Oct 2026 09:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555B36B071B; Tue, 27 Oct 2026 09:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A9A6B071C; Tue, 27 Oct 2026 09:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 227DA6B0719
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:03:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 990BA160A38
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:03:49 +0000 (UTC)
X-FDA: 85368423378.13.FD85BF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D7A044001D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:03:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LntWz1aq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793106227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuTQQCIIhCRj/ogwMUaU/txEPw0T6il6C0pniQihRqQ=;
	b=o9pVEwQwYN0rkGZ3kQkkqGZ88ay41lIkHlBYSWApVYV4SuiB4PBE7isLML3jYZ28sHM3IL
	8bGLOyJUMAuPRMy+khKVHpe3oPdYSDkaoqbMdc9uaYwNQC+FIw3GCT+Cd9d+WKF45irqrj
	skflNz+B+YZzQ8/uZq9CspIfg8I8o9o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LntWz1aq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793106227;
	b=h2cWq+EjjkSBXSQctp0E+KSx4XdTq+ddLJpwewQTfJW3uiE3Pb5x/k0Zv5WOrHTwv0tsfz
	wX8AQ8U2KbvHFgbBQ06qrUNV7g9dcxWvAcw0ohe8il0ZdzoumNLTfOoUWS2+luOssCRFio
	yCoAvoY+8dmlK9ea486Kdub2XYWpsdI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7699760211;
	Tue, 27 Oct 2026 13:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4751F01825;
	Tue, 27 Oct 2026 13:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793106227;
	bh=FuTQQCIIhCRj/ogwMUaU/txEPw0T6il6C0pniQihRqQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LntWz1aq54bGNesh7BxKU9O4TTVvUn8Nb85jHj0+dEg8gBWUsiJ7EEsWPcueC9j0X
	 FEuCjgO84J4BAk0jUowFE9WbI9ZGoKLdwgkpL4rVUhTEV6NYNUdjZgLMw4A4BGrJv5
	 gjo1NCsMWD7eMYBn0FWhWSbdWub9sNQok57/LZA5p4iB+kJGV8bNp4iAMwTdttRLrh
	 JCz1Tp5kyVK9krOqnecfbenbFoxboTngoFDFGhcdM5Qfsq/4xr02OvkZgeCRbjhs30
	 Xlahlb2PsI8DOkN1tgA38JdF9skFrmcmNRvKiCPzQml01gRIi2OXy6Vr+V+N42C0mA
	 NGFNhzFrX8Utg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 14:03:08 +0100
Subject: [PATCH v2 03/14] tmpfs: preserve explicitly disabled quota limits
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261027-fixes_shmem-v2-3-86a00952acb9@kernel.org>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
In-Reply-To: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3975; i=david@kernel.org;
 h=from:subject:message-id; bh=F9NYnsgH8oBV9j5aJk45w6lMYbZSDg8OHv+OvgcNne8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeLBSImX5u9oq8Tz/OLVvmufhkyP6PYpnd6z/uOerZu
 0/3Tr59REcpC4MYB4OsmCJLUPB9g5cv19VWu/Exw8xhZQIZwsDFKQATmSLN8D/lhY3YFJW8jPJk
 Jg0O3cCODbd7eO7szKyOebl/KQ9niz3DP+ONsuyv1B4p9m08uLNo0Yup1QWLVhxyTHw2L1Rj3WH
 GUj4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: D7A044001D
X-Stat-Signature: 9r6hnpg5y9rtt78be99inc8u6kgf43mj
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793106227-572856
X-HE-Meta: U2FsdGVkX18jBTVlZJnLI4N3ImFMRZkoqV3fvsuqseFshYFze38fY2TBqIRuifgfambHr5sNCPkUYiRRhS3knGn13t5HwtU/u3Bm47gSNTiKcJb/rGhHUEt6Ic1+F5g9T4Qz3j269fj6fxpd2VQV8o3zgDLM7K/1A9A/8/9AE9+3ZZo66rEwVqYAOjFIoOdAKPYz5dF6HuBdqpTfunlYguml1EO/Lsl7KUXn+6lqzyl2S762q/cocO3iwQ7BafgwswuQIwwvWZYwIrdOaxfZrtwvDhtH5gHB3noB9rWjACZSn3PMydPN7Ximk+6X7lR3G0qJlhKvHZZPAhVP77//7wgrt+slpWDwUlgla8py6kdOkNERjAy5zdA1SbKZU3ujQ1N0OOS7DYUyMVM/JarIsa0OYYm/IDhlFXxtAdB9UT9VADWoGQHy2N2t7Uc1QYtcjJUlb/jT6T135MTgzfKvKGkcHT/yiTWSGZ/iL24/T4IpS/EitgByv+XvW+bjIJrtzQhkRGH2qT05CzZujxtUdWKxEfTG6dIQx7ihiiAJX0GPZGGbzY40R44t/deTvYkEDs8/L31uPfHKilrkZorhRIy88z7kOrLwglqCW8IMu22zODSuvwzAXa8VwPs8IYQnHkpgUg/ShmCW61gf0weAC8snErjfwI1r1VvEB5+vFE+/l4uz5DI5kHGtlgQ/cnw+YTXnvBfO+JQlypg9HZDLkDLnTbSGBvpk+JHf2d2RvAtV6Bqa5bvvZnNJXYPxU9XhbaL1bv8dY/3WFiIw04EgMdtRyCL2neUWVIwv/G7vOyQi5AAEd9Zk7B4N3U58gSQCj/UAU2Cen/0JszRSwuWR1F4Vs9dM+xHqBU8LJNEovi0yZVJTr+ArS1NFaNBf1VtUZ6xoe9rpHJCqDqZw7vbCCpxN376EkZqmim9fdqt7SxlFyy2md7FMZJoHkp5rjyvWnOrSLp0zf0QJvFbMPY1
 cRSOavqY
 HfQO6kPXxatsuRPXmj1ezRiLRsQXszYeMaZdoxBUk7BRbFIqeP2wy4+CHHypt8MfQSwGSkwi4QbDP09QOFqn1d8bnfScbyNT2OVay86Nk8mX0ERnM3/+/yC+EXRLlbhUnzMlZplh7NlaaSnr2IDRM5qZHaBJYmwy0+kZCl4kResJ1gEUNDVC1jEK/vUHQ81nlB0bDLGpCoQZIHnqFLqAxb8Q/tdS3exTaViDUy6mdnXxFV5sUtyNe22U4xjScUZMpxOIPbNh/7i5bzXB6bN4MrXEiV43iF1K3lPSJTCNx/5H/cayLATNCH3Lr+nr4KWKxpo2NFiQaKR3Ljfzp00ECFr72z+hQnJZNpYvmZ9CFj6TSSzJ+uDuSooqHCTxeLo340u2yZwgg5VAXJ20UAJcZLrmXxPMiAmRlef9EqiEtOLaWLswu5J4nF1Dth0hY9awWxFb4MuAL+zngflOPLOsliFJUyI55uqjI1+XYW3I/+hbAOL0oLg705Hxjsbs2W5mYZ1co
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
index a83392f75e56b..eeca9efd448a2 100644
--- a/mm/shmem_quota.c
+++ b/mm/shmem_quota.c
@@ -234,7 +234,7 @@ static int shmem_acquire_dquot(struct dquot *dquot)
 	return ret;
 }
 
-static bool shmem_is_empty_dquot(struct dquot *dquot)
+static bool shmem_is_default_dquot(struct dquot *dquot)
 {
 	struct shmem_sb_info *sbinfo = dquot->dq_sb->s_fs_info;
 	qsize_t bhardlimit;
@@ -248,21 +248,21 @@ static bool shmem_is_empty_dquot(struct dquot *dquot)
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
@@ -297,7 +297,7 @@ static int shmem_release_dquot(struct dquot *dquot)
 	return -ENOENT;
 
 found:
-	if (shmem_is_empty_dquot(dquot)) {
+	if (shmem_is_default_dquot(dquot)) {
 		/* Remove entry from the tree */
 		rb_erase(&entry->node, info->dqi_priv);
 		kfree(entry);

-- 
2.43.0


