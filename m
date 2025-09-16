Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F815CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 18:31:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280408E0010; Tue, 16 Sep 2025 14:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20A168E0001; Tue, 16 Sep 2025 14:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083B28E0010; Tue, 16 Sep 2025 14:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E15028E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:31:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 987D357855
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:31:35 +0000 (UTC)
X-FDA: 83895956550.16.53339F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E653D8001A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:31:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dO9D/T+U";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758047494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ng6LVEHSPB3L3UtYO8HDzOniP8/TCGttBdeT0UayR8E=;
	b=d55TmqUZ+WwBuu4ssZK5gtxLwiRlnVzbPGKUjys71dFmIs9m8c5qOX75slHgLAHP1MdF4D
	yjaRTCyYm3xoBOs6ujieLNojOR/tfE47z5njZ7whDb++xr4k0wGJ8N9ZpUhLMo0wASeklW
	i9g4h0U15DmX2rOTLVjXWfOs3PPJLSM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dO9D/T+U";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758047494; a=rsa-sha256;
	cv=none;
	b=wzn6fBDfN6pBLXbinz+JDM+kQ7vnhW7En8PTjIDGV6Jl23PjnZ6n1+RuivFeGc3i7Kx7GL
	6B9rL0xuMmYetHUF9sjtG4AJm0oVqCcXXpd/+vMCbOzIyXLO+pI+bmQ516sWDrEX0+7ZRG
	ww1/i2TDztrr19qKj84OS1lCxFBUv6I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C34144B94;
	Tue, 16 Sep 2025 18:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B657BC4CEF7;
	Tue, 16 Sep 2025 18:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758047492;
	bh=7h0SXCHIrLtkJvqCMts1fDwLssCc9jFcz1TwtN1yTk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dO9D/T+U4fIXZoWGmqq+0hnaP8FRrEocTXAw1wplxnxtODrrLMbq8X1Vo7D+lQI+3
	 1da6zj9EYZ1qZBXD0o6QzbrW6opZDO3SXX45YZxOx/WilrvFKiknqBmue7zKZN8+jq
	 7ALnwCVH8qH8Sqz3J0eI8mbBKPXxM+MdGK0x0SqvIl9Lpo36pF3BG6EmYz+IVMsmtd
	 uLbJG0ue1r/EVSEuiMbhf3YI/rF/aBBv9ArHcsoO9ReUl2XHrAr5LN+fhUyJ1r3sQu
	 TlLrPXWzfY+VYeTCsd16jZsv7YiTnteGkLmGTRbcVsmeCxmrnODNYwz0eaTAvInpC/
	 rAjfH+zMNu/1g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] mm/damon/stat: expose negative idle time
