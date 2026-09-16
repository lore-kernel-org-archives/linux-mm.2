Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F7DCC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3786B0096; Wed, 16 Sep 2026 09:50:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7844D6B0098; Wed, 16 Sep 2026 09:50:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A156B0099; Wed, 16 Sep 2026 09:50:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49E4D6B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:50:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CAB65A0733
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:50:30 +0000 (UTC)
X-FDA: 85219760220.25.10E25A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 26DAC14000A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:50:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="auO/EBP1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789566629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K7T1QVABApjQc8vlsE5UVS8mdXdQEDKvwmurJLYEtzg=;
	b=Wm1zHocUDvVvjtleuszN12coTs4a99hZLOuyxvSAIlK426enoAy/B05AFJOirte2kfTxbC
	wjF6+VeaEoIn5P+y13lNcaxIEtk1OB4ShzO2KUJjPAvVlOGuGCClYSDQbfpqCncZGx9aZc
	SprCbROJlWsIQaVouFwex3+k7CXlLCQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789566629;
	b=HxQPKlcwT0zWvFKXs0x9jNEz9QINe8R2Ozud2T7wUFpGWym8yogQah9ge2GyOpm+Yzatkq
	9goCrmvKENdcH+W7/daG0CpaRTa++8IhGtfjax6vDIuxAYVIqlq5QW6v7xIxWsAEX8XP7w
	037Z2WUHU4UNQPO94H9XP3kHnuz534Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="auO/EBP1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7916F413AF;
	Wed, 16 Sep 2026 13:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244511F000FF;
	Wed, 16 Sep 2026 13:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789566628;
	bh=K7T1QVABApjQc8vlsE5UVS8mdXdQEDKvwmurJLYEtzg=;
	h=From:To:Cc:Subject:Date;
	b=auO/EBP1rEr/ZeaA/kfaI2Ze7jAgE0bqMYMop/sNILRJgcDKgdrIRT3mv9qqoonwI
	 lh92WtYuup4avrhPSZzOzIXhPGZw1v+jC+jH32pSaTH8yVJYjcHt7HA5A3qlzPQPFs
	 4iKDA8RqdRQ7Xd+imVlL98EqFNVzYFT4gdC9wD1tek804VIYlEwPXaRCecXlQ5Dohp
	 lXAfdjTtyF6/Qn34nJPHO1FkVRTpl4QYlbGmdP3P3y7etr5Glv1254Mh08iEu54XmU
	 4wfKu0Cza7C9G0wH7IDnGMTaS6MuvS4bJJM4osBblhXuMJViHLhHIHFgKo4waEoq3Z
	 ougYNPlqyZ1kA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [PATCH] mm/damon/core: don't skip damos_adjust_quota() while esz is not zero
Date: Wed, 16 Sep 2026 06:50:19 -0700
Message-ID: <20260916135020.86483-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 26DAC14000A
X-Stat-Signature: wdg1s5pnzw4oocbga6c5gsggot55p4uz
X-HE-Tag: 1789566629-168401
X-HE-Meta: U2FsdGVkX1+qLBArUjInavb9YzYTB/s1Est/QdG+iJect5dHRnhknqWiTzM/fHac9Jofwpg2p5SLQ2YLUn14GRgd78CpAZaD9oymFWGGuVq6tRdBEVrWh9Z2DdbclyM9dlWJGQMtSL+/aGguLB+04uuqqCk2bIHkYtr2BejUC0v2xVf0Ct9yYWwwkXVu4Oc0DXHb4OqS8mgPCXfH0N4wX2ZENkh/xxIPIv7BHEAaU4zSQU0psu4b0y2QqVAWI9vuYbDBWxJxuoRYwAp/TMbTS6lLPiqMkmyM7gMdl/DOLxBc3hRdckPAiN0nmO+6Gbm8OEDFGz+KxuLqWuDxk84VX9/utXGpa24RzYO94nmRYYrDbgKKP5q0Y5M+fZM5piYKvX8GfqEsyJHxIhy60RpUq9qU5hxhB6+Be+1bn839D6efDQ40MGNL8JQjK4E8SXuIMHzVttE6JV11K9vDDIfiFOEFe8/bpUk7KDMheSNxbGxslfZ7iZS4ZtzkEY6yeLSGv9BHV/Oqbz8ccDEJecEgLcUHJ7Q8UDATv6OIyjwEMJUu0bbxzjrrOz5bO+clHk9Zc/Vm75oXYmu2PcQ1WbFpt44FOoGk32Wh2L3rAXIauHt9QaCGvER27v6ICUmSN6ggW8COk1F9s3ucw1JDrr0CJLIh1TobSxHfS+qWwASSsURM2yfLs0gu+IYpUnlstXyaLk9pLSUGXbA8bTVOxCPVRF8YVHbE8LScekUjV+gNTir4VX7AV5CkEJEB1KxBmA5PavFdRM4uYYyQMxOrRbYD8rgodPqxAJ2wvIyUdwbaO2n6VoiJT13gDzutqffN35zWkZ7qBaAQ7jL8wzAGXmFtJBii/k1P4vj7BKO3DHnENpuEr81P82OdP8E3ohVUB8tWbm63sl5n4UNS5cUCyyYcayljyDnq9ZR+QVi+bRnz2fjeGt9ob5kX/p79RYOwYtfKKhXQ7f4lCQX+xgtQQey
 l88cingN
 AINKD4rIHxdul5JDuDBJIaQgq+QppXdIxaJN3D1kfgAg9wsm1bkGXVKODVmDbmuUAh1exY4WIoJeRTf+6APDvl6p/ZTK5//EMSs0ZSOGI8ZCvqgJrv3FF20OpTcv5qm0NPZ/KzGaJRHItP7eE0g1lQDqD7z3xkxilLiVP/TUm5fX8O9B8RpR3mpuz7jYZEC6chPYl+sbMDwY1VgBzO5uEIH+jI45SXT36QhB5a2Gi3Q6q1Ft7dXGXh5I1CuomSfYcnSmYL1ZIZmNNIdrVJzHdh9RL/oAyxOv8DVwnqUNPPGN4ajHQ8Bii8GufX+swVw7lwQWRs44/8M6ULqQPZdw4/8kMDw0y/z1UIczBnJIUHQp5ZkphlrwEY0VSXbM5589+2fkP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS could unexpectedly stop working when a user disables quota using
