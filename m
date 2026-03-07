Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE56F55104
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 795E96B0093; Sat,  7 Mar 2026 14:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715CA6B0098; Sat,  7 Mar 2026 14:49:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49E5F6B0096; Sat,  7 Mar 2026 14:49:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8EE6B0092
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:49:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC18F5690E
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:49:25 +0000 (UTC)
X-FDA: 84520306290.21.7C631E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5EE74C0007
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:49:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BEJvl+YA;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772912964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7fNYNdvNP2PcUOfrmeC8N1gWWQQifP877TzusDfXqE=;
	b=WHLO16c2oQgR8g3uX21Ro106wUn+aye6AmvW31SubdI9dTmp4IGKVmkIyagcW5fo72QC4Z
	CWBINQovH1nfi3fLCBvSKOOfE/frSwT4vzZN5UT2OvcYFUXJas5ROvDM/X+eJ01ZO1VuAw
	l3crXvH1SR+9T6yIGZk2tlfvwKLgQAw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BEJvl+YA;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772912964; a=rsa-sha256;
	cv=none;
	b=AONcfQnGycBp3fjzeaGJtcuvLptQkU+ZIEbLthzRkJbDDpL8vzukoUNvmRXZO8IWrxNTH0
	TyztWDkjA2abTG+rhXZh4gbd3dD8MTAmHxRb/sLuy5EmyZ5IUQ2tzbpTG0fmHL7eVmmB5s
	k9odEaFI6onzDHlwlEcBBoCAYpYnXbs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D8D13600B0;
	Sat,  7 Mar 2026 19:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778F0C2BCB1;
	Sat,  7 Mar 2026 19:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772912963;
	bh=Za6lpJwLEosOpDlDvwmJC/zKpW4MWLYWLFZqfZ7RdwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEJvl+YAbT9PXtUETsi60jcymWiXmgJCPTrhnzWxWSUvDSfTBvVLKFqnSugR1lo0J
	 rOenWaRUaGt7+2tbhuj0RZEyRWW07hUWI+5B9rvZIsh8BN5V8eWZ1mva31S2OEHyn6
	 iQ27N+x8TbtOSdBuPOqhoktX6nl54MzND32DrQqht5jCunuAYhYHU0/EwvSO5MCYIY
	 EMrb25eq3ER+ik+BHGSFW2J/gWAXu/lqPxiU82etKjjbMPNljoNqMwnJQHojEFByA7
	 /znw6AgT8r5mAzZSDUFlNxfTK6M5a5reW1IHQVHd7LwvbO0oIzZ7B4KKlbSHGRpEsn
	 AkGpuQo3l/FrQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] mm/damon/core: use time_after_eq() in kdamond_fn()
