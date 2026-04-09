Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E0D3F31E21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835C76B0095; Thu,  9 Apr 2026 10:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771846B0093; Thu,  9 Apr 2026 10:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54CFE6B0093; Thu,  9 Apr 2026 10:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3090F6B0092
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:22:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C169F5B1CE
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:00 +0000 (UTC)
X-FDA: 84639231600.09.00C0446
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 26D1FC000C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:21:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SVfJPkjw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bkaXdzOSmC/c+Yvyf7U3K9hWD43/2ed/TF4H/0hpcJc=;
	b=pHvvqvrKNYoEbUH4QEjUy1B3NERG9OlXqCp8zZqbGFtANpyBJtR3Z3IU9++RcXwWRPQUlH
	2+EjvJUtTWeeIthnVcmV2sLyn2bpu5t2mtM+oDVY3JQVYTjwQAYb8kfpVze7AIWthWcg0+
	+7XX4BfJuJkzYSx/FnxMvpu2Wp/P5rw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744519; a=rsa-sha256;
	cv=none;
	b=UI5rRJTcjppw9+uEeIcwhTY2xrhsRNOCOb6ca99ZIiCOe8sQYKRhX9sngWb7iugyrpNAHQ
	dhHZDk1LWBqvzPl94e83VEkFI1FBL/R0echVgDZ3/vAqsaGRQUt4SWJLozOA9N8OAJSnxk
	j7+oRoson6OnEcf53maIaJhnMXMwj1w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SVfJPkjw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F36460127;
	Thu,  9 Apr 2026 14:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00108C2BCB6;
	Thu,  9 Apr 2026 14:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775744518;
	bh=RDGyHZ5IvHxpF2pat4DZ9fNQzQ+auTQEfUiu8Hjau5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVfJPkjwteZ/uQ8aiGsD36acpad5x9EuM7S0aDblTDji435AVshSCmYg4GdsLIrmU
	 uEe81l092mwj7f1HOIKSWLyyXpYzDnE6h5+B3IL6XZryAUX3i3LX0zloz/55JqJZnP
	 SrSRbTSGJgoLUuT74E9ujRTK4Ispndc1cuENWsB6CwJdNwNf/9sPnlzxzE6T/b3pqJ
	 IMT4yHCzXtq/nE3gNO4Oybc1VCbcTXVQuppsiTcEEUM9fy+stO5JGgPMAgaAPP68Gn
	 TwhYwcHTxpRs47bFOGIaZ7jIgjmt5nE47gYjrnEvDBbJCLmswU1yNPxgMIj3PnlUtN
	 hJFoEaShCMCfQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 02/11] mm/damon/core: merge quota-sliced regions back
