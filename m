Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78777CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 06:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 096996B00C9; Tue, 19 Aug 2025 02:19:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06E156B00CB; Tue, 19 Aug 2025 02:19:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5E76B00CD; Tue, 19 Aug 2025 02:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC01D6B00C9
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:19:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8E51116FF9
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:19:58 +0000 (UTC)
X-FDA: 83792506476.30.750DD93
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1E798140004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:19:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Yq/ughyr";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755584397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/BMrKpb1UjQjynPo9tmCvpTeCNNWudYsCjYT+dY4Qo=;
	b=AAXHYA5jK+gVZtPIjYbmlIoDdQJOxrerkYZ4Q3ol+uDBSQn7EGxcAwUJRRBnroweMIERn9
	mvKB5DH88T9xqHL1zwYze+o5SRnAQcicg6l26ggbZQoeXI4jyQAt8ki834tTlZHH/2GXQY
	pb7k5WQyjaDLpU22yjwwiUzHu2+J4Y4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Yq/ughyr";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755584397; a=rsa-sha256;
	cv=none;
	b=Hutuh8NfZvHg+U2tOfXbR1Dial7uWwMsy//B6qku/cSA29sH7gkYEpvewbgAb740aBIj6L
	jxsah/S9bzU4lpTO5fN7cz5xdb+Ey2TDG1/qwhzzZWOq/qJRkQFdozfl4XTrvzxDinVw9w
	vTZkH23Ad/JOHGW9zhnK7Dghcr+375s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 500CE5C5A22;
	Tue, 19 Aug 2025 06:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB88DC4CEF4;
	Tue, 19 Aug 2025 06:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755584396;
	bh=s5rBpCaCaXvNVfSMIqwRsPuPA1JvP0VWMtY/Ojlh4yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yq/ughyr6tIXr2dcVNliYIQNkgvzfkzwCxxgvwkWaJ2SvqQ2WrXwNFUArlRQd9QLj
	 N9Cp1e0ix+PyDfbD1RmowghW2mU3e1wpDFgwDrvjh1BdkIUFWHUN13symnQhwoQlDD
	 FWWIkVvquapndDNi+337iI7sX/DLOoifCwcK6gWHol1bNjv9ZV8a/+Y4wRqF8QNaZf
	 239tadlTXO4O7OqpGFtDXaxXSZf/7kEo9RTbuosIhMadm0N8TgTwlKVG7pqdYEMwtS
	 f2q8eJ/FtsfCgYYcO5PhiYvqaULsUH0LfY57ZwljWw5wX5rjIZBFH4ajnKJXCzGCbZ
	 mNvSOdgrL/UMg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 04/16] mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
