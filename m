Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60A2CC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 04:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780F16B009F; Tue,  7 Jul 2026 00:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 695206B00A0; Tue,  7 Jul 2026 00:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 583A86B00A1; Tue,  7 Jul 2026 00:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8126B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:39:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C11FB1A02FD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:39:02 +0000 (UTC)
X-FDA: 84960725724.24.2B21C9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4600F140003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:39:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oD1rUo1E;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783399141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BcikUZMCVNS0h///WuvRclAdjwoWFw897c+LuoOpqhQ=;
	b=a1NgkB2F+XhZMtJDHiQjz7mxuUDXU7Pve7j0jJmXk8ZpCjVfB7VRCKi8+D9AP11WGI0vOh
	DM4cf6VLr7DQi+xbf0jtGoFS+X0MEudOZMpDmafyq3cUsCy+BpNIdPdW7Jxtkf4JRnyraj
	46iEsW8coJ1x/9tOEI5IRg2DBcslie8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oD1rUo1E;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783399141;
	b=tscDp8ZXHclJHpEdJPTAKyablf3z0kIMYh9lPxdzhdQgj9TmG15pLWw3eaF+69bNCNqtGH
	R8xd/ljCobhejrt4FUZFlCpy3ThpWfcFmpeNRHrr76lTQQZhYKxlsOXxjCSK6EXnMD6VIq
	/y2c0BUvErIeIjyeYUi4SY70j7u6bUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD1DD618A7;
	Tue,  7 Jul 2026 04:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9C41F00A3D;
	Tue,  7 Jul 2026 04:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783399140;
	bh=BcikUZMCVNS0h///WuvRclAdjwoWFw897c+LuoOpqhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oD1rUo1EwOOqrsoZo5RHyvCv82l6uKkLDQjTWeZKHV0qeEjfSAz4HSiDXuRpVj5Wi
	 dDZpxXNMYK1m/X++YMIdva4UIXgU50n12AhjdpoqwmMxIKx0wkT9c3Nu8OhAcDbzXu
	 7fGYpRjohzkJO4yHM/ODCD/iFAHi9140IxBkneBiCOTViEYv/YWX1hZHCw9TPBzsg7
	 zoYjbo0esYlGiWTDqdaMkeDq0fvV2aBluA+uSY9FwL+pMdNiLjsfPiUNDtYfHivAgd
	 cDTQ9TVFmfUC6ssiOijddJ6W8j33jwzH/GsIhsP6o3ka879a5n07XlVZCjJI/nKDDR
	 MxRBGpkEpatlQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/6] mm/damon/core: s/accesses_bp_to_nr_accesses/sample_bp_to_count/
Date: Mon,  6 Jul 2026 21:38:22 -0700
Message-ID: <20260707043828.97900-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260707043828.97900-1-sj@kernel.org>
References: <20260707043828.97900-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4600F140003
X-Stat-Signature: bb883t63mgtcssxkmtxtg77grbmwidmq
X-HE-Tag: 1783399141-538633
X-HE-Meta: U2FsdGVkX1+TcDVR0sRahB1R/NHRsRiIa5e7dkQZb41P67fyjpRTGmQE5KilV4tacGeviY2E3u3a0pG/K91x2yE9/wTBkmufAQ0wcoip9svdrM9zlZeBlvEVL55WkXtTSzHP420fNx5Le9if7zs0RwrYWiYgRqRx2NcITkWmTPvYAmc8ffPIyFjRfLEdMSDyxpJN6/luomx36RgWnfg9UHMchsYbgJ8gxOtPsP8BFBHu/T1T3I84/EOVBDr1Qo2h5mU4Op3Y/Wa5w82VcD3Xpkc0mo4QRQBMESGSrj8rVjhFD8f31yPvkvWzfqMjtd1DhURoYnXGvHZt+ygdaomll+MlOWjgPdgbseXh9QanFKvriDSUJk/E2JmAhCIZWjJgyAw+ljhw+AkY8mzLCL+r3G3vhnaUuV6uMur2e7+bqAScyredviAahx/eVp66z6AYi9i2FCexYIflMhia1jlp7cK+yoZMhuRp0QCjfCzx46yuGkplTAMISE9Mt/DpfZkkEl3MUr41CeWTtfwrixhJoYcX9gN0rWKUp9obNDhbl3ks0zBwp0LfXR2tnmLaYFS3ST/dpMN/JAY7YF92nFmD9JjYENmfNHD8p3XgAd/0+OJ+H0NxM1udBLioGIAaZvoYGYXitL2At5BdmQKePM9OgCcbiJypD9r4jVW7qqM6Bs4EdYbYtP1qPxBpXqcz1mUKe6Ki8QUZlioziiBZv2SGvwhNh39rSVy2fyyHoWgMDZC/pLgIg25pYW3ANPsb59wqqnSYxdLxsqVXPrAAdVbu/DUBiXTeJeUYrnhbVKfLp7Ph389lw3Py187HgrE5fT91yWaP5vm8HLbLU0ISufI+EeQy/tMEHw2KhCfL86kU4t2O+Q7xytMt7Bc6jZW7raozNvSSoJmSa4JUi/ZbpmDQNff4jH7eCRWiyRGh+5vUjoeSlSmS1vamZjWqkeuVArkF/nQK5ZQBkk4x/kgwRav
 ugyLMID6
 HHV4PfVprOl82K+gIOZD6Z0mh/l/wZPokYSfdr7ztiKWGLvo60xZvHk3/JavDTT8tPU7unt0oVtx3RtUg1X6fto1oAopCutzphDLY8XghRX4Z6mJFSs7ZaaxsFzRAT/g+fsvPUCLvPUe+j/zZQeH0XzBmtiimgAXkD8qV3OYjqh7ogXqje7UJUr0DDyrEPNoPYC7pSjxg9RLfHvfvQshR8GQe8RN/qWglcTD8hHyvVSopomHtqGdi0hCZxshEcY2fdXivwS2qObFTJkvk+/5IB7eQ6Q==
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
index e710e2789085e..ca530faaa4f83 100644
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
 
 /*
@@ -899,7 +899,7 @@ static unsigned int damon_nr_accesses_to_accesses_bp(
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

