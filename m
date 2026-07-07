Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6500C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77C336B00AF; Tue,  7 Jul 2026 09:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708956B00B0; Tue,  7 Jul 2026 09:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6A76B00B2; Tue,  7 Jul 2026 09:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2966B00AF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:50:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC30D8E0A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:53 +0000 (UTC)
X-FDA: 84962116386.21.ED6B79D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 155461C0011
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9+XRwXK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNpIO+SPQXji8X+//JGLIeVACOioKXNsL/4ynMEtvQc=;
	b=BRqZNN0x83uQbDdHwd26O7z1IiJaa2WymRK9DpJ7y0y+n3WlFgXNu2nhzLTv6p2Vf3Y2/w
	c9bmuq9EYcRHOd0doDl2N5BYIQM3Y0XZPOkN8JqA8R39dO1xZS6Uq9lhbEJB1zc/L5xMHb
	tyFrxgEX1NnVx4hC9CKomga5B6xOnEQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E9+XRwXK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432252;
	b=gOxTHPh5OL6nDZO+3YwtLkNIAdGSc/dVD7pp5MbzAN03bvJPj2NwoU9KwOtyDeSxzuGq2p
	g81KWLDGEdd9jYBe/lVw+z+vcc75JI8VReCL7L/KV4i/TViLqylR5KRBvkOAnYPnVIJtnA
	hW2jyyjBnwsUHelbEyLfJSvKsxYsZow=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA14A618BE;
	Tue,  7 Jul 2026 13:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D671F00A3D;
	Tue,  7 Jul 2026 13:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783432251;
	bh=CNpIO+SPQXji8X+//JGLIeVACOioKXNsL/4ynMEtvQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E9+XRwXKny0XBWnxcaapAMrTKbV5zSRJOfIx0quQQCbI0or4ckcFsXMUqvWrt6qU7
	 /ENPuv+FYA/u4si6dS8gVF+QeZDWl/zNPz3PmYDCugiiuQBiMWNoyF09NtynIP90EW
	 a5yvVS55wTUztjmSMJ38VJUETFQS+qqByS86hEhegzN7Amn99h/FlQjlSxrHk88J+w
	 oaajX4+0a6j7TlWuEQ3qgY8HCoavTTpDyTtKkuUNYejnUdZ2jhEXw5efhiS5jr3qZ2
	 8AKD7j4K2ZV0hi4exsO6n/bDVcd6wLUwVnbsnlWaXLfarC+rQrqRPcFX+FRUoEi6Sr
	 lHjSwdlstCxJQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 3/7] mm/damon/core: s/accesses_bp_to_nr_accesses/sample_bp_to_count/
Date: Tue,  7 Jul 2026 06:50:32 -0700
Message-ID: <20260707135038.90068-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260707135038.90068-1-sj@kernel.org>
References: <20260707135038.90068-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 85tpbbwi4kydujwpo8u764j819rpx4rh
X-Rspamd-Queue-Id: 155461C0011
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783432251-284245
X-HE-Meta: U2FsdGVkX1/VI9WBumvpWbXMyoUJDUuh8UBJsHMJzLiGGgkw7/8J5aPqKnBN343NUM156taV8LQQa23caVS1i9JrPz57z6Fj64BiOwXv4ax6gwhJDY0v8AWOMrCF5GwkMbrlzAtk42kph0fKOwzrDRW3oEmLpfz1gO8a1zKu7eELbE+m3ZzqvZa5yeMwgeQzAuROHkofdkxjKNkQIfMynlAewG0zVI/RNTNym45UV1jTEYYGFd6a66jUFQv16LsVFAlgOpSFlzuJiNAm+pqAVk3R0SpU7wT8TwRyOPbde7U35iJlET3KscD1ZZ+Wp8EKa7Y75x5/IHNf/eTdpQpXh5jcJFqPDA2K8ezhDTGn3HfRFoOtrog6N7Bb28zTP9ppNr2Hbso0WjvPbbz5wsyHFy6TqSgn8gsWKucPtIA1L9AXG5Q/YAsbCDxH8zfDP9dILUvSIKdozUKZ4sGoPCHis0mmPP5K2RxYSaeM6qalTE1vFIlwoo+CVuegzVwp13J48ZPVbC1eq3d4rMOREkpxZN3R/xuuVaK15vDf9gf4J+3+wWyJZEQ7M5Sg0N92dvCquDh/me4LnfBOsJcfDoV2wVS6yZd5ZvGvoF5vE0V28bQKsUiLH/6qG7KwDmk+CHErhbmq5fahdEq8kWmDBU/as1FeiEOUY/0+O1j1+CvxyRnWrNUDhmgsxaxxFK00SdSSaEVHiS3RfO4QRRHjSSvKE06Za6yJQZ5I/CtSAeYvpaNY1j4Wq0GgGq0hVx085cBSk0nZsnFfuMzpRFfl2YvGEvnbuRN74GA4xTokWyxKBj+mUhSKjz/rY9ZS9M2xy4CLPNS2EtyVHcvSVHtzWtOcBEkHUSSqUFyjeDiWADxGHSCYh1vchyEsQactIHtn/L4UhygG3yHRs4IlIQLc8RcBUDu6BReoWglB+6+j6atzeO4G0Xlt9RSsJeeFYm3brkFuTrTHFqNCOkQcQnMiuu/
 AI93Fa8+
 eD4g5xq1VaccPyn4vIvGZbvJCib+O6NmGzjjcTnnBUQ/RrU60BENkTVU/JzWwycw8ZMGaVaSNmwOOywWED2bTGCcJKV64lioiwknskcNt7pkVB40gSgMpqNJpvOtS/MjNqVpqxZS4Lt4OGGeZIuMaAJ4eTr/xdo85oYB17i9o5lAzxvf3nqeswGgoYKJguU2Cy6wiRucZsvYkY/Y6Z8V49toaxB5fYXo4Z72Bqx4hv8VIyj4732IkWprQt4iN0Mxa4qe3QvAhR0y7SXduBSz2ygewCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

accesses_bp_to_nr_accesses() actually converts a positive samples ratio
to the count.  Rename it to better describe what it really does and not
confusing for more general uses.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 177e5abc981ef..dea63083917b0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -876,11 +876,11 @@ static unsigned int damon_age_for_new_attrs(unsigned int age,
 	return age * old_attrs->aggr_interval / new_attrs->aggr_interval;
 }
 
-/* convert access ratio in bp (per 10,000) to nr_accesses */
-static unsigned int damon_accesses_bp_to_nr_accesses(
-		unsigned int accesses_bp, struct damon_attrs *attrs)
+/* convert sample ratio in bp (per 10,000) to count */
+static unsigned int damon_sample_bp_to_count(
+		unsigned int bp, struct damon_attrs *attrs)
 {
-	return accesses_bp * damon_nr_samples_per_aggr(attrs) / 10000;
+	return bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
 /* Convert nr_accesses to access ratio in bp (per 10,000) */
@@ -893,7 +893,7 @@ static unsigned int damon_nr_accesses_to_accesses_bp(
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
-	return damon_accesses_bp_to_nr_accesses(
+	return damon_sample_bp_to_count(
 			damon_nr_accesses_to_accesses_bp(
 				nr_accesses, old_attrs),
 			new_attrs);
-- 
2.47.3

