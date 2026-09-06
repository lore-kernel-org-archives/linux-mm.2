Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B191CC79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 18:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17DE86B008A; Sun,  6 Sep 2026 14:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156786B0092; Sun,  6 Sep 2026 14:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0919C6B0095; Sun,  6 Sep 2026 14:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D651A6B008A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:44:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7AF528059C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:44:27 +0000 (UTC)
X-FDA: 85184212974.08.67761A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id DE930160006
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:44:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K77of3bg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788720265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fn4wlsJY/z4XEr5TrccoXyN8K/aFxzX6vlLK3FGYk8U=;
	b=ZD1/+KJ9MhOj2XSEbjJZj4wHQ3yo8SkgCyyuaSrllzuJWkdWk0Qv4qcGwtgehfuMIeBS4t
	paOoTj4x4VolxONJ9SdlbBwicjWdsxjtdVI0zzMEkxKHLKJZ4rWQ/8A2ZXDZM7V9orOxRV
	3SVdPIC5s55iNtXugoO7B1+bZ5E5vq4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K77of3bg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788720265;
	b=S4HYlx8K94Ymr1tAmuG6bC4JTCUbI9lhE10B7zGkZVobHYQLxA3GRD+TBaISQa24rr0HSQ
	nS5IEG06Q9llrRHMLKn2ojwms+jdoQlckHV5GY+nJ48kvkmb7O7RcL3axTvfyLvZaiTufQ
	IRvDw2oH5e8J2QFaOjmcRAMgCWZFRSs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DE8160A6F;
	Sun,  6 Sep 2026 18:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E271F00A3F;
	Sun,  6 Sep 2026 18:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788720265;
	bh=Fn4wlsJY/z4XEr5TrccoXyN8K/aFxzX6vlLK3FGYk8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K77of3bgH2ETgg79GvBfvqsk1Fhipjvt+l4yf40emKaiJHOInR8qE1A6kKWuky9J0
	 aWM/HflKvFn8nFjOEnA/ewjjn0rhytHaFhF+tviRvMjr9zV34lfHSdiXfco1qXePhL
	 le3nhBAwGjJhrEoAylAN3EyJUp8F5UlDsXejZznILXL/tGfyomMXUVmbZhComT+Dk3
	 1PMVQNlntAVu2ZxDh0O3nHGd+jOJFaMttIwc+BAa9r8HL/RtFOJmOOpCgqXYpjzHq5
	 aF86moZ1oX9KUG3s+X82uojElKLZkzJh/sP+yoNLgNf6zpeZMWXf6BAkmsjL71gD5Z
	 4S6pRmNd5nw4A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/5] mm/damon/paddr: move probe filter handling to ops-common
