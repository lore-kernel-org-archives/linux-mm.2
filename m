Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE943C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345EB6B00A2; Wed,  9 Sep 2026 10:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2096B00A6; Wed,  9 Sep 2026 10:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17FF6B00A5; Wed,  9 Sep 2026 10:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A99D96B00A2
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:04:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1C2DA0254
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:04:18 +0000 (UTC)
X-FDA: 85194393396.19.D35A75C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5F9C14000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:04:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZirFfFOi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962657;
	b=6LfkSoA7xgqEPQBla3DJXFzsRvoJWKQEw1PMHWexZ3cGYJwxrXerImZHgy0M8vPYU3Fo6Z
	Se8TgF6OE3YnxqSvgqqpYi5mHo9bdu6pXZFssR9dv2W9zNCbBB4fhKsukLxZ11nLT/eq7M
	z2B/VN65uTYWnGH3IgMLZxOO2taqXDE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZirFfFOi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/q4lRoCEmtfAN8WJows66A5UoAjh8q66hyUmXRAz+Cg=;
	b=pR2E9lx5otmNJEdHIUJC2EFUJiBrxFiHx/XoBcJvXYxnRVQYXU0QhEI2wca7XHZWalWcnc
	AYe4N/xZB/Fjeg4Diqr1zaKOy7I1cbSqUjntVYBmj+k37+3Hm7ZGDYci1os9E4V3XvMXnl
	vRSM2EwcHqAgbrHwnfL4/tWsC1LCqNs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA9A160216;
	Wed,  9 Sep 2026 14:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AFB1F00A3F;
	Wed,  9 Sep 2026 14:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788962656;
	bh=/q4lRoCEmtfAN8WJows66A5UoAjh8q66hyUmXRAz+Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZirFfFOiBYwMdynaPn83142DNnMx1cuqIsMzSc0P2ONtSNMa4vl2Ewt3lij1t26/m
	 ZE7+4PClUCLBsuGhidUxKcJz6qTgaL1pU0aLttA9zIY1d3ptddWB5qQKYSz7euuGfL
	 ZprN3LznRcQvT0+HIy5gRQPmKGxwoJVb+jesgW5imusIvql9JF7Wrh2ywlbl3OouRf
	 2n5BCj+AyZT54O7KcTzXP+sgpd/8+2zSn01srWSRU1q26dUqIdDsGPL6idcHkDGbOB
	 qmzBMbNGSvyoyp45XZ4ARSgCPrdhM0AV47xxrNSKfP/rrpXbIulO2ukV+UDQifcc30
	 In3oDeyosUN1Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH REPOST 2/5] mm/damon/paddr: move probe filter handling to ops-common
Date: Wed,  9 Sep 2026 07:04:04 -0700
Message-ID: <20260909140408.104699-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260909140408.104699-1-sj@kernel.org>
References: <20260909140408.104699-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5F9C14000C
X-Stat-Signature: ensxo45drmkqwsbahxhrzegb1o5e5tmh
X-HE-Tag: 1788962657-448013
X-HE-Meta: U2FsdGVkX18tVc/Mx1FJ0kP307WdGQvTxWDNh7gPZpn4lUdRIdY2CJ0xj8FORMvFE5xnIBEfApz2LZHcVMpOQAic8osHnznXzlRjfiEC2rgGolNsPC5/HHahGb7AbLS20ImB2IG0DgMfRDvSIVqdyt8jV6d5ref5oE+EPAiJnl2aM2XYtpsXwId3V2g7dZqN7cevwuT/G2Q2EHUkd61ReEBSIM0ZKUkYsNObaM8vlmGLlkJE2yBjqoCaM5iD9RqmTI2poDkg3bTamJOw8d4HnFK0f156EfRRVl7fd9TuV0rCI1i48SAJ/QATwPaE1jYH7W/FXU8H9cBzCxWwU2uBWrbkyTS3qwoKvq8H3HBAMtsuqJboLV3+rt56LANsORTV5FLcHa6WW7TlH8fiBDoPHmTg4JN5u3ISEqZJNIT/jawE/K7Q7Ma9svP/qiKcLHw1/jq3EJi6qSnFL9paFW6ZDEu0T7+M7PRLANL3JwR1P8wiabeH9htjxG69M6JtAG54lo3NwiaVU22zNDA0HiPo7NVENRlZwSMb8tyMOIBKSqACp7+r5dnhxzj/EVjRCQ7y/XosCR44TwVJ8FI5GnEDkc6jvKLoc+gnCWK0d4S24MR7Pdfqh0uDxVDOgOC8302PjA37jVhDTdrd85MTBp314HhR/Ln9746bGCQS8JHhPDjmsyNa41pK0QZ+i46hehMI3JvlVs9zjIkNqUtcRwvoqTDhhDXdIw+6gpvmtR+cMe2eLUn4rsQliXYpXJ+eYr1TXOqj1M/OamJ5zqDKtX00+9h71vuZwJTViGw+xCBzYewxSv5taeWixlOzg8qucuOc79nlE7VcddyTpmptrZqGn06p+nSy5S+mW3hXNtUKiPh0d8bhzcY+WwWLILFu3/E6tqCm1F5HK01TU4R286imKKd0cDjYK6Rwj55qHmxCFPV7gfg/mn4tojmpkNG0tDr+j96uN2utmkkRqI+Yh9F
 9LLjAwi+
 RMNq5397oLurVR6Ua0F9GOd8HXSgg+kLDxXE8/t3dg43AdHtj91r044PyhiIMx6k1J88Afcy7OwBkZNlVOqp5ZTrMn2sR33aqN4//h176ZT7+URZ72oWi8VSf+0EOwZBbFV6SC/s8ytIK45JXv6nSdCj4Su6dLrcEURpZt/dfKNa0OX1NXZXvDOOB9BQVXwXXmiM1TO6CDswlpV0p/9MoKzAz1OyPI72x5zmj9qkyPRJ/SZw=
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
index acf8f216c51cc..c36cc39cd2c70 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -531,3 +531,35 @@ bool damos_ops_has_filter(struct damos *s)
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