the online parameters commit feature.  Fix it by correcting a wrong
quota unset check in damos_adjust_quota().

DAMON users could disable all quotas by unsetting time and size quotas,
and removing all quota goals.  The intention of disabling quotas would
be making DAMOS run at full speed.  When such quota disabled setup is
detected, damos_adjust_quota() skips all its work.  The skipped works
include effective size quota (damos_quota->esz) updates and charged
quota amount (damos_quota->charged_sz) resets.  The intention is to
avoid doing unnecessary work when quotas are disabled.

However, users could do the setup while effective size quota is
non-zero, by doing the disabling with the online DAMON parameters commit
feature.  In this case, because the effective size quota exists, DAMOS
will keep working with the quota until it is fully charged.  After the
effective quota is fully charged, the charged quota amount
(damos_quota->charged_sz) cannot be reset because damos_adjust_quota()
skips it.  Then, DAMOS stops working until the quota is newly set or
DAMON is entirely restarted.

The problem happens because damos_adjust_quota() assumes the user setup
for disabling quota immediately disabled it.  In reality, the quota is
still working until the effective size quota is also updated to zero.
Other logic for catching that uses damos_quota_is_set(), which
understands the fact and therefore checks the effective size quota in
addition to the user setup.  Fix the issue by using damos_quota_is_set()
in damos_adjust_quota() to determine if its works should be skipped.

The user impact is a non-deterministic and unexpected DAMOS stop
behavior.  That is, users would disable quotas using the online
parameters commit feature, expecting DAMOS will run at full speed.
However, depending on the timing, the setup can be updated while the
effective size quota is non-zero.  Due to the above mentioned internal
mechanism, DAMOS stops working instead of running at full speed.  It is
unexpected behavior.  It is also non-deterministic because sometimes the
setup is done when the effective size quota is zero, depending on the
timing.  It doesn't cause critical issues like crashes or leaks.  Users
can simply set a reasonable quota again, or restart DAMON.  But
definitely it is an unexpected and non-deterministic behavior that makes
it difficult to reliably use.  Also investigating the root cause of the
behavior would be quite difficult.

Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Cc: <stable@vger.kernel.org> # 5.19.x
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260916041409.106926-1-sj@kernel.org
- Collect R-b: from Kunwu.
- Drop RFC tag.
- Rebase to latest mm-new.
Changes from RFC
- RFC: https://lore.kernel.org/20260912200814.145612-5-sj@kernel.org
- Split out from the cleanup series for taking hotfix path.
- Describe the real issue.

 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index dd4317df42ff4..444c97c184027 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3348,7 +3348,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 	unsigned long cumulated_sz, cached_esz;
 	unsigned int score, max_score = 0;
 
-	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
+	if (!damos_quota_is_set(quota))
 		return;
 
 	/* First charge window */

base-commit: 8d713ff18bb27903ec1e19e54eecdda4168fe440
-- 
2.47.3

