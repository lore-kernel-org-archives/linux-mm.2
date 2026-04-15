Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5BDFF9D0F6
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 01:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3D5E6B0096; Tue, 14 Apr 2026 21:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F7D6B009B; Tue, 14 Apr 2026 21:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9673C6B0099; Tue, 14 Apr 2026 21:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4A36B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:21:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3086013A743
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:21:00 +0000 (UTC)
X-FDA: 84659036280.06.EDC80F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 77A711C0008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:20:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h4YEOuW3;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776216058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PKHojYGrHeCJ1d3lJ+9xq+T4/zBYb1diwQrR7/XEE4M=;
	b=l5ovPGEW/ijC7eJYAmJ9KFB2l2XQBVslPioMs4Lfo16Eq3gNUy1VCI+LTjHnFREN4Czxaf
	4QT/CzweGhOWHwKq4Rt5/b3vSN/U1+kX5mXVJA0OPNWYdQh3eThv3hjMMApLJQeRnqtjJb
	T1CCzd71Z1OoNNqADg+upUyQaXZ4vYc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h4YEOuW3;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776216058; a=rsa-sha256;
	cv=none;
	b=GizPkeUn6F/KPRBKkVgCpr+peE33iBrem2gdaQWrRdw0H4gfaZRC3O+Qmcgh6gRISDya7u
	Gc1VbqDT60S8HbKWmS769tA1HeN4QfzVhSlQi7bCY3y5LwqHryUEZn2eBkS5OXEz7mhQEd
	ofdOrDWQaJBlwiqF90KvHnI0PhLuiZk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 701FC44468;
	Wed, 15 Apr 2026 01:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AA8C2BCB6;
	Wed, 15 Apr 2026 01:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776216057;
	bh=jusaHabcDbQG2msd5Ko6TcArzh+c8u/ACR+D/XNuFA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4YEOuW3v6TayFitmmPN1KXvhRyqJNLlBeiZr6uJv0SIZTjQXNY9G+5hS/pPRT/Pf
	 032qZ9MuhlNV8BEM+oO3RGijzwIVVvhxeWRWHe/uTBFAP2ENXqBNfhSOD+s/8pjVcx
	 ibUlN43hxTJ0pME0M2I8qZ1RCIdfDa0YJ8m1+MgjhUkStI1nNE0PFEkqE06rUJ/Iuf
	 Omndah1zQpByfZBAIsRcajFnuZyzxCtQPjYlcgPA1PZIwia2vV9gptv4NRTtgnzKLN
	 m9a/8Kz3KAEM9gVVQXBJwc2laVm/hbB24KVlHdM+t/lksqNaLcYLXQETCgF9aSZdcy
	 DVtudT8vLYUbA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/7] mm/damon/reclaim: cover all system rams
