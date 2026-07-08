Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9758EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 02:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23B056B009F; Tue,  7 Jul 2026 22:49:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19C386B00A1; Tue,  7 Jul 2026 22:49:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B96C6B00A3; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEE626B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:49:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F1C81C8419
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:07 +0000 (UTC)
X-FDA: 84964077534.26.C26B33E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A7BEC1C0004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7da8BrI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783478945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oA5QgRVwAQqXAsPa92ekv3Nt4l6hxznyCttmnCPVif0=;
	b=tAV2jC5+ubf0LIezV2GuCgdm1ZJ/H0CJTaQNWbbSsgTJm+uiLiC4F6aUGa4PvsYRFbpKMw
	rt9ioCds6DZ45ZXOyqi9aL2sywQktG+aZazvObjSfC6Fj4lqyZoDq3aaA0B6B0HyGSgcYS
	43FdeG69fJk1Qp9hvXLm/HMcGbZG/Vs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7da8BrI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783478945;
	b=e5aOLebhiOqumGkKaTXYw17oTgrAkoj3in63AnPp+Pi5mJ6gBg9F3BO8Wixmt14wqTxDN9
	ZjYPE4dwWSYkXCpNEflPOJ/3s3MpcoMqFc8biWc8nLgFlDyXMtqTCRcfPxuHodOSTbVuCo
	QErIsdUZ+sThyOx3jTu+GGLR7Yyv3OE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B315601ED;
	Wed,  8 Jul 2026 02:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE22F1F00ACA;
	Wed,  8 Jul 2026 02:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783478945;
	bh=oA5QgRVwAQqXAsPa92ekv3Nt4l6hxznyCttmnCPVif0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7da8BrIJPZiSZ1wFMxO5mAX6hj4rbKZqjgz7wFXXNOYtJ3yi47fHcMAptnSsNWaJ
	 UrOD+afHUSLgDQilipphYZBdNWJba/MbST5R0FtRQcnP9miN/AzoRq3iB3lykybUdv
	 lmqRUukNoEhhi2ilz9tOcLmJwwPiEyBDKSuFyReBC/Q6A1wtDMW8MJNIsALLjdzSX7
	 OUfO5WdrfTwZl2+PLhPNSsBiqt3dOnyCPP3aU61VuU1G9Uhlbnvo3+cKFSzs/50lwC
	 VNKTcIcbWAnObHatGV3MxSb9UYt1WFCBh2Lrd0NZfWix8vsHopALi7qvfslZef+TIK
	 k6ViS9s4LKQLA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 4/7] mm/damon/core: s/nr_accesses_to_accesses_bp/sample_count_to_bp/
Date: Tue,  7 Jul 2026 19:48:50 -0700
Message-ID: <20260708024855.116614-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708024855.116614-1-sj@kernel.org>
References: <20260708024855.116614-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q5b9kdhz5wdt7otcznrojay65w3tedbq
X-Rspamd-Queue-Id: A7BEC1C0004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783478945-323767
X-HE-Meta: U2FsdGVkX19K9FY+zYRFQqX20ISoEzIt+5NsMaiEhHh8o2m0oKwILJIHq3KObDmoEJnbJKzNKTlZNh9X0HY0h9nBnmPkCDCuP9cUHOdf9x5paRxpFVmVOjrcgz+v0EKHl3Bcg0e7w74BQSQK7uYjTMp1Z2hme47jNyJsEO1xdS5jdisorc3Wz0fjLaMM7uDr3rZIToKAm2EhJcaAyVB8uqgzPJFZY/kHVEs4iXmOmhARCpFQLlU4qlQZ3Yx8zA6Q6/T7SshUei9hgiIBWRST+Qhha5pbV8DjllHaUBd96rmQD9VJXO3gohgo5w/GlqopIup1fTojz+c0nb2/zmUPDRMOhWD9/YKFIkbzdIE0aGFQPLrbcBbtyHaLPG0Z3UiUxWMZDys8Blto0Zob+yrE3r954LD1qI+1jrDVyvf8vLU7IR8JTbcIUI48OcP//peNICRFgy1dHmD1PmEMD4ELmahslL+yU05N5lx6DjGGtFcKEng91O6y014FYaFcNO+vugp7ydlSB7QWdbwoTExuIoxRq+QAnvVncGzRxTflSwPqUBw8rJBn66qFvRuAtTk4Z1Ie8TOT8Zn/gSf8odjrY2x+3FAjKGibCUYB5aPEPMyXqqd0JEXoOruPtbQn88ZnJgO/BXz5MbIkgi9U5AwD+iTAnwmryJGfO0WOHimTXhimf8DDy6y8hB41AXMJ+imVKT/Q76OPfmBp+cwboUQt3USJlm3seE9oimSAvl4oDLnG7/Rb77tk1QeXUukxx+xRJMDu7NHvFce9rC2tvrPFoGwSeViip3nUvQcj3faHj12tzkOxRkWWAQv7h9w7srB03xOuXaCPJDZrjZ/4QRKdlquVeM3+XG/AdUVMnTgMHenTCXMS6gARsfavUsoGw9wuTjdO3DIJwBxcuxIy2b1ARK3uFgDUMD4UG7NqaDqhKsYVdZehBVlY9TCis1HEeZuoIvTUIjWf0n4mU3F9mDJ
 0lHsrP6r
 Ir+3TpjFu/7An7N4roTlbRD+YUXaGF+2QNgXytK1AlJuLSd5fFCbXxGkmgTSXRs/dAXtYZH5/BnXt7aFmZHYEdYohnFADIk1XG3yf99LbvMHhkBsEBfjxADSCGo+k1xa57C8nCJL70bspXEpQ3h/G9OOYan79wzsq6t3fskfDigN9nQLW1DI944UaQe9KPf3dAbZbTES1vTv3num8FYSS3VYgOmZsfrpqaqql2P/5LGhma03eBvpI00f7J7hg5BcZiQq3sKJIpqaDpevpqCCKT7XYFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_to_accesses_bp() actually converts a positive sample
count to the ratio.  Rename it to better describe what it really does
and not confusing for more general uses.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index dea63083917b0..718268df27fa7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -883,19 +883,18 @@ static unsigned int damon_sample_bp_to_count(
 	return bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
-/* Convert nr_accesses to access ratio in bp (per 10,000) */
-static unsigned int damon_nr_accesses_to_accesses_bp(
-		unsigned int nr_accesses, struct damon_attrs *attrs)
+/* convert sample count to ratio in bp (per 10,000) */
+static unsigned int damon_sample_count_to_bp(
+		unsigned int count, struct damon_attrs *attrs)
 {
-	return mult_frac(nr_accesses, 10000, damon_nr_samples_per_aggr(attrs));
+	return mult_frac(count, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
 	return damon_sample_bp_to_count(
-			damon_nr_accesses_to_accesses_bp(
-				nr_accesses, old_attrs),
+			damon_sample_count_to_bp(nr_accesses, old_attrs),
 			new_attrs);
 }
 
-- 
2.47.3

