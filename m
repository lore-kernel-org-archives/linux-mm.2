Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5A99E6B270
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 03:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4106B0005; Tue, 23 Dec 2025 22:46:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 481936B0088; Tue, 23 Dec 2025 22:46:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 376DB6B008A; Tue, 23 Dec 2025 22:46:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0556B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 22:46:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0C5913B53A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 03:46:06 +0000 (UTC)
X-FDA: 84252976332.30.685DC39
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1D3582000C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 03:46:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lvjG7KPr;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766547965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SypNxq4ihkSOpwufXMhOr4v6vA4rTimGBEpmyUwAS38=;
	b=sMfVEiYjWkogZUNPWWhO9vgqeuPZTVFDzhKZvLHMJyw+TzRxv2N3lVzqUDhG82QmY/BP2G
	0gCUDeRn15ihRB+FnZFABuAZcd8+JafPwHtjLsS6kkogjsuJox4sJORQVmI+UbAlAcybdv
	V5NTVnbDZNHS4cZX1fIScwF94qSxm2o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766547965; a=rsa-sha256;
	cv=none;
	b=2kJJzzn7epFv2sfvEQAuLMN9tK459iF1tX2keKmLJY1+TyTqSn7fid0P7/ljxvutqJCUgH
	bzkoTMkYfn8jMVg7wkSL31Cd/Nx28S8xzwNhzyt76KZ2jzsX8ypwug1Cdxg3mhyPwP6/3k
	+/BjepSl4jw4ALq+uxV+VwIy3cKC0Os=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lvjG7KPr;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766547962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SypNxq4ihkSOpwufXMhOr4v6vA4rTimGBEpmyUwAS38=;
	b=lvjG7KPr3mKzGajh8YrxhwMJQ1a8J2HScnYZq9MVlcn/asADajOhFVEAb9UP2H6Bmk6H5X
	2x7u/CdWwkIWl873VSWvPxx0RKUKhnKYDX/UxembPa88QErwNyTOmYs1kp+l08BjT30A+/
	SWXYO/277sqa4GJjcRD1rR4oDyisjQQ=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH] memcg: damon: get memcg reference before access
Date: Tue, 23 Dec 2025 19:45:27 -0800
Message-ID: <20251224034527.3751306-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: x6rp19owb8ms7ggttonnq6mjrpyguoeg
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1D3582000C
X-Rspam-User: 
X-HE-Tag: 1766547964-726769
X-HE-Meta: U2FsdGVkX1+tISUi952tLFR8rnvNO3yTupMxPQymr9EMrl6VGEBFgS7gmjEvsPboFzm9219rivw2bReTWlN8X39rQaONePKzzrP+YGoOBThnXm8nm4PpunPGWOh3hQJUxJ/HEPj8AjuqvElmSMO7MNC8EqjgtZebQzxNhLi/VD+RZMVvf/H04JZpWp+QB/HBC9X/bXvxaSnbgHRxvkLW5F26ELYJDORaxdZiNc1ZA+NwgaO/Z+OkT4TxyEXyobEsYxcAaLEg3/hnlj/2NTRFGE44Sh3G3C8MpKYXxF3RdgqjsZw0nhUmw/eR4c4nNf/8vzw4HGHSsjoVzWWRVHtdFbfm/HaM5seAcx0KlAPoqkm+Hn6E0vnAksgm9E8rEvHq8LegM5HFcAmp7rNrAsYi/kMqfRw6ehV1+7DMBDQkE0FHZxXzVA/sHouJrqZ11HmHUyK6mQfVSyEpvEMlW/CtmCAPZpvXZeghmqaRDf/OwCMg9ATj2XgRGX3DLODqLb4exWWS5//Pczl9mIXit0FmMnY6Ok4VT4FVXxLaMR7lSjKdTCjLWLpl2X1Tpk63SR8qBq1KaUGGFyq/nQwZ4MZ+N4dEQye5SASi7KoU9gP6ZIkGCAA9NPs+uFRseDdZiLVzwrt9g1c+gHYwyWzPGugHb3TsukSX1U8zjfTf8v00TYyJJUZTP0sat1XjZw2wIQMfdmiCot/rz8Cd2WdW3jRoxoWUDF3HCaPymQuJoSdlDI/hroVu4PoGaJ+9DtBA30PgBh9b4qTYhQXM/A7ZMyK12G2leZ/ErKPRNW5G9j6d67N71lAoFDZx4oJD1NkoU3ecLH7JtGiAV39nEq+L4EHp5B1K6D3cEYJ5M0TIOE0QyOUbSSgAHWBzJNzK+EiiIE+VhIgBVXiQGsLDkhkpT8ZLZLQrFYuo3UsJ6dRUJQN7dq0Xj3GtuopiwsXjvZaPZDv+K+eJ1fDq6Ez3P03b7T/
 RJuDPx/W
 gQE4dW6Vs+VpCy5N4oYYElkhdAo1Et0DMbEQqBUqyJbBATys1FHewgXbOgUPtoAOi9Lu9H6IBigREMkONj2sTh2IyZ8B7kx+UFTokV3xR2hRhOw7x7tUJaKzNnXsFuEwUEcOlWAb9IqypH1E81DGcUZmu2cu/fa4jJKHKqUSnpbMOGtW79Rpg2s1vnQe2hYcSd4jl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The commit b74a120bcf507 ("mm/damon/core: implement
DAMOS_QUOTA_NODE_MEMCG_USED_BP") added accesses to memcg structure
without getting reference to it. This is unsafe. Let's get the reference
before accessing the memcg.

Fixes: b74a120bcf507 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/damon/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4ad5f290d382..89982e0229f0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2051,13 +2051,15 @@ static unsigned long damos_get_node_memcg_used_bp(
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(goal->memcg_id);
-	rcu_read_unlock();
-	if (!memcg) {
+	if (!memcg || !mem_cgroup_tryget(memcg)) {
+		rcu_read_unlock();
 		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 			return 0;
 		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
 			return 10000;
 	}
+	rcu_read_unlock();
+
 	mem_cgroup_flush_stats(memcg);
 	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(goal->nid));
 	used_pages = lruvec_page_state(lruvec, NR_ACTIVE_ANON);
@@ -2065,6 +2067,8 @@ static unsigned long damos_get_node_memcg_used_bp(
 	used_pages += lruvec_page_state(lruvec, NR_ACTIVE_FILE);
 	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
 
+	mem_cgroup_put(memcg);
+
 	si_meminfo_node(&i, goal->nid);
 	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 		numerator = used_pages;
-- 
2.47.3


