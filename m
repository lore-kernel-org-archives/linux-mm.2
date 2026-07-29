Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4169C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0BEA6B00BE; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A23A56B00C1; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89CE56B00C0; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 643776B00C2
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:03:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00FA3806ED
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:06 +0000 (UTC)
X-FDA: 85041980814.03.CBA75AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 64C4B20017
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z3bsZJLH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6Gzj2O2XUAR6lep0wUa1dFLYISIw0l2rjfScnnYsJA=;
	b=xRBdbwGsZ1VchMWepMCa+qF89OrhxJC+j8h5C6Qa4ujJ7xsdsYjKVDR3gG3aCVo6DjQUFM
	KOytgheS1c/iUhY+75E6voEFPdDYzAIouCJ3rnsG2MpoPd4AXVppM6tPNux3TxhSF27Gch
	KkX1tS4hEyRtMwCwk6k7B5tS7Ix6Qe0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z3bsZJLH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333785;
	b=LTz3fYmvAJ/9KVh7oMjVEtKdzIHtepysL/vJQZZS+IqRodv8uKyWTJ+l2yeSfe5I3xJbXF
	/qSgYpPmOxKtudNPg/5SZsJc0OMmSkhiEwaFPNgcl/LgKTBhb1ebMppQZwBKHqYF56mv0J
	YJDVjM/dkqAOKTgYXiYLnk/x1UwXUDs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA7C34375A;
	Wed, 29 Jul 2026 14:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B601F000E9;
	Wed, 29 Jul 2026 14:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785333784;
	bh=l6Gzj2O2XUAR6lep0wUa1dFLYISIw0l2rjfScnnYsJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z3bsZJLHYCQzwZO54/ElaLeyhDf/2VAfVGWP6UskqGjo6BDeL9kwYAE3utoKcmDQK
	 GHhtYksSfyTl3gjLZWz2dehrtDJp4ROmjUZk2R8KlVYGJwPYVol7nwsFLgYhEZuMTg
	 uekn/PmSjZO6Yj21tF7cR+GCB7vRCkGw55dTjxk3SCd9uvNulE+RuL8V9Lr9yAk5Ia
	 u+CY6ixLAPKnwvYW10VR4dHKaqMtSrxKFUW9xCsE5bauDEMvycJFalKuNLB8eYDizr
	 txwrEJzy9fGaGMhRtEX25lZRDGxQcDOuBgoxkNNZYswROFE8zwxqVSMMwd3E1Ln6b1
	 I7Jx53ncKsmLw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 04/12] mm/damon/core: validate number of probes in valid_probe_params()
Date: Wed, 29 Jul 2026 07:02:44 -0700
Message-ID: <20260729140253.87753-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729140253.87753-1-sj@kernel.org>
References: <20260729140253.87753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64C4B20017
X-Rspam-User: 
X-Stat-Signature: tgbigrenefpo7qn6ffjnqek93ms9r37c
X-HE-Tag: 1785333785-423421
X-HE-Meta: U2FsdGVkX18IVJNRmKSw2PzOlZgvSaXCV4ZcCXOIxfn++TrNWZtn7VDNCGQKKaT4qVE5zAFi6qaNfg7Gv8wXhWRZPzrM6eVvvZ+Rjkiqtr99jc+lLPWjvqsV9ZjEuDbyVVtZKQckkt5BWFY3/LHbN0YdlDEF9jIzN7DGXzRCY1re1teZvtrNp0DWDvoxlPIHvyF55sLwVFFhEJJuhTUFmEZtqYyPN66nVLG/UHuYI+nMF1SMpYSwztcOKjM5r6tln4xm4IAZC6tVgheKN4ZXbVl4lg7iasa7NeYCEQYU1AfA6NMcXeevDo+dbmv8WQ53YmQmLB6UeVVMMBpfPfhFNA12ujOL1uUvrPPHVBedUOmGBFSl1M8GjtKiPsfa4LVJX4glKDkZjsaiVryJQOIvdebUKpQv6rAD0yd0YYyRbRL7rCOmgmEWUZPh4bRdSVvFOmdR43gv9Y2P5hrolKbh0wwYR8uRYZRQVnjqNfP6M2ze1x6K5j/Lzv1s67T120ZweA1OEEZRbDf6pn8dojqd+4rg/E5uRlc8NalUfheBn34AJ1J8uKqJJ5BR59upv6634ZpF1RpAPqo08i6TImk9C8rOW8Hbv8EwOXqjykVnkcQwB/k2/1aQLMHEjKqXAU+fix7Q2mVBlBSzlARbH6vifTrzJTwHK9o4h7W1Msvpx7H0gv0FjEdD9iPp6CkV3Apmct5GJvNLgu17fTZ784Qx4MNvB5GiCy2Iv3m1yMnv2M0w/dpu284C+XNnNs/NMfA+/JC8mvVWEjhevZ31+cD7B5eHMmvdCqIVTjEmkvbFxE11joeim2api51C5V9VwFHfdRXLZ6EiPGuLlww9Q+uN5prB1QxatAIr7yVq5VWkemY5xBw15iRFks0dGutrahIJlefOHq2x3Z121l7jsXXATCtRi0E3OYP7CEgfEJYbG2ApddC2ZbSIVR0uOiahtp0zXZx20qD7PgkFud6VX5H
 JmzLK+0W
 lJm4wwNFhnZuyckb2ZmjXfNZJIcjoH6GEp6MiImMqBnzxVDrurjKSDowAKHeauEyrvEtj3Y6RyhFz5k6luDUGyxDZF7UXtqlclmIh2otTf/0b7RNtxBWy3dOndqVmvU3X6XWH3qrrsu24XPTrNMx+Xd5iQi8P24CdjOz/RvewluDV26Z4Bc/s3uX1PrLlsJdNFofY52+0JbzkQSPrmqVFNoNG0udt5KipP6i9la/sYwwAWfkO9cR0pJ2Q7nF/CKPW+L3KV676dGmd0fhezSvfFZ9o3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each DAMON context is allowed to have only up to DAMON_MAX_PROBES
probes.  The central place for validating DAMON probe parameters,
damon_valid_probe_params(), is not validating the upper limit, though.
Do the validation.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 1b0f12d17de3a..07f4e7126397b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1401,6 +1401,13 @@ static bool damon_valid_probe_params(struct damon_ctx *ctx)
 	unsigned char max_probe_hits;
 	struct damon_probe *probe;
 	unsigned int wsum, wsum_to_add;
+	int nr_probes;
+
+	nr_probes = 0;
+	damon_for_each_probe(probe, ctx)
+		nr_probes++;
+	if (nr_probes > DAMON_MAX_PROBES)
+		return false;
 
 	if (!damon_has_probe_weights(ctx))
 		return true;
-- 
2.47.3

