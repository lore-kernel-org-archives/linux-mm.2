Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D72C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:42:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3AD6B0092; Tue,  8 Sep 2026 10:42:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363CA6B0093; Tue,  8 Sep 2026 10:42:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0C96B0095; Tue,  8 Sep 2026 10:42:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5156B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:42:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2933FA06F4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:42:57 +0000 (UTC)
X-FDA: 85190861994.11.F2E725D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 81B6B14000E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:42:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Lz51TJq/";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788878575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jNxvFKt4UGJwKbXlYaf84gFPggvY9g3V38ihxwf2lM8=;
	b=xDfDuCt1du8yGKmb6d7pBXedaD2Tt4AcGgW0J9P/Lv5kaTSvT46FJyLESrGZV8YmW2dPtp
	1IHkLjHQGMbMErvbW0rpkBi38PLbMuESZ1IirIkYVjJO8fIWK2dYdPXlQz5+dHfLKRHc+K
	XXgqjTABIp9oBhUhhte53bosp9EWmCk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Lz51TJq/";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788878575;
	b=mYe51zwhvQ1ynEHmYnEHuV2Fg3VOxJa2ejWTDUzJsxImtEwZw1BNpNOOn2hQGG3zwkNVP3
	2ZjY2wn5NVqgS5309gpL3STd2qSRBrlbYkbhBQ40vNBjobYU7Lk9rbyx/RgKMyMFCX7mYa
	yoX4PyxQ1DSZd8jRKQrhD+LPGvhPhFg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B2E6404F9;
	Tue,  8 Sep 2026 14:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3A11F00A3A;
	Tue,  8 Sep 2026 14:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788878574;
	bh=jNxvFKt4UGJwKbXlYaf84gFPggvY9g3V38ihxwf2lM8=;
	h=From:To:Cc:Subject:Date;
	b=Lz51TJq/mLh0SOQWb50eZFJzbQhGHKJc5jizpRNUWLtlYghmUsHLlz7VUn2nmVaHn
	 PPEhEdOtcobvJfaCFckPbFhXzZjyP5DsE6uAP6lbzYBrcrk9hzuF8n8TVxRHhFNl+R
	 zZR7/V8OIrpLE9ji89C2nhPBMFrwBNYS/TVq+tMAr6MQdoyY5YE24JPjoww2ahRZPs
	 NkTcKG8s4dfB0MCugKnrPX666QGVF6y5LCq9HDrcVghJ3Qj8GMLkcYqKWg4KRModJk
	 UUr5mE/VAvZNUOGeNEDG5UCHf9M+ER9a03dJVu8+oVriCPIEYk6Mag+W8/c5o0IKDF
	 Me4RIGqmuTfdQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Enze Li <lienze@kylinos.cn>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2] mm/damon/core: reset invalid quota->charge_target_from