Date: Thu,  9 Apr 2026 07:21:37 -0700
Message-ID: <20260409142148.60652-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409142148.60652-1-sj@kernel.org>
References: <20260409142148.60652-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 26D1FC000C
X-Stat-Signature: wwhhjcqqcf7q86uiqwx9so8w1q5tpwud
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775744518-966079
X-HE-Meta: U2FsdGVkX19zRhUnU3vBYGKagp54pGUT4KO2U3B/Sm3j0Tznz/IEYnzxwemWrCYbYgIPeQCZj+G/wdk+8DRAu0ootdVaJQmnTmDlclIoHWAGwr1tG8wkj+syyXvU7S9r7JBRS0+IKfcVncgzvASxVW+H9bgSF9YKUcwEMYTPIbajncp3XHyp3A9neiZnfViBQofin9CTuJTVYCJHpCFd8s0eDqGRvyMhf5d3S1RXfYoiY6eL0UU+Di/h83IoET++Ktcl41bi1uOaFK7cTPgfqMW5bZsD9H6b2ujI+hfDihjUUnLXxEsDV16i7xgvXW/58knYFXf6+xPlSQFav6jxStumO5h5N6iYVZfKBRMpSCxlvnZyuR283K1/hmorerFkRlykfBMn5huViBb8djZ7fDlJFVGXWwDsAfRsertJwBJIVK02I1z/6pT3MkDdxqp49K80UsGrFnI40A8kwjDsTzHshvaFNpimRryN+E5h/qlGNnQ8SoToA5t2d7pMpI2BtGsydA7Z1ru6KoE5HecjP/sVuiueju2tikhwSW/XmV3si0HkBYhGQjsp0mPs4du7tV+Lxbo4/R73sM8OTA/qhJjWk3gIsB/5NJ55PtfFUiZMqX+TDYOW3xcMNbnusK/D5gPt8c9V3aHpxI2D9XgFqiSwrKQ9eTWXJFLHQDAqND2NKXQpgdneSyT2m1vJPwdZN93a2N+wkASX0/w0gzQ//v7Tp2a3qTLyVp9o1xoi7rKDqGzu7UTclu1qkFkArK7FONLK8qppWmgGjjP3MA1TR7P9E7gJAfuVP7zWijY2VshsEAYUyEAuJqsLM53b3jXLXhsgeACxEbgzHluXe5tkU2/u29QcLnK+ooMRzXnUzckzU1ec89lR4m3rllm309AbsdE48XdA4D/YDNlUs4vNPHWkVCI2dZrJdV+yDFNXvMPaTdKwunWh6+6pS9507lZ+BQ8ESRZwavqE3fVviWK
 Am3Q73wx
 suXvP3CVp+lWwTfP298GXIDrdxAVRaqDxTCJneskCWEf9UPPqKnzcHCD0QEEwi9VFMIAaEOpAEzYRb8vMS3qCvuAOKlV8lfx309Wd/yFCXIoOU7ZKPA61fmUSV+OawJAHCRYZA2zHeTG554EjfleSak7MnPKwQNgD+GCbzxOr0CZOq9aVVLNIgKAMzuAobSjgeD3x+Ew9MFI/H1LtsF2KfN737JChsUtms4tL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_apply_scheme() splits the given region to avoid applying action to
the region results in applying action to more than the quota limit
memory.  When such a split happens multiple times, theoretically that
could result in violating the user-set max_nr_regions limit.  If that
happens, DAMON could impose overhead larger than the max_nr_regions
based expectation.

Such cases should be rare since usually the real number of DAMON regions
are much lower than the max_nr_regions.  Even if it happens, because the
split operations could be made only up to the number of schemes per
scheme apply interval, the impact will be negligible.  The impact could
be higher after the following commit, though.  The following commit will
allow the action-failed region to be charged in a different (less than
region size) ratio.  As a result, the split operation could be made more
frequently in a corner case.

Still it is a theoretical corner case.  But it would still be better to
be avoided unless it causes other issues, as max_nr_regions is one of
the important user parameters.

Avoid the violation and resulting overhead by merging the sliced regions
back, as soon as the schemes handling for the slices are done.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c7d05d2385fe8..98ee776d98cd0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2159,6 +2159,33 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 	}
 }
 
+static void damos_apply_target(struct damon_ctx *c, struct damon_target *t)
+{
+	struct damon_region *r, *next, *orig_region = NULL;
+	unsigned long orig_end_addr;
+
+	damon_for_each_region_safe(r, next, t) {
+		/*
+		 * damon_do_apply_schemes() split the region if applying the
+		 * action to the whole region can make quota exceeded.  That
+		 * split can result in DAMON snapshot having more than
+		 * max_nr_regions regions.
+		 *
+		 * Merge back the sliced regions to the original region, as
+		 * soon as the schemes-handling of the slice is completed.
+		 */
+		if (!orig_region || orig_end_addr <= r->ar.start) {
+			orig_region = r;
+			orig_end_addr = r->ar.end;
+		}
+		damon_do_apply_schemes(c, t, r);
+		if (r == orig_region)
+			continue;
+		orig_region->ar.end = r->ar.end;
+		damon_destroy_region(r, t);
+	}
+}
+
 /*
  * damon_feed_loop_next_input() - get next input to achieve a target score.
  * @last_input	The last input.
@@ -2528,7 +2555,6 @@ static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
-	struct damon_region *r;
 	struct damos *s;
 	bool has_schemes_to_apply = false;
 
@@ -2551,9 +2577,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	damon_for_each_target(t, c) {
 		if (c->ops.target_valid && c->ops.target_valid(t) == false)
 			continue;
-
-		damon_for_each_region(r, t)
-			damon_do_apply_schemes(c, t, r);
+		damos_apply_target(c, t);
 	}
 
 	damon_for_each_scheme(s, c) {
-- 
2.47.3

