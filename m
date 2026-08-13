Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36B04C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33086B019E; Wed, 12 Aug 2026 23:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4806B01A0; Wed, 12 Aug 2026 23:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF9A56B019F; Wed, 12 Aug 2026 23:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87A6A6B019C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:50:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02439C0519
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:11 +0000 (UTC)
X-FDA: 85094868264.01.D0B9A10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6B936C0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZOj3dCJ/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786593010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bFqUVYf2n04Uixau/NkzvcP/6puf0JnXDQxViDXP7BQ=;
	b=VGk138aRiVerKDDvBqhGqhscU2Ypz48a4FMnf6HtA5V91fCO2lp4WId9M3t7k9h6nr3s+C
	qgBWaDDoZocRDkfeSD1TVYvq0JRX/K+dMbmBot9+SedL8z3WAK9peeqHz7dm3NA4pTjP6u
	qIJBBc8bPV0A2VTNJhXhhlKva78hc5M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZOj3dCJ/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786593010;
	b=muPE1UDi6StiFa6BOe4J9a6xuYyl9UWJe4gqgydEqkwuaotu+l4/nnQ5H7YOX4GvO4pMI9
	Yj+roX6iizMMJGZ5E2CXJJPTVwkn8X+XrZdEwmWVoWl00cvR+XCuGx/uW5Y0IE1APeuZ09
	5j9YsAFcDbsKBNt8ooBkVRY/9zNn4kE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1FBF43ADA;
	Thu, 13 Aug 2026 03:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9CF1F00A3E;
	Thu, 13 Aug 2026 03:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786593009;
	bh=bFqUVYf2n04Uixau/NkzvcP/6puf0JnXDQxViDXP7BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZOj3dCJ/1d3ON081pPcVJreuyCmWBp+g9lWZeT672RpxyAgNE0u/xEa0VbttpZVSB
	 RXQi/h/A/XyUh6lqJXEMCowjcMLF9EvJsIFKiUx0o+LFheHNXSrZ4Jr5aTOUdnmEOw
	 0966Xms2D6m+ziu5O+Z75zFAdTnDlx0BybIKL6n0gJWTFRVK94enFhCM+1o1HJyHGO
	 Weo4J041qAte4Gawte5oeZ2B298hmFP0Dg9/IB8mowtQHU+w+550V3OWS3vBqp4Zo8
	 282vrVqncGxGDbyZtUGyenSjZQwvewRbSRsW+qT3+0MgNgerYhRkYk0RfspjGKVS+X
	 jtrvCMexIeW3g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/4] mm/damon/reclaim: remove unnecessary damon_call() param validation
Date: Wed, 12 Aug 2026 20:49:58 -0700
Message-ID: <20260813035001.97364-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813035001.97364-1-sj@kernel.org>
References: <20260813035001.97364-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fp83q6qnmperuk13qc8ax3q4r4i3cj1t
X-Rspamd-Queue-Id: 6B936C0002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786593010-465876
X-HE-Meta: U2FsdGVkX19ce3sfaOMtDKEDNYaNb2GwlWyxqSzJyv2dmpb0xWNWfUFEMxoB4v7QPuuThsjwUWNJ8eWPv2WvRygdY7+mMkab7WDkjE5EJVtQF/cy07W150ptWWd2F1DZW+DiTlp5/l6+8zNLl6xJqZywEqEvPMnZO9e2g9P6vjZSRpJ4vR2L13t/hYq5wyc6Jglr3O0kdcGfbv1BjNI8F6oS0u1gQV1Df2jrPNuksoC/juQZrGEN/M4xXIDwa+erMrjewzM6OIPhE+mY5T3cWolqTNktuxfMbB6ptJU30N7ekJzorBjovH0d9YH5CpMG2ypiSZdsqdqHXWesY5F5g4OJbfruIaq8kKars4kE6m7ol5WmfsPgCaaOJny1VgUJ0+82L1XRvzzv7Ny5Zc2zcccJQidJMJNgzH3vNWevQiyqe4RxhAacKjXGcESjZAItAY/5o4xtey5A8j7LhgL2pOR7c6JQ9v9p0Ly749yIeYshPCI7G4XOZq5XAn5wbP6NYN+ewiAQb9ZgxO8WQx9aelBwGjc3Ml89UD2l/torjt5gg6xkiM4K1pAo/Ob/s0czQ35fSir4oEJ9BTsTxb5bh69CumwGSC5eNMPlSVwj9DGyD+OHkZuqPILVEOzbx6q23216D2+oYt7QcmtlIVEJW4doQb4ORmweQuOaJkOp5EnG087ReVpXwo7FNfQqmiIVkk0zIYUBfP1zpIcsqkpcNpGkseLE1ExeKh9lrAkPG3TITCoipzdaAf9CJUT0HdYbQ89mE/z4m2+8FntSLb2aU1gBZHEBnfLI1EcntxS3m27UOtogxMqwcw3IMUKwpnpJNea4dK5pUA7v+5aK2LmxwO1S61wrR57piEmfD1nfqEssyuCcABOlY6GDvk54o3Qb+BvhxG5QVJ0mbmD+U4oUeTtNc5nx4ADqbuL1hKRcjDN+d3oQXFKvclfT/NZLfkYpXFfkVdFVqHg6C5noJFW
 Aj20rCbT
 uSZ7dXLM7IzO8ZUbVJ4cn1VIAZZXQKTnN5tBiF1/XEf/q7c9RD3205KtPzzgZjGnNSgjZ4H95xaYPcqgpOExKFw+roC72ZLsOzv34RttRNbJwyhdMvvgp0ifpt97EIDUXfRsnJfiLO8Dhv342rtVeWZayrvmdZr4cxFWUcG47TP3aZv/ssXv9mBXpDXnGrwgk+HquDJV9DBogV7JQ6XaiGEwBnyHylYjuVYUlaW0Gokj6Rx7H70KyIBUp9cNBn05/f3WBgSut3D/JEvd6b/5foBropg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM avoids passing NULL or unstarted damon_ctx to damon_call()
with its own validation.  The validation is no longer needed, because
the DAMON core layer now handles the corner cases itself.  Remove the
unnecessary check.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 45d5557cc575a..42a2c9cb13431 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -271,8 +271,6 @@ static int damon_reclaim_commit_inputs_fn(void *arg)
 	return damon_reclaim_apply_parameters();
 }
 
-static bool damon_reclaim_damon_has_started;
-
 static int damon_reclaim_commit_inputs_store(const char *val,
 					     const struct kernel_param *kp)
 {
@@ -293,10 +291,6 @@ static int damon_reclaim_commit_inputs_store(const char *val,
 	if (!commit_inputs_request)
 		return 0;
 
-	/* Skip damon_call() if ctx has not successfully started. */
-	if (!damon_reclaim_damon_has_started)
-		return -EINVAL;
-
 	err = damon_call(ctx, &control);
 
 	return err ? err : control.return_code;
@@ -343,8 +337,6 @@ static int damon_reclaim_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
-	if (!damon_reclaim_damon_has_started)
-		damon_reclaim_damon_has_started = true;
 	return damon_call(ctx, &call_control);
 }
 
-- 
2.47.3