Date: Tue, 16 Sep 2025 11:31:27 -0700
Message-Id: <20250916183127.65708-3-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916183127.65708-1-sj@kernel.org>
References: <20250916183127.65708-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E653D8001A
X-Stat-Signature: q75ks1dmycfo139cubt1dqpiw35whzsm
X-HE-Tag: 1758047493-356011
X-HE-Meta: U2FsdGVkX19ZKuyxZHcu/hDBUBhc6UX1PqGNCPkFg7IPXHYVT1GBOQnfVcfelJoGPRQH+avx+9IWgT5fpEhyM80u2OfbMor/ubEfRancgoQ+o0He/IBgULTnHJ5mlRdrAbnXs9N10Vxnp/kTWtJARDTYtHKEpM+sC0DN7xkrc0xU9v+zO5EPMTtgvOZCyy/p5YBPTcAChW+LUlNtxeHSxbiommSzCkOdHBN+geEgbXTFxBgGtjzONH6cEnI3t1d1yhYfcuDongBzSUTa24BeAdIf6LvTGhmKnpb2N36i1GkxILuV6iewcFBZyT+4ipg6upnvyJ6U+7UhDD1cdyPvktzDeRt0tDDP9kiXOJRenNkYL4jfWv9re7s2YtIVjc8uJH05KmArbhNfqOVzkcgbCZ5FnbeoFExFmoxgt8nsxoGe0W7fk+37YkfRJvxbO47xutpQTnVdiEueXUxkeI5BXIbECKWzVFtdiFpbsH3YH1PQWe5oGOrBH0oOTFVTNzikIerxarC6S8Pqp+v6Lq6Xsbh9XXwC4J0JtVExurPVP3+n9mSIiYBpDubjCIEkPjGHeV/MX2/I6eJsxdtoFTldMDihNzJb7mZUicAo1WGuWUQ3oo9wuYXGJ+a68fAZ4l9LCWd48ub+YkzuJpFdjpF0HqpZHBqjDTjXs0s4l2IYN2Y+vOK4DNnEAn+rcC5gc86J+rTioC0azhpU/ePGfXyI0ScNH7mtb3ud+slxz8lktY2uFD3PaKJ9d3I4dc/CYVJXYtPvXz1eeKy1GZUeGcHykLBNWxCo50dnyYcnyB/rgx5kzqODzi7arzUJppx2EUK3I6yrVshtryvOrxnBbqY/pKmCtjm7eujiq9LJnQqQsWJCnUl68DVz9OEEtBCyN1ijDmInCO8tba8SkF+7aEdx+FfWw44cm4q+GRQH3TP4WIbbtQc294kNAjGjSBwaAomFO/G58rmv9OBfoWEN9kq
 /13sRp8S
 C0Rk8AvBj4JBKTTCBmuwAvpa1XwF9s3JSUs6Q0S6jdEWWvPqEhKBT3FQdPWFNDBNGKFmQaLEOtm9d9fKa7VdG4JB3nZco6qkPO15Z3MUQfDxfXucAcyt9GWLBc8rjTKgJmocgn9hAIjNBgUsoGHyz3ahv6490k+BTTOuaZm3odhkqNhgrv+xKKpQkQn5YpipraWKFoX4XsbgnY+JYEgwZKL3QQLWi6WLPe8HrMQ4nlhq3wkQzE2uZIBovJapYwJE5ZFVWl/Mg/jHjBcY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT calculates the idle time of a region using the region's age
if the region's nr_accesses is zero.  If the nr_accesses value is
non-zero (positive), the idle time of the region becomes zero.

This means the users cannot know how warm and hot data is distributed,
using DAMON_STAT's memory_idle_ms_percentiles output.  The other stat,
namely estimated_memory_bandwidth, can help understanding how the
overall access temperature of the system is, but it is still very rough
information.  On production systems, actually, a significant portion of
the system memory is observed with zero idle time, and we cannot break
it down based on its internal hotness distribution.

Define the idle time of the region using its age, similar to those
having zero nr_accesses, but multiples '-1' to distinguish it.  And
expose that using the same parameter interface,
memory_idle_ms_percentiles.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 1a8465abef4a..d8010968bbed 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -34,8 +34,8 @@ module_param(estimated_memory_bandwidth, ulong, 0400);
 MODULE_PARM_DESC(estimated_memory_bandwidth,
 		"Estimated memory bandwidth usage in bytes per second");
 
-static unsigned long memory_idle_ms_percentiles[101] __read_mostly = {0,};
-module_param_array(memory_idle_ms_percentiles, ulong, NULL, 0400);
+static long memory_idle_ms_percentiles[101] __read_mostly = {0,};
+module_param_array(memory_idle_ms_percentiles, long, NULL, 0400);
 MODULE_PARM_DESC(memory_idle_ms_percentiles,
 		"Memory idle time percentiles in milliseconds");
 
@@ -61,10 +61,10 @@ static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
 		MSEC_PER_SEC / c->attrs.aggr_interval;
 }
 
-static unsigned int damon_stat_idletime(const struct damon_region *r)
+static int damon_stat_idletime(const struct damon_region *r)
 {
 	if (r->nr_accesses)
-		return 0;
+		return -1 * (r->age + 1);
 	return r->age + 1;
 }
 
@@ -122,7 +122,7 @@ static void damon_stat_set_idletime_percentiles(struct damon_ctx *c)
 		while (next_percentile <= accounted_bytes * 100 / total_sz)
 			memory_idle_ms_percentiles[next_percentile++] =
 				damon_stat_idletime(region) *
-				c->attrs.aggr_interval / USEC_PER_MSEC;
+				(long)c->attrs.aggr_interval / USEC_PER_MSEC;
 	}
 	kfree(sorted_regions);
 }
-- 
2.39.5