Date: Mon, 18 Aug 2025 23:19:52 -0700
Message-Id: <20250819061952.39429-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250813050706.1564229-5-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E798140004
X-Stat-Signature: yojyuwhfxrbuh5aocn7d3mmxue8k4gdo
X-Rspam-User: 
X-HE-Tag: 1755584396-643628
X-HE-Meta: U2FsdGVkX1/it83UUboyAYK/q5735anPZVWq9i0oOAN5wHAEef99nRq022Qmn3rMrfdcO6Xtr72RRlB8RCCGE4164F3Gw7rxwGg2eJ38DiXZWfOceSPqqDQRDtazHh+ah5Jv3Vx1pmheYQD4A2ucawvZoCeqh/Xg7QRvu8BaCAaVbQhBsEbhJhxfrepVATOKReygp/OD8+fS1eFDLC8Nuyy+H3XkKzWeqTCaK4Of/zYuFsHTPSTjZxgTzohD9eWscyXVbx8bHBUl4y8sNX1I7UD8YAZcNOMidjPHMxZomk/F+9ANynz0gxnLlGVmVOgDiCNtGPhqcKruug+2GCUbnt387utSAWiNR3oaXKu5eVV5DvgP4S10Ohx85GSIRrEyrEV776RDNW75OhfLFoj/OgG+/oDC6UF09BpqQoVhCwpt4vqKQtc7DLHi4fKBqqyvuGUN0OjdcHeCYZlVyt4yqIrwLyOzrk2Yl9GZd/QLJflKSoPl136gwe4+g2yJmlfmfgsB608g/3j1E2672ZWmQVp0Kk6t6hmlfJDbLlu8Ylgaf0wqI5wj4g+ozuSYCzrGw+A64cdpwG6K44cFUZ1K2ov3X2weKbalVeyVWrde8F44lcmoNqnHOFDsS42O+JunAu68HtBsutvrZHyGLRBYcRKo/f8fdA2UNtN8046X/cGMpCB23Ty7xhVTJ/z1F5bxx8EgIA/RwwpTTluoWtiok70j58myoP9KsgA25RQzWBZ2Mye3EpnREbHiJKTgzbdnFAOYMhBmHk/oL3+eMSxqDsomvf7FBxi8sN7s7IXt9TyMEtzqXOaG7CqukF65j7DGoayXCLznqlLQB5JE9IxIAVGlJYIFDQ3LpZ7B9nvIm/TpeNqHYu5Hc4elxiCLjrVyEqwFhrxexm/MsX+H5D6auF8/S3MP78Zjh1162NLfXRfuHyMmkbF/FZ4/r0iInmQyUUFUB8inkCqymqpK46O
 PcFnNPY4
 Vii3WWKNKOIBb/ZiCA3hKwz1eAfA9RBPQBWFp5PfTDASjhx+jORW43PfnaS/LwUpgX/PA2IuOQf5wXwyLo6SSHPMn8I6vz4QQzmIk/RQzTyPCZlXJivPK0hNboebCtoB/CQeoSZKaBDSv0EICLph2JOL7c2hIk3L7v4bpSMwBoLuoVs/ZYe9rWqw1CvJpSV93TmygYKY5ZjgTMyMQWx1F9snCFH7q81/1TLOMBE8IcuphdHxUCFTN2IZFeGu+RyXv0dVnf46vc2BUN48=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Quanmin,

On Wed, 13 Aug 2025 13:06:54 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Add support of addr_unit for DAMOS_LRU_PRIO and DAMOS_LRU_DEPRIO action
> handling from the DAMOS operation implementation for the physical
> address space.

As I suggested on another reply[1], please squash attaching patch to this one
when you post next version of this series.

[1] https://lore.kernel.org/0001-mm-damon-paddr-set-DAMOS_PAGEOUT-stat-in-core-addres.patch

[...]


Thanks,
SJ

==== Attachment 0 (0001-mm-damon-paddr-set-DAMOS_LRU_-DE-PRIO-stat-in-core-a.patch) ====
From a05d13d152443f35b7a85e0bd5ccecf294b699c0 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 13 Aug 2025 21:26:48 -0700
Subject: [PATCH] mm/damon/paddr: set DAMOS_LRU_[DE]PRIO stat in core address
 unit

Operations layer should set DAMOS stat in core layer address unit, but
paddr is returning that for LRU_[DE]PRIO in paddr address unit.  Fix it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 6263dd58a2e7..ed71dd0bf80e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -198,8 +198,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 		struct damos *s, bool mark_accessed,
 		unsigned long *sz_filter_passed)
 {
-	phys_addr_t addr;
-	unsigned long applied = 0;
+	phys_addr_t addr, applied = 0;
 	struct folio *folio;
 
 	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
@@ -213,7 +212,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 
 		if (mark_accessed)
 			folio_mark_accessed(folio);
@@ -225,7 +224,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 		folio_put(folio);
 	}
 	s->last_applied = folio;
-	return applied * PAGE_SIZE;
+	return applied * PAGE_SIZE / addr_unit;
 }
 
 static unsigned long damon_pa_mark_accessed(struct damon_region *r,
-- 
2.39.5


