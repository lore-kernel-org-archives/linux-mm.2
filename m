Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDD58C4450A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 16:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A016B0088; Sun, 19 Jul 2026 12:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1AFA6B008A; Sun, 19 Jul 2026 12:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A314C6B008C; Sun, 19 Jul 2026 12:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF7D6B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 12:11:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EEDB5C05D9
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 16:11:42 +0000 (UTC)
X-FDA: 85006016844.15.F29FCA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 69E404000E
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 16:11:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OwpLxcVL;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784477501;
	b=LTrKNRKz/QnKreT7EqMhxe53V6sHu0F8vG9TK8YX5BrIlZAlDNtjEy6dHDe7m0Sjfam9Co
	9BTiQ7qBF9dFSKXve4zWWS34zKTEH6U0ytjvag3Hox3UvhwvpGkBwFIFK4UYU3eX7lGAEZ
	oMiNcXknorokmCXukz7liXIqKqaZ/LA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OwpLxcVL;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784477501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VMwzI12Qt5ciKjfitMVlDvecEgiGz82xEPDSiEP7R1Y=;
	b=5O2xzv5nEg4y7ZPuGelN7LC8BLjFX9qbwVvrbPt16w2pOsf/H4HBNvgwFMYN+FXAn6m52E
	IUz6eHyYfqw3W3pSg9zDgSvcIhbcyYGyAsoBlUIMK3PxEVY/Fsg75zcaiVjKF3zrrV8Vqj
	e5JZgBQPZJa8OvLceKlIvaL7qiVmzeY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 475EC4069D;
	Sun, 19 Jul 2026 16:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAB51F000E9;
	Sun, 19 Jul 2026 16:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784477500;
	bh=VMwzI12Qt5ciKjfitMVlDvecEgiGz82xEPDSiEP7R1Y=;
	h=From:To:Cc:Subject:Date;
	b=OwpLxcVL0NbruJq45iPw5bucNh7UZpY9Z1sMn3fwP7QHhpN2ZEZYdVR+OsU8aXWtU
	 mYbv1X7eiURQDL3JgD/1+P1e+kYLQN7YxTjisusyVVECxgCchYWqIX0O3FCi0oWFKd
	 XaoXCIV4Ns0uWSLtEO8IjBK/wLvdkSNzn2ZQkboO6sd5mtgEzx0YZy7O7ZurXDj53c
	 +u2BHG4OXooGSpx7izvsVV/2jTLfNOnrOWqEkv/V6xdMRRlUOe5h4EUwJBE2MCOpmQ
	 Y1zonEfjR7lDnbtLzPl3xoDflZ2pbby3xKWAXf2quFQrpVhFQHOvjSDyHWbkKnJI5B
	 VWSy39zrbZlnA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/ops-common: use nr_accesses moving sum for quota score