Date: Tue, 14 Apr 2026 18:20:30 -0700
Message-ID: <20260415012048.76508-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415012048.76508-1-sj@kernel.org>
References: <20260415012048.76508-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 77A711C0008
X-Stat-Signature: farcag7nfeqk7htwnx13rggrfqb59cgr
X-Rspamd-Server: rspam06
X-HE-Tag: 1776216058-932527
X-HE-Meta: U2FsdGVkX1+8RqSSy86iyYiO/V+yID2m53UCrCqFxxHMuR6pcb8hzCJ1DiH9TfL4JiQI1cYfWL5TRjarg13i6PO4ggAYr6c3btAdNyigF7Fd1HIxp91aKEY4Lkcd+nFMOArI2V0abbMjNV270Ao8IBcv3A6OEPHYaQPvL66lP5BLK+LL8pyKR5KTslakwZRvE/YCoXYnGHAXypUhsZy4BBDL9x+tpSGNcL9NIt+ihzRB7AAVjBlBnsUM/rX5N6FQXafLbrd1nDItqZhuD5xpgEIzbmFGcjRWOzIsNLTC05/+w4uwpsgVfpkZsOw0tzV5xNOQ5JDTSxqpM2widqUqpUV+1Nx96BNBEjmcuz9fPjIzpAUAq2B75pToUSffxTsqubHNCRjuaXuDLhB9pQXa8KAAH0us1LeOOi1SHGQ6RleQ2yHmmtlpmOq4omZusCc0+tH0HufOdi6pDw3uvJ4b+Svit4gUjdifr9g2i279A241WbMiWBvNFhi4eu6jpF5rl/b2L1Ec4ThaiitZoWwIIqlc0ROSNcgF5YpruZFNB5MucGAmz2gR4wUSngD/kugKJfwwaQGnNueRAfWccwJpB4ldo0f5nGbjtpHzzim0d+65u2oME1gu7wYZsFem7Yh6GOAKV9ndmcJIBXlDw0vX5+H/nleYHiztNsReR7lh4u8kM07Dq5wwIMQtBRszGKlzeNUdAt9DHizqBI8tXOv91PWVLZPCsLV5opUZJ5Q2lMyNw8Ory2tHJVG0YuKyj8qZa6Cw/5FmpsMBBoE5gi7i8OFV2G3PPYALr3NfUwIxKs6vjpkrvL3aBBrXwZdzj1U7anwVeln4fMaO0LScnl0SHQBWILgcgLEyUB1pdi2PgVTkex5sAPdLoOJvhzUXLWf4lE/w2aGah2tfHDU+7UZrCazBoMJmUChy+6PGJvZ636JfzAZ05jg0uGxXa84CFbKogvkOA4XQAxH2QnHIpJI
 lwJuxfmI
 wCWNUfUG0L6xiazMeqky2Y4H6nuf8ULQAgrES1CwS6RwUFHVdxHvgH/vM7TGvoxzW22ztU8yR9CUnLrOgBNfAgArZfe1lPPbfKXEq1FBpmQyNMg+UgnI5ROR7ClaIejtGSt/8+3STqQPARRQL6pVlF2Wa+d+lJ0/R7n5wHB61x3Lj7ZqUXTNuRV3E/Med2LT76/iS7E0ti5yld/PZf00BnmckJ1Wj1qgdpEhc+om4XtAnXKY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM allows users to set the physical address range to monitor
and do the work on.  When users don't explicitly set the range, the
biggest System RAM resource of the system is selected as the monitoring
target address range.  The intention was to reduce the overhead from
monitoring non-System RAM areas because monitoring of non-System RAM may
be meaningless.  However, because of the sampling based access check and
adaptive regions adjustment, the overhead should be negligible.  It
makes more sense to just cover all system rams of the system.  Do so.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 89998d28628c4..ecfc6b58d07d2 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -127,7 +127,8 @@ DEFINE_DAMON_MODULES_MON_ATTRS_PARAMS(damon_reclaim_mon_attrs);
  * Start of the target memory region in physical address.
  *
  * The start physical address of memory region that DAMON_RECLAIM will do work
- * against.  By default, biggest System RAM is used as the region.
+ * against.  By default, the system's entire physical memory is used as the
+ * region.
  */
 static unsigned long monitor_region_start __read_mostly;
 module_param(monitor_region_start, ulong, 0600);
@@ -136,7 +137,8 @@ module_param(monitor_region_start, ulong, 0600);
  * End of the target memory region in physical address.
  *
  * The end physical address of memory region that DAMON_RECLAIM will do work
- * against.  By default, biggest System RAM is used as the region.
+ * against.  By default, the system's entire physical memory is used as the
+ * region.
  */
 static unsigned long monitor_region_end __read_mostly;
 module_param(monitor_region_end, ulong, 0600);
@@ -264,11 +266,9 @@ static int damon_reclaim_apply_parameters(void)
 		damos_add_filter(scheme, filter);
 	}
 
-	err = damon_set_region_biggest_system_ram_default(param_target,
-					&monitor_region_start,
-					&monitor_region_end,
-					param_ctx->addr_unit,
-					param_ctx->min_region_sz);
+	err = damon_set_region_system_rams_default(param_target,
+			&monitor_region_start, &monitor_region_end,
+			param_ctx->addr_unit, param_ctx->min_region_sz);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
-- 
2.47.3