Date: Sun,  6 Sep 2026 11:44:12 -0700
Message-ID: <20260906184417.96621-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906184417.96621-1-sj@kernel.org>
References: <20260906184417.96621-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fap53ukpnjpmgewm3izac5btxim4pf7z
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE930160006
X-Rspam-User: 
X-HE-Tag: 1788720265-748661
X-HE-Meta: U2FsdGVkX186mW88H23D5sijW915sBqHh8I8S1XInQ1EGlAzwt43N120RZzLduNk1d6EPWqgso5E+7jxi8oYKB5EP4bvT8O6KqLnxecqQtVIUP3FPyQwmcMSsmLc2lIBbY37BunadudVbFu5JKKTobS7HZgU+BAEFW93n0VMdybvaiAe8eCaTFa2iBLK77gITn0Hg7FJmpNaN3Hoh3r8TBlHlLjwgbX2Pkg5ODkPgZDXxOH/N8gROFn2HowYAOt/aB/WEY3EJLx1PckuYoL5KAlRMgaX/kEy9swlwbBQAzO/tc9bEv6o2UzJfm15S2yFeNTxAFX1yVoWLQQHy/T3WBD0yyeLjvv8mZ6O0NcpBAJhyhLKjTZIc4X8dv/RchSwdtsMOEKm54kMs51gqXxHHRRrlfO/Xun+80NPsmnrg7eJM+aCRwBb0s5lfimm4Ay1r1YIbv8LpIFumYw9gbYNdkcFQKz1b418J6brR6jTZAbnk8ClORjIVDLw2lfpPDEUrkZ9SYWeX2JjlsuM9ovUB5qgTfcEzyaU0Gbdi5cNBzZTv0tracXRpvkosMd4lGfqrtHTLI09b1FACNfk+Gm3WKLgEv4WDkVlZ2ejI8CHmn7dG/r1B9txbDHyGHA7qrlcQ4MHe+kZKGuzR28U1DV7fTI2ULBAqgGFhCN3HpDHIvjJ2TU3BMybSHV0Uq949wP2GW5w6MYDQpkg1/eKjxClajV3BSydPsxdgCTCjLpwFt3Ua+2tWtw0tZ5Ug2azYLxcBuodg9PBhfNHIfbUaEjLD12o/9v/IPHklAbOkMYho6CpoHdHdH6Kx1kd09Mt4PtNZa2ZjzrZKn7/dYuNaY2v+rAZeXSve0C1oJjO4HgSYd6J6jzge2cdhGuUBtEkdqixpiRnJFvK1ghXf/J+Vc8FoR7DRNWPHJAo0SIiGv3nzxToO3HOjkcoW15tlhY8+r3usJdwV4KrrePQePOBbjD
 zqU49jA1
 bjJQikt9To5g9+m0wGKxICZP+XnFK+xIEqrigOLgq3ZUs7U2AKcM1sCGuXnYrBV//3GTtsK16Bt8ACCr8Mao22BZ38XYiAJ3xeIpAEHOMl8bRYT/XeWn0dV2exi7HhRVlQcp7XMOqlpO6K7f37dBKDtICgW6HS4Yiz5GyJygXcq+DUTeZyiokJKwAMpk67iZxMSB67Ph+PzVzAQih4gCRRs91K/nReWjjffkXTR9zsUXoGqo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Probe filter matching logic for anon and memcg type filters in DAMON's
physical address space operation set (paddr) can be reused by virtual
address space operation set (vaddr) in future.  Prepare the future by
moving the code to ops-common.c

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 32 ++++++++++++++++++++++++++++++++
 mm/damon/ops-common.h |  2 ++
 mm/damon/paddr.c      | 23 +----------------------
 3 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 441d45679eaf2..76b663a4be610 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -524,3 +524,35 @@ bool damos_ops_has_filter(struct damos *s)
 		return true;
 	return false;
 }
+
+bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio)
+{
+	bool matched = false;
+	struct mem_cgroup *memcg;
+
+	switch (filter->type) {
+	case DAMON_FILTER_TYPE_ANON:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		matched = folio_test_anon(folio);
+		break;
+	case DAMON_FILTER_TYPE_MEMCG:
+		if (!folio) {
+			matched = false;
+			break;
+		}
+		rcu_read_lock();
+		memcg = folio_memcg_check(folio);
+		if (!memcg)
+			matched = false;
+		else
+			matched = filter->memcg_id == mem_cgroup_id(memcg);
+		rcu_read_unlock();
+		break;
+	default:
+		break;
+	}
+	return matched == filter->matching;
+}
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index 172f0f17c4a84..ee27058251005 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -31,3 +31,5 @@ bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio);
 unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
 
 bool damos_ops_has_filter(struct damos *s);
+
+bool damon_ops_filter_match(struct damon_filter *filter, struct folio *folio);
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index d2173a448d0b0..d7c81829445ba 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -143,29 +143,8 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 		struct folio *folio)
 {
 	bool matched = false;
-	struct mem_cgroup *memcg;
 
 	switch (filter->type) {
-	case DAMON_FILTER_TYPE_ANON:
-		if (!folio) {
-			matched = false;
-			break;
-		}
-		matched = folio_test_anon(folio);
-		break;
-	case DAMON_FILTER_TYPE_MEMCG:
-		if (!folio) {
-			matched = false;
-			break;
-		}
-		rcu_read_lock();
-		memcg = folio_memcg_check(folio);
-		if (!memcg)
-			matched = false;
-		else
-			matched = filter->memcg_id == mem_cgroup_id(memcg);
-		rcu_read_unlock();
-		break;
 	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
 		if (!folio)
 			matched = false;
@@ -173,7 +152,7 @@ static bool damon_pa_filter_match(struct damon_filter *filter,
 			matched = damon_folio_young(folio);
 		break;
 	default:
-		break;
+		return damon_ops_filter_match(filter, folio);
 	}
 	return matched == filter->matching;
 }
-- 
2.47.3

