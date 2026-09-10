Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 491E3C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5467E6B008C; Thu, 10 Sep 2026 10:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7866B0092; Thu, 10 Sep 2026 10:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4354F6B0093; Thu, 10 Sep 2026 10:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2485B6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:28:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45EDC160335
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:28:57 +0000 (UTC)
X-FDA: 85198084314.23.522554B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id CE2A82000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:28:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=USlad1nL;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789050535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SW8evpy02DamdqiEXgaSrgnCDzWYzeYmnUuButPjW68=;
	b=Umvb6L2lLRcDFIuht2qK6SwIGnhykaFxdupSxtlOuxTGD1fpgZM29l5H/DWNR067gl1yz3
	OJx9bxBhgZPJLtGDI5g6LuEFq2RDRPk25F01ihk1CB+pu1HPH56OjLCMUke6DP+1cu7yHR
	m5BrWlq4Cj5c2Oz6N4iQlrFzYQPPnHE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=USlad1nL;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789050535;
	b=8QE1PZes0xJ5s3t6n1WlcgJDQFAGw2BKvw/H4m4SW2NnnZ4v5R5qIeL7qmBpjnV4xtms3I
	8UdQzqzol08bHWunZ7usrBxkAEp/37cX1MDNJieRb6AqUpN7aEK3gjZVsYsgldxsxQ6+sX
	rnWhcqUMqPT6H+VzXyTqiRPs1gyEm3Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CBC1600E2;
	Thu, 10 Sep 2026 14:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3E81F000FF;
	Thu, 10 Sep 2026 14:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050535;
	bh=SW8evpy02DamdqiEXgaSrgnCDzWYzeYmnUuButPjW68=;
	h=From:To:Cc:Subject:Date;
	b=USlad1nLJGBwm1TYjCXfWCjFwVc1+yp1yNfaYzaZ2UJTL28VarH9mHjDofJ5U7qdV
	 yWXTkCa/SzEwXLxakf5RFyH7CY7LMTIHvqcYDuegGK7bfn2gk5RbIrWbJEo9S+wlkd
	 4duC0LuhDN3UJH7DgtLTMNm6efHvoqmzIXtCsqlV2EJuoGTzpQS86cY4/CWCYDea6d
	 ALvqaZeSwbE/JQCTCzbYz5E37L/ffg3v3krMg/iF9/p7ZHnAVlAdiMfLGYCJZ6QNLE
	 Pq/2/bKG+mVUCkVR6sQrTfozCGq9RpnpEmVOl5r9zVu8w+8v+y1JYxog7C4jwqlGfq
	 6qqXOstwzJBPg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Enze Li <lienze@kylinos.cn>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] mm/damon/core: reset invalid quota->charge_target_from
Date: Thu, 10 Sep 2026 07:28:45 -0700
Message-ID: <20260910142846.172957-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CE2A82000A
X-Stat-Signature: obb5dkj1kdr4z15rxsnakj14qj6qac74
X-Rspam-User: 
X-HE-Tag: 1789050535-499954
X-HE-Meta: U2FsdGVkX1/ICBCUnrYLUM1QEo1FoLXAMlOHBLrvwfiZ4Vjg+skhOqDqt7fq05PFOrUeKxn88t9iUTOXMQ5qje21Piho2VR6iXcGgZwa0AKwOhg1gFvM8/M00I9X0WusVrHNfkqI3Pm2pdCirpaZaboN35t0Y0oyyWkJ0dNJ/JOAbeTFoTklFhdl8PC5DpKo8Jsmo8XQKPfAavXKCMiYUbhgfsdgSHq2/2c5StwyLy2WY/CP2aLvvBB7xlQ7eLttcfJa9N6rJ+wdGsI1yh7wBnNwsJPvEpzg/MWbriDyz4Gv9kLRzR4ADgwhR9BiFN9mNBo+ImRHirSKCIvW3l2RgwlUKRHrDOBdajaxPjrKxq+eva9pdQZ70TBZ1KPt6u6gbXP2YiTt62ZrDYYG8AHy2a5GKR8b19/tsYg9rJtAhSNOuE98PdFtmm4VsLO85Pf8ZVcPXP6ywh8E0UNqyzeItdc/JpsuZZvRuX3fgqxyjad6W7PgBsfGfA7GOsJgpzDW/rgkQaUFkrPhxPm4gcsp8E9mWzmiP7XUA/zJjlkDG4TnKK2S9uq+konYnUw35YxxGsxPQIM4W1KIURh4mMe9rsTblGeLUcQszkoolu6/D8YQthbcCKWbWxH4hrwXHh5lbBSUm5SaauhyEoBByI9YftKrmSIkLrdTsgwMcLajN9FCGsychgQ10ozoK4h/qAUxJvQCZO+LrAgnHomUSDfawuPTZ7ripdtpyMElY8wj4VTD0N/Ky8zVAlQwLenOD1dxIYUCfav3SSWoJECUL9ZBueXYAYdU4nnR+FxuYvZGgiwFqc5+/C5WXTu+SKZuqXVwnZvL7qcE1jvA/5SmXdBFRiBbRgqUtoD529mq4pfyXNcHd5oJXeDoKYOBoNXAa598d+AhRhY5kd8QTPPq9dxT40HPet79UADBxqV9XunDY1QtPd3f7gCXIJfDnWb24tBXtxf5SWqXciNPb+xIh1y
 KQRH8DHB
 8Dg92LmTSXeb6wn6Mi/8w2zZ7xEmY5cMQ9tjKNuDNWO8s9e1Wi0nvGd9XyfE16kr++mqNG80Yrxjgc6LvD9xpblQ4Z0y+L1J346lBhmk4W4Jy9Ki0Poug/glHK92R9DKtqxs9KEbYlelFDF5MRXPXx0xSeuG6H2SgZI3hJwTsD7kmSchlDU92K833olgic5ISLs0Lm9B2qhwMvRJ0/5tfKQ9HYlHU/W2rk/p14IUm7p3dPnQvGbiJ2PPLZyhDpbw4tlUdxxON0aQzuuWzn8W/qRoJmg==
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
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260908144246.104162-1-sj@kernel.org
- Drop RFC tag again.
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
index 645cb367019ae..06cf2ab7e97d7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3393,8 +3393,15 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
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
 

base-commit: bd699d8a4388cda037f01797294c834fb422ebe6
-- 
2.47.3

