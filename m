Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97654CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:23:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8CB56B0095; Sat, 20 Jun 2026 13:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3D226B0096; Sat, 20 Jun 2026 13:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52F66B0098; Sat, 20 Jun 2026 13:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 987666B0095
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:23:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E87DEA0202
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:00 +0000 (UTC)
X-FDA: 84900961320.06.7CAF70C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5A4511C0006
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:22:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nVNrz1gC;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zSgj5Q1lJXKb2smRSTNEFl3wFQBmUv230OpsOgctQ9w=;
	b=2p5ZhIPm0BuC2c8qGIH+gZmF341gSwcmEnKffAfET6L2btbHP8tkv4Jc7e1ptLYBcqDHWn
	d7FWWfrMTOcfSe+WQ2kxRjbqRX2R/EphwJRoJGMgfFdTKvI9UgAhNjUFhjtDrEx4gEuRbk
	bHLSrboamfNx0Ys3Djjx9/haBnJg+hs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976179;
	b=VavjW5Gatayytgi0dZpwAPlOhqhvmnHNFHeQvVTcQIdefg5K6KHpDzfB7GgqXlXoHXFAbT
	98LN6UcokEOtAlzJY+suqT6TIbBw3fPK5x6dNfWNnNzxZGAfWbaaDdg6oT1QVsJfLJg44h
	OTslhqMESHMVIqRfEXg/A/+6N3iAkGo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nVNrz1gC;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F1523601E2;
	Sat, 20 Jun 2026 17:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0B51F00A3D;
	Sat, 20 Jun 2026 17:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781976178;
	bh=zSgj5Q1lJXKb2smRSTNEFl3wFQBmUv230OpsOgctQ9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVNrz1gCKXXiDVJKN+W3DUXEZyv0fRAutNmwo93fxkEWFqIXR1uEr/mpqkpuOKwq+
	 AE9Q9aTk21q+5iShcW5iiIiPNH75Iv6ZLWrmL8TsS3bNUWiQqOtupuwUgFJ4neZE4r
	 tz3XPCkXqkkvtRvhbYe+BPBxC7j9ucjI2gtTO1O42xCUAIb4nnc8aRvV90FBw5iGq9
	 S/bddDJQddqevyxg6VHK0fbxxugyW2HKJhHWE2p4Vk3YDrqJsnnfSiVFXhHyO+N8Wx
	 /qgoza4KlqFGKBkw4tSuBw93ZEgNjfrNC/5FeMXwiL65c6ECU1gusS5dzKQ+ThZnJD
	 +w9/V/LX37Nwg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 03/13] mm/damon/core: use damon_nr_accesses_mvsum() in __damos_valid_target()