Date: Sat,  7 Mar 2026 11:49:14 -0800
Message-ID: <20260307194915.203169-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260307194915.203169-1-sj@kernel.org>
References: <20260307194915.203169-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5EE74C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: p9wp7uhc8dc8tjqbxow6hruoy46as1am
X-Rspam-User: 
X-HE-Tag: 1772912964-394674
X-HE-Meta: U2FsdGVkX18p7AdhNUR203AKbCI9G9PQE6eIKbvTnufqVPUpYGgBjgcX+sEBJxk5sUH6kv0Be8qLrkLWPjLGf8QOIvAKsRdMUg+v7jSXQQsRWIF3ThQv8c6Ib9T2d9PvsRTeODr0G7cSG7UZLhxSt72C/B3P6P8lIhH5hxnU3vKcmRUUsQYmhdSjZTwuAcAZt+JjFuSxddQ3gbU0AuceHxMZXN1e2DNjDUMU1gs8p79G+xkSrX//I12B0nTXahNdS6eSWJuYDKSKn7EtXd8vtfMb/gXF4+BeITX/V7Ra6hwS2TfsqHALG5v0tmmaQXUmLMn1/x6BDryd4aoG3nkaK60qFGLDU8lLbHHIHWDYqKt55o0rZYOpdhcB467DYdJ09l1csYMrPq7YpoVoAW6J99w55uXFL6ESb0iOFnVYbc8LAjEosydqjGXjy31MJZHgKLrepa8sW2Cxv9QK2jDIoyB2sOMjk9aGCVxCKHA/CpcUyO8jt6H35+qOoOrSjmnTjShCtyfHHSy4W9VgcitDWYtSWQnnWXXeQoGzUbTfUp3gSe9FdI17OVkUpq4ePS+KlfYtvaYJnrvQDbimkwAcKvpbQmhswieq31MvSY2/CrcDYRH5zfaxJZ1gwIArTOutNNlAhdACaFz4gdtsoQFHp5vhQSV3cCIv4c9gPSdJlDoNJnZ24GCL3vmb1LCKf+yp2CqywMoV8D5jRREAogU6zHDjiNH6w/cyCKzW5IPSLl18XtUyyd5zF54w94ibUBJSK/lqIplrsdJ8/B8rUYff4foIBy4vBNXUg48P4fVYuZ2YzjEQlI7As5HzGsoGJU9sYifR2fw2gAbckJQqKj6tf00ClaNmkcqOIZwZ11hCaN+8cskFfuC8wXCJyZEBVvlsygL28bOiwBQFtny1XBP0+/huLHUrNCeTLViGt7QTT4eJH8xEJO0uR1CctVi7v3RBMya1kRzyr0Y4lkezBEk
 VuqDlfon
 6e7t1Msraz3peC4ZjD8ad6LuZWwrD0LxGNhqPH+0rz1JZrBYX4vXBHphkrBW4XH+vfW6fRuQJwB4Kn3xRLB4kwLXdPly4tadp/gYBiOU7FQLTxaxTtMqM5dS8a0K7zJCK1Vd5Tumz6M8KHklu2QRFnjMIIqzHC1R85Kcqr58l/wNLaR1blrHYhOXtv62BdW+upFTyNKLCxWItkJjbQeOdoEJuwn/nD3wrqJIVlaQ8K7+YxSn7GhLRm/3S8jwQWB9dTq3mAhaLvf+h0KT65DLm6jT5xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_ctx->passed_sample_intervals and damon_ctx->next_*_sis are
unsigned long.  Those are compared in kdamond_fn() using normal
comparison operators.  It is unsafe from overflow.  Use time_after_eq(),
which is safe from overflows when correctly used, instead.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4ede733a94cc0..cd2d7a8e3fe92 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2915,7 +2915,8 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 
-		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
+		if (time_after_eq(ctx->passed_sample_intervals,
+					next_aggregation_sis)) {
 			kdamond_merge_regions(ctx,
 					max_nr_accesses / 10,
 					sz_limit);
@@ -2935,10 +2936,12 @@ static int kdamond_fn(void *data)
 
 		sample_interval = ctx->attrs.sample_interval ?
 			ctx->attrs.sample_interval : 1;
-		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
+		if (time_after_eq(ctx->passed_sample_intervals,
+					next_aggregation_sis)) {
 			if (ctx->attrs.intervals_goal.aggrs &&
-					ctx->passed_sample_intervals >=
-					ctx->next_intervals_tune_sis) {
+					time_after_eq(
+						ctx->passed_sample_intervals,
+						ctx->next_intervals_tune_sis)) {
 				/*
 				 * ctx->next_aggregation_sis might be updated
 				 * from kdamond_call().  In the case,
@@ -2972,7 +2975,8 @@ static int kdamond_fn(void *data)
 			kdamond_split_regions(ctx);
 		}
 
-		if (ctx->passed_sample_intervals >= next_ops_update_sis) {
+		if (time_after_eq(ctx->passed_sample_intervals,
+					next_ops_update_sis)) {
 			ctx->next_ops_update_sis = next_ops_update_sis +
 				ctx->attrs.ops_update_interval /
 				sample_interval;
-- 
2.47.3