Date: Sun, 19 Jul 2026 09:11:33 -0700
Message-ID: <20260719161136.90191-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 69E404000E
X-Stat-Signature: qt4xgxdukgfe85wm9ugyymnm6sgzw7iy
X-HE-Tag: 1784477501-437837
X-HE-Meta: U2FsdGVkX1/Y5sD93uyk68Gz+1Mr6ym+Bst+Rdz6soQFsqgfetfzkRfjUP7DPglr8UdX9Xj44lMzrsej34qwGiAvkM4dCDrGUiRqrimYK/3oLuk+iVJ3jGas8LdvUlk7npyfVvztvCYuepO6aPA7YVnlEnvnTZaEH4h+2Mcrqn9fOUP3pTfgmz3FEuIrWMxGraZK8uv7NwwfTI22HtQhEWhpdrFyWdio/T7lYl8PXLLTOWA4Qtv844XUis9QHfiGLxJzpLggCeVA2AJ0Sh10K43Hv469SMKTG4rzaprnxhfuCC6wQTXaMPPnKvrgLAtXESD6Dy4Ae6KdR5c4UEhV//AxTi8T00vkAibpUIfWkn8ih7BK+YcwWs7b4xP+lIM9X9u+0538FcFs5wlIlqZHX4E0cPjUgXUE8Wn5olKnzytAAFmEN540k4tCsfBaOsb03wPc1Z1MeWAC2ee2An3UzogM4MHiLSEUI8exeXix56aGLAK7T9r5PfeZqxzNnFbT2tuyvxEBDFpAguTjL4RaIUIyoBhF3dMTZITJG9JMjLhi122H1mUtAXGy0RReiM5g1mRgcj5vv65XNfhxVTmj9P2nEFtZGjB3JZvpVxYzWWg8P3PVv5huWpjGhk1RoLU72FRQvCUltLxCiQc5IUBZsQ2+ksnFM++JgmFSKwm6+6jB+K0Qfm8iPPcbDv3X39jOK1u4Tnke9q6jZ/QW3bpUJV4Wvrh9BN0X1X5O9XIHRL0/jrIyOTUMP9+FMndkPh5W94EwQS67Yk7cJi2MsTc0x6pPwFdUL04wRQUsDoxq1JFHg/cL4xOXaTKo7emaeBJ7R9u+6wB0rUcoMajFA1slL4Wyl3n+XxaG6ip7MuWcxwf6dx5G0CqHaZhwgYy8UJzbGG381N68z1PqBz8WpomNZeUOz44smSI6nyTbOthICdWOM65JpGgmqxG390iveQlco/tflalAZn77zkQqrtj
 oMRHqAkt
 8clLj/fAj8nwqywcNGK01VAJPjo7OreH+Wp6GGSmyxYNza+nFzQ8lTHQ5rzGc6Ucw6iAKLpGEdvh20IkhEc7zxG8XHLBGTw9uifhk05gufP+RrIj3qmPBze+fRPxa3fvY8b2oSpje845ZHsrOCcbfkVQDbAnNmKK1G1jyc2WEi6c2ppXqr/j1x91XVP59POv6E7s/V0AnMdB0N6j+HwzSEn/z+mYOaDssdO+pgN1tHG+ogZMHWRz1Gly7RY7TxMsBoZKK0j2iVNxWhe7XxqewRCSjtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 42f994b71404 ("mm/damon/core: implement scheme-specific
apply interval"), DAMOS scheme can be applied at any time.  At that
time, nr_accesses may not be fully aggregated.  But the quota
prioritization score is calculated using the not fully aggregated count.
As a result, the performance of DAMOS could be degraded.  Fix by using
damon_nr_accesses_mvsum() instead.

The user impact of the issue is suboptimum DAMOS performance under
certain setups.  Nonetheless, the bug was there from the beginning of
the setup availability.  In other words, the suboptimum performance is
the baseline of the setup and hence it didn't cause regression.  Also
the extent of the suboptimality was not big enough to be found from
users and testers.  Still, this is a clear bug that is better to be
fixed, and can be easily fixed.

Fixes: 42f994b71404 ("mm/damon/core: implement scheme-specific apply interval")
Cc: <stable@vger.kernel.org> # 6.7.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Given the user impact, this is not an urgent hotfix in my opinion.  But
this is still a clear bug fix that is better to eventually be merged
into stable kernels.  Hence Cc-ing stable@.

Changes from RFC:
- RFC: https://lore.kernel.org/20260718180121.94759-1-sj@kernel.org
- Drop RFC tag.
- Rebase to the latest mm-new.

 mm/damon/ops-common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index e59f5268d503c..d7d7f100389b0 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -111,8 +111,9 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 	unsigned int age_weight = s->quota.weight_age;
 	int hotness;
 
-	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE /
-		damon_nr_samples_per_aggr(&c->attrs);
+	freq_subscore = mult_frac(damon_nr_accesses_mvsum(r, c),
+			DAMON_MAX_SUBSCORE,
+			damon_nr_samples_per_aggr(&c->attrs));
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
 	if (age_in_sec)

base-commit: cd3ddd04256381e4874c14e644c9d263e323e777
-- 
2.47.3

