Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5873C44515
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 00:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AE226B00F9; Fri, 17 Jul 2026 20:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265376B00FA; Fri, 17 Jul 2026 20:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E4A6B00FC; Fri, 17 Jul 2026 20:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8AFD6B00F9
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 20:14:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54F5FC0306
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:47 +0000 (UTC)
X-FDA: 84999976614.08.4A40229
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C353B1C0004
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:14:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FOruMsKP;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784333685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqlH4wneWbMAf8JjBiLX1bTl/sVQqX7skPWoj8yoesY=;
	b=PIVasbXjQshhuKo10vMcnObUi2cDo86+6oPtF0yO6ppvmhGxoW3HBOd7DnctnDE23h8v3N
	nTLUa47cRuz/YMEBfNjeMqfgIqVbxvBrbC/NgOzDYWd3IDOC3GzOMMtCdJ9syewKWxc6a0
	CYrWL5f6zYIXuH1qufFjwaFVey0tWHE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FOruMsKP;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784333685;
	b=mh3rKoYw/DW3/PqvKE1TGr2Yq5WKDDEu8LiOBEcO3iKHhs3W2Qib+pdYPeMAe7CWI3x2wM
	lw6LqSyEF8zvs1g+0mZqYXsqySliMPfVRitOKDN6Rc2MKJn4AzgTCsFyiUwhRZ0MPvnGiH
	YM45Oi3INKgS+ShUi+9kE5KZgobfnKM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 445AA60AB5;
	Sat, 18 Jul 2026 00:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24751F00A3D;
	Sat, 18 Jul 2026 00:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784333685;
	bh=jqlH4wneWbMAf8JjBiLX1bTl/sVQqX7skPWoj8yoesY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOruMsKPL/U3XY9juZDN9avo76TDPTcJuXwXWUDQNx8Yz+18QegNmp+QCoET+Rve+
	 NwhddX+KuULp9o1ExaNTrovDAYYumb1NZqg8DK9VqS2FPbLqkQmSfprMv1KCNig6wl
	 bIMbznAwMck0z+azzhMkY6wFQsVOqXylEfvwS7yRD1epID098fb2au4ckVpiHgZSLY
	 gdY3MVjga6mdI5W/oGjg400pFHzJSzXGqNof9sO9SnMNbe9WLzPlNY4o3bMKI0FadV
	 BuAguxsV+avV1NBkQMuskVRVYFKBmApqU5rAR9oViuufNM+2UKc2GkJl2D6HU05OS5
	 Zp/Yw4rUuDYQw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/7] mm/damon/core: initialize damos->last_applied
Date: Fri, 17 Jul 2026 17:14:35 -0700
Message-ID: <20260718001442.87129-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718001442.87129-1-sj@kernel.org>
References: <20260718001442.87129-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C353B1C0004
X-Stat-Signature: cyx7jphbhcz3zr5caonbohgiu7jwtt8h
X-HE-Tag: 1784333685-679391
X-HE-Meta: U2FsdGVkX18SxTwhfmY8GB6knpjdRhawB0obZuL6qlmWI7Y9drJgFXZ4sNdD52vCJtE006mG1QenRO8wbv2GBOva3fSG0MNSncl9zJBMoQATYcr2aswIE+9hRtOcI1KzRNOPHjWWBsnvt/Th+1MrO1NwoxprqDAqdac+aLFNEMN6fPADx+vTimkMPHjmL+gK5SrlcM2CP/pVyWqYxq5YojSLCoU4cP9hflfiqOum6jtTWEorni0Ik7QxquKtdzme9lQncUZOQcpmSgUrU+BvSdvjnrc9EfSUEnqz+23zC0kxlZIgv+qToG98/xXPxj6+IBiD8iDE4yV9ME1EZs9a9kcJAzs0eNNrZr0d4tJfU8DU5ERubKmCcgYnHvilsIfk22m4UMOY37HLdnM51g9Me5k9l4JAvupV4QSH6HNJMXGf2HzrD/19kIUk3wV/czxSA0U0qdo8ynWJNb2D7Ldu6hf5vxvp0+xUL2im7wdVIwlHRd0jA9XcwsbbHh+xBr38MpVtOCas5LNg34Zw6mLAm7vH4jaDAbFvOA3IaAVlx26n4UyfKcvjDjFWx3AnSxDreiil9/5hXB0y2bU+Sd3hZ24VXZu3iYi/xbPs0mVgqnz5wVBPUIgnZqh4Cx9VeR6mnA4hnVtpFpf+mOpb22kKyMeFXP/+qPqpHgJdlc82Sswa541CIPVmNChkjdR9I3oL3TNI486rh3J8S2CXN2jV48C3vUzbXs23f+mSARDhmLRZ87DGu4XzuFEa6TA5byyQqHTFt2pXnsdqwApIcLB25OSmLu5XsODZR5ojwtkGg7yX/i30VLBWz1HXDDuuaVH7Eqabm0dcTKav0adHUzpxTR5eyC8LN18abenCsAuwch8jLCuWlTlcajYOMX0pdnKQM0Qk4qEYsUklX6zqzCJP7mRYTg4QWuVfqBz8M+VrSDod5G3tETFg5ZDKnYa4FhapCdeiKoxb5X35aifVZis
 CFHU9k3Q
 svnE+zcFzaMKCa/OPoBM9WJIPhzwPLgBb8hweMeXEqHh6vlZ74x7bpbciOpnKEmcaEn4Q512Q/+l7PbGk/FuLFwOB95DllLhnREPbFSG/XlUZMa37KJAgED53537NC0IZan62LjJgJj2z5dpxrFxpLUKcZfhNzW3BVz2QJX00w/582iphCPNqnuxzGcWPbhFi9qu4sywGFDSxFnYeuE0YFk5HKenKZs8ulPFB2WC1i8WfvSw5/1iKwhY01KbN/bfnZ6NWqQqTsAe7Fz/pB/YtT/RN6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Multiple DAMON regions could exist across a folio.  If they fulfill the
condition to apply a DAMOS scheme, the scheme could be applied multiple
times to the folio.  To avoid this, each DAMOS scheme stores the folio
that the scheme was applied to last time in the damos->last_applied
field and skips repeatedly applying the same scheme to the same folio.

The field is being used without initialization, though.  Hence, the
mechanism could wrongly skip applying a scheme to a folio at the very
first time of DAMOS run.

The user impact is trivial.  DAMON might unexpectedly skip applying
DAMOS action for one folio for the first time per scheme.  In the
DAMON's best-effort world, this is never a real problem.  No critical
consequences such as kernel panic or memory corruption happen.

It is a clear bug, though, and the fix is straightforward.  Fix the
issue by initializing the field in DAMOS scheme creation function,
damon_new_scheme().

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260714055436.120034-1-sj@kernel.org

Fixes: 94ba17adaba0 ("mm/damon: avoid applying DAMOS action to same entity multiple times")
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f464b4f0976c3..60255f5cd715e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -705,6 +705,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	INIT_LIST_HEAD(&scheme->ops_filters);
 	scheme->stat = (struct damos_stat){};
 	scheme->max_nr_snapshots = 0;
+	scheme->last_applied = NULL;
 	INIT_LIST_HEAD(&scheme->list);
 
 	scheme->quota = *(damos_quota_init(quota));
-- 
2.47.3