Date: Sat, 20 Jun 2026 10:22:33 -0700
Message-ID: <20260620172244.90953-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620172244.90953-1-sj@kernel.org>
References: <20260620172244.90953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5A4511C0006
X-Stat-Signature: yobd6y1nyuom9n6scjocp6epui8kco9h
X-HE-Tag: 1781976179-256734
X-HE-Meta: U2FsdGVkX1/xJboxyo2DQJzPW75KpDI3pr2AoO9Z1ImPqmbdlQ90pv2MzdHK+WqVmOHuDrt0Q5l+JuLzqrTYxcyobIPv/oOIq1c2vhi/L2TbSw5Lic/lTVSrg5SaivInxGYnEPrUVzSact9JKh+bRoT6HSSARlmR9jzNA5gizKqqQupKsyRdd0A3nxDzQAUZ9k742F2OAnXmYqiJymQfGzEtPPLSsA38d6DmJAREtYGY151fVWlOClrklIZJ3YNAca8pVVuWj+J77h9Z3x3JFqNqWA59qytMimTEYRA0UR0vW+BKr4t8eGUOvRRZvX87QjT2zMJFxJ6W2zSkCmDBq2HhPxw18RLBZsPj08VZiY0pM6/gp9nSZCGT43krb15cGI0bpciAOWTnAhepCnogbmpSmdD81i+DhAAvG6QXy3d4KnKpo2OIH3gepk9erWJH1iEBhhXd1Ph9ctXjVCJhG3/QynwsfITKuTHPXL8GpxILqXWItIowkeAvpcZRmCJ4I/XtDrf+eoPz0AC6xO+qZkHXXNZOdQcuzfK2C4Wk5//X7eZ3XoQ6ixqoGiinh9JsCVAhP2hLToOfBpJHn6n/LMRFKXUEq5w2VZ4od/T4jw1vfi6p1dmuXYdhufBfP9HRILCu5Em+ceyNjYyDcZfGx1E9FUgZbiJAFeT02uS6bB3M+xlu2KZ7MGOXw+oWQuhAq0G35YekOKEUutBLytHLaJW8ZU3AYRnV32Zv1vkVR5C9jzUDcw3CeKJuiAKZJxs4TLt4qIpktQcIUzOGYo3LzUkr5lN0gJTe8cQNCy7PVX4h/4hj+o5tDBIWTfjyRUE6ax6NwZRL2dQeP3WbmNZ5F+jEBsO37Ou4GRiV3dgFzmR7hrVLHlkTyRYga907d0shlvGfCuvYOfn+DlL+YBjWjFPwmXfHYtdWAe3+E9tvrONnThG8AHYNhkbX/XuSjegJe/6JA1WEe4WlLShnwk5
 Z1bzkArW
 8T2ogLawJ4L4tBCraoscvxUhwdNQVv/xv2KZ4cGGXtYszCY2B1Q1mpRHcUtmO40eSVFVE3brj2vAqAHDXW+llFAPhHYkv4r2iGvIjk/RATf35SwCgt3fGRIBR/6vGEWOx5wnipi1q2xgPGcG5YkDPFNxY6n+UJ2GEEF0uYJsUH8UlsRCr51p7NetHha8bg6o8fal+w0rfS20mC5PxTbG1CJ7Rf5fQmRIwCloxmBMeBmlhlpJNjBP708k7e6gaa6TQ499SpVf6qpGRiKc9YdtXI+OqzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_mvsum() returns a value same to nr_accesses_bp.  Also
the function is more simple and therefore more tolerant to errors.
Execution of the function would be more expensive than the simple read
of the field, but because the function is quite simple, the overhead
should be negligible.  Use it in __damos_valid_target() instead of the
nr_accesses_bp.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 687aa2ea1d013..ce0e2a4c1d523 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2120,10 +2120,11 @@ static noinline_for_stack void kdamond_tune_intervals(struct damon_ctx *c)
 	damon_set_attrs(c, &new_attrs);
 }
 
-static bool __damos_valid_target(struct damon_region *r, struct damos *s)
+static bool __damos_valid_target(struct damon_region *r, struct damos *s,
+		struct damon_ctx *c)
 {
 	unsigned long sz;
-	unsigned int nr_accesses = r->nr_accesses_bp / 10000;
+	unsigned int nr_accesses = damon_nr_accesses_mvsum(r, c);
 
 	sz = damon_sz_region(r);
 	return s->pattern.min_sz_region <= sz &&
@@ -2149,7 +2150,7 @@ static bool damos_quota_is_set(struct damos_quota *quota)
 static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
 		struct damos *s)
 {
-	bool ret = __damos_valid_target(r, s);
+	bool ret = __damos_valid_target(r, s, c);
 
 	if (!ret || !damos_quota_is_set(&s->quota) || !c->ops.get_scheme_score)
 		return ret;
@@ -2735,7 +2736,7 @@ static phys_addr_t damos_calc_eligible_bytes(struct damon_ctx *c,
 		damon_for_each_region(r, t) {
 			phys_addr_t addr, end_addr;
 
-			if (!__damos_valid_target(r, s))
+			if (!__damos_valid_target(r, s, c))
 				continue;
 
 			/* Convert from core address units to physical bytes */
@@ -3024,7 +3025,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 			(DAMOS_MAX_SCORE + 1));
 	damon_for_each_target(t, c) {
 		damon_for_each_region(r, t) {
-			if (!__damos_valid_target(r, s))
+			if (!__damos_valid_target(r, s, c))
 				continue;
 			if (damos_core_filter_out(c, t, r, s))
 				continue;
-- 
2.47.3