Date: Tue,  8 Sep 2026 07:42:44 -0700
Message-ID: <20260908144246.104162-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 81B6B14000E
X-Stat-Signature: dtqea4u7dga434wu7c3tgaa5ujj33ohw
X-Rspam-User: 
X-HE-Tag: 1788878575-119380
X-HE-Meta: U2FsdGVkX19q6jDjSNG5odo9aUQU8fpHlYx3mH+HLDaFUQNz+0omXciZofeRCHK5hCjMOl8wVyBBRfb3UBpxxGxShtVmpfku/9JX13+qim3KSo+ZEwxxXgIPzFYSVo7aAwv5Db9N8sMi3ypeURvalTaEABMuHH2CrVq4Vs2GazVtU6Kk8//JjoH76CyCvxpQYXoXWxNPD+qVZvFrEYD6pqVZN3O3SgVjn5pdcAQv+z6SWU6/PFkEPR68bAp4r/CgGlBKoKQG18K7TMupbqYtbMZPFKJT/UZ05NH9wiUMdTfv/aJ0BvGDyM9nj97XlwXrj/CL++OcrmXXKZk5+fxnWjLfoeaPed7oLLVyvT5RSIyVdIqXLZzuN8+zzsLfhMW1GvPVkx78zoYr1a/2noPdUD+vGceSYaKiKC4YZcwwu4GdZnPuQ+0Dcm4+GCu6GQM4EYeS3tgJFH3gwQmRFx/WW7IFAbcHiEqo91Aw7cFVytTFR+kyE2ubWOYN8jPbMx4hcoYq2yHKyn1WfySM7/t+XIu2sq0L1dYYY/z6bZgr9CvoCMvHQRN0EEfmY8p3Qcoie8fFZ0gvMifGmCfWQBR4kL94K0R5sOBOjfV6duzzxP+4fkAj3p3YszUsRbwwlXyJbefB7q5ETeBf8+3HyHJMaVXgWcCJ5XyQzAgz2kwhf4F3ZP3pz4vkRBfjrXQU08BKEpO5L0q5XbLNmeccFxa8CnKlTxqBFZ8zL/frpQiPW3/Z5spe1aygqAeos7GZBhKHvosKko3sDclSQAsyxcML/nQYYYAtFXKmNV/khjS97QFCZgEkeOb4Li22RlxJRBpTUcyTZoQHad2ofK5IhBGl/9Pk1moYj0YwsyyvuNd46qFZy2tlIoxt3cRVbKgs2ye1AWi+Ih9mbHMwyDwnTk1xJ49Vmaw1JiTNvDuqgkFtctXIlP5zknpIn+BTEkoxAgW9a8ErzSFC8UWVt+UQ1DC
 g2pURX2o
 5YueZfCc+WMLYcFr260hQx7HhiXsx8DiB5kbOrkgTKFKFYMGO1MFwjCLaNPXATzx6VkyXs6Af7M5LWFcnWRBz7tAVg0r0fdoq/YinIEA5Nzg7VTyymVCUN9D/iFVGxNE1nrVNI50UiFVSmT47BzQfu53O6UmDQEEsx8vSX+4LrRKqDhOQZeUMJFC39nWz/pw9iDaiQRLGzxQtQDus0du1xy07wfzWIj9O4ou/Mw+xmJL720xrmsryo69B+Mnhpy/pYBAy850Sxn3mctyEYkCogZi3Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS can suddenly stop working if a target process that the quota is
just fully charged on is terminated.  Fix by catching and processing the
corner case.

When DAMOS quota is fully charged, the target and the region to continue
applying the action in the next round is saved in
damos_quota->charge_{target,addr}_from.  In the next round, DAMOS
iterates targets and regions from the beginning.  It skips applying the
action to the regions until it visits and skips the saved target/region.

Virtual address space targets become invalid if the process is
terminated.  Trying to apply the scheme to invalid target is just a
waste of time.  Hence commit 6e4930e33329 ("mm/damon/core: fix wasteful
CPU calls by skipping non-existent targets") made the logic to skip
invalid targets.  However, it does skip before the charged target/region
skipping/updating.

Let's suppose the user runs DAMOS for multiple virtual address spaces
with a quota.  The quota exceeded in the middle of a virtual address
space.  And the process of the address space is terminated.  Then the
charge_target_from points to the invalid target.  The pointer update
logic is skipped for the invalid target, so the charge_target_from is
never updated.  DAMOS action to every target/region is skipped.  From
the user's perspective, it would look like suddenly DAMOS has stopped
working.

No critical leak or crash can happen.  The user could reinstall the
scheme.  But this makes use of DAMOS under certain setups quite
unreliable.

When the invalid target is found, further check the corner case and
reset the pointer.

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260830064708.40CA61F000E9@smtp.kernel.org

Fixes: 6e4930e33329 ("mm/damon/core: fix wasteful CPU calls by skipping non-existent targets")
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260907165529.98874-1-sj@kernel.org
- Move the corner case check to invalid target found case, to handle
  dynamic quota uninstall case.
- Add RFC tag again.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260906183654.95634-1-sj@kernel.org
- Drop RFC tag.

 mm/damon/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ce8c6f99106ed..a360c41cda89c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3389,8 +3389,15 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	max_region_sz = damon_region_sz_limit(c);
 	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
-		if (c->ops.target_valid && c->ops.target_valid(t) == false)
+		if (c->ops.target_valid && c->ops.target_valid(t) == false) {
+			damon_for_each_scheme(s, c) {
+				if (s->quota.charge_target_from != t)
+					continue;
+				s->quota.charge_target_from = NULL;
+				s->quota.charge_addr_from = 0;
+			}
 			continue;
+		}
 		damos_apply_target(c, t, max_region_sz);
 	}
 

base-commit: 4c152875952628604696dbba38cd487fdfde28ea
-- 
2.47.3

