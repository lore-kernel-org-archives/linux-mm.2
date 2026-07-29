Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0243C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:03:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CFA26B00BF; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5AF6B00BC; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F186B00C1; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F14206B00BC
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:03:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 845FBC068B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:06 +0000 (UTC)
X-FDA: 85041980772.30.A28FE0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A5DA980011
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dN3ktU5l;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RY+XUIrZiXuiiU/vLhDSc4ARUS4lqpakXQtTFBEewHU=;
	b=qOSEaWdDXwKz75CUV+jWl2pk/OAUd6gCS3SnJCMtLEgN8+m1HZ1Mu2lgWsXzesG10bMRYI
	QTbtOhw2AFkghJE/fXAal5v0Qn1lNE5mzhFA3qc+BUU9BUEqBPGJZ9aj0Qx+7Wwed4lXvJ
	pjYaj5GwLVvSkTYjUovNdtQekPXWKl8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333784;
	b=NjSb5Di4JDS0IqCXhq2bmp4jLu1vEMp+ctx0Bz+Z9fKSlBWpZFl2H3OjWyspTZVRVZvGm9
	voj6078TkhR2OnuqEsPgMBmX7hF5cOuY0sAGtoZGhsvBmgD5uB32Rv1nMjhIovxLUUjpIP
	2Gza6YVdDmlm5OGdC4xg4DovKMrpD4U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dN3ktU5l;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7C9444084;
	Wed, 29 Jul 2026 14:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695221F00A3E;
	Wed, 29 Jul 2026 14:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785333783;
	bh=RY+XUIrZiXuiiU/vLhDSc4ARUS4lqpakXQtTFBEewHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dN3ktU5lDjytpxloJrC/aEGv6gmCuCBuPEWJTFSQg/CwHZ5ppoglbsRHGyArQv0t/
	 EDyE+RO+eTv9Ky5DluaWf14vgsb6WF0Y7cTosv8GWxxb+v+Zxo9p+Ye0N9E4MOCW5Y
	 XFCyaO083qWJg3ks1Nw7216x7AxKOq6f2QWDIQcgUBqSNd4Jb1LYW26q6alYcgQAhx
	 2aWW7q0w2N+6qVFxJCKFigi07qg8sGtj1ZPsVNxg0dwiRChppiQlDkde7q3CyNkIut
	 0nXo2Cs2QiWb20Au8NrUlYqQmWRjBUyd8jgA4AgCHxBcT+LmqwR7vwMYshRlCwfvkA
	 EG0sRdx+CwPvg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 01/12] mm/damon/core: use damon_nr_samples_per_aggr() for max merge threshold
Date: Wed, 29 Jul 2026 07:02:41 -0700
Message-ID: <20260729140253.87753-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729140253.87753-1-sj@kernel.org>
References: <20260729140253.87753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A5DA980011
X-Stat-Signature: nz8hkun5gt93p3pzm3jrjgecuaq1e7xk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785333784-455454
X-HE-Meta: U2FsdGVkX1/u/aiNLZDMzAtrj8AZC6lGdO+IsWx5rkBbnshikIPUKDFpNJ4X10GB17eTf+si+GEG865FZQ4KuANJrFZo/Oq/F4yKfGFa2SY2AbZVS1WVNf3/xwHjg4MafY9EzhWK2Rw47BmKzZ852DwDgKXW77qiktgkRZPPC/m2Zx+J6lOHvAVAik3ns5B7naO10R4dOL1iS1BV+xpIctV0I7B6DxKkeeVpFq3/YqbHtG5WRPpoAP3CFiNNmETzerk4ERTBA85HQAjiMi+S65+jZa3BwCFZHq+BWQsBBaBx9RjO0cM9W1icltpeQNMS8LaJYo2ydgO5RPHlP78YLaaUhe0U/WFkz3BaBg2uX/mtzcLVWMOeSHcZtxf6E7dhMdve2e95VpOJtWeV1kgZvZpk7cALAnCMyrNVG74oVWfxHcTs2oqzRDDk1lUpRYtPPBBp2bUh5YfufrVBnJF2PbqEQtRhJ/VwUKoOJd7lzJ//KXs/23xtXyLnHT1fQPEnOtKRK/dcfSqfjaxjJ/gm6zvzUFTJQBjyxXrhCCAVOuY3VNUun7K2HNlPDs72/XIB8AvQwdEgNRfK41lktB+RhrdhuC6ZIJ5KywJe3jPsRjtNzGxLQLiinxHf/fsyxZgVJHeOQOfx3c7sc6/spsmC57FWvMExzCAIywvD9vX9Usg18IDJXQa8MNwymGqr6Fk4NDaedUEf+lu2LfjJoBldqlbsymIJWvpJroA0WaTtJ/eNdXC+OgwDW/7k7kbESESz720Z+DSaU3sjhQ9xtaX6sb/dB4zWGFZ8tV0gntCt8HU1tMGhowuvVMAW99trSQSBvT/U8B8ZwdBv4XpyjpnRddBsDAH+jZf6IPuFlNvDtWjywC+xro6+GKP+DA7RRpO5O6ys6KG/wKiuIpPag5O7anmrX/Y169ardqVkFVc8AfKd/SNZ03VHXDHtZc75j0wXcLzEEpp6Ofd4gUGGbyS
 MMcG5veM
 22DeqXyQLn7kI9dLEJp8SfF6gd9uT6aVHc+dmQzmff7jkPQPdvp5OPMXFWHYIwTdqCWiaitc1PqluX6l/nLuDQrSFpIvRiBNVY/v2WJdYP4QfH0e7YJML8iy9GqU7EOWGaECMtIhnNKls8iORr9JcZBrpfW+Ei+oCulDXjC3R0I7bPP6k7VaR5741PZ2NFHMLWkeqcvRJ+OLhi5YtVRiOnwmBTZMW+lvK2gPRLEf1E2zDdzqpqyfPDOGZrPufsw1GxCLBuG8lLdab9dHDdazQnu/R4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kdamond_merge_regions() open-codes max region merge threshold
calculation.  What it does is fundamentally the same as
damon_nr_samples_per_aggr() but missing a few corner cases.  The
unhandled corner cases should be rare and make only a negligible level
of monitoring results degradation.  But having the inconsistency could
increase future maintenance burden.  Use the dedicated function.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f7c9b94b6436b..4169268d94416 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3470,8 +3470,7 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 	unsigned int max_thres;
 	bool count_age = true;
 
-	max_thres = c->attrs.aggr_interval /
-		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
+	max_thres = damon_nr_samples_per_aggr(&c->attrs);
 	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-- 
2.47.3

